use crate::field::{BinaryElement, BinarySmallField, SmallField};
use crate::matrix::Matrix;
use std::marker::PhantomData;
use thiserror::Error;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Error)]
pub enum ProjectiveError {
    #[error("the requested field/order specialization is unsupported")]
    UnsupportedOrder,
    #[error("projective-plane incidence construction failed")]
    InvalidIncidence,
    #[error("projective dimension is too large for the index representation")]
    DimensionOverflow,
    #[error("projective coordinates are empty, zero, or contain an invalid field element")]
    InvalidPoint,
    #[error("projective point index is out of range")]
    PointOutOfRange,
    #[error("projective linear action is empty, malformed, singular, or over the wrong field")]
    InvalidLinearAction,
}

/// Allocation-free rank/unrank operations for canonical points of `PG(d,q)`.
///
/// This is projective space over the [`SmallField`] supplied at construction.
/// It is not a projective-Hjelmslev-space indexer: raw coordinates originating
/// in an equal-cardinality chain ring must not be passed through this API.
///
/// Points are ordered by their first nonzero coordinate. That coordinate is
/// normalized to one, and the remaining suffix is a big-endian base-`q`
/// number. The indexer borrows a runtime field and stores only `d + 2` block
/// offsets.
#[derive(Clone, Debug)]
pub struct ProjectiveIndex<'a> {
    field: &'a SmallField,
    vector_dimension: u8,
    point_count: u64,
    offsets: Box<[u64]>,
}

impl<'a> ProjectiveIndex<'a> {
    pub fn new(field: &'a SmallField, projective_dimension: u8) -> Result<Self, ProjectiveError> {
        let vector_dimension = projective_dimension
            .checked_add(1)
            .ok_or(ProjectiveError::DimensionOverflow)?;
        let mut offsets = Vec::with_capacity(usize::from(vector_dimension) + 1);
        offsets.push(0u64);
        let mut block = 1u64;
        let mut blocks = Vec::with_capacity(usize::from(vector_dimension));
        for index in 0..vector_dimension {
            blocks.push(block);
            if index + 1 != vector_dimension {
                block = block
                    .checked_mul(u64::from(field.order()))
                    .ok_or(ProjectiveError::DimensionOverflow)?;
            }
        }
        let mut point_count = 0u64;
        for &block in blocks.iter().rev() {
            point_count = point_count
                .checked_add(block)
                .ok_or(ProjectiveError::DimensionOverflow)?;
            offsets.push(point_count);
        }
        Ok(Self {
            field,
            vector_dimension,
            point_count,
            offsets: offsets.into_boxed_slice(),
        })
    }

    #[inline]
    pub const fn projective_dimension(&self) -> u8 {
        self.vector_dimension - 1
    }

    #[inline]
    pub const fn point_count(&self) -> u64 {
        self.point_count
    }

    /// Rank any nonzero homogeneous vector, normalizing it without allocation.
    pub fn index(&self, coordinates: &[u8]) -> Result<u64, ProjectiveError> {
        if coordinates.len() != usize::from(self.vector_dimension)
            || coordinates
                .iter()
                .any(|&coordinate| u16::from(coordinate) >= self.field.order())
        {
            return Err(ProjectiveError::InvalidPoint);
        }
        let pivot = coordinates
            .iter()
            .position(|&coordinate| coordinate != 0)
            .ok_or(ProjectiveError::InvalidPoint)?;
        let inverse = self
            .field
            .inverse(coordinates[pivot])
            .map_err(|_| ProjectiveError::InvalidPoint)?;
        let mut suffix = 0u64;
        for &coordinate in &coordinates[pivot + 1..] {
            suffix = suffix * u64::from(self.field.order())
                + u64::from(self.field.mul(coordinate, inverse));
        }
        Ok(self.offsets[pivot] + suffix)
    }

    /// Write the canonical representative for an index into caller storage.
    pub fn point(&self, index: u64, output: &mut [u8]) -> Result<(), ProjectiveError> {
        if index >= self.point_count || output.len() != usize::from(self.vector_dimension) {
            return Err(ProjectiveError::PointOutOfRange);
        }
        output.fill(0);
        let pivot = self.offsets[1..].partition_point(|&end| end <= index);
        output[pivot] = 1;
        let mut suffix = index - self.offsets[pivot];
        for coordinate in output[pivot + 1..].iter_mut().rev() {
            *coordinate = (suffix % u64::from(self.field.order())) as u8;
            suffix /= u64::from(self.field.order());
        }
        debug_assert_eq!(suffix, 0);
        Ok(())
    }

    pub fn point_owned(&self, index: u64) -> Result<Box<[u8]>, ProjectiveError> {
        let mut point = vec![0; usize::from(self.vector_dimension)];
        self.point(index, &mut point)?;
        Ok(point.into_boxed_slice())
    }

    #[inline(always)]
    fn index_canonical_nonzero(&self, coordinates: &[u8]) -> Result<u64, ProjectiveError> {
        debug_assert_eq!(coordinates.len(), usize::from(self.vector_dimension));
        debug_assert!(coordinates
            .iter()
            .all(|&coordinate| u16::from(coordinate) < self.field.order()));
        let pivot = coordinates
            .iter()
            .position(|&coordinate| coordinate != 0)
            .ok_or(ProjectiveError::InvalidLinearAction)?;
        let inverse = self.field.inverse_nonzero_canonical(coordinates[pivot]);
        let mut suffix = 0_u64;
        for &coordinate in &coordinates[pivot + 1..] {
            suffix = suffix * u64::from(self.field.order())
                + u64::from(self.field.mul_canonical(coordinate, inverse));
        }
        Ok(self.offsets[pivot] + suffix)
    }
}

/// A validated, flat pack of invertible projective linear generators.
///
/// Construction checks the matrix field presentation, shape, and full rank
/// full rank once. The runner then applies every generator through one flat
/// matrix arena and omits repeated element-range validation. It is intended
/// for orbit traversals whose explicit permutation tables would be too large.
#[derive(Clone, Debug)]
pub struct ProjectiveLinearActionPack<'a, const GENERATORS: usize> {
    index: ProjectiveIndex<'a>,
    matrices: Box<[u8]>,
    _generators: PhantomData<[(); GENERATORS]>,
}

impl<'a, const GENERATORS: usize> ProjectiveLinearActionPack<'a, GENERATORS> {
    pub fn new(
        field: &'a SmallField,
        projective_dimension: u8,
        matrices: [Matrix; GENERATORS],
    ) -> Result<Self, ProjectiveError> {
        if GENERATORS == 0 {
            return Err(ProjectiveError::InvalidLinearAction);
        }
        let index = ProjectiveIndex::new(field, projective_dimension)?;
        let dimension = usize::from(projective_dimension) + 1;
        let matrix_len = dimension
            .checked_mul(dimension)
            .ok_or(ProjectiveError::DimensionOverflow)?;
        let total_len = matrix_len
            .checked_mul(GENERATORS)
            .ok_or(ProjectiveError::DimensionOverflow)?;
        let mut flat = Vec::with_capacity(total_len);
        for matrix in matrices {
            if matrix.rows() != dimension
                || matrix.cols() != dimension
                || matrix.field_presentation() != field.presentation()
            {
                return Err(ProjectiveError::InvalidLinearAction);
            }
            let rank = matrix
                .canonical_row_basis_with(field)
                .map_err(|_| ProjectiveError::InvalidLinearAction)?
                .rows();
            if rank != dimension {
                return Err(ProjectiveError::InvalidLinearAction);
            }
            flat.extend_from_slice(matrix.as_slice());
        }
        Ok(Self {
            index,
            matrices: flat.into_boxed_slice(),
            _generators: PhantomData,
        })
    }

    #[inline]
    pub const fn projective_dimension(&self) -> u8 {
        self.index.projective_dimension()
    }

    #[inline]
    pub const fn point_count(&self) -> u64 {
        self.index.point_count()
    }

    /// Write the canonical representative of a projective point.
    #[inline(always)]
    pub fn point(&self, index: u64, output: &mut [u8]) -> Result<(), ProjectiveError> {
        self.index.point(index, output)
    }

    pub fn workspace(&self) -> ProjectiveActionWorkspace<GENERATORS> {
        let dimension = usize::from(self.index.vector_dimension);
        ProjectiveActionWorkspace {
            point: vec![0; dimension].into_boxed_slice(),
            image: vec![0; dimension].into_boxed_slice(),
            vector_dimension: self.index.vector_dimension,
            _pad: [0; 7],
            _generators: PhantomData,
        }
    }

    pub fn runner<'pack, 'workspace>(
        &'pack self,
        workspace: &'workspace mut ProjectiveActionWorkspace<GENERATORS>,
    ) -> Result<ProjectiveActionRunner<'pack, 'workspace, 'a, GENERATORS>, ProjectiveError> {
        if workspace.vector_dimension != self.index.vector_dimension
            || workspace.point.len() != usize::from(self.index.vector_dimension)
            || workspace.image.len() != usize::from(self.index.vector_dimension)
        {
            return Err(ProjectiveError::InvalidLinearAction);
        }
        Ok(ProjectiveActionRunner {
            pack: self,
            workspace,
        })
    }
}

/// Caller-owned fixed-capacity storage for projective action traversal.
#[repr(C)]
#[derive(Debug)]
pub struct ProjectiveActionWorkspace<const GENERATORS: usize> {
    point: Box<[u8]>,
    image: Box<[u8]>,
    vector_dimension: u8,
    _pad: [u8; 7],
    _generators: PhantomData<[(); GENERATORS]>,
}

const _: () = assert!(std::mem::size_of::<ProjectiveActionWorkspace<1>>() == 40);
const _: () = assert!(std::mem::align_of::<ProjectiveActionWorkspace<1>>() == 8);

/// Validate-once view whose successor operation allocates nothing.
pub struct ProjectiveActionRunner<'pack, 'workspace, 'field, const GENERATORS: usize> {
    pack: &'pack ProjectiveLinearActionPack<'field, GENERATORS>,
    workspace: &'workspace mut ProjectiveActionWorkspace<GENERATORS>,
}

impl<'pack, 'workspace, 'field, const GENERATORS: usize>
    ProjectiveActionRunner<'pack, 'workspace, 'field, GENERATORS>
{
    #[inline(always)]
    pub fn successors(&mut self, index: u64) -> Result<[u64; GENERATORS], ProjectiveError> {
        self.pack.index.point(index, &mut self.workspace.point)?;
        let dimension = usize::from(self.pack.index.vector_dimension);
        let matrix_len = dimension * dimension;
        let field = self.pack.index.field;
        let mut successors = [0_u64; GENERATORS];
        for (generator, successor) in successors.iter_mut().enumerate() {
            let matrix = &self.pack.matrices[generator * matrix_len..(generator + 1) * matrix_len];
            for (row, output) in self.workspace.image.iter_mut().enumerate() {
                let mut sum = 0_u8;
                let row = &matrix[row * dimension..(row + 1) * dimension];
                for (&coefficient, &coordinate) in row.iter().zip(self.workspace.point.iter()) {
                    if coefficient != 0 && coordinate != 0 {
                        sum =
                            field.add_canonical(sum, field.mul_canonical(coefficient, coordinate));
                    }
                }
                *output = sum;
            }
            *successor = self
                .pack
                .index
                .index_canonical_nonzero(&self.workspace.image)?;
        }
        Ok(successors)
    }
}

/// Allocation-free rank/unrank specialized for `PG(d, 2^H)`.
///
/// This is an exact representation specialization of [`ProjectiveIndex`].
/// Base-`2^H` multiplication and digit extraction become shifts and masks,
/// while normalized coordinate multiplication uses [`BinarySmallField`].
/// Construction validates the runtime field once, outside client loops.
#[repr(C)]
#[derive(Clone, Debug)]
pub struct BinaryProjectiveIndex<'a, const H: u8> {
    offsets: Box<[u64]>,
    field: BinarySmallField<'a, H>,
    point_count: u64,
    vector_dimension: u8,
    _pad: [u8; 7],
}

const _: () = assert!(std::mem::size_of::<BinaryProjectiveIndex<'static, 1>>() == 40);
const _: () = assert!(std::mem::align_of::<BinaryProjectiveIndex<'static, 1>>() == 8);

impl<'a, const H: u8> BinaryProjectiveIndex<'a, H> {
    pub fn new(field: &'a SmallField, projective_dimension: u8) -> Result<Self, ProjectiveError> {
        let field = field
            .binary_extension::<H>()
            .map_err(|_| ProjectiveError::UnsupportedOrder)?;
        let vector_dimension = projective_dimension
            .checked_add(1)
            .ok_or(ProjectiveError::DimensionOverflow)?;
        let mut offsets = Vec::with_capacity(usize::from(vector_dimension) + 1);
        offsets.push(0_u64);
        let highest_shift = u32::from(H) * u32::from(vector_dimension - 1);
        let mut block = 1_u64
            .checked_shl(highest_shift)
            .ok_or(ProjectiveError::DimensionOverflow)?;
        let mut point_count = 0_u64;
        for _ in 0..vector_dimension {
            point_count = point_count
                .checked_add(block)
                .ok_or(ProjectiveError::DimensionOverflow)?;
            offsets.push(point_count);
            block >>= H;
        }
        Ok(Self {
            offsets: offsets.into_boxed_slice(),
            field,
            point_count,
            vector_dimension,
            _pad: [0; 7],
        })
    }

    #[inline]
    pub const fn projective_dimension(&self) -> u8 {
        self.vector_dimension - 1
    }

    #[inline]
    pub const fn point_count(&self) -> u64 {
        self.point_count
    }

    /// Locate the canonical chart containing a validated point index.
    ///
    /// The leading affine chart contains `(q - 1) / q` of `PG(d, q)`, so a
    /// direct first-chart test avoids binary search for at least half of all
    /// indices and for 63/64 of `PG(d, 64)`.
    #[inline(always)]
    fn pivot_for_validated_index(&self, index: u64) -> usize {
        if index < self.offsets[1] {
            0
        } else {
            1 + self.offsets[2..].partition_point(|&end| end <= index)
        }
    }

    /// Rank a nonzero homogeneous vector with canonical `GF(2^H)` entries.
    #[inline(always)]
    pub fn index(&self, coordinates: &[u8]) -> Result<u64, ProjectiveError> {
        if coordinates.len() != usize::from(self.vector_dimension) {
            return Err(ProjectiveError::InvalidPoint);
        }
        let mut pivot = None;
        let mut invalid = 0_u16;
        for (position, &coordinate) in coordinates.iter().enumerate() {
            invalid |= u16::from(coordinate) >> H;
            if pivot.is_none() && coordinate != 0 {
                pivot = Some(position);
            }
        }
        if invalid != 0 {
            return Err(ProjectiveError::InvalidPoint);
        }
        let pivot = pivot.ok_or(ProjectiveError::InvalidPoint)?;
        let inverse = self.field.inverse_nonzero(coordinates[pivot]);
        let mut suffix = 0_u64;
        for &coordinate in &coordinates[pivot + 1..] {
            let normalized = self.field.mul_canonical(coordinate, inverse);
            suffix = (suffix << H) | u64::from(normalized);
        }
        Ok(self.offsets[pivot] + suffix)
    }

    /// Rank a nonzero vector whose canonical encoding was validated earlier.
    #[inline(always)]
    pub fn index_elements(&self, coordinates: &[BinaryElement<H>]) -> Result<u64, ProjectiveError> {
        if coordinates.len() != usize::from(self.vector_dimension) {
            return Err(ProjectiveError::InvalidPoint);
        }
        let pivot = coordinates
            .iter()
            .position(|coordinate| coordinate.value() != 0)
            .ok_or(ProjectiveError::InvalidPoint)?;
        let inverse = self.field.inverse_nonzero(coordinates[pivot].value());
        let mut suffix = 0_u64;
        for &coordinate in &coordinates[pivot + 1..] {
            let normalized = self.field.mul_canonical(coordinate.value(), inverse);
            suffix = (suffix << H) | u64::from(normalized);
        }
        Ok(self.offsets[pivot] + suffix)
    }

    /// Write the canonical representative for an index into caller storage.
    #[inline(always)]
    pub fn point(&self, index: u64, output: &mut [u8]) -> Result<(), ProjectiveError> {
        if index >= self.point_count || output.len() != usize::from(self.vector_dimension) {
            return Err(ProjectiveError::PointOutOfRange);
        }
        output.fill(0);
        let pivot = self.pivot_for_validated_index(index);
        output[pivot] = 1;
        let mut suffix = index - self.offsets[pivot];
        let mask = (1_u64 << H) - 1;
        for coordinate in output[pivot + 1..].iter_mut().rev() {
            *coordinate = (suffix & mask) as u8;
            suffix >>= H;
        }
        debug_assert_eq!(suffix, 0);
        Ok(())
    }

    /// Write a typed canonical representative into caller-owned storage.
    #[inline(always)]
    pub fn point_elements(
        &self,
        index: u64,
        output: &mut [BinaryElement<H>],
    ) -> Result<(), ProjectiveError> {
        if index >= self.point_count || output.len() != usize::from(self.vector_dimension) {
            return Err(ProjectiveError::PointOutOfRange);
        }
        output.fill(self.field.zero());
        let pivot = self.pivot_for_validated_index(index);
        output[pivot] = self.field.one();
        let mut suffix = index - self.offsets[pivot];
        let mask = (1_u64 << H) - 1;
        for coordinate in output[pivot + 1..].iter_mut().rev() {
            *coordinate = BinaryElement::from_canonical((suffix & mask) as u8);
            suffix >>= H;
        }
        Ok(())
    }

    #[inline(always)]
    fn point_into_validated_workspace(&self, index: u64, output: &mut [u8]) {
        debug_assert!(index < self.point_count);
        debug_assert_eq!(output.len(), usize::from(self.vector_dimension));
        output.fill(0);
        let pivot = self.pivot_for_validated_index(index);
        output[pivot] = 1;
        let mut suffix = index - self.offsets[pivot];
        let mask = (1_u64 << H) - 1;
        for coordinate in output[pivot + 1..].iter_mut().rev() {
            *coordinate = (suffix & mask) as u8;
            suffix >>= H;
        }
        debug_assert_eq!(suffix, 0);
    }

    #[inline(always)]
    fn index_canonical_nonzero(&self, coordinates: &[u8]) -> Result<u64, ProjectiveError> {
        debug_assert_eq!(coordinates.len(), usize::from(self.vector_dimension));
        debug_assert!(coordinates
            .iter()
            .all(|&coordinate| u16::from(coordinate) < self.field.order()));
        // A canonical leading one is already normalized in the first chart,
        // whose offset is zero. Ranking is therefore just its radix suffix.
        if coordinates[0] == 1 {
            let mut suffix = 0_u64;
            for &coordinate in &coordinates[1..] {
                suffix = (suffix << H) | u64::from(coordinate);
            }
            return Ok(suffix);
        }
        let pivot = coordinates
            .iter()
            .position(|&coordinate| coordinate != 0)
            .ok_or(ProjectiveError::InvalidLinearAction)?;
        let inverse = self.field.inverse_nonzero(coordinates[pivot]);
        let mut suffix = 0_u64;
        for &coordinate in &coordinates[pivot + 1..] {
            suffix = (suffix << H) | u64::from(self.field.mul_canonical(coordinate, inverse));
        }
        Ok(self.offsets[pivot] + suffix)
    }
}

/// A validate-once projective action pack specialized for `GF(2^H)`.
///
/// This is the fused-action counterpart of [`BinaryProjectiveIndex`]. It keeps
/// the generic action pack untouched while replacing projective radix division
/// with shifts, field addition with XOR, and the matrix inner-loop branches
/// with canonical multiplication-table lookups. Construction validates the
/// field presentation, matrix shape, and invertibility once.
#[repr(C)]
#[derive(Clone, Debug)]
pub struct BinaryProjectiveLinearActionPack<'a, const H: u8, const GENERATORS: usize> {
    index: BinaryProjectiveIndex<'a, H>,
    matrices: Box<[u8]>,
    _generators: PhantomData<[(); GENERATORS]>,
}

const _: () = assert!(std::mem::size_of::<BinaryProjectiveLinearActionPack<'static, 1, 1>>() == 56);
const _: () = assert!(std::mem::align_of::<BinaryProjectiveLinearActionPack<'static, 1, 1>>() == 8);

impl<'a, const H: u8, const GENERATORS: usize> BinaryProjectiveLinearActionPack<'a, H, GENERATORS> {
    pub fn new(
        field: &'a SmallField,
        projective_dimension: u8,
        matrices: [Matrix; GENERATORS],
    ) -> Result<Self, ProjectiveError> {
        if GENERATORS == 0 {
            return Err(ProjectiveError::InvalidLinearAction);
        }
        let index = BinaryProjectiveIndex::<H>::new(field, projective_dimension)?;
        let dimension = usize::from(projective_dimension) + 1;
        let matrix_len = dimension
            .checked_mul(dimension)
            .ok_or(ProjectiveError::DimensionOverflow)?;
        let total_len = matrix_len
            .checked_mul(GENERATORS)
            .ok_or(ProjectiveError::DimensionOverflow)?;
        let mut flat = Vec::with_capacity(total_len);
        for matrix in matrices {
            if matrix.rows() != dimension
                || matrix.cols() != dimension
                || matrix.field_presentation() != field.presentation()
            {
                return Err(ProjectiveError::InvalidLinearAction);
            }
            let rank = matrix
                .canonical_row_basis_with(field)
                .map_err(|_| ProjectiveError::InvalidLinearAction)?
                .rows();
            if rank != dimension {
                return Err(ProjectiveError::InvalidLinearAction);
            }
            flat.extend_from_slice(matrix.as_slice());
        }
        Ok(Self {
            index,
            matrices: flat.into_boxed_slice(),
            _generators: PhantomData,
        })
    }

    #[inline]
    pub const fn projective_dimension(&self) -> u8 {
        self.index.projective_dimension()
    }

    #[inline]
    pub const fn point_count(&self) -> u64 {
        self.index.point_count()
    }

    #[inline(always)]
    pub fn point(&self, index: u64, output: &mut [u8]) -> Result<(), ProjectiveError> {
        self.index.point(index, output)
    }

    pub fn workspace(&self) -> ProjectiveActionWorkspace<GENERATORS> {
        let dimension = usize::from(self.index.vector_dimension);
        ProjectiveActionWorkspace {
            point: vec![0; dimension].into_boxed_slice(),
            image: vec![0; dimension].into_boxed_slice(),
            vector_dimension: self.index.vector_dimension,
            _pad: [0; 7],
            _generators: PhantomData,
        }
    }

    pub fn runner<'pack, 'workspace>(
        &'pack self,
        workspace: &'workspace mut ProjectiveActionWorkspace<GENERATORS>,
    ) -> Result<BinaryProjectiveActionRunner<'pack, 'workspace, 'a, H, GENERATORS>, ProjectiveError>
    {
        if workspace.vector_dimension != self.index.vector_dimension
            || workspace.point.len() != usize::from(self.index.vector_dimension)
            || workspace.image.len() != usize::from(self.index.vector_dimension)
        {
            return Err(ProjectiveError::InvalidLinearAction);
        }
        Ok(BinaryProjectiveActionRunner {
            pack: self,
            workspace,
        })
    }
}

/// Validate-once, allocation-free runner for a binary projective action pack.
#[repr(C)]
pub struct BinaryProjectiveActionRunner<
    'pack,
    'workspace,
    'field,
    const H: u8,
    const GENERATORS: usize,
> {
    pack: &'pack BinaryProjectiveLinearActionPack<'field, H, GENERATORS>,
    workspace: &'workspace mut ProjectiveActionWorkspace<GENERATORS>,
}

const _: () = assert!(
    std::mem::size_of::<BinaryProjectiveActionRunner<'static, 'static, 'static, 1, 1>>() == 16
);
const _: () = assert!(
    std::mem::align_of::<BinaryProjectiveActionRunner<'static, 'static, 'static, 1, 1>>() == 8
);

impl<'pack, 'workspace, 'field, const H: u8, const GENERATORS: usize>
    BinaryProjectiveActionRunner<'pack, 'workspace, 'field, H, GENERATORS>
{
    #[inline(always)]
    pub fn successors(&mut self, index: u64) -> Result<[u64; GENERATORS], ProjectiveError> {
        if index >= self.pack.index.point_count {
            return Err(ProjectiveError::PointOutOfRange);
        }
        self.pack
            .index
            .point_into_validated_workspace(index, &mut self.workspace.point);
        let dimension = usize::from(self.pack.index.vector_dimension);
        let matrix_len = dimension * dimension;
        let field = self.pack.index.field;
        let mut successors = [0_u64; GENERATORS];
        for (generator, successor) in successors.iter_mut().enumerate() {
            let matrix = &self.pack.matrices[generator * matrix_len..(generator + 1) * matrix_len];
            for (row, output) in self.workspace.image.iter_mut().enumerate() {
                let row = &matrix[row * dimension..(row + 1) * dimension];
                let mut sum = 0_u8;
                for (&coefficient, &coordinate) in row.iter().zip(self.workspace.point.iter()) {
                    sum ^= field.mul_canonical(coefficient, coordinate);
                }
                *output = sum;
            }
            *successor = self
                .pack
                .index
                .index_canonical_nonzero(&self.workspace.image)?;
        }
        Ok(successors)
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct BinarySparseAction {
    unit_start: u32,
    unit_end: u32,
    weighted_start: u32,
    weighted_end: u32,
}

const _: () = assert!(std::mem::size_of::<BinarySparseAction>() == 16);
const _: () = assert!(std::mem::align_of::<BinarySparseAction>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct BinaryUnitActionTerm {
    output: u8,
    input: u8,
}

const _: () = assert!(std::mem::size_of::<BinaryUnitActionTerm>() == 2);
const _: () = assert!(std::mem::align_of::<BinaryUnitActionTerm>() == 1);

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct BinaryWeightedActionTerm {
    output: u8,
    input: u8,
    coefficient: u8,
    _pad: u8,
}

const _: () = assert!(std::mem::size_of::<BinaryWeightedActionTerm>() == 4);
const _: () = assert!(std::mem::align_of::<BinaryWeightedActionTerm>() == 1);

/// A validate-once sparse projective action pack over `GF(2^H)`.
///
/// Zero coefficients are removed, coefficients equal to one become direct XOR
/// terms, and only the remaining nonzero coefficients perform multiplication
/// table lookups. This is intended for permutation, diagonal, triangular, and
/// other structurally sparse generator families. Construction performs the
/// same field-presentation, shape, and invertibility checks as
/// [`BinaryProjectiveLinearActionPack`].
#[repr(C)]
#[derive(Clone, Debug)]
pub struct BinarySparseProjectiveLinearActionPack<'a, const H: u8, const GENERATORS: usize> {
    index: BinaryProjectiveIndex<'a, H>,
    actions: Box<[BinarySparseAction]>,
    unit_terms: Box<[BinaryUnitActionTerm]>,
    weighted_terms: Box<[BinaryWeightedActionTerm]>,
    _generators: PhantomData<[(); GENERATORS]>,
}

const _: () =
    assert!(std::mem::size_of::<BinarySparseProjectiveLinearActionPack<'static, 1, 1>>() == 88);
const _: () =
    assert!(std::mem::align_of::<BinarySparseProjectiveLinearActionPack<'static, 1, 1>>() == 8);

impl<'a, const H: u8, const GENERATORS: usize>
    BinarySparseProjectiveLinearActionPack<'a, H, GENERATORS>
{
    pub fn new(
        field: &'a SmallField,
        projective_dimension: u8,
        matrices: [Matrix; GENERATORS],
    ) -> Result<Self, ProjectiveError> {
        if GENERATORS == 0 {
            return Err(ProjectiveError::InvalidLinearAction);
        }
        let index = BinaryProjectiveIndex::<H>::new(field, projective_dimension)?;
        let dimension = usize::from(projective_dimension) + 1;
        let mut actions = Vec::with_capacity(GENERATORS);
        let mut unit_terms = Vec::new();
        let mut weighted_terms = Vec::new();
        for matrix in matrices {
            if matrix.rows() != dimension
                || matrix.cols() != dimension
                || matrix.field_presentation() != field.presentation()
            {
                return Err(ProjectiveError::InvalidLinearAction);
            }
            let rank = matrix
                .canonical_row_basis_with(field)
                .map_err(|_| ProjectiveError::InvalidLinearAction)?
                .rows();
            if rank != dimension {
                return Err(ProjectiveError::InvalidLinearAction);
            }
            let unit_start =
                u32::try_from(unit_terms.len()).map_err(|_| ProjectiveError::DimensionOverflow)?;
            let weighted_start = u32::try_from(weighted_terms.len())
                .map_err(|_| ProjectiveError::DimensionOverflow)?;
            for (output, row) in matrix.as_slice().chunks_exact(dimension).enumerate() {
                for (column, &coefficient) in row.iter().enumerate() {
                    if coefficient == 1 {
                        unit_terms.push(BinaryUnitActionTerm {
                            output: output as u8,
                            input: column as u8,
                        });
                    } else if coefficient != 0 {
                        weighted_terms.push(BinaryWeightedActionTerm {
                            output: output as u8,
                            input: column as u8,
                            coefficient,
                            _pad: 0,
                        });
                    }
                }
            }
            actions.push(BinarySparseAction {
                unit_start,
                unit_end: u32::try_from(unit_terms.len())
                    .map_err(|_| ProjectiveError::DimensionOverflow)?,
                weighted_start,
                weighted_end: u32::try_from(weighted_terms.len())
                    .map_err(|_| ProjectiveError::DimensionOverflow)?,
            });
        }
        Ok(Self {
            index,
            actions: actions.into_boxed_slice(),
            unit_terms: unit_terms.into_boxed_slice(),
            weighted_terms: weighted_terms.into_boxed_slice(),
            _generators: PhantomData,
        })
    }

    #[inline]
    pub const fn projective_dimension(&self) -> u8 {
        self.index.projective_dimension()
    }

    #[inline]
    pub const fn point_count(&self) -> u64 {
        self.index.point_count()
    }

    #[inline(always)]
    pub fn point(&self, index: u64, output: &mut [u8]) -> Result<(), ProjectiveError> {
        self.index.point(index, output)
    }

    pub fn workspace(&self) -> ProjectiveActionWorkspace<GENERATORS> {
        let dimension = usize::from(self.index.vector_dimension);
        ProjectiveActionWorkspace {
            point: vec![0; dimension].into_boxed_slice(),
            image: vec![0; dimension].into_boxed_slice(),
            vector_dimension: self.index.vector_dimension,
            _pad: [0; 7],
            _generators: PhantomData,
        }
    }

    pub fn runner<'pack, 'workspace>(
        &'pack self,
        workspace: &'workspace mut ProjectiveActionWorkspace<GENERATORS>,
    ) -> Result<
        BinarySparseProjectiveActionRunner<'pack, 'workspace, 'a, H, GENERATORS>,
        ProjectiveError,
    > {
        if workspace.vector_dimension != self.index.vector_dimension
            || workspace.point.len() != usize::from(self.index.vector_dimension)
            || workspace.image.len() != usize::from(self.index.vector_dimension)
        {
            return Err(ProjectiveError::InvalidLinearAction);
        }
        Ok(BinarySparseProjectiveActionRunner {
            pack: self,
            workspace,
        })
    }
}

/// Validate-once, allocation-free runner for a sparse binary action pack.
#[repr(C)]
pub struct BinarySparseProjectiveActionRunner<
    'pack,
    'workspace,
    'field,
    const H: u8,
    const GENERATORS: usize,
> {
    pack: &'pack BinarySparseProjectiveLinearActionPack<'field, H, GENERATORS>,
    workspace: &'workspace mut ProjectiveActionWorkspace<GENERATORS>,
}

const _: () = assert!(
    std::mem::size_of::<BinarySparseProjectiveActionRunner<'static, 'static, 'static, 1, 1>>()
        == 16
);
const _: () = assert!(
    std::mem::align_of::<BinarySparseProjectiveActionRunner<'static, 'static, 'static, 1, 1>>()
        == 8
);

impl<'pack, 'workspace, 'field, const H: u8, const GENERATORS: usize>
    BinarySparseProjectiveActionRunner<'pack, 'workspace, 'field, H, GENERATORS>
{
    #[inline(always)]
    pub fn successors(&mut self, index: u64) -> Result<[u64; GENERATORS], ProjectiveError> {
        if index >= self.pack.index.point_count {
            return Err(ProjectiveError::PointOutOfRange);
        }
        self.pack
            .index
            .point_into_validated_workspace(index, &mut self.workspace.point);
        let field = self.pack.index.field;
        let mut successors = [0_u64; GENERATORS];
        for (action, successor) in self.pack.actions.iter().zip(successors.iter_mut()) {
            self.workspace.image.fill(0);
            for term in &self.pack.unit_terms[action.unit_start as usize..action.unit_end as usize]
            {
                let output = usize::from(term.output);
                let input = usize::from(term.input);
                // SAFETY: construction records terms only while enumerating a
                // validated square matrix whose dimension is the workspace
                // dimension checked by `runner`.
                unsafe {
                    *self.workspace.image.get_unchecked_mut(output) ^=
                        *self.workspace.point.get_unchecked(input);
                }
            }
            for term in &self.pack.weighted_terms
                [action.weighted_start as usize..action.weighted_end as usize]
            {
                let output = usize::from(term.output);
                let input = usize::from(term.input);
                // SAFETY: the same validate-once matrix/workspace invariant as
                // the unit tape applies to both indices.
                unsafe {
                    *self.workspace.image.get_unchecked_mut(output) ^= field.mul_canonical(
                        term.coefficient,
                        *self.workspace.point.get_unchecked(input),
                    );
                }
            }
            *successor = self
                .pack
                .index
                .index_canonical_nonzero(&self.workspace.image)?;
        }
        Ok(successors)
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct BinaryLaneAction {
    unit_start: u32,
    unit_end: u32,
    weighted_start: u32,
    weighted_end: u32,
}

const _: () = assert!(std::mem::size_of::<BinaryLaneAction>() == 16);
const _: () = assert!(std::mem::align_of::<BinaryLaneAction>() == 4);

// A unit anti-diagonal matrix reverses the packed coordinate bytes exactly.
// Reserve an otherwise invalid tape start so the hot action record keeps its
// compact 16-byte stride without adding a tag field.
const BINARY_LANE_UNIT_REVERSAL: u32 = 1 << 31;
// In characteristic two, the lower Pascal matrix has entry `(row, column)`
// equal to one exactly when the column-bit set is contained in the row-bit
// set. Its action is the Boolean subset-zeta transform on the coordinate
// lanes, implemented by three packed shift/XOR stages for at most eight lanes.
const BINARY_LANE_SUBSET_ZETA: u32 = BINARY_LANE_UNIT_REVERSAL + 1;

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct BinaryLaneUnitTerm {
    lane_mask: u64,
    input_shift: u8,
    _pad: [u8; 7],
}

const _: () = assert!(std::mem::size_of::<BinaryLaneUnitTerm>() == 16);
const _: () = assert!(std::mem::align_of::<BinaryLaneUnitTerm>() == 8);

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct BinaryLaneWeightedTerm {
    input_shift: u8,
    output_shift: u8,
    coefficient: u8,
    _pad: u8,
}

const _: () = assert!(std::mem::size_of::<BinaryLaneWeightedTerm>() == 4);
const _: () = assert!(std::mem::align_of::<BinaryLaneWeightedTerm>() == 1);

/// A validate-once byte-lane projective action pack over `GF(2^H)`.
///
/// For vector dimensions at most eight, canonical field bytes occupy disjoint
/// lanes of one `u64`. Unit coefficients with the same input coordinate are
/// compiled into a lane mask, so one integer multiplication broadcasts that
/// coordinate to every selected output row without cross-lane carries.
/// Nonunit coefficients remain exact multiplication-table terms. The runner
/// keeps points and images packed through projective rank/unrank and allocates
/// no workspace.
#[repr(C)]
#[derive(Clone, Debug)]
pub struct BinaryLaneProjectiveLinearActionPack<
    'a,
    const H: u8,
    const DIMENSION: usize,
    const GENERATORS: usize,
> {
    index: BinaryProjectiveIndex<'a, H>,
    actions: Box<[BinaryLaneAction]>,
    unit_terms: Box<[BinaryLaneUnitTerm]>,
    weighted_terms: Box<[BinaryLaneWeightedTerm]>,
    _shape: PhantomData<([(); DIMENSION], [(); GENERATORS])>,
}

const _: () =
    assert!(std::mem::size_of::<BinaryLaneProjectiveLinearActionPack<'static, 1, 1, 1>>() == 88);
const _: () =
    assert!(std::mem::align_of::<BinaryLaneProjectiveLinearActionPack<'static, 1, 1, 1>>() == 8);

impl<'a, const H: u8, const DIMENSION: usize, const GENERATORS: usize>
    BinaryLaneProjectiveLinearActionPack<'a, H, DIMENSION, GENERATORS>
{
    pub fn new(
        field: &'a SmallField,
        projective_dimension: u8,
        matrices: [Matrix; GENERATORS],
    ) -> Result<Self, ProjectiveError> {
        if GENERATORS == 0 || DIMENSION == 0 || DIMENSION > 8 {
            return Err(ProjectiveError::InvalidLinearAction);
        }
        if usize::from(projective_dimension) + 1 != DIMENSION {
            return Err(ProjectiveError::InvalidLinearAction);
        }
        let index = BinaryProjectiveIndex::<H>::new(field, projective_dimension)?;
        let mut actions = Vec::with_capacity(GENERATORS);
        let mut unit_terms = Vec::new();
        let mut weighted_terms = Vec::new();
        for matrix in matrices {
            if matrix.rows() != DIMENSION
                || matrix.cols() != DIMENSION
                || matrix.field_presentation() != field.presentation()
            {
                return Err(ProjectiveError::InvalidLinearAction);
            }
            let rank = matrix
                .canonical_row_basis_with(field)
                .map_err(|_| ProjectiveError::InvalidLinearAction)?
                .rows();
            if rank != DIMENSION {
                return Err(ProjectiveError::InvalidLinearAction);
            }
            let unit_reversal = (0..DIMENSION).all(|output| {
                (0..DIMENSION).all(|input| {
                    matrix.as_slice()[output * DIMENSION + input]
                        == u8::from(input == DIMENSION - 1 - output)
                })
            });
            if unit_reversal {
                actions.push(BinaryLaneAction {
                    unit_start: BINARY_LANE_UNIT_REVERSAL,
                    unit_end: 0,
                    weighted_start: 0,
                    weighted_end: 0,
                });
                continue;
            }
            let subset_zeta = (0..DIMENSION).all(|output| {
                (0..DIMENSION).all(|input| {
                    matrix.as_slice()[output * DIMENSION + input] == u8::from(input & !output == 0)
                })
            });
            if subset_zeta {
                actions.push(BinaryLaneAction {
                    unit_start: BINARY_LANE_SUBSET_ZETA,
                    unit_end: 0,
                    weighted_start: 0,
                    weighted_end: 0,
                });
                continue;
            }
            let unit_start =
                u32::try_from(unit_terms.len()).map_err(|_| ProjectiveError::DimensionOverflow)?;
            let weighted_start = u32::try_from(weighted_terms.len())
                .map_err(|_| ProjectiveError::DimensionOverflow)?;
            for input in 0..DIMENSION {
                let mut lane_mask = 0_u64;
                for output in 0..DIMENSION {
                    let coefficient = matrix.as_slice()[output * DIMENSION + input];
                    if coefficient == 1 {
                        lane_mask |= 1_u64 << (8 * output);
                    } else if coefficient != 0 {
                        weighted_terms.push(BinaryLaneWeightedTerm {
                            input_shift: (8 * input) as u8,
                            output_shift: (8 * output) as u8,
                            coefficient,
                            _pad: 0,
                        });
                    }
                }
                if lane_mask != 0 {
                    unit_terms.push(BinaryLaneUnitTerm {
                        lane_mask,
                        input_shift: (8 * input) as u8,
                        _pad: [0; 7],
                    });
                }
            }
            actions.push(BinaryLaneAction {
                unit_start,
                unit_end: u32::try_from(unit_terms.len())
                    .map_err(|_| ProjectiveError::DimensionOverflow)?,
                weighted_start,
                weighted_end: u32::try_from(weighted_terms.len())
                    .map_err(|_| ProjectiveError::DimensionOverflow)?,
            });
        }
        Ok(Self {
            index,
            actions: actions.into_boxed_slice(),
            unit_terms: unit_terms.into_boxed_slice(),
            weighted_terms: weighted_terms.into_boxed_slice(),
            _shape: PhantomData,
        })
    }

    #[inline]
    pub const fn projective_dimension(&self) -> u8 {
        self.index.projective_dimension()
    }

    #[inline]
    pub const fn point_count(&self) -> u64 {
        self.index.point_count()
    }

    #[inline(always)]
    pub fn point(&self, index: u64, output: &mut [u8]) -> Result<(), ProjectiveError> {
        self.index.point(index, output)
    }

    #[inline]
    pub const fn workspace(&self) -> BinaryLaneProjectiveActionWorkspace {
        BinaryLaneProjectiveActionWorkspace { _private: () }
    }

    #[inline]
    pub fn runner(
        &self,
        _workspace: &mut BinaryLaneProjectiveActionWorkspace,
    ) -> Result<BinaryLaneProjectiveActionRunner<'_, 'a, H, DIMENSION, GENERATORS>, ProjectiveError>
    {
        Ok(BinaryLaneProjectiveActionRunner { pack: self })
    }
}

/// Zero-sized compatibility workspace for a byte-lane action runner.
#[repr(C)]
pub struct BinaryLaneProjectiveActionWorkspace {
    _private: (),
}

const _: () = assert!(std::mem::size_of::<BinaryLaneProjectiveActionWorkspace>() == 0);
const _: () = assert!(std::mem::align_of::<BinaryLaneProjectiveActionWorkspace>() == 1);

/// Allocation-free runner for a validated byte-lane binary action pack.
#[repr(transparent)]
pub struct BinaryLaneProjectiveActionRunner<
    'pack,
    'field,
    const H: u8,
    const DIMENSION: usize,
    const GENERATORS: usize,
> {
    pack: &'pack BinaryLaneProjectiveLinearActionPack<'field, H, DIMENSION, GENERATORS>,
}

const _: () = assert!(
    std::mem::size_of::<BinaryLaneProjectiveActionRunner<'static, 'static, 1, 1, 1>>() == 8
);
const _: () = assert!(
    std::mem::align_of::<BinaryLaneProjectiveActionRunner<'static, 'static, 1, 1, 1>>() == 8
);

impl<'pack, 'field, const H: u8, const DIMENSION: usize, const GENERATORS: usize>
    BinaryLaneProjectiveActionRunner<'pack, 'field, H, DIMENSION, GENERATORS>
{
    #[inline(always)]
    fn packed_point(&self, index: u64) -> u64 {
        let pivot = self.pack.index.pivot_for_validated_index(index);
        let mut point = 1_u64 << (8 * pivot);
        let mut suffix = index - self.pack.index.offsets[pivot];
        let mask = (1_u64 << H) - 1;
        for output in (pivot + 1..DIMENSION).rev() {
            point |= (suffix & mask) << (8 * output);
            suffix >>= H;
        }
        debug_assert_eq!(suffix, 0);
        point
    }

    #[inline(always)]
    fn packed_index(&self, point: u64) -> u64 {
        if point as u8 == 1 {
            let mut suffix = 0_u64;
            for input in 1..DIMENSION {
                suffix = (suffix << H) | ((point >> (8 * input)) & 0xff);
            }
            return suffix;
        }
        let mut pivot = 0_usize;
        while pivot < DIMENSION && ((point >> (8 * pivot)) & 0xff) == 0 {
            pivot += 1;
        }
        debug_assert!(pivot < DIMENSION);
        let leading = ((point >> (8 * pivot)) & 0xff) as u8;
        let inverse = self.pack.index.field.inverse_nonzero(leading);
        let mut suffix = 0_u64;
        for input in pivot + 1..DIMENSION {
            let coordinate = ((point >> (8 * input)) & 0xff) as u8;
            suffix =
                (suffix << H) | u64::from(self.pack.index.field.mul_canonical(coordinate, inverse));
        }
        self.pack.index.offsets[pivot] + suffix
    }

    #[inline(always)]
    pub fn successors(&mut self, index: u64) -> Result<[u64; GENERATORS], ProjectiveError> {
        if index >= self.pack.index.point_count {
            return Err(ProjectiveError::PointOutOfRange);
        }
        let point = self.packed_point(index);
        let field = self.pack.index.field;
        let mut successors = [0_u64; GENERATORS];
        for (action, successor) in self.pack.actions.iter().zip(successors.iter_mut()) {
            let image = match action.unit_start {
                BINARY_LANE_UNIT_REVERSAL => point.swap_bytes() >> (8 * (8 - DIMENSION)),
                BINARY_LANE_SUBSET_ZETA => {
                    let mut image = point;
                    image ^= (image << 8) & 0xff00_ff00_ff00_ff00;
                    image ^= (image << 16) & 0xffff_0000_ffff_0000;
                    image ^ ((image << 32) & 0xffff_ffff_0000_0000)
                }
                _ => {
                    let mut image = 0_u64;
                    for term in
                        &self.pack.unit_terms[action.unit_start as usize..action.unit_end as usize]
                    {
                        let coordinate = (point >> term.input_shift) & 0xff;
                        image ^= coordinate * term.lane_mask;
                    }
                    for term in &self.pack.weighted_terms
                        [action.weighted_start as usize..action.weighted_end as usize]
                    {
                        let coordinate = ((point >> term.input_shift) & 0xff) as u8;
                        image ^= u64::from(field.mul_canonical(term.coefficient, coordinate))
                            << term.output_shift;
                    }
                    image
                }
            };
            *successor = self.packed_index(image);
        }
        Ok(successors)
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ProjectivePoint {
    pub coordinates: [u8; 3],
    _reserved: u8,
}

const _: () = assert!(std::mem::size_of::<ProjectivePoint>() == 4);
const _: () = assert!(std::mem::align_of::<ProjectivePoint>() == 1);

#[derive(Clone, Debug)]
pub(crate) struct TernaryExtensionField {
    order: u8,
    degree: usize,
    modulus: [u8; 4],
    add: Box<[u8]>,
    multiply: Box<[u8]>,
}

impl TernaryExtensionField {
    pub(crate) fn new(order: u8) -> Result<Self, ProjectiveError> {
        let (degree, modulus) = match order {
            9 => (2, [1, 0, 1, 0]),
            27 => (3, [1, 2, 0, 1]),
            _ => return Err(ProjectiveError::UnsupportedOrder),
        };
        let table_len = order as usize * order as usize;
        let mut field = Self {
            order,
            degree,
            modulus,
            add: vec![0; table_len].into_boxed_slice(),
            multiply: vec![0; table_len].into_boxed_slice(),
        };
        for left in 0..order {
            for right in 0..order {
                let index = left as usize * order as usize + right as usize;
                field.add[index] = field.add_slow(left, right);
                field.multiply[index] = field.multiply_slow(left, right);
            }
        }
        Ok(field)
    }

    fn coefficients(&self, mut value: u8) -> [u8; 3] {
        let mut result = [0; 3];
        for coefficient in &mut result[..self.degree] {
            *coefficient = value % 3;
            value /= 3;
        }
        result
    }

    fn encode(&self, coefficients: &[u8]) -> u8 {
        let mut value = 0u8;
        let mut place = 1u8;
        for &coefficient in &coefficients[..self.degree] {
            value += coefficient % 3 * place;
            place *= 3;
        }
        value
    }

    fn add_slow(&self, left: u8, right: u8) -> u8 {
        let left = self.coefficients(left);
        let right = self.coefficients(right);
        let mut sum = [0; 3];
        for coordinate in 0..self.degree {
            sum[coordinate] = (left[coordinate] + right[coordinate]) % 3;
        }
        self.encode(&sum)
    }

    fn multiply_slow(&self, left: u8, right: u8) -> u8 {
        let left = self.coefficients(left);
        let right = self.coefficients(right);
        let mut product = [0u8; 5];
        for (left_index, &left_value) in left.iter().enumerate().take(self.degree) {
            for (right_index, &right_value) in right.iter().enumerate().take(self.degree) {
                let index = left_index + right_index;
                product[index] = (product[index] + left_value * right_value) % 3;
            }
        }
        for power in (self.degree..=(2 * self.degree - 2)).rev() {
            let leading = product[power] % 3;
            if leading == 0 {
                continue;
            }
            let shift = power - self.degree;
            for index in 0..self.degree {
                product[shift + index] =
                    (product[shift + index] + 3 - leading * self.modulus[index] % 3) % 3;
            }
        }
        self.encode(&product)
    }

    #[inline]
    pub(crate) fn add(&self, left: u8, right: u8) -> u8 {
        self.add[left as usize * self.order as usize + right as usize]
    }

    #[inline]
    pub(crate) fn multiply(&self, left: u8, right: u8) -> u8 {
        self.multiply[left as usize * self.order as usize + right as usize]
    }

    #[inline]
    pub(crate) fn pow(&self, mut base: u8, mut exponent: u8) -> u8 {
        let mut result = 1;
        while exponent != 0 {
            if exponent & 1 != 0 {
                result = self.multiply(result, base);
            }
            base = self.multiply(base, base);
            exponent >>= 1;
        }
        result
    }

    #[inline]
    pub(crate) fn inverse(&self, value: u8) -> u8 {
        debug_assert_ne!(value, 0);
        self.pow(value, self.order - 2)
    }
}

#[derive(Clone, Debug)]
pub struct ProjectivePlane {
    order: u8,
    points: Box<[ProjectivePoint]>,
    incidence: Box<[u16]>,
}

impl ProjectivePlane {
    pub fn ternary(order: u8) -> Result<Self, ProjectiveError> {
        let field = TernaryExtensionField::new(order)?;
        let expected_points = order as usize * order as usize + order as usize + 1;
        let mut points = Vec::with_capacity(expected_points);
        for y in 0..order {
            for z in 0..order {
                points.push(ProjectivePoint {
                    coordinates: [1, y, z],
                    _reserved: 0,
                });
            }
        }
        for z in 0..order {
            points.push(ProjectivePoint {
                coordinates: [0, 1, z],
                _reserved: 0,
            });
        }
        points.push(ProjectivePoint {
            coordinates: [0, 0, 1],
            _reserved: 0,
        });
        let line_size = order as usize + 1;
        let mut incidence = Vec::with_capacity(expected_points * line_size);
        for line in &points {
            let start = incidence.len();
            for (point_index, point) in points.iter().enumerate() {
                let mut value = 0u8;
                for coordinate in 0..3 {
                    value = field.add(
                        value,
                        field.multiply(point.coordinates[coordinate], line.coordinates[coordinate]),
                    );
                }
                if value == 0 {
                    incidence.push(
                        u16::try_from(point_index)
                            .map_err(|_| ProjectiveError::InvalidIncidence)?,
                    );
                }
            }
            if incidence.len() - start != line_size {
                return Err(ProjectiveError::InvalidIncidence);
            }
        }
        Ok(Self {
            order,
            points: points.into_boxed_slice(),
            incidence: incidence.into_boxed_slice(),
        })
    }

    pub fn order(&self) -> u8 {
        self.order
    }

    pub fn points(&self) -> &[ProjectivePoint] {
        &self.points
    }

    pub fn incident(&self, index: usize) -> Option<&[u16]> {
        if index >= self.points.len() {
            return None;
        }
        let line_size = self.order as usize + 1;
        let start = index * line_size;
        Some(&self.incidence[start..start + line_size])
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn generic_projective_index_round_trips_and_quotients_scalars() {
        let field = SmallField::new(3, 2).unwrap();
        let indexer = ProjectiveIndex::new(&field, 2).unwrap();
        assert_eq!(indexer.point_count(), 9 * 9 + 9 + 1);
        let mut point = [0u8; 3];
        for index in 0..indexer.point_count() {
            indexer.point(index, &mut point).unwrap();
            assert_eq!(indexer.index(&point).unwrap(), index);
            for scalar in 1..field.order() as u8 {
                let scaled = point.map(|coordinate| field.mul(coordinate, scalar));
                assert_eq!(indexer.index(&scaled).unwrap(), index);
            }
        }
        assert_eq!(
            indexer.index(&[0, 0, 0]),
            Err(ProjectiveError::InvalidPoint)
        );
    }

    #[test]
    fn generic_projective_index_handles_higher_dimension() {
        let field = SmallField::new(2, 4).unwrap();
        let indexer = ProjectiveIndex::new(&field, 3).unwrap();
        assert_eq!(indexer.point_count(), 16u64.pow(3) + 16u64.pow(2) + 16 + 1);
        let last = indexer.point_owned(indexer.point_count() - 1).unwrap();
        assert_eq!(&*last, &[0, 0, 0, 1]);
    }

    #[test]
    fn generic_projective_index_accepts_the_largest_representable_binary_space() {
        let field = SmallField::new(2, 8).unwrap();
        let indexer = ProjectiveIndex::new(&field, 7).unwrap();
        assert_eq!(indexer.point_count(), u64::MAX / 255);
        let mut last = [0_u8; 8];
        indexer.point(indexer.point_count() - 1, &mut last).unwrap();
        assert_eq!(last, [0, 0, 0, 0, 0, 0, 0, 1]);
        assert_eq!(indexer.index(&last).unwrap(), indexer.point_count() - 1);
        assert!(matches!(
            ProjectiveIndex::new(&field, 8),
            Err(ProjectiveError::DimensionOverflow)
        ));
    }

    fn binary_index_agrees<const H: u8>(limit: u64) {
        let field = SmallField::new(2, H).unwrap();
        let generic = ProjectiveIndex::new(&field, 4).unwrap();
        let binary = BinaryProjectiveIndex::<H>::new(&field, 4).unwrap();
        let binary_field = field.binary_extension::<H>().unwrap();
        assert_eq!(generic.point_count(), binary.point_count());
        let mut generic_point = [0_u8; 5];
        let mut binary_point = [0_u8; 5];
        let mut typed_point = [binary_field.zero(); 5];
        for index in 0..generic.point_count().min(limit) {
            generic.point(index, &mut generic_point).unwrap();
            binary.point(index, &mut binary_point).unwrap();
            binary.point_elements(index, &mut typed_point).unwrap();
            assert_eq!(generic_point, binary_point);
            assert_eq!(binary.index(&binary_point).unwrap(), index);
            assert_eq!(binary.index_elements(&typed_point).unwrap(), index);
            for position in 0..typed_point.len() {
                assert_eq!(typed_point[position].value(), binary_point[position]);
            }
        }
    }

    #[test]
    fn binary_projective_index_matches_generic_rank_and_unrank() {
        binary_index_agrees::<3>(u64::MAX);
        binary_index_agrees::<4>(10_000);
        binary_index_agrees::<5>(10_000);
        binary_index_agrees::<6>(10_000);
        binary_index_agrees::<7>(10_000);
        binary_index_agrees::<8>(10_000);

        let field = SmallField::new(2, 6).unwrap();
        assert!(matches!(
            BinaryProjectiveIndex::<4>::new(&field, 4),
            Err(ProjectiveError::UnsupportedOrder)
        ));
        let binary = BinaryProjectiveIndex::<6>::new(&field, 4).unwrap();
        assert_eq!(
            binary.index(&[1, 0, 64, 0, 0]),
            Err(ProjectiveError::InvalidPoint)
        );
    }

    #[test]
    fn binary_projective_hot_rank_and_unrank_allocate_nothing() {
        let field = SmallField::new(2, 6).unwrap();
        let binary = BinaryProjectiveIndex::<6>::new(&field, 4).unwrap();
        let binary_field = field.binary_extension::<6>().unwrap();
        let mut point = [0_u8; 5];
        let mut typed_point = [binary_field.zero(); 5];
        let (checksum, events) = crate::test_alloc::measure_allocations(|| {
            let _guard = crate::test_alloc::HotLoopAllocationGuard::enter();
            let mut checksum = 0_u64;
            for index in 0..10_000 {
                binary.point(index, &mut point).unwrap();
                checksum ^= binary.index(&point).unwrap();
                binary.point_elements(index, &mut typed_point).unwrap();
                checksum ^= binary.index_elements(&typed_point).unwrap();
            }
            checksum
        });
        assert_eq!(checksum, 0);
        assert_eq!(events, crate::test_alloc::AllocationEvents::default());
    }

    fn three_projective_generator_bytes() -> Box<[u8]> {
        [
            // Identity.
            1, 0, 0, 0, 1, 0, 0, 0, 1, // Swap the first two coordinates.
            0, 1, 0, 1, 0, 0, 0, 0, 1, // Shear the first coordinate by the second.
            1, 1, 0, 0, 1, 0, 0, 0, 1,
        ]
        .into()
    }

    fn three_projective_generators(field: &SmallField) -> [Matrix; 3] {
        let bytes = three_projective_generator_bytes();
        std::array::from_fn(|generator| {
            Matrix::new_with_field(
                field,
                3,
                3,
                bytes[generator * 9..(generator + 1) * 9].to_vec(),
            )
            .unwrap()
        })
    }

    fn three_weighted_projective_generators(field: &SmallField) -> [Matrix; 3] {
        let bytes = [
            // Weighted diagonal.
            1, 0, 0, 0, 2, 0, 0, 0, 3, // Weighted upper shear.
            1, 2, 0, 0, 1, 0, 0, 0, 1, // Weighted reversal.
            0, 0, 2, 0, 3, 0, 4, 0, 0,
        ];
        std::array::from_fn(|generator| {
            Matrix::new_with_field(
                field,
                3,
                3,
                bytes[generator * 9..(generator + 1) * 9].to_vec(),
            )
            .unwrap()
        })
    }

    #[test]
    fn projective_action_pack_matches_independent_matrix_application() {
        let field = SmallField::new(2, 3).unwrap();
        let pack =
            ProjectiveLinearActionPack::<3>::new(&field, 2, three_projective_generators(&field))
                .unwrap();
        let index = ProjectiveIndex::new(&field, 2).unwrap();
        let matrices = three_projective_generator_bytes();
        let mut point = [0_u8; 3];
        let mut image = [0_u8; 3];
        let mut workspace = pack.workspace();
        let mut runner = pack.runner(&mut workspace).unwrap();
        for point_index in 0..pack.point_count() {
            index.point(point_index, &mut point).unwrap();
            let actual = runner.successors(point_index).unwrap();
            for generator in 0..3 {
                let matrix = &matrices[generator * 9..(generator + 1) * 9];
                for row in 0..3 {
                    image[row] = (0..3).fold(0_u8, |sum, column| {
                        field.add(sum, field.mul(matrix[row * 3 + column], point[column]))
                    });
                }
                assert_eq!(actual[generator], index.index(&image).unwrap());
            }
        }

        let malformed = Matrix::new_with_field(&field, 2, 2, vec![1, 0, 0, 1]).unwrap();
        assert!(matches!(
            ProjectiveLinearActionPack::<1>::new(&field, 2, [malformed]),
            Err(ProjectiveError::InvalidLinearAction)
        ));
        let singular = Matrix::new_with_field(&field, 3, 3, vec![0_u8; 9]).unwrap();
        assert!(matches!(
            ProjectiveLinearActionPack::<1>::new(&field, 2, [singular]),
            Err(ProjectiveError::InvalidLinearAction)
        ));
        let other_modulus = if field.modulus() == [1, 0, 1, 1] {
            [1, 1, 0, 1]
        } else {
            [1, 0, 1, 1]
        };
        let other = SmallField::from_modulus(2, &other_modulus).unwrap();
        let wrong_field = three_projective_generators(&other)
            .into_iter()
            .next()
            .unwrap();
        assert!(matches!(
            ProjectiveLinearActionPack::<1>::new(&field, 2, [wrong_field]),
            Err(ProjectiveError::InvalidLinearAction)
        ));
    }

    #[test]
    fn projective_action_runner_allocates_nothing() {
        let field = SmallField::new(2, 3).unwrap();
        let pack =
            ProjectiveLinearActionPack::<3>::new(&field, 2, three_projective_generators(&field))
                .unwrap();
        let mut workspace = pack.workspace();
        let mut runner = pack.runner(&mut workspace).unwrap();
        let (checksum, events) = crate::test_alloc::measure_allocations(|| {
            let _guard = crate::test_alloc::HotLoopAllocationGuard::enter();
            let mut checksum = 0_u64;
            for round in 0..10_000_u64 {
                let successors = runner.successors(round % pack.point_count()).unwrap();
                checksum ^= successors.into_iter().fold(0, u64::wrapping_add);
            }
            checksum
        });
        assert_ne!(checksum, 0);
        assert_eq!(events, crate::test_alloc::AllocationEvents::default());
    }

    #[test]
    fn binary_projective_action_pack_matches_generic_and_fails_closed() {
        let field = SmallField::new(2, 3).unwrap();
        let generic =
            ProjectiveLinearActionPack::<3>::new(&field, 2, three_projective_generators(&field))
                .unwrap();
        let binary = BinaryProjectiveLinearActionPack::<3, 3>::new(
            &field,
            2,
            three_projective_generators(&field),
        )
        .unwrap();
        assert_eq!(generic.point_count(), binary.point_count());
        let mut generic_workspace = generic.workspace();
        let mut binary_workspace = binary.workspace();
        let point_count = binary.point_count();
        let mut generic_runner = generic.runner(&mut generic_workspace).unwrap();
        let mut binary_runner = binary.runner(&mut binary_workspace).unwrap();
        for point in 0..generic.point_count() {
            assert_eq!(
                generic_runner.successors(point).unwrap(),
                binary_runner.successors(point).unwrap()
            );
        }
        assert_eq!(
            binary_runner.successors(point_count),
            Err(ProjectiveError::PointOutOfRange)
        );

        let wrong_degree = BinaryProjectiveLinearActionPack::<4, 3>::new(
            &field,
            2,
            three_projective_generators(&field),
        );
        assert!(matches!(
            wrong_degree,
            Err(ProjectiveError::UnsupportedOrder)
        ));
        let singular = Matrix::new_with_field(&field, 3, 3, vec![0_u8; 9]).unwrap();
        assert!(matches!(
            BinaryProjectiveLinearActionPack::<3, 1>::new(&field, 2, [singular]),
            Err(ProjectiveError::InvalidLinearAction)
        ));
    }

    #[test]
    fn binary_projective_action_runner_allocates_nothing() {
        let field = SmallField::new(2, 3).unwrap();
        let pack = BinaryProjectiveLinearActionPack::<3, 3>::new(
            &field,
            2,
            three_projective_generators(&field),
        )
        .unwrap();
        let mut workspace = pack.workspace();
        let mut runner = pack.runner(&mut workspace).unwrap();
        let (checksum, events) = crate::test_alloc::measure_allocations(|| {
            let _guard = crate::test_alloc::HotLoopAllocationGuard::enter();
            let mut checksum = 0_u64;
            for round in 0..10_000_u64 {
                let successors = runner.successors(round % pack.point_count()).unwrap();
                checksum ^= successors.into_iter().fold(0, u64::wrapping_add);
            }
            checksum
        });
        assert_ne!(checksum, 0);
        assert_eq!(events, crate::test_alloc::AllocationEvents::default());
    }

    #[test]
    fn sparse_binary_projective_action_matches_dense_binary_pack() {
        let field = SmallField::new(2, 3).unwrap();
        let dense = BinaryProjectiveLinearActionPack::<3, 3>::new(
            &field,
            2,
            three_projective_generators(&field),
        )
        .unwrap();
        let sparse = BinarySparseProjectiveLinearActionPack::<3, 3>::new(
            &field,
            2,
            three_projective_generators(&field),
        )
        .unwrap();
        let lane = BinaryLaneProjectiveLinearActionPack::<3, 3, 3>::new(
            &field,
            2,
            three_projective_generators(&field),
        )
        .unwrap();
        assert_eq!(dense.point_count(), sparse.point_count());
        assert_eq!(dense.point_count(), lane.point_count());
        let mut dense_workspace = dense.workspace();
        let mut sparse_workspace = sparse.workspace();
        let mut lane_workspace = lane.workspace();
        {
            let mut dense_runner = dense.runner(&mut dense_workspace).unwrap();
            let mut sparse_runner = sparse.runner(&mut sparse_workspace).unwrap();
            let mut lane_runner = lane.runner(&mut lane_workspace).unwrap();
            for point in 0..dense.point_count() {
                let dense_successors = dense_runner.successors(point).unwrap();
                assert_eq!(dense_successors, sparse_runner.successors(point).unwrap());
                assert_eq!(dense_successors, lane_runner.successors(point).unwrap());
            }
            assert_eq!(
                sparse_runner.successors(sparse.point_count()),
                Err(ProjectiveError::PointOutOfRange)
            );
            assert_eq!(
                lane_runner.successors(lane.point_count()),
                Err(ProjectiveError::PointOutOfRange)
            );
        }

        let singular =
            std::array::from_fn(|_| Matrix::new_with_field(&field, 3, 3, vec![0; 9]).unwrap());
        assert!(matches!(
            BinarySparseProjectiveLinearActionPack::<3, 3>::new(&field, 2, singular),
            Err(ProjectiveError::InvalidLinearAction)
        ));
        let singular =
            std::array::from_fn(|_| Matrix::new_with_field(&field, 3, 3, vec![0; 9]).unwrap());
        assert!(matches!(
            BinaryLaneProjectiveLinearActionPack::<3, 3, 3>::new(&field, 2, singular),
            Err(ProjectiveError::InvalidLinearAction)
        ));

        let smaller = BinarySparseProjectiveLinearActionPack::<3, 3>::new(
            &field,
            1,
            std::array::from_fn(|_| {
                Matrix::new_with_field(&field, 2, 2, vec![1, 0, 0, 1]).unwrap()
            }),
        )
        .unwrap();
        let mut wrong_workspace = smaller.workspace();
        assert!(matches!(
            sparse.runner(&mut wrong_workspace),
            Err(ProjectiveError::InvalidLinearAction)
        ));
        assert!(matches!(
            BinaryLaneProjectiveLinearActionPack::<3, 2, 3>::new(
                &field,
                1,
                three_projective_generators(&field)
            ),
            Err(ProjectiveError::InvalidLinearAction)
        ));
    }

    #[test]
    fn sparse_binary_projective_action_runner_allocates_nothing() {
        let field = SmallField::new(2, 3).unwrap();
        let pack = BinarySparseProjectiveLinearActionPack::<3, 3>::new(
            &field,
            2,
            three_projective_generators(&field),
        )
        .unwrap();
        let mut workspace = pack.workspace();
        let mut runner = pack.runner(&mut workspace).unwrap();
        let (checksum, events) = crate::test_alloc::measure_allocations(|| {
            let _guard = crate::test_alloc::HotLoopAllocationGuard::enter();
            let mut checksum = 0_u64;
            for round in 0..10_000_u64 {
                let successors = runner.successors(round % pack.point_count()).unwrap();
                checksum ^= successors.into_iter().fold(0, u64::wrapping_add);
            }
            checksum
        });
        assert_ne!(checksum, 0);
        assert_eq!(events, crate::test_alloc::AllocationEvents::default());

        let lane = BinaryLaneProjectiveLinearActionPack::<3, 3, 3>::new(
            &field,
            2,
            three_projective_generators(&field),
        )
        .unwrap();
        let mut workspace = lane.workspace();
        let mut runner = lane.runner(&mut workspace).unwrap();
        let (checksum, events) = crate::test_alloc::measure_allocations(|| {
            let _guard = crate::test_alloc::HotLoopAllocationGuard::enter();
            let mut checksum = 0_u64;
            for round in 0..10_000_u64 {
                let successors = runner.successors(round % lane.point_count()).unwrap();
                checksum ^= successors.into_iter().fold(0, u64::wrapping_add);
            }
            checksum
        });
        assert_ne!(checksum, 0);
        assert_eq!(events, crate::test_alloc::AllocationEvents::default());
    }

    #[test]
    fn lane_binary_projective_action_matches_weighted_sparse_pack() {
        let field = SmallField::new(2, 3).unwrap();
        let sparse = BinarySparseProjectiveLinearActionPack::<3, 3>::new(
            &field,
            2,
            three_weighted_projective_generators(&field),
        )
        .unwrap();
        let lane = BinaryLaneProjectiveLinearActionPack::<3, 3, 3>::new(
            &field,
            2,
            three_weighted_projective_generators(&field),
        )
        .unwrap();
        let mut sparse_workspace = sparse.workspace();
        let mut lane_workspace = lane.workspace();
        let mut sparse_runner = sparse.runner(&mut sparse_workspace).unwrap();
        let mut lane_runner = lane.runner(&mut lane_workspace).unwrap();
        for point in 0..sparse.point_count() {
            assert_eq!(
                sparse_runner.successors(point).unwrap(),
                lane_runner.successors(point).unwrap()
            );
        }
        assert!(matches!(
            BinaryLaneProjectiveLinearActionPack::<3, 9, 3>::new(
                &field,
                8,
                three_weighted_projective_generators(&field)
            ),
            Err(ProjectiveError::InvalidLinearAction)
        ));
    }

    #[test]
    fn lane_binary_unit_reversal_uses_exact_byte_permutation() {
        let field = SmallField::new(2, 3).unwrap();
        let reversal =
            Matrix::new_with_field(&field, 3, 3, vec![0, 0, 1, 0, 1, 0, 1, 0, 0]).unwrap();
        let generic = ProjectiveLinearActionPack::<1>::new(&field, 2, [reversal.clone()]).unwrap();
        let lane =
            BinaryLaneProjectiveLinearActionPack::<3, 3, 1>::new(&field, 2, [reversal]).unwrap();
        assert_eq!(lane.actions[0].unit_start, BINARY_LANE_UNIT_REVERSAL);

        let mut generic_workspace = generic.workspace();
        let mut generic_runner = generic.runner(&mut generic_workspace).unwrap();
        let mut lane_workspace = lane.workspace();
        let mut lane_runner = lane.runner(&mut lane_workspace).unwrap();
        let (checksum, events) = crate::test_alloc::measure_allocations(|| {
            let _guard = crate::test_alloc::HotLoopAllocationGuard::enter();
            let mut checksum = 0_u64;
            for point in 0..lane.point_count() {
                let expected = generic_runner.successors(point).unwrap();
                let actual = lane_runner.successors(point).unwrap();
                assert_eq!(actual, expected);
                checksum ^= actual[0].rotate_left((point & 63) as u32);
            }
            checksum
        });
        assert_ne!(checksum, 0);
        assert_eq!(events, crate::test_alloc::AllocationEvents::default());
    }

    #[test]
    fn lane_binary_pascal_action_uses_exact_subset_zeta_transform() {
        let field = SmallField::new(2, 3).unwrap();
        let pascal = Matrix::new_with_field(
            &field,
            5,
            5,
            vec![
                1, 0, 0, 0, 0, // 0
                1, 1, 0, 0, 0, // 1
                1, 0, 1, 0, 0, // 2
                1, 1, 1, 1, 0, // 3
                1, 0, 0, 0, 1, // 4
            ],
        )
        .unwrap();
        let generic = ProjectiveLinearActionPack::<1>::new(&field, 4, [pascal.clone()]).unwrap();
        let lane =
            BinaryLaneProjectiveLinearActionPack::<3, 5, 1>::new(&field, 4, [pascal]).unwrap();
        assert_eq!(lane.actions[0].unit_start, BINARY_LANE_SUBSET_ZETA);

        let mut generic_workspace = generic.workspace();
        let mut generic_runner = generic.runner(&mut generic_workspace).unwrap();
        let mut lane_workspace = lane.workspace();
        let mut lane_runner = lane.runner(&mut lane_workspace).unwrap();
        let (checksum, events) = crate::test_alloc::measure_allocations(|| {
            let _guard = crate::test_alloc::HotLoopAllocationGuard::enter();
            let mut checksum = 0_u64;
            for point in 0..lane.point_count() {
                let expected = generic_runner.successors(point).unwrap();
                let actual = lane_runner.successors(point).unwrap();
                assert_eq!(actual, expected);
                checksum ^= actual[0].rotate_left((point & 63) as u32);
            }
            checksum
        });
        assert_ne!(checksum, 0);
        assert_eq!(events, crate::test_alloc::AllocationEvents::default());
    }

    #[test]
    fn ternary_planes_have_exact_incidence_parameters() {
        for (order, expected_hash) in [
            (9, 11_772_883_917_756_675_483u64),
            (27, 2_893_137_983_085_941_033u64),
        ] {
            let plane = ProjectivePlane::ternary(order).unwrap();
            let point_count = order as usize * order as usize + order as usize + 1;
            assert_eq!(plane.points().len(), point_count);
            assert!((0..point_count)
                .all(|line| plane.incident(line).unwrap().len() == order as usize + 1));
            let first = plane.incident(0).unwrap();
            for line in 1..point_count {
                let second = plane.incident(line).unwrap();
                assert_eq!(
                    first
                        .iter()
                        .filter(|point| second.binary_search(point).is_ok())
                        .count(),
                    1
                );
            }
            let hash = plane
                .incidence
                .iter()
                .fold(14_695_981_039_346_656_037u64, |hash, &point| {
                    (hash ^ u64::from(point)).wrapping_mul(1_099_511_628_211)
                });
            assert_eq!(hash, expected_hash);
        }
    }

    #[test]
    fn unsupported_order_is_rejected() {
        assert_eq!(
            ProjectivePlane::ternary(3).unwrap_err(),
            ProjectiveError::UnsupportedOrder
        );
    }
}
