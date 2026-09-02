//! Generic existential projection of an exact labelled feature domain.

use std::collections::BTreeSet;
use std::fs::{self, File};
use std::io::{BufRead, BufReader, BufWriter, Write};
use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use clap::Parser;
use serde_json::{json, Value};
use sha2::{Digest, Sha256};

#[derive(Debug, Parser)]
struct Args {
    #[arg(long)]
    train: PathBuf,
    #[arg(long)]
    holdout: PathBuf,
    #[arg(long)]
    output: PathBuf,
}

struct Corpus {
    fields: Vec<String>,
    rows: Vec<(bool, Vec<i64>)>,
}

fn read(path: &Path) -> Result<Corpus> {
    let mut lines = BufReader::new(File::open(path)?).lines();
    let header: Value = serde_json::from_str(
        &lines
            .next()
            .context("empty feature corpus")?
            .context("cannot read feature header")?,
    )?;
    let fields = header["fields"]
        .as_array()
        .context("feature header omitted fields")?
        .iter()
        .map(|value| {
            value
                .as_str()
                .context("non-string field")
                .map(str::to_owned)
        })
        .collect::<Result<Vec<_>>>()?;
    let mut rows = Vec::new();
    for line in lines {
        let value: Value = serde_json::from_str(&line?)?;
        let expected = value["expected"].as_bool().context("missing label")?;
        let values = value["values"]
            .as_array()
            .context("missing values")?
            .iter()
            .map(|entry| entry.as_i64().context("non-integer feature"))
            .collect::<Result<Vec<_>>>()?;
        if values.len() != fields.len() {
            anyhow::bail!("feature width mismatch");
        }
        rows.push((expected, values));
    }
    Ok(Corpus { fields, rows })
}

fn write_projection(
    path: &Path,
    split: &str,
    values: &BTreeSet<i64>,
    reachable: &BTreeSet<i64>,
    commitment: &str,
) -> Result<()> {
    let mut writer = BufWriter::new(File::create(path)?);
    serde_json::to_writer(
        &mut writer,
        &json!({
            "schema": "ergodis-campaign-data-v0",
            "presentation": format!("existential-feature-support-{split}-v1"),
            "problem": "opaque-existential-feature-support",
            "fields": ["value"],
            "rows": values.len(),
            "generator": {
                "name": "c1016-generic-existential-feature-projector",
                "version": "1",
                "digest": commitment,
            }
        }),
    )?;
    writer.write_all(b"\n")?;
    for (id, &value) in values.iter().enumerate() {
        serde_json::to_writer(
            &mut writer,
            &json!({"id": id, "expected": reachable.contains(&value), "values": [value]}),
        )?;
        writer.write_all(b"\n")?;
    }
    writer.flush()?;
    Ok(())
}

fn main() -> Result<()> {
    let args = Args::parse();
    let train = read(&args.train)?;
    let holdout = read(&args.holdout)?;
    if train.fields != holdout.fields || train.fields.is_empty() {
        anyhow::bail!("train/holdout feature schemas differ or are empty");
    }
    let rows: Vec<&(bool, Vec<i64>)> = train.rows.iter().chain(&holdout.rows).collect();
    let mut maximum_pruned = 0_usize;
    for field in 0..train.fields.len() {
        let reachable: BTreeSet<i64> = rows
            .iter()
            .filter_map(|row| row.0.then_some(row.1[field]))
            .collect();
        let pruned = rows
            .iter()
            .filter(|row| !row.0 && !reachable.contains(&row.1[field]))
            .count();
        maximum_pruned = maximum_pruned.max(pruned);
    }
    if maximum_pruned == 0 {
        anyhow::bail!("no feature has a nontrivial unreachable support gap");
    }
    fs::create_dir(&args.output).context("cannot create projection output")?;
    let mut candidates = Vec::new();
    for field in 0..train.fields.len() {
        let reachable: BTreeSet<i64> = rows
            .iter()
            .filter_map(|row| row.0.then_some(row.1[field]))
            .collect();
        let pruned = rows
            .iter()
            .filter(|row| !row.0 && !reachable.contains(&row.1[field]))
            .count();
        if pruned != maximum_pruned {
            continue;
        }
        let values: BTreeSet<i64> = rows.iter().map(|row| row.1[field]).collect();
        let source = serde_json::to_vec(&json!({
            "field": train.fields[field],
            "values": values,
            "reachable": reachable,
        }))?;
        let commitment = format!("{:x}", Sha256::digest(source));
        let name = format!("projection-f{field:03}");
        write_projection(
            &args.output.join(format!("{name}-train.jsonl")),
            "train",
            &values,
            &reachable,
            &commitment,
        )?;
        write_projection(
            &args.output.join(format!("{name}-holdout.jsonl")),
            "holdout",
            &values,
            &reachable,
            &commitment,
        )?;
        candidates.push(json!({
            "source_field": train.fields[field],
            "source_field_index": field,
            "domain_values": values,
            "reachable_values": reachable,
            "pruned_negative_rows": pruned,
            "source_commitment": commitment,
        }));
    }
    println!(
        "{}",
        serde_json::to_string(&json!({
            "maximum_pruned_negative_rows": maximum_pruned,
            "pareto_candidates": candidates,
            "provenance": "generic exhaustive existential projection over all supplied fields; every maximum-pruning support is retained instead of resolving ties by local score; duplicated projected presentations test deterministic replay, while downstream consumers choose useful scopes and authority remains with the exact source extractor",
        }))?
    );
    Ok(())
}
