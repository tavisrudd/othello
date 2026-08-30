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
        Ok(self.first_violation(selected).is_none())
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

    fn first_violation(&self, selected: u64) -> Option<u64> {
        let mut best = None;
        for cut in 0..self.cut_count() {
            let Some(clause) = self.violation_for_cut(cut, selected) else {
                continue;
            };
            if best.is_none_or(|prior: u64| clause.count_ones() < prior.count_ones()) {
                best = Some(clause);
            }
        }
        best
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
        let slots = seen_capacity.next_power_of_two();
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
    if budget == 0
        || budget as usize > problem.triples.len()
        || budget as usize >= workspace.frames.len()
    {
        return Err(AlignmentError::Budget);
    }
    workspace.seen.fill(0);
    workspace.frames.fill(SearchFrame::default());
    workspace.frames[0] = SearchFrame {
        selected: 1,
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
            let Some(clause) = problem.first_violation(selected) else {
                return Ok((Some(selected), metrics));
            };
            let branch_bits = clause & !selected;
            if selected.count_ones() == budget || branch_bits == 0 {
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
}
