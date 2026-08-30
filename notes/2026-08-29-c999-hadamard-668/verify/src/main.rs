//! `had668` -- verification and structural classification of Hadamard matrices.
//!
//! Built for the order-668 matrix announced in August 2026, but every subcommand works at any
//! order and the `selftest` subcommand exercises them on independently known constructions.

mod certify;
mod classify;
mod construct;
mod graph;
mod invariant4;
mod matrix;
mod selftest;

use anyhow::{Context, Result};
use clap::{Args, Parser, Subcommand};
use std::path::PathBuf;

use matrix::{BitLayout, Format, ParseOpts};

#[derive(Parser)]
#[command(name = "had668", version, about = "Verify and classify Hadamard matrices")]
struct Cli {
    #[command(subcommand)]
    cmd: Cmd,
}

#[derive(Args, Clone)]
struct InputOpts {
    /// Input file. `-` reads standard input.
    file: String,
    /// Input format; `auto` sniffs the file.
    #[arg(long, value_enum, default_value = "auto")]
    format: Format,
    /// Row length, required for bit-packed input.
    #[arg(long)]
    n: Option<usize>,
    /// Which sign a `0` bit / `0` character denotes.
    #[arg(long, value_enum, default_value = "plus")]
    bit_zero_is: ZeroSign,
    /// Whether bit-packed rows are byte aligned.
    #[arg(long, value_enum, default_value = "contiguous")]
    bit_layout: BitLayout,
}

#[derive(Clone, Copy, PartialEq, Eq, clap::ValueEnum)]
enum ZeroSign {
    Plus,
    Minus,
}

impl InputOpts {
    fn parse_opts(&self) -> ParseOpts {
        ParseOpts {
            format: self.format,
            n: self.n,
            bit_zero_is_plus: self.bit_zero_is == ZeroSign::Plus,
            bit_layout: self.bit_layout,
        }
    }
    fn read(&self) -> Result<String> {
        if self.file == "-" {
            use std::io::Read;
            let mut s = String::new();
            std::io::stdin().read_to_string(&mut s)?;
            Ok(s)
        } else {
            std::fs::read_to_string(&self.file)
                .with_context(|| format!("reading {}", self.file))
        }
    }
}

/// bliss / DIMACS graph format: `p edge V E`, then `n <vertex> <colour>` (1-indexed), then
/// one `e u v` per edge. Same 4n graph and same colouring as the dreadnaut path, so a
/// disagreement between the two solvers would be a real disagreement.
fn write_bliss(m: &matrix::Matrix, cells: Option<&[Vec<usize>]>, out: &std::path::Path)
    -> Result<()> {
    use std::io::Write;
    let n = m.n;
    let nv = 4 * n;
    let mut colour = vec![0usize; nv];
    match cells {
        Some(cs) => {
            for (ci, cell) in cs.iter().enumerate() {
                for &v in cell {
                    colour[v] = ci;
                }
            }
        }
        None => {
            for v in (2 * n)..(4 * n) {
                colour[v] = 1;
            }
        }
    }
    let f = std::fs::File::create(out)?;
    let mut w = std::io::BufWriter::with_capacity(1 << 20, f);
    writeln!(w, "p edge {} {}", nv, 2 * n * n)?;
    for v in 0..nv {
        writeln!(w, "n {} {}", v + 1, colour[v])?;
    }
    for r in 0..n {
        for c in 0..n {
            let (a, b) = if m.rows[r][c] == 1 {
                (2 * n + c, 3 * n + c)
            } else {
                (3 * n + c, 2 * n + c)
            };
            writeln!(w, "e {} {}", r + 1, a + 1)?;
            writeln!(w, "e {} {}", n + r + 1, b + 1)?;
        }
    }
    w.flush()?;
    Ok(())
}

/// Cells of the 4-profile colouring, as vertex lists in the 4n graph. A row `r` contributes
/// `r` and `n+r` to its cell (an automorphism may negate a row, so `r+` and `r-` must share a
/// colour); a column `c` contributes `2n+c` and `3n+c`. Row cells never merge with column cells.
pub fn profile_cells(m: &matrix::Matrix) -> Vec<Vec<usize>> {
    let n = m.n;
    let p = invariant4::profile(m);
    let nrc = p.row_class_sizes.len();
    let mut cells: Vec<Vec<usize>> = vec![Vec::new(); nrc + p.col_class_sizes.len()];
    for r in 0..n {
        let c = &mut cells[p.row_class[r]];
        c.push(r);
        c.push(n + r);
    }
    for c in 0..n {
        let cell = &mut cells[nrc + p.col_class[c]];
        cell.push(2 * n + c);
        cell.push(3 * n + c);
    }
    cells
}

/// `size -> how many classes have that size`
fn size_hist(sizes: &[usize]) -> std::collections::BTreeMap<usize, usize> {
    let mut h = std::collections::BTreeMap::new();
    for &s in sizes {
        *h.entry(s).or_insert(0) += 1;
    }
    h
}

fn mk_inv(code: Option<u32>, levels: &Option<Vec<u32>>) -> Option<graph::Invariant> {
    code.map(|code| {
        let (lo, hi) = match levels {
            Some(v) if v.len() == 2 => (v[0], v[1]),
            _ => (0, 3),
        };
        graph::Invariant { code, lo, hi }
    })
}

fn default_workdir() -> PathBuf {
    std::env::var("HAD668_WORKDIR")
        .map(PathBuf::from)
        .unwrap_or_else(|_| PathBuf::from("/tmp/persistent/tavis/c999-work"))
}

#[derive(Subcommand)]
enum Cmd {
    /// Check that the input is a Hadamard matrix: square, +-1, and H H^T = n I exactly.
    Verify {
        #[command(flatten)]
        input: InputOpts,
    },
    /// Dephase (first row and column all `+`) and print the canonical `+`/`-` text form.
    Normalize {
        #[command(flatten)]
        input: InputOpts,
        /// Write to this file instead of standard output.
        #[arg(long)]
        out: Option<PathBuf>,
        /// Print the sha256 of the result on standard error.
        #[arg(long)]
        hash: bool,
    },
    /// Build the 4n-vertex Hadamard graph and hand it to nauty's `dreadnaut`.
    Autgroup {
        #[command(flatten)]
        input: InputOpts,
        /// Do not colour the row and column vertex classes; this admits transpose-type
        /// automorphisms as well.
        #[arg(long)]
        no_color: bool,
        /// Ask dreadnaut for the generators and analyse their cycle structure.
        #[arg(long, default_value_t = true)]
        generators: bool,
        /// Where the `.dre` file is written.
        #[arg(long)]
        workdir: Option<PathBuf>,
        /// Keep the generated `.dre` file.
        #[arg(long)]
        keep_graph: bool,
        /// Only write the `.dre` file and print its path.
        #[arg(long)]
        emit_only: bool,
        /// Write the graph in bliss/DIMACS format to this path and exit. Used to confirm the
        /// nauty result with an independent solver.
        #[arg(long)]
        emit_bliss: Option<PathBuf>,
        /// nauty vertex invariant code (`*=`), e.g. 1 = twopaths, 6 = cellquads.
        #[arg(long)]
        invariant: Option<u32>,
        /// nauty invariant levels (`k=lo hi`), default `0 3` when --invariant is given.
        #[arg(long, num_args = 2)]
        invar_levels: Option<Vec<u32>>,
        /// Use nauty's Traces engine. Required in practice at these orders.
        #[arg(long)]
        traces: bool,
        /// Refine the initial colouring by the 4-profile invariant. This is what makes the
        /// computation feasible at these orders.
        #[arg(long)]
        profile_colour: bool,
    },
    /// Test the known structural forms and report exactly what was tested.
    Classify {
        #[command(flatten)]
        input: InputOpts,
        /// Also run `autgroup` and use it for the semiregular-cyclic test.
        #[arg(long)]
        with_aut: bool,
        #[arg(long)]
        workdir: Option<PathBuf>,
        /// nauty vertex invariant code (`*=`), e.g. 1 = twopaths, 6 = cellquads.
        #[arg(long)]
        invariant: Option<u32>,
        /// nauty invariant levels (`k=lo hi`), default `0 3` when --invariant is given.
        #[arg(long, num_args = 2)]
        invar_levels: Option<Vec<u32>>,
        /// Use nauty's Traces engine. Required in practice at these orders.
        #[arg(long)]
        traces: bool,
        /// Refine the initial colouring by the 4-profile invariant.
        #[arg(long)]
        profile_colour: bool,
    },
    /// Build known Hadamard matrices and run the whole pipeline on them.
    Selftest {
        /// Write each constructed matrix here as a `.pm` file.
        #[arg(long)]
        outdir: Option<PathBuf>,
        /// Skip the automorphism group above this order.
        #[arg(long, default_value_t = 700)]
        aut_max_n: usize,
        #[arg(long)]
        workdir: Option<PathBuf>,
        /// Print the full JSON report instead of the table.
        #[arg(long)]
        json: bool,
    },
    /// Compute the 4-profile vertex invariant and report how far it splits rows and columns.
    Profile {
        #[command(flatten)]
        input: InputOpts,
        /// Write the row/column class vectors as JSON here.
        #[arg(long)]
        out: Option<PathBuf>,
    },
    /// Write a per-order certificate JSON for each input matrix.
    Certify {
        /// Matrix files.
        files: Vec<String>,
        /// Directory for the `H<n>.json` records.
        #[arg(long)]
        outdir: PathBuf,
        #[arg(long)]
        workdir: Option<PathBuf>,
        /// Also compute the automorphism group.
        #[arg(long)]
        with_aut: bool,
        /// Wall-clock budget per automorphism computation, in seconds.
        #[arg(long, default_value_t = 900)]
        aut_timeout: u64,
        /// nauty vertex invariant code (`*=`).
        #[arg(long)]
        invariant: Option<u32>,
        /// nauty invariant levels (`k=lo hi`).
        #[arg(long, num_args = 2)]
        invar_levels: Option<Vec<u32>>,
        /// Use nauty's Traces engine.
        #[arg(long)]
        traces: bool,
        /// Refine the initial colouring by the 4-profile invariant. Needed for --with-aut to
        /// finish at these orders.
        #[arg(long)]
        profile_colour: bool,
    },
    /// TODO: decode the poster's encoded +-1 string once the encoding is published.
    Decode {
        /// Free-form description of the encoding, e.g. `base64:contiguous:0=plus`.
        spec: String,
        /// The encoded payload, or a file containing it.
        #[arg(long)]
        input: Option<String>,
        /// Row length of the decoded matrix.
        #[arg(long)]
        n: Option<usize>,
    },
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    match cli.cmd {
        Cmd::Verify { input } => {
            let text = input.read()?;
            let rep = matrix::verify_report(&input.file, &text, &input.parse_opts())?;
            println!("{}", serde_json::to_string_pretty(&rep)?);
            if !rep.pass {
                std::process::exit(1);
            }
        }
        Cmd::Normalize { input, out, hash } => {
            let text = input.read()?;
            let (m, _) = matrix::parse(&text, &input.parse_opts())?;
            let d = m.dephase();
            let canon = d.canonical_text();
            if hash {
                eprintln!("sha256 {}", d.sha256_canonical());
            }
            match out {
                Some(p) => std::fs::write(p, canon)?,
                None => print!("{canon}"),
            }
        }
        Cmd::Autgroup {
            input,
            no_color,
            generators,
            workdir,
            keep_graph,
            emit_only,
            invariant,
            invar_levels,
            traces,
            profile_colour,
            emit_bliss,
        } => {
            let inv = mk_inv(invariant, &invar_levels);
            let text = input.read()?;
            let (m, _) = matrix::parse(&text, &input.parse_opts())?;
            let wd = workdir.unwrap_or_else(default_workdir);
            let cells = if profile_colour {
                Some(profile_cells(&m))
            } else {
                None
            };
            if let Some(bp) = emit_bliss {
                write_bliss(&m, cells.as_deref(), &bp)?;
                println!("{}", bp.display());
                return Ok(());
            }
            if emit_only {
                std::fs::create_dir_all(&wd)?;
                let p = wd.join(format!("had{}.dre", m.n));
                graph::write_dreadnaut_full(
                    &m, !no_color, generators, inv, traces, cells.as_deref(), &p,
                )?;
                println!("{}", p.display());
                return Ok(());
            }
            let rep = graph::run_autgroup_engine(
                &m, !no_color, generators, inv, traces, cells.as_deref(), &wd, keep_graph, None,
            )?;
            println!("{}", serde_json::to_string_pretty(&rep)?);
        }
        Cmd::Classify {
            input,
            with_aut,
            workdir,
            invariant,
            invar_levels,
            traces,
            profile_colour,
        } => {
            let inv = mk_inv(invariant, &invar_levels);
            let text = input.read()?;
            let (m, _) = matrix::parse(&text, &input.parse_opts())?;
            let wd = workdir.unwrap_or_else(default_workdir);
            let aut = if with_aut {
                Some(graph::run_autgroup_engine(
                    &m,
                    true,
                    true,
                    inv,
                    traces,
                    if profile_colour { Some(profile_cells(&m)) } else { None }.as_deref(),
                    &wd,
                    false,
                    None,
                )?)
            } else {
                None
            };
            let rep = classify::classify(&m, aut);
            println!("{}", serde_json::to_string_pretty(&rep)?);
        }
        Cmd::Selftest {
            outdir,
            aut_max_n,
            workdir,
            json,
        } => {
            let wd = workdir.unwrap_or_else(default_workdir);
            let rep = selftest::run(outdir.as_deref(), aut_max_n, &wd)?;
            if json {
                println!("{}", serde_json::to_string_pretty(&rep)?);
            } else {
                print_selftest(&rep);
            }
            if !rep.all_pass {
                std::process::exit(1);
            }
        }
        Cmd::Profile { input, out } => {
            let text = input.read()?;
            let (m, _) = matrix::parse(&text, &input.parse_opts())?;
            let t0 = std::time::Instant::now();
            let p = invariant4::profile(&m);
            let secs = t0.elapsed().as_secs_f64();
            let rep = serde_json::json!({
                "n": m.n,
                "seconds": secs,
                "row_classes": p.row_class_sizes.len(),
                "col_classes": p.col_class_sizes.len(),
                "row_class_size_histogram": size_hist(&p.row_class_sizes),
                "col_class_size_histogram": size_hist(&p.col_class_sizes),
                "row_class": p.row_class,
                "col_class": p.col_class,
            });
            if let Some(o) = out {
                std::fs::write(o, serde_json::to_string(&rep)? + "\n")?;
            }
            println!(
                "n={} rows split into {} classes, cols into {} classes ({:.1} s)",
                m.n,
                p.row_class_sizes.len(),
                p.col_class_sizes.len(),
                secs
            );
            println!("  row class sizes: {:?}", size_hist(&p.row_class_sizes));
            println!("  col class sizes: {:?}", size_hist(&p.col_class_sizes));
        }
        Cmd::Certify {
            files,
            outdir,
            workdir,
            with_aut,
            aut_timeout,
            invariant,
            invar_levels,
            traces,
            profile_colour,
        } => {
            let wd = workdir.unwrap_or_else(default_workdir);
            let opts = certify::CertifyOpts {
                outdir: &outdir,
                workdir: &wd,
                with_aut,
                invariant: mk_inv(invariant, &invar_levels),
                traces,
                profile_colour,
                aut_timeout_secs: Some(aut_timeout),
            };
            let ok = certify::run(&files, &opts)?;
            if !ok {
                std::process::exit(1);
            }
        }
        Cmd::Decode { spec, input, n } => {
            // TODO(C999): the August-2026 poster published the order-668 matrix as an encoded
            // +-1 string together with a decoder whose format is not yet known here. When it is
            // known, implement it as a `Format` variant in `matrix.rs` and dispatch on `spec`.
            // Until then this subcommand only records the request and points at the generic
            // bit-packed reader, which already handles hex and base64 payloads in both bit
            // orders and both row layouts.
            eprintln!("decode: NOT IMPLEMENTED (the poster's encoding is not yet known here)");
            eprintln!("  spec  : {spec}");
            eprintln!("  input : {}", input.unwrap_or_else(|| "<none>".into()));
            eprintln!("  n     : {}", n.map(|v| v.to_string()).unwrap_or_default());
            eprintln!();
            eprintln!("Already supported without any new code, via `verify`/`classify`:");
            eprintln!("  --format hex|b64 --n <N> --bit-zero-is plus|minus \\");
            eprintln!("      --bit-layout contiguous|row-aligned");
            eprintln!("  --format pm|zo|num  for text payloads");
            eprintln!();
            eprintln!("If the published decoder is a script, run it to produce any of those");
            eprintln!("forms and feed the result to `verify`.");
            std::process::exit(2);
        }
    }
    Ok(())
}

fn print_selftest(rep: &selftest::SelftestReport) {
    println!(
        "{:<24} {:>5} {:>7} {:>7} {:>18} {:>18} {:>6}",
        "case", "n", "verify", "form", "|Aut(graph)|", "mod center", "pass"
    );
    for c in &rep.cases {
        println!(
            "{:<24} {:>5} {:>7} {:>7} {:>18} {:>18} {:>6}",
            c.case,
            c.n,
            if c.verify_pass { "ok" } else { "FAIL" },
            if c.form_pass { "ok" } else { "FAIL" },
            c.aut_graph_order.clone().unwrap_or_else(|| "-".into()),
            c.aut_order_mod_center.clone().unwrap_or_else(|| "-".into()),
            if c.pass { "PASS" } else { "FAIL" },
        );
        for f in &c.forms_found {
            println!("    form: {f}");
        }
        for n in &c.notes {
            println!("    note: {n}");
        }
    }
    for a in &rep.auxiliary {
        println!(
            "{:<24} {:>5} {:>7} {:>7} {:>18} {:>18} {:>6}",
            a.get("check").and_then(|v| v.as_str()).unwrap_or("?"),
            "-",
            "-",
            "-",
            "-",
            "-",
            if a.get("pass").and_then(|v| v.as_bool()).unwrap_or(false) {
                "PASS"
            } else {
                "FAIL"
            }
        );
    }
    println!("\nall_pass = {}", rep.all_pass);
}
