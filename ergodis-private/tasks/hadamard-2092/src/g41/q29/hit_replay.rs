use anyhow::Result;
use clap::Args as ClapArgs;
use ergodis_private::g41_q29_evolve::{replay_g41_q29_selection, G41Q29Selection};

#[derive(ClapArgs)]
pub struct Arguments {}

const SELECTION: G41Q29Selection = G41Q29Selection {
    root_id: 3_494_740,
    digits: [2_215_340, 1_953_396, 1_957_340, 1_958_308],
    orbit_masks: [
        29, 109, 6_321, 134, 998, 5_663, 23, 111, 10_165, 208, 8_311, 5_655, 29, 13, 12_721, 7_183,
        375, 5_655, 29, 45, 6_321, 5_527, 8_566, 5_271,
    ],
};

pub fn run(_arguments: Arguments) -> Result<()> {
    let report = replay_g41_q29_selection(SELECTION)?;
    serde_json::to_writer(std::io::stdout(), &report)?;
    println!();
    Ok(())
}
