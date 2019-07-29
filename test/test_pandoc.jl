

@testset "test pandoc parser" begin

    @testset "docbook" begin
        @test typeof(Pandoc.run_pandoc(joinpath(@__DIR__, "data", "docbook-reader.docbook"))) == Pandoc.Document
    end

    @testset "creole" begin
        @test typeof(Pandoc.run_pandoc(joinpath(@__DIR__, "data", "creole-reader.txt"))) == Pandoc.Document
    end

    @testset "markdown" begin
        @test typeof(Pandoc.run_pandoc(joinpath(@__DIR__, "data", "markdown-reader-more.txt"))) == Pandoc.Document
    end

    @testset "wiki" begin
        @test typeof(Pandoc.run_pandoc(joinpath(@__DIR__, "data", "mediawiki-reader.wiki"))) == Pandoc.Document
    end

    @testset "ipynb" begin
        @test typeof(Pandoc.run_pandoc(joinpath(@__DIR__, "data", "simple.ipynb"))) == Pandoc.Document
    end

    @testset "latex" begin
        @test typeof(Pandoc.run_pandoc(joinpath(@__DIR__, "data", "latex-reader.latex"))) == Pandoc.Document
    end

    @testset "man" begin
        @test typeof(Pandoc.run_pandoc(joinpath(@__DIR__, "data", "man-reader.man"))) == Pandoc.Document
    end

    @testset "tables" begin
        @test typeof(Pandoc.run_pandoc(joinpath(@__DIR__, "data", "pipe-tables.txt"))) == Pandoc.Document
    end
end
