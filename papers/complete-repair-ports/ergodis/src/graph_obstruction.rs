//! Allocation-free scalar obstructions for small simple graphs.
//!
//! The wedge deficit
//! `sum(deg(v)^2) - 2|E| - 6T` is twice the number of induced three-vertex
//! paths.  It vanishes exactly for disjoint unions of cliques, turning a
//! pattern-list check into one reusable scalar theorem kernel.

use thiserror::Error;

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct ClusterGraphCensus {
    pub vertices: u32,
    pub edges: u32,
    pub triangles: u32,
    pub induced_paths_three: u32,
    pub has_odd_component: bool,
}

impl ClusterGraphCensus {
    #[must_use]
    pub fn is_cluster_graph(self) -> bool {
        self.induced_paths_three == 0
    }
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum GraphObstructionError {
    #[error("packed graph order must be at most 64")]
    Order,
    #[error("packed adjacency must be loopless, symmetric, and in range")]
    Adjacency,
    #[error("graph census exceeds its compact representation")]
    Overflow,
}

/// Compute the induced-path obstruction from packed adjacency rows.
///
/// Bit `j` in row `i` denotes the edge `{i,j}`. The kernel performs no
/// allocation and is suitable for repeated feature compilation.
pub fn cluster_graph_census(
    adjacency: &[u64],
) -> Result<ClusterGraphCensus, GraphObstructionError> {
    if adjacency.len() > 64 {
        return Err(GraphObstructionError::Order);
    }
    let order = adjacency.len();
    let valid = if order == 64 {
        u64::MAX
    } else {
        (1_u64 << order) - 1
    };
    for (vertex, &row) in adjacency.iter().enumerate() {
        if row & !valid != 0 || row & (1_u64 << vertex) != 0 {
            return Err(GraphObstructionError::Adjacency);
        }
        let mut neighbours = row;
        while neighbours != 0 {
            let other = neighbours.trailing_zeros() as usize;
            if adjacency[other] & (1_u64 << vertex) == 0 {
                return Err(GraphObstructionError::Adjacency);
            }
            neighbours &= neighbours - 1;
        }
    }

    let degree_sum = adjacency
        .iter()
        .map(|row| u64::from(row.count_ones()))
        .sum::<u64>();
    let degree_square_sum = adjacency
        .iter()
        .map(|row| {
            let degree = u64::from(row.count_ones());
            degree * degree
        })
        .sum::<u64>();
    let edges = degree_sum / 2;
    let mut triangle_edge_incidences = 0_u64;
    for (left, &row) in adjacency.iter().enumerate() {
        let after_left = if left == 63 {
            0
        } else {
            row & (u64::MAX << (left + 1))
        };
        let mut neighbours = after_left;
        while neighbours != 0 {
            let right = neighbours.trailing_zeros() as usize;
            triangle_edge_incidences += u64::from((row & adjacency[right]).count_ones());
            neighbours &= neighbours - 1;
        }
    }
    let triangles = triangle_edge_incidences / 3;
    let closed_wedge_weight = edges
        .checked_mul(2)
        .and_then(|value| {
            triangles
                .checked_mul(6)
                .and_then(|closed| value.checked_add(closed))
        })
        .ok_or(GraphObstructionError::Overflow)?;
    let path_weight = degree_square_sum
        .checked_sub(closed_wedge_weight)
        .ok_or(GraphObstructionError::Adjacency)?;
    if !path_weight.is_multiple_of(2) {
        return Err(GraphObstructionError::Adjacency);
    }
    let induced_paths_three = path_weight / 2;
    let is_cluster = induced_paths_three == 0;
    let has_odd_component = is_cluster && adjacency.iter().any(|row| row.count_ones() % 2 == 0);
    Ok(ClusterGraphCensus {
        vertices: u32::try_from(order).map_err(|_| GraphObstructionError::Overflow)?,
        edges: u32::try_from(edges).map_err(|_| GraphObstructionError::Overflow)?,
        triangles: u32::try_from(triangles).map_err(|_| GraphObstructionError::Overflow)?,
        induced_paths_three: u32::try_from(induced_paths_three)
            .map_err(|_| GraphObstructionError::Overflow)?,
        has_odd_component,
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    fn rows(order: usize, edges: &[(usize, usize)]) -> Vec<u64> {
        let mut adjacency = vec![0_u64; order];
        for &(left, right) in edges {
            adjacency[left] |= 1_u64 << right;
            adjacency[right] |= 1_u64 << left;
        }
        adjacency
    }

    #[test]
    fn distinguishes_cluster_graphs_by_the_scalar_identity() {
        let cluster = rows(6, &[(0, 1), (0, 2), (1, 2), (3, 4)]);
        let census = cluster_graph_census(&cluster).unwrap();
        assert!(census.is_cluster_graph());
        assert!(census.has_odd_component);
        assert_eq!((census.edges, census.triangles), (4, 1));

        let path = rows(3, &[(0, 1), (1, 2)]);
        assert_eq!(cluster_graph_census(&path).unwrap().induced_paths_three, 1);
    }

    #[test]
    fn perfect_matching_has_no_odd_component() {
        let matching = rows(6, &[(0, 1), (2, 3), (4, 5)]);
        let census = cluster_graph_census(&matching).unwrap();
        assert!(census.is_cluster_graph());
        assert!(!census.has_odd_component);
    }

    #[test]
    fn rejects_asymmetric_input() {
        assert_eq!(
            cluster_graph_census(&[2, 0]),
            Err(GraphObstructionError::Adjacency)
        );
    }
}
