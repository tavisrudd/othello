use ergodis::{compile_alignment_attachment, AlignmentFractionalContext};
use std::io::{Read, Write};

const TRIPLES: usize = 56;
const MAXIMUM_BATCH: usize = 16;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let batch = std::env::var("ERGODIS_ALIGNMENT_FRACTIONAL_BATCH")
        .ok()
        .map_or(Ok(MAXIMUM_BATCH), |value| value.parse::<usize>())?;
    if batch == 0 || batch > MAXIMUM_BATCH {
        return Err("fractional batch must lie in [1,16]".into());
    }
    let problem = compile_alignment_attachment(8)?;
    let mut input = std::io::stdin().lock();
    let mut output = std::io::BufWriter::with_capacity(1 << 15, std::io::stdout().lock());
    let mut bytes = [0_u8; TRIPLES * 8];
    let mut weights = [0.0_f64; TRIPLES];
    let empty = AlignmentFractionalContext {
        cut: 0,
        clause: 0,
        weight: f64::INFINITY,
    };
    let mut contexts = [empty; MAXIMUM_BATCH];
    loop {
        if input.read(&mut bytes[..1])? == 0 {
            break;
        }
        input.read_exact(&mut bytes[1..])?;
        for (index, weight) in weights.iter_mut().enumerate() {
            *weight = f64::from_le_bytes(bytes[index * 8..index * 8 + 8].try_into()?);
        }
        let count = problem.fractional_contexts(&weights, &mut contexts[..batch])?;
        output.write_all(&(count as u32).to_le_bytes())?;
        for context in &contexts[..count] {
            output.write_all(&(context.cut as u64).to_le_bytes())?;
            output.write_all(&context.clause.to_le_bytes())?;
            output.write_all(&context.weight.to_le_bytes())?;
        }
        output.flush()?;
    }
    Ok(())
}
