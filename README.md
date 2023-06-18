# nerd-fonts-installer
Lists and downloads the latest Nerd Fonts (using fzf as selector).

This is just a make-do script that uses basic regular expressions to parse the Nerd Fonts release page (https://github.com/ryanoasis/nerd-fonts/releases) to list and download the latest Nerd Fonts. It can stop working if the layout of the GitHub releases page changes.

Multi-select is enabled in `fzf`. Use `TAB` to select multiple fonts.

Additionally, it also places the font files in <pre><i>Font Name</i> Nerd Font</pre> directory in `~/.local/share/fonts/`.

## Dependencies
`curl`,`sed`,`column`,`awk`,`wget`,`tar`,`unzip` and `fzf`.
