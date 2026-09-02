//! Private order-2092 adapters over reusable Ergodis cyclic kernels.

use num_bigint::BigUint;
use std::collections::{BTreeMap, BTreeSet, HashMap, HashSet};
use thiserror::Error;

const ROW_VALUES: usize = 10;
const COLUMN_VALUES: usize = 7;
const TABLE_LEN: usize = ROW_VALUES * ROW_VALUES * COLUMN_VALUES * COLUMN_VALUES * COLUMN_VALUES;

const MAX_PRIVATE_CARRIER: u32 = 522;

#[repr(C)]
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CyclicMultiplierOrbitPartition {
    orbit_of: Box<[u32]>,
    representatives: Box<[u32]>,
    orbit_sizes: Box<[u32]>,
    generator: u32,
    generator_order: u32,
    fixed_point_count: u32,
    _pad: u32,
}

#[cfg(target_pointer_width = "64")]
const _: () = assert!(
    std::mem::size_of::<CyclicMultiplierOrbitPartition>() == 64
        && std::mem::align_of::<CyclicMultiplierOrbitPartition>() == 8
);

impl CyclicMultiplierOrbitPartition {
    pub fn compile(carrier: u32, generator: u32) -> Result<Self, Hadamard2092Error> {
        if carrier == 0 || carrier > MAX_PRIVATE_CARRIER || generator >= carrier {
            return Err(Hadamard2092Error::InvalidMultiplier);
        }
        if gcd_u32(generator, carrier) != 1 {
            return Err(Hadamard2092Error::InvalidMultiplier);
        }
        let mut generator_order = 1_u32;
        let mut power = generator;
        while power != 1 {
            power = ((u64::from(power) * u64::from(generator)) % u64::from(carrier)) as u32;
            generator_order += 1;
            if generator_order > carrier {
                return Err(Hadamard2092Error::InvalidMultiplier);
            }
        }
        let mut orbit_of = vec![u32::MAX; carrier as usize];
        let mut representatives = Vec::with_capacity(carrier as usize);
        let mut orbit_sizes = Vec::with_capacity(carrier as usize);
        for point in 0..carrier {
            if orbit_of[point as usize] != u32::MAX {
                continue;
            }
            let orbit = orbit_sizes.len() as u32;
            representatives.push(point);
            let mut image = point;
            let mut size = 0_u32;
            loop {
                orbit_of[image as usize] = orbit;
                size += 1;
                image = ((u64::from(generator) * u64::from(image)) % u64::from(carrier)) as u32;
                if image == point {
                    break;
                }
            }
            orbit_sizes.push(size);
        }
        let fixed_point_count = orbit_sizes.iter().filter(|&&size| size == 1).count() as u32;
        Ok(Self {
            orbit_of: orbit_of.into_boxed_slice(),
            representatives: representatives.into_boxed_slice(),
            orbit_sizes: orbit_sizes.into_boxed_slice(),
            generator,
            generator_order,
            fixed_point_count,
            _pad: 0,
        })
    }

    pub fn generator(&self) -> u32 {
        self.generator
    }

    pub fn generator_order(&self) -> u32 {
        self.generator_order
    }

    pub fn orbit_count(&self) -> u32 {
        self.orbit_sizes.len() as u32
    }

    pub fn fixed_point_count(&self) -> u32 {
        self.fixed_point_count
    }

    pub fn orbit_of(&self, point: u32) -> Option<u32> {
        self.orbit_of.get(point as usize).copied()
    }

    pub fn orbit_ids(&self) -> &[u32] {
        &self.orbit_of
    }

    pub fn orbit_sizes(&self) -> &[u32] {
        &self.orbit_sizes
    }

    pub fn representatives(&self) -> &[u32] {
        &self.representatives
    }
}

#[repr(transparent)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct BorderedGsOrderTwoProfile([u16; 4]);

impl BorderedGsOrderTwoProfile {
    pub fn magnitudes(self) -> [u16; 4] {
        self.0
    }
}

#[repr(transparent)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct BorderedGsOrderThreeProfile([u32; 4]);

impl BorderedGsOrderThreeProfile {
    pub fn energies(self) -> [u32; 4] {
        self.0
    }
}

#[repr(C)]
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct BorderedGsMultiplierStratum {
    profiles: Box<[BorderedGsOrderTwoProfile]>,
    generator: u32,
    order: u32,
    orbit_count: u32,
    _pad: u32,
}

impl BorderedGsMultiplierStratum {
    pub fn generator(&self) -> u32 {
        self.generator
    }

    pub fn order(&self) -> u32 {
        self.order
    }

    pub fn orbit_count(&self) -> u32 {
        self.orbit_count
    }

    pub fn profiles(&self) -> &[BorderedGsOrderTwoProfile] {
        &self.profiles
    }
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum Hadamard2092Error {
    #[error("joint-compression marginal count overflow")]
    FibreOverflow,
    #[error("signature and output lengths differ")]
    Workspace,
    #[error("character value did not collapse to the expected fixed field")]
    FixedField,
    #[error("invalid private cyclic multiplier or carrier")]
    InvalidMultiplier,
    #[error("private theorem compiler exceeded its explicit state budget")]
    StateBudget,
    #[error("private theorem compiler arithmetic overflow")]
    ArithmeticOverflow,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct RationalJointCharacterCensus {
    pub orders: Box<[u8]>,
    pub special_energy_signatures: u32,
    pub zero_energy_signatures: u32,
    pub canonical_profiles: u64,
    pub profiles: Box<[[[u16; 3]; 4]]>,
    pub labelled_assignments: BigUint,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct QuadraticCharacterCensus {
    pub special_energy_signatures: u32,
    pub zero_energy_signatures: u32,
    pub canonical_profiles: u64,
    pub profiles: Box<[[u16; 4]]>,
    pub labelled_assignments: BigUint,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct SingleCharacterCensus {
    pub special_energy_signatures: u32,
    pub zero_energy_signatures: u32,
    pub canonical_profiles: u64,
    pub labelled_assignments: BigUint,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct EisensteinJointCharacterCensus {
    pub special_energy_signatures: u32,
    pub zero_energy_signatures: u32,
    pub canonical_profiles: u64,
    pub labelled_assignments: BigUint,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct QuadraticEisensteinJointCensus {
    pub special_energy_signatures: u32,
    pub zero_energy_signatures: u32,
    pub canonical_profiles: u64,
    pub labelled_assignments: BigUint,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct QuadraticRationalJointCensus {
    pub rational_profiles: u64,
    pub special_joint_signatures: u32,
    pub zero_joint_signatures: u32,
    pub special_block_assignments: u128,
    pub zero_block_assignments: u128,
    pub compatible_left_pair_assignments: BigUint,
    pub compatible_right_pair_assignments: BigUint,
    pub labelled_assignments: BigUint,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct DoubleQuadraticRationalJointCensus {
    pub rational_profiles: u64,
    pub special_joint_signatures: u32,
    pub zero_joint_signatures: u32,
    pub special_block_assignments: u128,
    pub zero_block_assignments: u128,
    pub compatible_left_pair_assignments: BigUint,
    pub compatible_right_pair_assignments: BigUint,
    pub labelled_assignments: BigUint,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Generator53Q58BlockFilterCensus {
    pub special_joint_signatures: u32,
    pub zero_joint_signatures: u32,
    pub special_block_assignments: u128,
    pub zero_block_assignments: u128,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct TranslationNormalizerCensus {
    pub generator: u32,
    pub translations: u32,
    pub special_raw: u128,
    pub special_quotient: u128,
    pub zero_raw: u128,
    pub zero_quotient: u128,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct UnitNormalizerCensus {
    pub generator: u32,
    pub quotient_units: u32,
    pub special_raw: u128,
    pub special_quotient: u128,
    pub zero_raw: u128,
    pub zero_quotient: u128,
}

/// Precompiled compatibility relation between the `d=9` and `d=6`
/// compressions over one residue class modulo 29.
///
/// Construction allocates once. `fibres` is a bounded O(1), allocation-free
/// hot-path lookup.
#[repr(C)]
#[derive(Clone, Debug)]
pub struct JointD9D6MarginalTable {
    counts: Box<[u16]>,
}

#[cfg(target_pointer_width = "64")]
const _: () = assert!(
    std::mem::size_of::<JointD9D6MarginalTable>() == 16
        && std::mem::align_of::<JointD9D6MarginalTable>() == 8
);

impl JointD9D6MarginalTable {
    pub fn compile() -> Result<Self, Hadamard2092Error> {
        const VALUES: [i8; 4] = [-3, -1, 1, 3];
        let mut counts = vec![0_u16; TABLE_LEN].into_boxed_slice();
        for encoded in 0..4096_u16 {
            let mut value = encoded;
            let mut cells = [0_i8; 6];
            for cell in &mut cells {
                *cell = VALUES[usize::from(value & 3)];
                value >>= 2;
            }
            let rows = [
                cells[0] + cells[1] + cells[2],
                cells[3] + cells[4] + cells[5],
            ];
            let columns = [
                cells[0] + cells[3],
                cells[1] + cells[4],
                cells[2] + cells[5],
            ];
            let index = marginal_index(rows, columns).expect("generated marginals are in range");
            counts[index] = counts[index]
                .checked_add(1)
                .ok_or(Hadamard2092Error::FibreOverflow)?;
        }
        Ok(Self { counts })
    }

    #[inline]
    pub fn fibres(&self, rows: [i8; 2], columns: [i8; 3]) -> u16 {
        marginal_index(rows, columns)
            .map(|index| self.counts[index])
            .unwrap_or(0)
    }

    pub fn compatible_signature_count(&self) -> u32 {
        self.counts.iter().filter(|&&count| count != 0).count() as u32
    }
}

/// Write the bordered-GS residual key for a PAF-pair signature.
/// Repeated calls allocate nothing.
pub fn write_bordered_pair_residual(
    signature: &[i32],
    output: &mut [i32],
) -> Result<(), Hadamard2092Error> {
    if signature.len() != output.len() {
        return Err(Hadamard2092Error::Workspace);
    }
    for (&value, output_value) in signature.iter().zip(output) {
        *output_value = -4 - value;
    }
    Ok(())
}

pub fn compile_bordered_order_two_profiles(
    carrier: u32,
) -> Result<Box<[BorderedGsOrderTwoProfile]>, Hadamard2092Error> {
    validate_bordered_carrier(carrier, 2)?;
    let special = order_two_magnitudes(carrier, 2);
    let zero = order_two_magnitudes(carrier, 0);
    Ok(compile_order_two_profiles(&special, &zero, 4 * (carrier + 1)).into_boxed_slice())
}

pub fn count_bordered_order_two_profile_domain(carrier: u32) -> Result<u64, Hadamard2092Error> {
    validate_bordered_carrier(carrier, 2)?;
    let special = (0..=carrier)
        .filter(|&value| {
            order_two_sum_possible(carrier, 2, i64::from(value))
                || order_two_sum_possible(carrier, 2, -i64::from(value))
        })
        .count() as u64;
    let zero = (0..=carrier)
        .filter(|&value| {
            order_two_sum_possible(carrier, 0, i64::from(value))
                || order_two_sum_possible(carrier, 0, -i64::from(value))
        })
        .count() as u64;
    let triples = zero
        .checked_mul(zero + 1)
        .and_then(|value| value.checked_mul(zero + 2))
        .map(|value| value / 6)
        .ok_or(Hadamard2092Error::FibreOverflow)?;
    special
        .checked_mul(triples)
        .ok_or(Hadamard2092Error::FibreOverflow)
}

pub fn compile_bordered_multiplier_strata(
    carrier: u32,
    minimum_order: u32,
) -> Result<Box<[BorderedGsMultiplierStratum]>, Hadamard2092Error> {
    validate_bordered_carrier(carrier, 2)?;
    let mut subgroups = BTreeMap::<Vec<u32>, u32>::new();
    for generator in 1..carrier {
        if gcd_u32(generator, carrier) != 1 {
            continue;
        }
        let subgroup = cyclic_subgroup(carrier, generator)?;
        if subgroup.len() < minimum_order as usize {
            continue;
        }
        let mut canonical = subgroup;
        canonical.sort_unstable();
        subgroups.entry(canonical).or_insert(generator);
        if subgroups.len() > carrier as usize {
            return Err(Hadamard2092Error::FibreOverflow);
        }
    }
    let mut strata = Vec::with_capacity(subgroups.len());
    for (subgroup, generator) in subgroups {
        let partition = CyclicMultiplierOrbitPartition::compile(carrier, generator)?;
        let (even, odd) = parity_orbit_sizes(carrier, &subgroup);
        let special = invariant_order_two_magnitudes(carrier, 2, &even, &odd);
        let zero = invariant_order_two_magnitudes(carrier, 0, &even, &odd);
        strata.push(BorderedGsMultiplierStratum {
            profiles: compile_order_two_profiles(&special, &zero, 4 * (carrier + 1))
                .into_boxed_slice(),
            generator,
            order: subgroup.len() as u32,
            orbit_count: partition.orbit_count(),
            _pad: 0,
        });
    }
    strata.sort_unstable_by_key(|stratum| (stratum.order, stratum.generator));
    Ok(strata.into_boxed_slice())
}

pub fn compile_bordered_multiplier_order_three_profiles(
    carrier: u32,
    generator: u32,
) -> Result<Box<[BorderedGsOrderThreeProfile]>, Hadamard2092Error> {
    validate_bordered_carrier(carrier, 3)?;
    let subgroup = cyclic_subgroup(carrier, generator)?;
    let target = 4 * (carrier + 1);
    let special = invariant_order_three_energies(carrier, 2, &subgroup, target)?;
    let zero = invariant_order_three_energies(carrier, 0, &subgroup, target)?;
    let mut profiles = Vec::new();
    for &a in &special {
        for (b_index, &b) in zero.iter().enumerate() {
            for (c_index, &c) in zero.iter().enumerate().skip(b_index) {
                let partial = u64::from(a) + u64::from(b) + u64::from(c);
                if partial > u64::from(target) {
                    break;
                }
                for &d in zero.iter().skip(c_index) {
                    let energy = partial + u64::from(d);
                    if energy == u64::from(target) {
                        profiles.push(BorderedGsOrderThreeProfile([a, b, c, d]));
                    } else if energy > u64::from(target) {
                        break;
                    }
                }
            }
        }
    }
    Ok(profiles.into_boxed_slice())
}

fn validate_bordered_carrier(carrier: u32, order: u32) -> Result<(), Hadamard2092Error> {
    if carrier == 0
        || carrier > MAX_PRIVATE_CARRIER
        || carrier & 1 != 0
        || !carrier.is_multiple_of(order)
    {
        return Err(Hadamard2092Error::InvalidMultiplier);
    }
    Ok(())
}

fn cyclic_subgroup(carrier: u32, generator: u32) -> Result<Vec<u32>, Hadamard2092Error> {
    if generator >= carrier || gcd_u32(generator, carrier) != 1 {
        return Err(Hadamard2092Error::InvalidMultiplier);
    }
    let mut subgroup = Vec::with_capacity(carrier.min(256) as usize);
    let mut value = 1_u32;
    loop {
        subgroup.push(value);
        value = ((u64::from(value) * u64::from(generator)) % u64::from(carrier)) as u32;
        if value == 1 {
            return Ok(subgroup);
        }
        if subgroup.len() > carrier as usize {
            return Err(Hadamard2092Error::InvalidMultiplier);
        }
    }
}

fn order_two_magnitudes(carrier: u32, row_sum: i64) -> Vec<u16> {
    (0..=carrier)
        .filter(|&value| {
            order_two_sum_possible(carrier, row_sum, i64::from(value))
                || order_two_sum_possible(carrier, row_sum, -i64::from(value))
        })
        .map(|value| value as u16)
        .collect()
}

fn order_two_sum_possible(carrier: u32, row_sum: i64, alternating: i64) -> bool {
    if (row_sum + alternating) & 1 != 0 || (row_sum - alternating) & 1 != 0 {
        return false;
    }
    let half = i64::from(carrier / 2);
    let even = (row_sum + alternating) / 2;
    let odd = (row_sum - alternating) / 2;
    even.abs() <= half && odd.abs() <= half && (even - half) & 1 == 0 && (odd - half) & 1 == 0
}

fn compile_order_two_profiles(
    special: &[u16],
    zero: &[u16],
    target: u32,
) -> Vec<BorderedGsOrderTwoProfile> {
    let mut profiles = Vec::new();
    for &a in special {
        for (b_index, &b) in zero.iter().enumerate() {
            for (c_index, &c) in zero.iter().enumerate().skip(b_index) {
                let partial = u64::from(a) * u64::from(a)
                    + u64::from(b) * u64::from(b)
                    + u64::from(c) * u64::from(c);
                if partial > u64::from(target) {
                    break;
                }
                for &d in zero.iter().skip(c_index) {
                    let energy = partial + u64::from(d) * u64::from(d);
                    if energy == u64::from(target) {
                        profiles.push(BorderedGsOrderTwoProfile([a, b, c, d]));
                    } else if energy > u64::from(target) {
                        break;
                    }
                }
            }
        }
    }
    profiles
}

fn parity_orbit_sizes(carrier: u32, subgroup: &[u32]) -> (Vec<u16>, Vec<u16>) {
    let mut visited = vec![false; carrier as usize];
    let mut even = Vec::new();
    let mut odd = Vec::new();
    for point in 0..carrier {
        if visited[point as usize] {
            continue;
        }
        let mut size = 0_u16;
        for &multiplier in subgroup {
            let image = ((u64::from(multiplier) * u64::from(point)) % u64::from(carrier)) as usize;
            if !visited[image] {
                visited[image] = true;
                size += 1;
            }
        }
        if point & 1 == 0 {
            even.push(size);
        } else {
            odd.push(size);
        }
    }
    (even, odd)
}

fn invariant_order_two_magnitudes(
    carrier: u32,
    row_sum: i64,
    even: &[u16],
    odd: &[u16],
) -> Vec<u16> {
    let minus_total = ((i64::from(carrier) - row_sum) / 2) as usize;
    let even_sums = subset_sums(even, minus_total);
    let odd_sums = subset_sums(odd, minus_total);
    let mut magnitudes = HashSet::new();
    for (even_minus, &even_reachable) in even_sums.iter().enumerate() {
        let odd_minus = minus_total - even_minus;
        if even_reachable && odd_sums[odd_minus] {
            magnitudes.insert(
                (2_i64 * (i64::from(carrier / 2) - 2 * even_minus as i64) - row_sum).unsigned_abs()
                    as u16,
            );
        }
    }
    let mut values = magnitudes.into_iter().collect::<Vec<_>>();
    values.sort_unstable();
    values
}

fn subset_sums(weights: &[u16], maximum: usize) -> Vec<bool> {
    let mut sums = vec![false; maximum + 1];
    sums[0] = true;
    for &weight in weights {
        let weight = usize::from(weight);
        for total in (weight..=maximum).rev() {
            sums[total] |= sums[total - weight];
        }
    }
    sums
}

fn invariant_order_three_energies(
    carrier: u32,
    row_sum: i64,
    subgroup: &[u32],
    target: u32,
) -> Result<Vec<u32>, Hadamard2092Error> {
    let minus_total = ((i64::from(carrier) - row_sum) / 2) as u16;
    let mut visited = vec![false; carrier as usize];
    let mut weights = Vec::with_capacity(carrier as usize);
    for point in 0..carrier {
        if visited[point as usize] {
            continue;
        }
        let mut weight = [0_u16; 3];
        for &multiplier in subgroup {
            let image = ((u64::from(multiplier) * u64::from(point)) % u64::from(carrier)) as usize;
            if !visited[image] {
                visited[image] = true;
                weight[image % 3] += 1;
            }
        }
        weights.push(weight);
    }
    const STATE_BUDGET: usize = 2_000_000;
    let mut states = HashSet::with_capacity(STATE_BUDGET);
    states.insert([0_u16; 3]);
    let mut additions = Vec::with_capacity(STATE_BUDGET);
    for weight in weights {
        additions.clear();
        additions.extend(states.iter().filter_map(|state| {
            let next = [
                state[0] + weight[0],
                state[1] + weight[1],
                state[2] + weight[2],
            ];
            (next.iter().copied().sum::<u16>() <= minus_total).then_some(next)
        }));
        if states.len().saturating_add(additions.len()) > STATE_BUDGET {
            return Err(Hadamard2092Error::FibreOverflow);
        }
        states.extend(additions.iter().copied());
    }
    let mut energies = states
        .into_iter()
        .filter(|state| state.iter().copied().sum::<u16>() == minus_total)
        .filter_map(|state| {
            let u = i64::from(state[0]) - i64::from(state[2]);
            let v = i64::from(state[1]) - i64::from(state[2]);
            let energy = 4_i64 * (u * u - u * v + v * v);
            (energy <= i64::from(target)).then_some(energy as u32)
        })
        .collect::<Vec<_>>();
    energies.sort_unstable();
    energies.dedup();
    Ok(energies)
}

/// Compile the exact order-nine energy profiles for the generator-41 shard.
/// Its multiplier image is the full Galois group of `Q(zeta_9)`, so every
/// character value is rational and the cyclotomic equation becomes an integer
/// four-square equation. This allocates only during campaign compilation.
pub fn compile_generator_41_order_nine_profiles() -> Box<[[u32; 4]]> {
    const CARRIER: u32 = 522;
    const GENERATOR: u32 = 41;
    const TARGET: u32 = 2092;
    let partition = CyclicMultiplierOrbitPartition::compile(CARRIER, GENERATOR)
        .expect("the fixed order-2092 multiplier is valid");
    let mut orbit_weights = vec![[0_i16; 7]; partition.orbit_count() as usize];
    const BASIS: [[i16; 6]; 9] = [
        [1, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0],
        [0, 0, 0, 1, 0, 0],
        [0, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 1],
        [-1, 0, 0, -1, 0, 0],
        [0, -1, 0, 0, -1, 0],
        [0, 0, -1, 0, 0, -1],
    ];
    for point in 0..CARRIER {
        let orbit = partition
            .orbit_of(point)
            .expect("point is in its partition") as usize;
        orbit_weights[orbit][0] += 1;
        for coordinate in 0..6 {
            orbit_weights[orbit][coordinate + 1] += BASIS[(point % 9) as usize][coordinate];
        }
    }
    assert!(orbit_weights
        .iter()
        .all(|weight| weight[2..].iter().all(|&coordinate| coordinate == 0)));

    let special = rational_order_nine_energies(&orbit_weights, 260, TARGET);
    let zero = rational_order_nine_energies(&orbit_weights, 261, TARGET);
    let mut profiles = Vec::new();
    for &a in &special {
        for (b_index, &b) in zero.iter().enumerate() {
            for (c_index, &c) in zero.iter().enumerate().skip(b_index) {
                for &d in zero.iter().skip(c_index) {
                    let energy = a + b + c + d;
                    if energy == TARGET {
                        profiles.push([a, b, c, d]);
                    } else if energy > TARGET {
                        break;
                    }
                }
            }
        }
    }
    profiles.into_boxed_slice()
}

fn rational_order_nine_energies(
    orbit_weights: &[[i16; 7]],
    minus_total: i16,
    target: u32,
) -> Vec<u32> {
    let mut states = HashSet::from([(0_i16, 0_i16)]);
    let mut additions = Vec::new();
    for weight in orbit_weights {
        additions.clear();
        additions.extend(states.iter().filter_map(|&(count, value)| {
            let next_count = count + weight[0];
            (next_count <= minus_total).then_some((next_count, value + weight[1]))
        }));
        states.extend(additions.iter().copied());
    }
    let mut energies = states
        .into_iter()
        .filter(|&(count, _)| count == minus_total)
        .filter_map(|(_, value)| {
            let value = i32::from(value);
            let energy = 4_u32 * value.unsigned_abs().pow(2);
            (energy <= target).then_some(energy)
        })
        .collect::<Vec<_>>();
    energies.sort_unstable();
    energies.dedup();
    energies
}

/// Compile a same-subset census for character sectors whose multiplier-fixed
/// values are rational. This is campaign compilation, not a solve kernel.
pub fn compile_rational_joint_character_census(
    generator: u32,
    orders: &[u8],
) -> Result<RationalJointCharacterCensus, Hadamard2092Error> {
    if orders.is_empty()
        || orders.len() > 3
        || orders
            .iter()
            .any(|order| !matches!(order, 2 | 3 | 6 | 9 | 18))
    {
        return Err(Hadamard2092Error::FixedField);
    }
    let weights = rational_orbit_weights(generator, orders)?;
    let special = rational_energy_distribution(&weights, orders.len(), 260)?;
    let zero = rational_energy_distribution(&weights, orders.len(), 261)?;
    let labelled_assignments = labelled_four_block_count(&special, &zero, orders.len());
    let profiles = canonical_four_block_profiles(&special, &zero, orders.len());
    Ok(RationalJointCharacterCensus {
        orders: orders.into(),
        special_energy_signatures: special.len() as u32,
        zero_energy_signatures: zero.len() as u32,
        canonical_profiles: profiles.len() as u64,
        profiles: profiles.into_boxed_slice(),
        labelled_assignments,
    })
}

/// Exact structural order-29 reduction for the generator-91 root.
///
/// There are 18 multiplier-fixed points and 18 size-14 orbits of each
/// Legendre class. The row sums force the special block to select eight fixed
/// points and 18 nonzero orbits, and each zero block to select nine fixed
/// points and 18 nonzero orbits. If `B` is the difference between its selected
/// residue and nonresidue orbit counts, its character energy is
///
/// - `4 + 29 B^2 - 4 B sqrt(29)` for the special block;
/// - `29 B^2` for a zero block.
///
/// Radical cancellation therefore forces `B = 0` in the special block. With
/// `B_i = 2 b_i` in the other blocks, the remaining rational equation is
/// `b_1^2 + b_2^2 + b_3^2 = 18`. Up to order and sign its only solutions are
/// `(4, 1, 1)` and `(3, 3, 0)`. No subset DP or certificate is involved.
pub fn compile_generator_91_order_29_census() -> Result<QuadraticCharacterCensus, Hadamard2092Error>
{
    let fixed_special = binomial_u128(18, 8);
    let fixed_zero = binomial_u128(18, 9);
    let balanced = binomial_u128(18, 9);
    let special = fixed_special * balanced * balanced;
    let zero_count = |difference: usize| {
        let residues = (18 + difference) / 2;
        let nonresidues = 18 - residues;
        fixed_zero * binomial_u128(18, residues) * binomial_u128(18, nonresidues)
    };
    let zero_0 = zero_count(0);
    let zero_2 = 2 * zero_count(2);
    let zero_6 = 2 * zero_count(6);
    let zero_8 = 2 * zero_count(8);
    let labelled_assignments = BigUint::from(3_u8)
        * BigUint::from(special)
        * (BigUint::from(zero_0) * BigUint::from(zero_6).pow(2)
            + BigUint::from(zero_8) * BigUint::from(zero_2).pow(2));
    let profiles = Box::new([[4, 0, 1044, 1044], [4, 116, 116, 1856]]);
    Ok(QuadraticCharacterCensus {
        special_energy_signatures: 9,
        zero_energy_signatures: 5,
        canonical_profiles: profiles.len() as u64,
        profiles,
        labelled_assignments,
    })
}

/// Exact structural order-9 reduction for the generator-133 root.
///
/// Modulo nine, each of the residue classes 0, 3, and 6 contains two fixed
/// multiplier orbits and fourteen size-four orbits. All remaining multiplier
/// orbits (four of size three and 28 of size twelve) have zero primitive
/// order-nine character sum. Thus the energy is an Eisenstein norm in the
/// three selected residue counts, while the remaining choices enter only
/// through a one-variable row-sum generating function.
pub fn compile_generator_133_order_nine_census() -> SingleCharacterCensus {
    let special = generator_133_order_nine_distribution(260);
    let zero = generator_133_order_nine_distribution(261);
    let labelled_assignments = single_character_four_block_count(&special, &zero);
    let canonical_profiles = single_character_canonical_profiles(&special, &zero);
    SingleCharacterCensus {
        special_energy_signatures: special.len() as u32,
        zero_energy_signatures: zero.len() as u32,
        canonical_profiles,
        labelled_assignments,
    }
}

/// Exact joint order-3/order-9 reduction for the generator-133 root.
///
/// The order-nine divisor classes above contribute only to residue zero
/// modulo three. The remaining multiplier orbits split into two identical
/// families, one in each nonzero residue modulo three, with two size-three
/// and fourteen size-twelve orbits per family. Consequently both character
/// energies are Eisenstein norms of five bounded integer counts.
pub fn compile_generator_133_order_three_nine_census() -> EisensteinJointCharacterCensus {
    let special = generator_133_order_three_nine_distribution(260);
    let zero = generator_133_order_three_nine_distribution(261);
    let labelled_assignments = joint_eisenstein_four_block_count(&special, &zero);
    let canonical_profiles = joint_eisenstein_canonical_profiles(&special, &zero);
    EisensteinJointCharacterCensus {
        special_energy_signatures: special.len() as u32,
        zero_energy_signatures: zero.len() as u32,
        canonical_profiles,
        labelled_assignments,
    }
}

/// Exact joint order-3/order-29 reduction for the generator-91 root.
///
/// CRT modulo 87 splits the multiplier orbits uniformly across residues
/// modulo three. In each residue there are six fixed points, six size-14
/// quadratic-residue orbits, and six size-14 nonresidue orbits. The two
/// character energies are therefore respectively an Eisenstein norm and the
/// quadratic norm already used by the structural order-29 theorem.
pub fn compile_generator_91_order_three_twenty_nine_census() -> QuadraticEisensteinJointCensus {
    let special = generator_91_order_three_twenty_nine_distribution(8);
    let zero = generator_91_order_three_twenty_nine_distribution(9);
    let labelled_assignments = quadratic_eisenstein_four_block_count(&special, &zero);
    let canonical_profiles = quadratic_eisenstein_canonical_profiles(&special, &zero);
    QuadraticEisensteinJointCensus {
        special_energy_signatures: special.len() as u32,
        zero_energy_signatures: zero.len() as u32,
        canonical_profiles,
        labelled_assignments,
    }
}

/// Exact same-subset joint q2/q3/q6/q29 reduction for generator 53.
///
/// CRT exposes five copies of the ten orbit types of negation on Z/18Z:
/// one over residue zero modulo 29 and one over each coset of `<24>` in
/// `(Z/29Z)^x`. A choice in the zero family contributes its Z/18 orbit size;
/// a choice in a nonzero family contributes seven times that size while its
/// order-29 coefficient is the unscaled size. This reduces fifty orbit bits
/// to a 1,024-row structural table and bounded meet-in-the-middle joins.
pub fn compile_generator_53_order_two_three_six_twenty_nine_census(
) -> Result<QuadraticRationalJointCensus, Hadamard2092Error> {
    let rational = compile_rational_joint_character_census(53, &[2, 3, 6])?;
    let mut special_energies = BTreeSet::new();
    let mut zero_energies = BTreeSet::new();
    for profile in rational.profiles.iter() {
        special_energies.insert(profile[0]);
        zero_energies.extend(profile[1..].iter().copied());
    }
    let base = generator_53_base_choices();
    let pairs = generator_53_base_pair_distributions(&base)?;
    let special = generator_53_joint_block_distribution(260, &special_energies, &base, &pairs)?;
    let zero = generator_53_joint_block_distribution(261, &zero_energies, &base, &pairs)?;

    let left = generator_53_joint_pair_distribution(&special, &zero)?;
    let right = generator_53_joint_pair_distribution(&zero, &zero)?;
    let mut labelled_assignments = BigUint::default();
    let mut compatible_left_pair_assignments = BigUint::default();
    let mut compatible_right_pair_assignments = BigUint::default();
    for (key, &count) in &left {
        let Some(residual) = key.residual() else {
            continue;
        };
        if let Some(&matches) = right.get(&residual) {
            labelled_assignments += BigUint::from(count) * BigUint::from(matches);
            compatible_left_pair_assignments += BigUint::from(count);
            compatible_right_pair_assignments += BigUint::from(matches);
        }
    }
    Ok(QuadraticRationalJointCensus {
        rational_profiles: rational.profiles.len() as u64,
        special_joint_signatures: special.values().map(BTreeMap::len).sum::<usize>() as u32,
        zero_joint_signatures: zero.values().map(BTreeMap::len).sum::<usize>() as u32,
        special_block_assignments: generator_53_block_assignment_count(
            special.values().flat_map(BTreeMap::values),
        )?,
        zero_block_assignments: generator_53_block_assignment_count(
            zero.values().flat_map(BTreeMap::values),
        )?,
        compatible_left_pair_assignments,
        compatible_right_pair_assignments,
        labelled_assignments,
    })
}

/// Add the primitive order-58 sector to the generator-53 CRT theorem.
/// Since `zeta_58^x = (-1)^x zeta_29^(15x)`, the order-58 coefficients are
/// exactly the parity sums of the same five Z/18 orbit families used above.
/// Its energy is a second Q(sqrt(29)) norm, independent of the order-29 norm
/// based on selected counts.
pub fn compile_generator_53_order_two_three_six_twenty_nine_fifty_eight_census(
) -> Result<DoubleQuadraticRationalJointCensus, Hadamard2092Error> {
    let rational = compile_rational_joint_character_census(53, &[2, 3, 6])?;
    let mut special_energies = BTreeSet::new();
    let mut zero_energies = BTreeSet::new();
    for profile in rational.profiles.iter() {
        special_energies.insert(profile[0]);
        zero_energies.extend(profile[1..].iter().copied());
    }
    let base = generator_53_base_choices();
    let detailed_pairs = generator_53_detailed_base_pair_distributions(&base)?;
    let special = generator_53_double_quadratic_block_distribution(
        260,
        &special_energies,
        &base,
        &detailed_pairs,
    )?;
    let zero = generator_53_double_quadratic_block_distribution(
        261,
        &zero_energies,
        &base,
        &detailed_pairs,
    )?;
    let mut labelled_assignments = BigUint::default();
    let mut compatible_left_pair_assignments = BigUint::default();
    let mut compatible_right_pair_assignments = BigUint::default();
    const PERMUTATIONS: [[usize; 3]; 6] = [
        [0, 1, 2],
        [0, 2, 1],
        [1, 0, 2],
        [1, 2, 0],
        [2, 0, 1],
        [2, 1, 0],
    ];
    for profile in rational.profiles.iter() {
        let special_distribution = special
            .get(&profile[0])
            .ok_or(Hadamard2092Error::FixedField)?;
        let zeros = [profile[1], profile[2], profile[3]];
        let mut seen = BTreeSet::new();
        for permutation in PERMUTATIONS {
            let ordered = [
                zeros[permutation[0]],
                zeros[permutation[1]],
                zeros[permutation[2]],
            ];
            if !seen.insert(ordered) {
                continue;
            }
            let first_zero = zero.get(&ordered[0]).ok_or(Hadamard2092Error::FixedField)?;
            let second_zero = zero.get(&ordered[1]).ok_or(Hadamard2092Error::FixedField)?;
            let third_zero = zero.get(&ordered[2]).ok_or(Hadamard2092Error::FixedField)?;
            let left = generator_53_double_quadratic_sector_pair_distribution(
                special_distribution,
                first_zero,
            )?;
            let right =
                generator_53_double_quadratic_sector_pair_distribution(second_zero, third_zero)?;
            for (key, &count) in &left {
                let Some(residual) = key.residual() else {
                    continue;
                };
                if let Some(&matches) = right.get(&residual) {
                    labelled_assignments += BigUint::from(count) * BigUint::from(matches);
                    compatible_left_pair_assignments += BigUint::from(count);
                    compatible_right_pair_assignments += BigUint::from(matches);
                }
            }
        }
    }
    Ok(DoubleQuadraticRationalJointCensus {
        rational_profiles: rational.profiles.len() as u64,
        special_joint_signatures: special.values().map(HashMap::len).sum::<usize>() as u32,
        zero_joint_signatures: zero.values().map(HashMap::len).sum::<usize>() as u32,
        special_block_assignments: generator_53_block_assignment_count(
            special.values().flat_map(HashMap::values),
        )?,
        zero_block_assignments: generator_53_block_assignment_count(
            zero.values().flat_map(HashMap::values),
        )?,
        compatible_left_pair_assignments,
        compatible_right_pair_assignments,
        labelled_assignments,
    })
}

/// Compile only the per-block q2/q3/q6/q29/q58 PSD filter. This avoids the
/// experimental four-block q58 join and is the form used by staged search.
pub fn compile_generator_53_q58_block_filter_census(
) -> Result<Generator53Q58BlockFilterCensus, Hadamard2092Error> {
    let rational = compile_rational_joint_character_census(53, &[2, 3, 6])?;
    let mut special_energies = BTreeSet::new();
    let mut zero_energies = BTreeSet::new();
    for profile in rational.profiles.iter() {
        special_energies.insert(profile[0]);
        zero_energies.extend(profile[1..].iter().copied());
    }
    let base = generator_53_base_choices();
    let detailed_pairs = generator_53_detailed_base_pair_distributions(&base)?;
    let special = generator_53_double_quadratic_block_distribution(
        260,
        &special_energies,
        &base,
        &detailed_pairs,
    )?;
    let zero = generator_53_double_quadratic_block_distribution(
        261,
        &zero_energies,
        &base,
        &detailed_pairs,
    )?;
    Ok(Generator53Q58BlockFilterCensus {
        special_joint_signatures: special.values().map(HashMap::len).sum::<usize>() as u32,
        zero_joint_signatures: zero.values().map(HashMap::len).sum::<usize>() as u32,
        special_block_assignments: generator_53_block_assignment_count(
            special.values().flat_map(HashMap::values),
        )?,
        zero_block_assignments: generator_53_block_assignment_count(
            zero.values().flat_map(HashMap::values),
        )?,
    })
}

/// Burnside census for the translations commuting with a linear multiplier.
/// Independent block translations preserve row sums and every PAF equation.
pub fn compile_translation_normalizer_census(
    generator: u32,
) -> Result<TranslationNormalizerCensus, Hadamard2092Error> {
    const CARRIER: u32 = 522;
    let partition = CyclicMultiplierOrbitPartition::compile(CARRIER, generator)?;
    let translations = gcd_u32(generator - 1, CARRIER);
    let mut special_sum = 0_u128;
    let mut zero_sum = 0_u128;
    let mut special_raw = 0_u128;
    let mut zero_raw = 0_u128;
    for index in 0..translations {
        let shift = index * (CARRIER / translations);
        let special = translation_fixed_subsets(&partition, shift, 260);
        let zero = translation_fixed_subsets(&partition, shift, 261);
        if index == 0 {
            special_raw = special;
            zero_raw = zero;
        }
        special_sum += special;
        zero_sum += zero;
    }
    assert_eq!(special_sum % u128::from(translations), 0);
    assert_eq!(zero_sum % u128::from(translations), 0);
    Ok(TranslationNormalizerCensus {
        generator,
        translations,
        special_raw,
        special_quotient: special_sum / u128::from(translations),
        zero_raw,
        zero_quotient: zero_sum / u128::from(translations),
    })
}

/// Burnside census for the common unit-dilation normalizer.
///
/// Every unit modulo 522 commutes with a linear multiplier. Applying the same
/// dilation to all four blocks preserves row sums and permutes the PAF
/// equations, hence preserves the complete GS system. The multiplier subgroup
/// already acts trivially on its invariant subsets, so the effective group is
/// `(Z/522Z)^x / <generator>`.
pub fn compile_unit_normalizer_census(
    generator: u32,
) -> Result<UnitNormalizerCensus, Hadamard2092Error> {
    const CARRIER: u32 = 522;
    let partition = CyclicMultiplierOrbitPartition::compile(CARRIER, generator)?;
    let mut subgroup = Vec::with_capacity(partition.generator_order() as usize);
    let mut power = 1_u32;
    loop {
        subgroup.push(power);
        power = ((u64::from(power) * u64::from(generator)) % u64::from(CARRIER)) as u32;
        if power == 1 {
            break;
        }
    }
    let mut covered = [false; CARRIER as usize];
    let mut representatives = Vec::with_capacity(14);
    for unit in 1..CARRIER {
        if gcd_u32(unit, CARRIER) != 1 || covered[unit as usize] {
            continue;
        }
        representatives.push(unit);
        for &element in &subgroup {
            covered[((u64::from(unit) * u64::from(element)) % u64::from(CARRIER)) as usize] = true;
        }
    }
    let quotient_units = representatives.len() as u32;
    let mut special_sum = 0_u128;
    let mut zero_sum = 0_u128;
    let mut special_raw = 0_u128;
    let mut zero_raw = 0_u128;
    for (index, &unit) in representatives.iter().enumerate() {
        let special = dilation_fixed_subsets(&partition, unit, 260);
        let zero = dilation_fixed_subsets(&partition, unit, 261);
        if index == 0 {
            special_raw = special;
            zero_raw = zero;
        }
        special_sum += special;
        zero_sum += zero;
    }
    assert_eq!(special_sum % u128::from(quotient_units), 0);
    assert_eq!(zero_sum % u128::from(quotient_units), 0);
    Ok(UnitNormalizerCensus {
        generator,
        quotient_units,
        special_raw,
        special_quotient: special_sum / u128::from(quotient_units),
        zero_raw,
        zero_quotient: zero_sum / u128::from(quotient_units),
    })
}

#[derive(Clone, Copy, Debug, Hash, PartialEq, Eq)]
struct RationalState {
    minus: u16,
    values: [i16; 3],
}

fn rational_orbit_weights(
    generator: u32,
    orders: &[u8],
) -> Result<Vec<(u16, [i16; 3])>, Hadamard2092Error> {
    const CARRIER: u32 = 522;
    let partition = CyclicMultiplierOrbitPartition::compile(CARRIER, generator)
        .expect("the fixed order-2092 multiplier is valid");
    let mut weights = vec![(0_u16, [0_i16; 3]); partition.orbit_count() as usize];
    let mut nuisance = vec![[[0_i16; 6]; 3]; partition.orbit_count() as usize];
    for point in 0..CARRIER {
        let orbit = partition.orbit_ids()[point as usize] as usize;
        weights[orbit].0 += 1;
        for (sector, &order) in orders.iter().enumerate() {
            let basis = cyclotomic_basis(order, point as usize % usize::from(order));
            weights[orbit].1[sector] += basis[0];
            for coordinate in 1..6 {
                nuisance[orbit][sector][coordinate] += basis[coordinate];
            }
        }
    }
    if nuisance.iter().any(|orbit| {
        orbit[..orders.len()]
            .iter()
            .any(|sector| sector[1..].iter().any(|&value| value != 0))
    }) {
        return Err(Hadamard2092Error::FixedField);
    }
    Ok(weights)
}

fn cyclotomic_basis(order: u8, exponent: usize) -> [i16; 6] {
    match order {
        2 => [if exponent & 1 == 0 { 1 } else { -1 }, 0, 0, 0, 0, 0],
        3 => [[1, 0, 0, 0, 0, 0], [0, 1, 0, 0, 0, 0], [-1, -1, 0, 0, 0, 0]][exponent],
        6 => [
            [1, 0, 0, 0, 0, 0],
            [0, 1, 0, 0, 0, 0],
            [-1, 1, 0, 0, 0, 0],
            [-1, 0, 0, 0, 0, 0],
            [0, -1, 0, 0, 0, 0],
            [1, -1, 0, 0, 0, 0],
        ][exponent],
        9 | 18 => {
            let mut powers = [[0_i16; 6]; 18];
            for power in 0..usize::from(order) {
                if power < 6 {
                    powers[power][power] = 1;
                } else {
                    let sign = if order == 9 { -1 } else { 1 };
                    let previous_three = powers[power - 3];
                    let previous_six = powers[power - 6];
                    for ((coordinate, value_three), value_six) in powers[power]
                        .iter_mut()
                        .zip(previous_three)
                        .zip(previous_six)
                    {
                        *coordinate = sign * value_three - value_six;
                    }
                }
            }
            powers[exponent]
        }
        _ => panic!("unsupported private rational character order"),
    }
}

fn rational_energy_distribution(
    weights: &[(u16, [i16; 3])],
    sectors: usize,
    minus_total: u16,
) -> Result<HashMap<[u16; 3], BigUint>, Hadamard2092Error> {
    const STATE_BUDGET: usize = 4_000_000;
    let mut states = HashMap::with_capacity(8_192);
    states.insert(
        RationalState {
            minus: 0,
            values: [0; 3],
        },
        BigUint::from(1_u8),
    );
    let mut additions = Vec::with_capacity(8_192);
    for &(size, values) in weights {
        additions.clear();
        for (state, count) in &states {
            if state.minus + size > minus_total {
                continue;
            }
            if additions.len() == STATE_BUDGET {
                return Err(Hadamard2092Error::FibreOverflow);
            }
            let mut next = *state;
            next.minus += size;
            for (next_value, &value) in next.values[..sectors].iter_mut().zip(&values[..sectors]) {
                *next_value += value;
            }
            additions.push((next, count.clone()));
        }
        for (state, count) in additions.drain(..) {
            if states.len() == STATE_BUDGET && !states.contains_key(&state) {
                return Err(Hadamard2092Error::FibreOverflow);
            }
            *states.entry(state).or_default() += count;
        }
    }
    let mut energies = HashMap::new();
    for (state, count) in states {
        if state.minus != minus_total {
            continue;
        }
        let mut key = [0_u16; 3];
        let mut admissible = true;
        for (target_energy, &value) in key[..sectors].iter_mut().zip(&state.values[..sectors]) {
            let value = i32::from(value);
            let energy = 4 * value * value;
            admissible &= energy <= 2092;
            *target_energy = energy as u16;
        }
        if admissible {
            *energies.entry(key).or_default() += count;
        }
    }
    Ok(energies)
}

fn labelled_four_block_count(
    special: &HashMap<[u16; 3], BigUint>,
    zero: &HashMap<[u16; 3], BigUint>,
    sectors: usize,
) -> BigUint {
    let left = rational_pair_distribution(special, zero, sectors);
    let right = rational_pair_distribution(zero, zero, sectors);
    let mut total = BigUint::default();
    for (key, count) in left {
        let mut residual = [0_u16; 3];
        for sector in 0..sectors {
            residual[sector] = 2092 - key[sector];
        }
        if let Some(matches) = right.get(&residual) {
            total += count * matches;
        }
    }
    total
}

fn rational_pair_distribution(
    left: &HashMap<[u16; 3], BigUint>,
    right: &HashMap<[u16; 3], BigUint>,
    sectors: usize,
) -> HashMap<[u16; 3], BigUint> {
    let mut pairs = HashMap::new();
    for (left_key, left_count) in left {
        for (right_key, right_count) in right {
            let mut key = [0_u16; 3];
            let mut admissible = true;
            for sector in 0..sectors {
                let energy = left_key[sector] + right_key[sector];
                admissible &= energy <= 2092;
                key[sector] = energy;
            }
            if admissible {
                *pairs.entry(key).or_default() += left_count * right_count;
            }
        }
    }
    pairs
}

fn canonical_four_block_profiles(
    special: &HashMap<[u16; 3], BigUint>,
    zero: &HashMap<[u16; 3], BigUint>,
    sectors: usize,
) -> Vec<[[u16; 3]; 4]> {
    let mut special_keys = special.keys().copied().collect::<Vec<_>>();
    special_keys.sort_unstable();
    let mut zero_keys = zero.keys().copied().collect::<Vec<_>>();
    zero_keys.sort_unstable();
    let zero_set = zero_keys.iter().copied().collect::<HashSet<_>>();
    let mut profiles = Vec::new();
    for a in special_keys {
        for (b_index, &b) in zero_keys.iter().enumerate() {
            for &c in &zero_keys[b_index..] {
                let mut d = [0_u16; 3];
                let mut admissible = true;
                for sector in 0..sectors {
                    let partial =
                        u32::from(a[sector]) + u32::from(b[sector]) + u32::from(c[sector]);
                    admissible &= partial <= 2092;
                    d[sector] = 2092_u16.wrapping_sub(partial as u16);
                }
                if admissible && d >= c && zero_set.contains(&d) {
                    profiles.push([a, b, c, d]);
                }
            }
        }
    }
    profiles
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Generator53BaseChoice {
    values: [i8; 3],
    multiplicity: u16,
}

type Generator53QuadraticDistribution = BTreeMap<(u16, i16), u128>;
type Generator53JointBlockDistribution = BTreeMap<[u16; 3], Generator53QuadraticDistribution>;

fn generator_53_block_assignment_count<'a>(
    mut counts: impl Iterator<Item = &'a u128>,
) -> Result<u128, Hadamard2092Error> {
    counts.try_fold(0_u128, |total, &count| {
        total
            .checked_add(count)
            .ok_or(Hadamard2092Error::ArithmeticOverflow)
    })
}

fn generator_53_base_choices() -> [Vec<Generator53BaseChoice>; 19] {
    // [selected size, q2 value, q3 value, q6 value] for the fixed points 0,9
    // and the negation pairs {r,-r}, 1 <= r <= 8, in Z/18Z.
    const ORBITS: [[i8; 4]; 10] = [
        [1, 1, 1, 1],
        [1, -1, 1, -1],
        [2, -2, -1, 1],
        [2, 2, -1, -1],
        [2, -2, 2, -2],
        [2, 2, -1, -1],
        [2, -2, -1, 1],
        [2, 2, 2, 2],
        [2, -2, -1, 1],
        [2, 2, -1, -1],
    ];
    let mut aggregated = BTreeMap::<(u8, [i8; 3]), u16>::new();
    for mask in 0_u16..1 << ORBITS.len() {
        let mut selected = 0_u8;
        let mut values = [0_i8; 3];
        for (orbit, weight) in ORBITS.iter().enumerate() {
            if mask & (1 << orbit) == 0 {
                continue;
            }
            selected += weight[0] as u8;
            for sector in 0..3 {
                values[sector] += weight[sector + 1];
            }
        }
        *aggregated.entry((selected, values)).or_default() += 1;
    }
    let mut choices: [Vec<Generator53BaseChoice>; 19] = std::array::from_fn(|_| Vec::new());
    for ((selected, values), multiplicity) in aggregated {
        choices[usize::from(selected)].push(Generator53BaseChoice {
            values,
            multiplicity,
        });
    }
    choices
}

fn generator_53_base_pair_distributions(
    choices: &[Vec<Generator53BaseChoice>; 19],
) -> Result<Vec<BTreeMap<[i16; 3], u64>>, Hadamard2092Error> {
    let mut pairs = Vec::with_capacity(19 * 19);
    for left in choices {
        for right in choices {
            let mut distribution = BTreeMap::<[i16; 3], u64>::new();
            for &left_choice in left {
                for &right_choice in right {
                    let values = std::array::from_fn(|sector| {
                        i16::from(left_choice.values[sector])
                            + i16::from(right_choice.values[sector])
                    });
                    let increment =
                        u64::from(left_choice.multiplicity) * u64::from(right_choice.multiplicity);
                    let count = distribution.entry(values).or_default();
                    *count = count
                        .checked_add(increment)
                        .ok_or(Hadamard2092Error::ArithmeticOverflow)?;
                }
            }
            pairs.push(distribution);
        }
    }
    Ok(pairs)
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Generator53DetailedPair {
    first_parity: i8,
    second_parity: i8,
    multiplicity: u64,
}

fn generator_53_detailed_base_pair_distributions(
    choices: &[Vec<Generator53BaseChoice>; 19],
) -> Result<Vec<BTreeMap<[i16; 3], Vec<Generator53DetailedPair>>>, Hadamard2092Error> {
    let mut pairs = Vec::with_capacity(19 * 19);
    for left in choices {
        for right in choices {
            let mut aggregated = BTreeMap::<([i16; 3], i8, i8), u64>::new();
            for &left_choice in left {
                for &right_choice in right {
                    let values = std::array::from_fn(|sector| {
                        i16::from(left_choice.values[sector])
                            + i16::from(right_choice.values[sector])
                    });
                    let increment =
                        u64::from(left_choice.multiplicity) * u64::from(right_choice.multiplicity);
                    let count = aggregated
                        .entry((values, left_choice.values[0], right_choice.values[0]))
                        .or_default();
                    *count = count
                        .checked_add(increment)
                        .ok_or(Hadamard2092Error::FibreOverflow)?;
                }
            }
            let mut distribution = BTreeMap::<[i16; 3], Vec<Generator53DetailedPair>>::new();
            for ((values, first_parity, second_parity), multiplicity) in aggregated {
                distribution
                    .entry(values)
                    .or_default()
                    .push(Generator53DetailedPair {
                        first_parity,
                        second_parity,
                        multiplicity,
                    });
            }
            pairs.push(distribution);
        }
    }
    Ok(pairs)
}

fn generator_53_joint_block_distribution(
    minus_total: u16,
    allowed_energies: &BTreeSet<[u16; 3]>,
    choices: &[Vec<Generator53BaseChoice>; 19],
    pairs: &[BTreeMap<[i16; 3], u64>],
) -> Result<Generator53JointBlockDistribution, Hadamard2092Error> {
    let signed_targets = allowed_energies
        .iter()
        .copied()
        .map(|energies| {
            generator_53_signed_rational_values(energies).map(|values| (energies, values))
        })
        .collect::<Result<Vec<_>, _>>()?;
    let mut distribution = allowed_energies
        .iter()
        .copied()
        .map(|energies| (energies, BTreeMap::new()))
        .collect::<Generator53JointBlockDistribution>();

    for fixed_selected in 0_u8..=18 {
        let Some(nonzero_selected) = minus_total.checked_sub(u16::from(fixed_selected)) else {
            continue;
        };
        if nonzero_selected % 7 != 0 {
            continue;
        }
        let nonzero_selected = nonzero_selected / 7;
        for n0 in 0_u8..=18 {
            for n1 in 0_u8..=18 {
                for n2 in 0_u8..=18 {
                    let partial = u16::from(n0) + u16::from(n1) + u16::from(n2);
                    let Some(n3) = nonzero_selected.checked_sub(partial) else {
                        continue;
                    };
                    if n3 > 18 {
                        continue;
                    }
                    let n3 = n3 as u8;
                    let Some((constant, radical)) =
                        generator_53_order_29_energy(fixed_selected, [n0, n1, n2, n3])
                    else {
                        continue;
                    };
                    if constant > 2092 {
                        continue;
                    }
                    let left_pairs = &pairs[usize::from(n0) * 19 + usize::from(n1)];
                    let right_pairs = &pairs[usize::from(n2) * 19 + usize::from(n3)];
                    for fixed_choice in &choices[usize::from(fixed_selected)] {
                        for &(energies, ref targets) in &signed_targets {
                            for target in targets {
                                let mut required = [0_i16; 3];
                                let mut compatible = true;
                                for sector in 0..3 {
                                    let difference =
                                        target[sector] - i16::from(fixed_choice.values[sector]);
                                    compatible &= difference % 7 == 0;
                                    required[sector] = difference / 7;
                                }
                                if !compatible {
                                    continue;
                                }
                                for (left_values, left_count) in left_pairs {
                                    let residual = std::array::from_fn(|sector| {
                                        required[sector] - left_values[sector]
                                    });
                                    let Some(right_count) = right_pairs.get(&residual) else {
                                        continue;
                                    };
                                    let increment = u128::from(fixed_choice.multiplicity)
                                        * u128::from(*left_count)
                                        * u128::from(*right_count);
                                    let count = distribution
                                        .get_mut(&energies)
                                        .expect("allowed energy key was precompiled")
                                        .entry((constant, radical))
                                        .or_default();
                                    *count = count
                                        .checked_add(increment)
                                        .ok_or(Hadamard2092Error::FibreOverflow)?;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Ok(distribution)
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Hash, PartialEq, Eq)]
struct Generator53DoubleQuadraticKey {
    constants: [u16; 2],
    radicals: [i16; 2],
}

const _: () = assert!(std::mem::size_of::<Generator53DoubleQuadraticKey>() == 8);

type Generator53DoubleQuadraticDistribution = HashMap<Generator53DoubleQuadraticKey, u128>;
type Generator53DoubleQuadraticBlockDistribution =
    BTreeMap<[u16; 3], Generator53DoubleQuadraticDistribution>;

fn generator_53_double_quadratic_block_distribution(
    minus_total: u16,
    allowed_energies: &BTreeSet<[u16; 3]>,
    choices: &[Vec<Generator53BaseChoice>; 19],
    pairs: &[BTreeMap<[i16; 3], Vec<Generator53DetailedPair>>],
) -> Result<Generator53DoubleQuadraticBlockDistribution, Hadamard2092Error> {
    const STATE_BUDGET: usize = 12_000_000;
    let signed_targets = allowed_energies
        .iter()
        .copied()
        .map(|energies| {
            generator_53_signed_rational_values(energies).map(|values| (energies, values))
        })
        .collect::<Result<Vec<_>, _>>()?;
    let mut distribution = allowed_energies
        .iter()
        .copied()
        .map(|energies| (energies, HashMap::new()))
        .collect::<Generator53DoubleQuadraticBlockDistribution>();
    let mut states = 0_usize;

    for fixed_selected in 0_u8..=18 {
        let Some(nonzero_selected) = minus_total.checked_sub(u16::from(fixed_selected)) else {
            continue;
        };
        if nonzero_selected % 7 != 0 {
            continue;
        }
        let nonzero_selected = nonzero_selected / 7;
        for n0 in 0_u8..=18 {
            for n1 in 0_u8..=18 {
                for n2 in 0_u8..=18 {
                    let partial = u16::from(n0) + u16::from(n1) + u16::from(n2);
                    let Some(n3) = nonzero_selected.checked_sub(partial) else {
                        continue;
                    };
                    if n3 > 18 {
                        continue;
                    }
                    let n3 = n3 as u8;
                    let Some(q29) = generator_53_order_29_energy(fixed_selected, [n0, n1, n2, n3])
                    else {
                        continue;
                    };
                    if q29.0 > 2092 {
                        continue;
                    }
                    let left_pairs = &pairs[usize::from(n0) * 19 + usize::from(n1)];
                    let right_pairs = &pairs[usize::from(n2) * 19 + usize::from(n3)];
                    for fixed_choice in &choices[usize::from(fixed_selected)] {
                        for &(energies, ref targets) in &signed_targets {
                            for target in targets {
                                let mut required = [0_i16; 3];
                                let mut compatible = true;
                                for sector in 0..3 {
                                    let difference =
                                        target[sector] - i16::from(fixed_choice.values[sector]);
                                    compatible &= difference % 7 == 0;
                                    required[sector] = difference / 7;
                                }
                                if !compatible {
                                    continue;
                                }
                                for (left_values, left_details) in left_pairs {
                                    let residual = std::array::from_fn(|sector| {
                                        required[sector] - left_values[sector]
                                    });
                                    let Some(right_details) = right_pairs.get(&residual) else {
                                        continue;
                                    };
                                    for left_detail in left_details {
                                        for right_detail in right_details {
                                            let Some(q58) = generator_53_order_58_energy(
                                                fixed_choice.values[0],
                                                [
                                                    left_detail.first_parity,
                                                    left_detail.second_parity,
                                                    right_detail.first_parity,
                                                    right_detail.second_parity,
                                                ],
                                            ) else {
                                                continue;
                                            };
                                            if q58.0 > 2092 {
                                                continue;
                                            }
                                            let key = Generator53DoubleQuadraticKey {
                                                constants: [q29.0, q58.0],
                                                radicals: [q29.1, q58.1],
                                            };
                                            let increment = u128::from(fixed_choice.multiplicity)
                                                * u128::from(left_detail.multiplicity)
                                                * u128::from(right_detail.multiplicity);
                                            let energy_distribution = distribution
                                                .get_mut(&energies)
                                                .expect("allowed energy key was precompiled");
                                            match energy_distribution.entry(key) {
                                                std::collections::hash_map::Entry::Vacant(
                                                    entry,
                                                ) => {
                                                    if states == STATE_BUDGET {
                                                        return Err(Hadamard2092Error::StateBudget);
                                                    }
                                                    states += 1;
                                                    entry.insert(increment);
                                                }
                                                std::collections::hash_map::Entry::Occupied(
                                                    mut entry,
                                                ) => {
                                                    *entry.get_mut() =
                                                        entry.get().checked_add(increment).ok_or(
                                                            Hadamard2092Error::ArithmeticOverflow,
                                                        )?;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Ok(distribution)
}

fn generator_53_signed_rational_values(
    energies: [u16; 3],
) -> Result<Vec<[i16; 3]>, Hadamard2092Error> {
    let mut roots = [0_i16; 3];
    for sector in 0..3 {
        if energies[sector] % 4 != 0 {
            return Err(Hadamard2092Error::FixedField);
        }
        let square = u32::from(energies[sector] / 4);
        let root = integer_sqrt_u32(square);
        if root * root != square {
            return Err(Hadamard2092Error::FixedField);
        }
        roots[sector] = root as i16;
    }
    let mut values = BTreeSet::new();
    for signs in 0_u8..8 {
        values.insert(std::array::from_fn(|sector| {
            if signs & (1 << sector) == 0 {
                roots[sector]
            } else {
                -roots[sector]
            }
        }));
    }
    Ok(values.into_iter().collect())
}

fn generator_53_order_29_energy(fixed: u8, coset_counts: [u8; 4]) -> Option<(u16, i16)> {
    generator_53_quadratic_energy(i16::from(fixed), coset_counts.map(i16::from))
}

fn generator_53_order_58_energy(fixed_parity: i8, coset_parities: [i8; 4]) -> Option<(u16, i16)> {
    let (constant, radical) =
        generator_53_quadratic_energy(i16::from(fixed_parity), coset_parities.map(i16::from))?;
    // Multiplication by 15 takes the displayed q29 cosets through a
    // nonresidue, swapping the two Gaussian periods.
    Some((constant, radical.checked_neg()?))
}

fn generator_53_quadratic_energy(fixed: i16, coset_counts: [i16; 4]) -> Option<(u16, i16)> {
    const COSETS: [[usize; 7]; 4] = [
        [1, 7, 16, 20, 23, 24, 25],
        [2, 3, 11, 14, 17, 19, 21],
        [4, 5, 6, 9, 13, 22, 28],
        [8, 10, 12, 15, 18, 26, 27],
    ];
    let mut coefficients = [0_i32; 29];
    coefficients[0] = i32::from(fixed);
    for (count, coset) in coset_counts.into_iter().zip(COSETS) {
        for residue in coset {
            coefficients[residue] = i32::from(count);
        }
    }
    let correlation = |shift: usize| {
        (0..29)
            .map(|index| coefficients[index] * coefficients[(index + shift) % 29])
            .sum::<i32>()
    };
    let c0 = correlation(0);
    let residue = correlation(1);
    let nonresidue = correlation(2);
    let constant = 2 * (2 * c0 - residue - nonresidue);
    let radical = 2 * (residue - nonresidue);
    Some((u16::try_from(constant).ok()?, i16::try_from(radical).ok()?))
}

#[derive(Clone, Copy, Debug, Hash, PartialEq, Eq)]
struct Generator53PairKey {
    energies: [u16; 3],
    constant: u16,
    radical: i16,
}

impl Generator53PairKey {
    fn residual(self) -> Option<Self> {
        Some(Self {
            energies: [
                2092_u16.checked_sub(self.energies[0])?,
                2092_u16.checked_sub(self.energies[1])?,
                2092_u16.checked_sub(self.energies[2])?,
            ],
            constant: 2092_u16.checked_sub(self.constant)?,
            radical: self.radical.checked_neg()?,
        })
    }
}

fn generator_53_joint_pair_distribution(
    left: &Generator53JointBlockDistribution,
    right: &Generator53JointBlockDistribution,
) -> Result<HashMap<Generator53PairKey, u128>, Hadamard2092Error> {
    let mut pairs = HashMap::<Generator53PairKey, u128>::new();
    for (left_energies, left_quadratic) in left {
        for (right_energies, right_quadratic) in right {
            let energies = [
                u32::from(left_energies[0]) + u32::from(right_energies[0]),
                u32::from(left_energies[1]) + u32::from(right_energies[1]),
                u32::from(left_energies[2]) + u32::from(right_energies[2]),
            ];
            if energies.iter().any(|&energy| energy > 2092) {
                continue;
            }
            for (&(left_constant, left_radical), &left_count) in left_quadratic {
                for (&(right_constant, right_radical), &right_count) in right_quadratic {
                    let constant = u32::from(left_constant) + u32::from(right_constant);
                    if constant > 2092 {
                        continue;
                    }
                    let key = Generator53PairKey {
                        energies: energies.map(|energy| energy as u16),
                        constant: constant as u16,
                        radical: left_radical
                            .checked_add(right_radical)
                            .ok_or(Hadamard2092Error::FibreOverflow)?,
                    };
                    let increment = left_count
                        .checked_mul(right_count)
                        .ok_or(Hadamard2092Error::FibreOverflow)?;
                    let count = pairs.entry(key).or_default();
                    *count = count
                        .checked_add(increment)
                        .ok_or(Hadamard2092Error::FibreOverflow)?;
                }
            }
        }
    }
    Ok(pairs)
}

#[derive(Clone, Copy, Debug, Hash, PartialEq, Eq)]
struct Generator53DoubleSectorPairKey {
    constants: [u16; 2],
    radicals: [i16; 2],
}

impl Generator53DoubleSectorPairKey {
    fn residual(self) -> Option<Self> {
        Some(Self {
            constants: [
                2092_u16.checked_sub(self.constants[0])?,
                2092_u16.checked_sub(self.constants[1])?,
            ],
            radicals: [
                self.radicals[0].checked_neg()?,
                self.radicals[1].checked_neg()?,
            ],
        })
    }
}

fn generator_53_double_quadratic_sector_pair_distribution(
    left: &Generator53DoubleQuadraticDistribution,
    right: &Generator53DoubleQuadraticDistribution,
) -> Result<HashMap<Generator53DoubleSectorPairKey, u128>, Hadamard2092Error> {
    const STATE_BUDGET: usize = 12_000_000;
    let mut pairs = HashMap::<Generator53DoubleSectorPairKey, u128>::new();
    for (left_key, &left_count) in left {
        for (right_key, &right_count) in right {
            let constants = [
                u32::from(left_key.constants[0]) + u32::from(right_key.constants[0]),
                u32::from(left_key.constants[1]) + u32::from(right_key.constants[1]),
            ];
            if constants.iter().any(|&constant| constant > 2092) {
                continue;
            }
            let key = Generator53DoubleSectorPairKey {
                constants: constants.map(|constant| constant as u16),
                radicals: [
                    left_key.radicals[0]
                        .checked_add(right_key.radicals[0])
                        .ok_or(Hadamard2092Error::ArithmeticOverflow)?,
                    left_key.radicals[1]
                        .checked_add(right_key.radicals[1])
                        .ok_or(Hadamard2092Error::ArithmeticOverflow)?,
                ],
            };
            let increment = left_count
                .checked_mul(right_count)
                .ok_or(Hadamard2092Error::ArithmeticOverflow)?;
            if !pairs.contains_key(&key) && pairs.len() == STATE_BUDGET {
                return Err(Hadamard2092Error::StateBudget);
            }
            let count = pairs.entry(key).or_default();
            *count = count
                .checked_add(increment)
                .ok_or(Hadamard2092Error::ArithmeticOverflow)?;
        }
    }
    Ok(pairs)
}

fn integer_sqrt_u32(value: u32) -> u32 {
    let mut root = (f64::from(value).sqrt()) as u32;
    while root > value / root.max(1) {
        root -= 1;
    }
    while root < u32::MAX && root + 1 <= value / (root + 1) {
        root += 1;
    }
    root
}

fn binomial_u128(n: usize, k: usize) -> u128 {
    let k = k.min(n - k);
    let mut value = 1_u128;
    for divisor in 1..=k {
        value = value * (n - k + divisor) as u128 / divisor as u128;
    }
    value
}

#[derive(Clone, Copy)]
struct Generator91ClassChoice {
    fixed: u8,
    nonzero: u8,
    balance: i8,
    selected: u16,
    multiplicity: u64,
}

fn generator_91_order_three_twenty_nine_distribution(
    fixed_total: u8,
) -> BTreeMap<(u16, u16, i16), BigUint> {
    let mut choices = Vec::with_capacity(7 * 7 * 7);
    for fixed in 0..=6 {
        for residues in 0..=6 {
            for nonresidues in 0..=6 {
                choices.push(Generator91ClassChoice {
                    fixed,
                    nonzero: residues + nonresidues,
                    balance: residues as i8 - nonresidues as i8,
                    selected: u16::from(fixed) + 14 * u16::from(residues + nonresidues),
                    multiplicity: (binomial_u128(6, fixed as usize)
                        * binomial_u128(6, residues as usize)
                        * binomial_u128(6, nonresidues as usize))
                        as u64,
                });
            }
        }
    }
    let mut energies = BTreeMap::<(u16, u16, i16), BigUint>::new();
    for &zero in &choices {
        for &one in &choices {
            let fixed_partial = zero.fixed + one.fixed;
            let nonzero_partial = zero.nonzero + one.nonzero;
            if fixed_partial > fixed_total || nonzero_partial > 18 {
                continue;
            }
            for &two in &choices {
                if fixed_partial + two.fixed != fixed_total || nonzero_partial + two.nonzero != 18 {
                    continue;
                }
                let u = i32::from(zero.selected) - i32::from(two.selected);
                let v = i32::from(one.selected) - i32::from(two.selected);
                let energy_three = 4 * (u * u - u * v + v * v);
                let rational = 2 * i16::from(fixed_total) - 18;
                let radical = i16::from(zero.balance + one.balance + two.balance);
                let constant = rational * rational + 29 * radical * radical;
                if energy_three > 2092 || constant > 2092 {
                    continue;
                }
                let multiplicity = u128::from(zero.multiplicity)
                    * u128::from(one.multiplicity)
                    * u128::from(two.multiplicity);
                *energies
                    .entry((energy_three as u16, constant as u16, 2 * rational * radical))
                    .or_default() += multiplicity;
            }
        }
    }
    energies
}

fn quadratic_eisenstein_pair_distribution(
    left: &BTreeMap<(u16, u16, i16), BigUint>,
    right: &BTreeMap<(u16, u16, i16), BigUint>,
) -> BTreeMap<(u16, u16, i16), BigUint> {
    let mut pairs = BTreeMap::<(u16, u16, i16), BigUint>::new();
    for (&(left_three, left_constant, left_radical), left_count) in left {
        for (&(right_three, right_constant, right_radical), right_count) in right {
            let three = u32::from(left_three) + u32::from(right_three);
            let constant = u32::from(left_constant) + u32::from(right_constant);
            if three <= 2092 && constant <= 2092 {
                *pairs
                    .entry((three as u16, constant as u16, left_radical + right_radical))
                    .or_default() += left_count * right_count;
            }
        }
    }
    pairs
}

fn quadratic_eisenstein_four_block_count(
    special: &BTreeMap<(u16, u16, i16), BigUint>,
    zero: &BTreeMap<(u16, u16, i16), BigUint>,
) -> BigUint {
    let left = quadratic_eisenstein_pair_distribution(special, zero);
    let right = quadratic_eisenstein_pair_distribution(zero, zero);
    let mut total = BigUint::default();
    for ((three, constant, radical), count) in left {
        if let Some(matches) = right.get(&(2092 - three, 2092 - constant, -radical)) {
            total += count * matches;
        }
    }
    total
}

fn quadratic_eisenstein_canonical_profiles(
    special: &BTreeMap<(u16, u16, i16), BigUint>,
    zero: &BTreeMap<(u16, u16, i16), BigUint>,
) -> u64 {
    let zeros = zero.keys().copied().collect::<Vec<_>>();
    let mut profiles = 0_u64;
    for &(a_three, a_constant, a_radical) in special.keys() {
        for (b_index, &(b_three, b_constant, b_radical)) in zeros.iter().enumerate() {
            for &(c_three, c_constant, c_radical) in &zeros[b_index..] {
                let three = u32::from(a_three) + u32::from(b_three) + u32::from(c_three);
                let constant =
                    u32::from(a_constant) + u32::from(b_constant) + u32::from(c_constant);
                if three > 2092 || constant > 2092 {
                    continue;
                }
                let d = (
                    (2092 - three) as u16,
                    (2092 - constant) as u16,
                    -a_radical - b_radical - c_radical,
                );
                if d >= (c_three, c_constant, c_radical) && zero.contains_key(&d) {
                    profiles += 1;
                }
            }
        }
    }
    profiles
}

fn generator_133_order_nine_distribution(minus_total: usize) -> BTreeMap<u16, BigUint> {
    let mut class_counts = [0_u128; 59];
    for fixed in 0..=2 {
        for quartets in 0..=14 {
            class_counts[fixed + 4 * quartets] +=
                binomial_u128(2, fixed) * binomial_u128(14, quartets);
        }
    }
    let mut neutral_counts = [0_u128; 523];
    for triples in 0..=4 {
        for dodecads in 0..=28 {
            let selected = 3 * triples + 12 * dodecads;
            neutral_counts[selected] += binomial_u128(4, triples) * binomial_u128(28, dodecads);
        }
    }
    let mut energies = BTreeMap::<u16, BigUint>::new();
    for n0 in 0..class_counts.len() {
        if class_counts[n0] == 0 {
            continue;
        }
        for n3 in 0..class_counts.len() {
            if class_counts[n3] == 0 {
                continue;
            }
            for n6 in 0..class_counts.len() {
                let selected = n0 + n3 + n6;
                if class_counts[n6] == 0 || selected > minus_total {
                    continue;
                }
                let neutral = neutral_counts[minus_total - selected];
                if neutral == 0 {
                    continue;
                }
                let u = n0 as i32 - n6 as i32;
                let v = n3 as i32 - n6 as i32;
                let energy = 4 * (u * u - u * v + v * v);
                if energy > 2092 {
                    continue;
                }
                let multiplicity = BigUint::from(class_counts[n0])
                    * BigUint::from(class_counts[n3])
                    * BigUint::from(class_counts[n6])
                    * BigUint::from(neutral);
                *energies.entry(energy as u16).or_default() += multiplicity;
            }
        }
    }
    energies
}

fn generator_133_order_three_nine_distribution(
    minus_total: usize,
) -> BTreeMap<(u16, u16), BigUint> {
    let mut class_counts = [0_u128; 59];
    for fixed in 0..=2 {
        for quartets in 0..=14 {
            class_counts[fixed + 4 * quartets] +=
                binomial_u128(2, fixed) * binomial_u128(14, quartets);
        }
    }
    let mut primitive_counts = [0_u128; 175];
    for triples in 0..=2 {
        for dodecads in 0..=14 {
            primitive_counts[3 * triples + 12 * dodecads] +=
                binomial_u128(2, triples) * binomial_u128(14, dodecads);
        }
    }
    let mut divisor_classes = BTreeMap::<(u16, u16), BigUint>::new();
    for n0 in 0..class_counts.len() {
        if class_counts[n0] == 0 {
            continue;
        }
        for n3 in 0..class_counts.len() {
            if class_counts[n3] == 0 {
                continue;
            }
            for n6 in 0..class_counts.len() {
                if class_counts[n6] == 0 {
                    continue;
                }
                let u = n0 as i32 - n6 as i32;
                let v = n3 as i32 - n6 as i32;
                let energy_nine = 4 * (u * u - u * v + v * v);
                if energy_nine > 2092 {
                    continue;
                }
                let multiplicity = BigUint::from(class_counts[n0])
                    * BigUint::from(class_counts[n3])
                    * BigUint::from(class_counts[n6]);
                *divisor_classes
                    .entry(((n0 + n3 + n6) as u16, energy_nine as u16))
                    .or_default() += multiplicity;
            }
        }
    }
    let mut energies = BTreeMap::<(u16, u16), BigUint>::new();
    for (&(residue_zero, energy_nine), class_count) in &divisor_classes {
        for (residue_one, &one_count) in primitive_counts.iter().enumerate() {
            if one_count == 0 || usize::from(residue_zero) + residue_one > minus_total {
                continue;
            }
            let residue_two = minus_total - usize::from(residue_zero) - residue_one;
            let Some(&two_count) = primitive_counts.get(residue_two) else {
                continue;
            };
            if two_count == 0 {
                continue;
            }
            let u = i32::from(residue_zero) - residue_two as i32;
            let v = residue_one as i32 - residue_two as i32;
            let energy_three = 4 * (u * u - u * v + v * v);
            if energy_three > 2092 {
                continue;
            }
            *energies
                .entry((energy_three as u16, energy_nine))
                .or_default() += class_count * one_count * two_count;
        }
    }
    energies
}

fn joint_eisenstein_pair_distribution(
    left: &BTreeMap<(u16, u16), BigUint>,
    right: &BTreeMap<(u16, u16), BigUint>,
) -> BTreeMap<(u16, u16), BigUint> {
    let mut pairs = BTreeMap::<(u16, u16), BigUint>::new();
    for (&(left_three, left_nine), left_count) in left {
        for (&(right_three, right_nine), right_count) in right {
            let three = u32::from(left_three) + u32::from(right_three);
            let nine = u32::from(left_nine) + u32::from(right_nine);
            if three <= 2092 && nine <= 2092 {
                *pairs.entry((three as u16, nine as u16)).or_default() += left_count * right_count;
            }
        }
    }
    pairs
}

fn joint_eisenstein_four_block_count(
    special: &BTreeMap<(u16, u16), BigUint>,
    zero: &BTreeMap<(u16, u16), BigUint>,
) -> BigUint {
    let left = joint_eisenstein_pair_distribution(special, zero);
    let right = joint_eisenstein_pair_distribution(zero, zero);
    let mut total = BigUint::default();
    for ((three, nine), count) in left {
        if let Some(matches) = right.get(&(2092 - three, 2092 - nine)) {
            total += count * matches;
        }
    }
    total
}

fn joint_eisenstein_canonical_profiles(
    special: &BTreeMap<(u16, u16), BigUint>,
    zero: &BTreeMap<(u16, u16), BigUint>,
) -> u64 {
    let zeros = zero.keys().copied().collect::<Vec<_>>();
    let mut profiles = 0_u64;
    for &(a_three, a_nine) in special.keys() {
        for (b_index, &(b_three, b_nine)) in zeros.iter().enumerate() {
            for &(c_three, c_nine) in &zeros[b_index..] {
                let three = u32::from(a_three) + u32::from(b_three) + u32::from(c_three);
                let nine = u32::from(a_nine) + u32::from(b_nine) + u32::from(c_nine);
                if three > 2092 || nine > 2092 {
                    continue;
                }
                let d = ((2092 - three) as u16, (2092 - nine) as u16);
                if d >= (c_three, c_nine) && zero.contains_key(&d) {
                    profiles += 1;
                }
            }
        }
    }
    profiles
}

fn single_character_four_block_count(
    special: &BTreeMap<u16, BigUint>,
    zero: &BTreeMap<u16, BigUint>,
) -> BigUint {
    let mut total = BigUint::default();
    for (&a, a_count) in special {
        for (&b, b_count) in zero {
            for (&c, c_count) in zero {
                let partial = u32::from(a) + u32::from(b) + u32::from(c);
                if partial > 2092 {
                    break;
                }
                let d = (2092 - partial) as u16;
                if let Some(d_count) = zero.get(&d) {
                    total += a_count * b_count * c_count * d_count;
                }
            }
        }
    }
    total
}

fn single_character_canonical_profiles(
    special: &BTreeMap<u16, BigUint>,
    zero: &BTreeMap<u16, BigUint>,
) -> u64 {
    let mut profiles = 0_u64;
    for &a in special.keys() {
        for &b in zero.keys() {
            for c in zero.range(b..).map(|(&energy, _)| energy) {
                let partial = u32::from(a) + u32::from(b) + u32::from(c);
                if partial > 2092 {
                    break;
                }
                let d = (2092 - partial) as u16;
                if d >= c && zero.contains_key(&d) {
                    profiles += 1;
                }
            }
        }
    }
    profiles
}

fn translation_fixed_subsets(
    partition: &CyclicMultiplierOrbitPartition,
    shift: u32,
    target: usize,
) -> u128 {
    let orbit_count = partition.orbit_count() as usize;
    let mut permutation = vec![0_usize; orbit_count];
    for (orbit, &representative) in partition.representatives().iter().enumerate() {
        permutation[orbit] =
            partition.orbit_ids()[((representative + shift) % 522) as usize] as usize;
    }
    let mut visited = vec![false; orbit_count];
    let mut cycle_weights = Vec::new();
    for start in 0..orbit_count {
        if visited[start] {
            continue;
        }
        let mut current = start;
        let mut weight = 0_usize;
        while !visited[current] {
            visited[current] = true;
            weight += partition.orbit_sizes()[current] as usize;
            current = permutation[current];
        }
        assert_eq!(current, start);
        cycle_weights.push(weight);
    }
    let mut counts = vec![0_u128; target + 1];
    counts[0] = 1;
    for weight in cycle_weights {
        for total in (weight..=target).rev() {
            counts[total] += counts[total - weight];
        }
    }
    counts[target]
}

fn dilation_fixed_subsets(
    partition: &CyclicMultiplierOrbitPartition,
    unit: u32,
    target: usize,
) -> u128 {
    let orbit_count = partition.orbit_count() as usize;
    let mut permutation = vec![0_usize; orbit_count];
    for (orbit, &representative) in partition.representatives().iter().enumerate() {
        let image = ((u64::from(unit) * u64::from(representative)) % 522) as usize;
        permutation[orbit] = partition.orbit_ids()[image] as usize;
    }
    let mut visited = vec![false; orbit_count];
    let mut counts = vec![0_u128; target + 1];
    counts[0] = 1;
    for start in 0..orbit_count {
        if visited[start] {
            continue;
        }
        let mut current = start;
        let mut weight = 0_usize;
        while !visited[current] {
            visited[current] = true;
            weight += partition.orbit_sizes()[current] as usize;
            current = permutation[current];
        }
        assert_eq!(current, start);
        for total in (weight..=target).rev() {
            counts[total] += counts[total - weight];
        }
    }
    counts[target]
}

fn gcd_u32(mut left: u32, mut right: u32) -> u32 {
    while right != 0 {
        (left, right) = (right, left % right);
    }
    left
}

fn marginal_index(rows: [i8; 2], columns: [i8; 3]) -> Option<usize> {
    let r0 = odd_index(rows[0], 9)?;
    let r1 = odd_index(rows[1], 9)?;
    let c0 = even_index(columns[0], 6)?;
    let c1 = even_index(columns[1], 6)?;
    let c2 = even_index(columns[2], 6)?;
    Some(
        ((((r0 * ROW_VALUES + r1) * COLUMN_VALUES + c0) * COLUMN_VALUES + c1) * COLUMN_VALUES) + c2,
    )
}

fn odd_index(value: i8, bound: i8) -> Option<usize> {
    (value.abs() <= bound && value & 1 != 0).then_some(((value + bound) / 2) as usize)
}

fn even_index(value: i8, bound: i8) -> Option<usize> {
    (value.abs() <= bound && value & 1 == 0).then_some(((value + bound) / 2) as usize)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn joint_marginal_table_matches_exact_fibre_counts() {
        let table = JointD9D6MarginalTable::compile().unwrap();
        assert_eq!(table.compatible_signature_count(), 1_666);
        assert_eq!(table.fibres([9, 9], [6, 6, 6]), 1);
        assert_eq!(table.fibres([1, 1], [0, 0, 2]), 10);
        assert_eq!(table.fibres([1, -1], [0, 0, 0]), 12);
        assert_eq!(table.fibres([1, 1], [0, 0, 0]), 0);
    }

    #[test]
    fn bordered_pair_residual_uses_caller_storage() {
        let mut output = [0; 2];
        write_bordered_pair_residual(&[0, 8], &mut output).unwrap();
        assert_eq!(output, [-4, -12]);
    }

    #[test]
    fn generator_41_order_nine_fixed_field_has_seven_profiles() {
        let profiles = compile_generator_41_order_nine_profiles();
        assert_eq!(profiles.len(), 7);
        assert_eq!(profiles[0], [4, 0, 324, 1764]);
        assert_eq!(profiles[6], [1444, 36, 36, 576]);
    }

    #[test]
    fn generator_53_joint_rational_sectors_match_exact_census() {
        let baseline = compile_rational_joint_character_census(53, &[2, 3]).unwrap();
        let joint = compile_rational_joint_character_census(53, &[2, 3, 6]).unwrap();
        assert_eq!(
            baseline.labelled_assignments.to_string(),
            "572849117221667545326815648911695209150545920"
        );
        assert_eq!(joint.canonical_profiles, 4);
        assert_eq!(
            joint.profiles.as_ref(),
            &[
                [[0, 4, 36], [4, 1764, 1156], [324, 324, 324], [1764, 0, 576]],
                [
                    [0, 4, 36],
                    [324, 0, 576],
                    [324, 1764, 36],
                    [1444, 324, 1444]
                ],
                [[0, 1156, 1764], [4, 36, 4], [324, 324, 324], [1764, 576, 0]],
                [
                    [1600, 4, 676],
                    [100, 1764, 196],
                    [196, 0, 1024],
                    [196, 324, 196]
                ],
            ]
        );
        assert_eq!(
            joint.labelled_assignments.to_string(),
            "485809675336267569788580842066841352273920"
        );
    }

    #[test]
    fn generator_53_crt_table_matches_direct_orbit_enumeration() {
        const ORDERS: [u8; 3] = [2, 3, 6];
        const COSETS: [[u32; 7]; 4] = [
            [1, 7, 16, 20, 23, 24, 25],
            [2, 3, 11, 14, 17, 19, 21],
            [4, 5, 6, 9, 13, 22, 28],
            [8, 10, 12, 15, 18, 26, 27],
        ];
        let partition = CyclicMultiplierOrbitPartition::compile(522, 53).unwrap();
        let mut direct: [Vec<(u8, [i8; 3])>; 5] = std::array::from_fn(|_| Vec::new());
        for orbit in 0..partition.orbit_count() as usize {
            let representative = partition.representatives()[orbit];
            let residue = representative % 29;
            let family = if residue == 0 {
                0
            } else {
                1 + COSETS
                    .iter()
                    .position(|coset| coset.contains(&residue))
                    .unwrap()
            };
            let scale = if family == 0 { 1_i16 } else { 7_i16 };
            let size = partition.orbit_sizes()[orbit] as i16;
            let mut values = [0_i16; 3];
            let mut nuisance = [[0_i16; 6]; 3];
            for point in 0..522_u32 {
                if partition.orbit_ids()[point as usize] as usize != orbit {
                    continue;
                }
                for (sector, order) in ORDERS.into_iter().enumerate() {
                    let basis = cyclotomic_basis(order, point as usize % usize::from(order));
                    values[sector] += basis[0];
                    for coordinate in 1..6 {
                        nuisance[sector][coordinate] += basis[coordinate];
                    }
                }
            }
            assert!(nuisance.iter().flatten().all(|&value| value == 0));
            assert_eq!(size % scale, 0);
            assert!(values.iter().all(|value| value % scale == 0));
            direct[family].push((
                (size / scale) as u8,
                values.map(|value| (value / scale) as i8),
            ));
        }

        let structural = generator_53_base_choices();
        let structural = structural
            .iter()
            .enumerate()
            .flat_map(|(selected, choices)| {
                choices
                    .iter()
                    .map(move |choice| ((selected as u8, choice.values), choice.multiplicity))
            })
            .collect::<BTreeMap<_, _>>();
        for family in direct {
            assert_eq!(family.len(), 10);
            let mut observed = BTreeMap::<(u8, [i8; 3]), u16>::new();
            for mask in 0_u16..1 << family.len() {
                let mut selected = 0_u8;
                let mut values = [0_i8; 3];
                for (orbit, &(size, orbit_values)) in family.iter().enumerate() {
                    if mask & (1 << orbit) != 0 {
                        selected += size;
                        for sector in 0..3 {
                            values[sector] += orbit_values[sector];
                        }
                    }
                }
                *observed.entry((selected, values)).or_default() += 1;
            }
            assert_eq!(observed, structural);
        }
    }

    #[test]
    fn generator_53_joint_q29_census_has_locked_exact_count() {
        let census = compile_generator_53_order_two_three_six_twenty_nine_census().unwrap();
        assert_eq!(census.rational_profiles, 4);
        assert_eq!(census.special_joint_signatures, 1_680);
        assert_eq!(census.zero_joint_signatures, 4_243);
        assert_eq!(
            census.labelled_assignments.to_string(),
            "64949798014649517492352112253500547072"
        );
    }

    #[test]
    fn generator_41_joint_order_nine_eighteen_matches_exact_census() {
        let baseline = compile_rational_joint_character_census(41, &[9]).unwrap();
        let joint = compile_rational_joint_character_census(41, &[9, 18]).unwrap();
        assert_eq!(baseline.canonical_profiles, 7);
        assert_eq!(joint.canonical_profiles, 387);
        assert_eq!(
            baseline.labelled_assignments.to_string(),
            "1332580562804244053999025176733560297539077230256871042175425367462033884231680000"
        );
        assert_eq!(
            joint.labelled_assignments.to_string(),
            "3607165718254718538574880781673168473605405212818997016633907986045061497280000"
        );
    }

    #[test]
    fn generator_91_quadratic_sector_has_two_profiles() {
        let census = compile_generator_91_order_29_census().unwrap();
        assert_eq!(census.special_energy_signatures, 9);
        assert_eq!(census.zero_energy_signatures, 5);
        assert_eq!(census.canonical_profiles, 2);
        assert_eq!(
            census.profiles.as_ref(),
            [[4, 0, 1044, 1044], [4, 116, 116, 1856]]
        );
        assert_eq!(
            census.labelled_assignments.to_string(),
            "116847377220225897454518661703070781429591990704537600000"
        );
    }

    #[test]
    fn generator_133_order_nine_structural_censuses_match_oracle() {
        let order_nine = compile_generator_133_order_nine_census();
        assert_eq!(order_nine.special_energy_signatures, 96);
        assert_eq!(order_nine.zero_energy_signatures, 59);
        assert_eq!(order_nine.canonical_profiles, 5_240);
        assert_eq!(
            order_nine.labelled_assignments.to_string(),
            "167803349527133921334156643488482700508920819465962831847348767798762276030735324160000"
        );

        let joint = compile_generator_133_order_three_nine_census();
        assert_eq!(joint.special_energy_signatures, 963);
        assert_eq!(joint.zero_energy_signatures, 289);
        assert_eq!(joint.canonical_profiles, 36_497);
        assert_eq!(
            joint.labelled_assignments.to_string(),
            "20721970203808936294246865471574389263541895011040695368732066488837326457966428160"
        );
    }

    #[test]
    fn generator_91_joint_order_three_twenty_nine_matches_oracle() {
        let census = compile_generator_91_order_three_twenty_nine_census();
        assert_eq!(census.special_energy_signatures, 180);
        assert_eq!(census.zero_energy_signatures, 70);
        assert_eq!(census.canonical_profiles, 210);
        assert_eq!(
            census.labelled_assignments.to_string(),
            "2219296829882121440753959304564483886881107968000000"
        );
    }

    #[test]
    fn translation_normalizers_match_burnside_census() {
        let expected = [(41, 2), (133, 6), (53, 2), (91, 18)];
        for (generator, translations) in expected {
            let census = compile_translation_normalizer_census(generator).unwrap();
            assert_eq!(census.translations, translations);
            assert!(census.special_quotient < census.special_raw);
            assert!(census.zero_quotient < census.zero_raw);
        }
        let strongest = compile_translation_normalizer_census(91).unwrap();
        assert_eq!(strongest.special_raw, 397_109_770_457_400);
        assert_eq!(strongest.special_quotient, 22_061_654_254_640);
        assert_eq!(strongest.zero_raw, 441_233_078_286_000);
        assert_eq!(strongest.zero_quotient, 24_512_948_795_724);
    }

    #[test]
    fn common_unit_normalizers_reduce_every_surviving_root() {
        let expected = [(41, 14), (133, 14), (53, 12), (91, 12)];
        for (generator, quotient_units) in expected {
            let census = compile_unit_normalizer_census(generator).unwrap();
            assert_eq!(census.quotient_units, quotient_units);
            assert!(census.special_quotient < census.special_raw);
            assert!(census.zero_quotient < census.zero_raw);
        }
    }

    #[test]
    fn small_orbit_partitions_match_direct_closure() {
        for carrier in 2..=48_u32 {
            for generator in 1..carrier {
                if gcd_u32(generator, carrier) != 1 {
                    continue;
                }
                let partition =
                    CyclicMultiplierOrbitPartition::compile(carrier, generator).unwrap();
                for point in 0..carrier {
                    let mut expected = HashSet::new();
                    let mut image = point;
                    loop {
                        expected.insert(image);
                        image = generator * image % carrier;
                        if image == point {
                            break;
                        }
                    }
                    let orbit = partition.orbit_of(point).unwrap();
                    let actual = (0..carrier)
                        .filter(|&candidate| partition.orbit_of(candidate) == Some(orbit))
                        .collect::<HashSet<_>>();
                    assert_eq!(actual, expected, "carrier={carrier} generator={generator}");
                }
            }
        }
        assert!(CyclicMultiplierOrbitPartition::compile(0, 0).is_err());
        assert!(CyclicMultiplierOrbitPartition::compile(523, 1).is_err());
    }
}
