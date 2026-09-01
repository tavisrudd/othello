//! Optional, experimental control plane for long theorem-search campaigns.
//!
//! This module is feature-gated so ordinary solves retain no controller state,
//! filesystem traffic, atomics, or hot-loop branches.

use crate::multiset::{MultisetBounds, MultisetStatistic};
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use std::collections::{BTreeMap, BTreeSet, VecDeque};
use std::fs::{self, File, OpenOptions};
use std::io::{self, BufReader, BufWriter, Read, Write};
use std::os::unix::fs::{FileTypeExt, OpenOptionsExt, PermissionsExt};
use std::os::unix::net::{UnixDatagram, UnixListener, UnixStream};
use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::Arc;
use std::thread::{self, JoinHandle};
use std::time::Duration;

mod client;
mod evolution;
mod synthesis;
mod text;
mod vm;

pub use client::PlanArena;
use evolution::{
    load_evolution_seeds, run_evolution, EvolutionBounds, EvolutionIdentity, EvolutionProgress,
    EvolutionSeed,
};
use synthesis::learn_decision_tree;
pub use text::{
    format_expression_plan, format_plan_expression, format_plan_name, lex_plan_text,
    parse_and_lower_plan, parse_expression_plan, parse_plan_expression, parse_plan_i64_literal,
    parse_plan_u64_literal, validate_plan_name, PlanTextToken, PlanTextTokenKind,
    MAX_PLAN_TEXT_BYTES, MAX_PLAN_TEXT_TOKENS,
};
pub use vm::{
    evaluate_plan, CompiledPlan, Evaluation, ExpressionPlanSpec, FeatureBatch,
    FeatureGeneratorProvenance, PlanDocument, PlanExpr, PlanOp, PlanOutput, PlanRole, PlanScope,
    PlanSpec,
};

pub const SCHEMA: &str = "ergodis-control-experimental-v0";
pub const DATA_SCHEMA: &str = "ergodis-campaign-data-v0";
pub const PLAN_SCHEMA: &str = "ergodis-attack-plan-v0";
pub const MAX_FRAME_BYTES: usize = 64 * 1024;
pub const MAX_PLAN_OPS: usize = 128;
pub const MAX_PLAN_STACK: usize = 64;
pub const MAX_ACTIVE_PLANS: usize = 64;
pub const MAX_ARCHIVE_CLASSES: usize = 4096;
pub const MAX_CANDIDATE_BATCH: usize = 4096;
pub const SOCKET_IO_TIMEOUT: Duration = Duration::from_secs(10);
const EVENT_RING: usize = 256;
const MAX_WATCHERS: usize = 64;
static NEXT_CLIENT_REQUEST_ID: AtomicU64 = AtomicU64::new(1);

#[derive(Debug, thiserror::Error)]
pub enum ControlError {
    #[error("I/O failure: {0}")]
    Io(#[from] io::Error),
    #[error("invalid JSON: {0}")]
    Json(#[from] serde_json::Error),
    #[error("{0}")]
    Invalid(String),
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct Manifest {
    pub schema: String,
    pub run_id: String,
    pub nonce: String,
    pub socket: PathBuf,
    pub run_dir: PathBuf,
    pub pid: u32,
    pub code_commit: String,
    pub presentation_hash: String,
    pub problem: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub feature_generator: Option<FeatureGeneratorProvenance>,
}

#[derive(Debug, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct Request {
    pub schema: String,
    pub request_id: u64,
    pub run_id: String,
    pub nonce: String,
    pub max_bytes: usize,
    pub op: String,
    #[serde(default)]
    pub args: Value,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Response {
    pub schema: String,
    pub request_id: u64,
    pub run_id: String,
    pub epoch: u64,
    pub ok: bool,
    pub result: Value,
}

#[derive(Clone, Debug, Serialize)]
struct Event {
    seq: u64,
    epoch: u64,
    kind: String,
    synopsis: String,
    plan: Option<String>,
}

struct Ledger {
    writer: BufWriter<File>,
    bytes: u64,
    max_bytes: u64,
    truncated: bool,
}

impl Ledger {
    fn create(path: &Path, max_bytes: u64) -> Result<Self, ControlError> {
        let file = OpenOptions::new()
            .write(true)
            .create_new(true)
            .mode(0o600)
            .open(path)?;
        Ok(Self {
            writer: BufWriter::new(file),
            bytes: 0,
            max_bytes,
            truncated: false,
        })
    }

    fn append(&mut self, event: &Event) -> Result<bool, ControlError> {
        let mut encoded = serde_json::to_vec(event)?;
        encoded.push(b'\n');
        if self.bytes.saturating_add(encoded.len() as u64) > self.max_bytes {
            self.truncated = true;
            return Ok(false);
        }
        self.writer.write_all(&encoded)?;
        self.writer.flush()?;
        self.bytes += encoded.len() as u64;
        Ok(true)
    }
}

struct StoredPlan {
    spec: PlanSpec,
    plan: CompiledPlan,
    evaluation: Evaluation,
}

struct EvolutionJob {
    id: String,
    relative_path: PathBuf,
    progress: Arc<EvolutionProgress>,
    handle: JoinHandle<Result<Value, ControlError>>,
}

pub struct Campaign {
    manifest: Manifest,
    batch: Arc<FeatureBatch>,
    epoch: AtomicU64,
    seq: u64,
    plans: Vec<StoredPlan>,
    archive: BTreeMap<String, String>,
    events: VecDeque<Event>,
    solver_status: Option<Value>,
    live_scope_masks: BTreeMap<String, u64>,
    watchers: Vec<PathBuf>,
    ledger: Ledger,
    response_limit: usize,
    trace_limit: u64,
    evolution: Option<EvolutionJob>,
    last_evolution: Option<Value>,
}

impl Campaign {
    pub fn create(
        data: &Path,
        run_dir: &Path,
        socket: Option<PathBuf>,
        ledger_limit: u64,
        response_limit: usize,
        trace_limit: u64,
    ) -> Result<Self, ControlError> {
        let run_dir = absolute_path(run_dir)?;
        if run_dir.exists() {
            return Err(ControlError::Invalid("run directory already exists".into()));
        }
        fs::create_dir(&run_dir)?;
        fs::set_permissions(&run_dir, fs::Permissions::from_mode(0o700))?;
        fs::create_dir(run_dir.join("evidence"))?;
        fs::set_permissions(run_dir.join("evidence"), fs::Permissions::from_mode(0o700))?;
        let batch = FeatureBatch::read_jsonl(data, 10_000_000, 200_000_000)?;
        let batch = Arc::new(batch);
        let run_id = random_hex(16)?;
        let nonce = random_hex(16)?;
        let socket = match socket {
            Some(path) => absolute_path(&path)?,
            None => default_socket(&run_id, &nonce)?,
        };
        if socket.exists() {
            return Err(ControlError::Invalid(
                "socket endpoint already exists".into(),
            ));
        }
        let data_hash = hash_file(data)?;
        let manifest = Manifest {
            schema: SCHEMA.into(),
            run_id,
            nonce,
            socket,
            run_dir: run_dir.clone(),
            pid: std::process::id(),
            code_commit: option_env!("ERGODIS_GIT_COMMIT")
                .unwrap_or("unknown")
                .into(),
            presentation_hash: data_hash,
            problem: batch.problem.clone(),
            feature_generator: batch.generator.clone(),
        };
        write_create_json(&run_dir.join("manifest.json"), &manifest)?;
        let ledger = Ledger::create(&run_dir.join("ledger.jsonl"), ledger_limit)?;
        Ok(Self {
            manifest,
            batch,
            epoch: AtomicU64::new(0),
            seq: 0,
            plans: Vec::with_capacity(MAX_ACTIVE_PLANS),
            archive: BTreeMap::new(),
            events: VecDeque::with_capacity(EVENT_RING),
            solver_status: None,
            live_scope_masks: BTreeMap::new(),
            watchers: Vec::with_capacity(MAX_WATCHERS),
            ledger,
            response_limit: response_limit.min(MAX_FRAME_BYTES),
            trace_limit,
            evolution: None,
            last_evolution: None,
        })
    }

    pub fn manifest(&self) -> &Manifest {
        &self.manifest
    }

    pub fn serve(mut self) -> Result<(), ControlError> {
        if let Some(parent) = self.manifest.socket.parent() {
            fs::create_dir_all(parent)?;
            fs::set_permissions(parent, fs::Permissions::from_mode(0o700))?;
        }
        let listener = UnixListener::bind(&self.manifest.socket)?;
        fs::set_permissions(&self.manifest.socket, fs::Permissions::from_mode(0o600))?;
        self.record("started", "campaign ready", None)?;
        let mut shutdown = false;
        while !shutdown {
            let (mut stream, _) = listener.accept()?;
            stream.set_read_timeout(Some(SOCKET_IO_TIMEOUT))?;
            stream.set_write_timeout(Some(SOCKET_IO_TIMEOUT))?;
            match read_frame(&mut stream) {
                Ok(bytes) => {
                    let request = serde_json::from_slice::<Request>(&bytes);
                    let (response, limit) = match request {
                        Ok(request) => {
                            let limit = request.max_bytes.min(self.response_limit);
                            let (response, stop) = self.handle(request);
                            shutdown |= stop;
                            (response, limit)
                        }
                        Err(error) => (
                            self.error_response(0, format!("invalid request: {error}")),
                            self.response_limit,
                        ),
                    };
                    let _ = write_response(&mut stream, response, limit);
                }
                Err(error) => {
                    let response = self.error_response(0, error.to_string());
                    let _ = write_response(&mut stream, response, self.response_limit);
                }
            }
        }
        drop(listener);
        if let Some(job) = self.evolution.take() {
            job.progress.cancel();
            let _ = job.handle.join();
        }
        fs::remove_file(&self.manifest.socket)?;
        Ok(())
    }

    fn handle(&mut self, request: Request) -> (Response, bool) {
        if request.schema != SCHEMA
            || request.run_id != self.manifest.run_id
            || request.nonce != self.manifest.nonce
        {
            return (
                self.error_response(request.request_id, "run handshake rejected"),
                false,
            );
        }
        let request_limit = request.max_bytes.min(self.response_limit);
        let result = match request.op.as_str() {
            "capabilities" => self.capabilities(),
            "status" => self.status(),
            "pulse" => self.pulse(&request.args),
            "watch-register" => self.watch_register(&request.args),
            "watch-unregister" => self.watch_unregister(&request.args),
            "plan-get" => self.plan_get(&request.args),
            "agent-brief" => self.agent_brief(&request.args),
            "feature-ceiling" => self.feature_ceiling(),
            "group-compile" => self.group_compile(&request.args),
            "scope-profile" => self.scope_profile(&request.args),
            "synthesize-tree" => self.synthesize_tree(&request.args),
            "candidate-try" => self.candidate_try(&request.args, false),
            "candidate-batch" => self.candidate_batch(&request.args),
            "evolve-start" => self.evolution_start(&request.args),
            "evolve-status" => self.evolution_status(),
            "evolve-cancel" => self.evolution_cancel(),
            "candidate-apply" => self.candidate_try(&request.args, true),
            "candidate-deactivate" => self.candidate_deactivate(&request.args),
            "obstruction-first" => self.obstruction(&request.args),
            "exceptional" => self.exceptional(&request.args),
            "trace" => self.trace(&request.args),
            "note" => self.note(&request.args),
            "noop" => Ok(json!({"noop": true})),
            "shutdown" => Ok(json!({"stopping": true})),
            _ => Err(ControlError::Invalid(format!(
                "unknown operation {:?}",
                request.op
            ))),
        };
        let stop = request.op == "shutdown" && result.is_ok();
        let mut response = match result {
            Ok(value) => self.success_response(request.request_id, value),
            Err(error) => self.error_response(request.request_id, error.to_string()),
        };
        if serde_json::to_vec(&response).map_or(true, |bytes| bytes.len() > request_limit) {
            response =
                self.error_response(request.request_id, "response exceeds requested max_bytes");
        }
        (response, stop)
    }

    fn capabilities(&self) -> Result<Value, ControlError> {
        Ok(json!({
            "schema": SCHEMA,
            "framing": "u32-le-length-prefixed-json",
            "max_frame_bytes": MAX_FRAME_BYTES,
            "socket_io_timeout_ms": SOCKET_IO_TIMEOUT.as_millis() as u64,
            "large_results": "run-relative-create-only-files",
            "proof_authority": false,
            "operations": [
                "capabilities", "status", "pulse", "watch-register",
                "watch-unregister", "plan-get", "agent-brief",
                "feature-ceiling", "scope-profile", "synthesize-tree",
                "group-compile",
                "candidate-try", "candidate-apply", "candidate-deactivate",
                "candidate-batch",
                "evolve-start", "evolve-status", "evolve-cancel",
                "obstruction-first", "exceptional", "trace", "note", "noop",
                "shutdown"
            ],
        }))
    }

    fn status(&self) -> Result<Value, ControlError> {
        Ok(json!({
            "problem": self.batch.problem,
            "presentation": self.batch.presentation,
            "presentation_hash": self.manifest.presentation_hash,
            "feature_generator": self.manifest.feature_generator,
            "rows": self.batch.rows(),
            "fields": self.batch.fields,
            "plans": self.plans.len(),
            "outcome_classes": self.archive.len(),
            "ledger_bytes": self.ledger.bytes,
            "ledger_limit": self.ledger.max_bytes,
            "ledger_truncated": self.ledger.truncated,
            "health": "ready",
            "solver": self.solver_status,
            "watchers": self.watchers.len(),
            "evolution": self.evolution.as_ref().map(|job| json!({
                "id": job.id,
                "path": job.relative_path,
                "progress": job.progress.snapshot(),
            })).or_else(|| self.last_evolution.clone()),
        }))
    }

    fn watch_register(&mut self, args: &Value) -> Result<Value, ControlError> {
        let path = PathBuf::from(
            args.get("path")
                .and_then(Value::as_str)
                .ok_or_else(|| ControlError::Invalid("watch-register requires path".into()))?,
        );
        if path.parent() != Some(self.manifest.run_dir.as_path())
            || !path
                .file_name()
                .and_then(|name| name.to_str())
                .is_some_and(|name| name.starts_with("watch-"))
            || !fs::metadata(&path)?.file_type().is_socket()
        {
            return Err(ControlError::Invalid("invalid watcher endpoint".into()));
        }
        if !self.watchers.contains(&path) {
            if self.watchers.len() == MAX_WATCHERS {
                return Err(ControlError::Invalid("watcher arena full".into()));
            }
            self.watchers.push(path.clone());
        }
        Ok(json!({
            "path": path,
            "epoch": self.epoch.load(Ordering::Acquire),
        }))
    }

    fn watch_unregister(&mut self, args: &Value) -> Result<Value, ControlError> {
        let path = PathBuf::from(
            args.get("path")
                .and_then(Value::as_str)
                .ok_or_else(|| ControlError::Invalid("watch-unregister requires path".into()))?,
        );
        let before = self.watchers.len();
        self.watchers.retain(|candidate| candidate != &path);
        Ok(json!({"removed": before != self.watchers.len()}))
    }

    fn notify_watchers(&mut self, epoch: u64) {
        let Ok(socket) = UnixDatagram::unbound() else {
            return;
        };
        let message = epoch.to_le_bytes();
        self.watchers
            .retain(|path| socket.send_to(&message, path).is_ok());
    }

    /// Safe-point query for a live solver. The unchanged response is constant
    /// size; changed epochs return only bounded plan identities.
    fn pulse(&mut self, args: &Value) -> Result<Value, ControlError> {
        if let Some(status) = args.get("solver").filter(|status| !status.is_null()) {
            let number = |name: &str| {
                status
                    .get(name)
                    .and_then(Value::as_u64)
                    .ok_or_else(|| ControlError::Invalid("invalid solver pulse".into()))
            };
            let optional_number = |name: &str| match status.get(name) {
                None | Some(Value::Null) => Ok(None),
                Some(value) => value
                    .as_u64()
                    .map(Some)
                    .ok_or_else(|| ControlError::Invalid("invalid solver pulse".into())),
            };
            let optional_bool = |name: &str| match status.get(name) {
                None | Some(Value::Null) => Ok(None),
                Some(value) => value
                    .as_bool()
                    .map(Some)
                    .ok_or_else(|| ControlError::Invalid("invalid solver pulse".into())),
            };
            let root_candidate = optional_number("root_candidate")?;
            let root_orbit = optional_number("root_orbit")?;
            for (field, value) in [
                ("root_candidate", root_candidate),
                ("root_orbit", root_orbit),
            ] {
                if let Some(value) = value.filter(|&value| value < 64) {
                    *self.live_scope_masks.entry(field.into()).or_default() |= 1_u64 << value;
                }
            }
            self.solver_status = Some(json!({
                "states": number("states")?,
                "duplicates": number("duplicates")?,
                "infeasible": number("infeasible")?,
                "depth": number("depth")?,
                "selected_count": number("selected_count")?,
                "unresolved_count": number("unresolved_count")?,
                "root_done": optional_number("root_done")?,
                "root_total": optional_number("root_total")?,
                "root_candidate": root_candidate,
                "root_orbit": root_orbit,
                "root_states": optional_number("root_states")?,
                "root_duplicates": optional_number("root_duplicates")?,
                "root_infeasible": optional_number("root_infeasible")?,
                "root_ordinal": optional_number("root_ordinal")?,
                "root_sized": optional_bool("root_sized")?,
                "root_initial_unresolved": optional_number("root_initial_unresolved")?,
                "root_initial_packing": optional_number("root_initial_packing")?,
                "root_initial_branches": optional_number("root_initial_branches")?,
                "active_root_mask": optional_number("active_root_mask")?,
                "completed_root_mask": optional_number("completed_root_mask")?,
            }));
        }
        let since_epoch = args
            .get("since_epoch")
            .and_then(Value::as_u64)
            .ok_or_else(|| ControlError::Invalid("pulse requires since_epoch".into()))?;
        let epoch = self.epoch.load(Ordering::Acquire);
        if since_epoch > epoch {
            return Err(ControlError::Invalid(format!(
                "pulse epoch {since_epoch} is ahead of current epoch {epoch}"
            )));
        }
        if since_epoch == epoch {
            return Ok(json!({"changed": false, "epoch": epoch}));
        }
        let plans: Vec<_> = self
            .plans
            .iter()
            .map(|stored| {
                json!({
                    "name": stored.plan.name,
                    "hash": stored.plan.hash,
                    "role": stored.plan.role,
                    "output": stored.plan.output,
                })
            })
            .collect();
        Ok(json!({"changed": true, "epoch": epoch, "plans": plans}))
    }

    /// Fetch one lowered plan from a stable epoch. Callers retry the pulse if
    /// the epoch changes between discovery and fetch.
    fn plan_get(&self, args: &Value) -> Result<Value, ControlError> {
        let expected_epoch = args
            .get("expect_epoch")
            .and_then(Value::as_u64)
            .ok_or_else(|| ControlError::Invalid("plan-get requires expect_epoch".into()))?;
        let epoch = self.epoch.load(Ordering::Acquire);
        if expected_epoch != epoch {
            return Err(ControlError::Invalid(format!(
                "stale epoch: expected {expected_epoch}, current {epoch}"
            )));
        }
        let name = args
            .get("plan")
            .and_then(Value::as_str)
            .ok_or_else(|| ControlError::Invalid("plan-get requires plan".into()))?;
        let stored = self
            .plans
            .iter()
            .find(|stored| stored.plan.name == name)
            .ok_or_else(|| ControlError::Invalid("unknown active plan".into()))?;
        Ok(json!({
            "epoch": epoch,
            "plan": stored.spec,
            "hash": stored.plan.hash,
        }))
    }

    fn agent_brief(&self, args: &Value) -> Result<Value, ControlError> {
        let since = args.get("since").and_then(Value::as_u64).unwrap_or(0);
        let top = args.get("top").and_then(Value::as_u64).unwrap_or(8).min(16) as usize;
        let selected: Vec<_> = self
            .events
            .iter()
            .filter(|event| event.seq > since)
            .take(top)
            .collect();
        let total = self.events.iter().filter(|event| event.seq > since).count();
        Ok(json!({
            "health": "ready",
            "changes": selected,
            "omitted": total.saturating_sub(selected.len()),
            "plans": self.plans.len(),
            "rows": self.batch.rows(),
            "ledger_headroom": self.ledger.max_bytes.saturating_sub(self.ledger.bytes),
            "recommended": if self.plans.is_empty() { "submit a diagnostic candidate" } else { "inspect the first obstruction or submit a sharper child" },
            "next_cursor": self.seq,
        }))
    }

    fn feature_ceiling(&self) -> Result<Value, ControlError> {
        if self.batch.rows() > u32::MAX as usize {
            return Err(ControlError::Invalid(
                "feature ceiling requires at most u32::MAX rows".into(),
            ));
        }
        let mut order: Vec<u32> = (0..self.batch.rows() as u32).collect();
        order.sort_unstable_by(|&left, &right| {
            self.batch
                .row(left as usize)
                .cmp(self.batch.row(right as usize))
                .then_with(|| left.cmp(&right))
        });
        let mut weighted_rows = 0u64;
        let mut optimal_correct = 0u64;
        let mut ambiguous_weight = 0u64;
        let mut ambiguous_groups = 0usize;
        let mut distinct_vectors = 0usize;
        let mut first_collision = None;
        let mut start = 0usize;
        while start < order.len() {
            let first = order[start] as usize;
            let mut end = start + 1;
            let mut positive = 0u64;
            let mut negative = 0u64;
            let mut positive_row = None;
            let mut negative_row = None;
            while end <= order.len() {
                if end == order.len()
                    || self.batch.row(order[end] as usize) != self.batch.row(first)
                {
                    break;
                }
                end += 1;
            }
            for &row in &order[start..end] {
                let row = row as usize;
                if self.batch.expected(row) {
                    positive += self.batch.weights[row];
                    positive_row.get_or_insert(row);
                } else {
                    negative += self.batch.weights[row];
                    negative_row.get_or_insert(row);
                }
            }
            distinct_vectors += 1;
            weighted_rows = weighted_rows.saturating_add(positive.saturating_add(negative));
            optimal_correct = optimal_correct.saturating_add(positive.max(negative));
            if positive != 0 && negative != 0 {
                ambiguous_groups += 1;
                ambiguous_weight = ambiguous_weight.saturating_add(positive + negative);
                if first_collision.is_none() {
                    first_collision = Some(json!({
                        "positive": self.batch.row_json(positive_row.unwrap()),
                        "negative": self.batch.row_json(negative_row.unwrap()),
                    }));
                }
            }
            start = end;
        }
        Ok(json!({
            "rows": self.batch.rows(),
            "weighted_rows": weighted_rows,
            "distinct_feature_vectors": distinct_vectors,
            "ambiguous_groups": ambiguous_groups,
            "ambiguous_weight": ambiguous_weight,
            "optimal_weighted_correct": optimal_correct,
            "unavoidable_weighted_errors": weighted_rows.saturating_sub(optimal_correct),
            "first_collision": first_collision,
        }))
    }

    fn group_compile(&mut self, args: &Value) -> Result<Value, ControlError> {
        let group_name = required_str(args, "group_by")?;
        let group_field = self
            .batch
            .fields
            .iter()
            .position(|field| field == group_name)
            .ok_or_else(|| ControlError::Invalid("unknown group_by field".into()))?;
        let evidence_name = required_str(args, "evidence_name")?;
        if evidence_name.is_empty()
            || evidence_name.len() > 64
            || !evidence_name
                .bytes()
                .all(|byte| byte.is_ascii_alphanumeric() || matches!(byte, b'-' | b'_' | b'.'))
        {
            return Err(ControlError::Invalid(
                "group-compile evidence_name is not a safe slug".into(),
            ));
        }
        let mut statistics = Vec::new();
        if args.get("count").and_then(Value::as_bool).unwrap_or(true) {
            statistics.push(MultisetStatistic::Count);
        }
        for argument in ["sum", "minimum", "maximum"] {
            let names = args
                .get(argument)
                .and_then(Value::as_array)
                .map(Vec::as_slice)
                .unwrap_or(&[]);
            for name in names {
                let name = name.as_str().ok_or_else(|| {
                    ControlError::Invalid(format!("{argument} fields must be strings"))
                })?;
                let field = self
                    .batch
                    .fields
                    .iter()
                    .position(|candidate| candidate == name)
                    .ok_or_else(|| {
                        ControlError::Invalid(format!("unknown aggregate field {name:?}"))
                    })?;
                statistics.push(match argument {
                    "sum" => MultisetStatistic::Sum { field },
                    "minimum" => MultisetStatistic::Minimum { field },
                    "maximum" => MultisetStatistic::Maximum { field },
                    _ => unreachable!(),
                });
            }
        }
        if statistics.is_empty() {
            return Err(ControlError::Invalid(
                "group-compile requires at least one statistic".into(),
            ));
        }
        let max_groups = args
            .get("max_groups")
            .and_then(Value::as_u64)
            .unwrap_or(1_000_000)
            .clamp(1, 1_000_000) as usize;
        let max_output_cells = args
            .get("max_output_cells")
            .and_then(Value::as_u64)
            .unwrap_or(200_000_000)
            .clamp(1, 200_000_000) as usize;
        let grouped = self.batch.aggregate_uniform_groups(
            group_field,
            &statistics,
            MultisetBounds {
                max_rows: self.batch.rows().max(1),
                max_groups,
                max_output_cells,
            },
        )?;
        let relative = PathBuf::from("evidence").join(format!("{evidence_name}.data.jsonl"));
        let file = OpenOptions::new()
            .write(true)
            .create_new(true)
            .mode(0o600)
            .open(self.manifest.run_dir.join(&relative))?;
        let mut writer = BufWriter::new(file);
        grouped.write_jsonl(&mut writer)?;
        writer.flush()?;
        let synopsis = format!(
            "compiled {} child rows into {} parent groups",
            self.batch.rows(),
            grouped.rows()
        );
        self.record("group-compiled", &synopsis, None)?;
        Ok(json!({
            "path": relative,
            "child_rows": self.batch.rows(),
            "groups": grouped.rows(),
            "fields": grouped.fields,
            "generator": grouped.generator,
        }))
    }

    fn scope_profile(&self, args: &Value) -> Result<Value, ControlError> {
        let field = required_str(args, "field")?;
        let field_index = self
            .batch
            .fields
            .iter()
            .position(|candidate| candidate == field)
            .ok_or_else(|| ControlError::Invalid(format!("unknown scope field {field:?}")))?;
        let mut bins = [(0_u64, 0_u64, 0_u64, 0_u64); 64];
        let mut batch_observed_mask = 0_u64;
        let mut omitted_rows = 0_u64;
        for row in 0..self.batch.rows() {
            let value = self.batch.row(row)[field_index];
            let Ok(value) = u32::try_from(value) else {
                omitted_rows = omitted_rows.saturating_add(1);
                continue;
            };
            if value >= 64 {
                omitted_rows = omitted_rows.saturating_add(1);
                continue;
            }
            let weight = self.batch.weights[row];
            let bin = &mut bins[value as usize];
            bin.0 = bin.0.saturating_add(1);
            bin.1 = bin.1.saturating_add(weight);
            if self.batch.expected(row) {
                bin.2 = bin.2.saturating_add(weight);
            } else {
                bin.3 = bin.3.saturating_add(weight);
            }
            batch_observed_mask |= 1_u64 << value;
        }
        let strata: Vec<Value> = bins
            .iter()
            .enumerate()
            .filter(|(_, bin)| bin.0 != 0)
            .map(
                |(value, &(rows, weight, positive_weight, negative_weight))| {
                    json!({
                        "value": value,
                        "rows": rows,
                        "weight": weight,
                        "positive_weight": positive_weight,
                        "negative_weight": negative_weight,
                    })
                },
            )
            .collect();
        let live_observed_mask = self.live_scope_masks.get(field).copied().unwrap_or(0);
        Ok(json!({
            "field": field,
            "observed_mask": batch_observed_mask | live_observed_mask,
            "batch_observed_mask": batch_observed_mask,
            "live_observed_mask": live_observed_mask,
            "omitted_rows": omitted_rows,
            "strata": strata,
        }))
    }

    fn synthesize_tree(&mut self, args: &Value) -> Result<Value, ControlError> {
        let max_nodes = args
            .get("max_nodes")
            .and_then(Value::as_u64)
            .unwrap_or(31)
            .clamp(1, 41) as usize;
        let max_depth = args
            .get("max_depth")
            .and_then(Value::as_u64)
            .unwrap_or(8)
            .clamp(1, 16) as usize;
        let training_filter = match (
            args.get("train_field").and_then(Value::as_str),
            args.get("train_value").and_then(Value::as_i64),
        ) {
            (None, None) => None,
            (Some(name), Some(value)) => Some((
                self.batch
                    .fields
                    .iter()
                    .position(|field| field == name)
                    .ok_or_else(|| ControlError::Invalid("unknown training field".into()))?,
                value,
            )),
            _ => {
                return Err(ControlError::Invalid(
                    "train_field and train_value must be supplied together".into(),
                ))
            }
        };
        let training_rows = training_filter.map_or(self.batch.rows(), |(field, value)| {
            (0..self.batch.rows())
                .filter(|&row| self.batch.row(row)[field] == value)
                .count()
        });
        let (spec, nodes, depth) =
            learn_decision_tree(&self.batch, max_nodes, max_depth, training_filter)?;
        let plan = CompiledPlan::compile(&spec, &self.batch.fields)?;
        let evaluation = evaluate_plan(&self.batch, &plan)?;
        let synopsis = format!(
            "tree {nodes} nodes, {} unavoidable errors",
            evaluation
                .weighted_rows
                .saturating_sub(evaluation.weighted_correct)
        );
        self.record("tree-synthesized", &synopsis, Some(spec.name.clone()))?;
        Ok(
            json!({"plan": spec, "nodes": nodes, "depth": depth, "training_rows": training_rows, "evaluation": evaluation}),
        )
    }

    fn candidate_try(&mut self, args: &Value, apply: bool) -> Result<Value, ControlError> {
        let spec_value = args
            .get("plan")
            .ok_or_else(|| ControlError::Invalid("missing plan".into()))?;
        let spec: PlanSpec = serde_json::from_value(spec_value.clone())?;
        let plan = CompiledPlan::compile(&spec, &self.batch.fields)?;
        let evaluation = evaluate_plan(&self.batch, &plan)?;
        let groups = args
            .get("group_by")
            .and_then(Value::as_str)
            .map(|field| self.grouped_evaluation(&plan, field))
            .transpose()?;
        let equivalent_to = self.archive.get(&evaluation.outcome_hash).cloned();
        if equivalent_to.is_none() && self.archive.len() < MAX_ARCHIVE_CLASSES {
            self.archive
                .insert(evaluation.outcome_hash.clone(), plan.name.clone());
        }
        let first = evaluation.first_mismatch;
        let obstruction = first.map(|row| self.batch.row_json(row));
        if !apply {
            let synopsis = match first {
                Some(row) => format!("first obstruction row {row}"),
                None => "no obstruction in frozen batch".into(),
            };
            self.record("candidate-tested", &synopsis, Some(plan.name.clone()))?;
            return Ok(
                json!({"plan": plan.name, "hash": plan.hash, "equivalent_to": equivalent_to, "evaluation": evaluation, "groups": groups, "first_obstruction": obstruction}),
            );
        }
        let expected_epoch = args
            .get("expect_epoch")
            .and_then(Value::as_u64)
            .ok_or_else(|| ControlError::Invalid("candidate-apply requires expect_epoch".into()))?;
        let old_epoch = self.epoch.load(Ordering::Acquire);
        if expected_epoch != old_epoch {
            return Err(ControlError::Invalid(format!(
                "stale epoch: expected {expected_epoch}, current {old_epoch}"
            )));
        }
        if self.plans.len() >= MAX_ACTIVE_PLANS
            || self
                .plans
                .iter()
                .any(|stored| stored.plan.name == plan.name)
        {
            return Err(ControlError::Invalid(
                "plan arena full or name already active".into(),
            ));
        }
        let name = plan.name.clone();
        let hash = plan.hash.clone();
        self.plans.push(StoredPlan {
            spec,
            plan,
            evaluation: evaluation.clone(),
        });
        let new_epoch = old_epoch + 1;
        self.epoch.store(new_epoch, Ordering::Release);
        self.notify_watchers(new_epoch);
        self.record(
            "candidate-applied",
            "diagnostic plan activated",
            Some(name.clone()),
        )?;
        Ok(
            json!({"plan": name, "hash": hash, "equivalent_to": equivalent_to, "old_epoch": old_epoch, "new_epoch": new_epoch, "evaluation": evaluation, "groups": groups, "first_obstruction": obstruction}),
        )
    }

    fn candidate_batch(&mut self, args: &Value) -> Result<Value, ControlError> {
        let plans = args
            .get("plans")
            .and_then(Value::as_array)
            .ok_or_else(|| ControlError::Invalid("candidate-batch requires plans".into()))?;
        if plans.is_empty() || plans.len() > MAX_CANDIDATE_BATCH {
            return Err(ControlError::Invalid(format!(
                "candidate-batch requires 1..={MAX_CANDIDATE_BATCH} plans"
            )));
        }
        let evidence_name = required_str(args, "evidence_name")?;
        if evidence_name.is_empty()
            || evidence_name.len() > 64
            || !evidence_name
                .bytes()
                .all(|byte| byte.is_ascii_alphanumeric() || matches!(byte, b'-' | b'_' | b'.'))
        {
            return Err(ControlError::Invalid(
                "candidate-batch evidence_name is not a safe slug".into(),
            ));
        }
        let retain = args
            .get("retain")
            .and_then(Value::as_u64)
            .unwrap_or(32)
            .clamp(1, 128) as usize;
        let byte_limit = args
            .get("max_evidence_bytes")
            .and_then(Value::as_u64)
            .unwrap_or(self.trace_limit)
            .min(self.trace_limit);
        let relative = PathBuf::from("evidence").join(format!("{evidence_name}.jsonl"));
        let file = OpenOptions::new()
            .write(true)
            .create_new(true)
            .mode(0o600)
            .open(self.manifest.run_dir.join(&relative))?;
        let mut writer = BufWriter::new(file);
        let mut bytes = 0_u64;
        let mut tested = 0_usize;
        let mut perfect = 0_usize;
        let mut truncated = false;
        let mut top: Vec<(u64, u64, String, Value)> = Vec::with_capacity(retain);
        for spec_value in plans {
            let spec: PlanSpec = serde_json::from_value(spec_value.clone())?;
            let plan = CompiledPlan::compile(&spec, &self.batch.fields)?;
            let evaluation = evaluate_plan(&self.batch, &plan)?;
            let equivalent_to = self.archive.get(&evaluation.outcome_hash).cloned();
            if equivalent_to.is_none() && self.archive.len() < MAX_ARCHIVE_CLASSES {
                self.archive
                    .insert(evaluation.outcome_hash.clone(), plan.name.clone());
            }
            let record = json!({
                "plan": &spec,
                "hash": &plan.hash,
                "equivalent_to": &equivalent_to,
                "evaluation": &evaluation,
            });
            let mut encoded = serde_json::to_vec(&record)?;
            encoded.push(b'\n');
            if bytes.saturating_add(encoded.len() as u64) > byte_limit {
                truncated = true;
                break;
            }
            writer.write_all(&encoded)?;
            bytes += encoded.len() as u64;
            tested += 1;
            if evaluation.weighted_correct == evaluation.weighted_rows {
                perfect += 1;
            }
            let compact = json!({
                "plan": &plan.name,
                "hash": &plan.hash,
                "weighted_correct": evaluation.weighted_correct,
                "weighted_rows": evaluation.weighted_rows,
                "false_positive": evaluation.weighted_false_positive,
                "false_negative": evaluation.weighted_false_negative,
                "outcome_hash": &evaluation.outcome_hash,
            });
            top.push((
                evaluation.weighted_correct,
                evaluation.weighted_false_positive,
                plan.name,
                compact,
            ));
            top.sort_unstable_by(|left, right| {
                right
                    .0
                    .cmp(&left.0)
                    .then_with(|| left.1.cmp(&right.1))
                    .then_with(|| left.2.cmp(&right.2))
            });
            top.truncate(retain);
        }
        writer.flush()?;
        let summaries: Vec<_> = top.into_iter().map(|entry| entry.3).collect();
        self.record(
            "candidate-batch-tested",
            &format!("tested {tested} candidates, retained {}", summaries.len()),
            None,
        )?;
        Ok(json!({
            "requested": plans.len(),
            "tested": tested,
            "perfect": perfect,
            "truncated": truncated,
            "path": relative,
            "bytes": bytes,
            "top": summaries,
        }))
    }

    fn reap_evolution(&mut self) -> Result<(), ControlError> {
        if !self
            .evolution
            .as_ref()
            .is_some_and(|job| job.handle.is_finished())
        {
            return Ok(());
        }
        let job = self.evolution.take().unwrap();
        let id = job.id;
        let path = job.relative_path;
        let completed = match job.handle.join() {
            Ok(Ok(summary)) => {
                json!({"id": id, "path": path, "state": "complete", "summary": summary})
            }
            Ok(Err(error)) => {
                json!({"id": id, "path": path, "state": "failed", "error": error.to_string()})
            }
            Err(_) => json!({
                "id": id,
                "path": path,
                "state": "failed",
                "error": "evolution worker panicked",
            }),
        };
        let synopsis = format!(
            "evolution {}",
            completed["state"].as_str().unwrap_or("failed")
        );
        self.last_evolution = Some(completed);
        self.record("evolution-finished", &synopsis, None)?;
        Ok(())
    }

    fn evolution_start(&mut self, args: &Value) -> Result<Value, ControlError> {
        self.reap_evolution()?;
        if self.evolution.is_some() {
            return Err(ControlError::Invalid(
                "an evolution job is already active".into(),
            ));
        }
        let seeds = match args.get("seeds") {
            None | Some(Value::Null) => None,
            Some(value) => Some(value.as_array().ok_or_else(|| {
                ControlError::Invalid("evolve-start seeds must be an array".into())
            })?),
        };
        if seeds.is_some_and(|seeds| seeds.len() > 32) {
            return Err(ControlError::Invalid(
                "evolve-start accepts at most 32 direct seeds".into(),
            ));
        }
        let mut lowered = Vec::with_capacity(32);
        let mut seed_hashes = BTreeSet::new();
        for seed in seeds.into_iter().flatten() {
            let spec: PlanSpec = serde_json::from_value(seed.clone())?;
            if spec.output != PlanOutput::Predicate {
                return Err(ControlError::Invalid(
                    "evolve-start accepts predicate seeds only".into(),
                ));
            }
            let compiled = CompiledPlan::compile(&spec, &self.batch.fields)?;
            if !seed_hashes.insert(compiled.hash) {
                return Err(ControlError::Invalid(
                    "evolve-start contains duplicate direct seeds".into(),
                ));
            }
            lowered.push(EvolutionSeed {
                plan: spec,
                parent_hash: None,
                source_hash: None,
                source_evidence: None,
                operator: "seed",
            });
        }
        let direct_seeds = lowered.len();
        let identity = EvolutionIdentity {
            code_commit: self.manifest.code_commit.clone(),
            presentation_hash: self.manifest.presentation_hash.clone(),
            presentation: self.batch.presentation.clone(),
            problem: self.batch.problem.clone(),
            fields: self.batch.fields.clone(),
            generator: self.batch.generator.clone(),
        };
        let resume = match args.get("resume_evidence") {
            None | Some(Value::Null) => None,
            Some(value) => Some(value.as_array().ok_or_else(|| {
                ControlError::Invalid("evolve-start resume_evidence must be an array".into())
            })?),
        };
        if resume.is_some_and(|paths| paths.len() > 8) {
            return Err(ControlError::Invalid(
                "evolve-start accepts at most eight replay archives".into(),
            ));
        }
        let resume_paths = resume
            .into_iter()
            .flatten()
            .map(|path| {
                path.as_str()
                    .ok_or_else(|| {
                        ControlError::Invalid("resume_evidence entries must be paths".into())
                    })
                    .and_then(|path| absolute_path(Path::new(path)))
            })
            .collect::<Result<Vec<_>, _>>()?;
        let replay_capacity = 32_usize.saturating_sub(lowered.len());
        if replay_capacity == 0 && !resume_paths.is_empty() {
            return Err(ControlError::Invalid(
                "evolve-start has no capacity for replay archives".into(),
            ));
        }
        let mut replay_archives = resume_paths
            .iter()
            .map(|path| load_evolution_seeds(path, &identity, replay_capacity).map(Vec::into_iter))
            .collect::<Result<Vec<_>, _>>()?;
        while lowered.len() < 32 {
            let mut observed = false;
            for archive in &mut replay_archives {
                for seed in archive.by_ref() {
                    observed = true;
                    let hash = seed.source_hash.as_ref().ok_or_else(|| {
                        ControlError::Invalid(
                            "replayed evolution seed omits its verified plan hash".into(),
                        )
                    })?;
                    if seed_hashes.insert(hash.clone()) {
                        lowered.push(seed);
                        break;
                    }
                }
                if lowered.len() == 32 {
                    break;
                }
            }
            if !observed {
                break;
            }
        }
        let replayed_seeds = lowered.len() - direct_seeds;
        if lowered.is_empty() {
            return Err(ControlError::Invalid(
                "evolve-start requires a direct or replayed seed".into(),
            ));
        }
        for seed in &lowered[direct_seeds..] {
            if seed.plan.output != PlanOutput::Predicate {
                return Err(ControlError::Invalid(
                    "replayed evolution evidence contains a non-predicate plan".into(),
                ));
            }
            CompiledPlan::compile(&seed.plan, &self.batch.fields)?;
        }
        let generations = args.get("generations").and_then(Value::as_u64).unwrap_or(3) as usize;
        let beam = args.get("beam").and_then(Value::as_u64).unwrap_or(16) as usize;
        let max_candidates = args
            .get("max_candidates")
            .and_then(Value::as_u64)
            .unwrap_or(1_000) as usize;
        if !(1..=32).contains(&generations)
            || !(1..=256).contains(&beam)
            || !(1..=100_000).contains(&max_candidates)
        {
            return Err(ControlError::Invalid(
                "invalid evolution generations, beam, or candidate bound".into(),
            ));
        }
        let evidence_name = required_str(args, "evidence_name")?;
        if evidence_name.is_empty()
            || evidence_name.len() > 64
            || !evidence_name
                .bytes()
                .all(|byte| byte.is_ascii_alphanumeric() || matches!(byte, b'-' | b'_' | b'.'))
        {
            return Err(ControlError::Invalid(
                "evolve-start evidence_name is not a safe slug".into(),
            ));
        }
        let byte_limit = args
            .get("max_evidence_bytes")
            .and_then(Value::as_u64)
            .unwrap_or(self.trace_limit)
            .min(self.trace_limit);
        if byte_limit == 0 {
            return Err(ControlError::Invalid(
                "evolution evidence limit must be positive".into(),
            ));
        }
        let id = random_hex(12)?;
        let relative_path = PathBuf::from("evidence").join(format!("{evidence_name}-{id}.jsonl"));
        let output = OpenOptions::new()
            .write(true)
            .create_new(true)
            .mode(0o600)
            .open(self.manifest.run_dir.join(&relative_path))?;
        let progress = Arc::new(EvolutionProgress::new());
        let worker_progress = Arc::clone(&progress);
        let batch = Arc::clone(&self.batch);
        let bounds = EvolutionBounds {
            generations,
            beam,
            max_candidates,
            byte_limit,
        };
        let handle = thread::Builder::new()
            .name(format!("ergodis-evolve-{}", &id[..8]))
            .spawn(move || {
                run_evolution(batch, identity, lowered, output, bounds, worker_progress)
            })?;
        self.evolution = Some(EvolutionJob {
            id: id.clone(),
            relative_path: relative_path.clone(),
            progress,
            handle,
        });
        self.last_evolution = None;
        self.record("evolution-started", "low-priority evolution started", None)?;
        Ok(json!({
            "id": id,
            "path": relative_path,
            "state": "running",
            "generations": generations,
            "beam": beam,
            "max_candidates": max_candidates,
            "max_evidence_bytes": byte_limit,
            "direct_seeds": direct_seeds,
            "replayed_seeds": replayed_seeds,
        }))
    }

    fn evolution_status(&mut self) -> Result<Value, ControlError> {
        self.reap_evolution()?;
        if let Some(job) = &self.evolution {
            return Ok(json!({
                "id": job.id,
                "path": job.relative_path,
                "state": "running",
                "progress": job.progress.snapshot(),
            }));
        }
        Ok(self
            .last_evolution
            .clone()
            .unwrap_or_else(|| json!({"state": "idle"})))
    }

    fn evolution_cancel(&mut self) -> Result<Value, ControlError> {
        self.reap_evolution()?;
        let Some(job) = &self.evolution else {
            return Ok(json!({"state": "idle", "cancel_requested": false}));
        };
        job.progress.cancel();
        Ok(json!({
            "id": job.id,
            "state": "running",
            "cancel_requested": true,
        }))
    }

    fn candidate_deactivate(&mut self, args: &Value) -> Result<Value, ControlError> {
        let expected_epoch = args
            .get("expect_epoch")
            .and_then(Value::as_u64)
            .ok_or_else(|| {
                ControlError::Invalid("candidate-deactivate requires expect_epoch".into())
            })?;
        let old_epoch = self.epoch.load(Ordering::Acquire);
        if expected_epoch != old_epoch {
            return Err(ControlError::Invalid(format!(
                "stale epoch: expected {expected_epoch}, current {old_epoch}"
            )));
        }
        let name = args
            .get("plan")
            .and_then(Value::as_str)
            .ok_or_else(|| ControlError::Invalid("candidate-deactivate requires plan".into()))?;
        let index = self
            .plans
            .iter()
            .position(|stored| stored.plan.name == name)
            .ok_or_else(|| ControlError::Invalid("unknown active plan".into()))?;
        self.plans.remove(index);
        let new_epoch = old_epoch + 1;
        self.epoch.store(new_epoch, Ordering::Release);
        self.notify_watchers(new_epoch);
        self.record(
            "candidate-deactivated",
            "diagnostic plan deactivated",
            Some(name.into()),
        )?;
        Ok(json!({"plan": name, "old_epoch": old_epoch, "new_epoch": new_epoch}))
    }

    fn grouped_evaluation(
        &self,
        plan: &CompiledPlan,
        field_name: &str,
    ) -> Result<Value, ControlError> {
        let field = self
            .batch
            .fields
            .iter()
            .position(|field| field == field_name)
            .ok_or_else(|| ControlError::Invalid("unknown group_by field".into()))?;
        let mut groups: BTreeMap<i64, [u64; 6]> = BTreeMap::new();
        for row in 0..self.batch.rows() {
            let value = self.batch.row(row)[field];
            if !groups.contains_key(&value) && groups.len() == 256 {
                return Err(ControlError::Invalid(
                    "group_by produces more than 256 groups".into(),
                ));
            }
            let counts = groups.entry(value).or_default();
            let observed = plan.evaluate_value_untraced(self.batch.row(row))? != 0;
            let expected = self.batch.expected(row);
            let weight = self.batch.weights[row];
            counts[0] += 1;
            counts[1] = counts[1].saturating_add(weight);
            if observed == expected {
                counts[2] = counts[2].saturating_add(weight);
            } else if observed {
                counts[3] = counts[3].saturating_add(weight);
            } else {
                counts[4] = counts[4].saturating_add(weight);
            }
            if observed {
                counts[5] = counts[5].saturating_add(weight);
            }
        }
        let groups: Vec<_> = groups
            .into_iter()
            .map(|(value, counts)| {
                json!({
                    "value": value,
                    "rows": counts[0],
                    "weighted_rows": counts[1],
                    "weighted_correct": counts[2],
                    "weighted_false_positive": counts[3],
                    "weighted_false_negative": counts[4],
                    "weighted_true": counts[5],
                })
            })
            .collect();
        Ok(json!({"field": field_name, "groups": groups}))
    }

    fn obstruction(&self, args: &Value) -> Result<Value, ControlError> {
        let name = required_str(args, "plan")?;
        let stored = self
            .plans
            .iter()
            .find(|stored| stored.plan.name == name)
            .ok_or_else(|| ControlError::Invalid("unknown active plan".into()))?;
        let row = stored.evaluation.first_mismatch;
        Ok(match row {
            Some(row) => json!({"plan": name, "obstruction": self.batch.row_json(row)}),
            None => json!({"plan": name, "obstruction": null}),
        })
    }

    fn exceptional(&mut self, args: &Value) -> Result<Value, ControlError> {
        let name = required_str(args, "plan")?;
        let top = args
            .get("top")
            .and_then(Value::as_u64)
            .unwrap_or(8)
            .clamp(1, 32) as usize;
        let high = match args
            .get("direction")
            .and_then(Value::as_str)
            .unwrap_or("high")
        {
            "high" => true,
            "low" => false,
            _ => {
                return Err(ControlError::Invalid(
                    "exceptional direction must be high or low".into(),
                ))
            }
        };
        let stored = self
            .plans
            .iter()
            .find(|stored| stored.plan.name == name)
            .ok_or_else(|| ControlError::Invalid("unknown active plan".into()))?;
        let mut selected: Vec<(i64, usize)> = Vec::with_capacity(top);
        for row in 0..self.batch.rows() {
            let score = stored.plan.evaluate_value_untraced(self.batch.row(row))?;
            let position = selected
                .iter()
                .position(|&(other, other_row)| {
                    if high {
                        score > other || (score == other && row < other_row)
                    } else {
                        score < other || (score == other && row < other_row)
                    }
                })
                .unwrap_or(selected.len());
            if position < top {
                selected.insert(position, (score, row));
                if selected.len() > top {
                    selected.pop();
                }
            }
        }
        let rows: Vec<_> = selected
            .iter()
            .map(|&(score, row)| json!({"score": score, "state": self.batch.row_json(row)}))
            .collect();
        let synopsis = selected.first().map_or_else(
            || "no exceptional state".into(),
            |&(score, row)| format!("top exceptional row {row}, score {score}"),
        );
        self.record("exceptional-query", &synopsis, Some(name.into()))?;
        Ok(json!({
            "plan": name,
            "direction": if high { "high" } else { "low" },
            "top": rows,
            "examined": self.batch.rows(),
        }))
    }

    fn trace(&mut self, args: &Value) -> Result<Value, ControlError> {
        let name = required_str(args, "plan")?;
        let row = args
            .get("row")
            .and_then(Value::as_u64)
            .ok_or_else(|| ControlError::Invalid("missing row".into()))? as usize;
        let max_records = args
            .get("max_records")
            .and_then(Value::as_u64)
            .unwrap_or(128)
            .min(MAX_PLAN_OPS as u64) as usize;
        if row >= self.batch.rows() {
            return Err(ControlError::Invalid("trace row out of range".into()));
        }
        let stored = self
            .plans
            .iter()
            .find(|stored| stored.plan.name == name)
            .ok_or_else(|| ControlError::Invalid("unknown active plan".into()))?;
        let mut values = Vec::with_capacity(stored.plan.op_count().min(max_records));
        let observed = stored
            .plan
            .evaluate_value(self.batch.row(row), Some(&mut values))?;
        let truncated = stored.plan.op_count() > max_records;
        values.truncate(max_records);
        let trace = json!({
            "schema": SCHEMA,
            "run_id": self.manifest.run_id,
            "plan": name,
            "plan_hash": stored.plan.hash,
            "row": self.batch.row_json(row),
            "observed": observed,
            "op_results": values,
            "truncated": truncated,
        });
        let (hash, bytes) = json_hash_and_len(&trace)?;
        if bytes > self.trace_limit {
            return Err(ControlError::Invalid(
                "trace exceeds configured file limit".into(),
            ));
        }
        let hash = hash.to_hex().to_string();
        let relative = PathBuf::from("evidence").join(format!("trace-{}.json", &hash[..20]));
        write_create_json_compact(&self.manifest.run_dir.join(&relative), &trace)?;
        self.record(
            "trace-written",
            "localized trace captured",
            Some(name.into()),
        )?;
        Ok(
            json!({"path": relative, "hash": hash, "bytes": bytes, "records": values.len(), "truncated": truncated}),
        )
    }

    fn note(&mut self, args: &Value) -> Result<Value, ControlError> {
        let text = required_str(args, "text")?;
        if text.len() > 512 || text.contains('\n') {
            return Err(ControlError::Invalid(
                "note must be one line of at most 512 bytes".into(),
            ));
        }
        self.record("note", text, None)?;
        Ok(json!({"event": self.seq}))
    }

    fn record(
        &mut self,
        kind: &str,
        synopsis: &str,
        plan: Option<String>,
    ) -> Result<(), ControlError> {
        self.seq += 1;
        let event = Event {
            seq: self.seq,
            epoch: self.epoch.load(Ordering::Relaxed),
            kind: kind.into(),
            synopsis: synopsis.into(),
            plan,
        };
        self.ledger.append(&event)?;
        if self.events.len() == EVENT_RING {
            self.events.pop_front();
        }
        self.events.push_back(event);
        Ok(())
    }

    fn success_response(&self, request_id: u64, result: Value) -> Response {
        Response {
            schema: SCHEMA.into(),
            request_id,
            run_id: self.manifest.run_id.clone(),
            epoch: self.epoch.load(Ordering::Acquire),
            ok: true,
            result,
        }
    }

    fn error_response(&self, request_id: u64, message: impl Into<String>) -> Response {
        Response {
            schema: SCHEMA.into(),
            request_id,
            run_id: self.manifest.run_id.clone(),
            epoch: self.epoch.load(Ordering::Acquire),
            ok: false,
            result: json!({"error": message.into()}),
        }
    }
}

pub fn send_request(
    manifest: &Manifest,
    op: &str,
    args: Value,
    max_bytes: usize,
) -> Result<Response, ControlError> {
    let request = Request {
        schema: SCHEMA.into(),
        request_id: next_client_request_id(),
        run_id: manifest.run_id.clone(),
        nonce: manifest.nonce.clone(),
        max_bytes: max_bytes.min(MAX_FRAME_BYTES),
        op: op.into(),
        args,
    };
    let encoded = serde_json::to_vec(&request)?;
    let mut stream = UnixStream::connect(&manifest.socket)?;
    stream.set_read_timeout(Some(SOCKET_IO_TIMEOUT))?;
    stream.set_write_timeout(Some(SOCKET_IO_TIMEOUT))?;
    write_frame(&mut stream, &encoded)?;
    let response = read_frame(&mut stream)?;
    let response: Response = serde_json::from_slice(&response)?;
    if response.schema != SCHEMA
        || response.request_id != request.request_id
        || response.run_id != manifest.run_id
    {
        return Err(ControlError::Invalid("response handshake rejected".into()));
    }
    Ok(response)
}

fn next_client_request_id() -> u64 {
    loop {
        let sequence = NEXT_CLIENT_REQUEST_ID.fetch_add(1, Ordering::Relaxed) as u32;
        if sequence != 0 {
            return (u64::from(std::process::id()) << 32) | u64::from(sequence);
        }
    }
}

pub fn read_manifest(run_dir: &Path) -> Result<Manifest, ControlError> {
    let file = File::open(run_dir.join("manifest.json"))?;
    let capacity = file.metadata()?.len().min(MAX_FRAME_BYTES as u64) as usize;
    let mut encoded = Vec::with_capacity(capacity);
    file.take(MAX_FRAME_BYTES as u64 + 1)
        .read_to_end(&mut encoded)?;
    if encoded.len() > MAX_FRAME_BYTES {
        return Err(ControlError::Invalid(
            "manifest exceeds protocol frame bound".into(),
        ));
    }
    let manifest: Manifest = serde_json::from_slice(&encoded)?;
    if manifest.schema != SCHEMA {
        return Err(ControlError::Invalid("unsupported manifest schema".into()));
    }
    Ok(manifest)
}

fn required_str<'a>(value: &'a Value, key: &str) -> Result<&'a str, ControlError> {
    value
        .get(key)
        .and_then(Value::as_str)
        .ok_or_else(|| ControlError::Invalid(format!("missing {key}")))
}

fn random_hex(bytes: usize) -> Result<String, ControlError> {
    const HEX: &[u8; 16] = b"0123456789abcdef";
    let mut random = vec![0u8; bytes];
    File::open("/dev/urandom")?.read_exact(&mut random)?;
    let mut encoded = String::with_capacity(bytes.saturating_mul(2));
    for byte in random {
        encoded.push(HEX[(byte >> 4) as usize] as char);
        encoded.push(HEX[(byte & 0x0f) as usize] as char);
    }
    Ok(encoded)
}

fn absolute_path(path: &Path) -> Result<PathBuf, ControlError> {
    if path.is_absolute() {
        Ok(path.to_path_buf())
    } else {
        Ok(std::env::current_dir()?.join(path))
    }
}

fn default_socket(run_id: &str, nonce: &str) -> Result<PathBuf, ControlError> {
    let runtime = std::env::var_os("XDG_RUNTIME_DIR").ok_or_else(|| {
        ControlError::Invalid("XDG_RUNTIME_DIR is unavailable; provide --socket".into())
    })?;
    absolute_path(
        &PathBuf::from(runtime)
            .join("ergodis")
            .join(unsafe { libc_uid() }.to_string())
            .join(format!("{}-{}.sock", &run_id[..12], &nonce[..12])),
    )
}

#[cfg(unix)]
unsafe fn libc_uid() -> u32 {
    // SAFETY: getuid has no preconditions and no memory effects.
    unsafe extern "C" {
        fn getuid() -> u32;
    }
    unsafe { getuid() }
}

fn hash_file(path: &Path) -> Result<String, ControlError> {
    let mut reader = BufReader::new(File::open(path)?);
    let mut hasher = blake3::Hasher::new();
    let mut buffer = [0u8; 64 * 1024];
    loop {
        let count = reader.read(&mut buffer)?;
        if count == 0 {
            break;
        }
        hasher.update(&buffer[..count]);
    }
    Ok(hasher.finalize().to_hex().to_string())
}

fn write_create_json(path: &Path, value: &impl Serialize) -> Result<(), ControlError> {
    let mut file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .open(path)?;
    serde_json::to_writer_pretty(&mut file, value)?;
    file.write_all(b"\n")?;
    Ok(())
}

struct HashCounter {
    hasher: blake3::Hasher,
    bytes: u64,
}

impl Write for HashCounter {
    fn write(&mut self, buffer: &[u8]) -> io::Result<usize> {
        self.hasher.update(buffer);
        self.bytes = self.bytes.saturating_add(buffer.len() as u64);
        Ok(buffer.len())
    }

    fn flush(&mut self) -> io::Result<()> {
        Ok(())
    }
}

fn json_hash_and_len(
    value: &(impl Serialize + ?Sized),
) -> Result<(blake3::Hash, u64), ControlError> {
    let mut counter = HashCounter {
        hasher: blake3::Hasher::new(),
        bytes: 0,
    };
    serde_json::to_writer(&mut counter, value)?;
    Ok((counter.hasher.finalize(), counter.bytes))
}

fn write_create_json_compact(
    path: &Path,
    value: &(impl Serialize + ?Sized),
) -> Result<(), ControlError> {
    let file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .open(path)?;
    let mut writer = BufWriter::new(file);
    serde_json::to_writer(&mut writer, value)?;
    writer.write_all(b"\n")?;
    writer.flush()?;
    Ok(())
}

fn write_frame(stream: &mut UnixStream, bytes: &[u8]) -> Result<(), ControlError> {
    if bytes.len() > MAX_FRAME_BYTES {
        return Err(ControlError::Invalid("frame exceeds limit".into()));
    }
    stream.write_all(&(bytes.len() as u32).to_le_bytes())?;
    stream.write_all(bytes)?;
    Ok(())
}

fn read_frame(stream: &mut UnixStream) -> Result<Vec<u8>, ControlError> {
    let mut prefix = [0u8; 4];
    stream.read_exact(&mut prefix)?;
    let length = u32::from_le_bytes(prefix) as usize;
    if length > MAX_FRAME_BYTES {
        return Err(ControlError::Invalid("frame exceeds limit".into()));
    }
    let mut bytes = vec![0u8; length];
    stream.read_exact(&mut bytes)?;
    Ok(bytes)
}

fn write_response(
    stream: &mut UnixStream,
    response: Response,
    max_bytes: usize,
) -> Result<(), ControlError> {
    let bytes = serde_json::to_vec(&response)?;
    if bytes.len() > max_bytes {
        return Err(ControlError::Invalid("response exceeds limit".into()));
    }
    write_frame(stream, &bytes)
}

#[cfg(test)]
mod tests {
    use super::vm::evaluate_plan_cascaded;
    use super::*;
    use crate::multiset::{MultisetBounds, MultisetStatistic};
    use std::thread;
    use std::time::Duration;

    fn batch() -> FeatureBatch {
        FeatureBatch {
            presentation: "tiny".into(),
            problem: "fixture".into(),
            fields: vec!["surplus".into(), "drop".into()].into_boxed_slice(),
            generator: None,
            row_ids: vec![7, 8].into_boxed_slice(),
            weights: vec![2, 3].into_boxed_slice(),
            expected: vec![0b11].into_boxed_slice(),
            values: vec![0, 6, 18, 0].into_boxed_slice(),
        }
    }

    #[test]
    fn postfix_plan_finds_no_obstruction_for_disjunctive_descent() {
        let spec = PlanSpec {
            schema: PLAN_SCHEMA.into(),
            name: "support-or-omega".into(),
            role: PlanRole::Diagnostic,
            output: PlanOutput::Predicate,
            scope: None,
            program: vec![
                PlanOp::Field {
                    name: "surplus".into(),
                },
                PlanOp::Const { value: 0 },
                PlanOp::Gt,
                PlanOp::Field {
                    name: "drop".into(),
                },
                PlanOp::Const { value: 0 },
                PlanOp::Gt,
                PlanOp::Or,
            ],
        };
        let batch = batch();
        let plan = CompiledPlan::compile(&spec, &batch.fields).unwrap();
        let result = evaluate_plan(&batch, &plan).unwrap();
        assert_eq!(result.weighted_correct, 5);
        assert_eq!(result.first_false, None);
    }

    #[test]
    fn synthesized_boolean_tree_compiles_and_matches_training_rows() {
        let batch = FeatureBatch {
            presentation: "tree".into(),
            problem: "threshold".into(),
            fields: vec!["x".into()].into_boxed_slice(),
            generator: None,
            row_ids: vec![0, 1, 2, 3].into_boxed_slice(),
            weights: vec![1; 4].into_boxed_slice(),
            expected: vec![0b1100].into_boxed_slice(),
            values: vec![0, 1, 2, 3].into_boxed_slice(),
        };
        let (spec, nodes, _) = learn_decision_tree(&batch, 7, 3, None).unwrap();
        assert!(nodes >= 3);
        assert_eq!(spec.output, PlanOutput::Predicate);
        let plan = CompiledPlan::compile(&spec, &batch.fields).unwrap();
        let result = evaluate_plan(&batch, &plan).unwrap();
        assert_eq!(result.weighted_correct, 4);
        assert_eq!(result.first_mismatch, None);
    }

    #[test]
    fn grouped_compilation_exposes_a_multiset_sum_without_key_leakage() {
        let mut values = Vec::new();
        let mut row_ids = Vec::new();
        let mut expected = 0_u64;
        for (group, contributions, label) in [
            (10_i64, [1_i64; 7], false),
            (20, [2; 7], true),
            (30, [1, 1, 2, 2, 2, 2, 2], true),
        ] {
            for contribution in contributions {
                let row = row_ids.len();
                row_ids.push(row as u64);
                values.extend_from_slice(&[group, contribution]);
                if label {
                    expected |= 1_u64 << row;
                }
            }
        }
        let children = FeatureBatch {
            presentation: "residual-children".into(),
            problem: "group-relation".into(),
            fields: vec!["parent".into(), "degree".into()].into_boxed_slice(),
            generator: None,
            row_ids: row_ids.into_boxed_slice(),
            weights: vec![1; 21].into_boxed_slice(),
            expected: vec![expected].into_boxed_slice(),
            values: values.into_boxed_slice(),
        };
        let parents = children
            .aggregate_uniform_groups(
                0,
                &[
                    MultisetStatistic::Count,
                    MultisetStatistic::Sum { field: 1 },
                    MultisetStatistic::Minimum { field: 1 },
                ],
                MultisetBounds {
                    max_rows: 64,
                    max_groups: 8,
                    max_output_cells: 32,
                },
            )
            .unwrap();
        assert_eq!(
            &*parents.fields,
            &["group-count", "group-sum:degree", "group-min:degree"]
        );
        assert_eq!(parents.rows(), 3);
        assert_eq!(parents.row(0), &[7, 7, 1]);
        assert_eq!(parents.row(1), &[7, 14, 2]);
        assert_eq!(parents.row(2), &[7, 12, 1]);
        let (spec, _, _) = learn_decision_tree(&parents, 7, 3, None).unwrap();
        let plan = CompiledPlan::compile(&spec, &parents.fields).unwrap();
        let result = evaluate_plan(&parents, &plan).unwrap();
        assert_eq!(result.weighted_correct, 3);
        assert_eq!(result.first_mismatch, None);
    }

    #[test]
    fn exact_cascade_stops_only_after_beam_entry_is_impossible() {
        let batch = FeatureBatch {
            presentation: "cascade".into(),
            problem: "all-positive".into(),
            fields: vec!["x".into()].into_boxed_slice(),
            generator: None,
            row_ids: (0..128).collect::<Vec<_>>().into_boxed_slice(),
            weights: vec![1; 128].into_boxed_slice(),
            expected: vec![u64::MAX; 2].into_boxed_slice(),
            values: vec![0; 128].into_boxed_slice(),
        };
        let spec = PlanSpec {
            schema: PLAN_SCHEMA.into(),
            name: "always-false".into(),
            role: PlanRole::Diagnostic,
            output: PlanOutput::Predicate,
            scope: None,
            program: vec![PlanOp::Bool { value: false }],
        };
        let plan = CompiledPlan::compile(&spec, &batch.fields).unwrap();
        let gate = |false_positive, maximum_correct| false_positive == 0 && maximum_correct >= 128;
        let (evaluation, rows) = evaluate_plan_cascaded(&batch, &plan, Some(&gate)).unwrap();
        assert!(evaluation.is_none());
        assert_eq!(rows, 64);
        let (evaluation, rows) = evaluate_plan_cascaded(&batch, &plan, None).unwrap();
        assert_eq!(rows, 128);
        assert_eq!(evaluation.unwrap().weighted_correct, 0);
    }

    #[test]
    fn language_neutral_binding_fixture_is_exact() {
        let fixture: Value = serde_json::from_str(include_str!(
            "../../tests/fixtures/control_protocol_v0.json"
        ))
        .unwrap();
        let request_json = fixture["request_json"].as_str().unwrap();
        let request: Request = serde_json::from_str(request_json).unwrap();
        assert_eq!(request.schema, SCHEMA);
        assert_eq!(request.request_id, 7);
        assert_eq!(serde_json::to_string(&request).unwrap(), request_json);

        let response_json = fixture["response_json"].as_str().unwrap();
        let response: Response = serde_json::from_str(response_json).unwrap();
        assert_eq!(response.schema, SCHEMA);
        assert_eq!(response.request_id, 7);
        assert_eq!(serde_json::to_string(&response).unwrap(), response_json);
    }

    #[test]
    fn rust_client_request_ids_are_nonzero_and_monotone() {
        let first = next_client_request_id();
        let second = next_client_request_id();
        assert_ne!(first, 0);
        assert!(second > first);
    }

    #[test]
    fn manifested_paths_are_absolute_without_requiring_the_target_to_exist() {
        let relative = Path::new("future-campaign.sock");
        assert_eq!(
            absolute_path(relative).unwrap(),
            std::env::current_dir().unwrap().join(relative)
        );
        let absolute = std::env::temp_dir().join("ergodis-absolute.sock");
        assert_eq!(absolute_path(&absolute).unwrap(), absolute);
    }

    #[test]
    fn random_handshake_material_is_exact_lower_hex() {
        let encoded = random_hex(16).unwrap();
        assert_eq!(encoded.len(), 32);
        assert!(encoded
            .bytes()
            .all(|byte| byte.is_ascii_digit() || (b'a'..=b'f').contains(&byte)));
    }

    #[test]
    fn rust_manifest_ingestion_is_bounded_before_json_parsing() {
        let temporary = tempfile::tempdir().unwrap();
        fs::write(
            temporary.path().join("manifest.json"),
            vec![b' '; MAX_FRAME_BYTES + 1],
        )
        .unwrap();
        assert!(matches!(
            read_manifest(temporary.path()),
            Err(ControlError::Invalid(message))
                if message == "manifest exceeds protocol frame bound"
        ));
        fs::write(
            temporary.path().join("manifest.json"),
            serde_json::to_vec(&Manifest {
                schema: "future".into(),
                run_id: "run".into(),
                nonce: "nonce".into(),
                socket: temporary.path().join("campaign.sock"),
                run_dir: temporary.path().to_path_buf(),
                pid: 1,
                code_commit: "test".into(),
                presentation_hash: "hash".into(),
                problem: "fixture".into(),
                feature_generator: None,
            })
            .unwrap(),
        )
        .unwrap();
        assert!(matches!(
            read_manifest(temporary.path()),
            Err(ControlError::Invalid(message)) if message == "unsupported manifest schema"
        ));
    }

    #[test]
    fn evidence_hashing_streams_the_exact_compact_payload() {
        let value = json!({"rows": [1, 2, 3], "status": "finite-certified"});
        let expected = serde_json::to_vec(&value).unwrap();
        let (hash, bytes) = json_hash_and_len(&value).unwrap();
        assert_eq!(bytes, expected.len() as u64);
        assert_eq!(hash, blake3::hash(&expected));

        let temporary = tempfile::tempdir().unwrap();
        let path = temporary.path().join("evidence.json");
        write_create_json_compact(&path, &value).unwrap();
        let mut expected_file = expected;
        expected_file.push(b'\n');
        assert_eq!(fs::read(path).unwrap(), expected_file);
    }

    #[test]
    fn expression_plan_lowers_to_the_same_validated_program() {
        let document: PlanDocument = serde_json::from_value(json!({
            "schema": PLAN_SCHEMA,
            "name": "support-or-omega",
            "role": "diagnostic",
            "expr": {
                "op": "or",
                "left": {
                    "op": "gt",
                    "left": {"op": "field", "name": "surplus"},
                    "right": {"op": "const", "value": 0}
                },
                "right": {
                    "op": "gt",
                    "left": {"op": "field", "name": "drop"},
                    "right": {"op": "const", "value": 0}
                }
            }
        }))
        .unwrap();
        let lowered = document.lower().unwrap();
        let batch = batch();
        let plan = CompiledPlan::compile(&lowered, &batch.fields).unwrap();
        let result = evaluate_plan(&batch, &plan).unwrap();
        assert_eq!(result.weighted_correct, 5);
        assert_eq!(result.first_false, None);
        assert_eq!(lowered.program.len(), 7);

        let mut renamed = lowered;
        renamed.name = "same-executable-different-label".into();
        let renamed_plan = CompiledPlan::compile(&renamed, &batch.fields).unwrap();
        assert_eq!(plan.hash, renamed_plan.hash);
    }

    #[test]
    fn malformed_postfix_program_fails_closed() {
        let mut spec = PlanSpec {
            schema: PLAN_SCHEMA.into(),
            name: "bad".into(),
            role: PlanRole::Diagnostic,
            output: PlanOutput::Predicate,
            scope: None,
            program: vec![PlanOp::And],
        };
        assert!(CompiledPlan::compile(&spec, &batch().fields).is_err());
        spec.program = vec![PlanOp::Const { value: 1 }, PlanOp::Const { value: 2 }];
        assert!(CompiledPlan::compile(&spec, &batch().fields).is_err());
        spec.program = vec![PlanOp::Const { value: 1 }, PlanOp::Not];
        assert!(CompiledPlan::compile(&spec, &batch().fields).is_err());
        spec.program = vec![PlanOp::Const { value: 1 }];
        assert!(CompiledPlan::compile(&spec, &batch().fields).is_err());
    }

    #[test]
    fn compiled_scope_mask_skips_vm_outside_selected_contexts() {
        let fields = vec!["root_candidate".into(), "score".into()];
        let scoped = PlanSpec {
            schema: PLAN_SCHEMA.into(),
            name: "root-six".into(),
            role: PlanRole::Ordering,
            output: PlanOutput::Score,
            scope: Some(PlanScope {
                field: "root_candidate".into(),
                mask: 1 << 6,
            }),
            program: vec![PlanOp::Field {
                name: "score".into(),
            }],
        };
        let plan = CompiledPlan::compile(&scoped, &fields).unwrap();
        assert_eq!(plan.evaluate_row(&[6, 17]).unwrap(), 17);
        assert_eq!(plan.evaluate_row(&[5, 17]).unwrap(), 0);
        assert!(plan.applies(&[6, 17]));
        assert!(!plan.applies(&[5, 17]));

        let mut unscoped = scoped;
        unscoped.scope = None;
        let unscoped = CompiledPlan::compile(&unscoped, &fields).unwrap();
        assert_ne!(plan.hash, unscoped.hash);
    }

    #[test]
    fn scope_profile_combines_frozen_and_live_strata() {
        let temporary = tempfile::tempdir().unwrap();
        let data = temporary.path().join("data.jsonl");
        fs::write(
            &data,
            concat!(
                "{\"schema\":\"ergodis-campaign-data-v0\",\"presentation\":\"roots\",\"problem\":\"fixture\",\"fields\":[\"root_orbit\"],\"rows\":2}\n",
                "{\"id\":1,\"expected\":true,\"values\":[0]}\n",
                "{\"id\":2,\"expected\":false,\"values\":[6]}\n"
            ),
        )
        .unwrap();
        let mut campaign = Campaign::create(
            &data,
            &temporary.path().join("run"),
            Some(temporary.path().join("control.sock")),
            4096,
            4096,
            4096,
        )
        .unwrap();
        let frozen = campaign
            .scope_profile(&json!({"field": "root_orbit"}))
            .unwrap();
        assert_eq!(frozen["observed_mask"], 65);
        assert_eq!(frozen["live_observed_mask"], 0);

        campaign
            .pulse(&json!({
                "since_epoch": 0,
                "solver": {
                    "states": 10,
                    "duplicates": 2,
                    "infeasible": 3,
                    "depth": 4,
                    "selected_count": 5,
                    "unresolved_count": 6,
                    "root_candidate": 26,
                    "root_orbit": 11
                }
            }))
            .unwrap();
        let combined = campaign
            .scope_profile(&json!({"field": "root_orbit"}))
            .unwrap();
        assert_eq!(combined["batch_observed_mask"], 65);
        assert_eq!(combined["live_observed_mask"], 1_u64 << 11);
        assert_eq!(combined["observed_mask"], 65 | (1_u64 << 11));
    }

    #[test]
    fn group_compile_streams_a_reusable_parent_campaign() {
        let temporary = tempfile::tempdir().unwrap();
        let data = temporary.path().join("data.jsonl");
        let children = FeatureBatch {
            presentation: "children".into(),
            problem: "fixture".into(),
            fields: vec!["parent".into(), "value".into()].into_boxed_slice(),
            generator: None,
            row_ids: vec![0, 1, 2, 3].into_boxed_slice(),
            weights: vec![1; 4].into_boxed_slice(),
            expected: vec![0b1100].into_boxed_slice(),
            values: vec![4, 2, 4, 3, 9, 5, 9, 7].into_boxed_slice(),
        };
        children.write_jsonl(File::create(&data).unwrap()).unwrap();
        let run = temporary.path().join("run");
        let mut campaign = Campaign::create(
            &data,
            &run,
            Some(temporary.path().join("control.sock")),
            4096,
            4096,
            4096,
        )
        .unwrap();
        let result = campaign
            .group_compile(&json!({
                "group_by": "parent",
                "sum": ["value"],
                "minimum": ["value"],
                "evidence_name": "parents",
            }))
            .unwrap();
        assert_eq!(result["child_rows"], 4);
        assert_eq!(result["groups"], 2);
        let grouped =
            FeatureBatch::read_jsonl(&run.join(result["path"].as_str().unwrap()), 8, 32).unwrap();
        assert_eq!(
            &*grouped.fields,
            &["group-count", "group-sum:value", "group-min:value"]
        );
        assert_eq!(grouped.row(0), &[2, 5, 2]);
        assert_eq!(grouped.row(1), &[2, 12, 5]);
        assert!(!grouped.expected(0));
        assert!(grouped.expected(1));
    }

    #[test]
    fn candidate_batch_streams_exact_results_to_campaign_evidence() {
        let temporary = tempfile::tempdir().unwrap();
        let data = temporary.path().join("data.jsonl");
        fs::write(
            &data,
            concat!(
                "{\"schema\":\"ergodis-campaign-data-v0\",\"presentation\":\"batch\",\"problem\":\"fixture\",\"fields\":[\"x\"],\"rows\":2}\n",
                "{\"id\":1,\"expected\":false,\"values\":[0]}\n",
                "{\"id\":2,\"expected\":true,\"values\":[1]}\n"
            ),
        )
        .unwrap();
        let mut campaign = Campaign::create(
            &data,
            &temporary.path().join("run"),
            Some(temporary.path().join("control.sock")),
            4096,
            4096,
            4096,
        )
        .unwrap();
        let plans = [false, true]
            .into_iter()
            .enumerate()
            .map(|(index, value)| {
                json!({
                    "schema": PLAN_SCHEMA,
                    "name": format!("constant-{index}"),
                    "role": "diagnostic",
                    "output": "predicate",
                    "program": [{"op": "bool", "value": value}],
                })
            })
            .collect::<Vec<_>>();
        let result = campaign
            .candidate_batch(&json!({
                "plans": plans,
                "evidence_name": "batch-control",
                "retain": 2,
            }))
            .unwrap();
        assert_eq!(result["tested"], 2);
        assert_eq!(result["truncated"], false);
        let evidence = fs::read_to_string(
            campaign
                .manifest
                .run_dir
                .join("evidence/batch-control.jsonl"),
        )
        .unwrap();
        assert_eq!(evidence.lines().count(), 2);
    }

    #[test]
    fn daemon_evolution_runs_off_thread_and_streams_trials() {
        let temporary = tempfile::tempdir().unwrap();
        let data = temporary.path().join("data.jsonl");
        fs::write(
            &data,
            concat!(
                "{\"schema\":\"ergodis-campaign-data-v0\",\"presentation\":\"evolve\",\"problem\":\"threshold\",\"fields\":[\"x\"],\"rows\":4}\n",
                "{\"id\":0,\"expected\":false,\"values\":[0]}\n",
                "{\"id\":1,\"expected\":false,\"values\":[99]}\n",
                "{\"id\":2,\"expected\":true,\"values\":[100]}\n",
                "{\"id\":3,\"expected\":true,\"values\":[101]}\n"
            ),
        )
        .unwrap();
        let mut campaign = Campaign::create(
            &data,
            &temporary.path().join("run"),
            Some(temporary.path().join("control.sock")),
            16_384,
            8_192,
            16_384,
        )
        .unwrap();
        assert!(campaign
            .evolution_start(&json!({"seeds": {}}))
            .unwrap_err()
            .to_string()
            .contains("seeds must be an array"));
        assert!(campaign
            .evolution_start(&json!({"resume_evidence": "archive.jsonl"}))
            .unwrap_err()
            .to_string()
            .contains("resume_evidence must be an array"));
        let seed = json!({
            "schema": PLAN_SCHEMA,
            "name": "threshold",
            "role": "diagnostic",
            "output": "predicate",
            "program": [
                {"op": "field", "name": "x"},
                {"op": "const", "value": 0},
                {"op": "gt"}
            ],
        });
        let second_seed = json!({
            "schema": PLAN_SCHEMA,
            "name": "reverse-threshold",
            "role": "diagnostic",
            "output": "predicate",
            "program": [
                {"op": "field", "name": "x"},
                {"op": "const", "value": 101},
                {"op": "lt"}
            ],
        });
        let started = campaign
            .evolution_start(&json!({
                "seeds": [seed, second_seed],
                "evidence_name": "evolution-control",
                "generations": 4,
                "beam": 2,
                "max_candidates": 4,
            }))
            .unwrap();
        assert_eq!(started["state"], "running");
        let completed = loop {
            let status = campaign.evolution_status().unwrap();
            if status["state"] != "running" {
                break status;
            }
            thread::yield_now();
        };
        assert_eq!(completed["state"], "complete");
        assert!(completed["summary"]["tested"].as_u64().unwrap() >= 2);
        assert!(completed["summary"]["perfect"].as_u64().unwrap() >= 1);
        assert_eq!(
            completed["summary"]["operator_scorecards"]["counterexample-threshold"]["trials"],
            2
        );
        assert_eq!(
            completed["summary"]["operator_scorecards"]["counterexample-threshold"]["improved"],
            2
        );
        assert_eq!(
            completed["summary"]["operator_scorecards"]["counterexample-threshold"]
                ["compared_to_parent"],
            2
        );
        assert_eq!(
            completed["summary"]["operator_scorecards"]["counterexample-threshold"]["perfect"],
            1
        );
        assert_eq!(
            completed["summary"]["operator_scorecards"]["counterexample-threshold"]
                ["semantic_op_rows"],
            24
        );
        assert_eq!(
            completed["summary"]["operator_scorecards"]["counterexample-threshold"]
                ["best_correct_gain"],
            1
        );
        assert_eq!(
            completed["summary"]["operator_scorecards"]["counterexample-threshold"]
                ["best_correct_gain_per_cost_numerator"],
            1
        );
        assert_eq!(
            completed["summary"]["operator_scorecards"]["counterexample-threshold"]
                ["best_correct_gain_per_cost_denominator"],
            12
        );
        assert_eq!(
            completed["summary"]["operator_scorecards"]["seed"]["compared_to_parent"],
            0
        );
        assert_eq!(completed["summary"]["selection_exploration_slots"], 2);
        assert_eq!(completed["summary"]["selection_guided_slots"], 0);
        assert_eq!(completed["summary"]["selection_balanced_slots"], 0);
        let relative = completed["path"].as_str().unwrap();
        let evidence = fs::read_to_string(campaign.manifest.run_dir.join(relative)).unwrap();
        assert_eq!(evidence.lines().count(), 6);
        let records = evidence
            .lines()
            .map(|line| serde_json::from_str::<Value>(line).unwrap())
            .collect::<Vec<_>>();
        assert_eq!(records[0]["schema"], "ergodis-evolution-evidence-v0");
        assert_eq!(records[0]["problem"], "threshold");
        assert_eq!(records[1]["operator"], "seed");
        assert!(records[1]["parent_hash"].is_null());
        assert_eq!(records[1]["failure_shape"]["kind"], "false-positive");
        assert_eq!(records[1]["failure_shape"]["first_mismatch_id"], 1);
        assert_eq!(records[1]["failure_shape"]["probes"][0]["field"], "x");
        assert_eq!(records[1]["failure_shape"]["probes"][0]["value"], 99);
        assert_eq!(records[2]["operator"], "seed");
        let seed_hashes = [&records[1]["hash"], &records[2]["hash"]]
            .into_iter()
            .map(|value| value.as_str().unwrap())
            .collect::<BTreeSet<_>>();
        let parent_hashes = records[3..5]
            .iter()
            .map(|record| record["parent_hash"].as_str().unwrap())
            .collect::<BTreeSet<_>>();
        assert_eq!(parent_hashes, seed_hashes);
        assert!(records[3..5]
            .iter()
            .all(|record| record["impact"]["improved"] == true));
        assert!(records[3..5]
            .iter()
            .all(|record| record["cost"]["semantic_op_rows"] == 12));
        assert!(records
            .iter()
            .skip(3)
            .any(|record| record["operator"] == "counterexample-threshold"));
        assert!(records
            .iter()
            .skip(3)
            .all(|record| record["operator"] != "seed"));
        assert_eq!(records[5]["type"], "summary");
        assert_eq!(records[5]["summary"]["bytes"], evidence.len() as u64);
        assert_eq!(
            records[5]["summary"]["bytes"],
            completed["summary"]["bytes"]
        );
        assert_eq!(
            records[5]["summary"]["operator_scorecards"],
            completed["summary"]["operator_scorecards"]
        );

        let rejected = campaign
            .evolution_start(&json!({
                "seeds": [records[1]["plan"].clone()],
                "evidence_name": "too-small",
                "generations": 1,
                "beam": 1,
                "max_candidates": 1,
                "max_evidence_bytes": 1024,
            }))
            .unwrap();
        let rejected_path = campaign
            .manifest
            .run_dir
            .join(rejected["path"].as_str().unwrap());
        let rejected = loop {
            let status = campaign.evolution_status().unwrap();
            if status["state"] != "running" {
                break status;
            }
            thread::yield_now();
        };
        assert_eq!(rejected["state"], "failed");
        assert!(rejected["error"]
            .as_str()
            .unwrap()
            .contains("summary reserve"));
        assert_eq!(fs::metadata(rejected_path).unwrap().len(), 0);
    }

    #[test]
    fn daemon_evolution_replays_compatible_cross_campaign_seeds() {
        let temporary = tempfile::tempdir().unwrap();
        let digest = "0".repeat(64);
        let first_data = temporary.path().join("first.jsonl");
        let second_data = temporary.path().join("second.jsonl");
        fs::write(
            &first_data,
            format!(
                "{{\"schema\":\"ergodis-campaign-data-v0\",\"presentation\":\"train\",\"problem\":\"threshold\",\"fields\":[\"x\"],\"rows\":2,\"generator\":{{\"name\":\"fixture\",\"version\":\"1\",\"digest\":\"{digest}\"}}}}\n{{\"id\":0,\"expected\":false,\"values\":[0]}}\n{{\"id\":1,\"expected\":true,\"values\":[2]}}\n"
            ),
        )
        .unwrap();
        fs::write(
            &second_data,
            format!(
                "{{\"schema\":\"ergodis-campaign-data-v0\",\"presentation\":\"holdout\",\"problem\":\"threshold\",\"fields\":[\"x\"],\"rows\":2,\"generator\":{{\"name\":\"fixture\",\"version\":\"1\",\"digest\":\"{digest}\"}}}}\n{{\"id\":2,\"expected\":true,\"values\":[3]}}\n{{\"id\":3,\"expected\":false,\"values\":[1]}}\n"
            ),
        )
        .unwrap();

        let mut first = Campaign::create(
            &first_data,
            &temporary.path().join("first-run"),
            Some(temporary.path().join("first.sock")),
            16_384,
            8_192,
            16_384,
        )
        .unwrap();
        let seed = json!({
            "schema": PLAN_SCHEMA,
            "name": "threshold",
            "role": "diagnostic",
            "output": "predicate",
            "program": [
                {"op": "field", "name": "x"},
                {"op": "const", "value": 1},
                {"op": "gt"}
            ],
        });
        let started = first
            .evolution_start(&json!({
                "seeds": [seed],
                "evidence_name": "train",
                "generations": 1,
                "beam": 1,
                "max_candidates": 1,
            }))
            .unwrap();
        let first_evidence = first
            .manifest
            .run_dir
            .join(started["path"].as_str().unwrap());
        while first.evolution_status().unwrap()["state"] == "running" {
            thread::yield_now();
        }

        let mut second = Campaign::create(
            &second_data,
            &temporary.path().join("second-run"),
            Some(temporary.path().join("second.sock")),
            16_384,
            8_192,
            16_384,
        )
        .unwrap();
        let started = second
            .evolution_start(&json!({
                "resume_evidence": [first_evidence.clone(), first_evidence.clone()],
                "evidence_name": "holdout",
                "generations": 1,
                "beam": 1,
                "max_candidates": 1,
            }))
            .unwrap();
        assert_eq!(started["direct_seeds"], 0);
        assert_eq!(started["replayed_seeds"], 1);
        let completed = loop {
            let status = second.evolution_status().unwrap();
            if status["state"] != "running" {
                break status;
            }
            thread::yield_now();
        };
        assert_eq!(completed["state"], "complete");
        let evidence = fs::read_to_string(
            second
                .manifest
                .run_dir
                .join(completed["path"].as_str().unwrap()),
        )
        .unwrap();
        let records = evidence
            .lines()
            .map(|line| serde_json::from_str::<Value>(line).unwrap())
            .collect::<Vec<_>>();
        assert_eq!(records[0]["presentation"], "holdout");
        assert_eq!(records[0]["code_commit"], second.manifest.code_commit);
        assert_eq!(records[1]["operator"], "replay");
        assert!(records[1]["parent_hash"].is_null());
        let source = fs::read_to_string(&first_evidence).unwrap();
        let mut source_records = source
            .lines()
            .map(|line| serde_json::from_str::<Value>(line).unwrap())
            .collect::<Vec<_>>();
        assert_eq!(records[1]["source_hash"], source_records[1]["hash"]);
        assert_eq!(
            records[1]["source_evidence"].as_str(),
            first_evidence.to_str()
        );

        let tampered_evidence = temporary.path().join("tampered-evidence.jsonl");
        source_records[1]["hash"] = Value::String("f".repeat(64));
        let mut tampered = source_records
            .iter()
            .map(serde_json::to_string)
            .collect::<Result<Vec<_>, _>>()
            .unwrap()
            .join("\n");
        tampered.push('\n');
        fs::write(&tampered_evidence, tampered).unwrap();
        let error = second
            .evolution_start(&json!({
                "resume_evidence": [tampered_evidence],
                "evidence_name": "tampered",
                "generations": 1,
                "beam": 1,
                "max_candidates": 1,
            }))
            .unwrap_err();
        assert!(error.to_string().contains("hash does not match"));

        let incompatible_data = temporary.path().join("incompatible.jsonl");
        fs::write(
            &incompatible_data,
            format!(
                "{{\"schema\":\"ergodis-campaign-data-v0\",\"presentation\":\"other\",\"problem\":\"threshold\",\"fields\":[\"x\"],\"rows\":1,\"generator\":{{\"name\":\"fixture\",\"version\":\"1\",\"digest\":\"{}\"}}}}\n{{\"id\":4,\"expected\":true,\"values\":[4]}}\n",
                "1".repeat(64)
            ),
        )
        .unwrap();
        let mut incompatible = Campaign::create(
            &incompatible_data,
            &temporary.path().join("incompatible-run"),
            Some(temporary.path().join("incompatible.sock")),
            16_384,
            8_192,
            16_384,
        )
        .unwrap();
        let error = incompatible
            .evolution_start(&json!({
                "resume_evidence": [first_evidence],
                "evidence_name": "incompatible",
                "generations": 1,
                "beam": 1,
                "max_candidates": 1,
            }))
            .unwrap_err();
        assert!(error.to_string().contains("incompatible"));
    }

    #[test]
    fn daemon_evolution_cascade_avoids_full_rows_for_dominated_candidates() {
        let temporary = tempfile::tempdir().unwrap();
        let data = temporary.path().join("data.jsonl");
        let batch = FeatureBatch {
            presentation: "cascade".into(),
            problem: "all-positive".into(),
            fields: vec!["x".into()].into_boxed_slice(),
            generator: None,
            row_ids: (0..128).collect::<Vec<_>>().into_boxed_slice(),
            weights: vec![1; 128].into_boxed_slice(),
            expected: vec![u64::MAX; 2].into_boxed_slice(),
            values: vec![0; 128].into_boxed_slice(),
        };
        batch.write_jsonl(File::create(&data).unwrap()).unwrap();
        let mut campaign = Campaign::create(
            &data,
            &temporary.path().join("run"),
            Some(temporary.path().join("control.sock")),
            16_384,
            8_192,
            64 * 1024,
        )
        .unwrap();
        let seed = json!({
            "schema": PLAN_SCHEMA,
            "name": "threshold",
            "role": "diagnostic",
            "output": "predicate",
            "program": [
                {"op": "field", "name": "x"},
                {"op": "const", "value": 0},
                {"op": "gt"}
            ],
        });
        campaign
            .evolution_start(&json!({
                "seeds": [seed],
                "evidence_name": "cascade-control",
                "generations": 2,
                "beam": 1,
                "max_candidates": 16,
            }))
            .unwrap();
        let completed = loop {
            let status = campaign.evolution_status().unwrap();
            if status["state"] != "running" {
                break status;
            }
            thread::yield_now();
        };
        let summary = &completed["summary"];
        let tested = summary["tested"].as_u64().unwrap();
        let rows = summary["rows_evaluated"].as_u64().unwrap();
        assert!(summary["cascade_rejections"].as_u64().unwrap() > 0);
        assert!(rows < tested * 128);
        assert!(summary["perfect"].as_u64().unwrap() > 0);
    }

    #[test]
    fn simultaneous_campaigns_reject_cross_run_control() {
        let temporary = tempfile::tempdir().unwrap();
        let data = temporary.path().join("data.jsonl");
        fs::write(
            &data,
            concat!(
                "{\"schema\":\"ergodis-campaign-data-v0\",\"presentation\":\"tiny\",\"problem\":\"fixture\",\"fields\":[\"x\"],\"rows\":1}\n",
                "{\"id\":1,\"expected\":true,\"values\":[1]}\n"
            ),
        )
        .unwrap();
        let campaign_a = Campaign::create(
            &data,
            &temporary.path().join("run-a"),
            Some(temporary.path().join("a.sock")),
            4096,
            4096,
            4096,
        )
        .unwrap();
        let campaign_b = Campaign::create(
            &data,
            &temporary.path().join("run-b"),
            Some(temporary.path().join("b.sock")),
            4096,
            4096,
            4096,
        )
        .unwrap();
        let manifest_a = campaign_a.manifest().clone();
        let manifest_b = campaign_b.manifest().clone();
        let thread_a = thread::spawn(move || campaign_a.serve().unwrap());
        let thread_b = thread::spawn(move || campaign_b.serve().unwrap());
        for _ in 0..100 {
            if manifest_a.socket.exists() && manifest_b.socket.exists() {
                break;
            }
            thread::sleep(Duration::from_millis(2));
        }
        assert!(manifest_a.socket.exists() && manifest_b.socket.exists());

        let mut crossed = manifest_a.clone();
        crossed.socket = manifest_b.socket.clone();
        assert!(send_request(&crossed, "status", json!({}), 4096).is_err());
        let status_b = send_request(&manifest_b, "status", json!({}), 4096).unwrap();
        assert!(status_b.ok);
        assert_eq!(status_b.epoch, 0);

        send_request(&manifest_a, "shutdown", json!({}), 4096).unwrap();
        send_request(&manifest_b, "shutdown", json!({}), 4096).unwrap();
        thread_a.join().unwrap();
        thread_b.join().unwrap();
    }

    #[test]
    fn safe_point_pulse_fetch_and_deactivate_are_epoch_consistent() {
        let temporary = tempfile::tempdir().unwrap();
        let data = temporary.path().join("data.jsonl");
        fs::write(
            &data,
            concat!(
                "{\"schema\":\"ergodis-campaign-data-v0\",\"presentation\":\"tiny\",\"problem\":\"fixture\",\"fields\":[\"x\"],\"rows\":1}\n",
                "{\"id\":1,\"expected\":true,\"values\":[1]}\n"
            ),
        )
        .unwrap();
        let mut campaign = Campaign::create(
            &data,
            &temporary.path().join("run"),
            Some(temporary.path().join("campaign.sock")),
            4096,
            4096,
            4096,
        )
        .unwrap();
        let request = |campaign: &Campaign, request_id, op: &str, args| Request {
            schema: SCHEMA.into(),
            request_id,
            run_id: campaign.manifest.run_id.clone(),
            nonce: campaign.manifest.nonce.clone(),
            max_bytes: 4096,
            op: op.into(),
            args,
        };

        let watcher_path = campaign.manifest.run_dir.join("watch-test.sock");
        let watcher = UnixDatagram::bind(&watcher_path).unwrap();
        watcher
            .set_read_timeout(Some(Duration::from_millis(20)))
            .unwrap();
        let (registered, _) = campaign.handle(request(
            &campaign,
            0,
            "watch-register",
            json!({"path": watcher_path}),
        ));
        assert!(registered.ok);
        assert_eq!(registered.result["epoch"], 0);

        let (pulse, _) = campaign.handle(request(&campaign, 1, "pulse", json!({"since_epoch": 0})));
        assert_eq!(pulse.result["changed"], false);

        let spec = PlanSpec {
            schema: PLAN_SCHEMA.into(),
            name: "positive".into(),
            role: PlanRole::Diagnostic,
            output: PlanOutput::Predicate,
            scope: None,
            program: vec![
                PlanOp::Field { name: "x".into() },
                PlanOp::Const { value: 0 },
                PlanOp::Gt,
            ],
        };
        let (applied, _) = campaign.handle(request(
            &campaign,
            2,
            "candidate-apply",
            json!({"plan": spec, "expect_epoch": 0}),
        ));
        assert!(applied.ok);
        assert_eq!(applied.epoch, 1);
        let mut notification = [0_u8; 8];
        assert_eq!(watcher.recv(&mut notification).unwrap(), 8);
        assert_eq!(u64::from_le_bytes(notification), 1);

        let (noop, _) = campaign.handle(request(&campaign, 20, "noop", json!({})));
        assert!(noop.ok);
        assert!(matches!(
            watcher.recv(&mut notification).unwrap_err().kind(),
            io::ErrorKind::WouldBlock | io::ErrorKind::TimedOut
        ));

        let (capabilities, _) = campaign.handle(request(&campaign, 21, "capabilities", json!({})));
        assert!(capabilities.ok);
        assert_eq!(capabilities.result["schema"], SCHEMA);
        assert_eq!(capabilities.result["max_frame_bytes"], MAX_FRAME_BYTES);
        assert_eq!(
            capabilities.result["socket_io_timeout_ms"],
            SOCKET_IO_TIMEOUT.as_millis() as u64
        );
        assert_eq!(capabilities.result["proof_authority"], false);

        let (pulse, _) = campaign.handle(request(&campaign, 3, "pulse", json!({"since_epoch": 0})));
        assert_eq!(pulse.result["changed"], true);
        assert_eq!(pulse.result["plans"][0]["name"], "positive");

        let (fetched, _) = campaign.handle(request(
            &campaign,
            4,
            "plan-get",
            json!({"plan": "positive", "expect_epoch": 1}),
        ));
        assert!(fetched.ok);
        assert_eq!(
            fetched.result["plan"]["program"].as_array().unwrap().len(),
            3
        );

        let (removed, _) = campaign.handle(request(
            &campaign,
            5,
            "candidate-deactivate",
            json!({"plan": "positive", "expect_epoch": 1}),
        ));
        assert!(removed.ok);
        assert_eq!(removed.epoch, 2);
        assert_eq!(watcher.recv(&mut notification).unwrap(), 8);
        assert_eq!(u64::from_le_bytes(notification), 2);
        let (pulse, _) = campaign.handle(request(&campaign, 6, "pulse", json!({"since_epoch": 1})));
        assert_eq!(pulse.result["changed"], true);
        assert_eq!(pulse.result["plans"].as_array().unwrap().len(), 0);
        let (unregistered, _) = campaign.handle(request(
            &campaign,
            7,
            "watch-unregister",
            json!({"path": watcher_path}),
        ));
        assert_eq!(unregistered.result["removed"], true);
    }
}
