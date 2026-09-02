use anyhow::{ensure, Context, Result};
use ergodis_private::g41_q87_energy::{issue_g41_q87_energy_proof, Q87_ENERGY_WORDS};
use ergodis_private::g41_q87_exact_energy::{
    census_g41_q87_exact_energies, census_g41_q87_reachable_energy_vectors,
    issue_g41_q87_exact_lift_proof,
};

const MASKS: [u8; 4] = [20, 13, 21, 13];
const DIGITS: [u32; 4] = [2_215_340, 1_953_396, 1_957_340, 1_958_308];
const COEFFICIENTS: [[u8; 8]; 4] = [
    [8, 9, 7, 10, 9, 5, 11, 12],
    [5, 8, 12, 10, 10, 8, 9, 7],
    [9, 9, 9, 9, 10, 9, 10, 7],
    [5, 10, 8, 5, 9, 12, 14, 6],
];

fn main() -> Result<()> {
    let argument = std::env::args()
        .nth(1)
        .context("expected one block index in 0..4 or proof")?;
    if argument == "proof" {
        let proof = issue_g41_q87_exact_lift_proof(MASKS, DIGITS, COEFFICIENTS)?;
        serde_json::to_writer(std::io::stdout(), &proof)?;
        println!();
        return Ok(());
    }
    if let Some(block) = argument.strip_prefix("vectors") {
        let block = block.parse::<usize>()?;
        ensure!(block < 4, "block index must be in 0..4");
        let report = census_g41_q87_reachable_energy_vectors(
            MASKS[block],
            DIGITS[block],
            COEFFICIENTS[block],
        )?;
        serde_json::to_writer(std::io::stdout(), &report)?;
        println!();
        return Ok(());
    }
    let block = argument.parse::<usize>()?;
    ensure!(block < 4, "block index must be in 0..4");
    let proof = issue_g41_q87_energy_proof(MASKS, DIGITS, COEFFICIENTS)?;
    let (bases, step, total_defect) = proof.energy_normal_form();
    let mut requested = [0_u64; Q87_ENERGY_WORDS];
    for defect in 0..=total_defect {
        let energy = usize::from(bases[block] + step * defect);
        requested[energy / 64] |= 1_u64 << (energy % 64);
    }
    let report =
        census_g41_q87_exact_energies(MASKS[block], DIGITS[block], COEFFICIENTS[block], requested)?;
    serde_json::to_writer(std::io::stdout(), &report)?;
    println!();
    Ok(())
}
