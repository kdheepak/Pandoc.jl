__precompile__(true)

"""
    Pandoc

Pandoc wrapper to read JSON AST from `pandoc`

See https://hackage.haskell.org/package/pandoc-types-1.17.5.4/docs/Text-Pandoc-Definition.html
"""
module Pandoc

import JSON
import Markdown

const PANDOC_JL_EXECUTABLE = get(ENV, "PANDOC_JL_EXECUTABLE", "pandoc")

@enum Alignment AlignLeft=1 AlignRight=2 AlignCenter=3 AlignDefault=4
@enum ListNumberStyle DefaultStyle=1 Example=2 Decimal=3 LowerRoman=4 UpperRoman=5 LowerAlpha=6 UpperAlpha=7
@enum ListNumberDelim DefaultDelim=1 Period=2 OneParen=3 TwoParens=4
@enum QuoteType SingleQuote=1 DoubleQuote=2
@enum MathType DisplayMath=1 InlineMath=2
@enum CitationMode AuthorInText=1 SuppressAuthor=2 NormalCitation=3

abstract type Element end

abstract type Inline <: Element end
abstract type Block <: Element end

const Format = String
const TableCell = Vector{Block}

struct Attributes
    identifier::String
    classes::Vector{String}
    attributes::Vector{Pair{String, String}}
end
function Attributes(identifier, classes, attributes::Vector{Any})
    attributes = Pair{String, String}[attr[1] => attr[2] for attr in attributes]
    return Attributes(identifier, classes, attributes)
end
Attributes() = Attributes("", [], [],)

struct Citation
    mode::CitationMode
    prefix::Vector{Inline}
    hash::Int
    id::String
    suffix::Vector{Inline}
    note_number::Int
end

struct ListAttributes
    number::Int
    style::ListNumberStyle
    delim::ListNumberDelim
end

"""Plain text, not a paragraph"""
struct Plain <: Block
    content:: Vector{Inline}
end

"""Paragraph"""
struct Para <: Block
    content::Vector{Inline}
end

"""Multiple non-breaking lines"""
struct LineBlock <: Block
    content::Vector{Vector{Inline}}
end

"""Code block (literal) with attributes"""
struct CodeBlock <: Block
    attr::Attributes
    content::String
end
CodeBlock(content) = CodeBlock(Attributes(), content)

"""Raw block"""
struct RawBlock <: Block
    format::Format
    content::String
end

"""Block quote (list of blocks)"""
struct BlockQuote <: Block
    content::Vector{Block}
end

"""Ordered list (attributes and a list of items, each a list of blocks)"""
struct OrderedList <: Block
    attr::ListAttributes
    content::Vector{Vector{Block}}
end

"""Bullet list (list of items, each a list of blocks)"""
struct BulletList <: Block
    content::Vector{Vector{Block}}
end

"""
Definition list Each list item is a pair consisting of a term (a list of inlines) and one or more definitions (each a list of blocks)"""
struct DefinitionList <: Block
    content::Vector{Pair{Vector{Inline}, Vector{Vector{Block}}}}
end

"""Header - level (integer) and text (inlines)"""
struct Header <: Block
    level::Int
    attr::Attributes
    content::Vector{Element}
end
Header(level) = Header(level, Attributes(), [])
Header(level, content) = Header(level, Attributes(), content)

"""Horizontal rule"""
struct HorizontalRule <: Block end

"""Table, with caption, column alignments (required), relative column widths (0 = default), column headers (each a list of blocks), and rows (each a list of lists of blocks)"""
struct Table <: Block
    content::Vector{Inline}
    alignments::Vector{Alignment}
    widths::Vector{Float64}
    headers::Vector{TableCell}
    rows::Vector{Vector{TableCell}}
end

"""Generic block container with attributes"""
struct Div <: Block
    attr::Attributes
    content::Vector{Block}
end
Div(content) = Div(Attributes(), content)

struct Null <: Block end

struct Target
    url::String
    title::String
end

"""Text (string)"""
struct Str <: Inline
    content::String
end

"""Emphasized text (list of inlines)"""
struct Emph <: Inline
    content::Vector{Inline}
end

"""Strongly emphasized text (list of inlines)"""
struct Strong <: Inline
    content::Vector{Inline}
end

"""Strikeout text (list of inlines)"""
struct Strikeout <: Inline
    content::Vector{Inline}
end

"""Superscripted text (list of inlines)"""
struct Superscript <: Inline
    content::Vector{Inline}
end

"""Subscripted text (list of inlines)"""
struct Subscript <: Inline
    content::Vector{Inline}
end

"""Small caps text (list of inlines)"""
struct SmallCaps <: Inline
    content::Vector{Inline}
end

"""Quoted text (list of inlines)"""
struct Quoted <: Inline
    quote_type::QuoteType
    content::Vector{Inline}
end

"""Citation (list of inlines)"""
struct Cite <: Inline
    citations::Vector{Citation}
    content::Vector{Inline}
end

"""Inline code (literal)"""
struct Code <: Inline
    attr::Attributes
    content::String
end
Code(content) = Code(Attributes(), content)

"""Inter-word space"""
struct Space <: Inline end

"""Soft line break"""
struct SoftBreak <: Inline end

"""Hard line break"""
struct LineBreak <: Inline end

"""TeX math (literal)"""
struct Math <: Inline
    math_type::MathType
    content::String
end

"""Raw inline"""
struct RawInline <: Inline
    format::Format
    content::String
end

"""Hyperlink: alt text (list of inlines), target"""
struct Link <: Inline
    attr::Attributes
    content::Vector{Inline}
    target::Target
end
Link(content, target) = Link(Attributes(), content, target)

"""Image: alt text (list of inlines), target"""
struct Image <: Inline
    attr::Attributes
    content::Vector{Inline}
    target::Target
end
Image(content, target) = Image(Attributes(), content, target)

"""Footnote or endnote"""
struct Note <: Inline
    content::Vector{Block}
end

"""Generic inline container with attributes"""
struct Span <: Inline
    attr::Attributes
    content::Vector{Inline}
end
Span(content) = Span(Attributes(), content)

struct Unknown
    e
    t
end

pandoc_api_version() = v"1.17.5-4"
pandoc_api_version(v) = pandoc_api_version(v, Val(length(v)))
pandoc_api_version(v, length::Val{0}) = error("Version array has to be length > 0 but got `$v` instead")
pandoc_api_version(v, length::Val{1}) = VersionNumber(v[1])
pandoc_api_version(v, length::Val{2}) = VersionNumber(v[1], v[2])
pandoc_api_version(v, length::Val{3}) = VersionNumber(v[1], v[2], v[3])
pandoc_api_version(v, length) = VersionNumber(v[1], v[2], v[3], tuple(v[4:end]...))

mutable struct Document
    data::Dict{String, Any}
    pandoc_api_version::VersionNumber
    meta::Dict{String, Any}
    blocks::Vector{Element}
end

function Document(data)
    pav = pandoc_api_version(data["pandoc-api-version"])
    meta = data["meta"]
    blocks = get_elements(data["blocks"])
    return Document(data, pav, meta, blocks)
end

function get_element(t, e)
    u = Unknown(e, t)
    @warn "Unknown element parsed: $u"
    return u
end

get_element(::Type{Null}, e) = Null()
get_element(::Type{SoftBreak}, e) = SoftBreak()
get_element(::Type{LineBreak}, e) = LineBreak()
get_element(::Type{HorizontalRule}, e) = HorizontalRule()
get_element(::Type{Space}, e) = Space()

get_element(::Type{Str}, e) = Str(e["c"])

function get_element(::Type{LineBlock}, e)
    content = Vector{Inline}[]
    for inlines in e["c"]
        push!(content, Inline[get_element(i) for i in inlines])
    end
    return LineBlock(content)
end

function get_element(::Type{Superscript}, e)
    return Superscript(Inline[get_element(i) for i in e["c"]])
end

function get_element(::Type{Subscript}, e)
    return Subscript(Inline[get_element(i) for i in e["c"]])
end

function get_element(::Type{Note}, e)
    return Note(Block[get_element(i) for i in e["c"]])
end

function get_element(::Type{Math}, e)
    math_type = eval(Symbol(e["c"][1]["t"]))
    content = e["c"][2]::String
    return Math(math_type, content)
end

function get_element(::Type{RawInline}, e)
    format = e["c"][1]::String
    content = e["c"][2]::String
    return RawInline(format, content)
end

function get_element(::Type{RawBlock}, e)
    format = e["c"][1]::String
    content = e["c"][2]::String
    return RawBlock(format, content)
end

function get_element(::Type{Quoted}, e)
    quote_type = eval(Symbol(e["c"][1]["t"]))
    content = Inline[get_element(i) for i in e["c"][2]]
    return Quoted(quote_type, content)
end

function get_element(::Type{Table}, e)
    c = e["c"]

    content = Inline[get_element(i) for i in c[1]]
    alignments = Alignment[ eval(Symbol(a["t"])) for a in c[2] ]
    widths = Float64[w for w in c[3]]
    headers = TableCell[]
    rows = Vector{TableCell}[]

    for blocks in c[4]
        push!(headers, Block[ get_element(b) for b in blocks ])
    end

    for list_of_blocks in c[5]
        row = TableCell[]
        for blocks in list_of_blocks
            push!(row, Block[ get_element(b) for b in blocks ])
        end
        push!(rows, row)
    end

    return Table(content, alignments, widths, headers, rows)
end

function get_element(::Type{Span}, e)
    return Span(
                Attributes(e["c"][1]...),
                Inline[get_element(i) for i in e["c"][2]]
               )
end

function get_element(::Type{Image}, e)
    attr = Attributes(e["c"][1]...)
    content = Inline[get_element(i) for i in e["c"][2]]
    target = Target(e["c"][3]...)
    return Image(attr, content, target)
end

function get_element(::Type{Strikeout}, e)
    return Strikeout(Inline[get_element(i) for i in e["c"]])
end

function get_element(::Type{SmallCaps}, e)
    return SmallCaps(Inline[get_element(i) for i in e["c"]])
end

function get_element(::Type{Strong}, e)
    return Strong(Inline[get_element(i) for i in e["c"]])
end

function get_element(::Type{DefinitionList}, e)
    c = e["c"]
    dl = Vector{Pair{Vector{Inline}, Vector{Vector{Block}}}}( [] )
    for items in c
        vector_blocks = Vector{Block}[]
        for blocks in items[2]
            push!(Block[get_element(b) for b in blocks])
        end
        inlines = Inline[get_element(i) for i in items[1]]
        push!(dl, (inlines => vector_blocks))
    end
    return DefinitionList(dl)
end

function get_element(::Type{Div}, e)
    attr = Attributes(e["c"][1]...)
    blocks = Block[get_element(b) for b in e["c"][2]]
    return Div(attr, blocks)
end

function get_element(::Type{BlockQuote}, e)
    blocks = Block[get_element(b) for b in e["c"]]
    return BlockQuote(blocks)
end

function get_element(::Type{ListAttributes}, e)
    number = e[1]
    style = eval(Symbol(e[2]["t"]))
    delim = eval(Symbol(e[3]["t"]))
    return ListAttributes(number, style, delim)
end

function get_element(::Type{OrderedList}, e)
    attr = get_element(ListAttributes, e["c"][1])
    ol = Vector{Block}[]
    for elements in e["c"][2]
        sol = Block[]
        for element in elements
            el = get_element(element)
            push!(sol, el)
        end
        push!(ol, sol)
    end
    return OrderedList(attr, ol)
end

function get_element(::Type{Citation}, e)
    mode = eval(Symbol(e["citationMode"]["t"]))
    prefix = Inline[get_element(i) for i in e["citationPrefix"]]
    hash = e["citationHash"]::Int
    id = e["citationId"]::String
    suffix = Inline[get_element(i) for i in e["citationSuffix"]]
    note_number = e["citationNoteNum"]::Int
    return Citation(mode, prefix, hash, id, suffix, note_number)
end

function get_element(::Type{Cite}, e)
    citations = Citation[get_element(Citation, c) for c in e["c"][1]]
    inlines = Inline[get_element(i) for i in e["c"][2]]
    return Cite(citations, inlines)
end

function get_element(::Type{Code}, e)
    attr = Attributes(e["c"][1]...)
    content = e["c"][2]
    return Code(attr, content)
end

function get_element(::Type{Plain}, e)
    content = Inline[]
    for se in e["c"]
        push!(content, get_element(se))
    end
    return Plain(content)
end

function get_element(::Type{CodeBlock}, e)
    attr = Attributes(e["c"][1]...)
    content = e["c"][2]::String
    return CodeBlock(attr, content)
end

function get_element(::Type{BulletList}, e)
    bl = Vector{Block}[]
    for elements in e["c"]
        sbl = Block[]
        for element in elements
            el = get_element(element)
            push!(sbl, el)
        end
        push!(bl, sbl)
    end
    return BulletList(bl)
end

function get_element(::Type{Emph}, e)
    return Emph(Element[get_element(se) for se in e["c"]])
end

function get_element(::Type{Para}, e)
    return Para(Element[get_element(se) for se in e["c"]])
end

function get_element(::Type{Link}, e)
    c = e["c"]
    identifier = c[1][1]::String
    classes = String[s for s in c[1][2]]
    attributes = Pair[ (String(k) => String(v)) for (k,v) in c[1][3] ]

    content = Element[]
    for se in c[2]
        push!(content, get_element(se))
    end

    target = Target(c[3][1], c[3][2])

    return Link(Attributes(identifier, classes, attributes), content, target)
end

function get_element(::Type{Header}, e)
    c = e["c"]
    level = c[1]::Int
    identifier = c[2][1]::String
    classes = String[s for s in c[2][2]]
    attributes = Pair[ (String(k) => String(v)) for (k,v) in c[2][3] ]

    content = Element[]
    for se in c[3]
        push!(content, get_element(se))
    end

    return Header(level, Attributes(identifier, classes, attributes), content)
end

get_element(e) = get_element(Val{Symbol(e["t"])}(), e)
get_element(::Val{:Header}, e) = get_element(Header, e)
get_element(::Val{:Link}, e) = get_element(Link, e)
get_element(::Val{:Space}, e) = get_element(Space, e)
get_element(::Val{:Emph}, e) = get_element(Emph, e)
get_element(::Val{:Str}, e) = get_element(Str, e)
get_element(::Val{:Para}, e) = get_element(Para, e)
get_element(::Val{:HorizontalRule}, e) = get_element(HorizontalRule, e)
get_element(::Val{:BulletList}, e) = get_element(BulletList, e)
get_element(::Val{:Plain}, e) = get_element(Plain, e)
get_element(::Val{:Code}, e) = get_element(Code, e)
get_element(::Val{:CodeBlock}, e) = get_element(CodeBlock, e)
get_element(::Val{:LineBreak}, e) = get_element(LineBreak, e)
get_element(::Val{:Cite}, e) = get_element(Cite, e)
get_element(::Val{:BlockQuote}, e) = get_element(BlockQuote, e)
get_element(::Val{:OrderedList}, e) = get_element(OrderedList, e)
get_element(::Val{:DefinitionList}, e) = get_element(DefinitionList, e)
get_element(::Val{:Strong}, e) = get_element(Strong, e)
get_element(::Val{:SmallCaps}, e) = get_element(SmallCaps, e)
get_element(::Val{:Span}, e) = get_element(Span, e)
get_element(::Val{:Strikeout}, e) = get_element(Strikeout, e)
get_element(::Val{:Image}, e) = get_element(Image, e)
get_element(::Val{:Table}, e) = get_element(Table, e)
get_element(::Val{:SoftBreak}, e) = get_element(SoftBreak, e)
get_element(::Val{:Quoted}, e) = get_element(Quoted, e)
get_element(::Val{:RawInline}, e) = get_element(RawInline, e)
get_element(::Val{:RawBlock}, e) = get_element(RawBlock, e)
get_element(::Val{:Math}, e) = get_element(Math, e)
get_element(::Val{:Superscript}, e) = get_element(Superscript, e)
get_element(::Val{:Subscript}, e) = get_element(Subscript, e)
get_element(::Val{:Note}, e) = get_element(Note, e)
get_element(::Val{:LineBlock}, e) = get_element(LineBlock, e)
get_element(::Val{:Div}, e) = get_element(Div, e)
get_element(::Val{:Null}, e) = get_element(Null, e)

function get_elements(blocks)
    elements = Element[]
    for e in blocks
        push!(elements, get_element(e))
    end
    return elements
end

function parse(markdown)
    cmd = pipeline(`echo $markdown`, `$PANDOC_JL_EXECUTABLE -t json`)
    data = read(cmd, String)
    return Document(JSON.parse(data))
end

function parse_file(filename)
    cmd = `$PANDOC_JL_EXECUTABLE -t json $filename`
    data = read(cmd, String)
    return Document(JSON.parse(data))
end

exists() = run(`which $PANDOC_JL_EXECUTABLE`, wait=false) |> success

### Convert

function Base.convert(::Type{Document}, md::Markdown.MD)

    pav = v"1.17.5-4"
    meta = Dict{String, Any}()
    data = Dict{String, Any}()
    blocks = Element[]

    for e in md.content
        push!(blocks, convert(Element, e))
    end

    return Document(data, pav, meta, blocks)

end

Base.convert(::Type{Element}, e::AbstractString) = convert(Str, e)
Base.convert(::Type{Inline}, e::AbstractString) = convert(Str, e)
Base.convert(::Type{Str}, e::AbstractString) = Str(e)

Base.convert(::Type{Element}, e::Markdown.Header) = convert(Header, e)
function Base.convert(::Type{Header}, e::Markdown.Header{V}) where V
    content = Element[]

    for s in split(e.text[1])
        push!(content, convert(Str, s))
        push!(content, Space())
    end
    if length(content) > 0 && content[end] isa Space
        pop!(content) # remove last Space()
    end

    return Header(
        V #= level =#,
        Attributes(
                replace(lowercase(e.text[1]), " " => "-"),
                [],
                []
               ),
        content,
    )
end

function _convert(::Type{Vector{Inline}}, text::AbstractString)
    return content
end

Base.convert(::Type{Element}, e::Markdown.Link) = convert(Link, e)
Base.convert(::Type{Inline}, e::Markdown.Link) = convert(Link, e)
function Base.convert(::Type{Link}, e::Markdown.Link)

    content = Inline[]
    text = if e.text isa AbstractString
        e.text
    else
        length(e.text) > 0 ? e.text[1] : ""
    end
    for s in split(text)
        push!(content, convert(Str, s))
        push!(content, Space())
    end
    pop!(content) # remove last Space()
    target = Target(e.url, "")

    return Link(
                Attributes(),
                content,
                target,
               )
end

Base.convert(::Type{Element}, e::Markdown.Italic) = convert(Emph, e)
Base.convert(::Type{Inline}, e::Markdown.Italic) = convert(Emph, e)
Base.convert(::Type{Emph}, e::Markdown.Italic) = Emph(Inline[i for i in e.text])

Base.convert(::Type{Element}, e::Markdown.Bold) = convert(Strong, e)
Base.convert(::Type{Inline}, e::Markdown.Bold) = convert(Strong, e)
Base.convert(::Type{Strong}, e::Markdown.Bold) = Strong(Inline[i for i in e.text])

Base.convert(::Type{Element}, e::Markdown.Paragraph) = convert(Para, e)
function Base.convert(::Type{T}, e::Markdown.Paragraph) where T<:Union{Para,Plain}
    content = Inline[]
    for c in e.content
        if c isa AbstractString
            for s in split(c)
                push!(content, convert(Str, s))
                push!(content, Space())
            end
            if length(content) > 0 && content[end] isa Space
                pop!(content) # remove last Space()
            end
        else
            push!(content, c)
        end
        push!(content, Space())
    end
    if length(content) > 0 && content[end] isa Space
        pop!(content) # remove last Space()
    end
    return T(content)
end


Base.convert(::Type{Element}, e::Markdown.HorizontalRule) = convert(HorizontalRule, e)
Base.convert(::Type{HorizontalRule}, e::Markdown.HorizontalRule) = HorizontalRule()

Base.convert(::Type{Element}, e::Markdown.LineBreak) = convert(LineBreak, e)
Base.convert(::Type{Inline}, e::Markdown.LineBreak) = convert(LineBreak, e)
Base.convert(::Type{LineBreak}, e::Markdown.LineBreak) = LineBreak()

Base.convert(::Type{Element}, e::Markdown.BlockQuote) = convert(BlockQuote, e)
Base.convert(::Type{Block}, e::Markdown.BlockQuote) = convert(BlockQuote, e)
function Base.convert(::Type{BlockQuote}, e::Markdown.BlockQuote)

    content = Block[]

    for c in e.content
        if c isa Markdown.Paragraph
            push!(content, convert(Para, c))
        else
            push!(content, c)
        end
    end

    return BlockQuote(content)
end

Base.convert(::Type{Element}, e::Markdown.Code) = convert(CodeBlock, e)
Base.convert(::Type{Block}, e::Markdown.Code) = convert(CodeBlock, e)
Base.convert(::Type{CodeBlock}, e::Markdown.Code) = CodeBlock(Attributes("", [e.language], []), e.code)

Base.convert(::Type{Inline}, e::Markdown.Code) = convert(Code, e)
Base.convert(::Type{Code}, e::Markdown.Code) = Code(Attributes("", [e.language], []), e.code)

Base.convert(::Type{Element}, e::Markdown.List) = e.ordered == 1 ? convert(OrderedList, e) : convert(BulletList, e)
Base.convert(::Type{Block}, e::Markdown.List) = e.ordered == 1 ? convert(OrderedList, e) : convert(BulletList, e)

function Base.convert(::Type{BulletList}, e::Markdown.List)
    content = Vector{Block}[]
    for items in e.items
        block = Block[]
        for item in items
            if item isa Markdown.Paragraph
                push!(block, convert(Plain, item))
            else
                push!(block, item)
            end
        end
        push!(content, block)
    end
    return BulletList(content)
end

function Base.convert(::Type{OrderedList}, e::Markdown.List)
    content = Vector{Block}[]
    for items in e.items
        block = Block[]
        for item in items
            if item isa Markdown.Paragraph
                push!(block, convert(Plain, item))
            else
                push!(block, item)
            end
        end
        push!(content, block)
    end
    # always returns list level 1 with Decimal with Period
    return OrderedList(ListAttributes(1, Pandoc.Decimal, Pandoc.Period), content)
end

Base.convert(::Type{Element}, e::Markdown.LaTeX) = convert(Inline, e)
Base.convert(::Type{Inline}, e::Markdown.LaTeX) = convert(Math, e)
Base.convert(::Type{Math}, e::Markdown.LaTeX) = Math(InlineMath, e.formula)

Base.convert(::Type{Inline}, e::Markdown.Image) = convert(Image, e)
Base.convert(::Type{Image}, e::Markdown.Image) = Image(Attributes(), [], Target(e.url, e.alt))

Base.convert(::Type{Element}, e::Markdown.Footnote) = convert(Inline, e)
Base.convert(::Type{Inline}, e::Markdown.Footnote) = convert(Note, e)
function Base.convert(::Type{Note}, e::Markdown.Footnote)
    isnothing(e.text) && return Note([])
    content = Block[]
    for p in e.text
        push!(content, p)
    end
    return Note(content)
end

### overloads

# fallback
compare(x, y) = false

function compare(x::T, y::T) where T
    equality = true
    for fieldname in fieldnames(T)
        equality = equality && ( getfield(x, fieldname) == getfield(y, fieldname) )
    end
    return equality
end

Base.:(==)(x::T, y::T) where T<:Pandoc.Element = compare(x, y)
Base.:(==)(x::Attributes, y::Attributes) = compare(x, y)
Base.:(==)(x::Citation, y::Citation) = compare(x, y)
Base.:(==)(x::ListAttributes, y::ListAttributes) = compare(x, y)
Base.:(==)(x::Target, y::Target) = compare(x, y)

end # module
