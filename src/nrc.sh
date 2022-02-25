#!/bin/ash

# If supplying two vcfs
if [ "$#" -eq 2 ]; then
    bcftools stats -s -       $1 $2 > /tmp/bcfstats
# Else if supplying a third vcf/site file, only look at those sites
elif [ "$#" -eq 3 ]; then
    bcftools stats -s - -T $3 $1 $2 > /tmp/bcfstats
else
    echo "Usage: nrc.sh <vcf1.vcf.gz> <vcf2.vcf.gz> [targets]"
    exit 1
fi

# Run the R script, which writes a new file to /tmp/bcfstats.tsv, then cat that output
Rscript /src/nrc.R
cat /tmp/bcfstats.tsv