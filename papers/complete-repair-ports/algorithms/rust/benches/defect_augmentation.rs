use std::hint::black_box;
use std::time::Duration;

use criterion::{criterion_group, criterion_main, BenchmarkId, Criterion, Throughput};
use ergo_comp::defect::{
    canonical_maximal_prefix_search, AugmentResult, Gf27DefectCatalog, Gf27TargetFrontier,
    MaximalPointAugmentor, SearchPruning,
};
use ergo_comp::projective::ProjectivePlane;

fn seeded_state(plane: &ProjectivePlane, depth: usize) -> MaximalPointAugmentor {
    let mut state = MaximalPointAugmentor::new(plane);
    let mut candidate = 0;
    while state.summary().selected_count() as usize != depth {
        if state.push(plane, candidate) == AugmentResult::Added {
            candidate += 37;
            candidate %= plane.points().len();
        } else {
            candidate += 1;
            candidate %= plane.points().len();
        }
    }
    state
}

fn seeded_points(plane: &ProjectivePlane, depth: usize) -> Vec<u16> {
    let mut state = MaximalPointAugmentor::new(plane);
    let mut points = Vec::with_capacity(depth);
    let mut candidate = 0;
    while points.len() != depth {
        if state.push(plane, candidate) == AugmentResult::Added {
            points.push(candidate as u16);
            candidate += 37;
            candidate %= plane.points().len();
        } else {
            candidate += 1;
            candidate %= plane.points().len();
        }
    }
    points
}

fn defect_augmentation(criterion: &mut Criterion) {
    let plane = ProjectivePlane::ternary(27).unwrap();
    let catalog = Gf27DefectCatalog::new();

    let mut pencil_group = criterion.benchmark_group("gf27_projective_pencil");
    pencil_group.throughput(Throughput::Elements(28));
    let mut state = seeded_state(&plane, 20);
    let point = (0..plane.points().len())
        .find(|&point| {
            let mut trial = state.clone();
            trial.push(&plane, point) == AugmentResult::Added
        })
        .unwrap();
    pencil_group.bench_function("push_pop", |bencher| {
        bencher.iter(|| {
            assert_eq!(state.push(&plane, point), AugmentResult::Added);
            state.pop(&plane, point);
            black_box(state.summary());
        });
    });
    pencil_group.finish();

    let mut filter_group = criterion.benchmark_group("gf27_degree_catalog");
    filter_group.throughput(Throughput::Elements(catalog.degree_target_count() as u64));
    for depth in [0, 20, 30, 40, 50] {
        let state = seeded_state(&plane, depth);
        filter_group.bench_with_input(
            BenchmarkId::new("compatible", depth),
            state.summary(),
            |bencher, summary| {
                bencher.iter(|| black_box(catalog.compatible_degree_targets(black_box(summary))));
            },
        );
    }
    filter_group.finish();

    let state = seeded_state(&plane, 30);
    let mut frontier = Gf27TargetFrontier::new(&catalog);
    for depth in 0..30 {
        let prefix = seeded_state(&plane, depth);
        frontier.refine(&catalog, prefix.summary());
    }
    let expected = catalog.compatible_degree_targets(state.summary());
    let mut frontier_group = criterion.benchmark_group("gf27_reversible_frontier");
    frontier_group.throughput(Throughput::Elements(frontier.active_count() as u64));
    frontier_group.bench_function("refine_parent_child_rollback", |bencher| {
        bencher.iter(|| {
            let checkpoint = frontier.refine(&catalog, state.summary());
            assert_eq!(frontier.active_count(), expected);
            frontier.rollback(checkpoint);
            black_box(frontier.active_count());
        });
    });
    frontier_group.finish();

    let forced = seeded_points(&plane, 30);
    let cap_stats = canonical_maximal_prefix_search(
        &plane,
        &catalog,
        &forced,
        32,
        u64::MAX,
        SearchPruning::DegreeCapOnly,
    )
    .unwrap()
    .stats;
    let catalog_stats = canonical_maximal_prefix_search(
        &plane,
        &catalog,
        &forced,
        32,
        u64::MAX,
        SearchPruning::DefectCatalog,
    )
    .unwrap()
    .stats;
    eprintln!("cap-only search: {cap_stats:?}");
    eprintln!("catalog search: {catalog_stats:?}");
    let mut search_group = criterion.benchmark_group("gf27_canonical_prefix_search");
    for (name, pruning, stats) in [
        ("degree_cap_only", SearchPruning::DegreeCapOnly, cap_stats),
        (
            "defect_catalog",
            SearchPruning::DefectCatalog,
            catalog_stats,
        ),
    ] {
        search_group.throughput(Throughput::Elements(stats.nodes));
        search_group.bench_function(name, |bencher| {
            bencher.iter(|| {
                black_box(
                    canonical_maximal_prefix_search(
                        &plane,
                        &catalog,
                        &forced,
                        32,
                        u64::MAX,
                        pruning,
                    )
                    .unwrap(),
                )
            });
        });
    }
    search_group.finish();

    let forced = seeded_points(&plane, 34);
    let cap_stats = canonical_maximal_prefix_search(
        &plane,
        &catalog,
        &forced,
        36,
        u64::MAX,
        SearchPruning::DegreeCapOnly,
    )
    .unwrap()
    .stats;
    let catalog_stats = canonical_maximal_prefix_search(
        &plane,
        &catalog,
        &forced,
        36,
        u64::MAX,
        SearchPruning::DefectCatalog,
    )
    .unwrap()
    .stats;
    let mut winning_group = criterion.benchmark_group("gf27_canonical_prefix_winning");
    for (name, pruning, stats) in [
        ("degree_cap_only", SearchPruning::DegreeCapOnly, cap_stats),
        (
            "defect_catalog",
            SearchPruning::DefectCatalog,
            catalog_stats,
        ),
    ] {
        winning_group.throughput(Throughput::Elements(stats.nodes));
        winning_group.bench_function(name, |bencher| {
            bencher.iter(|| {
                black_box(
                    canonical_maximal_prefix_search(
                        &plane,
                        &catalog,
                        &forced,
                        36,
                        u64::MAX,
                        pruning,
                    )
                    .unwrap(),
                )
            });
        });
    }
    winning_group.finish();

    let conditioned = canonical_maximal_prefix_search(
        &plane,
        &catalog,
        &forced,
        54,
        u64::MAX,
        SearchPruning::DefectCatalog,
    )
    .unwrap();
    assert_eq!(conditioned.stats.terminal_prefixes, 0);
    assert!(!conditioned.stats.node_limit_hit);
    let mut conditioned_group = criterion.benchmark_group("gf27_conditioned_unsat");
    conditioned_group.throughput(Throughput::Elements(conditioned.stats.nodes));
    conditioned_group.bench_function("catalog_forced34_to54", |bencher| {
        bencher.iter(|| {
            black_box(
                canonical_maximal_prefix_search(
                    &plane,
                    &catalog,
                    &forced,
                    54,
                    u64::MAX,
                    SearchPruning::DefectCatalog,
                )
                .unwrap(),
            )
        });
    });
    conditioned_group.finish();
}

criterion_group! {
    name = benches;
    config = Criterion::default()
        .sample_size(80)
        .warm_up_time(Duration::from_secs(2))
        .measurement_time(Duration::from_secs(4));
    targets = defect_augmentation
}
criterion_main!(benches);
