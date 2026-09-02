//! Structural interpretation of evolved q29 pair-target feature cycles.

use serde::Serialize;
use thiserror::Error;

use crate::g41_q29_evolve::Q29_COSETS;
use crate::mask_cycle_proof::ComplementCycleProof;

const MODULUS: usize = 29;

#[derive(Clone, Debug, PartialEq, Eq, Serialize)]
pub struct G41Q29CosetCycleProof {
    pub modulus: u8,
    pub coset_size: u8,
    pub generator: u8,
    pub class_action: [u8; 7],
    pub canonical_cycle: [u8; 7],
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q29CosetCycleError {
    #[error("q29 coset-cycle semantics are invalid")]
    SemanticMismatch,
}

fn validate_partition() -> Result<[u8; MODULUS], G41Q29CosetCycleError> {
    let mut class_of = [u8::MAX; MODULUS];
    for (class, coset) in Q29_COSETS.iter().enumerate() {
        for &residue in coset {
            if residue == 0 || residue >= MODULUS || class_of[residue] != u8::MAX {
                return Err(G41Q29CosetCycleError::SemanticMismatch);
            }
            class_of[residue] = class as u8;
        }
    }
    if class_of[1..].contains(&u8::MAX) {
        return Err(G41Q29CosetCycleError::SemanticMismatch);
    }
    Ok(class_of)
}

fn action_for(
    generator: usize,
    class_of: &[u8; MODULUS],
) -> Result<[u8; 7], G41Q29CosetCycleError> {
    if generator == 0 || generator >= MODULUS {
        return Err(G41Q29CosetCycleError::SemanticMismatch);
    }
    let mut action = [u8::MAX; 7];
    for (class, coset) in Q29_COSETS.iter().enumerate() {
        let target = class_of[(generator * coset[0]) % MODULUS];
        if coset
            .iter()
            .any(|&residue| class_of[(generator * residue) % MODULUS] != target)
        {
            return Err(G41Q29CosetCycleError::SemanticMismatch);
        }
        action[class] = target;
    }
    let mut sorted = action;
    sorted.sort_unstable();
    if sorted != [0, 1, 2, 3, 4, 5, 6] {
        return Err(G41Q29CosetCycleError::SemanticMismatch);
    }
    Ok(action)
}

pub fn synthesize_g41_q29_coset_cycle(
    mask_cycle: &ComplementCycleProof,
) -> Result<G41Q29CosetCycleProof, G41Q29CosetCycleError> {
    if mask_cycle.width != 7 || mask_cycle.canonical_cycle.len() != 7 {
        return Err(G41Q29CosetCycleError::SemanticMismatch);
    }
    let class_of = validate_partition()?;
    let mut expected = [0_u8; 7];
    expected.copy_from_slice(&mask_cycle.canonical_cycle);
    for generator in 2..MODULUS {
        let action = action_for(generator, &class_of)?;
        let mut cycle = [0_u8; 7];
        for index in 1..7 {
            cycle[index] = action[usize::from(cycle[index - 1])];
        }
        if cycle == expected && action[usize::from(cycle[6])] == 0 {
            let proof = G41Q29CosetCycleProof {
                modulus: MODULUS as u8,
                coset_size: 4,
                generator: generator as u8,
                class_action: action,
                canonical_cycle: cycle,
                provenance: "independent q29 coset-action proof; all 28 nonzero residues form seven disjoint four-element classes, multiplication by the synthesized least unit maps each whole class to one class, and its class permutation is exactly the evolved complement cycle",
            };
            verify_g41_q29_coset_cycle(&proof, mask_cycle)?;
            return Ok(proof);
        }
    }
    Err(G41Q29CosetCycleError::SemanticMismatch)
}

pub fn verify_g41_q29_coset_cycle(
    proof: &G41Q29CosetCycleProof,
    mask_cycle: &ComplementCycleProof,
) -> Result<(), G41Q29CosetCycleError> {
    if proof.modulus != MODULUS as u8
        || proof.coset_size != 4
        || mask_cycle.width != 7
        || mask_cycle.canonical_cycle.as_ref() != proof.canonical_cycle
    {
        return Err(G41Q29CosetCycleError::SemanticMismatch);
    }
    let class_of = validate_partition()?;
    let action = action_for(usize::from(proof.generator), &class_of)?;
    if action != proof.class_action {
        return Err(G41Q29CosetCycleError::SemanticMismatch);
    }
    for index in 0..7 {
        if action[usize::from(proof.canonical_cycle[index])]
            != proof.canonical_cycle[(index + 1) % 7]
        {
            return Err(G41Q29CosetCycleError::SemanticMismatch);
        }
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::mask_cycle_proof::synthesize_complement_cycle_proof;

    #[test]
    fn evolved_cycle_is_multiplication_by_three_on_q29_classes() {
        let masks = [47_u16, 55, 91, 93, 109, 118, 122];
        let mask_proof = synthesize_complement_cycle_proof(7, &masks).unwrap();
        let proof = synthesize_g41_q29_coset_cycle(&mask_proof).unwrap();
        assert_eq!(proof.generator, 3);
        assert_eq!(proof.canonical_cycle, [0, 2, 5, 1, 4, 6, 3]);
        verify_g41_q29_coset_cycle(&proof, &mask_proof).unwrap();

        let mut forged = proof.clone();
        forged.generator = 2;
        assert!(verify_g41_q29_coset_cycle(&forged, &mask_proof).is_err());
    }
}
