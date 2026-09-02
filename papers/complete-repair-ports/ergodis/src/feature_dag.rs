//! Bounded, typed feature terms for theorem evolution.
//!
//! Nodes are deterministically hash-consed and carry degree and evaluation-cost
//! bounds. A caller-owned workspace evaluates rows without allocation.

use std::collections::BTreeMap;

use thiserror::Error;

#[repr(transparent)]
#[derive(Clone, Copy, Debug, Eq, Ord, PartialEq, PartialOrd)]
pub struct FeatureId(u32);

impl FeatureId {
    pub fn index(self) -> usize {
        self.0 as usize
    }
}

#[derive(Clone, Copy, Debug, Eq, Ord, PartialEq, PartialOrd)]
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
                    self.push_with_residues(term, expansion.moduli, &mut candidates)?;
                }
                if expansion.include_gaussian_norms {
                    let term = self.gaussian_norm(left, right)?;
                    self.push_with_residues(term, expansion.moduli, &mut candidates)?;
                }
                if expansion.include_eisenstein_norms {
                    let term = self.eisenstein_norm(left, right)?;
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
}
