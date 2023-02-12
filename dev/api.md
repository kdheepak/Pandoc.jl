
<a id='API'></a>

<a id='API-1'></a>

# API

<a id='Pandoc.Pandoc' href='#Pandoc.Pandoc'>#</a>
**`Pandoc.Pandoc`** &mdash; *Module*.



```julia
Pandoc
```

Pandoc wrapper to read JSON AST from `pandoc`

See https://hackage.haskell.org/package/pandoc-types-1.23/docs/Text-Pandoc-Definition.html


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L3-L9' class='documenter-source'>source</a><br>

<a id='Pandoc.Attr' href='#Pandoc.Attr'>#</a>
**`Pandoc.Attr`** &mdash; *Type*.



Attr: identifier, classes, key-value pairs


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L147-L149' class='documenter-source'>source</a><br>

<a id='Pandoc.BlockQuote' href='#Pandoc.BlockQuote'>#</a>
**`Pandoc.BlockQuote`** &mdash; *Type*.



Block quote (list of blocks)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L241-L243' class='documenter-source'>source</a><br>

<a id='Pandoc.BulletList' href='#Pandoc.BulletList'>#</a>
**`Pandoc.BulletList`** &mdash; *Type*.



Bullet list (list of items, each a list of blocks)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L259-L261' class='documenter-source'>source</a><br>

<a id='Pandoc.Caption' href='#Pandoc.Caption'>#</a>
**`Pandoc.Caption`** &mdash; *Type*.



The caption of a table or figure, with optional short caption.


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L375-L377' class='documenter-source'>source</a><br>

<a id='Pandoc.Cell' href='#Pandoc.Cell'>#</a>
**`Pandoc.Cell`** &mdash; *Type*.



A table cell.


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L319-L321' class='documenter-source'>source</a><br>

<a id='Pandoc.Cite' href='#Pandoc.Cite'>#</a>
**`Pandoc.Cite`** &mdash; *Type*.



Citation (list of inlines)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L506-L508' class='documenter-source'>source</a><br>

<a id='Pandoc.Code' href='#Pandoc.Code'>#</a>
**`Pandoc.Code`** &mdash; *Type*.



Inline code (literal)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L515-L517' class='documenter-source'>source</a><br>

<a id='Pandoc.CodeBlock' href='#Pandoc.CodeBlock'>#</a>
**`Pandoc.CodeBlock`** &mdash; *Type*.



Code block (literal) with attributes


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L224-L226' class='documenter-source'>source</a><br>

<a id='Pandoc.ColSpan' href='#Pandoc.ColSpan'>#</a>
**`Pandoc.ColSpan`** &mdash; *Type*.



The number of columns occupied by a cell; the width of a cell.


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L314-L316' class='documenter-source'>source</a><br>

<a id='Pandoc.ColSpec' href='#Pandoc.ColSpec'>#</a>
**`Pandoc.ColSpec`** &mdash; *Type*.



The specification for a single table column.


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L301-L303' class='documenter-source'>source</a><br>

<a id='Pandoc.ColWidth' href='#Pandoc.ColWidth'>#</a>
**`Pandoc.ColWidth`** &mdash; *Type*.



The width of a table column, as a percentage of the text width.


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L294-L296' class='documenter-source'>source</a><br>

<a id='Pandoc.DefinitionList' href='#Pandoc.DefinitionList'>#</a>
**`Pandoc.DefinitionList`** &mdash; *Type*.



Definition list. Each list item is a pair consisting of a term (a list of inlines) and one or more definitions (each a list of blocks)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L267-L269' class='documenter-source'>source</a><br>

<a id='Pandoc.Div' href='#Pandoc.Div'>#</a>
**`Pandoc.Div`** &mdash; *Type*.



Generic block container with attributes


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L407-L409' class='documenter-source'>source</a><br>

<a id='Pandoc.Emph' href='#Pandoc.Emph'>#</a>
**`Pandoc.Emph`** &mdash; *Type*.



Emphasized text (list of inlines)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L433-L435' class='documenter-source'>source</a><br>

<a id='Pandoc.Header' href='#Pandoc.Header'>#</a>
**`Pandoc.Header`** &mdash; *Type*.



Header - level (integer) and text (inlines)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L279-L281' class='documenter-source'>source</a><br>

<a id='Pandoc.HorizontalRule' href='#Pandoc.HorizontalRule'>#</a>
**`Pandoc.HorizontalRule`** &mdash; *Type*.



Horizontal rule


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L289-L291' class='documenter-source'>source</a><br>

<a id='Pandoc.Image' href='#Pandoc.Image'>#</a>
**`Pandoc.Image`** &mdash; *Type*.



Image: alt text (list of inlines), target


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L575-L577' class='documenter-source'>source</a><br>

<a id='Pandoc.LineBlock' href='#Pandoc.LineBlock'>#</a>
**`Pandoc.LineBlock`** &mdash; *Type*.



Multiple non-breaking lines


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L217-L219' class='documenter-source'>source</a><br>

<a id='Pandoc.LineBreak' href='#Pandoc.LineBreak'>#</a>
**`Pandoc.LineBreak`** &mdash; *Type*.



Hard line break


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L534-L536' class='documenter-source'>source</a><br>

<a id='Pandoc.Link' href='#Pandoc.Link'>#</a>
**`Pandoc.Link`** &mdash; *Type*.



Hyperlink: alt text (list of inlines), target


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L565-L567' class='documenter-source'>source</a><br>

<a id='Pandoc.ListAttributes' href='#Pandoc.ListAttributes'>#</a>
**`Pandoc.ListAttributes`** &mdash; *Type*.



List attributes.

The first element of the triple is the start number of the list.


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L166-L170' class='documenter-source'>source</a><br>

<a id='Pandoc.Math' href='#Pandoc.Math'>#</a>
**`Pandoc.Math`** &mdash; *Type*.



TeX math (literal)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L539-L541' class='documenter-source'>source</a><br>

<a id='Pandoc.Note' href='#Pandoc.Note'>#</a>
**`Pandoc.Note`** &mdash; *Type*.



Footnote or endnote


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L585-L587' class='documenter-source'>source</a><br>

<a id='Pandoc.OrderedList' href='#Pandoc.OrderedList'>#</a>
**`Pandoc.OrderedList`** &mdash; *Type*.



Ordered list (attributes and a list of items, each a list of blocks)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L249-L251' class='documenter-source'>source</a><br>

<a id='Pandoc.Para' href='#Pandoc.Para'>#</a>
**`Pandoc.Para`** &mdash; *Type*.



Paragraph


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L210-L212' class='documenter-source'>source</a><br>

<a id='Pandoc.Plain' href='#Pandoc.Plain'>#</a>
**`Pandoc.Plain`** &mdash; *Type*.



Plain text, not a paragraph


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L202-L204' class='documenter-source'>source</a><br>

<a id='Pandoc.Quoted' href='#Pandoc.Quoted'>#</a>
**`Pandoc.Quoted`** &mdash; *Type*.



Quoted text (list of inlines)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L488-L490' class='documenter-source'>source</a><br>

<a id='Pandoc.RawBlock' href='#Pandoc.RawBlock'>#</a>
**`Pandoc.RawBlock`** &mdash; *Type*.



Raw block


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L233-L235' class='documenter-source'>source</a><br>

<a id='Pandoc.RawInline' href='#Pandoc.RawInline'>#</a>
**`Pandoc.RawInline`** &mdash; *Type*.



Raw inline


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L557-L559' class='documenter-source'>source</a><br>

<a id='Pandoc.RowHeadColumns' href='#Pandoc.RowHeadColumns'>#</a>
**`Pandoc.RowHeadColumns`** &mdash; *Type*.



The number of columns taken up by the row head of each row of a 'TableBody'. The row body takes up the remaining columns.


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L343-L345' class='documenter-source'>source</a><br>

<a id='Pandoc.RowSpan' href='#Pandoc.RowSpan'>#</a>
**`Pandoc.RowSpan`** &mdash; *Type*.



The number of rows occupied by a cell; the height of a cell.


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L309-L311' class='documenter-source'>source</a><br>

<a id='Pandoc.ShortCaption' href='#Pandoc.ShortCaption'>#</a>
**`Pandoc.ShortCaption`** &mdash; *Type*.



A short caption, for use in, for instance, lists of figures.


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L368-L370' class='documenter-source'>source</a><br>

<a id='Pandoc.SmallCaps' href='#Pandoc.SmallCaps'>#</a>
**`Pandoc.SmallCaps`** &mdash; *Type*.



Small caps text (list of inlines)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L480-L482' class='documenter-source'>source</a><br>

<a id='Pandoc.SoftBreak' href='#Pandoc.SoftBreak'>#</a>
**`Pandoc.SoftBreak`** &mdash; *Type*.



Soft line break


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L529-L531' class='documenter-source'>source</a><br>

<a id='Pandoc.Space' href='#Pandoc.Space'>#</a>
**`Pandoc.Space`** &mdash; *Type*.



Inter-word space


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L524-L526' class='documenter-source'>source</a><br>

<a id='Pandoc.Span' href='#Pandoc.Span'>#</a>
**`Pandoc.Span`** &mdash; *Type*.



Generic inline container with attributes


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L593-L595' class='documenter-source'>source</a><br>

<a id='Pandoc.Str' href='#Pandoc.Str'>#</a>
**`Pandoc.Str`** &mdash; *Type*.



Text (string)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L426-L428' class='documenter-source'>source</a><br>

<a id='Pandoc.Strikeout' href='#Pandoc.Strikeout'>#</a>
**`Pandoc.Strikeout`** &mdash; *Type*.



Strikeout text (list of inlines)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L456-L458' class='documenter-source'>source</a><br>

<a id='Pandoc.Strong' href='#Pandoc.Strong'>#</a>
**`Pandoc.Strong`** &mdash; *Type*.



Strongly emphasized text (list of inlines)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L448-L450' class='documenter-source'>source</a><br>

<a id='Pandoc.Subscript' href='#Pandoc.Subscript'>#</a>
**`Pandoc.Subscript`** &mdash; *Type*.



Subscripted text (list of inlines)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L472-L474' class='documenter-source'>source</a><br>

<a id='Pandoc.Superscript' href='#Pandoc.Superscript'>#</a>
**`Pandoc.Superscript`** &mdash; *Type*.



Superscripted text (list of inlines)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L464-L466' class='documenter-source'>source</a><br>

<a id='Pandoc.Table' href='#Pandoc.Table'>#</a>
**`Pandoc.Table`** &mdash; *Type*.



Table, with attributes, caption, optional short caption, column alignments and widths (required), table head, table bodies, and table foot


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L385-L389' class='documenter-source'>source</a><br>

<a id='Pandoc.TableBody' href='#Pandoc.TableBody'>#</a>
**`Pandoc.TableBody`** &mdash; *Type*.



A body of a table, with an intermediate head, intermediate body, and the specified number of row header columns in the intermediate body.


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L348-L352' class='documenter-source'>source</a><br>

<a id='Pandoc.TableFoot' href='#Pandoc.TableFoot'>#</a>
**`Pandoc.TableFoot`** &mdash; *Type*.



The foot of a table.


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L360-L362' class='documenter-source'>source</a><br>

<a id='Pandoc.TableHead' href='#Pandoc.TableHead'>#</a>
**`Pandoc.TableHead`** &mdash; *Type*.



The head of a table.


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L335-L337' class='documenter-source'>source</a><br>

<a id='Pandoc.Target' href='#Pandoc.Target'>#</a>
**`Pandoc.Target`** &mdash; *Type*.



Link target (URL, title).


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L418-L420' class='documenter-source'>source</a><br>

<a id='Pandoc.Underline' href='#Pandoc.Underline'>#</a>
**`Pandoc.Underline`** &mdash; *Type*.



Underlined text (list of inlines)


<a target='_blank' href='https://github.com/kdheepak/Pandoc.jl/blob/78bf65bfe08af1318ed2435111f04cbe3a7f13ea/src/Pandoc.jl#L441-L443' class='documenter-source'>source</a><br>

<a id='Pandoc.runtests-Tuple' href='#Pandoc.runtests-Tuple'>#</a>
**`Pandoc.runtests`** &mdash; *Method*.



```julia
Pandoc.runtests(pattern...; kwargs...)
```

Equivalent to `ReTest.retest(Pandoc, pattern...; kwargs...)`. This function is defined automatically in any module containing a `@testset`, possibly nested within submodules.

