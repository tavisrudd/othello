//! C985 diagnostic for `GF(2^h)` projective action and rank/unrank.
//!
//! The candidate exploits two exact identities: base-`2^h` digit extraction
//! is shift/mask, and field addition/subtraction is XOR.  This private driver
//! measures the reusable core types without embedding a campaign fixture in
//! the public package.

use std::hint::black_box;
use std::time::Instant;

use ergodis::field::{BinarySmallField, SmallField};
use ergodis::projective::{BinaryProjectiveIndex, ProjectiveIndex};

const MAX_DIMENSION: usize = 9;
const GENERATORS: usize = 3;

fn generators(dimension: usize) -> [[u8; MAX_DIMENSION * MAX_DIMENSION]; GENERATORS] {
    let mut output = [[0_u8; MAX_DIMENSION * MAX_DIMENSION]; GENERATORS];
    for row in 0..dimension {
        output[0][row * dimension + row] = 1;
        if row + 1 < dimension {
            output[0][row * dimension + row + 1] = 1;
        }
        output[1][row * dimension + row] = (row + 1) as u8;
        output[2][row * dimension + (dimension - row - 1)] = 1;
    }
    output
}

#[inline(always)]
fn apply_binary<const H: u8>(
    field: BinarySmallField<'_, H>,
    dimension: usize,
    matrix: &[u8; MAX_DIMENSION * MAX_DIMENSION],
    input: &[u8; MAX_DIMENSION],
    output: &mut [u8; MAX_DIMENSION],
) {
    for row in 0..dimension {
        let mut sum = 0_u8;
        for col in 0..dimension {
            let coefficient = matrix[row * dimension + col];
            let value = input[col];
            if coefficient != 0 && value != 0 {
                sum = field.add(sum, field.mul(coefficient, value));
            }
        }
        output[row] = sum;
    }
}

#[inline(always)]
fn apply_table(
    field: &SmallField,
    dimension: usize,
    matrix: &[u8; MAX_DIMENSION * MAX_DIMENSION],
    input: &[u8; MAX_DIMENSION],
    output: &mut [u8; MAX_DIMENSION],
) {
    for row in 0..dimension {
        let mut sum = 0_u8;
        for col in 0..dimension {
            let coefficient = matrix[row * dimension + col];
            let value = input[col];
            if coefficient != 0 && value != 0 {
                sum = field.add(sum, field.mul(coefficient, value));
            }
        }
        output[row] = sum;
    }
}

fn run<const H: u8>(backend: &str, dimension: usize, repetitions: u64) {
    let field = SmallField::new(2, H).expect("valid binary extension field");
    let projective = ProjectiveIndex::new(&field, (dimension - 1) as u8).unwrap();
    let binary_field = field.binary_extension::<H>().unwrap();
    let binary = BinaryProjectiveIndex::<H>::new(&field, (dimension - 1) as u8).unwrap();
    assert_eq!(projective.point_count(), binary.point_count());
    let generators = generators(dimension);
    let mut point = [0_u8; MAX_DIMENSION];
    let mut image = [0_u8; MAX_DIMENSION];
    let mut index = binary.point_count() / 3;
    let mut digest = 14_695_981_039_346_656_037_u64;
    let started = Instant::now();
    for _ in 0..repetitions {
        match backend {
            "table" => projective.point(index, &mut point[..dimension]).unwrap(),
            "binary" => binary.point(index, &mut point[..dimension]).unwrap(),
            _ => panic!("backend must be table or binary"),
        }
        for generator in &generators {
            index = match backend {
                "table" => {
                    apply_table(&field, dimension, generator, &point, &mut image);
                    projective.index(&image[..dimension]).unwrap()
                }
                "binary" => {
                    apply_binary(binary_field, dimension, generator, &point, &mut image);
                    binary.index(&image[..dimension]).unwrap()
                }
                _ => unreachable!(),
            };
            digest = digest.rotate_left(9) ^ index;
        }
        black_box((index, digest));
    }
    let elapsed_ns = started.elapsed().as_nanos();
    println!(
        "{{\"backend\":\"{backend}\",\"degree\":{H},\"dimension\":{dimension},\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{},\"checksum\":{digest},\"final_index\":{index}}}",
        repetitions * GENERATORS as u64
    );
}

fn main() {
    let mut args = std::env::args().skip(1);
    let backend = args.next().expect("backend is required");
    let degree: u8 = args.next().expect("degree is required").parse().unwrap();
    let dimension: usize = args.next().expect("dimension is required").parse().unwrap();
    let repetitions: u64 = args
        .next()
        .expect("repetitions are required")
        .parse()
        .unwrap();
    assert!(args.next().is_none(), "unexpected argument");
    match degree {
        3 => run::<3>(&backend, dimension, repetitions),
        4 => run::<4>(&backend, dimension, repetitions),
        5 => run::<5>(&backend, dimension, repetitions),
        6 => run::<6>(&backend, dimension, repetitions),
        7 => run::<7>(&backend, dimension, repetitions),
        8 => run::<8>(&backend, dimension, repetitions),
        _ => panic!("degree must lie in 3..=8"),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn agrees<const H: u8>() {
        let dimension = 5;
        let field = SmallField::new(2, H).unwrap();
        let projective = ProjectiveIndex::new(&field, 4).unwrap();
        let binary_field = field.binary_extension::<H>().unwrap();
        let binary = BinaryProjectiveIndex::<H>::new(&field, 4).unwrap();
        let generators = generators(dimension);
        let samples = projective.point_count().min(4096);
        let mut table_point = [0_u8; MAX_DIMENSION];
        let mut binary_point = [0_u8; MAX_DIMENSION];
        let mut table_image = [0_u8; MAX_DIMENSION];
        let mut binary_image = [0_u8; MAX_DIMENSION];
        for index in 0..samples {
            projective
                .point(index, &mut table_point[..dimension])
                .unwrap();
            binary.point(index, &mut binary_point[..dimension]).unwrap();
            assert_eq!(table_point, binary_point);
            assert_eq!(projective.index(&table_point[..dimension]).unwrap(), index);
            assert_eq!(binary.index(&binary_point[..dimension]).unwrap(), index);
            for generator in &generators {
                apply_table(&field, dimension, generator, &table_point, &mut table_image);
                apply_binary(
                    binary_field,
                    dimension,
                    generator,
                    &binary_point,
                    &mut binary_image,
                );
                assert_eq!(table_image, binary_image);
                assert_eq!(
                    projective.index(&table_image[..dimension]).unwrap(),
                    binary.index(&binary_image[..dimension]).unwrap()
                );
            }
        }
    }

    #[test]
    fn binary_projective_specialization_matches_checked_core() {
        agrees::<3>();
        agrees::<4>();
        agrees::<5>();
        agrees::<6>();
        agrees::<7>();
        agrees::<8>();
    }
}
