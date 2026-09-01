use crate::arena::{FlatMatrixArena, MatrixId};
use crate::field::{FieldElement, Prime};
use crate::matrix::{canonicalize_rows_in_place, Matrix, MatrixError};
use crate::witness::{WitnessArena, WitnessId};
use rustc_hash::{FxHashMap, FxHasher};
use std::hash::Hasher;
use thiserror::Error;

const NO_CHAIN_ENTRY: u32 = u32::MAX;

#[derive(Debug, Default)]
struct CollisionIndex {
    heads: FxHashMap<u64, u32>,
    next: Vec<u32>,
}

impl CollisionIndex {
    fn lookup(&self, hash: u64, mut equal: impl FnMut(u32) -> bool) -> Option<u32> {
        let mut current = self.heads.get(&hash).copied().unwrap_or(NO_CHAIN_ENTRY);
        while current != NO_CHAIN_ENTRY {
            if equal(current) {
                return Some(current);
            }
            current = self.next[current as usize];
        }
        None
    }

    fn insert(&mut self, hash: u64, id: u32) {
        assert_eq!(id as usize, self.next.len(), "collision IDs must be dense");
        let previous = self.heads.insert(hash, id).unwrap_or(NO_CHAIN_ENTRY);
        self.next.push(previous);
    }
}

fn byte_hash(bytes: &[u8]) -> u64 {
    let mut hasher = FxHasher::default();
    hasher.write(bytes);
    hasher.finish()
}

#[derive(Debug, Error)]
pub enum SpanError {
    #[error(transparent)]
    Matrix(#[from] MatrixError),
    #[error("the generator has too many coordinates for u32 witness IDs")]
    CoordinateOverflow,
    #[error("canonical target image uses field order {actual}, expected {expected}")]
    ImageField { expected: u8, actual: u8 },
    #[error("generated-span compilation exhausted its {0:?} limit")]
    ResourceLimit(SpanResource),
    #[error("generated-span compilation limits must all be positive")]
    InvalidLimits,
}

#[repr(u8)]
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum SpanResource {
    ProjectiveColumns,
    States,
    BasisBytes,
    Transitions,
}

const _: () = assert!(std::mem::size_of::<SpanResource>() == 1);
const _: () = assert!(std::mem::align_of::<SpanResource>() == 1);

#[repr(C)]
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct SpanBuildLimits {
    pub max_transitions: u64,
    pub max_projective_columns: usize,
    pub max_states: usize,
    pub max_matrix_payload_bytes: usize,
}

const _: () = assert!(std::mem::size_of::<SpanBuildLimits>() == 32);
const _: () = assert!(std::mem::align_of::<SpanBuildLimits>() == 8);

pub const DEFAULT_SPAN_BUILD_LIMITS: SpanBuildLimits = SpanBuildLimits {
    max_transitions: 50_000_000,
    max_projective_columns: 1 << 20,
    max_states: 1 << 18,
    max_matrix_payload_bytes: 128 << 20,
};

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct SpanState {
    basis: MatrixId,
    witness: WitnessId,
    rank: u16,
    _pad: u16,
    _reserved: u32,
}

const _: () = assert!(std::mem::size_of::<SpanState>() == 16);
const _: () = assert!(std::mem::align_of::<SpanState>() == 4);

#[derive(Debug)]
struct ColumnRep {
    values: Box<[u8]>,
    coordinate: u32,
    inverse_scale: u8,
}

#[derive(Debug)]
pub struct SpanAnswer {
    pub cost: u16,
    pub support: Box<[u32]>,
}

/// Canonical column-space image of a scalar demand, reusable across queries.
#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub struct CanonicalTargetImage {
    field_order: u8,
    ambient: u16,
    basis: Matrix,
}

impl CanonicalTargetImage {
    pub fn basis(&self) -> &Matrix {
        &self.basis
    }
}

/// Generated-span closure with fixed-size hot states and arena witnesses.
#[derive(Debug)]
pub struct GeneratedSpanTable {
    ambient: u16,
    bases: FlatMatrixArena,
    states: Vec<SpanState>,
    witnesses: WitnessArena,
    transitions: u64,
}

impl GeneratedSpanTable {
    pub fn build<const P: u8>(generator: &Matrix) -> Result<Self, SpanError> {
        Self::build_bounded::<P>(generator, DEFAULT_SPAN_BUILD_LIMITS)
    }

    pub fn build_bounded<const P: u8>(
        generator: &Matrix,
        limits: SpanBuildLimits,
    ) -> Result<Self, SpanError> {
        if limits.max_transitions == 0
            || limits.max_projective_columns == 0
            || limits.max_states == 0
            || limits.max_matrix_payload_bytes == 0
        {
            return Err(SpanError::InvalidLimits);
        }
        Prime::<P>::validate().map_err(MatrixError::from)?;
        generator.ensure_field::<Prime<P>>()?;
        if generator.cols() > u32::MAX as usize {
            return Err(SpanError::CoordinateOverflow);
        }
        if generator.rows() > u16::MAX as usize {
            return Err(SpanError::ResourceLimit(SpanResource::BasisBytes));
        }
        let (columns, mut retained_matrix_bytes) = projective_columns::<P>(
            generator,
            limits.max_projective_columns,
            limits.max_matrix_payload_bytes,
        )?;
        let ambient = generator.rows();
        let mut bases = FlatMatrixArena::default();
        let zero_id = bases.push(0, ambient, &[]);
        let mut index = CollisionIndex::default();
        index.insert(byte_hash(&[]), zero_id.0);
        let mut states = vec![SpanState {
            basis: zero_id,
            witness: WitnessArena::ROOT,
            rank: 0,
            _pad: 0,
            _reserved: 0,
        }];
        let mut witnesses = WitnessArena::default();
        let mut transitions = 0u64;
        let scratch_capacity = ambient
            .checked_add(1)
            .and_then(|rows| rows.checked_mul(ambient))
            .filter(|&cells| cells <= limits.max_matrix_payload_bytes)
            .ok_or(SpanError::ResourceLimit(SpanResource::BasisBytes))?;
        let mut scratch = Vec::with_capacity(scratch_capacity);
        for column in columns {
            let old_len = states.len();
            transitions = u64::try_from(old_len)
                .ok()
                .and_then(|count| transitions.checked_add(count))
                .filter(|&count| count <= limits.max_transitions)
                .ok_or(SpanError::ResourceLimit(SpanResource::Transitions))?;
            for state_index in 0..old_len {
                let state = states[state_index];
                let basis = bases.get(state.basis);
                debug_assert_eq!(basis.cols, ambient);
                scratch.clear();
                scratch.extend_from_slice(basis.data);
                scratch.extend_from_slice(&column.values);
                let candidate_rank =
                    canonicalize_rows_in_place::<P>(&mut scratch, basis.rows + 1, ambient)?;
                scratch.truncate(candidate_rank * ambient);
                if candidate_rank == state.rank as usize {
                    continue;
                }
                let hash = byte_hash(&scratch);
                if index
                    .lookup(hash, |id| bases.get(MatrixId(id)).data == scratch)
                    .is_some()
                {
                    continue;
                }
                if states.len() >= limits.max_states || states.len() >= u32::MAX as usize {
                    return Err(SpanError::ResourceLimit(SpanResource::States));
                }
                retained_matrix_bytes = retained_matrix_bytes
                    .checked_add(scratch.len())
                    .filter(|&bytes| bytes <= limits.max_matrix_payload_bytes)
                    .ok_or(SpanError::ResourceLimit(SpanResource::BasisBytes))?;
                let basis_id = bases.push(candidate_rank, ambient, &scratch);
                let witness =
                    witnesses.push(state.witness, column.coordinate, column.inverse_scale);
                index.insert(hash, basis_id.0);
                states.push(SpanState {
                    basis: basis_id,
                    witness,
                    rank: state.rank + 1,
                    _pad: 0,
                    _reserved: 0,
                });
            }
        }
        states.sort_unstable_by_key(|state| (state.rank, state.basis.0));
        Ok(Self {
            ambient: ambient as u16,
            bases,
            states,
            witnesses,
            transitions,
        })
    }

    pub fn generated_span_count(&self) -> usize {
        self.states.len()
    }

    pub fn transitions(&self) -> u64 {
        self.transitions
    }

    pub fn query<const P: u8>(&self, target: &Matrix) -> Result<Option<SpanAnswer>, SpanError> {
        let image = self.canonical_target_image::<P>(target)?;
        self.query_canonical_target_image::<P>(&image)
    }

    /// Compile a scalar demand to its canonical message-space image.
    pub fn canonical_target_image<const P: u8>(
        &self,
        target: &Matrix,
    ) -> Result<CanonicalTargetImage, SpanError> {
        Prime::<P>::validate().map_err(MatrixError::from)?;
        if target.rows() != self.ambient as usize {
            return Err(MatrixError::Shape.into());
        }
        let basis = target.transpose::<P>()?.canonical_row_basis::<P>()?;
        Ok(CanonicalTargetImage {
            field_order: P,
            ambient: self.ambient,
            basis,
        })
    }

    /// Query a previously canonicalized scalar-demand image without repeating
    /// transpose and row elimination.
    pub fn query_canonical_target_image<const P: u8>(
        &self,
        target_image: &CanonicalTargetImage,
    ) -> Result<Option<SpanAnswer>, SpanError> {
        Prime::<P>::validate().map_err(MatrixError::from)?;
        if target_image.field_order != P {
            return Err(SpanError::ImageField {
                expected: P,
                actual: target_image.field_order,
            });
        }
        if target_image.ambient != self.ambient {
            return Err(MatrixError::Shape.into());
        }
        let mut scratch = Vec::new();
        for state in &self.states {
            let basis = self.bases.get(state.basis);
            scratch.clear();
            scratch.extend_from_slice(basis.data);
            scratch.extend_from_slice(target_image.basis.as_slice());
            let joined_rank = canonicalize_rows_in_place::<P>(
                &mut scratch,
                basis.rows + target_image.basis.rows(),
                basis.cols,
            )?;
            if joined_rank == basis.rows {
                return Ok(Some(SpanAnswer {
                    cost: state.rank,
                    support: self.witnesses.support(state.witness),
                }));
            }
        }
        Ok(None)
    }
}

fn projective_columns<const P: u8>(
    generator: &Matrix,
    maximum_columns: usize,
    maximum_matrix_payload_bytes: usize,
) -> Result<(Vec<ColumnRep>, usize), SpanError> {
    let mut representatives = CollisionIndex::default();
    let mut result: Vec<ColumnRep> = Vec::new();
    let mut retained_matrix_bytes = 0_usize;
    for coordinate in 0..generator.cols() {
        let column = generator.column(coordinate);
        let Some(pivot) = column.iter().copied().find(|&entry| entry != 0) else {
            continue;
        };
        let inverse = FieldElement::<Prime<P>>::from_canonical(pivot)
            .inverse()
            .map_err(MatrixError::from)?;
        let normalized: Box<[u8]> = column
            .iter()
            .map(|&entry| (FieldElement::<Prime<P>>::from_canonical(entry) * inverse).value())
            .collect::<Vec<_>>()
            .into_boxed_slice();
        let hash = byte_hash(&normalized);
        if representatives
            .lookup(hash, |id| result[id as usize].values == normalized)
            .is_some()
        {
            continue;
        }
        if result.len() >= maximum_columns {
            return Err(SpanError::ResourceLimit(SpanResource::ProjectiveColumns));
        }
        retained_matrix_bytes = retained_matrix_bytes
            .checked_add(normalized.len())
            .filter(|&bytes| bytes <= maximum_matrix_payload_bytes)
            .ok_or(SpanError::ResourceLimit(SpanResource::BasisBytes))?;
        let id = u32::try_from(result.len()).map_err(|_| SpanError::CoordinateOverflow)?;
        representatives.insert(hash, id);
        result.push(ColumnRep {
            values: normalized,
            coordinate: u32::try_from(coordinate).map_err(|_| SpanError::CoordinateOverflow)?,
            inverse_scale: inverse.value(),
        });
    }
    Ok((result, retained_matrix_bytes))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn collision_index_replays_full_keys_inside_one_hash_bucket() {
        let values = [b"alpha".as_slice(), b"beta".as_slice(), b"gamma".as_slice()];
        let mut index = CollisionIndex::default();
        for id in 0..values.len() as u32 {
            index.insert(7, id);
        }
        for (expected, value) in values.iter().enumerate() {
            assert_eq!(
                index.lookup(7, |id| values[id as usize] == *value),
                Some(expected as u32)
            );
        }
        assert_eq!(index.lookup(7, |id| values[id as usize] == b"delta"), None);
    }

    #[test]
    fn generated_spans_match_triangle_gauge() {
        let generator = Matrix::new::<2>(2, 3, vec![1, 0, 1, 0, 1, 1]).unwrap();
        let table = GeneratedSpanTable::build::<2>(&generator).unwrap();
        assert_eq!(table.generated_span_count(), 5);
        let one = Matrix::new::<2>(2, 1, vec![1, 1]).unwrap();
        let full = Matrix::new::<2>(2, 2, vec![1, 0, 0, 1]).unwrap();
        assert_eq!(table.query::<2>(&one).unwrap().unwrap().cost, 1);
        assert_eq!(table.query::<2>(&full).unwrap().unwrap().cost, 2);
    }

    #[test]
    fn bounded_span_compilation_fails_before_each_resource_can_grow() {
        let generator = Matrix::new::<2>(2, 3, vec![1, 0, 1, 0, 1, 1]).unwrap();

        let mut limits = DEFAULT_SPAN_BUILD_LIMITS;
        limits.max_projective_columns = 2;
        assert!(matches!(
            GeneratedSpanTable::build_bounded::<2>(&generator, limits),
            Err(SpanError::ResourceLimit(SpanResource::ProjectiveColumns))
        ));

        let mut limits = DEFAULT_SPAN_BUILD_LIMITS;
        limits.max_states = 4;
        assert!(matches!(
            GeneratedSpanTable::build_bounded::<2>(&generator, limits),
            Err(SpanError::ResourceLimit(SpanResource::States))
        ));

        let mut limits = DEFAULT_SPAN_BUILD_LIMITS;
        limits.max_transitions = 1;
        assert!(matches!(
            GeneratedSpanTable::build_bounded::<2>(&generator, limits),
            Err(SpanError::ResourceLimit(SpanResource::Transitions))
        ));

        let mut limits = DEFAULT_SPAN_BUILD_LIMITS;
        limits.max_matrix_payload_bytes = 3;
        assert!(matches!(
            GeneratedSpanTable::build_bounded::<2>(&generator, limits),
            Err(SpanError::ResourceLimit(SpanResource::BasisBytes))
        ));

        let mut limits = DEFAULT_SPAN_BUILD_LIMITS;
        limits.max_states = 0;
        assert!(matches!(
            GeneratedSpanTable::build_bounded::<2>(&generator, limits),
            Err(SpanError::InvalidLimits)
        ));
    }

    #[test]
    fn matrix_payload_limit_counts_each_unique_payload_once() {
        let generator = Matrix::new::<2>(1, 2, vec![1, 1]).unwrap();
        let mut limits = DEFAULT_SPAN_BUILD_LIMITS;
        limits.max_matrix_payload_bytes = 2;
        let table = GeneratedSpanTable::build_bounded::<2>(&generator, limits).unwrap();
        assert_eq!(table.generated_span_count(), 2);

        limits.max_matrix_payload_bytes = 1;
        assert!(matches!(
            GeneratedSpanTable::build_bounded::<2>(&generator, limits),
            Err(SpanError::ResourceLimit(SpanResource::BasisBytes))
        ));
    }

    #[test]
    fn canonical_target_images_are_reusable_across_presentations() {
        let generator = Matrix::new::<2>(2, 3, vec![1, 0, 1, 0, 1, 1]).unwrap();
        let table = GeneratedSpanTable::build::<2>(&generator).unwrap();
        let one_column = Matrix::new::<2>(2, 1, vec![1, 1]).unwrap();
        let repeated_column = Matrix::new::<2>(2, 2, vec![1, 1, 1, 1]).unwrap();
        let one_image = table.canonical_target_image::<2>(&one_column).unwrap();
        let repeated_image = table.canonical_target_image::<2>(&repeated_column).unwrap();
        assert_eq!(one_image, repeated_image);
        let answer = table
            .query_canonical_target_image::<2>(&one_image)
            .unwrap()
            .unwrap();
        assert_eq!(answer.cost, 1);
        assert!(matches!(
            table.query_canonical_target_image::<3>(&one_image),
            Err(SpanError::ImageField {
                expected: 3,
                actual: 2
            })
        ));
    }

    #[test]
    fn projective_duplicate_restores_original_coordinate() {
        let generator = Matrix::new::<3>(2, 3, vec![2, 1, 0, 0, 0, 2]).unwrap();
        let table = GeneratedSpanTable::build::<3>(&generator).unwrap();
        let target = Matrix::new::<3>(2, 1, vec![1, 0]).unwrap();
        let answer = table.query::<3>(&target).unwrap().unwrap();
        assert_eq!(answer.cost, 1);
        assert_eq!(&*answer.support, &[0]);
    }

    #[test]
    fn generated_span_rejects_cross_field_generator_bytes() {
        use crate::field::Gf4;

        let generator = Matrix::new_field::<Gf4>(1, 1, vec![1]).unwrap();
        assert!(matches!(
            GeneratedSpanTable::build::<2>(&generator),
            Err(SpanError::Matrix(MatrixError::FieldMismatch))
        ));
    }
}
