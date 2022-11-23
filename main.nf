nextflow.enable.dsl=2

process Make {
    // publishDir "${params.outdir}", saveAs: { it.startsWith("reports/") ? null : it }
    publishDir "${params.outdir}"

    input: 
    val(name)

    output: 
    path("**/*.html")
    path("$name")

    """
    run $name
    """
}

workflow {
    Channel.of("sampleA", "sampleB")
    | Make
}