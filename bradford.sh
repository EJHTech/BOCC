#!/bin/sh

#Blackwell's Online Course Collector
#Version 0.1
# Copyright 2017 Eric Hofrichter
# Time-stamp: <2017-02-13 13:55:23>
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

#Bradford

echo "Bradford"
SCHOOL=Bradford
year=$1
echo $year
#change working directory
current_dir=$PWD
mkdir -p $SCHOOL/$year

#rip website--------------------------------------------------------------------
echo "Downloading Course Pages.  This will take a while"

for PAGE in {1..2000}; do
 wget -P bradford.rebuslist.com -nc -e robots=off "https://bradford.rebuslist.com/list.php?list_id=$PAGE" >/dev/null 2>&1 && echo "Page #$PAGE/2000" &
done

#change directory---------------------------------------------------------------
cd $SCHOOL/$year

#Create list of book detail links
grep 'ris.php' ../../bradford.rebuslist.com/* > ris.txt
sed -i 's/list.php?list_id=[0-9]*:<a href="//g' ris.txt
sed -i 's/".*$//g' ris.txt
grep 'material' ris.txt > rise.txt

mkdir ris

#Download book details----------------------------------------------------------

echo "Downloading book details.  This will take a long while"
bookTotal=$(cat rise.txt | wc -l)

while read url; do
 ((c++));
 wget -P ris/ -nc $url >/dev/null 2>&1 && echo "Book #$c/$bookTotal" &
done < rise.txt

export LC_ALL='C'

#return to BOCC directory-------------------------------------------------------
cd $current_dir

exit
