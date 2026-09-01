use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis::control::{send_request, Campaign, Manifest, Response};
use serde::Serialize;
use serde_json::{json, Value};
use sha2::{Digest, Sha256};
use std::fs::{File, OpenOptions};
use std::io::{BufRead, BufReader, BufWriter, Read, Write};
use std::os::unix::fs::OpenOptionsExt;
use std::path::{Path, PathBuf};
use std::thread;
use std::time::Duration;

const RESPONSE_LIMIT: usize = 64 * 1024;
const CAMPAIGN_LIMIT: u64 = 4 * 1024 * 1024;

#[derive(Debug, Parser)]
#[command(about = "Matched exact audit of evolution target strategies")]
struct Args {
    #[arg(long)]
    data: PathBuf,
    #[arg(long)]
    seeds: PathBuf,
    #[arg(long)]
    run_root: PathBuf,
    #[arg(long)]
    output: PathBuf,
    #[arg(long = "target-field", required = true)]
    target_fields: Vec<String>,
    #[arg(long = "target-value", required = true, allow_hyphen_values = true)]
    target_values: Vec<i64>,
    #[arg(long, default_value_t = 3)]
    generations: usize,
    #[arg(long, default_value_t = 4)]
    beam: usize,
    #[arg(long, default_value_t = 32)]
    max_candidates: usize,
}

#[derive(Serialize)]
struct StrategyAudit {
    strategy: &'static str,
    tested: u64,
    perfect: u64,
    rows_evaluated: u64,
    evidence_bytes: u64,
    first_perfect_trial: Option<u64>,
    first_perfect_semantic_op_rows: Option<u64>,
    first_perfect_operator: Option<String>,
    best_weighted_correct: u64,
    weighted_rows: u64,
    first_best_trial: Option<u64>,
    first_best_semantic_op_rows: Option<u64>,
    first_best_operator: Option<String>,
    operator_scorecards: Value,
    target_profile: Value,
    best_plan: Value,
    evidence_path: String,
    evidence_sha256: String,
}

#[derive(Serialize)]
struct AuditReport {
    schema: &'static str,
    data: String,
    data_sha256: String,
    seeds: String,
    seeds_sha256: String,
    target_fields: Vec<String>,
    target_values: Vec<i64>,
    generations: usize,
    beam: usize,
    max_candidates: usize,
    strategies: Vec<StrategyAudit>,
}

#[derive(Default)]
struct EvidenceMilestones {
    first_perfect_trial: Option<u64>,
    first_perfect_semantic_op_rows: Option<u64>,
    first_perfect_operator: Option<String>,
    best_weighted_correct: u64,
    weighted_rows: u64,
    first_best_trial: Option<u64>,
    first_best_semantic_op_rows: Option<u64>,
    first_best_operator: Option<String>,
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
    bail!("campaign did not become ready within ten seconds")
}

fn wait_for_evolution(manifest: &Manifest) -> Result<Value> {
    for _ in 0..60_000 {
        let status = require_ok(send_request(
            manifest,
            "evolve-status",
            json!({}),
            RESPONSE_LIMIT,
        )?)?;
        if status["state"] != "running" {
            return Ok(status);
        }
        thread::sleep(Duration::from_millis(1));
    }
    bail!("evolution did not finish within sixty seconds")
}

fn read_seeds(path: &Path) -> Result<Vec<Value>> {
    let file = File::open(path).with_context(|| format!("cannot open {}", path.display()))?;
    let mut seeds = Vec::new();
    for line in BufReader::new(file).lines() {
        let line = line?;
        if line.trim().is_empty() {
            continue;
        }
        if seeds.len() == 32 {
            bail!("seed file exceeds the 32-plan campaign bound");
        }
        seeds.push(serde_json::from_str(&line)?);
    }
    if seeds.is_empty() {
        bail!("seed file is empty");
    }
    Ok(seeds)
}

fn sha256(path: &Path) -> Result<String> {
    let mut file = File::open(path)?;
    let mut digest = Sha256::new();
    let mut buffer = [0_u8; 64 * 1024];
    loop {
        let bytes = file.read(&mut buffer)?;
        if bytes == 0 {
            break;
        }
        digest.update(&buffer[..bytes]);
    }
    Ok(format!("{:x}", digest.finalize()))
}

fn inspect_evidence(path: &Path) -> Result<EvidenceMilestones> {
    let file = File::open(path)?;
    let mut trial = 0_u64;
    let mut semantic_op_rows = 0_u64;
    let mut milestones = EvidenceMilestones::default();
    for line in BufReader::new(file).lines() {
        let record: Value = serde_json::from_str(&line?)?;
        if record.get("generation").is_none() || record.get("operator").is_none() {
            continue;
        }
        trial = trial
            .checked_add(1)
            .context("candidate trial count overflow")?;
        semantic_op_rows = semantic_op_rows
            .checked_add(record["cost"]["semantic_op_rows"].as_u64().unwrap_or(0))
            .context("candidate semantic-op row count overflow")?;
        let evaluation = &record["evaluation"];
        let Some(weighted_correct) = evaluation["weighted_correct"].as_u64() else {
            continue;
        };
        let weighted_rows = evaluation["weighted_rows"]
            .as_u64()
            .context("candidate evaluation omitted weighted row count")?;
        milestones.weighted_rows = milestones.weighted_rows.max(weighted_rows);
        if weighted_correct > milestones.best_weighted_correct {
            milestones.best_weighted_correct = weighted_correct;
            milestones.first_best_trial = Some(trial);
            milestones.first_best_semantic_op_rows = Some(semantic_op_rows);
            milestones.first_best_operator = record["operator"].as_str().map(str::to_owned);
        }
        if weighted_correct == weighted_rows && milestones.first_perfect_trial.is_none() {
            milestones.first_perfect_trial = Some(trial);
            milestones.first_perfect_semantic_op_rows = Some(semantic_op_rows);
            milestones.first_perfect_operator = record["operator"].as_str().map(str::to_owned);
        }
    }
    Ok(milestones)
}

fn run_strategy(args: &Args, seeds: &[Value], strategy: &'static str) -> Result<StrategyAudit> {
    let run_dir = args.run_root.join(strategy);
    let socket_dir = args
        .run_root
        .parent()
        .context("run root must have a parent directory")?;
    let socket = socket_dir.join(format!(
        ".target-strategy-{}-{strategy}.sock",
        std::process::id()
    ));
    let campaign = Campaign::create(
        &args.data,
        &run_dir,
        Some(socket),
        CAMPAIGN_LIMIT,
        RESPONSE_LIMIT,
        CAMPAIGN_LIMIT,
    )?;
    let manifest = campaign.manifest().clone();
    let server = thread::spawn(move || campaign.serve());
    wait_until_ready(&manifest)?;
    require_ok(send_request(
        &manifest,
        "target-profile-reset",
        json!({"fields": args.target_fields}),
        RESPONSE_LIMIT,
    )?)?;
    require_ok(send_request(
        &manifest,
        "target-profile-observe",
        json!({
            "values": args.target_values,
            "mass": 1,
            "unit_cost": 1,
            "strategy": strategy,
        }),
        RESPONSE_LIMIT,
    )?)?;
    let started = require_ok(send_request(
        &manifest,
        "evolve-start",
        json!({
            "seeds": seeds,
            "evidence_name": format!("target-strategy-{strategy}"),
            "generations": args.generations,
            "beam": args.beam,
            "max_candidates": args.max_candidates,
            "target_fields": args.target_fields,
            "target_profile": "current",
            "max_evidence_bytes": CAMPAIGN_LIMIT,
        }),
        RESPONSE_LIMIT,
    )?)?;
    if started["state"] != "running" {
        bail!("{strategy} evolution did not start");
    }
    let completed = wait_for_evolution(&manifest)?;
    if completed["state"] != "complete" {
        bail!("{strategy} evolution failed: {completed}");
    }
    require_ok(send_request(
        &manifest,
        "shutdown",
        json!({}),
        RESPONSE_LIMIT,
    )?)?;
    server
        .join()
        .map_err(|_| anyhow::anyhow!("{strategy} campaign thread panicked"))??;
    let relative = completed["path"]
        .as_str()
        .context("completed evolution omitted evidence path")?;
    let evidence_path = run_dir.join(relative);
    let milestones = inspect_evidence(&evidence_path)?;
    let summary = &completed["summary"];
    let evidence_bytes = std::fs::metadata(&evidence_path)?.len();
    if summary["bytes"].as_u64() != Some(evidence_bytes) {
        bail!("{strategy} evidence length disagrees with its stable summary");
    }
    Ok(StrategyAudit {
        strategy,
        tested: summary["tested"].as_u64().unwrap_or(0),
        perfect: summary["perfect"].as_u64().unwrap_or(0),
        rows_evaluated: summary["rows_evaluated"].as_u64().unwrap_or(0),
        evidence_bytes,
        first_perfect_trial: milestones.first_perfect_trial,
        first_perfect_semantic_op_rows: milestones.first_perfect_semantic_op_rows,
        first_perfect_operator: milestones.first_perfect_operator,
        best_weighted_correct: milestones.best_weighted_correct,
        weighted_rows: milestones.weighted_rows,
        first_best_trial: milestones.first_best_trial,
        first_best_semantic_op_rows: milestones.first_best_semantic_op_rows,
        first_best_operator: milestones.first_best_operator,
        operator_scorecards: summary["operator_scorecards"].clone(),
        target_profile: summary["target_profile"].clone(),
        best_plan: summary["best"]["plan"].clone(),
        evidence_path: evidence_path.display().to_string(),
        evidence_sha256: sha256(&evidence_path)?,
    })
}

fn main() -> Result<()> {
    let args = Args::parse();
    if args.target_fields.len() != args.target_values.len() {
        bail!("target field and value counts differ");
    }
    std::fs::create_dir(&args.run_root)
        .with_context(|| format!("cannot create {}", args.run_root.display()))?;
    let seeds = read_seeds(&args.seeds)?;
    let mut strategies = Vec::with_capacity(3);
    for strategy in ["balanced", "numeric", "structural"] {
        strategies.push(run_strategy(&args, &seeds, strategy)?);
    }
    let report = AuditReport {
        schema: "ergodis-private-target-strategy-audit-v0",
        data: args.data.display().to_string(),
        data_sha256: sha256(&args.data)?,
        seeds: args.seeds.display().to_string(),
        seeds_sha256: sha256(&args.seeds)?,
        target_fields: args.target_fields,
        target_values: args.target_values,
        generations: args.generations,
        beam: args.beam,
        max_candidates: args.max_candidates,
        strategies,
    };
    let file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .open(&args.output)
        .with_context(|| format!("cannot create {}", args.output.display()))?;
    let mut writer = BufWriter::new(file);
    serde_json::to_writer_pretty(&mut writer, &report)?;
    writer.write_all(b"\n")?;
    writer.flush()?;
    println!("{}", serde_json::to_string(&report)?);
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn evidence_milestones_keep_first_final_best_and_perfect() {
        let path = std::env::temp_dir().join(format!(
            "ergodis-target-strategy-evidence-{}.jsonl",
            std::process::id()
        ));
        let mut file = OpenOptions::new()
            .write(true)
            .create_new(true)
            .open(&path)
            .unwrap();
        for record in [
            json!({"generation": 0, "operator": "seed", "cost": {"semantic_op_rows": 10}, "evaluation": {"weighted_correct": 4, "weighted_rows": 10}}),
            json!({"generation": 0, "operator": "numeric", "cost": {"semantic_op_rows": 20}, "evaluation": {"weighted_correct": 7, "weighted_rows": 10}}),
            json!({"generation": 1, "operator": "exact", "cost": {"semantic_op_rows": 30}, "evaluation": {"weighted_correct": 10, "weighted_rows": 10}}),
            json!({"generation": 1, "operator": "duplicate", "cost": {"semantic_op_rows": 40}, "evaluation": {"weighted_correct": 10, "weighted_rows": 10}}),
        ] {
            writeln!(file, "{}", serde_json::to_string(&record).unwrap()).unwrap();
        }
        let milestones = inspect_evidence(&path).unwrap();
        assert_eq!(milestones.best_weighted_correct, 10);
        assert_eq!(milestones.weighted_rows, 10);
        assert_eq!(milestones.first_best_trial, Some(3));
        assert_eq!(milestones.first_best_semantic_op_rows, Some(60));
        assert_eq!(milestones.first_best_operator.as_deref(), Some("exact"));
        assert_eq!(milestones.first_perfect_trial, Some(3));
        assert_eq!(milestones.first_perfect_semantic_op_rows, Some(60));
        assert_eq!(milestones.first_perfect_operator.as_deref(), Some("exact"));
        std::fs::remove_file(path).unwrap();
    }
}
