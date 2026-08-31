//! certiis — explainable infeasibility for assignment and scheduling instances.
//!
//! Given an assignment instance (tasks, resources, an eligibility relation, optional
//! capacities) the tool either returns a feasible assignment or an *irreducible*
//! Hall-violating set of tasks together with its eligible-resource neighbourhood.
//!
//! The tool classifies the instance first and declines to certify when Hall's condition is
//! not the right certificate. See `notes/2026-08-31-infeasibility-certificate-prototype.md`.
//!
//! Everything here calls `ergodis_private::hall_core::HallWorkspace` exactly as it stands;
//! no core or shared module is modified.

use std::collections::{BTreeMap, BTreeSet};
use std::fs;
use std::path::{Path, PathBuf};
use std::time::Instant;

use anyhow::{bail, ensure, Context};
use clap::{Args, Parser, Subcommand, ValueEnum};
use ergodis_private::hall_core::{HallOutcome, HallWorkspace};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};

const INSTANCE_SCHEMA: &str = "certiis-instance/v1";
const CERTIFICATE_SCHEMA: &str = "certiis-certificate/v1";
/// Upper bound on the unit-expanded incidence list, to keep memory predictable.
const MAX_EXPANDED_EDGES: usize = 40_000_000;

// ---------------------------------------------------------------------------
// Instance model
// ---------------------------------------------------------------------------

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Task {
    pub id: String,
    /// Resource-units the task consumes. Units of one task may be supplied by the same
    /// resource more than once (a job taking three slots on one host). If the task instead
    /// needs `demand` *distinct* resources, set `distinct`; see the classifier.
    #[serde(default = "one")]
    pub demand: u32,
    #[serde(default, skip_serializing_if = "is_false")]
    pub distinct: bool,
}

fn is_false(value: &bool) -> bool {
    !*value
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Resource {
    pub id: String,
    #[serde(default = "one")]
    pub capacity: u32,
}

fn one() -> u32 {
    1
}

/// Extra structure beyond "task consumes units, resource supplies units".
///
/// Every variant here is a reason the instance may leave the matching regime; the
/// classifier decides which.
#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(tag = "kind", rename_all = "snake_case")]
pub enum Coupling {
    /// Resource must be loaded to exactly this many task-units (a lower *and* upper bound).
    ResourceExactLoad { resource: String, load: u32 },
    /// Prescribed column sums over the whole resource set.
    PrescribedColumnSums { sums: Vec<u32> },
    /// Prescribed row sums over the whole task set.
    PrescribedRowSums { sums: Vec<u32> },
    /// Two task rows must share exactly this many resources.
    PairwiseInnerProduct { tasks: [String; 2], value: u32 },
    /// Two tasks may not share a resource.
    TaskConflict { tasks: [String; 2] },
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct GroundTruth {
    pub feasible: bool,
    #[serde(default)]
    pub planted_tasks: Vec<String>,
    #[serde(default)]
    pub planted_resources: Vec<String>,
    /// Size of the smallest irreducible violating task set the generator knows about.
    #[serde(default)]
    pub minimal_certificate_size: Option<usize>,
    /// Size of the maximum-deficiency set the generator expects before minimization.
    #[serde(default)]
    pub expected_raw_deficient: Option<usize>,
    /// Number of independent bottlenecks planted.
    #[serde(default)]
    pub bottleneck_count: Option<usize>,
    /// Planted task sets, one per bottleneck, each the unique irreducible certificate.
    #[serde(default)]
    pub planted_blocks: Vec<Vec<String>>,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Instance {
    pub schema: String,
    pub name: String,
    pub tasks: Vec<Task>,
    pub resources: Vec<Resource>,
    pub eligible: Vec<(String, String)>,
    #[serde(default)]
    pub couplings: Vec<Coupling>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub ground_truth: Option<GroundTruth>,
}

// ---------------------------------------------------------------------------
// Classifier
// ---------------------------------------------------------------------------

#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum Regime {
    /// One unit per task, one unit per resource, eligibility only. Hall exactly.
    BipartiteMatching,
    /// Many-to-one with upper bounds only. Defect Hall over task sets, still exact.
    CapacitatedMatching,
    /// Resource-side lower bounds / prescribed sums. Gale-Ryser and flow territory.
    DegreeConstrainedCompletion,
    /// Pairwise coupling between task rows. Matrix completion, not matching.
    QuadraticallyCoupled,
}

impl Regime {
    fn certifiable(self) -> bool {
        matches!(self, Regime::BipartiteMatching | Regime::CapacitatedMatching)
    }

    fn as_str(self) -> &'static str {
        match self {
            Regime::BipartiteMatching => "bipartite_matching",
            Regime::CapacitatedMatching => "capacitated_matching",
            Regime::DegreeConstrainedCompletion => "degree_constrained_completion",
            Regime::QuadraticallyCoupled => "quadratically_coupled",
        }
    }
}

#[derive(Clone, Debug, Serialize)]
pub struct Classification {
    pub regime: &'static str,
    pub certifiable: bool,
    /// Why the instance landed in this regime.
    pub evidence: Vec<String>,
    /// What would be needed instead, when we decline.
    pub needed_instead: Vec<String>,
}

pub fn classify(instance: &Instance) -> Classification {
    let mut evidence = Vec::new();
    let mut quadratic = Vec::new();
    let mut degree = Vec::new();

    for coupling in &instance.couplings {
        match coupling {
            Coupling::PairwiseInnerProduct { tasks, value } => quadratic.push(format!(
                "pairwise inner product constraint <{}, {}> = {value}",
                tasks[0], tasks[1]
            )),
            Coupling::TaskConflict { tasks } => quadratic.push(format!(
                "pairwise task conflict between {} and {}",
                tasks[0], tasks[1]
            )),
            Coupling::ResourceExactLoad { resource, load } => degree.push(format!(
                "resource {resource} carries an exact load of {load}, a lower bound as well as an upper bound"
            )),
            Coupling::PrescribedColumnSums { sums } => degree.push(format!(
                "prescribed column sums over all {} resources",
                sums.len()
            )),
            Coupling::PrescribedRowSums { sums } => degree.push(format!(
                "prescribed row sums over all {} tasks",
                sums.len()
            )),
        }
    }

    if !quadratic.is_empty() {
        evidence.extend(quadratic);
        evidence.extend(degree);
        return Classification {
            regime: Regime::QuadraticallyCoupled.as_str(),
            certifiable: false,
            evidence,
            needed_instead: vec![
                "This is a degree-constrained matrix completion, not a matching. Hall's \
                 condition is necessary but not sufficient, and a Hall set is a decorative \
                 rather than a load-bearing certificate."
                    .into(),
                "Necessary conditions that do apply: Gale-Ryser for the row/column degree \
                 sequence, and the Frankl-Wilson / Fisher-type rank bounds on the pairwise \
                 inner-product system."
                    .into(),
                "A complete method needs a completion search with column-capacity pruning \
                 and pairwise inner-product filtering, or a general integer-programming \
                 irreducible-infeasible-subsystem extractor."
                    .into(),
            ],
        };
    }

    for task in &instance.tasks {
        if task.distinct && task.demand > 1 {
            degree.push(format!(
                "task {} needs {} *distinct* resources, an x_tr <= 1 upper bound on top of the \
                 capacities",
                task.id, task.demand
            ));
        }
    }

    if !degree.is_empty() {
        evidence.extend(degree);
        return Classification {
            regime: Regime::DegreeConstrainedCompletion.as_str(),
            certifiable: false,
            evidence,
            needed_instead: vec![
                "Resource-side lower bounds, and per-pair upper bounds such as 'this task \
                 needs distinct resources', turn feasibility into a degree-constrained \
                 subgraph problem. Hall's condition stays necessary but stops being \
                 sufficient: one task of demand 2 against one resource of capacity 5 passes \
                 every task-side Hall test and is still infeasible when the two units must \
                 come from different resources."
                    .into(),
                "Use the Gale supply-demand theorem (a max-flow min-cut feasibility test on \
                 the bipartite transportation network) or Gale-Ryser when the degree \
                 sequences are prescribed; the certificate is then a cut that names both a \
                 task set and a resource set, not a Hall set."
                    .into(),
            ],
        };
    }

    let max_demand = instance.tasks.iter().map(|t| t.demand).max().unwrap_or(1);
    let max_capacity = instance
        .resources
        .iter()
        .map(|r| r.capacity)
        .max()
        .unwrap_or(1);
    if max_demand <= 1 && max_capacity <= 1 {
        evidence.push("every task demands one unit and every resource supplies one".into());
        Classification {
            regime: Regime::BipartiteMatching.as_str(),
            certifiable: Regime::BipartiteMatching.certifiable(),
            evidence,
            needed_instead: Vec::new(),
        }
    } else {
        evidence.push(format!(
            "many-to-one: maximum task demand {max_demand}, maximum resource capacity \
             {max_capacity}, with upper bounds only"
        ));
        Classification {
            regime: Regime::CapacitatedMatching.as_str(),
            certifiable: Regime::CapacitatedMatching.certifiable(),
            evidence,
            needed_instead: Vec::new(),
        }
    }
}

// ---------------------------------------------------------------------------
// Compiled instance
// ---------------------------------------------------------------------------

struct Compiled {
    task_ids: Vec<String>,
    resource_ids: Vec<String>,
    demand: Vec<u32>,
    capacity: Vec<u32>,
    /// Sorted, de-duplicated eligible resources per task.
    adjacency: Vec<Vec<u32>>,
}

impl Compiled {
    fn build(instance: &Instance) -> anyhow::Result<Self> {
        ensure!(
            instance.schema == INSTANCE_SCHEMA,
            "unsupported instance schema {:?} (expected {INSTANCE_SCHEMA})",
            instance.schema
        );
        let mut task_index = BTreeMap::new();
        for (index, task) in instance.tasks.iter().enumerate() {
            ensure!(task.demand >= 1, "task {} has demand 0", task.id);
            if task_index.insert(task.id.as_str(), index).is_some() {
                bail!("duplicate task id {}", task.id);
            }
        }
        let mut resource_index = BTreeMap::new();
        for (index, resource) in instance.resources.iter().enumerate() {
            if resource_index.insert(resource.id.as_str(), index).is_some() {
                bail!("duplicate resource id {}", resource.id);
            }
        }
        let mut adjacency = vec![BTreeSet::new(); instance.tasks.len()];
        for (task, resource) in &instance.eligible {
            let &task_ix = task_index
                .get(task.as_str())
                .with_context(|| format!("eligibility names unknown task {task}"))?;
            let &resource_ix = resource_index
                .get(resource.as_str())
                .with_context(|| format!("eligibility names unknown resource {resource}"))?;
            adjacency[task_ix].insert(resource_ix as u32);
        }
        Ok(Self {
            task_ids: instance.tasks.iter().map(|t| t.id.clone()).collect(),
            resource_ids: instance.resources.iter().map(|r| r.id.clone()).collect(),
            demand: instance.tasks.iter().map(|t| t.demand).collect(),
            capacity: instance.resources.iter().map(|r| r.capacity).collect(),
            adjacency: adjacency
                .into_iter()
                .map(|set| set.into_iter().collect())
                .collect(),
        })
    }

    fn task_count(&self) -> usize {
        self.task_ids.len()
    }

    fn resource_count(&self) -> usize {
        self.resource_ids.len()
    }

    fn demand_of(&self, tasks: &[u32]) -> u64 {
        tasks.iter().map(|&t| u64::from(self.demand[t as usize])).sum()
    }

    fn neighborhood(&self, tasks: &[u32]) -> Vec<u32> {
        let mut seen = vec![false; self.resource_count()];
        let mut out = Vec::new();
        for &task in tasks {
            for &resource in &self.adjacency[task as usize] {
                if !seen[resource as usize] {
                    seen[resource as usize] = true;
                    out.push(resource);
                }
            }
        }
        out.sort_unstable();
        out
    }

    fn capacity_of(&self, resources: &[u32]) -> u64 {
        resources
            .iter()
            .map(|&r| u64::from(self.capacity[r as usize]))
            .sum()
    }
}

// ---------------------------------------------------------------------------
// Unit expansion, so `hall_core` can be used exactly as it stands
// ---------------------------------------------------------------------------

struct Expansion {
    left_count: usize,
    right_count: usize,
    offsets: Vec<u32>,
    neighbors: Vec<u32>,
    /// left copy -> task
    left_owner: Vec<u32>,
    /// right copy -> resource
    right_owner: Vec<u32>,
}

impl Expansion {
    fn build(compiled: &Compiled) -> anyhow::Result<Self> {
        let mut left_owner = Vec::new();
        for (task, &demand) in compiled.demand.iter().enumerate() {
            for _ in 0..demand {
                left_owner.push(task as u32);
            }
        }
        let mut right_owner = Vec::new();
        let mut right_base = Vec::with_capacity(compiled.resource_count());
        for (resource, &capacity) in compiled.capacity.iter().enumerate() {
            right_base.push(right_owner.len() as u32);
            for _ in 0..capacity {
                right_owner.push(resource as u32);
            }
        }

        let mut degree = vec![0usize; compiled.task_count()];
        let mut total: usize = 0;
        for task in 0..compiled.task_count() {
            let deg: usize = compiled.adjacency[task]
                .iter()
                .map(|&r| compiled.capacity[r as usize] as usize)
                .sum();
            degree[task] = deg;
            total = total.saturating_add(deg * compiled.demand[task] as usize);
            ensure!(
                total <= MAX_EXPANDED_EDGES,
                "unit expansion exceeds {MAX_EXPANDED_EDGES} incidences; \
                 hall_core has no capacity concept (see the request list in the report)"
            );
        }

        let mut offsets = Vec::with_capacity(left_owner.len() + 1);
        let mut neighbors = Vec::with_capacity(total);
        offsets.push(0u32);
        for &task in &left_owner {
            for &resource in &compiled.adjacency[task as usize] {
                let base = right_base[resource as usize];
                for copy in 0..compiled.capacity[resource as usize] {
                    neighbors.push(base + copy);
                }
            }
            offsets.push(neighbors.len() as u32);
        }
        Ok(Self {
            left_count: left_owner.len(),
            right_count: right_owner.len(),
            offsets,
            neighbors,
            left_owner,
            right_owner,
        })
    }
}

// ---------------------------------------------------------------------------
// Certificate
// ---------------------------------------------------------------------------

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct RemovalTest {
    pub removed_task: String,
    pub demand_after: u64,
    pub capacity_after: u64,
    /// False on every entry: that is what irreducibility means.
    pub still_violated: bool,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Deficiency {
    pub tasks: Vec<String>,
    pub neighborhood: Vec<String>,
    pub demand: u64,
    pub neighborhood_capacity: u64,
    pub deficit: u64,
    pub removal_tests: Vec<RemovalTest>,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ResourceUnits {
    pub resource: String,
    pub units: u32,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct AssignedTask {
    pub task: String,
    pub resources: Vec<ResourceUnits>,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(tag = "status", rename_all = "snake_case")]
pub enum Verdict {
    Feasible {
        assignment: Vec<AssignedTask>,
    },
    /// One irreducible certificate per independent bottleneck. The certificates are
    /// pairwise disjoint in both tasks and resources, and each one on its own proves the
    /// instance infeasible.
    Infeasible {
        /// Size of the maximum-deficiency set `hall_core` returned, before decomposition
        /// and minimization.
        raw_deficient_tasks: usize,
        certificates: Vec<Deficiency>,
    },
    Declined {
        needed_instead: Vec<String>,
    },
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Report {
    pub schema: String,
    pub instance: String,
    pub instance_digest: String,
    pub regime: String,
    pub regime_evidence: Vec<String>,
    pub task_count: usize,
    pub resource_count: usize,
    pub expanded_left: usize,
    pub expanded_right: usize,
    #[serde(flatten)]
    pub verdict: Verdict,
    pub matching_micros: u128,
    pub minimization_micros: u128,
    pub total_micros: u128,
}

fn digest(bytes: &[u8]) -> String {
    let mut hasher = Sha256::new();
    hasher.update(bytes);
    format!("{:x}", hasher.finalize())
}

// ---------------------------------------------------------------------------
// Solve
// ---------------------------------------------------------------------------

/// Greedy single-removal sweep, iterated to a fixpoint. Returns an irreducible violating
/// task set.
///
/// The fixpoint loop is not optional. The usual one-pass deletion filter for irreducible
/// infeasible subsystems relies on infeasibility being inherited by supersets; a Hall
/// violation is *not* monotone that way, since a subset of a non-violating set can violate.
/// So a task passed over early can become removable after a later removal, and only a pass
/// that changes nothing proves irreducibility.
///
/// `counts[r]` tracks how many tasks of the current set are adjacent to `r`, so each
/// removal test costs `O(deg(task))` rather than a full neighbourhood rebuild.
fn minimize(compiled: &Compiled, seed: &[u32], order: &[u32]) -> Vec<u32> {
    let mut present = vec![false; compiled.task_count()];
    let mut counts = vec![0u32; compiled.resource_count()];
    let mut demand: u64 = 0;
    let mut capacity: u64 = 0;
    for &task in seed {
        present[task as usize] = true;
        demand += u64::from(compiled.demand[task as usize]);
        for &resource in &compiled.adjacency[task as usize] {
            if counts[resource as usize] == 0 {
                capacity += u64::from(compiled.capacity[resource as usize]);
            }
            counts[resource as usize] += 1;
        }
    }

    loop {
        let mut removed_any = false;
        for &task in order {
            if !present[task as usize] {
                continue;
            }
            let demand_after = demand - u64::from(compiled.demand[task as usize]);
            let mut released: u64 = 0;
            for &resource in &compiled.adjacency[task as usize] {
                if counts[resource as usize] == 1 {
                    released += u64::from(compiled.capacity[resource as usize]);
                }
            }
            let capacity_after = capacity - released;
            if demand_after > capacity_after {
                present[task as usize] = false;
                demand = demand_after;
                capacity = capacity_after;
                for &resource in &compiled.adjacency[task as usize] {
                    counts[resource as usize] -= 1;
                }
                removed_any = true;
            }
        }
        if !removed_any {
            break;
        }
    }

    (0..compiled.task_count() as u32)
        .filter(|&t| present[t as usize])
        .collect()
}

/// Split a task set into the connected components of the bipartite subgraph it induces
/// together with its neighbourhood.
///
/// Components partition both the task set and its neighbourhood, so the total deficit is
/// the sum of the per-component deficits. A component with deficit zero is padding: it can
/// be dropped without destroying the violation, and dropping it makes the explanation
/// smaller and easier to read.
fn components(compiled: &Compiled, tasks: &[u32]) -> Vec<Vec<u32>> {
    // Reverse incidence restricted to the given task set.
    let mut sharers: BTreeMap<u32, Vec<u32>> = BTreeMap::new();
    for &task in tasks {
        for &resource in &compiled.adjacency[task as usize] {
            sharers.entry(resource).or_default().push(task);
        }
    }
    let mut visited_task = vec![false; compiled.task_count()];
    let mut expanded_resource = vec![false; compiled.resource_count()];
    let mut out = Vec::new();
    let mut queue = Vec::new();

    for &start in tasks {
        if visited_task[start as usize] {
            continue;
        }
        visited_task[start as usize] = true;
        queue.clear();
        queue.push(start);
        let mut group = Vec::new();
        while let Some(task) = queue.pop() {
            group.push(task);
            for &resource in &compiled.adjacency[task as usize] {
                if expanded_resource[resource as usize] {
                    continue;
                }
                expanded_resource[resource as usize] = true;
                for &other in &sharers[&resource] {
                    if !visited_task[other as usize] {
                        visited_task[other as usize] = true;
                        queue.push(other);
                    }
                }
            }
        }
        group.sort_unstable();
        out.push(group);
    }
    out
}

/// Decompose a violating task set into one irreducible certificate per independent
/// bottleneck.
///
/// Each returned set violates on its own and is irreducible under single-task removal, and
/// the sets are pairwise disjoint in tasks and in resources. Recursion terminates because
/// it only happens on a strictly smaller set.
fn extract_certificates(compiled: &Compiled, set: &[u32]) -> Vec<Vec<u32>> {
    let mut out = Vec::new();
    for group in components(compiled, set) {
        let neighborhood = compiled.neighborhood(&group);
        if compiled.demand_of(&group) <= compiled.capacity_of(&neighborhood) {
            continue; // padding: this component carries no deficit of its own.
        }
        let mut forward = group.clone();
        forward.sort_unstable();
        let mut backward = forward.clone();
        backward.reverse();
        let mut by_degree = forward.clone();
        by_degree.sort_by_key(|&t| std::cmp::Reverse(compiled.adjacency[t as usize].len()));
        let best = [forward, backward, by_degree]
            .into_iter()
            .map(|order| minimize(compiled, &group, &order))
            .min_by_key(Vec::len)
            .expect("three orders");
        if best.len() < group.len() {
            out.extend(extract_certificates(compiled, &best));
        } else {
            out.push(best);
        }
    }
    out
}

fn removal_tests(compiled: &Compiled, tasks: &[u32]) -> Vec<RemovalTest> {
    let mut counts = vec![0u32; compiled.resource_count()];
    let mut demand: u64 = 0;
    let mut capacity: u64 = 0;
    for &task in tasks {
        demand += u64::from(compiled.demand[task as usize]);
        for &resource in &compiled.adjacency[task as usize] {
            if counts[resource as usize] == 0 {
                capacity += u64::from(compiled.capacity[resource as usize]);
            }
            counts[resource as usize] += 1;
        }
    }
    tasks
        .iter()
        .map(|&task| {
            let demand_after = demand - u64::from(compiled.demand[task as usize]);
            let released: u64 = compiled.adjacency[task as usize]
                .iter()
                .filter(|&&r| counts[r as usize] == 1)
                .map(|&r| u64::from(compiled.capacity[r as usize]))
                .sum();
            let capacity_after = capacity - released;
            RemovalTest {
                removed_task: compiled.task_ids[task as usize].clone(),
                demand_after,
                capacity_after,
                still_violated: demand_after > capacity_after,
            }
        })
        .collect()
}

fn solve(instance: &Instance, raw: &[u8]) -> anyhow::Result<Report> {
    let started = Instant::now();
    let classification = classify(instance);
    let compiled = Compiled::build(instance)?;

    if !classification.certifiable {
        return Ok(Report {
            schema: CERTIFICATE_SCHEMA.into(),
            instance: instance.name.clone(),
            instance_digest: digest(raw),
            regime: classification.regime.into(),
            regime_evidence: classification.evidence,
            task_count: compiled.task_count(),
            resource_count: compiled.resource_count(),
            expanded_left: 0,
            expanded_right: 0,
            verdict: Verdict::Declined {
                needed_instead: classification.needed_instead,
            },
            matching_micros: 0,
            minimization_micros: 0,
            total_micros: started.elapsed().as_micros(),
        });
    }

    let expansion = Expansion::build(&compiled)?;
    let mut workspace = HallWorkspace::new(expansion.left_count.max(1), expansion.right_count.max(1));
    let matching_started = Instant::now();
    let outcome = workspace.solve(
        expansion.left_count,
        expansion.right_count,
        &expansion.offsets,
        &expansion.neighbors,
    )?;
    let matching_micros = matching_started.elapsed().as_micros();

    let (verdict, minimization_micros) = match outcome {
        HallOutcome::Saturated => {
            let pairs = workspace.matching(expansion.left_count);
            let mut tally: Vec<BTreeMap<u32, u32>> = vec![BTreeMap::new(); compiled.task_count()];
            for (copy, &right) in pairs.iter().enumerate() {
                let task = expansion.left_owner[copy] as usize;
                let resource = expansion.right_owner[right as usize];
                *tally[task].entry(resource).or_insert(0) += 1;
            }
            let assignment = compiled
                .task_ids
                .iter()
                .zip(tally)
                .map(|(id, counts)| AssignedTask {
                    task: id.clone(),
                    resources: counts
                        .into_iter()
                        .map(|(resource, units)| ResourceUnits {
                            resource: compiled.resource_ids[resource as usize].clone(),
                            units,
                        })
                        .collect(),
                })
                .collect();
            (Verdict::Feasible { assignment }, 0)
        }
        HallOutcome::Deficient { .. } => {
            let mut seed: Vec<u32> = workspace
                .deficient_left()
                .iter()
                .map(|&copy| expansion.left_owner[copy as usize])
                .collect();
            seed.sort_unstable();
            seed.dedup();
            let raw_size = seed.len();

            let seed_demand = compiled.demand_of(&seed);
            let seed_neighborhood = compiled.neighborhood(&seed);
            let seed_capacity = compiled.capacity_of(&seed_neighborhood);
            ensure!(
                seed_demand > seed_capacity,
                "projection of the hall_core deficient set is not a violator \
                 (demand {seed_demand}, capacity {seed_capacity})"
            );

            let minimization_started = Instant::now();
            let extracted = extract_certificates(&compiled, &seed);
            let minimization_micros = minimization_started.elapsed().as_micros();
            ensure!(
                !extracted.is_empty(),
                "decomposition of a violating set produced no certificate"
            );

            let mut certificates = Vec::with_capacity(extracted.len());
            for tasks in &extracted {
                let neighborhood = compiled.neighborhood(tasks);
                let demand = compiled.demand_of(tasks);
                let capacity = compiled.capacity_of(&neighborhood);
                ensure!(
                    demand > capacity,
                    "extraction destroyed the violation (demand {demand}, capacity {capacity})"
                );
                let tests = removal_tests(&compiled, tasks);
                ensure!(
                    tests.iter().all(|t| !t.still_violated),
                    "extraction returned a reducible set"
                );
                certificates.push(Deficiency {
                    tasks: tasks
                        .iter()
                        .map(|&t| compiled.task_ids[t as usize].clone())
                        .collect(),
                    neighborhood: neighborhood
                        .iter()
                        .map(|&r| compiled.resource_ids[r as usize].clone())
                        .collect(),
                    demand,
                    neighborhood_capacity: capacity,
                    deficit: demand - capacity,
                    removal_tests: tests,
                });
            }
            certificates.sort_by(|a, b| a.tasks.len().cmp(&b.tasks.len()).then_with(|| a.tasks.cmp(&b.tasks)));
            (
                Verdict::Infeasible {
                    raw_deficient_tasks: raw_size,
                    certificates,
                },
                minimization_micros,
            )
        }
    };

    Ok(Report {
        schema: CERTIFICATE_SCHEMA.into(),
        instance: instance.name.clone(),
        instance_digest: digest(raw),
        regime: classification.regime.into(),
        regime_evidence: classification.evidence,
        task_count: compiled.task_count(),
        resource_count: compiled.resource_count(),
        expanded_left: expansion.left_count,
        expanded_right: expansion.right_count,
        verdict,
        matching_micros,
        minimization_micros,
        total_micros: started.elapsed().as_micros(),
    })
}

// ---------------------------------------------------------------------------
// Independent verification
// ---------------------------------------------------------------------------

/// Recheck a report against its instance without using `hall_core` at all.
fn verify(instance: &Instance, raw: &[u8], report: &Report) -> anyhow::Result<Vec<String>> {
    let mut checks = Vec::new();
    ensure!(
        report.schema == CERTIFICATE_SCHEMA,
        "unsupported certificate schema {:?}",
        report.schema
    );
    let actual = digest(raw);
    ensure!(
        report.instance_digest == actual,
        "certificate was produced for a different instance (digest {} vs {actual})",
        report.instance_digest
    );
    checks.push(format!("instance digest matches ({actual})"));

    let classification = classify(instance);
    ensure!(
        classification.regime == report.regime,
        "regime disagrees: certificate says {}, reclassification says {}",
        report.regime,
        classification.regime
    );
    checks.push(format!("regime independently reclassified as {}", report.regime));

    let task_index: BTreeMap<&str, usize> = instance
        .tasks
        .iter()
        .enumerate()
        .map(|(i, t)| (t.id.as_str(), i))
        .collect();
    let resource_index: BTreeMap<&str, usize> = instance
        .resources
        .iter()
        .enumerate()
        .map(|(i, r)| (r.id.as_str(), i))
        .collect();
    let mut eligible: BTreeSet<(usize, usize)> = BTreeSet::new();
    for (task, resource) in &instance.eligible {
        let &t = task_index
            .get(task.as_str())
            .with_context(|| format!("unknown task {task}"))?;
        let &r = resource_index
            .get(resource.as_str())
            .with_context(|| format!("unknown resource {resource}"))?;
        eligible.insert((t, r));
    }

    match &report.verdict {
        Verdict::Declined { needed_instead } => {
            ensure!(
                !classification.certifiable,
                "certificate declines but the instance is in a certifiable regime"
            );
            ensure!(
                !needed_instead.is_empty(),
                "declined without naming what is needed instead"
            );
            checks.push("decline is justified: the regime is not certifiable by Hall".into());
        }
        Verdict::Feasible { assignment } => {
            ensure!(
                classification.certifiable,
                "feasible verdict in a non-certifiable regime"
            );
            let mut load = vec![0u32; instance.resources.len()];
            ensure!(
                assignment.len() == instance.tasks.len(),
                "assignment covers {} of {} tasks",
                assignment.len(),
                instance.tasks.len()
            );
            for entry in assignment {
                let &t = task_index
                    .get(entry.task.as_str())
                    .with_context(|| format!("assignment names unknown task {}", entry.task))?;
                let served: u32 = entry.resources.iter().map(|u| u.units).sum();
                ensure!(
                    served == instance.tasks[t].demand,
                    "task {} receives {served} units, demands {}",
                    entry.task,
                    instance.tasks[t].demand
                );
                let named: BTreeSet<&String> = entry.resources.iter().map(|u| &u.resource).collect();
                ensure!(
                    named.len() == entry.resources.len(),
                    "task {} lists the same resource twice",
                    entry.task
                );
                for unit in &entry.resources {
                    let &r = resource_index
                        .get(unit.resource.as_str())
                        .with_context(|| {
                            format!("assignment names unknown resource {}", unit.resource)
                        })?;
                    ensure!(
                        eligible.contains(&(t, r)),
                        "assignment uses ineligible pair ({}, {})",
                        entry.task,
                        unit.resource
                    );
                    load[r] += unit.units;
                }
            }
            for (r, resource) in instance.resources.iter().enumerate() {
                ensure!(
                    load[r] <= resource.capacity,
                    "resource {} loaded to {} over capacity {}",
                    resource.id,
                    load[r],
                    resource.capacity
                );
            }
            checks.push(format!(
                "assignment recomputed: all {} tasks served, eligibility and every capacity respected",
                instance.tasks.len()
            ));
        }
        Verdict::Infeasible { certificates, .. } => {
            ensure!(
                classification.certifiable,
                "infeasible verdict in a non-certifiable regime"
            );
            ensure!(!certificates.is_empty(), "no certificate");
            let mut claimed_tasks: BTreeSet<usize> = BTreeSet::new();
            let mut claimed_resources: BTreeSet<usize> = BTreeSet::new();
            for certificate in certificates {
            ensure!(!certificate.tasks.is_empty(), "empty certificate");
            let indices: Vec<usize> = certificate
                .tasks
                .iter()
                .map(|id| {
                    task_index
                        .get(id.as_str())
                        .copied()
                        .with_context(|| format!("certificate names unknown task {id}"))
                })
                .collect::<anyhow::Result<_>>()?;
            let distinct: BTreeSet<usize> = indices.iter().copied().collect();
            ensure!(
                distinct.len() == indices.len(),
                "certificate repeats a task"
            );

            let neighborhood = |set: &BTreeSet<usize>| -> BTreeSet<usize> {
                eligible
                    .iter()
                    .filter(|(t, _)| set.contains(t))
                    .map(|&(_, r)| r)
                    .collect()
            };
            let demand = |set: &BTreeSet<usize>| -> u64 {
                set.iter().map(|&t| u64::from(instance.tasks[t].demand)).sum()
            };
            let capacity = |set: &BTreeSet<usize>| -> u64 {
                set.iter()
                    .map(|&r| u64::from(instance.resources[r].capacity))
                    .sum()
            };

            let hood = neighborhood(&distinct);
            let claimed_hood: BTreeSet<usize> = certificate
                .neighborhood
                .iter()
                .map(|id| {
                    resource_index
                        .get(id.as_str())
                        .copied()
                        .with_context(|| format!("certificate names unknown resource {id}"))
                })
                .collect::<anyhow::Result<_>>()?;
            ensure!(
                hood == claimed_hood,
                "stated neighbourhood is not the eligible-resource set of the certificate tasks"
            );
            let d = demand(&distinct);
            let c = capacity(&hood);
            ensure!(
                d == certificate.demand && c == certificate.neighborhood_capacity,
                "stated demand/capacity ({}, {}) disagree with recomputation ({d}, {c})",
                certificate.demand,
                certificate.neighborhood_capacity
            );
            ensure!(
                d > c,
                "certificate does not violate Hall: demand {d} <= capacity {c}"
            );
            checks.push(format!(
                "Hall violation recomputed independently: {} tasks demand {d} units, their {} \
                 eligible resources supply {c} (deficit {})",
                distinct.len(),
                hood.len(),
                d - c
            ));

            ensure!(
                certificate.removal_tests.len() == indices.len(),
                "removal tests do not cover every certificate task"
            );
            for &t in &distinct {
                let mut reduced = distinct.clone();
                reduced.remove(&t);
                let reduced_hood = neighborhood(&reduced);
                let rd = demand(&reduced);
                let rc = capacity(&reduced_hood);
                ensure!(
                    rd <= rc,
                    "certificate is reducible: dropping {} leaves demand {rd} > capacity {rc}",
                    instance.tasks[t].id
                );
                let stated = certificate
                    .removal_tests
                    .iter()
                    .find(|test| test.removed_task == instance.tasks[t].id)
                    .with_context(|| {
                        format!("no removal test recorded for {}", instance.tasks[t].id)
                    })?;
                ensure!(
                    stated.demand_after == rd
                        && stated.capacity_after == rc
                        && !stated.still_violated,
                    "removal test for {} disagrees with recomputation",
                    instance.tasks[t].id
                );
            }
            checks.push(format!(
                "irreducibility proved by explicit removal: each of the {} tasks, when dropped, \
                 leaves demand <= capacity",
                distinct.len()
            ));

            for &t in &distinct {
                ensure!(
                    claimed_tasks.insert(t),
                    "task {} appears in two certificates",
                    instance.tasks[t].id
                );
            }
            for &r in &hood {
                ensure!(
                    claimed_resources.insert(r),
                    "resource {} appears in two certificates",
                    instance.resources[r].id
                );
            }
            }
            checks.push(format!(
                "{} independent bottleneck(s), pairwise disjoint in tasks and resources",
                certificates.len()
            ));
        }
    }
    Ok(checks)
}

// ---------------------------------------------------------------------------
// Generators
// ---------------------------------------------------------------------------

/// Small deterministic PRNG (SplitMix64) so instances replay exactly from a seed.
struct Rng(u64);

impl Rng {
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9E37_79B9_7F4A_7C15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
        z ^ (z >> 31)
    }

    fn below(&mut self, bound: usize) -> usize {
        (self.next() % bound as u64) as usize
    }
}

const QUALIFICATIONS: [&str; 4] = ["general", "icu", "paediatric", "orthopaedic"];

/// Append a planted violation whose unique irreducible certificate is known exactly, plus a
/// forced alternating cascade of length `cascade` that inflates the *maximum*-deficiency set
/// without joining the minimal one.
///
/// The block is `plant` scarce tasks eligible only to scarce resources of total capacity
/// `plant - 2` together with one bridge resource of capacity 1. The bridge is pinned by a
/// chain `chain_j ~ {bridge_j, bridge_{j+1}}` whose last link sees only `bridge_cascade`, so
/// the chain's matching is forced from the far end inwards and the bridge is never free.
///
/// Consequences, both checked by the benchmark:
/// * the unique irreducible certificate is exactly the `plant` scarce tasks (dropping any one
///   leaves demand `plant - 1` against capacity `plant - 1`);
/// * the alternating-reachable set `hall_core` returns has size `plant + cascade`, because
///   reachability walks the whole chain.
///
/// With `plant < 3` there is no room for the bridge, so the block degenerates to scarce
/// resources of total capacity `plant - 1` and no cascade.
fn plant_block(
    tasks: &mut Vec<Task>,
    resources: &mut Vec<Resource>,
    eligible: &mut Vec<(String, String)>,
    scarce_task: &str,
    scarce_resource: &str,
    plant: usize,
    cascade: usize,
    ground_truth: &mut GroundTruth,
) {
    if plant < 2 {
        // A single task cannot be short of its own eligible resources here, and `plant = 0`
        // would underflow the capacity arithmetic below.
        return;
    }
    let use_bridge = plant >= 3 && cascade >= 1;
    let scarce_total = if use_bridge {
        plant as u32 - 2
    } else {
        plant as u32 - 1
    };
    let scarce_count = ((scarce_total as usize) / 2).max(1);
    let mut capacities = vec![scarce_total / scarce_count as u32; scarce_count];
    let mut allotted: u32 = capacities.iter().sum();
    let mut cursor = 0;
    while allotted < scarce_total {
        capacities[cursor % scarce_count] += 1;
        allotted += 1;
        cursor += 1;
    }
    let mut scarce_ids = Vec::new();
    for (index, &capacity) in capacities.iter().enumerate() {
        let id = format!("{scarce_resource}_{index:02}");
        resources.push(Resource {
            id: id.clone(),
            capacity,
        });
        scarce_ids.push(id);
    }

    let mut neighbourhood = scarce_ids.clone();
    if use_bridge {
        let bridge = format!("{scarce_resource}_bridge_00");
        resources.push(Resource {
            id: bridge.clone(),
            capacity: 1,
        });
        neighbourhood.push(bridge);
        for link in 1..cascade {
            resources.push(Resource {
                id: format!("{scarce_resource}_bridge_{link:02}"),
                capacity: 1,
            });
        }
        for link in 0..cascade {
            let id = format!("{scarce_task}_chain_{link:02}");
            tasks.push(Task {
                id: id.clone(),
                demand: 1,
                distinct: false,
            });
            eligible.push((id.clone(), format!("{scarce_resource}_bridge_{link:02}")));
            if link + 1 < cascade {
                eligible.push((id, format!("{scarce_resource}_bridge_{:02}", link + 1)));
            }
        }
    }

    for index in 0..plant {
        let id = format!("{scarce_task}_{index:02}");
        tasks.push(Task {
            id: id.clone(),
            demand: 1,
            distinct: false,
        });
        for resource in &neighbourhood {
            eligible.push((id.clone(), resource.clone()));
        }
        ground_truth.planted_tasks.push(id);
    }
    ground_truth.feasible = false;
    ground_truth
        .planted_resources
        .extend(neighbourhood.iter().cloned());
    ground_truth.minimal_certificate_size = Some(plant);
    ground_truth.expected_raw_deficient =
        Some(ground_truth.expected_raw_deficient.unwrap_or(0) + plant
            + if use_bridge { cascade } else { 0 });
    ground_truth.bottleneck_count = Some(ground_truth.bottleneck_count.unwrap_or(0) + 1);
    let block: Vec<String> = ground_truth
        .planted_tasks
        .iter()
        .rev()
        .take(plant)
        .rev()
        .cloned()
        .collect();
    ground_truth.planted_blocks.push(block);
}

/// Shift rostering with qualifications.
///
/// The feasible core is built by drawing a valid assignment first and taking eligibility as
/// a superset of it, so the base instance is feasible by construction. `plant` then adds a
/// block of `plant` shifts requiring a rare qualification whose holders have total capacity
/// `plant - 1`; those holders are also generally qualified, so the alternating-reachable
/// deficient set spreads well beyond the planted block.
fn generate_roster(
    seed: u64,
    shifts: usize,
    nurses: usize,
    plant: usize,
    cascade: usize,
) -> Instance {
    let mut rng = Rng(seed);
    let mut tasks = Vec::new();
    let mut resources = Vec::new();
    let mut eligible = Vec::new();

    let capacity_each = ((shifts as f64 / nurses as f64).ceil() as u32).max(1) + 1;
    let mut nurse_quals: Vec<Vec<&str>> = Vec::with_capacity(nurses);
    for index in 0..nurses {
        let mut quals = vec![QUALIFICATIONS[0]];
        for qual in &QUALIFICATIONS[1..] {
            if rng.below(100) < 45 {
                quals.push(qual);
            }
        }
        resources.push(Resource {
            id: format!("nurse_{index:03}"),
            capacity: capacity_each,
        });
        nurse_quals.push(quals);
    }

    let mut remaining: Vec<u32> = vec![capacity_each; nurses];
    for index in 0..shifts {
        let day = index / 3;
        let slot = ["am", "pm", "night"][index % 3];
        let id = format!("shift_d{day:02}_{slot}");
        // Pick a qualification some nurse with residual capacity actually holds.
        let mut chosen = QUALIFICATIONS[0];
        for _ in 0..8 {
            let candidate = QUALIFICATIONS[rng.below(QUALIFICATIONS.len())];
            if nurse_quals
                .iter()
                .enumerate()
                .any(|(n, quals)| remaining[n] > 0 && quals.contains(&candidate))
            {
                chosen = candidate;
                break;
            }
        }
        let holders: Vec<usize> = (0..nurses)
            .filter(|&n| nurse_quals[n].contains(&chosen))
            .collect();
        // Reserve one holder with residual capacity, guaranteeing a feasible base.
        let mut reserved = None;
        for _ in 0..(4 * holders.len().max(1)) {
            let candidate = holders[rng.below(holders.len().max(1))];
            if remaining[candidate] > 0 {
                reserved = Some(candidate);
                break;
            }
        }
        let reserved = match reserved.or_else(|| holders.iter().copied().find(|&n| remaining[n] > 0))
        {
            Some(n) => n,
            None => continue,
        };
        remaining[reserved] -= 1;
        tasks.push(Task {
            id: id.clone(),
            demand: 1,
            distinct: false,
        });
        eligible.push((id.clone(), resources[reserved].id.clone()));
        for &holder in &holders {
            if holder != reserved && rng.below(100) < 60 {
                eligible.push((id.clone(), resources[holder].id.clone()));
            }
        }
    }

    let mut ground_truth = GroundTruth {
        feasible: true,
        planted_tasks: Vec::new(),
        planted_resources: Vec::new(),
        minimal_certificate_size: None,
        expected_raw_deficient: None,
        bottleneck_count: None,
        planted_blocks: Vec::new(),
    };

    if plant > 0 {
        plant_block(
            &mut tasks,
            &mut resources,
            &mut eligible,
            "shift_perfusion",
            "nurse_perfusionist",
            plant,
            cascade,
            &mut ground_truth,
        );
    }

    Instance {
        schema: INSTANCE_SCHEMA.into(),
        name: format!("roster-s{seed}-t{shifts}-r{nurses}-plant{plant}-cascade{cascade}"),
        tasks,
        resources,
        eligible,
        couplings: Vec::new(),
        ground_truth: Some(ground_truth),
    }
}

const ACCELERATORS: [(&str, u32); 3] = [("a100", 40), ("h100", 80), ("l4", 24)];

/// Compute-capacity placement: jobs need an accelerator class and a memory footprint,
/// hosts carry a class, a per-card memory size, and a slot capacity.
///
/// Planting over-subscribes one host class: `plant` jobs against hosts of total capacity
/// `plant - 1`. Minimal certificates therefore have size `plant`, but unlike the roster
/// case they are *not* unique, because any `plant` of the pool works when the pool is
/// larger.
fn generate_placement(
    seed: u64,
    jobs: usize,
    hosts: usize,
    plant: usize,
    cascade: usize,
) -> Instance {
    let mut rng = Rng(seed);
    let mut tasks = Vec::new();
    let mut resources = Vec::new();
    let mut eligible = Vec::new();

    let mut host_spec = Vec::with_capacity(hosts);
    for index in 0..hosts {
        let (class, memory) = ACCELERATORS[rng.below(ACCELERATORS.len())];
        let capacity = 2 + rng.below(4) as u32;
        let id = format!("host_{index:03}");
        resources.push(Resource {
            id: id.clone(),
            capacity,
        });
        host_spec.push((id, class, memory, capacity));
    }

    let mut remaining: Vec<u32> = host_spec.iter().map(|s| s.3).collect();
    for index in 0..jobs {
        let (class, max_memory) = ACCELERATORS[rng.below(ACCELERATORS.len())];
        let memory = 8 + rng.below((max_memory - 8) as usize) as u32;
        let candidates: Vec<usize> = (0..hosts)
            .filter(|&h| host_spec[h].1 == class && host_spec[h].2 >= memory)
            .collect();
        if candidates.is_empty() {
            continue;
        }
        let mut reserved = None;
        for _ in 0..(4 * candidates.len()) {
            let candidate = candidates[rng.below(candidates.len())];
            if remaining[candidate] > 0 {
                reserved = Some(candidate);
                break;
            }
        }
        let reserved = match reserved.or_else(|| candidates.iter().copied().find(|&h| remaining[h] > 0))
        {
            Some(h) => h,
            None => continue,
        };
        remaining[reserved] -= 1;
        let id = format!("job_{index:04}_{class}_{memory}g");
        tasks.push(Task {
            id: id.clone(),
            demand: 1,
            distinct: false,
        });
        for &candidate in &candidates {
            eligible.push((id.clone(), host_spec[candidate].0.clone()));
        }
    }

    let mut ground_truth = GroundTruth {
        feasible: true,
        planted_tasks: Vec::new(),
        planted_resources: Vec::new(),
        minimal_certificate_size: None,
        expected_raw_deficient: None,
        bottleneck_count: None,
        planted_blocks: Vec::new(),
    };

    if plant > 0 {
        plant_block(
            &mut tasks,
            &mut resources,
            &mut eligible,
            "job_h200",
            "host_h200",
            plant,
            cascade,
            &mut ground_truth,
        );
    }

    Instance {
        schema: INSTANCE_SCHEMA.into(),
        name: format!("placement-s{seed}-t{jobs}-r{hosts}-plant{plant}-cascade{cascade}"),
        tasks,
        resources,
        eligible,
        couplings: Vec::new(),
        ground_truth: Some(ground_truth),
    }
}

/// A deliberately non-matching instance: row sums, column sums and pairwise inner products
/// together. This is the C1018 failure mode; the tool must decline.
fn generate_coupled(seed: u64, rows: usize, columns: usize) -> Instance {
    let mut rng = Rng(seed);
    let tasks: Vec<Task> = (0..rows)
        .map(|i| Task {
            id: format!("row_{i:02}"),
            demand: 3,
            distinct: true,
        })
        .collect();
    let resources: Vec<Resource> = (0..columns)
        .map(|j| Resource {
            id: format!("col_{j:02}"),
            capacity: 3,
        })
        .collect();
    let mut eligible = Vec::new();
    for task in &tasks {
        for resource in &resources {
            if rng.below(100) < 70 {
                eligible.push((task.id.clone(), resource.id.clone()));
            }
        }
    }
    let mut couplings = vec![
        Coupling::PrescribedRowSums {
            sums: vec![3; rows],
        },
        Coupling::PrescribedColumnSums {
            sums: vec![3; columns],
        },
    ];
    for i in 0..rows {
        for j in (i + 1)..rows {
            couplings.push(Coupling::PairwiseInnerProduct {
                tasks: [format!("row_{i:02}"), format!("row_{j:02}")],
                value: 1,
            });
        }
    }
    Instance {
        schema: INSTANCE_SCHEMA.into(),
        name: format!("coupled-s{seed}-r{rows}-c{columns}"),
        tasks,
        resources,
        eligible,
        couplings,
        ground_truth: None,
    }
}

/// A roster with three independent shortages of different sizes. A single unsatisfiable
/// core names one of them; this is where per-bottleneck decomposition pays.
fn generate_multi_roster(
    seed: u64,
    shifts: usize,
    nurses: usize,
    plant: usize,
    cascade: usize,
) -> Instance {
    let mut instance = generate_roster(seed, shifts, nurses, 0, 0);
    let mut ground_truth = instance.ground_truth.take().unwrap_or(GroundTruth {
        feasible: true,
        planted_tasks: Vec::new(),
        planted_resources: Vec::new(),
        minimal_certificate_size: None,
        expected_raw_deficient: None,
        bottleneck_count: None,
        planted_blocks: Vec::new(),
    });
    let sizes: Vec<usize> = if plant == 0 {
        Vec::new()
    } else {
        vec![plant, plant + 2, plant + 5]
    };
    for (index, size) in sizes.into_iter().enumerate() {
        plant_block(
            &mut instance.tasks,
            &mut instance.resources,
            &mut instance.eligible,
            &format!("shift_scarce{index}"),
            &format!("nurse_scarce{index}"),
            size,
            cascade,
            &mut ground_truth,
        );
    }
    // `minimal_certificate_size` is per block and no longer single-valued here.
    ground_truth.minimal_certificate_size = None;
    if plant == 0 {
        ground_truth.feasible = true;
    }
    instance.ground_truth = Some(ground_truth);
    instance.name = format!("multiroster-s{seed}-t{shifts}-r{nurses}-plant{plant}-cascade{cascade}");
    instance
}

/// The most common real roster shape that this tool must refuse: every shift needs two
/// *distinct* nurses. Hall's condition is necessary but not sufficient here.
fn generate_distinct_roster(
    seed: u64,
    shifts: usize,
    nurses: usize,
    plant: usize,
    cascade: usize,
) -> Instance {
    let mut instance = generate_roster(seed, shifts, nurses, plant, cascade);
    instance.name = format!("distinct-{}", instance.name);
    for task in &mut instance.tasks {
        task.demand = 2;
        task.distinct = true;
    }
    instance.ground_truth = None;
    instance
}

/// Resource-side exact loads only: still not a matching, and the decline must name
/// Gale-Ryser / flow feasibility rather than the quadratic story.
fn generate_exact_load(seed: u64, rows: usize, columns: usize) -> Instance {
    let mut instance = generate_coupled(seed, rows, columns);
    instance.name = format!("exactload-s{seed}-r{rows}-c{columns}");
    instance.couplings = instance
        .resources
        .iter()
        .map(|r| Coupling::ResourceExactLoad {
            resource: r.id.clone(),
            load: 3,
        })
        .collect();
    instance
}

// ---------------------------------------------------------------------------
// CLI
// ---------------------------------------------------------------------------

#[derive(Copy, Clone, Debug, ValueEnum)]
enum Domain {
    Roster,
    Placement,
    MultiRoster,
    DistinctRoster,
    Coupled,
    ExactLoad,
}

#[derive(Args, Debug)]
struct GenerateArgs {
    #[arg(long, value_enum)]
    domain: Domain,
    #[arg(long, default_value_t = 1)]
    seed: u64,
    /// Number of tasks (shifts / jobs / rows) in the feasible core.
    #[arg(long, default_value_t = 120)]
    tasks: usize,
    /// Number of resources (nurses / hosts / columns) in the feasible core.
    #[arg(long, default_value_t = 40)]
    resources: usize,
    /// Size of the planted violation; 0 leaves the instance feasible.
    #[arg(long, default_value_t = 0)]
    plant: usize,
    /// Length of the forced alternating chain attached to the planted block. It inflates
    /// the maximum-deficiency set without joining the minimal certificate.
    #[arg(long, default_value_t = 0)]
    cascade: usize,
    #[arg(long)]
    out: PathBuf,
}

#[derive(Subcommand, Debug)]
enum Command {
    /// Write a generated instance to JSON.
    Generate(GenerateArgs),
    /// Report which regime an instance is in, and whether we may certify it.
    Classify {
        #[arg(long)]
        input: PathBuf,
    },
    /// Produce a feasible assignment or an irreducible Hall certificate.
    Solve {
        #[arg(long)]
        input: PathBuf,
        #[arg(long)]
        out: Option<PathBuf>,
    },
    /// Recheck a certificate against its instance, independently of `hall_core`.
    Verify {
        #[arg(long)]
        input: PathBuf,
        #[arg(long)]
        certificate: PathBuf,
    },
    /// Build the whole benchmark family under one directory.
    Suite {
        #[arg(long)]
        out: PathBuf,
    },
    /// Internal consistency checks, including brute force on small random instances.
    Selftest,
}

#[derive(Parser, Debug)]
#[command(name = "certiis", about = "Explainable infeasibility for assignment problems")]
struct Arguments {
    #[command(subcommand)]
    command: Command,
}

fn read_instance(path: &Path) -> anyhow::Result<(Instance, Vec<u8>)> {
    let raw = fs::read(path).with_context(|| format!("reading {}", path.display()))?;
    let instance: Instance = serde_json::from_slice(&raw)
        .with_context(|| format!("parsing {} as {INSTANCE_SCHEMA}", path.display()))?;
    Ok((instance, raw))
}

fn write_json<T: Serialize>(path: &Path, value: &T) -> anyhow::Result<()> {
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent).ok();
    }
    let mut bytes = serde_json::to_vec_pretty(value)?;
    bytes.push(b'\n');
    fs::write(path, bytes).with_context(|| format!("writing {}", path.display()))
}

fn build(domain: Domain, args: &GenerateArgs) -> Instance {
    match domain {
        Domain::Roster => {
            generate_roster(args.seed, args.tasks, args.resources, args.plant, args.cascade)
        }
        Domain::Placement => {
            generate_placement(args.seed, args.tasks, args.resources, args.plant, args.cascade)
        }
        Domain::MultiRoster => {
            generate_multi_roster(args.seed, args.tasks, args.resources, args.plant, args.cascade)
        }
        Domain::DistinctRoster => generate_distinct_roster(
            args.seed,
            args.tasks,
            args.resources,
            args.plant,
            args.cascade,
        ),
        Domain::Coupled => generate_coupled(args.seed, args.tasks, args.resources),
        Domain::ExactLoad => generate_exact_load(args.seed, args.tasks, args.resources),
    }
}

fn main() -> anyhow::Result<()> {
    let arguments = Arguments::parse();
    match arguments.command {
        Command::Generate(args) => {
            let instance = build(args.domain, &args);
            write_json(&args.out, &instance)?;
            println!(
                "{}: {} tasks, {} resources, {} eligible pairs -> {}",
                instance.name,
                instance.tasks.len(),
                instance.resources.len(),
                instance.eligible.len(),
                args.out.display()
            );
        }
        Command::Classify { input } => {
            let (instance, _) = read_instance(&input)?;
            let classification = classify(&instance);
            println!("{}", serde_json::to_string_pretty(&classification)?);
        }
        Command::Solve { input, out } => {
            let (instance, raw) = read_instance(&input)?;
            let report = solve(&instance, &raw)?;
            let line = match &report.verdict {
                Verdict::Feasible { .. } => format!("FEASIBLE ({})", report.regime),
                Verdict::Infeasible {
                    raw_deficient_tasks,
                    certificates,
                } => {
                    let detail = certificates
                        .iter()
                        .map(|c| {
                            format!(
                                "{} tasks demand {} units, their {} eligible resources supply {}",
                                c.tasks.len(),
                                c.demand,
                                c.neighborhood.len(),
                                c.neighborhood_capacity
                            )
                        })
                        .collect::<Vec<_>>()
                        .join("; ");
                    format!(
                        "INFEASIBLE ({}): {} bottleneck(s) from a {raw_deficient_tasks}-task \
                         deficient set -- {detail}",
                        report.regime,
                        certificates.len()
                    )
                }
                Verdict::Declined { .. } => format!("DECLINED ({})", report.regime),
            };
            println!("{line} [{} us]", report.total_micros);
            if let Some(path) = out {
                write_json(&path, &report)?;
            } else {
                println!("{}", serde_json::to_string_pretty(&report)?);
            }
        }
        Command::Verify { input, certificate } => {
            let (instance, raw) = read_instance(&input)?;
            let bytes = fs::read(&certificate)
                .with_context(|| format!("reading {}", certificate.display()))?;
            let report: Report = serde_json::from_slice(&bytes)
                .with_context(|| format!("parsing {}", certificate.display()))?;
            let checks = verify(&instance, &raw, &report)?;
            for check in &checks {
                println!("ok: {check}");
            }
            println!("VERIFIED");
        }
        Command::Suite { out } => {
            fs::create_dir_all(&out)?;
            let mut written = 0;
            for seed in 1..=5u64 {
                for (domain, tasks, resources) in [
                    (Domain::Roster, 150usize, 45usize),
                    (Domain::Placement, 200, 50),
                    (Domain::MultiRoster, 150, 45),
                ] {
                    for (plant, cascade) in
                        [(0usize, 0usize), (4, 0), (4, 40), (9, 40), (17, 120)]
                    {
                        let args = GenerateArgs {
                            domain,
                            seed,
                            tasks,
                            resources,
                            plant,
                            cascade,
                            out: PathBuf::new(),
                        };
                        let instance = build(domain, &args);
                        let path = out.join(format!("{}.json", instance.name));
                        write_json(&path, &instance)?;
                        written += 1;
                    }
                }
            }
            for (domain, tasks, resources) in [
                (Domain::Coupled, 12usize, 12usize),
                (Domain::ExactLoad, 12, 12),
                (Domain::DistinctRoster, 60, 20),
            ] {
                let args = GenerateArgs {
                    domain,
                    seed: 7,
                    tasks,
                    resources,
                    plant: 0,
                    cascade: 0,
                    out: PathBuf::new(),
                };
                let instance = build(domain, &args);
                let path = out.join(format!("{}.json", instance.name));
                write_json(&path, &instance)?;
                written += 1;
            }
            println!("wrote {written} instances to {}", out.display());
        }
        Command::Selftest => selftest()?,
    }
    Ok(())
}

// ---------------------------------------------------------------------------
// Selftest: brute force cross-check on small random instances
// ---------------------------------------------------------------------------

fn brute_force_feasible(compiled: &Compiled) -> bool {
    // Exhaustive check of the defect Hall condition over every task subset.
    let n = compiled.task_count();
    assert!(n <= 16);
    for mask in 0u32..(1 << n) {
        let set: Vec<u32> = (0..n as u32).filter(|&t| mask & (1 << t) != 0).collect();
        let hood = compiled.neighborhood(&set);
        if compiled.demand_of(&set) > compiled.capacity_of(&hood) {
            return false;
        }
    }
    true
}

fn selftest() -> anyhow::Result<()> {
    let mut rng = Rng(0xC0FFEE);
    let mut infeasible_seen = 0;
    let mut feasible_seen = 0;
    for trial in 0..4000u32 {
        let tasks = 1 + rng.below(6);
        let resources = 1 + rng.below(5);
        let mut instance = Instance {
            schema: INSTANCE_SCHEMA.into(),
            name: format!("selftest-{trial}"),
            tasks: (0..tasks)
                .map(|i| Task {
                    id: format!("t{i}"),
                    demand: 1 + rng.below(2) as u32,
                    distinct: false,
                })
                .collect(),
            resources: (0..resources)
                .map(|j| Resource {
                    id: format!("r{j}"),
                    capacity: 1 + rng.below(3) as u32,
                })
                .collect(),
            eligible: Vec::new(),
            couplings: Vec::new(),
            ground_truth: None,
        };
        for i in 0..tasks {
            for j in 0..resources {
                if rng.below(100) < 45 {
                    instance
                        .eligible
                        .push((format!("t{i}"), format!("r{j}")));
                }
            }
        }
        let raw = serde_json::to_vec(&instance)?;
        let compiled = Compiled::build(&instance)?;
        let expected = brute_force_feasible(&compiled);
        let report = solve(&instance, &raw)?;
        match &report.verdict {
            Verdict::Feasible { .. } => {
                anyhow::ensure!(expected, "trial {trial}: claimed feasible, brute force says not");
                feasible_seen += 1;
            }
            Verdict::Infeasible { .. } => {
                anyhow::ensure!(!expected, "trial {trial}: claimed infeasible, brute force says feasible");
                infeasible_seen += 1;
            }
            Verdict::Declined { .. } => bail!("trial {trial}: unexpected decline"),
        }
        verify(&instance, &raw, &report)
            .with_context(|| format!("trial {trial}: verification failed"))?;
    }
    println!("selftest ok: {feasible_seen} feasible and {infeasible_seen} infeasible random instances, each cross-checked against exhaustive defect-Hall and independently verified");

    // Generated instances must match their own planted ground truth exactly.
    for (plant, cascade) in [(4usize, 0usize), (4, 40), (9, 40), (17, 120)] {
        for seed in 1..=3u64 {
            for instance in [
                generate_roster(seed, 150, 45, plant, cascade),
                generate_placement(seed, 200, 50, plant, cascade),
            ] {
                let truth = instance.ground_truth.clone().expect("planted ground truth");
                let raw_bytes = serde_json::to_vec(&instance)?;
                let report = solve(&instance, &raw_bytes)?;
                let Verdict::Infeasible {
                    raw_deficient_tasks,
                    certificates,
                } = &report.verdict
                else {
                    bail!("{} should be infeasible", instance.name);
                };
                anyhow::ensure!(
                    certificates.len() == 1,
                    "{}: one planted bottleneck but {} certificates",
                    instance.name,
                    certificates.len()
                );
                let certificate = &certificates[0];
                anyhow::ensure!(
                    certificate.tasks.len() == truth.minimal_certificate_size.unwrap(),
                    "{}: certificate has {} tasks, planted minimum is {:?}",
                    instance.name,
                    certificate.tasks.len(),
                    truth.minimal_certificate_size
                );
                anyhow::ensure!(
                    certificate.tasks == truth.planted_tasks,
                    "{}: certificate is not the planted task set",
                    instance.name
                );
                anyhow::ensure!(
                    *raw_deficient_tasks == truth.expected_raw_deficient.unwrap(),
                    "{}: maximum-deficiency set has {raw_deficient_tasks} tasks, expected {:?}",
                    instance.name,
                    truth.expected_raw_deficient
                );
                verify(&instance, &raw_bytes, &report)?;
            }
        }
    }
    println!(
        "selftest ok: every planted instance returns exactly its planted minimal certificate, \
         with the expected pre-minimization maximum-deficiency set"
    );

    // Several independent shortages must come back separated, not merged into one blob.
    for seed in 1..=3u64 {
        let instance = generate_multi_roster(seed, 150, 45, 4, 40);
        let truth = instance.ground_truth.clone().expect("planted ground truth");
        let raw_bytes = serde_json::to_vec(&instance)?;
        let report = solve(&instance, &raw_bytes)?;
        let Verdict::Infeasible { certificates, .. } = &report.verdict else {
            bail!("{} should be infeasible", instance.name);
        };
        anyhow::ensure!(
            certificates.len() == truth.bottleneck_count.unwrap(),
            "{}: {} certificates for {:?} planted bottlenecks",
            instance.name,
            certificates.len(),
            truth.bottleneck_count
        );
        let mut found: Vec<Vec<String>> = certificates.iter().map(|c| c.tasks.clone()).collect();
        let mut expected = truth.planted_blocks.clone();
        found.sort();
        expected.sort();
        anyhow::ensure!(
            found == expected,
            "{}: certificates are not the planted blocks",
            instance.name
        );
        verify(&instance, &raw_bytes, &report)?;
    }
    println!(
        "selftest ok: instances with three independent shortages return three separate \
         certificates, each exactly its planted block"
    );

    // The classifier must decline on the non-matching shapes.
    for instance in [
        generate_coupled(3, 8, 8),
        generate_exact_load(3, 8, 8),
        generate_distinct_roster(3, 40, 15, 0, 0),
    ] {
        let raw = serde_json::to_vec(&instance)?;
        let report = solve(&instance, &raw)?;
        match &report.verdict {
            Verdict::Declined { needed_instead } => {
                anyhow::ensure!(!needed_instead.is_empty());
                println!("selftest ok: {} declined as {}", instance.name, report.regime);
            }
            _ => bail!("{} was not declined", instance.name),
        }
        verify(&instance, &raw, &report)?;
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn instance_from(
        tasks: &[(&str, u32)],
        resources: &[(&str, u32)],
        edges: &[(&str, &str)],
    ) -> Instance {
        Instance {
            schema: INSTANCE_SCHEMA.into(),
            name: "test".into(),
            tasks: tasks
                .iter()
                .map(|&(id, demand)| Task {
                    id: id.into(),
                    demand,
                    distinct: false,
                })
                .collect(),
            resources: resources
                .iter()
                .map(|&(id, capacity)| Resource {
                    id: id.into(),
                    capacity,
                })
                .collect(),
            eligible: edges
                .iter()
                .map(|&(t, r)| (t.to_string(), r.to_string()))
                .collect(),
            couplings: Vec::new(),
            ground_truth: None,
        }
    }

    #[test]
    fn minimal_certificate_is_exactly_the_tight_block() {
        // t0,t1,t2 all only see r0; t3..t9 have their own resources.
        let mut tasks = vec![("t0", 1), ("t1", 1), ("t2", 1)];
        let mut resources = vec![("r0", 1)];
        let mut edges = vec![("t0", "r0"), ("t1", "r0"), ("t2", "r0")];
        for i in 3..10 {
            let t: &'static str = Box::leak(format!("t{i}").into_boxed_str());
            let r: &'static str = Box::leak(format!("r{i}").into_boxed_str());
            tasks.push((t, 1));
            resources.push((r, 1));
            edges.push((t, r));
            edges.push((t, "r0"));
        }
        let instance = instance_from(&tasks, &resources, &edges);
        let raw = serde_json::to_vec(&instance).unwrap();
        let report = solve(&instance, &raw).unwrap();
        match &report.verdict {
            Verdict::Infeasible { certificates, .. } => {
                assert_eq!(certificates.len(), 1);
                let certificate = &certificates[0];
                assert_eq!(certificate.tasks.len(), 2, "{:?}", certificate.tasks);
                assert_eq!(certificate.neighborhood, vec!["r0".to_string()]);
                assert!(certificate.removal_tests.iter().all(|t| !t.still_violated));
            }
            other => panic!("expected infeasible, got {other:?}"),
        }
        verify(&instance, &raw, &report).unwrap();
    }

    #[test]
    fn capacities_are_respected_in_both_directions() {
        // one resource of capacity 3, one task of demand 3: feasible.
        let feasible = instance_from(&[("t", 3)], &[("r", 3)], &[("t", "r")]);
        let raw = serde_json::to_vec(&feasible).unwrap();
        let report = solve(&feasible, &raw).unwrap();
        match &report.verdict {
            Verdict::Feasible { assignment } => {
                assert_eq!(assignment[0].resources[0].units, 3);
            }
            other => panic!("expected feasible, got {other:?}"),
        }
        verify(&feasible, &raw, &report).unwrap();

        // demand 4 against capacity 3: infeasible with a one-task certificate.
        let infeasible = instance_from(&[("t", 4)], &[("r", 3)], &[("t", "r")]);
        let raw = serde_json::to_vec(&infeasible).unwrap();
        let report = solve(&infeasible, &raw).unwrap();
        match &report.verdict {
            Verdict::Infeasible { certificates, .. } => {
                assert_eq!(certificates[0].tasks, vec!["t".to_string()]);
                assert_eq!(certificates[0].deficit, 1);
            }
            other => panic!("expected infeasible, got {other:?}"),
        }
        verify(&infeasible, &raw, &report).unwrap();
    }

    #[test]
    fn independent_bottlenecks_come_back_separated() {
        // Three tasks on two resources, four tasks on three others. A single irreducible
        // set would pad one shortage with part of the other; two certificates do not.
        let instance = instance_from(
            &[("a1", 1), ("a2", 1), ("a3", 1), ("b1", 1), ("b2", 1), ("b3", 1), ("b4", 1)],
            &[("ra1", 1), ("ra2", 1), ("rb1", 1), ("rb2", 1), ("rb3", 1)],
            &[
                ("a1", "ra1"), ("a1", "ra2"), ("a2", "ra1"), ("a2", "ra2"),
                ("a3", "ra1"), ("a3", "ra2"),
                ("b1", "rb1"), ("b1", "rb2"), ("b1", "rb3"),
                ("b2", "rb1"), ("b2", "rb2"), ("b2", "rb3"),
                ("b3", "rb1"), ("b3", "rb2"), ("b3", "rb3"),
                ("b4", "rb1"), ("b4", "rb2"), ("b4", "rb3"),
            ],
        );
        let raw = serde_json::to_vec(&instance).unwrap();
        let report = solve(&instance, &raw).unwrap();
        match &report.verdict {
            Verdict::Infeasible { certificates, .. } => {
                assert_eq!(certificates.len(), 2);
                assert_eq!(certificates[0].tasks, vec!["a1", "a2", "a3"]);
                assert_eq!(certificates[0].neighborhood, vec!["ra1", "ra2"]);
                assert_eq!(certificates[1].tasks, vec!["b1", "b2", "b3", "b4"]);
                assert_eq!(certificates[1].neighborhood, vec!["rb1", "rb2", "rb3"]);
            }
            other => panic!("expected infeasible, got {other:?}"),
        }
        verify(&instance, &raw, &report).unwrap();
    }

    #[test]
    fn classifier_declines_on_row_column_and_inner_product_structure() {
        let coupled = generate_coupled(1, 6, 6);
        assert_eq!(classify(&coupled).regime, "quadratically_coupled");
        assert!(!classify(&coupled).certifiable);
        let exact = generate_exact_load(1, 6, 6);
        assert_eq!(classify(&exact).regime, "degree_constrained_completion");
    }

    #[test]
    fn classifier_declines_when_a_task_needs_distinct_resources() {
        // One task of demand 2 against one resource of capacity 5 passes every task-side
        // Hall test and is nonetheless infeasible: the tool must not certify it.
        let mut instance = instance_from(&[("t", 2)], &[("r", 5)], &[("t", "r")]);
        instance.tasks[0].distinct = true;
        let classification = classify(&instance);
        assert_eq!(classification.regime, "degree_constrained_completion");
        assert!(!classification.certifiable);

        let raw = serde_json::to_vec(&instance).unwrap();
        let report = solve(&instance, &raw).unwrap();
        assert!(matches!(report.verdict, Verdict::Declined { .. }));
        verify(&instance, &raw, &report).unwrap();
    }

    #[test]
    fn verification_rejects_a_tampered_certificate() {
        let instance = instance_from(
            &[("a", 1), ("b", 1), ("c", 1)],
            &[("x", 1)],
            &[("a", "x"), ("b", "x"), ("c", "x")],
        );
        let raw = serde_json::to_vec(&instance).unwrap();
        let mut report = solve(&instance, &raw).unwrap();
        if let Verdict::Infeasible { certificates, .. } = &mut report.verdict {
            let certificate = &mut certificates[0];
            certificate.tasks.push("c".into());
            certificate.demand += 1;
            certificate.deficit += 1;
            certificate.removal_tests.push(RemovalTest {
                removed_task: "c".into(),
                demand_after: 2,
                capacity_after: 1,
                still_violated: false,
            });
        }
        assert!(verify(&instance, &raw, &report).is_err());
    }
}
