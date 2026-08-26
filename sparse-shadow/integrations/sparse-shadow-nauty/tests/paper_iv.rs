use std::path::PathBuf;

use sparse_shadow_core::InputArtifact;

#[test]
fn nauty_agrees_on_paper_iv_weighted_scheme() {
    let path = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("../../../papers/q13-passant-code/verification/sparse_shadow_export.json");
    if !path.exists() {
        return;
    }
    let input: InputArtifact = serde_json::from_slice(&std::fs::read(path).expect("read export"))
        .expect("parse export");
    let comparison = sparse_shadow_nauty::cross_check(&input).expect("nauty agrees");
    assert!(comparison.verified());
    assert_eq!(
        comparison.authoritative_backend,
        "native-paper-iv-weighted-scheme-ir/v1"
    );
    assert_eq!(comparison.raw_input.automorphism_order, 2184);
    assert_eq!(comparison.native_canonical_input.automorphism_order, 2184);
    assert_eq!(
        comparison.raw_input.canonical_graph_blake3,
        "6b1b49c68cab6b85b34a536796895baec11863fb643eb9b25397bfa2c4780c15"
    );
    assert_eq!(comparison.raw_input.search_nodes, Some(12));
    assert_eq!(comparison.native_canonical_input.search_nodes, Some(12));
}
