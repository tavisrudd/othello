//! Exact order-six CRT residual between q58, q87, and q174.
//!
//! A q174 column is a `2 x 3` table of signed triple sums.  q58 supplies its
//! two row margins, q87 its three column margins, and one Eisenstein integer
//! supplies the two missing degrees of freedom.  The three views reconstruct
//! the q174 column exactly.

use thiserror::Error;

use crate::proof_synthesis::{evolve_bounded_homogeneous_relations, SynthesisError};

pub const ORDER6_DIRECTORY_LEN: usize = 34_300;
pub const ORDER6_LIFT_COUNT: usize = 4_096;
pub const ORDER6_MAX_LIFTS: usize = 12;
pub const ORDER6_COLUMNS: usize = 29;
pub const ORDER6_BLOCKS: usize = 4;
pub const EISENSTEIN_ENERGY_TARGET: usize = 523;
pub const ORDER6_PARSEVAL_FIELDS: usize = 5;
const ENERGY_WORDS: usize = (EISENSTEIN_ENERGY_TARGET + 64) / 64;

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct Order6LiftRange {
    pub start: u16,
    pub len: u8,
    _padding: u8,
}

const _: () = assert!(std::mem::size_of::<Order6LiftRange>() == 4);
const _: () = assert!(std::mem::align_of::<Order6LiftRange>() == 2);

#[repr(transparent)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct PackedOrder6Lift(pub u16);

const _: () = assert!(std::mem::size_of::<PackedOrder6Lift>() == 2);
const _: () = assert!(std::mem::align_of::<PackedOrder6Lift>() == 2);

#[repr(transparent)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct Order6MarginKey(pub u16);

const _: () = assert!(std::mem::size_of::<Order6MarginKey>() == 2);
const _: () = assert!(std::mem::align_of::<Order6MarginKey>() == 2);

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, Hash)]
pub struct EisensteinResidual {
    pub real: i8,
    pub omega: i8,
}

const _: () = assert!(std::mem::size_of::<EisensteinResidual>() == 2);
const _: () = assert!(std::mem::align_of::<EisensteinResidual>() == 1);

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Order6EnergyWorkspace {
    current: [u64; ENERGY_WORDS],
    next: [u64; ENERGY_WORDS],
    norms: [u16; ORDER6_MAX_LIFTS],
    _padding: [u8; 24],
}

const _: () = assert!(std::mem::size_of::<Order6EnergyWorkspace>() == 192);
const _: () = assert!(std::mem::align_of::<Order6EnergyWorkspace>() == 64);

impl Order6EnergyWorkspace {
    pub const ZERO: Self = Self {
        current: [0; ENERGY_WORDS],
        next: [0; ENERGY_WORDS],
        norms: [0; ORDER6_MAX_LIFTS],
        _padding: [0; 24],
    };
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Order6LiftDirectory {
    ranges: Box<[Order6LiftRange]>,
    lifts: Box<[PackedOrder6Lift]>,
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum Order6ResidualError {
    #[error("q58 row margin is not an odd integer in [-9, 9]")]
    InvalidQ58Margin,
    #[error("q87 column margin is not an even integer in [-6, 6]")]
    InvalidQ87Margin,
    #[error("order-six directory construction invariant failed")]
    DirectoryInvariant,
    #[error("order-six margin key is outside the compiled directory")]
    InvalidKey,
}

impl Order6MarginKey {
    pub fn from_signed(q58: [i8; 2], q87: [i8; 3]) -> Result<Self, Order6ResidualError> {
        let mut rows = [0_u8; 2];
        for (slot, signed) in q58.into_iter().enumerate() {
            if !(-9..=9).contains(&signed) || signed & 1 == 0 {
                return Err(Order6ResidualError::InvalidQ58Margin);
            }
            rows[slot] = ((i16::from(signed) + 9) / 2) as u8;
        }
        let mut columns = [0_u8; 3];
        for (slot, signed) in q87.into_iter().enumerate() {
            if !(-6..=6).contains(&signed) || signed & 1 != 0 {
                return Err(Order6ResidualError::InvalidQ87Margin);
            }
            columns[slot] = ((i16::from(signed) + 6) / 2) as u8;
        }
        Ok(Self(encode_key(rows, columns) as u16))
    }
}

impl PackedOrder6Lift {
    #[inline(always)]
    #[must_use]
    pub fn cell(self, row: usize, column: usize) -> u8 {
        ((self.0 >> (2 * (3 * row + column))) & 3) as u8
    }

    #[inline(always)]
    #[must_use]
    pub fn residual(self) -> EisensteinResidual {
        let d0 = self.cell(0, 0) as i8 - self.cell(1, 0) as i8;
        let d1 = self.cell(0, 1) as i8 - self.cell(1, 1) as i8;
        let d2 = self.cell(0, 2) as i8 - self.cell(1, 2) as i8;
        EisensteinResidual {
            real: d0 - d2,
            omega: d1 - d2,
        }
    }

    #[inline(always)]
    #[must_use]
    pub fn extreme_count(self) -> u8 {
        let mut count = 0_u8;
        for row in 0..2 {
            for column in 0..3 {
                let cell = self.cell(row, column);
                count += u8::from(cell == 0 || cell == 3);
            }
        }
        count
    }

    /// Return `(q174, q58, q87, q29, residual)` local square energies.
    #[must_use]
    pub fn projection_energies(self) -> [i32; 5] {
        let mut cells = [[0_i32; 3]; 2];
        let mut q174 = 0_i32;
        for (row, row_cells) in cells.iter_mut().enumerate() {
            for (column, cell) in row_cells.iter_mut().enumerate() {
                *cell = 2 * i32::from(self.cell(row, column)) - 3;
                q174 += *cell * *cell;
            }
        }
        let rows = [cells[0].iter().sum::<i32>(), cells[1].iter().sum::<i32>()];
        let columns = std::array::from_fn::<_, 3, _>(|column| cells[0][column] + cells[1][column]);
        let total = rows[0] + rows[1];
        let q58 = rows.iter().map(|value| value * value).sum();
        let q87 = columns.iter().map(|value| value * value).sum();
        let q29 = total * total;
        let residual = i32::from(self.residual().norm());
        [q174, q58, q87, q29, residual]
    }
}

/// Local character-orthogonality identity for the exact CRT decomposition.
/// Summing it shows that the residual energy 523 is forced by the registered
/// q29/q58/q87/q174 zero shells and need not be searched independently.
#[must_use]
pub fn order6_parseval_identity_holds(lift: PackedOrder6Lift) -> bool {
    let [q174, q58, q87, q29, residual] = lift.projection_energies();
    8 * residual == 6 * q174 - 2 * q58 - 3 * q87 + q29
}

/// Feed anonymous projection-energy observations to the generic bounded
/// relation evolver.  No theorem coefficients or labelled residual are given
/// to the synthesizer.
pub fn evolve_order6_energy_relations<const CAPACITY: usize>(
    output: &mut [[i8; ORDER6_PARSEVAL_FIELDS]; CAPACITY],
) -> Result<(u64, usize), SynthesisError> {
    let rows = std::array::from_fn::<_, ORDER6_LIFT_COUNT, _>(|packed| {
        PackedOrder6Lift(packed as u16).projection_energies()
    });
    evolve_bounded_homogeneous_relations(&rows, 8, output)
}

impl EisensteinResidual {
    #[inline(always)]
    #[must_use]
    pub fn norm(self) -> u16 {
        let real = i16::from(self.real);
        let omega = i16::from(self.omega);
        (real * real - real * omega + omega * omega) as u16
    }

    /// Residue modulo the Eisenstein prime `(1-omega)`, represented in `F_3`.
    #[inline(always)]
    #[must_use]
    pub fn prime_residue(self) -> u8 {
        (i16::from(self.real) + i16::from(self.omega)).rem_euclid(3) as u8
    }
}

/// The q58 row margins determine the Eisenstein residual modulo `1-omega`.
/// This permits pair keys to store only the quotient residual.
pub fn q58_forced_prime_residue(q58: [i8; 2]) -> Result<u8, Order6ResidualError> {
    for signed in q58 {
        if !(-9..=9).contains(&signed) || signed & 1 == 0 {
            return Err(Order6ResidualError::InvalidQ58Margin);
        }
    }
    // Division by two in F_3 is multiplication by two.
    Ok((2 * ((i16::from(q58[0]) - i16::from(q58[1])).rem_euclid(3) as u8)) % 3)
}

impl Order6LiftDirectory {
    pub fn compile() -> Result<Self, Order6ResidualError> {
        let mut counts = vec![0_u8; ORDER6_DIRECTORY_LEN];
        for packed in 0_u16..ORDER6_LIFT_COUNT as u16 {
            let key = key_of_lift(PackedOrder6Lift(packed));
            counts[key] += 1;
        }

        let mut ranges = vec![Order6LiftRange::default(); ORDER6_DIRECTORY_LEN].into_boxed_slice();
        let mut cursor = 0_u16;
        for (range, &count) in ranges.iter_mut().zip(&counts) {
            *range = Order6LiftRange {
                start: cursor,
                len: count,
                _padding: 0,
            };
            cursor = cursor
                .checked_add(u16::from(count))
                .ok_or(Order6ResidualError::DirectoryInvariant)?;
        }
        if usize::from(cursor) != ORDER6_LIFT_COUNT {
            return Err(Order6ResidualError::DirectoryInvariant);
        }

        let mut write = vec![0_u16; ORDER6_DIRECTORY_LEN];
        for (slot, range) in write.iter_mut().zip(ranges.iter()) {
            *slot = range.start;
        }
        let mut lifts = vec![PackedOrder6Lift::default(); ORDER6_LIFT_COUNT].into_boxed_slice();
        for packed in 0_u16..ORDER6_LIFT_COUNT as u16 {
            let lift = PackedOrder6Lift(packed);
            let key = key_of_lift(lift);
            let slot = usize::from(write[key]);
            lifts[slot] = lift;
            write[key] += 1;
        }
        Ok(Self { ranges, lifts })
    }

    #[inline(always)]
    pub fn lifts(&self, key: Order6MarginKey) -> Result<&[PackedOrder6Lift], Order6ResidualError> {
        let key = usize::from(key.0);
        let range = self
            .ranges
            .get(key)
            .ok_or(Order6ResidualError::InvalidKey)?;
        let start = usize::from(range.start);
        Ok(&self.lifts[start..start + usize::from(range.len)])
    }

    #[must_use]
    pub fn census(&self) -> (usize, usize, usize, usize) {
        let sum_compatible = (0..ORDER6_DIRECTORY_LEN)
            .filter(|&key| key_totals_agree(key))
            .count();
        let feasible = self.ranges.iter().filter(|range| range.len != 0).count();
        let deterministic = self.ranges.iter().filter(|range| range.len == 1).count();
        let maximum = self
            .ranges
            .iter()
            .map(|range| usize::from(range.len))
            .max()
            .unwrap_or(0);
        (sum_compatible, feasible, deterministic, maximum)
    }
}

/// Check the zero-shift Eisenstein norm before any off-zero correlation work.
/// The 523-bit dynamic program is fixed-size and allocation-free.
pub fn eisenstein_energy_target_reachable(
    directory: &Order6LiftDirectory,
    keys: &[[Order6MarginKey; ORDER6_COLUMNS]; ORDER6_BLOCKS],
    workspace: &mut Order6EnergyWorkspace,
) -> Result<bool, Order6ResidualError> {
    workspace.current.fill(0);
    workspace.current[0] = 1;
    for block_keys in keys {
        for &key in block_keys {
            let lifts = directory.lifts(key)?;
            if lifts.is_empty() {
                return Ok(false);
            }
            let mut norm_count = 0_usize;
            for &lift in lifts {
                let norm = lift.residual().norm();
                if !workspace.norms[..norm_count].contains(&norm) {
                    workspace.norms[norm_count] = norm;
                    norm_count += 1;
                }
            }
            workspace.next.fill(0);
            for &norm in &workspace.norms[..norm_count] {
                or_shifted(&mut workspace.next, &workspace.current, usize::from(norm));
            }
            std::mem::swap(&mut workspace.current, &mut workspace.next);
        }
    }
    Ok(workspace.current[EISENSTEIN_ENERGY_TARGET / 64]
        & (1_u64 << (EISENSTEIN_ENERGY_TARGET % 64))
        != 0)
}

#[inline(always)]
fn or_shifted(output: &mut [u64; ENERGY_WORDS], input: &[u64; ENERGY_WORDS], shift: usize) {
    let word_shift = shift / 64;
    let bit_shift = shift % 64;
    for source in 0..ENERGY_WORDS {
        let value = input[source];
        let target = source + word_shift;
        if target >= ENERGY_WORDS {
            break;
        }
        output[target] |= value << bit_shift;
        if bit_shift != 0 && target + 1 < ENERGY_WORDS {
            output[target + 1] |= value >> (64 - bit_shift);
        }
    }
}

fn key_of_lift(lift: PackedOrder6Lift) -> usize {
    let rows = [
        lift.cell(0, 0) + lift.cell(0, 1) + lift.cell(0, 2),
        lift.cell(1, 0) + lift.cell(1, 1) + lift.cell(1, 2),
    ];
    let columns = [
        lift.cell(0, 0) + lift.cell(1, 0),
        lift.cell(0, 1) + lift.cell(1, 1),
        lift.cell(0, 2) + lift.cell(1, 2),
    ];
    encode_key(rows, columns)
}

fn encode_key(rows: [u8; 2], columns: [u8; 3]) -> usize {
    ((((usize::from(rows[0]) * 10 + usize::from(rows[1])) * 7 + usize::from(columns[0])) * 7
        + usize::from(columns[1]))
        * 7)
        + usize::from(columns[2])
}

fn decode_key(mut key: usize) -> ([u8; 2], [u8; 3]) {
    let column2 = (key % 7) as u8;
    key /= 7;
    let column1 = (key % 7) as u8;
    key /= 7;
    let column0 = (key % 7) as u8;
    key /= 7;
    let row1 = (key % 10) as u8;
    key /= 10;
    ([key as u8, row1], [column0, column1, column2])
}

fn key_totals_agree(key: usize) -> bool {
    let (rows, columns) = decode_key(key);
    rows[0] + rows[1] == columns[0] + columns[1] + columns[2]
}

#[cfg(test)]
mod tests {
    use std::collections::HashSet;

    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn exact_local_census_matches_closed_counts() {
        let directory = Order6LiftDirectory::compile().unwrap();
        assert_eq!(directory.census(), (2_470, 1_666, 726, 12));
        assert_eq!(
            directory
                .ranges
                .iter()
                .map(|range| usize::from(range.len))
                .sum::<usize>(),
            4_096
        );
    }

    #[test]
    fn margins_plus_residual_reconstruct_every_table_uniquely() {
        let directory = Order6LiftDirectory::compile().unwrap();
        for key in 0..ORDER6_DIRECTORY_LEN {
            let lifts = directory.lifts(Order6MarginKey(key as u16)).unwrap();
            let mut residuals = HashSet::new();
            for &lift in lifts {
                assert_eq!(key_of_lift(lift), key);
                assert!(residuals.insert(lift.residual()));
            }
        }
    }

    #[test]
    fn parseval_energy_identity_holds_for_all_local_tables() {
        for packed in 0_u16..ORDER6_LIFT_COUNT as u16 {
            assert!(order6_parseval_identity_holds(PackedOrder6Lift(packed)));
        }
        assert_eq!(6 * 2_080 - 2 * 2_056 - 3 * 2_068 + 2_020, 8 * 523);
    }

    #[test]
    fn blind_relation_evolution_rediscovers_parseval_identity() {
        let mut relations = [[0_i8; ORDER6_PARSEVAL_FIELDS]; 4];
        let (_, found) = evolve_order6_energy_relations(&mut relations).unwrap();
        assert_eq!(found, 1);
        assert_eq!(relations[0], [6, -2, -3, 1, -8]);
    }

    #[test]
    fn signed_key_semantics_and_malformed_values_are_checked() {
        let key = Order6MarginKey::from_signed([-3, 1], [-2, 0, 0]).unwrap();
        assert!(key_totals_agree(usize::from(key.0)));
        assert_eq!(
            Order6MarginKey::from_signed([0, 1], [-2, 0, 0]),
            Err(Order6ResidualError::InvalidQ58Margin)
        );
        assert_eq!(
            Order6MarginKey::from_signed([-3, 1], [-1, 0, 0]),
            Err(Order6ResidualError::InvalidQ87Margin)
        );
    }

    #[test]
    fn q58_margin_forces_eisenstein_prime_residue_for_every_lift() {
        let directory = Order6LiftDirectory::compile().unwrap();
        for row0 in 0_i8..=9 {
            for row1 in 0_i8..=9 {
                let q58 = [2 * row0 - 9, 2 * row1 - 9];
                let expected = q58_forced_prime_residue(q58).unwrap();
                for column0 in 0_i8..=6 {
                    for column1 in 0_i8..=6 {
                        for column2 in 0_i8..=6 {
                            let key = Order6MarginKey::from_signed(
                                q58,
                                [2 * column0 - 6, 2 * column1 - 6, 2 * column2 - 6],
                            )
                            .unwrap();
                            for lift in directory.lifts(key).unwrap() {
                                assert_eq!(lift.residual().prime_residue(), expected);
                            }
                        }
                    }
                }
            }
        }
    }

    #[test]
    fn energy_dp_matches_direct_singleton_sum_and_allocates_nothing() {
        let directory = Order6LiftDirectory::compile().unwrap();
        let singleton = (0..ORDER6_DIRECTORY_LEN)
            .find(|&key| directory.ranges[key].len == 1)
            .unwrap();
        let keys = [[Order6MarginKey(singleton as u16); ORDER6_COLUMNS]; ORDER6_BLOCKS];
        let lift = directory.lifts(Order6MarginKey(singleton as u16)).unwrap()[0];
        let expected = usize::from(lift.residual().norm()) * ORDER6_COLUMNS * ORDER6_BLOCKS
            == EISENSTEIN_ENERGY_TARGET;
        let mut workspace = Order6EnergyWorkspace::ZERO;
        let (actual, allocations) = tracked_allocations(|| {
            eisenstein_energy_target_reachable(&directory, &keys, &mut workspace).unwrap()
        });
        assert_eq!(actual, expected);
        assert_eq!(allocations, 0);
    }

    #[test]
    fn bitset_shift_matches_scalar_reachability() {
        let directory = Order6LiftDirectory::compile().unwrap();
        let feasible = directory
            .ranges
            .iter()
            .enumerate()
            .filter(|(_, range)| range.len != 0)
            .map(|(key, _)| Order6MarginKey(key as u16))
            .take(116)
            .collect::<Vec<_>>();
        let mut keys = [[Order6MarginKey::default(); ORDER6_COLUMNS]; ORDER6_BLOCKS];
        for (slot, key) in keys.iter_mut().flatten().zip(feasible.into_iter()) {
            *slot = key;
        }
        let mut scalar = [false; EISENSTEIN_ENERGY_TARGET + 1];
        scalar[0] = true;
        for &key in keys.iter().flatten() {
            let before = scalar;
            scalar.fill(false);
            for lift in directory.lifts(key).unwrap() {
                let norm = usize::from(lift.residual().norm());
                for total in 0..=EISENSTEIN_ENERGY_TARGET.saturating_sub(norm) {
                    scalar[total + norm] |= before[total];
                }
            }
        }
        let mut workspace = Order6EnergyWorkspace::ZERO;
        assert_eq!(
            eisenstein_energy_target_reachable(&directory, &keys, &mut workspace).unwrap(),
            scalar[EISENSTEIN_ENERGY_TARGET]
        );
    }
}
