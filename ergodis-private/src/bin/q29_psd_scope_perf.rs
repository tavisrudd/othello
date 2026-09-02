use std::hint::black_box;

use ergodis_private::q29_psd_scope_proof::{
    census_retained_q29_psd_scopes, evolve_retained_q29_quadratic_template,
};

fn main() {
    let iterations = std::env::args()
        .nth(1)
        .map_or(1_u64, |value| value.parse().expect("iterations"));
    let mut digest = 0_u64;
    let mut last = None;
    for _ in 0..iterations {
        let report = black_box(census_retained_q29_psd_scopes());
        digest ^=
            u64::from(report.same_row_excluded) | u64::from(report.row_plus_single_excluded) << 16;
        last = Some(report);
    }
    println!(
        "{}",
        serde_json::to_string_pretty(&serde_json::json!({
            "iterations": iterations,
            "digest": digest,
            "report": last,
            "evolved_template": evolve_retained_q29_quadratic_template(),
        }))
        .expect("serialize report")
    );
}
