use crate::field::{BinarySmallField, SmallField};
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
            suffix = (suffix << H) | u64::from(self.field.mul(coordinate, inverse));
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
        assert_eq!(generic.point_count(), binary.point_count());
        let mut generic_point = [0_u8; 5];
        let mut binary_point = [0_u8; 5];
        for index in 0..generic.point_count().min(limit) {
            generic.point(index, &mut generic_point).unwrap();
            binary.point(index, &mut binary_point).unwrap();
            assert_eq!(generic_point, binary_point);
            assert_eq!(binary.index(&binary_point).unwrap(), index);
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
        let mut point = [0_u8; 5];
        let (checksum, events) = crate::test_alloc::measure_allocations(|| {
            let _guard = crate::test_alloc::HotLoopAllocationGuard::enter();
            let mut checksum = 0_u64;
            for index in 0..10_000 {
                binary.point(index, &mut point).unwrap();
                checksum ^= binary.index(&point).unwrap();
            }
            checksum
        });
        assert_eq!(checksum, 0);
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
