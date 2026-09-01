use ergodis::{BinaryKernelTrialOptions, CompiledBinaryKernelSearch};
use serde::Deserialize;
use std::fs::File;
use std::io::{BufReader, Read};

#[derive(Deserialize)]
struct Problem {
    coordinate_count: u16,
    physical_checks: Vec<Vec<u16>>,
    logical_observations: Vec<Vec<u16>>,
}

fn pack(rows: &[Vec<u16>], columns: usize) -> Vec<u64> {
    let words = columns.div_ceil(64);
    let mut packed = vec![0_u64; rows.len() * words];
    for (row, support) in rows.iter().enumerate() {
        for &coordinate in support {
            packed[row * words + usize::from(coordinate) / 64] |=
                1_u64 << (usize::from(coordinate) % 64);
        }
    }
    packed
}

fn read_u16s(reader: &mut impl Read, values: &mut [u16]) -> std::io::Result<()> {
    let bytes = unsafe {
        std::slice::from_raw_parts_mut(values.as_mut_ptr().cast::<u8>(), values.len() * 2)
    };
    reader.read_exact(bytes)
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut args = std::env::args().skip(1);
    let input = args.next().ok_or("missing input")?;
    let orders = args.next().ok_or("missing order file")?;
    let problem: Problem = serde_json::from_reader(BufReader::new(File::open(input)?))?;
    let columns = usize::from(problem.coordinate_count);
    let physical = pack(&problem.physical_checks, columns);
    let logical = pack(&problem.logical_observations, columns);
    let compiled = CompiledBinaryKernelSearch::compile(
        problem.coordinate_count,
        &physical,
        problem.physical_checks.len().try_into()?,
        &logical,
        problem.logical_observations.len().try_into()?,
    )?;
    let mut workspace = compiled.workspace(1018003)?;
    let options = BinaryKernelTrialOptions::new(756, 2, 96)?;

    let mut reader = BufReader::new(File::open(orders)?);
    let mut header = [0_u8; 16];
    reader.read_exact(&mut header)?;
    if &header[..8] != b"EGBPORD1" {
        return Err("bad order magic".into());
    }
    let file_columns = u16::from_le_bytes(header[8..10].try_into()?);
    let logical_count = u16::from_le_bytes(header[10..12].try_into()?);
    let records = u32::from_le_bytes(header[12..16].try_into()?);
    if file_columns != problem.coordinate_count
        || usize::from(logical_count) != problem.logical_observations.len()
    {
        return Err("order dimensions do not match problem".into());
    }
    let logical_words = usize::from(logical_count).div_ceil(64);
    let mut target = vec![0_u64; logical_words];
    let mut order = vec![0_u16; columns];
    let mut best_weight = u16::MAX;
    let mut best_support = Vec::new();
    let mut found = 0_u32;
    for _ in 0..records {
        let target_bytes = unsafe {
            std::slice::from_raw_parts_mut(target.as_mut_ptr().cast::<u8>(), logical_words * 8)
        };
        reader.read_exact(target_bytes)?;
        read_u16s(&mut reader, &mut order)?;
        let summary = workspace.evaluate_preordered_target(&compiled, &order, &target, options)?;
        if summary.has_witness() {
            found += 1;
            if summary.best_weight < best_weight {
                best_weight = summary.best_weight;
                best_support.clear();
                best_support.extend_from_slice(workspace.witness());
            }
        }
    }
    let mut trailing = [0_u8; 1];
    if reader.read(&mut trailing)? != 0 {
        return Err("trailing order bytes".into());
    }
    if !best_support.is_empty() {
        compiled.verify_support(&best_support)?;
    }
    println!(
        "{}",
        serde_json::json!({
            "records": records,
            "found": found,
            "best_weight": (best_weight != u16::MAX).then_some(best_weight),
            "best_support": best_support,
        })
    );
    Ok(())
}
