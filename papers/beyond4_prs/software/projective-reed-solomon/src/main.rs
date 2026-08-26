use clap::{Parser, Subcommand};
use projective_reed_solomon::{
    canonicalize_syndrome, classify, search_exact_locator, verify_certificate,
    verify_deep_certificate, DeepCertificate, LocatorCertificate, Request, CANONICALIZATION_SCHEMA,
    CERTIFICATE_SCHEMA, CLASSIFICATION_SCHEMA, DEEP_CERTIFICATE_SCHEMA, VERIFICATION_SCHEMA,
};
use std::fs;
use std::io::{self, Read};
use std::path::PathBuf;
use std::process::ExitCode;

#[derive(Parser)]
#[command(
    name = "projective-reed-solomon",
    version,
    about = "Proof-carrying tools for full-length projective Reed--Solomon syndromes",
    long_about = "Compute exact structural and coding data for full-length projective \
Reed--Solomon syndromes over explicitly represented finite fields.\n\n\
Structural canonicalization is available beyond the paper's classification range. \
Positive deep-hole verdicts remain fail-closed: they require a matching theorem-domain \
entry and carry a certificate that `verify` replays independently.",
    after_help = "Start here:\n  \
projective-reed-solomon classify examples/tangent-r5-f7.json\n  \
projective-reed-solomon canonicalize request.json\n  \
cat certificate.json | projective-reed-solomon verify\n\n\
Requests, result envelopes, and certificates use versioned JSON schemas. See README.md and docs/cli.md for the trust boundary."
)]
struct Cli {
    /// Maximum locator or transporter candidates examined by a bounded search.
    #[arg(
        long,
        visible_alias = "limit",
        global = true,
        default_value_t = 10_000_000
    )]
    candidate_limit: u64,

    /// Emit compact rather than pretty-printed JSON.
    #[arg(short, long, global = true)]
    compact: bool,

    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    /// Compute a semilinear canonical form and transporter without a coding verdict.
    ///
    /// This structural operation accepts every r >= 5 with q >= r. It never
    /// promotes a canonical form to a deep-hole classification.
    Canonicalize(SearchArgs),

    /// Compute exact distance and emit a replayable nearest-error certificate.
    ///
    /// Searches locator degrees in increasing order. The certificate records
    /// its split support and nonzero magnitudes so `verify` can replay it.
    Distance(SearchArgs),

    /// Recover a nearest error pattern and emit its replayable certificate.
    ///
    /// Returns the same exact locator certificate as `distance`; its support
    /// and magnitudes are the decoded nearest error pattern.
    Decode(SearchArgs),

    /// Apply the fail-closed theorem registry and emit a structural verdict.
    ///
    /// A DEEP result includes an independently replayable positive certificate.
    /// Unsupported or unresolved routes never receive one.
    Classify(SearchArgs),

    /// Replay a locator or positive deep certificate.
    ///
    /// Recomputes the arithmetic witness, transporter, family route, and frozen
    /// theorem-domain lookup. Success prints {"status":"VALID"}.
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

fn print_versioned_json<T: serde::Serialize>(
    schema: &str,
    value: &T,
    compact: bool,
) -> Result<(), Box<dyn std::error::Error>> {
    let mut value = serde_json::to_value(value)?;
    let object = value
        .as_object_mut()
        .ok_or("versioned JSON result must serialize as an object")?;
    object.insert("schema".into(), serde_json::Value::String(schema.into()));
    print_json(&value, compact)?;
    Ok(())
}

fn run() -> Result<(), Box<dyn std::error::Error>> {
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
            print_json(
                &serde_json::json!({
                    "schema": VERIFICATION_SCHEMA,
                    "status": "VALID"
                }),
                cli.compact,
            )?;
        }
        Command::Distance(args) | Command::Decode(args) => {
            let request: Request = serde_json::from_str(&read_input(&args.input.input)?)?;
            let certificate = search_exact_locator(&request, cli.candidate_limit)?;
            print_json(&certificate, cli.compact)?;
        }
        Command::Classify(args) => {
            let request: Request = serde_json::from_str(&read_input(&args.input.input)?)?;
            let result = classify(&request, cli.candidate_limit, cli.candidate_limit)?;
            print_versioned_json(CLASSIFICATION_SCHEMA, &result, cli.compact)?;
        }
        Command::Canonicalize(args) => {
            let request: Request = serde_json::from_str(&read_input(&args.input.input)?)?;
            let result = canonicalize_syndrome(&request, cli.candidate_limit)?;
            print_versioned_json(CANONICALIZATION_SCHEMA, &result, cli.compact)?;
        }
    }
    Ok(())
}

fn main() -> ExitCode {
    match run() {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("error: {error}");
            ExitCode::from(2)
        }
    }
}
