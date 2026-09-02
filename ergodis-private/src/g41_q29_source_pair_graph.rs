//! Exact source-pair graph beneath the aggregate q29 pair-target quotient.

use serde::{Deserialize, Serialize};
use thiserror::Error;

use crate::g41_joint_quotient_search::G41JointQuotientWitness;
use crate::g41_q29_exact_tablebase::{
    canonical_g41_q29_block_spec, translation_canonical_g41_q29_block_spec,
    G41Q29ExactTablebaseError,
};

const MAX_WITNESSES: usize = 1 << 22;

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord, Deserialize, Serialize)]
pub struct G41Q29CanonicalBlockSpec {
    pub mask: u8,
    pub digits: u32,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord, Deserialize, Serialize)]
pub struct G41Q29SourcePair {
    pub blocks: [G41Q29CanonicalBlockSpec; 2],
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord, Deserialize, Serialize)]
pub struct G41Q29SourcePairEdge {
    pub ac_pair: u32,
    pub bd_pair: u32,
    pub representative_witness: u32,
    pub representative_root_id: u32,
    pub witnessed_interfaces: u32,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29SourcePairGraphReport {
    pub interfaces: u32,
    pub ac_pairs: u32,
    pub bd_pairs: u32,
    pub edges: u32,
    pub provenance: &'static str,
}

#[derive(Serialize)]
pub struct G41Q29SourcePairGraph {
    pub report: G41Q29SourcePairGraphReport,
    pub ac_pairs: Box<[G41Q29SourcePair]>,
    pub bd_pairs: Box<[G41Q29SourcePair]>,
    pub edges: Box<[G41Q29SourcePairEdge]>,
}

#[derive(Debug, Error)]
pub enum G41Q29SourcePairGraphError {
    #[error("q29 source-pair graph resource bound exceeded")]
    StateBudget,
    #[error("q29 source-pair graph semantic invariant failed")]
    SemanticMismatch,
    #[error(transparent)]
    Tablebase(#[from] G41Q29ExactTablebaseError),
}

fn canonical(
    mask: u8,
    digits: u32,
) -> Result<G41Q29CanonicalBlockSpec, G41Q29SourcePairGraphError> {
    let (mask, digits, _) = canonical_g41_q29_block_spec(mask, digits)?;
    Ok(G41Q29CanonicalBlockSpec { mask, digits })
}

fn translation_canonical(
    mask: u8,
    digits: u32,
) -> Result<G41Q29CanonicalBlockSpec, G41Q29SourcePairGraphError> {
    let (mask, digits) = translation_canonical_g41_q29_block_spec(mask, digits)?;
    Ok(G41Q29CanonicalBlockSpec { mask, digits })
}

fn source_pair(
    witness: &G41JointQuotientWitness,
    positions: [usize; 2],
) -> Result<G41Q29SourcePair, G41Q29SourcePairGraphError> {
    let mut blocks = [
        canonical(witness.masks[positions[0]], witness.digits[positions[0]])?,
        canonical(witness.masks[positions[1]], witness.digits[positions[1]])?,
    ];
    blocks.sort_unstable();
    Ok(G41Q29SourcePair { blocks })
}

fn translation_source_pair(
    witness: &G41JointQuotientWitness,
    positions: [usize; 2],
) -> Result<G41Q29SourcePair, G41Q29SourcePairGraphError> {
    let mut blocks = [
        translation_canonical(witness.masks[positions[0]], witness.digits[positions[0]])?,
        translation_canonical(witness.masks[positions[1]], witness.digits[positions[1]])?,
    ];
    blocks.sort_unstable();
    Ok(G41Q29SourcePair { blocks })
}

fn compile_graph(
    witnesses: &[G41JointQuotientWitness],
    pair_extractor: fn(
        &G41JointQuotientWitness,
        [usize; 2],
    ) -> Result<G41Q29SourcePair, G41Q29SourcePairGraphError>,
    provenance: &'static str,
) -> Result<G41Q29SourcePairGraph, G41Q29SourcePairGraphError> {
    if witnesses.is_empty() || witnesses.len() > MAX_WITNESSES {
        return Err(G41Q29SourcePairGraphError::StateBudget);
    }
    let mut raw = Vec::with_capacity(witnesses.len());
    let mut ac_pairs = Vec::with_capacity(witnesses.len());
    let mut bd_pairs = Vec::with_capacity(witnesses.len());
    for (index, witness) in witnesses.iter().enumerate() {
        if witness.masks
            != std::array::from_fn(|block| ((witness.root_id >> (6 * block)) & 63) as u8)
        {
            return Err(G41Q29SourcePairGraphError::SemanticMismatch);
        }
        let ac = pair_extractor(witness, [0, 2])?;
        let bd = pair_extractor(witness, [1, 3])?;
        ac_pairs.push(ac);
        bd_pairs.push(bd);
        raw.push((ac, bd, index as u32, witness.root_id));
    }
    ac_pairs.sort_unstable();
    ac_pairs.dedup();
    bd_pairs.sort_unstable();
    bd_pairs.dedup();
    let mut edges = Vec::with_capacity(raw.len());
    for (ac, bd, witness, root_id) in raw {
        let ac_pair = ac_pairs
            .binary_search(&ac)
            .map_err(|_| G41Q29SourcePairGraphError::SemanticMismatch)?
            as u32;
        let bd_pair = bd_pairs
            .binary_search(&bd)
            .map_err(|_| G41Q29SourcePairGraphError::SemanticMismatch)?
            as u32;
        edges.push(G41Q29SourcePairEdge {
            ac_pair,
            bd_pair,
            representative_witness: witness,
            representative_root_id: root_id,
            witnessed_interfaces: 1,
        });
    }
    edges.sort_unstable_by_key(|edge| (edge.ac_pair, edge.bd_pair));
    let mut unique_edges = Vec::<G41Q29SourcePairEdge>::with_capacity(edges.len());
    for edge in edges {
        if let Some(previous) = unique_edges.last_mut() {
            if (previous.ac_pair, previous.bd_pair) == (edge.ac_pair, edge.bd_pair) {
                previous.witnessed_interfaces = previous
                    .witnessed_interfaces
                    .checked_add(1)
                    .ok_or(G41Q29SourcePairGraphError::StateBudget)?;
                if (edge.representative_witness, edge.representative_root_id)
                    < (
                        previous.representative_witness,
                        previous.representative_root_id,
                    )
                {
                    previous.representative_witness = edge.representative_witness;
                    previous.representative_root_id = edge.representative_root_id;
                }
                continue;
            }
        }
        unique_edges.push(edge);
    }
    Ok(G41Q29SourcePairGraph {
        report: G41Q29SourcePairGraphReport {
            interfaces: witnesses.len() as u32,
            ac_pairs: ac_pairs.len() as u32,
            bd_pairs: bd_pairs.len() as u32,
            edges: unique_edges.len() as u32,
            provenance,
        },
        ac_pairs: ac_pairs.into_boxed_slice(),
        bd_pairs: bd_pairs.into_boxed_slice(),
        edges: unique_edges.into_boxed_slice(),
    })
}

pub fn compile_g41_q29_source_pair_graph(
    witnesses: &[G41JointQuotientWitness],
) -> Result<G41Q29SourcePairGraph, G41Q29SourcePairGraphError> {
    compile_graph(
        witnesses,
        source_pair,
        "exact commutative A+C/B+D source-pair quotient of the sealed g41 interface witnesses; canonical block complementation preserves q29 defects, every edge retains a representative original witness index/root, and no aggregate or pair-target result authorizes exclusion without exact source replay",
    )
}

pub fn compile_g41_q29_translation_source_pair_graph(
    witnesses: &[G41JointQuotientWitness],
) -> Result<G41Q29SourcePairGraph, G41Q29SourcePairGraphError> {
    compile_graph(
        witnesses,
        translation_source_pair,
        "exact commutative A+C/B+D source-pair quotient of the sealed g41 interface witnesses under independent block complementation and translation by 261; the typed q174 translation proof establishes each block action, every edge retains a representative original witness index/root, and negative authority still requires exact source replay",
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn graph_deduplicates_commutative_pairs_and_retains_multiplicity() {
        let first = G41JointQuotientWitness {
            root_id: 1 | (2 << 6) | (3 << 12) | (4 << 18),
            masks: [1, 2, 3, 4],
            digits: [0; 4],
        };
        let second = G41JointQuotientWitness {
            root_id: 3 | (4 << 6) | (1 << 12) | (2 << 18),
            masks: [3, 4, 1, 2],
            digits: [0; 4],
        };
        let graph = compile_g41_q29_source_pair_graph(&[first, second]).unwrap();
        assert_eq!(graph.report.ac_pairs, 1);
        assert_eq!(graph.report.bd_pairs, 1);
        assert_eq!(graph.report.edges, 1);
        assert_eq!(graph.edges[0].witnessed_interfaces, 2);
        assert_eq!(graph.edges[0].representative_witness, 0);
    }

    #[test]
    fn translation_graph_identifies_independently_translated_blocks() {
        let first = G41JointQuotientWitness {
            root_id: 348_244,
            masks: [20, 1, 21, 1],
            digits: [2_215_340, 2_203_361, 1_957_347, 2_218_467],
        };
        let mut second = first;
        for block in 0..4 {
            let translated = crate::g41_q29_exact_tablebase::translate_261_g41_q29_block_spec(
                second.masks[block],
                second.digits[block],
            )
            .unwrap();
            second.masks[block] = translated.0;
            second.digits[block] = translated.1;
        }
        second.root_id = (0..4).fold(0_u32, |root, block| {
            root | (u32::from(second.masks[block]) << (6 * block))
        });
        let graph = compile_g41_q29_translation_source_pair_graph(&[first, second]).unwrap();
        assert_eq!(graph.report.ac_pairs, 1);
        assert_eq!(graph.report.bd_pairs, 1);
        assert_eq!(graph.report.edges, 1);
        assert_eq!(graph.edges[0].witnessed_interfaces, 2);
    }
}
