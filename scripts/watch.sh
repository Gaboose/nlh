#!/usr/bin/bash
inotifywait -e close_write,moved_to,create -m src |
while read -r directory events filename; do
    ceramic clay build web --setup --assets
    echo Done
done