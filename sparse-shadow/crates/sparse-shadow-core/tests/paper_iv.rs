use std::path::PathBuf;

use sparse_shadow_core::{InputArtifact, ShadowError, validate};

fn export_path() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("../../../../papers/q13-passant-code/verification/sparse_shadow_export.json")
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
