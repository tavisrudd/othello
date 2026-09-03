//! Exact-plus-measured scoring and admission for one encoder candidate.
//!
//! A candidate is admitted only when it round-trips the training observation
//! and every held-out observation exactly, answers every probe in the schedule
//! exactly, and allocates nothing in its decode and probe paths. Admission is
//! decided before any score is reported; a rejected candidate is never ranked.

use ergodis_private::repr_grammar::{
    decode, encode, probe_batch, reference_cycles, CostVector, EncodeError, Observation, Pipeline,
    ProbeAnswer, ProbeClass, ProbeQuery, ReprWorkspace, UsageWeights,
};
use serde::Serialize;

use super::alloc_guard;
use super::instances::SplitMix;

/// Measurement schedule. Warm-up runs are discarded; the reported figure is the
/// median over rounds of the per-operation cost within a round.
#[derive(Clone, Copy, Debug)]
pub struct Measurement {
    pub warmup: usize,
    pub rounds: usize,
    pub iterations: usize,
    pub probes: usize,
}

impl Default for Measurement {
    fn default() -> Self {
        Self {
            warmup: 2,
            rounds: 7,
            iterations: 4,
            probes: 256,
        }
    }
}

/// A deterministic probe schedule and its reference answers.
pub struct ProbeSchedule {
    pub queries: Vec<ProbeQuery>,
    pub answers: Vec<ProbeAnswer>,
}

pub fn probe_schedule(observation: &Observation, count: usize, seed: u64) -> ProbeSchedule {
    let mut generator = SplitMix::new(seed);
    let mut queries = Vec::with_capacity(count);
    let mut answers = Vec::with_capacity(count);
    for index in 0..count {
        let query = if observation.kind().membership_probe() {
            // Half hits, half uniform draws from the universe.
            let target = if index % 2 == 0 {
                observation.values()[generator.below(observation.len() as u64) as usize]
            } else {
                generator.below(observation.universe()) as i64
            };
            ProbeQuery::Contains(target)
        } else {
            ProbeQuery::Get(generator.below(observation.len() as u64 + 4) as u32)
        };
        let answer = match query {
            ProbeQuery::Contains(target) => {
                ProbeAnswer::Present(observation.values().binary_search(&target).is_ok())
            }
            ProbeQuery::Get(index) => {
                ProbeAnswer::Value(observation.values().get(index as usize).copied())
            }
        };
        queries.push(query);
        answers.push(answer);
    }
    ProbeSchedule { queries, answers }
}

/// The verdict for one candidate on one instance.
#[derive(Clone, Debug, Serialize)]
pub struct Evaluation {
    pub pipeline: String,
    pub admitted: bool,
    pub rejection: Option<String>,
    pub probe_class: Option<ProbeClass>,
    pub cost: Option<CostVector>,
    pub objective: Option<f64>,
    pub allocator_events: u64,
}

impl Evaluation {
    fn rejected(pipeline: &Pipeline, reason: String) -> Self {
        Self {
            pipeline: pipeline.name(),
            admitted: false,
            rejection: Some(reason),
            probe_class: None,
            cost: None,
            objective: None,
            allocator_events: 0,
        }
    }
}

fn describe(error: EncodeError) -> String {
    format!("{error:?}")
}

/// Encode, verify, and measure one candidate against one instance.
pub struct Scorer {
    pub workspace: ReprWorkspace,
    pub measurement: Measurement,
    pub timing: bool,
    /// Presized probe-answer buffer, so the measured probe path never grows a
    /// container.
    answers: Vec<ProbeAnswer>,
}

impl Scorer {
    pub fn new(
        max_elements: usize,
        max_universe: usize,
        measurement: Measurement,
        timing: bool,
    ) -> Self {
        Self {
            workspace: ReprWorkspace::new(max_elements, max_universe),
            answers: vec![ProbeAnswer::Present(false); measurement.probes.max(1)],
            measurement,
            timing,
        }
    }

    /// Round-trip and probe agreement on one observation. Returns the first
    /// disagreement as a compact reason.
    fn verify(
        &mut self,
        pipeline: &Pipeline,
        observation: &Observation,
        schedule: &ProbeSchedule,
        label: &str,
    ) -> Result<(), String> {
        let image = encode(pipeline, observation, &mut self.workspace)
            .map_err(|error| format!("{label}: encode {}", describe(error)))?;
        let count = decode(pipeline, &image, &mut self.workspace)
            .map_err(|error| format!("{label}: decode {}", describe(error)))?;
        if count != observation.len() || self.workspace.decoded()[..count] != *observation.values()
        {
            return Err(format!("{label}: round-trip identity failed"));
        }
        let taken = schedule.queries.len();
        probe_batch(
            pipeline,
            &image,
            &self.workspace,
            &schedule.queries,
            &mut self.answers[..taken],
        );
        for (index, (actual, expected)) in self.answers[..taken]
            .iter()
            .zip(schedule.answers.iter())
            .enumerate()
        {
            if actual != expected {
                return Err(format!(
                    "{label}: probe {index} disagreed ({actual:?} vs {expected:?})"
                ));
            }
        }
        Ok(())
    }

    pub fn evaluate(
        &mut self,
        pipeline: &Pipeline,
        training: &Observation,
        training_schedule: &ProbeSchedule,
        holdout: &[(Observation, ProbeSchedule)],
        weights: UsageWeights,
    ) -> Evaluation {
        if let Err(reason) = self.verify(pipeline, training, training_schedule, "training") {
            return Evaluation::rejected(pipeline, reason);
        }
        for (index, (observation, schedule)) in holdout.iter().enumerate() {
            if let Err(reason) =
                self.verify(pipeline, observation, schedule, &format!("holdout-{index}"))
            {
                return Evaluation::rejected(pipeline, reason);
            }
        }

        // Re-encode the training instance so the measured image is the one in
        // the workspace, then check the decode and probe paths allocate nothing.
        let image = match encode(pipeline, training, &mut self.workspace) {
            Ok(image) => image,
            Err(error) => {
                return Evaluation::rejected(
                    pipeline,
                    format!("training: encode {}", describe(error)),
                )
            }
        };
        let taken = training_schedule.queries.len();
        let workspace = &mut self.workspace;
        let answers = &mut self.answers;
        let ((), allocator_events) = alloc_guard::measure(|| {
            let _ = decode(pipeline, &image, workspace);
            probe_batch(
                pipeline,
                &image,
                workspace,
                &training_schedule.queries,
                &mut answers[..taken],
            );
        });
        if allocator_events != 0 {
            return Evaluation::rejected(
                pipeline,
                format!("decode or probe allocated {allocator_events} times"),
            );
        }

        let (encode_cycles, decode_cycles, probe_cycles_q16, precondition_cycles) = if self.timing {
            self.measure(pipeline, training, training_schedule)
        } else {
            (0, 0, 0, 0)
        };
        let cost = CostVector::new(
            image.header.declared_bytes(pipeline.descriptor()),
            encode_cycles,
            decode_cycles,
            probe_cycles_q16,
            precondition_cycles,
            self.workspace.working_bytes(training.len()),
            pipeline.syntax_cost(),
        );
        let objective = weights.objective(&cost);
        Evaluation {
            pipeline: pipeline.name(),
            admitted: true,
            rejection: None,
            probe_class: Some(pipeline.probe_class()),
            cost: Some(cost),
            objective: Some(objective),
            allocator_events,
        }
    }

    fn measure(
        &mut self,
        pipeline: &Pipeline,
        training: &Observation,
        schedule: &ProbeSchedule,
    ) -> (u64, u64, u64, u64) {
        let Measurement {
            warmup,
            rounds,
            iterations,
            ..
        } = self.measurement;
        let taken = schedule.queries.len();
        for _ in 0..warmup {
            if let Ok(image) = encode(pipeline, training, &mut self.workspace) {
                let _ = decode(pipeline, &image, &mut self.workspace);
                probe_batch(
                    pipeline,
                    &image,
                    &self.workspace,
                    &schedule.queries,
                    &mut self.answers[..taken],
                );
            }
        }
        let mut encode_samples = Vec::with_capacity(rounds);
        let mut decode_samples = Vec::with_capacity(rounds);
        let mut probe_samples = Vec::with_capacity(rounds);
        let mut precondition_samples = Vec::with_capacity(rounds);
        for _ in 0..rounds {
            let started = reference_cycles();
            let mut image = None;
            let mut precondition = 0_u64;
            for _ in 0..iterations {
                let encoded = encode(pipeline, training, &mut self.workspace)
                    .expect("candidate already verified on the training instance");
                precondition += encoded.precondition_cycles;
                image = Some(encoded);
            }
            let after_encode = reference_cycles();
            let image = image.expect("at least one iteration");
            for _ in 0..iterations {
                let _ = decode(pipeline, &image, &mut self.workspace);
            }
            let after_decode = reference_cycles();
            for _ in 0..iterations {
                probe_batch(
                    pipeline,
                    &image,
                    &self.workspace,
                    &schedule.queries,
                    &mut self.answers[..taken],
                );
                std::hint::black_box(&self.answers[0]);
            }
            let after_probe = reference_cycles();
            let per_iteration = iterations as u64;
            let precondition = precondition / per_iteration;
            precondition_samples.push(precondition);
            // Preconditions run inside encode, so charge them once, separately.
            encode_samples.push(
                (after_encode.saturating_sub(started) / per_iteration).saturating_sub(precondition),
            );
            decode_samples.push(after_decode.saturating_sub(after_encode) / per_iteration);
            let probe_total = after_probe.saturating_sub(after_decode);
            let probes = per_iteration * schedule.queries.len().max(1) as u64;
            probe_samples.push((probe_total << 16) / probes);
        }
        (
            median(&mut encode_samples),
            median(&mut decode_samples),
            median(&mut probe_samples),
            median(&mut precondition_samples),
        )
    }
}

fn median(samples: &mut [u64]) -> u64 {
    samples.sort_unstable();
    samples[samples.len() / 2]
}
