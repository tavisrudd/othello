use std::collections::{BTreeSet, VecDeque};

use crate::{DeclaredAction, GatedPaperV, SearchStats, ShadowError};

#[derive(Clone, Copy, Eq, Ord, PartialEq, PartialOrd)]
#[repr(C)]
struct HotKey {
    bytes: [i8; 21],
}

const _: () = assert!(std::mem::size_of::<HotKey>() == 21);
const _: () = assert!(std::mem::align_of::<HotKey>() == 1);

pub(crate) struct PreparedSearch {
    matrix: [[i8; 6]; 6],
    outer: [u8; 6],
    permutations: Vec<[u8; 6]>,
    best_key: Option<HotKey>,
    best_permutation: [u8; 6],
    equal_permutations: Vec<[u8; 6]>,
    stats: SearchStats,
}

pub(crate) struct PaperVSearchResult {
    pub best_permutation: Vec<usize>,
    pub equal_permutations: Vec<Vec<usize>>,
    pub stats: SearchStats,
}

pub(crate) fn search(value: &GatedPaperV) -> Result<PaperVSearchResult, ShadowError> {
    let mut prepared = prepare(value)?;
    run_prepared(&mut prepared);
    Ok(finish(prepared))
}

pub(crate) fn prepare(value: &GatedPaperV) -> Result<PreparedSearch, ShadowError> {
    let group = declared_group(value)?;
    let permutations = group
        .iter()
        .map(|permutation| {
            <[u8; 6]>::try_from(
                permutation
                    .iter()
                    .map(|&image| u8::try_from(image).expect("Paper-V image fits u8"))
                    .collect::<Vec<_>>(),
            )
            .expect("validated Paper-V degree")
        })
        .collect::<Vec<_>>();
    let mut matrix = [[0_i8; 6]; 6];
    for (row, output_row) in matrix.iter_mut().enumerate() {
        for (column, output) in output_row.iter_mut().enumerate() {
            *output = i8::try_from(value.delta_matrix[row][column].numerator)
                .expect("Paper-V delta entry fits i8");
        }
    }
    let outer = <[u8; 6]>::try_from(
        value
            .outer_involution
            .iter()
            .map(|&image| u8::try_from(image).expect("Paper-V outer image fits u8"))
            .collect::<Vec<_>>(),
    )
    .expect("validated Paper-V degree");
    Ok(PreparedSearch {
        matrix,
        outer,
        permutations,
        best_key: None,
        best_permutation: [0; 6],
        equal_permutations: Vec::with_capacity(720),
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
        let key = key(&prepared.matrix, prepared.outer, *permutation);
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

fn key(matrix: &[[i8; 6]; 6], outer: [u8; 6], permutation: [u8; 6]) -> HotKey {
    let mut inverse = [0_u8; 6];
    for (old, &new) in permutation.iter().enumerate() {
        inverse[new as usize] = u8::try_from(old).expect("Paper-V index fits u8");
    }
    let mut bytes = [0; 21];
    let mut cursor = 0;
    for left in 0..6 {
        for right in left + 1..6 {
            bytes[cursor] = matrix[inverse[left] as usize][inverse[right] as usize];
            cursor += 1;
        }
    }
    for &old in &inverse {
        bytes[cursor] =
            i8::try_from(permutation[outer[old as usize] as usize]).expect("Paper-V image fits i8");
        cursor += 1;
    }
    HotKey { bytes }
}

fn finish(prepared: PreparedSearch) -> PaperVSearchResult {
    PaperVSearchResult {
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

pub(crate) fn declared_group(value: &GatedPaperV) -> Result<Vec<Vec<usize>>, ShadowError> {
    let DeclaredAction::VertexPermutations { degree, generators } = &value.action else {
        return Err(ShadowError::Invalid(
            "Paper-V action must use vertex permutations".into(),
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
                if seen.len() > 720 {
                    return Err(ShadowError::Invalid("Paper-V action exceeds S6".into()));
                }
                pending.push_back(product);
            }
        }
    }
    Ok(seen.into_iter().collect())
}

#[cfg(test)]
pub(crate) fn prepared_stats(prepared: &PreparedSearch) -> &SearchStats {
    &prepared.stats
}
