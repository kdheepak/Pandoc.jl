"""
    Converter(input = "# header level 1") -> String
    Converter(input = "# header level 1", from="markdown", to="html") -> String

This is a `Converter` options struct.
It supports all of pandoc's command line arguments.

You can use it like so:

```julia
run(Converter(; input = "# Header level 1"))
```
"""
Base.@kwdef mutable struct Converter
  input::Union{String,AbstractPath,Vector{<:AbstractPath},Document}
  from::Union{Nothing,String} = nothing
  to::Union{Nothing,String} = nothing
  output::Union{Nothing,String} = nothing
  defaults::Union{Nothing,String} = nothing
  file_scope::Bool = false
  sandbox::Bool = false
  data_dir::Union{Nothing,String} = nothing
  template::Union{Nothing,String} = nothing
  metadata::Vector{Tuple{String,String}} = Tuple[]
  metadata_file::Union{Nothing,AbstractPath} = nothing
  standalone::Bool = false
  variables::Vector{Tuple{String,String}} = Tuple[]
  wrap::Union{Nothing,String} = nothing
  ascii::Bool = false
  toc::Bool = false
  toc_depth::Union{Nothing,Int} = nothing
  number_sections::Bool = false
  number_offset::Union{Int,Vector{Int}} = Int[]
  top_level_division::Union{Nothing,String} = nothing
  extract_media::Union{Nothing,AbstractPath} = nothing
  resource_path::Union{Nothing,AbstractPath} = nothing
  include_in_header::Vector{<:AbstractPath} = AbstractPath[]
  include_before_body::Vector{<:AbstractPath} = AbstractPath[]
  include_after_body::Vector{<:AbstractPath} = AbstractPath[]
  no_highlight::Bool = false
  highlight_style::Union{Nothing,String,AbstractPath} = nothing
  syntax_definition::Union{Nothing,AbstractPath} = nothing
  dpi::Union{Nothing,Int} = nothing
  eol::Union{Nothing,String} = nothing
  columns::Union{Nothing,Int} = nothing
  preserve_tabs::Bool = false
  tab_stop::Union{Nothing,Int} = nothing
  pdf_engine::Union{Nothing,String} = nothing
  pdf_engine_opt::Union{Nothing,String} = nothing
  reference_doc::Union{Nothing,AbstractPath} = nothing
  self_contained::Bool = false
  embed_resources::Bool = false
  request_header::Vector{Tuple{String,String}} = Tuple[]
  no_check_certificate::Bool = false
  abbreviations::Union{Nothing,AbstractPath} = nothing
  indented_code_classes::Union{Nothing,String} = nothing
  default_image_extension::Union{Nothing,String} = nothing
  filter::Vector{String} = []
  lua_filter::Vector{<:AbstractPath} = AbstractPath[]
  shift_heading_level_by::Union{Nothing,Int} = nothing
  base_header_level::Union{Nothing,Int} = nothing
  track_changes::Union{Nothing,String} = nothing
  strip_comments::Bool = false
  reference_links::Bool = false
  reference_location::Union{Nothing,String} = nothing
  markdown_headings::Union{Nothing,String} = nothing
  list_tables::Bool = false
  listings::Bool = false
  incremental::Bool = false
  slide_level::Union{Nothing,Int} = nothing
  section_divs::Bool = false
  html_q_tags::Bool = false
  email_obfuscation::Union{Nothing,String} = nothing
  id_prefix::Union{Nothing,String} = nothing
  title_prefix::Union{Nothing,String} = nothing
  css::Union{Nothing,String} = nothing
  epub_subdirectory::Union{Nothing,AbstractPath} = nothing
  epub_cover_image::Union{Nothing,AbstractPath} = nothing
  epub_title_page::Union{Nothing,Bool} = nothing
  epub_metadata::Union{Nothing,AbstractPath} = nothing
  epub_embed_font::Union{Nothing,AbstractPath} = nothing
  split_level::Union{Nothing,Int} = nothing
  chunk_template::Union{Nothing,AbstractPath} = nothing
  epub_chapter_level::Union{Nothing,Int} = nothing
  ipynb_output::Union{Nothing,String} = nothing
  citeproc::Bool = false
  bibliography::Union{Nothing,AbstractPath} = nothing
  csl::Union{Nothing,AbstractPath} = nothing
  citation_abbreviations::Union{Nothing,String} = nothing
  natbib::Bool = false
  biblatex::Bool = false
  mathml::Bool = false
  webtex::Union{Nothing,Bool,String} = nothing
  mathjax::Union{Nothing,Bool,String} = nothing
  katex::Union{Nothing,Bool,String} = nothing
  gladtex::Bool = false
  trace::Bool = false
  dump_args::Bool = false
  ignore_args::Bool = false
  verbose::Bool = false
  quiet::Bool = false
  fail_if_warnings::Bool = false
  log::Union{Nothing,String} = nothing
  bash_completion::Bool = false
  list_input_formats::Bool = false
  list_output_formats::Bool = false
  list_extensions::Union{Nothing,Bool,String} = nothing
  list_highlight_languages::Bool = false
  list_highlight_styles::Bool = false
  print_default_template::Union{Nothing,AbstractPath} = nothing
  print_default_data_file::Union{Nothing,AbstractPath} = nothing
  print_highlight_style::Union{Nothing,String,AbstractPath} = nothing
end

function Base.show(io::IO, c::Converter)
  print(io, command(c; p = "pandoc"))
end

function command(c::Converter; p = PANDOC_JL_EXECUTABLE)
  cmd = `$p`
  c.input isa Document && (c.from = "json")
  !isnothing(c.from) && (cmd = `$cmd -f $(c.from)`)
  !isnothing(c.to) && (cmd = `$cmd -t $(c.to)`)
  !isnothing(c.output) && (cmd = `$cmd -o $(c.output)`)
  !isnothing(c.defaults) && (cmd = `$cmd --defaults=$(c.defaults)`)
  c.file_scope && (cmd = `$cmd --file-scope`)
  c.sandbox && (cmd = `$cmd --sandbox`)
  !isnothing(c.data_dir) && (cmd = `$cmd --data-dir=$(c.data_dir)`)
  !isnothing(c.template) && (cmd = `$cmd --template=$(c.template)`)
  !isempty(c.metadata) && (cmd = `$cmd $(join(map(x -> "--metadata=$(x[1]):$(x[2])", c.metadata), " "))`)
  !isnothing(c.metadata_file) && (cmd = `$cmd --metadata-file=$(c.metadata_file)`)
  c.standalone && (cmd = `$cmd --standalone`)
  !isempty(c.variables) && (cmd = `$cmd $(join(map(x -> "-V $(x[1]):$(x[2])", c.variables), " "))`)
  !isnothing(c.wrap) && (cmd = `$cmd --wrap=$(c.wrap)`)
  c.ascii && (cmd = `$cmd --ascii $(c.ascii)`)
  c.toc && (cmd = `$cmd --toc $(c.toc)`)
  !isnothing(c.toc_depth) && (cmd = `$cmd --toc-depth=$(c.toc_depth)`)
  c.number_sections && (cmd = `$cmd --number-sections`)
  !isempty(c.number_offset) && (cmd = `$cmd --number-offset=$(join(c.number_offset, ","))`)
  !isnothing(c.top_level_division) && (cmd = `$cmd --top-level-division=$(c.top_level_division)`)
  !isnothing(c.extract_media) && (cmd = `$cmd --extract-media=$(c.extract_media)`)
  !isnothing(c.resource_path) && (cmd = `$cmd --resource-path=$(c.resource_path)`)
  for include in c.include_in_header
    cmd = `$cmd --include-in-header=$(include)`
  end
  for include in c.include_before_body
    cmd = `$cmd --include-before-body=$(include)`
  end
  for include in c.include_after_body
    cmd = `$cmd --include-after_body=$(include)`
  end
  c.no_highlight && (cmd = `$cmd --no-highlight`)
  !isnothing(c.highlight_style) && (cmd = `$cmd --highlight-style=$(c.highlight_style)`)
  !isnothing(c.syntax_definition) && (cmd = `$cmd --syntax-defintion=$(c.syntax_definition)`)
  !isnothing(c.dpi) && (cmd = `$cmd --dpi=$(c.dpi)`)
  !isnothing(c.eol) && (cmd = `$cmd --eol=$(c.eol)`)
  !isnothing(c.columns) && (cmd = `$cmd --columns=$(c.columns)`)
  c.preserve_tabs && (cmd = `$cmd --preserve-tabs`)
  !isnothing(c.tab_stop) && (cmd = `$cmd --tab_stop=$(c.tab_stop)`)
  !isnothing(c.pdf_engine) && (cmd = `$cmd --pdf-engine=$(c.pdf_engine)`)
  !isnothing(c.pdf_engine_opt) && (cmd = `$cmd --pdf-engine-opt=$(c.pdf_engine_opt)`)
  !isnothing(c.reference_doc) && (cmd = `$cmd --reference-doc=$(c.reference_doc)`)
  c.self_contained && (cmd = `$cmd --self-contained`)
  c.embed_resources && (cmd = `$cmd --embed-resources`)
  !isempty(c.request_header) && (cmd = `$cmd $(join(map(x -> "--request-header $(x[1]):$(x[2])", c.request_header), " "))`)
  c.no_check_certificate && (cmd = `$cmd --no-check-certificate`)
  !isnothing(c.abbreviations) && (cmd = `$cmd --abbreviations=$(c.abbreviations)`)
  !isnothing(c.indented_code_classes) && (cmd = `$cmd --indented-code-classes=$(c.indented_code_classes)`)
  !isnothing(c.default_image_extension) && (cmd = `$cmd --default-image-extension=$(c.default_image_extension)`)
  for filter in c.filter
    cmd = `$cmd --filter=$(c.filter)`
  end
  for lua_filter in c.lua_filter
    cmd = `$cmd -- $(c.lua_filter)`
  end
  !isnothing(c.shift_heading_level_by) && (cmd = `$cmd --shift-heading-level-by=$(c.shift_heading_level_by)`)
  !isnothing(c.base_header_level) && (cmd = `$cmd --base-header-level=$(c.base_header_level)`)
  !isnothing(c.track_changes) && (cmd = `$cmd --track-changes=$(c.track_changes)`)
  c.strip_comments && (cmd = `$cmd --strip-comments`)
  c.reference_links && (cmd = `$cmd --reference_links`)
  !isnothing(c.reference_location) && (cmd = `$cmd --reference-location=$(c.reference_location)`)
  !isnothing(c.markdown_headings) && (cmd = `$cmd --markdown-headings=$(c.markdown_headings)`)
  c.list_tables && (cmd = `$cmd --list-tables`)
  c.listings && (cmd = `$cmd --listings`)
  c.incremental && (cmd = `$cmd --incremental`)
  !isnothing(c.slide_level) && (cmd = `$cmd --slide-level=$(c.slide_level)`)
  c.section_divs && (cmd = `$cmd --section-divs`)
  c.html_q_tags && (cmd = `$cmd --html-q-tags`)
  !isnothing(c.email_obfuscation) && (cmd = `$cmd --email-obfuscation=$(c.email_obfuscation)`)
  !isnothing(c.id_prefix) && (cmd = `$cmd --id-prefix=$(c.id_prefix)`)
  !isnothing(c.title_prefix) && (cmd = `$cmd --title-prefix=$(c.title_prefix)`)
  !isnothing(c.css) && (cmd = `$cmd --css=$(c.css)`)
  !isnothing(c.epub_subdirectory) && (cmd = `$cmd --epub-subdirectory=$(c.epub_subdirectory)`)
  !isnothing(c.epub_cover_image) && (cmd = `$cmd --epub-cover-image=$(c.epub_cover_image)`)
  !isnothing(c.epub_title_page) && (cmd = `$cmd --epub-title-page=$(c.epub_title_page)`)
  !isnothing(c.epub_metadata) && (cmd = `$cmd --epub-metadata=$(c.epub_metadata)`)
  !isnothing(c.epub_embed_font) && (cmd = `$cmd --epub-embed-font=$(c.epub_embed_font)`)
  !isnothing(c.split_level) && (cmd = `$cmd --split-level=$(c.split_level)`)
  !isnothing(c.chunk_template) && (cmd = `$cmd --chunk-template=$(c.chunk_template)`)
  !isnothing(c.epub_chapter_level) && (cmd = `$cmd --epub-chapter-level=$(c.epub_chapter_level)`)
  !isnothing(c.ipynb_output) && (cmd = `$cmd --ipynb-output=$(c.ipynb_output)`)
  c.citeproc && (cmd = `$cmd --citeproc`)
  !isnothing(c.bibliography) && (cmd = `$cmd --bibliography=$(c.bibliography)`)
  !isnothing(c.csl) && (cmd = `$cmd --csl=$(c.csl)`)
  !isnothing(c.citation_abbreviations) && (cmd = `$cmd --citation-abbreviations=$(c.citation_abbreviations)`)
  c.natbib && (cmd = `$cmd --natbib`)
  c.biblatex && (cmd = `$cmd --biblatex`)
  c.mathml && (cmd = `$cmd --mathml`)
  !isnothing(c.webtex) && (cmd = c.webtex == true ? `$cmd --webtex` : `$cmd --webtex $(c.webtex)`)
  !isnothing(c.mathjax) && (cmd = c.mathjax == true ? `$cmd --mathjax` : `$cmd --mathjax $(c.mathjax)`)
  !isnothing(c.katex) && (cmd = c.katex == true ? `$cmd --katex` : `$cmd --katex $(c.katex)`)
  c.gladtex && (cmd = `$cmd --gladtex`)
  c.trace && (cmd = `$cmd --trace`)
  c.dump_args && (cmd = `$cmd --dump-args`)
  c.ignore_args && (cmd = `$cmd --ignore-args`)
  c.verbose && (cmd = `$cmd --verbose`)
  c.quiet && (cmd = `$cmd --quiet`)
  c.fail_if_warnings && (cmd = `$cmd --fail-if-warnings`)
  !isnothing(c.log) && (cmd = `$cmd --log=$(c.log)`)
  c.bash_completion && (cmd = `$cmd --bash-completion`)
  c.list_input_formats && (cmd = `$cmd --list-input-formats`)
  c.list_output_formats && (cmd = `$cmd --list-output-formats`)
  !isnothing(c.list_extensions) && (cmd = c.list_extensions == true ? `$cmd --list_extensions` : `$cmd --list_extensions=$(c.list_extensions)`)
  c.list_highlight_languages && (cmd = `$cmd --list-highlight-languages`)
  c.list_highlight_styles && (cmd = `$cmd --list-highlight-styles`)
  !isnothing(c.print_default_template) && (cmd = `$cmd --print-default-template=$(c.print_default_template)`)
  !isnothing(c.print_default_data_file) && (cmd = `$cmd --print-default-data-file=$(c.print_default_data_file)`)
  !isnothing(c.print_highlight_style) && (cmd = `$cmd --print-highlight-style=$(c.print_highlight_style)`)
  cmd
end

function Base.run(c::Converter)
  cmd = command(c)
  stdin = if c.input isa String
    IOBuffer(c.input)
  elseif c.input isa AbstractPath
    cmd = `$cmd $(c.input)`
    nothing
  elseif c.input isa Vector
    cmd = `$cmd $(join(c.input, " "))`
    nothing
  elseif c.input isa Document
    IOBuffer(JSON3.write(c.input))
  end
  stdout = isnothing(c.output) ? IOBuffer() : nothing
  run(pipeline(cmd; stdin = stdin, stdout = stdout))
  if isnothing(c.output)
    String(take!(stdout))
  else
    read(c.output, String)
  end
end
