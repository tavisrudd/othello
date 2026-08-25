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
    PaperIiTrade(Box<GatedPaperIi>),
    PaperIiiFourShadow(Box<GatedPaperIii>),
    PaperIvMinimumWords(Box<GatedPaperIv>),
    PaperVChordalConference(Box<GatedPaperV>),
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

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct FrozenSource {
    pub paper: String,
    pub theorem: String,
    pub artifact: String,
    pub sha256: String,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct FiniteFieldSpec {
    pub characteristic: u32,
    pub degree: u32,
    pub modulus_coefficients_low_to_high: Vec<u32>,
    pub element_encoding: String,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(tag = "kind", content = "spec", rename_all = "snake_case")]
pub enum BaseFieldSpec {
    Rational,
    Finite(FiniteFieldSpec),
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct RationalCoefficient {
    pub numerator: i64,
    pub denominator: u64,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(tag = "kind", rename_all = "snake_case")]
pub enum DeclaredAction {
    VertexPermutations {
        degree: u32,
        generators: Vec<Vec<u32>>,
    },
    ProjectiveSemilinear {
        field: FiniteFieldSpec,
        vector_dimension: u32,
        generators: Vec<SemilinearGenerator>,
    },
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SemilinearGenerator {
    pub matrix_rows: Vec<Vec<u32>>,
    pub frobenius_power: u32,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(tag = "kind", rename_all = "snake_case")]
pub enum AmbiguitySpec {
    ProjectiveOrbit,
    OrientationC2,
    HomogeneousFibre {
        numerator: String,
        denominator: String,
    },
    MarkingTorsor {
        group: String,
    },
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct OddCalibration {
    pub name: String,
    pub support: Vec<u32>,
    pub value: i64,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct CollisionWitness {
    pub boundary: String,
    pub left_artifact: String,
    pub right_artifact: String,
    pub common_restricted_shadow_blake3: String,
    pub distinguishing_datum: String,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct WeightedBlock {
    pub support: Vec<u32>,
    pub weight: i64,
    pub sign: i8,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct GatedPaperIi {
    pub gate: FixtureGate,
    pub source: FrozenSource,
    pub field: FiniteFieldSpec,
    pub matching_count: u32,
    pub trade_halves: [Vec<WeightedBlock>; 2],
    pub action: DeclaredAction,
    pub carrier_hypothesis: String,
    pub recovered_carrier: String,
    pub ambiguity: AmbiguitySpec,
    pub odd_calibration: Option<OddCalibration>,
    pub minimality_collisions: Vec<CollisionWitness>,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct GatedPaperIii {
    pub gate: FixtureGate,
    pub source: FrozenSource,
    pub branch_sextic: String,
    pub rational_fibre_point: Vec<RationalCoefficient>,
    pub fibre_quadratic_algebra: String,
    pub vertex_count: u32,
    pub aligned_four_sets: Vec<[u32; 4]>,
    pub action: DeclaredAction,
    pub recovered_twist: String,
    pub recovered_two_graph: String,
    pub twist_ambiguity: AmbiguitySpec,
    pub complement_ambiguity: AmbiguitySpec,
    pub calibrated_triangle_product: Option<i8>,
    pub minimality_collisions: Vec<CollisionWitness>,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct MinimumWord {
    pub support: Vec<u32>,
    pub weight: u32,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct WeightedPair {
    pub left: u32,
    pub right: u32,
    pub multiplicity: u32,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct GatedPaperIv {
    pub gate: FixtureGate,
    pub source: FrozenSource,
    pub field: FiniteFieldSpec,
    pub coordinate_count: u32,
    pub minimum_support_count: u32,
    pub weighted_pair_section: Vec<WeightedPair>,
    pub action: DeclaredAction,
    pub recovered_carrier: String,
    pub ambiguity: AmbiguitySpec,
    pub minimality_collisions: Vec<CollisionWitness>,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct GatedPaperV {
    pub gate: FixtureGate,
    pub source: FrozenSource,
    pub base_field: BaseFieldSpec,
    pub retained_residue: RelationalShadow,
    pub action: DeclaredAction,
    pub selected_chordal_line: Option<u32>,
    pub outer_involution: Vec<u32>,
    pub delta_matrix: Vec<Vec<RationalCoefficient>>,
    pub recovered_carrier: String,
    pub ambiguity: AmbiguitySpec,
    pub odd_calibration: Option<OddCalibration>,
    pub minimality_collisions: Vec<CollisionWitness>,
}
