nextflow.enable.dsl=2

process Dummy {
    debug true

    script:
    "echo 'Hello world!' && sleep 2h"
}

workflow {
    Dummy()
}
