use std::fs::File;
use std::io::{self, BufReader, Read};
use std::path::PathBuf;
use std::time::Instant;

use anyhow::Result;
use clap::Parser;
use ergodis_private::q16_quadratic::{analyze_quadratic_obstructions, read_level8};

#[derive(Parser)]
struct Arguments {
    #[arg(long)]
    levels: PathBuf,
    #[arg(long, default_value_t = 1)]
    threads: usize,
}

fn main() -> Result<()> {
    let arguments = Arguments::parse();
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
        "threads={} leaves={} structural={} full_rank_fallback={} forced_hit={} exceptions={} parse_seconds={:.6} analyze_seconds={:.6}",
        arguments.threads,
        census.leaves,
        census.structural,
        census.full_rank_fallback,
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
    Ok(())
}
