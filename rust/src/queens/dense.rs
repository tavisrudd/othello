use rayon::prelude::*;
use std::sync::OnceLock;

/// Largest dense layer the `getK` evaluators reach. The complete tables stop at
/// [`W8_K`]; `W9..=W{MAX_DENSE_K}` are evaluators over the layer below (see [`DenseW8::get9`]).
/// W9..W11 keep their labelled code (`K*(K-1)/2` ≤ 55 bits) in a `u64`; W12 (66-bit), W13
/// (78-bit), W14 (91-bit), W15 (105-bit) and W16 (120-bit) run on a `u128` two-word `pext`
/// path. W13..W16 children can be 12..15-vertex (66..105-bit) codes, so their projection uses
/// the `u128`-returning [`pext128_wide`]. K=16 is the `u128` ceiling for the labelled code
/// (16·15/2 = 120 ≤ 128); K=17 = 136 bits would need a wider code. The adjacency rows stay
/// `≤15` bits (`u64`), so [`pext128`] still recovers them at every K.
const MAX_DENSE_K: usize = 16;
const W8_K: usize = 8;
const W12_K: usize = 12;
const W13_K: usize = 13;
const W14_K: usize = 14;
const W15_K: usize = 15;
const W16_K: usize = 16;
/// `u64`-path induced table size: every W9..W11 child is a `≤11`-bit alive mask.
const MAX_INDUCED: usize = 1 << 11;
/// `u128`-path induced table sizes (W12's alive mask is 12-bit, W13's is 13-bit).
const W12_INDUCED: usize = 1 << W12_K;
const W13_INDUCED: usize = 1 << W13_K;
const W14_INDUCED: usize = 1 << W14_K;
const W15_INDUCED: usize = 1 << W15_K;
const W16_INDUCED: usize = 1 << W16_K;

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

// The W8 incident/induced masks let the *table build* recover adjacency + project children with
// `pext` (the runtime `get9..` machinery), instead of the scalar `adj_from_code`/`projected_code`
// per code — the k=8 build is 2^28 codes and dominates startup prep.
const W8_MASKS: ([u64; MAX_DENSE_K], [u64; MAX_INDUCED]) = wk_masks(8);
const W9_MASKS: ([u64; MAX_DENSE_K], [u64; MAX_INDUCED]) = wk_masks(9);
const W10_MASKS: ([u64; MAX_DENSE_K], [u64; MAX_INDUCED]) = wk_masks(10);
const W11_MASKS: ([u64; MAX_DENSE_K], [u64; MAX_INDUCED]) = wk_masks(11);

/// [`wk_masks`] for the `u128` layers (`k` ≥ 12, code > 64 bits): the incident/induced masks
/// are `u128` and the induced table is `2^k = INDUCED` entries. `incident` is sized to
/// `MAX_DENSE_K` so all the W≥12 layers share the [`extract_adj128`] signature.
///
/// The induced table is built **incrementally** over subsets in increasing order:
/// `induced[alive] = induced[alive \ {h}] | edges(h, alive \ {h})` where `h` is `alive`'s top
/// vertex — O(2^k · popcount) instead of the naïve O(2^k · k²/2) edge×subset scan. That keeps the
/// const-eval under the `long_running_const_eval` limit up to k=16 (the `u128` ceiling), where the
/// naïve form (7.9 M steps) trips it. Result is identical (`direct_wK_matches_scalar_recurrence`).
const fn wk_masks128<const INDUCED: usize>(k: usize) -> ([u128; MAX_DENSE_K], [u128; INDUCED]) {
    let mut incident = [0u128; MAX_DENSE_K];
    // `ebit[i][j]` (i<j) = the code-bit position of edge (i,j) in the upper-triangular layout.
    let mut ebit = [[0u8; MAX_DENSE_K]; MAX_DENSE_K];
    let mut bit = 0u32;
    let mut i = 0usize;
    while i < k {
        let mut j = i + 1;
        while j < k {
            let edge = 1u128 << bit;
            incident[i] |= edge;
            incident[j] |= edge;
            ebit[i][j] = bit as u8;
            bit += 1;
            j += 1;
        }
        i += 1;
    }
    let mut induced = [0u128; INDUCED];
    let mut alive = 1usize;
    while alive < (1usize << k) {
        let h = (usize::BITS - 1 - alive.leading_zeros()) as usize; // top set vertex
        let without_h = alive & !(1usize << h);
        let mut acc = induced[without_h];
        let mut rest = without_h;
        while rest != 0 {
            let v = rest.trailing_zeros() as usize; // v < h, an edge (v,h)
            rest &= rest - 1;
            acc |= 1u128 << (ebit[v][h] as u32);
        }
        induced[alive] = acc;
        alive += 1;
    }
    (incident, induced)
}

const W12_MASKS: ([u128; MAX_DENSE_K], [u128; W12_INDUCED]) = wk_masks128::<W12_INDUCED>(W12_K);
const W13_MASKS: ([u128; MAX_DENSE_K], [u128; W13_INDUCED]) = wk_masks128::<W13_INDUCED>(W13_K);
const W14_MASKS: ([u128; MAX_DENSE_K], [u128; W14_INDUCED]) = wk_masks128::<W14_INDUCED>(W14_K);
const W15_MASKS: ([u128; MAX_DENSE_K], [u128; W15_INDUCED]) = wk_masks128::<W15_INDUCED>(W15_K);
const W16_MASKS: ([u128; MAX_DENSE_K], [u128; W16_INDUCED]) = wk_masks128::<W16_INDUCED>(W16_K);

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
) -> ([u16; MAX_DENSE_K], u16) {
    let mut adj = [0u16; MAX_DENSE_K];
    let mut iso = 0u16; // bits where adj[i]==0 (isolated vertices) — fused for the pair-strip
    for i in 0..K {
        let packed = pext128(code, incident[i]) as u16;
        let below = (1u16 << i) - 1;
        let a = (packed & below) | ((packed & !below) << 1);
        adj[i] = a;
        iso |= ((a == 0) as u16) << i;
    }
    (adj, iso)
}

/// Recover the `K` adjacency rows from a labelled upper-triangular edge `code`.
/// `incident[i]` packs the edges touching vertex `i` into the low bits via `pext`;
/// re-inserting the self-gap at bit `i` gives `adj[i]` with `adj[i] & (1<<j)` set iff
/// edge `(i,j)` exists. `K` is `const` so the loop unrolls (this is on the hot pc==K path).
#[inline]
fn extract_adj<const K: usize>(
    code: u64,
    incident: &[u64; MAX_DENSE_K],
) -> ([u16; MAX_DENSE_K], u16) {
    use std::arch::x86_64::_pext_u64;
    let mut adj = [0u16; MAX_DENSE_K];
    let mut iso = 0u16; // bits where adj[i]==0 (isolated vertices) — fused for the pair-strip
    for i in 0..K {
        // SAFETY: production is built with target-cpu=znver5, which includes BMI2.
        let packed = unsafe { _pext_u64(code, incident[i]) } as u16;
        let below = (1u16 << i) - 1;
        let a = (packed & below) | ((packed & !below) << 1);
        adj[i] = a;
        iso |= ((a == 0) as u16) << i;
    }
    (adj, iso)
}

/// Isolated-vertex **pair-strip**: a zero-degree vertex is a `K1` component with Grundy value 1
/// (the only move empties it), so any *two* of them cancel in the Sprague-Grundy sum —
/// `g(G ⊔ 2·isolated) = g(G)` — and removing an even number is exactly win/loss-preserving. From
/// the `K` adjacency rows, return `(nrem, keep)` with `nrem` the even count of isolated vertices to
/// drop and `keep` the `K`-bit survivor mask, or `None` if `<2` isolated (no reduction). This
/// collapses the deep "peel one isolated vertex per ply" recursion the `getK` sweep would otherwise
/// do into a single smaller `getK` call (the reduced graph has `≤1` isolated vertex left).
/// MEASURED NET-NEGATIVE, gated off (`const` ⇒ DCE ⇒ production byte-identical to no-strip).
/// The K1 pair-strip fires too rarely to pay: getK peels isolated vertices *one ply at a time*, so a
/// level seldom has ≥2 isolated verts at once to cancel; the `iso_strip` check on every getK call then
/// costs more than the rare firings save (n=16 A/B: +3.4% cyc/node). The common *1-isolated* case needs
/// the core's nimber (`g(core ⊔ {v}) = g(core) XOR 1`), not boolean win/loss — i.e. the parked
/// component-nimber branch. Kept as substrate for that revival / a clique-pair generalisation (K2/K3).
const ISO_STRIP: bool = false;

#[inline]
fn iso_strip<const K: usize>(iso: u16) -> Option<(usize, u16)> {
    if !ISO_STRIP {
        return None; // gated off: inlines to None ⇒ the strip + the fused `iso` in extract_adj DCE.
    }
    let nrem = (iso.count_ones() & !1) as usize; // largest even ≤ count (leave ≤1)
    if nrem < 2 {
        return None;
    }
    let mut removed = 0u16;
    let mut r = iso;
    for _ in 0..nrem {
        let b = r & r.wrapping_neg(); // lowest set bit
        removed |= b;
        r ^= b;
    }
    let full = if K >= 16 { u16::MAX } else { (1u16 << K) - 1 };
    Some((nrem, full & !removed))
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

/// `pext` twin of `graph_wins` specialised to `k == 8` — the dominant build cost (2^28 codes,
/// ~all of startup prep). Recovers adjacency via [`extract_adj`] and projects each child code with
/// one BMI2 `pext` (the same machinery the runtime [`DenseW8::get9`] uses), replacing the scalar
/// `adj_from_code` (28-bit decode) + `projected_code` (per-child nested scan) — ~2× the codes/s.
/// Result is bit-identical to `graph_wins(8, code, _)` (asserted in `graph_wins8_matches_scalar`).
#[inline]
fn graph_wins8(code: u64, tables: &[Box<[u64]>]) -> bool {
    use std::arch::x86_64::_pext_u64;
    let (adj, _) = extract_adj::<8>(code, &W8_MASKS.0);
    let full = (1u16 << 8) - 1;
    // `i` is both the removed-vertex bit (`1 << i`) and the `adj[i]` index, so the range loop
    // is the natural form (mirrors `get9`).
    #[allow(clippy::needless_range_loop)]
    for i in 0..8 {
        let child = full & !((1u16 << i) | adj[i]);
        // SAFETY: target-cpu=znver5 ⇒ BMI2. `induced[child]` (child < 256) selects the
        // sub-graph's edge bits in upper-triangular order, so `pext` yields its canonical code.
        let child_code = unsafe { _pext_u64(code, W8_MASKS.1[child as usize]) } as usize;
        if !bit_get(&tables[child.count_ones() as usize], child_code) {
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
    let full = ((1u32 << k) - 1) as u16; // u16 form; (1u16 << 16) would overflow at k=16
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
                // `k` is loop-invariant so the branch hoists; k==8 (the 2^28-code dominant table)
                // takes the fast `pext` path, the tiny k≤7 tables keep the scalar reference.
                let win = if k == 8 {
                    graph_wins8((base + b) as u64, tables)
                } else {
                    graph_wins(k, base + b, tables)
                };
                if win {
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

    /// Dispatch to the right `getK` for a runtime `k` — used by the isolated-vertex pair-strip's
    /// tail-call (the reduced graph has `≤1` isolated vertex, so the target `getK` won't recurse
    /// here again). `getK` for `k ≤ 11` take a `u64`; the reduced code always fits its layer.
    #[inline]
    fn get_dyn(&self, k: usize, code: u128) -> bool {
        match k {
            16 => self.get16(code),
            15 => self.get15(code),
            14 => self.get14(code),
            13 => self.get13(code),
            12 => self.get12(code),
            11 => self.get11(code as u64),
            10 => self.get10(code as u64),
            9 => self.get9(code as u64),
            _ => self.get(k, code as usize),
        }
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
        let (adj, iso) = extract_adj::<9>(code, &W9_MASKS.0);
        if let Some((nrem, keep)) = iso_strip::<9>(iso) {
            // SAFETY: znver5 ⇒ BMI2. Project onto the isolated-free survivors (pext preserves order).
            let rcode = unsafe { _pext_u64(code, W9_MASKS.1[keep as usize]) };
            return self.get_dyn(9 - nrem, rcode as u128);
        }
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
        let (adj, iso) = extract_adj::<10>(code, &W10_MASKS.0);
        if let Some((nrem, keep)) = iso_strip::<10>(iso) {
            // SAFETY: znver5 ⇒ BMI2. Project onto the isolated-free survivors.
            let rcode = unsafe { _pext_u64(code, W10_MASKS.1[keep as usize]) };
            return self.get_dyn(10 - nrem, rcode as u128);
        }
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
        let (adj, iso) = extract_adj::<11>(code, &W11_MASKS.0);
        if let Some((nrem, keep)) = iso_strip::<11>(iso) {
            // SAFETY: znver5 ⇒ BMI2. Project onto the isolated-free survivors.
            let rcode = unsafe { _pext_u64(code, W11_MASKS.1[keep as usize]) };
            return self.get_dyn(11 - nrem, rcode as u128);
        }
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
        let (adj, iso) = extract_adj128::<12>(code, &W12_MASKS.0);
        if let Some((nrem, keep)) = iso_strip::<12>(iso) {
            return self.get_dyn(12 - nrem, pext128_wide(code, W12_MASKS.1[keep as usize]));
        }
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
        let (adj, iso) = extract_adj128::<13>(code, &W13_MASKS.0);
        if let Some((nrem, keep)) = iso_strip::<13>(iso) {
            return self.get_dyn(13 - nrem, pext128_wide(code, W13_MASKS.1[keep as usize]));
        }
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
        let (adj, iso) = extract_adj128::<14>(code, &W14_MASKS.0);
        if let Some((nrem, keep)) = iso_strip::<14>(iso) {
            return self.get_dyn(14 - nrem, pext128_wide(code, W14_MASKS.1[keep as usize]));
        }
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

    /// Exact value of one labelled 15-vertex graph — the W15 layer (105-bit `code` in a `u128`).
    /// A child has `≤14` vertices: a 14-vertex child (91-bit) → nested [`get14`], a 13-vertex →
    /// [`get13`], a 12-vertex → [`get12`] (all `>64` bits, via [`pext128_wide`]); smaller children
    /// have a `≤55`-bit code (`u64`). Bounded-depth recursion into the complete tables.
    #[inline]
    pub(crate) fn get15(&self, code: u128) -> bool {
        debug_assert!(code < (1u128 << 105));
        let (adj, iso) = extract_adj128::<15>(code, &W15_MASKS.0);
        if let Some((nrem, keep)) = iso_strip::<15>(iso) {
            return self.get_dyn(15 - nrem, pext128_wide(code, W15_MASKS.1[keep as usize]));
        }
        let full = (1u16 << 15) - 1;
        #[allow(clippy::needless_range_loop)]
        for i in 0..15 {
            let child = full & !((1u16 << i) | adj[i]);
            let cpc = child.count_ones() as usize;
            let child_code = pext128_wide(code, W15_MASKS.1[child as usize]);
            let lost = match cpc {
                14 => !self.get14(child_code),
                13 => !self.get13(child_code),
                12 => !self.get12(child_code),
                _ => {
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

    /// Exact value of one labelled 16-vertex graph — the W16 layer (120-bit `code`, the `u128`
    /// ceiling). A child has `≤15` vertices: 15/14/13/12-vertex children (105..66-bit) nest into
    /// [`get15`]/[`get14`]/[`get13`]/[`get12`] via [`pext128_wide`]; smaller children fit `u64`.
    #[inline]
    pub(crate) fn get16(&self, code: u128) -> bool {
        debug_assert!(code < (1u128 << 120));
        let (adj, iso) = extract_adj128::<16>(code, &W16_MASKS.0);
        if let Some((nrem, keep)) = iso_strip::<16>(iso) {
            return self.get_dyn(16 - nrem, pext128_wide(code, W16_MASKS.1[keep as usize]));
        }
        let full = u16::MAX; // all 16 vertices (1u16 << 16 would overflow)
        #[allow(clippy::needless_range_loop)]
        for i in 0..16 {
            let child = full & !((1u16 << i) | adj[i]);
            let cpc = child.count_ones() as usize;
            let child_code = pext128_wide(code, W16_MASKS.1[child as usize]);
            let lost = match cpc {
                15 => !self.get15(child_code),
                14 => !self.get14(child_code),
                13 => !self.get13(child_code),
                12 => !self.get12(child_code),
                _ => {
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
    fn graph_wins8_matches_scalar() {
        // The `pext` k=8 build path must be bit-identical to the scalar reference. Build the
        // tiny k≤7 tables (both paths read them), then compare over a spread of 28-bit codes.
        let mut tables: Vec<Box<[u64]>> = Vec::new();
        tables.push(vec![0u64].into_boxed_slice());
        for k in 1..=7 {
            tables.push(build_table(k, &tables));
        }
        for x in 0..50_000u64 {
            let code = x.wrapping_mul(0x9E37_79B9_7F4A_7C15) & ((1u64 << 28) - 1);
            assert_eq!(
                graph_wins8(code, &tables),
                graph_wins(8, code as usize, &tables),
                "graph_wins8 mismatch at code {code:#x}"
            );
        }
    }

    #[test]
    fn iso_strip_matches_scalar() {
        // The isolated-vertex pair-strip must stay bit-identical to the scalar `wins_rec` ground
        // truth (which has no strip). Random dense codes rarely have ≥2 isolated vertices, so force
        // SPARSE graphs (AND three shifted copies ⇒ ~1/8 edge density ⇒ many isolated vertices),
        // exercising the strip path across the u128 (16/14/12) and u64 (11/9) layers.
        let w8 = DenseW8::build();
        for x in 0..40_000u64 {
            let lo = x.wrapping_mul(0x9E37_79B9_7F4A_7C15);
            let hi = x.wrapping_mul(0xC2B2_AE3D_27D4_EB4F);
            let dense = (lo as u128) | ((hi as u128) << 64);
            let sparse = dense & (dense >> 1) & (dense >> 3); // ~1/8 of edge bits survive
            let c16 = sparse & ((1u128 << 120) - 1);
            assert_eq!(
                w8.get16(c16),
                wins_rec(16, c16, w8.tables),
                "get16 sparse {c16:#x}"
            );
            let c14 = sparse & ((1u128 << 91) - 1);
            assert_eq!(
                w8.get14(c14),
                wins_rec(14, c14, w8.tables),
                "get14 sparse {c14:#x}"
            );
            let c12 = sparse & ((1u128 << 66) - 1);
            assert_eq!(
                w8.get12(c12),
                wins_rec(12, c12, w8.tables),
                "get12 sparse {c12:#x}"
            );
            let c11 = (sparse as u64) & ((1u64 << 55) - 1);
            assert_eq!(
                w8.get11(c11),
                wins_rec(11, c11 as u128, w8.tables),
                "get11 sparse {c11:#x}"
            );
            let c9 = (sparse as u64) & ((1u64 << 36) - 1);
            assert_eq!(
                w8.get9(c9),
                wins_rec(9, c9 as u128, w8.tables),
                "get9 sparse {c9:#x}"
            );
        }
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

    #[test]
    fn direct_w15_matches_scalar_recurrence() {
        let w8 = DenseW8::build();
        for x in 0..30_000u64 {
            let lo = x.wrapping_mul(0x9E37_79B9_7F4A_7C15);
            let hi = x.wrapping_mul(0xC2B2_AE3D_27D4_EB4F);
            let code = ((lo as u128) | ((hi as u128) << 64)) & ((1u128 << 105) - 1);
            assert_eq!(
                w8.get15(code),
                wins_rec(15, code, w8.tables),
                "W15 mismatch at code {code:#x}"
            );
        }
    }

    #[test]
    fn direct_w16_matches_scalar_recurrence() {
        let w8 = DenseW8::build();
        for x in 0..30_000u64 {
            let lo = x.wrapping_mul(0x9E37_79B9_7F4A_7C15);
            let hi = x.wrapping_mul(0xC2B2_AE3D_27D4_EB4F);
            let code = ((lo as u128) | ((hi as u128) << 64)) & ((1u128 << 120) - 1);
            assert_eq!(
                w8.get16(code),
                wins_rec(16, code, w8.tables),
                "W16 mismatch at code {code:#x}"
            );
        }
    }
}
