#!/bin/bash

function displayHelp(){

	echo "Proper usage is: "
	echo "	./create_google_year_dir <output-dir> "
	exit 0
}


gms=gms
gmgz=gm.gz

function splitter(){
	while read data; do
		splitLine=( $data )
		year=${splitLine[$currentN]}
		gram=("${splitLine[@]:0:$currentN}")
		freq=${splitLine[$(($currentN + 1))]}
		foldername=$outputdir/$year/$currentN$gms
		mkdir -p $foldername
		filename=$foldername/$currentN$gmgz
		echo "$gram $freq" | gzip >> $filename
	done
	}

function execute(){
	source py3env/bin/activate

	for i in {1..5}; do
		currentN=$i
		echo "Downloading $currentN - grams"
		google-ngram-downloader readline -l $language -n $i | splitter
	done

}


if [ -z "$1" ]; then
	displayHelp
fi

outputdir=$1
language='eng-us'
currentN=1


if [ ! -d "$outputdir" ]; then
    echo "Output directory does not exist."
    while true; do
        read -p "Do you wish to create it? " yn
        case $yn in
            [Yy]* ) mkdir $outputdir ; break;;
            [Nn]* ) echo "exiting..."; exit;;
            * ) echo "Please enter yes or no";;
        esac
    done
fi

execute
