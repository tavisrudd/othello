use std::{fs, process::ExitCode};

use ergodis_private::q29_four_plus_one::{repair_q29_four_plus_one_exact, Q29FourPlusOneWorkspace};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};

#[derive(Deserialize)]
struct OuterInput {
    best_q29: [[i8; 29]; 4],
}

#[derive(Serialize)]
struct Output {
    source_commitment: [u8; 32],
    report: ergodis_private::q29_four_plus_one::Q29FourPlusOneReport,
}

fn main() -> ExitCode {
    let mut args = std::env::args().skip(1);
    let path = args
        .next()
        .expect("usage: q29_four_plus_one OUTER.json [state-limit]");
    let state_limit = args
        .next()
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(u64::MAX);
    let source = fs::read(path).expect("read outer JSON");
    let input: OuterInput = serde_json::from_slice(&source).expect("parse outer JSON");
    let root = x_to_y(&input.best_q29).expect("canonical even x=2y root");
    let workspace = Q29FourPlusOneWorkspace::compile(&root).expect("compile labelled targets");
    let report = repair_q29_four_plus_one_exact(root, &workspace, state_limit);
    println!(
        "{}",
        serde_json::to_string_pretty(&Output {
            source_commitment: Sha256::digest(&source).into(),
            report,
        })
        .expect("serialize report")
    );
    ExitCode::SUCCESS
}

fn x_to_y(rows_x: &[[i8; 29]; 4]) -> Option<[[i8; 29]; 4]> {
    let mut rows_y = [[0_i8; 29]; 4];
    for block in 0..4 {
        for point in 0..29 {
            let value = rows_x[block][point];
            if !(-18..=18).contains(&value) || value & 1 != 0 {
                return None;
            }
            rows_y[block][point] = value / 2;
        }
    }
    Some(rows_y)
}
