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
//   esc <q> [--cap <slots>] [class-index...]
//                -- same escape/bad table as `escape`, but each canonical size-3 class is solved
//                   with a PRIVATE full-expansion memo dropped after the class (no global arena):
//                   route (D), push past the q=19 memory wall class-by-class. Reports per-class
//                   escape/bad + PEAK private-memo size; `--cap` aborts a class whose memo exceeds
//                   it; a class-index filter resumes a q=23 campaign. Single-threaded, small RSS.
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
//   cert <q> [--out <dir>] [--bookcap <nodes>] [class-index...]
//                -- route-C phase-1 escape CERTIFICATE emitter (2026-07-07 codex task queue C12).
//                   Per canonical size-3 class: emit S3, one witness escape cell p (ON-conic when
//                   one exists, else off, recorded), and the FULL P-reply-book (responder strategy
//                   DAG) of the size-4 P-position insert p S3 — matching FiniteBuildGame.PairReplyBook
//                   / PCert (lean/CapGame/BuildGame.lean).  Writes <dir>/gridcap-q<q>.cert (default
//                   dir "certs"), line-oriented plain text, self-describing header, cells as r,c.
//                   Also prints the escape histogram (cross-check vs escape/esc).  Private per-class
//                   value memo (dropped per class), single-threaded.  `--bookcap` caps a class's book
//                   node count (marks it CAPPED, skips its book).
//   certcheck <q> <file>
//                -- INDEPENDENT re-verification of a .cert file using GAME RULES ONLY (no game
//                   values): witness position = S3+p legal cap; per book node, move/reply legality,
//                   closure (every legal move covered by exactly one reply row), child = P+x+y,
//                   terminal parity (no legal move + even size); onconic flag vs conic geometry.
//
// Build:  rustc -O -C target-cpu=native 2026-07-06-grid-cap-solver.rs -o /tmp/gridcap
// Falsification watch: if `outcome` ever prints N (first-player win), PG(2,q) has a
// counterexample; if `defect`'s min-deviating-size approaches 0/1, the root is about to flip.

use std::collections::{HashMap, HashSet};
use std::env;
use std::hash::{BuildHasherDefault, Hasher};
use std::io::{BufWriter, Write};
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
        49 => (7, vec![1, 0, 1]),          // x^2 + 1 (-1 nonsquare mod 7)
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
        for a in 1..q {
            assert!(
                inv[a] != 0 && mul[a * q + inv[a] as usize] == 1,
                "GF({}) element {} has no multiplicative inverse; check irreducible polynomial",
                q,
                a
            );
        }
        for a in 1..q {
            for b in 1..q {
                assert!(
                    mul[a * q + b] != 0,
                    "GF({}) has zero divisor {} * {}; check irreducible polynomial",
                    q,
                    a,
                    b
                );
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
        let n = q
            .checked_mul(q)
            .expect("q*q overflow while constructing board");
        assert!(
            n <= 64 * MAXW,
            "q={} gives {} cells, but this bit-mask build supports at most {} cells",
            q,
            n,
            64 * MAXW
        );
        let gf = GF::new(q);
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

// ---- ESC mode: per-size-3-class subtree solve with a PRIVATE (per-class) memo ----
// (Open-math plan 2026-07-07 route (D): push the escape/bad table past the q=19 GLOBAL-arena wall
// by solving each canonical size-3 class's subtree INDEPENDENTLY with a memo that is DROPPED when
// the class completes.  Peak RSS = one class's subtree, not the whole game — so a q=23 campaign
// can run class-by-class under a fixed budget instead of one >17 GB arena.)
//
// Reports the same escape/bad line as `escape` mode (over the full class set, unfiltered), plus
// the peak private-memo size per class.  A `--cap <slots>` bound ABORTS (and skips) any class
// whose private memo reaches it; an optional class-index filter processes only those classes so a
// walled q=23 run can be resumed class-by-class.
//
// Soundness: the private memo is keyed by the SAME global canon() as the shared arena.  Within one
// subtree that key merges MORE positions (never fewer) than a cross-subtree arena would, and the
// game value is a G-invariant, so every class's escape/bad count is IDENTICAL to `escape` mode's
// (validated exact at q=17 histogram 5:3 10:12 11:6 and q=19 uniform 211:27).  The only cost of the
// private memo is recomputing subtrees shared across different size-3 classes (never wrong, just
// slower) in exchange for a bounded, dropped-per-class memory footprint.

// Full-expansion recursion — identical to Solver::g with full=true, minus the defect diagnostics —
// over a PRIVATE memo, with a slot cap.  Returns None if the memo reached `cap` (class aborted).
fn esc_g(
    b: &Board,
    memo: &mut FnvMap<u128, bool>,
    cap: usize,
    occ: &mut Vec<u16>,
    chosen: &Mask,
    forbidden: &Mask,
) -> Option<bool> {
    let key = b.canon(occ);
    if let Some(&v) = memo.get(&key) {
        return Some(v);
    }
    if memo.len() >= cap {
        return None; // private memo hit the cap -> abort this class
    }
    let mut avail = [0u64; MAXW];
    for i in 0..MAXW {
        avail[i] = b.all[i] & !chosen[i] & !forbidden[i];
    }
    let mut is_n = false;
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
            let child = esc_g(b, memo, cap, occ, &nchosen, &nforb);
            occ.pop();
            match child {
                None => return None,        // propagate abort up the stack
                Some(false) => is_n = true, // full expansion: keep expanding siblings (no break)
                Some(true) => {}
            }
        }
    }
    memo.insert(key, is_n);
    Some(is_n)
}

// esc <q> [--cap <slots>] [class-index...]
fn solve_esc(q: usize, filter: &[usize], cap: usize) {
    let b = Board::new(q);
    let empty = [0u64; MAXW];
    // phase 1: canonical size-3 classes (reuse the enumerate machinery, same as `escape` phase-2)
    let mut frontier: Vec<(Vec<u16>, Mask, Mask)> = Vec::new();
    {
        let mut visited: HashSet<u128> = HashSet::new();
        let mut occ3: Vec<u16> = Vec::new();
        enumerate(&b, 3, &mut occ3, &empty, &empty, &mut visited, &mut frontier);
    }
    let ncls = frontier.len();
    let total_expected = (q * q + 21).wrapping_sub(9 * q); // q^2 - 9q + 21 (total lemma)
    let cap_str = if cap == usize::MAX { "none".to_string() } else { cap.to_string() };
    eprintln!(
        "  [esc q={}] {} size-3 classes; cap={}{}",
        q,
        ncls,
        cap_str,
        if filter.is_empty() { String::new() } else { format!("; filter={:?}", filter) }
    );

    // class indices to process (all, in canonical order, when unfiltered)
    let selected: Vec<usize> = if filter.is_empty() { (0..ncls).collect() } else { filter.to_vec() };

    // aggregate stats over successfully solved classes
    let mut min_esc = usize::MAX;
    let mut max_esc = 0usize;
    let mut even_esc = 0u64; // classes with escape even  (= bad odd)
    let mut solved = 0u64;
    let mut aborted = 0u64;
    let mut bad_total_ne = 0u64; // classes where total != formula (must be 0)
    let mut peak_max = 0usize;
    let mut hist: std::collections::BTreeMap<usize, u64> = std::collections::BTreeMap::new();
    let start = Instant::now();

    for &ci in &selected {
        if ci >= ncls {
            println!("CLS q={} cls={} status=OUT-OF-RANGE (only {} classes)", q, ci, ncls);
            continue;
        }
        eprintln!(
            "  [esc q={} {:6.1}s] class {}/{} (index {}) ...",
            q, start.elapsed().as_secs_f64(), solved + aborted + 1, selected.len(), ci
        );
        let (occ0, chosen, forbidden) = &frontier[ci];
        let cells: Vec<(usize, usize)> =
            occ0.iter().map(|&z| (z as usize / q, z as usize % q)).collect();
        // PRIVATE memo for THIS class only; dropped at the end of this loop iteration
        let mut memo: FnvMap<u128, bool> = FnvMap::default();
        // full-expansion solve of the size-3 subtree -> memoizes every size-4 child + descendant
        let mut occ = occ0.clone();
        let res = esc_g(&b, &mut memo, cap, &mut occ, chosen, forbidden);
        let peak = memo.len();
        if peak > peak_max {
            peak_max = peak;
        }
        if res.is_none() {
            aborted += 1;
            println!(
                "CLS q={} cls={} S3={:?} status=ABORTED peak-memo={} cap={}",
                q, ci, cells, peak, cap
            );
            continue;
        }
        // count escape = # P size-4 children (look them up from the now-populated private memo,
        // iterating the SAME avail cells `escape` mode counts over)
        let mut avail = [0u64; MAXW];
        for i in 0..MAXW {
            avail[i] = b.all[i] & !chosen[i] & !forbidden[i];
        }
        let mut n_p = 0usize;
        let mut n_tot = 0usize;
        let mut occ4 = occ0.clone();
        for w in 0..MAXW {
            let mut bits = avail[w];
            while bits != 0 {
                let tz = bits.trailing_zeros() as usize;
                bits &= bits - 1;
                let z = w * 64 + tz;
                n_tot += 1;
                occ4.push(z as u16);
                let key = b.canon(&occ4);
                occ4.pop();
                let is_n = *memo
                    .get(&key)
                    .expect("size-4 child must be memoized after full expansion");
                if !is_n {
                    n_p += 1; // P child = an escape
                }
            }
        }
        if n_tot != total_expected {
            bad_total_ne += 1;
        }
        let bad = n_tot - n_p;
        solved += 1;
        if n_p < min_esc {
            min_esc = n_p;
        }
        if n_p > max_esc {
            max_esc = n_p;
        }
        if n_p % 2 == 0 {
            even_esc += 1;
        }
        *hist.entry(n_p).or_insert(0) += 1;
        println!(
            "CLS q={} cls={} S3={:?} escape={} bad={} total={} peak-memo={} status=OK",
            q, ci, cells, n_p, bad, n_tot, peak
        );
    }

    // When the FULL class set solved with no aborts, reproduce the `escape` mode summary line
    // EXACTLY (root via the proven frame reduction: PG(2,q)=P <=> every S3 has an escape >=1;
    // 2026-07-06-frame-reduction.md / -escape-count-lemma.md).  Filtered/aborted runs print a
    // clearly-labelled PARTIAL summary instead (a resumed q=23 campaign cannot claim the root).
    let full_run = filter.is_empty() && aborted == 0 && solved == ncls as u64;
    let hs: Vec<String> = hist.iter().map(|(k, v)| format!("{}:{}", k, v)).collect();
    if full_run {
        let root_n = min_esc == 0; // some size-3 class with no escape => root N (counterexample)
        let outcome = if root_n { "N (COUNTEREXAMPLE!)" } else { "P" };
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
        println!(
            "      peak-private-memo max over classes = {}  [{:.1}s]",
            peak_max,
            start.elapsed().as_secs_f64()
        );
    } else {
        println!(
            "q={:>3}  PARTIAL  size3-classes={}  solved={}  aborted={}  total(q^2-9q+21)={}  \
             min-escape={}  max-escape={}  even-escape={}/{}  peak-private-memo-max={}  [{:.1}s]",
            q,
            ncls,
            solved,
            aborted,
            total_expected,
            if min_esc == usize::MAX { 0 } else { min_esc },
            max_esc,
            even_esc,
            solved,
            peak_max,
            start.elapsed().as_secs_f64()
        );
        if !hs.is_empty() {
            println!("      escape-histogram (escape:classes) = {}", hs.join(" "));
        }
    }
}

// ---- FEAT mode: route (B) per-class / per-extension conic-feature dump ----
// Open-math plan 2026-07-07 route (B): hunt a finer counting invariant on the escape/bad data.
// The principled first feature is Segre-shaped: through the projective 5-arc (2 burned direction
// points + S3) there is a UNIQUE conic; since it passes through both direction points (1:0:0)
// and (0:1:0), its affine part is the graph of the Moebius map through the 3 cells,
//   F(r,c) = rc + eps*r + zeta*c + gamma = 0
// (delta=1 normalization; delta=0 would make S3 collinear, excluded by the cap property).
// Conics = the (q+1)-arcs (Segre, q odd) = the EVEN maximal grid caps (q-1 affine cells), so
// "steer to the conic" is the natural even-completion strategy and on/off-conic position is the
// natural refinement of the total lemma's count.  Features per legal extension x:
//   on  = x on the conic;
//   ext = x external (exactly 2 tangents of the conic pass through x);
//   int = x internal (0 tangents).                       (q odd => 0/2 dichotomy off the conic)
// Emits machine-readable lines for offline regression:
//   X q=<q> cls=<i> x=<r>,<c> val=<P|N> pos=<on|ext|int>
//   CLS q=<q> cls=<i> S3=... escape=.. bad=.. onP/onN/extP/extN/intP/intN=..  legal_on=..
// plus per-q sanity checks (conic has q-1 affine cells, functional per row/col; every off-S3
// conic cell is a LEGAL extension, i.e. legal_on = q-4; tangent counts in {0,2}).
fn solve_feat(q: usize) {
    if q % 2 == 0 {
        eprintln!("feat mode: odd q only (conic interior/exterior needs q odd)");
        return;
    }
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
    // phase 1: full expansion => every reachable class memoized P/N
    let mut occ: Vec<u16> = Vec::new();
    let root_n = s.g(&mut occ, &empty, &empty);

    // phase 2: canonical size-3 classes
    let mut frontier: Vec<(Vec<u16>, Mask, Mask)> = Vec::new();
    {
        let mut visited: HashSet<u128> = HashSet::new();
        let mut occ3: Vec<u16> = Vec::new();
        enumerate(&b, 3, &mut occ3, &empty, &empty, &mut visited, &mut frontier);
    }
    let gf = &b.gf;
    let mut sane = true;
    for (ci, (occ0, chosen, forbidden)) in frontier.iter().enumerate() {
        let cells: Vec<(usize, usize)> =
            occ0.iter().map(|&z| (z as usize / q, z as usize % q)).collect();
        // conic fit: for each S3 cell,  r*c + eps*r + zeta*c + gamma = 0  — 3x3 linear system in
        // (eps, zeta, gamma); its determinant is the collinearity det of the 3 cells (nonzero,
        // cap property). Gaussian elimination over GF(q).
        let mut m: [[usize; 4]; 3] = [[0; 4]; 3];
        for i in 0..3 {
            let (r, c) = cells[i];
            m[i] = [r, c, 1, gf.neg[gf.m(r, c)] as usize];
        }
        for col in 0..3 {
            let piv = (col..3).find(|&i| m[i][col] != 0).expect("singular conic fit (S3 collinear?)");
            m.swap(col, piv);
            let inv = gf.inv[m[col][col]] as usize;
            for j in col..4 {
                m[col][j] = gf.m(inv, m[col][j]);
            }
            for i in 0..3 {
                if i != col && m[i][col] != 0 {
                    let f = m[i][col];
                    for j in col..4 {
                        m[i][j] = gf.sub(m[i][j], gf.m(f, m[col][j]));
                    }
                }
            }
        }
        let (eps, zeta, gamma) = (m[0][3], m[1][3], m[2][3]);
        let fval =
            |r: usize, c: usize| gf.a(gf.a(gf.m(r, c), gf.m(eps, r)), gf.a(gf.m(zeta, c), gamma));
        // affine conic cells + sanity (q-1 cells, functional per row and per col)
        let mut conic_cells: Vec<(usize, usize)> = Vec::new();
        for r in 0..q {
            for c in 0..q {
                if fval(r, c) == 0 {
                    conic_cells.push((r, c));
                }
            }
        }
        let mut rows_seen = vec![0u8; q];
        let mut cols_seen = vec![0u8; q];
        for &(r, c) in &conic_cells {
            rows_seen[r] += 1;
            cols_seen[c] += 1;
        }
        if conic_cells.len() != q - 1
            || rows_seen.iter().any(|&x| x > 1)
            || cols_seen.iter().any(|&x| x > 1)
        {
            println!(
                "!! q={} cls={} conic sanity FAIL: {} affine cells (expected {})",
                q,
                ci,
                conic_cells.len(),
                q - 1
            );
            sane = false;
        }
        // tangent count through affine v: #conic points P with B(P,v)=0 (polar/tangent at P).
        // B(P,v) = p_r v_c + p_c v_r + eps(p_r+v_r) + zeta(p_c+v_c) + 2 gamma   (P,v affine), and
        // for the two infinite conic points: B((1:0:0),v) = v_c + eps, B((0:1:0),v) = v_r + zeta.
        let two_gamma = gf.a(gamma, gamma);
        let tangents = |vr: usize, vc: usize| -> usize {
            let mut t = 0usize;
            if gf.a(vc, eps) == 0 {
                t += 1;
            }
            if gf.a(vr, zeta) == 0 {
                t += 1;
            }
            for &(pr, pc) in &conic_cells {
                let bl = gf.a(
                    gf.a(gf.a(gf.m(pr, vc), gf.m(pc, vr)), gf.m(eps, gf.a(pr, vr))),
                    gf.a(gf.m(zeta, gf.a(pc, vc)), two_gamma),
                );
                if bl == 0 {
                    t += 1;
                }
            }
            t
        };
        // per-extension loop (as in escape mode) + feature classification
        let mut avail = [0u64; MAXW];
        for i in 0..MAXW {
            avail[i] = b.all[i] & !chosen[i] & !forbidden[i];
        }
        let (mut on_p, mut on_n, mut ext_p, mut ext_n, mut int_p, mut int_n) = (0, 0, 0, 0, 0, 0);
        let mut anom = 0usize; // off-conic tangent count not in {0,2}
        let mut occ4 = occ0.clone();
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
                for &x in occ0.iter() {
                    mask_or(&mut nforb, &b.line_mask[x as usize * b.n + z]);
                }
                occ4.push(z as u16);
                let key = b.canon(&occ4);
                let is_n = match s.memo.get(&key) {
                    Some(&v) => v,
                    None => s.g(&mut occ4, &nchosen, &nforb),
                };
                occ4.pop();
                let (xr, xc) = (z / q, z % q);
                let pos = if fval(xr, xc) == 0 {
                    if is_n {
                        on_n += 1;
                    } else {
                        on_p += 1;
                    }
                    "on"
                } else {
                    match tangents(xr, xc) {
                        2 => {
                            if is_n {
                                ext_n += 1;
                            } else {
                                ext_p += 1;
                            }
                            "ext"
                        }
                        0 => {
                            if is_n {
                                int_n += 1;
                            } else {
                                int_p += 1;
                            }
                            "int"
                        }
                        t => {
                            anom += 1;
                            println!("!! q={} cls={} x={},{} tangents={} (expected 0/2)", q, ci, xr, xc, t);
                            sane = false;
                            "anom"
                        }
                    }
                };
                println!(
                    "X q={} cls={} x={},{} val={} pos={}",
                    q,
                    ci,
                    xr,
                    xc,
                    if is_n { "N" } else { "P" },
                    pos
                );
            }
        }
        let escape = on_p + ext_p + int_p;
        let bad = on_n + ext_n + int_n + anom; // anom counted nowhere else; must be 0
        let legal_on = on_p + on_n;
        if legal_on != q - 4 {
            println!("!! q={} cls={} legal_on={} (expected q-4={})", q, ci, legal_on, q - 4);
            sane = false;
        }
        println!(
            "CLS q={} cls={} S3={:?} escape={} bad={} onP={} onN={} extP={} extN={} intP={} intN={}",
            q, ci, cells, escape, bad, on_p, on_n, ext_p, ext_n, int_p, int_n
        );
    }
    println!(
        "FEAT-SUMMARY q={} root={} size3-classes={} sanity={}",
        q,
        if root_n { "N (COUNTEREXAMPLE!)" } else { "P" },
        frontier.len(),
        if sane { "OK" } else { "FAIL" }
    );
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

// ---- CERT mode: per-size-3-class escape certificate emitter (route C, phase 1) ----
// (2026-07-07 codex task queue C12.)  For each canonical size-3 class S3, emit:
//   * the class representative S3 (3 cells),
//   * one witness escape cell p (a P size-4 child of S3; prefer an ON-conic p, record on/off),
//   * a full P-reply-book of the size-4 P-position S4 = insert p S3: the responder's winning
//     strategy as a DAG over ACTUAL positions.  Every book node is an even P-position; for each
//     node, every legal mover move x is answered by a reply y whose grandchild P+x+y is again a
//     book node (a P-position), down to even terminals (maximal caps, no legal move).
// This is exactly the shape of FiniteBuildGame.PairReplyBook / PCert in lean/CapGame/BuildGame.lean:
// isP_of_replyStrategy with Good = "position is a book node" discharges IsP for S4 (terminals
// satisfy the reply obligation vacuously; sizes strictly grow => well-founded), and the recursive
// PairReplyBook/PCert reading is covered by the explicit per-node rows + terminal parity lines.
// Game values (needed only to PICK the P replies + count escapes) use a PRIVATE per-class canon memo
// dropped after the class (esc-mode substrate); the emitted book + certcheck use game RULES only.

// reconstruct (chosen, forbidden) masks from a cell set (game RULES: partial-permutation + affine
// cap).  Order-independent: chosen = the cells; forbidden = union of rc_mask over cells + line_mask
// over unordered pairs (line_mask is symmetric).  avail = all & !chosen & !forbidden = legal moves.
fn masks_of(b: &Board, cells: &[u16]) -> (Mask, Mask) {
    let mut chosen = [0u64; MAXW];
    let mut forb = [0u64; MAXW];
    for &c in cells {
        set_bit(&mut chosen, c as usize);
    }
    for i in 0..cells.len() {
        let ci = cells[i] as usize;
        mask_or(&mut forb, &b.rc_mask[ci]);
        for j in (i + 1)..cells.len() {
            let cj = cells[j] as usize;
            mask_or(&mut forb, &b.line_mask[ci * b.n + cj]);
        }
    }
    (chosen, forb)
}

// legal moves (ascending cell index) from a position given its masks.
fn avail_cells(b: &Board, chosen: &Mask, forb: &Mask) -> Vec<u16> {
    let mut out = Vec::new();
    for w in 0..MAXW {
        let mut bits = b.all[w] & !chosen[w] & !forb[w];
        while bits != 0 {
            let tz = bits.trailing_zeros() as usize;
            bits &= bits - 1;
            out.push((w * 64 + tz) as u16);
        }
    }
    out
}

// is `cells` a legal grid position (partial-permutation affine cap)?  Adds cells in the given order
// and checks each is available given the earlier ones (a set property, so order is irrelevant).
fn is_legal_position(b: &Board, cells: &[u16]) -> bool {
    let mut cur: Vec<u16> = Vec::new();
    for &c in cells {
        let cu = c as usize;
        if cu >= b.n {
            return false;
        }
        let (chosen, forb) = masks_of(b, &cur);
        if (chosen[cu >> 6] & (1u64 << (cu & 63))) != 0 {
            return false; // duplicate cell
        }
        if (forb[cu >> 6] & (1u64 << (cu & 63))) != 0 {
            return false; // shares a row/col or completes a collinear triple
        }
        cur.push(c);
    }
    true
}

// fit the unique conic through S3 (+ the two burned direction points): F(r,c)=rc+eps*r+zeta*c+gamma,
// on-conic <=> F==0.  Same Gaussian elimination as feat mode (odd q; all cert q are odd).
fn fit_conic(b: &Board, cells: &[(usize, usize)]) -> (usize, usize, usize) {
    let gf = &b.gf;
    let mut m: [[usize; 4]; 3] = [[0; 4]; 3];
    for i in 0..3 {
        let (r, c) = cells[i];
        m[i] = [r, c, 1, gf.neg[gf.m(r, c)] as usize];
    }
    for col in 0..3 {
        let piv = (col..3).find(|&i| m[i][col] != 0).expect("singular conic fit (S3 collinear?)");
        m.swap(col, piv);
        let inv = gf.inv[m[col][col]] as usize;
        for j in col..4 {
            m[col][j] = gf.m(inv, m[col][j]);
        }
        for i in 0..3 {
            if i != col && m[i][col] != 0 {
                let f = m[i][col];
                for j in col..4 {
                    m[i][j] = gf.sub(m[i][j], gf.m(f, m[col][j]));
                }
            }
        }
    }
    (m[0][3], m[1][3], m[2][3])
}

fn fmt_cells(cells: &[(usize, usize)]) -> String {
    cells.iter().map(|&(r, c)| format!("{},{}", r, c)).collect::<Vec<_>>().join(" ")
}

impl<'a> Solver<'a> {
    // game value of an arbitrary legal position given as a cell list (early-break; canon-memoized).
    fn value_cells(&mut self, cells: &[u16]) -> bool {
        let (chosen, forb) = masks_of(self.b, cells);
        let mut occ = cells.to_vec();
        self.g(&mut occ, &chosen, &forb)
    }
}

// the responder P-certificate as a DAG over actual positions.
struct CertBook {
    cells: Vec<Vec<u16>>,             // node id -> sorted cell list (an even P-position)
    rows: Vec<Vec<(u16, u16, u32)>>,  // node id -> [(mover move, reply, child node id)]
    terminal: Vec<bool>,             // node id -> no legal move (even maximal cap)
    index: HashMap<Vec<u16>, u32>,    // sorted cells -> node id
}
impl CertBook {
    fn new() -> CertBook {
        CertBook { cells: Vec::new(), rows: Vec::new(), terminal: Vec::new(), index: HashMap::new() }
    }
    fn get_or_add(&mut self, cells: Vec<u16>) -> (u32, bool) {
        if let Some(&id) = self.index.get(&cells) {
            return (id, false);
        }
        let id = self.cells.len() as u32;
        self.index.insert(cells.clone(), id);
        self.cells.push(cells);
        self.rows.push(Vec::new());
        self.terminal.push(false);
        (id, true)
    }
}

// build the responder strategy DAG from a size-4 P-position `root_cells`.  Every node processed is a
// P-position: it enumerates ALL mover moves x (closure), answers each with the lowest reply y whose
// grandchild is a P-position (exists because a P-position's children are all N), and recurses on that
// P grandchild.  Terminal = a P-node with no legal move.  Returns None if node count exceeds `cap`.
fn build_book(b: &Board, s: &mut Solver, root_cells: &[u16], cap: usize) -> Option<CertBook> {
    let mut book = CertBook::new();
    let mut root = root_cells.to_vec();
    root.sort_unstable();
    let (root_id, _) = book.get_or_add(root);
    let mut stack: Vec<u32> = vec![root_id];
    while let Some(id) = stack.pop() {
        if book.cells.len() > cap {
            return None;
        }
        let cells = book.cells[id as usize].clone();
        let (chosen, forb) = masks_of(b, &cells);
        let moves = avail_cells(b, &chosen, &forb);
        if moves.is_empty() {
            book.terminal[id as usize] = true; // even maximal cap (all book nodes are even)
            continue;
        }
        for x in moves {
            let mut px = cells.clone();
            px.push(x);
            px.sort_unstable();
            let (chx, fx) = masks_of(b, &px);
            let ys = avail_cells(b, &chx, &fx);
            let mut reply: Option<(u16, Vec<u16>)> = None;
            for y in ys {
                let mut pxy = px.clone();
                pxy.push(y);
                pxy.sort_unstable();
                if !s.value_cells(&pxy) {
                    reply = Some((y, pxy)); // P grandchild = a valid reply
                    break;
                }
            }
            let (y, pxy) = reply
                .expect("P-position node has a mover move with no P-reply (root was not P?)");
            let (cid, isnew) = book.get_or_add(pxy);
            book.rows[id as usize].push((x, y, cid));
            if isnew {
                stack.push(cid);
                if book.cells.len() > cap {
                    return None;
                }
            }
        }
    }
    Some(book)
}

// cert <q> [--out <dir>] [--bookcap <nodes>] [class-index...]
fn solve_cert(q: usize, filter: &[usize], outdir: &str, bookcap: usize) {
    let b = Board::new(q);
    let empty = [0u64; MAXW];
    // canonical size-3 classes (same enumerate/order as escape/esc modes -> stable class indices)
    let mut frontier: Vec<(Vec<u16>, Mask, Mask)> = Vec::new();
    {
        let mut visited: HashSet<u128> = HashSet::new();
        let mut occ3: Vec<u16> = Vec::new();
        enumerate(&b, 3, &mut occ3, &empty, &empty, &mut visited, &mut frontier);
    }
    let ncls = frontier.len();
    let total_expected = (q * q + 21).wrapping_sub(9 * q); // q^2 - 9q + 21 (total lemma)
    std::fs::create_dir_all(outdir).expect("create cert output dir");
    let path = format!("{}/gridcap-q{}.cert", outdir, q);
    let mut w = BufWriter::new(std::fs::File::create(&path).expect("create cert file"));
    writeln!(w, "# gridcap-escape-certificate v1").unwrap();
    writeln!(w, "q {}", q).unwrap();
    if is_prime(q) {
        writeln!(w, "field prime").unwrap();
    } else {
        let (p, poly) = irred(q);
        let coeffs: Vec<String> = poly.iter().map(|c| c.to_string()).collect();
        // poly coeffs are [c0..c_{k-1}, 1] (monic) over F_p; e.g. q=9 -> "1 0 1" = x^2+1 over F_3
        writeln!(w, "field GF{} base {} poly {}", q, p, coeffs.join(" ")).unwrap();
    }
    writeln!(w, "classes {}", ncls).unwrap();
    writeln!(w, "total {}", total_expected).unwrap();
    writeln!(w, "# grammar (one record per line; tokens space-separated; cells are r,c 0-based):").unwrap();
    writeln!(w, "#   CLASS <ci> s3 r,c r,c r,c escape <e> witness <r,c|none> onconic <0|1|-> book <ok|capped|none> nodes <N> rows <R> terms <T>").unwrap();
    writeln!(w, "#   N <ci> <nid> r,c ...              node <nid> of class <ci> = even P-position (sorted cells); node 0 = witness position S3+p").unwrap();
    writeln!(w, "#   R <ci> <nid> <mr,mc> <yr,yc> <cid>  from node <nid>: mover move (mr,mc), reply (yr,yc) -> child node <cid> = this node + {{move,reply}}").unwrap();
    writeln!(w, "#   T <ci> <nid>                       node <nid> is terminal (no legal move; even size)").unwrap();

    let selected: Vec<usize> = if filter.is_empty() { (0..ncls).collect() } else { filter.to_vec() };
    let mut hist: std::collections::BTreeMap<usize, u64> = std::collections::BTreeMap::new();
    let mut onc_yes = 0u64;
    let mut onc_no = 0u64;
    let mut capped = 0u64;
    let mut min_esc = usize::MAX;
    let mut max_esc = 0usize;
    let mut even_esc = 0u64;
    let start = Instant::now();

    for &ci in &selected {
        if ci >= ncls {
            eprintln!("cert: class index {} out of range ({} classes)", ci, ncls);
            continue;
        }
        let (occ0, chosen, forbidden) = &frontier[ci];
        let s3_cells: Vec<(usize, usize)> =
            occ0.iter().map(|&z| (z as usize / q, z as usize % q)).collect();
        // private per-class value memo (dropped at loop end), early-break value function
        let mut solver = Solver {
            b: &b,
            memo: FnvMap::default(),
            full: false,
            min_dev: usize::MAX,
            odd_max: 0,
            odd_max_min: usize::MAX,
            dev_even_n: 0,
            dev_odd_p: 0,
        };
        let (eps, zeta, gamma) = fit_conic(&b, &s3_cells);
        let gf = &b.gf;
        let on_conic = |z: usize| -> bool {
            let (r, c) = (z / q, z % q);
            gf.a(gf.a(gf.m(r, c), gf.m(eps, r)), gf.a(gf.m(zeta, c), gamma)) == 0
        };
        // value every legal size-4 child -> escape count + witness candidates (prefer on-conic P)
        let mut avail = [0u64; MAXW];
        for i in 0..MAXW {
            avail[i] = b.all[i] & !chosen[i] & !forbidden[i];
        }
        let mut n_tot = 0usize;
        let mut n_p = 0usize;
        let mut wit_on: Option<u16> = None;
        let mut wit_off: Option<u16> = None;
        for wi in 0..MAXW {
            let mut bits = avail[wi];
            while bits != 0 {
                let tz = bits.trailing_zeros() as usize;
                bits &= bits - 1;
                let z = wi * 64 + tz;
                n_tot += 1;
                let mut child = occ0.clone();
                child.push(z as u16);
                child.sort_unstable();
                if !solver.value_cells(&child) {
                    n_p += 1; // P child = an escape
                    if on_conic(z) {
                        if wit_on.is_none() {
                            wit_on = Some(z as u16);
                        }
                    } else if wit_off.is_none() {
                        wit_off = Some(z as u16);
                    }
                }
            }
        }
        let escape = n_p;
        if escape < min_esc {
            min_esc = escape;
        }
        if escape > max_esc {
            max_esc = escape;
        }
        if escape % 2 == 0 {
            even_esc += 1;
        }
        *hist.entry(escape).or_insert(0) += 1;
        if n_tot != total_expected {
            eprintln!("cert q={} cls={}: total {} != q^2-9q+21 {} (!!)", q, ci, n_tot, total_expected);
        }

        let (witness, onc) = match (wit_on, wit_off) {
            (Some(z), _) => (z, true),
            (None, Some(z)) => (z, false),
            (None, None) => {
                eprintln!("cert q={} cls={}: escape=0 (no P size-4 child) — (ESC) FAILS here!", q, ci);
                writeln!(
                    w,
                    "CLASS {} s3 {} escape 0 witness none onconic - book none nodes 0 rows 0 terms 0",
                    ci,
                    fmt_cells(&s3_cells)
                )
                .unwrap();
                continue;
            }
        };
        if onc {
            onc_yes += 1;
        } else {
            onc_no += 1;
        }
        let (wr, wc) = (witness as usize / q, witness as usize % q);

        // build the reply book from S4 = S3 + witness (reusing the warmed private value memo)
        let mut root = occ0.clone();
        root.push(witness);
        root.sort_unstable();
        match build_book(&b, &mut solver, &root, bookcap) {
            None => {
                capped += 1;
                writeln!(
                    w,
                    "CLASS {} s3 {} escape {} witness {},{} onconic {} book capped nodes 0 rows 0 terms 0",
                    ci, fmt_cells(&s3_cells), escape, wr, wc, if onc { 1 } else { 0 }
                )
                .unwrap();
                eprintln!(
                    "  [cert q={} {:6.1}s] class {} CAPPED (book > {} nodes)",
                    q, start.elapsed().as_secs_f64(), ci, bookcap
                );
            }
            Some(bk) => {
                let nnodes = bk.cells.len();
                let nrows: usize = bk.rows.iter().map(|r| r.len()).sum();
                let nterm = bk.terminal.iter().filter(|&&t| t).count();
                writeln!(
                    w,
                    "CLASS {} s3 {} escape {} witness {},{} onconic {} book ok nodes {} rows {} terms {}",
                    ci, fmt_cells(&s3_cells), escape, wr, wc, if onc { 1 } else { 0 }, nnodes, nrows, nterm
                )
                .unwrap();
                for (nid, cells) in bk.cells.iter().enumerate() {
                    let cs: Vec<String> = cells
                        .iter()
                        .map(|&z| format!("{},{}", z as usize / q, z as usize % q))
                        .collect();
                    writeln!(w, "N {} {} {}", ci, nid, cs.join(" ")).unwrap();
                }
                for nid in 0..bk.cells.len() {
                    if bk.terminal[nid] {
                        writeln!(w, "T {} {}", ci, nid).unwrap();
                    } else {
                        for &(x, y, cid) in &bk.rows[nid] {
                            writeln!(
                                w,
                                "R {} {} {},{} {},{} {}",
                                ci, nid,
                                x as usize / q, x as usize % q,
                                y as usize / q, y as usize % q,
                                cid
                            )
                            .unwrap();
                        }
                    }
                }
                eprintln!(
                    "  [cert q={} {:6.1}s] class {}/{}: escape={} witness=({},{}) onconic={} book nodes={} rows={} terms={}",
                    q, start.elapsed().as_secs_f64(), ci, ncls - 1, escape, wr, wc, onc, nnodes, nrows, nterm
                );
            }
        }
        w.flush().ok();
    }

    let hs: Vec<String> = hist.iter().map(|(k, v)| format!("{}:{}", k, v)).collect();
    writeln!(
        w,
        "# END classes={} onconic-witness={} offconic-witness={} capped-books={}",
        selected.len(), onc_yes, onc_no, capped
    )
    .unwrap();
    w.flush().unwrap();

    // escape summary to stdout (cross-check vs escape/esc mode: same summary+histogram format).
    if filter.is_empty() {
        let root_n = min_esc == 0;
        let outcome = if root_n { "N (COUNTEREXAMPLE!)" } else { "P" };
        let parity_ok = even_esc == 0;
        println!(
            "q={:>3}  root={}  size3-classes={}  total(q^2-9q+21)={}  min-escape={}  max-escape={}  \
             bad-odd(even-escape) classes={}/{}  parity-proof={}",
            q, outcome, ncls, total_expected,
            if min_esc == usize::MAX { 0 } else { min_esc }, max_esc,
            even_esc, ncls, if parity_ok { "HOLDS (all bad even)" } else { "BREAKS" },
        );
        println!("      escape-histogram (escape:classes) = {}", hs.join(" "));
        println!(
            "      cert witnesses: on-conic={} off-conic={} capped-books={}  [{:.1}s]",
            onc_yes, onc_no, capped, start.elapsed().as_secs_f64()
        );
    } else {
        println!(
            "q={:>3}  cert PARTIAL classes={} on-conic={} off-conic={} capped-books={}  [{:.1}s]",
            q, selected.len(), onc_yes, onc_no, capped, start.elapsed().as_secs_f64()
        );
    }
    println!("wrote {}", path);
}

// ---- CERTCHECK mode: independent rules-only re-verification of a .cert file ----
struct NodeTab {
    cells: HashMap<u32, Vec<u16>>,
    rows: HashMap<u32, Vec<(u16, u16, u32)>>,
    terms: HashSet<u32>,
}
struct ClassData {
    ci: usize,
    s3: Vec<u16>,
    witness: Option<u16>,
    onconic: Option<bool>,
    status: String,
    decl_nodes: usize,
    decl_rows: usize,
    decl_terms: usize,
    tab: NodeTab,
}

fn parse_cell(tok: &str, q: usize) -> u16 {
    let (r, c) = tok.split_once(',').expect("bad cell token (want r,c)");
    let r: usize = r.parse().expect("bad row");
    let c: usize = c.parse().expect("bad col");
    (r * q + c) as u16
}

// verify one `book ok` class against GAME RULES ONLY.  Returns (nodes,rows,terms) or an error reason.
#[allow(clippy::too_many_arguments)]
fn verify_class(b: &Board, q: usize, cd: &ClassData) -> Result<(usize, usize, usize), String> {
    let ci = cd.ci;
    let witness = cd.witness.ok_or_else(|| format!("class {}: book ok but no witness", ci))?;
    // node 0 must be the witness position S3 + p, and a legal 4-cap
    let mut root: Vec<u16> = cd.s3.to_vec();
    root.push(witness);
    root.sort_unstable();
    let node0 = cd.tab.cells.get(&0).ok_or_else(|| format!("class {}: missing node 0", ci))?;
    if *node0 != root {
        return Err(format!("class {}: node0 {:?} != sorted(S3+witness) {:?}", ci, node0, root));
    }
    if !is_legal_position(b, &root) {
        return Err(format!("class {}: witness position is not a legal cap", ci));
    }
    // onconic flag vs conic geometry (rules/geometry, not game values)
    if let Some(oc) = cd.onconic {
        let s3c: Vec<(usize, usize)> = cd.s3.iter().map(|&z| (z as usize / q, z as usize % q)).collect();
        let (eps, zeta, gamma) = fit_conic(b, &s3c);
        let (wr, wc) = (witness as usize / q, witness as usize % q);
        let onc = b.gf.a(b.gf.a(b.gf.m(wr, wc), b.gf.m(eps, wr)), b.gf.a(b.gf.m(zeta, wc), gamma)) == 0;
        if onc != oc {
            return Err(format!("class {}: onconic flag {} != geometry {}", ci, oc, onc));
        }
    }
    let mut nnodes = 0usize;
    let mut nrows = 0usize;
    let mut nterm = 0usize;
    for (&nid, cells) in cd.tab.cells.iter() {
        nnodes += 1;
        if cells.len() % 2 != 0 {
            return Err(format!("class {} node {}: odd size {}", ci, nid, cells.len()));
        }
        let (chosen, forb) = masks_of(b, cells);
        let avail = avail_cells(b, &chosen, &forb);
        let is_term = cd.tab.terms.contains(&nid);
        let node_rows = cd.tab.rows.get(&nid).cloned().unwrap_or_default();
        if is_term {
            nterm += 1;
            if !avail.is_empty() {
                return Err(format!("class {} node {}: TERM but has {} legal moves", ci, nid, avail.len()));
            }
            if !node_rows.is_empty() {
                return Err(format!("class {} node {}: TERM but has reply rows", ci, nid));
            }
        } else {
            if avail.is_empty() {
                return Err(format!("class {} node {}: no legal moves but not marked TERM", ci, nid));
            }
            // closure: the rows' mover moves == the legal moves exactly (each once, none missing/extra)
            let mut rx: Vec<u16> = node_rows.iter().map(|&(x, _, _)| x).collect();
            rx.sort_unstable();
            let mut av = avail.clone();
            av.sort_unstable();
            if rx != av {
                return Err(format!(
                    "class {} node {}: reply-book moves {:?} != legal moves {:?} (closure)",
                    ci, nid, rx, av
                ));
            }
            for &(x, y, cid) in &node_rows {
                nrows += 1;
                let mut px = cells.clone();
                px.push(x);
                px.sort_unstable();
                let (chx, fx) = masks_of(b, &px);
                let yu = y as usize;
                if (chx[yu >> 6] & (1u64 << (yu & 63))) != 0 || (fx[yu >> 6] & (1u64 << (yu & 63))) != 0 {
                    return Err(format!("class {} node {}: reply {} illegal after move {}", ci, nid, y, x));
                }
                let mut pxy = px.clone();
                pxy.push(y);
                pxy.sort_unstable();
                let child = cd
                    .tab
                    .cells
                    .get(&cid)
                    .ok_or_else(|| format!("class {} node {}: child node {} undefined", ci, nid, cid))?;
                if *child != pxy {
                    return Err(format!(
                        "class {} node {}: child {} = {:?} != P+move+reply {:?}",
                        ci, nid, cid, child, pxy
                    ));
                }
                if child.len() != cells.len() + 2 {
                    return Err(format!("class {} node {}: child size {} != {}", ci, nid, child.len(), cells.len() + 2));
                }
            }
        }
    }
    if nnodes != cd.decl_nodes || nrows != cd.decl_rows || nterm != cd.decl_terms {
        return Err(format!(
            "class {}: declared (nodes {} rows {} terms {}) != actual (nodes {} rows {} terms {})",
            ci, cd.decl_nodes, cd.decl_rows, cd.decl_terms, nnodes, nrows, nterm
        ));
    }
    Ok((nnodes, nrows, nterm))
}

fn check_cert(q_expect: usize, path: &str) {
    let text = std::fs::read_to_string(path).expect("read cert file");
    let mut q: usize = 0;
    let mut declared_classes = 0usize;
    let mut classes: Vec<ClassData> = Vec::new();
    for line in text.lines() {
        let line = line.trim();
        if line.is_empty() || line.starts_with('#') {
            continue;
        }
        let tok: Vec<&str> = line.split_whitespace().collect();
        match tok[0] {
            "q" => q = tok[1].parse().expect("q"),
            "field" | "total" => {}
            "classes" => declared_classes = tok[1].parse().expect("classes"),
            "CLASS" => {
                // CLASS ci s3 c c c escape e witness w onconic oc book status nodes N rows R terms T
                let ci: usize = tok[1].parse().expect("CLASS ci");
                assert_eq!(tok[2], "s3", "CLASS layout");
                let s3 = vec![parse_cell(tok[3], q), parse_cell(tok[4], q), parse_cell(tok[5], q)];
                assert_eq!(tok[8], "witness", "CLASS layout");
                let witness = if tok[9] == "none" { None } else { Some(parse_cell(tok[9], q)) };
                let onconic = match tok[11] {
                    "1" => Some(true),
                    "0" => Some(false),
                    _ => None,
                };
                let status = tok[13].to_string();
                let decl_nodes: usize = tok[15].parse().expect("nodes");
                let decl_rows: usize = tok[17].parse().expect("rows");
                let decl_terms: usize = tok[19].parse().expect("terms");
                classes.push(ClassData {
                    ci, s3, witness, onconic, status, decl_nodes, decl_rows, decl_terms,
                    tab: NodeTab { cells: HashMap::new(), rows: HashMap::new(), terms: HashSet::new() },
                });
            }
            "N" => {
                let nid: u32 = tok[2].parse().expect("N nid");
                let mut cs: Vec<u16> = tok[3..].iter().map(|t| parse_cell(t, q)).collect();
                cs.sort_unstable();
                classes.last_mut().expect("N before CLASS").tab.cells.insert(nid, cs);
            }
            "R" => {
                let nid: u32 = tok[2].parse().expect("R nid");
                let x = parse_cell(tok[3], q);
                let y = parse_cell(tok[4], q);
                let cid: u32 = tok[5].parse().expect("R cid");
                classes.last_mut().expect("R before CLASS").tab.rows.entry(nid).or_default().push((x, y, cid));
            }
            "T" => {
                let nid: u32 = tok[2].parse().expect("T nid");
                classes.last_mut().expect("T before CLASS").tab.terms.insert(nid);
            }
            other => eprintln!("certcheck: ignoring unknown line kind '{}'", other),
        }
    }
    if q_expect != 0 && q != q_expect {
        println!("certcheck RESULT: FAIL — header q={} != requested q={}", q, q_expect);
        return;
    }
    let b = Board::new(q);
    let mut n_pass = 0usize;
    let mut n_fail = 0usize;
    let mut n_skip = 0usize;
    let mut tot_nodes = 0usize;
    let mut tot_rows = 0usize;
    let mut tot_terms = 0usize;
    let mut fails: Vec<String> = Vec::new();
    for cd in &classes {
        if cd.status != "ok" {
            n_skip += 1; // capped / none: no book to verify
            continue;
        }
        match verify_class(&b, q, cd) {
            Ok((nn, nr, nt)) => {
                n_pass += 1;
                tot_nodes += nn;
                tot_rows += nr;
                tot_terms += nt;
            }
            Err(e) => {
                n_fail += 1;
                fails.push(e);
            }
        }
    }
    println!(
        "certcheck q={} file={}  classes(parsed)={} declared={}  PASS={} FAIL={} SKIP(capped/none)={}  nodes={} rows={} terms={}",
        q, path, classes.len(), declared_classes, n_pass, n_fail, n_skip, tot_nodes, tot_rows, tot_terms
    );
    for f in &fails {
        println!("  FAIL: {}", f);
    }
    println!("certcheck RESULT: {}", if n_fail == 0 { "PASS" } else { "FAIL" });
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
    if args[1] == "esc" {
        // esc <q> [--cap <slots>] [class-index...]
        let mut cap: usize = usize::MAX;
        let mut positional: Vec<usize> = Vec::new();
        let mut it = args[2..].iter();
        while let Some(a) = it.next() {
            if a == "--cap" {
                let v = it.next().expect("--cap needs a value");
                cap = v.parse().expect("--cap value must be an integer");
            } else if let Some(rest) = a.strip_prefix("--cap=") {
                cap = rest.parse().expect("--cap value must be an integer");
            } else {
                positional.push(a.parse().expect("q / class-index must be an integer"));
            }
        }
        let q = *positional.first().expect("esc mode needs q: esc <q> [--cap <slots>] [class-index...]");
        let filter: Vec<usize> = positional[1..].to_vec();
        solve_esc(q, &filter, cap);
        return;
    }
    if args[1] == "feat" {
        for a in &args[2..] {
            let q: usize = a.parse().expect("q must be an integer");
            solve_feat(q);
        }
        return;
    }
    if args[1] == "cert" {
        // cert <q> [--out <dir>] [--bookcap <nodes>] [class-index...]
        let mut outdir = "certs".to_string();
        let mut bookcap: usize = usize::MAX;
        let mut positional: Vec<usize> = Vec::new();
        let mut it = args[2..].iter();
        while let Some(a) = it.next() {
            if a == "--out" {
                outdir = it.next().expect("--out needs a value").clone();
            } else if let Some(rest) = a.strip_prefix("--out=") {
                outdir = rest.to_string();
            } else if a == "--bookcap" {
                bookcap = it.next().expect("--bookcap needs a value").parse().expect("--bookcap int");
            } else if let Some(rest) = a.strip_prefix("--bookcap=") {
                bookcap = rest.parse().expect("--bookcap int");
            } else {
                positional.push(a.parse().expect("q / class-index must be an integer"));
            }
        }
        let q = *positional.first().expect("cert mode needs q: cert <q> [--out <dir>] [--bookcap <nodes>] [class-index...]");
        let filter: Vec<usize> = positional[1..].to_vec();
        solve_cert(q, &filter, &outdir, bookcap);
        return;
    }
    if args[1] == "certcheck" {
        // certcheck <q> <file>   (q cross-checked against the file header)
        let q: usize = args[2].parse().expect("certcheck needs q: certcheck <q> <file>");
        let file = args.get(3).expect("certcheck needs a file: certcheck <q> <file>");
        check_cert(q, file);
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
