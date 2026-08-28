use criterion::{criterion_group, criterion_main, Criterion, Throughput};
use ergodis::{
    CappedAdditiveMonoid, FiniteOrderedMonoid, ParetoWitness, WitnessedParetoFront,
    WitnessedParetoWorkspace,
};
use std::hint::black_box;

fn benchmark_ordered_resources(c: &mut Criterion) {
    let boolean = CappedAdditiveMonoid::new([1; 16]).unwrap();
    let mixed = CappedAdditiveMonoid::new([3; 8]).unwrap();
    let mut primitives = c.benchmark_group("ordered_resource_primitives");
    primitives.throughput(Throughput::Elements(1));
    primitives.bench_function("boolean_combine_16", |b| {
        b.iter(|| {
            black_box(boolean.combine(black_box(0x5555), black_box(0x3333)));
        })
    });
    primitives.bench_function("mixed_radix_combine_8", |b| {
        b.iter(|| {
            black_box(mixed.combine(black_box(0x5555), black_box(0x3333)));
        })
    });
    primitives.finish();

    let front = WitnessedParetoFront::new(
        &boolean,
        (0..8).map(|bit| ParetoWitness {
            resource: 1 << bit,
            witness: bit,
        }),
    )
    .unwrap();
    let mut workspace = WitnessedParetoWorkspace::with_capacity(64);
    let mut pareto = c.benchmark_group("ordered_resource_pareto");
    pareto.throughput(Throughput::Elements(64));
    pareto.bench_function("witnessed_compose_8x8", |b| {
        b.iter(|| {
            let result = workspace
                .compose(
                    &boolean,
                    black_box(&front),
                    black_box(&front),
                    |left, right| Ok::<_, ()>(left * 8 + right),
                )
                .unwrap();
            black_box(result.len());
        })
    });
    pareto.finish();
}

criterion_group!(benches, benchmark_ordered_resources);
criterion_main!(benches);
