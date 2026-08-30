//! Constructions used by `selftest`: Sylvester, Paley I, Williamson, Goethals--Seidel,
//! two-circulant (periodic Golay) and bordered two-circulant (Legendre pair) Hadamard matrices.

use anyhow::{bail, Result};

use crate::matrix::Matrix;

pub fn is_prime(q: usize) -> bool {
    if q < 2 {
        return false;
    }
    let mut d = 2;
    while d * d <= q {
        if q % d == 0 {
            return false;
        }
        d += 1;
    }
    true
}

/// `Some((p, k))` when `q == p^k` with `p` prime and `k >= 1`.
pub fn prime_power(q: usize) -> Option<(usize, u32)> {
    if q < 2 {
        return None;
    }
    let mut p = 2;
    while p * p <= q {
        if q % p == 0 {
            let mut m = q;
            let mut k = 0;
            while m % p == 0 {
                m /= p;
                k += 1;
            }
            return if m == 1 { Some((p, k)) } else { None };
        }
        p += 1;
    }
    Some((q, 1))
}

/// Sylvester Hadamard matrix of order `2^k`.
pub fn sylvester(order: usize) -> Result<Matrix> {
    if order == 0 || order & (order - 1) != 0 {
        bail!("sylvester order {order} is not a power of two");
    }
    let mut rows = vec![vec![1i8; order]; order];
    for i in 0..order {
        for j in 0..order {
            rows[i][j] = if (i & j).count_ones() % 2 == 0 { 1 } else { -1 };
        }
    }
    Matrix::from_rows(rows)
}

/// Paley type I Hadamard matrix of order `q + 1`, for `q` an odd prime with `q = 3 (mod 4)`.
pub fn paley1(q: usize) -> Result<Matrix> {
    if !is_prime(q) || q % 4 != 3 {
        bail!("paley1 needs a prime q = 3 (mod 4), got {q}");
    }
    let mut chi = vec![-1i8; q];
    chi[0] = 0;
    for x in 1..q {
        chi[(x * x) % q] = 1;
    }
    let n = q + 1;
    let mut rows = vec![vec![0i8; n]; n];
    for i in 0..n {
        for j in 0..n {
            let s: i8 = if i == 0 && j == 0 {
                0
            } else if i == 0 {
                1
            } else if j == 0 {
                -1
            } else {
                chi[((j + q) - i) % q]
            };
            rows[i][j] = s + if i == j { 1 } else { 0 };
        }
    }
    Matrix::from_rows(rows)
}

pub fn circulant(seq: &[i8]) -> Vec<Vec<i8>> {
    let m = seq.len();
    (0..m)
        .map(|i| (0..m).map(|j| seq[(j + m - i) % m]).collect())
        .collect()
}

fn neg(b: &[Vec<i8>]) -> Vec<Vec<i8>> {
    b.iter().map(|r| r.iter().map(|&v| -v).collect()).collect()
}

fn transpose(b: &[Vec<i8>]) -> Vec<Vec<i8>> {
    let h = b.len();
    let w = b[0].len();
    (0..w).map(|j| (0..h).map(|i| b[i][j]).collect()).collect()
}

/// Right-multiply by the back-diagonal `R` (reverse the columns).
fn times_r(b: &[Vec<i8>]) -> Vec<Vec<i8>> {
    b.iter()
        .map(|r| r.iter().rev().cloned().collect())
        .collect()
}

/// Assemble a matrix from a grid of equally sized blocks.
pub fn assemble(grid: &[Vec<Vec<Vec<i8>>>]) -> Result<Matrix> {
    let m = grid[0][0].len();
    let mut rows: Vec<Vec<i8>> = Vec::new();
    for brow in grid {
        for i in 0..m {
            let mut r = Vec::new();
            for blk in brow {
                r.extend_from_slice(&blk[i]);
            }
            rows.push(r);
        }
    }
    Matrix::from_rows(rows)
}

/// Periodic autocorrelation of a +-1 sequence at every shift.
pub fn paf(a: &[i8]) -> Vec<i64> {
    let m = a.len();
    (0..m)
        .map(|s| {
            (0..m)
                .map(|i| (a[i] as i64) * (a[(i + s) % m] as i64))
                .sum()
        })
        .collect()
}

/// Williamson array from four symmetric circulant +-1 sequences of odd length `m`.
///
/// ```text
/// [  A   B   C   D
///   -B   A   D  -C
///   -C  -D   A   B
///   -D   C  -B   A ]
/// ```
pub fn williamson(a: &[i8], b: &[i8], c: &[i8], d: &[i8]) -> Result<Matrix> {
    let m = a.len();
    for s in [a, b, c, d] {
        if s.len() != m {
            bail!("williamson blocks must have equal length");
        }
        for j in 1..m {
            if s[j] != s[m - j] {
                bail!("williamson blocks must be symmetric circulants");
            }
        }
    }
    let (aa, bb, cc, dd) = (circulant(a), circulant(b), circulant(c), circulant(d));
    let sum: Vec<i64> = (0..m)
        .map(|s| paf(a)[s] + paf(b)[s] + paf(c)[s] + paf(d)[s])
        .collect();
    for (s, &v) in sum.iter().enumerate().skip(1) {
        if v != 0 {
            bail!("williamson condition fails at shift {s}: {v}");
        }
    }
    assemble(&[
        vec![aa.clone(), bb.clone(), cc.clone(), dd.clone()],
        vec![neg(&bb), aa.clone(), dd.clone(), neg(&cc)],
        vec![neg(&cc), neg(&dd), aa.clone(), bb.clone()],
        vec![neg(&dd), cc.clone(), neg(&bb), aa.clone()],
    ])
}

/// Goethals--Seidel array from four circulant +-1 sequences with `sum_i PAF_i(s) = 0`.
///
/// ```text
/// [  A     B R    C R    D R
///   -B R   A      D^T R -C^T R
///   -C R  -D^T R  A      B^T R
///   -D R   C^T R -B^T R  A    ]
/// ```
pub fn goethals_seidel(a: &[i8], b: &[i8], c: &[i8], d: &[i8]) -> Result<Matrix> {
    let m = a.len();
    for s in [b, c, d] {
        if s.len() != m {
            bail!("goethals-seidel blocks must have equal length");
        }
    }
    for s in 1..m {
        let v = paf(a)[s] + paf(b)[s] + paf(c)[s] + paf(d)[s];
        if v != 0 {
            bail!("goethals-seidel condition fails at shift {s}: {v}");
        }
    }
    let (aa, bb, cc, dd) = (circulant(a), circulant(b), circulant(c), circulant(d));
    let br = times_r(&bb);
    let cr = times_r(&cc);
    let dr = times_r(&dd);
    let btr = times_r(&transpose(&bb));
    let ctr = times_r(&transpose(&cc));
    let dtr = times_r(&transpose(&dd));
    assemble(&[
        vec![aa.clone(), br.clone(), cr.clone(), dr.clone()],
        vec![neg(&br), aa.clone(), dtr.clone(), neg(&ctr)],
        vec![neg(&cr), neg(&dtr), aa.clone(), btr.clone()],
        vec![neg(&dr), ctr.clone(), neg(&btr), aa.clone()],
    ])
}

/// Two-circulant Hadamard matrix `[A B; B^T -A^T]` of order `2m` from a periodic Golay pair
/// (`PAF_a(s) + PAF_b(s) = 0` for every `s != 0`).
pub fn two_circulant(a: &[i8], b: &[i8]) -> Result<Matrix> {
    let m = a.len();
    if b.len() != m {
        bail!("two-circulant blocks must have equal length");
    }
    for s in 1..m {
        let v = paf(a)[s] + paf(b)[s];
        if v != 0 {
            bail!("periodic Golay condition fails at shift {s}: {v}");
        }
    }
    let (aa, bb) = (circulant(a), circulant(b));
    assemble(&[
        vec![aa.clone(), bb.clone()],
        vec![transpose(&bb), neg(&transpose(&aa))],
    ])
}

/// Bordered two-circulant Hadamard matrix of order `2*ell + 2` from a Legendre pair
/// (`PAF_a(s) + PAF_b(s) = -2` for every `s != 0`, and `sum a = sum b = 1`).
///
/// ```text
/// [  1    1    e     e
///    1   -1    e    -e
///   -e^T -e^T  A     B
///   -e^T  e^T  B^T  -A^T ]
/// ```
pub fn legendre_pair_hadamard(a: &[i8], b: &[i8]) -> Result<Matrix> {
    let l = a.len();
    if b.len() != l {
        bail!("legendre pair halves must have equal length");
    }
    for s in 1..l {
        let v = paf(a)[s] + paf(b)[s];
        if v != -2 {
            bail!("legendre pair condition fails at shift {s}: {v} != -2");
        }
    }
    bordered_two_circulant_layout(a, b)
}

/// The same border/core layout with no Legendre-pair validation. Used to exercise the
/// order-668 code paths on sequences that are not (yet) a Legendre pair.
pub fn bordered_two_circulant_layout(a: &[i8], b: &[i8]) -> Result<Matrix> {
    let l = a.len();
    if b.len() != l {
        bail!("bordered two-circulant halves must have equal length");
    }
    let (aa, bb) = (circulant(a), circulant(b));
    let n = 2 * l + 2;
    let mut rows = vec![vec![0i8; n]; n];
    // border rows
    rows[0][0] = 1;
    rows[0][1] = 1;
    rows[1][0] = 1;
    rows[1][1] = -1;
    for j in 0..l {
        rows[0][2 + j] = 1;
        rows[0][2 + l + j] = 1;
        rows[1][2 + j] = 1;
        rows[1][2 + l + j] = -1;
    }
    for i in 0..l {
        rows[2 + i][0] = -1;
        rows[2 + i][1] = -1;
        rows[2 + l + i][0] = -1;
        rows[2 + l + i][1] = 1;
        for j in 0..l {
            rows[2 + i][2 + j] = aa[i][j];
            rows[2 + i][2 + l + j] = bb[i][j];
            rows[2 + l + i][2 + j] = bb[j][i];
            rows[2 + l + i][2 + l + j] = -aa[j][i];
        }
    }
    Matrix::from_rows(rows)
}

// ---------------------------------------------------------------------------
// small brute-force searches used to build the selftest inputs
// ---------------------------------------------------------------------------

fn seq_from_bits(bits: usize, m: usize) -> Vec<i8> {
    (0..m)
        .map(|i| if (bits >> i) & 1 == 0 { 1i8 } else { -1i8 })
        .collect()
}

/// Search for a Williamson quadruple of odd order `m` (symmetric circulants).
pub fn find_williamson(m: usize) -> Option<(Vec<i8>, Vec<i8>, Vec<i8>, Vec<i8>)> {
    if m % 2 == 0 {
        return None;
    }
    let half = (m - 1) / 2;
    let mut cands: Vec<Vec<i8>> = Vec::new();
    for bits in 0..(1usize << (half + 1)) {
        let mut s = vec![1i8; m];
        for j in 0..=half {
            s[j] = if (bits >> j) & 1 == 0 { 1 } else { -1 };
        }
        for j in 1..=half {
            s[m - j] = s[j];
        }
        cands.push(s);
    }
    let pafs: Vec<Vec<i64>> = cands.iter().map(|s| paf(s)).collect();
    let k = cands.len();
    for i0 in 0..k {
        for i1 in i0..k {
            for i2 in i1..k {
                for i3 in i2..k {
                    if (1..m).all(|s| {
                        pafs[i0][s] + pafs[i1][s] + pafs[i2][s] + pafs[i3][s] == 0
                    }) {
                        return Some((
                            cands[i0].clone(),
                            cands[i1].clone(),
                            cands[i2].clone(),
                            cands[i3].clone(),
                        ));
                    }
                }
            }
        }
    }
    None
}

/// Search for a Legendre pair of length `ell` with both row sums equal to 1.
pub fn find_legendre_pair(l: usize) -> Option<(Vec<i8>, Vec<i8>)> {
    use std::collections::HashMap;
    let mut by_profile: HashMap<Vec<i64>, Vec<i8>> = HashMap::new();
    for bits in 0..(1usize << l) {
        let s = seq_from_bits(bits, l);
        if s.iter().map(|&v| v as i64).sum::<i64>() != 1 {
            continue;
        }
        let p = paf(&s);
        let key: Vec<i64> = p[1..].to_vec();
        let want: Vec<i64> = key.iter().map(|v| -2 - v).collect();
        if let Some(other) = by_profile.get(&want) {
            return Some((other.clone(), s));
        }
        by_profile.entry(key).or_insert(s);
    }
    None
}

/// Search for a periodic Golay pair of length `m` (`PAF_a(s) + PAF_b(s) = 0`, `s != 0`).
pub fn find_periodic_golay(m: usize) -> Option<(Vec<i8>, Vec<i8>)> {
    use std::collections::HashMap;
    let mut by_profile: HashMap<Vec<i64>, Vec<i8>> = HashMap::new();
    for bits in 0..(1usize << m) {
        let s = seq_from_bits(bits, m);
        let p = paf(&s);
        let key: Vec<i64> = p[1..].to_vec();
        let want: Vec<i64> = key.iter().map(|v| -v).collect();
        if let Some(other) = by_profile.get(&want) {
            return Some((other.clone(), s));
        }
        by_profile.entry(key).or_insert(s);
    }
    None
}
