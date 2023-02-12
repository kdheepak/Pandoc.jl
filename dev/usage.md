
<a id='Usage'></a>

<a id='Usage-1'></a>

# Usage


You will need to install [Pandoc](https://github.com/jgm/pandoc). You can install it using your favorite package manager.


To use it in Julia, first add it:


```
(v1.8)> add Pandoc
```


Then you can run the following:


```
julia> using Pandoc
julia> Pandoc.Document("""# header level 1""")
```


You can also load a file from disk:


```
julia> using Pandoc, FilePaths
julia> Pandoc.Document(p"./path/to/markdown_file.md")
```

