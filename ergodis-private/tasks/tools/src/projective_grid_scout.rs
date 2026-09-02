use anyhow::Result;
use clap::Args;
use serde_json::json;
use std::fs::File;
use std::io::{BufWriter, Write};
use std::num::NonZeroUsize;
use std::path::PathBuf;
use std::time::Instant;

use ergodis_private::projective_grid::scout;

#[derive(Debug, Args)]
pub struct Cli {
    #[arg(long, default_value_t = 11)]
    q: u16,
    #[arg(long, default_value_t = 100)]
    states: usize,
    #[arg(long, default_value_t = 98_508_030)]
    seed: u64,
    #[arg(long, default_value_t = NonZeroUsize::MIN)]
    threads: NonZeroUsize,
    #[arg(long)]
    output: Option<PathBuf>,
}

pub fn run(cli: Cli) -> Result<()> {
    let start = Instant::now();
    let metrics = scout(cli.q, cli.states, cli.seed, cli.threads.get())?;
    let rendered = serde_json::to_string(&json!({
        "schema": "ergodis-private-projective-grid-scout-v1",
        "q": cli.q,
        "seed": cli.seed,
        "requested_states": cli.states,
        "threads": cli.threads,
        "metrics": metrics,
        "elapsed_seconds": start.elapsed().as_secs_f64(),
    }))?;
    if let Some(path) = cli.output {
        let mut writer = BufWriter::new(File::options().write(true).create_new(true).open(path)?);
        writer.write_all(rendered.as_bytes())?;
        writer.write_all(b"\n")?;
    } else {
        println!("{rendered}");
    }
    Ok(())
}
