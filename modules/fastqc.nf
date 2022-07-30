process fastqc {
	tag "$sampleID"

	input:
	tuple val(sampleID), path(read1), path(read2)

	output:
	path "*html", emit: fastqc_html
	path "*zip", emit: fastqc_zip

	script:
	"""
	mkdir $sampleID
	fastqc \\
		$task.ext.args \\
		$read1 $read2
	"""
}