use serde::{Deserialize, Serialize};
use std::collections::BTreeSet;
use thiserror::Error;

pub const REQUEST_SCHEMA: &str = "c969-request-v1";
pub const CERTIFICATE_SCHEMA: &str = "c969-locator-certificate-v1";

#[derive(Debug, Error, PartialEq, Eq)]
pub enum Error {
    #[error("the field characteristic must be prime")]
    NonPrimeCharacteristic,
    #[error("field degree must be positive")]
    ZeroFieldDegree,
    #[error("field order does not fit in the supported 32-bit encoding")]
    FieldTooLarge,
    #[error("the modulus must have degree m, be monic, and have coefficients in F_p")]
    BadModulus,
    #[error("the supplied modulus is reducible")]
    ReducibleModulus,
    #[error("redundancy must lie in 5..=10")]
    BadRedundancy,
    #[error("the syndrome dimension does not equal the redundancy")]
    BadSyndromeDimension,
    #[error("the zero syndrome has no projective normalization")]
    ZeroSyndrome,
    #[error("field element {0} is outside [0,q)")]
    BadElement(u32),
    #[error("candidate limit {limit} exceeded")]
    CandidateLimit { limit: u64 },
    #[error("certificate locator does not match its support")]
    BadLocator,
    #[error("certificate support is repeated or outside P1(F_q)")]
    BadSupport,
    #[error("certificate magnitude is zero or has the wrong length")]
    BadMagnitude,
    #[error("certificate error pattern does not reproduce the syndrome")]
    BadSyndromeWitness,
    #[error("no split locator was found through degree {0}")]
    NoLocator(usize),
    #[error("unsupported request schema or evaluation convention")]
    BadSchema,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct FieldSpec {
    pub p: u32,
    pub degree: usize,
    pub modulus: Vec<u32>,
    pub encoding: String,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct Request {
    pub schema: String,
    pub field: FieldSpec,
    pub redundancy: usize,
    pub evaluation: String,
    pub syndrome: Vec<u32>,
    #[serde(default)]
    pub operation: Option<String>,
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq, PartialOrd, Ord)]
#[serde(rename_all = "snake_case")]
pub enum Root {
    Finite(u32),
    Infinity,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct LocatorCertificate {
    pub schema: String,
    pub field: FieldSpec,
    pub redundancy: usize,
    pub normalized_syndrome: Vec<u32>,
    pub distance: usize,
    pub locator: Vec<u32>,
    pub support: Vec<Root>,
    pub magnitudes: Vec<u32>,
    pub candidates_examined: u64,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct SearchBoundary {
    pub schema: &'static str,
    pub normalized_syndrome: Vec<u32>,
    pub searched_through_degree: usize,
    pub candidates_examined: u64,
    pub conclusion: &'static str,
}

#[derive(Clone, Debug)]
pub struct Field {
    spec: FieldSpec,
    q: u32,
}

impl Field {
    pub fn new(spec: FieldSpec) -> Result<Self, Error> {
        if !is_prime(spec.p) {
            return Err(Error::NonPrimeCharacteristic);
        }
        if spec.degree == 0 {
            return Err(Error::ZeroFieldDegree);
        }
        if spec.encoding != "polynomial-basis-base-p-integer-v1" {
            return Err(Error::BadSchema);
        }
        let mut q64 = 1u64;
        for _ in 0..spec.degree {
            q64 = q64
                .checked_mul(u64::from(spec.p))
                .ok_or(Error::FieldTooLarge)?;
        }
        let q = u32::try_from(q64).map_err(|_| Error::FieldTooLarge)?;
        if spec.degree == 1 {
            if spec.modulus != [0, 1] {
                return Err(Error::BadModulus);
            }
        } else {
            if spec.modulus.len() != spec.degree + 1
                || spec.modulus[spec.degree] != 1
                || spec.modulus.iter().any(|&x| x >= spec.p)
            {
                return Err(Error::BadModulus);
            }
            if !irreducible(&spec.modulus, spec.p) {
                return Err(Error::ReducibleModulus);
            }
        }
        Ok(Self { spec, q })
    }

    pub fn spec(&self) -> &FieldSpec {
        &self.spec
    }

    pub fn order(&self) -> u32 {
        self.q
    }

    pub fn check(&self, a: u32) -> Result<(), Error> {
        if a < self.q {
            Ok(())
        } else {
            Err(Error::BadElement(a))
        }
    }

    pub fn add(&self, a: u32, b: u32) -> u32 {
        if self.spec.degree == 1 {
            return (a + b) % self.spec.p;
        }
        let mut aa = a;
        let mut bb = b;
        let mut place = 1u32;
        let mut out = 0u32;
        for _ in 0..self.spec.degree {
            let digit = (aa % self.spec.p + bb % self.spec.p) % self.spec.p;
            out += digit * place;
            place *= self.spec.p;
            aa /= self.spec.p;
            bb /= self.spec.p;
        }
        out
    }

    pub fn neg(&self, a: u32) -> u32 {
        if a == 0 {
            return 0;
        }
        if self.spec.degree == 1 {
            return self.spec.p - a;
        }
        let mut aa = a;
        let mut place = 1u32;
        let mut out = 0u32;
        for _ in 0..self.spec.degree {
            let d = aa % self.spec.p;
            if d != 0 {
                out += (self.spec.p - d) * place;
            }
            place *= self.spec.p;
            aa /= self.spec.p;
        }
        out
    }

    pub fn sub(&self, a: u32, b: u32) -> u32 {
        self.add(a, self.neg(b))
    }

    pub fn mul(&self, a: u32, b: u32) -> u32 {
        if self.spec.degree == 1 {
            return ((u64::from(a) * u64::from(b)) % u64::from(self.spec.p)) as u32;
        }
        let m = self.spec.degree;
        let p = i64::from(self.spec.p);
        let da = digits(a, self.spec.p, m);
        let db = digits(b, self.spec.p, m);
        let mut c = vec![0i64; 2 * m - 1];
        for i in 0..m {
            for j in 0..m {
                c[i + j] = (c[i + j] + i64::from(da[i]) * i64::from(db[j])) % p;
            }
        }
        for k in (m..c.len()).rev() {
            let lead = c[k].rem_euclid(p);
            if lead == 0 {
                continue;
            }
            for j in 0..m {
                c[k - m + j] =
                    (c[k - m + j] - lead * i64::from(self.spec.modulus[j])).rem_euclid(p);
            }
        }
        encode_digits(&c[..m], self.spec.p)
    }

    pub fn pow(&self, mut a: u32, mut n: u64) -> u32 {
        let mut out = 1u32;
        while n > 0 {
            if n & 1 == 1 {
                out = self.mul(out, a);
            }
            a = self.mul(a, a);
            n >>= 1;
        }
        out
    }

    pub fn inv(&self, a: u32) -> Option<u32> {
        (a != 0).then(|| self.pow(a, u64::from(self.q) - 2))
    }

    pub fn eval(&self, coeffs: &[u32], x: u32) -> u32 {
        coeffs
            .iter()
            .rev()
            .fold(0, |acc, &c| self.add(self.mul(acc, x), c))
    }
}

pub fn validate_request(request: &Request) -> Result<(Field, Vec<u32>), Error> {
    if request.schema != REQUEST_SCHEMA || request.evaluation != "full-projective-nrc-v1" {
        return Err(Error::BadSchema);
    }
    if !(5..=10).contains(&request.redundancy) {
        return Err(Error::BadRedundancy);
    }
    if request.syndrome.len() != request.redundancy {
        return Err(Error::BadSyndromeDimension);
    }
    let field = Field::new(request.field.clone())?;
    for &x in &request.syndrome {
        field.check(x)?;
    }
    let syndrome = normalize_projective(&field, &request.syndrome)?;
    Ok((field, syndrome))
}

pub fn normalize_projective(field: &Field, vector: &[u32]) -> Result<Vec<u32>, Error> {
    let pivot = vector
        .iter()
        .copied()
        .find(|&x| x != 0)
        .ok_or(Error::ZeroSyndrome)?;
    let scale = field.inv(pivot).expect("nonzero pivot has inverse");
    Ok(vector.iter().map(|&x| field.mul(scale, x)).collect())
}

pub fn locator_kernel(field: &Field, syndrome: &[u32], degree: usize) -> Vec<Vec<u32>> {
    let rows = syndrome.len().saturating_sub(degree);
    let matrix: Vec<Vec<u32>> = (0..rows)
        .map(|i| (0..=degree).map(|j| syndrome[i + j]).collect())
        .collect();
    nullspace(field, &matrix, degree + 1)
}

pub fn split_support(field: &Field, locator: &[u32]) -> Option<Vec<Root>> {
    if locator.is_empty() || locator.iter().all(|&x| x == 0) {
        return None;
    }
    let t = locator.len() - 1;
    let degree = locator.iter().rposition(|&x| x != 0)?;
    if degree + 1 < t {
        return None;
    }
    let mut roots = Vec::with_capacity(t);
    for x in 0..field.order() {
        if field.eval(locator, x) == 0 {
            roots.push(Root::Finite(x));
        }
    }
    if roots.len() != degree {
        return None;
    }
    if degree + 1 == t {
        roots.push(Root::Infinity);
    }
    (roots.len() == t).then_some(roots)
}

pub fn locator_from_support(field: &Field, support: &[Root]) -> Result<Vec<u32>, Error> {
    let mut coeffs = vec![1u32];
    let mut infinity_count = 0usize;
    for root in support {
        match *root {
            Root::Finite(x) => {
                field.check(x)?;
                let mut next = vec![0u32; coeffs.len() + 1];
                for (j, &c) in coeffs.iter().enumerate() {
                    next[j] = field.sub(next[j], field.mul(x, c));
                    next[j + 1] = field.add(next[j + 1], c);
                }
                coeffs = next;
            }
            Root::Infinity => infinity_count += 1,
        }
    }
    if infinity_count > 1 {
        return Err(Error::BadSupport);
    }
    coeffs.resize(support.len() + 1, 0);
    normalize_projective(field, &coeffs)
}

pub fn recover_magnitudes(field: &Field, syndrome: &[u32], support: &[Root]) -> Option<Vec<u32>> {
    let r = syndrome.len();
    let t = support.len();
    if t == 0 || t > r {
        return None;
    }
    let mut augmented = vec![vec![0u32; t + 1]; r];
    for i in 0..r {
        for (j, root) in support.iter().enumerate() {
            augmented[i][j] = match *root {
                Root::Finite(x) => field.pow(x, i as u64),
                Root::Infinity => u32::from(i + 1 == r),
            };
        }
        augmented[i][t] = syndrome[i];
    }
    let (rref, pivots) = rref(field, augmented, t);
    if rref
        .iter()
        .any(|row| row[..t].iter().all(|&x| x == 0) && row[t] != 0)
        || pivots.len() != t
    {
        return None;
    }
    let mut solution = vec![0u32; t];
    for (row, &pivot) in pivots.iter().enumerate() {
        solution[pivot] = rref[row][t];
    }
    solution.iter().all(|&x| x != 0).then_some(solution)
}

pub fn search_locator(
    request: &Request,
    max_degree: usize,
    candidate_limit: u64,
) -> Result<LocatorCertificate, Error> {
    let (field, syndrome) = validate_request(request)?;
    let stop = max_degree
        .min(request.redundancy)
        .min(field.order() as usize + 1);
    let mut examined = 0u64;
    for degree in 1..=stop {
        let basis = locator_kernel(&field, &syndrome, degree);
        for locator in projective_span(&field, &basis, candidate_limit, &mut examined)? {
            let Some(support) = split_support(&field, &locator) else {
                continue;
            };
            let Some(magnitudes) = recover_magnitudes(&field, &syndrome, &support) else {
                continue;
            };
            return Ok(LocatorCertificate {
                schema: CERTIFICATE_SCHEMA.to_string(),
                field: request.field.clone(),
                redundancy: request.redundancy,
                normalized_syndrome: syndrome,
                distance: support.len(),
                locator: normalize_projective(&field, &locator)?,
                support,
                magnitudes,
                candidates_examined: examined,
            });
        }
    }
    Err(Error::NoLocator(stop))
}

pub fn verify_certificate(certificate: &LocatorCertificate) -> Result<(), Error> {
    if certificate.schema != CERTIFICATE_SCHEMA {
        return Err(Error::BadSchema);
    }
    let field = Field::new(certificate.field.clone())?;
    if certificate.redundancy != certificate.normalized_syndrome.len()
        || certificate.distance != certificate.support.len()
        || certificate.locator.len() != certificate.distance + 1
    {
        return Err(Error::BadSyndromeDimension);
    }
    let normalized = normalize_projective(&field, &certificate.normalized_syndrome)?;
    if normalized != certificate.normalized_syndrome {
        return Err(Error::BadSyndromeWitness);
    }
    if certificate.support.iter().collect::<BTreeSet<_>>().len() != certificate.support.len() {
        return Err(Error::BadSupport);
    }
    let locator = locator_from_support(&field, &certificate.support)?;
    if locator != normalize_projective(&field, &certificate.locator)? {
        return Err(Error::BadLocator);
    }
    if certificate.magnitudes.len() != certificate.support.len()
        || certificate
            .magnitudes
            .iter()
            .any(|&x| x == 0 || x >= field.order())
    {
        return Err(Error::BadMagnitude);
    }
    let mut rebuilt = vec![0u32; certificate.redundancy];
    for (&magnitude, root) in certificate.magnitudes.iter().zip(&certificate.support) {
        for (i, out) in rebuilt.iter_mut().enumerate() {
            let column = match *root {
                Root::Finite(x) => field.pow(x, i as u64),
                Root::Infinity => u32::from(i + 1 == certificate.redundancy),
            };
            *out = field.add(*out, field.mul(magnitude, column));
        }
    }
    if rebuilt != certificate.normalized_syndrome {
        return Err(Error::BadSyndromeWitness);
    }
    Ok(())
}

fn projective_span(
    field: &Field,
    basis: &[Vec<u32>],
    limit: u64,
    examined: &mut u64,
) -> Result<Vec<Vec<u32>>, Error> {
    if basis.is_empty() {
        return Ok(Vec::new());
    }
    let dimension = basis.len();
    let width = basis[0].len();
    let mut out = Vec::new();
    for pivot in 0..dimension {
        let free = dimension - pivot - 1;
        let count = u64::from(field.order()).pow(free as u32);
        for code in 0..count {
            *examined += 1;
            if *examined > limit {
                return Err(Error::CandidateLimit { limit });
            }
            let mut scalars = vec![0u32; dimension];
            scalars[pivot] = 1;
            let mut rest = code;
            for scalar in &mut scalars[pivot + 1..] {
                *scalar = (rest % u64::from(field.order())) as u32;
                rest /= u64::from(field.order());
            }
            let mut vector = vec![0u32; width];
            for (scalar, row) in scalars.into_iter().zip(basis) {
                for j in 0..width {
                    vector[j] = field.add(vector[j], field.mul(scalar, row[j]));
                }
            }
            out.push(vector);
        }
    }
    Ok(out)
}

fn nullspace(field: &Field, matrix: &[Vec<u32>], columns: usize) -> Vec<Vec<u32>> {
    if matrix.is_empty() {
        return (0..columns)
            .map(|j| {
                let mut e = vec![0u32; columns];
                e[j] = 1;
                e
            })
            .collect();
    }
    let (reduced, pivots) = rref(field, matrix.to_vec(), columns);
    let pivot_set: BTreeSet<usize> = pivots.iter().copied().collect();
    let mut basis = Vec::new();
    for free in (0..columns).filter(|j| !pivot_set.contains(j)) {
        let mut v = vec![0u32; columns];
        v[free] = 1;
        for (row, &pivot) in pivots.iter().enumerate() {
            v[pivot] = field.neg(reduced[row][free]);
        }
        basis.push(v);
    }
    basis
}

fn rref(
    field: &Field,
    mut matrix: Vec<Vec<u32>>,
    pivot_columns: usize,
) -> (Vec<Vec<u32>>, Vec<usize>) {
    let mut row = 0usize;
    let mut pivots = Vec::new();
    for col in 0..pivot_columns {
        let Some(pivot) = (row..matrix.len()).find(|&i| matrix[i][col] != 0) else {
            continue;
        };
        matrix.swap(row, pivot);
        let inv = field.inv(matrix[row][col]).expect("pivot is nonzero");
        for x in &mut matrix[row] {
            *x = field.mul(*x, inv);
        }
        let pivot_row = matrix[row].clone();
        for (i, target) in matrix.iter_mut().enumerate() {
            if i == row || target[col] == 0 {
                continue;
            }
            let factor = target[col];
            for j in col..target.len() {
                target[j] = field.sub(target[j], field.mul(factor, pivot_row[j]));
            }
        }
        pivots.push(col);
        row += 1;
        if row == matrix.len() {
            break;
        }
    }
    (matrix, pivots)
}

fn digits(mut value: u32, p: u32, count: usize) -> Vec<u32> {
    let mut out = Vec::with_capacity(count);
    for _ in 0..count {
        out.push(value % p);
        value /= p;
    }
    out
}

fn encode_digits(digits: &[i64], p: u32) -> u32 {
    let mut out = 0u32;
    let mut place = 1u32;
    for &d in digits {
        out += d.rem_euclid(i64::from(p)) as u32 * place;
        place *= p;
    }
    out
}

fn is_prime(n: u32) -> bool {
    if n < 2 {
        return false;
    }
    if n.is_multiple_of(2) {
        return n == 2;
    }
    let mut d = 3u32;
    while u64::from(d) * u64::from(d) <= u64::from(n) {
        if n.is_multiple_of(d) {
            return false;
        }
        d += 2;
    }
    true
}

fn irreducible(f: &[u32], p: u32) -> bool {
    let degree = f.len() - 1;
    for d in 1..=degree / 2 {
        let count = u64::from(p).pow(d as u32);
        for code in 0..count {
            let mut divisor = vec![0u32; d + 1];
            divisor[d] = 1;
            let mut rest = code;
            for coefficient in &mut divisor[..d] {
                *coefficient = (rest % u64::from(p)) as u32;
                rest /= u64::from(p);
            }
            if polynomial_remainder(f, &divisor, p).iter().all(|&x| x == 0) {
                return false;
            }
        }
    }
    true
}

fn polynomial_remainder(dividend: &[u32], divisor: &[u32], p: u32) -> Vec<u32> {
    let mut out: Vec<i64> = dividend.iter().map(|&x| i64::from(x)).collect();
    let d = divisor.len() - 1;
    let modulus = i64::from(p);
    for k in (d..out.len()).rev() {
        let lead = out[k].rem_euclid(modulus);
        for j in 0..=d {
            out[k - d + j] = (out[k - d + j] - lead * i64::from(divisor[j])).rem_euclid(modulus);
        }
    }
    out[..d]
        .iter()
        .map(|x| x.rem_euclid(modulus) as u32)
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    fn prime_field(p: u32) -> FieldSpec {
        FieldSpec {
            p,
            degree: 1,
            modulus: vec![0, 1],
            encoding: "polynomial-basis-base-p-integer-v1".into(),
        }
    }

    fn request(field: FieldSpec, redundancy: usize, syndrome: Vec<u32>) -> Request {
        Request {
            schema: REQUEST_SCHEMA.into(),
            field,
            redundancy,
            evaluation: "full-projective-nrc-v1".into(),
            syndrome,
            operation: None,
        }
    }

    #[test]
    fn gf16_arithmetic_matches_x4_x_1() {
        let field = Field::new(FieldSpec {
            p: 2,
            degree: 4,
            modulus: vec![1, 1, 0, 0, 1],
            encoding: "polynomial-basis-base-p-integer-v1".into(),
        })
        .unwrap();
        assert_eq!(field.mul(2, 8), 3);
        for a in 1..16 {
            assert_eq!(field.mul(a, field.inv(a).unwrap()), 1);
        }
    }

    #[test]
    fn both_projective_locator_charts_round_trip() {
        let field = Field::new(prime_field(7)).unwrap();
        for support in [
            vec![Root::Finite(1), Root::Finite(2), Root::Finite(4)],
            vec![Root::Finite(1), Root::Finite(3), Root::Infinity],
        ] {
            let locator = locator_from_support(&field, &support).unwrap();
            assert_eq!(split_support(&field, &locator).unwrap(), support);
        }
    }

    #[test]
    fn decode_and_verify_weight_two() {
        let field = Field::new(prime_field(7)).unwrap();
        let support = vec![Root::Finite(1), Root::Finite(3)];
        let magnitudes = [2, 5];
        let mut syndrome = vec![0u32; 5];
        for (&e, root) in magnitudes.iter().zip(&support) {
            for (i, out) in syndrome.iter_mut().enumerate() {
                let x = match root {
                    Root::Finite(x) => field.pow(*x, i as u64),
                    Root::Infinity => u32::from(i == 4),
                };
                *out = field.add(*out, field.mul(e, x));
            }
        }
        let certificate = search_locator(&request(prime_field(7), 5, syndrome), 3, 1_000).unwrap();
        assert_eq!(certificate.distance, 2);
        verify_certificate(&certificate).unwrap();
    }

    #[test]
    fn c969_r10_q16_lucas_witness_replays() {
        let field_spec = FieldSpec {
            p: 2,
            degree: 4,
            modulus: vec![1, 1, 0, 0, 1],
            encoding: "polynomial-basis-base-p-integer-v1".into(),
        };
        let field = Field::new(field_spec.clone()).unwrap();
        let support = vec![0, 1, 2, 3, 6, 7, 8, 15]
            .into_iter()
            .map(Root::Finite)
            .collect::<Vec<_>>();
        let locator = locator_from_support(&field, &support).unwrap();
        let syndrome = vec![0, 0, 0, 0, 1, 0, 0, 0, 0, 0];
        let magnitudes = recover_magnitudes(&field, &syndrome, &support).unwrap();
        let certificate = LocatorCertificate {
            schema: CERTIFICATE_SCHEMA.into(),
            field: field_spec,
            redundancy: 10,
            normalized_syndrome: syndrome,
            distance: 8,
            locator,
            support,
            magnitudes,
            candidates_examined: 0,
        };
        verify_certificate(&certificate).unwrap();
    }
}
