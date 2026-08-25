use std::collections::BTreeSet;

use proptest::prelude::*;
use sparse_shadow_core::{
    Ambiguity, CanonicalCertificate, EquivalenceOutcome, InputArtifact, ProfileInput,
    ReconstructionArtifact, ShadowError, canonicalize, compare, reconstruct, validate,
    verify_canonical_artifact, verify_certificate, verify_equivalence, verify_reconstruction,
};

const FIXTURE: &str = include_str!("../../../fixtures/paper-i-icosahedral-orbitals.json");
const CALIBRATED_FIXTURE: &str =
    include_str!("../../../fixtures/paper-i-calibrated-icosahedral-orbitals.json");
const GOLDEN_CONTRACT: &str = include_str!("../../../fixtures/paper-i-golden-contract.json");
const PACKAGED_FIXTURE: &str = include_str!("../testdata/paper-i-icosahedral-orbitals.json");

fn fixture() -> InputArtifact {
    serde_json::from_str(FIXTURE).expect("committed fixture parses")
}

#[test]
fn packaged_unit_test_fixture_matches_the_public_fixture() {
    let packaged: InputArtifact =
        serde_json::from_str(PACKAGED_FIXTURE).expect("packaged fixture parses");
    assert_eq!(packaged, fixture());
}

fn calibrated_fixture() -> InputArtifact {
    serde_json::from_str(CALIBRATED_FIXTURE).expect("committed calibrated fixture parses")
}

fn contract_view(artifact: &sparse_shadow_core::CanonicalArtifact) -> serde_json::Value {
    serde_json::json!({
        "schema": artifact.schema,
        "canonical_id": artifact.canonical_id,
        "automorphism_order": artifact.automorphism_order,
        "automorphism_generator_count": artifact.automorphism_generators.len(),
        "vertex_orbits": artifact.vertex_orbits,
        "point_stabilizers": artifact.point_stabilizers.iter().map(|stabilizer| {
            serde_json::json!({
                "fixed_vertex": stabilizer.fixed_vertex,
                "automorphism_order": stabilizer.automorphism_order,
                "automorphism_generator_count": stabilizer.automorphism_generators.len(),
            })
        }).collect::<Vec<_>>(),
        "stats": artifact.stats,
        "certificate_schema": artifact.certificate.certificate_schema,
        "proof_system": artifact.certificate.proof_system,
    })
}

fn reconstruction_contract_view(artifact: &ReconstructionArtifact) -> serde_json::Value {
    let killed_by_calibration = match &artifact.ambiguity {
        Ambiguity::OrientationC2 {
            killed_by_calibration,
        } => *killed_by_calibration,
    };
    serde_json::json!({
        "schema": artifact.schema,
        "carrier_schema": artifact.carrier.schema,
        "axes": artifact.carrier.axes,
        "conference_switching_class": artifact.carrier.conference_switching_class,
        "killed_by_calibration": killed_by_calibration,
        "exact_oriented_return": artifact.exact_oriented_return,
    })
}

fn relabel(input: &mut InputArtifact, permutation: &[u32]) {
    let ProfileInput::PaperIOrientation(paper) = &mut input.profile else {
        unreachable!();
    };
    let mut vertices = paper.shadow.vertices.clone();
    for (old, value) in paper.shadow.vertices.iter().enumerate() {
        vertices[permutation[old] as usize] = value.clone();
    }
    paper.shadow.vertices = vertices;
    for relation in &mut paper.shadow.relations {
        for edge in &mut relation.edges {
            edge[0] = permutation[edge[0] as usize];
            edge[1] = permutation[edge[1] as usize];
            if !relation.directed && edge[0] > edge[1] {
                edge.swap(0, 1);
            }
        }
        relation.edges.sort_unstable();
    }
    if let Some(triangle) = &mut paper.calibrated_triangle {
        *triangle = triangle.map(|vertex| permutation[vertex as usize]);
        triangle.sort_unstable();
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
    assert_eq!(artifact.point_stabilizers.len(), 1);
    assert_eq!(artifact.point_stabilizers[0].fixed_vertex, 0);
    assert_eq!(artifact.point_stabilizers[0].automorphism_order, 10);
    assert_eq!(artifact.point_stabilizers[0].vertex_orbits[0], vec![0]);
}

#[test]
fn committed_golden_contract_is_stable() {
    let expected: serde_json::Value =
        serde_json::from_str(GOLDEN_CONTRACT).expect("golden contract parses");
    assert_eq!(
        expected["contract_schema"],
        "sparse-shadow-paper-i-golden/v1"
    );
    assert_eq!(
        contract_view(&canonicalize(&fixture()).expect("uncalibrated canonical fixture")),
        expected["uncalibrated"]
    );
    assert_eq!(
        contract_view(&canonicalize(&calibrated_fixture()).expect("calibrated canonical fixture")),
        expected["calibrated"]
    );
    assert_eq!(
        reconstruction_contract_view(
            &reconstruct(&fixture()).expect("uncalibrated reconstruction")
        ),
        expected["reconstruction"]["uncalibrated"]
    );
    assert_eq!(
        reconstruction_contract_view(
            &reconstruct(&calibrated_fixture()).expect("calibrated reconstruction")
        ),
        expected["reconstruction"]["calibrated"]
    );
}

#[test]
fn canonicalization_is_idempotent() {
    let first = canonicalize(&fixture()).expect("canonical fixture");
    let second = canonicalize(&first.canonical).expect("canonical form canonicalizes");
    assert_eq!(second.canonical_id, first.canonical_id);
    assert_eq!(second.canonical, first.canonical);
}

#[test]
fn expanded_canonical_wrapper_requires_v2() {
    let input = fixture();
    let mut artifact = canonicalize(&input).expect("canonical fixture");
    artifact.schema = "sparse-shadow-canonical/v1".into();
    assert!(verify_canonical_artifact(&input, &artifact).is_err());
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

    let mut corrupt_exhaustion = canonicalize(&input).expect("canonical fixture").certificate;
    corrupt_exhaustion.search_stats.search_nodes += 1;
    assert!(verify_certificate(&input, &corrupt_exhaustion).is_err());
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
fn schema_and_normalization_boundaries_reject_malformed_inputs() {
    let mut unknown: serde_json::Value = serde_json::from_str(FIXTURE).expect("fixture JSON");
    unknown["unexpected"] = serde_json::Value::Bool(true);
    assert!(serde_json::from_value::<InputArtifact>(unknown).is_err());

    let mut unknown_profile: serde_json::Value =
        serde_json::from_str(FIXTURE).expect("fixture JSON");
    unknown_profile["profile"]["unexpected"] = serde_json::Value::Bool(true);
    assert!(serde_json::from_value::<InputArtifact>(unknown_profile).is_err());

    let mut wrong_version = fixture();
    wrong_version.schema = "sparse-shadow/v2".into();
    assert!(matches!(
        validate(&wrong_version),
        Err(ShadowError::SchemaVersion { .. })
    ));

    let mut non_normal_edge = fixture();
    let ProfileInput::PaperIOrientation(paper) = &mut non_normal_edge.profile else {
        unreachable!();
    };
    paper.shadow.relations[0].edges[0] = [1, 0];
    assert!(validate(&non_normal_edge).is_err());

    let mut duplicate_calibration = fixture();
    let ProfileInput::PaperIOrientation(paper) = &mut duplicate_calibration.profile else {
        unreachable!();
    };
    paper.calibrated_triangle = Some([0, 0, 1]);
    assert!(validate(&duplicate_calibration).is_err());

    let mut non_normal_calibration = fixture();
    let ProfileInput::PaperIOrientation(paper) = &mut non_normal_calibration.profile else {
        unreachable!();
    };
    paper.calibrated_triangle = Some([2, 1, 0]);
    assert!(validate(&non_normal_calibration).is_err());

    let mut non_triangle_calibration = fixture();
    let ProfileInput::PaperIOrientation(paper) = &mut non_triangle_calibration.profile else {
        unreachable!();
    };
    paper.calibrated_triangle = Some([0, 1, 11]);
    assert!(validate(&non_triangle_calibration).is_err());
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
fn uncalibrated_orbital_exchange_realizes_the_orientation_involution() {
    let left = fixture();
    let mut exchanged = left.clone();
    let ProfileInput::PaperIOrientation(paper) = &mut exchanged.profile else {
        unreachable!();
    };
    let (positive, negative) = paper.shadow.relations.split_at_mut(1);
    std::mem::swap(&mut positive[0].edges, &mut negative[0].edges);

    let certificate = compare(&left, &exchanged).expect("orbital exchange compares");
    assert!(matches!(
        certificate.result,
        EquivalenceOutcome::Equivalent { .. }
    ));
    assert!(
        verify_equivalence(&left, &exchanged, &certificate)
            .expect("orbital exchange replays")
            .valid
    );
}

#[test]
fn reconstruction_reports_unoriented_c2_fibre() {
    let reconstructed = reconstruct(&fixture()).expect("reconstruction");
    assert!(!reconstructed.exact_oriented_return);
    assert_eq!(reconstructed.carrier.axes.len(), 6);
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
    corrupt.carrier.axes.pop();
    assert!(verify_reconstruction(&fixture(), &corrupt).is_err());

    let mut corrupt_wrapper = reconstruct(&fixture()).expect("reconstruction");
    corrupt_wrapper.canonical.automorphism_order -= 1;
    assert!(verify_reconstruction(&fixture(), &corrupt_wrapper).is_err());

    let mut corrupt_generators = reconstruct(&fixture()).expect("reconstruction");
    corrupt_generators.canonical.automorphism_generators.clear();
    assert!(verify_reconstruction(&fixture(), &corrupt_generators).is_err());

    let mut corrupt_orbits = reconstruct(&fixture()).expect("reconstruction");
    corrupt_orbits.canonical.vertex_orbits.clear();
    assert!(verify_reconstruction(&fixture(), &corrupt_orbits).is_err());

    let mut corrupt_stabilizers = reconstruct(&fixture()).expect("reconstruction");
    corrupt_stabilizers.canonical.point_stabilizers.clear();
    assert!(verify_reconstruction(&fixture(), &corrupt_stabilizers).is_err());
}

#[test]
fn calibrated_reconstruction_is_an_exact_oriented_return() {
    let input = calibrated_fixture();
    let reconstructed = reconstruct(&input).expect("calibrated reconstruction");
    assert!(reconstructed.exact_oriented_return);
    assert!(
        verify_reconstruction(&input, &reconstructed)
            .expect("calibrated reconstruction replays")
            .valid
    );
}

#[test]
fn tagged_certificate_variants_reject_unknown_fields() {
    let input = fixture();
    let mut reconstruction =
        serde_json::to_value(reconstruct(&input).expect("reconstruction")).expect("artifact JSON");
    reconstruction["ambiguity"]["unexpected"] = serde_json::Value::Bool(true);
    assert!(serde_json::from_value::<ReconstructionArtifact>(reconstruction).is_err());

    let mut equivalence =
        serde_json::to_value(compare(&input, &input).expect("equivalence")).expect("artifact JSON");
    equivalence["result"]["unexpected"] = serde_json::Value::Bool(true);
    assert!(
        serde_json::from_value::<sparse_shadow_core::EquivalenceCertificate>(equivalence).is_err()
    );
}

#[test]
fn all_calibrated_triangles_form_one_exhaustive_orbit() {
    let mut accepted = Vec::new();
    let mut canonical_ids = BTreeSet::new();
    let mut canonical_payloads = BTreeSet::new();
    for left in 0..12 {
        for middle in (left + 1)..12 {
            for right in (middle + 1)..12 {
                let mut input = fixture();
                let ProfileInput::PaperIOrientation(paper) = &mut input.profile else {
                    unreachable!();
                };
                paper.calibrated_triangle = Some([left, middle, right]);
                if validate(&input).is_ok() {
                    let artifact = canonicalize(&input).expect("admitted triangle canonicalizes");
                    assert_eq!(artifact.automorphism_order, 6);
                    canonical_ids.insert(artifact.canonical_id);
                    canonical_payloads.insert(artifact.certificate.canonical_json);
                    accepted.push(input);
                }
            }
        }
    }

    assert_eq!(accepted.len(), 20);
    assert_eq!(canonical_ids.len(), 1);
    assert_eq!(canonical_payloads.len(), 1);
    assert_eq!(
        canonical_ids.into_iter().next().expect("one orbit"),
        "00d68674bd6417ba1233fa80c7221469474d8139dfdf9d37cdf5b59e06717a4d"
    );

    let representative = &accepted[0];
    for input in &accepted[1..] {
        let certificate = compare(representative, input).expect("triangle orbit comparison");
        assert!(matches!(
            certificate.result,
            EquivalenceOutcome::Equivalent { .. }
        ));
        assert!(
            verify_equivalence(representative, input, &certificate)
                .expect("triangle orbit transporter replays")
                .valid
        );
    }
}

#[test]
fn equivalence_and_inequivalence_certificates_replay() {
    let left = fixture();
    let mut relabeled = left.clone();
    relabel(&mut relabeled, &[3, 8, 1, 10, 5, 0, 11, 4, 9, 2, 7, 6]);
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
    let mut corrupt_equivalent = equivalent;
    let EquivalenceOutcome::Equivalent { left_to_right } = &mut corrupt_equivalent.result else {
        unreachable!();
    };
    left_to_right[0] = left_to_right[1];
    assert!(verify_equivalence(&left, &relabeled, &corrupt_equivalent).is_err());

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
    let mut corrupt_inequivalent = inequivalent;
    let EquivalenceOutcome::Inequivalent {
        separating_invariant,
    } = &mut corrupt_inequivalent.result
    else {
        unreachable!();
    };
    separating_invariant.right_value = separating_invariant.left_value.clone();
    assert!(verify_equivalence(&left, &calibrated, &corrupt_inequivalent).is_err());
}

proptest! {
    #[test]
    fn canonical_identity_is_arbitrary_relabeling_invariant(
        swaps in prop::collection::vec(0usize..12, 0..48)
    ) {
        let mut permutation: Vec<u32> = (0..12).collect();
        for (step, &other) in swaps.iter().enumerate() {
            permutation.swap(step % 12, other);
        }

        for original in [fixture(), calibrated_fixture()] {
            let expected = canonicalize(&original).expect("canonical fixture");
            let mut relabeled = original;
            relabel(&mut relabeled, &permutation);
            let actual = canonicalize(&relabeled).expect("canonical relabeling");
            prop_assert_eq!(actual.canonical_id, expected.canonical_id);
        }
    }
}
