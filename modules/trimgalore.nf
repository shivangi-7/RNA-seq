process trimgalore {
	tag "$sampleID"

	input:
	tuple val(sampleID), path(read1), path(read2)

	output:
	tuple val(sampleID), path('*val_1.fq.gz'), path('*val_2.fq.gz'), emit: trimmed_reads
	path("*html"), emit: trimgalore_fastqc_html
	path("*zip"), emit: trimgalore_fastqc_zip
	path("*trimming_report.txt"), emit: trimgalore_logs

	script:
	"""
	trim_galore \\
		$task.ext.args \\
		--paired \\
		--gzip \\
		--fastqc \\
		${read1} \\
		${read2}
	"""
}