class CheckParameters {
   public static void checkRequiredParams(params, log) {
      if (!params.star_indexdir && !params.reference && !params.gtf) { 
         log.error "\nPlease specify the path to the directory containing the indexed genome " + 
         "(--star_indexdir). If the indexed genome is not available, please specify path to " +
         "reference fasta (--reference) and gtf file (--gtf) to generate indexes."
         System.exit(1)
      }

      if (!params.samples) { 
         log.error "\nInput samplesheet not specified!"
         System.exit(1)
      }

      if (!params.gtf) { 
         log.error "\nGenome annotations file not specified!"
         System.exit(1)
      }

      if (!params.bed) { 
         log.error "\nGenome BED file not specified!"
         System.exit(1)
      }
   }
}