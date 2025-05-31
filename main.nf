nextflow.enable.dsl=2

process Dummy {
    container { "robsyme/container-loading-100mb:${i.toString().padLeft(3,'0')}" }
    input: tuple val(i), val(layerSize)
    script: "echo 'Hello world! ${i}'"
}

process Dummy2 {
    container { "robsyme/container-loading-${layerSize}mb:${i.toString().padLeft(3,'0')}" }
    input: tuple val(i), val(layerSize)
    script: "echo 'Hello world! ${i}'"
}

workflow {
    def indices = Channel.of(1..params.processCount)
    def sizes = Channel.of(params.layerSize.tokenize(',')).flatten()
    def combined = indices.combine(sizes)

    def indices2 = Channel.of(35..params.processCount)
    def sizes2 = Channel.of(params.layerSize.tokenize(',')).flatten()
    def combined2 = indices.combine(sizes2)

    combined | Dummy
    combined2 | Dummy2
}
