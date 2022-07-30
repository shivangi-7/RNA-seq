process picard_markduplicates {
	tag "$sampleID"

	input:
	tuple val(sampleID), path(bam)
	
	output:
	tuple val(sampleID), path("*bam"), emit: picard_markdup_bam
	path ("*MarkDuplicates.metrics.txt"), emit: picard_markdup_metrics
	
	script:
	"""
	picard \\
        MarkDuplicates \\
        $task.ext.args \\
        I=$bam \\
        O=${sampleID}.markdup.bam \\
		M=${sampleID}.MarkDuplicates.metrics.txt
	"""
}