// C281 — exhaustive per-q census of tame legal dihedral conic configurations.
//
// Extends the C263 two-reflection (pair) enumerator to legal triples and
// produces one census, per odd prime field q <= 23, of every tame legal
// selected configuration whose induced involutions generate a dihedral
// subgroup of PGL_2(q):
//
//   |S| = 2 (pair)   -> D_{2m}, m = ord(sigma_x sigma_y) >= 2.
//                       m = 2 is the V_4 pair boundary; m >= 3 is the paper's
//                       Sec.14 family (templates C_{2m} / P_m / empty).
//   |S| = 3 (triple) -> the central involution z is forced (all reflection
//                       centres of one dihedral group are collinear), so the
//                       legal dihedral triples generate V_4 (Thm 4.1) or
//                       D_{4n}, rotation order 2n even, n >= 2 (Sec.5-9;
//                       templates K_4 / M_{4n} / C_{2n}xK_2 / ladders / empty).
//
// Conventions (identical to the manuscript, C263, C283, C284):
//   * prime fields only, q in {3,5,7,11,13,17,19,23} (the C263/C283/C284
//     scripts are all prime-field; q = 9 is deliberately excluded to match).
//   * conic C : XZ = Y^2 over F_q; P^1(q) indexed 0..q-1 (finite) and q (inf).
//   * off-conic point [a:b:c] (ac - b^2 != 0) <-> involution
//     sigma(t) = (bt - a)/(ct - b); this is a bijection (q^2 involutions).
//   * deleted set D_S = union over selected pairs {x,y} of Fix(sigma_x sigma_y)
//     (manuscript (2.3)/(3.1)); residual R_S on C \ D_S with edges u--sigma(u).
//   * LEGAL = no three selected points collinear (pairs are always legal;
//     triples are checked by a projective determinant).
//   * TAME  = p does not divide |G| (q odd, so p | 2m <=> p | m <=> p | |G|).
//   * value = Node-Kayles Grundy value G(R_S), computed directly on R_S.
//
// Enumeration strategy (rewritten from scratch; the earlier interrupted
// draft's r^{M/2} shortcut is NOT used):
//   pairs:   all C(q^2,2) unordered pairs, complete.
//   triples: a legal dihedral triple must contain a member commuting with the
//            other two (the central involution z), so it has >= 2 of its 3
//            pairwise products of order 2. The scan over all C(q^2,3) triples
//            uses that gate, then builds the actual group closure, verifies
//            dihedrality/centrality/order, and classifies. The gate itself is
//            INDEPENDENTLY validated for q <= 11 by a gate-free full-closure
//            re-enumeration of every triple (exact triple-set equality).
//
// Cross-checks (all must pass; process exits nonzero otherwise):
//   (a) NK(P_n) matches OEIS A002187 (Dawson's chess) initial terms;
//       NK(C_n) = mex{NK(P_{n-3})}.
//   (b) C263 overlap: tame pairs with m >= 3 over q in {5,...,23} reproduce
//       C263's exact totals (241,344 pairs, per-m histogram, value histogram).
//   (c) C284 overlap: in the gate-free full-closure pass, the non-dihedral
//       polyhedral triples (S4 at q=7, A5 at q=11) are classified by
//       (sigma,rho); class counts match C284's per-copy sizes up to a common
//       multiplier, and every direct residual value matches C284's
//       field-dependent orbit formula at that q.
//   (d) every configuration's direct value equals the per-orbit template xor
//       AND the paper's closed finite-field formula (Thm 4.1 / Sec.9 / Thm 14
//       analogues); every orbit's own residual value equals its template value.
//   (e) orbit equation q+1 = 4nf + 2eps + 2n(a0+a1) for every D_{4n} triple.
//   (f) no wild legal dihedral triple exists (C283), checked both by the gate
//       pass and the closure pass (wild dihedral closures must be collinear).
//
// Output: canonical JSON (sorted keys, integers only, no timestamps) to
// argv[1], default 2026-07-17-c281-dihedral-census-appendix.json.
//
// Reproduce (working directory: notes/):
//   rustc -O 2026-07-17-c281-dihedral-census-appendix.rs -o /tmp/c281bin
//   /tmp/c281bin 2026-07-17-c281-dihedral-census-appendix.json
//   sha256sum -c 2026-07-17-c281-dihedral-census-appendix.sha256

use std::collections::{BTreeMap, HashMap, HashSet};

// ---------- Grundy core (identical algorithm to C263 / nodekayles_cayley.rs) ----------
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
// P^1(p): index 0..p-1 = field elt, index p = infinity. Mobius action.
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

type Perm = Vec<u8>;

// All involutions of PGL2(p): one per off-conic point [a:b:c] of XZ=Y^2,
// matrix [[b,-a],[c,-b]]. Returns (permutation of P^1, point coords).
fn all_involutions(p: i64) -> Vec<(Perm, (i64, i64, i64))> {
    let n = (p + 1) as usize;
    let mut seen = HashSet::new();
    let mut out = Vec::new();
    let mut pts: Vec<(i64, i64, i64)> = Vec::new();
    for b in 0..p {
        for c in 0..p {
            pts.push((1, b, c));
        }
    }
    for c in 0..p {
        pts.push((0, 1, c));
    }
    pts.push((0, 0, 1));
    for (a, b, c) in pts {
        if ((a * c - b * b) % p + p) % p == 0 {
            continue; // on conic
        }
        let mat = (b, ((-a) % p + p) % p, c, ((-b) % p + p) % p);
        let perm: Perm = (0..n).map(|t| mobius(mat, t, p) as u8).collect();
        if seen.insert(perm.clone()) {
            out.push((perm, (a, b, c)));
        }
    }
    out
}

fn compose(f: &[u8], g: &[u8]) -> Perm {
    // f after g
    g.iter().map(|&x| f[x as usize]).collect()
}
fn perm_order(p: &[u8]) -> usize {
    // lcm of cycle lengths
    let n = p.len();
    let mut seen = vec![false; n];
    let mut l: usize = 1;
    for s in 0..n {
        if seen[s] {
            continue;
        }
        let mut len = 0usize;
        let mut x = s;
        while !seen[x] {
            seen[x] = true;
            x = p[x] as usize;
            len += 1;
        }
        let g = gcd(l, len);
        l = l / g * len;
    }
    l
}
fn gcd(a: usize, b: usize) -> usize {
    if b == 0 {
        a
    } else {
        gcd(b, a % b)
    }
}
fn fix_mask(p: &[u8]) -> u32 {
    let mut m = 0u32;
    for i in 0..p.len() {
        if p[i] as usize == i {
            m |= 1 << i;
        }
    }
    m
}

// Group closure by BFS; None if size exceeds cap.
fn closure(gens: &[&Perm], cap: usize) -> Option<Vec<Perm>> {
    let n = gens[0].len();
    let id: Perm = (0..n as u8).collect();
    let mut set: HashSet<Perm> = HashSet::new();
    set.insert(id.clone());
    let mut elems = vec![id];
    let mut k = 0;
    while k < elems.len() {
        let g = elems[k].clone();
        for gen in gens {
            let h = compose(&g, gen);
            if set.insert(h.clone()) {
                elems.push(h);
                if elems.len() > cap {
                    return None;
                }
            }
        }
        k += 1;
    }
    Some(elems)
}

// Dihedral test: |G| even, exists g of order |G|/2 with every element outside
// <g> an involution. Includes V4 = D_4.
fn is_dihedral(group: &[Perm]) -> bool {
    let sz = group.len();
    if sz < 4 || sz % 2 != 0 {
        return false;
    }
    let half = sz / 2;
    for g in group {
        if perm_order(g) == half {
            // build <g>
            let mut cyc: HashSet<Perm> = HashSet::new();
            let n = g.len();
            let mut x: Perm = (0..n as u8).collect();
            for _ in 0..half {
                cyc.insert(x.clone());
                x = compose(g, &x);
            }
            let id: Perm = (0..n as u8).collect();
            let mut ok = true;
            for h in group {
                if !cyc.contains(h) && (*h == id || compose(h, h) != id) {
                    ok = false;
                    break;
                }
            }
            if ok {
                return true;
            }
        }
    }
    false
}

fn collinear(p: i64, x: (i64, i64, i64), y: (i64, i64, i64), z: (i64, i64, i64)) -> bool {
    let det = x.0 * (y.1 * z.2 - y.2 * z.1) - x.1 * (y.0 * z.2 - y.2 * z.0)
        + x.2 * (y.0 * z.1 - y.1 * z.0);
    ((det % p) + p) % p == 0
}

// residual edges of T on live vertices; vertices relabelled 0..live.len().
fn residual(nn: usize, gens: &[&Perm], del: u32) -> (usize, Vec<(usize, usize)>) {
    let live: Vec<usize> = (0..nn).filter(|&x| del & (1 << x) == 0).collect();
    let mut idx = vec![usize::MAX; nn];
    for (a, &b) in live.iter().enumerate() {
        idx[b] = a;
    }
    let mut edges = Vec::new();
    for &u in &live {
        for gen in gens {
            let w = gen[u] as usize;
            if w != u && del & (1 << w) == 0 {
                let (a, b) = (idx[u], idx[w]);
                if a < b {
                    edges.push((a, b));
                }
            }
        }
    }
    edges.sort_unstable();
    edges.dedup();
    (live.len(), edges)
}

// residual value of the sub-board induced on `verts` (an orbit): generators
// never cross orbits, so this is the orbit's template contribution.
fn orbit_value(verts: &[usize], gens: &[&Perm], del: u32) -> u8 {
    let live: Vec<usize> = verts.iter().cloned().filter(|&v| del & (1 << v) == 0).collect();
    let mut idx: HashMap<usize, usize> = HashMap::new();
    for (a, &b) in live.iter().enumerate() {
        idx.insert(b, a);
    }
    let mut edges = Vec::new();
    for &u in &live {
        for gen in gens {
            let w = gen[u] as usize;
            if w != u && del & (1 << w) == 0 {
                if let (Some(&a), Some(&b)) = (idx.get(&u), idx.get(&w)) {
                    if a < b {
                        edges.push((a, b));
                    }
                }
            }
        }
    }
    edges.sort_unstable();
    edges.dedup();
    nk_graph(live.len(), &edges)
}

fn orbits_of(nn: usize, group: &[Perm]) -> Vec<Vec<usize>> {
    let mut orbit_of = vec![usize::MAX; nn];
    let mut orbits = Vec::new();
    for start in 0..nn {
        if orbit_of[start] != usize::MAX {
            continue;
        }
        let oid = orbits.len();
        let mut orb = vec![start];
        orbit_of[start] = oid;
        let mut qi = 0;
        while qi < orb.len() {
            let v = orb[qi];
            for g in group {
                let w = g[v] as usize;
                if orbit_of[w] == usize::MAX {
                    orbit_of[w] = oid;
                    orb.push(w);
                }
            }
            qi += 1;
        }
        orbits.push(orb);
    }
    orbits
}

// ---------- shared counters ----------
#[derive(Default)]
struct Fails {
    formula: u64,          // direct != per-orbit template xor
    closed_form: u64,      // direct != paper closed finite-field formula
    structure: u64,        // orbit size/deletion-pattern violation
    orbit_template: u64,   // per-orbit residual value != template value
    torus_anomaly: u64,    // m (resp. 2n) divides neither q-1 nor q+1
    orbit_equation: u64,   // (8.4) violation
    v4_parity_law: u64,    // (4.1) violation
    closure_shape: u64,    // closure order / centrality / dihedrality violation
    split_class_law: u64,  // t (split refl classes) outside {1} / {0,2} by h parity
}

fn hist_json(h: &BTreeMap<u8, u64>) -> String {
    let items: Vec<String> = h.iter().map(|(k, v)| format!("\"{}\":{}", k, v)).collect();
    format!("{{{}}}", items.join(","))
}
fn histm_json(h: &BTreeMap<usize, u64>) -> String {
    let items: Vec<String> = h.iter().map(|(k, v)| format!("\"{}\":{}", k, v)).collect();
    format!("{{{}}}", items.join(","))
}

// classification result of one triple by the commuting gate.
enum TripleClass {
    V4,
    D4n { n: usize, d_odd: bool, ci: usize },
    NonDihedral,
    Wild,
}

// gate classification: assumes exactly the pair-order pattern was pre-checked.
// c2 = number of pairwise products of order 2 (must be 2 or 3 to call).
fn classify_gated(
    p: i64,
    perms: [&Perm; 3],
    ords: [usize; 3], // ord(s0 s1), ord(s0 s2), ord(s1 s2)
) -> TripleClass {
    let c2 = ords.iter().filter(|&&o| o == 2).count();
    if c2 == 3 {
        return TripleClass::V4;
    }
    // c2 == 2: the centre is the member of both order-2 pairs.
    // pair index -> member indices: 0:(0,1) 1:(0,2) 2:(1,2)
    let (ci, si, ti) = if ords[0] == 2 && ords[1] == 2 {
        (0, 1, 2)
    } else if ords[0] == 2 && ords[2] == 2 {
        (1, 0, 2)
    } else {
        (2, 0, 1)
    };
    let prod = compose(perms[si], perms[ti]);
    let mp = perm_order(&prod);
    if mp % 2 == 1 {
        // z outside <s,s'> = D_{2mp}: G = D_{2mp} x <z> ~ D_{4mp} (mp odd), even-d class.
        let n = mp;
        if (p as usize) != 0 && n % (p as usize) == 0 {
            let _ = n;
            return TripleClass::Wild;
        }
        TripleClass::D4n { n, d_odd: false, ci }
    } else {
        // mp even: dihedral iff z is the centre of <s,s'> = D_{2mp}.
        let mut half = prod.clone();
        for _ in 1..(mp / 2) {
            half = compose(&prod, &half);
        }
        if &half == perms[ci] {
            let n = mp / 2;
            if n % (p as usize) == 0 {
                let _ = n;
            return TripleClass::Wild;
            }
            TripleClass::D4n { n, d_odd: true, ci }
        } else {
            TripleClass::NonDihedral
        }
    }
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let outpath = args
        .get(1)
        .cloned()
        .unwrap_or_else(|| "2026-07-17-c281-dihedral-census-appendix.json".to_string());
    let primes: Vec<i64> = vec![3, 5, 7, 11, 13, 17, 19, 23];
    let full_closure_primes: Vec<i64> = vec![3, 5, 7, 11];

    // ---- template nimber tables + checks ----
    let nmax = 60usize;
    let pathv: Vec<u8> = (0..=nmax).map(nk_path).collect();
    let cycv: Vec<u8> = (0..=nmax).map(nk_cycle).collect();
    let a002187: [u8; 40] = [
        0, 1, 1, 2, 0, 3, 1, 1, 0, 3, 3, 2, 2, 4, 0, 5, 2, 2, 3, 3, 0, 1, 1, 3, 0, 2, 1, 1, 0, 4,
        5, 2, 7, 4, 0, 1, 1, 2, 0, 3,
    ];
    let path_ok = (0..a002187.len()).all(|n| pathv[n] == a002187[n]);
    let cyc_ok = (3..=nmax).all(|n| cycv[n] == if pathv[n - 3] == 0 { 1 } else { 0 });

    // C263 expected overlap (q in {5..23}, tame pairs m>=3), hard-coded from
    // the committed 2026-07-17-c263-dihedral-pair-templates.json:
    let c263_total: u64 = 241344;
    let c263_mhist: &[(usize, u64)] = &[
        (3, 13920), (4, 13920), (5, 8160), (6, 13920), (7, 3276), (8, 17376), (9, 17604),
        (10, 8160), (11, 30360), (12, 15648), (14, 3276), (16, 9792), (18, 17604), (20, 13680),
        (22, 30360), (24, 24288),
    ];
    let c263_vhist: &[(u8, u64)] = &[(0, 172668), (1, 36456), (2, 13296), (3, 18924)];

    // C284 expected overlaps.
    // S4 at q=7: eps2=eps4=[q=1 mod 8]=0, eps3=[q=1 mod 3]=1, m1=(8-8)/24=0
    //   -> G = eps3*t3, and t3 = 0 for all four classes -> every value 0.
    // per-copy class sizes keyed by (sigma, rho):
    let s4_classes: &[(&str, usize, u64, u8)] = &[
        ("2,3,3", 4, 12, 0),
        ("2,3,4", 3, 24, 0),
        ("3,3,3", 4, 4, 0),
        ("3,4,4", 3, 12, 0),
    ];
    // A5 at q=11: eps2=[q=1 mod 4]=0, eps3=[q=1 mod 3]=0, eps5=[q=1 mod 5]=1,
    //   m1=(12-12)/60=0 -> G = eps5*t5(class).
    let a5_classes: &[(&str, usize, u64, u8)] = &[
        ("2,3,5", 5, 120, 0),
        ("2,5,5", 3, 60, 1),
        ("3,3,5", 3, 60, 0),
        ("3,5,5", 3, 60, 1),
        ("3,5,5", 5, 60, 0),
        ("5,5,5", 5, 20, 0),
    ];

    let mut fails = Fails::default();
    let mut all_ok = true;
    let mut per_q_json: Vec<String> = Vec::new();
    // aggregates for the C263 comparison
    let mut agg_m_hist: BTreeMap<usize, u64> = BTreeMap::new();
    let mut agg_v_hist: BTreeMap<u8, u64> = BTreeMap::new();
    let mut agg_pairs_m3: u64 = 0;
    let mut c284_json = String::from("null");
    let mut c284_s4_ok = true; // set false on any q=7 S4 mismatch
    let mut c284_a5_ok = true;
    let mut full_closure_all_agree = true;
    let mut wild_dihedral_noncollinear_closure: u64 = 0;
    // deviations from the manuscript's model-dependent claims (findings, not failures)
    let mut dev_pairs_thm_d: u64 = 0; // Sec.14 Thm D: rho = 1 + delta (even m)
    let mut dev_triples_sec9: u64 = 0; // Sec.9: a0 = 1 (t = 1 + delta)
    let mut dev_triples_sec9_value: u64 = 0; // Sec.9 boxed value differs from actual

    for &p in &primes {
        let nn = (p + 1) as usize;
        let invs = all_involutions(p);
        let ninv = invs.len();
        let perms: Vec<&Perm> = invs.iter().map(|(pm, _)| pm).collect();
        let pts: Vec<(i64, i64, i64)> = invs.iter().map(|(_, pt)| *pt).collect();
        let fixc: Vec<usize> = perms.iter().map(|pm| fix_mask(pm).count_ones() as usize).collect();

        // pair-order matrix
        let mut ordm = vec![0u8; ninv * ninv];
        for i in 0..ninv {
            for j in (i + 1)..ninv {
                let o = perm_order(&compose(perms[i], perms[j])) as u8;
                ordm[i * ninv + j] = o;
                ordm[j * ninv + i] = o;
            }
        }

        // ================= PAIR CENSUS =================
        let mut pair_total: u64 = 0;
        let mut pair_wild: u64 = 0;
        let mut pair_v4: u64 = 0;
        let mut pair_m3: u64 = 0;
        let mut pair_m_hist: BTreeMap<usize, u64> = BTreeMap::new();
        let mut pair_v_hist: BTreeMap<u8, u64> = BTreeMap::new();
        // families: ("V4",k_split) -> (count,value) ; m>=3: (m,t) -> (count,value,torus,delta)
        let mut fam_pair_v4: BTreeMap<usize, (u64, u8)> = BTreeMap::new();
        let mut fam_pair_m: BTreeMap<(usize, u64), (u64, u8, String, u8)> = BTreeMap::new();

        for i in 0..ninv {
            for j in (i + 1)..ninv {
                pair_total += 1;
                let m = ordm[i * ninv + j] as usize;
                if m >= 3 && m % (p as usize) == 0 {
                    pair_wild += 1;
                    continue;
                }
                let t = [perms[i], perms[j]];
                let rot = compose(perms[i], perms[j]);
                let del = fix_mask(&rot);
                let (lv, edges) = residual(nn, &t, del);
                let direct = nk_graph(lv, &edges);
                // group closure and orbit analysis
                let group = closure(&t, 2 * m + 1).expect("pair closure");
                if group.len() != 2 * m {
                    fails.closure_shape += 1;
                }
                let orbs = orbits_of(nn, &group);
                let mut pred: u8 = 0;
                let (mut rho_p, mut eps_p, mut f_p) = (0u64, 0u64, 0u64);
                for orb in &orbs {
                    let osz = orb.len();
                    let stab = group.len() / osz;
                    let delc = orb.iter().filter(|&&v| del & (1 << v) != 0).count();
                    let (tval, ok) = if m == 2 {
                        match (stab, delc) {
                            (1, 0) => (cycv[4], osz == 4),
                            (2, 0) => (1u8, osz == 2), // K2 from the swapping generator
                            (2, d) if d == osz => (0u8, osz == 2),
                            _ => (0u8, false),
                        }
                    } else {
                        match (stab, delc) {
                            (1, 0) => {
                                f_p += 1;
                                (cycv[2 * m], osz == 2 * m)
                            }
                            (2, 0) => {
                                rho_p += 1;
                                (pathv[m], osz == m)
                            }
                            (s, d) if s == m && d == osz => {
                                eps_p += 1;
                                (0u8, osz == 2)
                            }
                            _ => (0u8, false),
                        }
                    };
                    if !ok {
                        fails.structure += 1;
                    }
                    if tval != 0 || delc < osz {
                        let ov = orbit_value(orb, &t, del);
                        if ov != tval {
                            fails.orbit_template += 1;
                        }
                    }
                    pred ^= tval;
                }
                if direct != pred {
                    fails.formula += 1;
                }
                // closed forms + family bookkeeping
                if m == 2 {
                    pair_v4 += 1;
                    let k = (fixc[i] + fixc[j]) / 2; // split generators among the pair
                    let closed = (k % 2) as u8;
                    if closed != direct {
                        fails.closed_form += 1;
                        if fails.closed_form <= 10 {
                            eprintln!("CF pairV4 q={} k={} closed={} direct={}", p, k, closed, direct);
                        }
                    }
                    let e = fam_pair_v4.entry(k).or_insert((0, closed));
                    e.0 += 1;
                    if e.1 != direct {
                        fails.closed_form += 1;
                    }
                } else {
                    pair_m3 += 1;
                    *pair_m_hist.entry(m).or_insert(0) += 1;
                    let (torus, delta) = if (p - 1) % (m as i64) == 0 {
                        ("split", if m % 2 == 0 && (p - 1) % (2 * m as i64) == 0 { 1u8 } else { 0 })
                    } else if (p + 1) % (m as i64) == 0 {
                        ("nonsplit", if m % 2 == 0 && (p + 1) % (2 * m as i64) == 0 { 1 } else { 0 })
                    } else {
                        fails.torus_anomaly += 1;
                        ("anomaly", 0)
                    };
                    // number of split reflection classes t, computed from the
                    // group elements themselves (independent of the orbit scan)
                    let t_split: u64 = if m % 2 == 1 {
                        // single class; sigma_i, sigma_j conjugate
                        if fixc[i] != fixc[j] {
                            fails.split_class_law += 1;
                        }
                        if fixc[i] > 0 { 1 } else { 0 }
                    } else {
                        let s1 = compose(perms[i], &rot); // opposite-class reflection
                        (if fixc[i] > 0 { 1 } else { 0 })
                            + (if fix_mask(&s1) != 0 { 1 } else { 0 })
                    };
                    // split-class law: m even => t=1 iff h odd (delta=0), t in {0,2} iff delta=1
                    if m % 2 == 0 {
                        let lawok = if delta == 0 { t_split == 1 } else { t_split == 0 || t_split == 2 };
                        if !lawok {
                            fails.split_class_law += 1;
                        }
                        if rho_p != t_split {
                            fails.closed_form += 1;
                        }
                    } else if rho_p != 2 * t_split {
                        fails.closed_form += 1;
                    }
                    // orbit equation: q+1 = 2m f + m rho + 2 eps
                    if (nn as u64)
                        != 2 * (m as u64) * f_p + (m as u64) * rho_p + 2 * eps_p
                    {
                        fails.orbit_equation += 1;
                    }
                    let closed = if m % 2 == 1 {
                        0u8
                    } else {
                        ((t_split % 2) as u8) * pathv[m]
                    };
                    if closed != direct {
                        fails.closed_form += 1;
                        if fails.closed_form <= 10 {
                            eprintln!("CF pairM q={} m={} torus={} delta={} t={} closed={} direct={}", p, m, torus, delta, t_split, closed, direct);
                        }
                    }
                    // Thm-D (Sec.14) deviation: paper claims rho = 1 + delta for even m
                    if m % 2 == 0 && t_split != 1 + delta as u64 {
                        dev_pairs_thm_d += 1;
                    }
                    let e = fam_pair_m
                        .entry((m, t_split))
                        .or_insert((0, closed, torus.to_string(), delta));
                    e.0 += 1;
                    if e.1 != direct {
                        fails.closed_form += 1;
                    }
                }
                *pair_v_hist.entry(direct).or_insert(0) += 1;
            }
        }
        if p >= 5 {
            for (&m, &c) in &pair_m_hist {
                *agg_m_hist.entry(m).or_insert(0) += c;
            }
            for (i, j) in pair_v_hist.iter() {
                // v_hist includes V4 pairs; aggregate only m>=3 below via families
                let _ = (i, j);
            }
            // aggregate m>=3 value histogram: recompute from families is not
            // enough (per-family constant value), so use it directly:
            for (_m, (c, v, _t, _d)) in &fam_pair_m {
                *agg_v_hist.entry(*v).or_insert(0) += *c;
            }
            agg_pairs_m3 += pair_m3;
        }

        // ================= TRIPLE CENSUS (gated) =================
        let ntrip: u64 = if ninv >= 3 {
            (ninv as u64) * ((ninv - 1) as u64) * ((ninv - 2) as u64) / 6
        } else {
            0
        };
        let mut tri_gate_candidates: u64 = 0;
        let mut tri_nondihedral: u64 = 0;
        let mut tri_wild: u64 = 0;
        let mut tri_collinear: u64 = 0;
        let mut tri_accept: u64 = 0;
        let mut tri_v_hist: BTreeMap<u8, u64> = BTreeMap::new();
        // families: V4 by s ; D4n by (4n, d_class, t) -> (count, value, torus, paper_value)
        let mut fam_tri_v4: BTreeMap<usize, (u64, u8)> = BTreeMap::new();
        let mut fam_tri_d4n: BTreeMap<(usize, bool, u64), (u64, u8, String, u8)> = BTreeMap::new();
        let mut accepted: Vec<(usize, usize, usize)> = Vec::new();

        for i in 0..ninv {
            for j in (i + 1)..ninv {
                let oij = ordm[i * ninv + j];
                for k in (j + 1)..ninv {
                    let oik = ordm[i * ninv + k];
                    let ojk = ordm[j * ninv + k];
                    let c2 = (oij == 2) as usize + (oik == 2) as usize + (ojk == 2) as usize;
                    if c2 < 2 {
                        continue;
                    }
                    tri_gate_candidates += 1;
                    let trip = [perms[i], perms[j], perms[k]];
                    let cls = classify_gated(
                        p,
                        trip,
                        [oij as usize, oik as usize, ojk as usize],
                    );
                    let (fam_v4, n, d_odd, _ci) = match cls {
                        TripleClass::V4 => (true, 1usize, false, 0usize),
                        TripleClass::D4n { n, d_odd, ci } => (false, n, d_odd, ci),
                        TripleClass::NonDihedral => {
                            tri_nondihedral += 1;
                            continue;
                        }
                        TripleClass::Wild => {
                            tri_wild += 1;
                            continue;
                        }
                    };
                    if collinear(p, pts[i], pts[j], pts[k]) {
                        tri_collinear += 1;
                        continue;
                    }
                    // verify group closure shape
                    let gorder = if fam_v4 { 4 } else { 4 * n };
                    let group = match closure(&trip, gorder + 1) {
                        Some(g) if g.len() == gorder && is_dihedral(&g) => g,
                        _ => {
                            fails.closure_shape += 1;
                            continue;
                        }
                    };
                    tri_accept += 1;
                    accepted.push((i, j, k));
                    // deleted set: union of pair-product fixed points
                    let del = fix_mask(&compose(perms[i], perms[j]))
                        | fix_mask(&compose(perms[i], perms[k]))
                        | fix_mask(&compose(perms[j], perms[k]));
                    let (lv, edges) = residual(nn, &trip, del);
                    let direct = nk_graph(lv, &edges);
                    *tri_v_hist.entry(direct).or_insert(0) += 1;
                    let orbs = orbits_of(nn, &group);
                    let mut pred: u8 = 0;
                    let (mut f_free, mut eps, mut a01) = (0u64, 0u64, 0u64);
                    for orb in &orbs {
                        let osz = orb.len();
                        let stab = group.len() / osz;
                        let delc = orb.iter().filter(|&&v| del & (1 << v) != 0).count();
                        let (tval, ok) = if fam_v4 {
                            match (stab, delc) {
                                (1, 0) => {
                                    f_free += 1;
                                    (1u8, osz == 4) // K4
                                }
                                (2, d) if d == osz => (0u8, osz == 2),
                                _ => (0u8, false),
                            }
                        } else {
                            match stab {
                                1 => {
                                    f_free += 1;
                                    let tv = if d_odd { 1u8 } else { 0u8 }; // M_{4n} / prism
                                    (tv, osz == 4 * n && delc == 0)
                                }
                                2 => {
                                    a01 += 1;
                                    // ladders: d odd -> L_{n-1} (2 deleted);
                                    // d even -> L_n (0 del) or L_{n-2} (4 del)
                                    let tv = if d_odd {
                                        if n % 2 == 0 { 1u8 } else { 0u8 }
                                    } else {
                                        1u8
                                    };
                                    let okd = if d_odd {
                                        delc == 2
                                    } else {
                                        delc == 0 || delc == 4
                                    };
                                    (tv, osz == 2 * n && okd)
                                }
                                s if s == 2 * n && delc == osz => {
                                    eps += 1;
                                    (0u8, osz == 2)
                                }
                                _ => (0u8, false),
                            }
                        };
                        if !ok {
                            fails.structure += 1;
                        }
                        if delc < osz {
                            let ov = orbit_value(orb, &trip, del);
                            if ov != tval {
                                fails.orbit_template += 1;
                            }
                        }
                        pred ^= tval;
                    }
                    if direct != pred {
                        fails.formula += 1;
                    }
                    if fam_v4 {
                        let s = (fixc[i] + fixc[j] + fixc[k]) / 2;
                        // parity law (4.1)
                        let lawok = if p % 4 == 1 { s == 1 || s == 3 } else { s == 0 || s == 2 };
                        if !lawok {
                            fails.v4_parity_law += 1;
                        }
                        let nq = nn; // q+1
                        let closed = (((nq - 2 * s) / 4) % 2) as u8;
                        if closed != direct {
                            fails.closed_form += 1;
                            if fails.closed_form <= 10 {
                                eprintln!("CF triV4 q={} s={} closed={} direct={}", p, s, closed, direct);
                            }
                        }
                        let e = fam_tri_v4.entry(s).or_insert((0, closed));
                        e.0 += 1;
                        if e.1 != direct {
                            fails.closed_form += 1;
                        }
                    } else {
                        // orbit equation (8.4): q+1 = 4n f + 2 eps + 2n a01
                        if (nn as u64) != 4 * (n as u64) * f_free + 2 * eps + 2 * (n as u64) * a01
                        {
                            fails.orbit_equation += 1;
                        }
                        let two_n = 2 * n as i64;
                        let (torus, delta) = if (p - 1) % two_n == 0 {
                            ("split", if (p - 1) % (2 * two_n) == 0 { 1u8 } else { 0 })
                        } else if (p + 1) % two_n == 0 {
                            ("nonsplit", if (p + 1) % (2 * two_n) == 0 { 1 } else { 0 })
                        } else {
                            fails.torus_anomaly += 1;
                            ("anomaly", 0)
                        };
                        // split reflection classes t, from the group elements:
                        // r0 = a rotation of order 2n; s0 and s0*r0 represent the
                        // two reflection classes.
                        let mem = [i, j, k];
                        let ci_ = _ci;
                        let c_idx = mem[ci_];
                        let (s_idx, t_idx) = match ci_ {
                            0 => (mem[1], mem[2]),
                            1 => (mem[0], mem[2]),
                            _ => (mem[0], mem[1]),
                        };
                        let prod = compose(perms[s_idx], perms[t_idx]);
                        let r0 = if d_odd {
                            prod.clone()
                        } else {
                            compose(perms[c_idx], &prod)
                        };
                        if perm_order(&r0) != 2 * n {
                            fails.closure_shape += 1;
                        }
                        let s1 = compose(perms[s_idx], &r0);
                        let t_split: u64 = (if fixc[s_idx] > 0 { 1 } else { 0 })
                            + (if fix_mask(&s1) != 0 { 1 } else { 0 });
                        // split-class law: t=1 iff h odd (delta=0); t in {0,2} iff delta=1
                        let lawok = if delta == 0 { t_split == 1 } else { t_split == 0 || t_split == 2 };
                        if !lawok {
                            fails.split_class_law += 1;
                        }
                        let split_ind = if torus == "split" { 1u64 } else { 0 };
                        if eps != split_ind || a01 != t_split {
                            fails.closed_form += 1;
                            if fails.closed_form <= 10 {
                                eprintln!("CF triD4n-orbits q={} n={} d_odd={} torus={} delta={} t={} eps={} a01={} f={}", p, n, d_odd, torus, delta, t_split, eps, a01, f_free);
                            }
                        }
                        // corrected multiplicity: q+1 = 4n f + 2 eps + 2n t
                        let fnum = nn as i64 - 2 * (split_ind as i64) - two_n * t_split as i64;
                        let fpred = fnum / (4 * n as i64);
                        if fnum % (4 * n as i64) != 0 || f_free != fpred as u64 {
                            fails.closed_form += 1;
                            if fails.closed_form <= 10 {
                                eprintln!("CF triD4n-f q={} n={} f={} fpred={}", p, n, f_free, fpred);
                            }
                        }
                        // corrected closed value (Thm 8.1 with the actual t):
                        let closed = if d_odd {
                            ((fpred % 2) as u8)
                                ^ (if n % 2 == 0 { (t_split % 2) as u8 } else { 0 })
                        } else {
                            (t_split % 2) as u8
                        };
                        if closed != direct {
                            fails.closed_form += 1;
                            if fails.closed_form <= 10 {
                                eprintln!("CF triD4n-val q={} n={} d_odd={} t={} closed={} direct={}", p, n, d_odd, t_split, closed, direct);
                            }
                        }
                        // manuscript Sec.9 (model with a0=1): value and deviation
                        let hh = if torus == "split" { (p - 1) / two_n } else { (p + 1) / two_n };
                        let f9 = (hh - 1 - delta as i64) / 2;
                        let paper = if d_odd {
                            ((f9 % 2) as u8) ^ (if n % 2 == 0 { 1 - delta } else { 0 })
                        } else {
                            1 - delta
                        };
                        if t_split != 1 + delta as u64 {
                            dev_triples_sec9 += 1;
                            if paper != direct {
                                dev_triples_sec9_value += 1;
                            }
                        } else if paper != direct {
                            // in the paper's own model class the paper formula must hold
                            fails.closed_form += 1;
                        }
                        let e = fam_tri_d4n
                            .entry((4 * n, d_odd, t_split))
                            .or_insert((0, closed, torus.to_string(), paper));
                        e.0 += 1;
                        if e.1 != direct {
                            fails.closed_form += 1;
                        }
                    }
                }
            }
        }
        if tri_wild != 0 {
            // C283: no legal wild dihedral triple should exist at all.
            all_ok = false;
        }

        // ============ FULL-CLOSURE INDEPENDENT RE-ENUMERATION (q <= 11) ============
        let mut fc_json = String::from("null");
        let mut poly_json = String::from("null");
        if full_closure_primes.contains(&p) {
            let mut fc_accept: Vec<(usize, usize, usize)> = Vec::new();
            let mut fc_wild_dihedral_noncoll: u64 = 0;
            // polyhedral collection: (sigma,rho) -> (count, value mismatches)
            let mut poly: BTreeMap<(String, usize), (u64, u64)> = BTreeMap::new();
            let mut poly_rho_inconsistent: u64 = 0;
            let cap = 61usize;
            for i in 0..ninv {
                for j in (i + 1)..ninv {
                    for k in (j + 1)..ninv {
                        let trip = [perms[i], perms[j], perms[k]];
                        let g = match closure(&trip, cap) {
                            Some(g) => g,
                            None => continue, // larger than any dihedral/polyhedral target
                        };
                        let sz = g.len();
                        let dih = is_dihedral(&g);
                        if dih {
                            let tame = sz % (p as usize) != 0
                                && (sz / 2) % (p as usize) != 0;
                            let legal = !collinear(p, pts[i], pts[j], pts[k]);
                            if tame && legal {
                                fc_accept.push((i, j, k));
                            } else if !tame && legal {
                                fc_wild_dihedral_noncoll += 1;
                            }
                            continue;
                        }
                        // polyhedral overlap classes
                        let is_s4 = p == 7 && sz == 24;
                        let is_a5 = p == 11 && sz == 60;
                        if is_s4 || is_a5 {
                            let mut sig = vec![
                                ordm[i * ninv + j] as usize,
                                ordm[i * ninv + k] as usize,
                                ordm[j * ninv + k] as usize,
                            ];
                            sig.sort_unstable();
                            let sigs =
                                format!("{},{},{}", sig[0], sig[1], sig[2]);
                            // rho: order of all six ordered products must agree
                            let idxs = [
                                (i, j, k), (i, k, j), (j, i, k),
                                (j, k, i), (k, i, j), (k, j, i),
                            ];
                            let mut rhos: Vec<usize> = idxs
                                .iter()
                                .map(|&(a, b, c)| {
                                    perm_order(&compose(
                                        &compose(perms[a], perms[b]),
                                        perms[c],
                                    ))
                                })
                                .collect();
                            rhos.dedup();
                            if rhos.len() != 1 {
                                poly_rho_inconsistent += 1;
                            }
                            let rho = rhos[0];
                            let del = fix_mask(&compose(perms[i], perms[j]))
                                | fix_mask(&compose(perms[i], perms[k]))
                                | fix_mask(&compose(perms[j], perms[k]));
                            let (lv, edges) = residual(nn, &trip, del);
                            let direct = nk_graph(lv, &edges);
                            let expect = if is_s4 {
                                s4_classes
                                    .iter()
                                    .find(|(s, r, _, _)| *s == sigs && *r == rho)
                                    .map(|&(_, _, _, v)| v)
                            } else {
                                a5_classes
                                    .iter()
                                    .find(|(s, r, _, _)| *s == sigs && *r == rho)
                                    .map(|&(_, _, _, v)| v)
                            };
                            let mism = match expect {
                                Some(v) if v == direct => 0u64,
                                _ => 1u64,
                            };
                            let e = poly.entry((sigs, rho)).or_insert((0, 0));
                            e.0 += 1;
                            e.1 += mism;
                        }
                    }
                }
            }
            fc_accept.sort_unstable();
            let mut acc_sorted = accepted.clone();
            acc_sorted.sort_unstable();
            let agree = fc_accept == acc_sorted;
            if !agree {
                full_closure_all_agree = false;
            }
            wild_dihedral_noncollinear_closure += fc_wild_dihedral_noncoll;
            fc_json = format!(
                "{{\"performed\":true,\"legal_tame_dihedral\":{},\"triple_sets_equal\":{},\"wild_dihedral_noncollinear\":{}}}",
                fc_accept.len(),
                agree,
                fc_wild_dihedral_noncoll
            );
            if p == 7 || p == 11 {
                // ratio check against per-copy class sizes
                let base: &[(&str, usize, u64, u8)] = if p == 7 { s4_classes } else { a5_classes };
                let mut mult: Option<u64> = None;
                let mut ratio_ok = !poly.is_empty();
                let mut vmism: u64 = 0;
                for (sig, rho, per_copy, _v) in base.iter().map(|&(s, r, c, v)| (s, r, c, v)) {
                    match poly.get(&(sig.to_string(), rho)) {
                        Some(&(cnt, mm)) => {
                            vmism += mm;
                            if cnt % per_copy != 0 {
                                ratio_ok = false;
                            } else {
                                let q = cnt / per_copy;
                                match mult {
                                    None => mult = Some(q),
                                    Some(m0) if m0 == q => {}
                                    _ => ratio_ok = false,
                                }
                            }
                        }
                        None => ratio_ok = false,
                    }
                }
                // any unexpected class present?
                for ((sig, rho), _) in &poly {
                    if !base.iter().any(|&(s, r, _, _)| s == sig && r == *rho) {
                        ratio_ok = false;
                    }
                }
                let ok = ratio_ok && vmism == 0 && poly_rho_inconsistent == 0;
                if p == 7 {
                    c284_s4_ok = ok;
                } else {
                    c284_a5_ok = ok;
                }
                let cls: Vec<String> = poly
                    .iter()
                    .map(|((s, r), (c, mm))| {
                        format!(
                            "{{\"sigma\":\"{}\",\"rho\":{},\"count\":{},\"value_mismatches\":{}}}",
                            s, r, c, mm
                        )
                    })
                    .collect();
                poly_json = format!(
                    "{{\"group\":\"{}\",\"copies_multiplier\":{},\"classes\":[{}],\"ratio_ok\":{},\"rho_inconsistent\":{},\"ok\":{}}}",
                    if p == 7 { "S4" } else { "A5" },
                    mult.map(|m| m.to_string()).unwrap_or_else(|| "null".into()),
                    cls.join(","),
                    ratio_ok,
                    poly_rho_inconsistent,
                    ok
                );
            }
        }
        if p == 11 && poly_json != "null" {
            // stash A5 block; S4 block stashed at p==7 below
        }
        // build per-q JSON
        let mut fam_pair_items: Vec<String> = Vec::new();
        for (k, (c, v)) in &fam_pair_v4 {
            fam_pair_items.push(format!(
                "{{\"family\":\"V4\",\"k_split\":{},\"count\":{},\"value\":{}}}",
                k, c, v
            ));
        }
        for ((m, t), (c, v, torus, delta)) in &fam_pair_m {
            fam_pair_items.push(format!(
                "{{\"family\":\"D2m\",\"m\":{},\"torus\":\"{}\",\"delta\":{},\"refl_split\":{},\"count\":{},\"value\":{}}}",
                m, torus, delta, t, c, v
            ));
        }
        let mut fam_tri_items: Vec<String> = Vec::new();
        for (s, (c, v)) in &fam_tri_v4 {
            fam_tri_items.push(format!(
                "{{\"family\":\"V4\",\"s_split\":{},\"count\":{},\"value\":{}}}",
                s, c, v
            ));
        }
        for ((go, d_odd, t), (c, v, torus, paper)) in &fam_tri_d4n {
            fam_tri_items.push(format!(
                "{{\"family\":\"D4n\",\"group_order\":{},\"n\":{},\"d_class\":\"{}\",\"torus\":\"{}\",\"refl_split\":{},\"count\":{},\"value\":{},\"sec9_value\":{}}}",
                go,
                go / 4,
                if *d_odd { "odd" } else { "even" },
                torus,
                t,
                c,
                v,
                paper
            ));
        }
        per_q_json.push(format!(
            "    {{\"q\":{},\"involutions\":{},\n     \"pairs\":{{\"total\":{},\"v4\":{},\"tame_m_ge_3\":{},\"wild\":{},\"m_histogram\":{},\"value_histogram\":{},\"families\":[{}]}},\n     \"triples\":{{\"total\":{},\"gate_candidates\":{},\"legal_tame_dihedral\":{},\"excluded\":{{\"nondihedral_commuting\":{},\"wild\":{},\"collinear\":{}}},\"value_histogram\":{},\"families\":[{}]}},\n     \"full_closure_check\":{},\n     \"polyhedral_overlap\":{}}}",
            p,
            ninv,
            pair_total,
            pair_v4,
            pair_m3,
            pair_wild,
            histm_json(&pair_m_hist),
            hist_json(&pair_v_hist),
            fam_pair_items.join(","),
            ntrip,
            tri_gate_candidates,
            tri_accept,
            tri_nondihedral,
            tri_wild,
            tri_collinear,
            hist_json(&tri_v_hist),
            fam_tri_items.join(","),
            fc_json,
            poly_json
        ));
        if (p == 7 || p == 11) && poly_json != "null" {
            if c284_json == "null" {
                c284_json = format!("{{\"q{}\":{}", p, poly_json);
            } else {
                c284_json = format!("{},\"q{}\":{}", c284_json, p, poly_json);
            }
        }
    }
    if c284_json != "null" {
        c284_json.push('}');
    }

    // ---- C263 comparison ----
    let mut c263_m_match = agg_m_hist.len() == c263_mhist.len();
    for &(m, c) in c263_mhist {
        if agg_m_hist.get(&m) != Some(&c) {
            c263_m_match = false;
        }
    }
    let mut c263_v_match = agg_v_hist.len() == c263_vhist.len();
    for &(v, c) in c263_vhist {
        if agg_v_hist.get(&v) != Some(&c) {
            c263_v_match = false;
        }
    }
    let c263_total_match = agg_pairs_m3 == c263_total;
    let c263_ok = c263_m_match && c263_v_match && c263_total_match;

    let fail_total = fails.formula
        + fails.closed_form
        + fails.structure
        + fails.orbit_template
        + fails.torus_anomaly
        + fails.orbit_equation
        + fails.v4_parity_law
        + fails.closure_shape
        + fails.split_class_law;
    if !path_ok
        || !cyc_ok
        || fail_total != 0
        || !c263_ok
        || !c284_s4_ok
        || !c284_a5_ok
        || !full_closure_all_agree
        || wild_dihedral_noncollinear_closure != 0
    {
        all_ok = false;
    }

    // ---- JSON ----
    let mut s = String::new();
    s.push_str("{\n");
    s.push_str("  \"task\": \"C281\",\n");
    s.push_str("  \"description\": \"per-q census of tame legal dihedral conic configurations (pairs and triples), odd prime fields q <= 23\",\n");
    s.push_str("  \"primes\": [3,5,7,11,13,17,19,23],\n");
    s.push_str("  \"full_closure_primes\": [3,5,7,11],\n");
    s.push_str(&format!("  \"nk_path_0_60\": {:?},\n", pathv));
    s.push_str(&format!("  \"nk_cycle_0_60\": {:?},\n", cycv));
    s.push_str("  \"checks\": {\n");
    s.push_str(&format!("    \"path_matches_A002187\": {},\n", path_ok));
    s.push_str(&format!("    \"cycle_matches_mex_recurrence\": {},\n", cyc_ok));
    s.push_str(&format!("    \"formula_mismatches\": {},\n", fails.formula));
    s.push_str(&format!("    \"closed_form_mismatches\": {},\n", fails.closed_form));
    s.push_str(&format!("    \"structure_failures\": {},\n", fails.structure));
    s.push_str(&format!("    \"orbit_template_value_mismatches\": {},\n", fails.orbit_template));
    s.push_str(&format!("    \"torus_anomalies\": {},\n", fails.torus_anomaly));
    s.push_str(&format!("    \"orbit_equation_violations\": {},\n", fails.orbit_equation));
    s.push_str(&format!("    \"v4_parity_law_violations\": {},\n", fails.v4_parity_law));
    s.push_str(&format!("    \"closure_shape_failures\": {},\n", fails.closure_shape));
    s.push_str(&format!("    \"split_class_law_violations\": {},\n", fails.split_class_law));
    s.push_str(&format!(
        "    \"manuscript_thmD_pair_deviations\": {},\n",
        dev_pairs_thm_d
    ));
    s.push_str(&format!(
        "    \"manuscript_sec9_triple_deviations\": {},\n",
        dev_triples_sec9
    ));
    s.push_str(&format!(
        "    \"manuscript_sec9_triple_value_deviations\": {},\n",
        dev_triples_sec9_value
    ));
    s.push_str(&format!("    \"full_closure_agreement\": {},\n", full_closure_all_agree));
    s.push_str(&format!(
        "    \"wild_dihedral_noncollinear_closure_triples\": {},\n",
        wild_dihedral_noncollinear_closure
    ));
    s.push_str(&format!("    \"c263_overlap_match\": {},\n", c263_ok));
    s.push_str(&format!("    \"c284_s4_q7_overlap_ok\": {},\n", c284_s4_ok));
    s.push_str(&format!("    \"c284_a5_q11_overlap_ok\": {},\n", c284_a5_ok));
    s.push_str(&format!("    \"all_ok\": {}\n", all_ok));
    s.push_str("  },\n");
    s.push_str(&format!(
        "  \"c263_comparison\": {{\"domain\": \"tame pairs m>=3, q in [5,7,11,13,17,19,23]\", \"pairs\": {}, \"expected_pairs\": {}, \"m_histogram\": {}, \"value_histogram\": {}, \"m_histogram_match\": {}, \"value_histogram_match\": {}}},\n",
        agg_pairs_m3,
        c263_total,
        histm_json(&agg_m_hist),
        hist_json(&agg_v_hist),
        c263_m_match,
        c263_v_match
    ));
    s.push_str(&format!("  \"c284_overlap\": {},\n", c284_json));
    s.push_str("  \"per_q\": [\n");
    s.push_str(&per_q_json.join(",\n"));
    s.push_str("\n  ]\n}\n");
    std::fs::write(&outpath, &s).expect("write json");

    println!("=== C281 dihedral census ===");
    println!("all_ok = {}", all_ok);
    println!(
        "fails: formula={} closed={} structure={} orbit_tmpl={} torus={} orbit_eq={} v4law={} closure={} splitlaw={}",
        fails.formula,
        fails.closed_form,
        fails.structure,
        fails.orbit_template,
        fails.torus_anomaly,
        fails.orbit_equation,
        fails.v4_parity_law,
        fails.closure_shape,
        fails.split_class_law
    );
    println!(
        "manuscript deviations: pairs(ThmD rho=1+delta)={} triples(Sec9 a0=1)={} of which value-affecting={}",
        dev_pairs_thm_d, dev_triples_sec9, dev_triples_sec9_value
    );
    println!(
        "c263 overlap: pairs={} (expected {}) m_match={} v_match={}",
        agg_pairs_m3, c263_total, c263_m_match, c263_v_match
    );
    println!(
        "c284 overlap: S4@q7 ok={} A5@q11 ok={}; full-closure agree={}",
        c284_s4_ok, c284_a5_ok, full_closure_all_agree
    );
    println!("wrote {}", outpath);
    if !all_ok {
        std::process::exit(1);
    }
}
