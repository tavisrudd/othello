use anyhow::Result;
use ergodis_private::g53_mod49_high_scout::{
    compile_g53_mod49_high_saturation, count_g53_mod49_high_join, G53Mod49HighJoinCount,
    G53Mod49HighSaturation,
};
use serde::Serialize;

#[derive(Serialize)]
struct Report {
    schema: &'static str,
    provenance: &'static str,
    saturation: [G53Mod49HighSaturation; 3],
    q5_join: G53Mod49HighJoinCount,
    q6_join: G53Mod49HighJoinCount,
    q7_join: G53Mod49HighJoinCount,
}

fn main() -> Result<()> {
    println!(
        "{}",
        serde_json::to_string(&Report {
            schema: "ergodis-private-c1016-g53-mod49-high-scout-v1",
            provenance: "exact-row per-mask signature census; discovery only",
            saturation: [
                compile_g53_mod49_high_saturation(5)?,
                compile_g53_mod49_high_saturation(6)?,
                compile_g53_mod49_high_saturation(7)?,
            ],
            q5_join: count_g53_mod49_high_join(5)?,
            q6_join: count_g53_mod49_high_join(6)?,
            q7_join: count_g53_mod49_high_join(7)?,
        })?
    );
    Ok(())
}
