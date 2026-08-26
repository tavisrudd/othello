use crate::arena::{FlatMatrixArena, MatrixId};
use crate::field::Prime;
use crate::matrix::{canonicalize_rows_in_place, Matrix, MatrixError};
use crate::witness::{WitnessArena, WitnessId};
use rustc_hash::FxHashMap;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum SpanError {
    #[error(transparent)]
    Matrix(#[from] MatrixError),
    #[error("the generator has too many coordinates for u32 witness IDs")]
    CoordinateOverflow,
}

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
        Prime::<P>::validate().map_err(MatrixError::from)?;
        let columns = projective_columns::<P>(generator)?;
        let ambient = generator.rows();
        let mut bases = FlatMatrixArena::default();
        let zero_id = bases.push(0, ambient, &[]);
        let mut index: FxHashMap<Box<[u8]>, MatrixId> = FxHashMap::default();
        index.insert(Box::new([]), zero_id);
        let mut states = vec![SpanState {
            basis: zero_id,
            witness: WitnessArena::ROOT,
            rank: 0,
            _pad: 0,
            _reserved: 0,
        }];
        let mut witnesses = WitnessArena::default();
        let mut transitions = 0u64;
        let mut scratch = Vec::new();

        for column in columns {
            let old_len = states.len();
            for state_index in 0..old_len {
                transitions += 1;
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
                if index.contains_key(scratch.as_slice()) {
                    continue;
                }
                let basis_id = bases.push(candidate_rank, ambient, &scratch);
                let witness =
                    witnesses.push(state.witness, column.coordinate, column.inverse_scale);
                index.insert(scratch.clone().into_boxed_slice(), basis_id);
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
        if target.rows() != self.ambient as usize {
            return Err(MatrixError::Shape.into());
        }
        let target_basis = target.transpose::<P>()?.canonical_row_basis::<P>()?;
        let mut scratch = Vec::new();
        for state in &self.states {
            let basis = self.bases.get(state.basis);
            scratch.clear();
            scratch.extend_from_slice(basis.data);
            scratch.extend_from_slice(target_basis.as_slice());
            let joined_rank = canonicalize_rows_in_place::<P>(
                &mut scratch,
                basis.rows + target_basis.rows(),
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

fn projective_columns<const P: u8>(generator: &Matrix) -> Result<Vec<ColumnRep>, SpanError> {
    let mut representatives: FxHashMap<Box<[u8]>, ()> = FxHashMap::default();
    let mut result = Vec::new();
    for coordinate in 0..generator.cols() {
        let column = generator.column(coordinate);
        let Some(pivot) = column.iter().copied().find(|&entry| entry != 0) else {
            continue;
        };
        let inverse = Prime::<P>::inverse(pivot).map_err(MatrixError::from)?;
        let normalized: Box<[u8]> = column
            .iter()
            .map(|&entry| Prime::<P>::mul(entry, inverse))
            .collect::<Vec<_>>()
            .into_boxed_slice();
        if representatives.insert(normalized.clone(), ()).is_none() {
            result.push(ColumnRep {
                values: normalized,
                coordinate: u32::try_from(coordinate).map_err(|_| SpanError::CoordinateOverflow)?,
                inverse_scale: inverse,
            });
        }
    }
    Ok(result)
}

#[cfg(test)]
mod tests {
    use super::*;

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
    fn projective_duplicate_restores_original_coordinate() {
        let generator = Matrix::new::<3>(2, 3, vec![2, 1, 0, 0, 0, 2]).unwrap();
        let table = GeneratedSpanTable::build::<3>(&generator).unwrap();
        let target = Matrix::new::<3>(2, 1, vec![1, 0]).unwrap();
        let answer = table.query::<3>(&target).unwrap().unwrap();
        assert_eq!(answer.cost, 1);
        assert_eq!(&*answer.support, &[0]);
    }
}
