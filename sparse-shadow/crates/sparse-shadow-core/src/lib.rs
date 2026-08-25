//! Exact sparse-shadow schemas, canonicalization, reconstruction, and replay.

mod canonical;
mod equivalence;
mod error;
mod hot;
mod reconstruct;
mod schema;
mod verify;

pub use canonical::{
    BranchDecision, CanonicalArtifact, CanonicalCertificate, PointStabilizer, SearchStats,
    canonicalize, verify_canonical_artifact,
};
pub use equivalence::{
    EquivalenceCertificate, EquivalenceOutcome, SeparatingInvariant, compare, verify_equivalence,
};
pub use error::ShadowError;
pub use reconstruct::{ReconstructionArtifact, reconstruct, verify_reconstruction};
pub use schema::{
    ActionKind, AmbiguitySpec, BaseFieldSpec, BinaryRelation, CollisionWitness, DeclaredAction,
    FiniteFieldSpec, FixtureGate, FrozenSource, GatedPaperIi, GatedPaperIii, GatedPaperIv,
    GatedPaperV, InputArtifact, MinimumWord, OddCalibration, PaperIOrientation, ProfileInput,
    RationalCoefficient, RelationalShadow, SCHEMA_VERSION, SemilinearGenerator, Vertex,
    WeightedBlock, WeightedPair,
};
pub use verify::{VerificationReport, validate, verify_certificate};
