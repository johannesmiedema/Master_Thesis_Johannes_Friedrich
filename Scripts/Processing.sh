#Script form Postprocessing unaligned dorado Bamfiles
#Optimzed for parallelization, 128 threads required

#Basecalled BamFiles from dorado
bams=$(ls *unaligned.bam)

#------------------------
####    ALIGNMENT    ####
#------------------------

#Reference Genome, using gencode v45 primary assembly
refgenome="GRCh38.primary_assembly.genome.fa.gz"

function align {
    echo $1 \ 
    samtools fastq -T '*' "$1" \
	| minimap2 -y --MD -ax splice -uf -k14 -t 32 $2 - 2> ${1/unaligned.bam/GChr38.log} \
	| samtools view -bh \
	| samtools sort -@32 - -o ${1/unaligned.bam/GChr38.bam} \
	samtools index ${1/unaligned.bam/GChr38.bam}
}

export -f align 
parallel -v -u --env align -j 4 align ::: $bams ::: $refgenome

#-------------------------------------------
#### Extract modififcations with Modkit ####
#-------------------------------------------

aligned=$(ls *.GChr38.bam)

function runModkitm6A {
    modkit pileup --threads 32 -r $2 --log-filepath ${1/GChr38.bam/modkit.bed} $1 ${1/GChr38.bam/GChr38.bed}
}
 export -f runModkitm6A



parallel -v -u --env runModkitm6A -j 4 runModkitm6A ::: $aligned

