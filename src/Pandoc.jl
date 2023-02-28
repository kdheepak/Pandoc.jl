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
const FORMATS = Dict{String,String}(
  "md" => "markdown",
  "markdown" => "markdown",
  "qmd" => "markdown",
  "wiki" => "wiki",
  "tex" => "latex",
  "latex" => "latex",
)

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

abstract type Inline <: Element end
function Inline(e::Dict)
  if e["t"] == "Str"
    Str(e["c"])
  elseif e["t"] == "Emph"
    Emph(e["c"])
  elseif e["t"] == "Underline"
    Underline(e["c"])
  elseif e["t"] == "Strong"
    Strong(e["c"])
  elseif e["t"] == "Strikeout"
    Strikeout(e["c"])
  elseif e["t"] == "Superscript"
    Superscript(e["c"])
  elseif e["t"] == "Subscript"
    Subscript(e["c"])
  elseif e["t"] == "SmallCaps"
    SmallCaps(e["c"])
  elseif e["t"] == "Quoted"
    Quoted(e["c"]...)
  elseif e["t"] == "Cite"
    Cite(e["c"]...)
  elseif e["t"] == "Code"
    Code(e["c"]...)
  elseif e["t"] == "Space"
    Space()
  elseif e["t"] == "SoftBreak"
    SoftBreak()
  elseif e["t"] == "LineBreak"
    LineBreak()
  elseif e["t"] == "Math"
    Math(e["c"]...)
  elseif e["t"] == "RawInline"
    RawInline(e["c"]...)
  elseif e["t"] == "Link"
    Link(e["c"]...)
  elseif e["t"] == "Image"
    Image(e["c"]...)
  elseif e["t"] == "Note"
    Note(e["c"])
  elseif e["t"] == "Span"
    Span(e["c"]...)
  else
    error("Not implemented")
  end
end

abstract type Block <: Element end
function Block(e::Dict)
  if e["t"] == "Plain"
    Plain(e["c"])
  elseif e["t"] == "Para"
    Para(map(Inline, e["c"]))
  elseif e["t"] == "LineBlock"
    LineBlock(e["c"]...)
  elseif e["t"] == "CodeBlock"
    CodeBlock(e["c"]...)
  elseif e["t"] == "RawBlock"
    RawBlock(e["c"]...)
  elseif e["t"] == "BlockQuote"
    BlockQuote(e["c"])
  elseif e["t"] == "OrderedList"
    OrderedList(e["c"]...)
  elseif e["t"] == "BulletList"
    BulletList(e["c"])
  elseif e["t"] == "DefinitionList"
    DefinitionList(e["c"])
  elseif e["t"] == "Header"
    Header(e["c"]...)
  elseif e["t"] == "HorizontalRule"
    HorizontalRule()
  elseif e["t"] == "Table"
    Table(e["c"]...)
  elseif e["t"] == "Figure"
    Figure(e["c"]...)
  elseif e["t"] == "Div"
    Div(e["c"]...)
  else
    error("Not implemented for $e")
  end
end

const Format = String
const Text = String
const TableCell = Vector{Block}

"""
Attr: identifier, classes, key-value pairs
"""
Base.@kwdef struct Attr
  identifier::String = ""
  classes::Vector{String} = []
  attributes::Vector{Tuple{String,String}} = []
end
Attr(i, c, a::Vector{Any}) = Attr(i, c, map(x -> (x[1], x[2]), a))

struct Citation
  id::String
  prefix::Vector{Inline}
  suffix::Vector{Inline}
  mode::CitationMode.T
  note_number::Int
  hash::Int
end

"""
List attributes.

The first element of the triple is the start number of the list.
"""
Base.@kwdef struct ListAttributes
  number::Int = 1
  style::ListNumberStyle.T = ListNumberStyle.T()
  delim::ListNumberDelim.T = ListNumberDelim.T()
end
function ListAttributes(number, style::Dict, delim::Dict)
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
struct Plain <: Block
  content::Vector{Inline}
end
Plain(content::Vector{Any}) = Plain(map(Inline, content))

"""
Paragraph
"""
struct Para <: Block
  content::Vector{Inline}
end

"""
Multiple non-breaking lines
"""
struct LineBlock <: Block
  content::Vector{Vector{Inline}}
end

"""
Code block (literal) with attributes
"""
struct CodeBlock <: Block
  attr::Attr
  content::Text
end
CodeBlock(attr::Vector{Any}, content) = CodeBlock(Attr(attr...), content)

"""
Raw block
"""
struct RawBlock <: Block
  format::Format
  content::Text
end

"""
Block quote (list of blocks)
"""
struct BlockQuote <: Block
  content::Vector{Block}
end
BlockQuote(content::Vector{Any}) = BlockQuote(map(Block, content))

"""
Ordered list (attributes and a list of items, each a list of blocks)
"""
struct OrderedList <: Block
  attr::ListAttributes
  content::Vector{Vector{Block}}
end
OrderedList(attr::Vector{Any}, content::Vector{Any}) =
  OrderedList(ListAttributes(attr...), [map(Block, c) for c in content])

"""
Bullet list (list of items, each a list of blocks)
"""
struct BulletList <: Block
  content::Vector{Vector{Block}}
end
BulletList(content::Vector{Any}) = BulletList([map(Block, c) for c in content])

"""
Definition list. Each list item is a pair consisting of a term (a list of inlines) and one or more definitions (each a list of blocks)
"""
struct DefinitionList <: Block
  content::Vector{Pair{Vector{Inline},Vector{Vector{Block}}}}
end
DefinitionList(content::Vector{Any}) = DefinitionList(map(content) do (is, bs)
  is = map(Inline, is)
  bs = [map(Block, b) for b in bs]
  is => bs
end)

"""
Header - level (integer) and text (inlines)
"""
Base.@kwdef struct Header <: Block
  level::Int = 1
  attr::Attr = Attr()
  content::Vector{Inline} = []
end
Header(level, attr, content::Vector{Any}) = Header(level, Attr(attr...), map(Inline, content))

"""
Horizontal rule
"""
struct HorizontalRule <: Block end

"""
The width of a table column, as a percentage of the text width.
"""
Base.@kwdef struct ColWidth
  width::Union{Float64,Symbol} = :ColWidthDefault
end

"""
The specification for a single table column.
"""
Base.@kwdef struct ColSpec
  alignment::Alignment.T = Alignment.T()
  colwidth::ColWidth = ColWidth()
end

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
Base.@kwdef struct Cell
  attr::Attr = Attr()
  alignment::Alignment.T = Alignment.T()
  rowspan::RowSpan = 1
  colspan::ColSpan = 1
  content::Vector{Block} = []
end

Base.@kwdef struct Row
  attr::Attr = Attr()
  cells::Vector{Cell} = []
end

"""
The head of a table.
"""
Base.@kwdef struct TableHead
  attr::Attr = Attr()
  rows::Vector{Row} = []
end

"""
The number of columns taken up by the row head of each row of a 'TableBody'. The row body takes up the remaining columns.
"""
const RowHeadColumns = Int

"""
A body of a table, with an intermediate head, intermediate body,
and the specified number of row header columns in the intermediate
body.
"""
Base.@kwdef struct TableBody
  attr::Attr = Attr()
  rowheadcolumns::RowHeadColumns = 0
  head::Vector{Row} = []
  content::Vector{Row} = []
end

"""
The foot of a table.
"""
Base.@kwdef struct TableFoot
  attr::Attr = Attr()
  content::Vector{Row} = []
end

"""
A short caption, for use in, for instance, lists of figures.
"""
Base.@kwdef struct ShortCaption
  content::Union{Nothing,Vector{Inline}} = nothing
end

"""
The caption of a table or figure, with optional short caption.
"""
Base.@kwdef struct Caption
  caption::ShortCaption = ShortCaption()
  content::Vector{Block} = []
end
Caption(_::Nothing, content::Vector{Any}) = Caption(ShortCaption(), map(Block, content))
Caption(caption::Vector{Any}, content::Vector{Any}) = Caption(ShortCaption(map(Inline, caption)), map(Block, content))

"""
Table, with attributes, caption, optional short caption,
column alignments and widths (required), table head, table
bodies, and table foot
"""
Base.@kwdef struct Table <: Block
  attr::Attr = Attr()
  caption::Caption = Caption()
  colspec::Vector{ColSpec} = []
  head::TableHead = TableHead()
  bodies::Vector{TableBody} = []
  foot::TableFoot = TableFoot()
end

Base.@kwdef struct Figure <: Block
  attr::Attr = Attr()
  caption::Caption = Caption()
  content::Vector{Block} = []
end
Figure(attr::Vector{Any}, caption, content::Vector{Any}) =
  Figure(Attr(attr...), Caption(caption...), map(Block, content))

"""
Generic block container with attributes
"""
Base.@kwdef struct Div <: Block
  attr::Attr = Attr()
  content::Vector{Block} = []
end
Div(attr::Vector{Any}, content::Vector{Any}) = Div(Attr(attr...), map(Block, content))

struct Null <: Block end

"""
Link target (URL, title).
"""
Base.@kwdef struct Target
  url::Text = ""
  title::Text = ""
end

"""
Text (string)
"""
Base.@kwdef struct Str <: Inline
  content::Text = ""
end

"""
Emphasized text (list of inlines)
"""
Base.@kwdef struct Emph <: Inline
  content::Vector{Inline} = []
end
Emph(content::Vector{Any}) = Emph(map(Inline, content))

"""
Underlined text (list of inlines)
"""
Base.@kwdef struct Underline <: Inline
  content::Vector{Inline} = []
end

"""
Strongly emphasized text (list of inlines)
"""
Base.@kwdef struct Strong <: Inline
  content::Vector{Inline} = []
end
Strong(content::Vector{Any}) = Strong(map(Inline, content))

"""
Strikeout text (list of inlines)
"""
Base.@kwdef struct Strikeout <: Inline
  content::Vector{Inline} = []
end
Strikeout(content::Vector{Any}) = Strikeout(map(Inline, content))

"""
Superscripted text (list of inlines)
"""
Base.@kwdef struct Superscript <: Inline
  content::Vector{Inline} = []
end
Superscript(content::Vector{Any}) = Superscript(map(Inline, content))

"""
Subscripted text (list of inlines)
"""
Base.@kwdef struct Subscript <: Inline
  content::Vector{Inline} = []
end
Subscript(content::Vector{Any}) = Subscript(map(Inline, content))

"""
Small caps text (list of inlines)
"""
Base.@kwdef struct SmallCaps <: Inline
  content::Vector{Inline} = []
end
SmallCaps(content::Vector{Any}) = SmallCaps(map(Inline, content))

"""
Quoted text (list of inlines)
"""
Base.@kwdef struct Quoted <: Inline
  quote_type::QuoteType.T
  content::Vector{Inline} = []
end
function Quoted(quote_type::Dict, content::Vector{Any})
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
Base.@kwdef struct Cite <: Inline
  citations::Vector{Citation} = []
  content::Vector{Inline} = []
end
Cite(citations::Vector{Any}, content::Vector{Any}) = Cite(map(Citation, citations), map(Inline, content))

"""
Inline code (literal)
"""
Base.@kwdef struct Code <: Inline
  attr::Attr = Attr()
  content::Text = ""
end
Code(attr::Vector{Any}, content) = Code(Attr(attr...), content)

"""
Inter-word space
"""
struct Space <: Inline end

"""
Soft line break
"""
struct SoftBreak <: Inline end

"""
Hard line break
"""
struct LineBreak <: Inline end

"""
TeX math (literal)
"""
Base.@kwdef struct Math <: Inline
  math_type::MathType.T
  content::Text = ""
end
function Math(math_type::Dict, content)
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
Base.@kwdef struct RawInline <: Inline
  format::Format = ""
  content::Text = ""
end

"""
Hyperlink: alt text (list of inlines), target
"""
Base.@kwdef struct Link <: Inline
  attr::Attr = Attr()
  content::Vector{Inline} = []
  target::Target = Target()
end
Link(attr::Vector{Any}, content::Vector{Any}, target) = Link(Attr(attr...), map(Inline, content), Target(target...))

"""
Image: alt text (list of inlines), target
"""
Base.@kwdef struct Image <: Inline
  attr::Attr = Attr()
  content::Vector{Inline} = []
  target::Target = Target()
end
Image(attr::Vector{Any}, content::Vector{Any}, target) = Image(Attr(attr...), map(Inline, content), Target(target...))

"""
Footnote or endnote
"""
Base.@kwdef struct Note <: Inline
  content::Vector{Block} = []
end
Note(content::Vector{Any}) = Note(map(Block, content))

"""
Generic inline container with attributes
"""
Base.@kwdef struct Span <: Inline
  attr::Attr = Attr()
  content::Vector{Inline} = []
end
Span(attr, content::Vector{Any}) = Span(attr, map(Inline, content))

struct Unknown
  e::Any
  t::Any
end

abstract type MetaValue end

const MetaValueContent = Union{Dict{String,T},Vector{T},Bool,String,Vector{Inline},Vector{Block}} where {T<:MetaValue}

Base.@kwdef struct MetaValueData <: MetaValue
  type::MetaValueType.T
  content::MetaValueContent
end
StructTypes.StructType(::Type{MetaValueData}) = StructTypes.DictType()
function Base.pairs(e::MetaValueData)
  return if e.type == MetaValueType.MetaMap
    Base.pairs(e.content)
  else
    error("Not implemented yet")
  end
end

MetaValue(data::String) = MetaValueData(; type = MetaValueType.MetaString, content = data)

function MetaValue(data::Vector)
  d = MetaValue[]
  for v in data
    push!(d, MetaValue(v)) # TODO: support Vector{Inline} and Vector{Block}
  end
  MetaValueData(; type = MetaValueType.MetaList, content = d)
end

function MetaValue(data::Bool)
  MetaValueData(; type = MetaValueType.MetaBool, content = data)
end

function MetaValue(data::Dict)
  d = Dict{String,MetaValue}()
  for (k, v) in data
    d[k] = MetaValue(v)
  end
  MetaValueData(; type = MetaValueType.MetaMap, content = d)
end

Base.@kwdef mutable struct Document
  data::Dict{Symbol,Any} = Dict()
  pandoc_api_version::VersionNumber = v"1.23"
  meta::MetaValue = MetaValue(Dict())
  blocks::Vector{Block} = []
end

StructTypes.StructType(::Type{Document}) = StructTypes.DictType()
function StructTypes.keyvaluepairs(e::Document)
  OrderedDict([
    "pandoc-api-version" => [e.pandoc_api_version.major, e.pandoc_api_version.minor],
    "meta" => pairs(e.meta),
    "blocks" => [pairs(b) for b in e.blocks],
  ])
end

Document(data::String) = Document(JSON3.read(data, Dict))

function Document(data::Markdown.MD)
  data = string(data)
  iob = IOBuffer()
  run(pipeline(`$PANDOC_JL_EXECUTABLE -f markdown -t json`; stdin = IOBuffer(data), stdout = iob))
  json = String(take!(iob))
  dict = JSON3.read(json, Dict)
  Document(dict)
end

function Document(data::Dict)
  blocks = map(data["blocks"]) do e
    Block(e)
  end
  Document(; pandoc_api_version = VersionNumber(data["pandoc-api-version"]...), meta = MetaValue(data["meta"]), blocks)
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

function Document(data::AbstractPath)
  ext = extension(data)
  data = if ext == "json"
    JSON3.read(read(data), Dict)
  else
    JSON3.read(read(`$PANDOC_JL_EXECUTABLE -f $(FORMATS[ext]) -t json $data`, String), Dict)
  end
  Document(data)
end

@testset "document path" begin
  doc = Document(Path(joinpath(@__DIR__, "../test/data/writer.markdown")))
  @test doc.pandoc_api_version == v"1.23"
  @test length(doc.blocks) == 239
end

end # module
