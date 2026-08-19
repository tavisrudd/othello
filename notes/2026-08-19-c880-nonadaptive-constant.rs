// C880 — the nonadaptive constant for aligned-design reconstruction.
//
// This generator studies the ONE-POINT ATTACHMENT problem that the report
// `notes/2026-08-19-c880-nonadaptive-constant.md` reduces the nonadaptive
// construction to.
//
// Conventions (identical to `notes/2026-08-07-c880-alignment-separation.rs`).
// Points are 0..n-1.  A two-graph is a map tau from 3-subsets to F2 whose sum
// over the four triples of any 4-subset is even; equivalently the switching
// class of a graph G, with tau(abc) the parity of the number of edges of G
// inside {a,b,c}.  Every switching class has exactly one representative in
// which point 0 is isolated, so switching classes on m points are indexed by
// the 2^C(m-1,2) graphs on 1..m-1.  A 4-subset is ALIGNED when its four triples
// carry equal tau values, and the ALIGNMENT TEST on it returns that bit.
//
// THE ATTACHMENT PROBLEM.  Fix m "old" points 0..m-1 carrying a known
// two-graph, and one new point v.  The new point contributes the bits
// x_p = [v adjacent to p], p = 0..m-1, and x is only defined up to a global
// flip (flipping every x_p is switching at v), so normalise x_0 = 0.  For a
// triple T = {p,q,r} of old points, the test on {v} u T is aligned exactly when
//
//     x_p + x_q = e_pr + e_qr    and    x_p + x_r = e_pq + e_qr,
//
// where e is the chosen representative graph on the old points.  g(m) is the
// least number of triples T such that, for EVERY two-graph on the old points,
// the answers determine x.  The report proves 30 + sum_{m=7}^{n-1} g(m) is an
// upper bound for the nonadaptive query complexity at n points.
//
// Modes:
//   selfcheck                       identities behind the reduction
//   attach --m M [--maxweight K] [--out F]   exact/bracketed g(M)
//   verifyfamily --m M --family "t1,t2,..." [--out F]
//   totals --nmax N [--out F]       assemble the construction's size
//
// Build:  rustc -O -o $S/c880nc 2026-08-19-c880-nonadaptive-constant.rs
// Everything is deterministic: canonical enumeration, no randomness anywhere.

use std::collections::HashSet;
use std::env;
use std::fs;
use std::process;
use std::sync::Mutex;

// ---------------------------------------------------------------- combinatorics

fn pair_index(m: usize) -> Vec<Vec<usize>> {
    let mut idx = vec![vec![usize::MAX; m]; m];
    let mut k = 0;
    for p in 0..m {
        for q in (p + 1)..m {
            idx[p][q] = k;
            idx[q][p] = k;
            k += 1;
        }
    }
    idx
}

fn triples(m: usize) -> Vec<(usize, usize, usize)> {
    let mut v = Vec::new();
    for p in 0..m {
        for q in (p + 1)..m {
            for r in (q + 1)..m {
                v.push((p, q, r));
            }
        }
    }
    v
}

// The e-bit index of a pair, or None when the pair meets point 0 (gauge: 0 is
// isolated, so those edges are 0).
fn ebit_index(m: usize) -> Vec<Option<usize>> {
    let pi = pair_index(m);
    let mut out = vec![None; m * (m - 1) / 2];
    let mut k = 0;
    for p in 1..m {
        for q in (p + 1)..m {
            out[pi[p][q]] = Some(k);
            k += 1;
        }
    }
    out
}

// ---------------------------------------------------------------- alignment

// tau of a triple in a graph given as an adjacency-bit closure.
fn tau3<F: Fn(usize, usize) -> u32>(adj: &F, a: usize, b: usize, c: usize) -> u32 {
    (adj(a, b) + adj(a, c) + adj(b, c)) & 1
}

// Direct definition: the four triples of {a,b,c,d} carry equal tau.
fn aligned_direct<F: Fn(usize, usize) -> u32>(
    adj: &F,
    a: usize,
    b: usize,
    c: usize,
    d: usize,
) -> bool {
    let t = tau3(adj, a, b, c);
    tau3(adj, a, b, d) == t && tau3(adj, a, c, d) == t && tau3(adj, b, c, d) == t
}

// ---------------------------------------------------------------- attachment core

struct Attach {
    m: usize,
    tri: Vec<(usize, usize, usize)>,
    tc: usize,
    xc: usize,  // 2^(m-1)
    eb: usize,  // C(m-1,2)
    // per triple: e-bit indices of the three pairs (None when the pair meets 0)
    tpq: Vec<Option<usize>>,
    tpr: Vec<Option<usize>>,
    tqr: Vec<Option<usize>>,
    // per x: bit t set iff x_p ^ x_q == 1 for triple t's first pair (p,q)
    uword: Vec<u128>,
    // per x: bit t set iff x_p ^ x_r == 1 for triple t's second pair (p,r)
    vword: Vec<u128>,
    full: u128,
}

impl Attach {
    fn new(m: usize) -> Attach {
        assert!(m >= 4 && m <= 9, "m out of supported range");
        let tri = triples(m);
        let tc = tri.len();
        assert!(tc <= 128, "triple count exceeds a u128");
        let pi = pair_index(m);
        let ei = ebit_index(m);
        let xc = 1usize << (m - 1);
        let eb = (m - 1) * (m - 2) / 2;
        let mut tpq = Vec::with_capacity(tc);
        let mut tpr = Vec::with_capacity(tc);
        let mut tqr = Vec::with_capacity(tc);
        for &(p, q, r) in &tri {
            tpq.push(ei[pi[p][q]]);
            tpr.push(ei[pi[p][r]]);
            tqr.push(ei[pi[q][r]]);
        }
        let mut uword = vec![0u128; xc];
        let mut vword = vec![0u128; xc];
        for x in 0..xc {
            // bit i-1 of x is x_i for i >= 1; x_0 = 0.
            let xb = |i: usize| -> u128 {
                if i == 0 {
                    0
                } else {
                    ((x >> (i - 1)) & 1) as u128
                }
            };
            let mut u = 0u128;
            let mut v = 0u128;
            for (t, &(p, q, r)) in tri.iter().enumerate() {
                u |= (xb(p) ^ xb(q)) << t;
                v |= (xb(p) ^ xb(r)) << t;
            }
            uword[x] = u;
            vword[x] = v;
        }
        let full = if tc == 128 { !0u128 } else { (1u128 << tc) - 1 };
        Attach { m, tri, tc, xc, eb, tpq, tpr, tqr, uword, vword, full }
    }

    fn ebit(&self, e: u64, idx: Option<usize>) -> u128 {
        match idx {
            None => 0,
            Some(k) => ((e >> k) & 1) as u128,
        }
    }

    // alpha_t = e_pr ^ e_qr (target for the pair (p,q));
    // beta_t  = e_pq ^ e_qr (target for the pair (p,r)).
    fn targets(&self, e: u64) -> (u128, u128) {
        let mut a = 0u128;
        let mut b = 0u128;
        for t in 0..self.tc {
            let epq = self.ebit(e, self.tpq[t]);
            let epr = self.ebit(e, self.tpr[t]);
            let eqr = self.ebit(e, self.tqr[t]);
            a |= (epr ^ eqr) << t;
            b |= (epq ^ eqr) << t;
        }
        (a, b)
    }

    // Answer vectors of every x under the two-graph e, as u128 bitsets over triples.
    fn answers(&self, e: u64, out: &mut [u128]) {
        let (aw, bw) = self.targets(e);
        for x in 0..self.xc {
            out[x] = !(self.uword[x] ^ aw) & !(self.vword[x] ^ bw) & self.full;
        }
    }
}

// ---------------------------------------------------------------- parallel sweep

fn nthreads() -> usize {
    std::thread::available_parallelism().map(|v| v.get()).unwrap_or(1)
}

// Sweep every two-graph on m old points; collect every difference mask of
// popcount <= maxweight, and report whether the FULL triple family separates.
fn sweep_masks(at: &Attach, maxweight: u32) -> (HashSet<u128>, u64, bool) {
    let ecount: u64 = 1u64 << at.eb;
    let nt = nthreads();
    let out: Mutex<(HashSet<u128>, u64, bool)> = Mutex::new((HashSet::new(), 0u64, true));
    std::thread::scope(|s| {
        for tid in 0..nt {
            let outr = &out;
            s.spawn(move || {
                let mut local: HashSet<u128> = HashSet::new();
                let mut total: u64 = 0;
                let mut ok = true;
                let mut a = vec![0u128; at.xc];
                let mut e = tid as u64;
                while e < ecount {
                    at.answers(e, &mut a);
                    for x in 0..at.xc {
                        let ax = a[x];
                        for y in (x + 1)..at.xc {
                            let d = ax ^ a[y];
                            if d == 0 {
                                ok = false;
                                continue;
                            }
                            total += 1;
                            if d.count_ones() <= maxweight {
                                local.insert(d);
                            }
                        }
                    }
                    e += nt as u64;
                }
                let mut g = outr.lock().unwrap();
                for m in local {
                    g.0.insert(m);
                }
                g.1 += total;
                g.2 &= ok;
            });
        }
    });
    out.into_inner().unwrap()
}

// The MARGINAL problem P(k,j).  The points 0..k-1 are "known": the attachment
// x is given there, and only the remaining j = m-k points have to be found.
// Sweeps every two-graph and every pair of attachments agreeing on the known
// set, collecting the difference masks; the minimum hitting set of those masks
// is the exact number of tests the j new points cost once the known part is in
// hand.  `kbits` is the x-bit mask of the known points (point p, p >= 1, is
// bit p-1; point 0 is fixed by the gauge and always known).
fn sweep_marginal(at: &Attach, kbits: usize) -> (HashSet<u128>, u64) {
    let ecount: u64 = 1u64 << at.eb;
    let nt = nthreads();
    let out: Mutex<(HashSet<u128>, u64)> = Mutex::new((HashSet::new(), 0u64));
    std::thread::scope(|s| {
        for tid in 0..nt {
            let outr = &out;
            s.spawn(move || {
                let mut local: HashSet<u128> = HashSet::new();
                let mut total: u64 = 0;
                let mut a = vec![0u128; at.xc];
                let mut e = tid as u64;
                while e < ecount {
                    at.answers(e, &mut a);
                    for x in 0..at.xc {
                        for y in (x + 1)..at.xc {
                            if (x ^ y) & kbits != 0 {
                                continue;
                            }
                            let d = a[x] ^ a[y];
                            assert!(d != 0, "the full family fails on the marginal problem");
                            total += 1;
                            local.insert(d);
                        }
                    }
                    e += nt as u64;
                }
                let mut g = outr.lock().unwrap();
                for m in local {
                    g.0.insert(m);
                }
                g.1 += total;
            });
        }
    });
    out.into_inner().unwrap()
}

fn mode_marginal(m: usize, k: usize, out: Option<String>) {
    let at = Attach::new(m);
    assert!(k >= 1 && k < m);
    let mut kbits = 0usize;
    for p in 1..k {
        kbits |= 1 << (p - 1);
    }
    let (masks, pairs) = sweep_marginal(&at, kbits);
    let minimal = minimalize(&masks);
    if let Ok(p) = env::var("C880NC_DUMP") {
        let mut s = String::new();
        s.push_str(&format!(
            "{{\n  \"m\": {},\n  \"known_points\": {},\n  \"triples\": {},\n  \"mask_maxweight\": 0,\n  \"full_family_separates\": true,\n  \"x_pairs_checked\": {},\n  \"triple_list\": [",
            m, k, at.tc, pairs
        ));
        let tl: Vec<String> = at
            .tri
            .iter()
            .map(|&(p, q, r)| format!("[{},{},{}]", p, q, r))
            .collect();
        s.push_str(&tl.join(","));
        s.push_str("],\n  \"masks\": [\n");
        let rows: Vec<String> = minimal
            .iter()
            .map(|&mk| format!("    {}", json_usizes(&bits_to_list(mk, at.tc))))
            .collect();
        s.push_str(&rows.join(",\n"));
        s.push_str("\n  ]\n}");
        fs::write(&p, format!("{}\n", s)).expect("dump failed");
        println!("dumped {} minimal marginal masks to {}", minimal.len(), p);
        return;
    }
    let ub = greedy_hitting(&minimal, at.tc).count_ones() as usize;
    let (kk, sol, nodes) = exact_hitting(&minimal, at.tc, 1, ub);
    let list = bits_to_list(sol, at.tc);
    let tri_list: Vec<String> = list
        .iter()
        .map(|&t| {
            let (p, q, r) = at.tri[t];
            format!("[{},{},{}]", p, q, r)
        })
        .collect();
    let body = format!(
        "{{\n  \"mode\": \"marginal\",\n  \"m\": {},\n  \"known_points\": {},\n  \"new_points\": {},\n  \"two_graphs\": {},\n  \"x_pairs_checked\": {},\n  \"masks_minimal\": {},\n  \"marginal_cost\": {},\n  \"three_per_new_point\": {},\n  \"optimal_triples\": [{}],\n  \"search_nodes\": {}\n}}",
        m,
        k,
        m - k,
        1u64 << at.eb,
        pairs,
        minimal.len(),
        kk,
        3 * (m - k),
        tri_list.join(","),
        nodes
    );
    write_out(&out, &body);
}

// Verify a family exhaustively over every two-graph and every pair of x.
fn verify_family(at: &Attach, fam: u128) -> bool {
    find_violations(at, fam, 1).is_empty()
}

// Exhaustive sweep; returns distinct difference masks of colliding x-pairs,
// keeping at most `cap` of them (smallest popcount first within each thread).
fn find_violations(at: &Attach, fam: u128, cap: usize) -> HashSet<u128> {
    let ecount: u64 = 1u64 << at.eb;
    let nt = nthreads();
    let acc: Mutex<HashSet<u128>> = Mutex::new(HashSet::new());
    std::thread::scope(|s| {
        for tid in 0..nt {
            let accr = &acc;
            s.spawn(move || {
                let mut local: HashSet<u128> = HashSet::new();
                let mut a = vec![0u128; at.xc];
                let mut e = tid as u64;
                while e < ecount {
                    at.answers(e, &mut a);
                    for x in 0..at.xc {
                        let ax = a[x];
                        for y in (x + 1)..at.xc {
                            let d = ax ^ a[y];
                            if d & fam == 0 {
                                if local.len() < cap {
                                    local.insert(d);
                                } else if d.count_ones() < 6 {
                                    local.insert(d);
                                }
                            }
                        }
                    }
                    if local.len() >= cap {
                        break;
                    }
                    e += nt as u64;
                }
                let mut g = accr.lock().unwrap();
                for m in local {
                    g.insert(m);
                }
            });
        }
    });
    acc.into_inner().unwrap()
}

// ---------------------------------------------------------------- hitting set

fn minimalize(masks: &HashSet<u128>) -> Vec<u128> {
    let mut v: Vec<u128> = masks.iter().cloned().collect();
    v.sort_by_key(|m| (m.count_ones(), *m));
    let mut kept: Vec<u128> = Vec::new();
    for &m in &v {
        if !kept.iter().any(|&k| k & m == k) {
            kept.push(m);
        }
    }
    kept.sort();
    kept
}

fn greedy_hitting(masks: &[u128], ground: usize) -> u128 {
    let mut rem: Vec<u128> = masks.to_vec();
    let mut sol: u128 = 0;
    while !rem.is_empty() {
        let mut best = 0usize;
        let mut bestcnt = 0usize;
        for t in 0..ground {
            let b = 1u128 << t;
            let c = rem.iter().filter(|&&m| m & b != 0).count();
            if c > bestcnt {
                bestcnt = c;
                best = t;
            }
        }
        sol |= 1u128 << best;
        let b = 1u128 << best;
        rem.retain(|&m| m & b == 0);
    }
    sol
}

// Lower bound: greedy packing of pairwise disjoint masks.
fn packing_bound(rem: &[u128]) -> usize {
    let mut used: u128 = 0;
    let mut c = 0;
    for &m in rem {
        if m & used == 0 {
            used |= m;
            c += 1;
        }
    }
    c
}

struct Solver {
    limit: usize,
    nodes: u64,
}

impl Solver {
    // `rem` holds the still-uncovered masks, sorted by popcount.
    fn dfs(&mut self, rem: &[u128], chosen: u128, depth: usize) -> Option<u128> {
        self.nodes += 1;
        if rem.is_empty() {
            return Some(chosen);
        }
        if depth >= self.limit {
            return None;
        }
        if depth + packing_bound(rem) > self.limit {
            return None;
        }
        let t = rem[0];
        let mut bits = t;
        while bits != 0 {
            let b = bits & bits.wrapping_neg();
            bits ^= b;
            let sub: Vec<u128> = rem.iter().cloned().filter(|m| m & b == 0).collect();
            if let Some(sol) = self.dfs(&sub, chosen | b, depth + 1) {
                return Some(sol);
            }
        }
        None
    }
}

fn exact_hitting(masks: &[u128], ground: usize, lo: usize, hi: usize) -> (usize, u128, u64) {
    let mut sorted: Vec<u128> = masks.to_vec();
    sorted.sort_by_key(|m| (m.count_ones(), *m));
    let mut nodes = 0u64;
    let _ = ground;
    for k in lo..=hi {
        let mut s = Solver { limit: k, nodes: 0 };
        let r = s.dfs(&sorted, 0, 0);
        nodes += s.nodes;
        eprintln!("  limit {}: {} nodes, {}", k, s.nodes, if r.is_some() { "feasible" } else { "infeasible" });
        if let Some(sol) = r {
            return (k, sol, nodes);
        }
    }
    (usize::MAX, 0, nodes)
}

// ---------------------------------------------------------------- json

fn bits_to_list(mask: u128, tc: usize) -> Vec<usize> {
    (0..tc).filter(|&t| mask >> t & 1 == 1).collect()
}

fn json_usizes(v: &[usize]) -> String {
    let s: Vec<String> = v.iter().map(|x| x.to_string()).collect();
    format!("[{}]", s.join(","))
}

fn write_out(path: &Option<String>, body: &str) {
    match path {
        None => println!("{}", body),
        Some(p) => {
            fs::write(p, format!("{}\n", body)).expect("write failed");
            println!("wrote {}", p);
        }
    }
}

// ---------------------------------------------------------------- modes

fn mode_selfcheck() {
    // (1) On four points: aligned (four equal taus) <=> all four induced
    //     degrees have equal parity.  Checked over all 2^6 graphs.
    let mut checked = 0;
    for g in 0u32..64 {
        let bit = |p: usize, q: usize| -> u32 {
            let (a, b) = if p < q { (p, q) } else { (q, p) };
            let idx = match (a, b) {
                (0, 1) => 0,
                (0, 2) => 1,
                (0, 3) => 2,
                (1, 2) => 3,
                (1, 3) => 4,
                (2, 3) => 5,
                _ => unreachable!(),
            };
            (g >> idx) & 1
        };
        let direct = aligned_direct(&bit, 0, 1, 2, 3);
        let deg = |p: usize| -> u32 {
            (0..4).filter(|&q| q != p).map(|q| bit(p, q)).sum::<u32>() & 1
        };
        let parity = deg(0) == deg(1) && deg(0) == deg(2) && deg(0) == deg(3);
        assert_eq!(direct, parity, "degree-parity identity fails at g={}", g);
        checked += 1;
    }
    println!("selfcheck: degree-parity identity holds on all {} four-point graphs", checked);

    // (2) The attachment identity, exhaustively at m = 6 (old points 0..5, new
    //     point 6): the alpha/beta form agrees with the direct alignment test
    //     on {v,p,q,r} computed from the (m+1)-point graph.
    let m = 6usize;
    let at = Attach::new(m);
    let pi = pair_index(m);
    let ei = ebit_index(m);
    let mut a = vec![0u128; at.xc];
    let mut cases: u64 = 0;
    for e in 0u64..(1u64 << at.eb) {
        at.answers(e, &mut a);
        for x in 0..at.xc {
            // build the (m+1)-point graph: old edges from e, new edges from x
            let adj = |p: usize, q: usize| -> u32 {
                if p == q {
                    return 0;
                }
                if p == m || q == m {
                    let o = if p == m { q } else { p };
                    if o == 0 {
                        0
                    } else {
                        ((x >> (o - 1)) & 1) as u32
                    }
                } else {
                    match ei[pi[p][q]] {
                        None => 0,
                        Some(k) => ((e >> k) & 1) as u32,
                    }
                }
            };
            for (t, &(p, q, r)) in at.tri.iter().enumerate() {
                let direct = aligned_direct(&adj, m, p, q, r);
                let fast = (a[x] >> t) & 1 == 1;
                assert_eq!(direct, fast, "attachment identity fails e={} x={} t={}", e, x, t);
                cases += 1;
            }
        }
    }
    println!("selfcheck: attachment identity holds on all {} (two-graph, x, triple) cases at m=6", cases);
}

// Lower bound: the exact minimum hitting set of the difference masks of weight
// at most `maxweight`.  Dropping constraints can only lower a hitting number,
// so this is a valid lower bound for g(m) whatever the sweep missed above the
// weight cap.
fn mode_lowerbound(m: usize, maxweight: u32, out: Option<String>) {
    let at = Attach::new(m);
    let entropy_floor = {
        let h = -0.25f64 * (0.25f64).log2() - 0.75f64 * (0.75f64).log2();
        (((m - 1) as f64) / h).ceil() as usize
    };
    let (masks, pairs, full_ok) = sweep_masks(&at, maxweight);
    let minimal = minimalize(&masks);
    if let Ok(p) = env::var("C880NC_DUMP") {
        // Compact constraint file for an independent integer-program solve.
        let mut s = String::new();
        s.push_str(&format!(
            "{{\n  \"m\": {},\n  \"triples\": {},\n  \"mask_maxweight\": {},\n  \"full_family_separates\": {},\n  \"x_pairs_checked\": {},\n  \"triple_list\": [",
            m, at.tc, maxweight, full_ok, pairs
        ));
        let tl: Vec<String> = at
            .tri
            .iter()
            .map(|&(p, q, r)| format!("[{},{},{}]", p, q, r))
            .collect();
        s.push_str(&tl.join(","));
        s.push_str("],\n  \"masks\": [\n");
        let rows: Vec<String> = minimal
            .iter()
            .map(|&mk| format!("    {}", json_usizes(&bits_to_list(mk, at.tc))))
            .collect();
        s.push_str(&rows.join(",\n"));
        s.push_str("\n  ]\n}");
        fs::write(&p, format!("{}\n", s)).expect("dump failed");
        println!("dumped {} minimal masks to {}", minimal.len(), p);
        return;
    }
    let ub = greedy_hitting(&minimal, at.tc).count_ones() as usize;
    let (k, sol, nodes) = exact_hitting(&minimal, at.tc, entropy_floor.max(1), ub);
    let body = format!(
        "{{\n  \"mode\": \"lowerbound\",\n  \"m\": {},\n  \"triples\": {},\n  \"two_graphs\": {},\n  \"x_classes\": {},\n  \"x_pairs_checked\": {},\n  \"full_family_separates\": {},\n  \"mask_maxweight\": {},\n  \"masks_distinct\": {},\n  \"masks_minimal\": {},\n  \"entropy_floor\": {},\n  \"mask_hitting_number\": {},\n  \"g_lower_bound\": {},\n  \"optimal_hitting_set\": {},\n  \"search_nodes\": {}\n}}",
        m,
        at.tc,
        1u64 << at.eb,
        at.xc,
        pairs,
        full_ok,
        maxweight,
        masks.len(),
        minimal.len(),
        entropy_floor,
        k,
        k,
        json_usizes(&bits_to_list(sol, at.tc)),
        nodes
    );
    write_out(&out, &body);
}

// Upper bound: lazy greedy against the mask pool, every candidate confirmed by
// the exhaustive sweep, then a removal-and-swap reduction.
fn mode_build(m: usize, maxweight: u32, out: Option<String>) {
    let at = Attach::new(m);
    let (masks0, _pairs, _ok) = sweep_masks(&at, maxweight);
    let mut pool: Vec<u128> = minimalize(&masks0);
    let mut rounds = 0usize;
    let mut sol: u128;
    loop {
        rounds += 1;
        sol = greedy_hitting(&pool, at.tc);
        let viol = find_violations(&at, sol, 20_000);
        eprintln!("build round {}: |pool|={} size={} violations={}", rounds, pool.len(), sol.count_ones(), viol.len());
        if viol.is_empty() {
            break;
        }
        for v in viol {
            pool.push(v);
        }
        pool.sort_by_key(|x| (x.count_ones(), *x));
        pool.dedup();
        if pool.len() > 60_000 {
            pool.truncate(60_000);
        }
    }
    // Reduction: drop any triple whose removal keeps the family separating.
    let mut improved = true;
    while improved {
        improved = false;
        let mut bits = sol;
        while bits != 0 {
            let b = bits & bits.wrapping_neg();
            bits ^= b;
            let cand = sol & !b;
            if pool.iter().all(|&mk| mk & cand != 0) && verify_family(&at, cand) {
                sol = cand;
                improved = true;
                eprintln!("  reduced to {}", sol.count_ones());
                break;
            }
        }
    }
    // Swap: remove two, add one.
    let mut improved = true;
    while improved {
        improved = false;
        let chosen: Vec<usize> = bits_to_list(sol, at.tc);
        'swap: for i in 0..chosen.len() {
            for j in (i + 1)..chosen.len() {
                let base = sol & !(1u128 << chosen[i]) & !(1u128 << chosen[j]);
                for t in 0..at.tc {
                    if sol >> t & 1 == 1 {
                        continue;
                    }
                    let cand = base | (1u128 << t);
                    if pool.iter().all(|&mk| mk & cand != 0) && verify_family(&at, cand) {
                        sol = cand;
                        improved = true;
                        eprintln!("  swapped down to {}", sol.count_ones());
                        break 'swap;
                    }
                }
            }
        }
    }
    let list = bits_to_list(sol, at.tc);
    let tri_list: Vec<String> = list
        .iter()
        .map(|&t| {
            let (p, q, r) = at.tri[t];
            format!("[{},{},{}]", p, q, r)
        })
        .collect();
    let body = format!(
        "{{\n  \"mode\": \"build\",\n  \"m\": {},\n  \"triples\": {},\n  \"two_graphs\": {},\n  \"mask_seed_maxweight\": {},\n  \"lazy_rounds\": {},\n  \"anchor_bound_6m_minus_20\": {},\n  \"g_upper_bound\": {},\n  \"verified_exhaustively\": true,\n  \"family_triple_indices\": {},\n  \"family_triples\": [{}]\n}}",
        m,
        at.tc,
        1u64 << at.eb,
        maxweight,
        rounds,
        6 * m - 20,
        list.len(),
        json_usizes(&list),
        tri_list.join(",")
    );
    write_out(&out, &body);
}

#[allow(dead_code)]
fn mode_attach(m: usize, maxweight: u32, out: Option<String>) {
    let at = Attach::new(m);
    let entropy_floor = {
        // ceil((m-1)/H(1/4))
        let h = -0.25f64 * (0.25f64).log2() - 0.75f64 * (0.75f64).log2();
        (((m - 1) as f64) / h).ceil() as usize
    };
    let (masks0, pairs, full_ok) = sweep_masks(&at, maxweight);
    // Lazy constraint generation: solve the exact minimum hitting set of the
    // masks collected so far, verify the solution exhaustively, and on failure
    // fold the violated masks in and re-solve.  The hitting number never
    // decreases, so the first verified solution is the exact optimum.
    const POOL_CAP: usize = 12000;
    let mut pool: HashSet<u128> = masks0.clone();
    let mut lo = entropy_floor.max(1);
    let mut rounds = 0usize;
    let mut nodes = 0u64;
    let mut minimal_final: Vec<u128> = Vec::new();
    let (k, sol) = loop {
        rounds += 1;
        let mut minimal = minimalize(&pool);
        minimal.sort_by_key(|m| (m.count_ones(), *m));
        minimal.truncate(POOL_CAP);
        pool = minimal.iter().cloned().collect();
        let (k, sol, nd) = exact_hitting(&minimal, at.tc, lo, at.tc);
        nodes += nd;
        assert!(k != usize::MAX, "no hitting set exists");
        let viol = find_violations(&at, sol, 20_000);
        eprintln!("round {}: |masks|={} k={} violations={}", rounds, minimal.len(), k, viol.len());
        if viol.is_empty() {
            minimal_final = minimal;
            break (k, sol);
        }
        lo = k;
        for v in viol {
            pool.insert(v);
        }
    };
    let ub_greedy = greedy_hitting(&minimal_final, at.tc).count_ones() as usize;
    let verified = true;
    let list = bits_to_list(sol, at.tc);
    let tri_list: Vec<String> = list
        .iter()
        .map(|&t| {
            let (p, q, r) = at.tri[t];
            format!("[{},{},{}]", p, q, r)
        })
        .collect();
    let body = format!(
        "{{\n  \"mode\": \"attach\",\n  \"m\": {},\n  \"triples\": {},\n  \"two_graphs\": {},\n  \"x_classes\": {},\n  \"x_pairs_checked\": {},\n  \"full_family_separates\": {},\n  \"mask_seed_maxweight\": {},\n  \"masks_seeded\": {},\n  \"masks_minimal_final\": {},\n  \"lazy_rounds\": {},\n  \"entropy_floor\": {},\n  \"anchor_bound_6m_minus_20\": {},\n  \"greedy_upper_bound\": {},\n  \"witness_verified_exhaustively\": {},\n  \"g\": {},\n  \"witness_triple_indices\": {},\n  \"witness_triples\": [{}],\n  \"search_nodes\": {}\n}}",
        m,
        at.tc,
        1u64 << at.eb,
        at.xc,
        pairs,
        full_ok,
        maxweight,
        masks0.len(),
        minimal_final.len(),
        rounds,
        entropy_floor,
        6 * m - 20,
        ub_greedy,
        verified,
        k,
        json_usizes(&list),
        tri_list.join(","),
        nodes
    );
    write_out(&out, &body);
}

// The conjectured general family:  a six-point core carrying a verified
// optimal 12-triple attachment family, plus, for each old point outside the
// core, the three triples {a,b,w} with {a,b} a pair of one fixed core triple.
// Size 12 + 3(m-6) = 3m-6.
const CORE6: [[usize; 3]; 12] = [
    [0, 1, 2], [0, 1, 3], [0, 1, 4], [0, 2, 3], [0, 2, 4], [0, 2, 5],
    [0, 3, 5], [1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4], [2, 3, 5],
];

fn template_family(at: &Attach, m: usize, t0: [usize; 3]) -> (u128, Vec<usize>) {
    let mut idx = std::collections::HashMap::new();
    for (t, &(p, q, r)) in at.tri.iter().enumerate() {
        idx.insert((p, q, r), t);
    }
    let mut mask: u128 = 0;
    for c in CORE6.iter() {
        mask |= 1u128 << idx[&(c[0], c[1], c[2])];
    }
    for w in 6..m {
        for i in 0..3 {
            for j in (i + 1)..3 {
                let mut v = [t0[i], t0[j], w];
                v.sort();
                mask |= 1u128 << idx[&(v[0], v[1], v[2])];
            }
        }
    }
    (mask, bits_to_list(mask, at.tc))
}

fn mode_template(m: usize, t0s: &str, out: Option<String>) {
    let at = Attach::new(m);
    let parts: Vec<usize> = t0s.split(',').map(|s| s.trim().parse().unwrap()).collect();
    let t0 = [parts[0], parts[1], parts[2]];
    let (mask, list) = template_family(&at, m, t0);
    let ok = verify_family(&at, mask);
    let tri_list: Vec<String> = list
        .iter()
        .map(|&t| {
            let (p, q, r) = at.tri[t];
            format!("[{},{},{}]", p, q, r)
        })
        .collect();
    let body = format!(
        "{{\n  \"mode\": \"template\",\n  \"m\": {},\n  \"core_triple\": [{},{},{}],\n  \"two_graphs\": {},\n  \"x_classes\": {},\n  \"predicted_size_3m_minus_6\": {},\n  \"size\": {},\n  \"separates_every_two_graph\": {},\n  \"family_triples\": [{}]\n}}",
        m,
        t0[0], t0[1], t0[2],
        1u64 << at.eb,
        at.xc,
        3 * m - 6,
        list.len(),
        ok,
        tri_list.join(",")
    );
    write_out(&out, &body);
}

fn mode_verifyfamily(m: usize, fam: &str, out: Option<String>) {
    let at = Attach::new(m);
    let mut mask: u128 = 0;
    let mut list: Vec<usize> = Vec::new();
    for tok in fam.split(',') {
        let t: usize = tok.trim().parse().expect("bad triple index");
        assert!(t < at.tc);
        mask |= 1u128 << t;
        list.push(t);
    }
    list.sort();
    list.dedup();
    let ok = verify_family(&at, mask);
    let body = format!(
        "{{\n  \"mode\": \"verifyfamily\",\n  \"m\": {},\n  \"size\": {},\n  \"triple_indices\": {},\n  \"separates_every_two_graph\": {}\n}}",
        m,
        list.len(),
        json_usizes(&list),
        ok
    );
    write_out(&out, &body);
}

fn mode_totals(nmax: usize, gvals: &[(usize, usize)], out: Option<String>) {
    // 30 tests on seven points, then g(m) for each attachment m = 7..n-1.
    let mut rows: Vec<String> = Vec::new();
    let mut have: Vec<Option<usize>> = vec![None; nmax + 1];
    for &(m, g) in gvals {
        if m <= nmax {
            have[m] = Some(g);
        }
    }
    let mut total: Option<usize> = Some(30);
    for n in 7..=nmax {
        if n > 7 {
            total = match (total, have[n - 1]) {
                (Some(t), Some(g)) => Some(t + g),
                _ => None,
            };
        }
        let anchor = 3 * n * n - 23 * n + 45;
        rows.push(format!(
            "    {{\"n\": {}, \"recursive_total\": {}, \"anchor_family\": {}}}",
            n,
            match total {
                Some(t) => t.to_string(),
                None => "null".to_string(),
            },
            anchor
        ));
    }
    let body = format!(
        "{{\n  \"mode\": \"totals\",\n  \"base_seven_points\": 30,\n  \"g\": [{}],\n  \"rows\": [\n{}\n  ]\n}}",
        gvals
            .iter()
            .map(|&(m, g)| format!("{{\"m\": {}, \"g\": {}}}", m, g))
            .collect::<Vec<_>>()
            .join(","),
        rows.join(",\n")
    );
    write_out(&out, &body);
}

// ---------------------------------------------------------------- main

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("usage: c880nc <selfcheck|attach|verifyfamily|totals> [options]");
        process::exit(2);
    }
    let getopt = |name: &str| -> Option<String> {
        args.iter()
            .position(|a| a == name)
            .and_then(|i| args.get(i + 1))
            .cloned()
    };
    let out = getopt("--out");
    match args[1].as_str() {
        "selfcheck" => mode_selfcheck(),
        "attach" => {
            let m: usize = getopt("--m").expect("--m").parse().unwrap();
            let w: u32 = getopt("--maxweight").unwrap_or("8".into()).parse().unwrap();
            mode_attach(m, w, out);
        }
        "lowerbound" => {
            let m: usize = getopt("--m").expect("--m").parse().unwrap();
            let w: u32 = getopt("--maxweight").unwrap_or("8".into()).parse().unwrap();
            mode_lowerbound(m, w, out);
        }
        "marginal" => {
            let m: usize = getopt("--m").expect("--m").parse().unwrap();
            let k: usize = getopt("--known").expect("--known").parse().unwrap();
            mode_marginal(m, k, out);
        }
        "template" => {
            let m: usize = getopt("--m").expect("--m").parse().unwrap();
            let t0 = getopt("--t0").unwrap_or("0,1,2".into());
            mode_template(m, &t0, out);
        }
        "build" => {
            let m: usize = getopt("--m").expect("--m").parse().unwrap();
            let w: u32 = getopt("--maxweight").unwrap_or("8".into()).parse().unwrap();
            mode_build(m, w, out);
        }
        "verifyfamily" => {
            let m: usize = getopt("--m").expect("--m").parse().unwrap();
            let f = getopt("--family").expect("--family");
            mode_verifyfamily(m, &f, out);
        }
        "totals" => {
            let nmax: usize = getopt("--nmax").expect("--nmax").parse().unwrap();
            let g = getopt("--g").unwrap_or("".into());
            let mut gv: Vec<(usize, usize)> = Vec::new();
            for tok in g.split(',').filter(|s| !s.trim().is_empty()) {
                let mut it = tok.split(':');
                let m: usize = it.next().unwrap().trim().parse().unwrap();
                let val: usize = it.next().unwrap().trim().parse().unwrap();
                gv.push((m, val));
            }
            gv.sort();
            mode_totals(nmax, &gv, out);
        }
        other => {
            eprintln!("unknown mode {}", other);
            process::exit(2);
        }
    }
}
