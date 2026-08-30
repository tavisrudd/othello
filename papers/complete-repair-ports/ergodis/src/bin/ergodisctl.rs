use anyhow::{bail, Context, Result};
use clap::{Parser, Subcommand};
use ergodis::control::{read_manifest, send_request, PlanDocument, PlanOp, PlanOutput, PlanSpec};
use serde_json::{json, Value};
use std::collections::BTreeSet;
use std::fs::{File, OpenOptions};
use std::io::{BufRead, BufReader, BufWriter, Write};
use std::os::unix::fs::OpenOptionsExt;
use std::path::PathBuf;

#[derive(Debug, Parser)]
#[command(
    name = "ergodisctl",
    about = "Bounded local client for an Ergodis campaign"
)]
struct Cli {
    /// Private durable run directory containing manifest.json.
    #[arg(long)]
    run_dir: PathBuf,
    /// Emit the stable response JSON instead of compact human output.
    #[arg(long)]
    json: bool,
    /// Hard response-byte request.
    #[arg(long, default_value_t = 8192)]
    max_bytes: usize,
    #[command(subcommand)]
    command: Command,
}

#[derive(Debug, Subcommand)]
enum Command {
    Status,
    /// Poll a long search safe point for a changed active-plan epoch.
    Pulse {
        #[arg(long, default_value_t = 0)]
        since_epoch: u64,
    },
    /// Fetch one lowered active plan from an unchanged epoch.
    PlanGet {
        plan: String,
        #[arg(long)]
        expect_epoch: u64,
    },
    /// Exact best possible classification using the current feature vectors.
    Ceiling,
    /// Learn a bounded exact decision-tree attack and write its replayable plan.
    Synthesize {
        #[arg(long)]
        output: PathBuf,
        #[arg(long, default_value_t = 31)]
        max_nodes: u64,
        #[arg(long, default_value_t = 8)]
        max_depth: u64,
        #[arg(long, requires = "train_value")]
        train_field: Option<String>,
        #[arg(long, requires = "train_field", allow_hyphen_values = true)]
        train_value: Option<i64>,
    },
    /// One bounded delta digest suitable for an agent decision.
    AgentBrief {
        #[arg(long, default_value_t = 0)]
        since: u64,
        #[arg(long, default_value_t = 8)]
        top: u64,
    },
    /// Evaluate a candidate theorem shape without activating it.
    Try {
        plan: PathBuf,
        #[arg(long)]
        group_by: Option<String>,
    },
    /// Stream a JSONL population through the evaluator and write JSONL results.
    Batch {
        plans: PathBuf,
        #[arg(long)]
        output: PathBuf,
        #[arg(long, default_value_t = 10_000)]
        max_plans: usize,
    },
    /// Mutate seed predicates, run a bounded beam search, and stream all trials.
    Evolve {
        seeds: PathBuf,
        #[arg(long)]
        output: PathBuf,
        #[arg(long, default_value_t = 3)]
        generations: usize,
        #[arg(long, default_value_t = 16)]
        beam: usize,
        #[arg(long, default_value_t = 1000)]
        max_candidates: usize,
    },
    /// Evaluate and atomically activate a diagnostic/ordering plan.
    Apply {
        plan: PathBuf,
        #[arg(long)]
        expect_epoch: u64,
    },
    /// Atomically remove one diagnostic/ordering plan.
    Deactivate {
        plan: String,
        #[arg(long)]
        expect_epoch: u64,
    },
    /// Return only a stored plan's first mismatch or false row.
    Obstruction {
        plan: String,
    },
    /// Rank and return at most 32 exceptional feature rows by a plan's value.
    Exceptional {
        plan: String,
        #[arg(long, default_value_t = 8)]
        top: u64,
        #[arg(long, default_value = "high")]
        direction: String,
    },
    /// Write one bounded localized evaluator trace under the run directory.
    Trace {
        plan: String,
        #[arg(long)]
        row: u64,
        #[arg(long, default_value_t = 128)]
        max_records: u64,
    },
    /// Append a short high-level research annotation.
    Note {
        text: String,
    },
    Shutdown,
}

fn read_plan(path: &PathBuf) -> Result<PlanSpec> {
    let document: PlanDocument = serde_json::from_reader(BufReader::new(
        File::open(path).with_context(|| format!("cannot open plan {}", path.display()))?,
    ))
    .with_context(|| format!("invalid plan {}", path.display()))?;
    document
        .lower()
        .with_context(|| format!("cannot lower plan {}", path.display()))
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    let manifest = read_manifest(&cli.run_dir).context("cannot read campaign manifest")?;
    if let Command::Batch {
        plans,
        output,
        max_plans,
    } = &cli.command
    {
        return run_batch(&manifest, plans, output, *max_plans, cli.max_bytes);
    }
    if let Command::Evolve {
        seeds,
        output,
        generations,
        beam,
        max_candidates,
    } = &cli.command
    {
        return run_evolve(
            &manifest,
            seeds,
            output,
            *generations,
            *beam,
            *max_candidates,
            cli.max_bytes,
        );
    }
    if let Command::Synthesize {
        output,
        max_nodes,
        max_depth,
        train_field,
        train_value,
    } = &cli.command
    {
        return run_synthesize(
            &manifest,
            output,
            *max_nodes,
            *max_depth,
            train_field.as_deref(),
            *train_value,
            cli.max_bytes,
        );
    }
    let (op, args) = match cli.command {
        Command::Status => ("status", json!({})),
        Command::Pulse { since_epoch } => ("pulse", json!({"since_epoch": since_epoch})),
        Command::PlanGet { plan, expect_epoch } => (
            "plan-get",
            json!({"plan": plan, "expect_epoch": expect_epoch}),
        ),
        Command::Ceiling => ("feature-ceiling", json!({})),
        Command::Synthesize { .. } => unreachable!(),
        Command::AgentBrief { since, top } => ("agent-brief", json!({"since": since, "top": top})),
        Command::Try { plan, group_by } => (
            "candidate-try",
            json!({"plan": read_plan(&plan)?, "group_by": group_by}),
        ),
        Command::Batch { .. } => unreachable!(),
        Command::Evolve { .. } => unreachable!(),
        Command::Apply { plan, expect_epoch } => (
            "candidate-apply",
            json!({"plan": read_plan(&plan)?, "expect_epoch": expect_epoch}),
        ),
        Command::Deactivate { plan, expect_epoch } => (
            "candidate-deactivate",
            json!({"plan": plan, "expect_epoch": expect_epoch}),
        ),
        Command::Obstruction { plan } => ("obstruction-first", json!({"plan": plan})),
        Command::Exceptional {
            plan,
            top,
            direction,
        } => (
            "exceptional",
            json!({"plan": plan, "top": top, "direction": direction}),
        ),
        Command::Trace {
            plan,
            row,
            max_records,
        } => (
            "trace",
            json!({"plan": plan, "row": row, "max_records": max_records}),
        ),
        Command::Note { text } => ("note", json!({"text": text})),
        Command::Shutdown => ("shutdown", json!({})),
    };
    let response =
        send_request(&manifest, op, args, cli.max_bytes).context("campaign request failed")?;
    if cli.json {
        println!("{}", serde_json::to_string(&response)?);
    } else if response.ok {
        render_compact(op, &response.result, response.epoch)?;
    } else {
        bail!(
            "{}",
            response
                .result
                .get("error")
                .and_then(Value::as_str)
                .unwrap_or("campaign rejected request")
        );
    }
    Ok(())
}

fn run_synthesize(
    manifest: &ergodis::control::Manifest,
    output: &PathBuf,
    max_nodes: u64,
    max_depth: u64,
    train_field: Option<&str>,
    train_value: Option<i64>,
    max_bytes: usize,
) -> Result<()> {
    let response = send_request(
        manifest,
        "synthesize-tree",
        json!({"max_nodes": max_nodes, "max_depth": max_depth, "train_field": train_field, "train_value": train_value}),
        max_bytes,
    )?;
    if !response.ok {
        bail!("tree synthesis rejected: {}", response.result);
    }
    let mut file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .open(output)
        .with_context(|| format!("cannot create {}", output.display()))?;
    serde_json::to_writer_pretty(&mut file, &response.result["plan"])?;
    file.write_all(b"\n")?;
    let evaluation = &response.result["evaluation"];
    println!(
        "nodes={} depth={} train={} correct={}/{} plan={}",
        number(&response.result, "nodes"),
        number(&response.result, "depth"),
        number(&response.result, "training_rows"),
        number(evaluation, "weighted_correct"),
        number(evaluation, "weighted_rows"),
        output.display()
    );
    Ok(())
}

fn read_plan_jsonl(path: &PathBuf, limit: usize) -> Result<Vec<PlanSpec>> {
    let input = BufReader::new(
        File::open(path).with_context(|| format!("cannot open {}", path.display()))?,
    );
    let mut plans = Vec::new();
    for (line_number, line) in input.lines().enumerate() {
        let line = line?;
        if line.trim().is_empty() {
            continue;
        }
        if plans.len() == limit {
            bail!("seed population exceeds limit {limit}");
        }
        let document: PlanDocument = serde_json::from_str(&line)
            .with_context(|| format!("invalid plan at line {}", line_number + 1))?;
        plans.push(
            document
                .lower()
                .with_context(|| format!("cannot lower plan at line {}", line_number + 1))?,
        );
    }
    if plans.is_empty() {
        bail!("seed population is empty");
    }
    Ok(plans)
}

#[allow(clippy::too_many_arguments)]
fn run_evolve(
    manifest: &ergodis::control::Manifest,
    seeds: &PathBuf,
    output: &PathBuf,
    generations: usize,
    beam: usize,
    max_candidates: usize,
    max_bytes: usize,
) -> Result<()> {
    if generations == 0 || generations > 32 || beam == 0 || beam > 256 {
        bail!("evolve requires 1..=32 generations and 1..=256 beam width");
    }
    if max_candidates == 0 || max_candidates > 100_000 {
        bail!("evolve requires 1..=100000 candidates");
    }
    let status = send_request(manifest, "status", json!({}), max_bytes)?;
    if !status.ok {
        bail!("campaign status rejected: {}", status.result);
    }
    let fields: Vec<String> = status.result["fields"]
        .as_array()
        .ok_or_else(|| anyhow::anyhow!("status omitted feature fields"))?
        .iter()
        .map(|value| {
            value
                .as_str()
                .map(str::to_owned)
                .ok_or_else(|| anyhow::anyhow!("invalid feature field"))
        })
        .collect::<Result<_>>()?;
    let mut current = read_plan_jsonl(seeds, beam)?;
    if current
        .iter()
        .any(|plan| plan.output != PlanOutput::Predicate)
    {
        bail!("evolve accepts predicate seeds only");
    }
    let output_file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .open(output)
        .with_context(|| format!("cannot create {}", output.display()))?;
    let mut writer = BufWriter::new(output_file);
    let mut structural = BTreeSet::new();
    let mut outcome_classes = BTreeSet::new();
    let mut tested = 0usize;
    let mut perfect = 0usize;
    let mut best_correct = 0u64;
    let mut best_name = String::new();

    for generation in 0..generations {
        let mut ranked = Vec::new();
        for mut plan in current.drain(..) {
            if tested == max_candidates {
                break;
            }
            let structural_key = format!("{:?}|{:?}|{:?}", plan.role, plan.output, plan.program);
            if !structural.insert(structural_key) {
                continue;
            }
            plan.name = format!("evolve-g{generation}-c{tested}");
            let response = send_request(
                manifest,
                "candidate-try",
                json!({"plan": plan.clone()}),
                max_bytes,
            )?;
            if !response.ok {
                bail!("generated candidate rejected: {}", response.result);
            }
            serde_json::to_writer(
                &mut writer,
                &json!({"generation": generation, "plan": plan, "result": response.result}),
            )?;
            writer.write_all(b"\n")?;
            tested += 1;
            let evaluation = &response.result["evaluation"];
            let correct = number(evaluation, "weighted_correct");
            let rows = number(evaluation, "weighted_rows");
            let outcome = text(evaluation, "outcome_hash").to_owned();
            outcome_classes.insert(outcome);
            if correct == rows {
                perfect += 1;
            }
            if correct > best_correct {
                best_correct = correct;
                best_name = text(&response.result, "plan").into();
            }
            ranked.push((
                correct,
                response.result["plan"].as_str().unwrap_or("").to_owned(),
                plan,
            ));
        }
        if tested == max_candidates || generation + 1 == generations {
            break;
        }
        ranked.sort_unstable_by(|left, right| {
            right.0.cmp(&left.0).then_with(|| left.1.cmp(&right.1))
        });
        for (_, _, parent) in ranked.into_iter().take(beam) {
            mutate_plan(
                &parent,
                &fields,
                &mut current,
                max_candidates.saturating_sub(tested),
            );
            if current.len() >= max_candidates.saturating_sub(tested) {
                break;
            }
        }
    }
    writer.flush()?;
    println!(
        "tested={tested} outcome_classes={} perfect={perfect} best={best_name} correct={best_correct} results={}",
        outcome_classes.len(),
        output.display()
    );
    Ok(())
}

fn mutate_plan(parent: &PlanSpec, fields: &[String], output: &mut Vec<PlanSpec>, limit: usize) {
    for (index, op) in parent.program.iter().enumerate() {
        let replacements: Vec<PlanOp> = match op {
            PlanOp::Const { value } => [-8, -2, -1, 1, 2, 8]
                .into_iter()
                .filter_map(|delta| value.checked_add(delta))
                .map(|value| PlanOp::Const { value })
                .collect(),
            PlanOp::Field { name } => fields
                .iter()
                .filter(|field| *field != name)
                .map(|name| PlanOp::Field { name: name.clone() })
                .collect(),
            PlanOp::Eq | PlanOp::Ne | PlanOp::Lt | PlanOp::Le | PlanOp::Gt | PlanOp::Ge => vec![
                PlanOp::Eq,
                PlanOp::Ne,
                PlanOp::Lt,
                PlanOp::Le,
                PlanOp::Gt,
                PlanOp::Ge,
            ],
            PlanOp::And => vec![PlanOp::Or],
            PlanOp::Or => vec![PlanOp::And],
            _ => Vec::new(),
        };
        for replacement in replacements {
            if output.len() == limit {
                return;
            }
            let mut child = parent.clone();
            child.program[index] = replacement;
            output.push(child);
        }
    }
}

fn run_batch(
    manifest: &ergodis::control::Manifest,
    plans: &PathBuf,
    output: &PathBuf,
    max_plans: usize,
    max_bytes: usize,
) -> Result<()> {
    let input = BufReader::new(
        File::open(plans).with_context(|| format!("cannot open {}", plans.display()))?,
    );
    let output_file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .open(output)
        .with_context(|| format!("cannot create {}", output.display()))?;
    let mut writer = BufWriter::new(output_file);
    let mut count = 0usize;
    let mut perfect = 0usize;
    let mut best_correct = 0u64;
    let mut best_name = String::new();
    for (line_number, line) in input.lines().enumerate() {
        if count == max_plans {
            bail!("plan population exceeds --max-plans {max_plans}");
        }
        let line = line?;
        if line.trim().is_empty() {
            continue;
        }
        let plan: PlanSpec = serde_json::from_str(&line)
            .with_context(|| format!("invalid plan at line {}", line_number + 1))?;
        let response = send_request(manifest, "candidate-try", json!({"plan": plan}), max_bytes)?;
        if !response.ok {
            bail!(
                "candidate at line {} rejected: {}",
                line_number + 1,
                response.result
            );
        }
        serde_json::to_writer(&mut writer, &response.result)?;
        writer.write_all(b"\n")?;
        count += 1;
        let evaluation = &response.result["evaluation"];
        let correct = number(evaluation, "weighted_correct");
        let rows = number(evaluation, "weighted_rows");
        if correct == rows {
            perfect += 1;
        }
        if correct > best_correct {
            best_correct = correct;
            best_name = text(&response.result, "plan").into();
        }
    }
    writer.flush()?;
    println!(
        "plans={count} perfect={perfect} best={best_name} correct={best_correct} results={}",
        output.display()
    );
    Ok(())
}

fn render_compact(op: &str, result: &Value, epoch: u64) -> Result<()> {
    match op {
        "status" => {
            println!(
                "epoch={epoch} health={} problem={} rows={} plans={} ledger={}/{}",
                text(result, "health"),
                text(result, "problem"),
                number(result, "rows"),
                number(result, "plans"),
                number(result, "ledger_bytes"),
                number(result, "ledger_limit")
            );
            if let Some(solver) = result.get("solver").filter(|value| value.is_object()) {
                println!(
                    "solver states={} dup={} infeasible={} depth={} selected={} unresolved={}",
                    number(solver, "states"),
                    number(solver, "duplicates"),
                    number(solver, "infeasible"),
                    number(solver, "depth"),
                    number(solver, "selected_count"),
                    number(solver, "unresolved_count")
                );
            }
        }
        "pulse" => println!(
            "epoch={epoch} changed={} plans={}",
            result
                .get("changed")
                .and_then(Value::as_bool)
                .unwrap_or(false),
            result
                .get("plans")
                .and_then(Value::as_array)
                .map_or(0, Vec::len)
        ),
        "candidate-deactivate" => println!(
            "epoch={epoch} deactivated={} old={} new={}",
            text(result, "plan"),
            number(result, "old_epoch"),
            number(result, "new_epoch")
        ),
        "feature-ceiling" => println!(
            "epoch={epoch} vectors={} ambiguous={} unavoidable={}/{} first={}",
            number(result, "distinct_feature_vectors"),
            number(result, "ambiguous_groups"),
            number(result, "unavoidable_weighted_errors"),
            number(result, "weighted_rows"),
            result
                .get("first_collision")
                .map_or_else(|| "none".into(), Value::to_string)
        ),
        "agent-brief" => println!(
            "epoch={epoch} changes={} omitted={} plans={} rows={} headroom={} next={}\nnext: {}",
            result
                .get("changes")
                .and_then(Value::as_array)
                .map_or(0, Vec::len),
            number(result, "omitted"),
            number(result, "plans"),
            number(result, "rows"),
            number(result, "ledger_headroom"),
            number(result, "next_cursor"),
            text(result, "recommended")
        ),
        "candidate-try" | "candidate-apply" => {
            let evaluation = &result["evaluation"];
            if text(evaluation, "output") == "score" {
                println!(
                    "epoch={epoch} plan={} score=[{},{}] rows={}",
                    text(result, "plan"),
                    signed(evaluation, "minimum_score"),
                    signed(evaluation, "maximum_score"),
                    number(evaluation, "rows")
                );
            } else {
                println!(
                    "epoch={epoch} plan={} correct={}/{} fp={} fn={} first={}",
                    text(result, "plan"),
                    number(evaluation, "weighted_correct"),
                    number(evaluation, "weighted_rows"),
                    number(evaluation, "weighted_false_positive"),
                    number(evaluation, "weighted_false_negative"),
                    result
                        .get("first_obstruction")
                        .and_then(|value| value.get("id"))
                        .map_or_else(|| "none".into(), Value::to_string)
                );
            }
            if !result["groups"].is_null() {
                println!("groups={}", serde_json::to_string(&result["groups"])?);
            }
        }
        "obstruction-first" => println!("epoch={epoch} {}", serde_json::to_string(result)?),
        "exceptional" => println!(
            "epoch={epoch} plan={} examined={} top={}",
            text(result, "plan"),
            number(result, "examined"),
            serde_json::to_string(&result["top"])?
        ),
        "trace" => println!(
            "epoch={epoch} trace={} bytes={} records={}",
            text(result, "path"),
            number(result, "bytes"),
            number(result, "records")
        ),
        "note" => println!("epoch={epoch} event={}", number(result, "event")),
        "shutdown" => println!("epoch={epoch} stopping"),
        _ => println!("{}", serde_json::to_string(result)?),
    }
    Ok(())
}

fn text<'a>(value: &'a Value, key: &str) -> &'a str {
    value.get(key).and_then(Value::as_str).unwrap_or("?")
}

fn number(value: &Value, key: &str) -> u64 {
    value.get(key).and_then(Value::as_u64).unwrap_or(0)
}

fn signed(value: &Value, key: &str) -> i64 {
    value.get(key).and_then(Value::as_i64).unwrap_or(0)
}
