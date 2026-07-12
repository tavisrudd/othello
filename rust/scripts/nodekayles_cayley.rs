// Exact Node-Kayles Grundy values of the A5 (and S4) regular templates.
//
// Template = Cay(G, T): |G| vertices, an edge {g, g*t} per involution generator
// t in T (regular action, no deletions). Node-Kayles: a move at v deletes N[v].
// Solver: memoized Sprague-Grundy with connected-component decomposition
// (grundy of a disconnected available-set = XOR of component grundies).
// Connected components are memoized on their raw bitmask (<=60 vertices -> u64).

use std::collections::HashMap;
use std::hash::{BuildHasherDefault, Hasher};

#[derive(Default)]
struct IdHash(u64);
impl Hasher for IdHash {
    fn finish(&self) -> u64 {
        self.0
    }
    fn write(&mut self, _: &[u8]) {
        unreachable!()
    }
    fn write_u64(&mut self, n: u64) {
        self.0 = n.wrapping_mul(0x9E37_79B9_7F4A_7C15);
    }
}
type Map = HashMap<u64, u8, BuildHasherDefault<IdHash>>;

fn mul(p: &[usize], q: &[usize]) -> Vec<usize> {
    (0..q.len()).map(|i| p[q[i]]).collect()
}
fn is_ident(p: &[usize]) -> bool {
    p.iter().enumerate().all(|(i, &x)| i == x)
}
fn perm_order(p: &[usize]) -> usize {
    let mut x = p.to_vec();
    let mut o = 1;
    while !is_ident(&x) {
        x = mul(p, &x);
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
fn inv_perm(p: &[usize]) -> Vec<usize> {
    let mut r = vec![0usize; p.len()];
    for i in 0..p.len() {
        r[p[i]] = i;
    }
    r
}
fn closure(gens: &[Vec<usize>], n: usize) -> Vec<Vec<usize>> {
    let ident: Vec<usize> = (0..n).collect();
    let mut set: std::collections::HashSet<Vec<usize>> = std::collections::HashSet::new();
    set.insert(ident.clone());
    let mut frontier = vec![ident];
    while let Some(g) = frontier.pop() {
        for s in gens {
            let h = mul(&g, s);
            if set.insert(h.clone()) {
                frontier.push(h);
            }
        }
    }
    let mut v: Vec<Vec<usize>> = set.into_iter().collect();
    v.sort();
    v
}

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
// Canonical form under the left-multiplication automorphism group G (|G| perms):
// min over the G-orbit of the mask.  Left-mult by g is always an automorphism of
// the right Cayley graph, so this is a sound (value-preserving) dedup.
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
fn grundy(mask: u64, adj: &[u64], closed: &[u64], gperms: &[Vec<u32>], memo: &mut Map) -> u8 {
    if mask == 0 {
        return 0;
    }
    let mut rem = mask;
    let mut g = 0u8;
    while rem != 0 {
        let start = rem & rem.wrapping_neg();
        let comp = component(rem, start, adj);
        g ^= grundy_conn(comp, adj, closed, gperms, memo);
        rem &= !comp;
    }
    g
}
fn grundy_conn(mask: u64, adj: &[u64], closed: &[u64], gperms: &[Vec<u32>], memo: &mut Map) -> u8 {
    let key = canonical(mask, gperms);
    if let Some(&v) = memo.get(&key) {
        return v;
    }
    let mut opts = 0u64;
    let mut b = mask;
    while b != 0 {
        let v = b.trailing_zeros() as usize;
        let child = mask & !closed[v];
        let cg = grundy(child, adj, closed, gperms, memo);
        opts |= 1u64 << cg;
        b &= b - 1;
    }
    let m = (!opts).trailing_zeros() as u8;
    memo.insert(key, m);
    m
}

fn solve_group(n: usize, even_only: bool, name: &str, filter: Option<&[usize]>) {
    let ident: Vec<usize> = (0..n).collect();
    let target = if even_only { fact(n) / 2 } else { fact(n) };
    let els: Vec<Vec<usize>> = all_perms(n)
        .into_iter()
        .filter(|p| !even_only || sign(p) == 1)
        .collect();
    let invols: Vec<Vec<usize>> = els
        .iter()
        .filter(|p| !is_ident(p) && is_ident(&mul(p, p)))
        .cloned()
        .collect();
    // one representative generating triple per pairwise-order signature
    let mut reps: std::collections::BTreeMap<Vec<usize>, [Vec<usize>; 3]> =
        std::collections::BTreeMap::new();
    for i in 0..invols.len() {
        for j in (i + 1)..invols.len() {
            for k in (j + 1)..invols.len() {
                let tri = [invols[i].clone(), invols[j].clone(), invols[k].clone()];
                if closure(&tri, n).len() != target {
                    continue;
                }
                let mut sig = vec![
                    perm_order(&mul(&tri[0], &tri[1])),
                    perm_order(&mul(&tri[0], &tri[2])),
                    perm_order(&mul(&tri[1], &tri[2])),
                ];
                sig.sort();
                reps.entry(sig).or_insert(tri);
            }
        }
    }
    println!(
        "=== {} |G|={} involutions={} classes={} ===",
        name,
        target,
        invols.len(),
        reps.len()
    );
    for (sig, tri) in &reps {
        if let Some(f) = filter {
            if sig.as_slice() != f {
                continue;
            }
        }
        let group = closure(tri, n);
        let idx: HashMap<Vec<usize>, usize> = group
            .iter()
            .cloned()
            .enumerate()
            .map(|(i, g)| (g, i))
            .collect();
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
        let closed: Vec<u64> = (0..v).map(|x| adj[x] | (1u64 << x)).collect();
        // Full graph-automorphism group of Cay(G,T):
        //   left-multiplications L_a (a in G)  x  color-permuting conjugations
        //   c_s: h -> s h s^-1 for s in S_n with s T s^-1 = T (setwise).
        let sn = all_perms(n);
        let mut stab: Vec<Vec<u32>> = Vec::new();
        for s in &sn {
            let sinv = inv_perm(s);
            let conj = |h: &[usize]| mul(s, &mul(h, &sinv));
            if tri.iter().all(|t| {
                let ct = conj(t);
                tri.iter().any(|x| *x == ct)
            }) {
                stab.push(group.iter().map(|h| idx[&conj(h)] as u32).collect());
            }
        }
        let leftmul: Vec<Vec<u32>> = group
            .iter()
            .map(|g| group.iter().map(|h| idx[&mul(g, h)] as u32).collect())
            .collect();
        let mut gperms: Vec<Vec<u32>> = Vec::with_capacity(leftmul.len() * stab.len());
        for la in &leftmul {
            for c in &stab {
                gperms.push(c.iter().map(|&ci| la[ci as usize]).collect());
            }
        }
        eprintln!(
            "  [aut group size used: {} = {} left-mult x {} color-perm]",
            gperms.len(),
            leftmul.len(),
            stab.len()
        );
        let full = if v == 64 { u64::MAX } else { (1u64 << v) - 1 };
        let mut memo: Map = Map::default();
        let val = grundy(full, &adj, &closed, &gperms, &mut memo);
        let _ = ident;
        println!(
            "  class sig={:?}: Cay on {} vtx  Node-Kayles G = {}  (memo states: {})",
            sig,
            v,
            val,
            memo.len()
        );
    }
}
fn fact(n: usize) -> usize {
    (1..=n).product()
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let which = args.get(1).map(|s| s.as_str()).unwrap_or("A5");
    let filter: Option<Vec<usize>> = args
        .get(2)
        .map(|s| s.split(',').map(|x| x.trim().parse().unwrap()).collect());
    let f = filter.as_deref();
    match which {
        "S4" => solve_group(4, false, "S4", f),
        "A5" => solve_group(5, true, "A5", f),
        _ => println!("unknown"),
    }
}
