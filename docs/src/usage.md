# Usage

### Install

To use it in Julia, first add it:

```
(v1.8)> add Pandoc
```

### Convert Markdown to HTML

```@repl
using Pandoc

run(Pandoc.Converter(input = raw"""
# This is a header level 1

This is a paragraph
""")) |> println
```

### Convert Markdown to Markdown

```@repl
using Pandoc

run(Pandoc.Converter(input = raw"""
# This is a header level 1

This is a paragraph
""", to = "markdown")) |> println
```

### Convert Markdown to LaTeX

```@repl
using Pandoc

run(Pandoc.Converter(input = raw"""
# This is a header level 1

This is a paragraph
""", to = "latex")) |> println
```

### Convert Markdown to JSON

```@repl
using Pandoc

run(Pandoc.Converter(input = raw"""
# This is a header level 1

This is a paragraph
""", to = "json")) |> println
```

### Convert Markdown to `Pandoc.jl`'s Document type

```@repl
using Pandoc

Pandoc.Document(raw"""
# header level 1

This is a paragraph

## header level 2

This is another paragraph
""")
```

### Convert Markdown to Pandoc JSOn

```@repl
using Pandoc

Pandoc.JSON3.write(Pandoc.Document(raw"""
# header level 1

This is a paragraph
"""))
```

### Writing Pandoc Filters in Julia

Let's say you wanted to increment all the headers by 1 level.

```@repl
using Pandoc

doc = Pandoc.Document(raw"""
# header level 1

This is a paragraph.

## header level 2

This is another paragraph.
""")

for block in doc.blocks
  if block isa Pandoc.Header
    block.level += 1
  end
end

run(Pandoc.Converter(input = doc, from="json", to="markdown")) |> println
```

### Using `Pandoc.jl` with `FilePaths`

You can also load a file from disk:

```
julia> using Pandoc, FilePaths

julia> Pandoc.Document(p"./path/to/markdown_file.md")
```
