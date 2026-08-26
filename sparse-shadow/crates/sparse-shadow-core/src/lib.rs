//! Exact sparse-shadow schemas, canonicalization, reconstruction, and replay.

mod backend;
mod canonical;
mod equivalence;
mod error;
mod hot;
mod paper_iv;
mod paper_iv_reference;
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
    Ambiguity, MarkingTorsor, PAPER_I_CARRIER_SCHEMA_VERSION, PAPER_IV_CARRIER_SCHEMA_VERSION,
    PAPER_IV_RECONSTRUCTION_SCHEMA_VERSION, PaperICarrier, PaperIvCarrier,
    PaperIvReconstructionArtifact, PaperIvRelation, RECONSTRUCTION_SCHEMA_VERSION,
    ReconstructionArtifact, reconstruct, reconstruct_paper_iv, verify_paper_iv_reconstruction,
    verify_reconstruction,
};
pub use schema::{
    ActionKind, AmbiguitySpec, BaseFieldSpec, BinaryRelation, CollisionWitness, DeclaredAction,
    FiniteFieldSpec, FixtureGate, FrozenSource, GatedPaperIi, GatedPaperIii, GatedPaperIv,
    GatedPaperV, InputArtifact, MinimumWord, OddCalibration, PaperIOrientation, ProfileInput,
    RationalCoefficient, RelationalShadow, SCHEMA_VERSION, SemilinearGenerator, Vertex,
    WeightedBlock, WeightedPair,
};
pub use verify::{VerificationReport, validate, verify_certificate};
