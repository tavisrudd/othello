//! `gem-hunt` — the gem-mining lane's single task driver.
//!
//! Each subcommand is one of the C1018/C1020/C1025/C1028/C1029 exploration
//! binaries that previously lived as its own `ergodis-private/src/bin` file.
//! Flag names, defaults, and output are unchanged, so every committed replay
//! command and certificate digest survives the move; only the program name and
//! the subcommand path in front of the flags are new.
//!
//! New work in this lane adds a subcommand here.  Reusable machinery goes to
//! `ergodis_private` (`arith`, `gf2_linalg`, `css_codes`, `prs`), never into a
//! second copy inside another subcommand module.

// The moved drivers keep the fixed-array, indexed-loop shapes of the originals:
// these preserve bounded workspaces and make exact replay state visible.  The
// allowances below match `ergodis_private`'s own crate-level list.
// Every lint below fires on code carried over unchanged from the binaries this
// crate absorbs.  Silencing rather than rewriting keeps the move a pure move:
// certificate bytes and search order must not shift under a lint fix.
#![allow(
    clippy::iter_nth,
    clippy::manual_div_ceil,
    clippy::manual_is_multiple_of,
    clippy::manual_range_contains,
    clippy::manual_let_else,
    clippy::needless_range_loop,
    clippy::needless_question_mark,
    clippy::option_map_or_none,
    clippy::manual_is_variant_and,
    clippy::ptr_arg,
    clippy::question_mark,
    clippy::too_many_arguments,
    clippy::type_complexity,
    clippy::unnecessary_map_or,
    clippy::vec_init_then_push,
    dead_code
)]

#[cfg(feature = "chain-ring")]
mod chain_ring;
mod exterior_sets;
mod level_census;
mod parametric_cert;
mod plane12;
mod plane12_hyperoval;
mod prs_census;
mod prs_deephole;
mod prs_stratum;
mod transversal_css;

use anyhow::Result;
use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(
    name = "gem-hunt",
    about = "gem-mining lane exploration and certificate drivers"
)]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    /// Projective Reed–Solomon deep holes and covering radius.
    #[command(subcommand)]
    Prs(PrsCommand),
    /// Qubit CSS transversal-gate structure.
    #[command(subcommand)]
    Css(CssCommand),
    /// Restricted eliminations for a projective plane of order 12.
    Plane12(plane12::Plane12Args),
    /// Complete exterior sets of a conic in PG(2,q).
    ExteriorSets(exterior_sets::ExteriorSetsArgs),
    /// Arcs, codes, and probes in the projective Hjelmslev plane over a chain
    /// ring of order four. Requires the `chain-ring` feature, which currently
    /// does not build; see that feature's note in `Cargo.toml`.
    #[cfg(feature = "chain-ring")]
    ChainRing(chain_ring::ChainRingArgs),
    /// Parametric covering families and their residual-prime certificate.
    ParametricCert(parametric_cert::ParametricCertArgs),
}

#[derive(Subcommand)]
enum PrsCommand {
    /// Exact PRS deep-hole census via normal-rational-curve rank in PG(d,q).
    Deephole(prs_deephole::DeepholeArgs),
    /// Parallel exact PRS deep-hole census in PG(r-1,q).
    Census(prs_census::CensusArgs),
    /// Exact deep-hole decision on a PRS carrier stratum, top level only.
    Stratum(prs_stratum::StratumArgs),
}

#[derive(Subcommand)]
enum CssCommand {
    /// Exact diagonal transversal groups of small qubit CSS codes.
    Transversal(transversal_css::TransversalArgs),
    /// Transversal hierarchy level versus X-check weight census.
    Levels(level_census::LevelsArgs),
}

fn main() -> Result<()> {
    match Cli::parse().command {
        Command::Prs(PrsCommand::Deephole(args)) => prs_deephole::run(args),
        Command::Prs(PrsCommand::Census(args)) => prs_census::run(args),
        Command::Prs(PrsCommand::Stratum(args)) => prs_stratum::run(args),
        Command::Css(CssCommand::Transversal(args)) => {
            transversal_css::run(args).map_err(Into::into)
        }
        Command::Css(CssCommand::Levels(args)) => {
            level_census::run(args);
            Ok(())
        }
        Command::Plane12(args) => plane12::run(args),
        Command::ExteriorSets(args) => exterior_sets::run(args),
        #[cfg(feature = "chain-ring")]
        Command::ChainRing(args) => chain_ring::run(args),
        Command::ParametricCert(args) => {
            parametric_cert::run(args);
            Ok(())
        }
    }
}
