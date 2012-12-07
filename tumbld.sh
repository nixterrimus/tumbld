#!/bin/bash

download_site()
{
	# Go to subfolder for organized downloading
	if [ ! -d "$site" ]; then
		mkdir $site
	fi
	cd $site
	
	# Download the images using wget
	wget --quiet -H -Dmedia.tumblr.com,$site.tumblr.com -r -R "*avatar*" -A "[0-9]" \
	 -A "*index*" -A jpeg,jpg,bmp,gif,png --level=10 -nd -nc -erobots=off \
	http://$site.tumblr.com/
	
	# Clean up pages needed to find images
	rm -f 1 2 3 4 5 6 7 8 9 index.html
	
	cd ../
}

usage()
{
	echo "download images from tumblr"
  echo "Usage: `basename $0` [-s] file"
  exit $E_BADARGS
}

if [ $# -ne 1 ]
then
	echo "download images from tumblr"
  echo "Usage: `basename $0` file"
  exit $E_BADARGS
fi

if [ -e $1 ]
then
	# Download a site of tumblrs using a file as source
	cat $1 | while read site; do
			if [[ $site != \#* ]]; then
				download_site $site
			fi
	done
else
	# download a single tumblr
	site=$1
	download_site $site
fi