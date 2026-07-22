// Klein cubic threefold x0^2 x1 + x1^2 x2 + x2^2 x3 + x3^2 x4 + x4^2 x0 = 0 over F_{11^k}.
// Computes T(q) = sum over affine curve C: x2*x3^4 - 4*x2^3*x3 + 1 = 0 (x2 != 0) of chi(-4*x2),
// where chi is the quadratic character of F_q. Then tr(F^k | H^3) = -q*(1 + T(q)), q = 11^k.
// Derivation (verified in Python at k=1,2 against brute-force / known counts):
//   N(q) = q^3 + q^2 + 2q + 1 + S(q),  S(q) = q*T(q),
//   S(q) = sum_{x1,x2,x3} chi(x3^4 - 4(x1 + x1^2 x2 + x2^2 x3))   [x0 = 1 slice]
// Also provides a direct triple-loop computation of S(q) (independent of the x1-collapse)
// for k <= 3 as a cross-check.

const P: usize = 11;

struct Fq {
    k: usize,
    q: usize,
    m: usize,           // q - 1
    half: usize,        // log(-1) = m/2
    exp: Vec<u32>,      // exp[i] = element-index of g^i, g = t (primitive)
    log: Vec<u32>,      // log[element-index], log[0] unused
    zech: Vec<u32>,     // zech[d] = log(1 + g^d); u32::MAX when 1 + g^d = 0 (d == half)
}

fn add_idx(a: usize, b: usize, k: usize) -> usize {
    // digitwise add mod 11 of base-11 representations
    let (mut a, mut b) = (a, b);
    let mut out = 0usize;
    let mut mult = 1usize;
    for _ in 0..k {
        let d = (a % P + b % P) % P;
        out += d * mult;
        mult *= P;
        a /= P;
        b /= P;
    }
    out
}

fn mul_by_t(x: usize, k: usize, red: usize) -> usize {
    // multiply polynomial (element-index x) by t, reduce using t^k = red (element-index)
    let qk1 = P.pow((k - 1) as u32);
    let top = x / qk1;         // coefficient of t^(k-1)
    let low = x % qk1;         // remaining
    let shifted = low * P;     // multiply by t
    if top == 0 {
        shifted
    } else {
        // add top * red, digitwise
        let mut r = red;
        let mut mult = 1usize;
        let mut a2 = 0usize;
        for _ in 0..k {
            let d = (r % P) * top % P;
            a2 += d * mult;
            mult *= P;
            r /= P;
        }
        add_idx(shifted, a2, k)
    }
}

fn build_field(k: usize) -> Fq {
    let q = P.pow(k as u32);
    let m = q - 1;
    // Search for reduction constant red: t^k = red(t), such that the resulting ring is a field
    // with t primitive: build exp table by repeated mul_by_t; accept iff period of t is exactly m
    // and all m powers are distinct and nonzero.
    let mut exp = vec![0u32; m];
    let mut log = vec![0u32; q];
    'outer: for red in 1..q {
        let mut x = 1usize;
        for i in 0..m {
            exp[i] = x as u32;
            x = mul_by_t(x, k, red);
            if (x == 1 && i + 1 < m) || x == 0 {
                continue 'outer;
            }
        }
        if x != 1 {
            continue 'outer;
        }
        for v in log.iter_mut() {
            *v = u32::MAX;
        }
        let mut ok = true;
        for i in 0..m {
            let e = exp[i] as usize;
            if e == 0 || log[e] != u32::MAX {
                ok = false;
                break;
            }
            log[e] = i as u32;
        }
        if ok {
            eprintln!("k={} using reduction t^{} = elem#{}", k, k, red);
            let mut zech = vec![u32::MAX; m];
            for d in 0..m {
                let s = add_idx(exp[d] as usize, 1, k);
                if s != 0 {
                    zech[d] = log[s];
                }
            }
            return Fq { k, q, m, half: m / 2, exp, log, zech };
        }
    }
    panic!("no primitive reduction found for k={}", k);
}

impl Fq {
    fn neg4_log(&self) -> usize {
        // element-index of -4 = 7 (constant polynomial)
        self.log[7] as usize
    }

    // T(q) = sum over curve of chi(-4 x2), curve x2*x3^4 - 4 x2^3 x3 + 1 = 0, x2,x3 in F_q^*
    // (x3=0 gives no curve points since then LHS = 1).
    // log-domain: A = x2 x3^4 -> la = i + 4j; B = -4 x2^3 x3 -> lb = ln4 + 3i + j (mod m).
    // A+B = 0 iff (lb-la) mod m == half -> then A+B+1 = 1 != 0, skip. Else A+B = g^(la + zech[lb-la]).
    // On curve iff A+B = -1 iff that log == half. chi(-4 x2) = (-1)^(ln4 + i).
    fn curve_sum(&self, threads: usize) -> i64 {
        let m = self.m;
        let half = self.half;
        let ln4 = self.neg4_log();
        let zech = &self.zech;
        let chunk = (m + threads - 1) / threads;
        std::thread::scope(|s| {
            let mut handles = Vec::new();
            for t in 0..threads {
                let lo = t * chunk;
                let hi = ((t + 1) * chunk).min(m);
                let zech = &zech[..];
                handles.push(s.spawn(move || {
                    let mut acc = 0i64;
                    for i in lo..hi {
                        let chi_i: i64 = if (ln4 + i) % 2 == 0 { 1 } else { -1 };
                        // j = 0: la = i, lb = (ln4 + 3i) mod m, d = (lb - la) mod m
                        let mut la = i % m;
                        let mut d = (ln4 + 2 * i) % m;
                        for _ in 0..m {
                            if d != half {
                                let z = zech[d] as usize;
                                let mut ls = la + z;
                                if ls >= m {
                                    ls -= m;
                                }
                                if ls == half {
                                    acc += chi_i;
                                }
                            }
                            // j += 1: la += 4, lb += 1 => d -= 3
                            la += 4;
                            if la >= m {
                                la -= m;
                            }
                            d = if d >= 3 { d - 3 } else { d + m - 3 };
                        }
                    }
                    acc
                }));
            }
            handles.into_iter().map(|h| h.join().unwrap()).sum()
        })
    }

    // Direct S(q) = sum_{x1,x2,x3 in F_q} chi(x3^4 - 4(x1 + x1^2 x2 + x2^2 x3)),
    // independent of the x1-collapse. Uses full add/mul tables; only for k <= 3.
    fn s_direct(&self, threads: usize) -> i64 {
        let q = self.q;
        let k = self.k;
        let mut mul = vec![0u16; q * q];
        let mut addt = vec![0u16; q * q];
        for a in 0..q {
            for b in 0..q {
                addt[a * q + b] = add_idx(a, b, k) as u16;
                if a != 0 && b != 0 {
                    let l = (self.log[a] as usize + self.log[b] as usize) % self.m;
                    mul[a * q + b] = self.exp[l] as u16;
                }
            }
        }
        let mut chi = vec![0i8; q];
        for a in 1..q {
            chi[a] = if self.log[a] % 2 == 0 { 1 } else { -1 };
        }
        let neg4 = 7usize; // element-index of -4
        let chunk = (q + threads - 1) / threads;
        std::thread::scope(|s| {
            let mut handles = Vec::new();
            for t in 0..threads {
                let lo = t * chunk;
                let hi = ((t + 1) * chunk).min(q);
                let (mul, addt, chi) = (&mul[..], &addt[..], &chi[..]);
                handles.push(s.spawn(move || {
                    let mut acc = 0i64;
                    for x1 in lo..hi {
                        let x1s = mul[x1 * q + x1] as usize;
                        for x2 in 0..q {
                            let x2s = mul[x2 * q + x2] as usize;
                            let t1 = addt[x1 * q + mul[x1s * q + x2] as usize] as usize;
                            for x3 in 0..q {
                                let a = addt[t1 * q + mul[x2s * q + x3] as usize] as usize;
                                let x3s = mul[x3 * q + x3] as usize;
                                let x34 = mul[x3s * q + x3s] as usize;
                                let d = addt[x34 * q + mul[neg4 * q + a] as usize] as usize;
                                acc += chi[d] as i64;
                            }
                        }
                    }
                    acc
                }));
            }
            handles.into_iter().map(|h| h.join().unwrap()).sum()
        })
    }
}

impl Fq {
    fn mul(&self, a: usize, b: usize) -> usize {
        if a == 0 || b == 0 {
            return 0;
        }
        let l = (self.log[a] as usize + self.log[b] as usize) % self.m;
        self.exp[l] as usize
    }
    fn inv(&self, a: usize) -> usize {
        let l = (self.m - self.log[a] as usize) % self.m;
        self.exp[l] as usize
    }
    fn neg(&self, a: usize) -> usize {
        if a == 0 {
            0
        } else {
            self.exp[(self.log[a] as usize + self.half) % self.m] as usize
        }
    }
    fn sqrts(&self, a: usize) -> Vec<usize> {
        if a == 0 {
            return vec![0];
        }
        let l = self.log[a] as usize;
        if l % 2 != 0 {
            return vec![];
        }
        let r = self.exp[l / 2] as usize;
        vec![r, self.neg(r)]
    }
    fn add(&self, a: usize, b: usize) -> usize {
        add_idx(a, b, self.k)
    }

    // Count projective singular points of X over F_q.
    // Singular cone points satisfy grad f = 0; shown (see note) that all nonzero ones lie in
    // the open torus. Enumerate (x3, x4) in (F_q^*)^2:
    //   d3: x2^2 = -2 x3 x4          (0 or 2 roots)
    //   d4: x0 = -x3^2 / (2 x4)
    //   d2: x1^2 = -2 x2 x3          (0 or 2 roots)
    //   check d0: 2 x0 x1 + x4^2 = 0 and d1: x0^2 + 2 x1 x2 = 0
    // Then divide affine count by (q-1).
    fn sing_count(&self) -> (u64, u64) {
        let two_inv = self.inv(2);
        let mut affine = 0u64;
        for lx3 in 0..self.m {
            let x3 = self.exp[lx3] as usize;
            let x3sq = self.mul(x3, x3);
            for lx4 in 0..self.m {
                let x4 = self.exp[lx4] as usize;
                // x0 = -x3^2/(2x4)
                let x0 = self.neg(self.mul(self.mul(x3sq, two_inv), self.inv(x4)));
                let rhs2 = self.neg(self.mul(2 % self.q, self.mul(x3, x4)));
                for &x2 in self.sqrts(rhs2).iter() {
                    if x2 == 0 {
                        continue;
                    }
                    let rhs1 = self.neg(self.mul(2 % self.q, self.mul(x2, x3)));
                    for &x1 in self.sqrts(rhs1).iter() {
                        if x1 == 0 {
                            continue;
                        }
                        // d0: 2 x0 x1 + x4^2
                        let d0 = self.add(self.mul(2 % self.q, self.mul(x0, x1)), self.mul(x4, x4));
                        if d0 != 0 {
                            continue;
                        }
                        let d1 = self.add(self.mul(x0, x0), self.mul(2 % self.q, self.mul(x1, x2)));
                        if d1 == 0 {
                            affine += 1;
                        }
                    }
                }
            }
        }
        (affine, affine / self.m as u64)
    }

    // Count V = #{v in P^4(F_q) : B(v) = 0 and f(v) = 0}, where B is the Hessian quadric at
    // P = (1,3,9,5,4); lines through P inside X: #C = (V-1)/q. Brute force over P^4.
    fn cone_lines(&self) -> (u64, u64) {
        let q = self.q;
        // Hessian matrix mod 11 embedded in F_q (constants)
        let h: [[usize; 5]; 5] = [
            [6, 2, 0, 0, 8],
            [2, 7, 6, 0, 0],
            [0, 6, 10, 7, 0],
            [0, 0, 7, 8, 10],
            [8, 0, 0, 10, 2],
        ];
        let mut v_count = 0u64;
        let mut x = [0usize; 5];
        // iterate projective points: leading coordinate 1
        for lead in 0..5 {
            let rest = 5 - lead - 1;
            let total = (q as u64).pow(rest as u32);
            for mut idx in 0..total {
                for i in 0..5 {
                    x[i] = 0;
                }
                x[lead] = 1;
                for i in (lead + 1)..5 {
                    x[i] = (idx % q as u64) as usize;
                    idx /= q as u64;
                }
                // B(v) = sum h_ij v_i v_j (this is v^T H v = 2*B; zero iff B zero)
                let mut b = 0usize;
                for i in 0..5 {
                    for j in 0..5 {
                        b = self.add(b, self.mul(h[i][j] % q, self.mul(x[i], x[j])));
                    }
                }
                if b != 0 {
                    continue;
                }
                // f(v)
                let mut fv = 0usize;
                for i in 0..5 {
                    let m1 = self.mul(self.mul(x[i], x[i]), x[(i + 1) % 5]);
                    fv = self.add(fv, m1);
                }
                if fv == 0 {
                    v_count += 1;
                }
            }
        }
        (v_count, (v_count - 1) / q as u64)
    }
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let k: usize = args[1].parse().unwrap();
    let mode = args.get(2).map(|s| s.as_str()).unwrap_or("curve");
    let threads: usize = std::thread::available_parallelism().map(|n| n.get()).unwrap_or(8);
    let f = build_field(k);
    let q = f.q as i64;
    match mode {
        "curve" => {
            let t = f.curve_sum(threads);
            let s = q * t;
            let n = q * q * q + q * q + 2 * q + 1 + s;
            let tr = -q * (1 + t);
            println!("k={} q={} T={} S={} N={} tr(F^k|H^3)={}", k, q, t, s, n, tr);
        }
        "direct" => {
            let s = f.s_direct(threads);
            let n = q * q * q + q * q + 2 * q + 1 + s;
            let tr = (1 + q + q * q + q * q * q) - n;
            println!("k={} q={} S_direct={} N={} tr={}", k, q, s, n, tr);
        }
        "sing" => {
            let (aff, proj) = f.sing_count();
            println!("k={} q={} singular affine cone pts={} projective={}", k, q, aff, proj);
        }
        "lines" => {
            let (v, c) = f.cone_lines();
            println!("k={} q={} V(B=0,f=0)={} #C(lines through P)={}", k, q, v, c);
        }
        _ => panic!("mode curve|direct|sing|lines"),
    }
}
// appended: singular-locus counting over F_{11^k}
