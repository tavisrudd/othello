//! Resource-bounded verification of exact one-parameter certificate families.
//!
//! The verifier is deliberately characteristic-zero and producer-independent.
//! It checks flat polynomial-expression DAGs over `Z[t]`, coefficientwise
//! half-line positivity, finite congruence covers, streamed payload digests,
//! and an explicit composition DAG.  It does not search for families and does
//! not assign proof authority to domain-specific residual or scaling rules.

use std::io::Read;

use blake3::Hasher as Blake3Hasher;
use num_bigint::{BigInt, Sign};
use num_traits::{One, Zero};
use sha2::{Digest as _, Sha256};
use thiserror::Error;

pub const MAX_PARAMETRIC_FAMILIES: u32 = 100_000;
pub const MAX_PARAMETRIC_NODES_PER_FAMILY: u32 = 4_096;
pub const MAX_PARAMETRIC_TOTAL_NODES: u32 = 10_000_000;
pub const MAX_PARAMETRIC_DEGREE: u32 = 1_024;
pub const MAX_PARAMETRIC_COEFFICIENT_BITS: u32 = 65_536;
pub const MAX_PARAMETRIC_TOTAL_COEFFICIENTS: u64 = 128_000_000;
pub const MAX_PARAMETRIC_TOTAL_COEFFICIENT_BITS: u64 = 64_000_000_000;
pub const MAX_PARAMETRIC_ALGEBRA_WORK: u64 = 1_000_000_000;
pub const MAX_PARAMETRIC_COVER_MODULUS: u32 = 4_000_000;
pub const MAX_PARAMETRIC_COVER_MARKS: u64 = 1_000_000_000;
pub const MAX_PARAMETRIC_PAYLOADS: u32 = 4_096;
pub const MAX_PARAMETRIC_PAYLOAD_BYTES: u64 = 1 << 40;
pub const MAX_PARAMETRIC_TOTAL_PAYLOAD_BYTES: u64 = 1 << 40;
pub const MAX_PARAMETRIC_COMPOSITION_NODES: u32 = 1_000_000;

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ParametricVerificationLimits {
    pub max_payload_bytes: u64,
    pub max_total_payload_bytes: u64,
    pub max_total_coefficients: u64,
    pub max_total_coefficient_bits: u64,
    pub max_algebra_work: u64,
    pub max_cover_marks: u64,
    pub max_parameter: u64,
    pub max_families: u32,
    pub max_nodes_per_family: u32,
    pub max_total_nodes: u32,
    pub max_degree: u32,
    pub max_coefficient_bits: u32,
    pub max_cover_modulus: u32,
    pub max_payloads: u32,
    pub max_composition_nodes: u32,
    pub max_name_bytes: u32,
    pub max_evaluation_bits: u32,
}

const _: () = assert!(std::mem::size_of::<ParametricVerificationLimits>() == 96);
const _: () = assert!(std::mem::align_of::<ParametricVerificationLimits>() == 8);

impl Default for ParametricVerificationLimits {
    fn default() -> Self {
        Self {
            max_payload_bytes: 1 << 30,
            max_total_payload_bytes: 1 << 30,
            max_total_coefficients: 2_000_000,
            max_total_coefficient_bits: 1_000_000_000,
            max_algebra_work: 64_000_000,
            max_cover_marks: 64_000_000,
            max_parameter: u64::MAX,
            max_families: 10_000,
            max_nodes_per_family: 512,
            max_total_nodes: 200_000,
            max_degree: 128,
            max_coefficient_bits: 8_192,
            max_cover_modulus: 1_000_000,
            max_payloads: 256,
            max_composition_nodes: 100_000,
            max_name_bytes: 256,
            max_evaluation_bits: 65_536,
        }
    }
}

impl ParametricVerificationLimits {
    fn validate(self) -> Result<(), ParametricCertificateError> {
        if self.max_families == 0
            || self.max_families > MAX_PARAMETRIC_FAMILIES
            || self.max_nodes_per_family == 0
            || self.max_nodes_per_family > MAX_PARAMETRIC_NODES_PER_FAMILY
            || self.max_total_nodes == 0
            || self.max_total_nodes > MAX_PARAMETRIC_TOTAL_NODES
            || self.max_degree > MAX_PARAMETRIC_DEGREE
            || self.max_coefficient_bits == 0
            || self.max_coefficient_bits > MAX_PARAMETRIC_COEFFICIENT_BITS
            || self.max_total_coefficients == 0
            || self.max_total_coefficients > MAX_PARAMETRIC_TOTAL_COEFFICIENTS
            || self.max_total_coefficient_bits == 0
            || self.max_total_coefficient_bits > MAX_PARAMETRIC_TOTAL_COEFFICIENT_BITS
            || self.max_algebra_work == 0
            || self.max_algebra_work > MAX_PARAMETRIC_ALGEBRA_WORK
            || self.max_cover_modulus == 0
            || self.max_cover_modulus > MAX_PARAMETRIC_COVER_MODULUS
            || self.max_cover_marks == 0
            || self.max_cover_marks > MAX_PARAMETRIC_COVER_MARKS
            || self.max_payloads > MAX_PARAMETRIC_PAYLOADS
            || self.max_payload_bytes > MAX_PARAMETRIC_PAYLOAD_BYTES
            || self.max_total_payload_bytes > MAX_PARAMETRIC_TOTAL_PAYLOAD_BYTES
            || self.max_payload_bytes > self.max_total_payload_bytes
            || self.max_composition_nodes == 0
            || self.max_composition_nodes > MAX_PARAMETRIC_COMPOSITION_NODES
            || self.max_name_bytes == 0
            || self.max_name_bytes > 4_096
            || self.max_evaluation_bits == 0
            || self.max_evaluation_bits > MAX_PARAMETRIC_COEFFICIENT_BITS
        {
            return Err(ParametricCertificateError::InvalidLimits);
        }
        Ok(())
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum PolynomialOp {
    /// Canonical low-to-high coefficients; zero is encoded as exactly `[0]`.
    Literal(Box<[BigInt]>),
    Add {
        left: u32,
        right: u32,
    },
    Subtract {
        left: u32,
        right: u32,
    },
    Multiply {
        left: u32,
        right: u32,
    },
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct PolynomialProgram {
    pub nodes: Box<[PolynomialOp]>,
    pub class_node: u32,
    pub identity_roots: Box<[u32]>,
    pub positive_roots: Box<[u32]>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ParametricFamily {
    pub name: Box<str>,
    pub modulus: u32,
    pub residue: u32,
    pub parameter_minimum: u64,
    pub program: PolynomialProgram,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ParametricCover {
    pub claim_minimum: u64,
    pub modulus: u32,
    pub exceptional_residues: Box<[u32]>,
    pub families: Box<[ParametricFamily]>,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum PayloadDigestAlgorithm {
    Blake3,
    Sha256,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct PayloadDigest {
    pub name: Box<str>,
    pub algorithm: PayloadDigestAlgorithm,
    pub byte_length: u64,
    pub digest: [u8; 32],
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum ParametricCompositionNode {
    Family { family: u32 },
    FiniteCover { premises: Box<[u32]> },
    Payload { payload: u32 },
    All { premises: Box<[u32]> },
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ParametricCompositionDag {
    pub nodes: Box<[ParametricCompositionNode]>,
    pub root: u32,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ParametricCertificate {
    pub cover: ParametricCover,
    pub payloads: Box<[PayloadDigest]>,
    pub composition: ParametricCompositionDag,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct VerifiedParametricCertificate {
    pub claim_minimum: u64,
    pub cover_modulus: u32,
    pub exceptional_residues: Box<[u32]>,
    pub family_count: u32,
    pub payload_count: u32,
    pub composition_nodes: u32,
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum ParametricCertificateError {
    #[error("verification limits are empty, reserved, or exceed hard bounds")]
    InvalidLimits,
    #[error("certificate exceeds a declared resource bound")]
    ResourceLimit,
    #[error("a certificate name is empty, too long, or duplicated")]
    InvalidName,
    #[error("polynomial coefficients are empty or not canonically trimmed")]
    NonCanonicalPolynomial,
    #[error("a polynomial expression references a non-previous node")]
    InvalidPolynomialEdge,
    #[error("a polynomial exceeds the degree or coefficient-size bound")]
    PolynomialLimit,
    #[error("the declared class polynomial is not modulus*t + residue")]
    ClassPolynomialMismatch,
    #[error("an identity root does not depend on the declared class polynomial")]
    DetachedClassPolynomial,
    #[error("an asserted polynomial identity is nonzero")]
    IdentityFailure,
    #[error(
        "a positivity root is not coefficientwise nonnegative or is below one at the threshold"
    )]
    PositivityFailure,
    #[error("a family class, threshold, or cover modulus is invalid")]
    InvalidClass,
    #[error("exceptional residues or node lists are not sorted and unique")]
    NonCanonicalList,
    #[error("the finite congruence cover leaves an undeclared residue uncovered")]
    IncompleteCover,
    #[error("payload metadata or reader count is invalid")]
    InvalidPayload,
    #[error("payload reading failed")]
    PayloadRead,
    #[error("payload length or digest does not match its declaration")]
    PayloadMismatch,
    #[error("the composition DAG has an invalid edge or typed premise")]
    InvalidComposition,
    #[error(
        "the composition root does not reach every declared node exactly through a supported rule"
    )]
    IncompleteComposition,
}

#[derive(Default)]
struct VerificationBudget {
    polynomial_nodes: u64,
    coefficients: u64,
    coefficient_bits: u64,
    algebra_work: u64,
}

impl VerificationBudget {
    fn charge_node(
        &mut self,
        coefficients: usize,
        coefficient_bits: u64,
        work: usize,
        limits: ParametricVerificationLimits,
    ) -> Result<(), ParametricCertificateError> {
        self.polynomial_nodes = self
            .polynomial_nodes
            .checked_add(1)
            .ok_or(ParametricCertificateError::ResourceLimit)?;
        self.coefficients = self
            .coefficients
            .checked_add(coefficients as u64)
            .ok_or(ParametricCertificateError::ResourceLimit)?;
        self.coefficient_bits = self
            .coefficient_bits
            .checked_add(coefficient_bits)
            .ok_or(ParametricCertificateError::ResourceLimit)?;
        self.algebra_work = self
            .algebra_work
            .checked_add(work as u64)
            .ok_or(ParametricCertificateError::ResourceLimit)?;
        if self.polynomial_nodes > u64::from(limits.max_total_nodes)
            || self.coefficients > limits.max_total_coefficients
            || self.coefficient_bits > limits.max_total_coefficient_bits
            || self.algebra_work > limits.max_algebra_work
        {
            return Err(ParametricCertificateError::ResourceLimit);
        }
        Ok(())
    }
}

pub fn verify_parametric_certificate(
    certificate: &ParametricCertificate,
    limits: ParametricVerificationLimits,
    payload_readers: &mut [&mut dyn Read],
) -> Result<VerifiedParametricCertificate, ParametricCertificateError> {
    limits.validate()?;
    check_count(certificate.cover.families.len(), limits.max_families)?;
    check_count(certificate.payloads.len(), limits.max_payloads)?;
    check_count(
        certificate.composition.nodes.len(),
        limits.max_composition_nodes,
    )?;
    let total_payload_bytes = certificate
        .payloads
        .iter()
        .try_fold(0_u64, |total, payload| {
            total.checked_add(payload.byte_length)
        });
    if total_payload_bytes.is_none_or(|total| total > limits.max_total_payload_bytes) {
        return Err(ParametricCertificateError::ResourceLimit);
    }
    if payload_readers.len() != certificate.payloads.len() {
        return Err(ParametricCertificateError::InvalidPayload);
    }
    verify_unique_names(
        certificate
            .cover
            .families
            .iter()
            .map(|family| family.name.as_ref()),
        limits.max_name_bytes,
    )?;
    verify_unique_names(
        certificate
            .payloads
            .iter()
            .map(|payload| payload.name.as_ref()),
        limits.max_name_bytes,
    )?;
    if certificate
        .payloads
        .iter()
        .any(|payload| payload.byte_length > limits.max_payload_bytes)
    {
        return Err(ParametricCertificateError::InvalidPayload);
    }
    let mut budget = VerificationBudget::default();
    for family in &certificate.cover.families {
        verify_family(family, limits, &mut budget)?;
    }
    verify_composition(certificate, limits)?;
    for (payload, reader) in certificate.payloads.iter().zip(payload_readers.iter_mut()) {
        verify_payload(payload, limits, *reader)?;
    }
    Ok(VerifiedParametricCertificate {
        claim_minimum: certificate.cover.claim_minimum,
        cover_modulus: certificate.cover.modulus,
        exceptional_residues: certificate.cover.exceptional_residues.clone(),
        family_count: certificate.cover.families.len() as u32,
        payload_count: certificate.payloads.len() as u32,
        composition_nodes: certificate.composition.nodes.len() as u32,
    })
}

pub fn verify_payload(
    payload: &PayloadDigest,
    limits: ParametricVerificationLimits,
    reader: &mut dyn Read,
) -> Result<(), ParametricCertificateError> {
    limits.validate()?;
    if payload.name.is_empty()
        || payload.name.len() > limits.max_name_bytes as usize
        || payload.byte_length > limits.max_payload_bytes
    {
        return Err(ParametricCertificateError::InvalidPayload);
    }
    let mut buffer = [0_u8; 64 * 1024];
    let mut remaining = payload.byte_length;
    let mut blake3 = Blake3Hasher::new();
    let mut sha256 = Sha256::new();
    while remaining != 0 {
        let wanted =
            usize::try_from(remaining.min(buffer.len() as u64)).expect("buffer length fits usize");
        let read = reader
            .read(&mut buffer[..wanted])
            .map_err(|_| ParametricCertificateError::PayloadRead)?;
        if read == 0 {
            return Err(ParametricCertificateError::PayloadMismatch);
        }
        match payload.algorithm {
            PayloadDigestAlgorithm::Blake3 => {
                blake3.update(&buffer[..read]);
            }
            PayloadDigestAlgorithm::Sha256 => {
                sha256.update(&buffer[..read]);
            }
        }
        remaining -= read as u64;
    }
    let trailing = reader
        .read(&mut buffer[..1])
        .map_err(|_| ParametricCertificateError::PayloadRead)?;
    if trailing != 0 {
        return Err(ParametricCertificateError::PayloadMismatch);
    }
    let actual = match payload.algorithm {
        PayloadDigestAlgorithm::Blake3 => *blake3.finalize().as_bytes(),
        PayloadDigestAlgorithm::Sha256 => sha256.finalize().into(),
    };
    if actual != payload.digest {
        return Err(ParametricCertificateError::PayloadMismatch);
    }
    Ok(())
}

fn verify_family(
    family: &ParametricFamily,
    limits: ParametricVerificationLimits,
    budget: &mut VerificationBudget,
) -> Result<(), ParametricCertificateError> {
    if family.modulus == 0
        || family.residue >= family.modulus
        || family.parameter_minimum > limits.max_parameter
    {
        return Err(ParametricCertificateError::InvalidClass);
    }
    let program = &family.program;
    check_count(program.nodes.len(), limits.max_nodes_per_family)?;
    if program.nodes.is_empty()
        || program.class_node as usize >= program.nodes.len()
        || program.identity_roots.is_empty()
        || program.positive_roots.is_empty()
        || !sorted_unique(&program.identity_roots)
        || !sorted_unique(&program.positive_roots)
    {
        return Err(ParametricCertificateError::NonCanonicalList);
    }
    let mut values: Vec<Box<[BigInt]>> = Vec::with_capacity(program.nodes.len());
    let mut depends_on_class = Vec::with_capacity(program.nodes.len());
    for (node_index, node) in program.nodes.iter().enumerate() {
        let (coefficient_count, coefficient_bits, work) =
            projected_node_cost(&values, node_index, node)?;
        budget.charge_node(coefficient_count, coefficient_bits, work, limits)?;
        let dependency = node_index == program.class_node as usize
            || match node {
                PolynomialOp::Literal(_) => false,
                PolynomialOp::Add { left, right }
                | PolynomialOp::Subtract { left, right }
                | PolynomialOp::Multiply { left, right } => {
                    depends_on_class[*left as usize] || depends_on_class[*right as usize]
                }
            };
        let value = match node {
            PolynomialOp::Literal(coefficients) => {
                validate_literal(coefficients, limits)?;
                coefficients.clone()
            }
            PolynomialOp::Add { left, right } => {
                let (left, right) = previous_pair(&values, node_index, *left, *right)?;
                polynomial_add(left, right, false)
            }
            PolynomialOp::Subtract { left, right } => {
                let (left, right) = previous_pair(&values, node_index, *left, *right)?;
                polynomial_add(left, right, true)
            }
            PolynomialOp::Multiply { left, right } => {
                let (left, right) = previous_pair(&values, node_index, *left, *right)?;
                if left.len() + right.len() - 2 > limits.max_degree as usize {
                    return Err(ParametricCertificateError::PolynomialLimit);
                }
                polynomial_multiply(left, right)
            }
        };
        validate_computed(&value, limits)?;
        values.push(value);
        depends_on_class.push(dependency);
    }
    let class = &values[program.class_node as usize];
    let expected = [BigInt::from(family.residue), BigInt::from(family.modulus)];
    if class.as_ref() != expected {
        return Err(ParametricCertificateError::ClassPolynomialMismatch);
    }
    for &root in &program.identity_roots {
        let root = root as usize;
        if root >= values.len() {
            return Err(ParametricCertificateError::InvalidPolynomialEdge);
        }
        if !depends_on_class[root] {
            return Err(ParametricCertificateError::DetachedClassPolynomial);
        }
        if values[root].len() != 1 || !values[root][0].is_zero() {
            return Err(ParametricCertificateError::IdentityFailure);
        }
    }
    for &root in &program.positive_roots {
        let polynomial = values
            .get(root as usize)
            .ok_or(ParametricCertificateError::InvalidPolynomialEdge)?;
        if polynomial
            .iter()
            .any(|coefficient| coefficient.sign() == Sign::Minus)
            || evaluate_positive(polynomial, family.parameter_minimum, limits)?.is_zero()
        {
            return Err(ParametricCertificateError::PositivityFailure);
        }
    }
    Ok(())
}

fn verify_composition(
    certificate: &ParametricCertificate,
    limits: ParametricVerificationLimits,
) -> Result<(), ParametricCertificateError> {
    let dag = &certificate.composition;
    if dag.nodes.is_empty() || dag.root as usize >= dag.nodes.len() {
        return Err(ParametricCertificateError::InvalidComposition);
    }
    let mut cover_nodes = 0_u32;
    let mut family_leaves = vec![0_u8; certificate.cover.families.len()];
    let mut payload_leaves = vec![0_u8; certificate.payloads.len()];
    for (index, node) in dag.nodes.iter().enumerate() {
        match node {
            ParametricCompositionNode::Family { family } => {
                let Some(count) = family_leaves.get_mut(*family as usize) else {
                    return Err(ParametricCertificateError::InvalidComposition);
                };
                *count = count
                    .checked_add(1)
                    .ok_or(ParametricCertificateError::InvalidComposition)?;
            }
            ParametricCompositionNode::Payload { payload } => {
                let Some(count) = payload_leaves.get_mut(*payload as usize) else {
                    return Err(ParametricCertificateError::InvalidComposition);
                };
                *count = count
                    .checked_add(1)
                    .ok_or(ParametricCertificateError::InvalidComposition)?;
            }
            ParametricCompositionNode::FiniteCover { premises } => {
                cover_nodes += 1;
                let family_indices = family_premises(&dag.nodes, index, premises)?;
                if family_indices.len() != certificate.cover.families.len()
                    || family_indices
                        .iter()
                        .enumerate()
                        .any(|(expected, &actual)| actual as usize != expected)
                {
                    return Err(ParametricCertificateError::InvalidComposition);
                }
                verify_cover(&certificate.cover, &family_indices, limits)?;
            }
            ParametricCompositionNode::All { premises } => {
                validate_previous_list(index, premises)?;
            }
        }
    }
    if cover_nodes != 1
        || family_leaves.iter().any(|&count| count != 1)
        || payload_leaves.iter().any(|&count| count != 1)
    {
        return Err(ParametricCertificateError::InvalidComposition);
    }
    let mut reached = vec![false; dag.nodes.len()];
    let mut stack = Vec::with_capacity(dag.nodes.len());
    stack.push(dag.root as usize);
    while let Some(node) = stack.pop() {
        if reached[node] {
            continue;
        }
        reached[node] = true;
        match &dag.nodes[node] {
            ParametricCompositionNode::Family { .. }
            | ParametricCompositionNode::Payload { .. } => {}
            ParametricCompositionNode::FiniteCover { premises }
            | ParametricCompositionNode::All { premises } => {
                stack.extend(premises.iter().map(|&premise| premise as usize));
            }
        }
    }
    if reached.iter().any(|reached| !reached) {
        return Err(ParametricCertificateError::IncompleteComposition);
    }
    Ok(())
}

fn verify_cover(
    cover: &ParametricCover,
    family_indices: &[u32],
    limits: ParametricVerificationLimits,
) -> Result<(), ParametricCertificateError> {
    if cover.modulus == 0
        || cover.modulus > limits.max_cover_modulus
        || cover.claim_minimum > limits.max_parameter
        || !sorted_unique(&cover.exceptional_residues)
        || cover
            .exceptional_residues
            .last()
            .is_some_and(|&residue| residue >= cover.modulus)
    {
        return Err(ParametricCertificateError::InvalidClass);
    }
    let mut cover_marks = u64::from(cover.modulus);
    if cover_marks > limits.max_cover_marks {
        return Err(ParametricCertificateError::ResourceLimit);
    }
    for &family_index in family_indices {
        let family = &cover.families[family_index as usize];
        if !cover.modulus.is_multiple_of(family.modulus) {
            return Err(ParametricCertificateError::InvalidClass);
        }
        cover_marks = cover_marks
            .checked_add(u64::from(cover.modulus / family.modulus))
            .ok_or(ParametricCertificateError::ResourceLimit)?;
        if cover_marks > limits.max_cover_marks {
            return Err(ParametricCertificateError::ResourceLimit);
        }
    }
    let mut covered = vec![false; cover.modulus as usize];
    for &family_index in family_indices {
        let family = &cover.families[family_index as usize];
        for residue in (family.residue..cover.modulus).step_by(family.modulus as usize) {
            let least = least_congruent_at_least(cover.claim_minimum, residue, cover.modulus);
            let parameter = (least - u128::from(family.residue)) / u128::from(family.modulus);
            if parameter >= u128::from(family.parameter_minimum) {
                covered[residue as usize] = true;
            }
        }
    }
    for (residue, is_covered) in covered.into_iter().enumerate() {
        let is_exceptional = cover
            .exceptional_residues
            .binary_search(&(residue as u32))
            .is_ok();
        if is_covered && is_exceptional {
            return Err(ParametricCertificateError::InvalidClass);
        }
        if !is_covered && !is_exceptional {
            return Err(ParametricCertificateError::IncompleteCover);
        }
    }
    Ok(())
}

fn family_premises(
    nodes: &[ParametricCompositionNode],
    current: usize,
    premises: &[u32],
) -> Result<Box<[u32]>, ParametricCertificateError> {
    validate_previous_list(current, premises)?;
    let mut families = Vec::with_capacity(premises.len());
    for &premise in premises {
        match nodes[premise as usize] {
            ParametricCompositionNode::Family { family } => families.push(family),
            _ => return Err(ParametricCertificateError::InvalidComposition),
        }
    }
    families.sort_unstable();
    if !sorted_unique(&families) {
        return Err(ParametricCertificateError::NonCanonicalList);
    }
    Ok(families.into_boxed_slice())
}

fn validate_previous_list(
    current: usize,
    premises: &[u32],
) -> Result<(), ParametricCertificateError> {
    if premises.is_empty()
        || !sorted_unique(premises)
        || premises.iter().any(|&premise| premise as usize >= current)
    {
        return Err(ParametricCertificateError::InvalidComposition);
    }
    Ok(())
}

fn previous_pair(
    values: &[Box<[BigInt]>],
    current: usize,
    left: u32,
    right: u32,
) -> Result<(&[BigInt], &[BigInt]), ParametricCertificateError> {
    if left as usize >= current || right as usize >= current {
        return Err(ParametricCertificateError::InvalidPolynomialEdge);
    }
    Ok((&values[left as usize], &values[right as usize]))
}

fn projected_node_cost(
    values: &[Box<[BigInt]>],
    current: usize,
    node: &PolynomialOp,
) -> Result<(usize, u64, usize), ParametricCertificateError> {
    match node {
        PolynomialOp::Literal(coefficients) => Ok((
            coefficients.len(),
            total_coefficient_bits(coefficients)?,
            coefficients.len(),
        )),
        PolynomialOp::Add { left, right } | PolynomialOp::Subtract { left, right } => {
            let (left, right) = previous_pair(values, current, *left, *right)?;
            let coefficients = left.len().max(right.len());
            let bits_per_coefficient = max_coefficient_bits(left)
                .max(max_coefficient_bits(right))
                .checked_add(1)
                .ok_or(ParametricCertificateError::ResourceLimit)?;
            let coefficient_bits = bits_per_coefficient
                .checked_mul(coefficients as u64)
                .ok_or(ParametricCertificateError::ResourceLimit)?;
            Ok((coefficients, coefficient_bits, coefficients))
        }
        PolynomialOp::Multiply { left, right } => {
            let (left, right) = previous_pair(values, current, *left, *right)?;
            let coefficients = left
                .len()
                .checked_add(right.len())
                .and_then(|sum| sum.checked_sub(1))
                .ok_or(ParametricCertificateError::ResourceLimit)?;
            let work = left
                .len()
                .checked_mul(right.len())
                .ok_or(ParametricCertificateError::ResourceLimit)?;
            let accumulation_bits =
                u64::from(usize::BITS - left.len().min(right.len()).leading_zeros());
            let bits_per_coefficient = max_coefficient_bits(left)
                .checked_add(max_coefficient_bits(right))
                .and_then(|bits| bits.checked_add(accumulation_bits))
                .ok_or(ParametricCertificateError::ResourceLimit)?;
            let coefficient_bits = bits_per_coefficient
                .checked_mul(coefficients as u64)
                .ok_or(ParametricCertificateError::ResourceLimit)?;
            Ok((coefficients, coefficient_bits, work))
        }
    }
}

fn max_coefficient_bits(coefficients: &[BigInt]) -> u64 {
    coefficients.iter().map(BigInt::bits).max().unwrap_or(0)
}

fn total_coefficient_bits(coefficients: &[BigInt]) -> Result<u64, ParametricCertificateError> {
    coefficients.iter().try_fold(0_u64, |total, coefficient| {
        total
            .checked_add(coefficient.bits())
            .ok_or(ParametricCertificateError::ResourceLimit)
    })
}

fn polynomial_add(left: &[BigInt], right: &[BigInt], subtract: bool) -> Box<[BigInt]> {
    let mut result = vec![BigInt::zero(); left.len().max(right.len())];
    for (slot, coefficient) in result.iter_mut().zip(left) {
        *slot += coefficient;
    }
    for (slot, coefficient) in result.iter_mut().zip(right) {
        if subtract {
            *slot -= coefficient;
        } else {
            *slot += coefficient;
        }
    }
    canonicalize(result)
}

fn polynomial_multiply(left: &[BigInt], right: &[BigInt]) -> Box<[BigInt]> {
    let mut result = vec![BigInt::zero(); left.len() + right.len() - 1];
    for (left_index, left_coefficient) in left.iter().enumerate() {
        for (right_index, right_coefficient) in right.iter().enumerate() {
            result[left_index + right_index] += left_coefficient * right_coefficient;
        }
    }
    canonicalize(result)
}

fn canonicalize(mut coefficients: Vec<BigInt>) -> Box<[BigInt]> {
    while coefficients.len() > 1 && coefficients.last().is_some_and(Zero::is_zero) {
        coefficients.pop();
    }
    coefficients.into_boxed_slice()
}

fn validate_literal(
    coefficients: &[BigInt],
    limits: ParametricVerificationLimits,
) -> Result<(), ParametricCertificateError> {
    if coefficients.is_empty()
        || (coefficients.len() > 1 && coefficients.last().is_some_and(Zero::is_zero))
    {
        return Err(ParametricCertificateError::NonCanonicalPolynomial);
    }
    validate_computed(coefficients, limits)
}

fn validate_computed(
    coefficients: &[BigInt],
    limits: ParametricVerificationLimits,
) -> Result<(), ParametricCertificateError> {
    if coefficients.len() - 1 > limits.max_degree as usize
        || coefficients
            .iter()
            .any(|coefficient| coefficient.bits() > u64::from(limits.max_coefficient_bits))
    {
        return Err(ParametricCertificateError::PolynomialLimit);
    }
    Ok(())
}

fn evaluate_positive(
    polynomial: &[BigInt],
    parameter: u64,
    limits: ParametricVerificationLimits,
) -> Result<BigInt, ParametricCertificateError> {
    let parameter = BigInt::from(parameter);
    let mut value = BigInt::zero();
    for coefficient in polynomial.iter().rev() {
        value = value * &parameter + coefficient;
        if value.bits() > u64::from(limits.max_evaluation_bits) {
            return Err(ParametricCertificateError::PolynomialLimit);
        }
    }
    if value.sign() == Sign::Minus || value < BigInt::one() {
        return Err(ParametricCertificateError::PositivityFailure);
    }
    Ok(value)
}

fn verify_unique_names<'a>(
    names: impl Iterator<Item = &'a str>,
    max_name_bytes: u32,
) -> Result<(), ParametricCertificateError> {
    let mut names = names.collect::<Vec<_>>();
    if names
        .iter()
        .any(|name| name.is_empty() || name.len() > max_name_bytes as usize)
    {
        return Err(ParametricCertificateError::InvalidName);
    }
    names.sort_unstable();
    if names.windows(2).any(|window| window[0] == window[1]) {
        return Err(ParametricCertificateError::InvalidName);
    }
    Ok(())
}

fn check_count(count: usize, limit: u32) -> Result<(), ParametricCertificateError> {
    if count > limit as usize || count > u32::MAX as usize {
        return Err(ParametricCertificateError::ResourceLimit);
    }
    Ok(())
}

fn sorted_unique<T: Ord>(values: &[T]) -> bool {
    values.windows(2).all(|window| window[0] < window[1])
}

fn least_congruent_at_least(minimum: u64, residue: u32, modulus: u32) -> u128 {
    let minimum = u128::from(minimum);
    let modulus = u128::from(modulus);
    let residue = u128::from(residue);
    if minimum <= residue {
        return residue;
    }
    let delta = minimum - residue;
    let steps = delta.div_ceil(modulus);
    residue + steps * modulus
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::io::Cursor;

    fn literal(values: &[i64]) -> PolynomialOp {
        PolynomialOp::Literal(
            values
                .iter()
                .copied()
                .map(BigInt::from)
                .collect::<Vec<_>>()
                .into_boxed_slice(),
        )
    }

    fn even_family() -> ParametricFamily {
        // n=2t, A=t, B=2t, C=2t and n(BC+AC+AB)-4ABC=0.
        ParametricFamily {
            name: "even".into(),
            modulus: 2,
            residue: 0,
            parameter_minimum: 1,
            program: PolynomialProgram {
                nodes: vec![
                    literal(&[0, 2]),                              // 0 n
                    literal(&[0, 1]),                              // 1 A
                    literal(&[0, 2]),                              // 2 B
                    literal(&[0, 2]),                              // 3 C
                    PolynomialOp::Multiply { left: 2, right: 3 },  // 4 BC
                    PolynomialOp::Multiply { left: 1, right: 3 },  // 5 AC
                    PolynomialOp::Add { left: 4, right: 5 },       // 6
                    PolynomialOp::Multiply { left: 1, right: 2 },  // 7 AB
                    PolynomialOp::Add { left: 6, right: 7 },       // 8
                    PolynomialOp::Multiply { left: 0, right: 8 },  // 9 n sum
                    PolynomialOp::Multiply { left: 1, right: 2 },  // 10 AB
                    PolynomialOp::Multiply { left: 10, right: 3 }, // 11 ABC
                    literal(&[4]),                                 // 12
                    PolynomialOp::Multiply {
                        left: 12,
                        right: 11,
                    },
                    PolynomialOp::Subtract { left: 9, right: 13 }, // 14
                ]
                .into_boxed_slice(),
                class_node: 0,
                identity_roots: vec![14].into_boxed_slice(),
                positive_roots: vec![1, 2, 3].into_boxed_slice(),
            },
        }
    }

    fn certificate(payload_bytes: &[u8]) -> ParametricCertificate {
        let payload = PayloadDigest {
            name: "residual".into(),
            algorithm: PayloadDigestAlgorithm::Blake3,
            byte_length: payload_bytes.len() as u64,
            digest: *blake3::hash(payload_bytes).as_bytes(),
        };
        ParametricCertificate {
            cover: ParametricCover {
                claim_minimum: 2,
                modulus: 2,
                exceptional_residues: vec![1].into_boxed_slice(),
                families: vec![even_family()].into_boxed_slice(),
            },
            payloads: vec![payload].into_boxed_slice(),
            composition: ParametricCompositionDag {
                nodes: vec![
                    ParametricCompositionNode::Family { family: 0 },
                    ParametricCompositionNode::FiniteCover {
                        premises: vec![0].into_boxed_slice(),
                    },
                    ParametricCompositionNode::Payload { payload: 0 },
                    ParametricCompositionNode::All {
                        premises: vec![1, 2].into_boxed_slice(),
                    },
                ]
                .into_boxed_slice(),
                root: 3,
            },
        }
    }

    fn verify(
        certificate: &ParametricCertificate,
        payload: &[u8],
    ) -> Result<VerifiedParametricCertificate, ParametricCertificateError> {
        let mut cursor = Cursor::new(payload);
        let mut readers: [&mut dyn Read; 1] = [&mut cursor];
        verify_parametric_certificate(
            certificate,
            ParametricVerificationLimits::default(),
            &mut readers,
        )
    }

    #[test]
    fn exact_family_cover_payload_and_composition_verify() {
        let bytes = b"bounded residual evidence";
        let verified = verify(&certificate(bytes), bytes).unwrap();
        assert_eq!(verified.claim_minimum, 2);
        assert_eq!(verified.cover_modulus, 2);
        assert_eq!(&*verified.exceptional_residues, &[1]);
        assert_eq!(verified.family_count, 1);
        assert_eq!(verified.payload_count, 1);
        assert_eq!(verified.composition_nodes, 4);
    }

    #[test]
    fn identity_class_positivity_cover_and_payload_mutants_fail_closed() {
        let bytes = b"bounded residual evidence";

        let mut broken = certificate(bytes);
        broken.cover.families[0].program.nodes[12] = literal(&[5]);
        assert_eq!(
            verify(&broken, bytes),
            Err(ParametricCertificateError::IdentityFailure)
        );

        let mut broken = certificate(bytes);
        broken.cover.families[0].modulus = 1;
        assert_eq!(
            verify(&broken, bytes),
            Err(ParametricCertificateError::ClassPolynomialMismatch)
        );

        let mut broken = certificate(bytes);
        broken.cover.families[0].program.nodes[1] = literal(&[0, -1]);
        assert_eq!(
            verify(&broken, bytes),
            Err(ParametricCertificateError::IdentityFailure)
        );

        let mut broken = certificate(bytes);
        broken.cover.exceptional_residues = Box::new([]);
        assert_eq!(
            verify(&broken, bytes),
            Err(ParametricCertificateError::IncompleteCover)
        );

        let mut broken = certificate(bytes);
        broken.cover.exceptional_residues = vec![0, 1].into_boxed_slice();
        assert_eq!(
            verify(&broken, bytes),
            Err(ParametricCertificateError::InvalidClass)
        );

        assert_eq!(
            verify(&certificate(bytes), b"tampered residual evidence"),
            Err(ParametricCertificateError::PayloadMismatch)
        );
    }

    #[test]
    fn topology_canonicality_and_resource_limits_fail_closed() {
        let bytes = b"bounded residual evidence";
        let mut broken = certificate(bytes);
        broken.composition.nodes[3] = ParametricCompositionNode::All {
            premises: vec![1].into_boxed_slice(),
        };
        assert_eq!(
            verify(&broken, bytes),
            Err(ParametricCertificateError::IncompleteComposition)
        );

        let mut broken = certificate(bytes);
        broken.cover.families[0].program.nodes[4] = PolynomialOp::Multiply { left: 4, right: 3 };
        assert_eq!(
            verify(&broken, bytes),
            Err(ParametricCertificateError::InvalidPolynomialEdge)
        );

        let limits = ParametricVerificationLimits {
            max_nodes_per_family: 4,
            ..ParametricVerificationLimits::default()
        };
        let mut cursor = Cursor::new(bytes);
        let mut readers: [&mut dyn Read; 1] = [&mut cursor];
        assert_eq!(
            verify_parametric_certificate(&certificate(bytes), limits, &mut readers),
            Err(ParametricCertificateError::ResourceLimit)
        );
    }

    #[test]
    fn payload_verification_is_streamed_and_rejects_trailing_bytes() {
        let bytes = vec![0x5a; 200_000];
        let payload = PayloadDigest {
            name: "large".into(),
            algorithm: PayloadDigestAlgorithm::Sha256,
            byte_length: bytes.len() as u64,
            digest: Sha256::digest(&bytes).into(),
        };
        verify_payload(
            &payload,
            ParametricVerificationLimits::default(),
            &mut Cursor::new(&bytes),
        )
        .unwrap();
        let mut with_trailing = bytes;
        with_trailing.push(0);
        assert_eq!(
            verify_payload(
                &payload,
                ParametricVerificationLimits::default(),
                &mut Cursor::new(with_trailing)
            ),
            Err(ParametricCertificateError::PayloadMismatch)
        );
    }

    #[test]
    fn aggregate_work_limits_fail_before_unbounded_verification() {
        let bytes = b"bounded residual evidence";

        let limits = ParametricVerificationLimits {
            max_total_nodes: 14,
            ..ParametricVerificationLimits::default()
        };
        let mut cursor = Cursor::new(bytes);
        let mut readers: [&mut dyn Read; 1] = [&mut cursor];
        assert_eq!(
            verify_parametric_certificate(&certificate(bytes), limits, &mut readers),
            Err(ParametricCertificateError::ResourceLimit)
        );

        let limits = ParametricVerificationLimits {
            max_total_coefficient_bits: 8,
            ..ParametricVerificationLimits::default()
        };
        let mut cursor = Cursor::new(bytes);
        let mut readers: [&mut dyn Read; 1] = [&mut cursor];
        assert_eq!(
            verify_parametric_certificate(&certificate(bytes), limits, &mut readers),
            Err(ParametricCertificateError::ResourceLimit)
        );

        let limits = ParametricVerificationLimits {
            max_cover_marks: 2,
            ..ParametricVerificationLimits::default()
        };
        let mut cursor = Cursor::new(bytes);
        let mut readers: [&mut dyn Read; 1] = [&mut cursor];
        assert_eq!(
            verify_parametric_certificate(&certificate(bytes), limits, &mut readers),
            Err(ParametricCertificateError::ResourceLimit)
        );

        let limits = ParametricVerificationLimits {
            max_payload_bytes: (bytes.len() - 1) as u64,
            max_total_payload_bytes: (bytes.len() - 1) as u64,
            ..ParametricVerificationLimits::default()
        };
        let mut cursor = Cursor::new(bytes);
        let mut readers: [&mut dyn Read; 1] = [&mut cursor];
        assert_eq!(
            verify_parametric_certificate(&certificate(bytes), limits, &mut readers),
            Err(ParametricCertificateError::ResourceLimit)
        );
    }

    #[test]
    fn composition_requires_exactly_one_leaf_per_declared_object() {
        let bytes = b"bounded residual evidence";
        let mut broken = certificate(bytes);
        broken.composition.nodes[2] = ParametricCompositionNode::Family { family: 0 };
        assert_eq!(
            verify(&broken, bytes),
            Err(ParametricCertificateError::InvalidComposition)
        );
    }

    #[test]
    fn cover_threshold_arithmetic_extends_past_u64() {
        let bytes = b"bounded residual evidence";
        let mut certificate = certificate(bytes);
        certificate.cover.claim_minimum = u64::MAX;
        let verified = verify(&certificate, bytes).unwrap();
        assert_eq!(verified.claim_minimum, u64::MAX);
    }
}
