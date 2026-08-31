//! C1018 — exact deep-hole / covering-radius census for projective Reed–Solomon codes.
//!
//! For `PRS_k(q)` of length `n = q+1`, redundancy `r = n-k`, set `d = r-1`.  A
//! parity-check matrix has as columns the normal rational curve (NRC)
//! `P_a = (1,a,…,a^d)` (`a ∈ F_q`) together with `P_∞ = (0,…,0,1)` in
//! `PG(d,q)`.  The weight of the coset with syndrome `s` is
//!
//! ```text
//! w(s) = min { |T| : s ∈ span{ P_t : t ∈ T } }  ≤  d+1 = r,
//! ```
//!
//! and `w(s) ≤ j` holds iff the Hankel matrix `H^{(j)}_s = (s_{u+v})` of size
//! `(d-j+1)×(j+1)` annihilates some degree-`j` binary form with `j` distinct
//! roots in `PG(1,q)`.  The covering radius is `max_s w(s)` and the deep holes
//! are the attainers.
//!
//! The census enumerates `PGL(2,q)` (optionally `PΓL(2,q)`) orbits on
//! `PG(d,q)` by breadth-first closure over generators, evaluates `w` exactly at
//! one representative per orbit, and emits a compact JSON summary.
//!
//! Ergodis is used for the independent rank cross-check of the Hankel kernels
//! over prime fields (`ergodis::matrix::Matrix::canonical_row_basis_field`).

use std::collections::VecDeque;
use std::fmt::Write as _;

use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis::field::Prime;
use ergodis::matrix::Matrix;

#[derive(Parser, Debug)]
#[command(about = "Exact PRS deep-hole census via normal-rational-curve rank in PG(d,q)")]
struct Args {
    /// Field order (prime power, <= 251).
    #[arg(long)]
    q: usize,
    /// Redundancy r = n - k.  Ambient projective dimension is d = r-1.
    #[arg(long)]
    r: usize,
    /// Fuse Frobenius into the group (PGammaL instead of PGL).
    #[arg(long, default_value_t = false)]
    semilinear: bool,
    /// Cross-check every representative's Hankel ranks against Ergodis (prime q only).
    #[arg(long, default_value_t = false)]
    ergodis_crosscheck: bool,
    /// Output JSON path.
    #[arg(long)]
    out: Option<String>,
    /// Maximum number of top-weight orbit representatives to print in JSON.
    #[arg(long, default_value_t = 64)]
    max_reps: usize,
}

// ---------------------------------------------------------------------------
// finite field GF(p^h), elements are indices 0..q-1 encoding base-p digit
// vectors of the polynomial representation.
// ---------------------------------------------------------------------------

struct Field {
    p: usize,
    h: usize,
    q: usize,
    poly: Vec<usize>, // defining monic irreducible, low coefficients c_0..c_{h-1}
    add: Vec<u8>,
    mul: Vec<u8>,
    inv: Vec<u8>,
    neg: Vec<u8>,
}

fn poly_rem(a: &[usize], b: &[usize], p: usize) -> Vec<usize> {
    // b monic
    let mut a = a.to_vec();
    let db = b.len() - 1;
    while a.len() > db {
        let da = a.len() - 1;
        let c = a[da];
        if c != 0 {
            for i in 0..=db {
                a[da - db + i] = (a[da - db + i] + p - (c * b[i]) % p) % p;
            }
        }
        a.pop();
    }
    while a.len() > 1 && *a.last().unwrap() == 0 {
        a.pop();
    }
    a
}

fn is_irreducible(f: &[usize], p: usize) -> bool {
    let h = f.len() - 1;
    for m in 1..=(h / 2) {
        // enumerate monic polys of degree m
        let count = p.pow(m as u32);
        for code in 0..count {
            let mut g = vec![0usize; m + 1];
            g[m] = 1;
            let mut c = code;
            for item in g.iter_mut().take(m) {
                *item = c % p;
                c /= p;
            }
            let rem = poly_rem(f, &g, p);
            if rem.len() == 1 && rem[0] == 0 {
                return false;
            }
        }
    }
    true
}

fn find_irreducible(p: usize, h: usize) -> Vec<usize> {
    if h == 1 {
        return vec![0, 1];
    }
    let count = p.pow(h as u32);
    for code in 0..count {
        let mut f = vec![0usize; h + 1];
        f[h] = 1;
        let mut c = code;
        for item in f.iter_mut().take(h) {
            *item = c % p;
            c /= p;
        }
        if is_irreducible(&f, p) {
            return f;
        }
    }
    unreachable!("no irreducible polynomial found")
}

impl Field {
    fn new(q: usize) -> Result<Self> {
        let (p, h) = factor_prime_power(q).context("q must be a prime power")?;
        if q > 251 {
            bail!("q must be at most 251 (u8 element encoding)");
        }
        let f = find_irreducible(p, h);
        let digits = |mut x: usize| -> Vec<usize> {
            let mut v = vec![0usize; h];
            for item in v.iter_mut() {
                *item = x % p;
                x /= p;
            }
            v
        };
        let pack = |v: &[usize]| -> usize {
            let mut x = 0usize;
            for i in (0..h).rev() {
                x = x * p + v[i] % p;
            }
            x
        };
        let mut add = vec![0u8; q * q];
        for a in 0..q {
            let da = digits(a);
            for b in 0..q {
                let db = digits(b);
                let s: Vec<usize> = (0..h).map(|i| (da[i] + db[i]) % p).collect();
                add[a * q + b] = pack(&s) as u8;
            }
        }
        let mut mul = vec![0u8; q * q];
        for a in 0..q {
            let da = digits(a);
            for b in 0..q {
                let db = digits(b);
                let mut prod = vec![0usize; 2 * h];
                for i in 0..h {
                    if da[i] == 0 {
                        continue;
                    }
                    for j in 0..h {
                        prod[i + j] = (prod[i + j] + da[i] * db[j]) % p;
                    }
                }
                while prod.len() > 1 && *prod.last().unwrap() == 0 {
                    prod.pop();
                }
                let rem = poly_rem(&prod, &f, p);
                let mut v = vec![0usize; h];
                for (i, item) in rem.iter().enumerate() {
                    if i < h {
                        v[i] = *item;
                    }
                }
                mul[a * q + b] = pack(&v) as u8;
            }
        }
        let mut inv = vec![0u8; q];
        for a in 1..q {
            for b in 1..q {
                if mul[a * q + b] == 1 {
                    inv[a] = b as u8;
                    break;
                }
            }
            if inv[a] == 0 {
                bail!("field construction failed: {a} has no inverse in GF({q})");
            }
        }
        let mut neg = vec![0u8; q];
        for a in 0..q {
            for b in 0..q {
                if add[a * q + b] == 0 {
                    neg[a] = b as u8;
                    break;
                }
            }
        }
        Ok(Self {
            p,
            h,
            q,
            poly: f,
            add,
            mul,
            inv,
            neg,
        })
    }

    #[inline(always)]
    fn a(&self, x: u8, y: u8) -> u8 {
        self.add[x as usize * self.q + y as usize]
    }
    #[inline(always)]
    fn m(&self, x: u8, y: u8) -> u8 {
        self.mul[x as usize * self.q + y as usize]
    }
    #[inline(always)]
    fn n(&self, x: u8) -> u8 {
        self.neg[x as usize]
    }
    #[inline(always)]
    fn i(&self, x: u8) -> u8 {
        self.inv[x as usize]
    }
    fn pow(&self, x: u8, e: usize) -> u8 {
        let mut acc = 1u8;
        for _ in 0..e {
            acc = self.m(acc, x);
        }
        acc
    }
    /// embed an integer of Z into F_q (image of the prime field)
    fn from_int(&self, v: usize) -> u8 {
        (v % self.p) as u8
    }
    fn primitive(&self) -> u8 {
        for g in 2..self.q as u8 {
            let mut x = g;
            let mut ord = 1usize;
            while x != 1 {
                x = self.m(x, g);
                ord += 1;
            }
            if ord == self.q - 1 {
                return g;
            }
        }
        // q = 2 or 3
        (self.q - 1) as u8
    }
}

fn factor_prime_power(q: usize) -> Option<(usize, usize)> {
    if q < 2 {
        return None;
    }
    let mut p = 2usize;
    while p * p <= q {
        if q % p == 0 {
            break;
        }
        p += 1;
    }
    if p * p > q {
        return Some((q, 1));
    }
    let mut h = 0usize;
    let mut m = q;
    while m % p == 0 {
        m /= p;
        h += 1;
    }
    if m == 1 {
        Some((p, h))
    } else {
        None
    }
}

// ---------------------------------------------------------------------------
// PG(d,q) indexing
// ---------------------------------------------------------------------------

struct Proj {
    q: usize,
    d: usize,
    base: Vec<usize>, // base[l] = offset of the block with leading 1 at coordinate l
    n: usize,
}

impl Proj {
    fn new(q: usize, d: usize) -> Self {
        let mut base = vec![0usize; d + 2];
        for l in 0..=d {
            base[l + 1] = base[l] + q.pow((d - l) as u32);
        }
        let n = base[d + 1];
        Self { q, d, base, n }
    }

    fn encode(&self, v: &[u8], f: &Field) -> usize {
        let l = v.iter().position(|&x| x != 0).expect("nonzero vector");
        let s = f.i(v[l]);
        let mut idx = self.base[l];
        for i in (l + 1)..=self.d {
            idx += f.m(v[i], s) as usize * self.q.pow((self.d - i) as u32);
        }
        idx
    }

    fn decode(&self, mut idx: usize, out: &mut [u8]) {
        let mut l = 0usize;
        while idx >= self.base[l + 1] {
            l += 1;
        }
        idx -= self.base[l];
        for item in out.iter_mut().take(l) {
            *item = 0;
        }
        out[l] = 1;
        for i in ((l + 1)..=self.d).rev() {
            out[i] = (idx % self.q) as u8;
            idx /= self.q;
        }
    }
}

// ---------------------------------------------------------------------------
// group action: d-th symmetric power of a 2x2 matrix
// ---------------------------------------------------------------------------

fn binom(n: usize, k: usize) -> u128 {
    if k > n {
        return 0;
    }
    let mut acc: u128 = 1;
    for i in 0..k {
        acc = acc * (n - i) as u128 / (i as u128 + 1);
    }
    acc
}

/// S[i][j] = coefficient of x^{d-j} y^j in (a x + b y)^{d-i} (c x + e y)^i.
fn sym_power(f: &Field, d: usize, a: u8, b: u8, c: u8, e: u8) -> Vec<Vec<u8>> {
    let mut s = vec![vec![0u8; d + 1]; d + 1];
    for i in 0..=d {
        // A_k = C(d-i,k) a^{d-i-k} b^k ; B_k = C(i,k) c^{i-k} e^k
        let mut av = vec![0u8; d - i + 1];
        for (k, item) in av.iter_mut().enumerate() {
            let coef = f.from_int((binom(d - i, k) % f.p as u128) as usize);
            *item = f.m(f.m(coef, f.pow(a, d - i - k)), f.pow(b, k));
        }
        let mut bv = vec![0u8; i + 1];
        for (k, item) in bv.iter_mut().enumerate() {
            let coef = f.from_int((binom(i, k) % f.p as u128) as usize);
            *item = f.m(f.m(coef, f.pow(c, i - k)), f.pow(e, k));
        }
        for (ka, &x) in av.iter().enumerate() {
            if x == 0 {
                continue;
            }
            for (kb, &y) in bv.iter().enumerate() {
                if y == 0 {
                    continue;
                }
                s[i][ka + kb] = f.a(s[i][ka + kb], f.m(x, y));
            }
        }
    }
    s
}

fn apply(f: &Field, s: &[Vec<u8>], v: &[u8], out: &mut [u8]) {
    let d1 = v.len();
    for i in 0..d1 {
        let mut acc = 0u8;
        for j in 0..d1 {
            if s[i][j] != 0 && v[j] != 0 {
                acc = f.a(acc, f.m(s[i][j], v[j]));
            }
        }
        out[i] = acc;
    }
}

// ---------------------------------------------------------------------------
// exact NRC rank w(s)
// ---------------------------------------------------------------------------

/// Test whether the Hankel system for a degree-j form `l` (coefficients
/// l[0..=j], with the convention that a root at ∞ shows up as l[j] = 0)
/// annihilates s.
#[inline]
fn hankel_ok(f: &Field, d: usize, s: &[u8], l: &[u8], j: usize) -> bool {
    for v in 0..=(d - j) {
        let mut acc = 0u8;
        for u in 0..=j {
            if l[u] != 0 && s[u + v] != 0 {
                acc = f.a(acc, f.m(l[u], s[u + v]));
            }
        }
        if acc != 0 {
            return false;
        }
    }
    true
}

/// Depth-first enumeration of the j-subsets of PG(1,q) = {0..q-1} ∪ {∞},
/// carrying the product polynomial.  Returns the first subset whose form
/// annihilates s.  The root at ∞ contributes the binary factor `X`, i.e. it
/// leaves the dehomogenized coefficient vector untouched while raising the
/// binary degree by one.
fn find_split_annihilator(
    f: &Field,
    d: usize,
    s: &[u8],
    j: usize,
) -> Option<(Vec<usize>, Vec<u8>)> {
    let q = f.q;
    for use_inf in [false, true] {
        if use_inf && j == 0 {
            continue;
        }
        let jf = if use_inf { j - 1 } else { j };
        let mut chosen: Vec<usize> = Vec::with_capacity(jf);
        let cur = vec![1u8];
        if let Some(hit) = dfs_split(f, d, s, j, jf, 0, &cur, &mut chosen, use_inf) {
            return Some(hit);
        }
    }
    None
}

#[allow(clippy::too_many_arguments)]
fn dfs_split(
    f: &Field,
    d: usize,
    s: &[u8],
    j: usize,
    jf: usize,
    start: usize,
    cur: &[u8],
    chosen: &mut Vec<usize>,
    use_inf: bool,
) -> Option<(Vec<usize>, Vec<u8>)> {
    if chosen.len() == jf {
        let mut l = cur.to_vec();
        l.resize(j + 1, 0);
        if hankel_ok(f, d, s, &l, j) {
            let mut roots = chosen.clone();
            if use_inf {
                roots.push(f.q); // ∞ marker
            }
            return Some((roots, l));
        }
        return None;
    }
    let need = jf - chosen.len();
    let mut a = start;
    while a + need <= f.q {
        // multiply cur by (x - a)
        let mut next = vec![0u8; cur.len() + 1];
        for (u, &cu) in cur.iter().enumerate() {
            next[u + 1] = f.a(next[u + 1], cu);
            next[u] = f.a(next[u], f.m(f.n(a as u8), cu));
        }
        chosen.push(a);
        if let Some(hit) = dfs_split(f, d, s, j, jf, a + 1, &next, chosen, use_inf) {
            return Some(hit);
        }
        chosen.pop();
        a += 1;
    }
    None
}

struct RankInfo {
    w: usize,
    roots: Vec<usize>,
    apolar_degree: usize,
    apolar_kernel_dim: usize,
    apolar_type: String,
}

/// Gaussian elimination rank over F_q.
fn rank_of(f: &Field, rows: usize, cols: usize, data: &mut [u8]) -> usize {
    let mut pivot = 0usize;
    for col in 0..cols {
        let mut sel = None;
        for row in pivot..rows {
            if data[row * cols + col] != 0 {
                sel = Some(row);
                break;
            }
        }
        let Some(sel) = sel else { continue };
        for c in 0..cols {
            data.swap(pivot * cols + c, sel * cols + c);
        }
        let inv = f.i(data[pivot * cols + col]);
        for c in 0..cols {
            data[pivot * cols + c] = f.m(data[pivot * cols + c], inv);
        }
        for row in 0..rows {
            if row == pivot {
                continue;
            }
            let factor = data[row * cols + col];
            if factor == 0 {
                continue;
            }
            for c in 0..cols {
                let sub = f.m(factor, data[pivot * cols + c]);
                data[row * cols + c] = f.a(data[row * cols + c], f.n(sub));
            }
        }
        pivot += 1;
        if pivot == rows {
            break;
        }
    }
    pivot
}

fn hankel_matrix(d: usize, s: &[u8], j: usize) -> (usize, usize, Vec<u8>) {
    let rows = d - j + 1;
    let cols = j + 1;
    let mut data = vec![0u8; rows * cols];
    for v in 0..rows {
        for u in 0..cols {
            data[v * cols + u] = s[u + v];
        }
    }
    (rows, cols, data)
}

/// Classify a binary quadratic Q = l0 + l1 x + l2 x^2 (root at ∞ iff l2 = 0)
/// by its root pattern in PG(1,q).
fn quadratic_type(f: &Field, l: &[u8]) -> &'static str {
    let mut roots = 0usize;
    let mut distinct = 0usize;
    for a in 0..f.q as u8 {
        let val = f.a(l[0], f.a(f.m(l[1], a), f.m(l[2], f.m(a, a))));
        if val == 0 {
            roots += 1;
            distinct += 1;
        }
    }
    let inf_mult = if l[2] == 0 {
        if l[1] == 0 {
            2
        } else {
            1
        }
    } else {
        0
    };
    let total = roots + inf_mult;
    let _ = distinct;
    if total == 2 && inf_mult <= 1 {
        "split"
    } else if total == 1 || inf_mult == 2 {
        "double"
    } else if total == 0 {
        "inert"
    } else {
        "degenerate"
    }
}

fn analyse(f: &Field, d: usize, s: &[u8]) -> RankInfo {
    // apolar degree: least j with nontrivial Hankel kernel
    let mut apolar_degree = d + 1;
    let mut apolar_kernel_dim = 0usize;
    let mut apolar_type = String::from("n/a");
    for j in 1..=d {
        let (rows, cols, mut data) = hankel_matrix(d, s, j);
        let rk = rank_of(f, rows, cols, &mut data);
        if rk < cols {
            apolar_degree = j;
            apolar_kernel_dim = cols - rk;
            if j == 2 && apolar_kernel_dim == 1 {
                // extract the kernel vector from the reduced form
                let mut l = vec![0u8; 3];
                // find the free column
                let mut pivots = Vec::new();
                let mut r = 0usize;
                for c in 0..cols {
                    if r < rk && data[r * cols + c] != 0 {
                        pivots.push(c);
                        r += 1;
                    }
                }
                let free: Vec<usize> = (0..cols).filter(|c| !pivots.contains(c)).collect();
                if free.len() == 1 {
                    let fc = free[0];
                    l[fc] = 1;
                    for (ri, &pc) in pivots.iter().enumerate() {
                        l[pc] = f.n(data[ri * cols + fc]);
                    }
                    apolar_type = quadratic_type(f, &l).to_string();
                }
            }
            break;
        }
    }
    // exact rank
    for j in 1..=d {
        if let Some((roots, _)) = find_split_annihilator(f, d, s, j) {
            return RankInfo {
                w: j,
                roots,
                apolar_degree,
                apolar_kernel_dim,
                apolar_type,
            };
        }
    }
    RankInfo {
        w: d + 1,
        roots: Vec::new(),
        apolar_degree,
        apolar_kernel_dim,
        apolar_type,
    }
}

// ---------------------------------------------------------------------------
// Ergodis cross-check of Hankel ranks over prime fields
// ---------------------------------------------------------------------------

macro_rules! ergodis_rank_dispatch {
    ($p:expr, $rows:expr, $cols:expr, $data:expr, $( $lit:literal ),* ) => {
        match $p {
            $( $lit => {
                let m = Matrix::new_field::<Prime<$lit>>($rows, $cols, $data.to_vec())?;
                Some(m.canonical_row_basis_field::<Prime<$lit>>()?.rows())
            } )*
            _ => None,
        }
    };
}

fn ergodis_rank(p: usize, rows: usize, cols: usize, data: &[u8]) -> Result<Option<usize>> {
    let out = ergodis_rank_dispatch!(
        p as u8, rows, cols, data, 2u8, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53,
        59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151,
        157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251
    );
    Ok(out)
}

// ---------------------------------------------------------------------------

struct OrbitRecord {
    weight: usize,
    size: usize,
    rep: Vec<u8>,
    rep_index: usize,
    apolar_degree: usize,
    apolar_kernel_dim: usize,
    apolar_type: String,
    roots: Vec<usize>,
}

fn main() -> Result<()> {
    let args = Args::parse();
    let q = args.q;
    let r = args.r;
    if r < 2 {
        bail!("redundancy r must be at least 2");
    }
    let d = r - 1;
    if d > q {
        bail!("need d <= q for the normal rational curve to be an arc");
    }
    let f = Field::new(q)?;
    let proj = Proj::new(q, d);
    let k = q + 1 - r;
    if k < 1 {
        bail!("dimension k = q+1-r must be positive");
    }

    // group generators of PGL(2,q): a -> a+1, a -> g a, a -> 1/a
    let g = f.primitive();
    let mut gens: Vec<Vec<Vec<u8>>> = Vec::new();
    gens.push(sym_power(&f, d, 1, 0, 1, 1)); // (x,y) -> (x, x+y)   i.e. a -> a+1
    gens.push(sym_power(&f, d, 1, 0, 0, g)); // a -> g a
    gens.push(sym_power(&f, d, 0, 1, 1, 0)); // a -> 1/a
    let frobenius = args.semilinear && f.h > 1;

    let n = proj.n;
    let mut weight = vec![0u8; n]; // 0 = unvisited
    let mut records: Vec<OrbitRecord> = Vec::new();
    let mut hist = vec![0usize; d + 2];

    let mut buf = vec![0u8; d + 1];
    let mut img = vec![0u8; d + 1];
    let mut queue: VecDeque<usize> = VecDeque::new();
    let mut orbit: Vec<usize> = Vec::new();

    let mut crosscheck_done = 0usize;
    let mut crosscheck_ok = true;

    for start in 0..n {
        if weight[start] != 0 {
            continue;
        }
        proj.decode(start, &mut buf);
        let info = analyse(&f, d, &buf);
        if args.ergodis_crosscheck && f.h == 1 {
            for j in 1..=d {
                let (rows, cols, mut data) = hankel_matrix(d, &buf, j);
                let mine = {
                    let mut copy = data.clone();
                    rank_of(&f, rows, cols, &mut copy)
                };
                if let Some(theirs) = ergodis_rank(f.p, rows, cols, &data)? {
                    if theirs != mine {
                        crosscheck_ok = false;
                    }
                    crosscheck_done += 1;
                }
                data.clear();
            }
        }
        let wv = info.w as u8;
        // BFS the orbit
        orbit.clear();
        queue.clear();
        queue.push_back(start);
        weight[start] = wv;
        orbit.push(start);
        while let Some(cur) = queue.pop_front() {
            proj.decode(cur, &mut buf);
            for gen in &gens {
                apply(&f, gen, &buf, &mut img);
                let idx = proj.encode(&img, &f);
                if weight[idx] == 0 {
                    weight[idx] = wv;
                    orbit.push(idx);
                    queue.push_back(idx);
                }
            }
            if frobenius {
                for i in 0..=d {
                    img[i] = f.pow(buf[i], f.p);
                }
                let idx = proj.encode(&img, &f);
                if weight[idx] == 0 {
                    weight[idx] = wv;
                    orbit.push(idx);
                    queue.push_back(idx);
                }
            }
        }
        hist[info.w] += orbit.len();
        proj.decode(start, &mut buf);
        records.push(OrbitRecord {
            weight: info.w,
            size: orbit.len(),
            rep: buf.clone(),
            rep_index: start,
            apolar_degree: info.apolar_degree,
            apolar_kernel_dim: info.apolar_kernel_dim,
            apolar_type: info.apolar_type,
            roots: info.roots,
        });
    }

    let rho = (1..=d + 1).filter(|&w| hist[w] > 0).max().unwrap_or(0);
    let deep_points = hist[rho];
    let deep_orbits: Vec<&OrbitRecord> = records.iter().filter(|rec| rec.weight == rho).collect();

    // JSON
    let mut json = String::new();
    write!(
        json,
        "{{\"q\":{},\"p\":{},\"h\":{},\"defining_poly\":{:?},\"n\":{},\"k\":{},\"r\":{},\"d\":{},\
\"group\":\"{}\",\"projective_points\":{},\"covering_radius\":{},\"regime\":\"{}\",\
\"deep_hole_projective_points\":{},\"deep_hole_syndromes\":{},\"deep_hole_orbits\":{},\
\"total_orbits\":{},\"weight_histogram\":[",
        q,
        f.p,
        f.h,
        f.poly,
        q + 1,
        k,
        r,
        d,
        if frobenius { "PGammaL(2,q)" } else { "PGL(2,q)" },
        n,
        rho,
        if rho == r { "r" } else { "r-1" },
        deep_points,
        deep_points * (q - 1),
        deep_orbits.len(),
        records.len()
    )?;
    for w in 0..=(d + 1) {
        if w > 0 {
            json.push(',');
        }
        write!(json, "{{\"w\":{},\"points\":{}}}", w, hist[w])?;
    }
    json.push_str("],\"orbits\":[");
    let mut shown = 0usize;
    let mut first = true;
    let mut sorted: Vec<&OrbitRecord> = records.iter().collect();
    sorted.sort_by(|a, b| b.weight.cmp(&a.weight).then(a.size.cmp(&b.size)));
    for rec in sorted {
        if rec.weight + 1 < rho {
            continue;
        }
        if shown >= args.max_reps {
            break;
        }
        if !first {
            json.push(',');
        }
        first = false;
        shown += 1;
        write!(
            json,
            "{{\"w\":{},\"size\":{},\"rep\":{:?},\"rep_index\":{},\"apolar_degree\":{},\
\"apolar_kernel_dim\":{},\"apolar_type\":\"{}\",\"witness_roots\":{:?}}}",
            rec.weight,
            rec.size,
            rec.rep,
            rec.rep_index,
            rec.apolar_degree,
            rec.apolar_kernel_dim,
            rec.apolar_type,
            rec.roots
        )?;
    }
    write!(
        json,
        "],\"ergodis_rank_crosschecks\":{},\"ergodis_rank_agree\":{}}}",
        crosscheck_done, crosscheck_ok
    )?;

    if let Some(path) = &args.out {
        std::fs::write(path, format!("{json}\n"))?;
    }
    println!("{json}");
    Ok(())
}
