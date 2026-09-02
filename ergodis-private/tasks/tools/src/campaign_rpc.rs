use std::path::PathBuf;

use anyhow::{bail, Context, Result};
use clap::Args as ClapArgs;
use ergodis::control::{read_manifest, send_request};
use serde_json::Value;

#[derive(Debug, ClapArgs)]
pub struct Args {
    #[arg(long)]
    run_dir: PathBuf,
    #[arg(long)]
    op: String,
    #[arg(long, conflicts_with = "args_file")]
    args: Option<String>,
    #[arg(long)]
    args_file: Option<PathBuf>,
    #[arg(long, default_value_t = 16 * 1024)]
    max_bytes: usize,
}

pub fn run(args: Args) -> Result<()> {
    let manifest = read_manifest(&args.run_dir).context("cannot read campaign manifest")?;
    let encoded = if let Some(path) = args.args_file {
        let metadata = std::fs::metadata(&path).context("cannot stat --args-file")?;
        if metadata.len() > 1024 * 1024 {
            bail!("--args-file exceeds 1 MiB");
        }
        std::fs::read_to_string(path).context("cannot read --args-file")?
    } else {
        args.args.unwrap_or_else(|| "{}".into())
    };
    let request: Value = serde_json::from_str(&encoded).context("invalid request JSON")?;
    let response = send_request(&manifest, &args.op, request, args.max_bytes)
        .context("campaign request failed")?;
    if !response.ok {
        bail!(
            "campaign rejected request: {}",
            response.result["error"].as_str().unwrap_or("unknown error")
        );
    }
    println!("{}", serde_json::to_string_pretty(&response)?);
    Ok(())
}
