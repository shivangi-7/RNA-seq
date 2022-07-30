process multiqc {
	input:
	path multiqc_config
	path ("fastqc/*")
	path ("trimgalore/fastqc/*")
	path ("trimgalore/*")
	path ("star/*")
	path ('picard/markduplicates/*')
	path ('featurecounts/*')
	path ('qualimap/*')
	path ('rseqc/bam_stat/*')
    path ('rseqc/inner_distance/*')
    path ('rseqc/infer_experiment/*')
    path ('rseqc/junction_annotation/*')
    path ('rseqc/junction_saturation/*')
    path ('rseqc/read_distribution/*')
    path ('rseqc/read_duplication/*')

	output:
	path ("*html")

	script:
	"""
	multiqc \\
		-f \\
		$multiqc_config \\
		. 
	"""
}