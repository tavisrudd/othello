//! Exact certificate generator for two effective rank-six Rees-calibration charts.
//!
//! The coefficient domain is the unipotent support permitted by weights
//! `(0,1,1,2,2,3)` over one primitive cubic Kummer ray.  Arithmetic is exact
//! over the rationals.  The program constructs the self-dual five-parameter
//! calibration, transports multiplication in both tensor indices, computes
//! the logarithmic divisor defect, and checks the full normalized recurrence
//! on its conformal one-parameter family.  The `--distinct-lean` and
//! `--distinct-json` modes perform the corresponding exact calculation for
//! the distinct-root native order and emit its unique normalized first gauge
//! and selected-line obstruction.  Internal assertions check every emitted
//! correspondence.  The program contains no randomized search.

use std::collections::BTreeMap;
use std::env;
use std::fmt::{self, Display};
use std::ops::{Add, Div, Mul, Neg, Sub};

const N: usize = 6;
const VARIABLE_COUNT: usize = 6;
const A: usize = 0;
const B: usize = 1;
const C: usize = 2;
const D: usize = 3;
const F: usize = 4;
const R: usize = 5;

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
            (std::cmp::Ordering::Less, _) => format!("-{} / {}", -self.num, self.den),
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

impl Div for Rat {
    type Output = Self;

    fn div(self, rhs: Self) -> Self::Output {
        assert!(!rhs.is_zero());
        Self::new(self.num * rhs.den, self.den * rhs.num)
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

#[derive(Clone, Copy, Debug, Eq, PartialEq, Ord, PartialOrd)]
struct Monomial([u8; VARIABLE_COUNT]);

impl Monomial {
    const ONE: Self = Self([0; VARIABLE_COUNT]);

    fn variable(index: usize) -> Self {
        let mut exponents = [0; VARIABLE_COUNT];
        exponents[index] = 1;
        Self(exponents)
    }

    fn product(self, rhs: Self) -> Self {
        let mut exponents = [0; VARIABLE_COUNT];
        for (index, exponent) in exponents.iter_mut().enumerate() {
            *exponent = self.0[index] + rhs.0[index];
        }
        Self(exponents)
    }
}

#[derive(Clone, Debug, Eq, PartialEq)]
struct Poly(BTreeMap<Monomial, Rat>);

impl Poly {
    fn zero() -> Self {
        Self(BTreeMap::new())
    }

    fn constant(value: Rat) -> Self {
        if value.is_zero() {
            Self::zero()
        } else {
            Self(BTreeMap::from([(Monomial::ONE, value)]))
        }
    }

    fn variable(index: usize) -> Self {
        Self(BTreeMap::from([(Monomial::variable(index), Rat::ONE)]))
    }

    fn is_zero(&self) -> bool {
        self.0.is_empty()
    }

    fn as_constant(&self) -> Rat {
        assert!(self.0.keys().all(|monomial| *monomial == Monomial::ONE));
        self.0.get(&Monomial::ONE).copied().unwrap_or(Rat::ZERO)
    }

    fn scale(&self, scalar: Rat) -> Self {
        if scalar.is_zero() {
            return Self::zero();
        }
        Self(
            self.0
                .iter()
                .map(|(monomial, coefficient)| (*monomial, *coefficient * scalar))
                .collect(),
        )
    }

    fn r_derivative(&self) -> Self {
        let mut result = BTreeMap::new();
        for (monomial, coefficient) in &self.0 {
            let exponent = monomial.0[R];
            if exponent != 0 {
                let mut derived = *monomial;
                derived.0[R] -= 1;
                result.insert(derived, *coefficient * Rat::from(i128::from(exponent)));
            }
        }
        Self(result)
    }

    fn evaluate_r_one(&self) -> Self {
        let mut result = Self::zero();
        for (monomial, coefficient) in &self.0 {
            let mut evaluated = *monomial;
            evaluated.0[R] = 0;
            result = result + Self(BTreeMap::from([(evaluated, *coefficient)]));
        }
        result
    }

    fn mul_r(&self) -> Self {
        self.clone() * Self::variable(R)
    }

    fn substitute(&self, values: &[Self; VARIABLE_COUNT]) -> Self {
        let mut result = Self::zero();
        for (monomial, coefficient) in &self.0 {
            let mut term = Self::constant(*coefficient);
            for (index, exponent) in monomial.0.iter().copied().enumerate() {
                for _ in 0..exponent {
                    term = term * values[index].clone();
                }
            }
            result = result + term;
        }
        result
    }

    fn lean(&self) -> String {
        if self.is_zero() {
            return "0".to_string();
        }
        let names = ["a", "b", "c", "d", "f", "r"];
        self.0
            .iter()
            .map(|(monomial, coefficient)| {
                let factors = monomial
                    .0
                    .iter()
                    .copied()
                    .enumerate()
                    .filter(|(_, exponent)| *exponent != 0)
                    .map(|(index, exponent)| {
                        if exponent == 1 {
                            names[index].to_string()
                        } else {
                            format!("{} ^ {}", names[index], exponent)
                        }
                    })
                    .collect::<Vec<_>>();
                if factors.is_empty() {
                    format!("({})", coefficient.lean())
                } else {
                    format!("({}) * ({})", coefficient.lean(), factors.join(" * "))
                }
            })
            .collect::<Vec<_>>()
            .join(" + ")
    }
}

impl Display for Poly {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        if self.is_zero() {
            return write!(formatter, "0");
        }
        let names = ["a", "b", "c", "d", "f", "r"];
        let mut first = true;
        for (monomial, coefficient) in &self.0 {
            if !first {
                write!(formatter, " + ")?;
            }
            first = false;
            write!(formatter, "({coefficient})")?;
            for (index, exponent) in monomial.0.iter().copied().enumerate() {
                if exponent == 1 {
                    write!(formatter, "*{}", names[index])?;
                } else if exponent > 1 {
                    write!(formatter, "*{}^{}", names[index], exponent)?;
                }
            }
        }
        Ok(())
    }
}

impl Add for Poly {
    type Output = Self;

    fn add(mut self, rhs: Self) -> Self::Output {
        for (monomial, coefficient) in rhs.0 {
            let value = self.0.get(&monomial).copied().unwrap_or(Rat::ZERO) + coefficient;
            if value.is_zero() {
                self.0.remove(&monomial);
            } else {
                self.0.insert(monomial, value);
            }
        }
        self
    }
}

impl Sub for Poly {
    type Output = Self;

    fn sub(self, rhs: Self) -> Self::Output {
        self + (-rhs)
    }
}

impl Mul for Poly {
    type Output = Self;

    fn mul(self, rhs: Self) -> Self::Output {
        let mut result = Self::zero();
        for (left_monomial, left_coefficient) in self.0 {
            for (right_monomial, right_coefficient) in &rhs.0 {
                let monomial = left_monomial.product(*right_monomial);
                let coefficient = left_coefficient * *right_coefficient;
                result = result + Self(BTreeMap::from([(monomial, coefficient)]));
            }
        }
        result
    }
}

impl Neg for Poly {
    type Output = Self;

    fn neg(self) -> Self::Output {
        self.scale((-1).into())
    }
}

impl From<i128> for Poly {
    fn from(value: i128) -> Self {
        Self::constant(value.into())
    }
}

type Matrix = [[Poly; N]; N];
type Vector = [Poly; N];

fn zero_matrix() -> Matrix {
    std::array::from_fn(|_| std::array::from_fn(|_| Poly::zero()))
}

fn identity_matrix() -> Matrix {
    std::array::from_fn(|row| {
        std::array::from_fn(|column| {
            if row == column {
                Poly::from(1)
            } else {
                Poly::zero()
            }
        })
    })
}

fn add_matrix(left: &Matrix, right: &Matrix) -> Matrix {
    std::array::from_fn(|row| {
        std::array::from_fn(|column| left[row][column].clone() + right[row][column].clone())
    })
}

fn sub_matrix(left: &Matrix, right: &Matrix) -> Matrix {
    std::array::from_fn(|row| {
        std::array::from_fn(|column| left[row][column].clone() - right[row][column].clone())
    })
}

fn scale_matrix(scalar: Rat, matrix: &Matrix) -> Matrix {
    std::array::from_fn(|row| std::array::from_fn(|column| matrix[row][column].scale(scalar)))
}

fn mul_matrix(left: &Matrix, right: &Matrix) -> Matrix {
    std::array::from_fn(|row| {
        std::array::from_fn(|column| {
            (0..N).fold(Poly::zero(), |sum, inner| {
                sum + left[row][inner].clone() * right[inner][column].clone()
            })
        })
    })
}

fn transpose(matrix: &Matrix) -> Matrix {
    std::array::from_fn(|row| std::array::from_fn(|column| matrix[column][row].clone()))
}

fn mul_vector(matrix: &Matrix, vector: &Vector) -> Vector {
    std::array::from_fn(|row| {
        (0..N).fold(Poly::zero(), |sum, inner| {
            sum + matrix[row][inner].clone() * vector[inner].clone()
        })
    })
}

fn pairing() -> Matrix {
    std::array::from_fn(|row| {
        std::array::from_fn(|column| {
            if row + column == N - 1 {
                Poly::from(1)
            } else {
                Poly::zero()
            }
        })
    })
}

fn calibration() -> Matrix {
    let a = Poly::variable(A);
    let b = Poly::variable(B);
    let c = Poly::variable(C);
    let d = Poly::variable(D);
    let f = Poly::variable(F);
    let r = Poly::variable(R);
    let r2 = r.clone() * r.clone();
    let r3 = r2.clone() * r.clone();
    let mut result = identity_matrix();
    result[0][1] = a.clone() * r.clone();
    result[0][2] = b.clone() * r.clone();
    result[0][3] = c.clone() * r2.clone();
    result[0][4] = d.clone() * r2.clone();
    result[0][5] = -(a.clone() * d.clone() + b.clone() * c.clone()) * r3;
    result[1][3] = f.clone() * r.clone();
    result[1][5] = -(d.clone() + f.clone() * b.clone()) * r2.clone();
    result[2][4] = -f.clone() * r.clone();
    result[2][5] = (-c.clone() + f * a.clone()) * r2;
    result[3][5] = -b * r.clone();
    result[4][5] = -a * r;
    result
}

fn calibration_inverse(calibration: &Matrix) -> Matrix {
    let pairing = pairing();
    mul_matrix(&mul_matrix(&pairing, &transpose(calibration)), &pairing)
}

fn x_multiplication() -> Matrix {
    let mut result = zero_matrix();
    let r3 = Poly::variable(R) * Poly::variable(R) * Poly::variable(R);
    result[0][4] = r3.clone();
    result[1][5] = r3;
    result[2][0] = Poly::from(1);
    result[3][1] = Poly::from(1);
    result[4][2] = Poly::from(1);
    result[5][3] = Poly::from(1);
    result
}

fn e_multiplication() -> Matrix {
    let mut result = zero_matrix();
    result[1][0] = Poly::from(1);
    result[3][2] = Poly::from(1);
    result[5][4] = Poly::from(1);
    result
}

// Multiplication in the distinct-root order
//
//   Q[r][a,b]/(ab-r^2, a^3+b^3-2r^3)
//
// in the self-dual graded basis `(1,a,b,b^2,-a^2,b^3)`.  The coefficient of
// `b^3` gives the anti-diagonal pairing used by `pairing()`.
fn distinct_a_multiplication() -> Matrix {
    let mut result = zero_matrix();
    let r = Poly::variable(R);
    let r2 = r.clone() * r.clone();
    let r3 = r2.clone() * r;
    result[1][0] = Poly::from(1);
    result[4][1] = Poly::from(-1);
    result[0][2] = r2.clone();
    result[2][3] = r2.clone();
    result[0][4] = r3.scale(Rat::from(-2));
    result[5][4] = Poly::from(1);
    result[3][5] = r2;
    result
}

fn distinct_b_multiplication() -> Matrix {
    let mut result = zero_matrix();
    let r = Poly::variable(R);
    let r2 = r.clone() * r.clone();
    let r3 = r2.clone() * r;
    result[2][0] = Poly::from(1);
    result[0][1] = r2.clone();
    result[3][2] = Poly::from(1);
    result[5][3] = Poly::from(1);
    result[1][4] = r2.clone().scale(Rat::from(-1));
    result[2][5] = r3.scale(Rat::from(2));
    result[4][5] = r2;
    result
}

fn distinct_basis_multiplications() -> [Matrix; N] {
    let one = identity_matrix();
    let a = distinct_a_multiplication();
    let b = distinct_b_multiplication();
    let b2 = mul_matrix(&b, &b);
    let minus_a2 = scale_matrix(Rat::from(-1), &mul_matrix(&a, &a));
    let b3 = mul_matrix(&b2, &b);
    [one, a, b, b2, minus_a2, b3]
}

fn distinct_multiplication_of(vector: &Vector) -> Matrix {
    let basis = distinct_basis_multiplications();
    let mut result = zero_matrix();
    for index in 0..N {
        for row in 0..N {
            for column in 0..N {
                result[row][column] = result[row][column].clone()
                    + vector[index].clone() * basis[index][row][column].clone();
            }
        }
    }
    result
}

fn distinct_transported_multiplication(calibration: &Matrix, vector: &Vector) -> Matrix {
    let inverse = calibration_inverse(calibration);
    let old_vector = mul_vector(&inverse, vector);
    mul_matrix(
        &mul_matrix(calibration, &distinct_multiplication_of(&old_vector)),
        &inverse,
    )
}

fn basis_multiplications() -> [Matrix; N] {
    let one = identity_matrix();
    let e = e_multiplication();
    let x = x_multiplication();
    let xe = mul_matrix(&x, &e);
    let x2 = mul_matrix(&x, &x);
    let x2e = mul_matrix(&x2, &e);
    [one, e, x, xe, x2, x2e]
}

fn multiplication_of(vector: &Vector) -> Matrix {
    let basis = basis_multiplications();
    let mut result = zero_matrix();
    for index in 0..N {
        for row in 0..N {
            for column in 0..N {
                result[row][column] = result[row][column].clone()
                    + vector[index].clone() * basis[index][row][column].clone();
            }
        }
    }
    result
}

fn transported_multiplication(calibration: &Matrix, vector: &Vector) -> Matrix {
    let inverse = calibration_inverse(calibration);
    let old_vector = mul_vector(&inverse, vector);
    mul_matrix(
        &mul_matrix(calibration, &multiplication_of(&old_vector)),
        &inverse,
    )
}

fn grading() -> Matrix {
    let values = [
        Rat::new(-3, 2),
        Rat::new(-1, 2),
        Rat::new(-1, 2),
        Rat::new(1, 2),
        Rat::new(1, 2),
        Rat::new(3, 2),
    ];
    std::array::from_fn(|row| {
        std::array::from_fn(|column| {
            if row == column {
                Poly::constant(values[row])
            } else {
                Poly::zero()
            }
        })
    })
}

fn euler_derivative(matrix: &Matrix) -> Matrix {
    std::array::from_fn(|row| {
        std::array::from_fn(|column| matrix[row][column].r_derivative().mul_r())
    })
}

fn evaluate_r_one_matrix(matrix: &Matrix) -> Matrix {
    std::array::from_fn(|row| std::array::from_fn(|column| matrix[row][column].evaluate_r_one()))
}

fn substitute_matrix(matrix: &Matrix, values: &[Poly; VARIABLE_COUNT]) -> Matrix {
    std::array::from_fn(|row| std::array::from_fn(|column| matrix[row][column].substitute(values)))
}

fn constant_matrix(entries: [[Rat; N]; N]) -> Matrix {
    std::array::from_fn(|row| std::array::from_fn(|column| Poly::constant(entries[row][column])))
}

fn strict_jordan_basis() -> Matrix {
    constant_matrix([
        [0.into(), 1.into(), 0.into(), 0.into(), 1.into(), 0.into()],
        [1.into(), 0.into(), 1.into(), 0.into(), 0.into(), 0.into()],
        [
            0.into(),
            1.into(),
            0.into(),
            0.into(),
            (-1).into(),
            1.into(),
        ],
        [
            1.into(),
            0.into(),
            (-1).into(),
            1.into(),
            0.into(),
            0.into(),
        ],
        [
            0.into(),
            1.into(),
            0.into(),
            0.into(),
            0.into(),
            (-1).into(),
        ],
        [
            1.into(),
            0.into(),
            0.into(),
            (-1).into(),
            0.into(),
            0.into(),
        ],
    ])
}

fn strict_jordan_basis_inverse() -> Matrix {
    constant_matrix([
        [
            0.into(),
            Rat::new(1, 3),
            0.into(),
            Rat::new(1, 3),
            0.into(),
            Rat::new(1, 3),
        ],
        [
            Rat::new(1, 3),
            0.into(),
            Rat::new(1, 3),
            0.into(),
            Rat::new(1, 3),
            0.into(),
        ],
        [
            0.into(),
            Rat::new(2, 3),
            0.into(),
            Rat::new(-1, 3),
            0.into(),
            Rat::new(-1, 3),
        ],
        [
            0.into(),
            Rat::new(1, 3),
            0.into(),
            Rat::new(1, 3),
            0.into(),
            Rat::new(-2, 3),
        ],
        [
            Rat::new(2, 3),
            0.into(),
            Rat::new(-1, 3),
            0.into(),
            Rat::new(-1, 3),
            0.into(),
        ],
        [
            Rat::new(1, 3),
            0.into(),
            Rat::new(1, 3),
            0.into(),
            Rat::new(-2, 3),
            0.into(),
        ],
    ])
}

fn strict_jordan_form() -> Matrix {
    constant_matrix([
        [3.into(), 2.into(), 0.into(), 0.into(), 0.into(), 0.into()],
        [0.into(), 3.into(), 0.into(), 0.into(), 0.into(), 0.into()],
        [
            0.into(),
            0.into(),
            0.into(),
            (-3).into(),
            2.into(),
            0.into(),
        ],
        [
            0.into(),
            0.into(),
            3.into(),
            (-3).into(),
            0.into(),
            2.into(),
        ],
        [
            0.into(),
            0.into(),
            0.into(),
            0.into(),
            0.into(),
            (-3).into(),
        ],
        [
            0.into(),
            0.into(),
            0.into(),
            0.into(),
            3.into(),
            (-3).into(),
        ],
    ])
}

fn normal_substitution() -> [Poly; VARIABLE_COUNT] {
    let parameter = Poly::variable(B);
    [
        Poly::zero(),
        -parameter.clone(),
        Poly::zero(),
        -(parameter.clone() * parameter.clone()).scale(Rat::new(1, 2)),
        -parameter,
        Poly::from(1),
    ]
}

fn normal_calibration() -> Matrix {
    substitute_matrix(&calibration(), &normal_substitution())
}

fn normal_euler() -> Matrix {
    let calibration = normal_calibration();
    let euler_vector = [
        Poly::zero(),
        Poly::from(2),
        Poly::from(3),
        Poly::zero(),
        Poly::zero(),
        Poly::zero(),
    ];
    evaluate_r_one_matrix(&transported_multiplication(&calibration, &euler_vector))
}

fn normal_jordan_basis() -> Matrix {
    mul_matrix(
        &evaluate_r_one_matrix(&normal_calibration()),
        &strict_jordan_basis(),
    )
}

fn normal_jordan_basis_inverse() -> Matrix {
    mul_matrix(
        &strict_jordan_basis_inverse(),
        &evaluate_r_one_matrix(&calibration_inverse(&normal_calibration())),
    )
}

fn normal_jordan_form() -> Matrix {
    let parameter = Poly::variable(B);
    let shift = scale_matrix(
        Rat::from(3),
        &scale_poly_matrix(&parameter, &identity_matrix()),
    );
    add_matrix(&strict_jordan_form(), &shift)
}

fn scale_poly_matrix(scalar: &Poly, matrix: &Matrix) -> Matrix {
    std::array::from_fn(|row| {
        std::array::from_fn(|column| scalar.clone() * matrix[row][column].clone())
    })
}

fn normal_first_gauge() -> Matrix {
    let parameter = Poly::variable(B);
    let mut result = zero_matrix();
    result[0][2] = Poly::constant(Rat::new(-1, 9));
    result[0][3] = parameter.clone().scale(Rat::new(1, 9));
    result[1][4] = Poly::constant(Rat::new(-1, 9));
    result[1][5] = parameter.clone().scale(Rat::new(1, 9));
    result[2][0] = (Poly::from(1) - parameter.clone().scale(Rat::from(2))).scale(Rat::new(1, 9));
    result[3][0] = (Poly::from(2) - parameter.clone()).scale(Rat::new(1, 9));
    result[4][1] = (Poly::from(1) - parameter.clone().scale(Rat::from(2))).scale(Rat::new(1, 9));
    result[5][1] = (Poly::from(2) - parameter).scale(Rat::new(1, 9));
    result
}

fn connection_grading_in_normal_jordan_basis() -> Matrix {
    let connection_grading = scale_matrix(Rat::from(-1), &grading());
    mul_matrix(
        &mul_matrix(&normal_jordan_basis_inverse(), &connection_grading),
        &normal_jordan_basis(),
    )
}

fn normal_block_grading() -> Matrix {
    let jordan = normal_jordan_form();
    let gauge = normal_first_gauge();
    add_matrix(
        &connection_grading_in_normal_jordan_basis(),
        &sub_matrix(&mul_matrix(&jordan, &gauge), &mul_matrix(&gauge, &jordan)),
    )
}

fn normal_second_coefficient() -> Matrix {
    let jordan = normal_jordan_form();
    let gauge = normal_first_gauge();
    let grading = connection_grading_in_normal_jordan_basis();
    let commutator = sub_matrix(&mul_matrix(&jordan, &gauge), &mul_matrix(&gauge, &jordan));
    sub_matrix(
        &sub_matrix(
            &sub_matrix(&mul_matrix(&grading, &gauge), &mul_matrix(&gauge, &grading)),
            &mul_matrix(&gauge, &commutator),
        ),
        &gauge,
    )
}

fn emit_matrix_definition(name: &str, arguments: &str, matrix: &Matrix) {
    println!("def {name}{arguments} : Matrix Index Index ℚ :=");
    print!("  !![");
    for (row, entries) in matrix.iter().enumerate() {
        if row != 0 {
            print!("     ");
        }
        for (column, entry) in entries.iter().enumerate() {
            if column != 0 {
                print!(", ");
            }
            print!("{}", entry.lean());
        }
        if row + 1 == N {
            println!("]\n");
        } else {
            println!(";");
        }
    }
}

fn emit_block_matrix_definition(name: &str, arguments: &str, matrix: &BlockMatrix) {
    println!("def {name}{arguments} : Matrix (Fin 2) (Fin 2) ℚ :=");
    print!("  !![");
    for (row, entries) in matrix.iter().enumerate() {
        if row != 0 {
            print!("     ");
        }
        for (column, entry) in entries.iter().enumerate() {
            if column != 0 {
                print!(", ");
            }
            print!("{}", entry.lean());
        }
        if row + 1 == 2 {
            println!("]\n");
        } else {
            println!(";");
        }
    }
}

fn json_matrix(matrix: &Matrix, indent: &str) -> String {
    let rows = matrix
        .iter()
        .map(|row| {
            let entries = row
                .iter()
                .map(|entry| format!("\"{entry}\""))
                .collect::<Vec<_>>()
                .join(", ");
            format!("{indent}  [{entries}]")
        })
        .collect::<Vec<_>>()
        .join(",\n");
    format!("[\n{rows}\n{indent}]")
}

fn emit_lean(defect: &Matrix) {
    println!("import Mathlib\n");
    println!("/-!");
    println!("# Generated data for the effective Rees-calibration certificate\n");
    println!("This file is generated by `scripts/effective_rees_calibration_cert.rs`.");
    println!("The importing checker proves the matrix correspondence and the");
    println!("conformal classification from these exact formulas.");
    println!("-/\n");
    println!("namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.Generated.EffectiveReesCalibrationData\n");
    println!("abbrev Index := Fin 6\n");
    emit_matrix_definition("conformalDefectFormula", " (a b c d f : ℚ)", defect);
    emit_matrix_definition(
        "transportedEulerFormula",
        " (a b c d f : ℚ)",
        &general_euler_at_one(),
    );
    emit_matrix_definition(
        "oldEulerMultiplicationFormula",
        " (a b : ℚ)",
        &old_euler_multiplication(),
    );
    emit_matrix_definition(
        "leftEulerTransportFormula",
        " (a b c d f : ℚ)",
        &left_euler_transport(),
    );
    emit_matrix_definition(
        "transportedDivisorFormula",
        " (a b c d f : ℚ)",
        &general_divisor_at_one(),
    );
    emit_matrix_definition(
        "oldDivisorMultiplicationFormula",
        " (b : ℚ)",
        &old_divisor_multiplication(),
    );
    emit_matrix_definition(
        "leftDivisorTransportFormula",
        " (a b c d f : ℚ)",
        &left_divisor_transport(),
    );
    emit_matrix_definition(
        "normalCalibration",
        " (b : ℚ)",
        &evaluate_r_one_matrix(&normal_calibration()),
    );
    emit_matrix_definition(
        "normalCalibrationInverse",
        " (b : ℚ)",
        &evaluate_r_one_matrix(&calibration_inverse(&normal_calibration())),
    );
    emit_matrix_definition("normalJordanBasis", " (b : ℚ)", &normal_jordan_basis());
    emit_matrix_definition(
        "normalJordanBasisInverse",
        " (b : ℚ)",
        &normal_jordan_basis_inverse(),
    );
    emit_matrix_definition("normalJordanForm", " (b : ℚ)", &normal_jordan_form());
    emit_matrix_definition(
        "normalGradingInJordanBasis",
        " (b : ℚ)",
        &connection_grading_in_normal_jordan_basis(),
    );
    emit_matrix_definition("normalFirstGauge", " (b : ℚ)", &normal_first_gauge());
    println!("end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.Generated.EffectiveReesCalibrationData");
}

fn emit_json(defect: &Matrix) {
    println!("{{");
    println!("  \"rank\": 6,");
    println!("  \"weights\": [0, 1, 1, 2, 2, 3],");
    println!("  \"free_parameters\": [\"a\", \"b\", \"c\", \"d\", \"f\"],");
    println!("  \"conformal_normal_form\": [\"a=0\", \"c=0\", \"f=b\", \"2d+b^2=0\"],");
    println!("  \"pivot_entries\": [[1, 1], [1, 2], [1, 3], [1, 4]],");
    println!("  \"nonzero_defect_entries\": [");
    let entries = defect
        .iter()
        .enumerate()
        .flat_map(|(row, values)| {
            values
                .iter()
                .enumerate()
                .filter(|(_, value)| !value.is_zero())
                .map(move |(column, value)| (row, column, value))
        })
        .collect::<Vec<_>>();
    for (position, (row, column, value)) in entries.iter().enumerate() {
        let comma = if position + 1 == entries.len() {
            ""
        } else {
            ","
        };
        println!(
            "    {{\"row\": {row}, \"column\": {column}, \"polynomial\": \"{}\"}}{comma}",
            value.lean()
        );
    }
    println!("  ],");
    println!("  \"normal_family_selected_grading\": [\"-1/2\", \"1/2\"],");
    println!("  \"normal_family_second_return_10\": \"0\",");
    println!("  \"normal_family_discriminant\": \"0\"");
    println!("}}");
}

fn emit_distinct_lean() {
    let gauge = distinct_first_gauge();
    let (block_grading, _) = distinct_recurrence();
    println!("import Mathlib\n");
    println!("/-!");
    println!("# Generated data for the effective distinct-order certificate\n");
    println!("This file is generated by `scripts/effective_rees_calibration_cert.rs`.");
    println!("The importing checker reconstructs the native distinct-root algebra,");
    println!("the Sylvester system, and the selected grading from these formulas.");
    println!("-/\n");
    println!("namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.Generated.EffectiveDistinctOrderData\n");
    println!("abbrev Index := Fin 6\n");
    emit_matrix_definition("distinctFirstGaugeFormula", " (a b c d f : ℚ)", &gauge);
    emit_matrix_definition(
        "distinctOldEulerMultiplicationFormula",
        " (a : ℚ)",
        &distinct_old_euler_multiplication(),
    );
    emit_matrix_definition(
        "distinctLeftEulerTransportFormula",
        " (a b c d f : ℚ)",
        &distinct_left_euler_transport(),
    );
    emit_matrix_definition(
        "distinctTransportedEulerFormula",
        " (a b c d f : ℚ)",
        &distinct_transported_euler_formula(),
    );
    emit_matrix_definition(
        "distinctOldDivisorMultiplicationFormula",
        " (a : ℚ)",
        &distinct_old_divisor_multiplication(),
    );
    emit_matrix_definition(
        "distinctLeftDivisorTransportFormula",
        " (a b c d f : ℚ)",
        &distinct_left_divisor_transport(),
    );
    emit_matrix_definition(
        "distinctTransportedDivisorFormula",
        " (a b c d f : ℚ)",
        &distinct_transported_divisor_formula(),
    );
    emit_matrix_definition(
        "distinctNativeGradingFormula",
        " (a b c d f : ℚ)",
        &distinct_native_grading_formula(),
    );
    emit_block_matrix_definition(
        "distinctSelectedBlockGradingFormula",
        " (a b c d f : ℚ)",
        &block_grading,
    );
    println!("end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.Generated.EffectiveDistinctOrderData");
}

fn emit_distinct_json() {
    let gauge = distinct_first_gauge();
    let (block_grading, _) = distinct_recurrence();
    println!("{{");
    println!("  \"schema\": \"effective-distinct-order-certificate-v1\",");
    println!("  \"rank\": 6,");
    println!("  \"weights\": [0, 1, 1, 2, 2, 3],");
    println!("  \"native_order\": \"Q[r][a,b]/(ab-r^2,a^3+b^3-2r^3)\",");
    println!("  \"native_basis\": [\"1\", \"a\", \"b\", \"b^2\", \"-a^2\", \"b^3\"],");
    println!("  \"free_parameters\": [\"a\", \"b\", \"c\", \"d\", \"f\"],");
    println!("  \"conformal_defect_identically_zero\": true,");
    println!("  \"first_gauge\": {},", json_matrix(&gauge, "  "));
    println!("  \"selected_block_grading\": [");
    for (row, entries) in block_grading.iter().enumerate() {
        println!(
            "    [\"{}\", \"{}\"]{}",
            entries[0],
            entries[1],
            if row == 0 { "," } else { "" }
        );
    }
    println!("  ],");
    println!("  \"leading_line_entry\": \"1/6\",");
    println!("  \"leading_line_preserved\": false");
    println!("}}");
}

fn general_euler_at_one() -> Matrix {
    let calibration = calibration();
    let euler_vector = [
        Poly::zero(),
        Poly::from(2),
        Poly::from(3),
        Poly::zero(),
        Poly::zero(),
        Poly::zero(),
    ];
    evaluate_r_one_matrix(&transported_multiplication(&calibration, &euler_vector))
}

fn old_euler_vector() -> Vector {
    [
        Poly::variable(A).scale(Rat::from(-2)) + Poly::variable(B).scale(Rat::from(-3)),
        Poly::from(2),
        Poly::from(3),
        Poly::zero(),
        Poly::zero(),
        Poly::zero(),
    ]
}

fn old_divisor_vector() -> Vector {
    [
        -Poly::variable(B),
        Poly::zero(),
        Poly::from(1),
        Poly::zero(),
        Poly::zero(),
        Poly::zero(),
    ]
}

fn old_euler_multiplication() -> Matrix {
    evaluate_r_one_matrix(&multiplication_of(&old_euler_vector()))
}

fn old_divisor_multiplication() -> Matrix {
    evaluate_r_one_matrix(&multiplication_of(&old_divisor_vector()))
}

fn left_euler_transport() -> Matrix {
    mul_matrix(
        &evaluate_r_one_matrix(&calibration()),
        &old_euler_multiplication(),
    )
}

fn left_divisor_transport() -> Matrix {
    mul_matrix(
        &evaluate_r_one_matrix(&calibration()),
        &old_divisor_multiplication(),
    )
}

fn general_divisor_at_one() -> Matrix {
    let calibration = calibration();
    let divisor_vector = [
        Poly::zero(),
        Poly::zero(),
        Poly::from(1),
        Poly::zero(),
        Poly::zero(),
        Poly::zero(),
    ];
    evaluate_r_one_matrix(&transported_multiplication(&calibration, &divisor_vector))
}

fn defect() -> Matrix {
    let divisor = general_divisor_at_one();
    let mu = grading();
    let divisor_homogeneity = add_matrix(
        &divisor,
        &sub_matrix(&mul_matrix(&divisor, &mu), &mul_matrix(&mu, &divisor)),
    );
    sub_matrix(
        &scale_matrix(
            Rat::new(1, 3),
            &evaluate_r_one_matrix(&euler_derivative(&transported_multiplication(
                &calibration(),
                &[
                    Poly::zero(),
                    Poly::from(2),
                    Poly::from(3),
                    Poly::zero(),
                    Poly::zero(),
                    Poly::zero(),
                ],
            ))),
        ),
        &divisor_homogeneity,
    )
}

fn distinct_defect() -> Matrix {
    let calibration = calibration();
    let divisor_vector = [
        Poly::zero(),
        Poly::from(1),
        Poly::zero(),
        Poly::zero(),
        Poly::zero(),
        Poly::zero(),
    ];
    let euler_vector = [
        Poly::zero(),
        Poly::from(3),
        Poly::zero(),
        Poly::zero(),
        Poly::zero(),
        Poly::zero(),
    ];
    let divisor = evaluate_r_one_matrix(&distinct_transported_multiplication(
        &calibration,
        &divisor_vector,
    ));
    let mu = grading();
    let divisor_homogeneity = add_matrix(
        &divisor,
        &sub_matrix(&mul_matrix(&divisor, &mu), &mul_matrix(&mu, &divisor)),
    );
    sub_matrix(
        &scale_matrix(
            Rat::new(1, 3),
            &evaluate_r_one_matrix(&euler_derivative(&distinct_transported_multiplication(
                &calibration,
                &euler_vector,
            ))),
        ),
        &divisor_homogeneity,
    )
}

fn distinct_old_euler_multiplication() -> Matrix {
    let vector = [
        Poly::variable(A).scale(Rat::from(-3)),
        Poly::from(3),
        Poly::zero(),
        Poly::zero(),
        Poly::zero(),
        Poly::zero(),
    ];
    evaluate_r_one_matrix(&distinct_multiplication_of(&vector))
}

fn distinct_left_euler_transport() -> Matrix {
    mul_matrix(
        &evaluate_r_one_matrix(&calibration()),
        &distinct_old_euler_multiplication(),
    )
}

fn distinct_transported_euler_formula() -> Matrix {
    mul_matrix(
        &distinct_left_euler_transport(),
        &evaluate_r_one_matrix(&calibration_inverse(&calibration())),
    )
}

fn distinct_old_divisor_multiplication() -> Matrix {
    let vector = [
        -Poly::variable(A),
        Poly::from(1),
        Poly::zero(),
        Poly::zero(),
        Poly::zero(),
        Poly::zero(),
    ];
    evaluate_r_one_matrix(&distinct_multiplication_of(&vector))
}

fn distinct_left_divisor_transport() -> Matrix {
    mul_matrix(
        &evaluate_r_one_matrix(&calibration()),
        &distinct_old_divisor_multiplication(),
    )
}

fn distinct_transported_divisor_formula() -> Matrix {
    mul_matrix(
        &distinct_left_divisor_transport(),
        &evaluate_r_one_matrix(&calibration_inverse(&calibration())),
    )
}

fn distinct_native_grading_formula() -> Matrix {
    mul_matrix(
        &mul_matrix(
            &evaluate_r_one_matrix(&calibration_inverse(&calibration())),
            &grading(),
        ),
        &evaluate_r_one_matrix(&calibration()),
    )
}

fn print_nonzero_matrix(matrix: &Matrix) {
    for (row, entries) in matrix.iter().enumerate() {
        for (column, value) in entries.iter().enumerate() {
            if !value.is_zero() {
                println!("D[{row},{column}] = {value}");
            }
        }
    }
}

type BlockMatrix = [[Poly; 2]; 2];

fn distinct_projector() -> Matrix {
    constant_matrix([
        [
            Rat::new(1, 3),
            Rat::new(4, 9),
            Rat::new(2, 9),
            Rat::new(1, 9),
            Rat::new(-5, 9),
            Rat::ZERO,
        ],
        [
            Rat::new(2, 9),
            Rat::new(1, 3),
            Rat::new(1, 9),
            Rat::ZERO,
            Rat::new(-4, 9),
            Rat::new(-1, 9),
        ],
        [
            Rat::new(2, 9),
            Rat::new(1, 9),
            Rat::new(1, 3),
            Rat::new(4, 9),
            Rat::ZERO,
            Rat::new(5, 9),
        ],
        [
            Rat::new(1, 9),
            Rat::ZERO,
            Rat::new(2, 9),
            Rat::new(1, 3),
            Rat::new(1, 9),
            Rat::new(4, 9),
        ],
        [
            Rat::new(-1, 9),
            Rat::new(-2, 9),
            Rat::ZERO,
            Rat::new(1, 9),
            Rat::new(1, 3),
            Rat::new(2, 9),
        ],
        [
            Rat::ZERO,
            Rat::new(-1, 9),
            Rat::new(1, 9),
            Rat::new(2, 9),
            Rat::new(2, 9),
            Rat::new(1, 3),
        ],
    ])
}

fn distinct_selected_basis() -> [[Poly; 2]; N] {
    [
        [Poly::from(-1), Poly::from(-6)],
        [Poly::from(-1), Poly::from(-4)],
        [Poly::from(1), Poly::from(-4)],
        [Poly::from(1), Poly::from(-2)],
        [Poly::from(1), Poly::from(2)],
        [Poly::from(1), Poly::zero()],
    ]
}

fn distinct_left_inverse() -> [[Poly; N]; 2] {
    [
        [
            Poly::zero(),
            Poly::constant(Rat::new(-1, 9)),
            Poly::constant(Rat::new(1, 9)),
            Poly::constant(Rat::new(2, 9)),
            Poly::constant(Rat::new(2, 9)),
            Poly::constant(Rat::new(1, 3)),
        ],
        [
            Poly::constant(Rat::new(-1, 18)),
            Poly::constant(Rat::new(-1, 18)),
            Poly::constant(Rat::new(-1, 18)),
            Poly::constant(Rat::new(-1, 18)),
            Poly::constant(Rat::new(1, 18)),
            Poly::constant(Rat::new(-1, 18)),
        ],
    ]
}

fn compress_distinct(matrix: &Matrix) -> BlockMatrix {
    let left = distinct_left_inverse();
    let selected = distinct_selected_basis();
    std::array::from_fn(|row| {
        std::array::from_fn(|column| {
            (0..N).fold(Poly::zero(), |outer_sum, i| {
                outer_sum
                    + (0..N).fold(Poly::zero(), |inner_sum, j| {
                        inner_sum
                            + left[row][i].clone()
                                * matrix[i][j].clone()
                                * selected[j][column].clone()
                    })
            })
        })
    })
}

fn solve_constant_linear_system(
    coefficients: Vec<Vec<Rat>>,
    right_hand_side: Vec<Poly>,
    variable_count: usize,
) -> Vec<Poly> {
    assert_eq!(coefficients.len(), right_hand_side.len());
    let mut rows = coefficients
        .into_iter()
        .zip(right_hand_side)
        .map(|(mut coefficients, value)| {
            assert_eq!(coefficients.len(), variable_count);
            coefficients.push(Rat::ZERO);
            (coefficients, value)
        })
        .collect::<Vec<_>>();
    let mut pivot_rows = vec![None; variable_count];
    let mut next_row = 0;
    for column in 0..variable_count {
        let Some(pivot) = (next_row..rows.len()).find(|row| !rows[*row].0[column].is_zero()) else {
            continue;
        };
        rows.swap(next_row, pivot);
        let pivot_value = rows[next_row].0[column];
        let inverse = Rat::ONE / pivot_value;
        for entry in &mut rows[next_row].0 {
            *entry = *entry * inverse;
        }
        rows[next_row].1 = rows[next_row].1.scale(inverse);
        let pivot_coefficients = rows[next_row].0.clone();
        let pivot_rhs = rows[next_row].1.clone();
        for (row_index, (row_coefficients, row_rhs)) in rows.iter_mut().enumerate() {
            if row_index == next_row {
                continue;
            }
            let factor = row_coefficients[column];
            if factor.is_zero() {
                continue;
            }
            for index in 0..row_coefficients.len() {
                row_coefficients[index] =
                    row_coefficients[index] - factor * pivot_coefficients[index];
            }
            *row_rhs = row_rhs.clone() - pivot_rhs.clone().scale(factor);
        }
        pivot_rows[column] = Some(next_row);
        next_row += 1;
    }
    for (coefficients, value) in &rows {
        if coefficients[..variable_count]
            .iter()
            .all(|coefficient| coefficient.is_zero())
        {
            assert!(value.is_zero());
        }
    }
    assert!(pivot_rows.iter().all(Option::is_some));
    pivot_rows
        .into_iter()
        .map(|row| rows[row.expect("full column rank")].1.clone())
        .collect()
}

fn distinct_first_gauge() -> Matrix {
    let calibration_at_one = evaluate_r_one_matrix(&calibration());
    let inverse_at_one = evaluate_r_one_matrix(&calibration_inverse(&calibration()));
    let mu_in_native_frame = mul_matrix(
        &mul_matrix(&inverse_at_one, &grading()),
        &calibration_at_one,
    );
    let multiplication = scale_matrix(
        Rat::from(3),
        &evaluate_r_one_matrix(&distinct_a_multiplication()),
    );
    let projector = distinct_projector();
    let complement = sub_matrix(&identity_matrix(), &projector);
    let off_grading = add_matrix(
        &mul_matrix(&mul_matrix(&projector, &mu_in_native_frame), &complement),
        &mul_matrix(&mul_matrix(&complement, &mu_in_native_frame), &projector),
    );

    let mut operators = Vec::with_capacity(N * N);
    for variable in 0..N * N {
        let mut basis = zero_matrix();
        basis[variable / N][variable % N] = Poly::from(1);
        operators.push([
            sub_matrix(
                &mul_matrix(&multiplication, &basis),
                &mul_matrix(&basis, &multiplication),
            ),
            mul_matrix(&mul_matrix(&projector, &basis), &projector),
            mul_matrix(&mul_matrix(&complement, &basis), &complement),
        ]);
    }

    let right_hand_sides = [off_grading, zero_matrix(), zero_matrix()];
    let mut coefficients = Vec::new();
    let mut right_hand_side = Vec::new();
    for constraint in 0..3 {
        for row in 0..N {
            for column in 0..N {
                coefficients.push(
                    operators
                        .iter()
                        .map(|operator| operator[constraint][row][column].as_constant())
                        .collect(),
                );
                right_hand_side.push(right_hand_sides[constraint][row][column].clone());
            }
        }
    }
    let solution = solve_constant_linear_system(coefficients, right_hand_side, N * N);
    std::array::from_fn(|row| std::array::from_fn(|column| solution[row * N + column].clone()))
}

fn distinct_recurrence() -> (BlockMatrix, BlockMatrix) {
    let calibration_at_one = evaluate_r_one_matrix(&calibration());
    let inverse_at_one = evaluate_r_one_matrix(&calibration_inverse(&calibration()));
    let connection_grading = scale_matrix(
        Rat::from(-1),
        &mul_matrix(
            &mul_matrix(&inverse_at_one, &grading()),
            &calibration_at_one,
        ),
    );
    let multiplication = scale_matrix(
        Rat::from(3),
        &evaluate_r_one_matrix(&distinct_a_multiplication()),
    );
    let gauge = distinct_first_gauge();
    let commutator = sub_matrix(
        &mul_matrix(&multiplication, &gauge),
        &mul_matrix(&gauge, &multiplication),
    );
    let block_grading = add_matrix(&connection_grading, &commutator);
    let second = sub_matrix(
        &sub_matrix(
            &sub_matrix(
                &mul_matrix(&connection_grading, &gauge),
                &mul_matrix(&gauge, &connection_grading),
            ),
            &mul_matrix(&gauge, &commutator),
        ),
        &gauge,
    );
    (
        compress_distinct(&block_grading),
        compress_distinct(&second),
    )
}

fn print_block(name: &str, matrix: &BlockMatrix) {
    for (row, entries) in matrix.iter().enumerate() {
        for (column, value) in entries.iter().enumerate() {
            println!("{name}[{row},{column}] = {value}");
        }
    }
}

fn main() {
    let mode = env::args().nth(1);
    let calibration = calibration();
    let inverse = calibration_inverse(&calibration);
    assert_eq!(mul_matrix(&calibration, &inverse), identity_matrix());
    assert_eq!(
        mul_matrix(
            &mul_matrix(&transpose(&calibration), &pairing()),
            &calibration
        ),
        pairing()
    );
    let defect = evaluate_r_one_matrix(&defect());
    let specialized_defect = substitute_matrix(&defect, &normal_substitution());
    assert_eq!(specialized_defect, zero_matrix());

    assert_eq!(defect[1][1], Poly::variable(A).scale(Rat::new(-4, 3)));
    assert_eq!(
        defect[1][2],
        (Poly::variable(F) - Poly::variable(B)).scale(Rat::new(2, 3))
    );
    assert_eq!(
        defect[1][3],
        (-Poly::variable(C) + Poly::variable(A) * Poly::variable(F)).scale(Rat::new(4, 3))
    );

    let normalized_calibration = evaluate_r_one_matrix(&normal_calibration());
    let normal_inverse = evaluate_r_one_matrix(&calibration_inverse(&normal_calibration()));
    assert_eq!(
        mul_matrix(&normalized_calibration, &normal_inverse),
        identity_matrix()
    );
    let normal_basis = normal_jordan_basis();
    let normal_basis_inverse = normal_jordan_basis_inverse();
    assert_eq!(
        mul_matrix(&normal_basis, &normal_basis_inverse),
        identity_matrix()
    );
    assert_eq!(
        mul_matrix(&normal_basis_inverse, &normal_basis),
        identity_matrix()
    );
    let actual_jordan = mul_matrix(
        &mul_matrix(&normal_basis_inverse, &normal_euler()),
        &normal_basis,
    );
    assert_eq!(actual_jordan, normal_jordan_form());

    let block_grading = normal_block_grading();
    let second = normal_second_coefficient();
    assert_eq!(block_grading[0][0], Poly::constant(Rat::new(-1, 2)));
    assert_eq!(block_grading[0][1], Poly::zero());
    assert_eq!(block_grading[1][0], Poly::zero());
    assert_eq!(block_grading[1][1], Poly::constant(Rat::new(1, 2)));
    assert_eq!(second[1][0], Poly::zero());

    let distinct_defect_value = evaluate_r_one_matrix(&distinct_defect());
    assert_eq!(distinct_defect_value, zero_matrix());
    let distinct_gauge = distinct_first_gauge();
    let distinct_projector = distinct_projector();
    let distinct_complement = sub_matrix(&identity_matrix(), &distinct_projector);
    let distinct_calibration = evaluate_r_one_matrix(&calibration);
    let distinct_inverse = evaluate_r_one_matrix(&calibration_inverse(&calibration));
    let distinct_mu = mul_matrix(
        &mul_matrix(&distinct_inverse, &grading()),
        &distinct_calibration,
    );
    let distinct_u = scale_matrix(
        Rat::from(3),
        &evaluate_r_one_matrix(&distinct_a_multiplication()),
    );
    let distinct_off_mu = add_matrix(
        &mul_matrix(
            &mul_matrix(&distinct_projector, &distinct_mu),
            &distinct_complement,
        ),
        &mul_matrix(
            &mul_matrix(&distinct_complement, &distinct_mu),
            &distinct_projector,
        ),
    );
    assert_eq!(
        sub_matrix(
            &mul_matrix(&distinct_u, &distinct_gauge),
            &mul_matrix(&distinct_gauge, &distinct_u),
        ),
        distinct_off_mu
    );
    assert_eq!(
        mul_matrix(
            &mul_matrix(&distinct_projector, &distinct_gauge),
            &distinct_projector,
        ),
        zero_matrix()
    );
    assert_eq!(
        mul_matrix(
            &mul_matrix(&distinct_complement, &distinct_gauge),
            &distinct_complement,
        ),
        zero_matrix()
    );
    let (distinct_block_grading, _) = distinct_recurrence();
    assert_eq!(distinct_block_grading[1][0], Poly::constant(Rat::new(1, 6)));
    for row in 0..N {
        for column in 0..N {
            if (row < 2) != (column < 2) {
                assert!(block_grading[row][column].is_zero());
            }
        }
    }

    match mode.as_deref() {
        Some("--distinct-debug") => {
            print_nonzero_matrix(&evaluate_r_one_matrix(&distinct_defect()));
            print_nonzero_matrix(&distinct_first_gauge());
            let (block_grading, second) = distinct_recurrence();
            print_block("B", &block_grading);
            print_block("S", &second);
        }
        Some("--distinct-lean") => emit_distinct_lean(),
        Some("--distinct-json") => emit_distinct_json(),
        Some("--lean") => emit_lean(&defect),
        Some("--json") => emit_json(&defect),
        Some(other) => panic!("unknown argument: {}", other),
        None => {
            println!("effective self-dual calibration: five parameters");
            println!("conformal normal form: a=c=0, f=b, 2d+b^2=0");
            println!("normal-family selected discriminant: 0");
            for (row, entries) in defect.iter().enumerate() {
                for (column, entry) in entries.iter().enumerate() {
                    if !entry.is_zero() {
                        println!("D[{row},{column}] = {entry}");
                    }
                }
            }
        }
    }
}
