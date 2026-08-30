//! Optional, experimental control plane for long theorem-search campaigns.
//!
//! This module is feature-gated so ordinary solves retain no controller state,
//! filesystem traffic, atomics, or hot-loop branches.

use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use std::collections::{BTreeMap, VecDeque};
use std::fs::{self, File, OpenOptions};
use std::io::{self, BufRead, BufReader, BufWriter, Read, Write};
use std::os::unix::fs::{OpenOptionsExt, PermissionsExt};
use std::os::unix::net::{UnixListener, UnixStream};
use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicU64, Ordering};

pub const SCHEMA: &str = "ergodis-control-experimental-v0";
pub const DATA_SCHEMA: &str = "ergodis-campaign-data-v0";
pub const PLAN_SCHEMA: &str = "ergodis-attack-plan-v0";
pub const MAX_FRAME_BYTES: usize = 64 * 1024;
pub const MAX_PLAN_OPS: usize = 128;
pub const MAX_PLAN_STACK: usize = 64;
pub const MAX_ACTIVE_PLANS: usize = 64;
pub const MAX_ARCHIVE_CLASSES: usize = 4096;
const EVENT_RING: usize = 256;

#[derive(Debug, thiserror::Error)]
pub enum ControlError {
    #[error("I/O failure: {0}")]
    Io(#[from] io::Error),
    #[error("invalid JSON: {0}")]
    Json(#[from] serde_json::Error),
    #[error("{0}")]
    Invalid(String),
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct DataHeader {
    schema: String,
    presentation: String,
    problem: String,
    fields: Vec<String>,
    rows: usize,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct DataRow {
    id: u64,
    #[serde(default = "one")]
    weight: u64,
    expected: bool,
    values: Vec<i64>,
}

const fn one() -> u64 {
    1
}

/// Dense, presized feature batch. The evaluator touches only flat arrays.
#[derive(Debug)]
pub struct FeatureBatch {
    pub presentation: String,
    pub problem: String,
    pub fields: Box<[String]>,
    row_ids: Box<[u64]>,
    weights: Box<[u64]>,
    expected: Box<[u64]>,
    values: Box<[i64]>,
}

impl FeatureBatch {
    pub fn read_jsonl(
        path: &Path,
        max_rows: usize,
        max_cells: usize,
    ) -> Result<Self, ControlError> {
        let file = File::open(path)?;
        let mut lines = BufReader::new(file).lines();
        let header_line = lines
            .next()
            .ok_or_else(|| ControlError::Invalid("empty campaign data".into()))??;
        let header: DataHeader = serde_json::from_str(&header_line)?;
        if header.schema != DATA_SCHEMA {
            return Err(ControlError::Invalid(format!(
                "unsupported data schema {:?}",
                header.schema
            )));
        }
        if header.rows > max_rows || header.fields.len().saturating_mul(header.rows) > max_cells {
            return Err(ControlError::Invalid(
                "campaign data exceeds configured limits".into(),
            ));
        }
        if header.fields.is_empty() || header.fields.len() > u16::MAX as usize {
            return Err(ControlError::Invalid("invalid feature width".into()));
        }
        let mut seen = BTreeMap::new();
        for (index, field) in header.fields.iter().enumerate() {
            if field.is_empty() || seen.insert(field, index).is_some() {
                return Err(ControlError::Invalid(
                    "feature names must be nonempty and unique".into(),
                ));
            }
        }
        let mut row_ids = Vec::with_capacity(header.rows);
        let mut weights = Vec::with_capacity(header.rows);
        let mut expected = vec![0u64; header.rows.div_ceil(64)];
        let mut values = Vec::with_capacity(header.rows * header.fields.len());
        for row_index in 0..header.rows {
            let line = lines
                .next()
                .ok_or_else(|| ControlError::Invalid(format!("missing data row {row_index}")))??;
            let row: DataRow = serde_json::from_str(&line)?;
            if row.values.len() != header.fields.len() || row.weight == 0 {
                return Err(ControlError::Invalid(format!(
                    "invalid data row {row_index}"
                )));
            }
            row_ids.push(row.id);
            weights.push(row.weight);
            if row.expected {
                expected[row_index / 64] |= 1u64 << (row_index % 64);
            }
            values.extend_from_slice(&row.values);
        }
        if lines.next().transpose()?.is_some() {
            return Err(ControlError::Invalid(
                "campaign data has trailing rows".into(),
            ));
        }
        Ok(Self {
            presentation: header.presentation,
            problem: header.problem,
            fields: header.fields.into_boxed_slice(),
            row_ids: row_ids.into_boxed_slice(),
            weights: weights.into_boxed_slice(),
            expected: expected.into_boxed_slice(),
            values: values.into_boxed_slice(),
        })
    }

    pub fn rows(&self) -> usize {
        self.row_ids.len()
    }

    fn expected(&self, row: usize) -> bool {
        self.expected[row / 64] & (1u64 << (row % 64)) != 0
    }

    fn row(&self, row: usize) -> &[i64] {
        let width = self.fields.len();
        &self.values[row * width..(row + 1) * width]
    }

    fn row_json(&self, row: usize) -> Value {
        let mut features = serde_json::Map::with_capacity(self.fields.len());
        for (name, value) in self.fields.iter().zip(self.row(row)) {
            features.insert(name.clone(), (*value).into());
        }
        json!({
            "row": row,
            "id": self.row_ids[row],
            "weight": self.weights[row],
            "expected": self.expected(row),
            "features": features,
        })
    }
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct PlanSpec {
    pub schema: String,
    pub name: String,
    pub role: PlanRole,
    #[serde(default)]
    pub output: PlanOutput,
    pub program: Vec<PlanOp>,
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
#[serde(rename_all = "kebab-case")]
pub enum PlanRole {
    Diagnostic,
    Ordering,
}

#[derive(Clone, Copy, Debug, Default, Deserialize, Serialize, PartialEq, Eq)]
#[serde(rename_all = "kebab-case")]
pub enum PlanOutput {
    #[default]
    Predicate,
    Score,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(tag = "op", rename_all = "kebab-case", deny_unknown_fields)]
pub enum PlanOp {
    Field { name: String },
    Const { value: i64 },
    Add,
    Sub,
    Mul,
    Min,
    Max,
    Eq,
    Ne,
    Lt,
    Le,
    Gt,
    Ge,
    And,
    Or,
    Not,
    Abs,
}

#[repr(u8)]
#[derive(Clone, Copy, Debug)]
enum OpCode {
    Field,
    Const,
    Add,
    Sub,
    Mul,
    Min,
    Max,
    Eq,
    Ne,
    Lt,
    Le,
    Gt,
    Ge,
    And,
    Or,
    Not,
    Abs,
}

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct CompiledOp {
    value: i64,
    field: u16,
    code: OpCode,
    _pad: [u8; 5],
}

const _: () = assert!(std::mem::size_of::<CompiledOp>() == 16);
const _: () = assert!(std::mem::align_of::<CompiledOp>() == 8);

#[derive(Clone, Debug)]
pub struct CompiledPlan {
    pub name: String,
    pub role: PlanRole,
    pub output: PlanOutput,
    ops: Box<[CompiledOp]>,
    stack_needed: usize,
    pub hash: String,
}

impl CompiledPlan {
    pub fn compile(spec: &PlanSpec, fields: &[String]) -> Result<Self, ControlError> {
        if spec.schema != PLAN_SCHEMA || spec.name.is_empty() || spec.name.len() > 96 {
            return Err(ControlError::Invalid("invalid plan schema or name".into()));
        }
        if spec.program.is_empty() || spec.program.len() > MAX_PLAN_OPS {
            return Err(ControlError::Invalid(
                "plan program length is out of bounds".into(),
            ));
        }
        let index: BTreeMap<&str, usize> = fields
            .iter()
            .enumerate()
            .map(|(field, name)| (name.as_str(), field))
            .collect();
        let mut depth = 0usize;
        let mut stack_needed = 0usize;
        let mut ops = Vec::with_capacity(spec.program.len());
        for op in &spec.program {
            let (code, value, field, inputs) = match op {
                PlanOp::Field { name } => {
                    let field = *index.get(name.as_str()).ok_or_else(|| {
                        ControlError::Invalid(format!("unknown feature {name:?}"))
                    })?;
                    (OpCode::Field, 0, field as u16, 0)
                }
                PlanOp::Const { value } => (OpCode::Const, *value, 0, 0),
                PlanOp::Add => (OpCode::Add, 0, 0, 2),
                PlanOp::Sub => (OpCode::Sub, 0, 0, 2),
                PlanOp::Mul => (OpCode::Mul, 0, 0, 2),
                PlanOp::Min => (OpCode::Min, 0, 0, 2),
                PlanOp::Max => (OpCode::Max, 0, 0, 2),
                PlanOp::Eq => (OpCode::Eq, 0, 0, 2),
                PlanOp::Ne => (OpCode::Ne, 0, 0, 2),
                PlanOp::Lt => (OpCode::Lt, 0, 0, 2),
                PlanOp::Le => (OpCode::Le, 0, 0, 2),
                PlanOp::Gt => (OpCode::Gt, 0, 0, 2),
                PlanOp::Ge => (OpCode::Ge, 0, 0, 2),
                PlanOp::And => (OpCode::And, 0, 0, 2),
                PlanOp::Or => (OpCode::Or, 0, 0, 2),
                PlanOp::Not => (OpCode::Not, 0, 0, 1),
                PlanOp::Abs => (OpCode::Abs, 0, 0, 1),
            };
            if depth < inputs {
                return Err(ControlError::Invalid("plan stack underflow".into()));
            }
            depth = depth + 1 - inputs;
            stack_needed = stack_needed.max(depth);
            if stack_needed > MAX_PLAN_STACK {
                return Err(ControlError::Invalid(
                    "plan stack exceeds fixed evaluator".into(),
                ));
            }
            ops.push(CompiledOp {
                value,
                field,
                code,
                _pad: [0; 5],
            });
        }
        if depth != 1 {
            return Err(ControlError::Invalid(
                "plan must leave exactly one result".into(),
            ));
        }
        let encoded = serde_json::to_vec(spec)?;
        Ok(Self {
            name: spec.name.clone(),
            role: spec.role,
            output: spec.output,
            ops: ops.into_boxed_slice(),
            stack_needed,
            hash: blake3::hash(&encoded).to_hex().to_string(),
        })
    }

    /// Evaluate one row with a fixed stack and no allocation.
    fn evaluate_value(
        &self,
        row: &[i64],
        trace: Option<&mut Vec<i64>>,
    ) -> Result<i64, ControlError> {
        let mut stack = [0i64; MAX_PLAN_STACK];
        let mut depth = 0usize;
        let mut trace = trace;
        for op in &self.ops {
            let result = match op.code {
                OpCode::Field => row[op.field as usize],
                OpCode::Const => op.value,
                OpCode::Not => {
                    stack[depth - 1] = i64::from(stack[depth - 1] == 0);
                    if let Some(values) = trace.as_deref_mut() {
                        values.push(stack[depth - 1]);
                    }
                    continue;
                }
                OpCode::Abs => {
                    stack[depth - 1] = stack[depth - 1].checked_abs().ok_or_else(|| {
                        ControlError::Invalid("arithmetic overflow in plan".into())
                    })?;
                    if let Some(values) = trace.as_deref_mut() {
                        values.push(stack[depth - 1]);
                    }
                    continue;
                }
                code => {
                    let right = stack[depth - 1];
                    let left = stack[depth - 2];
                    depth -= 2;
                    match code {
                        OpCode::Add => left.checked_add(right).ok_or_else(|| {
                            ControlError::Invalid("arithmetic overflow in plan".into())
                        })?,
                        OpCode::Sub => left.checked_sub(right).ok_or_else(|| {
                            ControlError::Invalid("arithmetic overflow in plan".into())
                        })?,
                        OpCode::Mul => left.checked_mul(right).ok_or_else(|| {
                            ControlError::Invalid("arithmetic overflow in plan".into())
                        })?,
                        OpCode::Min => left.min(right),
                        OpCode::Max => left.max(right),
                        OpCode::Eq => i64::from(left == right),
                        OpCode::Ne => i64::from(left != right),
                        OpCode::Lt => i64::from(left < right),
                        OpCode::Le => i64::from(left <= right),
                        OpCode::Gt => i64::from(left > right),
                        OpCode::Ge => i64::from(left >= right),
                        OpCode::And => i64::from(left != 0 && right != 0),
                        OpCode::Or => i64::from(left != 0 || right != 0),
                        OpCode::Field | OpCode::Const | OpCode::Not | OpCode::Abs => unreachable!(),
                    }
                }
            };
            stack[depth] = result;
            depth += 1;
            if let Some(values) = trace.as_deref_mut() {
                values.push(result);
            }
        }
        debug_assert_eq!(depth, 1);
        debug_assert!(self.stack_needed <= MAX_PLAN_STACK);
        Ok(stack[0])
    }
}

#[derive(Clone, Debug, Serialize)]
pub struct Evaluation {
    pub output: PlanOutput,
    pub rows: usize,
    pub weighted_rows: u64,
    pub weighted_correct: u64,
    pub weighted_false_positive: u64,
    pub weighted_false_negative: u64,
    pub weighted_true: u64,
    pub first_mismatch: Option<usize>,
    pub first_false: Option<usize>,
    pub outcome_hash: String,
    pub minimum_score: i64,
    pub maximum_score: i64,
}

pub fn evaluate_plan(
    batch: &FeatureBatch,
    plan: &CompiledPlan,
) -> Result<Evaluation, ControlError> {
    let mut outcome_hasher = blake3::Hasher::new();
    let mut outcome_word = 0u64;
    let mut outcome_bits = 0u32;
    let mut result = Evaluation {
        output: plan.output,
        rows: batch.rows(),
        weighted_rows: 0,
        weighted_correct: 0,
        weighted_false_positive: 0,
        weighted_false_negative: 0,
        weighted_true: 0,
        first_mismatch: None,
        first_false: None,
        outcome_hash: String::new(),
        minimum_score: i64::MAX,
        maximum_score: i64::MIN,
    };
    for row in 0..batch.rows() {
        let value = plan.evaluate_value(batch.row(row), None)?;
        let observed = value != 0;
        let expected = batch.expected(row);
        result.minimum_score = result.minimum_score.min(value);
        result.maximum_score = result.maximum_score.max(value);
        if plan.output == PlanOutput::Predicate {
            outcome_word |= u64::from(observed) << outcome_bits;
            outcome_bits += 1;
            if outcome_bits == 64 {
                outcome_hasher.update(&outcome_word.to_le_bytes());
                outcome_word = 0;
                outcome_bits = 0;
            }
        } else {
            outcome_hasher.update(&value.to_le_bytes());
        }
        let weight = batch.weights[row];
        result.weighted_rows = result.weighted_rows.saturating_add(weight);
        if observed {
            result.weighted_true = result.weighted_true.saturating_add(weight);
        } else if result.first_false.is_none() {
            result.first_false = Some(row);
        }
        if observed == expected {
            result.weighted_correct = result.weighted_correct.saturating_add(weight);
        } else {
            result.first_mismatch.get_or_insert(row);
            if observed {
                result.weighted_false_positive =
                    result.weighted_false_positive.saturating_add(weight);
            } else {
                result.weighted_false_negative =
                    result.weighted_false_negative.saturating_add(weight);
            }
        }
    }
    if plan.output == PlanOutput::Predicate && outcome_bits != 0 {
        outcome_hasher.update(&outcome_word.to_le_bytes());
    }
    result.outcome_hash = outcome_hasher.finalize().to_hex().to_string();
    Ok(result)
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
    plan: CompiledPlan,
    evaluation: Evaluation,
}

pub struct Campaign {
    manifest: Manifest,
    batch: FeatureBatch,
    epoch: AtomicU64,
    seq: u64,
    plans: Vec<StoredPlan>,
    archive: BTreeMap<String, String>,
    events: VecDeque<Event>,
    ledger: Ledger,
    response_limit: usize,
    trace_limit: u64,
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
        if run_dir.exists() {
            return Err(ControlError::Invalid("run directory already exists".into()));
        }
        fs::create_dir(run_dir)?;
        fs::set_permissions(run_dir, fs::Permissions::from_mode(0o700))?;
        fs::create_dir(run_dir.join("evidence"))?;
        fs::set_permissions(run_dir.join("evidence"), fs::Permissions::from_mode(0o700))?;
        let batch = FeatureBatch::read_jsonl(data, 10_000_000, 200_000_000)?;
        let run_id = random_hex(16)?;
        let nonce = random_hex(16)?;
        let socket = match socket {
            Some(path) => path,
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
            run_dir: run_dir.to_path_buf(),
            pid: std::process::id(),
            code_commit: option_env!("ERGODIS_GIT_COMMIT")
                .unwrap_or("unknown")
                .into(),
            presentation_hash: data_hash,
            problem: batch.problem.clone(),
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
            ledger,
            response_limit: response_limit.min(MAX_FRAME_BYTES),
            trace_limit,
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
            match read_frame(&mut stream) {
                Ok(bytes) => {
                    let request = serde_json::from_slice::<Request>(&bytes);
                    let response = match request {
                        Ok(request) => {
                            let (response, stop) = self.handle(request);
                            shutdown |= stop;
                            response
                        }
                        Err(error) => self.error_response(0, format!("invalid request: {error}")),
                    };
                    let limit = self.response_limit;
                    let _ = write_response(&mut stream, response, limit);
                }
                Err(error) => {
                    let response = self.error_response(0, error.to_string());
                    let _ = write_response(&mut stream, response, self.response_limit);
                }
            }
        }
        drop(listener);
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
            "status" => self.status(),
            "agent-brief" => self.agent_brief(&request.args),
            "candidate-try" => self.candidate_try(&request.args, false),
            "candidate-apply" => self.candidate_try(&request.args, true),
            "obstruction-first" => self.obstruction(&request.args),
            "exceptional" => self.exceptional(&request.args),
            "trace" => self.trace(&request.args),
            "note" => self.note(&request.args),
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

    fn status(&self) -> Result<Value, ControlError> {
        Ok(json!({
            "problem": self.batch.problem,
            "presentation": self.batch.presentation,
            "presentation_hash": self.manifest.presentation_hash,
            "rows": self.batch.rows(),
            "fields": self.batch.fields,
            "plans": self.plans.len(),
            "outcome_classes": self.archive.len(),
            "ledger_bytes": self.ledger.bytes,
            "ledger_limit": self.ledger.max_bytes,
            "ledger_truncated": self.ledger.truncated,
            "health": "ready",
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

    fn candidate_try(&mut self, args: &Value, apply: bool) -> Result<Value, ControlError> {
        let spec_value = args
            .get("plan")
            .ok_or_else(|| ControlError::Invalid("missing plan".into()))?;
        let spec: PlanSpec = serde_json::from_value(spec_value.clone())?;
        let plan = CompiledPlan::compile(&spec, &self.batch.fields)?;
        let evaluation = evaluate_plan(&self.batch, &plan)?;
        let equivalent_to = self.archive.get(&evaluation.outcome_hash).cloned();
        if equivalent_to.is_none() && self.archive.len() < MAX_ARCHIVE_CLASSES {
            self.archive
                .insert(evaluation.outcome_hash.clone(), plan.name.clone());
        }
        let first = evaluation.first_mismatch.or(evaluation.first_false);
        let obstruction = first.map(|row| self.batch.row_json(row));
        if !apply {
            let synopsis = match first {
                Some(row) => format!("first obstruction row {row}"),
                None => "no obstruction in frozen batch".into(),
            };
            self.record("candidate-tested", &synopsis, Some(plan.name.clone()))?;
            return Ok(
                json!({"plan": plan.name, "hash": plan.hash, "equivalent_to": equivalent_to, "evaluation": evaluation, "first_obstruction": obstruction}),
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
            plan,
            evaluation: evaluation.clone(),
        });
        let new_epoch = old_epoch + 1;
        self.epoch.store(new_epoch, Ordering::Release);
        self.record(
            "candidate-applied",
            "diagnostic plan activated",
            Some(name.clone()),
        )?;
        Ok(
            json!({"plan": name, "hash": hash, "equivalent_to": equivalent_to, "old_epoch": old_epoch, "new_epoch": new_epoch, "evaluation": evaluation, "first_obstruction": obstruction}),
        )
    }

    fn obstruction(&self, args: &Value) -> Result<Value, ControlError> {
        let name = required_str(args, "plan")?;
        let stored = self
            .plans
            .iter()
            .find(|stored| stored.plan.name == name)
            .ok_or_else(|| ControlError::Invalid("unknown active plan".into()))?;
        let row = stored
            .evaluation
            .first_mismatch
            .or(stored.evaluation.first_false);
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
            let score = stored.plan.evaluate_value(self.batch.row(row), None)?;
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
        let mut values = Vec::with_capacity(stored.plan.ops.len().min(max_records));
        let observed = stored
            .plan
            .evaluate_value(self.batch.row(row), Some(&mut values))?;
        let truncated = stored.plan.ops.len() > max_records;
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
        let encoded = serde_json::to_vec(&trace)?;
        if encoded.len() as u64 > self.trace_limit {
            return Err(ControlError::Invalid(
                "trace exceeds configured file limit".into(),
            ));
        }
        let hash = blake3::hash(&encoded).to_hex().to_string();
        let relative = PathBuf::from("evidence").join(format!("trace-{}.json", &hash[..20]));
        write_create_bytes(&self.manifest.run_dir.join(&relative), &encoded)?;
        self.record(
            "trace-written",
            "localized trace captured",
            Some(name.into()),
        )?;
        Ok(
            json!({"path": relative, "hash": hash, "bytes": encoded.len(), "records": values.len(), "truncated": truncated}),
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
        request_id: 1,
        run_id: manifest.run_id.clone(),
        nonce: manifest.nonce.clone(),
        max_bytes: max_bytes.min(MAX_FRAME_BYTES),
        op: op.into(),
        args,
    };
    let encoded = serde_json::to_vec(&request)?;
    let mut stream = UnixStream::connect(&manifest.socket)?;
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

pub fn read_manifest(run_dir: &Path) -> Result<Manifest, ControlError> {
    Ok(serde_json::from_reader(BufReader::new(File::open(
        run_dir.join("manifest.json"),
    )?))?)
}

fn required_str<'a>(value: &'a Value, key: &str) -> Result<&'a str, ControlError> {
    value
        .get(key)
        .and_then(Value::as_str)
        .ok_or_else(|| ControlError::Invalid(format!("missing {key}")))
}

fn random_hex(bytes: usize) -> Result<String, ControlError> {
    let mut random = vec![0u8; bytes];
    File::open("/dev/urandom")?.read_exact(&mut random)?;
    Ok(random.iter().map(|byte| format!("{byte:02x}")).collect())
}

fn default_socket(run_id: &str, nonce: &str) -> Result<PathBuf, ControlError> {
    let runtime = std::env::var_os("XDG_RUNTIME_DIR").ok_or_else(|| {
        ControlError::Invalid("XDG_RUNTIME_DIR is unavailable; provide --socket".into())
    })?;
    Ok(PathBuf::from(runtime)
        .join("ergodis")
        .join(unsafe { libc_uid() }.to_string())
        .join(format!("{}-{}.sock", &run_id[..12], &nonce[..12])))
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

fn write_create_bytes(path: &Path, bytes: &[u8]) -> Result<(), ControlError> {
    let mut file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .open(path)?;
    file.write_all(bytes)?;
    file.write_all(b"\n")?;
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
    use super::*;
    use std::thread;
    use std::time::Duration;

    fn batch() -> FeatureBatch {
        FeatureBatch {
            presentation: "tiny".into(),
            problem: "fixture".into(),
            fields: vec!["surplus".into(), "drop".into()].into_boxed_slice(),
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
    fn malformed_postfix_program_fails_closed() {
        let mut spec = PlanSpec {
            schema: PLAN_SCHEMA.into(),
            name: "bad".into(),
            role: PlanRole::Diagnostic,
            output: PlanOutput::Predicate,
            program: vec![PlanOp::And],
        };
        assert!(CompiledPlan::compile(&spec, &batch().fields).is_err());
        spec.program = vec![PlanOp::Const { value: 1 }, PlanOp::Const { value: 2 }];
        assert!(CompiledPlan::compile(&spec, &batch().fields).is_err());
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
}
