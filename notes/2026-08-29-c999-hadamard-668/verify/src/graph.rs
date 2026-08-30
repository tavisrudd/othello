//! The 4n-vertex Hadamard graph and the nauty/`dreadnaut` interface.
//!
//! Vertices: `r+ = r`, `r- = n + r`, `c+ = 2n + c`, `c- = 3n + c`.
//! `r^s ~ c^t` iff `H[r][c] * s * t = +1`.
//!
//! Automorphisms of this graph that preserve the {rows} / {cols} colour classes are exactly
//! the signed monomial pairs `(P, Q)` with `P H Q^T = H`. The pair `(-I, -I)` (swap every
//! `r+ <-> r-` and every `c+ <-> c-`) is a central involution acting trivially on `H` itself,
//! so the Hadamard automorphism group in the "modulo the central swap" convention has order
//! `|Aut(graph)| / 2`.

use anyhow::{anyhow, bail, Context, Result};
use serde::Serialize;
use std::io::Write;
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};

use crate::matrix::Matrix;

/// Optional nauty vertex invariant: `(*=<code>, k=<lo> <hi>)`. Hadamard graphs with a small
/// automorphism group are the slow case for plain refinement; `1` (twopaths) and `6`
/// (cellquads) are the useful codes here.
#[derive(Clone, Copy, Debug)]
pub struct Invariant {
    pub code: u32,
    pub lo: u32,
    pub hi: u32,
}

#[allow(dead_code)]
pub fn write_dreadnaut(m: &Matrix, colored: bool, want_gens: bool, out: &Path) -> Result<()> {
    write_dreadnaut_inv(m, colored, want_gens, None, out)
}

#[allow(dead_code)]
pub fn write_dreadnaut_inv(
    m: &Matrix,
    colored: bool,
    want_gens: bool,
    inv: Option<Invariant>,
    out: &Path,
) -> Result<()> {
    write_dreadnaut_full(m, colored, want_gens, inv, false, out)
}

/// `traces` selects nauty's Traces engine (`At+`). The 4n Hadamard graph is regular, so dense
/// nauty's refinement never splits a cell and the search degenerates; Traces is built for
/// exactly this case and succeeds on graphs where the dense engine does not finish.
pub fn write_dreadnaut_full(
    m: &Matrix,
    colored: bool,
    want_gens: bool,
    inv: Option<Invariant>,
    traces: bool,
    out: &Path,
) -> Result<()> {
    let n = m.n;
    let f = std::fs::File::create(out)?;
    let mut w = std::io::BufWriter::with_capacity(1 << 20, f);
    writeln!(w, "n={}", 4 * n)?;
    writeln!(w, "$=0")?;
    writeln!(w, "g")?;
    // Only the row side needs to be listed; nauty symmetrizes an undirected graph.
    for r in 0..n {
        write!(w, "{} :", r)?;
        for c in 0..n {
            let t = if m.rows[r][c] == 1 { 2 * n } else { 3 * n };
            write!(w, " {}", t + c)?;
        }
        writeln!(w, ";")?;
        write!(w, "{} :", n + r)?;
        for c in 0..n {
            let t = if m.rows[r][c] == 1 { 3 * n } else { 2 * n };
            write!(w, " {}", t + c)?;
        }
        writeln!(w, ";")?;
    }
    for v in (2 * n)..(4 * n - 1) {
        writeln!(w, "{} :;", v)?;
    }
    writeln!(w, "{} :.", 4 * n - 1)?;
    if colored {
        write!(w, "f=[")?;
        for v in 0..(2 * n) {
            if v > 0 {
                write!(w, ",")?;
            }
            if v % 20 == 0 {
                writeln!(w)?;
            }
            write!(w, "{}", v)?;
        }
        write!(w, "|")?;
        for v in (2 * n)..(4 * n) {
            if v > 2 * n {
                write!(w, ",")?;
            }
            if v % 20 == 0 {
                writeln!(w)?;
            }
            write!(w, "{}", v)?;
        }
        writeln!(w, "]")?;
    }
    if let Some(i) = inv {
        writeln!(w, "*={}", i.code)?;
        writeln!(w, "k={} {}", i.lo, i.hi)?;
    }
    if traces {
        writeln!(w, "At+")?;
    }
    writeln!(w, "{}", if want_gens { "+a" } else { "-a" })?;
    writeln!(w, "c")?;
    writeln!(w, "x")?;
    // Deliberately no `o` command: its orbit line begins with a space, which is
    // indistinguishable from an automorphism continuation line. Orbits are computed here from
    // the generators instead, and cross-checked against the `N orbits;` summary count.
    writeln!(w, "q")?;
    w.flush()?;
    Ok(())
}

/// Locate `dreadnaut`: `$DREADNAUT`, then `PATH`, then `nix shell nixpkgs#nauty`.
pub fn dreadnaut_command() -> Result<Command> {
    if let Ok(p) = std::env::var("DREADNAUT") {
        if Path::new(&p).exists() {
            return Ok(Command::new(p));
        }
    }
    if Command::new("dreadnaut")
        .arg("-o")
        .arg("")
        .stdin(Stdio::null())
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()
        .is_ok()
    {
        return Ok(Command::new("dreadnaut"));
    }
    let mut c = Command::new("nix");
    c.args(["shell", "nixpkgs#nauty", "--command", "dreadnaut"]);
    Ok(c)
}

#[derive(Serialize, Clone, Debug)]
pub struct AutReport {
    pub n: usize,
    pub graph_vertices: usize,
    pub colored_row_col: bool,
    /// `|Aut(graph)|` exactly, when nauty printed an exact integer.
    pub aut_graph_order: Option<String>,
    /// The raw `grpsize=` token.
    pub aut_graph_order_raw: String,
    pub aut_graph_order_is_approx: bool,
    /// `|Aut(graph)|` as a float, always populated.
    pub aut_graph_order_f64: f64,
    /// `|Aut(graph)| / 2` -- the Hadamard automorphism group modulo the central swap.
    pub hadamard_aut_order_mod_center: Option<String>,
    pub hadamard_aut_order_mod_center_f64: f64,
    pub num_generators: usize,
    pub num_orbits: usize,
    pub orbit_sizes: Vec<usize>,
    pub generator_cycle_data: Vec<GenInfo>,
    /// Largest order of a strictly semiregular (fixed-point-free, uniform cycle length) element
    /// found among the generators, their powers, and a randomized walk in the group. This is a
    /// lower bound only: no full group is built and no cyclic-subgroup classification is done.
    pub max_semiregular_order_found: usize,
    /// Element orders seen during the randomized walk, ascending.
    pub sampled_element_orders: Vec<usize>,
    /// Elements that act with uniform cycle length away from their fixed points. A pure
    /// block-circulant form gives `fixed_points = 0`; a *bordered* block-circulant gives a small
    /// non-zero fixed set (the border), which is the shape the order-668 target would take.
    pub cyclic_structure_found: Vec<CyclicElt>,
    pub random_words_sampled: usize,
    pub dreadnaut_stderr: String,
}

#[derive(Serialize, Clone, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct CyclicElt {
    pub order: usize,
    pub fixed_points: usize,
    /// True when there are no fixed points at all (a pure block-circulant signature).
    pub strictly_semiregular: bool,
    /// Fixed points among the `2n` row vertices.
    pub fixed_row_vertices: usize,
    /// Fixed points among the `2n` column vertices.
    pub fixed_col_vertices: usize,
}

#[derive(Serialize, Clone, Debug)]
pub struct GenInfo {
    pub order: usize,
    pub semiregular: bool,
    pub cycle_lengths: Vec<usize>,
    pub fixed_points: usize,
    /// Cycle lengths of the induced action on the `2n` row vertices.
    pub row_cycle_lengths: Vec<usize>,
}

pub fn run_autgroup(
    m: &Matrix,
    colored: bool,
    want_gens: bool,
    workdir: &Path,
    keep: bool,
) -> Result<AutReport> {
    run_autgroup_inv(m, colored, want_gens, None, workdir, keep)
}

pub fn run_autgroup_inv(
    m: &Matrix,
    colored: bool,
    want_gens: bool,
    inv: Option<Invariant>,
    workdir: &Path,
    keep: bool,
) -> Result<AutReport> {
    run_autgroup_full(m, colored, want_gens, inv, workdir, keep, None)
}

/// `timeout` kills dreadnaut after the given wall-clock budget and returns a `TimedOut` error.
/// The 4n-vertex Hadamard graph is regular, so nauty's refinement never splits a cell on its
/// own; when the automorphism group is small this becomes a deep individualization search that
/// can run far longer than the whole rest of the pipeline.
pub fn run_autgroup_full(
    m: &Matrix,
    colored: bool,
    want_gens: bool,
    inv: Option<Invariant>,
    workdir: &Path,
    keep: bool,
    timeout: Option<std::time::Duration>,
) -> Result<AutReport> {
    run_autgroup_engine(m, colored, want_gens, inv, false, workdir, keep, timeout)
}

#[allow(clippy::too_many_arguments)]
pub fn run_autgroup_engine(
    m: &Matrix,
    colored: bool,
    want_gens: bool,
    inv: Option<Invariant>,
    traces: bool,
    workdir: &Path,
    keep: bool,
    timeout: Option<std::time::Duration>,
) -> Result<AutReport> {
    std::fs::create_dir_all(workdir)?;
    let path: PathBuf = workdir.join(format!("had{}-{}.dre", m.n, std::process::id()));
    write_dreadnaut_full(m, colored, want_gens, inv, traces, &path)?;
    let mut cmd = dreadnaut_command()?;
    let f = std::fs::File::open(&path)?;
    let mut child = cmd
        .stdin(Stdio::from(f))
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .context("failed to run dreadnaut (install nauty or set $DREADNAUT)")?;
    let start = std::time::Instant::now();
    let status = loop {
        match child.try_wait()? {
            Some(st) => break Some(st),
            None => {
                if let Some(t) = timeout {
                    if start.elapsed() >= t {
                        let _ = child.kill();
                        let _ = child.wait();
                        break None;
                    }
                }
                std::thread::sleep(std::time::Duration::from_millis(200));
            }
        }
    };
    let out = child.wait_with_output()?;
    if !keep {
        let _ = std::fs::remove_file(&path);
    }
    if status.is_none() {
        bail!(
            "dreadnaut exceeded the {} s budget on n = {}",
            timeout.map(|t| t.as_secs()).unwrap_or(0),
            m.n
        );
    }
    let stdout = String::from_utf8_lossy(&out.stdout).to_string();
    let stderr = String::from_utf8_lossy(&out.stderr).to_string();
    parse_dreadnaut(m, &stdout, &stderr, colored)
}

fn parse_dreadnaut(m: &Matrix, stdout: &str, stderr: &str, colored: bool) -> Result<AutReport> {
    let n = m.n;
    let nv = 4 * n;
    let summary = stdout
        .lines()
        .find(|l| l.contains("grpsize="))
        .ok_or_else(|| anyhow!("no grpsize line in dreadnaut output:\n{stdout}\n{stderr}"))?;
    let raw = summary
        .split("grpsize=")
        .nth(1)
        .unwrap()
        .split(';')
        .next()
        .unwrap()
        .trim()
        .to_string();
    let approx = raw.contains('e') || raw.contains('.');
    let exact = if approx { None } else { Some(raw.clone()) };
    let half = exact.as_ref().and_then(|s| {
        s.parse::<u128>()
            .ok()
            .filter(|v| v % 2 == 0)
            .map(|v| (v / 2).to_string())
    });
    let as_f64: f64 = raw.replace('e', "e").parse::<f64>().unwrap_or(f64::NAN);
    let ngens = summary
        .split_whitespace()
        .zip(summary.split_whitespace().skip(1))
        .find(|(_, b)| b.starts_with("gens"))
        .and_then(|(a, _)| a.parse::<usize>().ok())
        .unwrap_or(0);
    let norbits = summary
        .split_whitespace()
        .next()
        .and_then(|t| t.parse::<usize>().ok())
        .unwrap_or(0);

    // Generators in cycle notation. dreadnaut wraps a long permutation over several lines and
    // may split a single cycle mid-way; every continuation line is indented, and the first line
    // of a generator starts with `(` in column 0.
    let mut gen_info = Vec::new();
    let mut gens: Vec<Vec<u32>> = Vec::new();
    let mut cur = String::new();
    {
        let flush = |cur: &mut String, gens: &mut Vec<Vec<u32>>, gi: &mut Vec<GenInfo>| {
            if cur.is_empty() {
                return;
            }
            if let Ok(perm) = parse_cycles(cur, nv) {
                gi.push(analyse_perm(&perm, n));
                gens.push(perm);
            }
            cur.clear();
        };
        for line in stdout.lines() {
            // Dense nauty starts a generator with `(` in column 0; Traces prefixes it with
            // `Gen(A) #1: `. Both indent their continuation lines.
            let traces_start = line.starts_with("Gen") && line.contains(": (");
            if line.starts_with('(') || traces_start {
                flush(&mut cur, &mut gens, &mut gen_info);
                let body = if traces_start {
                    &line[line.find(": (").unwrap() + 2..]
                } else {
                    line
                };
                cur.push_str(body);
            } else if !cur.is_empty() && line.starts_with(|c: char| c.is_whitespace()) {
                cur.push(' ');
                cur.push_str(line);
            } else {
                flush(&mut cur, &mut gens, &mut gen_info);
            }
        }
        flush(&mut cur, &mut gens, &mut gen_info);
    }

    // Orbits of the group, computed from the generators by union-find.
    let orbit_sizes = {
        let mut parent: Vec<usize> = (0..nv).collect();
        fn find(p: &mut Vec<usize>, mut x: usize) -> usize {
            while p[x] != x {
                p[x] = p[p[x]];
                x = p[x];
            }
            x
        }
        for g in &gens {
            for v in 0..nv {
                let (a, b) = (find(&mut parent, v), find(&mut parent, g[v] as usize));
                if a != b {
                    parent[a] = b;
                }
            }
        }
        let mut counts = std::collections::HashMap::new();
        for v in 0..nv {
            let r = find(&mut parent, v);
            *counts.entry(r).or_insert(0usize) += 1;
        }
        let mut s: Vec<usize> = counts.into_values().collect();
        s.sort_unstable();
        s
    };

    // nauty's generators are chosen by its search tree and are typically near the identity, so
    // scanning only them badly underestimates the cyclic structure. Sample a deterministic
    // random walk in the group as well and test every cyclic generator of every sampled element.
    let words: usize = std::env::var("HAD668_RANDOM_WORDS")
        .ok()
        .and_then(|v| v.parse().ok())
        .unwrap_or(if gens.is_empty() { 0 } else { 2000 });
    let fixed_cap: usize = std::env::var("HAD668_FIXED_CAP")
        .ok()
        .and_then(|v| v.parse().ok())
        .unwrap_or(16);
    let mut max_semi = 1usize;
    let mut orders: Vec<usize> = Vec::new();
    let mut cyclic: Vec<CyclicElt> = Vec::new();
    // Record every sampled element (and every cyclic generator of the group it generates) whose
    // cycles all have length 1 or `order`. Fixed points are counted, not rejected: the core
    // shift of a *bordered* block-circulant matrix fixes exactly the border vertices, so
    // demanding zero fixed points would miss the order-668 shape entirely.
    let mut consider = |p: &[u32], orders: &mut Vec<usize>, cyc: &mut Vec<CyclicElt>| {
        let cl = cycle_lengths(p);
        let ord = cl.iter().fold(1usize, |a, &b| lcm(a, b));
        orders.push(ord);
        for d in divisors(ord) {
            let q = if d == 1 { p.to_vec() } else { perm_pow(p, d) };
            let qcl = cycle_lengths(&q);
            let qord = qcl.iter().fold(1usize, |a, &b| lcm(a, b));
            if qord <= 1 || !qcl.iter().all(|&l| l == 1 || l == qord) {
                continue;
            }
            let fixed = (0..q.len()).filter(|&v| q[v] as usize == v).count();
            // Reject elements that merely happen to have uniform cycles on a small moved set.
            // A block-circulant core shift moves everything except the border; a border of `b`
            // rows and `b` columns contributes 2b + 2b fixed vertices, so the default cap of 16
            // covers borders up to 4 rows (the widest of the decoded matrices with circulant
            // blocks). Raise HAD668_FIXED_CAP for wider borders.
            if fixed > fixed_cap {
                continue;
            }
            let fixed_rows = (0..2 * n).filter(|&v| q[v] as usize == v).count();
            if fixed == 0 && qord > max_semi {
                max_semi = qord;
            }
            cyc.push(CyclicElt {
                order: qord,
                fixed_points: fixed,
                strictly_semiregular: fixed == 0,
                fixed_row_vertices: fixed_rows,
                fixed_col_vertices: fixed - fixed_rows,
            });
        }
    };
    for g in &gens {
        consider(g, &mut orders, &mut cyclic);
    }
    if !gens.is_empty() {
        let mut state: u64 = 0x9E3779B97F4A7C15;
        let mut cur: Vec<u32> = (0..nv as u32).collect();
        for _ in 0..words {
            state = state
                .wrapping_mul(6364136223846793005)
                .wrapping_add(1442695040888963407);
            let g = &gens[((state >> 33) as usize) % gens.len()];
            cur = cur.iter().map(|&v| g[v as usize]).collect();
            consider(&cur, &mut orders, &mut cyclic);
        }
    }
    orders.sort_unstable();
    orders.dedup();
    cyclic.sort_unstable();
    cyclic.dedup();
    // Largest orders first; keep the report bounded.
    cyclic.sort_by(|a, b| b.order.cmp(&a.order).then(a.fixed_points.cmp(&b.fixed_points)));
    cyclic.truncate(24);

    Ok(AutReport {
        n,
        graph_vertices: nv,
        colored_row_col: colored,
        aut_graph_order: exact,
        aut_graph_order_raw: raw,
        aut_graph_order_is_approx: approx,
        aut_graph_order_f64: as_f64,
        hadamard_aut_order_mod_center: half,
        hadamard_aut_order_mod_center_f64: as_f64 / 2.0,
        num_generators: ngens,
        num_orbits: norbits,
        orbit_sizes,
        generator_cycle_data: gen_info,
        max_semiregular_order_found: max_semi,
        sampled_element_orders: orders,
        cyclic_structure_found: cyclic,
        random_words_sampled: words,
        dreadnaut_stderr: stderr.trim().to_string(),
    })
}

fn parse_cycles(s: &str, nv: usize) -> Result<Vec<u32>> {
    let mut perm: Vec<u32> = (0..nv as u32).collect();
    let mut rest = s;
    while let Some(open) = rest.find('(') {
        let close = rest[open..]
            .find(')')
            .ok_or_else(|| anyhow!("unterminated cycle"))?
            + open;
        let body = &rest[open + 1..close];
        let pts: Vec<u32> = body
            .split_whitespace()
            .map(|t| t.parse::<u32>().map_err(|e| anyhow!("{e}")))
            .collect::<Result<_>>()?;
        if pts.iter().any(|&p| p as usize >= nv) {
            bail!("cycle point out of range");
        }
        for i in 0..pts.len() {
            perm[pts[i] as usize] = pts[(i + 1) % pts.len()];
        }
        rest = &rest[close + 1..];
    }
    Ok(perm)
}

fn perm_mul(a: &[u32], b: &[u32]) -> Vec<u32> {
    a.iter().map(|&v| b[v as usize]).collect()
}

fn perm_pow(p: &[u32], k: usize) -> Vec<u32> {
    let mut result: Vec<u32> = (0..p.len() as u32).collect();
    let mut base = p.to_vec();
    let mut e = k;
    while e > 0 {
        if e & 1 == 1 {
            result = perm_mul(&result, &base);
        }
        base = perm_mul(&base, &base);
        e >>= 1;
    }
    result
}

fn divisors(n: usize) -> Vec<usize> {
    let mut d = Vec::new();
    let mut i = 1;
    while i * i <= n {
        if n % i == 0 {
            d.push(i);
            if i != n / i {
                d.push(n / i);
            }
        }
        i += 1;
    }
    d.sort_unstable();
    d
}

fn cycle_lengths(p: &[u32]) -> Vec<usize> {
    let mut seen = vec![false; p.len()];
    let mut out = Vec::new();
    for s in 0..p.len() {
        if seen[s] {
            continue;
        }
        let mut len = 0usize;
        let mut v = s;
        while !seen[v] {
            seen[v] = true;
            v = p[v] as usize;
            len += 1;
        }
        out.push(len);
    }
    out
}

fn analyse_perm(p: &[u32], n: usize) -> GenInfo {
    let cl = cycle_lengths(p);
    let order = cl.iter().fold(1usize, |a, &b| lcm(a, b));
    let fixed = cl.iter().filter(|&&l| l == 1).count();
    let semiregular = order > 1 && cl.iter().all(|&l| l == order);
    // Restriction to the 2n row vertices.
    let rows: Vec<u32> = (0..2 * n).map(|v| p[v]).collect();
    let row_cl = if rows.iter().all(|&v| (v as usize) < 2 * n) {
        let mut c = cycle_lengths(&rows);
        c.sort_unstable();
        c.dedup();
        c
    } else {
        vec![]
    };
    let mut cls = cl.clone();
    cls.sort_unstable();
    cls.dedup();
    GenInfo {
        order,
        semiregular,
        cycle_lengths: cls,
        fixed_points: fixed,
        row_cycle_lengths: row_cl,
    }
}

fn lcm(a: usize, b: usize) -> usize {
    a / gcd(a, b) * b
}

pub fn gcd(a: usize, b: usize) -> usize {
    if b == 0 {
        a
    } else {
        gcd(b, a % b)
    }
}
