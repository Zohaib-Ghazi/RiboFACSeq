#!/bin/bash
export bbmp=/media/sf_LinuxDirectory/bbmap/bbmap/
export ref_index=/media/sf_LinuxDirectory/DeepSequencing/BW25113_Index/
export subread=/media/sf_LinuxDirectory/DeepSequencing/Subread/subread-1.5.3-Linux-x86_64/bin/
export picard=/media/sf_LinuxDirectory/
 
mkdir -p ./{Trimmed_Reads,Untrimmed_Reads,Aligned_Pairs,Unaligned_Pairs,Reads2Count,featureCounts_Output};

# For read mapping, an index of the bacterial genome is initialized.
$bbmp/bbmap.sh ref=$ref_index/BW25113.fasta path=$ref_index;

for file in *R1_001.fastq.gz;
	do
	# The specified adapters from both the 5' and 3' ends of paired-end reads are removed using BBDuk of BBTools.
	$bbmp/bbduk.sh -Xmx1g in1=${file} in2=${file/R1_001.fastq.gz/R2_001.fastq.gz} out=stdout.fq ktrim=r rcomp=f k=22 hdist=2 edist=2 hdist2=1 edist2=1 mink=12 literal=CTGTCTCTTATACACATCTCAA tpe tbo 2>./Trimmed_Reads/${file/R1_001.fastq.gz/Trimming_Stats.txt} | \
	$bbmp/bbduk.sh -Xmx1g in=stdin.fq out=stdout.fq ktrim=l rcomp=f k=22 hdist=2  edist=2 hdist2=1 edist2=1 mink=12 literal=TTGAGATGTGTATAAGAGACAG int=t tpe tbo 2>>./Trimmed_Reads/${file/R1_001.fastq.gz/Trimming_Stats.txt} | \
	$bbmp/bbduk.sh -Xmx1g in=stdin.fq out=stdout.fq ktrim=l rcomp=f k=31 hdist=3 edist=2 hdist2=1 edist2=1 mink=12  literal=CAAGGTAGAGCAGGGTTTAGGAGAGAGGATC int=t tpe tbo 2>>./Trimmed_Reads/${file/R1_001.fastq.gz/Trimming_Stats.txt} | \
	$bbmp/bbduk.sh -Xmx1g in=stdin.fq outm1=./Untrimmed_Reads/${file/R1_001.fastq.gz/Failed_R1.fastq} outm2=./Untrimmed_Reads/${file/R1_001.fastq.gz/Failed_R2.fastq} out1=./Trimmed_Reads/${file/R1_001.fastq.gz/Trimmed_Pairs_R1.fastq} out2=./Trimmed_Reads/${file/R1_001.fastq.gz/Trimmed_Pairs_R2.fastq} ktrim=r rcomp=f k=31 hdist=3 edist=2 hdist2=1 edist2=1 mink=12 minlen=13 literal=GATCCTCTCTCCTAAACCCTGCTCTACCTTG int=t tpe tbo 2>>./Trimmed_Reads/${file/R1_001.fastq.gz/Trimming_Stats.txt};
	
	# The trimmed paired-end reads are aligned to the reference genome using BBMap of BBTools.
	$bbmp/bbmap.sh path=$ref_index in1=./Trimmed_Reads/${file/R1_001.fastq.gz/Trimmed_Pairs_R1.fastq} in2=./Trimmed_Reads/${file/R1_001.fastq.gz/Trimmed_Pairs_R2.fastq} outm=./Aligned_Pairs/${file/R1_001.fastq.gz/Aligned_Pairs.sam} outu=./Unaligned_Pairs/${file/R1_001.fastq.gz/Unaligned.fastq} killbadpairs=t pairedonly=t 2>./Aligned_Pairs/${file/R1_001.fastq.gz/Alignment_Stats.txt};

	# The R2 reads of each paired-end alignment are separated according to their orientation relative to the knock-in site using SAMtools.
	# Based on the library design, if the R2 read of a pair aligns to the DNA template (i.e. sense strand) in the 'reverse complement' direction, then this read pair should be located upstream (i.e. on the left-handed side) of the knock-in site.
	# Alternatively, if the R2 read of a pair aligns to the DNA template without reverse complementing, then this read pair should be located downstream of it (i.e. on the right-handed side of the knock-in).
	# Below, the R2 reads that align in the 'antisense orientation' are isolated.
	samtools view -h -F 4 ./Aligned_Pairs/${file/R1_001.fastq.gz/Aligned_Pairs.sam}| \
	awk '{if (NR<4) print $0}; {if ($3==147) print $0}' | \
	samtools view -bu - | \
	samtools sort -o ./Reads2Count/${file/R1_001.fastq.gz/Antisense_Orientation.bam} -;

	# The R2 reads of each paired-end alignment are separated according to their orientation relative to the knock-in site using SAMtools.
	# Based on the library design, if the R2 read of a pair aligns to the DNA template (i.e. sense strand) in the 'reverse complement' direction, then this read pair should be located upstream (i.e. on the left-handed side) of the knock-in site.
	# Alternatively, if the R2 read of a pair aligns to the DNA template without reverse complementing, then this read pair should be located downstream of it (i.e. on the right-handed side of the knock-in).
	# Below, the R2 reads that align in the 'sense orientation' are isolated.
	samtools view -h -F 4 ./Aligned_Pairs/${file/R1_001.fastq.gz/Aligned_Pairs.sam} | \
	awk '{if (NR<4) print $0}; {if ($3==163) print $0}'| \
	samtools view -bu - | \
	samtools sort -o ./Reads2Count/${file/R1_001.fastq.gz/Sense_Orientation.bam} -;

	# Depending on the orientation of an R2 read's alignment (see above), the aligned reads are reduced to their left-most or right-most base position prior to read counting. 
	$subread./featureCounts -d 15 -D 600 --read2pos 5 -t CDS -g gene_name -R SAM -a $ref_index/bbmap_BW25113.gtf -o ./featureCounts_Output/${file/R1_001.fastq.gz/AntiSense_Orient.txt} ./Reads2Count/${file/R1_001.fastq.gz/Antisense_Orientation.bam} 2>&1 | tee ./featureCounts_Output/${file/R1_001.fastq.gz/Antisense_Orient_Summary.txt}; 
	$subread./featureCounts -d 15 -D 600 --read2pos 3 -t CDS -g gene_name -R SAM -a $ref_index/bbmap_BW25113.gtf -o ./featureCounts_Output/${file/R1_001.fastq.gz/Sense_Orient.txt} ./Reads2Count/${file/R1_001.fastq.gz/Sense_Orientation.bam} 2>&1 | tee ./featureCounts_Output/${file/R1_001.fastq.gz/Sense_Orient_Summary.txt};

	# (Optional) Create a sorted bam file and index of the aligned read pairs to isolate those that span across a specified region of the genome.
	samtools view -buh -F 4 ./Aligned_Pairs/${file/R1_001.fastq.gz/Aligned_Pairs.sam} | \
	samtools sort -o ./Aligned_Pairs/${file/R1_001.fastq.gz/Aligned_Pairs.bam} -;
	samtools index ./Aligned_Pairs/${file/R1_001.fastq.gz/Aligned_Pairs.bam};
done 