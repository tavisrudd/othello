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
    ActionKind, BinaryRelation, FixtureGate, GatedPaperIi, GatedPaperIii, GatedPaperIv,
    GatedPaperV, InputArtifact, PaperIOrientation, ProfileInput, RelationalShadow, SCHEMA_VERSION,
    Vertex,
};
pub use verify::{VerificationReport, validate, verify_certificate};
