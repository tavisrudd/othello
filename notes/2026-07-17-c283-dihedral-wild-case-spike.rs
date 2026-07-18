// C283 -- wild-case scoping spike for the dihedral Schreier Node-Kayles paper.
//
// The manuscript's tame hypothesis is p \nmid 2m (Section 14, D_{2m} family;
// Sections 4-13, triple family D_{4n}). This script enumerates the WILD
// residual examples the paper excludes: legal pairs of off-conic points
// {x,y} whose induced involutions sigma_x, sigma_y in PGL_2(p) have a product
// r = sigma_x sigma_y of order m divisible by p.
//
// It records, for every wild pair over q = p in a small prime range:
//   - m = ord(r) and the assertion that m == p (the wild collapse);
//   - the group order |<sigma_x,sigma_y>| (must be 2p, dihedral);
//   - |Fix(sigma_x)|, |Fix(sigma_y)| on P^1 (reflection fixed points);
//   - |Fix(r)| on P^1 (rotation fixed points: 1 = unipotent, vs tame 0 or 2);
//   - |D_S| = |Fix(r)| deleted-set size (odd = 1, breaks the tame even pattern);
//   - whether the whole group has a GLOBAL fixed point on P^1 (reducible/Borel);
//   - the G-orbit sizes and stabilizer orders on P^1;
//   - the residual graph R_S structure (component count, degree sequence,
//     whether it is a single path P_p) and its Node-Kayles value NK(R_S),
//     compared to the Dawson value A002187(p).
//
// Grundy core is identical to notes/2026-07-17-c263-dihedral-pair-templates.rs
// (component-decomposed memoized Sprague-Grundy on <=64-vtx bitmasks), no
// canonicalization group.
//
// Output: deterministic JSON to arg 1; human summary on stdout. No timestamps.

use std::collections::HashMap;

// ---------- Grundy core (identical to C263) ----------
fn component(mask: u64, start: u64, adj: &[u64]) -> u64 {
    let mut comp = start;
    loop {
        let mut nb = 0u64;
        let mut b = comp;
        while b != 0 {
            let v = b.trailing_zeros() as usize;
            nb |= adj[v];
            b &= b - 1;
        }
        let new = comp | (nb & mask);
        if new == comp {
            return comp;
        }
        comp = new;
    }
}
fn grundy(mask: u64, adj: &[u64], closed: &[u64], memo: &mut HashMap<u64, u8>) -> u8 {
    if mask == 0 {
        return 0;
    }
    let mut rem = mask;
    let mut g = 0u8;
    while rem != 0 {
        let start = rem & rem.wrapping_neg();
        let comp = component(rem, start, adj);
        g ^= grundy_conn(comp, adj, closed, memo);
        rem &= !comp;
    }
    g
}
fn grundy_conn(mask: u64, adj: &[u64], closed: &[u64], memo: &mut HashMap<u64, u8>) -> u8 {
    if let Some(&v) = memo.get(&mask) {
        return v;
    }
    let mut opts = 0u64;
    let mut b = mask;
    while b != 0 {
        let v = b.trailing_zeros() as usize;
        let child = mask & !closed[v];
        let cg = grundy(child, adj, closed, memo);
        opts |= 1u64 << cg;
        b &= b - 1;
    }
    let m = (!opts).trailing_zeros() as u8;
    memo.insert(mask, m);
    m
}
fn nk_graph(n: usize, edges: &[(usize, usize)]) -> u8 {
    let mut adj = vec![0u64; n.max(1)];
    for &(u, v) in edges {
        if u != v {
            adj[u] |= 1u64 << v;
            adj[v] |= 1u64 << u;
        }
    }
    let closed: Vec<u64> = (0..n).map(|x| adj[x] | (1u64 << x)).collect();
    let full = if n == 0 {
        0
    } else if n == 64 {
        u64::MAX
    } else {
        (1u64 << n) - 1
    };
    let mut memo: HashMap<u64, u8> = HashMap::new();
    grundy(full, &adj, &closed, &mut memo)
}
fn nk_path(n: usize) -> u8 {
    if n == 0 {
        return 0;
    }
    let edges: Vec<(usize, usize)> = (0..n.saturating_sub(1)).map(|i| (i, i + 1)).collect();
    nk_graph(n, &edges)
}

// ---------- prime field / projective line (identical to C263) ----------
fn egcd(a: i64, b: i64) -> (i64, i64, i64) {
    if b == 0 {
        (a, 1, 0)
    } else {
        let (g, x, y) = egcd(b, a % b);
        (g, y, x - (a / b) * y)
    }
}
fn inv_mod(a: i64, p: i64) -> i64 {
    let (_, x, _) = egcd(((a % p) + p) % p, p);
    ((x % p) + p) % p
}
fn mobius(mat: (i64, i64, i64, i64), t: usize, p: i64) -> usize {
    let (a, b, c, d) = mat;
    let pinf = p as usize;
    if t == pinf {
        if c % p == 0 {
            pinf
        } else {
            (((a * inv_mod(c, p)) % p + p) % p) as usize
        }
    } else {
        let t = t as i64;
        let num = (a * t + b) % p;
        let den = (c * t + d) % p;
        if den % p == 0 {
            pinf
        } else {
            ((((num % p) + p) % p * inv_mod(den, p)) % p) as usize
        }
    }
}
fn all_involutions(p: i64) -> Vec<Vec<usize>> {
    let n = (p + 1) as usize;
    let mut seen = std::collections::HashSet::new();
    let mut out = Vec::new();
    let pu = p as i64;
    let mut pts: Vec<(i64, i64, i64)> = Vec::new();
    for b in 0..pu {
        for c in 0..pu {
            pts.push((1, b, c));
        }
    }
    for c in 0..pu {
        pts.push((0, 1, c));
    }
    pts.push((0, 0, 1));
    for (a, b, c) in pts {
        if ((a * c - b * b) % pu + pu) % pu == 0 {
            continue;
        }
        let mat = (b, ((-a) % pu + pu) % pu, c, ((-b) % pu + pu) % pu);
        let perm: Vec<usize> = (0..n).map(|t| mobius(mat, t, pu)).collect();
        if seen.insert(perm.clone()) {
            out.push(perm);
        }
    }
    out
}
fn compose(f: &[usize], g: &[usize]) -> Vec<usize> {
    g.iter().map(|&x| f[x]).collect()
}
fn perm_order(p: &[usize]) -> usize {
    let id: Vec<usize> = (0..p.len()).collect();
    let mut x = p.to_vec();
    let mut o = 1;
    while x != id {
        x = compose(p, &x);
        o += 1;
    }
    o
}
fn fixed(p: &[usize]) -> Vec<usize> {
    (0..p.len()).filter(|&i| p[i] == i).collect()
}

struct Rep {
    q: i64,
    m: usize,
    group_order: usize,
    fix_sx: usize,
    fix_sy: usize,
    fix_r: usize,
    del_size: usize,
    global_fixed: usize, // number of points fixed by the WHOLE group
    orbit_sizes: Vec<usize>,
    orbit_stabs: Vec<usize>,
    residual_vertices: usize,
    residual_components: usize,
    deg1: usize,
    deg2: usize,
    is_single_path: bool,
    nk_direct: u8,
    dawson_p: u8,
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let outpath = args
        .get(1)
        .cloned()
        .unwrap_or_else(|| "2026-07-17-c283-dihedral-wild-case-spike.json".to_string());
    let primes: Vec<i64> = if args.len() > 2 {
        args[2..].iter().map(|s| s.parse().unwrap()).collect()
    } else {
        vec![3, 5, 7, 11, 13]
    };

    let mut total_pairs = 0u64;
    let mut wild_pairs = 0u64;
    let mut m_neq_p = 0u64; // count of wild pairs where m != p (should be 0)
    let mut order_neq_2p = 0u64; // group order != 2p among wild (should be 0)
    let mut not_single_path = 0u64; // residual not one path P_p (should be 0)
    let mut nk_neq_dawson = 0u64; // NK(R_S) != A002187(p) (should be 0)
    let mut global_fix_not_1 = 0u64; // whole-group fixed points != 1 among wild
    let mut fix_r_hist: std::collections::BTreeMap<usize, u64> = std::collections::BTreeMap::new();
    let mut del_hist: std::collections::BTreeMap<usize, u64> = std::collections::BTreeMap::new();
    let mut reps: Vec<Rep> = Vec::new();
    let mut seen_rep: std::collections::HashSet<i64> = std::collections::HashSet::new();

    for &p in &primes {
        let n = (p + 1) as usize;
        let invs = all_involutions(p);
        let ninv = invs.len();
        for i in 0..ninv {
            for j in (i + 1)..ninv {
                total_pairs += 1;
                let s = &invs[i];
                let t = &invs[j];
                let st = compose(s, t); // r = sigma_x sigma_y
                let m = perm_order(&st);
                if m < 2 {
                    continue;
                }
                if (p % (m as i64)) != 0 {
                    continue; // tame -> covered by manuscript / C263
                }
                // WILD: p | m
                wild_pairs += 1;
                if m != p as usize {
                    m_neq_p += 1;
                }
                // group closure
                let mut group: Vec<Vec<usize>> = vec![(0..n).collect()];
                let mut set: std::collections::HashSet<Vec<usize>> = std::collections::HashSet::new();
                set.insert((0..n).collect());
                let gens = [s.clone(), t.clone()];
                let mut k = 0;
                while k < group.len() {
                    let g = group[k].clone();
                    for gen in &gens {
                        let h = compose(&g, gen);
                        if set.insert(h.clone()) {
                            group.push(h);
                        }
                    }
                    k += 1;
                }
                let order = group.len();
                if order != 2 * (p as usize) {
                    order_neq_2p += 1;
                }
                let fix_sx = fixed(s).len();
                let fix_sy = fixed(t).len();
                let fr = fixed(&st);
                let fix_r = fr.len();
                *fix_r_hist.entry(fix_r).or_insert(0) += 1;
                let del: std::collections::HashSet<usize> = fr.iter().cloned().collect();
                *del_hist.entry(del.len()).or_insert(0) += 1;

                // global fixed points of the whole group
                let global_fixed = (0..n)
                    .filter(|&x| group.iter().all(|g| g[x] == x))
                    .count();
                if global_fixed != 1 {
                    global_fix_not_1 += 1;
                }

                // orbit decomposition
                let mut orbit_of = vec![usize::MAX; n];
                let mut orbits: Vec<Vec<usize>> = Vec::new();
                for start in 0..n {
                    if orbit_of[start] != usize::MAX {
                        continue;
                    }
                    let oid = orbits.len();
                    let mut orb = vec![start];
                    orbit_of[start] = oid;
                    let mut qi = 0;
                    while qi < orb.len() {
                        let v = orb[qi];
                        for g in &group {
                            let w = g[v];
                            if orbit_of[w] == usize::MAX {
                                orbit_of[w] = oid;
                                orb.push(w);
                            }
                        }
                        qi += 1;
                    }
                    orbits.push(orb);
                }
                let orbit_sizes: Vec<usize> = orbits.iter().map(|o| o.len()).collect();
                let orbit_stabs: Vec<usize> = orbits.iter().map(|o| order / o.len()).collect();

                // residual R_S on P^1 \ del
                let live: Vec<usize> = (0..n).filter(|x| !del.contains(x)).collect();
                let idx: HashMap<usize, usize> =
                    live.iter().cloned().enumerate().map(|(a, b)| (b, a)).collect();
                let mut edge_set: std::collections::HashSet<(usize, usize)> =
                    std::collections::HashSet::new();
                for &u in &live {
                    for gen in &[s, t] {
                        let w = gen[u];
                        if w != u && !del.contains(&w) {
                            let (a, b) = (idx[&u], idx[&w]);
                            let e = if a < b { (a, b) } else { (b, a) };
                            edge_set.insert(e);
                        }
                    }
                }
                let edges: Vec<(usize, usize)> = edge_set.iter().cloned().collect();
                let nv = live.len();
                // degree sequence
                let mut deg = vec![0usize; nv];
                for &(a, b) in &edges {
                    deg[a] += 1;
                    deg[b] += 1;
                }
                let deg1 = deg.iter().filter(|&&d| d == 1).count();
                let deg2 = deg.iter().filter(|&&d| d == 2).count();
                // component count (union-find)
                let mut parent: Vec<usize> = (0..nv).collect();
                fn find(parent: &mut Vec<usize>, x: usize) -> usize {
                    let mut r = x;
                    while parent[r] != r {
                        r = parent[r];
                    }
                    let mut c = x;
                    while parent[c] != r {
                        let nxt = parent[c];
                        parent[c] = r;
                        c = nxt;
                    }
                    r
                }
                for &(a, b) in &edges {
                    let ra = find(&mut parent, a);
                    let rb = find(&mut parent, b);
                    if ra != rb {
                        parent[ra] = rb;
                    }
                }
                let ncomp = (0..nv).filter(|&x| find(&mut parent, x) == x).count();
                let is_single_path =
                    ncomp == 1 && deg1 == 2 && deg1 + deg2 == nv && nv == p as usize;
                if !is_single_path {
                    not_single_path += 1;
                }
                let nk_direct = nk_graph(nv, &edges);
                let dawson_p = nk_path(p as usize);
                if nk_direct != dawson_p {
                    nk_neq_dawson += 1;
                }

                if seen_rep.insert(p) {
                    reps.push(Rep {
                        q: p,
                        m,
                        group_order: order,
                        fix_sx,
                        fix_sy,
                        fix_r,
                        del_size: del.len(),
                        global_fixed,
                        orbit_sizes,
                        orbit_stabs,
                        residual_vertices: nv,
                        residual_components: ncomp,
                        deg1,
                        deg2,
                        is_single_path,
                        nk_direct,
                        dawson_p,
                    });
                }
            }
        }
    }

    // ---- JSON ----
    let mut out = String::new();
    out.push_str("{\n");
    out.push_str("  \"task\": \"C283\",\n");
    out.push_str("  \"generated\": \"wild-case (p|2m) dihedral residual scoping spike\",\n");
    out.push_str(&format!("  \"primes\": {:?},\n", primes));
    out.push_str(&format!("  \"total_pairs\": {},\n", total_pairs));
    out.push_str(&format!("  \"wild_pairs\": {},\n", wild_pairs));
    out.push_str(&format!("  \"wild_pairs_with_m_neq_p\": {},\n", m_neq_p));
    out.push_str(&format!(
        "  \"wild_pairs_group_order_neq_2p\": {},\n",
        order_neq_2p
    ));
    out.push_str(&format!(
        "  \"wild_pairs_global_fix_neq_1\": {},\n",
        global_fix_not_1
    ));
    out.push_str(&format!(
        "  \"wild_pairs_residual_not_single_path_P_p\": {},\n",
        not_single_path
    ));
    out.push_str(&format!(
        "  \"wild_pairs_NK_neq_dawson_p\": {},\n",
        nk_neq_dawson
    ));
    let frh: Vec<String> = fix_r_hist.iter().map(|(k, v)| format!("\"{}\":{}", k, v)).collect();
    out.push_str(&format!(
        "  \"rotation_fixed_point_count_histogram\": {{{}}},\n",
        frh.join(",")
    ));
    let dh: Vec<String> = del_hist.iter().map(|(k, v)| format!("\"{}\":{}", k, v)).collect();
    out.push_str(&format!(
        "  \"deleted_set_size_histogram\": {{{}}},\n",
        dh.join(",")
    ));
    out.push_str("  \"representatives\": [\n");
    for (i, r) in reps.iter().enumerate() {
        out.push_str(&format!(
            "    {{\"q\":{},\"m\":{},\"group_order\":{},\"fix_sigma_x\":{},\"fix_sigma_y\":{},\"fix_rotation\":{},\"deleted_set_size\":{},\"whole_group_fixed_points\":{},\"orbit_sizes\":{:?},\"orbit_stabilizers\":{:?},\"residual_vertices\":{},\"residual_components\":{},\"deg1\":{},\"deg2\":{},\"is_single_path_P_p\":{},\"NK_residual\":{},\"dawson_A002187_p\":{}}}{}\n",
            r.q, r.m, r.group_order, r.fix_sx, r.fix_sy, r.fix_r, r.del_size,
            r.global_fixed, r.orbit_sizes, r.orbit_stabs, r.residual_vertices,
            r.residual_components, r.deg1, r.deg2, r.is_single_path, r.nk_direct, r.dawson_p,
            if i + 1 < reps.len() { "," } else { "" }
        ));
    }
    out.push_str("  ]\n}\n");
    std::fs::write(&outpath, &out).expect("write json");

    println!("=== C283 wild-case (p|2m) dihedral spike ===");
    println!("primes: {:?}", primes);
    println!("total pairs={}  wild pairs (p|m)={}", total_pairs, wild_pairs);
    println!("wild pairs with m != p:               {}", m_neq_p);
    println!("wild pairs with group order != 2p:    {}", order_neq_2p);
    println!("wild pairs with whole-group fix != 1: {}", global_fix_not_1);
    println!("wild residuals not a single path P_p: {}", not_single_path);
    println!("wild NK(R_S) != Dawson A002187(p):    {}", nk_neq_dawson);
    println!("rotation |Fix| histogram: {:?}", fix_r_hist);
    println!("deleted-set-size histogram: {:?}", del_hist);
    for r in &reps {
        println!(
            "q={p} m={m} |G|={o} |Fix sx|={fx} |Fix sy|={fy} |Fix r|={fr} |D_S|={ds} globalFix={gf} orbits(sizes={os:?} stabs={ost:?}) residual: V={rv} comp={rc} deg1={d1} deg2={d2} singlePath={sp} NK={nk} Dawson(p)={dw}",
            p = r.q, m = r.m, o = r.group_order, fx = r.fix_sx, fy = r.fix_sy,
            fr = r.fix_r, ds = r.del_size, gf = r.global_fixed, os = r.orbit_sizes,
            ost = r.orbit_stabs, rv = r.residual_vertices, rc = r.residual_components,
            d1 = r.deg1, d2 = r.deg2, sp = r.is_single_path, nk = r.nk_direct, dw = r.dawson_p
        );
    }
    println!("wrote {}", outpath);
}
