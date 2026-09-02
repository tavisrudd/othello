use anyhow::Result;
use clap::Parser;
use ergodis_private::g41_joint_quotient_search::census_g41_joint_multiplicity;
use serde::Serialize;

#[derive(Parser)]
struct Args {
    #[arg(long)]
    full: bool,
}

#[derive(Serialize)]
struct Summary<'a> {
    roots_examined: u32,
    left_pair_fibres: u16,
    left_pair_candidates: u64,
    distinct_left_pair_states: u64,
    right_pair_candidates: u64,
    quotient_profile_quadruples: u128,
    raw_digit_quadruples: u128,
    minimum_root_profile_quadruples: u64,
    maximum_root_profile_quadruples: u64,
    minimum_root_digit_quadruples: u128,
    maximum_root_digit_quadruples: u128,
    provenance: &'a str,
}

fn main() -> Result<()> {
    let args = Args::parse();
    let report = census_g41_joint_multiplicity()?;
    if args.full {
        serde_json::to_writer(std::io::stdout(), &report)?;
    } else {
        serde_json::to_writer(
            std::io::stdout(),
            &Summary {
                roots_examined: report.roots_examined,
                left_pair_fibres: report.left_pair_fibres,
                left_pair_candidates: report.left_pair_candidates,
                distinct_left_pair_states: report.distinct_left_pair_states,
                right_pair_candidates: report.right_pair_candidates,
                quotient_profile_quadruples: report.quotient_profile_quadruples,
                raw_digit_quadruples: report.raw_digit_quadruples,
                minimum_root_profile_quadruples: report.minimum_root_profile_quadruples,
                maximum_root_profile_quadruples: report.maximum_root_profile_quadruples,
                minimum_root_digit_quadruples: report.minimum_root_digit_quadruples,
                maximum_root_digit_quadruples: report.maximum_root_digit_quadruples,
                provenance: report.provenance,
            },
        )?;
    }
    println!();
    Ok(())
}
