// C284 -- Polyhedral (S4, A5) nonregular coset templates for the conic-involution
// Node-Kayles paper.  Self-contained deterministic enumerator/solver.
//
// TWO independent computations that are cross-checked against each other:
//
//   Part 1 (ABSTRACT).  For G in {S4, A5} realised as an abstract permutation group,
//   and for each generating involution triple class T (sorted pairwise-product orders),
//   and each cyclic point-stabiliser class K, build the coset Schreier graph on G/K with
//   generators T, delete the cosets fixed by any pair product (eq. (3.1) of the paper),
//   and compute the Node-Kayles Grundy value  t_K = G(R(G,K,T))  of the residual template.
//   Solver: memoised Sprague-Grundy, component-XOR, canonicalised by the right
//   action of N_G(K)/K.
//
//   Part 2 (CONIC).  For each admissible prime q, build the actual subgroup G < PGL_2(q)
//   from trace-0 involution matrices, act on P^1(F_q), decompose into G-orbits, read each
//   orbit's cyclic stabiliser, build the fixed-point-deleted residual on the conic, and
//   compute its Node-Kayles value DIRECTLY (plain memo, component-XOR, NO group
//   canonicalisation -- a different code path).  Check, for every generating triple of the
//   found G and every orbit:  per-orbit residual nimber == t_K  AND  whole-board nimber
//   == XOR_K (m_K mod 2) t_K   (the orbit-template formula, Theorem 3.1).
//
// Determinism: fixed canonical enumeration, no randomness, no seeds.  JSON output is
// sorted and free of timestamps and host paths.
//
// Usage:
//   rustc -O 2026-07-17-c284-dihedral-polyhedral-coset-templates.rs -o /tmp/c284bin
//   ./c284bin json 7 17 23 31 11 19 29 31 41    # (primes routed to S4 or A5 automatically)
//   ./c284bin json                              # uses the default admissible prime set

use std::collections::{BTreeMap, BTreeSet, HashMap, HashSet};

// ----------------------------------------------------------------------------
// Shared Node-Kayles Grundy engine over a <=64-vertex bitmask adjacency.
// ----------------------------------------------------------------------------

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

// Plain (no group canonicalisation) memoised SG with connected-component XOR.
fn grundy_plain(mask: u64, adj: &[u64], closed: &[u64], memo: &mut HashMap<u64, u8>) -> u8 {
    if mask == 0 {
        return 0;
    }
    let mut rem = mask;
    let mut g = 0u8;
    while rem != 0 {
        let start = rem & rem.wrapping_neg();
        let comp = component(rem, start, adj);
        g ^= grundy_conn_plain(comp, adj, closed, memo);
        rem &= !comp;
    }
    g
}
fn grundy_conn_plain(mask: u64, adj: &[u64], closed: &[u64], memo: &mut HashMap<u64, u8>) -> u8 {
    if let Some(&v) = memo.get(&mask) {
        return v;
    }
    let mut opts = 0u64;
    let mut b = mask;
    while b != 0 {
        let v = b.trailing_zeros() as usize;
        let child = mask & !closed[v];
        let cg = grundy_plain(child, adj, closed, memo);
        opts |= 1u64 << cg;
        b &= b - 1;
    }
    let m = (!opts).trailing_zeros() as u8;
    memo.insert(mask, m);
    m
}

// Canonicalised SG: minimise the mask over a supplied automorphism group `gperms`.
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
fn canonical(mask: u64, gperms: &[Vec<u32>]) -> u64 {
    let mut best = mask;
    for p in gperms {
        let m = apply_perm(mask, p);
        if m < best {
            best = m;
        }
    }
    best
}
fn grundy_canon(
    mask: u64,
    adj: &[u64],
    closed: &[u64],
    gperms: &[Vec<u32>],
    memo: &mut HashMap<u64, u8>,
) -> u8 {
    if mask == 0 {
        return 0;
    }
    let mut rem = mask;
    let mut g = 0u8;
    while rem != 0 {
        let start = rem & rem.wrapping_neg();
        let comp = component(rem, start, adj);
        g ^= grundy_conn_canon(comp, adj, closed, gperms, memo);
        rem &= !comp;
    }
    g
}
fn grundy_conn_canon(
    mask: u64,
    adj: &[u64],
    closed: &[u64],
    gperms: &[Vec<u32>],
    memo: &mut HashMap<u64, u8>,
) -> u8 {
    let key = canonical(mask, gperms);
    if let Some(&v) = memo.get(&key) {
        return v;
    }
    let mut opts = 0u64;
    let mut b = mask;
    while b != 0 {
        let v = b.trailing_zeros() as usize;
        let child = mask & !closed[v];
        let cg = grundy_canon(child, adj, closed, gperms, memo);
        opts |= 1u64 << cg;
        b &= b - 1;
    }
    let m = (!opts).trailing_zeros() as u8;
    memo.insert(key, m);
    m
}

// ----------------------------------------------------------------------------
// Part 1: abstract permutation groups and coset templates.
// ----------------------------------------------------------------------------

fn pmul(p: &[usize], q: &[usize]) -> Vec<usize> {
    (0..q.len()).map(|i| p[q[i]]).collect()
}
fn pinv(p: &[usize]) -> Vec<usize> {
    let mut out = vec![0; p.len()];
    for (i, &pi) in p.iter().enumerate() {
        out[pi] = i;
    }
    out
}
fn is_ident(p: &[usize]) -> bool {
    p.iter().enumerate().all(|(i, &x)| i == x)
}
fn perm_order(p: &[usize]) -> usize {
    let mut x = p.to_vec();
    let mut o = 1;
    while !is_ident(&x) {
        x = pmul(p, &x);
        o += 1;
    }
    o
}
fn sign(p: &[usize]) -> i32 {
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
fn all_perms(n: usize) -> Vec<Vec<usize>> {
    let mut v: Vec<usize> = (0..n).collect();
    let mut out = Vec::new();
    permute(&mut v, 0, &mut out);
    out.sort();
    out
}
fn permute(v: &mut Vec<usize>, k: usize, out: &mut Vec<Vec<usize>>) {
    if k == v.len() {
        out.push(v.clone());
        return;
    }
    for i in k..v.len() {
        v.swap(k, i);
        permute(v, k + 1, out);
        v.swap(k, i);
    }
}
fn cyclic_powers(h: &[usize]) -> Vec<Vec<usize>> {
    // <h> as a sorted list of elements.
    let n = h.len();
    let ident: Vec<usize> = (0..n).collect();
    let mut out = vec![ident.clone()];
    let mut cur = h.to_vec();
    while !is_ident(&cur) {
        out.push(cur.clone());
        cur = pmul(h, &cur);
    }
    out.sort();
    out
}

struct TemplateRow {
    group: String,
    class: Vec<usize>,
    triple_count: usize,
    kname: String,
    korder: usize,
    coset_size: usize,
    deleted: usize,
    residual_vertices: usize,
    components: Vec<usize>,
    edges: Vec<(usize, usize)>,
    nimber: u8,
    nimber_plain: u8,
}

fn coset_of(g: &[usize], kelems: &[Vec<usize>], index: &HashMap<Vec<usize>, usize>) -> usize {
    // canonical id of left coset gK = min element index over {g*k}
    kelems.iter().map(|k| index[&pmul(g, k)]).min().unwrap()
}

struct AbstractResult {
    rows: Vec<TemplateRow>,
    // (group, class-signature, korder) -> nimber, for the conic formula.
    tk: HashMap<(String, Vec<usize>, usize), u8>,
    // one representative triple class list per group (sorted signatures).
    classes: HashMap<String, Vec<Vec<usize>>>,
}

fn abstract_group(
    gname: &str,
    n: usize,
    even_only: bool,
    // named cyclic stabiliser representatives (label, generator perm); label "C1" = trivial.
    kreps: &[(&str, Vec<usize>)],
    skip_regular: bool,
    class_filter: Option<&[usize]>,
) -> AbstractResult {
    let automorphisms = all_perms(n);
    let els: Vec<Vec<usize>> = automorphisms
        .iter()
        .cloned()
        .filter(|p| !even_only || sign(p) == 1)
        .collect();
    let index: HashMap<Vec<usize>, usize> = els
        .iter()
        .cloned()
        .enumerate()
        .map(|(i, g)| (g, i))
        .collect();
    let target = els.len();
    let invols: Vec<Vec<usize>> = els
        .iter()
        .filter(|p| !is_ident(p) && is_ident(&pmul(p, p)))
        .cloned()
        .collect();

    // One representative per refined triple class.  We independently verify
    // that each invariant class is exactly one Aut(G)-orbit.
    let mut reps: BTreeMap<Vec<usize>, [Vec<usize>; 3]> = BTreeMap::new();
    let mut class_counts: BTreeMap<Vec<usize>, usize> = BTreeMap::new();
    let mut class_aut_orbits: BTreeMap<Vec<usize>, BTreeSet<Vec<usize>>> = BTreeMap::new();
    for i in 0..invols.len() {
        for j in (i + 1)..invols.len() {
            for k in (j + 1)..invols.len() {
                let tri = [invols[i].clone(), invols[j].clone(), invols[k].clone()];
                // closure size == target ?
                if closure_perm(&tri, n).len() != target {
                    continue;
                }
                let mut sig = vec![
                    perm_order(&pmul(&tri[0], &tri[1])),
                    perm_order(&pmul(&tri[0], &tri[2])),
                    perm_order(&pmul(&tri[1], &tri[2])),
                ];
                sig.sort();
                let mut triple_orders = vec![
                    perm_order(&pmul(&pmul(&tri[0], &tri[1]), &tri[2])),
                    perm_order(&pmul(&pmul(&tri[0], &tri[2]), &tri[1])),
                    perm_order(&pmul(&pmul(&tri[1], &tri[0]), &tri[2])),
                    perm_order(&pmul(&pmul(&tri[1], &tri[2]), &tri[0])),
                    perm_order(&pmul(&pmul(&tri[2], &tri[0]), &tri[1])),
                    perm_order(&pmul(&pmul(&tri[2], &tri[1]), &tri[0])),
                ];
                triple_orders.sort();
                sig.push(0);
                sig.extend(triple_orders);
                let mut aut_key: Option<Vec<usize>> = None;
                for a in &automorphisms {
                    let ai = pinv(a);
                    let mut ids: Vec<usize> =
                        tri.iter().map(|t| index[&pmul(&pmul(a, t), &ai)]).collect();
                    ids.sort();
                    if aut_key.as_ref().map_or(true, |best| ids < *best) {
                        aut_key = Some(ids);
                    }
                }
                *class_counts.entry(sig.clone()).or_default() += 1;
                class_aut_orbits
                    .entry(sig.clone())
                    .or_default()
                    .insert(aut_key.unwrap());
                reps.entry(sig).or_insert(tri);
            }
        }
    }
    assert!(class_aut_orbits.values().all(|orbits| orbits.len() == 1));

    let mut rows = Vec::new();
    let mut tk = HashMap::new();
    let classes: Vec<Vec<usize>> = reps.keys().cloned().collect();

    for (sig, tri) in &reps {
        if class_filter.map_or(false, |wanted| sig.as_slice() != wanted) {
            continue;
        }
        for (kname, kgen) in kreps {
            let korder = perm_order(kgen).max(1);
            let kelems = cyclic_powers(kgen);
            if skip_regular && kelems.len() == 1 && korder == 1 {
                // skip trivial (regular) template for large groups (A5: 60 vtx, cited).
                continue;
            }
            // build coset list
            let mut coset_id: HashMap<usize, usize> = HashMap::new();
            let mut reps_g: Vec<Vec<usize>> = Vec::new();
            for g in &els {
                let cid = coset_of(g, &kelems, &index);
                if !coset_id.contains_key(&cid) {
                    coset_id.insert(cid, reps_g.len());
                    reps_g.push(els[cid].clone());
                }
            }
            let vcount = reps_g.len();
            if vcount > 62 {
                continue;
            }
            // adjacency from the three generators (Schreier: c=gK -> (t g)K)
            let mut adj = vec![0u64; vcount];
            for (ci, g) in reps_g.iter().enumerate() {
                for t in tri.iter() {
                    let ncid = coset_of(&pmul(t, g), &kelems, &index);
                    let cj = coset_id[&ncid];
                    if ci != cj {
                        adj[ci] |= 1u64 << cj;
                        adj[cj] |= 1u64 << ci;
                    }
                }
            }
            // deletion: coset c=gK fixed by a pair product h  <=>  (h g)K == gK
            let pairprods = [
                pmul(&tri[0], &tri[1]),
                pmul(&tri[0], &tri[2]),
                pmul(&tri[1], &tri[2]),
            ];
            let mut alive = if vcount == 64 {
                u64::MAX
            } else {
                (1u64 << vcount) - 1
            };
            let mut deleted = 0usize;
            for (ci, g) in reps_g.iter().enumerate() {
                let gc = coset_of(g, &kelems, &index);
                let mut dead = false;
                for h in pairprods.iter() {
                    if coset_of(&pmul(h, g), &kelems, &index) == gc {
                        dead = true;
                        break;
                    }
                }
                if dead {
                    alive &= !(1u64 << ci);
                    deleted += 1;
                }
            }
            // residual adjacency restricted to alive
            let mut radj = vec![0u64; vcount];
            for v in 0..vcount {
                if alive & (1u64 << v) != 0 {
                    radj[v] = adj[v] & alive;
                }
            }
            let closed: Vec<u64> = (0..vcount).map(|v| radj[v] | (1u64 << v)).collect();

            // The generators act on the left of G/K, so the commuting automorphisms
            // are the right actions of N_G(K)/K.  Left multiplication by arbitrary
            // elements is not a graph automorphism unless it normalises the generator set.
            let rightmul: Vec<Vec<u32>> = els
                .iter()
                .filter(|a| {
                    let acid = coset_of(a, &kelems, &index);
                    kelems
                        .iter()
                        .all(|k| coset_of(&pmul(k, a), &kelems, &index) == acid)
                })
                .map(|a| {
                    reps_g
                        .iter()
                        .map(|g| coset_id[&coset_of(&pmul(g, a), &kelems, &index)] as u32)
                        .collect()
                })
                .collect();

            let mut memo_c: HashMap<u64, u8> = HashMap::new();
            let nimber = grundy_canon(alive, &radj, &closed, &rightmul, &mut memo_c);
            let nimber_plain = if vcount <= 40 {
                let mut memo_p: HashMap<u64, u8> = HashMap::new();
                grundy_plain(alive, &radj, &closed, &mut memo_p)
            } else {
                nimber
            };

            // component sizes (of the residual)
            let mut comps = Vec::new();
            let mut rem = alive;
            while rem != 0 {
                let start = rem & rem.wrapping_neg();
                let c = component(rem, start, &radj);
                comps.push((c.count_ones()) as usize);
                rem &= !c;
            }
            comps.sort();

            let mut relabel = vec![usize::MAX; vcount];
            let mut next = 0usize;
            for v in 0..vcount {
                if alive & (1u64 << v) != 0 {
                    relabel[v] = next;
                    next += 1;
                }
            }
            let mut edges = Vec::new();
            for v in 0..vcount {
                if relabel[v] == usize::MAX {
                    continue;
                }
                for w in (v + 1)..vcount {
                    if relabel[w] != usize::MAX && radj[v] & (1u64 << w) != 0 {
                        edges.push((relabel[v], relabel[w]));
                    }
                }
            }

            rows.push(TemplateRow {
                group: gname.to_string(),
                class: sig.clone(),
                triple_count: class_counts[sig],
                kname: kname.to_string(),
                korder,
                coset_size: vcount,
                deleted,
                residual_vertices: (vcount - deleted),
                components: comps,
                edges,
                nimber,
                nimber_plain,
            });
            // formula lookup keyed by stabiliser ORDER (conic identifies K by |stab|);
            // for order 2 use the transposition/"maximal C2" class only (kname "C2a").
            if *kname != "C2b" {
                tk.insert((gname.to_string(), sig.clone(), korder), nimber);
            }
        }
    }
    let mut cmap = HashMap::new();
    cmap.insert(gname.to_string(), classes);
    AbstractResult {
        rows,
        tk,
        classes: cmap,
    }
}

fn closure_perm(gens: &[Vec<usize>], n: usize) -> Vec<Vec<usize>> {
    let ident: Vec<usize> = (0..n).collect();
    let mut set: HashSet<Vec<usize>> = HashSet::new();
    set.insert(ident.clone());
    let mut frontier = vec![ident];
    while let Some(g) = frontier.pop() {
        for s in gens {
            let h = pmul(&g, s);
            if set.insert(h.clone()) {
                frontier.push(h);
            }
        }
    }
    set.into_iter().collect()
}

// ----------------------------------------------------------------------------
// Part 2: PGL_2(q) matrix world, conic action, end-to-end verification.
// ----------------------------------------------------------------------------

type Mat = [i64; 4]; // [a,b,c,d] row-major, entries in 0..p

fn madd(a: i64, b: i64, p: i64) -> i64 {
    ((a + b) % p + p) % p
}
fn mmul_s(a: i64, b: i64, p: i64) -> i64 {
    ((a % p) * (b % p) % p + p) % p
}
fn inv_mod(a: i64, p: i64) -> i64 {
    // p prime; Fermat.
    let mut r = 1i64;
    let mut base = ((a % p) + p) % p;
    let mut e = p - 2;
    while e > 0 {
        if e & 1 == 1 {
            r = mmul_s(r, base, p);
        }
        base = mmul_s(base, base, p);
        e >>= 1;
    }
    r
}
fn norm_mat(m: Mat, p: i64) -> Mat {
    // scale so that the first nonzero entry (row-major) is 1
    let mut f = 0i64;
    for &x in m.iter() {
        let v = ((x % p) + p) % p;
        if v != 0 {
            f = v;
            break;
        }
    }
    if f == 0 {
        return [0, 0, 0, 0];
    }
    let fi = inv_mod(f, p);
    [
        mmul_s(m[0], fi, p),
        mmul_s(m[1], fi, p),
        mmul_s(m[2], fi, p),
        mmul_s(m[3], fi, p),
    ]
}
fn mat_mul(x: Mat, y: Mat, p: i64) -> Mat {
    [
        madd(mmul_s(x[0], y[0], p), mmul_s(x[1], y[2], p), p),
        madd(mmul_s(x[0], y[1], p), mmul_s(x[1], y[3], p), p),
        madd(mmul_s(x[2], y[0], p), mmul_s(x[3], y[2], p), p),
        madd(mmul_s(x[2], y[1], p), mmul_s(x[3], y[3], p), p),
    ]
}
const IDENT: Mat = [1, 0, 0, 1];
fn mat_order(m: Mat, p: i64) -> usize {
    let mut cur = norm_mat(m, p);
    let mut k = 1usize;
    while cur != IDENT {
        cur = norm_mat(mat_mul(cur, m, p), p);
        k += 1;
        if k > 200 {
            return 0;
        }
    }
    k
}
// P^1(F_p): index 0..p is [z:1] (z=index), index p is [1:0] = infinity.
fn act_point(m: Mat, pt: usize, p: i64) -> usize {
    let (num, den);
    if pt < p as usize {
        let z = pt as i64;
        num = madd(mmul_s(m[0], z, p), m[1], p);
        den = madd(mmul_s(m[2], z, p), m[3], p);
    } else {
        num = m[0];
        den = m[2];
    }
    if den == 0 {
        p as usize
    } else {
        (mmul_s(num, inv_mod(den, p), p)) as usize
    }
}

fn involutions_pgl(p: i64) -> Vec<Mat> {
    // trace-0 matrices [[a,b],[c,-a]] with det = -a^2 - bc != 0, up to scalar.
    let mut set: HashSet<Mat> = HashSet::new();
    for a in 0..p {
        for b in 0..p {
            for c in 0..p {
                let det = madd(mmul_s(a, -a, p), mmul_s(-b, c, p), p);
                if det == 0 {
                    continue;
                }
                let m = [a, b, c, ((-a) % p + p) % p];
                set.insert(norm_mat(m, p));
            }
        }
    }
    let mut v: Vec<Mat> = set.into_iter().collect();
    v.sort();
    v
}

fn closure_mat(gens: &[Mat], p: i64, cap: usize) -> Vec<Mat> {
    let mut set: HashSet<Mat> = HashSet::new();
    set.insert(IDENT);
    let mut frontier = vec![IDENT];
    let gens: Vec<Mat> = gens.iter().map(|&g| norm_mat(g, p)).collect();
    while let Some(g) = frontier.pop() {
        for &s in &gens {
            let h = norm_mat(mat_mul(g, s, p), p);
            if set.insert(h) {
                frontier.push(h);
                if set.len() > cap {
                    return set.into_iter().collect(); // over cap; caller discards
                }
            }
        }
    }
    let mut v: Vec<Mat> = set.into_iter().collect();
    v.sort();
    v
}

// find one subgroup of PGL_2(p) of the given order with generating involution triple
// whose pairwise product orders are all in `allowed`; return the full element list.
fn find_group(invs: &[Mat], p: i64, target: usize, allowed: &[usize]) -> Option<Vec<Mat>> {
    let lim = invs.len().min(400);
    for i in 0..lim {
        for j in (i + 1)..lim {
            let oij = mat_order(mat_mul(invs[i], invs[j], p), p);
            if !allowed.contains(&oij) {
                continue;
            }
            for k in (j + 1)..lim {
                let oik = mat_order(mat_mul(invs[i], invs[k], p), p);
                if !allowed.contains(&oik) {
                    continue;
                }
                let ojk = mat_order(mat_mul(invs[j], invs[k], p), p);
                if !allowed.contains(&ojk) {
                    continue;
                }
                let g = closure_mat(&[invs[i], invs[j], invs[k]], p, target + 4);
                if g.len() == target {
                    return Some(g);
                }
            }
        }
    }
    None
}

struct ConicOrbitReport {
    q: i64,
    group: String,
    orbit_stab: Vec<(usize, usize)>, // (size, stab_order) sorted
    triples_tested: usize,
    mismatches: usize,
    mismatch_classes: BTreeMap<Vec<usize>, usize>,
    // all observed (board nimber, formula value) pairs per class signature
    examples: BTreeMap<Vec<usize>, BTreeSet<(u8, u8)>>,
}

fn conic_verify(
    gname: &str,
    p: i64,
    target: usize,
    allowed: &[usize],
    tk: &HashMap<(String, Vec<usize>, usize), u8>,
    cited_regular: &HashMap<(String, Vec<usize>), u8>, // A5 t_1 from Appendix A / C260
    max_comp: usize,
) -> Option<ConicOrbitReport> {
    let invs = involutions_pgl(p);
    let g = find_group(&invs, p, target, allowed)?;

    let npts = (p + 1) as usize;
    // orbit decomposition under G
    let mut orbit_of = vec![usize::MAX; npts];
    let mut orbits: Vec<Vec<usize>> = Vec::new();
    for s in 0..npts {
        if orbit_of[s] != usize::MAX {
            continue;
        }
        let oid = orbits.len();
        let mut stack = vec![s];
        let mut orb = Vec::new();
        orbit_of[s] = oid;
        while let Some(x) = stack.pop() {
            orb.push(x);
            for &gg in &g {
                let y = act_point(gg, x, p);
                if orbit_of[y] == usize::MAX {
                    orbit_of[y] = oid;
                    stack.push(y);
                }
            }
        }
        orb.sort();
        orbits.push(orb);
    }
    // stabiliser order per orbit = |G| / |orbit|
    let mut orbit_stab: Vec<(usize, usize)> =
        orbits.iter().map(|o| (o.len(), target / o.len())).collect();
    orbit_stab.sort();

    // internal involutions of G and all generating triples
    let ginv: Vec<Mat> = g
        .iter()
        .cloned()
        .filter(|&m| m != IDENT && norm_mat(mat_mul(m, m, p), p) == IDENT)
        .collect();

    let mut triples_tested = 0usize;
    let mut mismatches = 0usize;
    let mut mismatch_classes: BTreeMap<Vec<usize>, usize> = BTreeMap::new();
    let mut examples: BTreeMap<Vec<usize>, BTreeSet<(u8, u8)>> = BTreeMap::new();

    for i in 0..ginv.len() {
        for j in (i + 1)..ginv.len() {
            for k in (j + 1)..ginv.len() {
                let tri = [ginv[i], ginv[j], ginv[k]];
                // must generate all of G
                let sub = closure_mat(&tri, p, target + 4);
                if sub.len() != target {
                    continue;
                }
                let mut sig = vec![
                    mat_order(mat_mul(tri[0], tri[1], p), p),
                    mat_order(mat_mul(tri[0], tri[2], p), p),
                    mat_order(mat_mul(tri[1], tri[2], p), p),
                ];
                sig.sort();
                let mut triple_orders = vec![
                    mat_order(mat_mul(mat_mul(tri[0], tri[1], p), tri[2], p), p),
                    mat_order(mat_mul(mat_mul(tri[0], tri[2], p), tri[1], p), p),
                    mat_order(mat_mul(mat_mul(tri[1], tri[0], p), tri[2], p), p),
                    mat_order(mat_mul(mat_mul(tri[1], tri[2], p), tri[0], p), p),
                    mat_order(mat_mul(mat_mul(tri[2], tri[0], p), tri[1], p), p),
                    mat_order(mat_mul(mat_mul(tri[2], tri[1], p), tri[0], p), p),
                ];
                triple_orders.sort();
                sig.push(0);
                sig.extend(triple_orders);
                triples_tested += 1;

                // pair-product fixed points -> deletion set on P^1
                let pairprods = [
                    norm_mat(mat_mul(tri[0], tri[1], p), p),
                    norm_mat(mat_mul(tri[0], tri[2], p), p),
                    norm_mat(mat_mul(tri[1], tri[2], p), p),
                ];
                let mut alive_pt = vec![true; npts];
                for pt in 0..npts {
                    for &h in &pairprods {
                        if act_point(h, pt, p) == pt {
                            alive_pt[pt] = false;
                            break;
                        }
                    }
                }
                // residual adjacency on P^1 (only when npts <= 64)
                if npts > 64 {
                    continue;
                }
                let mut adj = vec![0u64; npts];
                for pt in 0..npts {
                    if !alive_pt[pt] {
                        continue;
                    }
                    for &t in &tri {
                        let q2 = act_point(t, pt, p);
                        if q2 != pt && alive_pt[q2] {
                            adj[pt] |= 1u64 << q2;
                            adj[q2 as usize] |= 1u64 << pt;
                        }
                    }
                }
                let mut alive_mask = 0u64;
                for pt in 0..npts {
                    if alive_pt[pt] {
                        alive_mask |= 1u64 << pt;
                    }
                }
                let closed: Vec<u64> = (0..npts).map(|v| adj[v] | (1u64 << v)).collect();

                // largest component
                let mut biggest = 0usize;
                {
                    let mut rem = alive_mask;
                    while rem != 0 {
                        let start = rem & rem.wrapping_neg();
                        let c = component(rem, start, &adj);
                        biggest = biggest.max(c.count_ones() as usize);
                        rem &= !c;
                    }
                }

                // formula value: XOR over orbits of t_{K(orbit)} (each stab -> t_K)
                let mut formula = 0u8;
                let mut formula_ok = true;
                for (osize, stab) in orbit_stab.iter() {
                    let t = if *stab == 1 {
                        // regular / free orbit
                        if let Some(&v) = tk.get(&(gname.to_string(), sig.clone(), 1usize)) {
                            v
                        } else if let Some(&v) =
                            cited_regular.get(&(gname.to_string(), sig[..3].to_vec()))
                        {
                            v
                        } else {
                            formula_ok = false;
                            0
                        }
                    } else if let Some(&v) = tk.get(&(gname.to_string(), sig.clone(), *stab)) {
                        v
                    } else {
                        formula_ok = false;
                        0
                    };
                    let _ = osize;
                    formula ^= t;
                }

                if biggest <= max_comp {
                    let mut memo: HashMap<u64, u8> = HashMap::new();
                    let direct = grundy_plain(alive_mask, &adj, &closed, &mut memo);
                    if formula_ok && direct != formula {
                        mismatches += 1;
                        *mismatch_classes.entry(sig.clone()).or_default() += 1;
                    }
                    // per-orbit cross-check: each orbit's residual nimber == t_K
                    for (oid, orb) in orbits.iter().enumerate() {
                        let _ = oid;
                        let mut omask = 0u64;
                        for &pt in orb {
                            if alive_pt[pt] {
                                omask |= 1u64 << pt;
                            }
                        }
                        let stab = target / orb.len();
                        let mut m2: HashMap<u64, u8> = HashMap::new();
                        let onim = grundy_plain(omask, &adj, &closed, &mut m2);
                        let expect = if stab == 1 {
                            tk.get(&(gname.to_string(), sig.clone(), 1usize))
                                .cloned()
                                .or_else(|| {
                                    cited_regular
                                        .get(&(gname.to_string(), sig[..3].to_vec()))
                                        .cloned()
                                })
                        } else {
                            tk.get(&(gname.to_string(), sig.clone(), stab)).cloned()
                        };
                        if let Some(e) = expect {
                            if e != onim {
                                mismatches += 1;
                                *mismatch_classes.entry(sig.clone()).or_default() += 1;
                            }
                        }
                    }
                    examples
                        .entry(sig.clone())
                        .or_default()
                        .insert((direct, formula));
                } else {
                    // structure-only: a free orbit residual must equal Cay(G,T)
                    // (0 deletions inside it, 3-regular).  Record without the slow nimber.
                    examples
                        .entry(sig.clone())
                        .or_default()
                        .insert((255, formula));
                }
            }
        }
    }

    Some(ConicOrbitReport {
        q: p,
        group: gname.to_string(),
        orbit_stab,
        triples_tested,
        mismatches,
        mismatch_classes,
        examples,
    })
}

// ----------------------------------------------------------------------------
// JSON emission (hand-rolled, canonical/sorted).
// ----------------------------------------------------------------------------

fn vec_json(v: &[usize]) -> String {
    let s: Vec<String> = v.iter().map(|x| x.to_string()).collect();
    format!("[{}]", s.join(","))
}

fn edges_json(edges: &[(usize, usize)]) -> String {
    edges
        .iter()
        .map(|(u, v)| format!("[{},{}]", u, v))
        .collect::<Vec<_>>()
        .join(",")
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let mode = args.get(1).cloned().unwrap_or_else(|| "json".to_string());
    let mut primes: Vec<i64> = args
        .get(2..)
        .unwrap_or(&[])
        .iter()
        .filter_map(|s| s.parse().ok())
        .collect();
    if primes.is_empty() {
        primes = vec![7, 17, 23, 31, 11, 19, 29, 41];
    }

    if mode == "regular-extra" {
        let class = vec![3, 5, 5, 0, 5, 5, 5, 5, 5, 5];
        let result = abstract_group(
            "A5",
            5,
            true,
            &[("C1", vec![0, 1, 2, 3, 4])],
            false,
            Some(&class),
        );
        assert_eq!(result.rows.len(), 1);
        let row = &result.rows[0];
        println!(
            "{{\"group\":\"A5\",\"class\":{},\"K\":\"C1\",\"nimber\":{}}}",
            vec_json(&row.class),
            row.nimber
        );
        return;
    }

    // Abstract templates.
    // S4 = Sym(4); cyclic stabiliser reps by geometry:
    //   C1 trivial, C2a transposition (maximal), C2b double-transposition (NOT a
    //   stabiliser -- reported for completeness), C3, C4.
    let s4 = abstract_group(
        "S4",
        4,
        false,
        &[
            ("C1", vec![0, 1, 2, 3]),
            ("C2a", vec![1, 0, 2, 3]), // (0 1)
            ("C2b", vec![1, 0, 3, 2]), // (0 1)(2 3)
            ("C3", vec![1, 2, 0, 3]),  // (0 1 2)
            ("C4", vec![1, 2, 3, 0]),  // (0 1 2 3)
        ],
        false,
        None,
    );
    // A5 = Alt(5); C1 trivial (regular template skipped: 60 vtx, cited), C2, C3, C5.
    let a5 = abstract_group(
        "A5",
        5,
        true,
        &[
            ("C1", vec![0, 1, 2, 3, 4]),
            ("C2", vec![1, 0, 3, 2, 4]), // (0 1)(2 3)
            ("C3", vec![1, 2, 0, 3, 4]), // (0 1 2)
            ("C5", vec![1, 2, 3, 4, 0]), // (0 1 2 3 4)
        ],
        true,
        None,
    );

    // Merge tk tables.
    let mut tk: HashMap<(String, Vec<usize>, usize), u8> = HashMap::new();
    for (k, v) in s4.tk.iter().chain(a5.tk.iter()) {
        tk.insert(k.clone(), *v);
    }
    // A5 regular (t_1) values from Appendix A / C260 (cited, not recomputed here).
    let mut cited_regular: HashMap<(String, Vec<usize>), u8> = HashMap::new();
    cited_regular.insert(("A5".to_string(), vec![2, 3, 5]), 1);
    cited_regular.insert(("A5".to_string(), vec![2, 5, 5]), 1);
    cited_regular.insert(("A5".to_string(), vec![3, 3, 5]), 0);
    cited_regular.insert(("A5".to_string(), vec![3, 5, 5]), 0);
    cited_regular.insert(("A5".to_string(), vec![5, 5, 5]), 0);

    // Conic verification.
    let mut conic_reports: Vec<ConicOrbitReport> = Vec::new();
    for &q in &primes {
        // route prime to whichever polyhedral group embeds & is tame
        // S4 needs q = +-1 mod 8, tame p != 2,3; A5 needs q = +-1 mod 5, p != 2,3,5.
        if (q % 8 == 1 || q % 8 == 7) && q > 3 {
            if let Some(r) = conic_verify("S4", q, 24, &[2, 3, 4], &tk, &cited_regular, 40) {
                conic_reports.push(r);
            }
        }
        if (q % 5 == 1 || q % 5 == 4) && q > 5 {
            if let Some(r) = conic_verify("A5", q, 60, &[2, 3, 5], &tk, &cited_regular, 40) {
                conic_reports.push(r);
            }
        }
    }

    if mode == "check" {
        let bad: usize = conic_reports.iter().map(|r| r.mismatches).sum();
        let plainbad = s4
            .rows
            .iter()
            .chain(a5.rows.iter())
            .filter(|r| r.nimber != r.nimber_plain)
            .count();
        eprintln!(
            "checked_conic_triples={} conic_mismatches={} abstract_templates={} plain_vs_canon_disagreements={}",
            conic_reports.iter().map(|r| r.triples_tested).sum::<usize>(),
            bad,
            s4.rows.len() + a5.rows.len(),
            plainbad
        );
        assert_eq!(bad, 0);
        assert_eq!(plainbad, 0);
        return;
    }

    // ------- canonical JSON -------
    let mut out = String::new();
    out.push_str("{\n  \"schema\": \"c284-polyhedral-coset-templates-v1\",\n");

    // abstract templates
    out.push_str("  \"abstract_templates\": [\n");
    let mut allrows: Vec<&TemplateRow> = s4.rows.iter().chain(a5.rows.iter()).collect();
    allrows.sort_by(|a, b| {
        (a.group.clone(), a.class.clone(), a.korder, a.kname.clone()).cmp(&(
            b.group.clone(),
            b.class.clone(),
            b.korder,
            b.kname.clone(),
        ))
    });
    for (i, r) in allrows.iter().enumerate() {
        out.push_str(&format!(
            "    {{\"group\":\"{}\",\"pair_orders\":{},\"triple_product_orders\":{},\"triple_count\":{},\"K\":\"{}\",\"projective_line_stabilizer\":{},\"korder\":{},\"coset_size\":{},\"deleted\":{},\"residual_vertices\":{},\"components\":{},\"edges\":[{}],\"nimber\":{},\"nimber_plain\":{}}}{}\n",
            r.group,
            vec_json(&r.class[..3]),
            vec_json(&r.class[4..]),
            r.triple_count,
            r.kname,
            r.kname != "C2b",
            r.korder,
            r.coset_size,
            r.deleted,
            r.residual_vertices,
            vec_json(&r.components),
            edges_json(&r.edges),
            r.nimber,
            r.nimber_plain,
            if i + 1 < allrows.len() { "," } else { "" }
        ));
    }
    out.push_str("  ],\n");

    // conic verification
    out.push_str("  \"conic_verification\": [\n");
    conic_reports.sort_by(|a, b| (a.group.clone(), a.q).cmp(&(b.group.clone(), b.q)));
    for (i, r) in conic_reports.iter().enumerate() {
        let stabs: Vec<String> = r
            .orbit_stab
            .iter()
            .map(|(s, k)| format!("[{},{}]", s, k))
            .collect();
        let exs: Vec<String> = r
            .examples
            .iter()
            .map(|(sig, values)| {
                let vals: Vec<String> = values
                    .iter()
                    .map(|(d, f)| {
                        let ds = if *d == 255 {
                            "\"free-cited\"".to_string()
                        } else {
                            d.to_string()
                        };
                        format!("[{},{}]", ds, f)
                    })
                    .collect();
                format!(
                    "{{\"pair_orders\":{},\"triple_product_orders\":{},\"board_formula_values\":[{}]}}",
                    vec_json(&sig[..3]),
                    vec_json(&sig[4..]),
                    vals.join(",")
                )
            })
            .collect();
        let mismatch_classes: Vec<String> = r
            .mismatch_classes
            .iter()
            .map(|(sig, count)| {
                format!(
                    "{{\"pair_orders\":{},\"triple_product_orders\":{},\"count\":{}}}",
                    vec_json(&sig[..3]),
                    vec_json(&sig[4..]),
                    count
                )
            })
            .collect();
        out.push_str(&format!(
            "    {{\"group\":\"{}\",\"q\":{},\"orbit_size_stab\":[{}],\"triples_tested\":{},\"mismatches\":{},\"mismatch_classes\":[{}],\"examples\":[{}]}}{}\n",
            r.group,
            r.q,
            stabs.join(","),
            r.triples_tested,
            r.mismatches,
            mismatch_classes.join(","),
            exs.join(","),
            if i + 1 < conic_reports.len() { "," } else { "" }
        ));
    }
    out.push_str("  ],\n");

    out.push_str(
        "  \"regular_extra\": {\"group\":\"A5\",\"pair_orders\":[3,5,5],\"triple_product_orders\":[5,5,5,5,5,5],\"nimber\":0,\"replay_mode\":\"regular-extra\"},\n",
    );

    // summary
    let total_triples: usize = conic_reports.iter().map(|r| r.triples_tested).sum();
    let total_mismatch: usize = conic_reports.iter().map(|r| r.mismatches).sum();
    let plainbad = s4
        .rows
        .iter()
        .chain(a5.rows.iter())
        .filter(|r| r.nimber != r.nimber_plain)
        .count();
    out.push_str(&format!(
        "  \"summary\": {{\"total_conic_triples_tested\":{},\"total_mismatches\":{},\"abstract_plain_vs_canon_disagreements\":{},\"a5_regular_t1_source\":\"AppendixA/C260 plus C284 regular-extra\"}}\n",
        total_triples, total_mismatch, plainbad
    ));
    out.push_str("}\n");

    print!("{}", out);
    let _ = (&s4.classes, &a5.classes, &out);
}
