---
layout: post
title: README
date: '2017-01-19 22:08'
---

BOCC is the Blackwells Online Course Collector

Installation:
  -For Linux and MacOS:
    Visit https://github.com/mrknickerbocker/BOCC
    "Clone or download" the files

    Unzip in the desired directory.

    The program can be run in the directory it is stored in by using
    'chmod +x *.sh'
    to make the files executable, then
    './bocc.sh' to run

  -For Windows:
    This code is based on a shell script.  As such, to work on Windows it requires
    the installation of a linux terminal emulator. It has been tested on Cygwin (on Windows 7).
    You can find Cygwin and instructions for installation here: https://cygwin.com/install.html
      In addition to the base installation, the "wget" module must be installed.
      Afterwards, continue installation as in the "For Linux and MacOS" section

Execution:
  After running the program, you will be greeted and prompted to choose the
  appropriate school and then the relevant year.  The program will then run, and
  inform you when it has finished.  The output, including logs, will be stored
  in subfolders, first by school name and then by year.  There will be a variety of files
  created, but you will be most interested in the OETTDSYtrimmed.txt and DRPSreadingList.txt
  files.
