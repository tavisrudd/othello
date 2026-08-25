use thiserror::Error;

/// Failures are explicit at schema, action, canonicalization, and replay boundaries.
#[derive(Debug, Error)]
pub enum ShadowError {
    #[error("unsupported schema version `{found}`; expected `{expected}`")]
    SchemaVersion {
        expected: &'static str,
        found: String,
    },
    #[error("profile `{profile}` is schema-only: {reason}")]
    ProfileGated {
        profile: &'static str,
        reason: String,
    },
    #[error("invalid instance: {0}")]
    Invalid(String),
    #[error("certificate mismatch: {0}")]
    Certificate(String),
    #[error("JSON error: {0}")]
    Json(#[from] serde_json::Error),
    #[error("I/O error: {0}")]
    Io(#[from] std::io::Error),
}
