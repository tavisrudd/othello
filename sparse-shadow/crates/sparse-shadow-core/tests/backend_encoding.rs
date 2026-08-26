use sparse_shadow_core::{
    BACKEND_GRAPH_SCHEMA_VERSION, BackendDescriptor, BackendObservation, ExternalBackendKind,
    InputArtifact, canonicalize, compare_external_backend, encode_colored_incidence,
    verify_backend_comparison,
};

const FIXTURE: &str = include_str!("../../../fixtures/paper-i-icosahedral-orbitals.json");
const CALIBRATED_FIXTURE: &str =
    include_str!("../../../fixtures/paper-i-calibrated-icosahedral-orbitals.json");

#[test]
fn paper_i_encoding_has_frozen_shape() {
    let input: InputArtifact = serde_json::from_str(FIXTURE).expect("fixture parses");
    let graph = encode_colored_incidence(&input).expect("fixture encodes");
    assert_eq!(graph.schema, BACKEND_GRAPH_SCHEMA_VERSION);
    assert_eq!(graph.colors.len(), 78);
    assert_eq!(graph.edges.len(), 132);
    assert_eq!(graph.original_vertex_nodes, (0..12).collect::<Vec<_>>());
    assert_eq!(
        graph
            .colors
            .iter()
            .copied()
            .collect::<std::collections::BTreeSet<_>>()
            .len(),
        4
    );
}

#[test]
fn paper_ii_encoding_has_frozen_shape() {
    let path = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join(
        "../../../papers/clebsch-factorization/verification/evidence/sparse_shadow_export.json",
    );
    if !path.exists() {
        return;
    }
    let input: InputArtifact =
        serde_json::from_slice(&std::fs::read(path).expect("read export")).expect("parse export");
    let graph = encode_colored_incidence(&input).expect("Paper-II export encodes");
    assert_eq!(graph.colors.len(), 166);
    assert_eq!(graph.edges.len(), 396);
    assert_eq!(graph.original_vertex_nodes, (0..12).collect::<Vec<_>>());
    assert_eq!(
        graph
            .colors
            .iter()
            .copied()
            .collect::<std::collections::BTreeSet<_>>(),
        std::collections::BTreeSet::from([0, 1, 2, 3])
    );
}

#[test]
fn calibration_is_a_distinct_original_vertex_color_class() {
    let input: InputArtifact = serde_json::from_str(CALIBRATED_FIXTURE).expect("fixture parses");
    let graph = encode_colored_incidence(&input).expect("fixture encodes");
    assert_eq!(graph.colors.len(), 78);
    assert_eq!(graph.edges.len(), 132);
    assert_eq!(
        graph.colors[..12]
            .iter()
            .filter(|&&color| color == 1)
            .count(),
        3
    );
    assert_eq!(
        graph
            .colors
            .iter()
            .copied()
            .collect::<std::collections::BTreeSet<_>>()
            .len(),
        5
    );
}

#[test]
fn encoding_round_trips_at_value_level() {
    let input: InputArtifact = serde_json::from_str(FIXTURE).expect("fixture parses");
    let graph = encode_colored_incidence(&input).expect("fixture encodes");
    let json = serde_json::to_string(&graph).expect("encoding serializes");
    assert_eq!(
        serde_json::from_str::<sparse_shadow_core::ColoredIncidenceGraph>(&json)
            .expect("encoding parses"),
        graph
    );
}

#[test]
fn comparison_wrapper_rejects_corruption() {
    let input: InputArtifact = serde_json::from_str(FIXTURE).expect("fixture parses");
    let native = canonicalize(&input).expect("fixture canonicalizes");
    let observation = BackendObservation {
        canonical_graph_blake3: "1".repeat(64),
        automorphism_order: 120,
        search_nodes: Some(10),
    };
    let comparison = compare_external_backend(
        &native,
        BackendDescriptor {
            kind: ExternalBackendKind::Nauty,
            engine_version: "test".into(),
            configuration: "test".into(),
        },
        observation.clone(),
        observation,
    )
    .expect("matching observation binds");
    verify_backend_comparison(&native, &comparison).expect("comparison verifies");

    let mut corrupted = comparison;
    corrupted.automorphism_order_agrees = false;
    assert!(verify_backend_comparison(&native, &corrupted).is_err());
}
