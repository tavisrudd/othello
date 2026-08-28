use criterion::{criterion_group, criterion_main, Criterion};
use ergodis::observational::{FinitePresentation, GeneratorSpec};
use ergodis::{
    compile_binary_gl_rref, compile_permutation_orbits,
    compile_permutation_orbits_with_deferred_verification, quotient_presentation_by_binary_gl_rref,
    quotient_presentation_by_orbits, BinaryGlProbeAction, BinaryRightLinearMap,
    FinitePermutationAction,
};
use std::hint::black_box;

fn benchmark_gl_probe(c: &mut Criterion) {
    for (name, rows, columns) in [("rank2_width8", 2, 8), ("rank3_width6", 3, 6)] {
        let action = BinaryGlProbeAction::new(rows, columns).unwrap();
        let partition = compile_permutation_orbits(&action).unwrap();
        let expected = action.expected_orbit_count().unwrap();
        assert_eq!(partition.representatives().len() as u64, expected);
        let storage = partition.storage();
        let rref = compile_binary_gl_rref(action);
        assert_eq!(u64::from(rref.orbit_count()), expected);
        eprintln!(
            "GL_PROBE name={name} points={} generators={} orbits={} compression={:.3} quotient_bytes={} certificate_bytes={} rref_bytes={}",
            action.point_count(),
            action.generator_count(),
            expected,
            action.point_count() as f64 / expected as f64,
            storage.quotient_bytes,
            storage.certificate_bytes,
            rref.storage_bytes(),
        );
        let mut group = c.benchmark_group(format!("binary_gl_probe/{name}"));
        group.bench_function("compile_and_verify", |b| {
            b.iter(|| black_box(compile_permutation_orbits(black_box(&action)).unwrap()))
        });
        group.bench_function("compile_deferred_verification", |b| {
            b.iter(|| {
                black_box(
                    compile_permutation_orbits_with_deferred_verification(black_box(&action))
                        .unwrap(),
                )
            })
        });
        group.bench_function("compile_rref", |b| {
            b.iter(|| black_box(compile_binary_gl_rref(black_box(action))))
        });
        group.finish();
    }

    let action = BinaryGlProbeAction::new(3, 6).unwrap();
    let canonical = compile_binary_gl_rref(action);
    let observations = (0..action.point_count())
        .map(|point| canonical.representative(point).unwrap())
        .collect::<Vec<_>>();
    let column_maps = [
        [2, 4, 8, 16, 32, 1],
        [3, 2, 4, 8, 16, 32],
        [1, 2, 4, 8, 16, 0],
    ];
    let generators = column_maps.map(|map| GeneratorSpec {
        source_sort: 0,
        target_sort: 0,
        transitions: (0..action.point_count())
            .map(|point| apply_binary_column_map(point, 3, 6, map))
            .collect(),
    });
    let presentation =
        FinitePresentation::new([action.point_count()], observations, generators).unwrap();
    let generic = compile_permutation_orbits_with_deferred_verification(&action).unwrap();
    let generic_quotient = quotient_presentation_by_orbits(&presentation, &generic).unwrap();
    let direct_quotient =
        quotient_presentation_by_binary_gl_rref(&presentation, &canonical).unwrap();
    let right_contexts = column_maps.map(|map| BinaryRightLinearMap::new(6, map).unwrap());
    let theorem_quotient = canonical
        .compile_right_linear_presentation(&right_contexts, |representative| representative)
        .unwrap();
    assert_eq!(
        generic_quotient.observations().len(),
        direct_quotient.observations().len()
    );
    assert_eq!(
        direct_quotient.observations(),
        theorem_quotient.observations()
    );
    for context in 0..right_contexts.len() as u32 {
        for state in 0..canonical.orbit_count() {
            assert_eq!(
                direct_quotient.transition(context, state),
                theorem_quotient.transition(context, state)
            );
        }
    }

    let mut consuming = c.benchmark_group("binary_gl_probe/rank3_width6_consuming_quotient");
    consuming.bench_function("generic_bfs_then_checked_quotient", |b| {
        b.iter(|| {
            let partition =
                compile_permutation_orbits_with_deferred_verification(black_box(&action)).unwrap();
            black_box(
                quotient_presentation_by_orbits(black_box(&presentation), &partition).unwrap(),
            )
        })
    });
    consuming.bench_function("direct_rref_then_checked_quotient", |b| {
        b.iter(|| {
            let partition = compile_binary_gl_rref(black_box(action));
            black_box(
                quotient_presentation_by_binary_gl_rref(black_box(&presentation), &partition)
                    .unwrap(),
            )
        })
    });
    consuming.bench_function("theorem_compiled_right_linear_quotient", |b| {
        b.iter(|| {
            let partition = compile_binary_gl_rref(black_box(action));
            black_box(
                partition
                    .compile_right_linear_presentation(
                        black_box(&right_contexts),
                        |representative| representative,
                    )
                    .unwrap(),
            )
        })
    });
    consuming.finish();
}

fn apply_binary_column_map(point: u32, rows: usize, columns: usize, map: [u32; 6]) -> u32 {
    let row_mask = (1_u32 << columns) - 1;
    let mut result = 0_u32;
    for row in 0..rows {
        let source = point >> (row * columns) & row_mask;
        let mut target = 0_u32;
        for (column, &linear_form) in map.iter().enumerate().take(columns) {
            target |= ((source & linear_form).count_ones() & 1) << column;
        }
        result |= target << (row * columns);
    }
    result
}

criterion_group!(benches, benchmark_gl_probe);
criterion_main!(benches);
