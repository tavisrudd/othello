use ergodis::observational::{
    compile_observational_with_policy, CertificatePolicy, CompiledObservation, FinitePresentation,
    GeneratorSpec,
};
use ergodis::{CompositionTable, CostTable, Matrix};
use std::collections::{BTreeMap, BTreeSet};
use std::hint::black_box;
use std::time::Instant;

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct RecoveryProfile([u32; 4]);

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

fn hierarchy_step(profile: RecoveryProfile, context: usize) -> RecoveryProfile {
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

struct HierarchyMachine {
    presentation: FinitePresentation,
    profiles: Vec<Vec<RecoveryProfile>>,
}

fn build_machine(depth: usize, seed_bound: u32) -> HierarchyMachine {
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
    assert!(mode == "full" || mode == "raw-build-only");
    assert!(depth >= 1 && seed_bound >= 1);
    assert!(args.next().is_none());

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
    let queries = words(depth);

    for (start, &seed) in machine.profiles[0].iter().take(64).enumerate() {
        for contexts in &queries {
            let mut profile = seed;
            let mut state = start as u32;
            let mut class = compiled.state_classes()[start];
            for (level, &context) in contexts.iter().enumerate() {
                profile = hierarchy_step(profile, context as usize);
                let generator = 3 * level as u32 + u32::from(context);
                state = machine.presentation.transition(generator, state).unwrap();
                class = compiled.transition(generator, class).unwrap();
            }
            assert_eq!(
                profile.0[3],
                machine.presentation.observations()[state as usize]
            );
            assert_eq!(profile.0[3], compiled.class_outputs()[class as usize]);
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
        "hierarchy\t{depth}\t{seed_bound}\t{:?}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}",
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
        random_quotient_ns
    );
}
