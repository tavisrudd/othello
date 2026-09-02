//! Bounded, typed feature terms for theorem evolution.
//!
//! Nodes are deterministically hash-consed and carry degree and evaluation-cost
//! bounds. A caller-owned workspace evaluates rows without allocation.

use std::collections::BTreeMap;

use serde::{Deserialize, Serialize};
use thiserror::Error;

pub const FEATURE_DAG_SNAPSHOT_VERSION: u16 = 1;

#[repr(transparent)]
#[derive(Clone, Copy, Debug, Deserialize, Eq, Ord, PartialEq, PartialOrd, Serialize)]
#[serde(transparent)]
pub struct FeatureId(u32);

impl FeatureId {
    pub fn index(self) -> usize {
        self.0 as usize
    }
}

#[derive(Clone, Copy, Debug, Deserialize, Eq, Ord, PartialEq, PartialOrd, Serialize)]
#[serde(tag = "op", rename_all = "kebab-case", deny_unknown_fields)]
pub enum FeatureOp {
    Input { index: u16 },
    Constant { value: i64 },
    Add { left: FeatureId, right: FeatureId },
    Sub { left: FeatureId, right: FeatureId },
    Mul { left: FeatureId, right: FeatureId },
    Mod { source: FeatureId, modulus: u16 },
    Abs { source: FeatureId },
    GaussianNorm { left: FeatureId, right: FeatureId },
    EisensteinNorm { left: FeatureId, right: FeatureId },
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct FeatureNode {
    pub op: FeatureOp,
    pub degree: u8,
    pub evaluation_cost: u32,
}

/// Runtime-selected degree-two expansion over raw scalar inputs.
#[derive(Clone, Copy, Debug)]
pub struct RawFeatureExpansion<'a> {
    pub moduli: &'a [u16],
    pub include_abs: bool,
    pub include_sums: bool,
    pub include_differences: bool,
    pub include_products: bool,
    pub include_gaussian_norms: bool,
    pub include_eisenstein_norms: bool,
    pub include_affine_lifts: bool,
}

/// Stable serialized form of a feature DAG.
#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct FeatureDagSnapshot {
    pub version: u16,
    pub input_count: u16,
    pub maximum_degree: u8,
    pub operations: Box<[FeatureOp]>,
}

impl Default for RawFeatureExpansion<'static> {
    fn default() -> Self {
        Self {
            moduli: &[],
            include_abs: true,
            include_sums: true,
            include_differences: true,
            include_products: true,
            include_gaussian_norms: false,
            include_eisenstein_norms: false,
            include_affine_lifts: false,
        }
    }
}

#[derive(Clone, Copy, Debug, Error, Eq, PartialEq)]
pub enum FeatureDagError {
    #[error("feature DAG bounds must be positive")]
    EmptyBound,
    #[error("feature input index is out of range")]
    InputOutOfRange,
    #[error("feature node belongs to no node in this DAG")]
    UnknownNode,
    #[error("feature term exceeds the configured degree bound")]
    DegreeExceeded,
    #[error("feature DAG reached its configured node bound")]
    NodeLimit,
    #[error("feature evaluation cost overflowed")]
    CostOverflow,
    #[error("feature modulus must be positive")]
    ZeroModulus,
    #[error("feature input row has the wrong width")]
    InputWidth,
    #[error("feature workspace has the wrong capacity")]
    WorkspaceWidth,
    #[error("feature arithmetic overflowed")]
    ArithmeticOverflow,
    #[error("unsupported feature DAG snapshot version")]
    SnapshotVersion,
    #[error("feature DAG snapshot is not topological and canonical")]
    NonCanonicalSnapshot,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct FeatureBankBounds {
    pub maximum_rows: usize,
    pub maximum_bitmap_words: usize,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct FeaturePredicateCensus {
    pub rows: u64,
    pub expected: u64,
    pub surviving: u64,
    pub false_negatives: u64,
}

#[derive(Clone, Copy, Debug, Error, Eq, PartialEq)]
pub enum FeatureBankError {
    #[error("feature-bank bounds must be positive")]
    EmptyBound,
    #[error("feature-bank row matrix has the wrong size")]
    Shape,
    #[error("feature bank exceeds its configured row or bitmap bound")]
    TooLarge,
    #[error("expected-label bitmap has the wrong width")]
    LabelWidth,
    #[error("expected-label bitmap sets bits beyond the row domain")]
    LabelTail,
    #[error(transparent)]
    Evaluation(#[from] FeatureDagError),
}

/// Column-major bitmaps for predicates of the form `feature == 0`.
pub struct FeatureZeroBank {
    rows: usize,
    words: usize,
    features: usize,
    zero: Box<[u64]>,
}

impl FeatureZeroBank {
    pub fn compile(
        dag: &FeatureDag,
        row_values: &[i64],
        bounds: FeatureBankBounds,
    ) -> Result<Self, FeatureBankError> {
        if bounds.maximum_rows == 0 || bounds.maximum_bitmap_words == 0 {
            return Err(FeatureBankError::EmptyBound);
        }
        if row_values.len() % dag.input_count() != 0 {
            return Err(FeatureBankError::Shape);
        }
        let rows = row_values.len() / dag.input_count();
        let words = rows.div_ceil(64);
        let bitmap_words = dag
            .len()
            .checked_mul(words)
            .ok_or(FeatureBankError::TooLarge)?;
        if rows > bounds.maximum_rows || bitmap_words > bounds.maximum_bitmap_words {
            return Err(FeatureBankError::TooLarge);
        }
        let mut zero = vec![0_u64; bitmap_words];
        let mut workspace = dag.workspace();
        for (row, inputs) in row_values.chunks_exact(dag.input_count()).enumerate() {
            let values = dag.evaluate(inputs, &mut workspace)?;
            for (feature, &value) in values.iter().enumerate() {
                zero[feature * words + row / 64] |= u64::from(value == 0) << (row % 64);
            }
        }
        Ok(Self {
            rows,
            words,
            features: dag.len(),
            zero: zero.into_boxed_slice(),
        })
    }

    pub fn rows(&self) -> usize {
        self.rows
    }

    pub fn features(&self) -> usize {
        self.features
    }

    pub fn bitmap_words(&self) -> usize {
        self.zero.len()
    }

    pub fn zero_mask(&self, feature: FeatureId) -> Option<&[u64]> {
        (feature.index() < self.features)
            .then(|| &self.zero[feature.index() * self.words..(feature.index() + 1) * self.words])
    }

    pub fn score_necessary_zero(
        &self,
        feature: FeatureId,
        expected: &[u64],
    ) -> Result<FeaturePredicateCensus, FeatureBankError> {
        if expected.len() != self.words {
            return Err(FeatureBankError::LabelWidth);
        }
        if self.rows % 64 != 0
            && expected
                .last()
                .is_some_and(|&word| word & !((1_u64 << (self.rows % 64)) - 1) != 0)
        {
            return Err(FeatureBankError::LabelTail);
        }
        let selected = self.zero_mask(feature).ok_or(FeatureBankError::Shape)?;
        let mut expected_count = 0_u64;
        let mut surviving = 0_u64;
        let mut false_negatives = 0_u64;
        for (&selected, &expected) in selected.iter().zip(expected) {
            expected_count += u64::from(expected.count_ones());
            surviving += u64::from(selected.count_ones());
            false_negatives += u64::from((expected & !selected).count_ones());
        }
        Ok(FeaturePredicateCensus {
            rows: self.rows as u64,
            expected: expected_count,
            surviving,
            false_negatives,
        })
    }
}

pub struct FeatureDag {
    input_count: u16,
    maximum_degree: u8,
    maximum_nodes: usize,
    nodes: Vec<FeatureNode>,
    interned: BTreeMap<FeatureOp, FeatureId>,
}

impl FeatureDag {
    pub fn new(
        input_count: u16,
        maximum_degree: u8,
        maximum_nodes: usize,
    ) -> Result<Self, FeatureDagError> {
        if input_count == 0 || maximum_degree == 0 || maximum_nodes == 0 {
            return Err(FeatureDagError::EmptyBound);
        }
        Ok(Self {
            input_count,
            maximum_degree,
            maximum_nodes,
            nodes: Vec::with_capacity(maximum_nodes.min(4096)),
            interned: BTreeMap::new(),
        })
    }

    pub fn input_count(&self) -> usize {
        usize::from(self.input_count)
    }

    pub fn len(&self) -> usize {
        self.nodes.len()
    }

    pub fn is_empty(&self) -> bool {
        self.nodes.is_empty()
    }

    pub fn nodes(&self) -> &[FeatureNode] {
        &self.nodes
    }

    pub fn snapshot(&self) -> FeatureDagSnapshot {
        FeatureDagSnapshot {
            version: FEATURE_DAG_SNAPSHOT_VERSION,
            input_count: self.input_count,
            maximum_degree: self.maximum_degree,
            operations: self
                .nodes
                .iter()
                .map(|node| node.op)
                .collect::<Vec<_>>()
                .into_boxed_slice(),
        }
    }

    pub fn from_snapshot(
        snapshot: &FeatureDagSnapshot,
        maximum_nodes: usize,
    ) -> Result<Self, FeatureDagError> {
        if snapshot.version != FEATURE_DAG_SNAPSHOT_VERSION {
            return Err(FeatureDagError::SnapshotVersion);
        }
        if maximum_nodes < snapshot.operations.len() {
            return Err(FeatureDagError::NodeLimit);
        }
        let mut dag = Self::new(snapshot.input_count, snapshot.maximum_degree, maximum_nodes)?;
        for (ordinal, &op) in snapshot.operations.iter().enumerate() {
            let id = match op {
                FeatureOp::Input { index } => dag.input(index)?,
                FeatureOp::Constant { value } => dag.constant(value)?,
                FeatureOp::Add { left, right } => dag.add(left, right)?,
                FeatureOp::Sub { left, right } => dag.sub(left, right)?,
                FeatureOp::Mul { left, right } => dag.mul(left, right)?,
                FeatureOp::Mod { source, modulus } => dag.modulo(source, modulus)?,
                FeatureOp::Abs { source } => dag.abs(source)?,
                FeatureOp::GaussianNorm { left, right } => dag.gaussian_norm(left, right)?,
                FeatureOp::EisensteinNorm { left, right } => dag.eisenstein_norm(left, right)?,
            };
            if id.index() != ordinal || dag.node(id).is_none_or(|node| node.op != op) {
                return Err(FeatureDagError::NonCanonicalSnapshot);
            }
        }
        Ok(dag)
    }

    pub fn node(&self, id: FeatureId) -> Option<&FeatureNode> {
        self.nodes.get(id.index())
    }

    pub fn input(&mut self, index: u16) -> Result<FeatureId, FeatureDagError> {
        if index >= self.input_count {
            return Err(FeatureDagError::InputOutOfRange);
        }
        self.intern(FeatureOp::Input { index }, 1, 1)
    }

    pub fn constant(&mut self, value: i64) -> Result<FeatureId, FeatureDagError> {
        self.intern(FeatureOp::Constant { value }, 0, 1)
    }

    pub fn add(&mut self, left: FeatureId, right: FeatureId) -> Result<FeatureId, FeatureDagError> {
        let (left, right) = ordered(left, right);
        let (degree, cost) = self.binary_metadata(left, right, false, 1)?;
        self.intern(FeatureOp::Add { left, right }, degree, cost)
    }

    pub fn sub(&mut self, left: FeatureId, right: FeatureId) -> Result<FeatureId, FeatureDagError> {
        let (degree, cost) = self.binary_metadata(left, right, false, 1)?;
        self.intern(FeatureOp::Sub { left, right }, degree, cost)
    }

    pub fn mul(&mut self, left: FeatureId, right: FeatureId) -> Result<FeatureId, FeatureDagError> {
        let (left, right) = ordered(left, right);
        let (degree, cost) = self.binary_metadata(left, right, true, 1)?;
        self.intern(FeatureOp::Mul { left, right }, degree, cost)
    }

    pub fn modulo(
        &mut self,
        source: FeatureId,
        modulus: u16,
    ) -> Result<FeatureId, FeatureDagError> {
        if modulus == 0 {
            return Err(FeatureDagError::ZeroModulus);
        }
        let node = self.require(source)?;
        let cost = plus(node.evaluation_cost, 1)?;
        self.intern(FeatureOp::Mod { source, modulus }, node.degree, cost)
    }

    pub fn abs(&mut self, source: FeatureId) -> Result<FeatureId, FeatureDagError> {
        let node = self.require(source)?;
        let cost = plus(node.evaluation_cost, 1)?;
        self.intern(FeatureOp::Abs { source }, node.degree, cost)
    }

    pub fn gaussian_norm(
        &mut self,
        left: FeatureId,
        right: FeatureId,
    ) -> Result<FeatureId, FeatureDagError> {
        let (left, right) = ordered(left, right);
        let (degree, cost) = self.norm_metadata(left, right, 3)?;
        self.intern(FeatureOp::GaussianNorm { left, right }, degree, cost)
    }

    pub fn eisenstein_norm(
        &mut self,
        left: FeatureId,
        right: FeatureId,
    ) -> Result<FeatureId, FeatureDagError> {
        let (left, right) = ordered(left, right);
        let (degree, cost) = self.norm_metadata(left, right, 5)?;
        self.intern(FeatureOp::EisensteinNorm { left, right }, degree, cost)
    }

    /// Expand raw inputs into a deterministic candidate feature bank.
    ///
    /// Every created term is also reduced modulo each requested modulus. The
    /// configured DAG node bound stops an over-large runtime attack surface.
    pub fn expand_raw_degree_two(
        &mut self,
        expansion: RawFeatureExpansion<'_>,
    ) -> Result<Box<[FeatureId]>, FeatureDagError> {
        if expansion.moduli.contains(&0) {
            return Err(FeatureDagError::ZeroModulus);
        }
        let raw = (0..self.input_count)
            .map(|index| self.input(index))
            .collect::<Result<Vec<_>, _>>()?;
        let mut candidates = raw.clone();
        let mut nonlinear = Vec::new();
        for &source in &raw {
            if expansion.include_abs {
                let term = self.abs(source)?;
                self.push_with_residues(term, expansion.moduli, &mut candidates)?;
            }
            for &modulus in expansion.moduli {
                candidates.push(self.modulo(source, modulus)?);
            }
        }
        for (left_index, &left) in raw.iter().enumerate() {
            for (right_index, &right) in raw.iter().enumerate().skip(left_index) {
                if expansion.include_sums {
                    let term = self.add(left, right)?;
                    self.push_with_residues(term, expansion.moduli, &mut candidates)?;
                }
                if expansion.include_products {
                    let term = self.mul(left, right)?;
                    nonlinear.push(term);
                    self.push_with_residues(term, expansion.moduli, &mut candidates)?;
                }
                if expansion.include_gaussian_norms {
                    let term = self.gaussian_norm(left, right)?;
                    nonlinear.push(term);
                    self.push_with_residues(term, expansion.moduli, &mut candidates)?;
                }
                if expansion.include_eisenstein_norms {
                    let term = self.eisenstein_norm(left, right)?;
                    nonlinear.push(term);
                    self.push_with_residues(term, expansion.moduli, &mut candidates)?;
                }
                if expansion.include_differences && left_index != right_index {
                    for (minuend, subtrahend) in [(left, right), (right, left)] {
                        let term = self.sub(minuend, subtrahend)?;
                        self.push_with_residues(term, expansion.moduli, &mut candidates)?;
                    }
                }
            }
        }
        if expansion.include_affine_lifts {
            nonlinear.sort_unstable();
            nonlinear.dedup();
            for term in nonlinear {
                for &source in &raw {
                    for lifted in [
                        self.add(term, source)?,
                        self.sub(term, source)?,
                        self.sub(source, term)?,
                    ] {
                        self.push_with_residues(lifted, expansion.moduli, &mut candidates)?;
                    }
                }
            }
        }
        candidates.sort_unstable();
        candidates.dedup();
        Ok(candidates.into_boxed_slice())
    }

    pub fn workspace(&self) -> FeatureWorkspace {
        FeatureWorkspace {
            values: vec![0; self.nodes.len()],
        }
    }

    pub fn evaluate<'a>(
        &self,
        inputs: &[i64],
        workspace: &'a mut FeatureWorkspace,
    ) -> Result<&'a [i64], FeatureDagError> {
        if inputs.len() != self.input_count() {
            return Err(FeatureDagError::InputWidth);
        }
        if workspace.values.len() != self.nodes.len() {
            return Err(FeatureDagError::WorkspaceWidth);
        }
        for (index, node) in self.nodes.iter().enumerate() {
            let get = |id: FeatureId| workspace.values[id.index()];
            let result = match node.op {
                FeatureOp::Input { index } => inputs[usize::from(index)],
                FeatureOp::Constant { value } => value,
                FeatureOp::Add { left, right } => get(left)
                    .checked_add(get(right))
                    .ok_or(FeatureDagError::ArithmeticOverflow)?,
                FeatureOp::Sub { left, right } => get(left)
                    .checked_sub(get(right))
                    .ok_or(FeatureDagError::ArithmeticOverflow)?,
                FeatureOp::Mul { left, right } => get(left)
                    .checked_mul(get(right))
                    .ok_or(FeatureDagError::ArithmeticOverflow)?,
                FeatureOp::Mod { source, modulus } => get(source).rem_euclid(i64::from(modulus)),
                FeatureOp::Abs { source } => get(source)
                    .checked_abs()
                    .ok_or(FeatureDagError::ArithmeticOverflow)?,
                FeatureOp::GaussianNorm { left, right } => norm(get(left), get(right), false)?,
                FeatureOp::EisensteinNorm { left, right } => norm(get(left), get(right), true)?,
            };
            workspace.values[index] = result;
        }
        Ok(&workspace.values)
    }

    fn require(&self, id: FeatureId) -> Result<FeatureNode, FeatureDagError> {
        self.node(id).copied().ok_or(FeatureDagError::UnknownNode)
    }

    fn push_with_residues(
        &mut self,
        term: FeatureId,
        moduli: &[u16],
        output: &mut Vec<FeatureId>,
    ) -> Result<(), FeatureDagError> {
        output.push(term);
        for &modulus in moduli {
            output.push(self.modulo(term, modulus)?);
        }
        Ok(())
    }

    fn binary_metadata(
        &self,
        left: FeatureId,
        right: FeatureId,
        mul: bool,
        own: u32,
    ) -> Result<(u8, u32), FeatureDagError> {
        let left = self.require(left)?;
        let right = self.require(right)?;
        let degree = if mul {
            left.degree
                .checked_add(right.degree)
                .ok_or(FeatureDagError::DegreeExceeded)?
        } else {
            left.degree.max(right.degree)
        };
        Ok((
            degree,
            plus(plus(left.evaluation_cost, right.evaluation_cost)?, own)?,
        ))
    }

    fn norm_metadata(
        &self,
        left: FeatureId,
        right: FeatureId,
        own: u32,
    ) -> Result<(u8, u32), FeatureDagError> {
        let left = self.require(left)?;
        let right = self.require(right)?;
        let degree = left
            .degree
            .max(right.degree)
            .checked_mul(2)
            .ok_or(FeatureDagError::DegreeExceeded)?;
        Ok((
            degree,
            plus(plus(left.evaluation_cost, right.evaluation_cost)?, own)?,
        ))
    }

    fn intern(
        &mut self,
        op: FeatureOp,
        degree: u8,
        evaluation_cost: u32,
    ) -> Result<FeatureId, FeatureDagError> {
        if degree > self.maximum_degree {
            return Err(FeatureDagError::DegreeExceeded);
        }
        if let Some(&id) = self.interned.get(&op) {
            return Ok(id);
        }
        if self.nodes.len() == self.maximum_nodes || self.nodes.len() > u32::MAX as usize {
            return Err(FeatureDagError::NodeLimit);
        }
        let id = FeatureId(self.nodes.len() as u32);
        self.nodes.push(FeatureNode {
            op,
            degree,
            evaluation_cost,
        });
        self.interned.insert(op, id);
        Ok(id)
    }
}

pub struct FeatureWorkspace {
    values: Vec<i64>,
}

impl FeatureWorkspace {
    pub fn value(&self, id: FeatureId) -> Option<i64> {
        self.values.get(id.index()).copied()
    }
}

fn ordered(left: FeatureId, right: FeatureId) -> (FeatureId, FeatureId) {
    if left <= right {
        (left, right)
    } else {
        (right, left)
    }
}

fn plus(left: u32, right: u32) -> Result<u32, FeatureDagError> {
    left.checked_add(right).ok_or(FeatureDagError::CostOverflow)
}

fn norm(left: i64, right: i64, eisenstein: bool) -> Result<i64, FeatureDagError> {
    let left_square = left
        .checked_mul(left)
        .ok_or(FeatureDagError::ArithmeticOverflow)?;
    let right_square = right
        .checked_mul(right)
        .ok_or(FeatureDagError::ArithmeticOverflow)?;
    let partial = if eisenstein {
        left_square.checked_sub(
            left.checked_mul(right)
                .ok_or(FeatureDagError::ArithmeticOverflow)?,
        )
    } else {
        Some(left_square)
    };
    partial
        .and_then(|value| value.checked_add(right_square))
        .ok_or(FeatureDagError::ArithmeticOverflow)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn interns_commutative_terms_and_enforces_degree() {
        let mut dag = FeatureDag::new(2, 2, 16).unwrap();
        let x = dag.input(0).unwrap();
        let y = dag.input(1).unwrap();
        let xy = dag.mul(x, y).unwrap();
        assert_eq!(xy, dag.mul(y, x).unwrap());
        assert_eq!(dag.node(xy).unwrap().degree, 2);
        assert_eq!(dag.mul(xy, x), Err(FeatureDagError::DegreeExceeded));
    }

    #[test]
    fn evaluates_residues_and_norms_without_rebuilding() {
        let mut dag = FeatureDag::new(2, 2, 16).unwrap();
        let x = dag.input(0).unwrap();
        let y = dag.input(1).unwrap();
        let residue = dag.modulo(x, 7).unwrap();
        let gaussian = dag.gaussian_norm(x, y).unwrap();
        let eisenstein = dag.eisenstein_norm(x, y).unwrap();
        let mut workspace = dag.workspace();
        dag.evaluate(&[-2, 3], &mut workspace).unwrap();
        assert_eq!(workspace.value(residue), Some(5));
        assert_eq!(workspace.value(gaussian), Some(13));
        assert_eq!(workspace.value(eisenstein), Some(19));
    }

    #[test]
    fn rejects_stale_workspace_and_checked_overflow() {
        let mut dag = FeatureDag::new(1, 2, 8).unwrap();
        let x = dag.input(0).unwrap();
        let mut workspace = dag.workspace();
        let _square = dag.mul(x, x).unwrap();
        assert_eq!(
            dag.evaluate(&[2], &mut workspace),
            Err(FeatureDagError::WorkspaceWidth)
        );
        workspace = dag.workspace();
        assert_eq!(
            dag.evaluate(&[i64::MAX], &mut workspace),
            Err(FeatureDagError::ArithmeticOverflow)
        );
    }

    #[test]
    fn prepared_row_evaluation_allocates_nothing() {
        let mut dag = FeatureDag::new(2, 2, 16).unwrap();
        let x = dag.input(0).unwrap();
        let y = dag.input(1).unwrap();
        let _residue = dag.modulo(x, 7).unwrap();
        let _norm = dag.eisenstein_norm(x, y).unwrap();
        let mut workspace = dag.workspace();
        let (result, events) = crate::test_alloc::measure_current_thread_allocations(|| {
            dag.evaluate(&[11, -4], &mut workspace).map(|_| ())
        });
        result.unwrap();
        assert_eq!(events, crate::test_alloc::AllocationEvents::default());
    }

    #[test]
    fn runtime_expansion_builds_raw_degree_two_bank() {
        let mut dag = FeatureDag::new(2, 2, 128).unwrap();
        let candidates = dag
            .expand_raw_degree_two(RawFeatureExpansion {
                moduli: &[3, 7],
                include_gaussian_norms: true,
                include_eisenstein_norms: true,
                ..RawFeatureExpansion::default()
            })
            .unwrap();
        assert!(candidates.len() > 20);
        assert!(dag
            .nodes()
            .iter()
            .any(|node| matches!(node.op, FeatureOp::Mod { modulus: 7, .. })));
        assert!(dag
            .nodes()
            .iter()
            .any(|node| matches!(node.op, FeatureOp::EisensteinNorm { .. })));
        assert!(dag.nodes().iter().all(|node| node.degree <= 2));
    }

    #[test]
    fn snapshot_round_trip_preserves_ids_and_values() {
        let mut dag = FeatureDag::new(2, 2, 128).unwrap();
        dag.expand_raw_degree_two(RawFeatureExpansion {
            moduli: &[5],
            include_eisenstein_norms: true,
            ..RawFeatureExpansion::default()
        })
        .unwrap();
        let encoded = serde_json::to_vec(&dag.snapshot()).unwrap();
        let snapshot: FeatureDagSnapshot = serde_json::from_slice(&encoded).unwrap();
        let restored = FeatureDag::from_snapshot(&snapshot, 128).unwrap();
        assert_eq!(restored.nodes(), dag.nodes());
        let mut left = dag.workspace();
        let mut right = restored.workspace();
        assert_eq!(
            dag.evaluate(&[-9, 4], &mut left).unwrap(),
            restored.evaluate(&[-9, 4], &mut right).unwrap()
        );
    }

    #[test]
    fn snapshot_rejects_duplicate_and_future_nodes() {
        let duplicate = FeatureDagSnapshot {
            version: FEATURE_DAG_SNAPSHOT_VERSION,
            input_count: 1,
            maximum_degree: 2,
            operations: vec![FeatureOp::Input { index: 0 }; 2].into_boxed_slice(),
        };
        assert!(matches!(
            FeatureDag::from_snapshot(&duplicate, 8),
            Err(FeatureDagError::NonCanonicalSnapshot)
        ));
        let future = FeatureDagSnapshot {
            version: FEATURE_DAG_SNAPSHOT_VERSION,
            input_count: 1,
            maximum_degree: 2,
            operations: vec![FeatureOp::Abs {
                source: FeatureId(1),
            }]
            .into_boxed_slice(),
        };
        assert!(matches!(
            FeatureDag::from_snapshot(&future, 8),
            Err(FeatureDagError::UnknownNode)
        ));
    }

    #[test]
    fn zero_bank_scores_necessary_predicates_from_bitmaps() {
        let mut dag = FeatureDag::new(1, 2, 8).unwrap();
        let x = dag.input(0).unwrap();
        let bank = FeatureZeroBank::compile(
            &dag,
            &[-2, 0, 3],
            FeatureBankBounds {
                maximum_rows: 3,
                maximum_bitmap_words: 1,
            },
        )
        .unwrap();
        assert_eq!(bank.zero_mask(x), Some(&[0b010][..]));
        let census = bank.score_necessary_zero(x, &[0b010]).unwrap();
        assert_eq!(
            census,
            FeaturePredicateCensus {
                rows: 3,
                expected: 1,
                surviving: 1,
                false_negatives: 0,
            }
        );
        assert_eq!(
            bank.score_necessary_zero(x, &[1_u64 << 63]),
            Err(FeatureBankError::LabelTail)
        );
    }

    #[test]
    fn zero_bank_rescoring_allocates_nothing() {
        let mut dag = FeatureDag::new(2, 2, 64).unwrap();
        let candidates = dag
            .expand_raw_degree_two(RawFeatureExpansion {
                moduli: &[3],
                ..RawFeatureExpansion::default()
            })
            .unwrap();
        let rows = (0_i64..32)
            .flat_map(|left| [left, 31 - left])
            .collect::<Vec<_>>();
        let bank = FeatureZeroBank::compile(
            &dag,
            &rows,
            FeatureBankBounds {
                maximum_rows: 32,
                maximum_bitmap_words: dag.len(),
            },
        )
        .unwrap();
        let expected = [0x0000_0000_0000_ffff];
        let (_, events) = crate::test_alloc::measure_current_thread_allocations(|| {
            for &candidate in candidates.iter() {
                std::hint::black_box(bank.score_necessary_zero(candidate, &expected).unwrap());
            }
        });
        assert_eq!(events, crate::test_alloc::AllocationEvents::default());
    }
}
