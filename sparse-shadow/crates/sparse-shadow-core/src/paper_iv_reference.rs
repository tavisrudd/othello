#![allow(clippy::cast_possible_truncation)] // The independently replayed degree is 78.

use std::collections::BTreeSet;

use crate::{BranchDecision, GatedPaperIv, SearchStats, ShadowError};

const N: usize = 78;
const COLOR_COUNT: usize = 6;

#[derive(Clone)]
struct OrderedPartition {
    labels: Vec<usize>,
    ends: Vec<usize>,
}

pub(crate) struct ReferenceResult {
    pub input_to_canonical: Vec<u32>,
    pub automorphisms: Vec<Vec<u32>>,
    pub winning_trace: Vec<BranchDecision>,
    pub search_stats: SearchStats,
}

struct Walker<'a> {
    matrix: &'a [u8],
    best_key: Option<Vec<u8>>,
    best_order: Vec<usize>,
    equal_orders: Vec<Vec<usize>>,
    winning_trace: Vec<BranchDecision>,
    stats: SearchStats,
}

pub(crate) fn search(value: &GatedPaperIv) -> Result<ReferenceResult, ShadowError> {
    let matrix = relation_matrix(value)?;
    let mut walker = Walker {
        matrix: &matrix,
        best_key: None,
        best_order: Vec::new(),
        equal_orders: Vec::new(),
        winning_trace: Vec::new(),
        stats: SearchStats {
            search_nodes: 0,
            canonical_leaves: 0,
            refinement_rounds: 0,
            max_depth: 0,
            arena_grows: 0,
        },
    };
    walker.visit(
        OrderedPartition {
            labels: (0..N).collect(),
            ends: vec![N],
        },
        &mut Vec::new(),
    );

    let mut input_to_canonical = vec![0_u32; N];
    for (canonical, &input) in walker.best_order.iter().enumerate() {
        input_to_canonical[input] = canonical as u32;
    }
    let automorphisms = walker
        .equal_orders
        .iter()
        .map(|order| {
            let mut permutation = vec![0_u32; N];
            for position in 0..N {
                permutation[walker.best_order[position]] = order[position] as u32;
            }
            permutation
        })
        .collect::<BTreeSet<_>>()
        .into_iter()
        .collect();
    Ok(ReferenceResult {
        input_to_canonical,
        automorphisms,
        winning_trace: walker.winning_trace,
        search_stats: walker.stats,
    })
}

fn relation_matrix(value: &GatedPaperIv) -> Result<Vec<u8>, ShadowError> {
    let mut matrix = vec![0; N * N];
    for pair in &value.weighted_pair_section {
        let color = [6, 7, 8, 9, 12]
            .iter()
            .position(|&weight| weight == pair.multiplicity)
            .ok_or_else(|| ShadowError::Invalid("unknown Paper-IV weight".into()))?
            + 1;
        let left = pair.left as usize;
        let right = pair.right as usize;
        matrix[left * N + right] = color as u8;
        matrix[right * N + left] = color as u8;
    }
    Ok(matrix)
}

impl Walker<'_> {
    fn visit(&mut self, mut partition: OrderedPartition, trace: &mut Vec<BranchDecision>) {
        self.stats.search_nodes += 1;
        self.stats.max_depth = self.stats.max_depth.max(trace.len() as u32);
        self.stabilize(&mut partition);
        let Some((cell_index, start, end)) = choose_cell(&partition) else {
            self.leaf(&partition.labels, trace);
            return;
        };
        let cell = partition.labels[start..end].to_vec();
        for &chosen in &cell {
            let mut labels = partition.labels.clone();
            labels[start..end].sort_unstable_by_key(|&vertex| (vertex != chosen, vertex));
            let mut ends = partition.ends.clone();
            ends.insert(cell_index, start + 1);
            trace.push(BranchDecision {
                depth: trace.len() as u32,
                cell: cell.iter().map(|&vertex| vertex as u32).collect(),
                chosen_vertex: chosen as u32,
            });
            self.visit(OrderedPartition { labels, ends }, trace);
            trace.pop();
        }
    }

    fn stabilize(&mut self, partition: &mut OrderedPartition) {
        loop {
            self.stats.refinement_rounds += 1;
            let old_ends = partition.ends.clone();
            let old_labels = partition.labels.clone();
            let ranges = ranges(&old_ends);
            let mut labels = Vec::with_capacity(N);
            let mut ends = Vec::new();
            for &(start, end) in &ranges {
                let mut entries = old_labels[start..end]
                    .iter()
                    .map(|&vertex| (signature(vertex, &old_labels, &ranges, self.matrix), vertex))
                    .collect::<Vec<_>>();
                entries.sort_unstable();
                let mut previous: Option<Vec<u16>> = None;
                for (key, vertex) in entries {
                    if previous.as_ref().is_some_and(|old| *old != key) {
                        ends.push(labels.len());
                    }
                    labels.push(vertex);
                    previous = Some(key);
                }
                ends.push(labels.len());
            }
            let changed = ends != old_ends;
            partition.labels = labels;
            partition.ends = ends;
            if !changed {
                return;
            }
        }
    }

    fn leaf(&mut self, order: &[usize], trace: &[BranchDecision]) {
        self.stats.canonical_leaves += 1;
        let mut key = Vec::with_capacity(N * (N - 1) / 2);
        for right in 1..N {
            for left in 0..right {
                key.push(self.matrix[order[left] * N + order[right]]);
            }
        }
        match self.best_key.as_ref().map(|best| key.cmp(best)) {
            None | Some(std::cmp::Ordering::Less) => {
                self.best_key = Some(key);
                self.best_order = order.to_vec();
                self.equal_orders = vec![order.to_vec()];
                self.winning_trace = trace.to_vec();
            }
            Some(std::cmp::Ordering::Equal) => self.equal_orders.push(order.to_vec()),
            Some(std::cmp::Ordering::Greater) => {}
        }
    }
}

fn ranges(ends: &[usize]) -> Vec<(usize, usize)> {
    let mut start = 0;
    ends.iter()
        .map(|&end| {
            let range = (start, end);
            start = end;
            range
        })
        .collect()
}

fn signature(
    vertex: usize,
    labels: &[usize],
    ranges: &[(usize, usize)],
    matrix: &[u8],
) -> Vec<u16> {
    let mut signature = Vec::with_capacity(ranges.len() * COLOR_COUNT);
    for &(start, end) in ranges {
        let mut counts = [0_u16; COLOR_COUNT];
        for &other in &labels[start..end] {
            counts[matrix[vertex * N + other] as usize] += 1;
        }
        signature.extend(counts);
    }
    signature
}

fn choose_cell(partition: &OrderedPartition) -> Option<(usize, usize, usize)> {
    ranges(&partition.ends)
        .into_iter()
        .enumerate()
        .filter(|(_, (start, end))| end - start > 1)
        .min_by_key(|(index, (start, end))| (end - start, *index))
        .map(|(index, (start, end))| (index, start, end))
}
