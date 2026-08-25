//! Exact sparse-shadow schemas, canonicalization, reconstruction, and replay.

mod canonical;
mod error;
mod reconstruct;
mod schema;
mod verify;

pub use canonical::{
    BranchDecision, CanonicalArtifact, CanonicalCertificate, SearchStats, canonicalize,
};
pub use error::ShadowError;
pub use reconstruct::{ReconstructionArtifact, reconstruct};
pub use schema::{
    ActionKind, AmbiguitySpec, BinaryRelation, CollisionWitness, DeclaredAction, FiniteFieldSpec,
    FixtureGate, FrozenSource, GatedPaperIi, GatedPaperIii, GatedPaperIv, GatedPaperV,
    InputArtifact, MinimumWord, OddCalibration, PaperIOrientation, ProfileInput, RelationalShadow,
    SCHEMA_VERSION, SemilinearGenerator, ShadowChannel, Vertex, WeightedBlock,
};
pub use verify::{VerificationReport, validate, verify_certificate};
