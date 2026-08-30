use anyhow::{Context, Result};
use clap::Parser;
use ergodis::control::Campaign;
use std::path::PathBuf;

#[derive(Debug, Parser)]
#[command(
    name = "ergodis-campaign",
    about = "Experimental opt-in theorem-search campaign controller"
)]
struct Cli {
    /// Frozen JSONL feature batch.
    #[arg(long)]
    data: PathBuf,
    /// New private durable run directory.
    #[arg(long)]
    run_dir: PathBuf,
    /// Explicit Unix socket; required when XDG_RUNTIME_DIR is unavailable.
    #[arg(long)]
    socket: Option<PathBuf>,
    /// Maximum durable high-level ledger bytes.
    #[arg(long, default_value_t = 8 * 1024 * 1024)]
    ledger_max_bytes: u64,
    /// Maximum response bytes, additionally capped by the protocol.
    #[arg(long, default_value_t = 16 * 1024)]
    response_max_bytes: usize,
    /// Maximum bytes in one localized trace file.
    #[arg(long, default_value_t = 1024 * 1024)]
    trace_max_bytes: u64,
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    let campaign = Campaign::create(
        &cli.data,
        &cli.run_dir,
        cli.socket,
        cli.ledger_max_bytes,
        cli.response_max_bytes,
        cli.trace_max_bytes,
    )
    .context("cannot create campaign")?;
    println!("{}", serde_json::to_string(campaign.manifest())?);
    campaign.serve().context("campaign controller failed")
}
