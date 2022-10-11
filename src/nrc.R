#!/usr/bin/env Rscript

x=readLines("/tmp/bcfstats")
x=grep("^GCTs", x, value=TRUE)
x=read.table(text=x)
x=x[c(3,4,5,8,9,10,13,14,15)]
names(x)=c("rrrr", "rrra", "rraa", "rarr", "rara", "raaa", "aarr", "aara", "aaaa")
x |> 
transform(xrr=rrra+rraa, xra=rarr+raaa, xaa=aarr+aara) |>
transform(x=xrr+xra+xaa, m=rara+aaaa, mm=rrrr+rara+aaaa) |>
transform(xm=x+m, total=x+m+rrrr) |> 
transform(nrd=signif(x/xm, 3)) |>
transform(nrc=signif(1-nrd, 3)) |> 
transform(disc=signif(x/total, 3)) |>
transform(conc=signif(1-disc, 3)) |> 
transform(rr=rrrr+rrra+rraa, ra=rarr+rara+raaa, aa=aarr+aara+aaaa) |>
transform(p_rrra=ifelse(rr==0, 0, signif((rrra)/rr, 3))) |>
transform(p_rraa=ifelse(rr==0, 0, signif((rraa)/rr, 3))) |>
transform(p_rarr=ifelse(ra==0, 0, signif((rarr)/ra, 3))) |>
transform(p_raaa=ifelse(ra==0, 0, signif((raaa)/ra, 3))) |>
transform(p_aarr=ifelse(aa==0, 0, signif((aarr)/aa, 3))) |>
transform(p_aara=ifelse(aa==0, 0, signif((aara)/aa, 3))) |>
write.table(file="/tmp/bcfstats.tsv", sep="\t", quote=FALSE, row.names=FALSE)
