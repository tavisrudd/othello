//! Exact integer polynomial-identity checker for the C958 quintic inverse.

use num_bigint::BigInt;
use num_integer::Integer;
use num_traits::{One, Zero};
use serde_json::Value;
use std::collections::HashMap;
use std::env;
use std::fs;

type Exp = [u8; 4];

#[derive(Clone, Default)]
struct Poly(HashMap<Exp, BigInt>);

impl Poly {
    fn monomial(exp: Exp, coefficient: BigInt) -> Self {
        let mut terms = HashMap::new();
        if !coefficient.is_zero() {
            terms.insert(exp, coefficient);
        }
        Self(terms)
    }

    fn add_scaled(&mut self, other: &Self, scale: &BigInt) {
        for (&exp, coefficient) in &other.0 {
            let value = coefficient * scale;
            let entry = self.0.entry(exp).or_default();
            *entry += value;
            if entry.is_zero() {
                self.0.remove(&exp);
            }
        }
    }

    fn add(&self, other: &Self) -> Self {
        let mut answer = self.clone();
        answer.add_scaled(other, &BigInt::one());
        answer
    }

    fn sub(&self, other: &Self) -> Self {
        let mut answer = self.clone();
        answer.add_scaled(other, &(-BigInt::one()));
        answer
    }

    fn scale(&self, scalar: &BigInt) -> Self {
        let mut answer = Self::default();
        answer.add_scaled(self, scalar);
        answer
    }

    fn mul(&self, other: &Self) -> Self {
        // Cartesian product size is a catastrophically bad capacity estimate:
        // thousands of products coalesce onto each four-variable monomial.
        let capacity = self.0.len().saturating_mul(other.0.len()).min(262_144);
        let mut answer: HashMap<Exp, BigInt> = HashMap::with_capacity(capacity);
        for (&left_exp, left_coefficient) in &self.0 {
            for (&right_exp, right_coefficient) in &other.0 {
                let exp = std::array::from_fn(|i| left_exp[i] + right_exp[i]);
                let value = left_coefficient * right_coefficient;
                let entry = answer.entry(exp).or_default();
                *entry += value;
            }
        }
        answer.retain(|_, coefficient| !coefficient.is_zero());
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

fn scalar(text: &str) -> (BigInt, BigInt) {
    if let Some((numerator, denominator)) = text.split_once('/') {
        (numerator.parse().unwrap(), denominator.parse().unwrap())
    } else {
        (text.parse().unwrap(), BigInt::one())
    }
}

fn row_values(value: &Value, key: &str, one_scale: bool) -> Vec<Vec<BigInt>> {
    let rows: Vec<Vec<(BigInt, BigInt)>> = value["forward_linear_forms"][key]
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
        .collect();
    let global_lcm = rows
        .iter()
        .flatten()
        .fold(BigInt::one(), |lcm, entry| lcm.lcm(&entry.1));
    rows.iter()
        .map(|row| {
            let lcm = if one_scale {
                global_lcm.clone()
            } else {
                row.iter()
                    .fold(BigInt::one(), |lcm, entry| lcm.lcm(&entry.1))
            };
            row.iter()
                .map(|(numerator, denominator)| numerator * (&lcm / denominator))
                .collect()
        })
        .collect()
}

type HomogeneousTerm = (BigInt, [u8; 5]);

fn horner(terms: &[HomogeneousTerm], variable: usize, bases: &[Poly]) -> Poly {
    if terms.is_empty() {
        return Poly::default();
    }
    if variable == 5 {
        return Poly::monomial(
            [0; 4],
            terms.iter().fold(BigInt::zero(), |sum, term| sum + &term.0),
        );
    }
    let mut groups: [Vec<HomogeneousTerm>; 6] = std::array::from_fn(|_| Vec::new());
    let mut maximum = 0;
    for term in terms {
        let exponent = usize::from(term.1[variable]);
        maximum = maximum.max(exponent);
        groups[exponent].push(term.clone());
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
            let coefficient = term["coefficient"].as_str().unwrap().parse().unwrap();
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
    let slices = row_values(&value, "slice_rows", false);
    let tangents = row_values(&value, "tangent_rows", true);

    let p = Poly::monomial([1, 1, 1, 1], BigInt::one());
    let constants = [
        Poly::monomial([2, 1, 1, 1], BigInt::one()),
        Poly::monomial([1, 2, 1, 1], BigInt::one()),
        p,
        Poly::monomial([1, 1, 2, 1], BigInt::one()),
        Poly::monomial([1, 1, 1, 2], BigInt::one()),
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
            linear[index][variable] = Poly::monomial(exp, coefficient.into());
        }
    }

    let mut matrix = vec![vec![Poly::default(); 3]; 3];
    let mut rhs = vec![Poly::default(); 3];
    for row in 0..3 {
        for (index, constant) in constants.iter().enumerate() {
            rhs[row].add_scaled(constant, &(-&slices[row][index]));
        }
        for variable in 0..3 {
            for (index, entry) in linear.iter().enumerate() {
                matrix[row][variable].add_scaled(&entry[variable], &slices[row][index]);
            }
        }
        assert!(slices[row][15].is_zero());
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
        .scale(&BigInt::from(-3))
        .add(&z[0].mul(&z[2]).scale(&BigInt::from(4)))
        .sub(&z[1].mul(&z[2]));

    let mut rho = vec![Poly::default(); 5];
    for row in 0..5 {
        for (coefficient, coordinate) in tangents[row].iter().zip(&scaled_cox) {
            rho[row].add_scaled(coordinate, coefficient);
        }
        eprintln!("rho{row}: {} terms", rho[row].0.len());
    }
    let degree = value["inverse_degree"].as_u64().unwrap() as usize;
    let denominator = homogeneous(&value["common_denominator"], degree, &rho);
    eprintln!("denominator: {} terms", denominator.0.len());
    let coordinate_polys = [
        Poly::monomial([1, 0, 0, 0], BigInt::one()),
        Poly::monomial([0, 1, 0, 0], BigInt::one()),
        Poly::monomial([0, 0, 1, 0], BigInt::one()),
        Poly::monomial([0, 0, 0, 1], BigInt::one()),
    ];
    for (index, coordinate) in coordinate_polys.iter().enumerate() {
        let numerator = homogeneous(&value["numerators"][index], degree, &rho);
        let residual = numerator.sub(&coordinate.mul(&denominator));
        assert!(
            residual.0.is_empty(),
            "nonzero residual for coordinate {index}"
        );
        println!("coordinate {index}: exact polynomial identity over Z");
    }
}
