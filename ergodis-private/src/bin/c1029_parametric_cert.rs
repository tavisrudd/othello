//! C1029 — parametric certificate generator (Erdős–Straus vehicle).
//!
//! Instrument test: emit a *parametric* certificate — a finite set of polynomial identities that
//! discharges infinitely many cases — composed with a finite witness list for the residual cases,
//! together with a composition rule making the pair a complete claim over a stated range.
//!
//! This binary is self-contained: no `ergodis` or `ergodis-private` library dependency, no external
//! crates. It is built out of tree (see the report) because the `ergodis-private` library does not
//! currently compile.
//!
//! Certificate claim, for the emitted range `[2, N]`:
//!     for every integer n with 2 <= n <= N there are positive integers x, y, z with
//!     4/n = 1/x + 1/y + 1/z.
//!
//! Layers:
//!   * tier-1 identities: families (m, r, A, B, C) with A,B,C in Z[t], covering every residue
//!     class mod 840 except E = {1, 121, 169, 289, 361, 529}.
//!   * tier-2 identities: further families with arbitrary moduli, each removing some residual
//!     primes from the witness layer. They do not participate in the mod-840 covering argument.
//!   * witness layer: for every prime p <= N whose class mod 840 lies in E and which no tier-2
//!     family covers, an explicit triple recorded as (p, s, d).
//!
//! Nothing here is claimed as new mathematics: the tier-1 identities are classical (Mordell
//! school) and the certified range is far below the published 10^18 verification.

use std::collections::BTreeSet;
use std::fmt::Write as _;
use std::fs;
use std::path::PathBuf;

// ---------------------------------------------------------------------------------------------
// SHA-256 (self-contained; cross-checked against coreutils sha256sum in the replay script)
// ---------------------------------------------------------------------------------------------

const K256: [u32; 64] = [
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
];

fn sha256_hex(data: &[u8]) -> String {
    let mut h: [u32; 8] = [
        0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab,
        0x5be0cd19,
    ];
    let mut msg = data.to_vec();
    let bitlen = (data.len() as u64).wrapping_mul(8);
    msg.push(0x80);
    while msg.len() % 64 != 56 {
        msg.push(0);
    }
    msg.extend_from_slice(&bitlen.to_be_bytes());
    for chunk in msg.chunks(64) {
        let mut w = [0u32; 64];
        for i in 0..16 {
            w[i] = u32::from_be_bytes([
                chunk[4 * i],
                chunk[4 * i + 1],
                chunk[4 * i + 2],
                chunk[4 * i + 3],
            ]);
        }
        for i in 16..64 {
            let s0 = w[i - 15].rotate_right(7) ^ w[i - 15].rotate_right(18) ^ (w[i - 15] >> 3);
            let s1 = w[i - 2].rotate_right(17) ^ w[i - 2].rotate_right(19) ^ (w[i - 2] >> 10);
            w[i] = w[i - 16]
                .wrapping_add(s0)
                .wrapping_add(w[i - 7])
                .wrapping_add(s1);
        }
        let (mut a, mut b, mut c, mut d, mut e, mut f, mut g, mut hh) =
            (h[0], h[1], h[2], h[3], h[4], h[5], h[6], h[7]);
        for i in 0..64 {
            let s1 = e.rotate_right(6) ^ e.rotate_right(11) ^ e.rotate_right(25);
            let ch = (e & f) ^ ((!e) & g);
            let t1 = hh
                .wrapping_add(s1)
                .wrapping_add(ch)
                .wrapping_add(K256[i])
                .wrapping_add(w[i]);
            let s0 = a.rotate_right(2) ^ a.rotate_right(13) ^ a.rotate_right(22);
            let maj = (a & b) ^ (a & c) ^ (b & c);
            let t2 = s0.wrapping_add(maj);
            hh = g;
            g = f;
            f = e;
            e = d.wrapping_add(t1);
            d = c;
            c = b;
            b = a;
            a = t1.wrapping_add(t2);
        }
        for (i, v) in [a, b, c, d, e, f, g, hh].iter().enumerate() {
            h[i] = h[i].wrapping_add(*v);
        }
    }
    h.iter().map(|x| format!("{x:08x}")).collect()
}

// ---------------------------------------------------------------------------------------------
// exact integer polynomial arithmetic (coefficients low-to-high, i128, checked)
// ---------------------------------------------------------------------------------------------

#[derive(Clone, Debug, PartialEq, Eq)]
struct Poly(Vec<i128>);

impl Poly {
    fn zero() -> Self {
        Poly(vec![])
    }
    fn constant(c: i128) -> Self {
        if c == 0 {
            Poly::zero()
        } else {
            Poly(vec![c])
        }
    }
    /// a + b*t
    fn linear(a: i128, b: i128) -> Self {
        Poly(vec![a, b]).trimmed()
    }
    fn trimmed(mut self) -> Self {
        while self.0.last() == Some(&0) {
            self.0.pop();
        }
        self
    }
    fn is_zero(&self) -> bool {
        self.0.iter().all(|&c| c == 0)
    }
    fn degree(&self) -> isize {
        let t = self.clone().trimmed();
        if t.0.is_empty() {
            -1
        } else {
            t.0.len() as isize - 1
        }
    }
    fn coeff(&self, i: usize) -> i128 {
        *self.0.get(i).unwrap_or(&0)
    }
    fn add(&self, other: &Poly) -> Option<Poly> {
        let n = self.0.len().max(other.0.len());
        let mut out = Vec::with_capacity(n);
        for i in 0..n {
            out.push(self.coeff(i).checked_add(other.coeff(i))?);
        }
        Some(Poly(out).trimmed())
    }
    fn sub(&self, other: &Poly) -> Option<Poly> {
        let n = self.0.len().max(other.0.len());
        let mut out = Vec::with_capacity(n);
        for i in 0..n {
            out.push(self.coeff(i).checked_sub(other.coeff(i))?);
        }
        Some(Poly(out).trimmed())
    }
    fn mul(&self, other: &Poly) -> Option<Poly> {
        if self.is_zero() || other.is_zero() {
            return Some(Poly::zero());
        }
        let mut out = vec![0i128; self.0.len() + other.0.len() - 1];
        for (i, &a) in self.0.iter().enumerate() {
            if a == 0 {
                continue;
            }
            for (j, &b) in other.0.iter().enumerate() {
                let p = a.checked_mul(b)?;
                out[i + j] = out[i + j].checked_add(p)?;
            }
        }
        Some(Poly(out).trimmed())
    }
    fn mul_int(&self, k: i128) -> Option<Poly> {
        let mut out = Vec::with_capacity(self.0.len());
        for &c in &self.0 {
            out.push(c.checked_mul(k)?);
        }
        Some(Poly(out).trimmed())
    }
    /// exact division by a nonzero integer; None if any coefficient fails to divide
    fn div_int_exact(&self, k: i128) -> Option<Poly> {
        if k == 0 {
            return None;
        }
        let mut out = Vec::with_capacity(self.0.len());
        for &c in &self.0 {
            if c % k != 0 {
                return None;
            }
            out.push(c / k);
        }
        Some(Poly(out).trimmed())
    }
    /// exact polynomial division; None if the quotient is not in Z[t] or the remainder is nonzero
    fn div_poly_exact(&self, d: &Poly) -> Option<Poly> {
        let d = d.clone().trimmed();
        if d.is_zero() {
            return None;
        }
        let mut rem = self.clone().trimmed();
        let ddeg = d.degree();
        let dlead = d.coeff(ddeg as usize);
        let mut quot = vec![0i128; ((self.degree() - ddeg).max(-1) + 1).max(0) as usize];
        while !rem.is_zero() && rem.degree() >= ddeg {
            let rdeg = rem.degree();
            let rlead = rem.coeff(rdeg as usize);
            if rlead % dlead != 0 {
                return None;
            }
            let q = rlead / dlead;
            let shift = (rdeg - ddeg) as usize;
            if shift >= quot.len() {
                return None;
            }
            quot[shift] = q;
            let mut sub = vec![0i128; shift];
            for &c in &d.0 {
                sub.push(c.checked_mul(q)?);
            }
            rem = rem.sub(&Poly(sub))?;
        }
        if !rem.is_zero() {
            return None;
        }
        Some(Poly(quot).trimmed())
    }
    fn all_nonneg(&self) -> bool {
        self.0.iter().all(|&c| c >= 0)
    }
    fn eval(&self, t: i128) -> Option<i128> {
        let mut acc = 0i128;
        for &c in self.0.iter().rev() {
            acc = acc.checked_mul(t)?.checked_add(c)?;
        }
        Some(acc)
    }
    fn render(&self) -> String {
        let t = self.clone().trimmed();
        if t.0.is_empty() {
            return "0".to_string();
        }
        let mut s = String::new();
        for (i, c) in t.0.iter().enumerate() {
            if i > 0 {
                s.push(' ');
            }
            let _ = write!(s, "{c}");
        }
        s
    }
}

// ---------------------------------------------------------------------------------------------
// identity families
// ---------------------------------------------------------------------------------------------

#[derive(Clone, Debug)]
struct Family {
    name: String,
    m: i128,
    r: i128,
    tmin: i128,
    a: Poly,
    b: Poly,
    c: Poly,
}

impl Family {
    fn n_poly(&self) -> Poly {
        Poly::linear(self.r, self.m)
    }
    /// n*(B*C + A*C + A*B) - 4*A*B*C == 0 in Z[t]
    fn identity_holds(&self) -> bool {
        let (a, b, c) = (&self.a, &self.b, &self.c);
        let Some(bc) = b.mul(c) else { return false };
        let Some(ac) = a.mul(c) else { return false };
        let Some(ab) = a.mul(b) else { return false };
        let Some(s1) = bc.add(&ac).and_then(|p| p.add(&ab)) else {
            return false;
        };
        let Some(lhs) = self.n_poly().mul(&s1) else {
            return false;
        };
        let Some(abc) = ab.mul(c) else { return false };
        let Some(rhs) = abc.mul_int(4) else { return false };
        match lhs.sub(&rhs) {
            Some(d) => d.is_zero(),
            None => false,
        }
    }
    /// nonneg coefficients + value >= 1 at tmin  =>  >= 1 for every t >= tmin
    fn positivity_holds(&self) -> bool {
        for p in [&self.a, &self.b, &self.c] {
            if !p.all_nonneg() {
                return false;
            }
            match p.eval(self.tmin) {
                Some(v) if v >= 1 => {}
                _ => return false,
            }
        }
        true
    }
    /// every integer n >= 2 in the class has t >= tmin
    fn reach_holds(&self) -> bool {
        let n_min = if self.r >= 2 { self.r } else { self.r + self.m };
        (n_min - self.r) / self.m >= self.tmin
    }
    fn valid(&self) -> bool {
        self.m >= 1
            && self.r >= 0
            && self.r < self.m
            && self.identity_holds()
            && self.positivity_holds()
            && self.reach_holds()
    }
}

/// shape 1: n = k*t with a known solution 4/k = 1/a + 1/b + 1/c
fn family_scale(name: &str, k: i128, abc: [i128; 3]) -> Family {
    Family {
        name: name.to_string(),
        m: k,
        r: 0,
        tmin: 1,
        a: Poly::linear(0, abc[0]),
        b: Poly::linear(0, abc[1]),
        c: Poly::linear(0, abc[2]),
    }
}

/// how the auxiliary divisor d is built out of the class data
#[derive(Clone, Copy, Debug)]
enum DShape {
    Const(i128),
    TimesN(i128),
    TimesX(i128),
    M,
}

/// shape 2: x = (n+s)/4, M = n*x, y = (M+d)/s, z = M*(M+d)/(s*d).
/// The rational identity 1/x + 1/y + 1/z = 4/n is automatic; the content is integrality.
fn family_recipe(name: &str, m: i128, r: i128, s: i128, dshape: DShape) -> Option<Family> {
    if s <= 0 || m <= 0 || r < 0 || r >= m {
        return None;
    }
    let n = Poly::linear(r, m);
    let x = n.add(&Poly::constant(s))?.div_int_exact(4)?;
    let big_m = n.mul(&x)?;
    let d = match dshape {
        DShape::Const(k) => Poly::constant(k),
        DShape::TimesN(k) => n.mul_int(k)?,
        DShape::TimesX(k) => x.mul_int(k)?,
        DShape::M => big_m.clone(),
    };
    if d.is_zero() {
        return None;
    }
    let md = big_m.add(&d)?;
    let y = md.div_int_exact(s)?;
    let sd = d.mul_int(s)?;
    let z = big_m.mul(&md)?.div_poly_exact(&sd)?;
    let tmin = if r >= 2 { 0 } else { 1 };
    let fam = Family {
        name: name.to_string(),
        m,
        r,
        tmin,
        a: x,
        b: y,
        c: z,
    };
    if fam.valid() {
        Some(fam)
    } else {
        None
    }
}

/// The tier-1 covering layer: twelve families covering all residues mod 840 except
/// {1, 121, 169, 289, 361, 529}.
fn tier1_families() -> Vec<Family> {
    let mut out = Vec::new();
    // divisibility families: 4/2 = 1/1+1/2+1/2, 4/3 = 1/1+1/6+1/6,
    //                        4/5 = 1/2+1/4+1/20,  4/7 = 1/2+1/28+1/28
    out.push(family_scale("even", 2, [1, 2, 2]));
    out.push(family_scale("div3", 3, [1, 6, 6]));
    out.push(family_scale("div5", 5, [2, 4, 20]));
    out.push(family_scale("div7", 7, [2, 28, 28]));
    // n = 3 (mod 4): x = (n+1)/4, s = 1, d = M  ->  y = z = 2M
    out.push(family_recipe("n3mod4", 4, 3, 1, DShape::M).expect("n3mod4"));
    // n = 2 (mod 3): 4/n = 1/n + 1/((n+1)/3) + 1/(n(n+1)/3); not of the (s,d) shape
    out.push(Family {
        name: "n2mod3".to_string(),
        m: 3,
        r: 2,
        tmin: 0,
        a: Poly::linear(1, 1),          // (n+1)/3 = t+1
        b: Poly::linear(2, 3),          // n
        c: Poly(vec![2, 5, 3]),         // n(n+1)/3 = (3t+2)(t+1)
    });
    // n = 13 (mod 24): s = 3, d = 2
    out.push(family_recipe("n13mod24", 24, 13, 3, DShape::Const(2)).expect("n13mod24"));
    // n = 1 (mod 24) and n = 3, 6, 5 (mod 7): s = 7 with d = n, x, 2x
    out.push(family_recipe("n73mod168", 168, 73, 7, DShape::TimesN(1)).expect("n73mod168"));
    out.push(family_recipe("n97mod168", 168, 97, 7, DShape::TimesX(1)).expect("n97mod168"));
    out.push(family_recipe("n145mod168", 168, 145, 7, DShape::TimesX(2)).expect("n145mod168"));
    // n = 1 (mod 24) and n = 2, 3 (mod 5): s = 15 with d = 2n, 2x
    out.push(family_recipe("n97mod120", 120, 97, 15, DShape::TimesN(2)).expect("n97mod120"));
    out.push(family_recipe("n73mod120", 120, 73, 15, DShape::TimesX(2)).expect("n73mod120"));
    out
}

const COVER_MODULUS: i128 = 840;
const EXCEPTIONAL: [i128; 6] = [1, 121, 169, 289, 361, 529];

/// residues mod 840 not covered by any tier-1 family
fn uncovered_mod840(fams: &[Family]) -> Vec<i128> {
    let mut out = Vec::new();
    'outer: for a in 0..COVER_MODULUS {
        for f in fams {
            if COVER_MODULUS % f.m == 0 && a % f.m == f.r {
                continue 'outer;
            }
        }
        out.push(a);
    }
    out
}

// ---------------------------------------------------------------------------------------------
// tier-2 ladder: auto-generated families with arbitrary moduli
// ---------------------------------------------------------------------------------------------

fn gcd(a: i128, b: i128) -> i128 {
    if b == 0 {
        a.abs()
    } else {
        gcd(b, a % b)
    }
}
fn lcm(a: i128, b: i128) -> i128 {
    a / gcd(a, b) * b
}

/// Enumerate candidate (s, d-shape) families over classes with modulus lcm(4*c*s, 24).
fn tier2_candidates(s_max: i128, c_max: i128) -> Vec<Family> {
    let mut out = Vec::new();
    let mut seen: BTreeSet<(i128, i128)> = BTreeSet::new();
    let mut s = 3;
    while s <= s_max {
        for c in 1..=c_max {
            for shape in [DShape::Const(c), DShape::TimesN(c), DShape::TimesX(c)] {
                let m = lcm(4 * c * s, 24);
                if m > 200_000 {
                    continue;
                }
                for r in 0..m {
                    // only classes that can contain a residual prime are useful
                    if r % 24 != 1 || gcd(r, m) != 1 {
                        continue;
                    }
                    let name = format!("L_s{s}_{}{c}_r{r}m{m}", shape_tag(shape));
                    if let Some(f) = family_recipe(&name, m, r, s, shape) {
                        if seen.insert((f.m, f.r)) {
                            out.push(f);
                        }
                    }
                }
            }
        }
        s += 4;
    }
    out
}

fn shape_tag(s: DShape) -> &'static str {
    match s {
        DShape::Const(_) => "k",
        DShape::TimesN(_) => "n",
        DShape::TimesX(_) => "x",
        DShape::M => "M",
    }
}

// ---------------------------------------------------------------------------------------------
// sieve + witness search
// ---------------------------------------------------------------------------------------------

fn simple_sieve(limit: usize) -> Vec<u64> {
    let mut is_c = vec![false; limit + 1];
    let mut out = Vec::new();
    let mut i = 2usize;
    while i <= limit {
        if !is_c[i] {
            out.push(i as u64);
            let mut j = i * i;
            while j <= limit {
                is_c[j] = true;
                j += i;
            }
        }
        i += 1;
    }
    out
}

/// primes p <= n_max with p mod 840 in EXCEPTIONAL, via a segmented sieve
fn residual_primes(n_max: u64) -> Vec<u64> {
    let root = (n_max as f64).sqrt() as usize + 2;
    let base = simple_sieve(root);
    let exc: BTreeSet<u64> = EXCEPTIONAL.iter().map(|&e| e as u64).collect();
    let seg = 1 << 20;
    let mut out = Vec::new();
    let mut lo = 2u64;
    let mut mark = vec![false; seg];
    while lo <= n_max {
        let hi = (lo + seg as u64 - 1).min(n_max);
        let len = (hi - lo + 1) as usize;
        mark[..len].iter_mut().for_each(|b| *b = false);
        for &p in &base {
            if p * p > hi {
                break;
            }
            let mut start = ((lo + p - 1) / p) * p;
            if start < p * p {
                start = p * p;
            }
            let mut j = start;
            while j <= hi {
                mark[(j - lo) as usize] = true;
                j += p;
            }
        }
        for i in 0..len {
            if !mark[i] {
                let n = lo + i as u64;
                if n >= 2 && exc.contains(&(n % 840)) {
                    out.push(n);
                }
            }
        }
        lo = hi + 1;
    }
    out
}

/// factor x by trial division over `base` (must contain all primes <= sqrt(x))
fn factor(mut x: u64, base: &[u64]) -> Vec<(u64, u32)> {
    let mut fac: Vec<(u64, u32)> = Vec::new();
    for &p in base {
        if p * p > x {
            break;
        }
        if x % p == 0 {
            let mut e = 0;
            while x % p == 0 {
                x /= p;
                e += 1;
            }
            fac.push((p, e));
        }
    }
    if x > 1 {
        fac.push((x, 1));
    }
    fac
}

fn divisors_from(fac: &[(u64, u32)], mult: u32) -> Vec<u128> {
    let mut divs = vec![1u128];
    for &(p, e) in fac {
        let cur = divs.clone();
        let mut pk = 1u128;
        for _ in 0..(e * mult) {
            pk *= p as u128;
            for &d in &cur {
                divs.push(d * pk);
            }
        }
    }
    divs.sort_unstable();
    divs
}

/// Find (s, d) with x = (p+s)/4, M = p*x, d | M^2, s | (M+d), s | (M + M^2/d).
/// Then y = (M+d)/s and z = (M + M^2/d)/s are positive integers with 1/x + 1/y + 1/z = 4/p,
/// because (s*y - M)(s*z - M) = M^2 is exactly the condition 1/y + 1/z = s/M, and
/// 4/p - 1/x = s/(p*x) = s/M by construction.
/// `depth` = 1 restricts d to divisors of M (fast path); `depth` = 2 allows all of M^2.
fn find_witness(p: u64, base: &[u64], s_max: u64, depth: u32) -> Option<(u64, u128)> {
    // p is 1 mod 24 here, so 4 | p + s requires s = 3 (mod 4)
    let mut s = 3u64;
    while s <= s_max {
        if (p + s) % 4 != 0 {
            s += 4;
            continue;
        }
        let x = (p + s) / 4;
        let big_m = p as u128 * x as u128;
        let sm = s as u128;
        let mrem = big_m % sm;
        let fac = factor(x, base);
        let divs = divisors_from(&fac, depth);
        let m2 = big_m * big_m;
        let mut best: Option<u128> = None;
        let pmax = if depth == 1 { 1 } else { 2 };
        for &e in &divs {
            let mut pk = 1u128;
            for _ in 0..=pmax {
                let d = e * pk;
                pk *= p as u128;
                if d == 0 || m2 % d != 0 {
                    continue;
                }
                if (mrem + d % sm) % sm != 0 {
                    continue;
                }
                let co = m2 / d;
                if (big_m + co) % sm != 0 {
                    continue;
                }
                if best.map_or(true, |b| d < b) {
                    best = Some(d);
                }
            }
        }
        if let Some(d) = best {
            return Some((s, d));
        }
        s += 4;
    }
    None
}

// ---------------------------------------------------------------------------------------------
// driver
// ---------------------------------------------------------------------------------------------

fn arg_val(args: &[String], key: &str, default: &str) -> String {
    for w in args.windows(2) {
        if w[0] == key {
            return w[1].clone();
        }
    }
    default.to_string()
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let n_max: u64 = arg_val(&args, "--n-max", "10000000").parse().expect("n-max");
    let out_dir = PathBuf::from(arg_val(
        &args,
        "--out-dir",
        &format!("{}/.cache/ergodis/c1029", std::env::var("HOME").unwrap()),
    ));
    let ladder_top: usize = arg_val(&args, "--ladder-top", "0").parse().expect("ladder-top");
    let s_max_ladder: i128 = arg_val(&args, "--ladder-s-max", "31").parse().expect("s-max");
    let c_max_ladder: i128 = arg_val(&args, "--ladder-c-max", "12").parse().expect("c-max");
    let witness_s_max: u64 = arg_val(&args, "--witness-s-max", "4001").parse().expect("ws");
    let ladder_fit_max: u64 = arg_val(&args, "--ladder-fit-max", "0").parse().expect("fit-max");
    let tag = arg_val(&args, "--tag", "run");
    fs::create_dir_all(&out_dir).expect("out dir");

    // ---- tier 1 ----
    let t1 = tier1_families();
    for f in &t1 {
        assert!(f.valid(), "tier-1 family {} failed self-check", f.name);
    }
    let unc = uncovered_mod840(&t1);
    assert_eq!(
        unc,
        EXCEPTIONAL.to_vec(),
        "tier-1 covering does not leave exactly the expected exceptional set"
    );
    eprintln!("tier-1: {} families, uncovered mod 840 = {:?}", t1.len(), unc);

    // ---- residual primes ----
    let t_sieve = std::time::Instant::now();
    let resid = residual_primes(n_max);
    eprintln!(
        "residual primes <= {n_max}: {} ({:.1}s)",
        resid.len(),
        t_sieve.elapsed().as_secs_f64()
    );

    // ---- tier 2 ladder (greedy selection on residual coverage) ----
    let mut t2: Vec<Family> = Vec::new();
    if ladder_top > 0 {
        let cands = tier2_candidates(s_max_ladder, c_max_ladder);
        eprintln!("tier-2 candidates: {}", cands.len());
        // bucket residual-prime indices by residue, once per distinct modulus
        let moduli: BTreeSet<i128> = cands.iter().map(|f| f.m).collect();
        let mut buckets: std::collections::HashMap<i128, Vec<Vec<usize>>> =
            std::collections::HashMap::new();
        for &m in &moduli {
            let mu = m as u64;
            let mut b = vec![Vec::new(); m as usize];
            for (k, &p) in resid.iter().enumerate() {
                b[(p % mu) as usize].push(k);
            }
            buckets.insert(m, b);
        }
        // Greedy selection may be fitted on a prefix of the residual primes, so that the ladder's
        // absorption can be measured on the unseen remainder (a holdout against overfitting).
        let fit_len = if ladder_fit_max == 0 || ladder_fit_max >= n_max {
            resid.len()
        } else {
            resid.partition_point(|&p| p <= ladder_fit_max)
        };
        let mut open: Vec<bool> = vec![true; resid.len()];
        for k in fit_len..resid.len() {
            open[k] = false; // outside the fitting window: invisible to the greedy score
        }
        let mut n_open = fit_len;
        let mut used: BTreeSet<(i128, i128)> = BTreeSet::new();
        for _ in 0..ladder_top {
            let mut best: Option<(usize, usize)> = None; // (gain, index)
            for (i, f) in cands.iter().enumerate() {
                if used.contains(&(f.m, f.r)) {
                    continue;
                }
                let bucket = &buckets[&f.m][f.r as usize];
                let gain = bucket.iter().filter(|&&k| open[k]).count();
                if gain > best.map_or(0, |b| b.0) {
                    best = Some((gain, i));
                }
            }
            let Some((gain, idx)) = best else { break };
            if gain == 0 {
                break;
            }
            let f = cands[idx].clone();
            for &k in &buckets[&f.m][f.r as usize] {
                if open[k] {
                    open[k] = false;
                    n_open -= 1;
                }
            }
            used.insert((f.m, f.r));
            eprintln!(
                "  ladder + mod {} = {} (s-shape {}) gain {} -> open {}",
                f.m, f.r, f.name, gain, n_open
            );
            t2.push(f);
        }
        let covered = |p: u64| t2.iter().any(|f| p % (f.m as u64) == f.r as u64);
        let fit_abs = resid[..fit_len].iter().filter(|&&p| covered(p)).count();
        let hold_abs = resid[fit_len..].iter().filter(|&&p| covered(p)).count();
        let hold_n = resid.len() - fit_len;
        eprintln!(
            "ladder absorption: fit {}/{} = {:.5}, holdout {}/{} = {:.5}",
            fit_abs,
            fit_len,
            fit_abs as f64 / fit_len.max(1) as f64,
            hold_abs,
            hold_n,
            hold_abs as f64 / hold_n.max(1) as f64
        );
    }
    for f in &t2 {
        assert!(f.valid(), "tier-2 family {} failed self-check", f.name);
    }

    // ---- witnesses for what the ladder does not absorb ----
    let root = ((n_max as f64).sqrt() as usize) + 2;
    let base = simple_sieve(root);
    let t_wit = std::time::Instant::now();
    let mut witnesses: Vec<(u64, u64, u128)> = Vec::new();
    let mut ladder_absorbed = 0usize;
    let mut failures: Vec<u64> = Vec::new();
    for &p in &resid {
        if t2
            .iter()
            .any(|f| p % (f.m as u64) == f.r as u64)
        {
            ladder_absorbed += 1;
            continue;
        }
        match find_witness(p, &base, witness_s_max, 1)
            .or_else(|| find_witness(p, &base, witness_s_max, 2))
        {
            Some((s, d)) => witnesses.push((p, s, d)),
            None => failures.push(p),
        }
    }
    eprintln!(
        "witnesses: {} found, {} absorbed by ladder, {} FAILURES ({:.1}s)",
        witnesses.len(),
        ladder_absorbed,
        failures.len(),
        t_wit.elapsed().as_secs_f64()
    );
    assert!(failures.is_empty(), "witness search failed for {:?}", &failures[..failures.len().min(8)]);

    // ---- emit ----
    let wit_name = format!("c1029-witnesses-{tag}.txt");
    let mut wbuf = String::new();
    for (p, s, d) in &witnesses {
        let _ = writeln!(wbuf, "{p} {s} {d}");
    }
    let wit_path = out_dir.join(&wit_name);
    fs::write(&wit_path, &wbuf).expect("witness file");

    let mut cbuf = String::new();
    let _ = writeln!(cbuf, "# c1029 Erdos-Straus parametric certificate");
    let _ = writeln!(cbuf, "format c1029-parametric/1");
    let _ = writeln!(
        cbuf,
        "claim for every integer n with range_lo <= n <= range_hi there exist positive integers x,y,z with 4/n = 1/x + 1/y + 1/z"
    );
    let _ = writeln!(cbuf, "range_lo 2");
    let _ = writeln!(cbuf, "range_hi {n_max}");
    let _ = writeln!(cbuf, "cover_modulus {COVER_MODULUS}");
    let _ = write!(cbuf, "exceptional");
    for e in EXCEPTIONAL {
        let _ = write!(cbuf, " {e}");
    }
    let _ = writeln!(cbuf);
    let _ = writeln!(cbuf, "# family <tier> <name> <m> <r> <tmin>, then A/B/C coefficient rows (low-to-high in t, n = m*t + r)");
    let _ = writeln!(cbuf, "tier1_families {}", t1.len());
    let _ = writeln!(cbuf, "tier2_families {}", t2.len());
    for (tier, fams) in [(1u8, &t1), (2u8, &t2)] {
        for f in fams {
            let _ = writeln!(cbuf, "family {tier} {} {} {} {}", f.name, f.m, f.r, f.tmin);
            let _ = writeln!(cbuf, "A {}", f.a.render());
            let _ = writeln!(cbuf, "B {}", f.b.render());
            let _ = writeln!(cbuf, "C {}", f.c.render());
        }
    }
    let _ = writeln!(cbuf, "witness_file {wit_name}");
    let _ = writeln!(cbuf, "witness_sha256 {}", sha256_hex(wbuf.as_bytes()));
    let _ = writeln!(cbuf, "witness_count {}", witnesses.len());
    let _ = writeln!(cbuf, "residual_primes {}", resid.len());
    let _ = writeln!(cbuf, "ladder_absorbed {ladder_absorbed}");
    let _ = writeln!(cbuf, "end");
    let cert_path = out_dir.join(format!("c1029-cert-{tag}.txt"));
    fs::write(&cert_path, &cbuf).expect("cert file");

    println!("cert     {}", cert_path.display());
    println!("witness  {}", wit_path.display());
    println!("residual {} witnesses {} absorbed {}", resid.len(), witnesses.len(), ladder_absorbed);
}
