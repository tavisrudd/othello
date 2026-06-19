use rayon::prelude::*;
use std::sync::OnceLock;

/// Largest dense layer the `getK` evaluators reach. The complete tables stop at
/// [`W8_K`]; `W9..=W{MAXK}` are evaluators over the layer below (see [`DenseW8::get9`]).
/// 11 is the practical ceiling: the labelled code is `K*(K-1)/2 = 55` bits (fits `u64`),
/// the induced-mask table is `2^K` entries, and `K=12` would need a 66-bit code.
const MAX_DENSE_K: usize = 11;
const W8_K: usize = 8;
/// Widest induced-mask table any layer needs (`2^MAX_DENSE_K`).
const MAX_INDUCED: usize = 1 << MAX_DENSE_K;

/// Per-vertex incident masks and per-alive-subset induced masks for the `k`-vertex
/// upper-triangular edge layout. `incident[i]` selects the code bits of every edge
/// touching vertex `i` (used to recover `adj[i]` via `pext`); `induced[alive]` selects
/// the bits of every edge whose endpoints both lie in `alive` (a `k`-bit subset).
/// Because `pext` preserves bit order, projecting a sub-subset's `induced` mask yields
/// the relabelled subgraph's canonical upper-triangular code directly — the property
/// that lets a `k`-vertex child code feed straight into `W{child_pc}` (table or `getK`).
/// Entries past `k`/`2^k` stay zero (the consts size to `MAX_*` so all layers share a type).
const fn wk_masks(k: usize) -> ([u64; MAX_DENSE_K], [u64; MAX_INDUCED]) {
    let mut incident = [0u64; MAX_DENSE_K];
    let mut induced = [0u64; MAX_INDUCED];
    let mut bit = 0usize;
    let mut i = 0usize;
    while i < k {
        let mut j = i + 1;
        while j < k {
            let edge = 1u64 << bit;
            incident[i] |= edge;
            incident[j] |= edge;
            let mut alive = 0usize;
            while alive < (1usize << k) {
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

const W9_MASKS: ([u64; MAX_DENSE_K], [u64; MAX_INDUCED]) = wk_masks(9);
const W10_MASKS: ([u64; MAX_DENSE_K], [u64; MAX_INDUCED]) = wk_masks(10);
const W11_MASKS: ([u64; MAX_DENSE_K], [u64; MAX_INDUCED]) = wk_masks(11);

/// Recover the `K` adjacency rows from a labelled upper-triangular edge `code`.
/// `incident[i]` packs the edges touching vertex `i` into the low bits via `pext`;
/// re-inserting the self-gap at bit `i` gives `adj[i]` with `adj[i] & (1<<j)` set iff
/// edge `(i,j)` exists. `K` is `const` so the loop unrolls (this is on the hot pc==K path).
#[inline]
fn extract_adj<const K: usize>(code: u64, incident: &[u64; MAX_DENSE_K]) -> [u16; MAX_DENSE_K] {
    use std::arch::x86_64::_pext_u64;
    let mut adj = [0u16; MAX_DENSE_K];
    for i in 0..K {
        // SAFETY: production is built with target-cpu=znver5, which includes BMI2.
        let packed = unsafe { _pext_u64(code, incident[i]) } as u16;
        let below = (1u16 << i) - 1;
        adj[i] = (packed & below) | ((packed & !below) << 1);
    }
    adj
}

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

/// Recursive scalar reference for any `k` (the slow ground truth `getK` is validated
/// against). Bottoms out in the complete `W{≤8}` tables and recurses one ply per layer
/// above, exactly mirroring `W_K(G) = ∃v · ¬W_{K-1}(G∖N[v])` — no `pext`, no mask tables.
#[cfg(test)]
fn wins_rec(k: usize, code: usize, tables: &[Box<[u64]>]) -> bool {
    if k <= W8_K {
        return bit_get(&tables[k], code);
    }
    let adj = adj_from_code(k, code);
    let full = (1u16 << k) - 1;
    for i in 0..k {
        let child = full & !((1u16 << i) | adj[i]);
        let (ck, ccode) = projected_code(&adj, child);
        if !wins_rec(ck, ccode, tables) {
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
    /// there is no W9 allocation, canonicalisation, hash lookup, or join. Every child
    /// drops `1+deg(v)` vertices, so it lands in `W{≤8}` — one table lookup each.
    #[inline]
    pub(crate) fn get9(&self, code: u64) -> bool {
        use std::arch::x86_64::_pext_u64;

        debug_assert!(code < (1u64 << 36));
        let adj = extract_adj::<9>(code, &W9_MASKS.0);
        let full = (1u16 << 9) - 1;
        // `i` is both the removed-vertex bit (`1 << i`) and the `adj[i]` index, so the range
        // loop is the natural form here (not a needless one).
        #[allow(clippy::needless_range_loop)]
        for i in 0..9 {
            let child = full & !((1u16 << i) | adj[i]);
            // SAFETY: same BMI2 build invariant as `extract_adj`. Extracted edges retain
            // upper-triangle order, so the result directly indexes W[popcount].
            let child_code = unsafe { _pext_u64(code, W9_MASKS.1[child as usize]) } as usize;
            if !self.get(child.count_ones() as usize, child_code) {
                return true;
            }
        }
        false
    }

    /// Exact value of one labelled 10-vertex graph (45-bit `code`) — the W10 layer of the
    /// `W_K(G) = ∃v · ¬W_{K-1}(G∖N[v])` hierarchy. A move drops `1+deg(v)` vertices, so a
    /// child has `9-deg(v)` ≤ 9 vertices: an isolated vertex (deg 0) yields a 9-vertex child
    /// resolved by one nested [`get9`], every other child lands in `W{≤8}` (a direct table
    /// lookup). No allocation, no TT traffic, no re-expansion below pc==10.
    #[inline]
    pub(crate) fn get10(&self, code: u64) -> bool {
        use std::arch::x86_64::_pext_u64;

        debug_assert!(code < (1u64 << 45));
        let adj = extract_adj::<10>(code, &W10_MASKS.0);
        let full = (1u16 << 10) - 1;
        #[allow(clippy::needless_range_loop)]
        for i in 0..10 {
            let child = full & !((1u16 << i) | adj[i]);
            let cpc = child.count_ones() as usize;
            // SAFETY: same BMI2 build invariant as `extract_adj`; the projected code is the
            // child's canonical upper-triangular code (pext preserves edge order).
            let child_code = unsafe { _pext_u64(code, W10_MASKS.1[child as usize]) };
            let lost = if cpc == 9 {
                !self.get9(child_code)
            } else {
                !self.get(cpc, child_code as usize)
            };
            if lost {
                return true;
            }
        }
        false
    }

    /// Exact value of one labelled 11-vertex graph (55-bit `code`) — the W11 layer. A child
    /// has `10-deg(v)` ≤ 10 vertices, resolved by a nested [`get10`]/[`get9`] (one ply each)
    /// or a direct `W{≤8}` lookup. The recursion bottoms out in the complete tables, so it is
    /// bounded depth (≤ 2 nested levels) with no allocation, TT traffic, or re-expansion.
    #[inline]
    pub(crate) fn get11(&self, code: u64) -> bool {
        use std::arch::x86_64::_pext_u64;

        debug_assert!(code < (1u64 << 55));
        let adj = extract_adj::<11>(code, &W11_MASKS.0);
        let full = (1u16 << 11) - 1;
        #[allow(clippy::needless_range_loop)]
        for i in 0..11 {
            let child = full & !((1u16 << i) | adj[i]);
            let cpc = child.count_ones() as usize;
            // SAFETY: same BMI2 build invariant as `extract_adj`.
            let child_code = unsafe { _pext_u64(code, W11_MASKS.1[child as usize]) };
            let lost = match cpc {
                10 => !self.get10(child_code),
                9 => !self.get9(child_code),
                _ => !self.get(cpc, child_code as usize),
            };
            if lost {
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
            assert_eq!(w8.get9(code), wins_rec(9, code as usize, w8.tables));
        }
    }

    #[test]
    fn direct_w10_matches_scalar_recurrence() {
        let w8 = DenseW8::build();
        for x in 0..20_000u64 {
            let code = x.wrapping_mul(0x9E37_79B9_7F4A_7C15) & ((1u64 << 45) - 1);
            assert_eq!(
                w8.get10(code),
                wins_rec(10, code as usize, w8.tables),
                "W10 mismatch at code {code:#x}"
            );
        }
    }

    #[test]
    fn direct_w11_matches_scalar_recurrence() {
        let w8 = DenseW8::build();
        for x in 0..20_000u64 {
            let code = x.wrapping_mul(0x9E37_79B9_7F4A_7C15) & ((1u64 << 55) - 1);
            assert_eq!(
                w8.get11(code),
                wins_rec(11, code as usize, w8.tables),
                "W11 mismatch at code {code:#x}"
            );
        }
    }
}
