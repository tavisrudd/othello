use std::collections::BTreeSet;

use serde::{Deserialize, Serialize};

use crate::{
    CanonicalCertificate, InputArtifact, ProfileInput, ShadowError, VerificationReport,
    canonicalize, verify_certificate,
};

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(tag = "outcome", rename_all = "snake_case")]
pub enum EquivalenceOutcome {
    Equivalent {
        left_to_right: Vec<u32>,
    },
    Inequivalent {
        separating_invariant: SeparatingInvariant,
    },
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SeparatingInvariant {
    pub kind: String,
    pub left_value: String,
    pub right_value: String,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct EquivalenceCertificate {
    pub certificate_schema: String,
    pub left: CanonicalCertificate,
    pub right: CanonicalCertificate,
    pub result: EquivalenceOutcome,
}

/// Compare two inputs and emit an independently replayable result.
///
/// # Errors
///
/// Returns an error if either input fails validation or canonicalization.
pub fn compare(
    left: &InputArtifact,
    right: &InputArtifact,
) -> Result<EquivalenceCertificate, ShadowError> {
    let left_canonical = canonicalize(left)?;
    let right_canonical = canonicalize(right)?;
    let result = if left_canonical.canonical_id == right_canonical.canonical_id {
        EquivalenceOutcome::Equivalent {
            left_to_right: compose_transporters(
                &left_canonical.input_to_canonical,
                &right_canonical.input_to_canonical,
            )?,
        }
    } else {
        EquivalenceOutcome::Inequivalent {
            separating_invariant: SeparatingInvariant {
                kind: "exhaustively_verified_canonical_identity".into(),
                left_value: left_canonical.canonical_id,
                right_value: right_canonical.canonical_id,
            },
        }
    };
    Ok(EquivalenceCertificate {
        certificate_schema: "sparse-shadow-equivalence/v1".into(),
        left: left_canonical.certificate,
        right: right_canonical.certificate,
        result,
    })
}

/// Independently replay an equivalence or inequivalence certificate.
///
/// # Errors
///
/// Returns an error when either canonical proof fails, an isomorphism witness
/// does not preserve the raw objects, or the stated separating invariant is
/// inconsistent with the independently derived canonical forms.
pub fn verify_equivalence(
    left: &InputArtifact,
    right: &InputArtifact,
    certificate: &EquivalenceCertificate,
) -> Result<VerificationReport, ShadowError> {
    if certificate.certificate_schema != "sparse-shadow-equivalence/v1" {
        return Err(ShadowError::Certificate(
            "unsupported equivalence certificate schema".into(),
        ));
    }
    verify_certificate(left, &certificate.left)?;
    verify_certificate(right, &certificate.right)?;
    match &certificate.result {
        EquivalenceOutcome::Equivalent { left_to_right } => {
            if certificate.left.canonical_id != certificate.right.canonical_id {
                return Err(ShadowError::Certificate(
                    "equivalent result has unequal canonical identities".into(),
                ));
            }
            verify_isomorphism(left, right, left_to_right)?;
        }
        EquivalenceOutcome::Inequivalent {
            separating_invariant,
        } => {
            if separating_invariant.kind != "exhaustively_verified_canonical_identity"
                || separating_invariant.left_value != certificate.left.canonical_id
                || separating_invariant.right_value != certificate.right.canonical_id
                || certificate.left.canonical_id == certificate.right.canonical_id
            {
                return Err(ShadowError::Certificate(
                    "inequivalence separator is inconsistent".into(),
                ));
            }
        }
    }
    Ok(VerificationReport {
        valid: true,
        canonical_id: None,
        checked_automorphisms: certificate.left.automorphisms.len()
            + certificate.right.automorphisms.len(),
    })
}

fn compose_transporters(left: &[u32], right: &[u32]) -> Result<Vec<u32>, ShadowError> {
    if left.len() != right.len() {
        return Err(ShadowError::Invalid(
            "cannot compose transporters of different degrees".into(),
        ));
    }
    let mut inverse_right = vec![0; right.len()];
    for (old, &canonical) in right.iter().enumerate() {
        inverse_right[canonical as usize] =
            u32::try_from(old).map_err(|_| ShadowError::Invalid("degree exceeds u32".into()))?;
    }
    Ok(left
        .iter()
        .map(|&canonical| inverse_right[canonical as usize])
        .collect())
}

fn verify_isomorphism(
    left: &InputArtifact,
    right: &InputArtifact,
    permutation: &[u32],
) -> Result<(), ShadowError> {
    let (ProfileInput::PaperIOrientation(left), ProfileInput::PaperIOrientation(right)) =
        (&left.profile, &right.profile)
    else {
        return Err(ShadowError::Certificate(
            "isomorphism replay supports only the enabled Paper-I adapter".into(),
        ));
    };
    let n = left.shadow.vertices.len();
    let image: BTreeSet<_> = permutation.iter().copied().collect();
    if right.shadow.vertices.len() != n
        || permutation.len() != n
        || image.len() != n
        || image.iter().any(|&vertex| vertex as usize >= n)
    {
        return Err(ShadowError::Certificate(
            "equivalence witness is not a permutation of the common degree".into(),
        ));
    }
    for (old, &new) in permutation.iter().enumerate() {
        if left.shadow.vertices[old] != right.shadow.vertices[new as usize] {
            return Err(ShadowError::Certificate(
                "equivalence witness does not preserve vertex data".into(),
            ));
        }
    }
    if left.shadow.relations.len() != right.shadow.relations.len() {
        return Err(ShadowError::Certificate(
            "equivalence witness sees different relation counts".into(),
        ));
    }
    for (left_relation, right_relation) in left.shadow.relations.iter().zip(&right.shadow.relations)
    {
        if left_relation.name != right_relation.name
            || left_relation.directed != right_relation.directed
        {
            return Err(ShadowError::Certificate(
                "equivalence witness sees incompatible relation metadata".into(),
            ));
        }
        let mapped: BTreeSet<_> = left_relation
            .edges
            .iter()
            .map(|&[left, right]| {
                let mut edge = [permutation[left as usize], permutation[right as usize]];
                if !left_relation.directed && edge[0] > edge[1] {
                    edge.swap(0, 1);
                }
                edge
            })
            .collect();
        if mapped != right_relation.edges.iter().copied().collect() {
            return Err(ShadowError::Certificate(format!(
                "equivalence witness does not preserve relation `{}`",
                left_relation.name
            )));
        }
    }
    let mapped_calibration = left.calibrated_triangle.map(|triangle| {
        let mut mapped = triangle.map(|vertex| permutation[vertex as usize]);
        mapped.sort_unstable();
        mapped
    });
    let mut right_calibration = right.calibrated_triangle;
    if let Some(triangle) = &mut right_calibration {
        triangle.sort_unstable();
    }
    if mapped_calibration != right_calibration {
        return Err(ShadowError::Certificate(
            "equivalence witness does not preserve odd calibration".into(),
        ));
    }
    Ok(())
}
