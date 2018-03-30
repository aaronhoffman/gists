#!/bin/bash  
# generate file containing all URIs to execute to retrieve data from hacker news firebase API
# api docs: https://github.com/HackerNews/API

echo generating file hn-uri.txt

URICOUNT=10000000

echo file will contain $URICOUNT lines

# get current maxid from https://hacker-news.firebaseio.com/v0/maxitem.json
MAXID=12739717

echo max id $MAXID

let "MINID=$MAXID-$URICOUNT"

echo min id $MINID

# for 10MM rows, this took 10 minutes on my machine and produced a 560MB file 
for ((x=$MINID; x<$MAXID; x++))
do
    # append a uri for the current id to the file
    echo "https://hacker-news.firebaseio.com/v0/item/$x.json" >> hn-uri.txt
    if ! ((x % 10000)); then
        echo current id $x
    fi
done
