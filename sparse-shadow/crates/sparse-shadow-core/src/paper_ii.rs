use std::collections::{BTreeSet, VecDeque};

use crate::{DeclaredAction, GatedPaperIi, SearchStats, ShadowError, WeightedBlock};

pub(crate) struct PaperIiSearchResult {
    pub best_permutation: Vec<usize>,
    pub equal_permutations: Vec<Vec<usize>>,
    pub stats: SearchStats,
}

pub(crate) struct PreparedSearch {
    source: [[[u8; 6]; 11]; 2],
    permutations: Vec<[u8; 12]>,
    best_key: Option<HotKey>,
    best_permutation: [u8; 12],
    equal_permutations: Vec<[u8; 12]>,
    stats: SearchStats,
}

#[derive(Clone, Copy, Eq, Ord, PartialEq, PartialOrd)]
#[repr(C)]
struct HotKey {
    blocks: [[u8; 6]; 22],
}

const _: () = assert!(std::mem::size_of::<HotKey>() == 132);
const _: () = assert!(std::mem::align_of::<HotKey>() == 1);

pub(crate) fn search(value: &GatedPaperIi) -> Result<PaperIiSearchResult, ShadowError> {
    let mut prepared = prepare(value)?;
    run_prepared(&mut prepared);
    Ok(finish(prepared))
}

pub(crate) fn prepare(value: &GatedPaperIi) -> Result<PreparedSearch, ShadowError> {
    let group = declared_group(value)?;
    let permutations = group
        .iter()
        .map(|permutation| {
            <[u8; 12]>::try_from(
                permutation
                    .iter()
                    .map(|&x| u8::try_from(x).expect("Paper-II image fits u8"))
                    .collect::<Vec<_>>(),
            )
            .expect("validated Paper-II degree")
        })
        .collect::<Vec<_>>();
    let mut source = [[[0_u8; 6]; 11]; 2];
    for (half_index, half) in value.trade_halves.iter().enumerate() {
        for (block_index, block) in half.iter().enumerate() {
            for (edge_index, &edge) in block.support.iter().enumerate() {
                source[half_index][block_index][edge_index] =
                    u8::try_from(edge).expect("Paper-II encoded secant fits u8");
            }
        }
    }
    Ok(PreparedSearch {
        source,
        permutations,
        best_key: None,
        best_permutation: [0; 12],
        equal_permutations: Vec::with_capacity(1320),
        stats: SearchStats {
            search_nodes: 0,
            canonical_leaves: 0,
            refinement_rounds: 0,
            max_depth: 0,
            arena_grows: 0,
        },
    })
}

pub(crate) fn run_prepared(prepared: &mut PreparedSearch) {
    for permutation in &prepared.permutations {
        prepared.stats.search_nodes += 1;
        prepared.stats.canonical_leaves += 1;
        let key = hot_key(&prepared.source, permutation);
        match prepared.best_key.as_ref().map(|best| key.cmp(best)) {
            None | Some(std::cmp::Ordering::Less) => {
                prepared.best_key = Some(key);
                prepared.best_permutation = *permutation;
                prepared.equal_permutations.clear();
                prepared.equal_permutations.push(*permutation);
            }
            Some(std::cmp::Ordering::Equal) => prepared.equal_permutations.push(*permutation),
            Some(std::cmp::Ordering::Greater) => {}
        }
    }
}

fn finish(prepared: PreparedSearch) -> PaperIiSearchResult {
    PaperIiSearchResult {
        best_permutation: prepared
            .best_permutation
            .iter()
            .map(|&x| x as usize)
            .collect(),
        equal_permutations: prepared
            .equal_permutations
            .into_iter()
            .map(|permutation| permutation.iter().map(|&x| x as usize).collect())
            .collect(),
        stats: prepared.stats,
    }
}

#[cfg(test)]
pub(crate) fn prepared_stats(prepared: &PreparedSearch) -> &SearchStats {
    &prepared.stats
}

fn hot_key(source: &[[[u8; 6]; 11]; 2], permutation: &[u8; 12]) -> HotKey {
    let mut halves = [[[0_u8; 6]; 11]; 2];
    for (half_index, half) in source.iter().enumerate() {
        for (block_index, block) in half.iter().enumerate() {
            for (edge_index, &edge) in block.iter().enumerate() {
                let left = edge as usize / 12;
                let right = edge as usize % 12;
                let mut image = [permutation[left], permutation[right]];
                image.sort_unstable();
                halves[half_index][block_index][edge_index] = image[0] * 12 + image[1];
            }
            halves[half_index][block_index].sort_unstable();
        }
        halves[half_index].sort_unstable();
    }
    let mut blocks = [[0; 6]; 22];
    // The reference tuple key orders sign -1 before sign +1.
    blocks[..11].copy_from_slice(&halves[1]);
    blocks[11..].copy_from_slice(&halves[0]);
    HotKey { blocks }
}

pub(crate) fn declared_group(value: &GatedPaperIi) -> Result<Vec<Vec<usize>>, ShadowError> {
    let DeclaredAction::VertexPermutations { degree, generators } = &value.action else {
        return Err(ShadowError::Invalid(
            "Paper-II action must use vertex permutations".into(),
        ));
    };
    let degree = *degree as usize;
    let identity: Vec<usize> = (0..degree).collect();
    let generators = generators
        .iter()
        .map(|generator| {
            generator
                .iter()
                .map(|&image| image as usize)
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();
    let mut seen = BTreeSet::from([identity.clone()]);
    let mut pending = VecDeque::from([identity]);
    while let Some(element) = pending.pop_front() {
        for generator in &generators {
            let product = element
                .iter()
                .map(|&image| generator[image])
                .collect::<Vec<_>>();
            if seen.insert(product.clone()) {
                if seen.len() > 1320 {
                    return Err(ShadowError::Invalid(
                        "Paper-II action exceeds PGL2(11)".into(),
                    ));
                }
                pending.push_back(product);
            }
        }
    }
    Ok(seen.into_iter().collect())
}

pub(crate) fn relabel_support(
    block: &WeightedBlock,
    permutation: &[usize],
) -> Result<Vec<u32>, ShadowError> {
    let degree = permutation.len();
    let mut support = Vec::with_capacity(block.support.len());
    for &edge in &block.support {
        let left = edge as usize / degree;
        let right = edge as usize % degree;
        if left >= right || right >= degree {
            return Err(ShadowError::Invalid(
                "invalid Paper-II encoded secant".into(),
            ));
        }
        let mut image = [permutation[left], permutation[right]];
        image.sort_unstable();
        support.push(
            u32::try_from(image[0] * degree + image[1]).expect("Paper-II encoded secant fits u32"),
        );
    }
    support.sort_unstable();
    Ok(support)
}

pub(crate) fn relabel_blocks(
    blocks: &[WeightedBlock],
    permutation: &[usize],
) -> Result<Vec<WeightedBlock>, ShadowError> {
    let mut result = blocks
        .iter()
        .map(|block| {
            Ok(WeightedBlock {
                support: relabel_support(block, permutation)?,
                weight: block.weight,
                sign: block.sign,
            })
        })
        .collect::<Result<Vec<_>, ShadowError>>()?;
    result.sort_unstable_by_key(|block| (block.sign, block.weight, block.support.clone()));
    Ok(result)
}
