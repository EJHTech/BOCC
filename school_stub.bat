#!/bin/sh
#Blackwell's Online Course Collector
#Version 0.1
#Eric Hofrichter
#School Stub
#
#Aberdeen function
if (( $school==1 )); then
	echo "Aberdeen"

	#rip website
	echo "Downloading Information.  This will take a while"

	echo "Working on:"
        echo "Course coordinators"

	#get coordinators and courses
	#undergrad

	#postgrad

	#Clean up lists
	echo "Cleaning up"

	echo "Edinburgh";

	#get profile pages for everyone

	#download course information

	#Remove extraneous information

	#Strip out, sort, clean up, and join names and emails (from profile pages)
	echo "Working on:"
	echo  "Emails..."

	#Remove secretary from course pages (conflicts with contact information scraping)

	#Strip out and clean up Subject

	#Strip out and clean up course organizer (from course pages)
	echo "Courses..."
	echo "Course Organiser..."

	#strip out and clean up telephone
	echo "Telephone Numbers..."

	#strip out and clean up email address
	echo "Email Addresses..."

	#strip out and clean up course title/number
	echo "Course Titles and Numbers..."

	#split DRPS and title

	sort titleAndDRPS.txt | uniq > uniqTitleAndDRPS.txt

	#strip out and clean up course Semester (course start)
	echo "Semesters..."

	#strip out and clean up year (SCQF Level 7 (Year 1 Undergraduate))
	echo "Year..."

	#join on file names

	echo "Joining fields"

	#strip out reading list and prepend filename
	echo "Reading List"

	#add full path to filename for join matching and create readingList file

	#clean up readingList

	export LC_ALL='C'

	#clean up folder
