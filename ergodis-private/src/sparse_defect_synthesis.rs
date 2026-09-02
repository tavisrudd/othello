//! Domain-neutral synthesis of sparse energy defects from a finite alphabet.
//!
//! This is the private bridge from an evolved local alphabet to a compact
//! structural theorem candidate.  It discovers the minimum square, the gcd
//! normalization, and every bounded magnitude-count profile without receiving
//! names for any distinguished magnitudes.  Provenance is preserved: an
//! observed or heuristic alphabet can suggest a derivation, but only a caller
//! whose sealed extractor supplied structural or exact-computational input may
//! use the result for pruning.

use thiserror::Error;

use crate::proof_synthesis::{
    solve_bounded_linear_combination, BoundedLinearSolution, ProvenanceClass, SynthesisError,
    MAX_BOUNDED_VARIABLES,
};

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct SparseAlphabetObservation<const CHOICES: usize, const SLOTS: usize> {
    /// Size of every fibre collapsed to one quotient coordinate.
    fibre_size: u16,
    /// Number of supplementary blocks.
    block_count: u8,
    /// Exact total squared norm of all quotient marginals.
    signed_energy: u32,
    /// Anonymous attainable coefficients at one quotient coordinate.
    coefficients: [u16; CHOICES],
    /// Numbers of quotient coordinates represented by the independent slots.
    slot_multiplicities: [u8; SLOTS],
    provenance: ProvenanceClass,
}

impl<const CHOICES: usize, const SLOTS: usize> SparseAlphabetObservation<CHOICES, SLOTS> {
    pub fn observed(
        fibre_size: u16,
        block_count: u8,
        signed_energy: u32,
        coefficients: [u16; CHOICES],
        slot_multiplicities: [u8; SLOTS],
        provenance: ProvenanceClass,
    ) -> Result<Self, SparseDefectSynthesisError> {
        if !matches!(
            provenance,
            ProvenanceClass::ObservedEvolved | ProvenanceClass::HeuristicSearch
        ) {
            return Err(SparseDefectSynthesisError::InvalidObservation);
        }
        let observation = Self {
            fibre_size,
            block_count,
            signed_energy,
            coefficients,
            slot_multiplicities,
            provenance,
        };
        validate_observation(observation)?;
        Ok(observation)
    }

    /// Authoritative construction is sealed inside `ergodis-private`.
    /// Registered adapters must additionally bind extractor identity,
    /// parameters, and source commitment in their outer proof object.
    #[allow(
        dead_code,
        reason = "reserved for typed private adapters; discovery callers cannot construct pruning provenance"
    )]
    pub(crate) fn registered(
        fibre_size: u16,
        block_count: u8,
        signed_energy: u32,
        coefficients: [u16; CHOICES],
        slot_multiplicities: [u8; SLOTS],
        provenance: ProvenanceClass,
    ) -> Result<Self, SparseDefectSynthesisError> {
        if !provenance.permits_pruning() {
            return Err(SparseDefectSynthesisError::InvalidObservation);
        }
        let observation = Self {
            fibre_size,
            block_count,
            signed_energy,
            coefficients,
            slot_multiplicities,
            provenance,
        };
        validate_observation(observation)?;
        Ok(observation)
    }

    #[must_use]
    pub const fn provenance(self) -> ProvenanceClass {
        self.provenance
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct SparseDefectSchema {
    weights: [u16; MAX_BOUNDED_VARIABLES],
    upper_bounds: [u16; MAX_BOUNDED_VARIABLES],
    baseline_square: u32,
    normalizer: u32,
    defect_target: u32,
    candidate_count: u64,
    total_entries: u16,
    variables: u8,
    provenance: ProvenanceClass,
}

impl SparseDefectSchema {
    #[must_use]
    pub const fn authorizes_pruning(self) -> bool {
        self.provenance.permits_pruning()
    }

    #[must_use]
    pub const fn weights(&self) -> &[u16; MAX_BOUNDED_VARIABLES] {
        &self.weights
    }

    #[must_use]
    pub const fn baseline_square(self) -> u32 {
        self.baseline_square
    }

    #[must_use]
    pub const fn normalizer(self) -> u32 {
        self.normalizer
    }

    #[must_use]
    pub const fn defect_target(self) -> u32 {
        self.defect_target
    }

    #[must_use]
    pub const fn variables(self) -> u8 {
        self.variables
    }

    #[must_use]
    pub const fn provenance(self) -> ProvenanceClass {
        self.provenance
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct SparseDefectDerivation {
    schema: SparseDefectSchema,
    profiles: Box<[BoundedLinearSolution]>,
}

impl SparseDefectDerivation {
    #[must_use]
    pub const fn schema(&self) -> SparseDefectSchema {
        self.schema
    }

    #[must_use]
    pub fn profiles(&self) -> &[BoundedLinearSolution] {
        &self.profiles
    }
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum SparseDefectSynthesisError {
    #[error("the sparse alphabet dimensions or provenance are invalid")]
    InvalidObservation,
    #[error("the exact energy has no integral sparse-defect normalization")]
    NonIntegralDefect,
    #[error("the alphabet has too many distinct positive defect weights")]
    TooManyWeights,
    #[error("the supplied synthesis budget is insufficient")]
    Budget,
    #[error("independent replay rejected the derivation")]
    ReplayMismatch,
    #[error("sparse-defect arithmetic overflowed")]
    ArithmeticOverflow,
    #[error(transparent)]
    Synthesis(#[from] SynthesisError),
}

pub fn synthesize_sparse_defects<const CHOICES: usize, const SLOTS: usize>(
    observation: SparseAlphabetObservation<CHOICES, SLOTS>,
    candidate_budget: u64,
    solution_budget: u32,
) -> Result<SparseDefectDerivation, SparseDefectSynthesisError> {
    let schema = derive_schema(observation, candidate_budget)?;
    let variables = usize::from(schema.variables);
    let endpoint = solve_bounded_linear_combination(
        &schema.weights[..variables],
        &schema.upper_bounds[..variables],
        schema.defect_target,
        candidate_budget,
        solution_budget,
    )?;
    if endpoint.candidates_tested != schema.candidate_count {
        return Err(SparseDefectSynthesisError::ReplayMismatch);
    }
    let mut profiles = endpoint.solutions.into_vec();
    profiles.retain(|profile| {
        profile.values[..variables]
            .iter()
            .copied()
            .map(u32::from)
            .sum::<u32>()
            <= u32::from(schema.total_entries)
    });
    let derivation = SparseDefectDerivation {
        schema,
        profiles: profiles.into_boxed_slice(),
    };
    replay_sparse_defects(observation, &derivation)?;
    Ok(derivation)
}

/// Independently replay a synthesized schema and its complete bounded profile
/// list.  The replay uses a fixed odometer and allocates no workspace.
pub fn replay_sparse_defects<const CHOICES: usize, const SLOTS: usize>(
    observation: SparseAlphabetObservation<CHOICES, SLOTS>,
    derivation: &SparseDefectDerivation,
) -> Result<(), SparseDefectSynthesisError> {
    validate_observation(observation)?;
    let schema = derivation.schema;
    if schema.provenance != observation.provenance {
        return Err(SparseDefectSynthesisError::ReplayMismatch);
    }
    let variables = usize::from(schema.variables);
    if variables == 0 || variables > MAX_BOUNDED_VARIABLES {
        return Err(SparseDefectSynthesisError::ReplayMismatch);
    }

    let mut baseline = u32::MAX;
    let mut raw_gcd = 0_u32;
    let mut squares = [0_u32; CHOICES];
    for (index, &coefficient) in observation.coefficients.iter().enumerate() {
        let signed = i64::from(observation.fibre_size) - 2 * i64::from(coefficient);
        let square = signed
            .checked_mul(signed)
            .and_then(|value| u32::try_from(value).ok())
            .ok_or(SparseDefectSynthesisError::ArithmeticOverflow)?;
        squares[index] = square;
        baseline = baseline.min(square);
    }
    for square in squares {
        raw_gcd = gcd_u32(raw_gcd, square - baseline);
    }
    if baseline != schema.baseline_square || raw_gcd != schema.normalizer || raw_gcd == 0 {
        return Err(SparseDefectSynthesisError::ReplayMismatch);
    }
    let mut seen_weights = 0_u8;
    for square in squares {
        let excess = square - baseline;
        if excess == 0 {
            continue;
        }
        if excess % raw_gcd != 0 {
            return Err(SparseDefectSynthesisError::ReplayMismatch);
        }
        let weight = u16::try_from(excess / raw_gcd)
            .map_err(|_| SparseDefectSynthesisError::ArithmeticOverflow)?;
        let Some(index) = schema.weights[..variables]
            .iter()
            .position(|&candidate| candidate == weight)
        else {
            return Err(SparseDefectSynthesisError::ReplayMismatch);
        };
        seen_weights |= 1_u8 << index;
    }
    let expected_seen = (1_u16 << variables) - 1;
    if u16::from(seen_weights) != expected_seen
        || !schema.weights[..variables]
            .windows(2)
            .all(|pair| pair[0] < pair[1])
    {
        return Err(SparseDefectSynthesisError::ReplayMismatch);
    }
    let baseline_total = u32::from(schema.total_entries)
        .checked_mul(baseline)
        .ok_or(SparseDefectSynthesisError::ArithmeticOverflow)?;
    let reconstructed = baseline_total
        .checked_add(
            raw_gcd
                .checked_mul(schema.defect_target)
                .ok_or(SparseDefectSynthesisError::ArithmeticOverflow)?,
        )
        .ok_or(SparseDefectSynthesisError::ArithmeticOverflow)?;
    if reconstructed != observation.signed_energy {
        return Err(SparseDefectSynthesisError::ReplayMismatch);
    }
    for index in 0..variables {
        let expected = (schema.defect_target / u32::from(schema.weights[index]))
            .min(u32::from(schema.total_entries));
        if u32::from(schema.upper_bounds[index]) != expected {
            return Err(SparseDefectSynthesisError::ReplayMismatch);
        }
    }
    if schema.weights[variables..].iter().any(|&value| value != 0)
        || schema.upper_bounds[variables..]
            .iter()
            .any(|&value| value != 0)
    {
        return Err(SparseDefectSynthesisError::ReplayMismatch);
    }

    let mut candidate = BoundedLinearSolution {
        values: [0; MAX_BOUNDED_VARIABLES],
    };
    let mut profile_index = 0_usize;
    let mut tested = 0_u64;
    loop {
        tested = tested
            .checked_add(1)
            .ok_or(SparseDefectSynthesisError::ArithmeticOverflow)?;
        let mut sum = 0_u32;
        let mut entries = 0_u32;
        for index in 0..variables {
            sum = sum
                .checked_add(u32::from(schema.weights[index]) * u32::from(candidate.values[index]))
                .ok_or(SparseDefectSynthesisError::ArithmeticOverflow)?;
            entries = entries
                .checked_add(u32::from(candidate.values[index]))
                .ok_or(SparseDefectSynthesisError::ArithmeticOverflow)?;
        }
        if sum == schema.defect_target && entries <= u32::from(schema.total_entries) {
            if derivation.profiles.get(profile_index) != Some(&candidate) {
                return Err(SparseDefectSynthesisError::ReplayMismatch);
            }
            profile_index += 1;
        }
        let mut position = variables;
        loop {
            if position == 0 {
                if tested != schema.candidate_count || profile_index != derivation.profiles.len() {
                    return Err(SparseDefectSynthesisError::ReplayMismatch);
                }
                return Ok(());
            }
            position -= 1;
            if candidate.values[position] < schema.upper_bounds[position] {
                candidate.values[position] += 1;
                candidate.values[position + 1..variables].fill(0);
                break;
            }
        }
    }
}

/// Allocation-free classification for generated search kernels.  The caller
/// must separately establish that `coefficient` belongs to its exact alphabet.
pub fn defect_weight(
    schema: &SparseDefectSchema,
    fibre_size: u16,
    coefficient: u16,
) -> Result<Option<u16>, SparseDefectSynthesisError> {
    let signed = i64::from(fibre_size) - 2 * i64::from(coefficient);
    let square = signed
        .checked_mul(signed)
        .and_then(|value| u32::try_from(value).ok())
        .ok_or(SparseDefectSynthesisError::ArithmeticOverflow)?;
    let Some(excess) = square.checked_sub(schema.baseline_square) else {
        return Err(SparseDefectSynthesisError::ReplayMismatch);
    };
    if excess == 0 {
        return Ok(None);
    }
    if schema.normalizer == 0 || excess % schema.normalizer != 0 {
        return Err(SparseDefectSynthesisError::ReplayMismatch);
    }
    let weight = u16::try_from(excess / schema.normalizer)
        .map_err(|_| SparseDefectSynthesisError::ArithmeticOverflow)?;
    if !schema.weights[..usize::from(schema.variables)].contains(&weight) {
        return Err(SparseDefectSynthesisError::ReplayMismatch);
    }
    Ok(Some(weight))
}

fn derive_schema<const CHOICES: usize, const SLOTS: usize>(
    observation: SparseAlphabetObservation<CHOICES, SLOTS>,
    candidate_budget: u64,
) -> Result<SparseDefectSchema, SparseDefectSynthesisError> {
    validate_observation(observation)?;
    if candidate_budget == 0 {
        return Err(SparseDefectSynthesisError::Budget);
    }
    let slot_entries = observation
        .slot_multiplicities
        .iter()
        .try_fold(0_u16, |sum, &value| sum.checked_add(u16::from(value)))
        .ok_or(SparseDefectSynthesisError::ArithmeticOverflow)?;
    let total_entries = slot_entries
        .checked_mul(u16::from(observation.block_count))
        .ok_or(SparseDefectSynthesisError::ArithmeticOverflow)?;
    let mut squares = [0_u32; CHOICES];
    let mut baseline = u32::MAX;
    for (index, &coefficient) in observation.coefficients.iter().enumerate() {
        let signed = i64::from(observation.fibre_size) - 2 * i64::from(coefficient);
        let square = signed
            .checked_mul(signed)
            .and_then(|value| u32::try_from(value).ok())
            .ok_or(SparseDefectSynthesisError::ArithmeticOverflow)?;
        squares[index] = square;
        baseline = baseline.min(square);
    }
    let mut normalizer = 0_u32;
    for square in squares {
        normalizer = gcd_u32(normalizer, square - baseline);
    }
    if normalizer == 0 {
        return Err(SparseDefectSynthesisError::NonIntegralDefect);
    }
    let baseline_total = u32::from(total_entries)
        .checked_mul(baseline)
        .ok_or(SparseDefectSynthesisError::ArithmeticOverflow)?;
    let excess = observation
        .signed_energy
        .checked_sub(baseline_total)
        .ok_or(SparseDefectSynthesisError::NonIntegralDefect)?;
    if excess % normalizer != 0 {
        return Err(SparseDefectSynthesisError::NonIntegralDefect);
    }
    let defect_target = excess / normalizer;

    let mut weights = [0_u16; MAX_BOUNDED_VARIABLES];
    let mut variables = 0_usize;
    for square in squares {
        let excess = square - baseline;
        if excess == 0 {
            continue;
        }
        let weight = u16::try_from(excess / normalizer)
            .map_err(|_| SparseDefectSynthesisError::ArithmeticOverflow)?;
        match weights[..variables].binary_search(&weight) {
            Ok(_) => {}
            Err(position) => {
                if variables == MAX_BOUNDED_VARIABLES {
                    return Err(SparseDefectSynthesisError::TooManyWeights);
                }
                weights.copy_within(position..variables, position + 1);
                weights[position] = weight;
                variables += 1;
            }
        }
    }
    if variables == 0 {
        return Err(SparseDefectSynthesisError::NonIntegralDefect);
    }
    let mut upper_bounds = [0_u16; MAX_BOUNDED_VARIABLES];
    let mut candidate_count = 1_u64;
    for index in 0..variables {
        let bound = (defect_target / u32::from(weights[index])).min(u32::from(total_entries));
        upper_bounds[index] =
            u16::try_from(bound).map_err(|_| SparseDefectSynthesisError::ArithmeticOverflow)?;
        candidate_count = candidate_count
            .checked_mul(u64::from(upper_bounds[index]) + 1)
            .ok_or(SparseDefectSynthesisError::ArithmeticOverflow)?;
    }
    if candidate_count > candidate_budget {
        return Err(SparseDefectSynthesisError::Budget);
    }
    Ok(SparseDefectSchema {
        weights,
        upper_bounds,
        baseline_square: baseline,
        normalizer,
        defect_target,
        candidate_count,
        total_entries,
        variables: variables as u8,
        provenance: observation.provenance,
    })
}

fn validate_observation<const CHOICES: usize, const SLOTS: usize>(
    observation: SparseAlphabetObservation<CHOICES, SLOTS>,
) -> Result<(), SparseDefectSynthesisError> {
    if CHOICES < 2
        || SLOTS == 0
        || observation.fibre_size == 0
        || observation.block_count == 0
        || observation
            .coefficients
            .iter()
            .any(|&value| value > observation.fibre_size)
        || observation.slot_multiplicities.contains(&0)
        || observation.provenance == ProvenanceClass::DirectWitness
    {
        return Err(SparseDefectSynthesisError::InvalidObservation);
    }
    Ok(())
}

const fn gcd_u32(mut left: u32, mut right: u32) -> u32 {
    while right != 0 {
        let remainder = left % right;
        left = right;
        right = remainder;
    }
    left
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn g53(provenance: ProvenanceClass) -> SparseAlphabetObservation<10, 10> {
        let arguments = (
            29,
            4,
            1_976,
            [0, 1, 7, 8, 14, 15, 21, 22, 28, 29],
            [1, 2, 2, 2, 2, 2, 2, 2, 2, 1],
        );
        if provenance.permits_pruning() {
            SparseAlphabetObservation::registered(
                arguments.0,
                arguments.1,
                arguments.2,
                arguments.3,
                arguments.4,
                provenance,
            )
            .unwrap()
        } else {
            SparseAlphabetObservation::observed(
                arguments.0,
                arguments.1,
                arguments.2,
                arguments.3,
                arguments.4,
                provenance,
            )
            .unwrap()
        }
    }

    fn g133() -> SparseAlphabetObservation<16, 10> {
        SparseAlphabetObservation::registered(
            29,
            4,
            1_976,
            [0, 1, 4, 5, 8, 9, 12, 13, 16, 17, 20, 21, 24, 25, 28, 29],
            [1, 1, 1, 1, 1, 1, 3, 3, 3, 3],
            ProvenanceClass::ProvedStructural,
        )
        .unwrap()
    }

    #[test]
    fn blindly_rediscovers_and_replays_g53_defect_theorem() {
        let observation = g53(ProvenanceClass::ProvedStructural);
        let derivation = synthesize_sparse_defects(observation, 1_000, 32).unwrap();
        let schema = derivation.schema();
        assert_eq!(schema.baseline_square(), 1);
        assert_eq!(schema.normalizer(), 56);
        assert_eq!(schema.defect_target(), 34);
        assert_eq!(&schema.weights()[..4], &[3, 4, 13, 15]);
        assert_eq!(derivation.profiles().len(), 10);
        assert!(schema.authorizes_pruning());
        replay_sparse_defects(observation, &derivation).unwrap();
    }

    #[test]
    fn same_generic_synthesizer_handles_g133_alphabet() {
        let observation = g133();
        let derivation = synthesize_sparse_defects(observation, 600_000, 10_000).unwrap();
        let schema = derivation.schema();
        assert_eq!(schema.baseline_square(), 9);
        assert_eq!(schema.normalizer(), 16);
        assert_eq!(schema.defect_target(), 83);
        assert_eq!(&schema.weights()[..7], &[1, 7, 10, 22, 27, 45, 52]);
        assert!(schema.authorizes_pruning());
        replay_sparse_defects(observation, &derivation).unwrap();
    }

    #[test]
    fn observed_candidate_never_acquires_pruning_authority() {
        let observed = g53(ProvenanceClass::ObservedEvolved);
        let derivation = synthesize_sparse_defects(observed, 1_000, 32).unwrap();
        assert!(!derivation.schema().authorizes_pruning());
        assert_eq!(
            derivation.schema().provenance(),
            ProvenanceClass::ObservedEvolved
        );
    }

    #[test]
    fn forged_schema_and_direct_witness_fail_closed() {
        let observation = g53(ProvenanceClass::ProvedStructural);
        let mut derivation = synthesize_sparse_defects(observation, 1_000, 32).unwrap();
        derivation.schema.normalizer = 28;
        assert_eq!(
            replay_sparse_defects(observation, &derivation),
            Err(SparseDefectSynthesisError::ReplayMismatch)
        );
        assert_eq!(
            SparseAlphabetObservation::observed(
                29,
                4,
                1_976,
                [0, 1, 7, 8, 14, 15, 21, 22, 28, 29],
                [1, 2, 2, 2, 2, 2, 2, 2, 2, 1],
                ProvenanceClass::DirectWitness,
            ),
            Err(SparseDefectSynthesisError::InvalidObservation)
        );

        let mut incomplete = synthesize_sparse_defects(observation, 1_000, 32).unwrap();
        incomplete.profiles = incomplete.profiles[..9].into();
        assert_eq!(
            replay_sparse_defects(observation, &incomplete),
            Err(SparseDefectSynthesisError::ReplayMismatch)
        );
    }

    #[test]
    fn explicit_candidate_budget_fails_before_enumeration() {
        assert_eq!(
            synthesize_sparse_defects(g53(ProvenanceClass::ProvedStructural), 971, 32),
            Err(SparseDefectSynthesisError::Budget)
        );
    }

    #[test]
    fn generated_weight_classifier_allocates_nothing() {
        let observation = g53(ProvenanceClass::ProvedStructural);
        let derivation = synthesize_sparse_defects(observation, 1_000, 32).unwrap();
        let (result, allocations) = tracked_allocations(|| {
            let mut sum = 0_u32;
            for _ in 0..1_000 {
                for &coefficient in &observation.coefficients {
                    sum += u32::from(
                        defect_weight(&derivation.schema(), 29, coefficient)
                            .unwrap()
                            .unwrap_or(0),
                    );
                }
            }
            sum
        });
        assert_eq!(allocations, 0);
        assert!(result > 0);
    }
}
