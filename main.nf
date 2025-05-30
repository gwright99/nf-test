nextflow.enable.dsl=2

process Dummy {
    container "robsyme/container-loading-100mb:${sprintf('%03d', i)}"
    input: val(i)
    script: "echo 'Hello world! ${i}'"
}

workflow {
    Channel.of(1..params.processCount)
    | Dummy
}
