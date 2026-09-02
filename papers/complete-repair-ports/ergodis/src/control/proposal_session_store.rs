//! Atomic durable publication for one bounded external-proposer session.

use super::{
    ProposalIdempotencyKey, ProposalRevisionReservation, ProposalRole, ProposalSession,
    ProposalSessionError, ProposalSessionReservation, ProposalTicketSpec,
};
use serde::{de::DeserializeOwned, Serialize};
use std::fs::{self, File, OpenOptions};
use std::io::{self, Read, Write};
use std::os::unix::fs::{OpenOptionsExt, PermissionsExt};
use std::path::{Path, PathBuf};

const SNAPSHOT_FILE: &str = "session.json";
const MAX_SNAPSHOT_BYTES: u64 = 4 * 1024 * 1024;
const MAX_STALE_TEMP_FILES: usize = 16;

#[derive(Debug, thiserror::Error)]
pub enum ProposalSessionStoreError {
    #[error("proposal-session store I/O failed: {0}")]
    Io(#[from] io::Error),
    #[error("proposal-session store JSON failed: {0}")]
    Json(#[from] serde_json::Error),
    #[error(transparent)]
    Session(#[from] ProposalSessionError),
    #[error("proposal-session store is malformed or incompatible")]
    InvalidStore,
    #[error("proposal-session store is poisoned after an ambiguous durable write")]
    Poisoned,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
enum ProposalSessionTerminal {
    Settled,
    Cancelled,
}

pub struct ProposalSessionStore {
    root: PathBuf,
    session: ProposalSession,
    temp_sequence: u64,
    poisoned: bool,
}

impl ProposalSessionStore {
    pub fn create(
        root: &Path,
        session: ProposalSession,
    ) -> Result<Self, ProposalSessionStoreError> {
        fs::create_dir(root)?;
        fs::set_permissions(root, fs::Permissions::from_mode(0o700))?;
        write_create_atomic(root, 0, &session.snapshot())?;
        sync_directory(root)?;
        if let Some(parent) = root.parent().filter(|path| !path.as_os_str().is_empty()) {
            sync_directory(parent)?;
        }
        Ok(Self {
            root: root.to_path_buf(),
            session,
            temp_sequence: 1,
            poisoned: false,
        })
    }

    pub fn open(
        root: &Path,
        expected_session_binding: [u8; 32],
        expected_source_fingerprint: [u8; 32],
        now_ms: u64,
    ) -> Result<Self, ProposalSessionStoreError> {
        validate_private_directory(root)?;
        let mut stale_temps = 0_usize;
        let own_temp_prefix = format!(".tmp-{}-", std::process::id());
        let mut next_temp_sequence = 1_u64;
        for entry in fs::read_dir(root)? {
            let entry = entry?;
            let name = entry
                .file_name()
                .into_string()
                .map_err(|_| ProposalSessionStoreError::InvalidStore)?;
            if name.starts_with(".tmp-") {
                stale_temps += 1;
                if stale_temps > MAX_STALE_TEMP_FILES || !entry.file_type()?.is_file() {
                    return Err(ProposalSessionStoreError::InvalidStore);
                }
                if let Some(suffix) = name.strip_prefix(&own_temp_prefix) {
                    let sequence = u64::from_str_radix(suffix, 16)
                        .map_err(|_| ProposalSessionStoreError::InvalidStore)?;
                    next_temp_sequence = next_temp_sequence.max(
                        sequence
                            .checked_add(1)
                            .ok_or(ProposalSessionStoreError::InvalidStore)?,
                    );
                }
            } else if name != SNAPSHOT_FILE || !entry.file_type()?.is_file() {
                return Err(ProposalSessionStoreError::InvalidStore);
            }
        }
        let snapshot = read_bounded_json(&root.join(SNAPSHOT_FILE), MAX_SNAPSHOT_BYTES)?;
        let session = ProposalSession::restore(snapshot, now_ms)?;
        if session.session_binding() != expected_session_binding
            || session.source_fingerprint() != expected_source_fingerprint
        {
            return Err(ProposalSessionStoreError::InvalidStore);
        }
        Ok(Self {
            root: root.to_path_buf(),
            session,
            temp_sequence: next_temp_sequence,
            poisoned: false,
        })
    }

    pub fn root(&self) -> &Path {
        &self.root
    }

    pub fn session(&self) -> Result<&ProposalSession, ProposalSessionStoreError> {
        self.ensure_healthy()?;
        Ok(&self.session)
    }

    pub fn reserve(
        &mut self,
        spec: ProposalTicketSpec,
        now_ms: u64,
    ) -> Result<ProposalSessionReservation, ProposalSessionStoreError> {
        self.ensure_healthy()?;
        let result = self.session.reserve(spec, now_ms)?;
        if result == ProposalSessionReservation::Created {
            self.persist()?;
        }
        Ok(result)
    }

    pub fn reserve_revision(
        &mut self,
        canonical_payload_blake3: [u8; 32],
        role: ProposalRole,
        now_ms: u64,
    ) -> Result<ProposalRevisionReservation, ProposalSessionStoreError> {
        self.ensure_healthy()?;
        let result = self
            .session
            .reserve_revision(canonical_payload_blake3, role, now_ms)?;
        if result == ProposalRevisionReservation::Created {
            self.persist()?;
        }
        Ok(result)
    }

    pub fn settle(
        &mut self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<bool, ProposalSessionStoreError> {
        self.transition(key, ProposalSessionTerminal::Settled, now_ms)
    }

    pub fn cancel(
        &mut self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<bool, ProposalSessionStoreError> {
        self.transition(key, ProposalSessionTerminal::Cancelled, now_ms)
    }

    fn transition(
        &mut self,
        key: ProposalIdempotencyKey,
        terminal: ProposalSessionTerminal,
        now_ms: u64,
    ) -> Result<bool, ProposalSessionStoreError> {
        self.ensure_healthy()?;
        let changed = match terminal {
            ProposalSessionTerminal::Settled => self.session.settle(key, now_ms)?,
            ProposalSessionTerminal::Cancelled => self.session.cancel(key, now_ms)?,
        };
        if changed {
            self.persist()?;
        }
        Ok(changed)
    }

    fn persist(&mut self) -> Result<(), ProposalSessionStoreError> {
        let sequence = self.next_temp_sequence()?;
        if let Err(error) = write_replace_atomic(&self.root, sequence, &self.session.snapshot()) {
            self.poisoned = true;
            return Err(error);
        }
        Ok(())
    }

    fn next_temp_sequence(&mut self) -> Result<u64, ProposalSessionStoreError> {
        let sequence = self.temp_sequence;
        self.temp_sequence = self
            .temp_sequence
            .checked_add(1)
            .ok_or(ProposalSessionStoreError::InvalidStore)?;
        Ok(sequence)
    }

    fn ensure_healthy(&self) -> Result<(), ProposalSessionStoreError> {
        if self.poisoned {
            Err(ProposalSessionStoreError::Poisoned)
        } else {
            Ok(())
        }
    }
}

fn write_create_atomic(
    root: &Path,
    sequence: u64,
    value: &impl Serialize,
) -> Result<(), ProposalSessionStoreError> {
    let temporary = temporary_path(root, sequence);
    let destination = root.join(SNAPSHOT_FILE);
    write_temporary(&temporary, value)?;
    if let Err(error) = fs::hard_link(&temporary, &destination) {
        let _ = fs::remove_file(&temporary);
        return Err(error.into());
    }
    fs::remove_file(&temporary)?;
    sync_directory(root)?;
    Ok(())
}

fn write_replace_atomic(
    root: &Path,
    sequence: u64,
    value: &impl Serialize,
) -> Result<(), ProposalSessionStoreError> {
    let temporary = temporary_path(root, sequence);
    write_temporary(&temporary, value)?;
    if let Err(error) = fs::rename(&temporary, root.join(SNAPSHOT_FILE)) {
        let _ = fs::remove_file(&temporary);
        return Err(error.into());
    }
    sync_directory(root)?;
    Ok(())
}

fn write_temporary(path: &Path, value: &impl Serialize) -> Result<(), ProposalSessionStoreError> {
    let mut encoded = serde_json::to_vec(value)?;
    encoded.push(b'\n');
    if encoded.len() as u64 > MAX_SNAPSHOT_BYTES {
        return Err(ProposalSessionStoreError::InvalidStore);
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

fn read_bounded_json<T: DeserializeOwned>(
    path: &Path,
    maximum_bytes: u64,
) -> Result<T, ProposalSessionStoreError> {
    let mut file = OpenOptions::new()
        .read(true)
        .custom_flags(libc::O_NOFOLLOW)
        .open(path)?;
    let metadata = file.metadata()?;
    if !metadata.is_file()
        || metadata.len() > maximum_bytes
        || metadata.permissions().mode() & 0o077 != 0
    {
        return Err(ProposalSessionStoreError::InvalidStore);
    }
    let mut encoded = Vec::with_capacity(metadata.len() as usize);
    file.read_to_end(&mut encoded)?;
    if encoded.len() as u64 > maximum_bytes {
        return Err(ProposalSessionStoreError::InvalidStore);
    }
    Ok(serde_json::from_slice(&encoded)?)
}

fn validate_private_directory(path: &Path) -> Result<(), ProposalSessionStoreError> {
    let metadata = fs::symlink_metadata(path)?;
    if !metadata.is_dir() || metadata.permissions().mode() & 0o077 != 0 {
        return Err(ProposalSessionStoreError::InvalidStore);
    }
    Ok(())
}

fn sync_directory(path: &Path) -> Result<(), ProposalSessionStoreError> {
    File::open(path)?.sync_all()?;
    Ok(())
}

fn temporary_path(root: &Path, sequence: u64) -> PathBuf {
    root.join(format!(".tmp-{}-{sequence:016x}", std::process::id()))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::control::{ProposalDeadlines, ProposalSessionLimits, ProposalSessionQueryStatus};

    fn limits() -> ProposalSessionLimits {
        ProposalSessionLimits {
            allowed_roles: ProposalRole::Heuristic.mask(),
            expires_ms: 1_000,
            maximum_queries: 4,
            maximum_outstanding: 2,
            maximum_revisions: 2,
            maximum_work_units: 20,
            maximum_return_bytes: 200,
        }
    }

    fn key(request: u64) -> ProposalIdempotencyKey {
        ProposalIdempotencyKey::new("durable-session", request, [request as u8; 32]).unwrap()
    }

    fn spec(request: u64) -> ProposalTicketSpec {
        ProposalTicketSpec {
            key: key(request),
            proposer_id: 3,
            role: ProposalRole::Heuristic,
            deadlines: ProposalDeadlines::new(100, 500, 900, 700).unwrap(),
            cost_units: 5,
            max_return_bytes: 50,
        }
    }

    #[test]
    fn reservations_and_terminal_state_survive_restart() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("session");
        let session = ProposalSession::new([1; 32], [7; 32], limits(), 10).unwrap();
        {
            let mut store = ProposalSessionStore::create(&root, session).unwrap();
            assert_eq!(store.root(), root);
            assert_eq!(
                store.reserve(spec(1), 11).unwrap(),
                ProposalSessionReservation::Created
            );
            assert!(store.settle(key(1), 12).unwrap());
            store
                .reserve_revision([3; 32], ProposalRole::Heuristic, 13)
                .unwrap();
        }
        fs::write(
            root.join(format!(".tmp-{}-0000000000000064", std::process::id())),
            b"crash-leftover",
        )
        .unwrap();
        let mut store = ProposalSessionStore::open(&root, [1; 32], [7; 32], 20).unwrap();
        assert_eq!(
            store.session().unwrap().get(key(1)).unwrap().status,
            ProposalSessionQueryStatus::Settled
        );
        assert_eq!(
            store.reserve(spec(1), 20).unwrap(),
            ProposalSessionReservation::Existing {
                status: ProposalSessionQueryStatus::Settled
            }
        );
        assert_eq!(store.session().unwrap().usage().charged_work_units, 5);
    }

    #[test]
    fn corrupt_snapshot_and_loose_permissions_fail_closed() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("session");
        let session = ProposalSession::new([1; 32], [7; 32], limits(), 10).unwrap();
        drop(ProposalSessionStore::create(&root, session).unwrap());
        fs::write(root.join(SNAPSHOT_FILE), b"not json").unwrap();
        assert!(ProposalSessionStore::open(&root, [1; 32], [7; 32], 20).is_err());
        fs::set_permissions(&root, fs::Permissions::from_mode(0o755)).unwrap();
        assert!(matches!(
            ProposalSessionStore::open(&root, [1; 32], [7; 32], 20),
            Err(ProposalSessionStoreError::InvalidStore)
        ));
    }

    #[test]
    fn store_is_bound_to_session_and_source() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("session");
        let session = ProposalSession::new([1; 32], [7; 32], limits(), 10).unwrap();
        drop(ProposalSessionStore::create(&root, session).unwrap());
        assert!(matches!(
            ProposalSessionStore::open(&root, [2; 32], [7; 32], 20),
            Err(ProposalSessionStoreError::InvalidStore)
        ));
        assert!(matches!(
            ProposalSessionStore::open(&root, [1; 32], [8; 32], 20),
            Err(ProposalSessionStoreError::InvalidStore)
        ));
    }

    #[test]
    fn persistence_failure_poisons_without_publishing_reservation() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("session");
        let session = ProposalSession::new([1; 32], [7; 32], limits(), 10).unwrap();
        let mut store = ProposalSessionStore::create(&root, session).unwrap();
        fs::set_permissions(&root, fs::Permissions::from_mode(0o500)).unwrap();
        assert!(matches!(
            store.reserve(spec(1), 11),
            Err(ProposalSessionStoreError::Io(_))
        ));
        assert!(matches!(
            store.reserve(spec(2), 12),
            Err(ProposalSessionStoreError::Poisoned)
        ));
        fs::set_permissions(&root, fs::Permissions::from_mode(0o700)).unwrap();
        drop(store);
        let restored = ProposalSessionStore::open(&root, [1; 32], [7; 32], 20).unwrap();
        assert!(restored.session().unwrap().get(key(1)).is_none());
    }
}
