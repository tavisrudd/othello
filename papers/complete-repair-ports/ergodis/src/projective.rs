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
        let pivot = self.offsets[1..].partition_point(|&end| end <= index);
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
        let pivot = self.offsets[1..].partition_point(|&end| end <= index);
        output[pivot] = self.field.one();
        let mut suffix = index - self.offsets[pivot];
        let mask = (1_u64 << H) - 1;
        for coordinate in output[pivot + 1..].iter_mut().rev() {
            *coordinate = BinaryElement::from_canonical((suffix & mask) as u8);
            suffix >>= H;
        }
        Ok(())
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
