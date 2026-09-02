//! Typed campaign-daemon operations for bounded external proposers.

use super::{
    random_hex, CircuitBreakerConfig, CircuitPermit, ControlError, ProposalArtifactStore,
    ProposalDeadlines, ProposalFailureClass, ProposalFailureReport, ProposalIdempotencyKey,
    ProposalRateStore, ProposalRateStoreConfig, ProposalRequestSchemaId,
    ProposalRequestSchemaRegistry, ProposalRequestSchemaView, ProposalRole, ProposalSession,
    ProposalSessionLimits, ProposalSessionUsage, ProposalSubmissionStore, ProposalTicketClaim,
    ProposalTicketSnapshot, ProposalTicketSpec, ProposalTicketStatus, ProposalTicketSubmission,
    RetryAction, RetryPolicy, TokenBucketConfig,
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
pub const MAX_EXTERNAL_REQUEST_BYTES: u64 = 1024 * 1024;
pub const MAX_EXTERNAL_PROVIDERS: usize = 256;

const CAMPAIGN_RATE: TokenBucketConfig = TokenBucketConfig {
    capacity: 256,
    refill_units: 256,
    refill_period_ms: 60_000,
};
const PROVIDER_RATE: TokenBucketConfig = TokenBucketConfig {
    capacity: 64,
    refill_units: 64,
    refill_period_ms: 60_000,
};
const SESSION_RATE: TokenBucketConfig = TokenBucketConfig {
    capacity: 16,
    refill_units: 16,
    refill_period_ms: 60_000,
};
const RATE_STORE_CONFIG: ProposalRateStoreConfig = ProposalRateStoreConfig {
    campaign: CAMPAIGN_RATE,
    provider: PROVIDER_RATE,
    session: SESSION_RATE,
    circuit: CircuitBreakerConfig {
        failure_threshold: 3,
        base_open_ms: 1_000,
        maximum_open_ms: 60_000,
    },
    maximum_providers: MAX_EXTERNAL_PROVIDERS,
    maximum_sessions: MAX_EXTERNAL_PROPOSAL_SESSIONS,
};

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
    pub request_upload_directory: PathBuf,
    pub request_schemas: Vec<ProposalRequestSchemaView>,
}

#[derive(Clone, Debug, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalSubmitRequest {
    pub session_id: String,
    pub request_id: u64,
    pub canonical_payload_blake3: String,
    pub request_bytes: u64,
    pub request_schema: String,
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
    #[serde(skip_serializing_if = "Option::is_none")]
    pub artifact: Option<ProposalArtifactView>,
}

#[derive(Clone, Debug, Serialize)]
pub struct ProposalArtifactView {
    pub relative_path: PathBuf,
    pub blake3: String,
    pub bytes: u64,
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
    #[serde(skip_serializing_if = "Option::is_none")]
    pub upload_relative_path: Option<PathBuf>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub request_artifact: Option<ProposalArtifactView>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub request_schema: Option<ProposalRequestSchemaView>,
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
    artifacts: ProposalArtifactStore,
    request_schemas: ProposalRequestSchemaRegistry,
    rate_store: ProposalRateStore,
    sessions: BTreeMap<String, DaemonSession>,
}

struct DaemonSession {
    store: ProposalSubmissionStore,
}

impl ProposalDaemon {
    pub fn create(
        root: &Path,
        run_id: &str,
        nonce: &str,
        source_fingerprint_hex: &str,
    ) -> Result<Self, ControlError> {
        Self::create_with_request_schemas(
            root,
            run_id,
            nonce,
            source_fingerprint_hex,
            ProposalRequestSchemaRegistry::standard(),
        )
    }

    pub fn create_with_request_schemas(
        root: &Path,
        run_id: &str,
        nonce: &str,
        source_fingerprint_hex: &str,
        request_schemas: ProposalRequestSchemaRegistry,
    ) -> Result<Self, ControlError> {
        let source_fingerprint = parse_digest(source_fingerprint_hex, "source fingerprint")?;
        fs::create_dir(root)?;
        fs::set_permissions(root, fs::Permissions::from_mode(0o700))?;
        File::open(root)?.sync_all()?;
        if let Some(parent) = root.parent().filter(|path| !path.as_os_str().is_empty()) {
            File::open(parent)?.sync_all()?;
        }
        let mut clock = ControllerClock::new()?;
        let now_ms = clock.now_ms()?;
        let artifacts = ProposalArtifactStore::create(
            root.parent().ok_or_else(|| {
                ControlError::Invalid("proposal root has no run directory".into())
            })?,
            &root
                .parent()
                .ok_or_else(|| ControlError::Invalid("proposal root has no run directory".into()))?
                .join("proposal-artifacts"),
        )
        .map_err(invalid)?;
        let rate_binding =
            session_binding(run_id, nonce, "proposal-rate-store", source_fingerprint);
        let rate_store =
            ProposalRateStore::create(&root.join("rates"), rate_binding, RATE_STORE_CONFIG, now_ms)
                .map_err(invalid)?;
        Ok(Self {
            root: root.to_path_buf(),
            run_id: run_id.into(),
            nonce: nonce.into(),
            source_fingerprint,
            clock,
            retry_policy: RetryPolicy {
                maximum_retries: 4,
                base_delay_ms: 250,
                maximum_delay_ms: 30_000,
            },
            artifacts,
            request_schemas,
            rate_store,
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
        self.artifacts
            .create_session(&session_id)
            .map_err(invalid)?;
        let request_upload_directory = self
            .artifacts
            .request_upload_directory(&session_id)
            .map_err(invalid)?;
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
        self.rate_store
            .register_session(&session_id, now_ms)
            .map_err(invalid)?;
        let session = DaemonSession { store };
        if self.sessions.insert(session_id.clone(), session).is_some() {
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
            request_upload_directory,
            request_schemas: self.request_schemas.views(),
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
        let request_schema =
            ProposalRequestSchemaId::from_hex(&request.request_schema).map_err(invalid)?;
        self.request_schemas
            .validate(
                request_schema,
                request.proposer_id,
                request.role,
                request.request_bytes,
            )
            .map_err(invalid)?;
        let key = ProposalIdempotencyKey::new_typed(
            &request.session_id,
            request.request_id,
            request_schema.as_bytes(),
            payload,
        )?;
        if self
            .sessions
            .get(&request.session_id)
            .ok_or_else(|| ControlError::Invalid("unknown external proposer session".into()))?
            .store
            .tickets()
            .get(key)
            .is_some()
        {
            self.expire_session(&request.session_id, now_ms)?;
            let session = self.session_mut(&request.session_id)?;
            let ticket = session
                .store
                .tickets()
                .get(key)
                .ok_or_else(|| ControlError::Invalid("submitted ticket disappeared".into()))?;
            if !same_logical_submission(ticket, &request) {
                return Err(ControlError::Invalid(
                    "proposal idempotency identity names a different resource envelope".into(),
                ));
            }
            return Ok(ProposalSubmitted {
                ticket_key: key.to_hex(),
                disposition: ProposalTicketSubmission::Existing,
                ticket,
                usage: session.store.session().map_err(invalid)?.usage(),
            });
        }
        let deadlines = ProposalDeadlines::new(
            add_deadline(now_ms, request.queue_timeout_ms)?,
            add_deadline(now_ms, request.execution_timeout_ms)?,
            add_deadline(now_ms, request.retention_timeout_ms)?,
            add_deadline(now_ms, request.admission_timeout_ms)?,
        )?;
        let spec = ProposalTicketSpec {
            key,
            request_schema: request_schema.as_bytes(),
            request_blake3: payload,
            request_bytes: request.request_bytes,
            proposer_id: request.proposer_id,
            role: request.role,
            deadlines,
            cost_units: request.cost_units,
            max_return_bytes: request.maximum_return_bytes,
        };
        let mut preview = self
            .sessions
            .get(&request.session_id)
            .ok_or_else(|| ControlError::Invalid("unknown external proposer session".into()))?
            .store
            .session()
            .map_err(invalid)?
            .clone();
        preview.reserve(spec, now_ms).map_err(invalid)?;
        self.charge_submission_rates(&request.session_id, request.proposer_id, now_ms)?;
        self.artifacts
            .publish_request(
                &request.session_id,
                request.request_id,
                key,
                payload,
                request.request_bytes,
            )
            .map_err(invalid)?;
        let session = self.session_mut(&request.session_id)?;
        let disposition = session.store.submit(spec, now_ms).map_err(invalid)?;
        let ticket = session
            .store
            .tickets()
            .get(key)
            .ok_or_else(|| ControlError::Invalid("submitted ticket disappeared".into()))?;
        let usage = session.store.session().map_err(invalid)?.usage();
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
        self.expire_session(&request.session_id, now_ms)?;
        let session = self.session_mut(&request.session_id)?;
        view(key, &session.store)
    }

    pub fn claim(
        &mut self,
        request: ProposalTicketRequest,
    ) -> Result<ProposalClaimed, ControlError> {
        let now_ms = self.clock.now_ms()?;
        let key = ProposalIdempotencyKey::from_hex(&request.ticket_key)?;
        let (provider_id, status) = {
            self.expire_session(&request.session_id, now_ms)?;
            let session = self.session_mut(&request.session_id)?;
            let ticket =
                session.store.tickets().get(key).ok_or_else(|| {
                    ControlError::Invalid("unknown external proposal ticket".into())
                })?;
            (ticket.spec.proposer_id, ticket.status)
        };
        let provider_permit = if status_needs_provider_permit(status, now_ms) {
            let permit = self
                .rate_store
                .preview_provider_permit(provider_id, now_ms)
                .map_err(invalid)?;
            match permit {
                CircuitPermit::Denied {
                    retry_at_ms: u64::MAX,
                } => {
                    return self.provider_blocked_claim(
                        &request.session_id,
                        key,
                        ProposalTicketClaim::ProviderBusy,
                    );
                }
                CircuitPermit::Denied { retry_at_ms } => {
                    return self.provider_blocked_claim(
                        &request.session_id,
                        key,
                        ProposalTicketClaim::ProviderDeferred { retry_at_ms },
                    );
                }
                CircuitPermit::Normal | CircuitPermit::HalfOpenProbe => Some(permit),
            }
        } else {
            None
        };
        let claim = self
            .session_mut(&request.session_id)?
            .store
            .claim(key, now_ms)
            .map_err(invalid)?;
        if matches!(claim, ProposalTicketClaim::Started { .. })
            && provider_permit == Some(CircuitPermit::HalfOpenProbe)
            && self
                .rate_store
                .claim_provider_permit(provider_id, key, now_ms)
                .map_err(invalid)?
                != CircuitPermit::HalfOpenProbe
        {
            return Err(ControlError::Invalid(
                "provider half-open permit changed during claim".into(),
            ));
        }
        let session = self.session_mut(&request.session_id)?;
        let view = view(key, &session.store)?;
        let attempt = match claim {
            ProposalTicketClaim::Started { attempt } | ProposalTicketClaim::Busy { attempt } => {
                Some(attempt)
            }
            ProposalTicketClaim::Deferred { .. }
            | ProposalTicketClaim::ProviderDeferred { .. }
            | ProposalTicketClaim::ProviderBusy
            | ProposalTicketClaim::Terminal { .. } => None,
        };
        let upload_relative_path = attempt
            .map(|attempt| {
                self.artifacts
                    .upload_relative_path(&request.session_id, key, attempt)
            })
            .transpose()
            .map_err(invalid)?;
        let request_artifact = attempt
            .map(|_| {
                self.artifacts.inspect_request(
                    &request.session_id,
                    key,
                    view.ticket.spec.request_blake3,
                    view.ticket.spec.request_bytes,
                )
            })
            .transpose()
            .map_err(invalid)?
            .map(artifact_view);
        let request_schema = attempt
            .map(|_| {
                self.request_schemas
                    .validate(
                        ProposalRequestSchemaId::from_bytes(view.ticket.spec.request_schema),
                        view.ticket.spec.proposer_id,
                        view.ticket.spec.role,
                        view.ticket.spec.request_bytes,
                    )
                    .map(|schema| schema.view())
            })
            .transpose()
            .map_err(invalid)?;
        Ok(ProposalClaimed {
            ticket_key: view.ticket_key,
            claim,
            ticket: view.ticket,
            usage: view.usage,
            upload_relative_path,
            request_artifact,
            request_schema,
        })
    }

    fn provider_blocked_claim(
        &mut self,
        session_id: &str,
        key: ProposalIdempotencyKey,
        claim: ProposalTicketClaim,
    ) -> Result<ProposalClaimed, ControlError> {
        let session = self.session_mut(session_id)?;
        let view = view(key, &session.store)?;
        Ok(ProposalClaimed {
            ticket_key: view.ticket_key,
            claim,
            ticket: view.ticket,
            usage: view.usage,
            upload_relative_path: None,
            request_artifact: None,
            request_schema: None,
        })
    }

    fn expire_session(&mut self, session_id: &str, now_ms: u64) -> Result<(), ControlError> {
        let terminal = {
            let session = self.session_mut(session_id)?;
            session.store.expire_due(now_ms).map_err(invalid)?;
            session
                .store
                .tickets()
                .snapshot()
                .tickets
                .into_iter()
                .filter(|ticket| ticket.status.is_terminal())
                .map(|ticket| (ticket.spec.proposer_id, ticket.spec.key))
                .collect::<Vec<_>>()
        };
        for (provider_id, key) in terminal {
            self.rate_store
                .release_provider_ticket(provider_id, key)
                .map_err(invalid)?;
        }
        Ok(())
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
        let (provider_id, new_failure) =
            {
                let session = self.sessions.get(&request.session_id).ok_or_else(|| {
                    ControlError::Invalid("unknown external proposer session".into())
                })?;
                let ticket = session.store.tickets().get(key).ok_or_else(|| {
                    ControlError::Invalid("unknown external proposal ticket".into())
                })?;
                let new_failure = matches!(
                    ticket.status,
                    ProposalTicketStatus::Running { attempt, .. } if attempt == request.attempt
                );
                (ticket.spec.proposer_id, new_failure)
            };
        if new_failure {
            self.rate_store
                .record_provider_failure(provider_id, key, request.failure, now_ms)
                .map_err(invalid)?;
        }
        let session = self.session_mut(&request.session_id)?;
        let action = session
            .store
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
        let view = view(key, &session.store)?;
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
        let (maximum_bytes, provider_id, new_completion) = {
            let session = self
                .sessions
                .get(&request.session_id)
                .ok_or_else(|| ControlError::Invalid("unknown external proposer session".into()))?;
            let ticket =
                session.store.tickets().get(key).ok_or_else(|| {
                    ControlError::Invalid("unknown external proposal ticket".into())
                })?;
            let new_completion = match ticket.status {
                ProposalTicketStatus::Running { attempt, .. } if attempt == request.attempt => true,
                ProposalTicketStatus::Ready { attempt, .. } if attempt == request.attempt => false,
                _ => {
                    return Err(ControlError::Invalid(
                        "proposal completion does not name the active attempt".into(),
                    ));
                }
            };
            (
                ticket.spec.max_return_bytes,
                ticket.spec.proposer_id,
                new_completion,
            )
        };
        let artifact = self
            .artifacts
            .publish(&request.session_id, key, request.attempt, maximum_bytes)
            .map_err(invalid)?;
        let session = self.session_mut(&request.session_id)?;
        session
            .store
            .complete(
                key,
                request.attempt,
                artifact.blake3,
                artifact.bytes,
                now_ms,
            )
            .map_err(invalid)?;
        let mut view = view(key, &session.store)?;
        view.artifact = Some(artifact_view(artifact));
        if new_completion {
            self.rate_store
                .record_provider_success(provider_id, key)
                .map_err(invalid)?;
        }
        Ok(view)
    }

    pub fn cancel(
        &mut self,
        request: ProposalTicketRequest,
    ) -> Result<ProposalTicketView, ControlError> {
        let now_ms = self.clock.now_ms()?;
        let key = ProposalIdempotencyKey::from_hex(&request.ticket_key)?;
        let (provider_id, view) = {
            let session = self.session_mut(&request.session_id)?;
            session.store.cancel(key, now_ms).map_err(invalid)?;
            let view = view(key, &session.store)?;
            (view.ticket.spec.proposer_id, view)
        };
        self.rate_store
            .release_provider_ticket(provider_id, key)
            .map_err(invalid)?;
        Ok(view)
    }

    pub fn result(
        &mut self,
        request: ProposalTicketRequest,
    ) -> Result<ProposalTicketView, ControlError> {
        let now_ms = self.clock.now_ms()?;
        let key = ProposalIdempotencyKey::from_hex(&request.ticket_key)?;
        let (ready, maximum_bytes) = {
            let session = self.session_mut(&request.session_id)?;
            let ready = session.store.result(key, now_ms).map_err(invalid)?;
            let maximum_bytes = session
                .store
                .tickets()
                .get(key)
                .ok_or_else(|| ControlError::Invalid("unknown external proposal ticket".into()))?
                .spec
                .max_return_bytes;
            (ready, maximum_bytes)
        };
        let artifact = self
            .artifacts
            .inspect(
                &request.session_id,
                key,
                maximum_bytes,
                Some((ready.result_blake3, ready.result_bytes)),
            )
            .map_err(invalid)?;
        let session = self.session_mut(&request.session_id)?;
        let mut view = view(key, &session.store)?;
        view.artifact = Some(artifact_view(artifact));
        Ok(view)
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
        let session = self.session_mut(&request.session_id)?;
        session
            .store
            .reserve_revision(digest, request.role, now_ms)
            .map_err(invalid)?;
        Ok(session.store.session().map_err(invalid)?.usage())
    }

    fn charge_submission_rates(
        &mut self,
        session_id: &str,
        provider_id: u16,
        now_ms: u64,
    ) -> Result<(), ControlError> {
        self.rate_store
            .charge(session_id, provider_id, now_ms)
            .map_err(invalid)
    }

    fn session_mut(&mut self, session_id: &str) -> Result<&mut DaemonSession, ControlError> {
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
        artifact: None,
    })
}

fn artifact_view(artifact: super::ProposalArtifact) -> ProposalArtifactView {
    ProposalArtifactView {
        relative_path: artifact.relative_path,
        blake3: blake3::Hash::from(artifact.blake3).to_hex().to_string(),
        bytes: artifact.bytes,
    }
}

fn status_needs_provider_permit(status: ProposalTicketStatus, now_ms: u64) -> bool {
    matches!(status, ProposalTicketStatus::Queued)
        || matches!(
            status,
            ProposalTicketStatus::RetryWait { not_before_ms, .. } if now_ms >= not_before_ms
        )
}

fn same_logical_submission(
    ticket: ProposalTicketSnapshot,
    request: &ProposalSubmitRequest,
) -> bool {
    ticket.spec.proposer_id == request.proposer_id
        && ticket.spec.role == request.role
        && ticket.spec.request_schema
            == ProposalRequestSchemaId::from_hex(&request.request_schema)
                .ok()
                .map(ProposalRequestSchemaId::as_bytes)
                .unwrap_or([0; 32])
        && ticket.spec.request_blake3
            == blake3::Hash::from_hex(&request.canonical_payload_blake3)
                .ok()
                .map(|digest| *digest.as_bytes())
                .unwrap_or([0; 32])
        && ticket.spec.request_bytes == request.request_bytes
        && ticket.spec.cost_units == request.cost_units
        && ticket.spec.max_return_bytes == request.maximum_return_bytes
        && ticket
            .spec
            .deadlines
            .queue_by_ms
            .checked_sub(ticket.created_ms)
            == Some(request.queue_timeout_ms)
        && ticket
            .spec
            .deadlines
            .execute_by_ms
            .checked_sub(ticket.created_ms)
            == Some(request.execution_timeout_ms)
        && ticket
            .spec
            .deadlines
            .admit_by_ms
            .checked_sub(ticket.created_ms)
            == Some(request.admission_timeout_ms)
        && ticket
            .spec
            .deadlines
            .retain_until_ms
            .checked_sub(ticket.created_ms)
            == Some(request.retention_timeout_ms)
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
    if request.request_bytes == 0 || request.request_bytes > MAX_EXTERNAL_REQUEST_BYTES {
        return Err(ControlError::Invalid(
            "proposal request bytes are outside the operation bound".into(),
        ));
    }
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
    use crate::control::{ProposalRequestEncoding, ProposalRequestSchemaSpec};
    use std::fs::OpenOptions;
    use std::io::Write;
    use std::os::unix::fs::OpenOptionsExt;

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
            request_bytes: 7,
            request_schema: ProposalRequestSchemaRegistry::standard().views()[0]
                .id
                .clone(),
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

    fn stage_request(daemon: &ProposalDaemon, request: &ProposalSubmitRequest, payload: &[u8]) {
        assert_eq!(
            request.canonical_payload_blake3,
            blake3::hash(payload).to_hex().to_string()
        );
        assert_eq!(request.request_bytes, payload.len() as u64);
        let path = daemon.root.parent().unwrap().join(
            daemon
                .artifacts
                .request_upload_relative_path(&request.session_id, request.request_id)
                .unwrap(),
        );
        fs::write(&path, payload).unwrap();
        fs::set_permissions(&path, fs::Permissions::from_mode(0o600)).unwrap();
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
        let request = submit(&opened.session_id);
        stage_request(&daemon, &request, b"payload");
        let submitted = daemon.submit(request).unwrap();
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
        assert_eq!(
            claim.request_schema,
            opened.request_schemas.first().cloned()
        );
        let upload = temporary
            .path()
            .join(claim.upload_relative_path.as_ref().unwrap());
        let mut output = OpenOptions::new()
            .write(true)
            .create_new(true)
            .mode(0o600)
            .open(upload)
            .unwrap();
        output.write_all(b"result").unwrap();
        output.sync_all().unwrap();
        let completed = daemon
            .complete(ProposalCompleteRequest {
                session_id: opened.session_id,
                ticket_key: submitted.ticket_key,
                attempt: 0,
            })
            .unwrap();
        assert_eq!(completed.usage.outstanding, 0);
        assert_eq!(completed.usage.charged_work_units, 5);
        assert_eq!(completed.artifact.unwrap().bytes, 6);
    }

    #[test]
    fn schema_registry_gates_and_binds_streamed_requests() {
        let temporary = tempfile::tempdir().unwrap();
        let first = ProposalRequestSchemaSpec::new(
            "test.first",
            1,
            ProposalRequestEncoding::CanonicalCbor,
            7,
            ProposalRole::Heuristic.mask(),
            vec![3].into_boxed_slice(),
        )
        .unwrap();
        let second = ProposalRequestSchemaSpec::new(
            "test.second",
            1,
            ProposalRequestEncoding::TypedPlan,
            7,
            ProposalRole::Heuristic.mask(),
            vec![3].into_boxed_slice(),
        )
        .unwrap();
        let first_id = first.id().to_hex();
        let second_id = second.id().to_hex();
        let registry = ProposalRequestSchemaRegistry::new([first, second]).unwrap();
        let mut daemon = ProposalDaemon::create_with_request_schemas(
            &temporary.path().join("proposals"),
            "run",
            "nonce",
            blake3::hash(b"source").to_hex().as_ref(),
            registry,
        )
        .unwrap();
        let opened = daemon.open_session(offer()).unwrap();
        assert_eq!(opened.request_schemas.len(), 2);

        let mut rejected = submit(&opened.session_id);
        rejected.request_schema = "0".repeat(64);
        stage_request(&daemon, &rejected, b"payload");
        assert!(daemon.submit(rejected).is_err());
        assert_eq!(
            daemon
                .sessions
                .get(&opened.session_id)
                .unwrap()
                .store
                .session()
                .unwrap()
                .usage()
                .queries,
            0
        );

        let mut first_request = submit(&opened.session_id);
        first_request.request_schema = first_id;
        let first_submission = daemon.submit(first_request).unwrap();
        let mut second_request = submit(&opened.session_id);
        second_request.request_schema = second_id;
        stage_request(&daemon, &second_request, b"payload");
        let second_submission = daemon.submit(second_request).unwrap();
        assert_ne!(first_submission.ticket_key, second_submission.ticket_key);
        assert_ne!(
            first_submission.ticket.spec.request_schema,
            second_submission.ticket.spec.request_schema
        );
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
                .store
                .session()
                .unwrap()
                .usage()
                .queries,
            0
        );
    }

    #[test]
    fn hierarchical_rate_charge_is_atomic_and_duplicates_are_free() {
        let temporary = tempfile::tempdir().unwrap();
        let mut daemon = ProposalDaemon::create(
            &temporary.path().join("proposals"),
            "run",
            "nonce",
            blake3::hash(b"source").to_hex().as_ref(),
        )
        .unwrap();
        let mut generous = offer();
        generous.maximum_queries = 20;
        generous.maximum_work_units = 200;
        generous.maximum_return_bytes = 2_000;
        let opened = daemon.open_session(generous).unwrap();
        let mut first = None;
        for request_id in 1..=16 {
            let mut request = submit(&opened.session_id);
            request.request_id = request_id;
            request.canonical_payload_blake3 =
                blake3::hash(&request_id.to_le_bytes()).to_hex().to_string();
            request.request_bytes = 8;
            stage_request(&daemon, &request, &request_id.to_le_bytes());
            let submitted = daemon.submit(request).unwrap();
            first.get_or_insert(submitted.clone());
            daemon
                .cancel(ProposalTicketRequest {
                    session_id: opened.session_id.clone(),
                    ticket_key: submitted.ticket_key,
                })
                .unwrap();
        }
        let mut limited = submit(&opened.session_id);
        limited.request_id = 17;
        limited.canonical_payload_blake3 = blake3::hash(b"seventeenth").to_hex().to_string();
        limited.request_bytes = 11;
        stage_request(&daemon, &limited, b"seventeenth");
        assert!(matches!(
            daemon.submit(limited),
            Err(ControlError::Invalid(message)) if message.contains("rate limited")
        ));

        let first = first.unwrap();
        let mut duplicate = submit(&opened.session_id);
        duplicate.canonical_payload_blake3 =
            blake3::hash(&1_u64.to_le_bytes()).to_hex().to_string();
        duplicate.request_bytes = 8;
        assert_eq!(
            daemon.submit(duplicate).unwrap().disposition,
            ProposalTicketSubmission::Existing
        );
        let mut changed = submit(&opened.session_id);
        changed.canonical_payload_blake3 = blake3::hash(&1_u64.to_le_bytes()).to_hex().to_string();
        changed.request_bytes = 8;
        changed.cost_units = 6;
        assert!(matches!(
            daemon.submit(changed),
            Err(ControlError::Invalid(message)) if message.contains("different resource envelope")
        ));
        assert_eq!(first.usage.charged_work_units, 5);
    }

    #[test]
    fn repeated_backend_failures_open_provider_circuit_before_claim() {
        let temporary = tempfile::tempdir().unwrap();
        let mut daemon = ProposalDaemon::create(
            &temporary.path().join("proposals"),
            "run",
            "nonce",
            blake3::hash(b"source").to_hex().as_ref(),
        )
        .unwrap();
        let mut generous = offer();
        generous.maximum_queries = 8;
        generous.maximum_outstanding = 4;
        let opened = daemon.open_session(generous).unwrap();
        for request_id in 1..=3 {
            let mut request = submit(&opened.session_id);
            request.request_id = request_id;
            request.canonical_payload_blake3 =
                blake3::hash(&request_id.to_le_bytes()).to_hex().to_string();
            request.request_bytes = 8;
            stage_request(&daemon, &request, &request_id.to_le_bytes());
            let submitted = daemon.submit(request).unwrap();
            assert!(matches!(
                daemon
                    .claim(ProposalTicketRequest {
                        session_id: opened.session_id.clone(),
                        ticket_key: submitted.ticket_key.clone(),
                    })
                    .unwrap()
                    .claim,
                ProposalTicketClaim::Started { attempt: 0 }
            ));
            daemon
                .report_failure(ProposalFailureRequest {
                    session_id: opened.session_id.clone(),
                    ticket_key: submitted.ticket_key,
                    attempt: 0,
                    failure: ProposalFailureClass::BackendCrash,
                    provider_retry_after_ms: None,
                })
                .unwrap();
        }
        let mut request = submit(&opened.session_id);
        request.request_id = 4;
        request.canonical_payload_blake3 = blake3::hash(b"fourth").to_hex().to_string();
        request.request_bytes = 6;
        stage_request(&daemon, &request, b"fourth");
        let submitted = daemon.submit(request).unwrap();
        assert!(matches!(
            daemon
                .claim(ProposalTicketRequest {
                    session_id: opened.session_id,
                    ticket_key: submitted.ticket_key,
                })
                .unwrap()
                .claim,
            ProposalTicketClaim::ProviderDeferred { .. }
        ));
    }

    #[test]
    fn cancelling_half_open_probe_releases_exact_ticket_lease() {
        let temporary = tempfile::tempdir().unwrap();
        let mut daemon = ProposalDaemon::create(
            &temporary.path().join("proposals"),
            "run",
            "nonce",
            blake3::hash(b"source").to_hex().as_ref(),
        )
        .unwrap();
        let opened = daemon.open_session(offer()).unwrap();
        let request = submit(&opened.session_id);
        stage_request(&daemon, &request, b"payload");
        let first = daemon.submit(request).unwrap();
        let first_key = ProposalIdempotencyKey::from_hex(&first.ticket_key).unwrap();
        for _ in 0..3 {
            daemon
                .rate_store
                .record_provider_failure(3, first_key, ProposalFailureClass::BackendCrash, 0)
                .unwrap();
        }
        assert!(matches!(
            daemon
                .claim(ProposalTicketRequest {
                    session_id: opened.session_id.clone(),
                    ticket_key: first.ticket_key.clone(),
                })
                .unwrap()
                .claim,
            ProposalTicketClaim::Started { attempt: 0 }
        ));
        daemon
            .cancel(ProposalTicketRequest {
                session_id: opened.session_id.clone(),
                ticket_key: first.ticket_key,
            })
            .unwrap();

        let mut second_request = submit(&opened.session_id);
        second_request.request_id = 2;
        second_request.canonical_payload_blake3 = blake3::hash(b"second").to_hex().to_string();
        second_request.request_bytes = 6;
        stage_request(&daemon, &second_request, b"second");
        let second = daemon.submit(second_request).unwrap();
        assert!(matches!(
            daemon
                .claim(ProposalTicketRequest {
                    session_id: opened.session_id,
                    ticket_key: second.ticket_key,
                })
                .unwrap()
                .claim,
            ProposalTicketClaim::Started { attempt: 0 }
        ));
    }
}
