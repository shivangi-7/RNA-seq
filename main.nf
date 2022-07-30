nextflow.enable.dsl=2

include { RSEQC         } from './subworkflows/rseqc'
include { fastqc        } from './modules/fastqc'
include { multiqc       } from './modules/multiqc'
include { qualimap      } from './modules/qualimap'
include { trimgalore    } from './modules/trimgalore'
include { featurecounts } from './modules/subread'
include { picard_markduplicates         } from './modules/picard'
include { star_index_genome; star_align } from './modules/star'


workflow {
/* ============================| Preparation |============================ */

/*
Initiate channels
*/
	ch_input           = Channel.empty()
	ch_indexdir        = Channel.empty()
	ch_aligned_reads   = Channel.empty()
	ch_markdup_reads   = Channel.empty()


/*
Sanity checks
*/
	CheckParameters.checkRequiredParams(params, log)

	if (params.samples) {
        samples = file(params.samples, checkIfExists: true)
        if (samples.isEmpty()) {exit 1, "Input file is empty: ${samples.getName()}"}
    }

	reference = file(params.reference, checkIfExists: true)
	gtf       = file(params.gtf, checkIfExists: true)
	bed       = file(params.bed, checkIfExists: true)
	multiqc_config = file("$projectDir/assets/multiqc_config.yml")

/*
Index genome, if required
*/
	if (params.star_indexdir) {
		ch_indexdir = params.star_indexdir
	} else {
		star_index_genome(
			reference,
			gtf
		)

		ch_indexdir = star_index_genome.out
	}

/* ============================| Main workflow |========================== */

/*
Read sample information
*/
	Channel.fromPath(samples)
		.splitCsv(header: true)
		.map { row-> tuple(row.sampleID, file(row.read1), file(row.read2)) }
		.set { ch_input }

/*
QC and trimming
*/
	fastqc (ch_input)
	trimgalore (ch_input)

/*
Alignment
*/
	star_align (
		ch_indexdir,
		gtf,
		trimgalore.out.trimmed_reads
	)

/*
Read quantification
*/
	star_align.out.aligned_bam
		.map { it[1] }
		.toList()
		.set { ch_aligned_reads }

	featurecounts (
		samples.getName().split("\\.")[0],
		ch_aligned_reads,
		gtf
	)

/*
Mark duplicates
*/
	picard_markduplicates ( star_align.out.aligned_bam )
	ch_markdup_reads = picard_markduplicates.out.picard_markdup_bam
	
/*
Post alignment QC
*/
	qualimap (
		ch_markdup_reads,
		gtf
	)

	RSEQC ( ch_markdup_reads, bed )

	multiqc (
		multiqc_config,
		fastqc.out.fastqc_zip.collect(),
		trimgalore.out.trimgalore_fastqc_zip.collect(),
		trimgalore.out.trimgalore_logs.collect(),
		star_align.out.star_logs.collect(),
		picard_markduplicates.out.picard_markdup_metrics.collect(),
		featurecounts.out.featurecounts_summary.collect(),
		qualimap.out.collect(),
		RSEQC.out.rseqc_bamstat.collect(),
		RSEQC.out.rseqc_innerdistance.collect(),
		RSEQC.out.rseqc_inferexperiment.collect(),
		RSEQC.out.junction_annotation.collect(),
		RSEQC.out.rseqc_junctionsaturation.collect(),
		RSEQC.out.rseqc_readdistribution.collect(),
		RSEQC.out.rseqc_readduplication.collect()
	)
}