//! Atomic disk persistence for controller-owned proposer tickets.

use super::{
    ProposalFailureReport, ProposalIdempotencyKey, ProposalReadyResult, ProposalTicketClaim,
    ProposalTicketError, ProposalTicketLedger, ProposalTicketLedgerSnapshot,
    ProposalTicketSnapshot, ProposalTicketSpec, ProposalTicketSubmission, RetryAction,
    PROPOSAL_TICKET_LEDGER_SCHEMA,
};
use serde::{Deserialize, Serialize};
use std::fs::{self, File, OpenOptions};
use std::io::{self, BufWriter, Read, Write};
use std::os::unix::fs::{OpenOptionsExt, PermissionsExt};
use std::path::{Path, PathBuf};

pub const PROPOSAL_TICKET_STORE_SCHEMA: &str = "ergodis-proposal-ticket-store-v3";
const METADATA_FILE: &str = "metadata.json";
const TICKETS_DIRECTORY: &str = "tickets";
const MAX_METADATA_BYTES: u64 = 4 * 1024;
const MAX_TICKET_BYTES: u64 = 16 * 1024;
const MAX_STALE_TEMP_FILES: usize = 16;

#[derive(Debug, thiserror::Error)]
pub enum ProposalTicketStoreError {
    #[error("proposal ticket store is poisoned after a persistence failure")]
    Poisoned,
    #[error("proposal ticket store structure is invalid")]
    InvalidStore,
    #[error(transparent)]
    Ticket(#[from] ProposalTicketError),
    #[error(transparent)]
    Io(#[from] io::Error),
    #[error(transparent)]
    Json(#[from] serde_json::Error),
}

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
struct StoreMetadata {
    schema: String,
    ticket_schema: String,
    max_tickets: u32,
}

pub struct ProposalTicketStore {
    root: PathBuf,
    tickets_dir: PathBuf,
    ledger: ProposalTicketLedger,
    temp_sequence: u64,
    poisoned: bool,
}

impl ProposalTicketStore {
    pub fn create(root: &Path, max_tickets: usize) -> Result<Self, ProposalTicketStoreError> {
        let ledger = ProposalTicketLedger::new(max_tickets)?;
        fs::create_dir(root)?;
        fs::set_permissions(root, fs::Permissions::from_mode(0o700))?;
        let tickets_dir = root.join(TICKETS_DIRECTORY);
        fs::create_dir(&tickets_dir)?;
        fs::set_permissions(&tickets_dir, fs::Permissions::from_mode(0o700))?;
        let metadata = StoreMetadata {
            schema: PROPOSAL_TICKET_STORE_SCHEMA.into(),
            ticket_schema: PROPOSAL_TICKET_LEDGER_SCHEMA.into(),
            max_tickets: max_tickets as u32,
        };
        write_create_atomic(root, &root.join(METADATA_FILE), 0, &metadata)?;
        sync_directory(&tickets_dir)?;
        sync_directory(root)?;
        if let Some(parent) = root.parent().filter(|path| !path.as_os_str().is_empty()) {
            sync_directory(parent)?;
        }
        Ok(Self {
            root: root.to_path_buf(),
            tickets_dir,
            ledger,
            temp_sequence: 1,
            poisoned: false,
        })
    }

    pub fn open(
        root: &Path,
        configured_max_tickets: usize,
        now_ms: u64,
    ) -> Result<Self, ProposalTicketStoreError> {
        validate_private_directory(root)?;
        let tickets_dir = root.join(TICKETS_DIRECTORY);
        validate_private_directory(&tickets_dir)?;
        let metadata: StoreMetadata =
            read_bounded_json(&root.join(METADATA_FILE), MAX_METADATA_BYTES)?;
        if metadata.schema != PROPOSAL_TICKET_STORE_SCHEMA
            || metadata.ticket_schema != PROPOSAL_TICKET_LEDGER_SCHEMA
            || metadata.max_tickets as usize != configured_max_tickets
        {
            return Err(ProposalTicketStoreError::InvalidStore);
        }
        let mut tickets = Vec::with_capacity(configured_max_tickets.min(1024));
        let mut stale_temps = 0;
        let own_temp_prefix = format!(".tmp-{}-", std::process::id());
        let mut next_temp_sequence = 1_u64;
        for entry in fs::read_dir(&tickets_dir)? {
            let entry = entry?;
            let name = entry
                .file_name()
                .into_string()
                .map_err(|_| ProposalTicketStoreError::InvalidStore)?;
            if name.starts_with(".tmp-") {
                stale_temps += 1;
                if stale_temps > MAX_STALE_TEMP_FILES {
                    return Err(ProposalTicketStoreError::InvalidStore);
                }
                if let Some(suffix) = name.strip_prefix(&own_temp_prefix) {
                    let sequence = u64::from_str_radix(suffix, 16)
                        .map_err(|_| ProposalTicketStoreError::InvalidStore)?;
                    next_temp_sequence = next_temp_sequence.max(
                        sequence
                            .checked_add(1)
                            .ok_or(ProposalTicketStoreError::InvalidStore)?,
                    );
                }
                continue;
            }
            if !entry.file_type()?.is_file() || !name.ends_with(".json") {
                return Err(ProposalTicketStoreError::InvalidStore);
            }
            if tickets.len() == configured_max_tickets {
                return Err(ProposalTicketStoreError::InvalidStore);
            }
            let ticket: ProposalTicketSnapshot =
                read_bounded_json(&entry.path(), MAX_TICKET_BYTES)?;
            if name != ticket_filename(ticket.spec.key) {
                return Err(ProposalTicketStoreError::InvalidStore);
            }
            tickets.push(ticket);
        }
        let ledger = ProposalTicketLedger::restore(
            ProposalTicketLedgerSnapshot {
                schema: PROPOSAL_TICKET_LEDGER_SCHEMA.into(),
                max_tickets: configured_max_tickets as u32,
                tickets,
            },
            configured_max_tickets,
            now_ms,
        )?;
        let mut store = Self {
            root: root.to_path_buf(),
            tickets_dir,
            ledger,
            temp_sequence: next_temp_sequence,
            poisoned: false,
        };
        store.persist_all_changed_from_disk(now_ms)?;
        Ok(store)
    }

    pub fn ledger(&self) -> &ProposalTicketLedger {
        &self.ledger
    }

    pub fn root(&self) -> &Path {
        &self.root
    }

    pub fn submit(
        &mut self,
        spec: ProposalTicketSpec,
        now_ms: u64,
    ) -> Result<ProposalTicketSubmission, ProposalTicketStoreError> {
        self.ensure_healthy()?;
        let before = self.ledger.get(spec.key);
        let result = self.ledger.submit(spec, now_ms);
        self.persist_transition(spec.key, before)?;
        Ok(result?)
    }

    pub fn claim(
        &mut self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<ProposalTicketClaim, ProposalTicketStoreError> {
        self.ensure_healthy()?;
        let before = self.ledger.get(key);
        let result = self.ledger.claim(key, now_ms);
        self.persist_transition(key, before)?;
        Ok(result?)
    }

    pub fn record_failure(
        &mut self,
        key: ProposalIdempotencyKey,
        report: ProposalFailureReport,
    ) -> Result<RetryAction, ProposalTicketStoreError> {
        self.ensure_healthy()?;
        let before = self.ledger.get(key);
        let result = self.ledger.record_failure(key, report);
        self.persist_transition(key, before)?;
        Ok(result?)
    }

    pub fn complete(
        &mut self,
        key: ProposalIdempotencyKey,
        completed_attempt: u8,
        result_blake3: [u8; 32],
        result_bytes: u64,
        now_ms: u64,
    ) -> Result<(), ProposalTicketStoreError> {
        self.ensure_healthy()?;
        let before = self.ledger.get(key);
        let result =
            self.ledger
                .complete(key, completed_attempt, result_blake3, result_bytes, now_ms);
        self.persist_transition(key, before)?;
        Ok(result?)
    }

    pub fn cancel(
        &mut self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<bool, ProposalTicketStoreError> {
        self.ensure_healthy()?;
        let before = self.ledger.get(key);
        let result = self.ledger.cancel(key, now_ms);
        self.persist_transition(key, before)?;
        Ok(result?)
    }

    pub fn result(
        &mut self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<ProposalReadyResult, ProposalTicketStoreError> {
        self.ensure_healthy()?;
        let before = self.ledger.get(key);
        let result = self.ledger.result(key, now_ms);
        self.persist_transition(key, before)?;
        Ok(result?)
    }

    pub fn admission_result(
        &self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<ProposalReadyResult, ProposalTicketStoreError> {
        self.ensure_healthy()?;
        Ok(self.ledger.admission_result(key, now_ms)?)
    }

    pub fn expire_due(&mut self, now_ms: u64) -> Result<usize, ProposalTicketStoreError> {
        self.ensure_healthy()?;
        let before = self.ledger.snapshot();
        let result = self.ledger.expire_due(now_ms);
        let after = self.ledger.snapshot();
        for (old, new) in before.tickets.iter().zip(&after.tickets) {
            if old != new {
                self.persist_snapshot(*new, false)?;
            }
        }
        Ok(result?)
    }

    fn persist_transition(
        &mut self,
        key: ProposalIdempotencyKey,
        before: Option<ProposalTicketSnapshot>,
    ) -> Result<(), ProposalTicketStoreError> {
        let after = self.ledger.get(key);
        if after == before {
            return Ok(());
        }
        let Some(after) = after else {
            self.poisoned = true;
            return Err(ProposalTicketStoreError::InvalidStore);
        };
        self.persist_snapshot(after, before.is_none())
    }

    fn persist_snapshot(
        &mut self,
        ticket: ProposalTicketSnapshot,
        create_only: bool,
    ) -> Result<(), ProposalTicketStoreError> {
        let destination = self.tickets_dir.join(ticket_filename(ticket.spec.key));
        let sequence = self.next_temp_sequence()?;
        let result = if create_only {
            write_create_atomic(&self.tickets_dir, &destination, sequence, &ticket)
        } else {
            write_replace_atomic(&self.tickets_dir, &destination, sequence, &ticket)
        };
        if let Err(error) = result {
            self.poisoned = true;
            return Err(error);
        }
        Ok(())
    }

    fn persist_all_changed_from_disk(
        &mut self,
        now_ms: u64,
    ) -> Result<(), ProposalTicketStoreError> {
        let snapshots = self.ledger.snapshot().tickets;
        for ticket in snapshots {
            if ticket.updated_ms == now_ms
                && matches!(ticket.status, super::ProposalTicketStatus::Expired { .. })
            {
                self.persist_snapshot(ticket, false)?;
            }
        }
        Ok(())
    }

    fn next_temp_sequence(&mut self) -> Result<u64, ProposalTicketStoreError> {
        let sequence = self.temp_sequence;
        self.temp_sequence = self
            .temp_sequence
            .checked_add(1)
            .ok_or(ProposalTicketStoreError::InvalidStore)?;
        Ok(sequence)
    }

    fn ensure_healthy(&self) -> Result<(), ProposalTicketStoreError> {
        if self.poisoned {
            Err(ProposalTicketStoreError::Poisoned)
        } else {
            Ok(())
        }
    }
}

fn ticket_filename(key: ProposalIdempotencyKey) -> String {
    format!("{}.json", key.to_hex())
}

fn temporary_path(directory: &Path, sequence: u64) -> PathBuf {
    directory.join(format!(".tmp-{}-{sequence:016x}", std::process::id()))
}

fn write_create_atomic(
    directory: &Path,
    destination: &Path,
    sequence: u64,
    value: &impl Serialize,
) -> Result<(), ProposalTicketStoreError> {
    let temporary = temporary_path(directory, sequence);
    write_temporary(&temporary, value)?;
    let published = fs::hard_link(&temporary, destination);
    let cleanup = fs::remove_file(&temporary);
    if let Err(error) = published {
        let _ = cleanup;
        return Err(error.into());
    }
    cleanup?;
    sync_directory(directory)?;
    Ok(())
}

fn write_replace_atomic(
    directory: &Path,
    destination: &Path,
    sequence: u64,
    value: &impl Serialize,
) -> Result<(), ProposalTicketStoreError> {
    let temporary = temporary_path(directory, sequence);
    write_temporary(&temporary, value)?;
    if let Err(error) = fs::rename(&temporary, destination) {
        let _ = fs::remove_file(&temporary);
        return Err(error.into());
    }
    sync_directory(directory)?;
    Ok(())
}

fn write_temporary(path: &Path, value: &impl Serialize) -> Result<(), ProposalTicketStoreError> {
    let file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .custom_flags(libc::O_NOFOLLOW)
        .open(path)?;
    let mut writer = BufWriter::new(file);
    serde_json::to_writer(&mut writer, value)?;
    writer.write_all(b"\n")?;
    writer.flush()?;
    writer.get_ref().sync_all()?;
    Ok(())
}

fn read_bounded_json<T: for<'de> Deserialize<'de>>(
    path: &Path,
    max_bytes: u64,
) -> Result<T, ProposalTicketStoreError> {
    if fs::symlink_metadata(path)?.file_type().is_symlink() {
        return Err(ProposalTicketStoreError::InvalidStore);
    }
    let file = OpenOptions::new()
        .read(true)
        .custom_flags(libc::O_NOFOLLOW)
        .open(path)?;
    if file.metadata()?.len() > max_bytes {
        return Err(ProposalTicketStoreError::InvalidStore);
    }
    let mut bytes = Vec::with_capacity(file.metadata()?.len() as usize);
    file.take(max_bytes + 1).read_to_end(&mut bytes)?;
    if bytes.len() as u64 > max_bytes {
        return Err(ProposalTicketStoreError::InvalidStore);
    }
    Ok(serde_json::from_slice(&bytes)?)
}

fn validate_private_directory(path: &Path) -> Result<(), ProposalTicketStoreError> {
    let metadata = fs::symlink_metadata(path)?;
    if !metadata.file_type().is_dir() || metadata.permissions().mode() & 0o077 != 0 {
        return Err(ProposalTicketStoreError::InvalidStore);
    }
    Ok(())
}

fn sync_directory(path: &Path) -> Result<(), ProposalTicketStoreError> {
    File::open(path)?.sync_all()?;
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::control::{
        DeadlineStage, ProposalDeadlines, ProposalFailureClass, ProposalRole, ProposalTicketStatus,
        RetryPolicy,
    };

    fn spec(session: &str, request: u64) -> ProposalTicketSpec {
        ProposalTicketSpec {
            key: ProposalIdempotencyKey::new(
                session,
                request,
                *blake3::hash(b"canonical payload").as_bytes(),
            )
            .unwrap(),
            request_schema: [5; 32],
            request_blake3: *blake3::hash(b"canonical payload").as_bytes(),
            request_bytes: 17,
            proposer_id: 3,
            role: ProposalRole::ExactTransport,
            deadlines: ProposalDeadlines::new(100, 500, 900, 700).unwrap(),
            cost_units: 10,
            max_return_bytes: 1_024,
        }
    }

    #[test]
    fn transitions_survive_restart_and_duplicate_callbacks() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("tickets");
        let ticket = spec("session", 1);
        {
            let mut store = ProposalTicketStore::create(&root, 8).unwrap();
            assert_eq!(store.root(), root);
            assert_eq!(
                store.submit(ticket, 10).unwrap(),
                ProposalTicketSubmission::Created
            );
            assert_eq!(
                store.claim(ticket.key, 20).unwrap(),
                ProposalTicketClaim::Started { attempt: 0 }
            );
            let report = ProposalFailureReport {
                attempt: 0,
                failure: ProposalFailureClass::TransientTransport,
                retry_policy: RetryPolicy {
                    maximum_retries: 2,
                    base_delay_ms: 50,
                    maximum_delay_ms: 100,
                },
                observed_ms: 30,
                provider_retry_after_ms: None,
                jitter_word: 50,
            };
            assert_eq!(
                store.record_failure(ticket.key, report).unwrap(),
                RetryAction::RetryAt { not_before_ms: 80 }
            );
            assert_eq!(
                store.record_failure(ticket.key, report).unwrap(),
                RetryAction::RetryAt { not_before_ms: 80 }
            );
        }
        fs::write(
            root.join(TICKETS_DIRECTORY)
                .join(format!(".tmp-{}-0000000000000064", std::process::id())),
            b"crash-leftover",
        )
        .unwrap();
        {
            let mut store = ProposalTicketStore::open(&root, 8, 40).unwrap();
            assert_eq!(
                store.claim(ticket.key, 79).unwrap(),
                ProposalTicketClaim::Deferred { not_before_ms: 80 }
            );
            assert_eq!(
                store.claim(ticket.key, 80).unwrap(),
                ProposalTicketClaim::Started { attempt: 1 }
            );
            let digest = *blake3::hash(b"result").as_bytes();
            store.complete(ticket.key, 1, digest, 12, 90).unwrap();
            store.complete(ticket.key, 1, digest, 12, 91).unwrap();
        }
        let mut restored = ProposalTicketStore::open(&root, 8, 100).unwrap();
        assert!(matches!(
            restored.ledger().get(ticket.key).unwrap().status,
            ProposalTicketStatus::Ready { attempt: 1, .. }
        ));
        assert_eq!(restored.result(ticket.key, 100).unwrap().result_bytes, 12);
    }

    #[test]
    fn restore_pins_capacity_and_persists_deadline_expiry() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("tickets");
        let ticket = spec("session", 1);
        let mut store = ProposalTicketStore::create(&root, 8).unwrap();
        store.submit(ticket, 10).unwrap();
        drop(store);
        assert!(ProposalTicketStore::open(&root, 7, 20).is_err());
        let restored = ProposalTicketStore::open(&root, 8, 101).unwrap();
        assert!(matches!(
            restored.ledger().get(ticket.key).unwrap().status,
            ProposalTicketStatus::Expired {
                stage: DeadlineStage::Queue,
                ..
            }
        ));
        drop(restored);
        let restored_again = ProposalTicketStore::open(&root, 8, 102).unwrap();
        assert!(matches!(
            restored_again.ledger().get(ticket.key).unwrap().status,
            ProposalTicketStatus::Expired { .. }
        ));
    }

    #[test]
    fn corrupt_or_misnamed_ticket_fails_closed() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("tickets");
        let ticket = spec("session", 1);
        let mut store = ProposalTicketStore::create(&root, 8).unwrap();
        store.submit(ticket, 10).unwrap();
        drop(store);
        let original = root
            .join(TICKETS_DIRECTORY)
            .join(ticket_filename(ticket.key));
        let misnamed = root
            .join(TICKETS_DIRECTORY)
            .join(format!("{}.json", "0".repeat(64)));
        fs::rename(original, misnamed).unwrap();
        assert!(ProposalTicketStore::open(&root, 8, 20).is_err());
    }

    #[test]
    fn persistence_failure_prevents_dispatch_and_poisons_store() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("tickets");
        let ticket = spec("session", 1);
        let mut store = ProposalTicketStore::create(&root, 8).unwrap();
        store.submit(ticket, 10).unwrap();
        let tickets_dir = root.join(TICKETS_DIRECTORY);
        fs::set_permissions(&tickets_dir, fs::Permissions::from_mode(0o500)).unwrap();
        assert!(matches!(
            store.claim(ticket.key, 20),
            Err(ProposalTicketStoreError::Io(_))
        ));
        assert!(matches!(
            store.claim(ticket.key, 21),
            Err(ProposalTicketStoreError::Poisoned)
        ));
        fs::set_permissions(&tickets_dir, fs::Permissions::from_mode(0o700)).unwrap();
        drop(store);
        let restored = ProposalTicketStore::open(&root, 8, 30).unwrap();
        assert_eq!(
            restored.ledger().get(ticket.key).unwrap().status,
            ProposalTicketStatus::Queued
        );
    }
}
