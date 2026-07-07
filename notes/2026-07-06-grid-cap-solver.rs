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
//   resym [vK] q -- route-(A)-1/2 adaptive symmetric-strategy closure test (open-math plan
//                   2026-07-07): solve the game with P2 RESTRICTED to replies that land the
//                   position in family F_v (symmetric under some grid-automorphism involution,
//                   v0 = symmetry only / v1 = + fixed cells dead / v2 = + problem set dead /
//                   v3 = symmetric under ANY nontrivial automorphism, order >= 2 /
//                   v4 = v3 AND a true P-position of the exact game).
//                   frame-SAFE=YES is a machine-checked adaptive P2 strategy proof for PG(2,q).
//                   RESULT 2026-07-07: YES for q<=9 (every variant), NO for q=11,13,17 (even
//                   v3/v4) — the symmetric-family route is dead; see
//                   2026-07-07-resym-symmetric-family-dead.md.
//   breaks   q   -- exact cross-check: for every P1 break from the frame, #replies / #true-P
//                   replies / #P-replies that are symmetric (nontrivial stabilizer).
//   checkpos q r,c ... / rx,cx -- exact reply table (value + symmetry) for one position+break.
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

// ---- BOUNDARY mode: test "size-4 N  <=>  embeds in an odd maximal cap" at larger q ----
// The boundary characterization (validated q<=9, 2026-07-06-boundary-char-verify.py) says a
// size-4 grid position's GAME value is a purely STATIC geometric property: N iff it extends to
// an odd maximal cap.  If it still holds at q=13,17, `bad` is arc-computable (no game recursion)
// and the falsification watch can push past the q=19 exhaustive wall.  This mode computes, over
// all canonical size-4 classes, (a) the true game value and (b) emb = "extends to an odd maximal
// cap", and reports mismatches.  Both are G-invariants, so per-canonical-class is exact.

// emb(occ) = does `occ` extend to an ODD maximal cap?  Existential over maximal leaves' parity.
// Memoized on canon (a G-invariant).  Independent of the game minimax memo.
fn emb_rec(
    b: &Board,
    emb: &mut FnvMap<u128, bool>,
    occ: &mut Vec<u16>,
    chosen: &Mask,
    forbidden: &Mask,
) -> bool {
    let key = b.canon(occ);
    if let Some(&v) = emb.get(&key) {
        return v;
    }
    let mut avail = [0u64; MAXW];
    for i in 0..MAXW {
        avail[i] = b.all[i] & !chosen[i] & !forbidden[i];
    }
    let mut any = false;
    for w in 0..MAXW {
        if avail[w] != 0 {
            any = true;
            break;
        }
    }
    let v = if !any {
        occ.len() % 2 == 1 // maximal cap: contributes iff odd
    } else {
        let mut found = false;
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
                let r = emb_rec(b, emb, occ, &nchosen, &nforb);
                occ.pop();
                if r {
                    found = true;
                    break 'outer;
                }
            }
        }
        found
    };
    emb.insert(key, v);
    v
}

fn solve_boundary(q: usize) {
    let b = Board::new(q);
    // main game solve (full expansion) => memo has N/P for every class
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
    let mut occ0: Vec<u16> = Vec::new();
    let root_n = s.g(&mut occ0, &empty, &empty);

    // enumerate canonical size-4 classes
    let mut frontier: Vec<(Vec<u16>, Mask, Mask)> = Vec::new();
    {
        let mut visited: HashSet<u128> = HashSet::new();
        let mut occ4: Vec<u16> = Vec::new();
        enumerate(&b, 4, &mut occ4, &empty, &empty, &mut visited, &mut frontier);
    }
    let mut emb: FnvMap<u128, bool> = FnvMap::default();
    let mut nclasses = 0u64;
    let mut n_count = 0u64; // #N classes
    let mut emb_count = 0u64; // #emb-in-odd-maximal classes
    let mut mism = 0u64; // #classes where game-N != emb
    let mut mism_rep: Vec<u16> = Vec::new();
    for (occ, chosen, forbidden) in &frontier {
        let key = b.canon(occ);
        let gv = *s.memo.get(&key).expect("size-4 class must be memoized");
        let mut occm = occ.clone();
        let e = emb_rec(&b, &mut emb, &mut occm, chosen, forbidden);
        nclasses += 1;
        if gv {
            n_count += 1;
        }
        if e {
            emb_count += 1;
        }
        if gv != e {
            mism += 1;
            if mism_rep.is_empty() {
                mism_rep = occ.clone();
            }
        }
    }
    let outcome = if root_n { "N" } else { "P" };
    let verdict = if mism == 0 { "HOLDS" } else { "FAILS" };
    println!(
        "q={:>3}  root={}  size4-classes={}  game-N={}  emb-odd-maximal={}  mismatches={}  \
         boundary-char={}",
        q, outcome, nclasses, n_count, emb_count, mism, verdict
    );
    if mism > 0 {
        let rep: Vec<(usize, usize)> =
            mism_rep.iter().map(|&c| (c as usize / q, c as usize % q)).collect();
        println!("      first mismatch representative (cells) = {:?}", rep);
    }
}

// ---- RESYM mode: route (A) adaptive symmetric-strategy closure test ----
// (Open-math plan 2026-07-07 §(A)-1/2; depth-1 evidence in 2026-07-06-adaptive-resym-test.py.)
// Family F_v over EVEN-size legal grid positions S:
//   exists involution phi (semilinear monomial grid-hypergraph automorphism, phi != id,
//   enumerated EXHAUSTIVELY: both coordinate orders x all scalings/shifts x Frobenius twists
//   for prime-power q) with phi(S) = S and, per variant:
//     v0  no extra condition (broadest family; SAFE_v0(frame)=NO kills the whole
//         adaptive-involution route at this q)
//     v1  every phi-FIXED cell is dead (not legally playable) in S  [the depth-1 test's cond]
//     v2  phi's whole PROBLEM SET is dead: cells whose phi-image shares a row or column with
//         them (incl fixed cells) — the mirror-legality obstruction set of the
//         mirror-obstruction note (sigma_c: center row+col; antidiagonal: its fixed line)
// SAFE(S) = P1 stuck at S, or EVERY legal P1 move x admits a legal reply y with
// S+{x,y} in F_v and SAFE(S+{x,y}) — i.e. the game value with P2 restricted to
// symmetry-restoring replies.  SAFE(frame)=YES is a machine-checked adaptive-strategy P2 proof
// that the frame is P, hence PG(2,q)=P by the frame reduction (2026-07-06-frame-reduction.md).
// Memoizing SAFE on canon() is exact: G conjugates the involution set to itself (semilinearity
// and swap-parity are preserved by conjugation) and preserves legality/deadness, so F_v and
// SAFE are G-invariants.
// Reply-existence per (T = S+x, phi): let D = phi(T)\T.  |D| >= 2: phi can never be restored by
// one reply.  |D| = 1: the unique candidate is y = the element of D (then phi(T+y) = T+y
// automatically: the lone unmatched t0 in T\phi(T) satisfies phi(t0) = y).  |D| = 0 (phi already
// preserves T): y must be a phi-fixed legal cell.

#[derive(Clone)]
struct Involution {
    perm: Vec<u16>, // cell permutation
    fixed: Mask,    // fixed cells
    problem: Mask,  // cells whose image shares a row/col with them (incl fixed)
    kind: usize,    // 0 central, 1 antidiag/swap, 2 translation (char 2), 3 frob-twisted, 4 reflection
}

// all field automorphisms of GF(q) as value maps (id, frob, frob^2, ...)
fn field_autos(gf: &GF) -> Vec<Vec<u16>> {
    let q = gf.q;
    // characteristic p = additive order of 1
    let mut p = 1usize;
    let mut x = 1usize;
    while x != 0 {
        x = gf.a(x, 1);
        p += 1;
    }
    let pow = |b0: usize, mut e: usize| -> usize {
        let mut b = b0;
        let mut r = 1usize;
        while e > 0 {
            if e & 1 == 1 {
                r = gf.m(r, b);
            }
            b = gf.m(b, b);
            e >>= 1;
        }
        r
    };
    let frob: Vec<u16> = (0..q).map(|v| pow(v, p) as u16).collect();
    let mut autos: Vec<Vec<u16>> = vec![(0..q as u16).collect()];
    let mut cur = frob.clone();
    while cur.iter().enumerate().any(|(i, &v)| v as usize != i) {
        autos.push(cur.clone());
        cur = (0..q).map(|v| frob[cur[v] as usize]).collect();
    }
    autos
}

// exhaustive: every involution of the form (r,c) -> (a*s(r)+s1, b*s(c)+t1) or the swapped form,
// s a field automorphism — deduped. Includes maps useless as mirrors (reflections); they never
// witness membership of a legal |S|>=2 position (their orbits pair cells within a row/col), so
// including them is sound and costs nothing.
fn all_involutions(b: &Board) -> Vec<Involution> {
    let gf = &b.gf;
    let q = gf.q;
    let n = b.n;
    let autos = field_autos(gf);
    let neg1 = gf.neg[1] as usize;
    let mut seen: HashSet<Vec<u16>> = HashSet::new();
    let mut out: Vec<Involution> = Vec::new();
    let mut perm = vec![0u16; n];
    for (si, sigma) in autos.iter().enumerate() {
        for swap in [false, true] {
            for alpha in 1..q {
                for beta in 1..q {
                    for s in 0..q {
                        for t in 0..q {
                            for r in 0..q {
                                for c in 0..q {
                                    let (u, v) = if swap { (c, r) } else { (r, c) };
                                    let rr = gf.a(gf.m(alpha, sigma[u] as usize), s);
                                    let cc = gf.a(gf.m(beta, sigma[v] as usize), t);
                                    perm[r * q + c] = (rr * q + cc) as u16;
                                }
                            }
                            let mut is_inv = true;
                            let mut is_id = true;
                            for i in 0..n {
                                if perm[perm[i] as usize] as usize != i {
                                    is_inv = false;
                                    break;
                                }
                                if perm[i] as usize != i {
                                    is_id = false;
                                }
                            }
                            if !is_inv || is_id || !seen.insert(perm.clone()) {
                                continue;
                            }
                            let mut fixed = [0u64; MAXW];
                            let mut problem = [0u64; MAXW];
                            for i in 0..n {
                                let j = perm[i] as usize;
                                if j == i {
                                    set_bit(&mut fixed, i);
                                    set_bit(&mut problem, i);
                                } else if i / q == j / q || i % q == j % q {
                                    set_bit(&mut problem, i);
                                }
                            }
                            let kind = if si != 0 {
                                3
                            } else if swap {
                                1
                            } else if alpha == 1 && beta == 1 {
                                2
                            } else if alpha == neg1 && beta == neg1 {
                                0
                            } else {
                                4
                            };
                            out.push(Involution { perm: perm.clone(), fixed, problem, kind });
                        }
                    }
                }
            }
        }
    }
    out
}

// v3 family: symmetric under ANY nontrivial grid automorphism (order >= 2) — the maximal
// symmetry-based family. Enumerates the whole automorphism group (semilinear monomial affine,
// both coordinate orders); for a general g the |D|=1 reply y additionally needs g(y) in U
// (automatic for involutions, checked explicitly here); |D|=0 replies need g(y)=y.
fn all_autos(b: &Board) -> Vec<Involution> {
    let gf = &b.gf;
    let q = gf.q;
    let n = b.n;
    let autos = field_autos(gf);
    let neg1 = gf.neg[1] as usize;
    let mut seen: HashSet<Vec<u16>> = HashSet::new();
    let mut out: Vec<Involution> = Vec::new();
    let mut perm = vec![0u16; n];
    for (si, sigma) in autos.iter().enumerate() {
        for swap in [false, true] {
            for alpha in 1..q {
                for beta in 1..q {
                    for s in 0..q {
                        for t in 0..q {
                            for r in 0..q {
                                for c in 0..q {
                                    let (u, v) = if swap { (c, r) } else { (r, c) };
                                    let rr = gf.a(gf.m(alpha, sigma[u] as usize), s);
                                    let cc = gf.a(gf.m(beta, sigma[v] as usize), t);
                                    perm[r * q + c] = (rr * q + cc) as u16;
                                }
                            }
                            let mut is_id = true;
                            for i in 0..n {
                                if perm[i] as usize != i {
                                    is_id = false;
                                    break;
                                }
                            }
                            if is_id || !seen.insert(perm.clone()) {
                                continue;
                            }
                            let mut is_inv = true;
                            for i in 0..n {
                                if perm[perm[i] as usize] as usize != i {
                                    is_inv = false;
                                    break;
                                }
                            }
                            let mut fixed = [0u64; MAXW];
                            let mut problem = [0u64; MAXW];
                            for i in 0..n {
                                let j = perm[i] as usize;
                                if j == i {
                                    set_bit(&mut fixed, i);
                                    set_bit(&mut problem, i);
                                } else if i / q == j / q || i % q == j % q {
                                    set_bit(&mut problem, i);
                                }
                            }
                            let kind = if !is_inv {
                                5
                            } else if si != 0 {
                                3
                            } else if swap {
                                1
                            } else if alpha == 1 && beta == 1 {
                                2
                            } else if alpha == neg1 && beta == neg1 {
                                0
                            } else {
                                4
                            };
                            out.push(Involution { perm: perm.clone(), fixed, problem, kind });
                        }
                    }
                }
            }
        }
    }
    out
}

struct ResymStats {
    states: u64,
    max_size: usize,
    kind_wins: [u64; 6],
    fail_min_size: usize,
    fail_rep: Vec<u16>, // S cells with the unanswerable break x last
    fail_max_size: usize,
    fail_max_rep: Vec<u16>, // deepest failing (S,x): there NO symmetric family reply exists at all
    start: Instant,
}

#[allow(clippy::too_many_arguments)]
fn resym_safe(
    b: &Board,
    invs: &[Involution],
    memo: &mut FnvMap<u128, bool>,
    game: Option<&FnvMap<u128, bool>>, // exact game values (v4: family also requires true P)
    occ: &mut Vec<u16>,
    chosen: &Mask,
    forbidden: &Mask,
    variant: usize,
    st: &mut ResymStats,
) -> bool {
    let key = b.canon(occ);
    if let Some(&v) = memo.get(&key) {
        return v;
    }
    st.states += 1;
    if occ.len() > st.max_size {
        st.max_size = occ.len();
    }
    if st.states % 100_000 == 0 {
        eprintln!(
            "  [resym {:6.0}s] states={}  max-size={}",
            st.start.elapsed().as_secs_f64(),
            st.states,
            st.max_size
        );
    }
    let mut avail = [0u64; MAXW];
    for i in 0..MAXW {
        avail[i] = b.all[i] & !chosen[i] & !forbidden[i];
    }
    if avail.iter().all(|&w| w == 0) {
        memo.insert(key, true); // P1 stuck: P2 already won
        return true;
    }
    let mut all_answered = true;
    'xloop: for w in 0..MAXW {
        let mut bits = avail[w];
        while bits != 0 {
            let tz = bits.trailing_zeros() as usize;
            bits &= bits - 1;
            let x = w * 64 + tz;
            // T = S + x
            let mut chosen_t = *chosen;
            set_bit(&mut chosen_t, x);
            let mut forb_t = *forbidden;
            mask_or(&mut forb_t, &b.rc_mask[x]);
            for &o in occ.iter() {
                mask_or(&mut forb_t, &b.line_mask[o as usize * b.n + x]);
            }
            let mut avail_t = [0u64; MAXW];
            for i in 0..MAXW {
                avail_t[i] = b.all[i] & !chosen_t[i] & !forb_t[i];
            }
            occ.push(x as u16);
            // gather symmetry-restoring reply candidates (y, phi)
            let mut cand = [0u64; MAXW];
            let mut pairs: Vec<(u16, u32)> = Vec::new();
            for (pi, inv) in invs.iter().enumerate() {
                let mut dcnt = 0usize;
                let mut dy = 0usize;
                for &tcell in occ.iter() {
                    let im = inv.perm[tcell as usize] as usize;
                    if chosen_t[im >> 6] & (1u64 << (im & 63)) == 0 {
                        dcnt += 1;
                        if dcnt > 1 {
                            break;
                        }
                        dy = im;
                    }
                }
                if dcnt == 1 {
                    // legal, and g(U)=U: g(y) must land back in U = T+{y} (automatic for
                    // involutions, needed for general g in the v3 family)
                    let gy = inv.perm[dy] as usize;
                    if avail_t[dy >> 6] & (1u64 << (dy & 63)) != 0
                        && (gy == dy || chosen_t[gy >> 6] & (1u64 << (gy & 63)) != 0)
                    {
                        pairs.push((dy as u16, pi as u32));
                        set_bit(&mut cand, dy);
                    }
                } else if dcnt == 0 {
                    for w2 in 0..MAXW {
                        let mut fb = inv.fixed[w2] & avail_t[w2];
                        while fb != 0 {
                            let tz2 = fb.trailing_zeros() as usize;
                            fb &= fb - 1;
                            pairs.push(((w2 * 64 + tz2) as u16, pi as u32));
                            set_bit(&mut cand, w2 * 64 + tz2);
                        }
                    }
                }
            }
            let mut answered = false;
            'yloop: for w2 in 0..MAXW {
                let mut yb = cand[w2];
                while yb != 0 {
                    let tz2 = yb.trailing_zeros() as usize;
                    yb &= yb - 1;
                    let y = w2 * 64 + tz2;
                    // U = T + y
                    let mut chosen_u = chosen_t;
                    set_bit(&mut chosen_u, y);
                    let mut forb_u = forb_t;
                    mask_or(&mut forb_u, &b.rc_mask[y]);
                    for &o in occ.iter() {
                        mask_or(&mut forb_u, &b.line_mask[o as usize * b.n + y]);
                    }
                    let mut avail_u = [0u64; MAXW];
                    for i in 0..MAXW {
                        avail_u[i] = b.all[i] & !chosen_u[i] & !forb_u[i];
                    }
                    // v4: family also requires U to be a TRUE P-position of the game
                    if let Some(gm) = game {
                        occ.push(y as u16);
                        let ukey = b.canon(occ);
                        occ.pop();
                        match gm.get(&ukey) {
                            Some(&is_n) if !is_n => {}
                            _ => continue, // N or unreachable: not in the v4 family
                        }
                    }
                    // membership witness: some phi restoring symmetry that passes the variant
                    let mut witness: Option<u32> = None;
                    for &(py, pi) in pairs.iter() {
                        if py as usize != y {
                            continue;
                        }
                        let inv = &invs[pi as usize];
                        let ok = match variant {
                            0 => true,
                            1 => (0..MAXW).all(|i| inv.fixed[i] & avail_u[i] == 0),
                            _ => (0..MAXW).all(|i| inv.problem[i] & avail_u[i] == 0),
                        };
                        if ok {
                            witness = Some(pi);
                            break;
                        }
                    }
                    let wpi = match witness {
                        Some(p) => p,
                        None => continue,
                    };
                    occ.push(y as u16);
                    let ok = resym_safe(b, invs, memo, game, occ, &chosen_u, &forb_u, variant, st);
                    occ.pop();
                    if ok {
                        st.kind_wins[invs[wpi as usize].kind] += 1;
                        answered = true;
                        break 'yloop;
                    }
                }
            }
            occ.pop();
            if !answered {
                if occ.len() < st.fail_min_size {
                    st.fail_min_size = occ.len();
                    st.fail_rep = occ.clone();
                    st.fail_rep.push(x as u16);
                }
                if st.fail_max_rep.is_empty() || occ.len() > st.fail_max_size {
                    st.fail_max_size = occ.len();
                    st.fail_max_rep = occ.clone();
                    st.fail_max_rep.push(x as u16);
                }
                all_answered = false;
                break 'xloop;
            }
        }
    }
    memo.insert(key, all_answered);
    all_answered
}

// ---- BREAKS mode: cross-validate resym against the exact game ----
// Full-expands the true game, then for EVERY legal P1 break x from the frame reports: #legal
// replies, #true-P replies (P2's real winning replies), and #P replies whose position has a
// nontrivial stabilizer (is symmetric under some grid automorphism).  If some x has P>=1 but
// symmetric-P=0, the resym family loss is confirmed by the exact solver at the first level and
// P2's real winning replies there are ALL asymmetric.
fn solve_breaks(q: usize) {
    let b = Board::new(q);
    let autos = all_autos(&b);
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
    let mut occ0: Vec<u16> = Vec::new();
    let root_n = s.g(&mut occ0, &empty, &empty);
    // frame
    let c0 = 0usize;
    let c1 = q + 1;
    let mut chosen = empty;
    set_bit(&mut chosen, c0);
    set_bit(&mut chosen, c1);
    let mut forb = empty;
    mask_or(&mut forb, &b.rc_mask[c0]);
    mask_or(&mut forb, &b.rc_mask[c1]);
    mask_or(&mut forb, &b.line_mask[c0 * b.n + c1]);
    let occ: Vec<u16> = vec![c0 as u16, c1 as u16];
    let mut avail = [0u64; MAXW];
    for i in 0..MAXW {
        avail[i] = b.all[i] & !chosen[i] & !forb[i];
    }
    let symmetric = |u: &[u16], chos: &Mask| -> bool {
        'g: for g in autos.iter() {
            for &cell in u.iter() {
                let im = g.perm[cell as usize] as usize;
                if chos[im >> 6] & (1u64 << (im & 63)) == 0 {
                    continue 'g;
                }
            }
            return true;
        }
        false
    };
    println!(
        "q={:>3}  root={}  breaks-from-frame analysis (per P1 move x: replies / P-replies / symmetric-P-replies)",
        q,
        if root_n { "N (COUNTEREXAMPLE!)" } else { "P" }
    );
    let mut worst: (usize, usize, Vec<(usize, usize)>) = (usize::MAX, usize::MAX, Vec::new());
    let mut n_breaks = 0usize;
    let mut n_sym0 = 0usize; // breaks whose P-replies are ALL asymmetric
    for w in 0..MAXW {
        let mut bits = avail[w];
        while bits != 0 {
            let tz = bits.trailing_zeros() as usize;
            bits &= bits - 1;
            let x = w * 64 + tz;
            n_breaks += 1;
            let mut chosen_t = chosen;
            set_bit(&mut chosen_t, x);
            let mut forb_t = forb;
            mask_or(&mut forb_t, &b.rc_mask[x]);
            for &o in occ.iter() {
                mask_or(&mut forb_t, &b.line_mask[o as usize * b.n + x]);
            }
            let mut avail_t = [0u64; MAXW];
            for i in 0..MAXW {
                avail_t[i] = b.all[i] & !chosen_t[i] & !forb_t[i];
            }
            let mut occ_t = occ.clone();
            occ_t.push(x as u16);
            let (mut n_tot, mut n_p, mut n_symp) = (0usize, 0usize, 0usize);
            for w2 in 0..MAXW {
                let mut yb = avail_t[w2];
                while yb != 0 {
                    let tz2 = yb.trailing_zeros() as usize;
                    yb &= yb - 1;
                    let y = w2 * 64 + tz2;
                    n_tot += 1;
                    let mut chosen_u = chosen_t;
                    set_bit(&mut chosen_u, y);
                    let mut forb_u = forb_t;
                    mask_or(&mut forb_u, &b.rc_mask[y]);
                    for &o in occ_t.iter() {
                        mask_or(&mut forb_u, &b.line_mask[o as usize * b.n + y]);
                    }
                    let mut occ_u = occ_t.clone();
                    occ_u.push(y as u16);
                    let key = b.canon(&occ_u);
                    let is_n = match s.memo.get(&key) {
                        Some(&v) => v,
                        None => s.g(&mut occ_u.clone(), &chosen_u, &forb_u),
                    };
                    if !is_n {
                        n_p += 1;
                        if symmetric(&occ_u, &chosen_u) {
                            n_symp += 1;
                        }
                    }
                }
            }
            if n_p > 0 && n_symp == 0 {
                n_sym0 += 1;
            }
            if (n_symp, n_p) < (worst.0, worst.1) {
                let cells: Vec<(usize, usize)> =
                    occ_t.iter().map(|&c| (c as usize / q, c as usize % q)).collect();
                worst = (n_symp, n_p, cells);
            }
            println!(
                "      x=({},{})  replies={}  P={}  symmetric-P={}{}",
                x / q,
                x % q,
                n_tot,
                n_p,
                n_symp,
                if n_p > 0 && n_symp == 0 { "   <-- P-replies ALL asymmetric" } else { "" }
            );
        }
    }
    println!(
        "      summary: {} breaks, {} with all-asymmetric P-replies; worst (sym-P, P) = ({}, {}) at {:?}",
        n_breaks, n_sym0, worst.0, worst.1, worst.2
    );
}

// ---- CHECKPOS mode: exact reply analysis for one position + break ----
// checkpos <q> r,c r,c ... / rx,cx   (last cell after '/' = P1's break move)
// Prints every legal reply with its exact game value and stabilizer status.
fn solve_checkpos(q: usize, scells: &[(usize, usize)], bx: (usize, usize)) {
    let b = Board::new(q);
    let autos = all_autos(&b);
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
    let mut occ0: Vec<u16> = Vec::new();
    s.g(&mut occ0, &empty, &empty);
    // build position T = S + x incrementally
    let mut chosen = empty;
    let mut forb = empty;
    let mut occ: Vec<u16> = Vec::new();
    let add = |cell: (usize, usize), occ: &mut Vec<u16>, chosen: &mut Mask, forb: &mut Mask| {
        let i = cell.0 * q + cell.1;
        for &o in occ.iter() {
            mask_or(forb, &b.line_mask[o as usize * b.n + i]);
        }
        mask_or(forb, &b.rc_mask[i]);
        set_bit(chosen, i);
        occ.push(i as u16);
    };
    for &c in scells {
        add(c, &mut occ, &mut chosen, &mut forb);
    }
    let skey = b.canon(&occ);
    let s_val = s.memo.get(&skey).map(|&v| if v { "N" } else { "P" }).unwrap_or("?");
    add(bx, &mut occ, &mut chosen, &mut forb);
    let tkey = b.canon(&occ);
    let t_val = s.memo.get(&tkey).map(|&v| if v { "N" } else { "P" }).unwrap_or("?");
    println!(
        "q={}  S={:?} ({})  break x={:?} => T ({})  replies:",
        q, scells, s_val, bx, t_val
    );
    let mut avail = [0u64; MAXW];
    for i in 0..MAXW {
        avail[i] = b.all[i] & !chosen[i] & !forb[i];
    }
    let symmetric = |u: &[u16], chos: &Mask| -> bool {
        'g: for g in autos.iter() {
            for &cell in u.iter() {
                let im = g.perm[cell as usize] as usize;
                if chos[im >> 6] & (1u64 << (im & 63)) == 0 {
                    continue 'g;
                }
            }
            return true;
        }
        false
    };
    let (mut n_tot, mut n_p, mut n_symp) = (0usize, 0usize, 0usize);
    for w in 0..MAXW {
        let mut yb = avail[w];
        while yb != 0 {
            let tz = yb.trailing_zeros() as usize;
            yb &= yb - 1;
            let y = w * 64 + tz;
            n_tot += 1;
            let mut chosen_u = chosen;
            set_bit(&mut chosen_u, y);
            let mut forb_u = forb;
            mask_or(&mut forb_u, &b.rc_mask[y]);
            for &o in occ.iter() {
                mask_or(&mut forb_u, &b.line_mask[o as usize * b.n + y]);
            }
            let mut occ_u = occ.clone();
            occ_u.push(y as u16);
            let key = b.canon(&occ_u);
            let is_n = match s.memo.get(&key) {
                Some(&v) => v,
                None => s.g(&mut occ_u.clone(), &chosen_u, &forb_u),
            };
            let sym = symmetric(&occ_u, &chosen_u);
            if !is_n {
                n_p += 1;
                if sym {
                    n_symp += 1;
                }
            }
            println!(
                "      y=({},{})  {}  {}",
                y / q,
                y % q,
                if is_n { "N" } else { "P  <-- winning" },
                if sym { "[symmetric]" } else { "" }
            );
        }
    }
    println!("      total={}  P={}  symmetric-P={}", n_tot, n_p, n_symp);
}

fn solve_resym(q: usize, variant: usize) {
    let b = Board::new(q);
    let t0 = Instant::now();
    let invs = if variant >= 3 { all_autos(&b) } else { all_involutions(&b) };
    // v4: family = symmetric AND true-P; full-expand the exact game first
    let game_memo: Option<FnvMap<u128, bool>> = if variant == 4 {
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
        let mut occ0: Vec<u16> = Vec::new();
        s.g(&mut occ0, &empty, &empty);
        eprintln!("  [resym q={} v4] exact game expanded: {} classes", q, s.memo.len());
        Some(s.memo)
    } else {
        None
    };
    let mut kc = [0usize; 6];
    for inv in &invs {
        kc[inv.kind] += 1;
    }
    eprintln!(
        "  [resym q={} v{}] {} symmetries (central {}, antidiag {}, translation {}, frob {}, reflection {}, order>2 {}) built in {:.1}s",
        q, variant, invs.len(), kc[0], kc[1], kc[2], kc[3], kc[4], kc[5],
        t0.elapsed().as_secs_f64()
    );
    // frame = grid size-2 position {(0,0),(1,1)} (single G-orbit of legal pairs); with the
    // trivial sizes 0..2 chain this decides PG(2,q) (frame reduction).
    let empty = [0u64; MAXW];
    let c0 = 0usize;
    let c1 = q + 1;
    let mut chosen = empty;
    set_bit(&mut chosen, c0);
    set_bit(&mut chosen, c1);
    let mut forb = empty;
    mask_or(&mut forb, &b.rc_mask[c0]);
    mask_or(&mut forb, &b.rc_mask[c1]);
    mask_or(&mut forb, &b.line_mask[c0 * b.n + c1]);
    let mut occ: Vec<u16> = vec![c0 as u16, c1 as u16];
    let mut memo: FnvMap<u128, bool> = FnvMap::default();
    let mut st = ResymStats {
        states: 0,
        max_size: 2,
        kind_wins: [0; 6],
        fail_min_size: usize::MAX,
        fail_rep: Vec::new(),
        fail_max_size: 0,
        fail_max_rep: Vec::new(),
        start: Instant::now(),
    };
    let safe = resym_safe(
        &b, &invs, &mut memo, game_memo.as_ref(), &mut occ, &chosen, &forb, variant, &mut st,
    );
    println!(
        "q={:>3}  v{}  frame-SAFE={}  states={}  max-size={}  witness-kinds central:{} antidiag:{} translation:{} frob:{} reflection:{} order>2:{}  [{:.1}s]",
        q,
        variant,
        if safe { "YES (adaptive P2 strategy verified => PG(2,q)=P)" } else { "NO" },
        st.states,
        st.max_size,
        st.kind_wins[0],
        st.kind_wins[1],
        st.kind_wins[2],
        st.kind_wins[3],
        st.kind_wins[4],
        st.kind_wins[5],
        st.start.elapsed().as_secs_f64()
    );
    if !safe {
        let rep: Vec<(usize, usize)> =
            st.fail_rep.iter().map(|&c| (c as usize / q, c as usize % q)).collect();
        println!(
            "      first unrecoverable break: |S|={}  S+x cells (break x last) = {:?}",
            st.fail_min_size, rep
        );
        let repm: Vec<(usize, usize)> =
            st.fail_max_rep.iter().map(|&c| (c as usize / q, c as usize % q)).collect();
        println!(
            "      deepest failing break (zero family replies there): |S|={}  S+x cells (break x last) = {:?}",
            st.fail_max_size, repm
        );
    }
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
    if args[1] == "resym" {
        // resym [v0|v1|v2] <q> [q2 ...]
        let mut rest: &[String] = &args[2..];
        let mut variant = 0usize;
        if !rest.is_empty() && rest[0].starts_with('v') {
            variant = rest[0][1..].parse().expect("variant must be v0|v1|v2");
            rest = &rest[1..];
        }
        for a in rest {
            let q: usize = a.parse().expect("q must be an integer");
            solve_resym(q, variant);
        }
        return;
    }
    if args[1] == "checkpos" {
        // checkpos <q> r,c r,c ... / rx,cx
        let q: usize = args[2].parse().expect("q must be an integer");
        let mut cells: Vec<(usize, usize)> = Vec::new();
        let mut bx: Option<(usize, usize)> = None;
        let mut after_slash = false;
        for a in &args[3..] {
            if a == "/" {
                after_slash = true;
                continue;
            }
            let (r, c) = a.split_once(',').expect("cell must be r,c");
            let cell = (r.parse().unwrap(), c.parse().unwrap());
            if after_slash {
                bx = Some(cell);
            } else {
                cells.push(cell);
            }
        }
        solve_checkpos(q, &cells, bx.expect("break cell after /"));
        return;
    }
    if args[1] == "breaks" {
        for a in &args[2..] {
            let q: usize = a.parse().expect("q must be an integer");
            solve_breaks(q);
        }
        return;
    }
    if args[1] == "boundary" {
        for a in &args[2..] {
            let q: usize = a.parse().expect("q must be an integer");
            solve_boundary(q);
        }
        return;
    }
    let full = match args[1].as_str() {
        "outcome" => false,
        "defect" => true,
        _ => {
            eprintln!("mode must be 'outcome' | 'defect' | 'escape' | 'boundary' | 'par'");
            std::process::exit(2);
        }
    };
    for a in &args[2..] {
        let q: usize = a.parse().expect("q must be an integer");
        solve(q, full);
    }
}
