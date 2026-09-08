//! Conic trade and CSS subspace searches.
//!
//! `conic-search dist3`            Test 2: exhaustive search of evaluation subspaces L' of the
//!                          Clebsch p = 7 code (1 in L', dim L' >= 3) for a distance-three
//!                          CSS subcode with a nonzero logical cubic.
//! `conic-search trades P [--sym]` Test 3(a): translation classes of perfect matchings of the
//!                          conic over F_P; pairs of classes with equal signed moments of
//!                          orders 0..2 and different order 3.  `--sym` restricts to the
//!                          classes with a nontrivial AGL(1,P)-stabilizer.
//! `conic-search orbits P`         Test 3(a): the same for pairs of PGL_2(P)-orbits and pairs of
//!                          PSL_2(P)-orbits of matchings (any common size).
use rayon::prelude::*;
use std::collections::HashMap;
use std::env;

// ---------------------------------------------------------------- finite field helpers
fn inv(a: i64, p: i64) -> i64 {
    let mut r = 1i64;
    let mut b = a.rem_euclid(p);
    let mut e = p - 2;
    while e > 0 {
        if e & 1 == 1 {
            r = r * b % p;
        }
        b = b * b % p;
        e >>= 1;
    }
    r
}

/// Row-reduce `m` (rows x cols) over F_p in place; returns (rank, pivot columns).
fn rref(m: &mut Vec<Vec<i64>>, p: i64) -> (usize, Vec<usize>) {
    let rows = m.len();
    if rows == 0 {
        return (0, vec![]);
    }
    let cols = m[0].len();
    let mut r = 0;
    let mut piv = vec![];
    for c in 0..cols {
        let mut sel = None;
        for i in r..rows {
            if m[i][c].rem_euclid(p) != 0 {
                sel = Some(i);
                break;
            }
        }
        let Some(i) = sel else { continue };
        m.swap(r, i);
        let iv = inv(m[r][c], p);
        for j in 0..cols {
            m[r][j] = m[r][j] * iv % p;
        }
        for i in 0..rows {
            if i != r && m[i][c] != 0 {
                let f = m[i][c];
                for j in 0..cols {
                    m[i][j] = (m[i][j] - f * m[r][j]).rem_euclid(p);
                }
            }
        }
        piv.push(c);
        r += 1;
        if r == rows {
            break;
        }
    }
    (r, piv)
}

/// Basis of the right kernel {x : m x = 0} over F_p.
fn kernel(m: &Vec<Vec<i64>>, p: i64) -> Vec<Vec<i64>> {
    let cols = m[0].len();
    let mut a = m.clone();
    let (rank, piv) = rref(&mut a, p);
    let free: Vec<usize> = (0..cols).filter(|c| !piv.contains(c)).collect();
    let mut basis = vec![];
    for &f in &free {
        let mut x = vec![0i64; cols];
        x[f] = 1;
        for (ri, &pc) in piv.iter().enumerate().take(rank) {
            x[pc] = (-a[ri][f]).rem_euclid(p);
        }
        basis.push(x);
    }
    basis
}

// ---------------------------------------------------------------- Test 2: dist3
const E7: [[i64; 6]; 14] = [
    [3, 5, 0, 0, 3, 2],
    [0, 0, 0, 0, 0, 0],
    [6, 4, 6, 5, 3, 6],
    [2, 4, 0, 0, 2, 3],
    [1, 0, 6, 5, 2, 5],
    [5, 5, 6, 5, 0, 1],
    [4, 3, 3, 6, 4, 4],
    [3, 5, 0, 5, 0, 0],
    [0, 0, 0, 5, 2, 3],
    [6, 4, 6, 3, 2, 5],
    [2, 4, 0, 5, 3, 2],
    [1, 0, 6, 3, 0, 1],
    [5, 5, 6, 3, 3, 6],
    [4, 3, 3, 4, 4, 4],
];

#[derive(Default, Clone)]
struct Dist3Stats {
    /// key: (dim L', dim R, #classes L', #classes R, condition holds)
    tally: HashMap<(usize, usize, usize, usize, bool), u64>,
    hits: Vec<String>,
    total: u64,
}

fn dist3_eval(u: &[[i64; 6]], stats: &mut Dist3Stats) {
    let p = 7i64;
    let n = 14;
    let m = u.len();
    stats.total += 1;
    // basis of L': w_0 = 1, w_a = E u_a
    let mut w: Vec<[i64; 14]> = vec![[1; 14]];
    for row in u {
        let mut v = [0i64; 14];
        for i in 0..n {
            let mut s = 0;
            for j in 0..6 {
                s += E7[i][j] * row[j];
            }
            v[i] = s % p;
        }
        w.push(v);
    }
    let eps = |i: usize| if i < 7 { 1 } else { p - 1 };
    // T_{abc}; matrix C rows (a<=b), cols c
    let d = m + 1;
    let mut c_mat = vec![];
    let mut nonzero = false;
    for a in 0..d {
        for b in a..d {
            let mut row = vec![0i64; d];
            for c in 0..d {
                let mut s = 0;
                for i in 0..n {
                    s += eps(i) * w[a][i] * w[b][i] % p * w[c][i];
                }
                row[c] = s % p;
                if row[c] != 0 {
                    nonzero = true;
                }
            }
            c_mat.push(row);
        }
    }
    let rbasis = kernel(&c_mat, p); // coefficient vectors of R(L')
    let rdim = rbasis.len();
    // column signatures
    let sig_l: Vec<Vec<i64>> = (0..n).map(|i| (1..d).map(|a| w[a][i]).collect()).collect();
    let rvecs: Vec<[i64; 14]> = rbasis
        .iter()
        .map(|s| {
            let mut v = [0i64; 14];
            for i in 0..n {
                let mut t = 0;
                for c in 0..d {
                    t += s[c] * w[c][i];
                }
                v[i] = t % p;
            }
            v
        })
        .collect();
    let sig_r: Vec<Vec<i64>> = (0..n).map(|i| rvecs.iter().map(|v| v[i]).collect()).collect();
    let count_classes = |sig: &Vec<Vec<i64>>| {
        let mut seen: Vec<&Vec<i64>> = vec![];
        for s in sig {
            if !seen.contains(&s) {
                seen.push(s);
            }
        }
        seen.len()
    };
    let cl = count_classes(&sig_l);
    let cr = count_classes(&sig_r);
    let mut cond = nonzero && rdim < d;
    if cond {
        'outer: for i in 0..n {
            for j in (i + 1)..n {
                if sig_r[i] == sig_r[j] && sig_l[i] != sig_l[j] {
                    cond = false;
                    break 'outer;
                }
            }
        }
    }
    *stats.tally.entry((d, rdim, cl, cr, cond)).or_insert(0) += 1;
    if cond {
        stats.hits.push(format!("HIT dimL'={} dimR={} k'={} U={:?}", d, rdim, d - rdim, u));
    }
}

/// Enumerate RREF m x 6 matrices over F_7 with the given pivot columns, the first row's
/// free entries fixed by `prefix`, and recurse over the remaining free entries.
fn dist3_enum(piv: &[usize], rows: &mut Vec<[i64; 6]>, r: usize, col: usize, stats: &mut Dist3Stats) {
    let m = piv.len();
    if r == m {
        dist3_eval(rows, stats);
        return;
    }
    if col == 6 {
        dist3_enum(piv, rows, r + 1, 0, stats);
        return;
    }
    // entry (r, col): 0 if col < piv[r] or col is a pivot column; 1 if col == piv[r]; free otherwise
    if col < piv[r] || piv.contains(&col) {
        rows[r][col] = if col == piv[r] { 1 } else { 0 };
        dist3_enum(piv, rows, r, col + 1, stats);
    } else {
        for v in 0..7 {
            rows[r][col] = v;
            dist3_enum(piv, rows, r, col + 1, stats);
        }
        rows[r][col] = 0;
    }
}

fn combinations(n: usize, m: usize) -> Vec<Vec<usize>> {
    let mut out = vec![];
    let mut cur = vec![];
    fn rec(start: usize, n: usize, m: usize, cur: &mut Vec<usize>, out: &mut Vec<Vec<usize>>) {
        if cur.len() == m {
            out.push(cur.clone());
            return;
        }
        for i in start..n {
            cur.push(i);
            rec(i + 1, n, m, cur, out);
            cur.pop();
        }
    }
    rec(0, n, m, &mut cur, &mut out);
    out
}

fn dist3() {
    // tasks: (pivot set, assignment of the first row's free entries)
    let mut tasks: Vec<(Vec<usize>, Vec<i64>)> = vec![];
    for m in 2..=6 {
        for piv in combinations(6, m) {
            let free0: Vec<usize> = (piv[0] + 1..6).filter(|c| !piv.contains(c)).collect();
            let nf = free0.len();
            let total = 7usize.pow(nf as u32);
            for t in 0..total {
                let mut vals = vec![];
                let mut x = t;
                for _ in 0..nf {
                    vals.push((x % 7) as i64);
                    x /= 7;
                }
                tasks.push((piv.clone(), vals));
            }
        }
    }
    eprintln!("dist3: {} tasks", tasks.len());
    let merged: Dist3Stats = tasks
        .par_iter()
        .map(|(piv, vals)| {
            let m = piv.len();
            let mut stats = Dist3Stats::default();
            let mut rows = vec![[0i64; 6]; m];
            // fill row 0 completely, then enumerate rows 1.. via dist3_enum starting at r=1
            let free0: Vec<usize> = (piv[0] + 1..6).filter(|c| !piv.contains(c)).collect();
            rows[0][piv[0]] = 1;
            for (idx, &c) in free0.iter().enumerate() {
                rows[0][c] = vals[idx];
            }
            dist3_enum(piv, &mut rows, 1, 0, &mut stats);
            stats
        })
        .reduce(Dist3Stats::default, |mut a, b| {
            for (k, v) in b.tally {
                *a.tally.entry(k).or_insert(0) += v;
            }
            a.hits.extend(b.hits);
            a.total += b.total;
            a
        });
    println!("# dist3: subspaces examined = {}", merged.total);
    let mut keys: Vec<_> = merged.tally.iter().collect();
    keys.sort();
    println!("# (dimL', dimR, #classes L', #classes R, distance-3 condition) : count");
    for (k, v) in keys {
        println!("{:?} : {}", k, v);
    }
    println!("# hits: {}", merged.hits.len());
    for h in merged.hits.iter().take(200) {
        println!("{}", h);
    }
}

// ---------------------------------------------------------------- Test 3(a): matchings
/// Trivariate form of degree d stored as coef[a][b] for X^a Y^b Z^(d-a-b).
#[derive(Clone)]
struct Form {
    d: usize,
    c: Vec<i64>, // (d+1)*(d+1), index a*(d+1)+b
}
impl Form {
    fn one() -> Form {
        Form { d: 0, c: vec![1] }
    }
    fn get(&self, a: usize, b: usize) -> i64 {
        self.c[a * (self.d + 1) + b]
    }
    fn mul_linear(&self, l: [i64; 3], p: i64) -> Form {
        let d = self.d + 1;
        let mut c = vec![0i64; (d + 1) * (d + 1)];
        for a in 0..=self.d {
            for b in 0..=(self.d - a) {
                let v = self.get(a, b);
                if v == 0 {
                    continue;
                }
                c[(a + 1) * (d + 1) + b] = (c[(a + 1) * (d + 1) + b] + l[0] * v) % p;
                c[a * (d + 1) + b + 1] = (c[a * (d + 1) + b + 1] + l[1] * v) % p;
                c[a * (d + 1) + b] = (c[a * (d + 1) + b] + l[2] * v) % p;
            }
        }
        Form { d, c }
    }
    /// Exact division by Q = XZ - Y^2; panics if the remainder is nonzero.
    fn div_q(&self, p: i64) -> Form {
        let d = self.d;
        let mut g = self.c.clone();
        let hd = d - 2;
        let mut h = vec![0i64; (hd + 1) * (hd + 1)];
        for b in (2..=d).rev() {
            for a in 0..=(d - b) {
                let v = g[a * (d + 1) + b];
                if v == 0 {
                    continue;
                }
                // term t = -v X^a Y^(b-2) Z^c of H; G -= t*(XZ - Y^2)
                let t = (p - v) % p;
                h[a * (hd + 1) + (b - 2)] = (h[a * (hd + 1) + (b - 2)] + t) % p;
                g[a * (d + 1) + b] = 0;
                g[(a + 1) * (d + 1) + (b - 2)] = (g[(a + 1) * (d + 1) + (b - 2)] - t).rem_euclid(p);
            }
        }
        for a in 0..=d {
            for b in 0..2.min(d + 1) {
                if a + b <= d {
                    assert_eq!(g[a * (d + 1) + b], 0, "nonzero remainder in division by Q");
                }
            }
        }
        Form { d: hd, c: h }
    }
    fn flat(&self) -> Vec<i64> {
        let mut out = vec![];
        for a in 0..=self.d {
            for b in 0..=(self.d - a) {
                out.push(self.get(a, b));
            }
        }
        out
    }
}

/// Matching on P^1(F_p): partner[x] for x in 0..p, partner[p] for infinity.
type Matching = Vec<u8>;

fn secant(a: usize, b: usize, p: i64) -> [i64; 3] {
    let pu = p as usize;
    if a == pu {
        return secant(b, a, p);
    }
    if b == pu {
        // L_{a inf} = aX - Y
        return [(a as i64) % p, (p - 1) % p, 0];
    }
    let (a, b) = (a as i64, b as i64);
    [(a * b) % p, (p - (a + b) % p) % p, 1]
}

fn product_form(m: &Matching, p: i64) -> Form {
    let mut f = Form::one();
    for x in 0..m.len() {
        let y = m[x] as usize;
        if x < y {
            f = f.mul_linear(secant(x, y, p), p);
        }
    }
    f
}

fn point_x(m: &Matching, base: &Form, p: i64) -> Vec<i64> {
    let pm = product_form(m, p);
    let mut diff = pm.clone();
    for i in 0..diff.c.len() {
        diff.c[i] = (pm.c[i] - base.c[i]).rem_euclid(p);
    }
    diff.div_q(p).flat()
}

fn translate(m: &Matching, p: usize) -> Matching {
    let mut t = vec![0u8; p + 1];
    let sh = |x: usize| if x == p { p } else { (x + 1) % p };
    for x in 0..=p {
        t[sh(x)] = sh(m[x] as usize) as u8;
    }
    t
}

fn is_translation_canonical(m: &Matching, p: usize) -> bool {
    let mut t = m.clone();
    for _ in 1..p {
        t = translate(&t, p);
        if t < *m {
            return false;
        }
    }
    true
}

fn enumerate_matchings(p: usize, f: &mut dyn FnMut(&Matching)) {
    let n = p + 1;
    let mut m: Matching = vec![u8::MAX; n];
    fn rec(m: &mut Matching, n: usize, f: &mut dyn FnMut(&Matching)) {
        let first = (0..n).find(|&x| m[x] == u8::MAX);
        let Some(a) = first else {
            f(m);
            return;
        };
        for b in (a + 1)..n {
            if m[b] == u8::MAX {
                m[a] = b as u8;
                m[b] = a as u8;
                rec(m, n, f);
                m[a] = u8::MAX;
                m[b] = u8::MAX;
            }
        }
    }
    rec(&mut m, n, f);
}

/// Prefixes: matchings with the first `depth` pairs fixed (for parallel enumeration).
fn matching_prefixes(p: usize, depth: usize) -> Vec<Matching> {
    let n = p + 1;
    let mut out = vec![];
    let mut m: Matching = vec![u8::MAX; n];
    fn rec(m: &mut Matching, n: usize, depth: usize, out: &mut Vec<Matching>) {
        if depth == 0 {
            out.push(m.clone());
            return;
        }
        let a = (0..n).find(|&x| m[x] == u8::MAX).unwrap();
        for b in (a + 1)..n {
            if m[b] == u8::MAX {
                m[a] = b as u8;
                m[b] = a as u8;
                rec(m, n, depth - 1, out);
                m[a] = u8::MAX;
                m[b] = u8::MAX;
            }
        }
    }
    rec(&mut m, n, depth, &mut out);
    out
}

fn complete_from_prefix(prefix: &Matching, f: &mut dyn FnMut(&Matching)) {
    let n = prefix.len();
    let mut m = prefix.clone();
    fn rec(m: &mut Matching, n: usize, f: &mut dyn FnMut(&Matching)) {
        let first = (0..n).find(|&x| m[x] == u8::MAX);
        let Some(a) = first else {
            f(m);
            return;
        };
        for b in (a + 1)..n {
            if m[b] == u8::MAX {
                m[a] = b as u8;
                m[b] = a as u8;
                rec(m, n, f);
                m[a] = u8::MAX;
                m[b] = u8::MAX;
            }
        }
    }
    rec(&mut m, n, f);
}

struct Moments {
    m1: Vec<i64>,
    m2: Vec<i64>,
}

fn moments_of(points: &[Vec<i64>], p: i64) -> Moments {
    let nn = points[0].len();
    let mut m1 = vec![0i64; nn];
    let mut m2 = vec![0i64; nn * (nn + 1) / 2];
    for x in points {
        let mut idx = 0;
        for i in 0..nn {
            m1[i] = (m1[i] + x[i]) % p;
            for j in i..nn {
                m2[idx] = (m2[idx] + x[i] * x[j]) % p;
                idx += 1;
            }
        }
    }
    Moments { m1, m2 }
}

fn moment3(points: &[Vec<i64>], p: i64) -> Vec<i64> {
    let nn = points[0].len();
    let mut m3 = vec![0i64; nn * (nn + 1) * (nn + 2) / 6];
    for x in points {
        let mut idx = 0;
        for i in 0..nn {
            for j in i..nn {
                let xij = x[i] * x[j] % p;
                for k in j..nn {
                    m3[idx] = (m3[idx] + xij * x[k]) % p;
                    idx += 1;
                }
            }
        }
    }
    m3
}

fn hash_vec(v: &[i64], seed: u64) -> u64 {
    let mut h = seed ^ 0xcbf29ce484222325;
    for &x in v {
        h ^= x as u64;
        h = h.wrapping_mul(0x100000001b3);
        h ^= h >> 29;
    }
    h
}

fn encode(m: &Matching) -> u128 {
    let mut c: u128 = 0;
    for &x in m {
        c = (c << 5) | (x as u128);
    }
    c
}
fn decode(c: u128, n: usize) -> Matching {
    let mut m = vec![0u8; n];
    let mut c = c;
    for i in (0..n).rev() {
        m[i] = (c & 31) as u8;
        c >>= 5;
    }
    m
}

fn class_points(rep: &Matching, base: &Form, p: usize) -> Vec<Vec<i64>> {
    let mut pts = vec![];
    let mut m = rep.clone();
    for _ in 0..p {
        pts.push(point_x(&m, base, p as i64));
        m = translate(&m, p);
    }
    pts
}

fn affine_dim(points: &[Vec<i64>], p: i64) -> usize {
    let nn = points[0].len();
    let mut rows: Vec<Vec<i64>> = points
        .iter()
        .map(|x| {
            let mut r = vec![1i64];
            r.extend(x.iter().map(|&v| v.rem_euclid(p)));
            let _ = nn;
            r
        })
        .collect();
    let (rk, _) = rref(&mut rows, p);
    rk // = 1 + affine dimension
}

/// Matchings invariant under x -> c x (fixing 0 and infinity), for every c != 1.
fn symmetric_matchings(p: usize) -> Vec<Matching> {
    let pi = p as i64;
    let mut out: Vec<Matching> = vec![];
    for c in 2..p {
        let n = p + 1;
        let mut m: Matching = vec![u8::MAX; n];
        m[0] = p as u8;
        m[p] = 0;
        fn rec(m: &mut Matching, p: usize, c: i64, out: &mut Vec<Matching>) {
            let pi = p as i64;
            let first = (1..p).find(|&x| m[x] == u8::MAX);
            let Some(a) = first else {
                out.push(m.clone());
                return;
            };
            for b in (a + 1)..p {
                if m[b] != u8::MAX {
                    continue;
                }
                // try to add the whole <c>-orbit of the pair {a,b}
                let mut added: Vec<(usize, usize)> = vec![];
                let mut ok = true;
                let (mut x, mut y) = (a as i64, b as i64);
                loop {
                    let (xu, yu) = (x as usize, y as usize);
                    if m[xu] == u8::MAX && m[yu] == u8::MAX && xu != yu {
                        m[xu] = yu as u8;
                        m[yu] = xu as u8;
                        added.push((xu, yu));
                    } else if !(m[xu] == yu as u8 && m[yu] == xu as u8) {
                        ok = false;
                        break;
                    }
                    x = x * c % pi;
                    y = y * c % pi;
                    if x == a as i64 && y == b as i64 {
                        break;
                    }
                    if x == b as i64 && y == a as i64 {
                        break;
                    }
                }
                if ok {
                    rec(m, p, c, out);
                }
                for (xu, yu) in added {
                    m[xu] = u8::MAX;
                    m[yu] = u8::MAX;
                }
            }
        }
        rec(&mut m, p, c as i64, &mut out);
        let _ = pi;
    }
    out.sort();
    out.dedup();
    out
}

fn trades(p: usize, sym_only: bool) {
    let pi = p as i64;
    let base_m: Matching = {
        // base matching: pair x with x+1 for even x, infinity with p-1... use the first
        // matching in enumeration order
        let mut b = None;
        enumerate_matchings(p, &mut |m| {
            if b.is_none() {
                b = Some(m.clone());
            }
        });
        b.unwrap()
    };
    let base = product_form(&base_m, pi);
    // gather translation-canonical representatives
    let reps: Vec<u128> = if sym_only {
        let sm = symmetric_matchings(p);
        let mut v: Vec<u128> = sm
            .iter()
            .map(|m| {
                // translation-canonical form of m
                let mut best = m.clone();
                let mut t = m.clone();
                for _ in 1..p {
                    t = translate(&t, p);
                    if t < best {
                        best = t.clone();
                    }
                }
                encode(&best)
            })
            .collect();
        v.sort();
        v.dedup();
        v
    } else {
        let prefixes = matching_prefixes(p, if p >= 17 { 3 } else { 1 });
        let mut v: Vec<u128> = prefixes
            .par_iter()
            .flat_map_iter(|pre| {
                let mut local = vec![];
                complete_from_prefix(pre, &mut |m| {
                    if is_translation_canonical(m, p) {
                        local.push(encode(m));
                    }
                });
                local
            })
            .collect();
        v.sort();
        v
    };
    eprintln!("trades p={} : {} translation classes ({})", p, reps.len(), if sym_only { "AGL-symmetric only" } else { "all" });
    // hash (m1, m2) per class
    let n = p + 1;
    let keyed: Vec<(u64, u128)> = reps
        .par_iter()
        .map(|&code| {
            let m = decode(code, n);
            let pts = class_points(&m, &base, p);
            let mo = moments_of(&pts, pi);
            let h = hash_vec(&mo.m1, 1) ^ hash_vec(&mo.m2, 2).rotate_left(17);
            (h, code)
        })
        .collect();
    let mut keyed = keyed;
    keyed.sort();
    // buckets
    let mut hits = 0u64;
    let mut strength3 = 0u64;
    let mut checked_pairs = 0u64;
    let mut i = 0;
    let mut bucket_sizes: HashMap<usize, u64> = HashMap::new();
    while i < keyed.len() {
        let mut j = i;
        while j < keyed.len() && keyed[j].0 == keyed[i].0 {
            j += 1;
        }
        *bucket_sizes.entry(j - i).or_insert(0) += 1;
        if j - i >= 2 {
            let members: Vec<(Matching, Vec<Vec<i64>>)> = keyed[i..j]
                .iter()
                .map(|&(_, c)| {
                    let m = decode(c, n);
                    let pts = class_points(&m, &base, p);
                    (m, pts)
                })
                .collect();
            let mos: Vec<Moments> = members.iter().map(|(_, pts)| moments_of(pts, pi)).collect();
            let m3s: Vec<Vec<i64>> = members.iter().map(|(_, pts)| moment3(pts, pi)).collect();
            for a in 0..members.len() {
                for b in (a + 1)..members.len() {
                    checked_pairs += 1;
                    if mos[a].m1 == mos[b].m1 && mos[a].m2 == mos[b].m2 {
                        let mut all: Vec<Vec<i64>> = members[a].1.clone();
                        all.extend(members[b].1.iter().cloned());
                        let ad = affine_dim(&all, pi);
                        if m3s[a] != m3s[b] {
                            hits += 1;
                            if hits <= 50 {
                                println!(
                                    "HIT p={} classes {:?} | {:?}  affine-rank(1+dim)={}",
                                    p, members[a].0, members[b].0, ad
                                );
                            }
                        } else {
                            strength3 += 1;
                            if strength3 <= 20 {
                                println!(
                                    "STRENGTH3 p={} classes {:?} | {:?}  affine-rank={}",
                                    p, members[a].0, members[b].0, ad
                                );
                            }
                        }
                    }
                }
            }
        }
        i = j;
    }
    let mut bs: Vec<_> = bucket_sizes.into_iter().collect();
    bs.sort();
    println!(
        "# p={} classes={} pairs-checked={} hits(m0..m2 equal, m3 different)={} strength3(m3 also equal)={} bucket-size-distribution={:?}",
        p,
        reps.len(),
        checked_pairs,
        hits,
        strength3,
        bs
    );
}

// ---------------------------------------------------------------- PGL_2 orbits
fn pgl2_elements(p: usize, psl_only: bool) -> Vec<[i64; 4]> {
    let pi = p as i64;
    let mut els = vec![];
    let is_square = |x: i64| -> bool { (1..pi).any(|y| y * y % pi == x.rem_euclid(pi)) };
    for a in 0..pi {
        for b in 0..pi {
            for c in 0..pi {
                for d in 0..pi {
                    let det = (a * d - b * c).rem_euclid(pi);
                    if det == 0 {
                        continue;
                    }
                    if psl_only && !is_square(det) {
                        continue;
                    }
                    els.push([a, b, c, d]);
                }
            }
        }
    }
    // normalize projectively: keep those with first nonzero entry == 1
    els.retain(|e| {
        let first = e.iter().find(|&&x| x != 0).unwrap();
        *first == 1
    });
    els
}

fn apply_mobius(e: &[i64; 4], x: usize, p: usize) -> usize {
    let pi = p as i64;
    let [a, b, c, d] = *e;
    if x == p {
        // infinity -> a/c
        if c == 0 {
            p
        } else {
            (a * inv(c, pi)).rem_euclid(pi) as usize
        }
    } else {
        let xi = x as i64;
        let num = (a * xi + b).rem_euclid(pi);
        let den = (c * xi + d).rem_euclid(pi);
        if den == 0 {
            p
        } else {
            (num * inv(den, pi)).rem_euclid(pi) as usize
        }
    }
}

fn act(e: &[i64; 4], m: &Matching, p: usize) -> Matching {
    let mut t = vec![0u8; p + 1];
    for x in 0..=p {
        t[apply_mobius(e, x, p)] = apply_mobius(e, m[x] as usize, p) as u8;
    }
    t
}

fn orbits(p: usize) {
    let pi = p as i64;
    let n = p + 1;
    let base_m: Matching = {
        let mut b = None;
        enumerate_matchings(p, &mut |m| {
            if b.is_none() {
                b = Some(m.clone());
            }
        });
        b.unwrap()
    };
    let base = product_form(&base_m, pi);
    for (name, psl) in [("PGL_2", false), ("PSL_2", true)] {
        let g = pgl2_elements(p, psl);
        let mut all: Vec<u128> = vec![];
        enumerate_matchings(p, &mut |m| all.push(encode(m)));
        let reps: Vec<u128> = all
            .par_iter()
            .filter(|&&c| {
                let m = decode(c, n);
                g.iter().all(|e| act(e, &m, p) >= m)
            })
            .cloned()
            .collect();
        // orbit data
        struct Orb {
            rep: Matching,
            size: usize,
            pts: Vec<Vec<i64>>,
        }
        let orbs: Vec<Orb> = reps
            .par_iter()
            .map(|&c| {
                let m = decode(c, n);
                let mut members: Vec<Matching> = g.iter().map(|e| act(e, &m, p)).collect();
                members.sort();
                members.dedup();
                let pts: Vec<Vec<i64>> = members.iter().map(|mm| point_x(mm, &base, pi)).collect();
                Orb { rep: m, size: members.len(), pts }
            })
            .collect();
        let mut sizes: HashMap<usize, u64> = HashMap::new();
        for o in &orbs {
            *sizes.entry(o.size).or_insert(0) += 1;
        }
        let mut sz: Vec<_> = sizes.into_iter().collect();
        sz.sort();
        println!("# {} p={} : {} orbits, size distribution {:?}", name, p, orbs.len(), sz);
        let mos: Vec<Moments> = orbs.iter().map(|o| moments_of(&o.pts, pi)).collect();
        let mut hits = 0;
        for a in 0..orbs.len() {
            for b in (a + 1)..orbs.len() {
                if orbs[a].size != orbs[b].size {
                    continue;
                }
                if mos[a].m1 == mos[b].m1 && mos[a].m2 == mos[b].m2 {
                    let m3a = moment3(&orbs[a].pts, pi);
                    let m3b = moment3(&orbs[b].pts, pi);
                    let mut all_pts = orbs[a].pts.clone();
                    all_pts.extend(orbs[b].pts.iter().cloned());
                    let ad = affine_dim(&all_pts, pi);
                    if m3a != m3b {
                        hits += 1;
                        println!(
                            "HIT {} p={} size={} reps {:?} | {:?} affine-rank={}",
                            name, p, orbs[a].size, orbs[a].rep, orbs[b].rep, ad
                        );
                    } else {
                        println!(
                            "STRENGTH3 {} p={} size={} reps {:?} | {:?} affine-rank={}",
                            name, p, orbs[a].size, orbs[a].rep, orbs[b].rep, ad
                        );
                    }
                }
            }
        }
        println!("# {} p={} hits={}", name, p, hits);
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    match args.get(1).map(|s| s.as_str()) {
        Some("dist3") => dist3(),
        Some("trades") => {
            let p: usize = args[2].parse().unwrap();
            let sym = args.iter().any(|a| a == "--sym");
            trades(p, sym);
        }
        Some("orbits") => {
            let p: usize = args[2].parse().unwrap();
            orbits(p);
        }
        _ => eprintln!("usage: conic-search dist3 | trades P [--sym] | orbits P"),
    }
}
