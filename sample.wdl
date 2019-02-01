task ps {
  command {
    bwa
  }
  output {
    File procs = stdout()
  }
}

task cgrep {
  String pattern
  File in_file
  command {
    fastqc '${pattern}' ${in_file} | wc -l
  }
  output {
    Int count = read_int(stdout())
  }
}

task wc {
  File in_file
  command {
    multiqc ${in_file} | wc -l
  }
  output {
    Int count = read_int(stdout())
  }
}

workflow three_step {
  call gatk
  call module load GATK {
    input: in_file=ps.procs
  }
  call wc {
    input: in_file=ps.procs
  }
}
