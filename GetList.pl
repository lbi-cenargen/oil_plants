#!/usr/bin/perl
#
# This script read each KEGG pathway file and create a batch file to download the fasta
# files from KEGG API. This is because the API alows to download only 10 sequences per transaction
# This script create a batch file to download the sequences. 10 each wget command
# This program is part of the ** Build_KEGG_Database.bash ** file
# Roberto Togawa
# jul/2020
#
#

if($#ARGV < 0){
print "Usage: GetList.pl <kegg file>file\n";exit}

$file = $ARGV[0];
@arq = `awk '{print \$1}' $file`;
$org = substr($file,0,3);
$gene = `grep ^GENE $file`;
$gene =~ s/\s+/\ /g;
($head,$first) = split(/\ /,$gene);
$d = $#arq;
$cmd = "";

###### Loop de leitura #######
for ($i=0; $i<=$#arq; $i++) {
  $s = $arq[$i];
  chop $s;
  $ct=0;
  $nro=0;
  if ($s eq "GENE") {
   	$cmd =  "\nwget http://rest.kegg.jp/get/$org:$first+";
	for ($k=$i+1; $k<=$#arq; $k++) {
		 $g = $arq[$k];
		 chop $g;
		 if ($g =~ "COMPOUND") {last;}
		 $ct++;
		 if ($ct > 9) {
			 $ct=0;
		 	 $nro++;
			 chop $cmd;
			 $cmd = $cmd . "/aaseq";
			 print $cmd;
			 print "\nmv aaseq $file-aaseq$nro.fa\n\n";
			 $cmd = "wget http://rest.kegg.jp/get/";
		 }
		 $cmd = $cmd . "$org:$g+";
	}
	$nro++;
	chop $cmd;
	$cmd = $cmd . "/aaseq";
	print "$cmd\nmv aaseq $file-aaseq$nro.fa\n\n";
  }

}

