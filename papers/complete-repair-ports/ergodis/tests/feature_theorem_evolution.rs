use ergodis::{
    evolve_ranked_streaming, CensusReduction, EvolutionConfig, FeatureBankBounds, FeatureDag,
    FeatureId, FeatureOp, FeatureZeroBank, GroupAggregateOp, GroupAggregateSpec,
    GroupAggregationBounds, GroupAggregationPlan, RawFeatureExpansion,
};

#[derive(Clone, Copy)]
struct Score {
    false_negatives: u32,
    reduction: CensusReduction,
    cost: u32,
}

#[test]
fn runtime_raw_terms_recover_a_quadratic_residue_pruner() {
    let mut dag = FeatureDag::new(2, 2, 256).unwrap();
    let candidates = dag
        .expand_raw_degree_two(RawFeatureExpansion {
            moduli: &[7],
            include_gaussian_norms: true,
            include_eisenstein_norms: true,
            ..RawFeatureExpansion::default()
        })
        .unwrap();
    let rows = (-6_i64..=6)
        .flat_map(|left| (-6_i64..=6).map(move |right| [left, right]))
        .collect::<Vec<_>>();
    let expected = rows
        .iter()
        .map(|[left, right]| (left * left - left * right + right * right).rem_euclid(7) == 0)
        .collect::<Vec<_>>();
    let flat_rows = rows.iter().flatten().copied().collect::<Vec<_>>();
    let bank = FeatureZeroBank::compile(
        &dag,
        &flat_rows,
        FeatureBankBounds {
            maximum_rows: rows.len(),
            maximum_bitmap_words: dag.len() * rows.len().div_ceil(64),
        },
    )
    .unwrap();
    let expected_mask = label_mask(&expected);
    let summary = evolve_ranked_streaming(
        candidates.iter().copied(),
        EvolutionConfig {
            generations: 1,
            beam_width: 1,
            max_candidates: candidates.len(),
        },
        |_candidate, _output| {},
        |candidate: &FeatureId| {
            let census = bank
                .score_necessary_zero(*candidate, &expected_mask)
                .unwrap();
            Score {
                false_negatives: u32::try_from(census.false_negatives).unwrap(),
                reduction: CensusReduction::new(census.rows, census.surviving).unwrap(),
                cost: dag.node(*candidate).unwrap().evaluation_cost,
            }
        },
        |left, right| {
            left.false_negatives
                .cmp(&right.false_negatives)
                .then_with(|| left.reduction.preferred_cmp(right.reduction))
                .then_with(|| left.cost.cmp(&right.cost))
        },
        |score| score.false_negatives == 0,
        |_trial| Ok::<_, std::convert::Infallible>(()),
    )
    .unwrap();
    let best = summary.best_admitted.unwrap().candidate;
    let FeatureOp::Mod { source, modulus: 7 } = dag.node(best).unwrap().op else {
        panic!("best raw feature was not a modulo-seven term");
    };
    assert!(matches!(
        dag.node(source).unwrap().op,
        FeatureOp::EisensteinNorm { .. }
    ));
}

#[test]
fn affine_lift_transfers_a_symbolic_parameter_to_held_out_shards() {
    let mut dag = FeatureDag::new(3, 2, 2_048).unwrap();
    let candidates = dag
        .expand_raw_degree_two(RawFeatureExpansion {
            include_gaussian_norms: false,
            include_eisenstein_norms: false,
            include_affine_lifts: true,
            ..RawFeatureExpansion::default()
        })
        .unwrap();
    let rows = [2_i64, 3, 5, 7]
        .into_iter()
        .flat_map(|parameter| {
            (-5_i64..=5).flat_map(move |x| (-40_i64..=40).map(move |y| [parameter, x, y]))
        })
        .collect::<Vec<_>>();
    let expected = rows
        .iter()
        .map(|[parameter, x, y]| parameter * x + y == 0)
        .collect::<Vec<_>>();
    let flat_rows = rows.iter().flatten().copied().collect::<Vec<_>>();
    let bank = FeatureZeroBank::compile(
        &dag,
        &flat_rows,
        FeatureBankBounds {
            maximum_rows: rows.len(),
            maximum_bitmap_words: dag.len() * rows.len().div_ceil(64),
        },
    )
    .unwrap();
    let expected_mask = label_mask(&expected);
    let summary = evolve_ranked_streaming(
        candidates.iter().copied(),
        EvolutionConfig {
            generations: 1,
            beam_width: 1,
            max_candidates: candidates.len(),
        },
        |_candidate, _output| {},
        |candidate: &FeatureId| {
            let census = bank
                .score_necessary_zero(*candidate, &expected_mask)
                .unwrap();
            Score {
                false_negatives: u32::try_from(census.false_negatives).unwrap(),
                reduction: CensusReduction::new(census.rows, census.surviving).unwrap(),
                cost: dag.node(*candidate).unwrap().evaluation_cost,
            }
        },
        |left, right| {
            left.false_negatives
                .cmp(&right.false_negatives)
                .then_with(|| left.reduction.preferred_cmp(right.reduction))
                .then_with(|| left.cost.cmp(&right.cost))
        },
        |score| score.false_negatives == 0,
        |_trial| Ok::<_, std::convert::Infallible>(()),
    )
    .unwrap();
    let best = summary.best_admitted.unwrap().candidate;
    assert!(depends_on_input(&dag, best, 0));

    let mut workspace = dag.workspace();
    for parameter in [11_i64, 13] {
        for x in -5_i64..=5 {
            for y in -70_i64..=70 {
                let selected =
                    dag.evaluate(&[parameter, x, y], &mut workspace).unwrap()[best.index()] == 0;
                assert_eq!(selected, parameter * x + y == 0);
            }
        }
    }
}

#[test]
fn grouped_moment_exposes_a_relation_missing_from_flat_degree_two_terms() {
    let mut rows = vec![[0_i64; 7]];
    for index in 0..7 {
        for value in [-1, 1] {
            let mut row = [0_i64; 7];
            row[index] = value;
            rows.push(row);
        }
    }
    let flat_rows = rows.iter().flatten().copied().collect::<Vec<_>>();
    let expected_mask = label_mask(&(0..rows.len()).map(|index| index == 0).collect::<Vec<_>>());

    let mut flat_dag = FeatureDag::new(7, 2, 512).unwrap();
    let flat_candidates = flat_dag
        .expand_raw_degree_two(RawFeatureExpansion::default())
        .unwrap();
    let flat_bank = FeatureZeroBank::compile(
        &flat_dag,
        &flat_rows,
        FeatureBankBounds {
            maximum_rows: rows.len(),
            maximum_bitmap_words: flat_dag.len() * rows.len().div_ceil(64),
        },
    )
    .unwrap();
    let best_flat_survivors = flat_candidates
        .iter()
        .map(|&candidate| {
            flat_bank
                .score_necessary_zero(candidate, &expected_mask)
                .unwrap()
                .surviving
        })
        .min()
        .unwrap();
    assert_eq!(best_flat_survivors, 11);

    let aggregate = GroupAggregationPlan::compile(
        7,
        &[GroupAggregateSpec {
            members: (0_u16..7).collect::<Vec<_>>().into_boxed_slice(),
            operations: vec![GroupAggregateOp::SumSquares].into_boxed_slice(),
        }],
        GroupAggregationBounds {
            maximum_groups: 1,
            maximum_members_per_group: 7,
            maximum_outputs: 1,
        },
    )
    .unwrap();
    let mut aggregate_rows = vec![0_i64; rows.len()];
    aggregate
        .evaluate_rows(&flat_rows, rows.len(), &mut aggregate_rows)
        .unwrap();
    let mut aggregate_dag = FeatureDag::new(1, 1, 4).unwrap();
    let moment = aggregate_dag.input(0).unwrap();
    let aggregate_bank = FeatureZeroBank::compile(
        &aggregate_dag,
        &aggregate_rows,
        FeatureBankBounds {
            maximum_rows: rows.len(),
            maximum_bitmap_words: aggregate_dag.len() * rows.len().div_ceil(64),
        },
    )
    .unwrap();
    let census = aggregate_bank
        .score_necessary_zero(moment, &expected_mask)
        .unwrap();
    assert_eq!(census.false_negatives, 0);
    assert_eq!(census.surviving, 1);
    let summary = evolve_ranked_streaming(
        [moment],
        EvolutionConfig {
            generations: 1,
            beam_width: 1,
            max_candidates: 1,
        },
        |_candidate, _output| {},
        |candidate: &FeatureId| {
            let census = aggregate_bank
                .score_necessary_zero(*candidate, &expected_mask)
                .unwrap();
            Score {
                false_negatives: u32::try_from(census.false_negatives).unwrap(),
                reduction: CensusReduction::new(census.rows, census.surviving).unwrap(),
                cost: aggregate_dag.node(*candidate).unwrap().evaluation_cost,
            }
        },
        |left, right| {
            left.false_negatives
                .cmp(&right.false_negatives)
                .then_with(|| left.reduction.preferred_cmp(right.reduction))
                .then_with(|| left.cost.cmp(&right.cost))
        },
        |score| score.false_negatives == 0,
        |_trial| Ok::<_, std::convert::Infallible>(()),
    )
    .unwrap();
    assert_eq!(summary.best_admitted.unwrap().candidate, moment);
}

fn label_mask(labels: &[bool]) -> Vec<u64> {
    let mut mask = vec![0_u64; labels.len().div_ceil(64)];
    for (row, &label) in labels.iter().enumerate() {
        mask[row / 64] |= u64::from(label) << (row % 64);
    }
    mask
}

fn depends_on_input(dag: &FeatureDag, id: FeatureId, target: u16) -> bool {
    match dag.node(id).unwrap().op {
        FeatureOp::Input { index } => index == target,
        FeatureOp::Constant { .. } => false,
        FeatureOp::Mod { source, .. } | FeatureOp::Abs { source } => {
            depends_on_input(dag, source, target)
        }
        FeatureOp::Add { left, right }
        | FeatureOp::Sub { left, right }
        | FeatureOp::Mul { left, right }
        | FeatureOp::GaussianNorm { left, right }
        | FeatureOp::EisensteinNorm { left, right } => {
            depends_on_input(dag, left, target) || depends_on_input(dag, right, target)
        }
    }
}
