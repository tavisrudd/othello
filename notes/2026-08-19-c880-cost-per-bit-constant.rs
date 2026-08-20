// C880 — the cost-per-bit constant for nonadaptive aligned-design reconstruction.
//
// Companion generator for `notes/2026-08-19-c880-cost-per-bit-constant.md`.
// It re-derives the attachment machinery of
// `notes/2026-08-19-c880-nonadaptive-constant.rs` from scratch rather than
// importing it, so this report replays on its own bytes, and `selfcheck`
// checks the re-derivation against the direct four-triples definition of
// alignment.
//
// Conventions.  Points 0..n-1.  A two-graph is the switching class of a graph;
// the representative with point 0 isolated indexes switching classes on m
// points by the 2^C(m-1,2) graphs on 1..m-1.  A 4-set is ALIGNED when its four
// triples carry equal tau.
//
// THE ATTACHMENT PROBLEM.  m old points carry a known two-graph e; a new point
// v contributes x_p = [v ~ p], defined up to a global flip (switching at v), so
// x_0 = 0 and there are 2^(m-1) candidates.  For a triple T = {p,q,r},
//
//     {v,p,q,r} aligned  <=>  x_p + x_q = e_pr + e_qr  and  x_p + x_r = e_pq + e_qr.
//
// g(m) is the least number of triples that determine x for EVERY two-graph on
// the m points.
//
// Modes (all deterministic unless marked):
//   selfcheck                      the attachment identity, against the direct
//                                  definition, exhaustively at m = 6
//   masks --m M [--stride S] [--maxweight W] [--pool N] [--out F]
//                                  difference-mask sweep; --stride samples
//                                  two-graphs and then the output is only a
//                                  RELAXATION (valid lower bounds, not proof of
//                                  completeness)
//   lb --m M [--stride S] [--maxweight W] [--pool N] [--out F]
//                                  exact minimum hitting set of the swept mask
//                                  family: a lower bound for g(M), exact when
//                                  stride = 1 and no cap is applied
//   verify --m M --family "a,b,c;..." [--out F]
//                                  exhaustive: does the family determine the
//                                  attachment for every two-graph on M points?
//   search --m M --limit K [--stride S] [--rounds R]   NOT deterministic
//                                  lazy greedy against a sampled mask pool;
//                                  used only to FIND candidate families, which
//                                  are then certified by `verify`
//   bracket --nmax N [--g8 V] [--out F]
//                                  the star-flip lower bound against the
//                                  entropy floor and the block construction
//
// Build:  rustc -O -o $S/c880cpb 2026-08-19-c880-cost-per-bit-constant.rs

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

// ---------------------------------------------------------------- attachment core

struct Attach {
    tri: Vec<(usize, usize, usize)>,
    tc: usize,
    xc: usize,
    eb: usize,
    tpq: Vec<Option<usize>>,
    tpr: Vec<Option<usize>>,
    tqr: Vec<Option<usize>>,
    uword: Vec<u128>,
    vword: Vec<u128>,
    full: u128,
}

impl Attach {
    fn new(m: usize) -> Attach {
        assert!((4..=9).contains(&m), "m out of supported range");
        let tri = triples(m);
        let tc = tri.len();
        assert!(tc <= 128);
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
            let xb = |i: usize| -> u128 {
                if i == 0 { 0 } else { ((x >> (i - 1)) & 1) as u128 }
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
        Attach { tri, tc, xc, eb, tpq, tpr, tqr, uword, vword, full }
    }

    fn ebit(&self, e: u64, idx: Option<usize>) -> u128 {
        match idx { None => 0, Some(k) => ((e >> k) & 1) as u128 }
    }

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

    fn answers(&self, e: u64, out: &mut [u128]) {
        let (aw, bw) = self.targets(e);
        for x in 0..self.xc {
            out[x] = !(self.uword[x] ^ aw) & !(self.vword[x] ^ bw) & self.full;
        }
    }
}

fn nthreads() -> usize {
    std::thread::available_parallelism().map(|v| v.get()).unwrap_or(1)
}

// ---------------------------------------------------------------- mask sweep

// Every difference mask of a pair of attachments, over the two-graphs e with
// e % stride == 0.  stride = 1 is the complete family.
fn sweep(at: &Attach, stride: u64, maxweight: u32) -> (HashSet<u128>, u64, bool) {
    let ecount: u64 = 1u64 << at.eb;
    let nt = nthreads();
    let out: Mutex<(HashSet<u128>, u64, bool)> = Mutex::new((HashSet::new(), 0, true));
    std::thread::scope(|s| {
        for tid in 0..nt {
            let outr = &out;
            s.spawn(move || {
                let mut local: HashSet<u128> = HashSet::new();
                let mut total = 0u64;
                let mut ok = true;
                let mut a = vec![0u128; at.xc];
                let mut e = (tid as u64) * stride;
                while e < ecount {
                    at.answers(e, &mut a);
                    for x in 0..at.xc {
                        let ax = a[x];
                        for y in (x + 1)..at.xc {
                            let d = ax ^ a[y];
                            if d == 0 { ok = false; continue; }
                            total += 1;
                            if d.count_ones() <= maxweight { local.insert(d); }
                        }
                    }
                    e += (nt as u64) * stride;
                }
                let mut g = outr.lock().unwrap();
                for mk in local { g.0.insert(mk); }
                g.1 += total;
                g.2 &= ok;
            });
        }
    });
    out.into_inner().unwrap()
}

// Exhaustive check that a family determines the attachment, by sorting the
// masked answer vectors of all 2^(m-1) attachments for every two-graph.
fn verify_family(at: &Attach, fam: u128) -> bool {
    let ecount: u64 = 1u64 << at.eb;
    let nt = nthreads();
    let ok = Mutex::new(true);
    std::thread::scope(|s| {
        for tid in 0..nt {
            let okr = &ok;
            s.spawn(move || {
                let mut good = true;
                let mut a = vec![0u128; at.xc];
                let mut buf = vec![0u128; at.xc];
                let mut e = tid as u64;
                while e < ecount {
                    at.answers(e, &mut a);
                    for x in 0..at.xc { buf[x] = a[x] & fam; }
                    buf.sort_unstable();
                    for i in 1..buf.len() {
                        if buf[i] == buf[i - 1] { good = false; }
                    }
                    e += nt as u64;
                }
                *okr.lock().unwrap() &= good;
            });
        }
    });
    ok.into_inner().unwrap()
}

// Violated masks for a candidate family, sampling two-graphs by stride.
fn violations(at: &Attach, fam: u128, stride: u64, cap: usize) -> HashSet<u128> {
    let ecount: u64 = 1u64 << at.eb;
    let nt = nthreads();
    let acc: Mutex<HashSet<u128>> = Mutex::new(HashSet::new());
    std::thread::scope(|s| {
        for tid in 0..nt {
            let accr = &acc;
            s.spawn(move || {
                let mut local: HashSet<u128> = HashSet::new();
                let mut a = vec![0u128; at.xc];
                let mut e = (tid as u64) * stride;
                while e < ecount && local.len() < cap {
                    at.answers(e, &mut a);
                    for x in 0..at.xc {
                        let ax = a[x];
                        for y in (x + 1)..at.xc {
                            let d = ax ^ a[y];
                            if d & fam == 0 { local.insert(d); }
                        }
                    }
                    e += (nt as u64) * stride;
                }
                let mut g = accr.lock().unwrap();
                for mk in local { g.insert(mk); }
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
        if !kept.iter().any(|&k| k & m == k) { kept.push(m); }
    }
    kept.sort_by_key(|m| (m.count_ones(), *m));
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
            if c > bestcnt { bestcnt = c; best = t; }
        }
        sol |= 1u128 << best;
        let b = 1u128 << best;
        rem.retain(|&m| m & b == 0);
    }
    sol
}

fn packing_bound(rem: &[u128]) -> usize {
    let mut used: u128 = 0;
    let mut c = 0;
    for &m in rem {
        if m & used == 0 { used |= m; c += 1; }
    }
    c
}

struct Solver { limit: usize, nodes: u64 }

impl Solver {
    fn dfs(&mut self, rem: &[u128], chosen: u128, depth: usize) -> Option<u128> {
        self.nodes += 1;
        if rem.is_empty() { return Some(chosen); }
        if depth >= self.limit { return None; }
        if depth + packing_bound(rem) > self.limit { return None; }
        let t = rem[0];
        let mut bits = t;
        while bits != 0 {
            let b = bits & bits.wrapping_neg();
            bits ^= b;
            let sub: Vec<u128> = rem.iter().cloned().filter(|m| m & b == 0).collect();
            if let Some(sol) = self.dfs(&sub, chosen | b, depth + 1) { return Some(sol); }
        }
        None
    }
}

fn exact_hitting(masks: &[u128], lo: usize, hi: usize) -> (usize, u128, u64) {
    let sorted: Vec<u128> = masks.to_vec();
    let mut nodes = 0u64;
    for k in lo..=hi {
        let mut s = Solver { limit: k, nodes: 0 };
        let r = s.dfs(&sorted, 0, 0);
        nodes += s.nodes;
        eprintln!("  limit {}: {} nodes, {}", k, s.nodes,
                  if r.is_some() { "feasible" } else { "infeasible" });
        if let Some(sol) = r { return (k, sol, nodes); }
    }
    (usize::MAX, 0, nodes)
}

// ---------------------------------------------------------------- helpers

fn bits_to_list(mask: u128, tc: usize) -> Vec<usize> {
    (0..tc).filter(|&t| mask >> t & 1 == 1).collect()
}

fn json_usizes(v: &[usize]) -> String {
    let s: Vec<String> = v.iter().map(|x| x.to_string()).collect();
    format!("[{}]", s.join(","))
}

fn triple_strings(at: &Attach, list: &[usize]) -> String {
    let v: Vec<String> = list.iter().map(|&t| {
        let (p, q, r) = at.tri[t];
        format!("[{},{},{}]", p, q, r)
    }).collect();
    v.join(",")
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

fn parse_family(at: &Attach, s: &str) -> (u128, Vec<usize>) {
    let mut idx = std::collections::HashMap::new();
    for (t, &(p, q, r)) in at.tri.iter().enumerate() { idx.insert((p, q, r), t); }
    let mut mask: u128 = 0;
    for tok in s.split(';') {
        let v: Vec<usize> = tok.split(',').map(|x| x.trim().parse().unwrap()).collect();
        let mut w = [v[0], v[1], v[2]];
        w.sort();
        mask |= 1u128 << idx[&(w[0], w[1], w[2])];
    }
    (mask, bits_to_list(mask, at.tc))
}

fn entropy_ceil(bits: usize) -> usize {
    let h = -0.25f64 * (0.25f64).log2() - 0.75f64 * (0.75f64).log2();
    ((bits as f64) / h).ceil() as usize
}

// ---------------------------------------------------------------- modes

fn mode_selfcheck() {
    let m = 6usize;
    let at = Attach::new(m);
    let pi = pair_index(m);
    let ei = ebit_index(m);
    let mut a = vec![0u128; at.xc];
    let mut cases: u64 = 0;
    for e in 0u64..(1u64 << at.eb) {
        at.answers(e, &mut a);
        for x in 0..at.xc {
            let adj = |p: usize, q: usize| -> u32 {
                if p == q { return 0; }
                if p == m || q == m {
                    let o = if p == m { q } else { p };
                    if o == 0 { 0 } else { ((x >> (o - 1)) & 1) as u32 }
                } else {
                    match ei[pi[p][q]] { None => 0, Some(k) => ((e >> k) & 1) as u32 }
                }
            };
            let tau = |i: usize, j: usize, k: usize| (adj(i, j) + adj(i, k) + adj(j, k)) & 1;
            for (t, &(p, q, r)) in at.tri.iter().enumerate() {
                let s = tau(m, p, q);
                let direct = tau(m, p, r) == s && tau(m, q, r) == s && tau(p, q, r) == s;
                assert_eq!(direct, (a[x] >> t) & 1 == 1, "attachment identity fails");
                cases += 1;
            }
        }
    }
    println!("selfcheck: attachment identity holds on all {} (two-graph, attachment, triple) cases at m=6", cases);
}

fn mode_masks(m: usize, stride: u64, maxweight: u32, pool: usize, out: Option<String>) {
    let at = Attach::new(m);
    let (masks, pairs, full_ok) = sweep(&at, stride, maxweight);
    let mut minimal = minimalize(&masks);
    let capped = minimal.len() > pool;
    if capped { minimal.truncate(pool); }
    let body = {
        let tl: Vec<String> = at.tri.iter()
            .map(|&(p, q, r)| format!("[{},{},{}]", p, q, r)).collect();
        let rows: Vec<String> = minimal.iter()
            .map(|&mk| format!("    {}", json_usizes(&bits_to_list(mk, at.tc)))).collect();
        format!(
            "{{\n  \"mode\": \"masks\",\n  \"m\": {},\n  \"stride\": {},\n  \"mask_maxweight\": {},\n  \"pool_cap\": {},\n  \"pool_capped\": {},\n  \"complete\": {},\n  \"triples\": {},\n  \"two_graphs_swept\": {},\n  \"x_pairs_checked\": {},\n  \"full_family_separates\": {},\n  \"masks_minimal\": {},\n  \"triple_list\": [{}],\n  \"masks\": [\n{}\n  ]\n}}",
            m, stride, maxweight, pool, capped,
            stride == 1 && maxweight >= at.tc as u32 && !capped,
            at.tc, (1u64 << at.eb) / stride, pairs, full_ok, minimal.len(),
            tl.join(","), rows.join(",\n"))
    };
    write_out(&out, &body);
}

fn mode_lb(m: usize, stride: u64, maxweight: u32, pool: usize, out: Option<String>) {
    let at = Attach::new(m);
    let (masks, pairs, full_ok) = sweep(&at, stride, maxweight);
    let mut minimal = minimalize(&masks);
    let capped = minimal.len() > pool;
    if capped { minimal.truncate(pool); }
    let complete = stride == 1 && maxweight >= at.tc as u32 && !capped;
    let ub = greedy_hitting(&minimal, at.tc).count_ones() as usize;
    let (k, sol, nodes) = exact_hitting(&minimal, 1, ub);
    let list = bits_to_list(sol, at.tc);
    let verified = if complete { verify_family(&at, sol) } else { false };
    let body = format!(
        "{{\n  \"mode\": \"lb\",\n  \"m\": {},\n  \"stride\": {},\n  \"mask_maxweight\": {},\n  \"pool_cap\": {},\n  \"pool_capped\": {},\n  \"constraint_family_complete\": {},\n  \"triples\": {},\n  \"two_graphs_swept\": {},\n  \"x_pairs_checked\": {},\n  \"full_family_separates\": {},\n  \"masks_minimal\": {},\n  \"entropy_floor\": {},\n  \"hitting_number\": {},\n  \"g_lower_bound\": {},\n  \"g_exact\": {},\n  \"witness_triples\": [{}],\n  \"search_nodes\": {}\n}}",
        m, stride, maxweight, pool, capped, complete, at.tc,
        (1u64 << at.eb) / stride, pairs, full_ok, minimal.len(),
        entropy_ceil(m - 1), k, k,
        if complete && verified { k.to_string() } else { "null".to_string() },
        triple_strings(&at, &list), nodes);
    write_out(&out, &body);
}

fn mode_verify(m: usize, fam: &str, out: Option<String>) {
    let at = Attach::new(m);
    let (mask, list) = parse_family(&at, fam);
    let ok = verify_family(&at, mask);
    let body = format!(
        "{{\n  \"mode\": \"verify\",\n  \"m\": {},\n  \"two_graphs\": {},\n  \"attachments\": {},\n  \"size\": {},\n  \"determines_attachment\": {},\n  \"family_triples\": [{}]\n}}",
        m, 1u64 << at.eb, at.xc, list.len(), ok, triple_strings(&at, &list));
    write_out(&out, &body);
}

// Lazy greedy against a sampled mask pool.  NOT deterministic: the sampled
// violation set depends on thread scheduling.  Used only to FIND candidates.
fn mode_search(m: usize, limit: usize, stride: u64, rounds: usize) {
    let at = Attach::new(m);
    let (seed, _, _) = sweep(&at, stride.max(1), 12);
    let mut pool: Vec<u128> = minimalize(&seed);
    let mut best: Option<(usize, u128)> = None;
    for r in 0..rounds {
        let sol = greedy_hitting(&pool, at.tc);
        let size = sol.count_ones() as usize;
        let viol = violations(&at, sol, stride.max(1), 20_000);
        eprintln!("round {}: |pool|={} size={} violations={}", r, pool.len(), size, viol.len());
        if viol.is_empty() {
            eprintln!("FEASIBLE at size {}", size);
            if best.map_or(true, |(b, _)| size < b) { best = Some((size, sol)); }
            if size <= limit { break; }
            // force a different solution by banning one chosen triple
            let ban = sol & sol.wrapping_neg();
            pool.push(ban);
            continue;
        }
        for v in viol { pool.push(v); }
        pool.sort_by_key(|x| (x.count_ones(), *x));
        pool.dedup();
        if pool.len() > 80_000 { pool.truncate(80_000); }
    }
    match best {
        None => println!("no feasible family found"),
        Some((size, sol)) => {
            let list = bits_to_list(sol, at.tc);
            println!("best size {}: {}", size, triple_strings(&at, &list));
        }
    }
}

// The star-flip lower bound.  For a separating family F on n points and any
// point v, the tests through v must themselves determine v's attachment on the
// other n-1 points, so |F_v| >= g(n-1); summing over v counts each test four
// times, giving |F| >= n g(n-1) / 4.
fn mode_bracket(nmax: usize, g8: Option<usize>, out: Option<String>) {
    // Exact attachment costs, and the entropy floor of one layer otherwise.
    let g_lower = |m: usize| -> (usize, &'static str) {
        match m {
            5 => (9, "exact"),
            6 => (12, "exact"),
            7 => (15, "exact"),
            8 => match g8 { Some(v) => (v, "exact"), None => (entropy_ceil(m - 1), "layer entropy") },
            _ => (entropy_ceil(m - 1), "layer entropy"),
        }
    };
    // Block construction: blocks of four fresh points cost 9 against the gauge
    // point; the leftover 4..7 points use the measured small family.
    let g_upper = |m: usize| -> Option<usize> {
        let small = |s: usize| -> Option<usize> {
            match s { 4 => Some(9), 5 => Some(12), 6 => Some(15), 7 => Some(17), _ => None }
        };
        if (5..=8).contains(&m) { return small(m - 1); }
        let mut best: Option<usize> = None;
        for s in 4..=7 {
            if m < 1 + s { continue; }
            let rest = m - 1 - s;
            if rest % 4 != 0 { continue; }
            let c = 9 * (rest / 4) + small(s).unwrap();
            best = Some(match best { None => c, Some(b) => b.min(c) });
        }
        best
    };
    let mut rows: Vec<String> = Vec::new();
    let mut total = 30usize;
    for n in 7..=nmax {
        if n > 7 { total += g_upper(n - 1).expect("no block bound"); }
        let d = (n - 1) * (n - 2) / 2;
        let floor = entropy_ceil(d - 1);
        let (gl, prov) = g_lower(n - 1);
        let star = (n * gl + 3) / 4; // ceiling
        rows.push(format!(
            "    {{\"n\": {}, \"entropy_floor\": {}, \"star_flip_bound\": {}, \"star_flip_uses_g\": {}, \"star_flip_provenance\": \"{}\", \"best_lower_bound\": {}, \"block_construction\": {}}}",
            n, floor, star, gl, prov, floor.max(star), total));
    }
    let body = format!(
        "{{\n  \"mode\": \"bracket\",\n  \"g8_assumed\": {},\n  \"rows\": [\n{}\n  ]\n}}",
        match g8 { Some(v) => v.to_string(), None => "null".to_string() },
        rows.join(",\n"));
    write_out(&out, &body);
}

// The covering subproblem behind every "the no-answers must cover what the
// yes-answers left" lower bound.  Every alignment test's flat is a LINEAR
// codimension-two subspace containing the complementation vector, so after
// quotienting by it separation asks: cover F_2^m minus a single point by
// codimension-two linear subspaces.  c2(m) is the least number that can.
// Also reports that seven such subspaces cover the whole space for every m,
// which is why a counting or random-covering estimate says nothing here.
fn mode_flatcover(m: usize, out: Option<String>) {
    assert!((2..=7).contains(&m), "universe must fit a u128");
    let n = 1usize << m;
    let v = 1usize; // the point to leave uncovered
    // universe: all x except 0 and v
    let mut uidx = vec![usize::MAX; n];
    let mut univ: Vec<usize> = Vec::new();
    for x in 0..n {
        if x != 0 && x != v { uidx[x] = univ.len(); univ.push(x); }
    }
    let dot = |a: usize, b: usize| -> usize { (a & b).count_ones() as usize & 1 };
    // candidate flats: 2-subspaces D of the dual, indexed by their perp
    let mut sets: Vec<u128> = Vec::new();
    let mut seen: HashSet<Vec<usize>> = HashSet::new();
    for a in 1..n {
        for b in (a + 1)..n {
            if b == (a ^ b) || (a ^ b) == 0 { continue; }
            let d = [a, b, a ^ b];
            let mut key = d.to_vec();
            key.sort();
            if !seen.insert(key) { continue; }
            // D must not be contained in v^perp, else v gets covered
            if d.iter().all(|&z| dot(z, v) == 0) { continue; }
            let mut s: u128 = 0;
            for &x in &univ {
                if d.iter().all(|&z| dot(z, x) == 0) { s |= 1u128 << uidx[x]; }
            }
            sets.push(s);
        }
    }
    sets.sort();
    sets.dedup();
    let full: u128 = if univ.len() == 128 { !0 } else { (1u128 << univ.len()) - 1 };
    // exact minimum cover by iterative deepening
    fn cover(sets: &[u128], have: u128, full: u128, depth: usize, limit: usize,
             maxsize: u32, nodes: &mut u64) -> bool {
        *nodes += 1;
        if have == full { return true; }
        if depth == limit { return false; }
        let missing = full & !have;
        // no set covers more than maxsize elements, so this many rounds remain
        let need = (missing.count_ones() + maxsize - 1) / maxsize;
        if depth + need as usize > limit { return false; }
        let low = missing & missing.wrapping_neg();
        for &s in sets {
            if s & low != 0
                && cover(sets, have | s, full, depth + 1, limit, maxsize, nodes) {
                return true;
            }
        }
        false
    }
    let maxsize = sets.iter().map(|s| s.count_ones()).max().unwrap_or(1);
    let mut answer = usize::MAX;
    let mut nodes = 0u64;
    for k in 1..=12 {
        if cover(&sets, 0, full, 0, k, maxsize, &mut nodes) { answer = k; break; }
    }
    // the seven 2-subspaces of a fixed 3-space in the dual cover everything
    let seven_covers_all = if m >= 3 {
        let u = [1usize, 2, 4];
        let mut cov: u128 = 0;
        let mut hit_all = true;
        for a in 1..8usize {
            for b in (a + 1)..8usize {
                let da = (0..3).filter(|&i| a >> i & 1 == 1).fold(0, |acc, i| acc ^ u[i]);
                let db = (0..3).filter(|&i| b >> i & 1 == 1).fold(0, |acc, i| acc ^ u[i]);
                if da == db || da == 0 || db == 0 { continue; }
                for &x in &univ {
                    if dot(da, x) == 0 && dot(db, x) == 0 { cov |= 1u128 << uidx[x]; }
                }
            }
        }
        // also check v itself is covered by that arrangement
        let mut vcov = false;
        for a in 1..8usize {
            for b in (a + 1)..8usize {
                let da = (0..3).filter(|&i| a >> i & 1 == 1).fold(0, |acc, i| acc ^ u[i]);
                let db = (0..3).filter(|&i| b >> i & 1 == 1).fold(0, |acc, i| acc ^ u[i]);
                if da == db || da == 0 || db == 0 { continue; }
                if dot(da, v) == 0 && dot(db, v) == 0 { vcov = true; }
            }
        }
        hit_all &= cov == full && vcov;
        hit_all
    } else { false };
    let body = format!(
        "{{\n  \"mode\": \"flatcover\",\n  \"m\": {},\n  \"universe\": {},\n  \"candidate_flats\": {},\n  \"c2\": {},\n  \"polynomial_bound_m_over_2\": {},\n  \"seven_flats_of_a_three_space_cover_everything\": {},\n  \"search_nodes\": {}\n}}",
        m, univ.len(), sets.len(), answer, (m + 1) / 2, seven_covers_all, nodes);
    write_out(&out, &body);
}

// The affine covering constant.  Inside one attachment layer a test's yes-set
// is an AFFINE codimension-two flat (its two conditions have known nonzero
// targets), so the all-no instance asks: cover F_2^m minus the origin by
// codimension-two affine flats, none of which contains the origin.  c2aff(m)
// is the least number.  The pairing construction gives 3*ceil(m/2), and the
// polynomial method gives m/2; this mode computes the exact value.
fn mode_affcover(m: usize, out: Option<String>) {
    assert!((2..=6).contains(&m), "universe must fit a u128");
    let n = 1usize << m;
    let univ: Vec<usize> = (1..n).collect();
    let mut uidx = vec![usize::MAX; n];
    for (i, &x) in univ.iter().enumerate() { uidx[x] = i; }
    let dot = |a: usize, b: usize| -> usize { (a & b).count_ones() as usize & 1 };
    // a flat is {x : <a,x> = s, <b,x> = t} with a,b independent and (s,t) != (0,0)
    let mut sets: HashSet<u128> = HashSet::new();
    for a in 1..n {
        for b in (a + 1)..n {
            if a == b { continue; }
            for st in 1..4usize {
                let (s, t) = (st & 1, (st >> 1) & 1);
                let mut mask: u128 = 0;
                for &x in &univ {
                    if dot(a, x) == s && dot(b, x) == t { mask |= 1u128 << uidx[x]; }
                }
                if mask != 0 { sets.insert(mask); }
            }
        }
    }
    let mut sets: Vec<u128> = sets.into_iter().collect();
    sets.sort();
    let full: u128 = if univ.len() == 128 { !0 } else { (1u128 << univ.len()) - 1 };
    let maxsize = sets.iter().map(|s| s.count_ones()).max().unwrap_or(1);
    fn cover(sets: &[u128], have: u128, full: u128, depth: usize, limit: usize,
             maxsize: u32, nodes: &mut u64) -> bool {
        *nodes += 1;
        if have == full { return true; }
        if depth == limit { return false; }
        let missing = full & !have;
        let need = (missing.count_ones() + maxsize - 1) / maxsize;
        if depth + need as usize > limit { return false; }
        let low = missing & missing.wrapping_neg();
        for &s in sets {
            if s & low != 0
                && cover(sets, have | s, full, depth + 1, limit, maxsize, nodes) {
                return true;
            }
        }
        false
    }
    let mut answer = usize::MAX;
    let mut nodes = 0u64;
    for k in 1..=(3 * m) {
        if cover(&sets, 0, full, 0, k, maxsize, &mut nodes) { answer = k; break; }
    }
    // the pairing construction, checked
    // Pair the coordinates and take the three nonzero patterns on each pair;
    // an odd leftover coordinate i is covered by {x_i = 1, x_j = s}, s = 0, 1.
    let mut cov: u128 = 0;
    let mut pairing = 0usize;
    let mut add = |a: usize, s: usize, b: usize, t: usize,
                   cov: &mut u128, pairing: &mut usize| {
        for &x in &univ {
            if dot(a, x) == s && dot(b, x) == t { *cov |= 1u128 << uidx[x]; }
        }
        *pairing += 1;
    };
    let mut i = 0;
    while i + 1 < m {
        for st in 1..4usize {
            add(1 << i, st & 1, 1 << (i + 1), (st >> 1) & 1, &mut cov, &mut pairing);
        }
        i += 2;
    }
    if i < m {
        let j = if i == 0 { 0 } else { 0 };
        let other = if m > 1 { if i == 0 { 1 } else { 0 } } else { i };
        let _ = j;
        add(1 << i, 1, 1 << other, 0, &mut cov, &mut pairing);
        add(1 << i, 1, 1 << other, 1, &mut cov, &mut pairing);
    }
    let body = format!(
        "{{\n  \"mode\": \"affcover\",\n  \"m\": {},\n  \"universe\": {},\n  \"candidate_flats\": {},\n  \"c2aff\": {},\n  \"polynomial_bound_ceil_m_over_2\": {},\n  \"pairing_construction\": {},\n  \"pairing_covers_all\": {},\n  \"search_nodes\": {}\n}}",
        m, univ.len(), sets.len(), answer, (m + 1) / 2, pairing, cov == full, nodes);
    write_out(&out, &body);
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("usage: c880cpb <selfcheck|masks|lb|verify|search|bracket> [options]");
        process::exit(2);
    }
    let getopt = |name: &str| -> Option<String> {
        args.iter().position(|a| a == name).and_then(|i| args.get(i + 1)).cloned()
    };
    let out = getopt("--out");
    let num = |name: &str, dflt: u64| -> u64 {
        getopt(name).map(|v| v.parse().unwrap()).unwrap_or(dflt)
    };
    match args[1].as_str() {
        "selfcheck" => mode_selfcheck(),
        "masks" => mode_masks(num("--m", 0) as usize, num("--stride", 1),
                              num("--maxweight", 128) as u32,
                              num("--pool", u64::MAX / 2) as usize, out),
        "lb" => mode_lb(num("--m", 0) as usize, num("--stride", 1),
                        num("--maxweight", 128) as u32,
                        num("--pool", u64::MAX / 2) as usize, out),
        "verify" => mode_verify(num("--m", 0) as usize,
                                &getopt("--family").expect("--family"), out),
        "search" => mode_search(num("--m", 0) as usize, num("--limit", 1) as usize,
                                num("--stride", 1), num("--rounds", 200) as usize),
        "flatcover" => mode_flatcover(num("--m", 0) as usize, out),
        "affcover" => mode_affcover(num("--m", 0) as usize, out),
        "bracket" => mode_bracket(num("--nmax", 40) as usize,
                                  getopt("--g8").map(|v| v.parse().unwrap()), out),
        other => { eprintln!("unknown mode {}", other); process::exit(2); }
    }
}
