//! C43 — compiled orbit-canon solver for the cap achievement game on PG(m,q).
//!
//! Sizing (notes/2026-07-09-codex-pg43-sizing.md) showed PG(4,3) has ~10^13 raw caps but
//! only a few thousand PGL(5,3)-orbits, so a solve is feasible with an orbit-canon memo;
//! the wall is canonicalization throughput, which Python could not clear past k~9. This is
//! the Rust port.
//!
//! Game: board = points of PG(m,q); a position is a cap (no 3 collinear); a move adds a
//! point keeping the cap property; normal play (no move => lose). Outcome P = 2nd-player
//! win (root value 0), N = 1st-player win.
//!
//! Canonicalization (sound, validated in the Python probe): project a cap onto its span
//! (dim r; rank r is a PGL invariant), then canonicalize in PG(r-1,q):
//!   - frame-min: PGL is sharply transitive on frames (r+1 general-position points), so
//!     minimizing the embedded image bitmask over all frames in the cap is a complete
//!     canonical form. Used whenever the cap contains a frame ("contains a frame" is
//!     orbit-invariant).
//!   - torus fallback (frameless / k<=r caps): map an independent r-subset to the standard
//!     basis, minimize over the residual projective torus (q-1)^{r-1}.
//! Key = (rank, method, image bitmask over embedded PG(dim-1,q)). Exact; no hash collisions.
//!
//! Build:  rustc -O -C target-cpu=native 2026-07-09-pg43-solver.rs -o /tmp/pg43
//! Usage:  pg43 validate            # calibration ladder + orbit counts
//!         pg43 solve <m> <q> [wall_s] [memcap]
//!         pg43 orbit <m> <q> <maxk> [wall_s]

use std::collections::HashMap;
use std::env;
use std::time::Instant;

const MAXD: usize = 6;
type Vec6 = [u8; MAXD];

#[derive(Clone)]
struct GF {
    q: u8,
    inv: Vec<u8>,
}
impl GF {
    fn new(q: u8) -> GF {
        let mut inv = vec![0u8; q as usize];
        for a in 1..q {
            for b in 1..q {
                if (a * b) % q == 1 {
                    inv[a as usize] = b;
                }
            }
        }
        GF { q, inv }
    }
    #[inline]
    fn add(&self, a: u8, b: u8) -> u8 {
        (a + b) % self.q
    }
    #[inline]
    fn sub(&self, a: u8, b: u8) -> u8 {
        (a + self.q - b) % self.q
    }
    #[inline]
    fn mul(&self, a: u8, b: u8) -> u8 {
        (a * b) % self.q
    }
}

struct Board {
    gf: GF,
    dim: usize, // m+1
    n: usize,
    pts: Vec<Vec6>,
    vidx: Vec<i32>, // encode(vec) -> point index or -1
    lines: Vec<u128>,
    hps: Vec<u128>,
}

fn encode(v: &Vec6, q: u8, dim: usize) -> usize {
    let mut e = 0usize;
    let mut p = 1usize;
    for i in 0..dim {
        e += (v[i] as usize) * p;
        p *= q as usize;
    }
    e
}

fn vcanon(v: &Vec6, gf: &GF, dim: usize) -> Option<Vec6> {
    for i in 0..dim {
        if v[i] != 0 {
            let iv = gf.inv[v[i] as usize];
            let mut out = [0u8; MAXD];
            for j in 0..dim {
                out[j] = gf.mul(iv, v[j]);
            }
            return Some(out);
        }
    }
    None
}

impl Board {
    fn build(m: usize, q: u8) -> Board {
        let gf = GF::new(q);
        let dim = m + 1;
        let qq = q as usize;
        let total = qq.pow(dim as u32);
        // enumerate canonical points
        let mut reps: Vec<Vec6> = Vec::new();
        let mut seen = std::collections::HashSet::new();
        for code in 0..total {
            let mut v = [0u8; MAXD];
            let mut c = code;
            let mut any = false;
            for i in 0..dim {
                v[i] = (c % qq) as u8;
                if v[i] != 0 {
                    any = true;
                }
                c /= qq;
            }
            if !any {
                continue;
            }
            if let Some(cv) = vcanon(&v, &gf, dim) {
                let key = encode(&cv, q, dim);
                if seen.insert(key) {
                    reps.push(cv);
                }
            }
        }
        reps.sort_by_key(|v| encode(v, q, dim));
        let n = reps.len();
        let mut vidx = vec![-1i32; total];
        for (i, v) in reps.iter().enumerate() {
            vidx[encode(v, q, dim)] = i as i32;
        }
        // lines
        let mut lines = vec![0u128; n * n];
        for i in 0..n {
            for j in (i + 1)..n {
                let mut mij = 0u128;
                for a in 0..q {
                    for b in 0..q {
                        if a == 0 && b == 0 {
                            continue;
                        }
                        let mut v = [0u8; MAXD];
                        for k in 0..dim {
                            v[k] = gf.add(gf.mul(a, reps[i][k]), gf.mul(b, reps[j][k]));
                        }
                        if let Some(cv) = vcanon(&v, &gf, dim) {
                            let idx = vidx[encode(&cv, q, dim)];
                            if idx >= 0 {
                                mij |= 1u128 << idx;
                            }
                        }
                    }
                }
                lines[i * n + j] = mij;
                lines[j * n + i] = mij;
            }
        }
        // hyperplanes: functionals up to scale = same reps
        let mut hps = vec![0u128; n];
        for (f_i, f) in reps.iter().enumerate() {
            let mut mk = 0u128;
            for (i, p) in reps.iter().enumerate() {
                let mut s = 0u8;
                for k in 0..dim {
                    s = gf.add(s, gf.mul(f[k], p[k]));
                }
                if s == 0 {
                    mk |= 1u128 << i;
                }
            }
            hps[f_i] = mk;
        }
        Board { gf, dim, n, pts: reps, vidx, lines, hps }
    }
}

// ---- small linear algebra over GF(q), runtime n x n ----
fn mat_inv(a: &[[u8; MAXD]], n: usize, gf: &GF) -> Option<Vec<[u8; MAXD]>> {
    // augmented [A | I]
    let mut m = vec![[0u8; 2 * MAXD]; n];
    for i in 0..n {
        for j in 0..n {
            m[i][j] = a[i][j];
        }
        m[i][n + i] = 1;
    }
    for col in 0..n {
        let mut piv = None;
        for r in col..n {
            if m[r][col] != 0 {
                piv = Some(r);
                break;
            }
        }
        let piv = piv?;
        m.swap(col, piv);
        let iv = gf.inv[m[col][col] as usize];
        for j in 0..2 * n {
            m[col][j] = gf.mul(iv, m[col][j]);
        }
        for r in 0..n {
            if r != col && m[r][col] != 0 {
                let f = m[r][col];
                for j in 0..2 * n {
                    m[r][j] = gf.sub(m[r][j], gf.mul(f, m[col][j]));
                }
            }
        }
    }
    let mut out = vec![[0u8; MAXD]; n];
    for i in 0..n {
        for j in 0..n {
            out[i][j] = m[i][n + j];
        }
    }
    Some(out)
}

#[inline]
fn mv(m: &[[u8; MAXD]], v: &Vec6, n: usize, gf: &GF) -> Vec6 {
    let mut out = [0u8; MAXD];
    for i in 0..n {
        let mut s = 0u8;
        for k in 0..n {
            if m[i][k] != 0 && v[k] != 0 {
                s = gf.add(s, gf.mul(m[i][k], v[k]));
            }
        }
        out[i] = s;
    }
    out
}

fn rank_of(rows: &[Vec6], n: usize, gf: &GF) -> usize {
    let mut m: Vec<Vec6> = rows.to_vec();
    let r_ct = m.len();
    let mut rank = 0usize;
    let mut col = 0usize;
    while rank < r_ct && col < n {
        let mut piv = None;
        for r in rank..r_ct {
            if m[r][col] != 0 {
                piv = Some(r);
                break;
            }
        }
        match piv {
            None => {
                col += 1;
                continue;
            }
            Some(p) => {
                m.swap(rank, p);
                let iv = gf.inv[m[rank][col] as usize];
                for j in 0..n {
                    m[rank][j] = gf.mul(iv, m[rank][j]);
                }
                for r in 0..r_ct {
                    if r != rank && m[r][col] != 0 {
                        let f = m[r][col];
                        for j in 0..n {
                            m[r][j] = gf.sub(m[r][j], gf.mul(f, m[rank][j]));
                        }
                    }
                }
                rank += 1;
                col += 1;
            }
        }
    }
    rank
}

// SplitMix64 finalizer — a fast avalanche hash used for the WL color signatures.
#[inline]
fn mix64(x: u64) -> u64 {
    let mut z = x.wrapping_add(0x9e3779b97f4a7c15);
    z = (z ^ (z >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
    z = (z ^ (z >> 27)).wrapping_mul(0x94d049bb133111eb);
    z ^ (z >> 31)
}

// first color class (by ascending color value) of size >1, as a list of point indices;
// empty if the coloring is discrete. `order` must be indices sorted by color.
fn first_nonsingleton(order: &[usize], col: &[u64]) -> Vec<usize> {
    let k = order.len();
    let mut i = 0;
    while i < k {
        let mut j = i + 1;
        while j < k && col[order[j]] == col[order[i]] {
            j += 1;
        }
        if j - i > 1 {
            return order[i..j].to_vec();
        }
        i = j;
    }
    Vec::new()
}

struct Canon<'a> {
    b: &'a Board,
}
impl<'a> Canon<'a> {
    // Project S onto its span; returns (r, coords in a basis of the span, embedded as
    // Vec6 with first r entries used).
    fn project(&self, s: &[usize]) -> (usize, Vec<Vec6>) {
        let gf = &self.b.gf;
        let dim = self.b.dim;
        let mut basis: Vec<Vec6> = Vec::new();
        for &i in s {
            let v = self.b.pts[i];
            let mut trial = basis.clone();
            trial.push(v);
            if rank_of(&trial, dim, gf) > basis.len() {
                basis.push(v);
            }
        }
        let r = basis.len();
        // complete to full dim basis with standard e_i
        let mut full = basis.clone();
        let mut ei = 0usize;
        while full.len() < dim {
            let mut cand = [0u8; MAXD];
            cand[ei] = 1;
            ei += 1;
            let mut trial = full.clone();
            trial.push(cand);
            if rank_of(&trial, dim, gf) > full.len() {
                full.push(cand);
            }
        }
        // A columns = full basis vecs; invert; coords = first r of Ainv * point
        let mut a = [[0u8; MAXD]; MAXD];
        for c in 0..dim {
            for row in 0..dim {
                a[row][c] = full[c][row];
            }
        }
        let ainv = mat_inv(&a, dim, gf).unwrap();
        let mut coords = Vec::with_capacity(s.len());
        for &i in s {
            let w = mv(&ainv, &self.b.pts[i], dim, gf);
            let mut c = [0u8; MAXD];
            for t in 0..r {
                c[t] = w[t];
            }
            coords.push(c);
        }
        (r, coords)
    }

    // embed an r-dim vector into PG(dim-1,q) index (first r coords), canonicalized
    #[inline]
    fn emb_idx(&self, w: &Vec6) -> i32 {
        let cv = vcanon(w, &self.b.gf, self.b.dim).unwrap();
        self.b.vidx[encode(&cv, self.b.gf.q, self.b.dim)]
    }

    // Aut(S)-invariant point coloring: color[i] = rank (in lex order over the cap) of the
    // hyperplane-incidence profile of coords[i] — the sorted multiset over functionals f of
    // the r-dim span with f.coords[i]=0 of |{j : f.coords[j]=0}|. Basis-independent and
    // PGL-invariant, so restricting the frame search to minimum-color candidates keeps the
    // canonical form invariant (hence complete) while collapsing to few frames.
    // point-hyperplane incidence in the span: (inc[h] = points on hyperplane h,
    // pth[j] = hyperplanes through point j).
    fn incidence(&self, coords: &[Vec6], r: usize) -> (Vec<Vec<usize>>, Vec<Vec<usize>>) {
        let gf = &self.b.gf;
        let q = gf.q;
        let k = coords.len();
        let total = (q as usize).pow(r as u32);
        let mut funcs: Vec<Vec6> = Vec::new();
        let mut seen = std::collections::HashSet::new();
        for code in 0..total {
            let mut v = [0u8; MAXD];
            let mut c = code;
            let mut any = false;
            for i in 0..r {
                v[i] = (c % q as usize) as u8;
                if v[i] != 0 {
                    any = true;
                }
                c /= q as usize;
            }
            if !any {
                continue;
            }
            if let Some(cv) = vcanon(&v, gf, r) {
                if seen.insert(encode(&cv, q, r)) {
                    funcs.push(cv);
                }
            }
        }
        let hn = funcs.len();
        let mut inc: Vec<Vec<usize>> = vec![Vec::new(); hn];
        let mut pth: Vec<Vec<usize>> = vec![Vec::new(); k];
        for (h, f) in funcs.iter().enumerate() {
            for j in 0..k {
                let mut s = 0u8;
                for t in 0..r {
                    s = gf.add(s, gf.mul(f[t], coords[j][t]));
                }
                if s == 0 {
                    inc[h].push(j);
                    pth[j].push(h);
                }
            }
        }
        (inc, pth)
    }

    // Weisfeiler-Leman refinement of `init` point-coloring on the point-hyperplane
    // incidence to a stable partition. Colors are u64 hashes of the (invariant) refinement
    // signatures — a commutative (order-independent) multiset hash of neighbour colors — so
    // the coloring is PGL-invariant. Hash collisions only coarsen the partition (never break
    // invariance), affecting speed, not correctness.
    fn wl_refine(&self, k: usize, inc: &[Vec<usize>], pth: &[Vec<usize>], init: &[u64]) -> Vec<u64> {
        let hn = inc.len();
        let mut pc: Vec<u64> = init.iter().map(|&x| mix64(x.wrapping_add(1))).collect();
        let mut hc: Vec<u64> = inc.iter().map(|v| mix64(v.len() as u64 + 1)).collect();
        let mut prev = 0usize;
        for _ in 0..(k + 2) {
            let newpc: Vec<u64> = (0..k)
                .map(|i| {
                    let acc = pth[i]
                        .iter()
                        .fold(0u64, |a, &h| a.wrapping_add(mix64(hc[h])));
                    mix64(pc[i].wrapping_mul(0x100000001b3).wrapping_add(acc))
                })
                .collect();
            hc = (0..hn)
                .map(|h| {
                    let acc = inc[h]
                        .iter()
                        .fold(0u64, |a, &i| a.wrapping_add(mix64(newpc[i])));
                    mix64(hc[h].wrapping_mul(0x100000001b3).wrapping_add(acc))
                })
                .collect();
            let cnt = {
                let mut d = newpc.clone();
                d.sort_unstable();
                d.dedup();
                d.len()
            };
            pc = newpc;
            if cnt == prev {
                break;
            }
            prev = cnt;
        }
        pc
    }

    // Individualization-refinement canonical image: refine; if discrete, build the frame
    // from the color order and record the image; else individualize each point of the first
    // non-singleton cell and recurse, taking the min image (invariant canonical form).
    #[allow(clippy::too_many_arguments)]
    fn ir(
        &self,
        coords: &[Vec6],
        r: usize,
        k: usize,
        inc: &[Vec<usize>],
        pth: &[Vec<usize>],
        coloring: &[u64],
        best: &mut Option<u128>,
    ) {
        let col = self.wl_refine(k, inc, pth, coloring);
        let mut order: Vec<usize> = (0..k).collect();
        order.sort_by_key(|&i| col[i]);
        let cell = first_nonsingleton(&order, &col);
        if cell.is_empty() {
            if let Some(bm) = self.image_from_order(coords, r, k, &order) {
                match best {
                    Some(bv) if *bv <= bm => {}
                    _ => *best = Some(bm),
                }
            }
        } else {
            for &v in &cell {
                let mut nc = col.clone();
                nc[v] = 1; // individualize (fixed marker; distinct from the hash colors)
                self.ir(coords, r, k, inc, pth, &nc, best);
            }
        }
    }

    // Greedy single-frame key for the SOLVE: refine, then greedily individualize ONE point
    // of the first non-singleton cell (no min-over-branches), recurse to a discrete coloring,
    // build one frame. This is SOUND as a memo key — the image is a genuine orbit member, so
    // different orbits never collide (no wrong game value); it only OVER-splits symmetric caps
    // (a few extra nodes) in exchange for O(k) refinements instead of exponential IR branching.
    fn ir_greedy(
        &self,
        coords: &[Vec6],
        r: usize,
        k: usize,
        inc: &[Vec<usize>],
        pth: &[Vec<usize>],
        coloring: &[u64],
    ) -> u128 {
        let col = self.wl_refine(k, inc, pth, coloring);
        let mut order: Vec<usize> = (0..k).collect();
        order.sort_by_key(|&i| col[i]);
        let cell = first_nonsingleton(&order, &col);
        if cell.is_empty() {
            self.image_basis_only(coords, r, k, &order)
        } else {
            let mut nc = col.clone();
            nc[cell[0]] = 1; // individualize one member (greedy: no min over branches)
            self.ir_greedy(coords, r, k, inc, pth, &nc)
        }
    }

    fn key_solve(&self, s: &[usize]) -> (u8, u128) {
        if s.is_empty() {
            return (0, 0);
        }
        let (r, coords) = self.project(s);
        let (inc, pth) = self.incidence(&coords, r);
        let init = vec![0u64; coords.len()];
        (
            (r as u8) << 1,
            self.ir_greedy(&coords, r, coords.len(), &inc, &pth, &init),
        )
    }

    // Unit-free sound image for the SOLVE key: map the first r independent points (in the
    // canonical order) to the standard basis e_0..e_{r-1} and take the sorted embedded image.
    // Always defined (rank r ⇒ r independent points exist), and SOUND — it is g(S) for a real
    // projectivity g, so it never merges inequivalent caps. It is pinned only up to the torus
    // (≤(q−1)^{r−1} over-split), which costs a few extra memo nodes but no wrong values, and
    // avoids the expensive frame-unit search / torus fallback entirely.
    fn image_basis_only(&self, coords: &[Vec6], r: usize, k: usize, order: &[usize]) -> u128 {
        let gf = &self.b.gf;
        let mut basis: Vec<usize> = Vec::new();
        for &i in order {
            if basis.len() == r {
                break;
            }
            let mut rows: Vec<Vec6> = basis.iter().map(|&bi| coords[bi]).collect();
            rows.push(coords[i]);
            if rank_of(&rows, r, gf) > basis.len() {
                basis.push(i);
            }
        }
        let mut a = [[0u8; MAXD]; MAXD];
        for c in 0..r {
            for row in 0..r {
                a[row][c] = coords[basis[c]][row];
            }
        }
        let ainv = mat_inv(&a, r, gf).unwrap();
        let mut bm = 0u128;
        for j in 0..k {
            let w = mv(&ainv, &coords[j], r, gf);
            bm |= 1u128 << self.emb_idx(&w);
        }
        bm
    }

    // build the frame from a canonical point order and return the image bitmask (None if
    // the order yields no general-position unit, i.e. a frameless cap).
    fn image_from_order(&self, coords: &[Vec6], r: usize, k: usize, order: &[usize]) -> Option<u128> {
        let gf = &self.b.gf;
        let mut basis: Vec<usize> = Vec::new();
        for &i in order {
            if basis.len() == r {
                break;
            }
            let mut rows: Vec<Vec6> = basis.iter().map(|&bi| coords[bi]).collect();
            rows.push(coords[i]);
            if rank_of(&rows, r, gf) > basis.len() {
                basis.push(i);
            }
        }
        if basis.len() < r {
            return None;
        }
        let mut a = [[0u8; MAXD]; MAXD];
        for c in 0..r {
            for row in 0..r {
                a[row][c] = coords[basis[c]][row];
            }
        }
        let ainv = mat_inv(&a, r, gf)?;
        let mut unit = None;
        for &i in order {
            if basis.contains(&i) {
                continue;
            }
            let c = mv(&ainv, &coords[i], r, gf);
            if (0..r).all(|t| c[t] != 0) {
                unit = Some((i, c));
                break;
            }
        }
        let (_, c) = unit?;
        let mut m = [[0u8; MAXD]; MAXD];
        for i in 0..r {
            let di = gf.inv[c[i] as usize];
            for col in 0..r {
                m[i][col] = gf.mul(di, ainv[i][col]);
            }
        }
        let mut bm = 0u128;
        for j in 0..k {
            let w = mv(&m, &coords[j], r, gf);
            bm |= 1u128 << self.emb_idx(&w);
        }
        Some(bm)
    }

    // color-restricted frame-min: minimize embedded image bitmask over ordered (r+1)-frames
    // whose basis/unit points are, at each step, of MINIMUM color among the legal candidates.
    // None if no frame exists (frameless cap).
    fn frame_min(&self, coords: &[Vec6], r: usize, colors: &[u32]) -> Option<u128> {
        let gf = &self.b.gf;
        let k = coords.len();
        let mut best: Option<u128> = None;
        let mut basis_idx = vec![0usize; r];
        self.frame_rec(coords, r, k, 0, &mut basis_idx, gf, colors, &mut best);
        best
    }

    #[allow(clippy::too_many_arguments)]
    fn frame_rec(
        &self,
        coords: &[Vec6],
        r: usize,
        k: usize,
        depth: usize,
        basis_idx: &mut Vec<usize>,
        gf: &GF,
        colors: &[u32],
        best: &mut Option<u128>,
    ) {
        if depth == r {
            let mut a = [[0u8; MAXD]; MAXD];
            for c in 0..r {
                for row in 0..r {
                    a[row][c] = coords[basis_idx[c]][row];
                }
            }
            let ainv = match mat_inv(&a, r, gf) {
                Some(x) => x,
                None => return,
            };
            // unit candidates: not in basis, general position; restrict to min color
            let mut umin = u32::MAX;
            let mut units: Vec<usize> = Vec::new();
            for u in 0..k {
                if basis_idx[..r].contains(&u) {
                    continue;
                }
                let c = mv(&ainv, &coords[u], r, gf);
                if (0..r).any(|i| c[i] == 0) {
                    continue;
                }
                if colors[u] < umin {
                    umin = colors[u];
                    units.clear();
                    units.push(u);
                } else if colors[u] == umin {
                    units.push(u);
                }
            }
            for &u in &units {
                let cu = mv(&ainv, &coords[u], r, gf);
                let mut m = [[0u8; MAXD]; MAXD];
                for i in 0..r {
                    let di = gf.inv[cu[i] as usize];
                    for col in 0..r {
                        m[i][col] = gf.mul(di, ainv[i][col]);
                    }
                }
                let mut bm = 0u128;
                for j in 0..k {
                    let w = mv(&m, &coords[j], r, gf);
                    bm |= 1u128 << self.emb_idx(&w);
                }
                match best {
                    Some(bv) if *bv <= bm => {}
                    _ => *best = Some(bm),
                }
            }
            return;
        }
        // next basis point: independent-extending, of minimum color among such
        let mut cmin = u32::MAX;
        let mut cands: Vec<usize> = Vec::new();
        for i in 0..k {
            if basis_idx[..depth].contains(&i) {
                continue;
            }
            let mut rows: Vec<Vec6> = (0..depth).map(|d| coords[basis_idx[d]]).collect();
            rows.push(coords[i]);
            if rank_of(&rows, r, gf) > depth {
                if colors[i] < cmin {
                    cmin = colors[i];
                    cands.clear();
                    cands.push(i);
                } else if colors[i] == cmin {
                    cands.push(i);
                }
            }
        }
        for &i in &cands {
            basis_idx[depth] = i;
            self.frame_rec(coords, r, k, depth + 1, basis_idx, gf, colors, best);
        }
    }

    // torus canon (frameless / small caps): map ordered independent r-subset to basis,
    // min over projective torus diag(1,t_1..t_{r-1}).
    fn torus(&self, coords: &[Vec6], r: usize) -> u128 {
        let gf = &self.b.gf;
        let q = gf.q;
        let k = coords.len();
        // torus elements
        let mut tori: Vec<Vec6> = Vec::new();
        {
            let mut cur = [0u8; MAXD];
            cur[0] = 1;
            fn rec(pos: usize, r: usize, q: u8, cur: &mut Vec6, out: &mut Vec<Vec6>) {
                if pos == r {
                    out.push(*cur);
                    return;
                }
                for t in 1..q {
                    cur[pos] = t;
                    rec(pos + 1, r, q, cur, out);
                }
            }
            if r >= 1 {
                rec(1, r, q, &mut cur, &mut tori);
            }
        }
        let mut best: Option<u128> = None;
        let mut basis_idx = vec![0usize; r];
        self.torus_rec(coords, r, k, 0, &mut basis_idx, gf, &tori, &mut best);
        best.unwrap()
    }

    fn torus_rec(
        &self,
        coords: &[Vec6],
        r: usize,
        k: usize,
        depth: usize,
        basis_idx: &mut Vec<usize>,
        gf: &GF,
        tori: &[Vec6],
        best: &mut Option<u128>,
    ) {
        if depth == r {
            let mut a = [[0u8; MAXD]; MAXD];
            for c in 0..r {
                for row in 0..r {
                    a[row][c] = coords[basis_idx[c]][row];
                }
            }
            let ainv = match mat_inv(&a, r, gf) {
                Some(x) => x,
                None => return,
            };
            let base_img: Vec<Vec6> = (0..k).map(|j| mv(&ainv, &coords[j], r, gf)).collect();
            for t in tori {
                let mut bm = 0u128;
                for w in &base_img {
                    let mut ww = [0u8; MAXD];
                    for i in 0..r {
                        ww[i] = gf.mul(t[i], w[i]);
                    }
                    let ci = self.emb_idx(&ww);
                    bm |= 1u128 << ci;
                }
                match best {
                    Some(bv) if *bv <= bm => {}
                    _ => *best = Some(bm),
                }
            }
            return;
        }
        for i in 0..k {
            if basis_idx[..depth].contains(&i) {
                continue;
            }
            let mut rows: Vec<Vec6> = (0..depth).map(|d| coords[basis_idx[d]]).collect();
            rows.push(coords[i]);
            if rank_of(&rows, r, gf) > depth {
                basis_idx[depth] = i;
                self.torus_rec(coords, r, k, depth + 1, basis_idx, gf, tori, best);
            }
        }
    }

    // UNRESTRICTED frame-min (all ordered frames): unconditionally complete canonical
    // form, gold standard for validating the color-restricted key. Slow.
    fn key_exact(&self, s: &[usize]) -> (u8, u128) {
        if s.is_empty() {
            return (0, 0);
        }
        let (r, coords) = self.project(s);
        let all1: Vec<u32> = vec![0u32; coords.len()]; // all one color = no restriction
        if let Some(bm) = self.frame_min(&coords, r, &all1) {
            ((r as u8) << 1, bm)
        } else {
            ((r as u8) << 1 | 1, self.torus(&coords, r))
        }
    }

    // canonical key: (rank<<1 | method, image bitmask)
    fn key(&self, s: &[usize]) -> (u8, u128) {
        if s.is_empty() {
            return (0, 0); // empty cap: the unique rank-0 orbit
        }
        let (r, coords) = self.project(s);
        let (inc, pth) = self.incidence(&coords, r);
        let mut best: Option<u128> = None;
        let init = vec![0u64; coords.len()];
        self.ir(&coords, r, coords.len(), &inc, &pth, &init, &mut best);
        match best {
            Some(bm) => ((r as u8) << 1, bm),
            None => ((r as u8) << 1 | 1, self.torus(&coords, r)), // frameless
        }
    }
}

// ---- orbit-BFS (exact orbit counts per ply), spectrum-bucketed ----
fn spectrum(chosen: u128, hps: &[u128]) -> Vec<u16> {
    let mut hist = [0u16; 130];
    for &h in hps {
        let c = (chosen & h).count_ones() as usize;
        hist[c] += 1;
    }
    let mx = (0..130).rev().find(|&j| hist[j] > 0).unwrap();
    hist[..=mx].to_vec()
}

fn orbit_bfs(m: usize, q: u8, maxk: usize, wall: f64, exact: bool) {
    let b = Board::build(m, q);
    let cz = Canon { b: &b };
    let keyf = |s: &[usize]| if exact { cz.key_exact(s) } else { cz.key(s) };
    let all: u128 = if b.n == 128 { u128::MAX } else { (1u128 << b.n) - 1 };
    let t0 = Instant::now();
    let mut cur: Vec<Vec<usize>> = vec![vec![0]];
    let mut per_ply = vec![1usize, 1];
    for depth in 1..maxk {
        let mut buckets: HashMap<Vec<u16>, Vec<(Option<(u8, u128)>, Vec<usize>)>> = HashMap::new();
        let mut timed = false;
        for slist in &cur {
            if t0.elapsed().as_secs_f64() > wall {
                timed = true;
                break;
            }
            let mut chosen = 0u128;
            for &i in slist {
                chosen |= 1u128 << i;
            }
            let mut forb = 0u128;
            for ai in 0..slist.len() {
                for bi in (ai + 1)..slist.len() {
                    forb |= b.lines[slist[ai] * b.n + slist[bi]];
                }
            }
            let mut a = all & !chosen & !forb;
            while a != 0 {
                let y = a & a.wrapping_neg();
                a ^= y;
                let yi = y.trailing_zeros() as usize;
                let mut child = slist.clone();
                child.push(yi);
                let sp = spectrum(chosen | y, &b.hps);
                let entry = buckets.entry(sp).or_default();
                if entry.is_empty() {
                    entry.push((None, child));
                } else {
                    let ck = keyf(&child);
                    let mut hit = false;
                    for e in entry.iter_mut() {
                        if e.0.is_none() {
                            e.0 = Some(keyf(&e.1));
                        }
                        if e.0 == Some(ck) {
                            hit = true;
                            break;
                        }
                    }
                    if !hit {
                        entry.push((Some(ck), child));
                    }
                }
            }
        }
        let nxt: Vec<Vec<usize>> = buckets
            .into_iter()
            .flat_map(|(_, v)| v.into_iter().map(|e| e.1))
            .collect();
        per_ply.push(nxt.len());
        println!(
            "  orbits_{:<2} = {:>10}   (cum={:.1}s, reps={})",
            depth + 1,
            nxt.len(),
            t0.elapsed().as_secs_f64(),
            cur.len()
        );
        cur = nxt;
        if timed || cur.is_empty() {
            break;
        }
    }
    println!("PG({},{}) orbits/ply={:?}", m, q, per_ply);
}

// ---- solve: orbit-canon negamax ----
struct Solver<'a> {
    b: &'a Board,
    cz: Canon<'a>,
    all: u128,
    memo: HashMap<(u8, u128), bool>,
    nodes: u64,
    deadline: Option<Instant>,
    memcap: usize,
    t0: Instant,
    report_at: f64,
    rev: bool,   // reverse move ordering (cross-check)
    use_ir: bool, // use the IR-min canon `key` instead of `key_solve` (cross-check)
}
impl<'a> Solver<'a> {
    #[inline]
    fn guard(&mut self, depth: usize) {
        if self.memo.len() > self.memcap {
            self.bail("memcap");
        }
        let el = self.t0.elapsed().as_secs_f64();
        if el >= self.report_at {
            self.report_at = el + 20.0;
            eprintln!(
                "  [progress] nodes={} states={} depth={} {:.1}s ({:.0} nodes/s)",
                self.nodes,
                self.memo.len(),
                depth,
                el,
                self.nodes as f64 / el.max(0.001)
            );
            if self.deadline.map_or(false, |d| Instant::now() > d) {
                self.bail("deadline");
            }
        }
    }
    fn bail(&self, why: &str) -> ! {
        println!(
            "PG SOLVE -> UNFINISHED  states={} nodes={} {:.1}s ({})",
            self.memo.len(),
            self.nodes,
            self.t0.elapsed().as_secs_f64(),
            why
        );
        println!("PG43_SOLVER_DONE");
        std::process::exit(2);
    }
    // value for player to move: true = win (N), false = loss (P)
    fn value(&mut self, slist: &mut Vec<usize>, chosen: u128, forb: u128) -> bool {
        let key = if self.use_ir {
            self.cz.key(slist)
        } else {
            self.cz.key_solve(slist)
        };
        if let Some(&v) = self.memo.get(&key) {
            return v;
        }
        self.nodes += 1;
        self.guard(slist.len());
        let avail = self.all & !chosen & !forb;
        let mut moves: Vec<usize> = Vec::new();
        let mut a = avail;
        while a != 0 {
            let y = a & a.wrapping_neg();
            a ^= y;
            moves.push(y.trailing_zeros() as usize);
        }
        if self.rev {
            moves.reverse();
        }
        let mut res = false;
        for yi in moves {
            let mut nf = forb;
            for &i in slist.iter() {
                nf |= self.b.lines[yi * self.b.n + i];
            }
            slist.push(yi);
            let cv = self.value(slist, chosen | (1u128 << yi), nf);
            slist.pop();
            if !cv {
                res = true;
                break;
            }
        }
        self.memo.insert(key, res);
        res
    }
}

fn solve(m: usize, q: u8, wall: f64, memcap: usize, rev: bool, use_ir: bool) {
    let b = Board::build(m, q);
    let all: u128 = if b.n == 128 { u128::MAX } else { (1u128 << b.n) - 1 };
    let cz = Canon { b: &b };
    let t0 = Instant::now();
    let deadline = if wall > 0.0 {
        Some(t0 + std::time::Duration::from_secs_f64(wall))
    } else {
        None
    };
    let mut s = Solver {
        b: &b,
        cz,
        all,
        memo: HashMap::new(),
        nodes: 0,
        deadline,
        memcap,
        t0,
        report_at: 5.0,
        rev,
        use_ir,
    };
    let mut root = Vec::new();
    let v = s.value(&mut root, 0, 0);
    let outc = if v { "N (1st)" } else { "P (2nd)" };
    println!(
        "PG({},{}) SOLVE [rev={} ir={}] -> {}  states={} nodes={} {:.1}s",
        m,
        q,
        rev,
        use_ir,
        outc,
        s.memo.len(),
        s.nodes,
        t0.elapsed().as_secs_f64()
    );
}

fn xorshift(state: &mut u64) -> u64 {
    let mut x = *state;
    x ^= x << 13;
    x ^= x >> 7;
    x ^= x << 17;
    *state = x;
    x
}

// Soundness gate: key() (color-restricted) and key_exact() (all-frames) must both be
// invariant under random projectivities of PG(m,q). An over-split shows as non-invariance.
fn invtest(m: usize, q: u8) {
    let b = Board::build(m, q);
    let cz = Canon { b: &b };
    let dim = b.dim;
    let all: u128 = if b.n == 128 { u128::MAX } else { (1u128 << b.n) - 1 };
    let mut rng: u64 = 0x9e3779b97f4a7c15;
    let (mut fk, mut fe, mut tested) = (0u64, 0u64, 0u64);
    for sz in 5..=14usize {
        for _ in 0..10 {
            let mut s: Vec<usize> = Vec::new();
            let (mut chosen, mut forb, mut ok) = (0u128, 0u128, true);
            for _ in 0..sz {
                let avail = all & !chosen & !forb;
                if avail == 0 {
                    ok = false;
                    break;
                }
                let pick = (xorshift(&mut rng) % avail.count_ones() as u64) as u32;
                let mut a = avail;
                for _ in 0..pick {
                    a &= a - 1;
                }
                let idx = a.trailing_zeros() as usize;
                for &p in &s {
                    forb |= b.lines[idx * b.n + p];
                }
                s.push(idx);
                chosen |= 1u128 << idx;
            }
            if !ok || s.len() != sz {
                continue;
            }
            let k0 = cz.key(&s);
            let e0 = cz.key_exact(&s);
            for _ in 0..6 {
                let mut mat = [[0u8; MAXD]; MAXD];
                loop {
                    for i in 0..dim {
                        for j in 0..dim {
                            mat[i][j] = (xorshift(&mut rng) % q as u64) as u8;
                        }
                    }
                    let rows: Vec<Vec6> = (0..dim).map(|i| mat[i]).collect();
                    if rank_of(&rows, dim, &b.gf) == dim {
                        break;
                    }
                }
                let gs: Vec<usize> = s
                    .iter()
                    .map(|&i| {
                        let w = mv(&mat, &b.pts[i], dim, &b.gf);
                        let cv = vcanon(&w, &b.gf, dim).unwrap();
                        b.vidx[encode(&cv, q, dim)] as usize
                    })
                    .collect();
                tested += 1;
                if cz.key(&gs) != k0 {
                    fk += 1;
                }
                if cz.key_exact(&gs) != e0 {
                    fe += 1;
                }
            }
        }
    }
    println!(
        "PG({},{}) invtest: {} checks  key_fails={}  exact_fails={}",
        m, q, tested, fk, fe
    );
}

fn bench(m: usize, q: u8) {
    let b = Board::build(m, q);
    let cz = Canon { b: &b };
    let all: u128 = if b.n == 128 { u128::MAX } else { (1u128 << b.n) - 1 };
    let mut rng: u64 = 12345;
    for &sz in &[6usize, 9, 11, 13, 15, 17, 19] {
        let mut caps: Vec<Vec<usize>> = Vec::new();
        let mut tries = 0;
        while caps.len() < 20 && tries < 5000 {
            tries += 1;
            let mut s = Vec::new();
            let (mut chosen, mut forb, mut ok) = (0u128, 0u128, true);
            for _ in 0..sz {
                let avail = all & !chosen & !forb;
                if avail == 0 {
                    ok = false;
                    break;
                }
                let pick = (xorshift(&mut rng) % avail.count_ones() as u64) as u32;
                let mut a = avail;
                for _ in 0..pick {
                    a &= a - 1;
                }
                let idx = a.trailing_zeros() as usize;
                for &p in &s {
                    forb |= b.lines[idx * b.n + p];
                }
                s.push(idx);
                chosen |= 1u128 << idx;
            }
            if ok && s.len() == sz {
                caps.push(s);
            }
        }
        if caps.is_empty() {
            println!("size {:>2}: no caps found", sz);
            continue;
        }
        let reps = 5;
        let t0 = Instant::now();
        for _ in 0..reps {
            for s in &caps {
                std::hint::black_box(cz.key_solve(s));
            }
        }
        let g = t0.elapsed().as_secs_f64() / (reps as f64 * caps.len() as f64) * 1e6;
        println!("size {:>2}: key_solve {:>8.1} us/canon  ({} caps)", sz, g, caps.len());
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mode = args.get(1).map(|s| s.as_str()).unwrap_or("validate");
    match mode {
        "validate" => {
            for &(m, q, mk) in &[(2usize, 5u8, 6usize), (2, 7, 6), (3, 3, 10)] {
                orbit_bfs(m, q, mk, 600.0, false);
            }
            for &(m, q) in &[(2usize, 3u8), (2, 5), (2, 7), (3, 3)] {
                solve(m, q, 0.0, usize::MAX, false, false);
            }
        }
        "orbit" | "orbitx" => {
            let m: usize = args[2].parse().unwrap();
            let q: u8 = args[3].parse().unwrap();
            let maxk: usize = args[4].parse().unwrap();
            let wall: f64 = args.get(5).map(|s| s.parse().unwrap()).unwrap_or(3600.0);
            orbit_bfs(m, q, maxk, wall, mode == "orbitx");
        }
        "invtest" => {
            let m: usize = args[2].parse().unwrap();
            let q: u8 = args[3].parse().unwrap();
            invtest(m, q);
        }
        "bench" => {
            let m: usize = args[2].parse().unwrap();
            let q: u8 = args[3].parse().unwrap();
            bench(m, q);
        }
        "solve" => {
            let m: usize = args[2].parse().unwrap();
            let q: u8 = args[3].parse().unwrap();
            let wall: f64 = args.get(4).map(|s| s.parse().unwrap()).unwrap_or(0.0);
            let memcap: usize = args.get(5).map(|s| s.parse().unwrap()).unwrap_or(usize::MAX);
            let rev: bool = args.get(6).map(|s| s == "1").unwrap_or(false);
            let use_ir: bool = args.get(7).map(|s| s == "1").unwrap_or(false);
            solve(m, q, wall, memcap, rev, use_ir);
        }
        _ => eprintln!("unknown mode"),
    }
    println!("PG43_SOLVER_DONE");
}
