// C756 — independent replay of the conic-filling classification.
//
// This program shares no machinery with the main searcher: it never builds the
// conic-external graph, never uses the quadratic-character criterion, and never uses
// the covering LP.  It enumerates *every* arc of PG(2,q) directly, in increasing
// point order, keeps the exact uncovered set U(A) (points on no chord), and reports
// every arc whose U(A) is the point set of a nonsingular conic.
//
// Pruning is exact and loss-free: U(A) only shrinks when a point is added, and a
// nonsingular conic has q+1 points, so any branch with |U| < q+1 is dead.
// A point of U(A) is exactly a point addable to the arc, so the candidate set is U
// itself; hence the enumeration is over all arcs with |U(A)| >= q+1, which contains
// every conic-filling arc of every size k.
//
// Build/run:
//   rustc -O -o /tmp/c756r notes/2026-08-01-c756-all-k-conic-filling-replay.rs
//   /tmp/c756r 11
//
// Output: one canonical JSON object.

use std::env;

const W: usize = 12; // 768 bits: enough for PG(2,q), q <= 27

#[derive(Clone, Copy)]
struct Bs([u64; W]);

impl Bs {
    fn new() -> Bs {
        Bs([0; W])
    }
    #[inline]
    fn set(&mut self, i: usize) {
        self.0[i / 64] |= 1u64 << (i % 64);
    }
    #[inline]
    fn get(&self, i: usize) -> bool {
        self.0[i / 64] >> (i % 64) & 1 == 1
    }
    #[inline]
    fn or(&self, o: &Bs) -> Bs {
        let mut r = Bs::new();
        for i in 0..W {
            r.0[i] = self.0[i] | o.0[i];
        }
        r
    }
    #[inline]
    fn andnot(&self, o: &Bs) -> Bs {
        let mut r = Bs::new();
        for i in 0..W {
            r.0[i] = self.0[i] & !o.0[i];
        }
        r
    }
    #[inline]
    fn count(&self) -> usize {
        self.0.iter().map(|w| w.count_ones() as usize).sum()
    }
}

struct P2 {
    q: usize,
    p: usize,
    n: usize,
    mul: Vec<u16>,
    add: Vec<u16>,
    inv: Vec<u16>,
    pts: Vec<[usize; 3]>,
    idx: Vec<i32>,
    line: Vec<Bs>, // line[i*np + j] = point set of the line through i != j
    np: usize,
}

fn build_field(q: usize) -> (usize, usize, Vec<u16>, Vec<u16>, Vec<u16>) {
    let mut p = 0;
    let mut n = 0;
    for c in 2..=q {
        if q % c == 0 {
            let mut t = q;
            let mut e = 0;
            while t % c == 0 {
                t /= c;
                e += 1;
            }
            assert_eq!(t, 1, "q must be a prime power");
            p = c;
            n = e;
            break;
        }
    }
    // irreducible polynomial x^n + sum c_i x^i, found by brute force on roots and
    // (for n = 2, 3) that suffices; n <= 3 covers every q used by the replay.
    assert!(n <= 3, "replay supports q = p, p^2, p^3");
    let mut modpoly = vec![0usize; n];
    if n > 1 {
        'outer: for code in 0..p.pow(n as u32) {
            let mut cs = vec![0usize; n];
            let mut c = code;
            for i in 0..n {
                cs[i] = c % p;
                c /= p;
            }
            for x in 0..p {
                let mut v = 1usize;
                for i in (0..n).rev() {
                    v = (v * x + cs[i]) % p;
                }
                if v == 0 {
                    continue 'outer;
                }
            }
            modpoly = cs;
            break;
        }
    }
    let mut mul = vec![0u16; q * q];
    let mut add = vec![0u16; q * q];
    for a in 0..q {
        for b in 0..q {
            if n == 1 {
                mul[a * q + b] = ((a * b) % p) as u16;
                add[a * q + b] = ((a + b) % p) as u16;
            } else {
                let (mut av, mut bv) = (vec![0usize; n], vec![0usize; n]);
                let (mut x, mut y) = (a, b);
                for i in 0..n {
                    av[i] = x % p;
                    x /= p;
                    bv[i] = y % p;
                    y /= p;
                }
                let mut c = vec![0usize; 2 * n];
                for i in 0..n {
                    for j in 0..n {
                        c[i + j] = (c[i + j] + av[i] * bv[j]) % p;
                    }
                }
                for d in (n..2 * n).rev() {
                    let co = c[d];
                    if co == 0 {
                        continue;
                    }
                    c[d] = 0;
                    for i in 0..n {
                        c[d - n + i] = (c[d - n + i] + (p - modpoly[i] % p) % p * co) % p;
                    }
                }
                let mut r = 0usize;
                for i in (0..n).rev() {
                    r = r * p + c[i];
                }
                mul[a * q + b] = r as u16;
                let (mut xx, mut yy, mut rr, mut w) = (a, b, 0usize, 1usize);
                for _ in 0..n {
                    rr += ((xx % p + yy % p) % p) * w;
                    xx /= p;
                    yy /= p;
                    w *= p;
                }
                add[a * q + b] = rr as u16;
            }
        }
    }
    let mut inv = vec![0u16; q];
    for a in 1..q {
        for b in 1..q {
            if mul[a * q + b] == 1 {
                inv[a] = b as u16;
                break;
            }
        }
    }
    (p, n, mul, add, inv)
}

impl P2 {
    fn new(q: usize) -> P2 {
        let (p, n, mul, add, inv) = build_field(q);
        let mut pts = vec![];
        for y in 0..q {
            for x in 0..q {
                pts.push([x, y, 1]);
            }
        }
        for x in 0..q {
            pts.push([x, 1, 0]);
        }
        pts.push([1, 0, 0]);
        let np = pts.len();
        assert!(np <= W * 64);
        let mut idx = vec![-1i32; q * q * q];
        for (i, r) in pts.iter().enumerate() {
            idx[r[0] + q * r[1] + q * q * r[2]] = i as i32;
        }
        let mut me = P2 { q, p, n, mul, add, inv, pts, idx, line: vec![], np };
        let mut line = vec![Bs::new(); np * np];
        for i in 0..np {
            for j in 0..np {
                if i == j {
                    continue;
                }
                let mut b = Bs::new();
                let a = me.pts[i];
                let c = me.pts[j];
                for t in 0..q {
                    let v = [
                        me.a(a[0], me.m(t, c[0])),
                        me.a(a[1], me.m(t, c[1])),
                        me.a(a[2], me.m(t, c[2])),
                    ];
                    b.set(me.norm(v));
                }
                b.set(j);
                line[i * np + j] = b;
            }
        }
        me.line = line;
        me
    }
    #[inline]
    fn m(&self, a: usize, b: usize) -> usize {
        self.mul[a * self.q + b] as usize
    }
    #[inline]
    fn a(&self, x: usize, y: usize) -> usize {
        self.add[x * self.q + y] as usize
    }
    fn norm(&self, v: [usize; 3]) -> usize {
        for k in (0..3).rev() {
            if v[k] != 0 {
                let iv = self.inv[v[k]] as usize;
                let r = [self.m(v[0], iv), self.m(v[1], iv), self.m(v[2], iv)];
                return self.idx[r[0] + self.q * r[1] + self.q * self.q * r[2]] as usize;
            }
        }
        panic!()
    }
    /// Is the point set S (given as a bitset with exactly q+1 points) the zero set of
    /// a nonsingular conic?  Solve the 6-variable linear system over F_q by Gaussian
    /// elimination; require a 1-dimensional solution space, a nonsingular Gram matrix
    /// and zero set exactly S.
    fn is_conic(&self, s: &Bs) -> bool {
        let q = self.q;
        let mut rows: Vec<[usize; 6]> = vec![];
        for i in 0..self.np {
            if !s.get(i) {
                continue;
            }
            let [x, y, z] = self.pts[i];
            rows.push([
                self.m(x, x),
                self.m(y, y),
                self.m(z, z),
                self.m(x, y),
                self.m(x, z),
                self.m(y, z),
            ]);
        }
        // Gaussian elimination
        let mut r = 0usize;
        let mut pivots: Vec<usize> = vec![];
        for c in 0..6 {
            let mut piv = None;
            for i in r..rows.len() {
                if rows[i][c] != 0 {
                    piv = Some(i);
                    break;
                }
            }
            let piv = match piv {
                None => continue,
                Some(i) => i,
            };
            rows.swap(r, piv);
            let iv = self.inv[rows[r][c]] as usize;
            for cc in 0..6 {
                rows[r][cc] = self.m(rows[r][cc], iv);
            }
            for i in 0..rows.len() {
                if i != r && rows[i][c] != 0 {
                    let f = rows[i][c];
                    for cc in 0..6 {
                        let t = self.m(f, rows[r][cc]);
                        rows[i][cc] = self.a(rows[i][cc], self.negf(t));
                    }
                }
            }
            pivots.push(c);
            r += 1;
            if r == rows.len() {
                break;
            }
        }
        if r != 5 {
            return false; // solution space must be 1-dimensional
        }
        // back-substitute: free variable is the unique non-pivot column
        let free = (0..6).find(|c| !pivots.contains(c)).unwrap();
        let mut sol = [0usize; 6];
        sol[free] = 1;
        for (ri, &pc) in pivots.iter().enumerate() {
            sol[pc] = self.negf(rows[ri][free]);
        }
        // Gram matrix of a X^2 + b Y^2 + c Z^2 + d XY + e XZ + f YZ  (q odd)
        let half = self.inv[self.a(1, 1)] as usize;
        let g = [
            [sol[0], self.m(sol[3], half), self.m(sol[4], half)],
            [self.m(sol[3], half), sol[1], self.m(sol[5], half)],
            [self.m(sol[4], half), self.m(sol[5], half), sol[2]],
        ];
        let det = self.det3(&g);
        if det == 0 {
            return false;
        }
        // zero set must be exactly S
        for i in 0..self.np {
            let [x, y, z] = self.pts[i];
            let v = self.a(
                self.a(self.m(sol[0], self.m(x, x)), self.m(sol[1], self.m(y, y))),
                self.a(
                    self.m(sol[2], self.m(z, z)),
                    self.a(
                        self.m(sol[3], self.m(x, y)),
                        self.a(self.m(sol[4], self.m(x, z)), self.m(sol[5], self.m(y, z))),
                    ),
                ),
            );
            if (v == 0) != s.get(i) {
                return false;
            }
        }
        let _ = q;
        true
    }
    fn negf(&self, x: usize) -> usize {
        let (mut t, mut r, mut w) = (x, 0usize, 1usize);
        for _ in 0..self.n {
            r += ((self.p - t % self.p) % self.p) * w;
            t /= self.p;
            w *= self.p;
        }
        r
    }
    fn det3(&self, g: &[[usize; 3]; 3]) -> usize {
        let t1 = self.m(g[0][0], self.sub(self.m(g[1][1], g[2][2]), self.m(g[1][2], g[2][1])));
        let t2 = self.m(g[0][1], self.sub(self.m(g[1][0], g[2][2]), self.m(g[1][2], g[2][0])));
        let t3 = self.m(g[0][2], self.sub(self.m(g[1][0], g[2][1]), self.m(g[1][1], g[2][0])));
        self.a(self.sub(t1, t2), t3)
    }
    fn sub(&self, x: usize, y: usize) -> usize {
        self.a(x, self.negf(y))
    }
}

struct R<'a> {
    g: &'a P2,
    hits: Vec<Vec<usize>>,
    nodes: u64,
}

impl<'a> R<'a> {
    fn dfs(&mut self, arc: &mut Vec<usize>, covered: Bs, cand_start: usize) {
        self.nodes += 1;
        let np = self.g.np;
        let mut u = Bs::new();
        for i in 0..np {
            if !covered.get(i) {
                u.set(i);
            }
        }
        // arc points are covered once |arc| >= 2; for |arc| < 2 they are not, but such
        // arcs cannot be conic-filling (no chords at all / |U| too large), and they are
        // still expanded below.
        if arc.len() >= 3 && u.count() == self.g.q + 1 && self.g.is_conic(&u) {
            self.hits.push(arc.clone());
        }
        if u.count() < self.g.q + 1 {
            return;
        }
        for v in cand_start..np {
            if covered.get(v) {
                continue;
            }
            let mut nc = covered;
            for &w in arc.iter() {
                nc = nc.or(&self.g.line[w * np + v]);
            }
            arc.push(v);
            self.dfs(arc, nc, v + 1);
            arc.pop();
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let q: usize = args[1].parse().unwrap();
    // Optional second argument "frame": enumerate only the arcs containing the standard
    // frame.  PGL(3,q) is transitive on 4-subsets in general position and carries conics
    // to conics, so every conic-filling arc with k >= 4 has an equivalent one containing
    // it.  k = 3 needs no search: a triangle has |U| = (q-1)^2, which equals q+1 only for
    // q = 3, and the full q = 3 enumeration below reports no hit.
    let frame_only = args.len() > 2 && args[2] == "frame";
    let g = P2::new(q);
    let mut r = R { g: &g, hits: vec![], nodes: 0 };
    let mut arc: Vec<usize> = vec![];
    if frame_only {
        let e1 = g.norm([1, 0, 0]);
        let e2 = g.norm([0, 1, 0]);
        let e3 = g.norm([0, 0, 1]);
        let e4 = g.norm([1, 1, 1]);
        arc = vec![e1, e2, e3, e4];
        let np = g.np;
        let mut cov = Bs::new();
        for i in 0..4 {
            for j in (i + 1)..4 {
                cov = cov.or(&g.line[arc[i] * np + arc[j]]);
            }
        }
        r.dfs(&mut arc, cov, 0);
    } else {
        r.dfs(&mut arc, Bs::new(), 0);
    }
    let hs: Vec<String> = r
        .hits
        .iter()
        .map(|a| {
            let v: Vec<String> = a
                .iter()
                .map(|&i| {
                    let p = g.pts[i];
                    format!("[{},{},{}]", p[0], p[1], p[2])
                })
                .collect();
            format!("{{\"k\":{},\"points\":[{}]}}", a.len(), v.join(","))
        })
        .collect();
    println!(
        "{{\"q\":{},\"replay\":true,\"conic_filling\":[{}],\"count\":{},\"nodes\":{}}}",
        q,
        hs.join(","),
        r.hits.len(),
        r.nodes
    );
}
