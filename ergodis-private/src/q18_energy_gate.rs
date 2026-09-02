//! Exact q18 zero-energy gate derived from q174 binary margins.
//!
//! A q174 residue class records the 29 column degrees of a `3 x 29`
//! binary table only through `(total, zero_columns, full_columns)`.  Those
//! three numbers nevertheless determine the complete set of possible q18
//! zero-shift energies of its three row degrees.  Combining the 24 independent
//! residue classes gives a small exact bitset gate before any q18 off-zero
//! correlation or binary lift is constructed.

use thiserror::Error;

use crate::q18_q174_margin_lift::{Q174ClassSummary, Q174MarginSummary, CRT_COLUMNS};

pub const Q18_GS_COMBINED_ENERGY: usize = 1_976;
pub const Q18_ENERGY_WORDS: usize = (Q18_GS_COMBINED_ENERGY + 64) / 64;
const CLASS_ENERGY_VALUES: usize = 316;
// Three odd squares lie in `[3, 3*29^2]` and are always `3 (mod 8)`.
const _: () = assert!(CLASS_ENERGY_VALUES == (3 * 29 * 29 - 3) / 8 + 1);
const BLOCKS: usize = 4;
const EXPECTED_BLOCK_WEIGHTS: [u16; BLOCKS] = [262, 261, 261, 261];

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q18EnergyWorkspace {
    current: [u64; Q18_ENERGY_WORDS],
    next: [u64; Q18_ENERGY_WORDS],
    class_energies: [u16; CLASS_ENERGY_VALUES],
    _padding: [u8; 24],
}

const _: () = assert!(std::mem::size_of::<Q18EnergyWorkspace>() == 1_152);
const _: () = assert!(std::mem::align_of::<Q18EnergyWorkspace>() == 64);

impl Q18EnergyWorkspace {
    pub const ZERO: Self = Self {
        current: [0; Q18_ENERGY_WORDS],
        next: [0; Q18_ENERGY_WORDS],
        class_energies: [0; CLASS_ENERGY_VALUES],
        _padding: [0; 24],
    };
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum Q18EnergyGateError {
    #[error("q174 class summary is not realizable by 29 column degrees in [0, 3]")]
    InvalidClassSummary,
}

/// Exact min/max and distinct-count of compatible row-degree energies for one
/// q174 class. This diagnostic uses the same sealed enumerator as the gate.
pub fn q18_class_energy_bounds(
    summary: Q174ClassSummary,
) -> Result<(u16, u16, u16), Q18EnergyGateError> {
    validate_summary(summary)?;
    let mut energies = [0_u16; CLASS_ENERGY_VALUES];
    let count = enumerate_class_energies(summary, &mut energies, usize::from(u16::MAX));
    let minimum = *energies[..count].iter().min().unwrap();
    let maximum = *energies[..count].iter().max().unwrap();
    Ok((minimum, maximum, count as u16))
}

/// Convex lower bound for one class, attained by the three row degrees nearest
/// their common mean. Realizability gives `full <= floor(total/3)` and
/// `ceil(total/3) <= 29-zero`, so this balanced triple also satisfies the
/// complete three-row Gale--Ryser inequalities.
pub fn q18_class_minimum_energy(summary: Q174ClassSummary) -> Result<u16, Q18EnergyGateError> {
    validate_summary(summary)?;
    let quotient = summary.total / 3;
    let remainder = summary.total % 3;
    let degrees = [
        quotient + u16::from(remainder > 0),
        quotient + u16::from(remainder > 1),
        quotient,
    ];
    let energy = degrees
        .map(|degree| {
            let signed = 2 * degree as i16 - 29;
            (signed * signed) as u16
        })
        .iter()
        .sum();
    Ok(energy)
}

/// Decide whether some q18 row-degree margins compatible with the supplied
/// q174 summaries can have the required combined zero-shift energy.
///
/// This is an exact existential projection at the margin layer.  A `true`
/// result is only necessary for a binary/PAF lift; `false` excludes every q18
/// margin lift of these q174 summaries.  The hot gate is iterative and
/// allocation-free.
pub fn q18_energy_target_reachable_from_q174(
    summaries: &[Q174MarginSummary; BLOCKS],
    workspace: &mut Q18EnergyWorkspace,
) -> Result<bool, Q18EnergyGateError> {
    if !q18_convex_lower_bound_allows_target(summaries)? {
        return Ok(false);
    }

    workspace.current.fill(0);
    workspace.current[0] = 1;

    for summary in summaries {
        for &class in &summary.classes {
            let energy_count = enumerate_class_energies(
                class,
                &mut workspace.class_energies,
                Q18_GS_COMBINED_ENERGY,
            );
            if energy_count == 0 {
                return Ok(false);
            }
            workspace.next.fill(0);
            for &energy in &workspace.class_energies[..energy_count] {
                or_shifted(&mut workspace.next, &workspace.current, usize::from(energy));
            }
            std::mem::swap(&mut workspace.current, &mut workspace.next);
        }
    }

    Ok(
        workspace.current[Q18_GS_COMBINED_ENERGY / 64] & (1_u64 << (Q18_GS_COMBINED_ENERGY % 64))
            != 0,
    )
}

/// Proved convex necessary gate, independent of the subset-sum DP.
/// `true` is necessary-only and grants no positive or certificate authority.
pub fn q18_convex_lower_bound_allows_target(
    summaries: &[Q174MarginSummary; BLOCKS],
) -> Result<bool, Q18EnergyGateError> {
    let mut minimum_energy = 0_u16;
    for (block, summary) in summaries.iter().enumerate() {
        let mut block_weight = 0_u16;
        for &class in &summary.classes {
            minimum_energy += q18_class_minimum_energy(class)?;
            block_weight += class.total;
        }
        if block_weight != EXPECTED_BLOCK_WEIGHTS[block] {
            return Ok(false);
        }
    }
    Ok(usize::from(minimum_energy) <= Q18_GS_COMBINED_ENERGY)
}

/// Retained pre-convex implementation for exact-result and counter A/B only.
#[doc(hidden)]
pub fn q18_energy_target_reachable_from_q174_without_convex_control(
    summaries: &[Q174MarginSummary; BLOCKS],
    workspace: &mut Q18EnergyWorkspace,
) -> Result<bool, Q18EnergyGateError> {
    workspace.current.fill(0);
    workspace.current[0] = 1;
    for (block, summary) in summaries.iter().enumerate() {
        let mut block_weight = 0_u16;
        for &class in &summary.classes {
            validate_summary(class)?;
            block_weight += class.total;
            let energy_count = enumerate_class_energies(
                class,
                &mut workspace.class_energies,
                Q18_GS_COMBINED_ENERGY,
            );
            if energy_count == 0 {
                return Ok(false);
            }
            workspace.next.fill(0);
            for &energy in &workspace.class_energies[..energy_count] {
                or_shifted(&mut workspace.next, &workspace.current, usize::from(energy));
            }
            std::mem::swap(&mut workspace.current, &mut workspace.next);
        }
        if block_weight != EXPECTED_BLOCK_WEIGHTS[block] {
            return Ok(false);
        }
    }
    Ok(
        workspace.current[Q18_GS_COMBINED_ENERGY / 64] & (1_u64 << (Q18_GS_COMBINED_ENERGY % 64))
            != 0,
    )
}

fn validate_summary(summary: Q174ClassSummary) -> Result<(), Q18EnergyGateError> {
    let zero = u16::from(summary.zero_columns);
    let full = u16::from(summary.full_columns);
    let columns = CRT_COLUMNS as u16;
    if zero + full > columns {
        return Err(Q18EnergyGateError::InvalidClassSummary);
    }
    let middle = columns - zero - full;
    let minimum = 3 * full + middle;
    let maximum = 3 * full + 2 * middle;
    if summary.total < minimum || summary.total > maximum {
        return Err(Q18EnergyGateError::InvalidClassSummary);
    }
    Ok(())
}

fn enumerate_class_energies(
    summary: Q174ClassSummary,
    output: &mut [u16; CLASS_ENERGY_VALUES],
    cap: usize,
) -> usize {
    let mut count = 0_usize;
    for low in summary.full_columns..=CRT_COLUMNS as u8 {
        let remaining = summary.total.checked_sub(u16::from(low));
        let Some(remaining) = remaining else {
            continue;
        };
        for middle in low..=CRT_COLUMNS as u8 {
            let Some(high) = remaining.checked_sub(u16::from(middle)) else {
                continue;
            };
            if high > CRT_COLUMNS as u16 || high < u16::from(middle) {
                continue;
            }
            let high = high as u8;
            if summary.zero_columns > CRT_COLUMNS as u8 - high {
                continue;
            }
            let signed = [high, middle, low].map(|degree| 2 * i16::from(degree) - 29);
            let energy = signed.iter().map(|&value| value * value).sum::<i16>() as usize;
            if energy > cap {
                continue;
            }
            let energy = energy as u16;
            if !output[..count].contains(&energy) {
                debug_assert!(count < CLASS_ENERGY_VALUES);
                output[count] = energy;
                count += 1;
            }
        }
    }
    count
}

#[inline(always)]
fn or_shifted(output: &mut [u64; Q18_ENERGY_WORDS], input: &[u64; Q18_ENERGY_WORDS], shift: usize) {
    let word_shift = shift / 64;
    let bit_shift = shift % 64;
    for source in 0..Q18_ENERGY_WORDS {
        let value = input[source];
        let target = source + word_shift;
        if target >= Q18_ENERGY_WORDS {
            break;
        }
        output[target] |= value << bit_shift;
        if bit_shift != 0 && target + 1 < Q18_ENERGY_WORDS {
            output[target + 1] |= value >> (64 - bit_shift);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;
    use crate::q18_q174_margin_lift::Q174_CLASSES;

    fn direct_class_energies(summary: Q174ClassSummary) -> [bool; 3 * 29 * 29 + 1] {
        let mut found = [false; 3 * 29 * 29 + 1];
        for first in 0_u8..=CRT_COLUMNS as u8 {
            for second in 0_u8..=CRT_COLUMNS as u8 {
                for third in 0_u8..=CRT_COLUMNS as u8 {
                    if u16::from(first) + u16::from(second) + u16::from(third) != summary.total {
                        continue;
                    }
                    let mut degrees = [first, second, third];
                    degrees.sort_unstable_by(|left, right| right.cmp(left));
                    if summary.zero_columns > CRT_COLUMNS as u8 - degrees[0]
                        || summary.full_columns > degrees[2]
                    {
                        continue;
                    }
                    let energy = degrees
                        .map(|degree| {
                            let signed = 2 * i16::from(degree) - 29;
                            signed * signed
                        })
                        .iter()
                        .sum::<i16>() as usize;
                    found[energy] = true;
                }
            }
        }
        found
    }

    #[test]
    fn exhaustive_class_energy_compiler_matches_direct_degree_oracle() {
        let mut energies = [0_u16; CLASS_ENERGY_VALUES];
        let mut maximum = 0_usize;
        for zero_columns in 0_u8..=29 {
            for full_columns in 0_u8..=29 - zero_columns {
                let middle_columns = 29 - zero_columns - full_columns;
                for degree_two_columns in 0_u8..=middle_columns {
                    let degree_one_columns = middle_columns - degree_two_columns;
                    let summary = Q174ClassSummary {
                        total: u16::from(
                            degree_one_columns + 2 * degree_two_columns + 3 * full_columns,
                        ),
                        zero_columns,
                        full_columns,
                    };
                    validate_summary(summary).unwrap();
                    let count =
                        enumerate_class_energies(summary, &mut energies, Q18_GS_COMBINED_ENERGY);
                    maximum = maximum.max(count);
                    let direct = direct_class_energies(summary);
                    let direct_minimum = direct.iter().position(|&present| present).unwrap() as u16;
                    assert_eq!(q18_class_minimum_energy(summary).unwrap(), direct_minimum);
                    for energy in 0..=Q18_GS_COMBINED_ENERGY {
                        assert_eq!(
                            energies[..count].contains(&(energy as u16)),
                            direct[energy],
                            "summary={summary:?}, energy={energy}"
                        );
                    }
                }
            }
        }
        assert!(maximum <= CLASS_ENERGY_VALUES);
    }

    #[test]
    fn gate_accepts_summaries_extracted_from_a_direct_binary_lift() {
        let mut summaries = [Q174MarginSummary::default(); BLOCKS];
        for (block, summary) in summaries.iter_mut().enumerate() {
            let degrees = [15_u8; 18];
            // Adjust totals to the required 262/261 and choose column degrees
            // by a deterministic round-robin direct table.
            let mut adjusted = degrees;
            let target = EXPECTED_BLOCK_WEIGHTS[block];
            let mut total = adjusted.iter().map(|&x| u16::from(x)).sum::<u16>();
            let mut cursor = 0;
            while total != target {
                adjusted[cursor] -= 1;
                total -= 1;
                cursor += 1;
            }
            for class in 0..Q174_CLASSES {
                let rows = [adjusted[class], adjusted[class + 6], adjusted[class + 12]];
                let mut column_degrees = [0_u8; CRT_COLUMNS];
                for (row, &degree) in rows.iter().enumerate() {
                    for offset in 0..usize::from(degree) {
                        column_degrees[(offset + 7 * row + 3 * class) % CRT_COLUMNS] += 1;
                    }
                }
                summary.classes[class] = Q174ClassSummary {
                    total: rows.iter().map(|&x| u16::from(x)).sum(),
                    zero_columns: column_degrees.iter().filter(|&&x| x == 0).count() as u8,
                    full_columns: column_degrees.iter().filter(|&&x| x == 3).count() as u8,
                };
            }
        }
        let mut workspace = Q18EnergyWorkspace::ZERO;
        // This direct lift need not hit the GS energy, but the gate must agree
        // with a direct DP over its compatible row-degree energy sets.
        let result = q18_energy_target_reachable_from_q174(&summaries, &mut workspace).unwrap();
        let mut direct = [false; Q18_GS_COMBINED_ENERGY + 1];
        direct[0] = true;
        for summary in &summaries {
            for class in summary.classes {
                let choices = direct_class_energies(class);
                let before = direct;
                direct.fill(false);
                for base in 0..=Q18_GS_COMBINED_ENERGY {
                    if !before[base] {
                        continue;
                    }
                    for energy in 0..=Q18_GS_COMBINED_ENERGY - base {
                        direct[base + energy] |= choices[energy];
                    }
                }
            }
        }
        assert_eq!(result, direct[Q18_GS_COMBINED_ENERGY]);
    }

    #[test]
    fn malformed_summary_fails_closed_and_hot_gate_allocates_nothing() {
        let valid = Q174ClassSummary {
            total: 43,
            zero_columns: 0,
            full_columns: 0,
        };
        let mut summaries = [Q174MarginSummary::default(); BLOCKS];
        for summary in &mut summaries {
            summary.classes = [valid; Q174_CLASSES];
        }
        // Restore exact block weights while preserving realizability.
        summaries[0].classes[0].total += 4;
        for block in 1..BLOCKS {
            summaries[block].classes[0].total += 3;
        }
        let mut workspace = Q18EnergyWorkspace::ZERO;
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..256 {
                let _ = q18_energy_target_reachable_from_q174(&summaries, &mut workspace).unwrap();
            }
        });
        assert_eq!(allocations, 0);

        summaries[0].classes[0].zero_columns = 30;
        assert_eq!(
            q18_energy_target_reachable_from_q174(&summaries, &mut workspace),
            Err(Q18EnergyGateError::InvalidClassSummary)
        );
    }
}
