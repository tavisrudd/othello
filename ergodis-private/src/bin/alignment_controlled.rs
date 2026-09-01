use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis::control::read_manifest;
use ergodis::{
    compile_alignment_attachment, search_alignment_attachment_controlled,
    search_alignment_attachment_from, AlignmentSearchWorkspace,
};
use serde_json::json;
use std::path::PathBuf;

#[path = "../alignment_control.rs"]
mod alignment_control;
use alignment_control::{AlignmentCampaignControl, AlignmentProfilePolicy};

#[derive(Debug, Parser)]
#[command(about = "Opt-in alignment-attachment search with campaign safe points")]
struct Cli {
    #[arg(long)]
    run_dir: PathBuf,
    #[arg(long)]
    points: u32,
    #[arg(long)]
    budget: u32,
    #[arg(long, value_delimiter = ',', default_value = "0")]
    initial: Vec<usize>,
    #[arg(long, default_value_t = 1 << 22)]
    seen_capacity: usize,
    #[arg(long, default_value_t = 65_536)]
    pulse_interval: u64,
    /// Stream coarse progress snapshots from the auxiliary watcher as JSONL.
    #[arg(long, conflicts_with = "baseline")]
    progress_file: Option<PathBuf>,
    /// Publish bounded root-cost target profiles from the auxiliary watcher.
    #[arg(long, conflicts_with = "baseline")]
    evolution_profile: bool,
    #[arg(long, default_value_t = 8, requires = "evolution_profile")]
    profile_structural_branches: u64,
    #[arg(long, default_value_t = 3, requires = "evolution_profile")]
    profile_structural_packing: u64,
    #[arg(long)]
    symmetry: bool,
    #[arg(long)]
    compact_seen: bool,
    /// Run the unchanged core path without creating a controller client.
    #[arg(long)]
    baseline: bool,
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    let problem = compile_alignment_attachment(cli.points)?;
    let mut initial = 0_u64;
    for index in cli.initial {
        if index >= problem.triples().len() {
            bail!("initial triple index {index} is out of range");
        }
        initial |= 1_u64 << index;
    }
    let mut workspace = AlignmentSearchWorkspace::new(cli.budget, cli.seen_capacity)?;
    let group = if cli.symmetry {
        workspace.set_point_stabilizer(&problem, initial)?
    } else {
        1
    };
    if cli.compact_seen {
        workspace.enable_compact_seen(&problem, initial)?;
    }
    let (answer, metrics, control_json) = if cli.baseline {
        let (answer, metrics) =
            search_alignment_attachment_from(&problem, cli.budget, initial, &mut workspace)?;
        (answer, metrics, serde_json::Value::Null)
    } else {
        let manifest = read_manifest(&cli.run_dir).context("cannot read campaign manifest")?;
        let mut control = if cli.evolution_profile {
            AlignmentCampaignControl::new_profiled(
                manifest,
                8192,
                cli.progress_file,
                AlignmentProfilePolicy {
                    structural_branches: cli.profile_structural_branches,
                    structural_packing: cli.profile_structural_packing,
                },
            )?
        } else {
            AlignmentCampaignControl::new(manifest, 8192, cli.progress_file)?
        };
        let (answer, metrics) = search_alignment_attachment_controlled(
            &problem,
            cli.budget,
            initial,
            &mut workspace,
            cli.pulse_interval,
            &mut control,
        )?;
        (
            answer,
            metrics,
            json!({
                "epoch": control.epoch(),
                "notifications": control.notifications(),
                "profile_updates": control.profile_updates(),
                "profile_rejections": control.profile_rejections(),
                "profile_refreshes": control.profile_refreshes(),
                "group": group,
            }),
        )
    };
    if let Some(selected) = answer {
        if !problem.separates(selected)? {
            bail!("search answer failed exact replay");
        }
    }
    println!(
        "{}",
        serde_json::to_string(&json!({
            "answer": answer,
            "metrics": {
                "states": metrics.states,
                "duplicates": metrics.duplicate_states,
                "infeasible": metrics.infeasible_states,
            },
            "control": control_json,
        }))?
    );
    Ok(())
}
