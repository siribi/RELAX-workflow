#!/bin/bash
FALIST=`ls -1 *.fasta`
i=1
for FAFILE in $FALIST
        do
        FILEBASE=$(echo $FAFILE | cut -f1 -d.)
        echo $FILEBASE 
	sed -i '/^>/ s/_.*//' $FILEBASE.guidance.edit.fasta
	done
