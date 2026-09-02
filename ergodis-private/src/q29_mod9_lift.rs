//! Exact bounded integer lift of a supplied four-row q29 mod-nine shell.
//!
//! Each canonical residue `r in 0..9` has two lifts in `[-9,9]`, except zero
//! which has `{-9,0,9}`.  Write a lift as `base(r)+9t`, where `base(0)=-9`
//! and `t in {0,1,2}`, while `base(r)=r-9` and `t in {0,1}` otherwise.
//! The row sum fixes `T=(target-sum(base))/9`, so the bounded iterative DP
//! needs only 59 lift-index totals rather than 523 signed sums.  It enforces
//! `(1,0,0,0)` and combined square energy 505.  No recursion or allocation
//! occurs in `solve_q29_mod9_lift`.

pub const Q29_MOD9_ROWS: usize = 4;
pub const Q29_MOD9_COLUMNS: usize = 29;
pub const Q29_MOD9_TOTAL_ENERGY: usize = 505;
const MAX_LIFT_INDEX: usize = 2 * Q29_MOD9_COLUMNS;
const LIFT_INDEX_VALUES: usize = MAX_LIFT_INDEX + 1;
const ENERGY_VALUES: usize = Q29_MOD9_TOTAL_ENERGY + 1;
const ROW_STATE_COUNT: usize = LIFT_INDEX_VALUES * ENERGY_VALUES;
const ROW_LAYERS: usize = Q29_MOD9_COLUMNS + 1;
const PREDECESSOR_LEN: usize = ROW_LAYERS * ROW_STATE_COUNT;
const OUTER_LAYERS: usize = Q29_MOD9_ROWS + 1;
const UNREACHABLE: u8 = u8::MAX;
const ORIGIN: u8 = u8::MAX - 1;

pub const Q29_MOD9_LIFT_WORKSPACE_BYTES: usize = Q29_MOD9_ROWS * PREDECESSOR_LEN
    + Q29_MOD9_ROWS * PREDECESSOR_LEN * core::mem::size_of::<u64>()
    + Q29_MOD9_ROWS * ENERGY_VALUES * core::mem::size_of::<bool>()
    + OUTER_LAYERS * ENERGY_VALUES * core::mem::size_of::<u16>()
    + OUTER_LAYERS * ENERGY_VALUES * core::mem::size_of::<u128>()
    + Q29_MOD9_ROWS * Q29_MOD9_COLUMNS
    + Q29_MOD9_ROWS
    + 1;
pub const Q29_MOD9_LIFT_PROVENANCE: &str =
    "ExactComputational: canonical mod9 residues; bounded integer row DP; direct sum/energy/congruence replay";

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Q29Mod9LiftError {
    NoncanonicalResidue,
    InternalReplayFailure,
    UncompiledFibre,
}

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29Mod9LiftWitness {
    pub rows: [[i8; Q29_MOD9_COLUMNS]; Q29_MOD9_ROWS],
    pub row_energies: [u16; Q29_MOD9_ROWS],
    pub _pad: [u8; 4],
}

impl Q29Mod9LiftWitness {
    pub const ZERO: Self = Self {
        rows: [[0; Q29_MOD9_COLUMNS]; Q29_MOD9_ROWS],
        row_energies: [0; Q29_MOD9_ROWS],
        _pad: [0; 4],
    };
}

const _: () = assert!(core::mem::size_of::<Q29Mod9LiftWitness>() == 128);
const _: () = assert!(core::mem::align_of::<Q29Mod9LiftWitness>() == 64);

#[repr(C, align(16))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29Mod9LiftCount {
    pub count: u128,
    pub saturated: bool,
    pub _pad: [u8; 15],
}

const _: () = assert!(core::mem::size_of::<Q29Mod9LiftCount>() == 32);
const _: () = assert!(core::mem::align_of::<Q29Mod9LiftCount>() == 16);

/// Cold owner of all solve storage.  The boxed predecessor and path-count
/// arrays are allocated at setup and never grown.
pub struct Q29Mod9LiftWorkspace {
    predecessors: Box<[u8]>,
    path_counts: Box<[u64]>,
    row_energy_reachable: [[bool; ENERGY_VALUES]; Q29_MOD9_ROWS],
    outer_energy_choice: [[u16; ENERGY_VALUES]; OUTER_LAYERS],
    outer_suffix_counts: [[u128; ENERGY_VALUES]; OUTER_LAYERS],
    compiled_residues: [[u8; Q29_MOD9_COLUMNS]; Q29_MOD9_ROWS],
    target_lift_indices: [u8; Q29_MOD9_ROWS],
    fibre_compiled: bool,
}

impl Q29Mod9LiftWorkspace {
    #[must_use]
    pub fn new() -> Self {
        Self {
            predecessors: vec![UNREACHABLE; Q29_MOD9_ROWS * PREDECESSOR_LEN].into_boxed_slice(),
            path_counts: vec![0_u64; Q29_MOD9_ROWS * PREDECESSOR_LEN].into_boxed_slice(),
            row_energy_reachable: [[false; ENERGY_VALUES]; Q29_MOD9_ROWS],
            outer_energy_choice: [[u16::MAX; ENERGY_VALUES]; OUTER_LAYERS],
            outer_suffix_counts: [[0; ENERGY_VALUES]; OUTER_LAYERS],
            compiled_residues: [[0; Q29_MOD9_COLUMNS]; Q29_MOD9_ROWS],
            target_lift_indices: [0; Q29_MOD9_ROWS],
            fibre_compiled: false,
        }
    }

    #[must_use]
    pub const fn workspace_bytes(&self) -> usize {
        Q29_MOD9_LIFT_WORKSPACE_BYTES
    }
}

impl Default for Q29Mod9LiftWorkspace {
    fn default() -> Self {
        Self::new()
    }
}

/// Return one exact bounded integer lift, or `None` when this supplied residue
/// shell has none.  A miss covers exactly this shell and nothing else.
pub fn solve_q29_mod9_lift(
    residues: &[[u8; Q29_MOD9_COLUMNS]; Q29_MOD9_ROWS],
    workspace: &mut Q29Mod9LiftWorkspace,
) -> Result<Option<Q29Mod9LiftWitness>, Q29Mod9LiftError> {
    for row in residues {
        for &residue in row {
            if residue >= 9 {
                return Err(Q29Mod9LiftError::NoncanonicalResidue);
            }
        }
    }

    let mut target_lift_indices = [0_u8; Q29_MOD9_ROWS];
    for row in 0..Q29_MOD9_ROWS {
        let Some(target_lift_index) = target_lift_index(&residues[row], i16::from(row == 0)) else {
            return Ok(None);
        };
        target_lift_indices[row] = target_lift_index as u8;
        let start = row * PREDECESSOR_LEN;
        let predecessors = &mut workspace.predecessors[start..start + PREDECESSOR_LEN];
        compile_row(&residues[row], predecessors);
        for energy in 0..ENERGY_VALUES {
            workspace.row_energy_reachable[row][energy] =
                row_state_reachable(predecessors, Q29_MOD9_COLUMNS, target_lift_index, energy);
        }
    }

    workspace
        .outer_energy_choice
        .fill([u16::MAX; ENERGY_VALUES]);
    workspace.outer_energy_choice[0][0] = 0;
    for row in 0..Q29_MOD9_ROWS {
        for previous in 0..=Q29_MOD9_TOTAL_ENERGY {
            if workspace.outer_energy_choice[row][previous] == u16::MAX {
                continue;
            }
            for energy in 0..=(Q29_MOD9_TOTAL_ENERGY - previous) {
                if workspace.row_energy_reachable[row][energy]
                    && workspace.outer_energy_choice[row + 1][previous + energy] == u16::MAX
                {
                    workspace.outer_energy_choice[row + 1][previous + energy] = energy as u16;
                }
            }
        }
    }
    if workspace.outer_energy_choice[Q29_MOD9_ROWS][Q29_MOD9_TOTAL_ENERGY] == u16::MAX {
        return Ok(None);
    }

    let mut row_energies = [0_u16; Q29_MOD9_ROWS];
    let mut remaining = Q29_MOD9_TOTAL_ENERGY;
    for row in (0..Q29_MOD9_ROWS).rev() {
        let energy = workspace.outer_energy_choice[row + 1][remaining];
        row_energies[row] = energy;
        remaining -= usize::from(energy);
    }
    let mut witness = Q29Mod9LiftWitness {
        rows: [[0; Q29_MOD9_COLUMNS]; Q29_MOD9_ROWS],
        row_energies,
        _pad: [0; 4],
    };
    for row in 0..Q29_MOD9_ROWS {
        let start = row * PREDECESSOR_LEN;
        reconstruct_row(
            &residues[row],
            usize::from(target_lift_indices[row]),
            usize::from(row_energies[row]),
            &workspace.predecessors[start..start + PREDECESSOR_LEN],
            &mut witness.rows[row],
        )?;
    }
    if !replay_q29_mod9_lift(residues, &witness) {
        return Err(Q29Mod9LiftError::InternalReplayFailure);
    }
    Ok(Some(witness))
}

/// Compile exact per-row path counts and a saturating four-row suffix count.
/// The compiled tables are bound to the complete supplied residue shell.
pub fn compile_q29_mod9_lift_fibre(
    residues: &[[u8; Q29_MOD9_COLUMNS]; Q29_MOD9_ROWS],
    workspace: &mut Q29Mod9LiftWorkspace,
) -> Result<Q29Mod9LiftCount, Q29Mod9LiftError> {
    for row in residues {
        for &residue in row {
            if residue >= 9 {
                workspace.fibre_compiled = false;
                return Err(Q29Mod9LiftError::NoncanonicalResidue);
            }
        }
    }
    for row in 0..Q29_MOD9_ROWS {
        let Some(target) = target_lift_index(&residues[row], i16::from(row == 0)) else {
            workspace.fibre_compiled = false;
            return Ok(Q29Mod9LiftCount {
                count: 0,
                saturated: false,
                _pad: [0; 15],
            });
        };
        workspace.target_lift_indices[row] = target as u8;
        let start = row * PREDECESSOR_LEN;
        compile_row_counts(
            &residues[row],
            &mut workspace.path_counts[start..start + PREDECESSOR_LEN],
        );
    }

    workspace.outer_suffix_counts.fill([0; ENERGY_VALUES]);
    workspace.outer_suffix_counts[Q29_MOD9_ROWS][0] = 1;
    let mut saturated = false;
    for row in (0..Q29_MOD9_ROWS).rev() {
        let start = row * PREDECESSOR_LEN;
        let counts = &workspace.path_counts[start..start + PREDECESSOR_LEN];
        let target = usize::from(workspace.target_lift_indices[row]);
        for remaining in 0..ENERGY_VALUES {
            let mut ways = 0_u128;
            for energy in 0..=remaining {
                let row_ways = u128::from(counts[layer_index(Q29_MOD9_COLUMNS, target, energy)]);
                if row_ways == 0 {
                    continue;
                }
                let product = match row_ways
                    .checked_mul(workspace.outer_suffix_counts[row + 1][remaining - energy])
                {
                    Some(product) => product,
                    None => {
                        saturated = true;
                        u128::MAX
                    }
                };
                ways = match ways.checked_add(product) {
                    Some(next) => next,
                    None => {
                        saturated = true;
                        u128::MAX
                    }
                };
            }
            workspace.outer_suffix_counts[row][remaining] = ways;
        }
    }
    workspace.compiled_residues = *residues;
    workspace.fibre_compiled = true;
    Ok(Q29Mod9LiftCount {
        count: workspace.outer_suffix_counts[0][Q29_MOD9_TOTAL_ENERGY],
        saturated,
        _pad: [0; 15],
    })
}

/// Sample distinct lifts from one compiled fibre.  The caller supplies both
/// RNG state and fixed output storage.  Sampling never recompiles a row and
/// performs no allocation.  The return value may be smaller than the output
/// length only when the fibre is smaller or the bounded deduplication budget
/// is exhausted.
pub fn sample_distinct_q29_mod9_lifts(
    residues: &[[u8; Q29_MOD9_COLUMNS]; Q29_MOD9_ROWS],
    workspace: &Q29Mod9LiftWorkspace,
    random: &mut u64,
    output: &mut [Q29Mod9LiftWitness],
) -> Result<usize, Q29Mod9LiftError> {
    if !workspace.fibre_compiled || workspace.compiled_residues != *residues {
        return Err(Q29Mod9LiftError::UncompiledFibre);
    }
    let count = workspace.outer_suffix_counts[0][Q29_MOD9_TOTAL_ENERGY];
    if count == 0 || output.is_empty() {
        return Ok(0);
    }
    let target = if count <= usize::MAX as u128 {
        output.len().min(count as usize)
    } else {
        output.len()
    };
    let attempt_limit = target.saturating_mul(64).saturating_add(64);
    let mut produced = 0_usize;
    for _ in 0..attempt_limit {
        if produced == target {
            break;
        }
        let witness = sample_one_lift(workspace, random)?;
        if !replay_q29_mod9_lift(residues, &witness) {
            return Err(Q29Mod9LiftError::InternalReplayFailure);
        }
        if output[..produced]
            .iter()
            .any(|prior| prior.rows == witness.rows)
        {
            continue;
        }
        output[produced] = witness;
        produced += 1;
    }
    Ok(produced)
}

fn sample_one_lift(
    workspace: &Q29Mod9LiftWorkspace,
    random: &mut u64,
) -> Result<Q29Mod9LiftWitness, Q29Mod9LiftError> {
    let mut witness = Q29Mod9LiftWitness::ZERO;
    let mut remaining = Q29_MOD9_TOTAL_ENERGY;
    for row in 0..Q29_MOD9_ROWS {
        let start = row * PREDECESSOR_LEN;
        let counts = &workspace.path_counts[start..start + PREDECESSOR_LEN];
        let target = usize::from(workspace.target_lift_indices[row]);
        let mut rank = sample_below_u128(random, workspace.outer_suffix_counts[row][remaining]);
        let mut selected_energy = None;
        for energy in 0..=remaining {
            let row_ways = u128::from(counts[layer_index(Q29_MOD9_COLUMNS, target, energy)]);
            let contribution =
                row_ways.saturating_mul(workspace.outer_suffix_counts[row + 1][remaining - energy]);
            if rank < contribution {
                selected_energy = Some(energy);
                break;
            }
            rank -= contribution;
        }
        let energy = selected_energy.ok_or(Q29Mod9LiftError::InternalReplayFailure)?;
        witness.row_energies[row] = energy as u16;
        sample_row_path(
            &workspace.compiled_residues[row],
            target,
            energy,
            counts,
            random,
            &mut witness.rows[row],
        )?;
        remaining -= energy;
    }
    if remaining != 0 {
        return Err(Q29Mod9LiftError::InternalReplayFailure);
    }
    Ok(witness)
}

#[must_use]
pub fn replay_q29_mod9_lift(
    residues: &[[u8; Q29_MOD9_COLUMNS]; Q29_MOD9_ROWS],
    witness: &Q29Mod9LiftWitness,
) -> bool {
    let mut combined_energy = 0_i32;
    for row in 0..Q29_MOD9_ROWS {
        let mut sum = 0_i32;
        let mut energy = 0_i32;
        for column in 0..Q29_MOD9_COLUMNS {
            let value = witness.rows[row][column];
            if !(-9..=9).contains(&value) || value.rem_euclid(9) as u8 != residues[row][column] {
                return false;
            }
            sum += i32::from(value);
            energy += i32::from(value) * i32::from(value);
        }
        if sum != i32::from(row == 0) || energy != i32::from(witness.row_energies[row]) {
            return false;
        }
        combined_energy += energy;
    }
    combined_energy == Q29_MOD9_TOTAL_ENERGY as i32
}

fn state_index(lift_index: usize, energy: usize) -> usize {
    lift_index * ENERGY_VALUES + energy
}

fn layer_index(layer: usize, lift_index: usize, energy: usize) -> usize {
    layer * ROW_STATE_COUNT + state_index(lift_index, energy)
}

fn target_lift_index(residues: &[u8; Q29_MOD9_COLUMNS], target: i16) -> Option<usize> {
    let mut base_sum = 0_i16;
    for &residue in residues {
        base_sum += if residue == 0 {
            -9
        } else {
            i16::from(residue) - 9
        };
    }
    let difference = target - base_sum;
    if difference < 0 || difference % 9 != 0 {
        return None;
    }
    let lift_index = usize::try_from(difference / 9).ok()?;
    (lift_index <= MAX_LIFT_INDEX).then_some(lift_index)
}

fn residue_lifts(residue: u8) -> ([i8; 3], usize) {
    if residue == 0 {
        ([-9, 0, 9], 3)
    } else {
        ([residue as i8 - 9, residue as i8, 0], 2)
    }
}

fn compile_row(residues: &[u8; Q29_MOD9_COLUMNS], predecessors: &mut [u8]) {
    predecessors.fill(UNREACHABLE);
    predecessors[layer_index(0, 0, 0)] = ORIGIN;
    for column in 0..Q29_MOD9_COLUMNS {
        let (choices, choice_count) = residue_lifts(residues[column]);
        let lift_index_bound = (2 * column).min(MAX_LIFT_INDEX);
        let energy_bound = (81 * column).min(Q29_MOD9_TOTAL_ENERGY);
        for lift_index in 0..=lift_index_bound {
            for energy in 0..=energy_bound {
                if predecessors[layer_index(column, lift_index, energy)] == UNREACHABLE {
                    continue;
                }
                for (choice, &value) in choices[..choice_count].iter().enumerate() {
                    let next_lift_index = lift_index + choice;
                    let next_energy = energy + usize::from(value.unsigned_abs()).pow(2);
                    if next_lift_index <= MAX_LIFT_INDEX && next_energy <= Q29_MOD9_TOTAL_ENERGY {
                        let index = layer_index(column + 1, next_lift_index, next_energy);
                        if predecessors[index] == UNREACHABLE {
                            predecessors[index] = choice as u8;
                        }
                    }
                }
            }
        }
    }
}

fn compile_row_counts(residues: &[u8; Q29_MOD9_COLUMNS], counts: &mut [u64]) {
    counts.fill(0);
    counts[layer_index(0, 0, 0)] = 1;
    for column in 0..Q29_MOD9_COLUMNS {
        let (choices, choice_count) = residue_lifts(residues[column]);
        let lift_index_bound = (2 * column).min(MAX_LIFT_INDEX);
        let energy_bound = (81 * column).min(Q29_MOD9_TOTAL_ENERGY);
        for lift_index in 0..=lift_index_bound {
            for energy in 0..=energy_bound {
                let paths = counts[layer_index(column, lift_index, energy)];
                if paths == 0 {
                    continue;
                }
                for (choice, &value) in choices[..choice_count].iter().enumerate() {
                    let next_lift_index = lift_index + choice;
                    let next_energy = energy + usize::from(value.unsigned_abs()).pow(2);
                    if next_lift_index <= MAX_LIFT_INDEX && next_energy <= Q29_MOD9_TOTAL_ENERGY {
                        let index = layer_index(column + 1, next_lift_index, next_energy);
                        counts[index] = counts[index].saturating_add(paths);
                    }
                }
            }
        }
    }
}

fn sample_row_path(
    residues: &[u8; Q29_MOD9_COLUMNS],
    mut lift_index: usize,
    mut energy: usize,
    counts: &[u64],
    random: &mut u64,
    output: &mut [i8; Q29_MOD9_COLUMNS],
) -> Result<(), Q29Mod9LiftError> {
    let final_count = counts[layer_index(Q29_MOD9_COLUMNS, lift_index, energy)];
    if final_count == 0 {
        return Err(Q29Mod9LiftError::InternalReplayFailure);
    }
    let mut rank = sample_below_u128(random, u128::from(final_count)) as u64;
    for column in (0..Q29_MOD9_COLUMNS).rev() {
        let (choices, choice_count) = residue_lifts(residues[column]);
        let mut selected = None;
        for (choice, &value) in choices[..choice_count].iter().enumerate() {
            let value_energy = usize::from(value.unsigned_abs()).pow(2);
            if lift_index < choice || energy < value_energy {
                continue;
            }
            let paths = counts[layer_index(column, lift_index - choice, energy - value_energy)];
            if rank < paths {
                selected = Some((choice, value, value_energy));
                break;
            }
            rank -= paths;
        }
        let (choice, value, value_energy) =
            selected.ok_or(Q29Mod9LiftError::InternalReplayFailure)?;
        output[column] = value;
        lift_index -= choice;
        energy -= value_energy;
    }
    if lift_index != 0 || energy != 0 {
        return Err(Q29Mod9LiftError::InternalReplayFailure);
    }
    Ok(())
}

#[inline(always)]
fn next_random(random: &mut u64) -> u64 {
    *random ^= *random << 13;
    *random ^= *random >> 7;
    *random ^= *random << 17;
    *random
}

fn sample_below_u128(random: &mut u64, bound: u128) -> u128 {
    debug_assert!(bound != 0);
    let zone = u128::MAX - u128::MAX % bound;
    loop {
        let value = (u128::from(next_random(random)) << 64) | u128::from(next_random(random));
        if value < zone {
            return value % bound;
        }
    }
}

fn row_state_reachable(
    predecessors: &[u8],
    layer: usize,
    lift_index: usize,
    energy: usize,
) -> bool {
    predecessors[layer_index(layer, lift_index, energy)] != UNREACHABLE
}

fn reconstruct_row(
    residues: &[u8; Q29_MOD9_COLUMNS],
    target_lift_index: usize,
    energy: usize,
    predecessors: &[u8],
    output: &mut [i8; Q29_MOD9_COLUMNS],
) -> Result<(), Q29Mod9LiftError> {
    let mut lift_index = target_lift_index;
    let mut energy = energy;
    for column in (0..Q29_MOD9_COLUMNS).rev() {
        let choice = predecessors[layer_index(column + 1, lift_index, energy)];
        let (choices, choice_count) = residue_lifts(residues[column]);
        if usize::from(choice) >= choice_count {
            return Err(Q29Mod9LiftError::InternalReplayFailure);
        }
        let value = choices[usize::from(choice)];
        output[column] = value;
        lift_index -= usize::from(choice);
        energy -= usize::from(value.unsigned_abs()).pow(2);
    }
    if lift_index != 0 || energy != 0 {
        return Err(Q29Mod9LiftError::InternalReplayFailure);
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;
    use std::collections::BTreeMap;

    fn seed_rows() -> [[i8; Q29_MOD9_COLUMNS]; Q29_MOD9_ROWS] {
        let inventories: [[(usize, i8); 6]; 4] = [
            [(13, 2), (13, -2), (1, 3), (1, -3), (1, 1), (0, -1)],
            [(13, 2), (12, -2), (1, 3), (2, -3), (1, 1), (0, -1)],
            [(13, 2), (12, -2), (1, 3), (2, -3), (1, 1), (0, -1)],
            [(12, 2), (15, -2), (2, 3), (0, -3), (0, 1), (0, -1)],
        ];
        let mut rows = [[0_i8; Q29_MOD9_COLUMNS]; Q29_MOD9_ROWS];
        for row in 0..4 {
            let mut cursor = 0;
            for &(count, value) in &inventories[row] {
                for _ in 0..count {
                    rows[row][cursor] = value;
                    cursor += 1;
                }
            }
        }
        rows
    }

    fn multiple_lift_rows() -> [[i8; Q29_MOD9_COLUMNS]; Q29_MOD9_ROWS] {
        let mut rows = seed_rows();
        rows[0].fill(0);
        rows[0][0] = 1;
        rows[0][1] = -8;
        rows[0][2..10].fill(1);
        rows[0][10] = 5;
        rows[0][11] = -5;
        assert_eq!(
            rows[0].iter().map(|&value| i32::from(value)).sum::<i32>(),
            1
        );
        assert_eq!(
            rows[0]
                .iter()
                .map(|&value| i32::from(value) * i32::from(value))
                .sum::<i32>(),
            123
        );
        rows
    }

    #[test]
    fn known_shell_lifts_and_replays() {
        let rows = multiple_lift_rows();
        let residues = rows.map(|row| row.map(|value| value.rem_euclid(9) as u8));
        let mut workspace = Q29Mod9LiftWorkspace::new();
        assert_eq!(workspace.workspace_bytes(), 32_290_005);
        let witness = solve_q29_mod9_lift(&residues, &mut workspace)
            .unwrap()
            .unwrap();
        assert!(replay_q29_mod9_lift(&residues, &witness));
    }

    #[test]
    fn malformed_residue_fails_closed() {
        let mut residues = [[0_u8; Q29_MOD9_COLUMNS]; Q29_MOD9_ROWS];
        residues[2][17] = 9;
        let mut workspace = Q29Mod9LiftWorkspace::new();
        assert_eq!(
            solve_q29_mod9_lift(&residues, &mut workspace),
            Err(Q29Mod9LiftError::NoncanonicalResidue)
        );
    }

    #[test]
    fn repeated_solve_allocates_nothing() {
        let rows = seed_rows();
        let residues = rows.map(|row| row.map(|value| value.rem_euclid(9) as u8));
        let mut workspace = Q29Mod9LiftWorkspace::new();
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..2 {
                assert!(solve_q29_mod9_lift(&residues, &mut workspace)
                    .unwrap()
                    .is_some());
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn counted_fibre_samples_distinct_replayed_lifts_without_recompile_or_allocation() {
        let rows = multiple_lift_rows();
        let residues = rows.map(|row| row.map(|value| value.rem_euclid(9) as u8));
        let mut workspace = Q29Mod9LiftWorkspace::new();
        let count = compile_q29_mod9_lift_fibre(&residues, &mut workspace).unwrap();
        assert!(count.count >= 2, "{count:?}");
        let mut output = [Q29Mod9LiftWitness::ZERO; 2];
        let mut random = 0x9e37_79b9_7f4a_7c15;
        let (produced, allocations) = tracked_allocations(|| {
            sample_distinct_q29_mod9_lifts(&residues, &workspace, &mut random, &mut output).unwrap()
        });
        assert_eq!(allocations, 0);
        assert_eq!(produced, 2);
        for index in 0..produced {
            assert!(replay_q29_mod9_lift(&residues, &output[index]));
            assert!(output[..index]
                .iter()
                .all(|prior| prior.rows != output[index].rows));
        }
        let mut forged = residues;
        forged[0][0] = (forged[0][0] + 1) % 9;
        assert_eq!(
            sample_distinct_q29_mod9_lifts(&forged, &workspace, &mut random, &mut output,),
            Err(Q29Mod9LiftError::UncompiledFibre)
        );
    }

    #[test]
    fn small_dp_matches_exhaustive_mixed_radix_oracle() {
        for length in 1..=4 {
            let shell_count = 9_usize.pow(length as u32);
            for encoded_shell in 0..shell_count {
                let mut encoded_shell = encoded_shell;
                let mut residues = [0_u8; 4];
                for residue in &mut residues[..length] {
                    *residue = (encoded_shell % 9) as u8;
                    encoded_shell /= 9;
                }
                let mut oracle = BTreeMap::new();
                let mut radix_limit = 1_usize;
                for &residue in &residues[..length] {
                    radix_limit *= residue_lifts(residue).1;
                }
                for encoded_choices in 0..radix_limit {
                    let mut encoded_choices = encoded_choices;
                    let mut sum = 0_i16;
                    let mut energy = 0_u16;
                    for &residue in &residues[..length] {
                        let (choices, count) = residue_lifts(residue);
                        let value = choices[encoded_choices % count];
                        encoded_choices /= count;
                        sum += i16::from(value);
                        energy += u16::from(value.unsigned_abs()).pow(2);
                    }
                    *oracle.entry((sum, energy)).or_insert(0_u64) += 1;
                }
                let base_sum = residues[..length].iter().fold(0_i16, |sum, &residue| {
                    sum + if residue == 0 {
                        -9
                    } else {
                        i16::from(residue) - 9
                    }
                });
                let mut affine_dp = BTreeMap::from([((0_u8, 0_u16), 1_u64)]);
                for &residue in &residues[..length] {
                    let (choices, count) = residue_lifts(residue);
                    let mut next = BTreeMap::new();
                    for (&(lift_index, energy), &paths) in &affine_dp {
                        for (choice, &value) in choices[..count].iter().enumerate() {
                            *next
                                .entry((
                                    lift_index + choice as u8,
                                    energy + u16::from(value.unsigned_abs()).pow(2),
                                ))
                                .or_insert(0_u64) += paths;
                        }
                    }
                    affine_dp = next;
                }
                let affine_signed = affine_dp
                    .into_iter()
                    .map(|((lift_index, energy), paths)| {
                        ((base_sum + 9 * i16::from(lift_index), energy), paths)
                    })
                    .collect::<BTreeMap<_, _>>();
                assert_eq!(affine_signed, oracle);
            }
        }
    }
}
