//! Discovery-only coordinate descent over exact q29 profile tablebases.

use serde::Serialize;

use crate::g41_q29_exact_tablebase::G41Q29ExactProfile;
use crate::z2k_subgroup::{subgroup_membership_z2k, Z2kMembership, MAX_GENERATORS};

const BLOCKS: usize = 4;
const COORDINATES: usize = 7;
const TARGET: u16 = 523;
const SPAN_PRIMES: [u16; 16] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53];

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, Serialize)]
pub struct G41Q29ProfileJoinCandidate {
    pub indices: [u32; BLOCKS],
    pub residual: u32,
    pub sums: [u16; COORDINATES],
    pub _pad: [u8; 30],
}

const _: () = assert!(
    std::mem::size_of::<G41Q29ProfileJoinCandidate>() == 64
        && std::mem::align_of::<G41Q29ProfileJoinCandidate>() == 4
);

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29ProfileDescentReport {
    pub threads: u8,
    pub restarts: u32,
    pub sweeps: u16,
    pub profiles: [u32; 3],
    pub profiles_scored: u64,
    pub seeded: bool,
    pub initial_residual: Option<u32>,
    pub best: G41Q29ProfileJoinCandidate,
    pub pair_profiles_probed: u64,
    pub pair_repair: Option<G41Q29ProfileJoinCandidate>,
    pub difference_span: G41Q29DifferenceSpanReport,
    pub provenance: &'static str,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29DifferenceSpanReport {
    pub correction: [i16; COORDINATES],
    pub primes: [u16; 16],
    pub ranks: [u8; 16],
    pub correction_in_span: [bool; 16],
    pub nearest_distances: [u16; BLOCKS],
    pub nearest_deltas: [[i16; COORDINATES]; BLOCKS],
    pub two_adic_exponent: u8,
    pub two_adic_generators: u8,
    pub two_adic_pivot_count: u8,
    pub two_adic_pivot_valuations: [u8; 8],
    pub correction_in_two_adic_span: bool,
    pub two_adic_complete: bool,
    pub integer_basis_found: bool,
    pub integer_basis_determinant: i128,
    pub integer_basis: [[i16; COORDINATES]; COORDINATES],
    pub integer_basis_generations: u8,
    pub integer_basis_profiles_scanned: u64,
    pub correction_coefficients: [i128; COORDINATES],
    pub correction_in_integer_lattice: bool,
    pub index_58_lattice_proved: bool,
    pub profiles_scanned: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Copy)]
struct SplitMix64(u64);

impl SplitMix64 {
    #[inline(always)]
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9e37_79b9_7f4a_7c15);
        let mut value = self.0;
        value = (value ^ (value >> 30)).wrapping_mul(0xbf58_476d_1ce4_e5b9);
        value = (value ^ (value >> 27)).wrapping_mul(0x94d0_49bb_1331_11eb);
        value ^ (value >> 31)
    }
}

#[inline(always)]
fn residual(sums: &[u16; COORDINATES]) -> u32 {
    sums.iter()
        .map(|&sum| u32::from(sum.abs_diff(TARGET)))
        .sum()
}

fn profile_sums(
    sets: [&[G41Q29ExactProfile]; BLOCKS],
    indices: [u32; BLOCKS],
) -> [u16; COORDINATES] {
    std::array::from_fn(|coordinate| {
        (0..BLOCKS)
            .map(|block| sets[block][indices[block] as usize].coordinate(coordinate))
            .sum()
    })
}

fn modular_inverse(value: u16, modulus: u16) -> u16 {
    (1..modulus)
        .find(|candidate| (u32::from(value) * u32::from(*candidate)) % u32::from(modulus) == 1)
        .expect("nonzero residue modulo a prime is invertible")
}

fn insert_modular_basis(
    basis: &mut [[u16; COORDINATES]; COORDINATES],
    value: [i16; 7],
    modulus: u16,
) -> bool {
    let mut row = value.map(|entry| entry.rem_euclid(modulus as i16) as u16);
    for coordinate in 0..COORDINATES {
        if row[coordinate] == 0 {
            continue;
        }
        if basis[coordinate][coordinate] == 0 {
            let inverse = modular_inverse(row[coordinate], modulus);
            for entry in &mut row[coordinate..] {
                *entry = ((u32::from(*entry) * u32::from(inverse)) % u32::from(modulus)) as u16;
            }
            basis[coordinate] = row;
            return true;
        }
        let factor = row[coordinate];
        for column in coordinate..COORDINATES {
            row[column] = (u32::from(row[column]) + u32::from(modulus)
                - (u32::from(factor) * u32::from(basis[coordinate][column])) % u32::from(modulus))
                as u16
                % modulus;
        }
    }
    false
}

fn modular_basis_contains(
    basis: &[[u16; COORDINATES]; COORDINATES],
    value: [i16; COORDINATES],
    modulus: u16,
) -> bool {
    let mut row = value.map(|entry| entry.rem_euclid(modulus as i16) as u16);
    for coordinate in 0..COORDINATES {
        if row[coordinate] == 0 {
            continue;
        }
        if basis[coordinate][coordinate] == 0 {
            return false;
        }
        let factor = row[coordinate];
        for column in coordinate..COORDINATES {
            row[column] = (u32::from(row[column]) + u32::from(modulus)
                - (u32::from(factor) * u32::from(basis[coordinate][column])) % u32::from(modulus))
                as u16
                % modulus;
        }
    }
    true
}

fn compiled_z2k_contains(compiled: &Z2kMembership, value: [u16; 8], exponent: u8) -> bool {
    let modulus = 1_u32 << exponent;
    let mut transformed = [0_u16; 8];
    for (row, output) in transformed.iter_mut().enumerate() {
        let mut sum = 0_u32;
        for (coordinate, &entry) in value.iter().enumerate() {
            sum = (sum + u32::from(compiled.row_transform[row][coordinate]) * u32::from(entry))
                % modulus;
        }
        *output = sum as u16;
    }
    for (row, &value) in transformed
        .iter()
        .enumerate()
        .take(usize::from(compiled.pivot_count))
    {
        if value & ((1_u16 << compiled.pivot_valuations[row]) - 1) != 0 {
            return false;
        }
    }
    transformed[usize::from(compiled.pivot_count)..]
        .iter()
        .all(|&value| value == 0)
}

fn determinant(mut matrix: [[i128; COORDINATES]; COORDINATES]) -> i128 {
    let mut sign = 1_i128;
    let mut denominator = 1_i128;
    for pivot in 0..COORDINATES - 1 {
        let Some(chosen) = (pivot..COORDINATES).find(|&row| matrix[row][pivot] != 0) else {
            return 0;
        };
        if chosen != pivot {
            matrix.swap(chosen, pivot);
            sign = -sign;
        }
        let pivot_value = matrix[pivot][pivot];
        for row in pivot + 1..COORDINATES {
            for column in pivot + 1..COORDINATES {
                matrix[row][column] = (matrix[row][column] * pivot_value
                    - matrix[row][pivot] * matrix[pivot][column])
                    / denominator;
            }
        }
        denominator = pivot_value;
    }
    sign * matrix[COORDINATES - 1][COORDINATES - 1]
}

fn extract_integer_basis(
    generators: &[[i16; COORDINATES]],
    correction: [i16; COORDINATES],
) -> (
    bool,
    i128,
    [[i16; COORDINATES]; COORDINATES],
    [i128; COORDINATES],
    bool,
) {
    if generators.len() < COORDINATES || generators.len() > 12 {
        return (
            false,
            0,
            [[0; COORDINATES]; COORDINATES],
            [0; COORDINATES],
            false,
        );
    }
    let mut best_determinant = 0_i128;
    let mut best_basis = [[0_i16; COORDINATES]; COORDINATES];
    for mask in 0_u16..1_u16 << generators.len() {
        if mask.count_ones() != COORDINATES as u32 {
            continue;
        }
        let mut basis = [[0_i16; COORDINATES]; COORDINATES];
        let mut cursor = 0;
        for (index, generator) in generators.iter().enumerate() {
            if mask & (1 << index) != 0 {
                basis[cursor] = *generator;
                cursor += 1;
            }
        }
        let value = determinant(basis.map(|row| row.map(i128::from)));
        if value != 0 && (best_determinant == 0 || value.abs() < best_determinant.abs()) {
            best_determinant = value;
            best_basis = basis;
        }
    }
    if best_determinant == 0 {
        return (false, 0, best_basis, [0; COORDINATES], false);
    }
    let mut coefficients = [0_i128; COORDINATES];
    let mut integral = true;
    for row in 0..COORDINATES {
        let mut replaced = best_basis.map(|basis_row| basis_row.map(i128::from));
        replaced[row] = correction.map(i128::from);
        let numerator = determinant(replaced);
        integral &= numerator % best_determinant == 0;
        coefficients[row] = numerator / best_determinant;
    }
    (true, best_determinant, best_basis, coefficients, integral)
}

fn basis_coordinates(
    basis: [[i16; COORDINATES]; COORDINATES],
    determinant_value: i128,
    target: [i16; COORDINATES],
) -> ([i128; COORDINATES], bool) {
    let mut coefficients = [0_i128; COORDINATES];
    let mut integral = true;
    for row in 0..COORDINATES {
        let mut replaced = basis.map(|basis_row| basis_row.map(i128::from));
        replaced[row] = target.map(i128::from);
        let numerator = determinant(replaced);
        integral &= numerator % determinant_value == 0;
        coefficients[row] = numerator / determinant_value;
    }
    (coefficients, integral)
}

fn improve_integer_basis(
    sets: [&[G41Q29ExactProfile]; BLOCKS],
    initial: G41Q29ProfileJoinCandidate,
    mut basis: [[i16; COORDINATES]; COORDINATES],
    mut determinant_value: i128,
    lower_bound: i128,
) -> ([[i16; COORDINATES]; COORDINATES], i128, u8, u64) {
    let mut generations = 0_u8;
    let mut profiles_scanned = 0_u64;
    while determinant_value.abs() > lower_bound && generations < 32 {
        let mut cofactors = [[0_i128; COORDINATES]; COORDINATES];
        for row in 0..COORDINATES {
            for column in 0..COORDINATES {
                let mut replacement = basis.map(|basis_row| basis_row.map(i128::from));
                replacement[row] = [0; COORDINATES];
                replacement[row][column] = 1;
                cofactors[row][column] = determinant(replacement);
            }
        }
        let mut best_row = 0_usize;
        let mut best_delta = [0_i16; COORDINATES];
        let mut best_determinant = determinant_value;
        for block in 0..BLOCKS {
            let base = sets[block][initial.indices[block] as usize];
            for profile in sets[block] {
                profiles_scanned += 1;
                let delta = std::array::from_fn(|coordinate| {
                    profile.coordinate(coordinate) as i16 - base.coordinate(coordinate) as i16
                });
                if delta == [0; COORDINATES] {
                    continue;
                }
                for row in 0..COORDINATES {
                    let replacement_determinant = (0..COORDINATES)
                        .map(|column| cofactors[row][column] * i128::from(delta[column]))
                        .sum::<i128>();
                    if replacement_determinant != 0
                        && replacement_determinant.abs() < best_determinant.abs()
                    {
                        best_row = row;
                        best_delta = delta;
                        best_determinant = replacement_determinant;
                    }
                }
            }
        }
        if best_determinant.abs() >= determinant_value.abs() {
            break;
        }
        basis[best_row] = best_delta;
        determinant_value = best_determinant;
        generations += 1;
    }
    (basis, determinant_value, generations, profiles_scanned)
}

pub fn analyze_g41_q29_difference_span(
    sets: [&[G41Q29ExactProfile]; BLOCKS],
    initial: G41Q29ProfileJoinCandidate,
) -> G41Q29DifferenceSpanReport {
    let correction =
        std::array::from_fn(|coordinate| TARGET as i16 - initial.sums[coordinate] as i16);
    let mut bases = [[[0_u16; COORDINATES]; COORDINATES]; 16];
    let mut ranks = [0_u8; 16];
    let mut nearest_distances = [u16::MAX; BLOCKS];
    let mut nearest_deltas = [[0_i16; COORDINATES]; BLOCKS];
    let two_adic_exponent = 15_u8;
    let two_adic_modulus = 1_i32 << two_adic_exponent;
    let mut two_adic_generators = Vec::<[u16; 8]>::with_capacity(MAX_GENERATORS);
    let mut two_adic_generator_deltas = [[0_i16; COORDINATES]; MAX_GENERATORS];
    let mut two_adic_compiled =
        subgroup_membership_z2k(&two_adic_generators, [0; 8], two_adic_exponent).unwrap();
    let mut two_adic_complete = true;
    let mut profiles_scanned = 0_u64;
    for block in 0..BLOCKS {
        let base = sets[block][initial.indices[block] as usize];
        for profile in sets[block] {
            profiles_scanned += 1;
            let delta = std::array::from_fn(|coordinate| {
                profile.coordinate(coordinate) as i16 - base.coordinate(coordinate) as i16
            });
            let distance = delta.iter().map(|value| value.unsigned_abs()).sum::<u16>();
            if distance != 0 && distance < nearest_distances[block] {
                nearest_distances[block] = distance;
                nearest_deltas[block] = delta;
            }
            if distance == 0 {
                continue;
            }
            let mut two_adic_delta = [0_u16; 8];
            for coordinate in 0..COORDINATES {
                two_adic_delta[coordinate] =
                    i32::from(delta[coordinate]).rem_euclid(two_adic_modulus) as u16;
            }
            if two_adic_complete
                && !compiled_z2k_contains(&two_adic_compiled, two_adic_delta, two_adic_exponent)
            {
                if two_adic_generators.len() == MAX_GENERATORS {
                    two_adic_complete = false;
                } else {
                    two_adic_generator_deltas[two_adic_generators.len()] = delta;
                    two_adic_generators.push(two_adic_delta);
                    two_adic_compiled =
                        subgroup_membership_z2k(&two_adic_generators, [0; 8], two_adic_exponent)
                            .unwrap();
                }
            }
            for prime_index in 0..SPAN_PRIMES.len() {
                if ranks[prime_index] < COORDINATES as u8
                    && insert_modular_basis(
                        &mut bases[prime_index],
                        delta,
                        SPAN_PRIMES[prime_index],
                    )
                {
                    ranks[prime_index] += 1;
                }
            }
        }
    }
    let correction_in_span = std::array::from_fn(|index| {
        modular_basis_contains(&bases[index], correction, SPAN_PRIMES[index])
    });
    let mut two_adic_correction = [0_u16; 8];
    for coordinate in 0..COORDINATES {
        two_adic_correction[coordinate] =
            i32::from(correction[coordinate]).rem_euclid(two_adic_modulus) as u16;
    }
    let correction_in_two_adic_span = two_adic_complete
        && compiled_z2k_contains(&two_adic_compiled, two_adic_correction, two_adic_exponent);
    let (integer_basis_found, initial_basis_determinant, initial_basis, _, _) =
        extract_integer_basis(
            &two_adic_generator_deltas[..two_adic_generators.len()],
            correction,
        );
    let rank_mod_29 = ranks[SPAN_PRIMES.iter().position(|&prime| prime == 29).unwrap()];
    let determinant_lower_bound = if ranks[0] == 6 && rank_mod_29 == 6 {
        58
    } else {
        1
    };
    let (
        integer_basis,
        integer_basis_determinant,
        integer_basis_generations,
        integer_basis_profiles_scanned,
    ) = if integer_basis_found {
        improve_integer_basis(
            sets,
            initial,
            initial_basis,
            initial_basis_determinant,
            determinant_lower_bound,
        )
    } else {
        (initial_basis, initial_basis_determinant, 0, 0)
    };
    let (correction_coefficients, correction_in_integer_lattice) = if integer_basis_found {
        basis_coordinates(integer_basis, integer_basis_determinant, correction)
    } else {
        ([0; COORDINATES], false)
    };
    let index_58_lattice_proved = integer_basis_found
        && integer_basis_determinant.abs() == 58
        && ranks[0] == 6
        && rank_mod_29 == 6;
    G41Q29DifferenceSpanReport {
        correction,
        primes: SPAN_PRIMES,
        ranks,
        correction_in_span,
        nearest_distances,
        nearest_deltas,
        two_adic_exponent,
        two_adic_generators: two_adic_generators.len() as u8,
        two_adic_pivot_count: two_adic_compiled.pivot_count,
        two_adic_pivot_valuations: two_adic_compiled.pivot_valuations,
        correction_in_two_adic_span,
        two_adic_complete,
        integer_basis_found,
        integer_basis_determinant,
        integer_basis,
        integer_basis_generations,
        integer_basis_profiles_scanned,
        correction_coefficients,
        correction_in_integer_lattice,
        index_58_lattice_proved,
        profiles_scanned,
        provenance: "discovery-only exact profile-difference spans over sixteen prime fields; a failed membership is a sound modular obstruction after independent basis replay, while membership grants no existence authority",
    }
}

pub fn repair_g41_q29_profile_pair(
    sets: [&[G41Q29ExactProfile]; BLOCKS],
    initial: G41Q29ProfileJoinCandidate,
) -> (Option<G41Q29ProfileJoinCandidate>, u64) {
    let mut profiles_probed = 0_u64;
    for first_block in 0..BLOCKS {
        for second_block in first_block + 1..BLOCKS {
            let mut fixed = initial.sums;
            let old_first = sets[first_block][initial.indices[first_block] as usize];
            let old_second = sets[second_block][initial.indices[second_block] as usize];
            for coordinate in 0..COORDINATES {
                fixed[coordinate] -=
                    old_first.coordinate(coordinate) + old_second.coordinate(coordinate);
            }
            for (first_index, first) in sets[first_block].iter().enumerate() {
                profiles_probed += 1;
                let mut needed = [0_u16; COORDINATES];
                let mut feasible = true;
                for coordinate in 0..COORDINATES {
                    let partial = fixed[coordinate] + first.coordinate(coordinate);
                    let Some(value) = TARGET.checked_sub(partial) else {
                        feasible = false;
                        break;
                    };
                    needed[coordinate] = value;
                }
                if !feasible {
                    continue;
                }
                let target = G41Q29ExactProfile::from_coordinates(needed);
                let Ok(second_index) = sets[second_block].binary_search(&target) else {
                    continue;
                };
                let mut indices = initial.indices;
                indices[first_block] = first_index as u32;
                indices[second_block] = second_index as u32;
                let sums = profile_sums(sets, indices);
                if sums == [TARGET; COORDINATES] {
                    return (
                        Some(G41Q29ProfileJoinCandidate {
                            indices,
                            residual: 0,
                            sums,
                            _pad: [0; 30],
                        }),
                        profiles_probed,
                    );
                }
            }
        }
    }
    (None, profiles_probed)
}

pub fn descend_g41_q29_profiles(
    sets: [&[G41Q29ExactProfile]; BLOCKS],
    restarts: u32,
    sweeps: u16,
    seed: u64,
    initial: Option<[u32; BLOCKS]>,
) -> (G41Q29ProfileJoinCandidate, u64) {
    assert!(sets
        .iter()
        .all(|set| !set.is_empty() && set.len() <= u32::MAX as usize));
    let mut rng = SplitMix64(seed);
    let mut best = G41Q29ProfileJoinCandidate {
        residual: u32::MAX,
        ..G41Q29ProfileJoinCandidate::default()
    };
    let mut profiles_scored = 0_u64;
    for restart in 0..restarts {
        let mut indices = if restart == 0 {
            initial.unwrap_or_else(|| {
                std::array::from_fn(|block| (rng.next() % sets[block].len() as u64) as u32)
            })
        } else {
            std::array::from_fn(|block| (rng.next() % sets[block].len() as u64) as u32)
        };
        let mut sums = profile_sums(sets, indices);
        let mut current = residual(&sums);
        if current < best.residual {
            best = G41Q29ProfileJoinCandidate {
                indices,
                residual: current,
                sums,
                _pad: [0; 30],
            };
        }
        for _ in 0..sweeps {
            let mut improved = false;
            let first_block = (rng.next() & 3) as usize;
            for offset in 0..BLOCKS {
                let block = (first_block + offset) & 3;
                let old = sets[block][indices[block] as usize];
                let mut selected = indices[block];
                let mut selected_residual = current;
                for (candidate_index, candidate) in sets[block].iter().enumerate() {
                    let mut candidate_residual = 0_u32;
                    for coordinate in 0..COORDINATES {
                        let sum = sums[coordinate] - old.coordinate(coordinate)
                            + candidate.coordinate(coordinate);
                        candidate_residual += u32::from(sum.abs_diff(TARGET));
                    }
                    if candidate_residual < selected_residual {
                        selected = candidate_index as u32;
                        selected_residual = candidate_residual;
                        if selected_residual == 0 {
                            break;
                        }
                    }
                }
                profiles_scored += sets[block].len() as u64;
                if selected != indices[block] {
                    let replacement = sets[block][selected as usize];
                    for coordinate in 0..COORDINATES {
                        sums[coordinate] = sums[coordinate] - old.coordinate(coordinate)
                            + replacement.coordinate(coordinate);
                    }
                    indices[block] = selected;
                    current = selected_residual;
                    improved = true;
                    if current < best.residual {
                        best = G41Q29ProfileJoinCandidate {
                            indices,
                            residual: current,
                            sums,
                            _pad: [0; 30],
                        };
                    }
                    if current == 0 {
                        return (best, profiles_scored);
                    }
                }
            }
            if !improved {
                break;
            }
        }
    }
    (best, profiles_scored)
}

pub fn parallel_descend_g41_q29_profiles(
    a: &[G41Q29ExactProfile],
    b: &[G41Q29ExactProfile],
    c: &[G41Q29ExactProfile],
    threads: usize,
    restarts: u32,
    sweeps: u16,
    seed: u64,
    initial: Option<[u32; BLOCKS]>,
) -> G41Q29ProfileDescentReport {
    assert!((1..=16).contains(&threads));
    let sets = [a, b, c, b];
    let mut results = Vec::with_capacity(threads);
    std::thread::scope(|scope| {
        let mut handles = Vec::with_capacity(threads);
        for worker in 0..threads {
            let worker_restarts =
                restarts / threads as u32 + u32::from((worker as u32) < restarts % threads as u32);
            handles.push(scope.spawn(move || {
                descend_g41_q29_profiles(
                    sets,
                    worker_restarts,
                    sweeps,
                    seed ^ (worker as u64).wrapping_mul(0xd6e8_feb8_6659_fd93),
                    if worker == 0 { initial } else { None },
                )
            }));
        }
        for handle in handles {
            results.push(handle.join().expect("profile descent worker panicked"));
        }
    });
    let profiles_scored = results.iter().map(|result| result.1).sum();
    let best = results
        .into_iter()
        .map(|result| result.0)
        .min_by_key(|candidate| (candidate.residual, candidate.indices))
        .unwrap();
    assert_eq!(best.sums, profile_sums(sets, best.indices));
    assert_eq!(best.residual, residual(&best.sums));
    let initial_residual = initial.map(|indices| residual(&profile_sums(sets, indices)));
    let (pair_repair, pair_profiles_probed) = repair_g41_q29_profile_pair(sets, best);
    let difference_span = analyze_g41_q29_difference_span(sets, best);
    G41Q29ProfileDescentReport {
        threads: threads as u8,
        restarts,
        sweeps,
        profiles: [a.len() as u32, b.len() as u32, c.len() as u32],
        profiles_scored,
        seeded: initial.is_some(),
        initial_residual,
        best,
        pair_profiles_probed,
        pair_repair,
        difference_span,
        provenance: "discovery-only coordinate descent over exact aggregate q29 profile supersets; positives are directly replayed as four profile sums, but do not establish a raw slot-split witness; misses have no exclusion authority",
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
    fn descent_finds_and_replays_small_hit() {
        let a = [profile([100; 7]), profile([99; 7])];
        let b = [profile([123; 7]), profile([120; 7])];
        let c = [profile([177; 7]), profile([180; 7])];
        let (best, _) = descend_g41_q29_profiles([&a, &b, &c, &b], 8, 8, 7, None);
        assert_eq!(best.residual, 0);
        assert_eq!(best.sums, [523; 7]);
    }

    #[test]
    fn descent_hot_loop_allocates_nothing() {
        let a = [profile([100; 7]), profile([99; 7])];
        let b = [profile([123; 7]), profile([120; 7])];
        let c = [profile([177; 7]), profile([180; 7])];
        let (_, allocations) = tracked_allocations(|| {
            std::hint::black_box(descend_g41_q29_profiles([&a, &b, &c, &b], 100, 8, 9, None));
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn pair_repair_finds_exact_complement_without_allocation() {
        let a = [
            profile([100; 7]),
            profile([101, 100, 100, 100, 100, 100, 100]),
        ];
        let b = [
            profile([122, 123, 123, 123, 123, 123, 123]),
            profile([123; 7]),
        ];
        let c = [profile([177; 7])];
        let sets: [&[G41Q29ExactProfile]; 4] = [&a, &b, &c, &b];
        let initial = G41Q29ProfileJoinCandidate {
            indices: [1, 1, 0, 1],
            residual: 1,
            sums: profile_sums(sets, [1, 1, 0, 1]),
            _pad: [0; 30],
        };
        let ((repair, _), allocations) =
            tracked_allocations(|| repair_g41_q29_profile_pair(sets, initial));
        assert_eq!(allocations, 0);
        assert_eq!(repair.unwrap().sums, [523; 7]);
    }

    #[test]
    fn modular_difference_span_matches_unit_basis_oracle() {
        let mut profiles = Vec::with_capacity(8);
        profiles.push(profile([100; 7]));
        for coordinate in 0..7 {
            let mut values = [100; 7];
            values[coordinate] += 1;
            profiles.push(profile(values));
        }
        profiles.sort_unstable();
        let base_index = profiles
            .iter()
            .position(|item| *item == profile([100; 7]))
            .unwrap() as u32;
        let sets: [&[G41Q29ExactProfile]; 4] = [&profiles, &profiles, &profiles, &profiles];
        let initial = G41Q29ProfileJoinCandidate {
            indices: [base_index; 4],
            residual: 861,
            sums: [400; 7],
            _pad: [0; 30],
        };
        let report = analyze_g41_q29_difference_span(sets, initial);
        assert_eq!(report.ranks, [7; 16]);
        assert_eq!(report.correction_in_span, [true; 16]);
        assert_eq!(report.nearest_distances, [1; 4]);
    }
}
