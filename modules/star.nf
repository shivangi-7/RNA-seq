process star_index_genome {
	tag "$reference"
	
	input:
	path reference
	path gtf

	output:
	path 'star_ref_index'

	script:
	"""
	mkdir star_ref_index
	STAR \\
		--runMode genomeGenerate \\
		--genomeDir star_ref_index/ \\
		--genomeFastaFiles $reference \\
		--sjdbGTFfile $gtf \\
		$task.ext.args
	"""
}

process star_align {
	tag "$sampleID"
	
	input:
	path genomedir
	path gtf
	tuple val(sampleID), path(read1), path(read2)

	output:
	tuple val(sampleID), path('*sortedByCoord.out.bam'), emit: aligned_bam
	path ("*Log.final.out"), emit: star_logs

	script:
	"""
	STAR \\
        --genomeDir $genomedir \\
        --readFilesIn $read1 $read2  \\
        --outFileNamePrefix $sampleID. \\
		$task.ext.args
	"""
}