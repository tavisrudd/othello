// Standalone solver for the impartial SUM-FREE game on Z_n (Game 1).
//
//   Position = sum-free set A subset Z_n  (A cap (A+A) = empty, a=b allowed).
//   Move     = add x notin A keeping A u {x} sum-free.  Normal play.
//   G(n)     = Grundy value of the EMPTY set.
//
// Speed lever: the multiplier group {x -> u*x : gcd(u,n)=1} preserves
// sum-freeness => Grundy-preserving symmetry. Memoize on the canonical form
// = lexicographically-minimum bitmask over the multiplier orbit.
//
// Build:  rustc -O -C opt-level=3 -C target-cpu=native -C link-arg=-fuse-ld=mold sumfree.rs -o sumfree
// Run:    ./sumfree <nmax>

use std::env;
use std::time::Instant;

// -------------------- custom open-addressing memo: u128 -> u8 --------------------
const EMPTY: u8 = 0xFF;

struct Table {
    keys: Vec<u128>,
    vals: Vec<u8>,
    mask: usize, // capacity-1, capacity is a power of two
    len: usize,
}

impl Table {
    fn new(cap_pow2: u32) -> Self {
        let cap = 1usize << cap_pow2;
        Table { keys: vec![0u128; cap], vals: vec![EMPTY; cap], mask: cap - 1, len: 0 }
    }
    #[inline(always)]
    fn hash(k: u128) -> u64 {
        let lo = k as u64;
        let hi = (k >> 64) as u64;
        let mut h = lo.wrapping_mul(0x9E37_79B9_7F4A_7C15);
        h ^= hi.wrapping_mul(0xC2B2_AE3D_27D4_EB4F);
        h ^= h >> 29;
        h = h.wrapping_mul(0xBF58_476D_1CE4_E5B9);
        h ^= h >> 32;
        h
    }
    #[inline(always)]
    fn get(&self, k: u128) -> Option<u8> {
        let mut i = (Self::hash(k) as usize) & self.mask;
        loop {
            let v = unsafe { *self.vals.get_unchecked(i) };
            if v == EMPTY {
                return None;
            }
            if unsafe { *self.keys.get_unchecked(i) } == k {
                return Some(v);
            }
            i = (i + 1) & self.mask;
        }
    }
    #[inline(always)]
    fn insert(&mut self, k: u128, val: u8) {
        if (self.len + 1) * 10 >= (self.mask + 1) * 7 {
            self.grow();
        }
        let mut i = (Self::hash(k) as usize) & self.mask;
        loop {
            let v = unsafe { *self.vals.get_unchecked(i) };
            if v == EMPTY {
                self.keys[i] = k;
                self.vals[i] = val;
                self.len += 1;
                return;
            }
            if self.keys[i] == k {
                self.vals[i] = val;
                return;
            }
            i = (i + 1) & self.mask;
        }
    }
    fn grow(&mut self) {
        let newcap = (self.mask + 1) * 2;
        let mut nk = vec![0u128; newcap];
        let mut nv = vec![EMPTY; newcap];
        let nmask = newcap - 1;
        for idx in 0..=self.mask {
            if self.vals[idx] != EMPTY {
                let k = self.keys[idx];
                let mut i = (Self::hash(k) as usize) & nmask;
                loop {
                    if nv[i] == EMPTY {
                        nk[i] = k;
                        nv[i] = self.vals[idx];
                        break;
                    }
                    i = (i + 1) & nmask;
                }
            }
        }
        self.keys = nk;
        self.vals = nv;
        self.mask = nmask;
    }
}

// -------------------- core --------------------
fn gcd(a: usize, b: usize) -> usize {
    if b == 0 {
        a
    } else {
        gcd(b, a % b)
    }
}

// cyclic left rotation of an n-bit mask by s (element i -> i+s mod n)
#[inline(always)]
fn crot(a: u128, s: usize, n: usize, full: u128) -> u128 {
    if s == 0 {
        a
    } else {
        ((a << s) | (a >> (n - s))) & full
    }
}

// lex-min bitmask over the multiplier orbit
#[inline(always)]
fn canon(a: u128, perms: &[[u8; 128]]) -> u128 {
    let mut best = a;
    for p in perms {
        let mut b: u128 = 0;
        let mut x = a;
        while x != 0 {
            let i = x.trailing_zeros() as usize;
            x &= x - 1;
            b |= 1u128 << p[i];
        }
        if b < best {
            best = b;
        }
    }
    best
}

fn grundy(
    a: u128,
    n: usize,
    full: u128,
    perms: &[[u8; 128]],
    half: &[u128],
    table: &mut Table,
) -> u8 {
    if let Some(v) = table.get(a) {
        return v;
    }
    // A+A, A-A, and the "2x in A" preimage set, all in one pass over A's bits
    let mut apa: u128 = 0;
    let mut ama: u128 = 0;
    let mut dpre: u128 = 0;
    let mut x = a;
    while x != 0 {
        let b = x.trailing_zeros() as usize;
        x &= x - 1;
        apa |= crot(a, b, n, full);
        ama |= crot(a, n - b, n, full);
        dpre |= unsafe { *half.get_unchecked(b) };
    }
    // addable x: in 1..n-1, not in A, A+A, A-A, and 2x not in A
    let mut addmask = full & !a & !apa & !ama & !dpre;
    addmask &= !1u128; // exclude x = 0

    let mut seen: u64 = 0;
    let mut y = addmask;
    while y != 0 {
        let p = y.trailing_zeros() as usize;
        y &= y - 1;
        let child = a | (1u128 << p);
        let cc = canon(child, perms);
        let gv = grundy(cc, n, full, perms, half, table);
        if gv < 64 {
            seen |= 1u64 << gv;
        }
    }
    let mex = (!seen).trailing_zeros() as u8;
    table.insert(a, mex);
    mex
}

fn sumfree(n: usize) -> (u8, usize, f64) {
    let start = Instant::now();
    let full: u128 = if n >= 128 { u128::MAX } else { (1u128 << n) - 1 };

    // multiplier units, and the bit-permutations for each unit != 1
    let mut perms: Vec<[u8; 128]> = Vec::new();
    for u in 2..n {
        if gcd(u, n) == 1 {
            let mut p = [0u8; 128];
            for i in 0..n {
                p[i] = ((u * i) % n) as u8;
            }
            perms.push(p);
        }
    }
    // half[r] = { x in 0..n : 2x mod n == r } as a bitmask
    let mut half = vec![0u128; n.max(1)];
    for xx in 0..n {
        let r = (2 * xx) % n;
        half[r] |= 1u128 << xx;
    }

    let mut table = Table::new(12);
    let val = grundy(0u128, n, full, &perms, &half, &mut table);
    let elapsed = start.elapsed().as_secs_f64();
    (val, table.len, elapsed)
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let nmax: usize = args.get(1).and_then(|s| s.parse().ok()).unwrap_or(46);

    // validation gate: n = 1..44 must match exactly
    const GATE: [u8; 44] = [
        0, 1, 1, 2, 0, 0, 0, 2, 1, 1, 0, 0, 0, 2, 2, 3, 0, 0, 0, 2, 1, 3, 0, 0, 0, 2, 1, 2, 0, 0,
        0, 3, 1, 1, 0, 0, 0, 1, 1, 2, 0, 0, 0, 2,
    ];

    println!("Sum-free game on Z_n: Grundy(empty), multiplier-quotient solver");
    println!("{:>4}  {:>3}  {:>14}  {:>10}  {:>6}  {}", "n", "G", "memo", "sec", "mod6", "law");
    let mut seq: Vec<u8> = Vec::new();
    let mut gate_ok = true;
    let mut law_breaks: Vec<usize> = Vec::new();
    for n in 1..=nmax {
        let (g, memo, secs) = sumfree(n);
        seq.push(g);
        let law_p = matches!(n % 6, 0 | 1 | 5); // conjecture: G==0 iff n mod6 in {0,1,5}
        let obs_p = g == 0;
        let flag = if law_p == obs_p {
            ""
        } else {
            law_breaks.push(n);
            "  <<< LAW BREAKS"
        };
        if n <= 44 && g != GATE[n - 1] {
            gate_ok = false;
            println!(
                "{:>4}  {:>3}  {:>14}  {:>10.3}  {:>6}  {} *** GATE MISMATCH expected {}",
                n, g, memo, secs, n % 6, flag, GATE[n - 1]
            );
            println!("VALIDATION FAILED at n={} -- stopping.", n);
            return;
        }
        println!(
            "{:>4}  {:>3}  {:>14}  {:>10.3}  {:>6}  {}{}",
            n,
            g,
            memo,
            secs,
            n % 6,
            if law_p { "P" } else { "N" },
            flag
        );
        use std::io::Write;
        std::io::stdout().flush().ok();
    }
    if gate_ok {
        println!("VALIDATION GATE PASSED (n=1..44 match).");
    }
    if law_breaks.is_empty() {
        println!("mod-6 conjecture (G==0 iff n%6 in {{0,1,5}}): HOLDS for n=1..{}", nmax);
    } else {
        println!("mod-6 conjecture VIOLATED at n = {:?}", law_breaks);
    }
    let seq_str: Vec<String> = seq.iter().map(|v| v.to_string()).collect();
    println!("SEQ {}", seq_str.join(","));
}
