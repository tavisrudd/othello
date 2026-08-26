use std::hint::black_box;
use std::time::Duration;

use criterion::{criterion_group, criterion_main, BenchmarkId, Criterion};
use ergo_comp::{CompositionTable, CostTable, Matrix, WeightedRepairProblem};

fn composition_fixture() -> (Vec<Matrix>, CostTable) {
    const WIDTH: usize = 9;
    let inner = CostTable::from_entries::<2>(
        WIDTH,
        1,
        (0u16..1 << WIDTH).map(|bits| {
            let data = (0..WIDTH)
                .map(|shift| ((bits >> shift) & 1) as u8)
                .collect::<Vec<_>>();
            (Matrix::new::<2>(WIDTH, 1, data).unwrap(), bits.count_ones())
        }),
    )
    .unwrap();
    let identity = Matrix::new::<2>(
        WIDTH,
        WIDTH,
        (0..WIDTH * WIDTH)
            .map(|index| u8::from(index / WIDTH == index % WIDTH))
            .collect::<Vec<_>>(),
    )
    .unwrap();
    (vec![identity.clone(), identity], inner)
}

fn scheduler_fixture() -> WeightedRepairProblem {
    let families = (0..10)
        .map(|demand| {
            (0..8)
                .map(|resource| {
                    let mut loads = vec![0u32; 8];
                    loads[resource] = 1 + u32::from((demand + resource) % 3 == 0);
                    loads
                })
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();
    WeightedRepairProblem::from_families(&[5; 8], &families).unwrap()
}

fn parallel_kernels(criterion: &mut Criterion) {
    const THREAD_COUNTS: [usize; 9] = [1, 2, 4, 6, 8, 12, 16, 20, 24];
    let pools = THREAD_COUNTS.map(|threads| {
        rayon::ThreadPoolBuilder::new()
            .num_threads(threads)
            .build()
            .unwrap()
    });
    let (blocks, inner) = composition_fixture();
    let mut composition = criterion.benchmark_group("composition_threads");
    composition.bench_function(BenchmarkId::new("sequential", 1), |bencher| {
        bencher.iter(|| black_box(CompositionTable::compose::<2>(&blocks, &inner).unwrap()));
    });
    for (threads, pool) in THREAD_COUNTS.into_iter().zip(&pools) {
        composition.bench_function(BenchmarkId::new("parallel", threads), |bencher| {
            bencher.iter(|| {
                black_box(
                    pool.install(|| {
                        CompositionTable::compose_parallel::<2>(&blocks, &inner).unwrap()
                    }),
                )
            });
        });
    }
    composition.finish();

    let problem = scheduler_fixture();
    let mut scheduler = criterion.benchmark_group("adaptive_scheduler_threads");
    scheduler.bench_function(BenchmarkId::new("sequential", 1), |bencher| {
        bencher.iter(|| black_box(problem.solve_adaptive().unwrap()));
    });
    for (threads, pool) in THREAD_COUNTS.into_iter().zip(&pools) {
        scheduler.bench_function(BenchmarkId::new("parallel", threads), |bencher| {
            bencher.iter(|| black_box(pool.install(|| problem.solve_adaptive_parallel().unwrap())));
        });
    }
    scheduler.finish();
}

criterion_group! {
    name = benches;
    config = Criterion::default()
        .sample_size(20)
        .warm_up_time(Duration::from_secs(1))
        .measurement_time(Duration::from_secs(3));
    targets = parallel_kernels
}
criterion_main!(benches);
