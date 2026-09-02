//! Crash-reconcilable composition of session quota and asynchronous tickets.
//!
//! Durable order is session reservation first, then ticket publication. A
//! restart reconstructs a missing ticket from the exact reserved specification;
//! the inverse state (ticket without reservation) fails closed.

use super::{
    ProposalFailureReport, ProposalIdempotencyKey, ProposalReadyResult,
    ProposalRevisionReservation, ProposalSession, ProposalSessionQueryStatus, ProposalSessionStore,
    ProposalSessionStoreError, ProposalTicketClaim, ProposalTicketSpec, ProposalTicketStatus,
    ProposalTicketStore, ProposalTicketStoreError, ProposalTicketSubmission, RetryAction,
    MAX_PROPOSAL_TICKETS,
};
use std::fs::{self, File};
use std::io;
use std::os::unix::fs::PermissionsExt;
use std::path::{Path, PathBuf};

const SESSION_DIRECTORY: &str = "session";
const TICKETS_DIRECTORY: &str = "tickets";

#[derive(Debug, thiserror::Error)]
pub enum ProposalSubmissionStoreError {
    #[error("proposal-submission store I/O failed: {0}")]
    Io(#[from] io::Error),
    #[error(transparent)]
    Session(#[from] ProposalSessionStoreError),
    #[error(transparent)]
    Ticket(#[from] ProposalTicketStoreError),
    #[error("proposal-submission store is malformed or inconsistent")]
    InvalidStore,
    #[error("proposal-submission controller time moved backwards")]
    ClockReversed,
}

pub struct ProposalSubmissionStore {
    root: PathBuf,
    session: ProposalSessionStore,
    tickets: ProposalTicketStore,
}

impl ProposalSubmissionStore {
    pub fn create(
        root: &Path,
        session: ProposalSession,
        max_tickets: usize,
    ) -> Result<Self, ProposalSubmissionStoreError> {
        if max_tickets < session.limits().maximum_queries as usize
            || max_tickets > MAX_PROPOSAL_TICKETS
        {
            return Err(ProposalSubmissionStoreError::InvalidStore);
        }
        fs::create_dir(root)?;
        fs::set_permissions(root, fs::Permissions::from_mode(0o700))?;
        let session = ProposalSessionStore::create(&root.join(SESSION_DIRECTORY), session)?;
        let tickets = ProposalTicketStore::create(&root.join(TICKETS_DIRECTORY), max_tickets)?;
        sync_directory(root)?;
        if let Some(parent) = root.parent().filter(|path| !path.as_os_str().is_empty()) {
            sync_directory(parent)?;
        }
        Ok(Self {
            root: root.to_path_buf(),
            session,
            tickets,
        })
    }

    pub fn open(
        root: &Path,
        expected_session_binding: [u8; 32],
        expected_source_fingerprint: [u8; 32],
        max_tickets: usize,
        now_ms: u64,
    ) -> Result<Self, ProposalSubmissionStoreError> {
        validate_root(root)?;
        let session = ProposalSessionStore::open(
            &root.join(SESSION_DIRECTORY),
            expected_session_binding,
            expected_source_fingerprint,
            now_ms,
        )?;
        if max_tickets < session.session()?.limits().maximum_queries as usize {
            return Err(ProposalSubmissionStoreError::InvalidStore);
        }
        let tickets =
            ProposalTicketStore::open(&root.join(TICKETS_DIRECTORY), max_tickets, now_ms)?;
        let mut store = Self {
            root: root.to_path_buf(),
            session,
            tickets,
        };
        store.reconcile(now_ms)?;
        Ok(store)
    }

    pub fn root(&self) -> &Path {
        &self.root
    }

    pub fn session(&self) -> Result<&ProposalSession, ProposalSubmissionStoreError> {
        Ok(self.session.session()?)
    }

    pub fn tickets(&self) -> &super::ProposalTicketLedger {
        self.tickets.ledger()
    }

    pub fn submit(
        &mut self,
        spec: ProposalTicketSpec,
        now_ms: u64,
    ) -> Result<ProposalTicketSubmission, ProposalSubmissionStoreError> {
        self.session.reserve(spec, now_ms)?;
        Ok(self.tickets.submit(spec, now_ms)?)
    }

    pub fn reserve_revision(
        &mut self,
        canonical_payload_blake3: [u8; 32],
        role: super::ProposalRole,
        now_ms: u64,
    ) -> Result<ProposalRevisionReservation, ProposalSubmissionStoreError> {
        Ok(self
            .session
            .reserve_revision(canonical_payload_blake3, role, now_ms)?)
    }

    pub fn claim(
        &mut self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<ProposalTicketClaim, ProposalSubmissionStoreError> {
        let claim = self.tickets.claim(key, now_ms)?;
        self.settle_one(key, now_ms)?;
        Ok(claim)
    }

    pub fn record_failure(
        &mut self,
        key: ProposalIdempotencyKey,
        report: ProposalFailureReport,
        now_ms: u64,
    ) -> Result<RetryAction, ProposalSubmissionStoreError> {
        if now_ms < report.observed_ms {
            return Err(ProposalSubmissionStoreError::ClockReversed);
        }
        let action = self.tickets.record_failure(key, report)?;
        self.settle_one(key, now_ms)?;
        Ok(action)
    }

    pub fn complete(
        &mut self,
        key: ProposalIdempotencyKey,
        completed_attempt: u8,
        result_blake3: [u8; 32],
        result_bytes: u64,
        now_ms: u64,
    ) -> Result<(), ProposalSubmissionStoreError> {
        self.tickets
            .complete(key, completed_attempt, result_blake3, result_bytes, now_ms)?;
        self.settle_one(key, now_ms)?;
        Ok(())
    }

    pub fn cancel(
        &mut self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<bool, ProposalSubmissionStoreError> {
        let changed = self.tickets.cancel(key, now_ms)?;
        self.settle_one(key, now_ms)?;
        Ok(changed)
    }

    pub fn result(
        &mut self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<ProposalReadyResult, ProposalSubmissionStoreError> {
        Ok(self.tickets.result(key, now_ms)?)
    }

    pub fn admission_result(
        &self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<ProposalReadyResult, ProposalSubmissionStoreError> {
        Ok(self.tickets.admission_result(key, now_ms)?)
    }

    pub fn expire_due(&mut self, now_ms: u64) -> Result<usize, ProposalSubmissionStoreError> {
        let expired = self.tickets.expire_due(now_ms)?;
        self.settle_all(now_ms)?;
        Ok(expired)
    }

    fn reconcile(&mut self, now_ms: u64) -> Result<(), ProposalSubmissionStoreError> {
        let session_snapshot = self.session.session()?.snapshot();
        let ticket_snapshot = self.tickets.ledger().snapshot();
        for ticket in &ticket_snapshot.tickets {
            let Some(query) = self.session.session()?.get(ticket.spec.key) else {
                return Err(ProposalSubmissionStoreError::InvalidStore);
            };
            if query.spec != ticket.spec {
                return Err(ProposalSubmissionStoreError::InvalidStore);
            }
        }
        for query in session_snapshot.queries {
            if self.tickets.ledger().get(query.spec.key).is_none() {
                if query.status != ProposalSessionQueryStatus::Outstanding {
                    return Err(ProposalSubmissionStoreError::InvalidStore);
                }
                match self.tickets.submit(query.spec, query.reserved_ms)? {
                    ProposalTicketSubmission::Created => {}
                    ProposalTicketSubmission::Existing => {
                        return Err(ProposalSubmissionStoreError::InvalidStore);
                    }
                }
            }
        }
        self.tickets.expire_due(now_ms)?;
        self.settle_all(now_ms)
    }

    fn settle_all(&mut self, now_ms: u64) -> Result<(), ProposalSubmissionStoreError> {
        let keys: Vec<_> = self
            .session
            .session()?
            .snapshot()
            .queries
            .into_iter()
            .map(|query| query.spec.key)
            .collect();
        for key in keys {
            self.settle_one(key, now_ms)?;
        }
        Ok(())
    }

    fn settle_one(
        &mut self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<(), ProposalSubmissionStoreError> {
        let ticket = self
            .tickets
            .ledger()
            .get(key)
            .ok_or(ProposalSubmissionStoreError::InvalidStore)?;
        let query = self
            .session
            .session()?
            .get(key)
            .ok_or(ProposalSubmissionStoreError::InvalidStore)?;
        if query.spec != ticket.spec {
            return Err(ProposalSubmissionStoreError::InvalidStore);
        }
        match (query.status, ticket.status) {
            (ProposalSessionQueryStatus::Outstanding, ProposalTicketStatus::Cancelled { .. }) => {
                self.session.cancel(key, now_ms)?;
            }
            (ProposalSessionQueryStatus::Outstanding, status) if terminal_success(status) => {
                self.session.settle(key, now_ms)?;
            }
            (ProposalSessionQueryStatus::Outstanding, _) => {}
            (ProposalSessionQueryStatus::Settled, status) if terminal_success(status) => {}
            (ProposalSessionQueryStatus::Cancelled, ProposalTicketStatus::Cancelled { .. }) => {}
            _ => return Err(ProposalSubmissionStoreError::InvalidStore),
        }
        Ok(())
    }
}

fn terminal_success(status: ProposalTicketStatus) -> bool {
    matches!(
        status,
        ProposalTicketStatus::Ready { .. }
            | ProposalTicketStatus::TerminalFailure { .. }
            | ProposalTicketStatus::Expired { .. }
    )
}

fn validate_root(root: &Path) -> Result<(), ProposalSubmissionStoreError> {
    let metadata = fs::symlink_metadata(root)?;
    if !metadata.is_dir() || metadata.permissions().mode() & 0o077 != 0 {
        return Err(ProposalSubmissionStoreError::InvalidStore);
    }
    let mut entries = 0_usize;
    for entry in fs::read_dir(root)? {
        let entry = entry?;
        let name = entry
            .file_name()
            .into_string()
            .map_err(|_| ProposalSubmissionStoreError::InvalidStore)?;
        if !entry.file_type()?.is_dir() || (name != SESSION_DIRECTORY && name != TICKETS_DIRECTORY)
        {
            return Err(ProposalSubmissionStoreError::InvalidStore);
        }
        entries += 1;
        if entries > 2 {
            return Err(ProposalSubmissionStoreError::InvalidStore);
        }
    }
    if entries != 2 {
        return Err(ProposalSubmissionStoreError::InvalidStore);
    }
    Ok(())
}

fn sync_directory(path: &Path) -> Result<(), ProposalSubmissionStoreError> {
    File::open(path)?.sync_all()?;
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::control::{
        ProposalDeadlines, ProposalFailureClass, ProposalRole, ProposalSessionLimits,
        ProposalTicketSpec, RetryPolicy,
    };

    fn session() -> ProposalSession {
        ProposalSession::new(
            [1; 32],
            [2; 32],
            ProposalSessionLimits {
                allowed_roles: ProposalRole::Heuristic.mask(),
                expires_ms: 1_000,
                maximum_queries: 4,
                maximum_outstanding: 2,
                maximum_revisions: 2,
                maximum_work_units: 40,
                maximum_return_bytes: 400,
            },
            10,
        )
        .unwrap()
    }

    fn spec(request: u64) -> ProposalTicketSpec {
        ProposalTicketSpec {
            key: ProposalIdempotencyKey::new("submission", request, [request as u8; 32]).unwrap(),
            proposer_id: 3,
            role: ProposalRole::Heuristic,
            deadlines: ProposalDeadlines::new(100, 500, 900, 700).unwrap(),
            cost_units: 5,
            max_return_bytes: 50,
        }
    }

    #[test]
    fn complete_lifecycle_survives_restart() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("submissions");
        let ticket = spec(1);
        {
            let mut store = ProposalSubmissionStore::create(&root, session(), 4).unwrap();
            assert_eq!(
                store.submit(ticket, 11).unwrap(),
                ProposalTicketSubmission::Created
            );
            assert_eq!(
                store.claim(ticket.key, 12).unwrap(),
                ProposalTicketClaim::Started { attempt: 0 }
            );
            store.complete(ticket.key, 0, [9; 32], 12, 13).unwrap();
        }
        let mut restored = ProposalSubmissionStore::open(&root, [1; 32], [2; 32], 4, 20).unwrap();
        assert_eq!(
            restored.session().unwrap().get(ticket.key).unwrap().status,
            ProposalSessionQueryStatus::Settled
        );
        assert_eq!(restored.result(ticket.key, 20).unwrap().result_bytes, 12);
        assert_eq!(
            restored.submit(ticket, 21).unwrap(),
            ProposalTicketSubmission::Existing
        );
        assert_eq!(restored.session().unwrap().usage().charged_work_units, 5);
    }

    #[test]
    fn reservation_without_ticket_is_reconciled_after_restart() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("submissions");
        let ticket = spec(1);
        let mut store = ProposalSubmissionStore::create(&root, session(), 4).unwrap();
        store.session.reserve(ticket, 11).unwrap();
        drop(store);
        let restored = ProposalSubmissionStore::open(&root, [1; 32], [2; 32], 4, 20).unwrap();
        assert_eq!(
            restored.tickets().get(ticket.key).unwrap().status,
            ProposalTicketStatus::Queued
        );
    }

    #[test]
    fn ticket_without_reservation_is_rejected() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("submissions");
        let ticket = spec(1);
        let mut store = ProposalSubmissionStore::create(&root, session(), 4).unwrap();
        store.tickets.submit(ticket, 11).unwrap();
        drop(store);
        assert!(matches!(
            ProposalSubmissionStore::open(&root, [1; 32], [2; 32], 4, 20),
            Err(ProposalSubmissionStoreError::InvalidStore)
        ));
    }

    #[test]
    fn terminal_ticket_without_session_settlement_is_reconciled() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("submissions");
        let ticket = spec(1);
        let mut store = ProposalSubmissionStore::create(&root, session(), 4).unwrap();
        store.submit(ticket, 11).unwrap();
        store.tickets.claim(ticket.key, 12).unwrap();
        store
            .tickets
            .complete(ticket.key, 0, [9; 32], 12, 13)
            .unwrap();
        drop(store);
        let restored = ProposalSubmissionStore::open(&root, [1; 32], [2; 32], 4, 20).unwrap();
        assert_eq!(
            restored.session().unwrap().get(ticket.key).unwrap().status,
            ProposalSessionQueryStatus::Settled
        );
    }

    #[test]
    fn claim_expiry_and_terminal_failure_settle_session_quota() {
        let temporary = tempfile::tempdir().unwrap();
        let root = temporary.path().join("expiry");
        let expired = spec(1);
        let mut store = ProposalSubmissionStore::create(&root, session(), 4).unwrap();
        store.submit(expired, 11).unwrap();
        assert!(matches!(
            store.claim(expired.key, 101).unwrap(),
            ProposalTicketClaim::Terminal {
                status: ProposalTicketStatus::Expired { .. }
            }
        ));
        assert_eq!(
            store.session().unwrap().get(expired.key).unwrap().status,
            ProposalSessionQueryStatus::Settled
        );

        let failed = spec(2);
        store.submit(failed, 102).unwrap_err();
        let mut failed = failed;
        failed.deadlines = ProposalDeadlines::new(200, 500, 900, 700).unwrap();
        store.submit(failed, 102).unwrap();
        store.claim(failed.key, 103).unwrap();
        let report = ProposalFailureReport {
            attempt: 0,
            failure: ProposalFailureClass::Malformed,
            retry_policy: RetryPolicy {
                maximum_retries: 2,
                base_delay_ms: 10,
                maximum_delay_ms: 20,
            },
            observed_ms: 104,
            provider_retry_after_ms: None,
            jitter_word: 0,
        };
        assert_eq!(
            store.record_failure(failed.key, report, 105).unwrap(),
            RetryAction::DoNotRetry
        );
        assert_eq!(
            store.session().unwrap().get(failed.key).unwrap().status,
            ProposalSessionQueryStatus::Settled
        );
    }
}
