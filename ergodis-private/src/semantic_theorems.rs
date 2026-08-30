//! Proof-safety contracts for composing discovered theorem fragments.

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum ClaimStatus {
    Candidate,
    FiniteCertified,
    Proved,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum CompositionKind {
    DirectImplication,
    Specialization,
    Transport,
    CaseSplit,
    Induction,
    QuotientLift,
    BoundArithmetic,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct CompositionGate {
    pub premises: ClaimStatus,
    pub domains_compatible: bool,
    pub quantifiers_compatible: bool,
    pub rule_verified: bool,
}

impl CompositionGate {
    #[must_use]
    pub fn result_status(self) -> ClaimStatus {
        if self.premises == ClaimStatus::Proved
            && self.domains_compatible
            && self.quantifiers_compatible
            && self.rule_verified
        {
            ClaimStatus::Proved
        } else if self.premises >= ClaimStatus::FiniteCertified
            && self.domains_compatible
            && self.quantifiers_compatible
            && self.rule_verified
        {
            ClaimStatus::FiniteCertified
        } else {
            ClaimStatus::Candidate
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn finite_evidence_does_not_promote_to_proof() {
        let gate = CompositionGate {
            premises: ClaimStatus::FiniteCertified,
            domains_compatible: true,
            quantifiers_compatible: true,
            rule_verified: true,
        };
        assert_eq!(gate.result_status(), ClaimStatus::FiniteCertified);
    }

    #[test]
    fn quantifier_mismatch_blocks_composition() {
        let gate = CompositionGate {
            premises: ClaimStatus::Proved,
            domains_compatible: true,
            quantifiers_compatible: false,
            rule_verified: true,
        };
        assert_eq!(gate.result_status(), ClaimStatus::Candidate);
    }

    #[test]
    fn proved_compatible_fragments_compose() {
        let gate = CompositionGate {
            premises: ClaimStatus::Proved,
            domains_compatible: true,
            quantifiers_compatible: true,
            rule_verified: true,
        };
        assert_eq!(gate.result_status(), ClaimStatus::Proved);
    }
}
