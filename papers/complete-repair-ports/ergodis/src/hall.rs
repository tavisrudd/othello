//! Allocation-free exact Hall matching and obstruction extraction.
//!
//! The graph is compiled once into either dense row bitmaps or a compact CSR
//! adjacency pool, chosen from measured density.  A reusable workspace then
//! decides whether every left obligation can receive a distinct right
//! resource.  Failure returns an exact set `Z` with `|N(Z)| < |Z|`.
//!
//! Both layouts run the same kernel body, expanded once per layout, so the
//! layout choice is resolved at compilation and no loop carries a
//! run-constant branch on the representation.

use std::io::{self, Read, Write};
use thiserror::Error;

#[cfg(test)]
use crate::test_alloc::HotLoopAllocationGuard;

const NONE: u32 = u32::MAX;
const CERTIFICATE_MAGIC: [u8; 8] = *b"ERGHALL1";

/// Density below which the CSR pool beats the bitmap, as a divisor: sparse is
/// chosen when the mean degree is under `right_count / SPARSE_DENSITY_DIVISOR`.
///
/// Counting adjacency traffic predicts 32, since a dense row is `right / 8`
/// bytes against a CSR row's `4 * degree`, and an interleaved A/B across
/// densities puts the neutral point at density 31 per mille, which is that
/// prediction to within one part in a thousand.  Below it the CSR scan wins by up to twelve
/// percent and the margin grows as the graph thins; above it the bitmap wins,
/// reaching thirty percent at one tenth density.  See
/// `notes/2026-09-02-c1054-hall-core-promotion.md`.
const SPARSE_DENSITY_DIVISOR: u64 = 32;

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
    #[error("left vertex count exceeds workspace capacity")]
    LeftCapacity,
    #[error("right vertex count exceeds workspace capacity")]
    RightCapacity,
    #[error("CSR offsets do not describe the left vertex set")]
    InvalidOffsets,
    #[error("CSR graph contains a right endpoint outside the declared range")]
    InvalidEndpoint,
}

/// Saturation verdict in the shape callers serialize, independent of the
/// borrowed workspace view.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum HallOutcome {
    Saturated,
    Deficient {
        left_size: usize,
        neighborhood_size: usize,
    },
}

/// Which adjacency layout a Hall graph is compiled into.
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub enum HallLayout {
    /// One `u64` bitmap row per left vertex.
    Dense,
    /// A compact CSR neighbour pool.
    Sparse,
    /// Pick from the compiled edge count against [`SPARSE_DENSITY_DIVISOR`].
    #[default]
    Auto,
}

/// Resolve [`HallLayout::Auto`] against the compiled bounds.  Sparse wins
/// exactly when the CSR pool touches less adjacency memory than the bitmap.
#[must_use]
pub fn resolve_hall_layout(
    left_count: u32,
    right_count: u32,
    edge_count: usize,
    layout: HallLayout,
) -> HallLayout {
    match layout {
        HallLayout::Auto => {
            let candidates = u64::from(left_count) * u64::from(right_count);
            if SPARSE_DENSITY_DIVISOR * (edge_count as u64) < candidates {
                HallLayout::Sparse
            } else {
                HallLayout::Dense
            }
        }
        chosen => chosen,
    }
}

/// Row scans, one per adjacency layout.
///
/// The kernel body below is written once and expanded through these, so both
/// layouts run the same algorithm while each keeps the scan loop its own
/// representation wants.  The dense expansion is the nested word/bit loop the
/// bitmap kernel had before the sparse backend existed, character for
/// character, which is what keeps its generated code unchanged.
///
/// A generic kernel over an adjacency trait was tried first, in both a
/// closure and an iterator form, and cost the dense path six and nineteen
/// percent respectively; see the rejected-variant record in
/// `notes/2026-09-02-c1054-hall-core-promotion.md`.
///
/// `$body` runs with `$right` bound to one neighbour.  `continue` skips to the
/// next neighbour and `return` leaves the enclosing function, in both
/// expansions.
macro_rules! scan_dense_row {
    ($graph:expr, $left:expr, |$right:ident| $body:block) => {
        for (word_index, &raw_word) in $graph.row($left).iter().enumerate() {
            let mut word = raw_word;
            while word != 0 {
                let bit = word.trailing_zeros();
                word &= word - 1;
                let $right = (word_index as u32) * 64 + bit;
                $body
            }
        }
    };
}

macro_rules! scan_sparse_row {
    ($graph:expr, $left:expr, |$right:ident| $body:block) => {
        for &$right in $graph.row($left) {
            $body
        }
    };
}

/// The layout's own first rejection clause, kept as the leading term of the
/// kernel's short-circuit chain.
///
/// The dense scan walks whole words, so the last word of a row can address
/// columns at or past `right_count`.  That test led the original bitmap
/// kernel's condition and is reproduced in the same position here: hoisting it
/// into the scan as a separate branch measured slower on the dense path.  A
/// validated CSR view has no such column, so its clause folds away at
/// compilation and the sparse expansion carries no range test at all.
macro_rules! dense_out_of_range {
    ($graph:expr, $right:expr) => {
        $right >= $graph.right_count
    };
}

macro_rules! sparse_out_of_range {
    ($graph:expr, $right:expr) => {
        false
    };
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

/// Bipartite graph held as a compact CSR neighbour pool.
#[derive(Clone, Debug)]
pub struct SparseHallGraph {
    left_count: u32,
    right_count: u32,
    offsets: Box<[u32]>,
    neighbors: Box<[u32]>,
}

impl SparseHallGraph {
    /// Compile an edge iterator into ascending-per-row CSR storage.
    pub fn new(
        left_count: u32,
        right_count: u32,
        edges: impl IntoIterator<Item = (u32, u32)>,
    ) -> Result<Self, HallError> {
        let mut collected: Vec<(u32, u32)> = Vec::new();
        for (left, right) in edges {
            if left >= left_count || right >= right_count {
                return Err(HallError::Edge { left, right });
            }
            collected.push((left, right));
        }
        collected.sort_unstable();
        collected.dedup();
        if collected.len() > u32::MAX as usize {
            return Err(HallError::Overflow);
        }
        let mut offsets = vec![0_u32; left_count as usize + 1];
        for &(left, _) in &collected {
            offsets[left as usize + 1] += 1;
        }
        for index in 1..offsets.len() {
            offsets[index] += offsets[index - 1];
        }
        let neighbors: Vec<u32> = collected.into_iter().map(|(_, right)| right).collect();
        Ok(Self {
            left_count,
            right_count,
            offsets: offsets.into_boxed_slice(),
            neighbors: neighbors.into_boxed_slice(),
        })
    }

    #[must_use]
    pub fn left_count(&self) -> u32 {
        self.left_count
    }

    #[must_use]
    pub fn right_count(&self) -> u32 {
        self.right_count
    }

    #[must_use]
    pub fn edge_count(&self) -> usize {
        self.neighbors.len()
    }

    #[must_use]
    pub fn view(&self) -> SparseHallView<'_> {
        SparseHallView {
            left_count: self.left_count,
            right_count: self.right_count,
            offsets: &self.offsets,
            neighbors: &self.neighbors,
        }
    }
}

/// Borrowed CSR adjacency over caller-owned storage.
///
/// This is the zero-copy entry point: callers that already hold presized
/// `offsets`/`neighbors` buffers hand them straight to the kernel rather than
/// copying them into an owned graph on every decision.
#[derive(Clone, Copy, Debug)]
pub struct SparseHallView<'a> {
    left_count: u32,
    right_count: u32,
    offsets: &'a [u32],
    neighbors: &'a [u32],
}

impl<'a> SparseHallView<'a> {
    /// Validate and wrap caller-owned CSR slices.
    pub fn new(
        left_count: u32,
        right_count: u32,
        offsets: &'a [u32],
        neighbors: &'a [u32],
    ) -> Result<Self, HallError> {
        if offsets.len() != left_count as usize + 1
            || offsets.first().copied() != Some(0)
            || offsets.last().copied() != Some(neighbors.len() as u32)
            || offsets.windows(2).any(|pair| pair[0] > pair[1])
        {
            return Err(HallError::InvalidOffsets);
        }
        if neighbors.iter().any(|&right| right >= right_count) {
            return Err(HallError::InvalidEndpoint);
        }
        Ok(Self {
            left_count,
            right_count,
            offsets,
            neighbors,
        })
    }

    #[inline]
    fn row(&self, left: u32) -> &'a [u32] {
        let begin = self.offsets[left as usize] as usize;
        let end = self.offsets[left as usize + 1] as usize;
        &self.neighbors[begin..end]
    }
}

impl SparseHallView<'_> {
    #[inline]
    #[must_use]
    pub fn contains(&self, left: u32, right: u32) -> bool {
        left < self.left_count && self.row(left).contains(&right)
    }
}

/// A compiled Hall graph in whichever layout was selected.
#[derive(Clone, Debug)]
pub enum HallGraph {
    Dense(DenseHallGraph),
    Sparse(SparseHallGraph),
}

impl HallGraph {
    /// Compile `edges` under `layout`, resolving [`HallLayout::Auto`] from the
    /// realized edge count.
    pub fn compile(
        left_count: u32,
        right_count: u32,
        edges: impl IntoIterator<Item = (u32, u32)>,
        layout: HallLayout,
    ) -> Result<Self, HallError> {
        let collected: Vec<(u32, u32)> = edges.into_iter().collect();
        match resolve_hall_layout(left_count, right_count, collected.len(), layout) {
            HallLayout::Sparse => Ok(Self::Sparse(SparseHallGraph::new(
                left_count,
                right_count,
                collected,
            )?)),
            _ => Ok(Self::Dense(DenseHallGraph::new(
                left_count,
                right_count,
                collected,
            )?)),
        }
    }

    #[must_use]
    pub fn layout(&self) -> HallLayout {
        match self {
            Self::Dense(_) => HallLayout::Dense,
            Self::Sparse(_) => HallLayout::Sparse,
        }
    }

    #[must_use]
    pub fn left_count(&self) -> u32 {
        match self {
            Self::Dense(graph) => graph.left_count,
            Self::Sparse(graph) => graph.left_count,
        }
    }

    #[must_use]
    pub fn right_count(&self) -> u32 {
        match self {
            Self::Dense(graph) => graph.right_count,
            Self::Sparse(graph) => graph.right_count,
        }
    }

    #[must_use]
    pub fn contains(&self, left: u32, right: u32) -> bool {
        match self {
            Self::Dense(graph) => graph.contains(left, right),
            Self::Sparse(graph) => graph.view().contains(left, right),
        }
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
    deficient_left_len: usize,
    deficient_right_len: usize,
    solved_left_count: usize,
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
            deficient_left_len: 0,
            deficient_right_len: 0,
            solved_left_count: 0,
            epoch: 0,
        })
    }

    #[must_use]
    pub fn max_left(&self) -> u32 {
        self.max_left
    }

    #[must_use]
    pub fn max_right(&self) -> u32 {
        self.max_right
    }

    /// Matched right resource per left vertex from the last solve, `u32::MAX`
    /// where unmatched.  Valid until the workspace is reused.
    #[must_use]
    pub fn matching(&self) -> &[u32] {
        &self.left_match[..self.solved_left_count]
    }

    /// Ascending left vertices of the last extracted deficient set.
    ///
    /// The list occupies the front of the search queue, which is dead once the
    /// alternating sweep has finished; see [`alternating_deficiency`].
    #[must_use]
    pub fn deficient_left_indices(&self) -> &[u32] {
        &self.queue[..self.deficient_left_len]
    }

    /// Ascending right vertices of the exact neighbourhood of that set.
    ///
    /// The list occupies the front of the alternating-path parent array, which
    /// is likewise dead after the sweep.
    #[must_use]
    pub fn deficient_right_indices(&self) -> &[u32] {
        &self.parent_right[..self.deficient_right_len]
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

    /// The serializable verdict, independent of the borrowed bitmaps.
    pub fn outcome(&self) -> HallOutcome {
        if self.is_saturated() {
            HallOutcome::Saturated
        } else {
            HallOutcome::Deficient {
                left_size: self.deficient_left_count as usize,
                neighborhood_size: self.deficient_right_count as usize,
            }
        }
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
    solve_dense(graph, workspace)
}

/// Decide Hall saturation over caller-owned CSR adjacency, copying nothing.
pub fn solve_hall_sparse<'a>(
    graph: SparseHallView<'_>,
    workspace: &'a mut HallWorkspace,
) -> Result<HallResult<'a>, HallError> {
    solve_sparse(&graph, workspace)
}

/// Decide Hall saturation over a graph compiled in either layout.
pub fn solve_hall_graph<'a>(
    graph: &HallGraph,
    workspace: &'a mut HallWorkspace,
) -> Result<HallResult<'a>, HallError> {
    match graph {
        HallGraph::Dense(dense) => solve_dense(dense, workspace),
        HallGraph::Sparse(sparse) => solve_sparse(&sparse.view(), workspace),
    }
}

/// The kernel, expanded once per adjacency layout.
///
/// Generates the solve entry point, the breadth-first augmentation, the
/// alternating-reachability sweep that extracts the exact deficient set, and
/// the independent verifier, all from one body, with `$scan` supplying the
/// row loop.  Each expansion is straight-line code over its own
/// representation: no trait object, no closure, and no run-constant branch on
/// the layout inside any loop.
macro_rules! hall_kernel {
    ($solve:ident, $augment:ident, $deficiency:ident, $verify:ident, $graph:ty, $scan:ident, $out_of_range:ident) => {
        fn $solve<'a>(
            graph: &$graph,
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
                if $augment(graph, workspace, root) {
                    cardinality += 1;
                }
            }

            let left_words = left_count.div_ceil(64);
            let right_words = right_count.div_ceil(64);
            workspace.deficient_left[..left_words].fill(0);
            workspace.deficient_right[..right_words].fill(0);
            let (deficient_left_count, deficient_right_count) = if cardinality == graph.left_count {
                workspace.deficient_left_len = 0;
                workspace.deficient_right_len = 0;
                (0, 0)
            } else {
                $deficiency(graph, workspace)
            };
            workspace.solved_left_count = left_count;

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

        fn $augment(graph: &$graph, workspace: &mut HallWorkspace, root: u32) -> bool {
            let epoch = workspace.next_epoch();
            workspace.left_seen[root as usize] = epoch;
            workspace.queue[0] = root;
            let mut head = 0_usize;
            let mut tail = 1_usize;
            while head < tail {
                let left = workspace.queue[head];
                head += 1;
                $scan!(graph, left, |right| {
                    if $out_of_range!(graph, right)
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
                });
            }
            false
        }

        /// Outlined deliberately.  This sweep runs at most once per solve, only
        /// when the matching failed, and letting it inline grew the augmenting
        /// loop's code enough to cost that loop four percent even on inputs
        /// that never reach here.
        #[inline(never)]
        fn $deficiency(graph: &$graph, workspace: &mut HallWorkspace) -> (u32, u32) {
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
                $scan!(graph, left, |right| {
                    if $out_of_range!(graph, right)
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
                });
            }

            // The sweep above has drained its queue and will not read
            // `parent_right` again before the next solve resets both, so the
            // two ascending index lists are compacted into the front of those
            // existing presized buffers rather than into storage of their own.
            // `left_total` never exceeds `left` and `right_total` never
            // exceeds `right`, so each write lands at or behind the position
            // being read.
            let mut left_total = 0_u32;
            let mut right_total = 0_u32;
            for left in 0..graph.left_count {
                if workspace.left_seen[left as usize] == epoch {
                    bitmap_insert(&mut workspace.deficient_left, left);
                    workspace.queue[left_total as usize] = left;
                    left_total += 1;
                }
            }
            for right in 0..graph.right_count {
                if workspace.right_seen[right as usize] == epoch {
                    bitmap_insert(&mut workspace.deficient_right, right);
                    workspace.parent_right[right_total as usize] = right;
                    right_total += 1;
                }
            }
            workspace.deficient_left_len = left_total as usize;
            workspace.deficient_right_len = right_total as usize;
            debug_assert!(left_total > right_total);
            (left_total, right_total)
        }

        fn $verify(graph: &$graph, result: &HallResult<'_>) -> Result<(), HallError> {
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
                    $scan!(graph, left, |right| {
                        if $out_of_range!(graph, right) {
                            continue;
                        }
                        bitmap_insert(&mut exact_neighbours, right);
                    });
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
    };
}

hall_kernel!(
    solve_dense,
    augment_dense,
    deficiency_dense,
    verify_dense,
    DenseHallGraph,
    scan_dense_row,
    dense_out_of_range
);
hall_kernel!(
    solve_sparse,
    augment_sparse,
    deficiency_sparse,
    verify_sparse,
    SparseHallView<'_>,
    scan_sparse_row,
    sparse_out_of_range
);

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

/// Independently check a matching or exact Hall-deficient neighbourhood.
pub fn verify_hall_result(
    graph: &DenseHallGraph,
    result: &HallResult<'_>,
) -> Result<(), HallError> {
    verify_dense(graph, result)
}

/// Independently check a result against a graph in either layout.
pub fn verify_hall_graph_result(
    graph: &HallGraph,
    result: &HallResult<'_>,
) -> Result<(), HallError> {
    match graph {
        HallGraph::Dense(dense) => verify_dense(dense, result),
        HallGraph::Sparse(sparse) => verify_sparse(&sparse.view(), result),
    }
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

    fn next_u32(state: &mut u64) -> u32 {
        *state = state
            .wrapping_mul(6_364_136_223_846_793_005)
            .wrapping_add(1);
        (*state >> 32) as u32
    }

    /// Generated bipartite instance at a requested per-mille density, kept in
    /// both layouts plus the caller-owned CSR slices the private API uses.
    struct ParityInstance {
        left: u32,
        right: u32,
        dense: DenseHallGraph,
        sparse: SparseHallGraph,
        offsets: Vec<u32>,
        neighbors: Vec<u32>,
        edges: Vec<(u32, u32)>,
    }

    fn parity_instance(left: u32, right: u32, density_per_mille: u32, seed: u64) -> ParityInstance {
        let mut state = seed;
        let mut edges = Vec::new();
        let mut offsets = vec![0_u32];
        let mut neighbors = Vec::new();
        for source in 0..left {
            for target in 0..right {
                if next_u32(&mut state) % 1_000 < density_per_mille {
                    edges.push((source, target));
                    neighbors.push(target);
                }
            }
            offsets.push(neighbors.len() as u32);
        }
        ParityInstance {
            left,
            right,
            dense: DenseHallGraph::new(left, right, edges.iter().copied()).unwrap(),
            sparse: SparseHallGraph::new(left, right, edges.iter().copied()).unwrap(),
            offsets,
            neighbors,
            edges,
        }
    }

    fn snapshot(result: &HallResult<'_>) -> (HallOutcome, u32, Vec<u32>, Vec<u32>) {
        let deficient_left = (0..result.left_count)
            .filter(|&left| result.deficient_left_contains(left))
            .collect();
        let deficient_right = (0..result.right_count)
            .filter(|&right| result.deficient_right_contains(right))
            .collect();
        (
            result.outcome(),
            result.cardinality(),
            deficient_left,
            deficient_right,
        )
    }

    #[test]
    fn sparse_and_dense_agree_on_generated_instances_across_densities_and_sizes() {
        let mut workspace = HallWorkspace::new(96, 192).unwrap();
        let mut seed = 0x5eed_0000_0000_0001_u64;
        for &(left, right) in &[(8_u32, 8_u32), (24, 32), (64, 64), (48, 192), (96, 96)] {
            for &density in &[5_u32, 10, 20, 31, 50, 125, 250, 500, 900] {
                for trial in 0..4 {
                    seed = seed.wrapping_add(0x9e37_79b9_7f4a_7c15);
                    let instance = parity_instance(left, right, density, seed ^ trial);

                    let dense = solve_hall(&instance.dense, &mut workspace).unwrap();
                    let dense_snapshot = snapshot(&dense);
                    verify_hall_result(&instance.dense, &dense).unwrap();

                    let view = SparseHallView::new(
                        instance.left,
                        instance.right,
                        &instance.offsets,
                        &instance.neighbors,
                    )
                    .unwrap();
                    let sparse = solve_hall_sparse(view, &mut workspace).unwrap();
                    let sparse_snapshot = snapshot(&sparse);
                    let sparse_lists = (
                        workspace.deficient_left_indices().to_vec(),
                        workspace.deficient_right_indices().to_vec(),
                    );

                    let owned = solve_hall_sparse(instance.sparse.view(), &mut workspace).unwrap();
                    let owned_snapshot = snapshot(&owned);

                    let auto = HallGraph::compile(
                        instance.left,
                        instance.right,
                        instance.edges.iter().copied(),
                        HallLayout::Auto,
                    )
                    .unwrap();
                    let auto_result = solve_hall_graph(&auto, &mut workspace).unwrap();
                    let auto_snapshot = snapshot(&auto_result);
                    verify_hall_graph_result(&auto, &auto_result).unwrap();

                    let label = format!("{left}x{right}@{density} trial {trial}");
                    assert_eq!(dense_snapshot, sparse_snapshot, "borrowed CSR: {label}");
                    assert_eq!(dense_snapshot, owned_snapshot, "owned CSR: {label}");
                    assert_eq!(dense_snapshot, auto_snapshot, "auto layout: {label}");
                    assert_eq!(sparse_lists.0, dense_snapshot.2, "left list: {label}");
                    assert_eq!(sparse_lists.1, dense_snapshot.3, "right list: {label}");
                    assert_eq!(
                        auto.layout(),
                        resolve_hall_layout(left, right, instance.edges.len(), HallLayout::Auto),
                        "selector: {label}"
                    );
                }
            }
        }
    }

    #[test]
    fn the_automatic_selector_follows_the_measured_traffic_crossover() {
        // The measured neutral point is one neighbour per thirty-two right
        // vertices; below it the CSR pool wins, at and above it the bitmap does.
        assert_eq!(
            resolve_hall_layout(64, 640, 64 * 19, HallLayout::Auto),
            HallLayout::Sparse
        );
        assert_eq!(
            resolve_hall_layout(64, 640, 64 * 20, HallLayout::Auto),
            HallLayout::Dense,
            "an exact tie at one neighbour per thirty-two goes to the bitmap"
        );
        assert_eq!(
            resolve_hall_layout(64, 640, 64 * 21, HallLayout::Auto),
            HallLayout::Dense
        );
        assert_eq!(
            resolve_hall_layout(64, 640, 0, HallLayout::Dense),
            HallLayout::Dense
        );
        assert_eq!(
            resolve_hall_layout(64, 640, 64 * 640, HallLayout::Sparse),
            HallLayout::Sparse
        );
    }

    #[test]
    fn repeated_entry_into_both_backends_allocates_nothing_after_warm_up() {
        let instance = parity_instance(48, 96, 40, 0x00c1_0540_0000_0001);
        let deficient = parity_instance(48, 24, 30, 0x00c1_0540_0000_0002);
        let mut workspace = HallWorkspace::new(48, 96).unwrap();
        let view = SparseHallView::new(48, 96, &instance.offsets, &instance.neighbors).unwrap();
        let deficient_view =
            SparseHallView::new(48, 24, &deficient.offsets, &deficient.neighbors).unwrap();

        // Warm up outside the measurement so any lazy one-time setup is paid.
        for _ in 0..8 {
            solve_hall(&instance.dense, &mut workspace).unwrap();
            solve_hall_sparse(view, &mut workspace).unwrap();
            solve_hall(&deficient.dense, &mut workspace).unwrap();
            solve_hall_sparse(deficient_view, &mut workspace).unwrap();
        }

        let (checksum, events) = crate::test_alloc::measure_allocations(|| {
            let mut checksum = 0_u64;
            for _ in 0..64 {
                checksum += u64::from(
                    solve_hall(&instance.dense, &mut workspace)
                        .unwrap()
                        .cardinality(),
                );
                checksum += u64::from(
                    solve_hall_sparse(view, &mut workspace)
                        .unwrap()
                        .cardinality(),
                );
                checksum += u64::from(
                    solve_hall(&deficient.dense, &mut workspace)
                        .unwrap()
                        .deficiency(),
                );
                checksum += u64::from(
                    solve_hall_sparse(deficient_view, &mut workspace)
                        .unwrap()
                        .deficiency(),
                );
            }
            checksum
        });
        assert!(checksum > 0);
        assert_eq!(events, Default::default());
    }

    #[test]
    fn imported_private_hall_core_fixtures_reproduce_exactly() {
        // Ported verbatim from `ergodis-private::hall_core`'s own tests so the
        // promoted kernel is pinned to the private one's recorded answers.
        let mut workspace = HallWorkspace::new(4, 4).unwrap();

        let offsets = [0_u32, 2, 3, 4];
        let neighbors = [0_u32, 1, 1, 2];
        let view = SparseHallView::new(3, 3, &offsets, &neighbors).unwrap();
        let result = solve_hall_sparse(view, &mut workspace).unwrap();
        assert_eq!(result.outcome(), HallOutcome::Saturated);
        let matching = workspace.matching().to_vec();
        assert!(matching.iter().all(|&right| right != NONE));
        assert_eq!(
            matching
                .iter()
                .copied()
                .collect::<std::collections::HashSet<_>>()
                .len(),
            3
        );

        let offsets = [0_u32, 1, 2, 4, 5];
        let neighbors = [0_u32, 0, 0, 1, 2];
        let view = SparseHallView::new(4, 3, &offsets, &neighbors).unwrap();
        let result = solve_hall_sparse(view, &mut workspace).unwrap();
        assert_eq!(
            result.outcome(),
            HallOutcome::Deficient {
                left_size: 2,
                neighborhood_size: 1,
            }
        );
        assert_eq!(workspace.deficient_left_indices(), &[0, 1]);
        assert_eq!(workspace.deficient_right_indices(), &[0]);

        // The private `hall-certify` replay case.
        let offsets = [0_u32, 1, 2, 3];
        let neighbors = [0_u32, 0, 1];
        let view = SparseHallView::new(3, 2, &offsets, &neighbors).unwrap();
        let result = solve_hall_sparse(view, &mut workspace).unwrap();
        assert_eq!(
            result.outcome(),
            HallOutcome::Deficient {
                left_size: 2,
                neighborhood_size: 1,
            }
        );
        assert_eq!(workspace.deficient_left_indices(), &[0, 1]);
        assert_eq!(workspace.deficient_right_indices(), &[0]);

        assert_eq!(
            SparseHallView::new(1, 1, &[0, 1], &[1]).unwrap_err(),
            HallError::InvalidEndpoint
        );
        assert_eq!(
            SparseHallView::new(1, 2, &[0, 2], &[1]).unwrap_err(),
            HallError::InvalidOffsets
        );
    }

    #[test]
    fn exhaustive_four_by_four_csr_matches_brute_force_hall() {
        // The private kernel's exhaustive gate, re-run against the promoted
        // sparse path and cross-checked against the dense path on every graph.
        fn can_saturate(
            left: usize,
            left_count: usize,
            offsets: &[u32],
            neighbors: &[u32],
            used_right: u32,
        ) -> bool {
            if left == left_count {
                return true;
            }
            neighbors[offsets[left] as usize..offsets[left + 1] as usize]
                .iter()
                .any(|&right| {
                    used_right & (1 << right) == 0
                        && can_saturate(
                            left + 1,
                            left_count,
                            offsets,
                            neighbors,
                            used_right | (1 << right),
                        )
                })
        }

        let mut workspace = HallWorkspace::new(4, 4).unwrap();
        for graph in 0_u32..(1 << 16) {
            let mut offsets = Vec::with_capacity(5);
            let mut neighbors = Vec::with_capacity(16);
            let mut edges = Vec::with_capacity(16);
            offsets.push(0);
            for left in 0..4_u32 {
                for right in 0..4_u32 {
                    if graph & (1 << (4 * left + right)) != 0 {
                        neighbors.push(right);
                        edges.push((left, right));
                    }
                }
                offsets.push(neighbors.len() as u32);
            }
            let expected = can_saturate(0, 4, &offsets, &neighbors, 0);
            let view = SparseHallView::new(4, 4, &offsets, &neighbors).unwrap();
            let sparse = solve_hall_sparse(view, &mut workspace).unwrap();
            let sparse_snapshot = snapshot(&sparse);
            let sparse_lists = (
                workspace.deficient_left_indices().to_vec(),
                workspace.deficient_right_indices().to_vec(),
            );
            assert_eq!(
                sparse_snapshot.0 == HallOutcome::Saturated,
                expected,
                "graph={graph:#x}"
            );

            let dense = DenseHallGraph::new(4, 4, edges).unwrap();
            let dense_result = solve_hall(&dense, &mut workspace).unwrap();
            assert_eq!(snapshot(&dense_result), sparse_snapshot, "graph={graph:#x}");
            verify_hall_result(&dense, &dense_result).unwrap();

            if let HallOutcome::Deficient {
                left_size,
                neighborhood_size,
            } = sparse_snapshot.0
            {
                let mut exact_neighborhood = 0_u32;
                for &left in &sparse_lists.0 {
                    for &right in &neighbors
                        [offsets[left as usize] as usize..offsets[left as usize + 1] as usize]
                    {
                        exact_neighborhood |= 1 << right;
                    }
                }
                assert_eq!(exact_neighborhood.count_ones() as usize, neighborhood_size);
                assert_eq!(left_size, sparse_lists.0.len());
                assert!(neighborhood_size < left_size);
            }
        }
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
