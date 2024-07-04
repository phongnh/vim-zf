# vim-zf

Quickly navigate to **files** under a directory, jump to lines matching a
pattern using **grep**, open **buffers**, **tags** generated by ctags, Vim's
**help tags**, **old files**, and **file marks** using the fuzzy-searcher
[zf][zf].

The terminal buffer can be displayed either in a normal window at the bottom
of the screen or in a popup window.

<dl>
  <p align="center">
  <a href="https://asciinema.org/a/666835">
    <img src="https://asciinema.org/a/666835.png" width="480">
  </a>
  </p>
</dl>


## Requirements

- [zf][zf]
- [cut(1)][cut] (for the `:ZfHelp` command)
- [find(1)][find] or similar (for the `:ZfFind` command)
- [grep(1)][grep] or similar (for the `:ZfGrep` command)


## Commands

| Command          | Description                                                                         |
| ---------------- | ----------------------------------------------------------------------------------- |
| `:ZfFind [dir]`  | Find **files** in `[dir]`, edit selected file in the current window.                    |
| `:ZfGrep {args}` | Grep **lines** using pattern `{args}`, jump to selected location in the current window. |
| `:ZfBuffer`      | List **buffers**, edit selected buffer in the current window.                           |
| `:ZfArgs`        | List **global arglist**, edit selected file in the current window.                      |
| `:ZfLargs`       | List **local arglist**, edit selected file in the current window.                       |
| `:ZfOldfiles`    | List **most recently used** files, edit selected file in current window.                |
| `:ZfTjump`       | List **tags**, jump to selected tag in the current window.                              |
| `:ZfMarks`       | List **marks**, jump to the selected mark in the current window.                        |
| `:ZfHelp`        | List **help tags**, open help page with the selected tag in a new split.                |

`[dir]` is the directory to search in. If omitted, the search is performed in
the current working directory. Environment variables can be passed, for example,
`:ZfFind $VIMRUNTIME`.

Each command has a related command that opens the selected item in a new split,
like `:ZfBufferSplit`. These commands accept a **command modifier**. For
example, to open a buffer in a new vertical split, run `:vert ZfBufferSplit`,
`:tab ZfBufferSplit` will open the selected buffer in a new tab. For a full
list of supported command modifiers, see `:help zf-commands-split`.


## Configuration

Options can be passed to zf through the dictionary `g:zf`. The following
entries are supported:

| Entry            | Description                                                            | Default                            |
| ---------------- | -----------------------------------------------------------------------| ---------------------------------- |
| `height`         | The height of the interface in rows. This sets zf's `--height` option. | `10`                               |
| `term_highlight` | Highlight group for the terminal window.                               | `'Terminal'`                       |
| `popupwin`       | Display zf in a popup terminal.                                        | `v:false`                          |
| `popup`          | Popup window options (dictionary).                                     | [see below](#popup-window-options) |
| `findcmd`        | File-search command (string).                                          | [see below](#find-command)         |
| `grepcmd`        | Grep-search command.                                                   | `&grepprg`                         |
| `grepformat`     | Format string for parsing the selected grep-output line.               | `&grepformat`                      |
| `histadd`        | If true, add edit command to history.                                  | `v:false`                          |

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
| cut -b3-
```

Broken down the expression means:
- Ignore all hidden files and directories, except for `.gitignore`, and `.vim`,
- print only files and symlinks.
- The `cut` command will remove the leading `./` from all file paths.

### Example

```vim
g:zf = {
    findcmd: 'fd --type f',
    grepcmd: 'grep -Hn',
    grepformat: '%f:%l:%m',
    histadd: true,
    height: 15,
    term_highlight: 'Pmenu',
    popupwin: true,
    popup: {
        borderchars: [' ']
    }
}
```
More examples can be found under `:help zf-config-examples`.


## Writing custom zf commands

Writing custom commands that invoke zf is very simple. Internally, the above
commands call the `Start()` function that passes the items to zf in a terminal
window. The function is documented in `:help zf-api`.  Examples can be found in
`:help zf-api-examples`.


## Installation

Run the following commands in your terminal:
```bash
$ cd ~/.vim/pack/git-plugins/start
$ git clone https://github.com/phongnh/vim-zf
$ vim -u NONE -c 'helptags vim-zf/doc | quit'
```
**Note:** The directory name `git-plugins` is arbitrary, you can pick any other
name. For more details see `:help packages`. Alternatively, use your favorite
plugin manager.


## License

Distributed under the same terms as Vim itself. See `:help license`.

[zf]:   https://github.com/natecraddock/zf
[find]: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/find.html
[grep]: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/grep.html
[cut]:  https://pubs.opengroup.org/onlinepubs/9699919799/utilities/cut.html
