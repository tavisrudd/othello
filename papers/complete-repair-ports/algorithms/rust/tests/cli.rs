use serde_json::Value;
use std::path::PathBuf;
use std::process::Command;

fn example(name: &str) -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("examples")
        .join("data")
        .join(name)
}

fn run_application(input: Value) -> Value {
    let mut child = Command::new(env!("CARGO_BIN_EXE_ergo-comp"))
        .args(["application", "--input", "-"])
        .stdin(std::process::Stdio::piped())
        .stdout(std::process::Stdio::piped())
        .stderr(std::process::Stdio::piped())
        .spawn()
        .unwrap();
    serde_json::to_writer(child.stdin.take().unwrap(), &input).unwrap();
    let output = child.wait_with_output().unwrap();
    assert!(
        output.status.success(),
        "{}",
        String::from_utf8_lossy(&output.stderr)
    );
    serde_json::from_slice(&output.stdout).unwrap()
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

#[test]
fn application_cli_covers_storage_graph_qc_vector_and_gpu_front_ends() {
    let ceph = run_application(serde_json::json!({
        "kind": "ceph-xor",
        "coordinate_count": 8,
        "layers": [
            {"parity": 1, "data": [2, 3]},
            {"parity": 5, "data": [6, 7]},
            {"parity": 0, "data": [1, 2, 3]},
            {"parity": 4, "data": [5, 6, 7]}
        ],
        "target": 2,
        "unavailable": [2]
    }));
    assert_eq!(ceph["supports"], serde_json::json!([[1, 3]]));

    let ceph_compressed = run_application(serde_json::json!({
        "kind": "ceph-xor",
        "coordinate_count": 8,
        "layers": [
            {"parity": 1, "data": [2, 3]},
            {"parity": 5, "data": [6, 7]},
            {"parity": 0, "data": [1, 2, 3]},
            {"parity": 4, "data": [5, 6, 7]}
        ],
        "target": 2,
        "unavailable": [2],
        "exact_reliability": true,
        "resource_of_coordinate": [0, 0, 0, 1, 0, 0, 0, 0],
        "capacities": [3, 3],
        "demand_count": 3
    }));
    assert_eq!(
        ceph_compressed["reliability"]["success_counts_by_available"],
        serde_json::json!(["0", "0", "1", "5", "10", "10", "5", "1"])
    );
    assert_eq!(ceph_compressed["scheduling"]["repaired_count"], 3);
    assert_eq!(
        ceph_compressed["scheduling"]["assignment"][0]["representative_support"],
        serde_json::json!([1, 3])
    );

    let azure = run_application(serde_json::json!({
        "kind": "azure-lrc",
        "capacities": [6, 6, 6, 6, 6, 6, 3, 0, 0],
        "demand_count": 3
    }));
    assert_eq!(azure["repaired_count"], 3);

    let dag = run_application(serde_json::json!({
        "kind": "repair-dag",
        "capacities": [1, 1],
        "tasks": [
            {"predecessors": 0, "loads": [1, 0]},
            {"predecessors": 0, "loads": [0, 1]},
            {"predecessors": 3, "loads": [1, 1]}
        ]
    }));
    assert_eq!(dag["slots"], 2);

    let qc = run_application(serde_json::json!({
        "kind": "qc-ldpc",
        "check_groups": 2,
        "variable_groups": 2,
        "lift": 2,
        "shifts": [0, 0, 0, 1],
        "objective": "trapping",
        "size": 4,
        "maximum_odd_checks": 0
    }));
    assert_eq!(qc["found"], true);

    let vector = run_application(serde_json::json!({
        "kind": "vector-repair",
        "field": {"kind": "prime", "order": 2},
        "generator": {"rows": 3, "cols": 5, "data": [1,0,0,1,0, 0,1,0,1,0, 0,0,1,0,1]},
        "coordinate_nodes": [0,0,1,2,2],
        "target": {"rows": 3, "cols": 2, "data": [1,0,0,1,0,0]}
    }));
    assert_eq!(vector["node_cost"], 1);

    let gpu = run_application(serde_json::json!({
        "kind": "gpu-checkpoint",
        "data_shards": 2,
        "shard_nodes": [0,1,2,3],
        "node_racks": [0,0,1,1],
        "failed_shards": [0],
        "replacement_nodes": [0],
        "capacities": [2,2,2,2,2,1],
        "option_budget": 10
    }));
    assert_eq!(gpu["repaired_count"], 1);
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
