//! The 4-profile vertex invariant.
//!
//! For four rows, `J(i,j,k,l) = sum_c H_ic H_jc H_kc H_lc`. This is the first level that is not
//! constant on a Hadamard matrix, and the reason plain refinement stalls on the 4n graph:
//!
//! - pairs: `#{c : H_ic = H_jc} = n/2` for every pair, by orthogonality;
//! - triples: `indicator(x=y=z) = (1 + xy + xz + yz)/4`, so `#{c : H_ic = H_jc = H_kc} = n/4`
//!   for every triple, again by orthogonality;
//! - quadruples: `indicator(all equal) = (1 + xy+xz+xw+yz+yw+zw + xyzw)/8`, so the count is
//!   `(n + J(i,j,k,l))/8` and `J` is the first quantity that actually varies.
//!
//! Odd-order products are useless here regardless of cost: under a column sign flip `eps_c` a
//! product of three entries picks up `eps_c^3 = eps_c`, so `|sum_c H_ic H_jc H_kc|` is *not* an
//! automorphism invariant. `J` has four factors, so it is invariant under every column
//! permutation and every column negation, and negating any one row flips its sign. Taking `|J|`
//! therefore gives a quantity invariant under the whole monomial group, and the multiset
//! `{ |J(i,j,k,l)| : j<k<l }` is a genuine invariant of the row pair `{r+, r-}`.
//!
//! In bit terms, with `b_i` the row packed as bits (1 = entry -1),
//! `J(i,j,k,l) = n - 2 * popcount(b_i ^ b_j ^ b_k ^ b_l)`.

use rayon::prelude::*;

use crate::matrix::Matrix;

fn pack(m: &Matrix) -> (Vec<u64>, usize) {
    let n = m.n;
    let w = n.div_ceil(64);
    let mut bits = vec![0u64; n * w];
    for i in 0..n {
        for j in 0..n {
            if m.rows[i][j] == -1 {
                bits[i * w + j / 64] |= 1u64 << (j % 64);
            }
        }
    }
    (bits, w)
}

/// For each row, the histogram of `|J|/2` over all triples of other rows.
///
/// Cost is `C(n,4)` quadruple evaluations -- each quadruple updates all four of its rows, which
/// is four times cheaper than looping triples per row.
pub fn row_profile_histograms(m: &Matrix) -> Vec<Vec<u32>> {
    let n = m.n;
    let (bits, w) = pack(m);
    let nb = n / 2 + 1;

    let zero = || vec![0u32; n * nb];
    let hist = (0..n)
        .into_par_iter()
        .fold(zero, |mut h: Vec<u32>, i| {
            let mut local = vec![0u32; nb];
            for j in (i + 1)..n {
                // x = b_i ^ b_j
                let mut x = [0u64; 32];
                for t in 0..w {
                    x[t] = bits[i * w + t] ^ bits[j * w + t];
                }
                for k in (j + 1)..n {
                    let mut y = [0u64; 32];
                    for t in 0..w {
                        y[t] = x[t] ^ bits[k * w + t];
                    }
                    local[..nb].fill(0);
                    for l in (k + 1)..n {
                        let base = l * w;
                        let mut p = 0u32;
                        for t in 0..w {
                            p += (y[t] ^ bits[base + t]).count_ones();
                        }
                        let b = ((n as i64 - 2 * p as i64).unsigned_abs() / 2) as usize;
                        h[l * nb + b] += 1;
                        local[b] += 1;
                    }
                    for b in 0..nb {
                        let v = local[b];
                        if v != 0 {
                            h[i * nb + b] += v;
                            h[j * nb + b] += v;
                            h[k * nb + b] += v;
                        }
                    }
                }
            }
            h
        })
        .reduce(zero, |mut a, b| {
            for (x, y) in a.iter_mut().zip(b.iter()) {
                *x += *y;
            }
            a
        });

    (0..n).map(|i| hist[i * nb..(i + 1) * nb].to_vec()).collect()
}

/// Group indices by equal histogram. Returns the class index per row and the class sizes,
/// with classes ordered canonically by their histogram so the labelling is reproducible.
pub fn classes(hists: &[Vec<u32>]) -> (Vec<usize>, Vec<usize>) {
    let mut order: Vec<usize> = (0..hists.len()).collect();
    order.sort_by(|&a, &b| hists[a].cmp(&hists[b]));
    let mut class_of = vec![0usize; hists.len()];
    let mut sizes = Vec::new();
    let mut cur = 0usize;
    for (pos, &idx) in order.iter().enumerate() {
        if pos > 0 && hists[idx] != hists[order[pos - 1]] {
            cur += 1;
        }
        class_of[idx] = cur;
        if cur == sizes.len() {
            sizes.push(0);
        }
        sizes[cur] += 1;
    }
    (class_of, sizes)
}

pub struct Profile {
    pub row_class: Vec<usize>,
    pub row_class_sizes: Vec<usize>,
    pub col_class: Vec<usize>,
    pub col_class_sizes: Vec<usize>,
}

pub fn profile(m: &Matrix) -> Profile {
    let rows = row_profile_histograms(m);
    let (row_class, row_class_sizes) = classes(&rows);
    let t = m.transpose();
    let cols = row_profile_histograms(&t);
    let (col_class, col_class_sizes) = classes(&cols);
    Profile {
        row_class,
        row_class_sizes,
        col_class,
        col_class_sizes,
    }
}
