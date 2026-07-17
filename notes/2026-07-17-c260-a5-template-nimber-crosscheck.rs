// C260 independent cross-check (fast backstop) of A5/S4 regular-template Node-Kayles nimbers.
//
// This is an INDEPENDENT reimplementation, written fresh for C260, NOT derived from
// rust/scripts/nodekayles_cayley.rs.
//
//   * Necessarily SHARED: the graph definition. The template is the cubic Cayley graph
//     Cay(G,T) (one vertex per group element, an edge {g, g*t} per involution t in T).
//     This program rebuilds it with the same composition convention and the same
//     first-triple-per-pairwise-order-signature selection, so it evaluates the SAME graphs.
//
//   * INDEPENDENT: fresh solver code, and a deliberately DIFFERENT canonicalization -- the
//     memo key is the orbit minimum of a connected component's bitmask under the
//     left-regular representation of G ONLY (|G| permutations). The reference Rust solver
//     additionally minimises over the color-permuting conjugation stabiliser of T, so for
//     every class whose signature has a repeated order (all A5 classes except (2,3,5)) this
//     program uses a strictly SMALLER canonicalization group and therefore performs a
//     genuinely different computation, reaching more memo states and canonicalising them by
//     a different key. (For (2,3,5) that stabiliser is already trivial, so the group
//     coincides and this class is covered independently by the companion Python BLISS
//     per-subgraph-isomorphism solver.)
//
// Left multiplication L_g : h |-> g*h is an automorphism of the right Cayley graph, so
// orbit-min under {L_g} is a sound value-preserving canonicalization. Grundy of a
// disconnected position = XOR of component Grundies (Sprague-Grundy sum).
//
// Build & run (from repo rust/):
//   rustc -O ../notes/2026-07-17-c260-a5-template-nimber-crosscheck.rs -o /tmp/c260nk
//   /tmp/c260nk S4            # 4 classes -> 0
//   /tmp/c260nk A5            # 5 classes
//   /tmp/c260nk A5 5,5,5      # one class by signature
//   /tmp/c260nk json         # canonical JSON of all S4+A5 class values to stdout

use std::collections::HashMap;

fn mul(p: &[u32], q: &[u32]) -> Vec<u32> {
    (0..q.len()).map(|i| p[q[i] as usize]).collect()
}
fn is_ident(p: &[u32]) -> bool {
    p.iter().enumerate().all(|(i, &x)| i as u32 == x)
}
fn perm_order(p: &[u32]) -> u32 {
    let mut x = p.to_vec();
    let mut o = 1u32;
    while !is_ident(&x) {
        x = mul(p, &x);
        o += 1;
    }
    o
}
fn sign(p: &[u32]) -> i32 {
    let mut inv = 0;
    for i in 0..p.len() {
        for j in (i + 1)..p.len() {
            if p[i] > p[j] {
                inv += 1;
            }
        }
    }
    if inv % 2 == 0 {
        1
    } else {
        -1
    }
}
fn all_perms(n: usize) -> Vec<Vec<u32>> {
    // same swap-recursion order as the reference, so element indexing matches
    let mut v: Vec<u32> = (0..n as u32).collect();
    let mut out = Vec::new();
    fn rec(v: &mut Vec<u32>, k: usize, out: &mut Vec<Vec<u32>>) {
        if k == v.len() {
            out.push(v.clone());
            return;
        }
        for i in k..v.len() {
            v.swap(k, i);
            rec(v, k + 1, out);
            v.swap(k, i);
        }
    }
    rec(&mut v, 0, &mut out);
    out
}
fn closure(gens: &[Vec<u32>], n: usize) -> Vec<Vec<u32>> {
    let ident: Vec<u32> = (0..n as u32).collect();
    let mut seen: std::collections::HashSet<Vec<u32>> = std::collections::HashSet::new();
    seen.insert(ident.clone());
    let mut frontier = vec![ident];
    while let Some(g) = frontier.pop() {
        for s in gens {
            let h = mul(&g, s);
            if seen.insert(h.clone()) {
                frontier.push(h);
            }
        }
    }
    let mut v: Vec<Vec<u32>> = seen.into_iter().collect();
    v.sort();
    v
}

fn component(rem: u64, start: u64, adj: &[u64]) -> u64 {
    let mut comp = start;
    loop {
        let mut nb = 0u64;
        let mut b = comp;
        while b != 0 {
            let v = b.trailing_zeros() as usize;
            nb |= adj[v];
            b &= b - 1;
        }
        let new = comp | (nb & rem);
        if new == comp {
            return comp;
        }
        comp = new;
    }
}
#[inline]
fn apply_perm(mask: u64, perm: &[u32]) -> u64 {
    let mut r = 0u64;
    let mut b = mask;
    while b != 0 {
        let v = b.trailing_zeros() as usize;
        r |= 1u64 << perm[v];
        b &= b - 1;
    }
    r
}
#[inline]
fn canonical(mask: u64, perms: &[Vec<u32>]) -> u64 {
    let mut best = mask;
    for p in perms {
        let m = apply_perm(mask, p);
        if m < best {
            best = m;
        }
    }
    best
}
fn grundy(mask: u64, adj: &[u64], closed: &[u64], perms: &[Vec<u32>], memo: &mut HashMap<u64, u8>) -> u8 {
    if mask == 0 {
        return 0;
    }
    let mut rem = mask;
    let mut g = 0u8;
    while rem != 0 {
        let start = rem & rem.wrapping_neg();
        let comp = component(rem, start, adj);
        g ^= grundy_conn(comp, adj, closed, perms, memo);
        rem &= !comp;
    }
    g
}
fn grundy_conn(mask: u64, adj: &[u64], closed: &[u64], perms: &[Vec<u32>], memo: &mut HashMap<u64, u8>) -> u8 {
    let key = canonical(mask, perms);
    if let Some(&v) = memo.get(&key) {
        return v;
    }
    let mut opts = 0u64;
    let mut b = mask;
    while b != 0 {
        let v = b.trailing_zeros() as usize;
        let child = mask & !closed[v];
        let cg = grundy(child, adj, closed, perms, memo);
        opts |= 1u64 << cg;
        b &= b - 1;
    }
    let m = (!opts).trailing_zeros() as u8;
    memo.insert(key, m);
    m
}

struct ClassResult {
    sig: [u32; 3],
    vertices: usize,
    edges: usize,
    grundy: u8,
    memo_states: usize,
}

fn build_reps(n: usize, even_only: bool) -> Vec<([u32; 3], [Vec<u32>; 3])> {
    let target = if even_only { fact(n) / 2 } else { fact(n) };
    let els: Vec<Vec<u32>> = all_perms(n)
        .into_iter()
        .filter(|p| !even_only || sign(p) == 1)
        .collect();
    let invols: Vec<Vec<u32>> = els
        .iter()
        .filter(|p| !is_ident(p) && is_ident(&mul(p, p)))
        .cloned()
        .collect();
    let mut reps: std::collections::BTreeMap<[u32; 3], [Vec<u32>; 3]> = std::collections::BTreeMap::new();
    for i in 0..invols.len() {
        for j in (i + 1)..invols.len() {
            for k in (j + 1)..invols.len() {
                let tri = [invols[i].clone(), invols[j].clone(), invols[k].clone()];
                if closure(&tri, n).len() != target {
                    continue;
                }
                let mut sig = [
                    perm_order(&mul(&tri[0], &tri[1])),
                    perm_order(&mul(&tri[0], &tri[2])),
                    perm_order(&mul(&tri[1], &tri[2])),
                ];
                sig.sort();
                reps.entry(sig).or_insert(tri);
            }
        }
    }
    reps.into_iter().collect()
}

fn solve_class(n: usize, tri: &[Vec<u32>; 3]) -> ClassResult {
    let group = closure(tri, n);
    let idx: HashMap<Vec<u32>, usize> = group.iter().cloned().enumerate().map(|(i, g)| (g, i)).collect();
    let v = group.len();
    let mut adj = vec![0u64; v];
    for g in &group {
        let i = idx[g];
        for t in tri.iter() {
            let h = mul(g, t);
            let j = idx[&h];
            if i != j {
                adj[i] |= 1u64 << j;
                adj[j] |= 1u64 << i;
            }
        }
    }
    let edges: usize = adj.iter().map(|a| a.count_ones() as usize).sum::<usize>() / 2;
    let closed: Vec<u64> = (0..v).map(|x| adj[x] | (1u64 << x)).collect();
    // left-regular representation ONLY (|G| permutations): perm_g[idx[h]] = idx[g*h]
    let perms: Vec<Vec<u32>> = group
        .iter()
        .map(|g| group.iter().map(|h| idx[&mul(g, h)] as u32).collect())
        .collect();
    let sig = {
        let mut s = [
            perm_order(&mul(&tri[0], &tri[1])),
            perm_order(&mul(&tri[0], &tri[2])),
            perm_order(&mul(&tri[1], &tri[2])),
        ];
        s.sort();
        s
    };
    let full = if v == 64 { u64::MAX } else { (1u64 << v) - 1 };
    let mut memo: HashMap<u64, u8> = HashMap::new();
    let val = grundy(full, &adj, &closed, &perms, &mut memo);
    ClassResult {
        sig,
        vertices: v,
        edges,
        grundy: val,
        memo_states: memo.len(),
    }
}

fn fact(n: usize) -> usize {
    (1..=n).product()
}

fn run(name: &str, n: usize, even: bool, filter: Option<[u32; 3]>, json: bool, out: &mut Vec<(String, ClassResult)>) {
    let reps = build_reps(n, even);
    for (sig, tri) in &reps {
        if let Some(f) = filter {
            if *sig != f {
                continue;
            }
        }
        let r = solve_class(n, tri);
        if !json {
            eprintln!(
                "{} sig={:?}: G={} vtx={} edges={} memo_states={}",
                name, r.sig, r.grundy, r.vertices, r.edges, r.memo_states
            );
        }
        out.push((name.to_string(), r));
    }
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let mode = args.get(1).map(|s| s.as_str()).unwrap_or("A5");
    let filter: Option<[u32; 3]> = args.get(2).map(|s| {
        let v: Vec<u32> = s.split(',').map(|x| x.trim().parse().unwrap()).collect();
        [v[0], v[1], v[2]]
    });
    let mut out: Vec<(String, ClassResult)> = Vec::new();
    match mode {
        "S4" => run("S4", 4, false, filter, false, &mut out),
        "A5" => run("A5", 5, true, filter, false, &mut out),
        "json" => {
            run("S4", 4, false, None, true, &mut out);
            run("A5", 5, true, None, true, &mut out);
            // canonical JSON: sorted by (group, sig)
            out.sort_by(|a, b| (a.0.clone(), a.1.sig).cmp(&(b.0.clone(), b.1.sig)));
            println!("{{");
            println!("  \"solver\": \"c260-rust-leftmult-only\",");
            println!("  \"results\": [");
            for (i, (g, r)) in out.iter().enumerate() {
                let comma = if i + 1 < out.len() { "," } else { "" };
                println!(
                    "    {{\"group\": \"{}\", \"sig\": [{}, {}, {}], \"vertices\": {}, \"edges\": {}, \"grundy\": {}}}{}",
                    g, r.sig[0], r.sig[1], r.sig[2], r.vertices, r.edges, r.grundy, comma
                );
            }
            println!("  ]");
            println!("}}");
            return;
        }
        _ => {
            eprintln!("usage: <S4|A5|json> [sig like 5,5,5]");
            return;
        }
    }
}
