//! Exact attachment separation for aligned-design queries.
//!
//! A selected triple separates every attachment over every known two-graph
//! exactly when, for each nontrivial attachment cut, the constraint graph on
//! cut edges is non-bipartite.  Compilation materializes the bounded graph
//! incidences once; verification and search use packed masks only.

use thiserror::Error;

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum AlignmentError {
    #[error("alignment attachment controls require 5 through 8 points")]
    Shape,
    #[error("the selected family uses a triple outside the compiled domain")]
    Family,
    #[error("the requested cut is outside the compiled domain")]
    Cut,
    #[error(
        "fractional query weights must match the triple domain and be finite nonnegative values"
    )]
    Weights,
    #[error("the search budget exceeds the compiled triple count")]
    Budget,
    #[error("the pre-sized search table is full")]
    Workspace,
    #[error("an arithmetic counter overflowed")]
    Overflow,
}

#[derive(Debug)]
pub struct AlignmentAttachment {
    point_count: u8,
    triples: Box<[[u8; 3]]>,
    cut_edge_counts: Box<[u8]>,
    cut_pairs: Box<[u8]>,
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct AlignmentFractionalContext {
    pub cut: usize,
    pub clause: u64,
    pub weight: f64,
}

impl AlignmentAttachment {
    pub fn point_count(&self) -> u32 {
        u32::from(self.point_count)
    }

    pub fn triples(&self) -> &[[u8; 3]] {
        &self.triples
    }

    pub fn cut_count(&self) -> usize {
        self.cut_edge_counts.len()
    }

    pub fn separates(&self, selected: u64) -> Result<bool, AlignmentError> {
        if selected >> self.triples.len() != 0 {
            return Err(AlignmentError::Family);
        }
        Ok(self.violation_summary(selected).0.is_none())
    }

    /// Decide one compiled cut.  This is useful for monotone residualization:
    /// a cut separated by an already-fixed family stays separated by every
    /// extension and its constraint subsystem can be omitted.
    pub fn separates_cut(&self, selected: u64, cut: usize) -> Result<bool, AlignmentError> {
        if selected >> self.triples.len() != 0 {
            return Err(AlignmentError::Family);
        }
        if cut >= self.cut_count() {
            return Err(AlignmentError::Cut);
        }
        Ok(self.violation_for_cut(cut, selected).is_none())
    }

    /// Separate the most violated fractional context inequality.
    ///
    /// For one cut, minimizing the weight of a same-colour clause is weighted
    /// MaxCut on its cut-edge rook graph.  Complementary colourings agree, so
    /// vertex zero is fixed.  Gray-code enumeration flips one vertex at a time;
    /// every vertex has exactly `point_count - 2` incident triple constraints.
    /// The bounded kernel uses fixed stack storage and allocates nothing.
    pub fn minimum_fractional_context(
        &self,
        weights: &[f64],
    ) -> Result<AlignmentFractionalContext, AlignmentError> {
        let mut context = [AlignmentFractionalContext {
            cut: 0,
            clause: 0,
            weight: f64::INFINITY,
        }];
        self.fractional_contexts(weights, &mut context)?;
        Ok(context[0])
    }

    /// Return the lightest context inequality for as many distinct cuts as
    /// fit in `output`, sorted by weight.  One Gray scan therefore amortizes
    /// into a batch of user cuts without allocating.
    pub fn fractional_contexts(
        &self,
        weights: &[f64],
        output: &mut [AlignmentFractionalContext],
    ) -> Result<usize, AlignmentError> {
        if weights.len() != self.triples.len()
            || weights
                .iter()
                .any(|weight| !weight.is_finite() || *weight < 0.0)
        {
            return Err(AlignmentError::Weights);
        }
        if output.is_empty() {
            return Err(AlignmentError::Workspace);
        }
        let empty = AlignmentFractionalContext {
            cut: 0,
            clause: 0,
            weight: f64::INFINITY,
        };
        output.fill(empty);
        let mut written = 0_usize;
        for cut in 0..self.cut_count() {
            let edge_count = self.cut_edge_counts[cut] as usize;
            let mut incident_other = [[u8::MAX; 6]; 16];
            let mut incident_weight = [[0.0_f64; 6]; 16];
            let mut degrees = [0_u8; 16];
            let mut current = 0.0;
            for (triple, &weight) in weights.iter().enumerate() {
                let (left, right) = self.pair(cut, triple);
                if left == u8::MAX {
                    continue;
                }
                current += weight;
                for (vertex, other) in [(left, right), (right, left)] {
                    let degree = &mut degrees[vertex as usize];
                    incident_other[vertex as usize][*degree as usize] = other;
                    incident_weight[vertex as usize][*degree as usize] = weight;
                    *degree += 1;
                }
            }
            debug_assert!(degrees[..edge_count]
                .iter()
                .all(|&degree| degree == self.point_count - 2));

            let mut colors = 0_u16;
            let mut best_weight = current;
            let mut best_colors = colors;
            for step in 1_u32..(1_u32 << (edge_count - 1)) {
                let vertex = step.trailing_zeros() as usize + 1;
                let vertex_color = colors >> vertex & 1;
                for index in 0..degrees[vertex] as usize {
                    let other = incident_other[vertex][index] as usize;
                    let weight = incident_weight[vertex][index];
                    let same_colour = u64::from(vertex_color == (colors >> other & 1));
                    current += f64::from_bits(weight.to_bits() ^ (same_colour << 63));
                }
                colors ^= 1_u16 << vertex;
                if current < best_weight {
                    best_weight = current;
                    best_colors = colors;
                }
            }

            let mut clause = 0_u64;
            let mut exact_weight = 0.0;
            for (triple, &weight) in weights.iter().enumerate() {
                let (left, right) = self.pair(cut, triple);
                if left != u8::MAX && (best_colors >> left & 1) == (best_colors >> right & 1) {
                    clause |= 1_u64 << triple;
                    exact_weight += weight;
                }
            }
            let insertion =
                output[..written].partition_point(|context| context.weight <= exact_weight);
            if insertion < output.len() {
                let next_written = (written + 1).min(output.len());
                output.copy_within(insertion..next_written - 1, insertion + 1);
                output[insertion] = AlignmentFractionalContext {
                    cut,
                    clause,
                    weight: exact_weight,
                };
                written = next_written;
            }
        }
        Ok(written)
    }

    #[inline]
    fn pair(&self, cut: usize, triple: usize) -> (u8, u8) {
        let base = (cut * self.triples.len() + triple) * 2;
        (self.cut_pairs[base], self.cut_pairs[base + 1])
    }

    fn violation_for_cut(&self, cut: usize, selected: u64) -> Option<u64> {
        let edge_count = self.cut_edge_counts[cut] as usize;
        let mut adjacency = [0_u16; 16];
        let mut remaining_selected = selected;
        while remaining_selected != 0 {
            let triple = remaining_selected.trailing_zeros() as usize;
            remaining_selected &= remaining_selected - 1;
            let (left, right) = self.pair(cut, triple);
            if left == u8::MAX {
                continue;
            }
            adjacency[left as usize] |= 1_u16 << right;
            adjacency[right as usize] |= 1_u16 << left;
        }
        let mut queue = [0_u8; 16];
        let mut colored = 0_u16;
        let mut color_one = 0_u16;
        for root in 0..edge_count {
            let root_bit = 1_u16 << root;
            if colored & root_bit != 0 {
                continue;
            }
            colored |= root_bit;
            queue[0] = root as u8;
            let mut head = 0_usize;
            let mut tail = 1_usize;
            while head < tail {
                let vertex = queue[head];
                head += 1;
                let vertex_bit = 1_u16 << vertex;
                let neighbors = adjacency[vertex as usize];
                let same_color = if color_one & vertex_bit == 0 {
                    colored & !color_one
                } else {
                    color_one
                };
                if neighbors & same_color != 0 {
                    return None;
                }
                let mut fresh = neighbors & !colored;
                colored |= fresh;
                if color_one & vertex_bit == 0 {
                    color_one |= fresh;
                }
                while fresh != 0 {
                    let neighbor = fresh.trailing_zeros() as u8;
                    fresh &= fresh - 1;
                    queue[tail] = neighbor;
                    tail += 1;
                }
            }
        }
        let mut clause = 0_u64;
        for triple in 0..self.triples.len() {
            let (left, right) = self.pair(cut, triple);
            if left != u8::MAX && (color_one >> left & 1) == (color_one >> right & 1) {
                clause |= 1_u64 << triple;
            }
        }
        debug_assert_ne!(clause, 0, "cut={cut} selected={selected:#x}");
        Some(clause)
    }

    fn violation_summary(&self, selected: u64) -> (Option<u64>, u32) {
        let mut best = None;
        let mut clauses = [0_u64; 127];
        let mut clause_count = 0_usize;
        for cut in 0..self.cut_count() {
            let Some(clause) = self.violation_for_cut(cut, selected) else {
                continue;
            };
            clauses[clause_count] = clause;
            clause_count += 1;
            if best.is_none_or(|prior: u64| clause.count_ones() < prior.count_ones()) {
                best = Some(clause);
            }
        }
        let mut used = 0_u64;
        let mut packing = 0_u32;
        loop {
            let mut next = None;
            for &clause in &clauses[..clause_count] {
                if clause & used == 0
                    && next.is_none_or(|prior: u64| clause.count_ones() < prior.count_ones())
                {
                    next = Some(clause);
                }
            }
            let Some(clause) = next else {
                break;
            };
            used |= clause;
            packing += 1;
        }

        let mut hit_counts = [0_u8; 56];
        for &clause in &clauses[..clause_count] {
            let mut bits = clause;
            while bits != 0 {
                let triple = bits.trailing_zeros() as usize;
                bits &= bits - 1;
                hit_counts[triple] += 1;
            }
        }
        let mut available = if self.triples.len() == 64 {
            u64::MAX
        } else {
            (1_u64 << self.triples.len()) - 1
        } & !selected;
        let mut capacity = 0_usize;
        let mut incidence_bound = 0_u32;
        while capacity < clause_count && available != 0 {
            let mut candidates = available;
            let mut best_triple = candidates.trailing_zeros() as usize;
            while candidates != 0 {
                let triple = candidates.trailing_zeros() as usize;
                candidates &= candidates - 1;
                if hit_counts[triple] > hit_counts[best_triple] {
                    best_triple = triple;
                }
            }
            available &= !(1_u64 << best_triple);
            capacity += usize::from(hit_counts[best_triple]);
            incidence_bound += 1;
        }
        (best, packing.max(incidence_bound))
    }
}

/// Compile the exact cut-edge constraint graph for every nontrivial cut.
pub fn compile_alignment_attachment(
    point_count: u32,
) -> Result<AlignmentAttachment, AlignmentError> {
    if !(5..=8).contains(&point_count) {
        return Err(AlignmentError::Shape);
    }
    let n = point_count as usize;
    let mut triples = Vec::with_capacity(n * (n - 1) * (n - 2) / 6);
    for a in 0..n {
        for b in a + 1..n {
            for c in b + 1..n {
                triples.push([a as u8, b as u8, c as u8]);
            }
        }
    }

    let cut_count = (1_usize << (n - 1)) - 1;
    let mut cut_edge_counts = Vec::with_capacity(cut_count);
    let mut cut_pairs = Vec::with_capacity(cut_count * triples.len() * 2);
    for cut in 1..=cut_count {
        let mut edge_index = [[u8::MAX; 8]; 8];
        let mut edge_count = 0_u8;
        for (left, row) in edge_index[..n].iter_mut().enumerate() {
            for (right, cell) in row.iter_mut().enumerate().take(n).skip(left + 1) {
                if side(cut, left) != side(cut, right) {
                    *cell = edge_count;
                    edge_count += 1;
                }
            }
        }
        cut_edge_counts.push(edge_count);
        for &[a, b, c] in &triples {
            let (a, b, c) = (a as usize, b as usize, c as usize);
            let endpoints = if side(cut, a) == side(cut, b) && side(cut, a) != side(cut, c) {
                Some((c, a, b))
            } else if side(cut, a) == side(cut, c) && side(cut, a) != side(cut, b) {
                Some((b, a, c))
            } else if side(cut, b) == side(cut, c) && side(cut, b) != side(cut, a) {
                Some((a, b, c))
            } else {
                None
            };
            let Some((center, left, right)) = endpoints else {
                cut_pairs.extend([u8::MAX, u8::MAX]);
                continue;
            };
            cut_pairs.extend([
                edge_index[center.min(left)][center.max(left)],
                edge_index[center.min(right)][center.max(right)],
            ]);
        }
    }
    Ok(AlignmentAttachment {
        point_count: point_count as u8,
        triples: triples.into_boxed_slice(),
        cut_edge_counts: cut_edge_counts.into_boxed_slice(),
        cut_pairs: cut_pairs.into_boxed_slice(),
    })
}

#[inline]
fn side(cut: usize, point: usize) -> bool {
    point != 0 && cut & (1_usize << (point - 1)) != 0
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct AlignmentSearchMetrics {
    pub states: u64,
    pub duplicate_states: u64,
    pub infeasible_states: u64,
}

#[derive(Clone, Copy, Debug, Default)]
struct SearchFrame {
    selected: u64,
    branch_bits: u64,
    entered: bool,
}

#[derive(Debug)]
pub struct AlignmentSearchWorkspace {
    frames: Box<[SearchFrame]>,
    seen: Box<[u64]>,
}

impl AlignmentSearchWorkspace {
    pub fn new(maximum_budget: u32, seen_capacity: usize) -> Result<Self, AlignmentError> {
        if maximum_budget == 0 || seen_capacity < 16 {
            return Err(AlignmentError::Workspace);
        }
        let slots = seen_capacity
            .checked_next_power_of_two()
            .ok_or(AlignmentError::Workspace)?;
        Ok(Self {
            frames: vec![SearchFrame::default(); maximum_budget as usize + 1].into_boxed_slice(),
            seen: vec![0_u64; slots].into_boxed_slice(),
        })
    }

    fn insert_seen(&mut self, selected: u64) -> Result<bool, AlignmentError> {
        debug_assert_ne!(selected, 0);
        let mask = self.seen.len() - 1;
        let mut slot = (selected.wrapping_mul(0x9e37_79b9_7f4a_7c15) >> 32) as usize & mask;
        for _ in 0..self.seen.len() {
            if self.seen[slot] == selected {
                return Ok(false);
            }
            if self.seen[slot] == 0 {
                self.seen[slot] = selected;
                return Ok(true);
            }
            slot = (slot + 1) & mask;
        }
        Err(AlignmentError::Workspace)
    }
}

/// Search exactly for a separating family of at most `budget` triples.
///
/// The first triple is fixed by point-transitivity.  Each branch hits one
/// exact cut-coloring context that the current family fails to distinguish.
/// The DFS, duplicate table, and graph scans allocate nothing after workspace
/// construction.
pub fn search_alignment_attachment(
    problem: &AlignmentAttachment,
    budget: u32,
    workspace: &mut AlignmentSearchWorkspace,
) -> Result<(Option<u64>, AlignmentSearchMetrics), AlignmentError> {
    search_alignment_attachment_from(problem, budget, 1, workspace)
}

/// Search from a caller-proved symmetry representative or other fixed family.
pub fn search_alignment_attachment_from(
    problem: &AlignmentAttachment,
    budget: u32,
    initial: u64,
    workspace: &mut AlignmentSearchWorkspace,
) -> Result<(Option<u64>, AlignmentSearchMetrics), AlignmentError> {
    if budget == 0
        || budget as usize > problem.triples.len()
        || budget as usize >= workspace.frames.len()
    {
        return Err(AlignmentError::Budget);
    }
    if initial == 0 || initial >> problem.triples.len() != 0 || initial.count_ones() > budget {
        return Err(AlignmentError::Family);
    }
    workspace.seen.fill(0);
    workspace.frames.fill(SearchFrame::default());
    workspace.frames[0] = SearchFrame {
        selected: initial,
        ..SearchFrame::default()
    };
    let mut depth = 0_usize;
    let mut metrics = AlignmentSearchMetrics::default();

    loop {
        if !workspace.frames[depth].entered {
            let selected = workspace.frames[depth].selected;
            if !workspace.insert_seen(selected)? {
                metrics.duplicate_states = metrics
                    .duplicate_states
                    .checked_add(1)
                    .ok_or(AlignmentError::Overflow)?;
                if depth == 0 {
                    break;
                }
                depth -= 1;
                continue;
            }
            metrics.states = metrics
                .states
                .checked_add(1)
                .ok_or(AlignmentError::Overflow)?;
            let (violation, packing) = problem.violation_summary(selected);
            let Some(clause) = violation else {
                return Ok((Some(selected), metrics));
            };
            let branch_bits = clause & !selected;
            if selected.count_ones().saturating_add(packing) > budget || branch_bits == 0 {
                metrics.infeasible_states = metrics
                    .infeasible_states
                    .checked_add(1)
                    .ok_or(AlignmentError::Overflow)?;
                if depth == 0 {
                    break;
                }
                depth -= 1;
                continue;
            }
            workspace.frames[depth].branch_bits = branch_bits;
            workspace.frames[depth].entered = true;
        }

        let branch_bits = workspace.frames[depth].branch_bits;
        if branch_bits != 0 {
            let bit = branch_bits & branch_bits.wrapping_neg();
            workspace.frames[depth].branch_bits ^= bit;
            let selected = workspace.frames[depth].selected | bit;
            depth += 1;
            workspace.frames[depth] = SearchFrame {
                selected,
                ..SearchFrame::default()
            };
        } else if depth == 0 {
            break;
        } else {
            depth -= 1;
        }
    }
    Ok((None, metrics))
}

#[cfg(test)]
mod tests {
    use super::*;

    const SECOND_REPRESENTATIVES: [usize; 3] = [1, 11, 46];
    const THIRD_REPRESENTATIVES: [&[usize]; 3] = [
        &[2, 6, 7, 11, 15, 36, 40, 46, 52],
        &[1, 3, 12, 18, 21, 23, 26, 27, 33, 46, 49, 55],
        &[1, 4, 11, 13, 20, 47, 51],
    ];

    fn next_permutation(permutation: &mut [u8; 8]) -> bool {
        let Some(pivot) = (0..permutation.len() - 1)
            .rev()
            .find(|&index| permutation[index] < permutation[index + 1])
        else {
            return false;
        };
        let successor = (pivot + 1..permutation.len())
            .rev()
            .find(|&index| permutation[pivot] < permutation[index])
            .unwrap();
        permutation.swap(pivot, successor);
        permutation[pivot + 1..].reverse();
        true
    }

    fn permuted_triple_index(triples: &[[u8; 3]], index: usize, permutation: &[u8; 8]) -> usize {
        let mut image = triples[index].map(|point| permutation[point as usize]);
        image.sort_unstable();
        triples.iter().position(|&triple| triple == image).unwrap()
    }

    fn direct_answer(n: usize, e: u64, x: usize, triple: [u8; 3]) -> bool {
        let [a, b, c] = triple.map(usize::from);
        let known_edge = |left: usize, right: usize| {
            if left == 0 || right == 0 {
                0_u32
            } else {
                let (low, high) = (left.min(right) - 1, left.max(right) - 1);
                let mut index = 0_usize;
                for row in 0..n - 1 {
                    for column in row + 1..n - 1 {
                        if row == low && column == high {
                            return ((e >> index) & 1) as u32;
                        }
                        index += 1;
                    }
                }
                unreachable!()
            }
        };
        let attachment = |point: usize| {
            if point == 0 {
                0_u32
            } else {
                ((x >> (point - 1)) & 1) as u32
            }
        };
        let degrees = [
            attachment(a) ^ attachment(b) ^ attachment(c),
            attachment(a) ^ known_edge(a, b) ^ known_edge(a, c),
            attachment(b) ^ known_edge(a, b) ^ known_edge(b, c),
            attachment(c) ^ known_edge(a, c) ^ known_edge(b, c),
        ];
        degrees.iter().all(|&degree| degree == degrees[0])
    }

    fn direct_separates(problem: &AlignmentAttachment, selected: u64) -> bool {
        let n = problem.point_count() as usize;
        let edge_count = (n - 1) * (n - 2) / 2;
        for e in 0..1_u64 << edge_count {
            for x in 0..1_usize << (n - 1) {
                for y in x + 1..1_usize << (n - 1) {
                    let distinguished =
                        problem
                            .triples()
                            .iter()
                            .enumerate()
                            .any(|(index, &triple)| {
                                selected & (1_u64 << index) != 0
                                    && direct_answer(n, e, x, triple)
                                        != direct_answer(n, e, y, triple)
                            });
                    if !distinguished {
                        return false;
                    }
                }
            }
        }
        true
    }

    fn family(problem: &AlignmentAttachment, triples: &[[u8; 3]]) -> u64 {
        triples.iter().fold(0_u64, |mask, triple| {
            let index = problem
                .triples()
                .iter()
                .position(|candidate| candidate == triple)
                .unwrap();
            mask | (1_u64 << index)
        })
    }

    #[test]
    fn published_attachment_witnesses_pass_the_exact_cut_quotient() {
        let p5 = compile_alignment_attachment(5).unwrap();
        let g5 = family(
            &p5,
            &[
                [0, 1, 2],
                [0, 1, 3],
                [0, 1, 4],
                [0, 2, 3],
                [0, 2, 4],
                [0, 3, 4],
                [1, 2, 3],
                [1, 2, 4],
                [1, 3, 4],
            ],
        );
        assert!(p5.separates(g5).unwrap());

        let p8 = compile_alignment_attachment(8).unwrap();
        let g8 = family(
            &p8,
            &[
                [0, 1, 2],
                [0, 1, 4],
                [0, 1, 5],
                [0, 2, 4],
                [0, 2, 5],
                [0, 4, 5],
                [1, 2, 3],
                [1, 2, 5],
                [1, 2, 6],
                [1, 2, 7],
                [1, 3, 6],
                [1, 3, 7],
                [1, 4, 5],
                [1, 6, 7],
                [2, 3, 6],
                [2, 3, 7],
                [2, 5, 6],
            ],
        );
        assert_eq!(g8.count_ones(), 17);
        assert!(p8.separates(g8).unwrap());
        assert!(!p8.separates(g8 & !(1_u64 << g8.trailing_zeros())).unwrap());
    }

    #[test]
    fn iterative_search_reproves_g5() {
        let problem = compile_alignment_attachment(5).unwrap();
        let mut workspace = AlignmentSearchWorkspace::new(9, 1 << 18).unwrap();
        let (below, _) = search_alignment_attachment(&problem, 8, &mut workspace).unwrap();
        assert!(below.is_none());
        let (exact, _) = search_alignment_attachment(&problem, 9, &mut workspace).unwrap();
        let exact = exact.unwrap();
        assert_eq!(exact.count_ones(), 9);
        assert!(problem.separates(exact).unwrap());
    }

    #[test]
    fn cut_graph_quotient_matches_the_direct_predicate_exhaustively_at_five_points() {
        let problem = compile_alignment_attachment(5).unwrap();
        for selected in 0..1_u64 << problem.triples().len() {
            assert_eq!(
                problem.separates(selected).unwrap(),
                direct_separates(&problem, selected)
            );
        }
    }

    #[test]
    fn three_level_orbit_split_covers_every_anchored_family() {
        let problem = compile_alignment_attachment(8).unwrap();
        let triples = problem.triples();
        let mut permutations = Vec::with_capacity(40_320);
        let mut permutation = [0, 1, 2, 3, 4, 5, 6, 7];
        loop {
            if permuted_triple_index(triples, 0, &permutation) == 0 {
                permutations.push(permutation);
            }
            if !next_permutation(&mut permutation) {
                break;
            }
        }
        assert_eq!(permutations.len(), 720);

        for second in 1..triples.len() {
            assert!(SECOND_REPRESENTATIVES.iter().any(|&representative| {
                permutations
                    .iter()
                    .any(|action| permuted_triple_index(triples, second, action) == representative)
            }));
        }

        for (case, &second) in SECOND_REPRESENTATIVES.iter().enumerate() {
            let stabilizer = permutations
                .iter()
                .filter(|action| permuted_triple_index(triples, second, action) == second);
            let mut stabilizer_size = 0_usize;
            let mut covered = [false; 56];
            for action in stabilizer {
                stabilizer_size += 1;
                for &representative in THIRD_REPRESENTATIVES[case] {
                    covered[permuted_triple_index(triples, representative, action)] = true;
                }
            }
            assert_eq!(stabilizer_size, [48, 24, 72][case]);
            for (third, &is_covered) in covered.iter().enumerate().take(triples.len()).skip(1) {
                if third != second {
                    assert!(is_covered, "second={second} third={third}");
                }
            }
        }
    }

    #[test]
    fn gray_fractional_separator_matches_exhaustive_colourings() {
        let problem = compile_alignment_attachment(5).unwrap();
        let weights = (0..problem.triples().len())
            .map(|index| ((13 * index + 5) % 23) as f64 / 29.0)
            .collect::<Vec<_>>();
        let compiled = problem.minimum_fractional_context(&weights).unwrap();
        let mut direct = f64::INFINITY;
        for cut in 0..problem.cut_count() {
            let edge_count = problem.cut_edge_counts[cut] as usize;
            for free_colors in 0_u16..1_u16 << (edge_count - 1) {
                let colors = free_colors << 1;
                let mut weight = 0.0;
                for (triple, &triple_weight) in weights.iter().enumerate() {
                    let (left, right) = problem.pair(cut, triple);
                    if left != u8::MAX && (colors >> left & 1) == (colors >> right & 1) {
                        weight += triple_weight;
                    }
                }
                direct = direct.min(weight);
            }
        }
        assert!((compiled.weight - direct).abs() < 1e-12);
        let replay = weights
            .iter()
            .enumerate()
            .filter(|(index, _)| compiled.clause >> *index & 1 != 0)
            .map(|(_, weight)| weight)
            .sum::<f64>();
        assert!((compiled.weight - replay).abs() < 1e-12);
        let mut batch = [compiled; 8];
        assert_eq!(problem.fractional_contexts(&weights, &mut batch), Ok(8));
        assert_eq!(batch[0], compiled);
        assert!(batch
            .windows(2)
            .all(|pair| pair[0].weight <= pair[1].weight));
        assert!(batch.windows(2).all(|pair| pair[0].cut != pair[1].cut));
        assert_eq!(
            problem.minimum_fractional_context(&weights[..9]),
            Err(AlignmentError::Weights)
        );
    }
}
