use super::{ControlError, DATA_SCHEMA, MAX_PLAN_OPS, MAX_PLAN_STACK, PLAN_SCHEMA};
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use std::collections::BTreeMap;
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::path::Path;

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
    pub(super) row_ids: Box<[u64]>,
    pub(super) weights: Box<[u64]>,
    pub(super) expected: Box<[u64]>,
    pub(super) values: Box<[i64]>,
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

    pub(super) fn expected(&self, row: usize) -> bool {
        self.expected[row / 64] & (1u64 << (row % 64)) != 0
    }

    pub(super) fn row(&self, row: usize) -> &[i64] {
        let width = self.fields.len();
        &self.values[row * width..(row + 1) * width]
    }

    pub(super) fn row_json(&self, row: usize) -> Value {
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
#[serde(untagged)]
pub enum PlanDocument {
    Bytecode(PlanSpec),
    Expression(ExpressionPlanSpec),
}

impl PlanDocument {
    pub fn lower(self) -> Result<PlanSpec, ControlError> {
        match self {
            Self::Bytecode(spec) => Ok(spec),
            Self::Expression(spec) => spec.lower(),
        }
    }
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct ExpressionPlanSpec {
    pub schema: String,
    pub name: String,
    pub role: PlanRole,
    #[serde(default)]
    pub output: PlanOutput,
    pub expr: PlanExpr,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(tag = "op", rename_all = "kebab-case", deny_unknown_fields)]
pub enum PlanExpr {
    Field {
        name: String,
    },
    Const {
        value: i64,
    },
    Add {
        left: Box<Self>,
        right: Box<Self>,
    },
    Sub {
        left: Box<Self>,
        right: Box<Self>,
    },
    Mul {
        left: Box<Self>,
        right: Box<Self>,
    },
    Min {
        left: Box<Self>,
        right: Box<Self>,
    },
    Max {
        left: Box<Self>,
        right: Box<Self>,
    },
    Eq {
        left: Box<Self>,
        right: Box<Self>,
    },
    Ne {
        left: Box<Self>,
        right: Box<Self>,
    },
    Lt {
        left: Box<Self>,
        right: Box<Self>,
    },
    Le {
        left: Box<Self>,
        right: Box<Self>,
    },
    Gt {
        left: Box<Self>,
        right: Box<Self>,
    },
    Ge {
        left: Box<Self>,
        right: Box<Self>,
    },
    And {
        left: Box<Self>,
        right: Box<Self>,
    },
    Or {
        left: Box<Self>,
        right: Box<Self>,
    },
    Not {
        arg: Box<Self>,
    },
    Abs {
        arg: Box<Self>,
    },
    Select {
        condition: Box<Self>,
        #[serde(rename = "then")]
        then_value: Box<Self>,
        #[serde(rename = "else")]
        else_value: Box<Self>,
    },
}

impl ExpressionPlanSpec {
    pub fn lower(self) -> Result<PlanSpec, ControlError> {
        enum Emit<'a> {
            Expr(&'a PlanExpr, usize),
            Op(PlanOp),
        }
        let mut work = vec![Emit::Expr(&self.expr, 1)];
        let mut program = Vec::with_capacity(MAX_PLAN_OPS);
        let mut nodes = 0usize;
        while let Some(item) = work.pop() {
            match item {
                Emit::Op(op) => program.push(op),
                Emit::Expr(expr, depth) => {
                    nodes += 1;
                    if nodes > MAX_PLAN_OPS || depth > 32 {
                        return Err(ControlError::Invalid(
                            "expression plan exceeds node or depth limit".into(),
                        ));
                    }
                    match expr {
                        PlanExpr::Field { name } => {
                            program.push(PlanOp::Field { name: name.clone() })
                        }
                        PlanExpr::Const { value } => program.push(PlanOp::Const { value: *value }),
                        PlanExpr::Not { arg } => {
                            work.push(Emit::Op(PlanOp::Not));
                            work.push(Emit::Expr(arg, depth + 1));
                        }
                        PlanExpr::Abs { arg } => {
                            work.push(Emit::Op(PlanOp::Abs));
                            work.push(Emit::Expr(arg, depth + 1));
                        }
                        PlanExpr::Select {
                            condition,
                            then_value,
                            else_value,
                        } => {
                            work.push(Emit::Op(PlanOp::Select));
                            work.push(Emit::Expr(else_value, depth + 1));
                            work.push(Emit::Expr(then_value, depth + 1));
                            work.push(Emit::Expr(condition, depth + 1));
                        }
                        binary => {
                            let (left, right, op) = binary_parts(binary).unwrap();
                            work.push(Emit::Op(op));
                            work.push(Emit::Expr(right, depth + 1));
                            work.push(Emit::Expr(left, depth + 1));
                        }
                    }
                }
            }
            if program.len().saturating_add(work.len()) > 3 * MAX_PLAN_OPS {
                return Err(ControlError::Invalid(
                    "expression lowering work limit exceeded".into(),
                ));
            }
        }
        if program.len() > MAX_PLAN_OPS {
            return Err(ControlError::Invalid(
                "lowered expression exceeds VM operation limit".into(),
            ));
        }
        Ok(PlanSpec {
            schema: self.schema,
            name: self.name,
            role: self.role,
            output: self.output,
            program,
        })
    }
}

fn binary_parts(expr: &PlanExpr) -> Option<(&PlanExpr, &PlanExpr, PlanOp)> {
    let parts = match expr {
        PlanExpr::Add { left, right } => (left, right, PlanOp::Add),
        PlanExpr::Sub { left, right } => (left, right, PlanOp::Sub),
        PlanExpr::Mul { left, right } => (left, right, PlanOp::Mul),
        PlanExpr::Min { left, right } => (left, right, PlanOp::Min),
        PlanExpr::Max { left, right } => (left, right, PlanOp::Max),
        PlanExpr::Eq { left, right } => (left, right, PlanOp::Eq),
        PlanExpr::Ne { left, right } => (left, right, PlanOp::Ne),
        PlanExpr::Lt { left, right } => (left, right, PlanOp::Lt),
        PlanExpr::Le { left, right } => (left, right, PlanOp::Le),
        PlanExpr::Gt { left, right } => (left, right, PlanOp::Gt),
        PlanExpr::Ge { left, right } => (left, right, PlanOp::Ge),
        PlanExpr::And { left, right } => (left, right, PlanOp::And),
        PlanExpr::Or { left, right } => (left, right, PlanOp::Or),
        PlanExpr::Field { .. }
        | PlanExpr::Const { .. }
        | PlanExpr::Not { .. }
        | PlanExpr::Abs { .. }
        | PlanExpr::Select { .. } => return None,
    };
    Some((parts.0, parts.1, parts.2))
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
    Select,
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
    Select,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum ValueKind {
    Integer,
    Boolean,
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
    field_count: u16,
    pub hash: String,
}

impl CompiledPlan {
    pub(super) fn op_count(&self) -> usize {
        self.ops.len()
    }

    /// Evaluate one feature row without allocation.
    pub fn evaluate_row(&self, row: &[i64]) -> Result<i64, ControlError> {
        if row.len() != self.field_count as usize {
            return Err(ControlError::Invalid(
                "feature row width does not match compiled plan".into(),
            ));
        }
        self.evaluate_value(row, None)
    }

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
        let mut kinds = [ValueKind::Integer; MAX_PLAN_STACK];
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
                PlanOp::Select => (OpCode::Select, 0, 0, 3),
            };
            if depth < inputs {
                return Err(ControlError::Invalid("plan stack underflow".into()));
            }
            let base = depth - inputs;
            let result_kind = match code {
                OpCode::Field | OpCode::Const => ValueKind::Integer,
                OpCode::Add
                | OpCode::Sub
                | OpCode::Mul
                | OpCode::Min
                | OpCode::Max
                | OpCode::Abs => {
                    if kinds[base..depth]
                        .iter()
                        .any(|kind| *kind != ValueKind::Integer)
                    {
                        return Err(ControlError::Invalid(
                            "arithmetic plan operation requires integers".into(),
                        ));
                    }
                    ValueKind::Integer
                }
                OpCode::Eq | OpCode::Ne => {
                    if kinds[base] != kinds[base + 1] {
                        return Err(ControlError::Invalid(
                            "equality plan operation requires equal sorts".into(),
                        ));
                    }
                    ValueKind::Boolean
                }
                OpCode::Lt | OpCode::Le | OpCode::Gt | OpCode::Ge => {
                    if kinds[base..depth]
                        .iter()
                        .any(|kind| *kind != ValueKind::Integer)
                    {
                        return Err(ControlError::Invalid(
                            "ordered comparison requires integers".into(),
                        ));
                    }
                    ValueKind::Boolean
                }
                OpCode::And | OpCode::Or | OpCode::Not => {
                    if kinds[base..depth]
                        .iter()
                        .any(|kind| *kind != ValueKind::Boolean)
                    {
                        return Err(ControlError::Invalid(
                            "Boolean plan operation requires predicates".into(),
                        ));
                    }
                    ValueKind::Boolean
                }
                OpCode::Select => {
                    if kinds[base] != ValueKind::Boolean || kinds[base + 1] != kinds[base + 2] {
                        return Err(ControlError::Invalid(
                            "select requires a predicate and equal branch sorts".into(),
                        ));
                    }
                    kinds[base + 1]
                }
            };
            let next_depth = depth + 1 - inputs;
            if next_depth > MAX_PLAN_STACK {
                return Err(ControlError::Invalid(
                    "plan stack exceeds fixed evaluator".into(),
                ));
            }
            depth = next_depth;
            kinds[depth - 1] = result_kind;
            stack_needed = stack_needed.max(depth);
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
        let expected_kind = match spec.output {
            PlanOutput::Predicate => ValueKind::Boolean,
            PlanOutput::Score => ValueKind::Integer,
        };
        if kinds[0] != expected_kind {
            return Err(ControlError::Invalid(
                "plan result sort does not match its declared output".into(),
            ));
        }
        let encoded = serde_json::to_vec(spec)?;
        Ok(Self {
            name: spec.name.clone(),
            role: spec.role,
            output: spec.output,
            ops: ops.into_boxed_slice(),
            stack_needed,
            field_count: fields.len() as u16,
            hash: blake3::hash(&encoded).to_hex().to_string(),
        })
    }

    /// Evaluate one row with a fixed stack and no allocation.
    pub(super) fn evaluate_value(
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
                OpCode::Select => {
                    let otherwise = stack[depth - 1];
                    let then = stack[depth - 2];
                    let condition = stack[depth - 3];
                    depth -= 3;
                    if condition != 0 {
                        then
                    } else {
                        otherwise
                    }
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
                        OpCode::Field
                        | OpCode::Const
                        | OpCode::Not
                        | OpCode::Abs
                        | OpCode::Select => unreachable!(),
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
