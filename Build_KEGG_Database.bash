#!/bin/bash
#
# To run this script you need a file with KEGG code and a blast search database name
# Roberto Togawa / jul/2020
#

KEGGList=$1
DBNAME=$2
if [ -z "$DBNAME" ]
then
	dbname="ALL_organism.fa"
else
	dbname="ALL_"$DBNAME".fa"
fi

if [ ! -f "$KEGGList" ]; then
    echo "file $KEGGList does not exist."
    exit
fi

echo "downloading files..."
for i in `cat $KEGGList`;do wget http://rest.kegg.jp/get/$i;done

echo "Creating directories for each code"
for i in `cat $KEGGList`; do mkdir dir_$i;done

echo "moving downloaded files do each code"
for i in `cat $KEGGList`; do mv $i dir_$i;done

echo "Preparing a sh file to download the fasta files for each Gene entry"
echo "The KEGG API alow to download only 10 sequences per transaction"
echo "This script create a batch file to download the sequences. 10 each wget command"
for i in `cat $KEGGList`; do cd dir_$i;../GetList.pl $i > runMeGet$i.sh;cd ..;done

echo "Download a fasta file for each Gene entry"
for i in `cat $KEGGList`; do cd dir_$i;sh runMeGet$i.sh;cd ..;done

echo "Join each fasta file in only one with all sequences"
for i in `cat $KEGGList`; do cd dir_$i;cat *.fa > All.$i.fa;cd ..;done

echo "Join all sequences in one file for the current organism"
for i in `cat $KEGGList`; do cat dir_$i/All.$i.fa >> $dbname;done

echo "indexing the database for blast search"
makeblastdb -in $dbname -dbtype prot



