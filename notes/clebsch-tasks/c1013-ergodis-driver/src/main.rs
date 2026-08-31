//! C1013/C1014 quadratic-character census front end over the ergodis kernel.
//!
//! Reads one request per stdin line and writes one JSON object per line.
//!
//!   census <label> <p> <c0> <c1> ...                 -> chi(f(x)) over all x in F_p
//!   twist  <label> <p> <b> <a> <c0> <c1> ...         -> chi((b + a x) f(x)) over F_p
//!
//! Coefficients are ascending, arbitrary (possibly negative) integers; they are
//! reduced once by `PrimeQuadraticCharacter::reduce_coefficients`.
//!
//! ergodis is used read-only, as a library, via
//! `ergodis::character_sum::PrimeQuadraticCharacter`.

use std::io::{self, BufRead, Write};

use ergodis::character_sum::PrimeQuadraticCharacter;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let stdin = io::stdin();
    let stdout = io::stdout();
    let mut out = stdout.lock();
    for line in stdin.lock().lines() {
        let line = line?;
        let line = line.trim();
        if line.is_empty() || line.starts_with('#') {
            continue;
        }
        let fields: Vec<&str> = line.split_whitespace().collect();
        let kind = fields[0];
        let label = fields[1];
        let p: u32 = fields[2].parse()?;
        let character = PrimeQuadraticCharacter::new(p)?;
        let (intercept, slope, coefficient_start) = match kind {
            "census" => (0_i128, 0_i128, 3_usize),
            "twist" => (fields[3].parse::<i128>()?, fields[4].parse::<i128>()?, 5_usize),
            other => return Err(format!("unknown request kind {other}").into()),
        };
        let raw: Vec<i128> = fields[coefficient_start..]
            .iter()
            .map(|value| value.parse::<i128>())
            .collect::<Result<_, _>>()?;
        let reduced = character.reduce_coefficients(&raw);
        let census = match kind {
            "census" => character.polynomial_census_reduced(&reduced)?,
            _ => {
                let modulus = i128::from(p);
                character.linear_twist_polynomial_census_reduced(
                    0..p,
                    &reduced,
                    intercept.rem_euclid(modulus) as u32,
                    slope.rem_euclid(modulus) as u32,
                )?
            }
        };
        writeln!(
            out,
            "{{\"label\":\"{label}\",\"kind\":\"{kind}\",\"p\":{p},\"positive\":{},\
             \"negative\":{},\"zero\":{},\"sum\":{}}}",
            census.positive(),
            census.negative(),
            census.zero(),
            census.sum()
        )?;
    }
    Ok(())
}
