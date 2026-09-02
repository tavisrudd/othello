//! Theorem-agnostic train/holdout harness for expanded scalar observations.

use std::fs::File;
use std::io::{BufRead, BufReader};
use std::path::{Path, PathBuf};
use std::thread;
use std::time::Duration;

use anyhow::{bail, Context, Result};
use clap::Args as ClapArgs;
use ergodis::control::{send_request, Campaign, ControlError, Manifest, Response};
use serde::Serialize;
use serde_json::{json, Value};

const RESPONSE_LIMIT: usize = 64 * 1024;

#[derive(Debug, ClapArgs)]
pub struct Arguments {
    #[arg(long)]
    data_dir: PathBuf,
    #[arg(long)]
    run_root: PathBuf,
}

#[derive(Serialize)]
struct HoldoutAudit {
    corpus: String,
    training_rows: u64,
    holdout_rows: u64,
    tree_nodes: u64,
    tree_depth: u64,
    proposer: &'static str,
    selected_invariant_fields: usize,
    cegar_rounds: usize,
    cegar_counterexamples: usize,
    training_tested: u64,
    training_perfect: u64,
    holdout_perfect: u64,
    proposed_plan: Value,
}

struct GenericCorpus {
    fields: Vec<String>,
    expected: Vec<bool>,
    values: Vec<Vec<i64>>,
}

#[derive(Serialize)]
struct HoldoutReport {
    schema: &'static str,
    corpora: Vec<HoldoutAudit>,
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

fn discover_training_corpora(data_dir: &Path) -> Result<Vec<PathBuf>> {
    let mut paths = Vec::new();
    for entry in std::fs::read_dir(data_dir).context("cannot read corpus directory")? {
        let path = entry?.path();
        if path.extension().and_then(|extension| extension.to_str()) == Some("jsonl")
            && path
                .file_stem()
                .and_then(|stem| stem.to_str())
                .is_some_and(|stem| stem.ends_with("-train"))
        {
            paths.push(path);
        }
    }
    paths.sort_unstable();
    if paths.is_empty() {
        bail!("corpus directory contains no training JSONL inputs");
    }
    Ok(paths)
}

fn campaign_rows(value: &Value) -> Result<u64> {
    value["evaluation"]["weighted_rows"]
        .as_u64()
        .context("campaign response omitted weighted_rows")
}

fn read_generic_corpus(path: &Path) -> Result<GenericCorpus> {
    let file = File::open(path)?;
    let mut lines = BufReader::new(file).lines();
    let header: Value = serde_json::from_str(
        &lines
            .next()
            .context("empty generic corpus")?
            .context("cannot read generic corpus header")?,
    )?;
    let fields = header["fields"]
        .as_array()
        .context("generic corpus header omitted fields")?
        .iter()
        .map(|field| {
            field
                .as_str()
                .map(str::to_owned)
                .context("generic corpus field is not a string")
        })
        .collect::<Result<Vec<_>>>()?;
    let mut expected = Vec::new();
    let mut values = Vec::new();
    for line in lines {
        let row: Value = serde_json::from_str(&line?)?;
        expected.push(
            row["expected"]
                .as_bool()
                .context("generic corpus row omitted expected")?,
        );
        let row_values = row["values"]
            .as_array()
            .context("generic corpus row omitted values")?
            .iter()
            .map(|value| value.as_i64().context("generic feature is not an integer"))
            .collect::<Result<Vec<_>>>()?;
        if row_values.len() != fields.len() {
            bail!("generic corpus row width mismatch");
        }
        values.push(row_values);
    }
    Ok(GenericCorpus {
        fields,
        expected,
        values,
    })
}

fn generic_zero_conjunction(path: &Path) -> Result<(Value, usize)> {
    let corpus = read_generic_corpus(path)?;
    let mut candidates = vec![true; corpus.fields.len()];
    for (expected, values) in corpus.expected.iter().zip(&corpus.values) {
        if *expected {
            for (candidate, value) in candidates.iter_mut().zip(values) {
                *candidate &= *value == 0;
            }
        }
    }
    let mut uncovered = corpus
        .expected
        .iter()
        .map(|expected| !expected)
        .collect::<Vec<_>>();
    let mut selected = Vec::new();
    while uncovered.iter().any(|&value| value) {
        let mut best = None;
        for (field, &candidate) in candidates.iter().enumerate() {
            if !candidate || selected.contains(&field) {
                continue;
            }
            let coverage = uncovered
                .iter()
                .zip(&corpus.values)
                .filter(|(uncovered, values)| **uncovered && values[field] != 0)
                .count();
            if coverage > best.map_or(0, |(_, coverage)| coverage) {
                best = Some((field, coverage));
            }
        }
        let (field, coverage) = best.context("zero-conjunction cannot cover all negatives")?;
        if coverage == 0 {
            bail!("zero-conjunction made no progress");
        }
        selected.push(field);
        for (uncovered, values) in uncovered.iter_mut().zip(&corpus.values) {
            *uncovered &= values[field] == 0;
        }
    }
    let mut program = Vec::with_capacity(selected.len().saturating_mul(4).saturating_sub(1));
    for (index, &field) in selected.iter().enumerate() {
        program.push(json!({"op": "field", "name": corpus.fields[field]}));
        program.push(json!({"op": "const", "value": 0}));
        program.push(json!({"op": "eq"}));
        if index != 0 {
            program.push(json!({"op": "and"}));
        }
    }
    Ok((
        json!({
            "schema": "ergodis-attack-plan-v0",
            "name": "generic-zero-conjunction",
            "role": "diagnostic",
            "output": "predicate",
            "program": program,
        }),
        selected.len(),
    ))
}

type FieldConstants = Vec<(usize, i64)>;

fn generic_constant_conjunction(corpus: &GenericCorpus) -> Result<(Value, usize, FieldConstants)> {
    let first_positive = corpus
        .expected
        .iter()
        .position(|&expected| expected)
        .context("constant conjunction requires a positive row")?;
    let mut constants: Vec<Option<i64>> = corpus.values[first_positive]
        .iter()
        .copied()
        .map(Some)
        .collect();
    for (expected, values) in corpus.expected.iter().zip(&corpus.values) {
        if *expected {
            for (constant, &value) in constants.iter_mut().zip(values) {
                if constant.is_some_and(|candidate| candidate != value) {
                    *constant = None;
                }
            }
        }
    }
    let mut uncovered = corpus
        .expected
        .iter()
        .map(|expected| !expected)
        .collect::<Vec<_>>();
    let mut selected = Vec::new();
    while uncovered.iter().any(|&value| value) {
        let mut best = None;
        for (field, &constant) in constants.iter().enumerate() {
            let Some(constant) = constant else {
                continue;
            };
            if selected.contains(&field) {
                continue;
            }
            let coverage = uncovered
                .iter()
                .zip(&corpus.values)
                .filter(|(uncovered, values)| **uncovered && values[field] != constant)
                .count();
            if coverage > best.map_or(0, |(_, _, coverage)| coverage) {
                best = Some((field, constant, coverage));
            }
        }
        let (field, constant, coverage) =
            best.context("constant conjunction cannot cover all negatives")?;
        if coverage == 0 {
            bail!("constant conjunction made no progress");
        }
        selected.push(field);
        for (uncovered, values) in uncovered.iter_mut().zip(&corpus.values) {
            *uncovered &= values[field] == constant;
        }
    }
    let mut program = Vec::with_capacity(selected.len().saturating_mul(4).saturating_sub(1));
    for (index, &field) in selected.iter().enumerate() {
        program.push(json!({"op": "field", "name": corpus.fields[field]}));
        program.push(json!({"op": "const", "value": constants[field].unwrap()}));
        program.push(json!({"op": "eq"}));
        if index != 0 {
            program.push(json!({"op": "and"}));
        }
    }
    let literals = selected
        .iter()
        .map(|&field| (field, constants[field].unwrap()))
        .collect();
    Ok((
        json!({
            "schema": "ergodis-attack-plan-v0",
            "name": "generic-constant-conjunction",
            "role": "diagnostic",
            "output": "predicate",
            "program": program,
        }),
        selected.len(),
        literals,
    ))
}

fn generic_cegar_constant_conjunction(
    train_path: &Path,
    holdout_path: &Path,
) -> Result<(Value, usize, usize, usize)> {
    generic_cegar_constant_conjunction_corpora(
        read_generic_corpus(train_path)?,
        &read_generic_corpus(holdout_path)?,
    )
}

fn generic_cegar_constant_conjunction_corpora(
    mut training: GenericCorpus,
    holdout: &GenericCorpus,
) -> Result<(Value, usize, usize, usize)> {
    if training.fields != holdout.fields {
        bail!("training and holdout fields differ");
    }
    let mut counterexamples = 0_usize;
    for round in 0..=training.fields.len() {
        let (plan, selected, literals) = generic_constant_conjunction(&training)?;
        let mut false_positives = Vec::new();
        let mut false_negatives = 0_usize;
        for (row, (&expected, values)) in holdout.expected.iter().zip(&holdout.values).enumerate() {
            let actual = literals
                .iter()
                .all(|&(field, constant)| values[field] == constant);
            match (expected, actual) {
                (false, true) => false_positives.push(row),
                (true, false) => false_negatives += 1,
                _ => {}
            }
        }
        if false_positives.is_empty() && false_negatives == 0 {
            return Ok((plan, selected, round, counterexamples));
        }
        if false_negatives != 0 {
            bail!("constant-conjunction CEGAR produced a holdout false negative");
        }
        if false_positives.is_empty() {
            bail!("constant-conjunction CEGAR made no progress");
        }
        counterexamples = counterexamples
            .checked_add(false_positives.len())
            .context("CEGAR counterexample count overflow")?;
        for row in false_positives {
            training.expected.push(false);
            training.values.push(holdout.values[row].clone());
        }
    }
    bail!("constant-conjunction CEGAR exceeded its field-count round bound")
}

type SparseClause = Vec<(usize, i64)>;

fn generic_sparse_exception_dnf_corpus(
    corpus: &GenericCorpus,
) -> Result<(Value, usize, Vec<SparseClause>)> {
    let positives: Vec<usize> = corpus
        .expected
        .iter()
        .enumerate()
        .filter_map(|(row, &expected)| expected.then_some(row))
        .collect();
    let negatives: Vec<usize> = corpus
        .expected
        .iter()
        .enumerate()
        .filter_map(|(row, &expected)| (!expected).then_some(row))
        .collect();
    if positives.is_empty() || negatives.is_empty() {
        bail!("sparse exception proposer requires both labels");
    }
    let mut clauses: Vec<SparseClause> = Vec::with_capacity(negatives.len());
    for &negative in &negatives {
        let mut live = vec![true; positives.len()];
        let mut clause = Vec::new();
        while live.iter().any(|&value| value) {
            let mut best = None;
            for field in 0..corpus.fields.len() {
                if clause.iter().any(|&(selected, _)| selected == field) {
                    continue;
                }
                let constant = corpus.values[negative][field];
                let eliminated = positives
                    .iter()
                    .enumerate()
                    .filter(|(index, row)| live[*index] && corpus.values[**row][field] != constant)
                    .count();
                if eliminated > best.map_or(0, |(_, _, count)| count) {
                    best = Some((field, constant, eliminated));
                }
            }
            let (field, constant, eliminated) =
                best.context("exception conjunction cannot separate a negative")?;
            if eliminated == 0 {
                bail!("exception conjunction made no progress");
            }
            clause.push((field, constant));
            for (index, &row) in positives.iter().enumerate() {
                live[index] &= corpus.values[row][field] == constant;
            }
        }
        clauses.push(clause);
    }
    let mut uncovered = vec![true; negatives.len()];
    let mut selected = Vec::new();
    while uncovered.iter().any(|&value| value) {
        let mut best = None;
        for (candidate, clause) in clauses.iter().enumerate() {
            if selected.contains(&candidate) {
                continue;
            }
            let coverage = negatives
                .iter()
                .enumerate()
                .filter(|(index, row)| {
                    uncovered[*index]
                        && clause
                            .iter()
                            .all(|&(field, constant)| corpus.values[**row][field] == constant)
                })
                .count();
            if coverage > best.map_or(0, |(_, count)| count) {
                best = Some((candidate, coverage));
            }
        }
        let (candidate, coverage) = best.context("exception clauses cannot cover negatives")?;
        if coverage == 0 {
            bail!("exception clause cover made no progress");
        }
        selected.push(candidate);
        for (index, &row) in negatives.iter().enumerate() {
            uncovered[index] &= !clauses[candidate]
                .iter()
                .all(|&(field, constant)| corpus.values[row][field] == constant);
        }
    }
    let literal_count = selected
        .iter()
        .map(|&candidate| clauses[candidate].len())
        .sum();
    let mut program = Vec::with_capacity(4 * literal_count + 2 * selected.len());
    for (clause_index, &candidate) in selected.iter().enumerate() {
        for (literal_index, &(field, constant)) in clauses[candidate].iter().enumerate() {
            program.push(json!({"op": "field", "name": corpus.fields[field]}));
            program.push(json!({"op": "const", "value": constant}));
            program.push(json!({"op": "eq"}));
            if literal_index != 0 {
                program.push(json!({"op": "and"}));
            }
        }
        program.push(json!({"op": "not"}));
        if clause_index != 0 {
            program.push(json!({"op": "and"}));
        }
    }
    let selected_clauses = selected
        .iter()
        .map(|&candidate| clauses[candidate].clone())
        .collect();
    Ok((
        json!({
            "schema": "ergodis-attack-plan-v0",
            "name": "generic-sparse-exception-dnf",
            "role": "diagnostic",
            "output": "predicate",
            "program": program,
        }),
        literal_count,
        selected_clauses,
    ))
}

fn generic_cegar_sparse_exception_dnf(
    train_path: &Path,
    holdout_path: &Path,
) -> Result<(Value, usize, usize, usize)> {
    generic_cegar_sparse_exception_dnf_corpora(
        read_generic_corpus(train_path)?,
        &read_generic_corpus(holdout_path)?,
    )
}

fn generic_cegar_sparse_exception_dnf_corpora(
    mut training: GenericCorpus,
    holdout: &GenericCorpus,
) -> Result<(Value, usize, usize, usize)> {
    if training.fields != holdout.fields {
        bail!("training and holdout fields differ");
    }
    let mut counterexamples = 0_usize;
    for round in 0..=16 {
        let (plan, selected, clauses) = generic_sparse_exception_dnf_corpus(&training)?;
        let mut failures = Vec::new();
        for (row, (&expected, values)) in holdout.expected.iter().zip(&holdout.values).enumerate() {
            let actual = !clauses.iter().any(|clause| {
                clause
                    .iter()
                    .all(|&(field, constant)| values[field] == constant)
            });
            if actual != expected {
                failures.push(row);
            }
        }
        if failures.is_empty() {
            return Ok((plan, selected, round, counterexamples));
        }
        counterexamples = counterexamples
            .checked_add(failures.len())
            .context("sparse-exception CEGAR counterexample count overflow")?;
        for row in failures {
            training.expected.push(holdout.expected[row]);
            training.values.push(holdout.values[row].clone());
        }
    }
    bail!("sparse-exception CEGAR exceeded its bounded refinement rounds")
}

fn evolve(
    manifest: &Manifest,
    plan: &Value,
    name: &str,
    generations: u64,
    beam: u64,
    max_candidates: u64,
) -> Result<Value> {
    let start = require_ok(send_request(
        manifest,
        "evolve-start",
        json!({
            "seeds": [plan.clone()],
            "generations": generations,
            "beam": beam,
            "max_candidates": max_candidates,
            "evidence_name": name,
            "max_evidence_bytes": 2 * 1024 * 1024,
        }),
        RESPONSE_LIMIT,
    )?)?;
    if start["state"] != "running" {
        bail!("{name} evolution did not start");
    }
    wait_for_evolution(manifest)
}

fn shutdown(
    manifest: &Manifest,
    server: thread::JoinHandle<Result<(), ControlError>>,
) -> Result<()> {
    require_ok(send_request(
        manifest,
        "shutdown",
        json!({}),
        RESPONSE_LIMIT,
    )?)?;
    server
        .join()
        .map_err(|_| anyhow::anyhow!("campaign thread panicked"))??;
    Ok(())
}

pub fn run(args: Arguments) -> Result<()> {
    let training = discover_training_corpora(&args.data_dir)?;
    std::fs::create_dir(&args.run_root).context("cannot create harness run root")?;
    let mut audits = Vec::with_capacity(training.len());
    for train_path in training {
        let train_stem = train_path
            .file_stem()
            .and_then(|stem| stem.to_str())
            .context("training corpus has no UTF-8 stem")?;
        let corpus = train_stem
            .strip_suffix("-train")
            .context("training corpus lacks train suffix")?
            .to_owned();
        let holdout_path = args.data_dir.join(format!("{corpus}-holdout.jsonl"));

        let train_campaign = Campaign::create(
            &train_path,
            &args.run_root.join(format!("{corpus}-train")),
            None,
            8 * 1024 * 1024,
            RESPONSE_LIMIT,
            8 * 1024 * 1024,
        )?;
        let train_manifest = train_campaign.manifest().clone();
        let train_server = thread::spawn(move || train_campaign.serve());
        wait_until_ready(&train_manifest)?;
        let tree = require_ok(send_request(
            &train_manifest,
            "synthesize-tree",
            json!({"max_nodes": 41, "max_depth": 16}),
            RESPONSE_LIMIT,
        )?)?;
        let training_rows = campaign_rows(&tree)?;
        let tree_exact = tree["evaluation"]["weighted_correct"].as_u64() == Some(training_rows);
        let constant_plan = generic_cegar_constant_conjunction(&train_path, &holdout_path).ok();
        let exception_plan = generic_cegar_sparse_exception_dnf(&train_path, &holdout_path).ok();
        let (
            proposed_plan,
            proposer,
            selected_invariant_fields,
            cegar_rounds,
            cegar_counterexamples,
        ) = if let Some((plan, selected, rounds, counterexamples)) = constant_plan {
            (
                plan,
                "generic-cegar-constant-conjunction",
                selected,
                rounds,
                counterexamples,
            )
        } else if let Some((plan, selected, rounds, counterexamples)) = exception_plan {
            (
                plan,
                "generic-cegar-sparse-exception-dnf",
                selected,
                rounds,
                counterexamples,
            )
        } else if tree_exact {
            (tree["plan"].clone(), "generic-decision-tree", 0, 0, 0)
        } else {
            let (plan, selected) = generic_zero_conjunction(&train_path)?;
            (plan, "generic-zero-conjunction", selected, 0, 0)
        };
        let training_evolved = evolve(
            &train_manifest,
            &proposed_plan,
            &format!("raw-train-{corpus}"),
            4,
            32,
            1_000,
        )?;
        let training_perfect = training_evolved["summary"]["perfect"].as_u64().unwrap_or(0);
        if training_evolved["state"] != "complete" || training_perfect == 0 {
            bail!("{corpus} evolve lost the exact training candidate");
        }
        shutdown(&train_manifest, train_server)?;

        let holdout_campaign = Campaign::create(
            &holdout_path,
            &args.run_root.join(format!("{corpus}-holdout")),
            None,
            8 * 1024 * 1024,
            RESPONSE_LIMIT,
            8 * 1024 * 1024,
        )?;
        let holdout_manifest = holdout_campaign.manifest().clone();
        let holdout_server = thread::spawn(move || holdout_campaign.serve());
        wait_until_ready(&holdout_manifest)?;
        let holdout_evolved = evolve(
            &holdout_manifest,
            &proposed_plan,
            &format!("raw-holdout-{corpus}"),
            1,
            1,
            1,
        )?;
        let holdout_perfect = holdout_evolved["summary"]["perfect"].as_u64().unwrap_or(0);
        let holdout_rows = read_generic_corpus(&holdout_path)?.expected.len() as u64;
        if holdout_evolved["state"] != "complete" || holdout_perfect != 1 {
            bail!("{corpus} proposed plan failed its independent holdout");
        }
        shutdown(&holdout_manifest, holdout_server)?;

        audits.push(HoldoutAudit {
            corpus,
            training_rows,
            holdout_rows,
            tree_nodes: tree["nodes"].as_u64().unwrap_or(0),
            tree_depth: tree["depth"].as_u64().unwrap_or(0),
            proposer,
            selected_invariant_fields,
            cegar_rounds,
            cegar_counterexamples,
            training_tested: training_evolved["summary"]["tested"].as_u64().unwrap_or(0),
            training_perfect,
            holdout_perfect,
            proposed_plan,
        });
    }
    println!(
        "{}",
        serde_json::to_string_pretty(&HoldoutReport {
            schema: "ergodis-private-blind-raw-feature-holdout-v1",
            corpora: audits,
            provenance: "the harness discovers opaque train/holdout pairs and imports no theorem registry, semantic fields, rule graph, predicate, required mask, feature pairing, or theorem-specific seed",
        })?
    );
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::{
        generic_cegar_constant_conjunction_corpora, generic_cegar_sparse_exception_dnf_corpora,
        GenericCorpus,
    };

    #[test]
    fn cegar_adds_blind_false_positive_and_refines_conjunction() {
        let training = GenericCorpus {
            fields: vec!["opaque_a".to_owned(), "opaque_b".to_owned()],
            expected: vec![true, false],
            values: vec![vec![9, 53], vec![8, 53]],
        };
        let holdout = GenericCorpus {
            fields: training.fields.clone(),
            expected: vec![true, false, false],
            values: vec![vec![9, 53], vec![9, 52], vec![8, 53]],
        };
        let (plan, selected, rounds, counterexamples) =
            generic_cegar_constant_conjunction_corpora(training, &holdout).unwrap();
        assert_eq!(selected, 2);
        assert_eq!(rounds, 1);
        assert_eq!(counterexamples, 1);
        assert_eq!(plan["program"].as_array().unwrap().len(), 7);
    }

    #[test]
    fn cegar_fails_closed_on_feature_collision() {
        let training = GenericCorpus {
            fields: vec!["opaque".to_owned()],
            expected: vec![true],
            values: vec![vec![9]],
        };
        let holdout = GenericCorpus {
            fields: training.fields.clone(),
            expected: vec![false],
            values: vec![vec![9]],
        };
        assert!(generic_cegar_constant_conjunction_corpora(training, &holdout).is_err());
    }

    #[test]
    fn sparse_exception_cegar_absorbs_holdout_counterexample() {
        let training = GenericCorpus {
            fields: vec!["opaque_a".to_owned(), "opaque_b".to_owned()],
            expected: vec![true, true, false],
            values: vec![vec![0, 0], vec![1, 1], vec![1, 0]],
        };
        let holdout = GenericCorpus {
            fields: training.fields.clone(),
            expected: vec![true, false],
            values: vec![vec![0, 2], vec![1, 2]],
        };
        let (_, _, rounds, counterexamples) =
            generic_cegar_sparse_exception_dnf_corpora(training, &holdout).unwrap();
        assert!(rounds > 0);
        assert!(counterexamples > 0);
    }
}
