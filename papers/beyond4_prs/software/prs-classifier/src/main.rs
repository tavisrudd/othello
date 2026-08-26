use clap::{Parser, Subcommand};
use prs_classifier::{
    canonicalize_syndrome, classify, search_exact_locator, verify_certificate,
    verify_deep_certificate, DeepCertificate, LocatorCertificate, Request, CERTIFICATE_SCHEMA,
    DEEP_CERTIFICATE_SCHEMA,
};
use std::fs;
use std::io::{self, Read};
use std::path::PathBuf;

#[derive(Parser)]
#[command(name = "prs-classifier", version, about)]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    Distance(SearchArgs),
    Decode(SearchArgs),
    Classify(SearchArgs),
    Canonicalize(SearchArgs),
    VerifyCertificate { input: Option<PathBuf> },
}

#[derive(clap::Args)]
struct SearchArgs {
    input: Option<PathBuf>,
    #[arg(long, default_value_t = 10_000_000)]
    candidate_limit: u64,
}

fn read_input(path: &Option<PathBuf>) -> Result<String, Box<dyn std::error::Error>> {
    if let Some(path) = path {
        Ok(fs::read_to_string(path)?)
    } else {
        let mut input = String::new();
        io::stdin().read_to_string(&mut input)?;
        Ok(input)
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let cli = Cli::parse();
    match cli.command {
        Command::VerifyCertificate { input } => {
            let input = read_input(&input)?;
            let value: serde_json::Value = serde_json::from_str(&input)?;
            match value.get("schema").and_then(serde_json::Value::as_str) {
                Some(CERTIFICATE_SCHEMA) => {
                    verify_certificate(&serde_json::from_value::<LocatorCertificate>(value)?)?;
                }
                Some(DEEP_CERTIFICATE_SCHEMA) => {
                    verify_deep_certificate(
                        &serde_json::from_value::<DeepCertificate>(value)?,
                        10_000_000,
                    )?;
                }
                _ => return Err("unsupported certificate schema".into()),
            }
            println!("{{\"status\":\"VALID\"}}");
        }
        Command::Distance(args) | Command::Decode(args) => {
            let request: Request = serde_json::from_str(&read_input(&args.input)?)?;
            let certificate = search_exact_locator(&request, args.candidate_limit)?;
            println!("{}", serde_json::to_string_pretty(&certificate)?);
        }
        Command::Classify(args) => {
            let request: Request = serde_json::from_str(&read_input(&args.input)?)?;
            let result = classify(&request, args.candidate_limit, args.candidate_limit)?;
            println!("{}", serde_json::to_string_pretty(&result)?);
        }
        Command::Canonicalize(args) => {
            let request: Request = serde_json::from_str(&read_input(&args.input)?)?;
            let result = canonicalize_syndrome(&request, args.candidate_limit)?;
            println!("{}", serde_json::to_string_pretty(&result)?);
        }
    }
    Ok(())
}
