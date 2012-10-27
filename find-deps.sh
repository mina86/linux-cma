#!/bin/sh

sed -ne 's/.*\\includegraphics.*{\(build\/.*\)}.*/\1/p' "$@" /dev/null |
	while read img; do
		echo "images: $img"
		case "$img" in build/*--*)
			svg=${img%--*}.svg
			svg=img/${svg#build/}
			id=${img##*--}
			id=${id%.*}
			echo "$img: $svg"
			echo '	@mkdir -p build'
			echo "	inkscape -z -j -i $id --file=\$< --export-eps=\$@"
		esac
	done
