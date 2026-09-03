//! C1051: evolve-style search over a typed grammar of lossless encoders.
//!
//! Spike driver. It builds the instance corpus, evaluates every grammar
//! pipeline exhaustively as the ground-truth control, runs the public core's
//! bounded evolution engine over the same grammar, and reports whether the
//! search rediscovers the known good representation for each observation
//! family.

pub mod alloc_guard;
mod instances;
mod scorer;
mod search;

use std::path::PathBuf;

use anyhow::{Context, Result};
use clap::Args as ClapArgs;
use ergodis::theorem_search::EvolutionConfig;
use ergodis_private::repr_grammar::{
    enumerate_pipelines, ObservationKind, Pipeline, Serializer, Transform, UsageWeights,
};
use serde::Serialize;
use serde_json::json;

use scorer::{probe_schedule, Evaluation, Measurement, ProbeSchedule, Scorer};

#[derive(ClapArgs, Debug)]
pub struct Args {
    /// Where to write the JSON evidence record.
    #[arg(long, default_value = "evidence/c1051-repr-search.json")]
    pub report: PathBuf,
    /// Drop every measured timing, so two runs are byte-identical. Ranking then
    /// falls back to declared bytes, then syntax cost.
    #[arg(long)]
    pub deterministic: bool,
    /// Timed rounds per operation; the median round is reported.
    #[arg(long, default_value_t = 7)]
    pub rounds: usize,
    /// Iterations inside one timed round.
    #[arg(long, default_value_t = 4)]
    pub iterations: usize,
    /// Probes in the fixed probe schedule.
    #[arg(long, default_value_t = 256)]
    pub probes: usize,
    /// Generations for the bounded evolution engine.
    #[arg(long, default_value_t = 6)]
    pub generations: usize,
    /// Beam width for the bounded evolution engine.
    #[arg(long, default_value_t = 4)]
    pub beam_width: usize,
    /// Hard candidate cap for the bounded evolution engine.
    #[arg(long, default_value_t = 128)]
    pub max_candidates: usize,
}

#[derive(Serialize)]
struct RankedRow {
    rank: usize,
    #[serde(flatten)]
    evaluation: Evaluation,
}

/// The control representation from the C1051 survey's R4 row.
fn control_pipeline() -> Pipeline {
    Pipeline::new(vec![Transform::WindowClip], Serializer::BitPack)
        .expect("window-clip . bitpack is a valid depth-2 pipeline")
}

fn rank(mut evaluations: Vec<Evaluation>, deterministic: bool) -> Vec<Evaluation> {
    evaluations.sort_by(|left, right| {
        right
            .admitted
            .cmp(&left.admitted)
            .then_with(|| {
                if deterministic {
                    let left_bytes = left.cost.map(|cost| cost.encoded_bytes).unwrap_or(u64::MAX);
                    let right_bytes = right
                        .cost
                        .map(|cost| cost.encoded_bytes)
                        .unwrap_or(u64::MAX);
                    left_bytes.cmp(&right_bytes)
                } else {
                    left.objective
                        .unwrap_or(f64::INFINITY)
                        .total_cmp(&right.objective.unwrap_or(f64::INFINITY))
                }
            })
            .then_with(|| {
                let left_syntax = left.cost.map(|cost| cost.syntax_cost).unwrap_or(u32::MAX);
                let right_syntax = right.cost.map(|cost| cost.syntax_cost).unwrap_or(u32::MAX);
                left_syntax.cmp(&right_syntax)
            })
            .then_with(|| left.pipeline.cmp(&right.pipeline))
    });
    evaluations
}

/// A second, weight-free ranking: exact bytes, then probe cycles, then syntax.
/// Reported alongside the declared objective so a reader can see how much of
/// the verdict comes from the byte-to-cycle exchange rate.
fn rank_bytes_first(mut evaluations: Vec<Evaluation>) -> Vec<Evaluation> {
    evaluations.sort_by(|left, right| {
        right
            .admitted
            .cmp(&left.admitted)
            .then_with(|| {
                let left_bytes = left.cost.map(|cost| cost.encoded_bytes).unwrap_or(u64::MAX);
                let right_bytes = right
                    .cost
                    .map(|cost| cost.encoded_bytes)
                    .unwrap_or(u64::MAX);
                left_bytes.cmp(&right_bytes)
            })
            .then_with(|| {
                let left_probe = left
                    .cost
                    .map(|cost| cost.probe_cycles())
                    .unwrap_or(f64::INFINITY);
                let right_probe = right
                    .cost
                    .map(|cost| cost.probe_cycles())
                    .unwrap_or(f64::INFINITY);
                left_probe.total_cmp(&right_probe)
            })
            .then_with(|| left.pipeline.cmp(&right.pipeline))
    });
    evaluations
}

pub fn run(args: Args) -> Result<()> {
    let corpus = instances::corpus()?;
    let max_elements = corpus
        .iter()
        .flat_map(|instance| {
            std::iter::once(instance.training.len())
                .chain(instance.holdout.iter().map(|observation| observation.len()))
        })
        .max()
        .unwrap_or(0);
    let max_universe = corpus
        .iter()
        .flat_map(|instance| {
            std::iter::once(instance.training.universe()).chain(
                instance
                    .holdout
                    .iter()
                    .map(|observation| observation.universe()),
            )
        })
        .max()
        .unwrap_or(0) as usize;

    let measurement = Measurement {
        warmup: 2,
        rounds: args.rounds,
        iterations: args.iterations,
        probes: args.probes,
    };
    let mut scorer = Scorer::new(
        max_elements + 8,
        max_universe + 64,
        measurement,
        !args.deterministic,
    );
    let grammar = enumerate_pipelines();
    let control = control_pipeline();

    let mut instance_records = Vec::new();
    let mut result_records = Vec::new();

    for instance in &corpus {
        let weights = UsageWeights::for_kind(instance.training.kind(), instance.training.len());
        let training_schedule = probe_schedule(&instance.training, args.probes, 0xc105_1000);
        let holdout = instance
            .holdout
            .iter()
            .enumerate()
            .map(|(index, observation)| {
                let schedule =
                    probe_schedule(observation, args.probes.min(64), 0xc105_2000 + index as u64);
                (observation.clone(), schedule)
            })
            .collect::<Vec<(_, ProbeSchedule)>>();

        // Exhaustive control ranking over the whole grammar.
        let exhaustive = grammar
            .iter()
            .map(|pipeline| {
                scorer.evaluate(
                    pipeline,
                    &instance.training,
                    &training_schedule,
                    &holdout,
                    weights,
                )
            })
            .collect::<Vec<_>>();
        let admitted = exhaustive.iter().filter(|row| row.admitted).count();
        let bytes_first = rank_bytes_first(exhaustive.clone());
        let ranked = rank(exhaustive, args.deterministic);
        let control_bytes_rank = bytes_first
            .iter()
            .position(|row| row.pipeline == control.name())
            .map(|position| position + 1);

        // The bounded evolution engine over the same grammar.
        let mut driver = search::ReprDriver::new(
            &mut scorer,
            &instance.training,
            &training_schedule,
            &holdout,
            weights,
        );
        let summary = search::run_evolution(
            &mut driver,
            EvolutionConfig {
                generations: args.generations,
                beam_width: args.beam_width,
                max_candidates: args.max_candidates,
            },
        );
        let searched = driver.evaluations.len();
        let evolved = rank(
            driver.evaluations.values().cloned().collect::<Vec<_>>(),
            args.deterministic,
        );
        let search_best = evolved.first().map(|row| row.pipeline.clone());
        let exhaustive_best = ranked.first().map(|row| row.pipeline.clone());
        let control_name = control.name();
        let control_rank = ranked
            .iter()
            .position(|row| row.pipeline == control_name)
            .map(|position| position + 1);
        let control_row = ranked.iter().find(|row| row.pipeline == control_name);
        let search_found_control = search_best.as_deref() == Some(control_name.as_str());
        let search_no_worse_than_control = match (
            &evolved.first().and_then(|row| row.cost),
            control_row.and_then(|row| row.cost),
        ) {
            (Some(best), Some(control)) => {
                best.encoded_bytes <= control.encoded_bytes
                    && best.probe_cycles() <= control.probe_cycles()
            }
            _ => false,
        };

        instance_records.push(json!({
            "name": instance.name,
            "family": instance.family,
            "kind": instance.training.kind(),
            "elements": instance.training.len(),
            "universe": instance.training.universe(),
            "reference_bytes": instance.training.reference_bytes(),
            "entropy_bound_bytes": instance.training.entropy_bound_bytes(),
            "fingerprint": instance.fingerprint,
            "holdout_fingerprints": instance.holdout.iter().map(instances::fingerprint).collect::<Vec<_>>(),
            "note": instance.note,
        }));

        result_records.push(json!({
            "instance": instance.name,
            "usage_weights": weights,
            "grammar_size": grammar.len(),
            "admitted_candidates": admitted,
            "exhaustive_top": ranked
                .iter()
                .take(3)
                .cloned()
                .enumerate()
                .map(|(index, evaluation)| RankedRow { rank: index + 1, evaluation })
                .collect::<Vec<_>>(),
            "rejected_examples": ranked
                .iter()
                .filter(|row| !row.admitted)
                .take(4)
                .cloned()
                .collect::<Vec<_>>(),
            "exhaustive_best": exhaustive_best,
            "bytes_first_top": bytes_first
                .iter()
                .take(3)
                .cloned()
                .enumerate()
                .map(|(index, evaluation)| RankedRow { rank: index + 1, evaluation })
                .collect::<Vec<_>>(),
            "control_bytes_first_rank": control_bytes_rank,
            "search": {
                "engine": "ergodis::theorem_search::drive_ranked_evolution_streaming",
                "trials": summary.trials,
                "distinct_evaluations": searched,
                "grammar_size": grammar.len(),
                "best": search_best,
                "best_is_exhaustive_best": search_best == exhaustive_best,
                "top": evolved
                    .iter()
                    .take(3)
                    .cloned()
                    .enumerate()
                    .map(|(index, evaluation)| RankedRow { rank: index + 1, evaluation })
                    .collect::<Vec<_>>(),
            },
            "control": {
                "pipeline": control_name,
                "exhaustive_rank": control_rank,
                "cost": control_row.and_then(|row| row.cost),
                "objective": control_row.and_then(|row| row.objective),
                "search_returned_control": search_found_control,
                "search_no_worse_by_bytes_and_probe_cycles": search_no_worse_than_control,
            },
        }));

        println!(
            "{:<20} kind={:?} n={} u={} admitted={}/{} exhaustive-best={} search-best={} \
             control-rank={:?} evals={}/{}",
            instance.name,
            instance.training.kind(),
            instance.training.len(),
            instance.training.universe(),
            admitted,
            grammar.len(),
            exhaustive_best.as_deref().unwrap_or("-"),
            search_best.as_deref().unwrap_or("-"),
            control_rank,
            searched,
            grammar.len(),
        );
    }

    let report = json!({
        "task": "C1051",
        "lane": "complete-ports",
        "kind": "spike",
        "deterministic": args.deterministic,
        "grammar": {
            "transforms": ["window-clip", "delta", "zigzag", "canonical-permutation"],
            "serializers": [
                "identity", "narrow", "varint", "elias-fano", "run-length", "bitpack", "dictionary"
            ],
            "max_depth": 3,
            "size": grammar.len(),
            "observation_kinds": [
                ObservationKind::SortedIds,
                ObservationKind::DenseBitmap,
                ObservationKind::SmallIntVector
            ],
        },
        "measurement": {
            "clock": "reference cycles from the invariant time-stamp counter",
            "warmup": measurement.warmup,
            "rounds": measurement.rounds,
            "iterations": measurement.iterations,
            "probes": measurement.probes,
            "statistic": "median over rounds of the per-operation cost",
        },
        "admission": {
            "round_trip_identity": "training and every held-out observation",
            "probe_agreement": "every query in the fixed schedule, exactly",
            "allocation": "zero allocator events in decode and probe",
        },
        "instances": instance_records,
        "results": result_records,
    });

    if let Some(parent) = args.report.parent() {
        std::fs::create_dir_all(parent)
            .with_context(|| format!("creating {}", parent.display()))?;
    }
    std::fs::write(&args.report, serde_json::to_vec_pretty(&report)?)
        .with_context(|| format!("writing {}", args.report.display()))?;
    println!("report written to {}", args.report.display());
    Ok(())
}
