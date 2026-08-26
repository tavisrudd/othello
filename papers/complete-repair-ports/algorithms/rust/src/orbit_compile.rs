use crate::{OrbitError, OrbitOption};

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct TernaryAffineProblem {
    pub option_families: Vec<Vec<OrbitOption>>,
    pub target_residue: Box<[u8]>,
    pub target_totals: Box<[i32]>,
    pub original_width: u32,
    pub compressed_width: u32,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct TernaryAffineObstruction {
    pub baseline_residue: Box<[u8]>,
    pub target_difference: Box<[u8]>,
    pub annihilator: Box<[u8]>,
    pub nonzero_pairing: u8,
    pub span_rank: u32,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum TernaryAffineCompilation {
    Feasible(TernaryAffineProblem),
    Infeasible(TernaryAffineObstruction),
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct IntegerAffineProblem {
    pub option_families: Vec<Vec<OrbitOption>>,
    pub target_residue: Box<[u8]>,
    pub target_totals: Box<[i32]>,
    pub original_width: u32,
    pub compressed_width: u32,
    pub smith_diagonal: Box<[i128]>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct IntegerLatticeObstruction {
    pub baseline_totals: Box<[i128]>,
    pub target_difference: Box<[i128]>,
    pub functional: Box<[i128]>,
    pub modulus: i128,
    pub pairing: i128,
    pub lattice_rank: u32,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum IntegerAffineCompilation {
    Feasible(IntegerAffineProblem),
    Infeasible(IntegerLatticeObstruction),
}

#[derive(Default)]
struct RrefBasis {
    rows: Vec<Vec<u8>>,
    pivots: Vec<usize>,
}

#[inline]
fn sub_multiple(value: u8, coefficient: u8, basis: u8) -> u8 {
    (value + 3 - (coefficient * basis) % 3) % 3
}

impl RrefBasis {
    fn reduce(&self, vector: &[u8]) -> (Vec<u8>, Vec<u8>) {
        let mut remainder: Vec<_> = vector.iter().map(|value| value % 3).collect();
        let mut coordinates = Vec::with_capacity(self.rows.len());
        for (&pivot, row) in self.pivots.iter().zip(&self.rows) {
            let coefficient = remainder[pivot];
            coordinates.push(coefficient);
            if coefficient != 0 {
                for (value, &basis) in remainder.iter_mut().zip(row) {
                    *value = sub_multiple(*value, coefficient, basis);
                }
            }
        }
        (coordinates, remainder)
    }

    fn insert(&mut self, vector: &[u8]) {
        let (_, mut remainder) = self.reduce(vector);
        let Some(pivot) = remainder.iter().position(|&value| value != 0) else {
            return;
        };
        if remainder[pivot] == 2 {
            for value in &mut remainder {
                *value = (*value * 2) % 3;
            }
        }
        for row in &mut self.rows {
            let coefficient = row[pivot];
            if coefficient != 0 {
                for (value, &basis) in row.iter_mut().zip(&remainder) {
                    *value = sub_multiple(*value, coefficient, basis);
                }
            }
        }
        let position = self.pivots.partition_point(|&existing| existing < pivot);
        self.pivots.insert(position, pivot);
        self.rows.insert(position, remainder);
    }

    fn annihilator_for(&self, free: usize, width: usize) -> Vec<u8> {
        let mut functional = vec![0; width];
        functional[free] = 1;
        for (&pivot, row) in self.pivots.iter().zip(&self.rows) {
            functional[pivot] = (3 - row[free]) % 3;
        }
        functional
    }
}

fn difference(left: &[u8], right: &[u8]) -> Vec<u8> {
    left.iter()
        .zip(right)
        .map(|(&a, &b)| (a % 3 + 3 - b % 3) % 3)
        .collect()
}

fn pairing(left: &[u8], right: &[u8]) -> u8 {
    left.iter()
        .zip(right)
        .fold(0u8, |sum, (&a, &b)| (sum + a * b) % 3)
}

pub fn compile_ternary_affine_constraints(
    option_families: &[Vec<OrbitOption>],
    target_residue: &[u8],
    target_totals: &[i32],
) -> Result<TernaryAffineCompilation, OrbitError> {
    if option_families.iter().any(Vec::is_empty) {
        return Err(OrbitError::EmptyFamily);
    }
    let width = target_residue.len();
    let total_width = target_totals.len();
    let mut baseline = vec![0u8; width];
    let mut basis = RrefBasis::default();

    for family in option_families {
        for option in family {
            if option.residue.len() != width || option.totals.len() != total_width {
                return Err(OrbitError::DimensionMismatch);
            }
        }
        let family_baseline = &family[0].residue;
        for (sum, &value) in baseline.iter_mut().zip(family_baseline) {
            *sum = (*sum + value % 3) % 3;
        }
        for option in family.iter().skip(1) {
            basis.insert(&difference(&option.residue, family_baseline));
        }
    }

    let normalized_target: Vec<_> = target_residue.iter().map(|value| value % 3).collect();
    let target_difference = difference(&normalized_target, &baseline);
    let (compressed_target, remainder) = basis.reduce(&target_difference);
    if let Some(free) = remainder.iter().position(|&value| value != 0) {
        let annihilator = basis.annihilator_for(free, width);
        let nonzero_pairing = pairing(&annihilator, &target_difference);
        debug_assert_ne!(nonzero_pairing, 0);
        return Ok(TernaryAffineCompilation::Infeasible(
            TernaryAffineObstruction {
                baseline_residue: baseline.into_boxed_slice(),
                target_difference: target_difference.into_boxed_slice(),
                annihilator: annihilator.into_boxed_slice(),
                nonzero_pairing,
                span_rank: u32::try_from(basis.rows.len()).map_err(|_| OrbitError::TooLarge)?,
            },
        ));
    }

    let mut compressed_families = Vec::with_capacity(option_families.len());
    for family in option_families {
        let family_baseline = &family[0].residue;
        let mut compressed = Vec::with_capacity(family.len());
        for option in family {
            let (coordinates, option_remainder) =
                basis.reduce(&difference(&option.residue, family_baseline));
            debug_assert!(option_remainder.iter().all(|&value| value == 0));
            compressed.push(OrbitOption {
                label: option.label,
                residue: coordinates.into_boxed_slice(),
                totals: option.totals.clone(),
            });
        }
        compressed_families.push(compressed);
    }

    Ok(TernaryAffineCompilation::Feasible(TernaryAffineProblem {
        option_families: compressed_families,
        target_residue: compressed_target.into_boxed_slice(),
        target_totals: target_totals.to_vec().into_boxed_slice(),
        original_width: u32::try_from(width).map_err(|_| OrbitError::TooLarge)?,
        compressed_width: u32::try_from(basis.rows.len()).map_err(|_| OrbitError::TooLarge)?,
    }))
}

fn checked_row_subtract(
    matrix: &mut [Vec<i128>],
    transform: &mut [Vec<i128>],
    target: usize,
    source: usize,
    quotient: i128,
) -> Result<(), OrbitError> {
    for column in 0..matrix[target].len() {
        let product = quotient
            .checked_mul(matrix[source][column])
            .ok_or(OrbitError::TooLarge)?;
        matrix[target][column] = matrix[target][column]
            .checked_sub(product)
            .ok_or(OrbitError::TooLarge)?;
    }
    for column in 0..transform[target].len() {
        let product = quotient
            .checked_mul(transform[source][column])
            .ok_or(OrbitError::TooLarge)?;
        transform[target][column] = transform[target][column]
            .checked_sub(product)
            .ok_or(OrbitError::TooLarge)?;
    }
    Ok(())
}

fn checked_column_subtract(
    matrix: &mut [Vec<i128>],
    target: usize,
    source: usize,
    quotient: i128,
) -> Result<(), OrbitError> {
    for row in matrix {
        let product = quotient
            .checked_mul(row[source])
            .ok_or(OrbitError::TooLarge)?;
        row[target] = row[target]
            .checked_sub(product)
            .ok_or(OrbitError::TooLarge)?;
    }
    Ok(())
}

fn smith_left_transform(
    mut matrix: Vec<Vec<i128>>,
) -> Result<(Vec<i128>, Vec<Vec<i128>>), OrbitError> {
    let row_count = matrix.len();
    let column_count = matrix.first().map_or(0, Vec::len);
    let mut transform = vec![vec![0i128; row_count]; row_count];
    for (index, row) in transform.iter_mut().enumerate() {
        row[index] = 1;
    }
    let mut diagonal = Vec::new();
    for pivot_index in 0..row_count.min(column_count) {
        let Some((pivot_row, pivot_column)) = (pivot_index..row_count)
            .flat_map(|row| (pivot_index..column_count).map(move |column| (row, column)))
            .filter(|&(row, column)| matrix[row][column] != 0)
            .min_by_key(|&(row, column)| matrix[row][column].unsigned_abs())
        else {
            break;
        };
        matrix.swap(pivot_index, pivot_row);
        transform.swap(pivot_index, pivot_row);
        for row in &mut matrix {
            row.swap(pivot_index, pivot_column);
        }

        loop {
            let pivot = matrix[pivot_index][pivot_index];
            let mut restarted = false;
            for row in pivot_index + 1..row_count {
                if matrix[row][pivot_index] == 0 {
                    continue;
                }
                let quotient = matrix[row][pivot_index]
                    .checked_div(pivot)
                    .ok_or(OrbitError::TooLarge)?;
                checked_row_subtract(&mut matrix, &mut transform, row, pivot_index, quotient)?;
                if matrix[row][pivot_index] != 0 {
                    matrix.swap(row, pivot_index);
                    transform.swap(row, pivot_index);
                }
                restarted = true;
                break;
            }
            if restarted {
                continue;
            }
            for column in pivot_index + 1..column_count {
                if matrix[pivot_index][column] == 0 {
                    continue;
                }
                let quotient = matrix[pivot_index][column]
                    .checked_div(matrix[pivot_index][pivot_index])
                    .ok_or(OrbitError::TooLarge)?;
                checked_column_subtract(&mut matrix, column, pivot_index, quotient)?;
                if matrix[pivot_index][column] != 0 {
                    for row in &mut matrix {
                        row.swap(column, pivot_index);
                    }
                }
                restarted = true;
                break;
            }
            if restarted {
                continue;
            }
            let pivot = matrix[pivot_index][pivot_index];
            let offender = (pivot_index + 1..row_count).find_map(|row| {
                (pivot_index + 1..column_count)
                    .find(|&column| matrix[row][column] % pivot != 0)
                    .map(|column| (row, column))
            });
            if let Some((row, _)) = offender {
                checked_row_subtract(&mut matrix, &mut transform, pivot_index, row, -1)?;
                continue;
            }
            break;
        }
        if matrix[pivot_index][pivot_index] < 0 {
            checked_row_subtract(&mut matrix, &mut transform, pivot_index, pivot_index, 2)?;
        }
        diagonal.push(matrix[pivot_index][pivot_index]);
    }
    debug_assert!(diagonal.windows(2).all(|pair| pair[1] % pair[0] == 0));
    Ok((diagonal, transform))
}

fn transform_integer_vector(
    transform: &[Vec<i128>],
    vector: &[i128],
) -> Result<Vec<i128>, OrbitError> {
    transform
        .iter()
        .map(|row| {
            row.iter().zip(vector).try_fold(0i128, |sum, (&a, &b)| {
                sum.checked_add(a.checked_mul(b).ok_or(OrbitError::TooLarge)?)
                    .ok_or(OrbitError::TooLarge)
            })
        })
        .collect()
}

pub fn compile_integer_affine_constraints(
    option_families: &[Vec<OrbitOption>],
    target_residue: &[u8],
    target_totals: &[i32],
) -> Result<IntegerAffineCompilation, OrbitError> {
    if option_families.iter().any(Vec::is_empty) {
        return Err(OrbitError::EmptyFamily);
    }
    let residue_width = target_residue.len();
    let width = target_totals.len();
    let mut baseline = vec![0i128; width];
    let mut differences = Vec::new();
    for family in option_families {
        for option in family {
            if option.residue.len() != residue_width || option.totals.len() != width {
                return Err(OrbitError::DimensionMismatch);
            }
        }
        for (sum, &value) in baseline.iter_mut().zip(&family[0].totals) {
            *sum = sum
                .checked_add(i128::from(value))
                .ok_or(OrbitError::TooLarge)?;
        }
        for option in family.iter().skip(1) {
            differences.push(
                option
                    .totals
                    .iter()
                    .zip(&family[0].totals)
                    .map(|(&value, &base)| i128::from(value) - i128::from(base))
                    .collect::<Vec<_>>(),
            );
        }
    }
    let matrix: Vec<Vec<i128>> = (0..width)
        .map(|row| differences.iter().map(|column| column[row]).collect())
        .collect();
    let (diagonal, transform) = smith_left_transform(matrix)?;
    let target_difference: Vec<_> = target_totals
        .iter()
        .zip(&baseline)
        .map(|(&target, &base)| i128::from(target) - base)
        .collect();
    let transformed_target = transform_integer_vector(&transform, &target_difference)?;
    let obstruction_index = diagonal
        .iter()
        .enumerate()
        .find(|&(index, divisor)| transformed_target[index] % divisor != 0)
        .map(|(index, _)| index)
        .or_else(|| (diagonal.len()..width).find(|&index| transformed_target[index] != 0));
    if let Some(index) = obstruction_index {
        let modulus = diagonal.get(index).copied().unwrap_or(0);
        let pairing = if modulus == 0 {
            transformed_target[index]
        } else {
            transformed_target[index].rem_euclid(modulus)
        };
        return Ok(IntegerAffineCompilation::Infeasible(
            IntegerLatticeObstruction {
                baseline_totals: baseline.into_boxed_slice(),
                target_difference: target_difference.into_boxed_slice(),
                functional: transform[index].clone().into_boxed_slice(),
                modulus,
                pairing,
                lattice_rank: u32::try_from(diagonal.len()).map_err(|_| OrbitError::TooLarge)?,
            },
        ));
    }

    let compressed_target: Vec<i32> = diagonal
        .iter()
        .enumerate()
        .map(|(index, &divisor)| {
            i32::try_from(transformed_target[index] / divisor).map_err(|_| OrbitError::TooLarge)
        })
        .collect::<Result<_, _>>()?;
    let mut compressed_families = Vec::with_capacity(option_families.len());
    for family in option_families {
        let base: Vec<_> = family[0]
            .totals
            .iter()
            .map(|&value| i128::from(value))
            .collect();
        let mut compressed = Vec::with_capacity(family.len());
        for option in family {
            let difference: Vec<_> = option
                .totals
                .iter()
                .zip(&base)
                .map(|(&value, &base)| i128::from(value) - base)
                .collect();
            let transformed = transform_integer_vector(&transform, &difference)?;
            let totals: Vec<i32> = diagonal
                .iter()
                .enumerate()
                .map(|(index, &divisor)| {
                    debug_assert_eq!(transformed[index] % divisor, 0);
                    i32::try_from(transformed[index] / divisor).map_err(|_| OrbitError::TooLarge)
                })
                .collect::<Result<_, _>>()?;
            compressed.push(OrbitOption {
                label: option.label,
                residue: option.residue.clone(),
                totals: totals.into_boxed_slice(),
            });
        }
        compressed_families.push(compressed);
    }
    Ok(IntegerAffineCompilation::Feasible(IntegerAffineProblem {
        option_families: compressed_families,
        target_residue: target_residue.to_vec().into_boxed_slice(),
        target_totals: compressed_target.into_boxed_slice(),
        original_width: u32::try_from(width).map_err(|_| OrbitError::TooLarge)?,
        compressed_width: u32::try_from(diagonal.len()).map_err(|_| OrbitError::TooLarge)?,
        smith_diagonal: diagonal.into_boxed_slice(),
    }))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::ternary_orbit_syndrome_meet_in_middle;
    use proptest::prelude::*;

    fn option(label: u32, residue: &[u8], total: i32) -> OrbitOption {
        OrbitOption {
            label,
            residue: residue.into(),
            totals: vec![total].into_boxed_slice(),
        }
    }

    fn gcd(mut left: i128, mut right: i128) -> i128 {
        left = left.abs();
        right = right.abs();
        while right != 0 {
            (left, right) = (right, left % right);
        }
        left
    }

    fn determinant_three(matrix: &[Vec<i128>]) -> i128 {
        matrix[0][0] * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
            - matrix[0][1] * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
            + matrix[0][2] * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    }

    #[test]
    fn compresses_redundant_coordinates_and_preserves_witness() {
        let families = vec![
            vec![option(10, &[1, 2, 0, 1], 0), option(11, &[2, 1, 0, 2], 1)],
            vec![option(20, &[0, 1, 1, 2], 0), option(21, &[1, 0, 1, 0], 1)],
        ];
        let TernaryAffineCompilation::Feasible(compiled) =
            compile_ternary_affine_constraints(&families, &[2, 2, 1, 1], &[1]).unwrap()
        else {
            panic!("target should lie in the affine option span");
        };
        assert_eq!(compiled.original_width, 4);
        assert_eq!(compiled.compressed_width, 1);
        let result = ternary_orbit_syndrome_meet_in_middle(
            &compiled.option_families,
            &compiled.target_residue,
            &compiled.target_totals,
        )
        .unwrap();
        assert_eq!(result.choices.as_deref(), Some(&[10, 21][..]));
    }

    #[test]
    fn returns_checkable_annihilator_for_excluded_target() {
        let families = vec![vec![option(1, &[0, 0, 0], 0), option(2, &[1, 2, 0], 0)]];
        let TernaryAffineCompilation::Infeasible(obstruction) =
            compile_ternary_affine_constraints(&families, &[0, 0, 1], &[0]).unwrap()
        else {
            panic!("target should be outside the affine option span");
        };
        for option in &families[0] {
            let delta = difference(&option.residue, &families[0][0].residue);
            assert_eq!(pairing(&obstruction.annihilator, &delta), 0);
        }
        assert_eq!(
            pairing(&obstruction.annihilator, &obstruction.target_difference),
            obstruction.nonzero_pairing
        );
        assert_ne!(obstruction.nonzero_pairing, 0);
    }

    #[test]
    fn drops_a_forced_zero_rank_syndrome() {
        let families = vec![vec![option(1, &[2, 1], 3)], vec![option(2, &[1, 2], 4)]];
        let TernaryAffineCompilation::Feasible(compiled) =
            compile_ternary_affine_constraints(&families, &[0, 0], &[7]).unwrap()
        else {
            panic!("forced target should be feasible");
        };
        assert_eq!(compiled.compressed_width, 0);
        assert!(compiled.target_residue.is_empty());
        assert!(compiled
            .option_families
            .iter()
            .flatten()
            .all(|option| option.residue.is_empty()));
    }

    #[test]
    fn binary_orbit_families_have_rank_at_most_the_family_count() {
        const WIDTH: usize = 102;
        const FAMILIES: usize = 32;
        let families: Vec<_> = (0..FAMILIES)
            .map(|family| {
                let mut residue = vec![0; WIDTH];
                for (coordinate, value) in residue.iter_mut().enumerate() {
                    *value = ((family * 17 + coordinate * 11 + coordinate / 7) % 3) as u8;
                }
                vec![
                    option((2 * family) as u32, &[0; WIDTH], 0),
                    option((2 * family + 1) as u32, &residue, 1),
                ]
            })
            .collect();
        let target = vec![0u8; WIDTH];
        let TernaryAffineCompilation::Feasible(compiled) =
            compile_ternary_affine_constraints(&families, &target, &[0]).unwrap()
        else {
            panic!("the all-baseline target must be feasible");
        };
        assert!(compiled.compressed_width <= FAMILIES as u32);
        assert!(compiled.compressed_width.div_ceil(21) <= 2);
    }

    #[test]
    fn smith_compilation_preserves_coupled_integer_lattice() {
        let families = vec![
            vec![
                OrbitOption {
                    label: 10,
                    residue: Box::new([]),
                    totals: vec![0, 0].into_boxed_slice(),
                },
                OrbitOption {
                    label: 11,
                    residue: Box::new([]),
                    totals: vec![2, 4].into_boxed_slice(),
                },
            ],
            vec![
                OrbitOption {
                    label: 20,
                    residue: Box::new([]),
                    totals: vec![0, 0].into_boxed_slice(),
                },
                OrbitOption {
                    label: 21,
                    residue: Box::new([]),
                    totals: vec![6, 10].into_boxed_slice(),
                },
            ],
        ];
        let IntegerAffineCompilation::Feasible(compiled) =
            compile_integer_affine_constraints(&families, &[], &[8, 14]).unwrap()
        else {
            panic!("sum of the two nonbaseline differences must be feasible");
        };
        assert_eq!(compiled.smith_diagonal.as_ref(), &[2, 2]);
        let result = ternary_orbit_syndrome_meet_in_middle(
            &compiled.option_families,
            &compiled.target_residue,
            &compiled.target_totals,
        )
        .unwrap();
        assert_eq!(result.choices.as_deref(), Some(&[11, 21][..]));

        let IntegerAffineCompilation::Infeasible(obstruction) =
            compile_integer_affine_constraints(&families, &[], &[1, 2]).unwrap()
        else {
            panic!("odd first coordinate must violate the lattice congruence");
        };
        assert!(obstruction.modulus > 1);
        assert_ne!(obstruction.pairing, 0);
    }

    #[test]
    fn smith_compilation_certifies_a_rational_span_obstruction() {
        let families = vec![vec![
            OrbitOption {
                label: 1,
                residue: Box::new([]),
                totals: vec![0, 0].into_boxed_slice(),
            },
            OrbitOption {
                label: 2,
                residue: Box::new([]),
                totals: vec![1, 2].into_boxed_slice(),
            },
        ]];
        let IntegerAffineCompilation::Infeasible(obstruction) =
            compile_integer_affine_constraints(&families, &[], &[0, 1]).unwrap()
        else {
            panic!("target lies outside the rational option-difference span");
        };
        assert_eq!(obstruction.modulus, 0);
        assert_ne!(obstruction.pairing, 0);
    }

    proptest! {
        #[test]
        fn smith_transform_replays_random_three_by_three_matrices(
            entries in prop::collection::vec(-5i16..=5, 9)
        ) {
            let original: Vec<Vec<i128>> = entries
                .chunks_exact(3)
                .map(|row| row.iter().map(|&value| i128::from(value)).collect())
                .collect();
            let (diagonal, transform) = smith_left_transform(original.clone()).unwrap();
            for column in 0..3 {
                let source: Vec<_> = original.iter().map(|row| row[column]).collect();
                let transformed = transform_integer_vector(&transform, &source).unwrap();
                for (index, &divisor) in diagonal.iter().enumerate() {
                    prop_assert_eq!(transformed[index] % divisor, 0);
                }
                prop_assert!(transformed[diagonal.len()..].iter().all(|&value| value == 0));
            }
            prop_assert_eq!(determinant_three(&transform).abs(), 1);
            let determinant = determinant_three(&original);
            if determinant != 0 {
                prop_assert_eq!(diagonal.len(), 3);
                prop_assert_eq!(diagonal.iter().product::<i128>(), determinant.abs());
            }
        }

        #[test]
        fn smith_diagonal_matches_rectangular_determinantal_divisors(
            entries in prop::collection::vec(-7i16..=7, 6)
        ) {
            let matrix = vec![
                entries[0..3].iter().map(|&value| i128::from(value)).collect(),
                entries[3..6].iter().map(|&value| i128::from(value)).collect(),
            ];
            let (diagonal, transform) = smith_left_transform(matrix.clone()).unwrap();
            let minors = [
                matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0],
                matrix[0][0] * matrix[1][2] - matrix[0][2] * matrix[1][0],
                matrix[0][1] * matrix[1][2] - matrix[0][2] * matrix[1][1],
            ];
            let maximal_divisor = minors.into_iter().fold(0, gcd);
            let expected_rank = if maximal_divisor != 0 {
                2
            } else if matrix.iter().flatten().any(|&value| value != 0) {
                1
            } else {
                0
            };
            prop_assert_eq!(diagonal.len(), expected_rank);
            let expected_divisor = if expected_rank == 2 {
                maximal_divisor
            } else if expected_rank == 1 {
                matrix.iter().flatten().copied().fold(0, gcd)
            } else {
                1
            };
            prop_assert_eq!(diagonal.iter().product::<i128>(), expected_divisor);
            let transform_determinant =
                transform[0][0] * transform[1][1] - transform[0][1] * transform[1][0];
            prop_assert_eq!(transform_determinant.abs(), 1);
        }
    }
}
