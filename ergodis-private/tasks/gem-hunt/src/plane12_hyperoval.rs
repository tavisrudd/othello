//! C1018 wave 2B (gem-mining): completion search for an order-(n+1) invariant
//! projective plane of order n, with an optional invariant hyperoval.
//!
//! Model.  Let `p = n + 1` be prime and let `s` be a collineation of order `p`
//! of a plane of order `n`.  Wave 2A proved that `s` has exactly one fixed
//! point `P` and one fixed line `L`, non-incident, so the point orbits are
//! `{P}` and `n` orbits of size `p` (one of them the point set of `L`) and
//! dually for lines.  Normalizing base points and base lines so that the orbit
//! of `L` and the pencil through `P` carry the singleton `{0}`, the plane
//! axioms become exactly:
//!
//!   * for each `x` in `Z_p \ {0}` the map `i -> j` with `x` in `D_ij` is a
//!     bijection `pi_x` of `{1..n-1}` (the row and column cover conditions);
//!   * for every ordered pair `(i, k)` and every nonzero `g`, exactly one `x`
//!     with `x` and `x-g` nonzero satisfies `pi_x(i) = pi_{x-g}(k)`.
//!
//! The second condition is an exact cover: the `n(n-1)` ordered pairs of
//! distinct nonzero `x` claim `n-1` slots `(g, i, k)` each, filling the
//! `n * (n-1)^2` slots exactly once, so a repeated claim refutes immediately.
//!
//! An `s`-invariant hyperoval exists exactly when some row `m` has
//! `x -> pi_x(m)` two-to-one; that row's fibres are the starter of the
//! one-factorization of `K_{n+2}` induced on `L`.
//!
//! Normalizations, all lossless: relabelling line orbits sets `pi_1 = id`;
//! conjugating by a relabelling of point orbits then moves the hyperoval row to
//! index 0 while preserving `pi_1 = id`; the residual conjugation symmetry lets
//! `pi_2` be restricted to one representative per conjugacy class.  The classes
//! are the cycle types of `n-1` points in general mode, and cycle types
//! together with the length of the cycle containing row 0 in hyperoval mode.
//! Those classes are independent subtrees, so they are searched in parallel and
//! reported one by one: a run that does not exhaust still certifies exactly
//! which classes are eliminated.
//!
//! Hall's condition enters where the problem is matching-shaped: at each level
//! the admissible `(row, column)` pairs are fixed by the earlier levels and
//! `pi_x` is a perfect matching of that bipartite graph, so a Hall-deficient set
//! from `ergodis_private::hall_core` prunes the level with an explicit witness.

use std::fs::{self, File};
use std::io::BufWriter;
use std::path::PathBuf;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::time::Instant;

use anyhow::{bail, Result};
use ergodis_private::hall_core::{HallOutcome, HallWorkspace};
use serde::Serialize;

#[derive(clap::Args)]
pub struct HyperovalArgs {
    /// Plane order; n + 1 must be prime.
    #[arg(long, default_value_t = 12)]
    n: usize,
    /// Require an invariant hyperoval (row 0 two-to-one).
    #[arg(long, default_value_t = false)]
    hyperoval: bool,
    /// Wall-clock cap per level-2 class, in seconds; 0 means unbounded.
    #[arg(long, default_value_t = 0)]
    seconds: u64,
    /// Worker threads.
    #[arg(long, default_value_t = 0)]
    threads: usize,
    /// Stop after this many levels and count the surviving partial
    /// configurations instead of the complete ones; 0 means all levels.
    #[arg(long, default_value_t = 0)]
    depth: usize,
}

#[derive(Serialize, Clone)]
struct ClassResult {
    index: usize,
    cycle_type: Vec<usize>,
    nodes: u64,
    hall_prunes: u64,
    max_depth: usize,
    solutions: u64,
    exhausted: bool,
    seconds: f64,
    example: Option<Vec<Vec<u8>>>,
}

#[derive(Serialize)]
struct Certificate {
    schema: &'static str,
    n: usize,
    p: usize,
    rows: usize,
    x_values: usize,
    slots: usize,
    hyperoval: bool,
    depth_limit: usize,
    normalization: &'static str,
    level_two_classes: usize,
    classes_exhausted: usize,
    classes_incomplete: Vec<usize>,
    nodes: u64,
    hall_prunes: u64,
    max_depth_reached: usize,
    solutions: u64,
    exhausted: bool,
    seconds: f64,
    per_class: Vec<ClassResult>,
    example: Option<Vec<Vec<u8>>>,
    verdict: String,
}

struct Search {
    p: usize,
    r: usize,
    xs: usize,
    hyperoval: bool,
    slot: Vec<bool>,
    perm: Vec<Vec<u8>>,
    inv: Vec<Vec<u8>>,
    cnt: Vec<u8>,
    nodes: u64,
    hall_prunes: u64,
    max_depth: usize,
    solutions: u64,
    example: Option<Vec<Vec<u8>>>,
    deadline: Option<Instant>,
    stopped: bool,
    limit: usize,
    ws: HallWorkspace,
}

impl Search {
    fn new(n: usize, hyperoval: bool, deadline: Option<Instant>, depth: usize) -> Self {
        let p = n + 1;
        let r = n - 1;
        let xs = p - 1;
        let limit = if depth == 0 { xs } else { depth.min(xs) };
        let mut search = Self {
            p,
            r,
            xs,
            hyperoval,
            slot: vec![false; xs * r * r],
            perm: vec![vec![0u8; r]; xs + 1],
            inv: vec![vec![0u8; r]; xs + 1],
            cnt: vec![0u8; r],
            nodes: 0,
            hall_prunes: 0,
            max_depth: 1,
            solutions: 0,
            example: None,
            deadline,
            stopped: false,
            limit,
            ws: HallWorkspace::new(r, r),
        };
        for i in 0..r {
            search.perm[1][i] = i as u8;
            search.inv[1][i] = i as u8;
        }
        if hyperoval {
            search.cnt[0] = 1;
        }
        search
    }

    fn slot_index(&self, g: usize, i: usize, k: usize) -> usize {
        (g - 1) * self.r * self.r + i * self.r + k
    }

    /// Claim every slot forced by `pi_x(i) = v` against the placed levels.
    /// Two claims made at the same level collide exactly when `y1 + y2 = 2x`,
    /// so the claim is made and checked one earlier level at a time.
    fn try_mark(&mut self, x: usize, i: usize, v: usize) -> bool {
        for y in 1..x {
            let k = self.inv[y][v] as usize;
            let g1 = (x + self.p - y) % self.p;
            let g2 = (y + self.p - x) % self.p;
            let a = self.slot_index(g1, i, k);
            let b = self.slot_index(g2, k, i);
            if self.slot[a] || self.slot[b] {
                self.unmark_prefix(x, i, v, y);
                return false;
            }
            self.slot[a] = true;
            self.slot[b] = true;
        }
        true
    }

    fn unmark_prefix(&mut self, x: usize, i: usize, v: usize, upto: usize) {
        for y in 1..upto {
            let k = self.inv[y][v] as usize;
            let g1 = (x + self.p - y) % self.p;
            let g2 = (y + self.p - x) % self.p;
            let a = self.slot_index(g1, i, k);
            let b = self.slot_index(g2, k, i);
            self.slot[a] = false;
            self.slot[b] = false;
        }
    }

    fn unmark(&mut self, x: usize, i: usize, v: usize) {
        self.unmark_prefix(x, i, v, x);
    }

    /// Values still admissible for each row at level `x`, given earlier levels.
    /// A superset of the truth, which is all a pruning look-ahead needs.
    fn admissible(&self, x: usize) -> Vec<u16> {
        let mut out = vec![0u16; self.r];
        for i in 0..self.r {
            let mut mask = 0u16;
            'value: for v in 0..self.r {
                if self.hyperoval && i == 0 && self.cnt[v] >= 2 {
                    continue;
                }
                for y in 1..x {
                    let k = self.inv[y][v] as usize;
                    let g1 = (x + self.p - y) % self.p;
                    let g2 = (y + self.p - x) % self.p;
                    if self.slot[self.slot_index(g1, i, k)] || self.slot[self.slot_index(g2, k, i)]
                    {
                        continue 'value;
                    }
                }
                mask |= 1 << v;
            }
            out[i] = mask;
        }
        out
    }

    /// Hall test on the residual bipartite graph: unassigned rows against
    /// unused columns.  `pi_x` restricted to those rows must be a perfect
    /// matching, so a deficient set refutes the whole partial assignment.
    fn hall_feasible(&mut self, admissible: &[u16], assigned: u16, used: u16) -> bool {
        let r = self.r;
        let mut offsets = Vec::with_capacity(r + 1);
        let mut neighbors = Vec::with_capacity(r * r);
        let mut column_of = [0usize; 16];
        let mut right = 0usize;
        for v in 0..r {
            if used & (1 << v) == 0 {
                column_of[v] = right;
                right += 1;
            }
        }
        offsets.push(0u32);
        let mut left = 0usize;
        for i in 0..r {
            if assigned & (1 << i) != 0 {
                continue;
            }
            let mask = admissible[i] & !used;
            for v in 0..r {
                if mask & (1 << v) != 0 {
                    neighbors.push(column_of[v] as u32);
                }
            }
            offsets.push(neighbors.len() as u32);
            left += 1;
        }
        matches!(
            self.ws.solve(left, right, &offsets, &neighbors),
            Ok(HallOutcome::Saturated)
        )
    }

    fn hyperoval_feasible(&self, assigned_levels: usize) -> bool {
        let remaining = self.xs - assigned_levels;
        let ones = self.cnt.iter().filter(|c| **c == 1).count();
        let zeros = self.cnt.iter().filter(|c| **c == 0).count();
        if ones > remaining {
            return false;
        }
        let spare = remaining - ones;
        spare % 2 == 0 && spare / 2 <= zeros
    }

    fn out_of_budget(&mut self) -> bool {
        if self.stopped {
            return true;
        }
        if self.nodes % 8192 == 0 {
            if let Some(deadline) = self.deadline {
                if Instant::now() >= deadline {
                    self.stopped = true;
                    return true;
                }
            }
        }
        false
    }

    fn fill_level(&mut self, x: usize, assigned: u16, used: u16, admissible: &[u16]) {
        if self.stopped {
            return;
        }
        let full = if self.r == 16 {
            u16::MAX
        } else {
            (1u16 << self.r) - 1
        };
        if assigned == full {
            self.max_depth = self.max_depth.max(x);
            for i in 0..self.r {
                self.inv[x][self.perm[x][i] as usize] = i as u8;
            }
            if self.hyperoval {
                self.cnt[self.perm[x][0] as usize] += 1;
            }
            if !self.hyperoval || self.hyperoval_feasible(x) {
                self.descend(x + 1);
            }
            if self.hyperoval {
                self.cnt[self.perm[x][0] as usize] -= 1;
            }
            return;
        }
        if !self.hall_feasible(admissible, assigned, used) {
            self.hall_prunes += 1;
            return;
        }
        // Most constrained row first.
        let mut row = usize::MAX;
        let mut best = usize::MAX;
        for i in 0..self.r {
            if assigned & (1 << i) != 0 {
                continue;
            }
            let count = (admissible[i] & !used).count_ones() as usize;
            if count < best {
                best = count;
                row = i;
            }
        }
        let mut mask = admissible[row] & !used;
        while mask != 0 {
            if self.out_of_budget() {
                return;
            }
            let v = mask.trailing_zeros() as usize;
            mask &= mask - 1;
            self.nodes += 1;
            if !self.try_mark(x, row, v) {
                continue;
            }
            self.perm[x][row] = v as u8;
            self.fill_level(x, assigned | (1 << row), used | (1 << v), admissible);
            self.unmark(x, row, v);
            if self.stopped {
                return;
            }
        }
    }

    fn descend(&mut self, x: usize) {
        if self.stopped {
            return;
        }
        if x > self.limit {
            self.solutions += 1;
            if self.example.is_none() {
                self.example = Some(self.perm[1..=self.limit].to_vec());
            }
            return;
        }
        let admissible = self.admissible(x);
        self.fill_level(x, 0, 0, &admissible);
    }

    /// Search the subtree whose level-2 permutation is `rep`.
    fn run_class(&mut self, rep: &[u8]) {
        let mut placed = 0usize;
        let mut ok = true;
        for i in 0..self.r {
            let v = rep[i] as usize;
            if self.try_mark(2, i, v) {
                self.perm[2][i] = v as u8;
                placed += 1;
            } else {
                ok = false;
                break;
            }
        }
        if ok {
            self.max_depth = 2;
            for i in 0..self.r {
                self.inv[2][self.perm[2][i] as usize] = i as u8;
            }
            if self.hyperoval {
                self.cnt[self.perm[2][0] as usize] += 1;
            }
            if !self.hyperoval || self.hyperoval_feasible(2) {
                self.descend(3);
            }
            if self.hyperoval {
                self.cnt[self.perm[2][0] as usize] -= 1;
            }
        }
        for i in (0..placed).rev() {
            let v = self.perm[2][i] as usize;
            self.unmark(2, i, v);
        }
    }
}

fn integer_partitions(target: usize, max: usize) -> Vec<Vec<usize>> {
    let mut out = Vec::new();
    fn go(target: usize, max: usize, current: &mut Vec<usize>, out: &mut Vec<Vec<usize>>) {
        if target == 0 {
            out.push(current.clone());
            return;
        }
        for part in (1..=max.min(target)).rev() {
            current.push(part);
            go(target - part, part, current, out);
            current.pop();
        }
    }
    go(target, max, &mut Vec::new(), &mut out);
    out
}

fn permutation_from_cycles(cycles: &[usize], r: usize) -> Vec<u8> {
    let mut perm = vec![0u8; r];
    let mut base = 0usize;
    for len in cycles {
        for t in 0..*len {
            perm[base + t] = (base + (t + 1) % len) as u8;
        }
        base += len;
    }
    perm
}

/// One representative per conjugacy class of the residual symmetry group.
fn level_two_classes(r: usize, hyperoval: bool) -> Vec<(Vec<usize>, Vec<u8>)> {
    let mut out = Vec::new();
    if hyperoval {
        // Conjugation must fix row 0, so the invariant is the cycle type plus
        // the length of the cycle through row 0, which is placed first.
        for lead in 1..=r {
            for rest in integer_partitions(r - lead, r - lead) {
                let mut cycles = vec![lead];
                cycles.extend_from_slice(&rest);
                let perm = permutation_from_cycles(&cycles, r);
                out.push((cycles, perm));
            }
        }
    } else {
        for cycles in integer_partitions(r, r) {
            let perm = permutation_from_cycles(&cycles, r);
            out.push((cycles, perm));
        }
    }
    out
}

fn is_prime(m: usize) -> bool {
    if m < 2 {
        return false;
    }
    let mut d = 2;
    while d * d <= m {
        if m % d == 0 {
            return false;
        }
        d += 1;
    }
    true
}

pub fn run(out: PathBuf, args: HyperovalArgs) -> Result<()> {
    let n = args.n;
    let p = n + 1;
    if !is_prime(p) {
        bail!("n + 1 must be prime");
    }
    if n < 3 {
        bail!("n must be at least 3");
    }
    let r = n - 1;
    let xs = p - 1;
    let classes = level_two_classes(r, args.hyperoval);
    let threads = if args.threads > 0 {
        args.threads
    } else {
        std::thread::available_parallelism()
            .map(|t| t.get().min(20))
            .unwrap_or(4)
    };

    let start = Instant::now();
    let next = AtomicUsize::new(0);
    let classes_ref = &classes;
    let collected: Vec<Vec<ClassResult>> = std::thread::scope(|scope| {
        let handles: Vec<_> = (0..threads)
            .map(|_| {
                let next = &next;
                scope.spawn(move || {
                    let mut mine: Vec<ClassResult> = Vec::new();
                    loop {
                        let idx = next.fetch_add(1, Ordering::Relaxed);
                        if idx >= classes_ref.len() {
                            break;
                        }
                        let (cycle_type, rep) = &classes_ref[idx];
                        let deadline = if args.seconds > 0 {
                            Some(Instant::now() + std::time::Duration::from_secs(args.seconds))
                        } else {
                            None
                        };
                        let began = Instant::now();
                        let mut search = Search::new(n, args.hyperoval, deadline, args.depth);
                        search.run_class(rep);
                        mine.push(ClassResult {
                            index: idx,
                            cycle_type: cycle_type.clone(),
                            nodes: search.nodes,
                            hall_prunes: search.hall_prunes,
                            max_depth: search.max_depth,
                            solutions: search.solutions,
                            exhausted: !search.stopped,
                            seconds: began.elapsed().as_secs_f64(),
                            example: search.example.clone(),
                        });
                    }
                    mine
                })
            })
            .collect();
        handles.into_iter().map(|h| h.join().unwrap()).collect()
    });
    let elapsed = start.elapsed().as_secs_f64();

    let mut per_class: Vec<ClassResult> = collected.into_iter().flatten().collect();
    per_class.sort_by_key(|c| c.index);

    let nodes: u64 = per_class.iter().map(|c| c.nodes).sum();
    let hall_prunes: u64 = per_class.iter().map(|c| c.hall_prunes).sum();
    let solutions: u64 = per_class.iter().map(|c| c.solutions).sum();
    let max_depth = per_class.iter().map(|c| c.max_depth).max().unwrap_or(1);
    let classes_exhausted = per_class.iter().filter(|c| c.exhausted).count();
    let classes_incomplete: Vec<usize> = per_class
        .iter()
        .filter(|c| !c.exhausted)
        .map(|c| c.index)
        .collect();
    let exhausted = classes_incomplete.is_empty();
    let example = per_class.iter().find_map(|c| c.example.clone());

    let limit = if args.depth == 0 {
        xs
    } else {
        args.depth.min(xs)
    };
    let verdict = if solutions > 0 && limit < xs {
        format!("{solutions} partial configurations survive to level {limit} (exhaustive at that depth)")
    } else if solutions > 0 {
        format!("{solutions} solution(s) found")
    } else if exhausted {
        format!(
            "eliminated: no order-{p} invariant plane of order {n}{}",
            if args.hyperoval {
                " with an invariant hyperoval"
            } else {
                ""
            }
        )
    } else {
        format!(
            "partial: {classes_exhausted} of {} level-2 classes eliminated, {} incomplete",
            per_class.len(),
            classes_incomplete.len()
        )
    };

    let certificate = Certificate {
        schema: "c1018.plane12.invariant.v2",
        n,
        p,
        rows: r,
        x_values: xs,
        slots: xs * r * r,
        hyperoval: args.hyperoval,
        depth_limit: if args.depth == 0 {
            xs
        } else {
            args.depth.min(xs)
        },
        normalization:
            "pi_1 = identity; hyperoval row = 0; pi_2 one representative per conjugacy class",
        level_two_classes: per_class.len(),
        classes_exhausted,
        classes_incomplete,
        nodes,
        hall_prunes,
        max_depth_reached: max_depth,
        solutions,
        exhausted,
        seconds: elapsed,
        per_class,
        example,
        verdict,
    };

    if let Some(parent) = out.parent() {
        fs::create_dir_all(parent)?;
    }
    let writer = BufWriter::new(File::create(&out)?);
    serde_json::to_writer_pretty(writer, &certificate)?;
    println!(
        "{}",
        serde_json::to_string(&serde_json::json!({
            "n": certificate.n,
            "hyperoval": certificate.hyperoval,
            "classes": certificate.level_two_classes,
            "exhausted_classes": certificate.classes_exhausted,
            "nodes": certificate.nodes,
            "solutions": certificate.solutions,
            "exhausted": certificate.exhausted,
            "seconds": certificate.seconds,
            "verdict": certificate.verdict,
        }))?
    );
    Ok(())
}
