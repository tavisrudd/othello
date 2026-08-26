//! Exact arithmetic pruning for the open q=27, |D|=54 defect-19 branch.
//!
//! The hot operation augments a point set `D`.  By projective duality, adding
//! one point increments the 28 contiguous line-degree entries in its pencil.
//! A cold constructor enumerates every defect-19 internal/external shell and
//! compacts it to the distinct final degree profiles used by the hot filter.

use crate::projective::ProjectivePlane;

const GF27_LINE_COUNT: usize = 757;
const GF27_TARGET_SIZE: u8 = 54;
const GF27_MAX_DEGREE: u8 = 9;
const DEGREE_BINS: usize = GF27_MAX_DEGREE as usize + 1;
const TARGET_WORDS: usize = 16;

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct DegreeTarget {
    /// `tails[d]` is the number of final lines of degree at least `d`.
    tails: [u16; DEGREE_BINS],
    _pad: [u16; 6],
}

struct ThresholdMasks {
    offsets: [u32; DEGREE_BINS],
    limits: [u16; DEGREE_BINS],
    lower: Box<[u64]>,
    upper: Box<[u64]>,
}

impl DegreeTarget {
    #[inline]
    fn supports(&self, current: &[u16; DEGREE_BINS], remaining: usize) -> bool {
        for threshold in 1..DEGREE_BINS {
            if current[threshold] > self.tails[threshold] {
                return false;
            }
            if threshold > remaining && self.tails[threshold] > current[threshold - remaining] {
                return false;
            }
        }
        true
    }
}

const _: () = assert!(std::mem::size_of::<DegreeTarget>() == 32);
const _: () = assert!(std::mem::align_of::<DegreeTarget>() == 2);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct DegreeSummary {
    counts: [u16; DEGREE_BINS],
    selected_count: u8,
    maximum_degree: u8,
    _pad: [u8; 10],
}

const _: () = assert!(std::mem::size_of::<DegreeSummary>() == 32);
const _: () = assert!(std::mem::align_of::<DegreeSummary>() == 2);

impl DegreeSummary {
    pub fn counts(&self) -> &[u16; DEGREE_BINS] {
        &self.counts
    }

    pub fn selected_count(&self) -> u8 {
        self.selected_count
    }

    pub fn maximum_degree(&self) -> u8 {
        self.maximum_degree
    }

    #[inline]
    fn tails(&self) -> [u16; DEGREE_BINS] {
        let mut result = [0; DEGREE_BINS];
        let mut running = 0;
        for degree in (0..DEGREE_BINS).rev() {
            running += self.counts[degree];
            result[degree] = running;
        }
        result
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum AugmentResult {
    Added,
    AlreadySelected,
    DegreeCap,
    InvalidPoint,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum SearchPruning {
    DegreeCapOnly,
    DefectCatalog,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct CanonicalSearchStats {
    pub nodes: u64,
    pub terminal_prefixes: u64,
    pub degree_cap_prunes: u64,
    pub defect_catalog_prunes: u64,
    pub fixed_maximal_prunes: u64,
    pub node_limit_hit: bool,
    _pad: [u8; 7],
    _reserved: [u64; 1],
}

const _: () = assert!(std::mem::size_of::<CanonicalSearchStats>() == 56);
const _: () = assert!(std::mem::align_of::<CanonicalSearchStats>() == 8);

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CanonicalSearchResult {
    pub stats: CanonicalSearchStats,
    /// The first survivor, allocated once and only when a survivor exists.
    pub first_terminal_prefix: Option<Box<[u16]>>,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum CanonicalSearchError {
    InvalidPlane,
    InvalidDepth,
    InvalidForcedPoint,
    DuplicateForcedPoint,
    InfeasibleForcedPoint,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct FixedMaximalAnalysis {
    pub baseline_defect: u16,
    pub correction_budget: i16,
    pub baseline_internal_lines: u16,
    pub required_internal_delta: i16,
    pub local_infeasible_points: u16,
    pub local_cost_lower_bound: u16,
    pub scalar_correction_feasible: bool,
    _pad: [u8; 19],
}

const _: () = assert!(std::mem::size_of::<FixedMaximalAnalysis>() == 32);
const _: () = assert!(std::mem::align_of::<FixedMaximalAnalysis>() == 2);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum FixedMaximalError {
    InvalidPlane,
    IncompleteSet,
}

/// Canonical noncollinear frame `(e3,e2,e1)` for the q=27 maximal set.
///
/// Once two ordered maximal points are fixed, a 54-set must contain a point
/// off their 28-point line. Their stabilizer is transitive on the 729 off-line
/// points, so fixing the third point is lossless.
pub const fn gf27_normalized_frame() -> [u16; 3] {
    [756, 729, 0]
}

/// Orbits of non-frame points under the pointwise frame stabilizer.
///
/// The first three are the interiors of the coordinate sides; the fourth is
/// the complement of the coordinate triangle.
pub fn gf27_frame_point_orbits(
    plane: &ProjectivePlane,
) -> Result<[Box<[u16]>; 4], FixedMaximalError> {
    if plane.order() != 27 || plane.points().len() != GF27_LINE_COUNT {
        return Err(FixedMaximalError::InvalidPlane);
    }
    let frame = gf27_normalized_frame();
    let mut orbits = [Vec::new(), Vec::new(), Vec::new(), Vec::new()];
    for (point_index, point) in plane.points().iter().enumerate() {
        if frame.contains(&(point_index as u16)) {
            continue;
        }
        let [x, y, z] = point.coordinates;
        let orbit = if x == 0 {
            0
        } else if y == 0 {
            1
        } else if z == 0 {
            2
        } else {
            3
        };
        orbits[orbit].push(point_index as u16);
    }
    Ok(orbits.map(Vec::into_boxed_slice))
}

/// Mutable, allocation-free-per-node state for maximal-point augmentation.
#[derive(Clone, Debug)]
pub struct MaximalPointAugmentor {
    line_degrees: Box<[u8]>,
    selected_words: Box<[u64]>,
    summary: DegreeSummary,
}

impl MaximalPointAugmentor {
    pub fn new(plane: &ProjectivePlane) -> Self {
        let line_count = plane.points().len();
        Self {
            line_degrees: vec![0; line_count].into_boxed_slice(),
            selected_words: vec![0; line_count.div_ceil(64)].into_boxed_slice(),
            summary: DegreeSummary {
                counts: {
                    let mut counts = [0; DEGREE_BINS];
                    counts[0] = u16::try_from(line_count).expect("projective plane fits u16");
                    counts
                },
                selected_count: 0,
                maximum_degree: 0,
                _pad: [0; 10],
            },
        }
    }

    pub fn summary(&self) -> &DegreeSummary {
        &self.summary
    }

    pub fn line_degrees(&self) -> &[u8] {
        &self.line_degrees
    }

    pub fn is_selected(&self, point: usize) -> bool {
        point < self.line_degrees.len()
            && self.selected_words[point >> 6] & (1u64 << (point & 63)) != 0
    }

    /// Add a point and its entire projective pencil, or leave the state intact.
    #[inline]
    pub fn push(&mut self, plane: &ProjectivePlane, point: usize) -> AugmentResult {
        let Some(pencil) = plane.incident(point) else {
            return AugmentResult::InvalidPoint;
        };
        let word = point >> 6;
        let mask = 1u64 << (point & 63);
        if self.selected_words[word] & mask != 0 {
            return AugmentResult::AlreadySelected;
        }
        // Until some line reaches the cap, the rejection scan is provably dead.
        if self.summary.maximum_degree == GF27_MAX_DEGREE
            && pencil
                .iter()
                .any(|&line| self.line_degrees[line as usize] == GF27_MAX_DEGREE)
        {
            return AugmentResult::DegreeCap;
        }

        let mut pencil_maximum = 0;
        for &line in pencil {
            let degree = &mut self.line_degrees[line as usize];
            self.summary.counts[*degree as usize] -= 1;
            *degree += 1;
            self.summary.counts[*degree as usize] += 1;
            pencil_maximum = pencil_maximum.max(*degree);
        }
        self.selected_words[word] |= mask;
        self.summary.selected_count += 1;
        self.summary.maximum_degree = self.summary.maximum_degree.max(pencil_maximum);
        AugmentResult::Added
    }

    /// Undo a successful `push` of `point`.
    #[inline]
    pub fn pop(&mut self, plane: &ProjectivePlane, point: usize) {
        debug_assert!(self.is_selected(point));
        let pencil = plane
            .incident(point)
            .expect("selected point is in the plane");
        for &line in pencil {
            let degree = &mut self.line_degrees[line as usize];
            self.summary.counts[*degree as usize] -= 1;
            *degree -= 1;
            self.summary.counts[*degree as usize] += 1;
        }
        self.selected_words[point >> 6] &= !(1u64 << (point & 63));
        self.summary.selected_count -= 1;
        while self.summary.maximum_degree != 0
            && self.summary.counts[self.summary.maximum_degree as usize] == 0
        {
            self.summary.maximum_degree -= 1;
        }
    }
}

/// Analyze the residual arc-line labels for a completed 54-point set.
///
/// The minimum-defect label is used on every line first. Flipping a degree-1
/// or degree-2 line into the arc costs 3 or 1; flipping a degree-3 through
/// degree-7 line out costs 1, 3, 5, 7, or 9. Thus every correction is a signed
/// unit change in arc cardinality with total weight at most 19.
pub fn analyze_fixed_maximal_set(
    plane: &ProjectivePlane,
    state: &MaximalPointAugmentor,
) -> Result<FixedMaximalAnalysis, FixedMaximalError> {
    if plane.order() != 27 || plane.points().len() != GF27_LINE_COUNT {
        return Err(FixedMaximalError::InvalidPlane);
    }
    if state.summary.selected_count != GF27_TARGET_SIZE {
        return Err(FixedMaximalError::IncompleteSet);
    }

    let baseline_costs = [6u16, 0, 0, 0, 0, 1, 3, 6, 10, 15];
    let mut baseline_defect = 0u16;
    let mut baseline_internal_lines = 0u16;
    let mut baseline_internal = [0u64; 12];
    for (line, &degree) in state.line_degrees.iter().enumerate() {
        baseline_defect += baseline_costs[degree as usize];
        if degree == 0 || degree >= 3 {
            baseline_internal_lines += 1;
            baseline_internal[line >> 6] |= 1u64 << (line & 63);
        }
    }
    let correction_budget = 19i16 - baseline_defect as i16;
    let required_internal_delta = 279i16 - baseline_internal_lines as i16;
    let mut analysis = FixedMaximalAnalysis {
        baseline_defect,
        correction_budget,
        baseline_internal_lines,
        required_internal_delta,
        local_infeasible_points: 0,
        local_cost_lower_bound: 0,
        scalar_correction_feasible: false,
        _pad: [0; 19],
    };
    if correction_budget < 0 {
        return Ok(analysis);
    }
    let budget = correction_budget as usize;

    // Bit 32+delta records a reachable signed cardinality correction.
    let scalar = signed_flip_reachability(state.line_degrees.iter().copied(), budget);
    analysis.scalar_correction_feasible =
        adjustment_reachable(scalar[budget], required_internal_delta);

    for point in 0..GF27_LINE_COUNT {
        let pencil = plane.incident(point).expect("point belongs to plane");
        let baseline_degree = pencil
            .iter()
            .filter(|&&line| baseline_internal[line as usize >> 6] & (1u64 << (line & 63)) != 0)
            .count() as i16;
        let local = signed_flip_reachability(
            pencil.iter().map(|&line| state.line_degrees[line as usize]),
            budget,
        );
        let selected = state.is_selected(point);
        let target_adjustment = if selected {
            19 - baseline_degree
        } else {
            18 - baseline_degree
        };
        let minimum_cost = (0..=budget).find(|&used| {
            if selected {
                adjustment_reachable(local[used], target_adjustment)
            } else {
                adjustment_at_most_reachable(local[used], target_adjustment)
            }
        });
        if let Some(cost) = minimum_cost {
            analysis.local_cost_lower_bound = analysis.local_cost_lower_bound.max(cost as u16);
        } else {
            analysis.local_infeasible_points += 1;
        }
    }
    Ok(analysis)
}

#[inline]
fn flip_direction_cost(degree: u8) -> Option<(i8, u8)> {
    match degree {
        1 => Some((1, 3)),
        2 => Some((1, 1)),
        3 => Some((-1, 1)),
        4 => Some((-1, 3)),
        5 => Some((-1, 5)),
        6 => Some((-1, 7)),
        7 => Some((-1, 9)),
        _ => None,
    }
}

fn signed_flip_reachability(degrees: impl IntoIterator<Item = u8>, budget: usize) -> [u64; 20] {
    debug_assert!(budget <= 19);
    let mut reachable = [0u64; 20];
    reachable[0] = 1u64 << 32;
    for degree in degrees {
        let Some((direction, cost)) = flip_direction_cost(degree) else {
            continue;
        };
        let cost = usize::from(cost);
        if cost > budget {
            continue;
        }
        for used in (cost..=budget).rev() {
            let shifted = if direction > 0 {
                reachable[used - cost] << 1
            } else {
                reachable[used - cost] >> 1
            };
            reachable[used] |= shifted;
        }
    }
    reachable
}

#[inline]
fn adjustment_reachable(bits: u64, adjustment: i16) -> bool {
    (-32..32).contains(&adjustment) && bits & (1u64 << (32 + adjustment)) != 0
}

#[inline]
fn adjustment_at_most_reachable(bits: u64, maximum: i16) -> bool {
    if maximum < -32 {
        return false;
    }
    if maximum >= 31 {
        return bits != 0;
    }
    let inclusive_mask = (1u64 << (33 + maximum)) - 1;
    bits & inclusive_mask != 0
}

/// Exact defect-shell catalogue plus a sound partial-degree filter.
#[derive(Clone, Debug)]
pub struct Gf27DefectCatalog {
    degree_targets: Box<[DegreeTarget]>,
    mask_offsets: [u32; DEGREE_BINS],
    mask_limits: [u16; DEGREE_BINS],
    lower_masks: Box<[u64]>,
    upper_masks: Box<[u64]>,
    pair_count: usize,
    centered_spectrum_count: usize,
}

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct FilterCheckpoint {
    removed_words: [u64; TARGET_WORDS],
}

const _: () = assert!(std::mem::size_of::<FilterCheckpoint>() == 128);
const _: () = assert!(std::mem::align_of::<FilterCheckpoint>() == 64);

/// Reversible survivor set for depth-first catalogue filtering.
///
/// The 1,013 activity bits occupy two cache lines. Refining intersects
/// precomputed threshold masks; the returned two-line delta is the undo log.
#[repr(C, align(64))]
#[derive(Clone, Debug)]
pub struct Gf27TargetFrontier {
    active_words: [u64; TARGET_WORDS],
}

const _: () = assert!(std::mem::size_of::<Gf27TargetFrontier>() == 128);
const _: () = assert!(std::mem::align_of::<Gf27TargetFrontier>() == 64);

impl Gf27TargetFrontier {
    pub fn new(catalog: &Gf27DefectCatalog) -> Self {
        debug_assert!(catalog.degree_targets.len() <= TARGET_WORDS * 64);
        let mut active_words = [u64::MAX; TARGET_WORDS];
        let excess = TARGET_WORDS * 64 - catalog.degree_targets.len();
        active_words[TARGET_WORDS - 1] >>= excess;
        Self { active_words }
    }

    pub fn active_count(&self) -> usize {
        self.active_words
            .iter()
            .map(|word| word.count_ones() as usize)
            .sum()
    }

    #[inline]
    pub fn is_empty(&self) -> bool {
        self.active_words.iter().all(|&word| word == 0)
    }

    /// Remove profiles unreachable from `summary`, returning a rollback mark.
    #[inline]
    pub fn refine(
        &mut self,
        catalog: &Gf27DefectCatalog,
        summary: &DegreeSummary,
    ) -> FilterCheckpoint {
        let before = self.active_words;
        if summary.selected_count > GF27_TARGET_SIZE {
            self.active_words.fill(0);
        } else {
            let remaining = usize::from(GF27_TARGET_SIZE - summary.selected_count);
            let current = summary.tails();
            for threshold in 1..DEGREE_BINS {
                let lower = catalog.threshold_mask(false, threshold, current[threshold]);
                for (active, &mask) in self.active_words.iter_mut().zip(lower) {
                    *active &= mask;
                }
                if threshold > remaining {
                    let upper =
                        catalog.threshold_mask(true, threshold, current[threshold - remaining]);
                    for (active, &mask) in self.active_words.iter_mut().zip(upper) {
                        *active &= mask;
                    }
                }
            }
        }
        let mut removed_words = [0; TARGET_WORDS];
        for word in 0..TARGET_WORDS {
            removed_words[word] = before[word] ^ self.active_words[word];
        }
        FilterCheckpoint { removed_words }
    }

    #[inline]
    pub fn rollback(&mut self, checkpoint: FilterCheckpoint) {
        for (active, removed) in self.active_words.iter_mut().zip(checkpoint.removed_words) {
            *active |= removed;
        }
    }
}

impl Gf27DefectCatalog {
    pub fn new() -> Self {
        let internal = (0..=19)
            .map(|defect| convex_shell_histograms(279, 1_026, 3, 0, 9, defect))
            .collect::<Vec<_>>();
        let external = (0..=19)
            .map(|defect| convex_shell_histograms(478, 486, 1, 1, 7, defect))
            .collect::<Vec<_>>();

        let mut targets = Vec::new();
        let mut spectra = Vec::new();
        let mut pair_count = 0;
        for internal_defect in 0..=19 {
            for left in &internal[internal_defect] {
                for right in &external[19 - internal_defect] {
                    pair_count += 1;
                    let mut counts = [0; DEGREE_BINS];
                    for degree in 0..DEGREE_BINS {
                        counts[degree] = left[degree] + right[degree];
                    }
                    targets.push(DegreeTarget {
                        tails: histogram_tails(&counts),
                        _pad: [0; 6],
                    });

                    let mut spectrum = [0u16; 11];
                    for (degree, &count) in left.iter().enumerate() {
                        if count != 0 {
                            spectrum[10 - degree] += count;
                        }
                    }
                    for (degree, &count) in right.iter().enumerate().skip(1) {
                        if count != 0 {
                            spectrum[7 - degree] += count;
                        }
                    }
                    spectra.push(spectrum);
                }
            }
        }
        targets.sort_unstable();
        targets.dedup();
        spectra.sort_unstable();
        spectra.dedup();
        let masks = build_threshold_masks(&targets);
        Self {
            degree_targets: targets.into_boxed_slice(),
            mask_offsets: masks.offsets,
            mask_limits: masks.limits,
            lower_masks: masks.lower,
            upper_masks: masks.upper,
            pair_count,
            centered_spectrum_count: spectra.len(),
        }
    }

    pub fn pair_count(&self) -> usize {
        self.pair_count
    }

    pub fn degree_target_count(&self) -> usize {
        self.degree_targets.len()
    }

    pub fn centered_spectrum_count(&self) -> usize {
        self.centered_spectrum_count
    }

    #[inline]
    fn threshold_mask(&self, upper: bool, degree: usize, bound: u16) -> &[u64] {
        let bound = bound.min(self.mask_limits[degree]);
        let start = self.mask_offsets[degree] as usize + usize::from(bound) * TARGET_WORDS;
        let masks = if upper {
            &self.upper_masks
        } else {
            &self.lower_masks
        };
        &masks[start..start + TARGET_WORDS]
    }

    /// Count profiles reachable if each remaining point may raise a line once.
    ///
    /// Sorted interval matching makes the two tail inequalities exact for the
    /// histogram relaxation.  Projective incidence is deliberately retained
    /// as a later, stronger filter, so a zero is a proof of impossibility.
    #[inline]
    pub fn compatible_degree_targets(&self, summary: &DegreeSummary) -> usize {
        if summary.selected_count > GF27_TARGET_SIZE
            || summary
                .counts
                .iter()
                .map(|&count| usize::from(count))
                .sum::<usize>()
                != GF27_LINE_COUNT
        {
            return 0;
        }
        let remaining = usize::from(GF27_TARGET_SIZE - summary.selected_count);
        let current = summary.tails();
        self.degree_targets
            .iter()
            .filter(|target| target.supports(&current, remaining))
            .count()
    }
}

fn build_threshold_masks(targets: &[DegreeTarget]) -> ThresholdMasks {
    let mut offsets = [0; DEGREE_BINS];
    let mut limits = [0; DEGREE_BINS];
    let mut lower = Vec::new();
    let mut upper = Vec::new();
    for degree in 0..DEGREE_BINS {
        offsets[degree] = lower.len() as u32;
        let maximum = targets
            .iter()
            .map(|target| target.tails[degree])
            .max()
            .unwrap_or(0);
        limits[degree] = maximum + 1;
        for bound in 0..=maximum + 1 {
            let mut lower_words = [0u64; TARGET_WORDS];
            let mut upper_words = [0u64; TARGET_WORDS];
            for (target_index, target) in targets.iter().enumerate() {
                let value = target.tails[degree];
                if value >= bound {
                    lower_words[target_index >> 6] |= 1u64 << (target_index & 63);
                }
                if value <= bound {
                    upper_words[target_index >> 6] |= 1u64 << (target_index & 63);
                }
            }
            lower.extend_from_slice(&lower_words);
            upper.extend_from_slice(&upper_words);
        }
    }
    ThresholdMasks {
        offsets,
        limits,
        lower: lower.into_boxed_slice(),
        upper: upper.into_boxed_slice(),
    }
}

impl Default for Gf27DefectCatalog {
    fn default() -> Self {
        Self::new()
    }
}

/// Enumerate normalized point-set prefixes once in lexicographic order.
///
/// `forced_points` carries the geometric normalization chosen by the caller.
/// This is canonical combination generation relative to that normalization;
/// it does not claim to quotient the remaining projective stabilizer.
pub fn canonical_maximal_prefix_search(
    plane: &ProjectivePlane,
    catalog: &Gf27DefectCatalog,
    forced_points: &[u16],
    terminal_depth: u8,
    node_limit: u64,
    pruning: SearchPruning,
) -> Result<CanonicalSearchResult, CanonicalSearchError> {
    match pruning {
        SearchPruning::DegreeCapOnly => canonical_search_impl::<false>(
            plane,
            catalog,
            forced_points,
            terminal_depth,
            node_limit,
        ),
        SearchPruning::DefectCatalog => {
            canonical_search_impl::<true>(plane, catalog, forced_points, terminal_depth, node_limit)
        }
    }
}

fn canonical_search_impl<const FILTER: bool>(
    plane: &ProjectivePlane,
    catalog: &Gf27DefectCatalog,
    forced_points: &[u16],
    terminal_depth: u8,
    node_limit: u64,
) -> Result<CanonicalSearchResult, CanonicalSearchError> {
    if plane.order() != 27 || plane.points().len() != GF27_LINE_COUNT {
        return Err(CanonicalSearchError::InvalidPlane);
    }
    if terminal_depth > GF27_TARGET_SIZE || forced_points.len() > terminal_depth as usize {
        return Err(CanonicalSearchError::InvalidDepth);
    }
    let mut state = MaximalPointAugmentor::new(plane);
    for &point in forced_points {
        match state.push(plane, usize::from(point)) {
            AugmentResult::Added => {}
            AugmentResult::AlreadySelected => {
                return Err(CanonicalSearchError::DuplicateForcedPoint);
            }
            AugmentResult::DegreeCap => {
                return Err(CanonicalSearchError::InfeasibleForcedPoint);
            }
            AugmentResult::InvalidPoint => return Err(CanonicalSearchError::InvalidForcedPoint),
        }
    }
    let mut frontier = Gf27TargetFrontier::new(catalog);
    let candidates = (0..GF27_LINE_COUNT)
        .filter(|&point| !state.is_selected(point))
        .map(|point| point as u16)
        .collect::<Vec<_>>();
    let mut stats = CanonicalSearchStats::default();
    let mut first_terminal_prefix = None;

    #[allow(clippy::too_many_arguments)]
    fn visit<const FILTER: bool>(
        plane: &ProjectivePlane,
        catalog: &Gf27DefectCatalog,
        candidates: &[u16],
        start: usize,
        terminal_depth: u8,
        node_limit: u64,
        state: &mut MaximalPointAugmentor,
        frontier: &mut Gf27TargetFrontier,
        stats: &mut CanonicalSearchStats,
        first_terminal_prefix: &mut Option<Box<[u16]>>,
    ) {
        if stats.nodes == node_limit {
            stats.node_limit_hit = true;
            return;
        }
        stats.nodes += 1;
        let checkpoint = if FILTER {
            let checkpoint = frontier.refine(catalog, state.summary());
            if frontier.is_empty() {
                stats.defect_catalog_prunes += 1;
                frontier.rollback(checkpoint);
                return;
            }
            Some(checkpoint)
        } else {
            None
        };

        if state.summary().selected_count() == terminal_depth {
            if FILTER && terminal_depth == GF27_TARGET_SIZE {
                let analysis = analyze_fixed_maximal_set(plane, state)
                    .expect("search maintains a complete q=27 maximal set");
                if !analysis.scalar_correction_feasible || analysis.local_infeasible_points != 0 {
                    stats.fixed_maximal_prunes += 1;
                } else {
                    stats.terminal_prefixes += 1;
                    if first_terminal_prefix.is_none() {
                        *first_terminal_prefix = Some(selected_points(state));
                    }
                }
            } else {
                stats.terminal_prefixes += 1;
                if first_terminal_prefix.is_none() {
                    *first_terminal_prefix = Some(selected_points(state));
                }
            }
        } else {
            let needed = usize::from(terminal_depth - state.summary().selected_count());
            if candidates.len() - start >= needed {
                let last = candidates.len() - needed;
                for candidate_index in start..=last {
                    let point = usize::from(candidates[candidate_index]);
                    match state.push(plane, point) {
                        AugmentResult::Added => {
                            visit::<FILTER>(
                                plane,
                                catalog,
                                candidates,
                                candidate_index + 1,
                                terminal_depth,
                                node_limit,
                                state,
                                frontier,
                                stats,
                                first_terminal_prefix,
                            );
                            state.pop(plane, point);
                            if stats.node_limit_hit {
                                break;
                            }
                        }
                        AugmentResult::DegreeCap => stats.degree_cap_prunes += 1,
                        AugmentResult::AlreadySelected | AugmentResult::InvalidPoint => {
                            unreachable!("candidate list is validated and duplicate-free")
                        }
                    }
                }
            }
        }
        if let Some(checkpoint) = checkpoint {
            frontier.rollback(checkpoint);
        }
    }

    visit::<FILTER>(
        plane,
        catalog,
        &candidates,
        0,
        terminal_depth,
        node_limit,
        &mut state,
        &mut frontier,
        &mut stats,
        &mut first_terminal_prefix,
    );
    Ok(CanonicalSearchResult {
        stats,
        first_terminal_prefix,
    })
}

fn selected_points(state: &MaximalPointAugmentor) -> Box<[u16]> {
    (0..state.line_degrees.len())
        .filter(|&point| state.is_selected(point))
        .map(|point| point as u16)
        .collect::<Vec<_>>()
        .into_boxed_slice()
}

fn histogram_tails(counts: &[u16; DEGREE_BINS]) -> [u16; DEGREE_BINS] {
    let mut tails = [0; DEGREE_BINS];
    let mut running = 0;
    for degree in (0..DEGREE_BINS).rev() {
        running += counts[degree];
        tails[degree] = running;
    }
    tails
}

fn convex_shell_histograms(
    point_count: u16,
    degree_sum: u16,
    center: usize,
    minimum_degree: usize,
    maximum_degree: usize,
    defect: u16,
) -> Vec<[u16; DEGREE_BINS]> {
    let exceptional = (minimum_degree..=maximum_degree)
        .filter(|&degree| degree != center && degree != center + 1)
        .filter_map(|degree| {
            let delta = degree as i32 - center as i32;
            let cost = delta * (delta - 1) / 2;
            (cost <= i32::from(defect)).then_some((degree, cost as u16))
        })
        .collect::<Vec<_>>();
    let mut counts = [0; DEGREE_BINS];
    let mut output = Vec::new();

    #[allow(clippy::too_many_arguments)]
    fn visit(
        exceptional: &[(usize, u16)],
        index: usize,
        point_count: u16,
        degree_sum: u16,
        center: usize,
        used_points: u16,
        used_sum: u16,
        remaining: u16,
        counts: &mut [u16; DEGREE_BINS],
        output: &mut Vec<[u16; DEGREE_BINS]>,
    ) {
        if index == exceptional.len() {
            if remaining != 0 || used_points > point_count || used_sum > degree_sum {
                return;
            }
            let bulk_points = point_count - used_points;
            let bulk_sum = degree_sum - used_sum;
            let Some(high_count) = bulk_sum.checked_sub(center as u16 * bulk_points) else {
                return;
            };
            let Some(low_count) = bulk_points.checked_sub(high_count) else {
                return;
            };
            counts[center] = low_count;
            counts[center + 1] = high_count;
            output.push(*counts);
            counts[center] = 0;
            counts[center + 1] = 0;
            return;
        }

        let (degree, cost) = exceptional[index];
        let maximum_count = (remaining / cost).min(point_count - used_points);
        for count in 0..=maximum_count {
            counts[degree] = count;
            visit(
                exceptional,
                index + 1,
                point_count,
                degree_sum,
                center,
                used_points + count,
                used_sum + count * degree as u16,
                remaining - count * cost,
                counts,
                output,
            );
        }
        counts[degree] = 0;
    }

    visit(
        &exceptional,
        0,
        point_count,
        degree_sum,
        center,
        0,
        0,
        defect,
        &mut counts,
        &mut output,
    );
    output
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn gf27_catalog_matches_independent_python_counts() {
        let catalog = Gf27DefectCatalog::new();
        assert_eq!(catalog.pair_count(), 3_435);
        assert_eq!(catalog.degree_target_count(), 1_013);
        assert_eq!(catalog.centered_spectrum_count(), 1_496);
    }

    #[test]
    fn projective_pencil_updates_and_rollback_are_exact() {
        let plane = ProjectivePlane::ternary(27).unwrap();
        let mut state = MaximalPointAugmentor::new(&plane);
        let points = [0, 1, 27, 83, 271, 756];
        for (depth, &point) in points.iter().enumerate() {
            assert_eq!(state.push(&plane, point), AugmentResult::Added);
            assert_eq!(state.summary().selected_count(), (depth + 1) as u8);
            assert_eq!(
                state
                    .line_degrees()
                    .iter()
                    .map(|&x| usize::from(x))
                    .sum::<usize>(),
                (depth + 1) * 28
            );
        }
        assert_eq!(
            state.push(&plane, points[0]),
            AugmentResult::AlreadySelected
        );
        for (depth, &point) in points.iter().enumerate().rev() {
            state.pop(&plane, point);
            assert_eq!(state.summary().selected_count(), depth as u8);
        }
        assert!(state.line_degrees().iter().all(|&degree| degree == 0));
        assert_eq!(state.summary().counts()[0], 757);
    }

    #[test]
    fn arithmetic_filter_is_sound_at_root() {
        let plane = ProjectivePlane::ternary(27).unwrap();
        let state = MaximalPointAugmentor::new(&plane);
        let catalog = Gf27DefectCatalog::new();
        assert_eq!(
            catalog.compatible_degree_targets(state.summary()),
            catalog.degree_target_count()
        );
    }

    #[test]
    fn arithmetic_filter_accepts_every_exact_terminal_profile() {
        let catalog = Gf27DefectCatalog::new();
        for target in &catalog.degree_targets {
            let mut counts = [0; DEGREE_BINS];
            for (degree, count) in counts.iter_mut().enumerate().take(DEGREE_BINS - 1) {
                *count = target.tails[degree] - target.tails[degree + 1];
            }
            counts[DEGREE_BINS - 1] = target.tails[DEGREE_BINS - 1];
            let summary = DegreeSummary {
                counts,
                selected_count: GF27_TARGET_SIZE,
                maximum_degree: (0..DEGREE_BINS)
                    .rfind(|&degree| counts[degree] != 0)
                    .unwrap() as u8,
                _pad: [0; 10],
            };
            assert!(catalog.compatible_degree_targets(&summary) >= 1);
        }
    }

    #[test]
    fn degree_cap_rejection_does_not_mutate_state() {
        let plane = ProjectivePlane::ternary(27).unwrap();
        let line = plane.incident(0).unwrap();
        let mut state = MaximalPointAugmentor::new(&plane);
        for &point in &line[..GF27_MAX_DEGREE as usize] {
            assert_eq!(state.push(&plane, point as usize), AugmentResult::Added);
        }
        let before = state.clone();
        assert_eq!(
            state.push(&plane, line[GF27_MAX_DEGREE as usize] as usize),
            AugmentResult::DegreeCap
        );
        assert_eq!(state.line_degrees, before.line_degrees);
        assert_eq!(state.selected_words, before.selected_words);
        assert_eq!(state.summary, before.summary);
    }

    #[test]
    fn reversible_frontier_matches_full_scan_and_rollback() {
        let plane = ProjectivePlane::ternary(27).unwrap();
        let catalog = Gf27DefectCatalog::new();
        let mut frontier = Gf27TargetFrontier::new(&catalog);
        let mut state = MaximalPointAugmentor::new(&plane);
        let mut candidate = 0;
        let mut checkpoints = Vec::new();
        for depth in 0..=40 {
            let checkpoint = frontier.refine(&catalog, state.summary());
            checkpoints.push(checkpoint);
            assert_eq!(
                frontier.active_count(),
                catalog.compatible_degree_targets(state.summary())
            );
            if depth != 40 {
                loop {
                    if state.push(&plane, candidate) == AugmentResult::Added {
                        candidate = (candidate + 37) % plane.points().len();
                        break;
                    }
                    candidate = (candidate + 1) % plane.points().len();
                }
            }
        }
        for checkpoint in checkpoints.into_iter().rev() {
            frontier.rollback(checkpoint);
        }
        assert_eq!(frontier.active_count(), catalog.degree_target_count());
    }

    #[test]
    fn canonical_prefix_search_counts_combinations_without_duplicates() {
        let plane = ProjectivePlane::ternary(27).unwrap();
        let catalog = Gf27DefectCatalog::new();
        let result = canonical_maximal_prefix_search(
            &plane,
            &catalog,
            &[0, 1],
            4,
            u64::MAX,
            SearchPruning::DegreeCapOnly,
        )
        .unwrap();
        let stats = result.stats;
        assert_eq!(stats.terminal_prefixes, 755 * 754 / 2);
        assert_eq!(stats.nodes, 1 + 754 + 755 * 754 / 2);
        assert_eq!(stats.degree_cap_prunes, 0);
        assert!(!stats.node_limit_hit);
        let witness = result.first_terminal_prefix.unwrap();
        assert_eq!(witness.len(), 4);
        assert!(witness.windows(2).all(|pair| pair[0] < pair[1]));
        assert!(witness.contains(&0));
        assert!(witness.contains(&1));
    }

    #[test]
    fn fixed_maximal_analysis_rejects_incomplete_sets() {
        let plane = ProjectivePlane::ternary(27).unwrap();
        let state = MaximalPointAugmentor::new(&plane);
        assert_eq!(
            analyze_fixed_maximal_set(&plane, &state),
            Err(FixedMaximalError::IncompleteSet)
        );
    }

    #[test]
    fn signed_flip_costs_are_exact_defect_differences() {
        for degree in 1..=7 {
            let (direction, cost) = flip_direction_cost(degree).unwrap();
            let internal_delta = i16::from(degree) - 3;
            let external_delta = i16::from(degree) - 1;
            let internal_cost = internal_delta * (internal_delta - 1) / 2;
            let external_cost = external_delta * (external_delta - 1) / 2;
            assert_eq!(i16::from(cost), (external_cost - internal_cost).abs());
            assert_eq!(direction > 0, external_cost < internal_cost);
        }
        assert_eq!(flip_direction_cost(0), None);
        assert_eq!(flip_direction_cost(8), None);
        assert_eq!(flip_direction_cost(9), None);
    }

    #[test]
    fn signed_flip_dp_matches_subset_enumeration() {
        let degrees = [1, 2, 2, 3, 4, 5, 7, 8];
        let budget = 19;
        let dynamic = signed_flip_reachability(degrees, budget);
        let mut brute = [0u64; 20];
        for subset in 0u16..1u16 << degrees.len() {
            let mut cost = 0usize;
            let mut adjustment = 0i16;
            let mut valid = true;
            for (index, &degree) in degrees.iter().enumerate() {
                if subset & (1 << index) == 0 {
                    continue;
                }
                let Some((direction, flip_cost)) = flip_direction_cost(degree) else {
                    valid = false;
                    break;
                };
                cost += usize::from(flip_cost);
                adjustment += i16::from(direction);
            }
            if valid && cost <= budget {
                brute[cost] |= 1u64 << (32 + adjustment);
            }
        }
        assert_eq!(dynamic, brute);
    }

    #[test]
    fn tail_inequalities_match_exhaustive_interval_assignment() {
        fn assign(current: &[u8; 4], target: &[u8; 4], remaining: u8) -> bool {
            fn visit(
                current: &[u8; 4],
                target: &[u8; 4],
                remaining: u8,
                index: usize,
                used: u8,
            ) -> bool {
                if index == current.len() {
                    return true;
                }
                (0..target.len()).any(|candidate| {
                    let bit = 1u8 << candidate;
                    used & bit == 0
                        && current[index] <= target[candidate]
                        && target[candidate] <= current[index] + remaining
                        && visit(current, target, remaining, index + 1, used | bit)
                })
            }
            visit(current, target, remaining, 0, 0)
        }

        let sorted = (0u8..4)
            .flat_map(|a| {
                (a..4)
                    .flat_map(move |b| (b..4).flat_map(move |c| (c..4).map(move |d| [a, b, c, d])))
            })
            .collect::<Vec<_>>();
        for current_values in &sorted {
            let mut current_counts = [0u16; DEGREE_BINS];
            for &degree in current_values {
                current_counts[degree as usize] += 1;
            }
            let current = histogram_tails(&current_counts);
            for target_values in &sorted {
                let mut target_counts = [0u16; DEGREE_BINS];
                for &degree in target_values {
                    target_counts[degree as usize] += 1;
                }
                let target = DegreeTarget {
                    tails: histogram_tails(&target_counts),
                    _pad: [0; 6],
                };
                for remaining in 0..=2 {
                    assert_eq!(
                        target.supports(&current, remaining as usize),
                        assign(current_values, target_values, remaining)
                    );
                }
            }
        }
    }

    #[test]
    fn normalized_frame_stabilizer_orbits_partition_remaining_points() {
        let plane = ProjectivePlane::ternary(27).unwrap();
        let frame = gf27_normalized_frame();
        assert_eq!(plane.points()[frame[0] as usize].coordinates, [0, 0, 1]);
        assert_eq!(plane.points()[frame[1] as usize].coordinates, [0, 1, 0]);
        assert_eq!(plane.points()[frame[2] as usize].coordinates, [1, 0, 0]);
        let orbits = gf27_frame_point_orbits(&plane).unwrap();
        assert_eq!(
            orbits.each_ref().map(|orbit| orbit.len()),
            [26, 26, 26, 676]
        );
        assert_eq!(orbits.each_ref().map(|orbit| orbit[0]), [730, 1, 27, 28]);
        let mut union = orbits.into_iter().flatten().collect::<Vec<_>>();
        union.extend(frame);
        union.sort_unstable();
        assert_eq!(union, (0..757).collect::<Vec<_>>());
    }
}
