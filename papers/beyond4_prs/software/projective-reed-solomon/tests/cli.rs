use serde_json::Value;
use std::io::Write;
use std::process::{Command, Output, Stdio};
use tempfile::NamedTempFile;

const REQUEST: &str = include_str!("../examples/tangent-r5-f7.json");
const SHALLOW_REQUEST: &str = include_str!("../examples/shallow-r5-f7.json");

const OUTSIDE_THEOREM_DOMAIN_REQUEST: &str = r#"{
  "schema": "projective-reed-solomon-request-v1",
  "field": {
    "p": 11,
    "degree": 1,
    "modulus": [0, 1],
    "encoding": "polynomial-basis-base-p-integer-v1"
  },
  "redundancy": 11,
  "evaluation": "full-projective-nrc-v1",
  "syndrome": [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0]
}"#;

fn binary() -> Command {
    Command::new(env!("CARGO_BIN_EXE_projective-reed-solomon"))
}

fn run_with_stdin(arguments: &[&str], input: &str) -> Output {
    let mut child = binary()
        .args(arguments)
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .expect("CLI must start");
    child
        .stdin
        .take()
        .expect("piped stdin")
        .write_all(input.as_bytes())
        .expect("request must be written");
    child.wait_with_output().expect("CLI must finish")
}

#[test]
fn help_exposes_the_mathematical_commands() {
    let output = binary().arg("--help").output().expect("help must run");
    assert!(output.status.success());
    let help = String::from_utf8(output.stdout).expect("help must be UTF-8");
    for command in ["canonicalize", "distance", "decode", "classify", "verify"] {
        assert!(help.contains(command), "missing command {command}");
    }
    assert!(help.contains("Start here:"));
    assert!(help.contains("Positive deep-hole verdicts remain fail-closed"));
}

#[test]
fn classify_then_verify_replays_a_positive_certificate() {
    let classification = run_with_stdin(&["--compact", "classify"], REQUEST);
    assert!(
        classification.status.success(),
        "classification failed: {}",
        String::from_utf8_lossy(&classification.stderr)
    );
    let value: Value = serde_json::from_slice(&classification.stdout).expect("classification JSON");
    assert_eq!(value["schema"], "projective-reed-solomon-classification-v1");
    assert_eq!(value["status"], "DEEP");
    let certificate =
        serde_json::to_string(&value["deep_certificate"]).expect("certificate must serialize");
    assert_eq!(
        value["deep_certificate"]["schema"],
        "projective-reed-solomon-deep-certificate-v1"
    );

    let verification = run_with_stdin(&["--compact", "verify"], &certificate);
    assert!(
        verification.status.success(),
        "verification failed: {}",
        String::from_utf8_lossy(&verification.stderr)
    );
    let verified: Value = serde_json::from_slice(&verification.stdout).expect("verification JSON");
    assert_eq!(
        verified["schema"],
        "projective-reed-solomon-verification-v1"
    );
    assert_eq!(verified["status"], "VALID");
}

#[test]
fn verify_rejects_a_corrupted_positive_certificate() {
    let classification = run_with_stdin(&["--compact", "classify"], REQUEST);
    assert!(classification.status.success());
    let value: Value = serde_json::from_slice(&classification.stdout).expect("classification JSON");
    let mut certificate = value["deep_certificate"].clone();
    certificate["family"] = Value::String("corrupted-family".into());

    let verification = run_with_stdin(
        &["--compact", "verify"],
        &serde_json::to_string(&certificate).expect("certificate must serialize"),
    );
    assert!(!verification.status.success());
    assert_eq!(verification.status.code(), Some(2));
    assert!(verification.stdout.is_empty());
    assert!(
        String::from_utf8_lossy(&verification.stderr)
            .contains("positive deep certificate failed independent replay"),
        "unexpected rejection: {}",
        String::from_utf8_lossy(&verification.stderr)
    );
}

#[test]
fn canonicalize_accepts_a_json_file() {
    let mut request_file = NamedTempFile::new().expect("temporary request file");
    request_file
        .write_all(REQUEST.as_bytes())
        .expect("request must be written");
    let output = binary()
        .args(["-c", "canonicalize"])
        .arg(request_file.path())
        .output()
        .expect("canonicalize must run");
    assert!(
        output.status.success(),
        "canonicalization failed: {}",
        String::from_utf8_lossy(&output.stderr)
    );
    let value: Value = serde_json::from_slice(&output.stdout).expect("canonicalization JSON");
    assert_eq!(
        value["schema"],
        "projective-reed-solomon-canonicalization-v1"
    );
    assert_eq!(
        value["canonical_syndrome"].as_array().map(Vec::len),
        Some(5)
    );
    assert!(value["transporter"].is_object());
}

#[test]
fn distance_and_decode_emit_the_same_replayable_locator_certificate() {
    let distance = run_with_stdin(&["--compact", "distance"], SHALLOW_REQUEST);
    let decode = run_with_stdin(&["--compact", "decode"], SHALLOW_REQUEST);
    assert!(distance.status.success());
    assert!(decode.status.success());
    let distance_value: Value =
        serde_json::from_slice(&distance.stdout).expect("distance certificate JSON");
    let decode_value: Value =
        serde_json::from_slice(&decode.stdout).expect("decode certificate JSON");
    assert_eq!(distance_value, decode_value);
    assert_eq!(distance_value["distance"], 1);
    assert_eq!(
        distance_value["schema"],
        "projective-reed-solomon-locator-certificate-v1"
    );

    let verification = run_with_stdin(
        &["verify-certificate"],
        &serde_json::to_string(&distance_value).expect("certificate must serialize"),
    );
    assert!(verification.status.success());
    assert!(verification.stdout.starts_with(b"{\n"));
}

#[test]
fn classify_fails_closed_when_the_candidate_budget_is_exhausted() {
    let output = run_with_stdin(&["--limit", "0", "--compact", "classify"], REQUEST);
    assert!(!output.status.success());
    assert_eq!(output.status.code(), Some(2));
    assert!(output.stdout.is_empty());
    assert!(
        String::from_utf8_lossy(&output.stderr).contains("candidate limit 0 exceeded"),
        "unexpected failure: {}",
        String::from_utf8_lossy(&output.stderr)
    );
}

#[test]
fn classify_rejects_requests_beyond_the_theorem_domain() {
    let output = run_with_stdin(&["--compact", "classify"], OUTSIDE_THEOREM_DOMAIN_REQUEST);
    assert!(!output.status.success());
    assert_eq!(output.status.code(), Some(2));
    assert!(output.stdout.is_empty());
    assert!(
        String::from_utf8_lossy(&output.stderr).contains("redundancy must lie in 5..=10"),
        "unexpected rejection: {}",
        String::from_utf8_lossy(&output.stderr)
    );
}
