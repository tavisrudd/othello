use anyhow::{ensure, Result};
use clap::Args as ClapArgs;
use ergodis_private::g41_q174_joint::replay_g41_q174_q87_defects;

#[derive(ClapArgs)]
pub struct Arguments {
    /// Four packed q174 states.
    states: Vec<u128>,
}

pub fn run(arguments: Arguments) -> Result<()> {
    let states = arguments.states;
    ensure!(states.len() == 4, "expected four packed q174 states");
    let report = replay_g41_q174_q87_defects(states.try_into().expect("length checked"))?;
    serde_json::to_writer(std::io::stdout(), &report)?;
    println!();
    Ok(())
}
