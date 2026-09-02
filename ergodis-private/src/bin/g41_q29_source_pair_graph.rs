use std::fs::File;
use std::path::PathBuf;

use anyhow::Result;
use clap::Parser;
use ergodis_private::g41_digit_witness_cache::read_g41_digit_witness_cache;
use ergodis_private::g41_q29_source_pair_graph::{
    compile_g41_q29_source_pair_graph, compile_g41_q29_translation_source_pair_graph,
};

#[derive(Parser)]
struct Args {
    #[arg(long)]
    cache: PathBuf,
    #[arg(long)]
    full: bool,
}

fn main() -> Result<()> {
    let args = Args::parse();
    let source = read_g41_digit_witness_cache(File::open(args.cache)?)?;
    let direct = compile_g41_q29_source_pair_graph(&source.witnesses)?;
    let translated = compile_g41_q29_translation_source_pair_graph(&source.witnesses)?;
    if args.full {
        serde_json::to_writer(
            std::io::stdout(),
            &serde_json::json!({ "direct": direct, "translation_canonical": translated }),
        )?;
    } else {
        serde_json::to_writer(
            std::io::stdout(),
            &serde_json::json!({
                "direct": direct.report,
                "translation_canonical": translated.report,
            }),
        )?;
    }
    println!();
    Ok(())
}
