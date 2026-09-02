//! Bounded quota accounting for one external-proposer session.
//!
//! This is controller-owned cold state. Query identities remain in the ledger
//! after completion so reconnects and transport retries cannot mint budget.

use super::{ProposalIdempotencyKey, ProposalRole, ProposalTicketSpec};
use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;

pub const PROPOSAL_SESSION_SCHEMA: &str = "ergodis-proposal-session-v2";
pub const MAX_PROPOSAL_SESSION_QUERIES: usize = 4_096;

#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalSessionLimits {
    pub allowed_roles: u8,
    pub expires_ms: u64,
    pub maximum_queries: u32,
    pub maximum_outstanding: u16,
    pub maximum_revisions: u16,
    pub maximum_work_units: u64,
    pub maximum_return_bytes: u64,
}

#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(rename_all = "kebab-case")]
pub enum ProposalSessionQueryStatus {
    Outstanding,
    Settled,
    Cancelled,
}

#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalSessionQuery {
    pub spec: ProposalTicketSpec,
    pub reserved_ms: u64,
    pub status: ProposalSessionQueryStatus,
}

#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalSessionRevision {
    pub canonical_payload_blake3: [u8; 32],
    pub role: ProposalRole,
}

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalSessionSnapshot {
    pub schema: String,
    pub session_binding: [u8; 32],
    pub source_fingerprint: [u8; 32],
    pub limits: ProposalSessionLimits,
    pub charged_work_units: u64,
    pub charged_return_bytes: u64,
    pub outstanding: u16,
    pub updated_ms: u64,
    pub queries: Vec<ProposalSessionQuery>,
    pub revisions: Vec<ProposalSessionRevision>,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize)]
pub struct ProposalSessionUsage {
    pub queries: u32,
    pub outstanding: u16,
    pub revisions: u16,
    pub charged_work_units: u64,
    pub remaining_work_units: u64,
    pub charged_return_bytes: u64,
    pub remaining_return_bytes: u64,
    pub expires_ms: u64,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum ProposalSessionReservation {
    Created,
    Existing { status: ProposalSessionQueryStatus },
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum ProposalRevisionReservation {
    Created,
    Existing,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, thiserror::Error)]
pub enum ProposalSessionError {
    #[error("proposal-session limits are invalid")]
    InvalidLimits,
    #[error("proposal-session snapshot is invalid")]
    InvalidSnapshot,
    #[error("proposal-session query reservation is invalid")]
    InvalidQuery,
    #[error("proposal session has expired")]
    Expired,
    #[error("proposal role is not permitted by this session")]
    ForbiddenRole,
    #[error("proposal-session query capacity is exhausted")]
    QueryCapacity,
    #[error("proposal-session proposal-revision capacity is exhausted")]
    RevisionCapacity,
    #[error("proposal-session outstanding-query capacity is exhausted")]
    OutstandingCapacity,
    #[error("proposal-session work budget is exhausted")]
    WorkBudget,
    #[error("proposal-session return-byte budget is exhausted")]
    ReturnByteBudget,
    #[error("proposal-session query identity names different work")]
    IdentityConflict,
    #[error("proposal-session query is unknown")]
    UnknownQuery,
    #[error("proposal-session controller time moved backwards")]
    ClockReversed,
}

#[derive(Clone, Debug)]
pub struct ProposalSession {
    session_binding: [u8; 32],
    source_fingerprint: [u8; 32],
    limits: ProposalSessionLimits,
    charged_work_units: u64,
    charged_return_bytes: u64,
    outstanding: u16,
    updated_ms: u64,
    queries: BTreeMap<ProposalIdempotencyKey, ProposalSessionQuery>,
    revisions: BTreeMap<[u8; 32], ProposalRole>,
}

impl ProposalSession {
    pub fn new(
        session_binding: [u8; 32],
        source_fingerprint: [u8; 32],
        limits: ProposalSessionLimits,
        now_ms: u64,
    ) -> Result<Self, ProposalSessionError> {
        validate_limits(limits)?;
        if session_binding == [0; 32] {
            return Err(ProposalSessionError::InvalidLimits);
        }
        if now_ms > limits.expires_ms {
            return Err(ProposalSessionError::Expired);
        }
        Ok(Self {
            session_binding,
            source_fingerprint,
            limits,
            charged_work_units: 0,
            charged_return_bytes: 0,
            outstanding: 0,
            updated_ms: now_ms,
            queries: BTreeMap::new(),
            revisions: BTreeMap::new(),
        })
    }

    pub fn restore(
        snapshot: ProposalSessionSnapshot,
        now_ms: u64,
    ) -> Result<Self, ProposalSessionError> {
        if snapshot.schema != PROPOSAL_SESSION_SCHEMA {
            return Err(ProposalSessionError::InvalidSnapshot);
        }
        validate_limits(snapshot.limits)?;
        if snapshot.session_binding == [0; 32]
            || snapshot.updated_ms > now_ms
            || snapshot.queries.len() > snapshot.limits.maximum_queries as usize
            || snapshot.queries.len() > MAX_PROPOSAL_SESSION_QUERIES
            || snapshot.revisions.len() > snapshot.limits.maximum_revisions as usize
        {
            return Err(ProposalSessionError::InvalidSnapshot);
        }

        let mut queries = BTreeMap::new();
        let mut charged_work_units = 0_u64;
        let mut charged_return_bytes = 0_u64;
        let mut outstanding = 0_u16;
        for query in snapshot.queries {
            validate_query(query).map_err(|_| ProposalSessionError::InvalidSnapshot)?;
            if query.reserved_ms > snapshot.updated_ms
                || query.reserved_ms > snapshot.limits.expires_ms
                || query.reserved_ms > query.spec.deadlines.queue_by_ms
                || snapshot.limits.allowed_roles & query.spec.role.mask() == 0
            {
                return Err(ProposalSessionError::InvalidSnapshot);
            }
            charged_work_units = charged_work_units
                .checked_add(query.spec.cost_units)
                .ok_or(ProposalSessionError::InvalidSnapshot)?;
            charged_return_bytes = charged_return_bytes
                .checked_add(query.spec.max_return_bytes)
                .ok_or(ProposalSessionError::InvalidSnapshot)?;
            if query.status == ProposalSessionQueryStatus::Outstanding {
                outstanding = outstanding
                    .checked_add(1)
                    .ok_or(ProposalSessionError::InvalidSnapshot)?;
            }
            if queries.insert(query.spec.key, query).is_some() {
                return Err(ProposalSessionError::InvalidSnapshot);
            }
        }
        let mut revisions = BTreeMap::new();
        for revision in snapshot.revisions {
            if revision.canonical_payload_blake3 == [0; 32]
                || snapshot.limits.allowed_roles & revision.role.mask() == 0
                || revisions
                    .insert(revision.canonical_payload_blake3, revision.role)
                    .is_some()
            {
                return Err(ProposalSessionError::InvalidSnapshot);
            }
        }
        if charged_work_units != snapshot.charged_work_units
            || charged_return_bytes != snapshot.charged_return_bytes
            || outstanding != snapshot.outstanding
            || charged_work_units > snapshot.limits.maximum_work_units
            || charged_return_bytes > snapshot.limits.maximum_return_bytes
            || outstanding > snapshot.limits.maximum_outstanding
        {
            return Err(ProposalSessionError::InvalidSnapshot);
        }
        Ok(Self {
            session_binding: snapshot.session_binding,
            source_fingerprint: snapshot.source_fingerprint,
            limits: snapshot.limits,
            charged_work_units,
            charged_return_bytes,
            outstanding,
            updated_ms: snapshot.updated_ms,
            queries,
            revisions,
        })
    }

    pub fn snapshot(&self) -> ProposalSessionSnapshot {
        ProposalSessionSnapshot {
            schema: PROPOSAL_SESSION_SCHEMA.into(),
            session_binding: self.session_binding,
            source_fingerprint: self.source_fingerprint,
            limits: self.limits,
            charged_work_units: self.charged_work_units,
            charged_return_bytes: self.charged_return_bytes,
            outstanding: self.outstanding,
            updated_ms: self.updated_ms,
            queries: self.queries.values().copied().collect(),
            revisions: self
                .revisions
                .iter()
                .map(
                    |(&canonical_payload_blake3, &role)| ProposalSessionRevision {
                        canonical_payload_blake3,
                        role,
                    },
                )
                .collect(),
        }
    }

    pub fn get(&self, key: ProposalIdempotencyKey) -> Option<ProposalSessionQuery> {
        self.queries.get(&key).copied()
    }

    pub fn source_fingerprint(&self) -> [u8; 32] {
        self.source_fingerprint
    }

    pub fn session_binding(&self) -> [u8; 32] {
        self.session_binding
    }

    pub fn limits(&self) -> ProposalSessionLimits {
        self.limits
    }

    pub fn usage(&self) -> ProposalSessionUsage {
        ProposalSessionUsage {
            queries: self.queries.len() as u32,
            outstanding: self.outstanding,
            revisions: self.revisions.len() as u16,
            charged_work_units: self.charged_work_units,
            remaining_work_units: self.limits.maximum_work_units - self.charged_work_units,
            charged_return_bytes: self.charged_return_bytes,
            remaining_return_bytes: self.limits.maximum_return_bytes - self.charged_return_bytes,
            expires_ms: self.limits.expires_ms,
        }
    }

    pub fn reserve(
        &mut self,
        spec: ProposalTicketSpec,
        now_ms: u64,
    ) -> Result<ProposalSessionReservation, ProposalSessionError> {
        self.check_time(now_ms)?;
        let proposed = ProposalSessionQuery {
            spec,
            reserved_ms: now_ms,
            status: ProposalSessionQueryStatus::Outstanding,
        };
        validate_query(proposed)?;
        if let Some(existing) = self.queries.get(&spec.key) {
            return if existing.spec == spec {
                Ok(ProposalSessionReservation::Existing {
                    status: existing.status,
                })
            } else {
                Err(ProposalSessionError::IdentityConflict)
            };
        }
        if now_ms > self.limits.expires_ms {
            return Err(ProposalSessionError::Expired);
        }
        if now_ms > spec.deadlines.queue_by_ms {
            return Err(ProposalSessionError::Expired);
        }
        if self.limits.allowed_roles & spec.role.mask() == 0 {
            return Err(ProposalSessionError::ForbiddenRole);
        }
        if self.queries.len() == self.limits.maximum_queries as usize {
            return Err(ProposalSessionError::QueryCapacity);
        }
        if self.outstanding == self.limits.maximum_outstanding {
            return Err(ProposalSessionError::OutstandingCapacity);
        }
        let charged_work_units = self
            .charged_work_units
            .checked_add(spec.cost_units)
            .ok_or(ProposalSessionError::WorkBudget)?;
        if charged_work_units > self.limits.maximum_work_units {
            return Err(ProposalSessionError::WorkBudget);
        }
        let charged_return_bytes = self
            .charged_return_bytes
            .checked_add(spec.max_return_bytes)
            .ok_or(ProposalSessionError::ReturnByteBudget)?;
        if charged_return_bytes > self.limits.maximum_return_bytes {
            return Err(ProposalSessionError::ReturnByteBudget);
        }
        self.queries.insert(spec.key, proposed);
        self.charged_work_units = charged_work_units;
        self.charged_return_bytes = charged_return_bytes;
        self.outstanding += 1;
        self.updated_ms = now_ms;
        Ok(ProposalSessionReservation::Created)
    }

    pub fn settle(
        &mut self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<bool, ProposalSessionError> {
        self.transition_terminal(key, ProposalSessionQueryStatus::Settled, now_ms)
    }

    pub fn reserve_revision(
        &mut self,
        canonical_payload_blake3: [u8; 32],
        role: ProposalRole,
        now_ms: u64,
    ) -> Result<ProposalRevisionReservation, ProposalSessionError> {
        self.check_time(now_ms)?;
        if let Some(&existing_role) = self.revisions.get(&canonical_payload_blake3) {
            return if existing_role == role {
                Ok(ProposalRevisionReservation::Existing)
            } else {
                Err(ProposalSessionError::IdentityConflict)
            };
        }
        if now_ms > self.limits.expires_ms {
            return Err(ProposalSessionError::Expired);
        }
        if canonical_payload_blake3 == [0; 32] {
            return Err(ProposalSessionError::InvalidQuery);
        }
        if self.limits.allowed_roles & role.mask() == 0 {
            return Err(ProposalSessionError::ForbiddenRole);
        }
        if self.revisions.len() == self.limits.maximum_revisions as usize {
            return Err(ProposalSessionError::RevisionCapacity);
        }
        self.revisions.insert(canonical_payload_blake3, role);
        self.updated_ms = now_ms;
        Ok(ProposalRevisionReservation::Created)
    }

    pub fn cancel(
        &mut self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<bool, ProposalSessionError> {
        self.transition_terminal(key, ProposalSessionQueryStatus::Cancelled, now_ms)
    }

    fn transition_terminal(
        &mut self,
        key: ProposalIdempotencyKey,
        target: ProposalSessionQueryStatus,
        now_ms: u64,
    ) -> Result<bool, ProposalSessionError> {
        self.check_time(now_ms)?;
        let query = self
            .queries
            .get_mut(&key)
            .ok_or(ProposalSessionError::UnknownQuery)?;
        if query.status != ProposalSessionQueryStatus::Outstanding {
            return Ok(false);
        }
        query.status = target;
        self.outstanding -= 1;
        self.updated_ms = now_ms;
        Ok(true)
    }

    fn check_time(&self, now_ms: u64) -> Result<(), ProposalSessionError> {
        if now_ms < self.updated_ms {
            Err(ProposalSessionError::ClockReversed)
        } else {
            Ok(())
        }
    }
}

fn validate_limits(limits: ProposalSessionLimits) -> Result<(), ProposalSessionError> {
    if limits.allowed_roles == 0
        || limits.allowed_roles & !0x0f != 0
        || limits.maximum_queries == 0
        || limits.maximum_queries as usize > MAX_PROPOSAL_SESSION_QUERIES
        || limits.maximum_outstanding == 0
        || u32::from(limits.maximum_outstanding) > limits.maximum_queries
        || limits.maximum_revisions == 0
        || limits.maximum_work_units == 0
        || limits.maximum_return_bytes == 0
    {
        return Err(ProposalSessionError::InvalidLimits);
    }
    Ok(())
}

fn validate_query(query: ProposalSessionQuery) -> Result<(), ProposalSessionError> {
    if query.spec.key.as_bytes() == [0; 32] || query.spec.validate().is_err() {
        return Err(ProposalSessionError::InvalidQuery);
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::control::ProposalDeadlines;

    fn limits() -> ProposalSessionLimits {
        ProposalSessionLimits {
            allowed_roles: ProposalRole::Heuristic.mask() | ProposalRole::NecessaryReduction.mask(),
            expires_ms: 1_000,
            maximum_queries: 3,
            maximum_outstanding: 2,
            maximum_revisions: 2,
            maximum_work_units: 12,
            maximum_return_bytes: 120,
        }
    }

    fn key(request: u64) -> ProposalIdempotencyKey {
        ProposalIdempotencyKey::new("session", request, [request as u8; 32]).unwrap()
    }

    fn spec(
        request: u64,
        role: ProposalRole,
        cost_units: u64,
        max_return_bytes: u64,
    ) -> ProposalTicketSpec {
        ProposalTicketSpec {
            key: key(request),
            proposer_id: 3,
            role,
            deadlines: ProposalDeadlines::new(100, 500, 900, 700).unwrap(),
            cost_units,
            max_return_bytes,
        }
    }

    #[test]
    fn reservations_are_idempotent_bounded_and_not_refunded() {
        let mut session = ProposalSession::new([1; 32], [7; 32], limits(), 10).unwrap();
        assert_eq!(
            session.reserve(spec(1, ProposalRole::Heuristic, 5, 50), 11),
            Ok(ProposalSessionReservation::Created)
        );
        assert_eq!(
            session.reserve(spec(1, ProposalRole::Heuristic, 5, 50), 11),
            Ok(ProposalSessionReservation::Existing {
                status: ProposalSessionQueryStatus::Outstanding
            })
        );
        assert_eq!(
            session.reserve(spec(1, ProposalRole::Heuristic, 6, 50), 11),
            Err(ProposalSessionError::IdentityConflict)
        );
        assert_eq!(
            session.reserve(spec(2, ProposalRole::Ordering, 1, 1), 12),
            Err(ProposalSessionError::ForbiddenRole)
        );
        assert_eq!(
            session.reserve(spec(2, ProposalRole::NecessaryReduction, 6, 60), 12),
            Ok(ProposalSessionReservation::Created)
        );
        assert_eq!(
            session.reserve(spec(3, ProposalRole::Heuristic, 1, 1), 13),
            Err(ProposalSessionError::OutstandingCapacity)
        );
        assert_eq!(session.settle(key(1), 14), Ok(true));
        assert_eq!(session.settle(key(1), 14), Ok(false));
        assert_eq!(
            session.reserve(spec(3, ProposalRole::Heuristic, 2, 10), 15),
            Err(ProposalSessionError::WorkBudget)
        );
        assert_eq!(
            session.reserve(spec(3, ProposalRole::Heuristic, 1, 11), 15),
            Err(ProposalSessionError::ReturnByteBudget)
        );
        assert_eq!(
            session.reserve(spec(3, ProposalRole::Heuristic, 1, 10), 15),
            Ok(ProposalSessionReservation::Created)
        );
        assert_eq!(session.snapshot().charged_work_units, 12);
    }

    #[test]
    fn restore_recomputes_every_redundant_counter() {
        let mut session = ProposalSession::new([1; 32], [9; 32], limits(), 10).unwrap();
        session
            .reserve(spec(1, ProposalRole::Heuristic, 5, 50), 11)
            .unwrap();
        session.settle(key(1), 12).unwrap();
        session
            .reserve(spec(2, ProposalRole::NecessaryReduction, 6, 60), 13)
            .unwrap();
        session
            .reserve_revision([3; 32], ProposalRole::NecessaryReduction, 13)
            .unwrap();
        let snapshot = session.snapshot();
        assert!(ProposalSession::restore(snapshot.clone(), 13).is_ok());

        let mut forged = snapshot.clone();
        forged.outstanding = 0;
        assert_eq!(
            ProposalSession::restore(forged, 13).unwrap_err(),
            ProposalSessionError::InvalidSnapshot
        );
        let mut duplicate = snapshot;
        duplicate.queries.push(duplicate.queries[0]);
        duplicate.charged_work_units += duplicate.queries[0].spec.cost_units;
        duplicate.charged_return_bytes += duplicate.queries[0].spec.max_return_bytes;
        assert_eq!(
            ProposalSession::restore(duplicate, 13).unwrap_err(),
            ProposalSessionError::InvalidSnapshot
        );
    }

    #[test]
    fn expiry_and_clock_reversal_fail_closed() {
        assert_eq!(
            ProposalSession::new([1; 32], [0; 32], limits(), 1_001).unwrap_err(),
            ProposalSessionError::Expired
        );
        let mut session = ProposalSession::new([1; 32], [0; 32], limits(), 10).unwrap();
        assert_eq!(
            session.reserve(spec(1, ProposalRole::Heuristic, 1, 1), 9),
            Err(ProposalSessionError::ClockReversed)
        );
        assert_eq!(
            session.reserve(spec(1, ProposalRole::Heuristic, 1, 1), 1_001),
            Err(ProposalSessionError::Expired)
        );
    }

    #[test]
    fn proposal_revisions_are_role_bound_and_idempotent() {
        let mut session = ProposalSession::new([1; 32], [0; 32], limits(), 10).unwrap();
        assert_eq!(
            session.reserve_revision([1; 32], ProposalRole::Heuristic, 11),
            Ok(ProposalRevisionReservation::Created)
        );
        assert_eq!(
            session.reserve_revision([1; 32], ProposalRole::Heuristic, 11),
            Ok(ProposalRevisionReservation::Existing)
        );
        assert_eq!(
            session.reserve_revision([1; 32], ProposalRole::NecessaryReduction, 11),
            Err(ProposalSessionError::IdentityConflict)
        );
        assert_eq!(
            session.reserve_revision([2; 32], ProposalRole::Ordering, 12),
            Err(ProposalSessionError::ForbiddenRole)
        );
        session
            .reserve_revision([2; 32], ProposalRole::NecessaryReduction, 12)
            .unwrap();
        assert_eq!(
            session.reserve_revision([3; 32], ProposalRole::Heuristic, 13),
            Err(ProposalSessionError::RevisionCapacity)
        );
    }
}
