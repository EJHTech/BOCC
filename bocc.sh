#!/bin/bash

#Blackwell's Online Course Collector
#Version 0.1
# Copyright 2017 Eric Hofrichter
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#Main

#improve include handling
# Full path of this script
THIS=`readlink -f "${BASH_SOURCE[0]}"`
# This directory path
DIR=`dirname "${THIS}"`

#initialize variables
school=""
year=""

#get input from user
echo "Hello, "$USER".  This script will download and parse course information from university websites"

echo "Select School from list-
1 - Aberdeen
2 - Edinburgh
3 - Bradford"

while [[ ! $school || ! $school =~ ^[0-9]$ ]]; do
	read school
	if [[ ! $school || ! $school =~ ^[0-9]$ ]]; then
		echo "Invalid school selection"
	fi
done


getYear () {
	echo "Year in format MMMM-NNNN (e.g. 2016-2017): "
	while [[ ! $year || ! $year =~ ^20[0-9][0-9]-20[0-9][0-9]$ ]]; do
			read year
			if [[ ! $year || ! $year =~ ^20[0-9][0-9]-20[0-9][0-9]$ ]]; then
				echo "Invalid year"
			fi
	done
	return 0
}

#Aberdeen function
if (( $school==1 )); then
	. "$DIR/aberdeen.sh" "$year"
	exit

elif (( $school==2 )); then
	. "$DIR/edinburgh.sh" $year
	exit

elif (( $school==3 )); then
	. "$DIR/bradford.sh" $year
	exit

else echo "Please provide a valid school";
	exit

fi
