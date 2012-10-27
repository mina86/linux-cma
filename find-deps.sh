#!/bin/sh

# Copyright (c) 2012 by Michał Nazarewicz <mina86@mina86.com>
# Distributed under the terms of the Apache License Version 2.0
# available at <http://www.apache.org/licenses/LICENSE-2.0.html>

sed -ne 's/.*\\includegraphics.*{\(build\/[^}]*\)}.*/\1/p' "$@" /dev/null |
	sort -u |
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
