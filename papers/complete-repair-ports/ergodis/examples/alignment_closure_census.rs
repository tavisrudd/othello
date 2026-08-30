use ergodis::compile_alignment_attachment;
use std::collections::HashSet;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let points = std::env::var("ERGODIS_ALIGNMENT_POINTS")
        .ok()
        .map_or(Ok(5_u32), |value| value.parse())?;
    let problem = compile_alignment_attachment(points)?;
    if problem.triples().len() >= 24 {
        return Err("closure census is bounded to fewer than 24 triples".into());
    }
    let mut signature = vec![0_u8; problem.closure_signature_len()];
    let mut classes = HashSet::new();
    let mut by_cardinality = vec![HashSet::new(); problem.triples().len() + 1];
    for selected in 0..1_u64 << problem.triples().len() {
        problem.write_closure_signature(selected, &mut signature)?;
        let cardinality = selected.count_ones() as usize;
        classes.insert((cardinality as u8, signature.clone().into_boxed_slice()));
        by_cardinality[cardinality].insert(signature.clone().into_boxed_slice());
    }
    println!(
        "points={points} raw={} closure_classes={} by_cardinality={}",
        1_u64 << problem.triples().len(),
        classes.len(),
        by_cardinality
            .iter()
            .map(HashSet::len)
            .map(|count| count.to_string())
            .collect::<Vec<_>>()
            .join(",")
    );
    Ok(())
}
