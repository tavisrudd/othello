#![allow(clippy::cast_possible_truncation)] // Frozen q=13 enumerations have small exact bounds.

use std::collections::{BTreeMap, BTreeSet};

use serde::{Deserialize, Serialize};

use crate::{
    CanonicalArtifact, DeclaredAction, FiniteFieldSpec, GatedPaperIv, InputArtifact, ProfileInput,
    ShadowError, VerificationReport, WeightedPair, canonicalize, verify_canonical_artifact,
};

pub const RECONSTRUCTION_SCHEMA_VERSION: &str = "sparse-shadow-reconstruction/v2";
pub const PAPER_I_CARRIER_SCHEMA_VERSION: &str = "sparse-shadow-paper-i-carrier/v1";
pub const PAPER_II_CARRIER_SCHEMA_VERSION: &str = "sparse-shadow-paper-ii-carrier/v1";
pub const PAPER_II_RECONSTRUCTION_SCHEMA_VERSION: &str = "sparse-shadow-paper-ii-reconstruction/v1";
pub const PAPER_III_CARRIER_SCHEMA_VERSION: &str = "sparse-shadow-paper-iii-carrier/v1";
pub const PAPER_III_RECONSTRUCTION_SCHEMA_VERSION: &str =
    "sparse-shadow-paper-iii-reconstruction/v1";
pub const PAPER_IV_CARRIER_SCHEMA_VERSION: &str = "sparse-shadow-paper-iv-carrier/v1";
pub const PAPER_IV_RECONSTRUCTION_SCHEMA_VERSION: &str = "sparse-shadow-paper-iv-reconstruction/v1";
pub const PAPER_V_CARRIER_SCHEMA_VERSION: &str = "sparse-shadow-paper-v-carrier/v1";
pub const PAPER_V_RECONSTRUCTION_SCHEMA_VERSION: &str = "sparse-shadow-paper-v-reconstruction/v1";

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(tag = "kind", rename_all = "snake_case", deny_unknown_fields)]
pub enum Ambiguity {
    OrientationC2 { killed_by_calibration: bool },
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaperICarrier {
    pub schema: String,
    pub axes: Vec<[u32; 2]>,
    pub conference_switching_class: String,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ReconstructionArtifact {
    pub schema: String,
    pub profile: String,
    pub carrier: PaperICarrier,
    pub ambiguity: Ambiguity,
    pub exact_oriented_return: bool,
    pub round_trip_shadow: InputArtifact,
    pub canonical: CanonicalArtifact,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaperIiCarrier {
    pub schema: String,
    pub field: FiniteFieldSpec,
    pub endpoint_count: u32,
    pub matchings: Vec<Vec<[u32; 2]>>,
    pub oriented_sheets: [Vec<u32>; 2],
    pub full_action_order: u64,
    pub oriented_stabilizer_order: u64,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaperIiReconstructionArtifact {
    pub schema: String,
    pub profile: String,
    pub carrier: PaperIiCarrier,
    pub ambiguity: Ambiguity,
    pub exact_oriented_return: bool,
    pub round_trip_shadow: InputArtifact,
    pub canonical: CanonicalArtifact,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaperIiiCarrier {
    pub schema: String,
    pub branch_sextic: String,
    pub rational_fibre_point: Vec<crate::RationalCoefficient>,
    pub fibre_quadratic_algebra: String,
    pub aligned_four_sets: Vec<[u32; 4]>,
    pub recovered_twist: String,
    pub recovered_two_graph: String,
    pub calibrated_triangle_product: i8,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaperIiiAmbiguity {
    pub twist_numerator: String,
    pub twist_denominator: String,
    pub complement_killed_by_calibration: bool,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaperIiiReconstructionArtifact {
    pub schema: String,
    pub profile: String,
    pub carrier: PaperIiiCarrier,
    pub ambiguity: PaperIiiAmbiguity,
    pub exact_oriented_return: bool,
    pub round_trip_shadow: InputArtifact,
    pub canonical: CanonicalArtifact,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaperVCarrier {
    pub schema: String,
    pub verification_field: FiniteFieldSpec,
    pub six_axes: Vec<Vec<u32>>,
    pub chordal_quartic_points: Vec<Vec<u32>>,
    pub conference_cubic: Vec<u32>,
    pub chordal_cubic: Vec<u32>,
    pub delta_matrix: Vec<Vec<crate::RationalCoefficient>>,
    pub conference_positive_edges: Vec<[u32; 2]>,
    pub outer_lift: Vec<u32>,
    pub selected_chordal_line: u32,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaperVReconstructionArtifact {
    pub schema: String,
    pub profile: String,
    pub carrier: PaperVCarrier,
    pub ambiguity: Ambiguity,
    pub exact_marked_return: bool,
    pub round_trip_shadow: InputArtifact,
    pub canonical: CanonicalArtifact,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaperIvRelation {
    pub rho: u32,
    pub pair_multiplicity: u32,
    pub edges: Vec<[u32; 2]>,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaperIvCarrier {
    pub schema: String,
    pub field: FiniteFieldSpec,
    pub points: Vec<[u32; 3]>,
    pub lines: Vec<[u32; 3]>,
    pub incidence_rows: Vec<Vec<u32>>,
    pub conic_points: Vec<u32>,
    pub polarity_point_to_line: Vec<u32>,
    pub shadow_coordinate_to_internal_point: Vec<u32>,
    pub shadow_coordinate_to_passant_line: Vec<u32>,
    pub passant_incidence_rows: Vec<Vec<u32>>,
    pub elliptic_relations: Vec<PaperIvRelation>,
    pub binary_code_rank: u32,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct MarkingTorsor {
    pub group: String,
    pub order: u64,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaperIvReconstructionArtifact {
    pub schema: String,
    pub profile: String,
    pub carrier: PaperIvCarrier,
    pub ambiguity: MarkingTorsor,
    pub round_trip_shadow: InputArtifact,
    pub canonical: CanonicalArtifact,
}

/// Reconstruct the carrier and state the exact residual ambiguity.
///
/// # Errors
///
/// Returns an error when validation or canonicalization fails, or when the
/// selected profile is not enabled.
pub fn reconstruct(input: &InputArtifact) -> Result<ReconstructionArtifact, ShadowError> {
    let canonical = canonicalize(input)?;
    let ProfileInput::PaperIOrientation(paper) = &input.profile else {
        return Err(ShadowError::Invalid(
            "reconstruction called for a gated profile".into(),
        ));
    };
    let calibrated = paper.calibrated_triangle.is_some();
    let carrier = recover_paper_i_carrier(&canonical.canonical)?;
    Ok(ReconstructionArtifact {
        schema: RECONSTRUCTION_SCHEMA_VERSION.into(),
        profile: "paper_i_orientation".into(),
        carrier,
        ambiguity: Ambiguity::OrientationC2 {
            killed_by_calibration: calibrated,
        },
        exact_oriented_return: calibrated,
        round_trip_shadow: canonical.canonical.clone(),
        canonical,
    })
}

/// Reconstruct the Paper-II matching carrier and its calibrated sheet orientation.
///
/// # Errors
///
/// Returns an error if validation, canonicalization, or carrier recovery fails.
pub fn reconstruct_paper_ii(
    input: &InputArtifact,
) -> Result<PaperIiReconstructionArtifact, ShadowError> {
    let canonical = canonicalize(input)?;
    let carrier = recover_paper_ii_carrier(&canonical.canonical)?;
    Ok(PaperIiReconstructionArtifact {
        schema: PAPER_II_RECONSTRUCTION_SCHEMA_VERSION.into(),
        profile: "paper_ii_trade".into(),
        carrier,
        ambiguity: Ambiguity::OrientationC2 {
            killed_by_calibration: true,
        },
        exact_oriented_return: true,
        round_trip_shadow: canonical.canonical.clone(),
        canonical,
    })
}

/// Reconstruct Paper III's quadratic twist and calibrated conference two-graph.
///
/// # Errors
///
/// Returns an error if validation, canonicalization, or carrier recovery fails.
pub fn reconstruct_paper_iii(
    input: &InputArtifact,
) -> Result<PaperIiiReconstructionArtifact, ShadowError> {
    let canonical = canonicalize(input)?;
    let carrier = recover_paper_iii_carrier(&canonical.canonical)?;
    let ProfileInput::PaperIiiFourShadow(value) = &canonical.canonical.profile else {
        unreachable!("Paper-III canonicalization preserves the profile")
    };
    let crate::AmbiguitySpec::HomogeneousFibre {
        numerator,
        denominator,
    } = &value.twist_ambiguity
    else {
        unreachable!("validated Paper-III twist ambiguity")
    };
    Ok(PaperIiiReconstructionArtifact {
        schema: PAPER_III_RECONSTRUCTION_SCHEMA_VERSION.into(),
        profile: "paper_iii_four_shadow".into(),
        carrier,
        ambiguity: PaperIiiAmbiguity {
            twist_numerator: numerator.clone(),
            twist_denominator: denominator.clone(),
            complement_killed_by_calibration: true,
        },
        exact_oriented_return: true,
        round_trip_shadow: canonical.canonical.clone(),
        canonical,
    })
}

/// Independently replay a Paper-III carrier reconstruction.
///
/// # Errors
///
/// Returns an error if the canonical proof, carrier, round trip, or ambiguity is corrupt.
pub fn verify_paper_iii_reconstruction(
    input: &InputArtifact,
    artifact: &PaperIiiReconstructionArtifact,
) -> Result<VerificationReport, ShadowError> {
    if artifact.schema != PAPER_III_RECONSTRUCTION_SCHEMA_VERSION
        || artifact.profile != "paper_iii_four_shadow"
        || !artifact.ambiguity.complement_killed_by_calibration
        || !artifact.exact_oriented_return
    {
        return Err(ShadowError::Certificate(
            "Paper-III reconstruction metadata is inconsistent".into(),
        ));
    }
    let report = verify_canonical_artifact(input, &artifact.canonical)?;
    let ProfileInput::PaperIiiFourShadow(value) = &artifact.canonical.canonical.profile else {
        return Err(ShadowError::Certificate(
            "Paper-III reconstruction contains another profile".into(),
        ));
    };
    let crate::AmbiguitySpec::HomogeneousFibre {
        numerator,
        denominator,
    } = &value.twist_ambiguity
    else {
        return Err(ShadowError::Certificate(
            "Paper-III twist ambiguity is corrupt".into(),
        ));
    };
    if artifact.ambiguity.twist_numerator != *numerator
        || artifact.ambiguity.twist_denominator != *denominator
        || artifact.carrier != recover_paper_iii_carrier(&artifact.canonical.canonical)?
        || artifact.round_trip_shadow != artifact.canonical.canonical
    {
        return Err(ShadowError::Certificate(
            "Paper-III carrier, ambiguity, or round trip is corrupt".into(),
        ));
    }
    Ok(report)
}

fn recover_paper_iii_carrier(input: &InputArtifact) -> Result<PaperIiiCarrier, ShadowError> {
    let ProfileInput::PaperIiiFourShadow(value) = &input.profile else {
        return Err(ShadowError::Invalid(
            "Paper-III reconstruction received another profile".into(),
        ));
    };
    Ok(PaperIiiCarrier {
        schema: PAPER_III_CARRIER_SCHEMA_VERSION.into(),
        branch_sextic: value.branch_sextic.clone(),
        rational_fibre_point: value.rational_fibre_point.clone(),
        fibre_quadratic_algebra: value.fibre_quadratic_algebra.clone(),
        aligned_four_sets: value.aligned_four_sets.clone(),
        recovered_twist: value.recovered_twist.clone(),
        recovered_two_graph: value.recovered_two_graph.clone(),
        calibrated_triangle_product: value
            .calibrated_triangle_product
            .expect("validated Paper-III calibration"),
    })
}

/// Independently replay a Paper-II carrier reconstruction.
///
/// # Errors
///
/// Returns an error if the canonical proof, carrier, round trip, or ambiguity is corrupt.
pub fn verify_paper_ii_reconstruction(
    input: &InputArtifact,
    artifact: &PaperIiReconstructionArtifact,
) -> Result<VerificationReport, ShadowError> {
    if artifact.schema != PAPER_II_RECONSTRUCTION_SCHEMA_VERSION
        || artifact.profile != "paper_ii_trade"
        || artifact.ambiguity
            != (Ambiguity::OrientationC2 {
                killed_by_calibration: true,
            })
        || !artifact.exact_oriented_return
    {
        return Err(ShadowError::Certificate(
            "Paper-II reconstruction metadata is inconsistent".into(),
        ));
    }
    let report = verify_canonical_artifact(input, &artifact.canonical)?;
    if artifact.carrier != recover_paper_ii_carrier(&artifact.canonical.canonical)?
        || artifact.round_trip_shadow != artifact.canonical.canonical
    {
        return Err(ShadowError::Certificate(
            "Paper-II carrier or round trip is corrupt".into(),
        ));
    }
    Ok(report)
}

fn recover_paper_ii_carrier(input: &InputArtifact) -> Result<PaperIiCarrier, ShadowError> {
    let ProfileInput::PaperIiTrade(value) = &input.profile else {
        return Err(ShadowError::Invalid(
            "Paper-II reconstruction received another profile".into(),
        ));
    };
    let mut indexed = value
        .trade_halves
        .iter()
        .enumerate()
        .flat_map(|(sheet, half)| half.iter().map(move |block| (sheet, block)))
        .collect::<Vec<_>>();
    indexed.sort_unstable_by_key(|(_, block)| block.support.clone());
    let mut matchings = Vec::with_capacity(22);
    let mut oriented_sheets = [Vec::new(), Vec::new()];
    for (index, (sheet, block)) in indexed.into_iter().enumerate() {
        let matching = block
            .support
            .iter()
            .map(|&edge| [edge / 12, edge % 12])
            .collect::<Vec<_>>();
        matchings.push(matching);
        oriented_sheets[sheet].push(index as u32);
    }
    Ok(PaperIiCarrier {
        schema: PAPER_II_CARRIER_SCHEMA_VERSION.into(),
        field: value.field.clone(),
        endpoint_count: 12,
        matchings,
        oriented_sheets,
        full_action_order: 1320,
        oriented_stabilizer_order: 660,
    })
}

/// Reconstruct Paper V's marked chordal/conference carrier.
///
/// # Errors
///
/// Returns an error if validation, canonicalization, or carrier recovery fails.
pub fn reconstruct_paper_v(
    input: &InputArtifact,
) -> Result<PaperVReconstructionArtifact, ShadowError> {
    let canonical = canonicalize(input)?;
    let carrier = recover_paper_v_carrier(&canonical.canonical)?;
    Ok(PaperVReconstructionArtifact {
        schema: PAPER_V_RECONSTRUCTION_SCHEMA_VERSION.into(),
        profile: "paper_v_chordal_conference".into(),
        carrier,
        ambiguity: Ambiguity::OrientationC2 {
            killed_by_calibration: true,
        },
        exact_marked_return: true,
        round_trip_shadow: canonical.canonical.clone(),
        canonical,
    })
}

/// Independently replay a Paper-V carrier reconstruction.
///
/// # Errors
///
/// Returns an error if the canonical proof, carrier, round trip, or ambiguity is corrupt.
pub fn verify_paper_v_reconstruction(
    input: &InputArtifact,
    artifact: &PaperVReconstructionArtifact,
) -> Result<VerificationReport, ShadowError> {
    if artifact.schema != PAPER_V_RECONSTRUCTION_SCHEMA_VERSION
        || artifact.profile != "paper_v_chordal_conference"
        || artifact.ambiguity
            != (Ambiguity::OrientationC2 {
                killed_by_calibration: true,
            })
        || !artifact.exact_marked_return
    {
        return Err(ShadowError::Certificate(
            "Paper-V reconstruction metadata is inconsistent".into(),
        ));
    }
    let report = verify_canonical_artifact(input, &artifact.canonical)?;
    if artifact.carrier != recover_paper_v_carrier(&artifact.canonical.canonical)?
        || artifact.round_trip_shadow != artifact.canonical.canonical
    {
        return Err(ShadowError::Certificate(
            "Paper-V carrier or round trip is corrupt".into(),
        ));
    }
    Ok(report)
}

fn recover_paper_v_carrier(input: &InputArtifact) -> Result<PaperVCarrier, ShadowError> {
    let ProfileInput::PaperVChordalConference(value) = &input.profile else {
        return Err(ShadowError::Invalid(
            "Paper-V reconstruction received another profile".into(),
        ));
    };
    Ok(PaperVCarrier {
        schema: PAPER_V_CARRIER_SCHEMA_VERSION.into(),
        verification_field: value.verification_field.clone(),
        six_axes: value.conference_singular_points.clone(),
        chordal_quartic_points: value.chordal_singular_points.clone(),
        conference_cubic: value.conference_cubic.clone(),
        chordal_cubic: value.chordal_cubic.clone(),
        delta_matrix: value.delta_matrix.clone(),
        conference_positive_edges: value.retained_residue.relations[0].edges.clone(),
        outer_lift: value.outer_involution.clone(),
        selected_chordal_line: value
            .selected_chordal_line
            .expect("validated Paper-V selected line"),
    })
}

/// Independently replay a reconstruction artifact.
///
/// # Errors
///
/// Returns an error when the canonical proof, round trip, carrier, ambiguity,
/// or calibrated-return claim is inconsistent with the raw input.
pub fn verify_reconstruction(
    input: &InputArtifact,
    artifact: &ReconstructionArtifact,
) -> Result<VerificationReport, ShadowError> {
    if artifact.schema != RECONSTRUCTION_SCHEMA_VERSION || artifact.profile != "paper_i_orientation"
    {
        return Err(ShadowError::Certificate(
            "reconstruction metadata is inconsistent".into(),
        ));
    }
    let ProfileInput::PaperIOrientation(paper) = &input.profile else {
        return Err(ShadowError::Certificate(
            "reconstruction replay supports only Paper I".into(),
        ));
    };
    verify_canonical_artifact(input, &artifact.canonical)?;
    if artifact.carrier != recover_paper_i_carrier(&artifact.canonical.canonical)? {
        return Err(ShadowError::Certificate(
            "recovered Paper-I carrier differs from the verified canonical shadow".into(),
        ));
    }
    if artifact.round_trip_shadow != artifact.canonical.canonical {
        return Err(ShadowError::Certificate(
            "round-trip shadow differs from the verified canonical shadow".into(),
        ));
    }
    let calibrated = paper.calibrated_triangle.is_some();
    if artifact.exact_oriented_return != calibrated
        || artifact.ambiguity
            != (Ambiguity::OrientationC2 {
                killed_by_calibration: calibrated,
            })
    {
        return Err(ShadowError::Certificate(
            "residual orientation ambiguity is incorrect".into(),
        ));
    }
    Ok(VerificationReport {
        valid: true,
        canonical_id: Some(artifact.canonical.canonical_id.clone()),
        checked_automorphisms: artifact.canonical.certificate.automorphisms.len(),
    })
}

/// Reconstruct the marked projective plane carried by the Paper-IV shadow.
///
/// # Errors
///
/// Returns an error unless canonical recognition identifies the exact q=13
/// model and every recovered incidence, polarity, relation, and code invariant
/// passes exact arithmetic checks.
pub fn reconstruct_paper_iv(
    input: &InputArtifact,
) -> Result<PaperIvReconstructionArtifact, ShadowError> {
    let canonical = canonicalize(input)?;
    let carrier = recover_paper_iv_carrier(&canonical.canonical)?;
    Ok(PaperIvReconstructionArtifact {
        schema: PAPER_IV_RECONSTRUCTION_SCHEMA_VERSION.into(),
        profile: "paper_iv_minimum_words".into(),
        carrier,
        ambiguity: MarkingTorsor {
            group: "PGL2(13)".into(),
            order: 2184,
        },
        round_trip_shadow: canonical.canonical.clone(),
        canonical,
    })
}

/// Independently replay a Paper-IV reconstruction artifact.
///
/// # Errors
///
/// Returns an error when canonical replay or any recovered carrier component
/// differs from exact regeneration.
pub fn verify_paper_iv_reconstruction(
    input: &InputArtifact,
    artifact: &PaperIvReconstructionArtifact,
) -> Result<VerificationReport, ShadowError> {
    if artifact.schema != PAPER_IV_RECONSTRUCTION_SCHEMA_VERSION
        || artifact.profile != "paper_iv_minimum_words"
        || artifact.ambiguity
            != (MarkingTorsor {
                group: "PGL2(13)".into(),
                order: 2184,
            })
    {
        return Err(ShadowError::Certificate(
            "Paper-IV reconstruction metadata is inconsistent".into(),
        ));
    }
    let report = verify_canonical_artifact(input, &artifact.canonical)?;
    if artifact.round_trip_shadow != artifact.canonical.canonical {
        return Err(ShadowError::Certificate(
            "Paper-IV round-trip shadow differs from the canonical shadow".into(),
        ));
    }
    let recovered = recover_paper_iv_carrier(&artifact.canonical.canonical)
        .map_err(|error| ShadowError::Certificate(error.to_string()))?;
    if artifact.carrier != recovered {
        return Err(ShadowError::Certificate(
            "Paper-IV carrier differs from exact arithmetic recovery".into(),
        ));
    }
    Ok(report)
}

#[allow(clippy::too_many_lines)]
fn recover_paper_iv_carrier(canonical: &InputArtifact) -> Result<PaperIvCarrier, ShadowError> {
    let ProfileInput::PaperIvMinimumWords(value) = &canonical.profile else {
        return Err(ShadowError::Invalid(
            "Paper-IV carrier recovery received another profile".into(),
        ));
    };
    let model = standard_model(canonical, value)?;
    let model_canonical = canonicalize(&model)?;
    if model_canonical.canonical != *canonical {
        return Err(ShadowError::Invalid(
            "canonical shadow is not the standard q=13 conic model".into(),
        ));
    }

    let points = projective_points();
    let lines = points.clone();
    let point_index = points
        .iter()
        .enumerate()
        .map(|(index, &point)| (point, index as u32))
        .collect::<BTreeMap<_, _>>();
    let line_index = point_index.clone();
    let incidence_rows = lines
        .iter()
        .map(|&line| {
            points
                .iter()
                .enumerate()
                .filter(|(_, point)| incident(line, **point))
                .map(|(index, _)| index as u32)
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();
    if points.len() != 183
        || incidence_rows.len() != 183
        || incidence_rows.iter().any(|row| row.len() != 14)
    {
        return Err(ShadowError::Invalid(
            "invalid recovered PG(2,13) incidence".into(),
        ));
    }
    let mut collinear_pair_counts = BTreeMap::<[u32; 2], u8>::new();
    for row in &incidence_rows {
        for right in 1..row.len() {
            for left in 0..right {
                *collinear_pair_counts
                    .entry([row[left], row[right]])
                    .or_default() += 1;
            }
        }
    }
    if collinear_pair_counts.len() != 183 * 182 / 2
        || collinear_pair_counts.values().any(|&count| count != 1)
    {
        return Err(ShadowError::Invalid(
            "recovered plane lacks unique lines through point pairs".into(),
        ));
    }
    let conic_points = points
        .iter()
        .enumerate()
        .filter(|(_, point)| delta(**point) == 0)
        .map(|(index, _)| index as u32)
        .collect::<Vec<_>>();
    let polarity_point_to_line = points
        .iter()
        .map(|&point| line_index[&polar(point)])
        .collect::<Vec<_>>();
    if conic_points.len() != 14
        || polarity_point_to_line
            .iter()
            .copied()
            .collect::<BTreeSet<_>>()
            .len()
            != 183
    {
        return Err(ShadowError::Invalid(
            "invalid recovered conic or polarity".into(),
        ));
    }
    for (point, &line) in points.iter().zip(&polarity_point_to_line) {
        if pole(lines[line as usize]) != *point
            || incident(lines[line as usize], *point) != (delta(*point) == 0)
        {
            return Err(ShadowError::Invalid(
                "recovered polarity is not involutive with the declared absolute conic".into(),
            ));
        }
    }

    let internal = internal_points();
    let mut canonical_to_model = vec![0; 78];
    for (model_coordinate, &canonical_coordinate) in
        model_canonical.input_to_canonical.iter().enumerate()
    {
        canonical_to_model[canonical_coordinate as usize] = model_coordinate;
    }
    let shadow_coordinate_to_internal_point = canonical_to_model
        .iter()
        .map(|&model_coordinate| point_index[&internal[model_coordinate]])
        .collect::<Vec<_>>();
    let shadow_coordinate_to_passant_line = canonical_to_model
        .iter()
        .map(|&model_coordinate| line_index[&polar(internal[model_coordinate])])
        .collect::<Vec<_>>();
    let passant_incidence_rows = shadow_coordinate_to_passant_line
        .iter()
        .map(|&line| {
            shadow_coordinate_to_internal_point
                .iter()
                .enumerate()
                .filter(|&(_, &point)| incidence_rows[line as usize].binary_search(&point).is_ok())
                .map(|(coordinate, _)| coordinate as u32)
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();
    if passant_incidence_rows.iter().any(|row| row.len() != 7) {
        return Err(ShadowError::Invalid(
            "invalid recovered passant rows".into(),
        ));
    }

    let elliptic_relations = recover_relations(value)?;
    let weight_eight_rows = relation_rows(&elliptic_relations[0].edges, 78);
    let mut recovered_rows = passant_incidence_rows.clone();
    recovered_rows.sort_unstable();
    let mut expected_rows = weight_eight_rows;
    expected_rows.sort_unstable();
    if recovered_rows != expected_rows {
        return Err(ShadowError::Invalid(
            "weighted-pair section does not recover the passant incidence rows".into(),
        ));
    }
    let binary_code_rank = binary_rank_from_odd_pairs(value)?;
    if binary_code_rank != 36 {
        return Err(ShadowError::Invalid(
            "recovered binary code has wrong rank".into(),
        ));
    }

    Ok(PaperIvCarrier {
        schema: PAPER_IV_CARRIER_SCHEMA_VERSION.into(),
        field: value.field.clone(),
        points,
        lines,
        incidence_rows,
        conic_points,
        polarity_point_to_line,
        shadow_coordinate_to_internal_point,
        shadow_coordinate_to_passant_line,
        passant_incidence_rows,
        elliptic_relations,
        binary_code_rank,
    })
}

fn recover_paper_i_carrier(canonical: &InputArtifact) -> Result<PaperICarrier, ShadowError> {
    let ProfileInput::PaperIOrientation(paper) = &canonical.profile else {
        return Err(ShadowError::Invalid(
            "Paper-I carrier recovery received another profile".into(),
        ));
    };
    let antipodal = paper
        .shadow
        .relations
        .iter()
        .find(|relation| relation.name == "antipodal")
        .ok_or_else(|| ShadowError::Invalid("canonical Paper-I shadow has no antipodes".into()))?;
    Ok(PaperICarrier {
        schema: PAPER_I_CARRIER_SCHEMA_VERSION.into(),
        axes: antipodal.edges.clone(),
        conference_switching_class: "icosahedral_six_axis_switching_class".into(),
    })
}

fn standard_model(
    canonical: &InputArtifact,
    value: &GatedPaperIv,
) -> Result<InputArtifact, ShadowError> {
    let points = internal_points();
    let mut model = value.clone();
    model.weighted_pair_section.clear();
    for right in 1..points.len() {
        for left in 0..right {
            let multiplicity = match rho(points[left], points[right])? {
                0 => 8,
                1 | 3 => 6,
                9 => 12,
                10 => 7,
                12 => 9,
                _ => {
                    return Err(ShadowError::Invalid(
                        "unexpected q=13 elliptic relation".into(),
                    ));
                }
            };
            model.weighted_pair_section.push(WeightedPair {
                left: left as u32,
                right: right as u32,
                multiplicity,
            });
        }
    }
    let matrices = [(1, 1, 0, 1), (0, 1, 12, 0), (2, 0, 0, 1)];
    model.action = DeclaredAction::VertexPermutations {
        degree: 78,
        generators: matrices
            .iter()
            .map(|&matrix| {
                points
                    .iter()
                    .map(|&point| {
                        points
                            .binary_search(&symmetric_square_action(matrix, point))
                            .map(|index| index as u32)
                            .map_err(|_| {
                                ShadowError::Invalid("q=13 action left the internal points".into())
                            })
                    })
                    .collect::<Result<Vec<_>, _>>()
            })
            .collect::<Result<Vec<_>, _>>()?,
    };
    let mut artifact = canonical.clone();
    artifact.profile = ProfileInput::PaperIvMinimumWords(Box::new(model));
    Ok(artifact)
}

fn projective_points() -> Vec<[u32; 3]> {
    let mut points = Vec::with_capacity(183);
    for y in 0..13 {
        for z in 0..13 {
            points.push([1, y, z]);
        }
    }
    for z in 0..13 {
        points.push([0, 1, z]);
    }
    points.push([0, 0, 1]);
    points
}

fn internal_points() -> Vec<[u32; 3]> {
    let squares = (1..13)
        .map(|value| value * value % 13)
        .collect::<BTreeSet<_>>();
    projective_points()
        .into_iter()
        .filter(|&point| {
            let value = delta(point);
            value != 0 && !squares.contains(&value)
        })
        .collect()
}

fn normalize(mut vector: [u32; 3]) -> [u32; 3] {
    let first = vector
        .iter()
        .copied()
        .find(|&value| value != 0)
        .expect("projective vector is nonzero");
    let inverse = field_inverse(first);
    for value in &mut vector {
        *value = *value * inverse % 13;
    }
    vector
}

fn field_inverse(value: u32) -> u32 {
    (1..13)
        .find(|candidate| value * candidate % 13 == 1)
        .expect("nonzero prime-field element is invertible")
}

fn delta(point: [u32; 3]) -> u32 {
    (point[1] * point[1] + 13 - point[0] * point[2] % 13) % 13
}

fn polar(point: [u32; 3]) -> [u32; 3] {
    normalize([
        (13 - point[2]) % 13,
        2 * point[1] % 13,
        (13 - point[0]) % 13,
    ])
}

fn pole(line: [u32; 3]) -> [u32; 3] {
    normalize([(13 - line[2]) % 13, 7 * line[1] % 13, (13 - line[0]) % 13])
}

fn incident(line: [u32; 3], point: [u32; 3]) -> bool {
    (0..3).map(|index| line[index] * point[index]).sum::<u32>() % 13 == 0
}

fn rho(first: [u32; 3], second: [u32; 3]) -> Result<u32, ShadowError> {
    let beta = (2 * first[1] * second[1] + 26 - first[0] * second[2] - first[2] * second[0]) % 13;
    let denominator = delta(first) * delta(second) % 13;
    if denominator == 0 {
        return Err(ShadowError::Invalid("rho denominator vanishes".into()));
    }
    Ok(beta * beta % 13 * field_inverse(denominator) % 13)
}

#[allow(clippy::many_single_char_names)]
fn symmetric_square_action(matrix: (u32, u32, u32, u32), point: [u32; 3]) -> [u32; 3] {
    let (a, b, c, d) = matrix;
    let [x, y, z] = point;
    normalize([
        (a * a * x + 2 * a * b * y + b * b * z) % 13,
        (a * c * x + (a * d + b * c) * y + b * d * z) % 13,
        (c * c * x + 2 * c * d * y + d * d * z) % 13,
    ])
}

fn recover_relations(value: &GatedPaperIv) -> Result<Vec<PaperIvRelation>, ShadowError> {
    let mut weights = vec![0_u32; 78 * 78];
    for pair in &value.weighted_pair_section {
        let left = pair.left as usize;
        let right = pair.right as usize;
        weights[left * 78 + right] = pair.multiplicity;
        weights[right * 78 + left] = pair.multiplicity;
    }
    let mut edges = BTreeMap::<u32, Vec<[u32; 2]>>::new();
    for right in 1..78 {
        for left in 0..right {
            let multiplicity = weights[left * 78 + right];
            let relation = match multiplicity {
                8 => 0,
                12 => 9,
                7 => 10,
                9 => 12,
                6 => {
                    let common_sevens = (0..78)
                        .filter(|&middle| {
                            weights[left * 78 + middle] == 7 && weights[right * 78 + middle] == 7
                        })
                        .count();
                    match common_sevens {
                        2 => 1,
                        4 => 3,
                        _ => {
                            return Err(ShadowError::Invalid(
                                "multiplicity-six relation does not split intrinsically".into(),
                            ));
                        }
                    }
                }
                _ => return Err(ShadowError::Invalid("unknown pair multiplicity".into())),
            };
            edges
                .entry(relation)
                .or_default()
                .push([left as u32, right as u32]);
        }
    }
    let expected = BTreeMap::from([(0, 273), (1, 546), (3, 546), (9, 546), (10, 546), (12, 546)]);
    if edges
        .iter()
        .map(|(&rho, rows)| (rho, rows.len()))
        .collect::<BTreeMap<_, _>>()
        != expected
    {
        return Err(ShadowError::Invalid(
            "invalid recovered elliptic relation sizes".into(),
        ));
    }
    Ok(edges
        .into_iter()
        .map(|(rho, edges)| PaperIvRelation {
            rho,
            pair_multiplicity: match rho {
                0 => 8,
                1 | 3 => 6,
                9 => 12,
                10 => 7,
                12 => 9,
                _ => unreachable!(),
            },
            edges,
        })
        .collect())
}

fn relation_rows(edges: &[[u32; 2]], degree: usize) -> Vec<Vec<u32>> {
    let mut rows = vec![Vec::new(); degree];
    for &[left, right] in edges {
        rows[left as usize].push(right);
        rows[right as usize].push(left);
    }
    for row in &mut rows {
        row.sort_unstable();
    }
    rows
}

fn binary_rank_from_odd_pairs(value: &GatedPaperIv) -> Result<u32, ShadowError> {
    let mut rows = vec![0_u128; 78];
    for pair in &value.weighted_pair_section {
        if pair.multiplicity % 2 == 1 {
            rows[pair.left as usize] |= 1_u128 << pair.right;
            rows[pair.right as usize] |= 1_u128 << pair.left;
        }
    }
    let mut rank = 0;
    for column in 0..78 {
        let Some(pivot) = (rank..rows.len()).find(|&row| (rows[row] >> column) & 1 == 1) else {
            continue;
        };
        rows.swap(rank, pivot);
        for row in 0..rows.len() {
            if row != rank && (rows[row] >> column) & 1 == 1 {
                rows[row] ^= rows[rank];
            }
        }
        rank += 1;
    }
    u32::try_from(rank).map_err(|_| ShadowError::Invalid("binary rank exceeds u32".into()))
}
