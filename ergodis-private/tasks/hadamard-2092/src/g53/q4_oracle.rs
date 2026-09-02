use anyhow::Result;
use clap::Args as ClapArgs;
use ergodis_private::g53_sparse_q4_oracle::verify_g53_sparse_q4_census;
use serde::Serialize;

#[derive(ClapArgs)]
pub struct Arguments {
    #[arg(long, default_value_t = 16)]
    threads: usize,
}

#[derive(Serialize)]
struct Report<T> {
    schema: &'static str,
    provenance: &'static str,
    result: T,
}

pub fn run(arguments: Arguments) -> Result<()> {
    let result = verify_g53_sparse_q4_census(arguments.threads)?;
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            schema: "ergodis-private-c1016-g53-sparse-q4-independent-oracle-v1",
            provenance:
                "exact-computational independent replay: exhaustive base-five blocks plus hash join",
            result,
        },
    )?;
    println!();
    Ok(())
}
