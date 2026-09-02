//! C80 Hall rematching driver.
//!
//! Builds the exact bipartite Hall instance
//!
//! ```text
//! genuinely new defects  ->  consumed ancestral defect labels
//! ```
//!
//! for every complete old-labelled opponent/reply exchange out of a legal
//! size-four residual grid state, under two structural edge relations:
//!
//! * `ancestral-secant`: `z -- ell` when the line `z ell` carries a point
//!   selected before the exchange;
//! * `complete`: every new defect adjacent to every consumed label, whose Hall
//!   condition collapses to `|consumed| >= |created|`.
//!
//! Every instance is solved by the shared allocation-free `hall_core`
//! workspace, which returns either a saturating assignment or the exact
//! alternating-reachable Hall-deficient set with its neighbourhood.
//!
//! The grid engine here is written from the projective line classes rather
//! than pairwise determinants, so it is an independent implementation of the
//! same rules used by the existing scouts.

use std::collections::HashMap;
use std::fs::File;
use std::io::{BufWriter, Write};
use std::path::PathBuf;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::Mutex;

use clap::Args as ClapArgs;
use ergodis_private::hall_core::{HallOutcome, HallWorkspace};
use serde::Serialize;

const WORDS: usize = 4;
const MAXQ: usize = 16;

#[derive(Clone, Copy, Debug, Default, Eq, Ord, PartialEq, PartialOrd)]
struct Bits {
    words: [u64; WORDS],
}

impl Bits {
    #[inline]
    fn insert(&mut self, point: u16) {
        let point = usize::from(point);
        self.words[point >> 6] |= 1u64 << (point & 63);
    }
    #[inline]
    fn contains(self, point: u16) -> bool {
        let point = usize::from(point);
        self.words[point >> 6] & (1u64 << (point & 63)) != 0
    }
    #[inline]
    fn difference(self, other: Self) -> Self {
        let mut out = Self::default();
        for index in 0..WORDS {
            out.words[index] = self.words[index] & !other.words[index];
        }
        out
    }
    #[inline]
    fn count(self) -> u32 {
        self.words.iter().map(|word| word.count_ones()).sum()
    }
    #[inline]
    fn is_empty(self) -> bool {
        self.words.iter().all(|word| *word == 0)
    }
    #[inline]
    fn next(self, after: usize) -> Option<u16> {
        let mut index = after >> 6;
        if index >= WORDS {
            return None;
        }
        let mut word = self.words[index] & (!0u64 << (after & 63));
        loop {
            if word != 0 {
                return u16::try_from((index << 6) + word.trailing_zeros() as usize).ok();
            }
            index += 1;
            if index == WORDS {
                return None;
            }
            word = self.words[index];
        }
    }
    fn to_pairs(self, q: u16) -> Vec<[u16; 2]> {
        let mut out = Vec::new();
        let mut cursor = self.next(0);
        while let Some(point) = cursor {
            out.push([point / q, point % q]);
            cursor = self.next(usize::from(point) + 1);
        }
        out
    }
}

/// Precomputed projective line classes of the residual `q x q` grid.
struct Grid {
    q: u16,
    points: u16,
    /// `class[slope][point]` is the intercept `y - slope * x (mod q)`.
    class: Vec<[u8; MAXQ]>,
}

impl Grid {
    fn new(q: u16) -> Self {
        let points = q * q;
        let mut class = vec![[0u8; MAXQ]; usize::from(points)];
        for point in 0..points {
            let x = i32::from(point / q);
            let y = i32::from(point % q);
            for slope in 0..i32::from(q) {
                class[usize::from(point)][slope as usize] =
                    ((y - slope * x).rem_euclid(i32::from(q))) as u8;
            }
        }
        Self { q, points, class }
    }
}

/// Incremental residual position: selected set plus per-line occupancy.
#[derive(Clone)]
struct Position {
    selected: Bits,
    rows: u32,
    cols: u32,
    /// `load[slope][intercept]` counts selected points, slopes `1..q`.
    load: [[u8; MAXQ]; MAXQ],
}

impl Position {
    fn empty() -> Self {
        Self {
            selected: Bits::default(),
            rows: 0,
            cols: 0,
            load: [[0u8; MAXQ]; MAXQ],
        }
    }

    #[inline]
    fn insert(&mut self, grid: &Grid, point: u16) {
        self.selected.insert(point);
        self.rows |= 1u32 << (point / grid.q);
        self.cols |= 1u32 << (point % grid.q);
        let classes = &grid.class[usize::from(point)];
        // The index is the pencil slope, and it selects a row of `load` as well
        // as an entry of `classes`; iterating one of them hides that pairing.
        #[allow(clippy::needless_range_loop)]
        for slope in 1..usize::from(grid.q) {
            self.load[slope][usize::from(classes[slope])] += 1;
        }
    }

    fn with(&self, grid: &Grid, point: u16) -> Self {
        let mut next = self.clone();
        next.insert(grid, point);
        next
    }

    #[inline]
    fn legal_point(&self, grid: &Grid, point: u16) -> bool {
        if self.selected.contains(point) {
            return false;
        }
        if self.rows & (1u32 << (point / grid.q)) != 0 {
            return false;
        }
        if self.cols & (1u32 << (point % grid.q)) != 0 {
            return false;
        }
        let classes = &grid.class[usize::from(point)];
        // Same slope-indexed pairing of `load` with `classes` as above.
        #[allow(clippy::needless_range_loop)]
        for slope in 1..usize::from(grid.q) {
            if self.load[slope][usize::from(classes[slope])] >= 2 {
                return false;
            }
        }
        true
    }

    fn legal(&self, grid: &Grid) -> Bits {
        let mut out = Bits::default();
        for point in 0..grid.points {
            if self.legal_point(grid, point) {
                out.insert(point);
            }
        }
        out
    }

    /// Total capacity-two overload of the empty slope lines.
    fn omega(&self, grid: &Grid, legal: Bits) -> u32 {
        let mut counts = [[0u16; MAXQ]; MAXQ];
        let mut cursor = legal.next(0);
        while let Some(point) = cursor {
            let classes = &grid.class[usize::from(point)];
            for slope in 1..usize::from(grid.q) {
                counts[slope][usize::from(classes[slope])] += 1;
            }
            cursor = legal.next(usize::from(point) + 1);
        }
        let mut total = 0u32;
        // `slope` and `intercept` name the line coordinates and index both
        // `load` and `counts`; the pair of indices is the point of the scan.
        #[allow(clippy::needless_range_loop)]
        for slope in 1..usize::from(grid.q) {
            for intercept in 0..usize::from(grid.q) {
                if self.load[slope][intercept] == 0 {
                    total += u32::from(counts[slope][intercept].saturating_sub(2));
                }
            }
        }
        total
    }

    fn is_small_boundary(&self, grid: &Grid) -> bool {
        let legal = self.legal(grid);
        let count = legal.count();
        if count != 0 && count != 2 {
            return false;
        }
        if self.omega(grid, legal) != 0 {
            return false;
        }
        if count == 0 {
            return true;
        }
        let left = legal.next(0).expect("two legal points");
        let right = legal.next(usize::from(left) + 1).expect("two legal points");
        self.with(grid, left).legal_point(grid, right)
    }

    /// Legal opponents with no reply reaching the small boundary.
    fn defects(&self, grid: &Grid) -> Bits {
        let mut out = Bits::default();
        let legal = self.legal(grid);
        let mut opponent = legal.next(0);
        while let Some(candidate) = opponent {
            let child = self.with(grid, candidate);
            let replies = child.legal(grid);
            let mut certified = false;
            let mut reply = replies.next(0);
            while let Some(response) = reply {
                if child.with(grid, response).is_small_boundary(grid) {
                    certified = true;
                    break;
                }
                reply = replies.next(usize::from(response) + 1);
            }
            if !certified {
                out.insert(candidate);
            }
            opponent = legal.next(usize::from(candidate) + 1);
        }
        out
    }
}

/// Node--Kayles Grundy value of the full legal-point conflict graph.
///
/// Under `Omega = 0` this is the `Y_NK` boundary value: the position is P
/// exactly when the value is zero, so it decides `K_Omega` membership in the
/// base case.
fn boundary_grundy(grid: &Grid, position: &Position, cap: usize) -> Option<u32> {
    let legal = position.legal(grid);
    let mut cells = Vec::new();
    let mut cursor = legal.next(0);
    while let Some(point) = cursor {
        cells.push(point);
        cursor = legal.next(usize::from(point) + 1);
    }
    if cells.len() > cap {
        return None;
    }
    let mut adjacency = vec![0u64; cells.len()];
    for (index, &point) in cells.iter().enumerate() {
        let after = position.with(grid, point);
        for (other, &candidate) in cells.iter().enumerate().skip(index + 1) {
            if !after.legal_point(grid, candidate) {
                adjacency[index] |= 1u64 << other;
                adjacency[other] |= 1u64 << index;
            }
        }
    }
    let mut memo: HashMap<u64, u32> = HashMap::new();
    fn grundy(vertices: u64, adjacency: &[u64], memo: &mut HashMap<u64, u32>) -> u32 {
        if vertices == 0 {
            return 0;
        }
        if let Some(&value) = memo.get(&vertices) {
            return value;
        }
        let mut seen = 0u64;
        let mut remaining = vertices;
        while remaining != 0 {
            let low = remaining & remaining.wrapping_neg();
            let vertex = low.trailing_zeros() as usize;
            let value = grundy(vertices & !(low | adjacency[vertex]), adjacency, memo);
            if value < 64 {
                seen |= 1u64 << value;
            }
            remaining ^= low;
        }
        let result = seen.trailing_ones();
        memo.insert(vertices, result);
        result
    }
    let full = if cells.is_empty() {
        0
    } else {
        (1u64 << cells.len()) - 1
    };
    Some(grundy(full, &adjacency, &mut memo))
}

#[derive(Clone, Copy, Debug, Default, Serialize)]
struct Metrics {
    states: u64,
    complete_exchanges: u64,
    exchanges_with_new_defects: u64,
    new_defects: u64,
    maximum_new_defects: u32,
    /// `|consumed| <= |created|`: the complete relation saturates but the
    /// support cardinality does not strictly descend.
    nondecreasing_exchanges: u64,
    /// `|consumed| < |created|`: the complete relation is Hall-deficient.
    complete_relation_failures: u64,
    support_first_lex_failures: u64,
    omega_first_lex_failures: u64,
    ancestral_secant_edges: u64,
    ancestral_secant_zero_degree_defects: u64,
    ancestral_secant_hall_failures: u64,
    /// Hall failures split by `Omega(state) > 0` and strict `Omega` descent.
    failures_state_omega_zero: u64,
    failures_no_omega_descent: u64,
    /// Failures passing both cheap admission necessities.
    failures_admission_candidates: u64,
    /// Candidates whose successor has `Omega = 0`.
    candidates_successor_omega_zero: u64,
    /// Candidates whose successor is a `Y_NK` (Grundy-zero) boundary point,
    /// hence in `K_Omega`.
    candidates_successor_ynk_zero: u64,
    /// Candidates whose successor Grundy was above the vertex cap.
    candidates_successor_grundy_unknown: u64,
    /// Candidates whose successor has `Omega > 0` (deferred to Python).
    candidates_successor_omega_positive: u64,
    /// Over every new-defect exchange: successors with `Omega = 0`.
    successor_omega_zero: u64,
    /// Over every new-defect exchange: successors with `Omega = 0` and
    /// Node--Kayles Grundy zero, i.e. inside the `Y_NK` base boundary of
    /// `K_Omega`.
    successor_ynk_zero: u64,
    /// Over every new-defect exchange: successors with `Omega > 0`, whose
    /// `K_Omega` membership needs the recursion.
    successor_omega_positive: u64,
    /// Over every new-defect exchange: successors whose `Omega = 0` Grundy
    /// decision exceeded the vertex cap.
    successor_grundy_unknown: u64,
    /// Equality exchanges (`|consumed| = |created| >= 1`) with `Omega = 0`
    /// successors, and of those the ones inside the `Y_NK` base boundary.
    equality_successor_omega_zero: u64,
    equality_successor_ynk_zero: u64,
    equality_successor_omega_positive: u64,
    /// Ancestral-secant deficient-set shapes.
    deficient_left_one: u64,
    deficient_left_two_or_more: u64,
}

impl Metrics {
    fn merge(&mut self, other: &Metrics) {
        self.states += other.states;
        self.complete_exchanges += other.complete_exchanges;
        self.exchanges_with_new_defects += other.exchanges_with_new_defects;
        self.new_defects += other.new_defects;
        self.maximum_new_defects = self.maximum_new_defects.max(other.maximum_new_defects);
        self.nondecreasing_exchanges += other.nondecreasing_exchanges;
        self.complete_relation_failures += other.complete_relation_failures;
        self.support_first_lex_failures += other.support_first_lex_failures;
        self.omega_first_lex_failures += other.omega_first_lex_failures;
        self.ancestral_secant_edges += other.ancestral_secant_edges;
        self.ancestral_secant_zero_degree_defects += other.ancestral_secant_zero_degree_defects;
        self.ancestral_secant_hall_failures += other.ancestral_secant_hall_failures;
        self.failures_state_omega_zero += other.failures_state_omega_zero;
        self.failures_no_omega_descent += other.failures_no_omega_descent;
        self.failures_admission_candidates += other.failures_admission_candidates;
        self.candidates_successor_omega_zero += other.candidates_successor_omega_zero;
        self.candidates_successor_ynk_zero += other.candidates_successor_ynk_zero;
        self.candidates_successor_grundy_unknown += other.candidates_successor_grundy_unknown;
        self.candidates_successor_omega_positive += other.candidates_successor_omega_positive;
        self.successor_omega_zero += other.successor_omega_zero;
        self.successor_ynk_zero += other.successor_ynk_zero;
        self.successor_omega_positive += other.successor_omega_positive;
        self.successor_grundy_unknown += other.successor_grundy_unknown;
        self.equality_successor_omega_zero += other.equality_successor_omega_zero;
        self.equality_successor_ynk_zero += other.equality_successor_ynk_zero;
        self.equality_successor_omega_positive += other.equality_successor_omega_positive;
        self.deficient_left_one += other.deficient_left_one;
        self.deficient_left_two_or_more += other.deficient_left_two_or_more;
    }
}

#[derive(Clone, Serialize)]
struct FailureRecord {
    state: Vec<[u16; 2]>,
    opponent: [u16; 2],
    causal: [u16; 2],
    old_defects: Vec<[u16; 2]>,
    half_defects: Vec<[u16; 2]>,
    next_defects: Vec<[u16; 2]>,
    created: Vec<[u16; 2]>,
    consumed: Vec<[u16; 2]>,
    /// Ancestral-secant neighbourhood of each new defect, as ranks into
    /// `consumed`.
    neighbours: Vec<Vec<u32>>,
    /// Alternating-reachable Hall-deficient left set (ranks into `created`).
    deficient_left: Vec<u32>,
    /// Its exact neighbourhood (ranks into `consumed`).
    deficient_right: Vec<u32>,
    omega: [u32; 3],
    charged_support: [u32; 2],
    omega_descends: bool,
    successor_omega_zero: bool,
    successor_boundary_grundy: Option<u32>,
    successor_is_small_boundary: bool,
    admission_candidate: bool,
}

struct Worker {
    hall: HallWorkspace,
    offsets: Vec<u32>,
    neighbors: Vec<u32>,
}

impl Worker {
    fn new(points: usize) -> Self {
        Self {
            hall: HallWorkspace::new(points, points),
            offsets: Vec::with_capacity(points + 1),
            neighbors: Vec::with_capacity(points * points),
        }
    }

    /// Ancestral-secant relation: `z -- ell` when some point selected before
    /// the exchange lies on the line `z ell`.
    fn ancestral_secant(
        &mut self,
        grid: &Grid,
        state: Bits,
        created: Bits,
        consumed: Bits,
    ) -> (HallOutcome, u64, u64) {
        self.offsets.clear();
        self.neighbors.clear();
        self.offsets.push(0);
        let mut zero_degree = 0u64;
        let mut defect = created.next(0);
        while let Some(new_defect) = defect {
            let begin = self.neighbors.len();
            let mut rank = 0u32;
            let mut label = consumed.next(0);
            while let Some(old_label) = label {
                let mut carrier = state.next(0);
                let mut adjacent = false;
                while let Some(selected) = carrier {
                    if selected != new_defect
                        && selected != old_label
                        && collinear(grid, new_defect, old_label, selected)
                    {
                        adjacent = true;
                        break;
                    }
                    carrier = state.next(usize::from(selected) + 1);
                }
                if adjacent {
                    self.neighbors.push(rank);
                }
                rank += 1;
                label = consumed.next(usize::from(old_label) + 1);
            }
            if self.neighbors.len() == begin {
                zero_degree += 1;
            }
            self.offsets.push(self.neighbors.len() as u32);
            defect = created.next(usize::from(new_defect) + 1);
        }
        let edges = self.neighbors.len() as u64;
        let outcome = self
            .hall
            .solve(
                created.count() as usize,
                consumed.count() as usize,
                &self.offsets,
                &self.neighbors,
            )
            .expect("compiled Hall graph is valid");
        (outcome, edges, zero_degree)
    }
}

#[inline]
fn collinear(grid: &Grid, a: u16, b: u16, c: u16) -> bool {
    let (ax, ay) = (i32::from(a / grid.q), i32::from(a % grid.q));
    let (bx, by) = (i32::from(b / grid.q), i32::from(b % grid.q));
    let (cx, cy) = (i32::from(c / grid.q), i32::from(c % grid.q));
    ((bx - ax) * (cy - ay) - (by - ay) * (cx - ax)).rem_euclid(i32::from(grid.q)) == 0
}

/// Canonical exchange key: the pre-exchange selected set, then the opponent
/// and the causal reply, in word-lexicographic bitset order.
type ExchangeKey = (Bits, u16, u16);

struct Collector {
    metrics: Metrics,
    first_failure: Option<(Bits, u16, u16, FailureRecord)>,
    /// The globally smallest `candidate_cap` admission candidates in
    /// `ExchangeKey` order, kept sorted. Selecting by key rather than by
    /// arrival makes the retained set independent of how the enumeration is
    /// split across threads, so the emitted summary is byte-reproducible.
    candidates: Vec<(ExchangeKey, FailureRecord)>,
    candidate_cap: usize,
}

impl Collector {
    fn new(candidate_cap: usize) -> Self {
        Self {
            metrics: Metrics::default(),
            first_failure: None,
            candidates: Vec::new(),
            candidate_cap,
        }
    }

    fn offer(&mut self, key: ExchangeKey, record: FailureRecord) {
        if self.candidate_cap == 0 {
            return;
        }
        let position = self.candidates.partition_point(|entry| entry.0 < key);
        if position >= self.candidate_cap {
            return;
        }
        self.candidates.insert(position, (key, record));
        self.candidates.truncate(self.candidate_cap);
    }

    fn merge(&mut self, other: Collector) {
        self.metrics.merge(&other.metrics);
        match (&self.first_failure, &other.first_failure) {
            (None, Some(_)) => self.first_failure = other.first_failure.clone(),
            (Some(mine), Some(theirs)) => {
                if (theirs.0, theirs.1, theirs.2) < (mine.0, mine.1, mine.2) {
                    self.first_failure = other.first_failure.clone();
                }
            }
            _ => {}
        }
        for (key, record) in other.candidates {
            self.offer(key, record);
        }
    }
}

#[allow(clippy::too_many_lines)]
fn scan_state(
    grid: &Grid,
    state_points: &[u16],
    worker: &mut Worker,
    collector: &mut Collector,
    grundy_cap: usize,
    full_admission: bool,
) {
    let mut position = Position::empty();
    for &point in state_points {
        position.insert(grid, point);
    }
    let state = position.selected;
    collector.metrics.states += 1;

    let old_defects = position.defects(grid);
    if old_defects.is_empty() {
        return;
    }
    let old_support = old_defects.count();
    let state_legal = position.legal(grid);
    let old_omega = position.omega(grid, state_legal);

    let mut opponent = old_defects.next(0);
    while let Some(first) = opponent {
        let child = position.with(grid, first);
        let half_defects = child.defects(grid);
        let child_legal = child.legal(grid);
        let child_omega = child.omega(grid, child_legal);
        let mut causal = child_legal.next(0);
        while let Some(second) = causal {
            if old_defects.contains(second) {
                collector.metrics.complete_exchanges += 1;
                let successor = child.with(grid, second);
                let next_defects = successor.defects(grid);
                let created = next_defects
                    .difference(half_defects)
                    .difference(old_defects);
                if !created.is_empty() {
                    let consumed = old_defects.difference(next_defects);
                    let created_count = created.count();
                    let consumed_count = consumed.count();
                    collector.metrics.exchanges_with_new_defects += 1;
                    collector.metrics.new_defects += u64::from(created_count);
                    collector.metrics.maximum_new_defects =
                        collector.metrics.maximum_new_defects.max(created_count);
                    if consumed_count <= created_count {
                        collector.metrics.nondecreasing_exchanges += 1;
                    }
                    if consumed_count < created_count {
                        collector.metrics.complete_relation_failures += 1;
                    }
                    let (outcome, edges, zero_degree) =
                        worker.ancestral_secant(grid, state, created, consumed);
                    collector.metrics.ancestral_secant_edges += edges;
                    collector.metrics.ancestral_secant_zero_degree_defects += zero_degree;

                    let next_support = next_defects.count();
                    let successor_legal = successor.legal(grid);
                    let next_omega = successor.omega(grid, successor_legal);
                    if (next_support, next_omega) >= (old_support, old_omega) {
                        collector.metrics.support_first_lex_failures += 1;
                    }
                    if (next_omega, next_support) >= (old_omega, old_support) {
                        collector.metrics.omega_first_lex_failures += 1;
                    }

                    let mut shared_grundy = None;
                    if full_admission {
                        if next_omega == 0 {
                            collector.metrics.successor_omega_zero += 1;
                            shared_grundy = boundary_grundy(grid, &successor, grundy_cap);
                            match shared_grundy {
                                Some(0) => collector.metrics.successor_ynk_zero += 1,
                                Some(_) => {}
                                None => collector.metrics.successor_grundy_unknown += 1,
                            }
                        } else {
                            collector.metrics.successor_omega_positive += 1;
                        }
                        if consumed_count == created_count {
                            if next_omega == 0 {
                                collector.metrics.equality_successor_omega_zero += 1;
                                if shared_grundy == Some(0) {
                                    collector.metrics.equality_successor_ynk_zero += 1;
                                }
                            } else {
                                collector.metrics.equality_successor_omega_positive += 1;
                            }
                        }
                    }

                    if let HallOutcome::Deficient { left_size, .. } = outcome {
                        if left_size <= 1 {
                            collector.metrics.deficient_left_one += 1;
                        } else {
                            collector.metrics.deficient_left_two_or_more += 1;
                        }
                        collector.metrics.ancestral_secant_hall_failures += 1;
                        let omega_descends = next_omega < old_omega;
                        if old_omega == 0 {
                            collector.metrics.failures_state_omega_zero += 1;
                        }
                        if !omega_descends {
                            collector.metrics.failures_no_omega_descent += 1;
                        }
                        let candidate = old_omega > 0 && omega_descends;
                        let mut successor_grundy = None;
                        if candidate {
                            collector.metrics.failures_admission_candidates += 1;
                            if next_omega == 0 {
                                collector.metrics.candidates_successor_omega_zero += 1;
                                successor_grundy = if full_admission {
                                    shared_grundy
                                } else {
                                    boundary_grundy(grid, &successor, grundy_cap)
                                };
                                match successor_grundy {
                                    Some(0) => {
                                        collector.metrics.candidates_successor_ynk_zero += 1;
                                    }
                                    Some(_) => {}
                                    None => {
                                        collector.metrics.candidates_successor_grundy_unknown += 1;
                                    }
                                }
                            } else {
                                collector.metrics.candidates_successor_omega_positive += 1;
                            }
                        }
                        let need_record = candidate || collector.first_failure.is_none();
                        if need_record {
                            let mut neighbours = Vec::new();
                            for index in 0..created_count as usize {
                                let begin = worker.offsets[index] as usize;
                                let end = worker.offsets[index + 1] as usize;
                                neighbours.push(worker.neighbors[begin..end].to_vec());
                            }
                            let record = FailureRecord {
                                state: state.to_pairs(grid.q),
                                opponent: [first / grid.q, first % grid.q],
                                causal: [second / grid.q, second % grid.q],
                                old_defects: old_defects.to_pairs(grid.q),
                                half_defects: half_defects.to_pairs(grid.q),
                                next_defects: next_defects.to_pairs(grid.q),
                                created: created.to_pairs(grid.q),
                                consumed: consumed.to_pairs(grid.q),
                                neighbours,
                                deficient_left: worker.hall.deficient_left().to_vec(),
                                deficient_right: worker.hall.deficient_right().to_vec(),
                                omega: [old_omega, child_omega, next_omega],
                                charged_support: [old_support, next_support],
                                omega_descends,
                                successor_omega_zero: next_omega == 0,
                                successor_boundary_grundy: successor_grundy,
                                successor_is_small_boundary: successor.is_small_boundary(grid),
                                admission_candidate: candidate,
                            };
                            let key = (state, first, second);
                            let replace = match &collector.first_failure {
                                None => true,
                                Some(existing) => key < (existing.0, existing.1, existing.2),
                            };
                            if replace {
                                collector.first_failure =
                                    Some((state, first, second, record.clone()));
                            }
                            if candidate {
                                collector.offer(key, record);
                            }
                        }
                    }
                }
            }
            causal = child_legal.next(usize::from(second) + 1);
        }
        opponent = old_defects.next(usize::from(first) + 1);
    }
}

#[derive(Clone, Copy)]
struct XorShift64(u64);

impl XorShift64 {
    fn new(seed: u64) -> Self {
        Self(seed.max(1))
    }
    fn next(&mut self) -> u64 {
        let mut value = self.0;
        value ^= value << 13;
        value ^= value >> 7;
        value ^= value << 17;
        self.0 = value;
        value
    }
}

/// Reproduces the published deterministic scout sample exactly.
fn sampled_roots(grid: &Grid, budget: usize, seed: u64) -> Vec<[u16; 4]> {
    let mut rng = XorShift64::new(seed);
    let mut roots: Vec<[u16; 4]> = Vec::with_capacity(budget);
    let mut seen: Vec<Bits> = Vec::with_capacity(budget);
    let mut attempts = 0usize;
    while roots.len() < budget && attempts < budget.saturating_mul(20) {
        attempts += 1;
        let mut position = Position::empty();
        let mut chosen = Vec::new();
        for _ in 0..4 {
            let legal = position.legal(grid);
            let count = legal.count();
            if count == 0 {
                break;
            }
            let mut rank = (rng.next() % u64::from(count)) as u32;
            let mut cursor = legal.next(0);
            let mut picked = None;
            while let Some(point) = cursor {
                if rank == 0 {
                    picked = Some(point);
                    break;
                }
                rank -= 1;
                cursor = legal.next(usize::from(point) + 1);
            }
            let point = picked.expect("rank is in range");
            position.insert(grid, point);
            chosen.push(point);
        }
        if chosen.len() == 4 && !seen.contains(&position.selected) {
            seen.push(position.selected);
            chosen.sort_unstable();
            roots.push([chosen[0], chosen[1], chosen[2], chosen[3]]);
        }
    }
    roots.sort_unstable();
    roots
}

#[derive(ClapArgs)]
pub struct Arguments {
    #[arg(long, default_value_t = 11)]
    q: u16,
    /// Sampled deterministic roots; omit with `--exhaustive`.
    #[arg(long, default_value_t = 1000)]
    states: usize,
    #[arg(long, default_value_t = 98_508_030)]
    seed: u64,
    /// Enumerate every legal size-four residual state instead of sampling.
    #[arg(long, default_value_t = false)]
    exhaustive: bool,
    #[arg(long, default_value_t = 16)]
    threads: usize,
    /// Vertex cap for the successor Node--Kayles Grundy decision.
    #[arg(long, default_value_t = 26)]
    grundy_cap: usize,
    #[arg(long, default_value_t = 512)]
    candidate_cap: usize,
    /// Decide the `Y_NK` base boundary for every new-defect exchange, not only
    /// for ancestral-secant Hall failures.
    #[arg(long, default_value_t = false)]
    full_admission: bool,
    /// Omit the wall-clock field so the summary is byte-reproducible.
    #[arg(long, default_value_t = false)]
    deterministic: bool,
    #[arg(long)]
    summary: Option<PathBuf>,
    #[arg(long)]
    failures: Option<PathBuf>,
}

#[derive(Serialize)]
struct Summary {
    schema: &'static str,
    q: u16,
    mode: &'static str,
    states_requested: usize,
    #[serde(skip_serializing_if = "Option::is_none")]
    seed: Option<u64>,
    threads: usize,
    grundy_cap: usize,
    candidate_cap: usize,
    admission_candidates_truncated: bool,
    full_admission: bool,
    #[serde(skip_serializing_if = "Option::is_none")]
    elapsed_seconds: Option<f64>,
    metrics: Metrics,
    first_failure: Option<FailureRecord>,
    admission_candidates: Vec<FailureRecord>,
}

pub fn run(arguments: Arguments) -> anyhow::Result<()> {
    anyhow::ensure!(arguments.threads > 0, "thread count must be positive");
    anyhow::ensure!(
        (3..=13).contains(&arguments.q),
        "this driver covers prime orders 3 through 13"
    );
    let grid = Grid::new(arguments.q);
    let started = std::time::Instant::now();

    let shared = Mutex::new(Collector::new(arguments.candidate_cap));

    if arguments.exhaustive {
        // Partition the exhaustive size-four enumeration by the first two
        // selected points; the remaining two are enumerated in rank order.
        let mut tasks: Vec<(u16, u16)> = Vec::new();
        let empty = Position::empty();
        for first in 0..grid.points {
            let after_first = empty.with(&grid, first);
            for second in (first + 1)..grid.points {
                if after_first.legal_point(&grid, second) {
                    tasks.push((first, second));
                }
            }
        }
        let cursor = AtomicUsize::new(0);
        std::thread::scope(|scope| {
            for _ in 0..arguments.threads {
                scope.spawn(|| {
                    let mut worker = Worker::new(usize::from(grid.points));
                    let mut local = Collector::new(arguments.candidate_cap);
                    loop {
                        let index = cursor.fetch_add(1, Ordering::Relaxed);
                        if index >= tasks.len() {
                            break;
                        }
                        let (first, second) = tasks[index];
                        let base = Position::empty().with(&grid, first).with(&grid, second);
                        for third in (second + 1)..grid.points {
                            if !base.legal_point(&grid, third) {
                                continue;
                            }
                            let three = base.with(&grid, third);
                            for fourth in (third + 1)..grid.points {
                                if !three.legal_point(&grid, fourth) {
                                    continue;
                                }
                                scan_state(
                                    &grid,
                                    &[first, second, third, fourth],
                                    &mut worker,
                                    &mut local,
                                    arguments.grundy_cap,
                                    arguments.full_admission,
                                );
                            }
                        }
                    }
                    shared.lock().expect("collector mutex").merge(local);
                });
            }
        });
    } else {
        let roots = sampled_roots(&grid, arguments.states, arguments.seed);
        anyhow::ensure!(
            roots.len() == arguments.states,
            "generated {} of {} requested roots",
            roots.len(),
            arguments.states
        );
        let cursor = AtomicUsize::new(0);
        std::thread::scope(|scope| {
            for _ in 0..arguments.threads {
                scope.spawn(|| {
                    let mut worker = Worker::new(usize::from(grid.points));
                    let mut local = Collector::new(arguments.candidate_cap);
                    loop {
                        let index = cursor.fetch_add(1, Ordering::Relaxed);
                        if index >= roots.len() {
                            break;
                        }
                        scan_state(
                            &grid,
                            &roots[index],
                            &mut worker,
                            &mut local,
                            arguments.grundy_cap,
                            arguments.full_admission,
                        );
                    }
                    shared.lock().expect("collector mutex").merge(local);
                });
            }
        });
    }

    let collector = shared.into_inner().expect("collector mutex");
    let summary = Summary {
        schema: "c80-hall-rematch/v2",
        q: arguments.q,
        mode: if arguments.exhaustive {
            "exhaustive-size-four"
        } else {
            "deterministic-sample"
        },
        states_requested: if arguments.exhaustive {
            0
        } else {
            arguments.states
        },
        seed: (!arguments.exhaustive).then_some(arguments.seed),
        threads: arguments.threads,
        grundy_cap: arguments.grundy_cap,
        candidate_cap: arguments.candidate_cap,
        admission_candidates_truncated: collector.metrics.failures_admission_candidates
            > collector.candidates.len() as u64,
        full_admission: arguments.full_admission,
        elapsed_seconds: if arguments.deterministic {
            None
        } else {
            Some(started.elapsed().as_secs_f64())
        },
        metrics: collector.metrics,
        first_failure: collector
            .first_failure
            .as_ref()
            .map(|entry| entry.3.clone()),
        admission_candidates: collector
            .candidates
            .iter()
            .map(|entry| entry.1.clone())
            .collect(),
    };

    if let Some(path) = &arguments.failures {
        let mut stream = BufWriter::new(File::create(path)?);
        for (_, record) in &collector.candidates {
            serde_json::to_writer(&mut stream, record)?;
            stream.write_all(b"\n")?;
        }
        stream.flush()?;
    }

    let encoded = serde_json::to_string_pretty(&summary)? + "\n";
    if let Some(path) = &arguments.summary {
        std::fs::write(path, &encoded)?;
    } else {
        print!("{encoded}");
    }
    Ok(())
}
