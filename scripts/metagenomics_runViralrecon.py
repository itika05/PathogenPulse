import subprocess
import glob

inputList = glob.glob("*.csv")

def runViralrecon(inputList, trim, protocol):
    for inputFile in inputList:
        runtype = inputFile.replace("_input.csv", "")
        if protocol == "metagenomic":
            cmd_str = f"/home/ubuntu/nextflow run nf-core/viralrecon -r 2.6.0 \
                --max_cpus 94 \
                --max_memory '370.GB' \
                --input {inputFile} \
                --outdir {runtype}_output_trim_{trim} \
                --platform illumina \
                --protocol metagenomic \
                --genome 'MN908947.3' \
                --kraken2_db /home/ubuntu/Viralrecon/COVID/references/kraken2-human-db \
                --save_reference false \
                --variant_caller 'ivar' \
                --skip_assembly \
                -c programs/custom.config \
                -profile docker \
                -with-docker nfcore/viralrecon"
        subprocess.run(cmd_str, shell=True)

# run function
runViralrecon(inputList, trim=0, protocol="metagenomic")
