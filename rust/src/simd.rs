//! AVX2 SIMD kernels (x86-64). The eight ray directions of the Kogge-Stone
//! legal-move fill are independent, so they vectorise: four left-shift rays in
//! one `__m256i` (per-lane `vpsllvq`), four right-shift rays in another
//! (`vpsrlvq`). Bit-identical to `core::legal_moves` (checked in tests).
//!
//! Built only when the target has AVX2 (the `znver5`/`native` release does);
//! `core::legal_moves` selects this at compile time and falls back to scalar.

#![cfg(target_arch = "x86_64")]

use core::arch::x86_64::*;

const NOT_A: i64 = 0xFEFE_FEFE_FEFE_FEFEu64 as i64;
const NOT_H: i64 = 0x7F7F_7F7F_7F7F_7F7Fu64 as i64;
const FULL: i64 = -1; // 0xFFFF...F

#[inline]
unsafe fn hor_or(v: __m256i) -> u64 {
    let hi = _mm256_extracti128_si256::<1>(v); // lanes 2,3
    let lo = _mm256_castsi256_si128(v); // lanes 0,1
    let or = _mm_or_si128(hi, lo); // [0|2, 1|3]
    let sw = _mm_unpackhi_epi64(or, or); // [1|3, 1|3]
    _mm_cvtsi128_si64(_mm_or_si128(or, sw)) as u64
}

/// `core::legal_moves` for AVX2. Lanes (left group): N(8) E(1) NE(9) NW(7);
/// (right group): S(8) W(1) SE(7) SW(9). Per-lane premask masks file wrap.
///
/// # Safety
/// The CPU must support AVX2 (guaranteed by the `native`/`znver5` release build,
/// or guard with `is_x86_feature_detected!("avx2")`).
#[target_feature(enable = "avx2")]
pub unsafe fn legal_moves_avx2(player: u64, opponent: u64) -> u64 {
    let empty = _mm256_set1_epi64x(!(player | opponent) as i64);
    let pl = _mm256_set1_epi64x(player as i64);
    let opp = _mm256_set1_epi64x(opponent as i64);

    // ---- left-shift rays: N, E, NE, NW (set_epi64x is high-lane first) ----
    let pm_l = _mm256_set_epi64x(NOT_H, NOT_A, NOT_A, FULL); // NW,NE,E,N
    let s1_l = _mm256_set_epi64x(7, 9, 1, 8);
    let s2_l = _mm256_set_epi64x(14, 18, 2, 16);
    let s4_l = _mm256_set_epi64x(28, 36, 4, 32);

    let mut g = pl;
    let mut p = _mm256_and_si256(opp, pm_l);
    g = _mm256_or_si256(g, _mm256_and_si256(p, _mm256_sllv_epi64(g, s1_l)));
    p = _mm256_and_si256(p, _mm256_sllv_epi64(p, s1_l));
    g = _mm256_or_si256(g, _mm256_and_si256(p, _mm256_sllv_epi64(g, s2_l)));
    p = _mm256_and_si256(p, _mm256_sllv_epi64(p, s2_l));
    g = _mm256_or_si256(g, _mm256_and_si256(p, _mm256_sllv_epi64(g, s4_l)));
    let shifted = _mm256_sllv_epi64(_mm256_and_si256(g, opp), s1_l);
    let res_l = _mm256_and_si256(_mm256_and_si256(shifted, pm_l), empty);

    // ---- right-shift rays: S, W, SE, SW ----
    let pm_r = _mm256_set_epi64x(NOT_H, NOT_A, NOT_H, FULL); // SW,SE,W,S
    let s1_r = _mm256_set_epi64x(9, 7, 1, 8);
    let s2_r = _mm256_set_epi64x(18, 14, 2, 16);
    let s4_r = _mm256_set_epi64x(36, 28, 4, 32);

    let mut g = pl;
    let mut p = _mm256_and_si256(opp, pm_r);
    g = _mm256_or_si256(g, _mm256_and_si256(p, _mm256_srlv_epi64(g, s1_r)));
    p = _mm256_and_si256(p, _mm256_srlv_epi64(p, s1_r));
    g = _mm256_or_si256(g, _mm256_and_si256(p, _mm256_srlv_epi64(g, s2_r)));
    p = _mm256_and_si256(p, _mm256_srlv_epi64(p, s2_r));
    g = _mm256_or_si256(g, _mm256_and_si256(p, _mm256_srlv_epi64(g, s4_r)));
    let shifted = _mm256_srlv_epi64(_mm256_and_si256(g, opp), s1_r);
    let res_r = _mm256_and_si256(_mm256_and_si256(shifted, pm_r), empty);

    hor_or(_mm256_or_si256(res_l, res_r))
}

// --------------------------------------------------------------------------- //
// Batched (position-parallel) legal moves: 8 independent boards per call.
//
// This is the way to *amortise* SIMD setup. Instead of vectorising the eight
// ray directions of ONE board (slower than scalar -- broadcast + horizontal
// reduce dominate), put eight different boards in the eight lanes of a 512-bit
// register and run the ordinary Kogge-Stone fill with *immediate* shifts (same
// shift for every lane). Per-board cost drops because the loads/constants are
// shared across 8 boards and there is no per-call horizontal reduce.
// --------------------------------------------------------------------------- //

/// Eight independent boards' `legal_moves`, one per 512-bit lane.
///
/// # Safety
/// The CPU must support AVX-512F (guaranteed by the `native`/`znver5` release
/// build, or guard with `is_x86_feature_detected!("avx512f")`).
#[cfg(target_feature = "avx512f")]
#[target_feature(enable = "avx512f")]
pub unsafe fn legal_moves_x8(players: &[u64; 8], opps: &[u64; 8]) -> [u64; 8] {
    let pl = _mm512_loadu_epi64(players.as_ptr() as *const i64);
    let op = _mm512_loadu_epi64(opps.as_ptr() as *const i64);
    let empty = _mm512_andnot_si512(_mm512_or_si512(pl, op), _mm512_set1_epi64(FULL));
    let not_a = _mm512_set1_epi64(NOT_A);
    let not_h = _mm512_set1_epi64(NOT_H);
    let mut moves = _mm512_setzero_si512();

    // One ray: 3-step occluded fill with immediate shifts, then the square just
    // past the run (`SH` direction, `RM` result mask) is a legal move.
    macro_rules! ray_l {
        ($s:literal, $s2:literal, $s4:literal, $pm:expr, $rm:expr) => {{
            let mut g = pl;
            let mut p = _mm512_and_si512(op, $pm);
            g = _mm512_or_si512(g, _mm512_and_si512(p, _mm512_slli_epi64::<$s>(g)));
            p = _mm512_and_si512(p, _mm512_slli_epi64::<$s>(p));
            g = _mm512_or_si512(g, _mm512_and_si512(p, _mm512_slli_epi64::<$s2>(g)));
            p = _mm512_and_si512(p, _mm512_slli_epi64::<$s2>(p));
            g = _mm512_or_si512(g, _mm512_and_si512(p, _mm512_slli_epi64::<$s4>(g)));
            let sh = _mm512_slli_epi64::<$s>(_mm512_and_si512(g, op));
            moves = _mm512_or_si512(moves, _mm512_and_si512(_mm512_and_si512(sh, $rm), empty));
        }};
    }
    macro_rules! ray_r {
        ($s:literal, $s2:literal, $s4:literal, $pm:expr, $rm:expr) => {{
            let mut g = pl;
            let mut p = _mm512_and_si512(op, $pm);
            g = _mm512_or_si512(g, _mm512_and_si512(p, _mm512_srli_epi64::<$s>(g)));
            p = _mm512_and_si512(p, _mm512_srli_epi64::<$s>(p));
            g = _mm512_or_si512(g, _mm512_and_si512(p, _mm512_srli_epi64::<$s2>(g)));
            p = _mm512_and_si512(p, _mm512_srli_epi64::<$s2>(p));
            g = _mm512_or_si512(g, _mm512_and_si512(p, _mm512_srli_epi64::<$s4>(g)));
            let sh = _mm512_srli_epi64::<$s>(_mm512_and_si512(g, op));
            moves = _mm512_or_si512(moves, _mm512_and_si512(_mm512_and_si512(sh, $rm), empty));
        }};
    }
    let full = _mm512_set1_epi64(FULL);
    ray_l!(8, 16, 32, full, full); // N
    ray_r!(8, 16, 32, full, full); // S
    ray_l!(1, 2, 4, not_a, not_a); // E
    ray_l!(9, 18, 36, not_a, not_a); // NE
    ray_r!(7, 14, 28, not_a, not_a); // SE
    ray_r!(1, 2, 4, not_h, not_h); // W
    ray_l!(7, 14, 28, not_h, not_h); // NW
    ray_r!(9, 18, 36, not_h, not_h); // SW

    let mut out = [0u64; 8];
    _mm512_storeu_epi64(out.as_mut_ptr() as *mut i64, moves);
    out
}
