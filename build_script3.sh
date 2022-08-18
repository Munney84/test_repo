#!/bin/bash

# Title		:build_script3
# Description	:This script will securely create a git user and push any
#			changes to any branch but main automatically.
# Author	:Clarence Munn
# Date		:08-15-2022
# Version	: 1
# Usage		: ./build_script3.sh
# Notes		:script requires that you are already connected to a git branch

#=======================================================================
shell=/bin/bash

if [ $UID != 0 ];

then
echo "You must have sudo priveledges"
exit 1

else
echo "which group will we be using?"
read group

#using the group add command with the -f option to create a group if a group
#doesn't already exist

groupadd -f $group 

echo "What is your First and Last name?"
read name1

echo "Please type in a password"
read password

#taking the information gathered and placing it into a file

echo "$name1:$shell:$group:$password" >> GitAcc_users.txt

user_name=$(cat GitAcc_users.txt | head -c 1 && cat GitAcc_users.txt | cut -d ":" -f 1 | awk '{print $2}')

echo "Your user name is $user_name"

useradd -m -g $group -s $shell $user_name

echo $user_name:$password | chpasswd

fi
exit 0

echo "============================================"
sleep 1

echo "Now checking for sensitive information"

# Searching the file for keywords, -i option says to ignore case sensitivity

results1=$(grep -i '.com\|.net\|.org\|ssn\|cell\|phone\|email' GitAcc_users.txt)

#results 1 = keyword search

# Searching the file for line of numbers 9 and 10 characters long, -x option says to match the whole line
results2=$(grep -x '[0-9]\{9\}\|[0-9]\{10\}' GitAcc_users.txt)

#results 2 = SSN no dashes and phone numbers no dashes
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

if [[ -z $results1 && -z $results2 ]];

then
 
echo "No sensitive information found. Would you like to ADD and COMMIT the changes?"
echo "Please enter y / n"

read ADDans

	ADDans1=$(echo $Addans | head -c 1 | tr [A-Z] [a-z]

	if [[ $Addans1 == "y"]];
	then
	echo "Adding and committing changes made to GitAcc user group"
	git add GitAcc_users.txt
	sleep 1
	git commit -m " $(date) "
	echo "Completed!!"
	exit 0
	else
	echo "Information will be stored locally and has not been aded or committed."
	fi
	exit 0
else
echo "This file contains information that may be sensitive."
echo "Please review and consider encryption prior to sending"
exit 0

