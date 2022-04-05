#!/bin/bash
WARNING="\n\nUsage: $(basename $0) -r -l [-match arg] [-replace arg] 'query' dir"

RECURSIVE=0
LIST=0
while getopts ':m:p:rl' opt; do
    case "$opt" in
        r | recursive) RECURSIVE=1;;
        l | list) LIST=1;;
        m | match) MATCH="$OPTARG";;
        p | paste) REPLACE="$OPTARG";;
        :) echo -e "option requires an argument.$WARNING";
           exit 1;;
        ?) echo -e "Invalid command option.$WARNING";
           exit 1;;
    esac
done
shift $(($OPTIND - 1))

QUERY=$1
DIR=$2

if [ -z "$MATCH" ]; then
    echo -e 'You need to provide a regex.'$WARNING;
    exit 1
fi
if [ -z "$REPLACE" ]; then
    echo -e 'You need to provide a replacement.'$WARNING;
    exit 1
fi
if [ -z "$QUERY" ]; then
    echo -e 'You need to provide a query search.'$WARNING;
    exit 1
fi
if [ -z "$DIR" ]; then
    echo -e 'You need to provide dir.'$WARNING;
    exit 1
fi

if [[ "$DIR" =~ '/'$ ]]; then
    DIR=$(echo $DIR | sed 's:/*$::')
fi

FILES=$(grep -l -R "$QUERY" $DIR)

if [ -z "$FILES" ]
    then echo -e 'We found 0 files containing that query';
    exit 1
else
    echo -e "$FILES"
    echo $(wc -l <<< "${FILES}") 'matching files with query'
fi

read -p "Replace content of files(y/n)?" REPLY
case "$REPLY" in
  y|Y )
    for FILE in $FILES; do
        if [[ -f $FILE ]]; then
            $(perl -pi -e 's/'$MATCH'/'$REPLACE'/g;' $FILE)
            echo $FILE '[✓]'
        fi
    done
    ;;

  n|N )
    echo "Ok. No action taken" exit;;
  * )
    echo "invalid" exit;;
esac
