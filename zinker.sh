#! /bin/bash

######
# 
# @Author Irfan Durmus
# zinker - RapidShare downloader
#
# http://irfandurmus.com/projects/zinker/
# http://github.com/irfan/zinker/
#
# @Last Change: 
# 02 Agust 2012
#
# @Usage:
# ./zinker.sh username password myfiles.txt
#
######

# global variables

USERNAME=$1
PASSWORD=$2
FILE_LIST=$3

PWD=`pwd`/
TMP="$PWD"tmp/
DLFOLDER="$PWD"downloads

COOKIEFILE="$TMP""cookie-"`date +%Y%m%d%H%M%S`".txt"
LOGFILE="$TMP"log-`date +%Y%m%d%H%M%S`.txt


function GET_HELP () {
	    echo '=========================================='
	    echo "Usage : $0 <username> <password> <rapidurls.txt>"
	    echo ''
	    echo 'Arguments :'
	    echo '___________'
	    echo 'username        your rapidshare username'
	    echo 'password        your rapidshare password'
	    echo 'rapidurls.txt   which file contain rapid download urls per line'
		echo '=========================================='
		echo 'You can find us on github: http://github.com/irfan/zinker/'
}

function START_DOWNLOAD () {
	
	# if there are no 3 param, show help message
	if [ $# -ne 3 ]; then
		GET_HELP
		exit 1
	fi
	
	# check the url file whether exist
	if [ ! -f $FILE_LIST ]; then
		echo "$FILE_LIST is not a file. Plesae specify a file path which is storing rapidshare links."
		exit 1;
	fi
	
	# if the directory is not writable
	if [ ! -w . ]; then
	    echo "$USER user is not have permission to write this directory"
	    exit 1;
	fi
	
	# create tmp directory if no exists
	if [ ! -d $TMP ]; then
	    mkdir $TMP
		echo "Created : $TMP"
	fi
	
	# create download directory if no exists
	if [ ! -d $DLFOLDER ]; then
	    mkdir $DLFOLDER
		echo "Created : $DLFOLDER"
	fi
	
	GET_COOKIE # if everything going well get the cookie

}


function GET_COOKIE() {
	
	`curl -o $COOKIEFILE "https://api.rapidshare.com/cgi-bin/rsapi.cgi?sub=getaccountdetails&withcookie=1&login=$USERNAME&password=$PASSWORD" &>/dev/null`
	
	if [ ! -f $COOKIEFILE -o `grep cookie $COOKIEFILE | wc -l | tr -d ' '` -ne 1 ]; then
		LOGGER "We couldn't sign in to rapidshare api, the given username and password could be wrong or somethings going wrong with this script."
		exit 1;
	fi
	
	DOWNLOAD_FILES # lets call the method to start download the files
}

function DOWNLOAD_FILES() {
	COOKIE=`grep cookie $COOKIEFILE | cut -d '=' -f2`
	ADDITION=1;
	LINKS=0
	DOWNLOADED=0
	PASSED=0
	ERROR=0
	
	for i in `cat $FILE_LIST`;
	do
		# count how many links we have
		LINKS=$(($LINKS + $ADDITION));
		
		# get original filename that we can save the file with same name
		FILE=`echo $i | rev | cut -d '/' -f1 | rev`
		FILE="$DLFOLDER/$FILE";
		
		# if we have a file with same name, pass it!
		if [ -f $FILE ]; then
			PASSED=$(($PASSED + $ADDITION));
			LOGGER "PASSING: The file already exist.. $i > $FILE";
		fi
		
		# if we dont have file, start download
		if [ ! -f $FILE ]; then
			LOGGER "Download started : $i > $FILE";
			`wget --no-check-certificate --no-cookies -O $FILE --header="Cookie: enc=$COOKIE" $i &>/dev/null`
			
			# if file downloaded, log and increase the variable
			if [ -f $FILE ]; then
				# TODO: We should check file size to be sure is the file downloaded completely
				DOWNLOADED=$(($DOWNLOADED + $ADDITION));
				LOGGER "Download finised : $i > $FILE"
			else
				# if we dont have file, then we have trouble
				ERROR=$(($ERROR + $ADDITION));
				LOGGER "ERROR: We got error, exiting... : $i > $FILE";
				
				PUT_SUMMARY $LINKS $DOWNLOADED $PASSED $ERROR $DLFOLDER $LOGFILE $COOKIEFILE
				exit 1;
			fi
		fi
		
		
	done
	
	# Show the results and save to the log file
	PUT_SUMMARY $LINKS $DOWNLOADED $PASSED $ERROR $DLFOLDER $LOGFILE $COOKIEFILE
	
}

function LOGGER () {
	local STR="`date "+%Y-%m-%d %H:%M:%S"` $1"
	
	if [ ! -f $LOGFILE ]; then
		`touch $LOGFILE`
		echo "Created : $LOGFILE"
	fi
	
	`echo $STR >> $LOGFILE`
	echo $STR
}

function PUT_SUMMARY () {
	local LINKS=$1
	local DOWNLOADED=$2
	local PASSED=$3
	local ERROR=$4
	local DLFOLDER=$5
	local LOGFILE=$6
	local COOKIE=$7
	
	LOGGER "Download finished, here is the summary :"
	LOGGER "________________________________________"
	LOGGER "Total Links       : $LINKS"
	LOGGER "Downloaded        : $DOWNLOADED"
	LOGGER "Passed            : $PASSED"
	LOGGER "Error             : $ERROR"
	LOGGER "Download Folder   : $DLFOLDER"
	LOGGER "Log File          : $LOGFILE"
	LOGGER "Used cookie       : $COOKIEFILE"
	LOGGER "________________________________________"
}


START_DOWNLOAD	$USERNAME $PASSWORD $FILE_LIST 	# check the directories are exists 

