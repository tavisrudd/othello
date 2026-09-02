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
