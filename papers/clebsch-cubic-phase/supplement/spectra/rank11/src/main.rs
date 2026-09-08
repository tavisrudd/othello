// Exhaustive Hessian-rank distribution over PG(k-1, p) for the phase cubic F_p.
//
// Input: tensor file "p k" then k blocks of k x k entries: A[m][j][l] = T(e_j,e_l,e_m).
// H(v) = sum_m v_m A[m]  (rank equals rank of the true Hessian, which is 6*H).
// rank is scale invariant, so we enumerate one representative per projective point:
// v with leading nonzero coordinate equal to 1.
//
// Usage: rank11 <tensorfile> [--bench N]

use rayon::prelude::*;
use std::env;
use std::fs;
use std::time::Instant;

const KMAX: usize = 12;

#[derive(Clone)]
struct Prob {
    p: u8,
    k: usize,
    a: Vec<[u8; KMAX * KMAX]>, // a[m] is k x k, row-major with stride k
    inv: [u8; 32],
}

fn load(path: &str) -> Prob {
    let txt = fs::read_to_string(path).expect("read tensor");
    let mut it = txt.split_ascii_whitespace().map(|s| s.parse::<i64>().unwrap());
    let p = it.next().unwrap() as u8;
    let k = it.next().unwrap() as usize;
    assert!(k <= KMAX);
    let mut a = Vec::with_capacity(k);
    for _ in 0..k {
        let mut m = [0u8; KMAX * KMAX];
        for j in 0..k {
            for l in 0..k {
                let x = it.next().unwrap().rem_euclid(p as i64) as u8;
                m[j * k + l] = x;
            }
        }
        a.push(m);
    }
    let mut inv = [0u8; 32];
    for x in 1..p {
        for y in 1..p {
            if (x as u16 * y as u16) % p as u16 == 1 {
                inv[x as usize] = y;
            }
        }
    }
    Prob { p, k, a, inv }
}

#[inline(always)]
fn add_into(h: &mut [u8; KMAX * KMAX], a: &[u8; KMAX * KMAX], k: usize, p: u8) {
    for i in 0..k * k {
        let s = h[i] + a[i];
        h[i] = if s >= p { s - p } else { s };
    }
}

#[inline(always)]
fn rank_of(h: &[u8; KMAX * KMAX], k: usize, p: u8, inv: &[u8; 32]) -> usize {
    let mut m = *h;
    let mut r = 0usize;
    let pu = p as u16;
    for c in 0..k {
        let mut piv = usize::MAX;
        for i in r..k {
            if m[i * k + c] != 0 {
                piv = i;
                break;
            }
        }
        if piv == usize::MAX {
            continue;
        }
        if piv != r {
            for j in c..k {
                m.swap(r * k + j, piv * k + j);
            }
        }
        let iv = inv[m[r * k + c] as usize] as u16;
        for j in c..k {
            m[r * k + j] = ((m[r * k + j] as u16 * iv) % pu) as u8;
        }
        for i in (r + 1)..k {
            let f = m[i * k + c];
            if f != 0 {
                let g = (p - f) as u16;
                for j in c..k {
                    m[i * k + j] = ((m[i * k + j] as u16 + g * m[r * k + j] as u16) % pu) as u8;
                }
            }
        }
        r += 1;
        if r == k {
            break;
        }
    }
    r
}

/// Enumerate coordinates m..k of v (each 0..p-1), accumulating counts.
fn recurse(
    pr: &Prob,
    m: usize,
    h: &[u8; KMAX * KMAX],
    counts: &mut [u64; KMAX + 1],
    low: &mut Vec<(u8, [u8; KMAX])>,
    v: &mut [u8; KMAX],
    low_thresh: usize,
) {
    let (p, k) = (pr.p, pr.k);
    if m == k {
        let r = rank_of(h, k, p, &pr.inv);
        counts[r] += 1;
        if r <= low_thresh {
            low.push((r as u8, *v));
        }
        return;
    }
    let mut hc = *h;
    if m + 1 == k {
        // innermost: avoid recursion
        for c in 0..p {
            v[m] = c;
            let r = rank_of(&hc, k, p, &pr.inv);
            counts[r] += 1;
            if r <= low_thresh && low.len() < 20000 {
                low.push((r as u8, *v));
            }
            add_into(&mut hc, &pr.a[m], k, p);
        }
        v[m] = 0;
        return;
    }
    for c in 0..p {
        v[m] = c;
        recurse(pr, m + 1, &hc, counts, low, v, low_thresh);
        add_into(&mut hc, &pr.a[m], k, p);
    }
    v[m] = 0;
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let pr = load(&args[1]);
    let (p, k) = (pr.p, pr.k);
    let low_thresh: usize = args
        .iter()
        .position(|s| s == "--low")
        .map(|i| args[i + 1].parse().unwrap())
        .unwrap_or(4);

    // Work items: for each leading index j (v_j = 1, v_{<j} = 0), fix up to `d` of the
    // free coordinates j+1.. and recurse over the rest.
    struct Item {
        v: [u8; KMAX],
        start: usize, // first free coordinate to recurse over
    }
    let mut items: Vec<Item> = Vec::new();
    for j in 0..k {
        let free = k - 1 - j;
        let d = free.min(3);
        let mut idx = 0u64;
        let total = (p as u64).pow(d as u32);
        while idx < total {
            let mut v = [0u8; KMAX];
            v[j] = 1;
            let mut t = idx;
            for s in 0..d {
                v[j + 1 + s] = (t % p as u64) as u8;
                t /= p as u64;
            }
            items.push(Item { v, start: j + 1 + d });
            idx += 1;
        }
    }
    let n_items = items.len();
    let t0 = Instant::now();

    let (counts, lows) = items
        .par_iter()
        .map(|it| {
            let mut h = [0u8; KMAX * KMAX];
            for m in 0..it.start {
                let c = it.v[m];
                for _ in 0..c {
                    add_into(&mut h, &pr.a[m], k, p);
                }
            }
            let mut counts = [0u64; KMAX + 1];
            let mut low: Vec<(u8, [u8; KMAX])> = Vec::new();
            let mut v = it.v;
            recurse(&pr, it.start, &h, &mut counts, &mut low, &mut v, low_thresh);
            (counts, low)
        })
        .reduce(
            || ([0u64; KMAX + 1], Vec::new()),
            |mut a, b| {
                for i in 0..=KMAX {
                    a.0[i] += b.0[i];
                }
                a.1.extend(b.1);
                (a.0, a.1)
            },
        );

    let secs = t0.elapsed().as_secs_f64();
    let np: u64 = counts.iter().sum();
    let expect = ((p as u64).pow(k as u32) - 1) / (p as u64 - 1);
    println!("p={} k={} work_items={} elapsed={:.1}s", p, k, n_items, secs);
    println!("projective points enumerated = {} (expected {}) match={}", np, expect, np == expect);
    println!("# projective rank counts (rank, #lines, #vectors = lines*(p-1))");
    for r in 0..=k {
        if counts[r] > 0 {
            println!("rank {:2} lines {:>14} vectors {:>16}", r, counts[r], counts[r] * (p as u64 - 1));
        }
    }
    let tot_vec: u64 = counts.iter().map(|c| c * (p as u64 - 1)).sum::<u64>() + 1;
    println!("total vectors incl. v=0 = {} (p^k = {}) match={}", tot_vec, (p as u64).pow(k as u32), tot_vec == (p as u64).pow(k as u32));
    println!("# low-rank representatives (rank <= {}), {} found", low_thresh, lows.len());
    let mut lows = lows;
    lows.sort();
    for (r, v) in lows.iter().take(400) {
        let s: Vec<String> = v[..k].iter().map(|x| x.to_string()).collect();
        println!("low rank {} v = {}", r, s.join(" "));
    }
    if lows.len() > 400 {
        println!("... {} more suppressed", lows.len() - 400);
    }
}
