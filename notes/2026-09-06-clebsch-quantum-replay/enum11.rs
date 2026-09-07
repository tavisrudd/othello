// Full ordinary weight enumerator of ker G for the p=11 memo code, via the
// subset-rank identity  B_w = sum_{|S|=w} p^{w - r(G_S)}.
// Reads "rows cols" then the matrix (rows x cols) from stdin, prints B_0..B_n.
use std::io::Read;

const P: u64 = 11;
const R: usize = 11; // number of rows of G
const N: usize = 22; // number of columns of G

type Vec11 = [u64; R];

struct Basis {
    rows: [Vec11; R],
    piv: [usize; R],
    rank: usize,
}

impl Clone for Basis {
    fn clone(&self) -> Self {
        Basis { rows: self.rows, piv: self.piv, rank: self.rank }
    }
}

fn reduce(b: &Basis, v: &mut Vec11) -> Option<usize> {
    for i in 0..b.rank {
        let c = b.piv[i];
        let f = v[c] % P;
        if f != 0 {
            for j in 0..R {
                v[j] = (v[j] + (P - f) * b.rows[i][j]) % P;
            }
        }
    }
    (0..R).find(|&j| v[j] != 0)
}

fn inv(a: u64) -> u64 {
    let mut r = 1u64;
    for _ in 0..(P - 2) {
        r = r * a % P;
    }
    r
}

fn dfs(
    j: usize,
    b: &Basis,
    size: usize,
    cols: &[Vec11; N],
    bw: &mut [u128; N + 1],
    pow: &[u128; N + 1],
    binom: &[[u128; N + 1]; N + 1],
) {
    if b.rank == R {
        // every extension has rank R
        let rem = N - j;
        for t in 0..=rem {
            bw[size + t] += binom[rem][t] * pow[size + t - R];
        }
        return;
    }
    if j == N {
        bw[size] += pow[size - b.rank];
        return;
    }
    dfs(j + 1, b, size, cols, bw, pow, binom);
    let mut v = cols[j];
    match reduce(b, &mut v) {
        None => dfs(j + 1, b, size + 1, cols, bw, pow, binom),
        Some(c) => {
            let mut nb = b.clone();
            let f = inv(v[c]);
            for x in v.iter_mut() {
                *x = *x * f % P;
            }
            nb.rows[nb.rank] = v;
            nb.piv[nb.rank] = c;
            nb.rank += 1;
            dfs(j + 1, &nb, size + 1, cols, bw, pow, binom);
        }
    }
}

fn main() {
    let mut s = String::new();
    std::io::stdin().read_to_string(&mut s).unwrap();
    let nums: Vec<u64> = s.split_whitespace().map(|t| t.parse().unwrap()).collect();
    assert_eq!(nums[0] as usize, R);
    assert_eq!(nums[1] as usize, N);
    let mut cols = [[0u64; R]; N];
    for i in 0..R {
        for j in 0..N {
            cols[j][i] = nums[2 + i * N + j] % P;
        }
    }
    let mut pow = [0u128; N + 1];
    pow[0] = 1;
    for i in 1..=N {
        pow[i] = pow[i - 1] * P as u128;
    }
    let mut binom = [[0u128; N + 1]; N + 1];
    for i in 0..=N {
        binom[i][0] = 1;
        for k in 1..=i {
            binom[i][k] = binom[i - 1][k - 1] + if k <= i - 1 { binom[i - 1][k] } else { 0 };
        }
    }
    let b0 = Basis { rows: [[0u64; R]; R], piv: [0usize; R], rank: 0 };
    let mut bw = [0u128; N + 1];
    dfs(0, &b0, 0, &cols, &mut bw, &pow, &binom);
    for w in 0..=N {
        println!("{} {}", w, bw[w]);
    }
}
