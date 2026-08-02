// C756 — all-k conic-filling classification: exhaustive search over conic-external arcs.
//
// Setting.  C is the nonsingular conic Q(x,y,z) = y^2 - x z in PG(2,q), q odd.
// For a k-arc A, U(A) is the set of points on no chord (= secant of A).
//
// Reformulation used here (proved in the companion report):
//   U(A) = C  <=>  (E) every chord of A is external to C (disjoint from C), and
//                  (C) the chords cover every one of the q^2 points off C.
// (E) is equivalent to the pointwise character condition
//   chi( B(P,P')^2 - Q(P) Q(P') ) = -1     for all P != P' in A,
// where B is the polarization of Q.  A set satisfying (E) is a "conic-external arc".
//
// This program
//   * builds the conic-external graph on the q^2 points off C,
//   * searches for arcs (no 3 collinear) that are cliques of that graph,
//   * reports m(q) = the largest such arc, and
//   * tests condition (C) on every conic-external arc of size >= kmin(q),
//     where kmin(q) is the LP covering threshold (see report).
//
// Modes:
//   max     : exact m(q) (largest conic-external arc)
//   classify: enumerate all conic-filling arcs (any k); uses target = kmin(q)
//
// Build/run:
//   rustc -O -o /tmp/c756 notes/2026-08-01-c756-all-k-conic-filling.rs
//   /tmp/c756 max 13
//   /tmp/c756 classify 13
//
// Output is a single canonical JSON object on stdout.

use std::env;

// ---------------------------------------------------------------- finite field

struct Field {
    p: usize,
    n: usize,
    q: usize,
    mul: Vec<u16>,
    add: Vec<u16>,
    inv: Vec<u16>,
    is_sq: Vec<bool>, // is_sq[a] for a != 0
}

fn poly_mul_mod(a: usize, b: usize, p: usize, n: usize, modpoly: &[usize]) -> usize {
    // elements are base-p digit vectors, digit i = coefficient of x^i
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
    // reduce: x^n = -(modpoly[0..n]) where modpoly is the monic irreducible's low coeffs
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
    // monic x^n + sum coeffs[i] x^i; test no roots for n<=3, full factor test via
    // brute-force trial division by all monic polys of degree <= n/2
    // (n is small here: <= 4)
    fn eval_poly(cs: &[usize], n: usize, x: usize, p: usize) -> usize {
        let mut v = 1usize; // leading monic term
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
    // n == 4: no roots and no quadratic factor
    for x in 0..p {
        if eval_poly(coeffs, n, x, p) == 0 {
            return false;
        }
    }
    // trial divide by monic quadratics x^2 + b x + c
    for b in 0..p {
        for c in 0..p {
            // long division of x^4 + a3 x^3 + a2 x^2 + a1 x + a0 by x^2+bx+c
            let (a3, a2, a1, a0) = (coeffs[3], coeffs[2], coeffs[1], coeffs[0]);
            let q1 = 1usize;
            let q0 = (a3 + p - (b * q1) % p) % p;
            let r1 = (a1 + p - (c * q0) % p) % p;
            let r0 = (a0 + p - (c * q0 * 0) % p) % p; // placeholder, recomputed below
            let _ = r0;
            // remainder: x^4+a3x^3+a2x^2+a1x+a0 - (x^2+bx+c)(x^2+q0 x + q_c)
            // solve q_c from x^2 coefficient: a2 = q_c + b*q0 + c
            let qc = (a2 + 2 * p - (b * q0) % p - c % p) % p;
            let rem1 = (a1 + 2 * p - (b * qc) % p - (c * q0) % p) % p;
            let rem0 = (a0 + p - (c * qc) % p) % p;
            let _ = r1;
            if rem1 == 0 && rem0 == 0 {
                return false;
            }
        }
    }
    true
}

impl Field {
    fn new(q: usize) -> Field {
        // factor q = p^n
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
            // iterate candidate low coefficient tuples in canonical (lex) order
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
                    // digitwise addition mod p
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
        // digitwise negation mod p
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

struct Plane {
    f: Field,
    pts: Vec<[usize; 3]>,
    index: Vec<i32>, // lookup by x + q*y + q*q*z on normalized representative
    off: Vec<usize>, // indices of points off C, in increasing order
    pos: Vec<i32>,   // point index -> position in off, or -1
    adj: Vec<Vec<u64>>, // over off-positions
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
        let mut pl = Plane {
            f,
            pts,
            index,
            off: vec![],
            pos: vec![],
            adj: vec![],
            words: 0,
        };
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
    // polarization of y^2 - x z : B(P,R) = y v - (x w + z u)/2
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
    // all points of the line through point-indices i != j
    fn line(&self, i: usize, j: usize, out: &mut Vec<usize>) {
        let f = &self.f;
        out.clear();
        let a = self.pts[i];
        let b = self.pts[j];
        for t in 0..f.q {
            let v = [
                f.a(a[0], f.m(t, b[0])),
                f.a(a[1], f.m(t, b[1])),
                f.a(a[2], f.m(t, b[2])),
            ];
            out.push(self.normalize(v));
        }
        out.push(j);
    }
}

// ---------------------------------------------------------------- covering LP threshold

fn binom(n: u128, k: u128) -> u128 {
    if k > n {
        return 0;
    }
    let mut r: u128 = 1;
    for i in 0..k {
        r = r * (n - i) / (i + 1);
    }
    r
}

/// Largest number of points off C that b = C(k,2) chords can cover, from the two
/// exact chord moments plus the degree caps (arc points: k-1; other points: floor(k/2)).
fn max_covered(k: u128, q: u128) -> u128 {
    let b = binom(k, 2);
    let s1 = b * (q + 1) - k * (k - 1); // chord-incidences at non-arc points
    let s2 = 3 * binom(k, 4); // chord pairs meeting at non-arc points
    let d = k / 2;
    // LP bound: count <= s1 - 2*s2/d  (ceil the subtracted term)
    let sub = (2 * s2 + d - 1) / d;
    k + s1.saturating_sub(sub)
}

fn kmin_lp(q: u128) -> u128 {
    let mut k = 4u128;
    loop {
        if max_covered(k, q) >= q * q {
            return k;
        }
        k += 1;
        assert!(k < 10000);
    }
}

/// Spare-external-line bound.  If some arc point P lies on an external line that is
/// not a chord, that line's other q points are covered only by the C(k-1,2) chords
/// missing P, so C(k-1,2) >= q.  Otherwise every arc point is saturated, forcing
/// k - 1 = (q-1)/2 or (q+1)/2, i.e. k >= (q+1)/2.
fn kmin_line(q: u128) -> u128 {
    let mut k = 3u128;
    while binom(k - 1, 2) < q {
        k += 1;
    }
    let sat = (q + 1) / 2;
    if sat < k {
        sat
    } else {
        k
    }
}

fn kmin(q: u128) -> u128 {
    let a = kmin_lp(q);
    let b = kmin_line(q);
    if a > b {
        a
    } else {
        b
    }
}

// ---------------------------------------------------------------- search

struct Search<'a> {
    pl: &'a Plane,
    words: usize,
    best: usize,
    best_set: Vec<usize>,
    target: usize, // stop-expanding threshold for pruning (0 = find true max)
    found: Vec<Vec<usize>>,
    check_cover: bool,
    nodes: u64,
    linebuf: Vec<usize>,
}

fn popcnt(v: &[u64]) -> usize {
    v.iter().map(|w| w.count_ones() as usize).sum()
}

impl<'a> Search<'a> {
    fn dfs(&mut self, chosen: &mut Vec<usize>, cand: &[u64], forb: &[u64]) {
        self.nodes += 1;
        let sz = chosen.len();
        if sz > self.best {
            self.best = sz;
            self.best_set = chosen.clone();
        }
        if self.check_cover && sz >= self.target {
            if self.covers(chosen) {
                self.found.push(chosen.clone());
            }
        }
        // In `max` mode we want the true maximum, so a branch is useless unless it can
        // beat `best`.  In `classify` mode we must keep every branch that can still
        // reach the covering threshold `target`.
        let need = if self.check_cover { self.target } else { self.best + 1 };
        let avail = popcnt(cand);
        if sz + avail < need {
            return;
        }
        // iterate candidates
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
            // prune: remaining candidates including v
            let rem = popcnt(&c) + 1;
            let need2 = if self.check_cover { self.target } else { self.best + 1 };
            if sz + rem < need2 {
                break;
            }
            // new forbidden = forb | union of lines v-u for u in chosen
            let mut nf = forb.to_vec();
            let vp = self.pl.off[v];
            let mut lb = std::mem::take(&mut self.linebuf);
            for &u in chosen.iter() {
                let up = self.pl.off[u];
                self.pl.line(up, vp, &mut lb);
                for &w in lb.iter() {
                    let p = self.pl.pos[w];
                    if p >= 0 {
                        let p = p as usize;
                        nf[p / 64] |= 1u64 << (p % 64);
                    }
                }
            }
            self.linebuf = lb;
            let mut nc = vec![0u64; self.words];
            let adjv = &self.pl.adj[v];
            for w in 0..self.words {
                nc[w] = c[w] & adjv[w] & !nf[w];
            }
            chosen.push(v);
            self.dfs(chosen, &nc, &nf);
            chosen.pop();
        }
    }

    fn covers(&mut self, chosen: &[usize]) -> bool {
        let m = self.pl.off.len();
        let mut seen = vec![false; m];
        let mut lb = std::mem::take(&mut self.linebuf);
        for i in 0..chosen.len() {
            for j in (i + 1)..chosen.len() {
                self.pl.line(self.pl.off[chosen[i]], self.pl.off[chosen[j]], &mut lb);
                for &w in lb.iter() {
                    let p = self.pl.pos[w];
                    if p >= 0 {
                        seen[p as usize] = true;
                    }
                }
            }
        }
        self.linebuf = lb;
        seen.iter().all(|&b| b)
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mode = args[1].clone();
    let q: usize = args[2].parse().unwrap();
    let pl = Plane::new(q);
    let km = kmin(q as u128) as usize;

    // PGL(2,q) = the stabiliser of C is transitive on internal points and on
    // external points, so it suffices to run one representative of each type.
    let mut reps: Vec<usize> = vec![];
    for t in [1i32, -1i32] {
        for (i, &p) in pl.off.iter().enumerate() {
            if pl.f.chi(pl.qform(p)) == t {
                reps.push(i);
                break;
            }
        }
    }

    let words = pl.words;
    let mut best = 0usize;
    let mut best_set: Vec<usize> = vec![];
    let mut found: Vec<Vec<usize>> = vec![];
    let mut nodes = 0u64;
    let check_cover = mode == "classify";
    let target = if check_cover { km } else { 0 };

    for &r in reps.iter() {
        let mut s = Search {
            pl: &pl,
            words,
            best: 0,
            best_set: vec![],
            target,
            found: vec![],
            check_cover,
            nodes: 0,
            linebuf: Vec::with_capacity(q + 2),
        };
        let mut cand = vec![0u64; words];
        for w in 0..words {
            cand[w] = pl.adj[r][w];
        }
        // restrict to indices > r to avoid re-deriving smaller-index equivalents is NOT
        // valid after orbit reduction; keep the full neighbourhood.
        let mut chosen = vec![r];
        let forb = vec![0u64; words];
        s.dfs(&mut chosen, &cand, &forb);
        if s.best > best {
            best = s.best;
            best_set = s.best_set.clone();
        }
        found.extend(s.found.into_iter());
        nodes += s.nodes;
        let _ = &mut cand;
    }

    let pt = |i: &usize| -> String {
        let p = pl.pts[pl.off[*i]];
        format!("[{},{},{}]", p[0], p[1], p[2])
    };
    let bs: Vec<String> = best_set.iter().map(pt).collect();
    let fs: Vec<String> = found
        .iter()
        .map(|a| {
            let v: Vec<String> = a.iter().map(pt).collect();
            format!("{{\"k\":{},\"points\":[{}]}}", a.len(), v.join(","))
        })
        .collect();
    println!(
        "{{\"q\":{},\"p\":{},\"n\":{},\"kmin\":{},\"mode\":\"{}\",\"m_q\":{},\"witness\":[{}],\"conic_filling\":[{}],\"nodes\":{}}}",
        q,
        pl.f.p,
        pl.f.n,
        km,
        mode,
        best,
        bs.join(","),
        fs.join(","),
        nodes
    );
}
