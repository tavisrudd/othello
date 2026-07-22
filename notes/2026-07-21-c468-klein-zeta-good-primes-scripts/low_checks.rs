// Independent C468 checks at k=1,2 for p=31,41,61.
// k=1 uses full projective point enumeration.  k=2 uses the curve
// reduction and a direct O(q^2) scan, distinct from trace31k5.rs's O(q)
// determinant-11 solver and from the Delsarte calculation.

struct Fq {
    p: usize,
    k: usize,
    q: usize,
    m: usize,
    exp: Vec<usize>,
    log: Vec<usize>,
}

impl Fq {
    fn raw_mul(p: usize, k: usize, c: usize, x: usize, y: usize) -> usize {
        if k == 1 {
            return x * y % p;
        }
        let (a, b) = (x % p, x / p);
        let (d, e) = (y % p, y / p);
        // t^2+t+c=0.
        let lo = (a * d + p - c * b % p * e % p) % p;
        let hi = (a * e + b * d + p - b * e % p) % p;
        lo + p * hi
    }

    fn raw_pow(p: usize, k: usize, c: usize, mut x: usize, mut n: usize) -> usize {
        let mut r = 1;
        while n != 0 {
            if n & 1 != 0 {
                r = Self::raw_mul(p, k, c, r, x);
            }
            x = Self::raw_mul(p, k, c, x, x);
            n >>= 1;
        }
        r
    }

    fn new(p: usize, k: usize) -> Self {
        let c = match (p, k) {
            (_, 1) => 0,
            (31, 2) | (61, 2) => 2,
            (41, 2) => 1,
            _ => panic!("unsupported field"),
        };
        let q = p.pow(k as u32);
        let m = q - 1;
        let mut factors = Vec::new();
        let mut n = m;
        let mut r = 2;
        while r * r <= n {
            if n % r == 0 {
                factors.push(r);
                while n % r == 0 {
                    n /= r;
                }
            }
            r += 1;
        }
        if n > 1 {
            factors.push(n);
        }
        let primitive = (2..q)
            .find(|&g| {
                factors
                    .iter()
                    .all(|&r| Self::raw_pow(p, k, c, g, m / r) != 1)
            })
            .unwrap();
        let mut exp = vec![0; m];
        let mut log = vec![usize::MAX; q];
        let mut x = 1;
        for i in 0..m {
            exp[i] = x;
            log[x] = i;
            x = Self::raw_mul(p, k, c, x, primitive);
        }
        assert_eq!(x, 1);
        Self {
            p,
            k,
            q,
            m,
            exp,
            log,
        }
    }

    fn add(&self, x: usize, y: usize) -> usize {
        if self.k == 1 {
            return (x + y) % self.p;
        }
        (x % self.p + y % self.p) % self.p + self.p * ((x / self.p + y / self.p) % self.p)
    }

    fn curve_sum_direct(&self) -> i64 {
        let half = self.m / 2;
        let minus4 = self.p - 4;
        let ln4 = self.log[minus4];
        let mut zech = vec![usize::MAX; self.m];
        for d in 0..self.m {
            let s = self.add(1, self.exp[d]);
            if s != 0 {
                zech[d] = self.log[s];
            }
        }
        let mut total = 0i64;
        for i in 0..self.m {
            let sign = if (ln4 + i) % 2 == 0 { 1 } else { -1 };
            let mut la = i;
            let mut d = (ln4 + 2 * i) % self.m;
            for _ in 0..self.m {
                if d != half && (la + zech[d]) % self.m == half {
                    total += sign;
                }
                la = (la + 4) % self.m;
                d = (d + self.m - 3) % self.m;
            }
        }
        total
    }
}

fn base_prime_checks(p: usize) -> (u64, u64, [u64; 32]) {
    let mut count = 0u64;
    let mut singular = 0u64;
    let mut support_counts = [0u64; 32];
    for lead in 0..5 {
        let rest = 4 - lead;
        let total = p.pow(rest as u32);
        for mut code in 0..total {
            let mut x = [0usize; 5];
            x[lead] = 1;
            for slot in x.iter_mut().skip(lead + 1) {
                *slot = code % p;
                code /= p;
            }
            let mut f = 0usize;
            for i in 0..5 {
                f = (f + x[i] * x[i] % p * x[(i + 1) % 5]) % p;
            }
            if f == 0 {
                count += 1;
                let mask = (0..5).fold(0usize, |a, i| a | ((x[i] != 0) as usize) << i);
                support_counts[mask] += 1;
            }
            if lead == 0 && x.iter().all(|&v| v != 0) {
                let smooth =
                    (0..5).any(|i| (2 * x[i] * x[(i + 1) % 5] + x[(i + 4) % 5].pow(2)) % p != 0);
                if !smooth {
                    singular += 1;
                }
            }
        }
    }
    (count, singular, support_counts)
}

fn main() {
    for p in [31usize, 41, 61] {
        let (n1, singular, supports) = base_prime_checks(p);
        let expected1 = 1u64 + p as u64 + (p as u64).pow(2) + (p as u64).pow(3);
        assert_eq!(n1, expected1);
        assert_eq!(singular, 0);
        let f = Fq::new(p, 2);
        let t = f.curve_sum_direct();
        assert_eq!(t, -1);
        let q = f.q as u64;
        let n2 = 1 + q + q.pow(2) + q.pow(3);
        println!("p={p} smooth_base_singular={singular} N1={n1} k2_T={t} N2={n2}");
        if p == 31 {
            let m = (p - 1) as u64;
            let n5 = (m.pow(5) - m) / p as u64;
            let n4 = (m.pow(4) - m.pow(2)) / p as u64;
            let n3 = (m.pow(3) + m.pow(2)) / p as u64;
            assert_eq!(supports[31] * m, n5);
            for mask in 1usize..31 {
                let bits = mask.count_ones();
                let consecutive3 = (0..5)
                    .any(|i| mask == ((1 << i) | (1 << ((i + 1) % 5)) | (1 << ((i + 2) % 5))));
                let adjacent2 = (0..5).any(|i| mask == ((1 << i) | (1 << ((i + 1) % 5))));
                let expected = match bits {
                    4 => n4,
                    3 if consecutive3 => n3,
                    3 => 0,
                    2 if adjacent2 => 0,
                    2 => m.pow(2),
                    1 => m,
                    _ => continue,
                };
                assert_eq!(supports[mask] * m, expected, "support mask {mask}");
            }
            println!("p=31 strata_affine N5={n5} each_N4={n4} each_consecutive_N3={n3} each_split_N3=0 each_adjacent_N2=0 each_nonadjacent_N2={} each_N1={m}", m.pow(2));
        }
    }
}
