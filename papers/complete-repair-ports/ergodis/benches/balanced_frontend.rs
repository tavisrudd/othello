use std::hint::black_box;

use criterion::{criterion_group, criterion_main, Criterion, Throughput};
use ergodis::balanced::{
    BalancedTransversalCatalog, CarrierEquationBasis, CarrierEquationPush, HighFiberLedger,
    HighFiberPolynomial, HighFiberSpec,
};
use ergodis::{compile_ternary_affine_constraints, OrbitOption};

fn balanced_frontend(criterion: &mut Criterion) {
    let mut compile = criterion.benchmark_group("gf27_balanced_frontend");
    compile.throughput(Throughput::Elements(1_060));
    compile.bench_function("compile_two_semilinear_cases", |bencher| {
        bencher.iter(|| black_box(BalancedTransversalCatalog::q27()));
    });
    compile.finish();

    let catalog = BalancedTransversalCatalog::q27();
    let first = HighFiberPolynomial::new(1, [4, 7, 11, 3, 18, 9, 22, 6, 1]).unwrap();
    let second = HighFiberPolynomial::new(2, [8, 2, 15, 20, 5, 17, 12, 24, 10]).unwrap();
    let mut reconstruction = criterion.benchmark_group("gf27_balanced_seed_reconstruction");
    reconstruction.throughput(Throughput::Elements(9));
    reconstruction.bench_function("two_fibers_to_trace_product", |bencher| {
        bencher.iter(|| {
            black_box(
                catalog
                    .reconstruct_carrier_from_fibers(black_box(first), black_box(second))
                    .unwrap(),
            )
        });
    });
    reconstruction.finish();

    let carrier = catalog
        .reconstruct_carrier_from_fibers(first, second)
        .unwrap();
    let candidate_families: Vec<_> = (1..=9)
        .map(|value| {
            let truth = catalog.high_fiber_from_carrier(&carrier, value).unwrap();
            let mut family = Vec::with_capacity(64);
            for index in 0..63 {
                let mut decoy = truth;
                decoy.coefficients[0] =
                    ((usize::from(decoy.coefficients[0]) + index + 1) % 27) as u8;
                decoy.coefficients[1] =
                    ((usize::from(decoy.coefficients[1]) + index / 26 + 1) % 27) as u8;
                family.push(decoy);
            }
            family.push(truth);
            family
        })
        .collect();
    assert_eq!(
        catalog
            .search_high_fiber_candidates(&candidate_families)
            .unwrap()
            .unwrap()
            .candidates_examined,
        4_096
    );
    let mut seed_join = criterion.benchmark_group("gf27_balanced_seed_join");
    seed_join.throughput(Throughput::Elements(4_096));
    seed_join.bench_function("nine_families_64_candidates", |bencher| {
        bencher.iter(|| {
            black_box(
                catalog
                    .search_high_fiber_candidates(black_box(&candidate_families))
                    .unwrap(),
            )
        });
    });
    seed_join.finish();

    let carrier_cells = [
        (2, 2),
        (2, 1),
        (3, 3),
        (3, 9),
        (4, 4),
        (4, 16),
        (5, 5),
        (5, 13),
        (6, 6),
        (6, 9),
        (7, 7),
        (7, 13),
        (8, 8),
        (8, 16),
        (9, 9),
        (9, 15),
        (10, 10),
        (10, 7),
    ];
    let mut cell_solve = criterion.benchmark_group("gf27_balanced_cell_carrier");
    cell_solve.throughput(Throughput::Elements(18));
    cell_solve.bench_function("rank_18_reconstruction", |bencher| {
        bencher.iter(|| {
            black_box(
                catalog
                    .carrier_from_high_cells(black_box(&carrier_cells))
                    .unwrap(),
            )
        });
    });
    cell_solve.finish();

    let mut basis = CarrierEquationBasis::default();
    for &(x, y) in &carrier_cells[..17] {
        assert_eq!(
            catalog.push_high_cell(&mut basis, x, y),
            Some(CarrierEquationPush::Independent)
        );
    }
    let mut incremental = criterion.benchmark_group("gf27_balanced_cell_incremental");
    incremental.throughput(Throughput::Elements(1));
    incremental.bench_function("rank_17_push_pop", |bencher| {
        bencher.iter(|| {
            assert_eq!(
                catalog.push_high_cell(&mut basis, carrier_cells[17].0, carrier_cells[17].1),
                Some(CarrierEquationPush::Independent)
            );
            assert!(basis.pop_independent());
            black_box(basis.rank())
        });
    });
    incremental.bench_function("rank_17_push_solve_pop", |bencher| {
        bencher.iter(|| {
            assert_eq!(
                catalog.push_high_cell(&mut basis, carrier_cells[17].0, carrier_cells[17].1),
                Some(CarrierEquationPush::Independent)
            );
            let carrier = catalog.carrier_from_equation_basis(&basis).unwrap();
            assert!(basis.pop_independent());
            black_box(carrier)
        });
    });
    incremental.finish();

    let affine_families: Vec<_> = (0..32)
        .map(|family| {
            let residue: Vec<_> = (0..102)
                .map(|coordinate| ((family * 17 + coordinate * 11 + coordinate / 7) % 3) as u8)
                .collect();
            vec![
                OrbitOption {
                    label: (2 * family) as u32,
                    residue: vec![0; 102].into_boxed_slice(),
                    totals: Box::new([]),
                },
                OrbitOption {
                    label: (2 * family + 1) as u32,
                    residue: residue.into_boxed_slice(),
                    totals: Box::new([]),
                },
            ]
        })
        .collect();
    let mut affine = criterion.benchmark_group("orbit_affine_compile");
    affine.throughput(Throughput::Elements(32));
    affine.bench_function("synthetic_32_binary_102_to_rank", |bencher| {
        bencher.iter(|| {
            black_box(
                compile_ternary_affine_constraints(
                    black_box(&affine_families),
                    black_box(&[0; 102]),
                    &[],
                )
                .unwrap(),
            )
        });
    });
    affine.finish();

    let mut scan = criterion.benchmark_group("gf27_balanced_mapping_scan");
    scan.throughput(Throughput::Elements(530));
    for ratio_case in 0..2 {
        let mappings = catalog.mappings(ratio_case).unwrap();
        scan.bench_function(format!("ratio_case_{ratio_case}"), |bencher| {
            bencher.iter(|| {
                let mut checksum = 0u32;
                for mapping in mappings {
                    checksum = checksum.wrapping_add(u32::from(mapping.rows[0]));
                    checksum = checksum.wrapping_add(u32::from(mapping.columns[0]));
                }
                black_box(checksum)
            });
        });
    }
    scan.finish();

    let a_by_x = std::array::from_fn(|index| ((index * index + 1) % 27) as u8);
    let mut output = [0u16; 530];
    let mut avoidance = criterion.benchmark_group("gf27_balanced_cell_avoidance");
    avoidance.throughput(Throughput::Elements(530));
    for ratio_case in 0..2 {
        avoidance.bench_function(format!("ratio_case_{ratio_case}"), |bencher| {
            bencher.iter(|| {
                black_box(
                    catalog
                        .cell_avoiding_indices(
                            ratio_case,
                            black_box(&a_by_x),
                            black_box(&mut output),
                        )
                        .unwrap(),
                )
            });
        });
    }
    avoidance.finish();

    let mut reduced = criterion.benchmark_group("gf27_balanced_representative_avoidance");
    for ratio_case in 0..2 {
        reduced.throughput(Throughput::Elements(
            catalog.work_items(ratio_case).unwrap().len() as u64,
        ));
        reduced.bench_function(format!("ratio_case_{ratio_case}"), |bencher| {
            bencher.iter(|| {
                black_box(
                    catalog
                        .cell_avoiding_representatives(
                            ratio_case,
                            black_box(&a_by_x),
                            black_box(&mut output),
                        )
                        .unwrap(),
                )
            });
        });
    }
    reduced.finish();

    let mut witt4 = criterion.benchmark_group("gf27_balanced_witt4_lookup");
    witt4.throughput(Throughput::Elements(729));
    for ratio_case in 0..2 {
        witt4.bench_function(format!("ratio_case_{ratio_case}"), |bencher| {
            bencher.iter(|| {
                let mut sum = 0u8;
                for t in 0..27 {
                    for u in 0..27 {
                        sum ^= catalog.witt4_weight(ratio_case, u, t).unwrap();
                    }
                }
                black_box(sum)
            });
        });
    }
    witt4.finish();

    let spec = HighFiberSpec::new([1, 2, 3, 4, 5, 6, 7, 8, 9], 0b111).unwrap();
    let mut rows = Vec::with_capacity(26);
    rows.extend([[1, 2], [1, 3], [2, 3], [4, 5], [4, 6], [5, 6], [7, 8]]);
    rows.extend([1, 2, 3, 4, 4, 5, 5, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 9].map(|root| [root, 10]));
    let mut ledger = criterion.benchmark_group("gf27_balanced_high_fiber_ledger");
    ledger.throughput(Throughput::Elements(26));
    ledger.bench_function("complete_row_replay", |bencher| {
        bencher.iter(|| {
            let mut state = HighFiberLedger::default();
            for &roots in &rows {
                assert!(state.try_push(black_box(&spec), black_box(roots)));
            }
            assert!(state.is_complete(&spec));
            black_box(state)
        });
    });
    ledger.finish();
}

criterion_group!(benches, balanced_frontend);
criterion_main!(benches);
