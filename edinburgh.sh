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

#Edinburgh

echo "Edinburgh";
SCHOOL=Edinburgh
current_dir=$PWD

year=`echo $1 | sed 's/20//g'`

echo "Downloading Information.  This will take a while"
mkdir -p $SCHOOL/$year

#download course information----------------------------------------------------

wget -r --level=4 -e robots=off  --accept=htm --reject-regex '[a-z].htm' --no-check-certificate -nc -np www.drps.ed.ac.uk/$year

#Remove extraneous information--------------------------------------------------
rm www.drps.ed.ac.uk/$year/dpt/*[^0-9].htm
rm www.ed.ac.uk/profile/*student
for alpha in {a..z}; do
  sed -i -e '/Course secretary/,+2d' www.drps.ed.ac.uk/$year/dpt/cx$alpha*.htm
done

#change working directory
cd $SCHOOL/$year

#Strip out, sort, clean up, and join names and emails (from profile pages)------
echo "Working on:"
echo "Emails..."

#Strip out and clean up course organizer (from course pages)--------------------
echo "Courses..."
echo "Course Organiser..."
find ../../www.drps.ed.ac.uk/$year/dpt/ -type f | xargs grep -H "Course organiser<" > courseOrganiser.txt
find ../../www.drps.ed.ac.uk/$year/dpt/ -type f | xargs grep -H -L "Course organiser<" > NOcourseOrganiser.txt
sed -i 's/<td class="rowhead1"  width="15%">Course organiser<\/td><td width="35%">/^/g' courseOrganiser.txt
sed -i 's/<br>/^/g' courseOrganiser.txt
sort courseOrganiser.txt > COURSEORGANISER.txt
exit
#strip out and clean up telephone-----------------------------------------------
echo "Telephone Numbers..."
find ../../www.drps.ed.ac.uk/$year/dpt/ -type f | xargs grep -H "Tel" > Tel.txt
find ../../www.drps.ed.ac.uk/$year/dpt/ -type f | xargs grep -H -L "Tel" > NOTel.txt
sed -i 's/<b>Tel:<\/b>/^/g' Tel.txt
sed -i 's/<br>//g' Tel.txt
sed -i 's/ (/(/g' Tel.txt
sort Tel.txt > TEL.txt


#strip out and clean up email address-------------------------------------------
echo "Email Addresses..."
find ../../www.drps.ed.ac.uk/$year/dpt/ -type f | xargs grep -H "Email:" > Email.txt
find ../../www.drps.ed.ac.uk/$year/dpt/ -type f | xargs grep -H -L "Email:" > NOEmail.txt
sed -i 's/<b>Email:<\/b> /^/g' Email.txt
sed 's/<\/td>//g' Email.txt > EMAIL.txt

#strip out and clean up course title/number
echo "Course Titles and Numbers..."
find ../../www.drps.ed.ac.uk/$year/dpt/ -type f | xargs grep "<title>Course Catalog" > titleAndDRPS.txt
sed -i 's/<title>Course Catalogue - /^/g' titleAndDRPS.txt
sed -i 's/<\/title>//g' titleAndDRPS.txt
#sed -i 's/ (/^(/g' titleAndDRPS.txt

#split DRPS and title-----------------------------------------------------------
grep ') (' titleAndDRPS.txt > twoParens.txt
sed -i 's/) (/)^(/g' twoParens.txt
sed -i '/) (/d' titleAndDRPS.txt
sed -i 's/ (/^(/g' titleAndDRPS.txt
cat twoParens.txt >> titleAndDRPS.txt
sort titleAndDRPS.txt | uniq > uniqTitleAndDRPS.txt
cut -d ^ -f 1,3 uniqTitleAndDRPS.txt > DRPS.txt
cut -d ^ -f 1,2 uniqTitleAndDRPS.txt > TITLES.txt

#strip out and clean up course Semester (course start)--------------------------
echo "Semesters..."
find ../../www.drps.ed.ac.uk/$year/dpt/ -type f | xargs grep -i -A1 '>Course Start' > courseStart.txt
find ../../www.drps.ed.ac.uk/$year/dpt/ -type f | xargs grep -i -A1 -L '>Course Start' > NOcourseStart.txt
sed -i '/Course start date/,+1d' courseStart.txt
sed -i '/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}/d' courseStart.txt
grep colspan courseStart.txt > semester.txt
sort semester.txt > sortedSemester.txt
uniq sortedSemester.txt > uniqSemester.txt
sed -i 's/<\/td>//g' uniqSemester.txt
sed 's/-<td colspan="14">/:^/g' uniqSemester.txt > SEMESTER.txt

#strip out and clean up year (SCQF Level 7 (year 1 Undergraduate))--------------
echo "year..."
find ../../www.drps.ed.ac.uk/$year/dpt/ -type f | xargs grep 'Credit level' > year.txt
find ../../www.drps.ed.ac.uk/$year/dpt/ -type f | xargs grep -L 'Credit level' > NOyear.txt
sed -i 's/<\/td>//g' year.txt
sed -i 's/<td.*SCQF/^SCQF/g' year.txt
sort year.txt > sortedYear.txt
mv sortedYear.txt YEAR.txt

#join on file names-------------------------------------------------------------
export LC_ALL='C'

echo "Joining fields..."
join -t ^ -1 1 COURSEORGANISER.txt EMAIL.txt > OE.txt
join -t ^ -1 1 OE.txt TEL.txt > OET.txt
join -t ^ -1 1 OET.txt TITLES.txt > OETT.txt
join -t ^ -1 1 OETT.txt DRPS.txt > OETTD.txt
join -t ^ -1 1 OETTD.txt SEMESTER.txt > OETTDS.txt
join -t ^ -1 1 OETTDS.txt YEAR.txt > OETTDSY.txt
tr -s "^" < OETTDSY.txt > OETTDSYtrimmed.txt

#strip out reading list and prepend filename------------------------------------

echo "Reading List..."

for alpha in {a..z}; do
cp -n ../../www.drps.ed.ac.uk/$year/dpt/cx[$alpha]*.htm ../../www.drps.ed.ac.uk/$year/bak
done

for alpha in {a..z}; do
gawk -i inplace -v INPLACE_SUFFIX=.bak '/Reading List/{flag=1;next}/table/{flag=0;next} flag' ../../www.drps.ed.ac.uk/$year/dpt/cx[$alpha]*.htm
done

#add full path to filename for join matching and create readingList file--------
for alpha in {a..z}; do
awk '{print FILENAME,$0}' ../../www.drps.ed.ac.uk/$year/dpt/cx[$alpha]*.htm > readingList.txt
done

#clean up readingList-----------------------------------------------------------

sed -i 's/<tr>\|<td>\|<\/td>\|<\/tr>\|<br \/>//g' readingList.txt
sed -i 's/htm[^l]/htm:^/g' readingList.txt
sed -i '/htm:\^[ ]*$/d' readingList.txt
sed -i 's/\^ [0-9]*\./^ /g' readingList.txt
tr -s "-" < readingList.txt > readingList2.txt
mv readingList2.txt readingList.txt
join -t ^ -1 1 DRPS.txt readingList.txt > DRPSreadingList.txt



#clean up folder
echo "Cleaning up..."
rm -R ../../www.drps.ed.ac.uk/$year/dpt/
cp -R ../../www.drps.ed.ac.uk/$year/bak/ ../../www.drps.ed.ac.uk/$year/dpt/
echo "Done"

#return to BOCC directory
cd $current_dir

exit
