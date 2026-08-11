// C756 — oriented coherence census for the saturated-internal branch.
//
// A saturated-internal conic-filling arc over F_q (q odd) forces, by the
// 2026-08-10 dual-3-net reduction, an oriented support
//
//     Z = {z_1, ..., z_k} subset F_{q^2} \ F_q,     k = (q+3)/2,
//
// satisfying the sign-coherence relations (equations (3)-(4) of
// notes/2026-08-10-c756-coherent-dual-three-net.md)
//
//     chi_{q^2}(z_i - z_j)   =  c      (i != j),
//     chi_{q^2}(z_i - z_j^q) = -c      (i != j),      c = (-1)^{(q+1)/2}.
//
// The diagonal relation chi_{q^2}(z_i - z_i^q) = c is automatic.  This program
// enumerates every such set exhaustively.  Coherence is only NECESSARY: it
// ignores the arc condition and the covering condition, so an empty census is a
// complete negative for the saturated-internal branch over that field, while a
// nonempty census must be filtered further (as it is at q = 5).
//
// Relation to the earlier census.  notes/2026-08-01-c756-saturated-internal-audit.rs
// enumerates unoriented internal-point sets satisfying the pairwise chord-externality
// condition chi_q(Res) = -1 and then tests whether the Segre sign system
// s_ij = chi_{q^2}(z_i - z_j^q) is a sigma-coboundary, sigma = (-1)^{(q+1)/2+1} = -c.
// That is the same condition: the coboundary sign epsilon_i is exactly the choice of
// lift z_i versus z_i^q made here.  Searching in the oriented graph applies both
// constraints at every node of the search instead of only at the leaves, which is
// what makes q >= 47 reachable.  The two programs share only the field construction,
// and their `coherent` counts must agree on every common q; that is the cross-check.
//
// Normalization.  One vertex is fixed: z_0, the lift of the first trace-zero internal
// point in the deterministic element order, chosen exactly as in the 2026-08-01 audit.
// PGL(2,q) is transitive on internal points, and the global orientation flip
// z_i -> z_i^q maps coherent sets to coherent sets, so fixing one lift of one internal
// point loses nothing.  Reported counts are therefore normalized counts: coherent
// oriented sets containing z_0, not projective orbits.
//
// F_{q^2} is built as F_p[x]/(g) with g the first primitive polynomial in the
// deterministic encoding order used by the 2026-08-01 audit (see Field::build).
// No randomness anywhere; output is one canonical JSON document on stdout.
//
// Build:  rustc -O -o /tmp/c756coh notes/2026-08-11-c756-coherent-orientation-census.rs
// Run:    /tmp/c756coh              # default q list
//         /tmp/c756coh 5 7 25 27    # explicit q list

use std::env;

/// Vertex bound above which the exact maximum-clique pass is skipped (reported as null).
const OMEGA_VERTEX_LIMIT: usize = 4096;

struct Field {
    p: usize,
    q: usize,
    q2: usize,
    modulus: usize, // encoding of g (base-p digits)
    logt: Vec<u32>, // log of nonzero elements, logt[0] unused
    expt: Vec<u32>, // expt[i] = g^i, i in 0..q2-1
    frobt: Vec<u32>,
}

fn smallest_prime_factor(mut m: usize) -> usize {
    let mut d = 2;
    while d * d <= m {
        if m % d == 0 {
            return d;
        }
        d += 1;
    }
    m
}

fn poly_digits(mut e: usize, p: usize, len: usize) -> Vec<usize> {
    let mut v = vec![0usize; len];
    for i in 0..len {
        v[i] = e % p;
        e /= p;
    }
    v
}

fn digits_enc(v: &[usize], p: usize) -> usize {
    let mut e = 0usize;
    for i in (0..v.len()).rev() {
        e = e * p + v[i];
    }
    e
}

impl Field {
    fn build(q: usize) -> Field {
        let p = smallest_prime_factor(q);
        let mut n = 0usize;
        let mut t = q;
        while t > 1 {
            t /= p;
            n += 1;
        }
        let deg = 2 * n;
        let q2 = q * q;
        let pdeg = q2; // p^deg
        for rest in 0..pdeg {
            if rest % p == 0 {
                continue; // constant term zero
            }
            let g = poly_digits(rest, p, deg); // low digits; leading coeff 1 implicit
            let mut expt: Vec<u32> = Vec::with_capacity(q2 - 1);
            let mut cur = vec![0usize; deg];
            cur[0] = 1; // x^0 = 1
            expt.push(digits_enc(&cur, p) as u32);
            let mut ok = true;
            for i in 1..q2 {
                let top = cur[deg - 1];
                for j in (1..deg).rev() {
                    cur[j] = cur[j - 1];
                }
                cur[0] = 0;
                if top != 0 {
                    for j in 0..deg {
                        cur[j] = (cur[j] + (p - top % p) * g[j]) % p;
                    }
                }
                let enc = digits_enc(&cur, p);
                if enc == 1 {
                    if i != q2 - 1 {
                        ok = false;
                    }
                    break;
                }
                if i == q2 - 1 {
                    ok = false;
                    break;
                }
                expt.push(enc as u32);
            }
            if ok && expt.len() == q2 - 1 {
                let mut logt = vec![0u32; q2];
                for (i, &e) in expt.iter().enumerate() {
                    logt[e as usize] = i as u32;
                }
                let mut f = Field {
                    p,
                    q,
                    q2,
                    modulus: pdeg + rest,
                    logt,
                    expt,
                    frobt: vec![],
                };
                let mut frobt = vec![0u32; q2];
                for e in 1..q2 {
                    let l = f.logt[e] as usize;
                    frobt[e] = f.expt[(l * q) % (q2 - 1)];
                }
                f.frobt = frobt;
                return f;
            }
        }
        panic!("no primitive polynomial found for q={}", q);
    }
    fn add(&self, a: usize, b: usize) -> usize {
        let (mut a, mut b, p) = (a, b, self.p);
        let mut r = 0usize;
        let mut mult = 1usize;
        while a > 0 || b > 0 {
            r += ((a % p + b % p) % p) * mult;
            a /= p;
            b /= p;
            mult *= p;
        }
        r
    }
    fn neg(&self, a: usize) -> usize {
        let (mut a, p) = (a, self.p);
        let mut r = 0usize;
        let mut mult = 1usize;
        while a > 0 {
            r += ((p - a % p) % p) * mult;
            a /= p;
            mult *= p;
        }
        r
    }
    fn sub(&self, a: usize, b: usize) -> usize {
        self.add(a, self.neg(b))
    }
    fn mul(&self, a: usize, b: usize) -> usize {
        if a == 0 || b == 0 {
            return 0;
        }
        let l = (self.logt[a] as usize + self.logt[b] as usize) % (self.q2 - 1);
        self.expt[l] as usize
    }
    /// quadratic character of F_{q^2}
    fn chi(&self, a: usize) -> i32 {
        if a == 0 {
            0
        } else if self.logt[a] % 2 == 0 {
            1
        } else {
            -1
        }
    }
    fn frob(&self, a: usize) -> usize {
        if a == 0 {
            0
        } else {
            self.frobt[a] as usize
        }
    }
}

fn popcount(bs: &[u64]) -> u32 {
    bs.iter().map(|w| w.count_ones()).sum()
}

struct Search<'a> {
    adj: &'a [Vec<u64>],
    nw: usize,
    nodes: u64,
    found: u64,
    witness: Option<Vec<usize>>,
    max_depth: usize,
    best: usize,
    best_set: Vec<usize>,
    omega_nodes: u64,
}

/// Greedy sequential colouring of `cand`; returns the vertices in nondecreasing colour
/// order together with their colours.  A vertex of colour `k` cannot extend a clique by
/// more than `k`, which is the branch-and-bound bound used by `Search::omega`.
fn color_sort(adj: &[Vec<u64>], nw: usize, cand: &[u64]) -> (Vec<usize>, Vec<usize>) {
    let mut uncolored = cand.to_vec();
    let mut order: Vec<usize> = Vec::new();
    let mut colors: Vec<usize> = Vec::new();
    let mut k = 0usize;
    while popcount(&uncolored) > 0 {
        k += 1;
        let mut avail = uncolored.clone();
        while popcount(&avail) > 0 {
            let mut v = usize::MAX;
            for w in 0..nw {
                if avail[w] != 0 {
                    v = w * 64 + avail[w].trailing_zeros() as usize;
                    break;
                }
            }
            uncolored[v / 64] &= !(1u64 << (v % 64));
            avail[v / 64] &= !(1u64 << (v % 64));
            for w in 0..nw {
                avail[w] &= !adj[v][w];
            }
            order.push(v);
            colors.push(k);
        }
    }
    (order, colors)
}

impl<'a> Search<'a> {
    /// Exact maximum clique inside `cand` (Tomita-style colouring bound).
    fn omega(&mut self, chosen: &mut Vec<usize>, cand: &[u64]) {
        self.omega_nodes += 1;
        let (order, colors) = color_sort(self.adj, self.nw, cand);
        let mut p = cand.to_vec();
        for idx in (0..order.len()).rev() {
            if chosen.len() + colors[idx] <= self.best {
                return;
            }
            let v = order[idx];
            let ncand: Vec<u64> = (0..self.nw).map(|w| p[w] & self.adj[v][w]).collect();
            chosen.push(v);
            if popcount(&ncand) == 0 {
                if chosen.len() > self.best {
                    self.best = chosen.len();
                    self.best_set = chosen.clone();
                }
            } else {
                self.omega(chosen, &ncand);
            }
            chosen.pop();
            p[v / 64] &= !(1u64 << (v % 64));
        }
    }

    /// Enumerate every clique of size `need` inside `cand`, in ascending vertex order.
    fn dfs(&mut self, chosen: &mut Vec<usize>, cand: &[u64], need: usize) {
        self.nodes += 1;
        if chosen.len() > self.max_depth {
            self.max_depth = chosen.len();
        }
        if need == 0 {
            self.found += 1;
            if self.witness.is_none() {
                self.witness = Some(chosen.clone());
            }
            return;
        }
        if (popcount(cand) as usize) < need {
            return;
        }
        let mut c: Vec<u64> = cand.to_vec();
        for w in 0..self.nw {
            while c[w] != 0 {
                let b = c[w].trailing_zeros() as usize;
                let v = w * 64 + b;
                c[w] &= c[w] - 1; // clear bit v; keeps the tail strictly above v
                if (popcount(&c) as usize) + 1 < need {
                    return;
                }
                let ncand: Vec<u64> = (0..self.nw).map(|ww| c[ww] & self.adj[v][ww]).collect();
                chosen.push(v);
                self.dfs(chosen, &ncand, need - 1);
                chosen.pop();
            }
        }
    }
}

fn census(q: usize) -> String {
    let f = Field::build(q);
    let k = (q + 3) / 2;
    let h = (q + 1) / 2;
    let c: i32 = if h % 2 == 0 { 1 } else { -1 };

    // Fixed vertex: the lift, smaller in encoding order, of the first trace-zero
    // internal point.  Same normalization as the 2026-08-01 audit.
    let mut z0 = usize::MAX;
    for z in 1..f.q2 {
        let zq = f.frob(z);
        if zq != z && f.add(z, zq) == 0 && z < zq {
            z0 = z;
            break;
        }
    }
    assert!(z0 != usize::MAX, "no trace-zero internal point");
    // sanity: the diagonal relation of the reduction
    assert_eq!(f.chi(f.sub(z0, f.frob(z0))), c, "diagonal sign law");

    let coherent_pair = |a: usize, b: usize| -> bool {
        f.chi(f.sub(a, b)) == c && f.chi(f.sub(a, f.frob(b))) == -c
    };
    // the relation is symmetric: (z_i - z_j^q)^q = -(z_j - z_i^q) and chi(-1) = 1
    {
        let mut checked = 0usize;
        for z in 0..f.q2 {
            if f.frob(z) == z || z == z0 {
                continue;
            }
            if coherent_pair(z0, z) != coherent_pair(z, z0) {
                panic!("adjacency asymmetry at q={}", q);
            }
            checked += 1;
            if checked > 4 * q {
                break;
            }
        }
    }

    let verts: Vec<usize> = (0..f.q2)
        .filter(|&z| f.frob(z) != z && z != z0 && coherent_pair(z0, z))
        .collect();
    let nv = verts.len();
    let nw = nv.div_ceil(64).max(1);
    let mut adj: Vec<Vec<u64>> = vec![vec![0u64; nw]; nv];
    for i in 0..nv {
        for j in (i + 1)..nv {
            if coherent_pair(verts[i], verts[j]) {
                adj[i][j / 64] |= 1 << (j % 64);
                adj[j][i / 64] |= 1 << (i % 64);
            }
        }
    }

    let full: Vec<u64> = (0..nw)
        .map(|w| {
            let lo = w * 64;
            if lo + 64 <= nv {
                !0u64
            } else if lo >= nv {
                0
            } else {
                (1u64 << (nv - lo)) - 1
            }
        })
        .collect();

    let mut s = Search {
        adj: &adj,
        nw,
        nodes: 0,
        found: 0,
        witness: None,
        max_depth: 0,
        best: 0,
        best_set: Vec::new(),
        omega_nodes: 0,
    };
    let mut chosen: Vec<usize> = Vec::new();
    s.dfs(&mut chosen, &full, k - 1);
    // The maximum-coherent-set computation is exponentially harder than the census and is
    // skipped above a fixed vertex bound; the census itself is never skipped.
    if nv <= OMEGA_VERTEX_LIMIT {
        let mut chosen2: Vec<usize> = Vec::new();
        s.omega(&mut chosen2, &full);
    }
    // the census must be consistent with the maximum: a coherent k-set exists only if
    // the maximum coherent set through z0 has at least k elements
    assert!(
        s.found == 0 || s.best + 1 >= k,
        "census/omega inconsistency at q={}",
        q
    );

    let witness = match &s.witness {
        None => "null".to_string(),
        Some(w) => {
            let mut zs: Vec<usize> = w.iter().map(|&i| verts[i]).collect();
            zs.push(z0);
            zs.sort_unstable();
            format!(
                "[{}]",
                zs.iter()
                    .map(|z| z.to_string())
                    .collect::<Vec<_>>()
                    .join(",")
            )
        }
    };

    let omega_run = nv <= OMEGA_VERTEX_LIMIT;
    let omega_txt = if omega_run {
        (s.best + 1).to_string()
    } else {
        "null".to_string()
    };
    let mut omega_set: Vec<usize> = s.best_set.iter().map(|&i| verts[i]).collect();
    if omega_run {
        omega_set.push(z0);
    }
    omega_set.sort_unstable();

    format!(
        "{{\"q\":{},\"p\":{},\"k\":{},\"c\":{},\"modulus\":{},\"z0\":{},\
\"n_vertices\":{},\"coherent\":{},\"search_nodes\":{},\"max_depth\":{},\"witness_z\":{},\
\"omega\":{},\"omega_nodes\":{},\"omega_set_z\":[{}]}}",
        q,
        f.p,
        k,
        c,
        f.modulus,
        z0,
        nv,
        s.found,
        s.nodes,
        s.max_depth + 1,
        witness,
        omega_txt,
        s.omega_nodes,
        omega_set
            .iter()
            .map(|z| z.to_string())
            .collect::<Vec<_>>()
            .join(",")
    )
}

fn main() {
    let args: Vec<usize> = env::args()
        .skip(1)
        .map(|a| a.parse().expect("q must be a positive integer"))
        .collect();
    let qs: Vec<usize> = if args.is_empty() {
        vec![
            5, 7, 9, 11, 13, 17, 19, 23, 25, 27, 29, 31, 37, 41, 43, 47, 49, 53, 59, 61, 67, 71,
            73, 79, 81, 83, 89, 97, 101, 103, 107, 109, 113, 121, 125, 127, 169,
        ]
    } else {
        args
    };
    let rows: Vec<String> = qs.iter().map(|&q| census(q)).collect();
    println!(
        "{{\"task\":\"C756\",\"family\":\"saturated-internal\",\"census\":\"oriented coherence\",\
\"normalization\":\"one fixed oriented vertex z0 (first trace-zero internal point, smaller lift); \
counts are normalized coherent sets, not projective orbits\",\"rows\":[\n{}\n]}}",
        rows.join(",\n")
    );
}
