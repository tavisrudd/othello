//! Typed campaign-daemon operations for bounded external proposers.

use super::{
    random_hex, ControlError, ProposalDeadlines, ProposalFailureClass, ProposalFailureReport,
    ProposalIdempotencyKey, ProposalRole, ProposalSession, ProposalSessionLimits,
    ProposalSessionUsage, ProposalSubmissionStore, ProposalTicketClaim, ProposalTicketSnapshot,
    ProposalTicketSpec, ProposalTicketSubmission, RetryAction, RetryPolicy,
};
use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;
use std::fs::{self, File};
use std::os::unix::fs::PermissionsExt;
use std::path::{Path, PathBuf};
use std::time::{Instant, SystemTime, UNIX_EPOCH};

pub const MAX_EXTERNAL_PROPOSAL_SESSIONS: usize = 32;
pub const MAX_EXTERNAL_SESSION_TTL_MS: u64 = 60 * 60 * 1_000;
pub const MAX_EXTERNAL_OPERATION_TTL_MS: u64 = 24 * 60 * 60 * 1_000;
pub const MAX_EXTERNAL_SESSION_QUERIES: u32 = 64;
pub const MAX_EXTERNAL_SESSION_OUTSTANDING: u16 = 8;
pub const MAX_EXTERNAL_SESSION_REVISIONS: u16 = 16;
pub const MAX_EXTERNAL_SESSION_WORK_UNITS: u64 = 1_000_000_000;
pub const MAX_EXTERNAL_SESSION_RETURN_BYTES: u64 = 1024 * 1024;

#[derive(Clone, Copy, Debug, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalSessionOpenRequest {
    pub allowed_roles: u8,
    pub ttl_ms: u64,
    pub maximum_queries: u32,
    pub maximum_outstanding: u16,
    pub maximum_revisions: u16,
    pub maximum_work_units: u64,
    pub maximum_return_bytes: u64,
}

#[derive(Clone, Debug, Serialize)]
pub struct ProposalSessionOpened {
    pub session_id: String,
    pub source_fingerprint: String,
    pub limits: ProposalSessionLimits,
    pub usage: ProposalSessionUsage,
}

#[derive(Clone, Debug, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalSubmitRequest {
    pub session_id: String,
    pub request_id: u64,
    pub canonical_payload_blake3: String,
    pub proposer_id: u16,
    pub role: ProposalRole,
    pub cost_units: u64,
    pub maximum_return_bytes: u64,
    pub queue_timeout_ms: u64,
    pub execution_timeout_ms: u64,
    pub admission_timeout_ms: u64,
    pub retention_timeout_ms: u64,
}

#[derive(Clone, Debug, Serialize)]
pub struct ProposalSubmitted {
    pub ticket_key: String,
    pub disposition: ProposalTicketSubmission,
    pub ticket: ProposalTicketSnapshot,
    pub usage: ProposalSessionUsage,
}

#[derive(Clone, Debug, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalTicketRequest {
    pub session_id: String,
    pub ticket_key: String,
}

#[derive(Clone, Debug, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalFailureRequest {
    pub session_id: String,
    pub ticket_key: String,
    pub attempt: u8,
    pub failure: ProposalFailureClass,
    #[serde(default)]
    pub provider_retry_after_ms: Option<u64>,
}

#[derive(Clone, Debug, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalCompleteRequest {
    pub session_id: String,
    pub ticket_key: String,
    pub attempt: u8,
    pub result_blake3: String,
    pub result_bytes: u64,
}

#[derive(Clone, Debug, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalRevisionRequest {
    pub session_id: String,
    pub canonical_payload_blake3: String,
    pub role: ProposalRole,
}

#[derive(Clone, Debug, Serialize)]
pub struct ProposalTicketView {
    pub ticket_key: String,
    pub ticket: ProposalTicketSnapshot,
    pub usage: ProposalSessionUsage,
}

#[derive(Clone, Debug, Serialize)]
pub struct ProposalFailureAccepted {
    pub ticket_key: String,
    pub action: RetryAction,
    pub ticket: ProposalTicketSnapshot,
    pub usage: ProposalSessionUsage,
}

#[derive(Clone, Debug, Serialize)]
pub struct ProposalClaimed {
    pub ticket_key: String,
    pub claim: ProposalTicketClaim,
    pub ticket: ProposalTicketSnapshot,
    pub usage: ProposalSessionUsage,
}

struct ControllerClock {
    epoch_ms: u64,
    started: Instant,
    last_ms: u64,
}

impl ControllerClock {
    fn new() -> Result<Self, ControlError> {
        let epoch_ms = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .map_err(|_| ControlError::Invalid("controller clock precedes Unix epoch".into()))?
            .as_millis()
            .try_into()
            .map_err(|_| {
                ControlError::Invalid("controller clock exceeds u64 milliseconds".into())
            })?;
        Ok(Self {
            epoch_ms,
            started: Instant::now(),
            last_ms: epoch_ms,
        })
    }

    fn now_ms(&mut self) -> Result<u64, ControlError> {
        let elapsed_ms: u64 = self
            .started
            .elapsed()
            .as_millis()
            .try_into()
            .map_err(|_| ControlError::Invalid("controller elapsed time exceeds u64".into()))?;
        let now_ms = self
            .epoch_ms
            .checked_add(elapsed_ms)
            .ok_or_else(|| ControlError::Invalid("controller clock overflow".into()))?;
        if now_ms < self.last_ms {
            return Err(ControlError::Invalid(
                "controller monotone time moved backwards".into(),
            ));
        }
        self.last_ms = now_ms;
        Ok(now_ms)
    }
}

pub struct ProposalDaemon {
    root: PathBuf,
    run_id: String,
    nonce: String,
    source_fingerprint: [u8; 32],
    clock: ControllerClock,
    retry_policy: RetryPolicy,
    sessions: BTreeMap<String, ProposalSubmissionStore>,
}

impl ProposalDaemon {
    pub fn create(
        root: &Path,
        run_id: &str,
        nonce: &str,
        source_fingerprint_hex: &str,
    ) -> Result<Self, ControlError> {
        let source_fingerprint = parse_digest(source_fingerprint_hex, "source fingerprint")?;
        fs::create_dir(root)?;
        fs::set_permissions(root, fs::Permissions::from_mode(0o700))?;
        File::open(root)?.sync_all()?;
        if let Some(parent) = root.parent().filter(|path| !path.as_os_str().is_empty()) {
            File::open(parent)?.sync_all()?;
        }
        Ok(Self {
            root: root.to_path_buf(),
            run_id: run_id.into(),
            nonce: nonce.into(),
            source_fingerprint,
            clock: ControllerClock::new()?,
            retry_policy: RetryPolicy {
                maximum_retries: 4,
                base_delay_ms: 250,
                maximum_delay_ms: 30_000,
            },
            sessions: BTreeMap::new(),
        })
    }

    pub fn open_session(
        &mut self,
        request: ProposalSessionOpenRequest,
    ) -> Result<ProposalSessionOpened, ControlError> {
        validate_offer(request)?;
        if self.sessions.len() == MAX_EXTERNAL_PROPOSAL_SESSIONS {
            return Err(ControlError::Invalid(
                "external proposer session capacity is exhausted".into(),
            ));
        }
        let now_ms = self.clock.now_ms()?;
        let expires_ms = now_ms
            .checked_add(request.ttl_ms)
            .ok_or_else(|| ControlError::Invalid("session expiry overflow".into()))?;
        let session_id = random_hex(16)?;
        let session_binding = session_binding(
            &self.run_id,
            &self.nonce,
            &session_id,
            self.source_fingerprint,
        );
        let limits = ProposalSessionLimits {
            allowed_roles: request.allowed_roles,
            expires_ms,
            maximum_queries: request.maximum_queries,
            maximum_outstanding: request.maximum_outstanding,
            maximum_revisions: request.maximum_revisions,
            maximum_work_units: request.maximum_work_units,
            maximum_return_bytes: request.maximum_return_bytes,
        };
        let session =
            ProposalSession::new(session_binding, self.source_fingerprint, limits, now_ms)
                .map_err(invalid)?;
        let store = ProposalSubmissionStore::create(
            &self.root.join(&session_id),
            session,
            request.maximum_queries as usize,
        )
        .map_err(invalid)?;
        let usage = store.session().map_err(invalid)?.usage();
        if self.sessions.insert(session_id.clone(), store).is_some() {
            return Err(ControlError::Invalid(
                "external proposer session identity collision".into(),
            ));
        }
        Ok(ProposalSessionOpened {
            session_id,
            source_fingerprint: blake3::Hash::from(self.source_fingerprint)
                .to_hex()
                .to_string(),
            limits,
            usage,
        })
    }

    pub fn session_count(&self) -> usize {
        self.sessions.len()
    }

    pub fn submit(
        &mut self,
        request: ProposalSubmitRequest,
    ) -> Result<ProposalSubmitted, ControlError> {
        validate_operation_timeouts(&request)?;
        let now_ms = self.clock.now_ms()?;
        let payload = parse_digest(
            &request.canonical_payload_blake3,
            "canonical payload digest",
        )?;
        let key = ProposalIdempotencyKey::new(&request.session_id, request.request_id, payload)?;
        let deadlines = ProposalDeadlines::new(
            add_deadline(now_ms, request.queue_timeout_ms)?,
            add_deadline(now_ms, request.execution_timeout_ms)?,
            add_deadline(now_ms, request.retention_timeout_ms)?,
            add_deadline(now_ms, request.admission_timeout_ms)?,
        )?;
        let spec = ProposalTicketSpec {
            key,
            proposer_id: request.proposer_id,
            role: request.role,
            deadlines,
            cost_units: request.cost_units,
            max_return_bytes: request.maximum_return_bytes,
        };
        let store = self.session_mut(&request.session_id)?;
        let disposition = store.submit(spec, now_ms).map_err(invalid)?;
        let ticket = store
            .tickets()
            .get(key)
            .ok_or_else(|| ControlError::Invalid("submitted ticket disappeared".into()))?;
        let usage = store.session().map_err(invalid)?.usage();
        Ok(ProposalSubmitted {
            ticket_key: key.to_hex(),
            disposition,
            ticket,
            usage,
        })
    }

    pub fn status(
        &mut self,
        request: ProposalTicketRequest,
    ) -> Result<ProposalTicketView, ControlError> {
        let now_ms = self.clock.now_ms()?;
        let key = ProposalIdempotencyKey::from_hex(&request.ticket_key)?;
        let store = self.session_mut(&request.session_id)?;
        store.expire_due(now_ms).map_err(invalid)?;
        view(key, store)
    }

    pub fn claim(
        &mut self,
        request: ProposalTicketRequest,
    ) -> Result<ProposalClaimed, ControlError> {
        let now_ms = self.clock.now_ms()?;
        let key = ProposalIdempotencyKey::from_hex(&request.ticket_key)?;
        let store = self.session_mut(&request.session_id)?;
        let claim = store.claim(key, now_ms).map_err(invalid)?;
        let view = view(key, store)?;
        Ok(ProposalClaimed {
            ticket_key: view.ticket_key,
            claim,
            ticket: view.ticket,
            usage: view.usage,
        })
    }

    pub fn report_failure(
        &mut self,
        request: ProposalFailureRequest,
    ) -> Result<ProposalFailureAccepted, ControlError> {
        if request
            .provider_retry_after_ms
            .is_some_and(|delay| delay == 0 || delay > MAX_EXTERNAL_OPERATION_TTL_MS)
        {
            return Err(ControlError::Invalid(
                "provider Retry-After is outside the operation bound".into(),
            ));
        }
        let now_ms = self.clock.now_ms()?;
        let key = ProposalIdempotencyKey::from_hex(&request.ticket_key)?;
        let provider_retry_after_ms = request
            .provider_retry_after_ms
            .map(|delay| add_deadline(now_ms, delay))
            .transpose()?;
        let jitter_word = retry_jitter(key, request.attempt, request.failure, now_ms);
        let retry_policy = self.retry_policy;
        let store = self.session_mut(&request.session_id)?;
        let action = store
            .record_failure(
                key,
                ProposalFailureReport {
                    attempt: request.attempt,
                    failure: request.failure,
                    retry_policy,
                    observed_ms: now_ms,
                    provider_retry_after_ms,
                    jitter_word,
                },
                now_ms,
            )
            .map_err(invalid)?;
        let view = view(key, store)?;
        Ok(ProposalFailureAccepted {
            ticket_key: view.ticket_key,
            action,
            ticket: view.ticket,
            usage: view.usage,
        })
    }

    pub fn complete(
        &mut self,
        request: ProposalCompleteRequest,
    ) -> Result<ProposalTicketView, ControlError> {
        let now_ms = self.clock.now_ms()?;
        let key = ProposalIdempotencyKey::from_hex(&request.ticket_key)?;
        let digest = parse_digest(&request.result_blake3, "proposal result digest")?;
        let store = self.session_mut(&request.session_id)?;
        store
            .complete(key, request.attempt, digest, request.result_bytes, now_ms)
            .map_err(invalid)?;
        view(key, store)
    }

    pub fn cancel(
        &mut self,
        request: ProposalTicketRequest,
    ) -> Result<ProposalTicketView, ControlError> {
        let now_ms = self.clock.now_ms()?;
        let key = ProposalIdempotencyKey::from_hex(&request.ticket_key)?;
        let store = self.session_mut(&request.session_id)?;
        store.cancel(key, now_ms).map_err(invalid)?;
        view(key, store)
    }

    pub fn result(
        &mut self,
        request: ProposalTicketRequest,
    ) -> Result<ProposalTicketView, ControlError> {
        let now_ms = self.clock.now_ms()?;
        let key = ProposalIdempotencyKey::from_hex(&request.ticket_key)?;
        let store = self.session_mut(&request.session_id)?;
        store.result(key, now_ms).map_err(invalid)?;
        view(key, store)
    }

    pub fn reserve_revision(
        &mut self,
        request: ProposalRevisionRequest,
    ) -> Result<ProposalSessionUsage, ControlError> {
        let now_ms = self.clock.now_ms()?;
        let digest = parse_digest(
            &request.canonical_payload_blake3,
            "proposal revision digest",
        )?;
        let store = self.session_mut(&request.session_id)?;
        store
            .reserve_revision(digest, request.role, now_ms)
            .map_err(invalid)?;
        Ok(store.session().map_err(invalid)?.usage())
    }

    fn session_mut(
        &mut self,
        session_id: &str,
    ) -> Result<&mut ProposalSubmissionStore, ControlError> {
        self.sessions
            .get_mut(session_id)
            .ok_or_else(|| ControlError::Invalid("unknown external proposer session".into()))
    }
}

fn view(
    key: ProposalIdempotencyKey,
    store: &ProposalSubmissionStore,
) -> Result<ProposalTicketView, ControlError> {
    let ticket = store
        .tickets()
        .get(key)
        .ok_or_else(|| ControlError::Invalid("unknown external proposal ticket".into()))?;
    Ok(ProposalTicketView {
        ticket_key: key.to_hex(),
        ticket,
        usage: store.session().map_err(invalid)?.usage(),
    })
}

fn validate_offer(request: ProposalSessionOpenRequest) -> Result<(), ControlError> {
    if request.ttl_ms == 0
        || request.ttl_ms > MAX_EXTERNAL_SESSION_TTL_MS
        || request.maximum_queries == 0
        || request.maximum_queries > MAX_EXTERNAL_SESSION_QUERIES
        || request.maximum_outstanding == 0
        || request.maximum_outstanding > MAX_EXTERNAL_SESSION_OUTSTANDING
        || u32::from(request.maximum_outstanding) > request.maximum_queries
        || request.maximum_revisions == 0
        || request.maximum_revisions > MAX_EXTERNAL_SESSION_REVISIONS
        || request.maximum_work_units == 0
        || request.maximum_work_units > MAX_EXTERNAL_SESSION_WORK_UNITS
        || request.maximum_return_bytes == 0
        || request.maximum_return_bytes > MAX_EXTERNAL_SESSION_RETURN_BYTES
    {
        return Err(ControlError::Invalid(
            "external proposer session offer exceeds a hard bound".into(),
        ));
    }
    Ok(())
}

fn validate_operation_timeouts(request: &ProposalSubmitRequest) -> Result<(), ControlError> {
    if request.queue_timeout_ms == 0
        || request.queue_timeout_ms > request.execution_timeout_ms
        || request.execution_timeout_ms > request.admission_timeout_ms
        || request.admission_timeout_ms > request.retention_timeout_ms
        || request.retention_timeout_ms > MAX_EXTERNAL_OPERATION_TTL_MS
    {
        return Err(ControlError::Invalid(
            "proposal operation timeouts have an invalid order or bound".into(),
        ));
    }
    Ok(())
}

fn add_deadline(now_ms: u64, delay_ms: u64) -> Result<u64, ControlError> {
    now_ms
        .checked_add(delay_ms)
        .ok_or_else(|| ControlError::Invalid("proposal deadline overflow".into()))
}

fn parse_digest(encoded: &str, label: &str) -> Result<[u8; 32], ControlError> {
    let digest = blake3::Hash::from_hex(encoded)
        .map_err(|_| ControlError::Invalid(format!("invalid {label}")))?;
    Ok(*digest.as_bytes())
}

fn session_binding(
    run_id: &str,
    nonce: &str,
    session_id: &str,
    source_fingerprint: [u8; 32],
) -> [u8; 32] {
    let mut hasher = blake3::Hasher::new();
    hasher.update(b"ergodis-proposal-session-binding-v1\0");
    for value in [run_id, nonce, session_id] {
        hasher.update(&(value.len() as u64).to_le_bytes());
        hasher.update(value.as_bytes());
    }
    hasher.update(&source_fingerprint);
    *hasher.finalize().as_bytes()
}

fn retry_jitter(
    key: ProposalIdempotencyKey,
    attempt: u8,
    failure: ProposalFailureClass,
    now_ms: u64,
) -> u64 {
    let mut hasher = blake3::Hasher::new();
    hasher.update(b"ergodis-proposal-retry-jitter-v1\0");
    hasher.update(&key.as_bytes());
    hasher.update(&[attempt, failure as u8]);
    hasher.update(&now_ms.to_le_bytes());
    u64::from_le_bytes(hasher.finalize().as_bytes()[..8].try_into().unwrap())
}

fn invalid(error: impl std::fmt::Display) -> ControlError {
    ControlError::Invalid(error.to_string())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn offer() -> ProposalSessionOpenRequest {
        ProposalSessionOpenRequest {
            allowed_roles: ProposalRole::Heuristic.mask(),
            ttl_ms: 60_000,
            maximum_queries: 4,
            maximum_outstanding: 2,
            maximum_revisions: 2,
            maximum_work_units: 40,
            maximum_return_bytes: 400,
        }
    }

    fn submit(session_id: &str) -> ProposalSubmitRequest {
        ProposalSubmitRequest {
            session_id: session_id.into(),
            request_id: 1,
            canonical_payload_blake3: blake3::hash(b"payload").to_hex().to_string(),
            proposer_id: 3,
            role: ProposalRole::Heuristic,
            cost_units: 5,
            maximum_return_bytes: 50,
            queue_timeout_ms: 1_000,
            execution_timeout_ms: 2_000,
            admission_timeout_ms: 3_000,
            retention_timeout_ms: 4_000,
        }
    }

    #[test]
    fn typed_daemon_lifecycle_is_bounded_and_idempotent() {
        let temporary = tempfile::tempdir().unwrap();
        let mut daemon = ProposalDaemon::create(
            &temporary.path().join("proposals"),
            "run",
            "nonce",
            blake3::hash(b"source").to_hex().as_ref(),
        )
        .unwrap();
        let opened = daemon.open_session(offer()).unwrap();
        let submitted = daemon.submit(submit(&opened.session_id)).unwrap();
        assert_eq!(submitted.disposition, ProposalTicketSubmission::Created);
        assert_eq!(
            daemon
                .submit(submit(&opened.session_id))
                .unwrap()
                .disposition,
            ProposalTicketSubmission::Existing
        );
        let claim = daemon
            .claim(ProposalTicketRequest {
                session_id: opened.session_id.clone(),
                ticket_key: submitted.ticket_key.clone(),
            })
            .unwrap();
        assert!(matches!(
            claim.claim,
            ProposalTicketClaim::Started { attempt: 0 }
        ));
        let completed = daemon
            .complete(ProposalCompleteRequest {
                session_id: opened.session_id,
                ticket_key: submitted.ticket_key,
                attempt: 0,
                result_blake3: blake3::hash(b"result").to_hex().to_string(),
                result_bytes: 12,
            })
            .unwrap();
        assert_eq!(completed.usage.outstanding, 0);
        assert_eq!(completed.usage.charged_work_units, 5);
    }

    #[test]
    fn oversized_offer_and_bad_timeout_order_fail_before_work() {
        let temporary = tempfile::tempdir().unwrap();
        let mut daemon = ProposalDaemon::create(
            &temporary.path().join("proposals"),
            "run",
            "nonce",
            blake3::hash(b"source").to_hex().as_ref(),
        )
        .unwrap();
        let mut too_large = offer();
        too_large.maximum_queries = MAX_EXTERNAL_SESSION_QUERIES + 1;
        assert!(daemon.open_session(too_large).is_err());
        let opened = daemon.open_session(offer()).unwrap();
        let mut invalid = submit(&opened.session_id);
        invalid.execution_timeout_ms = 500;
        assert!(daemon.submit(invalid).is_err());
        assert_eq!(
            daemon
                .sessions
                .get(&opened.session_id)
                .unwrap()
                .session()
                .unwrap()
                .usage()
                .queries,
            0
        );
    }
}
