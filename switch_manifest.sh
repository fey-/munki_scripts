#!/bin/bash

# I steal things from the internet and then fail at making them better.
#
# Matt Carr
# matt.carr@utexas.edu
#
# Stupid manifest switcher that I wrote to help with testing.
#

if [[ $EUID -ne 0 ]]; then
   echo "Try again as root" 
   exit 1
fi
	
if [ $# -lt 1 ]; then
  echo "\n Try Again: \n $0 test|client|debug - Manifest or debug option was not defined. \n "
  exit 1
fi

input=$(echo $1)
debug=$(defaults read /Library/Preferences/ManagedInstalls.plist)
cmanifest=$(defaults read /Library/Preferences/ManagedInstalls.plist | grep "ClientIdentifier" | awk '{ print $3 }' |  sed 's/[;"]//g')

case $input in
	test)
	manifest="MANIFEST1" ;;
	
	client)
	manifest="MANIFEST2" ;;
	
	debug)
	echo $debug
	exit 0 ;;
esac

if [ $cmanifest != $manifest ]; then

defaults write /Library/Preferences/ManagedInstalls.plist ClientResourcesFilename $manifest.zip
defaults write /Library/Preferences/ManagedInstalls.plist ClientIdentifier $manifest

echo "Your munki manifest has been changed to $manifest"

else
	echo "\nExiting... \nYou've already got $cmanifest set as your manifest.\n"

fi

exit 0
