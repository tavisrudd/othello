use std::hint::black_box;

use ergodis_private::q29_complete_even_moments::{
    extract_q29_complete_even_moments, mine_retained_q29_single_swap_moments,
    retained_q29_single_swap_feature_census,
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
        _ => panic!("usage: q29_complete_even_moments_perf extract|census|mine [iterations]"),
    }
    println!("mode={mode} iterations={iterations} digest={digest}");
}
