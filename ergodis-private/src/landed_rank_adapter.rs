//! Domain adapter for the landed `GF(9)` intertwiner calculation.
//!
//! The generic rank compiler knows nothing about representations. This module
//! reconstructs four labelled generator blocks directly from the source
//! matrices, furnishing an independent Rust implementation of the frozen
//! calculation.

use crate::semantic_rank::Gf9BlockSystem;

pub const GENERATOR_NAMES: [&str; 4] = ["u(1)", "u(a)", "weyl", "torus"];
pub const SOURCE_SHA256: &str = "782087ca2931c7438dca514010b65cb152d90df18cc27ae86822dde0fea20ab6";

#[inline]
fn add(left: u8, right: u8) -> u8 {
    ((left % 3 + right % 3) % 3) + 3 * ((left / 3 + right / 3) % 3)
}

#[inline]
fn neg(value: u8) -> u8 {
    ((3 - value % 3) % 3) + 3 * ((3 - value / 3) % 3)
}

#[inline]
fn mul(left: u8, right: u8) -> u8 {
    let (a, b) = (left % 3, left / 3);
    let (c, d) = (right % 3, right / 3);
    ((a * c + 2 * b * d) % 3) + 3 * ((a * d + b * c) % 3)
}

fn power(mut value: u8, mut exponent: usize) -> u8 {
    let mut result = 1;
    while exponent != 0 {
        if exponent & 1 != 0 {
            result = mul(result, value);
        }
        value = mul(value, value);
        exponent >>= 1;
    }
    result
}

fn inverse(value: u8) -> u8 {
    power(value, 7)
}

fn choose(n: usize, k: usize) -> u8 {
    match (n, k) {
        (_, 0) => 1,
        (1, 1) => 1,
        (2, 1) => 2,
        (2, 2) => 1,
        (3, 1) | (3, 2) => 0,
        (3, 3) => 1,
        _ => 0,
    }
}

type Matrix = Vec<Vec<u8>>;

fn sym_power(matrix: &[[u8; 2]; 2], degree: usize) -> Matrix {
    let [[a, b], [c, d]] = *matrix;
    let mut result = vec![vec![0; degree + 1]; degree + 1];
    for input in 0..=degree {
        for r in 0..=(degree - input) {
            for s in 0..=input {
                let output = r + s;
                let factors = [
                    choose(degree - input, r),
                    power(a, degree - input - r),
                    power(b, r),
                    choose(input, s),
                    power(c, input - s),
                    power(d, s),
                ];
                let coefficient = factors.into_iter().fold(1, mul);
                result[output][input] = add(result[output][input], coefficient);
            }
        }
    }
    result
}

fn sym_square(matrix: &Matrix) -> Matrix {
    let dimension = matrix.len();
    let pairs = (0..dimension)
        .flat_map(|left| (left..dimension).map(move |right| (left, right)))
        .collect::<Vec<_>>();
    let mut result = vec![vec![0; pairs.len()]; pairs.len()];
    for (column, &(left, right)) in pairs.iter().enumerate() {
        for output_left in 0..dimension {
            for output_right in 0..dimension {
                let pair = if output_left <= output_right {
                    (output_left, output_right)
                } else {
                    (output_right, output_left)
                };
                let row = pairs
                    .iter()
                    .position(|&candidate| candidate == pair)
                    .unwrap();
                result[row][column] = add(
                    result[row][column],
                    mul(matrix[output_left][left], matrix[output_right][right]),
                );
            }
        }
    }
    result
}

fn generators() -> [[[u8; 2]; 2]; 4] {
    let primitive = (2..9).find(|&value| power(value, 4) != 1).unwrap();
    [
        [[1, 1], [0, 1]],
        [[1, 3], [0, 1]],
        [[0, neg(1)], [1, 0]],
        [[primitive, 0], [0, inverse(primitive)]],
    ]
}

/// Reconstruct the four generator blocks for the extra `L(2,0)` source.
#[must_use]
pub fn q9_extra_channel_system() -> Gf9BlockSystem {
    let mut rows = Vec::with_capacity(4 * 300 * 30);
    let mut block_offsets = Vec::with_capacity(5);
    block_offsets.push(0);
    let mut row_count = 0;
    for generator in generators() {
        let target = sym_square(&sym_power(&generator, 3));
        let source = sym_power(&generator, 2);
        let target_dimension = target.len();
        let source_dimension = source.len();
        let variables = target_dimension * source_dimension;
        for (output, target_row) in target.iter().enumerate() {
            for input in 0..source_dimension {
                let start = rows.len();
                rows.resize(start + variables, 0);
                let row = &mut rows[start..start + variables];
                for (middle, &coefficient) in target_row.iter().enumerate() {
                    let variable = middle * source_dimension + input;
                    row[variable] = add(row[variable], coefficient);
                }
                for (middle, source_row) in source.iter().enumerate() {
                    let variable = output * source_dimension + middle;
                    row[variable] = add(row[variable], neg(source_row[input]));
                }
                row_count += 1;
            }
        }
        block_offsets.push(row_count);
    }
    Gf9BlockSystem::try_new(30, rows, block_offsets).unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::semantic_rank::compile_semantic_rank_core;

    #[test]
    fn landed_extra_channel_matches_the_frozen_rank_core() {
        let system = q9_extra_channel_system();
        let core = compile_semantic_rank_core(&system);
        assert_eq!((system.row_count(), system.columns()), (120, 30));
        assert_eq!(core.rank, 29);
        assert_eq!(core.minimum_block_size, 3);
        assert_eq!(&*core.minimum_block_masks, &[0b0111, 0b1101, 0b1110]);
        assert_eq!(&*core.rank_loss_if_removed, &[0, 0, 1, 0]);
        let mut by_block = [0; 4];
        for &row in &core.independent_rows {
            by_block[row as usize / 30] += 1;
        }
        assert_eq!(by_block, [20, 4, 5, 0]);
        assert!(core.verify(&system));
        let mut incomplete = core.clone();
        incomplete.minimum_block_masks = core.minimum_block_masks[..2].into();
        assert!(!incomplete.verify(&system));
    }
}
