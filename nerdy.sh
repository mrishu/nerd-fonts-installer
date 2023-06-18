#!/bin/sh

page=$(mktemp)
download_selections=$(mktemp)

# download and parse releases page of nerd fonts
curl https://github.com/ryanoasis/nerd-fonts/releases > "$page"

# NOTE: This script will stop working when the layout of github releases page changes.
# In case the script has stopped working,
# curl the page and see what is the starting and ending lines of the table 
# which contains the download links to see if it works again.
starting_line="<table>"
ending_line="<\/table><\/details><\/div>"
sed -i -n '/^'"$starting_line"'$/,$p;/^'"$ending_line"'$/q' "$page"

# select fonts that I want to download
sed -n 's_<td><a href="\([^"]*\)">\([^<]*\)</a></td>_\2\t\1_p' "$page" | column -t | fzf --reverse --multi > "$download_selections"

while read -r selection ; do 
	filename=$(printf "$selection" | awk '{print $1}')
	download_link=$(printf "$selection" | awk '{print $2}')

	# make appropriate font directory in ~/.local/share/fonts/
	font_name=$(printf "$filename" | sed 's/\([^.]*\).*/\1/')
	font_directory="$HOME/.local/share/fonts/$font_name Nerd Font"
	if [ -d "$font_directory" ]; then
		printf "\033[31mDirectory '$font_directory' already exists!\
		\nDeleting directory '$font_directory' and making new '$font_directory'.\033[0m\n"
		rm -rf "$font_directory"
	fi
	mkdir -p "$font_directory"
	cd "$font_directory" || exit 1

	# download font
	wget "$download_link"

	# extract the downloaded file
	if printf "$filename" | grep -q '^.*\.tar\.xz$'; then
		tar -xvf "$filename"
	elif printf "$filename" | grep -q '^.*\.zip$'; then
		unzip "$filename"
	fi

	# remove compressed file
	rm "$filename"
done < "$download_selections"

rm "$page"
# refresh font cache
fc-cache
