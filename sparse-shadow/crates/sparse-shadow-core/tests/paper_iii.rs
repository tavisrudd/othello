use std::path::PathBuf;

use sparse_shadow_core::{
    DeclaredAction, InputArtifact, ProfileInput, ShadowError, canonicalize, reconstruct_paper_iii,
    validate, verify_canonical_artifact, verify_paper_iii_reconstruction,
};

fn export_path() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("../../../papers/clebsch-passages/verification/sparse_shadow_export.json")
}

fn load() -> InputArtifact {
    serde_json::from_slice(&std::fs::read(export_path()).expect("read Paper-III export"))
        .expect("typed Paper-III export")
}

#[test]
fn paper_iii_export_validates_and_rejects_corruption() {
    let input = load();
    assert_eq!(
        validate(&input)
            .expect("validate Paper-III export")
            .checked_automorphisms,
        720
    );
    let mut corrupt = input;
    let ProfileInput::PaperIiiFourShadow(value) = &mut corrupt.profile else {
        unreachable!()
    };
    value.rational_fibre_point[0].numerator = 3;
    assert!(matches!(validate(&corrupt), Err(ShadowError::Invalid(_))));
}

#[test]
fn paper_iii_canonical_and_reconstruction_certificates_replay() {
    let input = load();
    let canonical = canonicalize(&input).expect("canonicalize Paper-III export");
    assert_eq!(canonical.automorphism_order, 720);
    verify_canonical_artifact(&input, &canonical).expect("replay Paper-III certificate");
    let reconstruction = reconstruct_paper_iii(&input).expect("reconstruct Paper-III carrier");
    assert!(reconstruction.carrier.aligned_four_sets.is_empty());
    assert_eq!(reconstruction.carrier.calibrated_triangle_product, -1);
    assert!(reconstruction.exact_oriented_return);
    verify_paper_iii_reconstruction(&input, &reconstruction).expect("replay reconstruction");
    let mut corrupt = reconstruction;
    corrupt.carrier.calibrated_triangle_product = 1;
    assert!(matches!(
        verify_paper_iii_reconstruction(&input, &corrupt),
        Err(ShadowError::Certificate(_))
    ));
}

#[test]
fn paper_iii_is_relabeling_invariant_and_idempotent() {
    let input = load();
    let permutation = [5_u32, 3, 1, 4, 0, 2];
    let mut moved = input.clone();
    let ProfileInput::PaperIiiFourShadow(value) = &mut moved.profile else {
        unreachable!()
    };
    for four_set in &mut value.aligned_four_sets {
        *four_set = four_set.map(|vertex| permutation[vertex as usize]);
        four_set.sort_unstable();
    }
    value.aligned_four_sets.sort_unstable();
    let DeclaredAction::VertexPermutations { generators, .. } = &mut value.action else {
        unreachable!()
    };
    for generator in generators {
        let old = generator.clone();
        for vertex in 0..6 {
            generator[permutation[vertex] as usize] = permutation[old[vertex] as usize];
        }
    }
    let original = canonicalize(&input).expect("canonicalize original");
    let relabeled = canonicalize(&moved).expect("canonicalize relabeling");
    assert_eq!(original.canonical_id, relabeled.canonical_id);
    assert_eq!(original.canonical, relabeled.canonical);
    let repeated = canonicalize(&original.canonical).expect("canonicalize canonical form");
    assert_eq!(original.canonical_id, repeated.canonical_id);
}

#[test]
fn paper_iii_golden_contract_is_stable() {
    let input = load();
    let canonical = canonicalize(&input).expect("canonicalize Paper-III export");
    let reconstruction = reconstruct_paper_iii(&input).expect("reconstruct Paper-III carrier");
    let contract: serde_json::Value = serde_json::from_str(include_str!(
        "../../../fixtures/paper-iii-golden-contract.json"
    ))
    .expect("Paper-III golden contract parses");
    assert_eq!(contract["canonical_id"], canonical.canonical_id);
    assert_eq!(contract["automorphism_order"], canonical.automorphism_order);
    assert_eq!(contract["proof_system"], canonical.certificate.proof_system);
    assert_eq!(
        contract["search_stats"],
        serde_json::to_value(&canonical.stats).expect("stats serialize")
    );
    assert_eq!(
        contract["carrier"],
        serde_json::json!({
            "aligned_four_set_count": reconstruction.carrier.aligned_four_sets.len(),
            "branch_sextic": reconstruction.carrier.branch_sextic,
            "calibrated_triangle_product": reconstruction.carrier.calibrated_triangle_product,
            "fibre_quadratic_algebra": reconstruction.carrier.fibre_quadratic_algebra,
        })
    );
}
