#!/bin/sh

page=$(mktemp)

# download and parse releases page of nerd fonts
curl https://github.com/ryanoasis/nerd-fonts/releases > "$page"

# NOTE: This script will stop working when the layout of github releases page changes.
# In case the script has stopped working,
# curl the page and see what is the starting and ending lines of the table 
# which contains the download links to see if it works again.
starting_line="<table>"
ending_line="<\/table><\/details><\/div>"
sed -i -n '/^'"$starting_line"'$/,$p;/^'"$ending_line"'$/q' "$page"

# select font that I want to download
selection=$(sed -n 's_<td><a href="\([^"]*\)">\([^<]*\)</a></td>_\2\t\1_p' "$page" | column -t | fzf --reverse)
[ -z "$selection" ] && exit
filename=$(printf "$selection" | awk '{print $1}')
download_link=$(printf "$selection" | awk '{print $2}')

# make appropriate font directory in ~/.local/share/fonts/
font_name=$(printf "$filename" | sed 's/\([^.]*\).*/\1/')
font_directory="$HOME/.local/share/fonts/$font_name"
if [ -d "$font_directory" ]; then
	printf "$font_directory already exists!\
	\nDo you wish to delete the existing directory and make a new one? [y/n] "
	read -r ans
	if [ "$ans" = 'y' ] || [ "$ans" = 'Y' ]; then
		printf "Deleting directory $font_directory and placing new fonts in that directory.\n"
		rm -rf "$font_directory"
	else
		printf "Aborting!\n"
		exit
	fi
fi
mkdir -p "$font_directory"
cd "$font_directory"

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
rm "$page"

# refresh font cache
fc-cache
