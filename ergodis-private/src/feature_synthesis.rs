//! Domain-neutral bounded feature synthesis over paired integer observations.
//!
//! Successful expressions are compact reusable terminals for later searches;
//! callers provide only typed observations and targets, never theorem names.

use serde::{Deserialize, Serialize};

#[repr(transparent)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct ResidualTuple<T, const N: usize>([T; N]);

impl<T, const N: usize> ResidualTuple<T, N> {
    pub const fn from_array(values: [T; N]) -> Self {
        Self(values)
    }

    pub const fn as_array(&self) -> &[T; N] {
        &self.0
    }
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub enum FeatureOrigin {
    Evolved,
    HumanFed,
    TheoremDerived,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct AffineModularSeparator {
    pub modulus: u8,
    pub first_coefficient: i8,
    pub second_coefficient: i8,
    pub left_residues: u64,
    pub complemented_right_residues: u64,
    pub candidates_tested: u32,
    pub origin: FeatureOrigin,
    pub blindness_level: u8,
}

pub const MAX_SCOPES: usize = 128;

#[derive(Clone, Copy, Debug)]
pub struct PairedPointScope<'a> {
    pub left: &'a [[i32; 2]],
    pub right: &'a [[i32; 2]],
    pub target: [i32; 2],
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct ScopedAffineFeature {
    pub modulus: u8,
    pub first_coefficient: i8,
    pub second_coefficient: i8,
    pub scope_words: [u64; 2],
    pub scoped_instances: u8,
    pub newly_covered_instances: u8,
    pub candidates_tested: u32,
    pub origin: FeatureOrigin,
    pub blindness_level: u8,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct FourSetAffineObstruction {
    pub coordinates: [u8; 2],
    pub coefficients: [i8; 2],
    pub modulus: u8,
    pub residue_masks: [u64; 4],
    pub candidates_tested: u32,
    pub sampled_rejections: u32,
    pub exact_checks: u32,
    pub origin: FeatureOrigin,
    pub blindness_level: u8,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct FourSetConditionedCoordinateObstruction {
    pub coordinate: u8,
    pub terminal_target: u32,
    pub coordinate_target: u32,
    pub exact_rows: [u32; 4],
    pub candidates_tested: u8,
    pub origin: FeatureOrigin,
    pub blindness_level: u8,
}

pub const MAX_AFFINE_HULL_FIELDS: usize = 16;

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct FourSetAffineHullObstruction {
    pub modulus: u8,
    pub fields: u8,
    pub coefficients: [u8; MAX_AFFINE_HULL_FIELDS],
    pub target_residue: u8,
    pub attainable_residue: u8,
    pub rank: u8,
    pub rows_scanned: u64,
    pub candidates_tested: u8,
    pub origin: FeatureOrigin,
    pub blindness_level: u8,
}

#[inline(always)]
fn is_prime(value: u8) -> bool {
    value >= 2 && (2..value).all(|divisor| value % divisor != 0)
}

#[inline(always)]
fn inverse_mod(value: u8, modulus: u8) -> u8 {
    (1..modulus)
        .find(|&candidate| u16::from(value) * u16::from(candidate) % u16::from(modulus) == 1)
        .unwrap()
}

fn insert_modular_basis<const FIELDS: usize>(
    basis: &mut [[u8; FIELDS]; FIELDS],
    pivots: &mut [u8; FIELDS],
    rank: &mut usize,
    mut vector: [u8; FIELDS],
    modulus: u8,
) {
    for row in 0..*rank {
        let pivot = usize::from(pivots[row]);
        let factor = vector[pivot];
        if factor != 0 {
            for coordinate in 0..FIELDS {
                vector[coordinate] = (u16::from(vector[coordinate]) + u16::from(modulus)
                    - u16::from(factor) * u16::from(basis[row][coordinate]) % u16::from(modulus))
                    as u8
                    % modulus;
            }
        }
    }
    let Some(pivot) = vector.iter().position(|&entry| entry != 0) else {
        return;
    };
    let inverse = inverse_mod(vector[pivot], modulus);
    for entry in &mut vector {
        *entry = (u16::from(*entry) * u16::from(inverse) % u16::from(modulus)) as u8;
    }
    for row in 0..*rank {
        let factor = basis[row][pivot];
        if factor != 0 {
            for coordinate in 0..FIELDS {
                basis[row][coordinate] = (u16::from(basis[row][coordinate]) + u16::from(modulus)
                    - u16::from(factor) * u16::from(vector[coordinate]) % u16::from(modulus))
                    as u8
                    % modulus;
            }
        }
    }
    basis[*rank] = vector;
    pivots[*rank] = pivot as u8;
    *rank += 1;
}

/// Blindly search prime moduli for a full-coordinate affine-hull obstruction.
/// For each modulus this computes the exact affine span of all four supplied
/// sets, then emits a separating linear functional only when the target lies
/// outside that span. The bounded candidate loop allocates nothing.
pub fn synthesize_four_set_affine_hull_obstruction<const FIELDS: usize, T: Copy>(
    sets: [&[T]; 4],
    targets: &[i64; FIELDS],
    value: impl Fn(T, usize) -> i64,
    maximum_modulus: u8,
    blindness_level: u8,
) -> Option<FourSetAffineHullObstruction> {
    if FIELDS == 0
        || FIELDS > MAX_AFFINE_HULL_FIELDS
        || sets.iter().any(|set| set.is_empty())
        || maximum_modulus < 2
    {
        return None;
    }
    let mut candidates_tested = 0_u8;
    for modulus in 2..=maximum_modulus {
        if !is_prime(modulus) {
            continue;
        }
        candidates_tested = candidates_tested.saturating_add(1);
        let modulus_i64 = i64::from(modulus);
        let mut basis = [[0_u8; FIELDS]; FIELDS];
        let mut pivots = [0_u8; FIELDS];
        let mut rank = 0_usize;
        let mut base_sum = [0_u8; FIELDS];
        let mut rows_scanned = 0_u64;
        for block in 0..4 {
            let base: [u8; FIELDS] = std::array::from_fn(|coordinate| {
                value(sets[block][0], coordinate).rem_euclid(modulus_i64) as u8
            });
            for coordinate in 0..FIELDS {
                base_sum[coordinate] = (base_sum[coordinate] + base[coordinate]) % modulus;
            }
            for &row in sets[block] {
                rows_scanned = rows_scanned.saturating_add(1);
                let difference = std::array::from_fn(|coordinate| {
                    (value(row, coordinate) - i64::from(base[coordinate])).rem_euclid(modulus_i64)
                        as u8
                });
                insert_modular_basis(&mut basis, &mut pivots, &mut rank, difference, modulus);
                if rank == FIELDS {
                    break;
                }
            }
            if rank == FIELDS {
                break;
            }
        }
        if rank == FIELDS {
            continue;
        }
        let mut target_difference: [u8; FIELDS] = std::array::from_fn(|coordinate| {
            (targets[coordinate] - i64::from(base_sum[coordinate])).rem_euclid(modulus_i64) as u8
        });
        for row in 0..rank {
            let pivot = usize::from(pivots[row]);
            let factor = target_difference[pivot];
            if factor != 0 {
                for coordinate in 0..FIELDS {
                    target_difference[coordinate] =
                        (u16::from(target_difference[coordinate]) + u16::from(modulus)
                            - u16::from(factor) * u16::from(basis[row][coordinate])
                                % u16::from(modulus)) as u8
                            % modulus;
                }
            }
        }
        if target_difference.iter().all(|&entry| entry == 0) {
            continue;
        }
        let mut pivot_columns = [false; FIELDS];
        for &pivot in &pivots[..rank] {
            pivot_columns[usize::from(pivot)] = true;
        }
        for free in 0..FIELDS {
            if pivot_columns[free] {
                continue;
            }
            let mut functional = [0_u8; FIELDS];
            functional[free] = 1;
            for row in 0..rank {
                let pivot = usize::from(pivots[row]);
                functional[pivot] = (modulus - basis[row][free]) % modulus;
            }
            let target_residue = (0..FIELDS).fold(0_u16, |sum, coordinate| {
                (sum + u16::from(functional[coordinate])
                    * u16::from(targets[coordinate].rem_euclid(modulus_i64) as u8))
                    % u16::from(modulus)
            }) as u8;
            let attainable_residue = (0..FIELDS).fold(0_u16, |sum, coordinate| {
                (sum + u16::from(functional[coordinate]) * u16::from(base_sum[coordinate]))
                    % u16::from(modulus)
            }) as u8;
            if target_residue != attainable_residue {
                let mut coefficients = [0_u8; MAX_AFFINE_HULL_FIELDS];
                coefficients[..FIELDS].copy_from_slice(&functional);
                return Some(FourSetAffineHullObstruction {
                    modulus,
                    fields: FIELDS as u8,
                    coefficients,
                    target_residue,
                    attainable_residue,
                    rank: rank as u8,
                    rows_scanned,
                    candidates_tested,
                    origin: FeatureOrigin::Evolved,
                    blindness_level,
                });
            }
        }
    }
    None
}

/// Reusable bounded workspace for exact four-set joins in two nonnegative
/// terminals. Construction is cold; repeated synthesis calls allocate
/// nothing. The first terminal may be an earlier evolved or theorem-derived
/// feature, while the second is selected blindly from anonymous coordinates.
pub struct FourSetConditionedWorkspace {
    terminal_maximum: usize,
    coordinate_maximum: usize,
    coordinate_words: usize,
    fields: usize,
    observations: Vec<u64>,
    terminal_values: [Vec<u32>; 4],
    pair_sums: [Vec<u64>; 2],
}

impl FourSetConditionedWorkspace {
    pub fn new(fields: usize, terminal_maximum: usize, coordinate_maximum: usize) -> Option<Self> {
        if fields == 0 || fields > u8::MAX as usize || coordinate_maximum == usize::MAX {
            return None;
        }
        let coordinate_words = (coordinate_maximum + 1).div_ceil(64);
        let observation_words = 4_usize
            .checked_mul(fields)?
            .checked_mul(terminal_maximum.checked_add(1)?)?
            .checked_mul(coordinate_words)?;
        let pair_words = terminal_maximum
            .checked_add(1)?
            .checked_mul(coordinate_words)?;
        Some(Self {
            terminal_maximum,
            coordinate_maximum,
            coordinate_words,
            fields,
            observations: vec![0; observation_words],
            terminal_values: std::array::from_fn(|_| Vec::with_capacity(terminal_maximum + 1)),
            pair_sums: std::array::from_fn(|_| vec![0; pair_words]),
        })
    }

    #[inline(always)]
    fn observation_offset(&self, block: usize, field: usize, terminal: usize) -> usize {
        (((block * self.fields + field) * (self.terminal_maximum + 1)) + terminal)
            * self.coordinate_words
    }

    fn compile_observations<const FIELDS: usize, T: Copy>(
        &mut self,
        sets: [&[T]; 4],
        terminal: &impl Fn(T) -> u32,
        value: &impl Fn(T, usize) -> u32,
    ) -> Option<[u32; 4]> {
        if FIELDS != self.fields || sets.iter().any(|set| set.is_empty()) {
            return None;
        }
        self.observations.fill(0);
        for values in &mut self.terminal_values {
            values.clear();
        }
        let mut exact_rows = [0_u32; 4];
        for block in 0..4 {
            exact_rows[block] = sets[block].len().try_into().ok()?;
            for &row in sets[block] {
                let terminal = terminal(row) as usize;
                if terminal > self.terminal_maximum {
                    continue;
                }
                for field in 0..FIELDS {
                    let coordinate = value(row, field) as usize;
                    if coordinate <= self.coordinate_maximum {
                        let offset = self.observation_offset(block, field, terminal);
                        self.observations[offset + coordinate / 64] |= 1_u64 << (coordinate % 64);
                    }
                }
            }
            for terminal_value in 0..=self.terminal_maximum {
                let present = (0..FIELDS).any(|field| {
                    let offset = self.observation_offset(block, field, terminal_value);
                    self.observations[offset..offset + self.coordinate_words]
                        .iter()
                        .any(|&word| word != 0)
                });
                if present {
                    self.terminal_values[block].push(terminal_value as u32);
                }
            }
        }
        Some(exact_rows)
    }

    #[inline(always)]
    fn add_coordinate_sum(
        output: &mut [u64],
        output_offset: usize,
        first: &[u64],
        second: &[u64],
        coordinate_maximum: usize,
    ) {
        for (word_index, &word) in first.iter().enumerate() {
            let mut values = word;
            while values != 0 {
                let bit = values.trailing_zeros() as usize;
                values &= values - 1;
                let shift = word_index * 64 + bit;
                if shift > coordinate_maximum {
                    continue;
                }
                let word_shift = shift / 64;
                let bit_shift = shift % 64;
                for (source_word, &bits) in second.iter().enumerate() {
                    let destination = output_offset + word_shift + source_word;
                    if destination < output_offset + first.len() {
                        output[destination] |= bits << bit_shift;
                    }
                    if bit_shift != 0 && destination + 1 < output_offset + first.len() {
                        output[destination + 1] |= bits >> (64 - bit_shift);
                    }
                }
            }
        }
        let excess = first.len() * 64 - (coordinate_maximum + 1);
        if excess != 0 {
            output[output_offset + first.len() - 1] &= u64::MAX >> excess;
        }
    }

    fn compile_pair_sums(
        &mut self,
        field: usize,
        first_block: usize,
        second_block: usize,
        side: usize,
    ) {
        self.pair_sums[side].fill(0);
        for first_index in 0..self.terminal_values[first_block].len() {
            let first_terminal = self.terminal_values[first_block][first_index] as usize;
            for second_index in 0..self.terminal_values[second_block].len() {
                let second_terminal = self.terminal_values[second_block][second_index] as usize;
                let terminal_sum = first_terminal + second_terminal;
                if terminal_sum > self.terminal_maximum {
                    continue;
                }
                let first_offset = self.observation_offset(first_block, field, first_terminal);
                let second_offset = self.observation_offset(second_block, field, second_terminal);
                let output_offset = terminal_sum * self.coordinate_words;
                Self::add_coordinate_sum(
                    &mut self.pair_sums[side],
                    output_offset,
                    &self.observations[first_offset..first_offset + self.coordinate_words],
                    &self.observations[second_offset..second_offset + self.coordinate_words],
                    self.coordinate_maximum,
                );
            }
        }
    }

    fn target_reachable(&self, terminal_target: usize, coordinate_target: usize) -> bool {
        for terminal in 0..=terminal_target {
            let left_offset = terminal * self.coordinate_words;
            let right_offset = (terminal_target - terminal) * self.coordinate_words;
            for word_index in 0..self.coordinate_words {
                let mut values = self.pair_sums[0][left_offset + word_index];
                while values != 0 {
                    let bit = values.trailing_zeros() as usize;
                    values &= values - 1;
                    let coordinate = word_index * 64 + bit;
                    if coordinate <= coordinate_target {
                        let complement = coordinate_target - coordinate;
                        if self.pair_sums[1][right_offset + complement / 64]
                            & (1_u64 << (complement % 64))
                            != 0
                        {
                            return true;
                        }
                    }
                }
            }
        }
        false
    }
}

/// Try every anonymous coordinate after conditioning on an earlier
/// nonnegative terminal. A returned obstruction is exact over all supplied
/// rows; candidate selection and verification use the caller-owned workspace.
pub fn synthesize_four_set_conditioned_coordinate_obstruction<const FIELDS: usize, T: Copy>(
    workspace: &mut FourSetConditionedWorkspace,
    sets: [&[T]; 4],
    terminal_target: u32,
    coordinate_targets: &[u32; FIELDS],
    terminal: impl Fn(T) -> u32,
    value: impl Fn(T, usize) -> u32,
    blindness_level: u8,
) -> Option<FourSetConditionedCoordinateObstruction> {
    if terminal_target as usize > workspace.terminal_maximum
        || coordinate_targets
            .iter()
            .any(|&target| target as usize > workspace.coordinate_maximum)
    {
        return None;
    }
    let exact_rows = workspace.compile_observations::<FIELDS, T>(sets, &terminal, &value)?;
    for (field, &coordinate_target) in coordinate_targets.iter().enumerate() {
        workspace.compile_pair_sums(field, 0, 2, 0);
        workspace.compile_pair_sums(field, 1, 3, 1);
        if !workspace.target_reachable(terminal_target as usize, coordinate_target as usize) {
            return Some(FourSetConditionedCoordinateObstruction {
                coordinate: field as u8,
                terminal_target,
                coordinate_target,
                exact_rows,
                candidates_tested: (field + 1) as u8,
                origin: FeatureOrigin::Evolved,
                blindness_level,
            });
        }
    }
    None
}

#[inline(always)]
fn cyclic_sumset_mask(first: u64, second: u64, modulus: u8) -> u64 {
    let mut output = 0_u64;
    let mut left = first;
    while left != 0 {
        let first_value = left.trailing_zeros() as u8;
        left &= left - 1;
        let mut right = second;
        while right != 0 {
            let second_value = right.trailing_zeros() as u8;
            right &= right - 1;
            output |= 1_u64 << ((first_value + second_value) % modulus);
        }
    }
    output
}

#[inline(always)]
fn four_residue_masks_reach_target(masks: [u64; 4], target: u8, modulus: u8) -> bool {
    let left = cyclic_sumset_mask(masks[0], masks[2], modulus);
    let right = cyclic_sumset_mask(masks[1], masks[3], modulus);
    let mut sums = left;
    while sums != 0 {
        let value = sums.trailing_zeros() as u8;
        sums &= sums - 1;
        let complement = (target + modulus - value) % modulus;
        if right & (1_u64 << complement) != 0 {
            return true;
        }
    }
    false
}

/// Search anonymous fixed-width observations for a two-coordinate affine
/// modular obstruction to a four-set target sum. A bounded sample proposes
/// candidates; every returned candidate is then checked against all rows.
/// The candidate loop and exact verifier allocate nothing.
pub fn synthesize_four_set_affine_obstruction<const FIELDS: usize, T: Copy>(
    sets: [&[T]; 4],
    targets: &[i64; FIELDS],
    value: impl Fn(T, usize) -> i64,
    maximum_modulus: u8,
    maximum_coefficient: i8,
    sample_limit: usize,
    blindness_level: u8,
) -> Option<FourSetAffineObstruction> {
    if FIELDS == 0
        || FIELDS > u8::MAX as usize
        || sets.iter().any(|set| set.is_empty())
        || !(2..=64).contains(&maximum_modulus)
        || !(1..=16).contains(&maximum_coefficient)
        || sample_limit == 0
    {
        return None;
    }
    let mut candidates_tested = 0_u32;
    let mut sampled_rejections = 0_u32;
    let mut exact_checks = 0_u32;
    for complexity in 1..=2 * maximum_coefficient {
        for first_coefficient in -maximum_coefficient..=maximum_coefficient {
            for second_coefficient in -maximum_coefficient..=maximum_coefficient {
                if first_coefficient == 0 && second_coefficient == 0
                    || first_coefficient.unsigned_abs() + second_coefficient.unsigned_abs()
                        != complexity as u8
                {
                    continue;
                }
                for first_coordinate in 0..FIELDS {
                    for second_coordinate in first_coordinate + 1..FIELDS {
                        for modulus in 2..=maximum_modulus {
                            candidates_tested += 1;
                            let modulus_i64 = i64::from(modulus);
                            let target = (i64::from(first_coefficient) * targets[first_coordinate]
                                + i64::from(second_coefficient) * targets[second_coordinate])
                                .rem_euclid(modulus_i64)
                                as u8;
                            let mut sample_masks = [0_u64; 4];
                            for block in 0..4 {
                                let stride = sets[block].len().div_ceil(sample_limit).max(1);
                                for &row in sets[block].iter().step_by(stride).take(sample_limit) {
                                    let residue = (i64::from(first_coefficient)
                                        * value(row, first_coordinate)
                                        + i64::from(second_coefficient)
                                            * value(row, second_coordinate))
                                    .rem_euclid(modulus_i64)
                                        as u8;
                                    sample_masks[block] |= 1_u64 << residue;
                                }
                            }
                            if four_residue_masks_reach_target(sample_masks, target, modulus) {
                                continue;
                            }
                            sampled_rejections += 1;
                            exact_checks += 1;
                            let mut exact_masks = [0_u64; 4];
                            for block in 0..4 {
                                for &row in sets[block] {
                                    let residue = (i64::from(first_coefficient)
                                        * value(row, first_coordinate)
                                        + i64::from(second_coefficient)
                                            * value(row, second_coordinate))
                                    .rem_euclid(modulus_i64)
                                        as u8;
                                    exact_masks[block] |= 1_u64 << residue;
                                }
                            }
                            if !four_residue_masks_reach_target(exact_masks, target, modulus) {
                                return Some(FourSetAffineObstruction {
                                    coordinates: [first_coordinate as u8, second_coordinate as u8],
                                    coefficients: [first_coefficient, second_coefficient],
                                    modulus,
                                    residue_masks: exact_masks,
                                    candidates_tested,
                                    sampled_rejections,
                                    exact_checks,
                                    origin: FeatureOrigin::Evolved,
                                    blindness_level,
                                });
                            }
                        }
                    }
                }
            }
        }
    }
    None
}

#[inline(always)]
fn affine_residue(point: [i32; 2], first: i8, second: i8, modulus: i32) -> u32 {
    (i32::from(first) * point[0] + i32::from(second) * point[1]).rem_euclid(modulus) as u32
}

/// Search a bounded, theorem-neutral affine modular grammar for a separator.
///
/// The right observations are complemented against `target` before feature
/// evaluation. The repeated candidate loop is iterative and allocation-free.
pub fn synthesize_affine_modular_separator(
    left: &[[i32; 2]],
    right: &[[i32; 2]],
    target: [i32; 2],
    maximum_modulus: u8,
    maximum_coefficient: i8,
    blindness_level: u8,
) -> Option<AffineModularSeparator> {
    if left.is_empty()
        || right.is_empty()
        || !(2..=64).contains(&maximum_modulus)
        || !(1..=16).contains(&maximum_coefficient)
    {
        return None;
    }
    let mut candidates_tested = 0_u32;
    for complexity in 1..=2 * maximum_coefficient {
        for first in -maximum_coefficient..=maximum_coefficient {
            for second in -maximum_coefficient..=maximum_coefficient {
                if first == 0 && second == 0
                    || first.unsigned_abs() + second.unsigned_abs() != complexity as u8
                {
                    continue;
                }
                for modulus in 2..=maximum_modulus {
                    candidates_tested += 1;
                    let modulus_i32 = i32::from(modulus);
                    let mut left_residues = 0_u64;
                    for &point in left {
                        left_residues |= 1_u64 << affine_residue(point, first, second, modulus_i32);
                    }
                    let mut complemented_right_residues = 0_u64;
                    for &point in right {
                        let complement = [target[0] - point[0], target[1] - point[1]];
                        complemented_right_residues |=
                            1_u64 << affine_residue(complement, first, second, modulus_i32);
                    }
                    if left_residues & complemented_right_residues == 0 {
                        return Some(AffineModularSeparator {
                            modulus,
                            first_coefficient: first,
                            second_coefficient: second,
                            left_residues,
                            complemented_right_residues,
                            candidates_tested,
                            origin: FeatureOrigin::Evolved,
                            blindness_level,
                        });
                    }
                }
            }
        }
    }
    None
}

#[inline(always)]
fn separates_scope(scope: PairedPointScope<'_>, first: i8, second: i8, modulus: u8) -> bool {
    if scope.left.is_empty() || scope.right.is_empty() {
        return false;
    }
    let modulus_i32 = i32::from(modulus);
    let mut left_residues = 0_u64;
    for &point in scope.left {
        left_residues |= 1_u64 << affine_residue(point, first, second, modulus_i32);
    }
    let mut right_residues = 0_u64;
    for &point in scope.right {
        let complement = [scope.target[0] - point[0], scope.target[1] - point[1]];
        right_residues |= 1_u64 << affine_residue(complement, first, second, modulus_i32);
    }
    left_residues & right_residues == 0
}

pub fn scoped_affine_residue_masks(
    scope: PairedPointScope<'_>,
    feature: ScopedAffineFeature,
) -> Option<[u64; 2]> {
    if scope.left.is_empty() || scope.right.is_empty() || !(2..=64).contains(&feature.modulus) {
        return None;
    }
    let modulus = i32::from(feature.modulus);
    let mut masks = [0_u64; 2];
    for &point in scope.left {
        masks[0] |= 1_u64
            << affine_residue(
                point,
                feature.first_coefficient,
                feature.second_coefficient,
                modulus,
            );
    }
    for &point in scope.right {
        let complement = [scope.target[0] - point[0], scope.target[1] - point[1]];
        masks[1] |= 1_u64
            << affine_residue(
                complement,
                feature.first_coefficient,
                feature.second_coefficient,
                modulus,
            );
    }
    Some(masks)
}

/// Find the simplest candidate with maximum coverage of the supplied
/// uncovered scopes. The returned mask is the candidate's maximal valid scope
/// over all inputs, rather than a caller-provided mask.
pub fn best_scoped_affine_feature(
    scopes: &[PairedPointScope<'_>],
    uncovered: [u64; 2],
    maximum_modulus: u8,
    maximum_coefficient: i8,
    blindness_level: u8,
) -> Option<ScopedAffineFeature> {
    if scopes.is_empty()
        || scopes.len() > MAX_SCOPES
        || !(2..=64).contains(&maximum_modulus)
        || !(1..=16).contains(&maximum_coefficient)
    {
        return None;
    }
    let mut best = None;
    let mut candidates_tested = 0_u32;
    for complexity in 1..=2 * maximum_coefficient {
        for first in -maximum_coefficient..=maximum_coefficient {
            for second in -maximum_coefficient..=maximum_coefficient {
                if first == 0 && second == 0
                    || first.unsigned_abs() + second.unsigned_abs() != complexity as u8
                {
                    continue;
                }
                for modulus in 2..=maximum_modulus {
                    candidates_tested += 1;
                    let mut scope_words = [0_u64; 2];
                    for (index, &scope) in scopes.iter().enumerate() {
                        if separates_scope(scope, first, second, modulus) {
                            scope_words[index / 64] |= 1_u64 << (index % 64);
                        }
                    }
                    let newly_covered = (scope_words[0] & uncovered[0]).count_ones()
                        + (scope_words[1] & uncovered[1]).count_ones();
                    if newly_covered == 0 {
                        continue;
                    }
                    let scoped = scope_words[0].count_ones() + scope_words[1].count_ones();
                    let replace = best.as_ref().is_none_or(|candidate: &ScopedAffineFeature| {
                        newly_covered > u32::from(candidate.newly_covered_instances)
                            || (newly_covered == u32::from(candidate.newly_covered_instances)
                                && (complexity, modulus)
                                    < (
                                        candidate.first_coefficient.unsigned_abs() as i8
                                            + candidate.second_coefficient.unsigned_abs() as i8,
                                        candidate.modulus,
                                    ))
                    });
                    if replace {
                        best = Some(ScopedAffineFeature {
                            modulus,
                            first_coefficient: first,
                            second_coefficient: second,
                            scope_words,
                            scoped_instances: scoped as u8,
                            newly_covered_instances: newly_covered as u8,
                            candidates_tested,
                            origin: FeatureOrigin::Evolved,
                            blindness_level,
                        });
                    }
                }
            }
        }
    }
    best
}

/// Greedy bounded cover over automatically learned maximal feature scopes.
/// This is an inter-generation control operation; allocations are outside the
/// repeated candidate-evaluation kernel.
pub fn learn_scoped_affine_cover(
    scopes: &[PairedPointScope<'_>],
    maximum_modulus: u8,
    maximum_coefficient: i8,
    maximum_features: u8,
    blindness_level: u8,
) -> Vec<ScopedAffineFeature> {
    if scopes.is_empty() || scopes.len() > MAX_SCOPES {
        return Vec::new();
    }
    let mut uncovered = [0_u64; 2];
    for index in 0..scopes.len() {
        uncovered[index / 64] |= 1_u64 << (index % 64);
    }
    let mut output = Vec::with_capacity(usize::from(maximum_features));
    while uncovered != [0, 0] && output.len() < usize::from(maximum_features) {
        let Some(feature) = best_scoped_affine_feature(
            scopes,
            uncovered,
            maximum_modulus,
            maximum_coefficient,
            blindness_level,
        ) else {
            break;
        };
        uncovered[0] &= !feature.scope_words[0];
        uncovered[1] &= !feature.scope_words[1];
        output.push(feature);
    }
    output
}

pub const MAX_SCOPE_TREE_NODES: usize = 255;

#[repr(C)]
#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct CategoricalScopeNode {
    value: u16,
    field: u8,
    equal: u8,
    not_equal: u8,
    label: u8,
    kind: u8,
    reserved: u8,
}

const _: () = assert!(
    std::mem::size_of::<CategoricalScopeNode>() == 8
        && std::mem::align_of::<CategoricalScopeNode>() == 2
);

impl CategoricalScopeNode {
    const LEAF: u8 = 0;
    const EQUAL: u8 = 1;

    const fn leaf(label: u8) -> Self {
        Self {
            value: 0,
            field: 0,
            equal: 0,
            not_equal: 0,
            label,
            kind: Self::LEAF,
            reserved: 0,
        }
    }

    const fn equal(field: u8, value: u16, equal: u8, not_equal: u8) -> Self {
        Self {
            value,
            field,
            equal,
            not_equal,
            label: u8::MAX,
            kind: Self::EQUAL,
            reserved: 0,
        }
    }
}

#[derive(Clone, Copy)]
struct ScopeWork {
    rows: [u64; 2],
    node: u8,
    depth: u8,
}

const EMPTY_SCOPE_WORK: ScopeWork = ScopeWork {
    rows: [0; 2],
    node: 0,
    depth: 0,
};

#[inline(always)]
fn scope_rows_count(rows: [u64; 2]) -> u32 {
    rows[0].count_ones() + rows[1].count_ones()
}

#[inline(always)]
fn scope_rows_label(rows: [u64; 2], labels: &[u8]) -> Option<u8> {
    let mut found = None;
    for (index, &label) in labels.iter().enumerate() {
        if rows[index / 64] & (1_u64 << (index % 64)) == 0 {
            continue;
        }
        if found.is_some_and(|prior| prior != label) {
            return None;
        }
        found = Some(label);
    }
    found
}

#[inline(always)]
fn scope_misclassifications(rows: [u64; 2], labels: &[u8]) -> u32 {
    let mut counts = [0_u8; MAX_SCOPES];
    let mut maximum = 0_u8;
    for (index, &label) in labels.iter().enumerate() {
        if rows[index / 64] & (1_u64 << (index % 64)) != 0 {
            counts[usize::from(label)] += 1;
            maximum = maximum.max(counts[usize::from(label)]);
        }
    }
    scope_rows_count(rows) - u32::from(maximum)
}

/// Learn an exact multi-class scope partition from earlier categorical
/// features. Equality splits and work traversal are iterative; the caller
/// owns node storage so a preallocated repeated call performs no allocation.
pub fn synthesize_categorical_scope_tree_into<const FIELDS: usize>(
    values: &[[u16; FIELDS]],
    labels: &[u8],
    maximum_depth: u8,
    nodes: &mut Vec<CategoricalScopeNode>,
) -> bool {
    if values.is_empty()
        || values.len() != labels.len()
        || values.len() > MAX_SCOPES
        || FIELDS == 0
        || FIELDS > u8::MAX as usize
        || labels.iter().any(|&label| usize::from(label) >= MAX_SCOPES)
        || nodes.capacity() < MAX_SCOPE_TREE_NODES
    {
        return false;
    }
    nodes.clear();
    nodes.push(CategoricalScopeNode::leaf(u8::MAX));
    let mut all_rows = [0_u64; 2];
    for index in 0..values.len() {
        all_rows[index / 64] |= 1_u64 << (index % 64);
    }
    let mut work = [EMPTY_SCOPE_WORK; MAX_SCOPE_TREE_NODES];
    work[0] = ScopeWork {
        rows: all_rows,
        node: 0,
        depth: 0,
    };
    let mut pending = 1_usize;
    while pending != 0 {
        pending -= 1;
        let item = work[pending];
        if let Some(label) = scope_rows_label(item.rows, labels) {
            nodes[usize::from(item.node)] = CategoricalScopeNode::leaf(label);
            continue;
        }
        if item.depth == maximum_depth || nodes.len() + 2 > MAX_SCOPE_TREE_NODES {
            return false;
        }
        let mut best = None;
        for field in 0..FIELDS {
            for candidate_row in 0..values.len() {
                if item.rows[candidate_row / 64] & (1_u64 << (candidate_row % 64)) == 0 {
                    continue;
                }
                let value = values[candidate_row][field];
                let mut equal = [0_u64; 2];
                for (row, fields) in values.iter().enumerate() {
                    if item.rows[row / 64] & (1_u64 << (row % 64)) != 0 && fields[field] == value {
                        equal[row / 64] |= 1_u64 << (row % 64);
                    }
                }
                let not_equal = [item.rows[0] & !equal[0], item.rows[1] & !equal[1]];
                if equal == [0, 0] || not_equal == [0, 0] {
                    continue;
                }
                let errors = scope_misclassifications(equal, labels)
                    + scope_misclassifications(not_equal, labels);
                let balance = scope_rows_count(equal).min(scope_rows_count(not_equal));
                if best
                    .as_ref()
                    .is_none_or(|&(_, _, best_errors, best_balance, _, _)| {
                        errors < best_errors || (errors == best_errors && balance > best_balance)
                    })
                {
                    best = Some((field, value, errors, balance, equal, not_equal));
                }
            }
        }
        let Some((field, value, _, _, equal_rows, not_equal_rows)) = best else {
            return false;
        };
        let equal = nodes.len() as u8;
        nodes.push(CategoricalScopeNode::leaf(u8::MAX));
        let not_equal = nodes.len() as u8;
        nodes.push(CategoricalScopeNode::leaf(u8::MAX));
        nodes[usize::from(item.node)] =
            CategoricalScopeNode::equal(field as u8, value, equal, not_equal);
        if pending + 2 > work.len() {
            return false;
        }
        work[pending] = ScopeWork {
            rows: equal_rows,
            node: equal,
            depth: item.depth + 1,
        };
        work[pending + 1] = ScopeWork {
            rows: not_equal_rows,
            node: not_equal,
            depth: item.depth + 1,
        };
        pending += 2;
    }
    values
        .iter()
        .zip(labels)
        .all(|(fields, &label)| evaluate_categorical_scope_tree(fields, nodes) == Some(label))
}

#[inline(always)]
pub fn evaluate_categorical_scope_tree<const FIELDS: usize>(
    fields: &[u16; FIELDS],
    nodes: &[CategoricalScopeNode],
) -> Option<u8> {
    let mut node = 0_usize;
    for _ in 0..nodes.len() {
        let record = *nodes.get(node)?;
        match record.kind {
            CategoricalScopeNode::LEAF => return (record.label != u8::MAX).then_some(record.label),
            CategoricalScopeNode::EQUAL => {
                node = usize::from(
                    if fields.get(usize::from(record.field)) == Some(&record.value) {
                        record.equal
                    } else {
                        record.not_equal
                    },
                );
            }
            _ => return None,
        }
    }
    None
}

/// Hash-cons an exact scope tree into a contextual tablebase DAG. Child
/// states are already canonical when visited in reverse node order, so this
/// needs neither recursion nor temporary allocation.
pub fn minimize_categorical_scope_tree_into(
    tree: &[CategoricalScopeNode],
    tablebase: &mut Vec<CategoricalScopeNode>,
) -> Option<u8> {
    if tree.is_empty()
        || tree.len() > MAX_SCOPE_TREE_NODES
        || tablebase.capacity() < MAX_SCOPE_TREE_NODES
    {
        return None;
    }
    tablebase.clear();
    let mut remap = [u8::MAX; MAX_SCOPE_TREE_NODES];
    for old in (0..tree.len()).rev() {
        let source = tree[old];
        let canonical = match source.kind {
            CategoricalScopeNode::LEAF => CategoricalScopeNode::leaf(source.label),
            CategoricalScopeNode::EQUAL => {
                let equal = remap[usize::from(source.equal)];
                let not_equal = remap[usize::from(source.not_equal)];
                if equal == u8::MAX || not_equal == u8::MAX {
                    return None;
                }
                if equal == not_equal {
                    remap[old] = equal;
                    continue;
                }
                CategoricalScopeNode::equal(source.field, source.value, equal, not_equal)
            }
            _ => return None,
        };
        let state = if let Some(state) = tablebase.iter().position(|node| *node == canonical) {
            state
        } else {
            if tablebase.len() == MAX_SCOPE_TREE_NODES {
                return None;
            }
            tablebase.push(canonical);
            tablebase.len() - 1
        };
        remap[old] = state as u8;
    }
    Some(remap[0])
}

#[inline(always)]
pub fn evaluate_categorical_scope_tablebase<const FIELDS: usize>(
    fields: &[u16; FIELDS],
    tablebase: &[CategoricalScopeNode],
    root: u8,
) -> Option<u8> {
    let mut state = usize::from(root);
    for _ in 0..tablebase.len() {
        let record = *tablebase.get(state)?;
        match record.kind {
            CategoricalScopeNode::LEAF => return (record.label != u8::MAX).then_some(record.label),
            CategoricalScopeNode::EQUAL => {
                state = usize::from(
                    if fields.get(usize::from(record.field)) == Some(&record.value) {
                        record.equal
                    } else {
                        record.not_equal
                    },
                );
            }
            _ => return None,
        }
    }
    None
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn conditioned_coordinate_search_reuses_prior_terminal_without_allocating() {
        let first = [[0_u16, 0_u16], [1, 1]];
        let second = [[0_u16, 1_u16], [1, 0]];
        let fixed = [[0_u16, 0_u16]];
        let sets = [&first[..], &second[..], &fixed[..], &fixed[..]];
        let mut workspace = FourSetConditionedWorkspace::new(1, 0, 0).unwrap();
        let (candidate, allocations) = tracked_allocations(|| {
            synthesize_four_set_conditioned_coordinate_obstruction(
                &mut workspace,
                sets,
                0,
                &[0],
                |row| u32::from(row[0]),
                |row, _| u32::from(row[1]),
                4,
            )
        });
        let candidate = candidate.unwrap();
        assert_eq!(candidate.coordinate, 0);
        assert_eq!(candidate.origin, FeatureOrigin::Evolved);
        assert_eq!(candidate.exact_rows, [2, 2, 1, 1]);
        assert_eq!(allocations, 0);
    }

    #[test]
    fn affine_hull_search_discovers_full_coordinate_parity_blindly() {
        let first = [[0_i16, 0_i16], [1, 1], [2, 0]];
        let fixed = [[0_i16, 0_i16]];
        let sets = [&first[..], &fixed[..], &fixed[..], &fixed[..]];
        let (candidate, allocations) = tracked_allocations(|| {
            synthesize_four_set_affine_hull_obstruction(
                sets,
                &[1, 0],
                |row, coordinate| i64::from(row[coordinate]),
                11,
                7,
            )
        });
        let candidate = candidate.unwrap();
        assert_eq!(candidate.modulus, 2);
        assert_eq!(candidate.origin, FeatureOrigin::Evolved);
        assert_eq!(candidate.target_residue, 1);
        assert_eq!(candidate.attainable_residue, 0);
        assert_eq!(allocations, 0);
    }

    #[test]
    fn four_set_affine_obstruction_is_proposed_blindly_and_verified_exactly() {
        let first = [[0_i16, 7_i16], [2, 9], [4, 11]];
        let second = [[0_i16, 3_i16], [2, 5]];
        let sets = [&first[..], &second[..], &first[..], &second[..]];
        let targets = [1_i64, 0_i64];
        let (candidate, allocations) = tracked_allocations(|| {
            synthesize_four_set_affine_obstruction(
                sets,
                &targets,
                |row, coordinate| i64::from(row[coordinate]),
                8,
                3,
                2,
                3,
            )
        });
        let candidate = candidate.unwrap();
        assert_eq!(candidate.origin, FeatureOrigin::Evolved);
        assert!(!four_residue_masks_reach_target(
            candidate.residue_masks,
            (i64::from(candidate.coefficients[0]) * targets[usize::from(candidate.coordinates[0])]
                + i64::from(candidate.coefficients[1])
                    * targets[usize::from(candidate.coordinates[1])])
            .rem_euclid(i64::from(candidate.modulus)) as u8,
            candidate.modulus,
        ));
        assert_eq!(allocations, 0);
    }

    #[test]
    fn affine_separator_is_discovered_without_field_semantics() {
        let left = [[0, 0], [2, 2], [4, 0]];
        let right = [[1, 0], [3, 2]];
        let separator =
            synthesize_affine_modular_separator(&left, &right, [0, 0], 8, 3, 1).unwrap();
        assert_eq!(
            separator.left_residues & separator.complemented_right_residues,
            0
        );
        assert_eq!(separator.origin, FeatureOrigin::Evolved);
    }

    #[test]
    fn affine_search_hot_loop_allocates_nothing() {
        let left = [[0, 0], [2, 2], [4, 0]];
        let right = [[0, 0], [2, 2], [4, 0]];
        let (_, allocations) = tracked_allocations(|| {
            assert!(synthesize_affine_modular_separator(&left, &right, [0, 0], 8, 3, 1).is_none());
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn scope_masks_are_learned_from_candidate_validity() {
        let left_even = [[0, 0], [2, 0]];
        let right_odd = [[1, 0], [3, 0]];
        let left_odd = [[1, 0], [3, 0]];
        let right_even = [[0, 0], [2, 0]];
        let scopes = [
            PairedPointScope {
                left: &left_even,
                right: &right_odd,
                target: [0, 0],
            },
            PairedPointScope {
                left: &left_odd,
                right: &right_even,
                target: [0, 0],
            },
            PairedPointScope {
                left: &left_even,
                right: &left_even,
                target: [0, 0],
            },
        ];
        let feature = best_scoped_affine_feature(&scopes, [7, 0], 8, 3, 1).unwrap();
        assert_eq!(feature.scope_words[0] & 4, 0);
        assert_ne!(feature.scope_words[0] & 3, 0);
    }

    #[test]
    fn scoped_candidate_search_allocates_nothing() {
        let points = [[0, 0], [2, 0]];
        let scopes = [PairedPointScope {
            left: &points,
            right: &points,
            target: [0, 0],
        }];
        let (_, allocations) = tracked_allocations(|| {
            assert!(best_scoped_affine_feature(&scopes, [1, 0], 8, 3, 1).is_none());
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn categorical_scope_tree_is_exact_iterative_and_reusable() {
        let values = [[0, 0], [0, 1], [1, 0], [1, 1], [2, 0], [2, 1]];
        let labels = [0, 0, 1, 2, 1, 2];
        let mut nodes = Vec::with_capacity(MAX_SCOPE_TREE_NODES);
        assert!(synthesize_categorical_scope_tree_into(
            &values, &labels, 8, &mut nodes
        ));
        for (fields, &label) in values.iter().zip(&labels) {
            assert_eq!(evaluate_categorical_scope_tree(fields, &nodes), Some(label));
        }
        let (_, allocations) = tracked_allocations(|| {
            assert!(synthesize_categorical_scope_tree_into(
                &values, &labels, 8, &mut nodes
            ));
            for fields in &values {
                std::hint::black_box(evaluate_categorical_scope_tree(fields, &nodes));
            }
        });
        assert_eq!(allocations, 0);

        let mut tablebase = Vec::with_capacity(MAX_SCOPE_TREE_NODES);
        let root = minimize_categorical_scope_tree_into(&nodes, &mut tablebase).unwrap();
        for (fields, &label) in values.iter().zip(&labels) {
            assert_eq!(
                evaluate_categorical_scope_tablebase(fields, &tablebase, root),
                Some(label)
            );
        }
        let (_, allocations) = tracked_allocations(|| {
            let root = minimize_categorical_scope_tree_into(&nodes, &mut tablebase).unwrap();
            for fields in &values {
                std::hint::black_box(evaluate_categorical_scope_tablebase(
                    fields, &tablebase, root,
                ));
            }
        });
        assert_eq!(allocations, 0);
    }
}
