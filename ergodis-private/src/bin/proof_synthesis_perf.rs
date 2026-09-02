use std::hint::black_box;

use anyhow::Result;
use clap::{Parser, ValueEnum};
use ergodis_private::g133_exact_q2_proof::{
    derive_g133_exact_q2_rules_into, replay_g133_exact_q2_rules,
};
use ergodis_private::g41_quotient_filter_proof::{
    derive_g41_quotient_filter_rules_into, replay_g41_quotient_filter_rules,
};
use ergodis_private::g53_defect_profile_proof::{
    derive_g53_defect_rules_into, replay_g53_defect_rules,
};
use ergodis_private::g53_mod7_reduction::{derive_g53_mod7_rules_into, replay_g53_mod7_rules};
use ergodis_private::g53_reduction_proof::{derive_g53_rules_into, replay_g53_rules};
use ergodis_private::g53_sparse_q4_proof::{
    derive_g53_sparse_q4_rules_into, replay_g53_sparse_q4_rules,
};
use ergodis_private::g91_defect_obstruction::{
    derive_g91_defect_rules_into, replay_g91_defect_rules,
};
use ergodis_private::proof_synthesis::RuleApplication;
use ergodis_private::quotient_paf_proof::{
    derive_quotient_paf_rules_into, replay_quotient_paf_rules,
};
use ergodis_private::reduction_proof::{
    derive_generator_91_rule_transcript_into, replay_generator_91_rule_transcript,
};
use ergodis_private::subgroup_energy_proof::{
    derive_subgroup_energy_rules_into, replay_subgroup_energy_rules,
};

#[derive(Clone, Copy, Debug, ValueEnum)]
enum Kernel {
    Derive,
    Replay,
}

#[derive(Clone, Copy, Debug, ValueEnum)]
enum Adapter {
    G91,
    G53,
    Subgroup,
    Quotient,
    Defect,
    Mod7,
    G53Sparse,
    G91Defect,
    G41Filter,
    G133ExactQ2,
}

#[derive(Debug, Parser)]
struct Arguments {
    #[arg(long, value_enum, default_value_t = Adapter::G91)]
    adapter: Adapter,
    #[arg(long, value_enum)]
    kernel: Kernel,
    #[arg(long, default_value_t = 100_000_000)]
    iterations: u64,
}

fn main() -> Result<()> {
    let arguments = Arguments::parse();
    let mut workspace = [RuleApplication::EMPTY; 8];
    let (_, used) = match arguments.adapter {
        Adapter::G91 => derive_generator_91_rule_transcript_into(&mut workspace)?,
        Adapter::G53 => derive_g53_rules_into(&mut workspace)?,
        Adapter::Subgroup => derive_subgroup_energy_rules_into(&mut workspace)?,
        Adapter::Quotient => derive_quotient_paf_rules_into(&mut workspace)?,
        Adapter::Defect => derive_g53_defect_rules_into(&mut workspace)?,
        Adapter::Mod7 => derive_g53_mod7_rules_into(&mut workspace)?,
        Adapter::G53Sparse => derive_g53_sparse_q4_rules_into(&mut workspace)?,
        Adapter::G91Defect => derive_g91_defect_rules_into(&mut workspace)?,
        Adapter::G41Filter => derive_g41_quotient_filter_rules_into(&mut workspace)?,
        Adapter::G133ExactQ2 => derive_g133_exact_q2_rules_into(&mut workspace)?,
    };
    let transcript = &workspace[..used];
    let mut checksum = 0_u64;
    match arguments.kernel {
        Kernel::Derive => {
            for _ in 0..arguments.iterations {
                let (facts, applications) = match arguments.adapter {
                    Adapter::G91 => {
                        derive_generator_91_rule_transcript_into(black_box(&mut workspace))?
                    }
                    Adapter::G53 => derive_g53_rules_into(black_box(&mut workspace))?,
                    Adapter::Subgroup => {
                        derive_subgroup_energy_rules_into(black_box(&mut workspace))?
                    }
                    Adapter::Quotient => derive_quotient_paf_rules_into(black_box(&mut workspace))?,
                    Adapter::Defect => derive_g53_defect_rules_into(black_box(&mut workspace))?,
                    Adapter::Mod7 => derive_g53_mod7_rules_into(black_box(&mut workspace))?,
                    Adapter::G53Sparse => {
                        derive_g53_sparse_q4_rules_into(black_box(&mut workspace))?
                    }
                    Adapter::G91Defect => derive_g91_defect_rules_into(black_box(&mut workspace))?,
                    Adapter::G41Filter => {
                        derive_g41_quotient_filter_rules_into(black_box(&mut workspace))?
                    }
                    Adapter::G133ExactQ2 => {
                        derive_g133_exact_q2_rules_into(black_box(&mut workspace))?
                    }
                };
                checksum ^= facts ^ applications as u64;
            }
        }
        Kernel::Replay => {
            for _ in 0..arguments.iterations {
                checksum ^= match arguments.adapter {
                    Adapter::G91 => replay_generator_91_rule_transcript(black_box(transcript))?,
                    Adapter::G53 => replay_g53_rules(black_box(transcript))?,
                    Adapter::Subgroup => replay_subgroup_energy_rules(black_box(transcript))?,
                    Adapter::Quotient => replay_quotient_paf_rules(black_box(transcript))?,
                    Adapter::Defect => replay_g53_defect_rules(black_box(transcript))?,
                    Adapter::Mod7 => replay_g53_mod7_rules(black_box(transcript))?,
                    Adapter::G53Sparse => replay_g53_sparse_q4_rules(black_box(transcript))?,
                    Adapter::G91Defect => replay_g91_defect_rules(black_box(transcript))?,
                    Adapter::G41Filter => replay_g41_quotient_filter_rules(black_box(transcript))?,
                    Adapter::G133ExactQ2 => replay_g133_exact_q2_rules(black_box(transcript))?,
                };
            }
        }
    }
    println!("checksum={checksum}");
    Ok(())
}
