//! C1050 diagnostic: a repair DAG whose ready sets do not fit.
//!
//! The published repair-DAG benchmark row uses unit capacities and one distinct
//! resource per task, so every ready set fits whole,
//! `applications::schedule_repair_dag` takes its whole-ready fast path at every
//! layer, and the instance visits four BFS states per solve. That row therefore
//! never enters the `batch = (batch - 1) & ready` subset descent where the
//! kernel's cost lives (C1053).
//!
//! This fixture keeps the layered precedence structure and contends two shared
//! resource dimensions of capacity `c`: task `j` of every layer loads one unit
//! of dimension `j mod 2`. When `c` is below the per-dimension ready count no
//! ready set fits whole, the fast path never fires, and the descent runs on
//! every popped state.
//!
//! Usage: `c1050_repair_dag_contended <width> <layers> <capacity> [repetitions]`
//! Emits one JSON object on stdout, in the shape `bench_kernels` uses.

use std::hint::black_box;
use std::time::Instant;

use ergodis::applications::{schedule_repair_dag, RepairTask};

fn contended_fixture(width: usize, layers: usize) -> Vec<RepairTask> {
    assert!(width * layers <= 63, "the BFS state is a u64 task mask");
    let mut tasks = Vec::with_capacity(width * layers);
    for layer in 0..layers {
        let predecessors = if layer == 0 {
            0
        } else {
            ((1u64 << width) - 1) << ((layer - 1) * width)
        };
        for task in 0..width {
            let mut loads = vec![0u16; 2];
            loads[task % 2] = 1;
            tasks.push(RepairTask {
                predecessors,
                loads: loads.into_boxed_slice(),
            });
        }
    }
    tasks
}

/// Closed-form optimum for this fixture: each layer must be finished before the
/// next starts, and within a layer the two dimensions are independent, so the
/// layer needs `max(ceil(n0/c), ceil(n1/c))` unit slots.
fn expected_slots(width: usize, layers: usize, capacity: usize) -> usize {
    let on_zero = width.div_ceil(2);
    let on_one = width / 2;
    layers * on_zero.div_ceil(capacity).max(on_one.div_ceil(capacity))
}

fn main() {
    let arguments: Vec<String> = std::env::args().skip(1).collect();
    let width: usize = arguments[0].parse().unwrap();
    let layers: usize = arguments[1].parse().unwrap();
    let capacity: usize = arguments[2].parse().unwrap();
    let repetitions: usize = arguments.get(3).map_or(1, |value| value.parse().unwrap());

    let tasks = contended_fixture(width, layers);
    let capacities = vec![capacity as u16; 2];

    let mut work = 0u64;
    let mut checksum = 0u64;
    let start = Instant::now();
    for _ in 0..repetitions {
        let answer = schedule_repair_dag(
            black_box(&capacities),
            black_box(&tasks),
            black_box(1u64 << 32),
        )
        .unwrap();
        work += answer.states_examined;
        checksum += u64::from(answer.slots);
        black_box(answer);
    }
    let elapsed_ns = start.elapsed().as_nanos();

    assert_eq!(
        checksum as usize,
        repetitions * expected_slots(width, layers, capacity),
        "makespan disagrees with the closed form"
    );

    println!(
        "{{\"variant\":\"application:rdag-contended:rust:{width}:{layers}:{capacity}\",\
         \"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\
         \"peak_states\":0,\"peak_rss_kib\":0,\"checksum\":{checksum}}}"
    );
}
