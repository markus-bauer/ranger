#!/usr/bin/env bash

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

## Script to generate thumbnails for ranger.
## -----------------------------------------
##
## Exit codes:
## 0: success
## 1: no success
##
## Arguments:
FILE_PATH="${1}"         # Full path of the source file
IMAGE_CACHE_PATH="${2}"  # Full path of the output thumbnail
WIDTH="${3}"             # width of the output thumbnail
HEIGHT="${4}"            # height of the output thumbnail


MIMETYPE="$( file --dereference --brief --mime-type -- "${FILE_PATH}" )"

create_thumbnail() {
    local source="${1}"
    local target="${2}"
    # NOTE(markus): Thumbnails have to be created with a fixed/known size and format, so that they can be drawn
    # directly with kitty.
    convert -- "${source}[0]" -geometry "${WIDTH}x${HEIGHT}" "png32:${target}"
}

# TODO(markus): Include other file types from scope.
# TODO(markus): Would it be possible to hook into scope or share code?
case "${MIMETYPE}" in
    image/*)
        create_thumbnail "${FILE_PATH}" "${IMAGE_CACHE_PATH}" && exit 0;;

    video/*)
        ffmpegthumbnailer -i "${FILE_PATH}" -o "${IMAGE_CACHE_PATH}" -s 0 &&
        create_thumbnail "${IMAGE_CACHE_PATH}" "${IMAGE_CACHE_PATH}" &&
        exit 0;;

    audio/*)
        ffmpeg -i "${FILE_PATH}" -map 0:v -map -0:V -c copy "${IMAGE_CACHE_PATH}" && 
        create_thumbnail "${IMAGE_CACHE_PATH}" "${IMAGE_CACHE_PATH}" &&
        exit 0;;
esac

exit 1
