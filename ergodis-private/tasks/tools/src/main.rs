//! Lane-neutral private operator tools.
//!
//! Tier-2 task crate: one binary, one subcommand per tool.  Each module owns a
//! `clap::Args` struct and a `run` entry point; this file contains nothing but
//! the command tree and its dispatch.

use anyhow::Result;
use clap::{Parser, Subcommand};

mod alignment_controlled;
mod alignment_root_corpus;
mod c80_hall_rematch;
mod c985_extension_field_elimination_bench;
mod campaign_rpc;
mod certdist;
mod certiis;
mod css_bp_osd_spike;
mod hall_certify;
mod projective_grid_scout;
mod q16_quadratic;
mod q19_marked_polar;
mod q25_pair_repair;
mod qdist_to_ergodis;
mod repr_search;
mod routing_policy_audit;
mod semantic_affine_census;
mod semantic_rank_census;
mod target_strategy_audit;

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
    /// C985 CSS-distance drivers.
    #[command(subcommand)]
    Css(CssCommand),
    /// Explainable infeasibility for assignment problems.
    Certiis(certiis::Arguments),
    /// Private campaign RPC helper.
    CampaignRpc(campaign_rpc::Args),
    /// Generate an exact per-root alignment cost corpus.
    AlignmentRootCorpus(Box<alignment_root_corpus::Args>),
    /// Learn a conservative routing policy from matched evolution audits.
    RoutingPolicyAudit(Box<routing_policy_audit::Args>),
    /// Matched exact audit of evolution target strategies.
    TargetStrategyAudit(Box<target_strategy_audit::Args>),
    /// Census of affine semantic plans over a `nine_set` TSV.
    SemanticAffineCensus(semantic_affine_census::Args),
    /// Allocation-free semantic rank kernel census for counter isolation.
    SemanticRankCensus(semantic_rank_census::Args),
    /// C80 consumed-label Hall rematching instances and admission triage.
    C80HallRematch(Box<c80_hall_rematch::Arguments>),
    /// C1051 spike: evolve-style search over a typed lossless-encoder grammar.
    ReprSearch(Box<repr_search::Args>),
}

#[derive(Subcommand)]
enum CssCommand {
    /// Certified exact minimum-distance service prototype (job-level driver for
    /// the Ergodis CSS distance core).
    Certdist(certdist::Cli),
    /// Convert an external QDistSAT matrix stem into a checked Ergodis CSS input.
    QdistToErgodis(Box<qdist_to_ergodis::Args>),
    /// Private BP+OSD CSS logical-witness application spike.
    BpOsdSpike(Box<css_bp_osd_spike::Args>),
    /// C985 diagnostic isolating table-backed characteristic-two row reduction.
    ExtensionFieldEliminationBench(c985_extension_field_elimination_bench::Arguments),
}

fn main() -> Result<()> {
    match Cli::parse().command {
        Command::ProjectiveGridScout(args) => projective_grid_scout::run(args),
        Command::AlignmentControlled(args) => alignment_controlled::run(*args),
        Command::HallCertify(args) => hall_certify::run(args),
        Command::Q25PairRepair(args) => q25_pair_repair::run(args),
        Command::Q16Quadratic(args) => q16_quadratic::run(args),
        Command::Q19MarkedPolar => q19_marked_polar::run(),
        Command::Css(command) => match command {
            CssCommand::Certdist(args) => certdist::run(args),
            CssCommand::QdistToErgodis(args) => qdist_to_ergodis::run(*args),
            CssCommand::BpOsdSpike(args) => css_bp_osd_spike::run(*args),
            CssCommand::ExtensionFieldEliminationBench(args) => {
                c985_extension_field_elimination_bench::run(args)
            }
        },
        Command::Certiis(args) => certiis::run(args),
        Command::CampaignRpc(args) => campaign_rpc::run(args),
        Command::AlignmentRootCorpus(args) => alignment_root_corpus::run(*args),
        Command::RoutingPolicyAudit(args) => routing_policy_audit::run(*args),
        Command::TargetStrategyAudit(args) => target_strategy_audit::run(*args),
        Command::SemanticAffineCensus(args) => semantic_affine_census::run(args),
        Command::SemanticRankCensus(args) => semantic_rank_census::run(args),
        Command::C80HallRematch(args) => c80_hall_rematch::run(*args),
        Command::ReprSearch(args) => repr_search::run(*args),
    }
}

/// The C1051 spike rejects any encoder candidate that allocates in its decode
/// or probe path, so the binary carries a counting allocator. Its non-measuring
/// path is one relaxed atomic load.
/// Not registered under `cfg(test)`: the public core installs its own counting
/// allocator in its test configuration, and a crate may define only one.
#[cfg(not(test))]
#[global_allocator]
static ALLOCATOR: repr_search::alloc_guard::CountingAllocator =
    repr_search::alloc_guard::CountingAllocator;
