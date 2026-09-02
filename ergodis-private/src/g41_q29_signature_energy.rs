//! Exact energy-class joins for scoped g41 q29 aggregate signatures.

use crate::g41_q29_exact_tablebase::G41Q29ExactProfile;

pub const G41_Q29_TARGET_ENERGY: usize = 3_661;

pub fn distinct_g41_q29_profile_energies(profiles: &[G41Q29ExactProfile]) -> Vec<u16> {
    let mut present = [false; G41_Q29_TARGET_ENERGY + 1];
    for &profile in profiles {
        let energy = (0..7)
            .map(|coordinate| usize::from(profile.coordinate(coordinate)))
            .sum::<usize>();
        if energy <= G41_Q29_TARGET_ENERGY {
            present[energy] = true;
        }
    }
    present
        .iter()
        .enumerate()
        .filter_map(|(energy, &is_present)| is_present.then_some(energy as u16))
        .collect()
}

#[inline]
pub fn count_g41_q29_energy_class_joins(energies: [&[u16]; 4]) -> u64 {
    let mut left_counts = [0_u32; G41_Q29_TARGET_ENERGY + 1];
    for &first in energies[0] {
        for &second in energies[2] {
            let sum = usize::from(first) + usize::from(second);
            if sum <= G41_Q29_TARGET_ENERGY {
                left_counts[sum] += 1;
            }
        }
    }
    let mut joins = 0_u64;
    for &first in energies[1] {
        for &second in energies[3] {
            let sum = usize::from(first) + usize::from(second);
            if sum <= G41_Q29_TARGET_ENERGY {
                joins += u64::from(left_counts[G41_Q29_TARGET_ENERGY - sum]);
            }
        }
    }
    joins
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn brute(energies: [&[u16]; 4]) -> u64 {
        let mut count = 0_u64;
        for &a in energies[0] {
            for &b in energies[1] {
                for &c in energies[2] {
                    for &d in energies[3] {
                        count += u64::from(
                            usize::from(a) + usize::from(b) + usize::from(c) + usize::from(d)
                                == G41_Q29_TARGET_ENERGY,
                        );
                    }
                }
            }
        }
        count
    }

    #[test]
    fn energy_join_matches_independent_four_loop() {
        let a = [0, 1, 100, 1_000];
        let b = [0, 61, 500, 1_200];
        let c = [0, 400, 1_000];
        let d = [61, 1_061, 2_661];
        let energies: [&[u16]; 4] = [&a, &b, &c, &d];
        assert_eq!(count_g41_q29_energy_class_joins(energies), brute(energies));
    }

    #[test]
    fn energy_join_hot_kernel_does_not_allocate() {
        let a = [0, 1_000];
        let b = [0, 661];
        let c = [0, 1_000];
        let d = [0, 1_000];
        let (count, allocations) =
            tracked_allocations(|| count_g41_q29_energy_class_joins([&a, &b, &c, &d]));
        assert_eq!(count, 1);
        assert_eq!(allocations, 0);
    }
}
