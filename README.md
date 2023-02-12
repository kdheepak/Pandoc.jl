# Pandoc.jl

[![Build Status](https://travis-ci.com/kdheepak/Pandoc.jl.svg?branch=master)](https://travis-ci.com/kdheepak/Pandoc.jl)
[![Documentation](https://img.shields.io/badge/docs-ready-blue.svg)](https://kdheepak.github.io/Pandoc.jl/stable)

[Pandoc.jl](https://github.com/kdheepak/Pandoc.jl) is a package to allow easier interfacing with [Pandoc](https://github.com/jgm/pandoc).

## Install

To install Pandoc.jl, open the Julia package manager prompt and type:

```julia
(v1.8) pkg> add Pandoc
```

## Quick Start

```julia
julia> using Pandoc, FilePaths, Test

julia> doc = Pandoc.Document(p"./path/to/README.md");

julia> @test doc.pandoc_api_version == v"1.23"
```
