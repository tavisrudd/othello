//! Validate + microbenchmark the AVX2 `legal_moves` against the scalar kernel.
//!     cargo run --release --example bench_simd

use std::time::Instant;

use othello::core::legal_moves; // scalar reference (before any dispatch swap)

struct Lcg(u64);
impl Lcg {
    fn next(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x >> 12;
        x ^= x << 25;
        x ^= x >> 27;
        self.0 = x;
        x.wrapping_mul(0x2545_F491_4F6C_DD1D)
    }
}

fn main() {
    #[cfg(all(target_arch = "x86_64", target_feature = "avx2"))]
    {
        use othello::simd::legal_moves_avx2;

        // Validate equality over many random disjoint boards.
        let mut rng = Lcg(0xDEAD_BEEF);
        let mut boards = Vec::with_capacity(1 << 16);
        for _ in 0..(1 << 16) {
            let p = rng.next();
            let o = rng.next() & !p;
            assert_eq!(
                unsafe { legal_moves_avx2(p, o) },
                legal_moves(p, o),
                "mismatch p={p:#x} o={o:#x}"
            );
            boards.push((p, o));
        }
        println!(
            "validated AVX2 == scalar over {} random boards\n",
            boards.len()
        );

        let reps = 200usize;
        // scalar
        let mut acc = 0u64;
        let t = Instant::now();
        for _ in 0..reps {
            for &(p, o) in &boards {
                acc ^= legal_moves(p, o);
            }
        }
        let scalar_ns = t.elapsed().as_nanos() as f64 / (reps * boards.len()) as f64;

        // simd
        let t = Instant::now();
        for _ in 0..reps {
            for &(p, o) in &boards {
                acc ^= unsafe { legal_moves_avx2(p, o) };
            }
        }
        let simd_ns = t.elapsed().as_nanos() as f64 / (reps * boards.len()) as f64;

        std::hint::black_box(acc);
        println!("scalar legal_moves     : {scalar_ns:6.2} ns/call");
        println!(
            "avx2   legal_moves (x1): {simd_ns:6.2} ns/call   ({:.2}x)",
            scalar_ns / simd_ns
        );

        // Batched: 8 boards/call (amortises setup). Validate then time.
        #[cfg(target_feature = "avx512f")]
        {
            use othello::simd::legal_moves_x8;
            let n8 = boards.len() & !7;
            for c in (0..n8).step_by(8) {
                let mut ps = [0u64; 8];
                let mut os = [0u64; 8];
                for k in 0..8 {
                    ps[k] = boards[c + k].0;
                    os[k] = boards[c + k].1;
                }
                let got = unsafe { legal_moves_x8(&ps, &os) };
                for k in 0..8 {
                    assert_eq!(got[k], legal_moves(ps[k], os[k]), "x8 mismatch");
                }
            }
            let t = Instant::now();
            for _ in 0..reps {
                for c in (0..n8).step_by(8) {
                    let mut ps = [0u64; 8];
                    let mut os = [0u64; 8];
                    for k in 0..8 {
                        ps[k] = boards[c + k].0;
                        os[k] = boards[c + k].1;
                    }
                    let r = unsafe { legal_moves_x8(&ps, &os) };
                    acc ^= r[0] ^ r[7];
                }
            }
            let x8_ns = t.elapsed().as_nanos() as f64 / (reps * n8) as f64;
            std::hint::black_box(acc);
            println!(
                "avx512 legal_moves (x8): {x8_ns:6.2} ns/board ({:.2}x)",
                scalar_ns / x8_ns
            );
        }
    }
    #[cfg(not(all(target_arch = "x86_64", target_feature = "avx2")))]
    println!("built without avx2 target-feature; rebuild with target-cpu=native/znver5");
}
