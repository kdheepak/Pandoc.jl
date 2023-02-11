using Test

using Pandoc
const Markdown = Pandoc.Markdown
using Markdown

BASE_DIR = abspath(joinpath(dirname(Base.find_package("Pandoc")), ".."))
