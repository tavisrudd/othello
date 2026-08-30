//! Minimal typed contracts for `match / reduce / canonicalize` plans.

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum OpKind {
    Match,
    Reduce,
    Canonicalize,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum LabelContract {
    /// The action fixes the exact label predicate.
    Preserves,
    /// The action carries labels through an exact domain adapter.
    Transports,
    /// Useful geometry only; forbidden in a proof-producing quotient.
    Diagnostic,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct CanonicalizationGate {
    pub label_contract: LabelContract,
    pub action_verified: bool,
}

impl CanonicalizationGate {
    #[must_use]
    pub const fn proof_eligible(self) -> bool {
        match self.label_contract {
            LabelContract::Preserves | LabelContract::Transports => self.action_verified,
            LabelContract::Diagnostic => false,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn diagnostic_symmetry_never_enters_proof_packet() {
        let gate = CanonicalizationGate {
            label_contract: LabelContract::Diagnostic,
            action_verified: true,
        };
        assert!(!gate.proof_eligible());
    }

    #[test]
    fn transported_labels_require_verified_action() {
        let unverified = CanonicalizationGate {
            label_contract: LabelContract::Transports,
            action_verified: false,
        };
        assert!(!unverified.proof_eligible());
        assert!(CanonicalizationGate {
            label_contract: LabelContract::Transports,
            action_verified: true,
        }
        .proof_eligible());
    }
}
