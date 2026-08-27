use crate::arena::{FlatMatrixArena, MatrixId};
use crate::field::{FiniteField, Prime};
use crate::matrix::{Matrix, MatrixError};
use rustc_hash::FxHashMap;
use thiserror::Error;

#[cfg(feature = "parallel")]
use rayon::prelude::*;

#[derive(Debug, Error)]
pub enum CompositionError {
    #[error(transparent)]
    Matrix(#[from] MatrixError),
    #[error("cost table needs at least one entry")]
    EmptyTable,
    #[error("label or outer-block dimensions do not agree")]
    Shape,
    #[error("cost or state count exceeds its compact representation")]
    Overflow,
    #[error("expanded tower witness needs {required} nodes but the budget is {budget}")]
    WitnessBudget { required: u64, budget: u64 },
    #[error("tower depth {depth} exceeds the replay-safe limit {limit}")]
    TowerDepth { depth: usize, limit: usize },
}

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct CostRecord {
    label: MatrixId,
    cost: u32,
    witness: u32,
    _reserved: u32,
}

const _: () = assert!(std::mem::size_of::<CostRecord>() == 16);
const _: () = assert!(std::mem::align_of::<CostRecord>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct CompositionWitnessNode {
    parent: u32,
    choice: u32,
    block: u16,
    _pad: u16,
    depth: u32,
}

const _: () = assert!(std::mem::size_of::<CompositionWitnessNode>() == 16);
const _: () = assert!(std::mem::align_of::<CompositionWitnessNode>() == 4);

const ROOT_WITNESS: u32 = u32::MAX;
const MAX_TOWER_DEPTH: usize = 256;

#[derive(Clone, Debug)]
pub struct CostTable {
    p: u8,
    rows: u16,
    cols: u16,
    labels: FlatMatrixArena,
    records: Box<[CostRecord]>,
    index: FxHashMap<Box<[u8]>, u32>,
}

impl CostTable {
    pub fn from_entries<const P: u8>(
        rows: usize,
        cols: usize,
        entries: impl IntoIterator<Item = (Matrix, u32)>,
    ) -> Result<Self, CompositionError> {
        Self::from_entries_field::<Prime<P>>(rows, cols, entries)
    }

    pub fn from_entries_field<F: FiniteField>(
        rows: usize,
        cols: usize,
        entries: impl IntoIterator<Item = (Matrix, u32)>,
    ) -> Result<Self, CompositionError> {
        F::validate().map_err(MatrixError::from)?;
        let mut best: FxHashMap<Box<[u8]>, u32> = FxHashMap::default();
        for (label, cost) in entries {
            if label.rows() != rows || label.cols() != cols {
                return Err(CompositionError::Shape);
            }
            best.entry(label.as_slice().into())
                .and_modify(|old| *old = (*old).min(cost))
                .or_insert(cost);
        }
        if best.is_empty() {
            return Err(CompositionError::EmptyTable);
        }
        let mut ordered: Vec<_> = best.into_iter().collect();
        ordered.sort_unstable_by(|left, right| left.0.cmp(&right.0));
        let mut labels = FlatMatrixArena::default();
        let mut records = Vec::with_capacity(ordered.len());
        let mut index = FxHashMap::default();
        for (position, (data, cost)) in ordered.into_iter().enumerate() {
            let label = labels.push(rows, cols, &data);
            let record_id = u32::try_from(position).map_err(|_| CompositionError::Overflow)?;
            index.insert(data, record_id);
            records.push(CostRecord {
                label,
                cost,
                witness: ROOT_WITNESS,
                _reserved: 0,
            });
        }
        Ok(Self {
            p: F::ORDER,
            rows: u16::try_from(rows).map_err(|_| CompositionError::Overflow)?,
            cols: u16::try_from(cols).map_err(|_| CompositionError::Overflow)?,
            labels,
            records: records.into_boxed_slice(),
            index,
        })
    }

    pub fn len(&self) -> usize {
        self.records.len()
    }

    pub fn is_empty(&self) -> bool {
        self.records.is_empty()
    }

    pub fn cost(&self, label: &Matrix) -> Option<u32> {
        if label.rows() != self.rows as usize || label.cols() != self.cols as usize {
            return None;
        }
        let record = *self.index.get(label.as_slice())?;
        Some(self.records[record as usize].cost)
    }

    pub fn entries<const P: u8>(&self) -> Result<Vec<(Matrix, u32)>, CompositionError> {
        self.entries_field::<Prime<P>>()
    }

    pub fn entries_field<F: FiniteField>(&self) -> Result<Vec<(Matrix, u32)>, CompositionError> {
        if self.p != F::ORDER {
            return Err(CompositionError::Shape);
        }
        self.records
            .iter()
            .map(|record| {
                let label = self.labels.get(record.label);
                Ok((
                    Matrix::new_field::<F>(label.rows, label.cols, label.data.to_vec())?,
                    record.cost,
                ))
            })
            .collect()
    }

    pub(crate) fn shape(&self) -> (usize, usize) {
        (self.rows as usize, self.cols as usize)
    }

    pub(crate) fn field_order(&self) -> u8 {
        self.p
    }

    pub(crate) fn record_count(&self) -> usize {
        self.records.len()
    }

    pub(crate) fn record(&self, index: usize) -> (crate::arena::MatrixView<'_>, u32) {
        let record = self.records[index];
        (self.labels.get(record.label), record.cost)
    }
}

#[derive(Debug)]
pub struct CompositionAnswer {
    pub cost: u32,
    pub local_labels: Box<[Matrix]>,
}

#[derive(Clone, Debug)]
pub struct TowerLevel {
    pub outer_blocks: Box<[Matrix]>,
    pub target_block: usize,
}

#[derive(Debug)]
struct CompiledTowerLevel {
    target_block: usize,
    block_count: usize,
    ordinary: CompositionTable,
    target: CompositionTable,
}

#[derive(Debug)]
pub struct CompositionTower {
    ordinary_base: CostTable,
    target_base: CostTable,
    levels: Box<[CompiledTowerLevel]>,
}

#[derive(Debug, PartialEq, Eq)]
pub struct TowerWitness {
    pub label: Matrix,
    pub cost: u32,
    pub target_normalized: bool,
    pub children: Box<[TowerWitness]>,
}

#[derive(Debug, PartialEq, Eq)]
pub struct TowerAnswer {
    pub cost: u32,
    pub witness_nodes: u64,
    pub witness: TowerWitness,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct TowerReplaySummary {
    pub cost: u32,
    pub witness_nodes: u64,
}

#[derive(Clone, Copy, Debug)]
pub struct TowerWitnessVisit<'a> {
    pub level_from_base: usize,
    pub label_rows: usize,
    pub label_cols: usize,
    pub label_data: &'a [u8],
    pub cost: u32,
    pub target_normalized: bool,
    pub child_count: usize,
}

#[derive(Clone, Copy)]
struct ReplayLabel<'a> {
    rows: usize,
    cols: usize,
    data: &'a [u8],
}

struct ReplayScratch<'a> {
    choice_offsets: &'a [usize],
    choices: &'a mut [u32],
}

#[derive(Debug)]
pub struct CompositionTable {
    rows: u16,
    cols: u16,
    labels: FlatMatrixArena,
    records: Box<[CostRecord]>,
    index: FxHashMap<Box<[u8]>, u32>,
    witnesses: Box<[CompositionWitnessNode]>,
    ordinary: CostTable,
    target: Option<CostTable>,
    target_block: u16,
    _pad: u16,
    transitions: u64,
}

impl CompositionTable {
    pub fn compose<const P: u8>(
        outer_blocks: &[Matrix],
        inner: &CostTable,
    ) -> Result<Self, CompositionError> {
        Self::compose_field::<Prime<P>>(outer_blocks, inner)
    }

    pub fn compose_field<F: FiniteField>(
        outer_blocks: &[Matrix],
        inner: &CostTable,
    ) -> Result<Self, CompositionError> {
        Self::compose_impl::<F>(outer_blocks, inner, None, false)
    }

    pub fn compose_with_target_field<F: FiniteField>(
        outer_blocks: &[Matrix],
        ordinary: &CostTable,
        target: &CostTable,
        target_block: usize,
    ) -> Result<Self, CompositionError> {
        Self::compose_impl::<F>(outer_blocks, ordinary, Some((target, target_block)), false)
    }

    pub fn compose_with_target<const P: u8>(
        outer_blocks: &[Matrix],
        ordinary: &CostTable,
        target: &CostTable,
        target_block: usize,
    ) -> Result<Self, CompositionError> {
        Self::compose_with_target_field::<Prime<P>>(outer_blocks, ordinary, target, target_block)
    }

    /// Composes ordinary and target-normalized tables with parallel frontier
    /// transitions while preserving the sequential canonical witness.
    #[cfg(feature = "parallel")]
    pub fn compose_with_target_parallel_field<F: FiniteField>(
        outer_blocks: &[Matrix],
        ordinary: &CostTable,
        target: &CostTable,
        target_block: usize,
    ) -> Result<Self, CompositionError> {
        Self::compose_impl::<F>(outer_blocks, ordinary, Some((target, target_block)), true)
    }

    #[cfg(feature = "parallel")]
    pub fn compose_with_target_parallel<const P: u8>(
        outer_blocks: &[Matrix],
        ordinary: &CostTable,
        target: &CostTable,
        target_block: usize,
    ) -> Result<Self, CompositionError> {
        Self::compose_with_target_parallel_field::<Prime<P>>(
            outer_blocks,
            ordinary,
            target,
            target_block,
        )
    }

    /// Composes independent frontier transitions in parallel.
    ///
    /// Small frontiers stay on the sequential kernel to avoid scheduling
    /// overhead. The result and canonical witness are identical to [`Self::compose`].
    #[cfg(feature = "parallel")]
    pub fn compose_parallel<const P: u8>(
        outer_blocks: &[Matrix],
        inner: &CostTable,
    ) -> Result<Self, CompositionError> {
        Self::compose_parallel_field::<Prime<P>>(outer_blocks, inner)
    }

    #[cfg(feature = "parallel")]
    pub fn compose_parallel_field<F: FiniteField>(
        outer_blocks: &[Matrix],
        inner: &CostTable,
    ) -> Result<Self, CompositionError> {
        Self::compose_impl::<F>(outer_blocks, inner, None, true)
    }

    fn compose_impl<F: FiniteField>(
        outer_blocks: &[Matrix],
        inner: &CostTable,
        target_inner: Option<(&CostTable, usize)>,
        _parallel: bool,
    ) -> Result<Self, CompositionError> {
        F::validate().map_err(MatrixError::from)?;
        let Some(first) = outer_blocks.first() else {
            return Err(CompositionError::Shape);
        };
        let output_rows = first.rows();
        let inner_rows = inner.rows as usize;
        let demand_cols = inner.cols as usize;
        if inner.p != F::ORDER
            || first.cols() != inner_rows
            || outer_blocks
                .iter()
                .any(|block| block.rows() != output_rows || block.cols() != inner_rows)
        {
            return Err(CompositionError::Shape);
        }
        if let Some((target_table, target_block)) = target_inner {
            if target_table.p != F::ORDER
                || target_table.shape() != inner.shape()
                || target_block >= outer_blocks.len()
            {
                return Err(CompositionError::Shape);
            }
        }

        let output_len = output_rows * demand_cols;
        let mut labels = FlatMatrixArena::default();
        let zero = vec![0u8; output_len];
        let zero_id = labels.push(output_rows, demand_cols, &zero);
        let mut states = vec![CostRecord {
            label: zero_id,
            cost: 0,
            witness: ROOT_WITNESS,
            _reserved: 0,
        }];
        let mut witnesses = Vec::new();
        let mut transitions = 0u64;
        let mut increments = Vec::new();
        let mut target = vec![0u8; output_len];
        let mut state_bytes = vec![0u8; output_len];

        for (block_index, block) in outer_blocks.iter().enumerate() {
            let local_inner = target_inner
                .filter(|(_, target_block)| *target_block == block_index)
                .map_or(inner, |(target_table, _)| target_table);
            increments.resize(local_inner.records.len() * output_len, 0);
            for (choice, record) in local_inner.records.iter().enumerate() {
                let local = local_inner.labels.get(record.label);
                multiply_into::<F>(
                    block,
                    local.data,
                    local.cols,
                    &mut increments[choice * output_len..(choice + 1) * output_len],
                );
            }
            #[cfg(feature = "parallel")]
            if _parallel
                && states.len().saturating_mul(local_inner.records.len())
                    >= PARALLEL_COMPOSITION_TRANSITIONS
            {
                let added = u64::try_from(states.len())
                    .ok()
                    .and_then(|states| {
                        u64::try_from(local_inner.records.len())
                            .ok()
                            .and_then(|choices| states.checked_mul(choices))
                    })
                    .ok_or(CompositionError::Overflow)?;
                transitions = transitions
                    .checked_add(added)
                    .ok_or(CompositionError::Overflow)?;
                states = parallel_composition_step::<F>(
                    block_index,
                    output_rows,
                    demand_cols,
                    &states,
                    &mut labels,
                    &mut witnesses,
                    local_inner,
                    &increments,
                )?;
                continue;
            }

            let mut next = Vec::<CostRecord>::new();
            let mut next_index: FxHashMap<Box<[u8]>, usize> = FxHashMap::default();
            for state in &states {
                let state_label = labels.get(state.label);
                state_bytes.copy_from_slice(state_label.data);
                for (choice, inner_record) in local_inner.records.iter().enumerate() {
                    transitions += 1;
                    let increment = &increments[choice * output_len..(choice + 1) * output_len];
                    add_into::<F>(&state_bytes, increment, &mut target);
                    let candidate_cost = state
                        .cost
                        .checked_add(inner_record.cost)
                        .ok_or(CompositionError::Overflow)?;
                    if let Some(&position) = next_index.get(target.as_slice()) {
                        let incumbent = next[position];
                        let better = candidate_cost < incumbent.cost
                            || (candidate_cost == incumbent.cost
                                && path_is_lex_smaller(
                                    &witnesses,
                                    state.witness,
                                    choice as u32,
                                    incumbent.witness,
                                ));
                        if better {
                            let witness =
                                push_witness(&mut witnesses, state.witness, choice, block_index)?;
                            next[position].cost = candidate_cost;
                            next[position].witness = witness;
                        }
                    } else {
                        let label = labels.push(output_rows, demand_cols, &target);
                        let witness =
                            push_witness(&mut witnesses, state.witness, choice, block_index)?;
                        let position = next.len();
                        next_index.insert(target.clone().into_boxed_slice(), position);
                        next.push(CostRecord {
                            label,
                            cost: candidate_cost,
                            witness,
                            _reserved: 0,
                        });
                    }
                }
            }
            next.sort_unstable_by(|left, right| {
                labels
                    .get(left.label)
                    .data
                    .cmp(labels.get(right.label).data)
            });
            states = next;
        }

        let mut final_labels = FlatMatrixArena::default();
        for record in &mut states {
            let label = labels.get(record.label);
            record.label = final_labels.push(label.rows, label.cols, label.data);
        }
        let mut index = FxHashMap::default();
        for (position, record) in states.iter().enumerate() {
            index.insert(
                final_labels.get(record.label).data.into(),
                u32::try_from(position).map_err(|_| CompositionError::Overflow)?,
            );
        }
        Ok(Self {
            rows: u16::try_from(output_rows).map_err(|_| CompositionError::Overflow)?,
            cols: inner.cols,
            labels: final_labels,
            records: states.into_boxed_slice(),
            index,
            witnesses: witnesses.into_boxed_slice(),
            ordinary: inner.clone(),
            target: target_inner.map(|(table, _)| table.clone()),
            target_block: target_inner
                .map(|(_, block)| u16::try_from(block).map_err(|_| CompositionError::Overflow))
                .transpose()?
                .unwrap_or(u16::MAX),
            _pad: 0,
            transitions,
        })
    }

    pub fn len(&self) -> usize {
        self.records.len()
    }

    pub fn is_empty(&self) -> bool {
        self.records.is_empty()
    }

    pub fn transitions(&self) -> u64 {
        self.transitions
    }

    pub fn answer<const P: u8>(
        &self,
        label: &Matrix,
    ) -> Result<Option<CompositionAnswer>, CompositionError> {
        self.answer_field::<Prime<P>>(label)
    }

    pub fn answer_field<F: FiniteField>(
        &self,
        label: &Matrix,
    ) -> Result<Option<CompositionAnswer>, CompositionError> {
        if self.ordinary.p != F::ORDER
            || label.rows() != self.rows as usize
            || label.cols() != self.cols as usize
        {
            return Err(CompositionError::Shape);
        }
        let Some(&position) = self.index.get(label.as_slice()) else {
            return Ok(None);
        };
        let record = self.records[position as usize];
        let mut choices = path_choices(&self.witnesses, record.witness);
        let mut local_labels = Vec::with_capacity(choices.len());
        for (block, choice) in choices.drain(..).enumerate() {
            let table = if block == self.target_block as usize {
                self.target.as_ref().unwrap_or(&self.ordinary)
            } else {
                &self.ordinary
            };
            let inner_record = table.records[choice as usize];
            let local = table.labels.get(inner_record.label);
            local_labels.push(Matrix::new_field::<F>(
                local.rows,
                local.cols,
                local.data.to_vec(),
            )?);
        }
        Ok(Some(CompositionAnswer {
            cost: record.cost,
            local_labels: local_labels.into_boxed_slice(),
        }))
    }

    pub fn cost_table_field<F: FiniteField>(&self) -> Result<CostTable, CompositionError> {
        if self.ordinary.p != F::ORDER {
            return Err(CompositionError::Shape);
        }
        let entries = self
            .records
            .iter()
            .map(|record| {
                let label = self.labels.get(record.label);
                Ok((
                    Matrix::new_field::<F>(label.rows, label.cols, label.data.to_vec())?,
                    record.cost,
                ))
            })
            .collect::<Result<Vec<_>, MatrixError>>()?;
        CostTable::from_entries_field::<F>(self.rows as usize, self.cols as usize, entries)
    }

    pub fn cost_table<const P: u8>(&self) -> Result<CostTable, CompositionError> {
        self.cost_table_field::<Prime<P>>()
    }
}

impl CompositionTower {
    pub fn compile_field<F: FiniteField>(
        ordinary_base: &CostTable,
        target_base: &CostTable,
        levels: &[TowerLevel],
    ) -> Result<Self, CompositionError> {
        Self::validate_bases::<F>(ordinary_base, target_base)?;
        Self::validate_depth(levels)?;
        let mut ordinary_table = ordinary_base.clone();
        let mut target_table = target_base.clone();
        let mut compiled = Vec::with_capacity(levels.len());
        for level in levels {
            let ordinary =
                CompositionTable::compose_field::<F>(&level.outer_blocks, &ordinary_table)?;
            let target = CompositionTable::compose_with_target_field::<F>(
                &level.outer_blocks,
                &ordinary_table,
                &target_table,
                level.target_block,
            )?;
            ordinary_table = ordinary.cost_table_field::<F>()?;
            target_table = target.cost_table_field::<F>()?;
            compiled.push(CompiledTowerLevel {
                target_block: level.target_block,
                block_count: level.outer_blocks.len(),
                ordinary,
                target,
            });
        }
        Ok(Self {
            ordinary_base: ordinary_base.clone(),
            target_base: target_base.clone(),
            levels: compiled.into_boxed_slice(),
        })
    }

    pub fn compile<const P: u8>(
        ordinary_base: &CostTable,
        target_base: &CostTable,
        levels: &[TowerLevel],
    ) -> Result<Self, CompositionError> {
        Self::compile_field::<Prime<P>>(ordinary_base, target_base, levels)
    }

    #[cfg(feature = "parallel")]
    pub fn compile_parallel_field<F: FiniteField>(
        ordinary_base: &CostTable,
        target_base: &CostTable,
        levels: &[TowerLevel],
    ) -> Result<Self, CompositionError> {
        Self::validate_bases::<F>(ordinary_base, target_base)?;
        Self::validate_depth(levels)?;
        let mut ordinary_table = ordinary_base.clone();
        let mut target_table = target_base.clone();
        let mut compiled = Vec::with_capacity(levels.len());
        for level in levels {
            let ordinary = CompositionTable::compose_parallel_field::<F>(
                &level.outer_blocks,
                &ordinary_table,
            )?;
            let target = CompositionTable::compose_with_target_parallel_field::<F>(
                &level.outer_blocks,
                &ordinary_table,
                &target_table,
                level.target_block,
            )?;
            ordinary_table = ordinary.cost_table_field::<F>()?;
            target_table = target.cost_table_field::<F>()?;
            compiled.push(CompiledTowerLevel {
                target_block: level.target_block,
                block_count: level.outer_blocks.len(),
                ordinary,
                target,
            });
        }
        Ok(Self {
            ordinary_base: ordinary_base.clone(),
            target_base: target_base.clone(),
            levels: compiled.into_boxed_slice(),
        })
    }

    pub fn answer_target_field<F: FiniteField>(
        &self,
        label: &Matrix,
        witness_node_budget: u64,
    ) -> Result<Option<TowerAnswer>, CompositionError> {
        self.answer_impl::<F>(label, true, witness_node_budget)
    }

    pub fn answer_target<const P: u8>(
        &self,
        label: &Matrix,
        witness_node_budget: u64,
    ) -> Result<Option<TowerAnswer>, CompositionError> {
        self.answer_target_field::<Prime<P>>(label, witness_node_budget)
    }

    pub fn answer_ordinary_field<F: FiniteField>(
        &self,
        label: &Matrix,
        witness_node_budget: u64,
    ) -> Result<Option<TowerAnswer>, CompositionError> {
        self.answer_impl::<F>(label, false, witness_node_budget)
    }

    pub fn answer_ordinary<const P: u8>(
        &self,
        label: &Matrix,
        witness_node_budget: u64,
    ) -> Result<Option<TowerAnswer>, CompositionError> {
        self.answer_ordinary_field::<Prime<P>>(label, witness_node_budget)
    }

    pub fn replay_target_witness_field<F: FiniteField>(
        &self,
        label: &Matrix,
        witness_node_budget: u64,
        mut visit: impl FnMut(TowerWitnessVisit<'_>),
    ) -> Result<Option<TowerReplaySummary>, CompositionError> {
        self.replay_impl::<F>(label, true, witness_node_budget, &mut visit)
    }

    pub fn replay_target_witness<const P: u8>(
        &self,
        label: &Matrix,
        witness_node_budget: u64,
        visit: impl FnMut(TowerWitnessVisit<'_>),
    ) -> Result<Option<TowerReplaySummary>, CompositionError> {
        self.replay_target_witness_field::<Prime<P>>(label, witness_node_budget, visit)
    }

    pub fn replay_ordinary_witness_field<F: FiniteField>(
        &self,
        label: &Matrix,
        witness_node_budget: u64,
        mut visit: impl FnMut(TowerWitnessVisit<'_>),
    ) -> Result<Option<TowerReplaySummary>, CompositionError> {
        self.replay_impl::<F>(label, false, witness_node_budget, &mut visit)
    }

    pub fn replay_ordinary_witness<const P: u8>(
        &self,
        label: &Matrix,
        witness_node_budget: u64,
        visit: impl FnMut(TowerWitnessVisit<'_>),
    ) -> Result<Option<TowerReplaySummary>, CompositionError> {
        self.replay_ordinary_witness_field::<Prime<P>>(label, witness_node_budget, visit)
    }

    fn validate_bases<F: FiniteField>(
        ordinary_base: &CostTable,
        target_base: &CostTable,
    ) -> Result<(), CompositionError> {
        F::validate().map_err(MatrixError::from)?;
        if ordinary_base.p != F::ORDER
            || target_base.p != F::ORDER
            || ordinary_base.shape() != target_base.shape()
        {
            return Err(CompositionError::Shape);
        }
        Ok(())
    }

    fn validate_depth(levels: &[TowerLevel]) -> Result<(), CompositionError> {
        if levels.len() > MAX_TOWER_DEPTH {
            return Err(CompositionError::TowerDepth {
                depth: levels.len(),
                limit: MAX_TOWER_DEPTH,
            });
        }
        Ok(())
    }

    fn answer_impl<F: FiniteField>(
        &self,
        label: &Matrix,
        target_normalized: bool,
        witness_node_budget: u64,
    ) -> Result<Option<TowerAnswer>, CompositionError> {
        let required = self.witness_node_count()?;
        if required > witness_node_budget {
            return Err(CompositionError::WitnessBudget {
                required,
                budget: witness_node_budget,
            });
        }
        let Some(witness) =
            self.expand::<F>(self.levels.len().checked_sub(1), label, target_normalized)?
        else {
            return Ok(None);
        };
        Ok(Some(TowerAnswer {
            cost: witness.cost,
            witness_nodes: required,
            witness,
        }))
    }

    fn replay_impl<F: FiniteField>(
        &self,
        label: &Matrix,
        target_normalized: bool,
        witness_node_budget: u64,
        visit: &mut impl FnMut(TowerWitnessVisit<'_>),
    ) -> Result<Option<TowerReplaySummary>, CompositionError> {
        let required = self.witness_node_count()?;
        if required > witness_node_budget {
            return Err(CompositionError::WitnessBudget {
                required,
                budget: witness_node_budget,
            });
        }
        Self::validate_bases::<F>(&self.ordinary_base, &self.target_base)?;
        let mut choice_offsets = Vec::with_capacity(self.levels.len());
        let mut choice_count = 0usize;
        for level in &self.levels {
            choice_offsets.push(choice_count);
            choice_count = choice_count
                .checked_add(level.block_count)
                .ok_or(CompositionError::Overflow)?;
        }
        // One scratch allocation covers every recursion level. A child writes only
        // its own level segment, so the parent's choices remain live for siblings.
        let mut choices = vec![0u32; choice_count];
        let Some(cost) = self.replay_expand(
            self.levels.len().checked_sub(1),
            ReplayLabel {
                rows: label.rows(),
                cols: label.cols(),
                data: label.as_slice(),
            },
            target_normalized,
            &mut ReplayScratch {
                choice_offsets: &choice_offsets,
                choices: &mut choices,
            },
            visit,
        )?
        else {
            return Ok(None);
        };
        Ok(Some(TowerReplaySummary {
            cost,
            witness_nodes: required,
        }))
    }

    fn witness_node_count(&self) -> Result<u64, CompositionError> {
        let mut frontier = 1u64;
        let mut total = 1u64;
        for level in self.levels.iter().rev() {
            frontier = frontier
                .checked_mul(
                    u64::try_from(level.block_count).map_err(|_| CompositionError::Overflow)?,
                )
                .ok_or(CompositionError::Overflow)?;
            total = total
                .checked_add(frontier)
                .ok_or(CompositionError::Overflow)?;
        }
        Ok(total)
    }

    fn expand<F: FiniteField>(
        &self,
        level_index: Option<usize>,
        label: &Matrix,
        target_normalized: bool,
    ) -> Result<Option<TowerWitness>, CompositionError> {
        let Some(level_index) = level_index else {
            let table = if target_normalized {
                &self.target_base
            } else {
                &self.ordinary_base
            };
            return Ok(table.cost(label).map(|cost| TowerWitness {
                label: label.clone(),
                cost,
                target_normalized,
                children: Box::new([]),
            }));
        };
        let level = &self.levels[level_index];
        let table = if target_normalized {
            &level.target
        } else {
            &level.ordinary
        };
        let Some(answer) = table.answer_field::<F>(label)? else {
            return Ok(None);
        };
        let mut children = Vec::with_capacity(answer.local_labels.len());
        for (block, local_label) in answer.local_labels.iter().enumerate() {
            let child_target = target_normalized && block == level.target_block;
            let child = self
                .expand::<F>(level_index.checked_sub(1), local_label, child_target)?
                .ok_or(CompositionError::Shape)?;
            children.push(child);
        }
        Ok(Some(TowerWitness {
            label: label.clone(),
            cost: answer.cost,
            target_normalized,
            children: children.into_boxed_slice(),
        }))
    }

    fn replay_expand(
        &self,
        level_index: Option<usize>,
        label: ReplayLabel<'_>,
        target_normalized: bool,
        scratch: &mut ReplayScratch<'_>,
        visit: &mut impl FnMut(TowerWitnessVisit<'_>),
    ) -> Result<Option<u32>, CompositionError> {
        let Some(level_index) = level_index else {
            let table = if target_normalized {
                &self.target_base
            } else {
                &self.ordinary_base
            };
            if label.rows != table.rows as usize || label.cols != table.cols as usize {
                return Err(CompositionError::Shape);
            }
            let Some(&position) = table.index.get(label.data) else {
                return Ok(None);
            };
            let cost = table.records[position as usize].cost;
            visit(TowerWitnessVisit {
                level_from_base: 0,
                label_rows: label.rows,
                label_cols: label.cols,
                label_data: label.data,
                cost,
                target_normalized,
                child_count: 0,
            });
            return Ok(Some(cost));
        };
        let level = &self.levels[level_index];
        let table = if target_normalized {
            &level.target
        } else {
            &level.ordinary
        };
        if label.rows != table.rows as usize || label.cols != table.cols as usize {
            return Err(CompositionError::Shape);
        }
        let Some(&position) = table.index.get(label.data) else {
            return Ok(None);
        };
        let record = table.records[position as usize];
        let choice_start = scratch.choice_offsets[level_index];
        let choice_end = choice_start + level.block_count;
        fill_path_choices(
            &table.witnesses,
            record.witness,
            &mut scratch.choices[choice_start..choice_end],
        )?;
        visit(TowerWitnessVisit {
            level_from_base: level_index + 1,
            label_rows: label.rows,
            label_cols: label.cols,
            label_data: label.data,
            cost: record.cost,
            target_normalized,
            child_count: level.block_count,
        });
        for block in 0..level.block_count {
            let choice = scratch.choices[choice_start + block] as usize;
            let child_target = target_normalized && block == level.target_block;
            let inner = if child_target {
                table.target.as_ref().unwrap_or(&table.ordinary)
            } else {
                &table.ordinary
            };
            let inner_record = inner.records[choice];
            let local_label = inner.labels.get(inner_record.label);
            self.replay_expand(
                level_index.checked_sub(1),
                ReplayLabel {
                    rows: local_label.rows,
                    cols: local_label.cols,
                    data: local_label.data,
                },
                child_target,
                scratch,
                visit,
            )?
            .ok_or(CompositionError::Shape)?;
        }
        Ok(Some(record.cost))
    }
}

#[cfg(feature = "parallel")]
const PARALLEL_COMPOSITION_TRANSITIONS: usize = 4_096;

#[cfg(feature = "parallel")]
#[derive(Clone, Copy)]
struct PendingComposition {
    cost: u32,
    parent: u32,
    choice: u32,
}

#[cfg(feature = "parallel")]
#[allow(clippy::too_many_arguments)]
fn parallel_composition_step<F: FiniteField>(
    block_index: usize,
    output_rows: usize,
    demand_cols: usize,
    states: &[CostRecord],
    labels: &mut FlatMatrixArena,
    witnesses: &mut Vec<CompositionWitnessNode>,
    inner: &CostTable,
    increments: &[u8],
) -> Result<Vec<CostRecord>, CompositionError> {
    let output_len = output_rows * demand_cols;
    let workers = rayon::current_num_threads().max(1);
    let chunk_len = states.len().div_ceil(workers).max(1);
    let partials = states
        .par_chunks(chunk_len)
        .map(|chunk| {
            let mut local = FxHashMap::<Box<[u8]>, PendingComposition>::default();
            let mut target = vec![0u8; output_len];
            for state in chunk {
                let state_label = labels.get(state.label);
                for (choice, inner_record) in inner.records.iter().enumerate() {
                    let increment = &increments[choice * output_len..(choice + 1) * output_len];
                    add_into::<F>(state_label.data, increment, &mut target);
                    let candidate = PendingComposition {
                        cost: state
                            .cost
                            .checked_add(inner_record.cost)
                            .ok_or(CompositionError::Overflow)?,
                        parent: state.witness,
                        choice: u32::try_from(choice).map_err(|_| CompositionError::Overflow)?,
                    };
                    if let Some(incumbent) = local.get_mut(target.as_slice()) {
                        if pending_is_better(witnesses, candidate, *incumbent) {
                            *incumbent = candidate;
                        }
                    } else {
                        local.insert(target.clone().into_boxed_slice(), candidate);
                    }
                }
            }
            Ok(local)
        })
        .collect::<Result<Vec<_>, CompositionError>>()?;

    let mut next = Vec::<CostRecord>::new();
    let mut next_index = FxHashMap::<Box<[u8]>, usize>::default();
    for partial in partials {
        for (label_data, candidate) in partial {
            if let Some(&position) = next_index.get(label_data.as_ref()) {
                let incumbent = next[position];
                let better = candidate.cost < incumbent.cost
                    || (candidate.cost == incumbent.cost
                        && path_is_lex_smaller(
                            witnesses,
                            candidate.parent,
                            candidate.choice,
                            incumbent.witness,
                        ));
                if better {
                    let witness = push_witness(
                        witnesses,
                        candidate.parent,
                        candidate.choice as usize,
                        block_index,
                    )?;
                    next[position].cost = candidate.cost;
                    next[position].witness = witness;
                }
            } else {
                let label = labels.push(output_rows, demand_cols, &label_data);
                let witness = push_witness(
                    witnesses,
                    candidate.parent,
                    candidate.choice as usize,
                    block_index,
                )?;
                let position = next.len();
                next_index.insert(label_data, position);
                next.push(CostRecord {
                    label,
                    cost: candidate.cost,
                    witness,
                    _reserved: 0,
                });
            }
        }
    }
    next.sort_unstable_by(|left, right| {
        labels
            .get(left.label)
            .data
            .cmp(labels.get(right.label).data)
    });
    Ok(next)
}

#[cfg(feature = "parallel")]
fn pending_is_better(
    witnesses: &[CompositionWitnessNode],
    candidate: PendingComposition,
    incumbent: PendingComposition,
) -> bool {
    candidate.cost < incumbent.cost
        || (candidate.cost == incumbent.cost
            && virtual_path(witnesses, candidate.parent, candidate.choice)
                < virtual_path(witnesses, incumbent.parent, incumbent.choice))
}

#[cfg(feature = "parallel")]
fn virtual_path(witnesses: &[CompositionWitnessNode], parent: u32, choice: u32) -> Vec<u32> {
    let mut path = path_choices(witnesses, parent);
    path.push(choice);
    path
}

#[inline]
fn multiply_into<F: FiniteField>(
    left: &Matrix,
    right: &[u8],
    right_cols: usize,
    output: &mut [u8],
) {
    let shared = left.cols();
    debug_assert_eq!(right.len(), shared * right_cols);
    debug_assert_eq!(output.len(), left.rows() * right_cols);
    output.fill(0);
    for row in 0..left.rows() {
        for k in 0..shared {
            let factor = left.as_slice()[row * shared + k];
            if factor == 0 {
                continue;
            }
            for col in 0..right_cols {
                let product = F::mul(factor, right[k * right_cols + col]);
                let index = row * right_cols + col;
                output[index] = F::add(output[index], product);
            }
        }
    }
}

#[inline]
fn add_into<F: FiniteField>(left: &[u8], right: &[u8], output: &mut [u8]) {
    debug_assert_eq!(left.len(), right.len());
    debug_assert_eq!(left.len(), output.len());
    for ((output, &left), &right) in output.iter_mut().zip(left).zip(right) {
        *output = F::add(left, right);
    }
}

fn push_witness(
    witnesses: &mut Vec<CompositionWitnessNode>,
    parent: u32,
    choice: usize,
    block: usize,
) -> Result<u32, CompositionError> {
    let depth = if parent == ROOT_WITNESS {
        1
    } else {
        witnesses[parent as usize].depth + 1
    };
    let id = u32::try_from(witnesses.len()).map_err(|_| CompositionError::Overflow)?;
    witnesses.push(CompositionWitnessNode {
        parent,
        choice: u32::try_from(choice).map_err(|_| CompositionError::Overflow)?,
        block: u16::try_from(block).map_err(|_| CompositionError::Overflow)?,
        _pad: 0,
        depth,
    });
    Ok(id)
}

fn path_choices(witnesses: &[CompositionWitnessNode], mut witness: u32) -> Vec<u32> {
    if witness == ROOT_WITNESS {
        return Vec::new();
    }
    let mut result = Vec::with_capacity(witnesses[witness as usize].depth as usize);
    while witness != ROOT_WITNESS {
        let node = witnesses[witness as usize];
        result.push(node.choice);
        witness = node.parent;
    }
    result.reverse();
    result
}

fn fill_path_choices(
    witnesses: &[CompositionWitnessNode],
    mut witness: u32,
    output: &mut [u32],
) -> Result<(), CompositionError> {
    let mut remaining = output.len();
    while witness != ROOT_WITNESS {
        if remaining == 0 {
            return Err(CompositionError::Shape);
        }
        remaining -= 1;
        let node = witnesses[witness as usize];
        output[remaining] = node.choice;
        witness = node.parent;
    }
    if remaining != 0 {
        return Err(CompositionError::Shape);
    }
    Ok(())
}

fn path_is_lex_smaller(
    witnesses: &[CompositionWitnessNode],
    candidate_parent: u32,
    candidate_choice: u32,
    incumbent: u32,
) -> bool {
    let mut candidate = path_choices(witnesses, candidate_parent);
    candidate.push(candidate_choice);
    candidate < path_choices(witnesses, incumbent)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn literal_block_composition_retains_labels() {
        let inner = CostTable::from_entries::<2>(
            1,
            1,
            [
                (Matrix::new::<2>(1, 1, vec![0]).unwrap(), 0),
                (Matrix::new::<2>(1, 1, vec![1]).unwrap(), 1),
            ],
        )
        .unwrap();
        let blocks = [
            Matrix::new::<2>(1, 1, vec![1]).unwrap(),
            Matrix::new::<2>(1, 1, vec![1]).unwrap(),
        ];
        let table = CompositionTable::compose::<2>(&blocks, &inner).unwrap();
        let answer = table
            .answer::<2>(&Matrix::new::<2>(1, 1, vec![1]).unwrap())
            .unwrap()
            .unwrap();
        assert_eq!(answer.cost, 1);
        assert_eq!(answer.local_labels[0].as_slice(), &[0]);
        assert_eq!(answer.local_labels[1].as_slice(), &[1]);
    }

    #[test]
    fn gf4_composition_retains_extension_field_labels() {
        use crate::field::Gf4;

        let inner = CostTable::from_entries_field::<Gf4>(
            1,
            1,
            [
                (Matrix::new_field::<Gf4>(1, 1, vec![0]).unwrap(), 0),
                (Matrix::new_field::<Gf4>(1, 1, vec![1]).unwrap(), 1),
                (Matrix::new_field::<Gf4>(1, 1, vec![2]).unwrap(), 2),
                (Matrix::new_field::<Gf4>(1, 1, vec![3]).unwrap(), 3),
            ],
        )
        .unwrap();
        let blocks = [
            Matrix::new_field::<Gf4>(1, 1, vec![2]).unwrap(),
            Matrix::new_field::<Gf4>(1, 1, vec![1]).unwrap(),
        ];
        let table = CompositionTable::compose_field::<Gf4>(&blocks, &inner).unwrap();
        let target = Matrix::new_field::<Gf4>(1, 1, vec![3]).unwrap();
        let answer = table.answer_field::<Gf4>(&target).unwrap().unwrap();
        assert_eq!(answer.cost, 2);
        assert_eq!(answer.local_labels[0].as_slice(), &[1]);
        assert_eq!(answer.local_labels[1].as_slice(), &[1]);
    }

    #[test]
    fn gf4_scalar_composition_matches_exhaustive_two_block_oracle() {
        use crate::field::{FiniteField, Gf4};

        for costs in [[0, 3, 1, 2], [4, 0, 4, 1], [2, 2, 2, 2]] {
            let inner = CostTable::from_entries_field::<Gf4>(
                1,
                1,
                costs.into_iter().enumerate().map(|(label, cost)| {
                    (
                        Matrix::new_field::<Gf4>(1, 1, vec![label as u8]).unwrap(),
                        cost,
                    )
                }),
            )
            .unwrap();
            for left_factor in 0..4 {
                for right_factor in 0..4 {
                    let blocks = [
                        Matrix::new_field::<Gf4>(1, 1, vec![left_factor]).unwrap(),
                        Matrix::new_field::<Gf4>(1, 1, vec![right_factor]).unwrap(),
                    ];
                    let table = CompositionTable::compose_field::<Gf4>(&blocks, &inner).unwrap();
                    for target_value in 0..4 {
                        let target = Matrix::new_field::<Gf4>(1, 1, vec![target_value]).unwrap();
                        let answer = table.answer_field::<Gf4>(&target).unwrap();
                        let mut expected = None;
                        for left_label in 0..4 {
                            for right_label in 0..4 {
                                let value = Gf4::add(
                                    Gf4::mul(left_factor, left_label),
                                    Gf4::mul(right_factor, right_label),
                                );
                                if value != target_value {
                                    continue;
                                }
                                let candidate = (
                                    costs[left_label as usize] + costs[right_label as usize],
                                    left_label,
                                    right_label,
                                );
                                if expected.is_none_or(|incumbent| candidate < incumbent) {
                                    expected = Some(candidate);
                                }
                            }
                        }
                        match (answer, expected) {
                            (None, None) => {}
                            (Some(answer), Some((cost, left_label, right_label))) => {
                                assert_eq!(answer.cost, cost);
                                assert_eq!(answer.local_labels[0].as_slice(), &[left_label]);
                                assert_eq!(answer.local_labels[1].as_slice(), &[right_label]);
                            }
                            mismatch => {
                                panic!("composition/oracle feasibility mismatch: {mismatch:?}")
                            }
                        }
                    }
                }
            }
        }
    }

    #[cfg(feature = "parallel")]
    #[test]
    fn gf4_parallel_composition_matches_sequential_witnesses() {
        use crate::field::Gf4;

        let entries = (0u16..256)
            .map(|encoded| {
                let data = (0..4)
                    .map(|shift| ((encoded >> (2 * shift)) & 3) as u8)
                    .collect::<Vec<_>>();
                let cost = data.iter().map(|&entry| u32::from(entry != 0)).sum();
                (Matrix::new_field::<Gf4>(4, 1, data).unwrap(), cost)
            })
            .collect::<Vec<_>>();
        let inner = CostTable::from_entries_field::<Gf4>(4, 1, entries).unwrap();
        let identity = Matrix::new_field::<Gf4>(
            4,
            4,
            (0..16)
                .map(|index| u8::from(index / 4 == index % 4))
                .collect::<Vec<_>>(),
        )
        .unwrap();
        let blocks = [identity.clone(), identity];
        let sequential = CompositionTable::compose_field::<Gf4>(&blocks, &inner).unwrap();
        let parallel = CompositionTable::compose_parallel_field::<Gf4>(&blocks, &inner).unwrap();
        assert_eq!(parallel.transitions(), sequential.transitions());
        for encoded in [0u8, 1, 2, 3, 27, 108, 255] {
            let target = Matrix::new_field::<Gf4>(
                4,
                1,
                (0..4)
                    .map(|shift| (encoded >> (2 * shift)) & 3)
                    .collect::<Vec<_>>(),
            )
            .unwrap();
            let sequential_answer = sequential.answer_field::<Gf4>(&target).unwrap().unwrap();
            let parallel_answer = parallel.answer_field::<Gf4>(&target).unwrap().unwrap();
            assert_eq!(parallel_answer.cost, sequential_answer.cost);
            assert_eq!(parallel_answer.local_labels, sequential_answer.local_labels);
        }
    }

    #[cfg(feature = "parallel")]
    #[test]
    fn target_aware_parallel_composition_matches_sequential_witnesses() {
        use crate::field::Gf4;

        let entries = (0u16..256)
            .map(|encoded| {
                let data = (0..4)
                    .map(|shift| ((encoded >> (2 * shift)) & 3) as u8)
                    .collect::<Vec<_>>();
                let cost = data.iter().map(|&entry| u32::from(entry != 0)).sum();
                (Matrix::new_field::<Gf4>(4, 1, data).unwrap(), cost)
            })
            .collect::<Vec<_>>();
        let ordinary = CostTable::from_entries_field::<Gf4>(4, 1, entries.clone()).unwrap();
        let target = CostTable::from_entries_field::<Gf4>(
            4,
            1,
            entries
                .into_iter()
                .map(|(label, cost)| (label, 4 - cost))
                .collect::<Vec<_>>(),
        )
        .unwrap();
        let identity = Matrix::new_field::<Gf4>(
            4,
            4,
            (0..16)
                .map(|index| u8::from(index / 4 == index % 4))
                .collect::<Vec<_>>(),
        )
        .unwrap();
        let blocks = [identity.clone(), identity];
        let sequential =
            CompositionTable::compose_with_target_field::<Gf4>(&blocks, &ordinary, &target, 0)
                .unwrap();
        let parallel = CompositionTable::compose_with_target_parallel_field::<Gf4>(
            &blocks, &ordinary, &target, 0,
        )
        .unwrap();
        assert_eq!(parallel.transitions(), sequential.transitions());
        for encoded in [0u8, 1, 2, 3, 27, 108, 255] {
            let label = Matrix::new_field::<Gf4>(
                4,
                1,
                (0..4)
                    .map(|shift| (encoded >> (2 * shift)) & 3)
                    .collect::<Vec<_>>(),
            )
            .unwrap();
            let sequential_answer = sequential.answer_field::<Gf4>(&label).unwrap().unwrap();
            let parallel_answer = parallel.answer_field::<Gf4>(&label).unwrap().unwrap();
            assert_eq!(parallel_answer.cost, sequential_answer.cost);
            assert_eq!(parallel_answer.local_labels, sequential_answer.local_labels);
        }
    }

    #[test]
    fn target_aware_tables_compose_through_two_levels_with_witnesses() {
        let ordinary = CostTable::from_entries::<2>(
            1,
            1,
            [
                (Matrix::new::<2>(1, 1, vec![0]).unwrap(), 0),
                (Matrix::new::<2>(1, 1, vec![1]).unwrap(), 1),
            ],
        )
        .unwrap();
        let target = CostTable::from_entries::<2>(
            1,
            1,
            [
                (Matrix::new::<2>(1, 1, vec![0]).unwrap(), 2),
                (Matrix::new::<2>(1, 1, vec![1]).unwrap(), 0),
            ],
        )
        .unwrap();
        let blocks = [
            Matrix::new::<2>(1, 1, vec![1]).unwrap(),
            Matrix::new::<2>(1, 1, vec![1]).unwrap(),
        ];
        let ordinary_level_one = CompositionTable::compose::<2>(&blocks, &ordinary).unwrap();
        let target_level_one =
            CompositionTable::compose_with_target_field::<Prime<2>>(&blocks, &ordinary, &target, 0)
                .unwrap();
        let ordinary_table = ordinary_level_one.cost_table_field::<Prime<2>>().unwrap();
        let target_table = target_level_one.cost_table_field::<Prime<2>>().unwrap();
        let target_label = Matrix::new::<2>(1, 1, vec![1]).unwrap();
        assert_eq!(ordinary_table.cost(&target_label), Some(1));
        assert_eq!(target_table.cost(&target_label), Some(0));
        let level_two = CompositionTable::compose_with_target_field::<Prime<2>>(
            &blocks,
            &ordinary_table,
            &target_table,
            0,
        )
        .unwrap();
        let answer = level_two.answer::<2>(&target_label).unwrap().unwrap();
        assert_eq!(answer.cost, 0);
        assert_eq!(answer.local_labels[0].as_slice(), &[1]);
        assert_eq!(answer.local_labels[1].as_slice(), &[0]);
        let expanded_target = target_level_one
            .answer::<2>(&answer.local_labels[0])
            .unwrap()
            .unwrap();
        assert_eq!(expanded_target.cost, 0);
        assert_eq!(expanded_target.local_labels[0].as_slice(), &[1]);
        assert_eq!(expanded_target.local_labels[1].as_slice(), &[0]);
    }

    #[test]
    fn tower_expands_canonical_labels_to_a_budgeted_replay_tree() {
        let ordinary = CostTable::from_entries::<2>(
            1,
            1,
            [
                (Matrix::new::<2>(1, 1, vec![0]).unwrap(), 0),
                (Matrix::new::<2>(1, 1, vec![1]).unwrap(), 1),
            ],
        )
        .unwrap();
        let target = CostTable::from_entries::<2>(
            1,
            1,
            [
                (Matrix::new::<2>(1, 1, vec![0]).unwrap(), 2),
                (Matrix::new::<2>(1, 1, vec![1]).unwrap(), 0),
            ],
        )
        .unwrap();
        let blocks = || {
            vec![
                Matrix::new::<2>(1, 1, vec![1]).unwrap(),
                Matrix::new::<2>(1, 1, vec![1]).unwrap(),
            ]
            .into_boxed_slice()
        };
        let tower = CompositionTower::compile::<2>(
            &ordinary,
            &target,
            &[
                TowerLevel {
                    outer_blocks: blocks(),
                    target_block: 0,
                },
                TowerLevel {
                    outer_blocks: blocks(),
                    target_block: 0,
                },
            ],
        )
        .unwrap();
        let label = Matrix::new::<2>(1, 1, vec![1]).unwrap();
        let answer = tower.answer_target::<2>(&label, 7).unwrap().unwrap();
        assert_eq!(answer.cost, 0);
        assert_eq!(answer.witness_nodes, 7);
        assert!(answer.witness.target_normalized);
        assert!(answer.witness.children[0].target_normalized);
        assert!(!answer.witness.children[1].target_normalized);
        assert!(answer.witness.children[0].children[0].target_normalized);
        assert!(!answer.witness.children[0].children[1].target_normalized);
        let mut eager = Vec::new();
        fn flatten(
            witness: &TowerWitness,
            level_from_base: usize,
            output: &mut Vec<(usize, Vec<u8>, u32, bool, usize)>,
        ) {
            output.push((
                level_from_base,
                witness.label.as_slice().to_vec(),
                witness.cost,
                witness.target_normalized,
                witness.children.len(),
            ));
            for child in &witness.children {
                flatten(child, level_from_base - 1, output);
            }
        }
        flatten(&answer.witness, 2, &mut eager);
        let mut streamed = Vec::new();
        let summary = tower
            .replay_target_witness::<2>(&label, 7, |visit| {
                streamed.push((
                    visit.level_from_base,
                    visit.label_data.to_vec(),
                    visit.cost,
                    visit.target_normalized,
                    visit.child_count,
                ));
            })
            .unwrap()
            .unwrap();
        assert_eq!(summary.cost, answer.cost);
        assert_eq!(summary.witness_nodes, answer.witness_nodes);
        assert_eq!(streamed, eager);
        assert!(matches!(
            tower.answer_target::<2>(&label, 6),
            Err(CompositionError::WitnessBudget {
                required: 7,
                budget: 6
            })
        ));
        assert!(matches!(
            tower.replay_target_witness::<2>(&label, 6, |_| {}),
            Err(CompositionError::WitnessBudget {
                required: 7,
                budget: 6
            })
        ));
    }

    #[test]
    fn tower_rejects_recursion_unsafe_depth() {
        let table =
            CostTable::from_entries::<2>(1, 1, [(Matrix::new::<2>(1, 1, vec![0]).unwrap(), 0)])
                .unwrap();
        let levels = (0..=MAX_TOWER_DEPTH)
            .map(|_| TowerLevel {
                outer_blocks: Box::new([]),
                target_block: 0,
            })
            .collect::<Vec<_>>();
        assert!(matches!(
            CompositionTower::compile::<2>(&table, &table, &levels),
            Err(CompositionError::TowerDepth {
                depth: 257,
                limit: 256
            })
        ));
    }

    #[cfg(feature = "parallel")]
    #[test]
    fn parallel_composition_matches_costs_and_canonical_witnesses() {
        let entries = (0u16..256)
            .map(|bits| {
                let data = (0..8)
                    .map(|shift| ((bits >> shift) & 1) as u8)
                    .collect::<Vec<_>>();
                (Matrix::new::<2>(8, 1, data).unwrap(), bits.count_ones())
            })
            .collect::<Vec<_>>();
        let inner = CostTable::from_entries::<2>(8, 1, entries).unwrap();
        let identity = Matrix::new::<2>(
            8,
            8,
            (0..64)
                .map(|index| u8::from(index / 8 == index % 8))
                .collect::<Vec<_>>(),
        )
        .unwrap();
        let blocks = [identity.clone(), identity];
        let sequential = CompositionTable::compose::<2>(&blocks, &inner).unwrap();
        let parallel = CompositionTable::compose_parallel::<2>(&blocks, &inner).unwrap();
        assert_eq!(parallel.transitions(), sequential.transitions());
        assert_eq!(parallel.len(), sequential.len());
        for bits in 0u16..256 {
            let target = Matrix::new::<2>(
                8,
                1,
                (0..8)
                    .map(|shift| ((bits >> shift) & 1) as u8)
                    .collect::<Vec<_>>(),
            )
            .unwrap();
            let sequential_answer = sequential.answer::<2>(&target).unwrap().unwrap();
            let parallel_answer = parallel.answer::<2>(&target).unwrap().unwrap();
            assert_eq!(parallel_answer.cost, sequential_answer.cost);
            assert_eq!(parallel_answer.local_labels.len(), 2);
            for (parallel_label, sequential_label) in parallel_answer
                .local_labels
                .iter()
                .zip(&sequential_answer.local_labels)
            {
                assert_eq!(parallel_label, sequential_label);
            }
        }
    }
}
