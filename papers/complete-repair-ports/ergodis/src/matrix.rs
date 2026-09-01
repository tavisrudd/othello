use crate::field::{FieldError, FiniteField, Prime, SmallField};
use serde::{Deserialize, Serialize};
use thiserror::Error;

#[derive(Debug, Clone, PartialEq, Eq, Error)]
pub enum MatrixError {
    #[error(transparent)]
    Field(#[from] FieldError),
    #[error("matrix dimensions exceed the u16 representation")]
    DimensionOverflow,
    #[error("matrix data length does not match rows times columns")]
    Shape,
    #[error("matrix entries must be reduced modulo the field order")]
    UnreducedEntry,
}

/// Cold owning matrix. Hot DP records use integer IDs into contiguous pools.
#[repr(C)]
#[derive(Clone, Debug, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub struct Matrix {
    data: Box<[u8]>,
    rows: u16,
    cols: u16,
    _pad: u32,
    _reserved: u64,
}

const _: () = assert!(std::mem::size_of::<Matrix>() == 32);
const _: () = assert!(std::mem::align_of::<Matrix>() == 8);

impl Matrix {
    pub fn new<const P: u8>(
        rows: usize,
        cols: usize,
        data: impl Into<Box<[u8]>>,
    ) -> Result<Self, MatrixError> {
        Self::new_field::<Prime<P>>(rows, cols, data)
    }

    pub fn new_field<F: FiniteField>(
        rows: usize,
        cols: usize,
        data: impl Into<Box<[u8]>>,
    ) -> Result<Self, MatrixError> {
        F::validate()?;
        let rows = u16::try_from(rows).map_err(|_| MatrixError::DimensionOverflow)?;
        let cols = u16::try_from(cols).map_err(|_| MatrixError::DimensionOverflow)?;
        let data = data.into();
        if data.len() != rows as usize * cols as usize {
            return Err(MatrixError::Shape);
        }
        if data.iter().any(|&entry| entry >= F::ORDER) {
            return Err(MatrixError::UnreducedEntry);
        }
        Ok(Self {
            data,
            rows,
            cols,
            _pad: 0,
            _reserved: 0,
        })
    }

    /// Construct a matrix over a runtime-selected small field.
    pub fn new_with_field(
        field: &SmallField,
        rows: usize,
        cols: usize,
        data: impl Into<Box<[u8]>>,
    ) -> Result<Self, MatrixError> {
        let rows = u16::try_from(rows).map_err(|_| MatrixError::DimensionOverflow)?;
        let cols = u16::try_from(cols).map_err(|_| MatrixError::DimensionOverflow)?;
        let data = data.into();
        if data.len() != rows as usize * cols as usize {
            return Err(MatrixError::Shape);
        }
        if data.iter().any(|&entry| u16::from(entry) >= field.order()) {
            return Err(MatrixError::UnreducedEntry);
        }
        Ok(Self {
            data,
            rows,
            cols,
            _pad: 0,
            _reserved: 0,
        })
    }

    pub fn zeros<const P: u8>(rows: usize, cols: usize) -> Result<Self, MatrixError> {
        Self::zeros_field::<Prime<P>>(rows, cols)
    }

    pub fn zeros_field<F: FiniteField>(rows: usize, cols: usize) -> Result<Self, MatrixError> {
        Self::new_field::<F>(rows, cols, vec![0; rows.saturating_mul(cols)])
    }

    #[inline]
    pub fn rows(&self) -> usize {
        self.rows as usize
    }

    #[inline]
    pub fn cols(&self) -> usize {
        self.cols as usize
    }

    #[inline]
    pub fn as_slice(&self) -> &[u8] {
        &self.data
    }

    #[inline]
    pub fn row(&self, row: usize) -> &[u8] {
        let start = row * self.cols();
        &self.data[start..start + self.cols()]
    }

    pub fn column(&self, column: usize) -> Box<[u8]> {
        (0..self.rows())
            .map(|row| self.data[row * self.cols() + column])
            .collect::<Vec<_>>()
            .into_boxed_slice()
    }

    pub fn transpose<const P: u8>(&self) -> Result<Self, MatrixError> {
        self.transpose_field::<Prime<P>>()
    }

    pub fn transpose_field<F: FiniteField>(&self) -> Result<Self, MatrixError> {
        let mut data = vec![0; self.data.len()];
        for row in 0..self.rows() {
            for col in 0..self.cols() {
                data[col * self.rows() + row] = self.data[row * self.cols() + col];
            }
        }
        Self::new_field::<F>(self.cols(), self.rows(), data)
    }

    pub fn canonical_row_basis<const P: u8>(&self) -> Result<Self, MatrixError> {
        self.canonical_row_basis_field::<Prime<P>>()
    }

    pub fn canonical_row_basis_field<F: FiniteField>(&self) -> Result<Self, MatrixError> {
        F::validate()?;
        if self.data.iter().any(|&entry| entry >= F::ORDER) {
            return Err(MatrixError::UnreducedEntry);
        }
        let rows = self.rows();
        let cols = self.cols();
        let mut data = self.data.to_vec();
        let pivot_row = canonicalize_rows_in_place_field::<F>(&mut data, rows, cols)?;
        data.truncate(pivot_row * cols);
        Self::new_field::<F>(pivot_row, cols, data)
    }

    pub fn canonical_row_basis_with(&self, field: &SmallField) -> Result<Self, MatrixError> {
        if self
            .data
            .iter()
            .any(|&entry| u16::from(entry) >= field.order())
        {
            return Err(MatrixError::UnreducedEntry);
        }
        let rows = self.rows();
        let cols = self.cols();
        let mut data = self.data.to_vec();
        let pivot_row = canonicalize_rows_in_place_with(field, &mut data, rows, cols)?;
        data.truncate(pivot_row * cols);
        Self::new_with_field(field, pivot_row, cols, data)
    }

    /// Return a canonical row basis for the right kernel of this matrix.
    pub fn null_space<const P: u8>(&self) -> Result<Self, MatrixError> {
        self.null_space_field::<Prime<P>>()
    }

    /// Return a canonical row basis for the right kernel over a static field.
    pub fn null_space_field<F: FiniteField>(&self) -> Result<Self, MatrixError> {
        let reduced = self.canonical_row_basis_field::<F>()?;
        let data = null_space_from_reduced(&reduced, F::sub);
        Self::new_field::<F>(self.cols() - reduced.rows(), self.cols(), data)
    }

    /// Return a canonical row basis for the right kernel over a runtime field.
    pub fn null_space_with(&self, field: &SmallField) -> Result<Self, MatrixError> {
        let reduced = self.canonical_row_basis_with(field)?;
        let data = null_space_from_reduced(&reduced, |left, right| field.sub(left, right));
        Self::new_with_field(field, self.cols() - reduced.rows(), self.cols(), data)
    }

    pub fn append_row<const P: u8>(&self, row: &[u8]) -> Result<Self, MatrixError> {
        self.append_row_field::<Prime<P>>(row)
    }

    pub fn append_row_field<F: FiniteField>(&self, row: &[u8]) -> Result<Self, MatrixError> {
        if row.len() != self.cols() {
            return Err(MatrixError::Shape);
        }
        let mut data = Vec::with_capacity(self.data.len() + row.len());
        data.extend_from_slice(&self.data);
        data.extend_from_slice(row);
        Self::new_field::<F>(self.rows() + 1, self.cols(), data)
    }

    pub fn row_space_contains<const P: u8>(&self, candidate: &Matrix) -> Result<bool, MatrixError> {
        self.row_space_contains_field::<Prime<P>>(candidate)
    }

    pub fn row_space_contains_field<F: FiniteField>(
        &self,
        candidate: &Matrix,
    ) -> Result<bool, MatrixError> {
        if self.cols() != candidate.cols() {
            return Err(MatrixError::Shape);
        }
        let mut joined = self.canonical_row_basis_field::<F>()?;
        let rank = joined.rows();
        for row in 0..candidate.rows() {
            joined = joined.append_row_field::<F>(candidate.row(row))?;
        }
        Ok(joined.canonical_row_basis_field::<F>()?.rows() == rank)
    }
}

pub(crate) fn canonicalize_rows_in_place<const P: u8>(
    data: &mut [u8],
    rows: usize,
    cols: usize,
) -> Result<usize, MatrixError> {
    canonicalize_rows_in_place_field::<Prime<P>>(data, rows, cols)
}

pub(crate) fn canonicalize_rows_in_place_field<F: FiniteField>(
    data: &mut [u8],
    rows: usize,
    cols: usize,
) -> Result<usize, MatrixError> {
    // This is Gaussian elimination over a field.  The `FiniteField` bound is
    // semantically essential: pivot selection relies on every nonzero element
    // being invertible.  Chain-ring modules require Howell/Smith machinery,
    // not a different arithmetic implementation passed through this kernel.
    if data.len() != rows.saturating_mul(cols) {
        return Err(MatrixError::Shape);
    }
    let mut pivot_row = 0usize;
    for col in 0..cols {
        let Some(found) = (pivot_row..rows).find(|&row| data[row * cols + col] != 0) else {
            continue;
        };
        if found != pivot_row {
            for j in 0..cols {
                data.swap(found * cols + j, pivot_row * cols + j);
            }
        }
        let inverse = F::inverse(data[pivot_row * cols + col])?;
        for j in col..cols {
            data[pivot_row * cols + j] = F::mul(data[pivot_row * cols + j], inverse);
        }
        for row in 0..rows {
            if row == pivot_row {
                continue;
            }
            let factor = data[row * cols + col];
            if factor == 0 {
                continue;
            }
            for j in col..cols {
                let product = F::mul(factor, data[pivot_row * cols + j]);
                data[row * cols + j] = F::sub(data[row * cols + j], product);
            }
        }
        pivot_row += 1;
        if pivot_row == rows {
            break;
        }
    }
    Ok(pivot_row)
}

fn canonicalize_rows_in_place_with(
    field: &SmallField,
    data: &mut [u8],
    rows: usize,
    cols: usize,
) -> Result<usize, MatrixError> {
    if data.len() != rows.saturating_mul(cols) {
        return Err(MatrixError::Shape);
    }
    let mut pivot_row = 0usize;
    for col in 0..cols {
        let Some(found) = (pivot_row..rows).find(|&row| data[row * cols + col] != 0) else {
            continue;
        };
        if found != pivot_row {
            for j in 0..cols {
                data.swap(found * cols + j, pivot_row * cols + j);
            }
        }
        let inverse = field.inverse(data[pivot_row * cols + col])?;
        for j in col..cols {
            data[pivot_row * cols + j] = field.mul(data[pivot_row * cols + j], inverse);
        }
        for row in 0..rows {
            if row == pivot_row {
                continue;
            }
            let factor = data[row * cols + col];
            if factor == 0 {
                continue;
            }
            for j in col..cols {
                let product = field.mul(factor, data[pivot_row * cols + j]);
                data[row * cols + j] = field.sub(data[row * cols + j], product);
            }
        }
        pivot_row += 1;
        if pivot_row == rows {
            break;
        }
    }
    Ok(pivot_row)
}

fn null_space_from_reduced(reduced: &Matrix, subtract: impl Fn(u8, u8) -> u8) -> Box<[u8]> {
    let cols = reduced.cols();
    let rank = reduced.rows();
    let mut pivot_columns = Vec::with_capacity(rank);
    let mut is_pivot = vec![false; cols];
    for row in 0..rank {
        let pivot = reduced
            .row(row)
            .iter()
            .position(|&entry| entry != 0)
            .expect("canonical basis rows are nonzero");
        pivot_columns.push(pivot);
        is_pivot[pivot] = true;
    }
    let nullity = cols - rank;
    let mut basis = vec![0; nullity.saturating_mul(cols)];
    let mut basis_row = 0usize;
    for free in 0..cols {
        if is_pivot[free] {
            continue;
        }
        let output = &mut basis[basis_row * cols..(basis_row + 1) * cols];
        output[free] = 1;
        for (row, &pivot) in pivot_columns.iter().enumerate() {
            output[pivot] = subtract(0, reduced.row(row)[free]);
        }
        basis_row += 1;
    }
    basis.into_boxed_slice()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn canonical_basis_is_stable() {
        let matrix = Matrix::new::<3>(3, 3, vec![2, 1, 0, 1, 2, 0, 0, 0, 0]).unwrap();
        let basis = matrix.canonical_row_basis::<3>().unwrap();
        assert_eq!(basis.rows(), 1);
        assert_eq!(basis.as_slice(), &[1, 2, 0]);
        assert_eq!(basis.canonical_row_basis::<3>().unwrap(), basis);
    }

    #[test]
    fn row_space_containment_uses_rank_not_presented_row_count() {
        let redundant = Matrix::new::<2>(2, 2, vec![1, 0, 1, 0]).unwrap();
        let inside = Matrix::new::<2>(1, 2, vec![1, 0]).unwrap();
        let outside = Matrix::new::<2>(1, 2, vec![0, 1]).unwrap();
        assert!(redundant.row_space_contains::<2>(&inside).unwrap());
        assert!(!redundant.row_space_contains::<2>(&outside).unwrap());
    }

    #[test]
    fn gf4_elimination_uses_extension_multiplication() {
        use crate::field::Gf4;

        let matrix = Matrix::new_field::<Gf4>(2, 3, vec![2, 1, 3, 1, 3, 2]).unwrap();
        let basis = matrix.canonical_row_basis_field::<Gf4>().unwrap();
        assert_eq!(basis.rows(), 1);
        assert_eq!(basis.as_slice(), &[1, 3, 2]);
    }

    #[test]
    fn gf4_two_by_two_ranks_match_exhaustive_determinants() {
        use crate::field::{FiniteField, Gf4};

        for encoded in 0u16..256 {
            let mut value = encoded;
            let mut data = [0u8; 4];
            for entry in &mut data {
                *entry = (value & 3) as u8;
                value >>= 2;
            }
            let basis = Matrix::new_field::<Gf4>(2, 2, data.to_vec())
                .unwrap()
                .canonical_row_basis_field::<Gf4>()
                .unwrap();
            let determinant = Gf4::sub(Gf4::mul(data[0], data[3]), Gf4::mul(data[1], data[2]));
            let expected_rank = if determinant != 0 {
                2
            } else if data.iter().any(|&entry| entry != 0) {
                1
            } else {
                0
            };
            assert_eq!(basis.rows(), expected_rank, "encoded matrix {encoded}");
        }
    }

    #[test]
    fn null_space_returns_a_canonical_right_kernel() {
        let matrix = Matrix::new::<3>(2, 3, vec![1, 2, 0, 0, 1, 1]).unwrap();
        let kernel = matrix.null_space::<3>().unwrap();
        assert_eq!(kernel.rows(), 1);
        assert_eq!(kernel.as_slice(), &[2, 2, 1]);
        for row in 0..matrix.rows() {
            let product = (0..matrix.cols()).fold(0, |sum, column| {
                Prime::<3>::add(
                    sum,
                    Prime::<3>::mul(matrix.row(row)[column], kernel.row(0)[column]),
                )
            });
            assert_eq!(product, 0);
        }
    }

    #[test]
    fn runtime_extension_field_elimination_and_null_space_replay() {
        let field = SmallField::new(3, 2).unwrap();
        let matrix = Matrix::new_with_field(&field, 2, 4, vec![1, 3, 4, 2, 0, 1, 5, 7]).unwrap();
        let kernel = matrix.null_space_with(&field).unwrap();
        assert_eq!(kernel.rows(), matrix.cols() - 2);
        for matrix_row in 0..matrix.rows() {
            for kernel_row in 0..kernel.rows() {
                let product = (0..matrix.cols()).fold(0, |sum, column| {
                    field.add(
                        sum,
                        field.mul(
                            matrix.row(matrix_row)[column],
                            kernel.row(kernel_row)[column],
                        ),
                    )
                });
                assert_eq!(product, 0);
            }
        }
    }

    #[test]
    fn runtime_and_static_gf4_null_spaces_match_exhaustively_on_two_by_two_matrices() {
        use crate::field::Gf4;

        let field = SmallField::new(2, 2).unwrap();
        for encoded in 0u16..256 {
            let mut value = encoded;
            let mut data = [0u8; 4];
            for entry in &mut data {
                *entry = (value & 3) as u8;
                value >>= 2;
            }
            let matrix = Matrix::new_field::<Gf4>(2, 2, data.to_vec()).unwrap();
            assert_eq!(
                matrix.null_space_with(&field).unwrap(),
                matrix.null_space_field::<Gf4>().unwrap(),
                "encoded matrix {encoded}"
            );
        }
    }
}
