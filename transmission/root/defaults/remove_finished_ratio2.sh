#!/bin/bash

# Clears finished downloads from Transmission with ratio more than 2.0.
#
# Based on:
# https://gist.github.com/pawelszydlo/e2e1fc424f2c9d306f3a
#
# Server string is resolved in this order:
# 1. TRANSMISSION_SERVER environment variable
# 2. Parameters passed to this script
# 3. Hardcoded string in this script (see below).

# Server string: "host:port --auth username:password"
SERVER="localhost:9091 --auth $USER:$PASS"

# Which torrent states should be removed at 100% progress.
DONE_STATES=("Seeding" "Stopped" "Finished" "Idle")

# Get the final server string to use.
if [[ -n "$TRANSMISSION_SERVER" ]]; then
    echo -n "Using server string from the environment: "
    SERVER="$TRANSMISSION_SERVER"
elif [[ "$#" -gt 0 ]]; then
    echo -n "Using server string passed through parameters: "
    SERVER="$*"
else
    echo -n "Using hardcoded server string: "
fi
echo "${SERVER: : 10}(...)"  # Truncate to not print auth.

# Use transmission-remote to get the torrent list from transmission-remote.
TORRENT_LIST=$(transmission-remote $SERVER --list | sed -e '1d' -e '$d' | awk '{print $1}' | sed -e 's/[^0-9]*//g')

# Iterate through the torrents.
for TORRENT_ID in $TORRENT_LIST
do
    INFO=$(transmission-remote $SERVER --torrent "$TORRENT_ID" --info)
    echo -e "Processing #$TORRENT_ID: \"$(echo "$INFO" | sed -n 's/.*Name: \(.*\)/\1/p')\"..."
    # To see the full torrent info, uncomment the following line.
    # echo "$INFO"
    PROGRESS=$(echo "$INFO" | sed -n 's/.*Percent Done: \(.*\)%.*/\1/p')
    RATIO=$(echo "$INFO" | sed -n 's/.*Ratio: \(.*\)/\1/p')
    STATE=$(echo "$INFO" | sed -n 's/.*State: \(.*\)/\1/p')
 
    # If the torrent is 100% done and the state is one of the done states.
    if [[ "$PROGRESS" == "100" ]] && [[ "${DONE_STATES[@]}" =~ "$STATE" ]] && [[ "$RATIO" > 2.0 ]]; then
        echo "Torrent #$TORRENT_ID is done. Removing torrent from list."
        transmission-remote $SERVER --torrent "$TORRENT_ID" --remove
    else
        echo "Torrent #$TORRENT_ID is $PROGRESS% done with state \"$STATE\". Ignoring."
    fi
done
