use rayon::prelude::*;
use std::sync::OnceLock;

const MAX_DENSE_K: usize = 9;
const W8_K: usize = 8;
const W9_K: usize = 9;

const fn w9_masks() -> ([u64; W9_K], [u64; 1 << W9_K]) {
    let mut incident = [0u64; W9_K];
    let mut induced = [0u64; 1 << W9_K];
    let mut bit = 0usize;
    let mut i = 0usize;
    while i < W9_K {
        let mut j = i + 1;
        while j < W9_K {
            let edge = 1u64 << bit;
            incident[i] |= edge;
            incident[j] |= edge;
            let mut alive = 0usize;
            while alive < (1 << W9_K) {
                if (alive & (1 << i)) != 0 && (alive & (1 << j)) != 0 {
                    induced[alive] |= edge;
                }
                alive += 1;
            }
            bit += 1;
            j += 1;
        }
        i += 1;
    }
    (incident, induced)
}

const W9_MASKS: ([u64; W9_K], [u64; 1 << W9_K]) = w9_masks();

#[inline]
fn slots(k: usize) -> usize {
    1usize << (k * (k - 1) / 2)
}

#[inline]
fn words(k: usize) -> usize {
    slots(k).div_ceil(64)
}

#[inline]
fn bit_get(bits: &[u64], idx: usize) -> bool {
    (bits[idx >> 6] & (1u64 << (idx & 63))) != 0
}

fn adj_from_code(k: usize, code: usize) -> [u16; MAX_DENSE_K] {
    let mut adj = [0u16; MAX_DENSE_K];
    let mut bit = 0usize;
    for i in 0..k {
        for j in (i + 1)..k {
            if (code >> bit) & 1 != 0 {
                adj[i] |= 1u16 << j;
                adj[j] |= 1u16 << i;
            }
            bit += 1;
        }
    }
    adj
}

fn projected_code(adj: &[u16; MAX_DENSE_K], alive: u16) -> (usize, usize) {
    let k = alive.count_ones() as usize;
    let mut verts = [0usize; MAX_DENSE_K];
    let mut n = 0usize;
    let mut rem = alive;
    while rem != 0 {
        let v = rem.trailing_zeros() as usize;
        rem &= rem - 1;
        verts[n] = v;
        n += 1;
    }

    let mut code = 0usize;
    let mut bit = 0usize;
    for x in 0..k {
        let vx = verts[x];
        for &vy in verts.iter().take(k).skip(x + 1) {
            code |= (((adj[vx] >> vy) & 1) as usize) << bit;
            bit += 1;
        }
    }
    (k, code)
}

fn graph_wins(k: usize, code: usize, tables: &[Box<[u64]>]) -> bool {
    let adj = adj_from_code(k, code);
    let full = (1u16 << k) - 1;
    for i in 0..k {
        let child = full & !((1u16 << i) | adj[i]);
        let (ck, ccode) = projected_code(&adj, child);
        if !bit_get(&tables[ck], ccode) {
            return true;
        }
    }
    false
}

fn build_table(k: usize, tables: &[Box<[u64]>]) -> Box<[u64]> {
    (0..words(k))
        .into_par_iter()
        .map(|word| {
            let mut out = 0u64;
            let base = word << 6;
            let limit = slots(k).saturating_sub(base).min(64);
            for b in 0..limit {
                if graph_wins(k, base + b, tables) {
                    out |= 1u64 << b;
                }
            }
            out
        })
        .collect()
}

/// Complete win/loss tables for all labelled Node-Kayles graphs up to 8 vertices.
///
/// A row is the 28-bit upper-triangular edge code for vertices labelled `0..8`.
/// The value is invariant under relabelling, so callers may use any deterministic
/// labelling of the 8 live board squares and still get the correct result.
pub(crate) struct DenseW8 {
    tables: &'static [Box<[u64]>],
}

impl DenseW8 {
    pub(crate) fn build() -> Self {
        static TABLES: OnceLock<Vec<Box<[u64]>>> = OnceLock::new();
        let tables = TABLES.get_or_init(build_tables);
        DenseW8 { tables }
    }

    #[inline]
    pub(crate) fn get(&self, k: usize, code: usize) -> bool {
        debug_assert!(k <= W8_K);
        debug_assert!(code < slots(k));
        bit_get(&self.tables[k], code)
    }

    /// Exact value of one labelled 9-vertex graph, computed directly from the
    /// complete W0..W8 tables. `code` is the 36-bit upper-triangular edge code.
    /// BMI2 extracts adjacency rows and every induced child code arithmetically;
    /// there is no W9 allocation, canonicalisation, hash lookup, or join.
    #[inline]
    pub(crate) fn get9(&self, code: u64) -> bool {
        use std::arch::x86_64::_pext_u64;

        debug_assert!(code < (1u64 << 36));
        let mut adj = [0u16; W9_K];
        for (i, row) in adj.iter_mut().enumerate() {
            // SAFETY: production is built with target-cpu=znver5, which includes BMI2.
            let packed = unsafe { _pext_u64(code, W9_MASKS.0[i]) } as u16;
            let below = (1u16 << i) - 1;
            *row = (packed & below) | ((packed & !below) << 1);
        }
        let full = (1u16 << W9_K) - 1;
        // `i` is both the removed-vertex bit (`1 << i`) and the `adj[i]` index, so the range
        // loop is the natural form here (not a needless one).
        #[allow(clippy::needless_range_loop)]
        for i in 0..W9_K {
            let child = full & !((1u16 << i) | adj[i]);
            // SAFETY: same BMI2 build invariant as above. Extracted edges retain
            // upper-triangle order, so the result directly indexes W[popcount].
            let child_code = unsafe { _pext_u64(code, W9_MASKS.1[child as usize]) } as usize;
            if !self.get(child.count_ones() as usize, child_code) {
                return true;
            }
        }
        false
    }

    pub(crate) fn bytes(&self) -> u64 {
        self.tables
            .iter()
            .map(|t| t.len() * std::mem::size_of::<u64>())
            .sum::<usize>() as u64
    }
}

fn build_tables() -> Vec<Box<[u64]>> {
    let mut tables: Vec<Box<[u64]>> = Vec::with_capacity(W8_K + 1);
    tables.push(vec![0u64].into_boxed_slice());
    for k in 1..=W8_K {
        tables.push(build_table(k, &tables));
    }
    tables
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn dense_w8_known_small_prefix() {
        let mut tables: Vec<Box<[u64]>> = Vec::new();
        tables.push(vec![0u64].into_boxed_slice());
        for k in 1..=4 {
            tables.push(build_table(k, &tables));
        }
        assert_eq!(tables[1][0].count_ones(), 1);
        assert_eq!(tables[2].iter().map(|w| w.count_ones()).sum::<u32>(), 1);
        assert_eq!(tables[3].iter().map(|w| w.count_ones()).sum::<u32>(), 5);
        assert_eq!(tables[4].iter().map(|w| w.count_ones()).sum::<u32>(), 41);
    }

    #[test]
    fn direct_w9_matches_scalar_recurrence() {
        let w8 = DenseW8::build();
        for x in 0..10_000u64 {
            let code = x.wrapping_mul(0x9E37_79B9) & ((1u64 << 36) - 1);
            assert_eq!(w8.get9(code), graph_wins(9, code as usize, w8.tables));
        }
    }
}
