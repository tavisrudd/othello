use anyhow::Result;
use ergodis_private::g53_mod28_reduction::{compile_g53_mod28_prefix_counts, G53Mod28PrefixCount};
use serde::Serialize;

#[derive(Serialize)]
struct Report {
    schema: &'static str,
    provenance: &'static str,
    counts: [G53Mod28PrefixCount; 4],
}

fn main() -> Result<()> {
    println!(
        "{}",
        serde_json::to_string(&Report {
            schema: "ergodis-private-c1016-g53-mod28-scout-v1",
            provenance: "structural exact-row modular census; necessary only",
            counts: compile_g53_mod28_prefix_counts()?,
        })?
    );
    Ok(())
}
