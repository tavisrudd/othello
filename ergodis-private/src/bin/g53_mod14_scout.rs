use anyhow::Result;
use ergodis_private::g53_mod14_reduction::compile_g53_mod14_prefix_counts;
use serde::Serialize;

#[derive(Serialize)]
struct Report {
    schema: &'static str,
    provenance: &'static str,
    counts: [ergodis_private::g53_mod14_reduction::G53Mod14PrefixCount; 4],
}

fn main() -> Result<()> {
    println!(
        "{}",
        serde_json::to_string(&Report {
            schema: "ergodis-private-c1016-g53-mod14-scout-v1",
            provenance:
                "proved parity mechanism plus exact-computational root census; necessary only",
            counts: compile_g53_mod14_prefix_counts()?,
        })?
    );
    Ok(())
}
