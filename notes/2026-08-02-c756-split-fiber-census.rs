// C756 split-fiber census (lane: clebsch).
//
// Definitions (fixed by the task statement):
//   q odd prime; eps = smallest nonsquare in F_q; F_{q^2} = F_q(s), s^2 = eps.
//   Conjugation (a+b s)^q = a - b s.  N(u) = u^{q+1} = u * u^q in F_q.
//   chi(u) = chi_q(N(u)) with chi_q the Legendre symbol of F_q; chi(0) = 0.
//   t = (q+1)/2, nn = t+1 = (q+3)/2.
//
// A split-fiber pair is (R, gamma): R in F_q[X] monic of degree nn with R(0)=0,
// gamma in F_{q^2} \ F_q, and R(X) - gamma has nn distinct roots in F_{q^2}.
// Equivalently |R^{-1}(gamma)| = nn inside F_{q^2}.
//
// Cascade filters (see report):
//   F1: chi(R'(z)) = (-1)^t for all z in Z = R^{-1}(gamma).
//   F2: chi((z_i - z_j)(z_i - z_j^q)) = -1 for all i<j.
//   F3: chi(z_i - z_j) = (-1)^t and chi(z_i - z_j^q) = (-1)^{t+1} for all i != j.
//   F4: crown check on the Cayley graph over F_{q^2} with connection set
//       S = {u != 0 : chi(u) = (-1)^{t+1}}.
//
// Build:  rustc -O -o <out>/c756_census 2026-08-02-c756-split-fiber-census.rs
// Run:    <out>/c756_census <json-output-path>
//
// No external crates; threading is plain std::thread with a shared atomic work index.

use std::collections::{BTreeMap, HashSet};
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::{Arc, Mutex};
use std::thread;

// ---------------------------------------------------------------- field ----

#[derive(Clone)]
struct Field {
    q: usize,
    eps: usize,
    n2: usize,
    add: Vec<u16>,  // n2*n2
    neg: Vec<u16>,  // n2
    mul: Vec<u16>,  // n2*n2
    conj: Vec<u16>, // n2
    chi: Vec<i8>,   // n2
    invq: Vec<usize>,
}

fn pow_mod(mut b: usize, mut e: usize, m: usize) -> usize {
    let mut r = 1usize;
    b %= m;
    while e > 0 {
        if e & 1 == 1 {
            r = r * b % m;
        }
        b = b * b % m;
        e >>= 1;
    }
    r
}

fn legendre(x: usize, q: usize) -> i8 {
    let x = x % q;
    if x == 0 {
        return 0;
    }
    if pow_mod(x, (q - 1) / 2, q) == 1 {
        1
    } else {
        -1
    }
}

impl Field {
    fn new(q: usize) -> Field {
        let mut eps = 0usize;
        for c in 2..q {
            if legendre(c, q) == -1 {
                eps = c;
                break;
            }
        }
        assert!(eps != 0, "no nonsquare found");
        let n2 = q * q;
        let idx = |a: usize, b: usize| a + b * q;
        let mut add = vec![0u16; n2 * n2];
        let mut mul = vec![0u16; n2 * n2];
        let mut neg = vec![0u16; n2];
        let mut conj = vec![0u16; n2];
        let mut chi = vec![0i8; n2];
        for a1 in 0..q {
            for b1 in 0..q {
                let u = idx(a1, b1);
                neg[u] = idx((q - a1) % q, (q - b1) % q) as u16;
                conj[u] = idx(a1, (q - b1) % q) as u16;
                // N(u) = a^2 - eps b^2
                let nrm = (a1 * a1 + q * q * eps - eps * b1 * b1) % q;
                chi[u] = legendre(nrm, q);
                for a2 in 0..q {
                    for b2 in 0..q {
                        let v = idx(a2, b2);
                        add[u * n2 + v] = idx((a1 + a2) % q, (b1 + b2) % q) as u16;
                        mul[u * n2 + v] =
                            idx((a1 * a2 + eps * b1 * b2) % q, (a1 * b2 + a2 * b1) % q) as u16;
                    }
                }
            }
        }
        let mut invq = vec![0usize; q];
        for a in 1..q {
            invq[a] = pow_mod(a, q - 2, q);
        }
        Field { q, eps, n2, add, neg, mul, conj, chi, invq }
    }
    #[inline(always)]
    fn a(&self, u: u16) -> usize {
        (u as usize) % self.q
    }
    #[inline(always)]
    fn b(&self, u: u16) -> usize {
        (u as usize) / self.q
    }
    #[inline(always)]
    fn ad(&self, u: u16, v: u16) -> u16 {
        self.add[u as usize * self.n2 + v as usize]
    }
    #[inline(always)]
    fn ml(&self, u: u16, v: u16) -> u16 {
        self.mul[u as usize * self.n2 + v as usize]
    }
    #[inline(always)]
    fn sub(&self, u: u16, v: u16) -> u16 {
        self.ad(u, self.neg[v as usize])
    }
    fn emb(&self, a: usize) -> u16 {
        (a % self.q) as u16
    }
    fn fmt(&self, u: u16) -> String {
        format!("{}+{}s", self.a(u), self.b(u))
    }
    /// Horner evaluation of monic degree-nn R with R(0)=0 and coeffs c[1..nn-1] in F_q.
    fn eval_r(&self, c: &[u8], nn: usize, z: u16) -> u16 {
        // R = X^nn + c[nn-1] X^(nn-1) + ... + c[1] X, c[0] = 0
        let mut acc: u16 = 1;
        for k in (1..nn).rev() {
            acc = self.ml(acc, z);
            acc = self.ad(acc, self.emb(c[k] as usize));
        }
        self.ml(acc, z)
    }
    /// R'(z), R' = nn X^(nn-1) + sum_{k=1}^{nn-1} k c_k X^(k-1)
    fn eval_dr(&self, c: &[u8], nn: usize, z: u16) -> u16 {
        let mut acc: u16 = self.emb(nn);
        for k in (1..nn).rev() {
            acc = self.ml(acc, z);
            acc = self.ad(acc, self.emb(k * c[k] as usize));
        }
        acc
    }
}

// ------------------------------------------------------------- analysis ----

struct PairAnalysis {
    z: Vec<u16>,
    f1: bool,
    f2: bool,
    f3: bool,
    coh_ordered: usize, // ordered (i,j), i!=j, satisfying both F3 sign conditions
    f4_crown: bool,
    f4_agrees: bool,
    assert_ok: bool,
}

fn analyze(f: &Field, c: &[u8], nn: usize, gamma: u16, sign_t: i8) -> PairAnalysis {
    // recover roots by scanning the irrational elements
    let mut z: Vec<u16> = Vec::with_capacity(nn);
    for bb in 1..f.q {
        for aa in 0..f.q {
            let u = (aa + bb * f.q) as u16;
            if f.eval_r(c, nn, u) == gamma {
                z.push(u);
            }
        }
    }
    let mut assert_ok = z.len() == nn;
    // all irrational, no two conjugate, all distinct
    let mut seen = HashSet::new();
    for &u in &z {
        if f.b(u) == 0 {
            assert_ok = false;
        }
        if !seen.insert(u) {
            assert_ok = false;
        }
    }
    for &u in &z {
        if seen.contains(&f.conj[u as usize]) {
            assert_ok = false;
        }
    }
    if !assert_ok {
        return PairAnalysis {
            z,
            f1: false,
            f2: false,
            f3: false,
            coh_ordered: 0,
            f4_crown: false,
            f4_agrees: false,
            assert_ok: false,
        };
    }
    let sign_t1: i8 = -sign_t; // (-1)^{t+1}

    // F1
    let mut f1 = true;
    for &u in &z {
        if f.chi[f.eval_dr(c, nn, u) as usize] != sign_t {
            f1 = false;
            break;
        }
    }
    // F2, F3, coherence count
    let mut f2 = true;
    let mut f3 = true;
    let mut coh = 0usize;
    for i in 0..nn {
        for j in 0..nn {
            if i == j {
                continue;
            }
            let d = f.sub(z[i], z[j]);
            let e = f.sub(z[i], f.conj[z[j] as usize]);
            let c1 = f.chi[d as usize] == sign_t;
            let c2 = f.chi[e as usize] == sign_t1;
            if c1 && c2 {
                coh += 1;
            }
            if !(c1 && c2) {
                f3 = false;
            }
            if i < j {
                let prod = f.ml(d, e);
                if f.chi[prod as usize] != -1 {
                    f2 = false;
                }
            }
        }
    }
    // F4: induced subgraph on Z u Z^q under Cayley graph with connection set chi = (-1)^{t+1}
    let mut verts: Vec<u16> = Vec::with_capacity(2 * nn);
    for &u in &z {
        verts.push(u);
    }
    for &u in &z {
        verts.push(f.conj[u as usize]);
    }
    let adj = |x: u16, y: u16| -> bool { f.chi[f.sub(x, y) as usize] == sign_t1 };
    let mut crown = true;
    for i in 0..2 * nn {
        for j in 0..2 * nn {
            if i == j {
                continue;
            }
            let same_side = (i < nn) == (j < nn);
            let matched = (i % nn) == (j % nn);
            let want = !same_side && !matched;
            if adj(verts[i], verts[j]) != want {
                crown = false;
            }
        }
    }
    PairAnalysis {
        z,
        f1,
        f2,
        f3,
        coh_ordered: coh,
        f4_crown: crown,
        f4_agrees: crown == f3,
        assert_ok: true,
    }
}

// --------------------------------------------------------------- census ----

struct Found {
    c: [u8; 20],
    gamma: u16,
}

/// Enumerate all monic R of degree nn with R(0)=0 over F_q and record every
/// (R,gamma) with gamma irrational and |R^{-1}(gamma)| = nn.
fn enumerate_split_pairs(f: &Field, nn: usize, nthreads: usize) -> Vec<Found> {
    let q = f.q;
    let m = nn - 1; // free coefficients c_1..c_{nn-1}
    // half set: one representative per conjugate pair of irrational elements
    let mut hs: Vec<u16> = Vec::new();
    for bb in 1..=(q - 1) / 2 {
        for aa in 0..q {
            hs.push((aa + bb * q) as u16);
        }
    }
    let hn = hs.len();
    // powers: pw[k][i] = hs[i]^k for k=0..nn
    let mut pw = vec![vec![0u16; hn]; nn + 1];
    for i in 0..hn {
        pw[0][i] = 1;
        for k in 1..=nn {
            pw[k][i] = f.ml(pw[k - 1][i], hs[i]);
        }
    }
    // split coefficient space: fix the top `fixk` digits (coefficients of the
    // highest powers), Gray-code over the remaining `m - fixk`.
    let mut fixk = 0usize;
    while fixk < m && pow_usize(q, fixk) < 4 * nthreads {
        fixk += 1;
    }
    let free = m - fixk;
    let nchunks = pow_usize(q, fixk);
    let next = Arc::new(AtomicUsize::new(0));
    let out: Arc<Mutex<Vec<Found>>> = Arc::new(Mutex::new(Vec::new()));
    let conj_a: Vec<u16> = (0..f.n2).map(|i| f.conj[i]).collect();

    thread::scope(|scope| {
        for _ in 0..nthreads {
            let next = Arc::clone(&next);
            let out = Arc::clone(&out);
            let hs = &hs;
            let pw = &pw;
            let conj_a = &conj_a;
            scope.spawn(move || {
                let mut local: Vec<Found> = Vec::new();
                let mut va = vec![0u8; hn];
                let mut vb = vec![0u8; hn];
                let mut cnt = vec![0u8; f.n2];
                let mut touched: Vec<u16> = Vec::with_capacity(hn);
                let mut digits = vec![0u8; m];
                loop {
                    let chunk = next.fetch_add(1, Ordering::Relaxed);
                    if chunk >= nchunks {
                        break;
                    }
                    // decode fixed top digits
                    let mut cc = chunk;
                    for j in 0..fixk {
                        digits[free + j] = (cc % q) as u8;
                        cc /= q;
                    }
                    for j in 0..free {
                        digits[j] = 0;
                    }
                    // initialise values: R(z) = z^nn + sum_{k} c_k z^k
                    for i in 0..hn {
                        let mut acc = pw[nn][i];
                        for j in 0..m {
                            if digits[j] != 0 {
                                let term = f.ml(f.emb(digits[j] as usize), pw[j + 1][i]);
                                acc = f.ad(acc, term);
                            }
                        }
                        va[i] = f.a(acc) as u8;
                        vb[i] = f.b(acc) as u8;
                    }
                    // loop-free mixed-radix reflected Gray code over digits 0..free
                    let mut fo: Vec<usize> = (0..=free).collect();
                    let mut o: Vec<i8> = vec![1; free.max(1)];
                    let mut d: Vec<i32> = vec![0; free.max(1)];
                    loop {
                        // ---- visit current polynomial ----
                        touched.clear();
                        for i in 0..hn {
                            let g = va[i] as usize + vb[i] as usize * q;
                            if cnt[g] == 0 {
                                touched.push(g as u16);
                            }
                            cnt[g] += 1;
                        }
                        for &g in touched.iter() {
                            let gu = g as usize;
                            if gu / q == 0 {
                                continue; // rational gamma
                            }
                            let cg = conj_a[gu] as usize;
                            if cnt[gu] as usize + cnt[cg] as usize == nn {
                                // record both gamma and its conjugate, once each
                                if gu < cg || cnt[cg] == 0 {
                                    let mut arr = [0u8; 20];
                                    for j in 0..m {
                                        arr[j + 1] = digits[j];
                                    }
                                    local.push(Found { c: arr, gamma: gu as u16 });
                                    local.push(Found { c: arr, gamma: cg as u16 });
                                }
                            }
                        }
                        for &g in touched.iter() {
                            cnt[g as usize] = 0;
                        }
                        // ---- advance ----
                        if free == 0 {
                            break;
                        }
                        let j = fo[0];
                        fo[0] = 0;
                        if j == free {
                            break;
                        }
                        let delta = o[j];
                        d[j] += delta as i32;
                        digits[j] = d[j] as u8;
                        // update values by delta * z^(j+1)
                        let pk = &pw[j + 1];
                        if delta == 1 {
                            for i in 0..hn {
                                let p = pk[i] as usize;
                                let pa = p % q;
                                let pb = p / q;
                                let mut na = va[i] as usize + pa;
                                if na >= q {
                                    na -= q;
                                }
                                let mut nb = vb[i] as usize + pb;
                                if nb >= q {
                                    nb -= q;
                                }
                                va[i] = na as u8;
                                vb[i] = nb as u8;
                            }
                        } else {
                            for i in 0..hn {
                                let p = pk[i] as usize;
                                let pa = p % q;
                                let pb = p / q;
                                let na = va[i] as usize + q - pa;
                                let nb = vb[i] as usize + q - pb;
                                va[i] = (if na >= q { na - q } else { na }) as u8;
                                vb[i] = (if nb >= q { nb - q } else { nb }) as u8;
                            }
                        }
                        if d[j] == 0 || d[j] == (q as i32) - 1 {
                            o[j] = -o[j];
                            fo[j] = fo[j + 1];
                            fo[j + 1] = j + 1;
                        }
                    }
                }
                out.lock().unwrap().extend(local);
            });
        }
    });
    Arc::try_unwrap(out).ok().unwrap().into_inner().unwrap()
}

/// Independent (slow) recount of the raw split-pair total: plain Horner over every
/// monic R, no Gray code, no incremental state.  Used only as a self-check.
fn brute_count(f: &Field, nn: usize, nthreads: usize) -> u64 {
    let q = f.q;
    let m = nn - 1;
    let mut hs: Vec<u16> = Vec::new();
    for bb in 1..=(q - 1) / 2 {
        for aa in 0..q {
            hs.push((aa + bb * q) as u16);
        }
    }
    let hn = hs.len();
    let total = pow_usize(q, m);
    let next = Arc::new(AtomicUsize::new(0));
    let acc = Arc::new(AtomicUsize::new(0));
    let block = 1usize << 14;
    thread::scope(|scope| {
        for _ in 0..nthreads {
            let next = Arc::clone(&next);
            let acc = Arc::clone(&acc);
            let hs = &hs;
            scope.spawn(move || {
                let mut cnt = vec![0u8; f.n2];
                let mut touched: Vec<u16> = Vec::with_capacity(hn);
                let mut c = vec![0u8; nn + 1];
                let mut local = 0usize;
                loop {
                    let s = next.fetch_add(block, Ordering::Relaxed);
                    if s >= total {
                        break;
                    }
                    let e = (s + block).min(total);
                    for idx in s..e {
                        let mut x = idx;
                        for k in 1..=m {
                            c[k] = (x % q) as u8;
                            x /= q;
                        }
                        touched.clear();
                        for i in 0..hn {
                            let g = f.eval_r(&c, nn, hs[i]) as usize;
                            if cnt[g] == 0 {
                                touched.push(g as u16);
                            }
                            cnt[g] += 1;
                        }
                        for &g in touched.iter() {
                            let gu = g as usize;
                            if gu / q == 0 {
                                continue;
                            }
                            let cg = f.conj[gu] as usize;
                            if cnt[gu] as usize + cnt[cg] as usize == nn
                                && (gu < cg || cnt[cg] == 0)
                            {
                                local += 2;
                            }
                        }
                        for &g in touched.iter() {
                            cnt[g as usize] = 0;
                        }
                    }
                }
                acc.fetch_add(local, Ordering::Relaxed);
            });
        }
    });
    acc.load(Ordering::Relaxed) as u64
}

fn pow_usize(b: usize, e: usize) -> usize {
    let mut r = 1usize;
    for _ in 0..e {
        r *= b;
    }
    r
}

// ---------------------------------------------------------------- orbits ---

/// Orbit count of the split-fiber pairs under X -> aX + b (a in F_q^*, b in F_q),
/// acting by R(X) |-> a^{-nn} (R(aX+b) - R(b)), gamma |-> a^{-nn}(gamma - R(b)).
/// On root sets this is Z |-> {(z - b)/a}.  We canonicalise on root sets, which
/// determine the pair bijectively (R = prod(X-z) - prod(-z), gamma = -prod(-z)).
fn orbit_count(
    f: &Field,
    zsets: &[Vec<u16>],
    nn: usize,
) -> (usize, bool, BTreeMap<usize, usize>) {
    let q = f.q;
    let all: HashSet<u64> = zsets.iter().map(|z| enc(z)).collect();
    let mut canon: BTreeMap<u64, usize> = BTreeMap::new();
    let mut closed = true;
    let mut tmp = vec![0u16; nn];
    let mut img: HashSet<u64> = HashSet::new();
    for z in zsets {
        let mut best = u64::MAX;
        img.clear();
        for a in 1..q {
            let ai = f.emb(f.invq[a]);
            for b in 0..q {
                let bb = f.emb(b);
                for i in 0..nn {
                    tmp[i] = f.ml(ai, f.sub(z[i], bb));
                }
                let e = enc(&tmp);
                if !all.contains(&e) {
                    closed = false;
                }
                img.insert(e);
                if e < best {
                    best = e;
                }
            }
        }
        canon.insert(best, img.len());
    }
    let mut hist: BTreeMap<usize, usize> = BTreeMap::new();
    for (_, &sz) in canon.iter() {
        *hist.entry(sz).or_insert(0) += 1;
    }
    (canon.len(), closed, hist)
}

fn enc(z: &[u16]) -> u64 {
    let mut v = [0u16; 8];
    assert!(z.len() <= 8);
    v[..z.len()].copy_from_slice(z);
    let s = &mut v[..z.len()];
    s.sort_unstable();
    let mut e: u64 = 0;
    for &x in s.iter() {
        assert!(x < 256);
        e = (e << 8) | x as u64;
    }
    e
}

// -------------------------------------------------------------- sampling ---

struct Rng(u64);
impl Rng {
    fn next(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        self.0 = x;
        x
    }
}

/// Uniform random monic R of degree nn with R(0)=0; count R having at least one
/// totally split irrational fiber, and the total number of such fibers.
fn sample_density(f: &Field, nn: usize, nsamples: u64, nthreads: usize, seed: u64) -> (u64, u64) {
    let q = f.q;
    let m = nn - 1;
    let mut hs: Vec<u16> = Vec::new();
    for bb in 1..=(q - 1) / 2 {
        for aa in 0..q {
            hs.push((aa + bb * q) as u16);
        }
    }
    let hn = hs.len();
    // Fixed shard count and per-shard seeds: the sample is a deterministic
    // function of (q, nsamples, seed) and does NOT depend on the thread count.
    const NSHARDS: u64 = 256;
    let hits = Arc::new(AtomicUsize::new(0));
    let fibers = Arc::new(AtomicUsize::new(0));
    let shard = Arc::new(AtomicUsize::new(0));
    thread::scope(|scope| {
        for _ in 0..nthreads {
            let hits = Arc::clone(&hits);
            let fibers = Arc::clone(&fibers);
            let shard = Arc::clone(&shard);
            let hs = &hs;
            scope.spawn(move || {
              loop {
                let sh = shard.fetch_add(1, Ordering::Relaxed) as u64;
                if sh >= NSHARDS {
                    break;
                }
                let n = nsamples / NSHARDS
                    + if sh < nsamples % NSHARDS { 1 } else { 0 };
                let mut rng = Rng(seed.wrapping_mul(0x9E3779B97F4A7C15).wrapping_add(
                    (sh + 1).wrapping_mul(0xBF58476D1CE4E5B9),
                ) | 1);
                for _ in 0..20 {
                    rng.next();
                }
                let mut c = vec![0u8; nn];
                let mut cnt = vec![0u8; f.n2];
                let mut touched: Vec<u16> = Vec::with_capacity(hn);
                let mut lh = 0usize;
                let mut lf = 0usize;
                for _ in 0..n {
                    for k in 1..=m {
                        c[k] = (rng.next() % q as u64) as u8;
                    }
                    touched.clear();
                    for i in 0..hn {
                        let g = f.eval_r(&c, nn, hs[i]) as usize;
                        if cnt[g] == 0 {
                            touched.push(g as u16);
                        }
                        cnt[g] += 1;
                    }
                    let mut found = 0usize;
                    for &g in touched.iter() {
                        let gu = g as usize;
                        if gu / q == 0 {
                            continue;
                        }
                        let cg = f.conj[gu] as usize;
                        if cnt[gu] as usize + cnt[cg] as usize == nn {
                            if gu < cg || cnt[cg] == 0 {
                                found += 2;
                            }
                        }
                    }
                    for &g in touched.iter() {
                        cnt[g as usize] = 0;
                    }
                    if found > 0 {
                        lh += 1;
                        lf += found;
                    }
                }
                hits.fetch_add(lh, Ordering::Relaxed);
                fibers.fetch_add(lf, Ordering::Relaxed);
              }
            });
        }
    });
    (
        hits.load(Ordering::Relaxed) as u64,
        fibers.load(Ordering::Relaxed) as u64,
    )
}

fn wilson(k: f64, n: f64) -> (f64, f64) {
    if n == 0.0 {
        return (0.0, 1.0);
    }
    let z = 1.959963984540054f64;
    let p = k / n;
    let d = 1.0 + z * z / n;
    let c = p + z * z / (2.0 * n);
    let hw = z * ((p * (1.0 - p) / n) + z * z / (4.0 * n * n)).sqrt();
    (((c - hw) / d).max(0.0), ((c + hw) / d).min(1.0))
}

// ------------------------------------------------------------------ main ---

fn jesc(s: &str) -> String {
    s.replace('\\', "\\\\").replace('"', "\\\"")
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let outpath = args.get(1).cloned().unwrap_or_else(|| "-".to_string());
    let nthreads = std::thread::available_parallelism().map(|x| x.get()).unwrap_or(8);

    let mut j = String::new();
    j.push_str("{\n");
    j.push_str("  \"schema\": \"c756-split-fiber-census/1\",\n");
    j.push_str("  \"conventions\": {\n");
    j.push_str("    \"field\": \"F_{q^2} = F_q(s), s^2 = eps, eps = smallest nonsquare in F_q; element index a + b*q denotes a + b*s\",\n");
    j.push_str("    \"chi\": \"chi(u) = legendre(N(u), q), N(u) = a^2 - eps*b^2, chi(0) = 0\",\n");
    j.push_str("    \"nn\": \"(q+3)/2\", \"t\": \"(q+1)/2\",\n");
    j.push_str("    \"R\": \"monic degree nn, R(0)=0, coefficient list c[0..nn] with c[0]=0, c[nn]=1\",\n");
    j.push_str("    \"split_pair\": \"|R^{-1}(gamma)| = nn in F_{q^2}, gamma not in F_q\",\n");
    j.push_str("    \"group\": \"X -> aX+b: R -> a^{-nn}(R(aX+b)-R(b)), gamma -> a^{-nn}(gamma-R(b)); on roots Z -> {(z-b)/a}\"\n");
    j.push_str("  },\n");
    j.push_str("  \"exact_census\": [\n");

    // Optional overrides for smoke tests only; the certificate run uses the defaults.
    let census_qs: Vec<usize> = match std::env::var("C756_QS") {
        Ok(v) => v.split(',').map(|x| x.parse().unwrap()).collect(),
        Err(_) => vec![5usize, 7, 11, 13],
    };
    let nsamp: u64 = std::env::var("C756_SAMPLES")
        .ok()
        .and_then(|v| v.parse().ok())
        .unwrap_or(10_000_000);
    let mut first = true;
    for &q in census_qs.iter() {
        let f = Field::new(q);
        let nn = (q + 3) / 2;
        let t = (q + 1) / 2;
        let sign_t: i8 = if t % 2 == 0 { 1 } else { -1 };
        let t0 = std::time::Instant::now();
        let found = enumerate_split_pairs(&f, nn, nthreads);
        let elapsed = t0.elapsed().as_secs_f64();
        let raw = found.len();
        let npolys = pow_usize(q, nn - 1);
        // analysis
        let chunks: Vec<&[Found]> = found.chunks(1 + found.len() / nthreads.max(1)).collect();
        let results: Vec<(usize, usize, usize, usize, usize, usize, BTreeMap<usize, usize>, Vec<(Vec<u8>, u16, Vec<u16>)>, Vec<Vec<u16>>)> =
            thread::scope(|scope| {
                let mut handles = Vec::new();
                for ch in chunks.iter() {
                    let f = &f;
                    let ch = *ch;
                    handles.push(scope.spawn(move || {
                        let mut n1 = 0usize;
                        let mut n2o = 0usize;
                        let mut n12 = 0usize;
                        let mut n3 = 0usize;
                        let mut bad = 0usize;
                        let mut f4bad = 0usize;
                        let mut hist: BTreeMap<usize, usize> = BTreeMap::new();
                        let mut sols: Vec<(Vec<u8>, u16, Vec<u16>)> = Vec::new();
                        let mut zsets: Vec<Vec<u16>> = Vec::new();
                        for fo in ch {
                            let a = analyze(f, &fo.c, nn, fo.gamma, sign_t);
                            if !a.assert_ok {
                                bad += 1;
                                continue;
                            }
                            if !a.f4_agrees {
                                f4bad += 1;
                            }
                            if a.f2 {
                                n2o += 1;
                            }
                            if a.f1 {
                                n1 += 1;
                                if a.f2 {
                                    n12 += 1;
                                }
                            }
                            if a.f3 {
                                n3 += 1;
                                let mut cv = fo.c[0..=nn].to_vec();
                                cv[nn] = 1;
                                sols.push((cv, fo.gamma, a.z.clone()));
                            }
                            *hist.entry(a.coh_ordered).or_insert(0) += 1;
                            zsets.push(a.z);
                        }
                        (n1, n2o, n12, n3, bad, f4bad, hist, sols, zsets)
                    }));
                }
                handles.into_iter().map(|h| h.join().unwrap()).collect()
            });
        let mut n1 = 0;
        let mut n2o = 0;
        let mut n12 = 0;
        let mut n3 = 0;
        let mut bad = 0;
        let mut f4bad = 0;
        let mut hist: BTreeMap<usize, usize> = BTreeMap::new();
        let mut sols: Vec<(Vec<u8>, u16, Vec<u16>)> = Vec::new();
        let mut zsets: Vec<Vec<u16>> = Vec::new();
        for (a, a2, b, c, d, e, h, s, z) in results {
            n1 += a;
            n2o += a2;
            n12 += b;
            n3 += c;
            bad += d;
            f4bad += e;
            for (k, v) in h {
                *hist.entry(k).or_insert(0) += v;
            }
            sols.extend(s);
            zsets.extend(z);
        }
        let (norb, closed, ohist) = orbit_count(&f, &zsets, nn);
        let f3z: Vec<Vec<u16>> = sols.iter().map(|(_, _, z)| z.clone()).collect();
        let (norb3, closed3, _) = if f3z.is_empty() {
            (0, true, BTreeMap::new())
        } else {
            orbit_count(&f, &f3z, nn)
        };
        let brute = brute_count(&f, nn, nthreads);
        // heuristic
        let mut fact = 1f64;
        for i in 1..=nn {
            fact *= i as f64;
        }
        let heur = (npolys as f64) * ((q * q - q) as f64) / fact;
        // Refined heuristic: a split fibre's root set must be a conjugation-free,
        // rationality-free nn-subset of F_{q^2}; there are C((q^2-q)/2, nn) * 2^nn
        // of those, and each imposes nn-1 independent F_q-rationality conditions
        // on the coefficients of prod (X - z), each of probability 1/q.
        let hsz = (q * q - q) / 2;
        let mut refined = 1f64;
        for i in 0..nn {
            refined *= ((hsz - i) as f64) / ((i + 1) as f64);
        }
        refined *= (2f64).powi(nn as i32) / (npolys as f64);
        sols.sort_by(|x, y| (x.0.clone(), x.1).cmp(&(y.0.clone(), y.1)));

        if !first {
            j.push_str(",\n");
        }
        first = false;
        j.push_str(&format!("    {{\n      \"q\": {}, \"eps\": {}, \"nn\": {}, \"t\": {}, \"sign_t\": {},\n", q, f.eps, nn, t, sign_t));
        j.push_str(&format!("      \"num_monic_R\": {}, \"num_gamma\": {},\n", npolys, q * q - q));
        j.push_str(&format!("      \"raw_split_pairs\": {}, \"unordered_gamma_pairs\": {}, \"affine_orbits\": {}, \"orbit_action_closed\": {},\n", raw, raw / 2, norb, closed));
        j.push_str(&format!("      \"heuristic_count\": {:.4}, \"observed_over_heuristic\": {:.6}, \"heuristic_refined_count\": {:.4}, \"observed_over_refined\": {:.6},\n", heur, raw as f64 / heur, refined, raw as f64 / refined));
        j.push_str(&format!("      \"funnel\": {{\"split\": {}, \"F1\": {}, \"F2_alone\": {}, \"F1_F2\": {}, \"F3\": {}}},\n", raw, n1, n2o, n12, n3));
        j.push_str(&format!("      \"assertion_failures\": {}, \"f4_equivalence_failures\": {},\n", bad, f4bad));
        j.push_str(&format!("      \"f3_affine_orbits\": {}, \"f3_orbit_action_closed\": {},\n", norb3, closed3));
        j.push_str(&format!("      \"brute_force_recount\": {}, \"brute_force_agrees\": {},\n", brute, brute as usize == raw));
        j.push_str("      \"orbit_size_histogram\": {");
        let mut fo2 = true;
        for (k, v) in ohist.iter() {
            if !fo2 {
                j.push_str(", ");
            }
            fo2 = false;
            j.push_str(&format!("\"{}\": {}", k, v));
        }
        j.push_str("},\n");
        j.push_str(&format!("      \"max_ordered_pairs\": {},\n", nn * (nn - 1)));
        j.push_str("      \"coherence_histogram\": {");
        let mut fh = true;
        for (k, v) in hist.iter() {
            if !fh {
                j.push_str(", ");
            }
            fh = false;
            j.push_str(&format!("\"{}\": {}", k, v));
        }
        j.push_str("},\n");
        j.push_str("      \"f3_solutions\": [");
        for (i, (cv, g, z)) in sols.iter().enumerate() {
            if i > 0 {
                j.push_str(", ");
            }
            let zs: Vec<String> = z.iter().map(|&u| format!("\"{}\"", jesc(&f.fmt(u)))).collect();
            j.push_str(&format!(
                "{{\"R_coeffs_c0_to_cnn\": {:?}, \"gamma\": \"{}\", \"Z\": [{}]}}",
                cv,
                jesc(&f.fmt(*g)),
                zs.join(", ")
            ));
        }
        j.push_str("]");
        j.push_str("\n    }");
        let _ = elapsed;
        eprintln!(
            "q={} nn={} split={} brute={} orbits={} osz={:?} F1={} F1F2={} F3={} f3orb={} f4bad={} bad={} ({:.1}s)",
            q, nn, raw, brute, norb, ohist, n1, n12, n3, norb3, f4bad, bad, elapsed
        );
    }
    j.push_str("\n  ],\n");

    // ---- frame check at q = 5 ----
    {
        let f = Field::new(5);
        let nn = 4;
        let t = 3;
        let sign_t: i8 = -1;
        assert_eq!(f.eps, 2);
        let frames: [([u8; 20], (usize, usize)); 2] = [
            ({
                let mut a = [0u8; 20];
                a[1] = 2;
                a[2] = 4;
                a[3] = 3;
                a
            }, (2, 3)),
            ({
                let mut a = [0u8; 20];
                a[1] = 3;
                a[2] = 4;
                a[3] = 2;
                a
            }, (2, 2)),
        ];
        j.push_str("  \"frame_check_q5\": [\n");
        for (i, (c, (ga, gb))) in frames.iter().enumerate() {
            let g = (ga + gb * 5) as u16;
            let a = analyze(&f, c, nn, g, sign_t);
            let zs: Vec<String> = a.z.iter().map(|&u| format!("\"{}\"", f.fmt(u))).collect();
            if i > 0 {
                j.push_str(",\n");
            }
            j.push_str(&format!(
                "    {{\"R_coeffs_c0_to_cnn\": [0,{},{},{},1], \"gamma\": \"{}+{}s\", \"split\": {}, \"Z\": [{}], \"F1\": {}, \"F2\": {}, \"F3\": {}, \"F4_crown\": {}, \"F4_agrees_F3\": {}}}",
                c[1], c[2], c[3], ga, gb, a.assert_ok, zs.join(", "), a.f1, a.f2, a.f3, a.f4_crown, a.f4_agrees
            ));
            eprintln!(
                "frame {}: split={} F1={} F2={} F3={} crown={} Z={:?}",
                i, a.assert_ok, a.f1, a.f2, a.f3, a.f4_crown, zs
            );
        }
        j.push_str("\n  ],\n");
    }

    // ---- random sampling ----
    j.push_str("  \"sampling\": [\n");
    let samp = [(17usize, nsamp), (19, nsamp), (23, nsamp), (29, nsamp)];
    for (i, &(q, n)) in samp.iter().enumerate() {
        let f = Field::new(q);
        let nn = (q + 3) / 2;
        let t0 = std::time::Instant::now();
        let (hits, fibers) = sample_density(&f, nn, n, nthreads, 0xC756_0000 + q as u64);
        let el = t0.elapsed().as_secs_f64();
        let mut fact = 1f64;
        for k in 1..=nn {
            fact *= k as f64;
        }
        let heur = ((q * q - q) as f64) / fact;
        let hsz = (q * q - q) / 2;
        let mut refined = 1f64;
        for i in 0..nn {
            refined *= ((hsz - i) as f64) / ((i + 1) as f64);
        }
        let np = (q as f64).powi((nn - 1) as i32); // f64: q^(nn-1) overflows usize at q=29
        refined *= (2f64).powi(nn as i32) / (np * np);
        let (lo, hi) = wilson(hits as f64, n as f64);
        if i > 0 {
            j.push_str(",\n");
        }
        j.push_str(&format!(
            "    {{\"q\": {}, \"eps\": {}, \"nn\": {}, \"samples\": {}, \"seed\": {}, \"R_with_split_fiber\": {}, \"total_split_fibers\": {}, \"observed_rate\": {:.6e}, \"heuristic_rate\": {:.6e}, \"heuristic_refined_fiber_rate\": {:.6e}, \"observed_fiber_rate\": {:.6e}, \"wilson95\": [{:.6e}, {:.6e}]}}",
            q, f.eps, nn, n, 0xC756_0000u64 + q as u64, hits, fibers, hits as f64 / n as f64, heur, refined, fibers as f64 / n as f64, lo, hi
        ));
        eprintln!("sample q={} n={} hits={} fibers={} rate={:.3e} heur={:.3e} ({:.1}s)", q, n, hits, fibers, hits as f64 / n as f64, heur, el);
    }
    j.push_str("\n  ]\n}\n");

    if outpath == "-" {
        print!("{}", j);
    } else {
        std::fs::write(&outpath, j).expect("write json");
    }
}
