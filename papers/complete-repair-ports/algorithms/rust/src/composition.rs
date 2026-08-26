use crate::arena::{FlatMatrixArena, MatrixId};
use crate::field::Prime;
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
        Prime::<P>::validate().map_err(MatrixError::from)?;
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
            p: P,
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
        self.records
            .iter()
            .map(|record| {
                let label = self.labels.get(record.label);
                Ok((
                    Matrix::new::<P>(label.rows, label.cols, label.data.to_vec())?,
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

#[derive(Debug)]
pub struct CompositionTable {
    rows: u16,
    cols: u16,
    records: Box<[CostRecord]>,
    index: FxHashMap<Box<[u8]>, u32>,
    witnesses: Box<[CompositionWitnessNode]>,
    inner: CostTable,
    transitions: u64,
}

impl CompositionTable {
    pub fn compose<const P: u8>(
        outer_blocks: &[Matrix],
        inner: &CostTable,
    ) -> Result<Self, CompositionError> {
        Self::compose_impl::<P>(outer_blocks, inner, false)
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
        Self::compose_impl::<P>(outer_blocks, inner, true)
    }

    fn compose_impl<const P: u8>(
        outer_blocks: &[Matrix],
        inner: &CostTable,
        _parallel: bool,
    ) -> Result<Self, CompositionError> {
        Prime::<P>::validate().map_err(MatrixError::from)?;
        let Some(first) = outer_blocks.first() else {
            return Err(CompositionError::Shape);
        };
        let output_rows = first.rows();
        let inner_rows = inner.rows as usize;
        let demand_cols = inner.cols as usize;
        if inner.p != P
            || first.cols() != inner_rows
            || outer_blocks
                .iter()
                .any(|block| block.rows() != output_rows || block.cols() != inner_rows)
        {
            return Err(CompositionError::Shape);
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
        let mut increments = vec![0u8; inner.records.len() * output_len];
        let mut target = vec![0u8; output_len];
        let mut state_bytes = vec![0u8; output_len];

        for (block_index, block) in outer_blocks.iter().enumerate() {
            for (choice, record) in inner.records.iter().enumerate() {
                let local = inner.labels.get(record.label);
                multiply_into::<P>(
                    block,
                    local.data,
                    local.cols,
                    &mut increments[choice * output_len..(choice + 1) * output_len],
                );
            }
            #[cfg(feature = "parallel")]
            if _parallel
                && states.len().saturating_mul(inner.records.len())
                    >= PARALLEL_COMPOSITION_TRANSITIONS
            {
                let added = u64::try_from(states.len())
                    .ok()
                    .and_then(|states| {
                        u64::try_from(inner.records.len())
                            .ok()
                            .and_then(|choices| states.checked_mul(choices))
                    })
                    .ok_or(CompositionError::Overflow)?;
                transitions = transitions
                    .checked_add(added)
                    .ok_or(CompositionError::Overflow)?;
                states = parallel_composition_step::<P>(
                    block_index,
                    output_rows,
                    demand_cols,
                    &states,
                    &mut labels,
                    &mut witnesses,
                    inner,
                    &increments,
                )?;
                continue;
            }

            let mut next = Vec::<CostRecord>::new();
            let mut next_index: FxHashMap<Box<[u8]>, usize> = FxHashMap::default();
            for state in &states {
                let state_label = labels.get(state.label);
                state_bytes.copy_from_slice(state_label.data);
                for (choice, inner_record) in inner.records.iter().enumerate() {
                    transitions += 1;
                    let increment = &increments[choice * output_len..(choice + 1) * output_len];
                    add_into::<P>(&state_bytes, increment, &mut target);
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

        let mut index = FxHashMap::default();
        for (position, record) in states.iter().enumerate() {
            index.insert(
                labels.get(record.label).data.into(),
                u32::try_from(position).map_err(|_| CompositionError::Overflow)?,
            );
        }
        Ok(Self {
            rows: u16::try_from(output_rows).map_err(|_| CompositionError::Overflow)?,
            cols: inner.cols,
            records: states.into_boxed_slice(),
            index,
            witnesses: witnesses.into_boxed_slice(),
            inner: inner.clone(),
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
        if label.rows() != self.rows as usize || label.cols() != self.cols as usize {
            return Err(CompositionError::Shape);
        }
        let Some(&position) = self.index.get(label.as_slice()) else {
            return Ok(None);
        };
        let record = self.records[position as usize];
        let mut choices = path_choices(&self.witnesses, record.witness);
        let mut local_labels = Vec::with_capacity(choices.len());
        for choice in choices.drain(..) {
            let inner_record = self.inner.records[choice as usize];
            let local = self.inner.labels.get(inner_record.label);
            local_labels.push(Matrix::new::<P>(
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
fn parallel_composition_step<const P: u8>(
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
                    add_into::<P>(state_label.data, increment, &mut target);
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
fn multiply_into<const P: u8>(left: &Matrix, right: &[u8], right_cols: usize, output: &mut [u8]) {
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
                let product = Prime::<P>::mul(factor, right[k * right_cols + col]);
                let index = row * right_cols + col;
                output[index] = Prime::<P>::add(output[index], product);
            }
        }
    }
}

#[inline]
fn add_into<const P: u8>(left: &[u8], right: &[u8], output: &mut [u8]) {
    debug_assert_eq!(left.len(), right.len());
    debug_assert_eq!(left.len(), output.len());
    for ((output, &left), &right) in output.iter_mut().zip(left).zip(right) {
        *output = Prime::<P>::add(left, right);
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
