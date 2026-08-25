use serde::{Deserialize, Serialize};

use crate::{
    CanonicalArtifact, InputArtifact, ProfileInput, ShadowError, VerificationReport, canonicalize,
    verify_canonical_artifact,
};

pub const RECONSTRUCTION_SCHEMA_VERSION: &str = "sparse-shadow-reconstruction/v2";
pub const PAPER_I_CARRIER_SCHEMA_VERSION: &str = "sparse-shadow-paper-i-carrier/v1";

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
