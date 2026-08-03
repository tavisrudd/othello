// Exact q=49 carrier closure for R9.  Standard library only.

#[derive(Clone)]
struct Field {
    add: [[u8; 49]; 49],
    mul: [[u8; 49]; 49],
    neg: [u8; 49],
    inv: [u8; 49],
    square: [bool; 49],
}

impl Field {
    fn new() -> Self {
        let mut field = Field {
            add: [[0; 49]; 49],
            mul: [[0; 49]; 49],
            neg: [0; 49],
            inv: [0; 49],
            square: [false; 49],
        };
        for x in 0..49 {
            let (a, b) = (x % 7, x / 7);
            field.neg[x] = (((7 - a) % 7) + 7 * ((7 - b) % 7)) as u8;
            for y in 0..49 {
                let (c, d) = (y % 7, y / 7);
                field.add[x][y] = (((a + c) % 7) + 7 * ((b + d) % 7)) as u8;
                // tau^2=3 is irreducible over F_7.
                field.mul[x][y] =
                    (((a * c + 3 * b * d) % 7) + 7 * ((a * d + b * c) % 7)) as u8;
            }
        }
        for x in 1..49 {
            for y in 1..49 {
                if field.mul[x][y] == 1 {
                    field.inv[x] = y as u8;
                }
            }
            field.square[field.mul[x][x] as usize] = true;
        }
        field
    }

    #[inline]
    fn add(&self, x: u8, y: u8) -> u8 {
        self.add[x as usize][y as usize]
    }

    #[inline]
    fn neg(&self, x: u8) -> u8 {
        self.neg[x as usize]
    }

    #[inline]
    fn sub(&self, x: u8, y: u8) -> u8 {
        self.add(x, self.neg(y))
    }

    #[inline]
    fn mul(&self, x: u8, y: u8) -> u8 {
        self.mul[x as usize][y as usize]
    }
}

fn canonical_projective_vectors() -> Vec<[u8; 5]> {
    let mut out = Vec::with_capacity((49usize.pow(5) - 1) / 48);
    for pivot in 0..5 {
        let tail_length = 4 - pivot;
        let count = 49usize.pow(tail_length as u32);
        for mut code in 0..count {
            let mut vector = [0u8; 5];
            vector[pivot] = 1;
            for entry in vector.iter_mut().skip(pivot + 1) {
                *entry = (code % 49) as u8;
                code /= 49;
            }
            out.push(vector);
        }
    }
    out
}

fn quintic_coefficients(field: &Field, roots: &[u8; 5]) -> [u8; 6] {
    let mut coefficients = [0u8; 6];
    coefficients[0] = 1;
    let mut degree = 0;
    for &root in roots {
        let mut next = [0u8; 6];
        for i in 0..=degree {
            next[i] = field.sub(next[i], field.mul(root, coefficients[i]));
            next[i + 1] = field.add(next[i + 1], coefficients[i]);
        }
        coefficients = next;
        degree += 1;
    }
    coefficients
}

fn hankel_weights(coefficients: &[u8; 6]) -> [[u8; 5]; 4] {
    let mut weights = [[0u8; 5]; 4];
    for (slot, shift) in (-1isize..=2).enumerate() {
        for j in 0..5 {
            let index = j as isize + shift;
            if (0..6).contains(&index) {
                weights[slot][j] = coefficients[index as usize];
            }
        }
    }
    weights
}

#[inline]
fn dot(field: &Field, left: &[u8; 5], right: &[u8; 5]) -> u8 {
    let mut out = 0;
    for i in 0..5 {
        out = field.add(out, field.mul(left[i], right[i]));
    }
    out
}

fn has_witness(
    field: &Field,
    h: &[u8; 5],
    roots: &[u8; 5],
    weights: &[[u8; 5]; 4],
) -> bool {
    let hm1 = dot(field, h, &weights[0]);
    let h0 = dot(field, h, &weights[1]);
    let h1 = dot(field, h, &weights[2]);
    let h2 = dot(field, h, &weights[3]);
    let determinant = field.sub(field.mul(h0, h2), field.mul(h1, h1));
    if determinant == 0 {
        return false;
    }
    let trace_numerator = field.sub(field.mul(hm1, h2), field.mul(h0, h1));
    let norm_numerator = field.sub(field.mul(hm1, h1), field.mul(h0, h0));
    let inverse = field.inv[determinant as usize];
    let trace = field.mul(trace_numerator, inverse);
    let norm = field.mul(norm_numerator, inverse);
    let four_norm = field.mul(4, norm);
    let discriminant = field.sub(field.mul(trace, trace), four_norm);
    if discriminant == 0 || !field.square[discriminant as usize] {
        return false;
    }
    for &root in roots {
        let value = field.add(
            field.sub(field.mul(root, root), field.mul(trace, root)),
            norm,
        );
        if value == 0 {
            return false;
        }
    }
    true
}

fn next_combination(combination: &mut [u8; 5]) -> bool {
    for index in (0..5).rev() {
        let maximum = 48 - (4 - index) as u8;
        if combination[index] < maximum {
            combination[index] += 1;
            for j in index + 1..5 {
                combination[j] = combination[j - 1] + 1;
            }
            return true;
        }
    }
    false
}

fn main() {
    let field = Field::new();
    let mut survivors = canonical_projective_vectors();
    assert_eq!(survivors.len(), (49usize.pow(5) - 1) / 48);
    let initial = survivors.len();
    let mut roots = [0, 1, 2, 3, 4];
    let mut steps = Vec::new();
    let mut first_singleton = None;
    let mut tested = 0usize;
    loop {
        let coefficients = quintic_coefficients(&field, &roots);
        let weights = hankel_weights(&coefficients);
        survivors.retain(|h| !has_witness(&field, h, &roots, &weights));
        tested += 1;
        if survivors.len() == 1 && first_singleton.is_none() {
            first_singleton = Some((tested, survivors[0]));
        }
        if matches!(tested, 1 | 2 | 3 | 4 | 5 | 10 | 20 | 100 | 1_000)
            || survivors.is_empty()
        {
            steps.push((tested, roots, survivors.len()));
        }
        if survivors.is_empty() {
            break;
        }
        if !next_combination(&mut roots) {
            break;
        }
    }
    println!("schema=r9-q49-carrier-v1");
    println!("field=F49_tau2_eq_3");
    println!("projective_quartics={initial}");
    println!("quintics_tested={tested}");
    println!("survivors={}", survivors.len());
    if let Some((step, h)) = first_singleton {
        println!(
            "first_singleton={step};quartic={},{},{},{},{}",
            h[0], h[1], h[2], h[3], h[4]
        );
    }
    for (step, roots, count) in steps {
        println!(
            "milestone={step};roots={},{},{},{},{};survivors={count}",
            roots[0], roots[1], roots[2], roots[3], roots[4]
        );
    }
    assert!(survivors.is_empty(), "q=49 carrier was not closed");
}
