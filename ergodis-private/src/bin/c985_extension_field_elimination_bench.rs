//! C985 diagnostic: isolate table-backed and characteristic-two row reduction.
//!
//! This is deliberately private.  It answers whether a bit-/byte-sliced
//! `GF(2^h)` elimination backend can matter before any public API is added.

use std::hint::black_box;
use std::time::Instant;

use ergodis::SmallField;

const MAX_ROWS: usize = 8;
const MAX_COLS: usize = 9;
const MAX_CELLS: usize = MAX_ROWS * MAX_COLS;

#[repr(C)]
struct BinaryTables {
    multiply: Box<[u8]>,
    inverse: [u8; 256],
}

impl BinaryTables {
    fn new<const H: u8>(field: &SmallField) -> Self {
        let order = 1_usize << H;
        assert_eq!(usize::from(field.order()), order);
        assert_eq!(field.characteristic(), 2);
        let mut multiply = vec![0_u8; order * order].into_boxed_slice();
        for left in 0..order {
            for right in 0..order {
                multiply[(left << H) | right] = field.mul(left as u8, right as u8);
            }
        }
        let mut inverse = [0_u8; 256];
        for (value, output) in inverse.iter_mut().enumerate().take(order).skip(1) {
            *output = field.inverse(value as u8).expect("nonzero field element");
        }
        Self { multiply, inverse }
    }

    #[inline(always)]
    fn mul<const H: u8>(&self, left: u8, right: u8) -> u8 {
        self.multiply[(usize::from(left) << H) | usize::from(right)]
    }
}

#[inline(never)]
fn rref_table(field: &SmallField, rows: usize, cols: usize, data: &mut [u8; MAX_CELLS]) -> usize {
    let mut pivot = 0;
    for col in 0..cols {
        let Some(selected) = (pivot..rows).find(|&row| data[row * cols + col] != 0) else {
            continue;
        };
        for slot in col..cols {
            data.swap(pivot * cols + slot, selected * cols + slot);
        }
        let inverse = field
            .inverse(data[pivot * cols + col])
            .expect("pivot is nonzero");
        for slot in col..cols {
            data[pivot * cols + slot] = field.mul(data[pivot * cols + slot], inverse);
        }
        for row in 0..rows {
            if row == pivot {
                continue;
            }
            let factor = data[row * cols + col];
            if factor == 0 {
                continue;
            }
            for slot in col..cols {
                let product = field.mul(factor, data[pivot * cols + slot]);
                data[row * cols + slot] = field.sub(data[row * cols + slot], product);
            }
        }
        pivot += 1;
        if pivot == rows {
            break;
        }
    }
    pivot
}

#[inline(never)]
fn rref_binary<const H: u8>(
    tables: &BinaryTables,
    rows: usize,
    cols: usize,
    data: &mut [u8; MAX_CELLS],
) -> usize {
    let mut pivot = 0;
    for col in 0..cols {
        let Some(selected) = (pivot..rows).find(|&row| data[row * cols + col] != 0) else {
            continue;
        };
        for slot in col..cols {
            data.swap(pivot * cols + slot, selected * cols + slot);
        }
        let inverse = tables.inverse[usize::from(data[pivot * cols + col])];
        for slot in col..cols {
            data[pivot * cols + slot] = tables.mul::<H>(data[pivot * cols + slot], inverse);
        }
        for row in 0..rows {
            if row == pivot {
                continue;
            }
            let factor = data[row * cols + col];
            if factor == 0 {
                continue;
            }
            for slot in col..cols {
                let product = tables.mul::<H>(factor, data[pivot * cols + slot]);
                data[row * cols + slot] ^= product;
            }
        }
        pivot += 1;
        if pivot == rows {
            break;
        }
    }
    pivot
}

fn fixture(order: usize, rows: usize, cols: usize, mut seed: u64) -> [u8; MAX_CELLS] {
    assert!(rows <= MAX_ROWS && cols <= MAX_COLS && rows <= cols);
    let mut data = [0_u8; MAX_CELLS];
    for row in 0..rows {
        for col in 0..cols {
            seed = seed
                .wrapping_mul(6_364_136_223_846_793_005)
                .wrapping_add(1_442_695_040_888_963_407);
            let random = ((seed >> 32) as usize % order) as u8;
            data[row * cols + col] = if col > row && col < rows {
                0
            } else if col <= row {
                // A lower-triangular, nonzero-diagonal prefix guarantees full
                // row rank while forcing normalization and row elimination.
                1 + random % ((order - 1) as u8)
            } else {
                random
            };
        }
    }
    data
}

fn checksum(data: &[u8; MAX_CELLS], cells: usize) -> u64 {
    data[..cells]
        .iter()
        .fold(0_u64, |sum, &value| sum.rotate_left(7) ^ u64::from(value))
}

fn run<const H: u8>(backend: &str, rows: usize, cols: usize, seed: u64, repetitions: u64) {
    let field = SmallField::new(2, H).expect("valid binary extension field");
    let original = fixture(1_usize << H, rows, cols, seed);
    let tables = BinaryTables::new::<H>(&field);
    let mut data = [0_u8; MAX_CELLS];
    let started = Instant::now();
    let mut ranks = 0_u64;
    let mut digest = 0_u64;
    for _ in 0..repetitions {
        data[..rows * cols].copy_from_slice(&original[..rows * cols]);
        let rank = match backend {
            "table" => rref_table(&field, rows, cols, &mut data),
            "binary" => rref_binary::<H>(&tables, rows, cols, &mut data),
            _ => panic!("backend must be table or binary"),
        };
        ranks += rank as u64;
        digest = digest.wrapping_add(checksum(&data, rows * cols));
        black_box((&data, rank));
    }
    let elapsed_ns = started.elapsed().as_nanos();
    println!(
        "{{\"backend\":\"{backend}\",\"degree\":{H},\"rows\":{rows},\"cols\":{cols},\"seed\":{seed},\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"rank_sum\":{ranks},\"checksum\":{digest}}}"
    );
}

fn main() {
    let mut args = std::env::args().skip(1);
    let backend = args.next().expect("backend is required");
    let degree: u8 = args.next().expect("degree is required").parse().unwrap();
    let rows: usize = args.next().expect("rows are required").parse().unwrap();
    let cols: usize = args.next().expect("columns are required").parse().unwrap();
    let seed: u64 = args.next().expect("seed is required").parse().unwrap();
    let repetitions: u64 = args
        .next()
        .expect("repetitions are required")
        .parse()
        .unwrap();
    assert!(args.next().is_none(), "unexpected argument");
    match degree {
        3 => run::<3>(&backend, rows, cols, seed, repetitions),
        4 => run::<4>(&backend, rows, cols, seed, repetitions),
        5 => run::<5>(&backend, rows, cols, seed, repetitions),
        6 => run::<6>(&backend, rows, cols, seed, repetitions),
        7 => run::<7>(&backend, rows, cols, seed, repetitions),
        8 => run::<8>(&backend, rows, cols, seed, repetitions),
        _ => panic!("degree must lie in 3..=8"),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn agrees<const H: u8>() {
        let field = SmallField::new(2, H).unwrap();
        let tables = BinaryTables::new::<H>(&field);
        for seed in 0..256 {
            for (rows, cols) in [(4, 5), (8, 9)] {
                let original = fixture(1_usize << H, rows, cols, seed);
                let mut table = original;
                let mut binary = original;
                assert_eq!(
                    rref_table(&field, rows, cols, &mut table),
                    rref_binary::<H>(&tables, rows, cols, &mut binary)
                );
                assert_eq!(table, binary);
            }
        }
    }

    #[test]
    fn binary_specialization_matches_table_reduction() {
        agrees::<3>();
        agrees::<4>();
        agrees::<5>();
        agrees::<6>();
        agrees::<7>();
        agrees::<8>();
    }

    #[test]
    fn fixture_forces_real_elimination_work() {
        let field = SmallField::new(2, 6).unwrap();
        let tables = BinaryTables::new::<6>(&field);
        for (rows, cols) in [(4, 5), (8, 9)] {
            let original = fixture(64, rows, cols, 0);
            let mut table = original;
            let mut binary = original;
            assert_eq!(rref_table(&field, rows, cols, &mut table), rows);
            assert_eq!(rref_binary::<6>(&tables, rows, cols, &mut binary), rows);
            assert_ne!(table, original);
            assert_ne!(binary, original);
            assert_eq!(table, binary);
        }
    }
}
