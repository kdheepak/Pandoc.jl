

@testset "test version parser" begin

    @test Pandoc.pandoc_api_version([1]) == v"1.0.0"
    @test Pandoc.pandoc_api_version([1, 2]) == v"1.2"
    @test Pandoc.pandoc_api_version([1, 2, 3]) == v"1.2.3"
    @test Pandoc.pandoc_api_version([1, 2, 3, 4]) == v"1.2.3-4"
    @test Pandoc.pandoc_api_version([1, 2, 3, 4, 5]) == v"1.2.3-4.5"

end

@testset "test conversions" begin

    @test (
           convert(Pandoc.Header, Markdown.Header{1}(Any["Header 1"]))
           ==
           Pandoc.Header(1, Pandoc.Attributes("header-1", [], []), Pandoc.Element[Pandoc.Str("Header"), Pandoc.Space(), Pandoc.Str("1")])
          )

    @test (
           convert(Pandoc.Str, "hello")
           ==
           Pandoc.Str("hello")
          )

    @test (
           convert(Pandoc.Link, Markdown.Link("title", "https://example.com"))
           ==
           Pandoc.Link(
                       Pandoc.Attributes(),
                       Pandoc.Inline[Pandoc.Str("title")],
                       Pandoc.Target("https://example.com", ""),
                      )
          )

    @test (
           convert(Pandoc.Link, Markdown.Link(Any["title"], "https://example.com"))
           ==
           Pandoc.Link(
                       Pandoc.Attributes(),
                       Pandoc.Inline[Pandoc.Str("title")],
                       Pandoc.Target("https://example.com", ""),
                      )
          )


    @test (
           convert(Pandoc.Strong, Markdown.Bold(["bold"]))
           ==
           Pandoc.Strong(Pandoc.Inline[Pandoc.Str("bold")])
          )

    @test (
           convert(Pandoc.Emph, Markdown.Italic(["italic"]))
           ==
           Pandoc.Emph(Pandoc.Inline[Pandoc.Str("italic")])
          )

    @test (
           convert(Pandoc.Para, Markdown.Paragraph(Any["this is a paragraph"]))
           ==
           Pandoc.Para(
                       Pandoc.Inline[
                                     Pandoc.Str("this"),
                                     Pandoc.Space(),
                                     Pandoc.Str("is"),
                                     Pandoc.Space(),
                                     Pandoc.Str("a"),
                                     Pandoc.Space(),
                                     Pandoc.Str("paragraph"),
                                    ]
                      )
          )

    @test (
           convert(Pandoc.HorizontalRule, Markdown.HorizontalRule())
           ==
           Pandoc.HorizontalRule()
          )

    @test (
           convert(Pandoc.LineBreak, Markdown.LineBreak())
           ==
           Pandoc.LineBreak()
          )

    @test (
           convert(Pandoc.BlockQuote, Markdown.BlockQuote(Any[Markdown.Paragraph(Any["this is a paragraph"])]))
           ==
           Pandoc.BlockQuote(
                             Pandoc.Block[
                                          Pandoc.Para(
                                                      Pandoc.Inline[
                                                                    Pandoc.Str("this"),
                                                                    Pandoc.Space(),
                                                                    Pandoc.Str("is"),
                                                                    Pandoc.Space(),
                                                                    Pandoc.Str("a"),
                                                                    Pandoc.Space(),
                                                                    Pandoc.Str("paragraph")
                                                            ],
                                              ),
                                         ]
                            )
          )

    @test (
           convert(Pandoc.CodeBlock, Markdown.Code("x = π \ny = π / 2"))
           ==
           Pandoc.CodeBlock(
                            Pandoc.Attributes("", [""], []),
                            "x = π \ny = π / 2"
                           )
          )

    @test (
           convert(Pandoc.Code, Markdown.Code("x = π"))
           ==
           Pandoc.Code(
                       Pandoc.Attributes("", [""], []),
                       "x = π"
                      )
          )

    @test (
           convert(Pandoc.OrderedList, Markdown.List(Any[Any[Markdown.Paragraph(Any["one"])], Any[Markdown.Paragraph(Any["two"])]], 1, false))
           ==
           Pandoc.OrderedList(
                              Pandoc.ListAttributes(
                                                    1,
                                                    Pandoc.Decimal,
                                                    Pandoc.Period
                                                   ),
                              [
                               [
                                Pandoc.Para(
                                     Pandoc.Inline[Pandoc.Str("one")],
                                    )
                               ],
                               [
                                Pandoc.Para(
                                     Pandoc.Inline[Pandoc.Str("two")],
                                    )
                               ]
                              ]
                             )
          )

    @test (
           convert(Pandoc.Math, Markdown.LaTeX("x = π"))
           ==
           Pandoc.Math(Pandoc.InlineMath, "x = π")
          )

    @test (
           convert(Pandoc.Image, Markdown.Image("./image.png", ""))
           ==
           Pandoc.Image(Pandoc.Attributes(), [], Pandoc.Target("./image.png", ""))
          )

    @test (
           convert(Pandoc.Note, Markdown.Footnote("1", nothing))
           ==
           Pandoc.Note(Pandoc.Block[])
          )
end

@testset "test pandoc parser" begin

    @testset "docbook" begin
        @test typeof(Pandoc.parse_file(joinpath(@__DIR__, "data", "docbook-reader.docbook"))) == Pandoc.Document
    end

    @testset "creole" begin
        @test typeof(Pandoc.parse_file(joinpath(@__DIR__, "data", "creole-reader.txt"))) == Pandoc.Document
    end

    @testset "markdown" begin
        @test typeof(Pandoc.parse_file(joinpath(@__DIR__, "data", "markdown-reader-more.txt"))) == Pandoc.Document
        @test typeof(Pandoc.parse_file(joinpath(@__DIR__, "data", "writer.markdown"))) == Pandoc.Document
    end

    @testset "wiki" begin
        @test typeof(Pandoc.parse_file(joinpath(@__DIR__, "data", "mediawiki-reader.wiki"))) == Pandoc.Document
    end

    @testset "ipynb" begin
        @test typeof(Pandoc.parse_file(joinpath(@__DIR__, "data", "simple.ipynb"))) == Pandoc.Document
    end

    @testset "latex" begin
        @test typeof(Pandoc.parse_file(joinpath(@__DIR__, "data", "latex-reader.latex"))) == Pandoc.Document
    end

    @testset "man" begin
        @test typeof(Pandoc.parse_file(joinpath(@__DIR__, "data", "man-reader.man"))) == Pandoc.Document
    end

    @testset "tables" begin
        @test typeof(Pandoc.parse_file(joinpath(@__DIR__, "data", "pipe-tables.txt"))) == Pandoc.Document
    end
end
