use sparse_shadow_core::InputArtifact;

const FIXTURE: &str = include_str!("../../../fixtures/paper-i-icosahedral-orbitals.json");
const CALIBRATED_FIXTURE: &str =
    include_str!("../../../fixtures/paper-i-calibrated-icosahedral-orbitals.json");

#[test]
fn nauty_agrees_on_uncalibrated_paper_i() {
    let input: InputArtifact = serde_json::from_str(FIXTURE).expect("fixture parses");
    let comparison = sparse_shadow_nauty::cross_check(&input).expect("nauty agrees");
    assert!(comparison.verified());
    assert_eq!(comparison.raw_input.automorphism_order, 120);
    assert_eq!(comparison.native_canonical_input.automorphism_order, 120);
    assert_eq!(
        comparison.raw_input.canonical_graph_blake3,
        "2cf605b58b05803cb3961f3484cf5879197f930122a687c7786d60a8f96d3126"
    );
    assert_eq!(comparison.raw_input.search_nodes, Some(10));
    assert_eq!(comparison.native_canonical_input.search_nodes, Some(13));
}

#[test]
fn nauty_agrees_on_calibrated_paper_i() {
    let input: InputArtifact = serde_json::from_str(CALIBRATED_FIXTURE).expect("fixture parses");
    let comparison = sparse_shadow_nauty::cross_check(&input).expect("nauty agrees");
    assert!(comparison.verified());
    assert_eq!(comparison.raw_input.automorphism_order, 6);
    assert_eq!(comparison.native_canonical_input.automorphism_order, 6);
    assert_eq!(
        comparison.raw_input.canonical_graph_blake3,
        "d8e51ea31ce085c519cd40b98ab187474dc1786952267ef52e3094646cae59e2"
    );
    assert_eq!(comparison.raw_input.search_nodes, Some(6));
    assert_eq!(comparison.native_canonical_input.search_nodes, Some(6));
}
