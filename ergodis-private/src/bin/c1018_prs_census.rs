//! C1018 — parallel exact PRS deep-hole census over `PG(d,q)` for large `q`.
//!
//! This is a second, independent implementation of the census performed by
//! `c1018_prs_deephole.rs`.  It exists because the first driver is bounded by
//! two limits that block the cells C1018 still needs:
//!
//! * a `u32` point index and a one-byte-per-point weight array, which caps the
//!   ambient space at about `2·10^9` points and 2 GB, and
//! * an exact-rank routine that enumerates all `j`-subsets of `PG(1,q)` at
//!   every level `j = 1..d`, whose cost `Σ_j C(q+1,j)` explodes with `q`.
//!
//! What changes here:
//!
//! 1. **`u64` point indices and a one-bit visited bitmap.**  Memory is `N/8`
//!    bytes instead of `N`, so `|PG(8,19)| = 1.79·10^10` costs 2.2 GB rather
//!    than 17.9 GB.  The weight histogram is accumulated per orbit at discovery
//!    time, so no per-point weight storage is needed.
//! 2. **Lock-free parallel orbit enumeration** over `std::thread::scope`.
//!    Ownership of an orbit is decided by an atomic test-and-set on the bit of
//!    the orbit's *minimum* point index, which is a property of the orbit and
//!    not of the traversal order.  A thread that loses the race discards its
//!    traversal.  Every orbit is therefore recorded exactly once regardless of
//!    scheduling, and the histogram total is checked against `N` at the end.
//! 3. **Apolar-kernel exact rank.**  `w(s) ≤ j` requires a nonzero element of
//!    `ker H^(j)_s`, so levels with a trivial kernel are skipped outright
//!    (the first driver enumerated `C(q+1,j)` subsets even there).  At the
//!    surviving levels the search runs over whichever is smaller, the
//!    `(q^k-1)/(q-1)` projective points of the kernel or the `C(q+1,j)`
//!    split squarefree forms; `--rank-mode` pins either one for cross-checking.
//!
//! The two drivers share no code.  Agreement between them on a cell is an
//! independent replay of that cell: different index type, different traversal,
//! different orbit-ownership rule, and a different exact-rank algorithm.  The
//! finite field, the projective indexing, and the exact linear algebra all come
//! from the read-only Ergodis core (`SmallField`, `ProjectiveIndex`), so both
//! drivers agree on the field model by construction and the GF(2^h)
//! element-labelling hazard of the 2026-08-30 report cannot recur.

use std::collections::hash_map::DefaultHasher;
use std::fmt::Write as _;
use std::sync::atomic::{AtomicU64, AtomicUsize, Ordering};

use anyhow::{bail, Context, Result};
use clap::{Parser, ValueEnum};
use ergodis::field::SmallField;
use ergodis::projective::ProjectiveIndex;

const _: Option<DefaultHasher> = None;

#[derive(Copy, Clone, PartialEq, Eq, ValueEnum)]
enum RankMode {
    /// Pick the cheaper of kernel enumeration and subset enumeration per level.
    Auto,
    /// Always enumerate the projective points of the apolar kernel.
    Kernel,
    /// Always enumerate the j-subsets of PG(1,q) (the 2026-08-30 driver's rule).
    Subset,
}

#[derive(Parser)]
#[command(about = "Parallel exact PRS deep-hole census in PG(r-1,q)")]
struct Args {
    /// Field order (prime power, <= 251).
    #[arg(long)]
    q: usize,
    /// Redundancy r = n - k.  Ambient projective dimension is d = r-1.
    #[arg(long)]
    r: usize,
    /// Worker threads (default: all available parallelism).
    #[arg(long)]
    threads: Option<usize>,
    /// Exact-rank strategy.
    #[arg(long, value_enum, default_value_t = RankMode::Auto)]
    rank_mode: RankMode,
    /// Maximum orbit representatives to emit per reported weight class.
    #[arg(long, default_value_t = 64)]
    max_reps: usize,
    /// Sweep only the arithmetic-progression stratum
    /// `{ s : s_i = 0 unless i ≡ A (mod M) }` instead of censusing `PG(d,q)`.
    /// This is the fixed locus of the order-`M` diagonal torus element and is a
    /// projective subspace, so it is exhaustively searchable far beyond the
    /// reach of a full census.  Requires `--stratum-class`.
    #[arg(long)]
    stratum_mod: Option<usize>,
    /// Residue class `A` for `--stratum-mod`.
    #[arg(long, default_value_t = 0)]
    stratum_class: usize,
    /// Output JSON path.
    #[arg(long)]
    out: Option<String>,
}

// ---------------------------------------------------------------------------
// field wrapper over the Ergodis core table-driven GF(p^h)
// ---------------------------------------------------------------------------

struct Field {
    p: usize,
    h: usize,
    q: usize,
    inner: SmallField,
}

impl Field {
    fn new(q: usize) -> Result<Self> {
        let (p, h) = factor_prime_power(q).context("q must be a prime power")?;
        if q > 251 {
            bail!("q must be at most 251 (u8 element encoding)");
        }
        let inner = SmallField::new(p as u8, h as u8)?;
        Ok(Self { p, h, q, inner })
    }
    #[inline(always)]
    fn a(&self, x: u8, y: u8) -> u8 {
        self.inner.add(x, y)
    }
    #[inline(always)]
    fn m(&self, x: u8, y: u8) -> u8 {
        self.inner.mul(x, y)
    }
    #[inline(always)]
    fn n(&self, x: u8) -> u8 {
        self.inner.sub(0, x)
    }
    #[inline(always)]
    fn i(&self, x: u8) -> u8 {
        self.inner.inverse(x).expect("nonzero field element")
    }
    fn powi(&self, x: u8, e: usize) -> u8 {
        let mut acc = 1u8;
        for _ in 0..e {
            acc = self.m(acc, x);
        }
        acc
    }
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

/// `S[i][j]` = coefficient of `x^{d-j} y^j` in `(a x + b y)^{d-i} (c x + e y)^i`.
fn sym_power(f: &Field, d: usize, a: u8, b: u8, c: u8, e: u8) -> Vec<Vec<u8>> {
    let mut s = vec![vec![0u8; d + 1]; d + 1];
    for i in 0..=d {
        let mut av = vec![0u8; d - i + 1];
        for (k, item) in av.iter_mut().enumerate() {
            let coef = f.from_int((binom(d - i, k) % f.p as u128) as usize);
            *item = f.m(f.m(coef, f.powi(a, d - i - k)), f.powi(b, k));
        }
        let mut bv = vec![0u8; i + 1];
        for (k, item) in bv.iter_mut().enumerate() {
            let coef = f.from_int((binom(i, k) % f.p as u128) as usize);
            *item = f.m(f.m(coef, f.powi(c, i - k)), f.powi(e, k));
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

#[inline]
fn apply(f: &Field, s: &[Vec<u8>], v: &[u8], out: &mut [u8]) {
    for (i, o) in out.iter_mut().enumerate() {
        let mut acc = 0u8;
        for (j, &vj) in v.iter().enumerate() {
            let sij = s[i][j];
            if sij != 0 && vj != 0 {
                acc = f.a(acc, f.m(sij, vj));
            }
        }
        *o = acc;
    }
}

// ---------------------------------------------------------------------------
// exact NRC rank w(s)
// ---------------------------------------------------------------------------

/// Reduced row echelon form in place; returns the pivot columns.
fn rref(f: &Field, rows: usize, cols: usize, data: &mut [u8]) -> Vec<usize> {
    let mut pivots = Vec::new();
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
        pivots.push(col);
        pivot += 1;
        if pivot == rows {
            break;
        }
    }
    pivots
}

/// Kernel basis of the Hankel matrix `H^(j)_s`, as `k` vectors of length `j+1`.
/// Row `v`, column `u` of `H^(j)_s` is `s[u+v]`, `0 ≤ v ≤ d-j`, `0 ≤ u ≤ j`.
fn hankel_kernel(f: &Field, d: usize, s: &[u8], j: usize, scratch: &mut Vec<u8>) -> Vec<Vec<u8>> {
    let rows = d - j + 1;
    let cols = j + 1;
    scratch.clear();
    scratch.resize(rows * cols, 0);
    for v in 0..rows {
        for u in 0..cols {
            scratch[v * cols + u] = s[u + v];
        }
    }
    let pivots = rref(f, rows, cols, scratch);
    let free: Vec<usize> = (0..cols).filter(|c| !pivots.contains(c)).collect();
    let mut basis = Vec::with_capacity(free.len());
    for &fc in &free {
        let mut vec_ = vec![0u8; cols];
        vec_[fc] = 1;
        for (ri, &pc) in pivots.iter().enumerate() {
            vec_[pc] = f.n(scratch[ri * cols + fc]);
        }
        basis.push(vec_);
    }
    basis
}

/// Is the degree-`j` binary form with dehomogenized coefficients `l[0..=j]`
/// (low to high in `x`) split into `j` distinct roots over `PG(1,q)`?
///
/// The multiplicity at `∞` is `j - deg_x(l)`.  Writing `c` for the number of
/// distinct roots in `F_q`, the form is split squarefree exactly when
/// `c = deg_x(l)` (every finite root simple, no irreducible finite factor) and
/// `j - deg_x(l) ≤ 1` (the root at `∞`, if present, is simple).
#[inline]
fn split_squarefree(f: &Field, l: &[u8], j: usize, roots: &mut Vec<usize>) -> bool {
    let deg = match l.iter().rposition(|&c| c != 0) {
        Some(dg) => dg,
        None => return false,
    };
    if j - deg > 1 {
        return false;
    }
    roots.clear();
    for a in 0..f.q as u8 {
        let mut acc = 0u8;
        for u in (0..=deg).rev() {
            acc = f.a(f.m(acc, a), l[u]);
        }
        if acc == 0 {
            roots.push(a as usize);
            if roots.len() > deg {
                return false;
            }
        }
    }
    if roots.len() != deg {
        return false;
    }
    if j - deg == 1 {
        roots.push(f.q); // ∞ marker, matching the 2026-08-30 driver's convention
    }
    true
}

/// Enumerate the projective points of the span of `basis` in leading-one normal
/// form, calling `visit` on each; stops at the first `true`.
fn for_each_projective_point<Fn_>(f: &Field, basis: &[Vec<u8>], buf: &mut [u8], mut visit: Fn_) -> bool
where
    Fn_: FnMut(&[u8]) -> bool,
{
    let k = basis.len();
    let len = buf.len();
    let mut coeff = vec![0u8; k];
    // leading-one normal form: coeff[lead] = 1, coeff[< lead] = 0, rest free
    for lead in 0..k {
        let free = k - lead - 1;
        let total = (f.q as u128).pow(free as u32);
        for enc in 0..total {
            let mut e = enc;
            for c in coeff.iter_mut().take(lead) {
                *c = 0;
            }
            coeff[lead] = 1;
            for c in coeff.iter_mut().take(k).skip(lead + 1) {
                *c = (e % f.q as u128) as u8;
                e /= f.q as u128;
            }
            for b in buf.iter_mut().take(len) {
                *b = 0;
            }
            for (t, &ct) in coeff.iter().enumerate() {
                if ct == 0 {
                    continue;
                }
                for u in 0..len {
                    let bt = basis[t][u];
                    if bt != 0 {
                        buf[u] = f.a(buf[u], f.m(ct, bt));
                    }
                }
            }
            if visit(buf) {
                return true;
            }
        }
    }
    false
}

/// Depth-first enumeration of the `j`-subsets of `PG(1,q)`, testing each
/// product form against the Hankel system.  Retained as the cross-check path.
fn subset_search(f: &Field, d: usize, s: &[u8], j: usize) -> Option<Vec<usize>> {
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
    #[allow(clippy::too_many_arguments)]
    fn dfs(
        f: &Field,
        d: usize,
        s: &[u8],
        j: usize,
        jf: usize,
        start: usize,
        cur: &[u8],
        chosen: &mut Vec<usize>,
        use_inf: bool,
    ) -> Option<Vec<usize>> {
        if chosen.len() == jf {
            let mut l = cur.to_vec();
            l.resize(j + 1, 0);
            if hankel_ok(f, d, s, &l, j) {
                let mut roots = chosen.clone();
                if use_inf {
                    roots.push(f.q);
                }
                return Some(roots);
            }
            return None;
        }
        let need = jf - chosen.len();
        let mut a = start;
        while a + need <= f.q {
            let mut next = vec![0u8; cur.len() + 1];
            for (u, &cu) in cur.iter().enumerate() {
                next[u + 1] = f.a(next[u + 1], cu);
                next[u] = f.a(next[u], f.m(f.n(a as u8), cu));
            }
            chosen.push(a);
            if let Some(hit) = dfs(f, d, s, j, jf, a + 1, &next, chosen, use_inf) {
                return Some(hit);
            }
            chosen.pop();
            a += 1;
        }
        None
    }
    for use_inf in [false, true] {
        if use_inf && j == 0 {
            continue;
        }
        let jf = if use_inf { j - 1 } else { j };
        let mut chosen: Vec<usize> = Vec::with_capacity(jf);
        let cur = vec![1u8];
        if let Some(hit) = dfs(f, d, s, j, jf, 0, &cur, &mut chosen, use_inf) {
            return Some(hit);
        }
    }
    None
}

struct RankInfo {
    w: usize,
    roots: Vec<usize>,
    apolar_degree: usize,
    apolar_kernel_dim: usize,
    apolar_type: &'static str,
}

/// Classify a binary quadratic `l0 + l1 x + l2 x^2` (root at `∞` iff `l2 = 0`).
fn quadratic_type(f: &Field, l: &[u8]) -> &'static str {
    let mut roots = 0usize;
    for a in 0..f.q as u8 {
        let val = f.a(l[0], f.a(f.m(l[1], a), f.m(l[2], f.m(a, a))));
        if val == 0 {
            roots += 1;
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

struct RankScratch {
    matrix: Vec<u8>,
    form: Vec<u8>,
    roots: Vec<usize>,
}

impl RankScratch {
    fn new(d: usize) -> Self {
        Self {
            matrix: Vec::with_capacity((d + 1) * (d + 1)),
            form: vec![0u8; d + 2],
            roots: Vec::with_capacity(d + 2),
        }
    }
}

fn analyse(f: &Field, d: usize, s: &[u8], mode: RankMode, sc: &mut RankScratch) -> RankInfo {
    let mut apolar_degree = d + 1;
    let mut apolar_kernel_dim = 0usize;
    let mut apolar_type = "n/a";
    let mut w = d + 1;
    let mut witness: Vec<usize> = Vec::new();

    for j in 1..=d {
        let basis = hankel_kernel(f, d, s, j, &mut sc.matrix);
        let k = basis.len();
        if k == 0 {
            continue;
        }
        if apolar_degree > d {
            apolar_degree = j;
            apolar_kernel_dim = k;
            if j == 2 && k == 1 {
                apolar_type = quadratic_type(f, &basis[0]);
            }
        }
        // number of candidates each way
        let kernel_points: u128 = {
            let mut acc: u128 = 0;
            let mut pw: u128 = 1;
            for _ in 0..k {
                acc += pw;
                pw = pw.saturating_mul(f.q as u128);
            }
            acc // (q^k - 1)/(q - 1)
        };
        let subset_points = binom(f.q + 1, j);
        let use_kernel = match mode {
            RankMode::Kernel => true,
            RankMode::Subset => false,
            RankMode::Auto => kernel_points <= subset_points,
        };
        let hit = if use_kernel {
            sc.form.clear();
            sc.form.resize(j + 1, 0);
            let mut found: Option<Vec<usize>> = None;
            let mut form = std::mem::take(&mut sc.form);
            let mut roots = std::mem::take(&mut sc.roots);
            for_each_projective_point(f, &basis, &mut form, |l| {
                if split_squarefree(f, l, j, &mut roots) {
                    found = Some(roots.clone());
                    true
                } else {
                    false
                }
            });
            sc.form = form;
            sc.roots = roots;
            found
        } else {
            subset_search(f, d, s, j)
        };
        if let Some(roots) = hit {
            w = j;
            witness = roots;
            break;
        }
    }
    RankInfo {
        w,
        roots: witness,
        apolar_degree,
        apolar_kernel_dim,
        apolar_type,
    }
}

// ---------------------------------------------------------------------------
// per-thread open-addressing set for orbit traversal
// ---------------------------------------------------------------------------

struct StampSet {
    mask: usize,
    key: Vec<u64>,
    stamp: Vec<u32>,
    generation: u32,
}

impl StampSet {
    fn new(capacity: usize) -> Self {
        let mut size = 16usize;
        while size < capacity * 2 {
            size <<= 1;
        }
        Self {
            mask: size - 1,
            key: vec![0; size],
            stamp: vec![0; size],
            generation: 0,
        }
    }
    #[inline]
    fn reset(&mut self) {
        self.generation = self.generation.wrapping_add(1);
        if self.generation == 0 {
            self.stamp.iter_mut().for_each(|x| *x = 0);
            self.generation = 1;
        }
    }
    /// Returns true if `value` was newly inserted.
    #[inline]
    fn insert(&mut self, value: u64) -> bool {
        let mut slot = (value.wrapping_mul(0x9E37_79B9_7F4A_7C15) >> 24) as usize & self.mask;
        loop {
            if self.stamp[slot] != self.generation {
                self.stamp[slot] = self.generation;
                self.key[slot] = value;
                return true;
            }
            if self.key[slot] == value {
                return false;
            }
            slot = (slot + 1) & self.mask;
        }
    }
}

// ---------------------------------------------------------------------------

#[derive(Clone)]
struct OrbitRecord {
    weight: usize,
    size: u64,
    rep: Vec<u8>,
    rep_index: u64,
    apolar_degree: usize,
    apolar_kernel_dim: usize,
    apolar_type: &'static str,
    roots: Vec<usize>,
}

const CHUNK: u64 = 8192;

#[allow(clippy::too_many_arguments)]
fn worker(
    f: &Field,
    d: usize,
    proj: &ProjectiveIndex<'_>,
    gens: &[Vec<Vec<u8>>],
    n: u64,
    visited: &[AtomicU64],
    cursor: &AtomicU64,
    mode: RankMode,
    max_orbit: usize,
) -> Result<(Vec<u64>, u64, Vec<OrbitRecord>)> {
    let mut hist = vec![0u64; d + 2];
    let mut total_orbits = 0u64;
    let mut records: Vec<OrbitRecord> = Vec::new();
    let mut buf = vec![0u8; d + 1];
    let mut img = vec![0u8; d + 1];
    let mut orbit: Vec<u64> = Vec::with_capacity(max_orbit);
    let mut seen = StampSet::new(max_orbit.max(16));
    let mut sc = RankScratch::new(d);

    loop {
        let lo = cursor.fetch_add(CHUNK, Ordering::Relaxed);
        if lo >= n {
            break;
        }
        let hi = (lo + CHUNK).min(n);
        for start in lo..hi {
            if visited[(start / 64) as usize].load(Ordering::Relaxed) & (1u64 << (start % 64)) != 0 {
                continue;
            }
            orbit.clear();
            seen.reset();
            seen.insert(start);
            orbit.push(start);
            let mut head = 0usize;
            while head < orbit.len() {
                let cur = orbit[head];
                head += 1;
                proj.point(cur, &mut buf)?;
                for gen in gens {
                    apply(f, gen, &buf, &mut img);
                    let idx = proj.index(&img)?;
                    if seen.insert(idx) {
                        orbit.push(idx);
                    }
                }
            }
            let owner = *orbit.iter().min().expect("orbit is nonempty");
            let word = (owner / 64) as usize;
            let bit = 1u64 << (owner % 64);
            if visited[word].fetch_or(bit, Ordering::AcqRel) & bit != 0 {
                continue; // another thread owns this orbit
            }
            for &pt in orbit.iter() {
                let w = (pt / 64) as usize;
                let b = 1u64 << (pt % 64);
                visited[w].fetch_or(b, Ordering::Relaxed);
            }
            proj.point(owner, &mut buf)?;
            let info = analyse(f, d, &buf, mode, &mut sc);
            hist[info.w] += orbit.len() as u64;
            total_orbits += 1;
            // Only the top two weight classes can be the deep one: `w ≤ d+1`
            // always, and every cell computed in this campaign has `ρ ≥ d`.
            // The histogram is exact regardless of this filter; `main` bails if
            // `ρ < d` so a missing representative list can never pass silently.
            if info.w >= d {
                records.push(OrbitRecord {
                    weight: info.w,
                    size: orbit.len() as u64,
                    rep: buf.clone(),
                    rep_index: owner,
                    apolar_degree: info.apolar_degree,
                    apolar_kernel_dim: info.apolar_kernel_dim,
                    apolar_type: info.apolar_type,
                    roots: info.roots,
                });
            }
        }
    }
    Ok((hist, total_orbits, records))
}

/// Exhaustive parallel sweep of one arithmetic-progression stratum.
///
/// The stratum `{ s : s_i = 0 unless i ≡ A (mod M) }` is the projective
/// subspace spanned by the coordinate points it allows, so it is enumerated as
/// `PG(|I|-1, q)` and embedded coordinatewise into `PG(d,q)`.  Every point is
/// evaluated exactly; there is no orbit machinery and hence no bitmap, so cost
/// is linear in the stratum size and the sweep parallelises over point ranges.
#[allow(clippy::too_many_arguments)]
fn stratum_sweep(
    f: &Field,
    d: usize,
    r: usize,
    k: usize,
    m: usize,
    class: usize,
    mode: RankMode,
    threads: usize,
    max_reps: usize,
    out: Option<&str>,
) -> Result<()> {
    if m == 0 {
        bail!("--stratum-mod must be positive");
    }
    let indices: Vec<usize> = (0..=d).filter(|i| i % m == class % m).collect();
    if indices.is_empty() {
        bail!("stratum {class} mod {m} contains no coordinate of PG({d},q)");
    }
    let sub = ProjectiveIndex::new(
        &f.inner,
        u8::try_from(indices.len() - 1).context("stratum dimension exceeds u8")?,
    )?;
    let total = sub.point_count();
    // A stratum can be far smaller than one census chunk (`{1,11}` at r=13 is
    // only q+1 points), and a single point can cost seconds, so size the chunk
    // to the sweep rather than using the census constant.
    let chunk = (total / (threads as u64 * 4)).clamp(1, CHUNK);
    let cursor = AtomicU64::new(0);
    let failures = AtomicUsize::new(0);
    let mut hist = vec![0u64; d + 2];
    let mut examples: Vec<(Vec<u8>, usize, usize, usize)> = Vec::new();

    std::thread::scope(|scope| {
        let mut handles = Vec::new();
        for _ in 0..threads {
            let (f, sub, indices, cursor, failures) =
                (f, &sub, &indices, &cursor, &failures);
            handles.push(scope.spawn(move || {
                let mut hist = vec![0u64; d + 2];
                let mut examples: Vec<(Vec<u8>, usize, usize, usize)> = Vec::new();
                let mut small = vec![0u8; indices.len()];
                let mut full = vec![0u8; d + 1];
                let mut sc = RankScratch::new(d);
                loop {
                    let lo = cursor.fetch_add(chunk, Ordering::Relaxed);
                    if lo >= total {
                        break;
                    }
                    let hi = (lo + chunk).min(total);
                    for idx in lo..hi {
                        if sub.point(idx, &mut small).is_err() {
                            failures.fetch_add(1, Ordering::Relaxed);
                            return (hist, examples);
                        }
                        full.iter_mut().for_each(|c| *c = 0);
                        for (slot, &i) in indices.iter().enumerate() {
                            full[i] = small[slot];
                        }
                        let info = analyse(f, d, &full, mode, &mut sc);
                        hist[info.w] += 1;
                        if info.w == d && info.apolar_degree >= 3 {
                            examples.push((
                                full.clone(),
                                info.w,
                                info.apolar_degree,
                                info.apolar_kernel_dim,
                            ));
                        }
                    }
                }
                (hist, examples)
            }));
        }
        for handle in handles {
            let (h, ex) = handle.join().expect("stratum worker panicked");
            for (slot, add) in hist.iter_mut().zip(h) {
                *slot += add;
            }
            examples.extend(ex);
        }
    });
    if failures.load(Ordering::Relaxed) != 0 {
        bail!("a stratum worker failed");
    }
    let swept: u64 = hist.iter().sum();
    if swept != total {
        bail!("stratum histogram total {swept} does not cover all {total} points");
    }
    let rho = (1..=d + 1).filter(|&w| hist[w] > 0).max().unwrap_or(0);
    // `ρ(PRS) = d` in every cell of this campaign except the Seroussi--Roth
    // even-field pair; a stratum's own maximum can be lower, so deep is pinned
    // to `w = d`, not to the stratum maximum.
    let deep = hist[d];
    examples.sort();
    let exceptional = examples.len() as u64;

    let mut json = String::new();
    write!(
        json,
        "{{\"driver\":\"c1018_prs_census\",\"mode\":\"stratum\",\"q\":{},\"p\":{},\"h\":{},\
\"defining_poly\":{:?},\"n\":{},\"k\":{},\"r\":{},\"d\":{},\"stratum_mod\":{},\
\"stratum_class\":{},\"stratum_indices\":{:?},\"stratum_points\":{},\"threads\":{},\
\"stratum_max_weight\":{},\"deep_in_stratum\":{},\"exceptional_in_stratum\":{},\
\"weight_histogram\":[",
        f.q,
        f.p,
        f.h,
        f.inner.modulus(),
        f.q + 1,
        k,
        r,
        d,
        m,
        class % m,
        indices,
        total,
        threads,
        rho,
        deep,
        exceptional
    )?;
    for w in 0..=(d + 1) {
        if w > 0 {
            json.push(',');
        }
        write!(json, "{{\"w\":{},\"points\":{}}}", w, hist[w])?;
    }
    json.push_str("],\"exceptional_examples\":[");
    for (i, (pt, w, deg, kdim)) in examples.iter().take(max_reps).enumerate() {
        if i > 0 {
            json.push(',');
        }
        write!(
            json,
            "{{\"point\":{pt:?},\"w\":{w},\"apolar_degree\":{deg},\"apolar_kernel_dim\":{kdim}}}"
        )?;
    }
    json.push_str("]}");
    if let Some(path) = out {
        std::fs::write(path, format!("{json}\n"))?;
    }
    println!("{json}");
    Ok(())
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
    let k = q + 1 - r;
    if k < 1 {
        bail!("dimension k = q+1-r must be positive");
    }
    let f = Field::new(q)?;
    let threads = args
        .threads
        .or_else(|| std::thread::available_parallelism().ok().map(|v| v.get()))
        .unwrap_or(1)
        .max(1);
    if let Some(m) = args.stratum_mod {
        return stratum_sweep(
            &f,
            d,
            r,
            k,
            m,
            args.stratum_class,
            args.rank_mode,
            threads,
            args.max_reps,
            args.out.as_deref(),
        );
    }
    let proj = ProjectiveIndex::new(
        &f.inner,
        u8::try_from(d).context("projective dimension exceeds u8")?,
    )?;
    let n = proj.point_count();

    let g = f.primitive();
    let gens: Vec<Vec<Vec<u8>>> = vec![
        sym_power(&f, d, 1, 0, 1, 1), // a -> a+1
        sym_power(&f, d, 1, 0, 0, g), // a -> g a
        sym_power(&f, d, 0, 1, 1, 0), // a -> 1/a
    ];

    let words = ((n + 63) / 64) as usize;
    let visited: Vec<AtomicU64> = std::iter::repeat_with(|| AtomicU64::new(0))
        .take(words)
        .collect();
    let cursor = AtomicU64::new(0);
    let max_orbit = q * q * q; // |PGL(2,q)| = q^3 - q
    let failures = AtomicUsize::new(0);

    let mut hist = vec![0u64; d + 2];
    let mut total_orbits = 0u64;
    let mut records: Vec<OrbitRecord> = Vec::new();

    std::thread::scope(|scope| {
        let mut handles = Vec::new();
        for _ in 0..threads {
            let f = &f;
            let proj = &proj;
            let gens = &gens;
            let visited = &visited;
            let cursor = &cursor;
            let failures = &failures;
            handles.push(scope.spawn(move || {
                match worker(
                    f,
                    d,
                    proj,
                    gens,
                    n,
                    visited,
                    cursor,
                    args.rank_mode,
                    max_orbit,
                ) {
                    Ok(v) => v,
                    Err(_) => {
                        failures.fetch_add(1, Ordering::Relaxed);
                        (vec![0u64; d + 2], 0, Vec::new())
                    }
                }
            }));
        }
        for handle in handles {
            let (h, t, rec) = handle.join().expect("worker panicked");
            for (slot, add) in hist.iter_mut().zip(h) {
                *slot += add;
            }
            total_orbits += t;
            records.extend(rec);
        }
    });
    if failures.load(Ordering::Relaxed) != 0 {
        bail!("a worker thread failed");
    }

    let covered: u64 = hist.iter().sum();
    if covered != n {
        bail!("histogram total {covered} does not cover all {n} projective points");
    }

    let rho = (1..=d + 1).filter(|&w| hist[w] > 0).max().unwrap_or(0);
    if rho < d {
        bail!("covering radius {rho} is below d = {d}; the retained representative list is incomplete");
    }
    let deep_points = hist[rho];
    let mut deep: Vec<&OrbitRecord> = records.iter().filter(|rec| rec.weight == rho).collect();
    deep.sort_by(|a, b| {
        a.apolar_degree
            .cmp(&b.apolar_degree)
            .then(a.size.cmp(&b.size))
            .then(a.rep_index.cmp(&b.rep_index))
    });
    let deep_persistent: u64 = deep
        .iter()
        .filter(|rec| rec.apolar_degree <= 2)
        .map(|rec| rec.size)
        .sum();
    let deep_exceptional: u64 = deep
        .iter()
        .filter(|rec| rec.apolar_degree >= 3)
        .map(|rec| rec.size)
        .sum();
    let exceptional_orbits = deep.iter().filter(|rec| rec.apolar_degree >= 3).count();
    let persistent_predicted = (q as u64) * ((q + 1) as u64) * ((q + 1) as u64) / 2;

    let mut json = String::new();
    write!(
        json,
        "{{\"driver\":\"c1018_prs_census\",\"q\":{},\"p\":{},\"h\":{},\"defining_poly\":{:?},\
\"n\":{},\"k\":{},\"r\":{},\"d\":{},\"group\":\"PGL(2,q)\",\"threads\":{},\"rank_mode\":\"{}\",\
\"projective_points\":{},\"covering_radius\":{},\"regime\":\"{}\",\
\"deep_hole_projective_points\":{},\"deep_hole_syndromes\":{},\"deep_hole_orbits\":{},\
\"deep_persistent_points\":{},\"deep_exceptional_points\":{},\"deep_exceptional_orbits\":{},\
\"persistent_predicted\":{},\"total_orbits\":{},\"weight_histogram\":[",
        q,
        f.p,
        f.h,
        f.inner.modulus(),
        q + 1,
        k,
        r,
        d,
        threads,
        match args.rank_mode {
            RankMode::Auto => "auto",
            RankMode::Kernel => "kernel",
            RankMode::Subset => "subset",
        },
        n,
        rho,
        if rho == r { "r" } else { "r-1" },
        deep_points,
        deep_points * (q as u64 - 1),
        deep.len(),
        deep_persistent,
        deep_exceptional,
        exceptional_orbits,
        persistent_predicted,
        total_orbits
    )?;
    for w in 0..=(d + 1) {
        if w > 0 {
            json.push(',');
        }
        write!(json, "{{\"w\":{},\"points\":{}}}", w, hist[w])?;
    }
    json.push_str("],\"deep_orbits\":[");
    for (i, rec) in deep.iter().take(args.max_reps).enumerate() {
        if i > 0 {
            json.push(',');
        }
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
    json.push_str("]}");

    if let Some(path) = &args.out {
        std::fs::write(path, format!("{json}\n"))?;
    }
    println!("{json}");
    Ok(())
}
