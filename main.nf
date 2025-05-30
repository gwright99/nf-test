nextflow.enable.dsl=2

process Dummy {
    container { "robsyme/container-loading-${layerSize}mb:${i.toString().padLeft(3,'0')}" }
    input: tuple val(i), val(layerSize)
    script: "echo 'Hello world! ${i}'"
}

workflow {
    Channel.of(1..params.processCount)
    | combine(Channel.of(10,100))
    | take(10)
    | Dummy
}
