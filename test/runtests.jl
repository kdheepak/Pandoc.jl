using Test

using Pandoc, FilePathsBase, JSON3

Document = Pandoc.Document

@testset "pandoc" begin
  @test JSON3.write(Pandoc.Document(raw"""
  [@author]
  """)) ==
        raw"""{"pandoc-api-version":[1,23],"meta":{},"blocks":[{"t":"Para","c":[{"t":"Cite","c":[[{"citationId":"author","citationPrefix":[],"citationSuffix":[],"citationMode":{"t":"NormalCitation"},"citationNoteNum":1,"citationHash":0}],[{"t":"Str","c":"[@author]"}]]}]}]}"""

  doc = Document("""
 {
    "pandoc-api-version": [1, 23],
    "meta": {},
    "blocks": [],
    "data": {}
 }
 """)
  @test doc.pandoc_api_version == v"1.23"

  doc = Document(p"./data/writer.markdown")
  @test doc.pandoc_api_version == v"1.23"
  @test length(doc.blocks) == 239
end
