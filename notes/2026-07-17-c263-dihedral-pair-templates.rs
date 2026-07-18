// C263 — generalized-D_{2m} (two-reflection / legal-pair) dihedral templates.
//
// Verifies, end to end over odd prime fields, the claim that a legal pair of
// selected off-conic points {x,y} induces a dihedral group D_{2m}
// (m = ord(sigma_x sigma_y)) whose fixed-point-deleted Schreier residual has
// transitive templates
//     free orbit         -> cycle  C_{2m}     (nimber NK(C_{2m}))
//     reflection orbit   -> path   P_m        (nimber NK(P_m) = Dawson A002187)
//     rotation orbit     -> empty  \varnothing (nimber 0)
// and that NK(R_S) = XOR over orbits of the template nimber (Thm 3.1).
//
// Also emits the NK(P_n), NK(C_n) tables and cross-checks:
//   (a) NK(P_n) against hard-coded OEIS A002187 initial terms (Dawson's chess);
//   (b) NK(C_n) = mex{ NK(P_{n-3}) } for n>=3.
//
// Grundy core (component-decomposed memoized Sprague-Grundy on <=64-vtx bitmasks)
// is the same algorithm as rust/scripts/nodekayles_cayley.rs, with no
// canonicalization group (raw-mask memo).
//
// Output: JSON to the path given as arg (default c263-pair-templates.json),
// plus a human summary on stdout.

use std::collections::HashMap;

// ---------- Grundy core ----------
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
// NK value of an explicit simple graph on n<=64 vertices given adjacency lists.
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
fn nk_cycle(n: usize) -> u8 {
    if n < 3 {
        return nk_path(n);
    }
    let mut edges: Vec<(usize, usize)> = (0..n - 1).map(|i| (i, i + 1)).collect();
    edges.push((n - 1, 0));
    nk_graph(n, &edges)
}

// ---------- prime field / projective line ----------
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

// P^1(p): index 0..p-1 = finite field elt, index p = infinity.
// Mobius action of matrix [[A,B],[C,D]] on P^1.
fn mobius(mat: (i64, i64, i64, i64), t: usize, p: i64) -> usize {
    let (a, b, c, d) = mat;
    let pinf = p as usize;
    if t == pinf {
        // limit t->inf : A/C
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

// All involutions of PGL2(p) as permutations of P^1(p): one per off-conic point
// [a:b:c] (conic XZ=Y^2), matrix M=[[b,-a],[c,-b]], sigma(t)=(bt-a)/(ct-b).
fn all_involutions(p: i64) -> Vec<Vec<usize>> {
    let n = (p + 1) as usize;
    let mut seen = std::collections::HashSet::new();
    let mut out = Vec::new();
    // enumerate projective points [a:b:c] normalized (first nonzero coord = 1)
    let pu = p as i64;
    let mut pts: Vec<(i64, i64, i64)> = Vec::new();
    // a=1
    for b in 0..pu {
        for c in 0..pu {
            pts.push((1, b, c));
        }
    }
    // a=0,b=1
    for c in 0..pu {
        pts.push((0, 1, c));
    }
    // a=0,b=0,c=1
    pts.push((0, 0, 1));
    for (a, b, c) in pts {
        if ((a * c - b * b) % pu + pu) % pu == 0 {
            continue; // on conic -> degenerate
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
    // (f after g)
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

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let outpath = args
        .get(1)
        .cloned()
        .unwrap_or_else(|| "c263-pair-templates.json".to_string());
    let primes: Vec<i64> = if args.len() > 2 {
        args[2..].iter().map(|s| s.parse().unwrap()).collect()
    } else {
        vec![5, 7, 11, 13, 17, 19, 23]
    };

    // ---- template nimber tables + cross-checks ----
    let nmax = 60usize;
    let path: Vec<u8> = (0..=nmax).map(nk_path).collect();
    let cyc: Vec<u8> = (0..=nmax).map(nk_cycle).collect();

    // OEIS A002187 (Dawson's chess) initial terms, indexed from n=0:
    let a002187: [u8; 40] = [
        0, 1, 1, 2, 0, 3, 1, 1, 0, 3, 3, 2, 2, 4, 0, 5, 2, 2, 3, 3, 0, 1, 1, 3, 0, 2, 1, 1, 0, 4, 5,
        2, 7, 4, 0, 1, 1, 2, 0, 3,
    ];
    let mut path_ok = true;
    for n in 0..a002187.len() {
        if path[n] != a002187[n] {
            path_ok = false;
            eprintln!(
                "PATH MISMATCH n={} got {} expected {}",
                n, path[n], a002187[n]
            );
        }
    }
    let mut cyc_ok = true;
    for n in 3..=nmax {
        // mex{ NK(P_{n-3}) }
        let x = path[n - 3];
        let mex = if x == 0 { 1 } else { 0 };
        if cyc[n] != mex {
            cyc_ok = false;
            eprintln!("CYCLE MISMATCH n={} got {} mex={}", n, cyc[n], mex);
        }
    }

    // ---- end-to-end conic pair simulation ----
    let mut total_pairs = 0u64;
    let mut checked = 0u64;
    let mut mismatches = 0u64;
    let mut struct_fail = 0u64;
    let mut m_hist: std::collections::BTreeMap<usize, u64> = std::collections::BTreeMap::new();
    let mut val_hist: std::collections::BTreeMap<u8, u64> = std::collections::BTreeMap::new();
    // per-(q,m,torus) exact record of one representative
    let mut reps: Vec<serde_line> = Vec::new();
    let mut seen_rep: std::collections::HashSet<(i64, usize)> = std::collections::HashSet::new();

    for &p in &primes {
        let n = (p + 1) as usize;
        let invs = all_involutions(p);
        let ninv = invs.len();
        for i in 0..ninv {
            for j in (i + 1)..ninv {
                total_pairs += 1;
                let s = &invs[i];
                let t = &invs[j];
                let st = compose(s, t); // sigma_x sigma_y (rotation r)
                let m = perm_order(&st);
                if m < 3 {
                    continue; // m=1 impossible(distinct), m=2 -> V4 boundary (covered elsewhere)
                }
                if (p % (m as i64)) == 0 {
                    continue; // wild (p | 2m); skip
                }
                // generated group closure
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
                if order != 2 * m {
                    // not the expected dihedral order (should not happen for 2 involutions)
                    continue;
                }
                // deleted set = Fix(st)
                let del = fixed(&st);
                let del_set: std::collections::HashSet<usize> = del.iter().cloned().collect();
                // build residual R_S on P^1 \ del
                let live: Vec<usize> = (0..n).filter(|x| !del_set.contains(x)).collect();
                let idx: HashMap<usize, usize> =
                    live.iter().cloned().enumerate().map(|(a, b)| (b, a)).collect();
                let mut edges: Vec<(usize, usize)> = Vec::new();
                for &u in &live {
                    for gen in &[s, t] {
                        let w = gen[u];
                        if w != u && !del_set.contains(&w) {
                            let (a, b) = (idx[&u], idx[&w]);
                            if a < b {
                                edges.push((a, b));
                            }
                        }
                    }
                }
                let nk_direct = nk_graph(live.len(), &edges);

                // orbit decomposition of G on P^1
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
                // classify orbits, predicted value
                let cval = if 2 * m <= nmax { cyc[2 * m] } else { nk_cycle(2 * m) };
                let pval = if m <= nmax { path[m] } else { nk_path(m) };
                let mut nk_pred = 0u8;
                let mut f_free = 0u64;
                let mut rho_refl = 0u64;
                let mut ok_struct = true;
                // helper: residual degree of a live vertex within a vertex subset
                let subset_deg = |orb_set: &std::collections::HashSet<usize>, u: usize| -> usize {
                    let mut d = 0;
                    for gen in &[s, t] {
                        let w = gen[u];
                        if w != u && !del_set.contains(&w) && orb_set.contains(&w) {
                            d += 1;
                        }
                    }
                    d
                };
                for orb in &orbits {
                    let osz = orb.len();
                    let stab = order / osz;
                    let orb_set: std::collections::HashSet<usize> = orb.iter().cloned().collect();
                    if stab == 1 {
                        // free orbit -> C_{2m}: disjoint from del, 2-regular, connected
                        if orb.iter().any(|x| del_set.contains(x)) {
                            ok_struct = false;
                        }
                        if osz != 2 * m || orb.iter().any(|&u| subset_deg(&orb_set, u) != 2) {
                            ok_struct = false;
                        }
                        f_free += 1;
                        nk_pred ^= cval;
                    } else if stab == 2 {
                        // reflection orbit -> P_m: disjoint from del, exactly 2 deg-1 vertices,
                        // rest deg-2 (path); size m
                        if orb.iter().any(|x| del_set.contains(x)) {
                            ok_struct = false;
                        }
                        let deg1 = orb.iter().filter(|&&u| subset_deg(&orb_set, u) == 1).count();
                        let deg2 = orb.iter().filter(|&&u| subset_deg(&orb_set, u) == 2).count();
                        if osz != m || deg1 != 2 || deg1 + deg2 != osz {
                            ok_struct = false;
                        }
                        rho_refl += 1;
                        nk_pred ^= pval;
                    } else if stab == m {
                        // rotation orbit -> empty; must be fully deleted
                        if !orb.iter().all(|x| del_set.contains(x)) {
                            ok_struct = false;
                        }
                        // contributes 0
                    } else {
                        ok_struct = false;
                    }
                }
                checked += 1;
                *m_hist.entry(m).or_insert(0) += 1;
                *val_hist.entry(nk_direct).or_insert(0) += 1;
                if nk_direct != nk_pred {
                    mismatches += 1;
                    if mismatches <= 10 {
                        eprintln!(
                            "MISMATCH q={} m={} direct={} pred={} f={} rho={}",
                            p, m, nk_direct, nk_pred, f_free, rho_refl
                        );
                    }
                }
                if !ok_struct {
                    struct_fail += 1;
                }
                // record one representative per (q,m)
                if seen_rep.insert((p, m)) {
                    let torus = if (p - 1) % (m as i64) == 0 {
                        "split"
                    } else if (p + 1) % (m as i64) == 0 {
                        "nonsplit"
                    } else {
                        "other"
                    };
                    reps.push(serde_line {
                        q: p,
                        m,
                        torus: torus.to_string(),
                        f_free,
                        rho_refl,
                        nk_cycle_2m: cval,
                        nk_path_m: pval,
                        nk_direct,
                        nk_pred,
                    });
                }
            }
        }
    }

    // ---- write JSON ----
    let mut s = String::new();
    s.push_str("{\n");
    s.push_str(&format!(
        "  \"task\": \"C263\",\n  \"generated\": \"pair-of-reflections dihedral D_2m templates\",\n"
    ));
    s.push_str(&format!("  \"path_nimbers_NK_Pn\": {:?},\n", path));
    s.push_str(&format!("  \"cycle_nimbers_NK_Cn\": {:?},\n", cyc));
    s.push_str(&format!("  \"path_matches_A002187\": {},\n", path_ok));
    s.push_str(&format!(
        "  \"cycle_matches_mex_recurrence\": {},\n",
        cyc_ok
    ));
    s.push_str(&format!("  \"primes\": {:?},\n", primes));
    s.push_str(&format!("  \"total_pairs\": {},\n", total_pairs));
    s.push_str(&format!("  \"tame_pairs_checked\": {},\n", checked));
    s.push_str(&format!("  \"formula_mismatches\": {},\n", mismatches));
    s.push_str(&format!("  \"structure_failures\": {},\n", struct_fail));
    let mh: Vec<String> = m_hist.iter().map(|(k, v)| format!("\"{}\":{}", k, v)).collect();
    s.push_str(&format!("  \"m_histogram\": {{{}}},\n", mh.join(",")));
    let vh: Vec<String> = val_hist.iter().map(|(k, v)| format!("\"{}\":{}", k, v)).collect();
    s.push_str(&format!("  \"value_histogram\": {{{}}},\n", vh.join(",")));
    s.push_str("  \"representatives\": [\n");
    for (i, r) in reps.iter().enumerate() {
        s.push_str(&format!(
            "    {{\"q\":{},\"m\":{},\"torus\":\"{}\",\"f_free\":{},\"rho_refl\":{},\"NK_C2m\":{},\"NK_Pm\":{},\"NK_direct\":{},\"NK_pred\":{}}}{}\n",
            r.q, r.m, r.torus, r.f_free, r.rho_refl, r.nk_cycle_2m, r.nk_path_m, r.nk_direct, r.nk_pred,
            if i + 1 < reps.len() { "," } else { "" }
        ));
    }
    s.push_str("  ]\n}\n");
    std::fs::write(&outpath, &s).expect("write json");

    println!("=== C263 pair-template verification ===");
    println!("NK(P_n) matches A002187 (Dawson): {}", path_ok);
    println!("NK(C_n) matches mex recurrence:   {}", cyc_ok);
    println!("NK(P_n) n=0..20: {:?}", &path[0..=20]);
    println!("NK(C_n) n=0..20: {:?}", &cyc[0..=20]);
    println!("primes tested: {:?}", primes);
    println!(
        "total pairs={}  tame checked={}  formula mismatches={}  structure failures={}",
        total_pairs, checked, mismatches, struct_fail
    );
    println!("m histogram: {:?}", m_hist);
    println!("NK value histogram: {:?}", val_hist);
    println!("wrote {}", outpath);
}

struct serde_line {
    q: i64,
    m: usize,
    torus: String,
    f_free: u64,
    rho_refl: u64,
    nk_cycle_2m: u8,
    nk_path_m: u8,
    nk_direct: u8,
    nk_pred: u8,
}
