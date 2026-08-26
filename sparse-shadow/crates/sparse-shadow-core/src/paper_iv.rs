#![allow(clippy::cast_possible_truncation)] // The adapter's frozen degree is 78.

use std::{cmp::Ordering, collections::BTreeSet};

use crate::{BranchDecision, GatedPaperIv, SearchStats, ShadowError};

const DEGREE: usize = 78;
const COLORS: usize = 6;
const SIGNATURE_BYTES: usize = DEGREE * COLORS;
const LEAF_BYTES: usize = DEGREE * (DEGREE - 1) / 2;
const AUTOMORPHISM_CAPACITY: usize = 4096;

#[derive(Clone, Copy)]
struct HotPartition {
    order: [u8; DEGREE],
    cell_ends: [u8; DEGREE],
    cell_count: u8,
}

#[derive(Clone, Copy, Eq, Ord, PartialEq, PartialOrd)]
struct Signature {
    bytes: [u8; SIGNATURE_BYTES],
}

#[derive(Clone, Copy, Eq, Ord, PartialEq, PartialOrd)]
struct LeafKey {
    bytes: [u8; LEAF_BYTES],
}

#[derive(Clone, Copy)]
struct SignedVertex {
    signature: Signature,
    vertex: u8,
}

#[derive(Clone, Copy)]
struct HotBranch {
    cell: [u8; DEGREE],
    cell_len: u8,
    chosen: u8,
}

struct DensePaperIv {
    colors: Box<[u8; DEGREE * DEGREE]>,
}

struct HotSearch {
    has_best: bool,
    best_key: LeafKey,
    best_order: [u8; DEGREE],
    equal_orders: Vec<[u8; DEGREE]>,
    winning_path: [HotBranch; DEGREE],
    winning_depth: u8,
    stats: SearchStats,
}

pub(crate) struct PreparedSearch {
    dense: DensePaperIv,
    search: HotSearch,
}

pub(crate) struct PaperIvSearchResult {
    pub best_permutation: Vec<usize>,
    pub equal_permutations: Vec<Vec<usize>>,
    pub winning_trace: Vec<BranchDecision>,
    pub stats: SearchStats,
}

const EMPTY_SIGNATURE: Signature = Signature {
    bytes: [0; SIGNATURE_BYTES],
};
const EMPTY_SIGNED_VERTEX: SignedVertex = SignedVertex {
    signature: EMPTY_SIGNATURE,
    vertex: 0,
};
const EMPTY_BRANCH: HotBranch = HotBranch {
    cell: [0; DEGREE],
    cell_len: 0,
    chosen: 0,
};

const _: () = assert!(std::mem::size_of::<HotPartition>() <= 160);
const _: () = assert!(std::mem::size_of::<Signature>() == SIGNATURE_BYTES);
const _: () = assert!(std::mem::size_of::<LeafKey>() == LEAF_BYTES);

pub(crate) fn search(value: &GatedPaperIv) -> Result<PaperIvSearchResult, ShadowError> {
    let mut prepared = prepare(value)?;
    run_prepared(&mut prepared);
    Ok(finish(prepared.search))
}

pub(crate) fn prepare(value: &GatedPaperIv) -> Result<PreparedSearch, ShadowError> {
    let mut colors = Box::new([0; DEGREE * DEGREE]);
    for pair in &value.weighted_pair_section {
        let color = match pair.multiplicity {
            6 => 1,
            7 => 2,
            8 => 3,
            9 => 4,
            12 => 5,
            _ => {
                return Err(ShadowError::Invalid(
                    "unsupported Paper-IV pair weight".into(),
                ));
            }
        };
        let left = pair.left as usize;
        let right = pair.right as usize;
        colors[left * DEGREE + right] = color;
        colors[right * DEGREE + left] = color;
    }
    Ok(PreparedSearch {
        dense: DensePaperIv { colors },
        search: HotSearch {
            has_best: false,
            best_key: LeafKey {
                bytes: [0; LEAF_BYTES],
            },
            best_order: [0; DEGREE],
            equal_orders: Vec::with_capacity(AUTOMORPHISM_CAPACITY),
            winning_path: [EMPTY_BRANCH; DEGREE],
            winning_depth: 0,
            stats: SearchStats {
                search_nodes: 0,
                canonical_leaves: 0,
                refinement_rounds: 0,
                max_depth: 0,
                arena_grows: 0,
            },
        },
    })
}

pub(crate) fn run_prepared(prepared: &mut PreparedSearch) {
    let mut path = [EMPTY_BRANCH; DEGREE];
    walk(
        &prepared.dense,
        &mut prepared.search,
        initial_partition(),
        &mut path,
        0,
    );
}

#[cfg(test)]
pub(crate) fn prepared_stats(prepared: &PreparedSearch) -> &SearchStats {
    &prepared.search.stats
}

fn initial_partition() -> HotPartition {
    let mut order = [0; DEGREE];
    for (vertex, slot) in order.iter_mut().enumerate() {
        *slot = vertex as u8;
    }
    let mut cell_ends = [0; DEGREE];
    cell_ends[0] = DEGREE as u8;
    HotPartition {
        order,
        cell_ends,
        cell_count: 1,
    }
}

fn walk(
    dense: &DensePaperIv,
    search: &mut HotSearch,
    mut partition: HotPartition,
    path: &mut [HotBranch; DEGREE],
    depth: usize,
) {
    search.stats.search_nodes += 1;
    search.stats.max_depth = search.stats.max_depth.max(depth as u32);
    refine(dense, search, &mut partition);
    let Some(cell) = branch_cell(&partition) else {
        visit_leaf(dense, search, &partition, path, depth);
        return;
    };
    let (start, end) = cell_range(&partition, cell);
    let mut candidates = [0; DEGREE];
    let candidate_count = end - start;
    candidates[..candidate_count].copy_from_slice(&partition.order[start..end]);
    for &chosen in &candidates[..candidate_count] {
        let mut branch = EMPTY_BRANCH;
        branch.cell[..candidate_count].copy_from_slice(&candidates[..candidate_count]);
        branch.cell_len = candidate_count as u8;
        branch.chosen = chosen;
        path[depth] = branch;
        walk(
            dense,
            search,
            individualized(partition, cell, chosen),
            path,
            depth + 1,
        );
    }
}

#[allow(clippy::large_stack_arrays)] // Fixed scratch enforces the zero-allocation hot contract.
fn refine(dense: &DensePaperIv, search: &mut HotSearch, partition: &mut HotPartition) {
    loop {
        search.stats.refinement_rounds += 1;
        let old = *partition;
        let mut next = HotPartition {
            order: [0; DEGREE],
            cell_ends: [0; DEGREE],
            cell_count: 0,
        };
        let mut output = 0;
        for cell in 0..old.cell_count as usize {
            let (start, end) = cell_range(&old, cell);
            let count = end - start;
            let mut signed = [EMPTY_SIGNED_VERTEX; DEGREE];
            for (slot, &vertex) in old.order[start..end].iter().enumerate() {
                signed[slot] = SignedVertex {
                    signature: signature(dense, &old, vertex),
                    vertex,
                };
            }
            signed[..count].sort_unstable_by(|left, right| {
                left.signature
                    .cmp(&right.signature)
                    .then(left.vertex.cmp(&right.vertex))
            });
            for index in 0..count {
                if index > 0 && signed[index - 1].signature != signed[index].signature {
                    next.cell_ends[next.cell_count as usize] = output as u8;
                    next.cell_count += 1;
                }
                next.order[output] = signed[index].vertex;
                output += 1;
            }
            next.cell_ends[next.cell_count as usize] = output as u8;
            next.cell_count += 1;
        }
        *partition = next;
        if next.cell_count == old.cell_count {
            return;
        }
    }
}

fn signature(dense: &DensePaperIv, partition: &HotPartition, vertex: u8) -> Signature {
    let mut result = EMPTY_SIGNATURE;
    let mut output = 0;
    for cell in 0..partition.cell_count as usize {
        let (start, end) = cell_range(partition, cell);
        let mut counts = [0_u8; COLORS];
        for &other in &partition.order[start..end] {
            counts[dense.colors[vertex as usize * DEGREE + other as usize] as usize] += 1;
        }
        result.bytes[output..output + COLORS].copy_from_slice(&counts);
        output += COLORS;
    }
    result
}

fn branch_cell(partition: &HotPartition) -> Option<usize> {
    (0..partition.cell_count as usize)
        .filter(|&cell| {
            let (start, end) = cell_range(partition, cell);
            end - start > 1
        })
        .min_by_key(|&cell| {
            let (start, end) = cell_range(partition, cell);
            (end - start, cell)
        })
}

fn cell_range(partition: &HotPartition, cell: usize) -> (usize, usize) {
    let start = if cell == 0 {
        0
    } else {
        partition.cell_ends[cell - 1] as usize
    };
    (start, partition.cell_ends[cell] as usize)
}

fn individualized(mut partition: HotPartition, cell: usize, chosen: u8) -> HotPartition {
    let (start, end) = cell_range(&partition, cell);
    let chosen_position = partition.order[start..end]
        .iter()
        .position(|&vertex| vertex == chosen)
        .map(|offset| start + offset)
        .expect("branch vertex belongs to its cell");
    partition.order[start..=chosen_position].rotate_right(1);
    for index in (cell + 1..=partition.cell_count as usize).rev() {
        partition.cell_ends[index] = partition.cell_ends[index - 1];
    }
    partition.cell_ends[cell] = (start + 1) as u8;
    partition.cell_count += 1;
    partition
}

fn visit_leaf(
    dense: &DensePaperIv,
    search: &mut HotSearch,
    partition: &HotPartition,
    path: &[HotBranch; DEGREE],
    depth: usize,
) {
    search.stats.canonical_leaves += 1;
    let key = leaf_key(dense, &partition.order);
    let comparison = if search.has_best {
        key.cmp(&search.best_key)
    } else {
        Ordering::Less
    };
    if comparison == Ordering::Less {
        search.has_best = true;
        search.best_key = key;
        search.best_order = partition.order;
        search.equal_orders.clear();
        search.winning_path[..depth].copy_from_slice(&path[..depth]);
        search.winning_depth = depth as u8;
    }
    if comparison != Ordering::Greater {
        if search.equal_orders.len() == search.equal_orders.capacity() {
            search.stats.arena_grows += 1;
        }
        search.equal_orders.push(partition.order);
    }
}

fn leaf_key(dense: &DensePaperIv, order: &[u8; DEGREE]) -> LeafKey {
    let mut key = LeafKey {
        bytes: [0; LEAF_BYTES],
    };
    let mut output = 0;
    for right in 1..DEGREE {
        for left in 0..right {
            key.bytes[output] = dense.colors[order[left] as usize * DEGREE + order[right] as usize];
            output += 1;
        }
    }
    key
}

fn finish(search: HotSearch) -> PaperIvSearchResult {
    let mut input_to_canonical = vec![0; DEGREE];
    for (canonical, &input) in search.best_order.iter().enumerate() {
        input_to_canonical[input as usize] = canonical;
    }
    let equal_permutations = search
        .equal_orders
        .iter()
        .map(|order| {
            let mut permutation = vec![0; DEGREE];
            for position in 0..DEGREE {
                permutation[search.best_order[position] as usize] = order[position] as usize;
            }
            permutation
        })
        .collect::<BTreeSet<_>>()
        .into_iter()
        .collect();
    let winning_trace = search.winning_path[..search.winning_depth as usize]
        .iter()
        .enumerate()
        .map(|(depth, branch)| BranchDecision {
            depth: depth as u32,
            cell: branch.cell[..branch.cell_len as usize]
                .iter()
                .copied()
                .map(u32::from)
                .collect(),
            chosen_vertex: u32::from(branch.chosen),
        })
        .collect();
    PaperIvSearchResult {
        best_permutation: input_to_canonical,
        equal_permutations,
        winning_trace,
        stats: search.stats,
    }
}
