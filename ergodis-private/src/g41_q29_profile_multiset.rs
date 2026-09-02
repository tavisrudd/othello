//! Canonical four-profile multisets for the g41 aggregate pair graph.

use serde::Serialize;
use thiserror::Error;

use crate::g41_joint_quotient_search::G41JointQuotientWitness;
use crate::g41_q29_aggregate_pair_graph::{
    compile_g41_q29_aggregate_pair_graph, G41Q29AggregatePairGraphError,
    G41Q29AggregatePairGraphReport,
};

pub const A_CLASS: u8 = 0;
pub const B1_CLASS: u8 = 1;
pub const B5_CLASS: u8 = 2;
pub const C_CLASS: u8 = 3;

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q29ProfileMultisetReport {
    pub graph: G41Q29AggregatePairGraphReport,
    pub canonical_multisets: [[u8; 4]; 2],
    pub multiset_edges: [u16; 2],
    pub homogeneous_pairing_edges: [u16; 2],
    pub crossed_pairing_edges: [u16; 2],
    pub provenance: &'static str,
}

#[derive(Debug, Error)]
pub enum G41Q29ProfileMultisetError {
    #[error("aggregate signature escaped the four exact-profile classes")]
    UnknownClass,
    #[error("aggregate graph edge escaped the two canonical four-profile multisets")]
    UnknownMultiset,
    #[error("aggregate graph edge has a noncanonical pair partition")]
    UnknownPairing,
    #[error("profile-multiset count overflow")]
    CountOverflow,
    #[error(transparent)]
    Graph(#[from] G41Q29AggregatePairGraphError),
}

pub fn g41_q29_profile_class(signature: [u8; 4]) -> Option<u8> {
    match signature[0] {
        8 => Some(A_CLASS),
        1 | 17 => Some(B1_CLASS),
        5 | 13 => Some(B5_CLASS),
        9 => Some(C_CLASS),
        _ => None,
    }
}

fn pair_classes(signatures: [[u8; 4]; 2]) -> Result<[u8; 2], G41Q29ProfileMultisetError> {
    let mut classes = [
        g41_q29_profile_class(signatures[0]).ok_or(G41Q29ProfileMultisetError::UnknownClass)?,
        g41_q29_profile_class(signatures[1]).ok_or(G41Q29ProfileMultisetError::UnknownClass)?,
    ];
    classes.sort_unstable();
    Ok(classes)
}

pub fn canonical_g41_q29_profile_multiset(first: [u8; 2], second: [u8; 2]) -> [u8; 4] {
    let mut classes = [first[0], first[1], second[0], second[1]];
    classes.sort_unstable();
    classes
}

pub fn compile_g41_q29_profile_multiset_report(
    witnesses: &[G41JointQuotientWitness],
) -> Result<G41Q29ProfileMultisetReport, G41Q29ProfileMultisetError> {
    let graph = compile_g41_q29_aggregate_pair_graph(witnesses)?;
    let canonical_multisets = [
        [A_CLASS, B1_CLASS, B1_CLASS, C_CLASS],
        [A_CLASS, B5_CLASS, B5_CLASS, C_CLASS],
    ];
    let mut multiset_edges = [0_u16; 2];
    let mut homogeneous_pairing_edges = [0_u16; 2];
    let mut crossed_pairing_edges = [0_u16; 2];
    for edge in &graph.edges {
        let first = pair_classes(graph.ac_pairs[usize::from(edge.ac_pair)].signatures)?;
        let second = pair_classes(graph.bd_pairs[usize::from(edge.bd_pair)].signatures)?;
        let multiset = canonical_g41_q29_profile_multiset(first, second);
        let multiset_index = canonical_multisets
            .iter()
            .position(|&candidate| candidate == multiset)
            .ok_or(G41Q29ProfileMultisetError::UnknownMultiset)?;
        let b_class = canonical_multisets[multiset_index][1];
        let homogeneous = (first == [A_CLASS, C_CLASS] && second == [b_class, b_class])
            || (second == [A_CLASS, C_CLASS] && first == [b_class, b_class]);
        let crossed = (first == [A_CLASS, b_class] && second == [b_class, C_CLASS])
            || (second == [A_CLASS, b_class] && first == [b_class, C_CLASS]);
        if homogeneous == crossed {
            return Err(G41Q29ProfileMultisetError::UnknownPairing);
        }
        multiset_edges[multiset_index] = multiset_edges[multiset_index]
            .checked_add(1)
            .ok_or(G41Q29ProfileMultisetError::CountOverflow)?;
        let target = if homogeneous {
            &mut homogeneous_pairing_edges[multiset_index]
        } else {
            &mut crossed_pairing_edges[multiset_index]
        };
        *target = target
            .checked_add(1)
            .ok_or(G41Q29ProfileMultisetError::CountOverflow)?;
    }
    if multiset_edges.contains(&0)
        || homogeneous_pairing_edges.contains(&0)
        || crossed_pairing_edges.contains(&0)
        || multiset_edges
            .iter()
            .map(|&count| usize::from(count))
            .sum::<usize>()
            != graph.edges.len()
    {
        return Err(G41Q29ProfileMultisetError::UnknownMultiset);
    }
    Ok(G41Q29ProfileMultisetReport {
        graph: graph.report,
        canonical_multisets,
        multiset_edges,
        homogeneous_pairing_edges,
        crossed_pairing_edges,
        provenance: "exact canonicalization of every sealed aggregate-pair edge in the commutative monoid of four block profiles; pair partition is erased by sorting the four typed profile classes, leaving only A+C+B1+B1 and A+C+B5+B5; original homogeneous/crossed counts remain diagnostic provenance",
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn canonical_multiset_erases_pair_partition() {
        assert_eq!(
            canonical_g41_q29_profile_multiset([A_CLASS, C_CLASS], [B1_CLASS, B1_CLASS]),
            canonical_g41_q29_profile_multiset([A_CLASS, B1_CLASS], [B1_CLASS, C_CLASS])
        );
        assert_eq!(
            canonical_g41_q29_profile_multiset([A_CLASS, C_CLASS], [B5_CLASS, B5_CLASS]),
            canonical_g41_q29_profile_multiset([A_CLASS, B5_CLASS], [B5_CLASS, C_CLASS])
        );
    }

    #[test]
    fn signature_class_is_complement_canonical_for_middle_classes() {
        assert_eq!(g41_q29_profile_class([1, 0, 0, 0]), Some(B1_CLASS));
        assert_eq!(g41_q29_profile_class([17, 0, 0, 0]), Some(B1_CLASS));
        assert_eq!(g41_q29_profile_class([5, 0, 0, 0]), Some(B5_CLASS));
        assert_eq!(g41_q29_profile_class([13, 0, 0, 0]), Some(B5_CLASS));
        assert_eq!(g41_q29_profile_class([0, 0, 0, 0]), None);
    }
}
