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

use std::fmt::Write as _;

use anyhow::{bail, Context, Result};
use ergodis::field::Prime;
use ergodis::group_action::GeneratorClosureWorkspace;
use ergodis::matrix::Matrix;
use ergodis::projective::ProjectiveIndex;
use ergodis_private::prs::{quadratic_type, rank_of, sym_power, Field};

#[derive(clap::Args, Debug)]
pub struct DeepholeArgs {
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
    /// Sweep only the arithmetic-progression stratum {s : s_i = 0 unless i ≡ A mod M}
    /// instead of running a full PG(d,q) orbit census.  Requires --stratum-class.
    #[arg(long)]
    stratum_mod: Option<usize>,
    /// Residue class A for --stratum-mod.
    #[arg(long, default_value_t = 0)]
    stratum_class: usize,
    /// Output JSON path.
    #[arg(long)]
    out: Option<String>,
    /// Maximum number of top-weight orbit representatives to print in JSON.
    #[arg(long, default_value_t = 64)]
    max_reps: usize,
}

// ---------------------------------------------------------------------------
// group action: d-th symmetric power of a 2x2 matrix
// ---------------------------------------------------------------------------

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

/// Exact weight sweep of the arithmetic-progression stratum
/// `{ s : s_i = 0 unless i ≡ a (mod m) }`, the fixed locus in `PG(d,q)` of the
/// order-`m` diagonal torus element `t ↦ ζ_m t` (present when `m | q-1`).  It is
/// a projective subspace of dimension `|idx| - 1`, so it can be swept exactly at
/// field orders far beyond the reach of a full `PG(d,q)` census.  A point here
/// of weight `d` whose consecutive three-row catalecticant has rank ≥ 3 is an
/// exceptional deep hole.
fn stratum_sweep(
    f: &Field,
    d: usize,
    r: usize,
    k: usize,
    m: usize,
    a: usize,
    out: Option<&str>,
) -> Result<()> {
    if m == 0 {
        bail!("--stratum-mod must be positive");
    }
    let idx: Vec<usize> = (0..=d).filter(|i| i % m == a % m).collect();
    if idx.is_empty() {
        bail!("empty stratum: no coordinate index is ≡ {a} mod {m}");
    }
    let q = f.q;
    let l = idx.len();
    let mut hist = vec![0usize; d + 2];
    let mut deep = 0usize;
    let mut exceptional: Vec<Vec<u8>> = Vec::new();
    let mut s = vec![0u8; d + 1];
    let mut tail = vec![0u8; l];

    // enumerate leading-one normal forms of PG(l-1, q)
    for lead in 0..l {
        let free = l - lead - 1;
        let count = (q as u64).pow(free as u32);
        for code in 0..count {
            for item in tail.iter_mut() {
                *item = 0;
            }
            tail[lead] = 1;
            let mut c = code;
            for j in (lead + 1..l).rev() {
                tail[j] = (c % q as u64) as u8;
                c /= q as u64;
            }
            for item in s.iter_mut() {
                *item = 0;
            }
            for (&i, &v) in idx.iter().zip(tail.iter()) {
                s[i] = v;
            }
            let mut w = d + 1;
            for j in 1..=d {
                if find_split_annihilator(f, d, &s, j).is_some() {
                    w = j;
                    break;
                }
            }
            hist[w] += 1;
            if w == d {
                deep += 1;
                // consecutive three-row catalecticant, 3 x (d-1)
                let rows = 3usize;
                let cols = d - 1;
                let mut data = vec![0u8; rows * cols];
                for v in 0..rows {
                    for u in 0..cols {
                        data[v * cols + u] = s[u + v];
                    }
                }
                if rank_of(f, rows, cols, &mut data) >= 3 && exceptional.len() < 4096 {
                    exceptional.push(s.clone());
                }
            }
        }
    }

    let stratum_points: u64 = ((q as u64).pow(l as u32) - 1) / (q as u64 - 1);
    let mut json = String::new();
    write!(
        json,
        "{{\"mode\":\"stratum\",\"q\":{},\"p\":{},\"n\":{},\"k\":{},\"r\":{},\"d\":{},\
\"stratum_mod\":{},\"stratum_class\":{},\"stratum_indices\":{:?},\"stratum_points\":{},\
\"deep_in_stratum\":{},\"exceptional_in_stratum\":{},\"weight_histogram\":[",
        q,
        f.p,
        q + 1,
        k,
        r,
        d,
        m,
        a,
        idx,
        stratum_points,
        deep,
        exceptional.len()
    )?;
    for w in 0..=(d + 1) {
        if w > 0 {
            json.push(',');
        }
        write!(json, "{{\"w\":{},\"points\":{}}}", w, hist[w])?;
    }
    json.push_str("],\"exceptional_examples\":[");
    for (i, e) in exceptional.iter().take(256).enumerate() {
        if i > 0 {
            json.push(',');
        }
        write!(json, "{e:?}")?;
    }
    json.push_str("]}");
    if let Some(path) = out {
        std::fs::write(path, format!("{json}\n"))?;
    }
    println!("{json}");
    Ok(())
}

pub fn run(args: DeepholeArgs) -> Result<()> {
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
    let proj = ProjectiveIndex::new(
        &f.inner,
        u8::try_from(d).context("projective dimension exceeds u8")?,
    )?;
    let k = q + 1 - r;
    if k < 1 {
        bail!("dimension k = q+1-r must be positive");
    }

    if let Some(m) = args.stratum_mod {
        return stratum_sweep(&f, d, r, k, m, args.stratum_class, args.out.as_deref());
    }

    // group generators of PGL(2,q): a -> a+1, a -> g a, a -> 1/a
    let g = f.primitive();
    let mut gens: Vec<Vec<Vec<u8>>> = Vec::new();
    gens.push(sym_power(&f, d, 1, 0, 1, 1)); // (x,y) -> (x, x+y)   i.e. a -> a+1
    gens.push(sym_power(&f, d, 1, 0, 0, g)); // a -> g a
    gens.push(sym_power(&f, d, 0, 1, 1, 0)); // a -> 1/a
    let frobenius = args.semilinear && f.h > 1;

    let n = usize::try_from(proj.point_count()).context("projective space exceeds usize")?;
    let mut weight = vec![0u8; n]; // 0 = unvisited
    let mut records: Vec<OrbitRecord> = Vec::new();
    let mut hist = vec![0usize; d + 2];

    let mut buf = vec![0u8; d + 1];
    let mut img = vec![0u8; d + 1];
    let point_count = u32::try_from(n).context("projective space exceeds u32")?;
    let mut closure_workspace = GeneratorClosureWorkspace::new(point_count);

    let mut crosscheck_done = 0usize;
    let mut crosscheck_ok = true;

    for start in 0..n {
        if weight[start] != 0 {
            continue;
        }
        proj.point(start as u64, &mut buf)?;
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
        let generator_count = gens.len() as u32 + u32::from(frobenius);
        let orbit_size = closure_workspace
            .visit_with(
                point_count,
                generator_count,
                &[start as u32],
                |point| {
                    let label = &mut weight[point as usize];
                    if *label != 0 {
                        return false;
                    }
                    *label = wv;
                    true
                },
                |generator, point| {
                    proj.point(u64::from(point), &mut buf)?;
                    if let Some(gen) = gens.get(generator as usize) {
                        apply(&f, gen, &buf, &mut img);
                    } else {
                        debug_assert!(frobenius);
                        for i in 0..=d {
                            img[i] = f.pow(buf[i], f.p);
                        }
                    }
                    Ok::<u32, ergodis::projective::ProjectiveError>(proj.index(&img)? as u32)
                },
            )?
            .len();
        hist[info.w] += orbit_size;
        proj.point(start as u64, &mut buf)?;
        records.push(OrbitRecord {
            weight: info.w,
            size: orbit_size,
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
        f.inner.modulus(),
        q + 1,
        k,
        r,
        d,
        if frobenius {
            "PGammaL(2,q)"
        } else {
            "PGL(2,q)"
        },
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
