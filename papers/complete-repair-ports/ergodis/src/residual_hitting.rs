//! Exact bounded residual Hitting Set with streamed negative evidence.

use std::io::{Read, Write};

use thiserror::Error;

const MAGIC: [u8; 8] = *b"ERGHIT02";

#[derive(Debug, Error)]
pub enum ResidualHittingError {
    #[error("the requested hitting budget exceeds the pre-sized workspace")]
    Budget,
    #[error("a residual clause uses an element outside the available universe")]
    Clause,
    #[error("a certificate field or record is malformed")]
    Certificate,
    #[error("a certificate count overflowed")]
    Overflow,
    #[error("the certificate needs {required} records, above the limit {maximum}")]
    EvidenceLimit { required: u64, maximum: u64 },
    #[error(transparent)]
    Io(#[from] std::io::Error),
}

/// Reusable iterative workspace. Construction allocates; repeated solves do not.
#[derive(Debug)]
pub struct ResidualHittingWorkspace {
    chosen: Box<[u64]>,
    branches: Box<[u64]>,
    entered: Box<[bool]>,
}

impl ResidualHittingWorkspace {
    pub fn new(maximum_budget: u32) -> Self {
        let depth = maximum_budget as usize + 1;
        Self {
            chosen: vec![0; depth].into_boxed_slice(),
            branches: vec![0; depth].into_boxed_slice(),
            entered: vec![false; depth].into_boxed_slice(),
        }
    }

    /// Decide whether at most `budget` available elements hit every clause.
    ///
    /// The kernel branches on a shortest currently unhit clause. It performs
    /// no recursion and no allocation after workspace construction.
    pub fn is_hittable(
        &mut self,
        clauses: &[u64],
        available: u64,
        budget: u32,
    ) -> Result<bool, ResidualHittingError> {
        if budget as usize >= self.chosen.len() {
            return Err(ResidualHittingError::Budget);
        }
        if clauses.iter().any(|&clause| clause & !available != 0) {
            return Err(ResidualHittingError::Clause);
        }
        self.entered[..=budget as usize].fill(false);
        self.chosen[0] = 0;
        let mut depth = 0_usize;
        loop {
            if !self.entered[depth] {
                let mut best = None;
                for &clause in clauses {
                    if clause & self.chosen[depth] == 0
                        && best.is_none_or(|prior: u64| clause.count_ones() < prior.count_ones())
                    {
                        best = Some(clause);
                    }
                }
                let Some(branch) = best else {
                    return Ok(true);
                };
                if branch == 0 || depth == budget as usize {
                    if depth == 0 {
                        return Ok(false);
                    }
                    depth -= 1;
                    continue;
                }
                self.branches[depth] = branch;
                self.entered[depth] = true;
            }
            let branch = self.branches[depth];
            if branch == 0 {
                self.entered[depth] = false;
                if depth == 0 {
                    return Ok(false);
                }
                depth -= 1;
                continue;
            }
            let bit = branch & branch.wrapping_neg();
            self.branches[depth] ^= bit;
            self.chosen[depth + 1] = self.chosen[depth] | bit;
            depth += 1;
            self.entered[depth] = false;
        }
    }

    /// Stream a complete negative certificate, or return `None` if hittable.
    ///
    /// The certificate lists every `k`-subset of the available universe, where
    /// `k=min(budget, |available|)`, together with one clause it misses. Every
    /// smaller hitting set extends to a `k`-subset, so this is complete. The
    /// exact record count is checked against `maximum_records` before any
    /// output is written.
    pub fn write_refutation<W: Write>(
        &mut self,
        clauses: &[u64],
        available: u64,
        budget: u32,
        maximum_records: u64,
        output: &mut W,
    ) -> Result<Option<u64>, ResidualHittingError> {
        if self.is_hittable(clauses, available, budget)? {
            return Ok(None);
        }
        let empty_clause = clauses.iter().position(|&clause| clause == 0);
        let width = available.count_ones();
        let cardinality = empty_clause.map_or_else(|| budget.min(width), |_| 0);
        let count = empty_clause.map_or_else(|| binomial(width, cardinality), |_| Ok(1))?;
        if count > maximum_records {
            return Err(ResidualHittingError::EvidenceLimit {
                required: count,
                maximum: maximum_records,
            });
        }
        output.write_all(&MAGIC)?;
        output.write_all(&available.to_le_bytes())?;
        output.write_all(&budget.to_le_bytes())?;
        output.write_all(&cardinality.to_le_bytes())?;
        output.write_all(&count.to_le_bytes())?;
        if let Some(clause) = empty_clause {
            let clause = u32::try_from(clause).map_err(|_| ResidualHittingError::Overflow)?;
            output.write_all(&clause.to_le_bytes())?;
            return Ok(Some(1));
        }
        for_each_combination(available, cardinality, |chosen| {
            let clause = clauses
                .iter()
                .position(|clause| clause & chosen == 0)
                .ok_or(ResidualHittingError::Certificate)?;
            let clause = u32::try_from(clause).map_err(|_| ResidualHittingError::Overflow)?;
            output.write_all(&clause.to_le_bytes())?;
            Ok(())
        })?;
        Ok(Some(count))
    }
}

/// Independently replay a streamed negative certificate without retaining it.
pub fn verify_residual_hitting_refutation<R: Read>(
    clauses: &[u64],
    available: u64,
    budget: u32,
    input: &mut R,
) -> Result<u64, ResidualHittingError> {
    if clauses.iter().any(|&clause| clause & !available != 0) {
        return Err(ResidualHittingError::Clause);
    }
    let mut magic = [0_u8; 8];
    input.read_exact(&mut magic)?;
    if magic != MAGIC || read_u64(input)? != available || read_u32(input)? != budget {
        return Err(ResidualHittingError::Certificate);
    }
    let cardinality = read_u32(input)?;
    let empty_clause = clauses.contains(&0);
    let expected_cardinality = if empty_clause {
        0
    } else {
        budget.min(available.count_ones())
    };
    let count = read_u64(input)?;
    if cardinality != expected_cardinality
        || count
            != if empty_clause {
                1
            } else {
                binomial(available.count_ones(), cardinality)?
            }
    {
        return Err(ResidualHittingError::Certificate);
    }
    let mut seen = 0_u64;
    for_each_combination(available, cardinality, |expected| {
        let clause = usize::try_from(read_u32(input)?)
            .ok()
            .and_then(|index| clauses.get(index))
            .ok_or(ResidualHittingError::Certificate)?;
        if (empty_clause && *clause != 0) || (!empty_clause && clause & expected != 0) {
            return Err(ResidualHittingError::Certificate);
        }
        seen += 1;
        Ok(())
    })?;
    let mut trailing = [0_u8; 1];
    if input.read(&mut trailing)? != 0 || seen != count {
        return Err(ResidualHittingError::Certificate);
    }
    Ok(seen)
}

fn for_each_combination(
    available: u64,
    cardinality: u32,
    mut visit: impl FnMut(u64) -> Result<(), ResidualHittingError>,
) -> Result<(), ResidualHittingError> {
    let width = available.count_ones();
    if cardinality == 0 {
        return visit(0);
    }
    if cardinality == 64 {
        return visit(available);
    }
    let mut compressed = (1_u64 << cardinality) - 1;
    loop {
        visit(deposit(compressed, available))?;
        let low = compressed & compressed.wrapping_neg();
        let high = compressed.wrapping_add(low);
        if high == 0 {
            break;
        }
        let next = high | (((high ^ compressed) / low) >> 2);
        if width < 64 && next >> width != 0 {
            break;
        }
        compressed = next;
    }
    Ok(())
}

fn deposit(mut source: u64, mut mask: u64) -> u64 {
    let mut output = 0_u64;
    while source != 0 {
        let destination = mask & mask.wrapping_neg();
        if source & 1 != 0 {
            output |= destination;
        }
        source >>= 1;
        mask ^= destination;
    }
    output
}

fn binomial(n: u32, k: u32) -> Result<u64, ResidualHittingError> {
    let k = k.min(n - k);
    let mut value = 1_u128;
    for index in 0..k {
        value = value * u128::from(n - index) / u128::from(index + 1);
    }
    u64::try_from(value).map_err(|_| ResidualHittingError::Overflow)
}

fn read_u32(input: &mut impl Read) -> Result<u32, ResidualHittingError> {
    let mut bytes = [0_u8; 4];
    input.read_exact(&mut bytes)?;
    Ok(u32::from_le_bytes(bytes))
}

fn read_u64(input: &mut impl Read) -> Result<u64, ResidualHittingError> {
    let mut bytes = [0_u8; 8];
    input.read_exact(&mut bytes)?;
    Ok(u64::from_le_bytes(bytes))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn iterative_solver_and_streamed_refutation_cover_the_bounded_domain() {
        let clauses = [1_u64, 2, 4, 8];
        let mut workspace = ResidualHittingWorkspace::new(4);
        assert!(!workspace.is_hittable(&clauses, 0xf, 3).unwrap());
        assert!(workspace.is_hittable(&clauses, 0xf, 4).unwrap());

        let mut proof = Vec::new();
        assert_eq!(
            workspace
                .write_refutation(&clauses, 0xf, 3, 4, &mut proof)
                .unwrap(),
            Some(4)
        );
        assert_eq!(
            verify_residual_hitting_refutation(&clauses, 0xf, 3, &mut &proof[..]).unwrap(),
            4
        );
        assert_eq!(proof.len(), 32 + 4 * 4);

        let mut limited = Vec::new();
        assert!(matches!(
            workspace.write_refutation(&clauses, 0xf, 3, 3, &mut limited),
            Err(ResidualHittingError::EvidenceLimit {
                required: 4,
                maximum: 3
            })
        ));
        assert!(limited.is_empty());

        let last = proof.len() - 1;
        proof[last] ^= 1;
        assert!(verify_residual_hitting_refutation(&clauses, 0xf, 3, &mut &proof[..]).is_err());
    }

    #[test]
    fn empty_clause_is_an_immediate_refutation() {
        let clauses = [0_u64];
        let mut workspace = ResidualHittingWorkspace::new(8);
        assert!(!workspace.is_hittable(&clauses, 0xffff, 8).unwrap());
        let mut proof = Vec::new();
        assert_eq!(
            workspace
                .write_refutation(&clauses, 0xffff, 8, 1, &mut proof)
                .unwrap(),
            Some(1)
        );
        assert_eq!(
            verify_residual_hitting_refutation(&clauses, 0xffff, 8, &mut &proof[..]).unwrap(),
            1
        );
        assert_eq!(proof.len(), 36);
    }

    #[test]
    fn iterative_solver_matches_bruteforce_on_every_four_element_hypergraph() {
        let mut workspace = ResidualHittingWorkspace::new(4);
        for family in 0_u64..1_u64 << 16 {
            let clauses = (0_u64..16)
                .filter(|clause| family >> clause & 1 != 0)
                .collect::<Vec<_>>();
            for budget in 0..=4 {
                let brute = (0_u64..16).any(|chosen| {
                    chosen.count_ones() <= budget
                        && clauses.iter().all(|clause| clause & chosen != 0)
                });
                assert_eq!(
                    workspace.is_hittable(&clauses, 0xf, budget).unwrap(),
                    brute,
                    "family={family:#x} budget={budget}"
                );
            }
        }
    }
}
