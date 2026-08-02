// C756 — masked-RS collision audit: deleted-point direction profiles of conic-external arcs.
//
// Setting (identical to notes/2026-08-01-c756-all-k-conic-filling.rs):
//   C is the nonsingular conic Q(x,y,z) = y^2 - x z in PG(2,q), q odd.
//   A "conic-external arc" is a point set in general position (no 3 collinear) all of
//   whose connecting lines are external to C, equivalently
//     chi( B(P,P')^2 - Q(P) Q(P') ) = -1   for all P != P' in A.
//   The field arithmetic, the conic-external adjacency and the arc DFS are taken from
//   that searcher; the geometry is re-tabulated here (cross-product / incidence tables)
//   so that the direction measurement is table lookups only.
//
// Measurement.  For every conic-external arc A (see the normalization note below), every
// P in A, and every line l through P that is external to C and is NOT a chord of A
// (a "spare external line"):
//     B = A \ {P},  n = |B| = k-1,
//     for each t in l \ {P}:  mu_t = # chords of B meeting l at t,
//     h = #{ t : mu_t = 0 },  R = sum_t C(mu_t, 2),  delta = C(n,2) - q.
// Taking l as the line at infinity and P as the vertical direction, t runs over the q
// affine directions and mu_t is the number of chords of B with that direction; this is
// the setup of notes/2026-08-01-c756-nonsaturated-direction-reduction.md §1.
// Since A is an arc, no chord of B passes through P; the program asserts this (the
// "distinct x-coordinates" check) and counts any violation in `bad_meet`.
//
// Audited sizes: every k with C(k-1,2) >= q (i.e. delta >= 0).  Additionally, every arc
// of the maximum size m(q) is measured for the threshold-unification statistics
// (chord coverage fraction, minimum h).
//
// Normalization.  PGL(2,q) (the stabiliser of C) is transitive on external points and on
// internal points, so it suffices to enumerate arcs through one fixed external
// representative r_ext and one fixed internal representative r_int.  Run 1 enumerates
// every arc containing r_ext; run 2 enumerates every arc containing r_int with r_ext
// masked out of the candidate set, so the two runs are disjoint and every PGL(2,q)-orbit
// of conic-external arcs is represented.  Reported COUNTS are therefore counts of arcs
// through a fixed pair of representatives, not orbit counts; reported EXTREMA and the
// (h,R) support are complete, because every measured quantity is PGL(2,q)-invariant.
//
// Build/run:
//   rustc -O -o /tmp/c756mrs notes/2026-08-01-c756-masked-rs-collision-audit.rs
//   /tmp/c756mrs notes/2026-08-01-c756-masked-rs-collision-audit.json 27 29 31 43 41 ...
//
// Deterministic; no randomness anywhere.

use std::collections::HashMap;
use std::env;
use std::fs::File;
use std::io::Write;
use std::time::Instant;

// ---------------------------------------------------------------- finite field
// (verbatim from the committed searcher)

struct Field {
    p: usize,
    n: usize,
    q: usize,
    mul: Vec<u16>,
    add: Vec<u16>,
    inv: Vec<u16>,
    is_sq: Vec<bool>,
}

fn poly_mul_mod(a: usize, b: usize, p: usize, n: usize, modpoly: &[usize]) -> usize {
    let mut av = vec![0usize; n];
    let mut bv = vec![0usize; n];
    let (mut x, mut y) = (a, b);
    for i in 0..n {
        av[i] = x % p;
        x /= p;
        bv[i] = y % p;
        y /= p;
    }
    let mut c = vec![0usize; 2 * n];
    for i in 0..n {
        for j in 0..n {
            c[i + j] = (c[i + j] + av[i] * bv[j]) % p;
        }
    }
    for d in (n..2 * n).rev() {
        let co = c[d];
        if co == 0 {
            continue;
        }
        c[d] = 0;
        for i in 0..n {
            c[d - n + i] = (c[d - n + i] + (p - modpoly[i] % p) % p * co) % p;
        }
    }
    let mut r = 0usize;
    for i in (0..n).rev() {
        r = r * p + c[i];
    }
    r
}

fn is_irreducible(coeffs: &[usize], p: usize, n: usize) -> bool {
    fn eval_poly(cs: &[usize], n: usize, x: usize, p: usize) -> usize {
        let mut v = 1usize;
        for i in (0..n).rev() {
            v = (v * x + cs[i]) % p;
        }
        v
    }
    if n <= 3 {
        for x in 0..p {
            if eval_poly(coeffs, n, x, p) == 0 {
                return false;
            }
        }
        return true;
    }
    for x in 0..p {
        if eval_poly(coeffs, n, x, p) == 0 {
            return false;
        }
    }
    for b in 0..p {
        for c in 0..p {
            let (a3, a2, a1, a0) = (coeffs[3], coeffs[2], coeffs[1], coeffs[0]);
            let q1 = 1usize;
            let q0 = (a3 + p - (b * q1) % p) % p;
            let qc = (a2 + 2 * p - (b * q0) % p - c % p) % p;
            let rem1 = (a1 + 2 * p - (b * qc) % p - (c * q0) % p) % p;
            let rem0 = (a0 + p - (c * qc) % p) % p;
            if rem1 == 0 && rem0 == 0 {
                return false;
            }
        }
    }
    true
}

impl Field {
    fn new(q: usize) -> Field {
        let mut p = 0;
        let mut n = 0;
        for cand in 2..=q {
            if q % cand == 0 {
                let mut t = q;
                let mut e = 0;
                while t % cand == 0 {
                    t /= cand;
                    e += 1;
                }
                if t == 1 {
                    p = cand;
                    n = e;
                }
                break;
            }
        }
        assert!(p > 0 && n > 0, "q must be a prime power");
        assert!(p % 2 == 1, "q must be odd");
        let modpoly: Vec<usize> = if n == 1 {
            vec![0]
        } else {
            let mut found = None;
            let total = p.pow(n as u32);
            for code in 0..total {
                let mut cs = vec![0usize; n];
                let mut c = code;
                for i in 0..n {
                    cs[i] = c % p;
                    c /= p;
                }
                if is_irreducible(&cs, p, n) {
                    found = Some(cs);
                    break;
                }
            }
            found.expect("no irreducible polynomial found")
        };
        let mut mul = vec![0u16; q * q];
        let mut add = vec![0u16; q * q];
        for a in 0..q {
            for b in 0..q {
                if n == 1 {
                    mul[a * q + b] = ((a * b) % p) as u16;
                    add[a * q + b] = ((a + b) % p) as u16;
                } else {
                    mul[a * q + b] = poly_mul_mod(a, b, p, n, &modpoly) as u16;
                    let (mut x, mut y, mut r, mut w) = (a, b, 0usize, 1usize);
                    for _ in 0..n {
                        r += ((x % p + y % p) % p) * w;
                        x /= p;
                        y /= p;
                        w *= p;
                    }
                    add[a * q + b] = r as u16;
                }
            }
        }
        let mut inv = vec![0u16; q];
        for a in 1..q {
            for b in 1..q {
                if mul[a * q + b] == 1 {
                    inv[a] = b as u16;
                    break;
                }
            }
            assert!(inv[a] != 0, "field inverse missing");
        }
        let mut is_sq = vec![false; q];
        for a in 1..q {
            is_sq[mul[a * q + a] as usize] = true;
        }
        Field { p, n, q, mul, add, inv, is_sq }
    }
    #[inline]
    fn m(&self, a: usize, b: usize) -> usize {
        self.mul[a * self.q + b] as usize
    }
    #[inline]
    fn a(&self, x: usize, y: usize) -> usize {
        self.add[x * self.q + y] as usize
    }
    #[inline]
    fn neg(&self, x: usize) -> usize {
        let (mut t, mut r, mut w) = (x, 0usize, 1usize);
        for _ in 0..self.n {
            r += ((self.p - t % self.p) % self.p) * w;
            t /= self.p;
            w *= self.p;
        }
        r
    }
    #[inline]
    fn sub(&self, x: usize, y: usize) -> usize {
        self.a(x, self.neg(y))
    }
    #[inline]
    fn chi(&self, x: usize) -> i32 {
        if x == 0 {
            0
        } else if self.is_sq[x] {
            1
        } else {
            -1
        }
    }
}

// ---------------------------------------------------------------- plane
// (verbatim from the committed searcher, minus the on-demand `line` helper)

struct Plane {
    f: Field,
    pts: Vec<[usize; 3]>,
    index: Vec<i32>,
    off: Vec<usize>,
    pos: Vec<i32>,
    adj: Vec<Vec<u64>>,
    words: usize,
}

impl Plane {
    fn new(q: usize) -> Plane {
        let f = Field::new(q);
        let mut pts: Vec<[usize; 3]> = Vec::new();
        for y in 0..q {
            for x in 0..q {
                pts.push([x, y, 1]);
            }
        }
        for x in 0..q {
            pts.push([x, 1, 0]);
        }
        pts.push([1, 0, 0]);
        assert_eq!(pts.len(), q * q + q + 1);
        let mut index = vec![-1i32; q * q * q];
        for (i, p) in pts.iter().enumerate() {
            index[p[0] + q * p[1] + q * q * p[2]] = i as i32;
        }
        let mut pl = Plane { f, pts, index, off: vec![], pos: vec![], adj: vec![], words: 0 };
        let n = pl.pts.len();
        pl.pos = vec![-1i32; n];
        for i in 0..n {
            if pl.qform(i) != 0 {
                pl.pos[i] = pl.off.len() as i32;
                pl.off.push(i);
            }
        }
        assert_eq!(pl.off.len(), q * q);
        pl.words = (pl.off.len() + 63) / 64;
        let m = pl.off.len();
        let mut adj = vec![vec![0u64; pl.words]; m];
        for i in 0..m {
            for j in (i + 1)..m {
                if pl.external_join(pl.off[i], pl.off[j]) {
                    adj[i][j / 64] |= 1u64 << (j % 64);
                    adj[j][i / 64] |= 1u64 << (i % 64);
                }
            }
        }
        pl.adj = adj;
        pl
    }
    fn normalize(&self, p: [usize; 3]) -> usize {
        let f = &self.f;
        for k in (0..3).rev() {
            if p[k] != 0 {
                let iv = f.inv[p[k]] as usize;
                let r = [f.m(p[0], iv), f.m(p[1], iv), f.m(p[2], iv)];
                return self.index[r[0] + f.q * r[1] + f.q * f.q * r[2]] as usize;
            }
        }
        panic!("zero vector");
    }
    fn qform(&self, i: usize) -> usize {
        let f = &self.f;
        let p = self.pts[i];
        f.sub(f.m(p[1], p[1]), f.m(p[0], p[2]))
    }
    fn bform(&self, i: usize, j: usize) -> usize {
        let f = &self.f;
        let p = self.pts[i];
        let r = self.pts[j];
        let half = f.inv[f.a(1, 1)] as usize;
        let t = f.a(f.m(p[0], r[2]), f.m(p[2], r[0]));
        f.sub(f.m(p[1], r[1]), f.m(t, half))
    }
    fn external_join(&self, i: usize, j: usize) -> bool {
        let f = &self.f;
        let b = self.bform(i, j);
        let d = f.sub(f.m(b, b), f.m(self.qform(i), self.qform(j)));
        f.chi(d) == -1
    }
}

// ---------------------------------------------------------------- tabulated geometry

struct Geo {
    pl: Plane,
    npts: usize,
    stride: usize,     // q+1
    cx: Vec<u16>,      // cx[i*npts+j]: join of points i,j == meet of lines i,j (self-dual index)
    lpts: Vec<u16>,    // lpts[l*stride+c]: c-th point on line l == c-th line through point l
    lext: Vec<bool>,   // line l is external to C
}

impl Geo {
    fn new(pl: Plane) -> Geo {
        let npts = pl.pts.len();
        let q = pl.f.q;
        let stride = q + 1;
        let mut cx = vec![u16::MAX; npts * npts];
        for i in 0..npts {
            let a = pl.pts[i];
            for j in 0..npts {
                if i == j {
                    continue;
                }
                let b = pl.pts[j];
                let f = &pl.f;
                let v = [
                    f.sub(f.m(a[1], b[2]), f.m(a[2], b[1])),
                    f.sub(f.m(a[2], b[0]), f.m(a[0], b[2])),
                    f.sub(f.m(a[0], b[1]), f.m(a[1], b[0])),
                ];
                cx[i * npts + j] = pl.normalize(v) as u16;
            }
        }
        let mut lpts = vec![0u16; npts * stride];
        let mut lext = vec![true; npts];
        for l in 0..npts {
            let a = pl.pts[l];
            let mut c = 0usize;
            for p in 0..npts {
                let b = pl.pts[p];
                let f = &pl.f;
                let d = f.a(f.a(f.m(a[0], b[0]), f.m(a[1], b[1])), f.m(a[2], b[2]));
                if d == 0 {
                    lpts[l * stride + c] = p as u16;
                    c += 1;
                    if pl.qform(p) == 0 {
                        lext[l] = false;
                    }
                }
            }
            assert_eq!(c, stride, "line incidence count");
        }
        Geo { pl, npts, stride, cx, lext, lpts }
    }
}

// ---------------------------------------------------------------- statistics

#[derive(Default)]
struct Stats {
    arcs_by_size: HashMap<usize, u64>,
    // (n, h, R) -> count, over audited arcs (k >= k_thresh)
    hist: HashMap<(usize, usize, u64), u64>,
    instances: u64,
    h0_count: u64,
    h0_witness: Vec<String>,
    lecover_count: u64,
    lecover_witness: Vec<String>,
    bad_meet: u64,
    // extremal (k == m)
    ext_arcs: u64,
    ext_max_cov: usize,
    ext_min_cov: usize,
    ext_min_h: usize,
    ext_instances: u64,
    ext_arcs_no_spare: u64,
    ext_max_cov_witness: String,
}

struct Scratch {
    mu: Vec<u32>,
    touched: Vec<u16>,
    seen: Vec<bool>,
    covlist: Vec<u32>,
}

fn popcnt(v: &[u64]) -> usize {
    v.iter().map(|w| w.count_ones() as usize).sum()
}

fn binom2(n: u64) -> u64 {
    n * n.saturating_sub(1) / 2
}

// ---------------------------------------------------------------- enumeration

struct Enum<'a> {
    g: &'a Geo,
    words: usize,
    target: usize, // enum mode: report every arc of size >= target
    maxmode: bool,
    best: usize,
    best_set: Vec<usize>,
    nodes: u64,
    k_thresh: usize,
    m: usize,
    st: Stats,
    sc: Scratch,
}

impl<'a> Enum<'a> {
    fn new(g: &'a Geo, maxmode: bool, target: usize, k_thresh: usize, m: usize) -> Enum<'a> {
        let npts = g.npts;
        let noff = g.pl.off.len();
        Enum {
            g,
            words: g.pl.words,
            target,
            maxmode,
            best: 0,
            best_set: vec![],
            nodes: 0,
            k_thresh,
            m,
            st: Stats { ext_min_cov: usize::MAX, ext_min_h: usize::MAX, ..Default::default() },
            sc: Scratch {
                mu: vec![0u32; npts],
                touched: Vec::with_capacity(256),
                seen: vec![false; noff],
                covlist: Vec::with_capacity(noff),
            },
        }
    }

    fn dfs(&mut self, chosen: &mut Vec<usize>, cand: &[u64], forb: &[u64]) {
        self.nodes += 1;
        let sz = chosen.len();
        if sz > self.best {
            self.best = sz;
            self.best_set = chosen.clone();
        }
        if !self.maxmode && sz >= self.target {
            self.process(chosen);
        }
        let need = if self.maxmode { self.best + 1 } else { self.target };
        let avail = popcnt(cand);
        if sz + avail < need {
            return;
        }
        let npts = self.g.npts;
        let stride = self.g.stride;
        let mut c = cand.to_vec();
        loop {
            let mut v = usize::MAX;
            for w in 0..self.words {
                if c[w] != 0 {
                    v = w * 64 + c[w].trailing_zeros() as usize;
                    c[w] &= c[w] - 1;
                    break;
                }
            }
            if v == usize::MAX {
                break;
            }
            let rem = popcnt(&c) + 1;
            let need2 = if self.maxmode { self.best + 1 } else { self.target };
            if sz + rem < need2 {
                break;
            }
            let mut nf = forb.to_vec();
            let vp = self.g.pl.off[v];
            for &u in chosen.iter() {
                let up = self.g.pl.off[u];
                let l = self.g.cx[up * npts + vp] as usize;
                for t in 0..stride {
                    let w = self.g.lpts[l * stride + t] as usize;
                    let p = self.g.pl.pos[w];
                    if p >= 0 {
                        let p = p as usize;
                        nf[p / 64] |= 1u64 << (p % 64);
                    }
                }
            }
            let mut nc = vec![0u64; self.words];
            let adjv = &self.g.pl.adj[v];
            for w in 0..self.words {
                nc[w] = c[w] & adjv[w] & !nf[w];
            }
            chosen.push(v);
            self.dfs(chosen, &nc, &nf);
            chosen.pop();
        }
    }

    fn fmt_pt(&self, i: usize) -> String {
        let p = self.g.pl.pts[i];
        format!("[{},{},{}]", p[0], p[1], p[2])
    }

    fn process(&mut self, chosen: &[usize]) {
        let g = self.g;
        let q = g.pl.f.q;
        let npts = g.npts;
        let stride = g.stride;
        let k = chosen.len();
        *self.st.arcs_by_size.entry(k).or_insert(0) += 1;
        let do_extremal = k == self.m;
        let do_audit = k >= self.k_thresh;
        if !do_extremal && !do_audit {
            return;
        }
        let ap: Vec<usize> = chosen.iter().map(|&o| g.pl.off[o]).collect();

        if do_extremal {
            // chord coverage of the q^2 off-conic points
            let mut cnt = 0usize;
            for i in 0..k {
                for j in (i + 1)..k {
                    let l = g.cx[ap[i] * npts + ap[j]] as usize;
                    for t in 0..stride {
                        let w = g.lpts[l * stride + t] as usize;
                        let pz = g.pl.pos[w];
                        if pz >= 0 {
                            let pz = pz as usize;
                            if !self.sc.seen[pz] {
                                self.sc.seen[pz] = true;
                                self.sc.covlist.push(pz as u32);
                                cnt += 1;
                            }
                        }
                    }
                }
            }
            for &pz in self.sc.covlist.iter() {
                self.sc.seen[pz as usize] = false;
            }
            self.sc.covlist.clear();
            self.st.ext_arcs += 1;
            if cnt > self.st.ext_max_cov {
                self.st.ext_max_cov = cnt;
                let v: Vec<String> = ap.iter().map(|&i| self.fmt_pt(i)).collect();
                self.st.ext_max_cov_witness = format!("[{}]", v.join(","));
            }
            if cnt < self.st.ext_min_cov {
                self.st.ext_min_cov = cnt;
            }
        }

        let n = k - 1;
        let bn = n * (n - 1) / 2;
        let delta_ok = (bn as i64) - (q as i64) >= 0;
        let delta = if delta_ok { (bn - q) as u64 } else { 0 };
        let r_cover = binom2(delta + 1);

        let mut arc_has_spare = false;
        for pi in 0..k {
            let pp = ap[pi];
            let mut blines: Vec<u16> = Vec::with_capacity(bn);
            for i in 0..k {
                if i == pi {
                    continue;
                }
                for j in (i + 1)..k {
                    if j == pi {
                        continue;
                    }
                    blines.push(g.cx[ap[i] * npts + ap[j]]);
                }
            }
            debug_assert_eq!(blines.len(), bn);
            for c in 0..stride {
                let l = g.lpts[pp * stride + c] as usize; // lines through P (self-dual table)
                if !g.lext[l] {
                    continue;
                }
                let mut ischord = false;
                for i in 0..k {
                    if i != pi && g.cx[pp * npts + ap[i]] as usize == l {
                        ischord = true;
                        break;
                    }
                }
                if ischord {
                    continue;
                }
                arc_has_spare = true;
                let mut distinct = 0usize;
                for &bl in blines.iter() {
                    let t = g.cx[bl as usize * npts + l] as usize;
                    if t == pp {
                        self.st.bad_meet += 1;
                    }
                    let old = self.sc.mu[t];
                    if old == 0 {
                        self.sc.touched.push(t as u16);
                        distinct += 1;
                    }
                    self.sc.mu[t] = old + 1;
                }
                let mut rr: u64 = 0;
                let mut prof: Vec<u32> = Vec::new();
                for idx in 0..self.sc.touched.len() {
                    let t = self.sc.touched[idx] as usize;
                    let mt = self.sc.mu[t] as u64;
                    rr += binom2(mt);
                    if mt >= 2 {
                        prof.push(mt as u32);
                    }
                    self.sc.mu[t] = 0;
                }
                self.sc.touched.clear();
                let h = q - distinct;

                if do_extremal {
                    self.st.ext_instances += 1;
                    if h < self.st.ext_min_h {
                        self.st.ext_min_h = h;
                    }
                }
                if do_audit {
                    self.st.instances += 1;
                    *self.st.hist.entry((n, h, rr)).or_insert(0) += 1;
                    let interesting = h == 0 || (h == 1 && rr <= r_cover);
                    if interesting {
                        if h == 0 {
                            self.st.h0_count += 1;
                        } else {
                            self.st.lecover_count += 1;
                        }
                        let v: Vec<String> = ap.iter().map(|&i| self.fmt_pt(i)).collect();
                        prof.sort_unstable();
                        let w = format!(
                            "{{\"k\":{},\"n\":{},\"h\":{},\"R\":{},\"delta\":{},\"R_cover\":{},\"arc\":[{}],\"P\":{},\"line\":{},\"mu_ge2\":{:?}}}",
                            k,
                            n,
                            h,
                            rr,
                            delta,
                            r_cover,
                            v.join(","),
                            self.fmt_pt(pp),
                            self.fmt_pt(l),
                            prof
                        );
                        if h == 0 {
                            if self.st.h0_witness.len() < 20 {
                                self.st.h0_witness.push(w);
                            }
                        } else if self.st.lecover_witness.len() < 20 {
                            self.st.lecover_witness.push(w);
                        }
                    }
                }
            }
        }
        if do_extremal && !arc_has_spare {
            self.st.ext_arcs_no_spare += 1;
        }
    }
}

// ---------------------------------------------------------------- thresholds

fn k_thresh(q: usize) -> usize {
    // smallest k with C(k-1,2) >= q
    let mut k = 3usize;
    while (k - 1) * (k - 2) / 2 < q {
        k += 1;
    }
    k
}

fn run_rep(g: &Geo, maxmode: bool, target: usize, kt: usize, m: usize) -> (usize, Vec<usize>, u64, Stats) {
    // representatives: first external and first internal point off C
    let mut reps: Vec<usize> = vec![];
    for t in [1i32, -1i32] {
        for (i, &p) in g.pl.off.iter().enumerate() {
            if g.pl.f.chi(g.pl.qform(p)) == t {
                reps.push(i);
                break;
            }
        }
    }
    let words = g.pl.words;
    let mut best = 0usize;
    let mut best_set: Vec<usize> = vec![];
    let mut nodes = 0u64;
    let mut acc = Stats { ext_min_cov: usize::MAX, ext_min_h: usize::MAX, ..Default::default() };
    for (ri, &r) in reps.iter().enumerate() {
        let mut e = Enum::new(g, maxmode, target, kt, m);
        e.best = best;
        let mut cand = vec![0u64; words];
        for w in 0..words {
            cand[w] = g.pl.adj[r][w];
        }
        if ri == 1 {
            // dedup: run 2 must not re-derive arcs already enumerated in run 1
            let r0 = reps[0];
            cand[r0 / 64] &= !(1u64 << (r0 % 64));
        }
        let mut chosen = vec![r];
        let forb = vec![0u64; words];
        e.dfs(&mut chosen, &cand, &forb);
        if e.best > best {
            best = e.best;
            best_set = e.best_set.clone();
        }
        nodes += e.nodes;
        // merge stats
        let s = e.st;
        for (k, v) in s.arcs_by_size {
            *acc.arcs_by_size.entry(k).or_insert(0) += v;
        }
        for (k, v) in s.hist {
            *acc.hist.entry(k).or_insert(0) += v;
        }
        acc.instances += s.instances;
        acc.h0_count += s.h0_count;
        for w in s.h0_witness {
            if acc.h0_witness.len() < 20 {
                acc.h0_witness.push(w);
            }
        }
        acc.lecover_count += s.lecover_count;
        for w in s.lecover_witness {
            if acc.lecover_witness.len() < 20 {
                acc.lecover_witness.push(w);
            }
        }
        acc.bad_meet += s.bad_meet;
        acc.ext_arcs += s.ext_arcs;
        acc.ext_instances += s.ext_instances;
        acc.ext_arcs_no_spare += s.ext_arcs_no_spare;
        if s.ext_max_cov > acc.ext_max_cov {
            acc.ext_max_cov = s.ext_max_cov;
            acc.ext_max_cov_witness = s.ext_max_cov_witness;
        }
        if s.ext_min_cov < acc.ext_min_cov {
            acc.ext_min_cov = s.ext_min_cov;
        }
        if s.ext_min_h < acc.ext_min_h {
            acc.ext_min_h = s.ext_min_h;
        }
    }
    (best, best_set, nodes, acc)
}

fn main() {
    let args: Vec<String> = env::args().collect();
    assert!(args.len() >= 3, "usage: audit <out.json> <q> [<q> ...]");
    let out_path = args[1].clone();
    let qs: Vec<usize> = args[2..].iter().map(|s| s.parse().unwrap()).collect();

    let mut f = File::create(&out_path).unwrap();
    writeln!(
        f,
        "{{\"task\":\"C756-masked-rs-collision-audit\",\"conic\":\"y^2-xz\",\"records\":["
    )
    .unwrap();
    f.flush().unwrap();

    let mut first = true;
    for &q in qs.iter() {
        let t0 = Instant::now();
        eprintln!("[q={}] building plane", q);
        let pl = Plane::new(q);
        let g = Geo::new(pl);
        let kt = k_thresh(q);
        // exact m(q)
        let (m, mset, mnodes, _) = run_rep(&g, true, 0, usize::MAX, usize::MAX);
        let t_max = t0.elapsed().as_secs_f64();
        eprintln!("[q={}] m(q)={} kthresh={} ({:.1}s, {} nodes)", q, m, kt, t_max, mnodes);
        let target = if kt < m { kt } else { m };
        let (_, _, enodes, st) = run_rep(&g, false, target, kt, m);
        let secs = t0.elapsed().as_secs_f64();
        eprintln!(
            "[q={}] done: ext_arcs={} audit_instances={} h0={} le_cover={} ({:.1}s)",
            q, st.ext_arcs, st.instances, st.h0_count, st.lecover_count, secs
        );

        // serialize
        let mw: Vec<String> = mset
            .iter()
            .map(|&o| {
                let p = g.pl.pts[g.pl.off[o]];
                format!("[{},{},{}]", p[0], p[1], p[2])
            })
            .collect();
        let mut sizes: Vec<(usize, u64)> = st.arcs_by_size.iter().map(|(a, b)| (*a, *b)).collect();
        sizes.sort();
        let sizes_s: Vec<String> =
            sizes.iter().map(|(k, v)| format!("[{},{}]", k, v)).collect();
        let mut hist: Vec<((usize, usize, u64), u64)> =
            st.hist.iter().map(|(a, b)| (*a, *b)).collect();
        hist.sort();
        let hist_s: Vec<String> = hist
            .iter()
            .map(|((n, h, r), c)| format!("[{},{},{},{}]", n, h, r, c))
            .collect();
        let n_aud = if kt <= m { kt - 1 } else { 0 };
        let delta = if kt <= m { (n_aud * (n_aud - 1) / 2) as i64 - q as i64 } else { -1 };
        let rec = format!(
            "{{\"q\":{},\"p\":{},\"deg\":{},\"m_q\":{},\"m_witness\":[{}],\"k_thresh\":{},\
             \"audited_sizes\":{},\"n_audited\":{},\"delta\":{},\"R_cover\":{},\
             \"arcs_by_size\":[{}],\"audit_instances\":{},\"hist_n_h_R_count\":[{}],\
             \"h0_count\":{},\"h0_witness\":[{}],\"le_cover_count\":{},\"le_cover_witness\":[{}],\
             \"bad_meet\":{},\"extremal_arcs\":{},\"extremal_instances\":{},\
             \"extremal_arcs_without_spare_line\":{},\"extremal_max_cov_pts\":{},\
             \"extremal_min_cov_pts\":{},\"q2\":{},\"extremal_min_h\":{},\
             \"extremal_max_cov_witness\":{},\"max_nodes\":{},\"enum_nodes\":{},\"seconds\":{:.2},\
             \"exhaustive\":true}}",
            q,
            g.pl.f.p,
            g.pl.f.n,
            m,
            mw.join(","),
            kt,
            if kt <= m { format!("[{},{}]", kt, m) } else { "[]".to_string() },
            n_aud,
            delta,
            if delta >= 0 { binom2(delta as u64 + 1) as i64 } else { -1 },
            sizes_s.join(","),
            st.instances,
            hist_s.join(","),
            st.h0_count,
            st.h0_witness.join(","),
            st.lecover_count,
            st.lecover_witness.join(","),
            st.bad_meet,
            st.ext_arcs,
            st.ext_instances,
            st.ext_arcs_no_spare,
            st.ext_max_cov,
            if st.ext_min_cov == usize::MAX { 0 } else { st.ext_min_cov },
            q * q,
            if st.ext_min_h == usize::MAX { -1i64 } else { st.ext_min_h as i64 },
            if st.ext_max_cov_witness.is_empty() { "[]".to_string() } else { st.ext_max_cov_witness.clone() },
            mnodes,
            enodes,
            secs
        );
        if !first {
            writeln!(f, ",").unwrap();
        }
        first = false;
        write!(f, "{}", rec).unwrap();
        f.flush().unwrap();
    }
    writeln!(f, "\n]}}").unwrap();
    f.flush().unwrap();
}
