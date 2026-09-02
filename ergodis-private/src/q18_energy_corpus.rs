//! Discovery-only corpus measurement for the exact q174-to-q18 energy gate.
//!
//! Each proposal is made by a rejection-sampled partial Fisher--Yates draw of
//! four fixed-weight length-522 binary blocks.  We retain only proposals on
//! the exact q174 zero-energy shell (173 degree-zero/full columns).  Thus the
//! corpus does not preferentially select q174 margin summaries using the q18
//! gate.  It is still a deterministic pseudorandom sample, not exhaustive
//! evidence, and therefore has no proof or negative-coverage authority.

use crate::q18_energy_gate::{
    q18_class_energy_bounds, q18_convex_lower_bound_allows_target,
    q18_energy_target_reachable_from_q174,
    q18_energy_target_reachable_from_q174_without_convex_control, Q18EnergyGateError,
    Q18EnergyWorkspace,
};
use crate::q18_q174_margin_lift::Q174MarginSummary;

const BLOCKS: usize = 4;
const LENGTH: usize = 522;
const Q174: usize = 174;
const CLASSES: usize = 6;
const TARGET_EXTREMES: u16 = 173;
const BLOCK_WEIGHTS: [usize; BLOCKS] = [262, 261, 261, 261];

#[repr(C, align(64))]
pub struct Q18EnergyCorpusWorkspace {
    positions: [u16; LENGTH],
    degrees: [u8; Q174],
    summaries: [Q174MarginSummary; BLOCKS],
    gate: Q18EnergyWorkspace,
}

const _: () = assert!(std::mem::size_of::<Q18EnergyCorpusWorkspace>() == 2_560);
const _: () = assert!(std::mem::align_of::<Q18EnergyCorpusWorkspace>() == 64);

impl Q18EnergyCorpusWorkspace {
    #[must_use]
    pub fn new() -> Self {
        Self {
            positions: [0; LENGTH],
            degrees: [0; Q174],
            summaries: [Q174MarginSummary::default(); BLOCKS],
            gate: Q18EnergyWorkspace::ZERO,
        }
    }
}

impl Default for Q18EnergyCorpusWorkspace {
    fn default() -> Self {
        Self::new()
    }
}

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct Q18EnergyCorpusReport {
    pub proposals: u64,
    pub shell_samples: u64,
    pub gate_survivors: u64,
    pub summary_checksum: u64,
    pub scope_samples: [u64; 4],
    pub scope_rejects: [u64; 4],
    pub lower_bound_rejects: u64,
    pub upper_bound_rejects: u64,
    pub internal_gap_rejects: u64,
    _padding: [u8; 8],
}

const _: () = assert!(std::mem::size_of::<Q18EnergyCorpusReport>() == 128);
const _: () = assert!(std::mem::align_of::<Q18EnergyCorpusReport>() == 64);

const SCOPE_THRESHOLDS: [u16; 4] = [64, 96, 128, 160];

/// Measure the q18 gate on an independently proposed q174 energy-shell corpus.
///
/// `APPLY_GATE=false` is the equal-work corpus-generation control used for
/// hardware-counter A/B measurements.  It deliberately records every shell
/// sample as a survivor while retaining the same proposal stream and checksum.
pub fn measure_q18_energy_gate_corpus<const APPLY_GATE: bool>(
    mut seed: u64,
    shell_samples: u64,
    workspace: &mut Q18EnergyCorpusWorkspace,
) -> Result<Q18EnergyCorpusReport, Q18EnergyGateError> {
    let mut report = Q18EnergyCorpusReport::default();
    while report.shell_samples < shell_samples {
        report.proposals += 1;
        let extremes = propose_fixed_weight_blocks(&mut seed, workspace);
        if extremes != TARGET_EXTREMES {
            continue;
        }
        report.shell_samples += 1;
        accumulate_checksum(&workspace.summaries, &mut report.summary_checksum);
        let gate_survives = !APPLY_GATE
            || q18_energy_target_reachable_from_q174(&workspace.summaries, &mut workspace.gate)?;
        accumulate_scope(&workspace.summaries, gate_survives, &mut report);
        if APPLY_GATE && !gate_survives {
            classify_reject(&workspace.summaries, &mut report)?;
        }
        if gate_survives {
            report.gate_survivors += 1;
        }
    }
    Ok(report)
}

/// Coverage-directed shell corpus with deliberately broad degree profiles.
///
/// This is not a uniform sample of original binary blocks. It distributes the
/// 173 extreme q174 columns first and is only an adversarial discovery control
/// for gate rejects hidden in the tails. It has no proof authority.
pub fn measure_broad_q174_shell<const APPLY_GATE: bool>(
    mut seed: u64,
    shell_samples: u64,
    workspace: &mut Q18EnergyCorpusWorkspace,
) -> Result<Q18EnergyCorpusReport, Q18EnergyGateError> {
    let mut report = Q18EnergyCorpusReport::default();
    while report.shell_samples < shell_samples {
        report.proposals += 1;
        propose_broad_shell(&mut seed, workspace);
        report.shell_samples += 1;
        accumulate_checksum(&workspace.summaries, &mut report.summary_checksum);
        let gate_survives = !APPLY_GATE
            || q18_energy_target_reachable_from_q174(&workspace.summaries, &mut workspace.gate)?;
        accumulate_scope(&workspace.summaries, gate_survives, &mut report);
        if APPLY_GATE && !gate_survives {
            classify_reject(&workspace.summaries, &mut report)?;
        }
        if gate_survives {
            report.gate_survivors += 1;
        }
    }
    Ok(report)
}

/// Same broad proposal stream evaluated by the retained pre-convex gate.
/// This exists only for exact parity and hardware-counter A/B measurements.
pub fn measure_broad_q174_shell_old_gate_control(
    mut seed: u64,
    shell_samples: u64,
    workspace: &mut Q18EnergyCorpusWorkspace,
) -> Result<Q18EnergyCorpusReport, Q18EnergyGateError> {
    let mut report = Q18EnergyCorpusReport::default();
    while report.shell_samples < shell_samples {
        report.proposals += 1;
        propose_broad_shell(&mut seed, workspace);
        report.shell_samples += 1;
        accumulate_checksum(&workspace.summaries, &mut report.summary_checksum);
        let survives = q18_energy_target_reachable_from_q174_without_convex_control(
            &workspace.summaries,
            &mut workspace.gate,
        )?;
        accumulate_scope(&workspace.summaries, survives, &mut report);
        if !survives {
            classify_reject(&workspace.summaries, &mut report)?;
        } else {
            report.gate_survivors += 1;
        }
    }
    Ok(report)
}

/// Broad proposal stream evaluated only by the proved convex lower bound.
pub fn measure_broad_q174_shell_lower_bound(
    mut seed: u64,
    shell_samples: u64,
    workspace: &mut Q18EnergyCorpusWorkspace,
) -> Result<Q18EnergyCorpusReport, Q18EnergyGateError> {
    let mut report = Q18EnergyCorpusReport::default();
    while report.shell_samples < shell_samples {
        report.proposals += 1;
        propose_broad_shell(&mut seed, workspace);
        report.shell_samples += 1;
        accumulate_checksum(&workspace.summaries, &mut report.summary_checksum);
        let survives = q18_convex_lower_bound_allows_target(&workspace.summaries)?;
        accumulate_scope(&workspace.summaries, survives, &mut report);
        if survives {
            report.gate_survivors += 1;
        } else {
            report.lower_bound_rejects += 1;
        }
    }
    Ok(report)
}

fn classify_reject(
    summaries: &[Q174MarginSummary; BLOCKS],
    report: &mut Q18EnergyCorpusReport,
) -> Result<(), Q18EnergyGateError> {
    let mut minimum = 0_u32;
    let mut maximum = 0_u32;
    for summary in summaries {
        for class in summary.classes {
            let (class_minimum, class_maximum, _) = q18_class_energy_bounds(class)?;
            minimum += u32::from(class_minimum);
            maximum += u32::from(class_maximum);
        }
    }
    if minimum > 1_976 {
        report.lower_bound_rejects += 1;
    } else if maximum < 1_976 {
        report.upper_bound_rejects += 1;
    } else {
        report.internal_gap_rejects += 1;
    }
    Ok(())
}

fn accumulate_scope(
    summaries: &[Q174MarginSummary; BLOCKS],
    gate_survives: bool,
    report: &mut Q18EnergyCorpusReport,
) {
    let maximum = summaries
        .iter()
        .map(|summary| {
            summary
                .classes
                .iter()
                .map(|class| u16::from(class.zero_columns + class.full_columns))
                .sum::<u16>()
        })
        .max()
        .unwrap_or(0);
    for (index, &threshold) in SCOPE_THRESHOLDS.iter().enumerate() {
        if maximum >= threshold {
            report.scope_samples[index] += 1;
            report.scope_rejects[index] += u64::from(!gate_survives);
        }
    }
}

/// Return the first broad-shell proposal rejected by the proved q18 gate.
/// The returned summaries are a discovery witness only; replaying the gate
/// establishes rejection at the margin layer, not a new general theorem.
pub fn first_broad_q174_shell_reject(
    mut seed: u64,
    maximum_samples: u64,
    workspace: &mut Q18EnergyCorpusWorkspace,
) -> Result<Option<(u64, [Q174MarginSummary; BLOCKS])>, Q18EnergyGateError> {
    for sample in 1..=maximum_samples {
        propose_broad_shell(&mut seed, workspace);
        if !q18_energy_target_reachable_from_q174(&workspace.summaries, &mut workspace.gate)? {
            return Ok(Some((sample, workspace.summaries)));
        }
    }
    Ok(None)
}

fn accumulate_checksum(summaries: &[Q174MarginSummary; BLOCKS], checksum: &mut u64) {
    for summary in summaries {
        for class in summary.classes {
            *checksum = checksum
                .rotate_left(7)
                .wrapping_add(u64::from(class.total))
                .wrapping_add(u64::from(class.zero_columns) << 16)
                .wrapping_add(u64::from(class.full_columns) << 24);
        }
    }
}

fn propose_broad_shell(seed: &mut u64, workspace: &mut Q18EnergyCorpusWorkspace) {
    let extremes_by_block = loop {
        let mut result = [0_usize; BLOCKS];
        let mut remaining = TARGET_EXTREMES as usize;
        for (block, slot) in result.iter_mut().enumerate() {
            let remaining_blocks = BLOCKS - block - 1;
            let minimum = remaining.saturating_sub(remaining_blocks * Q174);
            let maximum = remaining.min(Q174);
            *slot = if block + 1 == BLOCKS {
                remaining
            } else {
                minimum + random_below(seed, (maximum - minimum + 1) as u64) as usize
            };
            remaining -= *slot;
        }
        if result
            .iter()
            .enumerate()
            .all(|(block, &extremes)| feasible_threes(BLOCK_WEIGHTS[block], extremes).is_some())
        {
            break result;
        }
    };
    for (block, &weight) in BLOCK_WEIGHTS.iter().enumerate() {
        let extremes = extremes_by_block[block];
        let required_increment = weight - (Q174 - extremes);
        let (minimum_threes, maximum_threes) = feasible_threes(weight, extremes).unwrap();
        let threes = minimum_threes
            + random_below(seed, (maximum_threes - minimum_threes + 1) as u64) as usize;
        let twos = required_increment - 3 * threes;
        let zeros = extremes - threes;
        let ones = Q174 - extremes - twos;

        let mut cursor = 0;
        for (degree, count) in [(0, zeros), (1, ones), (2, twos), (3, threes)] {
            workspace.degrees[cursor..cursor + count].fill(degree);
            cursor += count;
        }
        debug_assert_eq!(cursor, Q174);
        for tail in (1..Q174).rev() {
            let swap = random_below(seed, (tail + 1) as u64) as usize;
            workspace.degrees.swap(tail, swap);
        }
        summarize_degrees(&workspace.degrees, &mut workspace.summaries[block]);
    }
}

fn feasible_threes(weight: usize, extremes: usize) -> Option<(usize, usize)> {
    let required_increment = weight - (Q174 - extremes);
    let minimum = required_increment
        .saturating_sub(Q174 - extremes)
        .div_ceil(3);
    let maximum = (required_increment / 3).min(extremes);
    (minimum <= maximum).then_some((minimum, maximum))
}

fn propose_fixed_weight_blocks(seed: &mut u64, workspace: &mut Q18EnergyCorpusWorkspace) -> u16 {
    let mut extremes = 0_u16;
    for (block, &weight) in BLOCK_WEIGHTS.iter().enumerate() {
        for (index, position) in workspace.positions.iter_mut().enumerate() {
            *position = index as u16;
        }
        workspace.degrees.fill(0);
        for cursor in 0..weight {
            let offset = random_below(seed, (LENGTH - cursor) as u64) as usize;
            workspace.positions.swap(cursor, cursor + offset);
            let position = usize::from(workspace.positions[cursor]);
            workspace.degrees[position % Q174] += 1;
        }

        summarize_degrees(&workspace.degrees, &mut workspace.summaries[block]);
        extremes += workspace.summaries[block]
            .classes
            .iter()
            .map(|class| u16::from(class.zero_columns + class.full_columns))
            .sum::<u16>();
    }
    extremes
}

fn summarize_degrees(degrees: &[u8; Q174], summary: &mut Q174MarginSummary) {
    *summary = Q174MarginSummary::default();
    for (index, &degree) in degrees.iter().enumerate() {
        let class = &mut summary.classes[index % CLASSES];
        class.total += u16::from(degree);
        class.zero_columns += u8::from(degree == 0);
        class.full_columns += u8::from(degree == 3);
    }
}

#[inline(always)]
fn random_below(seed: &mut u64, bound: u64) -> u64 {
    debug_assert!(bound > 0);
    let threshold = bound.wrapping_neg() % bound;
    loop {
        let value = next_random(seed);
        if value >= threshold {
            return value % bound;
        }
    }
}

#[inline(always)]
fn next_random(seed: &mut u64) -> u64 {
    *seed = seed.wrapping_add(0x9e37_79b9_7f4a_7c15);
    let mut value = *seed;
    value = (value ^ (value >> 30)).wrapping_mul(0xbf58_476d_1ce4_e5b9);
    value = (value ^ (value >> 27)).wrapping_mul(0x94d0_49bb_1331_11eb);
    value ^ (value >> 31)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;
    use crate::q18_q174_margin_lift::Q174ClassSummary;

    #[test]
    fn proposals_have_exact_block_weights_and_summary_semantics() {
        let mut workspace = Q18EnergyCorpusWorkspace::new();
        let mut seed = 1;
        for _ in 0..32 {
            let direct_extremes = propose_fixed_weight_blocks(&mut seed, &mut workspace);
            let mut extracted_extremes = 0_u16;
            for (block, summary) in workspace.summaries.iter().enumerate() {
                assert_eq!(
                    summary.classes.iter().map(|class| class.total).sum::<u16>(),
                    BLOCK_WEIGHTS[block] as u16
                );
                extracted_extremes += summary
                    .classes
                    .iter()
                    .map(|class| u16::from(class.zero_columns + class.full_columns))
                    .sum::<u16>();
            }
            assert_eq!(direct_extremes, extracted_extremes);
        }
    }

    #[test]
    fn gate_and_control_replay_identical_corpus() {
        let mut control_workspace = Q18EnergyCorpusWorkspace::new();
        let mut gate_workspace = Q18EnergyCorpusWorkspace::new();
        let control =
            measure_q18_energy_gate_corpus::<false>(7, 64, &mut control_workspace).unwrap();
        let gate = measure_q18_energy_gate_corpus::<true>(7, 64, &mut gate_workspace).unwrap();
        assert_eq!(control.proposals, gate.proposals);
        assert_eq!(control.shell_samples, gate.shell_samples);
        assert_eq!(control.summary_checksum, gate.summary_checksum);
        assert!(gate.gate_survivors <= control.gate_survivors);
    }

    #[test]
    fn generation_and_gate_hot_loop_allocate_nothing() {
        let mut workspace = Q18EnergyCorpusWorkspace::new();
        let (_, allocations) = tracked_allocations(|| {
            let report = measure_q18_energy_gate_corpus::<true>(11, 64, &mut workspace).unwrap();
            assert_eq!(report.shell_samples, 64);
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn class_record_shape_remains_plain_and_compact() {
        assert_eq!(std::mem::size_of::<Q174ClassSummary>(), 4);
    }

    #[test]
    fn broad_shell_has_exact_energy_and_block_weights() {
        let mut workspace = Q18EnergyCorpusWorkspace::new();
        let mut seed = 19;
        for _ in 0..256 {
            propose_broad_shell(&mut seed, &mut workspace);
            let extremes = workspace
                .summaries
                .iter()
                .flat_map(|summary| summary.classes)
                .map(|class| u16::from(class.zero_columns + class.full_columns))
                .sum::<u16>();
            assert_eq!(extremes, TARGET_EXTREMES);
            for (block, summary) in workspace.summaries.iter().enumerate() {
                assert_eq!(
                    summary.classes.iter().map(|class| class.total).sum::<u16>(),
                    BLOCK_WEIGHTS[block] as u16
                );
            }
        }
    }

    #[test]
    fn convex_fast_path_and_old_gate_agree_on_broad_tail_corpus() {
        let mut fast_workspace = Q18EnergyCorpusWorkspace::new();
        let mut old_workspace = Q18EnergyCorpusWorkspace::new();
        let fast = measure_broad_q174_shell::<true>(23, 10_000, &mut fast_workspace).unwrap();
        let old =
            measure_broad_q174_shell_old_gate_control(23, 10_000, &mut old_workspace).unwrap();
        let lower = measure_broad_q174_shell_lower_bound(23, 10_000, &mut old_workspace).unwrap();
        assert_eq!(fast.summary_checksum, old.summary_checksum);
        assert_eq!(fast.gate_survivors, old.gate_survivors);
        assert_eq!(fast.gate_survivors, lower.gate_survivors);
        assert_eq!(fast.lower_bound_rejects, old.lower_bound_rejects);
        assert_eq!(fast.internal_gap_rejects, 0);
    }
}
