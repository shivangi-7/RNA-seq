process qualimap {
	tag "$sampleID"

	input:
	tuple val(sampleID), path(bam)
    path gtf

	output:
	path ("$sampleID")
	
	script:
	"""
	unset DISPLAY
    mkdir tmp
    export _JAVA_OPTIONS=-Djava.io.tmpdir=./tmp
    qualimap \\
        rnaseq \\
        $task.ext.args \\
        -bam $bam \\
        -gtf $gtf \\
        -pe \\
        -outdir $sampleID
	"""

}