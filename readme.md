Tumbld is a script to download images from a specific tumblr blog or set of tumblr blogs.  The script only requirement for the script to run is wget.  For a complete discussion of how this script works, take look at [Nick Rowe's blog entry on how tumbld works](http://blog.dcxn.com/2011/11/06/wget-all-recent-images-from-a-tumblr).

# Installations & Usage

To install tumbld, clone the repository and move it to your favorite script location.  tumbld.sh supports downloading from a single tumblr or a set of tumblrs.

## Downloading from a single tumblr

    tumbld.sh architectureblog
  
Downloads a single tumblr's images.  Make sure to pass only the base blog name and not the full url.

## Downloading from many tumblrs
    
    tumbld.sh /path/to/file
    
The file should contain a list of tumblr blog name with one on each line.  For example the `file` might look like

    architectureblog
    drawingarchitecture

If desired, pass in `-s` as the first argument and the photos from these blogs will be placed into subfolders.
    
# Common Problems

- Script isn't executable? Try this: `chmod /path/to/tumbld.sh`
- wget ins't installed? `apt-get intall wget` (debian/ubuntu) or `brew install wget` (osx)

# License

tumblr is written by [Nick Rowe](http://dcxn.com) and is available under an MIT license.

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/33892d7fb7e63cecbc426978a26aada9 "githalytics.com")](http://githalytics.com/nixterrimus/tumbld)
