use serde_json::Value;
use std::path::PathBuf;
use std::process::Command;

fn example(name: &str) -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("examples")
        .join("data")
        .join(name)
}

#[test]
fn transfer_cli_replays_the_gf4_separation() {
    let output = Command::new(env!("CARGO_BIN_EXE_ergo-comp"))
        .args([
            "transfer",
            "--input",
            example("f4-scalar-separation.json").to_str().unwrap(),
        ])
        .output()
        .unwrap();
    assert!(
        output.status.success(),
        "{}",
        String::from_utf8_lossy(&output.stderr)
    );
    let value: Value = serde_json::from_slice(&output.stdout).unwrap();
    let analyses = value["analyses"].as_array().unwrap();
    assert_eq!(value["comparison"]["all_scalar_escape_costs_equal"], true);
    assert_eq!(value["comparison"]["gamma_values_differ"], true);
    assert_eq!(analyses[0]["scalar_escape_cost"], 3);
    assert_eq!(analyses[1]["scalar_escape_cost"], 3);
    assert_eq!(analyses[0]["gamma"], 1);
    assert_eq!(analyses[1]["gamma"], 2);
    assert_eq!(analyses[0]["block_labels"], serde_json::json!([1, 2]));
    assert_eq!(analyses[1]["block_labels"], serde_json::json!([1, 2]));
}

#[test]
fn compose_cli_retains_legacy_prime_schema() {
    let output = Command::new(env!("CARGO_BIN_EXE_ergo-comp"))
        .args([
            "compose",
            "--input",
            example("compose.json").to_str().unwrap(),
        ])
        .output()
        .unwrap();
    assert!(
        output.status.success(),
        "{}",
        String::from_utf8_lossy(&output.stderr)
    );
    let value: Value = serde_json::from_slice(&output.stdout).unwrap();
    assert_eq!(value["feasible"], true);
    assert_eq!(value["cost"], 2);
}

#[test]
fn transfer_cli_fails_closed_on_insufficient_budget() {
    let mut value: Value =
        serde_json::from_slice(&std::fs::read(example("f4-scalar-separation.json")).unwrap())
            .unwrap();
    value["candidate_budget"] = 7.into();
    let mut child = Command::new(env!("CARGO_BIN_EXE_ergo-comp"))
        .args(["transfer", "--input", "-"])
        .stdin(std::process::Stdio::piped())
        .stdout(std::process::Stdio::piped())
        .stderr(std::process::Stdio::piped())
        .spawn()
        .unwrap();
    serde_json::to_writer(child.stdin.take().unwrap(), &value).unwrap();
    let output = child.wait_with_output().unwrap();
    assert!(!output.status.success());
    assert!(String::from_utf8_lossy(&output.stderr).contains("budget is 7"));
}

#[test]
fn target_subspace_cli_returns_matrix_witnesses() {
    let output = Command::new(env!("CARGO_BIN_EXE_ergo-comp"))
        .args([
            "transfer-subspace",
            "--input",
            example("transfer-subspace.json").to_str().unwrap(),
        ])
        .output()
        .unwrap();
    assert!(
        output.status.success(),
        "{}",
        String::from_utf8_lossy(&output.stderr)
    );
    let value: Value = serde_json::from_slice(&output.stdout).unwrap();
    assert_eq!(value["demand_dimension"], 2);
    assert_eq!(value["target_union_cost"], 2);
    assert_eq!(value["inner_dual_distance"], 2);
    assert_eq!(value["ordinary_candidates_examined"], 256);
    assert_eq!(value["target_candidates_examined"], 16);
    assert_eq!(value["outer_functionals_examined"], 15);
    assert!(value["zero_target_coefficients"]["data"].is_array());
}

#[test]
fn transfer_tower_cli_expands_leaf_coefficient_witnesses() {
    let output = Command::new(env!("CARGO_BIN_EXE_ergo-comp"))
        .args([
            "transfer-tower",
            "--input",
            example("transfer-tower.json").to_str().unwrap(),
        ])
        .output()
        .unwrap();
    assert!(
        output.status.success(),
        "{}",
        String::from_utf8_lossy(&output.stderr)
    );
    let value: Value = serde_json::from_slice(&output.stdout).unwrap();
    assert_eq!(value["levels"], 2);
    assert_eq!(value["cost"], 2);
    assert_eq!(value["witness_nodes"], 7);
    assert_eq!(value["witness"]["target_normalized"], true);
    assert_eq!(
        value["witness"]["children"][0]["children"][0]["target_normalized"],
        true
    );
    assert!(
        value["witness"]["children"][0]["children"][0]["coefficient_witness"]["data"].is_array()
    );
}

#[cfg(feature = "parallel")]
#[test]
fn transfer_tower_parallel_cli_matches_sequential_json() {
    let run = |parallel: bool| {
        let mut command = Command::new(env!("CARGO_BIN_EXE_ergo-comp"));
        command.args([
            "transfer-tower",
            "--input",
            example("transfer-tower.json").to_str().unwrap(),
        ]);
        if parallel {
            command.args(["--parallel", "--threads", "2"]);
        }
        command.output().unwrap().stdout
    };
    assert_eq!(run(false), run(true));
}
