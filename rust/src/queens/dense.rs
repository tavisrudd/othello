use rayon::prelude::*;
use std::sync::OnceLock;

/// Largest dense layer the `getK` evaluators reach. The complete tables stop at
/// [`W8_K`]; `W9..=W{MAX_DENSE_K}` are evaluators over the layer below (see [`DenseW8::get9`]).
/// W9..W11 keep their labelled code (`K*(K-1)/2` ≤ 55 bits) in a `u64`; W12 (66-bit), W13
/// (78-bit) and W14 (91-bit) run on a `u128` two-word `pext` path. W13/W14 children can be
/// 12/13-vertex (66/78-bit) codes, so their projection uses the `u128`-returning
/// [`pext128_wide`]. K=14 is the `u128` ceiling for the labelled code (91 ≤ 128); K=15 = 105
/// bits still fits, but a 14-vertex child code (91 bits) would need a `pext128`-wide adjacency
/// extract too — out of scope for now.
const MAX_DENSE_K: usize = 14;
const W8_K: usize = 8;
const W12_K: usize = 12;
const W13_K: usize = 13;
const W14_K: usize = 14;
/// `u64`-path induced table size: every W9..W11 child is a `≤11`-bit alive mask.
const MAX_INDUCED: usize = 1 << 11;
/// `u128`-path induced table sizes (W12's alive mask is 12-bit, W13's is 13-bit).
const W12_INDUCED: usize = 1 << W12_K;
const W13_INDUCED: usize = 1 << W13_K;
const W14_INDUCED: usize = 1 << W14_K;

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

/// [`wk_masks`] for the `u128` layers (`k` ≥ 12, code > 64 bits): the incident/induced masks
/// are `u128` and the induced table is `2^k = INDUCED` entries. `incident` is sized to
/// `MAX_DENSE_K` so W12 and W13 share the [`extract_adj128`] signature. Structurally identical
/// to `wk_masks` otherwise.
const fn wk_masks128<const INDUCED: usize>(k: usize) -> ([u128; MAX_DENSE_K], [u128; INDUCED]) {
    let mut incident = [0u128; MAX_DENSE_K];
    let mut induced = [0u128; INDUCED];
    let mut bit = 0usize;
    let mut i = 0usize;
    while i < k {
        let mut j = i + 1;
        while j < k {
            let edge = 1u128 << bit;
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

const W12_MASKS: ([u128; MAX_DENSE_K], [u128; W12_INDUCED]) = wk_masks128::<W12_INDUCED>(W12_K);
const W13_MASKS: ([u128; MAX_DENSE_K], [u128; W13_INDUCED]) = wk_masks128::<W13_INDUCED>(W13_K);
const W14_MASKS: ([u128; MAX_DENSE_K], [u128; W14_INDUCED]) = wk_masks128::<W14_INDUCED>(W14_K);

/// Two-word BMI2 `pext` over a `≤128`-bit `code`/`mask`. The low and high 64-bit halves
/// are extracted independently, then the high half's bits are shifted above the low half's
/// (`pext` preserves order, and the high-word edges hold the higher labelled-code bit
/// positions). Every call site extracts `≤ 55` bits (a `≤11`-vertex child code) or `≤ 11`
/// bits (an adjacency row), so the result fits `u64` and `lo_bits < 64`.
#[inline]
fn pext128(code: u128, mask: u128) -> u64 {
    use std::arch::x86_64::_pext_u64;
    // SAFETY: production is built with target-cpu=znver5, which includes BMI2.
    let lo = unsafe { _pext_u64(code as u64, mask as u64) };
    let hi = unsafe { _pext_u64((code >> 64) as u64, (mask >> 64) as u64) };
    let lo_bits = (mask as u64).count_ones();
    debug_assert!(lo_bits < 64);
    lo | (hi << lo_bits)
}

/// [`pext128`] for a child code that can exceed 64 bits: a 12-vertex child of a 13-vertex
/// node has a 66-bit code. The low half can hold up to 64 selected bits, so `lo_bits` may
/// be 64 and the high half is shifted within the `u128` (no `u64` overflow as in `pext128`).
#[inline]
fn pext128_wide(code: u128, mask: u128) -> u128 {
    use std::arch::x86_64::_pext_u64;
    // SAFETY: production is built with target-cpu=znver5, which includes BMI2.
    let lo = unsafe { _pext_u64(code as u64, mask as u64) } as u128;
    let hi = unsafe { _pext_u64((code >> 64) as u64, (mask >> 64) as u64) } as u128;
    let lo_bits = (mask as u64).count_ones();
    lo | (hi << lo_bits)
}

/// [`extract_adj`] for a `u128` code (W12/W13): same self-gap re-insertion, but the adjacency
/// row (`≤ K-1 ≤ 12` bits, fits `u64`) is recovered with [`pext128`].
#[inline]
fn extract_adj128<const K: usize>(
    code: u128,
    incident: &[u128; MAX_DENSE_K],
) -> [u16; MAX_DENSE_K] {
    let mut adj = [0u16; MAX_DENSE_K];
    for i in 0..K {
        let packed = pext128(code, incident[i]) as u16;
        let below = (1u16 << i) - 1;
        adj[i] = (packed & below) | ((packed & !below) << 1);
    }
    adj
}

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

fn adj_from_code(k: usize, code: u128) -> [u16; MAX_DENSE_K] {
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

fn projected_code(adj: &[u16; MAX_DENSE_K], alive: u16) -> (usize, u128) {
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

    // `u128`: a 12-vertex child (of a 13-vertex node) has a 66-bit code.
    let mut code = 0u128;
    let mut bit = 0usize;
    for x in 0..k {
        let vx = verts[x];
        for &vy in verts.iter().take(k).skip(x + 1) {
            code |= (((adj[vx] >> vy) & 1) as u128) << bit;
            bit += 1;
        }
    }
    (k, code)
}

fn graph_wins(k: usize, code: usize, tables: &[Box<[u64]>]) -> bool {
    let adj = adj_from_code(k, code as u128);
    let full = (1u16 << k) - 1;
    for i in 0..k {
        let child = full & !((1u16 << i) | adj[i]);
        let (ck, ccode) = projected_code(&adj, child);
        // Only reached for `k ≤ 8` (build-time), where the child code is `≤ 21` bits.
        if !bit_get(&tables[ck], ccode as usize) {
            return true;
        }
    }
    false
}

/// Recursive scalar reference for any `k` (the slow ground truth `getK` is validated
/// against). Bottoms out in the complete `W{≤8}` tables and recurses one ply per layer
/// above, exactly mirroring `W_K(G) = ∃v · ¬W_{K-1}(G∖N[v])` — no `pext`, no mask tables.
#[cfg(test)]
fn wins_rec(k: usize, code: u128, tables: &[Box<[u64]>]) -> bool {
    if k <= W8_K {
        return bit_get(&tables[k], code as usize);
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

    /// Exact value of one labelled 12-vertex graph — the W12 layer, the first past the
    /// `u64` code ceiling, so `code` is a 66-bit value in a `u128`. A child has `≤11`
    /// vertices (its code `≤55` bits, fits `u64`), resolved by a nested get11/get10/get9 or
    /// a `W{≤8}` lookup. [`pext128`] does every two-word projection; [`extract_adj128`]
    /// recovers the rows. No allocation, no TT traffic, no re-expansion below pc==12.
    #[inline]
    pub(crate) fn get12(&self, code: u128) -> bool {
        debug_assert!(code < (1u128 << 66));
        let adj = extract_adj128::<12>(code, &W12_MASKS.0);
        let full = (1u16 << 12) - 1;
        #[allow(clippy::needless_range_loop)]
        for i in 0..12 {
            let child = full & !((1u16 << i) | adj[i]);
            let cpc = child.count_ones() as usize;
            let child_code = pext128(code, W12_MASKS.1[child as usize]);
            let lost = match cpc {
                11 => !self.get11(child_code),
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

    /// Exact value of one labelled 13-vertex graph — the W13 layer (78-bit `code` in a
    /// `u128`). A child has `≤12` vertices: a 12-vertex child (isolated removed vertex) has a
    /// 66-bit code resolved by a nested [`get12`] (via [`pext128_wide`]); every smaller child
    /// has a `≤55`-bit code (`u64`) → get11/get10/get9 or a W≤8 lookup. Bounded-depth recursion
    /// into the complete tables, no allocation, no TT traffic, no re-expansion below pc==13.
    #[inline]
    pub(crate) fn get13(&self, code: u128) -> bool {
        debug_assert!(code < (1u128 << 78));
        let adj = extract_adj128::<13>(code, &W13_MASKS.0);
        let full = (1u16 << 13) - 1;
        #[allow(clippy::needless_range_loop)]
        for i in 0..13 {
            let child = full & !((1u16 << i) | adj[i]);
            let cpc = child.count_ones() as usize;
            let child_code = pext128_wide(code, W13_MASKS.1[child as usize]);
            let lost = if cpc == 12 {
                !self.get12(child_code)
            } else {
                // Child has ≤11 vertices ⇒ its code is ≤55 bits, so it fits `u64` losslessly.
                let cc = child_code as u64;
                match cpc {
                    11 => !self.get11(cc),
                    10 => !self.get10(cc),
                    9 => !self.get9(cc),
                    _ => !self.get(cpc, cc as usize),
                }
            };
            if lost {
                return true;
            }
        }
        false
    }

    /// Exact value of one labelled 14-vertex graph — the W14 layer (91-bit `code` in a `u128`,
    /// the `u128` ceiling for the labelled code). A child has `≤13` vertices: a 13-vertex child
    /// (78-bit) → nested [`get13`], a 12-vertex child (66-bit) → [`get12`] (both `>64` bits, via
    /// [`pext128_wide`]); every smaller child has a `≤55`-bit code (`u64`) → get11/get10/get9 or a
    /// W≤8 lookup. Bounded-depth recursion into the complete tables, no allocation, no TT traffic,
    /// no re-expansion below pc==14.
    #[inline]
    pub(crate) fn get14(&self, code: u128) -> bool {
        debug_assert!(code < (1u128 << 91));
        let adj = extract_adj128::<14>(code, &W14_MASKS.0);
        let full = (1u16 << 14) - 1;
        #[allow(clippy::needless_range_loop)]
        for i in 0..14 {
            let child = full & !((1u16 << i) | adj[i]);
            let cpc = child.count_ones() as usize;
            let child_code = pext128_wide(code, W14_MASKS.1[child as usize]);
            let lost = match cpc {
                13 => !self.get13(child_code),
                12 => !self.get12(child_code),
                _ => {
                    // Child has ≤11 vertices ⇒ its code is ≤55 bits, so it fits `u64` losslessly.
                    let cc = child_code as u64;
                    match cpc {
                        11 => !self.get11(cc),
                        10 => !self.get10(cc),
                        9 => !self.get9(cc),
                        _ => !self.get(cpc, cc as usize),
                    }
                }
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
            assert_eq!(w8.get9(code), wins_rec(9, code as u128, w8.tables));
        }
    }

    #[test]
    fn direct_w10_matches_scalar_recurrence() {
        let w8 = DenseW8::build();
        for x in 0..20_000u64 {
            let code = x.wrapping_mul(0x9E37_79B9_7F4A_7C15) & ((1u64 << 45) - 1);
            assert_eq!(
                w8.get10(code),
                wins_rec(10, code as u128, w8.tables),
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
                wins_rec(11, code as u128, w8.tables),
                "W11 mismatch at code {code:#x}"
            );
        }
    }

    #[test]
    fn direct_w12_matches_scalar_recurrence() {
        let w8 = DenseW8::build();
        // Spread x across the full 66-bit code with two independent 64-bit mixes.
        for x in 0..30_000u64 {
            let lo = x.wrapping_mul(0x9E37_79B9_7F4A_7C15);
            let hi = x.wrapping_mul(0xC2B2_AE3D_27D4_EB4F);
            let code = ((lo as u128) | ((hi as u128) << 64)) & ((1u128 << 66) - 1);
            assert_eq!(
                w8.get12(code),
                wins_rec(12, code, w8.tables),
                "W12 mismatch at code {code:#x}"
            );
        }
    }

    #[test]
    fn direct_w13_matches_scalar_recurrence() {
        let w8 = DenseW8::build();
        for x in 0..30_000u64 {
            let lo = x.wrapping_mul(0x9E37_79B9_7F4A_7C15);
            let hi = x.wrapping_mul(0xC2B2_AE3D_27D4_EB4F);
            let code = ((lo as u128) | ((hi as u128) << 64)) & ((1u128 << 78) - 1);
            assert_eq!(
                w8.get13(code),
                wins_rec(13, code, w8.tables),
                "W13 mismatch at code {code:#x}"
            );
        }
    }

    #[test]
    fn direct_w14_matches_scalar_recurrence() {
        let w8 = DenseW8::build();
        for x in 0..30_000u64 {
            let lo = x.wrapping_mul(0x9E37_79B9_7F4A_7C15);
            let hi = x.wrapping_mul(0xC2B2_AE3D_27D4_EB4F);
            let code = ((lo as u128) | ((hi as u128) << 64)) & ((1u128 << 91) - 1);
            assert_eq!(
                w8.get14(code),
                wins_rec(14, code, w8.tables),
                "W14 mismatch at code {code:#x}"
            );
        }
    }
}
