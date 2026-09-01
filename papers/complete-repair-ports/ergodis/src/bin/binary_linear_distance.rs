use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis::{CompiledBinaryLinearCode, Matrix};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::fs::{File, OpenOptions};
use std::io::{BufWriter, Read, Write};
use std::path::PathBuf;
use std::time::Instant;

#[derive(Debug, Parser)]
#[command(about = "Exact minimum nonzero weight of a small-rank binary linear code")]
struct Args {
    #[arg(long)]
    input: PathBuf,
    /// Create one JSON evidence record. Existing files are never overwritten.
    #[arg(long)]
    evidence: Option<PathBuf>,
    /// Refuse a larger exponential span unless the caller raises this bound.
    #[arg(long, default_value_t = 30)]
    maximum_rank: usize,
}

#[derive(Debug, Deserialize)]
struct SparseLinearCode {
    label: String,
    coordinate_count: u16,
    generators: Vec<Vec<u16>>,
}

#[derive(Debug, Serialize)]
struct Evidence<'a> {
    schema: &'static str,
    label: &'a str,
    coordinate_count: u16,
    rank: usize,
    input_sha256: String,
    compile_seconds: f64,
    search_seconds: f64,
    method: ergodis::BinaryLinearAlgorithm,
    information_sets: usize,
    result: ergodis::BinaryLinearWeightResult,
}

fn main() -> Result<()> {
    let args = Args::parse();
    let mut input = Vec::new();
    File::open(&args.input)
        .with_context(|| format!("opening input {}", args.input.display()))?
        .read_to_end(&mut input)?;
    let code: SparseLinearCode =
        serde_json::from_slice(&input).context("parsing sparse binary linear code")?;
    let columns = usize::from(code.coordinate_count);
    let mut data = vec![0u8; code.generators.len().saturating_mul(columns)];
    for (row, support) in code.generators.iter().enumerate() {
        for &coordinate in support {
            let coordinate = usize::from(coordinate);
            if coordinate >= columns {
                bail!("generator {row} contains out-of-range coordinate {coordinate}");
            }
            let entry = &mut data[row * columns + coordinate];
            if *entry != 0 {
                bail!("generator {row} repeats coordinate {coordinate}");
            }
            *entry = 1;
        }
    }
    let compile_start = Instant::now();
    let matrix = Matrix::new::<2>(code.generators.len(), columns, data)?;
    let compiled = CompiledBinaryLinearCode::compile(&matrix)?;
    if compiled.rank() > args.maximum_rank {
        bail!(
            "compiled rank {} exceeds --maximum-rank {} ({} nonzero candidates)",
            compiled.rank(),
            args.maximum_rank,
            (1u128 << compiled.rank()) - 1
        );
    }
    let compile_seconds = compile_start.elapsed().as_secs_f64();
    let method = compiled.recommended_algorithm();
    let search_start = Instant::now();
    let result = compiled.minimum_nonzero_weight();
    let search_seconds = search_start.elapsed().as_secs_f64();
    let evidence = Evidence {
        schema: "ergodis-binary-linear-distance-v2",
        label: &code.label,
        coordinate_count: code.coordinate_count,
        rank: compiled.rank(),
        input_sha256: format!("{:x}", Sha256::digest(&input)),
        compile_seconds,
        search_seconds,
        method,
        information_sets: compiled.information_set_count(),
        result,
    };
    serde_json::to_writer(std::io::stdout().lock(), &evidence)?;
    println!();
    if let Some(path) = args.evidence {
        let file = OpenOptions::new()
            .write(true)
            .create_new(true)
            .open(&path)
            .with_context(|| format!("creating evidence file {}", path.display()))?;
        let mut output = BufWriter::new(file);
        serde_json::to_writer(&mut output, &evidence)?;
        output.write_all(b"\n")?;
        output.flush()?;
    }
    Ok(())
}
