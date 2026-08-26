use std::{
    fs,
    path::PathBuf,
    process::Command,
    sync::atomic::{AtomicU64, Ordering},
};

static TEMP_SEQUENCE: AtomicU64 = AtomicU64::new(0);
const GOLDEN_CONTRACT: &str = include_str!("../../../fixtures/paper-i-golden-contract.json");
const PAPER_IV_GOLDEN_CONTRACT: &str =
    include_str!("../../../fixtures/paper-iv-golden-contract.json");

fn fixture(name: &str) -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("../../fixtures")
        .join(name)
}

fn paper_iv_export() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("../../../papers/q13-passant-code/verification/sparse_shadow_export.json")
}

fn paper_ii_export() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR")).join(
        "../../../papers/clebsch-factorization/verification/evidence/sparse_shadow_export.json",
    )
}

fn paper_v_export() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR")).join(
        "../../../papers/chordal-conference-reconstruction/verification/evidence/sparse_shadow_export.json",
    )
}

#[test]
fn paper_v_cli_canonical_and_reconstruction_artifacts_replay() {
    let input = paper_v_export();
    if !input.exists() {
        return;
    }
    let input_path = input.to_str().expect("UTF-8 export path");
    let canonical = run(&["canonicalize", input_path]);
    assert!(
        canonical.status.success(),
        "{}",
        String::from_utf8_lossy(&canonical.stderr)
    );
    let canonical_path = write_temp_json("paper-v-canonical", &canonical.stdout);
    assert_valid(&run(&[
        "verify-certificate",
        input_path,
        canonical_path.to_str().expect("UTF-8 temp path"),
    ]));
    fs::remove_file(canonical_path).expect("temporary canonical artifact removes");
    let reconstruction = run(&["reconstruct", input_path]);
    assert!(
        reconstruction.status.success(),
        "{}",
        String::from_utf8_lossy(&reconstruction.stderr)
    );
    let reconstruction_path = write_temp_json("paper-v-reconstruction", &reconstruction.stdout);
    assert_valid(&run(&[
        "verify-reconstruction-certificate",
        input_path,
        reconstruction_path.to_str().expect("UTF-8 temp path"),
    ]));
    fs::remove_file(reconstruction_path).expect("temporary reconstruction removes");
}

#[test]
fn paper_ii_cli_canonical_and_reconstruction_artifacts_replay() {
    let input = paper_ii_export();
    if !input.exists() {
        return;
    }
    let input_path = input.to_str().expect("UTF-8 export path");
    let canonical = run(&["canonicalize", input_path]);
    assert!(
        canonical.status.success(),
        "{}",
        String::from_utf8_lossy(&canonical.stderr)
    );
    let canonical_path = write_temp_json("paper-ii-canonical", &canonical.stdout);
    assert_valid(&run(&[
        "verify-certificate",
        input_path,
        canonical_path.to_str().expect("UTF-8 temp path"),
    ]));
    fs::remove_file(canonical_path).expect("temporary canonical artifact removes");

    let reconstruction = run(&["reconstruct", input_path]);
    assert!(
        reconstruction.status.success(),
        "{}",
        String::from_utf8_lossy(&reconstruction.stderr)
    );
    let reconstruction_path = write_temp_json("paper-ii-reconstruction", &reconstruction.stdout);
    assert_valid(&run(&[
        "verify-reconstruction-certificate",
        input_path,
        reconstruction_path.to_str().expect("UTF-8 temp path"),
    ]));
    fs::remove_file(reconstruction_path).expect("temporary reconstruction removes");
}

fn run(args: &[&str]) -> std::process::Output {
    Command::new(env!("CARGO_BIN_EXE_sparse-shadow"))
        .args(args)
        .output()
        .expect("CLI starts")
}

fn write_temp_json(label: &str, bytes: &[u8]) -> PathBuf {
    let sequence = TEMP_SEQUENCE.fetch_add(1, Ordering::Relaxed);
    let path = std::env::temp_dir().join(format!(
        "sparse-shadow-{label}-{}-{sequence}.json",
        std::process::id()
    ));
    fs::write(&path, bytes).expect("temporary certificate writes");
    path
}

fn assert_valid(output: &std::process::Output) {
    assert!(
        output.status.success(),
        "{}",
        String::from_utf8_lossy(&output.stderr)
    );
    assert!(String::from_utf8_lossy(&output.stdout).contains("\"valid\": true"));
}

fn assert_certificate_failure(output: &std::process::Output) {
    assert!(!output.status.success());
    assert!(String::from_utf8_lossy(&output.stderr).contains("certificate mismatch"));
}

fn digest(bytes: &[u8]) -> String {
    blake3::hash(bytes).to_hex().to_string()
}

#[test]
fn validate_accepts_paper_i() {
    let input = fixture("paper-i-icosahedral-orbitals.json");
    let output = run(&["validate", input.to_str().expect("UTF-8 fixture path")]);
    assert!(output.status.success());
    assert!(String::from_utf8_lossy(&output.stdout).contains("\"valid\": true"));
}

#[test]
fn every_gated_profile_fails_closed_with_its_required_export() {
    let gates = [
        (
            "gated-paper-ii-trade.json",
            "papers/clebsch-factorization/verification/evidence/sparse_shadow_export.json",
        ),
        (
            "gated-paper-iii-four-shadow.json",
            "papers/clebsch-passages/verification/sparse_shadow_export.json",
        ),
        (
            "gated-paper-iv-minimum-words.json",
            "papers/q13-passant-code/verification/sparse_shadow_export.json",
        ),
        (
            "gated-paper-v-chordal-conference.json",
            "papers/chordal-conference-reconstruction/verification/evidence/sparse_shadow_export.json",
        ),
    ];

    for (fixture_name, required_export) in gates {
        let input = fixture(fixture_name);
        let output = run(&["validate", input.to_str().expect("UTF-8 fixture path")]);
        assert!(
            !output.status.success(),
            "{fixture_name} unexpectedly passed"
        );
        let stderr = String::from_utf8_lossy(&output.stderr);
        assert!(stderr.contains("schema-only"), "{fixture_name}: {stderr}");
        assert!(stderr.contains(required_export), "{fixture_name}: {stderr}");
    }
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
fn cli_stdout_matches_cross_build_golden_digests() {
    let input = fixture("paper-i-icosahedral-orbitals.json");
    let calibrated = fixture("paper-i-calibrated-icosahedral-orbitals.json");
    let input_path = input.to_str().expect("UTF-8 fixture path");
    let calibrated_path = calibrated.to_str().expect("UTF-8 fixture path");
    let commands: [(&str, std::process::Output); 6] = [
        ("validate", run(&["validate", input_path])),
        ("canonicalize", run(&["canonicalize", input_path])),
        (
            "canonicalize_calibrated",
            run(&["canonicalize", calibrated_path]),
        ),
        ("reconstruct", run(&["reconstruct", input_path])),
        (
            "reconstruct_calibrated",
            run(&["reconstruct", calibrated_path]),
        ),
        (
            "equivalent_identical",
            run(&["equivalent", input_path, input_path]),
        ),
    ];
    let actual: serde_json::Map<String, serde_json::Value> = commands
        .into_iter()
        .map(|(name, output)| {
            assert!(output.status.success(), "{name}");
            (
                name.into(),
                serde_json::Value::String(digest(&output.stdout)),
            )
        })
        .collect();
    let expected: serde_json::Value =
        serde_json::from_str(GOLDEN_CONTRACT).expect("golden contract parses");
    assert_eq!(
        serde_json::Value::Object(actual),
        expected["cli_stdout_blake3"]
    );
}

#[test]
fn equivalent_accepts_identical_inputs() {
    let input = fixture("paper-i-icosahedral-orbitals.json");
    let path = input.to_str().expect("UTF-8 fixture path");
    let output = run(&["equivalent", path, path]);
    assert!(output.status.success());
    assert!(String::from_utf8_lossy(&output.stdout).contains("equivalent"));
}

#[test]
fn every_emitted_certificate_replays_through_the_cli() {
    let input = fixture("paper-i-icosahedral-orbitals.json");
    let calibrated = fixture("paper-i-calibrated-icosahedral-orbitals.json");
    let input_path = input.to_str().expect("UTF-8 fixture path");
    let calibrated_path = calibrated.to_str().expect("UTF-8 fixture path");

    let canonical = run(&["canonicalize", input_path]);
    assert!(canonical.status.success());
    let certificate_path = write_temp_json("canonical-artifact", &canonical.stdout);
    let verified = run(&[
        "verify-certificate",
        input_path,
        certificate_path.to_str().expect("UTF-8 temporary path"),
    ]);
    assert_valid(&verified);
    fs::remove_file(certificate_path).expect("temporary certificate removes");

    let canonical_json: serde_json::Value =
        serde_json::from_slice(&canonical.stdout).expect("canonical JSON parses");
    let bare_certificate = serde_json::to_vec_pretty(&canonical_json["certificate"])
        .expect("canonical certificate serializes");
    let certificate_path = write_temp_json("canonical-certificate", &bare_certificate);
    let verified = run(&[
        "verify-certificate",
        input_path,
        certificate_path.to_str().expect("UTF-8 temporary path"),
    ]);
    assert_valid(&verified);
    fs::remove_file(certificate_path).expect("temporary certificate removes");

    let equivalence = run(&["equivalent", input_path, input_path]);
    assert!(equivalence.status.success());
    let equivalence_path = write_temp_json("equivalence", &equivalence.stdout);
    let verified = run(&[
        "verify-equivalence-certificate",
        input_path,
        input_path,
        equivalence_path.to_str().expect("UTF-8 temporary path"),
    ]);
    assert_valid(&verified);
    fs::remove_file(equivalence_path).expect("temporary certificate removes");

    let reconstruction = run(&["reconstruct", calibrated_path]);
    assert!(reconstruction.status.success());
    let reconstruction_path = write_temp_json("reconstruction", &reconstruction.stdout);
    let verified = run(&[
        "verify-reconstruction-certificate",
        calibrated_path,
        reconstruction_path.to_str().expect("UTF-8 temporary path"),
    ]);
    assert_valid(&verified);
    fs::remove_file(reconstruction_path).expect("temporary certificate removes");
}

#[test]
fn paper_iv_cli_canonical_and_reconstruction_certificates_replay() {
    let input = paper_iv_export();
    if !input.exists() {
        return;
    }
    let input_path = input.to_str().expect("UTF-8 Paper-IV export path");

    let canonical = run(&["canonicalize", input_path]);
    assert!(canonical.status.success());
    let golden: serde_json::Value =
        serde_json::from_str(PAPER_IV_GOLDEN_CONTRACT).expect("Paper-IV golden contract parses");
    assert_eq!(
        canonical.stdout.len() as u64,
        golden["canonical"]["stdout_bytes"]
            .as_u64()
            .expect("canonical byte count")
    );
    assert_eq!(
        digest(&canonical.stdout),
        golden["canonical"]["stdout_blake3"]
            .as_str()
            .expect("canonical digest")
    );
    let canonical_path = write_temp_json("paper-iv-canonical", &canonical.stdout);
    assert_valid(&run(&[
        "verify-certificate",
        input_path,
        canonical_path.to_str().expect("UTF-8 temporary path"),
    ]));
    fs::remove_file(canonical_path).expect("temporary certificate removes");

    let reconstruction = run(&["reconstruct", input_path]);
    assert!(reconstruction.status.success());
    assert_eq!(
        reconstruction.stdout.len() as u64,
        golden["reconstruction"]["stdout_bytes"]
            .as_u64()
            .expect("reconstruction byte count")
    );
    assert_eq!(
        digest(&reconstruction.stdout),
        golden["reconstruction"]["stdout_blake3"]
            .as_str()
            .expect("reconstruction digest")
    );
    let reconstruction_path = write_temp_json("paper-iv-reconstruction", &reconstruction.stdout);
    assert_valid(&run(&[
        "verify-reconstruction-certificate",
        input_path,
        reconstruction_path.to_str().expect("UTF-8 temporary path"),
    ]));
    fs::remove_file(reconstruction_path).expect("temporary certificate removes");
}

#[test]
fn every_cli_verifier_rejects_a_corrupted_artifact() {
    let input = fixture("paper-i-icosahedral-orbitals.json");
    let input_path = input.to_str().expect("UTF-8 fixture path");

    let canonical = run(&["canonicalize", input_path]);
    assert!(canonical.status.success());
    let mut canonical_json: serde_json::Value =
        serde_json::from_slice(&canonical.stdout).expect("canonical JSON parses");
    canonical_json["automorphism_order"] = serde_json::Value::from(119);
    let certificate =
        serde_json::to_vec_pretty(&canonical_json).expect("canonical artifact serializes");
    let certificate_path = write_temp_json("corrupt-canonical", &certificate);
    let rejected = run(&[
        "verify-certificate",
        input_path,
        certificate_path.to_str().expect("UTF-8 temporary path"),
    ]);
    assert_certificate_failure(&rejected);
    fs::remove_file(certificate_path).expect("temporary certificate removes");

    let equivalence = run(&["equivalent", input_path, input_path]);
    assert!(equivalence.status.success());
    let mut equivalence_json: serde_json::Value =
        serde_json::from_slice(&equivalence.stdout).expect("equivalence JSON parses");
    equivalence_json["certificate_schema"] = serde_json::Value::String("corrupt".into());
    let equivalence =
        serde_json::to_vec_pretty(&equivalence_json).expect("equivalence certificate serializes");
    let equivalence_path = write_temp_json("corrupt-equivalence", &equivalence);
    let rejected = run(&[
        "verify-equivalence-certificate",
        input_path,
        input_path,
        equivalence_path.to_str().expect("UTF-8 temporary path"),
    ]);
    assert_certificate_failure(&rejected);
    fs::remove_file(equivalence_path).expect("temporary certificate removes");

    let reconstruction = run(&["reconstruct", input_path]);
    assert!(reconstruction.status.success());
    let mut reconstruction_json: serde_json::Value =
        serde_json::from_slice(&reconstruction.stdout).expect("reconstruction JSON parses");
    reconstruction_json["canonical"]["automorphism_order"] = serde_json::Value::from(119);
    let reconstruction = serde_json::to_vec_pretty(&reconstruction_json)
        .expect("reconstruction certificate serializes");
    let reconstruction_path = write_temp_json("corrupt-reconstruction", &reconstruction);
    let rejected = run(&[
        "verify-reconstruction-certificate",
        input_path,
        reconstruction_path.to_str().expect("UTF-8 temporary path"),
    ]);
    assert_certificate_failure(&rejected);
    fs::remove_file(reconstruction_path).expect("temporary certificate removes");
}
