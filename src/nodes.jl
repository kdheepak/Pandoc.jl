const PandocType = Union{
    Attr,
    Caption,
    Cell,
    ColSpec, # 
    ColWidth, #
    Citation,
    ListAttributes, #
    Row,
    ShortCaption,
    TableBody,
    TableFoot,
    TableHead,
    Target, #
    Element,
    Pair{Vector{Inline}, Vector{Vector{Block}}},
}

Base.getindex(el::PandocType, prop::Symbol) = getproperty(el, prop)
Base.setindex!(el::PandocType, x, prop::Symbol) = setproperty!(el, prop, x)
Base.getindex(doc::Pandoc.Document, idx) = doc.blocks[idx]
Base.setindex!(doc::Pandoc.Document, x, idx) = setindex!(doc, x, idx)

const Key = Union{Int, Symbol}

"""

    rootnode = PDNode(root)

It returns a Node elements from which navigate the document.
"""
mutable struct PDNode{N,P,K}
    node::N
    parent::Union{Nothing, PDNode}
    key::Key
    function PDNode(n, p, k)
        new{typeof(n), typeof(nodevalue(p)), isa(n, Vector) ? Int : Symbol}(n, p, k)
    end
    function PDNode(n::Pandoc.Document, p, k)
        new{typeof(n), typeof(nodevalue(p)), Int}(n, p, k)
    end
end
PDNode(root) = PDNode(root, nothing, 1)

const PDNodeSymbol = PDNode{N,P,Symbol} where {N,P}
const PDNodeInt = PDNode{N,P,Int} where {N,P}

AbstractTrees.nodevalue(n::PDNode) = n.node
AbstractTrees.nodevaluetype(n::PDNode{N,P,K}) where {N,P,K} = N
AbstractTrees.children(n::PDNodeInt) = begin
    ch = PDNode[]
    nv = nodevalue(n)
    for i in eachindex(nv)
        push!(ch, PDNode(nv[i], n, i))
    end
    ch
end
AbstractTrees.children(n::PDNode{Pandoc.Document,Nothing,Int}) = begin
    ch = PDNode[]
    nv = nodevalue(n).blocks
    for i in eachindex(nv)
        push!(ch, PDNode(nv[i], n, i))
    end
    ch
end
AbstractTrees.children(n::PDNodeSymbol) = begin
    ch = PDNode[]
    nv = nodevalue(n)
    for prop in propertynames(nv)
        push!(ch, PDNode(nv[prop], n, prop))
    end
    ch
end
AbstractTrees.parent(n::PDNode) = n.parent
AbstractTrees.ParentLinks(::Type{<:PDNode}) = StoredParents()
AbstractTrees.printnode(io::IO, n::PDNode) = begin
    if isnothing(n.parent)
        print(io, "<", typeof(n).parameters[1], " ROOT>")
    else
        print(io, "<", typeof(n).parameters[1], " <= ", typeof(n).parameters[2], "[", isa(n.key, Int) ? "" : ":", n.key, "]>")
    end
end
Base.show(io::IO, n::PDNode) = begin
    if isnothing(n.parent)
        print(io, "<", typeof(n).parameters[1], " ROOT>")
    else
        print(io, "<", typeof(n).parameters[1], " <= ", typeof(n).parameters[2], "[", isa(n.key, Int) ? "" : ":", n.key, "]>")
    end
end


"""
    clone(el)

Clone element as deatached from parent. 
"""
function clone(el::TreeCursor) end
"""
    collectall(root)

Colects all elements in `root`, including those which are not Pandoc types. It returns a collection of `IndexedCursor`s
"""
function collectall(root::PDNode) 
    collect(PostOrderDFS(root))
end

"""

    elementsbytype(rootnode, type)

Returns all `PDNode{N,P,K}` which types `N <: type`.
"""
function elementsbytype(root::PDNode{N,Nothing,K}, type::Type{<:PandocType}) where {N,K}
    o = PDNode[]
    itr = PostOrderDFS(root)
    for i in itr
        if AbstractTrees.nodevaluetype(i) == type
            push!(o, i)
        end
    end
    o
end

function hasclass(n::PDNode{Attr,P,Symbol}, class::String) where P
    nv = nodevalue(n)
    if in(:classes, propertynames(nv)) 
        return in(class, nv.classes)
    else
        return false
    end
end

function elementsbyclass(root::PDNode, class::String) 
    itr = elementsbytype(root, Attr)
    map(AbstractTrees.parent, filter((el) -> hasclass(el, class) , itr))
end

"""
    elementbyid(root, id)

Returns first Pandoc element which `el.attr.identifier` equals `id`. Returns a IndexedCursor from which 
one can navigate the document.
"""
function elementbyid(root::PDNode, id::String)
    itr = PostOrderDFS(root)
    for i in itr
        if AbstractTrees.nodevaluetype(i) == Attr && nodevalue(i).identifier == id
            return AbstractTrees.parent(i)
        end
    end
    o
end

# |||| WIP This is work in progreess. ||||
# vvvv                                vvvv

function remove!(el::AbstractTrees.IndexedCursor{<:PandocType,Vector}) 
    
end
function addafter!(el::AbstractTrees.IndexedCursor{<:PandocType,Vector}, new) 
    
end
function addbefore!(el::AbstractTrees.IndexedCursor{<:PandocType,Vector}, new) 
    
end

# Methods that act over all nodes
function clear!(crs::AbstractTrees.IndexedCursor{<:PandocType, <:PandocType})
    p = AbstractTrees.parent(crs)
    idx = crs.index
    props = propertynames(nodevalue(p))
    el = typeof(nodevalue(crs))()
    setproperty!(nodevalue(p), props[idx], el)
end

function substitute!(el, new) 
    # el and new must be similar
    p = (nodevalue ∘ parent)(el)
    setproperty!(nodevalue(p), el.key, new)
end