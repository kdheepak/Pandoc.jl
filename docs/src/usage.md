# Usage

You will need to install [Pandoc](https://github.com/jgm/pandoc).
You can install it using your favorite package manager.

To use it in Julia, first add it:

```
(v1.8)> add Pandoc
```

Then you can run the following:

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

run(Pandoc.Converter(input = JSON3.write(doc), from="json", to="markdown"))|> println
```

You can also load a file from disk:

```
julia> using Pandoc, FilePaths

julia> Pandoc.Document(p"./path/to/markdown_file.md")
```
