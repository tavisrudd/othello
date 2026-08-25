//! Exact sparse-shadow schemas, canonicalization, reconstruction, and replay.

mod backend;
mod canonical;
mod equivalence;
mod error;
mod hot;
mod reconstruct;
mod schema;
mod verify;

pub use backend::{
    BACKEND_COMPARISON_SCHEMA_VERSION, BACKEND_GRAPH_SCHEMA_VERSION, BackendComparison,
    BackendDescriptor, BackendObservation, ColoredIncidenceGraph, ExternalBackendKind,
    compare_external_backend, encode_colored_incidence, verify_backend_comparison,
};
pub use canonical::{
    BranchDecision, CANONICAL_SCHEMA_VERSION, CanonicalArtifact, CanonicalCertificate,
    PointStabilizer, SearchStats, canonicalize, verify_canonical_artifact,
};
pub use equivalence::{
    EquivalenceCertificate, EquivalenceOutcome, SeparatingInvariant, compare, verify_equivalence,
};
pub use error::ShadowError;
pub use reconstruct::{
    Ambiguity, PAPER_I_CARRIER_SCHEMA_VERSION, PaperICarrier, RECONSTRUCTION_SCHEMA_VERSION,
    ReconstructionArtifact, reconstruct, verify_reconstruction,
};
pub use schema::{
    ActionKind, AmbiguitySpec, BaseFieldSpec, BinaryRelation, CollisionWitness, DeclaredAction,
    FiniteFieldSpec, FixtureGate, FrozenSource, GatedPaperIi, GatedPaperIii, GatedPaperIv,
    GatedPaperV, InputArtifact, MinimumWord, OddCalibration, PaperIOrientation, ProfileInput,
    RationalCoefficient, RelationalShadow, SCHEMA_VERSION, SemilinearGenerator, Vertex,
    WeightedBlock, WeightedPair,
};
pub use verify::{VerificationReport, validate, verify_certificate};
