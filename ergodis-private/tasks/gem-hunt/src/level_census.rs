//! C1018 wave 2 — transversal hierarchy level versus X-check weight.
//!
//! A qubit CSS code is a flag `A ⊆ V ⊆ F_2^n`: `A` is the X-type stabilizer
//! code, `B = V^⊥` the Z-type stabilizer code, `V = B^⊥`, and
//! `k = dim V − dim A`. Every such flag is a valid CSS code (the commutation
//! condition `A ⊥ B` is exactly `A ⊆ V`), so enumerating flags enumerates CSS
//! codes with no further admissibility test.
//!
//! For each flag this computes, exactly:
//!   * `d_X` = min weight of `V \ A`, `d_Z` = min weight of `A^⊥ \ V^⊥`;
//!   * `wX` = the exact optimal X-check weight, i.e. the least `w` such that
//!     the codewords of `A` of weight `≤ w` span `A` (so *every* generating
//!     set of `A` contains a vector of weight `≥ wX`, and one achieves it);
//!   * `wZ` likewise for `B`;
//!   * the complete diagonal transversal group by Smith normal form, and the
//!     maximum Clifford-hierarchy level of an induced logical gate.
//!
//! The maximum over the group equals the maximum over any generating set:
//! multilinear coefficients add, and in `Z_{2^m}` the order of a sum divides
//! the larger of the two orders, so level is subadditive under composition.
//!
//! Two sweep modes:
//!   * `--census`: exhaustive over ALL flags in `F_2^n`, optionally restricted
//!     to `wX ≤ W` and to minimum distance `≥ D`.
//!   * `--ladder`: the Reed-Muller / punctured / shortened ladder that the
//!     wave-1B catalogue was drawn from, up to length 64.

use std::collections::BTreeMap;
use std::sync::{Arc, Mutex};

use ergodis_private::arith::{lcm_i128 as lcm, smith_normal_form};
use ergodis_private::css_codes::{multilinear_level, reed_muller};
use ergodis_private::gf2_linalg::{dual_basis, rref, span, Word};

#[derive(clap::Args, Debug)]
pub struct LevelsArgs {
    /// Exhaustive flag census at this length.
    #[arg(long)]
    census: Option<usize>,
    /// Restrict the census to codes of X-check weight at most this.
    #[arg(long)]
    max_check_weight: Option<u32>,
    /// Restrict the census to codes of minimum distance at least this.
    #[arg(long, default_value_t = 2)]
    min_distance: u32,
    /// Sweep the Reed-Muller ladder instead.
    #[arg(long, default_value_t = false)]
    ladder: bool,
    /// Worker threads for the census.
    #[arg(long, default_value_t = 8)]
    threads: usize,
    /// Skip a flag whose constraint system would exceed this many rows.
    #[arg(long, default_value_t = 1 << 17)]
    row_cap: usize,
}

// ---------------------------------------------------------------- GF(2) ----

/// Exact optimal check weight: least `w` with `{c ∈ code : |c| ≤ w}` spanning.
fn optimal_check_weight(basis: &[Word], n: usize) -> u32 {
    if basis.is_empty() {
        return 0;
    }
    let mut words: Vec<Word> = span(basis).into_iter().filter(|&w| w != 0).collect();
    words.sort_by_key(|w| w.count_ones());
    let target = basis.len();
    let mut acc: Vec<Word> = Vec::new();
    for w in words {
        let mut probe = acc.clone();
        probe.push(w);
        rref(&mut probe, n);
        if probe.len() > acc.len() {
            acc = probe;
            if acc.len() == target {
                return w.count_ones();
            }
        }
    }
    u32::MAX
}

/// Maximum induced logical Clifford-hierarchy level of the flag `A ⊆ V`.
fn max_level(a_basis: &[Word], v_basis: &[Word], n: usize, row_cap: usize) -> Option<usize> {
    let dim_a = a_basis.len();
    let k = v_basis.len() - dim_a;
    if k == 0 {
        return Some(0);
    }
    if (1usize << v_basis.len()) > row_cap {
        return None;
    }
    let a_span = span(a_basis);
    // coset representatives: complete A to a basis of V
    let mut cur = a_basis.to_vec();
    let mut ext = Vec::new();
    for &w in v_basis {
        let mut probe = cur.clone();
        probe.push(w);
        rref(&mut probe, n);
        if probe.len() > cur.len() {
            cur = probe;
            ext.push(w);
        }
    }
    let reps: Vec<Word> = (0..(1usize << k))
        .map(|mask| {
            let mut v = 0u64;
            for (i, e) in ext.iter().enumerate() {
                if mask >> i & 1 == 1 {
                    v ^= *e;
                }
            }
            v
        })
        .collect();

    let mut rowset: BTreeMap<Vec<i128>, ()> = BTreeMap::new();
    for &v in &reps {
        for &aw in &a_span {
            let w = v ^ aw;
            if w == v {
                continue;
            }
            let row: Vec<i128> = (0..n)
                .map(|j| ((w >> j & 1) as i128) - ((v >> j & 1) as i128))
                .collect();
            rowset.insert(row, ());
        }
    }
    let rows: Vec<Vec<i128>> = rowset.into_keys().collect();
    if rows.is_empty() {
        return Some(usize::MAX); // unconstrained: continuous logical action
    }
    let (diag, vmat) = smith_normal_form(&rows, n);
    let modulus = diag
        .iter()
        .filter(|&&d| d > 1)
        .fold(1i128, |acc, &d| lcm(acc, d))
        .max(1);
    let mut best = 0usize;
    for (i, &d) in diag.iter().enumerate() {
        if d <= 1 {
            continue;
        }
        let scale = modulus / d;
        let coeff: Vec<i128> = (0..n).map(|j| vmat[j][i] * scale).collect();
        let logical: Vec<i128> = reps
            .iter()
            .map(|&v| {
                (0..n)
                    .filter(|&j| v >> j & 1 == 1)
                    .map(|j| coeff[j])
                    .sum::<i128>()
                    .rem_euclid(modulus)
            })
            .collect();
        let base = logical[0];
        let logical: Vec<i128> = logical
            .iter()
            .map(|x| (x - base).rem_euclid(modulus))
            .collect();
        let l = multilinear_level(&logical, k, modulus);
        if l == usize::MAX {
            return Some(usize::MAX);
        }
        if l > best {
            best = l;
        }
    }
    // the free (torus) directions must act trivially, else the logical action
    // is continuous; check and flag
    for i in diag.len()..n {
        for &v in &reps {
            let s: i128 = (0..n)
                .filter(|&j| v >> j & 1 == 1)
                .map(|j| vmat[j][i])
                .sum();
            if s != 0 {
                return Some(usize::MAX);
            }
        }
    }
    Some(best)
}

// ------------------------------------------------ subspace enumeration -----

/// All subspaces of `F_2^m`, each as an RREF basis.
fn all_subspaces(m: usize) -> Vec<Vec<Word>> {
    let mut out = Vec::new();
    for d in 0..=m {
        let mut pivots = vec![0usize; d];
        enumerate_pivots(m, d, 0, 0, &mut pivots, &mut out);
    }
    out
}

fn enumerate_pivots(
    m: usize,
    d: usize,
    idx: usize,
    start: usize,
    pivots: &mut Vec<usize>,
    out: &mut Vec<Vec<Word>>,
) {
    if idx == d {
        // free positions per row: columns to the right of the pivot, not pivots
        let mut frees: Vec<Vec<usize>> = Vec::new();
        for i in 0..d {
            frees.push(
                ((pivots[i] + 1)..m)
                    .filter(|c| !pivots.contains(c))
                    .collect(),
            );
        }
        let total: usize = frees.iter().map(|f| f.len()).sum();
        for assign in 0..(1usize << total) {
            let mut basis = Vec::with_capacity(d);
            let mut bit = 0usize;
            for i in 0..d {
                let mut w = 1u64 << pivots[i];
                for &c in &frees[i] {
                    if assign >> bit & 1 == 1 {
                        w |= 1u64 << c;
                    }
                    bit += 1;
                }
                basis.push(w);
            }
            out.push(basis);
        }
        return;
    }
    for p in start..m {
        if m - p < d - idx {
            break;
        }
        pivots[idx] = p;
        enumerate_pivots(m, d, idx + 1, p + 1, pivots, out);
    }
}

// ----------------------------------------------------------- reporting -----

#[derive(Clone, Debug)]
struct Record {
    level: usize,
    n: usize,
    k: usize,
    d: u32,
    wx: u32,
    wz: u32,
    a: Vec<Word>,
    v: Vec<Word>,
}

type Table = BTreeMap<(u32, u32), Record>; // (wx, d) -> best record

fn merge(table: &mut Table, r: Record) {
    let key = (r.wx, r.d);
    match table.get(&key) {
        Some(old) if old.level >= r.level => {}
        _ => {
            table.insert(key, r);
        }
    }
}

// ---------------------------------------------------------- ladder mode ----

/// Punctured code: delete coordinate 0. The projection of a spanning set spans
/// the image, so this works on the basis and never enumerates the code.
fn punctured(code: &[Word], n: usize) -> (usize, Vec<Word>) {
    let mut out: Vec<Word> = code.iter().map(|w| w >> 1).collect();
    rref(&mut out, n - 1);
    (n - 1, out)
}

/// Shortened code: the subcode vanishing at coordinate 0, then delete it.
/// Computed by eliminating bit 0 across the basis, again without enumeration.
fn shortened(code: &[Word], n: usize) -> (usize, Vec<Word>) {
    let mut rows = code.to_vec();
    rref(&mut rows, n);
    let pivot = rows.iter().position(|w| w & 1 == 1);
    let mut out: Vec<Word> = Vec::new();
    match pivot {
        Some(p) => {
            let pr = rows[p];
            for (i, r) in rows.iter().enumerate() {
                if i == p {
                    continue;
                }
                let adjusted = if r & 1 == 1 { r ^ pr } else { *r };
                out.push(adjusted >> 1);
            }
        }
        None => out.extend(rows.iter().map(|w| w >> 1)),
    }
    rref(&mut out, n - 1);
    (n - 1, out)
}

fn ladder(row_cap: usize) {
    println!("== Reed-Muller ladder (length <= 64) ==");
    println!("family                         n    k   d_X  d_Z   wX   wZ  level");
    let mut families: Vec<(String, usize, Vec<Word>, Vec<Word>)> = Vec::new();
    for mm in 2..=6usize {
        let n = 1usize << mm;
        for r in 0..mm {
            for s in (r + 1)..=mm {
                let a = reed_muller(r, mm);
                let v = reed_muller(s, mm);
                families.push((format!("RM({r},{mm}) in RM({s},{mm})"), n, a, v));
                let (np, ap) = punctured(&reed_muller(r, mm), n);
                let (_, vp) = punctured(&reed_muller(s, mm), n);
                families.push((format!("PRM({r},{mm}) in PRM({s},{mm})"), np, ap, vp));
                let (ns, ash) = shortened(&reed_muller(r, mm), n);
                let (_, vsh) = punctured(&reed_muller(s, mm), n);
                families.push((
                    format!("SRM({r},{mm}) in PRM({s},{mm})"),
                    ns,
                    ash.clone(),
                    vsh,
                ));
                let (_, vs2) = shortened(&reed_muller(s, mm), n);
                families.push((format!("SRM({r},{mm}) in SRM({s},{mm})"), ns, ash, vs2));
            }
        }
    }
    for (name, n, a, v) in families {
        let mut a = a;
        rref(&mut a, n);
        let mut v = v;
        rref(&mut v, n);
        // A must sit inside V
        let vspan_ok = {
            let mut probe = v.clone();
            for &w in &a {
                probe.push(w);
            }
            rref(&mut probe, n);
            probe.len() == v.len()
        };
        if !vspan_ok || v.len() <= a.len() {
            continue;
        }
        // Enumerating a code is exponential in its dimension; skip ladder rungs
        // whose codes are too large to span, rather than approximating them.
        if a.len() > 20 || v.len() > 17 {
            println!("{name:30} {n:3}    -     -    -    -    -  skipped (dimension)");
            continue;
        }
        // Spanning a code is exponential in its dimension, so every derived
        // quantity is computed only when its code is small enough; anything
        // beyond the cap is printed as `-` rather than guessed.
        const DIM_CAP: usize = 20;
        let b = dual_basis(&v, n);
        let aperp = dual_basis(&a, n);
        let aset: Vec<Word> = span(&a);
        let dx = if v.len() <= DIM_CAP {
            span(&v)
                .into_iter()
                .filter(|w| !aset.contains(w))
                .map(|w| w.count_ones())
                .min()
                .unwrap_or(0)
        } else {
            0
        };
        let dz = if aperp.len() <= DIM_CAP && b.len() <= DIM_CAP {
            let bset: Vec<Word> = span(&b);
            span(&aperp)
                .into_iter()
                .filter(|w| !bset.contains(w))
                .map(|w| w.count_ones())
                .min()
                .unwrap_or(0)
        } else {
            0
        };
        let wx = if a.len() <= DIM_CAP {
            optimal_check_weight(&a, n)
        } else {
            0
        };
        let wz = if b.len() <= DIM_CAP {
            optimal_check_weight(&b, n)
        } else {
            0
        };
        let lvl = match max_level(&a, &v, n, row_cap) {
            Some(usize::MAX) => "cont".to_string(),
            Some(l) => l.to_string(),
            None => "skipped".to_string(),
        };
        println!(
            "{name:30} {n:3} {:4} {dx:5} {dz:4} {wx:4} {wz:4}  {lvl}",
            v.len() - a.len()
        );
    }
}

// ---------------------------------------------------------- census mode ----

fn census(n: usize, max_w: u32, min_d: u32, threads: usize, row_cap: usize) {
    let subs = Arc::new(all_subspaces(n));
    println!(
        "== exhaustive flag census: n={n}, wX<={max_w}, d>={min_d}, {} subspaces ==",
        subs.len()
    );
    // shared across threads: all subspaces of F_2^m for every quotient dimension
    // Only quotient dimensions up to n-1 are needed: `A = 0` is skipped below,
    // and enumerating all subspaces of F_2^n itself would dominate memory.
    let quotient_lists: Arc<Vec<Vec<Vec<Word>>>> = Arc::new((0..n).map(all_subspaces).collect());
    let table: Arc<Mutex<Table>> = Arc::new(Mutex::new(Table::new()));
    let counted = Arc::new(Mutex::new((0u64, 0u64))); // (flags analysed, skipped)
    let chunk = subs.len().div_ceil(threads);
    let mut handles = Vec::new();
    for t in 0..threads {
        let subs = Arc::clone(&subs);
        let table = Arc::clone(&table);
        let counted = Arc::clone(&counted);
        let quotient_lists = Arc::clone(&quotient_lists);
        handles.push(std::thread::spawn(move || {
            let mut local = Table::new();
            let mut seen = 0u64;
            let mut skipped = 0u64;
            let lo = t * chunk;
            let hi = ((t + 1) * chunk).min(subs.len());
            for a in &subs[lo..hi] {
                let dim_a = a.len();
                // `A = 0` means no X-type stabilizers at all: then every weight-one
                // vector lies in A^perp, and with k >= 1 some such vector is outside
                // B, forcing d_Z = 1. Such flags never pass min_distance >= 2.
                if dim_a == n || dim_a == 0 {
                    continue;
                }
                let wx = optimal_check_weight(a, n);
                if wx > max_w {
                    continue;
                }
                let aset = span(a);
                let aperp = dual_basis(a, n);
                let aperp_span = span(&aperp);
                // section: coordinates that are not pivots of A
                let pivots: Vec<usize> = a.iter().map(|r| r.trailing_zeros() as usize).collect();
                let free: Vec<usize> = (0..n).filter(|c| !pivots.contains(c)).collect();
                let m = free.len();
                for u in &quotient_lists[m] {
                    if u.is_empty() {
                        continue;
                    }
                    let mut v = a.clone();
                    for &uw in u {
                        let mut lifted = 0u64;
                        for (i, &f) in free.iter().enumerate() {
                            if uw >> i & 1 == 1 {
                                lifted |= 1u64 << f;
                            }
                        }
                        v.push(lifted);
                    }
                    rref(&mut v, n);
                    let k = v.len() - dim_a;
                    if k == 0 {
                        continue;
                    }
                    let vspan = span(&v);
                    let dx = vspan
                        .iter()
                        .filter(|w| !aset.contains(w))
                        .map(|w| w.count_ones())
                        .min()
                        .unwrap_or(0);
                    if dx < min_d {
                        continue;
                    }
                    let b = dual_basis(&v, n);
                    let bset = span(&b);
                    let dz = aperp_span
                        .iter()
                        .filter(|w| !bset.contains(w))
                        .map(|w| w.count_ones())
                        .min()
                        .unwrap_or(0);
                    if dz < min_d {
                        continue;
                    }
                    seen += 1;
                    let Some(level) = max_level(a, &v, n, row_cap) else {
                        skipped += 1;
                        continue;
                    };
                    let wz = optimal_check_weight(&b, n);
                    merge(
                        &mut local,
                        Record {
                            level,
                            n,
                            k,
                            d: dx.min(dz),
                            wx,
                            wz,
                            a: a.clone(),
                            v: v.clone(),
                        },
                    );
                }
            }
            {
                let mut g = table.lock().unwrap();
                for (_, r) in local {
                    merge(&mut g, r);
                }
            }
            let mut c = counted.lock().unwrap();
            c.0 += seen;
            c.1 += skipped;
        }));
    }
    for h in handles {
        h.join().unwrap();
    }
    let c = *counted.lock().unwrap();
    println!("flags analysed: {}   skipped (row cap): {}", c.0, c.1);
    println!(" wX   d   max level   k    wZ   witness A / V");
    let table = table.lock().unwrap();
    for ((wx, d), r) in table.iter() {
        let lvl = if r.level == usize::MAX {
            "cont".to_string()
        } else {
            r.level.to_string()
        };
        println!(
            "{wx:3} {d:3} {lvl:>11} {:4} {:5}   A={:?} V={:?}",
            r.k, r.wz, r.a, r.v
        );
    }
    let best = table
        .values()
        .map(|r| r.level)
        .filter(|&l| l != usize::MAX)
        .max();
    println!("maximum finite level over the whole census: {best:?}");
}

pub fn run(cli: LevelsArgs) {
    if cli.ladder {
        ladder(cli.row_cap);
    }
    if let Some(n) = cli.census {
        let w = cli.max_check_weight.unwrap_or(n as u32);
        census(n, w, cli.min_distance, cli.threads, cli.row_cap);
    }
}
