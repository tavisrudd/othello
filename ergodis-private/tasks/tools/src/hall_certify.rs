use std::fs::File;
use std::io::{BufReader, BufWriter};
use std::path::PathBuf;

use anyhow::Context;
use clap::Args as ClapArgs;
use ergodis_private::hall_core::{HallOutcome, HallWorkspace};
use serde::{Deserialize, Serialize};

#[derive(ClapArgs)]
pub struct Arguments {
    #[arg(long)]
    input: PathBuf,
    #[arg(long)]
    output: PathBuf,
}

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct GraphInput {
    schema: String,
    left_count: usize,
    right_count: usize,
    offsets: Vec<u32>,
    neighbors: Vec<u32>,
}

#[derive(Serialize)]
#[serde(tag = "outcome", rename_all = "snake_case")]
enum Certificate {
    Saturated {
        matching: Vec<u32>,
    },
    Deficient {
        left: Vec<u32>,
        neighborhood: Vec<u32>,
    },
}

#[derive(Serialize)]
struct GraphOutput {
    schema: &'static str,
    certificate: Certificate,
}

fn solve(input: &GraphInput) -> anyhow::Result<GraphOutput> {
    anyhow::ensure!(
        input.schema == "ergodis-hall-graph/v1",
        "unsupported graph schema"
    );
    let mut workspace = HallWorkspace::new(input.left_count, input.right_count);
    let outcome = workspace.solve(
        input.left_count,
        input.right_count,
        &input.offsets,
        &input.neighbors,
    )?;
    let certificate = match outcome {
        HallOutcome::Saturated => Certificate::Saturated {
            matching: workspace.matching(input.left_count).to_vec(),
        },
        HallOutcome::Deficient { .. } => Certificate::Deficient {
            left: workspace.deficient_left().to_vec(),
            neighborhood: workspace.deficient_right().to_vec(),
        },
    };
    Ok(GraphOutput {
        schema: "ergodis-hall-certificate/v1",
        certificate,
    })
}

pub fn run(arguments: Arguments) -> anyhow::Result<()> {
    let input: GraphInput = serde_json::from_reader(BufReader::new(
        File::open(&arguments.input).context("open Hall graph")?,
    ))
    .context("parse Hall graph")?;
    let output = File::options()
        .write(true)
        .create_new(true)
        .open(&arguments.output)
        .context("create Hall certificate")?;
    serde_json::to_writer_pretty(BufWriter::new(output), &solve(&input)?)
        .context("write Hall certificate")?;
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::{solve, Certificate, GraphInput};

    #[test]
    fn serializable_certificate_matches_core() {
        let output = solve(&GraphInput {
            schema: "ergodis-hall-graph/v1".to_owned(),
            left_count: 3,
            right_count: 2,
            offsets: vec![0, 1, 2, 3],
            neighbors: vec![0, 0, 1],
        })
        .unwrap();
        match output.certificate {
            Certificate::Deficient { left, neighborhood } => {
                assert_eq!(left, vec![0, 1]);
                assert_eq!(neighborhood, vec![0]);
            }
            Certificate::Saturated { .. } => panic!("expected Hall deficiency"),
        }
    }
}
