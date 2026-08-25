use std::{fs, path::PathBuf, process::ExitCode};

use clap::{Parser, Subcommand};
use serde::Serialize;
use sparse_shadow_core::{
    CanonicalCertificate, InputArtifact, ShadowError, canonicalize, reconstruct, validate,
    verify_certificate,
};
use thiserror::Error;

#[derive(Debug, Parser)]
#[command(name = "sparse-shadow", version, about)]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Debug, Subcommand)]
enum Command {
    Validate {
        input: PathBuf,
    },
    Canonicalize {
        input: PathBuf,
    },
    Equivalent {
        left: PathBuf,
        right: PathBuf,
    },
    Reconstruct {
        input: PathBuf,
    },
    VerifyCertificate {
        input: PathBuf,
        certificate: PathBuf,
    },
}

#[derive(Debug, Error)]
enum CliError {
    #[error(transparent)]
    Core(#[from] ShadowError),
    #[error("failed to read `{path}`: {source}")]
    Read {
        path: PathBuf,
        source: std::io::Error,
    },
}

#[derive(Serialize)]
struct EquivalenceResult {
    equivalent: bool,
    left_canonical_id: String,
    right_canonical_id: String,
}

fn main() -> ExitCode {
    match run() {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("error: {error}");
            ExitCode::FAILURE
        }
    }
}

fn run() -> Result<(), CliError> {
    let cli = Cli::parse();
    match cli.command {
        Command::Validate { input } => print_json(&validate(&read_input(&input)?)?)?,
        Command::Canonicalize { input } => print_json(&canonicalize(&read_input(&input)?)?)?,
        Command::Equivalent { left, right } => {
            let left = canonicalize(&read_input(&left)?)?;
            let right = canonicalize(&read_input(&right)?)?;
            print_json(&EquivalenceResult {
                equivalent: left.canonical_id == right.canonical_id,
                left_canonical_id: left.canonical_id,
                right_canonical_id: right.canonical_id,
            })?;
        }
        Command::Reconstruct { input } => print_json(&reconstruct(&read_input(&input)?)?)?,
        Command::VerifyCertificate { input, certificate } => {
            let certificate = read_json::<CanonicalCertificate>(&certificate)?;
            print_json(&verify_certificate(&read_input(&input)?, &certificate)?)?;
        }
    }
    Ok(())
}

fn read_input(path: &PathBuf) -> Result<InputArtifact, CliError> {
    read_json(path)
}

fn read_json<T: serde::de::DeserializeOwned>(path: &PathBuf) -> Result<T, CliError> {
    let bytes = fs::read(path).map_err(|source| CliError::Read {
        path: path.clone(),
        source,
    })?;
    Ok(serde_json::from_slice(&bytes).map_err(ShadowError::from)?)
}

fn print_json(value: &impl Serialize) -> Result<(), CliError> {
    println!(
        "{}",
        serde_json::to_string_pretty(value).map_err(ShadowError::from)?
    );
    Ok(())
}
