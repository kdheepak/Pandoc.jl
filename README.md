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
julia> using Pandoc, FilePaths, Test

julia> doc = Pandoc.Document(p"./test/data/example.md");

julia> @test doc.pandoc_api_version == v"1.23"

julia> @test length(doc.blocks) == 548
```
