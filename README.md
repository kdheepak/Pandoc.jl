# Pandoc.jl

[![Status](https://img.shields.io/github/actions/workflow/status/kdheepak/Pandoc.jl/test.yml?branch=main)](https://github.com/kdheepak/Pandoc.jl/actions)
[![Documentation](https://img.shields.io/badge/docs-ready-blue.svg)](https://kdheepak.com/Pandoc.jl/)

[Pandoc.jl](https://github.com/kdheepak/Pandoc.jl) is a package to make it easier to write filters for [Pandoc](https://github.com/jgm/pandoc) in Julia.

## Install

To install Pandoc.jl, open the Julia package manager prompt and type:

```julia
(v1.8) pkg> add Pandoc
```

## Quick Start

```julia
julia> using Pandoc
```

**Converter**

```julia
julia> run(Pandoc.Converter(input = raw"""
# This is a header

This is a paragraph.
""")) |> println
<h1 id="this-is-a-header">This is a header</h1>
<p>This is a paragraph.</p>
```

**Filter**

```julia
julia> doc = Pandoc.Document(raw"""
# This is a header

This is a paragraph.
""")

julia> for block in doc.blocks
         if block isa Pandoc.Header
           block.level += 1
         end
       end

julia> run(Pandoc.Converter(input = JSON3.write(doc), from="json", to="markdown"))|> println
## This is a header

This is a paragraph.
```
