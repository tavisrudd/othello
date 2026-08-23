use std::cmp::Ordering;
use std::env;
use std::fmt::{self, Display};
use std::ops::{Add, Mul, Neg, Sub};

const BLOCK: usize = 2;
const RANK: usize = 6;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
struct Rat {
    num: i128,
    den: i128,
}

impl Rat {
    const ZERO: Self = Self { num: 0, den: 1 };
    const ONE: Self = Self { num: 1, den: 1 };

    fn new(mut num: i128, mut den: i128) -> Self {
        assert_ne!(den, 0);
        if den < 0 {
            num = -num;
            den = -den;
        }
        let divisor = gcd(num.unsigned_abs(), den as u128) as i128;
        Self {
            num: num / divisor,
            den: den / divisor,
        }
    }

    fn is_zero(self) -> bool {
        self.num == 0
    }

    fn lean(self) -> String {
        match (self.num.cmp(&0), self.den) {
            (_, 1) => self.num.to_string(),
            (Ordering::Less, _) => format!("-{} / {}", -self.num, self.den),
            _ => format!("{} / {}", self.num, self.den),
        }
    }
}

fn gcd(mut left: u128, mut right: u128) -> u128 {
    while right != 0 {
        let remainder = left % right;
        left = right;
        right = remainder;
    }
    if left == 0 {
        1
    } else {
        left
    }
}

impl Display for Rat {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        if self.den == 1 {
            write!(formatter, "{}", self.num)
        } else {
            write!(formatter, "{}/{}", self.num, self.den)
        }
    }
}

impl Add for Rat {
    type Output = Self;

    fn add(self, rhs: Self) -> Self::Output {
        Self::new(self.num * rhs.den + rhs.num * self.den, self.den * rhs.den)
    }
}

impl Sub for Rat {
    type Output = Self;

    fn sub(self, rhs: Self) -> Self::Output {
        self + (-rhs)
    }
}

impl Mul for Rat {
    type Output = Self;

    fn mul(self, rhs: Self) -> Self::Output {
        Self::new(self.num * rhs.num, self.den * rhs.den)
    }
}

impl Neg for Rat {
    type Output = Self;

    fn neg(self) -> Self::Output {
        Self::new(-self.num, self.den)
    }
}

impl From<i128> for Rat {
    fn from(value: i128) -> Self {
        Self::new(value, 1)
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
struct Monomial {
    coefficient: Rat,
    exponent: i32,
}

impl Monomial {
    const ZERO: Self = Self {
        coefficient: Rat::ZERO,
        exponent: 0,
    };

    fn new(coefficient: Rat, exponent: i32) -> Self {
        Self {
            coefficient,
            exponent,
        }
    }

    fn product(self, rhs: Self) -> Self {
        Self::new(
            self.coefficient * rhs.coefficient,
            self.exponent + rhs.exponent,
        )
    }
}

type BlockMatrix = [[Monomial; BLOCK]; BLOCK];
type LaurentMatrix = [[Monomial; RANK]; RANK];
type Matrix = [[Rat; RANK]; RANK];

fn determinant_valuation(block: &BlockMatrix) -> i32 {
    let positive = block[0][0].product(block[1][1]);
    let negative = block[0][1].product(block[1][0]);
    match (
        positive.coefficient.is_zero(),
        negative.coefficient.is_zero(),
    ) {
        (true, true) => panic!("zero determinant"),
        (false, true) => positive.exponent,
        (true, false) => negative.exponent,
        (false, false) => match positive.exponent.cmp(&negative.exponent) {
            Ordering::Less => positive.exponent,
            Ordering::Greater => negative.exponent,
            Ordering::Equal => {
                assert!(
                    !(positive.coefficient - negative.coefficient).is_zero(),
                    "determinant leading terms cancel"
                );
                positive.exponent
            }
        },
    }
}

fn minimum_entry_valuation(block: &BlockMatrix) -> i32 {
    block
        .iter()
        .flatten()
        .filter(|entry| !entry.coefficient.is_zero())
        .map(|entry| entry.exponent)
        .min()
        .expect("zero block")
}

fn elementary_divisors(block: &BlockMatrix) -> [i32; 2] {
    let first = minimum_entry_valuation(block);
    [first, determinant_valuation(block) - first]
}

fn blocks() -> [BlockMatrix; 3] {
    [
        [
            [
                Monomial::new(Rat::new(2, 3), 0),
                Monomial::new((-1).into(), 0),
            ],
            [
                Monomial::new(Rat::new(1, 3), -1),
                Monomial::new(Rat::ONE, -1),
            ],
        ],
        [
            [
                Monomial::new(Rat::new(1, 3), 0),
                Monomial::new((-1).into(), 0),
            ],
            [Monomial::new(Rat::new(2, 3), 1), Monomial::new(Rat::ONE, 1)],
        ],
        [
            [Monomial::new(Rat::ONE, 0), Monomial::new((-1).into(), 3)],
            [Monomial::ZERO, Monomial::new(Rat::ONE, 0)],
        ],
    ]
}

fn comparison_matrix() -> LaurentMatrix {
    let mut result = [[Monomial::ZERO; RANK]; RANK];
    result[0][0] = Monomial::new(Rat::ONE, 0);
    result[0][5] = Monomial::new((-1).into(), 3);
    result[1][1] = Monomial::new(Rat::new(2, 3), 0);
    result[1][3] = Monomial::new((-1).into(), 0);
    result[2][2] = Monomial::new(Rat::new(1, 3), 0);
    result[2][4] = Monomial::new((-1).into(), 0);
    result[3][2] = Monomial::new(Rat::new(2, 3), 1);
    result[3][4] = Monomial::new(Rat::ONE, 1);
    result[4][1] = Monomial::new(Rat::new(1, 3), -1);
    result[4][3] = Monomial::new(Rat::ONE, -1);
    result[5][5] = Monomial::new(Rat::ONE, 0);
    result
}

fn verify_block_decomposition(matrix: &LaurentMatrix, blocks: &[BlockMatrix; 3]) {
    let row_groups = [[1_usize, 4], [2, 3], [0, 5]];
    let column_groups = [[1_usize, 3], [2, 4], [0, 5]];
    for block in 0..3 {
        for i in 0..BLOCK {
            for j in 0..BLOCK {
                assert_eq!(
                    matrix[row_groups[block][i]][column_groups[block][j]],
                    blocks[block][i][j]
                );
            }
        }
    }
    for (row, entries) in matrix.iter().enumerate() {
        for (column, entry) in entries.iter().enumerate() {
            let retained = (0..3).any(|block| {
                row_groups[block].contains(&row) && column_groups[block].contains(&column)
            });
            if !retained {
                assert!(entry.coefficient.is_zero());
            }
        }
    }
}

fn relative_coweight(blocks: &[BlockMatrix; 3]) -> Vec<i32> {
    let mut result = blocks
        .iter()
        .flat_map(elementary_divisors)
        .collect::<Vec<_>>();
    result.sort();
    result
}

fn zero_matrix() -> Matrix {
    [[Rat::ZERO; RANK]; RANK]
}

fn transpose(matrix: &Matrix) -> Matrix {
    let mut result = zero_matrix();
    for (i, row) in result.iter_mut().enumerate() {
        for (j, entry) in row.iter_mut().enumerate() {
            *entry = matrix[j][i];
        }
    }
    result
}

fn matrix_add(left: &Matrix, right: &Matrix) -> Matrix {
    let mut result = zero_matrix();
    for i in 0..RANK {
        for j in 0..RANK {
            result[i][j] = left[i][j] + right[i][j];
        }
    }
    result
}

fn matrix_mul(left: &Matrix, right: &Matrix) -> Matrix {
    let mut result = zero_matrix();
    for i in 0..RANK {
        for j in 0..RANK {
            for k in 0..RANK {
                result[i][j] = result[i][j] + left[i][k] * right[k][j];
            }
        }
    }
    result
}

fn pairing() -> Matrix {
    let mut result = zero_matrix();
    for i in 0..RANK {
        result[i][RANK - 1 - i] = Rat::ONE;
    }
    result
}

fn first_jet() -> Matrix {
    let mut result = zero_matrix();
    result[1][3] = Rat::ONE;
    result[2][4] = (-1).into();
    result
}

fn verify_first_jet(jet: &Matrix) {
    let pairing = pairing();
    assert_eq!(
        matrix_add(
            &matrix_mul(&transpose(jet), &pairing),
            &matrix_mul(&pairing, jet)
        ),
        zero_matrix()
    );
    assert!(jet.iter().flatten().any(|entry| !entry.is_zero()));
    for row in jet {
        assert!(row[..3].iter().all(|entry| entry.is_zero()));
    }
    let weights = [0_i32, 1, 1, 2, 2, 3];
    for i in 0..RANK {
        for j in 0..RANK {
            if !jet[i][j].is_zero() {
                assert_eq!(weights[i] + 1, weights[j]);
            }
        }
    }
}

fn json_monomial(monomial: Monomial) -> String {
    format!(
        "{{\"coefficient\":\"{}\",\"exponent\":{}}}",
        monomial.coefficient, monomial.exponent
    )
}

fn json_block(block: &BlockMatrix, indent: &str) -> String {
    let rows = block
        .iter()
        .map(|row| {
            let entries = row
                .iter()
                .map(|entry| json_monomial(*entry))
                .collect::<Vec<_>>()
                .join(",");
            format!("{indent}  [{entries}]")
        })
        .collect::<Vec<_>>()
        .join(",\n");
    format!("[\n{rows}\n{indent}]")
}

fn json_laurent_matrix(matrix: &LaurentMatrix, indent: &str) -> String {
    let rows = matrix
        .iter()
        .map(|row| {
            let entries = row
                .iter()
                .map(|entry| json_monomial(*entry))
                .collect::<Vec<_>>()
                .join(",");
            format!("{indent}  [{entries}]")
        })
        .collect::<Vec<_>>()
        .join(",\n");
    format!("[\n{rows}\n{indent}]")
}

fn json_matrix(matrix: &Matrix, indent: &str) -> String {
    let rows = matrix
        .iter()
        .map(|row| {
            let entries = row
                .iter()
                .map(|entry| format!("\"{}\"", entry))
                .collect::<Vec<_>>()
                .join(", ");
            format!("{indent}  [{entries}]")
        })
        .collect::<Vec<_>>()
        .join(",\n");
    format!("[\n{rows}\n{indent}]")
}

fn emit_json(matrix: &LaurentMatrix, blocks: &[BlockMatrix; 3], coweight: &[i32], jet: &Matrix) {
    println!("{{");
    println!("  \"schema\": \"marked-rees-shadow-certificate-v1\",");
    println!("  \"arithmetic\": \"reduced exact i128 rationals and integral exponents\",");
    println!(
        "  \"comparison_matrix\": {},",
        json_laurent_matrix(matrix, "  ")
    );
    println!("  \"comparison_blocks\": [");
    for (index, block) in blocks.iter().enumerate() {
        println!("    {{");
        println!("      \"matrix\": {},", json_block(block, "      "));
        println!(
            "      \"minimum_entry_valuation\": {},",
            minimum_entry_valuation(block)
        );
        println!(
            "      \"determinant_valuation\": {},",
            determinant_valuation(block)
        );
        let elementary = elementary_divisors(block);
        println!(
            "      \"elementary_divisors\": [{}, {}]",
            elementary[0], elementary[1]
        );
        print!("    }}");
        if index + 1 != blocks.len() {
            print!(",");
        }
        println!();
    }
    println!("  ],");
    println!(
        "  \"relative_coweight\": [{}],",
        coweight
            .iter()
            .map(ToString::to_string)
            .collect::<Vec<_>>()
            .join(", ")
    );
    println!("  \"first_jet\": {},", json_matrix(jet, "  "));
    println!("  \"first_jet_pairing_tangent\": true,");
    println!("  \"first_jet_fixes_first_three_columns\": true,");
    println!("  \"first_jet_weight_shift\": -1,");
    println!("  \"first_jet_nonzero\": true");
    println!("}}");
}

fn lean_monomial(monomial: Monomial) -> String {
    format!("⟨{}, {}⟩", monomial.coefficient.lean(), monomial.exponent)
}

fn lean_block(block: &BlockMatrix) -> String {
    let rows = block
        .iter()
        .map(|row| {
            row.iter()
                .map(|entry| lean_monomial(*entry))
                .collect::<Vec<_>>()
                .join(", ")
        })
        .collect::<Vec<_>>()
        .join(";\n     ");
    format!("!![{rows}]")
}

fn lean_laurent_matrix(matrix: &LaurentMatrix) -> String {
    let rows = matrix
        .iter()
        .map(|row| {
            row.iter()
                .map(|entry| lean_monomial(*entry))
                .collect::<Vec<_>>()
                .join(", ")
        })
        .collect::<Vec<_>>()
        .join(";\n     ");
    format!("!![{rows}]")
}

fn lean_matrix(matrix: &Matrix) -> String {
    let rows = matrix
        .iter()
        .map(|row| {
            row.iter()
                .map(|entry| entry.lean())
                .collect::<Vec<_>>()
                .join(", ")
        })
        .collect::<Vec<_>>()
        .join(";\n     ");
    format!("!![{rows}]")
}

fn emit_lean(matrix: &LaurentMatrix, blocks: &[BlockMatrix; 3], coweight: &[i32], jet: &Matrix) {
    println!("import Mathlib");
    println!();
    println!("/-!");
    println!("# Generated data for the marked Rees-shadow certificate");
    println!();
    println!("This file is generated by `scripts/marked_rees_shadow_cert.rs`.");
    println!("The importing checker recomputes the elementary divisors and");
    println!("the first-jet identities from these exact data.");
    println!("-/");
    println!();
    println!("namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.Generated.MarkedReesShadowData");
    println!();
    println!("abbrev Index := Fin 6");
    println!("abbrev BlockIndex := Fin 2");
    println!();
    println!("structure LaurentMonomial where");
    println!("  coefficient : ℚ");
    println!("  exponent : ℤ");
    println!("  deriving DecidableEq");
    println!();
    println!("def comparisonMatrix : Matrix Index Index LaurentMonomial :=");
    println!("  {}", lean_laurent_matrix(matrix));
    println!();
    for (index, block) in blocks.iter().enumerate() {
        println!("def comparisonBlock{index} : Matrix BlockIndex BlockIndex LaurentMonomial :=");
        println!("  {}", lean_block(block));
        println!();
    }
    println!("def certifiedRelativeCoweight : List ℤ :=");
    println!(
        "  [{}]",
        coweight
            .iter()
            .map(ToString::to_string)
            .collect::<Vec<_>>()
            .join(", ")
    );
    println!();
    println!("def shearFirstJet : Matrix Index Index ℚ :=");
    println!("  {}", lean_matrix(jet));
    println!();
    println!("end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.Generated.MarkedReesShadowData");
}

fn main() {
    let blocks = blocks();
    let matrix = comparison_matrix();
    let coweight = relative_coweight(&blocks);
    let jet = first_jet();
    assert_eq!(coweight, vec![-1, 0, 0, 0, 0, 1]);
    verify_block_decomposition(&matrix, &blocks);
    verify_first_jet(&jet);

    let argument = env::args().nth(1).unwrap_or_else(|| "--json".to_owned());
    match argument.as_str() {
        "--json" => emit_json(&matrix, &blocks, &coweight, &jet),
        "--lean" => emit_lean(&matrix, &blocks, &coweight, &jet),
        other => panic!("unknown output mode: {}", other),
    }
}
