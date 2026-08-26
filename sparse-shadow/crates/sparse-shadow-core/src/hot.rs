use std::cmp::Ordering;

use crate::{BranchDecision, PaperIOrientation, SearchStats};

const PAPER_I_VERTICES: usize = 12;
const PAPER_I_RELATIONS: usize = 3;
const INITIAL_AUTOMORPHISM_CAPACITY: usize = 256;

#[repr(C)]
#[derive(Clone, Copy)]
struct HotPartition {
    order: [u8; PAPER_I_VERTICES],
    cell_ends: [u8; PAPER_I_VERTICES],
    cell_count: u8,
    vertex_count: u8,
    _pad: [u8; 6],
}

#[repr(C, align(64))]
#[derive(Clone, Copy, Eq, PartialEq)]
struct Signature {
    bytes: [u8; 63],
    len: u8,
}

#[repr(C)]
#[derive(Clone, Copy, Eq, Ord, PartialEq, PartialOrd)]
struct LeafKey {
    words: [u64; 4],
}

#[repr(C, align(64))]
struct DensePaperI {
    adjacency: [[u16; PAPER_I_VERTICES]; PAPER_I_RELATIONS],
    calibrated_mask: u16,
    _pad: [u8; 54],
}

const _: () = assert!(
    size_of::<HotPartition>() == 32
        && align_of::<HotPartition>() == 1
        && size_of::<Signature>() == 64
        && align_of::<Signature>() == 64
        && size_of::<LeafKey>() == 32
        && align_of::<LeafKey>() == 8
        && size_of::<DensePaperI>() == 128
        && align_of::<DensePaperI>() == 64
);

pub(crate) struct HotResult {
    pub best_permutation: Vec<usize>,
    pub equal_permutations: Vec<Vec<usize>>,
    pub winning_trace: Vec<BranchDecision>,
    pub stats: SearchStats,
}

struct HotSearch {
    dense: DensePaperI,
    best_key: Option<LeafKey>,
    best_permutation: [u8; PAPER_I_VERTICES],
    winning_path: [u8; PAPER_I_VERTICES],
    winning_depth: u8,
    equal_permutations: Vec<[u8; PAPER_I_VERTICES]>,
    stats: SearchStats,
}

pub(crate) fn search(paper: &PaperIOrientation) -> HotResult {
    let initial = initial_partition(paper);
    let mut search = HotSearch {
        dense: DensePaperI::new(paper),
        best_key: None,
        best_permutation: [0; PAPER_I_VERTICES],
        winning_path: [0; PAPER_I_VERTICES],
        winning_depth: 0,
        equal_permutations: Vec::with_capacity(INITIAL_AUTOMORPHISM_CAPACITY),
        stats: SearchStats {
            search_nodes: 0,
            canonical_leaves: 0,
            refinement_rounds: 0,
            max_depth: 0,
            arena_grows: 0,
        },
    };
    let mut path = [0; PAPER_I_VERTICES];
    search.visit(initial, &mut path, 0);
    let winning_trace = replay_trace(
        paper,
        &search.dense,
        initial,
        &search.winning_path,
        usize::from(search.winning_depth),
    );
    HotResult {
        best_permutation: search
            .best_permutation
            .iter()
            .copied()
            .map(usize::from)
            .collect(),
        equal_permutations: search
            .equal_permutations
            .into_iter()
            .map(|permutation| permutation.into_iter().map(usize::from).collect())
            .collect(),
        winning_trace,
        stats: search.stats,
    }
}

impl DensePaperI {
    fn new(paper: &PaperIOrientation) -> Self {
        let mut adjacency = [[0; PAPER_I_VERTICES]; PAPER_I_RELATIONS];
        for (relation_index, relation) in paper.shadow.relations.iter().enumerate() {
            for &[left, right] in &relation.edges {
                adjacency[relation_index][left as usize] |= 1 << right;
                adjacency[relation_index][right as usize] |= 1 << left;
            }
        }
        let calibrated_mask = paper.calibrated_triangle.map_or(0, |triangle| {
            triangle
                .into_iter()
                .fold(0, |mask, vertex| mask | (1 << vertex))
        });
        Self {
            adjacency,
            calibrated_mask,
            _pad: [0; 54],
        }
    }
}

impl HotSearch {
    #[inline]
    fn visit(&mut self, partition: HotPartition, path: &mut [u8; PAPER_I_VERTICES], depth: u8) {
        self.stats.search_nodes += 1;
        self.stats.max_depth = self.stats.max_depth.max(u32::from(depth));
        let partition = refine(partition, &self.dense, &mut self.stats.refinement_rounds);
        if partition.cell_count == partition.vertex_count {
            self.stats.canonical_leaves += 1;
            self.accept_leaf(&partition, path, depth);
            return;
        }
        let cell = branch_cell(&partition);
        let (start, end) = partition.cell_range(cell);
        for position in start..end {
            let vertex = partition.order[position];
            path[usize::from(depth)] = vertex;
            self.visit(partition.individualized(cell, vertex), path, depth + 1);
        }
    }

    #[inline]
    fn accept_leaf(&mut self, partition: &HotPartition, path: &[u8; PAPER_I_VERTICES], depth: u8) {
        let key = leaf_key(partition, &self.dense);
        let permutation = partition.inverse_order();
        match self.best_key {
            None => self.replace_best(key, permutation, path, depth),
            Some(best) if key < best => self.replace_best(key, permutation, path, depth),
            Some(best) if key == best => self.push_equal(permutation),
            Some(_) => {}
        }
    }

    #[inline]
    fn replace_best(
        &mut self,
        key: LeafKey,
        permutation: [u8; PAPER_I_VERTICES],
        path: &[u8; PAPER_I_VERTICES],
        depth: u8,
    ) {
        self.best_key = Some(key);
        self.best_permutation = permutation;
        self.winning_path = *path;
        self.winning_depth = depth;
        self.equal_permutations.clear();
        self.push_equal(permutation);
    }

    #[inline]
    fn push_equal(&mut self, permutation: [u8; PAPER_I_VERTICES]) {
        if self.equal_permutations.len() == self.equal_permutations.capacity() {
            grow_automorphism_buffer(&mut self.equal_permutations);
            self.stats.arena_grows += 1;
        }
        self.equal_permutations.push(permutation);
    }
}

#[cold]
#[inline(never)]
fn grow_automorphism_buffer(buffer: &mut Vec<[u8; PAPER_I_VERTICES]>) {
    let additional = buffer.capacity().max(INITIAL_AUTOMORPHISM_CAPACITY);
    buffer.reserve_exact(additional);
}

impl HotPartition {
    #[inline]
    fn cell_range(&self, cell: usize) -> (usize, usize) {
        let start = if cell == 0 {
            0
        } else {
            usize::from(self.cell_ends[cell - 1])
        };
        (start, usize::from(self.cell_ends[cell]))
    }

    #[inline]
    fn individualized(mut self, cell: usize, vertex: u8) -> Self {
        let (start, end) = self.cell_range(cell);
        let position = self.order[start..end]
            .iter()
            .position(|&candidate| candidate == vertex)
            .map(|offset| start + offset)
            .expect("branch vertex belongs to selected cell");
        self.order.copy_within(start..position, start + 1);
        self.order[start] = vertex;
        let old_count = usize::from(self.cell_count);
        self.cell_ends.copy_within(cell..old_count, cell + 1);
        self.cell_ends[cell] = u8::try_from(start + 1).expect("Paper-I index fits u8");
        self.cell_count += 1;
        self
    }

    #[inline]
    fn inverse_order(&self) -> [u8; PAPER_I_VERTICES] {
        let mut permutation = [0; PAPER_I_VERTICES];
        for (new, &old) in self.order.iter().enumerate() {
            permutation[usize::from(old)] = u8::try_from(new).expect("Paper-I index fits u8");
        }
        permutation
    }
}

fn initial_partition(paper: &PaperIOrientation) -> HotPartition {
    let mut order = [0; PAPER_I_VERTICES];
    for (index, slot) in order.iter_mut().enumerate() {
        *slot = u8::try_from(index).expect("Paper-I index fits u8");
    }
    for index in 1..PAPER_I_VERTICES {
        let vertex = order[index];
        let mut cursor = index;
        while cursor > 0
            && paper.shadow.vertices[usize::from(vertex)]
                < paper.shadow.vertices[usize::from(order[cursor - 1])]
        {
            order[cursor] = order[cursor - 1];
            cursor -= 1;
        }
        order[cursor] = vertex;
    }
    let mut cell_ends = [0; PAPER_I_VERTICES];
    let mut cell_count = 0;
    for index in 1..=PAPER_I_VERTICES {
        if index == PAPER_I_VERTICES
            || paper.shadow.vertices[usize::from(order[index - 1])]
                != paper.shadow.vertices[usize::from(order[index])]
        {
            cell_ends[cell_count] = u8::try_from(index).expect("Paper-I index fits u8");
            cell_count += 1;
        }
    }
    HotPartition {
        order,
        cell_ends,
        cell_count: u8::try_from(cell_count).expect("Paper-I cell count fits u8"),
        vertex_count: u8::try_from(PAPER_I_VERTICES).expect("Paper-I size fits u8"),
        _pad: [0; 6],
    }
}

#[inline]
fn refine(
    mut partition: HotPartition,
    dense: &DensePaperI,
    refinement_rounds: &mut u64,
) -> HotPartition {
    loop {
        *refinement_rounds += 1;
        if partition.cell_count == partition.vertex_count {
            return partition;
        }
        let mut cell_masks = [0u16; PAPER_I_VERTICES];
        for (cell, cell_mask) in cell_masks
            .iter_mut()
            .enumerate()
            .take(usize::from(partition.cell_count))
        {
            let (start, end) = partition.cell_range(cell);
            for &vertex in &partition.order[start..end] {
                *cell_mask |= 1 << vertex;
            }
        }
        let mut signatures = [Signature {
            bytes: [0; 63],
            len: 0,
        }; PAPER_I_VERTICES];
        for cell in 0..usize::from(partition.cell_count) {
            let (start, end) = partition.cell_range(cell);
            if end - start > 1 {
                for &vertex in &partition.order[start..end] {
                    signatures[usize::from(vertex)] =
                        signature(usize::from(vertex), &partition, dense, &cell_masks);
                }
            }
        }
        let mut next = partition;
        next.cell_count = 0;
        let mut output = 0;
        for cell in 0..usize::from(partition.cell_count) {
            let (start, end) = partition.cell_range(cell);
            let output_start = output;
            for &vertex in &partition.order[start..end] {
                let mut cursor = output;
                while cursor > output_start
                    && signature_cmp(
                        &signatures[usize::from(vertex)],
                        &signatures[usize::from(next.order[cursor - 1])],
                    ) == Ordering::Less
                {
                    next.order[cursor] = next.order[cursor - 1];
                    cursor -= 1;
                }
                next.order[cursor] = vertex;
                output += 1;
            }
            for position in output_start + 1..output {
                if signatures[usize::from(next.order[position - 1])]
                    != signatures[usize::from(next.order[position])]
                {
                    next.cell_ends[usize::from(next.cell_count)] =
                        u8::try_from(position).expect("Paper-I index fits u8");
                    next.cell_count += 1;
                }
            }
            next.cell_ends[usize::from(next.cell_count)] =
                u8::try_from(output).expect("Paper-I index fits u8");
            next.cell_count += 1;
        }
        if next.cell_count == partition.cell_count {
            return next;
        }
        partition = next;
    }
}

#[inline]
fn signature(
    vertex: usize,
    partition: &HotPartition,
    dense: &DensePaperI,
    cell_masks: &[u16; PAPER_I_VERTICES],
) -> Signature {
    let mut result = Signature {
        bytes: [0; 63],
        len: 0,
    };
    for relation in 0..PAPER_I_RELATIONS {
        for &cell_mask in &cell_masks[..usize::from(partition.cell_count)] {
            result.bytes[usize::from(result.len)] =
                u8::try_from((dense.adjacency[relation][vertex] & cell_mask).count_ones())
                    .expect("Paper-I degree fits u8");
            result.len += 1;
        }
    }
    if dense.calibrated_mask != 0 {
        result.bytes[usize::from(result.len)] =
            u8::from(dense.calibrated_mask & (1 << vertex) != 0);
        result.len += 1;
    }
    result
}

#[inline]
fn signature_cmp(left: &Signature, right: &Signature) -> Ordering {
    left.bytes[..usize::from(left.len)].cmp(&right.bytes[..usize::from(right.len)])
}

#[inline]
fn branch_cell(partition: &HotPartition) -> usize {
    let mut best_cell = usize::MAX;
    let mut best_size = usize::MAX;
    for cell in 0..usize::from(partition.cell_count) {
        let (start, end) = partition.cell_range(cell);
        let size = end - start;
        if size > 1 && size < best_size {
            best_cell = cell;
            best_size = size;
        }
    }
    best_cell
}

#[inline]
fn leaf_key(partition: &HotPartition, dense: &DensePaperI) -> LeafKey {
    let mut key = LeafKey { words: [0; 4] };
    let mut position = 0;
    for left in 0..PAPER_I_VERTICES {
        for right in left + 1..PAPER_I_VERTICES {
            let old_left = usize::from(partition.order[left]);
            let old_right = partition.order[right];
            let relation = (0..PAPER_I_RELATIONS)
                .find(|&index| dense.adjacency[index][old_left] & (1 << old_right) != 0)
                .expect("validated Paper-I relations partition pairs");
            append_two_bits(
                &mut key,
                position,
                u8::try_from(relation).expect("Paper-I relation index fits u8"),
            );
            position += 1;
        }
    }
    for &old in &partition.order {
        append_two_bits(
            &mut key,
            position,
            u8::from(dense.calibrated_mask & (1 << old) != 0),
        );
        position += 1;
    }
    key
}

#[inline]
fn append_two_bits(key: &mut LeafKey, position: usize, value: u8) {
    let word = position / 32;
    let shift = 62 - 2 * (position % 32);
    key.words[word] |= u64::from(value) << shift;
}

fn replay_trace(
    _paper: &PaperIOrientation,
    dense: &DensePaperI,
    mut partition: HotPartition,
    path: &[u8; PAPER_I_VERTICES],
    depth: usize,
) -> Vec<BranchDecision> {
    let mut trace = Vec::with_capacity(depth);
    let mut rounds = 0;
    for (step, &vertex) in path[..depth].iter().enumerate() {
        partition = refine(partition, dense, &mut rounds);
        let cell = branch_cell(&partition);
        let (start, end) = partition.cell_range(cell);
        trace.push(BranchDecision {
            depth: u32::try_from(step).expect("Paper-I depth fits u32"),
            cell: partition.order[start..end]
                .iter()
                .copied()
                .map(u32::from)
                .collect(),
            chosen_vertex: u32::from(vertex),
        });
        partition = partition.individualized(cell, vertex);
    }
    trace
}

#[cfg(test)]
mod tests {
    use std::{alloc::System, sync::Mutex};

    use stats_alloc::{INSTRUMENTED_SYSTEM, Region, StatsAlloc};

    use super::*;
    use crate::InputArtifact;

    #[global_allocator]
    static GLOBAL: &StatsAlloc<System> = &INSTRUMENTED_SYSTEM;
    static ALLOCATION_TEST_LOCK: Mutex<()> = Mutex::new(());

    #[test]
    fn paper_i_ii_iv_and_v_search_loops_allocate_nothing() {
        let _guard = ALLOCATION_TEST_LOCK.lock().expect("allocation test lock");
        let input: InputArtifact = serde_json::from_str(include_str!(
            "../testdata/paper-i-icosahedral-orbitals.json"
        ))
        .expect("committed fixture parses");
        let crate::ProfileInput::PaperIOrientation(paper) = input.profile else {
            unreachable!();
        };
        let initial = initial_partition(&paper);
        let mut search = HotSearch {
            dense: DensePaperI::new(&paper),
            best_key: None,
            best_permutation: [0; PAPER_I_VERTICES],
            winning_path: [0; PAPER_I_VERTICES],
            winning_depth: 0,
            equal_permutations: Vec::with_capacity(INITIAL_AUTOMORPHISM_CAPACITY),
            stats: SearchStats {
                search_nodes: 0,
                canonical_leaves: 0,
                refinement_rounds: 0,
                max_depth: 0,
                arena_grows: 0,
            },
        };
        let mut path = [0; PAPER_I_VERTICES];
        {
            let region = Region::new(GLOBAL);
            search.visit(initial, &mut path, 0);
            let change = region.change();
            assert_eq!(change.allocations, 0);
            assert_eq!(change.reallocations, 0);
            assert_eq!(change.deallocations, 0);
        }
        assert_eq!(search.stats.arena_grows, 0);
        assert_eq!(search.equal_permutations.len(), 120);
        paper_ii_search_loop_allocates_nothing();
        paper_iv_search_loop_allocates_nothing();
        paper_v_search_loop_allocates_nothing();
    }

    fn paper_ii_search_loop_allocates_nothing() {
        let path = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join(
            "../../../papers/clebsch-factorization/verification/evidence/sparse_shadow_export.json",
        );
        if !path.exists() {
            return;
        }
        let input: InputArtifact =
            serde_json::from_slice(&std::fs::read(path).expect("read Paper-II export"))
                .expect("parse Paper-II export");
        let crate::ProfileInput::PaperIiTrade(paper) = input.profile else {
            unreachable!()
        };
        let mut search = crate::paper_ii::prepare(&paper).expect("Paper-II search prepares");
        let region = Region::new(GLOBAL);
        crate::paper_ii::run_prepared(&mut search);
        let change = region.change();
        assert_eq!(change.allocations, 0);
        assert_eq!(change.reallocations, 0);
        assert_eq!(change.deallocations, 0);
        assert_eq!(crate::paper_ii::prepared_stats(&search).search_nodes, 1320);
        assert_eq!(
            crate::paper_ii::prepared_stats(&search).canonical_leaves,
            1320
        );
    }

    fn paper_iv_search_loop_allocates_nothing() {
        let path = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR"))
            .join("../../../papers/q13-passant-code/verification/sparse_shadow_export.json");
        if !path.exists() {
            return;
        }
        let input: InputArtifact = serde_json::from_slice(
            &std::fs::read(path).expect("Paper-IV export reads for allocation gate"),
        )
        .expect("Paper-IV export parses for allocation gate");
        let crate::ProfileInput::PaperIvMinimumWords(paper) = input.profile else {
            unreachable!();
        };
        let mut search = crate::paper_iv::prepare(&paper).expect("Paper-IV search prepares");
        let region = Region::new(GLOBAL);
        crate::paper_iv::run_prepared(&mut search);
        let change = region.change();
        eprintln!(
            "Paper-IV hot search: allocations={} reallocations={} deallocations={}",
            change.allocations, change.reallocations, change.deallocations
        );
        assert_eq!(change.allocations, 0);
        assert_eq!(change.reallocations, 0);
        assert_eq!(change.deallocations, 0);
        assert_eq!(crate::paper_iv::prepared_stats(&search).search_nodes, 3901);
        assert_eq!(
            crate::paper_iv::prepared_stats(&search).canonical_leaves,
            2184
        );
    }

    fn paper_v_search_loop_allocates_nothing() {
        let path = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join(
            "../../../papers/chordal-conference-reconstruction/verification/evidence/sparse_shadow_export.json",
        );
        if !path.exists() {
            return;
        }
        let input: InputArtifact =
            serde_json::from_slice(&std::fs::read(path).expect("read Paper-V export"))
                .expect("parse Paper-V export");
        let crate::ProfileInput::PaperVChordalConference(paper) = input.profile else {
            unreachable!()
        };
        let mut search = crate::paper_v::prepare(&paper).expect("Paper-V search prepares");
        let region = Region::new(GLOBAL);
        crate::paper_v::run_prepared(&mut search);
        let change = region.change();
        assert_eq!(change.allocations, 0);
        assert_eq!(change.reallocations, 0);
        assert_eq!(change.deallocations, 0);
        assert_eq!(crate::paper_v::prepared_stats(&search).search_nodes, 720);
        assert_eq!(
            crate::paper_v::prepared_stats(&search).canonical_leaves,
            720
        );
    }
}
