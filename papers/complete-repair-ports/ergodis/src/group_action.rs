//! Exact orbit compilation for finite permutation actions.

use crate::observational::{FinitePresentation, GeneratorSpec, ObservationalError};
use thiserror::Error;

/// A finite set acted on by explicitly supplied permutation generators.
pub trait FinitePermutationAction {
    type Error;

    fn point_count(&self) -> u32;
    fn generator_count(&self) -> u32;
    fn apply(&self, generator: u32, point: u32) -> Result<u32, Self::Error>;
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum BinaryGlProbeError {
    #[error("binary GL probe dimensions must be positive and use fewer than 32 bits")]
    Shape,
    #[error("binary GL probe point or generator is out of range")]
    Index,
    #[error("binary GL probe orbit census overflows u64")]
    Overflow,
    #[error("binary GL RREF quotient failed independent replay")]
    Certificate,
}

#[derive(Debug, Error)]
pub enum BinaryGlPresentationError {
    #[error("binary right-linear context and GL quotient have incompatible shapes")]
    Shape,
    #[error(transparent)]
    Presentation(#[from] ObservationalError),
}

/// A right-linear map on the columns of a packed binary probe.
///
/// Each output column is encoded by the input-column mask whose parity forms
/// that output. Right-linear maps commute with every left row operation.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct BinaryRightLinearMap {
    columns: u8,
    forms: Box<[u32]>,
}

impl BinaryRightLinearMap {
    pub fn new(columns: usize, forms: impl Into<Box<[u32]>>) -> Result<Self, BinaryGlProbeError> {
        let forms = forms.into();
        if columns == 0
            || columns >= 32
            || forms.len() != columns
            || forms.iter().any(|&form| form >= 1_u32 << columns)
        {
            return Err(BinaryGlProbeError::Shape);
        }
        Ok(Self {
            columns: columns as u8,
            forms,
        })
    }

    pub fn apply(
        &self,
        action: &BinaryGlProbeAction,
        point: u32,
    ) -> Result<u32, BinaryGlProbeError> {
        if self.columns as usize != action.columns() || point >= action.point_count {
            return Err(BinaryGlProbeError::Index);
        }
        Ok(self.apply_unchecked(action.rows(), point))
    }

    #[inline]
    fn apply_unchecked(&self, rows: usize, point: u32) -> u32 {
        let columns = self.columns as usize;
        let row_mask = (1_u32 << columns) - 1;
        let mut result = 0_u32;
        for row in 0..rows {
            let source = point >> (row * columns) & row_mask;
            let mut target = 0_u32;
            for (column, &linear_form) in self.forms.iter().enumerate() {
                target |= ((source & linear_form).count_ones() & 1) << column;
            }
            result |= target << (row * columns);
        }
        result
    }
}

/// Left row action of `GL_rows(F_2)` on all `rows x columns` binary probes.
///
/// Points are packed row-major in `u32`. Adjacent swaps and both adjacent row
/// transvections generate the full general linear group; applying a generator
/// is branch-bounded arithmetic with no allocation.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct BinaryGlProbeAction {
    rows: u8,
    columns: u8,
    point_count: u32,
}

/// The theorem-specialized quotient for the left binary general-linear action.
///
/// A row space has one reduced-row-echelon basis, so its canonical packed
/// representative can be recomputed from a point without a lookup table. The
/// bitmap stores only which packed points are representatives; unlike a
/// generic orbit certificate, storage is one bit per concrete point.
#[derive(Clone, Debug)]
pub struct BinaryGlRrefQuotient {
    action: BinaryGlProbeAction,
    representative_bits: Box<[u64]>,
    rank_superblocks: Box<[u32]>,
    orbit_count: u32,
}

impl BinaryGlRrefQuotient {
    pub fn orbit_count(&self) -> u32 {
        self.orbit_count
    }

    pub fn storage_bytes(&self) -> usize {
        std::mem::size_of_val(&*self.representative_bits)
            + std::mem::size_of_val(&*self.rank_superblocks)
    }

    /// Return the canonical representative of the point's row space.
    #[inline]
    pub fn representative(&self, point: u32) -> Option<u32> {
        (point < self.action.point_count).then(|| self.action.rref_representative(point))
    }

    pub fn is_representative(&self, point: u32) -> bool {
        if point >= self.action.point_count {
            return false;
        }
        self.representative_bits[point as usize / 64] & (1_u64 << (point % 64)) != 0
    }

    pub fn representatives(&self) -> impl Iterator<Item = u32> + '_ {
        (0..self.action.point_count).filter(|&point| self.is_representative(point))
    }

    /// Return the dense canonical orbit ID, ordered by representative.
    #[inline]
    pub fn orbit(&self, point: u32) -> Option<u32> {
        let representative = self.representative(point)?;
        let word_index = representative as usize / 64;
        let block = word_index / 8;
        let mut rank = self.rank_superblocks[block];
        for &word in &self.representative_bits[block * 8..word_index] {
            rank += word.count_ones();
        }
        let bit_index = representative % 64;
        let below = if bit_index == 0 {
            0
        } else {
            self.representative_bits[word_index] & ((1_u64 << bit_index) - 1)
        };
        Some(rank + below.count_ones())
    }

    /// Select the representative with the given dense orbit ID.
    pub fn orbit_representative(&self, orbit: u32) -> Option<u32> {
        if orbit >= self.orbit_count {
            return None;
        }
        let upper = self
            .rank_superblocks
            .partition_point(|&prefix| prefix <= orbit);
        let block = upper.saturating_sub(1).min(
            self.representative_bits
                .len()
                .saturating_sub(1)
                .div_euclid(8),
        );
        let mut remaining = orbit - self.rank_superblocks[block];
        for (offset, &stored_word) in self.representative_bits[block * 8..]
            .iter()
            .take(8)
            .enumerate()
        {
            let population = stored_word.count_ones();
            if remaining >= population {
                remaining -= population;
                continue;
            }
            let mut word = stored_word;
            for _ in 0..remaining {
                word &= word - 1;
            }
            return Some(((block * 8 + offset) * 64 + word.trailing_zeros() as usize) as u32);
        }
        None
    }

    /// Compile a one-sort contextual presentation directly on row spaces.
    ///
    /// The callback observes canonical row-space representatives. Contexts are
    /// right-linear maps, so their compatibility with the left GL quotient is
    /// a theorem of matrix multiplication rather than a concrete-state scan.
    pub fn compile_right_linear_presentation(
        &self,
        contexts: &[BinaryRightLinearMap],
        mut observation: impl FnMut(u32) -> u32,
    ) -> Result<FinitePresentation, BinaryGlPresentationError> {
        if contexts
            .iter()
            .any(|context| context.columns as usize != self.action.columns())
        {
            return Err(BinaryGlPresentationError::Shape);
        }
        let orbit_count = self.orbit_count as usize;
        let mut representatives = Vec::with_capacity(orbit_count);
        let mut observations = Vec::with_capacity(orbit_count);
        for orbit in 0..self.orbit_count {
            let representative = self
                .orbit_representative(orbit)
                .ok_or(BinaryGlPresentationError::Shape)?;
            representatives.push(representative);
            observations.push(observation(representative));
        }
        let mut generators = Vec::with_capacity(contexts.len());
        for context in contexts {
            let mut transitions = Vec::with_capacity(orbit_count);
            for &representative in &representatives {
                let target = context.apply_unchecked(self.action.rows(), representative);
                transitions.push(self.orbit(target).ok_or(BinaryGlPresentationError::Shape)?);
            }
            generators.push(GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: transitions.into_boxed_slice(),
            });
        }
        Ok(FinitePresentation::new(
            [self.orbit_count],
            observations,
            generators,
        )?)
    }
}

impl BinaryGlProbeAction {
    pub fn new(rows: usize, columns: usize) -> Result<Self, BinaryGlProbeError> {
        let bits = rows.checked_mul(columns).ok_or(BinaryGlProbeError::Shape)?;
        if rows == 0 || columns == 0 || bits >= 32 || rows > u8::MAX as usize {
            return Err(BinaryGlProbeError::Shape);
        }
        Ok(Self {
            rows: rows as u8,
            columns: columns as u8,
            point_count: 1_u32 << bits,
        })
    }

    pub fn rows(&self) -> usize {
        self.rows as usize
    }

    pub fn columns(&self) -> usize {
        self.columns as usize
    }

    /// Burnside/row-space census: one orbit per subspace of rank at most rows.
    pub fn expected_orbit_count(&self) -> Result<u64, BinaryGlProbeError> {
        let maximum_rank = self.rows().min(self.columns());
        let mut total = 0_u64;
        for rank in 0..=maximum_rank {
            let mut numerator = 1_u128;
            let mut denominator = 1_u128;
            for index in 0..rank {
                numerator = numerator
                    .checked_mul(
                        (1_u128 << (self.columns() - index))
                            .checked_sub(1)
                            .ok_or(BinaryGlProbeError::Overflow)?,
                    )
                    .ok_or(BinaryGlProbeError::Overflow)?;
                denominator = denominator
                    .checked_mul(
                        (1_u128 << (rank - index))
                            .checked_sub(1)
                            .ok_or(BinaryGlProbeError::Overflow)?,
                    )
                    .ok_or(BinaryGlProbeError::Overflow)?;
            }
            total = total
                .checked_add(
                    u64::try_from(numerator / denominator)
                        .map_err(|_| BinaryGlProbeError::Overflow)?,
                )
                .ok_or(BinaryGlProbeError::Overflow)?;
        }
        Ok(total)
    }

    /// Canonicalize by the exact row-space theorem, with no allocation.
    ///
    /// The reduced basis is stored in descending packed-row order. This is a
    /// stable encoding choice; equality of representatives is exactly equality
    /// of row spaces.
    #[inline]
    fn rref_representative(&self, point: u32) -> u32 {
        let rows = self.rows();
        let columns = self.columns();
        let mask = (1_u32 << columns) - 1;
        let mut basis = [0_u32; 31];
        for (row, slot) in basis.iter_mut().enumerate().take(rows) {
            *slot = point >> (row * columns) & mask;
        }

        let mut rank = 0;
        for column in 0..columns {
            let bit = 1_u32 << column;
            let Some(pivot) = (rank..rows).find(|&row| basis[row] & bit != 0) else {
                continue;
            };
            basis.swap(rank, pivot);
            for row in 0..rows {
                if row != rank && basis[row] & bit != 0 {
                    basis[row] ^= basis[rank];
                }
            }
            rank += 1;
            if rank == rows {
                break;
            }
        }
        self.pack_basis(&mut basis, rank)
    }

    #[inline]
    fn pack_basis(&self, basis: &mut [u32; 31], rank: usize) -> u32 {
        basis[..rank].sort_unstable_by(|left, right| right.cmp(left));
        basis[rank..self.rows()].fill(0);
        basis[..self.rows()]
            .iter()
            .enumerate()
            .fold(0_u32, |packed, (row, &value)| {
                packed | (value << (row * self.columns()))
            })
    }
}

/// Compile the binary GL quotient by direct row-space canonicalization.
///
/// This is the preferred backend when the supplied action really is the left
/// row action. It enumerates the unique RREF basis of each row space directly,
/// performs no allocation in the enumeration loop, and stores one bit per raw
/// point instead of a generic spanning forest.
pub fn compile_binary_gl_rref(action: BinaryGlProbeAction) -> BinaryGlRrefQuotient {
    let mut representative_bits = vec![0_u64; (action.point_count as usize).div_ceil(64)];
    let mut orbit_count = 0_u32;
    let columns = action.columns();
    let maximum_rank = action.rows().min(columns);
    for pivots in 0_u32..1_u32 << columns {
        let rank = pivots.count_ones() as usize;
        if rank > maximum_rank {
            continue;
        }
        let mut pivot_columns = [0_u8; 31];
        let mut pivot_count = 0;
        for column in 0..columns {
            if pivots & (1_u32 << column) != 0 {
                pivot_columns[pivot_count] = column as u8;
                pivot_count += 1;
            }
        }
        let mut free_rows = [0_u8; 31];
        let mut free_columns = [0_u8; 31];
        let mut free_count = 0;
        for column in 0..columns {
            if pivots & (1_u32 << column) != 0 {
                continue;
            }
            for (row, &pivot) in pivot_columns.iter().enumerate().take(rank) {
                if usize::from(pivot) < column {
                    free_rows[free_count] = row as u8;
                    free_columns[free_count] = column as u8;
                    free_count += 1;
                }
            }
        }
        for assignment in 0_u32..1_u32 << free_count {
            let mut basis = [0_u32; 31];
            for row in 0..rank {
                basis[row] = 1_u32 << pivot_columns[row];
            }
            for free in 0..free_count {
                if assignment & (1_u32 << free) != 0 {
                    basis[free_rows[free] as usize] |= 1_u32 << free_columns[free];
                }
            }
            let representative = action.pack_basis(&mut basis, rank);
            let word = &mut representative_bits[representative as usize / 64];
            let bit = 1_u64 << (representative % 64);
            debug_assert_eq!(*word & bit, 0);
            *word |= bit;
            orbit_count += 1;
        }
    }
    let block_count = representative_bits.len().div_ceil(8);
    let mut rank_superblocks = Vec::with_capacity(block_count + 1);
    let mut rank = 0_u32;
    for block in representative_bits.chunks(8) {
        rank_superblocks.push(rank);
        rank += block.iter().map(|word| word.count_ones()).sum::<u32>();
    }
    rank_superblocks.push(rank);
    debug_assert_eq!(rank, orbit_count);
    BinaryGlRrefQuotient {
        action,
        representative_bits: representative_bits.into_boxed_slice(),
        rank_superblocks: rank_superblocks.into_boxed_slice(),
        orbit_count,
    }
}

/// Replay the row-space quotient independently against the supplied action.
pub fn verify_binary_gl_rref(quotient: &BinaryGlRrefQuotient) -> Result<(), BinaryGlProbeError> {
    let action = quotient.action;
    let expected =
        u32::try_from(action.expected_orbit_count()?).map_err(|_| BinaryGlProbeError::Overflow)?;
    if quotient.orbit_count != expected {
        return Err(BinaryGlProbeError::Certificate);
    }
    let mut counted = 0_u32;
    for point in 0..action.point_count {
        let representative = action.rref_representative(point);
        if action.rref_representative(representative) != representative
            || !quotient.is_representative(representative)
        {
            return Err(BinaryGlProbeError::Certificate);
        }
        if quotient.is_representative(point) {
            if representative != point {
                return Err(BinaryGlProbeError::Certificate);
            }
            counted += 1;
        }
        for generator in 0..action.generator_count() {
            let target = action.apply(generator, point)?;
            if action.rref_representative(target) != representative {
                return Err(BinaryGlProbeError::Certificate);
            }
        }
    }
    if counted != quotient.orbit_count {
        return Err(BinaryGlProbeError::Certificate);
    }
    Ok(())
}

impl FinitePermutationAction for BinaryGlProbeAction {
    type Error = BinaryGlProbeError;

    fn point_count(&self) -> u32 {
        self.point_count
    }

    fn generator_count(&self) -> u32 {
        3 * u32::from(self.rows.saturating_sub(1))
    }

    #[inline(always)]
    fn apply(&self, generator: u32, point: u32) -> Result<u32, Self::Error> {
        if point >= self.point_count || generator >= self.generator_count() {
            return Err(BinaryGlProbeError::Index);
        }
        let adjacent = u32::from(self.rows - 1);
        let edge = (generator % adjacent) as usize;
        let columns = self.columns();
        let mask = (1_u32 << columns) - 1;
        let left_shift = edge * columns;
        let right_shift = (edge + 1) * columns;
        let left = point >> left_shift & mask;
        let right = point >> right_shift & mask;
        let result = if generator < adjacent {
            let cleared = point & !(mask << left_shift) & !(mask << right_shift);
            cleared | (right << left_shift) | (left << right_shift)
        } else if generator < 2 * adjacent {
            point ^ (right << left_shift)
        } else {
            point ^ (left << right_shift)
        };
        Ok(result)
    }
}

#[derive(Debug, Error, PartialEq, Eq)]
pub enum OrbitCompileError<E> {
    #[error("permutation-action adapter failed: {0}")]
    Adapter(E),
    #[error("generator {generator} maps point {point} out of range to {target}")]
    Target {
        generator: u32,
        point: u32,
        target: u32,
    },
    #[error("generator {generator} is not a permutation: target {target} is repeated")]
    NotPermutation { generator: u32, target: u32 },
    #[error("orbit certificate has an invalid shape or index")]
    CertificateShape,
    #[error("orbit certificate edge for point {point} does not replay")]
    CertificateEdge { point: u32 },
    #[error("generator {generator} does not preserve the certified orbit of point {point}")]
    NotClosed { generator: u32, point: u32 },
    #[error("orbit {orbit} does not use its least point as representative")]
    NotCanonical { orbit: u32 },
}

#[derive(Debug, Error, PartialEq, Eq)]
pub enum OrbitQuotientError {
    #[error("orbit partition and finite presentation have different point counts")]
    PointCount,
    #[error("orbit {orbit} crosses a presentation sort boundary")]
    Sort { orbit: u32 },
    #[error("observation is not constant on orbit {orbit}")]
    Observation { orbit: u32 },
    #[error("context {context} is not well-defined on orbit {orbit}")]
    Context { context: u32, orbit: u32 },
    #[error("orbit partition contains an invalid orbit index")]
    OrbitIndex,
    #[error(transparent)]
    Presentation(#[from] ObservationalError),
}

/// Compact replayable orbit partition.
#[derive(Clone, Debug)]
pub struct OrbitPartition {
    point_orbits: Box<[u32]>,
    representatives: Box<[u32]>,
    predecessor_points: Box<[u32]>,
    predecessor_generators: Box<[u32]>,
    discovery_ranks: Box<[u32]>,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct OrbitStorage {
    pub quotient_bytes: usize,
    pub certificate_bytes: usize,
}

impl OrbitPartition {
    pub fn point_orbits(&self) -> &[u32] {
        &self.point_orbits
    }

    pub fn representatives(&self) -> &[u32] {
        &self.representatives
    }

    pub fn orbit(&self, point: u32) -> Option<u32> {
        self.point_orbits.get(point as usize).copied()
    }

    pub fn representative(&self, point: u32) -> Option<u32> {
        self.orbit(point)
            .and_then(|orbit| self.representatives.get(orbit as usize).copied())
    }

    pub fn storage(&self) -> OrbitStorage {
        OrbitStorage {
            quotient_bytes: std::mem::size_of_val(&*self.point_orbits)
                + std::mem::size_of_val(&*self.representatives),
            certificate_bytes: std::mem::size_of_val(&*self.predecessor_points)
                + std::mem::size_of_val(&*self.predecessor_generators)
                + std::mem::size_of_val(&*self.discovery_ranks),
        }
    }
}

trait OrbitPartitionView {
    fn point_count(&self) -> usize;
    fn orbit_count(&self) -> usize;
    fn orbit_at(&self, point: u32) -> Option<u32>;
    fn representative_at(&self, orbit: u32) -> Option<u32>;
}

impl OrbitPartitionView for OrbitPartition {
    fn point_count(&self) -> usize {
        self.point_orbits.len()
    }

    fn orbit_count(&self) -> usize {
        self.representatives.len()
    }

    fn orbit_at(&self, point: u32) -> Option<u32> {
        self.orbit(point)
    }

    fn representative_at(&self, orbit: u32) -> Option<u32> {
        self.representatives.get(orbit as usize).copied()
    }
}

impl OrbitPartitionView for BinaryGlRrefQuotient {
    fn point_count(&self) -> usize {
        self.action.point_count as usize
    }

    fn orbit_count(&self) -> usize {
        self.orbit_count as usize
    }

    fn orbit_at(&self, point: u32) -> Option<u32> {
        self.orbit(point)
    }

    fn representative_at(&self, orbit: u32) -> Option<u32> {
        self.orbit_representative(orbit)
    }
}

/// Quotient a finite interface by a sort-preserving, observation-invariant,
/// context-equivariant orbit partition.
///
/// All obligations are checked on concrete states. The returned presentation
/// retains every original context but stores one transition per source orbit.
pub fn quotient_presentation_by_orbits(
    presentation: &FinitePresentation,
    partition: &OrbitPartition,
) -> Result<FinitePresentation, OrbitQuotientError> {
    quotient_presentation_by_partition(presentation, partition)
}

/// Quotient a finite presentation through the compressed binary row-space
/// partition without materializing a point-to-orbit array.
pub fn quotient_presentation_by_binary_gl_rref(
    presentation: &FinitePresentation,
    partition: &BinaryGlRrefQuotient,
) -> Result<FinitePresentation, OrbitQuotientError> {
    quotient_presentation_by_partition(presentation, partition)
}

fn quotient_presentation_by_partition<P: OrbitPartitionView>(
    presentation: &FinitePresentation,
    partition: &P,
) -> Result<FinitePresentation, OrbitQuotientError> {
    let point_count = presentation.observations().len();
    if partition.point_count() != point_count {
        return Err(OrbitQuotientError::PointCount);
    }
    let orbit_count = partition.orbit_count();
    let mut orbit_sorts = vec![u32::MAX; orbit_count];
    let mut sort_orbit_counts = vec![0_usize; presentation.sorts().len()];
    for (sort, range) in presentation.sorts().iter().copied().enumerate() {
        for state in range.start..range.start + range.len {
            let orbit = partition
                .orbit_at(state)
                .ok_or(OrbitQuotientError::OrbitIndex)?;
            let Some(orbit_sort) = orbit_sorts.get_mut(orbit as usize) else {
                return Err(OrbitQuotientError::OrbitIndex);
            };
            if *orbit_sort == u32::MAX {
                *orbit_sort = sort as u32;
                sort_orbit_counts[sort] += 1;
            } else if *orbit_sort != sort as u32 {
                return Err(OrbitQuotientError::Sort { orbit });
            }
            let representative = partition
                .representative_at(orbit)
                .ok_or(OrbitQuotientError::OrbitIndex)?;
            if representative as usize >= point_count {
                return Err(OrbitQuotientError::OrbitIndex);
            }
            if presentation.observations()[state as usize]
                != presentation.observations()[representative as usize]
            {
                return Err(OrbitQuotientError::Observation { orbit });
            }
        }
    }
    if orbit_sorts.contains(&u32::MAX) {
        return Err(OrbitQuotientError::OrbitIndex);
    }
    let mut sort_orbits: Vec<_> = sort_orbit_counts
        .into_iter()
        .map(Vec::with_capacity)
        .collect();
    for (orbit, &sort) in orbit_sorts.iter().enumerate() {
        sort_orbits[sort as usize].push(orbit as u32);
    }

    let mut orbit_states = vec![u32::MAX; orbit_count];
    let mut observations = Vec::with_capacity(orbit_count);
    let mut next_state = 0_u32;
    for orbits in &sort_orbits {
        for &orbit in orbits {
            orbit_states[orbit as usize] = next_state;
            next_state += 1;
            let representative = partition
                .representative_at(orbit)
                .ok_or(OrbitQuotientError::OrbitIndex)?;
            observations.push(presentation.observations()[representative as usize]);
        }
    }

    let mut generators = Vec::with_capacity(presentation.generators().len());
    let mut targets_by_orbit = vec![u32::MAX; orbit_count];
    for (context, generator) in presentation.generators().iter().enumerate() {
        targets_by_orbit.fill(u32::MAX);
        let source = presentation.sorts()[generator.source_sort as usize];
        for state in source.start..source.start + source.len {
            let source_orbit = partition
                .orbit_at(state)
                .ok_or(OrbitQuotientError::OrbitIndex)?;
            let target_state = presentation.transition(context as u32, state).ok_or(
                OrbitQuotientError::Context {
                    context: context as u32,
                    orbit: source_orbit,
                },
            )?;
            let target_orbit = partition
                .orbit_at(target_state)
                .ok_or(OrbitQuotientError::OrbitIndex)?;
            let expected = &mut targets_by_orbit[source_orbit as usize];
            if *expected == u32::MAX {
                *expected = target_orbit;
            } else if *expected != target_orbit {
                return Err(OrbitQuotientError::Context {
                    context: context as u32,
                    orbit: source_orbit,
                });
            }
        }
        let source_orbits = &sort_orbits[generator.source_sort as usize];
        let mut transitions = Vec::with_capacity(source_orbits.len());
        for &orbit in source_orbits {
            let target_orbit = targets_by_orbit[orbit as usize];
            let target_state = orbit_states
                .get(target_orbit as usize)
                .copied()
                .filter(|&state| state != u32::MAX)
                .ok_or(OrbitQuotientError::OrbitIndex)?;
            transitions.push(target_state);
        }
        generators.push(GeneratorSpec {
            source_sort: generator.source_sort,
            target_sort: generator.target_sort,
            transitions: transitions.into_boxed_slice(),
        });
    }

    FinitePresentation::new(
        sort_orbits.iter().map(|orbits| orbits.len() as u32),
        observations,
        generators,
    )
    .map_err(Into::into)
}

/// Compile canonical orbits and a spanning-word certificate.
///
/// The algorithm is iterative and allocates five point-sized arrays plus one
/// point-sized queue, independent of the number of group elements.
pub fn compile_permutation_orbits<A: FinitePermutationAction>(
    action: &A,
) -> Result<OrbitPartition, OrbitCompileError<A::Error>> {
    compile_permutation_orbits_internal(action, true)
}

/// Compile after validating generators, but defer certificate replay.
///
/// Use this when the artifact will cross a later trust or persistence boundary
/// where [`verify_permutation_orbits`] is already mandatory.
pub fn compile_permutation_orbits_with_deferred_verification<A: FinitePermutationAction>(
    action: &A,
) -> Result<OrbitPartition, OrbitCompileError<A::Error>> {
    compile_permutation_orbits_internal(action, false)
}

fn compile_permutation_orbits_internal<A: FinitePermutationAction>(
    action: &A,
    verify_immediately: bool,
) -> Result<OrbitPartition, OrbitCompileError<A::Error>> {
    validate_generators(action)?;
    let point_count = action.point_count();
    let point_capacity = point_count as usize;
    let unseen = u32::MAX;
    let mut point_orbits = vec![unseen; point_capacity];
    let mut predecessor_points = vec![unseen; point_capacity];
    let mut predecessor_generators = vec![unseen; point_capacity];
    let mut discovery_ranks = vec![unseen; point_capacity];
    let mut representatives = Vec::with_capacity(point_capacity);
    let mut queue = Vec::with_capacity(point_capacity);

    for representative in 0..point_count {
        if point_orbits[representative as usize] != unseen {
            continue;
        }
        let orbit = representatives.len() as u32;
        representatives.push(representative);
        queue.clear();
        queue.push(representative);
        point_orbits[representative as usize] = orbit;
        predecessor_points[representative as usize] = representative;
        discovery_ranks[representative as usize] = 0;

        let mut head = 0;
        while head < queue.len() {
            let point = queue[head];
            head += 1;
            for generator in 0..action.generator_count() {
                let target = action
                    .apply(generator, point)
                    .map_err(OrbitCompileError::Adapter)?;
                if target >= point_count {
                    return Err(OrbitCompileError::Target {
                        generator,
                        point,
                        target,
                    });
                }
                if point_orbits[target as usize] != unseen {
                    continue;
                }
                point_orbits[target as usize] = orbit;
                predecessor_points[target as usize] = point;
                predecessor_generators[target as usize] = generator;
                discovery_ranks[target as usize] = queue.len() as u32;
                queue.push(target);
            }
        }
    }

    let partition = OrbitPartition {
        point_orbits: point_orbits.into_boxed_slice(),
        representatives: representatives.into_boxed_slice(),
        predecessor_points: predecessor_points.into_boxed_slice(),
        predecessor_generators: predecessor_generators.into_boxed_slice(),
        discovery_ranks: discovery_ranks.into_boxed_slice(),
    };
    if verify_immediately {
        verify_permutation_orbits(action, &partition)?;
    }
    Ok(partition)
}

/// Independently replay an orbit partition and its reachability certificate.
pub fn verify_permutation_orbits<A: FinitePermutationAction>(
    action: &A,
    partition: &OrbitPartition,
) -> Result<(), OrbitCompileError<A::Error>> {
    validate_generators(action)?;
    let point_count = action.point_count() as usize;
    if partition.point_orbits.len() != point_count
        || partition.predecessor_points.len() != point_count
        || partition.predecessor_generators.len() != point_count
        || partition.discovery_ranks.len() != point_count
    {
        return Err(OrbitCompileError::CertificateShape);
    }
    let mut minima = vec![u32::MAX; partition.representatives.len()];
    for point in 0..action.point_count() {
        let orbit = partition.point_orbits[point as usize];
        let Some(minimum) = minima.get_mut(orbit as usize) else {
            return Err(OrbitCompileError::CertificateShape);
        };
        *minimum = (*minimum).min(point);
        let representative = partition.representatives[orbit as usize];
        let predecessor = partition.predecessor_points[point as usize];
        let rank = partition.discovery_ranks[point as usize];
        if point == representative {
            if predecessor != point || rank != 0 {
                return Err(OrbitCompileError::CertificateEdge { point });
            }
        } else {
            let generator = partition.predecessor_generators[point as usize];
            if predecessor >= action.point_count()
                || generator >= action.generator_count()
                || partition.point_orbits[predecessor as usize] != orbit
                || partition.discovery_ranks[predecessor as usize] >= rank
                || action
                    .apply(generator, predecessor)
                    .map_err(OrbitCompileError::Adapter)?
                    != point
            {
                return Err(OrbitCompileError::CertificateEdge { point });
            }
        }
        for generator in 0..action.generator_count() {
            let target = action
                .apply(generator, point)
                .map_err(OrbitCompileError::Adapter)?;
            if target >= action.point_count() {
                return Err(OrbitCompileError::Target {
                    generator,
                    point,
                    target,
                });
            }
            if partition.point_orbits[target as usize] != orbit {
                return Err(OrbitCompileError::NotClosed { generator, point });
            }
        }
    }
    for (orbit, (&representative, &minimum)) in partition
        .representatives
        .iter()
        .zip(minima.iter())
        .enumerate()
    {
        if representative != minimum {
            return Err(OrbitCompileError::NotCanonical {
                orbit: orbit as u32,
            });
        }
    }
    Ok(())
}

fn validate_generators<A: FinitePermutationAction>(
    action: &A,
) -> Result<(), OrbitCompileError<A::Error>> {
    let point_count = action.point_count();
    let words = (point_count as usize).div_ceil(64);
    let mut seen = vec![0_u64; words];
    for generator in 0..action.generator_count() {
        seen.fill(0);
        for point in 0..point_count {
            let target = action
                .apply(generator, point)
                .map_err(OrbitCompileError::Adapter)?;
            if target >= point_count {
                return Err(OrbitCompileError::Target {
                    generator,
                    point,
                    target,
                });
            }
            let word = &mut seen[target as usize / 64];
            let bit = 1_u64 << (target % 64);
            if *word & bit != 0 {
                return Err(OrbitCompileError::NotPermutation { generator, target });
            }
            *word |= bit;
        }
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn binary_gl_probe_orbits_are_exact_row_spaces() {
        let action = BinaryGlProbeAction::new(2, 3).unwrap();
        let partition = compile_permutation_orbits(&action).unwrap();
        let rref = compile_binary_gl_rref(action);
        assert_eq!(action.point_count(), 64);
        assert_eq!(action.generator_count(), 3);
        assert_eq!(action.expected_orbit_count().unwrap(), 15);
        assert_eq!(partition.representatives().len(), 15);
        assert_eq!(rref.orbit_count(), 15);
        assert_eq!(rref.storage_bytes(), 16);
        assert_eq!(rref.representatives().count(), 15);
        let selected = rref.representatives().collect::<Vec<_>>();
        for orbit in 0..rref.orbit_count() {
            assert_eq!(
                rref.orbit_representative(orbit),
                selected.get(orbit as usize).copied()
            );
        }
        for point in 0..action.point_count() {
            assert_eq!(
                rref.representative(point),
                Some(action.rref_representative(point))
            );
        }
        verify_binary_gl_rref(&rref).unwrap();
        verify_permutation_orbits(&action, &partition).unwrap();

        let observations = (0..action.point_count())
            .map(|point| rref.orbit(point).unwrap())
            .collect::<Vec<_>>();
        let generators = (0..action.generator_count())
            .map(|generator| GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: (0..action.point_count())
                    .map(|point| action.apply(generator, point).unwrap())
                    .collect(),
            })
            .collect::<Vec<_>>();
        let presentation =
            FinitePresentation::new([action.point_count()], observations, generators).unwrap();
        let generic = quotient_presentation_by_orbits(&presentation, &partition).unwrap();
        let compressed = quotient_presentation_by_binary_gl_rref(&presentation, &rref).unwrap();
        assert_eq!(generic.sorts(), compressed.sorts());
        let compressed_to_generic = (0..rref.orbit_count())
            .map(|orbit| {
                partition
                    .orbit(rref.orbit_representative(orbit).unwrap())
                    .unwrap()
            })
            .collect::<Vec<_>>();
        for (compressed_state, &generic_state) in compressed_to_generic.iter().enumerate() {
            assert_eq!(
                compressed.observations()[compressed_state],
                generic.observations()[generic_state as usize]
            );
        }
        for context in 0..action.generator_count() {
            for (compressed_state, &generic_state) in compressed_to_generic.iter().enumerate() {
                let compressed_target = compressed
                    .transition(context, compressed_state as u32)
                    .unwrap();
                let generic_target = generic.transition(context, generic_state).unwrap();
                assert_eq!(
                    compressed_to_generic[compressed_target as usize],
                    generic_target
                );
            }
        }
    }

    #[test]
    fn direct_rref_matches_generic_gl_orbits_across_small_shapes() {
        for (rows, columns) in [(1, 4), (2, 4), (3, 4)] {
            let action = BinaryGlProbeAction::new(rows, columns).unwrap();
            let generic = compile_permutation_orbits_with_deferred_verification(&action).unwrap();
            let direct = compile_binary_gl_rref(action);
            assert_eq!(
                direct.orbit_count() as usize,
                generic.representatives().len()
            );
            assert_eq!(
                u64::from(direct.orbit_count()),
                action.expected_orbit_count().unwrap()
            );
            let mut generic_to_direct = vec![u32::MAX; generic.representatives().len()];
            for point in 0..action.point_count() {
                let generic_orbit = generic.orbit(point).unwrap() as usize;
                let direct_orbit = direct.orbit(point).unwrap();
                let expected = &mut generic_to_direct[generic_orbit];
                if *expected == u32::MAX {
                    *expected = direct_orbit;
                } else {
                    assert_eq!(*expected, direct_orbit);
                }
            }
            generic_to_direct.sort_unstable();
            assert_eq!(
                generic_to_direct,
                (0..direct.orbit_count()).collect::<Vec<_>>()
            );
            verify_binary_gl_rref(&direct).unwrap();
        }
    }

    #[test]
    fn right_linear_contexts_compile_directly_on_row_spaces() {
        let action = BinaryGlProbeAction::new(2, 3).unwrap();
        let quotient = compile_binary_gl_rref(action);
        let contexts = [
            BinaryRightLinearMap::new(3, [2, 4, 1]).unwrap(),
            BinaryRightLinearMap::new(3, [3, 2, 0]).unwrap(),
        ];
        let observations = (0..action.point_count())
            .map(|point| quotient.representative(point).unwrap())
            .collect::<Vec<_>>();
        let generators = contexts.iter().map(|context| GeneratorSpec {
            source_sort: 0,
            target_sort: 0,
            transitions: (0..action.point_count())
                .map(|point| context.apply(&action, point).unwrap())
                .collect(),
        });
        let concrete =
            FinitePresentation::new([action.point_count()], observations, generators).unwrap();
        let checked = quotient_presentation_by_binary_gl_rref(&concrete, &quotient).unwrap();
        let direct = quotient
            .compile_right_linear_presentation(&contexts, |representative| representative)
            .unwrap();
        assert_eq!(checked.observations(), direct.observations());
        for context in 0..contexts.len() as u32 {
            for state in 0..quotient.orbit_count() {
                assert_eq!(
                    checked.transition(context, state),
                    direct.transition(context, state)
                );
            }
        }
    }
    use crate::observational::{compile_observational, GeneratorSpec};
    use std::convert::Infallible;

    struct TableAction<const N: usize, const G: usize>([[u32; N]; G]);

    impl<const N: usize, const G: usize> FinitePermutationAction for TableAction<N, G> {
        type Error = Infallible;

        fn point_count(&self) -> u32 {
            N as u32
        }

        fn generator_count(&self) -> u32 {
            G as u32
        }

        fn apply(&self, generator: u32, point: u32) -> Result<u32, Self::Error> {
            Ok(self.0[generator as usize][point as usize])
        }
    }

    #[test]
    fn generators_compile_canonical_orbits_and_replay_certificate() {
        let action = TableAction([[1, 2, 3, 0, 5, 4], [0, 3, 2, 1, 4, 5]]);
        let partition = compile_permutation_orbits(&action).unwrap();
        assert_eq!(partition.representatives(), &[0, 4]);
        assert_eq!(partition.point_orbits(), &[0, 0, 0, 0, 1, 1]);
        assert_eq!(partition.representative(3), Some(0));
        assert_eq!(partition.representative(5), Some(4));
        assert_eq!(
            partition.storage(),
            OrbitStorage {
                quotient_bytes: 32,
                certificate_bytes: 72
            }
        );
        verify_permutation_orbits(&action, &partition).unwrap();

        let deferred = compile_permutation_orbits_with_deferred_verification(&action).unwrap();
        assert_eq!(deferred.point_orbits(), partition.point_orbits());
        assert_eq!(deferred.representatives(), partition.representatives());
        verify_permutation_orbits(&action, &deferred).unwrap();
    }

    #[test]
    fn non_permutations_are_rejected_before_orbit_search() {
        let action = TableAction([[0, 0, 2]]);
        assert_eq!(
            compile_permutation_orbits(&action).unwrap_err(),
            OrbitCompileError::NotPermutation {
                generator: 0,
                target: 0
            }
        );
    }

    #[test]
    fn verifier_rejects_corrupted_reachability_and_closure() {
        let action = TableAction([[1, 2, 3, 0]]);
        let mut edge = compile_permutation_orbits(&action).unwrap();
        edge.predecessor_points[2] = 2;
        assert_eq!(
            verify_permutation_orbits(&action, &edge),
            Err(OrbitCompileError::CertificateEdge { point: 2 })
        );

        let mut closure = compile_permutation_orbits(&action).unwrap();
        closure.point_orbits[3] = 1;
        closure.representatives = vec![0, 3].into_boxed_slice();
        assert!(matches!(
            verify_permutation_orbits(&action, &closure),
            Err(OrbitCompileError::NotClosed { .. })
                | Err(OrbitCompileError::CertificateEdge { .. })
        ));
    }

    #[test]
    fn invariant_presentation_quotients_to_one_state_per_orbit() {
        let action = TableAction([[1, 2, 3, 0, 5, 4], [0, 3, 2, 1, 4, 5]]);
        let partition = compile_permutation_orbits(&action).unwrap();
        let generators = action.0.map(|transitions| GeneratorSpec {
            source_sort: 0,
            target_sort: 0,
            transitions: transitions.into(),
        });
        let presentation = FinitePresentation::new([6], [7, 7, 7, 7, 9, 9], generators).unwrap();
        let quotient = quotient_presentation_by_orbits(&presentation, &partition).unwrap();

        assert_eq!(quotient.sorts()[0].len, 2);
        assert_eq!(quotient.observations(), &[7, 9]);
        for context in 0..2 {
            assert_eq!(quotient.transition(context, 0), Some(0));
            assert_eq!(quotient.transition(context, 1), Some(1));
        }
        let direct = compile_observational(&presentation).unwrap();
        let reduced = compile_observational(&quotient).unwrap();
        for left in 0..6 {
            for right in 0..6 {
                let direct_equal = direct.state_classes()[left] == direct.state_classes()[right];
                let left_orbit = partition.point_orbits()[left] as usize;
                let right_orbit = partition.point_orbits()[right] as usize;
                let reduced_equal =
                    reduced.state_classes()[left_orbit] == reduced.state_classes()[right_orbit];
                assert_eq!(direct_equal, reduced_equal);
            }
        }
    }

    #[test]
    fn quotient_rejects_noninvariant_observations() {
        let action = TableAction([[1, 0]]);
        let partition = compile_permutation_orbits(&action).unwrap();
        let presentation = FinitePresentation::new([2], [0, 1], []).unwrap();
        assert!(matches!(
            quotient_presentation_by_orbits(&presentation, &partition),
            Err(OrbitQuotientError::Observation { orbit: 0 })
        ));
    }

    #[test]
    fn quotient_rejects_contexts_that_do_not_descend_to_orbits() {
        let action = TableAction([[1, 0, 2]]);
        let partition = compile_permutation_orbits(&action).unwrap();
        let presentation = FinitePresentation::new(
            [3],
            [0, 0, 0],
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: [0, 2, 2].into(),
            }],
        )
        .unwrap();
        assert!(matches!(
            quotient_presentation_by_orbits(&presentation, &partition),
            Err(OrbitQuotientError::Context {
                context: 0,
                orbit: 0
            })
        ));
    }

    #[test]
    fn quotient_rejects_orbits_crossing_typed_sorts() {
        let action = TableAction([[1, 0]]);
        let partition = compile_permutation_orbits(&action).unwrap();
        let presentation = FinitePresentation::new([1, 1], [0, 0], []).unwrap();
        assert!(matches!(
            quotient_presentation_by_orbits(&presentation, &partition),
            Err(OrbitQuotientError::Sort { orbit: 0 })
        ));
    }

    fn next_permutation(values: &mut [u32]) -> bool {
        let Some(pivot) = (0..values.len().saturating_sub(1))
            .rev()
            .find(|&index| values[index] < values[index + 1])
        else {
            return false;
        };
        let successor = (pivot + 1..values.len())
            .rev()
            .find(|&index| values[pivot] < values[index])
            .unwrap();
        values.swap(pivot, successor);
        values[pivot + 1..].reverse();
        true
    }

    #[test]
    fn all_pairs_of_four_point_permutations_match_transitive_closure() {
        let mut permutations = Vec::with_capacity(24);
        let mut permutation = [0, 1, 2, 3];
        loop {
            permutations.push(permutation);
            if !next_permutation(&mut permutation) {
                break;
            }
        }
        assert_eq!(permutations.len(), 24);

        for &first in &permutations {
            for &second in &permutations {
                let action = TableAction([first, second]);
                let partition = compile_permutation_orbits(&action).unwrap();
                let mut reachable = [[false; 4]; 4];
                for point in 0..4 {
                    reachable[point][point] = true;
                    reachable[point][first[point] as usize] = true;
                    reachable[point][second[point] as usize] = true;
                }
                for middle in 0..4 {
                    for left in 0..4 {
                        for right in 0..4 {
                            reachable[left][right] |=
                                reachable[left][middle] && reachable[middle][right];
                        }
                    }
                }
                for (point, row) in reachable.iter().enumerate() {
                    let expected = (0..4).find(|&candidate| row[candidate]).unwrap() as u32;
                    assert_eq!(partition.representative(point as u32), Some(expected));
                }
            }
        }
    }
}
