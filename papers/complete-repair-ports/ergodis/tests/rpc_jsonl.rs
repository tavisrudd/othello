use std::io::Write;
use std::process::{Command, Stdio};

use serde_json::{json, Value};

#[test]
fn rpc_discovers_methods_batches_calls_and_recovers_after_errors() {
    let mut child = Command::new(env!("CARGO_BIN_EXE_ergodis-rpc"))
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()
        .unwrap();
    let requests = [
        json!({"jsonrpc": "2.0", "id": 1, "method": "rpc.discover"}).to_string(),
        json!({
            "jsonrpc": "2.0",
            "id": 2,
            "method": "character_sum.census",
            "params": {
                "modulus": 5,
                "queries": [
                    {"name": "S", "coefficients": [36, -108, 213, -246, 213, -108, 36]},
                    {"name": "S1", "coefficients": [36, -108, 105, -36]},
                    {"name": "S2", "coefficients": [36, -108, 105, -36], "linear_twist": [1, -4]}
                ]
            }
        })
        .to_string(),
        "not-json".to_owned(),
        json!({
            "jsonrpc": "2.0",
            "id": "big",
            "method": "character_sum.census",
            "params": {
                "modulus": 7,
                "queries": [{"name": "constant", "coefficients": [{"$integer": "700000000000000000000000000000000000001"}]}]
            }
        })
        .to_string(),
    ];
    {
        let input = child.stdin.as_mut().unwrap();
        for request in requests {
            writeln!(input, "{request}").unwrap();
        }
    }
    drop(child.stdin.take());
    let output = child.wait_with_output().unwrap();
    assert!(output.status.success());
    let responses: Vec<Value> = String::from_utf8(output.stdout)
        .unwrap()
        .lines()
        .map(|line| serde_json::from_str(line).unwrap())
        .collect();
    assert_eq!(responses.len(), 4);
    assert_eq!(
        responses[0]["result"]["methods"],
        json!(["rpc.discover", "character_sum.census"])
    );
    assert_eq!(responses[1]["result"]["queries"][0]["sum"], 2);
    assert_eq!(responses[1]["result"]["queries"][1]["sum"], -1);
    assert_eq!(responses[1]["result"]["queries"][2]["sum"], 3);
    assert_eq!(responses[2]["error"]["code"], -32700);
    assert_eq!(responses[3]["id"], "big");
    assert_eq!(responses[3]["result"]["queries"][0]["sum"], 7);
}
