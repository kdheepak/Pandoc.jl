__precompile__(true)

"""
    Pandoc

Pandoc wrapper to read JSON AST from `pandoc`

See https://hackage.haskell.org/package/pandoc-types-1.23/docs/Text-Pandoc-Definition.html
"""
module Pandoc

using Markdown

using EnumX
using FilePathsBase
using FilePathsBase: /
using InlineTest
using JSON3
using StructTypes
using DataStructures

using pandoc_jll

const PANDOC_JL_EXECUTABLE = get(ENV, "PANDOC_JL_EXECUTABLE", pandoc())
const FORMATS =
  Dict{String,String}("md" => "markdown", "markdown" => "markdown", "qmd" => "markdown", "wiki" => "wiki", "tex" => "latex", "latex" => "latex")

@enumx Alignment AlignLeft AlignRight AlignCenter AlignDefault
Alignment.T() = AlignDefault

"""
Style of list numbers.
"""
@enumx ListNumberStyle DefaultStyle Example Decimal LowerRoman UpperRoman LowerAlpha UpperAlpha
ListNumberStyle.T() = DefaultStyle

"""
Delimiter of list numbers.
"""
@enumx ListNumberDelim DefaultDelim Period OneParen TwoParens
ListNumberDelim.T() = DefaultDelim

"""
Type of quotation marks to use in Quoted inline.
"""
@enumx QuoteType SingleQuote DoubleQuote

"""
Type of math element (display or inline).
"""
@enumx MathType DisplayMath InlineMath

@enumx CitationMode AuthorInText SuppressAuthor NormalCitation

@enumx MetaValueType MetaMap MetaList MetaBool MetaString MetaInlines MetaBlocks

abstract type Element end

StructTypes.StructType(::Type{<:Element}) = StructTypes.CustomStruct()

abstract type Inline <: Element end
Inline(i) = StructTypes.constructfrom(Inline, i)
StructTypes.StructType(::Type{Inline}) = StructTypes.AbstractType()
StructTypes.subtypekey(::Type{Inline}) = "t"
StructTypes.subtypes(::Type{Inline}) = (
  Str = Str,
  Emph = Emph,
  Underline = Underline,
  Strong = Strong,
  Strikeout = Strikeout,
  Superscript = Superscript,
  Subscript = Subscript,
  SmallCaps = SmallCaps,
  Quoted = Quoted,
  Cite = Cite,
  Code = Code,
  Space = Space,
  SoftBreak = SoftBreak,
  LineBreak = LineBreak,
  Math = Math,
  RawInline = RawInline,
  Link = Link,
  Image = Image,
  Note = Note,
  Span = Span,
)

abstract type Block <: Element end
Block(b) = StructTypes.constructfrom(Block, b)
StructTypes.StructType(::Type{Block}) = StructTypes.AbstractType()
StructTypes.subtypekey(::Type{Block}) = "t"
StructTypes.subtypes(::Type{Block}) = (
  Plain = Plain,
  Para = Para,
  LineBlock = LineBlock,
  CodeBlock = CodeBlock,
  RawBlock = RawBlock,
  BlockQuote = BlockQuote,
  OrderedList = OrderedList,
  BulletList = BulletList,
  DefinitionList = DefinitionList,
  Header = Header,
  HorizontalRule = HorizontalRule,
  Table = Table,
  Figure = Figure,
  Div = Div,
)

const Format = String
const Text = String
const TableCell = Vector{Block}

"""
Attr: identifier, classes, key-value pairs
"""
Base.@kwdef mutable struct Attr
  identifier::String = ""
  classes::Vector{String} = []
  attributes::Vector{Tuple{String,String}} = []
end
Attr(i, c, a::Vector{Any}) = Attr(i, c, map(x -> (x[1], x[2]), a))
StructTypes.StructType(::Type{Attr}) = StructTypes.CustomStruct()
StructTypes.lower(e::Attr) = [e.identifier, e.classes, [[x1, x2] for (x1, x2) in e.attributes]]

mutable struct Citation
  id::String
  prefix::Vector{Inline}
  suffix::Vector{Inline}
  mode::CitationMode.T
  note_num::Int
  hash::Int
end
function Citation(d::Dict{String,Any})
  mode = if d["citationMode"]["t"] == "AuthorInText"
    CitationMode.AuthorInText
  elseif d["citationMode"]["t"] == "SuppressAuthor"
    CitationMode.SuppressAuthor
  elseif d["citationMode"]["t"] == "NormalCitation"
    CitationMode.NormalCitation
  else
    error("Unknown Citation")
  end
  Citation(d["citationId"], d["citationPrefix"], d["citationSuffix"], mode, d["citationNoteNum"], d["citationHash"])
end
StructTypes.StructType(::Type{Citation}) = StructTypes.CustomStruct()
StructTypes.lower(e::Citation) = OrderedDict([
  "citationId" => e.id,
  "citationPrefix" => e.prefix,
  "citationSuffix" => e.suffix,
  "citationMode" => Dict("t" => e.mode),
  "citationNoteNum" => e.note_num,
  "citationHash" => e.hash,
])

"""
List attributes.

The first element of the triple is the start number of the list.
"""
Base.@kwdef mutable struct ListAttributes
  number::Int = 1
  style::ListNumberStyle.T = ListNumberStyle.T()
  delim::ListNumberDelim.T = ListNumberDelim.T()
end
StructTypes.StructType(::Type{ListAttributes}) = StructTypes.CustomStruct()
StructTypes.lower(e::ListAttributes) = [e.number, Dict("t" => e.style), Dict("t" => e.delim)]
function ListAttributes(d::Dict)
  number, style, delim = d
  style = if style["t"] == "Decimal"
    ListNumberStyle.Decimal
  elseif style["t"] == "LowerRoman"
    ListNumberStyle.LowerRoman
  elseif style["t"] == "UpperRoman"
    ListNumberStyle.UpperRoman
  elseif style["t"] == "LowerAlpha"
    ListNumberStyle.LowerAlpha
  elseif style["t"] == "UpperAlpha"
    ListNumberStyle.UpperAlpha
  else
    error("Unknown $(style["t"])")
  end
  delim = if delim["t"] == "Period"
    ListNumberDelim.Period
  elseif delim["t"] == "OneParen"
    ListNumberDelim.OneParen
  elseif delim["t"] == "TwoParens"
    ListNumberDelim.TwoParens
  else
    error("Unknown $(delim["t"])")
  end
  ListAttributes(number, style, delim)
end

"""
Plain text, not a paragraph
"""
mutable struct Plain <: Block
  content::Vector{Inline}
end
StructTypes.lower(e::Plain) = OrderedDict(["t" => "Plain", "c" => e.content])
StructTypes.constructfrom(::Type{Plain}, d::Dict) = Plain(map(Inline, d["c"]))

"""
Paragraph
"""
mutable struct Para <: Block
  content::Vector{Inline}
end
StructTypes.lower(e::Para) = OrderedDict(["t" => "Para", "c" => e.content])
StructTypes.constructfrom(::Type{Para}, d::Dict) = Para(map(Inline, d["c"]))

"""
Multiple non-breaking lines
"""
mutable struct LineBlock <: Block
  content::Vector{Vector{Inline}}
end
StructTypes.lower(e::LineBlock) = OrderedDict(["t" => "LineBlock", "c" => e.content])
StructTypes.constructfrom(::Type{LineBlock}, d::Dict) = LineBlock(map(Inline, i) for i in d["c"])

"""
Code block (literal) with attributes
"""
mutable struct CodeBlock <: Block
  attr::Attr
  content::Text
end
StructTypes.lower(e::CodeBlock) = OrderedDict(["t" => "CodeBlock", "c" => [e.attr, e.content]])
StructTypes.constructfrom(::Type{CodeBlock}, d::Dict) = CodeBlock(Attr(d["c"][1]...), d["c"][2])

"""
Raw block
"""
mutable struct RawBlock <: Block
  format::Format
  content::Text
end
StructTypes.lower(e::RawBlock) = OrderedDict(["t" => "RawBlock", "c" => [e.format, e.content]])
StructTypes.constructfrom(::Type{RawBlock}, d::Dict) = RawBlock(d["c"]...)

"""
Block quote (list of blocks)
"""
mutable struct BlockQuote <: Block
  content::Vector{Block}
end
StructTypes.lower(e::BlockQuote) = OrderedDict(["t" => "BlockQuote", "c" => e.content])
StructTypes.constructfrom(::Type{BlockQuote}, d::Dict) = BlockQuote(map(Block, d["c"]))

"""
Ordered list (attributes and a list of items, each a list of blocks)
"""
mutable struct OrderedList <: Block
  attr::ListAttributes
  content::Vector{Vector{Block}}
end
StructTypes.lower(e::OrderedList) = OrderedDict(["t" => "OrderedList", "c" => [e.attr, e.content]])
StructTypes.constructfrom(::Type{OrderedList}, d::Dict) = OrderedList(ListAttributes(d["c"][1]...), [map(Block, b) for b in d["c"][2]])

"""
Bullet list (list of items, each a list of blocks)
"""
mutable struct BulletList <: Block
  content::Vector{Vector{Block}}
end
StructTypes.lower(e::BulletList) = OrderedDict(["t" => "BulletList", "c" => e.content])
StructTypes.constructfrom(::Type{BulletList}, d::Dict) = BulletList([map(Block, b) for b in d["c"]])

"""
Definition list. Each list item is a pair consisting of a term (a list of inlines) and one or more definitions (each a list of blocks)
"""
mutable struct DefinitionList <: Block
  content::Vector{Pair{Vector{Inline},Vector{Vector{Block}}}}
end
StructTypes.lower(e::DefinitionList) = OrderedDict(["t" => "DefinitionList", "c" => [[is, bs] for (is, bs) in e.content]])
StructTypes.constructfrom(::Type{DefinitionList}, d::Dict) = DefinitionList(map(d["c"]) do (is, bs)
  is = map(Inline, is)
  bs = [map(Block, b) for b in bs]
  is => bs
end)

"""
Header - level (integer) and text (inlines)
"""
Base.@kwdef mutable struct Header <: Block
  level::Int = 1
  attr::Attr = Attr()
  content::Vector{Inline} = []
end
StructTypes.lower(e::Header) = OrderedDict(["t" => "Header", "c" => [e.level, e.attr, e.content]])
StructTypes.constructfrom(::Type{Header}, d::Dict) = Header(d["c"][1], Attr(d["c"][2]...), map(Inline, d["c"][3]))

"""
Horizontal rule
"""
struct HorizontalRule <: Block end
StructTypes.lower(_::HorizontalRule) = Dict("t" => "HorizontalRule")
StructTypes.constructfrom(::Type{HorizontalRule}, d::Dict) = HorizontalRule()

"""
The width of a table column, as a percentage of the text width.
"""
Base.@kwdef mutable struct ColWidth
  width::Union{Float64,Symbol} = :ColWidthDefault
end
ColWidth(d::Dict) = ColWidth(Symbol(d["t"]))
StructTypes.StructType(::Type{ColWidth}) = StructTypes.CustomStruct()
StructTypes.lower(e::ColWidth) = Dict("t" => "ColWidthDefault") # TODO: fix colwidth serialize

"""
The specification for a single table column.
"""
Base.@kwdef mutable struct ColSpec
  alignment::Alignment.T = Alignment.T()
  colwidth::ColWidth = ColWidth()
end
function ColSpec(d::Vector)
  alignment, colwidth = d
  alignment = if alignment["t"] == "AlignDefault"
    Alignment.AlignDefault
  elseif alignment["t"] == "AlignLeft"
    Alignment.AlignLeft
  elseif alignment["t"] == "AlignRight"
    Alignment.AlignRight
  elseif alignment["t"] == "AlignCenter"
    Alignment.AlignCenter
  end
  ColSpec(alignment, ColWidth(colwidth))
end
StructTypes.StructType(::Type{ColSpec}) = StructTypes.CustomStruct()
StructTypes.lower(e::ColSpec) = [e.alignment, e.colwidth]

"""
The number of rows occupied by a cell; the height of a cell.
"""
const RowSpan = Int

"""
The number of columns occupied by a cell; the width of a cell.
"""
const ColSpan = Int

"""
A table cell.
"""
Base.@kwdef mutable struct Cell
  attr::Attr = Attr()
  alignment::Alignment.T = Alignment.T()
  rowspan::RowSpan = 1
  colspan::ColSpan = 1
  content::Vector{Block} = []
end
function Cell(v::Vector)
  attr, alignment, rowspan, colspan, content = v
  alignment = if alignment["t"] == "AlignDefault"
    Alignment.AlignDefault
  elseif alignment["t"] == "AlignLeft"
    Alignment.AlignLeft
  elseif alignment["t"] == "AlignRight"
    Alignment.AlignRight
  elseif alignment["t"] == "AlignCenter"
    Alignment.AlignCenter
  end
  Cell(Attr(attr...), alignment, rowspan, colspan, map(Block, content))
end
StructTypes.StructType(::Type{Cell}) = StructTypes.CustomStruct()
StructTypes.lower(e::Cell) = [e.attr, e.alignment, e.rowspan, e.colspan, e.content]

Base.@kwdef mutable struct Row
  attr::Attr = Attr()
  cells::Vector{Cell} = []
end
function Row(v::Vector)
  attr, cells = v
  Row(Attr(attr...), map(Cell, cells))
end
StructTypes.StructType(::Type{Row}) = StructTypes.CustomStruct()
StructTypes.lower(e::Row) = [e.attr, e.cells]

"""
The head of a table.
"""
Base.@kwdef mutable struct TableHead
  attr::Attr = Attr()
  rows::Vector{Row} = []
end
function TableHead(d::Vector)
  attr, rows = d
  TableHead(Attr(attr...), map(Row, rows))
end
StructTypes.StructType(::Type{TableHead}) = StructTypes.CustomStruct()
StructTypes.lower(e::TableHead) = [e.attr, e.rows]

"""
The number of columns taken up by the row head of each row of a 'TableBody'. The row body takes up the remaining columns.
"""
const RowHeadColumns = Int

"""
A body of a table, with an intermediate head, intermediate body,
and the specified number of row header columns in the intermediate
body.
"""
Base.@kwdef mutable struct TableBody
  attr::Attr = Attr()
  rowheadcolumns::RowHeadColumns = 0
  head::Vector{Row} = []
  content::Vector{Row} = []
end
function TableBody(d::Vector)
  attr, rowheadcolumns, head, content = d
  TableBody(Attr(attr...), rowheadcolumns, map(Row, head), map(Row, content))
end
StructTypes.StructType(::Type{TableBody}) = StructTypes.CustomStruct()
StructTypes.lower(e::TableBody) = [e.attr, e.rowheadcolumns, e.head, e.content]

"""
The foot of a table.
"""
Base.@kwdef mutable struct TableFoot
  attr::Attr = Attr()
  content::Vector{Row} = []
end
function TableFoot(d::Vector)
  attr, rows = d
  TableFoot(Attr(attr...), map(Row, rows))
end
StructTypes.StructType(::Type{TableFoot}) = StructTypes.CustomStruct()
StructTypes.lower(e::TableFoot) = [e.attr, e.content]

"""
A short caption, for use in, for instance, lists of figures.
"""
Base.@kwdef mutable struct ShortCaption
  content::Union{Nothing,Vector{Inline}} = nothing
end
StructTypes.StructType(::Type{ShortCaption}) = StructTypes.CustomStruct()
StructTypes.lower(e::ShortCaption) = e.content

"""
The caption of a table or figure, with optional short caption.
"""
Base.@kwdef mutable struct Caption
  caption::ShortCaption = ShortCaption()
  content::Vector{Block} = []
end
Caption(_::Nothing, content::Vector{Any}) = Caption(ShortCaption(), map(Block, content))
Caption(caption::Vector{Any}, content::Vector{Any}) = Caption(ShortCaption(map(Inline, caption)), map(Block, content))
StructTypes.StructType(::Type{Caption}) = StructTypes.CustomStruct()
StructTypes.lower(e::Caption) = [e.caption, e.content]

"""
Table, with attributes, caption, optional short caption,
column alignments and widths (required), table head, table
bodies, and table foot
"""
Base.@kwdef mutable struct Table <: Block
  attr::Attr = Attr()
  caption::Caption = Caption()
  colspec::Vector{ColSpec} = []
  head::TableHead = TableHead()
  bodies::Vector{TableBody} = []
  foot::TableFoot = TableFoot()
end
StructTypes.lower(e::Table) = OrderedDict(["t" => "Table", "c" => [e.attr, e.caption, e.colspec, e.head, e.bodies, e.foot]])
function StructTypes.constructfrom(::Type{Table}, d::Dict)
  Table(Attr(d["c"][1]...), Caption(d["c"][2]...), map(ColSpec, d["c"][3]), TableHead(d["c"][4]), map(TableBody, d["c"][5]), TableFoot(d["c"][6]))
end

Base.@kwdef mutable struct Figure <: Block
  attr::Attr = Attr()
  caption::Caption = Caption()
  content::Vector{Block} = []
end
StructTypes.lower(e::Figure) = OrderedDict(["t" => "Figure", "c" => [e.attr, e.caption, e.content]])
StructTypes.constructfrom(::Type{Figure}, d::Dict) = Figure(Attr(d["c"][1]...), Caption(d["c"][2]...), map(Block, d["c"][3]))

"""
Generic block container with attributes
"""
Base.@kwdef mutable struct Div <: Block
  attr::Attr = Attr()
  content::Vector{Block} = []
end
StructTypes.lower(e::Div) = OrderedDict(["t" => "Div", "c" => [e.attr, e.content]])
StructTypes.constructfrom(::Type{Div}, d::Dict) = Div(Attr(d["c"][1]...), map(Block, d["c"][2]))

struct Null <: Block end
StructTypes.lower(_::Null) = Dict("t" => "Null")
StructTypes.constructfrom(::Type{Null}, d::Dict) = Null()

"""
Link target (URL, title).
"""
Base.@kwdef mutable struct Target
  url::Text = ""
  title::Text = ""
end
StructTypes.StructType(::Type{Target}) = StructTypes.CustomStruct()
StructTypes.lower(e::Target) = [e.url, e.title]

"""
Text (string)
"""
Base.@kwdef mutable struct Str <: Inline
  content::Text = ""
end
StructTypes.lower(e::Str) = OrderedDict(["t" => "Str", "c" => e.content])
StructTypes.constructfrom(::Type{Str}, d::Dict) = Str(d["c"])

"""
Emphasized text (list of inlines)
"""
Base.@kwdef mutable struct Emph <: Inline
  content::Vector{Inline} = []
end
StructTypes.lower(e::Emph) = OrderedDict(["t" => "Emph", "c" => e.content])
StructTypes.constructfrom(::Type{Emph}, d::Dict) = Emph(map(Inline, d["c"]))

"""
Underlined text (list of inlines)
"""
Base.@kwdef mutable struct Underline <: Inline
  content::Vector{Inline} = []
end
StructTypes.lower(e::Underline) = OrderedDict(["t" => "Underline", "c" => e.content])
StructTypes.constructfrom(::Type{Underline}, d::Dict) = Underline(map(Inline, d["c"]))

"""
Strongly emphasized text (list of inlines)
"""
Base.@kwdef mutable struct Strong <: Inline
  content::Vector{Inline} = []
end
StructTypes.lower(e::Strong) = OrderedDict(["t" => "Strong", "c" => e.content])
StructTypes.constructfrom(::Type{Strong}, d::Dict) = Strong(map(Inline, d["c"]))

"""
Strikeout text (list of inlines)
"""
Base.@kwdef mutable struct Strikeout <: Inline
  content::Vector{Inline} = []
end
StructTypes.lower(e::Strikeout) = OrderedDict(["t" => "Strikeout", "c" => e.content])
StructTypes.constructfrom(::Type{Strikeout}, d::Dict) = Strikeout(map(Inline, d["c"]))

"""
Superscripted text (list of inlines)
"""
Base.@kwdef mutable struct Superscript <: Inline
  content::Vector{Inline} = []
end
StructTypes.lower(e::Superscript) = OrderedDict(["t" => "Superscript", "c" => e.content])
StructTypes.constructfrom(::Type{Superscript}, d::Dict) = Superscript(map(Inline, d["c"]))

"""
Subscripted text (list of inlines)
"""
Base.@kwdef mutable struct Subscript <: Inline
  content::Vector{Inline} = []
end
StructTypes.lower(e::Subscript) = OrderedDict(["t" => "Subscript", "c" => e.content])
StructTypes.constructfrom(::Type{Subscript}, d::Dict) = Subscript(map(Inline, d["c"]))

"""
Small caps text (list of inlines)
"""
Base.@kwdef mutable struct SmallCaps <: Inline
  content::Vector{Inline} = []
end
StructTypes.lower(e::SmallCaps) = OrderedDict(["t" => "SmallCaps", "c" => e.content])
StructTypes.constructfrom(::Type{SmallCaps}, d::Dict) = SmallCaps(map(Inline, d["c"]))

"""
Quoted text (list of inlines)
"""
Base.@kwdef mutable struct Quoted <: Inline
  quote_type::QuoteType.T
  content::Vector{Inline} = []
end
StructTypes.lower(e::Quoted) = OrderedDict(["t" => "Quoted", "c" => [Dict("t" => e.quote_type), e.content]])
function StructTypes.constructfrom(::Type{Quoted}, d::Dict)
  quote_type, content = d["c"]
  quote_type = if quote_type["t"] == "DoubleQuote"
    QuoteType.DoubleQuote
  elseif quote_type["t"] == "SingleQuote"
    QuoteType.SingleQuote
  else
    error("Unknown $quote_type")
  end
  Quoted(quote_type, map(Inline, content))
end

"""
Citation (list of inlines)
"""
Base.@kwdef mutable struct Cite <: Inline
  citations::Vector{Citation} = []
  content::Vector{Inline} = []
end
StructTypes.lower(e::Cite) = OrderedDict(["t" => "Cite", "c" => [e.citations, e.content]])
StructTypes.constructfrom(::Type{Cite}, d::Dict) = Cite(map(Citation, d["c"][1]), map(Inline, d["c"][2]))

@testset "citation" begin
  Document(raw"""
  [@author]
  """)
end

"""
Inline code (literal)
"""
Base.@kwdef mutable struct Code <: Inline
  attr::Attr = Attr()
  content::Text = ""
end
StructTypes.lower(e::Code) = OrderedDict(["t" => "Code", "c" => [e.attr, e.content]])
StructTypes.constructfrom(::Type{Code}, d::Dict) = Code(Attr(d["c"][1]...), d["c"][2])

"""
Inter-word space
"""
struct Space <: Inline end
StructTypes.lower(_::Space) = OrderedDict("t" => "Space")
StructTypes.constructfrom(::Type{Space}, d::Dict) = Space()

"""
Soft line break
"""
struct SoftBreak <: Inline end
StructTypes.lower(_::SoftBreak) = OrderedDict("t" => "SoftBreak")
StructTypes.constructfrom(::Type{SoftBreak}, d::Dict) = SoftBreak()

"""
Hard line break
"""
struct LineBreak <: Inline end
StructTypes.lower(_::LineBreak) = OrderedDict("t" => "LineBreak")
StructTypes.constructfrom(::Type{LineBreak}, d::Dict) = LineBreak()

"""
TeX math (literal)
"""
Base.@kwdef mutable struct Math <: Inline
  math_type::MathType.T
  content::Text = ""
end
StructTypes.lower(e::Math) = OrderedDict(["t" => "Math", "c" => [e.math_type, e.content]])
function StructTypes.constructfrom(::Type{Math}, d::Dict)
  math_type, content = d["c"]
  math_type = if math_type["t"] == "DisplayMath"
    MathType.DisplayMath
  elseif math_type["t"] == "InlineMath"
    MathType.InlineMath
  else
    error("Unknown $math_type")
  end
  Math(math_type, content)
end

"""
Raw inline
"""
Base.@kwdef mutable struct RawInline <: Inline
  format::Format = ""
  content::Text = ""
end
StructTypes.lower(e::RawInline) = OrderedDict(["t" => "RawInline", "c" => [e.format, e.content]])
StructTypes.constructfrom(::Type{RawInline}, d::Dict) = RawInline(d["c"]...)

"""
Hyperlink: alt text (list of inlines), target
"""
Base.@kwdef mutable struct Link <: Inline
  attr::Attr = Attr()
  content::Vector{Inline} = []
  target::Target = Target()
end
StructTypes.lower(e::Link) = OrderedDict(["t" => "Link", "c" => [e.attr, e.content, e.target]])
StructTypes.constructfrom(::Type{Link}, d::Dict) = Link(Attr(d["c"][1]...), map(Inline, d["c"][2]), Target(d["c"][3]...))

"""
Image: alt text (list of inlines), target
"""
Base.@kwdef mutable struct Image <: Inline
  attr::Attr = Attr()
  content::Vector{Inline} = []
  target::Target = Target()
end
StructTypes.lower(e::Image) = OrderedDict(["t" => "Image", "c" => [e.attr, e.content, e.target]])
StructTypes.constructfrom(::Type{Image}, d::Dict) = Image(Attr(d["c"][1]...), map(Inline, d["c"][2]), Target(d["c"][3]...))

"""
Footnote or endnote
"""
Base.@kwdef mutable struct Note <: Inline
  content::Vector{Block} = []
end
StructTypes.lower(e::Note) = OrderedDict(["t" => "Note", "c" => e.content])
StructTypes.constructfrom(::Type{Note}, d::Dict) = Note(map(Block, d["c"]))

"""
Generic inline container with attributes
"""
Base.@kwdef mutable struct Span <: Inline
  attr::Attr = Attr()
  content::Vector{Inline} = []
end
StructTypes.lower(e::Span) = OrderedDict(["t" => "Span", "c" => [e.attr, e.content]])

struct Unknown
  e::Any
  t::Any
end

abstract type MetaValue end

const MetaValueContent = Union{Dict{String,T},Vector{T},Bool,String,Vector{Inline},Vector{Block}} where {T<:MetaValue}

mutable struct MetaValueData <: MetaValue
  type::MetaValueType.T
  content::MetaValueContent
end
StructTypes.StructType(::Type{MetaValueData}) = StructTypes.CustomStruct()
function StructTypes.lower(e::MetaValueData)
  if e.type == MetaValueType.MetaMap
    e.content
  elseif e.type == MetaValueType.MetaList
    e.content
  elseif e.type == MetaValueType.MetaBool
    e.content
  elseif e.type == MetaValueType.MetaString
    e.content
  elseif e.type == MetaValueType.MetaInlines
    e.content
  elseif e.type == MetaValueType.MetaBlocks
    e.content
  else
    error("Unknown type for MetaValue: $e")
  end
end

MetaValue(data::String) = MetaValueData(MetaValueType.MetaString, data)

function MetaValue(data::Vector)
  d = MetaValue[]
  for v in data
    push!(d, MetaValue(v)) # TODO: support Vector{Inline} and Vector{Block}
  end
  MetaValueData(MetaValueType.MetaList, d)
end

function MetaValue(data::Bool)
  MetaValueData(MetaValueType.MetaBool, data)
end

function MetaValue(data::Dict)
  d = Dict{String,MetaValue}()
  for (k, v) in data
    d[k] = MetaValue(v)
  end
  MetaValueData(MetaValueType.MetaMap, d)
end

Base.@kwdef mutable struct Document
  data::Dict{Symbol,Any} = Dict()
  pandoc_api_version::VersionNumber = v"1.23"
  meta::MetaValue = MetaValue(Dict())
  blocks::Vector{Block} = []
end

StructTypes.StructType(::Type{Document}) = StructTypes.CustomStruct()
function StructTypes.construct(::Type{Document}, d::Dict)
  Document(; pandoc_api_version = VersionNumber(d["pandoc-api-version"]...), meta = MetaValue(d["meta"]), blocks = map(Block, d["blocks"]))
end
StructTypes.lower(e::Document) =
  OrderedDict(["pandoc-api-version" => [e.pandoc_api_version.major, e.pandoc_api_version.minor], "meta" => e.meta, "blocks" => e.blocks])

function Document(data::String)
  iob = IOBuffer()
  run(pipeline(`$PANDOC_JL_EXECUTABLE -f markdown -t json`; stdin = IOBuffer(data), stdout = iob))
  json = String(take!(iob))
  JSON3.read(json, Document)
end

function Document(data::AbstractPath)
  ext = extension(data)
  json = if ext == "json"
    read(data)
  else
    read(`$PANDOC_JL_EXECUTABLE -f $(FORMATS[ext]) -t json $data`, String)
  end
  JSON3.read(json, Document)
end

@testset "document json" begin
  doc = Document("""
 {
    "pandoc-api-version": [1, 23],
    "meta": {},
    "blocks": [],
    "data": {}
 }
 """)
  @test doc.pandoc_api_version == v"1.23"
end

@testset "document path" begin
  doc = Document(Path(joinpath(@__DIR__, "../test/data/writer.markdown")))
  @test doc.pandoc_api_version == v"1.23"
  @test length(doc.blocks) == 239
end

end # module
