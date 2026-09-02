use std::fs;
use std::path::PathBuf;

use anyhow::{Context, Result};
use ergodis_private::g41_q174_full_q87_join::G41Q174Q87ScopeContext;
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};

const MODULUS: usize = 87;
const MULTIPLIER: usize = 41;
const EXISTING_SHIFTS: [u8; 4] = [4, 6, 10, 33];
const MAXIMUM_PAIR_ENTRIES: usize = 1 << 20;

#[derive(Deserialize)]
struct InputBlock {
    states_by_target: Vec<Vec<u128>>,
}

#[derive(Deserialize)]
struct Input {
    target_indices: Vec<[usize; 4]>,
    target_fibres: Vec<InputBlock>,
}

#[derive(Serialize)]
struct Scope {
    shifts: Vec<u8>,
    surviving_profile_quartets: u8,
    total_right_pairs: u64,
    total_left_pairs: u64,
}

#[derive(Serialize)]
struct Report {
    source_digest: [u8; 32],
    multiplier_orbit_representatives: Vec<u8>,
    existing_shifts: [u8; 4],
    existing_canonical_classes: Vec<u8>,
    redundant_existing_shifts: Vec<u8>,
    candidate_classes: Vec<u8>,
    scopes_tested: u32,
    minimum_additional_classes: Option<u8>,
    sufficient_scopes: Vec<Scope>,
    provenance: &'static str,
}

fn canonical_class(shift: usize) -> u8 {
    let mut point = shift;
    let mut minimum = shift.min(MODULUS - shift);
    loop {
        point = point * MULTIPLIER % MODULUS;
        minimum = minimum.min(point.min(MODULUS - point));
        if point == shift {
            return minimum as u8;
        }
    }
}

fn main() -> Result<()> {
    let path = PathBuf::from(
        std::env::args_os()
            .nth(1)
            .context("expected target-fibre artifact path")?,
    );
    let source = fs::read(path)?;
    let input: Input = serde_json::from_slice(&source)?;
    anyhow::ensure!(
        input.target_fibres.len() == 4,
        "target-fibre block count changed"
    );
    let mut states: Vec<Vec<Vec<u128>>> = input
        .target_fibres
        .into_iter()
        .map(|block| block.states_by_target)
        .collect();
    for block in &mut states {
        for target in block {
            target.sort_unstable();
            target.dedup();
        }
    }
    let mut representatives: Vec<u8> = (1..=MODULUS / 2).map(canonical_class).collect();
    representatives.sort_unstable();
    representatives.dedup();
    let presented_existing_classes =
        EXISTING_SHIFTS.map(|shift| canonical_class(usize::from(shift)));
    let mut existing_canonical_classes: Vec<u8> = presented_existing_classes.to_vec();
    existing_canonical_classes.sort_unstable();
    existing_canonical_classes.dedup();
    let mut seen_existing = Vec::new();
    let mut redundant_existing_shifts = Vec::new();
    for (shift, class) in EXISTING_SHIFTS.into_iter().zip(presented_existing_classes) {
        if seen_existing.contains(&class) {
            redundant_existing_shifts.push(shift);
        } else {
            seen_existing.push(class);
        }
    }
    let candidate_classes: Vec<u8> = representatives
        .iter()
        .copied()
        .filter(|class| !existing_canonical_classes.contains(class))
        .collect();
    anyhow::ensure!(
        candidate_classes.len() < usize::BITS as usize,
        "scope mask overflow"
    );
    let contexts: Vec<G41Q174Q87ScopeContext> = input
        .target_indices
        .iter()
        .map(|indices| {
            G41Q174Q87ScopeContext::compile([
                &states[0][indices[0]],
                &states[1][indices[1]],
                &states[2][indices[2]],
                &states[3][indices[3]],
            ])
        })
        .collect::<Result<_, _>>()?;
    let mut scopes_tested = 0_u32;
    let mut minimum_additional_classes = None;
    let mut sufficient_scopes = Vec::new();
    for width in 1..=candidate_classes.len() {
        for mask in 1_usize..1_usize << candidate_classes.len() {
            if mask.count_ones() as usize != width {
                continue;
            }
            let shifts: Vec<u8> = candidate_classes
                .iter()
                .enumerate()
                .filter_map(|(index, &shift)| (mask & (1 << index) != 0).then_some(shift))
                .collect();
            let mut surviving_profile_quartets = 0_u8;
            let mut total_right_pairs = 0_u64;
            let mut total_left_pairs = 0_u64;
            for context in &contexts {
                let join = context.search(&shifts, MAXIMUM_PAIR_ENTRIES)?;
                surviving_profile_quartets += u8::from(join.first_states.is_some());
                total_right_pairs += join.right_pairs_visited;
                total_left_pairs += join.left_pairs_visited;
            }
            scopes_tested += 1;
            if surviving_profile_quartets == 0 {
                minimum_additional_classes = Some(width as u8);
                sufficient_scopes.push(Scope {
                    shifts,
                    surviving_profile_quartets,
                    total_right_pairs,
                    total_left_pairs,
                });
            }
        }
        if minimum_additional_classes.is_some() {
            break;
        }
    }
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            source_digest: Sha256::digest(source).into(),
            multiplier_orbit_representatives: representatives,
            existing_shifts: EXISTING_SHIFTS,
            existing_canonical_classes,
            redundant_existing_shifts,
            candidate_classes,
            scopes_tested,
            minimum_additional_classes,
            sufficient_scopes,
            provenance: "discovery-only progressively widened scope evolution over multiplier-derived q87 shift classes; candidates contain no hand-selected residual or theorem name, fitness is exact survival of all lifted target-profile quartets, and every evaluation uses the bounded full-state q87 extractor; authority requires sealed source-fibre replay",
        },
    )?;
    println!();
    Ok(())
}
