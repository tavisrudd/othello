use std::path::PathBuf;
use std::thread;
use std::time::Duration;

use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis::control::{send_request, Campaign, Manifest, Response};
use ergodis_private::banked_rule_evolve::banked_rule_systems;
use serde::Serialize;
use serde_json::{json, Value};

const RESPONSE_LIMIT: usize = 64 * 1024;

#[derive(Debug, Parser)]
struct Args {
    #[arg(long)]
    data_dir: PathBuf,
    #[arg(long)]
    run_root: PathBuf,
    #[arg(long)]
    reduction: Option<String>,
}

#[derive(Serialize)]
struct SystemAudit {
    reduction: &'static str,
    rules: usize,
    rows: usize,
    positive_rows: u64,
    tree_nodes: u64,
    tree_depth: u64,
    tree_weighted_correct: u64,
    evolved_tested: u64,
    evolved_perfect: u64,
    best_plan: Value,
}

#[derive(Serialize)]
struct AuditReport {
    schema: &'static str,
    systems: Vec<SystemAudit>,
    provenance: &'static str,
}

fn require_ok(response: Response) -> Result<Value> {
    if !response.ok {
        bail!(
            "campaign rejected request: {}",
            response.result["error"].as_str().unwrap_or("unknown error")
        );
    }
    Ok(response.result)
}

fn wait_until_ready(manifest: &Manifest) -> Result<()> {
    for _ in 0..10_000 {
        if send_request(manifest, "capabilities", json!({}), RESPONSE_LIMIT).is_ok() {
            return Ok(());
        }
        thread::sleep(Duration::from_millis(1));
    }
    bail!("campaign did not become ready within its bounded coordination poll")
}

fn wait_for_evolution(manifest: &Manifest) -> Result<Value> {
    for _ in 0..10_000 {
        let result = require_ok(send_request(
            manifest,
            "evolve-status",
            json!({}),
            RESPONSE_LIMIT,
        )?)?;
        if result["state"] != "running" {
            return Ok(result);
        }
        thread::sleep(Duration::from_millis(1));
    }
    bail!("evolution exceeded its bounded coordination poll")
}

fn main() -> Result<()> {
    let args = Args::parse();
    std::fs::create_dir(&args.run_root).context("cannot create audit run root")?;
    let mut audits = Vec::with_capacity(10);
    for system in banked_rule_systems() {
        if args
            .reduction
            .as_deref()
            .is_some_and(|reduction| reduction != system.slug)
        {
            continue;
        }
        let data = args.data_dir.join(format!("{}.jsonl", system.slug));
        let run_dir = args.run_root.join(system.slug);
        let campaign = Campaign::create(
            &data,
            &run_dir,
            None,
            2 * 1024 * 1024,
            RESPONSE_LIMIT,
            2 * 1024 * 1024,
        )?;
        let manifest = campaign.manifest().clone();
        let server = thread::spawn(move || campaign.serve());
        wait_until_ready(&manifest)?;
        let ceiling = require_ok(send_request(
            &manifest,
            "feature-ceiling",
            json!({}),
            RESPONSE_LIMIT,
        )?)?;
        if ceiling["unavoidable_weighted_errors"].as_u64() != Some(0) {
            bail!("{} has an ambiguous ablation corpus", system.slug);
        }
        let tree = require_ok(send_request(
            &manifest,
            "synthesize-tree",
            json!({"max_nodes": 41, "max_depth": 16}),
            RESPONSE_LIMIT,
        )?)?;
        let rows = 1_usize << system.rules.len();
        let positive_rows = (0_u64..rows as u64)
            .filter(|&mask| {
                ergodis_private::banked_rule_evolve::ablated_closure(system, mask)
                    & system.goal_facts
                    == system.goal_facts
            })
            .count() as u64;
        if tree["evaluation"]["weighted_correct"].as_u64() != Some(rows as u64) {
            bail!("{} tree synthesis was not exact", system.slug);
        }
        let start = require_ok(send_request(
            &manifest,
            "evolve-start",
            json!({
                "seeds": [tree["plan"].clone()],
                "generations": 4,
                "beam": 32,
                "max_candidates": 1_000,
                "evidence_name": format!("{}-proof-skeleton", system.slug),
                "max_evidence_bytes": 2 * 1024 * 1024,
            }),
            RESPONSE_LIMIT,
        )?)?;
        if start["state"] != "running" {
            bail!("{} evolution did not start", system.slug);
        }
        let evolved = wait_for_evolution(&manifest)?;
        let perfect = evolved["summary"]["perfect"].as_u64().unwrap_or(0);
        if evolved["state"] != "complete" || perfect == 0 {
            bail!(
                "{} evolution did not retain a perfect mechanism",
                system.slug
            );
        }
        audits.push(SystemAudit {
            reduction: system.slug,
            rules: system.rules.len(),
            rows,
            positive_rows,
            tree_nodes: tree["nodes"].as_u64().unwrap_or(0),
            tree_depth: tree["depth"].as_u64().unwrap_or(0),
            tree_weighted_correct: tree["evaluation"]["weighted_correct"].as_u64().unwrap_or(0),
            evolved_tested: evolved["summary"]["tested"].as_u64().unwrap_or(0),
            evolved_perfect: perfect,
            best_plan: evolved["summary"]["best"]["plan"].clone(),
        });
        require_ok(send_request(
            &manifest,
            "shutdown",
            json!({}),
            RESPONSE_LIMIT,
        )?)?;
        server
            .join()
            .map_err(|_| anyhow::anyhow!("{} campaign thread panicked", system.slug))??;
    }
    if audits.is_empty() {
        bail!("no banked rule system matched the requested reduction");
    }
    println!(
        "{}",
        serde_json::to_string_pretty(&AuditReport {
            schema: "ergodis-private-c1016-banked-rule-evolve-audit-v1",
            systems: audits,
            provenance: "discovery-only exhaustive rule-ablation campaigns; each evolved perfect plan is replayed only as a proof-skeleton candidate against its sealed registered rule system",
        })?
    );
    Ok(())
}
