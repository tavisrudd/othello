use criterion::{criterion_group, criterion_main, Criterion};
use ergodis::{
    compile_binary_gl_rref, compile_permutation_orbits,
    compile_permutation_orbits_with_deferred_verification, BinaryGlProbeAction,
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
}

criterion_group!(benches, benchmark_gl_probe);
criterion_main!(benches);
