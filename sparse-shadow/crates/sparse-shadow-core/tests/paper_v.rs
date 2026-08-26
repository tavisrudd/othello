use std::path::PathBuf;

use sparse_shadow_core::{
    DeclaredAction, InputArtifact, ProfileInput, ShadowError, canonicalize, reconstruct_paper_v,
    validate, verify_canonical_artifact, verify_paper_v_reconstruction,
};

fn export_path() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR")).join(
        "../../../papers/chordal-conference-reconstruction/verification/evidence/sparse_shadow_export.json",
    )
}

fn load() -> Option<InputArtifact> {
    let path = export_path();
    path.exists().then(|| {
        serde_json::from_slice(&std::fs::read(path).expect("read Paper-V export"))
            .expect("typed Paper-V export")
    })
}

#[test]
fn paper_v_export_validates_and_rejects_corruption() {
    let Some(input) = load() else { return };
    assert_eq!(
        validate(&input)
            .expect("validate Paper-V export")
            .checked_automorphisms,
        720
    );
    let mut corrupt = input;
    let ProfileInput::PaperVChordalConference(value) = &mut corrupt.profile else {
        unreachable!()
    };
    value.delta_matrix[0][1].numerator = -1;
    assert!(matches!(validate(&corrupt), Err(ShadowError::Invalid(_))));
}

#[test]
fn paper_v_canonical_and_reconstruction_certificates_replay() {
    let Some(input) = load() else { return };
    let canonical = canonicalize(&input).expect("canonicalize Paper-V export");
    verify_canonical_artifact(&input, &canonical).expect("replay Paper-V certificate");
    let reconstruction = reconstruct_paper_v(&input).expect("reconstruct Paper-V carrier");
    assert_eq!(reconstruction.carrier.six_axes.len(), 6);
    assert_eq!(reconstruction.carrier.chordal_quartic_points.len(), 12);
    assert_eq!(reconstruction.carrier.conference_cubic.len(), 35);
    assert_eq!(reconstruction.carrier.chordal_cubic.len(), 35);
    assert!(reconstruction.exact_marked_return);
    verify_paper_v_reconstruction(&input, &reconstruction).expect("replay reconstruction");
    let mut corrupt = reconstruction;
    corrupt.carrier.chordal_quartic_points.pop();
    assert!(matches!(
        verify_paper_v_reconstruction(&input, &corrupt),
        Err(ShadowError::Certificate(_))
    ));
}

#[test]
fn paper_v_is_relabeling_invariant_and_idempotent() {
    let Some(input) = load() else { return };
    let permutation = [5_u32, 3, 1, 4, 0, 2];
    let mut moved = input.clone();
    let ProfileInput::PaperVChordalConference(value) = &mut moved.profile else {
        unreachable!()
    };
    for relation in &mut value.retained_residue.relations {
        for edge in &mut relation.edges {
            *edge = [permutation[edge[0] as usize], permutation[edge[1] as usize]];
            edge.sort_unstable();
        }
        relation.edges.sort_unstable();
    }
    let old_outer = value.outer_involution.clone();
    for old in 0..6 {
        value.outer_involution[permutation[old] as usize] = permutation[old_outer[old] as usize];
    }
    let old_delta = value.delta_matrix.clone();
    for row in 0..6 {
        for column in 0..6 {
            value.delta_matrix[permutation[row] as usize][permutation[column] as usize] =
                old_delta[row][column].clone();
        }
    }
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
fn paper_v_golden_contract_is_stable() {
    let Some(input) = load() else { return };
    let canonical = canonicalize(&input).expect("canonicalize Paper-V export");
    let reconstruction = reconstruct_paper_v(&input).expect("reconstruct Paper-V carrier");
    let contract: serde_json::Value = serde_json::from_str(include_str!(
        "../../../fixtures/paper-v-golden-contract.json"
    ))
    .expect("Paper-V golden contract parses");
    assert_eq!(contract["canonical_id"], canonical.canonical_id);
    assert_eq!(contract["automorphism_order"], canonical.automorphism_order);
    assert_eq!(contract["proof_system"], canonical.certificate.proof_system);
    assert_eq!(
        contract["search_stats"],
        serde_json::to_value(&canonical.stats).expect("stats serialize")
    );
    assert_eq!(
        contract["carrier"]["conference_node_count"],
        reconstruction.carrier.six_axes.len()
    );
    assert_eq!(
        contract["carrier"]["chordal_point_count"],
        reconstruction.carrier.chordal_quartic_points.len()
    );
    assert_eq!(
        contract["carrier"]["cubic_coefficient_counts"],
        serde_json::json!([
            reconstruction.carrier.conference_cubic.len(),
            reconstruction.carrier.chordal_cubic.len()
        ])
    );
    assert_eq!(
        contract["carrier"]["selected_chordal_line"],
        reconstruction.carrier.selected_chordal_line
    );
}
