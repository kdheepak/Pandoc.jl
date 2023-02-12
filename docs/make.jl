using Documenter, Pandoc

cp(joinpath(@__DIR__, "../README.md"), joinpath(@__DIR__, "./src/index.md"); force = true, follow_symlinks = true)

makedocs(; sitename = "Pandoc.jl")

deploydocs(; repo = "github.com/kdheepak/Pandoc.jl.git")
