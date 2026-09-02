//! C1025 — deep-hole decision on a carrier stratum, at top level only.
//!
//! Built after the premise behind the C1024 accelerator proposal was checked and
//! found false: the Hankel rank on a stratum is *generically full*, so there is
//! no rank deficiency to exploit (see the report's Part 1).  This driver rests
//! on a different and provable reduction instead.
//!
//! **Single-level lemma.**  If `q + 1 ≥ d - 1` then
//!
//! ```text
//!     w(s) ≤ d-1   ⟺   some split squarefree form of degree exactly d-1
//!                       annihilates s.
//! ```
//!
//! *Proof.*  (⇐) immediate.  (⇒) if `w(s) = j₀ ≤ d-1`, take a minimal spanning
//! set `T₀ ⊆ PG(1,q)` with `|T₀| = j₀` and enlarge it to `T ⊇ T₀` of size `d-1`
//! by any further points of `PG(1,q)`, which exist because `|PG(1,q)| = q+1 ≥
//! d-1`.  Then `s ∈ span{P_t : t ∈ T₀} ⊆ span{P_t : t ∈ T}`, and the form of `T`
//! is split squarefree of degree `d-1`. ∎
//!
//! So deciding *deep or not* — as opposed to computing the exact rank `w(s)` —
//! needs **one** level, not all of `j = 1..d-1`.  The 2026-08-30 and 2026-08-31
//! drivers search every level because they report the exact `w`; for the
//! deep/not-deep question that is wasted work, and it is what made
//! `(17, m=7)` at `q = 29` time out.
//!
//! On top of that the search at the single level is staged:
//!
//! 1. **Randomised witness hunt.**  A split squarefree degree-`(d-1)` form
//!    annihilates `s` under two linear conditions, so a uniformly random
//!    `(d-1)`-subset succeeds with probability about `q^{-2}`; a few multiples
//!    of `q²` trials finds one for almost every non-deep point.  This phase can
//!    only ever certify **not deep**, and it does so by exhibiting a witness
//!    that is verified directly — it has no false positives by construction and
//!    depends on no unproved hypothesis.
//! 2. **Exhaustive fallback.**  Points that survive phase 1 get the complete
//!    `C(q+1, d-1)` enumeration, so the verdict for every point is exact.
//!
//! The number of points that reach phase 2 is reported, so the cost split is
//! visible and the exactness claim is auditable.
//!
//! Nothing in the read-only Ergodis core is modified; `SmallField` and
//! `ProjectiveIndex` are used as provided.

use std::fmt::Write as _;
use std::sync::atomic::{AtomicU64, AtomicUsize, Ordering};

use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis::field::SmallField;
use ergodis::projective::ProjectiveIndex;

#[derive(Parser)]
#[command(about = "Exact deep-hole decision on a PRS carrier stratum, top level only")]
struct Args {
    /// Field order (prime power, <= 251).
    #[arg(long)]
    q: usize,
    /// Redundancy r = n - k.  Ambient projective dimension is d = r-1.
    #[arg(long)]
    r: usize,
    /// Sweep the stratum { s : s_i = 0 unless i ≡ A (mod M) }.
    #[arg(long)]
    stratum_mod: usize,
    /// Residue class A.
    #[arg(long, default_value_t = 1)]
    stratum_class: usize,
    /// Randomised trials per point before falling back to exhaustive search.
    /// Defaults to 40·q², i.e. about forty expected hits.
    #[arg(long)]
    trials: Option<u64>,
    /// Worker threads.
    #[arg(long)]
    threads: Option<usize>,
    /// Maximum exceptional examples to emit.
    #[arg(long, default_value_t = 64)]
    max_reps: usize,
    /// Output JSON path.
    #[arg(long)]
    out: Option<String>,
}

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
        Ok(Self {
            p,
            h,
            q,
            inner: SmallField::new(p as u8, h as u8)?,
        })
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
    let mut mm = q;
    while mm % p == 0 {
        mm /= p;
        h += 1;
    }
    if mm == 1 {
        Some((p, h))
    } else {
        None
    }
}

/// Does the degree-`j` form with dehomogenised coefficients `l[0..=j]` (a root
/// at infinity showing as a degree deficit) annihilate the degree-`d` syndrome?
#[inline]
fn annihilates(f: &Field, d: usize, s: &[u8], l: &[u8], j: usize) -> bool {
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

/// Coefficients of `∏_{a ∈ finite} (x - a)`, padded to length `j+1`.
/// Points equal to `f.q` denote `∞` and contribute only to the degree.
fn subset_form(f: &Field, pts: &[usize], j: usize, out: &mut Vec<u8>) {
    out.clear();
    out.push(1); // the empty product
    for &a in pts {
        if a == f.q {
            continue; // a root at infinity: degree only, coefficients unchanged
        }
        let neg = f.n(a as u8);
        // out ← out · (x - a), computed in place from the top down
        out.push(0);
        for k in (1..out.len()).rev() {
            // new_k = old_{k-1} + neg · old_k   (old_k is out[k] before update)
            let shifted = out[k - 1];
            let scaled = if out[k] == 0 { 0 } else { f.m(neg, out[k]) };
            out[k] = f.a(shifted, scaled);
        }
        out[0] = f.m(neg, out[0]);
    }
    out.resize(j + 1, 0);
}

struct Rng(u64);

impl Rng {
    #[inline]
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9E37_79B9_7F4A_7C15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
        z ^ (z >> 31)
    }
    #[inline]
    fn below(&mut self, n: u64) -> u64 {
        self.next() % n
    }
}

/// Reduced row echelon rank over F_q.
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

/// Sylvester fast path.  Returns `Some(is_deep)` when the apolar degree is at
/// most 2, where the verdict costs `O(q)` and needs no search at all.
///
/// This is C1023 Lemma 1, the finite-field refinement of Sylvester's theorem via
/// the Apolarity Lemma: with `s^⊥ = (F, H)`, `deg F = e ≤ deg H`, (i) if `F` is
/// split squarefree over `F_q` then `w(s) = e`; (ii) if it is not and `e ≤ 2`,
/// then every level up to `d+1-e = d-1` consists of multiples of `F` and none is
/// split squarefree, so `s` is deep.  For `e ≤ 2` and `d ≥ 3` we have
/// `e < d+2-e`, so the degree-`e` part of `s^⊥` is one-dimensional and `F` is
/// well defined up to scalar.
fn sylvester_verdict(f: &Field, d: usize, s: &[u8]) -> Option<bool> {
    for j in 1..=2usize.min(d) {
        let rows = d - j + 1;
        let cols = j + 1;
        let mut data = vec![0u8; rows * cols];
        for v in 0..rows {
            for u in 0..cols {
                data[v * cols + u] = s[u + v];
            }
        }
        let rk = rank_of(f, rows, cols, &mut data);
        if rk == cols {
            continue; // no annihilator of this degree
        }
        // Extract the (unique, since rk = cols-1) kernel vector from the RREF.
        let mut pivots = Vec::new();
        let mut row = 0usize;
        for c in 0..cols {
            if row < rk && data[row * cols + c] != 0 {
                pivots.push(c);
                row += 1;
            }
        }
        let free: Vec<usize> = (0..cols).filter(|c| !pivots.contains(c)).collect();
        if free.len() != 1 {
            return None; // not the one-dimensional situation the lemma assumes
        }
        let mut fgen = vec![0u8; cols];
        fgen[free[0]] = 1;
        for (ri, &pc) in pivots.iter().enumerate() {
            fgen[pc] = f.n(data[ri * cols + free[0]]);
        }
        // Split squarefree over F_q?  Degree in x, plus a simple root at infinity
        // when the leading coefficient vanishes.
        let deg = match fgen.iter().rposition(|&c| c != 0) {
            Some(dg) => dg,
            None => return None,
        };
        if j - deg > 1 {
            return Some(true); // a repeated root at infinity: not split squarefree
        }
        let mut roots = 0usize;
        for a in 0..f.q as u8 {
            let mut acc = 0u8;
            for u in (0..=deg).rev() {
                acc = f.a(f.m(acc, a), fgen[u]);
            }
            if acc == 0 {
                roots += 1;
            }
        }
        let split_squarefree = roots == deg;
        return Some(!split_squarefree);
    }
    None
}

/// Apolar degree: least `j` with a nontrivial Hankel kernel.
fn apolar_degree(f: &Field, d: usize, s: &[u8]) -> usize {
    for j in 1..=d {
        let rows = d - j + 1;
        let cols = j + 1;
        let mut data = vec![0u8; rows * cols];
        for v in 0..rows {
            for u in 0..cols {
                data[v * cols + u] = s[u + v];
            }
        }
        if rank_of(f, rows, cols, &mut data) < cols {
            return j;
        }
    }
    d + 1
}

/// Exhaustive search over all `(d-1)`-subsets of `PG(1,q)`.
fn exhaustive_hit(f: &Field, d: usize, s: &[u8]) -> bool {
    let j = d - 1;
    let n = f.q + 1; // points of PG(1,q): 0..q-1 and the marker q for infinity
    let mut chosen: Vec<usize> = Vec::with_capacity(j);
    let mut buf: Vec<u8> = Vec::with_capacity(d + 2);
    fn rec(
        f: &Field,
        d: usize,
        s: &[u8],
        j: usize,
        n: usize,
        start: usize,
        chosen: &mut Vec<usize>,
        buf: &mut Vec<u8>,
    ) -> bool {
        if chosen.len() == j {
            subset_form(f, chosen, j, buf);
            return annihilates(f, d, s, buf, j);
        }
        let need = j - chosen.len();
        let mut a = start;
        while a + need <= n {
            chosen.push(a);
            if rec(f, d, s, j, n, a + 1, chosen, buf) {
                chosen.pop();
                return true;
            }
            chosen.pop();
            a += 1;
        }
        false
    }
    rec(f, d, s, j, n, 0, &mut chosen, &mut buf)
}

const CHUNK: u64 = 64;

fn main() -> Result<()> {
    let args = Args::parse();
    let (q, r) = (args.q, args.r);
    if r < 3 {
        bail!("redundancy r must be at least 3");
    }
    let d = r - 1;
    if d > q {
        bail!("need d <= q for the normal rational curve to be an arc");
    }
    let k = q + 1 - r;
    if k < 1 {
        bail!("dimension k = q+1-r must be positive");
    }
    if q + 1 < d - 1 {
        bail!("single-level lemma needs q+1 >= d-1");
    }
    let f = Field::new(q)?;
    let m = args.stratum_mod;
    if m == 0 {
        bail!("--stratum-mod must be positive");
    }
    let indices: Vec<usize> = (0..=d)
        .filter(|i| i % m == args.stratum_class % m)
        .collect();
    if indices.is_empty() {
        bail!("empty stratum");
    }
    let sub = ProjectiveIndex::new(
        &f.inner,
        u8::try_from(indices.len() - 1).context("stratum dimension exceeds u8")?,
    )?;
    let total = sub.point_count();
    let trials = args.trials.unwrap_or((q as u64) * (q as u64) * 40);
    let threads = args
        .threads
        .or_else(|| std::thread::available_parallelism().ok().map(|v| v.get()))
        .unwrap_or(1)
        .max(1);

    let cursor = AtomicU64::new(0);
    let failures = AtomicUsize::new(0);
    let mut deep = 0u64;
    let mut exceptional = 0u64;
    let mut phase2 = 0u64;
    let mut examples: Vec<(Vec<u8>, usize)> = Vec::new();

    std::thread::scope(|scope| {
        let mut handles = Vec::new();
        for tid in 0..threads {
            let (f, sub, indices, cursor, failures) = (&f, &sub, &indices, &cursor, &failures);
            handles.push(scope.spawn(move || {
                let mut deep = 0u64;
                let mut exceptional = 0u64;
                let mut phase2 = 0u64;
                let mut examples: Vec<(Vec<u8>, usize)> = Vec::new();
                let mut small = vec![0u8; indices.len()];
                let mut full = vec![0u8; d + 1];
                let mut buf: Vec<u8> = Vec::with_capacity(d + 2);
                let mut pts: Vec<usize> = Vec::with_capacity(d);
                let mut rng = Rng(0x1234_5678_9ABC_DEF0 ^ ((tid as u64) << 32));
                let npts = q + 1;
                let mut pool: Vec<usize> = (0..npts).collect();
                loop {
                    let lo = cursor.fetch_add(CHUNK, Ordering::Relaxed);
                    if lo >= total {
                        break;
                    }
                    let hi = (lo + CHUNK).min(total);
                    for idx in lo..hi {
                        if sub.point(idx, &mut small).is_err() {
                            failures.fetch_add(1, Ordering::Relaxed);
                            return (deep, exceptional, phase2, examples);
                        }
                        full.iter_mut().for_each(|c| *c = 0);
                        for (slot, &i) in indices.iter().enumerate() {
                            full[i] = small[slot];
                        }
                        // Phase 0: Sylvester fast path, exact and O(q), which
                        // disposes of the whole persistent locus without search.
                        if let Some(is_deep) = sylvester_verdict(f, d, &full) {
                            if is_deep {
                                deep += 1;
                                // apolar degree <= 2 here, so never exceptional
                            }
                            continue;
                        }
                        // Phase 1: randomised witness hunt at level d-1.
                        let mut hit = false;
                        for _ in 0..trials {
                            pts.clear();
                            // sample d-1 distinct points of PG(1,q) by partial shuffle
                            for slot in 0..(d - 1) {
                                let pick = slot + rng.below((npts - slot) as u64) as usize;
                                pool.swap(slot, pick);
                                pts.push(pool[slot]);
                            }
                            pts.sort_unstable();
                            subset_form(f, &pts, d - 1, &mut buf);
                            if annihilates(f, d, &full, &buf, d - 1) {
                                hit = true;
                                break;
                            }
                        }
                        if !hit {
                            // Phase 2: exact, exhaustive.
                            phase2 += 1;
                            hit = exhaustive_hit(f, d, &full);
                        }
                        if !hit {
                            deep += 1;
                            let e = apolar_degree(f, d, &full);
                            if e >= 3 {
                                exceptional += 1;
                                if examples.len() < 256 {
                                    examples.push((full.clone(), e));
                                }
                            }
                        }
                    }
                }
                (deep, exceptional, phase2, examples)
            }));
        }
        for handle in handles {
            let (dp, ex, p2, exm) = handle.join().expect("worker panicked");
            deep += dp;
            exceptional += ex;
            phase2 += p2;
            examples.extend(exm);
        }
    });
    if failures.load(Ordering::Relaxed) != 0 {
        bail!("a worker failed");
    }
    examples.sort();

    let mut json = String::new();
    write!(
        json,
        "{{\"driver\":\"c1025_prs_stratum\",\"q\":{},\"p\":{},\"h\":{},\"defining_poly\":{:?},\
\"n\":{},\"k\":{},\"r\":{},\"d\":{},\"stratum_mod\":{},\"stratum_class\":{},\
\"stratum_indices\":{:?},\"stratum_points\":{},\"threads\":{},\"trials\":{},\
\"deep_in_stratum\":{},\"exceptional_in_stratum\":{},\"phase2_points\":{},\
\"exceptional_examples\":[",
        q,
        f.p,
        f.h,
        f.inner.modulus(),
        q + 1,
        k,
        r,
        d,
        m,
        args.stratum_class % m,
        indices,
        total,
        threads,
        trials,
        deep,
        exceptional,
        phase2
    )?;
    for (i, (pt, e)) in examples.iter().take(args.max_reps).enumerate() {
        if i > 0 {
            json.push(',');
        }
        write!(json, "{{\"point\":{pt:?},\"apolar_degree\":{e}}}")?;
    }
    json.push_str("]}");
    if let Some(path) = &args.out {
        std::fs::write(path, format!("{json}\n"))?;
    }
    println!("{json}");
    Ok(())
}
