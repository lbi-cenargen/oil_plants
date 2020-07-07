# Oil plants RNASeq analysis pipeline

This is a part of Embrapa Genetic Resources and Biotecnology research bulletin called : xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Here you can find a description of the commands used to describe this bulletin.

### pre-processing
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
### Transcritome assembly

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

##### creating index
```sh
$ STAR --runThreadN 10 --runMode genomeGenerate --genomeDir [output PATH] --genomeFastaFiles [reference genome file (fasta file)]
```
##### running star
```sh
$ STAR --runThreadN 10 --genomeDir [outuput PATH] --sjdbGTFfile [GTF file] --sjdbOverhang 100 --readFilesIn [INPUT_R1_clipped_cutadapt.fastq] [INPUT_R2_clipped_cutadapt.fastq] --outSAMtype BAM SortedByCoordinate Unsorted --outReadsUnmapped Fastx --outFileNamePrefix [output prefix name] --quantMode TranscriptomeSAM
```
