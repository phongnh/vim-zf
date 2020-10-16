# vim-fzy

Quickly navigate to **files** under a directory, open **buffers**, **tags**
generated by ctags, Vim's **help tags**, **old files**, and **file marks** using
the fuzzy-searcher [fzy][fzy].

The terminal buffer can be displayed either in a normal window at the bottom
of the screen or in a popup window (requires Vim `>= 8.2.0204`).

<dl>
  <p align="center">
  <a href="https://asciinema.org/a/268637">
    <img src="https://asciinema.org/a/268637.png" width="480">
  </a>
  </p>
</dl>


## Requirements

- Vim `>= 8.1.1828` (`>= 8.2.0204` for popup terminal)
- [fzy][fzy]
- [cut(1)][cut] (for the `:FzyHelp` command)


## Commands

| Command          | Description                                                              |
| ---------------- | ------------------------------------------------------------------------ |
| `:FzyFind [dir]` | Find **files** in `[dir]`, edit selected file in the current window.     |
| `:FzyBuffer`     | List **buffers**, edit selected buffer in the current window.            |
| `:FzyArgs`       | List **global arglist**, edit selected file in the current window.       |
| `:FzyLargs`      | List **local arglist**, edit selected file in the current window.        |
| `:FzyOldfiles`   | List **most recently used** files, edit selected file in current window. |
| `:FzyTjump`      | List **tags**, jump to selected tag in the current window.               |
| `:FzyMarks`      | List **marks**, jump to the selected mark in the current window.         |
| `:FzyHelp`       | List **help tags**, open help page with the selected tag in a new split. |

`[dir]` is the directory to search in. If omitted, the search is performed in
the current working directory. Environment variables can be passed, for example,
`:FzyFind $VIMRUNTIME`.

Each command has a related command that opens the selected item in a new split:

| Command               | Description                                                              |
| --------------------- | ------------------------------------------------------------------------ |
| `:FzyFindSplit [dir]` | Same as `:FzyFind`, but edit the selected file in a new split.           |
| `:FzyBufferSplit`     | Same as `:FzyBuffer`, but edit the selected buffer in a new split.       |
| `:FzyArgsSplit`       | Same as `:FzyArgs`, but edit the selected file in a new split.           |
| `:FzyLargsSplit`      | Same as `:FzyLargs`, but edit the selected file in a new split.          |
| `:FzyOldfilesSplit`   | Same as `:FzyOldfiles`, but edit the selected file in a new split.       |
| `:FzyTjumpSplit`      | Same as `:FzyTjump`, but jump to the selected tag in a new split.        |
| `:FzyMarksSplit`      | Same as `:FzyMarks`, but jump to the selected mark in a new split.       |

These commands accept a **command modifier**. For example, to open a buffer in a
new vertical split, run `:vert FzyBufferSplit`. `:tab FzyBufferSplit` will open
the selected buffer in a new tab. For a full list of supported command
modifiers, see `:help fzy-commands-split`.


## Configuration

Options can be passed to fzy through the dictionary `g:fzy`. The following
entries are supported:

| Entry            | Description                                                                  | Default      |
| ---------------- | ---------------------------------------------------------------------------- | ------------ |
| `lines`          | Specify how many lines of results to show. This sets fzy's `--lines` option. | `10`         |
| `prompt`         | Set the fzy input prompt.                                                    | `'▶ '`       |
| `showinfo`       | If true, fzy is invoked with the `--show-info` option.                       | `v:false`    |
| `term_highlight` | Highlight group for the terminal window.                                     | `'Terminal'` |
| `popupwin`       | Display fzy in a popup terminal.                                             | `v:false`    |
| `popup`          | Popup window options (dictionary).                                           | see below    |
| `findcmd`        | File-search command (string).                                                | see below    |

When `popupwin` is set to `v:false`, the terminal window is opened at the bottom
of the screen and will occupy the full width of the Vim window.

### Popup window options

The appearance of the popup window can be configured through the `popup` key.
The following options can be set:

| Entry             | Description                                                                  | Default                                    |
| ----------------- | ---------------------------------------------------------------------------- | ------------------------------------------ |
| `highlight`       | Highlight group for popup window padding and border.                         | `'Pmenu'`                                  |
| `padding`         | List with numbers defining padding between popup window and its border.      | `[0, 1, 0, 1]`                             |
| `border`          | List with numbers (0 or 1) specifying whether to draw a popup window border. | `[1, 1, 1, 1]`                             |
| `borderchars`     | List with characters used for drawing the border.                            | `['═', '║', '═', '║', '╔', '╗', '╝', '╚']` |
| `borderhighlight` | List with highlight group names for drawing the border.¹                     | `['Pmenu']`                                |
| `minwidth`        | Minimum width of popup window.                                               | `80`                                       |

¹When only one item is specified it is used on all four sides.

### Find command

If `findcmd` is not specified, the following default command is used:
```bash
find
  -name '.*'
  -a '!' -name .
  -a '!' -name .gitignore
  -a '!' -name .vim
  -a -prune
  -o '(' -type f -o -type l ')'
  -a -print 2> /dev/null
| sed 's/^\.\///'
```

Broken down the expression means:
- Ignore all hidden files and directories, except for `.gitignore`, and `.vim`,
- print only files and symlinks.
- The `sed` command will remove the `./` prefix from all file paths.

### Example

```vim
let g:fzy = {
        \   'findcmd': 'fd --type f',
        \   'prompt': '>>> ',
        \   'showinfo': 1,
        \   'lines': 15,
        \   'term_highlight': 'Pmenu',
        \   'popupwin': 1,
        \   'popup': {
        \     'borderchars': [' ']
        \   }
        \ }
```
More examples can be found under `:help fzy-config-examples`.


## Writing custom fzy commands

Writing your own commands that will invoke fzy is not very hard. Internally, the
above commands call the `fzy#start()` function to pass the items to fzy in a
terminal window. The function is thoroughly documented under `:help fzy-api`.
Examples can be found under `:help fzy-api-examples`.


## Installation

#### Manual Installation

Run the following commands in your terminal:
```bash
$ cd ~/.vim/pack/git-plugins/start
$ git clone https://github.com/bfrg/vim-fzy
$ vim -u NONE -c "helptags vim-fzy/doc" -c q
```
**Note:** The directory name `git-plugins` is arbitrary, you can pick any other
name. For more details see `:help packages`.

#### Plugin Managers

Assuming [vim-plug][plug] is your favorite plugin manager, add the following to
your `vimrc`:
```vim
if has('patch-8.1.1828')
    Plug 'bfrg/vim-fzy'
endif
```


## License

Distributed under the same terms as Vim itself. See `:help license`.

[fzy]: https://github.com/jhawthorn/fzy
[find]: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/find.html
[cut]: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/cut.html
[plug]: https://github.com/junegunn/vim-plug
