use ergodis::compile_alignment_attachment;
use std::io::{BufWriter, Write};

fn side(cut: usize, point: usize) -> bool {
    point != 0 && cut & (1_usize << (point - 1)) != 0
}

fn write_xor(
    output: &mut impl Write,
    inputs: &[usize],
    parity: bool,
    next_variable: &mut usize,
) -> std::io::Result<()> {
    debug_assert!(inputs.len() >= 2);
    let mut left = inputs[0];
    for &right in &inputs[1..] {
        let result = *next_variable;
        *next_variable += 1;
        writeln!(output, "{left} {right} -{result} 0")?;
        writeln!(output, "-{left} -{right} -{result} 0")?;
        writeln!(output, "{left} -{right} {result} 0")?;
        writeln!(output, "-{left} {right} {result} 0")?;
        left = result;
    }
    writeln!(output, "{}{left} 0", if parity { "" } else { "-" })
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let path = std::env::args()
        .nth(1)
        .ok_or("usage: alignment_attachment_compact_cnf OUTPUT.cnf [BUDGET]")?;
    let budget = std::env::args()
        .nth(2)
        .map_or(Ok(16_usize), |value| value.parse())?;
    let problem = compile_alignment_attachment(8)?;
    let triples = problem.triples();
    if budget == 0 || budget >= triples.len() {
        return Err("budget must be between 1 and 55".into());
    }

    let mut witness_count = 0_usize;
    let mut xor_auxiliaries = 0_usize;
    let mut xor_clauses = 0_usize;
    for cut in 1_usize..1 << 7 {
        let right = (0..8).filter(|&point| side(cut, point)).count();
        let edge_count = right * (8 - right);
        let crossing_triples = 3 * edge_count;
        witness_count += crossing_triples;
        xor_auxiliaries += edge_count * 5 + crossing_triples - 1;
        xor_clauses += edge_count * 21 + 4 * (crossing_triples - 1) + 1;
    }
    let assignment_clauses = triples.len();
    let slot_implications = triples.len() * budget;
    let slot_exclusions = budget * triples.len() * (triples.len() - 1) / 2;
    let anchor_clause = 1_usize;
    let witness_implications = witness_count;
    let clause_count = assignment_clauses
        + slot_implications
        + slot_exclusions
        + anchor_clause
        + witness_implications
        + xor_clauses;
    let variable_count = triples.len() * (budget + 1) + witness_count + xor_auxiliaries;

    let file = std::fs::File::create_new(path)?;
    let mut output = BufWriter::with_capacity(1 << 20, file);
    writeln!(output, "p cnf {variable_count} {clause_count}")?;
    writeln!(output, "1 0")?;

    let slot_variable = |triple: usize, slot: usize| triples.len() + triple * budget + slot + 1;
    for triple in 0..triples.len() {
        write!(output, "-{}", triple + 1)?;
        for slot in 0..budget {
            write!(output, " {}", slot_variable(triple, slot))?;
        }
        writeln!(output, " 0")?;
        for slot in 0..budget {
            writeln!(output, "-{} {} 0", slot_variable(triple, slot), triple + 1)?;
        }
    }
    for slot in 0..budget {
        for left in 0..triples.len() {
            for right in left + 1..triples.len() {
                writeln!(
                    output,
                    "-{} -{} 0",
                    slot_variable(left, slot),
                    slot_variable(right, slot)
                )?;
            }
        }
    }

    let mut next_variable = triples.len() * (budget + 1) + 1;
    for cut in 1_usize..1 << 7 {
        let mut edge_index = [[u8::MAX; 8]; 8];
        let mut edge_count = 0_u8;
        for (left, row) in edge_index.iter_mut().enumerate() {
            for (right, cell) in row.iter_mut().enumerate().skip(left + 1) {
                if side(cut, left) != side(cut, right) {
                    *cell = edge_count;
                    edge_count += 1;
                }
            }
        }
        let mut witness_by_triple = [0_usize; 56];
        let mut pairs = [(u8::MAX, u8::MAX); 56];
        let mut witnesses = [0_usize; 48];
        let mut witness_len = 0_usize;
        for (triple, &[a, b, c]) in triples.iter().enumerate() {
            let (a, b, c) = (a as usize, b as usize, c as usize);
            let endpoints = if side(cut, a) == side(cut, b) && side(cut, a) != side(cut, c) {
                Some((c, a, b))
            } else if side(cut, a) == side(cut, c) && side(cut, a) != side(cut, b) {
                Some((b, a, c))
            } else if side(cut, b) == side(cut, c) && side(cut, b) != side(cut, a) {
                Some((a, b, c))
            } else {
                None
            };
            let Some((center, left, right)) = endpoints else {
                continue;
            };
            let witness = next_variable;
            next_variable += 1;
            witness_by_triple[triple] = witness;
            witnesses[witness_len] = witness;
            witness_len += 1;
            pairs[triple] = (
                edge_index[center.min(left)][center.max(left)],
                edge_index[center.min(right)][center.max(right)],
            );
            writeln!(output, "-{witness} {} 0", triple + 1)?;
        }
        for edge in 0..edge_count {
            let mut incident = [0_usize; 6];
            let mut len = 0_usize;
            for triple in 0..triples.len() {
                if pairs[triple].0 == edge || pairs[triple].1 == edge {
                    incident[len] = witness_by_triple[triple];
                    len += 1;
                }
            }
            debug_assert_eq!(len, 6);
            write_xor(&mut output, &incident, false, &mut next_variable)?;
        }
        write_xor(
            &mut output,
            &witnesses[..witness_len],
            true,
            &mut next_variable,
        )?;
    }
    if next_variable != variable_count + 1 {
        return Err("compact CNF variable count drifted".into());
    }
    output.flush()?;
    eprintln!(
        "wrote variables={variable_count} clauses={clause_count} witnesses={witness_count} xor_auxiliaries={xor_auxiliaries}"
    );
    Ok(())
}
