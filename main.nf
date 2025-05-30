nextflow.enable.dsl=2

process Dummy {
    container { "robsyme/container-loading-100mb:${i.toString().padLeft(3,'0')}" }
    input: val(i)
    script: "echo 'Hello world! ${i}'"
}

workflow {
    Channel.of(1..params.processCount)
    | Dummy
}
