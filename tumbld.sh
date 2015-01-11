#!/bin/bash

PAGES=5
USE_SUBFOLDERS=0

download_site()
{
    SITE=$1

    if [[ $USE_SUBFOLDERS == 1 ]]; then
        # Go to subfolder for organized downloading
        mkdir -p $SITE
        pushd $SITE &>/dev/null
    fi

    IMAGE_EXT_RE="jpeg|jpg|bmp|gif|png"
    PAGES_RE=""
    if [[ $PAGES >0 ]]; then
        PAGES_RE="($(seq -s \| 1 ${PAGES})DUMMY)"
    fi

    FILES=()
    IMG_SIZE=0
    IMG_COUNT=0

    # Download the images using wget
    while read LINE; do
        if [[ $LINE =~ \[([[:digit:]]+)(/[[:digit:]]+)?\][[:space:]]-\>[[:space:]]\"([^\"]+)\" ]]; then
            echo $LINE
            SIZE=${BASH_REMATCH[1]}
            FILE=${BASH_REMATCH[3]}
            if [[ ! $FILE =~ \.(${IMAGE_EXT_RE})$ ]]; then
                FILES+=($FILE)
            else
                let IMG_SIZE+=$SIZE
                let IMG_COUNT+=1
            fi
        fi
    done < <(
        wget -H \
            --domains=media.tumblr.com,$SITE.tumblr.com \
            --recursive \
            --reject "*avatar*" \
            --accept-regex "index|page/${PAGES_RE}|${IMAGE_EXT_RE}" \
            --level=$PAGES \
            --no-directories \
            --no-clobber \
            --no-verbose \
            -erobots=off \
            http://$SITE.tumblr.com/ 2>&1
    )

    # Clean up pages needed to find images
    echo "Deleting crawling ${#FILES[@]} files ..."
    rm -f ${FILES[*]}
    echo "Downloaded ${IMG_COUNT} images with total size ${IMG_SIZE}."

    if [[ $USE_SUBFOLDERS == 1 ]]; then
        popd &>/dev/null
    fi
}

usage()
{
    cat >&2 <<- EOF
        usage: $0 [options] [site_name ...]

        download images from tumblr

        OPTIONS:
        -h        Show this message
        -s        Put downloaded images in subfolders
        -p PAGES  Number of pages to download (default 5, use 0 for no limits)
        -l LIST   File with number of sites to download

        either site or list must be defined
EOF
}

SITES=()

while getopts "shp:l:" opt; do
    case $opt in
        p)
            PAGES=$OPTARG
            ;;
        l)
            LIST=$OPTARG
            if [ ! -f $LIST ]; then
                echo "List file $LIST does not exist." >&2
                exit $E_ENOENT
            fi
            SITES=($(paste -d ' ' -s $LIST))
            ;;
        s)
            USE_SUBFOLDERS=1
            ;;
        h)
            usage
            exit
            ;;
        \?)
            usage
            exit $E_OPTERROR
            ;;
    esac
done

shift $(($OPTIND - 1))

SITES+=($@)

# Ensure that there is at least one site
if [ ${#SITES[@]} -lt 1 ]; then
    usage
    exit $E_BADARGS
fi

for SITE in ${SITES[@]}; do
    download_site $SITE
done
