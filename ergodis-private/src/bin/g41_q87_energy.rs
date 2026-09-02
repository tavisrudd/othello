use anyhow::Result;
use ergodis_private::g41_q87_energy::{compile_g41_q87_energy_support, G41Q87EnergyReport};
use serde::Serialize;

const MASKS: [u8; 4] = [20, 13, 21, 13];
const DIGITS: [u32; 4] = [2_215_340, 1_953_396, 1_957_340, 1_958_308];
const COEFFICIENTS: [[u8; 8]; 4] = [
    [8, 9, 7, 10, 9, 5, 11, 12],
    [5, 8, 12, 10, 10, 8, 9, 7],
    [9, 9, 9, 9, 10, 9, 10, 7],
    [5, 10, 8, 5, 9, 12, 14, 6],
];
const TARGET: usize = 523;

#[derive(Serialize)]
struct Report {
    blocks: [G41Q87EnergyReport; 4],
    raw_energy_quartets: u64,
    compatible_energy_quartets: Vec<[u16; 4]>,
    coefficient_quadruple_excluded: bool,
    provenance: &'static str,
}

fn values(report: &G41Q87EnergyReport) -> Vec<usize> {
    (0..=TARGET)
        .filter(|&energy| report.energy_support[energy / 64] & (1_u64 << (energy % 64)) != 0)
        .collect()
}

fn main() -> Result<()> {
    let blocks: [G41Q87EnergyReport; 4] = (0..4)
        .map(|block| {
            compile_g41_q87_energy_support(MASKS[block], DIGITS[block], COEFFICIENTS[block])
        })
        .collect::<Result<Vec<_>, _>>()?
        .try_into()
        .map_err(|_| anyhow::anyhow!("q87 block count changed"))?;
    let energies: [Vec<usize>; 4] = std::array::from_fn(|block| values(&blocks[block]));
    let mut compatible_energy_quartets = Vec::new();
    for &first in &energies[0] {
        for &second in &energies[1] {
            for &third in &energies[2] {
                let Some(fourth) = TARGET.checked_sub(first + second + third) else {
                    continue;
                };
                if energies[3].binary_search(&fourth).is_ok() {
                    compatible_energy_quartets.push([
                        first as u16,
                        second as u16,
                        third as u16,
                        fourth as u16,
                    ]);
                }
            }
        }
    }
    let raw_energy_quartets = energies.iter().map(|values| values.len() as u64).product();
    let coefficient_quadruple_excluded = compatible_energy_quartets.is_empty();
    serde_json::to_writer(
        std::io::stdout(),
        &Report {
            blocks,
            raw_energy_quartets,
            compatible_energy_quartets,
            coefficient_quadruple_excluded,
            provenance: "four concrete interface-derived marginal three-lift Eisenstein energy supports; exact four-block target sum 523; cross-coordinate and cross-modulus correlations are deliberately absent",
        },
    )?;
    println!();
    Ok(())
}
