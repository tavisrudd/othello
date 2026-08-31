//! Allocation-free exact Hall matching and obstruction extraction.
//!
//! The graph is compiled once into dense row bitmaps.  A reusable workspace
//! then decides whether every left obligation can receive a distinct right
//! resource.  Failure returns an exact set `Z` with `|N(Z)| < |Z|`.

use std::io::{self, Read, Write};
use thiserror::Error;

#[cfg(test)]
use crate::test_alloc::HotLoopAllocationGuard;

const NONE: u32 = u32::MAX;
const CERTIFICATE_MAGIC: [u8; 8] = *b"ERGHALL1";

#[derive(Debug, Error, PartialEq, Eq)]
pub enum HallError {
    #[error("a Hall graph dimension exceeds compact storage")]
    Overflow,
    #[error("edge ({left}, {right}) is outside the Hall graph")]
    Edge { left: u32, right: u32 },
    #[error("the reusable Hall workspace is too small")]
    Workspace,
    #[error("a Hall certificate is malformed")]
    Certificate,
}

#[derive(Debug, Error)]
pub enum HallReplayError {
    #[error(transparent)]
    Io(#[from] io::Error),
    #[error(transparent)]
    Hall(#[from] HallError),
}

/// Immutable bipartite graph with one dense bitmap per left vertex.
#[derive(Clone, Debug)]
pub struct DenseHallGraph {
    left_count: u32,
    right_count: u32,
    words_per_row: usize,
    rows: Box<[u64]>,
}

impl DenseHallGraph {
    pub fn new(
        left_count: u32,
        right_count: u32,
        edges: impl IntoIterator<Item = (u32, u32)>,
    ) -> Result<Self, HallError> {
        let words_per_row = (right_count as usize).div_ceil(64);
        let words = (left_count as usize)
            .checked_mul(words_per_row)
            .ok_or(HallError::Overflow)?;
        let mut rows = vec![0_u64; words];
        for (left, right) in edges {
            if left >= left_count || right >= right_count {
                return Err(HallError::Edge { left, right });
            }
            let index = left as usize * words_per_row + right as usize / 64;
            rows[index] |= 1_u64 << (right % 64);
        }
        Ok(Self {
            left_count,
            right_count,
            words_per_row,
            rows: rows.into_boxed_slice(),
        })
    }

    pub fn left_count(&self) -> u32 {
        self.left_count
    }

    pub fn right_count(&self) -> u32 {
        self.right_count
    }

    pub fn contains(&self, left: u32, right: u32) -> bool {
        if left >= self.left_count || right >= self.right_count {
            return false;
        }
        let index = left as usize * self.words_per_row + right as usize / 64;
        self.rows[index] & (1_u64 << (right % 64)) != 0
    }

    #[inline]
    fn row(&self, left: u32) -> &[u64] {
        let start = left as usize * self.words_per_row;
        &self.rows[start..start + self.words_per_row]
    }
}

/// Pre-sized storage reused by every matching decision of bounded dimensions.
#[derive(Debug)]
pub struct HallWorkspace {
    max_left: u32,
    max_right: u32,
    left_match: Box<[u32]>,
    right_match: Box<[u32]>,
    left_seen: Box<[u32]>,
    right_seen: Box<[u32]>,
    parent_right: Box<[u32]>,
    queue: Box<[u32]>,
    deficient_left: Box<[u64]>,
    deficient_right: Box<[u64]>,
    epoch: u32,
}

impl HallWorkspace {
    pub fn new(max_left: u32, max_right: u32) -> Result<Self, HallError> {
        let left = max_left as usize;
        let right = max_right as usize;
        Ok(Self {
            max_left,
            max_right,
            left_match: vec![NONE; left].into_boxed_slice(),
            right_match: vec![NONE; right].into_boxed_slice(),
            left_seen: vec![0; left].into_boxed_slice(),
            right_seen: vec![0; right].into_boxed_slice(),
            parent_right: vec![NONE; right].into_boxed_slice(),
            queue: vec![0; left].into_boxed_slice(),
            deficient_left: vec![0; left.div_ceil(64)].into_boxed_slice(),
            deficient_right: vec![0; right.div_ceil(64)].into_boxed_slice(),
            epoch: 0,
        })
    }

    #[inline]
    fn next_epoch(&mut self) -> u32 {
        if self.epoch == u32::MAX {
            self.left_seen.fill(0);
            self.right_seen.fill(0);
            self.epoch = 1;
        } else {
            self.epoch += 1;
        }
        self.epoch
    }
}

/// Borrowed result, valid until the workspace is reused.
#[derive(Clone, Copy, Debug)]
pub struct HallResult<'a> {
    left_count: u32,
    right_count: u32,
    cardinality: u32,
    left_match: &'a [u32],
    deficient_left: &'a [u64],
    deficient_right: &'a [u64],
    deficient_left_count: u32,
    deficient_right_count: u32,
}

impl HallResult<'_> {
    pub fn is_saturated(&self) -> bool {
        self.cardinality == self.left_count
    }

    pub fn cardinality(&self) -> u32 {
        self.cardinality
    }

    pub fn matched_right(&self, left: u32) -> Option<u32> {
        let &right = self.left_match.get(left as usize)?;
        (right != NONE).then_some(right)
    }

    pub fn deficiency(&self) -> u32 {
        self.deficient_left_count
            .saturating_sub(self.deficient_right_count)
    }

    pub fn deficient_left_contains(&self, left: u32) -> bool {
        left < self.left_count && bitmap_contains(self.deficient_left, left)
    }

    pub fn deficient_right_contains(&self, right: u32) -> bool {
        right < self.right_count && bitmap_contains(self.deficient_right, right)
    }

    /// Stream a compact result without constructing an intermediate buffer.
    pub fn write_certificate(&self, mut writer: impl Write) -> io::Result<()> {
        writer.write_all(&CERTIFICATE_MAGIC)?;
        for value in [
            self.left_count,
            self.right_count,
            self.cardinality,
            self.deficient_left_count,
            self.deficient_right_count,
        ] {
            writer.write_all(&value.to_le_bytes())?;
        }
        for &right in self.left_match {
            writer.write_all(&right.to_le_bytes())?;
        }
        for &word in self.deficient_left.iter().chain(self.deficient_right) {
            writer.write_all(&word.to_le_bytes())?;
        }
        Ok(())
    }
}

/// Decide Hall saturation and expose either a matching or a deficient set.
/// No allocation occurs after construction of `graph` and `workspace`.
pub fn solve_hall<'a>(
    graph: &DenseHallGraph,
    workspace: &'a mut HallWorkspace,
) -> Result<HallResult<'a>, HallError> {
    #[cfg(test)]
    let _allocation_guard = HotLoopAllocationGuard::enter();
    if graph.left_count > workspace.max_left || graph.right_count > workspace.max_right {
        return Err(HallError::Workspace);
    }
    let left_count = graph.left_count as usize;
    let right_count = graph.right_count as usize;
    workspace.left_match[..left_count].fill(NONE);
    workspace.right_match[..right_count].fill(NONE);

    let mut cardinality = 0_u32;
    for root in 0..graph.left_count {
        if augment_from(graph, workspace, root) {
            cardinality += 1;
        }
    }

    let left_words = left_count.div_ceil(64);
    let right_words = right_count.div_ceil(64);
    workspace.deficient_left[..left_words].fill(0);
    workspace.deficient_right[..right_words].fill(0);
    let (deficient_left_count, deficient_right_count) = if cardinality == graph.left_count {
        (0, 0)
    } else {
        alternating_deficiency(graph, workspace)
    };

    Ok(HallResult {
        left_count: graph.left_count,
        right_count: graph.right_count,
        cardinality,
        left_match: &workspace.left_match[..left_count],
        deficient_left: &workspace.deficient_left[..left_words],
        deficient_right: &workspace.deficient_right[..right_words],
        deficient_left_count,
        deficient_right_count,
    })
}

fn augment_from(graph: &DenseHallGraph, workspace: &mut HallWorkspace, root: u32) -> bool {
    let epoch = workspace.next_epoch();
    workspace.left_seen[root as usize] = epoch;
    workspace.queue[0] = root;
    let mut head = 0_usize;
    let mut tail = 1_usize;
    while head < tail {
        let left = workspace.queue[head];
        head += 1;
        for (word_index, &raw_word) in graph.row(left).iter().enumerate() {
            let mut word = raw_word;
            while word != 0 {
                let bit = word.trailing_zeros();
                word &= word - 1;
                let right = (word_index as u32) * 64 + bit;
                if right >= graph.right_count
                    || workspace.left_match[left as usize] == right
                    || workspace.right_seen[right as usize] == epoch
                {
                    continue;
                }
                workspace.right_seen[right as usize] = epoch;
                workspace.parent_right[right as usize] = left;
                let next_left = workspace.right_match[right as usize];
                if next_left == NONE {
                    augment_path(workspace, right);
                    return true;
                }
                if workspace.left_seen[next_left as usize] != epoch {
                    workspace.left_seen[next_left as usize] = epoch;
                    workspace.queue[tail] = next_left;
                    tail += 1;
                }
            }
        }
    }
    false
}

#[inline]
fn augment_path(workspace: &mut HallWorkspace, mut right: u32) {
    loop {
        let left = workspace.parent_right[right as usize];
        let previous = workspace.left_match[left as usize];
        workspace.left_match[left as usize] = right;
        workspace.right_match[right as usize] = left;
        if previous == NONE {
            return;
        }
        right = previous;
    }
}

fn alternating_deficiency(graph: &DenseHallGraph, workspace: &mut HallWorkspace) -> (u32, u32) {
    let epoch = workspace.next_epoch();
    let mut tail = 0_usize;
    for left in 0..graph.left_count {
        if workspace.left_match[left as usize] == NONE {
            workspace.left_seen[left as usize] = epoch;
            workspace.queue[tail] = left;
            tail += 1;
        }
    }
    let mut head = 0_usize;
    while head < tail {
        let left = workspace.queue[head];
        head += 1;
        for (word_index, &raw_word) in graph.row(left).iter().enumerate() {
            let mut word = raw_word;
            while word != 0 {
                let bit = word.trailing_zeros();
                word &= word - 1;
                let right = (word_index as u32) * 64 + bit;
                if right >= graph.right_count
                    || workspace.left_match[left as usize] == right
                    || workspace.right_seen[right as usize] == epoch
                {
                    continue;
                }
                workspace.right_seen[right as usize] = epoch;
                let next_left = workspace.right_match[right as usize];
                if next_left != NONE && workspace.left_seen[next_left as usize] != epoch {
                    workspace.left_seen[next_left as usize] = epoch;
                    workspace.queue[tail] = next_left;
                    tail += 1;
                }
            }
        }
    }

    let mut left_total = 0_u32;
    let mut right_total = 0_u32;
    for left in 0..graph.left_count {
        if workspace.left_seen[left as usize] == epoch {
            bitmap_insert(&mut workspace.deficient_left, left);
            left_total += 1;
        }
    }
    for right in 0..graph.right_count {
        if workspace.right_seen[right as usize] == epoch {
            bitmap_insert(&mut workspace.deficient_right, right);
            right_total += 1;
        }
    }
    debug_assert!(left_total > right_total);
    (left_total, right_total)
}

/// Independently check a matching or exact Hall-deficient neighbourhood.
pub fn verify_hall_result(
    graph: &DenseHallGraph,
    result: &HallResult<'_>,
) -> Result<(), HallError> {
    if result.left_count != graph.left_count || result.right_count != graph.right_count {
        return Err(HallError::Certificate);
    }
    let mut used = vec![false; graph.right_count as usize];
    let mut matched = 0_u32;
    for left in 0..graph.left_count {
        if let Some(right) = result.matched_right(left) {
            if !graph.contains(left, right) || used[right as usize] {
                return Err(HallError::Certificate);
            }
            used[right as usize] = true;
            matched += 1;
        }
    }
    if matched != result.cardinality {
        return Err(HallError::Certificate);
    }
    if result.is_saturated() {
        if result.deficient_left_count != 0
            || result.deficient_right_count != 0
            || result
                .deficient_left
                .iter()
                .chain(result.deficient_right)
                .any(|&word| word != 0)
        {
            return Err(HallError::Certificate);
        }
        return Ok(());
    }

    let mut exact_neighbours = vec![0_u64; (graph.right_count as usize).div_ceil(64)];
    let mut left_total = 0_u32;
    for left in 0..graph.left_count {
        if result.deficient_left_contains(left) {
            left_total += 1;
            for (target, &word) in exact_neighbours.iter_mut().zip(graph.row(left)) {
                *target |= word;
            }
        }
    }
    let right_total = exact_neighbours.iter().map(|word| word.count_ones()).sum();
    if left_total != result.deficient_left_count
        || right_total != result.deficient_right_count
        || left_total <= right_total
        || exact_neighbours.as_slice() != result.deficient_right
    {
        return Err(HallError::Certificate);
    }
    Ok(())
}

/// Replay a streamed certificate directly from `reader` against `graph`.
pub fn verify_hall_certificate(
    graph: &DenseHallGraph,
    mut reader: impl Read,
) -> Result<(), HallReplayError> {
    let mut magic = [0_u8; 8];
    reader.read_exact(&mut magic)?;
    if magic != CERTIFICATE_MAGIC {
        return Err(HallError::Certificate.into());
    }
    let left_count = read_u32(&mut reader)?;
    let right_count = read_u32(&mut reader)?;
    let cardinality = read_u32(&mut reader)?;
    let deficient_left_count = read_u32(&mut reader)?;
    let deficient_right_count = read_u32(&mut reader)?;
    if left_count != graph.left_count || right_count != graph.right_count {
        return Err(HallError::Certificate.into());
    }

    let mut left_match = vec![NONE; left_count as usize];
    for right in &mut left_match {
        *right = read_u32(&mut reader)?;
    }
    let mut deficient_left = vec![0_u64; (left_count as usize).div_ceil(64)];
    let mut deficient_right = vec![0_u64; (right_count as usize).div_ceil(64)];
    for word in deficient_left.iter_mut().chain(&mut deficient_right) {
        let mut bytes = [0_u8; 8];
        reader.read_exact(&mut bytes)?;
        *word = u64::from_le_bytes(bytes);
    }
    let mut trailing = [0_u8; 1];
    if reader.read(&mut trailing)? != 0 {
        return Err(HallError::Certificate.into());
    }

    let result = HallResult {
        left_count,
        right_count,
        cardinality,
        left_match: &left_match,
        deficient_left: &deficient_left,
        deficient_right: &deficient_right,
        deficient_left_count,
        deficient_right_count,
    };
    verify_hall_result(graph, &result)?;
    Ok(())
}

#[inline]
fn read_u32(reader: &mut impl Read) -> io::Result<u32> {
    let mut bytes = [0_u8; 4];
    reader.read_exact(&mut bytes)?;
    Ok(u32::from_le_bytes(bytes))
}

#[inline]
fn bitmap_contains(bitmap: &[u64], bit: u32) -> bool {
    bitmap
        .get(bit as usize / 64)
        .is_some_and(|word| word & (1_u64 << (bit % 64)) != 0)
}

#[inline]
fn bitmap_insert(bitmap: &mut [u64], bit: u32) {
    bitmap[bit as usize / 64] |= 1_u64 << (bit % 64);
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::field::Prime;

    type Point = [u8; 2];

    fn collinear<const Q: u8>(left: Point, middle: Point, right: Point) -> bool {
        let dx_left = Prime::<Q>::sub(middle[0], left[0]);
        let dy_left = Prime::<Q>::sub(middle[1], left[1]);
        let dx_right = Prime::<Q>::sub(right[0], left[0]);
        let dy_right = Prime::<Q>::sub(right[1], left[1]);
        Prime::<Q>::mul(dx_left, dy_right) == Prime::<Q>::mul(dy_left, dx_right)
    }

    fn projective_charge_edges<const Q: u8>(
        causal: Point,
        old_labels: &[Point],
        fibres: &[&[(Point, bool)]],
    ) -> Vec<(u32, u32)> {
        let mut edges = Vec::new();
        for (defect, attacks) in fibres.iter().enumerate() {
            for (label, &old_label) in old_labels.iter().enumerate() {
                if attacks.iter().any(|&(reply, secant_deleted)| {
                    old_label == reply
                        || (secant_deleted && collinear::<Q>(causal, reply, old_label))
                }) {
                    edges.push((defect as u32, label as u32));
                }
            }
        }
        edges
    }

    fn brute_cardinality(graph: &DenseHallGraph) -> u32 {
        let base = graph.right_count as u64 + 1;
        let assignments = base.pow(graph.left_count);
        let mut best = 0_u32;
        for mut code in 0..assignments {
            let mut used = 0_u64;
            let mut count = 0_u32;
            for left in 0..graph.left_count {
                let choice = (code % base) as u32;
                code /= base;
                if choice < graph.right_count
                    && graph.contains(left, choice)
                    && used & (1_u64 << choice) == 0
                {
                    used |= 1_u64 << choice;
                    count += 1;
                } else if choice < graph.right_count {
                    count = 0;
                    break;
                }
            }
            best = best.max(count);
        }
        best
    }

    #[test]
    fn exhaustive_small_graphs_match_brute_force_and_replay() {
        let mut workspace = HallWorkspace::new(3, 4).unwrap();
        for mask in 0_u32..1 << 12 {
            let edges = (0..3).flat_map(|left| {
                (0..4).filter_map(move |right| {
                    ((mask >> (4 * left + right)) & 1 != 0).then_some((left, right))
                })
            });
            let graph = DenseHallGraph::new(3, 4, edges).unwrap();
            let expected = brute_cardinality(&graph);
            let result = solve_hall(&graph, &mut workspace).unwrap();
            assert_eq!(result.cardinality(), expected);
            verify_hall_result(&graph, &result).unwrap();
        }
    }

    #[test]
    fn extracts_and_streams_an_exact_deficient_set_without_workspace_growth() {
        let graph = DenseHallGraph::new(4, 4, [(0, 0), (1, 0), (2, 1), (3, 2), (3, 3)]).unwrap();
        let mut workspace = HallWorkspace::new(4, 4).unwrap();
        let pointers = (
            workspace.left_match.as_ptr(),
            workspace.right_match.as_ptr(),
            workspace.queue.as_ptr(),
        );
        let mut bytes = Vec::new();
        for _ in 0..100 {
            let result = solve_hall(&graph, &mut workspace).unwrap();
            assert!(!result.is_saturated());
            assert_eq!(result.deficiency(), 1);
            assert!(result.deficient_left_contains(0));
            assert!(result.deficient_left_contains(1));
            assert!(result.deficient_right_contains(0));
            verify_hall_result(&graph, &result).unwrap();
            bytes.clear();
            result.write_certificate(&mut bytes).unwrap();
            assert_eq!(&bytes[..8], &CERTIFICATE_MAGIC);
            verify_hall_certificate(&graph, bytes.as_slice()).unwrap();
        }
        assert_eq!(workspace.left_match.as_ptr(), pointers.0);
        assert_eq!(workspace.right_match.as_ptr(), pointers.1);
        assert_eq!(workspace.queue.as_ptr(), pointers.2);
    }

    #[test]
    fn matching_and_deficiency_loop_allocates_nothing() {
        let graph = DenseHallGraph::new(4, 4, [(0, 0), (1, 0), (2, 1), (3, 2), (3, 3)]).unwrap();
        let mut workspace = HallWorkspace::new(4, 4).unwrap();
        let (summary, events) = crate::test_alloc::measure_allocations(|| {
            let result = solve_hall(&graph, &mut workspace).unwrap();
            (result.cardinality(), result.deficiency())
        });
        assert_eq!(summary, (3, 1));
        assert_eq!(events, Default::default());
    }

    #[test]
    fn c80_q11_reply_resource_graph_repairs_the_causal_collision() {
        // Projective q=11 one-to-many witness. Right labels are the two consumed
        // certificate replies (2,9) and (7,10); the second new defect can use
        // only the latter. The causal label alone branches, while the complete
        // exchange admits the distinct resource assignment. This does not yet
        // transport the second resource to a distinct ancestral defect label.
        let graph = DenseHallGraph::new(2, 2, [(0, 0), (0, 1), (1, 1)]).unwrap();
        let mut workspace = HallWorkspace::new(2, 2).unwrap();
        let result = solve_hall(&graph, &mut workspace).unwrap();
        assert!(result.is_saturated());
        assert_eq!(result.matched_right(0), Some(0));
        assert_eq!(result.matched_right(1), Some(1));
        verify_hall_result(&graph, &result).unwrap();

        // Removing the secant-deleted (2,9) repair yields the exact two-to-one
        // causal collision and a replayable deficiency-one obstruction.
        let causal_only = DenseHallGraph::new(2, 2, [(0, 1), (1, 1)]).unwrap();
        let result = solve_hall(&causal_only, &mut workspace).unwrap();
        assert!(!result.is_saturated());
        assert_eq!(result.deficiency(), 1);
        assert!(result.deficient_left_contains(0));
        assert!(result.deficient_left_contains(1));
        assert!(result.deficient_right_contains(1));
        verify_hall_result(&causal_only, &result).unwrap();
    }

    #[test]
    fn c80_deletion_secants_lift_reply_resources_to_distinct_old_labels() {
        let q11_labels = [[3, 7], [4, 4], [4, 10], [6, 0], [7, 0], [7, 10], [8, 9]];
        let q11_first = [([2, 9], true), ([7, 10], false)];
        let q11_second = [([7, 10], false)];
        let q11_edges =
            projective_charge_edges::<11>([7, 10], &q11_labels, &[&q11_first, &q11_second]);
        let q11 = DenseHallGraph::new(2, q11_labels.len() as u32, q11_edges).unwrap();
        let mut workspace = HallWorkspace::new(2, 27).unwrap();
        let result = solve_hall(&q11, &mut workspace).unwrap();
        assert!(result.is_saturated());
        assert_eq!(result.matched_right(0), Some(0)); // (3,7), on the deletion secant.
        assert_eq!(result.matched_right(1), Some(5)); // causal label (7,10).

        let q23_type_i_labels = [
            [5, 2],
            [5, 9],
            [5, 10],
            [6, 18],
            [6, 21],
            [9, 10],
            [10, 13],
            [11, 3],
            [11, 9],
            [11, 16],
            [11, 18],
            [12, 15],
            [12, 17],
            [14, 11],
            [14, 16],
            [15, 2],
            [16, 13],
            [16, 17],
            [16, 22],
            [17, 19],
            [19, 3],
            [19, 14],
            [20, 13],
            [20, 14],
            [21, 16],
            [22, 14],
            [22, 18],
        ];
        let type_i_attack = [([5, 13], true)];
        let type_i_edges =
            projective_charge_edges::<23>([12, 15], &q23_type_i_labels, &[&type_i_attack]);
        assert_eq!(type_i_edges.len(), 3);
        let type_i = DenseHallGraph::new(1, q23_type_i_labels.len() as u32, type_i_edges).unwrap();
        let result = solve_hall(&type_i, &mut workspace).unwrap();
        assert!(result.is_saturated());

        let q23_type_ii_labels = [[20, 17], [22, 20]];
        let type_ii_attack = [([8, 20], true)];
        let type_ii_edges =
            projective_charge_edges::<23>([20, 17], &q23_type_ii_labels, &[&type_ii_attack]);
        assert_eq!(type_ii_edges, [(0, 0)]);
        let type_ii = DenseHallGraph::new(1, 2, type_ii_edges).unwrap();
        let result = solve_hall(&type_ii, &mut workspace).unwrap();
        assert!(result.is_saturated());
        // Type III has the identical local state and causal move.
    }

    #[test]
    fn c80_bounded_q11_scout_extracts_a_projective_hall_deficit() {
        let old_labels = [[4, 9], [6, 1]];
        let first = [([6, 1], false), ([10, 10], true)];
        let second = [([3, 8], true), ([6, 1], false)];
        let edges = projective_charge_edges::<11>([6, 1], &old_labels, &[&first, &second]);
        assert_eq!(edges, [(0, 1), (1, 1)]);
        let graph = DenseHallGraph::new(2, 2, edges).unwrap();
        let mut workspace = HallWorkspace::new(2, 2).unwrap();
        let result = solve_hall(&graph, &mut workspace).unwrap();
        assert!(!result.is_saturated());
        assert_eq!(result.deficiency(), 1);
        assert!(result.deficient_left_contains(0));
        assert!(result.deficient_left_contains(1));
        assert!(result.deficient_right_contains(1));
        verify_hall_result(&graph, &result).unwrap();
    }
}
