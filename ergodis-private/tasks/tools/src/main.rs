//! Lane-neutral private operator tools.
//!
//! Tier-2 task crate: one binary, one subcommand per tool.  Each module owns a
//! `clap::Args` struct and a `run` entry point; this file contains nothing but
//! the command tree and its dispatch.

use anyhow::Result;
use clap::{Parser, Subcommand};

mod alignment_controlled;
mod hall_certify;
mod projective_grid_scout;
mod q16_quadratic;
mod q19_marked_polar;
mod q25_pair_repair;

#[derive(Parser)]
#[command(about = "Private Ergodis operator tools")]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    /// Unpublished parallel projective grid-game scout.
    ProjectiveGridScout(projective_grid_scout::Cli),
    /// Opt-in alignment-attachment search with campaign safe points.
    AlignmentControlled(Box<alignment_controlled::Cli>),
    /// Serialize a Hall matching or Hall-deficiency certificate.
    HallCertify(hall_certify::Arguments),
    /// Q25 pair-repair census, certificates, and stabilizer synthesis.
    Q25PairRepair(q25_pair_repair::Arguments),
    /// Q16 quadratic obstruction census and theorem synthesis.
    Q16Quadratic(q16_quadratic::Arguments),
    /// Q19 marked-polar class census.
    Q19MarkedPolar,
}

fn main() -> Result<()> {
    match Cli::parse().command {
        Command::ProjectiveGridScout(args) => projective_grid_scout::run(args),
        Command::AlignmentControlled(args) => alignment_controlled::run(*args),
        Command::HallCertify(args) => hall_certify::run(args),
        Command::Q25PairRepair(args) => q25_pair_repair::run(args),
        Command::Q16Quadratic(args) => q16_quadratic::run(args),
        Command::Q19MarkedPolar => q19_marked_polar::run(),
    }
}
