#!/bin/bash

for a in $(find ./) 
do
	if [-d "$a"] 
	then
		chmod 755 $a
	else
		chmod 644 $a
	fi
done
