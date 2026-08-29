use ergodis::sat::certify_coloring_clique_unsat;
use serde_json::json;
use std::time::Instant;

fn main() -> anyhow::Result<()> {
    let path = std::env::args()
        .nth(1)
        .ok_or_else(|| anyhow::anyhow!("usage: vlsat_clique_certificate INSTANCE.cnf"))?;
    let start = Instant::now();
    let certificate = certify_coloring_clique_unsat(path)?
        .ok_or_else(|| anyhow::anyhow!("no coloring-clique obstruction found"))?;
    let elapsed_ns = start.elapsed().as_nanos();
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
    println!();
    Ok(())
}
