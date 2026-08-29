use ergodis::sat::{certify_coloring_clique_unsat, StructuredSatError};
use serde_json::json;
use std::io::Write;
use std::process::{Command, ExitCode};
use std::time::Instant;

fn main() -> anyhow::Result<ExitCode> {
    let mut arguments = std::env::args().skip(1);
    let kissat = arguments
        .next()
        .ok_or_else(|| anyhow::anyhow!("missing Kissat path"))?;
    let cnf = arguments
        .next()
        .ok_or_else(|| anyhow::anyhow!("missing CNF path"))?;
    if arguments.next().is_some() {
        anyhow::bail!("usage: cnf_theorem_or_kissat KISSAT INSTANCE.cnf");
    }

    let theorem_start = Instant::now();
    match certify_coloring_clique_unsat(&cnf) {
        Ok(Some(certificate)) => {
            let elapsed_ns = theorem_start.elapsed().as_nanos();
            println!(
                "c ergodis theorem=coloring-clique clique={} colors={} elapsed_ns={}",
                certificate.clique_vertices.len(),
                certificate.colors,
                elapsed_ns
            );
            serde_json::to_writer(
                std::io::stdout().lock(),
                &json!({
                    "status": "unsat",
                    "theorem": "a clique requires pairwise-distinct colors",
                    "variables": certificate.variables,
                    "clauses": certificate.clauses,
                    "vertices": certificate.vertices,
                    "colors": certificate.colors,
                    "clique_vertices": certificate.clique_vertices,
                    "elapsed_ns": elapsed_ns,
                }),
            )?;
            std::io::stdout().lock().write_all(b"\n")?;
            println!("s UNSATISFIABLE");
            Ok(ExitCode::from(20))
        }
        Ok(None)
        | Err(
            StructuredSatError::Encoding | StructuredSatError::Width | StructuredSatError::Capacity,
        ) => {
            eprintln!(
                "c ergodis theorem_miss_ns={}",
                theorem_start.elapsed().as_nanos()
            );
            let status = Command::new(kissat).arg("--quiet").arg(cnf).status()?;
            let code = status
                .code()
                .and_then(|code| u8::try_from(code).ok())
                .unwrap_or(1);
            Ok(ExitCode::from(code))
        }
        Err(error) => Err(error.into()),
    }
}
