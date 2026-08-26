use std::path::PathBuf;

use sparse_shadow_core::{
    DeclaredAction, InputArtifact, ProfileInput, ShadowError, canonicalize, reconstruct_paper_ii,
    validate, verify_canonical_artifact, verify_paper_ii_reconstruction,
};

fn export_path() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR")).join(
        "../../../papers/clebsch-factorization/verification/evidence/sparse_shadow_export.json",
    )
}

fn load() -> Option<InputArtifact> {
    let path = export_path();
    path.exists().then(|| {
        serde_json::from_slice(&std::fs::read(path).expect("read Paper-II export"))
            .expect("typed Paper-II export")
    })
}

#[test]
fn paper_ii_export_validates_and_rejects_corruption() {
    let Some(input) = load() else { return };
    let report = validate(&input).expect("validate Paper-II export");
    assert_eq!(report.checked_automorphisms, 1320);

    let mut corrupt = input;
    let ProfileInput::PaperIiTrade(value) = &mut corrupt.profile else {
        unreachable!()
    };
    value.trade_halves[0][0].support[0] = 2;
    assert!(matches!(validate(&corrupt), Err(ShadowError::Invalid(_))));
}

#[test]
fn paper_ii_canonical_and_reconstruction_certificates_replay() {
    let Some(input) = load() else { return };
    let canonical = canonicalize(&input).expect("canonicalize Paper-II export");
    assert_eq!(canonical.automorphism_order, 660);
    assert_eq!(canonical.vertex_orbits, vec![(0..12).collect::<Vec<_>>()]);
    verify_canonical_artifact(&input, &canonical).expect("replay Paper-II canonical certificate");

    let reconstruction = reconstruct_paper_ii(&input).expect("reconstruct matching carrier");
    assert_eq!(reconstruction.carrier.matchings.len(), 22);
    assert_eq!(reconstruction.carrier.oriented_sheets[0].len(), 11);
    assert_eq!(reconstruction.carrier.oriented_sheets[1].len(), 11);
    assert_eq!(reconstruction.carrier.full_action_order, 1320);
    assert_eq!(reconstruction.carrier.oriented_stabilizer_order, 660);
    verify_paper_ii_reconstruction(&input, &reconstruction).expect("replay reconstruction");

    let mut corrupt = reconstruction;
    corrupt.carrier.matchings.pop();
    assert!(matches!(
        verify_paper_ii_reconstruction(&input, &corrupt),
        Err(ShadowError::Certificate(_))
    ));
}

#[test]
fn paper_ii_is_relabeling_invariant_and_idempotent() {
    let Some(input) = load() else { return };
    let mut moved = input.clone();
    let ProfileInput::PaperIiTrade(value) = &mut moved.profile else {
        unreachable!()
    };
    let DeclaredAction::VertexPermutations { generators, .. } = &value.action else {
        unreachable!()
    };
    let permutation: [u32; 12] = generators[1].clone().try_into().expect("degree twelve");
    for block in value.trade_halves.iter_mut().flatten() {
        for edge in &mut block.support {
            let mut endpoints = [
                permutation[*edge as usize / 12],
                permutation[*edge as usize % 12],
            ];
            endpoints.sort_unstable();
            *edge = endpoints[0] * 12 + endpoints[1];
        }
        block.support.sort_unstable();
    }
    for half in &mut value.trade_halves {
        half.sort_unstable_by_key(|block| block.support.clone());
    }
    let DeclaredAction::VertexPermutations { generators, .. } = &mut value.action else {
        unreachable!()
    };
    for generator in generators {
        let old = generator.clone();
        for vertex in 0..12 {
            generator[permutation[vertex] as usize] = permutation[old[vertex] as usize];
        }
    }

    let original = canonicalize(&input).expect("canonicalize original");
    let relabeled = canonicalize(&moved).expect("canonicalize relabeling");
    let (ProfileInput::PaperIiTrade(left), ProfileInput::PaperIiTrade(right)) =
        (&original.canonical.profile, &relabeled.canonical.profile)
    else {
        unreachable!()
    };
    assert_eq!(left.trade_halves, right.trade_halves);
    assert_eq!(left.action, right.action);
    assert_eq!(original.canonical_id, relabeled.canonical_id);
    assert_eq!(original.canonical, relabeled.canonical);
    let repeated = canonicalize(&original.canonical).expect("canonicalize canonical form");
    assert_eq!(original.canonical_id, repeated.canonical_id);
}

#[test]
fn paper_ii_golden_contract_is_stable() {
    let Some(input) = load() else { return };
    let canonical = canonicalize(&input).expect("canonicalize Paper-II export");
    let reconstruction = reconstruct_paper_ii(&input).expect("reconstruct Paper-II carrier");
    let contract: serde_json::Value = serde_json::from_str(include_str!(
        "../../../fixtures/paper-ii-golden-contract.json"
    ))
    .expect("Paper-II golden contract parses");
    assert_eq!(contract["canonical_id"], canonical.canonical_id);
    assert_eq!(contract["automorphism_order"], canonical.automorphism_order);
    assert_eq!(contract["proof_system"], canonical.certificate.proof_system);
    assert_eq!(
        contract["search_stats"],
        serde_json::to_value(&canonical.stats).expect("stats serialize")
    );
    assert_eq!(
        contract["carrier"]["endpoint_count"],
        reconstruction.carrier.endpoint_count
    );
    assert_eq!(
        contract["carrier"]["matching_count"],
        reconstruction.carrier.matchings.len()
    );
    assert_eq!(
        contract["carrier"]["sheet_sizes"],
        serde_json::json!([
            reconstruction.carrier.oriented_sheets[0].len(),
            reconstruction.carrier.oriented_sheets[1].len()
        ])
    );
    assert_eq!(
        contract["carrier"]["full_action_order"],
        reconstruction.carrier.full_action_order
    );
    assert_eq!(
        contract["carrier"]["oriented_stabilizer_order"],
        reconstruction.carrier.oriented_stabilizer_order
    );
}
