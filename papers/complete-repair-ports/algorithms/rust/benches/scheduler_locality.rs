use std::hint::black_box;
use std::time::Duration;

use criterion::{criterion_group, criterion_main, BenchmarkId, Criterion, Throughput};
use ergo_comp::{WeightedRepairProblem, WeightedRepairWorkspace};

fn next_u32(state: &mut u64) -> u32 {
    *state = state
        .wrapping_mul(6_364_136_223_846_793_005)
        .wrapping_add(1);
    (*state >> 32) as u32
}

fn graded_problem(
    resource_count: usize,
    capacity: u32,
    demand_count: usize,
    option_count: usize,
    seed: u64,
) -> WeightedRepairProblem {
    let capacities = vec![capacity; resource_count];
    let weights = (0..resource_count)
        .map(|resource| if resource % 2 == 0 { 1 } else { 2 })
        .collect::<Vec<_>>();
    let even = (0..resource_count).step_by(2).collect::<Vec<_>>();
    let odd = (1..resource_count).step_by(2).collect::<Vec<_>>();
    let mut state = seed;
    let families = (0..demand_count)
        .map(|_| {
            (0..option_count)
                .map(|option| {
                    let mut loads = vec![0u32; resource_count];
                    match option % 4 {
                        0 => loads[even[next_u32(&mut state) as usize % even.len()]] = 4,
                        1 => loads[odd[next_u32(&mut state) as usize % odd.len()]] = 2,
                        2 => {
                            let first = next_u32(&mut state) as usize % even.len();
                            let mut second = next_u32(&mut state) as usize % even.len();
                            if second == first {
                                second = (second + 1) % even.len();
                            }
                            loads[even[first]] = 2;
                            loads[even[second]] = 2;
                        }
                        _ => {
                            loads[even[next_u32(&mut state) as usize % even.len()]] = 2;
                            loads[odd[next_u32(&mut state) as usize % odd.len()]] = 1;
                        }
                    }
                    loads
                })
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();
    WeightedRepairProblem::from_families_with_positive_grading(&capacities, &families, &weights)
        .unwrap()
}

fn scheduler_locality(criterion: &mut Criterion) {
    let cases = [
        ("balanced", 6, 3, 11, 4, 0xA17E_5EED),
        ("small-state", 4, 2, 80, 4, 0xA17E_5EED),
        ("large-nonuniform", 8, 4, 8, 4, 1),
    ];
    let mut group = criterion.benchmark_group("graded_scheduler_workspace");
    for (name, resources, capacity, demands, options, seed) in cases {
        let problem = graded_problem(resources, capacity, demands, options, seed);
        let mut workspace = WeightedRepairWorkspace::new();
        let reference = problem
            .solve_adaptive_with_workspace(&mut workspace)
            .unwrap();
        group.throughput(Throughput::Elements(reference.transitions_examined));
        group.bench_with_input(
            BenchmarkId::new("solve", name),
            &problem,
            |bencher, problem| {
                bencher.iter(|| {
                    black_box(
                        problem
                            .solve_adaptive_with_workspace(&mut workspace)
                            .unwrap(),
                    )
                });
            },
        );
    }
    group.finish();

    let shell_problem = graded_problem(4, 4_096, 8, 4, 0xA17E_5EED);
    let mut shell_workspace = WeightedRepairWorkspace::new();
    let shell_reference = shell_problem
        .solve_graded_shell_with_workspace(&mut shell_workspace)
        .unwrap();
    let sparse_reference = shell_problem.solve().unwrap();
    assert_eq!(shell_reference, sparse_reference);
    let mut shell_group = criterion.benchmark_group("graded_scheduler_large_box");
    shell_group.throughput(Throughput::Elements(shell_reference.transitions_examined));
    shell_group.bench_function("shell_ranked", |bencher| {
        bencher.iter(|| {
            black_box(
                shell_problem
                    .solve_graded_shell_with_workspace(&mut shell_workspace)
                    .unwrap(),
            )
        });
    });
    shell_group.bench_function("sparse_pareto", |bencher| {
        bencher.iter(|| black_box(shell_problem.solve().unwrap()));
    });
    shell_group.finish();
}

criterion_group! {
    name = benches;
    config = Criterion::default()
        .sample_size(60)
        .warm_up_time(Duration::from_secs(2))
        .measurement_time(Duration::from_secs(4));
    targets = scheduler_locality
}
criterion_main!(benches);
