use std::fs::File;
use std::io::{BufReader, BufWriter, Write};
use std::path::PathBuf;
use std::time::Instant;

use anyhow::Result;
use clap::Parser;
use ergodis_private::q25_pair_repair::{
    compile_q25_pair_repair, independently_verify, verify_certificate, write_certificate,
};

#[derive(Parser)]
struct Arguments {
    #[arg(long, default_value_t = 1)]
    threads: usize,
    #[arg(long)]
    certificate: Option<PathBuf>,
}

fn main() -> Result<()> {
    let arguments = Arguments::parse();
    let started = Instant::now();
    let census = compile_q25_pair_repair(arguments.threads)?;
    let compiled = started.elapsed();
    let replay_started = Instant::now();
    independently_verify(&census, arguments.threads)?;
    let replayed = replay_started.elapsed();
    let mut certificate_bytes = 0_u64;
    let mut certificate_seconds = 0_f64;
    let mut certificate_replay_seconds = 0_f64;
    if let Some(path) = arguments.certificate {
        let certificate_started = Instant::now();
        let mut output = BufWriter::new(File::create(&path)?);
        certificate_bytes = write_certificate(&census, &mut output)?;
        output.flush()?;
        certificate_seconds = certificate_started.elapsed().as_secs_f64();
        let certificate_replay_started = Instant::now();
        let mut input = BufReader::new(File::open(path)?);
        assert_eq!(verify_certificate(&mut input)?, certificate_bytes);
        certificate_replay_seconds = certificate_replay_started.elapsed().as_secs_f64();
    }
    println!(
        "threads={} rows={} obstructions={} legal={} response_classes={} quotient_bytes={} quotient_certificate_bytes={} theorem_certificate_bytes={} compile_seconds={:.6} replay_seconds={:.6} certificate_seconds={:.6} certificate_replay_seconds={:.6}",
        arguments.threads,
        census.records.len(),
        census.obstruction_count(),
        census.legal_count(),
        census.response_classes,
        census.quotient_bytes(),
        census.certificate_bytes(),
        certificate_bytes,
        compiled.as_secs_f64(),
        replayed.as_secs_f64(),
        certificate_seconds,
        certificate_replay_seconds,
    );
    Ok(())
}
