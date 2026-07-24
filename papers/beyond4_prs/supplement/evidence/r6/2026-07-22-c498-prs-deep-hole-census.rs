// C498 PRS(q-5) deep-hole census generator (redundancy six).
//
// Ambient PG(5,q); quintic normal rational curve nu(t)=(1,t,t^2,t^3,t^4,t^5),
// nu(inf)=(0,0,0,0,0,1) -- the q+1 columns of the parity check of PRS(q-5)
// (redundancy 6). Deep holes = points of PG(5,q) not in the span of any 4
// distinct curve points. Equivalently (Hankel criterion): the 2x5 Hankel
// kernel of the point is a NET of binary quartics, and the point is deep iff
// no member of the net is a totally-split squarefree quartic.
//
// Both characterisations are computed independently and cross-checked per field.
//
// Deterministic, no randomness, no timestamps. Compile: rustc -O c498_census.rs
use std::io::Write;

// ---------------------------------------------------------------------------
// Finite field GF(q)=GF(p^m). Element = integer whose base-p digits are the
// polynomial-basis coefficients (low degree = least significant).
// rvec[i] = coeff of t^i in the reduction of t^m.
// ---------------------------------------------------------------------------
fn field_spec(q: u32) -> (u32, u32, Vec<u32>, &'static str) {
    match q {
        7 => (7, 1, vec![], "GF(7) prime"),
        8 => (2, 3, vec![1, 1, 0], "t^3 = t + 1"),
        9 => (3, 2, vec![2, 0], "t^2 = -1"),
        11 => (11, 1, vec![], "GF(11) prime"),
        13 => (13, 1, vec![], "GF(13) prime"),
        16 => (2, 4, vec![1, 1, 0, 0], "t^4 = t + 1"),
        17 => (17, 1, vec![], "GF(17) prime"),
        19 => (19, 1, vec![], "GF(19) prime"),
        23 => (23, 1, vec![], "GF(23) prime"),
        25 => (5, 2, vec![2, 0], "t^2 = 2"),
        27 => (3, 3, vec![2, 1, 0], "t^3 = t - 1"),
        _ => panic!("unsupported q={}", q),
    }
}

struct GF {
    q: u32,
    p: u32,
    m: u32,
    desc: &'static str,
    add: Vec<u32>,
    mul: Vec<u32>,
    neg: Vec<u32>,
    inv: Vec<u32>,
    exp: Vec<u32>,
    log: Vec<i64>,
    gen: u32,
}

impl GF {
    fn new(q: u32) -> GF {
        let (p, m, rvec, desc) = field_spec(q);
        // redpow[j] = t^j as length-m vector, j=0..2m-2
        let mm = m as usize;
        let mult_t = |vec: &Vec<u32>| -> Vec<u32> {
            if m == 1 {
                return vec.clone();
            }
            let hi = vec[mm - 1];
            let mut w = vec![0u32; mm];
            w[0] = (hi * rvec[0]) % p;
            for i in 1..mm {
                w[i] = (vec[i - 1] + hi * rvec[i]) % p;
            }
            w
        };
        let mut redpow: Vec<Vec<u32>> = Vec::new();
        if m == 1 {
            redpow.push(vec![]);
        } else {
            let mut cur = vec![0u32; mm];
            cur[0] = 1;
            for _ in 0..(2 * mm - 1) {
                redpow.push(cur.clone());
                cur = mult_t(&cur);
            }
        }
        let digits = |a: u32| -> Vec<u32> {
            let mut d = vec![0u32; mm];
            let mut a = a;
            for i in 0..mm {
                d[i] = a % p;
                a /= p;
            }
            d
        };
        let from_digits = |d: &Vec<u32>| -> u32 {
            let mut v = 0u32;
            for &c in d.iter().rev() {
                v = v * p + (c % p);
            }
            v
        };
        let raw_mul = |a: u32, b: u32| -> u32 {
            if m == 1 {
                return (a * b) % p;
            }
            let va = digits(a);
            let vb = digits(b);
            let mut conv = vec![0u32; 2 * mm - 1];
            for i in 0..mm {
                if va[i] == 0 {
                    continue;
                }
                for j in 0..mm {
                    conv[i + j] = (conv[i + j] + va[i] * vb[j]) % p;
                }
            }
            let mut res = vec![0u32; mm];
            for j in 0..(2 * mm - 1) {
                let cj = conv[j];
                if cj == 0 {
                    continue;
                }
                let rp = &redpow[j];
                for i in 0..mm {
                    if rp[i] != 0 {
                        res[i] = (res[i] + cj * rp[i]) % p;
                    }
                }
            }
            from_digits(&res)
        };
        let raw_add = |a: u32, b: u32| -> u32 {
            if m == 1 {
                return (a + b) % p;
            }
            let va = digits(a);
            let vb = digits(b);
            let d: Vec<u32> = (0..mm).map(|i| (va[i] + vb[i]) % p).collect();
            from_digits(&d)
        };
        let raw_neg = |a: u32| -> u32 {
            if m == 1 {
                return (p - a % p) % p;
            }
            let va = digits(a);
            let d: Vec<u32> = (0..mm).map(|i| (p - va[i] % p) % p).collect();
            from_digits(&d)
        };
        // primitive element
        let mut gen = 0u32;
        'outer: for g in 2..q {
            let mut x = 1u32;
            let mut order = 0u32;
            for _ in 0..(q - 1) {
                x = raw_mul(x, g);
                order += 1;
                if x == 1 {
                    break;
                }
            }
            if order == q - 1 {
                gen = g;
                break 'outer;
            }
        }
        if gen == 0 && q > 2 {
            panic!("no primitive element for q={} (reducible modulus?)", q);
        }
        // exp/log
        let mut exp = vec![0u32; (q - 1) as usize];
        let mut log = vec![-1i64; q as usize];
        let mut x = 1u32;
        for i in 0..(q - 1) {
            exp[i as usize] = x;
            log[x as usize] = i as i64;
            x = raw_mul(x, gen);
        }
        assert_eq!(x, 1, "primitive cycle mismatch q={}", q);
        // dense tables
        let qs = q as usize;
        let mut add = vec![0u32; qs * qs];
        let mut mul = vec![0u32; qs * qs];
        let mut neg = vec![0u32; qs];
        let mut inv = vec![0u32; qs];
        for a in 0..q {
            neg[a as usize] = raw_neg(a);
            for b in 0..q {
                add[(a as usize) * qs + b as usize] = raw_add(a, b);
                mul[(a as usize) * qs + b as usize] = raw_mul(a, b);
            }
        }
        for a in 1..q {
            let e = ((q - 1 - (log[a as usize] as u32)) % (q - 1)) as usize;
            inv[a as usize] = exp[e];
        }
        GF { q, p, m, desc, add, mul, neg, inv, exp, log, gen }
    }

    #[inline]
    fn a(&self, x: u32, y: u32) -> u32 {
        self.add[(x as usize) * (self.q as usize) + y as usize]
    }
    #[inline]
    fn m_(&self, x: u32, y: u32) -> u32 {
        self.mul[(x as usize) * (self.q as usize) + y as usize]
    }
    #[inline]
    fn n(&self, x: u32) -> u32 {
        self.neg[x as usize]
    }
    #[inline]
    fn s(&self, x: u32, y: u32) -> u32 {
        self.a(x, self.n(y))
    }
    #[inline]
    fn i(&self, x: u32) -> u32 {
        self.inv[x as usize]
    }
    fn powe(&self, a: u32, e: i64) -> u32 {
        if a == 0 {
            return if e > 0 { 0 } else { 1 };
        }
        let q1 = (self.q - 1) as i64;
        let mut e = (self.log[a as usize] * e) % q1;
        if e < 0 {
            e += q1;
        }
        self.exp[e as usize]
    }
    fn frob(&self, a: u32) -> u32 {
        self.powe(a, self.p as i64)
    }
}

// ---------------------------------------------------------------------------
// Point encoding in PG(k-1,q): canonical vector (first nonzero coord = 1),
// index = radix-q integer with coord0 most significant.
// ---------------------------------------------------------------------------
fn encode(f: &GF, vec: &[u32]) -> i64 {
    let q = f.q as i64;
    let k = vec.len();
    for i in 0..k {
        if vec[i] != 0 {
            let iv = f.i(vec[i]);
            let mut idx: i64 = 0;
            for j in 0..k {
                idx = idx * q + f.m_(iv, vec[j]) as i64;
            }
            return idx;
        }
    }
    -1
}

fn decode(f: &GF, mut idx: i64, k: usize) -> Vec<u32> {
    let q = f.q as i64;
    let mut v = vec![0u32; k];
    for j in (0..k).rev() {
        v[j] = (idx % q) as u32;
        idx /= q;
    }
    v
}

// Canonical coefficient vectors for PG(k-1,q) (first nonzero = 1).
fn pg_coeffs(f: &GF, k: usize) -> Vec<Vec<u32>> {
    let q = f.q;
    let mut res: Vec<Vec<u32>> = Vec::new();
    // prefix of zeros, then a 1, then free tail
    for lead in 0..k {
        // positions 0..lead are 0, position lead = 1, positions lead+1..k free
        let tail = k - lead - 1;
        let total = (q as u64).pow(tail as u32);
        for code in 0..total {
            let mut v = vec![0u32; k];
            v[lead] = 1;
            let mut c = code;
            for j in 0..tail {
                v[lead + 1 + j] = (c % q as u64) as u32;
                c /= q as u64;
            }
            res.push(v);
        }
    }
    res
}

// ---------------------------------------------------------------------------
// Curve points nu(t) for PG(5,q): (1,t,t^2,t^3,t^4,t^5); nu(inf)=e5.
// ---------------------------------------------------------------------------
fn curve_points(f: &GF) -> Vec<Vec<u32>> {
    let q = f.q;
    let mut pts = Vec::new();
    for t in 0..q {
        let t2 = f.m_(t, t);
        let t3 = f.m_(t2, t);
        let t4 = f.m_(t3, t);
        let t5 = f.m_(t4, t);
        pts.push(vec![1, t, t2, t3, t4, t5]);
    }
    pts.push(vec![0, 0, 0, 0, 0, 1]);
    pts
}

// ---------------------------------------------------------------------------
// Binary-form factorisation over GF(q). poly low->high (index = power).
// ---------------------------------------------------------------------------
fn poly_deg(p: &[u32]) -> i32 {
    let mut d = p.len() as i32 - 1;
    while d >= 0 && p[d as usize] == 0 {
        d -= 1;
    }
    d
}
fn poly_eval(f: &GF, p: &[u32], x: u32) -> u32 {
    let mut r = 0u32;
    for &c in p.iter().rev() {
        r = f.a(f.m_(r, x), c);
    }
    r
}
fn poly_monic(f: &GF, p: &[u32]) -> Vec<u32> {
    let d = poly_deg(p);
    if d < 0 {
        return vec![0];
    }
    let lead = p[d as usize];
    let iv = f.i(lead);
    (0..=d as usize).map(|k| f.m_(iv, p[k])).collect()
}
fn poly_div_linear(f: &GF, p: &[u32], r: u32) -> Vec<u32> {
    // divide p by (x - r), exact; synthetic division
    let d = poly_deg(p) as usize;
    let coeffs = &p[..=d];
    let mut prev = coeffs[d];
    let mut out = vec![prev];
    for k in (1..d).rev() {
        prev = f.a(coeffs[k], f.m_(prev, r));
        out.push(prev);
    }
    out.reverse();
    out
}
fn poly_mod(f: &GF, a: &[u32], b: &[u32]) -> Vec<u32> {
    let mut a = a.to_vec();
    let db = poly_deg(b);
    if db < 0 {
        return a;
    }
    let lb_inv = f.i(b[db as usize]);
    let mut da = poly_deg(&a);
    while da >= db && da >= 0 {
        let coef = f.m_(a[da as usize], lb_inv);
        let shift = (da - db) as usize;
        for k in 0..=(db as usize) {
            a[shift + k] = f.a(a[shift + k], f.n(f.m_(coef, b[k])));
        }
        da = poly_deg(&a);
    }
    if da < 0 {
        vec![0]
    } else {
        a[..=(da as usize)].to_vec()
    }
}
fn poly_mod_exact(f: &GF, a: &[u32], b: &[u32]) -> Vec<u32> {
    let mut a = a.to_vec();
    let db = poly_deg(b);
    let lb_inv = f.i(b[db as usize]);
    let da0 = poly_deg(&a);
    let mut quo = vec![0u32; (da0 - db + 1) as usize];
    let mut da = da0;
    while da >= db && da >= 0 {
        let coef = f.m_(a[da as usize], lb_inv);
        let shift = (da - db) as usize;
        quo[shift] = coef;
        for k in 0..=(db as usize) {
            a[shift + k] = f.a(a[shift + k], f.n(f.m_(coef, b[k])));
        }
        da = poly_deg(&a);
    }
    quo
}
fn poly_gcd(f: &GF, a: &[u32], b: &[u32]) -> Vec<u32> {
    let mut a = if poly_deg(a) >= 0 { a[..=(poly_deg(a) as usize)].to_vec() } else { vec![0] };
    let mut b = if poly_deg(b) >= 0 { b[..=(poly_deg(b) as usize)].to_vec() } else { vec![0] };
    while poly_deg(&b) >= 0 {
        let r = poly_mod(f, &a, &b);
        a = b;
        b = r;
    }
    if poly_deg(&a) < 0 {
        vec![0]
    } else {
        poly_monic(f, &a)
    }
}
fn rational_roots_mult(f: &GF, p: &[u32]) -> (Vec<(u32, u32)>, Vec<u32>) {
    let q = f.q;
    let mut roots = Vec::new();
    let mut cur = poly_monic(f, p);
    let mut changed = true;
    while poly_deg(&cur) >= 1 && changed {
        changed = false;
        for r in 0..q {
            if poly_eval(f, &cur, r) == 0 {
                let mut mult = 0u32;
                while poly_deg(&cur) >= 1 && poly_eval(f, &cur, r) == 0 {
                    cur = poly_div_linear(f, &cur, r);
                    mult += 1;
                }
                roots.push((r, mult));
                changed = true;
                break;
            }
        }
    }
    (roots, cur)
}
fn irreducible_quadratic_divisor(f: &GF, p: &[u32]) -> Option<Vec<u32>> {
    let q = f.q;
    for c in 0..q {
        for b in 0..q {
            // x^2 + b x + c irreducible iff no rational root
            let mut has_root = false;
            for r in 0..q {
                if f.a(f.a(f.m_(r, r), f.m_(b, r)), c) == 0 {
                    has_root = true;
                    break;
                }
            }
            if has_root {
                continue;
            }
            let g = vec![c, b, 1];
            if poly_deg(&poly_mod(f, p, &g)) < 0 {
                return Some(g);
            }
        }
    }
    None
}
// Factor monic low->high into list of (deg,mult). Handles deg up to 5.
fn factor_monic(f: &GF, p: &[u32]) -> Vec<(u32, u32)> {
    let mut factors = Vec::new();
    let (roots, rem) = rational_roots_mult(f, p);
    for (_r, mult) in roots {
        factors.push((1u32, mult));
    }
    let d = poly_deg(&rem);
    if d <= 0 {
        return factors;
    }
    match d {
        2 => factors.push((2, 1)),
        3 => factors.push((3, 1)),
        4 => {
            match irreducible_quadratic_divisor(f, &rem) {
                None => factors.push((4, 1)),
                Some(g) => {
                    let quo = poly_monic(f, &poly_mod_exact(f, &rem, &g));
                    let gm = poly_monic(f, &g);
                    if quo == gm {
                        factors.push((2, 2));
                    } else {
                        factors.push((2, 1));
                        factors.push((2, 1));
                    }
                }
            }
        }
        5 => {
            match irreducible_quadratic_divisor(f, &rem) {
                None => factors.push((5, 1)),
                Some(g) => {
                    // remainder is irreducible cubic
                    factors.push((2, 1));
                    factors.push((3, 1));
                }
            }
        }
        _ => panic!("unexpected remainder degree {}", d),
    }
    factors
}
// coeffs_high = form coefficients top T-power down to U-power (length deg+1).
// Returns (deg,mult) list including the infinity (U) factor.
fn binary_factor(f: &GF, coeffs_high: &[u32]) -> Vec<(u32, u32)> {
    let n = coeffs_high.len();
    let mut i = 0;
    while i < n && coeffs_high[i] == 0 {
        i += 1;
    }
    let uz = i as u32;
    let mut factors = Vec::new();
    if uz > 0 {
        factors.push((1u32, uz));
    }
    if i < n {
        let rest = &coeffs_high[i..];
        let d = rest.len() as i32 - 1;
        if d >= 1 {
            let low: Vec<u32> = rest.iter().rev().cloned().collect();
            let low = poly_monic(f, &low);
            factors.extend(factor_monic(f, &low));
        }
    }
    factors
}
fn factor_signature(mut factors: Vec<(u32, u32)>) -> String {
    factors.sort_by(|a, b| (a.0, std::cmp::Reverse(a.1)).cmp(&(b.0, std::cmp::Reverse(b.1))));
    let toks: Vec<String> = factors
        .iter()
        .map(|&(d, mlt)| if mlt == 1 { format!("{}", d) } else { format!("{}^{}", d, mlt) })
        .collect();
    toks.join("+")
}
// totally split squarefree quartic: exactly 4 distinct roots in P^1(F_q).
// Allocation-free: count distinct finite roots + roots at infinity (leading
// zeros). Squarefree-split iff infinity has multiplicity <=1 and the finite
// part of degree dg has exactly dg distinct rational roots (equality forces
// all simple).
fn is_totally_split_squarefree(f: &GF, coeffs_high: &[u32]) -> bool {
    let n = coeffs_high.len(); // 5 for a quartic
    let mut uz = 0usize;
    while uz < n && coeffs_high[uz] == 0 {
        uz += 1;
    }
    if uz >= 2 {
        return false; // multiple root at infinity
    }
    let dg = (n - 1) - uz; // degree of finite part = 4 - uz
    let mut cnt = 0u32;
    for x in 0..f.q {
        let mut r = 0u32;
        for k in uz..n {
            r = f.a(f.m_(r, x), coeffs_high[k]);
        }
        if r == 0 {
            cnt += 1;
        }
    }
    cnt == dg as u32
}

// ---------------------------------------------------------------------------
// Nullspace of a matrix over GF(q). rows given as Vec<Vec<u32>>, ncol columns.
// Returns basis vectors (each length ncol).
// ---------------------------------------------------------------------------
fn nullspace(f: &GF, rows: &[Vec<u32>], ncol: usize) -> Vec<Vec<u32>> {
    let mut m: Vec<Vec<u32>> = rows.iter().map(|r| r.clone()).collect();
    let nr = m.len();
    let mut pivots: Vec<usize> = Vec::new();
    let mut rank = 0;
    for col in 0..ncol {
        let mut piv = None;
        for r in rank..nr {
            if m[r][col] != 0 {
                piv = Some(r);
                break;
            }
        }
        let piv = match piv {
            Some(x) => x,
            None => continue,
        };
        m.swap(rank, piv);
        let iv = f.i(m[rank][col]);
        for k in 0..ncol {
            m[rank][k] = f.m_(iv, m[rank][k]);
        }
        for r in 0..nr {
            if r != rank && m[r][col] != 0 {
                let fac = m[r][col];
                for k in 0..ncol {
                    m[r][k] = f.a(m[r][k], f.n(f.m_(fac, m[rank][k])));
                }
            }
        }
        pivots.push(col);
        rank += 1;
    }
    let free: Vec<usize> = (0..ncol).filter(|c| !pivots.contains(c)).collect();
    let mut basis = Vec::new();
    for &fc in &free {
        let mut v = vec![0u32; ncol];
        v[fc] = 1;
        for (ri, &pc) in pivots.iter().enumerate() {
            v[pc] = f.n(m[ri][fc]);
        }
        basis.push(v);
    }
    basis
}

fn matrix_rank(f: &GF, rows: &[Vec<u32>], ncol: usize) -> usize {
    let mut m: Vec<Vec<u32>> = rows.iter().map(|r| r.clone()).collect();
    let nr = m.len();
    let mut rank = 0;
    for col in 0..ncol {
        let mut piv = None;
        for r in rank..nr {
            if m[r][col] != 0 {
                piv = Some(r);
                break;
            }
        }
        let piv = match piv {
            Some(x) => x,
            None => continue,
        };
        m.swap(rank, piv);
        let iv = f.i(m[rank][col]);
        for k in 0..ncol {
            m[rank][k] = f.m_(iv, m[rank][k]);
        }
        for r in 0..nr {
            if r != rank && m[r][col] != 0 {
                let fac = m[r][col];
                for k in 0..ncol {
                    m[r][k] = f.a(m[r][k], f.n(f.m_(fac, m[rank][k])));
                }
            }
        }
        rank += 1;
        if rank == nr {
            break;
        }
    }
    rank
}

// Hankel kernel of point v=(a0..a5): kernel of [[a0..a4],[a1..a5]].
// Kernel vectors (c0..c4); returned as high->low (c4,c3,c2,c1,c0) for binary_factor.
fn hankel_kernel(f: &GF, v: &[u32]) -> Vec<Vec<u32>> {
    let rows = vec![
        vec![v[0], v[1], v[2], v[3], v[4]],
        vec![v[1], v[2], v[3], v[4], v[5]],
    ];
    let basis_c = nullspace(f, &rows, 5); // vectors (c0,c1,c2,c3,c4)
    basis_c
        .iter()
        .map(|c| vec![c[4], c[3], c[2], c[1], c[0]])
        .collect()
}

// Combine a net member from basis (high->low quartics) and coeff vector.
#[inline]
fn net_member(f: &GF, basis: &[Vec<u32>], coeffs: &[u32]) -> [u32; 5] {
    let mut member = [0u32; 5];
    for (ci, bvec) in coeffs.iter().zip(basis.iter()) {
        if *ci == 0 {
            continue;
        }
        for j in 0..5 {
            member[j] = f.a(member[j], f.m_(*ci, bvec[j]));
        }
    }
    member
}

// Deep by Hankel criterion: NOT deep iff net contains a totally-split
// squarefree member. Early-exit. `tables[d]` = precomputed PG(d-1,q) coeffs.
fn deep_by_hankel(f: &GF, v: &[u32], tables: &[Vec<Vec<u32>>]) -> bool {
    let basis = hankel_kernel(f, v);
    let d = basis.len();
    for coeffs in &tables[d] {
        let member = net_member(f, &basis, coeffs);
        if is_totally_split_squarefree(f, &member) {
            return false;
        }
    }
    true
}

// ---------------------------------------------------------------------------
// PGL2(q) action on PG(5,q) via degree-5 substitution.
// M[i][j] = coeff of t^j in (beta+alpha t)^i (delta+gamma t)^(5-i).
// ---------------------------------------------------------------------------
fn poly_mul_small(f: &GF, a: &[u32], b: &[u32]) -> Vec<u32> {
    let mut res = vec![0u32; a.len() + b.len() - 1];
    for (i, &ai) in a.iter().enumerate() {
        if ai == 0 {
            continue;
        }
        for (k, &bk) in b.iter().enumerate() {
            if bk != 0 {
                res[i + k] = f.a(res[i + k], f.m_(ai, bk));
            }
        }
    }
    res
}
fn build_mg(f: &GF, g: (u32, u32, u32, u32)) -> Vec<Vec<u32>> {
    let (alpha, beta, gamma, delta) = g;
    let mut m = vec![vec![0u32; 6]; 6];
    for i in 0..6usize {
        let mut pa = vec![1u32];
        for _ in 0..i {
            pa = poly_mul_small(f, &pa, &[beta, alpha]);
        }
        let mut pb = vec![1u32];
        for _ in 0..(5 - i) {
            pb = poly_mul_small(f, &pb, &[delta, gamma]);
        }
        let prod = poly_mul_small(f, &pa, &pb);
        for j in 0..6usize {
            m[i][j] = if j < prod.len() { prod[j] } else { 0 };
        }
    }
    m
}
fn apply_m(f: &GF, m: &[Vec<u32>], vec: &[u32]) -> Vec<u32> {
    let mut out = vec![0u32; 6];
    for i in 0..6usize {
        let mut s = 0u32;
        for j in 0..6usize {
            if vec[j] != 0 && m[i][j] != 0 {
                s = f.a(s, f.m_(m[i][j], vec[j]));
            }
        }
        out[i] = s;
    }
    out
}
fn verify_action(f: &GF, g: (u32, u32, u32, u32), m: &[Vec<u32>], cpts: &[Vec<u32>]) {
    let q = f.q;
    let (alpha, beta, gamma, delta) = g;
    for t in 0..q {
        let img = apply_m(f, m, &cpts[t as usize]);
        let num = f.a(f.m_(alpha, t), beta);
        let den = f.a(f.m_(gamma, t), delta);
        let target = if den == 0 {
            &cpts[q as usize]
        } else {
            let gt = f.m_(num, f.i(den));
            &cpts[gt as usize]
        };
        assert_eq!(encode(f, &img), encode(f, target), "action mismatch g t={}", t);
    }
    let img = apply_m(f, m, &cpts[q as usize]);
    let target = if gamma == 0 {
        &cpts[q as usize]
    } else {
        let gt = f.m_(alpha, f.i(gamma));
        &cpts[gt as usize]
    };
    assert_eq!(encode(f, &img), encode(f, target), "action mismatch g t=inf");
}

// net gcd degree (gcd of all members = gcd of the basis binary forms).
fn net_gcd_deg(f: &GF, basis: &[Vec<u32>]) -> u32 {
    // each basis vec is high->low quartic (c4,c3,c2,c1,c0). Track U-mult (leading zeros)
    // and finite gcd.
    let uz = |b: &Vec<u32>| -> (u32, Vec<u32>) {
        let mut i = 0;
        while i < b.len() && b[i] == 0 {
            i += 1;
        }
        let fin: Vec<u32> = b[i..].iter().rev().cloned().collect(); // low->high
        (i as u32, fin)
    };
    let mut common_u = u32::MAX;
    let mut g: Option<Vec<u32>> = None;
    for b in basis {
        let (u, fin) = uz(b);
        common_u = common_u.min(u);
        if poly_deg(&fin) >= 0 {
            g = Some(match g {
                None => fin,
                Some(gg) => poly_gcd(f, &gg, &fin),
            });
        }
    }
    let gdeg = match g {
        None => 0,
        Some(gg) => poly_deg(&gg).max(0) as u32,
    };
    common_u + gdeg
}

// ---------------------------------------------------------------------------
// Per-field census.
// ---------------------------------------------------------------------------
struct FieldRec {
    q: u32,
    n_points: i64,
    deep_count: usize,
    rho: u32,
    pgl_order: u64,
    n_pgl_orbits: usize,
    n_pgammal_orbits: usize,
    orbits: Vec<OrbitRec>,
}
struct OrbitRec {
    rep: Vec<u32>,
    rep_index: i64,
    size: usize,
    stab_order: u64,
    quintic_factor_type: String,
    net_gcd_deg: u32,
    member_hist: Vec<(String, u32)>,
    totalsplit_members: u32,
    frob_to_rep_index: i64,
}

fn census_field(q: u32) -> FieldRec {
    use std::time::Instant;
    let prof = std::env::var("C498_PROF").is_ok();
    let t0 = Instant::now();
    let f = GF::new(q);
    let n_points: i64 = {
        let q = q as i64;
        q.pow(5) + q.pow(4) + q.pow(3) + q * q + q + 1
    };
    let size = (q as usize).pow(6);
    let cpts = curve_points(&f);
    let ncurve = (q + 1) as usize;

    let points = pg_coeffs(&f, 6);
    let point_indices: Vec<i64> = points.iter().map(|v| encode(&f, v)).collect();
    assert_eq!(point_indices.len() as i64, n_points);

    // precompute PG(d-1,q) coefficient tables for net dims (kernel dim is 3 or 4).
    let pg_tables: Vec<Vec<Vec<u32>>> =
        (0..=4).map(|d| if d == 0 { Vec::new() } else { pg_coeffs(&f, d) }).collect();

    // curve triples rank 3 sanity
    for tri in [[0usize, 1, 2], [0, 1, ncurve - 1]] {
        let vs: Vec<Vec<u32>> = tri.iter().map(|&i| cpts[i].clone()).collect();
        assert_eq!(matrix_rank(&f, &vs, 6), 3, "curve triple not rank 3");
    }

    // ---- deep by span-marking (method S): mark all 4-point spans -----------
    let mut marked = vec![0u8; size];
    let pg3 = pg_coeffs(&f, 4); // PG(3,q) coeffs (a,b,c,d)
    let mut quad = [0usize; 4];
    for i1 in 0..ncurve {
        for i2 in (i1 + 1)..ncurve {
            for i3 in (i2 + 1)..ncurve {
                for i4 in (i3 + 1)..ncurve {
                    quad = [i1, i2, i3, i4];
                    let p: [&Vec<u32>; 4] =
                        [&cpts[quad[0]], &cpts[quad[1]], &cpts[quad[2]], &cpts[quad[3]]];
                    for coeff in &pg3 {
                        let (a, b, c, d) = (coeff[0], coeff[1], coeff[2], coeff[3]);
                        let mut v = [0u32; 6];
                        for k in 0..6 {
                            let t1 = f.a(f.m_(a, p[0][k]), f.m_(b, p[1][k]));
                            let t2 = f.a(f.m_(c, p[2][k]), f.m_(d, p[3][k]));
                            v[k] = f.a(t1, t2);
                        }
                        marked[encode(&f, &v) as usize] = 1;
                    }
                }
            }
        }
    }
    let _ = quad;
    let deep_s: Vec<i64> = point_indices
        .iter()
        .cloned()
        .filter(|&idx| marked[idx as usize] == 0)
        .collect();
    let deep_set: std::collections::HashSet<i64> = deep_s.iter().cloned().collect();
    if prof {
        eprintln!("  [q={}] span-mark: {:.2}s", q, t0.elapsed().as_secs_f64());
    }
    let t1 = Instant::now();

    // ---- deep by Hankel (method H) cross-check -----------------------------
    let mut deep_h: Vec<i64> = Vec::new();
    for (pi, v) in points.iter().enumerate() {
        if deep_by_hankel(&f, v, &pg_tables) {
            deep_h.push(point_indices[pi]);
        }
    }
    let deep_h_set: std::collections::HashSet<i64> = deep_h.iter().cloned().collect();
    assert_eq!(deep_set, deep_h_set, "q={}: span/Hankel deep sets disagree", q);

    let deep_count = deep_s.len();
    if prof {
        eprintln!("  [q={}] hankel:    {:.2}s", q, t1.elapsed().as_secs_f64());
    }
    let t2 = Instant::now();

    // ---- covering radius: every deep hole in some 5-curve-span (rho=5) ------
    // (non-deep points are in a 4-span, weight<=4). If no deep holes, rho<=4.
    let rho: u32 = if deep_count == 0 {
        4
    } else {
        // check a representative from each orbit later; here verify ALL deep holes
        // lie in a 5-point span (weight exactly 5).
        for &idx in &deep_s {
            let v = decode(&f, idx, 6);
            let mut found = false;
            'sub: for i1 in 0..ncurve {
                for i2 in (i1 + 1)..ncurve {
                    for i3 in (i2 + 1)..ncurve {
                        for i4 in (i3 + 1)..ncurve {
                            for i5 in (i4 + 1)..ncurve {
                                let rows = vec![
                                    cpts[i1].clone(),
                                    cpts[i2].clone(),
                                    cpts[i3].clone(),
                                    cpts[i4].clone(),
                                    cpts[i5].clone(),
                                    v.clone(),
                                ];
                                if matrix_rank(&f, &rows, 6) == 5 {
                                    found = true;
                                    break 'sub;
                                }
                            }
                        }
                    }
                }
            }
            assert!(found, "q={}: deep hole not in any 5-span (rho>5)", q);
        }
        5
    };

    if prof {
        eprintln!("  [q={}] covering:  {:.2}s", q, t2.elapsed().as_secs_f64());
    }
    let t3 = Instant::now();

    // ---- PGL2 orbit decomposition ------------------------------------------
    let e = f.gen;
    let gens = [(0u32, 1, 1, 0), (1, 1, 0, 1), (e, 0, 0, 1)];
    let ms: Vec<Vec<Vec<u32>>> = gens.iter().map(|&g| build_mg(&f, g)).collect();
    for (g, m) in gens.iter().zip(ms.iter()) {
        verify_action(&f, *g, m, &cpts);
    }
    let pgl_order = (q as u64).pow(3) - q as u64;

    let mut orbit_id: std::collections::HashMap<i64, usize> = std::collections::HashMap::new();
    let mut orbits: Vec<Vec<i64>> = Vec::new();
    for &start in &deep_s {
        if orbit_id.contains_key(&start) {
            continue;
        }
        let oid = orbits.len();
        let mut comp = Vec::new();
        let mut stack = vec![start];
        orbit_id.insert(start, oid);
        while let Some(cur) = stack.pop() {
            comp.push(cur);
            let cv = decode(&f, cur, 6);
            for m in &ms {
                let nb = encode(&f, &apply_m(&f, m, &cv));
                assert!(deep_set.contains(&nb), "q={}: PGL image left deep set", q);
                if !orbit_id.contains_key(&nb) {
                    orbit_id.insert(nb, oid);
                    stack.push(nb);
                }
            }
        }
        orbits.push(comp);
    }

    // ---- Frobenius on orbits ----
    let frob_point = |idx: i64| -> i64 {
        let v = decode(&f, idx, 6);
        encode(&f, &v.iter().map(|&x| f.frob(x)).collect::<Vec<u32>>())
    };
    let orbit_reps: Vec<i64> = orbits.iter().map(|c| *c.iter().min().unwrap()).collect();
    let mut frob_target = vec![0usize; orbits.len()];
    for oid in 0..orbits.len() {
        let fr = frob_point(orbit_reps[oid]);
        frob_target[oid] = *orbit_id.get(&fr).unwrap();
    }
    // count Frobenius cycles
    let mut seen = vec![false; orbits.len()];
    let mut pgammal = 0usize;
    for i in 0..orbits.len() {
        if seen[i] {
            continue;
        }
        pgammal += 1;
        let mut j = i;
        while !seen[j] {
            seen[j] = true;
            j = frob_target[j];
        }
    }

    // ---- per-orbit invariants ----
    let mut recs: Vec<(OrbitRec, usize)> = Vec::new();
    for oid in 0..orbits.len() {
        let rep = orbit_reps[oid];
        let v = decode(&f, rep, 6);
        let size = orbits[oid].len();
        assert_eq!(pgl_order % size as u64, 0, "q={}: orbit size {} not dividing", q, size);
        let stab = pgl_order / size as u64;
        let quintic_ft = factor_signature(binary_factor(&f, &v));
        let basis = hankel_kernel(&f, &v);
        let gcd_deg = net_gcd_deg(&f, &basis);
        // member histogram
        let mut hist: std::collections::HashMap<String, u32> = std::collections::HashMap::new();
        let mut totalsplit = 0u32;
        for coeffs in &pg_tables[basis.len()] {
            let member = net_member(&f, &basis, coeffs);
            let sig = factor_signature(binary_factor(&f, &member));
            *hist.entry(sig.clone()).or_insert(0) += 1;
            if is_totally_split_squarefree(&f, &member) {
                totalsplit += 1;
            }
        }
        assert_eq!(totalsplit, 0, "q={}: deep orbit has totally-split member", q);
        let mut member_hist: Vec<(String, u32)> = hist.into_iter().collect();
        member_hist.sort();
        recs.push((
            OrbitRec {
                rep: v,
                rep_index: rep,
                size,
                stab_order: stab,
                quintic_factor_type: quintic_ft,
                net_gcd_deg: gcd_deg,
                member_hist,
                totalsplit_members: totalsplit,
                frob_to_rep_index: 0,
            },
            oid,
        ));
    }
    // sort by (size, rep_index); fill frob target as rep_index
    recs.sort_by(|a, b| (a.0.size, a.0.rep_index).cmp(&(b.0.size, b.0.rep_index)));
    let oid_to_repidx: std::collections::HashMap<usize, i64> =
        recs.iter().map(|(r, oid)| (*oid, r.rep_index)).collect();
    let mut orbits_out = Vec::new();
    for (mut r, oid) in recs {
        r.frob_to_rep_index = oid_to_repidx[&frob_target[oid]];
        orbits_out.push(r);
    }

    if prof {
        eprintln!("  [q={}] orbits:    {:.2}s", q, t3.elapsed().as_secs_f64());
    }

    FieldRec {
        q,
        n_points,
        deep_count,
        rho,
        pgl_order,
        n_pgl_orbits: orbits.len(),
        n_pgammal_orbits: pgammal,
        orbits: orbits_out,
    }
}

fn json_escape(s: &str) -> String {
    s.replace('\\', "\\\\").replace('"', "\\\"")
}

fn write_json(recs: &[FieldRec]) -> String {
    let mut out = String::new();
    out.push_str("{\n");
    out.push_str("  \"schema\": \"c498-prs-deep-hole-census-v1\",\n");
    out.push_str("  \"fields\": {\n");
    for (fi, r) in recs.iter().enumerate() {
        out.push_str(&format!("    \"{}\": {{\n", r.q));
        out.push_str(&format!("      \"pg5_points\": {},\n", r.n_points));
        out.push_str(&format!("      \"deep_hole_count\": {},\n", r.deep_count));
        out.push_str(&format!("      \"covering_radius\": {},\n", r.rho));
        out.push_str(&format!("      \"pgl2_order\": {},\n", r.pgl_order));
        out.push_str(&format!("      \"pgl2_orbit_count\": {},\n", r.n_pgl_orbits));
        out.push_str(&format!("      \"pgammal_orbit_count\": {},\n", r.n_pgammal_orbits));
        out.push_str("      \"pgl2_orbits\": [\n");
        for (oi, o) in r.orbits.iter().enumerate() {
            out.push_str("        {\n");
            let rep: Vec<String> = o.rep.iter().map(|x| x.to_string()).collect();
            out.push_str(&format!("          \"rep\": [{}],\n", rep.join(", ")));
            out.push_str(&format!("          \"rep_index\": {},\n", o.rep_index));
            out.push_str(&format!("          \"size\": {},\n", o.size));
            out.push_str(&format!("          \"stab_order\": {},\n", o.stab_order));
            out.push_str(&format!(
                "          \"quintic_factor_type\": \"{}\",\n",
                json_escape(&o.quintic_factor_type)
            ));
            out.push_str(&format!("          \"net_gcd_deg\": {},\n", o.net_gcd_deg));
            out.push_str(&format!("          \"totalsplit_members\": {},\n", o.totalsplit_members));
            let hist: Vec<String> = o
                .member_hist
                .iter()
                .map(|(k, v)| format!("\"{}\": {}", json_escape(k), v))
                .collect();
            out.push_str(&format!("          \"member_hist\": {{{}}},\n", hist.join(", ")));
            out.push_str(&format!(
                "          \"frobenius_maps_to_rep_index\": {}\n",
                o.frob_to_rep_index
            ));
            out.push_str(if oi + 1 < r.orbits.len() { "        },\n" } else { "        }\n" });
        }
        out.push_str("      ]\n");
        out.push_str(if fi + 1 < recs.len() { "    },\n" } else { "    }\n" });
    }
    out.push_str("  }\n}\n");
    out
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let fields: Vec<u32> = if args.len() > 1 {
        args[1..].iter().map(|s| s.parse().unwrap()).collect()
    } else {
        vec![7, 8, 9, 11, 13, 16, 17, 19, 23, 25, 27]
    };
    let out_path = if let Ok(p) = std::env::var("C498_JSON_OUT") {
        p
    } else {
        "c498-census.json".to_string()
    };

    println!(
        "{:>3} {:>10} {:>8} {:>4} {:>6} {:>8}  orbit sizes",
        "q", "pg5_pts", "deep", "rho", "#PGL", "#PGammaL"
    );
    let mut recs = Vec::new();
    for q in fields {
        let r = census_field(q);
        let sizes: Vec<String> = r.orbits.iter().map(|o| o.size.to_string()).collect();
        println!(
            "{:>3} {:>10} {:>8} {:>4} {:>6} {:>8}  {}",
            r.q,
            r.n_points,
            r.deep_count,
            r.rho,
            r.n_pgl_orbits,
            r.n_pgammal_orbits,
            sizes.join(",")
        );
        std::io::stdout().flush().unwrap();
        recs.push(r);
    }
    let json = write_json(&recs);
    std::fs::write(&out_path, json).unwrap();
    eprintln!("wrote {}", out_path);
}
