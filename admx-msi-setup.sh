#!/bin/sh

#########################################################################################################################
##
## Copyright (C) 2021 BaseALT Ltd. <org@basealt.ru>
##
## This program is free software; you can redistribute it and/or
## modify it under the terms of the GNU General Public License
## as published by the Free Software Foundation; either version 2
## of the License, or (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
##
#########################################################################################################################

set -eu

TEMPDIR=$(mktemp -d -p /tmp)
DESTDIR="/usr/share/PolicyDefinitions/"

SOURCE_URL="https://download.microsoft.com/download/3/0/6/30680643-987a-450c-b906-a455fff4aee8/Administrative%20Templates%20(.admx)%20for%20Windows%2010%20October%202020%20Update.msi"

PROG="${0##*/}"
PROG_VERSION='0.1.0'

SHORT_OPTIONS=':d:hv-:s:'

cleanup()
{
	echo "Removing admx-msi-setup temporary files..."
	rm -rf "$TEMPDIR"
}

trap cleanup EXIT INT HUP

show_help()
{
	cat <<EOF
$PROG - download msi files and extract them in <destination-directory> default value is $DESTDIR.
Usage: $PROG [-d <destination-directory>] [-s <admx-msi-source>]

EOF
	exit
}

show_version()
{
	cat <<EOF
$PROG version $PROG_VERSION

EOF
	exit
}

while getopts "${SHORT_OPTIONS}" o; do
	    case "${o}" in
		h) show_help
			;;
		v) show_version
			;;
		d) DESTDIR="${OPTARG}"
			;;
		s) SOURCE_URL="${OPTARG}"
			;;
		*) echo "Unrecognized option: $1"; exit 3
			;;
	    esac
done

download_files()
{
  wget -N -q --tries=10 "$SOURCE_URL" -O "$TEMPDIR/package.msi"
}

extract_files()
{
  msiextract "$TEMPDIR/package.msi" -C "$TEMPDIR"
  SOURCEDIR=$(find "$TEMPDIR" -type d -name "PolicyDefinitions" -print | head -n 1)
  if [ -z "$SOURCEDIR" ]; then
      echo "Policy definitions not found in package!"
      exit 1
  else
      cd "$SOURCEDIR"
      mkdir "${DESTDIR}"
      cp -r -- * "${DESTDIR}"
  fi
}

main() 
{
	download_files
	extract_files
}

main
