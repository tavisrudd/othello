use ergodis::compile_alignment_attachment;

fn next_permutation(permutation: &mut [u8; 8]) -> bool {
    let Some(pivot) = (0..permutation.len() - 1)
        .rev()
        .find(|&index| permutation[index] < permutation[index + 1])
    else {
        return false;
    };
    let successor = (pivot + 1..permutation.len())
        .rev()
        .find(|&index| permutation[pivot] < permutation[index])
        .expect("a permutation pivot has a successor");
    permutation.swap(pivot, successor);
    permutation[pivot + 1..].reverse();
    true
}

fn image_index(triples: &[[u8; 3]], index: usize, permutation: &[u8; 8]) -> usize {
    let mut image = triples[index].map(|point| permutation[point as usize]);
    image.sort_unstable();
    triples
        .iter()
        .position(|&triple| triple == image)
        .expect("a point permutation preserves triples")
}

fn root(parent: &mut [u8; 56], mut index: usize) -> usize {
    while usize::from(parent[index]) != index {
        parent[index] = parent[usize::from(parent[index])];
        index = usize::from(parent[index]);
    }
    index
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut fixed = vec![0_usize];
    if let Some(argument) = std::env::args().nth(1) {
        fixed.extend(
            argument
                .split(',')
                .filter(|item| !item.is_empty())
                .map(str::parse::<usize>)
                .collect::<Result<Vec<_>, _>>()?,
        );
    }
    fixed.sort_unstable();
    if fixed.windows(2).any(|pair| pair[0] == pair[1]) || fixed.iter().any(|&index| index >= 56) {
        return Err("fixed triple indices must be distinct and below 56".into());
    }

    let problem = compile_alignment_attachment(8)?;
    let triples = problem.triples();
    let mut parent = std::array::from_fn(|index| index as u8);
    let mut stabilizer_size = 0_u32;
    let mut permutation = [0, 1, 2, 3, 4, 5, 6, 7];
    loop {
        if fixed
            .iter()
            .all(|&index| image_index(triples, index, &permutation) == index)
        {
            stabilizer_size += 1;
            for index in 0..triples.len() {
                let image = image_index(triples, index, &permutation);
                let left = root(&mut parent, index);
                let right = root(&mut parent, image);
                if left != right {
                    parent[right] = left as u8;
                }
            }
        }
        if !next_permutation(&mut permutation) {
            break;
        }
    }

    let fixed_mask = fixed
        .iter()
        .fold(0_u64, |mask, &index| mask | (1_u64 << index));
    let mut seen_roots = 0_u64;
    let mut representatives = Vec::new();
    for index in 0..triples.len() {
        if fixed_mask >> index & 1 != 0 {
            continue;
        }
        let orbit = root(&mut parent, index);
        let bit = 1_u64 << orbit;
        if seen_roots & bit == 0 {
            seen_roots |= bit;
            representatives.push(index);
        }
    }
    println!(
        "{}",
        representatives
            .iter()
            .map(usize::to_string)
            .collect::<Vec<_>>()
            .join(",")
    );
    eprintln!(
        "fixed={} stabilizer={stabilizer_size} orbits={}",
        fixed.len(),
        representatives.len()
    );
    Ok(())
}
