//! Per-order certificate generation: verify, classify, optionally compute the automorphism
//! group, and write one JSON record per matrix.

use anyhow::{Context, Result};
use serde::Serialize;
use serde_json::json;
use sha2::{Digest, Sha256};
use std::path::{Path, PathBuf};

use crate::classify::classify;
use crate::graph::{run_autgroup_engine, Invariant};
use crate::matrix::{parse, ParseOpts};

#[derive(Serialize)]
pub struct Certificate {
    pub n: usize,
    pub source_file: String,
    /// SHA-256 of the input file exactly as it sits on disk.
    pub sha256_source_file: String,
    /// SHA-256 of the canonical `+`/`-` text of the matrix as given.
    pub sha256_canonical_as_given: String,
    /// SHA-256 of the canonical `+`/`-` text after dephasing.
    pub sha256_canonical_normalized: String,
    pub square: bool,
    pub entries_pm1: bool,
    /// `max |(H H^T)_{ij}|` over `i != j`. Zero exactly when the matrix is Hadamard.
    pub max_abs_offdiag: i64,
    pub is_hadamard: bool,
    pub row_sum_multiset: Vec<(i64, usize)>,
    pub classification: serde_json::Value,
    pub automorphism: serde_json::Value,
    pub tool_version: String,
}

fn sha256_file(p: &Path) -> Result<String> {
    let bytes = std::fs::read(p).with_context(|| format!("reading {}", p.display()))?;
    let mut h = Sha256::new();
    h.update(&bytes);
    Ok(format!("{:x}", h.finalize()))
}

pub struct CertifyOpts<'a> {
    pub outdir: &'a Path,
    pub workdir: &'a Path,
    pub with_aut: bool,
    pub invariant: Option<Invariant>,
    pub traces: bool,
    pub profile_colour: bool,
    pub aut_timeout_secs: Option<u64>,
}

pub fn certify_one(file: &Path, opts: &CertifyOpts) -> Result<Certificate> {
    let text = std::fs::read_to_string(file).with_context(|| format!("reading {file:?}"))?;
    let (m, _) = parse(&text, &ParseOpts::default())?;

    let cells = if opts.with_aut && opts.profile_colour {
        Some(crate::profile_cells(&m))
    } else {
        None
    };
    let aut = if opts.with_aut {
        match run_autgroup_engine(
            &m,
            true,
            true,
            opts.invariant,
            opts.traces,
            cells.as_deref(),
            opts.workdir,
            false,
            opts.aut_timeout_secs.map(std::time::Duration::from_secs),
        ) {
            Ok(a) => Some(a),
            Err(e) => {
                eprintln!("  automorphism group for n = {}: {e}", m.n);
                None
            }
        }
    } else {
        None
    };
    let aut_failed = opts.with_aut && aut.is_none();

    let rep = classify(&m, aut.clone());

    // The proved, solver-free part of the automorphism group: block-shift automorphisms
    // certified by dephasing equality. Present whether or not nauty was run.
    let proved_shift = rep
        .tests
        .iter()
        .find(|t| t.found && t.name.starts_with("gs_array"))
        .and_then(|t| t.detail.get("shift_automorphisms").cloned())
        .unwrap_or(serde_json::Value::Null);

    let solver = match &aut {
        Some(a) => json!({
            "computed": true,
            "graph_vertices": a.graph_vertices,
            "colored_row_col": a.colored_row_col,
            "aut_graph_order": a.aut_graph_order_raw,
            "aut_graph_order_is_approx": a.aut_graph_order_is_approx,
            "hadamard_aut_order_mod_center": a.hadamard_aut_order_mod_center,
            "num_generators": a.num_generators,
            "num_orbits": a.num_orbits,
            "orbit_sizes": a.orbit_sizes,
            "cyclic_structure_found": a.cyclic_structure_found,
            "initial_colouring": if opts.profile_colour {
                "4-profile invariant (rows and columns coloured by the multiset of |J| over \
                 quadruples); without it neither nauty nor Traces finishes at this order"
            } else {
                "row/column split only"
            },
        }),
        None if aut_failed => json!({
            "computed": false,
            "reason": format!(
                "nauty did not finish within the {} s budget. The 4n-vertex Hadamard graph is \
                 regular and bipartite, so refinement never splits a cell unaided; when the \
                 automorphism group is small this becomes a deep individualization search.",
                opts.aut_timeout_secs.unwrap_or(0)
            ),
        }),
        None => json!({
            "computed": false,
            "reason": "not run. At these orders the 4n-vertex Hadamard graph defeats both dense \
                       nauty and Traces within a safe budget; see ../certificate/README.md. The \
                       proved_shift_subgroup field below is exact and needs no solver."
        }),
    };
    let automorphism = json!({
        "solver": solver,
        "proved_shift_subgroup": proved_shift,
    });

    // Keep the classification record compact: the matched form plus the full test ledger of
    // what was tried and what it returned.
    let classification = json!({
        "forms_found": rep.forms_found,
        "primary_form": rep.tests.iter()
            .find(|t| t.found && t.name.starts_with("gs_array"))
            .and_then(|t| t.variant.clone()),
        "tests": rep.tests,
    });

    let cert = Certificate {
        n: m.n,
        source_file: file
            .file_name()
            .map(|s| s.to_string_lossy().to_string())
            .unwrap_or_default(),
        sha256_source_file: sha256_file(file)?,
        sha256_canonical_as_given: m.sha256_canonical(),
        sha256_canonical_normalized: rep.sha256_canonical_normalized.clone(),
        square: m.is_square(),
        entries_pm1: true,
        max_abs_offdiag: rep.max_abs_offdiag,
        is_hadamard: rep.verified_hadamard,
        row_sum_multiset: {
            let mut sums = m.row_sums();
            sums.sort_unstable();
            let mut ms: Vec<(i64, usize)> = Vec::new();
            for s in sums {
                match ms.last_mut() {
                    Some(l) if l.0 == s => l.1 += 1,
                    _ => ms.push((s, 1)),
                }
            }
            ms
        },
        classification,
        automorphism,
        tool_version: format!("had668 {}", env!("CARGO_PKG_VERSION")),
    };

    std::fs::create_dir_all(opts.outdir)?;
    let out: PathBuf = opts.outdir.join(format!("H{}.json", cert.n));
    std::fs::write(&out, serde_json::to_string_pretty(&cert)? + "\n")?;
    Ok(cert)
}

pub fn run(files: &[String], opts: &CertifyOpts) -> Result<bool> {
    let mut all_ok = true;
    println!(
        "{:>6}  {:>10}  {:>8}  {:<58}  {}",
        "n", "hadamard", "max|off|", "structure", "|Aut(graph)|"
    );
    let mut certs = Vec::new();
    for f in files {
        let p = PathBuf::from(f);
        let c = certify_one(&p, opts)?;
        if !c.is_hadamard {
            all_ok = false;
        }
        let form = c.classification["primary_form"]
            .as_str()
            .unwrap_or("(no known form matched)")
            .to_string();
        let aut = c.automorphism["solver"]["aut_graph_order"]
            .as_str()
            .map(|s| s.to_string())
            .unwrap_or_else(|| "not computed".into());
        println!(
            "{:>6}  {:>10}  {:>8}  {:<58}  {}",
            c.n,
            if c.is_hadamard { "yes" } else { "NO" },
            c.max_abs_offdiag,
            form,
            aut
        );
        certs.push(c);
    }
    println!("\nwrote {} certificates to {}", certs.len(), opts.outdir.display());
    Ok(all_ok)
}
