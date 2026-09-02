use std::fs::File;

use ergodis_private::order6_margin_evolve::{
    repair_q29_radius_four_at_most_two_per_block_exact, repair_q29_triple_block_plus_one_exact,
    repair_q29_triple_plus_double_exact, Order6Q29RadiusFourWorkspace,
    Order6Q29TripleBlockWorkspace, Order6Q29TripleDoubleWorkspace,
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
    let radius_four =
        repair_q29_radius_four_at_most_two_per_block_exact(input.best_q29, &mut workspace)
            .expect("valid q29 repair domain and sufficient fixed workspace");
    let triple_workspace = Order6Q29TripleBlockWorkspace::new();
    let triple_block_plus_one = if radius_four.is_none() {
        repair_q29_triple_block_plus_one_exact(input.best_q29, &triple_workspace)
            .expect("valid q29 triple-block repair domain")
    } else {
        None
    };
    let mut triple_double_workspace = Order6Q29TripleDoubleWorkspace::new();
    let triple_plus_double = if radius_four.is_none() && triple_block_plus_one.is_none() {
        repair_q29_triple_plus_double_exact(input.best_q29, &mut triple_double_workspace)
            .expect("valid q29 triple-plus-double repair domain")
    } else {
        None
    };
    let result = radius_four.or(triple_block_plus_one).or(triple_plus_double);
    println!(
        "{}",
        serde_json::to_string_pretty(&serde_json::json!({
            "exact_scoped_repair_hit": result.is_some(),
            "repaired_q29": result,
            "radius_four_workspace_bytes": workspace.bytes(),
            "triple_block_workspace_bytes": triple_workspace.bytes(),
            "triple_double_workspace_bytes": triple_double_workspace.bytes(),
            "provenance": "Exact union of the total-radius-at-most-four neighborhood with at most two transfers per block, every minimal three-transfer same-block state alone or plus one distinct-block transfer, and every minimal 3+2 state across distinct blocks; same-block states use net donor/recipient multisets equivalent to sequential transfers; the 3+2 tablebase key contains energy plus every independent q29 PAF coordinate and resolves collisions by full-key comparison; every hit gets direct whole-block q29 PAF replay; miss has no authority outside this scoped union"
        }))
        .expect("serialize result")
    );
}
