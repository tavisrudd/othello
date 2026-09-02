//! Exact aggregate-signature pair graph for reusable q29 transposition tables.

use serde::Serialize;
use thiserror::Error;

use crate::g41_joint_quotient_search::G41JointQuotientWitness;
use crate::g41_q29_exact_tablebase::{g41_q29_slot_aggregate_signature, G41Q29ExactTablebaseError};

const MAX_WITNESSES: usize = 1 << 22;

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord, Serialize)]
pub struct G41Q29AggregatePair {
    pub signatures: [[u8; 4]; 2],
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord, Serialize)]
pub struct G41Q29AggregatePairEdge {
    pub ac_pair: u16,
    pub bd_pair: u16,
    pub representative_witness: u32,
    pub representative_root_id: u32,
    pub witnessed_interfaces: u32,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29AggregatePairGraphReport {
    pub interfaces: u32,
    pub aggregate_signatures: u16,
    pub ac_pairs: u16,
    pub bd_pairs: u16,
    pub edges: u16,
    pub provenance: &'static str,
}

#[derive(Serialize)]
pub struct G41Q29AggregatePairGraph {
    pub report: G41Q29AggregatePairGraphReport,
    pub signatures: Box<[[u8; 4]]>,
    pub ac_pairs: Box<[G41Q29AggregatePair]>,
    pub bd_pairs: Box<[G41Q29AggregatePair]>,
    pub edges: Box<[G41Q29AggregatePairEdge]>,
}

#[derive(Debug, Error)]
pub enum G41Q29AggregatePairGraphError {
    #[error("q29 aggregate-pair graph resource bound exceeded")]
    StateBudget,
    #[error("q29 aggregate-pair graph semantic invariant failed")]
    SemanticMismatch,
    #[error(transparent)]
    Tablebase(#[from] G41Q29ExactTablebaseError),
}

fn signature(
    witness: &G41JointQuotientWitness,
    block: usize,
) -> Result<[u8; 4], G41Q29AggregatePairGraphError> {
    Ok(g41_q29_slot_aggregate_signature(
        witness.masks[block],
        witness.digits[block],
    )?)
}

fn row_sum(signature: [u8; 4]) -> u16 {
    u16::from(signature[0])
        + 4 * u16::from(signature[1])
        + 4 * u16::from(signature[2])
        + 12 * u16::from(signature[3])
}

fn pair(
    witness: &G41JointQuotientWitness,
    blocks: [usize; 2],
) -> Result<G41Q29AggregatePair, G41Q29AggregatePairGraphError> {
    let mut signatures = [
        signature(witness, blocks[0])?,
        signature(witness, blocks[1])?,
    ];
    signatures.sort_unstable();
    Ok(G41Q29AggregatePair { signatures })
}

pub fn compile_g41_q29_aggregate_pair_graph(
    witnesses: &[G41JointQuotientWitness],
) -> Result<G41Q29AggregatePairGraph, G41Q29AggregatePairGraphError> {
    if witnesses.is_empty() || witnesses.len() > MAX_WITNESSES {
        return Err(G41Q29AggregatePairGraphError::StateBudget);
    }
    let mut raw = Vec::with_capacity(witnesses.len());
    let mut signatures = Vec::with_capacity(4 * witnesses.len());
    let mut ac_pairs = Vec::with_capacity(witnesses.len());
    let mut bd_pairs = Vec::with_capacity(witnesses.len());
    for (index, witness) in witnesses.iter().enumerate() {
        if witness.masks
            != std::array::from_fn(|block| ((witness.root_id >> (6 * block)) & 63) as u8)
        {
            return Err(G41Q29AggregatePairGraphError::SemanticMismatch);
        }
        let block_signatures = [
            signature(witness, 0)?,
            signature(witness, 1)?,
            signature(witness, 2)?,
            signature(witness, 3)?,
        ];
        signatures.extend_from_slice(&block_signatures);
        if row_sum(block_signatures[0]) != 260
            || block_signatures[1..]
                .iter()
                .any(|&value| row_sum(value) != 261)
        {
            return Err(G41Q29AggregatePairGraphError::SemanticMismatch);
        }
        let ac = pair(witness, [0, 2])?;
        let bd = pair(witness, [1, 3])?;
        ac_pairs.push(ac);
        bd_pairs.push(bd);
        raw.push((ac, bd, index as u32, witness.root_id));
    }
    signatures.sort_unstable();
    signatures.dedup();
    ac_pairs.sort_unstable();
    ac_pairs.dedup();
    bd_pairs.sort_unstable();
    bd_pairs.dedup();
    if signatures.len() > u16::MAX as usize
        || ac_pairs.len() > u16::MAX as usize
        || bd_pairs.len() > u16::MAX as usize
    {
        return Err(G41Q29AggregatePairGraphError::StateBudget);
    }
    let mut edges = Vec::with_capacity(raw.len());
    for (ac, bd, witness, root_id) in raw {
        edges.push(G41Q29AggregatePairEdge {
            ac_pair: ac_pairs
                .binary_search(&ac)
                .map_err(|_| G41Q29AggregatePairGraphError::SemanticMismatch)?
                as u16,
            bd_pair: bd_pairs
                .binary_search(&bd)
                .map_err(|_| G41Q29AggregatePairGraphError::SemanticMismatch)?
                as u16,
            representative_witness: witness,
            representative_root_id: root_id,
            witnessed_interfaces: 1,
        });
    }
    edges.sort_unstable_by_key(|edge| (edge.ac_pair, edge.bd_pair));
    let mut unique = Vec::<G41Q29AggregatePairEdge>::with_capacity(edges.len());
    for edge in edges {
        if let Some(previous) = unique.last_mut() {
            if (previous.ac_pair, previous.bd_pair) == (edge.ac_pair, edge.bd_pair) {
                previous.witnessed_interfaces = previous
                    .witnessed_interfaces
                    .checked_add(1)
                    .ok_or(G41Q29AggregatePairGraphError::StateBudget)?;
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
        unique.push(edge);
    }
    if unique.len() > u16::MAX as usize {
        return Err(G41Q29AggregatePairGraphError::StateBudget);
    }
    Ok(G41Q29AggregatePairGraph {
        report: G41Q29AggregatePairGraphReport {
            interfaces: witnesses.len() as u32,
            aggregate_signatures: signatures.len() as u16,
            ac_pairs: ac_pairs.len() as u16,
            bd_pairs: bd_pairs.len() as u16,
            edges: unique.len() as u16,
            provenance: "exact commutative aggregate-signature pair graph over the sealed g41 interface witnesses; four-block domains are edges between reusable A/C and B/D q29 transposition-table nodes, and every edge retains a source witness/root for independent replay",
        },
        signatures: signatures.into_boxed_slice(),
        ac_pairs: ac_pairs.into_boxed_slice(),
        bd_pairs: bd_pairs.into_boxed_slice(),
        edges: unique.into_boxed_slice(),
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn aggregate_graph_deduplicates_pair_edges_and_retains_source_multiplicity() {
        let first = G41JointQuotientWitness {
            root_id: 348_244,
            masks: [20, 1, 21, 1],
            digits: [2_215_340, 2_203_361, 1_957_347, 2_218_467],
        };
        let graph = compile_g41_q29_aggregate_pair_graph(&[first, first]).unwrap();
        assert_eq!(graph.report.ac_pairs, 1);
        assert_eq!(graph.report.bd_pairs, 1);
        assert_eq!(graph.report.edges, 1);
        assert_eq!(graph.edges[0].witnessed_interfaces, 2);
        assert_eq!(graph.edges[0].representative_witness, 0);
    }
}
