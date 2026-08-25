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
        let fixture_value: serde_json::Value =
            serde_json::from_str(fixture).expect("gated fixture JSON parses");
        let artifact: InputArtifact =
            serde_json::from_value(fixture_value.clone()).expect("gated fixture parses");
        assert_eq!(
            serde_json::to_value(&artifact).expect("gated fixture serializes"),
            fixture_value
        );
        assert!(matches!(
            validate(&artifact),
            Err(ShadowError::ProfileGated { .. })
        ));
    }
}

#[test]
fn tagged_gated_action_and_ambiguity_reject_unknown_fields() {
    let mut action: serde_json::Value =
        serde_json::from_str(GATED[0]).expect("gated fixture JSON parses");
    action["profile"]["input"]["action"]["unexpected"] = serde_json::Value::Bool(true);
    assert!(serde_json::from_value::<InputArtifact>(action).is_err());

    let mut ambiguity: serde_json::Value =
        serde_json::from_str(GATED[0]).expect("gated fixture JSON parses");
    ambiguity["profile"]["input"]["ambiguity"]["unexpected"] = serde_json::Value::Bool(true);
    assert!(serde_json::from_value::<InputArtifact>(ambiguity).is_err());

    let mut field: serde_json::Value =
        serde_json::from_str(GATED[3]).expect("gated fixture JSON parses");
    field["profile"]["input"]["base_field"]["unexpected"] = serde_json::Value::Bool(true);
    assert!(serde_json::from_value::<InputArtifact>(field).is_err());
}
