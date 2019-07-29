

@testset "test pandoc parser" begin

    @testset "docbook" begin

        Pandoc.run_pandoc(joinpath(@__DIR__, "data", "docbook-reader.docbook"))

    end

    @testset "creole" begin

        Pandoc.run_pandoc(joinpath(@__DIR__, "data", "creole-reader.txt"))

    end

    @testset "markdown" begin

        Pandoc.run_pandoc(joinpath(@__DIR__, "data", "markdown-reader-more.txt"))

    end

    @testset "wiki" begin

        Pandoc.run_pandoc(joinpath(@__DIR__, "data", "mediawiki-reader.wiki"))

    end

end
