use anyhow::{bail, Context, Result};
use clap::Args as ClapArgs;
use serde::Serialize;
use serde_json::Value;
use sha2::{Digest, Sha256};
use std::collections::{BTreeMap, BTreeSet};
use std::fs::{File, OpenOptions};
use std::io::{BufReader, BufWriter, Read, Write};
use std::os::unix::fs::OpenOptionsExt;
use std::path::{Path, PathBuf};

#[derive(Debug, ClapArgs)]
pub struct Args {
    #[arg(long, required = true, num_args = 2..)]
    report: Vec<PathBuf>,
    #[arg(long, default_value = ".")]
    package_root: PathBuf,
    #[arg(long, default_value_t = 2)]
    minimum_reports: usize,
    #[arg(long)]
    output: PathBuf,
}

#[derive(Clone, Debug, Eq, Ord, PartialEq, PartialOrd)]
struct PolicyKey {
    fields: Vec<String>,
    values: Vec<i64>,
}

#[derive(Clone, Debug, Serialize)]
struct StrategyMetric {
    strategy: String,
    best_weighted_correct: u64,
    weighted_rows: u64,
    first_best_trial: u64,
    first_best_semantic_op_rows: u64,
    tested: u64,
    evidence_bytes: u64,
}

#[derive(Clone, Debug, Serialize)]
struct MatchedAudit {
    report: String,
    report_sha256: String,
    data_sha256: String,
    seeds_sha256: String,
    strategies: Vec<StrategyMetric>,
}

#[derive(Clone, Debug, Serialize)]
struct RouteAggregate {
    strategy: String,
    safe: bool,
    wins: usize,
    ties: usize,
    losses: usize,
    total_first_best_semantic_op_rows: u64,
    total_evidence_bytes: u64,
}

#[derive(Serialize)]
struct PolicyDecision {
    target_fields: Vec<String>,
    target_values: Vec<i64>,
    reports: Vec<MatchedAudit>,
    aggregates: Vec<RouteAggregate>,
    recommended_strategy: &'static str,
    learned: bool,
    reason: &'static str,
    balanced_cost: u64,
    recommended_cost: u64,
}

#[derive(Serialize)]
struct PolicyReport {
    schema: &'static str,
    minimum_reports: usize,
    decisions: Vec<PolicyDecision>,
}

fn sha256(path: &Path) -> Result<String> {
    let mut file = File::open(path)?;
    let mut digest = Sha256::new();
    let mut buffer = [0_u8; 16 * 1024];
    loop {
        let bytes = file.read(&mut buffer)?;
        if bytes == 0 {
            break;
        }
        digest.update(&buffer[..bytes]);
    }
    Ok(format!("{:x}", digest.finalize()))
}

fn strings(value: &Value, field: &str) -> Result<Vec<String>> {
    value[field]
        .as_array()
        .context("target fields must be an array")?
        .iter()
        .map(|value| {
            value
                .as_str()
                .map(str::to_owned)
                .with_context(|| format!("{field} must contain strings"))
        })
        .collect()
}

fn integers(value: &Value, field: &str) -> Result<Vec<i64>> {
    value[field]
        .as_array()
        .context("target values must be an array")?
        .iter()
        .map(|value| {
            value
                .as_i64()
                .with_context(|| format!("{field} must contain integers"))
        })
        .collect()
}

fn metric(value: &Value) -> Result<StrategyMetric> {
    let required = |field: &str| {
        value[field]
            .as_u64()
            .with_context(|| format!("strategy metric omitted {field}"))
    };
    Ok(StrategyMetric {
        strategy: value["strategy"]
            .as_str()
            .context("strategy metric omitted strategy")?
            .to_owned(),
        best_weighted_correct: required("best_weighted_correct")?,
        weighted_rows: required("weighted_rows")?,
        first_best_trial: required("first_best_trial")?,
        first_best_semantic_op_rows: required("first_best_semantic_op_rows")?,
        tested: required("tested")?,
        evidence_bytes: required("evidence_bytes")?,
    })
}

fn read_audit(path: &Path, package_root: &Path) -> Result<(PolicyKey, MatchedAudit)> {
    let report: Value = serde_json::from_reader(BufReader::new(File::open(path)?))?;
    if report["schema"] != "ergodis-private-target-strategy-audit-v0" {
        bail!("{} has the wrong audit schema", path.display());
    }
    let key = PolicyKey {
        fields: strings(&report, "target_fields")?,
        values: integers(&report, "target_values")?,
    };
    if key.fields.len() != key.values.len() || key.fields.is_empty() {
        bail!("{} has an invalid target tuple", path.display());
    }
    for (field, expected) in [("data", "data_sha256"), ("seeds", "seeds_sha256")] {
        let relative = report[field]
            .as_str()
            .with_context(|| format!("audit omitted {field}"))?;
        let digest = sha256(&package_root.join(relative))?;
        if report[expected].as_str() != Some(&digest) {
            bail!("{} {field} hash mismatch", path.display());
        }
    }
    let mut strategies = Vec::new();
    let mut names = BTreeSet::new();
    for value in report["strategies"]
        .as_array()
        .context("audit omitted strategies")?
    {
        let parsed = metric(value)?;
        if !names.insert(parsed.strategy.clone()) {
            bail!("{} repeats strategy {}", path.display(), parsed.strategy);
        }
        let relative = value["evidence_path"]
            .as_str()
            .context("strategy omitted evidence path")?;
        let evidence = package_root.join(relative);
        if sha256(&evidence)? != value["evidence_sha256"].as_str().unwrap_or_default() {
            bail!("{} evidence hash mismatch", path.display());
        }
        if std::fs::metadata(&evidence)?.len() != parsed.evidence_bytes {
            bail!("{} evidence length mismatch", path.display());
        }
        strategies.push(parsed);
    }
    if names != BTreeSet::from(["balanced".into(), "numeric".into(), "structural".into()]) {
        bail!("{} is not a matched three-strategy audit", path.display());
    }
    strategies.sort_by(|left, right| left.strategy.cmp(&right.strategy));
    let optimum = (
        strategies[0].best_weighted_correct,
        strategies[0].weighted_rows,
    );
    if strategies
        .iter()
        .any(|metric| (metric.best_weighted_correct, metric.weighted_rows) != optimum)
    {
        bail!(
            "{} strategies did not reach the same best score",
            path.display()
        );
    }
    Ok((
        key,
        MatchedAudit {
            report: path.display().to_string(),
            report_sha256: sha256(path)?,
            data_sha256: report["data_sha256"].as_str().unwrap_or_default().into(),
            seeds_sha256: report["seeds_sha256"].as_str().unwrap_or_default().into(),
            strategies,
        },
    ))
}

fn aggregate(reports: &[MatchedAudit], strategy: &str) -> Result<RouteAggregate> {
    let mut aggregate = RouteAggregate {
        strategy: strategy.to_owned(),
        safe: true,
        wins: 0,
        ties: 0,
        losses: 0,
        total_first_best_semantic_op_rows: 0,
        total_evidence_bytes: 0,
    };
    for report in reports {
        let balanced = report
            .strategies
            .iter()
            .find(|metric| metric.strategy == "balanced")
            .context("matched audit omitted balanced strategy")?;
        let candidate = report
            .strategies
            .iter()
            .find(|metric| metric.strategy == strategy)
            .with_context(|| format!("matched audit omitted {strategy} strategy"))?;
        aggregate.total_first_best_semantic_op_rows = aggregate
            .total_first_best_semantic_op_rows
            .checked_add(candidate.first_best_semantic_op_rows)
            .context("aggregate semantic-op row overflow")?;
        aggregate.total_evidence_bytes = aggregate
            .total_evidence_bytes
            .checked_add(candidate.evidence_bytes)
            .context("aggregate evidence byte overflow")?;
        match candidate
            .first_best_semantic_op_rows
            .cmp(&balanced.first_best_semantic_op_rows)
        {
            std::cmp::Ordering::Less => aggregate.wins += 1,
            std::cmp::Ordering::Equal => aggregate.ties += 1,
            std::cmp::Ordering::Greater => {
                aggregate.losses += 1;
                aggregate.safe = false;
            }
        }
    }
    Ok(aggregate)
}

fn decide(
    key: PolicyKey,
    reports: Vec<MatchedAudit>,
    minimum_reports: usize,
) -> Result<PolicyDecision> {
    let balanced = aggregate(&reports, "balanced")?;
    let numeric = aggregate(&reports, "numeric")?;
    let structural = aggregate(&reports, "structural")?;
    let balanced_cost = balanced.total_first_best_semantic_op_rows;
    let mut eligible = [&numeric, &structural]
        .into_iter()
        .filter(|route| route.safe && route.wins != 0 && reports.len() >= minimum_reports)
        .collect::<Vec<_>>();
    eligible.sort_by_key(|route| {
        (
            route.total_first_best_semantic_op_rows,
            route.total_evidence_bytes,
            route.strategy.as_str(),
        )
    });
    let (recommended_strategy, learned, reason, recommended_cost) =
        if let Some(route) = eligible.first() {
            (
                match route.strategy.as_str() {
                    "numeric" => "numeric",
                    "structural" => "structural",
                    _ => unreachable!(),
                },
                true,
                "non-regressing-matched-audit-win",
                route.total_first_best_semantic_op_rows,
            )
        } else {
            (
                "balanced",
                false,
                if reports.len() < minimum_reports {
                    "insufficient-matched-reports"
                } else {
                    "no-non-regressing-route-win"
                },
                balanced_cost,
            )
        };
    Ok(PolicyDecision {
        target_fields: key.fields,
        target_values: key.values,
        reports,
        aggregates: vec![balanced, numeric, structural],
        recommended_strategy,
        learned,
        reason,
        balanced_cost,
        recommended_cost,
    })
}

pub fn run(args: Args) -> Result<()> {
    if args.minimum_reports == 0 {
        bail!("minimum reports must be positive");
    }
    let mut groups = BTreeMap::<PolicyKey, Vec<MatchedAudit>>::new();
    for path in &args.report {
        let (key, audit) = read_audit(path, &args.package_root)?;
        groups.entry(key).or_default().push(audit);
    }
    let decisions = groups
        .into_iter()
        .map(|(key, reports)| decide(key, reports, args.minimum_reports))
        .collect::<Result<Vec<_>>>()?;
    let report = PolicyReport {
        schema: "ergodis-private-routing-policy-v0",
        minimum_reports: args.minimum_reports,
        decisions,
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

    fn audit(balanced: u64, numeric: u64, structural: u64) -> MatchedAudit {
        let metric = |strategy: &str, cost| StrategyMetric {
            strategy: strategy.into(),
            best_weighted_correct: 1,
            weighted_rows: 1,
            first_best_trial: 1,
            first_best_semantic_op_rows: cost,
            tested: 1,
            evidence_bytes: cost,
        };
        MatchedAudit {
            report: String::new(),
            report_sha256: String::new(),
            data_sha256: String::new(),
            seeds_sha256: String::new(),
            strategies: vec![
                metric("balanced", balanced),
                metric("numeric", numeric),
                metric("structural", structural),
            ],
        }
    }

    fn key() -> PolicyKey {
        PolicyKey {
            fields: vec!["root".into()],
            values: vec![0],
        }
    }

    #[test]
    fn policy_learns_only_non_regressing_route() {
        let decision = decide(key(), vec![audit(100, 60, 120), audit(50, 50, 40)], 2).unwrap();
        assert_eq!(decision.recommended_strategy, "numeric");
        assert!(decision.learned);
        assert_eq!(decision.recommended_cost, 110);
    }

    #[test]
    fn policy_abstains_after_any_route_regression() {
        let decision = decide(key(), vec![audit(100, 90, 120), audit(50, 60, 40)], 2).unwrap();
        assert_eq!(decision.recommended_strategy, "balanced");
        assert!(!decision.learned);
    }
}
