//! The evolution driver over the encoder grammar.
//!
//! This reuses the public core's runner-neutral bounded evolution engine
//! (`theorem_search::drive_ranked_evolution_streaming` and
//! `RankedEvolutionDriver`) unchanged: the candidate type is a typed encoder
//! pipeline instead of a predicate, and the score is the declared representation
//! objective instead of an implication score. Parent selection uses the core's
//! quality-diversity schedule with the serializer as the niche descriptor, so a
//! cheap serializer family cannot crowd out the others before its compositions
//! have been tried.

use std::cmp::Ordering;
use std::collections::BTreeMap;
use std::convert::Infallible;

use ergodis::theorem_search::{
    drive_ranked_evolution_streaming, select_quality_diversity_parents, EvolutionConfig,
    QualityDiversitySchedule, RankedCandidateTrial, RankedEvolutionDriver, RankedEvolutionSummary,
};
use ergodis_private::repr_grammar::{
    Descriptor, Observation, Pipeline, Serializer, Transform, UsageWeights, MAX_TRANSFORMS,
};

use super::scorer::{Evaluation, ProbeSchedule, Scorer};

const TRANSFORMS: [Transform; 4] = [
    Transform::WindowClip,
    Transform::Delta,
    Transform::Zigzag,
    Transform::CanonicalPermutation,
];

const DESCRIPTORS: [Descriptor; 3] = [
    Descriptor::Runtime,
    Descriptor::Packed,
    Descriptor::TypeCarried,
];

const SERIALIZERS: [Serializer; 7] = [
    Serializer::Fixed64,
    Serializer::Narrow,
    Serializer::Varint,
    Serializer::EliasFano,
    Serializer::RunLength,
    Serializer::BitPack,
    Serializer::Dictionary,
];

/// The engine's score type. Inadmissible candidates sort last and are never
/// promoted; the objective is the declared usage-weighted cost.
#[derive(Clone, Debug)]
pub struct Score {
    pub admitted: bool,
    pub objective: f64,
}

/// One-node neighbours of a pipeline: swap the serializer, append, drop, or
/// replace one transform. Deterministic and sorted.
pub fn neighbours(pipeline: &Pipeline) -> Vec<Pipeline> {
    let mut output = Vec::new();
    for serializer in SERIALIZERS {
        if serializer != pipeline.serializer() {
            if let Some(candidate) = Pipeline::with_descriptor(
                pipeline.transforms().to_vec(),
                serializer,
                pipeline.descriptor(),
            ) {
                output.push(candidate);
            }
        }
    }
    if pipeline.transforms().len() < MAX_TRANSFORMS {
        for step in TRANSFORMS {
            for position in 0..=pipeline.transforms().len() {
                let mut transforms = pipeline.transforms().to_vec();
                transforms.insert(position, step);
                if let Some(candidate) = Pipeline::with_descriptor(
                    transforms,
                    pipeline.serializer(),
                    pipeline.descriptor(),
                ) {
                    output.push(candidate);
                }
            }
        }
    }
    for position in 0..pipeline.transforms().len() {
        let mut transforms = pipeline.transforms().to_vec();
        transforms.remove(position);
        if let Some(candidate) =
            Pipeline::with_descriptor(transforms, pipeline.serializer(), pipeline.descriptor())
        {
            output.push(candidate);
        }
        for step in TRANSFORMS {
            let mut transforms = pipeline.transforms().to_vec();
            transforms[position] = step;
            if let Some(candidate) =
                Pipeline::with_descriptor(transforms, pipeline.serializer(), pipeline.descriptor())
            {
                output.push(candidate);
            }
        }
    }
    for descriptor in DESCRIPTORS {
        if descriptor != pipeline.descriptor() {
            if let Some(candidate) = Pipeline::with_descriptor(
                pipeline.transforms().to_vec(),
                pipeline.serializer(),
                descriptor,
            ) {
                output.push(candidate);
            }
        }
    }
    output.sort();
    output.dedup();
    output.retain(|candidate| candidate != pipeline);
    output
}

/// The seeds handed to the engine: the bare serializers, no transforms.
pub fn seeds() -> Vec<Pipeline> {
    SERIALIZERS
        .into_iter()
        .filter_map(|serializer| Pipeline::new(Vec::new(), serializer))
        .collect()
}

pub struct ReprDriver<'a> {
    scorer: &'a mut Scorer,
    training: &'a Observation,
    training_schedule: &'a ProbeSchedule,
    holdout: &'a [(Observation, ProbeSchedule)],
    weights: UsageWeights,
    schedule: QualityDiversitySchedule,
    /// Every distinct candidate the engine actually evaluated.
    pub evaluations: BTreeMap<Pipeline, Evaluation>,
}

impl<'a> ReprDriver<'a> {
    pub fn new(
        scorer: &'a mut Scorer,
        training: &'a Observation,
        training_schedule: &'a ProbeSchedule,
        holdout: &'a [(Observation, ProbeSchedule)],
        weights: UsageWeights,
    ) -> Self {
        Self {
            scorer,
            training,
            training_schedule,
            holdout,
            weights,
            schedule: QualityDiversitySchedule::new(2, 1).expect("both phase lengths are positive"),
            evaluations: BTreeMap::new(),
        }
    }
}

impl RankedEvolutionDriver<Pipeline, Score> for ReprDriver<'_> {
    type Error = Infallible;

    fn evaluate(&mut self, _generation: u32, candidate: &Pipeline) -> Result<Score, Infallible> {
        let evaluation = self.scorer.evaluate(
            candidate,
            self.training,
            self.training_schedule,
            self.holdout,
            self.weights,
        );
        let score = Score {
            admitted: evaluation.admitted,
            objective: evaluation.objective.unwrap_or(f64::INFINITY),
        };
        self.evaluations.insert(candidate.clone(), evaluation);
        Ok(score)
    }

    fn compare_scores(&self, left: &Score, right: &Score) -> Ordering {
        right
            .admitted
            .cmp(&left.admitted)
            .then_with(|| left.objective.total_cmp(&right.objective))
    }

    fn admitted(&self, score: &Score) -> bool {
        score.admitted
    }

    fn select_parents(
        &mut self,
        generation: u32,
        trials: &mut [RankedCandidateTrial<Pipeline, Score>],
        beam_width: usize,
        output: &mut Vec<Pipeline>,
    ) -> Result<(), Infallible> {
        select_quality_diversity_parents(
            generation,
            trials,
            beam_width,
            self.schedule,
            |left: &Score, right: &Score| {
                right
                    .admitted
                    .cmp(&left.admitted)
                    .then_with(|| left.objective.total_cmp(&right.objective))
            },
            |candidate: &Pipeline, _: &Score| candidate.serializer(),
            output,
        );
        Ok(())
    }

    fn mutate(
        &mut self,
        _generation: u32,
        parent: &Pipeline,
        output: &mut Vec<Pipeline>,
    ) -> Result<(), Infallible> {
        output.extend(neighbours(parent));
        Ok(())
    }
}

/// Run the core engine over the grammar for one instance.
pub fn run_evolution(
    driver: &mut ReprDriver<'_>,
    config: EvolutionConfig,
) -> RankedEvolutionSummary<Pipeline, Score> {
    drive_ranked_evolution_streaming(seeds(), config, driver, |_| Ok::<(), Infallible>(()))
        .expect("the driver and sink are infallible and the config bounds are positive")
}
