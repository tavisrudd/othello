//! C1018 — exact diagonal transversal groups of small qubit CSS codes.
//!
//! For a CSS code with X-type stabilizer code `A` and Z-type stabilizer code
//! `B` (`A ⊥ B`), the code space is spanned by
//! `|ψ_v> = |A|^{-1/2} Σ_{a∈A} |a ⊕ v>` for `v ∈ B^⊥ / A`.
//!
//! A transversal diagonal unitary `U = ⊗_j diag(1, e^{iθ_j})` acts as
//! `U|x> = e^{iθ·x}|x>` with the *integer* inner product, so it preserves the
//! code space iff `x ↦ θ·x` is constant mod 2π on every coset `v ⊕ A ⊆ B^⊥`.
//! Writing `x = θ/2π`, that is the integer system `M x ∈ Z^R` with rows
//! `(v ⊕ a) − v ∈ {−1,0,1}^n`. With Smith normal form `U M V = D` the exact
//! group of such gates is `⊕_i Z_{d_i} ⊕ T^{n−r}` with torsion generators
//! `V e_i / d_i`.
//!
//! The induced logical gate is diagonal, `|y> ↦ e^{2πi p(y)}|y>` with
//! `p(y) = x · v(y)`; its Clifford-hierarchy level is read off the multilinear
//! expansion of `p` over `Z_N`.
//!
//! The binary also emits `css_distance_native` problem inputs for the exact
//! X- and Z-distances of each catalogued code.

use std::collections::BTreeMap;
use std::fs;
use std::path::PathBuf;

use ergodis::{CompiledBinaryLinearCode, Matrix};
use ergodis_private::arith::{lcm_i128 as lcm, smith_normal_form};
use ergodis_private::css_codes::{multilinear_level, reed_muller};
use ergodis_private::gf2_linalg::{all_ones, dual_basis, popcount_and, rref, span, Word};

#[derive(clap::Args, Debug)]
pub struct TransversalArgs {
    /// Restrict to codes whose label contains this substring.
    #[arg(long)]
    only: Option<String>,
    /// Directory to write css_distance_native problem inputs into.
    #[arg(long)]
    distance_inputs: Option<PathBuf>,
    /// Emit the full induced-logical phase table for each generator.
    #[arg(long, default_value_t = false)]
    verbose_logical: bool,
}

// ------------------------------------------------------------- codes -------

struct Code {
    label: &'static str,
    n: usize,
    a: Vec<Word>,
    b: Vec<Word>,
    note: &'static str,
}

/// A named physical transversal diagonal gate to test for membership:
/// `theta_j = 2*pi*coeff_j/modulus`.
struct Probe {
    name: String,
    modulus: i128,
    coeff: Vec<i128>,
}

fn uniform_probe(name: &str, n: usize, modulus: i128) -> Probe {
    Probe {
        name: name.to_string(),
        modulus,
        coeff: vec![1; n],
    }
}

/// The alternating T / T-dagger pattern used by the hypercube colour codes:
/// coefficient `+1` on even-parity vertices, `-1` on odd-parity vertices.
fn parity_probe(name: &str, n: usize, modulus: i128) -> Probe {
    Probe {
        name: name.to_string(),
        modulus,
        coeff: (0..n)
            .map(|j| {
                if (j as u32).count_ones() % 2 == 0 {
                    1
                } else {
                    -1
                }
            })
            .collect(),
    }
}

fn probes_for(label: &str, n: usize) -> Vec<Probe> {
    match label {
        "[[4,2,2]]" => vec![
            uniform_probe("S^{ox n}", n, 4),
            Probe {
                name: "S ox S^-1 ox S ox S^-1".to_string(),
                modulus: 4,
                coeff: vec![1, -1, 1, -1],
            },
            uniform_probe("T^{ox n}", n, 8),
        ],
        "[[7,1,3]]" | "[[15,7,3]]" | "[[9,1,3]]" => vec![
            uniform_probe("Z^{ox n}", n, 2),
            uniform_probe("S^{ox n}", n, 4),
            uniform_probe("T^{ox n}", n, 8),
        ],
        "[[15,1,3]]" => vec![
            uniform_probe("S^{ox n}", n, 4),
            uniform_probe("T^{ox n}", n, 8),
            uniform_probe("P_16^{ox n}", n, 16),
        ],
        "[[31,1,3]]" => vec![
            uniform_probe("T^{ox n}", n, 8),
            uniform_probe("P_16^{ox n}", n, 16),
            uniform_probe("P_32^{ox n}", n, 32),
        ],
        "[[8,3,2]]" => vec![
            parity_probe("T^{+-} (T on even, T^-1 on odd vertices)", n, 8),
            uniform_probe("T^{ox n}", n, 8),
        ],
        "[[16,4,2]]" => vec![
            parity_probe("P_16^{+-} (parity-alternating pi/8 rotation)", n, 16),
            parity_probe("T^{+-}", n, 8),
        ],
        "[[32,5,2]]" => vec![
            parity_probe("P_32^{+-} (parity-alternating pi/16 rotation)", n, 32),
            parity_probe("P_16^{+-}", n, 16),
        ],
        _ => Vec::new(),
    }
}

/// Punctured simplex code of length 2^mm - 1: row i has a 1 at position j-1
/// exactly when bit i of j is set, for j = 1..2^mm-1.
fn simplex(mm: usize) -> (usize, Vec<Word>) {
    let n = (1usize << mm) - 1;
    let mut rows = Vec::new();
    for i in 0..mm {
        let mut w: Word = 0;
        for j in 1..=n {
            if j >> i & 1 == 1 {
                w |= 1u64 << (j - 1);
            }
        }
        rows.push(w);
    }
    (n, rows)
}

fn catalogue() -> Vec<Code> {
    let mut out = Vec::new();

    // [[4,2,2]] error-detecting code / D=2 hypercube colour code.
    out.push(Code {
        label: "[[4,2,2]]",
        n: 4,
        a: vec![0b1111],
        b: vec![0b1111],
        note: "smallest CSS detection code; D=2 member of [[2^D,D,2]]",
    });

    // [[2^D, D, 2]] hypercube colour codes: A = RM(0,D), B = RM(D-2,D).
    for d in 3..=5usize {
        let n = 1usize << d;
        let label: &'static str = match d {
            3 => "[[8,3,2]]",
            4 => "[[16,4,2]]",
            _ => "[[32,5,2]]",
        };
        out.push(Code {
            label,
            n,
            a: vec![all_ones(n)],
            b: reed_muller(d - 2, d),
            note: "hypercube colour code [[2^D,D,2]]: A = RM(0,D), B = RM(D-2,D)",
        });
    }

    // Steane [[7,1,3]]: A = B = [7,3] simplex.
    let (n7, s7) = simplex(3);
    out.push(Code {
        label: "[[7,1,3]]",
        n: n7,
        a: s7.clone(),
        b: s7,
        note: "Steane code, CSS of the [7,4] Hamming code",
    });

    // [[15,7,3]] quantum Hamming: A = B = [15,4] simplex.
    let (n15, s15) = simplex(4);
    out.push(Code {
        label: "[[15,7,3]]",
        n: n15,
        a: s15.clone(),
        b: s15.clone(),
        note: "CSS of the [15,11] Hamming code",
    });

    // [[15,1,3]] quantum Reed-Muller: A = [15,4] simplex,
    // B^perp = punctured RM(1,4) = simplex + all-ones, B = (B^perp)^perp.
    let mut bperp = s15.clone();
    bperp.push(all_ones(n15));
    rref(&mut bperp, n15);
    out.push(Code {
        label: "[[15,1,3]]",
        n: n15,
        a: s15,
        b: dual_basis(&bperp, n15),
        note: "quantum Reed-Muller, the canonical transversal-T code",
    });

    // [[31,1,3]] next member of the same family.
    let (n31, s31) = simplex(5);
    let mut bperp31 = s31.clone();
    bperp31.push(all_ones(n31));
    rref(&mut bperp31, n31);
    out.push(Code {
        label: "[[31,1,3]]",
        n: n31,
        a: s31,
        b: dual_basis(&bperp31, n31),
        note: "next quantum Reed-Muller [[2^m-1,1,3]] member, m=5",
    });

    // Shor [[9,1,3]].
    out.push(Code {
        label: "[[9,1,3]]",
        n: 9,
        a: vec![0b000111111, 0b111111000],
        b: vec![
            0b000000011,
            0b000000110,
            0b000011000,
            0b000110000,
            0b011000000,
            0b110000000,
        ],
        note: "Shor nine-qubit code",
    });

    out
}

// --------------------------------------------------------- computation -----

struct Analysis {
    n: usize,
    k: usize,
    dim_a: usize,
    dim_b: usize,
    rank: usize,
    torsion: Vec<i128>,
    free_rank: usize,
    generators: Vec<Generator>,
    modulus: i128,
    /// True when every free (torus) direction acts trivially on the logicals.
    torus_logically_trivial: bool,
    /// Constraint rows `(v xor a) - v`.
    rows: Vec<Vec<i128>>,
    /// Coset representatives of `A` in `B^perp`, indexed by the logical label.
    reps: Vec<Word>,
    /// Invariant factors of the induced logical gate group (mod global phase).
    logical_invariants: Vec<i128>,
}

/// Invariant factors (those above 1) of the subgroup of `Z_N^m` generated by
/// `rows`. The subgroup is `Lambda / N Z^m` with `Lambda = rowspan + N Z^m`, so
/// the factors are `N / e_j` for the elementary divisors `e_j` of `[rows; N I]`.
fn subgroup_invariants(rows: &[Vec<i128>], m: usize, n_mod: i128) -> Vec<i128> {
    let mut mat: Vec<Vec<i128>> = rows.to_vec();
    for i in 0..m {
        let mut r = vec![0i128; m];
        r[i] = n_mod;
        mat.push(r);
    }
    let (diag, _) = smith_normal_form(&mat, m);
    assert_eq!(diag.len(), m, "expected full rank after adjoining N*I");
    diag.iter().map(|e| n_mod / e).filter(|f| *f > 1).collect()
}

struct Generator {
    order: i128,
    /// phases theta_j / 2pi = coeff_j / modulus
    coeff: Vec<i128>,
    /// induced logical phase p(y) * modulus, indexed by logical y in 0..2^k
    logical: Vec<i128>,
    level: usize,
    name: String,
}

fn name_gate(logical: &[i128], k: usize, modulus: i128, level: usize) -> String {
    if logical.iter().all(|&x| x.rem_euclid(modulus) == 0) {
        return "identity (logically trivial)".to_string();
    }
    // Multilinear expansion, printed as phases in units of 2pi/modulus.
    let mut terms = Vec::new();
    for s in 0..(1usize << k) {
        let mut alpha: i128 = 0;
        let mut r = s;
        loop {
            let sign = if ((s.count_ones() - r.count_ones()) % 2) == 0 {
                1
            } else {
                -1
            };
            alpha += sign * logical[r];
            if r == 0 {
                break;
            }
            r = (r - 1) & s;
        }
        let alpha = alpha.rem_euclid(modulus);
        if alpha == 0 {
            continue;
        }
        let vars: String = (0..k)
            .filter(|i| s >> i & 1 == 1)
            .map(|i| format!("y{i}"))
            .collect::<Vec<_>>()
            .join("");
        if vars.is_empty() {
            terms.push(format!("{alpha}"));
        } else {
            terms.push(format!("{alpha}*{vars}"));
        }
    }
    format!(
        "diag(w^p), w=exp(2pi i/{modulus}), p = {}  [hierarchy level {}]",
        terms.join(" + "),
        if level == usize::MAX {
            "non-2-power".to_string()
        } else {
            level.to_string()
        }
    )
}

fn analyse(code: &Code) -> Analysis {
    let n = code.n;
    let mut a = code.a.clone();
    rref(&mut a, n);
    let mut b = code.b.clone();
    rref(&mut b, n);
    for x in &a {
        for y in &b {
            assert_eq!(
                popcount_and(*x, *y) % 2,
                0,
                "{}: A and B are not orthogonal",
                code.label
            );
        }
    }
    let dim_a = a.len();
    let dim_b = b.len();
    let k = n - dim_a - dim_b;
    let bperp = dual_basis(&b, n);
    assert_eq!(bperp.len(), dim_a + k);

    // coset representatives of A inside B^perp
    let a_span = span(&a);
    let mut seen: BTreeMap<Word, ()> = BTreeMap::new();
    let mut reps: Vec<Word> = Vec::new();
    // complete A to a basis of B^perp; the extra vectors index the logicals
    let mut ext: Vec<Word> = Vec::new();
    {
        let mut cur = a.clone();
        for &w in &bperp {
            let mut probe = cur.clone();
            probe.push(w);
            rref(&mut probe, n);
            if probe.len() > cur.len() {
                cur = probe;
                ext.push(w);
            }
        }
    }
    assert_eq!(ext.len(), k);
    for mask in 0..(1usize << k) {
        let mut v: Word = 0;
        for i in 0..k {
            if mask >> i & 1 == 1 {
                v ^= ext[i];
            }
        }
        reps.push(v);
        seen.insert(v, ());
    }

    // constraint rows (v xor a) - v over the integers
    let mut rowset: BTreeMap<Vec<i128>, ()> = BTreeMap::new();
    for &v in &reps {
        for &aw in &a_span {
            let w = v ^ aw;
            let mut row = vec![0i128; n];
            let mut nz = false;
            for j in 0..n {
                let d = ((w >> j & 1) as i128) - ((v >> j & 1) as i128);
                row[j] = d;
                if d != 0 {
                    nz = true;
                }
            }
            if nz {
                rowset.insert(row, ());
            }
        }
    }
    let rows: Vec<Vec<i128>> = rowset.into_keys().collect();

    let (diag, vmat) = smith_normal_form(&rows, n);
    let rank = diag.len();
    let free_rank = n - rank;
    let torsion: Vec<i128> = diag.iter().copied().filter(|&d| d > 1).collect();

    let modulus = torsion.iter().fold(1i128, |acc, &d| lcm(acc, d)).max(1);

    // torsion generators: x = V e_i / d_i, scaled to integers mod `modulus`
    let mut generators = Vec::new();
    for (i, &d) in diag.iter().enumerate() {
        if d <= 1 {
            continue;
        }
        let scale = modulus / d;
        let coeff: Vec<i128> = (0..n)
            .map(|j| (vmat[j][i] * scale).rem_euclid(modulus))
            .collect();
        let logical: Vec<i128> = reps
            .iter()
            .map(|&v| {
                (0..n)
                    .filter(|&j| v >> j & 1 == 1)
                    .map(|j| coeff[j])
                    .sum::<i128>()
                    .rem_euclid(modulus)
            })
            .collect();
        let base = logical[0];
        let logical: Vec<i128> = logical
            .iter()
            .map(|x| (x - base).rem_euclid(modulus))
            .collect();
        let level = multilinear_level(&logical, k, modulus);
        let name = name_gate(&logical, k, modulus, level);
        generators.push(Generator {
            order: d,
            coeff,
            logical,
            level,
            name,
        });
    }

    // do the free (torus) directions act trivially on the logicals?
    let mut torus_logically_trivial = true;
    for i in rank..n {
        for &v in &reps {
            let s: i128 = (0..n)
                .filter(|&j| v >> j & 1 == 1)
                .map(|j| vmat[j][i])
                .sum();
            let s0: i128 = 0; // reps[0] = 0
            if s - s0 != 0 {
                torus_logically_trivial = false;
            }
        }
    }

    let logical_rows: Vec<Vec<i128>> = generators.iter().map(|g| g.logical.clone()).collect();
    let logical_invariants = if logical_rows.is_empty() {
        Vec::new()
    } else {
        subgroup_invariants(&logical_rows, 1usize << k, modulus)
    };

    Analysis {
        n,
        k,
        dim_a,
        dim_b,
        rank,
        torsion,
        free_rank,
        generators,
        modulus,
        torus_logically_trivial,
        rows,
        reps,
        logical_invariants,
    }
}

/// Membership test and logical readout for one named physical gate.
fn probe_report(an: &Analysis, p: &Probe) -> String {
    for row in &an.rows {
        let s: i128 = row.iter().zip(p.coeff.iter()).map(|(r, c)| r * c).sum();
        if s.rem_euclid(p.modulus) != 0 {
            return format!("{}: NOT code-preserving", p.name);
        }
    }
    let logical: Vec<i128> = an
        .reps
        .iter()
        .map(|&v| {
            (0..an.n)
                .filter(|&j| v >> j & 1 == 1)
                .map(|j| p.coeff[j])
                .sum::<i128>()
                .rem_euclid(p.modulus)
        })
        .collect();
    let base = logical[0];
    let logical: Vec<i128> = logical
        .iter()
        .map(|x| (x - base).rem_euclid(p.modulus))
        .collect();
    let level = multilinear_level(&logical, an.k, p.modulus);
    format!(
        "{}: code-preserving, logical {}",
        p.name,
        name_gate(&logical, an.k, p.modulus, level)
    )
}

// ------------------------------------------------ distance problem IO -----

fn supports(basis: &[Word], n: usize) -> Vec<Vec<u16>> {
    basis
        .iter()
        .map(|&w| {
            (0..n)
                .filter(|&j| w >> j & 1 == 1)
                .map(|j| j as u16)
                .collect()
        })
        .collect()
}

fn write_distance_inputs(code: &Code, dir: &PathBuf) -> std::io::Result<()> {
    let n = code.n;
    let mut a = code.a.clone();
    rref(&mut a, n);
    let mut b = code.b.clone();
    rref(&mut b, n);
    let bperp = dual_basis(&b, n);
    let aperp = dual_basis(&a, n);
    // logical X reps: complete A to a basis of B^perp
    let logical_x = complete(&a, &bperp, n);
    let logical_z = complete(&b, &aperp, n);
    let anchors: Vec<u16> = (0..n as u16).collect();
    let slug = code.label.replace(['[', ']', ',', ' '], "_");
    for (tag, checks, logicals) in [("dZ", &a, &logical_x), ("dX", &b, &logical_z)] {
        let problem = serde_json::json!({
            "label": format!("c1018-{slug}-{tag}"),
            "coordinate_count": n,
            "physical_checks": supports(checks, n),
            "logical_observations": supports(logicals, n),
            "anchors": anchors,
            "maximum_weight": n,
        });
        let path = dir.join(format!("c1018{slug}{tag}.json"));
        fs::write(path, serde_json::to_string_pretty(&problem).unwrap())?;
    }
    Ok(())
}

fn complete(sub: &[Word], sup: &[Word], n: usize) -> Vec<Word> {
    let mut cur = sub.to_vec();
    rref(&mut cur, n);
    let mut ext = Vec::new();
    for &w in sup {
        let mut probe = cur.clone();
        probe.push(w);
        rref(&mut probe, n);
        if probe.len() > cur.len() {
            cur = probe;
            ext.push(w);
        }
    }
    ext
}

// -------------------------------------------------------------- main -------

pub fn run(cli: TransversalArgs) -> std::io::Result<()> {
    if let Some(dir) = &cli.distance_inputs {
        fs::create_dir_all(dir)?;
    }
    for code in catalogue() {
        if let Some(f) = &cli.only {
            if !code.label.contains(f.as_str()) {
                continue;
            }
        }
        let an = analyse(&code);
        println!("=== {} : {}", code.label, code.note);
        println!(
            "  n={} k={} dim(A)={} dim(B)={}",
            an.n, an.k, an.dim_a, an.dim_b
        );
        // Exact lower bound on every X-type check weight: the minimum nonzero
        // weight of A. Enumerable because dim(A) is small for this catalogue.
        {
            let min_x = if code.a.len() <= 20 {
                let mut generator = Vec::with_capacity(code.a.len() * code.n);
                for &word in &code.a {
                    generator.extend((0..code.n).map(|coordinate| (word >> coordinate & 1) as u8));
                }
                let generator = Matrix::new::<2>(code.a.len(), code.n, generator)
                    .expect("catalogued binary generator is valid");
                CompiledBinaryLinearCode::compile(&generator)
                    .expect("catalogued code rank fits the exact enumerator")
                    .minimum_nonzero_weight()
                    .weight
                    .map_or(0, u32::from)
            } else {
                0
            };
            let mut b = code.b.clone();
            rref(&mut b, code.n);
            let max_z = b.iter().map(|w| w.count_ones()).max().unwrap_or(0);
            println!(
                "  minimum possible X-check weight (exact, min nonzero weight of A) = {min_x}; \
                 heaviest Z-check in the reduced generating set = {max_z}"
            );
        }
        let tor = if an.torsion.is_empty() {
            "trivial".to_string()
        } else {
            an.torsion
                .iter()
                .map(|d| format!("Z_{d}"))
                .collect::<Vec<_>>()
                .join(" + ")
        };
        let free = if an.free_rank == 0 {
            String::new()
        } else {
            format!(" + T^{}", an.free_rank)
        };
        let order: i128 = an.torsion.iter().product();
        println!(
            "  exact diagonal transversal group G = {tor}{free}   |G_tors| = {order}   (constraint rank {})",
            an.rank
        );
        println!(
            "  torus part acts trivially on logicals: {}",
            an.torus_logically_trivial
        );
        for g in &an.generators {
            println!("  gen order {}: {}", g.order, g.name);
            let phases: Vec<String> = g.coeff.iter().map(|c| format!("{}", c)).collect();
            println!(
                "      theta_j = 2pi/{} * [{}]",
                an.modulus,
                phases.join(",")
            );
            if cli.verbose_logical {
                println!(
                    "      logical phase table (units 2pi/{}): {:?}",
                    an.modulus, g.logical
                );
            }
            let _ = g.level;
        }
        let max_level = an.generators.iter().map(|g| g.level).max().unwrap_or(0);
        println!(
            "  maximum induced logical Clifford-hierarchy level: {}",
            if max_level == usize::MAX {
                "non-2-power".to_string()
            } else {
                max_level.to_string()
            }
        );
        let li = if an.logical_invariants.is_empty() {
            "trivial".to_string()
        } else {
            an.logical_invariants
                .iter()
                .map(|d| format!("Z_{d}"))
                .collect::<Vec<_>>()
                .join(" + ")
        };
        let lorder: i128 = an
            .logical_invariants
            .iter()
            .fold(1i128, |a, &d| a.saturating_mul(d));
        println!("  induced logical gate group (mod global phase) = {li}   order {lorder}");
        for p in probes_for(code.label, an.n) {
            println!("  probe {}", probe_report(&an, &p));
        }
        if let Some(dir) = &cli.distance_inputs {
            write_distance_inputs(&code, dir)?;
        }
    }
    Ok(())
}
