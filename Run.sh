#!/bin/bash
FILE_FASTA="all_chr_t0,45_w501.txt";
FILE_FASTQ_DENISOVA="~/DATABASE/DENISOVA/DENI";
FILE_FASTQ_NEANDERTAL="~/DATABASE/NEANDERTHAL/FASTQ/NEAN.fq";
#
GET_KESTREL=1;
GET_GOOSE=1;
#
RUN_GOOSE=1;
RUN_KESTREL=1;
#==============================================================================
if [[ "$GET_KESTREL" -eq "1" ]]; then
  git clone https://github.com/pratas/kestrel.git
  cd kestrel/src/
  cmake .
  make
  cd ../../
  cp kestrel/src/KESTREL .
fi
#==============================================================================
if [[ "$GET_GOOSE" -eq "1" ]]; then
  git clone https://github.com/pratas/goose.git
  cd goose/src/
  make
  cd ../../
  cp goose/src/goose-* .
fi
#==============================================================================
if [[ "$RUN_GOOSE" -eq "1" ]]; then
  rm -f out*.fa
  ./goose-splitreads < $FILE_FASTA
fi
#==============================================================================
if [[ "$RUN_KESTREL" -eq "1" ]]; then
  for f in out*.fa
    do
    echo "Running $f ...";
    ./KESTREL -n 4 -v -l 5 -t 0.5 -o $f-DENISOVA.fq $f $FILE_FASTQ_DENISOVA
    ./KESTREL -n 4 -v -l 5 -t 0.5 -o $f-NEANDERTAL.fq $f $FILE_FASTQ_NEANDERTAL
    cat $f-DENISOVA.fq $f-NEANDERTAL.fq > ALL-$f-x.fq
    rm -f $f-DENISOVA.fq $f-NEANDERTAL.fq;
    gzip ALL-$f-x.fq
    done
fi
#==============================================================================

