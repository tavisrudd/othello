//! Microbench: scalar branchless `filter_moves` vs an AVX-512 BITALG/VBMI2 version
//! (`vpshufbitqmb` in-register availability test + `vpcompressb` order-preserving
//! compaction). Answers the de-risk question for the move-filter lever: at what
//! `pmoves` length does the wide version beat the scalar loop (which has a serial
//! `nc += ...` dependency chain)? The deep search has short lists, the shallow has long
//! ones, so the break-even length decides whether the lever can pay.
//!
//! Run: `RUSTFLAGS="-C target-cpu=znver5 ..." cargo run --release --bin filter_bench`.

use std::time::Instant;

/// Scalar branchless filter — a copy of `iso_flat::filter_moves` semantics: keep the
/// squares of `pmoves` still set in the 256-bit `avail`, order-preserving.
#[inline(never)]
fn filter_scalar(out: &mut [u8], pmoves: &[u8], avail: &[u64; 4]) -> usize {
    let mut nc = 0usize;
    for &sq in pmoves {
        unsafe { *out.get_unchecked_mut(nc) = sq };
        let w = (sq >> 6) as usize;
        nc += ((unsafe { *avail.get_unchecked(w) } >> (sq & 63)) & 1) as usize;
    }
    nc
}

/// AVX-512 BITALG + VBMI2 filter. For each 64-byte chunk of `pmoves`:
/// `keep[i] = OR_w (sq_i in word w) & bit(sq_i&63) of avail[w]`, computed with one
/// `vpshufbitqmb` per word (broadcast avail[w] ⇒ every byte tests the same qword) and a
/// per-word `cmpeq` word-selector; then `vpcompressb` stores the survivors in order.
#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx512f,avx512bw,avx512vbmi2,avx512bitalg")]
unsafe fn filter_bitalg(out: *mut u8, pmoves: &[u8], avail: &[u64; 4]) -> usize {
    use std::arch::x86_64::*;
    let aw = [
        _mm512_set1_epi64(avail[0] as i64),
        _mm512_set1_epi64(avail[1] as i64),
        _mm512_set1_epi64(avail[2] as i64),
        _mm512_set1_epi64(avail[3] as i64),
    ];
    let hi_mask = _mm512_set1_epi8(0xC0u8 as i8);
    let mut nc = 0usize;
    let mut i = 0usize;
    let len = pmoves.len();
    while i < len {
        let n = (len - i).min(64);
        let lmask: u64 = if n == 64 { !0 } else { (1u64 << n) - 1 };
        let mv = _mm512_maskz_loadu_epi8(lmask, pmoves.as_ptr().add(i) as *const i8);
        let hi = _mm512_and_si512(mv, hi_mask);
        let mut keep: u64 = 0;
        // word 0
        let s0 = _mm512_cmpeq_epi8_mask(hi, _mm512_set1_epi8(0x00));
        keep |= _mm512_bitshuffle_epi64_mask(aw[0], mv) & s0;
        let s1 = _mm512_cmpeq_epi8_mask(hi, _mm512_set1_epi8(0x40));
        keep |= _mm512_bitshuffle_epi64_mask(aw[1], mv) & s1;
        let s2 = _mm512_cmpeq_epi8_mask(hi, _mm512_set1_epi8(0x80u8 as i8));
        keep |= _mm512_bitshuffle_epi64_mask(aw[2], mv) & s2;
        let s3 = _mm512_cmpeq_epi8_mask(hi, _mm512_set1_epi8(0xC0u8 as i8));
        keep |= _mm512_bitshuffle_epi64_mask(aw[3], mv) & s3;
        keep &= lmask;
        _mm512_mask_compressstoreu_epi8(out.add(nc) as *mut i8, keep, mv);
        nc += keep.count_ones() as usize;
        i += 64;
    }
    nc
}

/// Deterministic xorshift (no `Math.random`/`Date::now` needed; reproducible).
struct Rng(u64);
impl Rng {
    fn next(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        self.0 = x;
        x
    }
}

fn main() {
    let lengths = [4usize, 8, 12, 16, 24, 32, 48, 64, 96, 128, 192, 256];
    let mut rng = Rng(0x1234_5678_9abc_def1);
    println!(
        "{:>6} | {:>10} | {:>10} | {:>8} | {:>6}",
        "len", "scalar ns", "bitalg ns", "speedup", "survive%"
    );
    for &len in &lengths {
        // Build a representative case set: random move lists (distinct squares 0..255 in a
        // shuffled order, a q.order-like subsequence) and a ~50%-density avail.
        let cases = 4096;
        let mut pmoves_all: Vec<Vec<u8>> = Vec::with_capacity(cases);
        let mut avails: Vec<[u64; 4]> = Vec::with_capacity(cases);
        let mut survivors = 0usize;
        let mut total = 0usize;
        for _ in 0..cases {
            let mut pm = Vec::with_capacity(len);
            for _ in 0..len {
                pm.push((rng.next() & 0xff) as u8);
            }
            // ~50% of the moves available: set each move's bit with prob 1/2.
            let mut av = [0u64; 4];
            for &sq in &pm {
                if rng.next() & 1 == 0 {
                    av[(sq >> 6) as usize] |= 1u64 << (sq & 63);
                }
            }
            for &sq in &pm {
                total += 1;
                survivors += (((av[(sq >> 6) as usize] >> (sq & 63)) & 1) == 1) as usize;
            }
            pmoves_all.push(pm);
            avails.push(av);
        }
        let mut out = vec![0u8; 256];
        // correctness cross-check on the first case
        let ns = filter_scalar(&mut out, &pmoves_all[0], &avails[0]);
        let mut out2 = vec![0u8; 256];
        let nb = unsafe { filter_bitalg(out2.as_mut_ptr(), &pmoves_all[0], &avails[0]) };
        assert_eq!(ns, nb, "count mismatch at len {len}");
        assert_eq!(&out[..ns], &out2[..nb], "order mismatch at len {len}");

        let iters = 200usize;
        let t = Instant::now();
        let mut sink = 0usize;
        for _ in 0..iters {
            for c in 0..cases {
                sink += filter_scalar(&mut out, &pmoves_all[c], &avails[c]);
            }
        }
        let scalar_ns = t.elapsed().as_nanos() as f64 / (iters * cases) as f64;
        let t = Instant::now();
        for _ in 0..iters {
            for c in 0..cases {
                sink += unsafe { filter_bitalg(out2.as_mut_ptr(), &pmoves_all[c], &avails[c]) };
            }
        }
        let bitalg_ns = t.elapsed().as_nanos() as f64 / (iters * cases) as f64;
        std::hint::black_box(sink);
        println!(
            "{:>6} | {:>10.2} | {:>10.2} | {:>7.2}x | {:>5.1}%",
            len,
            scalar_ns,
            bitalg_ns,
            scalar_ns / bitalg_ns,
            100.0 * survivors as f64 / total as f64,
        );
    }
}
