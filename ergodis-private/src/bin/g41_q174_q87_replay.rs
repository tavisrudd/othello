use anyhow::{ensure, Result};
use ergodis_private::g41_q174_joint::replay_g41_q174_q87_defects;

fn main() -> Result<()> {
    let states = std::env::args()
        .skip(1)
        .map(|argument| argument.parse::<u128>())
        .collect::<Result<Vec<_>, _>>()?;
    ensure!(states.len() == 4, "expected four packed q174 states");
    let report = replay_g41_q174_q87_defects(states.try_into().expect("length checked"))?;
    serde_json::to_writer(std::io::stdout(), &report)?;
    println!();
    Ok(())
}
