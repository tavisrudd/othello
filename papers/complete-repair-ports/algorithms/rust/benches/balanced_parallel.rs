use criterion::{criterion_group, criterion_main, BenchmarkId, Criterion};
use ergo_comp::balanced::{BalancedDfsLimits, BalancedQueueLimits, BalancedTransversalCatalog};
use rayon::{ThreadPool, ThreadPoolBuilder};
use std::hint::black_box;
use std::time::Duration;

fn thread_pool(threads: usize) -> ThreadPool {
    ThreadPoolBuilder::new()
        .num_threads(threads)
        .thread_name(move |index| format!("balanced-bench-{threads}-{index}"))
        .build()
        .expect("benchmark thread-pool construction must succeed")
}

fn balanced_parallel(c: &mut Criterion) {
    let catalog = BalancedTransversalCatalog::q27();
    let limits = BalancedQueueLimits {
        max_tasks: 24,
        max_high_sets_per_task: 1,
        per_high_set: BalancedDfsLimits {
            max_nodes: 500,
            max_terminal_carriers: 500,
        },
    };
    let expected = catalog.search_balanced_work_batch(limits).unwrap();
    let pools = [1, 2, 4, 8, 12, 24].map(|threads| (threads, thread_pool(threads)));
    for (_, pool) in &pools {
        assert_eq!(
            pool.install(|| catalog.search_balanced_work_batch_parallel(limits))
                .unwrap(),
            expected
        );
    }

    let mut group = c.benchmark_group("gf27_balanced_24_task_batch");
    group.sample_size(10);
    group.warm_up_time(Duration::from_secs(1));
    group.measurement_time(Duration::from_secs(3));
    for (threads, pool) in &pools {
        group.bench_with_input(BenchmarkId::new("threads", threads), threads, |b, _| {
            b.iter(|| {
                black_box(
                    pool.install(|| catalog.search_balanced_work_batch_parallel(limits))
                        .unwrap(),
                )
            });
        });
    }
    group.finish();
}

criterion_group!(benches, balanced_parallel);
criterion_main!(benches);
