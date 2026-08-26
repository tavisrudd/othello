use std::path::PathBuf;

use sparse_shadow_core::InputArtifact;

#[test]
fn nauty_agrees_on_paper_ii_oriented_trade() {
    let path = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join(
        "../../../papers/clebsch-factorization/verification/evidence/sparse_shadow_export.json",
    );
    if !path.exists() { return; }
    let input: InputArtifact = serde_json::from_slice(&std::fs::read(path).expect("read export"))
        .expect("parse export");
    let comparison = sparse_shadow_nauty::cross_check(&input).expect("nauty agrees");
    assert!(comparison.verified());
    assert_eq!(comparison.authoritative_backend, "native-paper-ii-declared-action/v1");
    assert_eq!(comparison.raw_input.automorphism_order, 660);
    assert_eq!(comparison.native_canonical_input.automorphism_order, 660);
    assert_eq!(comparison.raw_input.canonical_graph_blake3,
        "286566ef3ad75aae814d2b5d0d0ea9fee6902877f500d2b28548d531ef602fa0");
    assert_eq!(comparison.raw_input.search_nodes, Some(11));
    assert_eq!(comparison.native_canonical_input.search_nodes, Some(13));
}
