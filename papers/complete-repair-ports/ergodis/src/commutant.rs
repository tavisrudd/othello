//! Verified commutants and invariant splits for packed binary actions.
//!
//! Coordinate orbits do not expose every algebraic reduction of a linear
//! state space.  A map commuting with all verified action generators preserves
//! the action while a central idempotent in that commutant gives an exact
//! invariant direct sum.  This module compiles those objects over `GF(2)` and
//! replays their defining equations independently.

use crate::Matrix;
use thiserror::Error;

const MAX_PACKED_DIMENSION: usize = 63;
const MAX_COMMUTANT_EQUATION_BYTES: usize = 128 * 1024 * 1024;

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum BinaryCommutantError {
    #[error("packed binary actions require a dimension in 1..=63")]
    Dimension,
    #[error("binary linear-map rows do not match the declared dimension")]
    Shape,
    #[error("binary action generators have incompatible dimensions")]
    GeneratorShape,
    #[error("binary subspace action requires a nonzero binary row space of rank at most 63")]
    SubspaceShape,
    #[error("coordinate action is not a permutation of the ambient coordinates")]
    NotPermutation,
    #[error("coordinate action does not preserve the supplied binary row space")]
    NotInvariant,
    #[error("binary quotient action requires nested row spaces with quotient rank in 1..=63")]
    QuotientShape,
    #[error("binary extension-field certificates require a degree in 2..=16")]
    FieldDegree,
    #[error("commuting operator does not generate the claimed extension field")]
    NotExtensionField,
    #[error("binary commutant equation workspace exceeds the 128 MiB safety limit")]
    ResourceLimit,
    #[error("binary commutant certificate failed independent replay")]
    Certificate,
}

/// A packed row-major linear endomorphism over `GF(2)`.
///
/// Bit `j` of row `i` is the coefficient of input `j` in output `i`.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct PackedBinaryLinearMap {
    dimension: u8,
    rows: Box<[u64]>,
}

impl PackedBinaryLinearMap {
    pub fn new(
        dimension: usize,
        rows: impl Into<Box<[u64]>>,
    ) -> Result<Self, BinaryCommutantError> {
        if dimension == 0 || dimension > MAX_PACKED_DIMENSION {
            return Err(BinaryCommutantError::Dimension);
        }
        let rows = rows.into();
        let mask = (1_u64 << dimension) - 1;
        if rows.len() != dimension || rows.iter().any(|&row| row & !mask != 0) {
            return Err(BinaryCommutantError::Shape);
        }
        Ok(Self {
            dimension: dimension as u8,
            rows,
        })
    }

    pub fn identity(dimension: usize) -> Result<Self, BinaryCommutantError> {
        Self::new(
            dimension,
            (0..dimension)
                .map(|index| 1_u64 << index)
                .collect::<Vec<_>>(),
        )
    }

    #[inline]
    pub fn dimension(&self) -> usize {
        self.dimension as usize
    }

    #[inline]
    pub fn rows(&self) -> &[u64] {
        &self.rows
    }

    #[inline]
    pub fn apply(&self, vector: u64) -> Option<u64> {
        let dimension = self.dimension();
        if vector >= 1_u64 << dimension {
            return None;
        }
        let mut output = 0_u64;
        for (index, &row) in self.rows.iter().enumerate() {
            output |= u64::from((row & vector).count_ones() & 1) << index;
        }
        Some(output)
    }

    pub fn compose(&self, right: &Self) -> Result<Self, BinaryCommutantError> {
        if self.dimension != right.dimension {
            return Err(BinaryCommutantError::Shape);
        }
        let mut rows = Vec::with_capacity(self.dimension());
        for &left_row in &self.rows {
            let mut bits = left_row;
            let mut row = 0_u64;
            while bits != 0 {
                let index = bits.trailing_zeros() as usize;
                row ^= right.rows[index];
                bits &= bits - 1;
            }
            rows.push(row);
        }
        Self::new(self.dimension(), rows)
    }

    pub fn commutes_with(&self, other: &Self) -> bool {
        self.dimension == other.dimension
            && packed_commutes(&self.rows, &other.rows, self.dimension())
    }

    pub fn is_idempotent(&self) -> bool {
        packed_is_idempotent(&self.rows)
    }

    pub fn rank(&self) -> usize {
        packed_rank(self.rows.to_vec(), self.dimension())
    }
}

#[derive(Clone, Debug)]
pub struct PackedBinaryAction {
    dimension: u8,
    generators: Box<[PackedBinaryLinearMap]>,
}

impl PackedBinaryAction {
    pub fn new(
        dimension: usize,
        generators: impl Into<Box<[PackedBinaryLinearMap]>>,
    ) -> Result<Self, BinaryCommutantError> {
        if dimension == 0 || dimension > MAX_PACKED_DIMENSION {
            return Err(BinaryCommutantError::Dimension);
        }
        let generators = generators.into();
        if generators
            .iter()
            .any(|generator| generator.dimension() != dimension)
        {
            return Err(BinaryCommutantError::GeneratorShape);
        }
        Ok(Self {
            dimension: dimension as u8,
            generators,
        })
    }

    pub fn dimension(&self) -> usize {
        self.dimension as usize
    }

    pub fn generators(&self) -> &[PackedBinaryLinearMap] {
        &self.generators
    }
}

/// A basis of the full endomorphism algebra commuting with an action.
#[derive(Clone, Debug)]
pub struct BinaryCommutant {
    dimension: u8,
    basis: Box<[PackedBinaryLinearMap]>,
}

/// A certified scalar action of `GF(2^degree)` on the binary state space.
#[derive(Clone, Debug)]
pub struct BinaryExtensionField {
    generator: PackedBinaryLinearMap,
    degree: u8,
}

impl BinaryExtensionField {
    pub fn generator(&self) -> &PackedBinaryLinearMap {
        &self.generator
    }

    pub fn degree(&self) -> usize {
        self.degree as usize
    }

    pub fn scalar_dimension(&self) -> usize {
        self.generator.dimension() / self.degree()
    }
}

impl BinaryCommutant {
    pub fn dimension(&self) -> usize {
        self.dimension as usize
    }

    pub fn algebra_dimension(&self) -> usize {
        self.basis.len()
    }

    pub fn basis(&self) -> &[PackedBinaryLinearMap] {
        &self.basis
    }

    /// Search a bounded prefix of the commutant for a nontrivial central
    /// idempotent.  The bound controls cold compilation work; returning `None`
    /// makes no assertion that the representation is indecomposable.
    pub fn find_central_split(
        &self,
        maximum_combinations: u64,
    ) -> Result<Option<BinaryInvariantSplit>, BinaryCommutantError> {
        if self.basis.is_empty() || maximum_combinations == 0 {
            return Ok(None);
        }
        let basis_count = self.basis.len();
        let available = if basis_count >= 64 {
            u64::MAX
        } else {
            (1_u64 << basis_count) - 1
        };
        let limit = available.min(maximum_combinations);
        let dimension = self.dimension();
        let identity = PackedBinaryLinearMap::identity(dimension)?;
        let mut rows = vec![0_u64; dimension];
        let mut previous_gray = 0_u64;
        for index in 1..=limit {
            let gray = index ^ (index >> 1);
            let changed = gray ^ previous_gray;
            let basis_index = changed.trailing_zeros() as usize;
            if basis_index >= basis_count {
                break;
            }
            for (row, &basis_row) in rows.iter_mut().zip(self.basis[basis_index].rows()) {
                *row ^= basis_row;
            }
            previous_gray = gray;
            if rows.iter().all(|&row| row == 0)
                || rows == identity.rows.as_ref()
                || !packed_is_idempotent(&rows)
                || self
                    .basis
                    .iter()
                    .any(|basis| !packed_commutes(&rows, basis.rows(), dimension))
            {
                continue;
            }
            return Ok(Some(BinaryInvariantSplit::new(
                PackedBinaryLinearMap::new(dimension, rows.clone())?,
            )?));
        }
        Ok(None)
    }
}

/// A certified direct sum `im(P) + ker(P)` from an idempotent `P`.
#[derive(Clone, Debug)]
pub struct BinaryInvariantSplit {
    projection: PackedBinaryLinearMap,
    image: PackedBinarySubspace,
    kernel: PackedBinarySubspace,
}

impl BinaryInvariantSplit {
    fn new(projection: PackedBinaryLinearMap) -> Result<Self, BinaryCommutantError> {
        if !projection.is_idempotent() {
            return Err(BinaryCommutantError::Certificate);
        }
        let dimension = projection.dimension();
        let image_basis = independent_basis(
            (0..dimension).map(|coordinate| projection.apply(1_u64 << coordinate).unwrap()),
            dimension,
        );
        if image_basis.is_empty() || image_basis.len() == dimension {
            return Err(BinaryCommutantError::Certificate);
        }
        let kernel_basis = nullspace_packed(projection.rows(), dimension);
        if image_basis.len() + kernel_basis.len() != dimension {
            return Err(BinaryCommutantError::Certificate);
        }
        Ok(Self {
            projection,
            image: PackedBinarySubspace::new(dimension, image_basis)?,
            kernel: PackedBinarySubspace::new(dimension, kernel_basis)?,
        })
    }

    pub fn projection(&self) -> &PackedBinaryLinearMap {
        &self.projection
    }

    pub fn image_dimension(&self) -> usize {
        self.image.dimension()
    }

    pub fn kernel_dimension(&self) -> usize {
        self.kernel.dimension()
    }

    pub fn image_space(&self) -> &PackedBinarySubspace {
        &self.image
    }

    pub fn kernel_space(&self) -> &PackedBinarySubspace {
        &self.kernel
    }

    #[inline]
    pub fn project(&self, vector: u64) -> Option<(u64, u64)> {
        let image = self.projection.apply(vector)?;
        Some((image, vector ^ image))
    }

    #[inline]
    pub fn reconstruct(&self, image: u64, kernel: u64) -> Option<u64> {
        let vector = image ^ kernel;
        let projected_image = self.projection.apply(image)?;
        let projected_kernel = self.projection.apply(kernel)?;
        (projected_image == image && projected_kernel == 0).then_some(vector)
    }

    /// Project directly into compact coordinates of the two invariant blocks.
    #[inline]
    pub fn project_coordinates(&self, vector: u64) -> Option<(u64, u64)> {
        let (image, kernel) = self.project(vector)?;
        Some((
            self.image.coordinates(image)?,
            self.kernel.coordinates(kernel)?,
        ))
    }

    #[inline]
    pub fn reconstruct_coordinates(&self, image: u64, kernel: u64) -> Option<u64> {
        let image = self.image.expand(image)?;
        let kernel = self.kernel.expand(kernel)?;
        self.reconstruct(image, kernel)
    }
}

/// A packed basis with allocation-free coordinate conversion after compile.
#[derive(Clone, Debug)]
pub struct PackedBinarySubspace {
    ambient_dimension: u8,
    basis: Box<[u64]>,
    pivot_vectors: Box<[u64]>,
    pivot_coefficients: Box<[u64]>,
}

impl PackedBinarySubspace {
    fn new(ambient_dimension: usize, basis: Vec<u64>) -> Result<Self, BinaryCommutantError> {
        if ambient_dimension == 0
            || ambient_dimension > MAX_PACKED_DIMENSION
            || basis.len() > MAX_PACKED_DIMENSION
        {
            return Err(BinaryCommutantError::Dimension);
        }
        let mask = (1_u64 << ambient_dimension) - 1;
        if basis.iter().any(|&vector| vector & !mask != 0)
            || packed_rank(basis.clone(), ambient_dimension) != basis.len()
        {
            return Err(BinaryCommutantError::Certificate);
        }
        let mut pivot_vectors = vec![0_u64; ambient_dimension];
        let mut pivot_coefficients = vec![0_u64; ambient_dimension];
        for (basis_index, &basis_vector) in basis.iter().enumerate() {
            let mut vector = basis_vector;
            let mut coefficients = 1_u64 << basis_index;
            while vector != 0 {
                let pivot = vector.trailing_zeros() as usize;
                if pivot_vectors[pivot] == 0 {
                    pivot_vectors[pivot] = vector;
                    pivot_coefficients[pivot] = coefficients;
                    break;
                }
                vector ^= pivot_vectors[pivot];
                coefficients ^= pivot_coefficients[pivot];
            }
            if vector == 0 {
                return Err(BinaryCommutantError::Certificate);
            }
        }
        Ok(Self {
            ambient_dimension: ambient_dimension as u8,
            basis: basis.into_boxed_slice(),
            pivot_vectors: pivot_vectors.into_boxed_slice(),
            pivot_coefficients: pivot_coefficients.into_boxed_slice(),
        })
    }

    pub fn ambient_dimension(&self) -> usize {
        self.ambient_dimension as usize
    }

    pub fn dimension(&self) -> usize {
        self.basis.len()
    }

    pub fn basis(&self) -> &[u64] {
        &self.basis
    }

    /// Convert an ambient vector to basis coordinates with no allocation.
    #[inline]
    pub fn coordinates(&self, mut vector: u64) -> Option<u64> {
        if vector >= 1_u64 << self.ambient_dimension() {
            return None;
        }
        let mut coordinates = 0_u64;
        while vector != 0 {
            let pivot = vector.trailing_zeros() as usize;
            let reducer = self.pivot_vectors[pivot];
            if reducer == 0 {
                return None;
            }
            vector ^= reducer;
            coordinates ^= self.pivot_coefficients[pivot];
        }
        Some(coordinates)
    }

    /// Expand basis coordinates with no allocation.
    #[inline]
    pub fn expand(&self, mut coordinates: u64) -> Option<u64> {
        if self.dimension() < 64 && coordinates >= 1_u64 << self.dimension() {
            return None;
        }
        let mut vector = 0_u64;
        while coordinates != 0 {
            let index = coordinates.trailing_zeros() as usize;
            vector ^= self.basis[index];
            coordinates &= coordinates - 1;
        }
        Some(vector)
    }
}

pub fn binary_commutant_workspace_upper_bound(
    action: &PackedBinaryAction,
) -> Result<usize, BinaryCommutantError> {
    let variable_count = action
        .dimension()
        .checked_mul(action.dimension())
        .ok_or(BinaryCommutantError::ResourceLimit)?;
    let equation_count = action
        .generators
        .len()
        .checked_mul(variable_count)
        .ok_or(BinaryCommutantError::ResourceLimit)?;
    let bytes_per_equation = variable_count
        .div_ceil(64)
        .checked_mul(std::mem::size_of::<u64>())
        .and_then(|bytes| bytes.checked_add(std::mem::size_of::<Vec<u64>>()))
        .ok_or(BinaryCommutantError::ResourceLimit)?;
    equation_count
        .checked_mul(bytes_per_equation)
        .ok_or(BinaryCommutantError::ResourceLimit)
}

/// Compile the full solution space of `XG = GX` for every supplied generator.
pub fn compile_binary_commutant(
    action: &PackedBinaryAction,
) -> Result<BinaryCommutant, BinaryCommutantError> {
    if binary_commutant_workspace_upper_bound(action)? > MAX_COMMUTANT_EQUATION_BYTES {
        return Err(BinaryCommutantError::ResourceLimit);
    }
    let dimension = action.dimension();
    let variable_count = dimension * dimension;
    let mut equations = commutant_equations(action);
    let pivots = rref_binary(&mut equations, variable_count);
    let mut is_pivot = vec![false; variable_count];
    for &pivot in &pivots {
        is_pivot[pivot] = true;
    }
    let word_count = variable_count.div_ceil(64);
    let mut basis = Vec::with_capacity(variable_count - pivots.len());
    for (free, &pivoted) in is_pivot.iter().enumerate() {
        if pivoted {
            continue;
        }
        let mut vector = vec![0_u64; word_count];
        toggle(&mut vector, free);
        for (row, &pivot) in equations.iter().zip(&pivots) {
            if bit(row, free) {
                toggle(&mut vector, pivot);
            }
        }
        basis.push(
            PackedBinaryLinearMap::new(dimension, unpack_map_rows(&vector, dimension))
                .expect("commutant nullspace vectors have the compiled shape"),
        );
    }
    Ok(BinaryCommutant {
        dimension: dimension as u8,
        basis: basis.into_boxed_slice(),
    })
}

/// Certify that a commuting operator generates a copy of `GF(2^degree)`.
///
/// Closure is checked by reducing the next power into
/// `span(1, A, ..., A^(degree-1))`.  The field condition is checked directly:
/// every nonzero element of that span has full binary rank.  The bounded
/// degree makes this exhaustive certificate practical and prevents an
/// accidental product algebra from being labelled a field.
pub fn certify_binary_extension_field(
    action: &PackedBinaryAction,
    generator: PackedBinaryLinearMap,
    degree: usize,
) -> Result<BinaryExtensionField, BinaryCommutantError> {
    if !(2..=16).contains(&degree) {
        return Err(BinaryCommutantError::FieldDegree);
    }
    let dimension = action.dimension();
    if generator.dimension() != dimension
        || dimension % degree != 0
        || action
            .generators
            .iter()
            .any(|action_generator| !generator.commutes_with(action_generator))
    {
        return Err(BinaryCommutantError::NotExtensionField);
    }
    let identity = PackedBinaryLinearMap::identity(dimension)?;
    let mut powers = Vec::with_capacity(degree + 1);
    powers.push(identity);
    for _ in 0..degree {
        let next = powers
            .last()
            .expect("identity starts the power sequence")
            .compose(&generator)?;
        powers.push(next);
    }
    let variable_count = dimension * dimension;
    let mut flattened = powers[..degree]
        .iter()
        .map(|power| pack_map(power, variable_count))
        .collect::<Vec<_>>();
    if binary_rank(flattened.clone(), variable_count) != degree {
        return Err(BinaryCommutantError::NotExtensionField);
    }
    flattened.push(pack_map(&powers[degree], variable_count));
    if binary_rank(flattened, variable_count) != degree {
        return Err(BinaryCommutantError::NotExtensionField);
    }

    let mut combination = vec![0_u64; dimension];
    let mut rank_scratch = vec![0_u64; dimension];
    let mut previous_gray = 0_u64;
    for index in 1_u64..1_u64 << degree {
        let gray = index ^ (index >> 1);
        let changed = gray ^ previous_gray;
        let power = changed.trailing_zeros() as usize;
        for (row, &power_row) in combination.iter_mut().zip(powers[power].rows()) {
            *row ^= power_row;
        }
        previous_gray = gray;
        rank_scratch.copy_from_slice(&combination);
        if packed_rank_in_place(&mut rank_scratch, dimension) != dimension {
            return Err(BinaryCommutantError::NotExtensionField);
        }
    }
    Ok(BinaryExtensionField {
        generator,
        degree: degree as u8,
    })
}

pub fn verify_binary_extension_field(
    action: &PackedBinaryAction,
    field: &BinaryExtensionField,
) -> Result<(), BinaryCommutantError> {
    let replay = certify_binary_extension_field(action, field.generator.clone(), field.degree())?;
    if replay.generator != field.generator || replay.degree != field.degree {
        return Err(BinaryCommutantError::Certificate);
    }
    Ok(())
}

/// Induce packed coordinate actions on the canonical basis of a binary row
/// space.  Each permutation maps a source coordinate to its target coordinate.
pub fn compile_binary_subspace_action(
    subspace: &Matrix,
    coordinate_generators: &[Box<[u16]>],
) -> Result<PackedBinaryAction, BinaryCommutantError> {
    let (basis, pivot_columns) = canonical_binary_basis(subspace)?;
    let dimension = basis.rows();
    let mut generators = Vec::with_capacity(coordinate_generators.len());
    for permutation in coordinate_generators {
        validate_permutation(permutation, basis.cols())?;
        let mut action_rows = vec![0_u64; dimension];
        let mut transformed = vec![0_u8; basis.cols()];
        let mut reconstructed = vec![0_u8; basis.cols()];
        for source_basis in 0..dimension {
            transformed.fill(0);
            for (source, &target) in permutation.iter().enumerate() {
                transformed[usize::from(target)] = basis.row(source_basis)[source];
            }
            reconstructed.fill(0);
            for (target_basis, &pivot) in pivot_columns.iter().enumerate() {
                if transformed[pivot] == 0 {
                    continue;
                }
                action_rows[target_basis] |= 1_u64 << source_basis;
                for (entry, &basis_entry) in reconstructed.iter_mut().zip(basis.row(target_basis)) {
                    *entry ^= basis_entry;
                }
            }
            if reconstructed != transformed {
                return Err(BinaryCommutantError::NotInvariant);
            }
        }
        generators.push(PackedBinaryLinearMap::new(dimension, action_rows)?);
    }
    PackedBinaryAction::new(dimension, generators)
}

/// Induce coordinate actions on a binary quotient row space
/// `superspace / subspace`.
///
/// The reducer retains quotient labels while eliminating concrete ambient
/// rows. A generator may therefore move a chosen representative by an element
/// of `subspace`; only its exact quotient action is exposed.
pub fn compile_binary_quotient_action(
    subspace: &Matrix,
    superspace: &Matrix,
    coordinate_generators: &[Box<[u16]>],
) -> Result<PackedBinaryAction, BinaryCommutantError> {
    if subspace.cols() != superspace.cols() || subspace.cols() == 0 {
        return Err(BinaryCommutantError::QuotientShape);
    }
    let subspace_basis = canonical_binary_matrix(subspace)?;
    let superspace_basis = canonical_binary_matrix(superspace)?;
    if superspace_basis.rows() <= subspace_basis.rows() {
        return Err(BinaryCommutantError::QuotientShape);
    }
    let ambient_dimension = superspace_basis.cols();
    let word_count = ambient_dimension.div_ceil(64);
    let subspace_rows = (0..subspace_basis.rows())
        .map(|row| pack_binary_row(subspace_basis.row(row)))
        .collect::<Vec<_>>();
    let superspace_rows = (0..superspace_basis.rows())
        .map(|row| pack_binary_row(superspace_basis.row(row)))
        .collect::<Vec<_>>();

    let mut superspace_reducer = LabelledBinaryReducer::new(ambient_dimension);
    for row in &superspace_rows {
        if !superspace_reducer.insert(row.clone(), 0) {
            return Err(BinaryCommutantError::Certificate);
        }
    }
    for row in &subspace_rows {
        let mut candidate = row.clone();
        let mut label = 0;
        superspace_reducer.reduce(&mut candidate, &mut label);
        if candidate.iter().any(|&word| word != 0) {
            return Err(BinaryCommutantError::QuotientShape);
        }
    }

    let mut subspace_reducer = LabelledBinaryReducer::new(ambient_dimension);
    let mut quotient_reducer = LabelledBinaryReducer::new(ambient_dimension);
    for row in &subspace_rows {
        if !subspace_reducer.insert(row.clone(), 0) || !quotient_reducer.insert(row.clone(), 0) {
            return Err(BinaryCommutantError::Certificate);
        }
    }
    let mut quotient_sources = Vec::new();
    for row in &superspace_rows {
        if quotient_sources.len() == MAX_PACKED_DIMENSION {
            let mut reduced = row.clone();
            let mut label = 0;
            quotient_reducer.reduce(&mut reduced, &mut label);
            if reduced.iter().any(|&word| word != 0) {
                return Err(BinaryCommutantError::QuotientShape);
            }
            continue;
        }
        let quotient_label = 1_u64 << quotient_sources.len();
        if quotient_reducer.insert(row.clone(), quotient_label) {
            quotient_sources.push(row.clone());
        }
    }
    let quotient_dimension = quotient_sources.len();
    if quotient_dimension == 0
        || quotient_dimension > MAX_PACKED_DIMENSION
        || quotient_dimension != superspace_basis.rows() - subspace_basis.rows()
    {
        return Err(BinaryCommutantError::QuotientShape);
    }

    let mut generators = Vec::with_capacity(coordinate_generators.len());
    let mut transformed = vec![0_u64; word_count];
    for permutation in coordinate_generators {
        validate_permutation(permutation, ambient_dimension)?;
        for source in &subspace_rows {
            permute_packed(source, permutation, &mut transformed);
            let mut label = 0;
            subspace_reducer.reduce(&mut transformed, &mut label);
            if transformed.iter().any(|&word| word != 0) {
                return Err(BinaryCommutantError::NotInvariant);
            }
        }
        for source in &superspace_rows {
            permute_packed(source, permutation, &mut transformed);
            let mut label = 0;
            quotient_reducer.reduce(&mut transformed, &mut label);
            if transformed.iter().any(|&word| word != 0) {
                return Err(BinaryCommutantError::NotInvariant);
            }
        }

        let mut action_rows = vec![0_u64; quotient_dimension];
        for (source_basis, source) in quotient_sources.iter().enumerate() {
            permute_packed(source, permutation, &mut transformed);
            let mut target_label = 0;
            quotient_reducer.reduce(&mut transformed, &mut target_label);
            if transformed.iter().any(|&word| word != 0) {
                return Err(BinaryCommutantError::NotInvariant);
            }
            for (target_basis, action_row) in action_rows.iter_mut().enumerate() {
                if target_label & (1_u64 << target_basis) != 0 {
                    *action_row |= 1_u64 << source_basis;
                }
            }
        }
        generators.push(PackedBinaryLinearMap::new(quotient_dimension, action_rows)?);
    }
    PackedBinaryAction::new(quotient_dimension, generators)
}

/// Compile the coordinate action on CSS logical row classes.
///
/// Physical checks form `K`; adjoining the supplied logical rows forms `D`.
/// The observable module is the quotient `D/K`, so logical representatives
/// are allowed to mix with physical checks under a symmetry.
pub fn compile_binary_css_logical_action(
    physical_checks: &Matrix,
    logical_rows: &Matrix,
    coordinate_generators: &[Box<[u16]>],
) -> Result<PackedBinaryAction, BinaryCommutantError> {
    if physical_checks.cols() == 0 || physical_checks.cols() != logical_rows.cols() {
        return Err(BinaryCommutantError::QuotientShape);
    }
    if physical_checks.as_slice().iter().any(|&entry| entry > 1)
        || logical_rows.as_slice().iter().any(|&entry| entry > 1)
    {
        return Err(BinaryCommutantError::SubspaceShape);
    }
    let rows = physical_checks.rows() + logical_rows.rows();
    let columns = physical_checks.cols();
    let mut joined = Vec::with_capacity(rows.saturating_mul(columns));
    joined.extend_from_slice(physical_checks.as_slice());
    joined.extend_from_slice(logical_rows.as_slice());
    let superspace =
        Matrix::new::<2>(rows, columns, joined).map_err(|_| BinaryCommutantError::SubspaceShape)?;
    compile_binary_quotient_action(physical_checks, &superspace, coordinate_generators)
}

/// Replay an induced action from the original row space and permutations.
pub fn verify_binary_subspace_action(
    subspace: &Matrix,
    coordinate_generators: &[Box<[u16]>],
    action: &PackedBinaryAction,
) -> Result<(), BinaryCommutantError> {
    let replay = compile_binary_subspace_action(subspace, coordinate_generators)?;
    if replay.dimension != action.dimension || replay.generators != action.generators {
        return Err(BinaryCommutantError::Certificate);
    }
    Ok(())
}

pub fn verify_binary_quotient_action(
    subspace: &Matrix,
    superspace: &Matrix,
    coordinate_generators: &[Box<[u16]>],
    action: &PackedBinaryAction,
) -> Result<(), BinaryCommutantError> {
    let replay = compile_binary_quotient_action(subspace, superspace, coordinate_generators)?;
    if replay.dimension != action.dimension || replay.generators != action.generators {
        return Err(BinaryCommutantError::Certificate);
    }
    Ok(())
}

pub fn verify_binary_css_logical_action(
    physical_checks: &Matrix,
    logical_rows: &Matrix,
    coordinate_generators: &[Box<[u16]>],
    action: &PackedBinaryAction,
) -> Result<(), BinaryCommutantError> {
    let replay =
        compile_binary_css_logical_action(physical_checks, logical_rows, coordinate_generators)?;
    if replay.dimension != action.dimension || replay.generators != action.generators {
        return Err(BinaryCommutantError::Certificate);
    }
    Ok(())
}

/// Independently replay the defining equations and dimension count.
pub fn verify_binary_commutant(
    action: &PackedBinaryAction,
    commutant: &BinaryCommutant,
) -> Result<(), BinaryCommutantError> {
    if binary_commutant_workspace_upper_bound(action)? > MAX_COMMUTANT_EQUATION_BYTES {
        return Err(BinaryCommutantError::ResourceLimit);
    }
    if action.dimension() != commutant.dimension() {
        return Err(BinaryCommutantError::Certificate);
    }
    if commutant.basis.iter().any(|candidate| {
        action
            .generators
            .iter()
            .any(|generator| !candidate.commutes_with(generator))
    }) {
        return Err(BinaryCommutantError::Certificate);
    }
    let variable_count = action.dimension() * action.dimension();
    let constraint_rank = binary_rank(commutant_equations(action), variable_count);
    let basis_rows = commutant
        .basis
        .iter()
        .map(|candidate| pack_map(candidate, variable_count))
        .collect::<Vec<_>>();
    let basis_rank = binary_rank(basis_rows, variable_count);
    if basis_rank != commutant.algebra_dimension() || basis_rank + constraint_rank != variable_count
    {
        return Err(BinaryCommutantError::Certificate);
    }
    Ok(())
}

pub fn verify_binary_invariant_split(
    action: &PackedBinaryAction,
    commutant: &BinaryCommutant,
    split: &BinaryInvariantSplit,
) -> Result<(), BinaryCommutantError> {
    verify_binary_commutant(action, commutant)?;
    let projection = split.projection();
    if projection.dimension() != action.dimension()
        || !projection.is_idempotent()
        || projection.rank() != split.image_dimension()
        || split.image_dimension() + split.kernel_dimension() != action.dimension()
        || action
            .generators
            .iter()
            .any(|generator| !projection.commutes_with(generator))
        || commutant
            .basis
            .iter()
            .any(|basis| !projection.commutes_with(basis))
    {
        return Err(BinaryCommutantError::Certificate);
    }
    for coordinate in 0..action.dimension() {
        let vector = 1_u64 << coordinate;
        let compact = split
            .project_coordinates(vector)
            .ok_or(BinaryCommutantError::Certificate)?;
        if split.reconstruct_coordinates(compact.0, compact.1) != Some(vector) {
            return Err(BinaryCommutantError::Certificate);
        }
    }
    Ok(())
}

fn commutant_equations(action: &PackedBinaryAction) -> Vec<Vec<u64>> {
    let dimension = action.dimension();
    let variable_count = dimension * dimension;
    let word_count = variable_count.div_ceil(64);
    let mut equations = Vec::with_capacity(action.generators.len() * variable_count);
    for generator in &action.generators {
        for output in 0..dimension {
            for input in 0..dimension {
                let mut equation = vec![0_u64; word_count];
                for middle in 0..dimension {
                    if generator.rows[middle] & (1_u64 << input) != 0 {
                        toggle(&mut equation, output * dimension + middle);
                    }
                    if generator.rows[output] & (1_u64 << middle) != 0 {
                        toggle(&mut equation, middle * dimension + input);
                    }
                }
                if equation.iter().any(|&word| word != 0) {
                    equations.push(equation);
                }
            }
        }
    }
    equations
}

fn canonical_binary_basis(subspace: &Matrix) -> Result<(Matrix, Vec<usize>), BinaryCommutantError> {
    if subspace.cols() == 0 || subspace.as_slice().iter().any(|&entry| entry > 1) {
        return Err(BinaryCommutantError::SubspaceShape);
    }
    let basis = subspace
        .canonical_row_basis::<2>()
        .map_err(|_| BinaryCommutantError::SubspaceShape)?;
    if basis.rows() == 0 || basis.rows() > MAX_PACKED_DIMENSION {
        return Err(BinaryCommutantError::SubspaceShape);
    }
    let mut pivot_columns = Vec::with_capacity(basis.rows());
    for row in 0..basis.rows() {
        let pivot = basis
            .row(row)
            .iter()
            .position(|&entry| entry != 0)
            .ok_or(BinaryCommutantError::SubspaceShape)?;
        pivot_columns.push(pivot);
    }
    Ok((basis, pivot_columns))
}

fn canonical_binary_matrix(matrix: &Matrix) -> Result<Matrix, BinaryCommutantError> {
    if matrix.cols() == 0 || matrix.as_slice().iter().any(|&entry| entry > 1) {
        return Err(BinaryCommutantError::SubspaceShape);
    }
    matrix
        .canonical_row_basis::<2>()
        .map_err(|_| BinaryCommutantError::SubspaceShape)
}

fn validate_permutation(
    permutation: &[u16],
    coordinate_count: usize,
) -> Result<(), BinaryCommutantError> {
    if permutation.len() != coordinate_count {
        return Err(BinaryCommutantError::NotPermutation);
    }
    let mut seen = vec![false; coordinate_count];
    for &target in permutation {
        let target = usize::from(target);
        if target >= coordinate_count || std::mem::replace(&mut seen[target], true) {
            return Err(BinaryCommutantError::NotPermutation);
        }
    }
    Ok(())
}

struct LabelledBinaryReducer {
    pivot_rows: Vec<Option<Box<[u64]>>>,
    pivot_labels: Vec<u64>,
}

impl LabelledBinaryReducer {
    fn new(ambient_dimension: usize) -> Self {
        Self {
            pivot_rows: vec![None; ambient_dimension],
            pivot_labels: vec![0; ambient_dimension],
        }
    }

    fn insert(&mut self, mut row: Vec<u64>, mut label: u64) -> bool {
        self.reduce(&mut row, &mut label);
        let Some(pivot) = first_set_bit(&row) else {
            return false;
        };
        self.pivot_rows[pivot] = Some(row.into_boxed_slice());
        self.pivot_labels[pivot] = label;
        true
    }

    fn reduce(&self, row: &mut [u64], label: &mut u64) {
        while let Some(pivot) = first_set_bit(row) {
            let Some(reducer) = &self.pivot_rows[pivot] else {
                break;
            };
            for (entry, &reducer_entry) in row.iter_mut().zip(reducer.iter()) {
                *entry ^= reducer_entry;
            }
            *label ^= self.pivot_labels[pivot];
        }
    }
}

fn pack_binary_row(row: &[u8]) -> Vec<u64> {
    let mut packed = vec![0_u64; row.len().div_ceil(64)];
    for (coordinate, &entry) in row.iter().enumerate() {
        if entry != 0 {
            packed[coordinate / 64] |= 1_u64 << (coordinate % 64);
        }
    }
    packed
}

fn permute_packed(source: &[u64], permutation: &[u16], target: &mut [u64]) {
    target.fill(0);
    for (coordinate, &image) in permutation.iter().enumerate() {
        if source[coordinate / 64] & (1_u64 << (coordinate % 64)) != 0 {
            let image = usize::from(image);
            target[image / 64] |= 1_u64 << (image % 64);
        }
    }
}

fn first_set_bit(words: &[u64]) -> Option<usize> {
    words
        .iter()
        .enumerate()
        .find_map(|(index, &word)| (word != 0).then(|| 64 * index + word.trailing_zeros() as usize))
}

fn pack_map(map: &PackedBinaryLinearMap, variable_count: usize) -> Vec<u64> {
    let dimension = map.dimension();
    let mut packed = vec![0_u64; variable_count.div_ceil(64)];
    for (row, &entries) in map.rows.iter().enumerate() {
        let mut bits = entries;
        while bits != 0 {
            let column = bits.trailing_zeros() as usize;
            toggle(&mut packed, row * dimension + column);
            bits &= bits - 1;
        }
    }
    packed
}

fn unpack_map_rows(vector: &[u64], dimension: usize) -> Vec<u64> {
    let mut rows = vec![0_u64; dimension];
    for (row, entries) in rows.iter_mut().enumerate() {
        for column in 0..dimension {
            if bit(vector, row * dimension + column) {
                *entries |= 1_u64 << column;
            }
        }
    }
    rows
}

fn independent_basis(vectors: impl IntoIterator<Item = u64>, columns: usize) -> Vec<u64> {
    let mut pivots = vec![0_u64; columns];
    let mut basis = Vec::with_capacity(columns);
    for mut vector in vectors {
        let original = vector;
        while vector != 0 {
            let pivot = vector.trailing_zeros() as usize;
            if pivots[pivot] == 0 {
                pivots[pivot] = vector;
                basis.push(original);
                break;
            }
            vector ^= pivots[pivot];
        }
    }
    basis
}

fn nullspace_packed(rows: &[u64], columns: usize) -> Vec<u64> {
    let mut equations = rows.iter().map(|&row| vec![row]).collect::<Vec<_>>();
    let pivots = rref_binary(&mut equations, columns);
    let mut is_pivot = vec![false; columns];
    for &pivot in &pivots {
        is_pivot[pivot] = true;
    }
    let mut basis = Vec::with_capacity(columns - pivots.len());
    for (free, &pivoted) in is_pivot.iter().enumerate() {
        if pivoted {
            continue;
        }
        let mut vector = 1_u64 << free;
        for (row, &pivot) in equations.iter().zip(&pivots) {
            if bit(row, free) {
                vector |= 1_u64 << pivot;
            }
        }
        basis.push(vector);
    }
    basis
}

fn binary_rank(mut rows: Vec<Vec<u64>>, columns: usize) -> usize {
    rref_binary(&mut rows, columns).len()
}

fn rref_binary(rows: &mut [Vec<u64>], columns: usize) -> Vec<usize> {
    let mut pivot_row = 0usize;
    let mut pivots = Vec::with_capacity(rows.len().min(columns));
    for column in 0..columns {
        let Some(found) = (pivot_row..rows.len()).find(|&row| bit(&rows[row], column)) else {
            continue;
        };
        rows.swap(pivot_row, found);
        let pivot = rows[pivot_row].clone();
        for (row, entries) in rows.iter_mut().enumerate() {
            if row != pivot_row && bit(entries, column) {
                for (entry, &pivot_entry) in entries.iter_mut().zip(&pivot) {
                    *entry ^= pivot_entry;
                }
            }
        }
        pivots.push(column);
        pivot_row += 1;
        if pivot_row == rows.len() {
            break;
        }
    }
    pivots
}

fn packed_rank(mut rows: Vec<u64>, columns: usize) -> usize {
    packed_rank_in_place(&mut rows, columns)
}

fn packed_rank_in_place(rows: &mut [u64], columns: usize) -> usize {
    let mut rank = 0usize;
    for column in 0..columns {
        let Some(found) = (rank..rows.len()).find(|&row| rows[row] & (1_u64 << column) != 0) else {
            continue;
        };
        rows.swap(rank, found);
        for row in 0..rows.len() {
            if row != rank && rows[row] & (1_u64 << column) != 0 {
                rows[row] ^= rows[rank];
            }
        }
        rank += 1;
        if rank == rows.len() {
            break;
        }
    }
    rank
}

#[inline]
fn packed_composed_row(mut left_row: u64, right_rows: &[u64]) -> u64 {
    let mut row = 0_u64;
    while left_row != 0 {
        let index = left_row.trailing_zeros() as usize;
        row ^= right_rows[index];
        left_row &= left_row - 1;
    }
    row
}

#[inline]
fn packed_is_idempotent(rows: &[u64]) -> bool {
    rows.iter()
        .all(|&row| packed_composed_row(row, rows) == row)
}

#[inline]
fn packed_commutes(left: &[u64], right: &[u64], dimension: usize) -> bool {
    left.len() == dimension
        && right.len() == dimension
        && left.iter().zip(right).all(|(&left_row, &right_row)| {
            packed_composed_row(left_row, right) == packed_composed_row(right_row, left)
        })
}

#[inline]
fn bit(words: &[u64], index: usize) -> bool {
    words[index / 64] & (1_u64 << (index % 64)) != 0
}

#[inline]
fn toggle(words: &mut [u64], index: usize) {
    words[index / 64] ^= 1_u64 << (index % 64);
}

#[cfg(test)]
mod tests {
    use super::*;

    fn map(rows: &[u64]) -> PackedBinaryLinearMap {
        PackedBinaryLinearMap::new(rows.len(), rows.to_vec()).unwrap()
    }

    #[test]
    fn every_two_dimensional_single_generator_commutant_replays() {
        for packed in 0_u64..16 {
            let action = PackedBinaryAction::new(2, vec![map(&[packed & 3, packed >> 2])]).unwrap();
            let commutant = compile_binary_commutant(&action).unwrap();
            verify_binary_commutant(&action, &commutant).unwrap();
        }
    }

    #[test]
    fn central_idempotent_splits_nonisomorphic_blocks() {
        let generator = map(&[0b010, 0b011, 0b100]);
        let action = PackedBinaryAction::new(3, vec![generator.clone()]).unwrap();
        let commutant = compile_binary_commutant(&action).unwrap();
        verify_binary_commutant(&action, &commutant).unwrap();
        assert_eq!(commutant.algebra_dimension(), 3);

        let split = commutant
            .find_central_split(1 << commutant.algebra_dimension())
            .unwrap()
            .unwrap();
        verify_binary_invariant_split(&action, &commutant, &split).unwrap();
        assert_eq!(
            [split.image_dimension(), split.kernel_dimension()]
                .into_iter()
                .product::<usize>(),
            2
        );
        for vector in 0_u64..8 {
            let (image, kernel) = split.project(vector).unwrap();
            assert_eq!(split.reconstruct(image, kernel), Some(vector));
            let compact = split.project_coordinates(vector).unwrap();
            assert_eq!(
                split.reconstruct_coordinates(compact.0, compact.1),
                Some(vector)
            );
            assert_eq!(
                split.project(generator.apply(vector).unwrap()).unwrap(),
                (
                    generator.apply(image).unwrap(),
                    generator.apply(kernel).unwrap()
                )
            );
        }
    }

    #[test]
    fn trivial_action_is_one_isotypic_block() {
        let action =
            PackedBinaryAction::new(2, vec![PackedBinaryLinearMap::identity(2).unwrap()]).unwrap();
        let commutant = compile_binary_commutant(&action).unwrap();
        assert_eq!(commutant.algebra_dimension(), 4);
        verify_binary_commutant(&action, &commutant).unwrap();
        assert!(commutant.find_central_split(16).unwrap().is_none());
    }

    #[test]
    fn coordinate_cycle_induces_irreducible_even_parity_action() {
        let subspace = Matrix::new::<2>(2, 3, [1, 1, 0, 0, 1, 1]).unwrap();
        let permutations = vec![vec![1_u16, 2, 0].into_boxed_slice()];
        let action = compile_binary_subspace_action(&subspace, &permutations).unwrap();
        verify_binary_subspace_action(&subspace, &permutations, &action).unwrap();
        let generator = &action.generators()[0];
        assert_eq!(
            generator
                .compose(generator)
                .unwrap()
                .compose(generator)
                .unwrap(),
            PackedBinaryLinearMap::identity(2).unwrap()
        );
        let commutant = compile_binary_commutant(&action).unwrap();
        verify_binary_commutant(&action, &commutant).unwrap();
        assert_eq!(commutant.algebra_dimension(), 2);
        assert!(commutant.find_central_split(4).unwrap().is_none());
        let field = certify_binary_extension_field(&action, generator.clone(), 2).unwrap();
        assert_eq!(field.scalar_dimension(), 1);
        verify_binary_extension_field(&action, &field).unwrap();
    }

    #[test]
    fn replay_rejects_a_dependent_commutant_basis() {
        let action = PackedBinaryAction::new(2, vec![map(&[0b10, 0b11])]).unwrap();
        let mut commutant = compile_binary_commutant(&action).unwrap();
        assert!(commutant.basis.len() >= 2);
        commutant.basis[0] = commutant.basis[1].clone();
        assert_eq!(
            verify_binary_commutant(&action, &commutant).unwrap_err(),
            BinaryCommutantError::Certificate
        );
    }

    #[test]
    fn induced_action_rejects_noninvariant_subspace() {
        let subspace = Matrix::new::<2>(1, 3, [1, 1, 0]).unwrap();
        let permutations = vec![vec![1_u16, 2, 0].into_boxed_slice()];
        assert_eq!(
            compile_binary_subspace_action(&subspace, &permutations).unwrap_err(),
            BinaryCommutantError::NotInvariant
        );
    }

    #[test]
    fn identity_does_not_fake_an_extension_field() {
        let action =
            PackedBinaryAction::new(2, vec![PackedBinaryLinearMap::identity(2).unwrap()]).unwrap();
        assert_eq!(
            certify_binary_extension_field(
                &action,
                PackedBinaryLinearMap::identity(2).unwrap(),
                2,
            )
            .unwrap_err(),
            BinaryCommutantError::NotExtensionField
        );
    }

    #[test]
    fn quotient_action_retains_modulo_subspace_mixing() {
        let subspace = Matrix::new::<2>(1, 3, [1, 1, 1]).unwrap();
        let superspace = Matrix::new::<2>(3, 3, [1, 0, 0, 0, 1, 0, 0, 0, 1]).unwrap();
        let permutations = vec![vec![1_u16, 2, 0].into_boxed_slice()];
        let action = compile_binary_quotient_action(&subspace, &superspace, &permutations).unwrap();
        verify_binary_quotient_action(&subspace, &superspace, &permutations, &action).unwrap();
        assert_eq!(action.dimension(), 2);
        let generator = &action.generators()[0];
        assert_eq!(
            generator
                .compose(generator)
                .unwrap()
                .compose(generator)
                .unwrap(),
            PackedBinaryLinearMap::identity(2).unwrap()
        );
        let field = certify_binary_extension_field(&action, generator.clone(), 2).unwrap();
        verify_binary_extension_field(&action, &field).unwrap();
    }

    #[test]
    fn quotient_action_rejects_nonnested_and_noninvariant_inputs() {
        let left = Matrix::new::<2>(1, 3, [1, 0, 0]).unwrap();
        let right = Matrix::new::<2>(1, 3, [0, 1, 0]).unwrap();
        assert_eq!(
            compile_binary_quotient_action(&left, &right, &[]).unwrap_err(),
            BinaryCommutantError::QuotientShape
        );

        let full = Matrix::new::<2>(3, 3, [1, 0, 0, 0, 1, 0, 0, 0, 1]).unwrap();
        let swap = vec![vec![1_u16, 0, 2].into_boxed_slice()];
        assert_eq!(
            compile_binary_quotient_action(&left, &full, &swap).unwrap_err(),
            BinaryCommutantError::NotInvariant
        );
    }

    #[test]
    fn css_logical_action_is_computed_modulo_checks() {
        let physical = Matrix::new::<2>(1, 3, [1, 1, 1]).unwrap();
        let logical = Matrix::new::<2>(2, 3, [1, 0, 0, 0, 1, 0]).unwrap();
        let permutations = vec![vec![1_u16, 2, 0].into_boxed_slice()];
        let action = compile_binary_css_logical_action(&physical, &logical, &permutations).unwrap();
        verify_binary_css_logical_action(&physical, &logical, &permutations, &action).unwrap();
        assert_eq!(action.dimension(), 2);
        let generator = &action.generators()[0];
        let field = certify_binary_extension_field(&action, generator.clone(), 2).unwrap();
        assert_eq!(field.scalar_dimension(), 1);
    }

    #[test]
    fn commutant_workspace_is_rejected_before_large_allocation() {
        let identity = PackedBinaryLinearMap::identity(63).unwrap();
        let action = PackedBinaryAction::new(63, vec![identity; 100]).unwrap();
        assert!(binary_commutant_workspace_upper_bound(&action).unwrap() > 128 * 1024 * 1024);
        assert_eq!(
            compile_binary_commutant(&action).unwrap_err(),
            BinaryCommutantError::ResourceLimit
        );
    }
}
