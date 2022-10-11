#!/bin/bash
set -e

# -s samplename  (passed to bcftools -s/--sample)
# -T targetsfile (passed to bcftools -T/--targets-file)
while getopts "s:T:" opt; do
  case $opt in
    s) sample="$OPTARG";;
    T) targets="$OPTARG";;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1;;
  esac

  case $OPTARG in
    -*) echo "Option $opt needs a valid argument"
    exit 1
    ;;
  esac
done

# VCFs are positional arguments
vcf1=${@:$OPTIND:1}
vcf2=${@:$OPTIND+1:1}


# Check that VCFs are supplied
if [ -z "$vcf1" ] || [ -z "$vcf2" ]; then
    echo "Usage: nrc.sh [-s sample] [-T targets.vcf.gz] <1.vcf.gz> <2.vcf.gz>"
    exit 1
fi 

# If VCFs don't exist throw error
if [ ! -f "$vcf1" ]; then echo "VCF $vcf1 does not exist!"; exit 1; fi
if [ ! -f "$vcf2" ]; then echo "VCF $vcf2 does not exist!"; exit 1; fi

# If targets file was supplied but doesn't exist, throw an error
if [ ! -z "$targets" ] && [ ! -f "$targets" ]; then echo "Targets file $targets does not exist!"; exit 1; fi

# if you didn't define a targets file, then targets becomes "", else it becomes "-T targetsfile"
if [ -z "$targets" ]; then 
    targets=""
else
    targets="-T $targets"
fi

# if you didn't define a sample, then sample becomes "-s -", else it becomes "-s sample"
if [ -z "$sample" ]; then 
    sample="-s -"
else 
    sample="-s $sample"
fi

# Run the command
bcftools stats --collapse all $sample $targets $vcf1 $vcf2 > /tmp/bcfstats

# Run the R script, which writes a new file to /tmp/bcfstats.tsv, then cat that output
Rscript /src/nrc.R
cat /tmp/bcfstats.tsv
