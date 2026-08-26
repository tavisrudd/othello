use std::path::PathBuf;

use sparse_shadow_core::{
    DeclaredAction, InputArtifact, ProfileInput, ShadowError, canonicalize, compare,
    reconstruct_paper_iv, validate, verify_canonical_artifact, verify_equivalence,
    verify_paper_iv_reconstruction,
};

fn export_path() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("../../../papers/q13-passant-code/verification/sparse_shadow_export.json")
}

fn load_export() -> Option<serde_json::Value> {
    let path = export_path();
    path.exists().then(|| {
        serde_json::from_slice(&std::fs::read(path).expect("read Paper-IV export"))
            .expect("parse Paper-IV export")
    })
}

#[test]
fn paper_iv_export_passes_the_independent_structural_gate() {
    let Some(value) = load_export() else { return };
    let artifact: InputArtifact = serde_json::from_value(value).expect("typed Paper-IV export");
    let report = validate(&artifact).expect("valid Paper-IV export");
    assert!(report.valid);
    assert_eq!(report.checked_automorphisms, 2184);
}

#[test]
fn paper_iv_export_rejects_pair_and_source_corruption() {
    let Some(value) = load_export() else { return };

    let mut pair = value.clone();
    pair["profile"]["input"]["weighted_pair_section"][0]["multiplicity"] = 5.into();
    let artifact: InputArtifact = serde_json::from_value(pair).expect("typed corrupted export");
    assert!(matches!(validate(&artifact), Err(ShadowError::Invalid(_))));

    let mut source = value.clone();
    source["profile"]["input"]["source"]["sha256"] = "0".repeat(64).into();
    let artifact: InputArtifact = serde_json::from_value(source).expect("typed corrupted export");
    assert!(matches!(validate(&artifact), Err(ShadowError::Invalid(_))));

    let mut action = value;
    let generator = action["profile"]["input"]["action"]["generators"][0]
        .as_array_mut()
        .expect("generator is an array");
    generator.swap(0, 1);
    let artifact: InputArtifact = serde_json::from_value(action).expect("typed corrupted export");
    assert!(matches!(validate(&artifact), Err(ShadowError::Invalid(_))));
}

#[test]
fn paper_iv_canonical_certificate_has_independent_replay() {
    let Some(value) = load_export() else { return };
    let artifact: InputArtifact = serde_json::from_value(value).expect("typed Paper-IV export");
    let canonical = canonicalize(&artifact).expect("canonicalize Paper-IV export");
    assert_eq!(canonical.automorphism_order, 2184);
    assert_eq!(canonical.vertex_orbits, vec![(0..78).collect::<Vec<_>>()]);
    let report = verify_canonical_artifact(&artifact, &canonical)
        .expect("independently replay Paper-IV canonical certificate");
    assert_eq!(report.checked_automorphisms, 2184);

    let mut corrupt = canonical;
    corrupt.certificate.automorphisms.pop();
    assert!(matches!(
        verify_canonical_artifact(&artifact, &corrupt),
        Err(ShadowError::Certificate(_))
    ));
}

#[test]
fn paper_iv_reconstructs_and_replays_the_marked_conic_plane() {
    let Some(value) = load_export() else { return };
    let input: InputArtifact = serde_json::from_value(value).expect("typed Paper-IV export");
    let artifact = reconstruct_paper_iv(&input).expect("reconstruct Paper-IV carrier");
    assert_eq!(artifact.carrier.points.len(), 183);
    assert_eq!(artifact.carrier.lines.len(), 183);
    assert_eq!(artifact.carrier.conic_points.len(), 14);
    assert_eq!(artifact.carrier.passant_incidence_rows.len(), 78);
    assert_eq!(artifact.carrier.elliptic_relations.len(), 6);
    assert_eq!(artifact.carrier.binary_code_rank, 36);
    verify_paper_iv_reconstruction(&input, &artifact)
        .expect("independently replay Paper-IV reconstruction");

    let mut corrupt = artifact;
    corrupt.carrier.conic_points.pop();
    assert!(matches!(
        verify_paper_iv_reconstruction(&input, &corrupt),
        Err(ShadowError::Certificate(_))
    ));
}

#[test]
fn paper_iv_canonicalization_is_relabeling_invariant_and_idempotent() {
    let Some(value) = load_export() else { return };
    let input: InputArtifact = serde_json::from_value(value).expect("typed Paper-IV export");
    let permutation = (0_u32..78)
        .map(|vertex| (17 * vertex + 5) % 78)
        .collect::<Vec<_>>();
    let mut relabeled = input.clone();
    let ProfileInput::PaperIvMinimumWords(value) = &mut relabeled.profile else {
        unreachable!()
    };
    for pair in &mut value.weighted_pair_section {
        let mut endpoints = [
            permutation[pair.left as usize],
            permutation[pair.right as usize],
        ];
        endpoints.sort_unstable();
        pair.left = endpoints[0];
        pair.right = endpoints[1];
    }
    value
        .weighted_pair_section
        .sort_unstable_by_key(|pair| (pair.left, pair.right));
    let DeclaredAction::VertexPermutations { generators, .. } = &mut value.action else {
        unreachable!()
    };
    for generator in generators {
        let old = generator.clone();
        for vertex in 0..78 {
            generator[permutation[vertex] as usize] = permutation[old[vertex] as usize];
        }
    }

    let original = canonicalize(&input).expect("canonicalize original Paper-IV export");
    let moved = canonicalize(&relabeled).expect("canonicalize relabeled Paper-IV export");
    assert_eq!(original.canonical_id, moved.canonical_id);
    assert_eq!(original.canonical, moved.canonical);
    verify_canonical_artifact(&relabeled, &moved).expect("replay relabeled certificate");

    let repeated = canonicalize(&original.canonical).expect("canonicalize canonical Paper-IV form");
    assert_eq!(repeated.canonical_id, original.canonical_id);
    assert_eq!(repeated.canonical, original.canonical);

    let equivalence = compare(&input, &relabeled).expect("compare Paper-IV relabeling");
    verify_equivalence(&input, &relabeled, &equivalence)
        .expect("replay Paper-IV equivalence certificate");
}
