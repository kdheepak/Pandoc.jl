

@testset "test version parser" begin

    @test Pandoc.pandoc_api_version([1]) == v"1.0.0"
    @test Pandoc.pandoc_api_version([1, 2]) == v"1.2"
    @test Pandoc.pandoc_api_version([1, 2, 3]) == v"1.2.3"
    @test Pandoc.pandoc_api_version([1, 2, 3, 4]) == v"1.2.3-4"
    @test Pandoc.pandoc_api_version([1, 2, 3, 4, 5]) == v"1.2.3-4.5"

end

@testset "test pandoc parser" begin

    @testset "docbook" begin
        @test typeof(Pandoc.run(joinpath(@__DIR__, "data", "docbook-reader.docbook"))) == Pandoc.Document
    end

    @testset "creole" begin
        @test typeof(Pandoc.run(joinpath(@__DIR__, "data", "creole-reader.txt"))) == Pandoc.Document
    end

    @testset "markdown" begin
        @test typeof(Pandoc.run(joinpath(@__DIR__, "data", "markdown-reader-more.txt"))) == Pandoc.Document
        @test typeof(Pandoc.run(joinpath(@__DIR__, "data", "writer.markdown"))) == Pandoc.Document
    end

    @testset "wiki" begin
        @test typeof(Pandoc.run(joinpath(@__DIR__, "data", "mediawiki-reader.wiki"))) == Pandoc.Document
    end

    @testset "ipynb" begin
        @test typeof(Pandoc.run(joinpath(@__DIR__, "data", "simple.ipynb"))) == Pandoc.Document
    end

    @testset "latex" begin
        @test typeof(Pandoc.run(joinpath(@__DIR__, "data", "latex-reader.latex"))) == Pandoc.Document
    end

    @testset "man" begin
        @test typeof(Pandoc.run(joinpath(@__DIR__, "data", "man-reader.man"))) == Pandoc.Document
    end

    @testset "tables" begin
        @test typeof(Pandoc.run(joinpath(@__DIR__, "data", "pipe-tables.txt"))) == Pandoc.Document
    end
end
