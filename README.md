# Non-reference concordance

Please cite: **fixme**.

## Build:

```sh
git clone git@github.com:signaturescience/nrc.git
cd nrc
docker build --no-cache -t nrc .
```

## Usage

```sh
docker run --rm -v $(pwd):$(pwd) -w $(pwd) nrc exampledata/a.vcf.gz exampledata/b.vcf.gz
```

Running with `-v $(pwd):$(pwd) -w $(pwd)` assumes vcf1 and vcf2 live in the current working directory. Alternatively, the default workdir in the container is `/data`, so you could mount a path to your data to `/data` and run as such: 

```sh
docker run --rm -v /path/to/host/nrc/exampledata:/data nrc /data/a.vcf.gz /data/b.vcf.gz
```

Example data from this repo is copied to the container in `/exampledata`. To debug or experiment, jump into the container interactively with:

```sh
docker run --rm -it --entrypoint /bin/ash -w /exampledata nrc
```


### Result

```
rrrr    rrra    rraa    rarr    rara    raaa    aarr    aara    aaaa    xrr     xra    xaa      x       m       xm      total   nrd     nrc     rr      ra      aa      p_rrra p_rraa   p_rarr  p_raaa  p_aarr  p_aara
21      1       2       3       17      4       5       6       13      3       7      11       21      30      51      72      0.412   0.588   24      24      24      0.0417 0.0833   0.125   0.167   0.208   0.25
```

### Details

Nonreference concordance is calculated as `NRC = 1 - (xRR + xRA + xAA) / (xRR + xRA + xAA + mRA + mAA)`. xRR, xRA, and xAA are the counts of the mismatches for the homozygous reference, heterozygous and homozygous alternative genotypes, while mRA and mAA are the counts of the matches at the heterozygous and homozygous alternative genotypes.

The container [script](src/nrc.sh) is running [bcftools stats](http://samtools.github.io/bcftools/bcftools.html#stats) followed by [post-processing in R](src/nrc.R) to pull out the relevant info.


|    Metric   |      Value |Definition |
|:------|-------:|:----------|
|rrrr   | 21 | Count of RR to RR matches          |
|rrra   |  1 | Count of RR to RA mismatches          |
|rraa   |  2 | Count of RA to AA mismatches          |
|rarr   |  3 | Count of RA to RR mismatches          |
|rara   | 17 | Cunt of RA to RA matches          |
|raaa   |  4 | Count of RA to AA mismatches          |
|aarr   |  5 | Count of AA to RR mismatches          |
|aara   |  6 | Count of AA to RA mismatches          |
|aaaa   | 13 | Count of AA to AA matches          |
|xrr    |  3 | Count of RR mismatches          |
|xra    |  7 | Count of RA mismatches          |
|xaa    | 11 | Count of AA mismatches          |
|x      | 21 | xrr + xra + xaa          |
|m      | 30 | mra + maa          |
|xm     | 51 | x + m          |
|total  | 72 | x + m + mrr          |
|nrd    |  0.4120| Nonreference discordance (1-NRC)         |
|nrc    |  0.5880| Nonreference concordance (1-NRD)          |
|rr     | 24| Total count of RR homozygotes          |
|ra     | 24| Total count of RA heterozygotes          |
|aa     | 24| Total count of AA homozygotes          |
|p_rrra |  0.0417| rrra / rr          |
|p_rraa |  0.0833| rraa / rr          |
|p_rarr |  0.1250| rarr / ra          |
|p_raaa |  0.1670| raaa / ra          |
|p_aarr |  0.2080| aarr / aa          |
|p_aara |  0.2500| aara / aa          |