nextflow.enable.dsl=2

process MakeBigFile {
    publishDir "${params.outdir}"
    memory '4G'

    input:
    val(i)

    output:
    path("*.dat")

    script:
    def filesize = new MemoryUnit(params.bigfilesize)
    """
    dd if=/dev/zero bs=1M count=0 seek=${filesize.toMega()} of=out.big.${i}.dat
    """
}

process MakeSmallFiles {
    publishDir "${params.outdir}"
    memory '4G'

    output:
    path("*.dat")

    when:
    params.smallfilecount > 0

    script:
    def filesize = new MemoryUnit(params.smallfilesize)
    """
    dd if=/dev/zero bs=1M count=0 seek=${filesize.toMega()} of=out.small.template.dat
    for j in {1..${params.smallfilecount}}; do cp out.small.template.dat "out.small.\${j}.dat"; done
    rm -f out.small.template.dat
    """
}

workflow {
    MakeSmallFiles()

    Channel.of(0..params.bigfilecount)
    | filter { it > 0 } 
    | MakeBigFile
}