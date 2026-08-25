use serde::{Deserialize, Serialize};

use crate::{CanonicalArtifact, InputArtifact, ProfileInput, ShadowError, canonicalize};

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
