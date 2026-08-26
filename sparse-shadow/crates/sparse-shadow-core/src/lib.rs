//! Exact sparse-shadow schemas, canonicalization, reconstruction, and replay.

mod backend;
mod canonical;
mod equivalence;
mod error;
mod hot;
mod paper_ii;
mod paper_iii;
mod paper_iv;
mod paper_iv_reference;
mod paper_v;
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
    Ambiguity, MarkingTorsor, PAPER_I_CARRIER_SCHEMA_VERSION, PAPER_II_CARRIER_SCHEMA_VERSION,
    PAPER_II_RECONSTRUCTION_SCHEMA_VERSION, PAPER_III_CARRIER_SCHEMA_VERSION,
    PAPER_III_RECONSTRUCTION_SCHEMA_VERSION, PAPER_IV_CARRIER_SCHEMA_VERSION,
    PAPER_IV_RECONSTRUCTION_SCHEMA_VERSION, PAPER_V_CARRIER_SCHEMA_VERSION,
    PAPER_V_RECONSTRUCTION_SCHEMA_VERSION, PaperICarrier, PaperIiCarrier,
    PaperIiReconstructionArtifact, PaperIiiAmbiguity, PaperIiiCarrier,
    PaperIiiReconstructionArtifact, PaperIvCarrier, PaperIvReconstructionArtifact, PaperIvRelation,
    PaperVCarrier, PaperVReconstructionArtifact, RECONSTRUCTION_SCHEMA_VERSION,
    ReconstructionArtifact, reconstruct, reconstruct_paper_ii, reconstruct_paper_iii,
    reconstruct_paper_iv, reconstruct_paper_v, verify_paper_ii_reconstruction,
    verify_paper_iii_reconstruction, verify_paper_iv_reconstruction, verify_paper_v_reconstruction,
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
