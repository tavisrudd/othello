//! Durable hierarchical admission-rate state for external proposers.

use super::{
    charge_token_buckets, CircuitBreaker, CircuitBreakerConfig, CircuitBreakerSnapshot,
    CircuitPermit, ProposalFailureClass, ProposalIdempotencyKey, TokenBucket, TokenBucketConfig,
    TokenBucketSnapshot,
};
use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;
use std::fs::{self, File, OpenOptions};
use std::io::{self, Read, Write};
use std::os::unix::fs::{OpenOptionsExt, PermissionsExt};
use std::path::{Path, PathBuf};

const SCHEMA: &str = "ergodis-proposal-rate-store-v4";
const SNAPSHOT_FILE: &str = "rates.json";
const MAX_SNAPSHOT_BYTES: u64 = 256 * 1024;
const MAX_STALE_TEMP_FILES: usize = 16;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct ProposalRateStoreConfig {
    pub campaign: TokenBucketConfig,
    pub provider: TokenBucketConfig,
    pub session: TokenBucketConfig,
    pub circuit: CircuitBreakerConfig,
    pub maximum_providers: usize,
    pub maximum_sessions: usize,
}

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
struct ProposalRateSnapshot {
    schema: String,
    binding: [u8; 32],
    campaign: TokenBucketSnapshot,
    providers: Vec<ProviderRateSnapshot>,
    sessions: Vec<SessionRateSnapshot>,
}

#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
struct ProviderRateSnapshot {
    provider_id: u16,
    bucket: TokenBucketSnapshot,
    circuit: CircuitBreakerSnapshot,
    half_open_ticket: Option<ProposalIdempotencyKey>,
    rate_limited_until_ms: u64,
}

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
struct SessionRateSnapshot {
    session_id: String,
    bucket: TokenBucketSnapshot,
}

#[derive(Debug, thiserror::Error)]
pub enum ProposalRateStoreError {
    #[error("proposal-rate store I/O failed: {0}")]
    Io(#[from] io::Error),
    #[error("proposal-rate store JSON failed: {0}")]
    Json(#[from] serde_json::Error),
    #[error("proposal-rate store is malformed or incompatible")]
    InvalidStore,
    #[error("proposal-rate store rejected the charge: {0}")]
    Rate(String),
    #[error("proposal-rate store is poisoned after an ambiguous durable write")]
    Poisoned,
}

pub struct ProposalRateStore {
    root: PathBuf,
    binding: [u8; 32],
    config: ProposalRateStoreConfig,
    campaign: TokenBucket,
    providers: BTreeMap<u16, ProviderState>,
    sessions: BTreeMap<String, TokenBucket>,
    temp_sequence: u64,
    poisoned: bool,
}

#[derive(Clone, Debug)]
struct ProviderState {
    bucket: TokenBucket,
    circuit: CircuitBreaker,
    half_open_ticket: Option<ProposalIdempotencyKey>,
    rate_limited_until_ms: u64,
}

impl ProposalRateStore {
    pub fn create(
        root: &Path,
        binding: [u8; 32],
        config: ProposalRateStoreConfig,
        now_ms: u64,
    ) -> Result<Self, ProposalRateStoreError> {
        validate_config(config)?;
        fs::create_dir(root)?;
        fs::set_permissions(root, fs::Permissions::from_mode(0o700))?;
        let store = Self {
            root: root.to_path_buf(),
            binding,
            config,
            campaign: TokenBucket::full(config.campaign, now_ms)
                .map_err(|error| ProposalRateStoreError::Rate(error.to_string()))?,
            providers: BTreeMap::new(),
            sessions: BTreeMap::new(),
            temp_sequence: 1,
            poisoned: false,
        };
        write_create_atomic(root, 0, &store.snapshot())?;
        sync_directory(root)?;
        if let Some(parent) = root.parent().filter(|path| !path.as_os_str().is_empty()) {
            sync_directory(parent)?;
        }
        Ok(store)
    }

    pub fn open(
        root: &Path,
        expected_binding: [u8; 32],
        config: ProposalRateStoreConfig,
        now_ms: u64,
    ) -> Result<Self, ProposalRateStoreError> {
        validate_config(config)?;
        validate_private_directory(root)?;
        let temp_sequence = inspect_directory(root)?;
        let snapshot: ProposalRateSnapshot =
            read_bounded_json(&root.join(SNAPSHOT_FILE), MAX_SNAPSHOT_BYTES)?;
        if snapshot.schema != SCHEMA
            || snapshot.binding != expected_binding
            || snapshot.providers.len() > config.maximum_providers
            || snapshot.sessions.len() > config.maximum_sessions
        {
            return Err(ProposalRateStoreError::InvalidStore);
        }
        let campaign = TokenBucket::restore(config.campaign, snapshot.campaign, now_ms)
            .map_err(|_| ProposalRateStoreError::InvalidStore)?;
        let mut providers = BTreeMap::new();
        for provider in snapshot.providers {
            let bucket = TokenBucket::restore(config.provider, provider.bucket, now_ms)
                .map_err(|_| ProposalRateStoreError::InvalidStore)?;
            let circuit = CircuitBreaker::restore(config.circuit, provider.circuit, now_ms)
                .map_err(|_| ProposalRateStoreError::InvalidStore)?;
            if circuit.snapshot().half_open_claimed != provider.half_open_ticket.is_some() {
                return Err(ProposalRateStoreError::InvalidStore);
            }
            if providers
                .insert(
                    provider.provider_id,
                    ProviderState {
                        bucket,
                        circuit,
                        half_open_ticket: provider.half_open_ticket,
                        rate_limited_until_ms: provider.rate_limited_until_ms,
                    },
                )
                .is_some()
            {
                return Err(ProposalRateStoreError::InvalidStore);
            }
        }
        let mut sessions = BTreeMap::new();
        for session in snapshot.sessions {
            validate_session_id(&session.session_id)?;
            let bucket = TokenBucket::restore(config.session, session.bucket, now_ms)
                .map_err(|_| ProposalRateStoreError::InvalidStore)?;
            if sessions.insert(session.session_id, bucket).is_some() {
                return Err(ProposalRateStoreError::InvalidStore);
            }
        }
        Ok(Self {
            root: root.to_path_buf(),
            binding: expected_binding,
            config,
            campaign,
            providers,
            sessions,
            temp_sequence,
            poisoned: false,
        })
    }

    pub fn register_session(
        &mut self,
        session_id: &str,
        now_ms: u64,
    ) -> Result<(), ProposalRateStoreError> {
        self.ensure_healthy()?;
        validate_session_id(session_id)?;
        if self.sessions.contains_key(session_id) {
            return Ok(());
        }
        if self.sessions.len() == self.config.maximum_sessions {
            return Err(ProposalRateStoreError::InvalidStore);
        }
        let bucket = TokenBucket::full(self.config.session, now_ms)
            .map_err(|error| ProposalRateStoreError::Rate(error.to_string()))?;
        self.sessions.insert(session_id.into(), bucket);
        self.persist()
    }

    pub fn charge(
        &mut self,
        session_id: &str,
        provider_id: u16,
        now_ms: u64,
    ) -> Result<(), ProposalRateStoreError> {
        self.ensure_healthy()?;
        let mut campaign = self.campaign.clone();
        let mut provider = match self.providers.get(&provider_id) {
            Some(provider) => provider.clone(),
            None => {
                if self.providers.len() == self.config.maximum_providers {
                    return Err(ProposalRateStoreError::InvalidStore);
                }
                ProviderState {
                    bucket: TokenBucket::full(self.config.provider, now_ms)
                        .map_err(|error| ProposalRateStoreError::Rate(error.to_string()))?,
                    circuit: CircuitBreaker::new(self.config.circuit)
                        .map_err(|error| ProposalRateStoreError::Rate(error.to_string()))?,
                    half_open_ticket: None,
                    rate_limited_until_ms: 0,
                }
            }
        };
        let mut session = self
            .sessions
            .get(session_id)
            .cloned()
            .ok_or(ProposalRateStoreError::InvalidStore)?;
        let mut buckets = [campaign, provider.bucket, session];
        charge_token_buckets(&mut buckets, &[1, 1, 1], now_ms)
            .map_err(|error| ProposalRateStoreError::Rate(error.to_string()))?;
        [campaign, provider.bucket, session] = buckets;
        self.campaign = campaign;
        self.providers.insert(provider_id, provider);
        self.sessions.insert(session_id.into(), session);
        self.persist()
    }

    pub fn preview_provider_permit(
        &self,
        provider_id: u16,
        now_ms: u64,
    ) -> Result<CircuitPermit, ProposalRateStoreError> {
        self.ensure_healthy()?;
        let provider = self
            .providers
            .get(&provider_id)
            .ok_or(ProposalRateStoreError::InvalidStore)?;
        if now_ms < provider.rate_limited_until_ms {
            return Ok(CircuitPermit::Denied {
                retry_at_ms: provider.rate_limited_until_ms,
            });
        }
        let mut circuit = provider.circuit;
        Ok(circuit.permit(now_ms))
    }

    pub fn claim_provider_permit(
        &mut self,
        provider_id: u16,
        ticket_key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<CircuitPermit, ProposalRateStoreError> {
        self.ensure_healthy()?;
        let provider = self
            .providers
            .get_mut(&provider_id)
            .ok_or(ProposalRateStoreError::InvalidStore)?;
        if now_ms < provider.rate_limited_until_ms {
            return Ok(CircuitPermit::Denied {
                retry_at_ms: provider.rate_limited_until_ms,
            });
        }
        let before = provider.circuit.snapshot();
        let permit = provider.circuit.permit(now_ms);
        if permit == CircuitPermit::HalfOpenProbe {
            if provider.half_open_ticket.is_some() {
                return Err(ProposalRateStoreError::InvalidStore);
            }
            provider.half_open_ticket = Some(ticket_key);
        }
        if provider.circuit.snapshot() != before {
            self.persist()?;
        }
        Ok(permit)
    }

    pub fn defer_provider_until(
        &mut self,
        provider_id: u16,
        not_before_ms: u64,
        now_ms: u64,
    ) -> Result<(), ProposalRateStoreError> {
        self.ensure_healthy()?;
        if not_before_ms <= now_ms {
            return Err(ProposalRateStoreError::InvalidStore);
        }
        let provider = self
            .providers
            .get_mut(&provider_id)
            .ok_or(ProposalRateStoreError::InvalidStore)?;
        if not_before_ms <= provider.rate_limited_until_ms {
            return Ok(());
        }
        provider.rate_limited_until_ms = not_before_ms;
        self.persist()
    }

    pub fn record_provider_failure(
        &mut self,
        provider_id: u16,
        ticket_key: ProposalIdempotencyKey,
        failure: ProposalFailureClass,
        now_ms: u64,
    ) -> Result<(), ProposalRateStoreError> {
        self.ensure_healthy()?;
        let provider = self
            .providers
            .get_mut(&provider_id)
            .ok_or(ProposalRateStoreError::InvalidStore)?;
        let before = provider.circuit.snapshot();
        let before_ticket = provider.half_open_ticket;
        provider.circuit.record_failure(failure, now_ms);
        if provider.half_open_ticket == Some(ticket_key) {
            if provider.circuit.snapshot().half_open_claimed {
                provider.circuit.release_half_open();
            }
            provider.half_open_ticket = None;
        } else if !provider.circuit.snapshot().half_open_claimed {
            provider.half_open_ticket = None;
        }
        if provider.circuit.snapshot() != before || provider.half_open_ticket != before_ticket {
            self.persist()?;
        }
        Ok(())
    }

    pub fn record_provider_success(
        &mut self,
        provider_id: u16,
        _ticket_key: ProposalIdempotencyKey,
    ) -> Result<(), ProposalRateStoreError> {
        self.ensure_healthy()?;
        let provider = self
            .providers
            .get_mut(&provider_id)
            .ok_or(ProposalRateStoreError::InvalidStore)?;
        let before = provider.circuit.snapshot();
        provider.circuit.record_success();
        provider.half_open_ticket = None;
        if provider.circuit.snapshot() != before {
            self.persist()?;
        }
        Ok(())
    }

    pub fn release_provider_ticket(
        &mut self,
        provider_id: u16,
        ticket_key: ProposalIdempotencyKey,
    ) -> Result<(), ProposalRateStoreError> {
        self.ensure_healthy()?;
        let provider = self
            .providers
            .get_mut(&provider_id)
            .ok_or(ProposalRateStoreError::InvalidStore)?;
        if provider.half_open_ticket != Some(ticket_key) {
            return Ok(());
        }
        provider.circuit.release_half_open();
        provider.half_open_ticket = None;
        self.persist()
    }

    fn snapshot(&self) -> ProposalRateSnapshot {
        ProposalRateSnapshot {
            schema: SCHEMA.into(),
            binding: self.binding,
            campaign: self.campaign.snapshot(),
            providers: self
                .providers
                .iter()
                .map(|(&provider_id, provider)| ProviderRateSnapshot {
                    provider_id,
                    bucket: provider.bucket.snapshot(),
                    circuit: provider.circuit.snapshot(),
                    half_open_ticket: provider.half_open_ticket,
                    rate_limited_until_ms: provider.rate_limited_until_ms,
                })
                .collect(),
            sessions: self
                .sessions
                .iter()
                .map(|(session_id, bucket)| SessionRateSnapshot {
                    session_id: session_id.clone(),
                    bucket: bucket.snapshot(),
                })
                .collect(),
        }
    }

    fn persist(&mut self) -> Result<(), ProposalRateStoreError> {
        let sequence = self.temp_sequence;
        self.temp_sequence = self
            .temp_sequence
            .checked_add(1)
            .ok_or(ProposalRateStoreError::InvalidStore)?;
        if let Err(error) = write_replace_atomic(&self.root, sequence, &self.snapshot()) {
            self.poisoned = true;
            return Err(error);
        }
        Ok(())
    }

    fn ensure_healthy(&self) -> Result<(), ProposalRateStoreError> {
        if self.poisoned {
            Err(ProposalRateStoreError::Poisoned)
        } else {
            Ok(())
        }
    }
}

fn validate_config(config: ProposalRateStoreConfig) -> Result<(), ProposalRateStoreError> {
    if config.maximum_providers == 0 || config.maximum_sessions == 0 {
        return Err(ProposalRateStoreError::InvalidStore);
    }
    CircuitBreaker::new(config.circuit).map_err(|_| ProposalRateStoreError::InvalidStore)?;
    Ok(())
}

fn validate_session_id(session_id: &str) -> Result<(), ProposalRateStoreError> {
    if session_id.len() == 32
        && session_id
            .bytes()
            .all(|byte| byte.is_ascii_digit() || (b'a'..=b'f').contains(&byte))
    {
        Ok(())
    } else {
        Err(ProposalRateStoreError::InvalidStore)
    }
}

fn inspect_directory(root: &Path) -> Result<u64, ProposalRateStoreError> {
    let mut stale_temps = 0;
    let mut next_sequence = 1;
    let own_prefix = format!(".tmp-{}-", std::process::id());
    for entry in fs::read_dir(root)? {
        let entry = entry?;
        let name = entry
            .file_name()
            .into_string()
            .map_err(|_| ProposalRateStoreError::InvalidStore)?;
        if name.starts_with(".tmp-") {
            stale_temps += 1;
            if stale_temps > MAX_STALE_TEMP_FILES || !entry.file_type()?.is_file() {
                return Err(ProposalRateStoreError::InvalidStore);
            }
            if let Some(suffix) = name.strip_prefix(&own_prefix) {
                let sequence = u64::from_str_radix(suffix, 16)
                    .map_err(|_| ProposalRateStoreError::InvalidStore)?;
                next_sequence = next_sequence.max(
                    sequence
                        .checked_add(1)
                        .ok_or(ProposalRateStoreError::InvalidStore)?,
                );
            }
        } else if name != SNAPSHOT_FILE || !entry.file_type()?.is_file() {
            return Err(ProposalRateStoreError::InvalidStore);
        }
    }
    Ok(next_sequence)
}

fn write_create_atomic(
    root: &Path,
    sequence: u64,
    value: &impl Serialize,
) -> Result<(), ProposalRateStoreError> {
    let temporary = temporary_path(root, sequence);
    write_temporary(&temporary, value)?;
    if let Err(error) = fs::hard_link(&temporary, root.join(SNAPSHOT_FILE)) {
        let _ = fs::remove_file(&temporary);
        return Err(error.into());
    }
    fs::remove_file(temporary)?;
    sync_directory(root)
}

fn write_replace_atomic(
    root: &Path,
    sequence: u64,
    value: &impl Serialize,
) -> Result<(), ProposalRateStoreError> {
    let temporary = temporary_path(root, sequence);
    write_temporary(&temporary, value)?;
    if let Err(error) = fs::rename(&temporary, root.join(SNAPSHOT_FILE)) {
        let _ = fs::remove_file(&temporary);
        return Err(error.into());
    }
    sync_directory(root)
}

fn write_temporary(path: &Path, value: &impl Serialize) -> Result<(), ProposalRateStoreError> {
    let mut encoded = serde_json::to_vec(value)?;
    encoded.push(b'\n');
    if encoded.len() as u64 > MAX_SNAPSHOT_BYTES {
        return Err(ProposalRateStoreError::InvalidStore);
    }
    let mut file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .custom_flags(libc::O_NOFOLLOW)
        .open(path)?;
    file.write_all(&encoded)?;
    file.sync_all()?;
    Ok(())
}

fn read_bounded_json<T: for<'de> Deserialize<'de>>(
    path: &Path,
    maximum_bytes: u64,
) -> Result<T, ProposalRateStoreError> {
    let mut file = OpenOptions::new()
        .read(true)
        .custom_flags(libc::O_NOFOLLOW)
        .open(path)?;
    let metadata = file.metadata()?;
    if !metadata.is_file()
        || metadata.len() > maximum_bytes
        || metadata.permissions().mode() & 0o077 != 0
    {
        return Err(ProposalRateStoreError::InvalidStore);
    }
    let mut encoded = Vec::with_capacity(metadata.len() as usize);
    file.read_to_end(&mut encoded)?;
    if encoded.len() as u64 > maximum_bytes {
        return Err(ProposalRateStoreError::InvalidStore);
    }
    Ok(serde_json::from_slice(&encoded)?)
}

fn validate_private_directory(path: &Path) -> Result<(), ProposalRateStoreError> {
    let metadata = fs::symlink_metadata(path)?;
    if !metadata.is_dir() || metadata.permissions().mode() & 0o077 != 0 {
        return Err(ProposalRateStoreError::InvalidStore);
    }
    Ok(())
}

fn temporary_path(root: &Path, sequence: u64) -> PathBuf {
    root.join(format!(".tmp-{}-{sequence:016x}", std::process::id()))
}

fn sync_directory(path: &Path) -> Result<(), ProposalRateStoreError> {
    File::open(path)?.sync_all()?;
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    const CONFIG: ProposalRateStoreConfig = ProposalRateStoreConfig {
        campaign: TokenBucketConfig {
            capacity: 4,
            refill_units: 4,
            refill_period_ms: 1_000,
        },
        provider: TokenBucketConfig {
            capacity: 2,
            refill_units: 2,
            refill_period_ms: 1_000,
        },
        session: TokenBucketConfig {
            capacity: 2,
            refill_units: 2,
            refill_period_ms: 1_000,
        },
        circuit: CircuitBreakerConfig {
            failure_threshold: 2,
            base_open_ms: 100,
            maximum_open_ms: 1_000,
        },
        maximum_providers: 2,
        maximum_sessions: 2,
    };

    #[test]
    fn durable_charge_does_not_refill_on_reopen() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("rates");
        let session = "0123456789abcdef0123456789abcdef";
        let mut store = ProposalRateStore::create(&root, [7; 32], CONFIG, 10).unwrap();
        store.register_session(session, 10).unwrap();
        store.charge(session, 3, 10).unwrap();
        store.charge(session, 3, 10).unwrap();
        assert!(matches!(
            store.charge(session, 3, 10),
            Err(ProposalRateStoreError::Rate(message)) if message.contains("rate limited")
        ));
        drop(store);

        let mut reopened = ProposalRateStore::open(&root, [7; 32], CONFIG, 10).unwrap();
        assert!(matches!(
            reopened.charge(session, 3, 10),
            Err(ProposalRateStoreError::Rate(message)) if message.contains("rate limited")
        ));
        reopened.charge(session, 3, 510).unwrap();
    }

    #[test]
    fn wrong_binding_and_duplicate_snapshot_entries_fail_closed() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("rates");
        let session = "0123456789abcdef0123456789abcdef";
        let mut store = ProposalRateStore::create(&root, [7; 32], CONFIG, 10).unwrap();
        store.register_session(session, 10).unwrap();
        drop(store);
        assert!(matches!(
            ProposalRateStore::open(&root, [8; 32], CONFIG, 10),
            Err(ProposalRateStoreError::InvalidStore)
        ));

        let path = root.join(SNAPSHOT_FILE);
        let mut snapshot: ProposalRateSnapshot =
            read_bounded_json(&path, MAX_SNAPSHOT_BYTES).unwrap();
        snapshot.sessions.push(snapshot.sessions[0].clone());
        fs::write(&path, serde_json::to_vec(&snapshot).unwrap()).unwrap();
        fs::set_permissions(&path, fs::Permissions::from_mode(0o600)).unwrap();
        assert!(matches!(
            ProposalRateStore::open(&root, [7; 32], CONFIG, 10),
            Err(ProposalRateStoreError::InvalidStore)
        ));
    }

    #[test]
    fn provider_circuit_survives_reopen_and_persists_half_open_claim() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("rates");
        let session = "0123456789abcdef0123456789abcdef";
        let ticket = ProposalIdempotencyKey::new(session, 1, [3; 32]).unwrap();
        let mut store = ProposalRateStore::create(&root, [7; 32], CONFIG, 10).unwrap();
        store.register_session(session, 10).unwrap();
        store.charge(session, 3, 10).unwrap();
        store
            .record_provider_failure(3, ticket, ProposalFailureClass::BackendCrash, 10)
            .unwrap();
        assert_eq!(
            store.claim_provider_permit(3, ticket, 10).unwrap(),
            CircuitPermit::Normal
        );
        store
            .record_provider_failure(3, ticket, ProposalFailureClass::BackendCrash, 10)
            .unwrap();
        assert_eq!(
            store.claim_provider_permit(3, ticket, 10).unwrap(),
            CircuitPermit::Denied { retry_at_ms: 110 }
        );
        drop(store);

        let mut reopened = ProposalRateStore::open(&root, [7; 32], CONFIG, 110).unwrap();
        assert_eq!(
            reopened.claim_provider_permit(3, ticket, 110).unwrap(),
            CircuitPermit::HalfOpenProbe
        );
        drop(reopened);
        let mut reopened = ProposalRateStore::open(&root, [7; 32], CONFIG, 110).unwrap();
        assert_eq!(
            reopened.claim_provider_permit(3, ticket, 110).unwrap(),
            CircuitPermit::Denied {
                retry_at_ms: u64::MAX
            }
        );
        reopened.release_provider_ticket(3, ticket).unwrap();
        assert_eq!(
            reopened.claim_provider_permit(3, ticket, 110).unwrap(),
            CircuitPermit::HalfOpenProbe
        );
        reopened.record_provider_success(3, ticket).unwrap();
        assert_eq!(
            reopened.claim_provider_permit(3, ticket, 110).unwrap(),
            CircuitPermit::Normal
        );
    }

    #[test]
    fn provider_rate_limit_defers_sibling_tickets_across_reopen() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("rates");
        let session = "0123456789abcdef0123456789abcdef";
        let first = ProposalIdempotencyKey::new(session, 1, [3; 32]).unwrap();
        let sibling = ProposalIdempotencyKey::new(session, 2, [4; 32]).unwrap();
        let mut store = ProposalRateStore::create(&root, [7; 32], CONFIG, 10).unwrap();
        store.register_session(session, 10).unwrap();
        store.charge(session, 3, 10).unwrap();
        store.defer_provider_until(3, 510, 10).unwrap();
        assert_eq!(
            store.preview_provider_permit(3, 509).unwrap(),
            CircuitPermit::Denied { retry_at_ms: 510 }
        );
        assert_eq!(
            store.claim_provider_permit(3, first, 509).unwrap(),
            CircuitPermit::Denied { retry_at_ms: 510 }
        );
        drop(store);

        let mut reopened = ProposalRateStore::open(&root, [7; 32], CONFIG, 509).unwrap();
        assert_eq!(
            reopened.claim_provider_permit(3, sibling, 509).unwrap(),
            CircuitPermit::Denied { retry_at_ms: 510 }
        );
        assert_eq!(
            reopened.claim_provider_permit(3, sibling, 510).unwrap(),
            CircuitPermit::Normal
        );
    }
}
