use anyhow::{bail, Context, Result};
use clap::{Parser, Subcommand, ValueEnum};
use ergodis::control::{
    evaluate_plan, parse_and_lower_plan, read_manifest, send_request, synthesize_decision_tree,
    CompiledPlan, FeatureBatch, PlanDocument, PlanOp, PlanOutput, PlanRole, PlanScope, PlanSpec,
    MAX_PLAN_TEXT_BYTES,
};
use serde_json::{json, Value};
use std::collections::BTreeSet;
use std::fs::{File, OpenOptions};
use std::io::{BufRead, BufReader, BufWriter, Read, Write};
use std::os::unix::fs::OpenOptionsExt;
use std::path::{Component, PathBuf};
use std::thread;
use std::time::{Duration, Instant};

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

#[derive(Clone, Copy, Debug, ValueEnum)]
enum CliProposalRole {
    Ordering,
    Heuristic,
    NecessaryReduction,
    ExactTransport,
}

impl CliProposalRole {
    fn protocol_name(self) -> &'static str {
        match self {
            Self::Ordering => "ordering",
            Self::Heuristic => "heuristic",
            Self::NecessaryReduction => "necessary-reduction",
            Self::ExactTransport => "exact-transport",
        }
    }

    fn mask(self) -> u8 {
        1 << self as u8
    }
}

#[derive(Clone, Copy, Debug, ValueEnum)]
enum CliProposalFailure {
    Malformed,
    ForbiddenRole,
    SemanticRejection,
    StaleSnapshot,
    BudgetLimit,
    DeterministicBackend,
    TransientTransport,
    ProviderRateLimit,
    QueueTimeout,
    ExecutionTimeout,
    BackendCrash,
    ProtocolFault,
}

impl CliProposalFailure {
    fn protocol_name(self) -> &'static str {
        match self {
            Self::Malformed => "malformed",
            Self::ForbiddenRole => "forbidden-role",
            Self::SemanticRejection => "semantic-rejection",
            Self::StaleSnapshot => "stale-snapshot",
            Self::BudgetLimit => "budget-limit",
            Self::DeterministicBackend => "deterministic-backend",
            Self::TransientTransport => "transient-transport",
            Self::ProviderRateLimit => "provider-rate-limit",
            Self::QueueTimeout => "queue-timeout",
            Self::ExecutionTimeout => "execution-timeout",
            Self::BackendCrash => "backend-crash",
            Self::ProtocolFault => "protocol-fault",
        }
    }
}

#[derive(Debug, Subcommand)]
enum Command {
    /// Report the negotiated protocol surface and hard limits.
    Capabilities,
    Status,
    /// Exercise the control socket without changing or notifying search state.
    Noop,
    /// Run an autonomous active/off ordering-plan probation from progress JSONL.
    Probation {
        plan: String,
        #[arg(long)]
        progress: PathBuf,
        #[arg(long)]
        expect_epoch: u64,
        #[arg(long, default_value_t = 5)]
        samples: usize,
        #[arg(long, default_value_t = 15)]
        slowdown_percent: u64,
        #[arg(long, default_value_t = 120)]
        timeout_seconds: u64,
    },
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
    /// Compile permutation-invariant parent rows for a follow-on campaign.
    GroupCompile {
        group_by: String,
        #[arg(long, default_value_t = true)]
        count: bool,
        #[arg(long)]
        sum: Vec<String>,
        #[arg(long)]
        minimum: Vec<String>,
        #[arg(long)]
        maximum: Vec<String>,
        #[arg(long)]
        evidence_name: String,
        #[arg(long, default_value_t = 1_000_000)]
        max_groups: u64,
        #[arg(long, default_value_t = 200_000_000)]
        max_output_cells: u64,
    },
    /// Compile aggregate parent rows and immediately synthesize an exact tree.
    GroupSynthesize {
        group_by: String,
        #[arg(long, default_value_t = true)]
        count: bool,
        #[arg(long)]
        sum: Vec<String>,
        #[arg(long)]
        minimum: Vec<String>,
        #[arg(long)]
        maximum: Vec<String>,
        #[arg(long)]
        evidence_name: String,
        #[arg(long)]
        output: PathBuf,
        #[arg(long, default_value_t = 1_000_000)]
        max_groups: u64,
        #[arg(long, default_value_t = 200_000_000)]
        max_output_cells: u64,
        #[arg(long, default_value_t = 31)]
        max_nodes: usize,
        #[arg(long, default_value_t = 8)]
        max_depth: usize,
        #[arg(long, requires = "train_value")]
        train_field: Option<String>,
        #[arg(long, requires = "train_field", allow_hyphen_values = true)]
        train_value: Option<i64>,
    },
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
    /// Start daemon-owned low-priority evolution with streamed evidence.
    EvolveStart {
        /// Optional JSONL seed population. May be omitted when replaying evidence.
        seeds: Option<PathBuf>,
        /// Compatible prior evolution archives to rank and re-evaluate as seeds.
        #[arg(long = "resume-evidence")]
        resume_evidence: Vec<PathBuf>,
        #[arg(long)]
        evidence_name: String,
        #[arg(long, default_value_t = 3)]
        generations: usize,
        #[arg(long, default_value_t = 16)]
        beam: usize,
        #[arg(long, default_value_t = 1000)]
        max_candidates: usize,
        /// Features whose first-mismatch tuple defines an additional semantic niche.
        #[arg(long = "target-field")]
        target_fields: Vec<String>,
        /// Bounded operational target graph used only for expansion priority.
        #[arg(long)]
        target_profile: Option<PathBuf>,
        /// Snapshot the campaign-local watcher profile instead of reading a file.
        #[arg(long, conflicts_with = "target_profile")]
        target_profile_current: bool,
        #[arg(long)]
        max_evidence_bytes: Option<u64>,
    },
    /// Reset the campaign-local operational target profile.
    TargetProfileReset {
        #[arg(long = "field", required = true)]
        fields: Vec<String>,
    },
    /// Set one absolute mass/cost observation in the current target profile.
    TargetProfileObserve {
        #[arg(long = "value", required = true, allow_hyphen_values = true)]
        values: Vec<i64>,
        #[arg(long)]
        mass: u64,
        #[arg(long)]
        unit_cost: u64,
        /// Preferred finite mutation ordering for this target tuple.
        #[arg(long, default_value = "balanced")]
        strategy: String,
    },
    /// Add one dependency or continuation edge between existing target tuples.
    TargetProfileEdge {
        #[arg(long, value_delimiter = ',', allow_hyphen_values = true)]
        from: Vec<i64>,
        #[arg(long, value_delimiter = ',', allow_hyphen_values = true)]
        to: Vec<i64>,
        #[arg(long)]
        kind: String,
    },
    /// Inspect the campaign-local operational target profile.
    TargetProfileStatus,
    /// Queue the current target profile for the next evolution generation.
    EvolveProfileRefresh,
    /// Query the active or most recently completed daemon evolution job.
    EvolveStatus,
    /// Request cancellation of the active daemon evolution job.
    EvolveCancel,
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
    /// Open one bounded external-proposer session.
    ProposalSessionOpen {
        #[arg(long, value_enum, required = true)]
        role: Vec<CliProposalRole>,
        #[arg(long, default_value_t = 15 * 60 * 1_000)]
        ttl_ms: u64,
        #[arg(long, default_value_t = 16)]
        maximum_queries: u32,
        #[arg(long, default_value_t = 4)]
        maximum_outstanding: u16,
        #[arg(long, default_value_t = 8)]
        maximum_revisions: u16,
        #[arg(long, default_value_t = 1_000_000)]
        maximum_work_units: u64,
        #[arg(long, default_value_t = 64 * 1024)]
        maximum_return_bytes: u64,
    },
    /// Submit one idempotent bounded query/proposal job.
    ProposalSubmit {
        #[arg(long)]
        session: String,
        #[arg(long)]
        request_id: u64,
        #[arg(long)]
        payload_blake3: String,
        #[arg(long)]
        proposer_id: u16,
        #[arg(long, value_enum)]
        role: CliProposalRole,
        #[arg(long)]
        cost_units: u64,
        #[arg(long)]
        maximum_return_bytes: u64,
        #[arg(long, default_value_t = 30_000)]
        queue_timeout_ms: u64,
        #[arg(long, default_value_t = 5 * 60 * 1_000)]
        execution_timeout_ms: u64,
        #[arg(long, default_value_t = 10 * 60 * 1_000)]
        admission_timeout_ms: u64,
        #[arg(long, default_value_t = 15 * 60 * 1_000)]
        retention_timeout_ms: u64,
    },
    /// Inspect one proposal ticket and session usage.
    ProposalStatus {
        #[arg(long)]
        session: String,
        #[arg(long)]
        ticket: String,
    },
    /// Claim one queued proposal ticket as a provider worker.
    ProposalWorkerClaim {
        #[arg(long)]
        session: String,
        #[arg(long)]
        ticket: String,
    },
    /// Report one typed provider failure and receive retry policy.
    ProposalWorkerFailure {
        #[arg(long)]
        session: String,
        #[arg(long)]
        ticket: String,
        #[arg(long)]
        attempt: u8,
        #[arg(long, value_enum)]
        failure: CliProposalFailure,
        #[arg(long)]
        provider_retry_after_ms: Option<u64>,
    },
    /// Publish compact result metadata for a claimed ticket.
    ProposalWorkerComplete {
        #[arg(long)]
        session: String,
        #[arg(long)]
        ticket: String,
        #[arg(long)]
        attempt: u8,
    },
    /// Cancel one proposal ticket idempotently.
    ProposalCancel {
        #[arg(long)]
        session: String,
        #[arg(long)]
        ticket: String,
    },
    /// Fetch ready result metadata subject to retention expiry.
    ProposalResult {
        #[arg(long)]
        session: String,
        #[arg(long)]
        ticket: String,
    },
    /// Charge one distinct proposal revision against session quota.
    ProposalRevisionReserve {
        #[arg(long)]
        session: String,
        #[arg(long)]
        payload_blake3: String,
        #[arg(long, value_enum)]
        role: CliProposalRole,
    },
    Shutdown,
}

fn read_plan(path: &PathBuf) -> Result<PlanSpec> {
    let file = File::open(path).with_context(|| format!("cannot open plan {}", path.display()))?;
    let mut text = String::new();
    file.take((MAX_PLAN_TEXT_BYTES + 1) as u64)
        .read_to_string(&mut text)
        .with_context(|| format!("cannot read plan {}", path.display()))?;
    if text.len() > MAX_PLAN_TEXT_BYTES {
        bail!("plan {} exceeds byte limit", path.display());
    }
    if text.trim_start().starts_with('{') {
        let document: PlanDocument = serde_json::from_str(&text)
            .with_context(|| format!("invalid JSON plan {}", path.display()))?;
        document
            .lower()
            .with_context(|| format!("cannot lower plan {}", path.display()))
    } else {
        parse_and_lower_plan(&text)
            .with_context(|| format!("invalid textual plan {}", path.display()))
    }
}

fn read_json_value(path: &PathBuf) -> Result<Value> {
    let file = File::open(path).with_context(|| format!("cannot open {}", path.display()))?;
    let mut text = String::new();
    file.take((MAX_PLAN_TEXT_BYTES + 1) as u64)
        .read_to_string(&mut text)
        .with_context(|| format!("cannot read {}", path.display()))?;
    if text.len() > MAX_PLAN_TEXT_BYTES {
        bail!("{} exceeds byte limit", path.display());
    }
    serde_json::from_str(&text).with_context(|| format!("invalid JSON in {}", path.display()))
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
    if let Command::EvolveStart {
        seeds,
        resume_evidence,
        evidence_name,
        generations,
        beam,
        max_candidates,
        target_fields,
        target_profile,
        target_profile_current,
        max_evidence_bytes,
    } = &cli.command
    {
        let seeds = seeds
            .as_ref()
            .map(|path| read_plan_jsonl(path, 32))
            .transpose()?
            .unwrap_or_default();
        let target_profile = if *target_profile_current {
            Some(Value::String("current".into()))
        } else {
            target_profile.as_ref().map(read_json_value).transpose()?
        };
        let response = send_request(
            &manifest,
            "evolve-start",
            json!({
                "seeds": seeds,
                "resume_evidence": resume_evidence,
                "evidence_name": evidence_name,
                "generations": generations,
                "beam": beam,
                "max_candidates": max_candidates,
                "target_fields": target_fields,
                "target_profile": target_profile,
                "max_evidence_bytes": max_evidence_bytes,
            }),
            cli.max_bytes,
        )?;
        if !response.ok {
            bail!("daemon evolution rejected: {}", response.result);
        }
        if cli.json {
            println!("{}", serde_json::to_string(&response)?);
        } else {
            render_compact("evolve-start", &response.result, response.epoch)?;
        }
        return Ok(());
    }
    if let Command::Probation {
        plan,
        progress,
        expect_epoch,
        samples,
        slowdown_percent,
        timeout_seconds,
    } = &cli.command
    {
        return run_probation(
            &manifest,
            plan,
            progress,
            *expect_epoch,
            *samples,
            *slowdown_percent,
            *timeout_seconds,
            cli.max_bytes,
            cli.json,
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
    if let Command::GroupSynthesize {
        group_by,
        count,
        sum,
        minimum,
        maximum,
        evidence_name,
        output,
        max_groups,
        max_output_cells,
        max_nodes,
        max_depth,
        train_field,
        train_value,
    } = &cli.command
    {
        return run_group_synthesize(
            &manifest,
            group_by,
            *count,
            sum,
            minimum,
            maximum,
            evidence_name,
            output,
            *max_groups,
            *max_output_cells,
            *max_nodes,
            *max_depth,
            train_field.as_deref(),
            *train_value,
            cli.max_bytes,
        );
    }
    let (op, args) = match cli.command {
        Command::Capabilities => ("capabilities", json!({})),
        Command::Status => ("status", json!({})),
        Command::Noop => ("noop", json!({})),
        Command::Probation { .. } => unreachable!(),
        Command::Pulse { since_epoch } => ("pulse", json!({"since_epoch": since_epoch})),
        Command::PlanGet { plan, expect_epoch } => (
            "plan-get",
            json!({"plan": plan, "expect_epoch": expect_epoch}),
        ),
        Command::Ceiling => ("feature-ceiling", json!({})),
        Command::GroupCompile {
            group_by,
            count,
            sum,
            minimum,
            maximum,
            evidence_name,
            max_groups,
            max_output_cells,
        } => (
            "group-compile",
            json!({
                "group_by": group_by,
                "count": count,
                "sum": sum,
                "minimum": minimum,
                "maximum": maximum,
                "evidence_name": evidence_name,
                "max_groups": max_groups,
                "max_output_cells": max_output_cells,
            }),
        ),
        Command::GroupSynthesize { .. } => unreachable!(),
        Command::Synthesize { .. } => unreachable!(),
        Command::AgentBrief { since, top } => ("agent-brief", json!({"since": since, "top": top})),
        Command::Try { plan, group_by } => (
            "candidate-try",
            json!({"plan": read_plan(&plan)?, "group_by": group_by}),
        ),
        Command::Batch { .. } => unreachable!(),
        Command::Evolve { .. } => unreachable!(),
        Command::EvolveStart { .. } => unreachable!(),
        Command::TargetProfileReset { fields } => {
            ("target-profile-reset", json!({"fields": fields}))
        }
        Command::TargetProfileObserve {
            values,
            mass,
            unit_cost,
            strategy,
        } => (
            "target-profile-observe",
            json!({
                "values": values,
                "mass": mass,
                "unit_cost": unit_cost,
                "strategy": strategy,
            }),
        ),
        Command::TargetProfileEdge { from, to, kind } => (
            "target-profile-edge",
            json!({"from": from, "to": to, "kind": kind}),
        ),
        Command::TargetProfileStatus => ("target-profile-status", json!({})),
        Command::EvolveProfileRefresh => ("evolve-profile-refresh", json!({})),
        Command::EvolveStatus => ("evolve-status", json!({})),
        Command::EvolveCancel => ("evolve-cancel", json!({})),
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
        Command::ProposalSessionOpen {
            role,
            ttl_ms,
            maximum_queries,
            maximum_outstanding,
            maximum_revisions,
            maximum_work_units,
            maximum_return_bytes,
        } => (
            "proposal-session-open",
            json!({
                "allowed_roles": role.into_iter().fold(0_u8, |mask, role| mask | role.mask()),
                "ttl_ms": ttl_ms,
                "maximum_queries": maximum_queries,
                "maximum_outstanding": maximum_outstanding,
                "maximum_revisions": maximum_revisions,
                "maximum_work_units": maximum_work_units,
                "maximum_return_bytes": maximum_return_bytes,
            }),
        ),
        Command::ProposalSubmit {
            session,
            request_id,
            payload_blake3,
            proposer_id,
            role,
            cost_units,
            maximum_return_bytes,
            queue_timeout_ms,
            execution_timeout_ms,
            admission_timeout_ms,
            retention_timeout_ms,
        } => (
            "proposal-submit",
            json!({
                "session_id": session,
                "request_id": request_id,
                "canonical_payload_blake3": payload_blake3,
                "proposer_id": proposer_id,
                "role": role.protocol_name(),
                "cost_units": cost_units,
                "maximum_return_bytes": maximum_return_bytes,
                "queue_timeout_ms": queue_timeout_ms,
                "execution_timeout_ms": execution_timeout_ms,
                "admission_timeout_ms": admission_timeout_ms,
                "retention_timeout_ms": retention_timeout_ms,
            }),
        ),
        Command::ProposalStatus { session, ticket } => (
            "proposal-status",
            json!({"session_id": session, "ticket_key": ticket}),
        ),
        Command::ProposalWorkerClaim { session, ticket } => (
            "proposal-worker-claim",
            json!({"session_id": session, "ticket_key": ticket}),
        ),
        Command::ProposalWorkerFailure {
            session,
            ticket,
            attempt,
            failure,
            provider_retry_after_ms,
        } => (
            "proposal-worker-failure",
            json!({
                "session_id": session,
                "ticket_key": ticket,
                "attempt": attempt,
                "failure": failure.protocol_name(),
                "provider_retry_after_ms": provider_retry_after_ms,
            }),
        ),
        Command::ProposalWorkerComplete {
            session,
            ticket,
            attempt,
        } => (
            "proposal-worker-complete",
            json!({
                "session_id": session,
                "ticket_key": ticket,
                "attempt": attempt,
            }),
        ),
        Command::ProposalCancel { session, ticket } => (
            "proposal-cancel",
            json!({"session_id": session, "ticket_key": ticket}),
        ),
        Command::ProposalResult { session, ticket } => (
            "proposal-result",
            json!({"session_id": session, "ticket_key": ticket}),
        ),
        Command::ProposalRevisionReserve {
            session,
            payload_blake3,
            role,
        } => (
            "proposal-revision-reserve",
            json!({
                "session_id": session,
                "canonical_payload_blake3": payload_blake3,
                "role": role.protocol_name(),
            }),
        ),
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

#[derive(Clone, Copy, Debug, serde::Deserialize)]
struct ProgressSolver {
    states: u64,
    root_done: u64,
    #[serde(default)]
    root_candidate: u64,
    #[serde(default)]
    root_initial_unresolved: u64,
    #[serde(default)]
    root_initial_packing: u64,
    #[serde(default)]
    root_initial_branches: u64,
}

#[derive(Clone, Copy, Debug, serde::Deserialize)]
struct ProgressRecord {
    elapsed_ms: u64,
    applied_epoch: u64,
    solver: ProgressSolver,
}

#[allow(clippy::too_many_arguments)]
fn run_probation(
    manifest: &ergodis::control::Manifest,
    plan_name: &str,
    progress_path: &PathBuf,
    expect_epoch: u64,
    samples: usize,
    slowdown_percent: u64,
    timeout_seconds: u64,
    max_bytes: usize,
    emit_json: bool,
) -> Result<()> {
    if !(2..=60).contains(&samples) || slowdown_percent > 1000 || timeout_seconds == 0 {
        bail!("probation requires 2..=60 samples, slowdown <=1000%, and a positive timeout");
    }
    let fetched = send_request(
        manifest,
        "plan-get",
        json!({"plan": plan_name, "expect_epoch": expect_epoch}),
        max_bytes,
    )?;
    if !fetched.ok {
        bail!("probation cannot fetch active plan: {}", fetched.result);
    }
    let plan: PlanSpec = serde_json::from_value(fetched.result["plan"].clone())?;
    if plan.role != PlanRole::Ordering {
        bail!("probation accepts ordering plans only");
    }

    let file = File::open(progress_path)
        .with_context(|| format!("cannot open progress file {}", progress_path.display()))?;
    let mut reader = BufReader::new(file);
    let mut fragment = String::new();
    let deadline = Instant::now() + Duration::from_secs(timeout_seconds);
    let active =
        collect_progress_window(&mut reader, &mut fragment, expect_epoch, samples, deadline)?;

    let deactivated = send_request(
        manifest,
        "candidate-deactivate",
        json!({"plan": plan_name, "expect_epoch": expect_epoch}),
        max_bytes,
    )?;
    if !deactivated.ok {
        bail!("probation cannot deactivate plan: {}", deactivated.result);
    }
    let inactive_epoch = deactivated.epoch;
    let inactive = collect_progress_window(
        &mut reader,
        &mut fragment,
        inactive_epoch,
        samples,
        deadline,
    )?;

    let active_state_rate = progress_rate(&active, |sample| sample.solver.states)?;
    let inactive_state_rate = progress_rate(&inactive, |sample| sample.solver.states)?;
    let active_root_rate = progress_rate(&active, |sample| sample.solver.root_done)?;
    let inactive_root_rate = progress_rate(&inactive, |sample| sample.solver.root_done)?;
    let same_stratum = matches!(
        (progress_stratum(&active), progress_stratum(&inactive)),
        (Some(active), Some(inactive)) if active == inactive
    );
    let (metric, active_rate, inactive_rate, comparable) = if same_stratum {
        (
            "same_root_states_per_second",
            active_state_rate,
            inactive_state_rate,
            true,
        )
    } else if active_root_rate > 0.0 && inactive_root_rate > 0.0 {
        (
            "completed_roots_per_second",
            active_root_rate,
            inactive_root_rate,
            true,
        )
    } else {
        ("incomparable_root_windows", 0.0, 0.0, false)
    };
    let rollback = comparable
        && inactive_rate * 100.0 > active_rate * (100_u64.saturating_add(slowdown_percent) as f64);
    let final_epoch = if rollback {
        inactive_epoch
    } else {
        let restored = send_request(
            manifest,
            "candidate-apply",
            json!({"plan": plan, "expect_epoch": inactive_epoch}),
            max_bytes,
        )?;
        if !restored.ok {
            bail!("probation cannot restore plan: {}", restored.result);
        }
        restored.epoch
    };
    let ratio = (comparable && active_rate > 0.0).then(|| inactive_rate / active_rate);
    let result = json!({
        "plan": plan_name,
        "decision": if rollback { "rollback" } else { "retain" },
        "metric": metric,
        "active_rate": active_rate,
        "inactive_rate": inactive_rate,
        "ratio": ratio,
        "comparable": comparable,
        "threshold_percent": slowdown_percent,
        "final_epoch": final_epoch,
    });
    if emit_json {
        println!("{}", serde_json::to_string(&result)?);
    } else {
        println!(
            "decision={} plan={} metric={} active={:.3} inactive={:.3} ratio={} epoch={}",
            text(&result, "decision"),
            plan_name,
            metric,
            active_rate,
            inactive_rate,
            ratio.map_or_else(|| "n/a".to_owned(), |value| format!("{value:.3}x")),
            final_epoch,
        );
    }
    Ok(())
}

fn progress_stratum(samples: &[ProgressRecord]) -> Option<(u64, u64, u64, u64)> {
    let first = samples.first()?.solver;
    let stratum = (
        first.root_candidate,
        first.root_initial_unresolved,
        first.root_initial_packing,
        first.root_initial_branches,
    );
    samples
        .iter()
        .all(|sample| {
            let solver = sample.solver;
            (
                solver.root_candidate,
                solver.root_initial_unresolved,
                solver.root_initial_packing,
                solver.root_initial_branches,
            ) == stratum
        })
        .then_some(stratum)
}

fn collect_progress_window<R: BufRead>(
    reader: &mut R,
    fragment: &mut String,
    epoch: u64,
    samples: usize,
    deadline: Instant,
) -> Result<Vec<ProgressRecord>> {
    let mut window = Vec::with_capacity(samples);
    while window.len() < samples {
        if Instant::now() >= deadline {
            bail!("probation timed out waiting for epoch {epoch} progress");
        }
        let mut chunk = String::new();
        if reader.read_line(&mut chunk)? == 0 {
            thread::sleep(Duration::from_millis(50));
            continue;
        }
        fragment.push_str(&chunk);
        if !fragment.ends_with('\n') {
            continue;
        }
        let record: ProgressRecord = serde_json::from_str(fragment.trim_end())?;
        fragment.clear();
        if record.applied_epoch == epoch {
            window.push(record);
        }
    }
    Ok(window)
}

fn progress_rate(samples: &[ProgressRecord], value: impl Fn(ProgressRecord) -> u64) -> Result<f64> {
    let first = samples.first().copied().context("empty progress window")?;
    let last = samples.last().copied().context("empty progress window")?;
    let elapsed_ms = last.elapsed_ms.saturating_sub(first.elapsed_ms);
    if elapsed_ms == 0 {
        bail!("progress window has zero duration");
    }
    Ok(value(last).saturating_sub(value(first)) as f64 * 1000.0 / elapsed_ms as f64)
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

#[allow(clippy::too_many_arguments)]
fn run_group_synthesize(
    manifest: &ergodis::control::Manifest,
    group_by: &str,
    count: bool,
    sum: &[String],
    minimum: &[String],
    maximum: &[String],
    evidence_name: &str,
    output: &PathBuf,
    max_groups: u64,
    max_output_cells: u64,
    max_nodes: usize,
    max_depth: usize,
    train_field: Option<&str>,
    train_value: Option<i64>,
    max_bytes: usize,
) -> Result<()> {
    if output.try_exists()? {
        bail!("refusing to overwrite {}", output.display());
    }
    if !(1..=41).contains(&max_nodes) || !(1..=16).contains(&max_depth) {
        bail!("tree synthesis bounds are outside the public limits");
    }
    if train_field.is_some() != train_value.is_some() {
        bail!("train_field and train_value must be supplied together");
    }
    let max_groups = max_groups.clamp(1, 1_000_000);
    let max_output_cells = max_output_cells.clamp(1, 200_000_000);
    let response = send_request(
        manifest,
        "group-compile",
        json!({
            "group_by": group_by,
            "count": count,
            "sum": sum,
            "minimum": minimum,
            "maximum": maximum,
            "evidence_name": evidence_name,
            "max_groups": max_groups,
            "max_output_cells": max_output_cells,
        }),
        max_bytes,
    )?;
    if !response.ok {
        bail!("group compilation rejected: {}", response.result);
    }
    let relative = PathBuf::from(text(&response.result, "path"));
    if relative.as_os_str().is_empty()
        || relative
            .components()
            .any(|component| !matches!(component, Component::Normal(_)))
    {
        bail!("group compilation returned an unsafe evidence path");
    }
    let grouped_path = manifest.run_dir.join(&relative);
    let grouped = FeatureBatch::read_jsonl(
        &grouped_path,
        max_groups as usize,
        max_output_cells as usize,
    )
    .with_context(|| format!("cannot replay grouped data {}", grouped_path.display()))?;
    let training_stratum = match (train_field, train_value) {
        (None, None) => None,
        (Some(field), Some(value)) => Some((field, value)),
        _ => bail!("train_field and train_value must be supplied together"),
    };
    let synthesis = synthesize_decision_tree(&grouped, max_nodes, max_depth, training_stratum)?;
    let compiled = CompiledPlan::compile(&synthesis.plan, &grouped.fields)?;
    let evaluation = evaluate_plan(&grouped, &compiled)?;
    let mut file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .open(output)
        .with_context(|| format!("cannot create {}", output.display()))?;
    serde_json::to_writer_pretty(&mut file, &synthesis.plan)?;
    file.write_all(b"\n")?;
    println!(
        "groups={} nodes={} depth={} train={} correct={}/{} data={} plan={}",
        grouped.rows(),
        synthesis.nodes,
        synthesis.depth,
        synthesis.training_rows,
        evaluation.weighted_correct,
        evaluation.weighted_rows,
        relative.display(),
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
        plans.push(parse_plan_json_line(&line, line_number + 1)?);
    }
    if plans.is_empty() {
        bail!("seed population is empty");
    }
    Ok(plans)
}

fn parse_plan_json_line(line: &str, line_number: usize) -> Result<PlanSpec> {
    let document: PlanDocument = serde_json::from_str(line)
        .with_context(|| format!("invalid plan at line {line_number}"))?;
    document
        .lower()
        .with_context(|| format!("cannot lower plan at line {line_number}"))
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
    let scope_profiles = read_scope_profiles(manifest, &fields, max_bytes)?;
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
            let structural_key = format!(
                "{:?}|{:?}|{:?}|{:?}",
                plan.role, plan.output, plan.scope, plan.program
            );
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
                &scope_profiles,
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

#[derive(Debug)]
struct ScopeMutationProfile {
    field: String,
    observed_mask: u64,
    positive_majority_mask: u64,
}

fn read_scope_profiles(
    manifest: &ergodis::control::Manifest,
    fields: &[String],
    max_bytes: usize,
) -> Result<Vec<ScopeMutationProfile>> {
    let mut profiles = Vec::new();
    for field in ["root_orbit", "root_candidate"] {
        if !fields.iter().any(|candidate| candidate == field) {
            continue;
        }
        let response = send_request(
            manifest,
            "scope-profile",
            json!({"field": field}),
            max_bytes,
        )?;
        if !response.ok {
            bail!("scope profile rejected: {}", response.result);
        }
        let observed_mask = number(&response.result, "observed_mask");
        let mut positive_majority_mask = 0_u64;
        for stratum in response.result["strata"]
            .as_array()
            .ok_or_else(|| anyhow::anyhow!("scope profile omitted strata"))?
        {
            if number(stratum, "positive_weight") > number(stratum, "negative_weight") {
                positive_majority_mask |= 1_u64 << number(stratum, "value");
            }
        }
        if observed_mask != 0 {
            profiles.push(ScopeMutationProfile {
                field: field.to_owned(),
                observed_mask,
                positive_majority_mask,
            });
        }
    }
    Ok(profiles)
}

fn push_scoped_child(
    parent: &PlanSpec,
    field: &str,
    mask: u64,
    output: &mut Vec<PlanSpec>,
    limit: usize,
) -> bool {
    if mask == 0 || output.len() == limit {
        return output.len() == limit;
    }
    let mut child = parent.clone();
    child.scope = Some(PlanScope {
        field: field.to_owned(),
        mask,
    });
    output.push(child);
    output.len() == limit
}

fn mutate_plan(
    parent: &PlanSpec,
    fields: &[String],
    scope_profiles: &[ScopeMutationProfile],
    output: &mut Vec<PlanSpec>,
    limit: usize,
) {
    for profile in scope_profiles {
        if parent
            .scope
            .as_ref()
            .is_some_and(|scope| scope.field == profile.field)
        {
            let current_mask = parent.scope.as_ref().map_or(0, |scope| scope.mask);
            let mut bits = profile.observed_mask;
            while bits != 0 {
                let bit = bits & bits.wrapping_neg();
                bits ^= bit;
                if push_scoped_child(parent, &profile.field, current_mask ^ bit, output, limit) {
                    return;
                }
            }
        } else {
            let mut bits = profile.observed_mask;
            while bits != 0 {
                let bit = bits & bits.wrapping_neg();
                bits ^= bit;
                if push_scoped_child(parent, &profile.field, bit, output, limit) {
                    return;
                }
            }
            if profile.positive_majority_mask != profile.observed_mask
                && push_scoped_child(
                    parent,
                    &profile.field,
                    profile.positive_majority_mask,
                    output,
                    limit,
                )
            {
                return;
            }
        }
    }
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
        let plan = parse_plan_json_line(&line, line_number + 1)?;
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
        "noop" => println!("epoch={epoch} noop"),
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
        "evolve-profile-refresh" => println!(
            "epoch={epoch} queued={} replaced_pending={}",
            result
                .get("queued")
                .and_then(Value::as_bool)
                .unwrap_or(false),
            result
                .get("replaced_pending")
                .and_then(Value::as_bool)
                .unwrap_or(false)
        ),
        "evolve-start"
        | "evolve-status"
        | "evolve-cancel"
        | "target-profile-reset"
        | "target-profile-observe"
        | "target-profile-edge"
        | "target-profile-status" => println!(
            "epoch={epoch} evolution={} state={} tested={} perfect={} path={}",
            text(result, "id"),
            text(result, "state"),
            evolution_count(result, "tested"),
            evolution_count(result, "perfect"),
            text(result, "path")
        ),
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

fn evolution_count(result: &Value, key: &str) -> u64 {
    result
        .get("progress")
        .or_else(|| result.get("summary"))
        .map_or(0, |counters| number(counters, key))
}

fn signed(value: &Value, key: &str) -> i64 {
    value.get(key).and_then(Value::as_i64).unwrap_or(0)
}

#[cfg(test)]
mod probation_tests {
    use super::*;
    use std::io::Cursor;

    #[test]
    fn proposer_commands_are_typed_by_clap() {
        let cli = Cli::try_parse_from([
            "ergodisctl",
            "--run-dir",
            "/tmp/example",
            "proposal-session-open",
            "--role",
            "heuristic",
            "--role",
            "necessary-reduction",
        ])
        .unwrap();
        let Command::ProposalSessionOpen { role, .. } = cli.command else {
            panic!("wrong command");
        };
        assert_eq!(
            role.into_iter().fold(0_u8, |mask, role| mask | role.mask()),
            CliProposalRole::Heuristic.mask() | CliProposalRole::NecessaryReduction.mask()
        );
        assert!(Cli::try_parse_from([
            "ergodisctl",
            "--run-dir",
            "/tmp/example",
            "proposal-worker-failure",
            "--session",
            "s",
            "--ticket",
            "t",
            "--attempt",
            "0",
            "--failure",
            "not-a-failure",
        ])
        .is_err());
    }

    #[test]
    fn evolution_counts_survive_completion_reaping() {
        let running = json!({"progress": {"tested": 7, "perfect": 1}});
        let complete = json!({"state": "complete", "summary": {"tested": 101, "perfect": 3}});
        assert_eq!(evolution_count(&running, "tested"), 7);
        assert_eq!(evolution_count(&running, "perfect"), 1);
        assert_eq!(evolution_count(&complete, "tested"), 101);
        assert_eq!(evolution_count(&complete, "perfect"), 3);
    }

    #[test]
    fn single_plan_reader_accepts_text_and_json_with_identical_lowering() {
        let directory = tempfile::tempdir().unwrap();
        let text_path = directory.path().join("plan.ergo");
        let json_path = directory.path().join("plan.json");
        std::fs::write(
            &text_path,
            "plan parity { role diagnostic; output predicate; expr debt <= 3; }",
        )
        .unwrap();
        std::fs::write(
            &json_path,
            serde_json::to_vec(&serde_json::json!({
                "schema": ergodis::control::PLAN_SCHEMA,
                "name": "parity",
                "role": "diagnostic",
                "output": "predicate",
                "expr": {
                    "op": "le",
                    "left": {"op": "field", "name": "debt"},
                    "right": {"op": "const", "value": 3}
                }
            }))
            .unwrap(),
        )
        .unwrap();
        assert_eq!(
            serde_json::to_value(read_plan(&text_path).unwrap()).unwrap(),
            serde_json::to_value(read_plan(&json_path).unwrap()).unwrap()
        );
    }

    #[test]
    fn population_reader_accepts_expression_and_bytecode_documents() {
        let expression = serde_json::json!({
            "schema": ergodis::control::PLAN_SCHEMA,
            "name": "parity",
            "role": "diagnostic",
            "output": "predicate",
            "expr": {
                "op": "le",
                "left": {"op": "field", "name": "debt"},
                "right": {"op": "const", "value": 3}
            }
        });
        let lowered = PlanDocument::Expression(serde_json::from_value(expression.clone()).unwrap())
            .lower()
            .unwrap();
        let bytecode = serde_json::to_string(&lowered).unwrap();
        assert_eq!(
            serde_json::to_value(parse_plan_json_line(&expression.to_string(), 7).unwrap())
                .unwrap(),
            serde_json::to_value(parse_plan_json_line(&bytecode, 8).unwrap()).unwrap()
        );
    }

    #[test]
    fn group_synthesize_composes_create_only_artifacts_end_to_end() {
        let temporary = tempfile::tempdir().unwrap();
        let data = temporary.path().join("data.jsonl");
        std::fs::write(
            &data,
            concat!(
                "{\"schema\":\"ergodis-campaign-data-v0\",\"presentation\":\"groups\",\"problem\":\"fixture\",\"fields\":[\"group\",\"value\"],\"rows\":4}\n",
                "{\"id\":0,\"expected\":false,\"values\":[0,0]}\n",
                "{\"id\":1,\"expected\":false,\"values\":[0,0]}\n",
                "{\"id\":2,\"expected\":true,\"values\":[1,1]}\n",
                "{\"id\":3,\"expected\":true,\"values\":[1,1]}\n"
            ),
        )
        .unwrap();
        let run_dir = temporary.path().join("run");
        let campaign = ergodis::control::Campaign::create(
            &data,
            &run_dir,
            Some(temporary.path().join("control.sock")),
            4096,
            16 * 1024,
            4096,
        )
        .unwrap();
        let manifest = campaign.manifest().clone();
        let server = thread::spawn(move || campaign.serve().unwrap());
        for _ in 0..100 {
            if manifest.socket.exists() {
                break;
            }
            thread::sleep(Duration::from_millis(2));
        }
        assert!(manifest.socket.exists());

        let output = temporary.path().join("plan.json");
        run_group_synthesize(
            &manifest,
            "group",
            true,
            &["value".into()],
            &[],
            &[],
            "parents",
            &output,
            16,
            64,
            7,
            3,
            None,
            None,
            16 * 1024,
        )
        .unwrap();
        assert!(run_dir.join("evidence/parents.data.jsonl").is_file());
        let plan: PlanSpec = serde_json::from_slice(&std::fs::read(&output).unwrap()).unwrap();
        assert_eq!(plan.output, PlanOutput::Predicate);
        assert!(run_group_synthesize(
            &manifest,
            "group",
            true,
            &["value".into()],
            &[],
            &[],
            "must-not-exist",
            &output,
            16,
            64,
            7,
            3,
            None,
            None,
            16 * 1024,
        )
        .is_err());
        assert!(!run_dir.join("evidence/must-not-exist.data.jsonl").exists());

        send_request(&manifest, "shutdown", json!({}), 4096).unwrap();
        server.join().unwrap();
    }

    #[test]
    fn windows_filter_epochs_and_measure_cumulative_rate() {
        let data = concat!(
            "{\"elapsed_ms\":1000,\"applied_epoch\":1,\"solver\":{\"states\":100,\"root_done\":0}}\n",
            "{\"elapsed_ms\":2000,\"applied_epoch\":1,\"solver\":{\"states\":300,\"root_done\":1}}\n",
            "{\"elapsed_ms\":3000,\"applied_epoch\":2,\"solver\":{\"states\":350,\"root_done\":1}}\n",
            "{\"elapsed_ms\":4000,\"applied_epoch\":2,\"solver\":{\"states\":750,\"root_done\":3}}\n",
        );
        let mut reader = Cursor::new(data.as_bytes());
        let mut fragment = String::new();
        let deadline = Instant::now() + Duration::from_secs(1);
        let active = collect_progress_window(&mut reader, &mut fragment, 1, 2, deadline).unwrap();
        let inactive = collect_progress_window(&mut reader, &mut fragment, 2, 2, deadline).unwrap();
        assert_eq!(
            progress_rate(&active, |sample| sample.solver.states).unwrap(),
            200.0
        );
        assert_eq!(
            progress_rate(&inactive, |sample| sample.solver.states).unwrap(),
            400.0
        );
        assert_eq!(
            progress_rate(&inactive, |sample| sample.solver.root_done).unwrap(),
            2.0
        );
        assert_eq!(progress_stratum(&active), progress_stratum(&inactive));
    }

    #[test]
    fn stratum_rejects_windows_that_cross_roots() {
        let records = [
            ProgressRecord {
                elapsed_ms: 1_000,
                applied_epoch: 1,
                solver: ProgressSolver {
                    states: 100,
                    root_done: 0,
                    root_candidate: 3,
                    root_initial_unresolved: 7,
                    root_initial_packing: 2,
                    root_initial_branches: 4,
                },
            },
            ProgressRecord {
                elapsed_ms: 2_000,
                applied_epoch: 1,
                solver: ProgressSolver {
                    states: 200,
                    root_done: 1,
                    root_candidate: 4,
                    root_initial_unresolved: 7,
                    root_initial_packing: 2,
                    root_initial_branches: 4,
                },
            },
        ];
        assert_eq!(progress_stratum(&records), None);
    }

    #[test]
    fn evolution_generates_singleton_and_label_aligned_scopes_first() {
        let parent = PlanSpec {
            schema: ergodis::control::PLAN_SCHEMA.into(),
            name: "seed".into(),
            role: PlanRole::Diagnostic,
            output: PlanOutput::Predicate,
            scope: None,
            program: vec![PlanOp::Const { value: 1 }],
        };
        let profile = ScopeMutationProfile {
            field: "root_orbit".into(),
            observed_mask: 0b1011,
            positive_majority_mask: 0b1001,
        };
        let mut children = Vec::new();
        mutate_plan(&parent, &[], &[profile], &mut children, 8);
        let masks: Vec<u64> = children
            .iter()
            .filter_map(|child| child.scope.as_ref().map(|scope| scope.mask))
            .collect();
        assert_eq!(masks, vec![0b0001, 0b0010, 0b1000, 0b1001]);
    }
}
