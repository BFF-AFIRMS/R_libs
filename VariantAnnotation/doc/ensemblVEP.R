## ----setup,echo=FALSE,results="hide",message=FALSE----------------------------
library(BiocStyle)
library(VariantAnnotation)
library(jsonlite)
library(httr)

## ----dodemo,message=FALSE-----------------------------------------------------
library(VariantAnnotation)
fl <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
r22 = readVcf(fl)
r22

## ----lksnv--------------------------------------------------------------------
dr = which(width(rowRanges(r22))!=1)
r22s = r22[-dr]
res = vep_by_region(r22[1:100], snv_only=FALSE, chk_max=FALSE)
jans = toJSON(content(res))

## ----doj1, message=FALSE------------------------------------------------------
library(rjsoncons)
names(jsonlite::fromJSON(jmespath(jans, "[*]")))

## ----doj2---------------------------------------------------------------------
table(jsonlite::fromJSON(jmespath(jans, "[*].most_severe_consequence")))

## ----doj3---------------------------------------------------------------------
head(fromJSON(jmespath(jans, "[*].regulatory_feature_consequences")))

## ----lktaaaa------------------------------------------------------------------
table(unlist(fromJSON(jmespath(jans, "[*].motif_feature_consequences"))))

## ----lkmakeg, message=FALSE---------------------------------------------------
library(GenomicRanges)
.make_GRanges = function( vep_response ) {
  stopifnot(inherits(vep_response, "response"))  # httr
  nested = fromJSON(toJSON(content(vep_response)))
  ini = GRanges(seqnames = unlist(nested$seq_region_name),
    IRanges(start=unlist(nested$start), end=unlist(nested$end)))
  dr = match(c("seq_region_name", "start", "end"), names(nested))
  mcols(ini) = DataFrame(nested[,-dr])
  ini
}
tstg = .make_GRanges( res )
tstg[,1]  # full print is unwieldy
names(mcols(tstg))

## ----lkmc---------------------------------------------------------------------
mcols(tstg)[1, "transcript_consequences"]

