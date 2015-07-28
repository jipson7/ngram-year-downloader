#!/bin/bash

function displayHelp(){

	echo "Proper usage is: "
	echo "	./create_google_year_dir <output-dir> <input-dir>"
	exit 0
}


gms=gms
gmgz=gm-0001.gz
gm=gm

function splitter(){
	while read data; do
		splitLine=( $data )
		year=${splitLine[$currentN]}
		gramSplit=("${splitLine[@]:0:$currentN}")
		gram="${gramSplit[@]}"
		freq=${splitLine[$(($currentN + 1))]}
		foldername=$outputdir/$year/$currentN$gms
		mkdir -p $foldername
		if [ "$currentN" -eq 1 ]; then
			filename=$foldername/vocab_cs
			touch $filename
			echo "$gram $freq" >> $filename
		else
			filename=$foldername/$currentN$gmgz
			touch $filename
			echo "$gram $freq" | gzip >> $filename
		fi

	done
}

function zipOneGrams(){
	fileConst=1gms/vocab_cs
	for d in $outputdir/*/; do
        $filename = $d$fileConst
        sort -k2 -r -n -o $filename $filename
		gzip $filename
	done
}

function execute(){
	source env/bin/activate

	for i in {1..5}; do
		currentN=$i
		echo "Splitting $currentN - grams"
        dirname=$inputdir/$i$gms 
        for f in $dirname/*.gz; do
            zcat $f | splitter
        done
		if [ "$currentN" -eq 1 ]; then
			zipOneGrams
		fi
	done

}


if [ -z "$1" ] && [ -z "$2" ]; then
	displayHelp
fi

outputdir=$1
inputdir=$2
currentN=1

if [ ! -d "$inputdir" ]; then
    echo "Input directory does not exist."
    exit 0
fi

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
