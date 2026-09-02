use std::hint::black_box;

use ergodis_private::q29_complete_even_moments::{
    derive_q29_row0_even_moment_recurrence, extract_q29_complete_even_moments,
    mine_retained_q29_single_swap_moments, reconstruct_q29_row0_mod29,
    replay_q29_moment_crt_sufficiency, retained_q29_single_swap_feature_census,
};
use ergodis_private::q29_even_moment_proof::retained_q29_y6_root;

fn main() {
    let mut args = std::env::args().skip(1);
    let mode = args.next().unwrap_or_else(|| "extract".to_owned());
    let iterations = args
        .next()
        .map_or(1_000_000_u64, |value| value.parse().expect("iterations"));
    let rows = retained_q29_y6_root();
    let mut digest = 0_u64;
    if mode == "mine" {
        println!(
            "{}",
            serde_json::to_string_pretty(&mine_retained_q29_single_swap_moments())
                .expect("serialize mining report")
        );
        return;
    }
    match mode.as_str() {
        "extract" => {
            for _ in 0..iterations {
                let signature = black_box(extract_q29_complete_even_moments(black_box(&rows)));
                digest ^= u64::from(signature.target_mask());
                for value in signature.values() {
                    digest = digest.rotate_left(3) ^ u64::from(value);
                }
            }
        }
        "census" => {
            for _ in 0..iterations {
                let (counts, legal) = black_box(retained_q29_single_swap_feature_census());
                digest ^= u64::from(legal);
                for count in counts {
                    digest = digest.rotate_left(3) ^ u64::from(count);
                }
            }
        }
        "recurrence" => {
            for _ in 0..iterations {
                let signature = black_box(derive_q29_row0_even_moment_recurrence(black_box(&rows)))
                    .expect("retained row sums");
                digest ^= u64::from(signature.matches_mask());
                for value in signature.derived() {
                    digest = digest.rotate_left(3) ^ u64::from(value);
                }
            }
        }
        "reconstruct" => {
            let other_rows = [rows[1], rows[2], rows[3]];
            let antisymmetric = std::array::from_fn(|representative| {
                rows[0][representative + 1] - rows[0][28 - representative]
            });
            for _ in 0..iterations {
                let row = black_box(reconstruct_q29_row0_mod29(
                    black_box(&other_rows),
                    black_box(&antisymmetric),
                ))
                .expect("mod29 reconstruction");
                for value in row {
                    digest = digest.rotate_left(3) ^ u64::from(value);
                }
            }
        }
        "crt" => {
            let residual = [0_i16; 29];
            for _ in 0..iterations {
                digest ^= u64::from(black_box(replay_q29_moment_crt_sufficiency(
                    black_box(&residual),
                )));
            }
        }
        _ => panic!(
            "usage: q29_complete_even_moments_perf extract|census|recurrence|reconstruct|crt|mine [iterations]"
        ),
    }
    println!("mode={mode} iterations={iterations} digest={digest}");
}
