#!/bin/bash -xe

COEFFICIENTS=( 1 1.5 2 3 4 )
DRAWABLES=( drawable-mdpi drawable-hdpi drawable-xhdpi drawable-xxhdpi drawable-xxxhdpi )
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

for DP_DIR in `find svg/ -type d -name "[0-9]*"`; do
	cd $DIR/$DP_DIR
	REQUESTED_DP=$(echo ${PWD##*/} | sed 's:^\([0-9]*\).*:\1:g')

	for FILE in `ls -1`; do
		PREFIX=$(echo ${FILE%.*} | sed 's:\(^.*\)_[0-9]*px$:\1:g')
		for ((i=0;i<${#COEFFICIENTS[@]};i++)); do
			COEF=${COEFFICIENTS[$i]}
			DEST_DIR=$DIR/res_new/${DRAWABLES[$i]}
			DIMENSION=$(echo "$COEF * $REQUESTED_DP / 1" | bc)
			# DENSITY=$(echo "$DIMENSION * 10 / 1" | bc)
			DENSITY=1600
			mkdir -p $DEST_DIR
			# convert -background none -density $DENSITY -resize ${DIMENSION}x${DIMENSION} $FILE -alpha off -fill "#8a8e90" -opaque black -alpha on "$DEST_DIR/${PREFIX}_${REQUESTED_DP}dip.png"
			convert -background none -density $DENSITY -resize ${DIMENSION}x${DIMENSION} $FILE -quality 100 "$DEST_DIR/${PREFIX}_${REQUESTED_DP}dip.png"
		done
	done
done
