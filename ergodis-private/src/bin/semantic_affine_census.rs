use std::fs::OpenOptions;
use std::io::Write;
use std::path::PathBuf;

use clap::Parser;
use ergodis_private::semantic_plan::affine_census::{affine_subspaces, run};
use ergodis_private::semantic_sets::TernaryPartitionMaxOverlapProfiler;
use serde::Serialize;

#[derive(Parser)]
struct Args {
    /// Optional TSV with `nine_set` and optional `orbit_size` columns.
    #[arg(long)]
    labelled_tsv: Option<PathBuf>,
    #[arg(long)]
    output: Option<PathBuf>,
}

#[derive(Serialize)]
struct ResultEnvelope {
    schema: &'static str,
    universe: &'static str,
    subset_size: usize,
    affine_planes: usize,
    affine_lines: usize,
    ambient_subsets: u64,
    maximum_plane_overlap_histogram: Vec<u64>,
    minimum_maximum_plane_overlap: usize,
    minimum_stratum_size: u64,
    minimum_stratum_all_caps: bool,
    affine_group_order: usize,
    minimum_stratum_orbit_size: usize,
    stabilizer_order: usize,
    single_affine_orbit: bool,
    canonicalization_label_contract: &'static str,
    canonicalization_proof_eligible: bool,
    representative: Vec<u8>,
    labelled_objects: Option<u64>,
    labelled_maximum_plane_overlap_histogram: Option<Vec<u64>>,
    labelled_in_minimum_stratum: Option<u64>,
}

fn profile_labelled(path: &PathBuf, planes: Vec<u64>) -> anyhow::Result<(u64, Vec<u64>)> {
    let input = std::fs::read_to_string(path)?;
    let mut lines = input.lines();
    let header: Vec<&str> = lines
        .next()
        .ok_or_else(|| anyhow::anyhow!("empty labelled TSV"))?
        .split('\t')
        .collect();
    let support_column = header
        .iter()
        .position(|name| *name == "nine_set")
        .ok_or_else(|| anyhow::anyhow!("labelled TSV lacks nine_set column"))?;
    let weight_column = header.iter().position(|name| *name == "orbit_size");
    let mut profiler = TernaryPartitionMaxOverlapProfiler::try_new(planes, (1_u64 << 27) - 1, 9)
        .map_err(anyhow::Error::msg)?;
    let mut total = 0_u64;
    for line in lines.filter(|line| !line.is_empty()) {
        let mut support_field = None;
        let mut weight = 1_u64;
        for (column, field) in line.split('\t').enumerate() {
            if column == support_column {
                support_field = Some(field);
            }
            if Some(column) == weight_column {
                weight = field.parse()?;
            }
        }
        let mut mask = 0_u64;
        for point in support_field
            .ok_or_else(|| anyhow::anyhow!("short labelled TSV row"))?
            .split(',')
        {
            mask |= 1_u64 << point.parse::<u8>()?;
        }
        if mask.count_ones() != 9 {
            anyhow::bail!("labelled TSV row is not a nine-set");
        }
        profiler.observe(mask, weight);
        total += weight;
    }
    Ok((total, profiler.histogram().to_vec()))
}

fn main() -> anyhow::Result<()> {
    let args = Args::parse();
    let census = run()?;
    let planes = affine_subspaces(2);
    let lines = affine_subspaces(1);
    assert_eq!(planes.len(), 39);
    assert_eq!(lines.len(), 117);

    let labelled = args
        .labelled_tsv
        .as_ref()
        .map(|path| profile_labelled(path, planes.clone()))
        .transpose()?;
    let labelled_in_minimum_stratum = labelled
        .as_ref()
        .map(|(_, histogram)| histogram[census.minimum as usize]);
    let result = ResultEnvelope {
        schema: "ergodis.semantic-affine-census.v1",
        universe: "AG(3,3)",
        subset_size: 9,
        affine_planes: planes.len(),
        affine_lines: lines.len(),
        ambient_subsets: census.ambient_subsets,
        maximum_plane_overlap_histogram: census.histogram.to_vec(),
        minimum_maximum_plane_overlap: census.minimum as usize,
        minimum_stratum_size: census.minimum_count,
        minimum_stratum_all_caps: census.minimum_all_caps,
        affine_group_order: census.affine_group_order,
        minimum_stratum_orbit_size: census.orbit_size,
        stabilizer_order: census.stabilizer_order(),
        single_affine_orbit: census.is_single_minimum_orbit(),
        canonicalization_label_contract: "diagnostic",
        canonicalization_proof_eligible: false,
        representative: (0..27_u8)
            .filter(|point| census.representative & (1_u64 << point) != 0)
            .collect(),
        labelled_objects: labelled.as_ref().map(|(total, _)| *total),
        labelled_maximum_plane_overlap_histogram: labelled
            .as_ref()
            .map(|(_, histogram)| histogram.clone()),
        labelled_in_minimum_stratum,
    };
    let rendered = serde_json::to_vec_pretty(&result)?;
    if let Some(path) = args.output {
        let mut output = OpenOptions::new().write(true).create_new(true).open(path)?;
        output.write_all(&rendered)?;
        output.write_all(b"\n")?;
    } else {
        std::io::stdout().write_all(&rendered)?;
        std::io::stdout().write_all(b"\n")?;
    }
    Ok(())
}
