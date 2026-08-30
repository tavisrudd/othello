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

fn counter_shape(items: usize, budget: usize) -> (usize, usize) {
    let width = budget + 1;
    let variables = (1..=items).map(|prefix| prefix.min(width)).sum();
    let mut clauses = 2_usize;
    for prefix in 2..=items {
        clauses += 3;
        for threshold in 2..=prefix.min(width) {
            clauses += if threshold < prefix { 4 } else { 3 };
        }
    }
    (variables, clauses + 2)
}

fn write_cardinality_band(
    output: &mut impl Write,
    items: usize,
    minimum: usize,
    budget: usize,
    next_variable: &mut usize,
) -> std::io::Result<()> {
    let width = budget + 1;
    let mut counter = vec![vec![0_usize; width]; items];
    for (prefix, row) in counter.iter_mut().enumerate() {
        for cell in &mut row[..=prefix.min(budget)] {
            *cell = *next_variable;
            *next_variable += 1;
        }
    }
    writeln!(output, "-1 {} 0", counter[0][0])?;
    writeln!(output, "1 -{} 0", counter[0][0])?;
    for prefix in 1..items {
        let item = prefix + 1;
        let state = counter[prefix][0];
        let prior = counter[prefix - 1][0];
        writeln!(output, "-{prior} {state} 0")?;
        writeln!(output, "-{item} {state} 0")?;
        writeln!(output, "-{state} {prior} {item} 0")?;
        for threshold in 1..=prefix.min(budget) {
            let state = counter[prefix][threshold];
            let lower = counter[prefix - 1][threshold - 1];
            if threshold < prefix {
                let prior = counter[prefix - 1][threshold];
                writeln!(output, "-{prior} {state} 0")?;
                writeln!(output, "-{item} -{lower} {state} 0")?;
                writeln!(output, "-{state} {prior} {item} 0")?;
                writeln!(output, "-{state} {prior} {lower} 0")?;
            } else {
                writeln!(output, "-{state} {item} 0")?;
                writeln!(output, "-{state} {lower} 0")?;
                writeln!(output, "-{item} -{lower} {state} 0")?;
            }
        }
    }
    writeln!(output, "-{} 0", counter[items - 1][budget])?;
    writeln!(output, "{} 0", counter[items - 1][minimum - 1])
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let path = std::env::args()
        .nth(1)
        .ok_or("usage: alignment_attachment_compact_cnf OUTPUT.cnf [MAXIMUM] [MINIMUM] [FIXED]")?;
    let budget = std::env::args()
        .nth(2)
        .map_or(Ok(16_usize), |value| value.parse())?;
    let minimum = std::env::args()
        .nth(3)
        .map_or(Ok(15_usize), |value| value.parse())?;
    let mut fixed = std::env::args()
        .nth(4)
        .map(|value| {
            value
                .split(',')
                .map(str::parse::<usize>)
                .collect::<Result<Vec<_>, _>>()
        })
        .transpose()?
        .unwrap_or_default();
    let problem = compile_alignment_attachment(8)?;
    let triples = problem.triples();
    if minimum < 15 || budget < minimum || budget >= triples.len() {
        return Err(
            "bounds must satisfy the proved lower bound 15 <= MINIMUM <= MAXIMUM <= 55".into(),
        );
    }
    fixed.sort_unstable();
    if fixed.windows(2).any(|pair| pair[0] == pair[1])
        || fixed
            .iter()
            .any(|&index| index == 0 || index >= triples.len())
    {
        return Err("FIXED must contain distinct zero-based non-anchor triple indices".into());
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
    let (counter_variables, counter_clauses) = counter_shape(triples.len(), budget);
    let anchor_clauses = 1_usize + fixed.len();
    let witness_implications = witness_count;
    let clause_count = counter_clauses + anchor_clauses + witness_implications + xor_clauses;
    let variable_count = triples.len() + counter_variables + witness_count + xor_auxiliaries;

    let file = std::fs::File::create_new(path)?;
    let mut output = BufWriter::with_capacity(1 << 20, file);
    writeln!(output, "p cnf {variable_count} {clause_count}")?;
    writeln!(output, "1 0")?;
    for fixed in fixed {
        writeln!(output, "{} 0", fixed + 1)?;
    }

    let mut next_variable = triples.len() + 1;
    write_cardinality_band(
        &mut output,
        triples.len(),
        minimum,
        budget,
        &mut next_variable,
    )?;
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
