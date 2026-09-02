use std::fs::{File, OpenOptions};
use std::io::{self, BufReader, BufWriter, Read, Write};
use std::path::PathBuf;
use std::time::Instant;

use anyhow::Result;
use clap::Args;
use ergodis_private::q16_quadratic::{
    analyze_quadratic_obstructions, read_level8, synthesize_quadratic_theorem,
};

#[derive(Args)]
pub struct Arguments {
    #[arg(long)]
    levels: PathBuf,
    #[arg(long, default_value_t = 1)]
    threads: usize,
    #[arg(long)]
    synthesize: bool,
    #[arg(long, requires = "synthesize")]
    theorem_log: Option<PathBuf>,
}

pub fn run(arguments: Arguments) -> Result<()> {
    let input: Box<dyn Read> = if arguments.levels.as_os_str() == "-" {
        Box::new(io::stdin().lock())
    } else {
        Box::new(BufReader::new(File::open(arguments.levels)?))
    };
    let parsed_started = Instant::now();
    let arcs = read_level8(input)?;
    let parsed = parsed_started.elapsed();
    let analyzed_started = Instant::now();
    let census = analyze_quadratic_obstructions(&arcs, arguments.threads)?;
    let analyzed = analyzed_started.elapsed();
    println!(
        "threads={} leaves={} structural={} full_rank_fallback={} underdetermined={} forced_hit={} exceptions={} parse_seconds={:.6} analyze_seconds={:.6}",
        arguments.threads,
        census.leaves,
        census.structural,
        census.full_rank_fallback,
        census.underdetermined,
        census.forced_hit,
        census.exception_count,
        parsed.as_secs_f64(),
        analyzed.as_secs_f64(),
    );
    for exception in &census.exceptions[..census.exception_count as usize] {
        println!(
            "exception={} rank={} selected_zeros={} kernel={:x?}",
            exception.ordinal, exception.rank, exception.selected_zeros, exception.kernel
        );
    }
    if arguments.synthesize {
        let started = Instant::now();
        let discovery = synthesize_quadratic_theorem(&arcs)?;
        let best = discovery.best_sound;
        println!(
            "theorem_trials={} best_collinear_points={} best_off_line_rank={} covered_true={} false_positives={} synthesize_seconds={:.6}",
            discovery.trials.len(),
            best.candidate.collinear_points,
            best.candidate.off_line_rank,
            best.score.covered_true,
            best.score.false_positives,
            started.elapsed().as_secs_f64(),
        );
        if let Some(path) = arguments.theorem_log {
            let output = OpenOptions::new().write(true).create_new(true).open(path)?;
            let mut writer = BufWriter::new(output);
            for trial in &discovery.trials {
                serde_json::to_writer(
                    &mut writer,
                    &serde_json::json!({
                        "generation": trial.generation,
                        "candidate": {
                            "collinear_points": trial.candidate.collinear_points,
                            "off_line_rank": trial.candidate.off_line_rank,
                        },
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
