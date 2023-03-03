using Test

using Pandoc, FilePathsBase, JSON3

Document = Pandoc.Document

@testset "pandoc" begin
  doc = JSON3.read(
    """
{
   "pandoc-api-version": [1, 23],
   "meta": {},
   "blocks": [],
   "data": {}
}
""",
    Document,
  )
  @test doc.pandoc_api_version == v"1.23"

  doc = Document(p"./data/example.md")
  @test doc.pandoc_api_version == v"1.23"
  @test length(doc.blocks) == 548
  JSON3.read(JSON3.write(doc), Dict)

  doc = Document(p"./data/example.txt")
  @test doc.pandoc_api_version == v"1.23"
  @test length(doc.blocks) == 1114
  JSON3.read(JSON3.write(doc), Dict)
end
