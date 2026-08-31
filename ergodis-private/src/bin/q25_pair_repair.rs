use std::fs::{File, OpenOptions};
use std::io::{BufReader, BufWriter, Write};
use std::path::PathBuf;
use std::time::Instant;

use anyhow::Result;
use clap::Parser;
use ergodis_private::q25_pair_repair::{
    classify_minimum_residual_orbits, compile_q25_pair_repair, format_matrix_pattern,
    independently_verify, synthesize_residual_stabilizer_pattern, verify_certificate,
    verify_minimum_certificate, write_certificate, write_minimum_certificate,
};

#[derive(Parser)]
struct Arguments {
    #[arg(long, default_value_t = 1)]
    threads: usize,
    #[arg(long)]
    certificate: Option<PathBuf>,
    #[arg(long)]
    minimum_certificate: Option<PathBuf>,
    #[arg(long)]
    classify_residual: bool,
    #[arg(long)]
    synthesize_stabilizer: bool,
    #[arg(long, requires = "synthesize_stabilizer")]
    stabilizer_log: Option<PathBuf>,
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
    let mut minimum_certificate_bytes = 0_u64;
    let mut minimum_certificate_seconds = 0_f64;
    let mut minimum_certificate_replay_seconds = 0_f64;
    if let Some(path) = arguments.minimum_certificate {
        let certificate_started = Instant::now();
        let mut output = BufWriter::new(File::create(&path)?);
        minimum_certificate_bytes = write_minimum_certificate(&census, &mut output)?;
        output.flush()?;
        minimum_certificate_seconds = certificate_started.elapsed().as_secs_f64();
        let certificate_replay_started = Instant::now();
        let mut input = BufReader::new(File::open(path)?);
        let summary = verify_minimum_certificate(&mut input, arguments.threads)?;
        assert_eq!(summary.minimum_legal_count, 32);
        assert_eq!(summary.minimum_rows, 24);
        minimum_certificate_replay_seconds = certificate_replay_started.elapsed().as_secs_f64();
    }
    let classification_started = Instant::now();
    let classes = if arguments.classify_residual {
        classify_minimum_residual_orbits(&census)
    } else {
        Vec::new()
    };
    let classification_seconds = classification_started.elapsed().as_secs_f64();
    let minimum_orbit_total: u16 = classes.iter().map(|class| class.orbit_size).sum();
    println!(
        "threads={} rows={} obstructions={} legal={} response_classes={} residual_classes={} minimum_orbit_total={} quotient_bytes={} quotient_certificate_bytes={} theorem_certificate_bytes={} minimum_certificate_bytes={} compile_seconds={:.6} replay_seconds={:.6} certificate_seconds={:.6} certificate_replay_seconds={:.6} minimum_certificate_seconds={:.6} minimum_certificate_replay_seconds={:.6} classification_seconds={:.6}",
        arguments.threads,
        census.records.len(),
        census.obstruction_count(),
        census.legal_count(),
        census.response_classes,
        classes.len(),
        minimum_orbit_total,
        census.quotient_bytes(),
        census.certificate_bytes(),
        certificate_bytes,
        minimum_certificate_bytes,
        compiled.as_secs_f64(),
        replayed.as_secs_f64(),
        certificate_seconds,
        certificate_replay_seconds,
        minimum_certificate_seconds,
        minimum_certificate_replay_seconds,
        classification_seconds,
    );
    if arguments.synthesize_stabilizer {
        let started = Instant::now();
        let discovery = synthesize_residual_stabilizer_pattern()?;
        println!(
            "stabilizer_matrices={} stabilizer_members={} theorem_trials={} covered_true={} false_positives={} complexity={} pattern={} synthesize_seconds={:.6}",
            discovery.matrices,
            discovery.members,
            discovery.trials.len(),
            discovery.best_sound.score.covered_true,
            discovery.best_sound.score.false_positives,
            discovery.best_sound.score.complexity,
            format_matrix_pattern(discovery.best_sound.candidate),
            started.elapsed().as_secs_f64(),
        );
        if let Some(path) = arguments.stabilizer_log {
            let output = OpenOptions::new().write(true).create_new(true).open(path)?;
            let mut writer = BufWriter::new(output);
            for trial in &discovery.trials {
                serde_json::to_writer(
                    &mut writer,
                    &serde_json::json!({
                        "generation": trial.generation,
                        "candidate_mask": trial.candidate,
                        "pattern": format_matrix_pattern(trial.candidate),
                        "score": {
                            "examples": trial.score.examples,
                            "conclusion_true": trial.score.conclusion_true,
                            "covered_true": trial.score.covered_true,
                            "false_positives": trial.score.false_positives,
                            "complexity": trial.score.complexity,
                        },
                    }),
                )?;
                writer.write_all(b"\n")?;
            }
            writer.flush()?;
        }
    }
    Ok(())
}
