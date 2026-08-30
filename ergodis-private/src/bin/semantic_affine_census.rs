use std::collections::HashSet;
use std::fs::OpenOptions;
use std::io::Write;
use std::path::PathBuf;

use clap::Parser;
use ergodis_private::semantic_plan::{CanonicalizationGate, LabelContract};
use ergodis_private::semantic_sets::{for_each_k_subset, MaxOverlapProfiler};
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

#[inline]
fn add(left: u8, right: u8) -> u8 {
    let mut result = 0_u8;
    let mut place = 1_u8;
    let mut a = left;
    let mut b = right;
    for _ in 0..3 {
        result += ((a % 3 + b % 3) % 3) * place;
        a /= 3;
        b /= 3;
        place *= 3;
    }
    result
}

#[inline]
fn scale(value: u8, scalar: u8) -> u8 {
    match scalar {
        0 => 0,
        1 => value,
        2 => add(value, value),
        _ => unreachable!(),
    }
}

fn affine_subspaces(rank: usize) -> Vec<u64> {
    let mut linear = Vec::new();
    if rank == 1 {
        for a in 1..27_u8 {
            linear.push((1_u64 << 0) | (1_u64 << a) | (1_u64 << scale(a, 2)));
        }
    } else {
        for a in 1..27_u8 {
            for b in (a + 1)..27_u8 {
                if b == scale(a, 2) {
                    continue;
                }
                let mut mask = 0_u64;
                for i in 0..3_u8 {
                    for j in 0..3_u8 {
                        mask |= 1_u64 << add(scale(a, i), scale(b, j));
                    }
                }
                linear.push(mask);
            }
        }
    }
    linear.sort_unstable();
    linear.dedup();
    let mut affine = Vec::with_capacity(linear.len() * 27);
    for mask in linear {
        for translation in 0..27_u8 {
            let mut translated = 0_u64;
            let mut points = mask;
            while points != 0 {
                let point = points.trailing_zeros() as u8;
                translated |= 1_u64 << add(point, translation);
                points &= points - 1;
            }
            affine.push(translated);
        }
    }
    affine.sort_unstable();
    affine.dedup();
    affine
}

fn determinant(matrix: &[u8; 9]) -> u8 {
    let positive = matrix[0] * matrix[4] * matrix[8]
        + matrix[1] * matrix[5] * matrix[6]
        + matrix[2] * matrix[3] * matrix[7];
    let negative = matrix[2] * matrix[4] * matrix[6]
        + matrix[1] * matrix[3] * matrix[8]
        + matrix[0] * matrix[5] * matrix[7];
    (positive + 3 - negative % 3) % 3
}

fn decode_matrix(mut code: usize) -> [u8; 9] {
    let mut matrix = [0_u8; 9];
    for entry in &mut matrix {
        *entry = (code % 3) as u8;
        code /= 3;
    }
    matrix
}

fn transform_point(point: u8, matrix: &[u8; 9], translation: u8) -> u8 {
    let vector = [point % 3, (point / 3) % 3, (point / 9) % 3];
    let shift = [translation % 3, (translation / 3) % 3, (translation / 9) % 3];
    let mut result = 0_u8;
    let mut place = 1_u8;
    for row in 0..3 {
        let coordinate = (shift[row]
            + matrix[3 * row] * vector[0]
            + matrix[3 * row + 1] * vector[1]
            + matrix[3 * row + 2] * vector[2])
            % 3;
        result += coordinate * place;
        place *= 3;
    }
    result
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
    let mut profiler = MaxOverlapProfiler::new(planes, 9);
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
    let planes = affine_subspaces(2);
    let lines = affine_subspaces(1);
    assert_eq!(planes.len(), 39);
    assert_eq!(lines.len(), 117);

    let mut profiler = MaxOverlapProfiler::new(planes.clone(), 9);
    let mut ambient_subsets = 0_u64;
    let mut minimum = 9_u32;
    let mut minimum_count = 0_u64;
    let mut minimum_all_caps = true;
    let mut representative = 0_u64;
    for_each_k_subset(27, 9, |mask| {
        ambient_subsets += 1;
        let overlap = profiler.observe(mask, 1);
        if overlap < minimum {
            minimum = overlap;
            minimum_count = 0;
            minimum_all_caps = true;
            representative = mask;
        }
        if overlap == minimum {
            minimum_count += 1;
            minimum_all_caps &= lines.iter().all(|line| (mask & line).count_ones() <= 2);
        }
    });

    let mut orbit = HashSet::with_capacity(4096);
    let mut general_linear_order = 0_usize;
    for code in 0..3_usize.pow(9) {
        let matrix = decode_matrix(code);
        if determinant(&matrix) == 0 {
            continue;
        }
        general_linear_order += 1;
        for translation in 0..27_u8 {
            let mut transformed = 0_u64;
            let mut points = representative;
            while points != 0 {
                let point = points.trailing_zeros() as u8;
                transformed |= 1_u64 << transform_point(point, &matrix, translation);
                points &= points - 1;
            }
            orbit.insert(transformed);
        }
    }
    let affine_group_order = general_linear_order * 27;
    let canonicalization_gate = CanonicalizationGate {
        label_contract: LabelContract::Diagnostic,
        action_verified: true,
    };
    let labelled = args
        .labelled_tsv
        .as_ref()
        .map(|path| profile_labelled(path, planes.clone()))
        .transpose()?;
    let labelled_in_minimum_stratum = labelled
        .as_ref()
        .map(|(_, histogram)| histogram[minimum as usize]);
    let result = ResultEnvelope {
        schema: "ergodis.semantic-affine-census.v1",
        universe: "AG(3,3)",
        subset_size: 9,
        affine_planes: planes.len(),
        affine_lines: lines.len(),
        ambient_subsets,
        maximum_plane_overlap_histogram: profiler.histogram().to_vec(),
        minimum_maximum_plane_overlap: minimum as usize,
        minimum_stratum_size: minimum_count,
        minimum_stratum_all_caps: minimum_all_caps,
        affine_group_order,
        minimum_stratum_orbit_size: orbit.len(),
        stabilizer_order: affine_group_order / orbit.len(),
        single_affine_orbit: orbit.len() as u64 == minimum_count,
        canonicalization_label_contract: "diagnostic",
        canonicalization_proof_eligible: canonicalization_gate.proof_eligible(),
        representative: (0..27_u8)
            .filter(|point| representative & (1_u64 << point) != 0)
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
