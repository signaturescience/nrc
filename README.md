# Non-reference concordance

Build:

```sh
git clone git@github.com:signaturescience/nrc.git
cd nrc
docker build --no-cache -t nrc .
```

Usage:

```sh
docker run --rm -v $(pwd):$(pwd) -w $(pwd) nrc exampledata/a.vcf.gz exampledata/b.vcf.gz
```

That's the easy way, assuming vcf1 and vcf2 live in the current working directory. Alternatively, the default workdir in the container is `/data`, so you could mount a path to your data to `/data` and run as such

```sh
docker run --rm -v /path/to/host/data:/data nrc /data/vcf1.vcf.gz /data/vcf2.vcf.gz
```

Nonreference concordance is calculated as `NRC = 1 - (xRR + xRA + xAA) / (xRR + xRA + xAA + mRA + mAA)`. xRR, xRA, and xAA are the counts of the mismatches for the homozygous reference, heterozygous and homozygous alternative genotypes, while mRA and mAA are the counts of the matches at the heterozygous and homozygous alternative genotypes.

The container [script](src/nrc.sh) is running [bcftools stats](http://samtools.github.io/bcftools/bcftools.html#stats) followed by [post-processing in R](src/nrc.R) to pull out the relevant info.
