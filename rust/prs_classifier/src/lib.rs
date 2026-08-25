use serde::{Deserialize, Serialize};
use std::collections::BTreeSet;
use thiserror::Error;

pub const REQUEST_SCHEMA: &str = "c969-request-v1";
pub const CERTIFICATE_SCHEMA: &str = "c969-locator-certificate-v1";
pub const DEEP_CERTIFICATE_SCHEMA: &str = "c969-deep-certificate-v1";

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
    #[error("full-length PRS requires q>=r so that the code has positive dimension")]
    BadCodeParameters,
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
    #[error("positive deep certificate failed independent replay")]
    BadDeepCertificate,
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

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct DeepCertificate {
    pub schema: String,
    pub domain_registry_version: u32,
    pub request: Request,
    pub normalized_syndrome: Vec<u32>,
    pub distance: usize,
    pub family: String,
    pub family_evidence: DeepFamilyEvidence,
    pub canonical_syndrome: Vec<u32>,
    pub transporter: Transporter,
    pub split_free_source: String,
    pub radius_source: String,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
#[serde(tag = "route", rename_all = "snake_case")]
pub enum DeepFamilyEvidence {
    Persistent {
        kind: PersistentKind,
    },
    FrozenOrbit {
        pgl_orbit_count: usize,
        semilinear_orbit_size: u64,
        semilinear_stabilizer_order: u64,
    },
    Formula {
        invariant: String,
    },
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct SearchBoundary {
    pub schema: &'static str,
    pub normalized_syndrome: Vec<u32>,
    pub searched_through_degree: usize,
    pub candidates_examined: u64,
    pub conclusion: &'static str,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct Transporter {
    pub frobenius_exponent: usize,
    pub matrix: [u32; 4],
    pub projective_output_scale: u32,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct Canonicalization {
    pub normalized_input: Vec<u32>,
    pub canonical_syndrome: Vec<u32>,
    pub transporter: Transporter,
    pub transporters_examined: u64,
    pub complexity: &'static str,
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum PersistentKind {
    Tangent,
    Sigma,
    RationalSecant,
    Other,
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum VerdictStatus {
    Deep,
    NotDeep,
    Unresolved,
    Unsupported,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct ClassificationResult {
    pub status: VerdictStatus,
    pub distance: Option<usize>,
    pub distance_lower_bound: usize,
    pub family: Option<String>,
    pub canonicalization: Option<Canonicalization>,
    pub locator_certificate: Option<LocatorCertificate>,
    pub deep_certificate: Option<DeepCertificate>,
    pub split_free_source: Option<String>,
    pub radius_source: Option<String>,
    pub note: String,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct FrozenOrbit {
    pub redundancy: usize,
    pub q: u32,
    pub field: FrozenField,
    pub canonical_representative: Vec<u32>,
    pub family: String,
    pub pgl_orbit_count: usize,
    pub semilinear_orbit_size: u64,
    pub semilinear_stabilizer_order: u64,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct FrozenField {
    pub p: u32,
    pub degree: usize,
    pub modulus: Vec<u32>,
}

#[derive(Debug, Deserialize)]
struct FrozenOrbitRegistry {
    schema: String,
    records: Vec<FrozenOrbit>,
}

#[derive(Debug, Deserialize)]
struct TheoremDomainRegistry {
    schema: String,
    registry_version: u32,
    levels: Vec<TheoremDomainLevel>,
}

#[derive(Debug, Deserialize)]
struct TheoremDomainLevel {
    redundancy: usize,
    covering_radius: usize,
    deep_predicate: String,
    families: Vec<String>,
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

    pub fn frobenius(&self, a: u32, exponent: usize) -> u32 {
        let mut power = 1u64;
        for _ in 0..(exponent % self.spec.degree) {
            power *= u64::from(self.spec.p);
        }
        self.pow(a, power)
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
    if field.order() < request.redundancy as u32 {
        return Err(Error::BadCodeParameters);
    }
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

pub fn persistent_kind(field: &Field, syndrome: &[u32]) -> PersistentKind {
    if syndrome.len() < 4 {
        return PersistentKind::Other;
    }
    let degree = syndrome.len() - 2;
    let basis = locator_kernel(field, syndrome, degree);
    let Some((gcd, infinity_multiplicity)) = homogeneous_basis_gcd(field, &basis, degree) else {
        return PersistentKind::Other;
    };
    let total_degree = polynomial_degree(&gcd).unwrap_or(0) + infinity_multiplicity;
    if total_degree != 2 {
        return PersistentKind::Other;
    }
    if infinity_multiplicity == 2 {
        return PersistentKind::Tangent;
    }
    if infinity_multiplicity == 1 {
        return PersistentKind::RationalSecant;
    }
    let roots = (0..field.order())
        .filter(|&x| field.eval(&gcd, x) == 0)
        .count();
    match roots {
        0 => PersistentKind::Sigma,
        1 => PersistentKind::Tangent,
        2 => PersistentKind::RationalSecant,
        _ => PersistentKind::Other,
    }
}

fn homogeneous_cubic_derivatives(field: &Field, cubic: &[u32]) -> (Vec<u32>, Vec<u32>) {
    let mut derivative_t = vec![0u32; 3];
    let mut derivative_u = vec![0u32; 3];
    for (i, &coefficient) in cubic.iter().enumerate().take(4) {
        if i > 0 {
            derivative_t[i - 1] = field.mul(coefficient, (i as u32) % field.spec.p);
        }
        if i < 3 {
            derivative_u[i] = field.mul(coefficient, ((3 - i) as u32) % field.spec.p);
        }
    }
    (derivative_t, derivative_u)
}

fn cubic_pencil_jacobian(field: &Field, basis: &[Vec<u32>]) -> Option<Vec<u32>> {
    if basis.len() != 2 || basis.iter().any(|cubic| cubic.len() != 4) {
        return None;
    }
    let (c_t, c_u) = homogeneous_cubic_derivatives(field, &basis[0]);
    let (d_t, d_u) = homogeneous_cubic_derivatives(field, &basis[1]);
    let left = polynomial_mul(field, &c_t, &d_u);
    let right = polynomial_mul(field, &c_u, &d_t);
    Some(
        left.into_iter()
            .zip(right)
            .map(|(a, b)| field.sub(a, b))
            .collect(),
    )
}

fn homogeneous_quadratic_square_root(field: &Field, quartic: &[u32]) -> Option<Vec<u32>> {
    if quartic.len() != 5 || quartic.iter().all(|&x| x == 0) {
        return None;
    }
    let mut quadratic = vec![0u32; 3];
    let scale;
    if field.spec.p == 2 {
        if quartic[1] != 0 || quartic[3] != 0 {
            return None;
        }
        let pivot = [0usize, 2, 4].into_iter().find(|&i| quartic[i] != 0)?;
        scale = quartic[pivot];
        let scale_inverse = field.inv(scale)?;
        for j in 0..3 {
            quadratic[j] = field.pow(
                field.mul(quartic[2 * j], scale_inverse),
                u64::from(field.order()) / 2,
            );
        }
    } else if quartic[0] != 0 {
        scale = quartic[0];
        quadratic[0] = 1;
        let two_inverse = field.inv(2 % field.spec.p)?;
        let scale_inverse = field.inv(scale)?;
        quadratic[1] = field.mul(field.mul(quartic[1], scale_inverse), two_inverse);
        quadratic[2] = field.mul(
            field.sub(
                field.mul(quartic[2], scale_inverse),
                field.mul(quadratic[1], quadratic[1]),
            ),
            two_inverse,
        );
    } else if quartic[2] != 0 {
        if quartic[1] != 0 {
            return None;
        }
        scale = quartic[2];
        quadratic[1] = 1;
        quadratic[2] = field.mul(
            field.mul(quartic[3], field.inv(scale)?),
            field.inv(2 % field.spec.p)?,
        );
    } else {
        if quartic[..4].iter().any(|&x| x != 0) {
            return None;
        }
        scale = quartic[4];
        quadratic[2] = 1;
    }
    let rebuilt = polynomial_mul(field, &quadratic, &quadratic)
        .into_iter()
        .map(|coefficient| field.mul(scale, coefficient))
        .collect::<Vec<_>>();
    (rebuilt == quartic)
        .then(|| normalize_projective(field, &quadratic).ok())
        .flatten()
}

fn r5_tame_formula_family(field: &Field, syndrome: &[u32]) -> Option<(&'static str, &'static str)> {
    if syndrome.len() != 5 || field.spec.p == 3 {
        return None;
    }
    let basis = locator_kernel(field, syndrome, 3);
    let (gcd, infinity_multiplicity) = homogeneous_basis_gcd(field, &basis, 3)?;
    if polynomial_degree(&gcd).unwrap_or(0) + infinity_multiplicity != 0 {
        return None;
    }
    let quadratic =
        homogeneous_quadratic_square_root(field, &cubic_pencil_jacobian(field, &basis)?)?;
    let finite_roots = (0..field.order())
        .filter(|&x| field.eval(&quadratic, x) == 0)
        .count();
    let infinity_root = usize::from(polynomial_degree(&quadratic)? < 2);
    match (finite_roots + infinity_root, field.order() % 3) {
        (2, 2) => Some((
            "r5.osculating_rational",
            "r5.cyclic_jacobian_square:rational_ramification_pair:q_mod_3=2",
        )),
        (0, 1) => Some((
            "r5.osculating_conjugate",
            "r5.cyclic_jacobian_square:conjugate_ramification_pair:q_mod_3=1",
        )),
        _ => None,
    }
}

fn substitute_binary_cubic(
    field: &Field,
    cubic: &[u32],
    old_t: [u32; 2],
    old_u: [u32; 2],
) -> Vec<u32> {
    let mut out = vec![0u32; 4];
    for (i, &coefficient) in cubic.iter().enumerate().take(4) {
        let term = polynomial_mul(
            field,
            &polynomial_power(field, &old_t, i),
            &polynomial_power(field, &old_u, 3 - i),
        );
        for (target, value) in out.iter_mut().zip(term) {
            *target = field.add(*target, field.mul(coefficient, value));
        }
    }
    out
}

fn r5_char3_formula_family(
    field: &Field,
    syndrome: &[u32],
) -> Option<(&'static str, &'static str)> {
    if syndrome.len() != 5 || field.spec.p != 3 {
        return None;
    }
    if syndrome == [0, 0, 1, 0, 0] {
        return Some(("r5.char3_nucleus", "r5.char3_cube_pencil:fixed_nucleus"));
    }
    let basis = locator_kernel(field, syndrome, 3);
    if basis.len() != 2 {
        return None;
    }
    let cube_scalars = nullspace(
        field,
        &[
            vec![basis[0][1], basis[1][1]],
            vec![basis[0][2], basis[1][2]],
        ],
        2,
    );
    if cube_scalars.len() != 1 {
        return None;
    }
    let scalars = &cube_scalars[0];
    let cube = (0..4)
        .map(|i| {
            field.add(
                field.mul(scalars[0], basis[0][i]),
                field.mul(scalars[1], basis[1][i]),
            )
        })
        .collect::<Vec<_>>();
    if cube[1] != 0 || cube[2] != 0 {
        return None;
    }
    let cube_root_power = u64::from(field.order() / 3);
    let linear_t = field.pow(cube[3], cube_root_power);
    let linear_u = field.pow(cube[0], cube_root_power);
    let (root_t, root_u) = (linear_u, field.neg(linear_t));
    let (base_t, base_u) = if linear_t != 0 {
        (field.inv(linear_t)?, 0)
    } else {
        (0, field.inv(linear_u)?)
    };
    let other = if scalars[1] != 0 {
        &basis[0]
    } else {
        &basis[1]
    };
    let transformed = substitute_binary_cubic(field, other, [base_t, root_t], [base_u, root_u]);
    let lead_inverse = field.inv(transformed[3])?;
    let quadratic_term = field.mul(transformed[2], lead_inverse);
    let linear_term = field.mul(transformed[1], lead_inverse);
    if quadratic_term != 0 || linear_term == 0 {
        return None;
    }
    let minus_linear = field.neg(linear_term);
    if field.pow(minus_linear, u64::from(field.order() - 1) / 2) == 1 {
        return None;
    }
    Some((
        "r5.char3_wild",
        "r5.char3_additive_kernel:minus_linear_nonsquare",
    ))
}

fn r5_formula_family(field: &Field, syndrome: &[u32]) -> Option<(&'static str, &'static str)> {
    r5_tame_formula_family(field, syndrome).or_else(|| r5_char3_formula_family(field, syndrome))
}

pub fn apply_semilinear(
    field: &Field,
    syndrome: &[u32],
    frobenius_exponent: usize,
    matrix: [u32; 4],
) -> Result<(Vec<u32>, u32), Error> {
    for &entry in &matrix {
        field.check(entry)?;
    }
    let [alpha, beta, gamma, delta] = matrix;
    if field.sub(field.mul(alpha, delta), field.mul(beta, gamma)) == 0 {
        return Err(Error::BadSupport);
    }
    let n = syndrome.len() - 1;
    let frobenius_syndrome: Vec<u32> = syndrome
        .iter()
        .map(|&x| field.frobenius(x, frobenius_exponent))
        .collect();
    let mut out = vec![0u32; syndrome.len()];
    for (i, output) in out.iter_mut().enumerate() {
        let left = polynomial_power(field, &[beta, alpha], i);
        let right = polynomial_power(field, &[delta, gamma], n - i);
        let row = polynomial_mul(field, &left, &right);
        for j in 0..=n {
            *output = field.add(*output, field.mul(row[j], frobenius_syndrome[j]));
        }
    }
    let pivot = out
        .iter()
        .copied()
        .find(|&x| x != 0)
        .ok_or(Error::ZeroSyndrome)?;
    let scale = field.inv(pivot).expect("nonzero pivot has inverse");
    for x in &mut out {
        *x = field.mul(scale, *x);
    }
    Ok((out, scale))
}

pub fn canonicalize_syndrome(
    request: &Request,
    transporter_limit: u64,
) -> Result<Canonicalization, Error> {
    let (field, syndrome) = validate_request(request)?;
    let matrices = normalized_pgl_matrices(&field);
    let total = u64::try_from(matrices.len()).unwrap_or(u64::MAX)
        * u64::try_from(field.spec.degree).unwrap_or(u64::MAX);
    if total > transporter_limit {
        return Err(Error::CandidateLimit {
            limit: transporter_limit,
        });
    }
    let mut best = syndrome.clone();
    let mut best_transporter = Transporter {
        frobenius_exponent: 0,
        matrix: [1, 0, 0, 1],
        projective_output_scale: 1,
    };
    let mut examined = 0u64;
    for exponent in 0..field.spec.degree {
        for &matrix in &matrices {
            examined += 1;
            let (candidate, scale) = apply_semilinear(&field, &syndrome, exponent, matrix)?;
            if candidate < best {
                best = candidate;
                best_transporter = Transporter {
                    frobenius_exponent: exponent,
                    matrix,
                    projective_output_scale: scale,
                };
            }
        }
    }
    Ok(Canonicalization {
        normalized_input: syndrome,
        canonical_syndrome: best,
        transporter: best_transporter,
        transporters_examined: examined,
        complexity: "explicit PGL(2,q) x Gal enumeration: m*(q^3-q) transports",
    })
}

pub fn frozen_orbit_lookup(
    field: &Field,
    redundancy: usize,
    canonical_syndrome: &[u32],
) -> Option<FrozenOrbit> {
    let registry: FrozenOrbitRegistry =
        serde_json::from_str(include_str!("../data/frozen-orbits-v1.json"))
            .expect("generated frozen orbit registry must parse");
    assert_eq!(registry.schema, "c969-frozen-orbit-registry-v1");
    registry.records.into_iter().find(|record| {
        record.redundancy == redundancy
            && record.q == field.order()
            && record.field.p == field.spec.p
            && record.field.degree == field.spec.degree
            && record.field.modulus == field.spec.modulus
            && record.canonical_representative == canonical_syndrome
    })
}

fn theorem_domain_registry() -> TheoremDomainRegistry {
    let registry: TheoremDomainRegistry = serde_json::from_str(include_str!(
        "../../../notes/reed-solomon-tasks/c969-theorem-domain-v1.json"
    ))
    .expect("frozen theorem-domain registry must parse");
    assert_eq!(registry.schema, "c969-theorem-domain-v1");
    assert_eq!(registry.registry_version, 1);
    registry
}

fn deep_domain_level(redundancy: usize, q: u32) -> Option<TheoremDomainLevel> {
    theorem_domain_registry()
        .levels
        .into_iter()
        .find(|level| level.redundancy == redundancy)
        .filter(|level| {
            level
                .deep_predicate
                .strip_prefix("q>=")
                .and_then(|threshold| threshold.parse::<u32>().ok())
                .is_some_and(|threshold| q >= threshold)
        })
}

fn split_free_source(
    kind: PersistentKind,
    frozen: Option<&FrozenOrbit>,
    formula: Option<(&str, &str)>,
) -> String {
    match kind {
        PersistentKind::Tangent | PersistentKind::Sigma => {
            "intrinsic quadratic Hankel-gcd replay".into()
        }
        _ if frozen.is_some() => "frozen semilinear exception registry".into(),
        _ if formula.is_some() => "intrinsic R5 formula-family replay".into(),
        _ => "locator search exhausted through degree r-2".into(),
    }
}

fn deep_family_evidence(
    kind: PersistentKind,
    frozen: Option<&FrozenOrbit>,
    formula: Option<(&str, &str)>,
) -> Option<DeepFamilyEvidence> {
    match kind {
        PersistentKind::Tangent | PersistentKind::Sigma => {
            Some(DeepFamilyEvidence::Persistent { kind })
        }
        _ => frozen
            .map(|record| DeepFamilyEvidence::FrozenOrbit {
                pgl_orbit_count: record.pgl_orbit_count,
                semilinear_orbit_size: record.semilinear_orbit_size,
                semilinear_stabilizer_order: record.semilinear_stabilizer_order,
            })
            .or_else(|| {
                formula.map(|(_, invariant)| DeepFamilyEvidence::Formula {
                    invariant: invariant.into(),
                })
            }),
    }
}

pub fn verify_deep_certificate(
    certificate: &DeepCertificate,
    transporter_limit: u64,
) -> Result<(), Error> {
    if certificate.schema != DEEP_CERTIFICATE_SCHEMA || certificate.domain_registry_version != 1 {
        return Err(Error::BadDeepCertificate);
    }
    let (field, syndrome) =
        validate_request(&certificate.request).map_err(|_| Error::BadDeepCertificate)?;
    if syndrome != certificate.normalized_syndrome
        || certificate.distance + 1 != certificate.request.redundancy
    {
        return Err(Error::BadDeepCertificate);
    }

    let canonicalization = canonicalize_syndrome(&certificate.request, transporter_limit)
        .map_err(|_| Error::BadDeepCertificate)?;
    if canonicalization.canonical_syndrome != certificate.canonical_syndrome
        || canonicalization.transporter != certificate.transporter
    {
        return Err(Error::BadDeepCertificate);
    }
    let (transported, scale) = apply_semilinear(
        &field,
        &syndrome,
        certificate.transporter.frobenius_exponent,
        certificate.transporter.matrix,
    )
    .map_err(|_| Error::BadDeepCertificate)?;
    if transported != certificate.canonical_syndrome
        || scale != certificate.transporter.projective_output_scale
    {
        return Err(Error::BadDeepCertificate);
    }

    let persistent = persistent_kind(&field, &syndrome);
    let frozen = frozen_orbit_lookup(
        &field,
        certificate.request.redundancy,
        &certificate.canonical_syndrome,
    );
    let formula = r5_formula_family(&field, &syndrome);
    let replayed_family = match persistent {
        PersistentKind::Tangent => Some("persistent.tangent"),
        PersistentKind::Sigma => Some("persistent.sigma"),
        _ => frozen
            .as_ref()
            .map(|record| record.family.as_str())
            .or_else(|| formula.map(|(family, _)| family)),
    };
    if replayed_family != Some(certificate.family.as_str())
        || deep_family_evidence(persistent, frozen.as_ref(), formula)
            != Some(certificate.family_evidence.clone())
        || split_free_source(persistent, frozen.as_ref(), formula) != certificate.split_free_source
    {
        return Err(Error::BadDeepCertificate);
    }

    let level = deep_domain_level(certificate.request.redundancy, field.order())
        .ok_or(Error::BadDeepCertificate)?;
    let expected_radius_source = format!(
        "theorem-domain-v1:R{} rho={} for {}",
        level.redundancy, level.covering_radius, level.deep_predicate
    );
    if level.covering_radius != certificate.distance
        || !level.families.contains(&certificate.family)
        || certificate.radius_source != expected_radius_source
    {
        return Err(Error::BadDeepCertificate);
    }
    Ok(())
}

pub fn classify(
    request: &Request,
    locator_candidate_limit: u64,
    transporter_limit: u64,
) -> Result<ClassificationResult, Error> {
    let (field, syndrome) = validate_request(request)?;
    let split_degree = request.redundancy - 2;
    let persistent = persistent_kind(&field, &syndrome);
    if !matches!(persistent, PersistentKind::Tangent | PersistentKind::Sigma) {
        match search_locator(request, split_degree, locator_candidate_limit) {
            Ok(certificate) => {
                return Ok(ClassificationResult {
                    status: VerdictStatus::NotDeep,
                    distance: Some(certificate.distance),
                    distance_lower_bound: certificate.distance,
                    family: None,
                    canonicalization: None,
                    locator_certificate: Some(certificate),
                    deep_certificate: None,
                    split_free_source: None,
                    radius_source: None,
                    note: "explicit split locator and nonzero magnitudes certify a closer word"
                        .into(),
                });
            }
            Err(Error::NoLocator(_)) => {}
            Err(error) => return Err(error),
        }
    }

    let canonicalization = canonicalize_syndrome(request, transporter_limit)?;
    let frozen = frozen_orbit_lookup(
        &field,
        request.redundancy,
        &canonicalization.canonical_syndrome,
    );
    let formula = r5_formula_family(&field, &syndrome);
    let family = match persistent {
        PersistentKind::Tangent => Some("persistent.tangent".to_string()),
        PersistentKind::Sigma => Some("persistent.sigma".to_string()),
        _ => frozen
            .as_ref()
            .map(|record| record.family.clone())
            .or_else(|| formula.map(|(family, _)| family.into())),
    };
    let q = field.order();
    let domain_level = deep_domain_level(request.redundancy, q);
    let (status, distance, radius_source, note) = if request.redundancy == 7
        && matches!(q, 7..=9)
        && family.is_some()
    {
        (
            VerdictStatus::Unresolved,
            None,
            None,
            "split-free classification is exact, but the frozen surface has no covering-radius premise".into(),
        )
    } else if let (Some(family), Some(level)) = (family.as_ref(), domain_level.as_ref()) {
        if level.families.contains(family) {
            (
                VerdictStatus::Deep,
                Some(level.covering_radius),
                Some(format!(
                    "theorem-domain-v1:R{} rho={} for {}",
                    level.redundancy, level.covering_radius, level.deep_predicate
                )),
                "frozen family and covering-radius routes are both complete".into(),
            )
        } else {
            (
                VerdictStatus::Unsupported,
                None,
                None,
                "recognized family is absent from the applicable theorem-domain row".into(),
            )
        }
    } else {
        (
            VerdictStatus::Unsupported,
            None,
            None,
            if family.is_some() {
                "family recognized, but code classification lies outside the frozen theorem range"
                    .into()
            } else {
                "split-free input has no enabled structural adapter in this implementation".into()
            },
        )
    };
    let replay_source = split_free_source(persistent, frozen.as_ref(), formula);
    let deep_certificate = if status == VerdictStatus::Deep {
        Some(DeepCertificate {
            schema: DEEP_CERTIFICATE_SCHEMA.into(),
            domain_registry_version: 1,
            request: request.clone(),
            normalized_syndrome: syndrome.clone(),
            distance: distance.expect("DEEP verdict has radius"),
            family: family.clone().expect("DEEP verdict has family"),
            family_evidence: deep_family_evidence(persistent, frozen.as_ref(), formula)
                .expect("DEEP verdict has family evidence"),
            canonical_syndrome: canonicalization.canonical_syndrome.clone(),
            transporter: canonicalization.transporter.clone(),
            split_free_source: replay_source.clone(),
            radius_source: radius_source
                .clone()
                .expect("DEEP verdict has radius source"),
        })
    } else {
        None
    };
    Ok(ClassificationResult {
        status,
        distance,
        distance_lower_bound: request.redundancy - 1,
        family,
        canonicalization: Some(canonicalization),
        locator_certificate: None,
        deep_certificate,
        split_free_source: Some(replay_source),
        radius_source,
        note,
    })
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

const TERMINAL_GRID_SIZE: u32 = 12;

fn reverse_root(field: &Field, root: Root) -> Root {
    match root {
        Root::Infinity => Root::Finite(0),
        Root::Finite(0) => Root::Infinity,
        Root::Finite(x) => Root::Finite(field.inv(x).expect("nonzero field element")),
    }
}

fn cubic_completions_in_chart(
    field: &Field,
    functional: &[u32; 4],
    forbidden: &[Root],
) -> Vec<Vec<Root>> {
    let grid_stop = field.order().min(TERMINAL_GRID_SIZE);
    let mut completions = Vec::new();
    let forbidden_finite = forbidden
        .iter()
        .filter_map(|root| match root {
            Root::Finite(x) => Some(*x),
            Root::Infinity => None,
        })
        .collect::<BTreeSet<_>>();
    for x in 0..grid_stop {
        if forbidden_finite.contains(&x) {
            continue;
        }
        let a = field.add(field.neg(field.mul(functional[0], x)), functional[1]);
        let b = field.sub(field.mul(functional[1], x), functional[2]);
        let c = field.sub(functional[3], field.mul(functional[2], x));
        for y in 0..grid_stop {
            if y == x || forbidden_finite.contains(&y) {
                continue;
            }
            let denominator = field.add(field.mul(a, y), b);
            let numerator = field.add(field.mul(b, y), c);
            if denominator == 0 {
                if numerator != 0 {
                    continue;
                }
                for z in 0..grid_stop {
                    if z != x && z != y && !forbidden_finite.contains(&z) {
                        completions.push(vec![Root::Finite(x), Root::Finite(y), Root::Finite(z)]);
                    }
                }
                continue;
            }
            let z = field.mul(
                field.neg(numerator),
                field.inv(denominator).expect("nonzero denominator"),
            );
            if z == x || z == y || forbidden_finite.contains(&z) {
                continue;
            }
            completions.push(vec![Root::Finite(x), Root::Finite(y), Root::Finite(z)]);
        }
    }
    completions
}

fn terminal_cubic_completions(
    field: &Field,
    functional: [u32; 4],
    forbidden: &[Root],
) -> Vec<Vec<Root>> {
    let mut completions = cubic_completions_in_chart(field, &functional, forbidden);
    let reversed_functional = [functional[3], functional[2], functional[1], functional[0]];
    let reversed_forbidden = forbidden
        .iter()
        .map(|&root| reverse_root(field, root))
        .collect::<Vec<_>>();
    completions.extend(
        cubic_completions_in_chart(field, &reversed_functional, &reversed_forbidden)
            .into_iter()
            .map(|support| {
                support
                    .into_iter()
                    .map(|root| reverse_root(field, root))
                    .collect()
            }),
    );
    completions
}

struct ProjectivePrefixes {
    q: u32,
    point_count: u64,
    indices: Vec<u64>,
    first: bool,
    done: bool,
}

impl ProjectivePrefixes {
    fn new(field: &Field, size: usize) -> Self {
        let point_count = u64::from(field.order()) + 1;
        Self {
            q: field.order(),
            point_count,
            indices: (0..size as u64).collect(),
            first: true,
            done: size as u64 > point_count,
        }
    }

    fn support(&self) -> Vec<Root> {
        self.indices
            .iter()
            .map(|&index| {
                if index < u64::from(self.q) {
                    Root::Finite(index as u32)
                } else {
                    Root::Infinity
                }
            })
            .collect()
    }
}

impl Iterator for ProjectivePrefixes {
    type Item = Vec<Root>;

    fn next(&mut self) -> Option<Self::Item> {
        if self.done {
            return None;
        }
        if self.first {
            self.first = false;
            return Some(self.support());
        }
        let size = self.indices.len();
        let Some(position) = (0..size)
            .rev()
            .find(|&i| self.indices[i] < self.point_count - (size - i) as u64)
        else {
            self.done = true;
            return None;
        };
        self.indices[position] += 1;
        for i in position + 1..size {
            self.indices[i] = self.indices[i - 1] + 1;
        }
        Some(self.support())
    }
}

pub fn search_fast_terminal_locator(
    request: &Request,
    prefix_limit: u64,
) -> Result<LocatorCertificate, Error> {
    let (field, syndrome) = validate_request(request)?;
    if !(5..=7).contains(&request.redundancy) {
        return Err(Error::NoLocator(request.redundancy - 1));
    }
    let prefix_degree = request.redundancy - 4;
    for (prefix, index) in ProjectivePrefixes::new(&field, prefix_degree).zip(0u64..) {
        if index >= prefix_limit {
            return Err(Error::CandidateLimit {
                limit: prefix_limit,
            });
        }
        let examined = index + 1;
        let prefix_locator = locator_from_support(&field, &prefix)?;
        let mut functional = [0u32; 4];
        for (j, output) in functional.iter_mut().enumerate() {
            for (i, &coefficient) in prefix_locator.iter().enumerate() {
                *output = field.add(*output, field.mul(syndrome[i + j], coefficient));
            }
        }
        for completion in terminal_cubic_completions(&field, functional, &prefix) {
            let mut support = prefix.clone();
            support.extend(completion);
            support.sort_unstable();
            let locator = locator_from_support(&field, &support)?;
            let hankel_value = syndrome
                .iter()
                .zip(&locator)
                .map(|(&s, &coefficient)| field.mul(s, coefficient))
                .fold(0, |sum, term| field.add(sum, term));
            if hankel_value != 0 {
                continue;
            }
            let Some(magnitudes) = recover_magnitudes(&field, &syndrome, &support) else {
                continue;
            };
            let certificate = LocatorCertificate {
                schema: CERTIFICATE_SCHEMA.into(),
                field: request.field.clone(),
                redundancy: request.redundancy,
                normalized_syndrome: syndrome.clone(),
                distance: support.len(),
                locator,
                support,
                magnitudes,
                candidates_examined: examined,
            };
            verify_certificate(&certificate)?;
            return Ok(certificate);
        }
    }
    Err(Error::NoLocator(request.redundancy - 1))
}

pub fn search_exact_locator(
    request: &Request,
    candidate_limit: u64,
) -> Result<LocatorCertificate, Error> {
    match search_locator(request, request.redundancy - 2, candidate_limit) {
        Ok(certificate) => return Ok(certificate),
        Err(Error::NoLocator(_)) => {}
        Err(error) => return Err(error),
    }
    if (5..=7).contains(&request.redundancy) {
        match search_fast_terminal_locator(request, candidate_limit) {
            Ok(certificate) => return Ok(certificate),
            Err(Error::NoLocator(_)) => {}
            Err(error) => return Err(error),
        }
    }
    match search_locator(request, request.redundancy - 1, candidate_limit) {
        Ok(certificate) => return Ok(certificate),
        Err(Error::NoLocator(_)) => {}
        Err(error) => return Err(error),
    }
    let (field, syndrome) = validate_request(request)?;
    let support = (0..request.redundancy as u32)
        .map(Root::Finite)
        .collect::<Vec<_>>();
    let magnitudes =
        recover_magnitudes(&field, &syndrome, &support).ok_or(Error::BadSyndromeWitness)?;
    let locator = locator_from_support(&field, &support)?;
    let certificate = LocatorCertificate {
        schema: CERTIFICATE_SCHEMA.into(),
        field: request.field.clone(),
        redundancy: request.redundancy,
        normalized_syndrome: syndrome,
        distance: request.redundancy,
        locator,
        support,
        magnitudes,
        candidates_examined: 0,
    };
    verify_certificate(&certificate)?;
    Ok(certificate)
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

fn normalized_pgl_matrices(field: &Field) -> Vec<[u32; 4]> {
    let q = field.order();
    let capacity = u64::from(q).pow(3) - u64::from(q);
    let mut matrices = Vec::with_capacity(capacity as usize);
    for beta in 0..q {
        for gamma in 0..q {
            for delta in 0..q {
                if field.sub(delta, field.mul(beta, gamma)) != 0 {
                    matrices.push([1, beta, gamma, delta]);
                }
            }
        }
    }
    for gamma in 1..q {
        for delta in 0..q {
            matrices.push([0, 1, gamma, delta]);
        }
    }
    debug_assert_eq!(matrices.len() as u64, capacity);
    matrices
}

fn homogeneous_basis_gcd(
    field: &Field,
    basis: &[Vec<u32>],
    homogeneous_degree: usize,
) -> Option<(Vec<u32>, usize)> {
    let first = basis.first()?;
    let mut gcd = polynomial_trim(first.clone());
    let mut infinity_multiplicity = homogeneous_degree - polynomial_degree(first)?;
    for polynomial in &basis[1..] {
        infinity_multiplicity =
            infinity_multiplicity.min(homogeneous_degree - polynomial_degree(polynomial)?);
        gcd = polynomial_gcd(field, gcd, polynomial_trim(polynomial.clone()));
    }
    Some((gcd, infinity_multiplicity))
}

fn polynomial_degree(polynomial: &[u32]) -> Option<usize> {
    polynomial.iter().rposition(|&x| x != 0)
}

fn polynomial_trim(mut polynomial: Vec<u32>) -> Vec<u32> {
    while polynomial.last() == Some(&0) {
        polynomial.pop();
    }
    polynomial
}

fn polynomial_mul(field: &Field, a: &[u32], b: &[u32]) -> Vec<u32> {
    let mut out = vec![0u32; a.len() + b.len() - 1];
    for (i, &x) in a.iter().enumerate() {
        for (j, &y) in b.iter().enumerate() {
            out[i + j] = field.add(out[i + j], field.mul(x, y));
        }
    }
    out
}

fn polynomial_power(field: &Field, polynomial: &[u32], exponent: usize) -> Vec<u32> {
    let mut out = vec![1u32];
    for _ in 0..exponent {
        out = polynomial_mul(field, &out, polynomial);
    }
    out
}

fn polynomial_gcd(field: &Field, mut a: Vec<u32>, mut b: Vec<u32>) -> Vec<u32> {
    while !b.is_empty() {
        let remainder = polynomial_division_remainder(field, &a, &b);
        a = b;
        b = remainder;
    }
    if let Some(&lead) = a.last() {
        let inv = field.inv(lead).expect("nonzero leading coefficient");
        for x in &mut a {
            *x = field.mul(*x, inv);
        }
    }
    a
}

fn polynomial_division_remainder(field: &Field, dividend: &[u32], divisor: &[u32]) -> Vec<u32> {
    let mut out = polynomial_trim(dividend.to_vec());
    let divisor_degree = divisor.len() - 1;
    let divisor_lead_inverse = field
        .inv(divisor[divisor_degree])
        .expect("divisor leading coefficient is nonzero");
    while out.len() >= divisor.len() {
        let shift = out.len() - divisor.len();
        let factor = field.mul(*out.last().unwrap(), divisor_lead_inverse);
        for (j, &coefficient) in divisor.iter().enumerate() {
            out[shift + j] = field.sub(out[shift + j], field.mul(factor, coefficient));
        }
        out = polynomial_trim(out);
    }
    out
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

    #[test]
    fn persistent_r6_representatives_match_frozen_certificate() {
        let field = Field::new(prime_field(17)).unwrap();
        assert_eq!(
            persistent_kind(&field, &[0, 0, 0, 0, 1, 0]),
            PersistentKind::Tangent
        );
        assert_eq!(
            persistent_kind(&field, &[0, 1, 0, 3, 0, 9]),
            PersistentKind::Sigma
        );
    }

    #[test]
    fn fast_terminal_selector_covers_r6_and_r7_representatives() {
        for input in [
            request(prime_field(17), 6, vec![0, 0, 0, 0, 1, 0]),
            request(prime_field(17), 6, vec![0, 1, 0, 3, 0, 9]),
            request(prime_field(7), 7, vec![0, 0, 0, 0, 1, 0, 0]),
        ] {
            let certificate = search_fast_terminal_locator(&input, 10_000).unwrap();
            assert_eq!(certificate.distance, input.redundancy - 1);
            verify_certificate(&certificate).unwrap();
        }
    }

    #[test]
    fn fast_terminal_selector_exhausts_all_r5_q5_syndromes() {
        let field_spec = prime_field(5);
        let field = Field::new(field_spec.clone()).unwrap();
        let basis = (0..5)
            .map(|i| {
                let mut vector = vec![0; 5];
                vector[i] = 1;
                vector
            })
            .collect::<Vec<_>>();
        let mut examined = 0;
        let syndromes = projective_span(&field, &basis, 1_000, &mut examined).unwrap();
        assert_eq!(syndromes.len(), 781);
        for syndrome in syndromes {
            let input = request(field_spec.clone(), 5, syndrome);
            if matches!(search_locator(&input, 3, 1_000), Err(Error::NoLocator(3))) {
                let certificate = search_fast_terminal_locator(&input, 1_000).unwrap();
                assert_eq!(certificate.distance, 4);
                verify_certificate(&certificate).unwrap();
            }
        }
    }

    #[test]
    fn r5_tame_formula_adapter_covers_fields_above_registry() {
        let rational_field = Field::new(prime_field(53)).unwrap();
        assert_eq!(
            r5_tame_formula_family(&rational_field, &[0, 0, 1, 0, 0]),
            Some((
                "r5.osculating_rational",
                "r5.cyclic_jacobian_square:rational_ramification_pair:q_mod_3=2"
            ))
        );
        let result = classify(
            &request(prime_field(53), 5, vec![0, 0, 1, 0, 0]),
            10_000,
            200_000,
        )
        .unwrap();
        assert_eq!(result.status, VerdictStatus::Deep);
        let certificate = result.deep_certificate.unwrap();
        verify_deep_certificate(&certificate, 200_000).unwrap();
        assert!(matches!(
            certificate.family_evidence,
            DeepFamilyEvidence::Formula { .. }
        ));

        let conjugate_field = Field::new(prime_field(61)).unwrap();
        let norm = (1..61)
            .find(|&candidate| {
                (0..61).all(|x| conjugate_field.add(conjugate_field.mul(x, x), candidate) != 0)
            })
            .unwrap();
        let three = 3;
        let six = 6;
        let cubics = [
            vec![0, conjugate_field.neg(conjugate_field.mul(six, norm)), 0, 2],
            vec![norm, 0, conjugate_field.neg(three), 0],
        ];
        let equations = cubics
            .iter()
            .flat_map(|cubic| {
                [
                    vec![cubic[0], cubic[1], cubic[2], cubic[3], 0],
                    vec![0, cubic[0], cubic[1], cubic[2], cubic[3]],
                ]
            })
            .collect::<Vec<_>>();
        let syndrome = normalize_projective(
            &conjugate_field,
            nullspace(&conjugate_field, &equations, 5).first().unwrap(),
        )
        .unwrap();
        assert_eq!(
            r5_tame_formula_family(&conjugate_field, &syndrome).map(|(family, _)| family),
            Some("r5.osculating_conjugate")
        );
    }

    #[test]
    fn r5_characteristic_three_formula_adapter_replays_frozen_shapes() {
        let field = Field::new(FieldSpec {
            p: 3,
            degree: 2,
            modulus: vec![1, 0, 1],
            encoding: "polynomial-basis-base-p-integer-v1".into(),
        })
        .unwrap();
        assert_eq!(
            r5_char3_formula_family(&field, &[0, 0, 1, 0, 0]),
            Some(("r5.char3_nucleus", "r5.char3_cube_pencil:fixed_nucleus"))
        );
        assert_eq!(
            r5_char3_formula_family(&field, &[0, 0, 1, 0, 4]),
            Some((
                "r5.char3_wild",
                "r5.char3_additive_kernel:minus_linear_nonsquare"
            ))
        );
    }

    #[test]
    fn pgl_action_preserves_nrc_and_canonicalizes_equivalent_inputs() {
        let field_spec = prime_field(7);
        let field = Field::new(field_spec.clone()).unwrap();
        let point = (0..5).map(|i| field.pow(3, i)).collect::<Vec<_>>();
        let matrix = [1, 2, 0, 1];
        let (image, _) = apply_semilinear(&field, &point, 0, matrix).unwrap();
        let expected = (0..5).map(|i| field.pow(5, i)).collect::<Vec<_>>();
        assert_eq!(image, expected);

        let left = canonicalize_syndrome(&request(field_spec.clone(), 5, point), 1_000).unwrap();
        let right = canonicalize_syndrome(&request(field_spec, 5, image), 1_000).unwrap();
        assert_eq!(left.canonical_syndrome, right.canonical_syndrome);
        assert_eq!(left.transporters_examined, 336);
    }

    #[test]
    fn frozen_exception_registry_classifies_r5_wild() {
        let field_spec = FieldSpec {
            p: 3,
            degree: 2,
            modulus: vec![1, 0, 1],
            encoding: "polynomial-basis-base-p-integer-v1".into(),
        };
        let result =
            classify(&request(field_spec, 5, vec![0, 0, 1, 0, 4]), 10_000, 10_000).unwrap();
        assert_eq!(result.status, VerdictStatus::Deep);
        assert_eq!(result.distance, Some(4));
        assert_eq!(result.family.as_deref(), Some("r5.char3_wild"));
        let certificate = result.deep_certificate.as_ref().unwrap();
        verify_deep_certificate(certificate, 10_000).unwrap();
        let mut corrupted = certificate.clone();
        if let DeepFamilyEvidence::FrozenOrbit {
            semilinear_orbit_size,
            ..
        } = &mut corrupted.family_evidence
        {
            *semilinear_orbit_size += 1;
        }
        assert_eq!(
            verify_deep_certificate(&corrupted, 10_000),
            Err(Error::BadDeepCertificate)
        );
    }

    #[test]
    fn frozen_r7_radius_gap_is_unresolved() {
        let result = classify(
            &request(prime_field(7), 7, vec![0, 0, 0, 0, 1, 0, 0]),
            10_000,
            10_000,
        )
        .unwrap();
        assert_eq!(result.status, VerdictStatus::Unresolved);
        assert_eq!(result.distance, None);
        assert_eq!(result.family.as_deref(), Some("r7.sporadic"));
    }

    #[test]
    fn exact_decoder_returns_terminal_nearest_word_for_r5_tangent() {
        let input = request(prime_field(7), 5, vec![0, 0, 0, 1, 0]);
        let certificate = search_fast_terminal_locator(&input, 10_000).unwrap();
        assert_eq!(certificate.distance, 4);
        verify_certificate(&certificate).unwrap();

        let exact = search_exact_locator(&input, 10_000).unwrap();
        assert_eq!(exact.distance, 4);
        verify_certificate(&exact).unwrap();
    }

    #[test]
    fn rejects_geometric_carrier_outside_positive_dimension_code_range() {
        let error = validate_request(&request(prime_field(7), 9, vec![0, 0, 1, 0, 0, 0, 1, 0, 0]))
            .unwrap_err();
        assert_eq!(error, Error::BadCodeParameters);
    }

    #[test]
    fn certificate_verifier_rejects_corrupted_magnitude() {
        let mut certificate =
            search_exact_locator(&request(prime_field(7), 5, vec![0, 3, 5, 4, 1]), 10_000).unwrap();
        certificate.magnitudes[0] = 0;
        assert_eq!(verify_certificate(&certificate), Err(Error::BadMagnitude));
    }

    #[test]
    fn deep_certificate_verifier_rejects_corrupted_routes() {
        let result = classify(
            &request(prime_field(17), 6, vec![0, 0, 0, 0, 1, 0]),
            10_000,
            10_000,
        )
        .unwrap();
        let certificate = result.deep_certificate.unwrap();
        verify_deep_certificate(&certificate, 10_000).unwrap();

        let mut corrupted = certificate.clone();
        corrupted.radius_source.push_str("-corrupt");
        assert_eq!(
            verify_deep_certificate(&corrupted, 10_000),
            Err(Error::BadDeepCertificate)
        );

        let mut corrupted = certificate;
        corrupted.family = "r6.sporadic".into();
        assert_eq!(
            verify_deep_certificate(&corrupted, 10_000),
            Err(Error::BadDeepCertificate)
        );
    }
}
