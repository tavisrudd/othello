// C756 — saturated-internal branch: exhaustive normalized audit.
//
// A saturated-internal candidate over F_q (q odd) is a set of k = (q+3)/2 internal
// points of a fixed nonsingular conic in PG(2,q) (irreducible binary quadratics in the
// coefficient model, i.e. conjugate pairs {z, z^q} with z in F_{q^2} \ F_q) such that
// chi(Res(f_i, f_j)) = -1 for every pair (every join is a passant).  One internal point
// is fixed (legitimate: PGL(2,q) is transitive on internal points); the fixed point is
// the first trace-zero conjugate pair in the deterministic element order, i.e. X^2 - d.
//
// For every candidate the program records:
//   candidates   : sets satisfying the pairwise character condition only;
//   angle_biject : candidates with no collinear triple through the fixed point
//                  (equivalently the circle angles u^(1-q) are pairwise distinct);
//   coherent     : candidates whose Segre sign system s_ij = chi_{q^2}(z_i - z_j^q)
//                  is a (-1)^(t+1)-coboundary, t = (q+1)/2 (the report's Theorem 2
//                  proves every saturated-internal ARC is coherent);
//   arcs         : candidates in general position (no three points collinear);
//   arcs_coherent: arcs that are coherent (theorem predicts = arcs);
//   covering     : arcs whose chords cover all q^2 points off the conic
//                  (conic-filling condition (V)).
//
// F_{q^2} is built as F_p[x]/(g) with g the first primitive polynomial of degree 2n in
// the deterministic encoding order (polynomials encoded base p, most significant digit
// last removed; see fn build_field).  No randomness anywhere.
//
// Build:  rustc -O -o /tmp/c756si notes/2026-08-01-c756-saturated-internal-audit.rs
// Run:    /tmp/c756si            # default q list
//         /tmp/c756si 5 7 11     # explicit q list
// Output: one JSON document on stdout.

use std::env;

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
        // search monic g of degree deg, constant term nonzero, x primitive mod g
        for rest in 0..pdeg {
            if rest % p == 0 {
                continue; // constant term zero
            }
            let g = poly_digits(rest, p, deg); // low digits; leading coeff 1 implicit
            // iterate e = x^i as digit vector, reduce with g
            let mut expt: Vec<u32> = Vec::with_capacity(q2 - 1);
            let mut cur = vec![0usize; deg];
            cur[0] = 1; // x^0 = 1
            expt.push(digits_enc(&cur, p) as u32);
            let mut ok = true;
            for i in 1..q2 {
                // multiply by x: shift up
                let top = cur[deg - 1];
                for j in (1..deg).rev() {
                    cur[j] = cur[j - 1];
                }
                cur[0] = 0;
                if top != 0 {
                    // subtract top * (g + x^deg): x^deg = -g
                    for j in 0..deg {
                        cur[j] = (cur[j] + (p - top % p) * g[j]) % p;
                    }
                }
                let enc = digits_enc(&cur, p);
                if enc == 1 {
                    if i == q2 - 1 {
                        // primitive
                    } else {
                        ok = false;
                    }
                    break;
                }
                if i == q2 - 1 {
                    ok = false; // never returned to 1
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
    fn chi(&self, a: usize) -> i32 {
        if a == 0 {
            0
        } else if self.logt[a] % 2 == 0 {
            1
        } else {
            -1
        }
    }
    /// quadratic character of the subfield F_q, defined on subfield elements
    fn chi_q(&self, a: usize) -> i32 {
        if a == 0 {
            return 0;
        }
        let l = self.logt[a] as usize;
        let e = self.expt[(l * ((self.q - 1) / 2)) % (self.q2 - 1)] as usize;
        if e == 1 {
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

struct Pt {
    z: usize,
    zq: usize,
    row: [usize; 3], // (1, -tr, nm)
}

fn det3(f: &Field, u: &[usize; 3], v: &[usize; 3], w: &[usize; 3]) -> usize {
    let m0 = f.sub(f.mul(v[1], w[2]), f.mul(v[2], w[1]));
    let m1 = f.sub(f.mul(v[0], w[2]), f.mul(v[2], w[0]));
    let m2 = f.sub(f.mul(v[0], w[1]), f.mul(v[1], w[0]));
    f.add(f.sub(f.mul(u[0], m0), f.mul(u[1], m1)), f.mul(u[2], m2))
}

struct Counts {
    candidates: u64,
    candidates_line: u64, // the k-1 non-fixed points are collinear (line-plus-apex type)
    angle_biject: u64,
    coherent: u64,
    arcs: u64,
    arcs_coherent: u64,
    covering: u64,
    witness: Option<String>,
}

fn popcount(bs: &[u64]) -> u32 {
    bs.iter().map(|w| w.count_ones()).sum()
}

/// Enumerate all cliques of size `need` inside `cand`; `process` returns true to abort.
/// Returns true if aborted.
fn dfs(
    adj: &[Vec<u64>],
    chosen: &mut Vec<usize>,
    cand: &[u64],
    need: usize,
    process: &mut dyn FnMut(&[usize]) -> bool,
) -> bool {
    if need == 0 {
        return process(chosen);
    }
    if (popcount(cand) as usize) < need {
        return false;
    }
    // iterate the set bits of cand in ascending order; clearing each visited bit keeps
    // the remaining candidate set strictly above the current vertex, so every clique is
    // produced exactly once in ascending vertex order.
    let mut c: Vec<u64> = cand.to_vec();
    let nw = c.len();
    for w in 0..nw {
        while c[w] != 0 {
            let b = c[w].trailing_zeros() as usize;
            let v = w * 64 + b;
            c[w] &= c[w] - 1; // clear bit v
            if (popcount(&c) as usize) + 1 < need {
                return false;
            }
            let ncand: Vec<u64> = (0..nw).map(|ww| c[ww] & adj[v][ww]).collect();
            chosen.push(v);
            let abort = dfs(adj, chosen, &ncand, need - 1, process);
            chosen.pop();
            if abort {
                return true;
            }
        }
    }
    false
}

fn audit(q: usize) -> String {
    let f = Field::build(q);
    let k = (q + 3) / 2;
    let t = (q + 1) / 2;
    let sigma: i32 = if (t + 1) % 2 == 0 { 1 } else { -1 };
    let one = 1usize; // encoding of 1

    // internal points
    let mut pts: Vec<Pt> = Vec::new();
    for z in 0..f.q2 {
        let zq = f.frob(z);
        if zq == z || zq < z {
            continue;
        }
        let tr = f.add(z, zq);
        let nm = f.mul(z, zq);
        pts.push(Pt {
            z,
            zq,
            row: [one, f.neg(tr), nm],
        });
    }
    let n_internal = pts.len();
    assert_eq!(n_internal, q * (q - 1) / 2);

    // fixed point: first trace-zero pair
    let p0 = pts
        .iter()
        .position(|pt| f.add(pt.z, pt.zq) == 0)
        .expect("trace-zero internal point");

    let pair_cond = |a: &Pt, b: &Pt| -> bool {
        // Res(f_a, f_b) = f_b(z_a) f_b(z_a^q)
        let e1 = f.mul(f.sub(a.z, b.z), f.sub(a.z, b.zq));
        let e2 = f.mul(f.sub(a.zq, b.z), f.sub(a.zq, b.zq));
        f.chi_q(f.mul(e1, e2)) == -1
    };

    // vertices: neighbors of p0
    let verts: Vec<usize> = (0..n_internal)
        .filter(|&i| i != p0 && pair_cond(&pts[p0], &pts[i]))
        .collect();
    let nv = verts.len();
    let nw = nv.div_ceil(64);
    let mut adj: Vec<Vec<u64>> = vec![vec![0u64; nw]; nv];
    for i in 0..nv {
        for j in (i + 1)..nv {
            if pair_cond(&pts[verts[i]], &pts[verts[j]]) {
                adj[i][j / 64] |= 1 << (j % 64);
                adj[j][i / 64] |= 1 << (i % 64);
            }
        }
    }

    // subfield and plane points for the covering test
    let sub_elems: Vec<usize> = (0..f.q2).filter(|&e| f.frob(e) == e).collect();
    assert_eq!(sub_elems.len(), q);
    let mut plane: Vec<([usize; 3], bool)> = Vec::new(); // (row, on_conic)
    {
        let four = {
            let two = f.add(one, one);
            f.mul(two, two)
        };
        let mut push = |a: usize, b: usize, c: usize, plane: &mut Vec<([usize; 3], bool)>| {
            let disc = f.sub(f.mul(b, b), f.mul(four, f.mul(a, c)));
            plane.push(([a, b, c], disc == 0));
        };
        for &b in &sub_elems {
            for &c in &sub_elems {
                push(one, b, c, &mut plane);
            }
        }
        for &c in &sub_elems {
            push(0, one, c, &mut plane);
        }
        push(0, 0, one, &mut plane);
    }
    let n_off_conic = plane.iter().filter(|e| !e.1).count();
    assert_eq!(n_off_conic, q * q);

    let mut counts = Counts {
        candidates: 0,
        candidates_line: 0,
        angle_biject: 0,
        coherent: 0,
        arcs: 0,
        arcs_coherent: 0,
        covering: 0,
        witness: None,
    };

    {
        let mut process = |chosen: &[usize]| -> bool {
            let set: Vec<&Pt> = std::iter::once(&pts[p0])
                .chain(chosen.iter().map(|&i| &pts[verts[i]]))
                .collect();
            counts.candidates += 1;
            // line-plus-apex type: the k-1 non-fixed points are all collinear
            {
                let mut line_type = true;
                for i in 3..set.len() {
                    if det3(&f, &set[1].row, &set[2].row, &set[i].row) != 0 {
                        line_type = false;
                        break;
                    }
                }
                if line_type {
                    counts.candidates_line += 1;
                }
            }
            // angle bijectivity: no collinear triple through the fixed point
            let mut angle_ok = true;
            'a: for i in 1..set.len() {
                for j in (i + 1)..set.len() {
                    if det3(&f, &set[0].row, &set[i].row, &set[j].row) == 0 {
                        angle_ok = false;
                        break 'a;
                    }
                }
            }
            if angle_ok {
                counts.angle_biject += 1;
            }
            // coherence: sigma * s_ij must be a coboundary
            let s = |a: &Pt, b: &Pt| -> i32 { f.chi(f.sub(a.z, b.zq)) };
            let e: Vec<i32> = (1..set.len()).map(|i| sigma * s(set[0], set[i])).collect();
            let mut coherent = true;
            'c: for i in 1..set.len() {
                for j in (i + 1)..set.len() {
                    if sigma * s(set[i], set[j]) != e[i - 1] * e[j - 1] {
                        coherent = false;
                        break 'c;
                    }
                }
            }
            if coherent {
                counts.coherent += 1;
            }
            // arc: general position
            let mut arc = angle_ok;
            if arc {
                'g: for i in 1..set.len() {
                    for j in (i + 1)..set.len() {
                        for l in (j + 1)..set.len() {
                            if det3(&f, &set[i].row, &set[j].row, &set[l].row) == 0 {
                                arc = false;
                                break 'g;
                            }
                        }
                    }
                }
            }
            if arc {
                counts.arcs += 1;
                if coherent {
                    counts.arcs_coherent += 1;
                }
                // covering
                let mut covering = true;
                'p: for (row, on_conic) in &plane {
                    if *on_conic {
                        continue;
                    }
                    let mut covered = false;
                    'q: for i in 0..set.len() {
                        for j in (i + 1)..set.len() {
                            if det3(&f, row, &set[i].row, &set[j].row) == 0 {
                                covered = true;
                                break 'q;
                            }
                        }
                    }
                    if !covered {
                        covering = false;
                        break 'p;
                    }
                }
                if covering {
                    counts.covering += 1;
                    if counts.witness.is_none() {
                        let w: Vec<String> = set
                            .iter()
                            .map(|pt| format!("[{},{}]", f.add(pt.z, pt.zq), f.mul(pt.z, pt.zq)))
                            .collect();
                        counts.witness = Some(format!("[{}]", w.join(",")));
                    }
                }
            }
            false
        };
        let full: Vec<u64> = {
            let mut v = vec![0u64; nw];
            for i in 0..nv {
                v[i / 64] |= 1 << (i % 64);
            }
            v
        };
        let mut chosen = Vec::new();
        dfs(&adj, &mut chosen, &full, k - 1, &mut process);
    }

    // largest pairwise-passant internal set through the fixed point:
    // 1 + max clique size among the vertices, probed by descending target size.
    // Every external line carries (q+1)/2 collinear internal points that are pairwise
    // joined by that same passant, so the true maximum is at least (q+1)/2.
    let mut max_thru_p0 = 1usize;
    {
        let full: Vec<u64> = {
            let mut v = vec![0u64; nw];
            for i in 0..nv {
                v[i / 64] |= 1 << (i % 64);
            }
            v
        };
        let mut target = k + 2; // probe cap; report caps at k+2
        while target >= 1 {
            let mut found = false;
            let mut probe = |_c: &[usize]| -> bool {
                found = true;
                true
            };
            let mut chosen = Vec::new();
            dfs(&adj, &mut chosen, &full, target, &mut probe);
            if found {
                max_thru_p0 = 1 + target;
                break;
            }
            target -= 1;
        }
    }

    format!(
        "{{\"q\":{},\"p\":{},\"k\":{},\"t\":{},\"sigma\":{},\"modulus\":{},\"n_internal\":{},\"n_vertices\":{},\"max_passant_set_thru_p0\":{},\"candidates\":{},\"candidates_line\":{},\"angle_biject\":{},\"coherent\":{},\"arcs\":{},\"arcs_coherent\":{},\"covering\":{},\"witness_tr_nm\":{}}}",
        q,
        f.p,
        k,
        t,
        sigma,
        f.modulus,
        n_internal,
        nv,
        max_thru_p0,
        counts.candidates,
        counts.candidates_line,
        counts.angle_biject,
        counts.coherent,
        counts.arcs,
        counts.arcs_coherent,
        counts.covering,
        counts.witness.map_or("null".to_string(), |w| format!("\"{}\"", w)),
    )
}

fn main() {
    let args: Vec<usize> = env::args()
        .skip(1)
        .map(|a| a.parse().expect("q must be an integer"))
        .collect();
    let qs: Vec<usize> = if args.is_empty() {
        vec![5, 7, 9, 11, 13, 17, 19, 23, 25, 27, 29, 31, 37, 41, 43]
    } else {
        args
    };
    let rows: Vec<String> = qs.iter().map(|&q| format!(" {}", audit(q))).collect();
    println!(
        "{{\"task\":\"C756\",\"family\":\"saturated-internal\",\"normalization\":\"fixed first trace-zero internal point; counts are normalized solutions, not projective orbits\",\"rows\":[\n{}\n]}}",
        rows.join(",\n")
    );
}
