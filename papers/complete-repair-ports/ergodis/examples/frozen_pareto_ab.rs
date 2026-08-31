use std::hint::black_box;
use std::time::Instant;

use ergodis::observational::{compile_layered_frozen_dag_audited, LayeredGeneratorSpec};
use ergodis::{
    CappedAdditiveMonoid, FrozenParetoPlan, ParetoWitness, WitnessedParetoFront,
    WitnessedParetoWorkspace,
};

fn main() {
    let repetitions = std::env::args()
        .nth(1)
        .map(|value| value.parse::<usize>().expect("invalid repetition count"))
        .unwrap_or(3);
    let states = std::env::args()
        .nth(2)
        .map(|value| value.parse::<u32>().expect("invalid state count"))
        .unwrap_or(2_048);
    let sorts = std::env::args()
        .nth(3)
        .map(|value| value.parse::<u32>().expect("invalid sort count"))
        .unwrap_or(8);
    assert!(sorts >= 2);
    let state_counts = vec![states; sorts as usize];
    let generators = (0..sorts - 1)
        .flat_map(|sort| {
            [
                LayeredGeneratorSpec {
                    source_sort: sort,
                    target_sort: sort + 1,
                },
                LayeredGeneratorSpec {
                    source_sort: sort,
                    target_sort: sort + 1,
                },
            ]
        })
        .collect::<Vec<_>>();
    let mut audit = Vec::new();
    let (frozen, _) = compile_layered_frozen_dag_audited(
        &state_counts,
        &generators,
        &[0],
        |_, state| state,
        |generator, state| {
            if generator & 1 == 0 {
                state
            } else {
                (state * 5 + 1) % states
            }
        },
        &mut audit,
    )
    .unwrap();
    let plan = FrozenParetoPlan::new(&frozen).unwrap();
    let entries = (0..states)
        .map(|state| frozen.entry_class(0, state).unwrap())
        .collect::<Vec<_>>();
    let query = plan.query(&entries).unwrap();
    let monoid = CappedAdditiveMonoid::new([1; 8]).unwrap();
    let outputs = (0..states)
        .map(|state| {
            WitnessedParetoFront::new(
                &monoid,
                [
                    ParetoWitness {
                        resource: 1 << (state % 8),
                        witness: state,
                    },
                    ParetoWitness {
                        resource: 1 << ((state + 3) % 8),
                        witness: state ^ 0x8000_0000,
                    },
                ],
            )
            .unwrap()
        })
        .collect::<Vec<_>>();
    let edges = generators
        .iter()
        .enumerate()
        .map(|(generator, _)| {
            WitnessedParetoFront::new(
                &monoid,
                [ParetoWitness {
                    resource: 1 << (generator % 8),
                    witness: generator as u32,
                }],
            )
            .unwrap()
        })
        .collect::<Vec<_>>();
    let mut workspace = WitnessedParetoWorkspace::with_capacity(256);
    let warm = query
        .evaluate(
            &monoid,
            &outputs,
            &edges,
            &mut workspace,
            |generator, edge, child| child.rotate_left(5) ^ edge ^ generator,
        )
        .unwrap();
    let expected_checksum = checksum(&warm.0);
    black_box(warm);

    let started = Instant::now();
    let mut result_checksum = 0_u64;
    let mut peak_live_entries = 0_usize;
    for _ in 0..repetitions {
        let result = query
            .evaluate(
                &monoid,
                &outputs,
                &edges,
                &mut workspace,
                |generator, edge, child| child.rotate_left(5) ^ edge ^ generator,
            )
            .unwrap();
        result_checksum = result_checksum.wrapping_add(checksum(&result.0));
        peak_live_entries = peak_live_entries.max(result.1.peak_live_entries);
        black_box(result);
    }
    let elapsed_ns = started.elapsed().as_nanos();
    assert_eq!(
        result_checksum,
        expected_checksum.wrapping_mul(repetitions as u64)
    );
    println!(
        "{{\"repetitions\":{repetitions},\"classes\":{},\"entries\":{},\"elapsed_ns\":{elapsed_ns},\"peak_live_entries\":{peak_live_entries},\"checksum\":{result_checksum}}}",
        frozen.storage().classes,
        entries.len(),
    );
}

fn checksum(fronts: &[WitnessedParetoFront]) -> u64 {
    fronts.iter().fold(0_u64, |checksum, front| {
        front.entries().iter().fold(checksum, |checksum, entry| {
            checksum
                .wrapping_mul(0x9e37_79b9)
                .wrapping_add(u64::from(entry.resource))
                .wrapping_add(u64::from(entry.witness).rotate_left(17))
        })
    })
}
