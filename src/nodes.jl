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
    rootnode = PandocNode(root)

It returns a node element from which navigate the document.
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

Returns all `PandocNode{N}` which types `N <: type`.
"""
function elementsbytype(root::PandocNode{Document}, type::Type{<:Union{_PandocAll,Block,Inline,Element}})
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
""" 
    clear!(n)

Clears the node `n` from the tree. If its parent is a vector, it 
removes the element. If its parent is a Pandoc element, it clears 
all values. It doesn't work with all elements.
"""
function clear!(n::PandocNode)
    pv = nodevalue(parent(n))
    if isa(n.key, Symbol)
        setproperty!(pv, n.key, N())
    else
        deleteat!(pv, n.key)
    end
    nothing
end
""" 
    substitute!(n, new)

Substitutes the node `n` by the element `new`.
"""
function substitute!(n::PandocNode, new) 
    pv = nodevalue(parent(n))
    if isa(n.key, Symbol)
        setproperty!(pv, n.key, new)
    else
        setindex!(pv, new, n.key)
    end
    nothing
end
""" 
    addafter!(n, new)

Adds the element `new` after the node `n`.
"""
function addafter!(n::PandocNode, new) 
    isa(n.key, Symbol) && error("Cannot add a new element if parent is not a vector!")
    pv = nodevalue(parent(n))
    splice!(pv, n.key, [n.node, new])
    nothing
end
""" 
    addbefore!(n, new)

Adds the element `new` before the node `n`.
"""
function addbefore!(n::PandocNode, new) 
    isa(n.key, Symbol) && error("Cannot add a new element if parent is not a vector!")
    pv = nodevalue(parent(n))
    splice!(pv, n.key, [new, n.node])
    nothing
end
"""
    hasclass(n, class)

Checks wheter a node `n` has a class `class`.  
"""
function hasclass(n::PandocNode{<:_PandocWithAttr}, class)
    classes = nodevalue(n).attr.classes
    in(class, classes)
end
"""
    addclass!(n, class)

Adds a class `class` to `n` if it's not already.
"""
function addclass!(n::PandocNode{<:_PandocWithAttr}, class)
    classes = nodevalue(n).attr.classes
    in(class, classes) && return nothing
    push!(classes, class)
    nothing
end
"""
    removeclass!(n, class)

Removes all classes `class` from `n`.
"""
function removeclass!(n::PandocNode{<:_PandocWithAttr}, class)
    classes = nodevalue(n).attr.classes
    filter!((c) -> !isequal(c,class), classes)
    nothing
end
"""
    getattr(n, attr_name)

Returns the value of the attribute `attr_name` for the node `n`, if any.
"""
function getattr(n::PandocNode{<:_PandocWithAttr}, attr_name::String)
    attrs = nodevalue(n).attr.attributes
    for i in eachindex(attrs)
        attrs[1] == attr_name && return attrs[2]
    end
    nothing
end
"""
    addattr!(n, {name, value})

Adds attribure `{name, value}` to the node `n`.
"""
function addattr!(n::PandocNode{<:_PandocWithAttr}, attr::Tuple{String, String})
    attrs = nodevalue(n).attr.attributes
    for a in attrs
        a[1] == attr[1] && error("Attribute already in use. Try to remove it first with `removeattr!`.")
    end
    push!(attrs, attr)
    nothing
end
"""
    removeattr!(n, attr_name)

Removes the value of the attribute `attr_name` for the node `n`, if any.
"""
function removeattr!(n::PandocNode{<:_PandocWithAttr}, attr_name::String)
    attrs = nodevalue(n).attr.attributes
    filter!((a) -> !isequal(a[1], attr_name) , attrs)
    nothing
end