use std::path::PathBuf;

use sparse_shadow_core::InputArtifact;

#[test]
fn nauty_agrees_on_paper_v_marked_carrier() {
    let path = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join(
        "../../../papers/chordal-conference-reconstruction/verification/evidence/sparse_shadow_export.json",
    );
    if !path.exists() { return; }
    let input: InputArtifact = serde_json::from_slice(&std::fs::read(path).expect("read export"))
        .expect("parse export");
    let comparison = sparse_shadow_nauty::cross_check(&input).expect("nauty agrees");
    assert!(comparison.verified());
    assert_eq!(comparison.authoritative_backend, "native-paper-v-marked-conference-action/v1");
    assert_eq!(comparison.raw_input.automorphism_order, 1);
    assert_eq!(comparison.native_canonical_input.automorphism_order, 1);
    assert_eq!(comparison.raw_input.canonical_graph_blake3,
        "afd022821b810c620de384db96f2d1936ae0164ea8a6216c289c41647d7052d5");
    assert_eq!(comparison.raw_input.search_nodes, Some(6));
    assert_eq!(comparison.native_canonical_input.search_nodes, Some(6));
}
