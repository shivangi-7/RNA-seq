process rseqc_bamstat {
	tag "$sampleID"
	label 'rseqc'

	input:
	tuple val(sampleID), path(bam)

	output:
	path ("*txt")

	script:
	"""
	bam_stat.py \\
        -i $bam \\
        $task.ext.args \\
        > ${sampleID}.bam_stat.txt
	"""
}

process rseqc_innerdistance {
	tag "$sampleID"
	label 'rseqc'

	input:
	tuple val(sampleID), path(bam)
	path bed

	output:
	path ("*pdf"), emit: inner_distance_pdf
	path ("*freq.txt"), emit: inner_distance_freq
	path ("*mean.txt"), emit: inner_distance_mean

	script:
	"""
	inner_distance.py \\
		-i $bam \\
		-o $sampleID \\
		-r $bed \\
		$task.ext.args \\
		> stdout.txt
    head -n 2 stdout.txt > ${sampleID}.inner_distance_mean.txt
	"""
}

process rseqc_inferexperiment {
	tag "$sampleID"
	label 'rseqc'

	input:
	tuple val(sampleID), path(bam)
	path bed

	output:
	path ("*txt")

	script:
	"""
	infer_experiment.py \\
		-i $bam \\
		-r $bed \\
		$task.ext.args \\
		> ${sampleID}.infer_experiment.txt
	"""
}

process rseqc_junctionannotation {
	tag "$sampleID"
	label 'rseqc'

	input:
	tuple val(sampleID), path(bam)
	path bed

	output:
	path ("*.{pdf,xls,bed}"), emit: junction_annotation_reports
	path ("*junction_annotation.log"), emit: junction_annotation_logs

	script:
	"""
	junction_annotation.py \\
        -i $bam \\
        -r $bed \\
        -o $sampleID \\
        $task.ext.args \\
        2> ${sampleID}.junction_annotation.log
	"""
}

process rseqc_junctionsaturation {
	tag "$sampleID"
	label 'rseqc'

	input:
	tuple val(sampleID), path(bam)
	path bed

	output:
	path ("*pdf"), emit: junction_saturation_pdf
	path ("*_plot.r"), emit: junction_saturation_rscript

	script:
	"""
    junction_saturation.py \\
        -i $bam \\
        -r $bed \\
        -o $sampleID \\
        $task.ext.args
	"""
}

process rseqc_readdistribution {
	tag "$sampleID"
	label 'rseqc'

	input:
	tuple val(sampleID), path(bam)
	path bed

	output:
	path ("*read_distribution.txt")

	script:
	"""
	read_distribution.py \\
        -i $bam \\
        -r $bed \\
        > ${sampleID}.read_distribution.txt
	"""
}

process rseqc_readduplication {
	tag "$sampleID"
	label 'rseqc'

	input:
	tuple val(sampleID), path(bam)
	path bed

	output:
	path ("*pdf"), emit: rseqc_readdup_pdf
	path ("*seq.DupRate.xls"), emit: rseqc_readdup_seq
	path ("*pos.DupRate.xls"), emit: rseqc_readdup_pos

	script:
	"""
    read_duplication.py \\
        -i $bam \\
        -o $sampleID \\
        $task.ext.args
	"""
}