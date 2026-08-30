use ergodis::compile_alignment_attachment;
use std::collections::{HashMap, HashSet};

fn signature_hash(signature: &[u8]) -> u64 {
    signature.iter().fold(0xcbf2_9ce4_8422_2325, |hash, &byte| {
        (hash ^ u64::from(byte)).wrapping_mul(0x1000_0000_01b3)
    })
}

fn sampled_census(
    problem: &ergodis::AlignmentAttachment,
    samples: usize,
) -> Result<(), Box<dyn std::error::Error>> {
    let weight = std::env::var("ERGODIS_ALIGNMENT_WEIGHT")
        .ok()
        .map_or(Ok(15_u32), |value| value.parse())?;
    let fixed = std::env::var("ERGODIS_ALIGNMENT_FIXED")
        .unwrap_or_else(|_| "0,1,2".to_owned())
        .split(',')
        .map(str::parse::<usize>)
        .collect::<Result<Vec<_>, _>>()?
        .into_iter()
        .fold(0_u64, |mask, triple| mask | 1_u64 << triple);
    if weight < fixed.count_ones() || weight as usize > problem.triples().len() {
        return Err("sample weight must contain the fixed family".into());
    }
    let mut signature = vec![0_u8; problem.closure_signature_len()];
    let mut replay = vec![0_u8; signature.len()];
    let mut selected_masks = HashSet::with_capacity(samples);
    let mut buckets: HashMap<u64, Vec<u64>> = HashMap::with_capacity(samples);
    let mut state = 0x8f6a_3c91_d274_5be7_u64;
    while selected_masks.len() < samples {
        let mut selected = fixed;
        while selected.count_ones() < weight {
            state ^= state << 7;
            state ^= state >> 9;
            state ^= state << 8;
            selected |= 1_u64 << (state as usize % problem.triples().len());
        }
        if !selected_masks.insert(selected) {
            continue;
        }
        problem.write_closure_signature(selected, &mut signature)?;
        let bucket = buckets.entry(signature_hash(&signature)).or_default();
        let mut duplicate = false;
        for &representative in bucket.iter() {
            problem.write_closure_signature(representative, &mut replay)?;
            if replay == signature {
                duplicate = true;
                break;
            }
        }
        if !duplicate {
            bucket.push(selected);
        }
    }
    let classes = buckets.values().map(Vec::len).sum::<usize>();
    println!(
        "points={} samples={samples} weight={weight} fixed={fixed:#x} closure_classes={classes} merges={}",
        problem.point_count(),
        samples - classes
    );
    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let points = std::env::var("ERGODIS_ALIGNMENT_POINTS")
        .ok()
        .map_or(Ok(5_u32), |value| value.parse())?;
    let problem = compile_alignment_attachment(points)?;
    if let Ok(samples) = std::env::var("ERGODIS_ALIGNMENT_SAMPLES") {
        return sampled_census(&problem, samples.parse()?);
    }
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
