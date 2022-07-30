include { rseqc_bamstat; rseqc_innerdistance; rseqc_inferexperiment; rseqc_junctionannotation;
		  rseqc_junctionsaturation; rseqc_readdistribution; rseqc_readduplication } from '../modules/rseqc'

workflow RSEQC {
	take:
	bam
	bed

	main:
	rseqc_bamstat (bam)
	rseqc_innerdistance (bam, bed)
	rseqc_inferexperiment (bam, bed)
	rseqc_junctionannotation (bam, bed)
	rseqc_junctionsaturation (bam, bed)
	rseqc_readdistribution (bam, bed)
	rseqc_readduplication (bam, bed)

	emit:
	rseqc_bamstat = rseqc_bamstat.out
	rseqc_innerdistance = rseqc_innerdistance.out.inner_distance_freq
	rseqc_inferexperiment = rseqc_inferexperiment.out
	junction_annotation = rseqc_junctionannotation.out.junction_annotation_logs
	rseqc_junctionsaturation = rseqc_junctionsaturation.out.junction_saturation_rscript
	rseqc_readdistribution = rseqc_readdistribution.out
	rseqc_readduplication = rseqc_readduplication.out.rseqc_readdup_pos
}