//! Private spike: lift evolved observations into small structural proofs.
//!
//! This module deliberately has no public-Ergodis authority. It tests the
//! architecture needed to turn a diagnostic predicate into a typed conjecture,
//! discharge it with registered theorem rules, and independently replay the
//! resulting compact derivation.

use serde::{Deserialize, Serialize};
use thiserror::Error;

use crate::proof_synthesis::{
    derive_horn_closure, derive_horn_closure_into, replay_horn_derivation, solve_sorted_square_sum,
    ExtractorDescriptor, IntegerLinearSystem, ProvenanceClass, RuleApplication, RuleSpec,
    SynthesisError,
};

const TARGET: i64 = 2092;
const ORBIT_SIZE: i64 = 14;
const FIXED_POINTS: i64 = 18;
const G91_ORDER29_CAMPAIGN_COMMITMENT: [u8; 32] = [
    0x74, 0x23, 0x8f, 0x6b, 0x16, 0x0c, 0x25, 0xd7, 0x43, 0xb8, 0x73, 0xc7, 0xf2, 0x90, 0x88, 0x28,
    0x95, 0x65, 0x19, 0x7d, 0x65, 0xe7, 0xd6, 0x46, 0xf4, 0x29, 0xb4, 0xb9, 0x58, 0x68, 0xbb, 0x92,
];
const G91_ORDER29_PARAMETER_DIGEST: [u8; 32] = [
    0xde, 0xec, 0xf3, 0xfc, 0x75, 0xab, 0xe4, 0x2a, 0x1f, 0x55, 0x20, 0xb9, 0x87, 0x54, 0x18, 0x5e,
    0x20, 0xa2, 0x68, 0x17, 0xee, 0xe4, 0x5c, 0xf2, 0x41, 0xe4, 0x23, 0x6c, 0xdf, 0x2a, 0x81, 0x3f,
];
const G91_ORDER29_EXTRACTOR_ID: [u8; 16] = *b"c1016-g91-q29-v1";

const FACT_OBSERVATION: u8 = 0;
const FACT_REGISTERED_EXTRACTOR: u8 = 1;
const FACT_CANONICAL_SEMANTICS: u8 = 2;
const FACT_QUADRATIC_INDEPENDENCE: u8 = 3;
const FACT_ORBIT_INVENTORY: u8 = 4;
const FACT_ROW_COUNTS: u8 = 5;
const FACT_SPECIAL_BALANCE: u8 = 6;
const FACT_THREE_SQUARE_EQUATION: u8 = 7;
const FACT_ENDPOINT: u8 = 8;

const Q29_RULES: [RuleSpec; 7] = [
    RuleSpec::registered(
        0x29_01,
        (1 << FACT_OBSERVATION) | (1 << FACT_REGISTERED_EXTRACTOR),
        FACT_CANONICAL_SEMANTICS,
    ),
    RuleSpec::registered(
        0x29_02,
        1 << FACT_CANONICAL_SEMANTICS,
        FACT_QUADRATIC_INDEPENDENCE,
    ),
    RuleSpec::registered(
        0x29_03,
        1 << FACT_REGISTERED_EXTRACTOR,
        FACT_ORBIT_INVENTORY,
    ),
    RuleSpec::registered(0x29_04, 1 << FACT_ORBIT_INVENTORY, FACT_ROW_COUNTS),
    RuleSpec::registered(
        0x29_05,
        (1 << FACT_QUADRATIC_INDEPENDENCE) | (1 << FACT_ROW_COUNTS),
        FACT_SPECIAL_BALANCE,
    ),
    RuleSpec::registered(
        0x29_06,
        (1 << FACT_ROW_COUNTS) | (1 << FACT_SPECIAL_BALANCE),
        FACT_THREE_SQUARE_EQUATION,
    ),
    RuleSpec::registered(0x29_07, 1 << FACT_THREE_SQUARE_EQUATION, FACT_ENDPOINT),
];

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub enum SemanticType {
    Integer,
    QuadraticCoefficient { radicand: i16 },
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub enum SemanticField {
    RootOrbit,
    EnergyConstantSum,
    EnergyRadicalSum,
}

impl SemanticField {
    const fn value_type(self) -> SemanticType {
        match self {
            Self::RootOrbit | Self::EnergyConstantSum => SemanticType::Integer,
            Self::EnergyRadicalSum => SemanticType::QuadraticCoefficient { radicand: 29 },
        }
    }
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub enum ObservedClause {
    Equal { field: String, value: i64 },
    AbsoluteAtMost { field: String, bound: i64 },
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub enum TypedClause {
    Equal {
        field: SemanticField,
        value_type: SemanticType,
        value: i64,
    },
    AbsoluteAtMost {
        field: SemanticField,
        value_type: SemanticType,
        bound: i64,
    },
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct ExtractorBinding {
    descriptor: ExtractorDescriptor,
    carrier: u16,
    generator: u16,
    character_order: u8,
    source_commitment: [u8; 32],
}

impl ExtractorBinding {
    /// The only extractor admitted by this spike. Construction is typed rather
    /// than selected by a presentation column name.
    #[must_use]
    pub const fn generator_91_order_29() -> Self {
        Self {
            descriptor: ExtractorDescriptor::registered(
                G91_ORDER29_EXTRACTOR_ID,
                1,
                G91_ORDER29_PARAMETER_DIGEST,
                G91_ORDER29_CAMPAIGN_COMMITMENT,
            ),
            carrier: 522,
            generator: 91,
            character_order: 29,
            source_commitment: G91_ORDER29_CAMPAIGN_COMMITMENT,
        }
    }

    fn registered(self) -> bool {
        self.descriptor.identity() == G91_ORDER29_EXTRACTOR_ID
            && self.descriptor.version() == 1
            && self.descriptor.parameter_digest() == G91_ORDER29_PARAMETER_DIGEST
            && self.descriptor.source_commitment() == G91_ORDER29_CAMPAIGN_COMMITMENT
            && self.carrier == 522
            && self.generator == 91
            && self.character_order == 29
            && self.source_commitment == G91_ORDER29_CAMPAIGN_COMMITMENT
    }
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct Order29BlockCounts {
    pub fixed_selected: u8,
    pub residue_orbits_selected: u8,
    pub nonresidue_orbits_selected: u8,
}

impl Order29BlockCounts {
    const fn minus_count(self) -> i64 {
        self.fixed_selected as i64
            + ORBIT_SIZE
                * (self.residue_orbits_selected as i64 + self.nonresidue_orbits_selected as i64)
    }

    const fn field_coordinates(self) -> (i64, i64) {
        (
            2 * self.fixed_selected as i64
                - self.residue_orbits_selected as i64
                - self.nonresidue_orbits_selected as i64,
            self.residue_orbits_selected as i64 - self.nonresidue_orbits_selected as i64,
        )
    }

    const fn energy_coordinates(self) -> (i64, i64) {
        let (rational, radical) = self.field_coordinates();
        (
            rational * rational + 29 * radical * radical,
            2 * rational * radical,
        )
    }
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct Order29Quartet {
    pub blocks: [Order29BlockCounts; 4],
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct PresentedFields {
    pub root_orbit: i64,
    pub constant_sum: i64,
    pub radical_sum: i64,
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct ExtractedFields {
    pub root_orbit: i64,
    pub constant_sum: i64,
    pub radical_sum: i64,
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub enum ProofObligation {
    RegisteredExtractor,
    CanonicalFieldSemantics,
    QuadraticBasisIndependent,
    OrbitInventory,
    RowSumCounts,
    ThreeSquareEndpoint,
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub enum DerivationStep {
    LiftObservedPredicate,
    RecomputeCanonicalFields,
    SeparateQuadraticCoefficients,
    DeriveFixedAndNonzeroOrbitCounts,
    CancelSpecialRadicalCoefficient,
    ReduceToThreeSquares { target: u8 },
    EnumerateThreeSquareSolutions,
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub enum ProofStatus {
    Candidate,
    ProofSkeleton,
    Proved,
}

#[derive(Clone, Copy, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub enum TheoremGoal {
    QuadraticEnergySumEqualsRational { target: i64, radicand: i16 },
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct StructuralProof {
    pub extractor: ExtractorBinding,
    pub goal: TheoremGoal,
    pub lifted_clauses: Box<[TypedClause]>,
    pub obligations: Box<[ProofObligation]>,
    pub derivation: Box<[DerivationStep]>,
    pub rule_transcript: Box<[RuleApplication]>,
    pub special_balance: i8,
    pub three_square_target: u8,
    pub unordered_absolute_solutions: Box<[[u8; 3]]>,
    pub energy_profiles: Box<[[u16; 4]]>,
    pub status: ProofStatus,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum ProofError {
    #[error("extractor is not sealed and registered for this theorem")]
    UnregisteredExtractor,
    #[error("evolved field has no canonical semantic binding: {0}")]
    UnknownField(String),
    #[error("evolved predicate does not contain the expected structural shape")]
    UnsupportedObservation,
    #[error("presented field values disagree with independent extraction")]
    SemanticMismatch,
    #[error("order-29 orbit counts violate the registered domain")]
    InvalidOrbitCounts,
    #[error("structural derivation did not replay")]
    InvalidDerivation,
    #[error("generic synthesis failed: {0}")]
    Synthesis(#[from] SynthesisError),
}

#[must_use]
pub fn extract_order_29_fields(quartet: &Order29Quartet) -> ExtractedFields {
    let (constant_sum, radical_sum) = quartet
        .blocks
        .iter()
        .map(|block| block.energy_coordinates())
        .fold((0_i64, 0_i64), |sum, value| {
            (sum.0 + value.0, sum.1 + value.1)
        });
    ExtractedFields {
        root_orbit: 3,
        constant_sum,
        radical_sum,
    }
}

pub fn verify_presented_fields(
    binding: ExtractorBinding,
    quartet: &Order29Quartet,
    presented: PresentedFields,
) -> Result<ExtractedFields, ProofError> {
    if !binding.registered() {
        return Err(ProofError::UnregisteredExtractor);
    }
    validate_quartet_domain(quartet)?;
    let extracted = extract_order_29_fields(quartet);
    if presented.root_orbit != extracted.root_orbit
        || presented.constant_sum != extracted.constant_sum
        || presented.radical_sum != extracted.radical_sum
    {
        return Err(ProofError::SemanticMismatch);
    }
    Ok(extracted)
}

pub fn synthesize_generator_91_order_29_proof(
    binding: ExtractorBinding,
    observed: &[ObservedClause],
) -> Result<StructuralProof, ProofError> {
    if !binding.registered() {
        return Err(ProofError::UnregisteredExtractor);
    }
    let lifted = observed
        .iter()
        .map(lift_clause)
        .collect::<Result<Vec<_>, _>>()?;
    let has_constant_target = lifted.iter().any(|clause| {
        matches!(
            clause,
            TypedClause::Equal {
                field: SemanticField::EnergyConstantSum,
                value: TARGET,
                ..
            }
        )
    });
    let has_radical_observation = lifted.iter().any(|clause| {
        matches!(
            clause,
            TypedClause::Equal {
                field: SemanticField::EnergyRadicalSum,
                ..
            } | TypedClause::AbsoluteAtMost {
                field: SemanticField::EnergyRadicalSum,
                ..
            }
        )
    });
    if !has_constant_target || !has_radical_observation {
        return Err(ProofError::UnsupportedObservation);
    }

    let solutions = generic_three_square_solutions(18)?;
    if solutions.as_slice() != [[0, 3, 3], [1, 1, 4]] {
        return Err(ProofError::InvalidDerivation);
    }
    let initial_facts = (1 << FACT_OBSERVATION) | (1 << FACT_REGISTERED_EXTRACTOR);
    let horn = derive_horn_closure(initial_facts, 1 << FACT_ENDPOINT, &Q29_RULES, 7)?;
    let proof = StructuralProof {
        extractor: binding,
        goal: TheoremGoal::QuadraticEnergySumEqualsRational {
            target: TARGET,
            radicand: 29,
        },
        lifted_clauses: lifted.into_boxed_slice(),
        obligations: vec![
            ProofObligation::RegisteredExtractor,
            ProofObligation::CanonicalFieldSemantics,
            ProofObligation::QuadraticBasisIndependent,
            ProofObligation::OrbitInventory,
            ProofObligation::RowSumCounts,
            ProofObligation::ThreeSquareEndpoint,
        ]
        .into_boxed_slice(),
        derivation: vec![
            DerivationStep::LiftObservedPredicate,
            DerivationStep::RecomputeCanonicalFields,
            DerivationStep::SeparateQuadraticCoefficients,
            DerivationStep::DeriveFixedAndNonzeroOrbitCounts,
            DerivationStep::CancelSpecialRadicalCoefficient,
            DerivationStep::ReduceToThreeSquares { target: 18 },
            DerivationStep::EnumerateThreeSquareSolutions,
        ]
        .into_boxed_slice(),
        rule_transcript: horn.applications,
        special_balance: 0,
        three_square_target: 18,
        unordered_absolute_solutions: solutions.into_boxed_slice(),
        energy_profiles: Box::new([[4, 0, 1044, 1044], [4, 116, 116, 1856]]),
        status: ProofStatus::Proved,
        provenance: ProvenanceClass::ProvedStructural,
    };
    verify_structural_proof(&proof)?;
    Ok(proof)
}

pub fn verify_structural_proof(proof: &StructuralProof) -> Result<(), ProofError> {
    if !proof.extractor.registered()
        || proof.goal
            != (TheoremGoal::QuadraticEnergySumEqualsRational {
                target: TARGET,
                radicand: 29,
            })
        || proof.status != ProofStatus::Proved
        || proof.provenance != ProvenanceClass::ProvedStructural
        || proof.special_balance != 0
        || proof.three_square_target != 18
    {
        return Err(ProofError::InvalidDerivation);
    }
    let expected_steps = [
        DerivationStep::LiftObservedPredicate,
        DerivationStep::RecomputeCanonicalFields,
        DerivationStep::SeparateQuadraticCoefficients,
        DerivationStep::DeriveFixedAndNonzeroOrbitCounts,
        DerivationStep::CancelSpecialRadicalCoefficient,
        DerivationStep::ReduceToThreeSquares { target: 18 },
        DerivationStep::EnumerateThreeSquareSolutions,
    ];
    let (solutions, profiles) = replay_q29_structural_arithmetic()?;
    let initial_facts = (1 << FACT_OBSERVATION) | (1 << FACT_REGISTERED_EXTRACTOR);
    replay_horn_derivation(
        initial_facts,
        1 << FACT_ENDPOINT,
        &Q29_RULES,
        &proof.rule_transcript,
    )?;
    if proof.derivation.as_ref() != expected_steps
        || proof.unordered_absolute_solutions.as_ref() != solutions
        || proof.energy_profiles.as_ref() != profiles
        || !has_typed_target_and_radical_observation(&proof.lifted_clauses)
    {
        return Err(ProofError::InvalidDerivation);
    }
    Ok(())
}

/// Allocation-free rule-closure compilation kernel for the registered q29
/// adapter. Full arithmetic discharge remains a cold-path verification step.
pub fn derive_generator_91_rule_transcript_into(
    workspace: &mut [RuleApplication],
) -> Result<(u64, usize), ProofError> {
    let initial_facts = (1 << FACT_OBSERVATION) | (1 << FACT_REGISTERED_EXTRACTOR);
    derive_horn_closure_into(
        initial_facts,
        1 << FACT_ENDPOINT,
        &Q29_RULES,
        Q29_RULES.len() as u32,
        workspace,
    )
    .map_err(ProofError::from)
}

/// Allocation-free replay kernel against the sealed q29 rule registry.
pub fn replay_generator_91_rule_transcript(
    applications: &[RuleApplication],
) -> Result<u64, ProofError> {
    let initial_facts = (1 << FACT_OBSERVATION) | (1 << FACT_REGISTERED_EXTRACTOR);
    replay_horn_derivation(initial_facts, 1 << FACT_ENDPOINT, &Q29_RULES, applications)
        .map_err(ProofError::from)
}

fn has_typed_target_and_radical_observation(clauses: &[TypedClause]) -> bool {
    let target = clauses.iter().any(|clause| {
        matches!(
            clause,
            TypedClause::Equal {
                field: SemanticField::EnergyConstantSum,
                value_type: SemanticType::Integer,
                value: TARGET,
            }
        )
    });
    let radical = clauses.iter().any(|clause| {
        matches!(
            clause,
            TypedClause::Equal {
                field: SemanticField::EnergyRadicalSum,
                value_type: SemanticType::QuadraticCoefficient { radicand: 29 },
                ..
            } | TypedClause::AbsoluteAtMost {
                field: SemanticField::EnergyRadicalSum,
                value_type: SemanticType::QuadraticCoefficient { radicand: 29 },
                ..
            }
        )
    });
    target && radical
}

fn replay_q29_structural_arithmetic() -> Result<(Vec<[u8; 3]>, Vec<[u16; 4]>), ProofError> {
    let special_counts = row_sum_orbit_solutions(260);
    let zero_counts = row_sum_orbit_solutions(261);
    if special_counts != [(8, 18)] || zero_counts != [(9, 18)] {
        return Err(ProofError::InvalidDerivation);
    }
    let special_rational = 2 * special_counts[0].0 - special_counts[0].1;
    let zero_rational = 2 * zero_counts[0].0 - zero_counts[0].1;
    if special_rational != -2 || zero_rational != 0 {
        return Err(ProofError::InvalidDerivation);
    }

    // Equality with the rational target in Q(sqrt(29)) makes the radical
    // coefficient zero. The zero blocks have rational coordinate zero, so
    // their energy radical coefficients vanish. What remains is
    // 2*(-2)*B_special=0.
    let special_coefficient = 2 * special_rational;
    if special_coefficient == 0 {
        return Err(ProofError::InvalidDerivation);
    }
    let special_system = IntegerLinearSystem::new(1, &[(&[special_coefficient], 0)])?;
    let special_solution = special_system.solve_unique_integer()?;
    let special_balance = special_solution[0];
    let special_constant = special_rational * special_rational + 29 * special_balance.pow(2);
    let remaining_constant = TARGET - special_constant;
    if remaining_constant != 2088 || remaining_constant % (29 * 4) != 0 {
        return Err(ProofError::InvalidDerivation);
    }
    // Each zero block selects 18 nonzero orbits, so its Legendre-class balance
    // is even. Substitution B_i=2*b_i gives the small endpoint below.
    let three_square_target = (remaining_constant / (29 * 4)) as u8;
    let solutions = generic_three_square_solutions(three_square_target)?;
    let profiles = solutions
        .iter()
        .map(|solution| {
            let mut zero_energies = solution.map(|value| 29_u16 * (2 * u16::from(value)).pow(2));
            zero_energies.sort_unstable();
            [
                special_constant as u16,
                zero_energies[0],
                zero_energies[1],
                zero_energies[2],
            ]
        })
        .collect::<Vec<_>>();
    if three_square_target != 18 || solutions != [[0, 3, 3], [1, 1, 4]] {
        return Err(ProofError::InvalidDerivation);
    }
    Ok((solutions, profiles))
}

fn row_sum_orbit_solutions(minus_total: i64) -> Vec<(i64, i64)> {
    let mut solutions = Vec::new();
    for fixed in 0..=FIXED_POINTS {
        let remaining = minus_total - fixed;
        if remaining >= 0 && remaining % ORBIT_SIZE == 0 {
            solutions.push((fixed, remaining / ORBIT_SIZE));
        }
    }
    solutions
}

fn lift_clause(clause: &ObservedClause) -> Result<TypedClause, ProofError> {
    let (name, constructor): (&str, fn(SemanticField, SemanticType, i64) -> TypedClause) =
        match clause {
            ObservedClause::Equal { field, .. } => {
                (field, |field, value_type, value| TypedClause::Equal {
                    field,
                    value_type,
                    value,
                })
            }
            ObservedClause::AbsoluteAtMost { field, .. } => (field, |field, value_type, bound| {
                TypedClause::AbsoluteAtMost {
                    field,
                    value_type,
                    bound,
                }
            }),
        };
    let field = match name {
        "root_orbit" => SemanticField::RootOrbit,
        "constant_sum" => SemanticField::EnergyConstantSum,
        "radical_sum" | "radical_abs" => SemanticField::EnergyRadicalSum,
        _ => return Err(ProofError::UnknownField(name.to_owned())),
    };
    let value = match clause {
        ObservedClause::Equal { value, .. } => *value,
        ObservedClause::AbsoluteAtMost { bound, .. } => *bound,
    };
    Ok(constructor(field, field.value_type(), value))
}

fn validate_quartet_domain(quartet: &Order29Quartet) -> Result<(), ProofError> {
    for (index, block) in quartet.blocks.iter().enumerate() {
        let expected_minus = if index == 0 { 260 } else { 261 };
        if block.fixed_selected as i64 > FIXED_POINTS
            || block.residue_orbits_selected > 18
            || block.nonresidue_orbits_selected > 18
            || block.minus_count() != expected_minus
        {
            return Err(ProofError::InvalidOrbitCounts);
        }
    }
    Ok(())
}

fn generic_three_square_solutions(target: u8) -> Result<Vec<[u8; 3]>, ProofError> {
    solve_sorted_square_sum(3, u32::from(target), 1_000)?
        .solutions
        .iter()
        .map(|solution| {
            let values: [u16; 3] = solution
                .as_ref()
                .try_into()
                .map_err(|_| ProofError::InvalidDerivation)?;
            Ok([
                u8::try_from(values[0]).map_err(|_| ProofError::InvalidDerivation)?,
                u8::try_from(values[1]).map_err(|_| ProofError::InvalidDerivation)?,
                u8::try_from(values[2]).map_err(|_| ProofError::InvalidDerivation)?,
            ])
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    fn observation() -> [ObservedClause; 2] {
        [
            ObservedClause::Equal {
                field: "constant_sum".into(),
                value: 2092,
            },
            ObservedClause::AbsoluteAtMost {
                field: "radical_abs".into(),
                bound: 2,
            },
        ]
    }

    #[test]
    fn q29_observation_lifts_to_stronger_structural_proof() {
        let proof = synthesize_generator_91_order_29_proof(
            ExtractorBinding::generator_91_order_29(),
            &observation(),
        )
        .unwrap();
        assert_eq!(proof.status, ProofStatus::Proved);
        assert_eq!(proof.special_balance, 0);
        assert_eq!(
            proof.unordered_absolute_solutions.as_ref(),
            [[0, 3, 3], [1, 1, 4]]
        );
        verify_structural_proof(&proof).unwrap();
    }

    #[test]
    fn correct_field_names_with_false_values_are_rejected() {
        let quartet = Order29Quartet {
            blocks: [
                Order29BlockCounts {
                    fixed_selected: 8,
                    residue_orbits_selected: 9,
                    nonresidue_orbits_selected: 9,
                },
                Order29BlockCounts {
                    fixed_selected: 9,
                    residue_orbits_selected: 9,
                    nonresidue_orbits_selected: 9,
                },
                Order29BlockCounts {
                    fixed_selected: 9,
                    residue_orbits_selected: 12,
                    nonresidue_orbits_selected: 6,
                },
                Order29BlockCounts {
                    fixed_selected: 9,
                    residue_orbits_selected: 6,
                    nonresidue_orbits_selected: 12,
                },
            ],
        };
        let false_presentation = PresentedFields {
            root_orbit: 3,
            constant_sum: 2092,
            radical_sum: 7,
        };
        assert_eq!(
            verify_presented_fields(
                ExtractorBinding::generator_91_order_29(),
                &quartet,
                false_presentation,
            ),
            Err(ProofError::SemanticMismatch)
        );
    }

    #[test]
    fn unknown_feature_name_does_not_gain_semantics() {
        let observed = [ObservedClause::Equal {
            field: "looks_like_radical_sum".into(),
            value: 0,
        }];
        assert!(matches!(
            synthesize_generator_91_order_29_proof(
                ExtractorBinding::generator_91_order_29(),
                &observed,
            ),
            Err(ProofError::UnknownField(_))
        ));
    }

    #[test]
    fn forged_extractor_version_is_rejected() {
        let mut binding = ExtractorBinding::generator_91_order_29();
        binding.descriptor = ExtractorDescriptor::registered(
            G91_ORDER29_EXTRACTOR_ID,
            2,
            G91_ORDER29_PARAMETER_DIGEST,
            G91_ORDER29_CAMPAIGN_COMMITMENT,
        );
        assert_eq!(
            synthesize_generator_91_order_29_proof(binding, &observation()),
            Err(ProofError::UnregisteredExtractor)
        );
    }

    #[test]
    fn mutated_derivation_fails_independent_replay() {
        let mut proof = synthesize_generator_91_order_29_proof(
            ExtractorBinding::generator_91_order_29(),
            &observation(),
        )
        .unwrap();
        proof.three_square_target = 19;
        assert_eq!(
            verify_structural_proof(&proof),
            Err(ProofError::InvalidDerivation)
        );
    }

    #[test]
    fn heuristic_provenance_cannot_replay_as_structural_authority() {
        let mut proof = synthesize_generator_91_order_29_proof(
            ExtractorBinding::generator_91_order_29(),
            &observation(),
        )
        .unwrap();
        proof.provenance = ProvenanceClass::HeuristicSearch;
        assert_eq!(
            verify_structural_proof(&proof),
            Err(ProofError::InvalidDerivation)
        );
    }
}
