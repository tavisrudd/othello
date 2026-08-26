use std::{fs, path::PathBuf, process::ExitCode};

use clap::{Parser, Subcommand};
use serde::{Deserialize, Serialize};
use sparse_shadow_core::{
    CanonicalArtifact, CanonicalCertificate, EquivalenceCertificate, InputArtifact,
    PaperIiReconstructionArtifact, PaperIiiReconstructionArtifact, PaperIvReconstructionArtifact,
    PaperVReconstructionArtifact, ProfileInput, ReconstructionArtifact, ShadowError, canonicalize,
    compare, reconstruct, reconstruct_paper_ii, reconstruct_paper_iii, reconstruct_paper_iv,
    reconstruct_paper_v, validate, verify_canonical_artifact, verify_certificate,
    verify_equivalence, verify_paper_ii_reconstruction, verify_paper_iii_reconstruction,
    verify_paper_iv_reconstruction, verify_paper_v_reconstruction, verify_reconstruction,
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
    VerifyEquivalenceCertificate {
        left: PathBuf,
        right: PathBuf,
        certificate: PathBuf,
    },
    VerifyReconstructionCertificate {
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

#[derive(Debug, Deserialize)]
#[serde(untagged)]
enum CanonicalProof {
    Artifact(Box<CanonicalArtifact>),
    Certificate(CanonicalCertificate),
}

#[derive(Debug, Deserialize)]
#[serde(untagged)]
enum ReconstructionProof {
    PaperIv(Box<PaperIvReconstructionArtifact>),
    PaperV(Box<PaperVReconstructionArtifact>),
    PaperIii(Box<PaperIiiReconstructionArtifact>),
    PaperIi(Box<PaperIiReconstructionArtifact>),
    PaperI(Box<ReconstructionArtifact>),
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
            print_json(&compare(&read_input(&left)?, &read_input(&right)?)?)?;
        }
        Command::Reconstruct { input } => {
            let input = read_input(&input)?;
            match &input.profile {
                ProfileInput::PaperIiTrade(_) => {
                    print_json(&reconstruct_paper_ii(&input)?)?;
                }
                ProfileInput::PaperIiiFourShadow(_) => {
                    print_json(&reconstruct_paper_iii(&input)?)?;
                }
                ProfileInput::PaperIvMinimumWords(_) => {
                    print_json(&reconstruct_paper_iv(&input)?)?;
                }
                ProfileInput::PaperVChordalConference(_) => {
                    print_json(&reconstruct_paper_v(&input)?)?;
                }
                ProfileInput::PaperIOrientation(_) => print_json(&reconstruct(&input)?)?,
            }
        }
        Command::VerifyCertificate { input, certificate } => {
            let input = read_input(&input)?;
            match read_json::<CanonicalProof>(&certificate)? {
                CanonicalProof::Artifact(artifact) => {
                    print_json(&verify_canonical_artifact(&input, &artifact)?)?;
                }
                CanonicalProof::Certificate(certificate) => {
                    print_json(&verify_certificate(&input, &certificate)?)?;
                }
            }
        }
        Command::VerifyEquivalenceCertificate {
            left,
            right,
            certificate,
        } => {
            let certificate = read_json::<EquivalenceCertificate>(&certificate)?;
            print_json(&verify_equivalence(
                &read_input(&left)?,
                &read_input(&right)?,
                &certificate,
            )?)?;
        }
        Command::VerifyReconstructionCertificate { input, certificate } => {
            let input = read_input(&input)?;
            match read_json::<ReconstructionProof>(&certificate)? {
                ReconstructionProof::PaperIv(certificate) => {
                    print_json(&verify_paper_iv_reconstruction(&input, &certificate)?)?;
                }
                ReconstructionProof::PaperIi(certificate) => {
                    print_json(&verify_paper_ii_reconstruction(&input, &certificate)?)?;
                }
                ReconstructionProof::PaperIii(certificate) => {
                    print_json(&verify_paper_iii_reconstruction(&input, &certificate)?)?;
                }
                ReconstructionProof::PaperV(certificate) => {
                    print_json(&verify_paper_v_reconstruction(&input, &certificate)?)?;
                }
                ReconstructionProof::PaperI(certificate) => {
                    print_json(&verify_reconstruction(&input, &certificate)?)?;
                }
            }
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
