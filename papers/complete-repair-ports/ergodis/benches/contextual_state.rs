use criterion::{criterion_group, criterion_main, Criterion};
use ergodis::{
    certify_rank_one_transfer_by_generators, confinement_by_generators,
    confinement_by_generators_field, ContextStrategy, CostTable, FiniteField, Gf4, Matrix, Prime,
    RankBoundedContextCache, RankOneProbeCache,
};
use std::hint::black_box;

fn chain_basis<F: FiniteField>(dimension: usize) -> Matrix {
    let blocks = dimension + 1;
    let mut data = vec![0u8; dimension * blocks];
    for row in 0..dimension {
        data[row * blocks + row] = 1;
        data[row * blocks + row + 1] = 1;
    }
    Matrix::new_field::<F>(dimension, blocks, data).unwrap()
}

fn scalar_table<F: FiniteField>(zero_cost: u32) -> CostTable {
    CostTable::from_entries_field::<F>(
        1,
        1,
        (0..F::ORDER).map(|value| {
            (
                Matrix::new_field::<F>(1, 1, vec![value]).unwrap(),
                if value == 0 { zero_cost } else { 1 },
            )
        }),
    )
    .unwrap()
}

fn binary_rank_table(rank: usize) -> CostTable {
    CostTable::from_entries::<2>(
        1,
        rank,
        (0usize..(1usize << rank)).map(|bits| {
            let data = (0..rank)
                .map(|shift| ((bits >> shift) & 1) as u8)
                .collect::<Vec<_>>();
            let cost = data.iter().filter(|&&entry| entry != 0).count() as u32;
            (Matrix::new::<2>(1, rank, data).unwrap(), cost)
        }),
    )
    .unwrap()
}

fn benchmark_contextual_state(c: &mut Criterion) {
    let binary_basis = chain_basis::<Prime<2>>(8);
    let inner = scalar_table::<Prime<2>>(0);
    let target = scalar_table::<Prime<2>>(1);
    let exact_work =
        confinement_by_generators::<2>(&binary_basis, 9, &inner, &target, 0, 3).unwrap();
    let certificate_work =
        certify_rank_one_transfer_by_generators::<2>(&binary_basis, 9, &inner, &target, 0, 3, 0)
            .unwrap();
    eprintln!(
        "CONTEXT_WORK radius exact_candidates={} certificate_candidates={} certificate_lookups={}",
        exact_work.transitions,
        certificate_work.candidates_examined,
        certificate_work.local_lookups
    );
    let mut bounded = c.benchmark_group("rank_one_radius_decision");
    bounded.bench_function("A_exact_then_compare", |b| {
        b.iter(|| {
            let answer = confinement_by_generators::<2>(
                black_box(&binary_basis),
                9,
                black_box(&inner),
                black_box(&target),
                0,
                3,
            )
            .unwrap();
            black_box(0 < answer.cost)
        })
    });
    bounded.bench_function("B_radius_certificate", |b| {
        b.iter(|| {
            black_box(
                certify_rank_one_transfer_by_generators::<2>(
                    black_box(&binary_basis),
                    9,
                    black_box(&inner),
                    black_box(&target),
                    0,
                    3,
                    0,
                )
                .unwrap()
                .transfers_completely,
            )
        })
    });
    bounded.finish();

    let all_rank_basis = chain_basis::<Prime<2>>(3);
    let rank_tables = (1..=4).map(binary_rank_table).collect::<Vec<_>>();
    let all_rank_candidates = rank_tables
        .iter()
        .map(|table| {
            confinement_by_generators::<2>(&all_rank_basis, 4, table, table, 0, 2)
                .unwrap()
                .transitions
        })
        .sum::<u64>();
    let all_rank_certificate = certify_rank_one_transfer_by_generators::<2>(
        &all_rank_basis,
        4,
        &rank_tables[0],
        &rank_tables[0],
        0,
        2,
        0,
    )
    .unwrap();
    eprintln!(
        "CONTEXT_WORK all_rank exact_candidates={} certificate_candidates={} certificate_lookups={}",
        all_rank_candidates,
        all_rank_certificate.candidates_examined,
        all_rank_certificate.local_lookups
    );
    let mut all_rank = c.benchmark_group("complete_transfer_all_ranks");
    all_rank.bench_function("A_compute_each_rank", |b| {
        b.iter(|| {
            let mut total = 0u32;
            for table in &rank_tables {
                total += confinement_by_generators::<2>(
                    black_box(&all_rank_basis),
                    4,
                    black_box(table),
                    black_box(table),
                    0,
                    2,
                )
                .unwrap()
                .cost;
            }
            black_box(total)
        })
    });
    all_rank.bench_function("B_rank_one_certificate", |b| {
        b.iter(|| {
            black_box(
                certify_rank_one_transfer_by_generators::<2>(
                    black_box(&all_rank_basis),
                    4,
                    black_box(&rank_tables[0]),
                    black_box(&rank_tables[0]),
                    0,
                    2,
                    0,
                )
                .unwrap()
                .transfers_completely,
            )
        })
    });
    all_rank.finish();

    let gf4_basis = chain_basis::<Gf4>(4);
    let gf4_inner = scalar_table::<Gf4>(0);
    let gf4_target = scalar_table::<Gf4>(1);
    let mut projective_cache =
        RankOneProbeCache::<Gf4>::new(&gf4_inner, &gf4_target, 5, 0, 3).unwrap();
    let projective_direct =
        confinement_by_generators_field::<Gf4>(&gf4_basis, 5, &gf4_inner, &gf4_target, 0, 3)
            .unwrap();
    let projective_cold = projective_cache.context_cost_cached(&gf4_basis).unwrap();
    let projective_warm = projective_cache.context_cost_cached(&gf4_basis).unwrap();
    eprintln!(
        "CONTEXT_WORK projective direct_vectors={} lines={} cold_scalar_probes={} warm_hits={} cache_entries={}",
        projective_direct.transitions,
        projective_cold.work.distinct_subspaces,
        projective_cold.work.scalar_probes,
        projective_warm.work.cache_hits,
        projective_cache.cached_probe_count()
    );
    let mut projective = c.benchmark_group("projective_line_cache_warm");
    projective.bench_function("A_direct_vectors", |b| {
        b.iter(|| {
            black_box(
                confinement_by_generators_field::<Gf4>(
                    black_box(&gf4_basis),
                    5,
                    black_box(&gf4_inner),
                    black_box(&gf4_target),
                    0,
                    3,
                )
                .unwrap()
                .cost,
            )
        })
    });
    projective.bench_function("B_cached_lines", |b| {
        b.iter(|| {
            black_box(
                projective_cache
                    .context_cost_cached(black_box(&gf4_basis))
                    .unwrap()
                    .cost,
            )
        })
    });
    projective.finish();
    let mut projective_cold = c.benchmark_group("projective_line_cache_cold");
    projective_cold.bench_function("A_direct_vectors", |b| {
        b.iter(|| {
            black_box(
                confinement_by_generators_field::<Gf4>(
                    black_box(&gf4_basis),
                    5,
                    black_box(&gf4_inner),
                    black_box(&gf4_target),
                    0,
                    3,
                )
                .unwrap()
                .cost,
            )
        })
    });
    projective_cold.bench_function("B_build_and_query", |b| {
        b.iter(|| {
            let mut cache =
                RankOneProbeCache::<Gf4>::new(&gf4_inner, &gf4_target, 5, 0, 3).unwrap();
            black_box(
                cache
                    .context_cost_cached(black_box(&gf4_basis))
                    .unwrap()
                    .cost,
            )
        })
    });
    projective_cold.finish();
    let mut projective_auto = c.benchmark_group("projective_auto_one_shot");
    projective_auto.bench_function("A_direct_vectors", |b| {
        b.iter(|| {
            black_box(
                confinement_by_generators_field::<Gf4>(
                    black_box(&gf4_basis),
                    5,
                    black_box(&gf4_inner),
                    black_box(&gf4_target),
                    0,
                    3,
                )
                .unwrap()
                .cost,
            )
        })
    });
    projective_auto.bench_function("B_auto_cached", |b| {
        b.iter(|| {
            let mut cache =
                RankOneProbeCache::<Gf4>::new(&gf4_inner, &gf4_target, 5, 0, 3).unwrap();
            black_box(
                cache
                    .context_cost_planned(
                        black_box(&gf4_basis),
                        ContextStrategy::Auto {
                            expected_queries: 1,
                            memory_budget_bytes: usize::MAX,
                        },
                    )
                    .unwrap()
                    .result
                    .cost,
            )
        })
    });
    projective_auto.finish();

    let rank_two_basis = chain_basis::<Prime<2>>(4);
    let rank_two_table = binary_rank_table(2);
    let mut rank_cache =
        RankBoundedContextCache::<Prime<2>>::new(&rank_two_table, &rank_two_table, 5, 0, 2)
            .unwrap();
    let rank_direct =
        confinement_by_generators::<2>(&rank_two_basis, 5, &rank_two_table, &rank_two_table, 0, 2)
            .unwrap();
    let rank_cold = rank_cache.context_cost_cached(&rank_two_basis).unwrap();
    let rank_warm = rank_cache.context_cost_cached(&rank_two_basis).unwrap();
    eprintln!(
        "CONTEXT_WORK rank_bounded direct_maps={} subspaces={} cold_candidates={} warm_hits={} cache_entries={}",
        rank_direct.transitions,
        rank_cold.work.distinct_subspaces,
        rank_cold.work.generator_candidates,
        rank_warm.work.cache_hits,
        rank_cache.cached_context_count()
    );
    let mut rank_bounded = c.benchmark_group("rank_bounded_context_cache_warm");
    rank_bounded.bench_function("A_direct_maps", |b| {
        b.iter(|| {
            black_box(
                confinement_by_generators::<2>(
                    black_box(&rank_two_basis),
                    5,
                    black_box(&rank_two_table),
                    black_box(&rank_two_table),
                    0,
                    2,
                )
                .unwrap()
                .cost,
            )
        })
    });
    rank_bounded.bench_function("B_cached_subspaces", |b| {
        b.iter(|| {
            black_box(
                rank_cache
                    .context_cost_cached(black_box(&rank_two_basis))
                    .unwrap()
                    .cost,
            )
        })
    });
    rank_bounded.finish();
    let mut rank_bounded_cold = c.benchmark_group("rank_bounded_context_cache_cold");
    rank_bounded_cold.bench_function("A_direct_maps", |b| {
        b.iter(|| {
            black_box(
                confinement_by_generators::<2>(
                    black_box(&rank_two_basis),
                    5,
                    black_box(&rank_two_table),
                    black_box(&rank_two_table),
                    0,
                    2,
                )
                .unwrap()
                .cost,
            )
        })
    });
    rank_bounded_cold.bench_function("B_build_and_query", |b| {
        b.iter(|| {
            let mut cache =
                RankBoundedContextCache::<Prime<2>>::new(&rank_two_table, &rank_two_table, 5, 0, 2)
                    .unwrap();
            black_box(
                cache
                    .context_cost_cached(black_box(&rank_two_basis))
                    .unwrap()
                    .cost,
            )
        })
    });
    rank_bounded_cold.finish();
    let mut rank_auto = c.benchmark_group("rank_bounded_auto_one_shot");
    rank_auto.bench_function("A_direct_maps", |b| {
        b.iter(|| {
            black_box(
                confinement_by_generators::<2>(
                    black_box(&rank_two_basis),
                    5,
                    black_box(&rank_two_table),
                    black_box(&rank_two_table),
                    0,
                    2,
                )
                .unwrap()
                .cost,
            )
        })
    });
    rank_auto.bench_function("B_auto_direct", |b| {
        b.iter(|| {
            let mut cache =
                RankBoundedContextCache::<Prime<2>>::new(&rank_two_table, &rank_two_table, 5, 0, 2)
                    .unwrap();
            black_box(
                cache
                    .context_cost_planned(
                        black_box(&rank_two_basis),
                        ContextStrategy::Auto {
                            expected_queries: 1,
                            memory_budget_bytes: usize::MAX,
                        },
                    )
                    .unwrap()
                    .result
                    .cost,
            )
        })
    });
    rank_auto.finish();
}

criterion_group!(benches, benchmark_contextual_state);
criterion_main!(benches);
