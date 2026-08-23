//! Exact certificate generator for unit-fixed self-dual Weyl positions.
//!
//! The finite domain is the eight monomial relative positions which fix the
//! unit/top hyperbolic pair and permute or reverse the two middle hyperbolic
//! pairs.  For each position the program transports the complete
//! multiplication tensor of `Q[r][x,e]/(x^3-r^3,e^2)` in both output and input
//! indices.  It checks integrality, the special binary cubic, hard Lefschetz,
//! and whether the transported divisor generates the reduced cubic quotient.
//! The modes `--json` and `--lean` emit canonical certificate artifacts.

use std::collections::BTreeMap;
use std::convert::TryInto;
use std::env;

const N: usize = 6;
const WEIGHT: [i32; N] = [0, 1, 1, 2, 2, 3];
const PAIR: [usize; N] = [5, 4, 3, 2, 1, 0];

#[derive(Clone, Debug, Default, Eq, PartialEq)]
struct Laurent(BTreeMap<i32, i64>);

impl Laurent {
    fn monomial(exponent: i32, coefficient: i64) -> Self {
        let mut terms = BTreeMap::new();
        if coefficient != 0 {
            terms.insert(exponent, coefficient);
        }
        Self(terms)
    }

    fn add(&self, right: &Self) -> Self {
        let mut result = self.0.clone();
        for (&exponent, &coefficient) in &right.0 {
            *result.entry(exponent).or_default() += coefficient;
        }
        result.retain(|_, coefficient| *coefficient != 0);
        Self(result)
    }

    fn mul(&self, right: &Self) -> Self {
        let mut result = BTreeMap::new();
        for (&left_exponent, &left_coefficient) in &self.0 {
            for (&right_exponent, &right_coefficient) in &right.0 {
                *result.entry(left_exponent + right_exponent).or_default() +=
                    left_coefficient * right_coefficient;
            }
        }
        result.retain(|_, coefficient| *coefficient != 0);
        Self(result)
    }

    fn derivative_at_one(&self) -> i64 {
        self.0
            .iter()
            .map(|(&exponent, &coefficient)| i64::from(exponent) * coefficient)
            .sum()
    }

    fn valuation(&self) -> Option<i32> {
        self.0.first_key_value().map(|(&exponent, _)| exponent)
    }

    fn constant(&self) -> i64 {
        self.0.get(&0).copied().unwrap_or(0)
    }

    fn at_one(&self) -> i64 {
        self.0.values().sum()
    }
}

type Matrix = Vec<Vec<Laurent>>;

fn zero_matrix() -> Matrix {
    vec![vec![Laurent::default(); N]; N]
}

fn identity_matrix() -> Matrix {
    let mut result = zero_matrix();
    for (index, row) in result.iter_mut().enumerate() {
        row[index] = Laurent::monomial(0, 1);
    }
    result
}

fn add_matrix(left: &Matrix, right: &Matrix) -> Matrix {
    let mut result = zero_matrix();
    for i in 0..N {
        for j in 0..N {
            result[i][j] = left[i][j].add(&right[i][j]);
        }
    }
    result
}

fn scale_matrix(scalar: &Laurent, matrix: &Matrix) -> Matrix {
    let mut result = zero_matrix();
    for i in 0..N {
        for j in 0..N {
            result[i][j] = scalar.mul(&matrix[i][j]);
        }
    }
    result
}

fn mul_matrix(left: &Matrix, right: &Matrix) -> Matrix {
    let mut result = zero_matrix();
    for i in 0..N {
        for j in 0..N {
            for k in 0..N {
                result[i][j] = result[i][j].add(&left[i][k].mul(&right[k][j]));
            }
        }
    }
    result
}

fn transpose(matrix: &Matrix) -> Matrix {
    let mut result = zero_matrix();
    for i in 0..N {
        for j in 0..N {
            result[i][j] = matrix[j][i].clone();
        }
    }
    result
}

fn basis_pair(index: usize) -> (usize, usize) {
    match index {
        0 => (0, 0),
        1 => (0, 1),
        2 => (1, 0),
        3 => (1, 1),
        4 => (2, 0),
        5 => (2, 1),
        _ => unreachable!(),
    }
}

fn basis_index(x_power: usize, e_power: usize) -> usize {
    match (x_power, e_power) {
        (0, 0) => 0,
        (0, 1) => 1,
        (1, 0) => 2,
        (1, 1) => 3,
        (2, 0) => 4,
        (2, 1) => 5,
        _ => unreachable!(),
    }
}

fn basis_multiplication(multiplier: usize) -> Matrix {
    let mut result = zero_matrix();
    let (left_x, left_e) = basis_pair(multiplier);
    for column in 0..N {
        let (right_x, right_e) = basis_pair(column);
        if left_e + right_e >= 2 {
            continue;
        }
        let total_x = left_x + right_x;
        let (reduced_x, r_power) = if total_x >= 3 {
            (total_x - 3, 3)
        } else {
            (total_x, 0)
        };
        let row = basis_index(reduced_x, left_e + right_e);
        result[row][column] = Laurent::monomial(r_power, 1);
    }
    result
}

fn basis_multiplications() -> Vec<Matrix> {
    (0..N).map(basis_multiplication).collect()
}

fn pairing_matrix() -> Matrix {
    let mut result = zero_matrix();
    for i in 0..N {
        result[i][PAIR[i]] = Laurent::monomial(0, 1);
    }
    result
}

fn weyl_permutation(swap_pairs: bool, reverse_first: bool, reverse_second: bool) -> [usize; N] {
    let source_pairs = [(1usize, 4usize), (2usize, 3usize)];
    let target_pairs = if swap_pairs {
        [source_pairs[1], source_pairs[0]]
    } else {
        source_pairs
    };
    let reversals = [reverse_first, reverse_second];
    let mut sigma = [0usize, 1, 2, 3, 4, 5];
    sigma[0] = 0;
    sigma[5] = 5;
    for pair_index in 0..2 {
        let (source_low, source_high) = source_pairs[pair_index];
        let (target_low, target_high) = target_pairs[pair_index];
        if reversals[pair_index] {
            sigma[source_low] = target_high;
            sigma[source_high] = target_low;
        } else {
            sigma[source_low] = target_low;
            sigma[source_high] = target_high;
        }
    }
    sigma
}

fn calibration(sigma: &[usize; N]) -> Matrix {
    let mut result = zero_matrix();
    for source in 0..N {
        let target = sigma[source];
        result[target][source] = Laurent::monomial(WEIGHT[source] - WEIGHT[target], 1);
    }
    result
}

fn inverse_calibration(sigma: &[usize; N]) -> Matrix {
    let mut inverse_sigma = [0usize; N];
    for source in 0..N {
        inverse_sigma[sigma[source]] = source;
    }
    calibration(&inverse_sigma)
}

fn transported_tensor(sigma: &[usize; N]) -> Vec<Matrix> {
    let calibration = calibration(sigma);
    let inverse = inverse_calibration(sigma);
    let old = basis_multiplications();
    let mut result = Vec::new();
    for input in 0..N {
        let mut old_multiplication = zero_matrix();
        for old_input in 0..N {
            old_multiplication = add_matrix(
                &old_multiplication,
                &scale_matrix(&inverse[old_input][input], &old[old_input]),
            );
        }
        result.push(mul_matrix(
            &mul_matrix(&calibration, &old_multiplication),
            &inverse,
        ));
    }
    result
}

fn is_integral(tensor: &[Matrix]) -> bool {
    tensor.iter().all(|matrix| {
        matrix
            .iter()
            .flatten()
            .all(|entry| entry.valuation().is_none_or(|valuation| valuation >= 0))
    })
}

fn unit_law(tensor: &[Matrix]) -> bool {
    tensor[0] == identity_matrix()
}

fn hard_lefschetz_polynomial(tensor: &[Matrix]) -> (i64, i64, i64) {
    let coefficient = |matrix: &Matrix, row: usize, column: usize| matrix[row][column].constant();
    let determinant = |alpha: i64, beta: i64| {
        let entry = |row: usize, column: usize| {
            alpha * coefficient(&tensor[1], row, column)
                + beta * coefficient(&tensor[2], row, column)
        };
        entry(3, 1) * entry(4, 2) - entry(3, 2) * entry(4, 1)
    };
    let alpha_squared = determinant(1, 0);
    let beta_squared = determinant(0, 1);
    let mixed = determinant(1, 1) - alpha_squared - beta_squared;
    (alpha_squared, mixed, beta_squared)
}

fn special_product(tensor: &[Matrix], left: usize, right: usize) -> [i64; N] {
    std::array::from_fn(|row| tensor[left][row][right].constant())
}

fn special_triple_product(tensor: &[Matrix], first: usize, second: usize, third: usize) -> i64 {
    let product = special_product(tensor, second, third);
    (0..N)
        .map(|index| tensor[first][5][index].constant() * product[index])
        .sum()
}

fn binary_cubic(tensor: &[Matrix]) -> (i64, i64, i64, i64) {
    (
        special_triple_product(tensor, 1, 1, 1),
        special_triple_product(tensor, 1, 1, 2),
        special_triple_product(tensor, 1, 2, 2),
        special_triple_product(tensor, 2, 2, 2),
    )
}

fn first_conformal_defect(tensor: &[Matrix]) -> Option<(usize, usize, i64)> {
    let euler = add_matrix(
        &scale_matrix(&Laurent::monomial(0, 2), &tensor[1]),
        &scale_matrix(&Laurent::monomial(0, 3), &tensor[2]),
    );
    let divisor = &tensor[2];
    for row in 0..N {
        for column in 0..N {
            let derivative = euler[row][column].derivative_at_one();
            let grading_commutator =
                i64::from(WEIGHT[column] - WEIGHT[row]) * divisor[row][column].at_one();
            let defect = derivative - 3 * divisor[row][column].at_one() - 3 * grading_commutator;
            if defect != 0 {
                return Some((row, column, defect));
            }
        }
    }
    None
}

fn coweight(sigma: &[usize; N]) -> [i32; N] {
    let mut result: Vec<_> = (0..N)
        .map(|source| WEIGHT[source] - WEIGHT[sigma[source]])
        .collect();
    result.sort();
    result.try_into().expect("rank-six coweight")
}

fn inverse_source(sigma: &[usize; N], target: usize) -> usize {
    (0..N)
        .find(|&source| sigma[source] == target)
        .expect("permutation target")
}

fn divisor_generates_cubic_quotient(sigma: &[usize; N]) -> bool {
    let source = inverse_source(sigma, 2);
    let (x_power, e_power) = basis_pair(source);
    e_power == 0 && x_power != 0
}

fn compose_permutations(left: &[usize; N], right: &[usize; N]) -> [usize; N] {
    std::array::from_fn(|source| left[right[source]])
}

#[derive(Clone, Debug, Eq, PartialEq)]
struct PositionData {
    index: usize,
    swap_pairs: bool,
    reverse_first: bool,
    reverse_second: bool,
    permutation: [usize; N],
    inverse_permutation: [usize; N],
    coweight: [i32; N],
    divisor_old_index: usize,
    divisor_generates: bool,
    representative: Option<usize>,
    special_binary_cubic: (i64, i64, i64, i64),
    hard_lefschetz: (i64, i64, i64),
}

fn enumerate_positions() -> Vec<PositionData> {
    let mut partial = Vec::new();
    for swap_pairs in [false, true] {
        for reverse_first in [false, true] {
            for reverse_second in [false, true] {
                let permutation = weyl_permutation(swap_pairs, reverse_first, reverse_second);
                let calibration = calibration(&permutation);
                let inverse = inverse_calibration(&permutation);
                assert_eq!(mul_matrix(&calibration, &inverse), identity_matrix());
                assert_eq!(
                    mul_matrix(
                        &mul_matrix(&transpose(&calibration), &pairing_matrix()),
                        &calibration
                    ),
                    pairing_matrix()
                );
                let tensor = transported_tensor(&permutation);
                assert!(is_integral(&tensor));
                assert!(unit_law(&tensor));
                partial.push((
                    swap_pairs,
                    reverse_first,
                    reverse_second,
                    permutation,
                    binary_cubic(&tensor),
                    hard_lefschetz_polynomial(&tensor),
                ));
            }
        }
    }

    assert_eq!(partial.len(), 8);
    let identity = partial[0].3;
    let distinct_representative = partial[2].3;
    let kummer_involution = partial[7].3;
    let base_tensor = basis_multiplications();
    assert_eq!(transported_tensor(&kummer_involution), base_tensor);
    assert_eq!(first_conformal_defect(&base_tensor), None);

    partial
        .into_iter()
        .enumerate()
        .map(
            |(
                index,
                (
                    swap_pairs,
                    reverse_first,
                    reverse_second,
                    permutation,
                    special_binary_cubic,
                    hard_lefschetz,
                ),
            )| {
                let divisor_generates = divisor_generates_cubic_quotient(&permutation);
                let representative = if !divisor_generates {
                    None
                } else if permutation == identity
                    || permutation == compose_permutations(&identity, &kummer_involution)
                {
                    Some(0)
                } else if permutation == distinct_representative
                    || permutation
                        == compose_permutations(&distinct_representative, &kummer_involution)
                {
                    Some(2)
                } else {
                    panic!("generating position outside the two certified orbits")
                };
                PositionData {
                    index,
                    swap_pairs,
                    reverse_first,
                    reverse_second,
                    permutation,
                    inverse_permutation: std::array::from_fn(|target| {
                        inverse_source(&permutation, target)
                    }),
                    coweight: coweight(&permutation),
                    divisor_old_index: inverse_source(&permutation, 2),
                    divisor_generates,
                    representative,
                    special_binary_cubic,
                    hard_lefschetz,
                }
            },
        )
        .collect()
}

fn json_array<T: std::fmt::Display>(entries: &[T]) -> String {
    format!(
        "[{}]",
        entries
            .iter()
            .map(ToString::to_string)
            .collect::<Vec<_>>()
            .join(", ")
    )
}

fn emit_json(positions: &[PositionData]) {
    println!("{{");
    println!("  \"schema\": \"unit-fixed-weyl-coweight-certificate-v1\",");
    println!("  \"rank\": 6,");
    println!("  \"weights\": [0, 1, 1, 2, 2, 3],");
    println!("  \"kummer_involution_position\": 7,");
    println!("  \"representative_positions\": [0, 2],");
    println!("  \"positions\": [");
    for (offset, position) in positions.iter().enumerate() {
        println!("    {{");
        println!("      \"index\": {},", position.index);
        println!("      \"swap_pairs\": {},", position.swap_pairs);
        println!("      \"reverse_first\": {},", position.reverse_first);
        println!("      \"reverse_second\": {},", position.reverse_second);
        println!(
            "      \"permutation\": {},",
            json_array(&position.permutation)
        );
        println!(
            "      \"inverse_permutation\": {},",
            json_array(&position.inverse_permutation)
        );
        println!("      \"coweight\": {},", json_array(&position.coweight));
        println!(
            "      \"divisor_old_basis_index\": {},",
            position.divisor_old_index
        );
        println!(
            "      \"divisor_generates_cubic_quotient\": {},",
            position.divisor_generates
        );
        match position.representative {
            Some(representative) => {
                println!("      \"representative_mod_kummer_involution\": {representative},")
            }
            None => println!("      \"representative_mod_kummer_involution\": null,"),
        }
        let cubic = [
            position.special_binary_cubic.0,
            position.special_binary_cubic.1,
            position.special_binary_cubic.2,
            position.special_binary_cubic.3,
        ];
        let hard_lefschetz = [
            position.hard_lefschetz.0,
            position.hard_lefschetz.1,
            position.hard_lefschetz.2,
        ];
        println!("      \"special_binary_cubic\": {},", json_array(&cubic));
        println!(
            "      \"hard_lefschetz_determinant\": {}",
            json_array(&hard_lefschetz)
        );
        println!(
            "    }}{}",
            if offset + 1 == positions.len() {
                ""
            } else {
                ","
            }
        );
    }
    println!("  ]");
    println!("}}");
}

fn lean_bool(value: bool) -> &'static str {
    if value {
        "true"
    } else {
        "false"
    }
}

fn emit_lean_vector<T: std::fmt::Display>(name: &str, codomain: &str, values: &[T]) {
    println!("def {name} : Position → {codomain} :=");
    println!("  ![{}]\n", json_array(values).trim_matches(['[', ']']));
}

fn emit_lean(positions: &[PositionData]) {
    println!("import Mathlib\n");
    println!("/-!");
    println!("# Generated data for the unit-fixed Weyl-position certificate\n");
    println!("This file is generated by `scripts/native_coweight_scan.rs`.");
    println!("It records the eight unit/top-fixed monomial positions and their");
    println!("exact coweight, divisor-source, cubic, and Lefschetz data.");
    println!("The importing checker reconstructs the finite correspondence.");
    println!("-/\n");
    println!("namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.Generated.UnitFixedWeylCoweightData\n");
    println!("/-- Index of one of the eight monomial Weyl positions. -/");
    println!("abbrev Position := Fin 8");
    println!("/-- Index of one of the six graded basis monomials. -/");
    println!("abbrev Index := Fin 6\n");

    let swaps = positions
        .iter()
        .map(|position| lean_bool(position.swap_pairs))
        .collect::<Vec<_>>();
    let reverse_first = positions
        .iter()
        .map(|position| lean_bool(position.reverse_first))
        .collect::<Vec<_>>();
    let reverse_second = positions
        .iter()
        .map(|position| lean_bool(position.reverse_second))
        .collect::<Vec<_>>();
    println!("/-- Whether the two middle hyperbolic pairs are exchanged. -/");
    emit_lean_vector("swapPairs", "Bool", &swaps);
    println!("/-- Whether the first source hyperbolic pair is reversed. -/");
    emit_lean_vector("reverseFirst", "Bool", &reverse_first);
    println!("/-- Whether the second source hyperbolic pair is reversed. -/");
    emit_lean_vector("reverseSecond", "Bool", &reverse_second);

    println!("/-- Permutation of the six graded basis monomials. -/");
    println!("def permutation : Position → Index → Index :=");
    println!("  ![");
    for (offset, position) in positions.iter().enumerate() {
        println!(
            "    {}{}",
            json_array(&position.permutation)
                .replace('[', "![")
                .replace(']', "]"),
            if offset + 1 == positions.len() {
                ""
            } else {
                ","
            }
        );
    }
    println!("  ]\n");

    println!("/-- Sorted relative coweight of each position. -/");
    println!("def sortedCoweight : Position → Index → ℤ :=");
    println!("  ![");
    for (offset, position) in positions.iter().enumerate() {
        println!(
            "    {}{}",
            json_array(&position.coweight)
                .replace('[', "![")
                .replace(']', "]"),
            if offset + 1 == positions.len() {
                ""
            } else {
                ","
            }
        );
    }
    println!("  ]\n");

    println!("/-- Inverse basis permutation of each position. -/");
    println!("def inversePermutation : Position → Index → Index :=");
    println!("  ![");
    for (offset, position) in positions.iter().enumerate() {
        println!(
            "    {}{}",
            json_array(&position.inverse_permutation)
                .replace('[', "![")
                .replace(']', "]"),
            if offset + 1 == positions.len() {
                ""
            } else {
                ","
            }
        );
    }
    println!("  ]\n");

    let divisor_indices = positions
        .iter()
        .map(|position| position.divisor_old_index)
        .collect::<Vec<_>>();
    let generating = positions
        .iter()
        .map(|position| lean_bool(position.divisor_generates))
        .collect::<Vec<_>>();
    println!("/-- Source basis monomial of the marked target divisor. -/");
    emit_lean_vector("divisorOldBasisIndex", "Index", &divisor_indices);
    println!("/-- Whether that source generates the reduced cubic quotient. -/");
    emit_lean_vector("divisorGeneratesCubicQuotient", "Bool", &generating);

    println!("/-- Chosen representative modulo the Kummer algebra involution. -/");
    println!("def representativeModKummerInvolution : Position → Option Position :=");
    let representatives = positions
        .iter()
        .map(|position| match position.representative {
            Some(index) => format!("some {index}"),
            None => "none".to_string(),
        })
        .collect::<Vec<_>>();
    println!("  ![{}]\n", representatives.join(", "));

    println!("/-- Coefficients of `u^3,u^2v,uv^2,v^3` on the special fibre. -/");
    println!("def specialBinaryCubic : Position → Fin 4 → ℤ :=");
    println!("  ![");
    for (offset, position) in positions.iter().enumerate() {
        let values = [
            position.special_binary_cubic.0,
            position.special_binary_cubic.1,
            position.special_binary_cubic.2,
            position.special_binary_cubic.3,
        ];
        println!(
            "    {}{}",
            json_array(&values).replace('[', "![").replace(']', "]"),
            if offset + 1 == positions.len() {
                ""
            } else {
                ","
            }
        );
    }
    println!("  ]\n");

    println!("/-- Coefficients of `α^2,αβ,β^2` in the Lefschetz determinant. -/");
    println!("def hardLefschetzDeterminant : Position → Fin 3 → ℤ :=");
    println!("  ![");
    for (offset, position) in positions.iter().enumerate() {
        let values = [
            position.hard_lefschetz.0,
            position.hard_lefschetz.1,
            position.hard_lefschetz.2,
        ];
        println!(
            "    {}{}",
            json_array(&values).replace('[', "![").replace(']', "]"),
            if offset + 1 == positions.len() {
                ""
            } else {
                ","
            }
        );
    }
    println!("  ]\n");
    println!("end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.Generated.UnitFixedWeylCoweightData");
}

fn emit_summary(positions: &[PositionData]) {
    let pairing = pairing_matrix();
    assert_eq!(pairing, pairing_matrix());
    for position in positions {
        println!(
            "position={} sigma={:?} coweight={:?} divisor_source={} generates={} representative={:?} cubic={:?} hl={:?}",
            position.index,
            position.permutation,
            position.coweight,
            position.divisor_old_index,
            position.divisor_generates,
            position.representative,
            position.special_binary_cubic,
            position.hard_lefschetz
        );
    }
}

fn main() {
    let positions = enumerate_positions();
    match env::args().nth(1).as_deref() {
        Some("--json") => emit_json(&positions),
        Some("--lean") => emit_lean(&positions),
        None => emit_summary(&positions),
        Some(mode) => panic!("unknown mode: {}", mode),
    }
}
