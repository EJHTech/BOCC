#!/bin/bash

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

#Aberdeen

echo "Aberdeen"
year=$1
echo $year

SCHOOL=Aberdeen

mkdir -p $SCHOOL/$year

#rip website (Aberdeen)---------------------------------------------------------
echo "Downloading Information.  This will take a while"

wget https://www.abdn.ac.uk/registry/courses/postgraduate/$year/ -r --level=4 -e robots=off --reject=jpg,php,pdf,png,ico,css,js,gif,xml --no-check-certificate -nc --tries=2 -np | sed -e 's/<[^>]*>//g'

wget https://www.abdn.ac.uk/registry/courses/undergraduate/$year/ -r --level=4 -e robots=off --reject=jpg,php,pdf,png,ico,css,js,gif,xml --no-check-certificate -nc --tries=2 -np | sed -e 's/<[^>]*>//g'

echo "Working on:"
echo "Course coordinators"

#get coordinators and courses---------------------------------------------------
#undergrad
grep -r -i -H 'courseheader\|coordinators\|"have a record of any course coordinators"' -A1 ./www.abdn.ac.uk/registry/courses/undergraduate/$year/ > $SCHOOL/$year/undergrad_courses.txt

#postgrad
grep -r -i -H 'courseheader\|coordinators\|"have a record of any course coordinators"' -A1 ./www.abdn.ac.uk/registry/courses/postgraduate/$year/ > $SCHOOL/$year/postgrad_courses.txt

#change working directory-------------------------------------------------------
current_dir=$PWD

cd $SCHOOL/$year

#Clean up lists-----------------------------------------------------------------
echo "Cleaning up text files"

#Strip HTML---------------------------------------------------------------------
sed -i '/<ul class="coordinators-list">\|<h1 class="courseheader">\|\-\-/d' *grad_courses.txt
sed -i -E 's/\('$year'\)//g' *grad_courses.txt
sed -i '/h1>\|text-muted\|Co-ordinators\|colspan=3/d' *grad_courses.txt
sed -i '/t.>\|<t.|\tbody>\|<ul\|ul>/d' *grad_courses.txt
sed -i '/Students\|During\|div\|<p><p>/d' *grad_courses.txt
sed -i 's/<li>\|<\/li>//g' *grad_courses.txt

#replace the colon with ^ seperator---------------------------------------------
sed -i 's/: /^ /' *courses.txt

#Trim whitespace----------------------------------------------------------------
tr -s [:space:] < undergrad_courses.txt > undergrad_courses2.txt
tr -s [:space:] < postgrad_courses.txt > postgrad_courses2.txt

#Seperate DPRS, Title, and coordinator------------------------------------------
cat undergrad_courses2.txt | grep '[A-Z]\{4,\}' > undergrad_DPRS_TITLE
cat undergrad_courses2.txt | grep '[a-z] [A-Z]' > undergrad_coordinator
cat postgrad_courses2.txt | grep '[A-Z]\{4,\}' > postgrad_DPRS_TITLE
cat postgrad_courses2.txt | grep '[a-z] [A-Z]' > postgrad_coordinator

#Remove any extraneous downloaded files-----------------------------------------
find . | grep '\.[0-9]' | xargs rm 2> /dev/null

echo "Done";

#return to BOCC directory-------------------------------------------------------
cd $current_dir

exit
