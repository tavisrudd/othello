//! Hadamard-2092 multiplier-sector drivers.
//!
//! Tier-2 task crate: one binary, one subcommand per driver, grouped by
//! multiplier sector.  Each module owns a `clap::Args` struct named `Arguments`
//! and a `run` entry point; this file contains nothing but the command tree and
//! its dispatch.

use anyhow::Result;
use clap::{Parser, Subcommand};

mod evolve;
mod g133;
mod g41;
mod g53;
mod g91;
mod order6;
mod proof;
mod q18;

#[derive(Parser)]
#[command(about = "Hadamard-2092 multiplier-sector drivers")]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    /// `g=41` joint quotient sector.
    #[command(subcommand)]
    G41(G41Command),
    /// `g=53` sparse-defect q4 sector and its discovery campaign.
    #[command(subcommand)]
    G53(G53Command),
    /// `g=91` defect-obstruction sector.
    #[command(subcommand)]
    G91(G91Command),
    /// `g=133` exact-interior sector.
    #[command(subcommand)]
    G133(G133Command),
    /// Exact q18 shell and the unrestricted q18/q29 bridge.
    #[command(subcommand)]
    Q18(Q18Command),
    /// Order-six margin sector on the open q29 path.
    #[command(subcommand)]
    Order6(Order6Command),
    /// Standing evolve backfill and blind-discovery controls.
    #[command(subcommand)]
    Evolve(EvolveCommand),
    /// Proof-synthesis counter harness.
    #[command(subcommand)]
    Proof(ProofCommand),
}

#[derive(Subcommand)]
enum G41Command {
    /// Synthesize the G41 quotient-filter proof from the registered binding and observed shift hits.
    QuotientProof(g41::quotient_proof::Arguments),
    /// Enumerate G41 joint digit witnesses and write the sealed witness cache.
    DigitCache(g41::digit_cache::Arguments),
    /// Enumerate G41 joint digit witnesses and report the summary or the full report.
    DigitWitnesses(g41::digit_witnesses::Arguments),
    /// Report Z18 orbit-histogram patterns of cyclic multiplier partitions for generators 41, 53, 91, 133.
    Z18Projection(g41::z18_projection::Arguments),
    /// q174 joint interface tables and their replays.
    #[command(subcommand)]
    Q174(Q174Command),
    /// q29 lift: caches, block specs, and the profile campaign.
    #[command(subcommand)]
    Q29(Q29Command),
    /// q87 block energies.
    #[command(subcommand)]
    Q87(Q87Command),
}

#[derive(Subcommand)]
enum Q174Command {
    /// Compile one exact q174 joint tablebase block.
    Joint(g41::q174::joint::Arguments),
    /// Scan the bounded broad grouped join across all four exact q174 blocks.
    JointJoin(g41::q174::joint_join::Arguments),
    /// Replay the full-q87 join over a presentation-bound target-fibre artifact.
    FullQ87Join(g41::q174::full_q87_join::Arguments),
    /// Prove the q174 zero-energy lower bound for exact G41/q18 interfaces.
    EnergyTheorem(g41::q174::energy_theorem::Arguments),
    /// Prove the q174 coset-complement (flip) symmetry.
    FlipProof(g41::q174::flip_proof::Arguments),
    /// Compile the second-stage exact q174 target fibres behind sampled grouped-join matches.
    TargetFibres(g41::q174::target_fibres::Arguments),
    /// Exact single-block target-fibre benchmark replay, optionally in translation-control mode.
    TargetFibreReplay(g41::q174::target_fibre_replay::Arguments),
    /// Replay q87 defects for four packed q174 states.
    Q87Replay(g41::q174::q87_replay::Arguments),
}

#[derive(Subcommand)]
enum Q29Command {
    /// Cold exact census of q29 block specs over a sealed digit-witness cache.
    BlockSpecs(g41::q29::block_specs::Arguments),
    /// Build and seal the q29 matched-profile-pair cache by exact-key scan over all projection shards.
    MatchedPairCache(Box<g41::q29::matched_pair_cache::Arguments>),
    /// Independent readback audit of the q29 pair-target cache against recompiled source tables.
    CacheAudit(g41::q29::cache_audit::Arguments),
    /// Synthesize the complement-cycle proof and q29 coset action from exact successful mask scopes.
    CycleProof(g41::q29::cycle_proof::Arguments),
    /// Exact dual-archetype q29 profile-pair campaign over projection shards.
    Campaign(Box<g41::q29::campaign::Arguments>),
    /// Lift an exact q29 aggregate-profile hit to concrete fine-orbit masks and replay it word-level.
    HitLift(Box<g41::q29::hit_lift::Arguments>),
    /// Replay the sealed q29 selection and emit its exact replay report.
    HitReplay(g41::q29::hit_replay::Arguments),
    /// Cost model for q29 spec replay versus grouped decompositions with Gale-Ryser feasibility.
    WorkModel(g41::q29::work_model::Arguments),
}

#[derive(Subcommand)]
enum Q87Command {
    /// Marginal three-lift Eisenstein energy supports for the four q87 blocks and their compatible quartets.
    Energy(g41::q87::energy::Arguments),
    /// Exact q87 energy census per block, reachable energy vectors, or the exact lift proof.
    ExactEnergy(g41::q87::exact_energy::Arguments),
}

#[derive(Subcommand)]
enum G53Command {
    /// Heuristic local search over the g53 carrier-522 quotient shells.
    Search(Box<g53::search::Arguments>),
    /// Synthesize the g53 sparse q4 proof.
    Q4Proof(g53::q4_proof::Arguments),
    /// Independent exhaustive replay oracle for the g53 sparse q4 census.
    Q4Oracle(g53::q4_oracle::Arguments),
}

#[derive(Subcommand)]
enum G91Command {
    /// Synthesize the g91 defect-obstruction proof for the observed evolved candidate.
    DefectProof(g91::defect_proof::Arguments),
}

#[derive(Subcommand)]
enum G133Command {
    /// Synthesize and verify the exact g133 q2 proof, emitting it as JSON.
    Q2Proof(g133::q2_proof::Arguments),
    /// Synthesize and verify the exact g133 shift proof for a given shift.
    ShiftProof(g133::shift_proof::Arguments),
    /// Synthesize and verify the g133 cycle-mod-11 proof against the evolved candidate.
    CycleMod11Proof(g133::cycle_mod11_proof::Arguments),
    /// Write a g133 exact-shift evolve campaign file with a survives/excluded label.
    EvolveAdapter(g133::evolve_adapter::Arguments),
}

#[derive(Subcommand)]
enum Q18Command {
    /// Measure the q18 energy-gate corpus and broad q174 shell reject rates over pseudorandom fixed-weight samples.
    EnergyCorpus(q18::energy_corpus::Arguments),
    /// Search the radius-four local-repair families for an exact q18 coefficient repair.
    LocalRepair(q18::local_repair::Arguments),
    /// Bridge a q18 solution to a q29 solution via the proved binary margin lift and replay the canonical candidate.
    Q29Bridge(q18::q29_bridge::Arguments),
    /// Evolve q18 unassumed-block candidates across worker threads and print the best report as JSON.
    UnassumedEvolve(q18::unassumed_evolve::Arguments),
}

#[derive(Subcommand)]
enum Order6Command {
    /// Evolve the order-6 margin shell and report the best worker as JSON.
    MarginEvolve(order6::margin_evolve::Arguments),
    /// Exact scoped q29 repair search over an evolve output file.
    Q29Repair(order6::q29_repair::Arguments),
}

#[derive(Subcommand)]
enum EvolveCommand {
    /// Exhaustive rule-ablation corpora for the sealed proof systems.
    #[command(subcommand)]
    BankedRules(BankedRulesCommand),
    /// Theorem-specific semantic residual corpora for the banked reductions.
    #[command(subcommand)]
    BankedSemantics(BankedSemanticsCommand),
    /// Emit paired train/holdout raw-feature corpora for every banked semantic system.
    RawFeatures(evolve::raw_features::Arguments),
    /// Theorem-agnostic train/holdout harness for expanded scalar observations.
    BlindHoldout(evolve::blind_holdout::Arguments),
}

#[derive(Subcommand)]
enum BankedRulesCommand {
    /// Emit the banked rule-ablation evolution campaign corpus for one reduction.
    Emit(evolve::banked_rules_emit::Arguments),
    /// Audit banked rule-ablation campaigns per registered rule system.
    Audit(evolve::banked_rules_audit::Arguments),
}

#[derive(Subcommand)]
enum BankedSemanticsCommand {
    /// Emit banked semantic-evolution corpora for every registered semantic system.
    Emit(evolve::banked_semantics_emit::Arguments),
    /// Audit banked semantic-evolution campaigns across all registered systems.
    Audit(evolve::banked_semantics_audit::Arguments),
}

#[derive(Subcommand)]
enum ProofCommand {
    /// Microbenchmark the derive and replay kernels of each proof adapter.
    Perf(proof::perf::Arguments),
}

fn main() -> Result<()> {
    match Cli::parse().command {
        Command::G41(command) => match command {
            G41Command::QuotientProof(arguments) => g41::quotient_proof::run(arguments),
            G41Command::DigitCache(arguments) => g41::digit_cache::run(arguments),
            G41Command::DigitWitnesses(arguments) => g41::digit_witnesses::run(arguments),
            G41Command::Z18Projection(arguments) => g41::z18_projection::run(arguments),
            G41Command::Q174(command) => match command {
                Q174Command::Joint(arguments) => g41::q174::joint::run(arguments),
                Q174Command::JointJoin(arguments) => g41::q174::joint_join::run(arguments),
                Q174Command::FullQ87Join(arguments) => g41::q174::full_q87_join::run(arguments),
                Q174Command::EnergyTheorem(arguments) => g41::q174::energy_theorem::run(arguments),
                Q174Command::FlipProof(arguments) => g41::q174::flip_proof::run(arguments),
                Q174Command::TargetFibres(arguments) => g41::q174::target_fibres::run(arguments),
                Q174Command::TargetFibreReplay(arguments) => {
                    g41::q174::target_fibre_replay::run(arguments)
                }
                Q174Command::Q87Replay(arguments) => g41::q174::q87_replay::run(arguments),
            },
            G41Command::Q29(command) => match command {
                Q29Command::BlockSpecs(arguments) => g41::q29::block_specs::run(arguments),
                Q29Command::MatchedPairCache(arguments) => {
                    g41::q29::matched_pair_cache::run(*arguments)
                }
                Q29Command::CacheAudit(arguments) => g41::q29::cache_audit::run(arguments),
                Q29Command::CycleProof(arguments) => g41::q29::cycle_proof::run(arguments),
                Q29Command::Campaign(arguments) => g41::q29::campaign::run(*arguments),
                Q29Command::HitLift(arguments) => g41::q29::hit_lift::run(*arguments),
                Q29Command::HitReplay(arguments) => g41::q29::hit_replay::run(arguments),
                Q29Command::WorkModel(arguments) => g41::q29::work_model::run(arguments),
            },
            G41Command::Q87(command) => match command {
                Q87Command::Energy(arguments) => g41::q87::energy::run(arguments),
                Q87Command::ExactEnergy(arguments) => g41::q87::exact_energy::run(arguments),
            },
        },
        Command::G53(command) => match command {
            G53Command::Search(arguments) => g53::search::run(*arguments),
            G53Command::Q4Proof(arguments) => g53::q4_proof::run(arguments),
            G53Command::Q4Oracle(arguments) => g53::q4_oracle::run(arguments),
        },
        Command::G91(command) => match command {
            G91Command::DefectProof(arguments) => g91::defect_proof::run(arguments),
        },
        Command::G133(command) => match command {
            G133Command::Q2Proof(arguments) => g133::q2_proof::run(arguments),
            G133Command::ShiftProof(arguments) => g133::shift_proof::run(arguments),
            G133Command::CycleMod11Proof(arguments) => g133::cycle_mod11_proof::run(arguments),
            G133Command::EvolveAdapter(arguments) => g133::evolve_adapter::run(arguments),
        },
        Command::Q18(command) => match command {
            Q18Command::EnergyCorpus(arguments) => q18::energy_corpus::run(arguments),
            Q18Command::LocalRepair(arguments) => q18::local_repair::run(arguments),
            Q18Command::Q29Bridge(arguments) => q18::q29_bridge::run(arguments),
            Q18Command::UnassumedEvolve(arguments) => q18::unassumed_evolve::run(arguments),
        },
        Command::Order6(command) => match command {
            Order6Command::MarginEvolve(arguments) => order6::margin_evolve::run(arguments),
            Order6Command::Q29Repair(arguments) => order6::q29_repair::run(arguments),
        },
        Command::Evolve(command) => match command {
            EvolveCommand::BankedRules(command) => match command {
                BankedRulesCommand::Emit(arguments) => evolve::banked_rules_emit::run(arguments),
                BankedRulesCommand::Audit(arguments) => evolve::banked_rules_audit::run(arguments),
            },
            EvolveCommand::BankedSemantics(command) => match command {
                BankedSemanticsCommand::Emit(arguments) => {
                    evolve::banked_semantics_emit::run(arguments)
                }
                BankedSemanticsCommand::Audit(arguments) => {
                    evolve::banked_semantics_audit::run(arguments)
                }
            },
            EvolveCommand::RawFeatures(arguments) => evolve::raw_features::run(arguments),
            EvolveCommand::BlindHoldout(arguments) => evolve::blind_holdout::run(arguments),
        },
        Command::Proof(command) => match command {
            ProofCommand::Perf(arguments) => proof::perf::run(arguments),
        },
    }
}
