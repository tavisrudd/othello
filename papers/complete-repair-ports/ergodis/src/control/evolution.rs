use super::{
    vm::evaluate_plan_cascaded, CompiledPlan, ControlError, FeatureBatch, PlanOp, PlanScope,
    PlanSpec,
};
use serde_json::{json, Value};
use std::collections::{BTreeMap, BTreeSet};
use std::fs::File;
use std::io::{BufWriter, Write};
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::Arc;

#[repr(C, align(64))]
pub(super) struct EvolutionProgress {
    tested: AtomicU64,
    generation: AtomicU64,
    perfect: AtomicU64,
    done: AtomicBool,
    cancelled: AtomicBool,
    _pad: [u8; 30],
}

const _: () = assert!(
    std::mem::size_of::<EvolutionProgress>() == 64
        && std::mem::align_of::<EvolutionProgress>() == 64
);

impl EvolutionProgress {
    pub(super) fn new() -> Self {
        Self {
            tested: AtomicU64::new(0),
            generation: AtomicU64::new(0),
            perfect: AtomicU64::new(0),
            done: AtomicBool::new(false),
            cancelled: AtomicBool::new(false),
            _pad: [0; 30],
        }
    }

    pub(super) fn cancel(&self) {
        self.cancelled.store(true, Ordering::Release);
    }

    pub(super) fn snapshot(&self) -> Value {
        json!({
            "tested": self.tested.load(Ordering::Relaxed),
            "generation": self.generation.load(Ordering::Relaxed),
            "perfect": self.perfect.load(Ordering::Relaxed),
            "done": self.done.load(Ordering::Acquire),
            "cancel_requested": self.cancelled.load(Ordering::Acquire),
        })
    }
}

#[derive(Clone, Copy)]
pub(super) struct EvolutionBounds {
    pub generations: usize,
    pub beam: usize,
    pub max_candidates: usize,
    pub byte_limit: u64,
}

struct ScopeMutationProfile {
    field: String,
    observed_mask: u64,
    positive_majority_mask: u64,
}

struct PendingCandidate {
    plan: PlanSpec,
    parent_hash: Option<String>,
    operator: &'static str,
}

type EvolutionRankKey = (std::cmp::Reverse<u64>, u64, usize);

#[inline]
fn evolution_rank_key(correct: u64, false_positive: u64, complexity: usize) -> EvolutionRankKey {
    (std::cmp::Reverse(correct), false_positive, complexity)
}

#[inline]
fn can_enter_beam(
    survivor_keys: &[EvolutionRankKey],
    beam: usize,
    maximum_correct: u64,
    false_positive: u64,
    complexity: usize,
) -> bool {
    survivor_keys.len() < beam
        || evolution_rank_key(maximum_correct, false_positive, complexity)
            <= survivor_keys[survivor_keys.len() - 1]
}

pub(super) fn run_evolution(
    batch: Arc<FeatureBatch>,
    current: Vec<PlanSpec>,
    output: File,
    bounds: EvolutionBounds,
    progress: Arc<EvolutionProgress>,
) -> Result<Value, ControlError> {
    // SAFETY: setpriority has no pointer arguments; `who = 0` selects only the
    // calling Linux task. Failure is reported in the job summary.
    let low_priority = unsafe { libc::setpriority(libc::PRIO_PROCESS, 0, 10) } == 0;
    let scope_profiles = scope_profiles(&batch)?;
    let mut writer = BufWriter::new(output);
    let mut bytes = 0_u64;
    let mut structural = BTreeSet::new();
    let mut outcome_classes = BTreeMap::new();
    let mut tested = 0_usize;
    let mut perfect = 0_usize;
    let mut structural_rejections = 0_usize;
    let mut outcome_expansion_rejections = 0_usize;
    let mut cascade_rejections = 0_usize;
    let mut rows_evaluated = 0_u64;
    let mut best: Option<(u64, u64, usize, PlanSpec)> = None;
    let mut truncated = false;
    let mut current = current
        .into_iter()
        .map(|plan| PendingCandidate {
            plan,
            parent_hash: None,
            operator: "seed",
        })
        .collect::<Vec<_>>();

    'generations: for generation in 0..bounds.generations {
        progress
            .generation
            .store(generation as u64, Ordering::Relaxed);
        let mut ranked = Vec::new();
        let mut survivor_keys = Vec::<EvolutionRankKey>::new();
        for pending in current.drain(..) {
            if tested == bounds.max_candidates || progress.cancelled.load(Ordering::Acquire) {
                break 'generations;
            }
            let mut plan = pending.plan;
            let structural_key = format!(
                "{:?}|{:?}|{:?}|{:?}",
                plan.role, plan.output, plan.scope, plan.program
            );
            if !structural.insert(structural_key) {
                structural_rejections += 1;
                continue;
            }
            plan.name = format!("evolve-g{generation}-c{tested}");
            let compiled = CompiledPlan::compile(&plan, &batch.fields)?;
            let can_enter = |false_positive: u64, maximum_correct: u64| {
                can_enter_beam(
                    &survivor_keys,
                    bounds.beam,
                    maximum_correct,
                    false_positive,
                    plan.program.len(),
                )
            };
            let (evaluation, examined) =
                evaluate_plan_cascaded(&batch, &compiled, Some(&can_enter))?;
            rows_evaluated = rows_evaluated.saturating_add(examined as u64);
            let Some(evaluation) = evaluation else {
                let record = json!({
                    "generation": generation,
                    "parent_hash": pending.parent_hash,
                    "operator": pending.operator,
                    "plan": &plan,
                    "hash": &compiled.hash,
                    "evaluation": null,
                    "cascade": {"rejected": true, "rows_evaluated": examined},
                });
                let mut encoded = serde_json::to_vec(&record)?;
                encoded.push(b'\n');
                if bytes.saturating_add(encoded.len() as u64) > bounds.byte_limit {
                    truncated = true;
                    break 'generations;
                }
                writer.write_all(&encoded)?;
                bytes += encoded.len() as u64;
                tested += 1;
                cascade_rejections += 1;
                progress.tested.store(tested as u64, Ordering::Relaxed);
                continue;
            };
            let equivalent_to = outcome_classes.get(&evaluation.outcome_hash).cloned();
            outcome_classes
                .entry(evaluation.outcome_hash.clone())
                .or_insert_with(|| plan.name.clone());
            let record = json!({
                "generation": generation,
                "parent_hash": pending.parent_hash,
                "operator": pending.operator,
                "plan": &plan,
                "hash": &compiled.hash,
                "equivalent_to": equivalent_to,
                "evaluation": &evaluation,
            });
            let mut encoded = serde_json::to_vec(&record)?;
            encoded.push(b'\n');
            if bytes.saturating_add(encoded.len() as u64) > bounds.byte_limit {
                truncated = true;
                break 'generations;
            }
            writer.write_all(&encoded)?;
            bytes += encoded.len() as u64;
            tested += 1;
            if evaluation.weighted_correct == evaluation.weighted_rows {
                perfect += 1;
            }
            let candidate_key = (
                evaluation.weighted_correct,
                evaluation.weighted_false_positive,
                plan.program.len(),
            );
            if best.as_ref().is_none_or(|best| {
                candidate_key.0 > best.0
                    || (candidate_key.0 == best.0 && candidate_key.1 < best.1)
                    || (candidate_key.0 == best.0
                        && candidate_key.1 == best.1
                        && candidate_key.2 < best.2)
            }) {
                best = Some((
                    candidate_key.0,
                    candidate_key.1,
                    candidate_key.2,
                    plan.clone(),
                ));
            }
            survivor_keys.push(evolution_rank_key(
                evaluation.weighted_correct,
                evaluation.weighted_false_positive,
                plan.program.len(),
            ));
            survivor_keys.sort_unstable();
            survivor_keys.truncate(bounds.beam);
            ranked.push((
                evaluation.weighted_correct,
                evaluation.weighted_false_positive,
                plan.program.len(),
                evaluation.outcome_hash,
                compiled.hash,
                plan,
            ));
            progress.tested.store(tested as u64, Ordering::Relaxed);
            progress.perfect.store(perfect as u64, Ordering::Relaxed);
        }
        if tested == bounds.max_candidates || generation + 1 == bounds.generations {
            break;
        }
        ranked.sort_unstable_by(|left, right| {
            right
                .0
                .cmp(&left.0)
                .then_with(|| left.1.cmp(&right.1))
                .then_with(|| left.2.cmp(&right.2))
                .then_with(|| left.5.name.cmp(&right.5.name))
        });
        let mut expanded_outcomes = BTreeSet::new();
        let mut expanded = 0_usize;
        for (_, _, _, outcome_hash, parent_hash, parent) in ranked {
            if expanded == bounds.beam {
                break;
            }
            if !expanded_outcomes.insert(outcome_hash) {
                outcome_expansion_rejections += 1;
                continue;
            }
            mutate_plan(
                &parent,
                &parent_hash,
                &batch.fields,
                &scope_profiles,
                &mut current,
                bounds.max_candidates.saturating_sub(tested),
            );
            expanded += 1;
            if current.len() >= bounds.max_candidates.saturating_sub(tested) {
                break;
            }
        }
    }
    writer.flush()?;
    progress.done.store(true, Ordering::Release);
    Ok(json!({
        "tested": tested,
        "perfect": perfect,
        "outcome_classes": outcome_classes.len(),
        "structural_rejections": structural_rejections,
        "outcome_expansion_rejections": outcome_expansion_rejections,
        "cascade_rejections": cascade_rejections,
        "rows_evaluated": rows_evaluated,
        "bytes": bytes,
        "truncated": truncated,
        "cancelled": progress.cancelled.load(Ordering::Acquire),
        "low_priority": low_priority,
        "best": best.map(|(correct, false_positive, complexity, plan)| json!({
            "weighted_correct": correct,
            "false_positive": false_positive,
            "complexity": complexity,
            "plan": plan,
        })),
    }))
}

fn scope_profiles(batch: &FeatureBatch) -> Result<Vec<ScopeMutationProfile>, ControlError> {
    let mut profiles = Vec::new();
    for field_name in ["root_orbit", "root_candidate"] {
        let Some(field) = batch.fields.iter().position(|name| name == field_name) else {
            continue;
        };
        let mut observed_mask = 0_u64;
        let mut weights = [[0_u64; 2]; 64];
        for row in 0..batch.rows() {
            let value = batch.row(row)[field];
            if !(0..64).contains(&value) {
                continue;
            }
            let value = value as usize;
            observed_mask |= 1_u64 << value;
            let label = usize::from(batch.expected(row));
            weights[value][label] = weights[value][label]
                .checked_add(batch.weights[row])
                .ok_or_else(|| ControlError::Invalid("scope weight overflow".into()))?;
        }
        if observed_mask == 0 {
            continue;
        }
        let positive_majority_mask = weights
            .iter()
            .enumerate()
            .filter(|(_, weight)| weight[1] > weight[0])
            .fold(0_u64, |mask, (value, _)| mask | (1_u64 << value));
        profiles.push(ScopeMutationProfile {
            field: field_name.into(),
            observed_mask,
            positive_majority_mask,
        });
    }
    Ok(profiles)
}

fn push_scoped_child(
    parent: &PlanSpec,
    parent_hash: &str,
    field: &str,
    mask: u64,
    operator: &'static str,
    output: &mut Vec<PendingCandidate>,
    limit: usize,
) -> bool {
    if mask == 0 || output.len() == limit {
        return output.len() == limit;
    }
    let mut child = parent.clone();
    child.scope = Some(PlanScope {
        field: field.to_owned(),
        mask,
    });
    output.push(PendingCandidate {
        plan: child,
        parent_hash: Some(parent_hash.into()),
        operator,
    });
    output.len() == limit
}

fn mutate_plan(
    parent: &PlanSpec,
    parent_hash: &str,
    fields: &[String],
    scope_profiles: &[ScopeMutationProfile],
    output: &mut Vec<PendingCandidate>,
    limit: usize,
) {
    for profile in scope_profiles {
        if parent
            .scope
            .as_ref()
            .is_some_and(|scope| scope.field == profile.field)
        {
            let current_mask = parent.scope.as_ref().map_or(0, |scope| scope.mask);
            let mut bits = profile.observed_mask;
            while bits != 0 {
                let bit = bits & bits.wrapping_neg();
                bits ^= bit;
                if push_scoped_child(
                    parent,
                    parent_hash,
                    &profile.field,
                    current_mask ^ bit,
                    "scope-toggle",
                    output,
                    limit,
                ) {
                    return;
                }
            }
        } else {
            let mut bits = profile.observed_mask;
            while bits != 0 {
                let bit = bits & bits.wrapping_neg();
                bits ^= bit;
                if push_scoped_child(
                    parent,
                    parent_hash,
                    &profile.field,
                    bit,
                    "scope-initialize",
                    output,
                    limit,
                ) {
                    return;
                }
            }
            if profile.positive_majority_mask != profile.observed_mask
                && push_scoped_child(
                    parent,
                    parent_hash,
                    &profile.field,
                    profile.positive_majority_mask,
                    "scope-majority",
                    output,
                    limit,
                )
            {
                return;
            }
        }
    }
    for (index, op) in parent.program.iter().enumerate() {
        let (operator, replacements): (&'static str, Vec<PlanOp>) = match op {
            PlanOp::Const { value } => (
                "constant-shift",
                [-8, -2, -1, 1, 2, 8]
                    .into_iter()
                    .filter_map(|delta| value.checked_add(delta))
                    .map(|value| PlanOp::Const { value })
                    .collect(),
            ),
            PlanOp::Field { name } => (
                "field-substitute",
                fields
                    .iter()
                    .filter(|field| *field != name)
                    .map(|name| PlanOp::Field { name: name.clone() })
                    .collect(),
            ),
            PlanOp::Eq | PlanOp::Ne | PlanOp::Lt | PlanOp::Le | PlanOp::Gt | PlanOp::Ge => (
                "comparison-substitute",
                vec![
                    PlanOp::Eq,
                    PlanOp::Ne,
                    PlanOp::Lt,
                    PlanOp::Le,
                    PlanOp::Gt,
                    PlanOp::Ge,
                ],
            ),
            PlanOp::And => ("boolean-flip", vec![PlanOp::Or]),
            PlanOp::Or => ("boolean-flip", vec![PlanOp::And]),
            _ => ("none", Vec::new()),
        };
        for replacement in replacements {
            if output.len() == limit {
                return;
            }
            let mut child = parent.clone();
            child.program[index] = replacement;
            output.push(PendingCandidate {
                plan: child,
                parent_hash: Some(parent_hash.into()),
                operator,
            });
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn cascade_gate_uses_the_reported_beam_order() {
        let mut survivors = vec![evolution_rank_key(90, 20, 4), evolution_rank_key(80, 0, 4)];
        survivors.sort_unstable();

        // More correct candidates beat a lower-false-positive survivor under
        // the published ordering; the old false-positive-first gate rejected
        // this candidate before its score could be observed.
        assert!(can_enter_beam(&survivors, 2, 85, 10, 4));
        assert!(!can_enter_beam(&survivors, 2, 79, 0, 1));
        assert!(can_enter_beam(&survivors, 2, 80, 0, 3));
    }
}
