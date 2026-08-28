// C973 GF(27) switch probe.
//
// K = GF(27) = F3[x]/(x^3 - x - 1), elements encoded as integers 0..26 with
// base-3 digits n = d0 + 3*d1 + 9*d2  <->  d0 + d1*x + d2*x^2.
//
// Carrier syndrome z = (z2,...,z8) in K^7 \ {0} (projective).
// A monic degree-9 locator g(t) = t^9 + sum_{i=0}^{8} g_i t^i closes z iff
//     sum_{i=2}^{8} z_i g_{i-1} = 0   and   sum_{i=2}^{8} z_i g_i = 0.

use std::fmt::Write as _;
use std::fs;
use std::io::Write as _;
use std::time::Instant;

const NF: usize = 27;

// ---------------------------------------------------------------- field ----

pub struct Tab {
    pub add: [[u8; NF]; NF],
    pub mul: [[u8; NF]; NF],
    pub neg: [u8; NF],
    pub inv: [u8; NF],
    pub issq: [bool; NF],
    pub sqrt: [u8; NF],
}

fn digits(a: u8) -> [u8; 3] {
    [a % 3, (a / 3) % 3, (a / 9) % 3]
}
fn undigits(d: [u8; 3]) -> u8 {
    d[0] % 3 + 3 * (d[1] % 3) + 9 * (d[2] % 3)
}

fn build_tab() -> Box<Tab> {
    let mut t = Box::new(Tab {
        add: [[0; NF]; NF],
        mul: [[0; NF]; NF],
        neg: [0; NF],
        inv: [0; NF],
        issq: [false; NF],
        sqrt: [0; NF],
    });
    for a in 0..NF {
        for b in 0..NF {
            let (da, db) = (digits(a as u8), digits(b as u8));
            t.add[a][b] = undigits([da[0] + db[0], da[1] + db[1], da[2] + db[2]]);
            // polynomial product, degree <= 4
            let mut c = [0u8; 5];
            for i in 0..3 {
                for j in 0..3 {
                    c[i + j] = (c[i + j] + da[i] * db[j]) % 3;
                }
            }
            // x^3 = x + 1, x^4 = x^2 + x
            let r0 = (c[0] + c[3]) % 3;
            let r1 = (c[1] + c[3] + c[4]) % 3;
            let r2 = (c[2] + c[4]) % 3;
            t.mul[a][b] = undigits([r0, r1, r2]);
        }
    }
    for a in 0..NF {
        let d = digits(a as u8);
        t.neg[a] = undigits([(3 - d[0]) % 3, (3 - d[1]) % 3, (3 - d[2]) % 3]);
        for b in 0..NF {
            if t.mul[a][b] == 1 {
                t.inv[a] = b as u8;
            }
        }
    }
    t.issq[0] = true;
    t.sqrt[0] = 0;
    for a in 1..NF {
        let s = t.mul[a][a] as usize;
        t.issq[s] = true;
        t.sqrt[s] = a as u8;
    }
    t
}

#[inline(always)]
fn ad(t: &Tab, a: u8, b: u8) -> u8 {
    t.add[a as usize][b as usize]
}
#[inline(always)]
fn ml(t: &Tab, a: u8, b: u8) -> u8 {
    t.mul[a as usize][b as usize]
}
#[inline(always)]
fn ng(t: &Tab, a: u8) -> u8 {
    t.neg[a as usize]
}
#[inline(always)]
fn sb(t: &Tab, a: u8, b: u8) -> u8 {
    t.add[a as usize][t.neg[b as usize] as usize]
}
#[inline(always)]
fn iv(t: &Tab, a: u8) -> u8 {
    t.inv[a as usize]
}
fn pow(t: &Tab, a: u8, e: u32) -> u8 {
    let mut r = 1u8;
    for _ in 0..e {
        r = ml(t, r, a);
    }
    r
}

/// monic polynomial with the given roots, coefficients low -> high
fn poly_from_roots(t: &Tab, roots: &[u8]) -> Vec<u8> {
    let mut p = vec![1u8];
    for &r in roots {
        let mut q = vec![0u8; p.len() + 1];
        for i in 0..p.len() {
            q[i + 1] = ad(t, q[i + 1], p[i]);
            q[i] = sb(t, q[i], ml(t, p[i], r));
        }
        p = q;
    }
    p
}

fn poly_mul_linear(t: &Tab, p: &[u8], r: u8) -> Vec<u8> {
    // p(t) * (t - r)
    let mut q = vec![0u8; p.len() + 1];
    for i in 0..p.len() {
        q[i + 1] = ad(t, q[i + 1], p[i]);
        q[i] = sb(t, q[i], ml(t, p[i], r));
    }
    q
}

fn poly_eval(t: &Tab, p: &[u8], x: u8) -> u8 {
    let mut s = 0u8;
    for i in (0..p.len()).rev() {
        s = ad(t, ml(t, s, x), p[i]);
    }
    s
}

// ------------------------------------------------------------- geometry ----

#[derive(Clone)]
struct Line {
    pts: [u8; 3],
    dir: u8, // canonical direction representative
    p: u8,   // R(t) = t^3 + p t + q
    q: u8,
}

#[derive(Clone)]
struct Plane {
    pts: [u8; 9],
    mask: u32,
    a: u8, // P(t) = t^9 + A t^3 + B t + C
    b: u8,
    c: u8,
    powers: [[u8; 7]; 9], // per root: [x^6,x^5,x^4,x^3,x^2,x,1]
}

fn build_lines(t: &Tab) -> Vec<Line> {
    let mut seen = std::collections::BTreeSet::new();
    let mut out = Vec::new();
    for d in 1..27u8 {
        for c in 0..27u8 {
            let mut pts = [c, ad(t, c, d), ad(t, c, ml(t, d, 2))];
            pts.sort();
            if !seen.insert(pts) {
                continue;
            }
            let r = poly_from_roots(t, &pts);
            assert_eq!(r.len(), 4);
            assert_eq!(r[3], 1);
            assert_eq!(r[2], 0, "line locator must be t^3 + p t + q");
            // canonical direction: min of {d, 2d}
            let dd = ml(t, d, 2);
            let dir = if d < dd { d } else { dd };
            out.push(Line { pts, dir, p: r[1], q: r[0] });
        }
    }
    out
}

fn build_planes(t: &Tab) -> Vec<Plane> {
    let mut subspaces = std::collections::BTreeSet::new();
    for d1 in 1..27u8 {
        for d2 in 1..27u8 {
            let mut v = Vec::new();
            for a in 0..3u8 {
                for b in 0..3u8 {
                    v.push(ad(t, ml(t, d1, a), ml(t, d2, b)));
                }
            }
            v.sort();
            v.dedup();
            if v.len() == 9 {
                subspaces.insert(v);
            }
        }
    }
    let mut seen = std::collections::BTreeSet::new();
    let mut out = Vec::new();
    for v in &subspaces {
        for c in 0..27u8 {
            let mut pts: Vec<u8> = v.iter().map(|&w| ad(t, c, w)).collect();
            pts.sort();
            if !seen.insert(pts.clone()) {
                continue;
            }
            let p = poly_from_roots(t, &pts);
            assert_eq!(p.len(), 10);
            assert_eq!(p[9], 1);
            for &i in &[8usize, 7, 6, 5, 4, 2] {
                assert_eq!(p[i], 0, "plane locator must be t^9 + A t^3 + B t + C");
            }
            let mut arr = [0u8; 9];
            arr.copy_from_slice(&pts);
            let mut mask = 0u32;
            let mut powers = [[0u8; 7]; 9];
            for (i, &x) in pts.iter().enumerate() {
                mask |= 1 << x;
                for k in 0..7 {
                    powers[i][k] = pow(t, x, (6 - k) as u32);
                }
            }
            out.push(Plane { pts: arr, mask, a: p[3], b: p[1], c: p[0], powers });
        }
    }
    out
}

// ------------------------------------------------------------ candidates ---

#[derive(Clone)]
struct Cand {
    b1: [u8; 7], // E1 row of base = Q*(t-x1)*(t-x2)
    b2: [u8; 7], // E2 row of base
    w11: [u8; 7],
    w12: [u8; 7], // E1,E2 rows of W1 = Q*(t-x2)  (multiplier of c1)
    w21: [u8; 7],
    w22: [u8; 7], // E1,E2 rows of W2 = Q*(t-x1)  (multiplier of c2)
    qmask: u32,
    x1: u8,
    x2: u8,
    lam1: bool,
    kappa: u8,
    lambda: u8,
    plane: u16,
    line: u16,
}

fn rows(h: &[u8]) -> ([u8; 7], [u8; 7]) {
    // E1 uses h_1..h_7, E2 uses h_2..h_8
    let get = |i: usize| if i < h.len() { h[i] } else { 0 };
    let mut r1 = [0u8; 7];
    let mut r2 = [0u8; 7];
    for k in 0..7 {
        r1[k] = get(k + 1);
        r2[k] = get(k + 2);
    }
    (r1, r2)
}

fn build_cands(t: &Tab, lines: &[Line], planes: &[Plane], log: &mut String) -> Vec<Cand> {
    let gen = 3u8; // x, satisfies x^3 = x + 1
    assert_eq!(pow(t, gen, 3), ad(t, gen, 1));
    let mut out = Vec::new();
    let mut lam_poly_ok = 0usize;
    let mut lam1_per_line = vec![0usize; lines.len()];
    let mut lam1_dir_ok = 0usize;
    for (li, l) in lines.iter().enumerate() {
        let lmask: u32 = l.pts.iter().map(|&x| 1u32 << x).fold(0, |a, b| a | b);
        let containing: Vec<usize> =
            (0..planes.len()).filter(|&pi| planes[pi].mask & lmask == lmask).collect();
        assert_eq!(containing.len(), 4, "each line lies in exactly four planes");
        let d = l.dir;
        // p = -d^2
        assert_eq!(l.p, ng(t, ml(t, d, d)), "line direction/p mismatch");
        let d6 = pow(t, d, 6);
        for &pi in &containing {
            let pl = &planes[pi];
            // P_kappa(t) = t^9 + (p^3 - kappa) t^3 - kappa*p*t + (q^3 - kappa*q)
            let p3 = pow(t, l.p, 3);
            let kappa = sb(t, p3, pl.a);
            assert_eq!(pl.b, ng(t, ml(t, kappa, l.p)), "pencil B coefficient mismatch");
            assert_eq!(
                pl.c,
                sb(t, pow(t, l.q, 3), ml(t, kappa, l.q)),
                "pencil C coefficient mismatch"
            );
            let lambda = ml(t, kappa, iv(t, d6));
            // lambda^4 + lambda + 1 = 0 ?
            let v = ad(t, ad(t, pow(t, lambda, 4), lambda), 1);
            if v == 0 {
                lam_poly_ok += 1;
            }
            let lam1 = lambda == 1;
            if lam1 {
                lam1_per_line[li] += 1;
                // direction space of the lambda=1 plane should be span_F3(d, d*gen)
                let dg = ml(t, d, gen);
                let mut span: Vec<u8> = Vec::new();
                for a in 0..3u8 {
                    for b in 0..3u8 {
                        span.push(ad(t, ml(t, d, a), ml(t, dg, b)));
                    }
                }
                span.sort();
                let mut diffs: Vec<u8> =
                    pl.pts.iter().map(|&x| sb(t, x, pl.pts[0])).collect();
                diffs.sort();
                if diffs == span {
                    lam1_dir_ok += 1;
                }
            }
            for pr in 0..3usize {
                let (x1, x2) = match pr {
                    0 => (l.pts[0], l.pts[1]),
                    1 => (l.pts[0], l.pts[2]),
                    _ => (l.pts[1], l.pts[2]),
                };
                let qroots: Vec<u8> =
                    pl.pts.iter().cloned().filter(|&r| r != x1 && r != x2).collect();
                assert_eq!(qroots.len(), 7);
                let qp = poly_from_roots(t, &qroots);
                let w1 = poly_mul_linear(t, &qp, x2);
                let w2 = poly_mul_linear(t, &qp, x1);
                let base = poly_mul_linear(t, &w1, x1);
                let (b1, b2) = rows(&base);
                let (w11, w12) = rows(&w1);
                let (w21, w22) = rows(&w2);
                let qmask = qroots.iter().map(|&x| 1u32 << x).fold(0, |a, b| a | b);
                out.push(Cand {
                    b1,
                    b2,
                    w11,
                    w12,
                    w21,
                    w22,
                    qmask,
                    x1,
                    x2,
                    lam1,
                    kappa,
                    lambda,
                    plane: pi as u16,
                    line: li as u16,
                });
            }
        }
    }
    let n_lam1_lines = lam1_per_line.iter().filter(|&&c| c == 1).count();
    writeln!(
        log,
        "pencil check: kappa/d^6 satisfies lambda^4+lambda+1=0 in {}/{} (line,plane) pairs; \
lines with exactly one lambda=1 plane: {}/{}; lambda=1 plane direction equals span_F3(d, d*x) in {} cases",
        lam_poly_ok,
        lines.len() * 4,
        n_lam1_lines,
        lines.len(),
        lam1_dir_ok
    )
    .unwrap();
    out
}

// --------------------------------------------------------- switch scan -----

#[derive(Clone, Copy, Default)]
struct Stat {
    n_ns: u16,
    n_zero: u16,
    n_sq: u16, // nonzero square discriminant == n_split_distinct
    n_good: u16,
    n_good_lam1: u16,
    n_good_conj: u16,
    n_ns_lam1: u16,
    n_onept: u16,
}

#[inline(always)]
fn dot(t: &Tab, z: &[u8; 7], v: &[u8; 7]) -> u8 {
    let mut s0 = 0u8;
    let mut s1 = 0u8;
    for k in 0..3 {
        s0 = t.add[s0 as usize][t.mul[z[2 * k] as usize][v[2 * k] as usize] as usize];
        s1 = t.add[s1 as usize][t.mul[z[2 * k + 1] as usize][v[2 * k + 1] as usize] as usize];
    }
    s0 = t.add[s0 as usize][t.mul[z[6] as usize][v[6] as usize] as usize];
    t.add[s0 as usize][s1 as usize]
}

fn scan(t: &Tab, cands: &[Cand], planes: &[Plane], z: &[u8; 7]) -> Stat {
    let mut st = Stat::default();
    for c in cands {
        let a11 = dot(t, z, &c.w11);
        let a21 = dot(t, z, &c.w12);
        let a12 = dot(t, z, &c.w21);
        let a22 = dot(t, z, &c.w22);
        let det = sb(t, ml(t, a11, a22), ml(t, a12, a21));
        if det == 0 {
            continue;
        }
        st.n_ns += 1;
        if c.lam1 {
            st.n_ns_lam1 += 1;
        }
        let r1 = ng(t, dot(t, z, &c.b1));
        let r2 = ng(t, dot(t, z, &c.b2));
        let di = iv(t, det);
        let c1 = ml(t, sb(t, ml(t, r1, a22), ml(t, a12, r2)), di);
        let c2 = ml(t, sb(t, ml(t, a11, r2), ml(t, r1, a21)), di);
        // S = t^2 + beta t + gamma
        let beta = sb(t, ad(t, c1, c2), ad(t, c.x1, c.x2));
        let gamma = sb(t, ml(t, c.x1, c.x2), ad(t, ml(t, c1, c.x2), ml(t, c2, c.x1)));
        let disc = sb(t, ml(t, beta, beta), gamma); // beta^2 - 4 gamma, char 3
        if disc == 0 {
            st.n_zero += 1;
            continue;
        }
        if !t.issq[disc as usize] {
            continue;
        }
        st.n_sq += 1;
        let s = t.sqrt[disc as usize];
        let ra = sb(t, beta, s);
        let rb = ad(t, beta, s);
        if (c.qmask >> ra) & 1 == 0 && (c.qmask >> rb) & 1 == 0 {
            st.n_good += 1;
            if c.lam1 {
                st.n_good_lam1 += 1;
            } else {
                st.n_good_conj += 1;
            }
        }
    }
    // one-point switches, eq (16c): Z = z3*A, R = z2*B + z4*A, y = R/Z,
    // (x - y) phi(x) + Z = 0 with phi(x) = z2(x^6+A)+z3 x^5+z4 x^4+z5 x^3+z6 x^2+z7 x+z8.
    let (z2, z3, z4) = (z[0], z[1], z[2]);
    for pl in planes {
        let zz = ml(t, z3, pl.a);
        if zz == 0 {
            continue;
        }
        let rr = ad(t, ml(t, z2, pl.b), ml(t, z4, pl.a));
        let y = ml(t, rr, iv(t, zz));
        let ymem = (pl.mask >> y) & 1 == 1;
        let z2a = ml(t, z2, pl.a);
        for i in 0..9 {
            let x = pl.pts[i];
            let phi = ad(t, dot(t, z, &pl.powers[i]), z2a);
            if ad(t, ml(t, sb(t, x, y), phi), zz) == 0 && !ymem {
                st.n_onept += 1;
            }
        }
    }
    st
}

// ----------------------------------------------------- exhaustive search ---

/// Full count over all 9-subsets of K of split nine-affine locators closing z,
/// and over all 8-subsets under the natural degree-8 reading (g_9 = 0, g_8 = 1).
fn exhaustive(t: &Tab, z: &[u8; 7]) -> (u64, u64) {
    fn rec(
        t: &Tab,
        z: &[u8; 7],
        depth: usize,
        start: u8,
        h: &[u8; 10],
        c9: &mut u64,
        c8: &mut u64,
    ) {
        if depth == 8 {
            let mut p0 = 0u8;
            let mut p1 = 0u8;
            let mut p2 = 0u8;
            for k in 0..7 {
                p0 = ad(t, p0, ml(t, z[k], h[k]));
                p1 = ad(t, p1, ml(t, z[k], h[k + 1]));
                p2 = ad(t, p2, ml(t, z[k], h[k + 2]));
            }
            if p1 == 0 && p2 == 0 {
                *c8 += 1;
            }
            for x in start..27u8 {
                if sb(t, p0, ml(t, x, p1)) == 0 && sb(t, p1, ml(t, x, p2)) == 0 {
                    *c9 += 1;
                }
            }
            return;
        }
        let xmax = 18u8 + depth as u8; // need 8-depth further roots above x
        let mut x = start;
        while x <= xmax {
            let mut dst = [0u8; 10];
            for i in 0..=depth {
                dst[i + 1] = ad(t, dst[i + 1], h[i]);
                dst[i] = sb(t, dst[i], ml(t, h[i], x));
            }
            rec(t, z, depth + 1, x + 1, &dst, c9, c8);
            x += 1;
        }
    }
    let mut h = [0u8; 10];
    h[0] = 1;
    let (mut c9, mut c8) = (0u64, 0u64);
    rec(t, z, 0, 0, &h, &mut c9, &mut c8);
    (c9, c8)
}

// ----------------------------------------------------------- accumulator ---

const MAXC: usize = 1405;

struct Acc {
    count: u64,
    h_good: Vec<u64>,
    h_ns: Vec<u64>,
    h_sq: Vec<u64>,
    h_zero: Vec<u64>,
    h_good_lam1: Vec<u64>,
    h_good_conj: Vec<u64>,
    h_onept: Vec<u64>,
    s_good: u64,
    s_ns: u64,
    s_sq: u64,
    s_zero: u64,
    s_good_lam1: u64,
    s_good_conj: u64,
    s_onept: u64,
    min_good: u32,
    argmin_good: [u8; 7],
    min_good_lam1: u32,
    argmin_good_lam1: [u8; 7],
    min_onept: u32,
    argmin_onept: [u8; 7],
    fails: Vec<[u8; 7]>,
}

impl Acc {
    fn new() -> Acc {
        Acc {
            count: 0,
            h_good: vec![0; MAXC],
            h_ns: vec![0; MAXC],
            h_sq: vec![0; MAXC],
            h_zero: vec![0; MAXC],
            h_good_lam1: vec![0; MAXC],
            h_good_conj: vec![0; MAXC],
            h_onept: vec![0; MAXC],
            s_good: 0,
            s_ns: 0,
            s_sq: 0,
            s_zero: 0,
            s_good_lam1: 0,
            s_good_conj: 0,
            s_onept: 0,
            min_good: u32::MAX,
            argmin_good: [0; 7],
            min_good_lam1: u32::MAX,
            argmin_good_lam1: [0; 7],
            min_onept: u32::MAX,
            argmin_onept: [0; 7],
            fails: Vec::new(),
        }
    }
    fn push(&mut self, z: &[u8; 7], st: &Stat) {
        self.count += 1;
        self.h_good[st.n_good as usize] += 1;
        self.h_ns[st.n_ns as usize] += 1;
        self.h_sq[st.n_sq as usize] += 1;
        self.h_zero[st.n_zero as usize] += 1;
        self.h_good_lam1[st.n_good_lam1 as usize] += 1;
        self.h_good_conj[st.n_good_conj as usize] += 1;
        self.h_onept[st.n_onept as usize] += 1;
        self.s_good += st.n_good as u64;
        self.s_ns += st.n_ns as u64;
        self.s_sq += st.n_sq as u64;
        self.s_zero += st.n_zero as u64;
        self.s_good_lam1 += st.n_good_lam1 as u64;
        self.s_good_conj += st.n_good_conj as u64;
        self.s_onept += st.n_onept as u64;
        if (st.n_good as u32) < self.min_good {
            self.min_good = st.n_good as u32;
            self.argmin_good = *z;
        }
        if (st.n_good_lam1 as u32) < self.min_good_lam1 {
            self.min_good_lam1 = st.n_good_lam1 as u32;
            self.argmin_good_lam1 = *z;
        }
        if (st.n_onept as u32) < self.min_onept {
            self.min_onept = st.n_onept as u32;
            self.argmin_onept = *z;
        }
        if st.n_good == 0 && self.fails.len() < 100_000 {
            self.fails.push(*z);
        }
    }
    fn merge(&mut self, o: &Acc) {
        self.count += o.count;
        for i in 0..MAXC {
            self.h_good[i] += o.h_good[i];
            self.h_ns[i] += o.h_ns[i];
            self.h_sq[i] += o.h_sq[i];
            self.h_zero[i] += o.h_zero[i];
            self.h_good_lam1[i] += o.h_good_lam1[i];
            self.h_good_conj[i] += o.h_good_conj[i];
            self.h_onept[i] += o.h_onept[i];
        }
        self.s_good += o.s_good;
        self.s_ns += o.s_ns;
        self.s_sq += o.s_sq;
        self.s_zero += o.s_zero;
        self.s_good_lam1 += o.s_good_lam1;
        self.s_good_conj += o.s_good_conj;
        self.s_onept += o.s_onept;
        if o.min_good < self.min_good {
            self.min_good = o.min_good;
            self.argmin_good = o.argmin_good;
        }
        if o.min_good_lam1 < self.min_good_lam1 {
            self.min_good_lam1 = o.min_good_lam1;
            self.argmin_good_lam1 = o.argmin_good_lam1;
        }
        if o.min_onept < self.min_onept {
            self.min_onept = o.min_onept;
            self.argmin_onept = o.argmin_onept;
        }
        for f in &o.fails {
            if self.fails.len() < 100_000 {
                self.fails.push(*f);
            }
        }
    }
}

// ---------------------------------------------------------- quotient pts ---

fn p1_norm(t: &Tab, u: u8, v: u8) -> (u8, u8) {
    if u != 0 {
        (1, ml(t, v, iv(t, u)))
    } else if v != 0 {
        (0, 1)
    } else {
        (0, 0)
    }
}

/// rank-one projective quotient points, with graph flags under four conventions
struct QPoint {
    m: [u8; 4], // (z3, z4, z6, z7) with M = [[z3,z6],[z4,z7]] = [[a,b],[c,d]]
    g: [bool; 4],
}

fn rank_one_points(t: &Tab) -> Vec<QPoint> {
    let mut out = Vec::new();
    for a in 0..27u8 {
        for b in 0..27u8 {
            for c in 0..27u8 {
                for d in 0..27u8 {
                    if a == 0 && b == 0 && c == 0 && d == 0 {
                        continue;
                    }
                    if sb(t, ml(t, a, d), ml(t, b, c)) != 0 {
                        continue;
                    }
                    // projective normalization: first nonzero in (z3,z4,z6,z7) = (a,c,b,d) order
                    let ord = [a, c, b, d];
                    let piv = ord.iter().find(|&&x| x != 0).cloned().unwrap();
                    if piv != 1 {
                        continue;
                    }
                    let col = if a != 0 || c != 0 { p1_norm(t, a, c) } else { p1_norm(t, b, d) };
                    let row = if a != 0 || b != 0 { p1_norm(t, a, b) } else { p1_norm(t, c, d) };
                    let f1 = (pow(t, col.0, 3), pow(t, col.1, 3));
                    let f2 = (pow(t, col.0, 9), pow(t, col.1, 9));
                    let g = [
                        row == p1_norm(t, f1.0, f1.1),
                        row == p1_norm(t, f1.1, ng(t, f1.0)),
                        row == p1_norm(t, f2.0, f2.1),
                        row == p1_norm(t, f2.1, ng(t, f2.0)),
                    ];
                    out.push(QPoint { m: [a, c, b, d], g });
                }
            }
        }
    }
    out
}

// ------------------------------------------------------------------ rng ----

struct Rng(u64);
impl Rng {
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9E3779B97F4A7C15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xBF58476D1CE4E5B9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94D049BB133111EB);
        z ^ (z >> 31)
    }
    fn f(&mut self) -> u8 {
        (self.next() % 27) as u8
    }
}

// ----------------------------------------------------------------- main ----

fn zstr(z: &[u8; 7]) -> String {
    z.iter().map(|x| x.to_string()).collect::<Vec<_>>().join(",")
}

fn hist_lines(name: &str, stratum: &str, h: &[u64]) -> String {
    let mut s = String::new();
    for (v, &c) in h.iter().enumerate() {
        if c > 0 {
            writeln!(s, "{}\t{}\t{}\t{}", stratum, name, v, c).unwrap();
        }
    }
    s
}

fn main() {
    let t0 = Instant::now();
    let tab = build_tab();
    let t: &Tab = &tab;
    let mut log = String::new();

    let args: Vec<String> = std::env::args().collect();
    let mode = args.get(1).cloned().unwrap_or_else(|| "full".to_string());
    let nthreads: usize = std::env::var("PROBE_THREADS")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(8);

    let lines = build_lines(t);
    let planes = build_planes(t);
    writeln!(log, "field: GF(27) = F3[x]/(x^3 - x - 1), elements 0..26 as base-3 digit vectors").unwrap();
    writeln!(log, "lines: {}   planes: {}", lines.len(), planes.len()).unwrap();
    let cands = build_cands(t, &lines, &planes, &mut log);
    writeln!(log, "switch candidates |B| = {}", cands.len()).unwrap();
    let n_lam1 = cands.iter().filter(|c| c.lam1).count();
    writeln!(log, "candidates with lambda = 1: {}   conjugate: {}", n_lam1, cands.len() - n_lam1).unwrap();
    let mut lams: Vec<u8> = cands.iter().map(|c| c.lambda).collect();
    lams.sort();
    lams.dedup();
    writeln!(log, "distinct lambda values over all (line,plane): {:?}", lams).unwrap();

    // ---- sanity check 1: one-point identity (16b)/(16c) ----
    {
        let mut rng = Rng(0xC973_2026_0828);
        let (mut pass, mut fail) = (0u64, 0u64);
        let mut tested = 0u64;
        while tested < 200_000 {
            let mut z = [0u8; 7];
            for k in 0..7 {
                z[k] = rng.f();
            }
            if z.iter().all(|&x| x == 0) {
                continue;
            }
            let pl = &planes[(rng.next() as usize) % planes.len()];
            let x = pl.pts[(rng.next() as usize) % 9];
            let zz = ml(t, z[1], pl.a);
            if zz == 0 {
                continue;
            }
            tested += 1;
            let rr = ad(t, ml(t, z[0], pl.b), ml(t, z[2], pl.a));
            let y = ml(t, rr, iv(t, zz));
            let phi = ad(t, dot(t, &z, &pl.powers[pl.pts.iter().position(|&p| p == x).unwrap()]), ml(t, z[0], pl.a));
            let predicate = ad(t, ml(t, sb(t, x, y), phi), zz) == 0;
            // ground truth: build g = (t-y) P(t)/(t-x) and test both Hankel equations
            let others: Vec<u8> = pl.pts.iter().cloned().filter(|&r| r != x).collect();
            let mut roots = others.clone();
            roots.push(y);
            let g = poly_from_roots(t, &roots);
            let mut e1 = 0u8;
            let mut e2 = 0u8;
            for k in 0..7 {
                e1 = ad(t, e1, ml(t, z[k], g[k + 1]));
                e2 = ad(t, e2, ml(t, z[k], g[k + 2]));
            }
            let truth = e1 == 0 && e2 == 0;
            if truth == predicate {
                pass += 1;
            } else {
                fail += 1;
            }
        }
        writeln!(log, "sanity (16c) one-point identity: pass {} fail {} (random z, plane, root; Z != 0)", pass, fail).unwrap();
    }

    // ---- sanity check 2: switch solve cross-check ----
    {
        let mut rng = Rng(0x5EED_0001);
        let (mut ok, mut bad) = (0u64, 0u64);
        let mut checked = 0u64;
        while checked < 20_000 {
            let mut z = [0u8; 7];
            for k in 0..7 {
                z[k] = rng.f();
            }
            if z.iter().all(|&x| x == 0) {
                continue;
            }
            let c = &cands[(rng.next() as usize) % cands.len()];
            let a11 = dot(t, &z, &c.w11);
            let a21 = dot(t, &z, &c.w12);
            let a12 = dot(t, &z, &c.w21);
            let a22 = dot(t, &z, &c.w22);
            let det = sb(t, ml(t, a11, a22), ml(t, a12, a21));
            if det == 0 {
                continue;
            }
            checked += 1;
            let r1 = ng(t, dot(t, &z, &c.b1));
            let r2 = ng(t, dot(t, &z, &c.b2));
            let di = iv(t, det);
            let c1 = ml(t, sb(t, ml(t, r1, a22), ml(t, a12, r2)), di);
            let c2 = ml(t, sb(t, ml(t, a11, r2), ml(t, r1, a21)), di);
            // rebuild g = Q * S explicitly from the plane and check the Hankel pair
            let pl = &planes[c.plane as usize];
            let qroots: Vec<u8> =
                pl.pts.iter().cloned().filter(|&r| r != c.x1 && r != c.x2).collect();
            let qp = poly_from_roots(t, &qroots);
            let beta = sb(t, ad(t, c1, c2), ad(t, c.x1, c.x2));
            let gamma = sb(t, ml(t, c.x1, c.x2), ad(t, ml(t, c1, c.x2), ml(t, c2, c.x1)));
            let s = [gamma, beta, 1u8];
            let mut g = vec![0u8; 10];
            for i in 0..8 {
                for j in 0..3 {
                    g[i + j] = ad(t, g[i + j], ml(t, qp[i], s[j]));
                }
            }
            let mut e1 = 0u8;
            let mut e2 = 0u8;
            for k in 0..7 {
                e1 = ad(t, e1, ml(t, z[k], g[k + 1]));
                e2 = ad(t, e2, ml(t, z[k], g[k + 2]));
            }
            if e1 == 0 && e2 == 0 && g[9] == 1 {
                ok += 1;
            } else {
                bad += 1;
            }
        }
        writeln!(log, "sanity switch solve: Q*S closes z in {} cases, fails in {}", ok, bad).unwrap();
    }

    // ---- sanity check 3: a n_good candidate really yields 9 distinct roots ----
    {
        let mut rng = Rng(0xABCD_1234);
        let mut verified = 0u64;
        let mut bad = 0u64;
        while verified < 5_000 {
            let mut z = [0u8; 7];
            for k in 0..7 {
                z[k] = rng.f();
            }
            if z.iter().all(|&x| x == 0) {
                continue;
            }
            let c = &cands[(rng.next() as usize) % cands.len()];
            let a11 = dot(t, &z, &c.w11);
            let a21 = dot(t, &z, &c.w12);
            let a12 = dot(t, &z, &c.w21);
            let a22 = dot(t, &z, &c.w22);
            let det = sb(t, ml(t, a11, a22), ml(t, a12, a21));
            if det == 0 {
                continue;
            }
            let r1 = ng(t, dot(t, &z, &c.b1));
            let r2 = ng(t, dot(t, &z, &c.b2));
            let di = iv(t, det);
            let c1 = ml(t, sb(t, ml(t, r1, a22), ml(t, a12, r2)), di);
            let c2 = ml(t, sb(t, ml(t, a11, r2), ml(t, r1, a21)), di);
            let beta = sb(t, ad(t, c1, c2), ad(t, c.x1, c.x2));
            let gamma = sb(t, ml(t, c.x1, c.x2), ad(t, ml(t, c1, c.x2), ml(t, c2, c.x1)));
            let disc = sb(t, ml(t, beta, beta), gamma);
            if disc == 0 || !t.issq[disc as usize] {
                continue;
            }
            let sq = t.sqrt[disc as usize];
            let ra = sb(t, beta, sq);
            let rb = ad(t, beta, sq);
            if (c.qmask >> ra) & 1 != 0 || (c.qmask >> rb) & 1 != 0 {
                continue;
            }
            verified += 1;
            let pl = &planes[c.plane as usize];
            let mut roots: Vec<u8> =
                pl.pts.iter().cloned().filter(|&r| r != c.x1 && r != c.x2).collect();
            roots.push(ra);
            roots.push(rb);
            let mut sorted = roots.clone();
            sorted.sort();
            sorted.dedup();
            let g = poly_from_roots(t, &roots);
            let mut e1 = 0u8;
            let mut e2 = 0u8;
            for k in 0..7 {
                e1 = ad(t, e1, ml(t, z[k], g[k + 1]));
                e2 = ad(t, e2, ml(t, z[k], g[k + 2]));
            }
            if sorted.len() != 9 || e1 != 0 || e2 != 0 || poly_eval(t, &g, ra) != 0 {
                bad += 1;
            }
        }
        writeln!(log, "sanity n_good semantics: {} good candidates verified as split 9-distinct-root locators closing z, {} bad", verified, bad).unwrap();
    }

    print!("{}", log);
    let outdir = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("out");
    fs::create_dir_all(&outdir).unwrap();

    let qpts = rank_one_points(t);
    let gc: Vec<usize> = (0..4).map(|i| qpts.iter().filter(|p| p.g[i]).count()).collect();
    writeln!(
        log,
        "rank-one projective quotient points: {}; graph-convention counts [row=sigma(col), row=J.sigma(col), row=sigma^2(col), row=J.sigma^2(col)] = {:?}",
        qpts.len(),
        gc
    )
    .unwrap();
    println!("rank-one points {} graph counts {:?}", qpts.len(), gc);

    if mode == "bench" {
        let mut rng = Rng(1);
        let mut z = [0u8; 7];
        for k in 0..7 {
            z[k] = rng.f();
        }
        let t1 = Instant::now();
        let n = 2000;
        let mut acc = 0u64;
        for i in 0..n {
            z[0] = ((i % 26) + 1) as u8;
            acc += scan(t, &cands, &planes, &z).n_good as u64;
        }
        let el = t1.elapsed();
        println!("bench: {} syndromes in {:?} => {:?}/syndrome (acc {})", n, el, el / n as u32, acc);
        let t2 = Instant::now();
        let r = exhaustive(t, &[1, 0, 0, 0, 0, 0, 0]);
        println!("bench exhaustive: {:?} in {:?}", r, t2.elapsed());
        return;
    }

    let graph_conv: usize = std::env::var("PROBE_GRAPH_CONV")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(0);
    if mode == "dump" {
        // list every syndrome whose statistics attain (or come close to) a
        // stratum minimum, with the exhaustive locator counts for each
        let gt: u16 = std::env::var("DUMP_GOOD").ok().and_then(|s| s.parse().ok()).unwrap_or(120);
        let lt: u16 = std::env::var("DUMP_LAM1").ok().and_then(|s| s.parse().ok()).unwrap_or(10);
        let nst: u16 = std::env::var("DUMP_NS").ok().and_then(|s| s.parse().ok()).unwrap_or(0);
        let names = ["rank0-kernel", "rank1-graph", "rank1-offgraph", "rank2-random"];
        let mut zs: Vec<(u8, [u8; 7])> = Vec::new();
        for z2 in 0..27u8 {
            for z5 in 0..27u8 {
                for z8 in 0..27u8 {
                    let ord = [z2, z5, z8];
                    if ord.iter().find(|&&x| x != 0).cloned() != Some(1) {
                        continue;
                    }
                    zs.push((0u8, [z2, 0, 0, z5, 0, 0, z8]));
                }
            }
        }
        for qp in &qpts {
            let s = if qp.g[graph_conv] { 1u8 } else { 2u8 };
            for z2 in 0..27u8 {
                for z5 in 0..27u8 {
                    for z8 in 0..27u8 {
                        zs.push((s, [z2, qp.m[0], qp.m[1], z5, qp.m[2], qp.m[3], z8]));
                    }
                }
            }
        }
        {
            let mut rng = Rng(0xC973_2026_0828);
            let mut n = 0;
            while n < 20_000 {
                let (a, c, b, d) = (rng.f(), rng.f(), rng.f(), rng.f());
                if sb(t, ml(t, a, d), ml(t, b, c)) == 0 {
                    continue;
                }
                let ord = [a, c, b, d];
                let piv = ord.iter().find(|&&x| x != 0).cloned().unwrap();
                let s = iv(t, piv);
                let (a, c, b, d) = (ml(t, a, s), ml(t, c, s), ml(t, b, s), ml(t, d, s));
                zs.push((3u8, [rng.f(), a, c, rng.f(), b, d, rng.f()]));
                n += 1;
            }
        }
        let chunks: Vec<&[(u8, [u8; 7])]> =
            zs.chunks((zs.len() + nthreads - 1) / nthreads).collect();
        let parts: Vec<Vec<(u8, [u8; 7], Stat)>> = std::thread::scope(|sc| {
            let handles: Vec<_> = chunks
                .iter()
                .map(|ch| {
                    let cands = &cands;
                    let planes = &planes;
                    let ch = *ch;
                    sc.spawn(move || {
                        let mut v = Vec::new();
                        for (s, z) in ch {
                            let st = scan(t, cands, planes, z);
                            if st.n_good <= gt || st.n_good_lam1 <= lt || st.n_ns <= nst {
                                v.push((*s, *z, st));
                            }
                        }
                        v
                    })
                })
                .collect();
            handles.into_iter().map(|h| h.join().unwrap()).collect()
        });
        let mut rows = String::new();
        writeln!(rows, "stratum\tz2,z3,z4,z5,z6,z7,z8\tn_nonsingular\tn_zero_disc\tn_split_distinct\tn_good\tn_good_lambda1\tn_good_conjugate\tn_onepoint\texh_split9\texh_deg8").unwrap();
        let mut all: Vec<(u8, [u8; 7], Stat)> = parts.into_iter().flatten().collect();
        all.sort_by_key(|r| (r.2.n_good, r.1));
        for (s, z, st) in &all {
            let (c9, c8) = exhaustive(t, z);
            writeln!(
                rows,
                "{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}",
                names[*s as usize], zstr(z), st.n_ns, st.n_zero, st.n_sq, st.n_good, st.n_good_lam1,
                st.n_good_conj, st.n_onept, c9, c8
            )
            .unwrap();
        }
        fs::write(outdir.join("extremes.tsv"), &rows).unwrap();
        println!("dump: {} rows, {:?}", all.len(), t0.elapsed());
        return;
    }

    // ---------------- strata -----------------
    let mut strat_names: Vec<String> = Vec::new();
    let mut accs: Vec<Acc> = Vec::new();
    let mut qrows = String::new();

    // rank 0: quotient zero, kernel (z2,z5,z8) projectively normalized
    {
        let mut a = Acc::new();
        for z2 in 0..27u8 {
            for z5 in 0..27u8 {
                for z8 in 0..27u8 {
                    let ord = [z2, z5, z8];
                    let piv = ord.iter().find(|&&x| x != 0).cloned();
                    if piv != Some(1) {
                        continue;
                    }
                    let z = [z2, 0, 0, z5, 0, 0, z8];
                    let st = scan(t, &cands, &planes, &z);
                    a.push(&z, &st);
                }
            }
        }
        strat_names.push("rank0-kernel".to_string());
        accs.push(a);
        println!("rank0 done at {:?}", t0.elapsed());
    }

    // rank 1: exhaustive over all 784 quotient points x 27^3 kernel values
    {
        let chunks: Vec<Vec<usize>> = (0..nthreads)
            .map(|w| (0..qpts.len()).filter(|i| i % nthreads == w).collect())
            .collect();
        let results: Vec<(Acc, Acc, String)> = std::thread::scope(|sc| {
            let handles: Vec<_> = chunks
                .iter()
                .map(|ch| {
                    let cands = &cands;
                    let planes = &planes;
                    let qpts = &qpts;
                    sc.spawn(move || {
                        let mut ag = Acc::new();
                        let mut ao = Acc::new();
                        let mut rows = String::new();
                        for &qi in ch {
                            let qp = &qpts[qi];
                            let on = qp.g[graph_conv];
                            let mut mn = u32::MAX;
                            let mut sum = 0u64;
                            let mut nz = 0u64;
                            for z2 in 0..27u8 {
                                for z5 in 0..27u8 {
                                    for z8 in 0..27u8 {
                                        let z = [z2, qp.m[0], qp.m[1], z5, qp.m[2], qp.m[3], z8];
                                        let st = scan(t, cands, planes, &z);
                                        if on {
                                            ag.push(&z, &st);
                                        } else {
                                            ao.push(&z, &st);
                                        }
                                        let g = st.n_good as u32;
                                        if g < mn {
                                            mn = g;
                                        }
                                        sum += g as u64;
                                        if g == 0 {
                                            nz += 1;
                                        }
                                    }
                                }
                            }
                            writeln!(
                                rows,
                                "{}\t{},{},{},{}\t{}\t{}\t{}\t{}\t{}\t{:.3}\t{}",
                                if on { "rank1-graph" } else { "rank1-offgraph" },
                                qp.m[0], qp.m[1], qp.m[2], qp.m[3],
                                qp.g[0] as u8, qp.g[1] as u8, qp.g[2] as u8, qp.g[3] as u8,
                                mn,
                                sum as f64 / 19683.0,
                                nz
                            )
                            .unwrap();
                        }
                        (ag, ao, rows)
                    })
                })
                .collect();
            handles.into_iter().map(|h| h.join().unwrap()).collect()
        });
        let mut ag = Acc::new();
        let mut ao = Acc::new();
        for (g, o, r) in &results {
            ag.merge(g);
            ao.merge(o);
            qrows.push_str(r);
        }
        strat_names.push("rank1-graph".to_string());
        accs.push(ag);
        strat_names.push("rank1-offgraph".to_string());
        accs.push(ao);
        println!("rank1 done at {:?}", t0.elapsed());
    }

    // rank 2: random sample
    {
        let nsample: usize = std::env::var("PROBE_R2")
            .ok()
            .and_then(|s| s.parse().ok())
            .unwrap_or(20_000);
        let mut rng = Rng(0xC973_2026_0828);
        let mut zs: Vec<[u8; 7]> = Vec::with_capacity(nsample);
        while zs.len() < nsample {
            let (a, c, b, d) = (rng.f(), rng.f(), rng.f(), rng.f());
            // M = [[a,b],[c,d]] = [[z3,z6],[z4,z7]]
            if sb(t, ml(t, a, d), ml(t, b, c)) == 0 {
                continue;
            }
            let ord = [a, c, b, d];
            let piv = ord.iter().find(|&&x| x != 0).cloned().unwrap();
            let s = iv(t, piv);
            let (a, c, b, d) = (ml(t, a, s), ml(t, c, s), ml(t, b, s), ml(t, d, s));
            zs.push([rng.f(), a, c, rng.f(), b, d, rng.f()]);
        }
        let chunks: Vec<&[[u8; 7]]> = zs.chunks((nsample + nthreads - 1) / nthreads).collect();
        let parts: Vec<Acc> = std::thread::scope(|sc| {
            let handles: Vec<_> = chunks
                .iter()
                .map(|ch| {
                    let cands = &cands;
                    let planes = &planes;
                    let ch = *ch;
                    sc.spawn(move || {
                        let mut a = Acc::new();
                        for z in ch {
                            let st = scan(t, cands, planes, z);
                            a.push(z, &st);
                        }
                        a
                    })
                })
                .collect();
            handles.into_iter().map(|h| h.join().unwrap()).collect()
        });
        let mut a = Acc::new();
        for p in &parts {
            a.merge(p);
        }
        strat_names.push("rank2-random".to_string());
        accs.push(a);
        println!("rank2 done at {:?}", t0.elapsed());
    }

    // ---------------- fallback for failures ----------------
    let mut fail_rows = String::new();
    writeln!(fail_rows, "stratum\tz2,z3,z4,z5,z6,z7,z8\tn_nonsingular\tn_zero_disc\tn_split_distinct\tn_good\tn_onept\texh_split9\texh_deg8").unwrap();
    let fallback_cap: usize = std::env::var("PROBE_FALLBACK_CAP")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(1024);
    let mut total_fail = 0u64;
    for (si, a) in accs.iter().enumerate() {
        total_fail += a.h_good[0];
        let list: Vec<[u8; 7]> = a.fails.iter().cloned().take(fallback_cap).collect();
        if list.is_empty() {
            continue;
        }
        let chunks: Vec<&[[u8; 7]]> =
            list.chunks((list.len() + nthreads - 1) / nthreads).collect();
        let parts: Vec<Vec<([u8; 7], Stat, u64, u64)>> = std::thread::scope(|sc| {
            let handles: Vec<_> = chunks
                .iter()
                .map(|ch| {
                    let cands = &cands;
                    let planes = &planes;
                    let ch = *ch;
                    sc.spawn(move || {
                        ch.iter()
                            .map(|z| {
                                let st = scan(t, cands, planes, z);
                                let (f9, f8) = exhaustive(t, z);
                                (*z, st, f9, f8)
                            })
                            .collect::<Vec<_>>()
                    })
                })
                .collect();
            handles.into_iter().map(|h| h.join().unwrap()).collect()
        });
        for p in &parts {
            for (z, st, f9, f8) in p {
                writeln!(
                    fail_rows,
                    "{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}",
                    strat_names[si],
                    zstr(z),
                    st.n_ns,
                    st.n_zero,
                    st.n_sq,
                    st.n_good,
                    st.n_onept,
                    f9,
                    f8
                )
                .unwrap();
            }
        }
    }

    // ---------------- output ----------------
    let mut hist = String::new();
    writeln!(hist, "stratum\tmetric\tvalue\tcount").unwrap();
    let mut summ = String::new();
    writeln!(summ, "stratum\tn_syndromes\tmin_n_good\tmean_n_good\tmin_n_good_lam1\tmean_n_good_lam1\tmean_n_good_conj\tmin_n_onept\tmean_n_onept\tmean_n_nonsingular\tmean_n_zero_disc\tmean_n_split_distinct\tn_good_zero_count\targmin_n_good\targmin_n_good_lam1\targmin_n_onept").unwrap();
    for (si, a) in accs.iter().enumerate() {
        let n = a.count.max(1) as f64;
        hist.push_str(&hist_lines("n_good", &strat_names[si], &a.h_good));
        hist.push_str(&hist_lines("n_nonsingular", &strat_names[si], &a.h_ns));
        hist.push_str(&hist_lines("n_split_distinct", &strat_names[si], &a.h_sq));
        hist.push_str(&hist_lines("n_zero_disc", &strat_names[si], &a.h_zero));
        hist.push_str(&hist_lines("n_good_lambda1", &strat_names[si], &a.h_good_lam1));
        hist.push_str(&hist_lines("n_good_conjugate", &strat_names[si], &a.h_good_conj));
        hist.push_str(&hist_lines("n_onepoint", &strat_names[si], &a.h_onept));
        writeln!(
            summ,
            "{}\t{}\t{}\t{:.4}\t{}\t{:.4}\t{:.4}\t{}\t{:.4}\t{:.4}\t{:.4}\t{:.4}\t{}\t{}\t{}\t{}",
            strat_names[si],
            a.count,
            a.min_good,
            a.s_good as f64 / n,
            a.min_good_lam1,
            a.s_good_lam1 as f64 / n,
            a.s_good_conj as f64 / n,
            a.min_onept,
            a.s_onept as f64 / n,
            a.s_ns as f64 / n,
            a.s_zero as f64 / n,
            a.s_sq as f64 / n,
            a.h_good[0],
            zstr(&a.argmin_good),
            zstr(&a.argmin_good_lam1),
            zstr(&a.argmin_onept)
        )
        .unwrap();
    }

    let elapsed = t0.elapsed();
    writeln!(log, "total syndromes with n_good = 0 across strata: {}", total_fail).unwrap();
    writeln!(log, "wall time: {:.2} s, threads {}", elapsed.as_secs_f64(), nthreads).unwrap();

    fs::write(outdir.join("histograms.tsv"), &hist).unwrap();
    fs::write(outdir.join("summary.tsv"), &summ).unwrap();
    let mut qh = String::new();
    writeln!(qh, "stratum\tz3,z4,z6,z7\tgraph_sigma\tgraph_J_sigma\tgraph_sigma2\tgraph_J_sigma2\tmin_n_good\tmean_n_good\tcount_n_good_zero").unwrap();
    qh.push_str(&qrows);
    fs::write(outdir.join("quotient_points.tsv"), &qh).unwrap();
    fs::write(outdir.join("failures.tsv"), &fail_rows).unwrap();
    fs::write(outdir.join("checks.txt"), &log).unwrap();
    print!("{}", log);
    std::io::stdout().flush().unwrap();
}
