use serde::{Deserialize, Serialize};

use crate::{
    CanonicalArtifact, InputArtifact, ProfileInput, ShadowError, VerificationReport, canonicalize,
    verify_certificate,
};

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(tag = "kind", rename_all = "snake_case")]
pub enum Ambiguity {
    OrientationC2 { killed_by_calibration: bool },
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ReconstructionArtifact {
    pub schema: String,
    pub profile: String,
    pub carrier: String,
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
    Ok(ReconstructionArtifact {
        schema: "sparse-shadow-reconstruction/v1".into(),
        profile: "paper_i_orientation".into(),
        carrier: "six_axis_conference_switching_class".into(),
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
    if artifact.schema != "sparse-shadow-reconstruction/v1"
        || artifact.profile != "paper_i_orientation"
        || artifact.carrier != "six_axis_conference_switching_class"
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
    verify_certificate(input, &artifact.canonical.certificate)?;
    crate::canonical::verify_canonical_artifact_fields(&artifact.canonical)?;
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
