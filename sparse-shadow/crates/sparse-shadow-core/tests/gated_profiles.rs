use sparse_shadow_core::{InputArtifact, ShadowError, validate};

const GATED: [&str; 4] = [
    include_str!("../../../fixtures/gated-paper-ii-trade.json"),
    include_str!("../../../fixtures/gated-paper-iii-four-shadow.json"),
    include_str!("../../../fixtures/gated-paper-iv-minimum-words.json"),
    include_str!("../../../fixtures/gated-paper-v-chordal-conference.json"),
];

#[test]
fn disabled_profiles_are_typed_and_fail_closed() {
    for fixture in GATED {
        let artifact: InputArtifact = serde_json::from_str(fixture).expect("gated fixture parses");
        assert!(matches!(
            validate(&artifact),
            Err(ShadowError::ProfileGated { .. })
        ));
    }
}
