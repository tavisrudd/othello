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
//   escape   q   -- per-size-3-class escape margin (# P size-4 children) + bad-parity split
//                   (route-A crux 2026-07-06-escape-count-lemma.md): min/max escape, histogram,
//                   #even-escape (=bad-odd) classes, parity-proof holds/breaks. Single-threaded.
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
    subt: Vec<u16>, // subt[x*q+y] = x - y (one lookup)
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
        let mut subt = vec![0u16; q * q];
        for x in 0..q {
            for y in 0..q {
                subt[x * q + y] = add[x * q + neg[y] as usize];
            }
        }
        GF { q, add, mul, inv, neg, subt }
    }
    #[inline]
    fn subf(&self, x: usize, y: usize) -> usize {
        self.subt[x * self.q + y] as usize
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
    cellh: Vec<(u64, u64)>, // per-cell (h1,h2) for order-independent set hashing in canon
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
        // per-cell strong hashes (two independent 64-bit mixes) for order-independent set hashing
        let mut cellh = vec![(0u64, 0u64); n];
        for (i, h) in cellh.iter_mut().enumerate() {
            let c = i as u64;
            let mut x = c.wrapping_add(0x9e3779b97f4a7c15);
            x = (x ^ (x >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
            x = (x ^ (x >> 27)).wrapping_mul(0x94d049bb133111eb);
            let h1 = x ^ (x >> 31);
            let mut y = c.wrapping_add(0xd1b54a32d192ed03);
            y = (y ^ (y >> 29)).wrapping_mul(0xff51afd7ed558ccd);
            y = (y ^ (y >> 32)).wrapping_mul(0xc4ceb9fe1a85ec53);
            let h2 = y ^ (y >> 29);
            *h = (h1, h2);
        }
        Board { gf, q, n, rc_mask, line_mask, all, cellh }
    }

    // Canonical fingerprint = MIN over all anchor images of an ORDER-INDEPENDENT set hash.
    // For each ordered occupied pair (u,v) and swap, the unique g in G with g(u)=(0,0),
    // (optional swap), g(v)=(1,1) maps the position to an image set; its set-hash is the sum of
    // per-cell hashes (commutative => no sort). The image-set collection is identical for all
    // G-equivalent positions, so the min set-hash is a G-invariant (validated by matching exact
    // class counts). No sort, no Vec, no allocation; per-cell (r,c) precomputed once.
    fn canon(&self, occ: &[u16]) -> u128 {
        let n = occ.len();
        if n <= 1 {
            return n as u128; // 0/1 cell: single orbit, sentinel per size
        }
        let q = self.q;
        let gf = &self.gf;
        let cellh = &self.cellh;
        let mut rows = [0usize; 64];
        let mut cols = [0usize; 64];
        for k in 0..n {
            let c = occ[k] as usize;
            rows[k] = c / q;
            cols[k] = c % q;
        }
        let mut best: u128 = u128::MAX;
        let mut tr = [0usize; 64]; // cell coords after translating u->origin (per ui; reused)
        let mut tc = [0usize; 64];
        for ui in 0..n {
            let (ur, uc) = (rows[ui], cols[ui]);
            for k in 0..n {
                tr[k] = gf.subf(rows[k], ur); // hoisted: depends only on ui, not on (vi,sw)
                tc[k] = gf.subf(cols[k], uc);
            }
            for vi in 0..n {
                if vi == ui {
                    continue;
                }
                // sw=0: rows=tr, cols=tc;  sw=1: rows=tc, cols=tr (swap exchanges the roles)
                for &(sr, sc) in &[(&tr, &tc), (&tc, &tr)] {
                    let a = gf.inv[sr[vi]] as usize; // scale v's row-coord to 1
                    let b = gf.inv[sc[vi]] as usize; // scale v's col-coord to 1
                    let (mut s1, mut s2) = (0u64, 0u64);
                    for k in 0..n {
                        let idx = gf.m(a, sr[k]) * q + gf.m(b, sc[k]);
                        let (h1, h2) = cellh[idx];
                        s1 = s1.wrapping_add(h1);
                        s2 = s2.wrapping_add(h2);
                    }
                    let h = ((s1 as u128) << 64) | (s2 as u128);
                    if h < best {
                        best = h;
                    }
                }
            }
        }
        best
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

// ---- parallel outcome solver: FIXED-ARENA open-addressing memo (Tiger-style) ----
// One Box<[u128]> per shard, sized once at startup, NEVER grown — no per-node allocation.
// Slot encoding (a slot is one u128): bit127 = occupied, bit126 = value (P/N), bits[0..125] =
// 126-bit key discriminator (fp >> shard_log2). Empty slot = 0. Linear probing within a shard.
// 126-bit key => collision prob ~ (1e9)^2 / 2^126 ~ 1e-20 at a billion classes.
const OCC: u128 = 1u128 << 127;
const VAL: u128 = 1u128 << 126;
const KMASK: u128 = (1u128 << 126) - 1;

struct Shard {
    slots: Box<[u128]>, // allocated once (zeroed, lazily faulted); never resized
    len: usize,
}
impl Shard {
    fn new(cap: usize) -> Shard {
        Shard {
            slots: vec![0u128; cap].into_boxed_slice(),
            len: 0,
        }
    }
    #[inline]
    fn get(&self, k: u128) -> Option<bool> {
        let cap = self.slots.len();
        let mut h = (k as usize) & (cap - 1);
        loop {
            let s = self.slots[h];
            if s == 0 {
                return None;
            }
            if (s & KMASK) == k {
                return Some(s & VAL != 0);
            }
            h = (h + 1) & (cap - 1);
        }
    }
    // returns true if a NEW slot was filled
    #[inline]
    fn insert(&mut self, k: u128, v: bool) -> bool {
        let cap = self.slots.len();
        let mut h = (k as usize) & (cap - 1);
        loop {
            let s = self.slots[h];
            if s == 0 {
                self.slots[h] = OCC | (if v { VAL } else { 0 }) | k;
                self.len += 1;
                return true;
            }
            if (s & KMASK) == k {
                return false;
            }
            h = (h + 1) & (cap - 1);
        }
    }
}

struct Memo {
    shards: Box<[Mutex<Shard>]>,
    shard_log2: u32,
    mask: usize,
    inserts: AtomicUsize, // distinct-class fill counter (progress metric)
}
impl Memo {
    // total_log2 = log2(total slots); shard_log2 = log2(#shards). Arena bytes = 16 << total_log2.
    fn new(total_log2: usize, shard_log2: usize) -> Memo {
        let nshards = 1usize << shard_log2;
        let shardcap = 1usize << (total_log2 - shard_log2);
        let shards: Vec<Mutex<Shard>> =
            (0..nshards).map(|_| Mutex::new(Shard::new(shardcap))).collect();
        Memo {
            shards: shards.into_boxed_slice(),
            shard_log2: shard_log2 as u32,
            mask: nshards - 1,
            inserts: AtomicUsize::new(0),
        }
    }
    #[inline]
    fn split(&self, fp: u128) -> (usize, u128) {
        // shard = low bits; in-shard key = the remaining high bits (disjoint => uniform probe)
        ((fp as usize) & self.mask, fp >> self.shard_log2)
    }
    #[inline]
    fn get(&self, fp: u128) -> Option<bool> {
        let (s, k) = self.split(fp);
        self.shards[s].lock().unwrap().get(k)
    }
    #[inline]
    fn insert(&self, fp: u128, v: bool) {
        let (s, k) = self.split(fp);
        let mut sh = self.shards[s].lock().unwrap();
        // guard: >87.5% full degrades probing badly => the arena was under-sized
        if sh.len + (sh.len >> 3) >= sh.slots.len() {
            eprintln!(
                "FATAL: memo shard {}/{} nearly full ({}/{}); rerun with a larger arena log2",
                s, self.mask + 1, sh.len, sh.slots.len()
            );
            std::process::exit(3);
        }
        if sh.insert(k, v) {
            self.inserts.fetch_add(1, Ordering::Relaxed);
        }
    }
    #[inline]
    fn work(&self) -> usize {
        self.inserts.load(Ordering::Relaxed)
    }
    fn len(&self) -> usize {
        self.shards.iter().map(|s| s.lock().unwrap().len).sum()
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

fn solve_parallel(q: usize, nthreads: usize, depth: usize, arena_log2: usize) {
    let b = Board::new(q);
    let memo = Memo::new(arena_log2, 12); // fixed arena: (1<<arena_log2) slots, 4096 shards
    eprintln!(
        "  [par q={}] arena {} slots ({} GB, fixed)",
        q,
        1usize << arena_log2,
        ((16usize << arena_log2) as f64) / 1e9
    );
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

// ---- ESCAPE mode: per-size-3-class escape margin + bad-parity distribution ----
// Route (A) falsification data (2026-07-06-frame-reduction.md / -escape-count-lemma.md):
//   escape(S3) = # P size-4 children of a size-3 grid position S3.
//   total(S3)  = # legal size-4 extensions = q^2-9q+21 (the total lemma, constant).
//   bad(S3)    = total - escape.  For odd q, total is odd, so  bad even <=> escape odd.
// Crux: escape >= 1 for every S3  <=>  PG(2,q)=P.  Parity proof works iff every bad is even
// (equivalently every escape odd).  This mode reports, over all CANONICAL size-3 classes:
//   min/max escape (falsification: min must stay >=1), the escape histogram, and the count of
//   classes with EVEN escape (= bad ODD, where the parity proof breaks).  Single-threaded (light
//   footprint) full expansion to memoize all classes, then a size-3 post-pass.
fn solve_escape(q: usize) {
    let b = Board::new(q);
    let mut s = Solver {
        b: &b,
        memo: FnvMap::default(),
        full: true,
        min_dev: usize::MAX,
        odd_max: 0,
        odd_max_min: usize::MAX,
        dev_even_n: 0,
        dev_odd_p: 0,
    };
    let empty = [0u64; MAXW];
    // phase 1: full expansion => every reachable class (all sizes) memoized P/N
    let mut occ: Vec<u16> = Vec::new();
    let root_n = s.g(&mut occ, &empty, &empty);

    // phase 2: enumerate canonical size-3 classes; for each count P size-4 children
    let mut frontier: Vec<(Vec<u16>, Mask, Mask)> = Vec::new();
    {
        let mut visited: HashSet<u128> = HashSet::new();
        let mut occ3: Vec<u16> = Vec::new();
        enumerate(&b, 3, &mut occ3, &empty, &empty, &mut visited, &mut frontier);
    }
    let total_expected = (q * q + 21).wrapping_sub(9 * q); // q^2 - 9q + 21
    let mut min_esc = usize::MAX;
    let mut max_esc = 0usize;
    let mut even_esc = 0u64; // classes with escape even  (= bad odd)
    let mut bad_total_ne = 0u64; // classes where total != q^2-9q+21 (must be 0)
    let mut min_rep: Vec<u16> = Vec::new(); // occ of a min-escape representative
    let mut hist: std::collections::BTreeMap<usize, u64> = std::collections::BTreeMap::new();
    for (occ0, chosen, forbidden) in &frontier {
        let mut avail = [0u64; MAXW];
        for i in 0..MAXW {
            avail[i] = b.all[i] & !chosen[i] & !forbidden[i];
        }
        let mut n_p = 0usize;
        let mut n_tot = 0usize;
        let mut occ = occ0.clone();
        for w in 0..MAXW {
            let mut bits = avail[w];
            while bits != 0 {
                let tz = bits.trailing_zeros() as usize;
                bits &= bits - 1;
                let z = w * 64 + tz;
                n_tot += 1;
                let mut nchosen = *chosen;
                set_bit(&mut nchosen, z);
                let mut nforb = *forbidden;
                mask_or(&mut nforb, &b.rc_mask[z]);
                for &x in occ0.iter() {
                    mask_or(&mut nforb, &b.line_mask[x as usize * b.n + z]);
                }
                occ.push(z as u16);
                let key = b.canon(&occ);
                occ.pop();
                // full expansion memoized every class; missing => recompute (shouldn't happen)
                let is_n = match s.memo.get(&key) {
                    Some(&v) => v,
                    None => {
                        occ.push(z as u16);
                        let v = s.g(&mut occ, &nchosen, &nforb);
                        occ.pop();
                        v
                    }
                };
                if !is_n {
                    n_p += 1; // P child = an escape
                }
            }
        }
        if n_tot != total_expected {
            bad_total_ne += 1;
        }
        if n_p < min_esc {
            min_esc = n_p;
            min_rep = occ0.clone();
        }
        if n_p > max_esc {
            max_esc = n_p;
        }
        if n_p % 2 == 0 {
            even_esc += 1;
        }
        *hist.entry(n_p).or_insert(0) += 1;
    }
    let ncls = frontier.len() as u64;
    let outcome = if root_n { "N (COUNTEREXAMPLE!)" } else { "P" };
    let hs: Vec<String> = hist.iter().map(|(k, v)| format!("{}:{}", k, v)).collect();
    let parity_ok = even_esc == 0;
    println!(
        "q={:>3}  root={}  size3-classes={}  total(q^2-9q+21)={}{}  min-escape={}  max-escape={}  \
         bad-odd(even-escape) classes={}/{}  parity-proof={}",
        q,
        outcome,
        ncls,
        total_expected,
        if bad_total_ne > 0 {
            format!(" [!! {} classes with total != formula]", bad_total_ne)
        } else {
            String::new()
        },
        if min_esc == usize::MAX { 0 } else { min_esc },
        max_esc,
        even_esc,
        ncls,
        if parity_ok { "HOLDS (all bad even)" } else { "BREAKS" },
    );
    println!("      escape-histogram (escape:classes) = {}", hs.join(" "));
    let rep: Vec<(usize, usize)> = min_rep.iter().map(|&c| (c as usize / q, c as usize % q)).collect();
    println!("      min-escape representative S3 (cells) = {:?}", rep);
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
        // par <q> [threads] [depth] [arena_log2]
        let q: usize = args[2].parse().expect("q must be an integer");
        let nthreads: usize = args
            .get(3)
            .and_then(|s| s.parse().ok())
            .unwrap_or_else(|| thread::available_parallelism().map(|n| n.get()).unwrap_or(8));
        let depth: usize = args.get(4).and_then(|s| s.parse().ok()).unwrap_or(4);
        let arena_log2: usize = args.get(5).and_then(|s| s.parse().ok()).unwrap_or(29);
        solve_parallel(q, nthreads, depth, arena_log2);
        return;
    }
    if args[1] == "escape" {
        for a in &args[2..] {
            let q: usize = a.parse().expect("q must be an integer");
            solve_escape(q);
        }
        return;
    }
    let full = match args[1].as_str() {
        "outcome" => false,
        "defect" => true,
        _ => {
            eprintln!("mode must be 'outcome' | 'defect' | 'escape' | 'par'");
            std::process::exit(2);
        }
    };
    for a in &args[2..] {
        let q: usize = a.parse().expect("q must be an integer");
        solve(q, full);
    }
}
