//! Exact energy-conditioned interval relaxation for four q29 profile blocks.

use serde::Serialize;

use crate::g41_q29_exact_tablebase::G41Q29ExactProfile;

const COORDINATES: usize = 7;
const MAX_ENERGY: usize = 3_661;
const DEFECT_TARGET: u16 = 523;
const FULL_SCOPE: u8 = (1 << COORDINATES) - 1;
const DEFECT_WORDS: usize = 9;
const PAIR_SUM_WORDS: usize = 17;

#[repr(C)]
#[derive(Clone, Copy)]
struct EnergyBox {
    minimum: [u16; COORDINATES],
    maximum: [u16; COORDINATES],
    energy: u16,
    present: u8,
    _pad: u8,
}

const _: () =
    assert!(std::mem::size_of::<EnergyBox>() == 32 && std::mem::align_of::<EnergyBox>() == 2);

impl Default for EnergyBox {
    fn default() -> Self {
        Self {
            minimum: [u16::MAX; COORDINATES],
            maximum: [0; COORDINATES],
            energy: 0,
            present: 0,
            _pad: 0,
        }
    }
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29EnergyBoxReport {
    pub energy_supports: [u16; 3],
    pub exact_energy_quadruples: u64,
    pub surviving_full_scope_quadruples: u64,
    pub best_scope_mask: u8,
    pub best_scope_coordinates: u8,
    pub best_scope_survivors: u64,
    pub survivors_by_scope: Box<[u64]>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29EnergyFibreReport {
    pub energy_supports: [u16; 3],
    pub exact_energy_quadruples: u64,
    pub surviving_full_scope_quadruples: u64,
    pub best_scope_mask: u8,
    pub best_scope_coordinates: u8,
    pub best_scope_survivors: u64,
    pub survivors_by_scope: Box<[u64]>,
    pub pair_sum_bytes: u64,
    pub provenance: &'static str,
}

struct EnergyCoordinateSupports {
    energies: Box<[u16]>,
    index_by_energy: Box<[u16]>,
    bits: Box<[u64]>,
}

struct CoordinatePairSums {
    right_len: usize,
    bits: Box<[u64]>,
}

fn compile_boxes(profiles: &[G41Q29ExactProfile], boxes: &mut [EnergyBox; MAX_ENERGY + 1]) {
    for profile in profiles {
        let mut values = [0_u16; COORDINATES];
        for coordinate in 0..COORDINATES {
            values[coordinate] = profile.coordinate(coordinate);
        }
        let energy = values.iter().sum::<u16>();
        let bucket = &mut boxes[usize::from(energy)];
        if bucket.present == 0 {
            bucket.energy = energy;
            bucket.present = 1;
        }
        for coordinate in 0..COORDINATES {
            bucket.minimum[coordinate] = bucket.minimum[coordinate].min(values[coordinate]);
            bucket.maximum[coordinate] = bucket.maximum[coordinate].max(values[coordinate]);
        }
    }
}

fn support_into(boxes: &[EnergyBox; MAX_ENERGY + 1], output: &mut [u16; MAX_ENERGY + 1]) -> usize {
    let mut length = 0;
    for (energy, bucket) in boxes.iter().enumerate() {
        if bucket.present != 0 {
            output[length] = energy as u16;
            length += 1;
        }
    }
    length
}

fn enumerate_box_join(
    boxes: [&[EnergyBox; MAX_ENERGY + 1]; 3],
    supports: [&[u16]; 3],
    survivors_by_scope: &mut [u64; 128],
) -> u64 {
    survivors_by_scope.fill(0);
    let mut quadruples = 0_u64;
    for &energy_a in supports[0] {
        for &energy_c in supports[2] {
            let partial = energy_a + energy_c;
            if partial > MAX_ENERGY as u16 {
                continue;
            }
            let required_b_pair = MAX_ENERGY as u16 - partial;
            for &energy_b1 in supports[1] {
                let Some(energy_b2) = required_b_pair.checked_sub(energy_b1) else {
                    continue;
                };
                if usize::from(energy_b2) > MAX_ENERGY
                    || boxes[1][usize::from(energy_b2)].present == 0
                {
                    continue;
                }
                quadruples += 1;
                let selected = [
                    &boxes[0][usize::from(energy_a)],
                    &boxes[1][usize::from(energy_b1)],
                    &boxes[2][usize::from(energy_c)],
                    &boxes[1][usize::from(energy_b2)],
                ];
                let mut feasible = 0_u8;
                for coordinate in 0..COORDINATES {
                    let minimum = selected
                        .iter()
                        .map(|bucket| u32::from(bucket.minimum[coordinate]))
                        .sum::<u32>();
                    let maximum = selected
                        .iter()
                        .map(|bucket| u32::from(bucket.maximum[coordinate]))
                        .sum::<u32>();
                    if minimum <= u32::from(DEFECT_TARGET) && u32::from(DEFECT_TARGET) <= maximum {
                        feasible |= 1 << coordinate;
                    }
                }
                for scope in 1_u8..=FULL_SCOPE {
                    if feasible & scope == scope {
                        survivors_by_scope[usize::from(scope)] += 1;
                    }
                }
            }
        }
    }
    quadruples
}

pub fn analyze_g41_q29_energy_boxes(
    a: &[G41Q29ExactProfile],
    b: &[G41Q29ExactProfile],
    c: &[G41Q29ExactProfile],
) -> G41Q29EnergyBoxReport {
    let mut boxes_a = Box::new([EnergyBox::default(); MAX_ENERGY + 1]);
    let mut boxes_b = Box::new([EnergyBox::default(); MAX_ENERGY + 1]);
    let mut boxes_c = Box::new([EnergyBox::default(); MAX_ENERGY + 1]);
    compile_boxes(a, &mut boxes_a);
    compile_boxes(b, &mut boxes_b);
    compile_boxes(c, &mut boxes_c);
    let mut support_a = [0_u16; MAX_ENERGY + 1];
    let mut support_b = [0_u16; MAX_ENERGY + 1];
    let mut support_c = [0_u16; MAX_ENERGY + 1];
    let lengths = [
        support_into(&boxes_a, &mut support_a),
        support_into(&boxes_b, &mut support_b),
        support_into(&boxes_c, &mut support_c),
    ];
    let mut survivors_by_scope = [0_u64; 128];
    let exact_energy_quadruples = enumerate_box_join(
        [&boxes_a, &boxes_b, &boxes_c],
        [
            &support_a[..lengths[0]],
            &support_b[..lengths[1]],
            &support_c[..lengths[2]],
        ],
        &mut survivors_by_scope,
    );
    let mut best_scope_mask = FULL_SCOPE;
    for scope in 1_u8..=FULL_SCOPE {
        let best = survivors_by_scope[usize::from(best_scope_mask)];
        let candidate = survivors_by_scope[usize::from(scope)];
        if (candidate, scope.count_ones(), scope)
            < (best, best_scope_mask.count_ones(), best_scope_mask)
        {
            best_scope_mask = scope;
        }
    }
    G41Q29EnergyBoxReport {
        energy_supports: lengths.map(|length| length as u16),
        exact_energy_quadruples,
        surviving_full_scope_quadruples: survivors_by_scope[usize::from(FULL_SCOPE)],
        best_scope_mask,
        best_scope_coordinates: best_scope_mask.count_ones() as u8,
        best_scope_survivors: survivors_by_scope[usize::from(best_scope_mask)],
        survivors_by_scope: survivors_by_scope.to_vec().into_boxed_slice(),
        provenance: "exact energy identity followed by an energy-conditioned coordinate interval relaxation; every retained tuple is necessary-only, and emptiness may authorize exclusion because minima/maxima are recomputed from the exact profile sets",
    }
}

fn compile_coordinate_supports(profiles: &[G41Q29ExactProfile]) -> EnergyCoordinateSupports {
    let mut present = [false; MAX_ENERGY + 1];
    for profile in profiles {
        let energy = (0..COORDINATES)
            .map(|coordinate| profile.coordinate(coordinate))
            .sum::<u16>();
        present[usize::from(energy)] = true;
    }
    let energies = present
        .into_iter()
        .enumerate()
        .filter_map(|(energy, is_present)| is_present.then_some(energy as u16))
        .collect::<Box<[_]>>();
    let mut index_by_energy = vec![u16::MAX; MAX_ENERGY + 1].into_boxed_slice();
    for (index, &energy) in energies.iter().enumerate() {
        index_by_energy[usize::from(energy)] = index as u16;
    }
    let mut bits = vec![0_u64; energies.len() * COORDINATES * DEFECT_WORDS].into_boxed_slice();
    for profile in profiles {
        let energy = (0..COORDINATES)
            .map(|coordinate| profile.coordinate(coordinate))
            .sum::<u16>();
        let index = usize::from(index_by_energy[usize::from(energy)]);
        for coordinate in 0..COORDINATES {
            let value = usize::from(profile.coordinate(coordinate));
            bits[(index * COORDINATES + coordinate) * DEFECT_WORDS + value / 64] |=
                1_u64 << (value % 64);
        }
    }
    EnergyCoordinateSupports {
        energies,
        index_by_energy,
        bits,
    }
}

fn coordinate_bits(
    supports: &EnergyCoordinateSupports,
    energy_index: usize,
    coordinate: usize,
) -> &[u64] {
    let start = (energy_index * COORDINATES + coordinate) * DEFECT_WORDS;
    &supports.bits[start..start + DEFECT_WORDS]
}

fn compile_pair_sums(
    left: &EnergyCoordinateSupports,
    right: &EnergyCoordinateSupports,
) -> CoordinatePairSums {
    let mut bits =
        vec![0_u64; left.energies.len() * right.energies.len() * COORDINATES * PAIR_SUM_WORDS]
            .into_boxed_slice();
    for left_index in 0..left.energies.len() {
        for right_index in 0..right.energies.len() {
            for coordinate in 0..COORDINATES {
                let output_start =
                    ((left_index * right.energies.len() + right_index) * COORDINATES + coordinate)
                        * PAIR_SUM_WORDS;
                let output = &mut bits[output_start..output_start + PAIR_SUM_WORDS];
                for (left_word_index, &left_word) in coordinate_bits(left, left_index, coordinate)
                    .iter()
                    .enumerate()
                {
                    let mut pending_left = left_word;
                    while pending_left != 0 {
                        let left_value =
                            64 * left_word_index + pending_left.trailing_zeros() as usize;
                        pending_left &= pending_left - 1;
                        for (right_word_index, &right_word) in
                            coordinate_bits(right, right_index, coordinate)
                                .iter()
                                .enumerate()
                        {
                            let mut pending_right = right_word;
                            while pending_right != 0 {
                                let right_value =
                                    64 * right_word_index + pending_right.trailing_zeros() as usize;
                                pending_right &= pending_right - 1;
                                let sum = left_value + right_value;
                                output[sum / 64] |= 1_u64 << (sum % 64);
                            }
                        }
                    }
                }
            }
        }
    }
    CoordinatePairSums {
        right_len: right.energies.len(),
        bits,
    }
}

fn pair_sum_bits(
    sums: &CoordinatePairSums,
    left_index: usize,
    right_index: usize,
    coordinate: usize,
) -> &[u64] {
    let start =
        ((left_index * sums.right_len + right_index) * COORDINATES + coordinate) * PAIR_SUM_WORDS;
    &sums.bits[start..start + PAIR_SUM_WORDS]
}

#[inline(always)]
fn complementary_pair_sums_intersect(left: &[u64], right: &[u64]) -> bool {
    for (word_index, &word) in left[..DEFECT_WORDS].iter().enumerate() {
        let mut pending = word;
        while pending != 0 {
            let sum = 64 * word_index + pending.trailing_zeros() as usize;
            pending &= pending - 1;
            if sum <= usize::from(DEFECT_TARGET) {
                let complement = usize::from(DEFECT_TARGET) - sum;
                if right[complement / 64] & (1_u64 << (complement % 64)) != 0 {
                    return true;
                }
            }
        }
    }
    false
}

fn enumerate_fibre_join(
    supports: [&EnergyCoordinateSupports; 3],
    ac_sums: &CoordinatePairSums,
    bb_sums: &CoordinatePairSums,
    survivors_by_scope: &mut [u64; 128],
) -> u64 {
    survivors_by_scope.fill(0);
    let mut quadruples = 0_u64;
    for (a_index, &energy_a) in supports[0].energies.iter().enumerate() {
        for (c_index, &energy_c) in supports[2].energies.iter().enumerate() {
            let partial = energy_a + energy_c;
            if partial > MAX_ENERGY as u16 {
                continue;
            }
            let required_b_pair = MAX_ENERGY as u16 - partial;
            for (b1_index, &energy_b1) in supports[1].energies.iter().enumerate() {
                let Some(energy_b2) = required_b_pair.checked_sub(energy_b1) else {
                    continue;
                };
                if usize::from(energy_b2) > MAX_ENERGY {
                    continue;
                }
                let b2_index = supports[1].index_by_energy[usize::from(energy_b2)];
                if b2_index == u16::MAX {
                    continue;
                }
                quadruples += 1;
                let mut feasible = 0_u8;
                for coordinate in 0..COORDINATES {
                    if complementary_pair_sums_intersect(
                        pair_sum_bits(ac_sums, a_index, c_index, coordinate),
                        pair_sum_bits(bb_sums, b1_index, usize::from(b2_index), coordinate),
                    ) {
                        feasible |= 1 << coordinate;
                    }
                }
                for scope in 1_u8..=FULL_SCOPE {
                    if feasible & scope == scope {
                        survivors_by_scope[usize::from(scope)] += 1;
                    }
                }
            }
        }
    }
    quadruples
}

pub fn analyze_g41_q29_energy_coordinate_fibres(
    a: &[G41Q29ExactProfile],
    b: &[G41Q29ExactProfile],
    c: &[G41Q29ExactProfile],
) -> G41Q29EnergyFibreReport {
    let supports = [
        compile_coordinate_supports(a),
        compile_coordinate_supports(b),
        compile_coordinate_supports(c),
    ];
    let ac_sums = compile_pair_sums(&supports[0], &supports[2]);
    let bb_sums = compile_pair_sums(&supports[1], &supports[1]);
    let mut survivors_by_scope = [0_u64; 128];
    let exact_energy_quadruples = enumerate_fibre_join(
        [&supports[0], &supports[1], &supports[2]],
        &ac_sums,
        &bb_sums,
        &mut survivors_by_scope,
    );
    let mut best_scope_mask = FULL_SCOPE;
    for scope in 1_u8..=FULL_SCOPE {
        let best = survivors_by_scope[usize::from(best_scope_mask)];
        let candidate = survivors_by_scope[usize::from(scope)];
        if (candidate, scope.count_ones(), scope)
            < (best, best_scope_mask.count_ones(), best_scope_mask)
        {
            best_scope_mask = scope;
        }
    }
    G41Q29EnergyFibreReport {
        energy_supports: supports.each_ref().map(|item| item.energies.len() as u16),
        exact_energy_quadruples,
        surviving_full_scope_quadruples: survivors_by_scope[usize::from(FULL_SCOPE)],
        best_scope_mask,
        best_scope_coordinates: best_scope_mask.count_ones() as u8,
        best_scope_survivors: survivors_by_scope[usize::from(best_scope_mask)],
        survivors_by_scope: survivors_by_scope.to_vec().into_boxed_slice(),
        pair_sum_bytes: (ac_sums.bits.len() + bb_sums.bits.len()) as u64 * 8,
        provenance: "exact energy-conditioned one-coordinate fibres and fixed bitset pair sumsets; scopes are exhaustively learned rather than supplied; simultaneous coordinate feasibility is a necessary relaxation, so emptiness may authorize exclusion after independent replay",
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn profile(values: [u16; 7]) -> G41Q29ExactProfile {
        G41Q29ExactProfile::from_coordinates(values)
    }

    #[test]
    fn boxes_match_direct_small_oracle() {
        let a = [profile([100, 100, 100, 100, 100, 100, 100])];
        let b = [profile([123, 123, 123, 123, 123, 123, 123])];
        let c = [profile([177, 177, 177, 177, 177, 177, 177])];
        let report = analyze_g41_q29_energy_boxes(&a, &b, &c);
        assert_eq!(report.exact_energy_quadruples, 1);
        assert_eq!(report.surviving_full_scope_quadruples, 1);

        let bad = [profile([178, 177, 177, 177, 177, 177, 176])];
        let report = analyze_g41_q29_energy_boxes(&a, &b, &bad);
        assert_eq!(report.exact_energy_quadruples, 1);
        assert_eq!(report.surviving_full_scope_quadruples, 0);
    }

    #[test]
    fn box_join_hot_loop_allocates_nothing() {
        let mut boxes = Box::new([EnergyBox::default(); MAX_ENERGY + 1]);
        for &energy in &[700_u16, 861, 1_100] {
            boxes[usize::from(energy)] = EnergyBox {
                minimum: [100; 7],
                maximum: [523; 7],
                energy,
                present: 1,
                _pad: 0,
            };
        }
        let support = [700_u16, 861, 1_100];
        let mut counts = [0_u64; 128];
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..1_000 {
                std::hint::black_box(enumerate_box_join(
                    [&boxes, &boxes, &boxes],
                    [&support, &support, &support],
                    &mut counts,
                ));
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn coordinate_fibres_match_direct_small_oracle() {
        let a = [profile([100, 100, 100, 100, 100, 100, 100])];
        let b = [profile([123, 123, 123, 123, 123, 123, 123])];
        let c = [profile([177, 177, 177, 177, 177, 177, 177])];
        let report = analyze_g41_q29_energy_coordinate_fibres(&a, &b, &c);
        assert_eq!(report.exact_energy_quadruples, 1);
        assert_eq!(report.surviving_full_scope_quadruples, 1);

        let bad = [profile([178, 177, 177, 177, 177, 177, 176])];
        let report = analyze_g41_q29_energy_coordinate_fibres(&a, &b, &bad);
        assert_eq!(report.exact_energy_quadruples, 1);
        assert_eq!(report.surviving_full_scope_quadruples, 0);
    }

    #[test]
    fn coordinate_fibre_join_allocates_nothing() {
        let profiles = [profile([100, 100, 100, 100, 100, 100, 100])];
        let support = compile_coordinate_supports(&profiles);
        let sums = compile_pair_sums(&support, &support);
        let mut counts = [0_u64; 128];
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..1_000 {
                std::hint::black_box(enumerate_fibre_join(
                    [&support, &support, &support],
                    &sums,
                    &sums,
                    &mut counts,
                ));
            }
        });
        assert_eq!(allocations, 0);
    }
}
