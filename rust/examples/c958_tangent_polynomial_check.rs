//! Exact finite-field polynomial-identity checker for the C958 quintic inverse.

use serde_json::Value;
use std::collections::HashMap;
use std::env;
use std::fs;

const PRIME: u64 = 1_000_033;
type Exp = [u8; 4];

#[derive(Clone, Default)]
struct Poly(HashMap<Exp, u64>);

impl Poly {
    fn monomial(exp: Exp, coefficient: u64) -> Self {
        let mut terms = HashMap::new();
        if !coefficient.is_multiple_of(PRIME) {
            terms.insert(exp, coefficient % PRIME);
        }
        Self(terms)
    }

    fn add_scaled(&mut self, other: &Self, scale: u64) {
        for (&exp, &coefficient) in &other.0 {
            let value = (coefficient * scale) % PRIME;
            let entry = self.0.entry(exp).or_default();
            *entry = (*entry + value) % PRIME;
            if *entry == 0 {
                self.0.remove(&exp);
            }
        }
    }

    fn add(&self, other: &Self) -> Self {
        let mut answer = self.clone();
        answer.add_scaled(other, 1);
        answer
    }

    fn sub(&self, other: &Self) -> Self {
        let mut answer = self.clone();
        answer.add_scaled(other, PRIME - 1);
        answer
    }

    fn scale(&self, scalar: u64) -> Self {
        let mut answer = Self::default();
        answer.add_scaled(self, scalar % PRIME);
        answer
    }

    fn mul(&self, other: &Self) -> Self {
        // Cartesian product size is a catastrophically bad capacity estimate:
        // thousands of products coalesce onto each four-variable monomial.
        let capacity = self.0.len().saturating_mul(other.0.len()).min(262_144);
        let mut answer = HashMap::with_capacity(capacity);
        for (&left_exp, &left_coefficient) in &self.0 {
            for (&right_exp, &right_coefficient) in &other.0 {
                let exp = std::array::from_fn(|i| left_exp[i] + right_exp[i]);
                let value = (left_coefficient * right_coefficient) % PRIME;
                let entry = answer.entry(exp).or_default();
                *entry = (*entry + value) % PRIME;
            }
        }
        answer.retain(|_, coefficient| *coefficient != 0);
        Self(answer)
    }
}

fn determinant3(matrix: &[Vec<Poly>]) -> Poly {
    matrix[0][0]
        .mul(
            &matrix[1][1]
                .mul(&matrix[2][2])
                .sub(&matrix[1][2].mul(&matrix[2][1])),
        )
        .sub(
            &matrix[0][1].mul(
                &matrix[1][0]
                    .mul(&matrix[2][2])
                    .sub(&matrix[1][2].mul(&matrix[2][0])),
            ),
        )
        .add(
            &matrix[0][2].mul(
                &matrix[1][0]
                    .mul(&matrix[2][1])
                    .sub(&matrix[1][1].mul(&matrix[2][0])),
            ),
        )
}

fn decimal_mod(text: &str) -> u64 {
    let (negative, digits) = text
        .strip_prefix('-')
        .map_or((false, text), |rest| (true, rest));
    let value = digits.bytes().fold(0, |value, digit| {
        (value * 10 + u64::from(digit - b'0')) % PRIME
    });
    if negative && value != 0 {
        PRIME - value
    } else {
        value
    }
}

fn mod_pow(mut base: u64, mut exponent: u64) -> u64 {
    let mut answer = 1;
    while exponent != 0 {
        if exponent & 1 != 0 {
            answer = answer * base % PRIME;
        }
        base = base * base % PRIME;
        exponent >>= 1;
    }
    answer
}

fn scalar(text: &str) -> u64 {
    if let Some((numerator, denominator)) = text.split_once('/') {
        decimal_mod(numerator) * mod_pow(decimal_mod(denominator), PRIME - 2) % PRIME
    } else {
        decimal_mod(text)
    }
}

fn row_values(value: &Value, key: &str) -> Vec<Vec<u64>> {
    value["forward_linear_forms"][key]
        .as_array()
        .unwrap()
        .iter()
        .map(|row| {
            row.as_array()
                .unwrap()
                .iter()
                .map(|x| scalar(x.as_str().unwrap()))
                .collect()
        })
        .collect()
}

type HomogeneousTerm = (u64, [u8; 5]);

fn horner(terms: &[HomogeneousTerm], variable: usize, bases: &[Poly]) -> Poly {
    if terms.is_empty() {
        return Poly::default();
    }
    if variable == 5 {
        return Poly::monomial(
            [0; 4],
            terms.iter().fold(0, |sum, term| (sum + term.0) % PRIME),
        );
    }
    let mut groups: [Vec<HomogeneousTerm>; 6] = std::array::from_fn(|_| Vec::new());
    let mut maximum = 0;
    for term in terms {
        let exponent = usize::from(term.1[variable]);
        maximum = maximum.max(exponent);
        groups[exponent].push(*term);
    }
    let mut answer = horner(&groups[maximum], variable + 1, bases);
    for exponent in (0..maximum).rev() {
        answer = answer.mul(&bases[variable]);
        if !groups[exponent].is_empty() {
            answer = answer.add(&horner(&groups[exponent], variable + 1, bases));
        }
    }
    answer
}

fn homogeneous(sparse: &Value, degree: usize, bases: &[Poly]) -> Poly {
    let terms: Vec<HomogeneousTerm> = sparse
        .as_array()
        .unwrap()
        .iter()
        .map(|term| {
            let coefficient = decimal_mod(term["coefficient"].as_str().unwrap());
            let affine: Vec<u8> = term["exponents"]
                .as_array()
                .unwrap()
                .iter()
                .map(|x| x.as_u64().unwrap() as u8)
                .collect();
            let affine_degree: usize = affine.iter().map(|&x| usize::from(x)).sum();
            (
                coefficient,
                [
                    (degree - affine_degree) as u8,
                    affine[0],
                    affine[1],
                    affine[2],
                    affine[3],
                ],
            )
        })
        .collect();
    horner(&terms, 0, bases)
}

fn main() {
    let path = env::args()
        .nth(1)
        .expect("usage: c958_tangent_polynomial_check CERTIFICATE");
    let value: Value = serde_json::from_str(&fs::read_to_string(path).unwrap()).unwrap();
    let slices = row_values(&value, "slice_rows");
    let tangents = row_values(&value, "tangent_rows");

    let p = Poly::monomial([1, 1, 1, 1], 1);
    let constants = [
        Poly::monomial([2, 1, 1, 1], 1),
        Poly::monomial([1, 2, 1, 1], 1),
        p,
        Poly::monomial([1, 1, 2, 1], 1),
        Poly::monomial([1, 1, 1, 2], 1),
    ];
    let mut linear = vec![vec![Poly::default(); 3]; 16];
    let specifications: [(usize, Exp, [i64; 3]); 10] = [
        (5, [0, 0, 1, 1], [0, 0, 1]),
        (6, [0, 1, 1, 1], [0, 1, 0]),
        (7, [0, 1, 0, 1], [0, 1, -1]),
        (8, [0, 1, 1, 0], [0, 3, -2]),
        (9, [1, 0, 1, 1], [1, 0, 0]),
        (10, [1, 0, 0, 1], [1, 0, -1]),
        (11, [1, 0, 1, 0], [3, 0, -1]),
        (12, [1, 1, 0, 1], [1, -1, 0]),
        (13, [1, 1, 1, 0], [2, -1, 0]),
        (14, [1, 1, 0, 0], [1, -2, 1]),
    ];
    for (index, exp, coefficients) in specifications {
        for (variable, coefficient) in coefficients.into_iter().enumerate() {
            let reduced = coefficient.rem_euclid(PRIME as i64) as u64;
            linear[index][variable] = Poly::monomial(exp, reduced);
        }
    }

    let mut matrix = vec![vec![Poly::default(); 3]; 3];
    let mut rhs = vec![Poly::default(); 3];
    for row in 0..3 {
        for (index, constant) in constants.iter().enumerate() {
            rhs[row].add_scaled(constant, (PRIME - slices[row][index]) % PRIME);
        }
        for variable in 0..3 {
            for (index, entry) in linear.iter().enumerate() {
                matrix[row][variable].add_scaled(&entry[variable], slices[row][index]);
            }
        }
        assert_eq!(slices[row][15], 0);
    }
    let delta = determinant3(&matrix);
    let mut z = Vec::new();
    for column in 0..3 {
        let mut replaced = matrix.clone();
        for row in 0..3 {
            replaced[row][column] = rhs[row].clone();
        }
        z.push(determinant3(&replaced));
    }
    let delta_squared = delta.mul(&delta);

    let mut scaled_cox = vec![Poly::default(); 16];
    for (index, constant) in constants.iter().enumerate() {
        scaled_cox[index] = constant.mul(&delta_squared);
    }
    for index in 5..15 {
        let mut combined = Poly::default();
        for (variable, z_value) in z.iter().enumerate() {
            combined = combined.add(&linear[index][variable].mul(z_value));
        }
        scaled_cox[index] = combined.mul(&delta);
    }
    scaled_cox[15] = z[0]
        .mul(&z[1])
        .scale(PRIME - 3)
        .add(&z[0].mul(&z[2]).scale(4))
        .sub(&z[1].mul(&z[2]));

    let mut rho = vec![Poly::default(); 5];
    for row in 0..5 {
        for (coefficient, coordinate) in tangents[row].iter().zip(&scaled_cox) {
            rho[row].add_scaled(coordinate, *coefficient);
        }
        eprintln!("rho{row}: {} terms", rho[row].0.len());
    }
    let degree = value["inverse_degree"].as_u64().unwrap() as usize;
    let denominator = homogeneous(&value["common_denominator"], degree, &rho);
    eprintln!("denominator: {} terms", denominator.0.len());
    let coordinate_polys = [
        Poly::monomial([1, 0, 0, 0], 1),
        Poly::monomial([0, 1, 0, 0], 1),
        Poly::monomial([0, 0, 1, 0], 1),
        Poly::monomial([0, 0, 0, 1], 1),
    ];
    for (index, coordinate) in coordinate_polys.iter().enumerate() {
        let numerator = homogeneous(&value["numerators"][index], degree, &rho);
        let residual = numerator.sub(&coordinate.mul(&denominator));
        assert!(
            residual.0.is_empty(),
            "nonzero residual for coordinate {index}"
        );
        println!("coordinate {index}: exact polynomial identity modulo {PRIME}");
    }
}
