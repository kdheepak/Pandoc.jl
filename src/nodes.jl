# pandocnodetypes = [Attr, BlockQuote, BulletList, Caption, Cell, Citation, Cite, Code, CodeBlock, ColSpec, DefinitionList, Div, Emph, Figure, Header, HorizontalRule, Image, LineBlock, LineBreak, Link, ListAttributes, Math, Note, Null, OrderedList, Para, Plain, Quoted, RawBlock, RawInline, Row, ShortCaption, SmallCaps, SoftBreak, Space, Span, Str, Strikeout, Strong, Subscript, Superscript, Table, TableBody, TableFoot, TableHead, Target, Underline, Unknown, Vector{Inline}, Vector{Block}, Vector{Vector{Block}}, Pair{Vector{Inline},Vector{Vector{Block}}}, Vector{Pair{Vector{Inline},Vector{Vector{Block}}}}]

"Types without children"
const _PandocLeaf = Union{
    Attr,
    ColSpec,
    HorizontalRule,
    LineBlock,
    LineBreak,
    ListAttributes,
    Math,
    Null,
    RawBlock,
    RawInline,
    ShortCaption,
    SoftBreak,
    Space,
    Str,
    Target,
    Unknown
}

"Types with Attr at `:attr` field"
const _PandocWithAttr = Union{
    Cell,
    Code,
    CodeBlock,
    Div,
    Figure,
    Header,
    Image,
    Link,
    Row,
    Span,
    Table,
    TableBody,
    TableFoot,
    TableHead
}

"Vector types"
const _PandocVector = Union{
    Vector{Inline},
    Vector{Block},
    Vector{Vector{Block}},
    Vector{Pair{Vector{Inline}, Vector{Vector{Block}}}}
}

"Rest of the types that will promote to NoteType"
const _PandocRestOfTypes = Union{
    BlockQuote,
    BulletList,
    Caption,
    Citation,
    Cite,
    DefinitionList,
    Emph,
    Note,
    OrderedList,
    Para,
    Plain,
    Quoted,
    SmallCaps,
    Strikeout,
    Strong,
    Subscript,
    Superscript,
    Underline,
    Pair{Vector{Inline}, Vector{Vector{Block}}}
}

const _PandocBranch = Union{_PandocRestOfTypes, _PandocVector, _PandocWithAttr}
const _PandocAll = Union{_PandocLeaf, _PandocRestOfTypes, _PandocVector, _PandocWithAttr}

const Key = Union{Int, Symbol}

"""

    rootnode = PDNode(root)

It returns a Node elements from which navigate the document.
"""
abstract type PandocNode{N} end
mutable struct PandocStructNode{N} <: PandocNode{N}
    node::N
    parent::Union{Nothing,PandocNode}
    key::Key
    function PandocStructNode(n,p,k)
        new{typeof(n)}(n,p,k)
    end
end
struct PandocVectorNode{N} <: PandocNode{N}
    node::N
    parent::Union{Nothing,PandocNode}
    key::Key
    function PandocVectorNode(n,p,k)
        new{typeof(n)}(n,p,k)
    end
end
PandocNode(doc::Document) = PandocVectorNode(doc, nothing, 1)
PandocNode(n::_PandocVector, p, k) = PandocVectorNode(n, p, k)
PandocNode(n::Union{_PandocLeaf,_PandocWithAttr,_PandocRestOfTypes}, p, k) = PandocStructNode(n, p, k)

AbstractTrees.nodevalue(n::PandocNode) = n.node
AbstractTrees.nodevaluetype(::PandocNode{N}) where {N} = N
AbstractTrees.parent(n::PandocNode) = n.parent
AbstractTrees.children(n::PandocVectorNode) = begin
    ch = PandocNode[]
    nv = nodevalue(n)
    for i in eachindex(nv)
        push!(ch, PandocNode(nv[i], n, i))
    end
    ch
end
AbstractTrees.children(n::PandocStructNode) = begin
    ch = PandocNode[]
    nv = nodevalue(n)
    for prop in propertynames(nv)
        new = getproperty(nv, prop)
        if isa(new, _PandocAll)
            push!(ch, PandocNode(new, n, prop))
        end
    end
    ch
end
AbstractTrees.children(n::PandocVectorNode{Document}) = begin
    ch = PandocNode[]
    nv = nodevalue(n).blocks
    for i in eachindex(nv)
        push!(ch, PandocNode(nv[i], n, i))
    end
    ch
end
AbstractTrees.ParentLinks(::Type{<:PandocNode}) = StoredParents()
AbstractTrees.printnode(io::IO, n::PandocNode) = begin
    if isnothing(n.parent)
        print(io, "<", typeof(n).parameters[1], " ROOT>")
    else
        print(io, "<", typeof(n).parameters[1], " <= ", typeof(n.parent).parameters[1], "[", isa(n.key, Int) ? "" : ":", n.key, "]>")
    end
end
Base.show(io::IO, n::PandocNode) = begin
    if isnothing(n.parent)
        print(io, "<", typeof(n).parameters[1], " ROOT>")
    else
        print(io, "<", typeof(n).parameters[1], " <= ", typeof(n.parent).parameters[1], "[", isa(n.key, Int) ? "" : ":", n.key, "]>")
    end
end

"""
    collectall(root)

Colects all elements in `root`, including those which are not Pandoc types. It returns a collection of `IndexedCursor`s
"""
function collectall(root::PandocNode) 
    collect(PreOrderDFS(root))
end

"""

    elementsbytype(rootnode, type)

Returns all `PDNode{N,P,K}` which types `N <: type`.
"""
function elementsbytype(root::PandocNode{Document}, type::Type{<:_PandocAll})
    o = PandocNode[]
    itr = PostOrderDFS(root)
    for i in itr
        if isa(nodevalue(i), type)
            push!(o, i)
        end
    end
    o
end

function elementsbyclass(root::PandocNode, class::String) 
    itr = elementsbytype(root, _PandocWithAttr)
    filter((n) -> in(class, nodevalue(n).attr.classes) , itr)
end

"""
    elementbyid(root, id)

Returns first Pandoc element which `el.attr.identifier` equals `id`. Returns a IndexedCursor from which 
one can navigate the document.
"""
function elementbyid(root::PandocNode, id::String)
    itr = elementsbytype(root, _PandocWithAttr)
    for i in itr
        if nodevalue(i).attr.identifier == id
            return i
        end
    end
end

# |||| WIP This is work in progreess. ||||
# vvvv                                vvvv

function clear!(el::PandocNode) 
    
end

function substitute!(el::PandocNode, new) 
    
end

function addafter!(el::PandocNode, new) 
    
end

function addbefore!(el::PandocNode, new) 
    
end

"""true or false"""
function hasclass end

"""Return the value of the attribute or nothing"""
function getattr end

function addclass! end

function removeclass! end

function addattr! end

function removeattr! end