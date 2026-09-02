use std::hint::black_box;

use ergodis_private::q29_mod3_norm::extract_q29_modular_correlation;

fn retained_canonical_rows() -> [[i8; 29]; 4] {
    let inventories: [[(usize, i8); 6]; 4] = [
        [(13, 2), (13, -2), (1, 3), (1, -3), (1, 1), (0, -1)],
        [(13, 2), (12, -2), (1, 3), (2, -3), (1, 1), (0, -1)],
        [(13, 2), (12, -2), (1, 3), (2, -3), (1, 1), (0, -1)],
        [(12, 2), (15, -2), (2, 3), (0, -3), (0, 1), (0, -1)],
    ];
    let mut rows = [[0_i8; 29]; 4];
    for block in 0..4 {
        let mut cursor = 0;
        for &(count, value) in &inventories[block] {
            for _ in 0..count {
                rows[block][cursor] = value;
                cursor += 1;
            }
        }
        assert_eq!(cursor, 29);
    }
    rows
}

fn main() {
    let repetitions = std::env::args()
        .nth(1)
        .and_then(|text| text.parse::<u64>().ok())
        .unwrap_or(10_000_000);
    let rows = retained_canonical_rows();
    let mut checksum = 0_u64;
    for _ in 0..repetitions {
        let result = extract_q29_modular_correlation(black_box(&rows)).expect("canonical rows");
        checksum = checksum.wrapping_add(u64::from(result.mod9_residues()[14]));
    }
    println!("repetitions={repetitions} checksum={checksum}");
    println!("provenance=PerformanceControl; fixed canonical row; no search authority");
}
