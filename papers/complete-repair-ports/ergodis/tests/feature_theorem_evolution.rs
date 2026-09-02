use ergodis::{
    evolve_ranked_streaming, CensusReduction, EvolutionConfig, FeatureDag, FeatureId, FeatureOp,
    RawFeatureExpansion,
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
    let mut columns = vec![vec![0_i64; rows.len()]; dag.len()];
    let mut workspace = dag.workspace();
    for (row_index, row) in rows.iter().enumerate() {
        let values = dag.evaluate(row, &mut workspace).unwrap();
        for (column, &value) in columns.iter_mut().zip(values) {
            column[row_index] = value;
        }
    }
    let summary = evolve_ranked_streaming(
        candidates.iter().copied(),
        EvolutionConfig {
            generations: 1,
            beam_width: 1,
            max_candidates: candidates.len(),
        },
        |_candidate, _output| {},
        |candidate: &FeatureId| {
            let selected = columns[candidate.index()].iter().map(|&value| value == 0);
            let (mut false_negatives, mut surviving) = (0_u32, 0_u64);
            for (selected, &expected) in selected.zip(&expected) {
                surviving += u64::from(selected);
                false_negatives += u32::from(expected && !selected);
            }
            Score {
                false_negatives,
                reduction: CensusReduction::new(rows.len() as u64, surviving).unwrap(),
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
    let mut columns = vec![vec![0_i64; rows.len()]; dag.len()];
    let mut workspace = dag.workspace();
    for (row_index, row) in rows.iter().enumerate() {
        for (column, &value) in columns
            .iter_mut()
            .zip(dag.evaluate(row, &mut workspace).unwrap())
        {
            column[row_index] = value;
        }
    }
    let summary = evolve_ranked_streaming(
        candidates.iter().copied(),
        EvolutionConfig {
            generations: 1,
            beam_width: 1,
            max_candidates: candidates.len(),
        },
        |_candidate, _output| {},
        |candidate: &FeatureId| {
            let mut false_negatives = 0_u32;
            let mut surviving = 0_u64;
            for (&value, &expected) in columns[candidate.index()].iter().zip(&expected) {
                let selected = value == 0;
                surviving += u64::from(selected);
                false_negatives += u32::from(expected && !selected);
            }
            Score {
                false_negatives,
                reduction: CensusReduction::new(rows.len() as u64, surviving).unwrap(),
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
