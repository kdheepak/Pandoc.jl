using Documenter, Pandoc, DocumenterMarkdown

cp(joinpath(@__DIR__, "../README.md"), joinpath(@__DIR__, "./src/index.md"); force = true, follow_symlinks = true)

makedocs(; sitename = "Pandoc.jl documentation", format = Markdown())

deploydocs(; repo = "github.com/kdheepak/Pandoc.jl.git")
