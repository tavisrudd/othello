use std::{path::PathBuf, process::Command};

fn fixture(name: &str) -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("../../fixtures")
        .join(name)
}

fn run(args: &[&str]) -> std::process::Output {
    Command::new(env!("CARGO_BIN_EXE_sparse-shadow"))
        .args(args)
        .output()
        .expect("CLI starts")
}

#[test]
fn validate_accepts_paper_i() {
    let input = fixture("paper-i-icosahedral-orbitals.json");
    let output = run(&["validate", input.to_str().expect("UTF-8 fixture path")]);
    assert!(output.status.success());
    assert!(String::from_utf8_lossy(&output.stdout).contains("\"valid\": true"));
}

#[test]
fn gated_profile_fails_closed_with_required_export() {
    let input = fixture("gated-paper-ii-trade.json");
    let output = run(&["validate", input.to_str().expect("UTF-8 fixture path")]);
    assert!(!output.status.success());
    let stderr = String::from_utf8_lossy(&output.stderr);
    assert!(stderr.contains("schema-only"));
    assert!(
        stderr.contains(
            "papers/clebsch-factorization/verification/evidence/sparse_shadow_export.json"
        )
    );
}

#[test]
fn canonicalize_is_byte_deterministic() {
    let input = fixture("paper-i-icosahedral-orbitals.json");
    let path = input.to_str().expect("UTF-8 fixture path");
    let first = run(&["canonicalize", path]);
    let second = run(&["canonicalize", path]);
    assert!(first.status.success());
    assert!(second.status.success());
    assert_eq!(first.stdout, second.stdout);
}

#[test]
fn equivalent_accepts_identical_inputs() {
    let input = fixture("paper-i-icosahedral-orbitals.json");
    let path = input.to_str().expect("UTF-8 fixture path");
    let output = run(&["equivalent", path, path]);
    assert!(output.status.success());
    assert!(String::from_utf8_lossy(&output.stdout).contains("equivalent"));
}
