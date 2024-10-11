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
  @test v"1.23" <= doc.pandoc_api_version < v"1.24"

  doc = Document(p"./data/example.md")
  @test v"1.23" <= doc.pandoc_api_version < v"1.24"
  @test length(doc.blocks) == 548
  JSON3.read(JSON3.write(doc), Dict)

  doc = Document(p"./data/example.txt")
  @test v"1.23" <= doc.pandoc_api_version < v"1.24"
  @test length(doc.blocks) == 1114
  JSON3.read(JSON3.write(doc), Dict)
end
