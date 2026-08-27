use anyhow::{bail, Context, Result};
use clap::{Parser, Subcommand};
use ergo_comp::{
    azure_lrc_12_2_2_upgrade_domains, ceph_xor_repair_supports, compile_binary_rank_one,
    compile_binary_target_subspace, confinement_by_generators_field, gpu_checkpoint_mds_recovery,
    minimum_node_span_repair, schedule_repair_dag, CephXorLayer, CoefficientWitness,
    CompositionTable, CompositionTower, ConfinementSector, CostTable, FiniteField, Gf4, Matrix,
    MatrixCoefficientWitness, Prime, QcLdpcCode, RepairTask, TowerLevel, TowerWitness,
    WeightedRepairProblem, WeightedSchedulerBackend,
};
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use std::io::{self, Read};
use std::num::NonZeroUsize;
use std::path::{Path, PathBuf};

#[derive(Debug, Parser)]
#[command(
    name = "ergo-comp",
    version,
    about = "Exact compiler for hierarchical linear-code recovery"
)]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Debug, Subcommand)]
enum Command {
    /// Compose labelled inner recovery costs through outer linear blocks.
    Compose {
        /// JSON input file, or '-' for standard input.
        #[arg(short, long, default_value = "-")]
        input: PathBuf,
        /// Use the optional parallel composition kernel.
        #[arg(long)]
        parallel: bool,
        /// Number of workers; defaults to available parallelism.
        #[arg(long, requires = "parallel")]
        threads: Option<NonZeroUsize>,
    },
    /// Analyze exact rank-one transfer from represented binary inner encoders.
    Transfer {
        /// JSON input file, or '-' for standard input.
        #[arg(short, long, default_value = "-")]
        input: PathBuf,
    },
    /// Analyze an explicit normalized target subspace and its exact transfer.
    TransferSubspace {
        /// JSON input file, or '-' for standard input.
        #[arg(short, long, default_value = "-")]
        input: PathBuf,
    },
    /// Compile represented recovery data through a tower and replay its witness tree.
    TransferTower {
        /// JSON input file, or '-' for standard input.
        #[arg(short, long, default_value = "-")]
        input: PathBuf,
        /// Use the optional parallel composition kernel.
        #[arg(long)]
        parallel: bool,
        /// Number of workers; defaults to available parallelism.
        #[arg(long, requires = "parallel")]
        threads: Option<NonZeroUsize>,
    },
    /// Maximize simultaneous repairs under resource capacities.
    Schedule {
        /// JSON input file, or '-' for standard input.
        #[arg(short, long, default_value = "-")]
        input: PathBuf,
        /// Use parallel Pareto kernels when the selected backend benefits.
        #[arg(long)]
        parallel: bool,
        /// Number of workers; defaults to available parallelism.
        #[arg(long, requires = "parallel")]
        threads: Option<NonZeroUsize>,
    },
    /// Run an exact storage, repair-DAG, QC-LDPC, vector-code, or GPU-checkpoint analysis.
    Application {
        /// Tagged JSON input file, or '-' for standard input.
        #[arg(short, long, default_value = "-")]
        input: PathBuf,
    },
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
struct MatrixSpec {
    rows: usize,
    cols: usize,
    data: Vec<u8>,
}

impl MatrixSpec {
    fn into_matrix_field<F: FiniteField>(self) -> Result<Matrix> {
        Matrix::new_field::<F>(self.rows, self.cols, self.data)
            .context("invalid reduced matrix in input")
    }

    fn from_matrix(matrix: &Matrix) -> Self {
        Self {
            rows: matrix.rows(),
            cols: matrix.cols(),
            data: matrix.as_slice().to_vec(),
        }
    }
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct CostEntrySpec {
    label: MatrixSpec,
    cost: u32,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct CostTableSpec {
    rows: usize,
    cols: usize,
    entries: Vec<CostEntrySpec>,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct ComposeInput {
    #[serde(default)]
    prime: Option<u8>,
    #[serde(default)]
    field: Option<FieldSpec>,
    inner: CostTableSpec,
    outer_blocks: Vec<MatrixSpec>,
    target: MatrixSpec,
}

#[derive(Clone, Debug, Deserialize)]
#[serde(tag = "kind", rename_all = "kebab-case", deny_unknown_fields)]
enum FieldSpec {
    Prime { order: u8 },
    BinaryExtension { degree: u8, modulus: Vec<u8> },
}

#[derive(Clone, Copy, Debug)]
enum FieldSelection {
    Prime(u8),
    Gf4,
}

impl ComposeInput {
    fn field_selection(&self) -> Result<FieldSelection> {
        match (&self.prime, &self.field) {
            (Some(_), Some(_)) => bail!("declare either 'prime' or 'field', not both"),
            (None, None) => bail!("missing field declaration: supply 'prime' or 'field'"),
            (Some(order), None) => Ok(FieldSelection::Prime(*order)),
            (None, Some(FieldSpec::Prime { order })) => Ok(FieldSelection::Prime(*order)),
            (
                None,
                Some(FieldSpec::BinaryExtension {
                    degree: 2,
                    modulus,
                }),
            ) if modulus.as_slice() == [1, 1, 1] => Ok(FieldSelection::Gf4),
            (None, Some(FieldSpec::BinaryExtension { degree, modulus })) => bail!(
                "unsupported binary extension GF(2^{degree}) with modulus {modulus:?}; supported extension is GF(4) with modulus [1, 1, 1]"
            ),
        }
    }
}

fn default_candidate_budget() -> u64 {
    1 << 20
}

fn default_witness_node_budget() -> u64 {
    1 << 20
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct EncoderSpec {
    name: String,
    columns: Vec<u8>,
    target_coordinate: usize,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct TransferInput {
    field: FieldSpec,
    base_prime: u8,
    inner_encoders: Vec<EncoderSpec>,
    outer_functional_dual_basis: MatrixSpec,
    target_block: usize,
    #[serde(default = "default_candidate_budget")]
    candidate_budget: u64,
    #[serde(default = "default_candidate_budget")]
    outer_functional_budget: u64,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct TransferSubspaceInput {
    field: FieldSpec,
    base_prime: u8,
    columns: Vec<u8>,
    target_coordinates: Vec<usize>,
    target_normalization: MatrixSpec,
    outer_functional_dual_basis: MatrixSpec,
    target_block: usize,
    #[serde(default = "default_candidate_budget")]
    ordinary_candidate_budget: u64,
    #[serde(default = "default_candidate_budget")]
    target_candidate_budget: u64,
    #[serde(default = "default_candidate_budget")]
    outer_functional_budget: u64,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct TowerLevelSpec {
    outer_blocks: Vec<MatrixSpec>,
    target_block: usize,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct TransferTowerInput {
    field: FieldSpec,
    base_prime: u8,
    columns: Vec<u8>,
    target_coordinates: Vec<usize>,
    target_normalization: MatrixSpec,
    levels: Vec<TowerLevelSpec>,
    final_label: MatrixSpec,
    #[serde(default = "default_candidate_budget")]
    ordinary_candidate_budget: u64,
    #[serde(default = "default_candidate_budget")]
    target_candidate_budget: u64,
    #[serde(default = "default_witness_node_budget")]
    witness_node_budget: u64,
}

#[derive(Debug, Deserialize)]
#[serde(tag = "kind", rename_all = "kebab-case", deny_unknown_fields)]
enum ApplicationInput {
    CephXor {
        coordinate_count: usize,
        layers: Vec<CephLayerSpec>,
        target: usize,
        unavailable: Vec<usize>,
        #[serde(default = "default_candidate_budget")]
        budget: u64,
    },
    AzureLrc {
        capacities: Vec<u32>,
        demand_count: usize,
    },
    RepairDag {
        capacities: Vec<u16>,
        tasks: Vec<RepairTaskSpec>,
        #[serde(default = "default_candidate_budget")]
        budget: u64,
    },
    QcLdpc {
        check_groups: usize,
        variable_groups: usize,
        lift: usize,
        shifts: Vec<Option<u16>>,
        objective: QcObjective,
        size: usize,
        #[serde(default)]
        maximum_odd_checks: usize,
        #[serde(default = "default_candidate_budget")]
        budget: u64,
    },
    VectorRepair {
        field: FieldSpec,
        generator: MatrixSpec,
        coordinate_nodes: Vec<u16>,
        target: MatrixSpec,
        #[serde(default = "default_candidate_budget_usize")]
        state_budget: usize,
    },
    GpuCheckpoint {
        data_shards: usize,
        shard_nodes: Vec<u16>,
        node_racks: Vec<u16>,
        failed_shards: Vec<usize>,
        replacement_nodes: Vec<u16>,
        capacities: Vec<u32>,
        #[serde(default = "default_candidate_budget")]
        option_budget: u64,
    },
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct CephLayerSpec {
    parity: u8,
    data: Vec<u8>,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct RepairTaskSpec {
    predecessors: u64,
    loads: Vec<u16>,
}

#[derive(Clone, Copy, Debug, Deserialize)]
#[serde(rename_all = "kebab-case")]
enum QcObjective {
    Stopping,
    Trapping,
}

fn default_candidate_budget_usize() -> usize {
    1 << 20
}

#[derive(Debug, Serialize)]
struct LabelCostOutput {
    label: u8,
    cost: u32,
    coefficients: Vec<u8>,
}

#[derive(Debug, Serialize)]
struct BlockWitnessOutput {
    block: usize,
    label: u8,
    cost: u32,
    coefficients: Vec<u8>,
}

#[derive(Debug, Serialize)]
struct ZeroSectorWitnessOutput {
    target_coefficients: Vec<u8>,
    escaping_block: usize,
    inner_dual_coefficients: Vec<u8>,
}

#[derive(Debug, Serialize)]
struct AssociatedPairOutput {
    k_p: MatrixSpec,
    d_p: MatrixSpec,
    quotient_dimension: usize,
}

#[derive(Debug, Serialize)]
struct TransferAnalysisOutput {
    name: String,
    associated_pair: AssociatedPairOutput,
    relative_weight_hierarchy: Vec<u32>,
    recovery_cost: u32,
    inner_dual_distance: u32,
    scalar_escape_cost: u32,
    ordinary_costs: Vec<LabelCostOutput>,
    target_normalized_costs: Vec<LabelCostOutput>,
    zero_functional_cost: u32,
    nonzero_functional_cost: Option<u32>,
    gamma: u32,
    maximum_confined_radius: Option<u32>,
    rank_one_controls_all_recoverable_ranks: bool,
    winning_sector: &'static str,
    outer_functional_coefficients: Option<MatrixSpec>,
    block_labels: Vec<u8>,
    block_witnesses: Vec<BlockWitnessOutput>,
    zero_sector_witness: ZeroSectorWitnessOutput,
    candidates_examined: u64,
    outer_functionals_examined: u64,
}

#[derive(Debug, Serialize)]
struct TransferOutput {
    field: &'static str,
    base_field: &'static str,
    comparison: TransferComparisonOutput,
    analyses: Vec<TransferAnalysisOutput>,
}

#[derive(Debug, Serialize)]
struct TransferComparisonOutput {
    all_recovery_costs_equal: bool,
    all_inner_dual_distances_equal: bool,
    all_scalar_escape_costs_equal: bool,
    gamma_values_differ: bool,
}

#[derive(Debug, Serialize)]
struct MatrixLabelCostOutput {
    label: MatrixSpec,
    cost: u32,
    coefficients: MatrixSpec,
}

#[derive(Debug, Serialize)]
struct MatrixBlockWitnessOutput {
    block: usize,
    label: MatrixSpec,
    cost: u32,
    coefficients: MatrixSpec,
}

#[derive(Debug, Serialize)]
struct TransferSubspaceOutput {
    field: &'static str,
    base_field: &'static str,
    demand_dimension: usize,
    target_union_cost: u32,
    inner_dual_distance: u32,
    ordinary_costs: Vec<MatrixLabelCostOutput>,
    target_normalized_costs: Vec<MatrixLabelCostOutput>,
    zero_functional_cost: u32,
    nonzero_functional_cost: Option<u32>,
    gamma: u32,
    maximum_confined_radius: Option<u32>,
    winning_sector: &'static str,
    outer_functional_coefficients: Option<MatrixSpec>,
    block_witnesses: Vec<MatrixBlockWitnessOutput>,
    zero_target_coefficients: MatrixSpec,
    zero_escape_inner_dual_coefficients: Vec<u8>,
    ordinary_candidates_examined: u64,
    target_candidates_examined: u64,
    outer_functionals_examined: u64,
}

#[derive(Debug, Serialize)]
struct TowerWitnessOutput {
    label: MatrixSpec,
    cost: u32,
    target_normalized: bool,
    coefficient_witness: Option<MatrixSpec>,
    children: Vec<TowerWitnessOutput>,
}

#[derive(Debug, Serialize)]
struct TransferTowerOutput {
    field: &'static str,
    base_field: &'static str,
    demand_dimension: usize,
    target_union_cost: u32,
    levels: usize,
    final_label: MatrixSpec,
    cost: u32,
    witness_nodes: u64,
    witness: TowerWitnessOutput,
    ordinary_candidates_examined: u64,
    target_candidates_examined: u64,
}

#[derive(Debug, Serialize)]
struct ComposeOutput {
    feasible: bool,
    cost: Option<u32>,
    local_labels: Vec<MatrixSpec>,
    compiled_labels: usize,
    transitions_examined: u64,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct ScheduleInput {
    capacities: Vec<u32>,
    families: Vec<Vec<Vec<u32>>>,
    #[serde(default)]
    positive_grading: Option<Vec<u32>>,
}

#[derive(Debug, Serialize)]
struct ScheduleChoiceOutput {
    demand: u32,
    loads: Vec<u32>,
}

#[derive(Debug, Serialize)]
struct ScheduleOutput {
    repaired_count: usize,
    complete: bool,
    assignment: Vec<ScheduleChoiceOutput>,
    unmatched_demands: Vec<u32>,
    total_loads: Vec<u64>,
    backend: &'static str,
    transitions_examined: u64,
    peak_pareto_states: u32,
}

fn read_json<T: for<'de> Deserialize<'de>>(path: &Path) -> Result<T> {
    let mut bytes = Vec::new();
    if path == Path::new("-") {
        io::stdin()
            .read_to_end(&mut bytes)
            .context("failed to read standard input")?;
    } else {
        bytes = std::fs::read(path)
            .with_context(|| format!("failed to read input file {}", path.display()))?;
    }
    serde_json::from_slice(&bytes).context("invalid JSON input")
}

fn write_json<T: Serialize>(value: &T) -> Result<()> {
    serde_json::to_writer_pretty(io::stdout().lock(), value)
        .context("failed to write JSON output")?;
    println!();
    Ok(())
}

fn compose_for_field<F: FiniteField>(input: ComposeInput, parallel: bool) -> Result<ComposeOutput> {
    let entries = input
        .inner
        .entries
        .into_iter()
        .map(|entry| Ok((entry.label.into_matrix_field::<F>()?, entry.cost)))
        .collect::<Result<Vec<_>>>()?;
    let inner = CostTable::from_entries_field::<F>(input.inner.rows, input.inner.cols, entries)
        .context("failed to compile inner cost table")?;
    let outer_blocks = input
        .outer_blocks
        .into_iter()
        .map(MatrixSpec::into_matrix_field::<F>)
        .collect::<Result<Vec<_>>>()?;
    let target = input.target.into_matrix_field::<F>()?;
    let compiled = if parallel {
        #[cfg(feature = "parallel")]
        {
            CompositionTable::compose_parallel_field::<F>(&outer_blocks, &inner)
        }
        #[cfg(not(feature = "parallel"))]
        {
            bail!("parallel execution requires building ergo-comp with --features parallel")
        }
    } else {
        CompositionTable::compose_field::<F>(&outer_blocks, &inner)
    }
    .context("failed to compose recovery costs")?;
    let answer = compiled
        .answer_field::<F>(&target)
        .context("failed to reconstruct composition witness")?;
    let (feasible, cost, local_labels) = match answer {
        Some(answer) => (
            true,
            Some(answer.cost),
            answer
                .local_labels
                .iter()
                .map(MatrixSpec::from_matrix)
                .collect(),
        ),
        None => (false, None, Vec::new()),
    };
    Ok(ComposeOutput {
        feasible,
        cost,
        local_labels,
        compiled_labels: compiled.len(),
        transitions_examined: compiled.transitions(),
    })
}

fn compose(input: ComposeInput, parallel: bool) -> Result<ComposeOutput> {
    match input.field_selection()? {
        FieldSelection::Prime(2) => compose_for_field::<Prime<2>>(input, parallel),
        FieldSelection::Prime(3) => compose_for_field::<Prime<3>>(input, parallel),
        FieldSelection::Prime(5) => compose_for_field::<Prime<5>>(input, parallel),
        FieldSelection::Prime(7) => compose_for_field::<Prime<7>>(input, parallel),
        FieldSelection::Prime(11) => compose_for_field::<Prime<11>>(input, parallel),
        FieldSelection::Prime(13) => compose_for_field::<Prime<13>>(input, parallel),
        FieldSelection::Gf4 => compose_for_field::<Gf4>(input, parallel),
        FieldSelection::Prime(prime) => {
            bail!("unsupported prime {prime}; supported primes are 2, 3, 5, 7, 11, and 13")
        }
    }
}

fn label_costs(entries: &[Option<CoefficientWitness>]) -> Vec<LabelCostOutput> {
    entries
        .iter()
        .enumerate()
        .filter_map(|(label, witness)| {
            witness.as_ref().map(|witness| LabelCostOutput {
                label: label as u8,
                cost: witness.cost,
                coefficients: witness.coefficients.to_vec(),
            })
        })
        .collect()
}

fn transfer(input: TransferInput) -> Result<TransferOutput> {
    if input.base_prime != 2 {
        bail!("the rank-one transfer front end currently requires base_prime 2");
    }
    match &input.field {
        FieldSpec::BinaryExtension { degree: 2, modulus } if modulus.as_slice() == [1, 1, 1] => {}
        _ => {
            bail!("the rank-one transfer front end currently requires GF(4) with modulus [1, 1, 1]")
        }
    }
    if input.inner_encoders.is_empty() {
        bail!("transfer input needs at least one inner encoder");
    }
    let functional_dual_basis = input
        .outer_functional_dual_basis
        .into_matrix_field::<Gf4>()?;
    let block_count = functional_dual_basis.cols();
    if block_count < 2 || input.target_block >= block_count {
        bail!("transfer needs at least two outer blocks and a valid target block");
    }
    let outer_functional_count = 4u64
        .checked_pow(
            u32::try_from(functional_dual_basis.rows())
                .context("outer functional-dual rank exceeds u32")?,
        )
        .context("outer functional enumeration count overflow")?;
    if outer_functional_count > input.outer_functional_budget {
        bail!(
            "outer functional enumeration needs {outer_functional_count} candidates but the budget is {}",
            input.outer_functional_budget
        );
    }

    let mut analyses = Vec::with_capacity(input.inner_encoders.len());
    for encoder in input.inner_encoders {
        let profile = compile_binary_rank_one::<Gf4>(
            &encoder.columns,
            encoder.target_coordinate,
            input.candidate_budget,
        )
        .with_context(|| format!("failed to compile inner encoder '{}'", encoder.name))?;
        let inner_dual = profile
            .inner_dual()
            .context("the current transfer front end requires a nontrivial inner dual")?;
        let (ordinary, target) = profile.cost_tables::<Gf4>()?;
        let answer = confinement_by_generators_field::<Gf4>(
            &functional_dual_basis,
            block_count,
            &ordinary,
            &target,
            input.target_block,
            inner_dual.cost,
        )?;
        let mut block_witnesses = Vec::new();
        if answer.sector == ConfinementSector::Nonzero {
            for (block, label) in answer.block_labels.iter().enumerate() {
                let label = label.as_slice()[0];
                let table = if block == input.target_block {
                    profile.target_normalized()
                } else {
                    profile.ordinary()
                };
                let witness = table[label as usize]
                    .as_ref()
                    .context("winning block label has no compiled coefficient witness")?;
                block_witnesses.push(BlockWitnessOutput {
                    block,
                    label,
                    cost: witness.cost,
                    coefficients: witness.coefficients.to_vec(),
                });
            }
        }
        let target_zero = profile.target_normalized()[0]
            .as_ref()
            .context("target zero label has no recovery witness")?;
        let escaping_block = (0..block_count)
            .find(|&block| block != input.target_block)
            .expect("block count was checked above");
        let scalar_escape_cost = profile
            .recovery_cost()
            .checked_add(inner_dual.cost)
            .context("scalar escape cost overflow")?;
        if answer.zero_cost != scalar_escape_cost {
            bail!("internal zero-sector cost mismatch");
        }
        analyses.push(TransferAnalysisOutput {
            name: encoder.name,
            associated_pair: AssociatedPairOutput {
                k_p: MatrixSpec::from_matrix(profile.k_p()),
                d_p: MatrixSpec::from_matrix(profile.d_p()),
                quotient_dimension: profile.quotient_dimension(),
            },
            relative_weight_hierarchy: vec![profile.recovery_cost()],
            recovery_cost: profile.recovery_cost(),
            inner_dual_distance: inner_dual.cost,
            scalar_escape_cost,
            ordinary_costs: label_costs(profile.ordinary()),
            target_normalized_costs: label_costs(profile.target_normalized()),
            zero_functional_cost: answer.zero_cost,
            nonzero_functional_cost: answer.nonzero_cost,
            gamma: answer.cost,
            maximum_confined_radius: answer.cost.checked_sub(1),
            rank_one_controls_all_recoverable_ranks: profile.quotient_dimension() == 1,
            winning_sector: match answer.sector {
                ConfinementSector::Zero => "zero",
                ConfinementSector::Nonzero => "nonzero",
            },
            outer_functional_coefficients: answer
                .functional_coefficients
                .as_ref()
                .map(MatrixSpec::from_matrix),
            block_labels: answer
                .block_labels
                .iter()
                .map(|label| label.as_slice()[0])
                .collect(),
            block_witnesses,
            zero_sector_witness: ZeroSectorWitnessOutput {
                target_coefficients: target_zero.coefficients.to_vec(),
                escaping_block,
                inner_dual_coefficients: inner_dual.coefficients.to_vec(),
            },
            candidates_examined: profile.candidates_examined(),
            outer_functionals_examined: answer.transitions,
        });
    }
    let first = &analyses[0];
    let comparison = TransferComparisonOutput {
        all_recovery_costs_equal: analyses
            .iter()
            .all(|analysis| analysis.recovery_cost == first.recovery_cost),
        all_inner_dual_distances_equal: analyses
            .iter()
            .all(|analysis| analysis.inner_dual_distance == first.inner_dual_distance),
        all_scalar_escape_costs_equal: analyses
            .iter()
            .all(|analysis| analysis.scalar_escape_cost == first.scalar_escape_cost),
        gamma_values_differ: analyses
            .iter()
            .any(|analysis| analysis.gamma != first.gamma),
    };
    Ok(TransferOutput {
        field: "GF(4) = GF(2)[a]/(a^2+a+1)",
        base_field: "GF(2)",
        comparison,
        analyses,
    })
}

fn matrix_label_costs(entries: &[MatrixCoefficientWitness]) -> Vec<MatrixLabelCostOutput> {
    entries
        .iter()
        .map(|entry| MatrixLabelCostOutput {
            label: MatrixSpec::from_matrix(&entry.label),
            cost: entry.cost,
            coefficients: MatrixSpec::from_matrix(&entry.coefficients),
        })
        .collect()
}

fn transfer_subspace(input: TransferSubspaceInput) -> Result<TransferSubspaceOutput> {
    if input.base_prime != 2 {
        bail!("the target-subspace front end currently requires base_prime 2");
    }
    match &input.field {
        FieldSpec::BinaryExtension { degree: 2, modulus } if modulus.as_slice() == [1, 1, 1] => {}
        _ => bail!("the target-subspace front end currently requires GF(4) with modulus [1, 1, 1]"),
    }
    let normalization = input.target_normalization.into_matrix_field::<Prime<2>>()?;
    let profile = compile_binary_target_subspace::<Gf4>(
        &input.columns,
        &input.target_coordinates,
        &normalization,
        input.ordinary_candidate_budget,
        input.target_candidate_budget,
    )?;
    let inner_dual = profile
        .inner_dual()
        .context("the current target-subspace front end requires a nontrivial inner dual")?;
    let functional_dual_basis = input
        .outer_functional_dual_basis
        .into_matrix_field::<Gf4>()?;
    let block_count = functional_dual_basis.cols();
    if block_count < 2 || input.target_block >= block_count {
        bail!("transfer needs at least two outer blocks and a valid target block");
    }
    let outer_exponent = functional_dual_basis
        .rows()
        .checked_mul(profile.demand_dimension())
        .context("outer functional enumeration exponent overflow")?;
    let outer_functional_count = 4u64
        .checked_pow(u32::try_from(outer_exponent).context("outer exponent exceeds u32")?)
        .context("outer functional enumeration count overflow")?;
    if outer_functional_count > input.outer_functional_budget {
        bail!(
            "outer functional enumeration needs {outer_functional_count} candidates but the budget is {}",
            input.outer_functional_budget
        );
    }
    let (ordinary, target) = profile.cost_tables::<Gf4>()?;
    let answer = confinement_by_generators_field::<Gf4>(
        &functional_dual_basis,
        block_count,
        &ordinary,
        &target,
        input.target_block,
        inner_dual.cost,
    )?;
    let mut block_witnesses = Vec::new();
    if answer.sector == ConfinementSector::Nonzero {
        for (block, label) in answer.block_labels.iter().enumerate() {
            let entries = if block == input.target_block {
                profile.target_normalized()
            } else {
                profile.ordinary()
            };
            let witness = entries
                .iter()
                .find(|entry| entry.label == *label)
                .context("winning block label has no coefficient witness")?;
            block_witnesses.push(MatrixBlockWitnessOutput {
                block,
                label: MatrixSpec::from_matrix(label),
                cost: witness.cost,
                coefficients: MatrixSpec::from_matrix(&witness.coefficients),
            });
        }
    }
    let target_zero = profile
        .target_normalized()
        .iter()
        .find(|entry| entry.label.as_slice().iter().all(|&value| value == 0))
        .context("zero target label has no coefficient witness")?;
    Ok(TransferSubspaceOutput {
        field: "GF(4) = GF(2)[a]/(a^2+a+1)",
        base_field: "GF(2)",
        demand_dimension: profile.demand_dimension(),
        target_union_cost: profile.target_union_cost(),
        inner_dual_distance: inner_dual.cost,
        ordinary_costs: matrix_label_costs(profile.ordinary()),
        target_normalized_costs: matrix_label_costs(profile.target_normalized()),
        zero_functional_cost: answer.zero_cost,
        nonzero_functional_cost: answer.nonzero_cost,
        gamma: answer.cost,
        maximum_confined_radius: answer.cost.checked_sub(1),
        winning_sector: match answer.sector {
            ConfinementSector::Zero => "zero",
            ConfinementSector::Nonzero => "nonzero",
        },
        outer_functional_coefficients: answer
            .functional_coefficients
            .as_ref()
            .map(MatrixSpec::from_matrix),
        block_witnesses,
        zero_target_coefficients: MatrixSpec::from_matrix(&target_zero.coefficients),
        zero_escape_inner_dual_coefficients: inner_dual.coefficients.to_vec(),
        ordinary_candidates_examined: profile.ordinary_candidates_examined(),
        target_candidates_examined: profile.target_candidates_examined(),
        outer_functionals_examined: answer.transitions,
    })
}

fn tower_witness_output(
    profile: &ergo_comp::BinaryTargetProfile,
    witness: &TowerWitness,
) -> Result<TowerWitnessOutput> {
    let coefficient_witness = if witness.children.is_empty() {
        let entries = if witness.target_normalized {
            profile.target_normalized()
        } else {
            profile.ordinary()
        };
        let entry = entries
            .iter()
            .find(|entry| entry.label == witness.label)
            .context("tower leaf label has no coefficient witness")?;
        if entry.cost != witness.cost {
            bail!("tower leaf cost does not match its coefficient witness");
        }
        Some(MatrixSpec::from_matrix(&entry.coefficients))
    } else {
        None
    };
    let children = witness
        .children
        .iter()
        .map(|child| tower_witness_output(profile, child))
        .collect::<Result<Vec<_>>>()?;
    Ok(TowerWitnessOutput {
        label: MatrixSpec::from_matrix(&witness.label),
        cost: witness.cost,
        target_normalized: witness.target_normalized,
        coefficient_witness,
        children,
    })
}

fn transfer_tower(input: TransferTowerInput, parallel: bool) -> Result<TransferTowerOutput> {
    if input.base_prime != 2 {
        bail!("the represented-tower front end currently requires base_prime 2");
    }
    match &input.field {
        FieldSpec::BinaryExtension { degree: 2, modulus } if modulus.as_slice() == [1, 1, 1] => {}
        _ => {
            bail!("the represented-tower front end currently requires GF(4) with modulus [1, 1, 1]")
        }
    }
    if input.levels.is_empty() {
        bail!("the represented tower needs at least one outer level");
    }
    let normalization = input.target_normalization.into_matrix_field::<Prime<2>>()?;
    let profile = compile_binary_target_subspace::<Gf4>(
        &input.columns,
        &input.target_coordinates,
        &normalization,
        input.ordinary_candidate_budget,
        input.target_candidate_budget,
    )?;
    let (ordinary, target) = profile.cost_tables::<Gf4>()?;
    let levels = input
        .levels
        .into_iter()
        .map(|level| {
            let outer_blocks = level
                .outer_blocks
                .into_iter()
                .map(MatrixSpec::into_matrix_field::<Gf4>)
                .collect::<Result<Vec<_>>>()?
                .into_boxed_slice();
            Ok(TowerLevel {
                outer_blocks,
                target_block: level.target_block,
            })
        })
        .collect::<Result<Vec<_>>>()?;
    let tower = if parallel {
        #[cfg(feature = "parallel")]
        {
            CompositionTower::compile_parallel_field::<Gf4>(&ordinary, &target, &levels)?
        }
        #[cfg(not(feature = "parallel"))]
        {
            bail!("parallel execution requires building ergo-comp with --features parallel")
        }
    } else {
        CompositionTower::compile_field::<Gf4>(&ordinary, &target, &levels)?
    };
    let final_label = input.final_label.into_matrix_field::<Gf4>()?;
    let answer = tower
        .answer_target_field::<Gf4>(&final_label, input.witness_node_budget)?
        .context("the requested final tower label is infeasible")?;
    let witness = tower_witness_output(&profile, &answer.witness)?;
    Ok(TransferTowerOutput {
        field: "GF(4) = GF(2)[a]/(a^2+a+1)",
        base_field: "GF(2)",
        demand_dimension: profile.demand_dimension(),
        target_union_cost: profile.target_union_cost(),
        levels: levels.len(),
        final_label: MatrixSpec::from_matrix(&final_label),
        cost: answer.cost,
        witness_nodes: answer.witness_nodes,
        witness,
        ordinary_candidates_examined: profile.ordinary_candidates_examined(),
        target_candidates_examined: profile.target_candidates_examined(),
    })
}

fn schedule(input: ScheduleInput, parallel: bool) -> Result<ScheduleOutput> {
    let problem = match input.positive_grading {
        Some(weights) => WeightedRepairProblem::from_families_with_positive_grading(
            &input.capacities,
            &input.families,
            &weights,
        ),
        None => WeightedRepairProblem::from_families(&input.capacities, &input.families),
    }
    .context("failed to compile repair scheduler")?;
    let backend = match problem.recommended_backend() {
        WeightedSchedulerBackend::SparsePareto => "sparse-pareto",
        WeightedSchedulerBackend::DenseLattice => "dense-lattice",
    };
    let answer = if parallel {
        #[cfg(feature = "parallel")]
        {
            problem.solve_adaptive_parallel()
        }
        #[cfg(not(feature = "parallel"))]
        {
            bail!("parallel execution requires building ergo-comp with --features parallel")
        }
    } else {
        problem.solve_adaptive()
    }
    .context("failed to solve repair scheduler")?;
    Ok(ScheduleOutput {
        repaired_count: answer.repaired_count(),
        complete: answer.complete(),
        assignment: answer
            .assignment
            .iter()
            .map(|choice| ScheduleChoiceOutput {
                demand: choice.demand,
                loads: choice.loads.to_vec(),
            })
            .collect(),
        unmatched_demands: answer.unmatched_demands.to_vec(),
        total_loads: answer.total_loads.to_vec(),
        backend,
        transitions_examined: answer.transitions_examined,
        peak_pareto_states: answer.peak_pareto_states,
    })
}

fn application_schedule_output(problem: WeightedRepairProblem) -> Result<Value> {
    let backend = match problem.recommended_backend() {
        WeightedSchedulerBackend::SparsePareto => "sparse-pareto",
        WeightedSchedulerBackend::DenseLattice => "dense-lattice",
    };
    let answer = problem
        .solve_adaptive()
        .context("failed to solve application scheduler")?;
    Ok(json!({
        "repaired_count": answer.repaired_count(),
        "complete": answer.complete(),
        "assignment": answer.assignment.iter().map(|choice| json!({
            "demand": choice.demand,
            "loads": choice.loads,
        })).collect::<Vec<_>>(),
        "unmatched_demands": answer.unmatched_demands,
        "total_loads": answer.total_loads,
        "backend": backend,
        "transitions_examined": answer.transitions_examined,
        "peak_pareto_states": answer.peak_pareto_states,
    }))
}

fn node_span_output<F: FiniteField>(
    generator: MatrixSpec,
    coordinate_nodes: Vec<u16>,
    target: MatrixSpec,
    state_budget: usize,
) -> Result<Value> {
    let generator = generator.into_matrix_field::<F>()?;
    let target = target.into_matrix_field::<F>()?;
    let answer =
        minimum_node_span_repair::<F>(&generator, &coordinate_nodes, &target, state_budget)?;
    Ok(match answer {
        Some(answer) => json!({
            "feasible": true,
            "node_cost": answer.node_cost,
            "nodes": answer.nodes,
            "generated_spans": answer.generated_spans,
            "transitions": answer.transitions,
        }),
        None => json!({"feasible": false}),
    })
}

fn application(input: ApplicationInput) -> Result<Value> {
    match input {
        ApplicationInput::CephXor {
            coordinate_count,
            layers,
            target,
            unavailable,
            budget,
        } => {
            let layers: Vec<_> = layers
                .into_iter()
                .map(|layer| CephXorLayer {
                    parity: layer.parity,
                    data: layer.data.into_boxed_slice(),
                })
                .collect();
            let answer =
                ceph_xor_repair_supports(coordinate_count, &layers, target, &unavailable, budget)?;
            Ok(json!({
                "application": "ceph-recursive-lrc",
                "supports": answer.supports,
                "closure_rounds": answer.closure_rounds,
                "combinations_examined": answer.combinations_examined,
            }))
        }
        ApplicationInput::AzureLrc {
            capacities,
            demand_count,
        } => {
            let capacities: [u32; 9] = capacities
                .try_into()
                .map_err(|_| anyhow::anyhow!("Azure LRC needs nine upgrade-domain capacities"))?;
            application_schedule_output(azure_lrc_12_2_2_upgrade_domains(
                &capacities,
                demand_count,
            )?)
        }
        ApplicationInput::RepairDag {
            capacities,
            tasks,
            budget,
        } => {
            let tasks: Vec<_> = tasks
                .into_iter()
                .map(|task| RepairTask {
                    predecessors: task.predecessors,
                    loads: task.loads.into_boxed_slice(),
                })
                .collect();
            let answer = schedule_repair_dag(&capacities, &tasks, budget)?;
            Ok(json!({
                "application": "full-node-repair-dag",
                "slots": answer.slots,
                "task_batches": answer.task_batches,
                "states_examined": answer.states_examined,
            }))
        }
        ApplicationInput::QcLdpc {
            check_groups,
            variable_groups,
            lift,
            shifts,
            objective,
            size,
            maximum_odd_checks,
            budget,
        } => {
            let code = QcLdpcCode::new(check_groups, variable_groups, lift, shifts)?;
            let answer = match objective {
                QcObjective::Stopping => code.find_stopping_set(size, budget)?,
                QcObjective::Trapping => {
                    code.find_trapping_set(size, maximum_odd_checks, budget)?
                }
            };
            Ok(match answer {
                Some(answer) => json!({
                    "application": "qc-ldpc",
                    "found": true,
                    "variables": answer.variables,
                    "odd_checks": answer.odd_checks,
                    "candidates_examined": answer.candidates_examined,
                    "cyclic_normalization_factor": answer.cyclic_normalization_factor,
                }),
                None => json!({"application": "qc-ldpc", "found": false}),
            })
        }
        ApplicationInput::VectorRepair {
            field,
            generator,
            coordinate_nodes,
            target,
            state_budget,
        } => match field {
            FieldSpec::Prime { order: 2 } => {
                node_span_output::<Prime<2>>(generator, coordinate_nodes, target, state_budget)
            }
            FieldSpec::Prime { order: 3 } => {
                node_span_output::<Prime<3>>(generator, coordinate_nodes, target, state_budget)
            }
            FieldSpec::Prime { order: 5 } => {
                node_span_output::<Prime<5>>(generator, coordinate_nodes, target, state_budget)
            }
            FieldSpec::Prime { order: 7 } => {
                node_span_output::<Prime<7>>(generator, coordinate_nodes, target, state_budget)
            }
            FieldSpec::Prime { order: 11 } => {
                node_span_output::<Prime<11>>(generator, coordinate_nodes, target, state_budget)
            }
            FieldSpec::Prime { order: 13 } => {
                node_span_output::<Prime<13>>(generator, coordinate_nodes, target, state_budget)
            }
            FieldSpec::BinaryExtension { degree: 2, modulus }
                if modulus.as_slice() == [1, 1, 1] =>
            {
                node_span_output::<Gf4>(generator, coordinate_nodes, target, state_budget)
            }
            unsupported => bail!("unsupported vector-repair field {unsupported:?}"),
        },
        ApplicationInput::GpuCheckpoint {
            data_shards,
            shard_nodes,
            node_racks,
            failed_shards,
            replacement_nodes,
            capacities,
            option_budget,
        } => application_schedule_output(gpu_checkpoint_mds_recovery(
            data_shards,
            &shard_nodes,
            &node_racks,
            &failed_shards,
            &replacement_nodes,
            &capacities,
            option_budget,
        )?),
    }
}

fn run_with_threads<T: Send>(
    parallel: bool,
    threads: Option<NonZeroUsize>,
    operation: impl FnOnce() -> Result<T> + Send,
) -> Result<T> {
    if !parallel {
        return operation();
    }
    #[cfg(feature = "parallel")]
    {
        let threads = threads.map_or_else(
            || std::thread::available_parallelism().map_or(1, NonZeroUsize::get),
            NonZeroUsize::get,
        );
        rayon::ThreadPoolBuilder::new()
            .num_threads(threads)
            .build()
            .context("failed to create parallel worker pool")?
            .install(operation)
    }
    #[cfg(not(feature = "parallel"))]
    {
        let _ = threads;
        bail!("parallel execution requires building ergo-comp with --features parallel")
    }
}

fn main() -> Result<()> {
    match Cli::parse().command {
        Command::Compose {
            input,
            parallel,
            threads,
        } => {
            let input = read_json(&input)?;
            write_json(&run_with_threads(parallel, threads, || {
                compose(input, parallel)
            })?)
        }
        Command::Transfer { input } => {
            let input = read_json(&input)?;
            write_json(&transfer(input)?)
        }
        Command::TransferSubspace { input } => {
            let input = read_json(&input)?;
            write_json(&transfer_subspace(input)?)
        }
        Command::TransferTower {
            input,
            parallel,
            threads,
        } => {
            let input = read_json(&input)?;
            write_json(&run_with_threads(parallel, threads, || {
                transfer_tower(input, parallel)
            })?)
        }
        Command::Schedule {
            input,
            parallel,
            threads,
        } => {
            let input = read_json(&input)?;
            write_json(&run_with_threads(parallel, threads, || {
                schedule(input, parallel)
            })?)
        }
        Command::Application { input } => {
            let input = read_json(&input)?;
            write_json(&application(input)?)
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn matrix(rows: usize, cols: usize, data: &[u8]) -> MatrixSpec {
        MatrixSpec {
            rows,
            cols,
            data: data.to_vec(),
        }
    }

    #[test]
    fn composition_returns_cost_and_local_witness() {
        let output = compose(
            ComposeInput {
                prime: Some(3),
                field: None,
                inner: CostTableSpec {
                    rows: 1,
                    cols: 1,
                    entries: vec![
                        CostEntrySpec {
                            label: matrix(1, 1, &[0]),
                            cost: 0,
                        },
                        CostEntrySpec {
                            label: matrix(1, 1, &[1]),
                            cost: 2,
                        },
                    ],
                },
                outer_blocks: vec![matrix(1, 1, &[1])],
                target: matrix(1, 1, &[1]),
            },
            false,
        )
        .unwrap();
        assert!(output.feasible);
        assert_eq!(output.cost, Some(2));
        assert_eq!(output.local_labels.len(), 1);
        assert_eq!(output.local_labels[0].data, [1]);
    }

    #[test]
    fn gf4_composition_dispatches_from_declared_polynomial_basis() {
        let output = compose(
            ComposeInput {
                prime: None,
                field: Some(FieldSpec::BinaryExtension {
                    degree: 2,
                    modulus: vec![1, 1, 1],
                }),
                inner: CostTableSpec {
                    rows: 1,
                    cols: 1,
                    entries: vec![
                        CostEntrySpec {
                            label: matrix(1, 1, &[0]),
                            cost: 0,
                        },
                        CostEntrySpec {
                            label: matrix(1, 1, &[1]),
                            cost: 1,
                        },
                        CostEntrySpec {
                            label: matrix(1, 1, &[2]),
                            cost: 2,
                        },
                        CostEntrySpec {
                            label: matrix(1, 1, &[3]),
                            cost: 3,
                        },
                    ],
                },
                outer_blocks: vec![matrix(1, 1, &[2]), matrix(1, 1, &[1])],
                target: matrix(1, 1, &[3]),
            },
            false,
        )
        .unwrap();
        assert_eq!(output.cost, Some(2));
        assert_eq!(output.local_labels[0].data, [1]);
        assert_eq!(output.local_labels[1].data, [1]);
    }

    #[test]
    fn gf4_example_schema_parses_and_replays() {
        let input: ComposeInput = serde_json::from_str(include_str!(concat!(
            env!("CARGO_MANIFEST_DIR"),
            "/examples/data/compose-gf4.json"
        )))
        .unwrap();
        let output = compose(input, false).unwrap();
        assert_eq!(output.cost, Some(2));
        assert_eq!(output.compiled_labels, 4);
    }

    #[test]
    fn scheduler_returns_complete_assignment_and_loads() {
        let output = schedule(
            ScheduleInput {
                capacities: vec![1, 1],
                families: vec![vec![vec![1, 0], vec![0, 1]], vec![vec![1, 0], vec![0, 1]]],
                positive_grading: Some(vec![1, 1]),
            },
            false,
        )
        .unwrap();
        assert!(output.complete);
        assert_eq!(output.repaired_count, 2);
        assert_eq!(output.total_loads, [1, 1]);
    }

    #[test]
    fn transfer_reproduces_the_paper_gf4_separation() {
        let output = transfer(TransferInput {
            field: FieldSpec::BinaryExtension {
                degree: 2,
                modulus: vec![1, 1, 1],
            },
            base_prime: 2,
            inner_encoders: vec![
                EncoderSpec {
                    name: "I1".to_owned(),
                    columns: vec![1, 1, 2],
                    target_coordinate: 0,
                },
                EncoderSpec {
                    name: "I2".to_owned(),
                    columns: vec![1, 1, 3],
                    target_coordinate: 0,
                },
            ],
            outer_functional_dual_basis: matrix(1, 2, &[1, 2]),
            target_block: 0,
            candidate_budget: 8,
            outer_functional_budget: 4,
        })
        .unwrap();
        assert_eq!(output.analyses.len(), 2);
        assert_eq!(output.analyses[0].scalar_escape_cost, 3);
        assert_eq!(output.analyses[1].scalar_escape_cost, 3);
        assert_eq!(output.analyses[0].nonzero_functional_cost, Some(1));
        assert_eq!(output.analyses[1].nonzero_functional_cost, Some(2));
        assert_eq!(output.analyses[0].gamma, 1);
        assert_eq!(output.analyses[1].gamma, 2);
        assert_eq!(output.analyses[0].block_labels, [1, 2]);
        assert_eq!(output.analyses[1].block_labels, [1, 2]);
        assert!(output.comparison.all_recovery_costs_equal);
        assert!(output.comparison.all_inner_dual_distances_equal);
        assert!(output.comparison.all_scalar_escape_costs_equal);
        assert!(output.comparison.gamma_values_differ);
    }
}
