//! Finite-field and normal-rational-curve helpers shared by the projective
//! Reed–Solomon (PRS) deep-hole drivers.
//!
//! [`Field`] and the four functions below were duplicated across the C1018
//! deep-hole census, the C1018 parallel census, and the C1025 stratum decision
//! driver.  The three copies differed only in doc comments, local variable
//! names, one method name (`pow` versus `powi`), and which methods each driver
//! happened to need; the version here is the superset with the `pow` spelling.
//!
//! Field arithmetic itself comes from the read-only Ergodis core
//! (`SmallField`), so every driver agrees on the field model by construction.
//! These are cold analysis helpers over small fixed matrices; the Ergodis
//! zero-allocation solve contract applies to the drivers' sweep loops, which
//! keep their own presized scratch and call `rank_of` on caller-owned buffers.

use anyhow::{bail, Context, Result};
use ergodis::field::SmallField;

use crate::arith::{binom, factor_prime_power};

/// GF(p^h) with elements encoded as indices `0..q-1` of the polynomial
/// representation's base-`p` digit vectors.
pub struct Field {
    pub p: usize,
    pub h: usize,
    pub q: usize,
    pub inner: SmallField,
}

impl Field {
    pub fn new(q: usize) -> Result<Self> {
        let (p, h) = factor_prime_power(q).context("q must be a prime power")?;
        if q > 251 {
            bail!("q must be at most 251 (u8 element encoding)");
        }
        let inner = SmallField::new(p as u8, h as u8)?;
        Ok(Self { p, h, q, inner })
    }

    #[inline(always)]
    pub fn a(&self, x: u8, y: u8) -> u8 {
        self.inner.add(x, y)
    }
    #[inline(always)]
    pub fn m(&self, x: u8, y: u8) -> u8 {
        self.inner.mul(x, y)
    }
    #[inline(always)]
    pub fn n(&self, x: u8) -> u8 {
        self.inner.sub(0, x)
    }
    #[inline(always)]
    pub fn i(&self, x: u8) -> u8 {
        self.inner.inverse(x).expect("nonzero field element")
    }
    pub fn pow(&self, x: u8, e: usize) -> u8 {
        let mut acc = 1u8;
        for _ in 0..e {
            acc = self.m(acc, x);
        }
        acc
    }
    /// embed an integer of Z into F_q (image of the prime field)
    pub fn from_int(&self, v: usize) -> u8 {
        (v % self.p) as u8
    }
    pub fn primitive(&self) -> u8 {
        for g in 2..self.q as u8 {
            let mut x = g;
            let mut ord = 1usize;
            while x != 1 {
                x = self.m(x, g);
                ord += 1;
            }
            if ord == self.q - 1 {
                return g;
            }
        }
        // q = 2 or 3
        (self.q - 1) as u8
    }
}

/// S[i][j] = coefficient of x^{d-j} y^j in (a x + b y)^{d-i} (c x + e y)^i.
pub fn sym_power(f: &Field, d: usize, a: u8, b: u8, c: u8, e: u8) -> Vec<Vec<u8>> {
    let mut s = vec![vec![0u8; d + 1]; d + 1];
    for i in 0..=d {
        // A_k = C(d-i,k) a^{d-i-k} b^k ; B_k = C(i,k) c^{i-k} e^k
        let mut av = vec![0u8; d - i + 1];
        for (k, item) in av.iter_mut().enumerate() {
            let coef = f.from_int((binom(d - i, k) % f.p as u128) as usize);
            *item = f.m(f.m(coef, f.pow(a, d - i - k)), f.pow(b, k));
        }
        let mut bv = vec![0u8; i + 1];
        for (k, item) in bv.iter_mut().enumerate() {
            let coef = f.from_int((binom(i, k) % f.p as u128) as usize);
            *item = f.m(f.m(coef, f.pow(c, i - k)), f.pow(e, k));
        }
        for (ka, &x) in av.iter().enumerate() {
            if x == 0 {
                continue;
            }
            for (kb, &y) in bv.iter().enumerate() {
                if y == 0 {
                    continue;
                }
                s[i][ka + kb] = f.a(s[i][ka + kb], f.m(x, y));
            }
        }
    }
    s
}

/// Classify a binary quadratic Q = l0 + l1 x + l2 x^2 (root at ∞ iff l2 = 0)
/// by its root pattern in PG(1,q).
pub fn quadratic_type(f: &Field, l: &[u8]) -> &'static str {
    let mut roots = 0usize;
    for a in 0..f.q as u8 {
        let val = f.a(l[0], f.a(f.m(l[1], a), f.m(l[2], f.m(a, a))));
        if val == 0 {
            roots += 1;
        }
    }
    let inf_mult = if l[2] == 0 {
        if l[1] == 0 {
            2
        } else {
            1
        }
    } else {
        0
    };
    let total = roots + inf_mult;
    if total == 2 && inf_mult <= 1 {
        "split"
    } else if total == 1 || inf_mult == 2 {
        "double"
    } else if total == 0 {
        "inert"
    } else {
        "degenerate"
    }
}

/// Reduced row echelon rank over F_q, computed in place in `data`.
pub fn rank_of(f: &Field, rows: usize, cols: usize, data: &mut [u8]) -> usize {
    let mut pivot = 0usize;
    for col in 0..cols {
        let mut sel = None;
        for row in pivot..rows {
            if data[row * cols + col] != 0 {
                sel = Some(row);
                break;
            }
        }
        let Some(sel) = sel else { continue };
        for c in 0..cols {
            data.swap(pivot * cols + c, sel * cols + c);
        }
        let inv = f.i(data[pivot * cols + col]);
        for c in 0..cols {
            data[pivot * cols + c] = f.m(data[pivot * cols + c], inv);
        }
        for row in 0..rows {
            if row == pivot {
                continue;
            }
            let factor = data[row * cols + col];
            if factor == 0 {
                continue;
            }
            for c in 0..cols {
                let sub = f.m(factor, data[pivot * cols + c]);
                data[row * cols + c] = f.a(data[row * cols + c], f.n(sub));
            }
        }
        pivot += 1;
        if pivot == rows {
            break;
        }
    }
    pivot
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn field_rejects_non_prime_powers_and_large_orders() {
        assert!(Field::new(12).is_err());
        assert!(Field::new(256).is_err());
        assert!(Field::new(9).is_ok());
    }

    #[test]
    fn primitive_element_generates_the_multiplicative_group() {
        let f = Field::new(7).unwrap();
        let g = f.primitive();
        let mut x = g;
        let mut ord = 1usize;
        while x != 1 {
            x = f.m(x, g);
            ord += 1;
        }
        assert_eq!(ord, 6);
    }

    #[test]
    fn sym_power_of_identity_is_the_identity_matrix() {
        let f = Field::new(5).unwrap();
        let s = sym_power(&f, 3, 1, 0, 0, 1);
        for (i, row) in s.iter().enumerate() {
            for (j, &v) in row.iter().enumerate() {
                assert_eq!(v, u8::from(i == j), "entry ({i}, {j})");
            }
        }
    }

    #[test]
    fn quadratic_types_over_gf5() {
        let f = Field::new(5).unwrap();
        // x^2 - 1 = (x-1)(x+1): two distinct affine roots.
        assert_eq!(quadratic_type(&f, &[4, 0, 1]), "split");
        // x^2: a double affine root.
        assert_eq!(quadratic_type(&f, &[0, 0, 1]), "double");
        // x^2 + 2 has no root in GF(5).
        assert_eq!(quadratic_type(&f, &[2, 0, 1]), "inert");
    }

    #[test]
    fn rank_of_identity_and_dependent_rows() {
        let f = Field::new(5).unwrap();
        let mut identity = vec![1, 0, 0, 0, 1, 0, 0, 0, 1];
        assert_eq!(rank_of(&f, 3, 3, &mut identity), 3);
        // (1, 2, 3) and (1, 0, 0) are independent over GF(5).
        let mut independent = vec![1, 2, 3, 1, 0, 0];
        assert_eq!(rank_of(&f, 2, 3, &mut independent), 2);
        // (2, 4, 1) = 2 * (1, 2, 3) over GF(5), since 6 = 1.
        let mut proportional = vec![1, 2, 3, 2, 4, 1];
        assert_eq!(rank_of(&f, 2, 3, &mut proportional), 1);
    }
}
