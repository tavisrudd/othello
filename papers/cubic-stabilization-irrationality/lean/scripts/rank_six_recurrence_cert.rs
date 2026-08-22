use std::cmp::Ordering;
use std::env;
use std::fmt::{self, Display};
use std::ops::{Add, Div, Mul, Neg, Sub};

const N: usize = 6;
const B: usize = 2;

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

impl Div for Rat {
    type Output = Self;

    fn div(self, rhs: Self) -> Self::Output {
        assert_ne!(rhs.num, 0);
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

type Matrix = [[Rat; N]; N];
type Rect = Vec<Vec<Rat>>;

fn zero() -> Matrix {
    [[Rat::ZERO; N]; N]
}

fn identity() -> Matrix {
    let mut result = zero();
    for (index, row) in result.iter_mut().enumerate() {
        row[index] = Rat::ONE;
    }
    result
}

fn add(left: &Matrix, right: &Matrix) -> Matrix {
    let mut result = zero();
    for i in 0..N {
        for j in 0..N {
            result[i][j] = left[i][j] + right[i][j];
        }
    }
    result
}

fn sub(left: &Matrix, right: &Matrix) -> Matrix {
    let mut result = zero();
    for i in 0..N {
        for j in 0..N {
            result[i][j] = left[i][j] - right[i][j];
        }
    }
    result
}

fn scale(scalar: Rat, matrix: &Matrix) -> Matrix {
    let mut result = zero();
    for i in 0..N {
        for j in 0..N {
            result[i][j] = scalar * matrix[i][j];
        }
    }
    result
}

fn mul(left: &Matrix, right: &Matrix) -> Matrix {
    let mut result = zero();
    for i in 0..N {
        for j in 0..N {
            for k in 0..N {
                result[i][j] = result[i][j] + left[i][k] * right[k][j];
            }
        }
    }
    result
}

fn pow(matrix: &Matrix, exponent: usize) -> Matrix {
    let mut result = identity();
    for _ in 0..exponent {
        result = mul(&result, matrix);
    }
    result
}

fn mat_vec_rows(matrix: &Matrix) -> Rect {
    matrix.iter().map(|row| row.to_vec()).collect()
}

fn rect_mul(left: &Rect, right: &Rect) -> Rect {
    assert!(!left.is_empty() && !right.is_empty());
    assert_eq!(left[0].len(), right.len());
    let mut result = vec![vec![Rat::ZERO; right[0].len()]; left.len()];
    for i in 0..left.len() {
        for j in 0..right[0].len() {
            for k in 0..right.len() {
                result[i][j] = result[i][j] + left[i][k] * right[k][j];
            }
        }
    }
    result
}

fn matrix_rect_mul(left: &Matrix, right: &Rect) -> Rect {
    rect_mul(&mat_vec_rows(left), right)
}

fn rect_matrix_mul(left: &Rect, right: &Matrix) -> Rect {
    rect_mul(left, &mat_vec_rows(right))
}

fn projector(multiplication: &Matrix) -> Matrix {
    let terms = [
        (0, Rat::new(1, 3)),
        (1, Rat::new(4, 9)),
        (2, Rat::new(5, 9)),
        (4, Rat::new(-1, 9)),
        (5, Rat::new(-2, 9)),
    ];
    let mut result = zero();
    for (exponent, coefficient) in terms {
        result = add(&result, &scale(coefficient, &pow(multiplication, exponent)));
    }
    result
}

fn variable(row: usize, column: usize) -> usize {
    row * N + column
}

fn add_equation(equations: &mut Vec<Vec<Rat>>, coefficients: Vec<Rat>, rhs: Rat) {
    let mut equation = coefficients;
    equation.push(rhs);
    equations.push(equation);
}

fn solve_first_gauge(multiplication: &Matrix, grading: &Matrix, selected: &Matrix) -> Matrix {
    let complement = sub(&identity(), selected);
    let rhs = add(
        &mul(&mul(selected, grading), &complement),
        &mul(&mul(&complement, grading), selected),
    );
    let mut equations = Vec::new();

    for i in 0..N {
        for j in 0..N {
            let mut coefficients = vec![Rat::ZERO; N * N];
            for k in 0..N {
                coefficients[variable(k, j)] = coefficients[variable(k, j)] + multiplication[i][k];
                coefficients[variable(i, k)] = coefficients[variable(i, k)] - multiplication[k][j];
            }
            add_equation(&mut equations, coefficients, rhs[i][j]);
        }
    }

    for block in [selected, &complement] {
        for i in 0..N {
            for j in 0..N {
                let mut coefficients = vec![Rat::ZERO; N * N];
                for row in 0..N {
                    for column in 0..N {
                        coefficients[variable(row, column)] =
                            coefficients[variable(row, column)] + block[i][row] * block[column][j];
                    }
                }
                add_equation(&mut equations, coefficients, Rat::ZERO);
            }
        }
    }

    assert_eq!(equations.len(), 3 * N * N);
    let solution = solve_unique(equations, N * N);
    let mut result = zero();
    for i in 0..N {
        for j in 0..N {
            result[i][j] = solution[variable(i, j)];
        }
    }
    result
}

fn solve_unique(mut equations: Vec<Vec<Rat>>, variables: usize) -> Vec<Rat> {
    let mut pivot_row = 0;
    let mut pivot_for_column = vec![None; variables];
    for column in 0..variables {
        let pivot = (pivot_row..equations.len()).find(|&row| !equations[row][column].is_zero());
        let Some(found) = pivot else { continue };
        equations.swap(pivot_row, found);
        let divisor = equations[pivot_row][column];
        for entry in column..=variables {
            equations[pivot_row][entry] = equations[pivot_row][entry] / divisor;
        }
        for row in 0..equations.len() {
            if row == pivot_row {
                continue;
            }
            let factor = equations[row][column];
            if factor.is_zero() {
                continue;
            }
            for entry in column..=variables {
                equations[row][entry] =
                    equations[row][entry] - factor * equations[pivot_row][entry];
            }
        }
        pivot_for_column[column] = Some(pivot_row);
        pivot_row += 1;
    }

    for equation in &equations {
        let zero_left = equation[..variables].iter().all(|entry| entry.is_zero());
        assert!(
            !zero_left || equation[variables].is_zero(),
            "inconsistent system"
        );
    }
    assert_eq!(pivot_row, variables, "first gauge is not unique");

    let mut solution = vec![Rat::ZERO; variables];
    for column in 0..variables {
        let row = pivot_for_column[column].expect("missing pivot");
        solution[column] = equations[row][variables];
    }
    solution
}

#[derive(Clone, Copy)]
enum Orientation {
    Lower,
    Upper,
}

impl Orientation {
    fn name(self) -> &'static str {
        match self {
            Self::Lower => "lower",
            Self::Upper => "upper",
        }
    }
}

struct Certificate {
    orientation: Orientation,
    multiplication: Matrix,
    projector: Matrix,
    selected_basis: Rect,
    left_inverse: Rect,
    first_gauge: Matrix,
    selected_grading: Rect,
    selected_second: Rect,
    residue: Rect,
    discriminant: Rat,
}

fn multiplication(orientation: Orientation) -> Matrix {
    let mut result = zero();
    match orientation {
        Orientation::Lower => {
            result[0][4] = Rat::ONE;
            result[1][4] = 6.into();
            result[1][5] = Rat::ONE;
        }
        Orientation::Upper => {
            result[0][4] = Rat::ONE;
            result[0][5] = 6.into();
            result[1][5] = Rat::ONE;
        }
    }
    result[2][0] = Rat::ONE;
    result[3][1] = Rat::ONE;
    result[4][2] = Rat::ONE;
    result[5][3] = Rat::ONE;
    result
}

fn grading() -> Matrix {
    let values = [
        Rat::new(-3, 2),
        Rat::new(3, 2),
        Rat::new(-1, 2),
        Rat::new(-1, 2),
        Rat::new(1, 2),
        Rat::new(1, 2),
    ];
    let mut result = zero();
    for i in 0..N {
        result[i][i] = values[i];
    }
    result
}

fn selected_basis(orientation: Orientation) -> Rect {
    match orientation {
        Orientation::Lower => vec![
            vec![0.into(), 1.into()],
            vec![1.into(), 0.into()],
            vec![0.into(), 1.into()],
            vec![1.into(), (-2).into()],
            vec![0.into(), 1.into()],
            vec![1.into(), (-4).into()],
        ],
        Orientation::Upper => vec![
            vec![1.into(), 0.into()],
            vec![0.into(), 1.into()],
            vec![1.into(), (-2).into()],
            vec![0.into(), 1.into()],
            vec![1.into(), (-4).into()],
            vec![0.into(), 1.into()],
        ],
    }
}

fn left_inverse(orientation: Orientation) -> Rect {
    match orientation {
        Orientation::Lower => vec![
            vec![0.into(), 1.into(), 0.into(), 0.into(), 0.into(), 0.into()],
            vec![1.into(), 0.into(), 0.into(), 0.into(), 0.into(), 0.into()],
        ],
        Orientation::Upper => vec![
            vec![1.into(), 0.into(), 0.into(), 0.into(), 0.into(), 0.into()],
            vec![0.into(), 1.into(), 0.into(), 0.into(), 0.into(), 0.into()],
        ],
    }
}

fn expected_first_gauge(orientation: Orientation) -> Matrix {
    let rows: [[(i128, i128); N]; N] = match orientation {
        Orientation::Lower => [
            [(-1, 9), (0, 1), (2, 9), (0, 1), (2, 9), (0, 1)],
            [(0, 1), (-1, 9), (-8, 9), (-4, 9), (-4, 9), (-1, 9)],
            [(-1, 9), (0, 1), (2, 9), (0, 1), (2, 9), (0, 1)],
            [(2, 9), (2, 9), (-2, 3), (-1, 9), (4, 9), (2, 9)],
            [(-4, 9), (0, 1), (-1, 9), (0, 1), (-1, 9), (0, 1)],
            [(16, 9), (2, 9), (2, 9), (-1, 9), (4, 3), (2, 9)],
        ],
        Orientation::Upper => [
            [(-1, 9), (4, 9), (2, 9), (8, 9), (2, 9), (2, 3)],
            [(0, 1), (-1, 9), (0, 1), (-4, 9), (0, 1), (-1, 9)],
            [(-1, 9), (-2, 3), (2, 9), (4, 9), (2, 9), (-4, 9)],
            [(0, 1), (2, 9), (0, 1), (-1, 9), (0, 1), (2, 9)],
            [(-4, 9), (-4, 9), (-1, 9), (2, 3), (-1, 9), (-14, 9)],
            [(0, 1), (2, 9), (0, 1), (-1, 9), (0, 1), (2, 9)],
        ],
    };
    let mut result = zero();
    for i in 0..N {
        for j in 0..N {
            result[i][j] = Rat::new(rows[i][j].0, rows[i][j].1);
        }
    }
    result
}

fn solve(orientation: Orientation) -> Certificate {
    let multiplication = multiplication(orientation);
    let projector = projector(&multiplication);
    let selected_basis = selected_basis(orientation);
    let left_inverse = left_inverse(orientation);
    let grading = grading();
    let first_gauge = solve_first_gauge(&multiplication, &grading, &projector);
    assert_eq!(first_gauge, expected_first_gauge(orientation));
    let commutator = sub(
        &mul(&multiplication, &first_gauge),
        &mul(&first_gauge, &multiplication),
    );
    let connection_grading = scale((-1).into(), &grading);
    let block_grading = add(&connection_grading, &commutator);
    let second = sub(
        &sub(
            &sub(
                &mul(&connection_grading, &first_gauge),
                &mul(&first_gauge, &connection_grading),
            ),
            &mul(&first_gauge, &commutator),
        ),
        &first_gauge,
    );
    let selected_grading = rect_mul(
        &rect_matrix_mul(&left_inverse, &block_grading),
        &selected_basis,
    );
    let selected_second = rect_mul(
        &rect_matrix_mul(&left_inverse, &mul(&mul(&projector, &second), &projector)),
        &selected_basis,
    );
    let residue = vec![
        vec![selected_grading[0][0], 2.into()],
        vec![selected_second[1][0], selected_grading[1][1] - Rat::ONE],
    ];
    let trace = residue[0][0] + residue[1][1];
    let determinant = residue[0][0] * residue[1][1] - residue[0][1] * residue[1][0];
    let discriminant = trace * trace - Rat::from(4) * determinant;

    let selected_jordan = vec![vec![1.into(), 2.into()], vec![0.into(), 1.into()]];
    assert_eq!(rect_mul(&left_inverse, &selected_basis), identity_rect(B));
    assert_eq!(
        matrix_rect_mul(&multiplication, &selected_basis),
        rect_mul(&selected_basis, &selected_jordan)
    );
    assert_eq!(mul(&projector, &projector), projector);
    assert_eq!(
        mul(&projector, &multiplication),
        mul(&multiplication, &projector)
    );
    assert_eq!(mul(&mul(&projector, &first_gauge), &projector), zero());
    let complement = sub(&identity(), &projector);
    assert_eq!(mul(&mul(&complement, &first_gauge), &complement), zero());
    assert_eq!(
        mul(&projector, &block_grading),
        mul(&block_grading, &projector)
    );
    assert_eq!(selected_second, scalar_identity(B, Rat::new(1, 3)));
    match orientation {
        Orientation::Lower => {
            assert_eq!(selected_grading, diagonal2(Rat::new(-1, 2), Rat::new(1, 2)));
            assert_eq!(discriminant, Rat::ZERO);
        }
        Orientation::Upper => {
            assert_eq!(selected_grading, diagonal2(Rat::new(1, 2), Rat::new(-1, 2)));
            assert_eq!(discriminant, 4.into());
        }
    }

    Certificate {
        orientation,
        multiplication,
        projector,
        selected_basis,
        left_inverse,
        first_gauge,
        selected_grading,
        selected_second,
        residue,
        discriminant,
    }
}

fn identity_rect(size: usize) -> Rect {
    let mut result = vec![vec![Rat::ZERO; size]; size];
    for (index, row) in result.iter_mut().enumerate() {
        row[index] = Rat::ONE;
    }
    result
}

fn scalar_identity(size: usize, scalar: Rat) -> Rect {
    let mut result = vec![vec![Rat::ZERO; size]; size];
    for (index, row) in result.iter_mut().enumerate() {
        row[index] = scalar;
    }
    result
}

fn diagonal2(first: Rat, second: Rat) -> Rect {
    vec![vec![first, Rat::ZERO], vec![Rat::ZERO, second]]
}

fn json_rect(matrix: &Rect, indent: &str) -> String {
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

fn json_matrix(matrix: &Matrix, indent: &str) -> String {
    json_rect(&mat_vec_rows(matrix), indent)
}

fn emit_json(certificates: &[Certificate]) {
    println!("{{");
    println!("  \"schema\": \"rank-six-recurrence-certificate-v1\",");
    println!("  \"arithmetic\": \"reduced exact i128 rationals\",");
    println!("  \"linear_system\": \"Sylvester equation plus zero diagonal blocks\",");
    println!("  \"unknowns_per_orientation\": 36,");
    println!("  \"equations_per_orientation\": 108,");
    println!("  \"rank_per_orientation\": 36,");
    println!("  \"orientations\": [");
    for (index, certificate) in certificates.iter().enumerate() {
        println!("    {{");
        println!("      \"name\": \"{}\",", certificate.orientation.name());
        println!(
            "      \"multiplication\": {},",
            json_matrix(&certificate.multiplication, "      ")
        );
        println!(
            "      \"projector\": {},",
            json_matrix(&certificate.projector, "      ")
        );
        println!(
            "      \"selected_basis\": {},",
            json_rect(&certificate.selected_basis, "      ")
        );
        println!(
            "      \"left_inverse\": {},",
            json_rect(&certificate.left_inverse, "      ")
        );
        println!(
            "      \"first_gauge\": {},",
            json_matrix(&certificate.first_gauge, "      ")
        );
        println!(
            "      \"selected_grading\": {},",
            json_rect(&certificate.selected_grading, "      ")
        );
        println!(
            "      \"selected_second\": {},",
            json_rect(&certificate.selected_second, "      ")
        );
        println!(
            "      \"modified_residue\": {},",
            json_rect(&certificate.residue, "      ")
        );
        println!("      \"discriminant\": \"{}\"", certificate.discriminant);
        print!("    }}");
        if index + 1 != certificates.len() {
            print!(",");
        }
        println!();
    }
    println!("  ]");
    println!("}}");
}

fn lean_matrix(name: &str, rows: &Rect, row_type: &str, column_type: &str) {
    println!("def {name} : Matrix {row_type} {column_type} ℚ :=");
    print!("  !![");
    for (row_index, row) in rows.iter().enumerate() {
        if row_index != 0 {
            print!("     ");
        }
        for (column_index, entry) in row.iter().enumerate() {
            if column_index != 0 {
                print!(", ");
            }
            print!("{}", entry.lean());
        }
        if row_index + 1 != rows.len() {
            println!(";");
        } else {
            println!("]");
        }
    }
    println!();
}

fn emit_lean(certificates: &[Certificate]) {
    println!("import Mathlib\n");
    println!("/-!");
    println!("# Exact data for the two rank-six recurrence orientations\n");
    println!("This file is generated by `scripts/rank_six_recurrence_cert.rs`.");
    println!("The generator solves the rational Sylvester system with vanishing");
    println!("selected and complementary diagonal gauge blocks.  The importing");
    println!("checker proves the mathematical identities from these data.");
    println!("-/\n");
    println!("namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.Generated.RankSixRecurrenceData\n");
    println!("abbrev Index := Fin 6");
    println!("abbrev BlockIndex := Fin 2\n");
    lean_matrix("grading", &mat_vec_rows(&grading()), "Index", "Index");
    for certificate in certificates {
        let prefix = certificate.orientation.name();
        lean_matrix(
            &format!("{prefix}Multiplication"),
            &mat_vec_rows(&certificate.multiplication),
            "Index",
            "Index",
        );
        lean_matrix(
            &format!("{prefix}Projector"),
            &mat_vec_rows(&certificate.projector),
            "Index",
            "Index",
        );
        lean_matrix(
            &format!("{prefix}SelectedBasis"),
            &certificate.selected_basis,
            "Index",
            "BlockIndex",
        );
        lean_matrix(
            &format!("{prefix}LeftInverse"),
            &certificate.left_inverse,
            "BlockIndex",
            "Index",
        );
        lean_matrix(
            &format!("{prefix}FirstGauge"),
            &mat_vec_rows(&certificate.first_gauge),
            "Index",
            "Index",
        );
    }
    println!("end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.Generated.RankSixRecurrenceData");
}

fn main() {
    let certificates = [solve(Orientation::Lower), solve(Orientation::Upper)];
    match env::args().nth(1).as_deref() {
        Some("--json") => emit_json(&certificates),
        Some("--lean") => emit_lean(&certificates),
        _ => {
            eprintln!("usage: rank_six_recurrence_cert (--json|--lean)");
            std::process::exit(2);
        }
    }
}
