//! Exact replay and deterministic construction for finite binary-query designs.
//!
//! A test is a bit mask of hypotheses producing the positive response.  The
//! module verifies nonadaptive separating families and flat adaptive decision
//! trees without recursion.  The constructors are deterministic greedy
//! baselines, strengthened by an exact connected-triple factor whenever every
//! query names one hypothesis pair. Certificates remain exact even when no
//! global optimality theorem applies.

use thiserror::Error;

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct NonadaptiveQueryCertificate {
    selected_tests: Box<[u32]>,
}

impl NonadaptiveQueryCertificate {
    #[must_use]
    pub fn new(selected_tests: impl Into<Box<[u32]>>) -> Self {
        Self {
            selected_tests: selected_tests.into(),
        }
    }

    #[must_use]
    pub fn selected_tests(&self) -> &[u32] {
        &self.selected_tests
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct AdaptiveQueryNode {
    pub test: u32,
    pub negative: i32,
    pub positive: i32,
    _reserved: u32,
}

impl AdaptiveQueryNode {
    #[must_use]
    pub const fn new(test: u32, negative: i32, positive: i32) -> Self {
        Self {
            test,
            negative,
            positive,
            _reserved: 0,
        }
    }
}

const _: () = assert!(
    std::mem::size_of::<AdaptiveQueryNode>() == 16
        && std::mem::align_of::<AdaptiveQueryNode>() == 4
);

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct AdaptiveQueryCertificate {
    root: i32,
    nodes: Box<[AdaptiveQueryNode]>,
}

impl AdaptiveQueryCertificate {
    #[must_use]
    pub fn new(root: i32, nodes: impl Into<Box<[AdaptiveQueryNode]>>) -> Self {
        Self {
            root,
            nodes: nodes.into(),
        }
    }

    #[must_use]
    pub fn root(&self) -> i32 {
        self.root
    }

    #[must_use]
    pub fn nodes(&self) -> &[AdaptiveQueryNode] {
        &self.nodes
    }
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct AdaptiveQueryMetrics {
    pub internal_nodes: u32,
    pub maximum_depth: u32,
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum QueryDesignError {
    #[error("binary query design requires 1..=64 hypotheses")]
    Shape,
    #[error("a query contains a hypothesis outside the declared universe")]
    QueryRange,
    #[error("hypotheses {left} and {right} are indistinguishable")]
    Indistinguishable { left: u32, right: u32 },
    #[error("query certificate is invalid")]
    Certificate,
}

/// Universal lower bound for nonadaptive queries when every test marks
/// exactly two hypotheses.
///
/// In a separating selected-edge graph there is at most one isolated vertex
/// and no two-vertex component. With `m` edges, the nontrivial components
/// cover at most `m + floor(m/2)` vertices, giving the returned bound.
pub fn pair_query_nonadaptive_lower_bound(
    hypotheses: u32,
    tests: &[u64],
) -> Result<Option<u32>, QueryDesignError> {
    validate(hypotheses, tests)?;
    if tests.iter().any(|test| test.count_ones() != 2) {
        return Ok(None);
    }
    let mut queries = 0_u32;
    while 1_u32 + queries + queries / 2 < hypotheses {
        queries += 1;
    }
    Ok(Some(queries))
}

/// Deterministically construct a separating nonadaptive family by greedy
/// maximum coverage of unresolved hypothesis pairs.
pub fn compile_greedy_nonadaptive_queries(
    hypotheses: u32,
    tests: &[u64],
) -> Result<NonadaptiveQueryCertificate, QueryDesignError> {
    let universe = validate(hypotheses, tests)?;
    let mut unresolved = Vec::new();
    for left in 0..hypotheses {
        for right in left + 1..hypotheses {
            unresolved.push((left as u8, right as u8));
        }
    }
    let mut selected = Vec::new();
    let mut used = vec![false; tests.len()];
    while !unresolved.is_empty() {
        let best = tests
            .iter()
            .enumerate()
            .filter(|(index, _)| !used[*index])
            .map(|(index, &test)| {
                let separated = unresolved
                    .iter()
                    .filter(|&&(left, right)| ((test >> left) ^ (test >> right)) & 1 != 0)
                    .count();
                (separated, index)
            })
            .max_by(|left, right| left.0.cmp(&right.0).then_with(|| right.1.cmp(&left.1)));
        let Some((_, best)) = best else {
            let (left, right) = unresolved[0];
            return Err(QueryDesignError::Indistinguishable {
                left: u32::from(left),
                right: u32::from(right),
            });
        };
        if tests[best] & universe == 0 || tests[best] & universe == universe {
            used[best] = true;
            continue;
        }
        let separated = unresolved
            .iter()
            .filter(|&&(left, right)| ((tests[best] >> left) ^ (tests[best] >> right)) & 1 != 0)
            .count();
        if separated == 0 {
            let (left, right) = unresolved[0];
            return Err(QueryDesignError::Indistinguishable {
                left: u32::from(left),
                right: u32::from(right),
            });
        }
        used[best] = true;
        selected.push(best as u32);
        unresolved
            .retain(|&(left, right)| ((tests[best] >> left) ^ (tests[best] >> right)) & 1 == 0);
    }
    let mut position = selected.len();
    while position != 0 {
        position -= 1;
        let mut reduced = selected.clone();
        reduced.remove(position);
        let candidate = NonadaptiveQueryCertificate::new(reduced.clone());
        if verify_nonadaptive_queries(hypotheses, tests, &candidate).is_ok() {
            selected = reduced;
        }
    }
    if let Some(edge_optimum) = edge_query_triple_factor(hypotheses, tests) {
        if edge_optimum.len() < selected.len() {
            selected = edge_optimum;
        }
    }
    let certificate = NonadaptiveQueryCertificate {
        selected_tests: selected.into_boxed_slice(),
    };
    verify_nonadaptive_queries(hypotheses, tests, &certificate)?;
    Ok(certificate)
}

pub fn verify_nonadaptive_queries(
    hypotheses: u32,
    tests: &[u64],
    certificate: &NonadaptiveQueryCertificate,
) -> Result<(), QueryDesignError> {
    validate(hypotheses, tests)?;
    if certificate
        .selected_tests
        .iter()
        .any(|&test| test as usize >= tests.len())
    {
        return Err(QueryDesignError::Certificate);
    }
    for left in 0..hypotheses {
        for right in left + 1..hypotheses {
            if !certificate.selected_tests.iter().any(|&test| {
                ((tests[test as usize] >> left) ^ (tests[test as usize] >> right)) & 1 != 0
            }) {
                return Err(QueryDesignError::Certificate);
            }
        }
    }
    Ok(())
}

/// Construct a flat adaptive tree by choosing the most balanced available
/// split at each node. Traversal and construction are iterative.
pub fn compile_greedy_adaptive_queries(
    hypotheses: u32,
    tests: &[u64],
) -> Result<AdaptiveQueryCertificate, QueryDesignError> {
    let universe = validate(hypotheses, tests)?;
    if hypotheses == 1 {
        return Ok(AdaptiveQueryCertificate {
            root: encode_leaf(0),
            nodes: Box::new([]),
        });
    }
    let mut nodes = vec![AdaptiveQueryNode::default()];
    let mut tasks = vec![(0_usize, universe)];
    while let Some((node_index, candidates)) = tasks.pop() {
        let mut best = None;
        for (test_index, &test) in tests.iter().enumerate() {
            let positive = candidates & test;
            let negative = candidates & !test;
            if positive == 0 || negative == 0 {
                continue;
            }
            let key = (
                positive.count_ones().max(negative.count_ones()),
                positive.count_ones().abs_diff(negative.count_ones()),
                test_index,
            );
            if best.is_none_or(|(best_key, _, _)| key < best_key) {
                best = Some((key, positive, negative));
            }
        }
        let Some(((.., test_index), positive, negative)) = best else {
            let left = candidates.trailing_zeros();
            let right = (candidates & (candidates - 1)).trailing_zeros();
            return Err(QueryDesignError::Indistinguishable { left, right });
        };
        let negative_child = make_child(negative, &mut nodes, &mut tasks);
        let positive_child = make_child(positive, &mut nodes, &mut tasks);
        nodes[node_index] =
            AdaptiveQueryNode::new(test_index as u32, negative_child, positive_child);
    }
    let certificate = AdaptiveQueryCertificate {
        root: 0,
        nodes: nodes.into_boxed_slice(),
    };
    verify_adaptive_queries(hypotheses, tests, &certificate)?;
    Ok(certificate)
}

pub fn verify_adaptive_queries(
    hypotheses: u32,
    tests: &[u64],
    certificate: &AdaptiveQueryCertificate,
) -> Result<AdaptiveQueryMetrics, QueryDesignError> {
    let universe = validate(hypotheses, tests)?;
    let mut visited = vec![false; certificate.nodes.len()];
    let mut leaves = 0_u64;
    let mut maximum_depth = 0_u32;
    let mut stack = vec![(certificate.root, universe, 0_u32)];
    while let Some((child, candidates, depth)) = stack.pop() {
        maximum_depth = maximum_depth.max(depth);
        if child < 0 {
            let hypothesis = decode_leaf(child).ok_or(QueryDesignError::Certificate)?;
            if candidates.count_ones() != 1
                || candidates.trailing_zeros() != hypothesis
                || hypothesis >= hypotheses
            {
                return Err(QueryDesignError::Certificate);
            }
            leaves |= 1_u64 << hypothesis;
            continue;
        }
        let node_index = child as usize;
        if node_index >= certificate.nodes.len() || visited[node_index] {
            return Err(QueryDesignError::Certificate);
        }
        visited[node_index] = true;
        let node = certificate.nodes[node_index];
        if node.test as usize >= tests.len() {
            return Err(QueryDesignError::Certificate);
        }
        let positive = candidates & tests[node.test as usize];
        let negative = candidates & !tests[node.test as usize];
        if positive == 0 || negative == 0 {
            return Err(QueryDesignError::Certificate);
        }
        stack.push((node.positive, positive, depth + 1));
        stack.push((node.negative, negative, depth + 1));
    }
    if leaves != universe || visited.iter().any(|&seen| !seen) {
        return Err(QueryDesignError::Certificate);
    }
    Ok(AdaptiveQueryMetrics {
        internal_nodes: certificate.nodes.len() as u32,
        maximum_depth,
    })
}

fn make_child(
    candidates: u64,
    nodes: &mut Vec<AdaptiveQueryNode>,
    tasks: &mut Vec<(usize, u64)>,
) -> i32 {
    if candidates.count_ones() == 1 {
        return encode_leaf(candidates.trailing_zeros());
    }
    let child = nodes.len();
    nodes.push(AdaptiveQueryNode::default());
    tasks.push((child, candidates));
    child as i32
}

#[repr(C)]
#[derive(Clone, Copy)]
struct ConnectedTriple {
    mask: u64,
    first_test: u32,
    second_test: u32,
}

const _: () = assert!(
    std::mem::size_of::<ConnectedTriple>() == 16 && std::mem::align_of::<ConnectedTriple>() == 8
);

/// At the edge-query lower bound, every nontrivial selected component is a
/// three-vertex tree, with at most one isolated hypothesis. Find that exact
/// witness by iterative exact cover when the congruence permits it.
fn edge_query_triple_factor(hypotheses: u32, tests: &[u64]) -> Option<Vec<u32>> {
    if hypotheses % 3 > 1 || tests.iter().any(|test| test.count_ones() != 2) {
        return None;
    }
    let order = hypotheses as usize;
    let mut edge_test = vec![u32::MAX; order * order];
    for (test_index, &test) in tests.iter().enumerate() {
        let left = test.trailing_zeros() as usize;
        let right = (test & (test - 1)).trailing_zeros() as usize;
        let index = left * order + right;
        let reverse = right * order + left;
        let test_index = test_index as u32;
        edge_test[index] = edge_test[index].min(test_index);
        edge_test[reverse] = edge_test[reverse].min(test_index);
    }
    let mut triples = Vec::new();
    let mut by_vertex = vec![Vec::new(); order];
    for first in 0..order {
        for second in first + 1..order {
            for third in second + 1..order {
                let edges = [
                    edge_test[first * order + second],
                    edge_test[first * order + third],
                    edge_test[second * order + third],
                ];
                let available = edges
                    .into_iter()
                    .filter(|&edge| edge != u32::MAX)
                    .collect::<Vec<_>>();
                if available.len() < 2 {
                    continue;
                }
                let triple = ConnectedTriple {
                    mask: (1_u64 << first) | (1_u64 << second) | (1_u64 << third),
                    first_test: available[0],
                    second_test: available[1],
                };
                let index = triples.len();
                triples.push(triple);
                by_vertex[first].push(index);
                by_vertex[second].push(index);
                by_vertex[third].push(index);
            }
        }
    }
    let universe = if hypotheses == 64 {
        u64::MAX
    } else {
        (1_u64 << hypotheses) - 1
    };
    let isolate_choices = if hypotheses.is_multiple_of(3) {
        1
    } else {
        order
    };
    for choice in 0..isolate_choices {
        let isolate = if hypotheses.is_multiple_of(3) {
            order
        } else {
            choice
        };
        let mut covered = if isolate == order {
            0
        } else {
            1_u64 << isolate
        };
        let mut chosen: Vec<usize> = Vec::with_capacity(order / 3);
        let mut frames: Vec<(usize, usize)> = Vec::with_capacity(order / 3 + 1);
        loop {
            if covered == universe {
                let mut selected = Vec::with_capacity(chosen.len() * 2);
                for &triple in &chosen {
                    selected.push(triples[triple].first_test);
                    selected.push(triples[triple].second_test);
                }
                return Some(selected);
            }
            if frames.len() == chosen.len() {
                let vertex = (!covered & universe).trailing_zeros() as usize;
                frames.push((vertex, 0));
            }
            let depth = chosen.len();
            let (vertex, next) = frames[depth];
            let candidate = by_vertex[vertex][next..]
                .iter()
                .position(|&triple| triples[triple].mask & covered == 0)
                .map(|offset| next + offset);
            if let Some(position) = candidate {
                frames[depth].1 = position + 1;
                let triple = by_vertex[vertex][position];
                chosen.push(triple);
                covered |= triples[triple].mask;
                continue;
            }
            frames.pop();
            let Some(triple) = chosen.pop() else {
                break;
            };
            covered ^= triples[triple].mask;
        }
    }
    None
}

fn validate(hypotheses: u32, tests: &[u64]) -> Result<u64, QueryDesignError> {
    if !(1..=64).contains(&hypotheses) {
        return Err(QueryDesignError::Shape);
    }
    let universe = if hypotheses == 64 {
        u64::MAX
    } else {
        (1_u64 << hypotheses) - 1
    };
    if tests.iter().any(|&test| test & !universe != 0) {
        return Err(QueryDesignError::QueryRange);
    }
    Ok(universe)
}

fn encode_leaf(hypothesis: u32) -> i32 {
    -1 - hypothesis as i32
}

fn decode_leaf(leaf: i32) -> Option<u32> {
    (leaf < 0).then(|| (-1_i64 - i64::from(leaf)) as u32)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn compiles_and_replays_binary_identification() {
        let tests = [0b0011, 0b0101, 0b1001];
        let nonadaptive = compile_greedy_nonadaptive_queries(4, &tests).unwrap();
        assert_eq!(nonadaptive.selected_tests().len(), 2);
        let adaptive = compile_greedy_adaptive_queries(4, &tests).unwrap();
        let metrics = verify_adaptive_queries(4, &tests, &adaptive).unwrap();
        assert_eq!(metrics.maximum_depth, 2);
        assert_eq!(metrics.internal_nodes, 3);
    }

    #[test]
    fn reports_indistinguishable_hypotheses() {
        assert!(matches!(
            compile_greedy_adaptive_queries(3, &[0b001]),
            Err(QueryDesignError::Indistinguishable { .. })
        ));
        assert!(matches!(
            compile_greedy_nonadaptive_queries(3, &[0b001]),
            Err(QueryDesignError::Indistinguishable { .. })
        ));
    }
}
