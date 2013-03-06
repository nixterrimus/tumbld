#!/bin/bash

download_site()
{
  if [ "$USE_SUBFOLDERS" == "1" ]
  then
	  # Go to subfolder for organized downloading
	  if [ ! -d "$site" ]
    then
		  mkdir $site
	  fi
	  cd $site
  fi
	
	# Download the images using wget
	wget --quiet -H -Dmedia.tumblr.com,$site.tumblr.com -r -R "*avatar*" -A "[0-9]" \
	 -A "*index*" -A jpeg,jpg,bmp,gif,png --level=10 -nd -nc -erobots=off \
	http://$site.tumblr.com/
	
	# Clean up pages needed to find images
	rm -f 1 2 3 4 5 6 7 8 9 index.html
	
  if [ "$USE_SUBFOLDERS" == "1" ]
  then
    cd ../
  fi
}

usage()
{
  cat << EOF
  usage: $0 [options] file_or_site_name

  download images from tumblr

  OPTIONS:
     -h      Show this message
     -s      Put downloaded images in subfolders
EOF
}

# Ensure that there are args
if [ $# -lt 1 ]
then
  usage
  exit $E_BADARGS
fi

USE_SUBFOLDERS=0
Sites=()

# Parse args
for var in "$@"
do
  if [ "$var" == "-s" ]; then
    USE_SUBFOLDERS=1
  else
    Sites=("${Sites[@]}" "$var")
  fi
done

# Ensure that a site or file of sites has been set
if [ ${#Sites[@]} -lt 1 ]
then
  usage
  exit $E_BADARGS
fi

# Act accordingly
if [ -f ${Sites[0]} ]
then
  # Download a site of tumblrs using a file as source
  cat ${Sites[0]} | while read site; do
    if [[ $site != \#* ]]; then
      download_site $site
    fi
  done
else
  # download a single tumblr
  site=${Sites[0]}
  download_site $site
fi
