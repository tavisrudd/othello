use anyhow::{ensure, Context, Result};
use ergodis_private::g41_q174_joint::compile_g41_q174_joint_tablebase;

const MASKS: [u8; 4] = [20, 13, 21, 13];
const DIGITS: [u32; 4] = [2_215_340, 1_953_396, 1_957_340, 1_958_308];
const COEFFICIENTS: [[u8; 8]; 4] = [
    [8, 9, 7, 10, 9, 5, 11, 12],
    [5, 8, 12, 10, 10, 8, 9, 7],
    [9, 9, 9, 9, 10, 9, 10, 7],
    [5, 10, 8, 5, 9, 12, 14, 6],
];
const B1_MASKS: [u8; 4] = [20, 1, 21, 1];
const B1_DIGITS: [u32; 4] = [2_215_340, 2_203_361, 1_957_347, 2_218_467];
const B1_COEFFICIENTS: [[u8; 8]; 4] = [
    [8, 8, 10, 10, 9, 8, 10, 8],
    [1, 12, 6, 10, 7, 9, 11, 10],
    [9, 9, 9, 9, 10, 7, 10, 9],
    [1, 5, 15, 9, 10, 8, 9, 9],
];

fn main() -> Result<()> {
    let mut args = std::env::args().skip(1);
    let block = args
        .next()
        .context("expected block index in 0..4")?
        .parse::<usize>()?;
    ensure!(block < 4, "block index must be in 0..4");
    let middle_small = args.next().map_or(Ok(5_u8), |value| value.parse::<u8>())?;
    let (masks, digits, coefficients) = match middle_small {
        1 => (B1_MASKS, B1_DIGITS, B1_COEFFICIENTS),
        5 => (MASKS, DIGITS, COEFFICIENTS),
        _ => anyhow::bail!("middle-small must be 1 or 5"),
    };
    let table = compile_g41_q174_joint_tablebase(masks[block], digits[block], coefficients[block])?;
    serde_json::to_writer(std::io::stdout(), &table.report)?;
    println!();
    Ok(())
}
