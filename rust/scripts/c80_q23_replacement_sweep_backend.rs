//! Bounded-memory Rust backend for the C80 q=23 replacement-orbit sweep.
use std::collections::{HashMap, HashSet};
use std::env;

const Q: usize = 23;
const N: usize = Q * Q;
const WORDS: usize = N.div_ceil(64);

#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq)]
struct Bits([u64; WORDS]);

impl Bits {
    fn empty() -> Self {
        Self([0; WORDS])
    }

    fn insert(&mut self, point: usize) {
        self.0[point / 64] |= 1_u64 << (point % 64);
    }

    fn contains(self, point: usize) -> bool {
        self.0[point / 64] & (1_u64 << (point % 64)) != 0
    }

    fn with(mut self, point: usize) -> Self {
        self.insert(point);
        self
    }

    fn intersection(self, other: Self) -> Self {
        let mut result = Self::empty();
        for index in 0..WORDS {
            result.0[index] = self.0[index] & other.0[index];
        }
        result
    }

    fn count(self) -> usize {
        self.0.iter().map(|word| word.count_ones() as usize).sum()
    }

    fn iter(self) -> BitsIter {
        BitsIter {
            bits: self,
            word: 0,
        }
    }
}

struct BitsIter {
    bits: Bits,
    word: usize,
}

impl Iterator for BitsIter {
    type Item = usize;

    fn next(&mut self) -> Option<Self::Item> {
        while self.word < WORDS {
            let word = self.bits.0[self.word];
            if word != 0 {
                let offset = word.trailing_zeros() as usize;
                self.bits.0[self.word] &= self.bits.0[self.word] - 1;
                return Some(64 * self.word + offset);
            }
            self.word += 1;
        }
        None
    }
}

#[derive(Clone)]
struct Line {
    affine: Bits,
    fixed_load: u8,
}

#[derive(Default)]
struct Counts {
    opponent_fibres: u64,
    reply_candidates: u64,
    fd_edges: u64,
    fdel_edges: u64,
}

struct Witness {
    outer_opponent: usize,
    outer_reply: usize,
    opponent: usize,
    reply: usize,
    old: Vec<usize>,
    half: Vec<usize>,
    next: Vec<usize>,
    successor_fdel: bool,
}

struct Engine {
    lines: Vec<Line>,
    incident: Vec<Vec<usize>>,
    legal_cache: HashMap<Bits, Bits>,
    defect_cache: HashMap<Bits, Vec<usize>>,
    fd_cache: HashMap<Bits, bool>,
    fdel_cache: HashMap<Bits, bool>,
}

fn mod_q(value: i32) -> i32 {
    value.rem_euclid(Q as i32)
}

fn inverse(value: i32) -> i32 {
    let mut result = 1_i32;
    let mut base = mod_q(value);
    let mut exponent = Q as i32 - 2;
    while exponent != 0 {
        if exponent & 1 != 0 {
            result = mod_q(result * base);
        }
        base = mod_q(base * base);
        exponent >>= 1;
    }
    result
}

fn normalized_line(first: (i32, i32, i32), second: (i32, i32, i32)) -> (i32, i32, i32) {
    let raw = (
        mod_q(first.1 * second.2 - first.2 * second.1),
        mod_q(first.2 * second.0 - first.0 * second.2),
        mod_q(first.0 * second.1 - first.1 * second.0),
    );
    let pivot = [raw.0, raw.1, raw.2]
        .into_iter()
        .find(|value| *value != 0)
        .unwrap();
    let scale = inverse(pivot);
    (
        mod_q(raw.0 * scale),
        mod_q(raw.1 * scale),
        mod_q(raw.2 * scale),
    )
}

fn on_line(line: (i32, i32, i32), point: (i32, i32, i32)) -> bool {
    mod_q(line.0 * point.0 + line.1 * point.1 + line.2 * point.2) == 0
}

fn cell(index: usize) -> (usize, usize) {
    (index / Q, index % Q)
}

fn cell_index(row: usize, column: usize) -> usize {
    row * Q + column
}

fn format_points(points: &[usize]) -> String {
    points
        .iter()
        .map(|point| {
            let (row, column) = cell(*point);
            format!("{row},{column}")
        })
        .collect::<Vec<_>>()
        .join(";")
}

impl Engine {
    fn new() -> Self {
        let fixed = [(1, 0, 0), (0, 1, 0)];
        let affine = (0..N)
            .map(|index| {
                let (row, column) = cell(index);
                (row as i32, column as i32, 1)
            })
            .collect::<Vec<_>>();
        let mut points = fixed.to_vec();
        points.extend(affine.iter().copied());
        let mut keys = HashSet::new();
        for first in 0..points.len() {
            for second in first + 1..points.len() {
                keys.insert(normalized_line(points[first], points[second]));
            }
        }
        assert_eq!(keys.len(), Q * Q + Q + 1);
        let mut keys = keys.into_iter().collect::<Vec<_>>();
        keys.sort_unstable();
        let lines = keys
            .into_iter()
            .map(|key| {
                let mut mask = Bits::empty();
                for (index, point) in affine.iter().enumerate() {
                    if on_line(key, *point) {
                        mask.insert(index);
                    }
                }
                Line {
                    affine: mask,
                    fixed_load: fixed.iter().filter(|point| on_line(key, **point)).count() as u8,
                }
            })
            .collect::<Vec<_>>();
        let mut incident = vec![Vec::new(); N];
        for (line_index, line) in lines.iter().enumerate() {
            for point in line.affine.iter() {
                incident[point].push(line_index);
            }
        }
        assert!(incident.iter().all(|rows| rows.len() == Q + 1));
        Self {
            lines,
            incident,
            legal_cache: HashMap::new(),
            defect_cache: HashMap::new(),
            fd_cache: HashMap::new(),
            fdel_cache: HashMap::new(),
        }
    }

    fn legal(&mut self, state: Bits) -> Bits {
        if let Some(result) = self.legal_cache.get(&state) {
            return *result;
        }
        let mut result = Bits::empty();
        for point in 0..N {
            if state.contains(point) {
                continue;
            }
            let legal = self.incident[point].iter().all(|line_index| {
                let line = &self.lines[*line_index];
                line.fixed_load as usize + state.intersection(line.affine).count() < 2
            });
            if legal {
                result.insert(point);
            }
        }
        self.legal_cache.insert(state, result);
        result
    }

    fn small_boundary(&mut self, state: Bits) -> bool {
        let legal = self.legal(state);
        match legal.count() {
            0 => true,
            2 => {
                let points = legal.iter().collect::<Vec<_>>();
                self.legal(state.with(points[0])).contains(points[1])
            }
            _ => false,
        }
    }

    fn defects(&mut self, state: Bits) -> Vec<usize> {
        if let Some(result) = self.defect_cache.get(&state) {
            return result.clone();
        }
        let mut result = Vec::new();
        for opponent in self.legal(state).iter() {
            let child = state.with(opponent);
            let covered = self
                .legal(child)
                .iter()
                .any(|reply| self.small_boundary(child.with(reply)));
            if !covered {
                result.push(opponent);
            }
        }
        self.defect_cache.insert(state, result.clone());
        result
    }

    fn fd(&mut self, state: Bits) -> bool {
        if let Some(result) = self.fd_cache.get(&state) {
            return *result;
        }
        let defects = self.defects(state);
        if defects.is_empty() {
            self.fd_cache.insert(state, true);
            return true;
        }
        self.fd_cache.insert(state, false);
        let rank = defects.len();
        for opponent in defects {
            let child = state.with(opponent);
            let mut found = false;
            for reply in self.legal(child).iter() {
                let target = child.with(reply);
                if self.defects(target).len() < rank && self.fd(target) {
                    found = true;
                    break;
                }
            }
            if !found {
                return false;
            }
        }
        self.fd_cache.insert(state, true);
        true
    }

    fn fdel(&mut self, state: Bits) -> bool {
        if let Some(result) = self.fdel_cache.get(&state) {
            return *result;
        }
        let defects = self.defects(state);
        if defects.is_empty() {
            self.fdel_cache.insert(state, true);
            return true;
        }
        self.fdel_cache.insert(state, false);
        let old = defects.iter().copied().collect::<HashSet<_>>();
        for opponent in defects {
            let child = state.with(opponent);
            let mut found = false;
            for reply in self.legal(child).iter() {
                let target = child.with(reply);
                let next = self.defects(target);
                let strict_subset =
                    next.len() < old.len() && next.iter().all(|point| old.contains(point));
                if strict_subset && self.fdel(target) {
                    found = true;
                    break;
                }
            }
            if !found {
                return false;
            }
        }
        self.fdel_cache.insert(state, true);
        true
    }

    fn replacement_witnesses(
        &mut self,
        state: Bits,
        outer_opponent: usize,
        outer_reply: usize,
    ) -> Vec<Witness> {
        let old = self.defects(state);
        let old_set = old.iter().copied().collect::<HashSet<_>>();
        let rank = old.len();
        let mut result = Vec::new();
        for opponent in old.iter().copied() {
            let child = state.with(opponent);
            let half = self.defects(child);
            let mut fd_rows = Vec::new();
            let mut deletion_exists = false;
            for reply in self.legal(child).iter() {
                let successor = child.with(reply);
                let next = self.defects(successor);
                if next.len() < rank && self.fd(successor) {
                    fd_rows.push((reply, successor, next.clone()));
                }
                let next_set = next.iter().copied().collect::<HashSet<_>>();
                if next_set.len() < old_set.len()
                    && next_set.iter().all(|point| old_set.contains(point))
                    && self.fdel(successor)
                {
                    deletion_exists = true;
                }
            }
            if deletion_exists {
                continue;
            }
            for (reply, successor, next) in fd_rows {
                if next.iter().any(|point| !old_set.contains(point)) {
                    result.push(Witness {
                        outer_opponent,
                        outer_reply,
                        opponent,
                        reply,
                        old: old.clone(),
                        half: half.clone(),
                        next,
                        successor_fdel: self.fdel(successor),
                    });
                }
            }
        }
        result
    }
}

fn main() {
    let args = env::args().collect::<Vec<_>>();
    assert_eq!(args.len(), 3, "usage: backend HISTORY_ROW HISTORY_COLUMN");
    let history_row = args[1].parse::<usize>().unwrap();
    let history_column = args[2].parse::<usize>().unwrap();
    let mut engine = Engine::new();
    let mut control = Bits::empty();
    control.insert(cell_index(0, 0));
    for parameter in 1..=4 {
        control.insert(cell_index(parameter, inverse(parameter as i32) as usize));
    }
    control.insert(cell_index(history_row, history_column));

    let mut counts = Counts::default();
    let mut witnesses = Vec::new();
    for opponent in engine.legal(control).iter() {
        counts.opponent_fibres += 1;
        let child = control.with(opponent);
        for reply in engine.legal(child).iter() {
            counts.reply_candidates += 1;
            let target = child.with(reply);
            if !engine.fd(target) {
                continue;
            }
            counts.fd_edges += 1;
            if engine.fdel(target) {
                counts.fdel_edges += 1;
                continue;
            }
            witnesses.extend(engine.replacement_witnesses(target, opponent, reply));
        }
    }
    println!(
        "C\t{}\t{}\t{}\t{}",
        counts.opponent_fibres, counts.reply_candidates, counts.fd_edges, counts.fdel_edges
    );
    for witness in witnesses {
        let old = witness.old.iter().copied().collect::<HashSet<_>>();
        let half = witness.half.iter().copied().collect::<HashSet<_>>();
        let next = witness.next.iter().copied().collect::<HashSet<_>>();
        let mut created_opponent = half.difference(&old).copied().collect::<Vec<_>>();
        let mut created_reply = next.difference(&half).copied().collect::<Vec<_>>();
        let mut retained = next.intersection(&old).copied().collect::<Vec<_>>();
        let mut removed = old.difference(&next).copied().collect::<Vec<_>>();
        created_opponent.sort_unstable();
        created_reply.sort_unstable();
        retained.sort_unstable();
        removed.sort_unstable();
        println!(
            "W\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}",
            witness.outer_opponent,
            witness.outer_reply,
            witness.opponent,
            witness.reply,
            witness.old.len(),
            witness.half.len(),
            witness.next.len(),
            format_points(&created_opponent),
            format_points(&created_reply),
            format_points(&retained),
            format_points(&removed),
            u8::from(witness.successor_fdel),
        );
    }
}
