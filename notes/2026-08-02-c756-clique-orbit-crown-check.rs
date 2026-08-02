// C756: do the two known maximal-clique orbits of the Paley graph P(q^2) ever
// satisfy the crown condition (B) of a coherent system?
//
// Build:  rustc -O -o <scratch>/c756 2026-08-02-c756-clique-orbit-crown-check.rs
// Run:    <scratch>/c756 --max <QMAX> --exhaustive-max <QEX> --out <path.json>
//
// Conventions
//   q = p^m odd, q = 3 (mod 4) for the orbit sweep.
//   F_q is built from the lexicographically first monic irreducible poly of degree m
//     over F_p (little-endian digit order, digit i = coefficient of x^i); an element is
//     the integer whose base-p digits are its coefficients.
//   eps = the smallest nonsquare of F_q under that integer encoding.
//   F_{q^2} = F_q(s), s^2 = eps; element x + y*s is encoded as the index x*q + y.
//   conjugation (x + y s)^q = x - y s;  N(z) = z^{q+1} = x^2 - eps y^2.
//   chi(u) = quadratic character of F_{q^2} = quadratic character of N(u) in F_q.
//   t = (q+1)/2, k = t+1 = (q+3)/2, delta = (-1)^t.
//
// A coherent system is Z subset of F_{q^2} \ F_q, |Z| = k, no two elements conjugate,
//   (A) chi(z_i - z_j)   =  delta  for i != j
//   (B) chi(z_i - z_j^q) = -delta  for i != j
//   (D) chi(z_i - z_i^q) =  delta  (automatic for irrational z_i)

use std::env;
use std::fs;
use std::time::{Duration, Instant};

// ---------------------------------------------------------------- F_p poly helpers

fn pow_mod(mut b: u64, mut e: u64, p: u64) -> u64 {
    let mut r = 1u64;
    b %= p;
    while e > 0 {
        if e & 1 == 1 {
            r = r * b % p;
        }
        b = b * b % p;
        e >>= 1;
    }
    r
}

fn poly_trim(v: &mut Vec<u64>) {
    while let Some(&l) = v.last() {
        if l == 0 {
            v.pop();
        } else {
            break;
        }
    }
}

/// remainder of a modulo the monic-or-not polynomial b over F_p
fn poly_rem(a: &[u64], b: &[u64], p: u64) -> Vec<u64> {
    let mut r = a.to_vec();
    poly_trim(&mut r);
    let db = b.len() - 1;
    let lead_inv = pow_mod(b[db], p - 2, p);
    while r.len() > db {
        let dr = r.len() - 1;
        let coef = r[dr] * lead_inv % p;
        for i in 0..=db {
            let idx = dr - db + i;
            r[idx] = (r[idx] + p - coef * b[i] % p) % p;
        }
        poly_trim(&mut r);
    }
    r
}

fn digits(mut code: usize, p: usize, n: usize) -> Vec<u64> {
    let mut v = Vec::with_capacity(n);
    for _ in 0..n {
        v.push((code % p) as u64);
        code /= p;
    }
    v
}

/// monic polynomial of degree d whose lower coefficients are the base-p digits of `code`
fn monic(code: usize, p: usize, d: usize) -> Vec<u64> {
    let mut v = digits(code, p, d);
    v.push(1);
    v
}

fn is_irreducible(f: &[u64], p: usize, m: usize) -> bool {
    // trial division by every monic polynomial of degree 1..=m/2
    for d in 1..=(m / 2) {
        let lim = p.pow(d as u32);
        for code in 0..lim {
            let g = monic(code, p, d);
            if poly_rem(f, &g, p as u64).is_empty() {
                return false;
            }
        }
    }
    true
}

// ---------------------------------------------------------------- F_q

struct Fq {
    p: usize,
    m: usize,
    q: usize,
    modulus: Vec<u64>, // lower m coefficients of the monic defining polynomial
    add: Vec<u16>,
    mul: Vec<u16>,
    neg: Vec<u16>,
    sq: Vec<i8>, // 0 for zero, +1 square, -1 nonsquare
    eps: usize,
    gen: usize, // a primitive element of F_q^*
}

impl Fq {
    #[inline]
    fn a(&self, x: usize, y: usize) -> usize {
        self.add[x * self.q + y] as usize
    }
    #[inline]
    fn s(&self, x: usize, y: usize) -> usize {
        self.add[x * self.q + self.neg[y] as usize] as usize
    }
    #[inline]
    fn m_(&self, x: usize, y: usize) -> usize {
        self.mul[x * self.q + y] as usize
    }

    fn new(p: usize, m: usize) -> Fq {
        let q = p.pow(m as u32);
        assert!(q <= 65535);
        // defining polynomial
        let modulus: Vec<u64> = if m == 1 {
            vec![]
        } else {
            let mut found = None;
            for code in 0..p.pow(m as u32) {
                let f = monic(code, p, m);
                if is_irreducible(&f, p, m) {
                    found = Some(f);
                    break;
                }
            }
            let f = found.expect("no irreducible polynomial found");
            f[..m].to_vec()
        };

        let mut add = vec![0u16; q * q];
        let mut neg = vec![0u16; q];
        for i in 0..q {
            let di = digits(i, p, m);
            for j in 0..q {
                let dj = digits(j, p, m);
                let mut code = 0usize;
                for t in (0..m).rev() {
                    code = code * p + ((di[t] + dj[t]) % p as u64) as usize;
                }
                add[i * q + j] = code as u16;
            }
            let mut code = 0usize;
            for t in (0..m).rev() {
                code = code * p + ((p as u64 - di[t]) % p as u64) as usize;
            }
            neg[i] = code as u16;
        }

        let mut mul = vec![0u16; q * q];
        for i in 0..q {
            let di = digits(i, p, m);
            for j in 0..=i {
                let dj = digits(j, p, m);
                // convolve
                let mut c = vec![0u64; 2 * m - 1];
                for x in 0..m {
                    if di[x] == 0 {
                        continue;
                    }
                    for y in 0..m {
                        c[x + y] = (c[x + y] + di[x] * dj[y]) % p as u64;
                    }
                }
                // reduce mod x^m + sum modulus[t] x^t
                if m > 1 {
                    for d in (m..2 * m - 1).rev() {
                        let coef = c[d];
                        if coef == 0 {
                            continue;
                        }
                        c[d] = 0;
                        for t in 0..m {
                            let idx = d - m + t;
                            c[idx] = (c[idx] + p as u64 - coef * modulus[t] % p as u64) % p as u64;
                        }
                    }
                }
                let mut code = 0usize;
                for t in (0..m).rev() {
                    code = code * p + c[t] as usize;
                }
                mul[i * q + j] = code as u16;
                mul[j * q + i] = code as u16;
            }
        }

        let mut sq = vec![-1i8; q];
        sq[0] = 0;
        for i in 1..q {
            sq[mul[i * q + i] as usize] = 1;
        }

        let eps = (1..q).find(|&i| sq[i] == -1).expect("no nonsquare");

        // primitive element
        let mut gen = 0usize;
        'outer: for g in 2..q {
            let mut x = g;
            let mut ord = 1usize;
            while x != 1 {
                x = mul[x * q + g] as usize;
                ord += 1;
                if ord > q {
                    continue 'outer;
                }
            }
            if ord == q - 1 {
                gen = g;
                break;
            }
        }
        assert!(gen != 0 || q == 2);

        Fq { p, m, q, modulus, add, mul, neg, sq, eps, gen }
    }
}

// ---------------------------------------------------------------- F_{q^2}

struct F2 {
    f: Fq,
    q: usize,
    t: usize,
    k: usize,
    delta: i8,
    chi: Vec<i8>, // indexed by x*q + y
}

#[inline]
fn xy(idx: usize, q: usize) -> (usize, usize) {
    (idx / q, idx % q)
}

impl F2 {
    fn new(p: usize, m: usize) -> F2 {
        let f = Fq::new(p, m);
        let q = f.q;
        let t = (q + 1) / 2;
        let k = t + 1;
        let delta: i8 = if t % 2 == 0 { 1 } else { -1 };
        let mut chi = vec![0i8; q * q];
        for x in 0..q {
            let x2 = f.m_(x, x);
            for y in 0..q {
                let n = f.s(x2, f.m_(f.eps, f.m_(y, y)));
                chi[x * q + y] = f.sq[n];
            }
        }
        F2 { f, q, t, k, delta, chi }
    }
    #[inline]
    fn add2(&self, a: usize, b: usize) -> usize {
        let (ax, ay) = xy(a, self.q);
        let (bx, by) = xy(b, self.q);
        self.f.a(ax, bx) * self.q + self.f.a(ay, by)
    }
    #[inline]
    fn sub2(&self, a: usize, b: usize) -> usize {
        let (ax, ay) = xy(a, self.q);
        let (bx, by) = xy(b, self.q);
        self.f.s(ax, bx) * self.q + self.f.s(ay, by)
    }
    #[inline]
    fn mul2(&self, a: usize, b: usize) -> usize {
        let (ax, ay) = xy(a, self.q);
        let (bx, by) = xy(b, self.q);
        let re = self.f.a(self.f.m_(ax, bx), self.f.m_(self.f.eps, self.f.m_(ay, by)));
        let im = self.f.a(self.f.m_(ax, by), self.f.m_(ay, bx));
        re * self.q + im
    }
    #[inline]
    fn conj(&self, a: usize) -> usize {
        let (ax, ay) = xy(a, self.q);
        ax * self.q + self.f.neg[ay] as usize
    }
    #[inline]
    fn chi_of(&self, a: usize) -> i8 {
        self.chi[a]
    }
    fn pow2(&self, a: usize, mut e: usize) -> usize {
        let mut r = 1 * self.q + 0; // element 1 = (1,0)
        let mut b = a;
        while e > 0 {
            if e & 1 == 1 {
                r = self.mul2(r, b);
            }
            b = self.mul2(b, b);
            e >>= 1;
        }
        r
    }
    #[inline]
    fn is_irrational(&self, a: usize) -> bool {
        a % self.q != 0
    }

    /// Generic coherent-system tester.
    fn is_coherent(&self, z: &[usize]) -> bool {
        if z.len() != self.k {
            return false;
        }
        for i in 0..z.len() {
            if !self.is_irrational(z[i]) {
                return false;
            }
            if self.chi_of(self.sub2(z[i], self.conj(z[i]))) != self.delta {
                return false;
            }
            for j in 0..z.len() {
                if i == j {
                    continue;
                }
                if z[i] == z[j] || z[i] == self.conj(z[j]) {
                    return false;
                }
                if self.chi_of(self.sub2(z[i], z[j])) != self.delta {
                    return false;
                }
                if self.chi_of(self.sub2(z[i], self.conj(z[j]))) != -self.delta {
                    return false;
                }
            }
        }
        true
    }
}

// ---------------------------------------------------------------- bitsets

#[derive(Clone)]
struct Bits {
    w: Vec<u64>,
}
impl Bits {
    fn new(n: usize) -> Bits {
        Bits { w: vec![0u64; (n + 63) / 64] }
    }
    #[inline]
    fn set(&mut self, i: usize) {
        self.w[i >> 6] |= 1u64 << (i & 63);
    }
    #[inline]
    fn get(&self, i: usize) -> bool {
        self.w[i >> 6] >> (i & 63) & 1 == 1
    }
    #[inline]
    fn count(&self) -> usize {
        self.w.iter().map(|x| x.count_ones() as usize).sum()
    }
    #[inline]
    fn and_into(&self, o: &Bits, out: &mut Bits) {
        for i in 0..self.w.len() {
            out.w[i] = self.w[i] & o.w[i];
        }
    }
}

// ---------------------------------------------------------------- JSON helper

fn jstr(s: &str) -> String {
    format!("\"{}\"", s.replace('\\', "\\\\").replace('"', "\\\""))
}

// ---------------------------------------------------------------- main work

struct Row {
    q: usize,
    p: usize,
    m: usize,
    eps: usize,
    k: usize,
    delta: i8,
    circle_size: usize,
    q0_size: usize,
    q1_size: usize,
    s_clique: [bool; 2],
    s_maximal: [bool; 2],
    reduction_ok: bool,
    triples_tested: u64,
    triples_passed: u64,
    passes: Vec<String>,
    seconds: f64,
    exhaustive: Option<Exh>,
}

struct Exh {
    vertices: usize,
    aut_verified: bool,
    transitive: bool,
    cliques_through_s: u64,
    completed: bool,
    seconds: f64,
}

fn circle(f2: &F2) -> Vec<usize> {
    let q = f2.q;
    let mut c = Vec::new();
    for x in 0..q {
        for y in 0..q {
            let idx = x * q + y;
            if idx == 0 {
                continue;
            }
            let (xx, yy) = (x, y);
            let n = f2.f.s(f2.f.m_(xx, xx), f2.f.m_(f2.f.eps, f2.f.m_(yy, yy)));
            if n == 1 {
                c.push(idx);
            }
        }
    }
    c
}

fn run_q(p: usize, m: usize, exhaustive: bool, exh_budget: Duration) -> Row {
    let start = Instant::now();
    let f2 = F2::new(p, m);
    let q = f2.q;
    let k = f2.k;
    assert_eq!(q % 4, 3, "orbit sweep only defined for q = 3 mod 4");
    assert_eq!(f2.delta, 1);

    let c = circle(&f2);
    let half = (q + 1) / 2;
    let mut q0: Vec<usize> = Vec::new();
    let mut q1: Vec<usize> = Vec::new();
    let one = 1 * q;
    for &z in &c {
        if f2.pow2(z, half) == one {
            q0.push(z);
        } else {
            q1.push(z);
        }
    }
    let mut s: [Vec<usize>; 2] = [q0.clone(), q1.clone()];
    for j in 0..2 {
        s[j].push(0);
        s[j].sort();
    }

    // ---- setup validation
    let mut s_clique = [true, true];
    let mut s_maximal = [true, true];
    for j in 0..2 {
        if s[j].len() != k {
            s_clique[j] = false;
        }
        for ii in 0..s[j].len() {
            for jj in 0..ii {
                if f2.chi_of(f2.sub2(s[j][ii], s[j][jj])) != 1 {
                    s_clique[j] = false;
                }
            }
        }
        // maximality
        'outer: for w in 0..q * q {
            if s[j].contains(&w) {
                continue;
            }
            for &u in &s[j] {
                if f2.chi_of(f2.sub2(w, u)) != 1 {
                    continue 'outer;
                }
            }
            s_maximal[j] = false;
            break;
        }
    }

    // ---- verify the b -> c = b - b^q reduction
    let mut reduction_ok = true;
    {
        // (i) {b - b^q} is exactly s*F_q and each fiber has size q
        let mut cnt = vec![0usize; q * q];
        for b in 0..q * q {
            let cc = f2.sub2(b, f2.conj(b));
            cnt[cc] += 1;
        }
        for idx in 0..q * q {
            let (x, _y) = xy(idx, q);
            if cnt[idx] != 0 && (x != 0 || cnt[idx] != q) {
                reduction_ok = false;
            }
        }
        let images = (0..q).filter(|&y| cnt[y] == q).count();
        if images != q {
            reduction_ok = false;
        }
        // (ii) same c => identical chi signature, for a deterministic sample
        let mut rng: u64 = 0x9E3779B97F4A7C15 ^ (q as u64);
        let mut next = || {
            rng ^= rng << 13;
            rng ^= rng >> 7;
            rng ^= rng << 17;
            rng
        };
        for _ in 0..20 {
            let a = (next() as usize) % (q * q);
            if f2.chi_of(a) != 1 {
                continue;
            }
            let j = (next() as usize) % 2;
            let b1 = (next() as usize) % (q * q);
            let c1 = f2.sub2(b1, f2.conj(b1));
            let b2 = loop {
                let b = (next() as usize) % (q * q);
                if f2.sub2(b, f2.conj(b)) == c1 {
                    break b;
                }
            };
            let z1: Vec<usize> = s[j].iter().map(|&u| f2.add2(f2.mul2(a, u), b1)).collect();
            let z2: Vec<usize> = s[j].iter().map(|&u| f2.add2(f2.mul2(a, u), b2)).collect();
            for ii in 0..k {
                for jj in 0..k {
                    let v1 = f2.chi_of(f2.sub2(z1[ii], f2.conj(z1[jj])));
                    let v2 = f2.chi_of(f2.sub2(z2[ii], f2.conj(z2[jj])));
                    if v1 != v2 {
                        reduction_ok = false;
                    }
                    let w1 = f2.chi_of(f2.sub2(z1[ii], z1[jj]));
                    let w2 = f2.chi_of(f2.sub2(z2[ii], z2[jj]));
                    if w1 != w2 {
                        reduction_ok = false;
                    }
                }
            }
        }
    }

    // ---- main orbit sweep
    let alist: Vec<usize> = (0..q * q).filter(|&a| f2.chi_of(a) == 1).collect();
    let mut triples_tested: u64 = 0;
    let mut triples_passed: u64 = 0;
    let mut passes: Vec<String> = Vec::new();

    let mut av = vec![0usize; k];
    let mut bv = vec![0usize; k];
    for j in 0..2 {
        let sj = &s[j];
        for &a in &alist {
            let aq = f2.conj(a);
            for i in 0..k {
                av[i] = f2.mul2(a, sj[i]);
                bv[i] = f2.mul2(aq, f2.conj(sj[i]));
            }
            // early-rejection entries: (0,1), (1,0), (0,0)
            let d01 = f2.sub2(av[0], bv[1]);
            let d10 = f2.sub2(av[1], bv[0]);
            let d00 = f2.sub2(av[0], bv[0]);
            let (x01, y01) = xy(d01, q);
            let (x10, y10) = xy(d10, q);
            let (x00, y00) = xy(d00, q);
            for cy in 0..q {
                triples_tested += 1;
                if f2.chi[x01 * q + f2.f.a(y01, cy)] != -1 {
                    continue;
                }
                if f2.chi[x10 * q + f2.f.a(y10, cy)] != -1 {
                    continue;
                }
                if f2.chi[x00 * q + f2.f.a(y00, cy)] != 1 {
                    continue;
                }
                // full check
                let cc = 0 * q + cy;
                let mut ok = true;
                'full: for ii in 0..k {
                    for jj in 0..k {
                        let w = f2.add2(f2.sub2(av[ii], bv[jj]), cc);
                        let want = if ii == jj { 1i8 } else { -1i8 };
                        if f2.chi_of(w) != want {
                            ok = false;
                            break 'full;
                        }
                    }
                    // condition (A)
                    for jj in 0..ii {
                        if f2.chi_of(f2.sub2(av[ii], av[jj])) != 1 {
                            ok = false;
                            break 'full;
                        }
                    }
                }
                if ok {
                    // independent confirmation with the generic tester, using b = c/... :
                    // any b with b - b^q = c works; c itself is such a b (c^q = -c, so
                    // c - c^q = 2c). Use b = c * inv(2) in F_{q^2}: 2 is in F_q.
                    let two = f2.f.a(1, 1);
                    let inv2 = {
                        let mut r = 1;
                        for x in 1..q {
                            if f2.f.m_(two, x) == 1 {
                                r = x;
                                break;
                            }
                        }
                        r
                    };
                    let bb = f2.mul2(inv2 * q + 0, cc);
                    let z: Vec<usize> = sj.iter().map(|&u| f2.add2(f2.mul2(a, u), bb)).collect();
                    let conf = f2.is_coherent(&z);
                    triples_passed += 1;
                    let zs: Vec<String> = z
                        .iter()
                        .map(|&e| {
                            let (x, y) = xy(e, q);
                            format!("[{},{}]", x, y)
                        })
                        .collect();
                    let (ax, ay) = xy(a, q);
                    passes.push(format!(
                        "{{\"j\":{},\"a\":[{},{}],\"c\":[0,{}],\"Z\":[{}],\"generic_tester\":{}}}",
                        j,
                        ax,
                        ay,
                        cy,
                        zs.join(","),
                        conf
                    ));
                }
            }
        }
    }

    let seconds = start.elapsed().as_secs_f64();

    // ---- optional exhaustive independent search
    let exh = if exhaustive {
        Some(exhaustive_search(&f2, exh_budget))
    } else {
        None
    };

    Row {
        q,
        p,
        m,
        eps: f2.f.eps,
        k,
        delta: f2.delta,
        circle_size: c.len(),
        q0_size: q0.len(),
        q1_size: q1.len(),
        s_clique,
        s_maximal,
        reduction_ok,
        triples_tested,
        triples_passed,
        passes,
        seconds,
        exhaustive: exh,
    }
}

/// Exhaustive search for ANY coherent system, using the symmetry group
/// {z -> a z + b : a in F_q^*, b in F_q} which acts transitively on the irrational
/// elements and preserves the coherence graph; so it suffices to search cliques
/// containing the vertex s = (0,1).
fn exhaustive_search(f2: &F2, budget: Duration) -> Exh {
    let start = Instant::now();
    let q = f2.q;
    let verts: Vec<usize> = (0..q * q).filter(|&z| f2.is_irrational(z)).collect();
    let n = verts.len();
    let mut pos = vec![usize::MAX; q * q];
    for (i, &v) in verts.iter().enumerate() {
        pos[v] = i;
    }
    let mut adj: Vec<Bits> = (0..n).map(|_| Bits::new(n)).collect();
    for i in 0..n {
        for jj in 0..i {
            let (zi, zj) = (verts[i], verts[jj]);
            if f2.chi_of(f2.sub2(zi, zj)) == f2.delta
                && f2.chi_of(f2.sub2(zi, f2.conj(zj))) == -f2.delta
            {
                adj[i].set(jj);
                adj[jj].set(i);
            }
        }
    }

    // verify the claimed automorphisms and transitivity
    let mut aut_verified = true;
    for &(a, b) in &[(f2.f.gen, 0usize), (1usize, 1usize)] {
        let ae = a * q + 0;
        let be = b * q + 0;
        let map: Vec<usize> = verts.iter().map(|&z| pos[f2.add2(f2.mul2(ae, z), be)]).collect();
        for i in 0..n {
            for jj in 0..i {
                if adj[i].get(jj) != adj[map[i]].get(map[jj]) {
                    aut_verified = false;
                }
            }
        }
    }
    // transitivity of the group on irrationals: orbit of s = (0,1)
    let mut seen = vec![false; q * q];
    for a in 1..q {
        for b in 0..q {
            let z = f2.add2(f2.mul2(a * q + 0, 0 * q + 1), b * q + 0);
            seen[z] = true;
        }
    }
    let transitive = verts.iter().all(|&z| seen[z]);

    let v0 = pos[0 * q + 1];
    let k = f2.k;
    let mut count: u64 = 0;
    let mut completed = true;
    let mut cand = adj[v0].clone();
    // only consider vertices > v0 is NOT valid here (we fix v0 as a member, others free)
    let mut scratch: Vec<Bits> = (0..k + 1).map(|_| Bits::new(n)).collect();
    expand(&adj, &mut cand, 1, k, &mut count, &mut scratch, 0, n, start, budget, &mut completed);

    Exh {
        vertices: n,
        aut_verified,
        transitive,
        cliques_through_s: count,
        completed,
        seconds: start.elapsed().as_secs_f64(),
    }
}

#[allow(clippy::too_many_arguments)]
fn expand(
    adj: &[Bits],
    cand: &mut Bits,
    size: usize,
    k: usize,
    count: &mut u64,
    scratch: &mut Vec<Bits>,
    depth: usize,
    n: usize,
    start: Instant,
    budget: Duration,
    completed: &mut bool,
) {
    if size == k {
        *count += 1;
        return;
    }
    if !*completed {
        return;
    }
    if depth == 0 && start.elapsed() > budget {
        *completed = false;
        return;
    }
    if size + cand.count() < k {
        return;
    }
    if depth < 3 && start.elapsed() > budget {
        *completed = false;
        return;
    }
    let words = cand.w.len();
    for wi in 0..words {
        let mut bits = cand.w[wi];
        while bits != 0 {
            let b = bits.trailing_zeros() as usize;
            bits &= bits - 1;
            let v = wi * 64 + b;
            if v >= n {
                continue;
            }
            if size + cand.count() < k {
                return;
            }
            let mut next = Bits::new(n);
            cand.and_into(&adj[v], &mut next);
            // restrict to vertices after v to avoid permutations
            for w2 in 0..=wi {
                if w2 < wi {
                    next.w[w2] = 0;
                } else {
                    next.w[w2] &= !((1u64 << b) | ((1u64 << b) - 1));
                }
            }
            expand(adj, &mut next, size + 1, k, count, scratch, depth + 1, n, start, budget, completed);
            if !*completed {
                return;
            }
            cand.w[wi] &= !(1u64 << b);
        }
    }
}

// ---------------------------------------------------------------- controls

fn controls() -> String {
    let mut out = Vec::new();

    // (i) the two known q = 5 four-frames
    let f2 = F2::new(5, 1);
    assert_eq!(f2.f.eps, 2);
    assert_eq!(f2.k, 4);
    assert_eq!(f2.delta, -1);
    let q = 5;
    let mk = |x: usize, y: usize| x * q + y;
    let frame1 = vec![mk(0, 1), mk(1, 4), mk(2, 2), mk(4, 3)];
    let frame2 = vec![mk(0, 1), mk(4, 4), mk(1, 3), mk(3, 2)];
    out.push(format!(
        "\"q5_frame1_coherent\":{}",
        f2.is_coherent(&frame1)
    ));
    out.push(format!(
        "\"q5_frame2_coherent\":{}",
        f2.is_coherent(&frame2)
    ));
    out.push(format!("\"q5_eps\":{}", f2.f.eps));
    out.push(format!("\"q5_delta\":{}", f2.delta));

    // (ii) random size-k subsets should fail
    let mut rng: u64 = 0xDEADBEEF12345678;
    let mut next = || {
        rng ^= rng << 13;
        rng ^= rng >> 7;
        rng ^= rng << 17;
        rng
    };
    let mut neg_total = 0u64;
    let mut neg_pass = 0u64;
    let mut per_q: Vec<String> = Vec::new();
    for &(p, m) in &[(5usize, 1usize), (7, 1), (11, 1), (3, 3)] {
        let g = F2::new(p, m);
        let qq = g.q;
        let mut lt = 0u64;
        let mut lp = 0u64;
        for _ in 0..2000 {
            let mut z: Vec<usize> = Vec::new();
            while z.len() < g.k {
                let e = (next() as usize) % (qq * qq);
                if !g.is_irrational(e) {
                    continue;
                }
                if z.iter().any(|&w| w == e || w == g.conj(e)) {
                    continue;
                }
                z.push(e);
            }
            lt += 1;
            if g.is_coherent(&z) {
                lp += 1;
            }
        }
        neg_total += lt;
        neg_pass += lp;
        per_q.push(format!("{{\"q\":{},\"tested\":{},\"coherent\":{}}}", qq, lt, lp));
    }
    out.push(format!("\"random_subsets_tested\":{}", neg_total));
    out.push(format!("\"random_subsets_coherent\":{}", neg_pass));
    out.push(format!("\"random_subsets_by_q\":[{}]", per_q.join(",")));

    // (iii) sanity: chi(-1) = 1 in F_{q^2} for a few q
    let mut chi_minus1_all_one = true;
    for &(p, m) in &[(5usize, 1usize), (7, 1), (11, 1), (3, 3)] {
        let g = F2::new(p, m);
        let m1 = g.f.neg[1] as usize * g.q;
        if g.chi_of(m1) != 1 {
            chi_minus1_all_one = false;
        }
    }
    out.push(format!("\"chi_minus_one_is_one\":{}", chi_minus1_all_one));

    // (iv) positive control for the exhaustive clique search: at q = 5 it must find
    // the known four-frames through the vertex s.
    let g5 = F2::new(5, 1);
    let e5 = exhaustive_search(&g5, Duration::from_secs(60));
    out.push(format!(
        "\"q5_exhaustive\":{{\"vertices\":{},\"aut_verified\":{},\"transitive\":{},\"coherent_systems_through_s\":{},\"completed\":{}}}",
        e5.vertices, e5.aut_verified, e5.transitive, e5.cliques_through_s, e5.completed
    ));

    format!("{{{}}}", out.join(","))
}

// ---------------------------------------------------------------- driver

fn prime_powers_3mod4(lo: usize, hi: usize) -> Vec<(usize, usize)> {
    let mut v = Vec::new();
    for p in 2..=hi {
        // primality
        let mut isp = p > 1;
        let mut d = 2;
        while d * d <= p {
            if p % d == 0 {
                isp = false;
                break;
            }
            d += 1;
        }
        if !isp || p == 2 {
            continue;
        }
        let mut m = 1;
        loop {
            let q = p.pow(m as u32);
            if q > hi {
                break;
            }
            if q >= lo && q % 4 == 3 {
                v.push((p, m));
            }
            m += 1;
        }
    }
    v.sort_by_key(|&(p, m)| p.pow(m as u32));
    v
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut maxq = 109usize;
    let mut exh_max = 31usize;
    let mut out_path = String::from("c756.json");
    let mut exh_budget_s = 300u64;
    // Wall-clock is host-dependent, so it is omitted from the certificate by default;
    // pass --timings to include it (the run log on stderr always carries it).
    let mut timings = false;
    let mut i = 1;
    while i < args.len() {
        match args[i].as_str() {
            "--max" => {
                maxq = args[i + 1].parse().unwrap();
                i += 2;
            }
            "--exhaustive-max" => {
                exh_max = args[i + 1].parse().unwrap();
                i += 2;
            }
            "--exhaustive-budget" => {
                exh_budget_s = args[i + 1].parse().unwrap();
                i += 2;
            }
            "--timings" => {
                timings = true;
                i += 1;
            }
            "--out" => {
                out_path = args[i + 1].clone();
                i += 2;
            }
            _ => panic!("unknown arg {}", args[i]),
        }
    }

    let ctrl = controls();
    let list = prime_powers_3mod4(7, maxq);
    let mut rows = Vec::new();
    let mut total_tested = 0u64;
    let mut total_passed = 0u64;
    for &(p, m) in &list {
        let q = p.pow(m as u32);
        let row = run_q(p, m, q <= exh_max, Duration::from_secs(exh_budget_s));
        total_tested += row.triples_tested;
        total_passed += row.triples_passed;
        eprintln!(
            "q={} tested={} passed={} {:.2}s",
            row.q, row.triples_tested, row.triples_passed, row.seconds
        );
        rows.push(row);
    }

    let secs = |v: f64| if timings { format!("{:.3}", v) } else { String::from("null") };
    let mut rj = Vec::new();
    for r in &rows {
        let exh = match &r.exhaustive {
            None => String::from("null"),
            Some(e) => format!(
                "{{\"vertices\":{},\"aut_verified\":{},\"transitive\":{},\"coherent_systems_through_s\":{},\"completed\":{},\"seconds\":{}}}",
                e.vertices, e.aut_verified, e.transitive, e.cliques_through_s, e.completed, secs(e.seconds)
            ),
        };
        rj.push(format!(
            "{{\"q\":{},\"p\":{},\"m\":{},\"eps\":{},\"k\":{},\"delta\":{},\"circle_size\":{},\"q0_size\":{},\"q1_size\":{},\"S0_clique\":{},\"S1_clique\":{},\"S0_maximal\":{},\"S1_maximal\":{},\"reduction_verified\":{},\"triples_tested\":{},\"triples_passed\":{},\"passes\":[{}],\"seconds\":{},\"exhaustive\":{}}}",
            r.q, r.p, r.m, r.eps, r.k, r.delta, r.circle_size, r.q0_size, r.q1_size,
            r.s_clique[0], r.s_clique[1], r.s_maximal[0], r.s_maximal[1], r.reduction_ok,
            r.triples_tested, r.triples_passed, r.passes.join(","), secs(r.seconds), exh
        ));
    }

    let json = format!(
        "{{\n  \"schema\": {},\n  \"task\": {},\n  \"generator\": {},\n  \"conventions\": {},\n  \"params\": {{\"q_min\":7,\"q_max\":{},\"exhaustive_max\":{},\"exhaustive_budget_seconds\":{}}},\n  \"controls\": {},\n  \"totals\": {{\"triples_tested\":{},\"triples_passed\":{}}},\n  \"rows\": [\n    {}\n  ]\n}}\n",
        jstr("c756-clique-orbit-crown-check/1"),
        jstr("C756"),
        jstr("notes/2026-08-02-c756-clique-orbit-crown-check.rs"),
        jstr("F_q from lex-first monic irreducible over F_p (little-endian digits); eps = least nonsquare of F_q; F_{q^2}=F_q(s), s^2=eps; element x+y*s encoded as x*q+y; chi(u)=quadratic character of N(u); t=(q+1)/2, k=t+1, delta=(-1)^t; orbit family Z = a*S_j + b with chi(a)=1 and b entering only through c=b-b^q in s*F_q"),
        maxq,
        exh_max,
        exh_budget_s,
        ctrl,
        total_tested,
        total_passed,
        rj.join(",\n    ")
    );
    fs::write(&out_path, json).unwrap();
    eprintln!("TOTAL tested={} passed={}", total_tested, total_passed);
}
