# nerd-fonts-installer
Lists and downloads the latest Nerd Fonts using fzf

This is just a make-do script that uses basic regular expressions to parse the Nerd Fonts release page [https://github.com/ryanoasis/nerd-fonts/releases] to list and download them. Additionally, it also places the files in the appropriate directory under `~/.local/share/fonts/`.

NOTE: It can stop working if the layout of the GitHub releases page changes.
