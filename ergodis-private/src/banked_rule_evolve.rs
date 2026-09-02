//! Discovery-only Ergodis corpora for the sealed private proof mechanisms.
//!
//! Each corpus ablates subsets of one registered Horn-rule system. Features
//! are semantic proof steps, never row IDs or labels. The label says whether
//! the sealed goal remains derivable from the canonical initial facts.

use std::fs::{File, OpenOptions};
use std::io::{BufWriter, Write};
use std::os::unix::fs::OpenOptionsExt;
use std::path::Path;

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::proof_synthesis::RuleSpec;

const DATA_SCHEMA: &str = "ergodis-campaign-data-v0";
const GENERATOR_NAME: &str = "c1016-banked-proof-rule-ablation";
const GENERATOR_VERSION: &str = "1";
const MAX_RULES: usize = 12;

#[derive(Clone, Copy)]
pub struct BankedRuleSystem {
    pub slug: &'static str,
    pub rules: &'static [RuleSpec],
    pub initial_facts: u64,
    pub goal_facts: u64,
    pub fields: &'static [&'static str],
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct BankedRuleCorpusReport {
    pub reduction: &'static str,
    pub rules: u8,
    pub rows: u32,
    pub positive_rows: u32,
    pub generator_digest: [u8; 32],
    pub provenance: &'static str,
}

#[derive(Debug, Error)]
pub enum BankedRuleEvolveError {
    #[error("unknown banked proof reduction")]
    UnknownReduction,
    #[error("banked proof rule system exceeds its bound or is malformed")]
    InvalidRuleSystem,
    #[error(transparent)]
    Io(#[from] std::io::Error),
    #[error(transparent)]
    Json(#[from] serde_json::Error),
}

#[derive(Serialize)]
struct GeneratorHeader<'a> {
    name: &'a str,
    version: &'a str,
    digest: String,
}

#[derive(Serialize)]
struct DataHeader<'a> {
    schema: &'a str,
    presentation: String,
    problem: String,
    fields: &'a [&'a str],
    rows: usize,
    generator: GeneratorHeader<'a>,
}

#[derive(Serialize)]
struct DataRow<'a> {
    id: u64,
    expected: bool,
    values: &'a [i64],
}

pub fn banked_rule_systems() -> [BankedRuleSystem; 10] {
    let subgroup = crate::subgroup_energy_proof::evolve_rule_system();
    let quotient = crate::quotient_paf_proof::evolve_rule_system();
    let coverage = crate::quotient_paf_proof::evolve_coverage_rule_system();
    let g53 = crate::g53_reduction_proof::evolve_rule_system();
    let g53_defect = crate::g53_defect_profile_proof::evolve_rule_system();
    let g53_q4 = crate::g53_sparse_q4_proof::evolve_rule_system();
    let g41 = crate::g41_quotient_filter_proof::evolve_rule_system();
    let g133_q2 = crate::g133_exact_q2_proof::evolve_rule_system();
    let g133_shift = crate::g133_exact_shift_proof::evolve_rule_system();
    let g133_cycle = crate::g133_cycle_mod11_proof::evolve_rule_system();
    [
        system(
            "subgroup-energy",
            subgroup,
            &[
                "coset_partition",
                "ordered_pair_bijection",
                "diagonal_split",
                "energy_formula",
            ],
        ),
        system(
            "quotient-paf",
            quotient,
            &[
                "residue_partition",
                "pair_fibre_bijection",
                "zero_fibre_split",
                "quotient_targets",
            ],
        ),
        system(
            "quotient-character-coverage",
            coverage,
            &[
                "divisor_sectors",
                "complete_dual_coverage",
                "quotient_reduction",
            ],
        ),
        system(
            "g53-structural",
            g53,
            &[
                "raw_orbits",
                "five_families",
                "scales",
                "rational_weights",
                "q29_coordinates",
                "exact_census",
                "necessary_reduction",
            ],
        ),
        system(
            "g53-defect-profile",
            g53_defect,
            &[
                "five_family_projection",
                "quotient_zero_shift",
                "signed_energy",
                "defect_equation",
                "ten_profiles",
                "background_bound",
            ],
        ),
        system(
            "g53-q4-exclusion",
            g53_q4,
            &[
                "defect_theorem",
                "mod7_roots",
                "sparse_profiles",
                "four_fibres",
                "independent_replay",
                "q4_exclusion",
            ],
        ),
        system(
            "g41-quotient-filter",
            g41,
            &[
                "quotient_theorem",
                "orbit_reduction",
                "independent_domains",
                "exact_filters",
                "intersection",
                "necessary_reduction",
            ],
        ),
        system(
            "g133-q2",
            g133_q2,
            &[
                "canonical_orbits",
                "exact_primary",
                "independent_oracle",
                "direct_replay",
                "q2_reduction",
            ],
        ),
        system(
            "g133-exact-shift",
            g133_shift,
            &[
                "canonical_orbits",
                "exact_primary",
                "independent_oracle",
                "gap_mechanism",
                "direct_replay",
                "necessary_reduction",
            ],
        ),
        system(
            "g133-cycle-mod11",
            g133_cycle,
            &[
                "evolved_feature_reextracted",
                "three_cycle_identity",
                "canonical_q6_coverage",
                "primary_exclusion",
                "independent_replay",
                "necessary_exclusion",
            ],
        ),
    ]
}

const fn system(
    slug: &'static str,
    source: (&'static [RuleSpec], u64, u64),
    fields: &'static [&'static str],
) -> BankedRuleSystem {
    BankedRuleSystem {
        slug,
        rules: source.0,
        initial_facts: source.1,
        goal_facts: source.2,
        fields,
    }
}

#[inline(always)]
pub fn ablated_closure(system: BankedRuleSystem, enabled_rules: u64) -> u64 {
    let mut facts = system.initial_facts;
    loop {
        let before = facts;
        for (index, rule) in system.rules.iter().enumerate() {
            if enabled_rules & (1_u64 << index) != 0 && facts & rule.premises() == rule.premises() {
                facts |= 1_u64 << rule.conclusion();
            }
        }
        if facts == before {
            return facts;
        }
    }
}

fn validate(system: BankedRuleSystem) -> Result<(), BankedRuleEvolveError> {
    if system.rules.is_empty()
        || system.rules.len() > MAX_RULES
        || system.rules.len() != system.fields.len()
        || system.goal_facts == 0
        || system.fields.iter().any(|field| field.is_empty())
    {
        return Err(BankedRuleEvolveError::InvalidRuleSystem);
    }
    Ok(())
}

fn digest(system: BankedRuleSystem) -> [u8; 32] {
    let mut hasher = Sha256::new();
    hasher.update(GENERATOR_NAME.as_bytes());
    hasher.update(GENERATOR_VERSION.as_bytes());
    hasher.update(system.slug.as_bytes());
    hasher.update(system.initial_facts.to_le_bytes());
    hasher.update(system.goal_facts.to_le_bytes());
    for (field, rule) in system.fields.iter().zip(system.rules) {
        hasher.update(field.as_bytes());
        hasher.update([0]);
        hasher.update(rule.identity().to_le_bytes());
        hasher.update(rule.premises().to_le_bytes());
        hasher.update([rule.conclusion()]);
    }
    hasher.finalize().into()
}

fn digest_hex(digest: [u8; 32]) -> String {
    const HEX: &[u8; 16] = b"0123456789abcdef";
    let mut output = String::with_capacity(64);
    for byte in digest {
        output.push(char::from(HEX[usize::from(byte >> 4)]));
        output.push(char::from(HEX[usize::from(byte & 15)]));
    }
    output
}

pub fn write_banked_rule_campaign(
    reduction: &str,
    output: &Path,
) -> Result<BankedRuleCorpusReport, BankedRuleEvolveError> {
    let system = banked_rule_systems()
        .into_iter()
        .find(|system| system.slug == reduction)
        .ok_or(BankedRuleEvolveError::UnknownReduction)?;
    validate(system)?;
    let rows = 1_usize << system.rules.len();
    let generator_digest = digest(system);
    let file: File = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .open(output)?;
    let mut writer = BufWriter::with_capacity(64 * 1024, file);
    serde_json::to_writer(
        &mut writer,
        &DataHeader {
            schema: DATA_SCHEMA,
            presentation: format!("c1016-{}-rule-ablation-v1", system.slug),
            problem: format!("banked-proof-{}", system.slug),
            fields: system.fields,
            rows,
            generator: GeneratorHeader {
                name: GENERATOR_NAME,
                version: GENERATOR_VERSION,
                digest: digest_hex(generator_digest),
            },
        },
    )?;
    writer.write_all(b"\n")?;
    let mut positive_rows = 0_u32;
    let mut values = Vec::with_capacity(system.rules.len());
    for mask in 0_u64..rows as u64 {
        let expected = ablated_closure(system, mask) & system.goal_facts == system.goal_facts;
        positive_rows += u32::from(expected);
        values.clear();
        for rule in 0..system.rules.len() {
            values.push(i64::from(mask & (1_u64 << rule) != 0));
        }
        serde_json::to_writer(
            &mut writer,
            &DataRow {
                id: mask,
                expected,
                values: &values,
            },
        )?;
        writer.write_all(b"\n")?;
    }
    writer.flush()?;
    Ok(BankedRuleCorpusReport {
        reduction: system.slug,
        rules: system.rules.len() as u8,
        rows: rows as u32,
        positive_rows,
        generator_digest,
        provenance: "discovery-only exhaustive rule-ablation corpus; authority remains with the sealed extractor and independent transcript replay",
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;
    use crate::proof_synthesis::derive_horn_closure;

    #[test]
    fn every_banked_rule_ablation_matches_the_proof_engine() {
        for system in banked_rule_systems() {
            validate(system).unwrap();
            for mask in 0_u64..(1_u64 << system.rules.len()) {
                let selected = system
                    .rules
                    .iter()
                    .enumerate()
                    .filter_map(|(index, rule)| (mask & (1_u64 << index) != 0).then_some(*rule))
                    .collect::<Vec<_>>();
                let expected =
                    ablated_closure(system, mask) & system.goal_facts == system.goal_facts;
                let actual = derive_horn_closure(
                    system.initial_facts,
                    system.goal_facts,
                    &selected,
                    selected.len() as u32,
                )
                .is_ok();
                assert_eq!(actual, expected, "{} mask {mask:#x}", system.slug);
            }
        }
    }

    #[test]
    fn ablation_closure_kernel_allocates_nothing() {
        let system = banked_rule_systems()[3];
        let (_, allocations) = tracked_allocations(|| {
            for mask in 0_u64..128 {
                std::hint::black_box(ablated_closure(system, mask));
            }
        });
        assert_eq!(allocations, 0);
    }
}
