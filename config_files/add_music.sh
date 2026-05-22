#!/bin/bash

echo -n "Enter url: "
read music_url
FILENAME=$(yt-dlp -x --audio-format mp3 --restrict-filenames -o "%(title)s.%(ext)s" --print "after_move:filepath" $music_url)
echo "The audio '${FILENAME}' is done cooking."
