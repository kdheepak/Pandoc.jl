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

include("interface.jl")
include("types.jl")

end # module
