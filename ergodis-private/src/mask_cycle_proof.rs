//! Compact structural proofs for complements of sufficient feature masks.

use serde::Serialize;
use thiserror::Error;

const MAX_WIDTH: usize = 16;

#[derive(Clone, Debug, PartialEq, Eq, Serialize)]
pub struct ComplementCycleProof {
    pub width: u8,
    pub mask_arity: u8,
    pub positive_masks: Box<[u16]>,
    pub canonical_cycle: Box<[u8]>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum ComplementCycleProofError {
    #[error("mask-cycle proof semantics are invalid")]
    SemanticMismatch,
}

pub fn synthesize_complement_cycle_proof(
    width: usize,
    positive_masks: &[u16],
) -> Result<ComplementCycleProof, ComplementCycleProofError> {
    if !(3..=MAX_WIDTH).contains(&width) || positive_masks.len() != width {
        return Err(ComplementCycleProofError::SemanticMismatch);
    }
    let full = (1_u16 << width) - 1;
    let mut masks = positive_masks.to_vec();
    masks.sort_unstable();
    masks.dedup();
    if masks.len() != width
        || masks
            .iter()
            .any(|&mask| mask & !full != 0 || mask.count_ones() != width as u32 - 2)
    {
        return Err(ComplementCycleProofError::SemanticMismatch);
    }
    let mut adjacency = [[false; MAX_WIDTH]; MAX_WIDTH];
    for &mask in &masks {
        let omitted = full ^ mask;
        let first = omitted.trailing_zeros() as usize;
        let second = (omitted & (omitted - 1)).trailing_zeros() as usize;
        if first >= width || second >= width || first == second || adjacency[first][second] {
            return Err(ComplementCycleProofError::SemanticMismatch);
        }
        adjacency[first][second] = true;
        adjacency[second][first] = true;
    }
    if (0..width).any(|vertex| {
        adjacency[vertex][..width]
            .iter()
            .filter(|&&edge| edge)
            .count()
            != 2
    }) {
        return Err(ComplementCycleProofError::SemanticMismatch);
    }
    let mut cycle = Vec::with_capacity(width);
    let mut previous = usize::MAX;
    let mut current = 0_usize;
    for step in 0..width {
        if cycle.contains(&(current as u8)) {
            return Err(ComplementCycleProofError::SemanticMismatch);
        }
        cycle.push(current as u8);
        let mut neighbors = [usize::MAX; 2];
        let mut cursor = 0;
        for candidate in 0..width {
            if adjacency[current][candidate] {
                neighbors[cursor] = candidate;
                cursor += 1;
            }
        }
        if step == 0 {
            previous = current;
            current = neighbors[0].min(neighbors[1]);
        } else {
            let next = if neighbors[0] == previous {
                neighbors[1]
            } else {
                neighbors[0]
            };
            previous = current;
            current = next;
        }
    }
    if current != 0 {
        return Err(ComplementCycleProofError::SemanticMismatch);
    }
    let proof = ComplementCycleProof {
        width: width as u8,
        mask_arity: (width - 2) as u8,
        positive_masks: masks.into_boxed_slice(),
        canonical_cycle: cycle.into_boxed_slice(),
        provenance: "compact complement-cycle proof; positive fixed-arity masks are unique, every complement is one edge, all vertices have degree two, iterative traversal visits every vertex once, and the canonical cycle closes",
    };
    verify_complement_cycle_proof(&proof)?;
    Ok(proof)
}

pub fn verify_complement_cycle_proof(
    proof: &ComplementCycleProof,
) -> Result<(), ComplementCycleProofError> {
    let width = usize::from(proof.width);
    if !(3..=MAX_WIDTH).contains(&width)
        || usize::from(proof.mask_arity) != width - 2
        || proof.positive_masks.len() != width
        || proof.canonical_cycle.len() != width
        || proof.canonical_cycle.first() != Some(&0)
        || proof.canonical_cycle[1] >= proof.canonical_cycle[width - 1]
    {
        return Err(ComplementCycleProofError::SemanticMismatch);
    }
    let full = (1_u16 << width) - 1;
    let mut expected = Vec::with_capacity(width);
    for edge in 0..width {
        let first = usize::from(proof.canonical_cycle[edge]);
        let second = usize::from(proof.canonical_cycle[(edge + 1) % width]);
        if first >= width || second >= width || first == second {
            return Err(ComplementCycleProofError::SemanticMismatch);
        }
        expected.push(full ^ (1 << first) ^ (1 << second));
    }
    expected.sort_unstable();
    let mut supplied = proof.positive_masks.to_vec();
    supplied.sort_unstable();
    if expected != supplied {
        return Err(ComplementCycleProofError::SemanticMismatch);
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn synthesizes_and_rejects_forged_seven_cycle() {
        let cycle = [0_usize, 2, 5, 1, 4, 6, 3];
        let full = 127_u16;
        let masks: Vec<u16> = (0..7)
            .map(|edge| full ^ (1 << cycle[edge]) ^ (1 << cycle[(edge + 1) % 7]))
            .collect();
        let proof = synthesize_complement_cycle_proof(7, &masks).unwrap();
        assert_eq!(&*proof.canonical_cycle, &[0, 2, 5, 1, 4, 6, 3]);
        verify_complement_cycle_proof(&proof).unwrap();

        let mut forged = proof.clone();
        forged.positive_masks[0] ^= 1;
        assert!(verify_complement_cycle_proof(&forged).is_err());
        let mut missing = masks;
        missing.pop();
        assert!(synthesize_complement_cycle_proof(7, &missing).is_err());
    }
}
