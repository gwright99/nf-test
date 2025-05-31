nextflow.enable.dsl=2

process Dummy {
    container { "robsyme/container-loading-${layerSize}mb:${i.toString().padLeft(3,'0')}" }
    input: tuple val(i), val(layerSize)
    script: "echo 'Hello world! ${i}'"
}

workflow {
    def indices = Channel.of(1..params.processCount)
    def sizes = Channel.of(params.layerSize.tokenize(',')).flatten()
    def combined = indices.combine(sizes)

    combined | Dummy
    combined | Dummy2
}
