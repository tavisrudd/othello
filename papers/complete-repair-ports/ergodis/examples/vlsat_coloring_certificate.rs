use ergodis::sat::certify_multipartite_coloring_unsat;
use serde_json::json;
use std::time::Instant;

fn main() -> anyhow::Result<()> {
    let path = std::env::args()
        .nth(1)
        .ok_or_else(|| anyhow::anyhow!("usage: vlsat_coloring_certificate INSTANCE.cnf"))?;
    let start = Instant::now();
    let certificate = certify_multipartite_coloring_unsat(path)?
        .ok_or_else(|| anyhow::anyhow!("no complete-multipartite coloring obstruction found"))?;
    let elapsed_ns = start.elapsed().as_nanos();
    serde_json::to_writer(
        std::io::stdout().lock(),
        &json!({
            "status": "unsat",
            "theorem": "complete multipartite chromatic number equals number of parts",
            "variables": certificate.variables,
            "clauses": certificate.clauses,
            "vertices": certificate.vertices,
            "colors": certificate.colors,
            "parts": certificate.parts.len(),
            "part_sizes": certificate.parts.iter().map(|part| part.count_ones()).collect::<Vec<_>>(),
            "clique_vertices": certificate.clique_vertices,
            "elapsed_ns": elapsed_ns,
        }),
    )?;
    println!();
    Ok(())
}
