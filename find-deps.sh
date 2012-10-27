#!/bin/sh

sed -ne 's/.*\\includegraphics.*{\(build\/.*\)}.*/images: \1/p' "$@" /dev/null |
