//! Exact compilation of binary recovery data over characteristic-two fields.

use crate::composition::{CompositionError, CostTable};
use crate::field::{FiniteField, Prime};
use crate::matrix::{Matrix, MatrixError};
use rustc_hash::FxHashMap;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum TransferError {
    #[error(transparent)]
    Matrix(#[from] MatrixError),
    #[error(transparent)]
    Composition(#[from] CompositionError),
    #[error("the represented encoder must have between 2 and 63 columns")]
    ColumnCount,
    #[error("binary encoder compilation requires a field of characteristic two")]
    BaseFieldMismatch,
    #[error("the target coordinate is outside the encoder")]
    TargetCoordinate,
    #[error("an encoder column lies outside the canonical field encoding")]
    UnreducedColumn,
    #[error("exact enumeration needs {required} candidates but the budget is {budget}")]
    CandidateBudget { required: u64, budget: u64 },
    #[error("the target coordinate has no normalized binary recovery equation")]
    UnrecoverableTarget,
    #[error("the compiled profile belongs to a different field encoding")]
    FieldMismatch,
    #[error("target coordinates must be distinct and lie inside the encoder")]
    TargetCoordinates,
    #[error("the target normalization matrix must have one row per target coordinate")]
    NormalizationShape,
    #[error("target normalization entries must be binary")]
    NonbinaryNormalization,
    #[error("target normalization columns must be linearly independent")]
    DependentNormalization,
    #[error("the coefficient search dimension exceeds the packed exact enumerator")]
    SearchDimension,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CoefficientWitness {
    pub cost: u32,
    pub coefficients: Box<[u8]>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct MatrixCoefficientWitness {
    pub label: Matrix,
    pub cost: u32,
    pub coefficients: Matrix,
}

#[derive(Clone, Debug)]
pub struct BinaryTargetProfile {
    field_order: u8,
    demand_dimension: u16,
    ordinary: Box<[MatrixCoefficientWitness]>,
    target_normalized: Box<[MatrixCoefficientWitness]>,
    target_union_cost: u32,
    inner_dual: Option<CoefficientWitness>,
    ordinary_candidates_examined: u64,
    target_candidates_examined: u64,
}

impl BinaryTargetProfile {
    pub fn demand_dimension(&self) -> usize {
        self.demand_dimension as usize
    }

    pub fn ordinary(&self) -> &[MatrixCoefficientWitness] {
        &self.ordinary
    }

    pub fn target_normalized(&self) -> &[MatrixCoefficientWitness] {
        &self.target_normalized
    }

    pub fn target_union_cost(&self) -> u32 {
        self.target_union_cost
    }

    pub fn inner_dual(&self) -> Option<&CoefficientWitness> {
        self.inner_dual.as_ref()
    }

    pub fn ordinary_candidates_examined(&self) -> u64 {
        self.ordinary_candidates_examined
    }

    pub fn target_candidates_examined(&self) -> u64 {
        self.target_candidates_examined
    }

    pub fn cost_tables<F: FiniteField>(&self) -> Result<(CostTable, CostTable), TransferError> {
        if self.field_order != F::ORDER {
            return Err(TransferError::FieldMismatch);
        }
        let ordinary = self
            .ordinary
            .iter()
            .map(|entry| (entry.label.clone(), entry.cost));
        let target = self
            .target_normalized
            .iter()
            .map(|entry| (entry.label.clone(), entry.cost));
        Ok((
            CostTable::from_entries_field::<F>(1, self.demand_dimension(), ordinary)?,
            CostTable::from_entries_field::<F>(1, self.demand_dimension(), target)?,
        ))
    }
}

#[derive(Clone, Debug)]
pub struct BinaryRankOneProfile {
    field_order: u8,
    ordinary: Box<[Option<CoefficientWitness>]>,
    target_normalized: Box<[Option<CoefficientWitness>]>,
    inner_dual: Option<CoefficientWitness>,
    recovery_cost: u32,
    k_p: Matrix,
    d_p: Matrix,
    quotient_dimension: u16,
    candidates_examined: u64,
}

impl BinaryRankOneProfile {
    pub fn ordinary(&self) -> &[Option<CoefficientWitness>] {
        &self.ordinary
    }

    pub fn target_normalized(&self) -> &[Option<CoefficientWitness>] {
        &self.target_normalized
    }

    pub fn inner_dual(&self) -> Option<&CoefficientWitness> {
        self.inner_dual.as_ref()
    }

    pub fn recovery_cost(&self) -> u32 {
        self.recovery_cost
    }

    pub fn k_p(&self) -> &Matrix {
        &self.k_p
    }

    pub fn d_p(&self) -> &Matrix {
        &self.d_p
    }

    pub fn quotient_dimension(&self) -> usize {
        self.quotient_dimension as usize
    }

    pub fn candidates_examined(&self) -> u64 {
        self.candidates_examined
    }

    pub fn cost_tables<F: FiniteField>(&self) -> Result<(CostTable, CostTable), TransferError> {
        if self.field_order != F::ORDER {
            return Err(TransferError::FieldMismatch);
        }
        let ordinary = self
            .ordinary
            .iter()
            .enumerate()
            .filter_map(|(label, witness)| {
                witness.as_ref().map(|witness| (label as u8, witness.cost))
            })
            .map(|(label, cost)| Ok((Matrix::new_field::<F>(1, 1, vec![label])?, cost)))
            .collect::<Result<Vec<_>, MatrixError>>()?;
        let target = self
            .target_normalized
            .iter()
            .enumerate()
            .filter_map(|(label, witness)| {
                witness.as_ref().map(|witness| (label as u8, witness.cost))
            })
            .map(|(label, cost)| Ok((Matrix::new_field::<F>(1, 1, vec![label])?, cost)))
            .collect::<Result<Vec<_>, MatrixError>>()?;
        Ok((
            CostTable::from_entries_field::<F>(1, 1, ordinary)?,
            CostTable::from_entries_field::<F>(1, 1, target)?,
        ))
    }
}

/// Compiles matrix-valued prescribed-coset costs for a normalized target
/// subspace of a represented binary encoder.
///
/// `target_normalization` is a binary matrix with one row per target
/// coordinate. Its columns are the chosen normalized basis of the recovered
/// target subspace. Costs count the union of nonzero coefficient rows.
pub fn compile_binary_target_subspace<F: FiniteField>(
    columns: &[u8],
    target_coordinates: &[usize],
    target_normalization: &Matrix,
    ordinary_candidate_budget: u64,
    target_candidate_budget: u64,
) -> Result<BinaryTargetProfile, TransferError> {
    if F::CHARACTERISTIC != 2 {
        return Err(TransferError::BaseFieldMismatch);
    }
    if columns.len() < 2 || columns.len() >= u64::BITS as usize {
        return Err(TransferError::ColumnCount);
    }
    if columns.iter().any(|&column| column >= F::ORDER) {
        return Err(TransferError::UnreducedColumn);
    }
    if target_coordinates.is_empty()
        || target_coordinates
            .iter()
            .any(|&target| target >= columns.len())
    {
        return Err(TransferError::TargetCoordinates);
    }
    let mut target_flags = vec![false; columns.len()];
    for &target in target_coordinates {
        if std::mem::replace(&mut target_flags[target], true) {
            return Err(TransferError::TargetCoordinates);
        }
    }
    if target_normalization.rows() != target_coordinates.len() || target_normalization.cols() == 0 {
        return Err(TransferError::NormalizationShape);
    }
    target_normalization.ensure_field::<Prime<2>>()?;
    if target_normalization
        .as_slice()
        .iter()
        .any(|&entry| entry >= 2)
    {
        return Err(TransferError::NonbinaryNormalization);
    }
    let demand_dimension = target_normalization.cols();
    let helper_count = columns.len() - target_coordinates.len();
    let ordinary_bits = columns
        .len()
        .checked_mul(demand_dimension)
        .ok_or(TransferError::SearchDimension)?;
    let target_bits = helper_count
        .checked_mul(demand_dimension)
        .ok_or(TransferError::SearchDimension)?;
    let ordinary_candidates = packed_candidate_count(ordinary_bits)?;
    let target_candidates = packed_candidate_count(target_bits)?;
    if binary_matrix_rank(target_normalization) != demand_dimension {
        return Err(TransferError::DependentNormalization);
    }
    check_budget(ordinary_candidates, ordinary_candidate_budget)?;
    check_budget(target_candidates, target_candidate_budget)?;

    let mut ordinary = FxHashMap::<Box<[u8]>, MatrixCoefficientWitness>::default();
    let mut coefficients = vec![0u8; columns.len() * demand_dimension];
    let mut label = vec![0u8; demand_dimension];
    for packed in 0..ordinary_candidates {
        fill_packed_coefficients(&mut coefficients, packed);
        evaluate_binary_coefficients::<F>(columns, demand_dimension, &coefficients, &mut label);
        let cost = coefficient_union_cost(&coefficients, demand_dimension);
        retain_matrix_witness::<F>(
            &mut ordinary,
            &label,
            cost,
            columns.len(),
            demand_dimension,
            &coefficients,
        )?;
    }

    let helpers = target_flags
        .iter()
        .enumerate()
        .filter_map(|(coordinate, &is_target)| (!is_target).then_some(coordinate))
        .collect::<Vec<_>>();
    coefficients.fill(0);
    for (target_row, &coordinate) in target_coordinates.iter().enumerate() {
        coefficients[coordinate * demand_dimension..(coordinate + 1) * demand_dimension]
            .copy_from_slice(target_normalization.row(target_row));
    }
    let mut target_normalized = FxHashMap::<Box<[u8]>, MatrixCoefficientWitness>::default();
    for packed in 0..target_candidates {
        for (helper_row, &coordinate) in helpers.iter().enumerate() {
            let start = coordinate * demand_dimension;
            for demand in 0..demand_dimension {
                coefficients[start + demand] =
                    ((packed >> (helper_row * demand_dimension + demand)) & 1) as u8;
            }
        }
        evaluate_binary_coefficients::<F>(columns, demand_dimension, &coefficients, &mut label);
        let cost = helpers
            .iter()
            .filter(|&&coordinate| {
                coefficients[coordinate * demand_dimension..(coordinate + 1) * demand_dimension]
                    .iter()
                    .any(|&entry| entry != 0)
            })
            .count() as u32;
        retain_matrix_witness::<F>(
            &mut target_normalized,
            &label,
            cost,
            columns.len(),
            demand_dimension,
            &coefficients,
        )?;
    }

    let zero = vec![0u8; demand_dimension];
    let target_union_cost = target_normalized
        .get(zero.as_slice())
        .ok_or(TransferError::UnrecoverableTarget)?
        .cost;
    let inner_dual = compile_binary_inner_dual::<F>(columns, ordinary_candidate_budget)?;
    Ok(BinaryTargetProfile {
        field_order: F::ORDER,
        demand_dimension: u16::try_from(demand_dimension)
            .map_err(|_| TransferError::SearchDimension)?,
        ordinary: ordered_witnesses(ordinary),
        target_normalized: ordered_witnesses(target_normalized),
        target_union_cost,
        inner_dual,
        ordinary_candidates_examined: ordinary_candidates,
        target_candidates_examined: target_candidates,
    })
}

pub fn compile_binary_inner_dual<F: FiniteField>(
    columns: &[u8],
    candidate_budget: u64,
) -> Result<Option<CoefficientWitness>, TransferError> {
    if F::CHARACTERISTIC != 2 {
        return Err(TransferError::BaseFieldMismatch);
    }
    if columns.len() < 2 || columns.len() >= u64::BITS as usize {
        return Err(TransferError::ColumnCount);
    }
    if columns.iter().any(|&column| column >= F::ORDER) {
        return Err(TransferError::UnreducedColumn);
    }
    let candidate_count = packed_candidate_count(columns.len())?;
    check_budget(candidate_count, candidate_budget)?;
    let mut coefficients = vec![0u8; columns.len()];
    let mut best = None;
    for mask in 1..candidate_count {
        fill_packed_coefficients(&mut coefficients, mask);
        let label = columns
            .iter()
            .zip(&coefficients)
            .filter(|&(_, &coefficient)| coefficient != 0)
            .fold(0u8, |label, (&column, _)| F::add(label, column));
        if label == 0 {
            retain_better(
                &mut best,
                coefficients.iter().map(|&entry| u32::from(entry)).sum(),
                &coefficients,
            );
        }
    }
    Ok(best)
}

fn packed_candidate_count(bits: usize) -> Result<u64, TransferError> {
    if bits >= u64::BITS as usize {
        return Err(TransferError::SearchDimension);
    }
    Ok(1u64 << bits)
}

fn check_budget(required: u64, budget: u64) -> Result<(), TransferError> {
    if required > budget {
        return Err(TransferError::CandidateBudget { required, budget });
    }
    Ok(())
}

fn fill_packed_coefficients(coefficients: &mut [u8], packed: u64) {
    for (index, coefficient) in coefficients.iter_mut().enumerate() {
        *coefficient = ((packed >> index) & 1) as u8;
    }
}

fn evaluate_binary_coefficients<F: FiniteField>(
    columns: &[u8],
    demand_dimension: usize,
    coefficients: &[u8],
    label: &mut [u8],
) {
    label.fill(0);
    for (coordinate, &column) in columns.iter().enumerate() {
        for demand in 0..demand_dimension {
            if coefficients[coordinate * demand_dimension + demand] != 0 {
                label[demand] = F::add(label[demand], column);
            }
        }
    }
}

fn coefficient_union_cost(coefficients: &[u8], demand_dimension: usize) -> u32 {
    coefficients
        .chunks_exact(demand_dimension)
        .filter(|row| row.iter().any(|&entry| entry != 0))
        .count() as u32
}

fn binary_matrix_rank(matrix: &Matrix) -> usize {
    let mut rows = matrix
        .as_slice()
        .chunks_exact(matrix.cols())
        .map(|row| {
            row.iter()
                .enumerate()
                .fold(0u64, |packed, (column, &entry)| {
                    packed | (u64::from(entry) << column)
                })
        })
        .collect::<Vec<_>>();
    let mut rank = 0;
    for column in 0..matrix.cols() {
        let Some(pivot) = (rank..rows.len()).find(|&row| (rows[row] >> column) & 1 != 0) else {
            continue;
        };
        rows.swap(rank, pivot);
        for row in 0..rows.len() {
            if row != rank && (rows[row] >> column) & 1 != 0 {
                rows[row] ^= rows[rank];
            }
        }
        rank += 1;
    }
    rank
}

fn retain_matrix_witness<F: FiniteField>(
    table: &mut FxHashMap<Box<[u8]>, MatrixCoefficientWitness>,
    label: &[u8],
    cost: u32,
    coefficient_rows: usize,
    coefficient_cols: usize,
    coefficients: &[u8],
) -> Result<(), TransferError> {
    let replace = table.get(label).is_none_or(|incumbent| {
        (cost, coefficients) < (incumbent.cost, incumbent.coefficients.as_slice())
    });
    if replace {
        table.insert(
            label.into(),
            MatrixCoefficientWitness {
                label: Matrix::new_field::<F>(1, label.len(), label.to_vec())?,
                cost,
                coefficients: Matrix::new::<2>(
                    coefficient_rows,
                    coefficient_cols,
                    coefficients.to_vec(),
                )?,
            },
        );
    }
    Ok(())
}

fn ordered_witnesses(
    table: FxHashMap<Box<[u8]>, MatrixCoefficientWitness>,
) -> Box<[MatrixCoefficientWitness]> {
    let mut entries = table.into_values().collect::<Vec<_>>();
    entries.sort_unstable_by(|left, right| left.label.as_slice().cmp(right.label.as_slice()));
    entries.into_boxed_slice()
}

/// Compiles all ordinary and target-normalized scalar coset costs of a
/// represented binary encoder whose columns are elements of `F`.
///
/// A coefficient vector `y` has label `sum_i y_i columns_i`. Ordinary cost is
/// its Hamming weight. Target-normalized cost fixes the target coefficient to
/// one and counts only helper coordinates. Ties use lexicographically least
/// coefficient vectors.
pub fn compile_binary_rank_one<F: FiniteField>(
    columns: &[u8],
    target_coordinate: usize,
    candidate_budget: u64,
) -> Result<BinaryRankOneProfile, TransferError> {
    if F::CHARACTERISTIC != 2 {
        return Err(TransferError::BaseFieldMismatch);
    }
    if columns.len() < 2 || columns.len() >= u64::BITS as usize {
        return Err(TransferError::ColumnCount);
    }
    if target_coordinate >= columns.len() {
        return Err(TransferError::TargetCoordinate);
    }
    if columns.iter().any(|&column| column >= F::ORDER) {
        return Err(TransferError::UnreducedColumn);
    }
    let candidate_count = 1u64 << columns.len();
    if candidate_count > candidate_budget {
        return Err(TransferError::CandidateBudget {
            required: candidate_count,
            budget: candidate_budget,
        });
    }

    let mut ordinary = vec![None; F::ORDER as usize];
    let mut target_normalized = vec![None; F::ORDER as usize];
    let mut inner_dual = None;
    let helper_count = columns.len() - 1;
    let mut d_basis = vec![0u64; helper_count];
    let mut k_basis = vec![0u64; helper_count];
    let mut coefficients = vec![0u8; columns.len()];
    for mask in 0..candidate_count {
        let mut label = 0u8;
        let mut support = 0u32;
        for (coordinate, &column) in columns.iter().enumerate() {
            let coefficient = ((mask >> coordinate) & 1) as u8;
            coefficients[coordinate] = coefficient;
            if coefficient != 0 {
                support += 1;
                label = F::add(label, column);
            }
        }
        retain_better(&mut ordinary[label as usize], support, &coefficients);
        if mask != 0 && label == 0 {
            let below_target = mask & ((1u64 << target_coordinate) - 1);
            let above_target = mask >> (target_coordinate + 1);
            let helper_row = below_target | (above_target << target_coordinate);
            insert_binary_basis(&mut d_basis, helper_row);
            if coefficients[target_coordinate] == 0 {
                insert_binary_basis(&mut k_basis, helper_row);
            }
            retain_better(&mut inner_dual, support, &coefficients);
        }
        if coefficients[target_coordinate] != 0 {
            retain_better(
                &mut target_normalized[label as usize],
                support - 1,
                &coefficients,
            );
        }
    }
    let recovery_cost = target_normalized[0]
        .as_ref()
        .ok_or(TransferError::UnrecoverableTarget)?
        .cost;
    let d_p = binary_basis_matrix(&d_basis, helper_count)?;
    let k_p = binary_basis_matrix(&k_basis, helper_count)?;
    let quotient_dimension =
        u16::try_from(d_p.rows() - k_p.rows()).map_err(|_| TransferError::ColumnCount)?;
    Ok(BinaryRankOneProfile {
        field_order: F::ORDER,
        ordinary: ordinary.into_boxed_slice(),
        target_normalized: target_normalized.into_boxed_slice(),
        inner_dual,
        recovery_cost,
        k_p,
        d_p,
        quotient_dimension,
        candidates_examined: candidate_count,
    })
}

fn retain_better(slot: &mut Option<CoefficientWitness>, cost: u32, coefficients: &[u8]) {
    let replace = slot.as_ref().is_none_or(|incumbent| {
        (cost, coefficients) < (incumbent.cost, incumbent.coefficients.as_ref())
    });
    if replace {
        *slot = Some(CoefficientWitness {
            cost,
            coefficients: coefficients.into(),
        });
    }
}

fn insert_binary_basis(basis: &mut [u64], mut row: u64) {
    for pivot in 0..basis.len() {
        if row & (1u64 << pivot) == 0 {
            continue;
        }
        if basis[pivot] != 0 {
            row ^= basis[pivot];
            continue;
        }
        basis[pivot] = row;
        for (other, basis_row) in basis.iter_mut().enumerate() {
            if other != pivot && *basis_row & (1u64 << pivot) != 0 {
                *basis_row ^= row;
            }
        }
        return;
    }
}

fn binary_basis_matrix(basis: &[u64], width: usize) -> Result<Matrix, MatrixError> {
    let rows = basis.iter().filter(|&&row| row != 0).count();
    let mut data = Vec::with_capacity(rows * width);
    for &row in basis.iter().filter(|&&row| row != 0) {
        data.extend((0..width).map(|coordinate| ((row >> coordinate) & 1) as u8));
    }
    Matrix::new::<2>(rows, width, data)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::field::Gf4;

    #[test]
    fn paper_gf4_profiles_have_equal_scalars_and_different_labels() {
        let first = compile_binary_rank_one::<Gf4>(&[1, 1, 2], 0, 8).unwrap();
        let second = compile_binary_rank_one::<Gf4>(&[1, 1, 3], 0, 8).unwrap();
        assert_eq!(first.recovery_cost(), 1);
        assert_eq!(second.recovery_cost(), 1);
        assert_eq!(first.inner_dual().unwrap().cost, 2);
        assert_eq!(second.inner_dual().unwrap().cost, 2);
        assert_eq!(first.k_p().rows(), 0);
        assert_eq!(first.d_p().as_slice(), &[1, 0]);
        assert_eq!(first.quotient_dimension(), 1);
        assert_eq!(first.k_p(), second.k_p());
        assert_eq!(first.d_p(), second.d_p());
        let ordinary_first = first
            .ordinary()
            .iter()
            .map(|entry| entry.as_ref().map(|witness| witness.cost))
            .collect::<Vec<_>>();
        let ordinary_second = second
            .ordinary()
            .iter()
            .map(|entry| entry.as_ref().map(|witness| witness.cost))
            .collect::<Vec<_>>();
        let target_first = first
            .target_normalized()
            .iter()
            .map(|entry| entry.as_ref().map(|witness| witness.cost))
            .collect::<Vec<_>>();
        let target_second = second
            .target_normalized()
            .iter()
            .map(|entry| entry.as_ref().map(|witness| witness.cost))
            .collect::<Vec<_>>();
        assert_eq!(ordinary_first, [Some(0), Some(1), Some(1), Some(2)]);
        assert_eq!(ordinary_second, [Some(0), Some(1), Some(2), Some(1)]);
        assert_eq!(target_first, [Some(1), Some(0), Some(2), Some(1)]);
        assert_eq!(target_second, [Some(1), Some(0), Some(1), Some(2)]);
    }

    #[test]
    fn target_subspace_rank_one_specializes_to_scalar_profile() {
        let normalization = Matrix::new::<2>(1, 1, vec![1]).unwrap();
        let general =
            compile_binary_target_subspace::<Gf4>(&[1, 1, 2], &[0], &normalization, 8, 4).unwrap();
        let scalar = compile_binary_rank_one::<Gf4>(&[1, 1, 2], 0, 8).unwrap();
        assert_eq!(general.demand_dimension(), 1);
        assert_eq!(general.target_union_cost(), scalar.recovery_cost());
        assert_eq!(general.ordinary_candidates_examined(), 8);
        assert_eq!(general.target_candidates_examined(), 4);
        let general_costs = general
            .ordinary()
            .iter()
            .map(|entry| (entry.label.as_slice()[0], entry.cost))
            .collect::<Vec<_>>();
        let scalar_costs = scalar
            .ordinary()
            .iter()
            .enumerate()
            .filter_map(|(label, entry)| entry.as_ref().map(|entry| (label as u8, entry.cost)))
            .collect::<Vec<_>>();
        assert_eq!(general_costs, scalar_costs);
    }

    #[test]
    fn rank_two_target_union_retains_matrix_labels_and_witness() {
        let normalization = Matrix::new::<2>(2, 2, vec![1, 0, 0, 1]).unwrap();
        let profile =
            compile_binary_target_subspace::<Gf4>(&[1, 2, 1, 2], &[0, 1], &normalization, 256, 16)
                .unwrap();
        assert_eq!(profile.demand_dimension(), 2);
        assert_eq!(profile.target_union_cost(), 2);
        assert_eq!(profile.inner_dual().unwrap().cost, 2);
        let zero = profile
            .target_normalized()
            .iter()
            .find(|entry| entry.label.as_slice() == [0, 0])
            .unwrap();
        assert_eq!(zero.cost, 2);
        assert_eq!(zero.coefficients.as_slice(), &[1, 0, 0, 1, 1, 0, 0, 1]);
        let (ordinary, target) = profile.cost_tables::<Gf4>().unwrap();
        assert_eq!(ordinary.shape(), (1, 2));
        assert_eq!(target.shape(), (1, 2));
    }

    #[test]
    fn target_subspace_rejects_dependent_normalization_columns() {
        let normalization = Matrix::new::<2>(2, 2, vec![1, 0, 1, 0]).unwrap();
        assert!(matches!(
            compile_binary_target_subspace::<Gf4>(&[1, 2, 1, 2], &[0, 1], &normalization, 256, 16),
            Err(TransferError::DependentNormalization)
        ));
    }

    #[test]
    fn target_subspace_rejects_nonbinary_matrix_presentation() {
        let normalization = Matrix::new_field::<Gf4>(1, 1, vec![1]).unwrap();
        assert!(matches!(
            compile_binary_target_subspace::<Gf4>(&[1, 1, 2], &[0], &normalization, 8, 4),
            Err(TransferError::Matrix(MatrixError::FieldMismatch))
        ));
    }

    #[test]
    fn enumeration_budget_fails_closed() {
        let error = compile_binary_rank_one::<Gf4>(&[1, 1, 2], 0, 7).unwrap_err();
        assert!(matches!(
            error,
            TransferError::CandidateBudget {
                required: 8,
                budget: 7
            }
        ));
    }

    #[test]
    fn binary_compiler_rejects_odd_characteristic() {
        use crate::field::Prime;

        assert!(matches!(
            compile_binary_rank_one::<Prime<3>>(&[1, 1], 0, 4),
            Err(TransferError::BaseFieldMismatch)
        ));
    }

    #[test]
    fn packed_pair_bases_match_matrix_elimination_for_all_three_column_encoders() {
        use crate::field::Gf4;

        for encoded in 0u8..64 {
            let columns = [encoded & 3, (encoded >> 2) & 3, (encoded >> 4) & 3];
            for target in 0..3 {
                let Ok(profile) = compile_binary_rank_one::<Gf4>(&columns, target, 8) else {
                    continue;
                };
                let mut dual_rows = Vec::new();
                let mut shortened_rows = Vec::new();
                for mask in 1u8..8 {
                    let label = columns
                        .iter()
                        .enumerate()
                        .fold(0u8, |label, (index, &column)| {
                            if mask & (1 << index) == 0 {
                                label
                            } else {
                                Gf4::add(label, column)
                            }
                        });
                    if label != 0 {
                        continue;
                    }
                    let helper_row = (0..3)
                        .filter(|&coordinate| coordinate != target)
                        .map(|coordinate| (mask >> coordinate) & 1)
                        .collect::<Vec<_>>();
                    dual_rows.extend_from_slice(&helper_row);
                    if mask & (1 << target) == 0 {
                        shortened_rows.extend_from_slice(&helper_row);
                    }
                }
                let expected_d = Matrix::new::<2>(dual_rows.len() / 2, 2, dual_rows)
                    .unwrap()
                    .canonical_row_basis::<2>()
                    .unwrap();
                let expected_k = Matrix::new::<2>(shortened_rows.len() / 2, 2, shortened_rows)
                    .unwrap()
                    .canonical_row_basis::<2>()
                    .unwrap();
                assert_eq!(profile.d_p(), &expected_d);
                assert_eq!(profile.k_p(), &expected_k);
            }
        }
    }
}
