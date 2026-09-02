use std::fs::File;

use ergodis_private::order6_margin_evolve::{
    repair_q29_radius_four_at_most_two_per_block_exact, Order6Q29RadiusFourWorkspace,
};
use serde::Deserialize;

#[derive(Deserialize)]
struct EvolveOutput {
    best_q29: [[i8; 29]; 4],
}

fn main() {
    let path = std::env::args()
        .nth(1)
        .expect("usage: order6_q29_exact_repair EVOLVE.json");
    let input: EvolveOutput = serde_json::from_reader(File::open(path).expect("open input"))
        .expect("parse evolve output");
    let mut workspace = Order6Q29RadiusFourWorkspace::new();
    let result = repair_q29_radius_four_at_most_two_per_block_exact(input.best_q29, &mut workspace)
        .expect("valid q29 repair domain and sufficient fixed workspace");
    println!(
        "{}",
        serde_json::to_string_pretty(&serde_json::json!({
            "exact_radius_four_at_most_two_per_block_hit": result.is_some(),
            "repaired_q29": result,
            "workspace_bytes": workspace.bytes(),
            "provenance": "Exact total-radius-at-most-four neighborhood with at most two transfers per block; same-block moves compiled sequentially; every hit gets direct whole-block q29 PAF replay; miss has no authority outside this scoped neighborhood"
        }))
        .expect("serialize result")
    );
}
