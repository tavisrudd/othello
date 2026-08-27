use std::hint::black_box;

use ergodis::balanced::{HighFiberLedger, HighFiberSpec};

fn main() {
    let iterations = std::env::args()
        .nth(1)
        .map(|value| value.parse::<u64>().expect("iterations must be an integer"))
        .unwrap_or(1_000_000);
    let spec = HighFiberSpec::new([1, 2, 3, 4, 5, 6, 7, 8, 9], 0b111).unwrap();
    let rows = [
        [1, 2],
        [1, 3],
        [2, 3],
        [4, 5],
        [4, 6],
        [5, 6],
        [7, 8],
        [1, 10],
        [2, 10],
        [3, 10],
        [4, 10],
        [4, 10],
        [5, 10],
        [5, 10],
        [6, 10],
        [6, 10],
        [7, 10],
        [7, 10],
        [7, 10],
        [8, 10],
        [8, 10],
        [8, 10],
        [9, 10],
        [9, 10],
        [9, 10],
        [9, 10],
    ];
    let mut checksum = 0u64;
    for _ in 0..iterations {
        let mut state = HighFiberLedger::default();
        for &roots in &rows {
            assert!(state.try_push(black_box(&spec), black_box(roots)));
        }
        assert!(state.is_complete(&spec));
        checksum = checksum.wrapping_add(u64::from(state.rows_done()));
    }
    println!(
        "iterations={iterations} rows={} checksum={checksum}",
        iterations * rows.len() as u64
    );
}
