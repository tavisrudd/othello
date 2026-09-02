use anyhow::Result;
use clap::Parser;
use ergodis_private::g53_sparse_q4_proof::{synthesize_g53_sparse_q4_proof, G53SparseQ4Binding};

#[derive(Parser)]
struct Arguments {
    #[arg(long, default_value_t = 16)]
    threads: usize,
}

fn main() -> Result<()> {
    let arguments = Arguments::parse();
    let proof =
        synthesize_g53_sparse_q4_proof(G53SparseQ4Binding::registered(), arguments.threads)?;
    serde_json::to_writer(std::io::stdout(), &proof)?;
    println!();
    Ok(())
}
