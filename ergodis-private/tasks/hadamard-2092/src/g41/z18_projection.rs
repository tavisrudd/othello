use std::collections::BTreeMap;

use anyhow::Result;
use clap::Args as ClapArgs;
use ergodis_private::hadamard_2092::CyclicMultiplierOrbitPartition;
use serde::Serialize;

const CARRIER: usize = 522;
const QUOTIENT: usize = 18;

#[derive(Serialize)]
struct Pattern {
    orbit_size: u8,
    orbit_count: u8,
    histogram: [u8; QUOTIENT],
}

#[derive(Serialize)]
struct GeneratorReport {
    generator: u16,
    patterns: Vec<Pattern>,
}

#[derive(ClapArgs)]
pub struct Arguments {}

pub fn run(_arguments: Arguments) -> Result<()> {
    let mut reports = Vec::new();
    for generator in [41_u16, 53, 91, 133] {
        let partition =
            CyclicMultiplierOrbitPartition::compile(CARRIER as u32, u32::from(generator))?;
        let mut patterns = BTreeMap::<(u8, [u8; QUOTIENT]), u8>::new();
        for orbit in 0..partition.orbit_count() as usize {
            let representative = partition.representatives()[orbit] as usize;
            let mut point = representative;
            let mut histogram = [0_u8; QUOTIENT];
            let mut size = 0_u8;
            loop {
                histogram[point % QUOTIENT] += 1;
                size += 1;
                point = point * usize::from(generator) % CARRIER;
                if point == representative {
                    break;
                }
            }
            *patterns.entry((size, histogram)).or_default() += 1;
        }
        reports.push(GeneratorReport {
            generator,
            patterns: patterns
                .into_iter()
                .map(|((orbit_size, histogram), orbit_count)| Pattern {
                    orbit_size,
                    orbit_count,
                    histogram,
                })
                .collect(),
        });
    }
    serde_json::to_writer(std::io::stdout(), &reports)?;
    println!();
    Ok(())
}
