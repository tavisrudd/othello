use std::hint::black_box;

use ergodis::{BoundedSubsetSumBounds, BoundedSubsetSumPlan};

fn main() {
    let iterations = std::env::args()
        .nth(1)
        .map(|value| {
            value
                .parse::<usize>()
                .expect("iterations must be an integer")
        })
        .unwrap_or(5_000);
    let weights = [
        -97, -89, -83, -79, -71, -67, -61, -53, -47, -43, -37, -31, -29, -23, 19, 27, 33, 39, 45,
        51, 57, 63, 69, 75, 81, 87, 93, 99,
    ];
    let plan = BoundedSubsetSumPlan::compile(
        &weights,
        7,
        BoundedSubsetSumBounds {
            maximum_items: weights.len(),
            maximum_sum_width: 4_096,
            maximum_reachability_words: 4_096,
            maximum_transitions: 1_000_000,
        },
    )
    .expect("benchmark plan must compile");
    let mut workspace = plan.workspace();
    let mut witness = vec![0; plan.witness_words()];
    let mut checksum = 0_u64;
    for _ in 0..iterations {
        checksum ^= black_box(
            plan.solve_into(&mut workspace, &mut witness)
                .expect("benchmark solve must succeed"),
        );
    }
    println!("iterations={iterations} checksum={checksum}");
}
