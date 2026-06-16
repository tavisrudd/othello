//! Step-1 Fermi-check benchmark for the Non-Attacking Queens inner-loop rewrite.
//!
//! Measures **cycles per canonicalisation** for several implementations over a
//! realistic deep-heavy corpus of `available` masks (n=16 layout):
//!
//! * **baseline** — today's `Queens::canon`: a scalar per-set-bit scatter through
//!   a `Vec<u32>` symmetry permutation, lexicographic min over the 8 D4 images.
//! * **A0** — "optimal-structure scalar": the 8 D4 orientation images computed with
//!   word-level SWAR bit transforms (no per-bit scatter, no permutation table),
//!   then a multiword lexicographic min-of-8. Tests whether the *structure* is the win.
//! * **A1** — GFNI (`GF2P8AFFINEQB`) 8×8 block transposes/reflections + an AVX-512
//!   masked multiword min-of-8. The stretch goal.
//! * **A2** — hybrid: SWAR transpose plus GFNI only for in-byte h-flips. This uses
//!   GFNI where the guide says it is naturally strong, without A1's block repack.
//!
//! This bin is **additive only**: it replicates the production geometry (`board`,
//! `attack`, `sym`, `canon`) locally and does NOT touch `queens.rs` or the search.
//!
//! Correctness gate (printed before any timing is meaningful): the kernel must be a
//! perfect D4-invariant. We verify by **partition count** — the number of distinct
//! kernel keys must equal the number of distinct `Queens::canon` values over the
//! corpus. Any exact invariant passes; we need not reproduce the lex-min rep.
//!
//! Build via the Makefile (znver5 + mold): see the `canon-bench` target. Timing is
//! taken under `perf stat -e cycles` divided by (corpus × repeats) — rdtsc is the
//! fixed reference clock on Zen5, NOT core cycles, so we do not use it for cyc/canon.

use std::hint::black_box;
use std::time::Instant;

// ============================================================================
// Board geometry (replicated from queens.rs — n=16, layout square = row*16 + col).
// Bits = [u64;4]; word w holds rows 4w..4w+3 (16 bits each); col = s & 15, row = s >> 4.
// ============================================================================

const N: u32 = 16;

/// 256-bit board. Derived lexicographic order on the words, word 0 MOST significant
/// (matches the production `Bits` Ord/Hash used to pick the canonical representative).
#[derive(Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord, Default, Debug)]
struct Bits([u64; 4]);

impl Bits {
    const ZERO: Bits = Bits([0; 4]);
    #[inline]
    fn set(&mut self, i: u32) {
        self.0[(i / 64) as usize] |= 1u64 << (i % 64);
    }
    #[inline]
    fn get(self, i: u32) -> bool {
        self.0[(i / 64) as usize] & (1u64 << (i % 64)) != 0
    }
    #[inline]
    fn or(self, o: Bits) -> Bits {
        Bits([
            self.0[0] | o.0[0],
            self.0[1] | o.0[1],
            self.0[2] | o.0[2],
            self.0[3] | o.0[3],
        ])
    }
    #[inline]
    fn and_not(self, o: Bits) -> Bits {
        Bits([
            self.0[0] & !o.0[0],
            self.0[1] & !o.0[1],
            self.0[2] & !o.0[2],
            self.0[3] & !o.0[3],
        ])
    }
    #[inline]
    fn popcount(self) -> u32 {
        self.0.iter().map(|w| w.count_ones()).sum()
    }
    #[inline]
    fn each<F: FnMut(u32)>(self, mut f: F) {
        for (k, &w) in self.0.iter().enumerate() {
            let mut w = w;
            while w != 0 {
                let b = w.trailing_zeros();
                f(k as u32 * 64 + b);
                w &= w - 1;
            }
        }
    }
}

#[inline]
fn symmetry(t: usize, r: u32, c: u32, n: u32) -> (u32, u32) {
    let (m1, m2) = (n - 1 - r, n - 1 - c);
    match t {
        0 => (r, c),
        1 => (c, m1),
        2 => (m1, m2),
        3 => (m2, r),
        4 => (r, m2),
        5 => (m1, c),
        6 => (c, r),
        _ => (m2, m1),
    }
}

/// Replica of `Queens` geometry needed for the corpus walk + baseline canon.
struct Geom {
    board: Bits,
    attack: Vec<Bits>,
    order: Vec<u32>,
    sym: Vec<Vec<u32>>,
}

impl Geom {
    fn new(n: u32) -> Self {
        let mut board = Bits::ZERO;
        for s in 0..n * n {
            board.set(s);
        }
        let mut attack = vec![Bits::ZERO; (n * n) as usize];
        for r in 0..n {
            for c in 0..n {
                let mut mask = Bits::ZERO;
                for rr in 0..n {
                    for cc in 0..n {
                        if rr == r
                            || cc == c
                            || rr as i32 - cc as i32 == r as i32 - c as i32
                            || rr + cc == r + c
                        {
                            mask.set(rr * n + cc);
                        }
                    }
                }
                attack[(r * n + c) as usize] = mask;
            }
        }
        let mut order: Vec<u32> = (0..n * n).collect();
        order.sort_by_key(|&s| std::cmp::Reverse(attack[s as usize].popcount()));
        let sym: Vec<Vec<u32>> = (0..8)
            .map(|t| {
                (0..n * n)
                    .map(|s| {
                        let (r2, c2) = symmetry(t, s / n, s % n, n);
                        r2 * n + c2
                    })
                    .collect()
            })
            .collect();
        Geom {
            board,
            attack,
            order,
            sym,
        }
    }

    #[inline]
    fn is_available(&self, blocked: Bits, sq: u32) -> bool {
        self.board.get(sq) && !blocked.get(sq)
    }
    #[inline]
    fn no_moves(&self, blocked: Bits) -> bool {
        self.board.or(blocked) == blocked
    }
    #[inline]
    fn place(&self, blocked: Bits, sq: u32) -> Bits {
        blocked.or(self.attack[sq as usize])
    }

    /// BASELINE — today's `Queens::canon`: scalar per-set-bit scatter, lex min of 8.
    #[inline]
    fn canon(&self, mask: Bits) -> Bits {
        let mut best = mask;
        for t in 1..8 {
            let perm = &self.sym[t];
            let mut img = Bits::ZERO;
            mask.each(|s| img.set(perm[s as usize]));
            if img < best {
                best = img;
            }
        }
        best
    }
}

// ============================================================================
// Corpus: the realistic deep-heavy working set of `available = board & !blocked`
// masks the live search dedups, in the n=16 layout (= production's layout at n=16,
// exactly what the rewrite's kernel operates on).
//
// The live solver is TT-backed: it visits each *distinct* canonical position about
// once. So the representative working set is the set of DISTINCT positions, NOT every
// raw node visit (recording every visit drowns the corpus in the bushy near-leaf
// region of the leftmost subtree). We mimic the TT: a DFS over the real move geometry
// (forcing order, place, is_available, no_moves) that dedups on the canonical key and
// records each newly-seen *raw available* mask once, capped at `cap` distinct positions.
// Recording the RAW (pre-canon) mask — one representative raw orbit member per class —
// is what canon is actually called on per edge in the live search, and gives the
// kernel a realistic mix of orientations to fold (not just canonical reps).
// ============================================================================

struct Walk<'a> {
    g: &'a Geom,
    seen: std::collections::HashSet<Bits>, // dedup by canonical key (the TT key)
    out: Vec<Bits>,                        // raw available masks, one per new class
    cap: usize,
}

impl Walk<'_> {
    fn dfs(&mut self, blocked: Bits) {
        if self.out.len() >= self.cap {
            return;
        }
        let available = self.g.board.and_not(blocked);
        let key = self.g.canon(available);
        if !self.seen.insert(key) {
            return; // transposition — the live TT would prune here
        }
        // Record the raw available mask (the per-edge canon input in the live search).
        self.out.push(available);
        for &sq in &self.g.order {
            if self.out.len() >= self.cap {
                return;
            }
            if !self.g.is_available(blocked, sq) {
                continue;
            }
            let child = self.g.place(blocked, sq);
            if self.g.no_moves(child) {
                continue; // terminal: nothing below to key
            }
            self.dfs(child);
        }
    }
}

fn build_corpus(g: &Geom, cap: usize) -> Vec<Bits> {
    let mut w = Walk {
        g,
        seen: std::collections::HashSet::with_capacity(cap * 2),
        out: Vec::with_capacity(cap),
        cap,
    };
    w.dfs(Bits::ZERO);
    w.out
}

// ============================================================================
// Variant A0 — word-level SWAR D4 transforms + multiword lex-min-of-8.
// All transforms verified offline against the permutation ground truth.
// ============================================================================

/// Reverse the bits within each 16-bit field of `x` (h-flip: reverse cols in 4 rows).
#[inline(always)]
fn rev16(x: u64) -> u64 {
    let x = ((x & 0x00ff_00ff_00ff_00ff) << 8) | ((x >> 8) & 0x00ff_00ff_00ff_00ff);
    let x = ((x & 0x0f0f_0f0f_0f0f_0f0f) << 4) | ((x >> 4) & 0x0f0f_0f0f_0f0f_0f0f);
    let x = ((x & 0x3333_3333_3333_3333) << 2) | ((x >> 2) & 0x3333_3333_3333_3333);
    ((x & 0x5555_5555_5555_5555) << 1) | ((x >> 1) & 0x5555_5555_5555_5555)
}

/// h-flip: reverse columns within each row (independent per word).
#[inline(always)]
fn hflip(w: [u64; 4]) -> [u64; 4] {
    [rev16(w[0]), rev16(w[1]), rev16(w[2]), rev16(w[3])]
}

/// v-flip: reverse the 16 rows. Row r is a 16-bit field at word r/4, offset (r%4)*16.
/// New row index = 15 - r. Word-level: reverse the 4 words, then reverse the four
/// 16-bit fields within each word.
#[inline(always)]
fn vflip(w: [u64; 4]) -> [u64; 4] {
    // Reverse the four 16-bit fields inside a 64-bit word (rows within a word block).
    #[inline(always)]
    fn rev_fields(x: u64) -> u64 {
        // rotate the 16-bit lanes: [a,b,c,d] -> [d,c,b,a]
        let swap32 = x.rotate_right(32);
        // now swap the two 16-bit halves within each 32-bit half
        ((swap32 & 0x0000_ffff_0000_ffff) << 16) | ((swap32 >> 16) & 0x0000_ffff_0000_ffff)
    }
    [
        rev_fields(w[3]),
        rev_fields(w[2]),
        rev_fields(w[1]),
        rev_fields(w[0]),
    ]
}

// 256-bit logical shifts over [u64;4], specialised on a CONST shift amount so they
// fully unroll to branchless shift/or sequences (the generic runtime-`sh` version
// did not unroll and bloated the kernel with branches — that was the first-draft
// measurement artifact). bit i lives in word i/64; index 0 is the low limb.
#[inline(always)]
fn shl256<const SH: u32>(w: [u64; 4]) -> [u64; 4] {
    const { assert!(SH < 256) };
    let word = (SH / 64) as usize;
    let bit = SH % 64;
    let mut r = [0u64; 4];
    let mut i = 3i32;
    while i >= word as i32 {
        let src = i as usize - word;
        let lo = if bit == 0 { w[src] } else { w[src] << bit };
        let hi = if bit != 0 && src >= 1 {
            w[src - 1] >> (64 - bit)
        } else {
            0
        };
        r[i as usize] = lo | hi;
        i -= 1;
    }
    r
}

#[inline(always)]
fn shr256<const SH: u32>(w: [u64; 4]) -> [u64; 4] {
    const { assert!(SH < 256) };
    let word = (SH / 64) as usize;
    let bit = SH % 64;
    let mut r = [0u64; 4];
    let mut i = 0usize;
    while i < 4 - word {
        let src = i + word;
        let lo = if bit == 0 { w[src] } else { w[src] >> bit };
        let hi = if bit != 0 && src + 1 < 4 {
            w[src + 1] << (64 - bit)
        } else {
            0
        };
        r[i] = lo | hi;
        i += 1;
    }
    r
}

#[inline(always)]
fn and4(a: [u64; 4], b: [u64; 4]) -> [u64; 4] {
    [a[0] & b[0], a[1] & b[1], a[2] & b[2], a[3] & b[3]]
}
#[inline(always)]
fn or4(a: [u64; 4], b: [u64; 4]) -> [u64; 4] {
    [a[0] | b[0], a[1] | b[1], a[2] | b[2], a[3] | b[3]]
}
#[inline(always)]
fn andnot4(a: [u64; 4], b: [u64; 4]) -> [u64; 4] {
    // a & !b
    [a[0] & !b[0], a[1] & !b[1], a[2] & !b[2], a[3] & !b[3]]
}

/// 16×16 bit transpose via 4 SWAR delta-swap stages (d = 8,4,2,1; sh = d*15 =
/// 120,60,30,15). Each stage is fully unrolled on a CONST shift so the whole thing is
/// branchless. Mask constants + `mask<<sh` precomputed as constants (the masks are
/// compile-time, so `mask_sh` need not be computed at runtime). Verified offline.
#[inline(always)]
fn transpose(w: [u64; 4]) -> [u64; 4] {
    #[inline(always)]
    fn stage<const SH: u32>(v: [u64; 4], mask: [u64; 4], mask_sh: [u64; 4]) -> [u64; 4] {
        let lo = and4(v, mask);
        let hi = and4(shr256::<SH>(v), mask);
        let keep = andnot4(andnot4(v, mask), mask_sh);
        or4(or4(keep, shl256::<SH>(lo)), hi)
    }
    // mask_sh = mask << sh, precomputed (constant). Derived/checked offline.
    let v = stage::<120>(
        w,
        [0xff00_ff00_ff00_ff00, 0xff00_ff00_ff00_ff00, 0, 0],
        // 0xff00ff00ff00ff00 (words 0,1) << 120  (Python-verified)
        [0, 0, 0x00ff_00ff_00ff_00ff, 0x00ff_00ff_00ff_00ff],
    );
    let v = stage::<60>(
        v,
        [0xf0f0_f0f0_f0f0_f0f0, 0, 0xf0f0_f0f0_f0f0_f0f0, 0],
        // 0xf0f0... (words 0,2) << 60  (Python-verified)
        [0, 0x0f0f_0f0f_0f0f_0f0f, 0, 0x0f0f_0f0f_0f0f_0f0f],
    );
    let v = stage::<30>(
        v,
        [0xcccc_cccc, 0xcccc_cccc, 0xcccc_cccc, 0xcccc_cccc],
        // 0xcccccccc (each word) << 30
        [
            0x3333_3333_0000_0000,
            0x3333_3333_0000_0000,
            0x3333_3333_0000_0000,
            0x3333_3333_0000_0000,
        ],
    );
    stage::<15>(
        v,
        [
            0xaaaa_0000_aaaa,
            0xaaaa_0000_aaaa,
            0xaaaa_0000_aaaa,
            0xaaaa_0000_aaaa,
        ],
        // 0xaaaa0000aaaa (each word) << 15
        [
            0x5555_0000_5555_0000,
            0x5555_0000_5555_0000,
            0x5555_0000_5555_0000,
            0x5555_0000_5555_0000,
        ],
    )
}

/// Compute all 8 D4 orientation images of `mask` with word-level transforms (no
/// scatter, no permutation table). Independent of popcount.
#[inline(always)]
fn d4_images(mask: [u64; 4]) -> [[u64; 4]; 8] {
    // Generators: identity, h-flip, v-flip, transpose.
    // rot180 = hflip(vflip); rot90 = transpose(vflip); rot270 = vflip(transpose);
    // anti = hflip(vflip(transpose)).  (Derivation verified offline.)
    let id = mask;
    let h = hflip(mask);
    let v = vflip(mask);
    let r180 = hflip(v); // = rot180
    let t = transpose(mask);
    let r90 = transpose(v); // (r,c)->(c,15-r)
    let r270 = vflip(t); // (r,c)->(15-c,r)
    let anti = hflip(r270); // (r,c)->(15-c,15-r)
    [id, h, v, r180, t, r90, r270, anti]
}

/// Multiword lexicographic min over 8 four-word candidates. Word 0 is the most-
/// significant limb (matches `Bits` Ord). Branchless-ish scalar arg-min.
#[inline(always)]
fn lex_min8(imgs: &[[u64; 4]; 8]) -> [u64; 4] {
    let mut best = imgs[0];
    for cand in &imgs[1..] {
        // Lexicographic compare on [u64;4], index 0 most significant.
        if lex_lt(*cand, best) {
            best = *cand;
        }
    }
    best
}

#[inline(always)]
fn lex_lt(a: [u64; 4], b: [u64; 4]) -> bool {
    // Compare as a 256-bit big-endian-by-limb number: word 0 first.
    if a[0] != b[0] {
        return a[0] < b[0];
    }
    if a[1] != b[1] {
        return a[1] < b[1];
    }
    if a[2] != b[2] {
        return a[2] < b[2];
    }
    a[3] < b[3]
}

/// A0 kernel: 8 word-level images, lex-min-of-8, fold to a 64-bit hash key.
#[inline(always)]
fn a0_key(mask: Bits) -> u64 {
    let imgs = d4_images(mask.0);
    let m = lex_min8(&imgs);
    hash4(m)
}

/// A0 canonical Bits (for the invariant cross-check vs baseline canon classes).
#[inline(always)]
fn a0_canon(mask: Bits) -> Bits {
    Bits(lex_min8(&d4_images(mask.0)))
}

/// Cheap 4-word mix → 64-bit key (consumed by black_box; partition uses full Bits).
#[inline(always)]
fn hash4(m: [u64; 4]) -> u64 {
    let mut h = 0xcbf2_9ce4_8422_2325u64;
    for w in m {
        h = (h ^ w).wrapping_mul(0x1000_0000_01b3);
    }
    h
}

// ============================================================================
// Variant A1 — GFNI 8×8 block transposes/reflections + AVX-512 masked min-of-8.
// Built only if A0 is correct (gated in main). x86_64 + avx512 + gfni required.
// ============================================================================

#[cfg(target_arch = "x86_64")]
mod a1 {
    use super::Bits;
    #[cfg(target_arch = "x86_64")]
    use std::arch::x86_64::*;

    // What A1 tests: the full GFNI design — GFNI 16×16 **transpose** + GFNI **h-flip**
    // (per-byte bit-reverse) + AVX-512 masked multiword **min-of-8** (`lex_min8_avx`).
    //
    // GFNI mechanics (Intel GFNI Tech Guide 644497, confirmed empirically on this CPU):
    // `GF2P8AFFINEQB(x, A)` computes, per output byte i, out_byte = A·in_byte over GF(2)
    // — so it bit-permutes WITHIN a byte (matrix 0x0102040810204080 = per-byte identity,
    // 0x8040201008040201 = per-byte bit-reverse). The guide's matrix↔column duality
    // (§2.4) gives the 8×8 bit TRANSPOSE: feed the 8×8 block as the *matrix* operand and
    // the identity as the *data*, then per-byte bit-reverse the result:
    //   transpose8(block) = revbyte( affine(data = 0x8040201008040201, matrix = block) ).
    // A 16×16 board = a 2×2 grid of 8×8 blocks; transpose all four blocks in one
    // `_mm256` affine (per-64-bit-lane), then swap the two off-diagonal blocks. The
    // repack [u64;4]↔block-lanes is scalar (the cost A1 must overcome).

    /// GFNI per-byte bit-reverse matrix (empirically confirmed on this CPU).
    const REV_BYTE: i64 = 0x8040_2010_0804_0201u64 as i64;

    /// Full 16×16 GFNI bit transpose. Verified at runtime against the SWAR transpose.
    #[target_feature(enable = "avx512f,avx512bw,avx512vl,avx512dq,gfni")]
    #[inline]
    unsafe fn transpose16_gfni(w: [u64; 4]) -> [u64; 4] {
        // Repack into 4 lanes, each an 8×8 block (byte = block-row, bit = block-col):
        //   A = rows0-7 cols0-7, B = rows0-7 cols8-15, C = rows8-15 cols0-7, D = rest.
        let (mut ab, mut bb, mut cb, mut db) = ([0u8; 8], [0u8; 8], [0u8; 8], [0u8; 8]);
        for r in 0..16usize {
            let row = ((w[r / 4] >> ((r % 4) * 16)) & 0xffff) as u16;
            let (lo, hi) = ((row & 0xff) as u8, (row >> 8) as u8);
            if r < 8 {
                ab[r] = lo;
                bb[r] = hi;
            } else {
                cb[r - 8] = lo;
                db[r - 8] = hi;
            }
        }
        let blk = [
            u64::from_le_bytes(ab),
            u64::from_le_bytes(bb),
            u64::from_le_bytes(cb),
            u64::from_le_bytes(db),
        ];
        let v = _mm256_loadu_si256(blk.as_ptr() as *const __m256i);
        // transpose8 each block: revbyte(affine(data=identity, matrix=block))
        let idmat = _mm256_set1_epi64x(REV_BYTE);
        let t1 = _mm256_gf2p8affine_epi64_epi8::<0>(idmat, v);
        let t2 = _mm256_gf2p8affine_epi64_epi8::<0>(t1, _mm256_set1_epi64x(REV_BYTE));
        let mut bt = [0u64; 4];
        _mm256_storeu_si256(bt.as_mut_ptr() as *mut __m256i, t2);
        // 16×16 transpose = [[A^T, C^T],[B^T, D^T]] (swap off-diagonal blocks).
        let (atb, btb, ctb, dtb) = (
            bt[0].to_le_bytes(),
            bt[1].to_le_bytes(),
            bt[2].to_le_bytes(),
            bt[3].to_le_bytes(),
        );
        let mut out = [0u64; 4];
        for r in 0..16usize {
            let (lo, hi) = if r < 8 {
                (atb[r], ctb[r])
            } else {
                (btb[r - 8], dtb[r - 8])
            };
            let row = (lo as u16) | ((hi as u16) << 8);
            out[r / 4] |= (row as u64) << ((r % 4) * 16);
        }
        out
    }

    /// h-flip (reverse columns within each 16-bit row) via GFNI: per-byte bit-reverse
    /// (one `vgf2p8affineqb` over the 256-bit board) then swap the two bytes of each
    /// 16-bit row field. Verified at runtime against the SWAR h-flip in the gate.
    #[target_feature(enable = "avx512f,avx512bw,avx512vl,avx512dq,gfni")]
    #[inline]
    unsafe fn hflip_gfni(w: [u64; 4]) -> [u64; 4] {
        let v = _mm256_loadu_si256(w.as_ptr() as *const __m256i);
        // per-byte bit reverse
        let rev = _mm256_gf2p8affine_epi64_epi8::<0>(v, _mm256_set1_epi64x(REV_BYTE));
        let mut tmp = [0u64; 4];
        _mm256_storeu_si256(tmp.as_mut_ptr() as *mut __m256i, rev);
        // swap the two bytes within each 16-bit lane: (x<<8 | x>>8) masked per byte.
        // After per-byte bit-reverse, bit c of a row went to bit (15-c) within its
        // byte but stayed in the same byte; the 16-bit field reverse needs the two
        // bytes swapped so col 0..7 <-> 8..15. Do it with a rotate of 8 within 16.
        for x in &mut tmp {
            let lo = (*x & 0x00ff_00ff_00ff_00ff) << 8;
            let hi = (*x >> 8) & 0x00ff_00ff_00ff_00ff;
            *x = lo | hi;
        }
        tmp
    }

    /// All 8 D4 images: GFNI h-flip + GFNI 16×16 transpose + SWAR v-flip.
    #[target_feature(enable = "avx512f,avx512bw,avx512vl,avx512dq,gfni")]
    #[inline]
    pub unsafe fn d4_images_gfni(mask: [u64; 4]) -> [[u64; 4]; 8] {
        let id = mask;
        let h = hflip_gfni(mask);
        let v = super::vflip(mask);
        let r180 = hflip_gfni(v);
        let t = transpose16_gfni(mask);
        let r90 = transpose16_gfni(v);
        let r270 = super::vflip(t);
        let anti = hflip_gfni(r270);
        [id, h, v, r180, t, r90, r270, anti]
    }

    /// AVX-512 multiword lexicographic min-of-8 over the 8 four-word images.
    ///
    /// Word 0 is the most-significant limb. Strategy: build 8 lanes of word0, reduce
    /// to the min (vpminuq tree), mask candidates whose word0 == min, then among the
    /// survivors reduce word1, etc. We use scalar masking with AVX-512 k-regs.
    #[target_feature(enable = "avx512f,avx512bw,avx512vl,avx512dq,gfni")]
    #[inline]
    pub unsafe fn lex_min8_avx(imgs: &[[u64; 4]; 8]) -> [u64; 4] {
        // Gather word j of all 8 candidates into a zmm, reduce min, narrow the
        // surviving set by an equality mask per limb.
        let w0 = _mm512_set_epi64(
            imgs[7][0] as i64,
            imgs[6][0] as i64,
            imgs[5][0] as i64,
            imgs[4][0] as i64,
            imgs[3][0] as i64,
            imgs[2][0] as i64,
            imgs[1][0] as i64,
            imgs[0][0] as i64,
        );
        let min0 = _mm512_reduce_min_epu64(w0) as u64;
        let mut alive = _mm512_cmpeq_epu64_mask(w0, _mm512_set1_epi64(min0 as i64));
        // limb 1
        let w1 = _mm512_set_epi64(
            imgs[7][1] as i64,
            imgs[6][1] as i64,
            imgs[5][1] as i64,
            imgs[4][1] as i64,
            imgs[3][1] as i64,
            imgs[2][1] as i64,
            imgs[1][1] as i64,
            imgs[0][1] as i64,
        );
        let big = _mm512_set1_epi64(-1i64);
        let m1v = _mm512_mask_blend_epi64(alive, big, w1);
        let min1 = _mm512_reduce_min_epu64(m1v) as u64;
        alive &= _mm512_cmpeq_epu64_mask(w1, _mm512_set1_epi64(min1 as i64));
        // limb 2
        let w2 = _mm512_set_epi64(
            imgs[7][2] as i64,
            imgs[6][2] as i64,
            imgs[5][2] as i64,
            imgs[4][2] as i64,
            imgs[3][2] as i64,
            imgs[2][2] as i64,
            imgs[1][2] as i64,
            imgs[0][2] as i64,
        );
        let m2v = _mm512_mask_blend_epi64(alive, big, w2);
        let min2 = _mm512_reduce_min_epu64(m2v) as u64;
        alive &= _mm512_cmpeq_epu64_mask(w2, _mm512_set1_epi64(min2 as i64));
        // limb 3
        let w3 = _mm512_set_epi64(
            imgs[7][3] as i64,
            imgs[6][3] as i64,
            imgs[5][3] as i64,
            imgs[4][3] as i64,
            imgs[3][3] as i64,
            imgs[2][3] as i64,
            imgs[1][3] as i64,
            imgs[0][3] as i64,
        );
        let m3v = _mm512_mask_blend_epi64(alive, big, w3);
        let min3 = _mm512_reduce_min_epu64(m3v) as u64;
        [min0, min1, min2, min3]
    }

    #[target_feature(enable = "avx512f,avx512bw,avx512vl,avx512dq,gfni")]
    #[inline]
    pub unsafe fn a1_key(mask: Bits) -> u64 {
        let imgs = d4_images_gfni(mask.0);
        let m = lex_min8_avx(&imgs);
        super::hash4(m)
    }

    #[target_feature(enable = "avx512f,avx512bw,avx512vl,avx512dq,gfni")]
    #[inline]
    pub unsafe fn a1_canon(mask: Bits) -> Bits {
        Bits(lex_min8_avx(&d4_images_gfni(mask.0)))
    }

    /// Hybrid: keep the SWAR transpose, but use GFNI for the two h-flips that are
    /// not already derivable by a cheap vertical flip.
    #[target_feature(enable = "avx512f,avx512bw,avx512vl,avx512dq,gfni")]
    #[inline]
    pub unsafe fn d4_images_hybrid(mask: [u64; 4]) -> [[u64; 4]; 8] {
        let id = mask;
        let h = hflip_gfni(mask);
        let v = super::vflip(mask);
        let r180 = super::vflip(h);
        let t = super::transpose(mask);
        let r90 = hflip_gfni(t);
        let r270 = super::vflip(t);
        let anti = super::vflip(r90);
        [id, h, v, r180, t, r90, r270, anti]
    }

    #[target_feature(enable = "avx512f,avx512bw,avx512vl,avx512dq,gfni")]
    #[inline]
    pub unsafe fn a2_key(mask: Bits) -> u64 {
        let imgs = d4_images_hybrid(mask.0);
        let m = super::lex_min8(&imgs);
        super::hash4(m)
    }

    #[target_feature(enable = "avx512f,avx512bw,avx512vl,avx512dq,gfni")]
    #[inline]
    pub unsafe fn a2_canon(mask: Bits) -> Bits {
        Bits(super::lex_min8(&d4_images_hybrid(mask.0)))
    }

    /// A3 incremental kernel: carry the 8 orientations live, apply ONE move by and-not-ing
    /// each with that move's per-orientation attack mask (`att[t*NN + m]`), then AVX
    /// lex-min + hash. No per-node image recompute — the per-edge cost the floor predicts
    /// is the real lever *below* the recompute kernels (A0–A2). Uses the branchless AVX
    /// min, the shared floor of every variant.
    #[target_feature(enable = "avx512f,avx512bw,avx512vl,avx512dq,gfni")]
    #[inline]
    pub unsafe fn a3_key(o0: &[[u64; 4]; 8], att: &[[u64; 4]], m: usize) -> u64 {
        let mut o = [[0u64; 4]; 8];
        for t in 0..8 {
            o[t] = super::andnot4(o0[t], att[t * super::NN + m]);
        }
        // Scalar lex-min, not lex_min8_avx: the AVX min's 8-lane gather is a measured
        // LOSS here (A1 is the slowest recompute kernel for exactly this reason).
        super::hash4(super::lex_min8(&o))
    }
}

// ============================================================================
// Correctness gate + timing harness
// ============================================================================

fn distinct_count<T: Ord + Copy>(xs: impl Iterator<Item = T>) -> usize {
    let mut v: Vec<T> = xs.collect();
    v.sort_unstable();
    v.dedup();
    v.len()
}

/// Returns true if `keyfn` induces exactly the same partition as `canonfn` over the
/// corpus (the perfect-D4-invariant gate). Also returns (distinct_keys, distinct_canon).
fn invariant_gate(corpus: &[Bits], g: &Geom, keyfn: impl Fn(Bits) -> Bits) -> (bool, usize, usize) {
    let distinct_canon = distinct_count(corpus.iter().map(|&m| g.canon(m)));
    let distinct_key = distinct_count(corpus.iter().map(|&m| keyfn(m)));
    // Partition-count equality is the gate the spec asks for. But equal counts with a
    // mismatched partition is possible in principle; we additionally check that the
    // key partition *refines consistently* by verifying per-class agreement: two masks
    // share a canon class iff they share a key class. We do this by comparing the
    // multiset of (canon, key) pairs — the number of distinct pairs must equal both
    // counts (a bijection between the two partitions).
    let distinct_pairs = distinct_count(corpus.iter().map(|&m| (g.canon(m), keyfn(m))));
    let perfect = distinct_key == distinct_canon && distinct_pairs == distinct_canon;
    (perfect, distinct_key, distinct_canon)
}

/// The raw image of `mask` under production symmetry `t` (independent of the kernel —
/// uses the `sym` permutation, the baseline path). For the merge-stress gate.
fn raw_image(g: &Geom, mask: Bits, t: usize) -> Bits {
    let perm = &g.sym[t];
    let mut img = Bits::ZERO;
    mask.each(|s| img.set(perm[s as usize]));
    img
}

/// Merge-stress gate: build an orbit-augmented corpus where every mask appears with
/// ALL 8 of its raw D4 orientations, so D4-equivalent (but non-identical) raw masks are
/// present and MUST collapse to one class. Confirms the kernel merges exactly as
/// `canon` does — `distinct_key == distinct_canon == distinct_pairs` on the augmented
/// set. Returns (perfect, distinct_key, distinct_canon, augmented_len).
fn merge_stress_gate(
    corpus: &[Bits],
    g: &Geom,
    keyfn: impl Fn(Bits) -> Bits,
) -> (bool, usize, usize, usize) {
    // Cap the augmentation work: sample up to 500k base masks, expand each ×8.
    let sample = corpus.len().min(500_000);
    let mut aug: Vec<Bits> = Vec::with_capacity(sample * 8);
    for &m in &corpus[..sample] {
        for t in 0..8 {
            aug.push(raw_image(g, m, t));
        }
    }
    let dc = distinct_count(aug.iter().map(|&m| g.canon(m)));
    let dk = distinct_count(aug.iter().map(|&m| keyfn(m)));
    let dp = distinct_count(aug.iter().map(|&m| (g.canon(m), keyfn(m))));
    (dk == dc && dp == dc, dk, dc, aug.len())
}

// ============================================================================
// A3 — incremental-orientation model (the path the floor predicts past the recompute
// kernels). The integrated search never recomputes the 8 images: it carries them live
// and, per move, and-nots each with the move's per-orientation attack mask. The per-edge
// cost collapses to 8×and-not + lex-min + hash. A3 measures exactly that, isolated, so we
// know the incremental floor BEFORE the Step-3 rewrite commits to it.
// ============================================================================

const NN: usize = (N * N) as usize;

/// Per-orientation attack table: `att[t*NN + s]` = perm_t(attack[s]) — the move's attack
/// mask in orientation t's frame. 8*256*32 B = 64 KB (L1/L2-resident). Built offline.
fn build_att(g: &Geom) -> Vec<[u64; 4]> {
    let mut att = vec![[0u64; 4]; 8 * NN];
    for t in 0..8 {
        for (s, &atk) in g.attack.iter().enumerate() {
            att[t * NN + s] = raw_image(g, atk, t).0;
        }
    }
    att
}

/// The 8 live orientations of `available`: `orient[t]` = perm_t(available).
fn orient0_of(g: &Geom, available: Bits) -> [[u64; 4]; 8] {
    std::array::from_fn(|t| raw_image(g, available, t).0)
}

/// The representative DFS move from `available`: its lowest-index available square.
fn first_sq(available: Bits) -> Option<u32> {
    for (k, &w) in available.0.iter().enumerate() {
        if w != 0 {
            return Some(k as u32 * 64 + w.trailing_zeros());
        }
    }
    None
}

/// A3 incremental canon (scalar min, for the gate): the 8 live orientations of `available`
/// and-not the first move's per-orientation attack, lex-min. Equals canon(available &
/// !attack[m]) — the canon of the CHILD position the incremental search keys per edge.
fn a3_canon(g: &Geom, att: &[[u64; 4]], available: Bits) -> Option<Bits> {
    let m = first_sq(available)? as usize;
    let o0 = orient0_of(g, available);
    let o: [[u64; 4]; 8] = std::array::from_fn(|t| andnot4(o0[t], att[t * NN + m]));
    Some(Bits(lex_min8(&o)))
}

/// A3 gate: the incremental child-canon must equal the direct canon of the child for
/// every corpus position (the incremental per-edge update is exact ⇒ a perfect invariant
/// by the same argument as A0–A2: perm_t distributes over `&`/`!`).
fn a3_gate(corpus: &[Bits], g: &Geom, att: &[[u64; 4]]) -> (bool, usize, usize) {
    let mut matched = 0usize;
    let mut total = 0usize;
    for &available in corpus {
        let Some(m) = first_sq(available) else {
            continue;
        };
        total += 1;
        let child = available.and_not(g.attack[m as usize]);
        if a3_canon(g, att, available) == Some(g.canon(child)) {
            matched += 1;
        }
    }
    (matched == total, matched, total)
}

/// Time A3 over a cache-resident working set of (orientations, move) pairs, so the loop
/// measures the incremental COMPUTE (8×and-not + AVX lex-min + hash + the L1/L2 att
/// loads), not the bandwidth of streaming orientations — faithful to the DFS, where the
/// parent's orientations are register/L1-resident. canons = pairs * reps. (Upper bound:
/// the real search keeps `o0` in registers; here it is reloaded, so the integrated cost
/// is ≤ this.)
fn time_a3(att: &[[u64; 4]], orients: &[[[u64; 4]; 8]], moves: &[u32], reps: usize) -> (u128, u64) {
    let t = Instant::now();
    let mut acc: u64 = 0;
    for _ in 0..reps {
        for (o0, &m) in orients.iter().zip(moves) {
            let o0 = black_box(o0);
            acc = acc.wrapping_add(unsafe { a1::a3_key(o0, att, m as usize) });
        }
    }
    black_box(acc);
    (t.elapsed().as_nanos(), acc)
}

/// Time a key function over the corpus, `reps` passes, black_box the accumulator.
/// Returns (ns_total, accumulator).
fn time_keys(corpus: &[Bits], reps: usize, keyfn: impl Fn(Bits) -> u64) -> (u128, u64) {
    let t = Instant::now();
    let mut acc: u64 = 0;
    for _ in 0..reps {
        for &m in corpus {
            acc = acc.wrapping_add(keyfn(black_box(m)));
        }
    }
    black_box(acc);
    (t.elapsed().as_nanos(), acc)
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    // Usage: canon_bench [cap] [reps] [mode]
    //   cap  = max corpus masks (default 4_000_000)
    //   reps = timing passes over corpus (default 8)
    //   mode = "verify" (gate + 1 pass each, fast) | "bench" (default, timed loop)
    //          | "perf:baseline" | "perf:a0" | "perf:a1" | "perf:a2" | "perf:a3"
    //            (single impl, for perf stat; a3 = incremental model)
    let cap: usize = args
        .get(1)
        .and_then(|s| s.parse().ok())
        .unwrap_or(4_000_000);
    let reps: usize = args.get(2).and_then(|s| s.parse().ok()).unwrap_or(8);
    let mode = args.get(3).map(String::as_str).unwrap_or("bench");

    eprintln!("building corpus (n={N}, cap={cap}) ...");
    let g = Geom::new(N);
    let corpus = build_corpus(&g, cap);
    let popsum: u64 = corpus.iter().map(|m| m.popcount() as u64).sum();
    eprintln!(
        "corpus: {} distinct positions (raw available masks), mean popcount {:.2}",
        corpus.len(),
        popsum as f64 / corpus.len() as f64
    );
    // Popcount histogram (deep-heavy shape sanity): bucket by available bit count.
    let mut hist = [0u64; 17];
    for m in &corpus {
        let p = m.popcount().min(16) as usize;
        hist[p] += 1;
    }
    eprint!("popcount buckets (0..=15, 16+): ");
    for (p, &c) in hist.iter().enumerate() {
        if c > 0 {
            eprint!("{p}:{} ", c);
        }
    }
    eprintln!();

    // A3 incremental-model data: the per-orientation attack table + a cache-resident
    // working set of (orientations, first-move) pairs. Built in EVERY mode (and anchored
    // with black_box) so the perf:build cycle subtraction stays consistent across impls.
    let att = build_att(&g);
    let cap_a3 = corpus.len().min(1 << 14);
    let mut a3_orients: Vec<[[u64; 4]; 8]> = Vec::with_capacity(cap_a3);
    let mut a3_moves: Vec<u32> = Vec::with_capacity(cap_a3);
    for &available in &corpus[..cap_a3] {
        if let Some(m) = first_sq(available) {
            a3_orients.push(orient0_of(&g, available));
            a3_moves.push(m);
        }
    }
    black_box((&att, &a3_orients, &a3_moves));

    // --- perf-stat single-impl modes: just run the timed loop, nothing else. ---
    let a1_ok = is_x86_feature_detected!("gfni")
        && is_x86_feature_detected!("avx512f")
        && is_x86_feature_detected!("avx512bw")
        && is_x86_feature_detected!("avx512vl")
        && is_x86_feature_detected!("avx512dq");
    match mode {
        "perf:baseline" => {
            let (_, acc) = time_keys(&corpus, reps, |m| {
                let c = g.canon(m);
                hash4(c.0)
            });
            eprintln!("baseline acc={acc} canons={}", corpus.len() * reps);
            return;
        }
        "perf:build" => {
            // Build only (no timing loop): the cycle floor to SUBTRACT from each impl's
            // perf-stat run, isolating the loop. black_box so the build isn't elided.
            black_box(&corpus);
            eprintln!("build-only (subtract this cycle count) canons=0");
            return;
        }
        "perf:empty" => {
            // Loop + black_box overhead only (trivial keyfn): subtract from each impl to
            // isolate pure kernel cost from per-iteration harness overhead.
            let (_, acc) = time_keys(&corpus, reps, |m| m.0[0]);
            eprintln!("empty acc={acc} canons={}", corpus.len() * reps);
            return;
        }
        "perf:a0" => {
            let (_, acc) = time_keys(&corpus, reps, a0_key);
            eprintln!("a0 acc={acc} canons={}", corpus.len() * reps);
            return;
        }
        "perf:a1" => {
            if !a1_ok {
                eprintln!("a1 unavailable (missing CPU features)");
                return;
            }
            let (_, acc) = time_keys(&corpus, reps, |m| unsafe { a1::a1_key(m) });
            eprintln!("a1 acc={acc} canons={}", corpus.len() * reps);
            return;
        }
        "perf:a2" => {
            if !a1_ok {
                eprintln!("a2 unavailable (missing CPU features)");
                return;
            }
            let (_, acc) = time_keys(&corpus, reps, |m| unsafe { a1::a2_key(m) });
            eprintln!("a2 acc={acc} canons={}", corpus.len() * reps);
            return;
        }
        "perf:a3" => {
            if !a1_ok || a3_orients.is_empty() {
                eprintln!("a3 unavailable (missing CPU features or empty working set)");
                return;
            }
            let (_, acc) = time_a3(&att, &a3_orients, &a3_moves, reps);
            eprintln!("a3 acc={acc} canons={}", a3_orients.len() * reps);
            return;
        }
        _ => {}
    }

    // --- correctness gate (before timing means anything) ---
    println!("\n=== CORRECTNESS GATE (perfect D4-invariant via partition count) ===");
    let (a0_perfect, a0_keys, canon_classes) = invariant_gate(&corpus, &g, a0_canon);
    println!(
        "A0:  distinct kernel keys = {:>10}   distinct canon = {:>10}   perfect = {}",
        a0_keys, canon_classes, a0_perfect
    );
    let (a1_perfect, a2_perfect) = if a1_ok {
        let (p, a1_keys, cc) = invariant_gate(&corpus, &g, |m| unsafe { a1::a1_canon(m) });
        println!(
            "A1:  distinct kernel keys = {:>10}   distinct canon = {:>10}   perfect = {}",
            a1_keys, cc, p
        );
        let (a2_p, a2_keys, a2_cc) = invariant_gate(&corpus, &g, |m| unsafe { a1::a2_canon(m) });
        println!(
            "A2:  distinct kernel keys = {:>10}   distinct canon = {:>10}   perfect = {}",
            a2_keys, a2_cc, a2_p
        );
        (p, a2_p)
    } else {
        println!("A1:  skipped (CPU features missing)");
        println!("A2:  skipped (CPU features missing)");
        (false, false)
    };
    // A3 is the incremental child-canon: gate it by exact agreement with the direct canon
    // of the child position (not a partition count — it canonicalises the NEXT position).
    let a3_perfect = if a1_ok && !a3_orients.is_empty() {
        let (p, matched, total) = a3_gate(&corpus, &g, &att);
        println!("A3:  incremental child-canon matched {matched} / {total}   exact = {p}");
        p
    } else {
        println!("A3:  skipped (CPU features missing)");
        false
    };

    // Merge-stress: orbit-augment (each mask × all 8 raw D4 images) so D4-equivalent
    // raw masks are present and MUST collapse identically under canon and the kernel.
    println!("\n--- merge-stress gate (orbit-augmented: every mask × 8 raw orientations) ---");
    let (a0_ms, a0_dk, a0_dc, aug_len) = merge_stress_gate(&corpus, &g, a0_canon);
    println!(
        "A0:  augmented set = {:>10}   distinct keys = {:>9}   distinct canon = {:>9}   merges-match = {}",
        aug_len, a0_dk, a0_dc, a0_ms
    );
    if a1_ok {
        let (a1_ms, a1_dk, a1_dc, _) =
            merge_stress_gate(&corpus, &g, |m| unsafe { a1::a1_canon(m) });
        println!(
            "A1:  augmented set = {:>10}   distinct keys = {:>9}   distinct canon = {:>9}   merges-match = {}",
            aug_len, a1_dk, a1_dc, a1_ms
        );
        let (a2_ms, a2_dk, a2_dc, _) =
            merge_stress_gate(&corpus, &g, |m| unsafe { a1::a2_canon(m) });
        println!(
            "A2:  augmented set = {:>10}   distinct keys = {:>9}   distinct canon = {:>9}   merges-match = {}",
            aug_len, a2_dk, a2_dc, a2_ms
        );
    }

    if !a0_perfect {
        println!("\nA0 is NOT a perfect invariant — timing is meaningless. Fix the kernel.");
        return;
    }
    if a1_ok && !a2_perfect {
        println!("\nA2 is NOT a perfect invariant — timing is meaningless. Fix the kernel.");
        return;
    }
    if a1_ok && !a3_orients.is_empty() && !a3_perfect {
        println!("\nA3 incremental update is NOT exact — its model is wrong; timing meaningless.");
        return;
    }
    if mode == "verify" {
        println!("\nverify mode: gate done, skipping timing.");
        return;
    }

    // --- timing (wall-clock ns/canon; perf stat gives the authoritative cyc/canon) ---
    println!("\n=== TIMING ({} masks × {} reps) ===", corpus.len(), reps);
    let n_canon = (corpus.len() * reps) as f64;

    let (ns_base, _) = time_keys(&corpus, reps, |m| {
        let c = g.canon(m);
        hash4(c.0)
    });
    let (ns_a0, _) = time_keys(&corpus, reps, a0_key);
    let ns_a1 = if a1_perfect {
        Some(time_keys(&corpus, reps, |m| unsafe { a1::a1_key(m) }).0)
    } else {
        None
    };
    let ns_a2 = if a2_perfect {
        Some(time_keys(&corpus, reps, |m| unsafe { a1::a2_key(m) }).0)
    } else {
        None
    };
    let ns_a3 = if a1_ok && !a3_orients.is_empty() {
        Some(time_a3(&att, &a3_orients, &a3_moves, reps).0)
    } else {
        None
    };

    let per = |ns: u128| ns as f64 / n_canon;
    println!("{:<10} {:>12} {:>10}", "impl", "ns/canon", "speedup");
    let base_ns = per(ns_base);
    println!("{:<10} {:>12.3} {:>10}", "baseline", base_ns, "1.00x");
    println!(
        "{:<10} {:>12.3} {:>9.2}x",
        "A0",
        per(ns_a0),
        base_ns / per(ns_a0)
    );
    if let Some(ns) = ns_a1 {
        println!("{:<10} {:>12.3} {:>9.2}x", "A1", per(ns), base_ns / per(ns));
    }
    if let Some(ns) = ns_a2 {
        println!("{:<10} {:>12.3} {:>9.2}x", "A2", per(ns), base_ns / per(ns));
    }
    if let Some(ns) = ns_a3 {
        // A3 times its own cache-resident working set, so its divisor differs.
        let a3_n = (a3_orients.len() * reps) as f64;
        let a3_per = ns as f64 / a3_n;
        println!(
            "{:<10} {:>12.3} {:>9.2}x  (incremental model — NOT recompute)",
            "A3",
            a3_per,
            base_ns / a3_per
        );
    }
    println!(
        "\n(ns/canon is a cross-check. For cyc/canon run under `perf stat -e cycles`\n \
         with mode perf:baseline | perf:a0 | perf:a1 | perf:a2, then divide cycles by {}.\n \
         A3 uses mode perf:a3 — divide by (min(corpus,2^14) * reps), which it prints.)",
        corpus.len() * reps
    );
}
