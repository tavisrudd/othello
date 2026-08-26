use std::collections::{BTreeSet, VecDeque};

use crate::{DeclaredAction, GatedPaperIii, SearchStats, ShadowError};

#[derive(Clone, Copy, Eq, Ord, PartialEq, PartialOrd)]
#[repr(transparent)]
struct HotKey(u16);

const _: () = assert!(std::mem::size_of::<HotKey>() == 2);
const _: () = assert!(std::mem::align_of::<HotKey>() == 2);

pub(crate) struct PaperIiiSearchResult {
    pub best_permutation: Vec<usize>,
    pub equal_permutations: Vec<Vec<usize>>,
    pub stats: SearchStats,
}

pub(crate) struct PreparedSearch {
    four_sets: [[u8; 4]; 15],
    four_set_count: u8,
    permutations: Vec<[u8; 6]>,
    best_key: Option<HotKey>,
    best_permutation: [u8; 6],
    equal_permutations: Vec<[u8; 6]>,
    stats: SearchStats,
}

pub(crate) fn search(value: &GatedPaperIii) -> Result<PaperIiiSearchResult, ShadowError> {
    let mut prepared = prepare(value)?;
    run_prepared(&mut prepared);
    Ok(finish(prepared))
}

pub(crate) fn prepare(value: &GatedPaperIii) -> Result<PreparedSearch, ShadowError> {
    let group = declared_group(value)?;
    let permutations = group
        .iter()
        .map(|permutation| {
            <[u8; 6]>::try_from(
                permutation
                    .iter()
                    .map(|&image| u8::try_from(image).expect("Paper-III image fits u8"))
                    .collect::<Vec<_>>(),
            )
            .expect("validated Paper-III degree")
        })
        .collect::<Vec<_>>();
    let mut four_sets = [[0; 4]; 15];
    for (index, four_set) in value.aligned_four_sets.iter().enumerate() {
        four_sets[index] =
            four_set.map(|vertex| u8::try_from(vertex).expect("Paper-III vertex fits u8"));
    }
    Ok(PreparedSearch {
        four_sets,
        four_set_count: u8::try_from(value.aligned_four_sets.len())
            .expect("Paper-III four-set count fits u8"),
        equal_permutations: Vec::with_capacity(permutations.len()),
        permutations,
        best_key: None,
        best_permutation: [0; 6],
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
        let key = hot_key(&prepared.four_sets, prepared.four_set_count, *permutation);
        match prepared.best_key.map(|best| key.cmp(&best)) {
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

fn finish(prepared: PreparedSearch) -> PaperIiiSearchResult {
    PaperIiiSearchResult {
        best_permutation: prepared
            .best_permutation
            .iter()
            .map(|&image| image as usize)
            .collect(),
        equal_permutations: prepared
            .equal_permutations
            .into_iter()
            .map(|permutation| permutation.iter().map(|&image| image as usize).collect())
            .collect(),
        stats: prepared.stats,
    }
}

fn hot_key(four_sets: &[[u8; 4]; 15], four_set_count: u8, permutation: [u8; 6]) -> HotKey {
    let mut bits = 0_u16;
    for four_set in &four_sets[..four_set_count as usize] {
        let mut image = four_set.map(|vertex| permutation[vertex as usize]);
        image.sort_unstable();
        bits |= 1 << four_set_index(image);
    }
    HotKey(bits)
}

fn four_set_index(four_set: [u8; 4]) -> u32 {
    let mut index = 0_u32;
    for left in 0_u8..6 {
        for right in left + 1..6 {
            if !four_set.contains(&left) && !four_set.contains(&right) {
                return index;
            }
            index += 1;
        }
    }
    unreachable!("a four-subset of six labels omits one pair")
}

#[cfg(test)]
pub(crate) fn prepared_stats(prepared: &PreparedSearch) -> &SearchStats {
    &prepared.stats
}

pub(crate) fn declared_group(value: &GatedPaperIii) -> Result<Vec<Vec<usize>>, ShadowError> {
    let DeclaredAction::VertexPermutations { degree, generators } = &value.action else {
        return Err(ShadowError::Invalid(
            "Paper-III action must use vertex permutations".into(),
        ));
    };
    let degree = *degree as usize;
    let identity = (0..degree).collect::<Vec<_>>();
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
                if seen.len() > 720 {
                    return Err(ShadowError::Invalid("Paper-III action exceeds S6".into()));
                }
                pending.push_back(product);
            }
        }
    }
    Ok(seen.into_iter().collect())
}

pub(crate) fn relabel_four_sets(four_sets: &[[u32; 4]], permutation: &[usize]) -> Vec<[u32; 4]> {
    let mut result = four_sets
        .iter()
        .map(|four_set| {
            let mut image = four_set.map(|vertex| {
                u32::try_from(permutation[vertex as usize]).expect("Paper-III image fits u32")
            });
            image.sort_unstable();
            image
        })
        .collect::<Vec<_>>();
    result.sort_unstable();
    result
}
