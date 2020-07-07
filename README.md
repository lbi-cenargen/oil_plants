# oil_plants
Oil plants RNASeq analysis pipeline

This is a part of Embrapa Genetic Resources and Biotecnology research bulletin called : xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Here you can find a description of the commands used to describe this bulletin.

### pre-processing
In this project three species are used in the study: *E. guineensis, J. curcas, R. communis*

The following files are used for the processing:

E. guineensis | J. curcas | R. communis
------------ | ------------- | -------------
elaeis_guinnensis_R1.fastq | jatropha_sp_R1.fastq | ricinus_communis_R1.fastq| 
elaeis_guinnensis_R2.fastq | jatropha_sp_R2.fastq | ricinus_communis_R2.fastq



### pre-processing

#### [fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) - A quality control tool for high throughput sequence data 

```sh
$ fastqc elaeis_guinnensis_R1.fastq elaeis_guinnensis_R2.fastq
or
$ fastqc elaeis_guinnensis_R*
```
