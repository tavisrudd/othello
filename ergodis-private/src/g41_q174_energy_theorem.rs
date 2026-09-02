//! Exact zero-energy lower bound for the g41/q18 source interfaces at q174.

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g41_joint_quotient_search::G41JointQuotientWitness;
use crate::g41_q29_evolve::{compile_inventory, digit_counts, FineInventory, FineOrbit};
use crate::projected_orbit_min_cost::{
    ProjectedOrbitBudget, ProjectedOrbitCompileReport, ProjectedOrbitItem,
    ProjectedOrbitMinCostKernel, ProjectedOrbitMinCostTable, ProjectedOrbitMinCostWorkspace,
};

const SLOTS: usize = 6;
const Q174: usize = 174;
const Q174_CLASSES: usize = 46;
const ROW_WEIGHTS: [u16; 4] = [260, 261, 261, 261];
const REQUIRED_NONZERO_INTERSECTION: u16 = 520;
const TARGET_ZERO_ENERGY: u16 = ROW_WEIGHTS[0]
    + ROW_WEIGHTS[1]
    + ROW_WEIGHTS[2]
    + ROW_WEIGHTS[3]
    + 2 * REQUIRED_NONZERO_INTERSECTION;
#[cfg(test)]
const UNREACHABLE: u16 = u16::MAX;

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q174EnergyTheoremError {
    #[error("g41 q174 energy theorem semantic check failed")]
    SemanticMismatch,
    #[error("g41 q174 energy theorem received no source interfaces")]
    EmptyDomain,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174EnergyTheoremReport {
    pub source_interfaces: u64,
    pub row_weights: [u16; 4],
    pub required_shift_174_intersection: u16,
    pub target_zero_energy: u16,
    pub symbolic_lower_bound: u16,
    pub symbolic_target_gap: u16,
    pub minimum_combined_zero_energy: u16,
    pub target_gap: u16,
    pub interfaces_at_minimum: u64,
    pub attaining_interface: G41JointQuotientWitness,
    pub q174_orbit_classes: u8,
    pub paired_large_classes: [u8; 2],
    pub tripled_large_classes: [u8; 2],
    pub small_orbit_energies: [u8; SLOTS],
    pub tripled_large_orbit_energy: u8,
    pub projection_compile: ProjectedOrbitCompileReport,
    pub min_cost_workspace_bytes: u64,
    pub interface_digest: [u8; 32],
    pub excludes_target: bool,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174SymbolicBoundReport {
    pub row_weights: [u16; 4],
    pub target_zero_energy: u16,
    pub symbolic_lower_bound: u16,
    pub target_gap: u16,
    pub per_block_energy_offset: u16,
    pub maximum_mask_correction_per_block: u8,
    pub pair_lane_inequality_verified: bool,
    pub small_mask_identity_checks: u8,
    pub projection_compile: ProjectedOrbitCompileReport,
    pub verified: bool,
    pub provenance: &'static str,
}

#[derive(Clone, Copy)]
struct Q174Layout {
    class_of: [u8; Q174],
    class_sizes: [u8; Q174_CLASSES],
}

fn compile_layout() -> Result<Q174Layout, G41Q174EnergyTheoremError> {
    let mut class_of = [u8::MAX; Q174];
    let mut class_sizes = [0_u8; Q174_CLASSES];
    let mut classes = 0_usize;
    for residue in 0..Q174 {
        if class_of[residue] != u8::MAX {
            continue;
        }
        if classes == Q174_CLASSES {
            return Err(G41Q174EnergyTheoremError::SemanticMismatch);
        }
        let mut point = residue;
        loop {
            if class_of[point] != u8::MAX && class_of[point] != classes as u8 {
                return Err(G41Q174EnergyTheoremError::SemanticMismatch);
            }
            if class_of[point] == u8::MAX {
                class_of[point] = classes as u8;
                class_sizes[classes] += 1;
            }
            point = point * 41 % Q174;
            if point == residue {
                break;
            }
        }
        classes += 1;
    }
    if classes != Q174_CLASSES {
        return Err(G41Q174EnergyTheoremError::SemanticMismatch);
    }
    Ok(Q174Layout {
        class_of,
        class_sizes,
    })
}

fn orbit_class_amplitude(
    layout: &Q174Layout,
    orbit: &FineOrbit,
) -> Result<(usize, u8), G41Q174EnergyTheoremError> {
    let first = usize::from(orbit.points[0]) % Q174;
    let class = usize::from(layout.class_of[first]);
    let mut counts = [0_u8; Q174];
    for &point in &orbit.points[..usize::from(orbit.len)] {
        counts[usize::from(point) % Q174] += 1;
    }
    let amplitude = counts[first];
    if amplitude == 0
        || counts.iter().enumerate().any(|(residue, &count)| {
            count
                != if usize::from(layout.class_of[residue]) == class {
                    amplitude
                } else {
                    0
                }
        })
    {
        return Err(G41Q174EnergyTheoremError::SemanticMismatch);
    }
    Ok((class, amplitude))
}

fn orbit_energy(layout: &Q174Layout, orbit: &FineOrbit) -> Result<u16, G41Q174EnergyTheoremError> {
    let (class, amplitude) = orbit_class_amplitude(layout, orbit)?;
    Ok(u16::from(layout.class_sizes[class]) * u16::from(amplitude).pow(2))
}

/// Exact minimum of `4 * sum (a_i+b_i)^2` over seven classes, where
/// `a_i in {0,1}`, `b_i in {0,1,2}`, and the two prescribed sums are fixed.
#[cfg(test)]
fn paired_minimum_table() -> [[u16; 15]; 8] {
    let mut current = [[UNREACHABLE; 15]; 8];
    current[0][0] = 0;
    for _ in 0..7 {
        let mut next = [[UNREACHABLE; 15]; 8];
        for used_a in 0..=7 {
            for used_b in 0..=14 {
                let base = current[used_a][used_b];
                if base == UNREACHABLE {
                    continue;
                }
                for a in 0..=1 {
                    for b in 0..=2 {
                        if used_a + a > 7 || used_b + b > 14 {
                            continue;
                        }
                        let value = a + b;
                        let cost = base + 4 * (value * value) as u16;
                        let target = &mut next[used_a + a][used_b + b];
                        *target = (*target).min(cost);
                    }
                }
            }
        }
        current = next;
    }
    current
}

fn compile_projection_kernel(
    inventory: &FineInventory,
    layout: &Q174Layout,
) -> Result<
    (
        ProjectedOrbitMinCostKernel,
        [u8; SLOTS],
        [u8; 2],
        [u8; 2],
        u8,
    ),
    G41Q174EnergyTheoremError,
> {
    let small_energies: [u8; SLOTS] = std::array::from_fn(|slot| {
        orbit_energy(layout, &inventory.small[slot]).expect("compiled inventory must be semantic")
            as u8
    });
    let mut multiplicities = [[0_u8; SLOTS]; Q174_CLASSES];
    let mut items = Vec::with_capacity(
        inventory
            .large_len
            .iter()
            .map(|&length| usize::from(length))
            .sum(),
    );
    let mut tripled_energy = None;
    for slot in 0..SLOTS {
        for orbit in &inventory.large[slot][..usize::from(inventory.large_len[slot])] {
            let (class, amplitude) = orbit_class_amplitude(layout, orbit)?;
            multiplicities[class][slot] += 1;
            items.push(ProjectedOrbitItem {
                lane: class as u16,
                family: slot as u8,
                amplitude,
            });
            if slot >= 4 {
                let energy = u16::from(layout.class_sizes[class]) * u16::from(amplitude).pow(2);
                let energy: u8 = energy
                    .try_into()
                    .map_err(|_| G41Q174EnergyTheoremError::SemanticMismatch)?;
                if tripled_energy
                    .replace(energy)
                    .is_some_and(|old| old != energy)
                {
                    return Err(G41Q174EnergyTheoremError::SemanticMismatch);
                }
            }
        }
    }
    let paired = [
        multiplicities
            .iter()
            .filter(|lanes| lanes[0] == 1 && lanes[2] == 2 && lanes.iter().sum::<u8>() == 3)
            .count() as u8,
        multiplicities
            .iter()
            .filter(|lanes| lanes[1] == 1 && lanes[3] == 2 && lanes.iter().sum::<u8>() == 3)
            .count() as u8,
    ];
    let tripled = [
        multiplicities
            .iter()
            .filter(|lanes| lanes[4] == 1 && lanes.iter().sum::<u8>() == 1)
            .count() as u8,
        multiplicities
            .iter()
            .filter(|lanes| lanes[5] == 1 && lanes.iter().sum::<u8>() == 1)
            .count() as u8,
    ];
    for slot in 0..SLOTS {
        let (class, _) = orbit_class_amplitude(layout, &inventory.small[slot])?;
        if multiplicities[class].iter().sum::<u8>() != 0 {
            return Err(G41Q174EnergyTheoremError::SemanticMismatch);
        }
    }
    let lane_weights: [u16; Q174_CLASSES] = layout.class_sizes.map(u16::from);
    let kernel = ProjectedOrbitMinCostKernel::compile(
        &lane_weights,
        SLOTS as u8,
        &items,
        ProjectedOrbitBudget {
            maximum_states: 256,
        },
    )
    .map_err(|_| G41Q174EnergyTheoremError::SemanticMismatch)?;
    Ok((
        kernel,
        small_energies,
        paired,
        tripled,
        tripled_energy.ok_or(G41Q174EnergyTheoremError::SemanticMismatch)?,
    ))
}

fn block_minimum(
    witness: &G41JointQuotientWitness,
    block: usize,
    inventory: &FineInventory,
    table: &ProjectedOrbitMinCostTable,
    small_mask_energies: &[u16; 64],
) -> Result<u16, G41Q174EnergyTheoremError> {
    let counts = digit_counts(witness.digits[block]);
    if counts
        .iter()
        .zip(inventory.large_len)
        .any(|(&count, length)| count > length)
    {
        return Err(G41Q174EnergyTheoremError::SemanticMismatch);
    }
    let mask = witness.masks[block];
    table
        .minimum(&counts)
        .map_err(|_| G41Q174EnergyTheoremError::SemanticMismatch)?
        .checked_add(u32::from(small_mask_energies[usize::from(mask)]))
        .ok_or(G41Q174EnergyTheoremError::SemanticMismatch)?
        .try_into()
        .map_err(|_| G41Q174EnergyTheoremError::SemanticMismatch)
}

fn compile_small_mask_energies(
    inventory: &FineInventory,
    layout: &Q174Layout,
) -> Result<[u16; 64], G41Q174EnergyTheoremError> {
    let mut energies = [0_u16; 64];
    for mask in 0_u8..64 {
        let mut fixed = [0_u8; Q174_CLASSES];
        for slot in 0..SLOTS {
            if mask & (1 << slot) != 0 {
                let (class, amplitude) = orbit_class_amplitude(layout, &inventory.small[slot])?;
                fixed[class] += amplitude;
            }
        }
        energies[usize::from(mask)] = (0..Q174_CLASSES)
            .map(|class| u16::from(layout.class_sizes[class]) * u16::from(fixed[class]).pow(2))
            .sum();
    }
    Ok(energies)
}

fn update_digest(hasher: &mut Sha256, witness: &G41JointQuotientWitness) {
    hasher.update(witness.root_id.to_le_bytes());
    hasher.update(witness.masks);
    for digit in witness.digits {
        hasher.update(digit.to_le_bytes());
    }
}

fn compile_symbolic_bound(
    inventory: &FineInventory,
    layout: &Q174Layout,
    projection_compile: ProjectedOrbitCompileReport,
    small_orbit_energies: [u8; SLOTS],
    paired_large_classes: [u8; 2],
    tripled_large_classes: [u8; 2],
    tripled_large_orbit_energy: u8,
) -> Result<G41Q174SymbolicBoundReport, G41Q174EnergyTheoremError> {
    let pair_lane_inequality_verified =
        (0_i16..=3).all(|coefficient| 4 * coefficient * coefficient >= 12 * coefficient - 8);
    if !pair_lane_inequality_verified
        || paired_large_classes != [7, 7]
        || tripled_large_classes != [14, 14]
        || tripled_large_orbit_energy != 36
        || small_orbit_energies != [1, 1, 4, 4, 18, 18]
        || inventory.large_len != [7, 7, 14, 14, 14, 14]
    {
        return Err(G41Q174EnergyTheoremError::SemanticMismatch);
    }
    let small_source_weights = inventory.small.map(|orbit| orbit.len);
    if small_source_weights != [1, 1, 2, 2, 6, 6] {
        return Err(G41Q174EnergyTheoremError::SemanticMismatch);
    }
    for mask in 0_u8..64 {
        let mut fixed = [0_u8; Q174_CLASSES];
        let mut source_weight = 0_u16;
        for slot in 0..SLOTS {
            if mask & (1 << slot) == 0 {
                continue;
            }
            let (class, amplitude) = orbit_class_amplitude(layout, &inventory.small[slot])?;
            fixed[class] += amplitude;
            source_weight += u16::from(small_source_weights[slot]);
        }
        let energy = (0..Q174_CLASSES)
            .map(|class| u16::from(layout.class_sizes[class]) * u16::from(fixed[class]).pow(2))
            .sum::<u16>();
        let correction = u16::from(((mask & 1 != 0) ^ (mask & 4 != 0)) as u8)
            + u16::from(((mask & 2 != 0) ^ (mask & 8 != 0)) as u8);
        if i32::from(energy) - 3 * i32::from(source_weight) != -2 * i32::from(correction)
            || correction > 2
        {
            return Err(G41Q174EnergyTheoremError::SemanticMismatch);
        }
    }
    // Each paired four-point lane obeys 4*x^2 >= 12*x-8.
    // There are fourteen such lanes per block, hence offset 112.  The
    // independently checked small-mask identity can subtract at most four.
    const PER_BLOCK_OFFSET: u16 = 112 + 4;
    let symbolic_lower_bound = ROW_WEIGHTS
        .into_iter()
        .map(|weight| 3 * weight - PER_BLOCK_OFFSET)
        .sum::<u16>();
    Ok(G41Q174SymbolicBoundReport {
        row_weights: ROW_WEIGHTS,
        target_zero_energy: TARGET_ZERO_ENERGY,
        symbolic_lower_bound,
        target_gap: symbolic_lower_bound - TARGET_ZERO_ENERGY,
        per_block_energy_offset: PER_BLOCK_OFFSET,
        maximum_mask_correction_per_block: 2,
        pair_lane_inequality_verified,
        small_mask_identity_checks: 64,
        projection_compile,
        verified: symbolic_lower_bound > TARGET_ZERO_ENERGY,
        provenance: "cache-independent structural proof: the discovered q174 collision graph has two seven-lane unit-amplitude scopes and two disjoint tripled-amplitude scopes; 4*x^2 >= 12*x-8 on every paired lane, tripled orbit energy equals three times source weight, and exhaustive local replay of the 64 fixed small masks proves E_small-3*w_small=-2*h with h<=2, yielding E_block>=3*w-116 and combined E>=2665",
    })
}

pub fn prove_g41_q174_symbolic_bound(
) -> Result<G41Q174SymbolicBoundReport, G41Q174EnergyTheoremError> {
    let layout = compile_layout()?;
    let inventory = compile_inventory().map_err(|_| G41Q174EnergyTheoremError::SemanticMismatch)?;
    let (
        kernel,
        small_orbit_energies,
        paired_large_classes,
        tripled_large_classes,
        tripled_large_orbit_energy,
    ) = compile_projection_kernel(&inventory, &layout)?;
    compile_symbolic_bound(
        &inventory,
        &layout,
        kernel.report().clone(),
        small_orbit_energies,
        paired_large_classes,
        tripled_large_classes,
        tripled_large_orbit_energy,
    )
}

pub fn prove_g41_q174_zero_energy_bound(
    interfaces: &[G41JointQuotientWitness],
) -> Result<G41Q174EnergyTheoremReport, G41Q174EnergyTheoremError> {
    let first = interfaces
        .first()
        .copied()
        .ok_or(G41Q174EnergyTheoremError::EmptyDomain)?;
    let layout = compile_layout()?;
    let inventory = compile_inventory().map_err(|_| G41Q174EnergyTheoremError::SemanticMismatch)?;
    let (
        kernel,
        small_orbit_energies,
        paired_large_classes,
        tripled_large_classes,
        tripled_large_orbit_energy,
    ) = compile_projection_kernel(&inventory, &layout)?;
    let projection_compile = kernel.report().clone();
    let symbolic = compile_symbolic_bound(
        &inventory,
        &layout,
        projection_compile.clone(),
        small_orbit_energies,
        paired_large_classes,
        tripled_large_classes,
        tripled_large_orbit_energy,
    )?;
    let mut workspace = ProjectedOrbitMinCostWorkspace::new(256)
        .map_err(|_| G41Q174EnergyTheoremError::SemanticMismatch)?;
    let min_cost_workspace_bytes = workspace.workspace_bytes();
    let table = kernel
        .compile_quota_table(&[0; Q174_CLASSES], &mut workspace)
        .map_err(|_| G41Q174EnergyTheoremError::SemanticMismatch)?;
    let small_mask_energies = compile_small_mask_energies(&inventory, &layout)?;
    let mut minimum = u16::MAX;
    let mut at_minimum = 0_u64;
    let mut attaining = first;
    let mut hasher = Sha256::new();
    hasher.update(b"ergodis-private/g41-q174-zero-energy-bound/v1");
    for witness in interfaces {
        update_digest(&mut hasher, witness);
        let mut combined = 0_u16;
        for block in 0..4 {
            combined = combined
                .checked_add(block_minimum(
                    witness,
                    block,
                    &inventory,
                    &table,
                    &small_mask_energies,
                )?)
                .ok_or(G41Q174EnergyTheoremError::SemanticMismatch)?;
        }
        if combined < minimum {
            minimum = combined;
            at_minimum = 1;
            attaining = *witness;
        } else if combined == minimum {
            at_minimum += 1;
        }
    }
    Ok(G41Q174EnergyTheoremReport {
        source_interfaces: interfaces.len() as u64,
        row_weights: ROW_WEIGHTS,
        required_shift_174_intersection: REQUIRED_NONZERO_INTERSECTION,
        target_zero_energy: TARGET_ZERO_ENERGY,
        symbolic_lower_bound: symbolic.symbolic_lower_bound,
        symbolic_target_gap: symbolic.target_gap,
        minimum_combined_zero_energy: minimum,
        target_gap: minimum.saturating_sub(TARGET_ZERO_ENERGY),
        interfaces_at_minimum: at_minimum,
        attaining_interface: attaining,
        q174_orbit_classes: Q174_CLASSES as u8,
        paired_large_classes,
        tripled_large_classes,
        small_orbit_energies,
        tripled_large_orbit_energy,
        projection_compile,
        min_cost_workspace_bytes,
        interface_digest: hasher.finalize().into(),
        excludes_target: minimum > TARGET_ZERO_ENERGY,
        provenance: "typed g41 adapter over the domain-neutral projected-orbit min-cost engine: fine orbits are independently classified under projection mod 174, the engine discovers connected family/lane collision scopes from their contributions and solves them by bounded iterative DP, and every sealed exact q18 source interface is scanned with one allocation-free workspace; no search miss or evolved hypothesis is used as proof",
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    fn brute_pair(classes: u8, count_a: u8, count_b: u8) -> u16 {
        let items = 3 * classes;
        let mut best = u16::MAX;
        for mask in 0_u64..1_u64 << items {
            let mut seen_a = 0_u8;
            let mut seen_b = 0_u8;
            let mut energy = 0_u16;
            for class in 0..classes {
                let base = 3 * class;
                let a = ((mask >> base) & 1) as u8;
                let b = ((mask >> (base + 1)) & 1) as u8 + ((mask >> (base + 2)) & 1) as u8;
                seen_a += a;
                seen_b += b;
                energy += 4 * u16::from(a + b).pow(2);
            }
            if seen_a == count_a && seen_b == count_b {
                best = best.min(energy);
            }
        }
        best
    }

    #[test]
    fn seven_class_dp_matches_independent_small_brute_force() {
        for classes in 1..=4_u8 {
            let mut current = [[UNREACHABLE; 15]; 8];
            current[0][0] = 0;
            for _ in 0..classes {
                let mut next = [[UNREACHABLE; 15]; 8];
                for used_a in 0..=usize::from(classes) {
                    for used_b in 0..=2 * usize::from(classes) {
                        let base = current[used_a][used_b];
                        if base == UNREACHABLE {
                            continue;
                        }
                        for a in 0..=1 {
                            for b in 0..=2 {
                                let cost = base + 4 * ((a + b) * (a + b)) as u16;
                                let cell = &mut next[used_a + a][used_b + b];
                                *cell = (*cell).min(cost);
                            }
                        }
                    }
                }
                current = next;
            }
            for count_a in 0..=classes {
                for count_b in 0..=2 * classes {
                    assert_eq!(
                        current[usize::from(count_a)][usize::from(count_b)],
                        brute_pair(classes, count_a, count_b)
                    );
                }
            }
        }
    }

    #[test]
    fn compiled_inventory_has_the_proved_projection_shape() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let (kernel, small, paired, tripled, tripled_energy) =
            compile_projection_kernel(&inventory, &layout).unwrap();
        assert_eq!(small, [1, 1, 4, 4, 18, 18]);
        assert_eq!(paired, [7, 7]);
        assert_eq!(tripled, [14, 14]);
        assert_eq!(tripled_energy, 36);
        assert_eq!(kernel.report().collision_components, 4);
    }

    #[test]
    fn target_energy_is_independently_derived_from_compression_identity() {
        let word: [u8; 522] = std::array::from_fn(|index| {
            u8::from(index % 7 == 0 || index % 11 == 3 || index % 19 == 5)
        });
        let coefficients: [u8; Q174] = std::array::from_fn(|residue| {
            word[residue] + word[residue + Q174] + word[residue + 2 * Q174]
        });
        let energy = coefficients
            .iter()
            .map(|&value| u32::from(value).pow(2))
            .sum::<u32>();
        let weight = word.iter().map(|&value| u32::from(value)).sum::<u32>();
        let correlation = |shift: usize| {
            (0..word.len())
                .map(|index| u32::from(word[index] * word[(index + shift) % word.len()]))
                .sum::<u32>()
        };
        assert_eq!(energy, weight + correlation(174) + correlation(348));
        assert_eq!(TARGET_ZERO_ENERGY, 1_043 + 2 * 520);
    }

    #[test]
    fn cache_independent_symbolic_bound_excludes_target() {
        let proof = prove_g41_q174_symbolic_bound().unwrap();
        assert!(proof.verified);
        assert_eq!(proof.symbolic_lower_bound, 2_665);
        assert_eq!(proof.target_gap, 582);
        assert_eq!(proof.small_mask_identity_checks, 64);
        assert_eq!(proof.projection_compile.collision_components, 4);
    }

    #[test]
    fn block_pair_minimum_matches_direct_fine_orbit_selections() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let table = paired_minimum_table();
        let count_a = 2_u32;
        let count_b = 3_u32;
        let mut best = u16::MAX;
        for selected_a in 0_u16..1 << inventory.large_len[0] {
            if selected_a.count_ones() != count_a {
                continue;
            }
            for selected_b in 0_u16..1 << inventory.large_len[2] {
                if selected_b.count_ones() != count_b {
                    continue;
                }
                let mut coefficients = [0_u8; Q174];
                for (slot, selected) in [(0, selected_a), (2, selected_b)] {
                    for orbit in 0..inventory.large_len[slot] {
                        if selected & (1 << orbit) == 0 {
                            continue;
                        }
                        for &point in &inventory.large[slot][usize::from(orbit)].points
                            [..usize::from(inventory.large[slot][usize::from(orbit)].len)]
                        {
                            coefficients[usize::from(point) % Q174] += 1;
                        }
                    }
                }
                best = best.min(
                    coefficients
                        .iter()
                        .map(|&value| u16::from(value).pow(2))
                        .sum(),
                );
            }
        }
        assert_eq!(best, table[count_a as usize][count_b as usize]);
        assert_eq!(
            compile_projection_kernel(&inventory, &layout).unwrap().2[0],
            7
        );
    }

    #[test]
    fn precomputed_small_mask_energy_matches_direct_projection() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let energies = compile_small_mask_energies(&inventory, &layout).unwrap();
        for mask in 0_u8..64 {
            let mut coefficients = [0_u8; Q174];
            for slot in 0..SLOTS {
                if mask & (1 << slot) == 0 {
                    continue;
                }
                for &point in
                    &inventory.small[slot].points[..usize::from(inventory.small[slot].len)]
                {
                    coefficients[usize::from(point) % Q174] += 1;
                }
            }
            let direct = coefficients
                .iter()
                .map(|&coefficient| u16::from(coefficient).pow(2))
                .sum::<u16>();
            assert_eq!(energies[usize::from(mask)], direct);
        }
    }
}
