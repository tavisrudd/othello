use std::fs::OpenOptions;
use std::hint::black_box;
use std::io::{self, Write};
use std::path::PathBuf;
use std::time::Instant;

use clap::{Parser, ValueEnum};
use ergodis_private::landed_rank_adapter::{
    q9_channel_system, q9_extra_channel_system, GENERATOR_NAMES, SOURCE_SHA256,
};
use ergodis_private::semantic_rank::{compile_semantic_rank_core, Gf9RankWorkspace};
use serde::Serialize;

#[derive(Parser)]
struct Args {
    #[arg(long)]
    output: Option<PathBuf>,

    /// Run only one allocation-free rank kernel for hardware-counter isolation.
    #[arg(long, value_enum)]
    replay_kernel: Option<ReplayKernel>,

    #[arg(long, default_value_t = 200_000)]
    kernel_rounds: usize,
}

#[derive(Clone, Copy, ValueEnum)]
enum ReplayKernel {
    Raw,
    Core,
}

#[derive(Serialize)]
struct Envelope {
    schema: &'static str,
    field: &'static str,
    source_sha256: &'static str,
    modality: &'static str,
    raw_equations: usize,
    variables: usize,
    rank: usize,
    hom_dimension: usize,
    independent_equations: usize,
    independent_equation_rows: Vec<u32>,
    equation_compression_ratio: f64,
    minimum_generator_core_size: usize,
    minimum_generator_cores: Vec<Vec<&'static str>>,
    generator_rank_loss_if_removed: Vec<(&'static str, usize)>,
    independent_equations_by_generator: Vec<(&'static str, usize)>,
    certificate_replayed: bool,
    compile_microseconds: u128,
    replay_rounds: usize,
    raw_rank_replay_ns: u128,
    core_rank_replay_ns: u128,
    rank_replay_speedup: f64,
    raw_workspace_payload_bytes: usize,
    core_workspace_payload_bytes: usize,
    workspace_payload_reduction: f64,
    landed_channel_controls: Vec<ChannelControl>,
    boundary: &'static str,
}

#[derive(Serialize)]
struct ChannelControl {
    digits: [usize; 2],
    variables: usize,
    rank: usize,
    hom_dimension: usize,
    minimum_generator_core_size: usize,
    minimum_generator_core_count: usize,
    certificate_replayed: bool,
}

const LANDED_CHANNELS: [([usize; 2], usize, usize, usize, usize); 5] = [
    ([0, 0], 10, 0, 2, 4),
    ([0, 2], 29, 1, 3, 3),
    ([1, 1], 40, 0, 3, 3),
    ([2, 0], 29, 1, 3, 3),
    ([2, 2], 90, 0, 3, 3),
];

fn run_replay_kernel(
    kernel: ReplayKernel,
    rounds: usize,
    system: &ergodis_private::semantic_rank::Gf9BlockSystem,
    certificate: &ergodis_private::semantic_rank::Gf9BlockSystem,
    rank: usize,
) {
    assert!(rounds > 0);
    let (selected, mask) = match kernel {
        ReplayKernel::Raw => (system, 0b1111),
        ReplayKernel::Core => (certificate, 1),
    };
    let mut workspace = Gf9RankWorkspace::new(selected.row_count(), selected.columns());
    let mut checksum = 0_usize;
    for _ in 0..rounds {
        checksum = checksum.wrapping_add(black_box(workspace.rank_blocks(selected, mask)));
    }
    assert_eq!(checksum, rank.wrapping_mul(rounds));
    black_box(checksum);
}

fn main() -> anyhow::Result<()> {
    let args = Args::parse();
    let system = q9_extra_channel_system();
    let started = Instant::now();
    let core = compile_semantic_rank_core(&system);
    let compile_microseconds = started.elapsed().as_micros();
    let certificate = system
        .select_rows(&core.independent_rows)
        .map_err(|message| anyhow::anyhow!(message))?;
    if let Some(kernel) = args.replay_kernel {
        run_replay_kernel(kernel, args.kernel_rounds, &system, &certificate, core.rank);
        return Ok(());
    }
    let replay_rounds = 2_000;
    let mut raw_workspace = Gf9RankWorkspace::new(system.row_count(), system.columns());
    let mut core_workspace = Gf9RankWorkspace::new(certificate.row_count(), certificate.columns());
    let raw_workspace_payload_bytes = raw_workspace.payload_bytes();
    let core_workspace_payload_bytes = core_workspace.payload_bytes();
    let raw_started = Instant::now();
    for _ in 0..replay_rounds {
        assert_eq!(
            black_box(raw_workspace.rank_blocks(&system, 0b1111)),
            core.rank
        );
    }
    let raw_rank_replay_ns = raw_started.elapsed().as_nanos() / replay_rounds as u128;
    let core_started = Instant::now();
    for _ in 0..replay_rounds {
        assert_eq!(
            black_box(core_workspace.rank_blocks(&certificate, 1)),
            core.rank
        );
    }
    let core_rank_replay_ns = core_started.elapsed().as_nanos() / replay_rounds as u128;
    let minimum_generator_cores = core
        .minimum_block_masks
        .iter()
        .map(|&mask| {
            GENERATOR_NAMES
                .iter()
                .enumerate()
                .filter_map(|(index, &name)| (mask & (1 << index) != 0).then_some(name))
                .collect()
        })
        .collect();
    let landed_channel_controls: Vec<_> = LANDED_CHANNELS
        .into_iter()
        .map(
            |([low, high], expected_rank, expected_hom, expected_size, expected_count)| {
                let control_system = q9_channel_system(low, high);
                let control_core = compile_semantic_rank_core(&control_system);
                let control = ChannelControl {
                    digits: [low, high],
                    variables: control_system.columns(),
                    rank: control_core.rank,
                    hom_dimension: control_system.columns() - control_core.rank,
                    minimum_generator_core_size: control_core.minimum_block_size,
                    minimum_generator_core_count: control_core.minimum_block_masks.len(),
                    certificate_replayed: control_core.verify(&control_system),
                };
                assert_eq!(control.rank, expected_rank);
                assert_eq!(control.hom_dimension, expected_hom);
                assert_eq!(control.minimum_generator_core_size, expected_size);
                assert_eq!(control.minimum_generator_core_count, expected_count);
                assert!(control.certificate_replayed);
                control
            },
        )
        .collect();
    let mut independent_by_generator = [0; 4];
    for &row in &core.independent_rows {
        independent_by_generator[row as usize / 30] += 1;
    }
    let envelope = Envelope {
        schema: "ergodis.semantic-rank-census.v1",
        field: "GF(9)",
        source_sha256: SOURCE_SHA256,
        modality: "finite-field intertwiner rank core",
        raw_equations: system.row_count(),
        variables: system.columns(),
        rank: core.rank,
        hom_dimension: system.columns() - core.rank,
        independent_equations: core.independent_rows.len(),
        independent_equation_rows: core.independent_rows.to_vec(),
        equation_compression_ratio: system.row_count() as f64 / core.independent_rows.len() as f64,
        minimum_generator_core_size: core.minimum_block_size,
        minimum_generator_cores,
        generator_rank_loss_if_removed: GENERATOR_NAMES
            .into_iter()
            .zip(core.rank_loss_if_removed.iter().copied())
            .collect(),
        independent_equations_by_generator: GENERATOR_NAMES
            .into_iter()
            .zip(independent_by_generator)
            .collect(),
        certificate_replayed: core.verify(&system),
        compile_microseconds,
        replay_rounds,
        raw_rank_replay_ns,
        core_rank_replay_ns,
        rank_replay_speedup: raw_rank_replay_ns as f64 / core_rank_replay_ns as f64,
        raw_workspace_payload_bytes,
        core_workspace_payload_bytes,
        workspace_payload_reduction: (system.row_count() * system.columns()) as f64
            / raw_workspace_payload_bytes as f64,
        landed_channel_controls,
        boundary: "bounded GF(9) finite certificate; not an all-field theorem",
    };
    assert_eq!(
        (envelope.variables, envelope.rank, envelope.hom_dimension),
        (30, 29, 1)
    );
    assert!(envelope.certificate_replayed);
    let encoded = serde_json::to_vec_pretty(&envelope)?;
    match args.output {
        Some(path) => {
            let mut file = OpenOptions::new().write(true).create_new(true).open(path)?;
            file.write_all(&encoded)?;
            file.write_all(b"\n")?;
        }
        None => {
            io::stdout().write_all(&encoded)?;
            io::stdout().write_all(b"\n")?;
        }
    }
    Ok(())
}
