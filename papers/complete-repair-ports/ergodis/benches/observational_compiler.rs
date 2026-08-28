use criterion::{criterion_group, criterion_main, BenchmarkId, Criterion, Throughput};
use ergodis::observational::{
    compile_observational, compile_observational_with_policy, CertificatePolicy,
    FinitePresentation, GeneratorSpec,
};
use std::hint::black_box;

fn separated_presentation(states: u32) -> FinitePresentation {
    FinitePresentation::new([states], (0..states).collect::<Vec<_>>(), []).unwrap()
}

fn chain_presentation(states: u32) -> FinitePresentation {
    let mut observations = vec![0; states as usize];
    observations[states as usize - 1] = 1;
    let transitions = (0..states)
        .map(|state| (state + 1).min(states - 1))
        .collect::<Vec<_>>()
        .into_boxed_slice();
    FinitePresentation::new(
        [states],
        observations,
        [GeneratorSpec {
            source_sort: 0,
            target_sort: 0,
            transitions,
        }],
    )
    .unwrap()
}

fn benchmark_observational_compiler(c: &mut Criterion) {
    let mut separated = c.benchmark_group("observational_separated");
    for states in [1_024_u32, 4_096, 16_384] {
        let presentation = separated_presentation(states);
        separated.throughput(Throughput::Elements(u64::from(states)));
        separated.bench_with_input(
            BenchmarkId::new("quotient_only", states),
            &presentation,
            |b, presentation| {
                b.iter(|| {
                    black_box(
                        compile_observational_with_policy(
                            black_box(presentation),
                            CertificatePolicy::QuotientOnly,
                        )
                        .unwrap(),
                    )
                });
            },
        );
        separated.bench_with_input(
            BenchmarkId::new("split_transcript", states),
            &presentation,
            |b, presentation| {
                b.iter(|| {
                    black_box(
                        compile_observational_with_policy(
                            black_box(presentation),
                            CertificatePolicy::SplitTranscript,
                        )
                        .unwrap(),
                    )
                });
            },
        );
    }
    for states in [64_u32, 128, 256] {
        let presentation = separated_presentation(states);
        separated.throughput(Throughput::Elements(u64::from(states)));
        separated.bench_with_input(
            BenchmarkId::new("exhaustive_pair_audit", states),
            &presentation,
            |b, presentation| {
                b.iter(|| black_box(compile_observational(black_box(presentation)).unwrap()));
            },
        );
    }
    separated.finish();

    let mut chain = c.benchmark_group("observational_long_chain");
    for states in [64_u32, 128, 256] {
        let presentation = chain_presentation(states);
        chain.throughput(Throughput::Elements(u64::from(states)));
        chain.bench_with_input(
            BenchmarkId::new("quotient_only", states),
            &presentation,
            |b, presentation| {
                b.iter(|| {
                    black_box(
                        compile_observational_with_policy(
                            black_box(presentation),
                            CertificatePolicy::QuotientOnly,
                        )
                        .unwrap(),
                    )
                });
            },
        );
        chain.bench_with_input(
            BenchmarkId::new("split_transcript", states),
            &presentation,
            |b, presentation| {
                b.iter(|| {
                    black_box(
                        compile_observational_with_policy(
                            black_box(presentation),
                            CertificatePolicy::SplitTranscript,
                        )
                        .unwrap(),
                    )
                });
            },
        );
    }
    chain.finish();
}

criterion_group!(benches, benchmark_observational_compiler);
criterion_main!(benches);
