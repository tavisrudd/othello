//! Domain-neutral private proof-synthesis primitives.
//!
//! C1016 remains private while this API is exercised on several adapters. The
//! engine owns typed extractor descriptors, exact linear closure, bounded
//! iterative Diophantine endpoints, and compact replay records. Domain
//! vocabulary and theorem rules live in registered adapters.

use serde::{Deserialize, Serialize};
use thiserror::Error;

pub const MAX_LINEAR_VARIABLES: usize = 16;
pub const MAX_SQUARE_VARIABLES: usize = 8;
pub const MAX_BOUNDED_VARIABLES: usize = 8;
pub const MAX_FACTS: u8 = 64;

/// Exhaustively evolves primitive bounded homogeneous integer relations over
/// anonymous scalar observations. The caller owns the output workspace; the
/// candidate loop is iterative and allocation-free.
pub fn evolve_bounded_homogeneous_relations<const FIELDS: usize, const CAPACITY: usize>(
    rows: &[[i32; FIELDS]],
    coefficient_bound: i8,
    output: &mut [[i8; FIELDS]; CAPACITY],
) -> Result<(u64, usize), SynthesisError> {
    if FIELDS == 0 || FIELDS > MAX_LINEAR_VARIABLES || rows.is_empty() || coefficient_bound <= 0 {
        return Err(SynthesisError::InvalidLinearDimensions);
    }
    let radix = u64::try_from(2_i16 * i16::from(coefficient_bound) + 1)
        .map_err(|_| SynthesisError::InvalidLinearDimensions)?;
    let candidates = (0..FIELDS).try_fold(1_u64, |product, _| {
        product
            .checked_mul(radix)
            .ok_or(SynthesisError::ArithmeticOverflow)
    })?;
    let mut tested = 0_u64;
    let mut found = 0_usize;
    for mut code in 0..candidates {
        let mut coefficients = [0_i8; FIELDS];
        for coefficient in &mut coefficients {
            *coefficient = (code % radix) as i8 - coefficient_bound;
            code /= radix;
        }
        let Some(first) = coefficients.iter().copied().find(|&value| value != 0) else {
            continue;
        };
        if first < 0 || coefficients_gcd(coefficients) != 1 {
            continue;
        }
        tested += 1;
        let mut holds = true;
        for row in rows {
            let mut sum = 0_i64;
            for field in 0..FIELDS {
                sum = sum
                    .checked_add(i64::from(coefficients[field]) * i64::from(row[field]))
                    .ok_or(SynthesisError::ArithmeticOverflow)?;
            }
            if sum != 0 {
                holds = false;
                break;
            }
        }
        if holds {
            if found == CAPACITY {
                return Err(SynthesisError::SolutionBudget);
            }
            output[found] = coefficients;
            found += 1;
        }
    }
    Ok((tested, found))
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ModularNullspaceRelation<const FIELDS: usize> {
    pub coefficients: [i8; FIELDS],
    pub primes_tested: u8,
    pub rows_replayed: u64,
}

/// Blind fast path for a unique small homogeneous relation.  Candidate
/// coefficients come from one-dimensional nullspaces over small prime fields,
/// then gain evidentiary status only after exact integer replay on every row.
/// The bounded kernel is iterative and allocation-free.
pub fn evolve_unique_bounded_relation_modular<const FIELDS: usize>(
    rows: &[[i32; FIELDS]],
    coefficient_bound: i8,
) -> Result<Option<ModularNullspaceRelation<FIELDS>>, SynthesisError> {
    const PRIMES: [u8; 11] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31];
    if FIELDS == 0 || FIELDS > MAX_LINEAR_VARIABLES || rows.is_empty() || coefficient_bound <= 0 {
        return Err(SynthesisError::InvalidLinearDimensions);
    }
    for (prime_index, modulus) in PRIMES.into_iter().enumerate() {
        let primes_tested = (prime_index + 1) as u8;
        let mut basis = [[0_u8; FIELDS]; FIELDS];
        let mut pivots = [0_u8; FIELDS];
        let mut rank = 0_usize;
        for observation in rows {
            let mut vector = observation.map(|value| value.rem_euclid(i32::from(modulus)) as u8);
            for row in 0..rank {
                let pivot = usize::from(pivots[row]);
                let factor = vector[pivot];
                if factor != 0 {
                    for field in 0..FIELDS {
                        vector[field] = (u16::from(vector[field]) + u16::from(modulus)
                            - u16::from(factor) * u16::from(basis[row][field]) % u16::from(modulus))
                            as u8
                            % modulus;
                    }
                }
            }
            let Some(pivot) = vector.iter().position(|&value| value != 0) else {
                continue;
            };
            let inverse = (1..modulus)
                .find(|&candidate| {
                    u16::from(candidate) * u16::from(vector[pivot]) % u16::from(modulus) == 1
                })
                .ok_or(SynthesisError::ArithmeticOverflow)?;
            for value in &mut vector {
                *value = (u16::from(*value) * u16::from(inverse) % u16::from(modulus)) as u8;
            }
            for row in 0..rank {
                let factor = basis[row][pivot];
                if factor != 0 {
                    for field in 0..FIELDS {
                        basis[row][field] = (u16::from(basis[row][field]) + u16::from(modulus)
                            - u16::from(factor) * u16::from(vector[field]) % u16::from(modulus))
                            as u8
                            % modulus;
                    }
                }
            }
            basis[rank] = vector;
            pivots[rank] = pivot as u8;
            rank += 1;
            if rank == FIELDS {
                return Ok(None);
            }
        }
        if rank + 1 != FIELDS {
            continue;
        }
        let mut pivot_fields = [false; FIELDS];
        for &pivot in &pivots[..rank] {
            pivot_fields[usize::from(pivot)] = true;
        }
        let free = pivot_fields
            .iter()
            .position(|&is_pivot| !is_pivot)
            .ok_or(SynthesisError::ArithmeticOverflow)?;
        let mut null_vector = [0_u8; FIELDS];
        null_vector[free] = 1;
        for row in 0..rank {
            let pivot = usize::from(pivots[row]);
            null_vector[pivot] = (modulus - basis[row][free]) % modulus;
        }
        for scale in 1..modulus {
            let mut coefficients = [0_i8; FIELDS];
            let mut in_bounds = true;
            for field in 0..FIELDS {
                let residue =
                    (u16::from(null_vector[field]) * u16::from(scale) % u16::from(modulus)) as i16;
                let signed = if residue <= i16::from(modulus / 2) {
                    residue
                } else {
                    residue - i16::from(modulus)
                };
                if signed.unsigned_abs() > coefficient_bound as u16 {
                    in_bounds = false;
                    break;
                }
                coefficients[field] = signed as i8;
            }
            let Some(first) = coefficients.iter().copied().find(|&value| value != 0) else {
                continue;
            };
            if !in_bounds || coefficients_gcd(coefficients) != 1 {
                continue;
            }
            if first < 0 {
                for coefficient in &mut coefficients {
                    *coefficient = -*coefficient;
                }
            }
            let mut rows_replayed = 0_u64;
            let exact = rows.iter().all(|observation| {
                rows_replayed += 1;
                (0..FIELDS).fold(0_i64, |sum, field| {
                    sum + i64::from(coefficients[field]) * i64::from(observation[field])
                }) == 0
            });
            if exact {
                return Ok(Some(ModularNullspaceRelation {
                    coefficients,
                    primes_tested,
                    rows_replayed,
                }));
            }
        }
    }
    Ok(None)
}

fn coefficients_gcd<const FIELDS: usize>(coefficients: [i8; FIELDS]) -> u8 {
    let mut divisor = 0_u8;
    for coefficient in coefficients {
        let mut value = coefficient.unsigned_abs();
        let mut current = divisor;
        while value != 0 {
            let remainder = current % value;
            current = value;
            value = remainder;
        }
        divisor = current;
    }
    divisor
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct ExtractorDescriptor {
    identity: [u8; 16],
    version: u16,
    parameter_digest: [u8; 32],
    source_commitment: [u8; 32],
}

impl ExtractorDescriptor {
    /// Registration is crate-private: domain adapters must be reviewed and
    /// compiled into `ergodis-private`; presentations cannot construct one.
    pub(crate) const fn registered(
        identity: [u8; 16],
        version: u16,
        parameter_digest: [u8; 32],
        source_commitment: [u8; 32],
    ) -> Self {
        Self {
            identity,
            version,
            parameter_digest,
            source_commitment,
        }
    }

    #[must_use]
    pub const fn identity(self) -> [u8; 16] {
        self.identity
    }

    #[must_use]
    pub const fn version(self) -> u16 {
        self.version
    }

    #[must_use]
    pub const fn parameter_digest(self) -> [u8; 32] {
        self.parameter_digest
    }

    #[must_use]
    pub const fn source_commitment(self) -> [u8; 32] {
        self.source_commitment
    }
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub enum SemanticSort {
    Integer,
    AlgebraicCoefficient {
        field_tag: u64,
        basis_index: u8,
        degree: u8,
    },
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub enum Relation {
    Equal,
    AbsoluteAtMost,
    Congruent { modulus: i64 },
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct TypedObservation {
    pub field: u32,
    pub sort: SemanticSort,
    pub relation: Relation,
    pub value: i64,
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub enum GenericProofStatus {
    Candidate,
    Skeleton,
    Proved,
    Falsified,
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub enum ProvenanceClass {
    ProvedStructural,
    ExactComputational,
    ObservedEvolved,
    HeuristicSearch,
    DirectWitness,
}

impl ProvenanceClass {
    #[must_use]
    pub const fn permits_pruning(self) -> bool {
        matches!(self, Self::ProvedStructural | Self::ExactComputational)
    }

    #[must_use]
    pub const fn permits_negative_coverage(self) -> bool {
        self.permits_pruning()
    }

    #[must_use]
    pub const fn permits_direct_positive_claim(self) -> bool {
        matches!(self, Self::DirectWitness)
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct RuleApplication {
    pub input_fact_mask: u64,
    pub rule: u32,
    pub registry_slot: u16,
    pub output_fact: u8,
    reserved: u8,
}

const _: () = assert!(std::mem::size_of::<RuleApplication>() == 16);

impl RuleApplication {
    pub const EMPTY: Self = Self {
        input_fact_mask: 0,
        rule: 0,
        registry_slot: 0,
        output_fact: 0,
        reserved: 0,
    };
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct RuleSpec {
    identity: u32,
    premises: u64,
    conclusion: u8,
}

impl RuleSpec {
    /// Rule registration is private to compiled adapters. An evolved
    /// presentation can suggest a rule identity but cannot register one.
    pub(crate) const fn registered(identity: u32, premises: u64, conclusion: u8) -> Self {
        Self {
            identity,
            premises,
            conclusion,
        }
    }

    #[must_use]
    pub const fn identity(self) -> u32 {
        self.identity
    }

    #[must_use]
    pub const fn premises(self) -> u64 {
        self.premises
    }

    #[must_use]
    pub const fn conclusion(self) -> u8 {
        self.conclusion
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct HornDerivation {
    pub final_facts: u64,
    pub applications: Box<[RuleApplication]>,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct DerivationTranscript {
    pub extractor: ExtractorDescriptor,
    pub goal_digest: [u8; 32],
    pub rules: Box<[RuleApplication]>,
    pub status: GenericProofStatus,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum SynthesisError {
    #[error("linear system dimensions are invalid or exceed the private bound")]
    InvalidLinearDimensions,
    #[error("linear system arithmetic overflowed")]
    ArithmeticOverflow,
    #[error("linear system is inconsistent")]
    Inconsistent,
    #[error("linear system does not determine every variable")]
    Underdetermined,
    #[error("unique rational solution is not integral")]
    NonIntegral,
    #[error("bounded endpoint dimensions are invalid")]
    InvalidEndpoint,
    #[error("bounded endpoint exceeded its explicit candidate budget")]
    EndpointBudget,
    #[error("bounded endpoint exceeded its explicit solution budget")]
    SolutionBudget,
    #[error("Horn proof registry or fact mask is invalid")]
    InvalidRuleRegistry,
    #[error("Horn closure did not derive the requested goal")]
    GoalNotDerived,
    #[error("Horn closure exceeded its explicit application budget")]
    RuleBudget,
    #[error("Horn transcript did not replay against the sealed registry")]
    InvalidTranscript,
}

/// Compute the least closure of registered Horn rules. This is iterative,
/// deterministic, and bounded; it is suitable for compiling an evolved
/// observation into a compact candidate proof without exploring a recursive
/// proof tree.
pub fn derive_horn_closure(
    initial_facts: u64,
    goal_facts: u64,
    registry: &[RuleSpec],
    application_budget: u32,
) -> Result<HornDerivation, SynthesisError> {
    let mut workspace = [RuleApplication::EMPTY; MAX_FACTS as usize];
    let (facts, used) = derive_horn_closure_into(
        initial_facts,
        goal_facts,
        registry,
        application_budget,
        &mut workspace,
    )?;
    Ok(HornDerivation {
        final_facts: facts,
        applications: workspace[..used].to_vec().into_boxed_slice(),
    })
}

/// Allocation-free closure kernel over caller-owned transcript storage.
pub fn derive_horn_closure_into(
    initial_facts: u64,
    goal_facts: u64,
    registry: &[RuleSpec],
    application_budget: u32,
    workspace: &mut [RuleApplication],
) -> Result<(u64, usize), SynthesisError> {
    validate_rule_registry(registry, application_budget)?;
    let mut facts = initial_facts;
    let limit = workspace.len().min(application_budget as usize);
    let mut used = 0_usize;
    loop {
        if facts & goal_facts == goal_facts {
            return Ok((facts, used));
        }
        let before = facts;
        for (registry_slot, rule) in registry.iter().enumerate() {
            let conclusion = fact_mask(rule.conclusion)?;
            if facts & conclusion == 0 && facts & rule.premises == rule.premises {
                if used >= limit {
                    return Err(SynthesisError::RuleBudget);
                }
                workspace[used] = RuleApplication {
                    input_fact_mask: rule.premises,
                    rule: rule.identity,
                    registry_slot: registry_slot as u16,
                    output_fact: rule.conclusion,
                    reserved: 0,
                };
                used += 1;
                facts |= conclusion;
            }
        }
        if facts == before {
            return Err(SynthesisError::GoalNotDerived);
        }
    }
}

/// Replay a compact transcript against the sealed adapter registry. Rule IDs,
/// premises, and conclusions all have to match; presentation metadata alone
/// cannot create authority.
pub fn replay_horn_derivation(
    initial_facts: u64,
    goal_facts: u64,
    registry: &[RuleSpec],
    applications: &[RuleApplication],
) -> Result<u64, SynthesisError> {
    validate_rule_registry(registry, u32::MAX)?;
    let mut facts = initial_facts;
    for application in applications {
        let Some(rule) = registry.get(usize::from(application.registry_slot)) else {
            return Err(SynthesisError::InvalidTranscript);
        };
        if application.rule != rule.identity
            || application.input_fact_mask != rule.premises
            || application.output_fact != rule.conclusion
            || application.reserved != 0
            || facts & rule.premises != rule.premises
        {
            return Err(SynthesisError::InvalidTranscript);
        }
        facts |= fact_mask(rule.conclusion)?;
    }
    if facts & goal_facts != goal_facts {
        return Err(SynthesisError::GoalNotDerived);
    }
    Ok(facts)
}

fn validate_rule_registry(
    registry: &[RuleSpec],
    application_budget: u32,
) -> Result<(), SynthesisError> {
    if registry.is_empty()
        || application_budget == 0
        || registry.iter().any(|rule| {
            rule.conclusion >= MAX_FACTS
                || rule.premises & fact_mask_unchecked(rule.conclusion) != 0
        })
    {
        return Err(SynthesisError::InvalidRuleRegistry);
    }
    for (index, rule) in registry.iter().enumerate() {
        if registry[..index]
            .iter()
            .any(|earlier| earlier.identity == rule.identity)
        {
            return Err(SynthesisError::InvalidRuleRegistry);
        }
    }
    Ok(())
}

const fn fact_mask(fact: u8) -> Result<u64, SynthesisError> {
    if fact >= MAX_FACTS {
        Err(SynthesisError::InvalidRuleRegistry)
    } else {
        Ok(fact_mask_unchecked(fact))
    }
}

const fn fact_mask_unchecked(fact: u8) -> u64 {
    1_u64 << fact
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct IntegerLinearSystem {
    variables: usize,
    rows: Box<[Box<[i128]>]>,
}

impl IntegerLinearSystem {
    pub fn new(variables: usize, equations: &[(&[i64], i64)]) -> Result<Self, SynthesisError> {
        if variables == 0
            || variables > MAX_LINEAR_VARIABLES
            || equations.is_empty()
            || equations.iter().any(|(row, _)| row.len() != variables)
        {
            return Err(SynthesisError::InvalidLinearDimensions);
        }
        let rows = equations
            .iter()
            .map(|(coefficients, right)| {
                coefficients
                    .iter()
                    .map(|&value| i128::from(value))
                    .chain(std::iter::once(i128::from(*right)))
                    .collect::<Vec<_>>()
                    .into_boxed_slice()
            })
            .collect::<Vec<_>>()
            .into_boxed_slice();
        Ok(Self { variables, rows })
    }

    /// Fraction-free elimination with exact divisibility checks. Compilation
    /// may allocate; no generated solve-loop kernel calls this routine.
    pub fn solve_unique_integer(&self) -> Result<Box<[i64]>, SynthesisError> {
        let mut rows = self.rows.to_vec();
        let mut pivot_row = 0_usize;
        let mut previous_pivot = 1_i128;
        let mut pivots = vec![usize::MAX; self.variables];
        for column in 0..self.variables {
            let Some(selected) = (pivot_row..rows.len()).find(|&row| rows[row][column] != 0) else {
                continue;
            };
            rows.swap(pivot_row, selected);
            let pivot = rows[pivot_row][column];
            for row in pivot_row + 1..rows.len() {
                let factor = rows[row][column];
                if factor == 0 {
                    continue;
                }
                for entry in column + 1..=self.variables {
                    let left = rows[row][entry]
                        .checked_mul(pivot)
                        .ok_or(SynthesisError::ArithmeticOverflow)?;
                    let right = factor
                        .checked_mul(rows[pivot_row][entry])
                        .ok_or(SynthesisError::ArithmeticOverflow)?;
                    let numerator = left
                        .checked_sub(right)
                        .ok_or(SynthesisError::ArithmeticOverflow)?;
                    if numerator % previous_pivot != 0 {
                        return Err(SynthesisError::ArithmeticOverflow);
                    }
                    rows[row][entry] = numerator / previous_pivot;
                }
                rows[row][column] = 0;
            }
            pivots[column] = pivot_row;
            pivot_row += 1;
            previous_pivot = pivot;
            if pivot_row == rows.len() {
                break;
            }
        }
        if rows.iter().any(|row| {
            row[..self.variables].iter().all(|&value| value == 0) && row[self.variables] != 0
        }) {
            return Err(SynthesisError::Inconsistent);
        }
        if pivots.contains(&usize::MAX) {
            return Err(SynthesisError::Underdetermined);
        }
        let mut solution = vec![0_i128; self.variables];
        for column in (0..self.variables).rev() {
            let row = pivots[column];
            let mut right = rows[row][self.variables];
            for later in column + 1..self.variables {
                right = right
                    .checked_sub(
                        rows[row][later]
                            .checked_mul(solution[later])
                            .ok_or(SynthesisError::ArithmeticOverflow)?,
                    )
                    .ok_or(SynthesisError::ArithmeticOverflow)?;
            }
            let coefficient = rows[row][column];
            if right % coefficient != 0 {
                return Err(SynthesisError::NonIntegral);
            }
            solution[column] = right / coefficient;
        }
        solution
            .into_iter()
            .map(|value| i64::try_from(value).map_err(|_| SynthesisError::ArithmeticOverflow))
            .collect::<Result<Vec<_>, _>>()
            .map(Vec::into_boxed_slice)
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct SquareSumEndpoint {
    pub variables: u8,
    pub target: u32,
    pub candidates_tested: u64,
    pub solutions: Box<[Box<[u16]>]>,
}

/// Enumerate nondecreasing nonnegative solutions of a small square-sum
/// endpoint. Traversal is iterative and bounded explicitly.
pub fn solve_sorted_square_sum(
    variables: u8,
    target: u32,
    candidate_budget: u64,
) -> Result<SquareSumEndpoint, SynthesisError> {
    if variables == 0 || usize::from(variables) > MAX_SQUARE_VARIABLES || candidate_budget == 0 {
        return Err(SynthesisError::InvalidEndpoint);
    }
    let maximum = integer_square_root(target);
    let mut candidate = vec![0_u16; usize::from(variables)];
    let mut solutions = Vec::new();
    let mut tested = 0_u64;
    loop {
        tested = tested
            .checked_add(1)
            .ok_or(SynthesisError::EndpointBudget)?;
        if tested > candidate_budget {
            return Err(SynthesisError::EndpointBudget);
        }
        let sum = candidate.iter().try_fold(0_u64, |sum, &value| {
            sum.checked_add(u64::from(value) * u64::from(value))
                .ok_or(SynthesisError::ArithmeticOverflow)
        })?;
        if sum == u64::from(target) {
            solutions.push(candidate.clone().into_boxed_slice());
        }

        let mut position = candidate.len();
        loop {
            if position == 0 {
                return Ok(SquareSumEndpoint {
                    variables,
                    target,
                    candidates_tested: tested,
                    solutions: solutions.into_boxed_slice(),
                });
            }
            position -= 1;
            if candidate[position] < maximum {
                candidate[position] += 1;
                let next = candidate[position];
                candidate[position + 1..].fill(next);
                break;
            }
        }
    }
}

fn integer_square_root(value: u32) -> u16 {
    let mut low = 0_u32;
    let mut high = u32::from(u16::MAX);
    while low < high {
        let middle = low + (high - low).div_ceil(2);
        if u64::from(middle) * u64::from(middle) <= u64::from(value) {
            low = middle;
        } else {
            high = middle - 1;
        }
    }
    low as u16
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct BoundedLinearSolution {
    pub values: [u16; MAX_BOUNDED_VARIABLES],
}

const _: () = assert!(std::mem::size_of::<BoundedLinearSolution>() == 16);

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct BoundedLinearEndpoint {
    pub variables: u8,
    pub target: u32,
    pub candidates_tested: u64,
    pub solutions: Box<[BoundedLinearSolution]>,
}

/// Enumerate bounded nonnegative solutions of one exact linear equation.
/// The odometer is iterative, the candidate lives in a fixed Tiger record,
/// and the result vector is fully presized before the hot loop.
pub fn solve_bounded_linear_combination(
    weights: &[u16],
    upper_bounds: &[u16],
    target: u32,
    candidate_budget: u64,
    solution_budget: u32,
) -> Result<BoundedLinearEndpoint, SynthesisError> {
    if weights.is_empty()
        || weights.len() > MAX_BOUNDED_VARIABLES
        || weights.len() != upper_bounds.len()
        || weights.contains(&0)
        || candidate_budget == 0
        || solution_budget == 0
    {
        return Err(SynthesisError::InvalidEndpoint);
    }
    let mut candidate = BoundedLinearSolution {
        values: [0; MAX_BOUNDED_VARIABLES],
    };
    let mut solutions = Vec::with_capacity(solution_budget as usize);
    let mut tested = 0_u64;
    loop {
        tested = tested
            .checked_add(1)
            .ok_or(SynthesisError::EndpointBudget)?;
        if tested > candidate_budget {
            return Err(SynthesisError::EndpointBudget);
        }
        let sum =
            weights
                .iter()
                .zip(candidate.values)
                .try_fold(0_u32, |sum, (&weight, value)| {
                    sum.checked_add(u32::from(weight) * u32::from(value))
                        .ok_or(SynthesisError::ArithmeticOverflow)
                })?;
        if sum == target {
            if solutions.len() == solution_budget as usize {
                return Err(SynthesisError::SolutionBudget);
            }
            solutions.push(candidate);
        }

        let mut position = weights.len();
        loop {
            if position == 0 {
                return Ok(BoundedLinearEndpoint {
                    variables: weights.len() as u8,
                    target,
                    candidates_tested: tested,
                    solutions: solutions.into_boxed_slice(),
                });
            }
            position -= 1;
            if candidate.values[position] < upper_bounds[position] {
                candidate.values[position] += 1;
                candidate.values[position + 1..weights.len()].fill(0);
                break;
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn bounded_relation_evolution_is_blind_exact_and_allocation_free() {
        let rows = [[1, 2, 2, 0], [2, 0, 1, 2], [3, 4, 5, 0], [7, 2, 8, 0]];
        let mut output = [[0_i8; 4]; 4];
        let (result, allocations) =
            tracked_allocations(|| evolve_bounded_homogeneous_relations(&rows, 2, &mut output));
        let (tested, found) = result.unwrap();
        assert!(tested > 0);
        assert_eq!(found, 1);
        assert_eq!(output[0], [2, 1, -2, -1]);
        assert_eq!(allocations, 0);
        let mut too_small: [[i8; 4]; 0] = [];
        assert_eq!(
            evolve_bounded_homogeneous_relations(&rows, 2, &mut too_small),
            Err(SynthesisError::SolutionBudget)
        );
    }

    #[test]
    fn modular_nullspace_fast_path_matches_exhaustive_relation_evolution() {
        let rows = [[1, 2, 2, 0], [2, 0, 1, 2], [3, 4, 5, 0], [7, 2, 8, 0]];
        let mut exhaustive = [[0_i8; 4]; 4];
        let (_, found) = evolve_bounded_homogeneous_relations(&rows, 2, &mut exhaustive).unwrap();
        assert_eq!(found, 1);
        let fast = evolve_unique_bounded_relation_modular(&rows, 2)
            .unwrap()
            .unwrap();
        assert_eq!(fast.coefficients, exhaustive[0]);
        assert_eq!(fast.rows_replayed, rows.len() as u64);
    }

    #[test]
    fn modular_nullspace_matches_exhaustive_on_independent_small_relations() {
        let relations = [
            [1_i8, 1, 1, 1],
            [2, 1, -2, -1],
            [1, -2, 1, 2],
            [2, -1, 1, 1],
            [1, 2, -2, 2],
            [2, -2, 1, -1],
        ];
        for expected in relations {
            let [a, b, c, d] = expected.map(i32::from);
            let rows = [[d, 0, 0, -a], [0, d, 0, -b], [0, 0, d, -c]];
            let mut exhaustive = [[0_i8; 4]; 4];
            let (_, found) =
                evolve_bounded_homogeneous_relations(&rows, 2, &mut exhaustive).unwrap();
            assert_eq!(found, 1, "{expected:?}");
            assert_eq!(exhaustive[0], expected);
            assert_eq!(
                evolve_unique_bounded_relation_modular(&rows, 2)
                    .unwrap()
                    .unwrap()
                    .coefficients,
                expected
            );
        }
    }

    #[test]
    fn modular_nullspace_fails_closed_on_full_or_nonunique_rank() {
        let full = [[1, 0], [0, 1]];
        assert_eq!(
            evolve_unique_bounded_relation_modular(&full, 1).unwrap(),
            None
        );
        let nonunique = [[1, 0, 0]];
        assert_eq!(
            evolve_unique_bounded_relation_modular(&nonunique, 1).unwrap(),
            None
        );
    }

    #[test]
    fn modular_nullspace_kernel_allocates_nothing() {
        let rows = [[1, 2, 2, 0], [2, 0, 1, 2], [3, 4, 5, 0], [7, 2, 8, 0]];
        let (relation, allocations) =
            tracked_allocations(|| evolve_unique_bounded_relation_modular(&rows, 2));
        assert_eq!(allocations, 0);
        assert_eq!(relation.unwrap().unwrap().coefficients, [2, 1, -2, -1]);
    }

    #[test]
    fn fraction_free_linear_closure_is_exact() {
        let system = IntegerLinearSystem::new(2, &[(&[2, 1], 7), (&[1, -1], 2)]).unwrap();
        assert_eq!(system.solve_unique_integer().unwrap().as_ref(), [3, 1]);
        let nonintegral = IntegerLinearSystem::new(1, &[(&[2], 1)]).unwrap();
        assert_eq!(
            nonintegral.solve_unique_integer(),
            Err(SynthesisError::NonIntegral)
        );
    }

    #[test]
    fn square_endpoint_is_iterative_bounded_and_canonical() {
        let endpoint = solve_sorted_square_sum(3, 18, 1_000).unwrap();
        assert!(endpoint.candidates_tested <= 1_000);
        assert_eq!(
            endpoint
                .solutions
                .iter()
                .map(|solution| solution.as_ref())
                .collect::<Vec<_>>(),
            [&[0, 3, 3][..], &[1, 1, 4][..]]
        );
        assert_eq!(
            solve_sorted_square_sum(3, 18, 1),
            Err(SynthesisError::EndpointBudget)
        );
        assert_eq!(integer_square_root(u32::MAX), u16::MAX);
        assert_eq!(
            integer_square_root(u32::from(u16::MAX).pow(2) - 1),
            u16::MAX - 1
        );
    }

    #[test]
    fn horn_closure_synthesizes_and_independently_replays() {
        const RULES: [RuleSpec; 3] = [
            RuleSpec::registered(11, 1 << 0, 1),
            RuleSpec::registered(12, (1 << 0) | (1 << 1), 2),
            RuleSpec::registered(13, 1 << 2, 3),
        ];
        let proof = derive_horn_closure(1 << 0, 1 << 3, &RULES, 3).unwrap();
        assert_eq!(proof.applications.len(), 3);
        assert_eq!(
            replay_horn_derivation(1 << 0, 1 << 3, &RULES, &proof.applications),
            Ok(0b1111)
        );
        let mut forged = proof.applications.to_vec();
        forged[1].input_fact_mask = 0;
        assert_eq!(
            replay_horn_derivation(1 << 0, 1 << 3, &RULES, &forged),
            Err(SynthesisError::InvalidTranscript)
        );

        let mut workspace = [RuleApplication::EMPTY; 3];
        let (facts, used) =
            derive_horn_closure_into(1 << 0, 1 << 3, &RULES, 3, &mut workspace).unwrap();
        assert_eq!((facts, used), (0b1111, 3));
        assert_eq!(workspace.as_slice(), proof.applications.as_ref());
    }

    #[test]
    fn provenance_authority_is_fail_closed() {
        for class in [
            ProvenanceClass::ObservedEvolved,
            ProvenanceClass::HeuristicSearch,
            ProvenanceClass::DirectWitness,
        ] {
            assert!(!class.permits_pruning());
            assert!(!class.permits_negative_coverage());
        }
        assert!(ProvenanceClass::ProvedStructural.permits_pruning());
        assert!(ProvenanceClass::ExactComputational.permits_negative_coverage());
        assert!(ProvenanceClass::DirectWitness.permits_direct_positive_claim());
        assert!(!ProvenanceClass::HeuristicSearch.permits_direct_positive_claim());
    }

    #[test]
    fn bounded_linear_endpoint_finds_exact_g53_defect_profiles() {
        let endpoint =
            solve_bounded_linear_combination(&[15, 13, 4, 3], &[2, 2, 8, 11], 34, 1_000, 16)
                .unwrap();
        assert_eq!(endpoint.solutions.len(), 10);
        for solution in endpoint.solutions {
            assert_eq!(
                15 * u32::from(solution.values[0])
                    + 13 * u32::from(solution.values[1])
                    + 4 * u32::from(solution.values[2])
                    + 3 * u32::from(solution.values[3]),
                34
            );
        }
    }

    #[test]
    fn bounded_linear_endpoint_fails_closed_on_budgets() {
        assert_eq!(
            solve_bounded_linear_combination(&[1], &[10], 7, 3, 1),
            Err(SynthesisError::EndpointBudget)
        );
        assert_eq!(
            solve_bounded_linear_combination(&[1, 1], &[1, 1], 1, 4, 1),
            Err(SynthesisError::SolutionBudget)
        );
    }
}
