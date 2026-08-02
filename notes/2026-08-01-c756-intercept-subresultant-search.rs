// C756 intercept-subresultant probe: covering-configuration search.
//
// Seeded simulated annealing for n affine points over F_p (p prime), in
// general position (distinct x_i, no three collinear), whose C(n,2) chord
// slopes cover all of F_p.  Slack delta = C(n,2) - p.  Used for the hard
// large instances; smaller instances are found directly by the companion
// Python script 2026-08-01-c756-intercept-subresultant-cover.py.
//
// Deterministic: xorshift64* RNG with the seeds printed below.
//
// Build/run (standalone, no crate deps):
//   rustc -O notes/2026-08-01-c756-intercept-subresultant-search.rs \
//       -o /tmp/c756-search && /tmp/c756-search

const MOVES_PER_RUN: u64 = 30_000_000;
const SEEDS: [u64; 8] = [
    20260801, 20260802, 20260803, 20260804, 20260805, 20260806, 20260807,
    20260808,
];
const INSTANCES: [(usize, i64); 3] = [(9, 31), (10, 41), (10, 43)];

struct Rng(u64);
impl Rng {
    fn next(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x >> 12;
        x ^= x << 25;
        x ^= x >> 27;
        self.0 = x;
        x.wrapping_mul(0x2545F4914F6CDD1D)
    }
    fn below(&mut self, n: u64) -> u64 {
        self.next() % n
    }
    fn unit(&mut self) -> f64 {
        (self.next() >> 11) as f64 / (1u64 << 53) as f64
    }
}

struct Search {
    n: usize,
    p: i64,
    inv: Vec<i64>,
}

impl Search {
    fn new(n: usize, p: i64) -> Self {
        let mut inv = vec![0i64; p as usize];
        for a in 1..p {
            let mut x = 1i64;
            for _ in 0..(p - 2) {
                x = x * a % p;
            }
            inv[a as usize] = x;
        }
        Search { n, p, inv }
    }

    fn slope(&self, a: (i64, i64), b: (i64, i64)) -> usize {
        let dx = (a.0 - b.0).rem_euclid(self.p);
        let dy = (a.1 - b.1).rem_euclid(self.p);
        (dy * self.inv[dx as usize] % self.p) as usize
    }

    fn collinear(&self, a: (i64, i64), b: (i64, i64), c: (i64, i64)) -> bool {
        ((b.0 - a.0) * (c.1 - a.1) - (c.0 - a.0) * (b.1 - a.1))
            .rem_euclid(self.p)
            == 0
    }

    fn valid_replace(&self, pts: &[(i64, i64)], i: usize, np: (i64, i64)) -> bool {
        let n = self.n;
        for j in 0..n {
            if j != i && pts[j].0 == np.0 {
                return false;
            }
        }
        for j in 0..n {
            if j == i {
                continue;
            }
            for k in (j + 1)..n {
                if k == i {
                    continue;
                }
                if self.collinear(np, pts[j], pts[k]) {
                    return false;
                }
            }
        }
        true
    }

    fn run(&self, seed: u64) -> Option<Vec<(i64, i64)>> {
        let (n, p) = (self.n, self.p);
        let mut rng = Rng(seed);
        let mut pts = vec![(0i64, 0i64); n];
        'restart: loop {
            let mut used = vec![false; p as usize];
            for i in 0..n {
                loop {
                    let x = rng.below(p as u64) as i64;
                    if !used[x as usize] {
                        used[x as usize] = true;
                        pts[i] = (x, rng.below(p as u64) as i64);
                        break;
                    }
                }
            }
            for i in 0..n {
                for j in (i + 1)..n {
                    for k in (j + 1)..n {
                        if self.collinear(pts[i], pts[j], pts[k]) {
                            continue 'restart;
                        }
                    }
                }
            }
            break;
        }
        let mut cnt = vec![0i32; p as usize];
        for i in 0..n {
            for j in (i + 1)..n {
                cnt[self.slope(pts[i], pts[j])] += 1;
            }
        }
        let unc = |c: &[i32]| c.iter().filter(|&&v| v == 0).count() as i32;
        let mut sc = unc(&cnt);
        let mut temp = 1.5f64;
        let cool = 0.9999997f64;
        for _ in 0..MOVES_PER_RUN {
            if sc == 0 {
                return Some(pts);
            }
            temp *= cool;
            let i = rng.below(n as u64) as usize;
            let old = pts[i];
            let np = if rng.unit() < 0.6 {
                let miss: Vec<usize> =
                    (0..p as usize).filter(|&s| cnt[s] == 0).collect();
                let s = miss[rng.below(miss.len() as u64) as usize] as i64;
                let mut j = rng.below(n as u64) as usize;
                while j == i {
                    j = rng.below(n as u64) as usize;
                }
                let x = rng.below(p as u64) as i64;
                (x, (pts[j].1 + s * (x - pts[j].0)).rem_euclid(p))
            } else {
                (rng.below(p as u64) as i64, rng.below(p as u64) as i64)
            };
            if !self.valid_replace(&pts, i, np) {
                continue;
            }
            let mut nc = cnt.clone();
            for j in 0..n {
                if j != i {
                    nc[self.slope(old, pts[j])] -= 1;
                }
            }
            pts[i] = np;
            for j in 0..n {
                if j != i {
                    nc[self.slope(np, pts[j])] += 1;
                }
            }
            let s2 = unc(&nc);
            let d = (s2 - sc) as f64;
            if d <= 0.0 || rng.unit() < (-d / temp).exp() {
                cnt = nc;
                sc = s2;
            } else {
                pts[i] = old;
            }
            if temp < 0.02 {
                temp = 1.0; // reheat
            }
        }
        None
    }
}

fn main() {
    for (n, p) in INSTANCES {
        let delta = (n * (n - 1) / 2) as i64 - p;
        let search = Search::new(n, p);
        let mut found = false;
        for seed in SEEDS {
            match search.run(seed) {
                Some(pts) => {
                    println!(
                        "(n,p)=({},{}) delta={} seed={} FOUND {:?}",
                        n, p, delta, seed, pts
                    );
                    found = true;
                    break;
                }
                None => println!(
                    "(n,p)=({},{}) delta={} seed={} exhausted {} moves",
                    n, p, delta, seed, MOVES_PER_RUN
                ),
            }
        }
        if !found {
            println!(
                "(n,p)=({},{}) delta={} NOT FOUND after {} seeds x {} moves",
                n,
                p,
                delta,
                SEEDS.len(),
                MOVES_PER_RUN
            );
        }
    }
}
