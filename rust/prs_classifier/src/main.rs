use clap::{Parser, Subcommand};
use prs_classifier::{search_locator, verify_certificate, LocatorCertificate, Request};
use serde::Serialize;
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
    #[arg(long)]
    max_degree: Option<usize>,
    #[arg(long, default_value_t = 10_000_000)]
    candidate_limit: u64,
}

#[derive(Serialize)]
struct PartialResult<'a> {
    status: &'a str,
    note: &'a str,
    certificate: LocatorCertificate,
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
            let certificate: LocatorCertificate = serde_json::from_str(&read_input(&input)?)?;
            verify_certificate(&certificate)?;
            println!("{{\"status\":\"VALID\"}}");
        }
        Command::Distance(args) | Command::Decode(args) => {
            let request: Request = serde_json::from_str(&read_input(&args.input)?)?;
            let max_degree = args
                .max_degree
                .unwrap_or(request.redundancy.saturating_sub(2));
            let certificate = search_locator(&request, max_degree, args.candidate_limit)?;
            println!("{}", serde_json::to_string_pretty(&certificate)?);
        }
        Command::Classify(args) | Command::Canonicalize(args) => {
            let request: Request = serde_json::from_str(&read_input(&args.input)?)?;
            let max_degree = args
                .max_degree
                .unwrap_or(request.redundancy.saturating_sub(2));
            let certificate = search_locator(&request, max_degree, args.candidate_limit)?;
            let result = PartialResult {
                status: "NOT_DEEP",
                note: "witness-backed shallow verdict; structural deep-family adapters are not yet enabled",
                certificate,
            };
            println!("{}", serde_json::to_string_pretty(&result)?);
        }
    }
    Ok(())
}
