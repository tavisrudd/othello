use ergodis::compile_alignment_attachment;
use std::io::{BufWriter, Write};

fn side(cut: usize, point: usize) -> bool {
    point != 0 && cut & (1_usize << (point - 1)) != 0
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let path = std::env::args()
        .nth(1)
        .ok_or("usage: alignment_attachment_cnf OUTPUT.cnf [BUDGET]")?;
    let budget = std::env::args()
        .nth(2)
        .map_or(Ok(16_usize), |value| value.parse())?;
    let problem = compile_alignment_attachment(8)?;
    let triples = problem.triples();
    if budget == 0 || budget >= triples.len() {
        return Err("budget must be between 1 and 55".into());
    }

    let cut_clauses = (1_usize..1 << 7)
        .map(|cut| {
            let right = (0..8).filter(|&point| side(cut, point)).count();
            1_usize << (right * (8 - right))
        })
        .sum::<usize>();
    let assignment_clauses = triples.len();
    let implication_clauses = triples.len() * budget;
    let slot_clauses = budget * triples.len() * (triples.len() - 1) / 2;
    let clause_count = cut_clauses + assignment_clauses + implication_clauses + slot_clauses;
    let variable_count = triples.len() * (budget + 1);

    let file = std::fs::File::create_new(path)?;
    let mut output = BufWriter::with_capacity(1 << 20, file);
    writeln!(output, "p cnf {variable_count} {clause_count}")?;

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

    for cut in 1_usize..1 << 7 {
        let mut edge_index = [[u8::MAX; 8]; 8];
        let mut edge_count = 0_u8;
        for (left, row) in edge_index.iter_mut().enumerate() {
            for (right, cell) in row.iter_mut().enumerate().skip(left + 1) {
                if side(cut, left) == side(cut, right) {
                    continue;
                }
                *cell = edge_count;
                edge_count += 1;
            }
        }
        for coloring in 0_u32..1_u32 << edge_count {
            let mut width = 0_usize;
            for (index, &[a, b, c]) in triples.iter().enumerate() {
                let (a, b, c) = (a as usize, b as usize, c as usize);
                let singleton_and_pair =
                    if side(cut, a) == side(cut, b) && side(cut, a) != side(cut, c) {
                        Some((c, a, b))
                    } else if side(cut, a) == side(cut, c) && side(cut, a) != side(cut, b) {
                        Some((b, a, c))
                    } else if side(cut, b) == side(cut, c) && side(cut, b) != side(cut, a) {
                        Some((a, b, c))
                    } else {
                        None
                    };
                let Some((singleton, first, second)) = singleton_and_pair else {
                    continue;
                };
                let first_bit =
                    coloring >> edge_index[singleton.min(first)][singleton.max(first)] & 1;
                let second_bit =
                    coloring >> edge_index[singleton.min(second)][singleton.max(second)] & 1;
                if first_bit == second_bit {
                    write!(output, "{} ", index + 1)?;
                    width += 1;
                }
            }
            if width == 0 {
                return Err("the complete triple family failed to separate a cut context".into());
            }
            writeln!(output, "0")?;
        }
    }
    output.flush()?;
    eprintln!("wrote variables={variable_count} clauses={clause_count} cut_clauses={cut_clauses}");
    Ok(())
}
