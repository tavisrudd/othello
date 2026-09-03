//! Planted theorem-gap corpus and admission-boundary measurement.
//!
//! The command writes a planted training/direct-model view pair, runs the blind
//! evolve harness against the training view alone, exhaustively enumerates a
//! declared conjunction domain over the training view, and replays every
//! corpus-perfect candidate against the complete direct model through the
//! existing bounded theorem archive. Every rejection retains a replayable
//! counterexample row.
//!
//! The proposer never sees the direct-model view. Nothing here claims general
//! admission soundness, transfer to unplanted corpora, or discovery: the
//! planted corpus tests one boundary on one deterministic family.

use std::io::{BufRead, BufReader};
use std::path::{Path, PathBuf};
use std::thread;

use anyhow::{bail, Context, Result};
use clap::Args as ClapArgs;
use ergodis::control::{
    send_request, Campaign, CompiledPlan, PlanSpec, MAX_FRAME_BYTES, PLAN_SCHEMA,
};
use ergodis::theorem_search::{SoundTheoremArchive, TheoremArchiveAdmission};
use ergodis_private::planted_gap_corpus::{
    planted_residuals, planted_source_digest, planted_truth, write_planted_view,
    PlantedCorpusReport, PlantedView, PLANTED_COORDINATES, PLANTED_EXPANDED_FIELDS,
};
use serde::Serialize;
use serde_json::{json, Value};
use sha2::{Digest, Sha256};

use super::blind_holdout::{
    evolve, generic_constant_conjunction, read_generic_corpus, require_ok, shutdown,
    wait_until_ready, GenericCorpus,
};

/// Declared constant alphabet of the exhaustive conjunction domain.
const DOMAIN_CONSTANTS: [i64; 9] = [-4, -3, -2, -1, 0, 1, 2, 3, 4];
/// Declared maximum number of literals per enumerated conjunction.
const DOMAIN_MAX_LITERALS: usize = 3;
/// Bound on the number of swept rejections retained in full in the certificate.
const MAX_RETAINED_SWEEP_REJECTIONS: usize = 64;
/// Bounded theorem archive capacity for the admission run.
const ARCHIVE_POINTS: usize = 64;

const RESPONSE_LIMIT: usize = 64 * 1024;
const EVOLVE_EVIDENCE_NAME: &str = "planted-gap-training";
const EVOLVE_GENERATIONS: u64 = 4;
const EVOLVE_BEAM: u64 = 32;
const EVOLVE_MAX_CANDIDATES: u64 = 1_000;

#[derive(Debug, ClapArgs)]
pub struct Arguments {
    /// Directory to create; holds both views, the campaign run root, and the certificate.
    #[arg(long)]
    output_dir: PathBuf,
}

#[derive(Clone, Debug, Serialize)]
struct Literal {
    field: usize,
    constant: i64,
}

#[derive(Clone, Debug, Serialize)]
struct Counterexample {
    /// Direct-model row index; replay with `planted_residuals(DirectModel, row)`.
    row: usize,
    residuals: [i64; PLANTED_COORDINATES],
    /// The candidate claims this row; the direct model does not.
    claimed: bool,
    expected: bool,
}

#[derive(Clone, Debug, Serialize)]
struct CandidateVerdict {
    name: String,
    origin: &'static str,
    literals: Option<Vec<Literal>>,
    plan_digest: String,
    training_covered: u64,
    training_false_positives: u64,
    direct_model_covered: u64,
    direct_model_false_positives: u64,
    admission: String,
    counterexample: Option<Counterexample>,
}

#[derive(Clone, Debug, Serialize)]
struct DomainReport {
    fields: usize,
    constants: usize,
    maximum_literals: usize,
    declared_conjunctions: u64,
    live_literals: usize,
    enumerated_conjunctions: u64,
    corpus_perfect: u64,
    stop_condition: &'static str,
    pruning_argument: &'static str,
}

#[derive(Clone, Debug, Serialize)]
struct ProposerReport {
    proposer: &'static str,
    selected_fields: usize,
    training_rows: u64,
    tree_nodes: u64,
    tree_depth: u64,
    evolve_generations: u64,
    evolve_beam: u64,
    evolve_max_candidates: u64,
    evolve_tested: u64,
    evolve_perfect: u64,
    evidence_records: usize,
    distinct_proposed_predicates: usize,
    unreplayable_proposals: usize,
    context: &'static str,
}

#[derive(Clone, Debug, Serialize)]
struct AdmissionTotals {
    candidates_screened: u64,
    admitted: u64,
    rejected_unsound: u64,
    rejected_other: u64,
    retained_sweep_rejections: usize,
    /// Proposals retained individually: perfect on the training view and
    /// claiming at least one training row.
    retained_evolve_proposals: usize,
    /// Proposals with no training false positive, vacuous ones included.
    evolve_zero_false_positive: usize,
    /// Proposals outside the replayable predicate shape; never admitted.
    uncompilable_proposals: usize,
    by_origin: Vec<OriginTotals>,
}

#[derive(Clone, Debug, Serialize)]
struct OriginTotals {
    origin: &'static str,
    screened: u64,
    admitted: u64,
    rejected_unsound: u64,
    rejected_other: u64,
}

#[derive(Serialize)]
struct Certificate {
    schema: &'static str,
    planted_source_digest: String,
    views: Vec<PlantedCorpusReport>,
    view_digests: Vec<String>,
    domain: DomainReport,
    proposer: ProposerReport,
    planted_predicates: Vec<CandidateVerdict>,
    evolve_proposals: Vec<CandidateVerdict>,
    sweep_rejections: Vec<CandidateVerdict>,
    totals: AdmissionTotals,
    limits: &'static str,
}

fn hex(digest: [u8; 32]) -> String {
    const HEX: &[u8; 16] = b"0123456789abcdef";
    let mut output = String::with_capacity(64);
    for byte in digest {
        output.push(char::from(HEX[usize::from(byte >> 4)]));
        output.push(char::from(HEX[usize::from(byte & 15)]));
    }
    output
}

fn plan_digest(plan: &Value) -> Result<String> {
    let mut hasher = Sha256::new();
    hasher.update(serde_json::to_vec(plan)?);
    Ok(hex(hasher.finalize().into()))
}

fn conjunction_plan(name: &str, literals: &[Literal], fields: &[String]) -> Value {
    let mut program = Vec::with_capacity(4 * literals.len());
    for (index, literal) in literals.iter().enumerate() {
        program.push(json!({"op": "field", "name": fields[literal.field]}));
        program.push(json!({"op": "const", "value": literal.constant}));
        program.push(json!({"op": "eq"}));
        if index != 0 {
            program.push(json!({"op": "and"}));
        }
    }
    json!({
        "schema": PLAN_SCHEMA,
        "name": name,
        "role": "diagnostic",
        "output": "predicate",
        "program": program,
    })
}

fn words(rows: usize) -> usize {
    rows.div_ceil(64)
}

fn set_bit(bitmap: &mut [u64], row: usize) {
    bitmap[row / 64] |= 1_u64 << (row % 64);
}

fn get_bit(bitmap: &[u64], row: usize) -> bool {
    bitmap[row / 64] & (1_u64 << (row % 64)) != 0
}

fn popcount(bitmap: &[u64]) -> u64 {
    bitmap.iter().map(|word| u64::from(word.count_ones())).sum()
}

/// Coverage of a compiled plan over a corpus, into caller-owned storage.
fn coverage_into(plan: &CompiledPlan, corpus: &GenericCorpus, bitmap: &mut [u64]) -> Result<()> {
    bitmap.fill(0);
    for (row, values) in corpus.values.iter().enumerate() {
        // A predicate plan claims a row when it is in scope and evaluates
        // nonzero, matching the campaign evaluator's own convention.
        if plan.applies(values)
            && plan
                .evaluate_row(values)
                .map_err(|error| anyhow::anyhow!("candidate plan does not evaluate: {error}"))?
                != 0
        {
            set_bit(bitmap, row);
        }
    }
    Ok(())
}

fn false_positives(coverage: &[u64], truth: &[u64]) -> u64 {
    coverage
        .iter()
        .zip(truth)
        .map(|(&covered, &expected)| u64::from((covered & !expected).count_ones()))
        .sum()
}

fn first_counterexample(
    coverage: &[u64],
    corpus: &GenericCorpus,
    rows: usize,
) -> Option<Counterexample> {
    (0..rows).find_map(|row| {
        (get_bit(coverage, row) && !corpus.expected[row]).then(|| Counterexample {
            row,
            residuals: planted_residuals(PlantedView::DirectModel, row),
            claimed: true,
            expected: corpus.expected[row],
        })
    })
}

fn admission_label(admission: TheoremArchiveAdmission) -> String {
    match admission {
        TheoremArchiveAdmission::Inserted {
            removed,
            novel_rows,
        } => {
            format!("admitted (removed {removed}, novel rows {novel_rows})")
        }
        TheoremArchiveAdmission::RejectedUnsound { false_positives } => {
            format!("rejected-unsound ({false_positives} direct-model false positives)")
        }
        TheoremArchiveAdmission::RejectedDominated => "rejected-dominated".to_owned(),
        TheoremArchiveAdmission::RejectedNoNovelCoverage => "rejected-no-novel-coverage".to_owned(),
        TheoremArchiveAdmission::RejectedCapacity => "rejected-capacity".to_owned(),
    }
}

struct AdmissionContext<'a> {
    training: &'a GenericCorpus,
    direct_model: &'a GenericCorpus,
    fields: Vec<String>,
    training_truth: Vec<u64>,
    direct_truth: Vec<u64>,
    training_coverage: Vec<u64>,
    direct_coverage: Vec<u64>,
}

impl<'a> AdmissionContext<'a> {
    fn new(training: &'a GenericCorpus, direct_model: &'a GenericCorpus) -> Result<Self> {
        if training.fields != direct_model.fields {
            bail!("planted views disagree on their presented fields");
        }
        let training_words = words(training.expected.len());
        let direct_words = words(direct_model.expected.len());
        let mut training_truth = vec![0_u64; training_words];
        for (row, &expected) in training.expected.iter().enumerate() {
            if expected {
                set_bit(&mut training_truth, row);
            }
        }
        let mut direct_truth = vec![0_u64; direct_words];
        for (row, &expected) in direct_model.expected.iter().enumerate() {
            if expected {
                set_bit(&mut direct_truth, row);
            }
        }
        Ok(Self {
            training,
            direct_model,
            fields: training.fields.clone(),
            training_truth,
            direct_truth,
            training_coverage: vec![0_u64; training_words],
            direct_coverage: vec![0_u64; direct_words],
        })
    }

    /// Screen one candidate: training perfection first, then direct-model admission.
    fn screen(
        &mut self,
        archive: &mut SoundTheoremArchive<String>,
        name: String,
        origin: &'static str,
        literals: Option<Vec<Literal>>,
        plan: &Value,
    ) -> Result<CandidateVerdict> {
        let spec: PlanSpec = serde_json::from_value(plan.clone())
            .context("candidate plan is not a valid attack plan")?;
        let compiled = CompiledPlan::compile(&spec, &self.fields)
            .map_err(|error| anyhow::anyhow!("candidate plan does not compile: {error}"))?;
        coverage_into(&compiled, self.training, &mut self.training_coverage)?;
        let training_covered = popcount(&self.training_coverage);
        let training_false_positives =
            false_positives(&self.training_coverage, &self.training_truth);
        coverage_into(&compiled, self.direct_model, &mut self.direct_coverage)?;
        let direct_model_covered = popcount(&self.direct_coverage);
        let direct_model_false_positives =
            false_positives(&self.direct_coverage, &self.direct_truth);
        let admission = archive
            .admit(name.clone(), &self.direct_coverage, plan_cost(plan))
            .map_err(|error| anyhow::anyhow!("theorem archive rejected the bitmap: {error}"))?;
        let counterexample = (direct_model_false_positives != 0)
            .then(|| {
                first_counterexample(
                    &self.direct_coverage,
                    self.direct_model,
                    self.direct_model.expected.len(),
                )
            })
            .flatten();
        Ok(CandidateVerdict {
            name,
            origin,
            literals,
            plan_digest: plan_digest(plan)?,
            training_covered,
            training_false_positives,
            direct_model_covered,
            direct_model_false_positives,
            admission: admission_label(admission),
            counterexample,
        })
    }
}

/// Declared syntax cost: the candidate's program length, comparable across
/// planted, proposed, and swept candidates because all three are plans.
fn plan_cost(plan: &Value) -> u32 {
    plan["program"]
        .as_array()
        .map_or(u32::MAX, |program| program.len() as u32)
}

/// Exhaustive sweep of the declared conjunction domain over the training view.
///
/// Literals with empty training coverage are dropped first: conjunction
/// coverage is monotone under adding literals, so any conjunction containing
/// such a literal covers nothing and fails the nonempty-coverage requirement.
fn sweep_training_domain(training: &GenericCorpus) -> (Vec<Literal>, Vec<Vec<Literal>>, u64) {
    let rows = training.expected.len();
    let bitmap_words = words(rows);
    let mut live: Vec<(Literal, Vec<u64>)> =
        Vec::with_capacity(training.fields.len() * DOMAIN_CONSTANTS.len());
    for field in 0..training.fields.len() {
        for &constant in &DOMAIN_CONSTANTS {
            let mut bitmap = vec![0_u64; bitmap_words];
            let mut covered = false;
            for (row, values) in training.values.iter().enumerate() {
                if values[field] == constant {
                    set_bit(&mut bitmap, row);
                    covered = true;
                }
            }
            if covered {
                live.push((Literal { field, constant }, bitmap));
            }
        }
    }
    let mut truth = vec![0_u64; bitmap_words];
    for (row, &expected) in training.expected.iter().enumerate() {
        if expected {
            set_bit(&mut truth, row);
        }
    }
    let mut perfect = Vec::new();
    let mut enumerated = 0_u64;
    let mut scratch = vec![0_u64; bitmap_words];
    let mut pair = vec![0_u64; bitmap_words];
    for first in 0..live.len() {
        enumerated += 1;
        if false_positives(&live[first].1, &truth) == 0 && popcount(&live[first].1) != 0 {
            perfect.push(vec![live[first].0.clone()]);
        }
        for second in first + 1..live.len() {
            for (word, slot) in pair.iter_mut().enumerate() {
                *slot = live[first].1[word] & live[second].1[word];
            }
            enumerated += 1;
            let pair_covered = popcount(&pair);
            if pair_covered != 0 && false_positives(&pair, &truth) == 0 {
                perfect.push(vec![live[first].0.clone(), live[second].0.clone()]);
            }
            if pair_covered == 0 {
                enumerated += (live.len() - second - 1) as u64;
                continue;
            }
            for third in second + 1..live.len() {
                for (word, slot) in scratch.iter_mut().enumerate() {
                    *slot = pair[word] & live[third].1[word];
                }
                enumerated += 1;
                if popcount(&scratch) != 0 && false_positives(&scratch, &truth) == 0 {
                    perfect.push(vec![
                        live[first].0.clone(),
                        live[second].0.clone(),
                        live[third].0.clone(),
                    ]);
                }
            }
        }
    }
    let live_literals = live.into_iter().map(|(literal, _)| literal).collect();
    (live_literals, perfect, enumerated)
}

fn declared_domain_size(fields: usize, constants: usize) -> u64 {
    let literals = (fields * constants) as u64;
    let pairs = literals * literals.saturating_sub(1) / 2;
    let triples = literals * literals.saturating_sub(1) * literals.saturating_sub(2) / 6;
    literals + pairs + triples
}

fn planted_predicate_plans(
    residual_fields: [u16; PLANTED_COORDINATES],
    fields: &[String],
) -> Vec<(String, Vec<Literal>, Value)> {
    let zero = |coordinate: usize| Literal {
        field: usize::from(residual_fields[coordinate]),
        constant: 0,
    };
    let declared = [
        ("P0-sound", vec![zero(0), zero(1)]),
        ("P1-unsound-tied-second", vec![zero(0), zero(2)]),
        ("P2-unsound-tied-third", vec![zero(0), zero(3)]),
        (
            "P3-unsound-tied-second-and-third",
            vec![zero(0), zero(2), zero(3)],
        ),
    ];
    declared
        .into_iter()
        .map(|(name, literals)| {
            let plan = conjunction_plan(name, &literals, fields);
            (name.to_owned(), literals, plan)
        })
        .collect()
}

/// The single evolve evidence file, whose name carries a run-unique suffix.
fn locate_evidence(directory: &Path) -> Result<PathBuf> {
    let mut paths = Vec::new();
    for entry in
        std::fs::read_dir(directory).context("cannot read the evolve evidence directory")?
    {
        let path = entry?.path();
        if path
            .file_name()
            .and_then(|name| name.to_str())
            .is_some_and(|name| name.starts_with(EVOLVE_EVIDENCE_NAME))
        {
            paths.push(path);
        }
    }
    if paths.len() != 1 {
        bail!("expected exactly one evolve evidence file");
    }
    Ok(paths.remove(0))
}

/// Distinct predicate plans the evolve run proposed, in evidence order.
fn evolve_proposals(evidence: &Path) -> Result<(Vec<Value>, usize, usize)> {
    let file = std::fs::File::open(evidence).context("cannot read evolve evidence")?;
    let mut records = 0_usize;
    let mut unreplayable = 0_usize;
    let mut seen = std::collections::BTreeSet::new();
    let mut plans = Vec::new();
    for line in BufReader::new(file).lines() {
        let record: Value = serde_json::from_str(&line?)?;
        if record["type"] == "summary" {
            continue;
        }
        records += 1;
        let Some(plan) = record.get("plan") else {
            continue;
        };
        if serde_json::from_value::<PlanSpec>(plan.clone()).is_err() {
            unreplayable += 1;
            continue;
        }
        let digest = plan_digest(plan)?;
        if seen.insert(digest) {
            plans.push(plan.clone());
        }
    }
    Ok((plans, records, unreplayable))
}

pub fn run(args: Arguments) -> Result<()> {
    std::fs::create_dir(&args.output_dir).context("cannot create the theorem-gap output root")?;
    let views_dir = args.output_dir.join("views");
    std::fs::create_dir(&views_dir)?;
    let training_path = views_dir.join("planted-gap-training.jsonl");
    let direct_path = views_dir.join("planted-gap-direct-model.jsonl");
    let training_report = write_planted_view(PlantedView::Training, &training_path)?;
    let direct_report = write_planted_view(PlantedView::DirectModel, &direct_path)?;

    let training = read_generic_corpus(&training_path)?;
    let direct_model = read_generic_corpus(&direct_path)?;
    if training.fields.len() != PLANTED_EXPANDED_FIELDS {
        bail!("planted training view has an unexpected presented width");
    }
    for (row, &expected) in direct_model.expected.iter().enumerate() {
        if expected != planted_truth(&planted_residuals(PlantedView::DirectModel, row)) {
            bail!("direct-model labels disagree with the independent latent oracle");
        }
    }

    // The blind proposer sees the training view only; the direct model is never
    // an input to proposal, only to admission.
    let (seed_plan, selected_fields, _) = generic_constant_conjunction(&training)?;

    let run_root = args.output_dir.join("run");
    std::fs::create_dir(&run_root)?;
    let campaign_dir = run_root.join("training");
    let campaign = Campaign::create(
        &training_path,
        &campaign_dir,
        None,
        8 * 1024 * 1024,
        MAX_FRAME_BYTES,
        8 * 1024 * 1024,
    )?;
    let manifest = campaign.manifest().clone();
    let server = thread::spawn(move || campaign.serve());
    wait_until_ready(&manifest)?;
    let tree = require_ok(send_request(
        &manifest,
        "synthesize-tree",
        json!({"max_nodes": 41, "max_depth": 16}),
        RESPONSE_LIMIT,
    )?)?;
    let evolved = evolve(
        &manifest,
        &seed_plan,
        EVOLVE_EVIDENCE_NAME,
        EVOLVE_GENERATIONS,
        EVOLVE_BEAM,
        EVOLVE_MAX_CANDIDATES,
    )?;
    shutdown(&manifest, server)?;
    if evolved["state"] != "complete" {
        bail!("planted training evolution did not complete");
    }
    // The campaign appends a run-unique suffix to the evidence file name; the
    // file contents are deterministic, the name is not.
    let evidence_path = locate_evidence(&campaign_dir.join("evidence"))?;
    let (proposed_plans, evidence_records, unreplayable) = evolve_proposals(&evidence_path)?;

    let (live_literals, corpus_perfect, enumerated) = sweep_training_domain(&training);

    let mut context = AdmissionContext::new(&training, &direct_model)?;
    let mut archive = SoundTheoremArchive::<String>::new(
        direct_model.expected.len(),
        &context.direct_truth.clone(),
        ARCHIVE_POINTS,
    )
    .map_err(|error| anyhow::anyhow!("cannot open the bounded theorem archive: {error}"))?;

    let mut planted_verdicts = Vec::with_capacity(4);
    for (name, literals, plan) in
        planted_predicate_plans(training_report.presented_residual_fields, &context.fields)
    {
        planted_verdicts.push(context.screen(
            &mut archive,
            name,
            "planted",
            Some(literals),
            &plan,
        )?);
    }

    // Every proposal is screened; only the corpus-perfect ones — the candidates
    // this task is about — are retained individually, the rest as counts.
    let mut evolve_verdicts = Vec::with_capacity(proposed_plans.len() + 1);
    let mut evolve_screened = 0_u64;
    let mut evolve_admitted = 0_u64;
    let mut evolve_unsound = 0_u64;
    let mut evolve_other = 0_u64;
    let mut uncompilable = 0_usize;
    let mut evolve_zero_false_positive = 0_usize;
    let mut screen_proposal = |context: &mut AdmissionContext,
                               archive: &mut SoundTheoremArchive<String>,
                               name: String,
                               origin: &'static str,
                               plan: &Value|
     -> Result<()> {
        let Ok(verdict) = context.screen(archive, name, origin, None, plan) else {
            // A mutated plan outside the replayable predicate shape is counted,
            // never silently admitted.
            uncompilable += 1;
            return Ok(());
        };
        evolve_screened += 1;
        if verdict.direct_model_false_positives != 0 {
            evolve_unsound += 1;
        } else if verdict.admission.starts_with("admitted") {
            evolve_admitted += 1;
        } else {
            evolve_other += 1;
        }
        // A candidate that claims no training row is vacuously free of training
        // false positives; corpus perfection requires nonempty coverage.
        if verdict.training_false_positives == 0 {
            evolve_zero_false_positive += 1;
            if verdict.training_covered != 0 {
                evolve_verdicts.push(verdict);
            }
        }
        Ok(())
    };
    screen_proposal(
        &mut context,
        &mut archive,
        "seed-generic-constant-conjunction".to_owned(),
        "blind-proposer",
        &seed_plan,
    )?;
    for (index, plan) in proposed_plans.iter().enumerate() {
        screen_proposal(
            &mut context,
            &mut archive,
            format!("evolve-{index:04}"),
            "evolve",
            plan,
        )?;
    }

    let mut sweep_rejections = Vec::with_capacity(MAX_RETAINED_SWEEP_REJECTIONS);
    let mut swept_admitted = 0_u64;
    let mut swept_unsound = 0_u64;
    let mut swept_other = 0_u64;
    for (index, literals) in corpus_perfect.iter().enumerate() {
        let name = format!("sweep-{index:06}");
        let plan = conjunction_plan(&name, literals, &context.fields);
        let verdict = context.screen(
            &mut archive,
            name,
            "domain-sweep",
            Some(literals.clone()),
            &plan,
        )?;
        if verdict.direct_model_false_positives != 0 {
            swept_unsound += 1;
            if sweep_rejections.len() < MAX_RETAINED_SWEEP_REJECTIONS {
                sweep_rejections.push(verdict);
            }
        } else if verdict.admission.starts_with("admitted") {
            swept_admitted += 1;
        } else {
            swept_other += 1;
        }
    }

    fn counted(
        verdicts: &[CandidateVerdict],
        predicate: impl Fn(&CandidateVerdict) -> bool,
    ) -> u64 {
        verdicts.iter().filter(|verdict| predicate(verdict)).count() as u64
    }
    fn admitted(verdict: &CandidateVerdict) -> bool {
        verdict.admission.starts_with("admitted")
    }
    fn unsound(verdict: &CandidateVerdict) -> bool {
        verdict.direct_model_false_positives != 0
    }
    let totals = AdmissionTotals {
        candidates_screened: planted_verdicts.len() as u64
            + evolve_screened
            + corpus_perfect.len() as u64,
        admitted: counted(&planted_verdicts, admitted) + evolve_admitted + swept_admitted,
        rejected_unsound: counted(&planted_verdicts, unsound) + evolve_unsound + swept_unsound,
        rejected_other: counted(&planted_verdicts, |verdict| {
            !admitted(verdict) && !unsound(verdict)
        }) + evolve_other
            + swept_other,
        retained_sweep_rejections: sweep_rejections.len(),
        retained_evolve_proposals: evolve_verdicts.len(),
        evolve_zero_false_positive,
        uncompilable_proposals: uncompilable,
        by_origin: vec![
            OriginTotals {
                origin: "planted",
                screened: planted_verdicts.len() as u64,
                admitted: counted(&planted_verdicts, admitted),
                rejected_unsound: counted(&planted_verdicts, unsound),
                rejected_other: counted(&planted_verdicts, |verdict| {
                    !admitted(verdict) && !unsound(verdict)
                }),
            },
            OriginTotals {
                origin: "evolve",
                screened: evolve_screened,
                admitted: evolve_admitted,
                rejected_unsound: evolve_unsound,
                rejected_other: evolve_other,
            },
            OriginTotals {
                origin: "domain-sweep",
                screened: corpus_perfect.len() as u64,
                admitted: swept_admitted,
                rejected_unsound: swept_unsound,
                rejected_other: swept_other,
            },
        ],
    };

    let certificate = Certificate {
        schema: "ergodis-private-planted-theorem-gap-admission-v1",
        planted_source_digest: hex(planted_source_digest()),
        view_digests: vec![
            hex(training_report.view_digest),
            hex(direct_report.view_digest),
        ],
        views: vec![training_report, direct_report],
        domain: DomainReport {
            fields: PLANTED_EXPANDED_FIELDS,
            constants: DOMAIN_CONSTANTS.len(),
            maximum_literals: DOMAIN_MAX_LITERALS,
            declared_conjunctions: declared_domain_size(
                PLANTED_EXPANDED_FIELDS,
                DOMAIN_CONSTANTS.len(),
            ),
            live_literals: live_literals.len(),
            enumerated_conjunctions: enumerated,
            corpus_perfect: corpus_perfect.len() as u64,
            stop_condition: "the declared domain is exhausted; there is no budget, timeout, or sampling step",
            pruning_argument: "conjunction coverage is monotone decreasing in the literal set, so any conjunction containing a literal with empty training coverage covers no training row and cannot meet the nonempty-coverage requirement; such conjunctions are counted but not materialized",
        },
        proposer: ProposerReport {
            proposer: "generic-constant-conjunction",
            selected_fields,
            training_rows: tree["evaluation"]["weighted_rows"].as_u64().unwrap_or(0),
            tree_nodes: tree["nodes"].as_u64().unwrap_or(0),
            tree_depth: tree["depth"].as_u64().unwrap_or(0),
            evolve_generations: EVOLVE_GENERATIONS,
            evolve_beam: EVOLVE_BEAM,
            evolve_max_candidates: EVOLVE_MAX_CANDIDATES,
            evolve_tested: evolved["summary"]["tested"].as_u64().unwrap_or(0),
            evolve_perfect: evolved["summary"]["perfect"].as_u64().unwrap_or(0),
            evidence_records,
            distinct_proposed_predicates: proposed_plans.len(),
            unreplayable_proposals: unreplayable,
            context: "the proposer and the evolve campaign see the training view only; the direct-model view is an admission input and is never presented to proposal",
        },
        planted_predicates: planted_verdicts,
        evolve_proposals: evolve_verdicts,
        sweep_rejections,
        totals,
        limits: "planted-family evidence only: no claim of general admission soundness, of transfer to unplanted corpora, or that evolve discovered mathematics",
    };
    println!("{}", serde_json::to_string_pretty(&certificate)?);
    Ok(())
}
