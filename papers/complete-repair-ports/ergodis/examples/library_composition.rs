use ergodis::{CompositionTable, CostTable, Matrix};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let zero = Matrix::new::<2>(1, 1, vec![0])?;
    let one = Matrix::new::<2>(1, 1, vec![1])?;
    let inner = CostTable::from_entries::<2>(1, 1, [(zero, 0), (one.clone(), 1)])?;
    let blocks = [one.clone(), one.clone()];
    let compiled = CompositionTable::compose::<2>(&blocks, &inner)?;
    let answer = compiled.answer::<2>(&one)?.expect("reachable label");

    assert_eq!(answer.cost, 1);
    assert_eq!(answer.local_labels.len(), 2);
    println!(
        "cost={} local_labels={:?}",
        answer.cost, answer.local_labels
    );
    Ok(())
}
