#!/bin/bash

#Bashscript providing wrapped Basecalling Function 

threads=16
dorado="/home/johannes/Software/dorado-0.9.5-linux-x64/bin/./dorado"

function basecalling {
    $dorado basecaller \
    --estimate-poly-a -n 10000\
    --device "cuda:all" \
    sup,m6A_DRACH,pseU,m5C $1 > "$2"_unaligned.bam 2> "$2"_basecalling.log 
}

export -f basecalling

basecalling $1 
