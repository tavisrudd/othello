use super::{ControlError, DATA_SCHEMA, MAX_PLAN_OPS, MAX_PLAN_STACK, PLAN_SCHEMA};
use crate::multiset::{compile_bounded_multiset_aggregates, MultisetBounds, MultisetStatistic};
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use std::collections::BTreeMap;
use std::fs::File;
use std::io::{BufRead, BufReader, Write};
use std::mem::MaybeUninit;
use std::path::Path;

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct DataHeader {
    schema: String,
    presentation: String,
    problem: String,
    fields: Vec<String>,
    rows: usize,
    #[serde(default)]
    generator: Option<FeatureGeneratorProvenance>,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)]
pub struct FeatureGeneratorProvenance {
    pub name: String,
    pub version: String,
    pub digest: String,
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
    pub generator: Option<FeatureGeneratorProvenance>,
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
        if header.generator.as_ref().is_some_and(|generator| {
            generator.name.is_empty()
                || generator.version.is_empty()
                || generator.digest.len() != 64
                || !generator
                    .digest
                    .bytes()
                    .all(|byte| byte.is_ascii_hexdigit())
        }) {
            return Err(ControlError::Invalid(
                "invalid feature-generator provenance".into(),
            ));
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
            generator: header.generator,
            row_ids: row_ids.into_boxed_slice(),
            weights: weights.into_boxed_slice(),
            expected: expected.into_boxed_slice(),
            values: values.into_boxed_slice(),
        })
    }

    pub fn rows(&self) -> usize {
        self.row_ids.len()
    }

    /// Stream this frozen batch in the stable campaign-data format.
    pub fn write_jsonl(&self, mut output: impl Write) -> Result<(), ControlError> {
        serde_json::to_writer(
            &mut output,
            &json!({
                "schema": DATA_SCHEMA,
                "presentation": self.presentation,
                "problem": self.problem,
                "fields": self.fields,
                "rows": self.rows(),
                "generator": self.generator,
            }),
        )?;
        output.write_all(b"\n")?;
        for row in 0..self.rows() {
            serde_json::to_writer(
                &mut output,
                &json!({
                    "id": self.row_ids[row],
                    "weight": self.weights[row],
                    "expected": self.expected(row),
                    "values": self.row(row),
                }),
            )?;
            output.write_all(b"\n")?;
        }
        Ok(())
    }

    /// Compile one permutation-invariant row per value of `group_field`.
    ///
    /// Labels must be uniform within each group.  Every resulting parent row
    /// has weight one; child multiplicity is available explicitly through a
    /// `Count` statistic.  This is a cold transformation, after which plans
    /// use the unchanged allocation-free row evaluator.
    pub fn aggregate_uniform_groups(
        &self,
        group_field: usize,
        statistics: &[MultisetStatistic],
        bounds: MultisetBounds,
    ) -> Result<Self, ControlError> {
        if group_field >= self.fields.len() {
            return Err(ControlError::Invalid(
                "unknown aggregate group field".into(),
            ));
        }
        let group_keys = (0..self.rows())
            .map(|row| self.row(row)[group_field])
            .collect::<Vec<_>>();
        let table = compile_bounded_multiset_aggregates(
            &group_keys,
            &self.values,
            self.fields.len(),
            statistics,
            bounds,
        )
        .map_err(|error| ControlError::Invalid(error.to_string()))?;

        let mut labels = BTreeMap::<i64, bool>::new();
        for (row, &key) in group_keys.iter().enumerate() {
            let expected = self.expected(row);
            if labels
                .insert(key, expected)
                .is_some_and(|prior| prior != expected)
            {
                return Err(ControlError::Invalid(
                    "aggregate groups require uniform expected labels".into(),
                ));
            }
        }
        let mut fields = Vec::with_capacity(statistics.len());
        for statistic in statistics {
            fields.push(match *statistic {
                MultisetStatistic::Count => "group-count".into(),
                MultisetStatistic::Sum { field } => format!("group-sum:{}", self.fields[field]),
                MultisetStatistic::Minimum { field } => {
                    format!("group-min:{}", self.fields[field])
                }
                MultisetStatistic::Maximum { field } => {
                    format!("group-max:{}", self.fields[field])
                }
            });
        }
        let mut values = Vec::with_capacity(table.values().len());
        let mut expected = vec![0_u64; table.groups().div_ceil(64)];
        for group in 0..table.groups() {
            let key = table.group_key(group);
            values.extend_from_slice(table.row(group));
            if labels[&key] {
                expected[group / 64] |= 1_u64 << (group % 64);
            }
        }
        let mut digest = blake3::Hasher::new();
        for key in table.group_keys() {
            digest.update(&key.to_le_bytes());
        }
        for value in table.values() {
            digest.update(&value.to_le_bytes());
        }
        Ok(Self {
            presentation: format!("{}:grouped", self.presentation),
            problem: self.problem.clone(),
            fields: fields.into_boxed_slice(),
            generator: Some(FeatureGeneratorProvenance {
                name: "ergodis-bounded-multiset".into(),
                version: env!("CARGO_PKG_VERSION").into(),
                digest: digest.finalize().to_hex().to_string(),
            }),
            row_ids: table
                .group_keys()
                .iter()
                .map(|key| u64::from_le_bytes(key.to_le_bytes()))
                .collect::<Vec<_>>()
                .into_boxed_slice(),
            weights: vec![1_u64; table.groups()].into_boxed_slice(),
            expected: expected.into_boxed_slice(),
            values: values.into_boxed_slice(),
        })
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
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub scope: Option<PlanScope>,
    pub program: Vec<PlanOp>,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct PlanScope {
    pub field: String,
    pub mask: u64,
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
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub scope: Option<PlanScope>,
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
            scope: self.scope,
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
    Bool { value: bool },
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
    Bool,
    FieldEqConst,
    FieldNeConst,
    FieldLtConst,
    FieldLeConst,
    FieldGtConst,
    FieldGeConst,
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

const MAX_TRUTH_TABLE_LEAVES: usize = 6;
const TRUTH_COLUMNS: [u64; MAX_TRUTH_TABLE_LEAVES] = [
    0xaaaa_aaaa_aaaa_aaaa,
    0xcccc_cccc_cccc_cccc,
    0xf0f0_f0f0_f0f0_f0f0,
    0xff00_ff00_ff00_ff00,
    0xffff_0000_ffff_0000,
    0xffff_ffff_0000_0000,
];

#[repr(u8)]
#[derive(Clone, Copy, Debug)]
enum ComparisonCode {
    Eq,
    Ne,
    Lt,
    Le,
    Gt,
    Ge,
}

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct PredicateLeaf {
    value: i64,
    field: u16,
    code: ComparisonCode,
    _pad: [u8; 5],
}

const _: () = assert!(std::mem::size_of::<PredicateLeaf>() == 16);
const _: () = assert!(std::mem::align_of::<PredicateLeaf>() == 8);

impl PredicateLeaf {
    #[inline(always)]
    fn evaluate(self, row: &[i64]) -> usize {
        let field = row[self.field as usize];
        usize::from(match self.code {
            ComparisonCode::Eq => field == self.value,
            ComparisonCode::Ne => field != self.value,
            ComparisonCode::Lt => field < self.value,
            ComparisonCode::Le => field <= self.value,
            ComparisonCode::Gt => field > self.value,
            ComparisonCode::Ge => field >= self.value,
        })
    }
}

#[repr(C)]
#[derive(Clone, Debug)]
struct CompiledPredicate {
    leaves: Box<[PredicateLeaf]>,
    truth_table: u64,
}

const _: () = assert!(std::mem::size_of::<CompiledPredicate>() == 24);
const _: () = assert!(std::mem::align_of::<CompiledPredicate>() == 8);

impl CompiledPredicate {
    #[inline(always)]
    fn evaluate(&self, row: &[i64]) -> i64 {
        let mut assignment = 0usize;
        for (index, &leaf) in self.leaves.iter().enumerate() {
            assignment |= leaf.evaluate(row) << index;
        }
        ((self.truth_table >> assignment) & 1) as i64
    }
}

fn fused_field_constant_comparison(code: OpCode, reverse: bool) -> Option<OpCode> {
    Some(match (code, reverse) {
        (OpCode::Eq, _) => OpCode::FieldEqConst,
        (OpCode::Ne, _) => OpCode::FieldNeConst,
        (OpCode::Lt, false) | (OpCode::Gt, true) => OpCode::FieldLtConst,
        (OpCode::Le, false) | (OpCode::Ge, true) => OpCode::FieldLeConst,
        (OpCode::Gt, false) | (OpCode::Lt, true) => OpCode::FieldGtConst,
        (OpCode::Ge, false) | (OpCode::Le, true) => OpCode::FieldGeConst,
        _ => return None,
    })
}

fn fuse_field_constant_comparisons(ops: &[CompiledOp]) -> Vec<CompiledOp> {
    let mut fused = Vec::with_capacity(ops.len());
    let mut cursor = 0;
    while cursor < ops.len() {
        if let Some(window) = ops.get(cursor..cursor + 3) {
            let operands = match (window[0].code, window[1].code) {
                (OpCode::Field, OpCode::Const) => Some((window[0].field, window[1].value, false)),
                (OpCode::Const, OpCode::Field) => Some((window[1].field, window[0].value, true)),
                _ => None,
            };
            if let Some((field, value, reverse)) = operands {
                if let Some(code) = fused_field_constant_comparison(window[2].code, reverse) {
                    fused.push(CompiledOp {
                        value,
                        field,
                        code,
                        _pad: [0; 5],
                    });
                    cursor += 3;
                    continue;
                }
            }
        }
        fused.push(ops[cursor]);
        cursor += 1;
    }
    fused
}

fn comparison_code(code: OpCode) -> Option<ComparisonCode> {
    Some(match code {
        OpCode::FieldEqConst => ComparisonCode::Eq,
        OpCode::FieldNeConst => ComparisonCode::Ne,
        OpCode::FieldLtConst => ComparisonCode::Lt,
        OpCode::FieldLeConst => ComparisonCode::Le,
        OpCode::FieldGtConst => ComparisonCode::Gt,
        OpCode::FieldGeConst => ComparisonCode::Ge,
        _ => return None,
    })
}

/// Compile a small pure predicate to its exact Boolean response table.
///
/// Six leaves cover the complete table in one `u64`. Larger or mixed-sort
/// programs keep the ordinary stack evaluator rather than changing semantics.
fn compile_truth_table_predicate(ops: &[CompiledOp]) -> Option<CompiledPredicate> {
    let mut leaves = Vec::with_capacity(MAX_TRUTH_TABLE_LEAVES);
    let mut stack = [0u64; MAX_PLAN_STACK];
    let mut depth = 0usize;
    for op in ops {
        let result = if let Some(code) = comparison_code(op.code) {
            if leaves.len() == MAX_TRUTH_TABLE_LEAVES {
                return None;
            }
            let leaf_index = leaves.len();
            leaves.push(PredicateLeaf {
                value: op.value,
                field: op.field,
                code,
                _pad: [0; 5],
            });
            TRUTH_COLUMNS[leaf_index]
        } else {
            match op.code {
                OpCode::Bool => {
                    if op.value != 0 {
                        u64::MAX
                    } else {
                        0
                    }
                }
                OpCode::Not => {
                    stack[depth - 1] = !stack[depth - 1];
                    continue;
                }
                OpCode::And | OpCode::Or => {
                    let right = stack[depth - 1];
                    let left = stack[depth - 2];
                    depth -= 2;
                    if matches!(op.code, OpCode::And) {
                        left & right
                    } else {
                        left | right
                    }
                }
                _ => return None,
            }
        };
        stack[depth] = result;
        depth += 1;
    }
    (depth == 1).then(|| CompiledPredicate {
        leaves: leaves.into_boxed_slice(),
        truth_table: stack[0],
    })
}

#[inline(always)]
unsafe fn read_plan_stack(stack: &[MaybeUninit<i64>; MAX_PLAN_STACK], index: usize) -> i64 {
    // SAFETY: callers use only indices below the validated bytecode depth.
    unsafe { stack[index].assume_init() }
}

#[derive(Clone, Debug)]
pub struct CompiledPlan {
    pub name: String,
    pub role: PlanRole,
    pub output: PlanOutput,
    ops: Box<[CompiledOp]>,
    fast_ops: Box<[CompiledOp]>,
    fast_predicate: Option<CompiledPredicate>,
    stack_needed: usize,
    field_count: u16,
    scope_field: u16,
    scope_mask: u64,
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
        self.evaluate_value_untraced(row)
    }

    #[inline(always)]
    pub fn applies(&self, row: &[i64]) -> bool {
        if self.scope_field == u16::MAX {
            return true;
        }
        let value = row[self.scope_field as usize];
        (0..64).contains(&value) && self.scope_mask >> value & 1 != 0
    }

    pub fn scope_descriptor(&self) -> Option<(usize, u64)> {
        (self.scope_field != u16::MAX).then_some((self.scope_field as usize, self.scope_mask))
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
        let (scope_field, scope_mask) = if let Some(scope) = &spec.scope {
            let field = *index.get(scope.field.as_str()).ok_or_else(|| {
                ControlError::Invalid(format!("unknown scope feature {:?}", scope.field))
            })?;
            if scope.mask == 0 {
                return Err(ControlError::Invalid("plan scope mask is empty".into()));
            }
            (field as u16, scope.mask)
        } else {
            (u16::MAX, u64::MAX)
        };
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
                PlanOp::Bool { value } => (OpCode::Bool, i64::from(*value), 0, 0),
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
                OpCode::Bool => ValueKind::Boolean,
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
                OpCode::FieldEqConst
                | OpCode::FieldNeConst
                | OpCode::FieldLtConst
                | OpCode::FieldLeConst
                | OpCode::FieldGtConst
                | OpCode::FieldGeConst => unreachable!("fused op appears only after validation"),
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
        // The display name is ledger metadata, not executable semantics.
        let encoded = serde_json::to_vec(&(
            PLAN_SCHEMA,
            spec.role,
            spec.output,
            spec.scope.as_ref().map(|scope| (&scope.field, scope.mask)),
            spec.program.as_slice(),
        ))?;
        let fast_ops = fuse_field_constant_comparisons(&ops).into_boxed_slice();
        let fast_predicate = compile_truth_table_predicate(&fast_ops);
        Ok(Self {
            name: spec.name.clone(),
            role: spec.role,
            output: spec.output,
            ops: ops.into_boxed_slice(),
            fast_ops,
            fast_predicate,
            stack_needed,
            field_count: fields.len() as u16,
            scope_field,
            scope_mask,
            hash: blake3::hash(&encoded).to_hex().to_string(),
        })
    }

    #[inline]
    pub(super) fn evaluate_value_untraced(&self, row: &[i64]) -> Result<i64, ControlError> {
        if let Some(predicate) = &self.fast_predicate {
            return Ok(if self.applies(row) {
                predicate.evaluate(row)
            } else {
                0
            });
        }
        self.evaluate_value_impl::<false>(row, None)
    }

    /// Evaluate one row with a fixed stack and optional diagnostic tracing.
    pub(super) fn evaluate_value(
        &self,
        row: &[i64],
        trace: Option<&mut Vec<i64>>,
    ) -> Result<i64, ControlError> {
        match trace {
            Some(values) => self.evaluate_value_impl::<true>(row, Some(values)),
            None => self.evaluate_value_untraced(row),
        }
    }

    fn evaluate_value_impl<const TRACE: bool>(
        &self,
        row: &[i64],
        trace: Option<&mut Vec<i64>>,
    ) -> Result<i64, ControlError> {
        if !self.applies(row) {
            return Ok(0);
        }
        let mut stack = [MaybeUninit::<i64>::uninit(); MAX_PLAN_STACK];
        let mut depth = 0usize;
        let mut trace = trace;
        let ops = if TRACE { &self.ops } else { &self.fast_ops };
        for op in ops {
            let result = match op.code {
                OpCode::Field => row[op.field as usize],
                OpCode::Const => op.value,
                OpCode::Bool => op.value,
                OpCode::FieldEqConst => i64::from(row[op.field as usize] == op.value),
                OpCode::FieldNeConst => i64::from(row[op.field as usize] != op.value),
                OpCode::FieldLtConst => i64::from(row[op.field as usize] < op.value),
                OpCode::FieldLeConst => i64::from(row[op.field as usize] <= op.value),
                OpCode::FieldGtConst => i64::from(row[op.field as usize] > op.value),
                OpCode::FieldGeConst => i64::from(row[op.field as usize] >= op.value),
                OpCode::Not => {
                    // Compiled stack discipline proves this slot initialized.
                    let result = i64::from(unsafe { read_plan_stack(&stack, depth - 1) } == 0);
                    stack[depth - 1].write(result);
                    if TRACE {
                        trace
                            .as_deref_mut()
                            .expect("traced evaluator has a trace sink")
                            .push(result);
                    }
                    continue;
                }
                OpCode::Abs => {
                    // Compiled stack discipline proves this slot initialized.
                    let result = unsafe { read_plan_stack(&stack, depth - 1) }
                        .checked_abs()
                        .ok_or_else(|| {
                            ControlError::Invalid("arithmetic overflow in plan".into())
                        })?;
                    stack[depth - 1].write(result);
                    if TRACE {
                        trace
                            .as_deref_mut()
                            .expect("traced evaluator has a trace sink")
                            .push(result);
                    }
                    continue;
                }
                OpCode::Select => {
                    // Compiled stack discipline proves all three slots initialized.
                    let otherwise = unsafe { read_plan_stack(&stack, depth - 1) };
                    let then = unsafe { read_plan_stack(&stack, depth - 2) };
                    let condition = unsafe { read_plan_stack(&stack, depth - 3) };
                    depth -= 3;
                    if condition != 0 {
                        then
                    } else {
                        otherwise
                    }
                }
                code => {
                    // Compiled stack discipline proves both operand slots initialized.
                    let right = unsafe { read_plan_stack(&stack, depth - 1) };
                    let left = unsafe { read_plan_stack(&stack, depth - 2) };
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
                        | OpCode::Bool
                        | OpCode::Not
                        | OpCode::Abs
                        | OpCode::Select
                        | OpCode::FieldEqConst
                        | OpCode::FieldNeConst
                        | OpCode::FieldLtConst
                        | OpCode::FieldLeConst
                        | OpCode::FieldGtConst
                        | OpCode::FieldGeConst => unreachable!(),
                    }
                }
            };
            stack[depth].write(result);
            depth += 1;
            if TRACE {
                trace
                    .as_deref_mut()
                    .expect("traced evaluator has a trace sink")
                    .push(result);
            }
        }
        debug_assert_eq!(depth, 1);
        debug_assert!(self.stack_needed <= MAX_PLAN_STACK);
        // A valid plan leaves exactly one initialized result.
        Ok(unsafe { read_plan_stack(&stack, 0) })
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
    let (evaluation, _) = evaluate_plan_cascaded(batch, plan, None)?;
    Ok(evaluation.expect("an uncensored evaluation always completes"))
}

/// Evaluate in fixed row blocks and stop only when `can_enter` proves that no
/// completion of the unseen rows can enter the current survivor set.
pub(super) fn evaluate_plan_cascaded(
    batch: &FeatureBatch,
    plan: &CompiledPlan,
    can_enter: Option<&dyn Fn(u64, u64) -> bool>,
) -> Result<(Option<Evaluation>, usize), ControlError> {
    let total_weight = batch
        .weights
        .iter()
        .try_fold(0_u64, |sum, &weight| sum.checked_add(weight))
        .ok_or_else(|| ControlError::Invalid("campaign weight overflow".into()))?;
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
        let value = plan.evaluate_value_untraced(batch.row(row))?;
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
        let rows_evaluated = row + 1;
        if rows_evaluated % 64 == 0 && rows_evaluated != batch.rows() {
            let remaining_weight = total_weight.saturating_sub(result.weighted_rows);
            let maximum_correct = result.weighted_correct.saturating_add(remaining_weight);
            if can_enter.is_some_and(|gate| !gate(result.weighted_false_positive, maximum_correct))
            {
                return Ok((None, rows_evaluated));
            }
        }
    }
    if plan.output == PlanOutput::Predicate && outcome_bits != 0 {
        outcome_hasher.update(&outcome_word.to_le_bytes());
    }
    result.outcome_hash = outcome_hasher.finalize().to_hex().to_string();
    Ok((Some(result), batch.rows()))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn compile_test_plan(program: Vec<PlanOp>, output: PlanOutput) -> CompiledPlan {
        CompiledPlan::compile(
            &PlanSpec {
                schema: PLAN_SCHEMA.to_owned(),
                name: "stack-safety-test".to_owned(),
                role: PlanRole::Diagnostic,
                output,
                scope: None,
                program,
            },
            &["x".to_owned()],
        )
        .unwrap()
    }

    fn assert_traced_untraced(
        program: Vec<PlanOp>,
        output: PlanOutput,
        row: &[i64],
        expected: i64,
    ) {
        let plan = compile_test_plan(program, output);
        let mut trace = Vec::with_capacity(plan.ops.len());
        assert_eq!(
            plan.evaluate_value(row, Some(&mut trace)).unwrap(),
            expected
        );
        assert_eq!(plan.evaluate_value_untraced(row).unwrap(), expected);
        assert_eq!(trace.len(), plan.ops.len());
    }

    #[test]
    fn fixed_stack_covers_every_opcode_shape() {
        let integers = [
            (PlanOp::Add, 10),
            (PlanOp::Sub, 4),
            (PlanOp::Mul, 21),
            (PlanOp::Min, 3),
            (PlanOp::Max, 7),
        ];
        for (op, expected) in integers {
            assert_traced_untraced(
                vec![PlanOp::Const { value: 7 }, PlanOp::Const { value: 3 }, op],
                PlanOutput::Score,
                &[11],
                expected,
            );
        }

        let comparisons = [
            (PlanOp::Eq, 0),
            (PlanOp::Ne, 1),
            (PlanOp::Lt, 0),
            (PlanOp::Le, 0),
            (PlanOp::Gt, 1),
            (PlanOp::Ge, 1),
        ];
        for (op, expected) in comparisons {
            assert_traced_untraced(
                vec![PlanOp::Const { value: 7 }, PlanOp::Const { value: 3 }, op],
                PlanOutput::Predicate,
                &[11],
                expected,
            );
        }

        for (op, expected) in [(PlanOp::And, 0), (PlanOp::Or, 1)] {
            assert_traced_untraced(
                vec![
                    PlanOp::Bool { value: true },
                    PlanOp::Bool { value: false },
                    op,
                ],
                PlanOutput::Predicate,
                &[11],
                expected,
            );
        }
        assert_traced_untraced(
            vec![PlanOp::Bool { value: false }, PlanOp::Not],
            PlanOutput::Predicate,
            &[11],
            1,
        );
        assert_traced_untraced(
            vec![PlanOp::Const { value: -7 }, PlanOp::Abs],
            PlanOutput::Score,
            &[11],
            7,
        );
        assert_traced_untraced(
            vec![
                PlanOp::Bool { value: true },
                PlanOp::Field {
                    name: "x".to_owned(),
                },
                PlanOp::Const { value: 3 },
                PlanOp::Select,
            ],
            PlanOutput::Score,
            &[11],
            11,
        );
    }

    #[test]
    fn fixed_stack_reaches_the_validated_maximum_depth() {
        let mut program = Vec::with_capacity(2 * MAX_PLAN_STACK - 1);
        program.extend((0..MAX_PLAN_STACK).map(|_| PlanOp::Const { value: 1 }));
        program.extend((1..MAX_PLAN_STACK).map(|_| PlanOp::Add));
        let plan = compile_test_plan(program, PlanOutput::Score);
        assert_eq!(plan.stack_needed, MAX_PLAN_STACK);
        let mut trace = Vec::with_capacity(plan.ops.len());
        assert_eq!(
            plan.evaluate_value(&[0], Some(&mut trace)).unwrap(),
            MAX_PLAN_STACK as i64
        );
        assert_eq!(
            plan.evaluate_value_untraced(&[0]).unwrap(),
            MAX_PLAN_STACK as i64
        );
        assert_eq!(trace.len(), 2 * MAX_PLAN_STACK - 1);
    }

    #[test]
    fn fixed_stack_preserves_arithmetic_errors() {
        for program in [
            vec![
                PlanOp::Const { value: i64::MAX },
                PlanOp::Const { value: 1 },
                PlanOp::Add,
            ],
            vec![PlanOp::Const { value: i64::MIN }, PlanOp::Abs],
        ] {
            let plan = compile_test_plan(program, PlanOutput::Score);
            let mut trace = Vec::new();
            assert!(plan.evaluate_value(&[0], Some(&mut trace)).is_err());
            assert!(plan.evaluate_value_untraced(&[0]).is_err());
        }
    }

    #[test]
    fn truth_table_predicate_matches_source_trace_exhaustively() {
        let program = vec![
            PlanOp::Field {
                name: "x".to_owned(),
            },
            PlanOp::Const { value: 0 },
            PlanOp::Gt,
            PlanOp::Field {
                name: "y".to_owned(),
            },
            PlanOp::Const { value: 0 },
            PlanOp::Gt,
            PlanOp::And,
            PlanOp::Field {
                name: "z".to_owned(),
            },
            PlanOp::Const { value: 0 },
            PlanOp::Lt,
            PlanOp::Or,
        ];
        let plan = CompiledPlan::compile(
            &PlanSpec {
                schema: PLAN_SCHEMA.to_owned(),
                name: "truth-table-test".to_owned(),
                role: PlanRole::Diagnostic,
                output: PlanOutput::Predicate,
                scope: None,
                program,
            },
            &["x".to_owned(), "y".to_owned(), "z".to_owned()],
        )
        .unwrap();
        let predicate = plan.fast_predicate.as_ref().unwrap();
        assert_eq!(predicate.leaves.len(), 3);
        assert_eq!(plan.fast_ops.len(), 5);
        for x in -1..=1 {
            for y in -1..=1 {
                for z in -1..=1 {
                    let row = [x, y, z];
                    let expected = i64::from(((x > 0) & (y > 0)) | (z < 0));
                    let mut trace = Vec::new();
                    assert_eq!(
                        plan.evaluate_value(&row, Some(&mut trace)).unwrap(),
                        expected
                    );
                    assert_eq!(plan.evaluate_value_untraced(&row).unwrap(), expected);
                    assert_eq!(trace.len(), plan.ops.len());
                }
            }
        }
    }

    #[test]
    fn truth_table_predicate_accepts_six_leaves_and_falls_back_above_it() {
        for leaf_count in [MAX_TRUTH_TABLE_LEAVES, MAX_TRUTH_TABLE_LEAVES + 1] {
            let mut program = Vec::new();
            for _ in 0..leaf_count {
                program.extend([
                    PlanOp::Field {
                        name: "x".to_owned(),
                    },
                    PlanOp::Const { value: 0 },
                    PlanOp::Gt,
                ]);
            }
            program.extend((1..leaf_count).map(|_| PlanOp::And));
            let plan = compile_test_plan(program, PlanOutput::Predicate);
            assert_eq!(
                plan.fast_predicate.is_some(),
                leaf_count == MAX_TRUTH_TABLE_LEAVES
            );
            for value in [-1, 1] {
                let mut trace = Vec::new();
                let traced = plan.evaluate_value(&[value], Some(&mut trace)).unwrap();
                assert_eq!(plan.evaluate_value_untraced(&[value]).unwrap(), traced);
            }
        }
    }

    #[test]
    fn fused_field_constant_comparisons_match_traced_programs() {
        let fields = vec!["x".to_owned()];
        let comparisons = [
            PlanOp::Eq,
            PlanOp::Ne,
            PlanOp::Lt,
            PlanOp::Le,
            PlanOp::Gt,
            PlanOp::Ge,
        ];
        for reverse in [false, true] {
            for comparison in comparisons.clone() {
                let mut program = Vec::with_capacity(3);
                if reverse {
                    program.push(PlanOp::Const { value: 1 });
                    program.push(PlanOp::Field {
                        name: "x".to_owned(),
                    });
                } else {
                    program.push(PlanOp::Field {
                        name: "x".to_owned(),
                    });
                    program.push(PlanOp::Const { value: 1 });
                }
                program.push(comparison);
                let plan = CompiledPlan::compile(
                    &PlanSpec {
                        schema: PLAN_SCHEMA.to_owned(),
                        name: "fusion-test".to_owned(),
                        role: PlanRole::Diagnostic,
                        output: PlanOutput::Predicate,
                        scope: None,
                        program,
                    },
                    &fields,
                )
                .unwrap();
                assert_eq!(plan.ops.len(), 3);
                assert_eq!(plan.fast_ops.len(), 1);
                for value in [-2, 0, 1, 2] {
                    let mut trace = Vec::new();
                    let traced = plan.evaluate_value(&[value], Some(&mut trace)).unwrap();
                    assert_eq!(plan.evaluate_value_untraced(&[value]).unwrap(), traced);
                    assert_eq!(trace.len(), 3);
                }
            }
        }
    }
}
