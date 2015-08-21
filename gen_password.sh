#!/bin/bash
# generates passwords easily
# usage "gen_password <length>"
# tries to use best practices for passwords
# default length is 16

LENGTH=16
RET=0

# check arguments
if [[ $# -ne 0 ]]; then
	LENGTH=$1

	if [[ $1 -eq "-h" || $# -gt 1 ]]; then
		echo
		echo "Usage: gen_password <length>"
		echo
		exit
	fi
fi

# generate passwords
pwgen -ysBv $LENGTH 

