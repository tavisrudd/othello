use serde::{Deserialize, Serialize};

use crate::ShadowError;

pub const SCHEMA_VERSION: &str = "sparse-shadow/v1";

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct InputArtifact {
    pub schema: String,
    pub profile: ProfileInput,
}

impl InputArtifact {
    /// Check that the artifact uses the only schema understood by this build.
    ///
    /// # Errors
    ///
    /// Returns [`ShadowError::SchemaVersion`] for every other version.
    pub fn check_version(&self) -> Result<(), ShadowError> {
        if self.schema == SCHEMA_VERSION {
            Ok(())
        } else {
            Err(ShadowError::SchemaVersion {
                expected: SCHEMA_VERSION,
                found: self.schema.clone(),
            })
        }
    }
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(tag = "adapter", content = "input", rename_all = "snake_case")]
pub enum ProfileInput {
    PaperIOrientation(PaperIOrientation),
    PaperIiTrade(GatedPaperIi),
    PaperIiiFourShadow(GatedPaperIii),
    PaperIvMinimumWords(GatedPaperIv),
    PaperVChordalConference(GatedPaperV),
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum ActionKind {
    ColorPreservingPermutations,
}

#[derive(Clone, Debug, Eq, PartialEq, Ord, PartialOrd, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Vertex {
    pub color: u32,
    #[serde(default)]
    pub weight: i64,
    #[serde(default)]
    pub sign: i8,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct BinaryRelation {
    pub name: String,
    pub directed: bool,
    pub edges: Vec<[u32; 2]>,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct RelationalShadow {
    pub action: ActionKind,
    pub vertices: Vec<Vertex>,
    pub relations: Vec<BinaryRelation>,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaperIOrientation {
    pub theorem_locator: String,
    pub shadow: RelationalShadow,
    pub calibrated_triangle: Option<[u32; 3]>,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct FixtureGate {
    pub enabled: bool,
    pub reason: String,
    pub required_export: String,
}

macro_rules! gated_profile {
    ($name:ident) => {
        #[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
        #[serde(deny_unknown_fields)]
        pub struct $name {
            pub gate: FixtureGate,
            pub shadow: RelationalShadow,
        }
    };
}

gated_profile!(GatedPaperIi);
gated_profile!(GatedPaperIii);
gated_profile!(GatedPaperIv);
gated_profile!(GatedPaperV);
