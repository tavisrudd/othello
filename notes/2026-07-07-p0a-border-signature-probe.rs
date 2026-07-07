// P0a border-signature census / valtest probe.
//
// Standalone by design: compile with
//   rustc -O 2026-07-07-p0a-border-signature-probe.rs -o /tmp/p0a-probe
//
// Interpretation note: Appendix P0a's n=20 plan and live-count formulas force
// the paired core to be [0..n-2]^2 with tau(r,c)=(n-2-r,n-2-c).  The appendix's
// [0..n-3]^2 text is treated as a half-open/range typo; otherwise the documented
// n=18/n=20 paired-core counts do not match.

use std::collections::{BTreeMap, BTreeSet, HashMap, HashSet};
use std::env;

const MAXW: usize = 8; // enough for n <= 20 (400 bits)

#[derive(Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord, Debug)]
struct Mask([u64; MAXW]);

impl Mask {
    fn zero() -> Self {
        Mask([0; MAXW])
    }
    fn set(&mut self, i: usize) {
        self.0[i / 64] |= 1u64 << (i % 64);
    }
    fn has(&self, i: usize) -> bool {
        ((self.0[i / 64] >> (i % 64)) & 1) != 0
    }
    fn and(self, rhs: Mask) -> Mask {
        let mut out = [0u64; MAXW];
        for i in 0..MAXW {
            out[i] = self.0[i] & rhs.0[i];
        }
        Mask(out)
    }
    fn minus(self, rhs: Mask) -> Mask {
        let mut out = [0u64; MAXW];
        for i in 0..MAXW {
            out[i] = self.0[i] & !rhs.0[i];
        }
        Mask(out)
    }
    fn count(&self) -> u32 {
        self.0.iter().map(|x| x.count_ones()).sum()
    }
    fn is_empty(&self) -> bool {
        self.0.iter().all(|&x| x == 0)
    }
    fn iter(self) -> MaskIter {
        MaskIter { mask: self, word: 0 }
    }
}

struct MaskIter {
    mask: Mask,
    word: usize,
}

impl Iterator for MaskIter {
    type Item = usize;
    fn next(&mut self) -> Option<usize> {
        while self.word < MAXW {
            let bits = self.mask.0[self.word];
            if bits != 0 {
                let tz = bits.trailing_zeros() as usize;
                self.mask.0[self.word] &= bits - 1;
                return Some(self.word * 64 + tz);
            }
            self.word += 1;
        }
        None
    }
}

#[derive(Clone)]
struct Board {
    n: usize,
    closed: Vec<Mask>,
    full: Mask,
    residual: Mask,
    core: Mask,
    border: Mask,
    row_arm: Mask,
    col_arm: Mask,
}

impl Board {
    fn new(n: usize) -> Board {
        assert!(n <= 20);
        let nn = n * n;
        let mut full = Mask::zero();
        for i in 0..nn {
            full.set(i);
        }
        let mut closed = vec![Mask::zero(); nn];
        for i in 0..nn {
            for j in 0..nn {
                if i == j || attacks(n, i, j) {
                    closed[i].set(j);
                }
            }
        }
        let h = n / 2 - 1;
        let root = idx(n, h, h);
        let residual = full.minus(closed[root]);

        let mut core = Mask::zero();
        let mut border = Mask::zero();
        let mut row_arm = Mask::zero();
        let mut col_arm = Mask::zero();
        for r in 0..n {
            for c in 0..n {
                let z = idx(n, r, c);
                if r <= n - 2 && c <= n - 2 {
                    core.set(z);
                }
                if r == n - 1 || c == n - 1 {
                    border.set(z);
                }
                if r == n - 1 && c < n - 1 {
                    row_arm.set(z);
                }
                if c == n - 1 && r < n - 1 {
                    col_arm.set(z);
                }
            }
        }
        core = core.and(residual);
        border = border.and(residual);
        row_arm = row_arm.and(residual);
        col_arm = col_arm.and(residual);
        Board { n, closed, full, residual, core, border, row_arm, col_arm }
    }

    fn play(&self, live: Mask, z: usize) -> Mask {
        live.minus(self.closed[z])
    }

    fn tau(&self, z: usize) -> Option<usize> {
        let (r, c) = rc(self.n, z);
        if r <= self.n - 2 && c <= self.n - 2 {
            Some(idx(self.n, self.n - 2 - r, self.n - 2 - c))
        } else {
            None
        }
    }

    fn is_border(&self, z: usize) -> bool {
        self.border.has(z)
    }

    fn is_core(&self, z: usize) -> bool {
        self.core.has(z)
    }

    fn is_event_move(&self, live: Mask, z: usize) -> bool {
        if self.is_border(z) {
            return true;
        }
        if self.is_core(z) {
            return match self.tau(z) {
                Some(tz) => !live.has(tz),
                None => true,
            };
        }
        true
    }
}

fn idx(n: usize, r: usize, c: usize) -> usize {
    r * n + c
}

fn rc(n: usize, z: usize) -> (usize, usize) {
    (z / n, z % n)
}

fn attacks(n: usize, a: usize, b: usize) -> bool {
    if a == b {
        return false;
    }
    let (ar, ac) = rc(n, a);
    let (br, bc) = rc(n, b);
    ar == br || ac == bc || ar + bc == br + ac || ar + ac == br + bc
}

fn v1_signature(b: &Board, live: Mask) -> String {
    let border_live = live.and(b.border);
    let row_count = border_live.and(b.row_arm).count();
    let col_count = border_live.and(b.col_arm).count();
    let core_live = live.and(b.core);
    let mut row_inc = Vec::new();
    let mut col_inc = Vec::new();
    for z in border_live.and(b.row_arm).iter() {
        let cnt = core_live.iter().filter(|&x| attacks(b.n, z, x)).count();
        row_inc.push(cnt);
    }
    for z in border_live.and(b.col_arm).iter() {
        let cnt = core_live.iter().filter(|&x| attacks(b.n, z, x)).count();
        col_inc.push(cnt);
    }
    row_inc.sort_unstable();
    col_inc.sort_unstable();
    format!("{}:{}:{:?}:{:?}", row_count, col_count, row_inc, col_inc)
}

fn v0_signature(b: &Board, live: Mask) -> (u32, u32) {
    let border_live = live.and(b.border);
    (border_live.and(b.row_arm).count(), border_live.and(b.col_arm).count())
}

fn border_subset(b: &Board, live: Mask) -> Mask {
    live.and(b.border)
}

fn census_states(b: &Board, max_events: usize) -> Vec<HashSet<Mask>> {
    let mut levels: Vec<HashSet<Mask>> = (0..=max_events).map(|_| HashSet::new()).collect();
    levels[0].insert(b.residual);
    for depth in 0..max_events {
        let cur: Vec<Mask> = levels[depth].iter().copied().collect();
        for live in cur {
            for mv in live.iter() {
                if !b.is_event_move(live, mv) {
                    continue;
                }
                let after_opp = b.play(live, mv);
                if after_opp.is_empty() {
                    continue;
                }
                for reply in after_opp.iter() {
                    let child = b.play(after_opp, reply);
                    levels[depth + 1].insert(child);
                }
            }
        }
    }
    levels
}

fn run_census(n: usize, max_events: usize) {
    let b = Board::new(n);
    let levels = census_states(&b, max_events);
    println!(
        "CENSUS n={} max_events={} residual_live={} core_live={} border_live={}",
        n,
        max_events,
        b.residual.count(),
        b.residual.and(b.core).count(),
        b.residual.and(b.border).count()
    );
    for (depth, states) in levels.iter().enumerate() {
        let mut borders = BTreeSet::new();
        let mut v0s = BTreeSet::new();
        let mut v1s = BTreeSet::new();
        for &live in states {
            borders.insert(border_subset(&b, live));
            v0s.insert(v0_signature(&b, live));
            v1s.insert(v1_signature(&b, live));
        }
        println!(
            "CENSUS-DEPTH n={} depth={} states={} border_subsets={} v0={} v1={}",
            n,
            depth,
            states.len(),
            borders.len(),
            v0s.len(),
            v1s.len()
        );
    }
}

fn win_solve(b: &Board, live: Mask, memo: &mut HashMap<Mask, bool>) -> bool {
    if let Some(&v) = memo.get(&live) {
        return v;
    }
    let mut is_n = false;
    for mv in live.iter() {
        let child = b.play(live, mv);
        if !win_solve(b, child, memo) {
            is_n = true;
            break;
        }
    }
    memo.insert(live, is_n);
    is_n
}

fn run_solve_full(n: usize) {
    let b = Board::new(n);
    let mut memo = HashMap::new();
    let is_n = win_solve(&b, b.full, &mut memo);
    println!(
        "SOLVE-FULL n={} verdict={} memo={}",
        n,
        if is_n { "FIRST" } else { "SECOND" },
        memo.len()
    );
}

fn run_solve_residual(n: usize) {
    let b = Board::new(n);
    let mut memo = HashMap::new();
    let is_n = win_solve(&b, b.residual, &mut memo);
    println!(
        "SOLVE-RESIDUAL n={} verdict={} memo={} live={}",
        n,
        if is_n { "N" } else { "P" },
        memo.len(),
        b.residual.count()
    );
}

fn core_fold_key(b: &Board, live: Mask) -> String {
    let core_live = live.and(b.core);
    let mut a: Vec<usize> = core_live.iter().collect();
    let mut ta: Vec<usize> = core_live.iter().map(|z| b.tau(z).expect("core cell has tau")).collect();
    a.sort_unstable();
    ta.sort_unstable();
    if ta < a {
        format!("{:?}", ta)
    } else {
        format!("{:?}", a)
    }
}

fn run_valtest(n: usize) {
    let b = Board::new(n);
    let levels = census_states(&b, 3);
    let mut states = HashSet::new();
    for level in &levels {
        for &s in level {
            states.insert(s);
        }
    }
    let mut solver_memo = HashMap::new();
    let mut buckets: BTreeMap<(String, String), Vec<(Mask, bool)>> = BTreeMap::new();
    for live in states.iter().copied() {
        let val = win_solve(&b, live, &mut solver_memo);
        let key = (core_fold_key(&b, live), v1_signature(&b, live));
        buckets.entry(key).or_default().push((live, val));
    }
    let mut violations = Vec::new();
    for (key, vals) in &buckets {
        let first = vals[0].1;
        if vals.iter().any(|x| x.1 != first) {
            violations.push((key, vals));
        }
    }
    println!(
        "VALTEST n={} states={} buckets={} solver_memo={} violations={}",
        n,
        states.len(),
        buckets.len(),
        solver_memo.len(),
        violations.len()
    );
    for (i, (key, vals)) in violations.iter().enumerate() {
        println!(
            "VALTEST-VIOLATION n={} idx={} bucket_core={} bucket_v1={} members={}",
            n,
            i,
            key.0,
            key.1,
            vals.len()
        );
        for (live, val) in vals.iter().take(20) {
            println!(
                "  member verdict={} live_count={} border={:?}",
                if *val { "N" } else { "P" },
                live.count(),
                border_subset(&b, *live)
            );
        }
    }
}

fn usage() -> ! {
    eprintln!("usage:");
    eprintln!("  p0a census <n> <max-events>");
    eprintln!("  p0a valtest <n>");
    eprintln!("  p0a solve-full <n>");
    eprintln!("  p0a solve-residual <n>");
    std::process::exit(2);
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 3 {
        usage();
    }
    let n: usize = args[2].parse().expect("n must be usize");
    match args[1].as_str() {
        "census" => {
            if args.len() != 4 {
                usage();
            }
            let max_events: usize = args[3].parse().expect("max-events must be usize");
            run_census(n, max_events);
        }
        "valtest" => run_valtest(n),
        "solve-full" => run_solve_full(n),
        "solve-residual" => run_solve_residual(n),
        _ => usage(),
    }
}
