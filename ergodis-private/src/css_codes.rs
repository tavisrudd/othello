//! Binary code constructions and Clifford-hierarchy level bookkeeping shared by
//! the C1018 transversal-CSS and level-census drivers.
//!
//! Both drivers previously carried byte-identical copies of these functions
//! apart from doc comments and one inlined temporary.  They are cold catalogue
//! and analysis helpers, evaluated once per code, and are not admitted to any
//! Ergodis solve hot loop.

use crate::arith::gcd_i128;
use crate::gf2_linalg::{rref, Word};

/// Reed–Muller RM(r, mm) as a length-2^mm binary code, coordinates indexed by
/// the integer whose bits are the evaluation point.
pub fn reed_muller(r: usize, mm: usize) -> Vec<Word> {
    let n = 1usize << mm;
    let mut gens = Vec::new();
    for s in 0..(1usize << mm) {
        if (s as u32).count_ones() as usize > r {
            continue;
        }
        let mut w: Word = 0;
        for p in 0..n {
            if s & !p == 0 {
                // monomial ∏_{i∈s} x_i evaluated at p
                w |= 1u64 << p;
            }
        }
        gens.push(w);
    }
    let mut g = gens;
    rref(&mut g, n);
    g
}

/// Clifford-hierarchy level of the logical diagonal gate whose phase table is
/// `logical` (units `2 pi / modulus`) on `k` logical qubits.
///
/// Returns `usize::MAX` when some Mobius coefficient has odd multiplicative
/// order, which places the gate in no level of the qubit Clifford hierarchy.
pub fn multilinear_level(logical: &[i128], k: usize, modulus: i128) -> usize {
    // Mobius expansion over Z_modulus: alpha_S = sum_{R subset S} (-1)^{|S|-|R|} f(R)
    let mut level = 0usize;
    for s in 0..(1usize << k) {
        let mut alpha: i128 = 0;
        let mut r = s;
        loop {
            let sign = if ((s.count_ones() - r.count_ones()) % 2) == 0 {
                1
            } else {
                -1
            };
            alpha += sign * logical[r];
            if r == 0 {
                break;
            }
            r = (r - 1) & s;
        }
        let alpha = alpha.rem_euclid(modulus);
        if alpha == 0 {
            continue;
        }
        // order of alpha in Z_modulus
        let ord = modulus / gcd_i128(alpha, modulus);
        // e such that ord = 2^e (odd part contributes via its own bound)
        let mut e = 0usize;
        let mut o = ord;
        while o % 2 == 0 {
            o /= 2;
            e += 1;
        }
        if o != 1 {
            // odd-order component: not in any level of the qubit Clifford
            // hierarchy; flag with a large level so it is visible.
            return usize::MAX;
        }
        let deg = s.count_ones() as usize;
        let cand = deg + e - 1;
        if cand > level {
            level = cand;
        }
    }
    level
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn reed_muller_dimensions() {
        // RM(1, 3) is the [8, 4] first-order Reed-Muller code.
        assert_eq!(reed_muller(1, 3).len(), 4);
        // RM(m, m) is the whole space.
        assert_eq!(reed_muller(3, 3).len(), 8);
    }

    #[test]
    fn t_gate_is_level_three() {
        // Single logical qubit, phases (0, 1) in units of 2 pi / 8.
        assert_eq!(multilinear_level(&[0, 1], 1, 8), 3);
        // S gate: phases (0, 1) in units of 2 pi / 4.
        assert_eq!(multilinear_level(&[0, 1], 1, 4), 2);
    }

    #[test]
    fn odd_order_phase_is_flagged() {
        assert_eq!(multilinear_level(&[0, 1], 1, 3), usize::MAX);
    }
}
