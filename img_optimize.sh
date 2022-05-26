#!/bin/bash
WARNING="\n\nUsage: $(basename $0) dir maxwidth"

DIR=$1
MAXWIDTH=$2

if [[ -d $DIR ]]; then
    if [[ "$DIR" =~ '/'$ ]]; then
	    DIR="$DIR"
	else
		DIR="$DIR"/
	fi
	echo "$DIR*"
	for FILE in "$DIR"* ; do
		if [[ -f $FILE ]]; then
			echo "$FILE"
			if [ $MAXWIDTH > 0 ]; then
				convert "$FILE" -resize "${MAXWIDTH}x>" -auto-orient "$FILE"
			fi
		    convert -strip -interlace Plane -quality 85% "$FILE" "$FILE"
		elif [[ -d $FILE ]]; then
			echo "can't recursively do: $FILE"
		fi
	done
elif [[ -f $DIR ]]; then
	echo "$DIR"
	if [ $MAXWIDTH > 0 ]; then
		convert "$FILE" -resize "${MAXWIDTH}x>" -auto-orient "$FILE"
	fi
    convert -strip -interlace Plane -quality 85% "$DIR" "$DIR"
else
    echo "couldn't find $DIR"
fi
exit 1