use crate::arena::{FlatMatrixArena, MatrixId};
use crate::composition::{CompositionError, CostTable};
use crate::field::{FiniteField, Prime};
use crate::matrix::{Matrix, MatrixError};
use rustc_hash::FxHashMap;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum ConfinementError {
    #[error(transparent)]
    Composition(#[from] CompositionError),
    #[error(transparent)]
    Matrix(#[from] MatrixError),
    #[error("confinement input dimensions do not agree")]
    Shape,
    #[error("cost or state count exceeds its compact representation")]
    Overflow,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ConfinementSector {
    Zero,
    Nonzero,
}

#[derive(Debug)]
pub struct ConfinementAnswer {
    pub cost: u32,
    pub zero_cost: u32,
    pub nonzero_cost: Option<u32>,
    pub sector: ConfinementSector,
    pub functional_coefficients: Option<Matrix>,
    pub block_labels: Box<[Matrix]>,
    pub transitions: u64,
}

/// Radius decision for the rank-one complete-transfer criterion.
///
/// Unlike [`ConfinementAnswer`], this deliberately does not compute the exact
/// losing nonzero-sector minimum.  It stops at the first obstruction of cost
/// at most `radius`, or certifies that none exists.
#[derive(Debug)]
pub struct RankOneTransferCertificate {
    pub radius: u32,
    pub transfers_completely: bool,
    pub obstruction_cost: Option<u32>,
    pub obstruction_sector: Option<ConfinementSector>,
    pub functional_coefficients: Option<Matrix>,
    pub block_labels: Box<[Matrix]>,
    pub candidates_examined: u64,
    pub local_lookups: u64,
}

pub fn confinement_by_generators<const P: u8>(
    functional_dual_basis: &Matrix,
    block_count: usize,
    inner: &CostTable,
    target: &CostTable,
    target_block: usize,
    inner_dual_distance: u32,
) -> Result<ConfinementAnswer, ConfinementError> {
    confinement_by_generators_field::<Prime<P>>(
        functional_dual_basis,
        block_count,
        inner,
        target,
        target_block,
        inner_dual_distance,
    )
}

pub fn confinement_by_generators_field<F: FiniteField>(
    functional_dual_basis: &Matrix,
    block_count: usize,
    inner: &CostTable,
    target: &CostTable,
    target_block: usize,
    inner_dual_distance: u32,
) -> Result<ConfinementAnswer, ConfinementError> {
    F::validate().map_err(MatrixError::from)?;
    let (label_rows, demand_cols) = inner.shape();
    if inner.field_order() != F::ORDER
        || target.field_order() != F::ORDER
        || target.shape() != (label_rows, demand_cols)
        || functional_dual_basis.cols() != block_count * label_rows
        || target_block >= block_count
    {
        return Err(ConfinementError::Shape);
    }
    let zero = Matrix::zeros_field::<F>(label_rows, demand_cols)?;
    let zero_cost = target
        .cost(&zero)
        .ok_or(ConfinementError::Shape)?
        .checked_add(inner_dual_distance)
        .ok_or(ConfinementError::Overflow)?;
    let mut best_nonzero_cost = None;
    let coefficient_len = functional_dual_basis.rows() * demand_cols;
    let mut coefficients = vec![0u8; coefficient_len];
    let mut block_data = vec![0u8; block_count * label_rows * demand_cols];
    let mut best_nonzero_coefficients = vec![0u8; coefficient_len];
    let mut best_nonzero_labels = vec![0u8; block_data.len()];
    let mut transitions = 0u64;

    while increment_base_field::<F>(&mut coefficients) {
        transitions += 1;
        evaluate_functional::<F>(
            functional_dual_basis,
            block_count,
            label_rows,
            demand_cols,
            &coefficients,
            &mut block_data,
        );
        let mut cost = 0u32;
        let mut feasible = true;
        for block in 0..block_count {
            let start = block * label_rows * demand_cols;
            let end = start + label_rows * demand_cols;
            let table = if block == target_block { target } else { inner };
            let Some(local_cost) = table.cost_slice(&block_data[start..end]) else {
                feasible = false;
                break;
            };
            cost = cost
                .checked_add(local_cost)
                .ok_or(ConfinementError::Overflow)?;
            if best_nonzero_cost.is_some_and(|incumbent| cost >= incumbent) {
                feasible = false;
                break;
            }
        }
        if feasible && best_nonzero_cost.is_none_or(|incumbent| cost < incumbent) {
            best_nonzero_cost = Some(cost);
            best_nonzero_coefficients.copy_from_slice(&coefficients);
            best_nonzero_labels.copy_from_slice(&block_data);
        }
    }

    let nonzero_wins = best_nonzero_cost.is_some_and(|cost| cost < zero_cost);
    let best_cost = best_nonzero_cost.map_or(zero_cost, |cost| cost.min(zero_cost));

    Ok(ConfinementAnswer {
        cost: best_cost,
        zero_cost,
        nonzero_cost: best_nonzero_cost,
        sector: if nonzero_wins {
            ConfinementSector::Nonzero
        } else {
            ConfinementSector::Zero
        },
        functional_coefficients: if nonzero_wins {
            Some(Matrix::new_field::<F>(
                functional_dual_basis.rows(),
                demand_cols,
                best_nonzero_coefficients,
            )?)
        } else {
            None
        },
        block_labels: if nonzero_wins {
            best_nonzero_labels
                .chunks_exact(label_rows * demand_cols)
                .map(|label| Matrix::new_field::<F>(label_rows, demand_cols, label.to_vec()))
                .collect::<Result<Vec<_>, MatrixError>>()?
                .into_boxed_slice()
        } else {
            vec![zero; block_count].into_boxed_slice()
        },
        transitions,
    })
}

/// Decide the rank-one complete-transfer condition through `radius`.
///
/// The input tables must have one demand column.  The zero-functional cost is
/// checked first.  Nonzero candidates are accumulated target block first and
/// abandoned as soon as their partial cost exceeds `radius`.
pub fn certify_rank_one_transfer_by_generators_field<F: FiniteField>(
    functional_dual_basis: &Matrix,
    block_count: usize,
    inner: &CostTable,
    target: &CostTable,
    target_block: usize,
    inner_dual_distance: u32,
    radius: u32,
) -> Result<RankOneTransferCertificate, ConfinementError> {
    F::validate().map_err(MatrixError::from)?;
    let (label_rows, demand_cols) = inner.shape();
    if demand_cols != 1
        || inner.field_order() != F::ORDER
        || target.field_order() != F::ORDER
        || target.shape() != (label_rows, demand_cols)
        || functional_dual_basis.cols() != block_count * label_rows
        || target_block >= block_count
    {
        return Err(ConfinementError::Shape);
    }
    let zero = Matrix::zeros_field::<F>(label_rows, 1)?;
    let zero_cost = target
        .cost(&zero)
        .ok_or(ConfinementError::Shape)?
        .checked_add(inner_dual_distance)
        .ok_or(ConfinementError::Overflow)?;
    if zero_cost <= radius {
        return Ok(RankOneTransferCertificate {
            radius,
            transfers_completely: false,
            obstruction_cost: Some(zero_cost),
            obstruction_sector: Some(ConfinementSector::Zero),
            functional_coefficients: None,
            block_labels: vec![zero; block_count].into_boxed_slice(),
            candidates_examined: 0,
            local_lookups: 1,
        });
    }

    let coefficient_len = functional_dual_basis.rows();
    let mut coefficients = vec![0u8; coefficient_len];
    let mut block_data = vec![0u8; block_count * label_rows];
    let mut candidates_examined = 0u64;
    let mut local_lookups = 1u64;
    let mut order = Vec::with_capacity(block_count);
    order.push(target_block);
    order.extend((0..block_count).filter(|&block| block != target_block));

    while increment_base_field::<F>(&mut coefficients) {
        candidates_examined += 1;
        evaluate_functional::<F>(
            functional_dual_basis,
            block_count,
            label_rows,
            1,
            &coefficients,
            &mut block_data,
        );
        let mut cost = 0u32;
        let mut feasible = true;
        for &block in &order {
            let start = block * label_rows;
            let end = start + label_rows;
            let table = if block == target_block { target } else { inner };
            local_lookups += 1;
            let Some(local_cost) = table.cost_slice(&block_data[start..end]) else {
                feasible = false;
                break;
            };
            cost = cost
                .checked_add(local_cost)
                .ok_or(ConfinementError::Overflow)?;
            if cost > radius {
                feasible = false;
                break;
            }
        }
        if feasible {
            let labels = (0..block_count)
                .map(|block| {
                    let start = block * label_rows;
                    Matrix::new_field::<F>(
                        label_rows,
                        1,
                        block_data[start..start + label_rows].to_vec(),
                    )
                })
                .collect::<Result<Vec<_>, MatrixError>>()?;
            return Ok(RankOneTransferCertificate {
                radius,
                transfers_completely: false,
                obstruction_cost: Some(cost),
                obstruction_sector: Some(ConfinementSector::Nonzero),
                functional_coefficients: Some(Matrix::new_field::<F>(
                    functional_dual_basis.rows(),
                    1,
                    coefficients.clone(),
                )?),
                block_labels: labels.into_boxed_slice(),
                candidates_examined,
                local_lookups,
            });
        }
    }

    Ok(RankOneTransferCertificate {
        radius,
        transfers_completely: true,
        obstruction_cost: None,
        obstruction_sector: None,
        functional_coefficients: None,
        block_labels: Vec::new().into_boxed_slice(),
        candidates_examined,
        local_lookups,
    })
}

pub fn certify_rank_one_transfer_by_generators<const P: u8>(
    functional_dual_basis: &Matrix,
    block_count: usize,
    inner: &CostTable,
    target: &CostTable,
    target_block: usize,
    inner_dual_distance: u32,
    radius: u32,
) -> Result<RankOneTransferCertificate, ConfinementError> {
    certify_rank_one_transfer_by_generators_field::<Prime<P>>(
        functional_dual_basis,
        block_count,
        inner,
        target,
        target_block,
        inner_dual_distance,
        radius,
    )
}

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct SyndromeState {
    syndrome: MatrixId,
    cost: u32,
    witness: u32,
    nonzero: u8,
    _pad: [u8; 3],
}

const _: () = assert!(std::mem::size_of::<SyndromeState>() == 16);
const _: () = assert!(std::mem::align_of::<SyndromeState>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct SyndromeWitnessNode {
    parent: u32,
    choice: u32,
    depth: u32,
    _reserved: u32,
}

const _: () = assert!(std::mem::size_of::<SyndromeWitnessNode>() == 16);
const _: () = assert!(std::mem::align_of::<SyndromeWitnessNode>() == 4);

const ROOT_WITNESS: u32 = u32::MAX;

pub fn confinement_by_syndrome<const P: u8>(
    constraint_blocks: &[Matrix],
    inner: &CostTable,
    target: &CostTable,
    target_block: usize,
    inner_dual_distance: u32,
) -> Result<ConfinementAnswer, ConfinementError> {
    Prime::<P>::validate().map_err(MatrixError::from)?;
    let Some(first) = constraint_blocks.first() else {
        return Err(ConfinementError::Shape);
    };
    let syndrome_rows = first.rows();
    let (label_rows, demand_cols) = inner.shape();
    if inner.field_order() != P
        || target.field_order() != P
        || target.shape() != (label_rows, demand_cols)
        || target_block >= constraint_blocks.len()
        || first.cols() != label_rows
        || constraint_blocks
            .iter()
            .any(|block| block.rows() != syndrome_rows || block.cols() != label_rows)
    {
        return Err(ConfinementError::Shape);
    }
    let syndrome_len = syndrome_rows * demand_cols;
    let zero_syndrome = vec![0u8; syndrome_len];
    let zero_label = Matrix::zeros::<P>(label_rows, demand_cols)?;
    let zero_cost = target
        .cost(&zero_label)
        .ok_or(ConfinementError::Shape)?
        .checked_add(inner_dual_distance)
        .ok_or(ConfinementError::Overflow)?;
    let mut arena = FlatMatrixArena::default();
    let zero_id = arena.push(syndrome_rows, demand_cols, &zero_syndrome);
    let mut states = vec![SyndromeState {
        syndrome: zero_id,
        cost: 0,
        witness: ROOT_WITNESS,
        nonzero: 0,
        _pad: [0; 3],
    }];
    let mut witnesses = Vec::new();
    let mut transitions = 0u64;
    let mut increment = Vec::new();
    let mut candidate = vec![0u8; syndrome_len];
    let mut state_bytes = vec![0u8; syndrome_len];

    for (block_index, constraint) in constraint_blocks.iter().enumerate() {
        let local = if block_index == target_block {
            target
        } else {
            inner
        };
        increment.resize(local.record_count() * syndrome_len, 0);
        for choice in 0..local.record_count() {
            let (label, _) = local.record(choice);
            multiply_slice_into::<P>(
                constraint,
                label.data,
                label.cols,
                &mut increment[choice * syndrome_len..(choice + 1) * syndrome_len],
            );
        }
        let mut next = Vec::<SyndromeState>::new();
        let mut index: FxHashMap<Box<[u8]>, usize> = FxHashMap::default();
        for state in &states {
            state_bytes.copy_from_slice(arena.get(state.syndrome).data);
            for choice in 0..local.record_count() {
                transitions += 1;
                let (label, local_cost) = local.record(choice);
                let label_nonzero = label.data.iter().any(|&value| value != 0);
                let nonzero = state.nonzero | u8::from(label_nonzero);
                add_slice_into::<P>(
                    &state_bytes,
                    &increment[choice * syndrome_len..(choice + 1) * syndrome_len],
                    &mut candidate,
                );
                let mut key = Vec::with_capacity(syndrome_len + 1);
                key.extend_from_slice(&candidate);
                key.push(nonzero);
                let cost = state
                    .cost
                    .checked_add(local_cost)
                    .ok_or(ConfinementError::Overflow)?;
                if let Some(&position) = index.get(key.as_slice()) {
                    let incumbent = next[position];
                    let better = cost < incumbent.cost
                        || (cost == incumbent.cost
                            && path_is_lex_smaller(
                                &witnesses,
                                state.witness,
                                choice as u32,
                                incumbent.witness,
                            ));
                    if better {
                        let witness = push_witness(&mut witnesses, state.witness, choice)?;
                        next[position].cost = cost;
                        next[position].witness = witness;
                    }
                } else {
                    let syndrome = arena.push(syndrome_rows, demand_cols, &candidate);
                    let witness = push_witness(&mut witnesses, state.witness, choice)?;
                    let position = next.len();
                    index.insert(key.into_boxed_slice(), position);
                    next.push(SyndromeState {
                        syndrome,
                        cost,
                        witness,
                        nonzero,
                        _pad: [0; 3],
                    });
                }
            }
        }
        states = next;
    }

    let nonzero = states.iter().find(|state| {
        state.nonzero != 0 && arena.get(state.syndrome).data == zero_syndrome.as_slice()
    });
    if let Some(state) = nonzero.filter(|state| state.cost < zero_cost) {
        let choices = path_choices(&witnesses, state.witness);
        let mut labels = Vec::with_capacity(choices.len());
        for (block, choice) in choices.into_iter().enumerate() {
            let table = if block == target_block { target } else { inner };
            let (label, _) = table.record(choice as usize);
            labels.push(Matrix::new::<P>(
                label.rows,
                label.cols,
                label.data.to_vec(),
            )?);
        }
        return Ok(ConfinementAnswer {
            cost: state.cost,
            zero_cost,
            nonzero_cost: Some(state.cost),
            sector: ConfinementSector::Nonzero,
            functional_coefficients: None,
            block_labels: labels.into_boxed_slice(),
            transitions,
        });
    }
    Ok(ConfinementAnswer {
        cost: zero_cost,
        zero_cost,
        nonzero_cost: nonzero.map(|state| state.cost),
        sector: ConfinementSector::Zero,
        functional_coefficients: None,
        block_labels: vec![zero_label; constraint_blocks.len()].into_boxed_slice(),
        transitions,
    })
}

fn evaluate_functional<F: FiniteField>(
    basis: &Matrix,
    block_count: usize,
    label_rows: usize,
    demand_cols: usize,
    coefficients: &[u8],
    output: &mut [u8],
) {
    output.fill(0);
    for functional in 0..basis.rows() {
        for block_coordinate in 0..block_count * label_rows {
            let factor = basis.as_slice()[functional * basis.cols() + block_coordinate];
            if factor == 0 {
                continue;
            }
            for demand in 0..demand_cols {
                let product = F::mul(factor, coefficients[functional * demand_cols + demand]);
                let index = block_coordinate * demand_cols + demand;
                output[index] = F::add(output[index], product);
            }
        }
    }
}

fn increment_base_field<F: FiniteField>(digits: &mut [u8]) -> bool {
    for digit in digits.iter_mut().rev() {
        *digit += 1;
        if *digit < F::ORDER {
            return true;
        }
        *digit = 0;
    }
    false
}

#[inline]
fn multiply_slice_into<const P: u8>(
    left: &Matrix,
    right: &[u8],
    right_cols: usize,
    output: &mut [u8],
) {
    output.fill(0);
    for row in 0..left.rows() {
        for k in 0..left.cols() {
            let factor = left.as_slice()[row * left.cols() + k];
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
fn add_slice_into<const P: u8>(left: &[u8], right: &[u8], output: &mut [u8]) {
    for ((output, &left), &right) in output.iter_mut().zip(left).zip(right) {
        *output = Prime::<P>::add(left, right);
    }
}

fn push_witness(
    witnesses: &mut Vec<SyndromeWitnessNode>,
    parent: u32,
    choice: usize,
) -> Result<u32, ConfinementError> {
    let depth = if parent == ROOT_WITNESS {
        1
    } else {
        witnesses[parent as usize].depth + 1
    };
    let id = u32::try_from(witnesses.len()).map_err(|_| ConfinementError::Overflow)?;
    witnesses.push(SyndromeWitnessNode {
        parent,
        choice: u32::try_from(choice).map_err(|_| ConfinementError::Overflow)?,
        depth,
        _reserved: 0,
    });
    Ok(id)
}

fn path_choices(witnesses: &[SyndromeWitnessNode], mut witness: u32) -> Vec<u32> {
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
    witnesses: &[SyndromeWitnessNode],
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

    fn binary_scalar_table() -> CostTable {
        CostTable::from_entries::<2>(
            1,
            1,
            [
                (Matrix::new::<2>(1, 1, vec![0]).unwrap(), 0),
                (Matrix::new::<2>(1, 1, vec![1]).unwrap(), 1),
            ],
        )
        .unwrap()
    }

    #[test]
    fn generator_and_syndrome_engines_agree() {
        let table = binary_scalar_table();
        let basis = Matrix::new::<2>(1, 2, vec![1, 1]).unwrap();
        let constraints = [
            Matrix::new::<2>(1, 1, vec![1]).unwrap(),
            Matrix::new::<2>(1, 1, vec![1]).unwrap(),
        ];
        let generated = confinement_by_generators::<2>(&basis, 2, &table, &table, 0, 2).unwrap();
        let syndrome = confinement_by_syndrome::<2>(&constraints, &table, &table, 0, 2).unwrap();
        assert_eq!(generated.cost, syndrome.cost);
        assert_eq!(generated.zero_cost, 2);
        assert_eq!(generated.nonzero_cost, Some(2));
        assert_eq!(generated.zero_cost, syndrome.zero_cost);
        assert_eq!(generated.nonzero_cost, syndrome.nonzero_cost);
        assert_eq!(generated.sector, syndrome.sector);
        assert_eq!(generated.block_labels, syndrome.block_labels);
    }

    #[test]
    fn rank_one_certificate_matches_exact_radius_decisions() {
        let table = binary_scalar_table();
        let basis = Matrix::new::<2>(2, 3, vec![1, 1, 0, 0, 1, 1]).unwrap();
        let exact = confinement_by_generators::<2>(&basis, 3, &table, &table, 0, 3).unwrap();
        for radius in 0..=4 {
            let certificate = certify_rank_one_transfer_by_generators::<2>(
                &basis, 3, &table, &table, 0, 3, radius,
            )
            .unwrap();
            assert_eq!(certificate.transfers_completely, radius < exact.cost);
            assert_eq!(certificate.obstruction_cost.is_some(), radius >= exact.cost);
        }
    }

    #[test]
    fn rank_one_certificate_short_circuits_zero_and_nonzero_obstructions() {
        let table = binary_scalar_table();
        let basis = Matrix::new::<2>(3, 4, vec![1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1]).unwrap();
        let zero = certify_rank_one_transfer_by_generators::<2>(&basis, 4, &table, &table, 0, 1, 1)
            .unwrap();
        assert_eq!(zero.obstruction_sector, Some(ConfinementSector::Zero));
        assert_eq!(zero.candidates_examined, 0);

        let nonzero =
            certify_rank_one_transfer_by_generators::<2>(&basis, 4, &table, &table, 0, 4, 2)
                .unwrap();
        assert_eq!(nonzero.obstruction_sector, Some(ConfinementSector::Nonzero));
        assert!(nonzero.candidates_examined < 7);
    }
}
