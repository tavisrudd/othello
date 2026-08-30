use anyhow::{bail, Context, Result};
use clap::{Parser, Subcommand};
use ergodis::control::{read_manifest, send_request, PlanSpec};
use serde_json::{json, Value};
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
    },
    /// Stream a JSONL population through the evaluator and write JSONL results.
    Batch {
        plans: PathBuf,
        #[arg(long)]
        output: PathBuf,
        #[arg(long, default_value_t = 10_000)]
        max_plans: usize,
    },
    /// Evaluate and atomically activate a diagnostic/ordering plan.
    Apply {
        plan: PathBuf,
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
    serde_json::from_reader(BufReader::new(
        File::open(path).with_context(|| format!("cannot open plan {}", path.display()))?,
    ))
    .with_context(|| format!("invalid plan {}", path.display()))
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
    let (op, args) = match cli.command {
        Command::Status => ("status", json!({})),
        Command::AgentBrief { since, top } => ("agent-brief", json!({"since": since, "top": top})),
        Command::Try { plan } => ("candidate-try", json!({"plan": read_plan(&plan)?})),
        Command::Batch { .. } => unreachable!(),
        Command::Apply { plan, expect_epoch } => (
            "candidate-apply",
            json!({"plan": read_plan(&plan)?, "expect_epoch": expect_epoch}),
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
        "status" => println!(
            "epoch={epoch} health={} problem={} rows={} plans={} ledger={}/{}",
            text(result, "health"),
            text(result, "problem"),
            number(result, "rows"),
            number(result, "plans"),
            number(result, "ledger_bytes"),
            number(result, "ledger_limit")
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
