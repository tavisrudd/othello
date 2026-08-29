use ergodis::observational::{
    compile_layered_observational, compile_observational_with_policy, read_frozen_observation,
    verify_frozen_layered_audit, write_frozen_observation, write_layered_audit, CertificatePolicy,
    CompiledObservation, FinitePresentation, FrozenObservationLimits, GeneratorSpec,
    LayeredGeneratorSpec,
};
#[cfg(test)]
use ergodis::{CompositionTable, CostTable, Matrix};
use std::collections::{BTreeMap, BTreeSet};
use std::hint::black_box;
use std::io::Write;
use std::time::Instant;

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct RecoveryProfile([u32; 4]);

#[cfg(test)]
fn profile_table(costs: [u32; 2]) -> CostTable {
    CostTable::from_entries::<2>(
        1,
        1,
        (0_u8..2).map(|label| {
            (
                Matrix::new::<2>(1, 1, vec![label]).unwrap(),
                costs[label as usize],
            )
        }),
    )
    .unwrap()
}

#[cfg(test)]
fn hierarchy_step_reference(profile: RecoveryProfile, context: usize) -> RecoveryProfile {
    let coefficients = [(1_u8, 0_u8), (0, 1), (1, 1)][context];
    let blocks = [
        Matrix::new::<2>(1, 1, vec![coefficients.0]).unwrap(),
        Matrix::new::<2>(1, 1, vec![coefficients.1]).unwrap(),
    ];
    let ordinary = profile_table([profile.0[0], profile.0[1]]);
    let target = profile_table([profile.0[2], profile.0[3]]);
    let ordinary_composed = CompositionTable::compose::<2>(&blocks, &ordinary).unwrap();
    let target_composed =
        CompositionTable::compose_with_target::<2>(&blocks, &ordinary, &target, 0).unwrap();
    let mut result = [0_u32; 4];
    for label in 0_u8..2 {
        let matrix = Matrix::new::<2>(1, 1, vec![label]).unwrap();
        result[label as usize] = ordinary_composed
            .answer::<2>(&matrix)
            .unwrap()
            .unwrap()
            .cost;
        result[2 + label as usize] = target_composed.answer::<2>(&matrix).unwrap().unwrap().cost;
    }
    RecoveryProfile(result)
}

#[inline]
fn add_cost(left: u32, right: u32) -> u32 {
    left.checked_add(right).expect("hierarchy cost overflow")
}

#[inline]
fn hierarchy_step(profile: RecoveryProfile, context: usize) -> RecoveryProfile {
    let [ordinary_zero, ordinary_one, target_zero, target_one] = profile.0;
    let ordinary_minimum = ordinary_zero.min(ordinary_one);
    let next = match context {
        0 => [
            add_cost(ordinary_zero, ordinary_minimum),
            add_cost(ordinary_one, ordinary_minimum),
            add_cost(target_zero, ordinary_minimum),
            add_cost(target_one, ordinary_minimum),
        ],
        1 => {
            let target_minimum = target_zero.min(target_one);
            [
                add_cost(ordinary_zero, ordinary_minimum),
                add_cost(ordinary_one, ordinary_minimum),
                add_cost(ordinary_zero, target_minimum),
                add_cost(ordinary_one, target_minimum),
            ]
        }
        2 => [
            add_cost(ordinary_zero, ordinary_zero).min(add_cost(ordinary_one, ordinary_one)),
            add_cost(ordinary_zero, ordinary_one),
            add_cost(target_zero, ordinary_zero).min(add_cost(target_one, ordinary_one)),
            add_cost(target_zero, ordinary_one).min(add_cost(target_one, ordinary_zero)),
        ],
        _ => panic!("unknown hierarchy context {context}"),
    };
    RecoveryProfile(next)
}

#[inline]
fn layered_transition_id(seed_bound: u32, generator: u32, state: u32) -> u32 {
    let level = generator / 3;
    let context = generator % 3;
    if level == 0 {
        let ordinary = state / seed_bound + 1;
        let zero_sector = state % seed_bound + 1;
        let target_parameter = match context {
            0 => zero_sector,
            1 => 0,
            2 => zero_sector.min(ordinary),
            _ => unreachable!(),
        };
        return (ordinary - 1) * (seed_bound + 1) + target_parameter;
    }
    let ordinary = state / (seed_bound + 1) + 1;
    let target_parameter = state % (seed_bound + 1);
    let next_parameter = if target_parameter == 0 {
        0
    } else {
        match context {
            0 => target_parameter,
            1 => 0,
            2 => target_parameter.min(ordinary),
            _ => unreachable!(),
        }
    };
    (ordinary - 1) * (seed_bound + 1) + next_parameter
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn scalar_hierarchy_step_matches_composition_oracle() {
        for ordinary_zero in 0..=4 {
            for ordinary_one in 0..=4 {
                for target_zero in 0..=4 {
                    for target_one in 0..=4 {
                        let profile =
                            RecoveryProfile([ordinary_zero, ordinary_one, target_zero, target_one]);
                        for context in 0..3 {
                            assert_eq!(
                                hierarchy_step(profile, context),
                                hierarchy_step_reference(profile, context),
                                "profile={profile:?} context={context}"
                            );
                        }
                    }
                }
            }
        }
    }

    #[test]
    fn closed_form_layered_ids_match_profile_transitions() {
        for seed_bound in 1..=12 {
            let profiles = build_profiles(4, seed_bound);
            for level in 0..=4 {
                for state in 0..profiles[level].len() as u32 {
                    let algebraic_output = if level == 0 || state % (seed_bound + 1) != 0 {
                        0
                    } else {
                        state / (seed_bound + 1) + 1
                    };
                    assert_eq!(profiles[level][state as usize].0[3], algebraic_output);
                    if level == 4 {
                        continue;
                    }
                    for context in 0..3_u32 {
                        let target =
                            hierarchy_step(profiles[level][state as usize], context as usize);
                        let target_state =
                            layered_transition_id(seed_bound, 3 * level as u32 + context, state);
                        assert_eq!(profiles[level + 1][target_state as usize], target);
                    }
                }
            }
        }
    }
}

struct HierarchyMachine {
    presentation: FinitePresentation,
    profiles: Vec<Vec<RecoveryProfile>>,
}

fn build_profiles(depth: usize, seed_bound: u32) -> Vec<Vec<RecoveryProfile>> {
    let first = (1..=seed_bound)
        .flat_map(|ordinary| {
            (1..=seed_bound).map(move |zero_sector| RecoveryProfile([0, ordinary, zero_sector, 0]))
        })
        .collect::<Vec<_>>();
    let mut profiles = Vec::with_capacity(depth + 1);
    profiles.push(first);
    for level in 0..depth {
        let next = profiles[level]
            .iter()
            .flat_map(|&profile| (0..3).map(move |context| hierarchy_step(profile, context)))
            .collect::<BTreeSet<_>>()
            .into_iter()
            .collect();
        profiles.push(next);
    }
    profiles
}

fn build_machine(depth: usize, seed_bound: u32) -> HierarchyMachine {
    let profiles = build_profiles(depth, seed_bound);
    let mut next_offset = 0_u32;
    let offsets = profiles
        .iter()
        .map(|states| {
            let offset = next_offset;
            next_offset += states.len() as u32;
            offset
        })
        .collect::<Vec<_>>();
    let ids = profiles
        .iter()
        .zip(&offsets)
        .map(|(states, &offset)| {
            states
                .iter()
                .copied()
                .enumerate()
                .map(|(index, profile)| (profile, offset + index as u32))
                .collect::<BTreeMap<_, _>>()
        })
        .collect::<Vec<_>>();
    let mut generators = Vec::with_capacity(depth * 3);
    for level in 0..depth {
        for context in 0..3 {
            generators.push(GeneratorSpec {
                source_sort: level as u32,
                target_sort: level as u32 + 1,
                transitions: profiles[level]
                    .iter()
                    .map(|&profile| ids[level + 1][&hierarchy_step(profile, context)])
                    .collect(),
            });
        }
    }
    let observations = profiles
        .iter()
        .flat_map(|states| states.iter().map(|profile| profile.0[3]))
        .collect::<Vec<_>>();
    let presentation = FinitePresentation::new(
        profiles.iter().map(|states| states.len() as u32),
        observations,
        generators,
    )
    .unwrap();
    HierarchyMachine {
        presentation,
        profiles,
    }
}

fn compile_layered_hierarchy(
    depth: usize,
    seed_bound: u32,
) -> Result<CompiledObservation, ergodis::observational::ObservationalError> {
    let generators = hierarchy_generators(depth);
    let state_counts = hierarchy_state_counts(depth, seed_bound);
    compile_layered_observational(
        &state_counts,
        &generators,
        |sort, state| hierarchy_observation(seed_bound, sort, state),
        |generator, state| layered_transition_id(seed_bound, generator, state),
    )
}

fn hierarchy_generators(depth: usize) -> Vec<LayeredGeneratorSpec> {
    (0..depth)
        .flat_map(|level| {
            (0..3).map(move |_| LayeredGeneratorSpec {
                source_sort: level as u32,
                target_sort: level as u32 + 1,
            })
        })
        .collect()
}

fn hierarchy_observation(seed_bound: u32, sort: u32, state: u32) -> u32 {
    if sort == 0 || state % (seed_bound + 1) != 0 {
        0
    } else {
        state / (seed_bound + 1) + 1
    }
}

fn hierarchy_state_counts(depth: usize, seed_bound: u32) -> Vec<u32> {
    let mut state_counts = Vec::with_capacity(depth + 1);
    state_counts.push(
        seed_bound
            .checked_mul(seed_bound)
            .expect("hierarchy state count overflow"),
    );
    let repeated_count = seed_bound
        .checked_mul(seed_bound + 1)
        .expect("hierarchy state count overflow");
    state_counts.resize(depth + 1, repeated_count);
    state_counts
}

fn hierarchy_frozen_limits(depth: usize, seed_bound: u32) -> FrozenObservationLimits {
    let states = hierarchy_state_counts(depth, seed_bound)
        .into_iter()
        .map(|count| count as usize)
        .sum();
    FrozenObservationLimits {
        maximum_sorts: depth + 1,
        maximum_states: states,
        maximum_entry_states: (seed_bound as usize) * seed_bound as usize,
        maximum_classes: states,
        maximum_generators: 3 * depth,
        maximum_transitions: states.saturating_mul(3 * depth),
    }
}

fn words(depth: usize) -> Vec<Box<[u8]>> {
    let count = 3_usize.pow(depth as u32);
    (0..count)
        .map(|mut word| {
            let mut contexts = vec![0_u8; depth];
            for context in &mut contexts {
                *context = (word % 3) as u8;
                word /= 3;
            }
            contexts.into_boxed_slice()
        })
        .collect()
}

fn mix(checksum: u64, value: u32) -> u64 {
    checksum.rotate_left(9) ^ u64::from(value).wrapping_mul(0x9e37_79b9)
}

fn next_random(state: &mut u64) -> u64 {
    *state ^= *state << 13;
    *state ^= *state >> 7;
    *state ^= *state << 17;
    *state
}

fn time_raw(machine: &HierarchyMachine, queries: &[Box<[u8]>], repetitions: usize) -> (u128, u64) {
    let start_time = Instant::now();
    let mut checksum = 0_u64;
    for _ in 0..repetitions {
        for start in 0..machine.profiles[0].len() as u32 {
            for contexts in queries {
                let mut state = start;
                for (level, &context) in contexts.iter().enumerate() {
                    state = machine
                        .presentation
                        .transition(3 * level as u32 + u32::from(context), state)
                        .unwrap();
                }
                checksum = mix(
                    checksum,
                    black_box(machine.presentation.observations()[state as usize]),
                );
            }
        }
    }
    (start_time.elapsed().as_nanos(), checksum)
}

fn time_quotient(
    machine: &HierarchyMachine,
    compiled: &CompiledObservation,
    queries: &[Box<[u8]>],
    repetitions: usize,
) -> (u128, u64) {
    let start_time = Instant::now();
    let mut checksum = 0_u64;
    for _ in 0..repetitions {
        for start in 0..machine.profiles[0].len() {
            for contexts in queries {
                let mut class = compiled.state_classes()[start];
                for (level, &context) in contexts.iter().enumerate() {
                    class = compiled
                        .transition(3 * level as u32 + u32::from(context), class)
                        .unwrap();
                }
                checksum = mix(
                    checksum,
                    black_box(compiled.class_outputs()[class as usize]),
                );
            }
        }
    }
    (start_time.elapsed().as_nanos(), checksum)
}

fn time_random_raw(
    machine: &HierarchyMachine,
    queries: &[Box<[u8]>],
    random_queries: &[(u32, u32)],
    repetitions: usize,
) -> (u128, u64) {
    let start_time = Instant::now();
    let mut checksum = 0_u64;
    for _ in 0..repetitions {
        for &(start, word) in random_queries {
            let mut state = start;
            for (level, &context) in queries[word as usize].iter().enumerate() {
                state = machine
                    .presentation
                    .transition(3 * level as u32 + u32::from(context), state)
                    .unwrap();
            }
            checksum = mix(
                checksum,
                black_box(machine.presentation.observations()[state as usize]),
            );
        }
    }
    (start_time.elapsed().as_nanos(), checksum)
}

fn time_random_quotient(
    compiled: &CompiledObservation,
    queries: &[Box<[u8]>],
    random_queries: &[(u32, u32)],
    repetitions: usize,
) -> (u128, u64) {
    let start_time = Instant::now();
    let mut checksum = 0_u64;
    for _ in 0..repetitions {
        for &(start, word) in random_queries {
            let mut class = compiled.state_classes()[start as usize];
            for (level, &context) in queries[word as usize].iter().enumerate() {
                class = compiled
                    .transition(3 * level as u32 + u32::from(context), class)
                    .unwrap();
            }
            checksum = mix(
                checksum,
                black_box(compiled.class_outputs()[class as usize]),
            );
        }
    }
    (start_time.elapsed().as_nanos(), checksum)
}

fn main() {
    let mut args = std::env::args().skip(1);
    let depth = args.next().map_or(4, |value| value.parse().unwrap());
    let cached_repetitions = args.next().map_or(10_000, |value| value.parse().unwrap());
    let direct_repetitions = args.next().map_or(1, |value| value.parse().unwrap());
    let seed_bound = args.next().map_or(3, |value| value.parse().unwrap());
    let quotient_first = match args.next().as_deref() {
        None | Some("raw-first") => false,
        Some("quotient-first") => true,
        Some(value) => panic!("unknown order {value}"),
    };
    let mode = args.next().unwrap_or_else(|| "full".to_owned());
    let frozen_path = (mode == "layered-artifacts" || mode == "layered-artifacts-verify")
        .then(|| args.next().expect("layered-artifacts needs a frozen path"));
    let audit_path = (mode == "layered-audit"
        || mode == "layered-audit-verify"
        || mode == "layered-artifacts"
        || mode == "layered-artifacts-verify")
        .then(|| args.next().expect("layered audit needs an output path"));
    assert!(
        mode == "full"
            || mode == "raw-build-only"
            || mode == "generic-build-only"
            || mode == "layered-build-only"
            || mode == "layered-audit"
            || mode == "layered-audit-verify"
            || mode == "layered-artifacts"
            || mode == "layered-artifacts-verify"
    );
    assert!(depth >= 1 && seed_bound >= 1);
    assert!(args.next().is_none());

    if let Some(audit_path) = audit_path {
        let state_counts = hierarchy_state_counts(depth, seed_bound);
        let generators = hierarchy_generators(depth);
        let load_only = mode == "layered-artifacts-verify";
        let compile_start = Instant::now();
        let compiled = if load_only {
            None
        } else {
            Some(compile_layered_hierarchy(depth, seed_bound).unwrap())
        };
        let mut compile_ns = compile_start.elapsed().as_nanos();
        let write_ns = if mode == "layered-audit" || mode == "layered-artifacts" {
            let file = std::fs::File::create(&audit_path).unwrap();
            let mut writer = std::io::BufWriter::with_capacity(64 * 1024, file);
            let write_start = Instant::now();
            write_layered_audit(
                &state_counts,
                &generators,
                |sort, state| hierarchy_observation(seed_bound, sort, state),
                |generator, state| layered_transition_id(seed_bound, generator, state),
                compiled.as_ref().unwrap(),
                &mut writer,
            )
            .unwrap();
            writer.flush().unwrap();
            drop(writer);
            write_start.elapsed().as_nanos()
        } else {
            0
        };
        let frozen = if load_only {
            let load_start = Instant::now();
            let file = std::fs::File::open(frozen_path.as_ref().unwrap()).unwrap();
            let mut reader = std::io::BufReader::with_capacity(64 * 1024, file);
            let frozen =
                read_frozen_observation(&mut reader, hierarchy_frozen_limits(depth, seed_bound))
                    .unwrap();
            compile_ns = load_start.elapsed().as_nanos();
            frozen
        } else {
            compiled.unwrap().into_frozen(&state_counts, &[0]).unwrap()
        };
        if mode == "layered-artifacts" {
            let file = std::fs::File::create(frozen_path.as_ref().unwrap()).unwrap();
            let mut writer = std::io::BufWriter::with_capacity(64 * 1024, file);
            write_frozen_observation(&frozen, &mut writer).unwrap();
            writer.flush().unwrap();
        }
        let file = std::fs::File::open(&audit_path).unwrap();
        let mut reader = std::io::BufReader::with_capacity(64 * 1024, file);
        let verify_start = Instant::now();
        verify_frozen_layered_audit(&frozen, &mut reader).unwrap();
        let verify_ns = verify_start.elapsed().as_nanos();
        println!(
            "layered-audit\t{depth}\t{seed_bound}\t{}\t{}\t{compile_ns}\t{write_ns}\t{verify_ns}\t{}",
            frozen.storage().payload_bytes,
            std::fs::metadata(audit_path).unwrap().len(),
            frozen_path
                .map(|path| std::fs::metadata(path).unwrap().len())
                .unwrap_or(0)
        );
        return;
    }

    if mode == "layered-build-only" {
        let start = Instant::now();
        let compiled = compile_layered_hierarchy(depth, seed_bound).unwrap();
        let compile_ns = start.elapsed().as_nanos();
        let states = compiled.metrics().states;
        let classes = compiled.class_outputs().len();
        let compiled_bytes = compiled.storage().quotient_bytes;
        let state_counts = hierarchy_state_counts(depth, seed_bound);
        let frozen = compiled.into_frozen(&state_counts, &[0]).unwrap();
        let total_ns = start.elapsed().as_nanos();
        println!(
            "layered-only\t{depth}\t{seed_bound}\t{states}\t{classes}\t{compiled_bytes}\t{}\t{compile_ns}\t{total_ns}",
            frozen.storage().payload_bytes
        );
        black_box(frozen);
        return;
    }

    let build_start = Instant::now();
    let machine = build_machine(depth, seed_bound);
    let raw_build_ns = build_start.elapsed().as_nanos();
    if mode == "raw-build-only" {
        black_box(machine.presentation.state_count());
        return;
    }
    let compile_start = Instant::now();
    let compiled = compile_observational_with_policy(
        &machine.presentation,
        CertificatePolicy::SplitTranscript,
    )
    .unwrap();
    let quotient_build_ns = compile_start.elapsed().as_nanos();
    if mode == "generic-build-only" {
        println!(
            "generic-only\t{depth}\t{seed_bound}\t{}\t{}\t{raw_build_ns}\t{quotient_build_ns}\t{}\t{}",
            machine.presentation.state_count(),
            compiled.class_outputs().len(),
            compiled.storage().quotient_bytes,
            compiled.storage().certificate_bytes
        );
        black_box(compiled);
        return;
    }
    let layered_compile_start = Instant::now();
    let layered = compile_layered_hierarchy(depth, seed_bound).unwrap();
    let layered_compile_ns = layered_compile_start.elapsed().as_nanos();
    assert_eq!(compiled.class_ranges(), layered.class_ranges());
    let queries = words(depth);

    for (start, &seed) in machine.profiles[0].iter().take(64).enumerate() {
        for contexts in &queries {
            let mut profile = seed;
            let mut state = start as u32;
            let mut class = compiled.state_classes()[start];
            let mut layered_class = layered.state_classes()[start];
            for (level, &context) in contexts.iter().enumerate() {
                profile = hierarchy_step(profile, context as usize);
                let generator = 3 * level as u32 + u32::from(context);
                state = machine.presentation.transition(generator, state).unwrap();
                class = compiled.transition(generator, class).unwrap();
                layered_class = layered.transition(generator, layered_class).unwrap();
            }
            assert_eq!(
                profile.0[3],
                machine.presentation.observations()[state as usize]
            );
            assert_eq!(profile.0[3], compiled.class_outputs()[class as usize]);
            assert_eq!(
                profile.0[3],
                layered.class_outputs()[layered_class as usize]
            );
        }
    }

    let direct_start = Instant::now();
    let mut direct_checksum = 0_u64;
    for _ in 0..direct_repetitions {
        for &seed in &machine.profiles[0] {
            for contexts in &queries {
                let mut profile = seed;
                for &context in contexts.iter() {
                    profile = hierarchy_step(profile, context as usize);
                }
                direct_checksum = mix(direct_checksum, black_box(profile.0[3]));
            }
        }
    }
    let direct_ns = direct_start.elapsed().as_nanos();

    let random_query_count = machine.profiles[0]
        .len()
        .saturating_mul(queries.len())
        .min(1_000_000);
    let mut random = 0x9e37_79b9_7f4a_7c15_u64;
    let random_queries = (0..random_query_count)
        .map(|_| {
            let start = next_random(&mut random) % machine.profiles[0].len() as u64;
            let word = next_random(&mut random) % queries.len() as u64;
            (start as u32, word as u32)
        })
        .collect::<Vec<_>>();
    let (
        (raw_ns, raw_checksum),
        (quotient_ns, quotient_checksum),
        (random_raw_ns, random_raw_checksum),
        (random_quotient_ns, random_quotient_checksum),
    ) = if quotient_first {
        let quotient = time_quotient(&machine, &compiled, &queries, cached_repetitions);
        let random_quotient =
            time_random_quotient(&compiled, &queries, &random_queries, cached_repetitions);
        let raw = time_raw(&machine, &queries, cached_repetitions);
        let random_raw = time_random_raw(&machine, &queries, &random_queries, cached_repetitions);
        (raw, quotient, random_raw, random_quotient)
    } else {
        let raw = time_raw(&machine, &queries, cached_repetitions);
        let random_raw = time_random_raw(&machine, &queries, &random_queries, cached_repetitions);
        let quotient = time_quotient(&machine, &compiled, &queries, cached_repetitions);
        let random_quotient =
            time_random_quotient(&compiled, &queries, &random_queries, cached_repetitions);
        (raw, quotient, random_raw, random_quotient)
    };

    let direct_queries = direct_repetitions * machine.profiles[0].len() * queries.len();
    let cached_queries = cached_repetitions * machine.profiles[0].len() * queries.len();
    assert_eq!(raw_checksum, quotient_checksum);
    assert_eq!(random_raw_checksum, random_quotient_checksum);
    let random_cached_queries = cached_repetitions * random_queries.len();
    let raw_transition_count = machine.profiles[..depth]
        .iter()
        .map(|states| states.len() * 3)
        .sum::<usize>();
    let raw_payload_bytes =
        std::mem::size_of::<u32>() * (machine.presentation.state_count() + raw_transition_count);
    let compiled_storage = compiled.storage();
    println!(
        "hierarchy\t{depth}\t{seed_bound}\t{:?}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}",
        machine.profiles.iter().map(Vec::len).collect::<Vec<_>>(),
        machine.presentation.state_count(),
        compiled.class_outputs().len(),
        raw_payload_bytes,
        compiled_storage.quotient_bytes,
        compiled_storage.certificate_bytes,
        raw_build_ns,
        quotient_build_ns,
        if direct_queries == 0 {
            0
        } else {
            direct_ns / direct_queries as u128
        },
        raw_ns / cached_queries as u128,
        quotient_ns / cached_queries as u128,
        random_raw_ns / random_cached_queries as u128,
        random_quotient_ns / random_cached_queries as u128,
        direct_checksum,
        raw_checksum,
        quotient_checksum,
        quotient_first,
        cached_queries,
        raw_ns,
        quotient_ns,
        random_cached_queries,
        random_raw_ns,
        random_quotient_ns,
        layered_compile_ns,
        layered.storage().quotient_bytes
    );
}
