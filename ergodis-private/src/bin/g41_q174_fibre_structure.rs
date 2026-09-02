use std::collections::{BTreeMap, BTreeSet};
use std::fs::File;
use std::path::PathBuf;

use anyhow::{Context, Result};
use clap::Parser;
use ergodis_private::g41_q174_joint::{
    prove_g41_q174_coset_complement_symmetry, G41Q174SourceFeasibilityWorkspace,
};
use serde::{Deserialize, Serialize};
use serde_json::json;

const LANES: usize = 46;

#[derive(Parser)]
struct Args {
    input: PathBuf,
}

#[derive(Deserialize)]
struct Input {
    masks: [u8; 4],
    digits: [u32; 4],
    q29_coefficients: [[u8; 8]; 4],
    target_fibres: [TargetFibre; 4],
}

#[derive(Deserialize)]
struct TargetFibre {
    states_by_target: Vec<Vec<u128>>,
}

#[derive(Serialize)]
struct FibreStructure {
    block: u8,
    target: u16,
    states: u32,
    varying_lanes: u8,
    lane_cartesian_product: u128,
    xor_affine_rank: u8,
    xor_affine_subspace: bool,
    maximum_xor_weight_from_minimum: u8,
    minimum_xor_weight_between_states: u8,
    xor_basis_hex: Vec<String>,
    proved_flip_components: u16,
    largest_proved_flip_component: u16,
    missing_profile_preserving_flips: u32,
    missing_source_feasible_flips: u32,
}

#[derive(Serialize)]
struct GeneratorFrequency {
    generator_hex: String,
    fibres: u16,
    bit_weight: u8,
    changed_lanes: Vec<u8>,
    lane_xor_masks: Vec<u8>,
    representative_residues: Vec<u8>,
    q29_orbit_minima: Vec<u8>,
    lane_value_patterns: Vec<Vec<u8>>,
}

#[inline(always)]
fn lane(state: u128, index: usize) -> u8 {
    ((state >> (2 * index)) & 3) as u8
}

fn lane_representatives() -> [u8; LANES] {
    let mut seen = [false; 174];
    let mut representatives = [0_u8; LANES];
    let mut classes = 0_usize;
    for residue in 0..174 {
        if seen[residue] {
            continue;
        }
        representatives[classes] = residue as u8;
        classes += 1;
        let mut point = residue;
        loop {
            seen[point] = true;
            point = point * 41 % 174;
            if point == residue {
                break;
            }
        }
    }
    assert_eq!(classes, LANES);
    representatives
}

fn q29_orbit_minimum(residue: u8) -> u8 {
    let residue = residue % 29;
    let mut point = residue;
    let mut minimum = residue;
    loop {
        minimum = minimum.min(point);
        point = ((usize::from(point) * 41) % 29) as u8;
        if point == residue {
            return minimum;
        }
    }
}

fn insert_basis(basis: &mut [u128; 92], mut value: u128) -> bool {
    while value != 0 {
        let pivot = value.ilog2() as usize;
        if basis[pivot] == 0 {
            basis[pivot] = value;
            return true;
        }
        value ^= basis[pivot];
    }
    false
}

fn reduced_basis(states: &[u128]) -> Vec<u128> {
    let mut basis = [0_u128; 92];
    let origin = states[0];
    for &state in &states[1..] {
        insert_basis(&mut basis, state ^ origin);
    }
    for pivot in 0..92 {
        if basis[pivot] == 0 {
            continue;
        }
        for other in 0..92 {
            if other != pivot && basis[other] & (1_u128 << pivot) != 0 {
                basis[other] ^= basis[pivot];
            }
        }
    }
    basis.into_iter().filter(|&value| value != 0).collect()
}

fn analyze(
    block: usize,
    target: usize,
    states: &[u128],
    workspace: &mut G41Q174SourceFeasibilityWorkspace,
    coefficients: [u8; 8],
    generator_words: [[u64; 2]; 7],
    changed_lanes: [[u8; 4]; 7],
    valid_patterns: [[u8; 6]; 7],
    valid_pattern_counts: [u8; 7],
) -> FibreStructure {
    let minimum = states[0];
    let mut varying_lanes = 0_u8;
    let mut lane_cartesian_product = 1_u128;
    for index in 0..LANES {
        let mut values = 0_u8;
        for &state in states {
            values |= 1 << lane(state, index);
        }
        let cardinality = values.count_ones() as u8;
        if cardinality > 1 {
            varying_lanes += 1;
        }
        lane_cartesian_product = lane_cartesian_product.saturating_mul(u128::from(cardinality));
    }
    let mut basis = [0_u128; 92];
    let mut xor_affine_rank = 0_u8;
    let mut maximum_xor_weight_from_minimum = 0_u8;
    let mut minimum_xor_weight_between_states = u8::MAX;
    for (index, &state) in states.iter().enumerate() {
        let difference = state ^ minimum;
        maximum_xor_weight_from_minimum =
            maximum_xor_weight_from_minimum.max(difference.count_ones() as u8);
        xor_affine_rank += u8::from(insert_basis(&mut basis, difference));
        for &other in &states[..index] {
            minimum_xor_weight_between_states =
                minimum_xor_weight_between_states.min((state ^ other).count_ones() as u8);
        }
    }
    if states.len() < 2 {
        minimum_xor_weight_between_states = 0;
    }
    let expected_size = 1_usize.checked_shl(u32::from(xor_affine_rank));
    let xor_affine_subspace = expected_size == Some(states.len());
    let state_set: BTreeSet<_> = states.iter().copied().collect();
    let mut visited = BTreeSet::new();
    let mut proved_flip_components = 0_u16;
    let mut largest_proved_flip_component = 0_u16;
    let mut missing_profile_preserving_flips = 0_u32;
    let mut missing_source_feasible_flips = 0_u32;
    for &seed in states {
        if visited.contains(&seed) {
            continue;
        }
        proved_flip_components += 1;
        let mut stack = vec![seed];
        visited.insert(seed);
        let mut component_size = 0_u16;
        while let Some(state) = stack.pop() {
            component_size += 1;
            for coordinate in 0..7 {
                let mut pattern = 0_u8;
                let mut binary = true;
                for (index, &changed_lane) in changed_lanes[coordinate].iter().enumerate() {
                    match lane(state, usize::from(changed_lane)) {
                        0 => {}
                        3 => pattern |= 1 << index,
                        _ => binary = false,
                    }
                }
                if !binary
                    || !valid_patterns[coordinate][..usize::from(valid_pattern_counts[coordinate])]
                        .contains(&pattern)
                {
                    continue;
                }
                let generator = u128::from(generator_words[coordinate][0])
                    | (u128::from(generator_words[coordinate][1]) << 64);
                let next = state ^ generator;
                if state_set.contains(&next) {
                    if visited.insert(next) {
                        stack.push(next);
                    }
                } else {
                    missing_profile_preserving_flips += 1;
                    missing_source_feasible_flips +=
                        u32::from(workspace.check(coefficients, next).unwrap());
                }
            }
        }
        largest_proved_flip_component = largest_proved_flip_component.max(component_size);
    }
    FibreStructure {
        block: block as u8,
        target: target as u16,
        states: states.len() as u32,
        varying_lanes,
        lane_cartesian_product,
        xor_affine_rank,
        xor_affine_subspace,
        maximum_xor_weight_from_minimum,
        minimum_xor_weight_between_states,
        xor_basis_hex: xor_affine_subspace
            .then(|| {
                reduced_basis(states)
                    .into_iter()
                    .map(|generator| format!("{generator:023x}"))
                    .collect()
            })
            .unwrap_or_default(),
        proved_flip_components,
        largest_proved_flip_component,
        missing_profile_preserving_flips,
        missing_source_feasible_flips,
    }
}

fn main() -> Result<()> {
    let args = Args::parse();
    let input: Input = serde_json::from_reader(
        File::open(&args.input).with_context(|| format!("open {}", args.input.display()))?,
    )?;
    let mut structures = Vec::new();
    let mut cardinalities = BTreeSet::new();
    let mut generator_frequencies = BTreeMap::<u128, u16>::new();
    let proof = prove_g41_q174_coset_complement_symmetry()?;
    for block in 0..4 {
        let mut workspace =
            G41Q174SourceFeasibilityWorkspace::new(input.masks[block], input.digits[block])?;
        for (target, states) in input.target_fibres[block]
            .states_by_target
            .iter()
            .enumerate()
        {
            if states.is_empty() {
                continue;
            }
            cardinalities.insert(states.len());
            let structure = analyze(
                block,
                target,
                states,
                &mut workspace,
                input.q29_coefficients[block],
                proof.generator_words,
                proof.changed_lanes,
                proof.valid_pattern_masks,
                proof.valid_pattern_counts,
            );
            if structure.xor_affine_subspace {
                for generator in reduced_basis(states) {
                    *generator_frequencies.entry(generator).or_default() += 1;
                }
            }
            structures.push(structure);
        }
    }
    let representatives = lane_representatives();
    let mut generators: Vec<_> = generator_frequencies
        .into_iter()
        .map(|(generator, fibres)| {
            let mut changed_lanes = Vec::new();
            let mut lane_xor_masks = Vec::new();
            for lane in 0..LANES {
                let mask = ((generator >> (2 * lane)) & 3) as u8;
                if mask != 0 {
                    changed_lanes.push(lane as u8);
                    lane_xor_masks.push(mask);
                }
            }
            let representative_residues: Vec<_> = changed_lanes
                .iter()
                .map(|&lane| representatives[usize::from(lane)])
                .collect();
            let q29_orbit_minima = representative_residues
                .iter()
                .map(|&residue| q29_orbit_minimum(residue))
                .collect();
            let mut lane_value_patterns = BTreeSet::new();
            for block in &input.target_fibres {
                for states in &block.states_by_target {
                    let state_set: BTreeSet<_> = states.iter().copied().collect();
                    for &state in states {
                        if state_set.contains(&(state ^ generator)) {
                            lane_value_patterns.insert(
                                changed_lanes
                                    .iter()
                                    .map(|&index| lane(state, usize::from(index)))
                                    .collect::<Vec<_>>(),
                            );
                        }
                    }
                }
            }
            GeneratorFrequency {
                generator_hex: format!("{generator:023x}"),
                fibres,
                bit_weight: generator.count_ones() as u8,
                changed_lanes,
                lane_xor_masks,
                representative_residues,
                q29_orbit_minima,
                lane_value_patterns: lane_value_patterns.into_iter().collect(),
            }
        })
        .collect();
    generators.sort_unstable_by_key(|generator| {
        (
            std::cmp::Reverse(generator.fibres),
            generator.generator_hex.clone(),
        )
    });
    serde_json::to_writer_pretty(
        std::io::stdout(),
        &json!({
            "structures": structures,
            "generator_frequencies": generators,
            "distinct_cardinalities": cardinalities,
            "provenance": "discovery-only algebraic structure census over presentation-supplied packed q174 target fibres; every promoted symmetry must be independently proved against canonical extractors and source membership",
        }),
    )?;
    println!();
    Ok(())
}
