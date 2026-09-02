use std::fs;
use std::io::Cursor;
use std::path::PathBuf;
use std::sync::atomic::{AtomicUsize, Ordering};

use anyhow::{ensure, Context, Result};
use clap::Parser;
use ergodis_private::g41_digit_witness_cache::read_g41_digit_witness_cache;
use ergodis_private::g41_q29_aggregate_pair_graph::compile_g41_q29_aggregate_pair_graph;
use ergodis_private::g41_q29_exact_tablebase::compile_g41_q29_aggregate_block_tablebase;
use ergodis_private::g41_q29_exact_tablebase::{
    audit_g41_q29_fixed_zero_defect_fibres, G41Q29FixedZeroDefectFibreReport,
};
use serde::Serialize;
use sha2::{Digest, Sha256};

#[derive(Parser)]
struct Args {
    #[arg(long)]
    cache: PathBuf,
    #[arg(long, default_value_t = 2)]
    threads: usize,
    #[arg(long)]
    prove_saturation: bool,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq, PartialOrd, Ord)]
struct SignatureReport {
    signature: [u8; 4],
    coefficient_states: u32,
    admissible_coefficient_states: u32,
    profiles: u32,
    profile_digest: [u8; 32],
    workspace_bytes: u64,
}

#[derive(Serialize)]
struct Report {
    threads: u8,
    source_cache_digest: [u8; 32],
    signatures: Vec<SignatureReport>,
    total_profiles: u64,
    maximum_profiles: u32,
    maximum_workspace_bytes_per_worker: u64,
    saturation_proof: Option<SaturationProof>,
    provenance: &'static str,
}

#[derive(Serialize)]
struct SaturationProof {
    extractor_id: &'static str,
    extractor_version: u16,
    canonical_semantics: &'static str,
    signatures_verified: u16,
    fixed_zero_domains: [G41Q29FixedZeroDefectFibreReport; 4],
    substitution_classes: [SaturationClass; 4],
    authority: &'static str,
    provenance: &'static str,
}

#[derive(Clone, Copy, Serialize)]
struct SaturationClass {
    row_sum: u16,
    canonical_zero_coefficient: u8,
    maximum_fibre: u8,
    signatures: u16,
    admissible_coefficient_states: u32,
    exact_correlation_profiles: u32,
}

fn signature_row_sum(signature: [u8; 4]) -> u16 {
    u16::from(signature[0])
        + 4 * u16::from(signature[1])
        + 4 * u16::from(signature[2])
        + 12 * u16::from(signature[3])
}

fn saturation_class(signature: [u8; 4]) -> Option<usize> {
    match signature[0] {
        8 => Some(0),
        1 | 17 => Some(1),
        5 | 13 => Some(2),
        9 => Some(3),
        _ => None,
    }
}

fn signature_matches_fixed_domain(
    entry: &SignatureReport,
    fixed: &G41Q29FixedZeroDefectFibreReport,
) -> bool {
    entry.admissible_coefficient_states == fixed.admissible_coefficient_vectors
        && entry.profiles == fixed.exact_correlation_profiles
        && entry.profile_digest == fixed.profile_digest
        && signature_row_sum(entry.signature) == fixed.row_sum
        && entry.signature[0].min(18 - entry.signature[0]) == fixed.zero_coefficient
}

fn main() -> Result<()> {
    let args = Args::parse();
    ensure!((1..=4).contains(&args.threads));
    let source_bytes = fs::read(args.cache)?;
    let source_cache_digest: [u8; 32] = Sha256::digest(&source_bytes).into();
    let source = read_g41_digit_witness_cache(Cursor::new(source_bytes))?;
    let graph = compile_g41_q29_aggregate_pair_graph(&source.witnesses)?;
    let next = AtomicUsize::new(0);
    let workers = std::thread::scope(|scope| -> Result<Vec<Vec<SignatureReport>>> {
        let mut handles = Vec::with_capacity(args.threads);
        for _ in 0..args.threads {
            handles.push(scope.spawn(|| -> Result<Vec<SignatureReport>> {
                let mut reports = Vec::new();
                loop {
                    let index = next.fetch_add(1, Ordering::Relaxed);
                    let Some(&signature) = graph.signatures.get(index) else {
                        break;
                    };
                    let table = compile_g41_q29_aggregate_block_tablebase(signature)?;
                    reports.push(SignatureReport {
                        signature,
                        coefficient_states: table.report.exact_coefficient_states,
                        admissible_coefficient_states: table
                            .report
                            .exact_coefficient_states
                            .checked_sub(table.report.profiles_exceeding_defect_budget)
                            .context("admissible coefficient-state count underflow")?,
                        profiles: table.report.exact_correlation_profiles,
                        profile_digest: table.report.profile_digest,
                        workspace_bytes: table.report.workspace_bytes,
                    });
                }
                Ok(reports)
            }));
        }
        handles
            .into_iter()
            .map(|handle| {
                handle
                    .join()
                    .map_err(|_| anyhow::anyhow!("worker panicked"))?
            })
            .collect()
    })?;
    let mut signatures: Vec<SignatureReport> = workers.into_iter().flatten().collect();
    signatures.sort_unstable();
    ensure!(signatures.len() == graph.signatures.len());
    let total_profiles = signatures
        .iter()
        .map(|entry| u64::from(entry.profiles))
        .sum();
    let maximum_profiles = signatures
        .iter()
        .map(|entry| entry.profiles)
        .max()
        .unwrap_or(0);
    let maximum_workspace_bytes_per_worker = signatures
        .iter()
        .map(|entry| entry.workspace_bytes)
        .max()
        .unwrap_or(0);
    let saturation_proof = args
        .prove_saturation
        .then(|| -> Result<SaturationProof> {
            let fixed_zero_domains = [
                audit_g41_q29_fixed_zero_defect_fibres(260, 8)?,
                audit_g41_q29_fixed_zero_defect_fibres(261, 1)?,
                audit_g41_q29_fixed_zero_defect_fibres(261, 5)?,
                audit_g41_q29_fixed_zero_defect_fibres(261, 9)?,
            ];
            let mut signature_counts = [0_u16; 4];
            for entry in &signatures {
                let class = saturation_class(entry.signature)
                    .context("signature escaped the fixed-zero classes")?;
                let fixed = &fixed_zero_domains[class];
                ensure!(signature_matches_fixed_domain(entry, fixed));
                signature_counts[class] = signature_counts[class]
                    .checked_add(1)
                    .context("saturation-class signature count overflow")?;
            }
            ensure!(signature_counts.iter().all(|&count| count != 0));
            let substitution_classes = std::array::from_fn(|class| {
                let fixed = &fixed_zero_domains[class];
                SaturationClass {
                    row_sum: fixed.row_sum,
                    canonical_zero_coefficient: fixed.zero_coefficient,
                    maximum_fibre: fixed.maximum_fibre,
                    signatures: signature_counts[class],
                    admissible_coefficient_states: fixed.admissible_coefficient_vectors,
                    exact_correlation_profiles: fixed.exact_correlation_profiles,
                }
            });
            Ok(SaturationProof {
                extractor_id: "ergodis-private.g41-q29-aggregate-saturation",
                extractor_version: 2,
                canonical_semantics: "length-522 multiplier-41 q29 coefficient counts; row sum and zero coefficient fixed; seven ordered Dirichlet defects bounded by 523; coefficient complement canonicalized only by the typed extractor",
                signatures_verified: signatures.len() as u16,
                fixed_zero_domains,
                substitution_classes,
                authority: "exact-profile-table-substitution-only",
                provenance: "each compiled aggregate coefficient image is structurally a subset of its matching fixed-zero row domain; independently equal admissible-state cardinality proves finite-set equality, while exact fibre grouping proves the defect map is singleton except for explicit coefficient complements; this authority replaces signature-labelled q29 profile tables only and cannot exclude a source root or issue a final certificate",
            })
        })
        .transpose()?;
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            threads: args.threads as u8,
            source_cache_digest,
            signatures,
            total_profiles,
            maximum_profiles,
            maximum_workspace_bytes_per_worker,
            saturation_proof,
            provenance: "exact aggregate-signature q29 table census over every node label in the sealed pair graph; bounded workers compile independent immutable tables, the source cache byte digest is retained after typed payload replay, and no shared atomic is touched inside a table kernel",
        },
    )?;
    println!();
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn fixed() -> G41Q29FixedZeroDefectFibreReport {
        G41Q29FixedZeroDefectFibreReport {
            row_sum: 260,
            zero_coefficient: 8,
            coefficient_vectors: 20,
            admissible_coefficient_vectors: 10,
            exact_correlation_profiles: 10,
            singleton_fibres: 10,
            complement_pair_fibres: 0,
            maximum_fibre: 1,
            profile_digest: [7; 32],
            workspace_bytes: 100,
            provenance: "test fixture",
        }
    }

    fn entry() -> SignatureReport {
        SignatureReport {
            signature: [8, 3, 15, 15],
            coefficient_states: 12,
            admissible_coefficient_states: 10,
            profiles: 10,
            profile_digest: [7; 32],
            workspace_bytes: 100,
        }
    }

    #[test]
    fn saturation_binding_rejects_correct_class_with_wrong_semantics() {
        assert!(signature_matches_fixed_domain(&entry(), &fixed()));
        let mut wrong_values = entry();
        wrong_values.admissible_coefficient_states = 9;
        assert!(!signature_matches_fixed_domain(&wrong_values, &fixed()));
        let mut wrong_digest = entry();
        wrong_digest.profile_digest[0] ^= 1;
        assert!(!signature_matches_fixed_domain(&wrong_digest, &fixed()));
        let mut wrong_signature = entry();
        wrong_signature.signature[0] = 9;
        assert!(!signature_matches_fixed_domain(&wrong_signature, &fixed()));
    }
}
