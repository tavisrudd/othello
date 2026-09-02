//! Bit-packed GF(2) linear algebra on 64-coordinate words.
//!
//! Lifted verbatim from the C1018 transversal-CSS and level-census drivers,
//! which carried byte-identical copies apart from doc comments.  These are cold
//! setup/analysis helpers, not solve-hot-loop kernels: they allocate owned
//! `Vec<Word>` results by design and are called once per catalogued code, so the
//! Ergodis zero-allocation hot-loop contract does not apply to them.

/// One 64-coordinate GF(2) vector, bit `i` being coordinate `i`.
pub type Word = u64;

/// Reduce `basis` to reduced row echelon form in place and drop zero rows.
pub fn rref(basis: &mut Vec<Word>, n: usize) {
    let mut rank = 0usize;
    for col in 0..n {
        let bit = 1u64 << col;
        let Some(p) = (rank..basis.len()).find(|&i| basis[i] & bit != 0) else {
            continue;
        };
        basis.swap(rank, p);
        for i in 0..basis.len() {
            if i != rank && basis[i] & bit != 0 {
                basis[i] ^= basis[rank];
            }
        }
        rank += 1;
    }
    basis.truncate(rank);
    basis.retain(|&w| w != 0);
}

/// Every vector of the span of `basis`, in Gray-free doubling order.
pub fn span(basis: &[Word]) -> Vec<Word> {
    let mut out = vec![0u64];
    for &b in basis {
        let cur: Vec<Word> = out.iter().map(|&w| w ^ b).collect();
        out.extend(cur);
    }
    out
}

/// Basis of the dual code `{y : y·b = 0 ∀ b ∈ basis}` inside `F_2^n`.
pub fn dual_basis(basis: &[Word], n: usize) -> Vec<Word> {
    let mut rows = basis.to_vec();
    rref(&mut rows, n);
    // pivot columns
    let mut pivots = Vec::new();
    for r in &rows {
        pivots.push(r.trailing_zeros() as usize);
    }
    let free: Vec<usize> = (0..n).filter(|c| !pivots.contains(c)).collect();
    let mut out = Vec::new();
    for &f in &free {
        let mut y = 1u64 << f;
        for (i, r) in rows.iter().enumerate() {
            if r >> f & 1 == 1 {
                y |= 1u64 << pivots[i];
            }
        }
        out.push(y);
    }
    out
}

/// Weight of the coordinatewise product of two GF(2) vectors.
pub fn popcount_and(a: Word, b: Word) -> u32 {
    (a & b).count_ones()
}

/// The all-ones vector of length `n` (`n <= 64`).
pub fn all_ones(n: usize) -> Word {
    if n == 64 {
        !0
    } else {
        (1u64 << n) - 1
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn rref_drops_dependent_rows() {
        let mut basis = vec![0b011u64, 0b110, 0b101];
        rref(&mut basis, 3);
        assert_eq!(basis.len(), 2);
    }

    #[test]
    fn dual_of_repetition_is_even_weight() {
        let dual = dual_basis(&[0b1111u64], 4);
        assert_eq!(dual.len(), 3);
        for &w in &dual {
            assert_eq!(w.count_ones() % 2, 0);
        }
    }

    #[test]
    fn span_has_two_to_the_rank_elements() {
        assert_eq!(span(&[0b001u64, 0b010]).len(), 4);
    }

    #[test]
    fn all_ones_edges() {
        assert_eq!(all_ones(3), 0b111);
        assert_eq!(all_ones(64), u64::MAX);
        assert_eq!(popcount_and(0b1011, 0b0111), 2);
    }
}
