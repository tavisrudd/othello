//! Restart-validatable asynchronous ticket state for external proposers.
//!
//! This is controller-owned cold state. It has no dependency on solve workers,
//! sockets, provider SDKs, or admission authority.

use super::{
    DeadlineExceeded, DeadlineStage, ProposalDeadlines, ProposalFailureClass,
    ProposalIdempotencyKey, ProposalRole, RetryAction, RetryPolicy,
};
use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;

pub const PROPOSAL_TICKET_LEDGER_SCHEMA: &str = "ergodis-proposal-ticket-ledger-v1";
pub const MAX_PROPOSAL_TICKETS: usize = 65_536;

#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalTicketSpec {
    pub key: ProposalIdempotencyKey,
    pub proposer_id: u16,
    pub role: ProposalRole,
    pub deadlines: ProposalDeadlines,
    pub cost_units: u64,
    pub max_return_bytes: u64,
}

impl ProposalTicketSpec {
    pub fn validate(self) -> Result<(), ProposalTicketError> {
        validate_ticket_spec(self)
    }
}

#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(tag = "state", rename_all = "kebab-case", deny_unknown_fields)]
pub enum ProposalTicketStatus {
    Queued,
    Running {
        attempt: u8,
        started_ms: u64,
    },
    RetryWait {
        failed_attempt: u8,
        next_attempt: u8,
        not_before_ms: u64,
        failure: ProposalFailureClass,
        retry_action: RetryAction,
    },
    Ready {
        attempt: u8,
        completed_ms: u64,
        result_blake3: [u8; 32],
        result_bytes: u64,
    },
    TerminalFailure {
        attempt: u8,
        failed_ms: u64,
        failure: ProposalFailureClass,
        action: RetryAction,
    },
    Cancelled {
        cancelled_ms: u64,
    },
    Expired {
        stage: DeadlineStage,
        expired_ms: u64,
    },
}

impl ProposalTicketStatus {
    pub fn is_terminal(self) -> bool {
        matches!(
            self,
            Self::Ready { .. }
                | Self::TerminalFailure { .. }
                | Self::Cancelled { .. }
                | Self::Expired { .. }
        )
    }
}

#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalTicketSnapshot {
    pub spec: ProposalTicketSpec,
    pub status: ProposalTicketStatus,
    pub created_ms: u64,
    pub updated_ms: u64,
}

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalTicketLedgerSnapshot {
    pub schema: String,
    pub max_tickets: u32,
    pub tickets: Vec<ProposalTicketSnapshot>,
}

#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(rename_all = "kebab-case")]
pub enum ProposalTicketSubmission {
    Created,
    Existing,
}

#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(tag = "kind", rename_all = "kebab-case")]
pub enum ProposalTicketClaim {
    Started { attempt: u8 },
    Deferred { not_before_ms: u64 },
    Busy { attempt: u8 },
    Terminal { status: ProposalTicketStatus },
}

#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
pub struct ProposalReadyResult {
    pub result_blake3: [u8; 32],
    pub result_bytes: u64,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct ProposalFailureReport {
    pub attempt: u8,
    pub failure: ProposalFailureClass,
    pub retry_policy: RetryPolicy,
    pub observed_ms: u64,
    pub provider_retry_after_ms: Option<u64>,
    pub jitter_word: u64,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, thiserror::Error)]
pub enum ProposalTicketError {
    #[error("proposal ticket ledger capacity is invalid or exhausted")]
    Capacity,
    #[error("proposal ticket specification is invalid")]
    InvalidSpec,
    #[error("proposal ticket snapshot is invalid")]
    InvalidSnapshot,
    #[error("proposal idempotency key already names a different request")]
    IdentityConflict,
    #[error("proposal ticket is unknown")]
    Unknown,
    #[error("proposal ticket transition is invalid")]
    InvalidTransition,
    #[error("proposal ticket controller time moved backwards")]
    ClockReversed,
    #[error("proposal result exceeds its declared byte limit")]
    ResultTooLarge,
    #[error(transparent)]
    Deadline(#[from] DeadlineExceeded),
}

#[derive(Clone, Debug)]
pub struct ProposalTicketLedger {
    max_tickets: usize,
    tickets: BTreeMap<ProposalIdempotencyKey, ProposalTicketSnapshot>,
}

impl ProposalTicketLedger {
    pub fn new(max_tickets: usize) -> Result<Self, ProposalTicketError> {
        validate_capacity(max_tickets)?;
        Ok(Self {
            max_tickets,
            tickets: BTreeMap::new(),
        })
    }

    pub fn restore(
        snapshot: ProposalTicketLedgerSnapshot,
        configured_max_tickets: usize,
        now_ms: u64,
    ) -> Result<Self, ProposalTicketError> {
        if snapshot.schema != PROPOSAL_TICKET_LEDGER_SCHEMA {
            return Err(ProposalTicketError::InvalidSnapshot);
        }
        validate_capacity(configured_max_tickets)?;
        if snapshot.max_tickets as usize != configured_max_tickets {
            return Err(ProposalTicketError::InvalidSnapshot);
        }
        if snapshot.tickets.len() > snapshot.max_tickets as usize {
            return Err(ProposalTicketError::InvalidSnapshot);
        }
        let mut tickets = BTreeMap::new();
        for ticket in snapshot.tickets {
            validate_ticket_snapshot(ticket, now_ms)?;
            if tickets.insert(ticket.spec.key, ticket).is_some() {
                return Err(ProposalTicketError::InvalidSnapshot);
            }
        }
        let mut ledger = Self {
            max_tickets: snapshot.max_tickets as usize,
            tickets,
        };
        ledger.expire_due(now_ms)?;
        Ok(ledger)
    }

    pub fn snapshot(&self) -> ProposalTicketLedgerSnapshot {
        ProposalTicketLedgerSnapshot {
            schema: PROPOSAL_TICKET_LEDGER_SCHEMA.into(),
            max_tickets: self.max_tickets as u32,
            tickets: self.tickets.values().copied().collect(),
        }
    }

    pub fn len(&self) -> usize {
        self.tickets.len()
    }

    pub fn is_empty(&self) -> bool {
        self.tickets.is_empty()
    }

    pub fn get(&self, key: ProposalIdempotencyKey) -> Option<ProposalTicketSnapshot> {
        self.tickets.get(&key).copied()
    }

    pub fn submit(
        &mut self,
        spec: ProposalTicketSpec,
        now_ms: u64,
    ) -> Result<ProposalTicketSubmission, ProposalTicketError> {
        validate_ticket_spec(spec)?;
        if let Some(existing) = self.tickets.get(&spec.key) {
            return if existing.spec == spec {
                Ok(ProposalTicketSubmission::Existing)
            } else {
                Err(ProposalTicketError::IdentityConflict)
            };
        }
        if self.tickets.len() == self.max_tickets {
            return Err(ProposalTicketError::Capacity);
        }
        spec.deadlines.check(DeadlineStage::Queue, now_ms)?;
        self.tickets.insert(
            spec.key,
            ProposalTicketSnapshot {
                spec,
                status: ProposalTicketStatus::Queued,
                created_ms: now_ms,
                updated_ms: now_ms,
            },
        );
        Ok(ProposalTicketSubmission::Created)
    }

    pub fn claim(
        &mut self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<ProposalTicketClaim, ProposalTicketError> {
        let ticket = self
            .tickets
            .get_mut(&key)
            .ok_or(ProposalTicketError::Unknown)?;
        check_clock(ticket.updated_ms, now_ms)?;
        let attempt = match ticket.status {
            ProposalTicketStatus::Queued => {
                if let Err(expired) = ticket.spec.deadlines.check(DeadlineStage::Queue, now_ms) {
                    expire(ticket, expired.stage, now_ms);
                    return Ok(ProposalTicketClaim::Terminal {
                        status: ticket.status,
                    });
                }
                0
            }
            ProposalTicketStatus::RetryWait {
                next_attempt,
                not_before_ms,
                ..
            } => {
                if now_ms < not_before_ms {
                    return Ok(ProposalTicketClaim::Deferred { not_before_ms });
                }
                if let Err(expired) = ticket
                    .spec
                    .deadlines
                    .check(DeadlineStage::Execution, now_ms)
                {
                    expire(ticket, expired.stage, now_ms);
                    return Ok(ProposalTicketClaim::Terminal {
                        status: ticket.status,
                    });
                }
                next_attempt
            }
            ProposalTicketStatus::Running { attempt, .. } => {
                return Ok(ProposalTicketClaim::Busy { attempt });
            }
            status => return Ok(ProposalTicketClaim::Terminal { status }),
        };
        ticket.status = ProposalTicketStatus::Running {
            attempt,
            started_ms: now_ms,
        };
        ticket.updated_ms = now_ms;
        Ok(ProposalTicketClaim::Started { attempt })
    }

    pub fn record_failure(
        &mut self,
        key: ProposalIdempotencyKey,
        report: ProposalFailureReport,
    ) -> Result<RetryAction, ProposalTicketError> {
        let ticket = self
            .tickets
            .get_mut(&key)
            .ok_or(ProposalTicketError::Unknown)?;
        check_clock(ticket.updated_ms, report.observed_ms)?;
        let attempt = match ticket.status {
            ProposalTicketStatus::Running { attempt, .. } if attempt == report.attempt => attempt,
            ProposalTicketStatus::RetryWait {
                failed_attempt: recorded_attempt,
                failure: recorded_failure,
                retry_action,
                ..
            } if recorded_attempt == report.attempt && recorded_failure == report.failure => {
                return Ok(retry_action);
            }
            ProposalTicketStatus::TerminalFailure {
                attempt: recorded_attempt,
                failure: recorded_failure,
                action,
                ..
            } if recorded_attempt == report.attempt && recorded_failure == report.failure => {
                return Ok(action);
            }
            _ => return Err(ProposalTicketError::InvalidTransition),
        };
        if let Err(expired) = ticket
            .spec
            .deadlines
            .check(DeadlineStage::Execution, report.observed_ms)
        {
            expire(ticket, expired.stage, report.observed_ms);
            return Ok(RetryAction::DoNotRetry);
        }
        let proposed = report.retry_policy.decide(
            report.failure,
            attempt,
            report.observed_ms,
            ticket.spec.deadlines.execute_by_ms,
            report.provider_retry_after_ms,
            report.jitter_word,
        );
        let wait_until = match proposed {
            RetryAction::RetryAt { not_before_ms } => Some(not_before_ms),
            RetryAction::CircuitOpen { until_ms } => Some(until_ms),
            RetryAction::DoNotRetry | RetryAction::RebaseRequired | RetryAction::ReduceScope => {
                None
            }
        };
        let applied = if let (Some(not_before_ms), Some(next_attempt)) =
            (wait_until, attempt.checked_add(1))
        {
            if not_before_ms <= ticket.spec.deadlines.execute_by_ms {
                ticket.status = ProposalTicketStatus::RetryWait {
                    failed_attempt: attempt,
                    next_attempt,
                    not_before_ms,
                    failure: report.failure,
                    retry_action: proposed,
                };
                proposed
            } else {
                terminal_failure(
                    ticket,
                    attempt,
                    report.failure,
                    RetryAction::DoNotRetry,
                    report.observed_ms,
                );
                RetryAction::DoNotRetry
            }
        } else {
            terminal_failure(
                ticket,
                attempt,
                report.failure,
                proposed,
                report.observed_ms,
            );
            proposed
        };
        ticket.updated_ms = report.observed_ms;
        Ok(applied)
    }

    pub fn complete(
        &mut self,
        key: ProposalIdempotencyKey,
        completed_attempt: u8,
        result_blake3: [u8; 32],
        result_bytes: u64,
        now_ms: u64,
    ) -> Result<(), ProposalTicketError> {
        let ticket = self
            .tickets
            .get_mut(&key)
            .ok_or(ProposalTicketError::Unknown)?;
        check_clock(ticket.updated_ms, now_ms)?;
        let attempt = match ticket.status {
            ProposalTicketStatus::Running { attempt, .. } if attempt == completed_attempt => {
                attempt
            }
            ProposalTicketStatus::Ready {
                attempt,
                result_blake3: recorded_blake3,
                result_bytes: recorded_bytes,
                ..
            } if attempt == completed_attempt
                && recorded_blake3 == result_blake3
                && recorded_bytes == result_bytes =>
            {
                return Ok(());
            }
            ProposalTicketStatus::Ready { .. } => {
                return Err(ProposalTicketError::IdentityConflict);
            }
            _ => return Err(ProposalTicketError::InvalidTransition),
        };
        if result_bytes > ticket.spec.max_return_bytes {
            return Err(ProposalTicketError::ResultTooLarge);
        }
        if let Err(expired) = ticket
            .spec
            .deadlines
            .check(DeadlineStage::Execution, now_ms)
        {
            expire(ticket, expired.stage, now_ms);
            return Err(ProposalTicketError::Deadline(expired));
        }
        ticket.status = ProposalTicketStatus::Ready {
            attempt,
            completed_ms: now_ms,
            result_blake3,
            result_bytes,
        };
        ticket.updated_ms = now_ms;
        Ok(())
    }

    pub fn result(
        &mut self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<ProposalReadyResult, ProposalTicketError> {
        let ticket = self
            .tickets
            .get_mut(&key)
            .ok_or(ProposalTicketError::Unknown)?;
        check_clock(ticket.updated_ms, now_ms)?;
        let ready = ready_result(ticket.status)?;
        if let Err(expired) = ticket
            .spec
            .deadlines
            .check(DeadlineStage::ResultRetention, now_ms)
        {
            if matches!(ticket.status, ProposalTicketStatus::Ready { .. }) {
                expire(ticket, expired.stage, now_ms);
            }
            return Err(ProposalTicketError::Deadline(expired));
        }
        Ok(ready)
    }

    pub fn admission_result(
        &self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<ProposalReadyResult, ProposalTicketError> {
        let ticket = self.tickets.get(&key).ok_or(ProposalTicketError::Unknown)?;
        check_clock(ticket.updated_ms, now_ms)?;
        let ready = ready_result(ticket.status)?;
        ticket
            .spec
            .deadlines
            .check(DeadlineStage::Admission, now_ms)?;
        Ok(ready)
    }

    pub fn cancel(
        &mut self,
        key: ProposalIdempotencyKey,
        now_ms: u64,
    ) -> Result<bool, ProposalTicketError> {
        let ticket = self
            .tickets
            .get_mut(&key)
            .ok_or(ProposalTicketError::Unknown)?;
        check_clock(ticket.updated_ms, now_ms)?;
        if ticket.status.is_terminal() {
            return Ok(false);
        }
        let deadline_stage = match ticket.status {
            ProposalTicketStatus::Queued => Some(DeadlineStage::Queue),
            ProposalTicketStatus::Running { .. } | ProposalTicketStatus::RetryWait { .. } => {
                Some(DeadlineStage::Execution)
            }
            _ => None,
        };
        if let Some(stage) = deadline_stage {
            if ticket.spec.deadlines.check(stage, now_ms).is_err() {
                expire(ticket, stage, now_ms);
                return Ok(false);
            }
        }
        ticket.status = ProposalTicketStatus::Cancelled {
            cancelled_ms: now_ms,
        };
        ticket.updated_ms = now_ms;
        Ok(true)
    }

    pub fn expire_due(&mut self, now_ms: u64) -> Result<usize, ProposalTicketError> {
        if self
            .tickets
            .values()
            .any(|ticket| ticket.updated_ms > now_ms)
        {
            return Err(ProposalTicketError::ClockReversed);
        }
        let mut expired = 0;
        for ticket in self.tickets.values_mut() {
            let stage = match ticket.status {
                ProposalTicketStatus::Queued if now_ms > ticket.spec.deadlines.queue_by_ms => {
                    Some(DeadlineStage::Queue)
                }
                ProposalTicketStatus::Running { .. } | ProposalTicketStatus::RetryWait { .. }
                    if now_ms > ticket.spec.deadlines.execute_by_ms =>
                {
                    Some(DeadlineStage::Execution)
                }
                ProposalTicketStatus::Ready { .. }
                    if now_ms > ticket.spec.deadlines.retain_until_ms =>
                {
                    Some(DeadlineStage::ResultRetention)
                }
                _ => None,
            };
            if let Some(stage) = stage {
                expire(ticket, stage, now_ms);
                expired += 1;
            }
        }
        Ok(expired)
    }
}

fn validate_capacity(max_tickets: usize) -> Result<(), ProposalTicketError> {
    if max_tickets == 0 || max_tickets > MAX_PROPOSAL_TICKETS {
        Err(ProposalTicketError::Capacity)
    } else {
        Ok(())
    }
}

fn validate_ticket_spec(spec: ProposalTicketSpec) -> Result<(), ProposalTicketError> {
    if spec.cost_units == 0
        || spec.max_return_bytes == 0
        || ProposalDeadlines::new(
            spec.deadlines.queue_by_ms,
            spec.deadlines.execute_by_ms,
            spec.deadlines.retain_until_ms,
            spec.deadlines.admit_by_ms,
        )
        .is_err()
    {
        return Err(ProposalTicketError::InvalidSpec);
    }
    Ok(())
}

fn validate_ticket_snapshot(
    ticket: ProposalTicketSnapshot,
    now_ms: u64,
) -> Result<(), ProposalTicketError> {
    validate_ticket_spec(ticket.spec).map_err(|_| ProposalTicketError::InvalidSnapshot)?;
    if ticket.created_ms > ticket.updated_ms || ticket.updated_ms > now_ms {
        return Err(ProposalTicketError::InvalidSnapshot);
    }
    let valid = match ticket.status {
        ProposalTicketStatus::Queued => true,
        ProposalTicketStatus::Running { started_ms, .. } => {
            started_ms >= ticket.created_ms
                && started_ms <= ticket.updated_ms
                && started_ms <= ticket.spec.deadlines.execute_by_ms
        }
        ProposalTicketStatus::RetryWait {
            failed_attempt,
            next_attempt,
            not_before_ms,
            retry_action,
            ..
        } => {
            failed_attempt.checked_add(1) == Some(next_attempt)
                && retry_action_time(retry_action) == Some(not_before_ms)
                && not_before_ms >= ticket.updated_ms
                && not_before_ms <= ticket.spec.deadlines.execute_by_ms
        }
        ProposalTicketStatus::Ready {
            completed_ms,
            result_bytes,
            ..
        } => {
            completed_ms >= ticket.created_ms
                && completed_ms <= ticket.updated_ms
                && completed_ms <= ticket.spec.deadlines.execute_by_ms
                && result_bytes <= ticket.spec.max_return_bytes
        }
        ProposalTicketStatus::TerminalFailure {
            failed_ms, action, ..
        } => {
            failed_ms >= ticket.created_ms
                && failed_ms <= ticket.updated_ms
                && failed_ms <= ticket.spec.deadlines.execute_by_ms
                && retry_action_time(action).is_none()
        }
        ProposalTicketStatus::Cancelled { cancelled_ms } => {
            cancelled_ms >= ticket.created_ms && cancelled_ms <= ticket.updated_ms
        }
        ProposalTicketStatus::Expired { stage, expired_ms } => {
            expired_ms >= ticket.created_ms
                && expired_ms <= ticket.updated_ms
                && expired_ms > ticket.spec.deadlines.deadline(stage)
        }
    };
    if valid {
        Ok(())
    } else {
        Err(ProposalTicketError::InvalidSnapshot)
    }
}

fn check_clock(updated_ms: u64, now_ms: u64) -> Result<(), ProposalTicketError> {
    if now_ms < updated_ms {
        Err(ProposalTicketError::ClockReversed)
    } else {
        Ok(())
    }
}

fn ready_result(status: ProposalTicketStatus) -> Result<ProposalReadyResult, ProposalTicketError> {
    if let ProposalTicketStatus::Ready {
        result_blake3,
        result_bytes,
        ..
    } = status
    {
        Ok(ProposalReadyResult {
            result_blake3,
            result_bytes,
        })
    } else {
        Err(ProposalTicketError::InvalidTransition)
    }
}

fn retry_action_time(action: RetryAction) -> Option<u64> {
    match action {
        RetryAction::RetryAt { not_before_ms } => Some(not_before_ms),
        RetryAction::CircuitOpen { until_ms } => Some(until_ms),
        RetryAction::DoNotRetry | RetryAction::RebaseRequired | RetryAction::ReduceScope => None,
    }
}

fn terminal_failure(
    ticket: &mut ProposalTicketSnapshot,
    attempt: u8,
    failure: ProposalFailureClass,
    action: RetryAction,
    now_ms: u64,
) {
    ticket.status = ProposalTicketStatus::TerminalFailure {
        attempt,
        failed_ms: now_ms,
        failure,
        action,
    };
}

fn expire(ticket: &mut ProposalTicketSnapshot, stage: DeadlineStage, now_ms: u64) {
    ticket.status = ProposalTicketStatus::Expired {
        stage,
        expired_ms: now_ms,
    };
    ticket.updated_ms = now_ms;
}

#[cfg(test)]
mod tests {
    use super::*;

    fn spec(session: &str, request: u64, proposer_id: u16) -> ProposalTicketSpec {
        ProposalTicketSpec {
            key: ProposalIdempotencyKey::new(
                session,
                request,
                *blake3::hash(b"canonical payload").as_bytes(),
            )
            .unwrap(),
            proposer_id,
            role: ProposalRole::ExactTransport,
            deadlines: ProposalDeadlines::new(100, 500, 900, 700).unwrap(),
            cost_units: 10,
            max_return_bytes: 1_024,
        }
    }

    #[test]
    fn submission_is_idempotent_and_rejects_identity_reuse() {
        let mut ledger = ProposalTicketLedger::new(1).unwrap();
        let first = spec("session", 1, 7);
        assert_eq!(
            ledger.submit(first, 10),
            Ok(ProposalTicketSubmission::Created)
        );
        assert_eq!(
            ledger.submit(first, 20),
            Ok(ProposalTicketSubmission::Existing)
        );
        assert_eq!(ledger.len(), 1);
        assert_eq!(
            ledger.submit(
                ProposalTicketSpec {
                    proposer_id: 8,
                    ..first
                },
                20
            ),
            Err(ProposalTicketError::IdentityConflict)
        );
        assert_eq!(
            ledger.submit(spec("session", 2, 7), 20),
            Err(ProposalTicketError::Capacity)
        );
    }

    #[test]
    fn retry_wait_and_completion_follow_absolute_deadlines() {
        let mut ledger = ProposalTicketLedger::new(4).unwrap();
        let ticket = spec("session", 1, 7);
        ledger.submit(ticket, 10).unwrap();
        assert_eq!(
            ledger.claim(ticket.key, 20),
            Ok(ProposalTicketClaim::Started { attempt: 0 })
        );
        let policy = RetryPolicy {
            maximum_retries: 2,
            base_delay_ms: 50,
            maximum_delay_ms: 100,
        };
        assert_eq!(
            ledger.record_failure(
                ticket.key,
                ProposalFailureReport {
                    attempt: 0,
                    failure: ProposalFailureClass::ProviderRateLimit,
                    retry_policy: policy,
                    observed_ms: 30,
                    provider_retry_after_ms: Some(100),
                    jitter_word: 0,
                },
            ),
            Ok(RetryAction::RetryAt { not_before_ms: 100 })
        );
        assert_eq!(
            ledger.record_failure(
                ticket.key,
                ProposalFailureReport {
                    attempt: 0,
                    failure: ProposalFailureClass::ProviderRateLimit,
                    retry_policy: policy,
                    observed_ms: 31,
                    provider_retry_after_ms: Some(400),
                    jitter_word: u64::MAX,
                },
            ),
            Ok(RetryAction::RetryAt { not_before_ms: 100 })
        );
        assert_eq!(
            ledger.claim(ticket.key, 99),
            Ok(ProposalTicketClaim::Deferred { not_before_ms: 100 })
        );
        assert_eq!(
            ledger.claim(ticket.key, 100),
            Ok(ProposalTicketClaim::Started { attempt: 1 })
        );
        let digest = *blake3::hash(b"result").as_bytes();
        assert_eq!(
            ledger.complete(ticket.key, 0, digest, 100, 110),
            Err(ProposalTicketError::InvalidTransition)
        );
        ledger.complete(ticket.key, 1, digest, 100, 120).unwrap();
        ledger.complete(ticket.key, 1, digest, 100, 121).unwrap();
        assert_eq!(
            ledger.complete(ticket.key, 0, digest, 100, 121),
            Err(ProposalTicketError::IdentityConflict)
        );
        assert!(matches!(
            ledger.get(ticket.key).unwrap().status,
            ProposalTicketStatus::Ready {
                attempt: 1,
                result_blake3,
                ..
            } if result_blake3 == digest
        ));
        assert_eq!(
            ledger.admission_result(ticket.key, 700),
            Ok(ProposalReadyResult {
                result_blake3: digest,
                result_bytes: 100,
            })
        );
        assert!(matches!(
            ledger.admission_result(ticket.key, 701),
            Err(ProposalTicketError::Deadline(DeadlineExceeded {
                stage: DeadlineStage::Admission,
                ..
            }))
        ));
        assert!(ledger.result(ticket.key, 701).is_ok());
        assert!(matches!(
            ledger.result(ticket.key, 901),
            Err(ProposalTicketError::Deadline(DeadlineExceeded {
                stage: DeadlineStage::ResultRetention,
                ..
            }))
        ));
        assert!(matches!(
            ledger.get(ticket.key).unwrap().status,
            ProposalTicketStatus::Expired {
                stage: DeadlineStage::ResultRetention,
                ..
            }
        ));
    }

    #[test]
    fn cancellation_and_terminal_failures_are_idempotent() {
        let mut ledger = ProposalTicketLedger::new(4).unwrap();
        let cancelled = spec("session", 1, 7);
        ledger.submit(cancelled, 10).unwrap();
        assert_eq!(ledger.cancel(cancelled.key, 20), Ok(true));
        assert_eq!(ledger.cancel(cancelled.key, 21), Ok(false));

        let failed = spec("session", 2, 7);
        ledger.submit(failed, 10).unwrap();
        ledger.claim(failed.key, 20).unwrap();
        let action = ledger
            .record_failure(
                failed.key,
                ProposalFailureReport {
                    attempt: 0,
                    failure: ProposalFailureClass::SemanticRejection,
                    retry_policy: RetryPolicy {
                        maximum_retries: 2,
                        base_delay_ms: 50,
                        maximum_delay_ms: 100,
                    },
                    observed_ms: 30,
                    provider_retry_after_ms: None,
                    jitter_word: 0,
                },
            )
            .unwrap();
        assert_eq!(action, RetryAction::DoNotRetry);
        assert_eq!(
            ledger.record_failure(
                failed.key,
                ProposalFailureReport {
                    attempt: 0,
                    failure: ProposalFailureClass::SemanticRejection,
                    retry_policy: RetryPolicy {
                        maximum_retries: 2,
                        base_delay_ms: 50,
                        maximum_delay_ms: 100,
                    },
                    observed_ms: 31,
                    provider_retry_after_ms: None,
                    jitter_word: 99,
                },
            ),
            Ok(RetryAction::DoNotRetry)
        );
        assert!(matches!(
            ledger.get(failed.key).unwrap().status,
            ProposalTicketStatus::TerminalFailure {
                failure: ProposalFailureClass::SemanticRejection,
                ..
            }
        ));
    }

    #[test]
    fn restore_rejects_duplicate_and_impossible_state() {
        let mut ledger = ProposalTicketLedger::new(4).unwrap();
        let ticket = spec("session", 1, 7);
        ledger.submit(ticket, 10).unwrap();
        ledger.claim(ticket.key, 20).unwrap();
        let snapshot = ledger.snapshot();
        assert_eq!(
            ProposalTicketLedger::restore(snapshot.clone(), 4, 20)
                .unwrap()
                .get(ticket.key),
            ledger.get(ticket.key)
        );
        assert!(ProposalTicketLedger::restore(snapshot.clone(), 3, 20).is_err());

        let mut duplicate = snapshot.clone();
        duplicate.tickets.push(duplicate.tickets[0]);
        assert!(ProposalTicketLedger::restore(duplicate, 4, 20).is_err());

        let mut impossible = snapshot;
        impossible.tickets[0].status = ProposalTicketStatus::RetryWait {
            failed_attempt: 0,
            next_attempt: 1,
            not_before_ms: 501,
            failure: ProposalFailureClass::TransientTransport,
            retry_action: RetryAction::RetryAt { not_before_ms: 501 },
        };
        assert!(ProposalTicketLedger::restore(impossible, 4, 501).is_err());

        let mut queued = ProposalTicketLedger::new(4).unwrap();
        let queued_ticket = spec("queued", 1, 7);
        queued.submit(queued_ticket, 10).unwrap();
        let restored = ProposalTicketLedger::restore(queued.snapshot(), 4, 101).unwrap();
        assert!(matches!(
            restored.get(queued_ticket.key).unwrap().status,
            ProposalTicketStatus::Expired {
                stage: DeadlineStage::Queue,
                ..
            }
        ));
    }

    #[test]
    fn deadline_and_clock_fail_closed() {
        let mut ledger = ProposalTicketLedger::new(4).unwrap();
        let ticket = spec("session", 1, 7);
        assert!(matches!(
            ledger.submit(ticket, 101),
            Err(ProposalTicketError::Deadline(_))
        ));
        ledger.submit(ticket, 10).unwrap();
        ledger.claim(ticket.key, 20).unwrap();
        assert_eq!(
            ledger.complete(ticket.key, 0, [0; 32], 2_048, 30),
            Err(ProposalTicketError::ResultTooLarge)
        );
        assert_eq!(
            ledger.cancel(ticket.key, 19),
            Err(ProposalTicketError::ClockReversed)
        );
    }
}
