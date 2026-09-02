//! Deterministic cold policy primitives for external theorem proposers.
//!
//! Callers supply monotone milliseconds explicitly. No policy state or clock
//! read is reachable from a solve worker.

use super::ControlError;
use serde::{Deserialize, Serialize};

const PARTS_PER_MILLION: u128 = 1_000_000;
const MAX_SESSION_ID_BYTES: usize = 256;

#[repr(transparent)]
#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq)]
pub struct ProposalIdempotencyKey([u8; 32]);

const _: () = assert!(std::mem::size_of::<ProposalIdempotencyKey>() == 32);
const _: () = assert!(std::mem::align_of::<ProposalIdempotencyKey>() == 1);

impl ProposalIdempotencyKey {
    pub fn new(
        session_id: &str,
        request_id: u64,
        canonical_payload_blake3: [u8; 32],
    ) -> Result<Self, ControlError> {
        if session_id.is_empty() || session_id.len() > MAX_SESSION_ID_BYTES || request_id == 0 {
            return Err(ControlError::Invalid(
                "invalid proposer idempotency identity".into(),
            ));
        }
        let mut hasher = blake3::Hasher::new();
        hasher.update(b"ergodis-proposer-idempotency-v1\0");
        hasher.update(&(session_id.len() as u64).to_le_bytes());
        hasher.update(session_id.as_bytes());
        hasher.update(&request_id.to_le_bytes());
        hasher.update(&canonical_payload_blake3);
        Ok(Self(*hasher.finalize().as_bytes()))
    }

    pub fn as_bytes(self) -> [u8; 32] {
        self.0
    }

    pub fn to_hex(self) -> String {
        blake3::Hash::from(self.0).to_hex().to_string()
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct TokenBucketConfig {
    pub capacity: u64,
    pub refill_units: u64,
    pub refill_period_ms: u64,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct TokenBucketSnapshot {
    pub tokens: u64,
    pub refill_remainder: u64,
    pub last_refill_ms: u64,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct RateLimit {
    pub remaining: u64,
    pub retry_at_ms: u64,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, thiserror::Error)]
pub enum TokenBucketError {
    #[error("token-bucket cost must be positive")]
    InvalidCost,
    #[error("token-bucket monotone time moved backwards")]
    ClockReversed,
    #[error("request is rate limited")]
    RateLimited(RateLimit),
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, thiserror::Error)]
pub enum HierarchicalTokenBucketError {
    #[error("hierarchical token-bucket costs do not match the bucket count")]
    ShapeMismatch,
    #[error("hierarchical token bucket {bucket_index} rejected the charge: {source}")]
    Bucket {
        bucket_index: usize,
        #[source]
        source: TokenBucketError,
    },
}

#[derive(Clone, Debug)]
pub struct TokenBucket {
    config: TokenBucketConfig,
    state: TokenBucketSnapshot,
}

impl TokenBucket {
    pub fn full(config: TokenBucketConfig, now_ms: u64) -> Result<Self, ControlError> {
        validate_bucket_config(config)?;
        Ok(Self {
            config,
            state: TokenBucketSnapshot {
                tokens: config.capacity,
                refill_remainder: 0,
                last_refill_ms: now_ms,
            },
        })
    }

    pub fn restore(
        config: TokenBucketConfig,
        state: TokenBucketSnapshot,
        now_ms: u64,
    ) -> Result<Self, ControlError> {
        validate_bucket_config(config)?;
        if state.tokens > config.capacity
            || state.refill_remainder >= config.refill_period_ms
            || state.last_refill_ms > now_ms
        {
            return Err(ControlError::Invalid(
                "invalid persisted token-bucket state".into(),
            ));
        }
        let mut bucket = Self { config, state };
        bucket
            .refill(now_ms)
            .map_err(|error| ControlError::Invalid(error.to_string()))?;
        Ok(bucket)
    }

    pub fn snapshot(&self) -> TokenBucketSnapshot {
        self.state
    }

    pub fn remaining(&mut self, now_ms: u64) -> Result<u64, TokenBucketError> {
        self.refill(now_ms)?;
        Ok(self.state.tokens)
    }

    pub fn try_take(&mut self, now_ms: u64, cost: u64) -> Result<(), TokenBucketError> {
        self.preview_take(now_ms, cost)?;
        self.state.tokens -= cost;
        Ok(())
    }

    fn preview_take(&mut self, now_ms: u64, cost: u64) -> Result<(), TokenBucketError> {
        if cost == 0 {
            return Err(TokenBucketError::InvalidCost);
        }
        self.refill(now_ms)?;
        if self.state.tokens >= cost {
            return Ok(());
        }
        let missing = cost - self.state.tokens;
        if cost > self.config.capacity {
            return Err(TokenBucketError::RateLimited(RateLimit {
                remaining: self.state.tokens,
                retry_at_ms: u64::MAX,
            }));
        }
        let numerator = u128::from(missing) * u128::from(self.config.refill_period_ms);
        let adjusted = numerator.saturating_sub(u128::from(self.state.refill_remainder));
        let delay = adjusted.div_ceil(u128::from(self.config.refill_units));
        Err(TokenBucketError::RateLimited(RateLimit {
            remaining: self.state.tokens,
            retry_at_ms: now_ms.saturating_add(u64::try_from(delay).unwrap_or(u64::MAX)),
        }))
    }

    fn refill(&mut self, now_ms: u64) -> Result<(), TokenBucketError> {
        let elapsed = now_ms
            .checked_sub(self.state.last_refill_ms)
            .ok_or(TokenBucketError::ClockReversed)?;
        if elapsed == 0 || self.state.tokens == self.config.capacity {
            self.state.last_refill_ms = now_ms;
            if self.state.tokens == self.config.capacity {
                self.state.refill_remainder = 0;
            }
            return Ok(());
        }
        let accrued = u128::from(elapsed) * u128::from(self.config.refill_units)
            + u128::from(self.state.refill_remainder);
        let period = u128::from(self.config.refill_period_ms);
        let added = accrued / period;
        self.state.refill_remainder =
            u64::try_from(accrued % period).expect("remainder is below a u64 refill period");
        self.state.tokens = self.config.capacity.min(
            self.state
                .tokens
                .saturating_add(u64::try_from(added).unwrap_or(u64::MAX)),
        );
        self.state.last_refill_ms = now_ms;
        if self.state.tokens == self.config.capacity {
            self.state.refill_remainder = 0;
        }
        Ok(())
    }
}

/// Atomically debit every applicable campaign/provider/session bucket.
///
/// Refills are observed at `now_ms` even when a later bucket rejects the
/// request, but no token debit occurs unless every bucket admits its cost.
pub fn charge_token_buckets(
    buckets: &mut [TokenBucket],
    costs: &[u64],
    now_ms: u64,
) -> Result<(), HierarchicalTokenBucketError> {
    if buckets.len() != costs.len() {
        return Err(HierarchicalTokenBucketError::ShapeMismatch);
    }
    for (bucket_index, (bucket, &cost)) in buckets.iter_mut().zip(costs).enumerate() {
        bucket.preview_take(now_ms, cost).map_err(|source| {
            HierarchicalTokenBucketError::Bucket {
                bucket_index,
                source,
            }
        })?;
    }
    for (bucket, &cost) in buckets.iter_mut().zip(costs) {
        bucket.state.tokens -= cost;
    }
    Ok(())
}

fn validate_bucket_config(config: TokenBucketConfig) -> Result<(), ControlError> {
    if config.capacity == 0 || config.refill_units == 0 || config.refill_period_ms == 0 {
        return Err(ControlError::Invalid(
            "token-bucket capacity and refill terms must be positive".into(),
        ));
    }
    Ok(())
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum DeadlineStage {
    Queue,
    Execution,
    ResultRetention,
    Admission,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalDeadlines {
    pub queue_by_ms: u64,
    pub execute_by_ms: u64,
    pub retain_until_ms: u64,
    pub admit_by_ms: u64,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, thiserror::Error)]
#[error("{stage:?} deadline {deadline_ms} ms has expired")]
pub struct DeadlineExceeded {
    pub stage: DeadlineStage,
    pub deadline_ms: u64,
}

impl ProposalDeadlines {
    pub fn new(
        queue_by_ms: u64,
        execute_by_ms: u64,
        retain_until_ms: u64,
        admit_by_ms: u64,
    ) -> Result<Self, ControlError> {
        if queue_by_ms > execute_by_ms
            || execute_by_ms > admit_by_ms
            || admit_by_ms > retain_until_ms
        {
            return Err(ControlError::Invalid(
                "proposal deadlines have an invalid absolute order".into(),
            ));
        }
        Ok(Self {
            queue_by_ms,
            execute_by_ms,
            retain_until_ms,
            admit_by_ms,
        })
    }

    pub fn deadline(self, stage: DeadlineStage) -> u64 {
        match stage {
            DeadlineStage::Queue => self.queue_by_ms,
            DeadlineStage::Execution => self.execute_by_ms,
            DeadlineStage::ResultRetention => self.retain_until_ms,
            DeadlineStage::Admission => self.admit_by_ms,
        }
    }

    pub fn check(self, stage: DeadlineStage, now_ms: u64) -> Result<(), DeadlineExceeded> {
        let deadline_ms = self.deadline(stage);
        if now_ms > deadline_ms {
            Err(DeadlineExceeded { stage, deadline_ms })
        } else {
            Ok(())
        }
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum ProposalFailureClass {
    Malformed,
    ForbiddenRole,
    SemanticRejection,
    StaleSnapshot,
    BudgetLimit,
    DeterministicBackend,
    TransientTransport,
    ProviderRateLimit,
    QueueTimeout,
    ExecutionTimeout,
    BackendCrash,
    ProtocolFault,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum RetryAction {
    DoNotRetry,
    RebaseRequired,
    ReduceScope,
    RetryAt { not_before_ms: u64 },
    CircuitOpen { until_ms: u64 },
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct RetryPolicy {
    pub maximum_retries: u8,
    pub base_delay_ms: u64,
    pub maximum_delay_ms: u64,
}

impl RetryPolicy {
    pub fn decide(
        self,
        failure: ProposalFailureClass,
        prior_retries: u8,
        now_ms: u64,
        deadline_ms: u64,
        provider_retry_after_ms: Option<u64>,
        jitter_word: u64,
    ) -> RetryAction {
        match failure {
            ProposalFailureClass::StaleSnapshot => return RetryAction::RebaseRequired,
            ProposalFailureClass::BudgetLimit
            | ProposalFailureClass::QueueTimeout
            | ProposalFailureClass::ExecutionTimeout => return RetryAction::ReduceScope,
            ProposalFailureClass::BackendCrash | ProposalFailureClass::ProtocolFault => {
                return RetryAction::CircuitOpen {
                    until_ms: now_ms.saturating_add(self.maximum_delay_ms),
                };
            }
            ProposalFailureClass::TransientTransport | ProposalFailureClass::ProviderRateLimit => {}
            ProposalFailureClass::Malformed
            | ProposalFailureClass::ForbiddenRole
            | ProposalFailureClass::SemanticRejection
            | ProposalFailureClass::DeterministicBackend => return RetryAction::DoNotRetry,
        }
        if self.maximum_retries == 0
            || self.base_delay_ms == 0
            || self.maximum_delay_ms < self.base_delay_ms
            || prior_retries >= self.maximum_retries
        {
            return RetryAction::DoNotRetry;
        }
        let shift = u32::from(prior_retries.min(63));
        let ceiling = self
            .base_delay_ms
            .saturating_mul(1_u64.checked_shl(shift).unwrap_or(u64::MAX))
            .min(self.maximum_delay_ms);
        let jittered = if ceiling == u64::MAX {
            jitter_word
        } else {
            jitter_word % (ceiling + 1)
        };
        let not_before_ms = now_ms
            .saturating_add(jittered)
            .max(provider_retry_after_ms.unwrap_or(now_ms));
        if not_before_ms > deadline_ms {
            RetryAction::DoNotRetry
        } else {
            RetryAction::RetryAt { not_before_ms }
        }
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct CircuitBreakerConfig {
    pub failure_threshold: u8,
    pub base_open_ms: u64,
    pub maximum_open_ms: u64,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum CircuitPermit {
    Normal,
    HalfOpenProbe,
    Denied { retry_at_ms: u64 },
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct CircuitBreaker {
    config: CircuitBreakerConfig,
    consecutive_failures: u8,
    open_count: u8,
    open_until_ms: u64,
    half_open_claimed: bool,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct CircuitBreakerSnapshot {
    pub consecutive_failures: u8,
    pub open_count: u8,
    pub open_until_ms: u64,
    pub half_open_claimed: bool,
}

impl CircuitBreaker {
    pub fn new(config: CircuitBreakerConfig) -> Result<Self, ControlError> {
        validate_circuit_config(config)?;
        Ok(Self {
            config,
            consecutive_failures: 0,
            open_count: 0,
            open_until_ms: 0,
            half_open_claimed: false,
        })
    }

    pub fn restore(
        config: CircuitBreakerConfig,
        snapshot: CircuitBreakerSnapshot,
        now_ms: u64,
    ) -> Result<Self, ControlError> {
        validate_circuit_config(config)?;
        if (snapshot.open_until_ms == 0
            && (snapshot.half_open_claimed
                || snapshot.consecutive_failures >= config.failure_threshold))
            || (snapshot.open_until_ms != 0
                && (snapshot.open_count == 0
                    || snapshot.consecutive_failures < config.failure_threshold))
            || (snapshot.half_open_claimed && now_ms < snapshot.open_until_ms)
        {
            return Err(ControlError::Invalid(
                "invalid persisted circuit-breaker state".into(),
            ));
        }
        Ok(Self {
            config,
            consecutive_failures: snapshot.consecutive_failures,
            open_count: snapshot.open_count,
            open_until_ms: snapshot.open_until_ms,
            half_open_claimed: snapshot.half_open_claimed,
        })
    }

    pub fn snapshot(self) -> CircuitBreakerSnapshot {
        CircuitBreakerSnapshot {
            consecutive_failures: self.consecutive_failures,
            open_count: self.open_count,
            open_until_ms: self.open_until_ms,
            half_open_claimed: self.half_open_claimed,
        }
    }

    pub fn permit(&mut self, now_ms: u64) -> CircuitPermit {
        if self.open_until_ms == 0 {
            return CircuitPermit::Normal;
        }
        if now_ms < self.open_until_ms {
            return CircuitPermit::Denied {
                retry_at_ms: self.open_until_ms,
            };
        }
        if self.half_open_claimed {
            CircuitPermit::Denied {
                retry_at_ms: u64::MAX,
            }
        } else {
            self.half_open_claimed = true;
            CircuitPermit::HalfOpenProbe
        }
    }

    pub fn record_success(&mut self) {
        self.consecutive_failures = 0;
        self.open_count = 0;
        self.open_until_ms = 0;
        self.half_open_claimed = false;
    }

    pub fn record_failure(&mut self, failure: ProposalFailureClass, now_ms: u64) {
        if !failure_counts_toward_circuit(failure) {
            return;
        }
        self.consecutive_failures = self.consecutive_failures.saturating_add(1);
        if self.consecutive_failures < self.config.failure_threshold && self.open_until_ms == 0 {
            return;
        }
        let shift = u32::from(self.open_count.min(63));
        let interval = self
            .config
            .base_open_ms
            .saturating_mul(1_u64.checked_shl(shift).unwrap_or(u64::MAX))
            .min(self.config.maximum_open_ms);
        self.open_count = self.open_count.saturating_add(1);
        self.open_until_ms = now_ms.saturating_add(interval);
        self.half_open_claimed = false;
    }
}

fn validate_circuit_config(config: CircuitBreakerConfig) -> Result<(), ControlError> {
    if config.failure_threshold == 0
        || config.base_open_ms == 0
        || config.maximum_open_ms < config.base_open_ms
    {
        return Err(ControlError::Invalid(
            "invalid circuit-breaker configuration".into(),
        ));
    }
    Ok(())
}

fn failure_counts_toward_circuit(failure: ProposalFailureClass) -> bool {
    matches!(
        failure,
        ProposalFailureClass::TransientTransport
            | ProposalFailureClass::ExecutionTimeout
            | ProposalFailureClass::BackendCrash
            | ProposalFailureClass::ProtocolFault
    )
}

#[repr(u8)]
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum ProposalRole {
    Ordering,
    Heuristic,
    NecessaryReduction,
    ExactTransport,
}

impl ProposalRole {
    pub fn mask(self) -> u8 {
        1 << self as u8
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct ProposalCandidate {
    pub id: u16,
    pub required_context: u64,
    pub supported_roles: u8,
    pub admission_probability_ppm: u32,
    pub expected_exact_work_gain: u64,
    pub cross_instance_reuse_ppm: u32,
    pub estimated_cost_units: u64,
    pub estimated_return_bytes: u64,
    pub exploration_bonus: u64,
    pub available_tokens: u64,
    pub in_flight: u16,
    pub concurrency_limit: u16,
    pub circuit_open_until_ms: u64,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct ProposalSelectionContext {
    pub available_context: u64,
    pub requested_role: ProposalRole,
    pub remaining_cost_units: u64,
    pub remaining_return_bytes: u64,
    pub now_ms: u64,
    pub deadline_ms: u64,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct ProposalSelection {
    pub id: u16,
    pub value_numerator: u128,
    pub cost_denominator: u64,
}

pub fn select_proposer(
    candidates: &[ProposalCandidate],
    context: ProposalSelectionContext,
) -> Result<Option<ProposalSelection>, ControlError> {
    if context.now_ms > context.deadline_ms {
        return Ok(None);
    }
    for (index, candidate) in candidates.iter().enumerate() {
        if candidates[index + 1..]
            .iter()
            .any(|other| other.id == candidate.id)
        {
            return Err(ControlError::Invalid(
                "duplicate proposer candidate ID".into(),
            ));
        }
    }
    let mut best: Option<ProposalSelection> = None;
    for &candidate in candidates {
        if candidate.admission_probability_ppm > 1_000_000
            || candidate.cross_instance_reuse_ppm > 1_000_000
            || candidate.supported_roles & !0x0f != 0
            || candidate.estimated_cost_units == 0
            || candidate.concurrency_limit == 0
        {
            return Err(ControlError::Invalid(
                "proposer candidate has invalid bounded estimates".into(),
            ));
        }
        if candidate.required_context & !context.available_context != 0
            || candidate.supported_roles & context.requested_role.mask() == 0
            || candidate.estimated_cost_units > context.remaining_cost_units
            || candidate.estimated_return_bytes > context.remaining_return_bytes
            || candidate.available_tokens < candidate.estimated_cost_units
            || candidate.in_flight >= candidate.concurrency_limit
            || candidate.circuit_open_until_ms > context.now_ms
        {
            continue;
        }
        let expected = u128::from(candidate.admission_probability_ppm)
            .checked_mul(u128::from(candidate.expected_exact_work_gain))
            .and_then(|value| value.checked_mul(u128::from(candidate.cross_instance_reuse_ppm)))
            .ok_or_else(|| ControlError::Invalid("proposer value estimate overflow".into()))?;
        let exploration = u128::from(candidate.exploration_bonus)
            .checked_mul(PARTS_PER_MILLION * PARTS_PER_MILLION)
            .ok_or_else(|| {
                ControlError::Invalid("proposer exploration estimate overflow".into())
            })?;
        let selection = ProposalSelection {
            id: candidate.id,
            value_numerator: expected
                .checked_add(exploration)
                .ok_or_else(|| ControlError::Invalid("proposer score overflow".into()))?,
            cost_denominator: candidate.estimated_cost_units,
        };
        if selection.value_numerator == 0 {
            continue;
        }
        let replace = if let Some(current) = best {
            let left = selection
                .value_numerator
                .checked_mul(u128::from(current.cost_denominator))
                .ok_or_else(|| {
                    ControlError::Invalid("proposer score comparison overflow".into())
                })?;
            let right = current
                .value_numerator
                .checked_mul(u128::from(selection.cost_denominator))
                .ok_or_else(|| {
                    ControlError::Invalid("proposer score comparison overflow".into())
                })?;
            left > right || (left == right && selection.id < current.id)
        } else {
            true
        };
        if replace {
            best = Some(selection);
        }
    }
    Ok(best)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn proposer_idempotency_keys_bind_the_full_logical_request() {
        let payload = *blake3::hash(b"canonical request").as_bytes();
        let key = ProposalIdempotencyKey::new("session-a", 7, payload).unwrap();
        assert_eq!(
            key,
            ProposalIdempotencyKey::new("session-a", 7, payload).unwrap()
        );
        assert_ne!(
            key,
            ProposalIdempotencyKey::new("session-b", 7, payload).unwrap()
        );
        assert_ne!(
            key,
            ProposalIdempotencyKey::new("session-a", 8, payload).unwrap()
        );
        assert_ne!(
            key,
            ProposalIdempotencyKey::new(
                "session-a",
                7,
                *blake3::hash(b"different request").as_bytes(),
            )
            .unwrap()
        );
        assert_eq!(key.to_hex().len(), 64);
        assert_eq!(key.as_bytes().len(), 32);
        assert!(ProposalIdempotencyKey::new("", 7, payload).is_err());
        assert!(ProposalIdempotencyKey::new("session-a", 0, payload).is_err());
        assert!(ProposalIdempotencyKey::new(&"s".repeat(257), 7, payload).is_err());
    }

    #[test]
    fn token_bucket_refills_persists_and_reports_retry() {
        let config = TokenBucketConfig {
            capacity: 10,
            refill_units: 2,
            refill_period_ms: 1_000,
        };
        let mut bucket = TokenBucket::full(config, 100).unwrap();
        bucket.try_take(100, 9).unwrap();
        assert_eq!(
            bucket.try_take(100, 2),
            Err(TokenBucketError::RateLimited(RateLimit {
                remaining: 1,
                retry_at_ms: 600,
            }))
        );
        assert_eq!(bucket.remaining(600).unwrap(), 2);
        let restored = TokenBucket::restore(config, bucket.snapshot(), 1_100).unwrap();
        assert_eq!(restored.state.tokens, 3);
        let before = bucket.snapshot();
        assert_eq!(
            bucket.try_take(599, 1),
            Err(TokenBucketError::ClockReversed)
        );
        assert_eq!(bucket.snapshot(), before);
    }

    #[test]
    fn hierarchical_token_charges_are_all_or_none() {
        let config = TokenBucketConfig {
            capacity: 10,
            refill_units: 1,
            refill_period_ms: 1_000,
        };
        let mut buckets = [
            TokenBucket::full(config, 0).unwrap(),
            TokenBucket::full(config, 0).unwrap(),
        ];
        buckets[1].try_take(0, 9).unwrap();
        assert_eq!(
            charge_token_buckets(&mut buckets, &[4, 2], 0),
            Err(HierarchicalTokenBucketError::Bucket {
                bucket_index: 1,
                source: TokenBucketError::RateLimited(RateLimit {
                    remaining: 1,
                    retry_at_ms: 1_000,
                }),
            })
        );
        assert_eq!(buckets[0].snapshot().tokens, 10);
        assert_eq!(buckets[1].snapshot().tokens, 1);
        charge_token_buckets(&mut buckets, &[4, 1], 0).unwrap();
        assert_eq!(buckets[0].snapshot().tokens, 6);
        assert_eq!(buckets[1].snapshot().tokens, 0);
        assert_eq!(
            charge_token_buckets(&mut buckets, &[1], 0),
            Err(HierarchicalTokenBucketError::ShapeMismatch)
        );
    }

    #[test]
    fn retry_policy_is_typed_bounded_and_deadline_aware() {
        let policy = RetryPolicy {
            maximum_retries: 4,
            base_delay_ms: 250,
            maximum_delay_ms: 30_000,
        };
        assert_eq!(
            policy.decide(
                ProposalFailureClass::SemanticRejection,
                0,
                1_000,
                10_000,
                None,
                7,
            ),
            RetryAction::DoNotRetry
        );
        assert_eq!(
            policy.decide(
                ProposalFailureClass::ProviderRateLimit,
                1,
                1_000,
                10_000,
                Some(4_000),
                3,
            ),
            RetryAction::RetryAt {
                not_before_ms: 4_000
            }
        );
        assert_eq!(
            policy.decide(
                ProposalFailureClass::TransientTransport,
                1,
                9_900,
                10_000,
                Some(10_100),
                3,
            ),
            RetryAction::DoNotRetry
        );
    }

    #[test]
    fn absolute_deadlines_distinguish_operation_stages() {
        let deadlines = ProposalDeadlines::new(100, 200, 400, 300).unwrap();
        assert_eq!(deadlines.check(DeadlineStage::Queue, 100), Ok(()));
        assert_eq!(
            deadlines.check(DeadlineStage::Queue, 101),
            Err(DeadlineExceeded {
                stage: DeadlineStage::Queue,
                deadline_ms: 100,
            })
        );
        assert_eq!(deadlines.check(DeadlineStage::Execution, 150), Ok(()));
        assert!(ProposalDeadlines::new(200, 100, 400, 300).is_err());
        assert!(ProposalDeadlines::new(100, 300, 400, 200).is_err());
    }

    #[test]
    fn circuit_breaker_ignores_semantic_rejection_and_allows_one_probe() {
        let mut breaker = CircuitBreaker::new(CircuitBreakerConfig {
            failure_threshold: 2,
            base_open_ms: 100,
            maximum_open_ms: 800,
        })
        .unwrap();
        breaker.record_failure(ProposalFailureClass::SemanticRejection, 10);
        breaker.record_failure(ProposalFailureClass::ProviderRateLimit, 10);
        breaker.record_failure(ProposalFailureClass::QueueTimeout, 10);
        assert_eq!(breaker.permit(10), CircuitPermit::Normal);
        breaker.record_failure(ProposalFailureClass::BackendCrash, 20);
        breaker.record_failure(ProposalFailureClass::BackendCrash, 30);
        assert_eq!(
            breaker.permit(40),
            CircuitPermit::Denied { retry_at_ms: 130 }
        );
        assert_eq!(breaker.permit(130), CircuitPermit::HalfOpenProbe);
        let snapshot = breaker.snapshot();
        let mut restored = CircuitBreaker::restore(breaker.config, snapshot, 130).unwrap();
        assert_eq!(
            restored.permit(130),
            CircuitPermit::Denied {
                retry_at_ms: u64::MAX
            }
        );
        restored.record_success();
        assert_eq!(restored.permit(131), CircuitPermit::Normal);
        assert!(CircuitBreaker::restore(
            breaker.config,
            CircuitBreakerSnapshot {
                consecutive_failures: 0,
                open_count: 0,
                open_until_ms: 0,
                half_open_claimed: true,
            },
            131,
        )
        .is_err());
        assert!(CircuitBreaker::restore(
            breaker.config,
            CircuitBreakerSnapshot {
                consecutive_failures: 0,
                open_count: 1,
                open_until_ms: 200,
                half_open_claimed: false,
            },
            131,
        )
        .is_err());
    }

    fn candidate(id: u16, cost: u64, gain: u64) -> ProposalCandidate {
        ProposalCandidate {
            id,
            required_context: 1,
            supported_roles: ProposalRole::ExactTransport.mask(),
            admission_probability_ppm: 500_000,
            expected_exact_work_gain: gain,
            cross_instance_reuse_ppm: 1_000_000,
            estimated_cost_units: cost,
            estimated_return_bytes: 1_000,
            exploration_bonus: 0,
            available_tokens: 1_000,
            in_flight: 0,
            concurrency_limit: 1,
            circuit_open_until_ms: 0,
        }
    }

    #[test]
    fn selector_prices_value_and_filters_ineligible_proposers() {
        let context = ProposalSelectionContext {
            available_context: 1,
            requested_role: ProposalRole::ExactTransport,
            remaining_cost_units: 1_000,
            remaining_return_bytes: 2_000,
            now_ms: 100,
            deadline_ms: 200,
        };
        let cheap = candidate(2, 10, 100);
        let expensive = candidate(1, 100, 500);
        assert_eq!(
            select_proposer(&[expensive, cheap], context)
                .unwrap()
                .unwrap()
                .id,
            2
        );

        let mut blocked = cheap;
        blocked.circuit_open_until_ms = 101;
        assert_eq!(select_proposer(&[blocked], context).unwrap(), None);

        let mut exploratory = expensive;
        exploratory.exploration_bonus = 1_000;
        assert_eq!(
            select_proposer(&[cheap, exploratory], context)
                .unwrap()
                .unwrap()
                .id,
            1
        );

        assert!(select_proposer(&[cheap, cheap], context).is_err());
        let mut zero = cheap;
        zero.admission_probability_ppm = 0;
        zero.exploration_bonus = 0;
        assert_eq!(select_proposer(&[zero], context).unwrap(), None);

        let mut huge_left = candidate(3, u64::MAX, u64::MAX);
        let mut huge_right = candidate(4, u64::MAX - 1, u64::MAX);
        for candidate in [&mut huge_left, &mut huge_right] {
            candidate.available_tokens = u64::MAX;
            candidate.estimated_return_bytes = 0;
        }
        let huge_context = ProposalSelectionContext {
            remaining_cost_units: u64::MAX,
            remaining_return_bytes: u64::MAX,
            ..context
        };
        assert!(select_proposer(&[huge_left, huge_right], huge_context).is_err());
    }
}
