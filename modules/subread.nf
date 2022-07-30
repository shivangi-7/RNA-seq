process featurecounts {
	tag "$prefix"

	input:
	val prefix
	path bams
	path gtf

	output:
	path("*featureCounts.txt"), emit: featurecounts_counts
	path("*featureCounts.txt.summary"), emit: featurecounts_summary

	script:
	"""
	featureCounts \\
        $task.ext.args \\
        -p \\
        -T $task.cpus \\
        -a $gtf \\
        -o ${prefix}.featureCounts.txt \\
        ${bams.join(' ')}
	"""
}