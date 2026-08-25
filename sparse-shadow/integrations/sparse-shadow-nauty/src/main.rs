use std::{env, fs, process::ExitCode};

use sparse_shadow_core::InputArtifact;

fn main() -> ExitCode {
    match run() {
        Ok(json) => {
            println!("{json}");
            ExitCode::SUCCESS
        }
        Err(error) => {
            eprintln!("sparse-shadow-nauty: {error}");
            ExitCode::FAILURE
        }
    }
}

fn run() -> Result<String, Box<dyn std::error::Error>> {
    let path = env::args()
        .nth(1)
        .ok_or("usage: sparse-shadow-nauty INPUT.json")?;
    let input: InputArtifact = serde_json::from_slice(&fs::read(path)?)?;
    Ok(serde_json::to_string(&sparse_shadow_nauty::cross_check(
        &input,
    )?)?)
}
