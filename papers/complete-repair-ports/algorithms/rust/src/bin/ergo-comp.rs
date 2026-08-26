use anyhow::{bail, Context, Result};
use clap::{Parser, Subcommand};
use ergo_comp::{
    CompositionTable, CostTable, Matrix, WeightedRepairProblem, WeightedSchedulerBackend,
};
use serde::{Deserialize, Serialize};
use std::io::{self, Read};
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
    },
    /// Maximize simultaneous repairs under resource capacities.
    Schedule {
        /// JSON input file, or '-' for standard input.
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
    fn into_matrix<const P: u8>(self) -> Result<Matrix> {
        Matrix::new::<P>(self.rows, self.cols, self.data).context("invalid reduced matrix in input")
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
    prime: u8,
    inner: CostTableSpec,
    outer_blocks: Vec<MatrixSpec>,
    target: MatrixSpec,
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

fn compose_for<const P: u8>(input: ComposeInput) -> Result<ComposeOutput> {
    let entries = input
        .inner
        .entries
        .into_iter()
        .map(|entry| Ok((entry.label.into_matrix::<P>()?, entry.cost)))
        .collect::<Result<Vec<_>>>()?;
    let inner = CostTable::from_entries::<P>(input.inner.rows, input.inner.cols, entries)
        .context("failed to compile inner cost table")?;
    let outer_blocks = input
        .outer_blocks
        .into_iter()
        .map(MatrixSpec::into_matrix::<P>)
        .collect::<Result<Vec<_>>>()?;
    let target = input.target.into_matrix::<P>()?;
    let compiled = CompositionTable::compose::<P>(&outer_blocks, &inner)
        .context("failed to compose recovery costs")?;
    let answer = compiled
        .answer::<P>(&target)
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

fn compose(input: ComposeInput) -> Result<ComposeOutput> {
    match input.prime {
        2 => compose_for::<2>(input),
        3 => compose_for::<3>(input),
        5 => compose_for::<5>(input),
        7 => compose_for::<7>(input),
        11 => compose_for::<11>(input),
        13 => compose_for::<13>(input),
        prime => bail!("unsupported prime {prime}; supported primes are 2, 3, 5, 7, 11, and 13"),
    }
}

fn schedule(input: ScheduleInput) -> Result<ScheduleOutput> {
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
    let answer = problem
        .solve_adaptive()
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

fn main() -> Result<()> {
    match Cli::parse().command {
        Command::Compose { input } => write_json(&compose(read_json(&input)?)?),
        Command::Schedule { input } => write_json(&schedule(read_json(&input)?)?),
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
        let output = compose(ComposeInput {
            prime: 3,
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
        })
        .unwrap();
        assert!(output.feasible);
        assert_eq!(output.cost, Some(2));
        assert_eq!(output.local_labels.len(), 1);
        assert_eq!(output.local_labels[0].data, [1]);
    }

    #[test]
    fn scheduler_returns_complete_assignment_and_loads() {
        let output = schedule(ScheduleInput {
            capacities: vec![1, 1],
            families: vec![vec![vec![1, 0], vec![0, 1]], vec![vec![1, 0], vec![0, 1]]],
            positive_grading: Some(vec![1, 1]),
        })
        .unwrap();
        assert!(output.complete);
        assert_eq!(output.repaired_count, 2);
        assert_eq!(output.total_loads, [1, 1]);
    }
}
