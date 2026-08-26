use clap::{Parser, Subcommand};
use projective_reed_solomon::{
    canonicalize_syndrome, classify, search_exact_locator, verify_certificate,
    verify_deep_certificate, DeepCertificate, LocatorCertificate, Request, CERTIFICATE_SCHEMA,
    DEEP_CERTIFICATE_SCHEMA,
};
use std::fs;
use std::io::{self, Read};
use std::path::PathBuf;

#[derive(Parser)]
#[command(
    name = "projective-reed-solomon",
    version,
    about = "Exact tools for full-length projective Reed--Solomon syndromes"
)]
struct Cli {
    /// Maximum locator or transporter candidates examined by a bounded search.
    #[arg(long, global = true, default_value_t = 10_000_000)]
    candidate_limit: u64,

    /// Emit compact rather than pretty-printed JSON.
    #[arg(long, global = true)]
    compact: bool,

    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    /// Compute exact distance and emit a replayable nearest-error certificate.
    Distance(SearchArgs),
    /// Recover a nearest error pattern and emit its replayable certificate.
    Decode(SearchArgs),
    /// Apply the fail-closed theorem registry and emit a structural verdict.
    Classify(SearchArgs),
    /// Compute a semilinear canonical form and transporter without a coding verdict.
    Canonicalize(SearchArgs),
    /// Replay a locator or positive deep certificate.
    #[command(visible_alias = "verify-certificate")]
    Verify(InputArgs),
}

#[derive(clap::Args)]
struct SearchArgs {
    #[command(flatten)]
    input: InputArgs,
}

#[derive(clap::Args)]
struct InputArgs {
    /// JSON input file; reads standard input when omitted.
    #[arg(value_name = "FILE")]
    input: Option<PathBuf>,
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

fn print_json<T: serde::Serialize>(value: &T, compact: bool) -> Result<(), serde_json::Error> {
    if compact {
        println!("{}", serde_json::to_string(value)?);
    } else {
        println!("{}", serde_json::to_string_pretty(value)?);
    }
    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let cli = Cli::parse();
    match cli.command {
        Command::Verify(args) => {
            let input = read_input(&args.input)?;
            let value: serde_json::Value = serde_json::from_str(&input)?;
            match value.get("schema").and_then(serde_json::Value::as_str) {
                Some(CERTIFICATE_SCHEMA) => {
                    verify_certificate(&serde_json::from_value::<LocatorCertificate>(value)?)?;
                }
                Some(DEEP_CERTIFICATE_SCHEMA) => {
                    verify_deep_certificate(
                        &serde_json::from_value::<DeepCertificate>(value)?,
                        cli.candidate_limit,
                    )?;
                }
                _ => return Err("unsupported certificate schema".into()),
            }
            println!("{{\"status\":\"VALID\"}}");
        }
        Command::Distance(args) | Command::Decode(args) => {
            let request: Request = serde_json::from_str(&read_input(&args.input.input)?)?;
            let certificate = search_exact_locator(&request, cli.candidate_limit)?;
            print_json(&certificate, cli.compact)?;
        }
        Command::Classify(args) => {
            let request: Request = serde_json::from_str(&read_input(&args.input.input)?)?;
            let result = classify(&request, cli.candidate_limit, cli.candidate_limit)?;
            print_json(&result, cli.compact)?;
        }
        Command::Canonicalize(args) => {
            let request: Request = serde_json::from_str(&read_input(&args.input.input)?)?;
            let result = canonicalize_syndrome(&request, cli.candidate_limit)?;
            print_json(&result, cli.compact)?;
        }
    }
    Ok(())
}
