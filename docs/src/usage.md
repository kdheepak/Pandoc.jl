# Usage

You will need to install [Pandoc](https://github.com/jgm/pandoc).
You can install it using your favorite package manager.

To use it in Julia, first add it:

```
(v1.1)> add Pandoc
```

Then you can run the following:

```
julia> using Pandoc
julia> Pandoc.parse("""# header level 1""")
```

You can also load a file from disk:

```
julia> using Pandoc
julia> Pandoc.parse_file("./path/to/markdown_file.md")
```
