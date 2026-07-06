// Canonical grid cap-game solver (compiled port of 2026-07-06-grid-canon2.py).
//
// Grid game = PG(2,q) residual after the opening pair: cells of F_q x F_q, legal =
// partial-permutation matrix (<=1/row, <=1/col) AND affine cap (no 3 collinear); P1 first.
//   PG(2,q) = P  <=>  grid game is a FIRST-PLAYER LOSS.
//
// Canonicalizes `chosen` under the full grid automorphism group G = {(r,c)->(a r+s, b c+t)} |x swap
// (a,b in F*, s,t in F) via the anchor min-image (translate one occupied cell to (0,0), optional
// swap, scale a second to (1,1); minimize the resulting sorted cell list over all anchor choices).
// G preserves the row/col classes AND affine collinearity, so the game value is a G-invariant and
// memoizing on the canonical form is exact.
//
// Modes:
//   outcome  q   -- early-break, prints root P/N (the falsification signal) + #classes
//   defect   q   -- FULL expansion; also prints parity-defect diagnostics:
//                   min-deviating-size (root-safety margin), #odd-maximal-cap classes, etc.
//
// Build:  rustc -O -C target-cpu=native 2026-07-06-grid-cap-solver.rs -o /tmp/gridcap
// Falsification watch: if `outcome` ever prints N (first-player win), PG(2,q) has a
// counterexample; if `defect`'s min-deviating-size approaches 0/1, the root is about to flip.

use std::collections::{HashMap, HashSet};
use std::env;
use std::hash::{BuildHasherDefault, Hasher};
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::Mutex;
use std::thread;
use std::time::{Duration, Instant};

const MAXW: usize = 16; // supports N = q*q <= 1024, i.e. q <= 32
type Mask = [u64; MAXW];

#[inline]
fn mask_or(a: &mut Mask, b: &Mask) {
    for i in 0..MAXW {
        a[i] |= b[i];
    }
}
#[inline]
fn set_bit(a: &mut Mask, idx: usize) {
    a[idx >> 6] |= 1u64 << (idx & 63);
}

// ---- fast passthrough hasher for u128 fingerprint keys ----
#[derive(Default)]
struct IdHash(u64);
impl Hasher for IdHash {
    fn finish(&self) -> u64 {
        self.0
    }
    fn write(&mut self, bytes: &[u8]) {
        for &b in bytes {
            self.0 = (self.0 ^ b as u64).wrapping_mul(0x100000001b3);
        }
    }
    fn write_u128(&mut self, i: u128) {
        self.0 = ((i as u64) ^ ((i >> 64) as u64)).wrapping_mul(0x9e3779b97f4a7c15);
    }
}
type FnvMap<K, V> = HashMap<K, V, BuildHasherDefault<IdHash>>;

// ---- GF(q) ----
struct GF {
    q: usize,
    add: Vec<u16>,
    mul: Vec<u16>,
    inv: Vec<u16>,
    neg: Vec<u16>,
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

// monic irreducible poly coeffs [c0..c_{k-1}, 1] over F_p (matches gf.py IRRED where present).
fn irred(q: usize) -> (usize, Vec<i64>) {
    match q {
        4 => (2, vec![1, 1, 1]),
        8 => (2, vec![1, 1, 0, 1]),
        9 => (3, vec![1, 0, 1]),
        16 => (2, vec![1, 1, 0, 0, 1]),
        25 => (5, vec![3, 0, 1]),
        27 => (3, vec![1, 2, 0, 1]),
        32 => (2, vec![1, 0, 1, 0, 0, 1]), // x^5 + x^2 + 1 over F_2
        49 => (7, vec![3, 0, 1]),          // x^2 + 3 (3 nonsquare mod 7)
        _ => panic!("unsupported prime power q={}", q),
    }
}

impl GF {
    fn new(q: usize) -> GF {
        let mut add = vec![0u16; q * q];
        let mut mul = vec![0u16; q * q];
        let mut inv = vec![0u16; q];
        let mut neg = vec![0u16; q];
        if is_prime(q) {
            for a in 0..q {
                for b in 0..q {
                    add[a * q + b] = ((a + b) % q) as u16;
                    mul[a * q + b] = ((a * b) % q) as u16;
                }
            }
        } else {
            let (p, poly) = irred(q);
            let k = poly.len() - 1;
            let digits = |mut x: usize| -> Vec<i64> {
                let mut d = vec![0i64; k];
                for item in d.iter_mut() {
                    *item = (x % p) as i64;
                    x /= p;
                }
                d
            };
            let undig = |d: &[i64]| -> usize {
                let mut x = 0usize;
                for i in (0..k).rev() {
                    x = x * p + (d[i].rem_euclid(p as i64) as usize);
                }
                x
            };
            for a in 0..q {
                let da = digits(a);
                for b in 0..q {
                    let db = digits(b);
                    let mut s = vec![0i64; k];
                    for i in 0..k {
                        s[i] = (da[i] + db[i]).rem_euclid(p as i64);
                    }
                    add[a * q + b] = undig(&s) as u16;
                    let mut prod = vec![0i64; 2 * k];
                    for i in 0..k {
                        for j in 0..k {
                            prod[i + j] = (prod[i + j] + da[i] * db[j]).rem_euclid(p as i64);
                        }
                    }
                    for deg in (k..=2 * k - 1).rev() {
                        let c = prod[deg];
                        if c != 0 {
                            prod[deg] = 0;
                            for i in 0..k {
                                prod[deg - k + i] =
                                    (prod[deg - k + i] - c * poly[i]).rem_euclid(p as i64);
                            }
                        }
                    }
                    mul[a * q + b] = undig(&prod[..k]) as u16;
                }
            }
        }
        for a in 0..q {
            for b in 0..q {
                if add[a * q + b] == 0 {
                    neg[a] = b as u16;
                }
                if a != 0 && mul[a * q + b] == 1 {
                    inv[a] = b as u16;
                }
            }
        }
        GF { q, add, mul, inv, neg }
    }
    #[inline]
    fn a(&self, x: usize, y: usize) -> usize {
        self.add[x * self.q + y] as usize
    }
    #[inline]
    fn m(&self, x: usize, y: usize) -> usize {
        self.mul[x * self.q + y] as usize
    }
    #[inline]
    fn sub(&self, x: usize, y: usize) -> usize {
        self.a(x, self.neg[y] as usize)
    }
}

struct Board {
    gf: GF,
    q: usize,
    n: usize,               // N = q*q
    rc_mask: Vec<Mask>,     // same row or col as cell i
    line_mask: Vec<Mask>,   // [x*N + z] = all cells on affine line through x and z
    all: Mask,
}

impl Board {
    fn new(q: usize) -> Board {
        let gf = GF::new(q);
        let n = q * q;
        let cell = |r: usize, c: usize| r * q + c;
        let mut rc_mask = vec![[0u64; MAXW]; n];
        for r in 0..q {
            for c in 0..q {
                let i = cell(r, c);
                for c2 in 0..q {
                    if c2 != c {
                        set_bit(&mut rc_mask[i], cell(r, c2));
                    }
                }
                for r2 in 0..q {
                    if r2 != r {
                        set_bit(&mut rc_mask[i], cell(r2, c));
                    }
                }
            }
        }
        let mut line_mask = vec![[0u64; MAXW]; n * n];
        for i in 0..n {
            let (ri, ci) = (i / q, i % q);
            for j in 0..n {
                if i == j {
                    continue;
                }
                let (rj, cj) = (j / q, j % q);
                let dr = gf.sub(rj, ri);
                let dc = gf.sub(cj, ci);
                let m = &mut line_mask[i * n + j];
                for t in 0..q {
                    let rr = gf.a(ri, gf.m(t, dr));
                    let cc = gf.a(ci, gf.m(t, dc));
                    set_bit(m, cell(rr, cc));
                }
            }
        }
        let mut all = [0u64; MAXW];
        for i in 0..n {
            set_bit(&mut all, i);
        }
        Board { gf, q, n, rc_mask, line_mask, all }
    }

    // 128-bit fingerprint of a sorted cell list (two independent 64-bit poly hashes).
    // Collision prob for ~1e9 keys ~ 1e-20; validated at small q by matching exact class counts.
    #[inline]
    fn fp(list: &[u16]) -> u128 {
        let mut h1: u64 = 0x243f6a8885a308d3;
        let mut h2: u64 = 0x13198a2e03707344;
        for &x in list {
            h1 = (h1 ^ x as u64).wrapping_mul(0x100000001b3);
            h2 = h2.rotate_left(7) ^ (x as u64).wrapping_mul(0x9e3779b97f4a7c15);
            h2 = h2.wrapping_mul(0xff51afd7ed558ccd);
        }
        ((h1 as u128) << 64) | (h2 as u128)
    }

    // canonical fingerprint = fp of the lexicographically-min anchor image over the full group.
    fn canon(&self, occ: &[u16]) -> u128 {
        let q = self.q;
        if occ.len() <= 1 {
            // 0 or 1 cell: all such positions are one orbit; fixed sentinel per size.
            return occ.len() as u128;
        }
        let gf = &self.gf;
        let mut best: Option<Vec<u16>> = None;
        let mut buf = vec![0u16; occ.len()];
        for &ui in occ {
            let (ur, uc) = (ui as usize / q, ui as usize % q);
            for &vi in occ {
                if vi == ui {
                    continue;
                }
                let (vr, vc) = (vi as usize / q, vi as usize % q);
                // v after translate u->origin
                let tvr = gf.sub(vr, ur);
                let tvc = gf.sub(vc, uc);
                for sw in 0..2 {
                    let (pvr, pvc) = if sw == 1 { (tvc, tvr) } else { (tvr, tvc) };
                    // both nonzero (distinct row & col from u)
                    let a = gf.inv[pvr] as usize;
                    let b = gf.inv[pvc] as usize;
                    for (k, &xi) in occ.iter().enumerate() {
                        let (xr, xc) = (xi as usize / q, xi as usize % q);
                        let mut yr = gf.sub(xr, ur);
                        let mut yc = gf.sub(xc, uc);
                        if sw == 1 {
                            std::mem::swap(&mut yr, &mut yc);
                        }
                        let rr = gf.m(a, yr);
                        let cc = gf.m(b, yc);
                        buf[k] = (rr * q + cc) as u16;
                    }
                    buf.sort_unstable();
                    match &best {
                        Some(cur) if cur.as_slice() <= buf.as_slice() => {}
                        _ => best = Some(buf.clone()),
                    }
                }
            }
        }
        Self::fp(&best.unwrap())
    }
}

struct Solver<'a> {
    b: &'a Board,
    memo: FnvMap<u128, bool>, // true = N (mover wins), false = P (mover loses)
    full: bool,                     // full expansion (defect mode) vs early break
    // defect diagnostics:
    min_dev: usize,      // min size of a class whose P/N disagrees with parity; usize::MAX if none
    odd_max: u64,        // #odd-size maximal-cap classes
    odd_max_min: usize,  // smallest odd maximal cap size
    dev_even_n: u64,     // #even-but-N classes
    dev_odd_p: u64,      // #odd-but-P classes
}

impl<'a> Solver<'a> {
    fn g(&mut self, occ: &mut Vec<u16>, chosen: &Mask, forbidden: &Mask) -> bool {
        let key = self.b.canon(occ);
        if let Some(&v) = self.memo.get(&key) {
            return v;
        }
        // avail = ALL & !chosen & !forbidden
        let mut avail = [0u64; MAXW];
        for i in 0..MAXW {
            avail[i] = self.b.all[i] & !chosen[i] & !forbidden[i];
        }
        let size = occ.len();
        let mut is_n = false;
        let mut any_move = false;
        'outer: for w in 0..MAXW {
            let mut bits = avail[w];
            while bits != 0 {
                let tz = bits.trailing_zeros() as usize;
                bits &= bits - 1;
                let z = w * 64 + tz;
                any_move = true;
                // child masks
                let mut nchosen = *chosen;
                set_bit(&mut nchosen, z);
                let mut nforb = *forbidden;
                mask_or(&mut nforb, &self.b.rc_mask[z]);
                for &x in occ.iter() {
                    mask_or(&mut nforb, &self.b.line_mask[x as usize * self.b.n + z]);
                }
                occ.push(z as u16);
                let child = self.g(occ, &nchosen, &nforb);
                occ.pop();
                if !child {
                    is_n = true;
                    if !self.full {
                        break 'outer;
                    }
                }
            }
        }
        let maximal = !any_move; // no available move
        let is_p = !is_n;
        // record diagnostics (only meaningful under full expansion)
        if self.full {
            let parity_p = size % 2 == 0; // naive law: P iff even
            if is_p != parity_p {
                if size < self.min_dev {
                    self.min_dev = size;
                }
                if is_p {
                    self.dev_odd_p += 1;
                } else {
                    self.dev_even_n += 1;
                }
            }
            if maximal && size % 2 == 1 {
                self.odd_max += 1;
                if size < self.odd_max_min {
                    self.odd_max_min = size;
                }
            }
        }
        self.memo.insert(key, is_n);
        is_n
    }
}

// ---- parallel outcome solver ----
// Sharded concurrent memo. Keys are u128 fingerprints (already well-mixed) -> IdHash + low-bit shard.
struct Memo {
    shards: Vec<Mutex<FnvMap<u128, bool>>>,
    mask: usize,
    inserts: AtomicUsize, // approximate node-work counter (may double-count concurrent recompute)
}
impl Memo {
    fn new(log2: usize) -> Memo {
        let n = 1usize << log2;
        Memo {
            shards: (0..n).map(|_| Mutex::new(FnvMap::default())).collect(),
            mask: n - 1,
            inserts: AtomicUsize::new(0),
        }
    }
    #[inline]
    fn shard(&self, fp: u128) -> usize {
        (fp as usize) & self.mask
    }
    #[inline]
    fn get(&self, fp: u128) -> Option<bool> {
        self.shards[self.shard(fp)].lock().unwrap().get(&fp).copied()
    }
    #[inline]
    fn insert(&self, fp: u128, v: bool) {
        self.shards[self.shard(fp)].lock().unwrap().insert(fp, v);
        self.inserts.fetch_add(1, Ordering::Relaxed);
    }
    #[inline]
    fn work(&self) -> usize {
        self.inserts.load(Ordering::Relaxed)
    }
    fn len(&self) -> usize {
        self.shards.iter().map(|s| s.lock().unwrap().len()).sum()
    }
}

// sequential early-break solve over the SHARED memo (used by workers below the frontier,
// and by the top pass above it). Value is deterministic so concurrent recompute is harmless.
fn g_par(b: &Board, memo: &Memo, occ: &mut Vec<u16>, chosen: &Mask, forbidden: &Mask) -> bool {
    let key = b.canon(occ);
    if let Some(v) = memo.get(key) {
        return v;
    }
    let mut avail = [0u64; MAXW];
    for i in 0..MAXW {
        avail[i] = b.all[i] & !chosen[i] & !forbidden[i];
    }
    let mut is_n = false;
    'outer: for w in 0..MAXW {
        let mut bits = avail[w];
        while bits != 0 {
            let tz = bits.trailing_zeros() as usize;
            bits &= bits - 1;
            let z = w * 64 + tz;
            let mut nchosen = *chosen;
            set_bit(&mut nchosen, z);
            let mut nforb = *forbidden;
            mask_or(&mut nforb, &b.rc_mask[z]);
            for &x in occ.iter() {
                mask_or(&mut nforb, &b.line_mask[x as usize * b.n + z]);
            }
            occ.push(z as u16);
            let child = g_par(b, memo, occ, &nchosen, &nforb);
            occ.pop();
            if !child {
                is_n = true;
                break 'outer;
            }
        }
    }
    memo.insert(key, is_n);
    is_n
}

// enumerate all canonical nodes of size == depth (the frontier), deduped by canonical form.
fn enumerate(
    b: &Board,
    depth: usize,
    occ: &mut Vec<u16>,
    chosen: &Mask,
    forbidden: &Mask,
    visited: &mut HashSet<u128>,
    out: &mut Vec<(Vec<u16>, Mask, Mask)>,
) {
    let key = b.canon(occ);
    if !visited.insert(key) {
        return; // this canonical node already handled
    }
    if occ.len() == depth {
        out.push((occ.clone(), *chosen, *forbidden));
        return;
    }
    let mut avail = [0u64; MAXW];
    for i in 0..MAXW {
        avail[i] = b.all[i] & !chosen[i] & !forbidden[i];
    }
    for w in 0..MAXW {
        let mut bits = avail[w];
        while bits != 0 {
            let tz = bits.trailing_zeros() as usize;
            bits &= bits - 1;
            let z = w * 64 + tz;
            let mut nchosen = *chosen;
            set_bit(&mut nchosen, z);
            let mut nforb = *forbidden;
            mask_or(&mut nforb, &b.rc_mask[z]);
            for &x in occ.iter() {
                mask_or(&mut nforb, &b.line_mask[x as usize * b.n + z]);
            }
            occ.push(z as u16);
            enumerate(b, depth, occ, &nchosen, &nforb, visited, out);
            occ.pop();
        }
    }
}

fn solve_parallel(q: usize, nthreads: usize, depth: usize) {
    let b = Board::new(q);
    let memo = Memo::new(12); // 4096 shards
    let empty = [0u64; MAXW];
    // phase 1: frontier (sequential, cheap)
    let mut frontier: Vec<(Vec<u16>, Mask, Mask)> = Vec::new();
    {
        let mut visited: HashSet<u128> = HashSet::new();
        let mut occ: Vec<u16> = Vec::new();
        enumerate(&b, depth, &mut occ, &empty, &empty, &mut visited, &mut frontier);
    }
    eprintln!(
        "  [par q={}] {} frontier tasks (depth {}), {} threads — solving...",
        q, frontier.len(), depth, nthreads
    );
    // phase 2: parallel solve of frontier subtrees over the shared memo
    let idx = AtomicUsize::new(0);
    let done_tasks = AtomicUsize::new(0);
    let start = Instant::now();
    let total = frontier.len();
    thread::scope(|s| {
        // live progress reporter (stderr): tasks done/total, nodes memoized, nodes/s
        {
            let (memo, done_tasks, start) = (&memo, &done_tasks, &start);
            s.spawn(move || {
                let (mut last_n, mut last_t) = (0usize, 0.0f64);
                loop {
                    thread::sleep(Duration::from_secs(5));
                    let d = done_tasks.load(Ordering::Relaxed);
                    let n = memo.work();
                    let el = start.elapsed().as_secs_f64();
                    let rate = if el > last_t {
                        (n - last_n) as f64 / (el - last_t)
                    } else {
                        0.0
                    };
                    eprintln!(
                        "  [par q={} {:6.0}s] tasks {:>5}/{:<5}  nodes {:>13}  {:>10.0} nodes/s",
                        q, el, d, total, n, rate
                    );
                    last_n = n;
                    last_t = el;
                    if d >= total {
                        break;
                    }
                }
            });
        }
        for _ in 0..nthreads {
            let (b, memo, frontier, idx, done_tasks) = (&b, &memo, &frontier, &idx, &done_tasks);
            s.spawn(move || loop {
                let i = idx.fetch_add(1, Ordering::Relaxed);
                if i >= frontier.len() {
                    break;
                }
                let (occ0, chosen, forbidden) = &frontier[i];
                let mut occ = occ0.clone();
                g_par(b, memo, &mut occ, chosen, forbidden);
                done_tasks.fetch_add(1, Ordering::Relaxed);
            });
        }
    });
    eprintln!("  [par q={} {:6.0}s] phase-2 done, finishing top pass", q, start.elapsed().as_secs_f64());
    // phase 3: sequential top pass (children at the frontier are memoized)
    let mut occ: Vec<u16> = Vec::new();
    let root_n = g_par(&b, &memo, &mut occ, &empty, &empty);
    let outcome = if root_n {
        "N (1st WINS -> COUNTEREXAMPLE!)"
    } else {
        "P (2nd wins)"
    };
    println!(
        "q={:>3}  root={}  classes={}  [parallel: {} threads, depth {}, {} frontier tasks]",
        q, outcome, memo.len(), nthreads, depth, frontier.len()
    );
}

fn solve(q: usize, full: bool) {
    let b = Board::new(q);
    let mut s = Solver {
        b: &b,
        memo: FnvMap::default(),
        full,
        min_dev: usize::MAX,
        odd_max: 0,
        odd_max_min: usize::MAX,
        dev_even_n: 0,
        dev_odd_p: 0,
    };
    let empty = [0u64; MAXW];
    let mut occ: Vec<u16> = Vec::new();
    let root_n = s.g(&mut occ, &empty, &empty);
    let outcome = if root_n { "N (1st WINS -> COUNTEREXAMPLE!)" } else { "P (2nd wins)" };
    if full {
        let mindev = if s.min_dev == usize::MAX {
            "none (pure parity)".to_string()
        } else {
            s.min_dev.to_string()
        };
        let omin = if s.odd_max_min == usize::MAX { 0 } else { s.odd_max_min };
        println!(
            "q={:>3}  root={}  classes={}  min-dev-size={}  odd-maximal-caps={} (min size {})  even-but-N={} odd-but-P={}",
            q, outcome, s.memo.len(), mindev, s.odd_max, omin, s.dev_even_n, s.dev_odd_p
        );
    } else {
        println!("q={:>3}  root={}  classes={}", q, outcome, s.memo.len());
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 3 {
        eprintln!("usage: {} <outcome|defect> <q> [q2 q3 ...]", args[0]);
        std::process::exit(2);
    }
    if args[1] == "par" {
        // par <q> [threads] [depth]
        let q: usize = args[2].parse().expect("q must be an integer");
        let nthreads: usize = args
            .get(3)
            .and_then(|s| s.parse().ok())
            .unwrap_or_else(|| thread::available_parallelism().map(|n| n.get()).unwrap_or(8));
        let depth: usize = args.get(4).and_then(|s| s.parse().ok()).unwrap_or(4);
        solve_parallel(q, nthreads, depth);
        return;
    }
    let full = match args[1].as_str() {
        "outcome" => false,
        "defect" => true,
        _ => {
            eprintln!("mode must be 'outcome' | 'defect' | 'par'");
            std::process::exit(2);
        }
    };
    for a in &args[2..] {
        let q: usize = a.parse().expect("q must be an integer");
        solve(q, full);
    }
}
