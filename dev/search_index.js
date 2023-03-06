var documenterSearchIndex = {"docs":
[{"location":"api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"Modules = [Pandoc]","category":"page"},{"location":"api/#Pandoc.Pandoc","page":"API","title":"Pandoc.Pandoc","text":"Pandoc\n\nPandoc wrapper to read JSON AST from pandoc\n\nSee https://hackage.haskell.org/package/pandoc-types-1.23/docs/Text-Pandoc-Definition.html\n\n\n\n\n\n","category":"module"},{"location":"api/#Pandoc.Attr","page":"API","title":"Pandoc.Attr","text":"Attr: identifier, classes, key-value pairs\n\nidentifier::String\nclasses::Vector{String}\nattributes::Vector{Tuple{String, String}}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.BlockQuote","page":"API","title":"Pandoc.BlockQuote","text":"Block quote (list of blocks)\n\ncontent::Vector{Pandoc.Block}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.BulletList","page":"API","title":"Pandoc.BulletList","text":"Bullet list (list of items, each a list of blocks)\n\ncontent::Vector{Vector{Pandoc.Block}}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Caption","page":"API","title":"Pandoc.Caption","text":"The caption of a table or figure, with optional short caption.\n\ncaption::Pandoc.ShortCaption\ncontent::Vector{Pandoc.Block}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Cell","page":"API","title":"Pandoc.Cell","text":"A table cell.\n\nattr::Pandoc.Attr\nalignment::Pandoc.Alignment.T\nrowspan::Int64\ncolspan::Int64\ncontent::Vector{Pandoc.Block}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Citation","page":"API","title":"Pandoc.Citation","text":"Citation\n\nid::String\nprefix::Vector{Pandoc.Inline}\nsuffix::Vector{Pandoc.Inline}\nmode::Pandoc.CitationMode.T\nnote_num::Int64\nhash::Int64\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Cite","page":"API","title":"Pandoc.Cite","text":"Citation (list of inlines)\n\ncitations::Vector{Pandoc.Citation}\ncontent::Vector{Pandoc.Inline}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Code","page":"API","title":"Pandoc.Code","text":"Inline code (literal)\n\nattr::Pandoc.Attr\ncontent::String\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.CodeBlock","page":"API","title":"Pandoc.CodeBlock","text":"Code block (literal) with attributes\n\nattr::Pandoc.Attr\ncontent::String\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.ColSpan","page":"API","title":"Pandoc.ColSpan","text":"The number of columns occupied by a cell; the width of a cell.\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.ColSpec","page":"API","title":"Pandoc.ColSpec","text":"The specification for a single table column.\n\nalignment::Pandoc.Alignment.T\ncolwidth::Pandoc.ColWidth\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.ColWidth","page":"API","title":"Pandoc.ColWidth","text":"The width of a table column, as a percentage of the text width.\n\nwidth::Union{Float64, Symbol}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Converter","page":"API","title":"Pandoc.Converter","text":"This is a Converter options struct. It supports all of pandoc's command line arguments.\n\nYou can use it like so:\n\njulia> run(Converter(; input = \"# Header level 1\"))\n\"<h1 id=\"header-level-1\">Header level 1</h1>\r\n\"\n\njulia> c = Pandoc.Converter(; input = \"# Header level 1\")\n`pandoc`\n\njulia> c.from = \"markdown\";\n\njulia> c.to = \"rst\";\n\njulia> c\n`pandoc -f markdown -t rst`\n\njulia> run(c)\n\"Header level 1\r\n==============\r\n\"\n\nmutable struct Converter\n\ninput::Union{String, FilePathsBase.AbstractPath, Pandoc.Document, Vector{<:FilePathsBase.AbstractPath}}\nfrom::Union{Nothing, String}\nto::Union{Nothing, String}\noutput::Union{Nothing, String}\ndefaults::Union{Nothing, String}\nfile_scope::Bool\nsandbox::Bool\ndata_dir::Union{Nothing, String}\ntemplate::Union{Nothing, String}\nmetadata::Vector{Tuple{String, String}}\nmetadata_file::Union{Nothing, FilePathsBase.AbstractPath}\nstandalone::Bool\nvariables::Vector{Tuple{String, String}}\nwrap::Union{Nothing, String}\nascii::Bool\ntoc::Bool\ntoc_depth::Union{Nothing, Int64}\nnumber_sections::Bool\nnumber_offset::Union{Int64, Vector{Int64}}\ntop_level_division::Union{Nothing, String}\nextract_media::Union{Nothing, FilePathsBase.AbstractPath}\nresource_path::Union{Nothing, FilePathsBase.AbstractPath}\ninclude_in_header::Vector{<:FilePathsBase.AbstractPath}\ninclude_before_body::Vector{<:FilePathsBase.AbstractPath}\ninclude_after_body::Vector{<:FilePathsBase.AbstractPath}\nno_highlight::Bool\nhighlight_style::Union{Nothing, String, FilePathsBase.AbstractPath}\nsyntax_definition::Union{Nothing, FilePathsBase.AbstractPath}\ndpi::Union{Nothing, Int64}\neol::Union{Nothing, String}\ncolumns::Union{Nothing, Int64}\npreserve_tabs::Bool\ntab_stop::Union{Nothing, Int64}\npdf_engine::Union{Nothing, String}\npdf_engine_opt::Union{Nothing, String}\nreference_doc::Union{Nothing, FilePathsBase.AbstractPath}\nself_contained::Bool\nembed_resources::Bool\nrequest_header::Vector{Tuple{String, String}}\nno_check_certificate::Bool\nabbreviations::Union{Nothing, FilePathsBase.AbstractPath}\nindented_code_classes::Union{Nothing, String}\ndefault_image_extension::Union{Nothing, String}\nfilter::Vector{String}\nlua_filter::Vector{<:FilePathsBase.AbstractPath}\nshift_heading_level_by::Union{Nothing, Int64}\nbase_header_level::Union{Nothing, Int64}\ntrack_changes::Union{Nothing, String}\nstrip_comments::Bool\nreference_links::Bool\nreference_location::Union{Nothing, String}\nmarkdown_headings::Union{Nothing, String}\nlist_tables::Bool\nlistings::Bool\nincremental::Bool\nslide_level::Union{Nothing, Int64}\nsection_divs::Bool\nhtml_q_tags::Bool\nemail_obfuscation::Union{Nothing, String}\nid_prefix::Union{Nothing, String}\ntitle_prefix::Union{Nothing, String}\ncss::Union{Nothing, String}\nepub_subdirectory::Union{Nothing, FilePathsBase.AbstractPath}\nepub_cover_image::Union{Nothing, FilePathsBase.AbstractPath}\nepub_title_page::Union{Nothing, Bool}\nepub_metadata::Union{Nothing, FilePathsBase.AbstractPath}\nepub_embed_font::Union{Nothing, FilePathsBase.AbstractPath}\nsplit_level::Union{Nothing, Int64}\nchunk_template::Union{Nothing, FilePathsBase.AbstractPath}\nepub_chapter_level::Union{Nothing, Int64}\nipynb_output::Union{Nothing, String}\nciteproc::Bool\nbibliography::Union{Nothing, FilePathsBase.AbstractPath}\ncsl::Union{Nothing, FilePathsBase.AbstractPath}\ncitation_abbreviations::Union{Nothing, String}\nnatbib::Bool\nbiblatex::Bool\nmathml::Bool\nwebtex::Union{Nothing, Bool, String}\nmathjax::Union{Nothing, Bool, String}\nkatex::Union{Nothing, Bool, String}\ngladtex::Bool\ntrace::Bool\ndump_args::Bool\nignore_args::Bool\nverbose::Bool\nquiet::Bool\nfail_if_warnings::Bool\nlog::Union{Nothing, String}\nbash_completion::Bool\nlist_input_formats::Bool\nlist_output_formats::Bool\nlist_extensions::Union{Nothing, Bool, String}\nlist_highlight_languages::Bool\nlist_highlight_styles::Bool\nprint_default_template::Union{Nothing, FilePathsBase.AbstractPath}\nprint_default_data_file::Union{Nothing, FilePathsBase.AbstractPath}\nprint_highlight_style::Union{Nothing, String, FilePathsBase.AbstractPath}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.DefinitionList","page":"API","title":"Pandoc.DefinitionList","text":"Definition list. Each list item is a pair consisting of a term (a list of inlines) and one or more definitions (each a list of blocks)\n\ncontent::Vector{Pair{Vector{Pandoc.Inline}, Vector{Vector{Pandoc.Block}}}}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Div","page":"API","title":"Pandoc.Div","text":"Generic block container with attributes\n\nattr::Pandoc.Attr\ncontent::Vector{Pandoc.Block}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Document","page":"API","title":"Pandoc.Document","text":"Document\n\ndata::Dict{Symbol, Any}\npandoc_api_version::VersionNumber\nmeta::Pandoc.MetaValue\nblocks::Vector{Pandoc.Block}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Emph","page":"API","title":"Pandoc.Emph","text":"Emphasized text (list of inlines)\n\ncontent::Vector{Pandoc.Inline}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Figure","page":"API","title":"Pandoc.Figure","text":"Figure\n\nattr::Pandoc.Attr\ncaption::Pandoc.Caption\ncontent::Vector{Pandoc.Block}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Header","page":"API","title":"Pandoc.Header","text":"Header - level (integer) and text (inlines)\n\nlevel::Int64\nattr::Pandoc.Attr\ncontent::Vector{Pandoc.Inline}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.HorizontalRule","page":"API","title":"Pandoc.HorizontalRule","text":"Horizontal rule\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Image","page":"API","title":"Pandoc.Image","text":"Image: alt text (list of inlines), target\n\nattr::Pandoc.Attr\ncontent::Vector{Pandoc.Inline}\ntarget::Pandoc.Target\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.LineBlock","page":"API","title":"Pandoc.LineBlock","text":"Multiple non-breaking lines\n\ncontent::Vector{Vector{Pandoc.Inline}}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.LineBreak","page":"API","title":"Pandoc.LineBreak","text":"Hard line break\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Link","page":"API","title":"Pandoc.Link","text":"Hyperlink: alt text (list of inlines), target\n\nattr::Pandoc.Attr\ncontent::Vector{Pandoc.Inline}\ntarget::Pandoc.Target\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.ListAttributes","page":"API","title":"Pandoc.ListAttributes","text":"List attributes.\n\nThe first element of the triple is the start number of the list.\n\nnumber::Int64\nstyle::Pandoc.ListNumberStyle.T\ndelim::Pandoc.ListNumberDelim.T\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Math","page":"API","title":"Pandoc.Math","text":"TeX math (literal)\n\nmath_type::Pandoc.MathType.T\ncontent::String\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Note","page":"API","title":"Pandoc.Note","text":"Footnote or endnote\n\ncontent::Vector{Pandoc.Block}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.OrderedList","page":"API","title":"Pandoc.OrderedList","text":"Ordered list (attributes and a list of items, each a list of blocks)\n\nattr::Pandoc.ListAttributes\ncontent::Vector{Vector{Pandoc.Block}}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Para","page":"API","title":"Pandoc.Para","text":"Paragraph\n\ncontent::Vector{Pandoc.Inline}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Plain","page":"API","title":"Pandoc.Plain","text":"Plain text, not a paragraph\n\ncontent::Vector{Pandoc.Inline}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Quoted","page":"API","title":"Pandoc.Quoted","text":"Quoted text (list of inlines)\n\nquote_type::Pandoc.QuoteType.T\ncontent::Vector{Pandoc.Inline}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.RawBlock","page":"API","title":"Pandoc.RawBlock","text":"Raw block\n\nformat::String\ncontent::String\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.RawInline","page":"API","title":"Pandoc.RawInline","text":"Raw inline\n\nformat::String\ncontent::String\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Row","page":"API","title":"Pandoc.Row","text":"Row\n\nattr::Pandoc.Attr\ncells::Vector{Pandoc.Cell}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.RowHeadColumns","page":"API","title":"Pandoc.RowHeadColumns","text":"The number of columns taken up by the row head of each row of a 'TableBody'. The row body takes up the remaining columns.\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.RowSpan","page":"API","title":"Pandoc.RowSpan","text":"The number of rows occupied by a cell; the height of a cell.\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.ShortCaption","page":"API","title":"Pandoc.ShortCaption","text":"A short caption, for use in, for instance, lists of figures.\n\ncontent::Union{Nothing, Vector{Pandoc.Inline}}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.SmallCaps","page":"API","title":"Pandoc.SmallCaps","text":"Small caps text (list of inlines)\n\ncontent::Vector{Pandoc.Inline}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.SoftBreak","page":"API","title":"Pandoc.SoftBreak","text":"Soft line break\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Space","page":"API","title":"Pandoc.Space","text":"Inter-word space\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Span","page":"API","title":"Pandoc.Span","text":"Generic inline container with attributes\n\nattr::Pandoc.Attr\ncontent::Vector{Pandoc.Inline}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Str","page":"API","title":"Pandoc.Str","text":"Text (string)\n\ncontent::String\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Strikeout","page":"API","title":"Pandoc.Strikeout","text":"Strikeout text (list of inlines)\n\ncontent::Vector{Pandoc.Inline}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Strong","page":"API","title":"Pandoc.Strong","text":"Strongly emphasized text (list of inlines)\n\ncontent::Vector{Pandoc.Inline}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Subscript","page":"API","title":"Pandoc.Subscript","text":"Subscripted text (list of inlines)\n\ncontent::Vector{Pandoc.Inline}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Superscript","page":"API","title":"Pandoc.Superscript","text":"Superscripted text (list of inlines)\n\ncontent::Vector{Pandoc.Inline}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Table","page":"API","title":"Pandoc.Table","text":"Table, with attributes, caption, optional short caption, column alignments and widths (required), table head, table bodies, and table foot\n\nattr::Pandoc.Attr\ncaption::Pandoc.Caption\ncolspec::Vector{Pandoc.ColSpec}\nhead::Pandoc.TableHead\nbodies::Vector{Pandoc.TableBody}\nfoot::Pandoc.TableFoot\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.TableBody","page":"API","title":"Pandoc.TableBody","text":"A body of a table, with an intermediate head, intermediate body, and the specified number of row header columns in the intermediate body.\n\nattr::Pandoc.Attr\nrowheadcolumns::Int64\nhead::Vector{Pandoc.Row}\ncontent::Vector{Pandoc.Row}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.TableFoot","page":"API","title":"Pandoc.TableFoot","text":"The foot of a table.\n\nattr::Pandoc.Attr\ncontent::Vector{Pandoc.Row}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.TableHead","page":"API","title":"Pandoc.TableHead","text":"The head of a table.\n\nattr::Pandoc.Attr\nrows::Vector{Pandoc.Row}\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Target","page":"API","title":"Pandoc.Target","text":"Link target (URL, title).\n\nurl::String\ntitle::String\n\n\n\n\n\n","category":"type"},{"location":"api/#Pandoc.Underline","page":"API","title":"Pandoc.Underline","text":"Underlined text (list of inlines)\n\ncontent::Vector{Pandoc.Inline}\n\n\n\n\n\n","category":"type"},{"location":"api/#Base.run-Tuple{Pandoc.Converter}","page":"API","title":"Base.run","text":"run(c::Pandoc.Converter) -> String\n\n\nExecute command generated by Converter.\n\nExample\n\njulia> run(Pandoc.Converter(input = \"# header level 1\", from=\"markdown\", to=\"html\"))\n\"<h1 id=\"header-level-1\">header level 1</h1>\r\n\"\n\n\n\n\n\n","category":"method"},{"location":"usage/#Usage","page":"Usage","title":"Usage","text":"","category":"section"},{"location":"usage/#Install","page":"Usage","title":"Install","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"To use it in Julia, first add it:","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"(v1.8)> add Pandoc","category":"page"},{"location":"usage/#Convert-Markdown-to-HTML","page":"Usage","title":"Convert Markdown to HTML","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"using Pandoc\n\nrun(Pandoc.Converter(input = raw\"\"\"\n# This is a header level 1\n\nThis is a paragraph\n\"\"\")) |> println","category":"page"},{"location":"usage/#Convert-Markdown-to-Markdown","page":"Usage","title":"Convert Markdown to Markdown","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"using Pandoc\n\nrun(Pandoc.Converter(input = raw\"\"\"\n# This is a header level 1\n\nThis is a paragraph\n\"\"\", to = \"markdown\")) |> println","category":"page"},{"location":"usage/#Convert-Markdown-to-LaTeX","page":"Usage","title":"Convert Markdown to LaTeX","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"using Pandoc\n\nrun(Pandoc.Converter(input = raw\"\"\"\n# This is a header level 1\n\nThis is a paragraph\n\"\"\", to = \"latex\")) |> println","category":"page"},{"location":"usage/#Convert-Markdown-to-JSON","page":"Usage","title":"Convert Markdown to JSON","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"using Pandoc\n\nrun(Pandoc.Converter(input = raw\"\"\"\n# This is a header level 1\n\nThis is a paragraph\n\"\"\", to = \"json\")) |> println","category":"page"},{"location":"usage/#Convert-Markdown-to-Pandoc.jl's-Document-type","page":"Usage","title":"Convert Markdown to Pandoc.jl's Document type","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"using Pandoc\n\nPandoc.Document(raw\"\"\"\n# header level 1\n\nThis is a paragraph\n\n## header level 2\n\nThis is another paragraph\n\"\"\")","category":"page"},{"location":"usage/#Convert-Markdown-to-Pandoc-JSon","page":"Usage","title":"Convert Markdown to Pandoc JSon","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"using Pandoc\n\nPandoc.JSON3.write(Pandoc.Document(raw\"\"\"\n# header level 1\n\nThis is a paragraph\n\n## header level 2\n\nThis is another paragraph\n\"\"\"))","category":"page"},{"location":"usage/#Writing-Pandoc-Filters-in-Julia","page":"Usage","title":"Writing Pandoc Filters in Julia","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"Let's say you wanted to increment all the headers by 1 level.","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"using Pandoc\n\ndoc = Pandoc.Document(raw\"\"\"\n# header level 1\n\nThis is a paragraph.\n\n## header level 2\n\nThis is another paragraph.\n\"\"\")\n\nfor block in doc.blocks\n  if block isa Pandoc.Header\n    block.level += 1\n  end\nend\n\nrun(Pandoc.Converter(input = doc, from=\"json\", to=\"markdown\")) |> println","category":"page"},{"location":"usage/#Using-Pandoc.jl-with-FilePaths","page":"Usage","title":"Using Pandoc.jl with FilePaths","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"You can also load a file from disk:","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"julia> using Pandoc, FilePaths\n\njulia> Pandoc.Document(p\"./path/to/markdown_file.md\")","category":"page"},{"location":"#Pandoc.jl","page":"Pandoc.jl","title":"Pandoc.jl","text":"","category":"section"},{"location":"","page":"Pandoc.jl","title":"Pandoc.jl","text":"(Image: Status) (Image: Documentation)","category":"page"},{"location":"","page":"Pandoc.jl","title":"Pandoc.jl","text":"Pandoc.jl is a package to make it easier to write filters for Pandoc in Julia.","category":"page"},{"location":"#Install","page":"Pandoc.jl","title":"Install","text":"","category":"section"},{"location":"","page":"Pandoc.jl","title":"Pandoc.jl","text":"To install Pandoc.jl, open the Julia package manager prompt and type:","category":"page"},{"location":"","page":"Pandoc.jl","title":"Pandoc.jl","text":"(v1.8) pkg> add Pandoc","category":"page"},{"location":"#Quick-Start","page":"Pandoc.jl","title":"Quick Start","text":"","category":"section"},{"location":"","page":"Pandoc.jl","title":"Pandoc.jl","text":"julia> using Pandoc","category":"page"},{"location":"","page":"Pandoc.jl","title":"Pandoc.jl","text":"Converter","category":"page"},{"location":"","page":"Pandoc.jl","title":"Pandoc.jl","text":"julia> run(Pandoc.Converter(input = raw\"\"\"\n# This is a header\n\nThis is a paragraph.\n\"\"\")) |> println\n<h1 id=\"this-is-a-header\">This is a header</h1>\n<p>This is a paragraph.</p>","category":"page"},{"location":"","page":"Pandoc.jl","title":"Pandoc.jl","text":"Filter","category":"page"},{"location":"","page":"Pandoc.jl","title":"Pandoc.jl","text":"julia> doc = Pandoc.Document(raw\"\"\"\n# This is a header\n\nThis is a paragraph.\n\"\"\")\n\njulia> for block in doc.blocks\n         if block isa Pandoc.Header\n           block.level += 1\n         end\n       end\n\njulia> run(Pandoc.Converter(input = doc, to=\"markdown\")) |> println\n## This is a header\n\nThis is a paragraph.","category":"page"}]
}
