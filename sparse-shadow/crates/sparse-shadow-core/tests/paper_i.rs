use proptest::prelude::*;
use sparse_shadow_core::{
    CanonicalCertificate, EquivalenceOutcome, InputArtifact, ProfileInput, canonicalize, compare,
    reconstruct, validate, verify_certificate, verify_equivalence, verify_reconstruction,
};

const FIXTURE: &str = include_str!("../../../fixtures/paper-i-icosahedral-orbitals.json");

fn fixture() -> InputArtifact {
    serde_json::from_str(FIXTURE).expect("committed fixture parses")
}

fn rotate(input: &mut InputArtifact, amount: u32) {
    let ProfileInput::PaperIOrientation(paper) = &mut input.profile else {
        unreachable!();
    };
    let n = u32::try_from(paper.shadow.vertices.len()).expect("fixture size fits u32");
    let mut vertices = paper.shadow.vertices.clone();
    for (old, value) in paper.shadow.vertices.iter().enumerate() {
        let old = u32::try_from(old).expect("fixture index fits u32");
        vertices[(old + amount).rem_euclid(n) as usize] = value.clone();
    }
    paper.shadow.vertices = vertices;
    for relation in &mut paper.shadow.relations {
        for edge in &mut relation.edges {
            edge[0] = (edge[0] + amount).rem_euclid(n);
            edge[1] = (edge[1] + amount).rem_euclid(n);
            if !relation.directed && edge[0] > edge[1] {
                edge.swap(0, 1);
            }
        }
        relation.edges.sort_unstable();
    }
}

#[test]
fn fixture_validates_and_has_expected_symmetry() {
    let input = fixture();
    assert!(validate(&input).expect("valid fixture").valid);
    let artifact = canonicalize(&input).expect("canonical fixture");
    assert_eq!(artifact.automorphism_order, 120);
    assert!(artifact.automorphism_generators.len() < 120);
    assert_eq!(artifact.vertex_orbits, vec![(0..12).collect::<Vec<_>>()]);
}

#[test]
fn certificate_replays_and_corruption_is_rejected() {
    let input = fixture();
    let artifact = canonicalize(&input).expect("canonical fixture");
    assert!(
        verify_certificate(&input, &artifact.certificate)
            .expect("valid certificate")
            .valid
    );
    let mut corrupt: CanonicalCertificate = artifact.certificate;
    let replacement = if corrupt.canonical_id.starts_with('0') {
        "1"
    } else {
        "0"
    };
    corrupt.canonical_id.replace_range(0..1, replacement);
    assert!(verify_certificate(&input, &corrupt).is_err());

    let mut corrupt_trace = canonicalize(&input).expect("canonical fixture").certificate;
    corrupt_trace.winning_trace[0].chosen_vertex ^= 1;
    assert!(verify_certificate(&input, &corrupt_trace).is_err());

    let mut missing_automorphism = canonicalize(&input).expect("canonical fixture").certificate;
    missing_automorphism.automorphisms.pop();
    assert!(verify_certificate(&input, &missing_automorphism).is_err());
}

#[test]
fn malformed_orbital_partition_is_rejected() {
    let mut input = fixture();
    let ProfileInput::PaperIOrientation(paper) = &mut input.profile else {
        unreachable!();
    };
    paper.shadow.relations[0].edges.pop();
    assert!(validate(&input).is_err());
}

#[test]
fn provenance_does_not_change_mathematical_identity() {
    let left = fixture();
    let mut right = left.clone();
    let ProfileInput::PaperIOrientation(paper) = &mut right.profile else {
        unreachable!();
    };
    paper.theorem_locator = "a-second-frozen-export-of-the-same-shadow".into();
    let certificate = compare(&left, &right).expect("comparison");
    assert!(matches!(
        certificate.result,
        EquivalenceOutcome::Equivalent { .. }
    ));
    assert!(
        verify_equivalence(&left, &right, &certificate)
            .expect("equivalence replays")
            .valid
    );
}

#[test]
fn reconstruction_reports_unoriented_c2_fibre() {
    let reconstructed = reconstruct(&fixture()).expect("reconstruction");
    assert!(!reconstructed.exact_oriented_return);
    assert_eq!(
        reconstructed.round_trip_shadow,
        reconstructed.canonical.canonical
    );
    assert!(
        verify_reconstruction(&fixture(), &reconstructed)
            .expect("reconstruction replays")
            .valid
    );
    let mut corrupt = reconstructed;
    corrupt.carrier = "wrong_carrier".into();
    assert!(verify_reconstruction(&fixture(), &corrupt).is_err());
}

#[test]
fn equivalence_and_inequivalence_certificates_replay() {
    let left = fixture();
    let mut relabeled = left.clone();
    rotate(&mut relabeled, 3);
    let equivalent = compare(&left, &relabeled).expect("comparison");
    assert!(matches!(
        equivalent.result,
        EquivalenceOutcome::Equivalent { .. }
    ));
    assert!(
        verify_equivalence(&left, &relabeled, &equivalent)
            .expect("equivalence replays")
            .valid
    );

    let mut calibrated = left.clone();
    let ProfileInput::PaperIOrientation(paper) = &mut calibrated.profile else {
        unreachable!();
    };
    paper.calibrated_triangle = Some([0, 1, 2]);
    let inequivalent = compare(&left, &calibrated).expect("comparison");
    assert!(matches!(
        inequivalent.result,
        EquivalenceOutcome::Inequivalent { .. }
    ));
    assert!(
        verify_equivalence(&left, &calibrated, &inequivalent)
            .expect("inequivalence replays")
            .valid
    );
}

proptest! {
    #[test]
    fn canonical_identity_is_rotation_invariant(amount in 0u32..12) {
        let original = fixture();
        let expected = canonicalize(&original).expect("canonical fixture");
        let mut relabeled = original;
        rotate(&mut relabeled, amount);
        let actual = canonicalize(&relabeled).expect("canonical relabeling");
        prop_assert_eq!(actual.canonical_id, expected.canonical_id);
    }
}
