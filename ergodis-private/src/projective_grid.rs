//! Unpublished projective grid-game adapter for Ergodis root execution.
//!
//! The hot representation is a fixed five-word bitset, sufficient for the
//! prime-field controls through `q = 17`.  Root generation is deterministic;
//! roots are independent after generation and may therefore be evaluated by
//! Rayon without shared search state or evidence-order dependence.  This is a
//! research adapter, not part of the Ergodis library or release tree.

use ergodis::root_execution::{reduce_roots, RootKernel, RootOrdinal};
use serde::Serialize;
use thiserror::Error;

use crate::hall_core::{HallOutcome, HallWorkspace};

const MAX_Q: u16 = 17;
const MAX_POINTS: usize = (MAX_Q as usize) * (MAX_Q as usize);
const WORDS: usize = MAX_POINTS.div_ceil(64);

#[derive(Clone, Copy, Debug, Default, Eq, Ord, PartialEq, PartialOrd)]
#[repr(C)]
pub struct C80Bits {
    words: [u64; WORDS],
}

const _: () = assert!(size_of::<C80Bits>() == 40 && align_of::<C80Bits>() == 8);

impl C80Bits {
    #[inline]
    fn insert(&mut self, point: u16) {
        let point = usize::from(point);
        self.words[point >> 6] |= 1_u64 << (point & 63);
    }

    #[inline]
    fn contains(self, point: u16) -> bool {
        let point = usize::from(point);
        self.words[point >> 6] & (1_u64 << (point & 63)) != 0
    }

    #[inline]
    fn difference(self, right: Self) -> Self {
        let mut result = Self::default();
        let mut index = 0;
        while index < WORDS {
            result.words[index] = self.words[index] & !right.words[index];
            index += 1;
        }
        result
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
        let mut word_index = after >> 6;
        if word_index >= WORDS {
            return None;
        }
        let mut word = self.words[word_index] & (!0_u64 << (after & 63));
        loop {
            if word != 0 {
                return u16::try_from((word_index << 6) + word.trailing_zeros() as usize).ok();
            }
            word_index += 1;
            if word_index == WORDS {
                return None;
            }
            word = self.words[word_index];
        }
    }

    #[inline]
    fn nth(self, mut rank: u32) -> Option<u16> {
        let mut offset = 0_usize;
        for word in self.words {
            let count = word.count_ones();
            if rank < count {
                let mut remaining = word;
                while rank != 0 {
                    remaining &= remaining - 1;
                    rank -= 1;
                }
                return u16::try_from(offset + remaining.trailing_zeros() as usize).ok();
            }
            rank -= count;
            offset += 64;
        }
        None
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C)]
struct C80Game {
    q: u16,
    points: u16,
}

const _: () = assert!(size_of::<C80Game>() == 4 && align_of::<C80Game>() == 2);

impl C80Game {
    fn new(q: u16) -> Result<Self, C80Error> {
        if !(3..=MAX_Q).contains(&q) || !is_prime(q) {
            return Err(C80Error::UnsupportedOrder(q));
        }
        Ok(Self { q, points: q * q })
    }

    #[inline]
    fn xy(self, point: u16) -> (i32, i32) {
        (i32::from(point / self.q), i32::from(point % self.q))
    }

    #[inline]
    fn collinear(self, left: u16, middle: u16, right: u16) -> bool {
        let (lx, ly) = self.xy(left);
        let (mx, my) = self.xy(middle);
        let (rx, ry) = self.xy(right);
        ((mx - lx) * (ry - ly) - (my - ly) * (rx - lx)).rem_euclid(i32::from(self.q)) == 0
    }

    fn legal_after(self, state: C80Bits, point: u16) -> bool {
        if state.contains(point) {
            return false;
        }
        let (px, py) = self.xy(point);
        let mut left = state.next(0);
        while let Some(a) = left {
            let (ax, ay) = self.xy(a);
            if px == ax || py == ay {
                return false;
            }
            let mut right = state.next(usize::from(a) + 1);
            while let Some(b) = right {
                if self.collinear(a, b, point) {
                    return false;
                }
                right = state.next(usize::from(b) + 1);
            }
            left = state.next(usize::from(a) + 1);
        }
        true
    }

    fn legal(self, state: C80Bits) -> C80Bits {
        let mut result = C80Bits::default();
        let mut point = 0_u16;
        while point < self.points {
            if self.legal_after(state, point) {
                result.insert(point);
            }
            point += 1;
        }
        result
    }

    fn omega(self, state: C80Bits, legal: C80Bits) -> u32 {
        let q = usize::from(self.q);
        let mut total = 0_u32;
        let mut slope = 1_i32;
        while slope < i32::from(self.q) {
            let mut selected = [false; MAX_Q as usize];
            let mut point = state.next(0);
            while let Some(index) = point {
                let (x, y) = self.xy(index);
                selected[(y - slope * x).rem_euclid(i32::from(self.q)) as usize] = true;
                point = state.next(usize::from(index) + 1);
            }
            let mut counts = [0_u16; MAX_Q as usize];
            point = legal.next(0);
            while let Some(index) = point {
                let (x, y) = self.xy(index);
                counts[(y - slope * x).rem_euclid(i32::from(self.q)) as usize] += 1;
                point = legal.next(usize::from(index) + 1);
            }
            let mut intercept = 0;
            while intercept < q {
                if !selected[intercept] {
                    total += u32::from(counts[intercept].saturating_sub(2));
                }
                intercept += 1;
            }
            slope += 1;
        }
        total
    }

    fn is_small_boundary(self, state: C80Bits) -> bool {
        let legal = self.legal(state);
        if self.omega(state, legal) != 0 {
            return false;
        }
        match legal.count() {
            0 => true,
            2 => {
                let left = legal.next(0).expect("two legal points");
                let right = legal.next(usize::from(left) + 1).expect("two legal points");
                let mut child = state;
                child.insert(left);
                self.legal_after(child, right)
            }
            _ => false,
        }
    }

    fn defects(self, state: C80Bits) -> C80Bits {
        let mut defects = C80Bits::default();
        let legal = self.legal(state);
        let mut opponent = legal.next(0);
        while let Some(candidate) = opponent {
            let mut child = state;
            child.insert(candidate);
            let replies = self.legal(child);
            let mut reply = replies.next(0);
            let mut certified = false;
            while let Some(response) = reply {
                let mut target = child;
                target.insert(response);
                if self.is_small_boundary(target) {
                    certified = true;
                    break;
                }
                reply = replies.next(usize::from(response) + 1);
            }
            if !certified {
                defects.insert(candidate);
            }
            opponent = legal.next(usize::from(candidate) + 1);
        }
        defects
    }
}

#[derive(Clone, Copy, Debug, Default, Eq, PartialEq, Serialize)]
pub struct C80ScoutMetrics {
    pub states: u64,
    pub complete_exchanges: u64,
    pub exchanges_with_new_defects: u64,
    pub new_defects: u64,
    pub maximum_new_defects: u32,
    pub nondecreasing_exchanges: u64,
    pub complete_relation_failures: u64,
    pub support_first_lex_failures: u64,
    pub omega_first_lex_failures: u64,
    pub ancestral_secant_edges: u64,
    pub ancestral_secant_zero_degree_defects: u64,
    pub ancestral_secant_hall_failures: u64,
}

impl C80ScoutMetrics {
    fn merge(mut self, right: Self) -> Self {
        self.states += right.states;
        self.complete_exchanges += right.complete_exchanges;
        self.exchanges_with_new_defects += right.exchanges_with_new_defects;
        self.new_defects += right.new_defects;
        self.maximum_new_defects = self.maximum_new_defects.max(right.maximum_new_defects);
        self.nondecreasing_exchanges += right.nondecreasing_exchanges;
        self.complete_relation_failures += right.complete_relation_failures;
        self.support_first_lex_failures += right.support_first_lex_failures;
        self.omega_first_lex_failures += right.omega_first_lex_failures;
        self.ancestral_secant_edges += right.ancestral_secant_edges;
        self.ancestral_secant_zero_degree_defects += right.ancestral_secant_zero_degree_defects;
        self.ancestral_secant_hall_failures += right.ancestral_secant_hall_failures;
        self
    }
}

struct C80Worker {
    hall: HallWorkspace,
    offsets: Vec<u32>,
    neighbors: Vec<u32>,
}

impl C80Worker {
    fn new(points: usize) -> Self {
        Self {
            hall: HallWorkspace::new(points, points),
            offsets: Vec::with_capacity(points + 1),
            neighbors: Vec::with_capacity(points * points),
        }
    }

    fn ancestral_secant_hall(
        &mut self,
        game: C80Game,
        state: C80Bits,
        created: C80Bits,
        consumed: C80Bits,
    ) -> (HallOutcome, u64, u64) {
        self.offsets.clear();
        self.neighbors.clear();
        self.offsets.push(0);
        let mut zero_degree = 0_u64;
        let mut defect = created.next(0);
        while let Some(new_defect) = defect {
            let begin = self.neighbors.len();
            let mut label_rank = 0_u32;
            let mut label = consumed.next(0);
            while let Some(old_label) = label {
                let mut carrier = state.next(0);
                let mut adjacent = false;
                while let Some(selected) = carrier {
                    if selected != new_defect
                        && selected != old_label
                        && game.collinear(new_defect, old_label, selected)
                    {
                        adjacent = true;
                        break;
                    }
                    carrier = state.next(usize::from(selected) + 1);
                }
                if adjacent {
                    self.neighbors.push(label_rank);
                }
                label_rank += 1;
                label = consumed.next(usize::from(old_label) + 1);
            }
            if self.neighbors.len() == begin {
                zero_degree += 1;
            }
            self.offsets.push(self.neighbors.len() as u32);
            defect = created.next(usize::from(new_defect) + 1);
        }
        let edge_count = self.neighbors.len() as u64;
        let outcome = self
            .hall
            .solve(
                created.count() as usize,
                consumed.count() as usize,
                &self.offsets,
                &self.neighbors,
            )
            .expect("internally compiled Hall graph is valid");
        (outcome, edge_count, zero_degree)
    }
}

fn scout_root(game: C80Game, state: C80Bits, worker: &mut C80Worker) -> C80ScoutMetrics {
    let mut metrics = C80ScoutMetrics {
        states: 1,
        ..C80ScoutMetrics::default()
    };
    let old_defects = game.defects(state);
    let old_support = old_defects.count();
    let state_legal = game.legal(state);
    let old_omega = game.omega(state, state_legal);
    let mut opponent = state_legal.next(0);
    while let Some(first) = opponent {
        if old_defects.contains(first) {
            let mut child = state;
            child.insert(first);
            let half_defects = game.defects(child);
            let child_legal = game.legal(child);
            let mut causal = child_legal.next(0);
            while let Some(second) = causal {
                if old_defects.contains(second) {
                    metrics.complete_exchanges += 1;
                    let mut successor = child;
                    successor.insert(second);
                    let next_defects = game.defects(successor);
                    let created = next_defects
                        .difference(half_defects)
                        .difference(old_defects);
                    if !created.is_empty() {
                        let consumed = old_defects.difference(next_defects);
                        let created_count = created.count();
                        let consumed_count = consumed.count();
                        metrics.exchanges_with_new_defects += 1;
                        metrics.new_defects += u64::from(created_count);
                        metrics.maximum_new_defects =
                            metrics.maximum_new_defects.max(created_count);
                        if consumed_count <= created_count {
                            metrics.nondecreasing_exchanges += 1;
                        }
                        if consumed_count < created_count {
                            metrics.complete_relation_failures += 1;
                        }
                        let (hall, edges, zero_degree) =
                            worker.ancestral_secant_hall(game, state, created, consumed);
                        metrics.ancestral_secant_edges += edges;
                        metrics.ancestral_secant_zero_degree_defects += zero_degree;
                        if matches!(hall, HallOutcome::Deficient { .. }) {
                            metrics.ancestral_secant_hall_failures += 1;
                        }
                        let next_support = next_defects.count();
                        let next_legal = game.legal(successor);
                        let next_omega = game.omega(successor, next_legal);
                        if (next_support, next_omega) >= (old_support, old_omega) {
                            metrics.support_first_lex_failures += 1;
                        }
                        if (next_omega, next_support) >= (old_omega, old_support) {
                            metrics.omega_first_lex_failures += 1;
                        }
                    }
                }
                causal = child_legal.next(usize::from(second) + 1);
            }
        }
        opponent = state_legal.next(usize::from(first) + 1);
    }
    metrics
}

struct C80Kernel {
    game: C80Game,
}

impl RootKernel for C80Kernel {
    type Root = C80Bits;
    type Worker = C80Worker;
    type Output = C80ScoutMetrics;

    #[inline]
    fn create_worker(&self) -> Self::Worker {
        C80Worker::new(usize::from(self.game.points))
    }

    #[inline]
    fn evaluate(
        &self,
        worker: &mut Self::Worker,
        _ordinal: RootOrdinal,
        root: &Self::Root,
    ) -> Self::Output {
        scout_root(self.game, *root, worker)
    }
}

fn roots(game: C80Game, state_budget: usize, seed: u64) -> Vec<C80Bits> {
    let mut rng = XorShift64::new(seed);
    let mut roots = Vec::with_capacity(state_budget);
    let mut attempts = 0_usize;
    while roots.len() < state_budget && attempts < state_budget.saturating_mul(20) {
        attempts += 1;
        let mut state = C80Bits::default();
        let mut selected = 0;
        while selected < 4 {
            let legal = game.legal(state);
            let count = legal.count();
            if count == 0 {
                break;
            }
            let point = legal
                .nth((rng.next() % u64::from(count)) as u32)
                .expect("rank is in range");
            state.insert(point);
            selected += 1;
        }
        if selected == 4 && !roots.contains(&state) {
            roots.push(state);
        }
    }
    roots.sort_unstable();
    roots
}

pub fn scout(
    q: u16,
    state_budget: usize,
    seed: u64,
    threads: usize,
) -> Result<C80ScoutMetrics, C80Error> {
    if threads == 0 {
        return Err(C80Error::ZeroThreads);
    }
    let game = C80Game::new(q)?;
    let roots = roots(game, state_budget, seed);
    if roots.len() != state_budget {
        return Err(C80Error::InsufficientRoots {
            requested: state_budget,
            generated: roots.len(),
        });
    }
    reduce_roots(
        &C80Kernel { game },
        &roots,
        threads,
        C80ScoutMetrics::default,
        C80ScoutMetrics::merge,
    )
    .map_err(|error| C80Error::RootExecution(error.to_string()))
}

#[derive(Debug, Error)]
pub enum C80Error {
    #[error("C80 currently supports prime orders 3 through {MAX_Q}, not {0}")]
    UnsupportedOrder(u16),
    #[error("thread count must be positive")]
    ZeroThreads,
    #[error("requested {requested} roots but generated only {generated}")]
    InsufficientRoots { requested: usize, generated: usize },
    #[error("C80 root execution failed: {0}")]
    RootExecution(String),
}

#[derive(Clone, Copy)]
#[repr(transparent)]
struct XorShift64(u64);

impl XorShift64 {
    fn new(seed: u64) -> Self {
        Self(seed.max(1))
    }

    #[inline]
    fn next(&mut self) -> u64 {
        let mut value = self.0;
        value ^= value << 13;
        value ^= value >> 7;
        value ^= value << 17;
        self.0 = value;
        value
    }
}

const fn is_prime(value: u16) -> bool {
    let mut divisor = 2_u16;
    while divisor * divisor <= value {
        if value % divisor == 0 {
            return false;
        }
        divisor += 1;
    }
    true
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn empty_and_singleton_legal_counts_match_the_grid_rules() {
        let game = C80Game::new(11).unwrap();
        let empty = C80Bits::default();
        assert_eq!(game.legal(empty).count(), 121);
        let mut singleton = empty;
        singleton.insert(0);
        assert_eq!(game.legal(singleton).count(), 100);
    }

    #[test]
    fn parallel_root_reduction_is_exact() {
        let serial = scout(5, 24, 98_508_030, 1).unwrap();
        assert_eq!(scout(5, 24, 98_508_030, 4).unwrap(), serial);
    }
}
