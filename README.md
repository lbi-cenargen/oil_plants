# Oil plants RNASeq analysis pipeline

This is a part of Embrapa Genetic Resources and Biotecnology research bulletin called : "Combinação de abordagens de análises de novo e guiadas pelo genoma para explorar dados de RNA-Seq de sementes oleaginosas para anotação de vias de ácidos graxos".
Here you can find a description of the commands used to describe this bulletin.

---

## Pre-processing

---

In this project three species are used in the study: *E. guineensis, J. curcas, R. communis*

The following files are used for the processing:

E. guineensis | J. curcas | R. communis
------------ | ------------- | -------------
elaeis_guinnensis_R1.fastq | jatropha_sp_R1.fastq | ricinus_communis_R1.fastq|
elaeis_guinnensis_R2.fastq | jatropha_sp_R2.fastq | ricinus_communis_R2.fastq

#### [fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) - A quality control tool for high throughput sequence data

```sh
$ fastqc INPUT_R1.fastq INPUT_R2.fastq
or
$ fastqc INPUT_R*
```

#### [cutadapt](https://cutadapt.readthedocs.io/en/stable/) - Cutadapt finds and removes adapter sequences, primers, poly-A tails and other types of unwanted sequence from your high-throughput sequencing reads.

```sh
$ cutadapt -a AGATCGGAAGAG  -A AGATCGGAAGAG -o INPUT_R1_clipped_cutadapt.fastq  -p INPUT_R2_clipped_cutadapt.fastq  -f fastq --minimum-length=16 INPUT_R1_clipped.fastq INPUT_R2_clipped.fastq
```
---

### Transcritome assembly

---

The following files are used for the processing:

E. guineensis | J. curcas | R. communis
------------ | ------------- | -------------
elaeis_guinnensis_R1_clipped.fastq | jatropha_sp_R1_clipped.fastq | ricinus_communis_R1_clipped.fastq|
elaeis_guinnensis_R2_clipped.fastq | jatropha_sp_R2_clipped.fastq | ricinus_communis_R2_clipped.fastq

#### Velveth/Oases

```sh
$ velveth [nº k-mer] -fastq -shortPaired INPUT_R1_clipped_cutadapt.fastq INPUT_R2_clipped_cutadapt.fastq
```

#### HISAT2
```sh
$ hisat2 -x [hisat index PATH] -1 INPUT_R1_clipped_cutadapt.fastq -2 INPUT_R2_clipped_cutadapt.fastq
```

#### SPAdes
```sh
$ python spades.py -o [output PATH] --rna -1 INPUT_R1_clipped_cutadapt.fastq  -2 INPUT_R2_clipped_cutadapt.fastq  -k [nº k-mer]
```

#### SOAP
```sh
$ SOAPdenovo-Trans-31mer all -s [config file] -o [output PATH] -p 10 -M 1
```

#### STAR

##### creating star index
```sh
$ STAR --runThreadN 10 --runMode genomeGenerate --genomeDir [output PATH] --genomeFastaFiles [reference genome file (fasta file)]
```
##### running star
```sh
$ STAR --runThreadN 10 --genomeDir [outuput PATH] --sjdbGTFfile [GTF file] --sjdbOverhang 100 --readFilesIn [INPUT_R1_clipped_cutadapt.fastq] [INPUT_R2_clipped_cutadapt.fastq] --outSAMtype BAM SortedByCoordinate Unsorted --outReadsUnmapped Fastx --outFileNamePrefix [output prefix name] --quantMode TranscriptomeSAM
```
---

### Evidence Directed Gene Construction

---

#### [Evidential Gene](http://arthropods.eugenes.org/about/about-EvidentialGene/)

The input for this method is the resulting assembly for the previous steps.
To prepare the input for EvidentialGene, the trformat.pl script was used

```sh
EvidentialGene_dir/scripts/rnaseq/trformat.pl -output all.tr  -input transcripts.fasta[.gz]  tr2.fasta  tr3.fasta etc
```

After this step, the method is called as following
```sh
EvidentialGene_dir/scripts/prot/tr2aacds2.pl -mrnaseq ALL_transcripts.fasta
```
---

### Completeness analysis

---

#### [BUSCO](https://busco.ezlab.org/)
"BUSCO attempts to provide a quantitative assessment of the completeness in terms of expected gene content of a genome assembly, transcriptome, or annotated gene set"

For the input to run BUSCO we used the result of Evidential Gene for each Transcriptome. The used command is as following:

```sh
BUSCO_V3/scripts/run_BUSCO.py -m tran -o <output PATH> -i <input PATH> -l /BUSCO_V3/datasets/embryophyta_odb9 -c 10
```
