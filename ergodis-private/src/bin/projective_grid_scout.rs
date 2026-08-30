use anyhow::Result;
use clap::Parser;
use serde_json::json;
use std::num::NonZeroUsize;
use std::time::Instant;

#[path = "../projective_grid.rs"]
mod projective_grid;
use projective_grid::scout;

#[derive(Debug, Parser)]
#[command(about = "Unpublished parallel projective grid-game scout")]
struct Cli {
    #[arg(long, default_value_t = 11)]
    q: u16,
    #[arg(long, default_value_t = 100)]
    states: usize,
    #[arg(long, default_value_t = 98_508_030)]
    seed: u64,
    #[arg(long, default_value_t = NonZeroUsize::MIN)]
    threads: NonZeroUsize,
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    let start = Instant::now();
    let metrics = scout(cli.q, cli.states, cli.seed, cli.threads.get())?;
    println!(
        "{}",
        serde_json::to_string(&json!({
            "schema": "ergodis-private-projective-grid-scout-v1",
            "q": cli.q,
            "seed": cli.seed,
            "requested_states": cli.states,
            "threads": cli.threads,
            "metrics": metrics,
            "elapsed_seconds": start.elapsed().as_secs_f64(),
        }))?
    );
    Ok(())
}
