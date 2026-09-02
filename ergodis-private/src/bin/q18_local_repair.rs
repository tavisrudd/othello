use std::{fs, process::ExitCode};

use ergodis_private::{
    q18_local_repair::{
        repair_q18_across_distinct_blocks, repair_q18_one_double_one_single,
        repair_q18_one_double_two_singles, repair_q18_one_triple_one_double,
        repair_q18_two_doubles, Q18LocalRepairWorkspace,
    },
    q18_pair_split::Q18Coefficients,
};
use serde::Deserialize;

#[derive(Deserialize)]
struct Input {
    best_coefficients: [[i8; 18]; 4],
}

fn main() -> ExitCode {
    let path = std::env::args()
        .nth(1)
        .expect("usage: q18_local_repair INPUT.json");
    let input: Input = serde_json::from_slice(&fs::read(path).unwrap()).unwrap();
    let base = Q18Coefficients {
        blocks: input.best_coefficients,
    };
    let mut workspace = Q18LocalRepairWorkspace::new();
    match repair_q18_across_distinct_blocks(&base, &mut workspace) {
        Some(hit) => {
            println!("{}", serde_json::to_string_pretty(&hit.blocks).unwrap());
            ExitCode::SUCCESS
        }
        None => match repair_q18_one_double_one_single(&base) {
            Some(hit) => {
                println!("{}", serde_json::to_string_pretty(&hit.blocks).unwrap());
                ExitCode::SUCCESS
            }
            None => match repair_q18_two_doubles(&base, &mut workspace) {
                Some(hit) => {
                    println!("{}", serde_json::to_string_pretty(&hit.blocks).unwrap());
                    ExitCode::SUCCESS
                }
                None => match repair_q18_one_double_two_singles(&base, &mut workspace) {
                    Some(hit) => {
                        println!("{}", serde_json::to_string_pretty(&hit.blocks).unwrap());
                        ExitCode::SUCCESS
                    }
                    None => match repair_q18_one_triple_one_double(&base, &mut workspace) {
                        Some(hit) => {
                            println!("{}", serde_json::to_string_pretty(&hit.blocks).unwrap());
                            ExitCode::SUCCESS
                        }
                        None => {
                            println!("no exact repair in the tested radius-four union or minimal 3+2 family; negative authority is scoped to those partitions");
                            ExitCode::from(1)
                        }
                    },
                },
            },
        },
    }
}
