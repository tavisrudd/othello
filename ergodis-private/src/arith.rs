//! Integer arithmetic helpers shared by the gem-hunt task drivers.
//!
//! Every function here was previously duplicated across two or more of the
//! C1018/C1020/C1025/C1028/C1029 binaries.  Where the copies differed in more
//! than a doc comment or a local variable name, both behaviours are kept under
//! distinct names rather than silently unified; see `lcm_i128` versus
//! `lcm_i128_nonzero`.
//!
//! These are cold setup and certificate-construction helpers.  None of them
//! runs inside an Ergodis solve hot loop, so the zero-allocation contract in
//! the core `PERFORMANCE.md` binds their callers, not these functions; the ones
//! that return `Vec` (`prime_divisors_*`) are called once per parameter set.

/// Greatest common divisor of two signed integers, returned nonnegative.
pub fn gcd_i128(a: i128, b: i128) -> i128 {
    if b == 0 {
        a.abs()
    } else {
        gcd_i128(b, a % b)
    }
}

/// Greatest common divisor of two unsigned integers.
pub fn gcd_u64(a: u64, b: u64) -> u64 {
    if b == 0 {
        a
    } else {
        gcd_u64(b, a % b)
    }
}

/// Least common multiple, defined as `0` when either argument is `0`.
///
/// This is the C1018 transversal-CSS and level-census behaviour.
pub fn lcm_i128(a: i128, b: i128) -> i128 {
    if a == 0 || b == 0 {
        0
    } else {
        a / gcd_i128(a, b) * b
    }
}

/// Least common multiple without the zero guard, as used by the C1029
/// parametric-certificate driver, where both arguments are known positive.
///
/// Kept separate because `lcm_i128_nonzero(0, 0)` divides by zero whereas
/// [`lcm_i128`] returns `0`.
pub fn lcm_i128_nonzero(a: i128, b: i128) -> i128 {
    a / gcd_i128(a, b) * b
}

/// Distinct prime divisors of `n`, ascending.
pub fn prime_divisors_usize(mut n: usize) -> Vec<usize> {
    let mut out = Vec::new();
    let mut d = 2usize;
    while d * d <= n {
        if n % d == 0 {
            out.push(d);
            while n % d == 0 {
                n /= d;
            }
        }
        d += 1;
    }
    if n > 1 {
        out.push(n);
    }
    out
}

/// Distinct prime divisors of `n`, ascending.
pub fn prime_divisors_u64(mut n: u64) -> Vec<u64> {
    let mut out = Vec::new();
    let mut p = 2u64;
    while p * p <= n {
        if n % p == 0 {
            out.push(p);
            while n % p == 0 {
                n /= p;
            }
        }
        p += 1;
    }
    if n > 1 {
        out.push(n);
    }
    out
}

/// Binomial coefficient `C(n, k)` as an exact `u128`.
pub fn binom(n: usize, k: usize) -> u128 {
    if k > n {
        return 0;
    }
    let mut acc: u128 = 1;
    for i in 0..k {
        acc = acc * (n - i) as u128 / (i as u128 + 1);
    }
    acc
}

/// Write `q = p^h` with `p` prime, or return `None` when `q` is not a prime
/// power.
pub fn factor_prime_power(q: usize) -> Option<(usize, usize)> {
    if q < 2 {
        return None;
    }
    let mut p = 2usize;
    while p * p <= q {
        if q % p == 0 {
            break;
        }
        p += 1;
    }
    if p * p > q {
        return Some((q, 1));
    }
    let mut h = 0usize;
    let mut m = q;
    while m % p == 0 {
        m /= p;
        h += 1;
    }
    if m == 1 {
        Some((p, h))
    } else {
        None
    }
}

/// Write `q = p^h` with `p` prime, failing closed when `q` is not a prime
/// power.
///
/// This is the C1020 exterior-set driver's variant: it uses trial division from
/// below rather than the square-root cutoff of [`factor_prime_power`], and it
/// reports the failure as an error instead of `None`.  Kept separate because
/// its argument and result widths are the plane-order widths that driver's
/// projective indexing requires.
pub fn factor_prime_power_u16(q: u16) -> anyhow::Result<(u8, u8)> {
    use anyhow::{bail, Context as _};
    if q < 2 {
        bail!("q = {q} is not a prime power");
    }
    for p in 2u16..=q {
        if q % p != 0 {
            continue;
        }
        let mut rest = q;
        let mut h = 0u8;
        while rest % p == 0 {
            rest /= p;
            h += 1;
        }
        if rest != 1 {
            bail!("q = {q} is not a prime power");
        }
        return Ok((u8::try_from(p).context("characteristic exceeds u8")?, h));
    }
    bail!("q = {q} is not a prime power")
}

/// Smith normal form of `m` (R x n). Returns (diagonal entries, V) with
/// `U m V = D` for some unimodular `U`; only `V` (n x n) is tracked.
pub fn smith_normal_form(m: &[Vec<i128>], n: usize) -> (Vec<i128>, Vec<Vec<i128>>) {
    let mut a: Vec<Vec<i128>> = m.to_vec();
    let rows = a.len();
    let mut v: Vec<Vec<i128>> = (0..n)
        .map(|i| (0..n).map(|j| if i == j { 1 } else { 0 }).collect())
        .collect();
    let mut diag = Vec::new();
    let mut t = 0usize;
    while t < rows && t < n {
        // find pivot: smallest nonzero absolute value in the active submatrix
        let mut best: Option<(usize, usize)> = None;
        for i in t..rows {
            for j in t..n {
                if a[i][j] != 0 {
                    let cand = a[i][j].abs();
                    if best.is_none_or(|(bi, bj)| cand < a[bi][bj].abs()) {
                        best = Some((i, j));
                    }
                }
            }
        }
        let Some((pi, pj)) = best else { break };
        a.swap(t, pi);
        if pj != t {
            for row in a.iter_mut() {
                row.swap(t, pj);
            }
            for row in v.iter_mut() {
                row.swap(t, pj);
            }
        }
        loop {
            // clear column t
            let mut changed = false;
            for i in (t + 1)..rows {
                if a[i][t] != 0 {
                    let q = a[i][t] / a[t][t];
                    for j in t..n {
                        a[i][j] -= q * a[t][j];
                    }
                    if a[i][t] != 0 {
                        a.swap(t, i);
                        changed = true;
                    }
                }
            }
            // clear row t
            for j in (t + 1)..n {
                if a[t][j] != 0 {
                    let q = a[t][j] / a[t][t];
                    for row in a.iter_mut() {
                        row[j] -= q * row[t];
                    }
                    for row in v.iter_mut() {
                        row[j] -= q * row[t];
                    }
                    if a[t][j] != 0 {
                        for row in a.iter_mut() {
                            row.swap(t, j);
                        }
                        for row in v.iter_mut() {
                            row.swap(t, j);
                        }
                        changed = true;
                    }
                }
            }
            if !changed {
                break;
            }
        }
        // divisibility fix-up: if some entry is not divisible by pivot, fold it in
        let mut fixed = false;
        'outer: for i in (t + 1)..rows {
            for j in (t + 1)..n {
                if a[i][j] % a[t][t] != 0 {
                    for j2 in t..n {
                        a[t][j2] += a[i][j2];
                    }
                    fixed = true;
                    break 'outer;
                }
            }
        }
        if fixed {
            continue;
        }
        if a[t][t] < 0 {
            for row in a.iter_mut() {
                row[t] = -row[t];
            }
            for row in v.iter_mut() {
                row[t] = -row[t];
            }
        }
        diag.push(a[t][t]);
        t += 1;
    }
    (diag, v)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn gcd_and_lcm_agree_with_products() {
        assert_eq!(gcd_i128(-12, 18), 6);
        assert_eq!(gcd_u64(12, 18), 6);
        assert_eq!(lcm_i128(4, 6), 12);
        assert_eq!(lcm_i128(0, 6), 0);
        assert_eq!(lcm_i128_nonzero(4, 6), 12);
    }

    #[test]
    fn prime_divisors_are_distinct_and_ascending() {
        assert_eq!(prime_divisors_usize(360), vec![2, 3, 5]);
        assert_eq!(prime_divisors_u64(360), vec![2, 3, 5]);
        assert_eq!(prime_divisors_usize(1), Vec::<usize>::new());
    }

    #[test]
    fn binom_matches_pascal() {
        assert_eq!(binom(5, 2), 10);
        assert_eq!(binom(5, 6), 0);
        assert_eq!(binom(20, 10), 184_756);
    }

    #[test]
    fn prime_powers_only() {
        assert_eq!(factor_prime_power(9), Some((3, 2)));
        assert_eq!(factor_prime_power(7), Some((7, 1)));
        assert_eq!(factor_prime_power(12), None);
        assert_eq!(factor_prime_power(1), None);
        assert_eq!(factor_prime_power_u16(9).unwrap(), (3, 2));
        assert!(factor_prime_power_u16(12).is_err());
    }

    #[test]
    fn smith_normal_form_of_diagonal_two_three() {
        let (diag, _) = smith_normal_form(&[vec![2, 0], vec![0, 3]], 2);
        assert_eq!(diag, vec![1, 6]);
    }
}
