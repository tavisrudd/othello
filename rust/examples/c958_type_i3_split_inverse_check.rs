//! Independent modular polynomial-identity checker for the C958 type-I3 inverse.
//!
//! This is intentionally not, by itself, a characteristic-zero proof.  It
//! evaluates the exact formula strings in several 24-dimensional specialized
//! quotient algebras, then checks the full landing and two projective composite
//! polynomial identities.  A generic certificate must additionally supply a
//! degree/height bound and a sufficiently large deterministic evaluation set.

use serde_json::Value;
use std::collections::HashMap;
use std::env;
use std::fs;
use std::time::Instant;

const DIM: usize = 24;

#[derive(Clone)]
struct Context {
    modulus: u64,
    a: u64,
    beta: u64,
}

impl Context {
    fn add(&self, x: u64, y: u64) -> u64 {
        let value = x + y;
        if value >= self.modulus {
            value - self.modulus
        } else {
            value
        }
    }

    fn neg(&self, x: u64) -> u64 {
        if x == 0 {
            0
        } else {
            self.modulus - x
        }
    }

    fn sub(&self, x: u64, y: u64) -> u64 {
        self.add(x, self.neg(y))
    }

    fn mul(&self, x: u64, y: u64) -> u64 {
        ((u128::from(x) * u128::from(y)) % u128::from(self.modulus)) as u64
    }

    fn pow(&self, mut x: u64, mut exponent: u64) -> u64 {
        let mut answer = 1;
        while exponent != 0 {
            if exponent & 1 != 0 {
                answer = self.mul(answer, x);
            }
            x = self.mul(x, x);
            exponent >>= 1;
        }
        answer
    }

    fn integer(&self, text: &str) -> u64 {
        text.bytes().fold(0, |value, digit| {
            self.add(self.mul(value, 10), u64::from(digit - b'0'))
        })
    }
}

// Basis order: delta^e_delta d^e_d r^e_r g^e_g, with dimensions 2,2,3,2.
fn basis_index(g: u8, r: u8, d: u8, delta: u8) -> usize {
    (((usize::from(delta) * 2 + usize::from(d)) * 3 + usize::from(r)) * 2) + usize::from(g)
}

#[derive(Clone, Debug, PartialEq, Eq)]
struct FieldElement([u64; DIM]);

impl FieldElement {
    fn zero() -> Self {
        Self([0; DIM])
    }

    fn one() -> Self {
        let mut answer = Self::zero();
        answer.0[0] = 1;
        answer
    }

    fn scalar(value: u64) -> Self {
        let mut answer = Self::zero();
        answer.0[0] = value;
        answer
    }

    fn generator(g: u8, r: u8, d: u8, delta: u8) -> Self {
        let mut answer = Self::zero();
        answer.0[basis_index(g, r, d, delta)] = 1;
        answer
    }

    fn is_zero(&self) -> bool {
        self.0.iter().all(|&x| x == 0)
    }

    fn add_assign(&mut self, other: &Self, context: &Context) {
        for (left, &right) in self.0.iter_mut().zip(&other.0) {
            *left = context.add(*left, right);
        }
    }

    fn add(&self, other: &Self, context: &Context) -> Self {
        let mut answer = self.clone();
        answer.add_assign(other, context);
        answer
    }

    fn neg(&self, context: &Context) -> Self {
        Self(self.0.map(|x| context.neg(x)))
    }

    fn sub(&self, other: &Self, context: &Context) -> Self {
        self.add(&other.neg(context), context)
    }

    fn reduced_term(answer: &mut Self, coefficient: u64, exponents: [u8; 4], context: &Context) {
        if coefficient == 0 {
            return;
        }
        let [g, r, d, delta] = exponents;
        if delta >= 2 {
            let a4 = context.pow(context.a, 4);
            let a_beta = context.mul(context.a, context.beta);
            let constant = context.neg(context.add(context.mul(52, a4), context.mul(36, a_beta)));
            let g_coefficient =
                context.neg(context.add(context.mul(32, a4), context.mul(24, a_beta)));
            Self::reduced_term(
                answer,
                context.mul(coefficient, constant),
                [g, r, d, delta - 2],
                context,
            );
            Self::reduced_term(
                answer,
                context.mul(coefficient, g_coefficient),
                [g + 1, r, d, delta - 2],
                context,
            );
        } else if d >= 2 {
            Self::reduced_term(
                answer,
                context.mul(coefficient, context.mul(4, context.pow(context.a, 2))),
                [g, r, d - 2, delta],
                context,
            );
            Self::reduced_term(
                answer,
                context.mul(coefficient, context.neg(3)),
                [g, r + 2, d - 2, delta],
                context,
            );
        } else if r >= 3 {
            Self::reduced_term(
                answer,
                context.mul(coefficient, context.pow(context.a, 2)),
                [g, r - 2, d, delta],
                context,
            );
            let constant = context.neg(context.add(context.pow(context.a, 3), context.beta));
            Self::reduced_term(
                answer,
                context.mul(coefficient, constant),
                [g, r - 3, d, delta],
                context,
            );
        } else if g >= 2 {
            Self::reduced_term(
                answer,
                context.mul(coefficient, 3),
                [g - 2, r, d, delta],
                context,
            );
        } else {
            let index = basis_index(g, r, d, delta);
            answer.0[index] = context.add(answer.0[index], coefficient);
        }
    }

    fn mul(&self, other: &Self, context: &Context) -> Self {
        let mut answer = Self::zero();
        for (left_index, &left) in self.0.iter().enumerate().filter(|(_, &x)| x != 0) {
            let left_g = (left_index % 2) as u8;
            let left_r = ((left_index / 2) % 3) as u8;
            let left_d = ((left_index / 6) % 2) as u8;
            let left_delta = (left_index / 12) as u8;
            for (right_index, &right) in other.0.iter().enumerate().filter(|(_, &x)| x != 0) {
                let exponents = [
                    left_g + (right_index % 2) as u8,
                    left_r + ((right_index / 2) % 3) as u8,
                    left_d + ((right_index / 6) % 2) as u8,
                    left_delta + (right_index / 12) as u8,
                ];
                Self::reduced_term(&mut answer, context.mul(left, right), exponents, context);
            }
        }
        answer
    }

    fn pow(&self, mut exponent: u32, context: &Context) -> Self {
        let mut base = self.clone();
        let mut answer = Self::one();
        while exponent != 0 {
            if exponent & 1 != 0 {
                answer = answer.mul(&base, context);
            }
            base = base.mul(&base, context);
            exponent >>= 1;
        }
        answer
    }

    #[allow(clippy::needless_range_loop)]
    fn inverse(&self, context: &Context) -> Option<Self> {
        let mut matrix = vec![[0_u64; DIM + 1]; DIM];
        for column in 0..DIM {
            let product = self.mul(
                &Self::generator(
                    (column % 2) as u8,
                    ((column / 2) % 3) as u8,
                    ((column / 6) % 2) as u8,
                    (column / 12) as u8,
                ),
                context,
            );
            for (row, &value) in product.0.iter().enumerate() {
                matrix[row][column] = value;
            }
        }
        matrix[0][DIM] = 1;
        for column in 0..DIM {
            let pivot = (column..DIM).find(|&row| matrix[row][column] != 0)?;
            matrix.swap(column, pivot);
            let inverse = context.pow(matrix[column][column], context.modulus - 2);
            for entry in &mut matrix[column][column..=DIM] {
                *entry = context.mul(*entry, inverse);
            }
            for row in 0..DIM {
                if row == column {
                    continue;
                }
                let scale = matrix[row][column];
                if scale == 0 {
                    continue;
                }
                for entry in column..=DIM {
                    matrix[row][entry] = context.sub(
                        matrix[row][entry],
                        context.mul(scale, matrix[column][entry]),
                    );
                }
            }
        }
        Some(Self(std::array::from_fn(|row| matrix[row][DIM])))
    }
}

#[derive(Debug)]
enum Expr {
    Number(String),
    Variable(String),
    Neg(Box<Expr>),
    Add(Box<Expr>, Box<Expr>),
    Sub(Box<Expr>, Box<Expr>),
    Mul(Box<Expr>, Box<Expr>),
    Div(Box<Expr>, Box<Expr>),
    Pow(Box<Expr>, u32),
}

struct Parser<'a> {
    text: &'a [u8],
    position: usize,
}

impl<'a> Parser<'a> {
    fn new(text: &'a str) -> Self {
        Self {
            text: text.as_bytes(),
            position: 0,
        }
    }
    fn whitespace(&mut self) {
        while self.position < self.text.len() && self.text[self.position].is_ascii_whitespace() {
            self.position += 1;
        }
    }
    fn take(&mut self, token: &[u8]) -> bool {
        self.whitespace();
        if self.text[self.position..].starts_with(token) {
            self.position += token.len();
            true
        } else {
            false
        }
    }
    fn sum(&mut self) -> Expr {
        let mut answer = self.product();
        loop {
            if self.take(b"+") {
                answer = Expr::Add(Box::new(answer), Box::new(self.product()));
            } else if self.take(b"-") {
                answer = Expr::Sub(Box::new(answer), Box::new(self.product()));
            } else {
                return answer;
            }
        }
    }
    fn product(&mut self) -> Expr {
        let mut answer = self.unary();
        loop {
            self.whitespace();
            if self.text[self.position..].starts_with(b"**") {
                return answer;
            }
            if self.take(b"*") {
                answer = Expr::Mul(Box::new(answer), Box::new(self.unary()));
            } else if self.take(b"/") {
                answer = Expr::Div(Box::new(answer), Box::new(self.unary()));
            } else {
                return answer;
            }
        }
    }
    fn unary(&mut self) -> Expr {
        if self.take(b"+") {
            self.unary()
        } else if self.take(b"-") {
            Expr::Neg(Box::new(self.unary()))
        } else {
            self.power()
        }
    }
    fn power(&mut self) -> Expr {
        let base = self.atom();
        if self.take(b"**") {
            self.whitespace();
            let start = self.position;
            while self.position < self.text.len() && self.text[self.position].is_ascii_digit() {
                self.position += 1;
            }
            assert!(self.position > start, "nonliteral exponent");
            let exponent = std::str::from_utf8(&self.text[start..self.position])
                .unwrap()
                .parse()
                .unwrap();
            Expr::Pow(Box::new(base), exponent)
        } else {
            base
        }
    }
    fn atom(&mut self) -> Expr {
        self.whitespace();
        if self.take(b"(") {
            let answer = self.sum();
            assert!(self.take(b")"), "missing closing parenthesis");
            return answer;
        }
        let start = self.position;
        if self.position < self.text.len() && self.text[self.position].is_ascii_digit() {
            while self.position < self.text.len() && self.text[self.position].is_ascii_digit() {
                self.position += 1;
            }
            Expr::Number(
                std::str::from_utf8(&self.text[start..self.position])
                    .unwrap()
                    .to_owned(),
            )
        } else {
            while self.position < self.text.len()
                && (self.text[self.position].is_ascii_alphanumeric()
                    || self.text[self.position] == b'_')
            {
                self.position += 1;
            }
            assert!(
                self.position > start,
                "expected atom at byte {}",
                self.position
            );
            Expr::Variable(
                std::str::from_utf8(&self.text[start..self.position])
                    .unwrap()
                    .to_owned(),
            )
        }
    }
    fn finish(mut self) -> Expr {
        let answer = self.sum();
        self.whitespace();
        assert_eq!(self.position, self.text.len(), "unparsed expression suffix");
        answer
    }
}

fn evaluate(expression: &Expr, context: &Context) -> Result<FieldElement, String> {
    let a = FieldElement::scalar(context.a);
    let beta = FieldElement::scalar(context.beta);
    match expression {
        Expr::Number(text) => Ok(FieldElement::scalar(context.integer(text))),
        Expr::Variable(name) => Ok(match name.as_str() {
            "a" => a,
            "beta" => beta,
            "g" => FieldElement::generator(1, 0, 0, 0),
            "r" => FieldElement::generator(0, 1, 0, 0),
            "d" => FieldElement::generator(0, 0, 1, 0),
            "delta" => FieldElement::generator(0, 0, 0, 1),
            _ => return Err(format!("unknown variable {name}")),
        }),
        Expr::Neg(value) => Ok(evaluate(value, context)?.neg(context)),
        Expr::Add(left, right) => {
            Ok(evaluate(left, context)?.add(&evaluate(right, context)?, context))
        }
        Expr::Sub(left, right) => {
            Ok(evaluate(left, context)?.sub(&evaluate(right, context)?, context))
        }
        Expr::Mul(left, right) => {
            Ok(evaluate(left, context)?.mul(&evaluate(right, context)?, context))
        }
        Expr::Div(left, right) => {
            let denominator = evaluate(right, context)?;
            let inverse = denominator
                .inverse(context)
                .ok_or("zero-divisor denominator")?;
            Ok(evaluate(left, context)?.mul(&inverse, context))
        }
        Expr::Pow(value, exponent) => Ok(evaluate(value, context)?.pow(*exponent, context)),
    }
}

#[derive(Clone, Default)]
struct Polynomial<const N: usize>(HashMap<[u8; N], FieldElement>);

impl<const N: usize> Polynomial<N> {
    fn term(exponents: [u8; N], coefficient: FieldElement) -> Self {
        let mut terms = HashMap::new();
        if !coefficient.is_zero() {
            terms.insert(exponents, coefficient);
        }
        Self(terms)
    }
    fn constant(coefficient: FieldElement) -> Self {
        Self::term([0; N], coefficient)
    }
    fn variable(index: usize) -> Self {
        let mut exponents = [0; N];
        exponents[index] = 1;
        Self::term(exponents, FieldElement::one())
    }
    fn add_assign(&mut self, other: &Self, context: &Context) {
        for (&exponents, coefficient) in &other.0 {
            let entry = self.0.entry(exponents).or_insert_with(FieldElement::zero);
            entry.add_assign(coefficient, context);
            if entry.is_zero() {
                self.0.remove(&exponents);
            }
        }
    }
    fn add(&self, other: &Self, context: &Context) -> Self {
        let mut answer = self.clone();
        answer.add_assign(other, context);
        answer
    }
    fn neg(&self, context: &Context) -> Self {
        Self(self.0.iter().map(|(&e, c)| (e, c.neg(context))).collect())
    }
    fn sub(&self, other: &Self, context: &Context) -> Self {
        self.add(&other.neg(context), context)
    }
    fn scale(&self, scalar: &FieldElement, context: &Context) -> Self {
        Self(
            self.0
                .iter()
                .filter_map(|(&e, c)| {
                    let value = c.mul(scalar, context);
                    (!value.is_zero()).then_some((e, value))
                })
                .collect(),
        )
    }
    fn mul(&self, other: &Self, context: &Context) -> Self {
        let mut answer = Self::default();
        for (&left_e, left_c) in &self.0 {
            for (&right_e, right_c) in &other.0 {
                let exponents = std::array::from_fn(|i| left_e[i] + right_e[i]);
                let value = left_c.mul(right_c, context);
                let entry = answer.0.entry(exponents).or_insert_with(FieldElement::zero);
                entry.add_assign(&value, context);
            }
        }
        answer.0.retain(|_, coefficient| !coefficient.is_zero());
        answer
    }
    fn pow(&self, mut exponent: u8, context: &Context) -> Self {
        let mut answer = Self::constant(FieldElement::one());
        let mut base = self.clone();
        while exponent != 0 {
            if exponent & 1 != 0 {
                answer = answer.mul(&base, context);
            }
            base = base.mul(&base, context);
            exponent >>= 1;
        }
        answer
    }
}

fn substitute<const N: usize, const M: usize>(
    source: &Polynomial<N>,
    bases: &[Polynomial<M>; N],
    context: &Context,
) -> Polynomial<M> {
    let mut answer = Polynomial::default();
    for (exponents, coefficient) in &source.0 {
        let mut term = Polynomial::constant(coefficient.clone());
        for (base, &exponent) in bases.iter().zip(exponents) {
            if exponent != 0 {
                term = term.mul(&base.pow(exponent, context), context);
            }
        }
        answer.add_assign(&term, context);
    }
    answer
}

fn coefficient_vectors(value: &Value, key: &str) -> Vec<Vec<Expr>> {
    value[key]
        .as_object()
        .map(|object| {
            ["Z1", "Z2", "Z3"]
                .iter()
                .map(|name| {
                    object[*name]
                        .as_array()
                        .unwrap()
                        .iter()
                        .map(|entry| Parser::new(entry.as_str().unwrap()).finish())
                        .collect()
                })
                .collect()
        })
        .unwrap_or_else(|| {
            value[key]
                .as_array()
                .unwrap()
                .iter()
                .map(|row| {
                    row.as_array()
                        .unwrap()
                        .iter()
                        .map(|entry| Parser::new(entry.as_str().unwrap()).finish())
                        .collect()
                })
                .collect()
        })
}

fn evaluate_vectors(
    expressions: &[Vec<Expr>],
    context: &Context,
) -> Result<Vec<Vec<FieldElement>>, String> {
    expressions
        .iter()
        .map(|row| row.iter().map(|x| evaluate(x, context)).collect())
        .collect()
}

type KernelResult = (usize, Vec<Vec<FieldElement>>, Vec<usize>);

#[allow(clippy::needless_range_loop)]
fn rank_and_right_kernel(
    mut matrix: Vec<Vec<FieldElement>>,
    context: &Context,
) -> Result<KernelResult, String> {
    let rows = matrix.len();
    let columns = matrix.first().map_or(0, Vec::len);
    assert!(matrix.iter().all(|row| row.len() == columns));
    let mut source_rows: Vec<usize> = (0..rows).collect();
    let mut pivot_columns = Vec::new();
    let mut pivot_row = 0;
    for column in 0..columns {
        let mut selected = None;
        for row in pivot_row..rows {
            if let Some(inverse) = matrix[row][column].inverse(context) {
                selected = Some((row, inverse));
                break;
            }
        }
        let Some((row, inverse)) = selected else {
            continue;
        };
        matrix.swap(pivot_row, row);
        source_rows.swap(pivot_row, row);
        for entry in column..columns {
            matrix[pivot_row][entry] = matrix[pivot_row][entry].mul(&inverse, context);
        }
        for row in 0..rows {
            if row == pivot_row || matrix[row][column].is_zero() {
                continue;
            }
            let scale = matrix[row][column].clone();
            for entry in column..columns {
                matrix[row][entry] =
                    matrix[row][entry].sub(&scale.mul(&matrix[pivot_row][entry], context), context);
            }
        }
        pivot_columns.push(column);
        pivot_row += 1;
        if pivot_row == rows {
            break;
        }
    }
    let free_columns: Vec<usize> = (0..columns)
        .filter(|column| !pivot_columns.contains(column))
        .collect();
    let kernel = free_columns
        .iter()
        .map(|&free| {
            let mut vector = vec![FieldElement::zero(); columns];
            vector[free] = FieldElement::one();
            for (row, &pivot) in pivot_columns.iter().enumerate() {
                vector[pivot] = matrix[row][free].neg(context);
            }
            vector
        })
        .collect();
    Ok((pivot_row, kernel, source_rows[..pivot_row].to_vec()))
}

fn normalize(vector: &mut [FieldElement], context: &Context) -> Result<(), String> {
    let pivot = vector
        .iter()
        .find_map(|value| value.inverse(context))
        .ok_or("cannot normalize a zero or zero-divisor vector")?;
    for value in vector {
        *value = value.mul(&pivot, context);
    }
    Ok(())
}

struct ReconstructionExpressions {
    points: Vec<Vec<Expr>>,
    section_coefficients: Vec<Vec<Expr>>,
}

fn reconstruction_expressions(blowdown: &Value, sections: &Value) -> ReconstructionExpressions {
    let points = (0..=5)
        .map(|index| {
            blowdown["contracted_points"][format!("E{index}")]
                .as_array()
                .unwrap()
                .iter()
                .map(|entry| Parser::new(entry.as_str().unwrap()).finish())
                .collect()
        })
        .collect();
    let section_coefficients = (1..=5)
        .map(|index| {
            let coefficients = &sections["sections"][format!("E{index}")]["coefficients"];
            ["A", "B", "C", "D"]
                .iter()
                .map(|name| Parser::new(coefficients[*name].as_str().unwrap()).finish())
                .collect()
        })
        .collect();
    ReconstructionExpressions {
        points,
        section_coefficients,
    }
}

fn reconstruct_inverse(
    expressions: &ReconstructionExpressions,
    context: &Context,
) -> Result<(Vec<Vec<FieldElement>>, Vec<usize>), String> {
    let points = evaluate_vectors(&expressions.points, context)?;
    let sections = evaluate_vectors(&expressions.section_coefficients, context)?;
    let cubic_exponents = [
        [3_u8, 0, 0],
        [2, 1, 0],
        [2, 0, 1],
        [1, 2, 0],
        [1, 1, 1],
        [1, 0, 2],
        [0, 3, 0],
        [0, 2, 1],
        [0, 1, 2],
        [0, 0, 3],
    ];
    fn monomial_value(
        point: &[FieldElement],
        exponents: [u8; 3],
        context: &Context,
    ) -> FieldElement {
        point
            .iter()
            .zip(exponents)
            .fold(FieldElement::one(), |value, (coordinate, exponent)| {
                value.mul(&coordinate.pow(u32::from(exponent), context), context)
            })
    }
    let evaluation: Vec<Vec<FieldElement>> = points
        .iter()
        .map(|point| {
            cubic_exponents
                .iter()
                .map(|&exponents| monomial_value(point, exponents, context))
                .collect()
        })
        .collect();
    let (rank, mut cubic_vectors, _) = rank_and_right_kernel(evaluation, context)?;
    if rank != 6 || cubic_vectors.len() != 4 {
        return Err(format!(
            "cubic interpolation has rank {rank} and nullity {}",
            cubic_vectors.len()
        ));
    }
    for vector in &mut cubic_vectors {
        normalize(vector, context)?;
    }

    let mut target_forms = vec![vec![
        vec![
            FieldElement::zero(),
            FieldElement::zero(),
            FieldElement::one(),
            FieldElement::zero(),
        ],
        vec![
            FieldElement::zero(),
            FieldElement::zero(),
            FieldElement::zero(),
            FieldElement::one(),
        ],
    ]];
    for coefficients in sections {
        target_forms.push(vec![
            vec![
                FieldElement::one(),
                FieldElement::zero(),
                coefficients[0].neg(context),
                coefficients[1].neg(context),
            ],
            vec![
                FieldElement::zero(),
                FieldElement::one(),
                coefficients[2].neg(context),
                coefficients[3].neg(context),
            ],
        ]);
    }
    let mut transformation_rows = Vec::new();
    for ((point, forms), _point_index) in points.iter().zip(&target_forms).zip(0..) {
        let tangent_vectors: Vec<Vec<FieldElement>> = (0..3)
            .map(|variable| {
                cubic_vectors
                    .iter()
                    .map(|cubic| {
                        cubic_exponents.iter().zip(cubic).fold(
                            FieldElement::zero(),
                            |sum, (&mut_exponents, coefficient)| {
                                let exponent = mut_exponents[variable];
                                if exponent == 0 {
                                    sum
                                } else {
                                    let mut derivative_exponents = mut_exponents;
                                    derivative_exponents[variable] -= 1;
                                    sum.add(
                                        &coefficient
                                            .mul(
                                                &FieldElement::scalar(u64::from(exponent)),
                                                context,
                                            )
                                            .mul(
                                                &monomial_value(
                                                    point,
                                                    derivative_exponents,
                                                    context,
                                                ),
                                                context,
                                            ),
                                        context,
                                    )
                                }
                            },
                        )
                    })
                    .collect()
            })
            .collect();
        let (tangent_rank, _, _) = rank_and_right_kernel(tangent_vectors.clone(), context)?;
        if tangent_rank != 2 {
            return Err(format!(
                "marked-point tangent rank is {tangent_rank}, not 2"
            ));
        }
        for line_form in forms {
            for tangent_vector in &tangent_vectors {
                transformation_rows.push(
                    line_form
                        .iter()
                        .flat_map(|left| {
                            tangent_vector.iter().map(|right| left.mul(right, context))
                        })
                        .collect(),
                );
            }
        }
    }
    let (rank, mut kernel, independent_rows) = rank_and_right_kernel(transformation_rows, context)?;
    if rank != 15 || kernel.len() != 1 {
        return Err(format!(
            "exceptional-line alignment has rank {rank} and nullity {}",
            kernel.len()
        ));
    }
    normalize(&mut kernel[0], context)?;
    let transformation = &kernel[0];
    let inverse = (0..4)
        .map(|row| {
            (0..10)
                .map(|monomial| {
                    (0..4).fold(FieldElement::zero(), |sum, column| {
                        sum.add(
                            &transformation[4 * row + column]
                                .mul(&cubic_vectors[column][monomial], context),
                            context,
                        )
                    })
                })
                .collect()
        })
        .collect();
    Ok((inverse, independent_rows))
}

fn polynomial_from_vector<const N: usize>(
    coefficients: &[FieldElement],
    exponents: &[[u8; N]],
    context: &Context,
) -> Polynomial<N> {
    assert_eq!(coefficients.len(), exponents.len());
    coefficients
        .iter()
        .zip(exponents)
        .fold(Polynomial::default(), |mut answer, (c, &e)| {
            answer.add_assign(&Polynomial::term(e, c.clone()), context);
            answer
        })
}

fn surface(context: &Context) -> Polynomial<4> {
    let y: [Polynomial<4>; 4] = std::array::from_fn(Polynomial::variable);
    let a = FieldElement::scalar(context.a);
    let a2 = FieldElement::scalar(context.pow(context.a, 2));
    let a3_beta = FieldElement::scalar(context.add(context.pow(context.a, 3), context.beta));
    let first = y[2].mul(
        &y[0]
            .pow(2, context)
            .scale(&a, context)
            .add(
                &y[0]
                    .mul(&y[1], context)
                    .scale(&FieldElement::scalar(context.mul(2, context.a)), context),
                context,
            )
            .add(&y[2].pow(2, context).scale(&a3_beta, context), context),
        context,
    );
    let second = y[3].mul(
        &y[0]
            .pow(2, context)
            .add(&y[0].mul(&y[1], context), context)
            .add(&y[1].pow(2, context), context)
            .sub(&y[2].pow(2, context).scale(&a2, context), context)
            .add(&y[3].pow(2, context), context),
        context,
    );
    first.add(&second, context)
}

fn reduce_mod_surface(polynomial: &Polynomial<4>, context: &Context) -> Polynomial<4> {
    let a = FieldElement::scalar(context.a);
    let a2 = FieldElement::scalar(context.pow(context.a, 2));
    let a3_beta = FieldElement::scalar(context.add(context.pow(context.a, 3), context.beta));
    let q_terms = [
        ([2, 0, 0], FieldElement::one()),
        ([1, 1, 0], FieldElement::one()),
        ([0, 2, 0], FieldElement::one()),
        ([0, 0, 2], a2.neg(context)),
    ];
    let r_terms = [
        ([2, 0, 1], a),
        ([1, 1, 1], FieldElement::scalar(context.mul(2, context.a))),
        ([0, 0, 3], a3_beta),
    ];
    fn descend(
        exponents: [u8; 4],
        coefficient: FieldElement,
        q_terms: &[([u8; 3], FieldElement)],
        r_terms: &[([u8; 3], FieldElement)],
        context: &Context,
        answer: &mut Polynomial<4>,
    ) {
        if exponents[3] < 3 {
            answer.add_assign(&Polynomial::term(exponents, coefficient), context);
            return;
        }
        for (base, value) in q_terms {
            let next = [
                exponents[0] + base[0],
                exponents[1] + base[1],
                exponents[2] + base[2],
                exponents[3] - 2,
            ];
            descend(
                next,
                coefficient.mul(value, context).neg(context),
                q_terms,
                r_terms,
                context,
                answer,
            );
        }
        for (base, value) in r_terms {
            let next = [
                exponents[0] + base[0],
                exponents[1] + base[1],
                exponents[2] + base[2],
                exponents[3] - 3,
            ];
            descend(
                next,
                coefficient.mul(value, context).neg(context),
                q_terms,
                r_terms,
                context,
                answer,
            );
        }
    }
    let mut answer = Polynomial::default();
    for (&exponents, coefficient) in &polynomial.0 {
        descend(
            exponents,
            coefficient.clone(),
            &q_terms,
            &r_terms,
            context,
            &mut answer,
        );
    }
    answer
}

fn check_values(
    context: &Context,
    blowdown_expressions: &[Vec<Expr>],
    inverse_values: &[Vec<FieldElement>],
) -> Result<(usize, usize, usize), String> {
    let blowdown_values = evaluate_vectors(blowdown_expressions, context)?;
    let quadric_exponents = [
        [2, 0, 0, 0],
        [1, 1, 0, 0],
        [1, 0, 1, 0],
        [1, 0, 0, 1],
        [0, 2, 0, 0],
        [0, 1, 1, 0],
        [0, 1, 0, 1],
        [0, 0, 2, 0],
        [0, 0, 1, 1],
        [0, 0, 0, 2],
    ];
    let cubic_exponents = [
        [3, 0, 0],
        [2, 1, 0],
        [2, 0, 1],
        [1, 2, 0],
        [1, 1, 1],
        [1, 0, 2],
        [0, 3, 0],
        [0, 2, 1],
        [0, 1, 2],
        [0, 0, 3],
    ];
    let quadrics: [Polynomial<4>; 3] = std::array::from_fn(|i| {
        polynomial_from_vector(&blowdown_values[i], &quadric_exponents, context)
    });
    let inverse: [Polynomial<3>; 4] = std::array::from_fn(|i| {
        polynomial_from_vector(&inverse_values[i], &cubic_exponents, context)
    });

    let landing = substitute(&surface(context), &inverse, context);
    if !landing.0.is_empty() {
        return Err(format!("landing residual has {} terms", landing.0.len()));
    }

    let forward_after_inverse: [Polynomial<3>; 3] =
        std::array::from_fn(|i| substitute(&quadrics[i], &inverse, context));
    if forward_after_inverse.iter().any(|value| value.0.is_empty()) {
        return Err("forward composite has an identically zero coordinate".to_owned());
    }
    let z: [Polynomial<3>; 3] = std::array::from_fn(Polynomial::variable);
    let forward_residuals = [
        forward_after_inverse[0]
            .mul(&z[1], context)
            .sub(&forward_after_inverse[1].mul(&z[0], context), context),
        forward_after_inverse[0]
            .mul(&z[2], context)
            .sub(&forward_after_inverse[2].mul(&z[0], context), context),
    ];
    if let Some((index, residual)) = forward_residuals
        .iter()
        .enumerate()
        .find(|(_, x)| !x.0.is_empty())
    {
        return Err(format!(
            "forward composite residual {index} has {} terms",
            residual.0.len()
        ));
    }

    let inverse_after_forward: [Polynomial<4>; 4] =
        std::array::from_fn(|i| substitute(&inverse[i], &quadrics, context));
    if inverse_after_forward.iter().any(|value| value.0.is_empty()) {
        return Err("reverse composite has an identically zero coordinate".to_owned());
    }
    let y: [Polynomial<4>; 4] = std::array::from_fn(Polynomial::variable);
    let mut largest_unreduced = 0;
    for index in 1..4 {
        let residual = inverse_after_forward[0]
            .mul(&y[index], context)
            .sub(&inverse_after_forward[index].mul(&y[0], context), context);
        largest_unreduced = largest_unreduced.max(residual.0.len());
        let reduced = reduce_mod_surface(&residual, context);
        if !reduced.0.is_empty() {
            return Err(format!(
                "reverse composite residual {index} has {} reduced terms",
                reduced.0.len()
            ));
        }
    }
    Ok((
        landing.0.len(),
        forward_after_inverse[0].0.len(),
        largest_unreduced,
    ))
}

fn check_formula_case(
    context: &Context,
    blowdown_expressions: &[Vec<Expr>],
    inverse_expressions: &[Vec<Expr>],
) -> Result<(usize, usize, usize), String> {
    let inverse_values = evaluate_vectors(inverse_expressions, context)?;
    check_values(context, blowdown_expressions, &inverse_values)
}

fn main() {
    let arguments: Vec<String> = env::args().skip(1).collect();
    let reconstruct = arguments
        .first()
        .is_some_and(|value| value == "--reconstruct");
    let (blowdown_path, second_path) = if reconstruct {
        assert_eq!(
            arguments.len(),
            3,
            "usage: CHECK --reconstruct BLOWDOWN_JSON SECTIONS_JSON"
        );
        (&arguments[1], &arguments[2])
    } else {
        assert_eq!(
            arguments.len(),
            2,
            "usage: CHECK BLOWDOWN_JSON INVERSE_FORMULAS_JSON"
        );
        (&arguments[0], &arguments[1])
    };
    let blowdown: Value =
        serde_json::from_str(&fs::read_to_string(blowdown_path).unwrap()).unwrap();
    assert_eq!(blowdown["schema"], "c958-type-i3-split-blowdown-v1");
    assert_eq!(
        blowdown["field_tower"],
        serde_json::json!([
            "g^2=3",
            "r^3-a^2*r+a^3+beta=0",
            "d^2+3*r^2-4*a^2=0",
            "delta^2=(-32*g-52)*a^4-(24*g+36)*a*beta"
        ])
    );
    let parse_start = Instant::now();
    let blowdown_expressions = coefficient_vectors(&blowdown, "quadric_coefficients");
    let mut inverse_expressions = None;
    let mut reconstruction = None;
    let mut normalized = false;
    if reconstruct {
        let sections: Value =
            serde_json::from_str(&fs::read_to_string(second_path).unwrap()).unwrap();
        assert_eq!(sections["schema"], "c958-type-i3-exceptional-sections-v1");
        reconstruction = Some(reconstruction_expressions(&blowdown, &sections));
    } else {
        let inverse: Value =
            serde_json::from_str(&fs::read_to_string(second_path).unwrap()).unwrap();
        normalized = inverse["schema"]
            .as_str()
            .is_some_and(|schema| schema.starts_with("c958-type-i3-normalized-"));
        assert!(matches!(
            inverse["schema"].as_str(),
            Some("c958-type-i3-split-inverse-formulas-v1")
                | Some("c958-type-i3-split-inverse-one-sided-v1")
                | Some("c958-type-i3-split-inverse-v1")
                | Some("c958-type-i3-normalized-split-inverse-formulas-v1")
                | Some("c958-type-i3-normalized-split-inverse-one-sided-v1")
                | Some("c958-type-i3-normalized-split-inverse-v1")
        ));
        inverse_expressions = Some(coefficient_vectors(&inverse, "inverse_cubic_coefficients"));
    }
    eprintln!(
        "parsed input coefficient formulas in {:.3}s",
        parse_start.elapsed().as_secs_f64()
    );

    let cases = if normalized {
        [
            Context {
                modulus: 1_000_003,
                a: 1,
                beta: 1,
            },
            Context {
                modulus: 1_000_033,
                a: 1,
                beta: 7,
            },
            Context {
                modulus: 1_000_037,
                a: 1,
                beta: 13,
            },
        ]
    } else {
        [
            Context {
                modulus: 1_000_003,
                a: 2,
                beta: 1,
            },
            Context {
                modulus: 1_000_033,
                a: 5,
                beta: 7,
            },
            Context {
                modulus: 1_000_037,
                a: 11,
                beta: 13,
            },
        ]
    };
    let mut successful = 0;
    for context in &cases {
        let start = Instant::now();
        let result = if let Some(expressions) = &reconstruction {
            reconstruct_inverse(expressions, context).and_then(|(inverse, independent_rows)| {
                eprintln!(
                    "p={} a={} beta={}: alignment independent source rows {:?}",
                    context.modulus, context.a, context.beta, independent_rows
                );
                check_values(context, &blowdown_expressions, &inverse)
            })
        } else {
            check_formula_case(
                context,
                &blowdown_expressions,
                inverse_expressions.as_ref().unwrap(),
            )
        };
        match result {
            Ok((landing, forward, reverse)) => {
                successful += 1;
                println!("p={} a={} beta={}: full polynomial identities pass (landing terms {}, forward terms {}, largest reverse before reduction {}) in {:.3}s",
                    context.modulus, context.a, context.beta, landing, forward, reverse,
                    start.elapsed().as_secs_f64());
            }
            Err(error) if error == "zero-divisor denominator" => {
                eprintln!(
                    "p={} a={} beta={}: skipped ({error})",
                    context.modulus, context.a, context.beta
                );
            }
            Err(error) => panic!(
                "p={} a={} beta={}: {error}",
                context.modulus, context.a, context.beta
            ),
        }
    }
    assert!(successful >= 2, "too many singular specializations");
    println!("diagnostic only: {successful} complete quotient-algebra specializations passed");
}

#[cfg(test)]
mod tests {
    use super::*;

    fn context() -> Context {
        Context {
            modulus: 1_000_003,
            a: 2,
            beta: 1,
        }
    }

    #[test]
    fn quotient_generators_satisfy_the_four_tower_relations() {
        let context = context();
        let g = FieldElement::generator(1, 0, 0, 0);
        let r = FieldElement::generator(0, 1, 0, 0);
        let d = FieldElement::generator(0, 0, 1, 0);
        let delta = FieldElement::generator(0, 0, 0, 1);
        assert_eq!(g.pow(2, &context), FieldElement::scalar(3));
        assert!(r
            .pow(3, &context)
            .sub(
                &r.mul(&FieldElement::scalar(context.a * context.a), &context),
                &context,
            )
            .add(
                &FieldElement::scalar(context.a.pow(3) + context.beta),
                &context,
            )
            .is_zero());
        assert!(d
            .pow(2, &context)
            .add(
                &r.pow(2, &context).mul(&FieldElement::scalar(3), &context),
                &context,
            )
            .sub(&FieldElement::scalar(4 * context.a * context.a), &context,)
            .is_zero());
        let delta_squared = FieldElement::scalar(context.neg(context.add(
            context.mul(52, context.pow(context.a, 4)),
            context.mul(36, context.mul(context.a, context.beta)),
        )))
        .add(
            &g.mul(
                &FieldElement::scalar(context.neg(context.add(
                    context.mul(32, context.pow(context.a, 4)),
                    context.mul(24, context.mul(context.a, context.beta)),
                ))),
                &context,
            ),
            &context,
        );
        assert_eq!(delta.pow(2, &context), delta_squared);
    }

    #[test]
    fn parses_and_evaluates_every_committed_blowdown_coefficient() {
        let value: Value = serde_json::from_str(include_str!(
            "../../notes/2026-08-25-c958-type-i3-split-blowdown.json"
        ))
        .unwrap();
        let expressions = coefficient_vectors(&value, "quadric_coefficients");
        let evaluated = evaluate_vectors(&expressions, &context()).unwrap();
        assert_eq!(evaluated.iter().map(Vec::len).sum::<usize>(), 30);
    }
}
