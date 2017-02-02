#!/bin/bash
#
#Blackwell's Online Course Collector
#Version 0.1
# Copyright 2017 Eric Hofrichter

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

#get input from user
school=""
echo "Hello, "$USER".  This script will download and parse course information from university websites"

#read school

while [[ ! $school || $school = [^0-9] ]]; do
	echo "Select School from list-
	1 - Aberdeen
	2 - Edinburgh
	3 - Bradford"
	read school
done

year=""
while [[ ! $input || $input != 20[0-9][0-9] ]]; do
    #echo "Error: '$input' is not a number." >&2
		echo "Year in format MMMM-NNNN (e.g. 2016-2017): "
		read year
done
echo $school
echo $year
exit

#check input


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
