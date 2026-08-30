//! End-to-end self test on constructions whose properties are known independently.

use anyhow::Result;
use serde::Serialize;
use serde_json::json;
use std::path::{Path, PathBuf};

use crate::classify::{classify, census_subgroups_333};
use crate::construct::{
    find_legendre_pair, find_periodic_golay, find_williamson, goethals_seidel,
    legendre_pair_hadamard, paley1, sylvester, two_circulant, williamson,
};
use crate::graph::run_autgroup;
use crate::matrix::{parse, Matrix, ParseOpts};

#[derive(Serialize)]
pub struct CaseResult {
    pub case: String,
    pub n: usize,
    pub verify_pass: bool,
    pub max_abs_offdiag: i64,
    pub sha256_canonical_normalized: String,
    pub forms_found: Vec<String>,
    pub expected_forms: Vec<String>,
    pub form_pass: bool,
    pub aut_graph_order: Option<String>,
    pub aut_order_mod_center: Option<String>,
    pub expected_aut_graph_order: Option<String>,
    pub aut_pass: Option<bool>,
    pub notes: Vec<String>,
    pub pass: bool,
}

#[derive(Serialize)]
pub struct SelftestReport {
    pub cases: Vec<CaseResult>,
    pub auxiliary: Vec<serde_json::Value>,
    pub all_pass: bool,
}

struct Case {
    name: &'static str,
    matrix: Matrix,
    expected_forms: Vec<&'static str>,
    expected_aut: Option<&'static str>,
    notes: Vec<String>,
}

fn build_cases() -> Result<Vec<Case>> {
    let mut cases = Vec::new();

    // Sylvester H_{2^k}: the rows and their negatives are the 2^{k+1} +-1 vectors of the
    // first-order Reed-Muller code RM(1,k), which is an elementary abelian group of order
    // 2^{k+1} under pointwise product. A monomial column transformation preserves that set iff
    // its sign vector lies in the code and its permutation lies in AGL(k,2), and the column part
    // determines the row part, so
    //     |Aut(H_{2^k})| = 2^{k+1} * 2^k * |GL(k,2)|.
    // k = 2 gives 8 * 4 * 6 = 192, which is also (2^4 * 4!)^2 / 768, the stabilizer order implied
    // by the 768 Hadamard matrices of order 4 -- an independent anchor for the formula.
    cases.push(Case {
        name: "sylvester_4",
        matrix: sylvester(4)?,
        expected_forms: vec![],
        expected_aut: Some("192"),
        notes: vec![
            "|Aut(graph)| = 2^3 * 2^2 * |GL(2,2)| = 8 * 4 * 6 = 192, cross-checked against \
             (2^4 * 4!)^2 / 768 = 192 from the 768 Hadamard matrices of order 4."
                .into(),
        ],
    });

    cases.push(Case {
        name: "sylvester_16",
        matrix: sylvester(16)?,
        expected_forms: vec![],
        expected_aut: Some("10321920"),
        notes: vec![
            "|Aut(graph)| = 2^5 * 2^4 * |GL(4,2)| = 32 * 16 * 20160 = 10321920; the quotient by \
             the central swap is 5160960. (Note: 2 * |AGL(4,2)| = 645120 is NOT the right value; \
             the sign group has order 2^{k+1}, not 2.)"
                .into(),
        ],
    });

    cases.push(Case {
        name: "sylvester_32",
        matrix: sylvester(32)?,
        expected_forms: vec![],
        expected_aut: Some("20478689280"),
        notes: vec![
            "|Aut(graph)| = 2^6 * 2^5 * |GL(5,2)| = 64 * 32 * 9999360 = 20478689280."
                .into(),
        ],
    });

    cases.push(Case {
        name: "paley1_12",
        matrix: paley1(11)?,
        expected_forms: vec!["paley_applicability"],
        expected_aut: Some("190080"),
        notes: vec![
            "The order-12 Hadamard matrix is unique up to equivalence; its automorphism group is \
             2.M12 of order 190080, so the quotient by the central swap is |M12| = 95040."
                .into(),
        ],
    });

    cases.push(Case {
        name: "paley1_660",
        matrix: paley1(659)?,
        expected_forms: vec!["paley_applicability"],
        expected_aut: Some("286190520"),
        notes: vec![
            "Paley I at q = 659 (prime, 659 = 3 mod 4) gives order 660. This is the largest \
             independently constructible check close to the order-668 target; 667 = 23 * 29 and \
             333 = 3^2 * 37 are not prime powers, so no Paley construction reaches 668."
                .into(),
            "|Aut(graph)| = 2 * |PSL(2,659)| = 2 * 659 * (659^2 - 1) / 2 = 286190520, so the \
             quotient by the central swap is |PSL(2,659)| = 143095260. This is the strongest \
             independent confirmation that the 4n-graph plus row/column colouring plus the \
             central-swap quotient computes the Hadamard automorphism group."
                .into(),
        ],
    });

    // Williamson and Goethals--Seidel from a brute-forced Williamson quadruple.
    let mut wcase = None;
    for m in [7usize, 5, 3] {
        if let Some(q) = find_williamson(m) {
            wcase = Some((m, q));
            break;
        }
    }
    if let Some((m, (a, b, c, d))) = wcase {
        cases.push(Case {
            name: "williamson",
            matrix: williamson(&a, &b, &c, &d)?,
            expected_forms: vec!["williamson[as_given]", "cyclic_block_structure_from_aut"],
            expected_aut: None,
            notes: vec![format!(
                "Williamson quadruple of block order {m} found by exhaustive search over \
                 symmetric circulants; Hadamard order {}.",
                4 * m
            )],
        });
        cases.push(Case {
            name: "goethals_seidel",
            matrix: goethals_seidel(&a, &b, &c, &d)?,
            expected_forms: vec!["goethals_seidel[as_given]"],
            expected_aut: None,
            notes: vec![format!(
                "Same four sequences placed in the Goethals--Seidel array, block order {m}, \
                 Hadamard order {}.",
                4 * m
            )],
        });
    }

    // Two-circulant (periodic Golay pair).
    let mut gcase = None;
    for m in (2..=13usize).rev() {
        if let Some(p) = find_periodic_golay(m) {
            gcase = Some((m, p));
            break;
        }
    }
    if let Some((m, (a, b))) = gcase {
        cases.push(Case {
            name: "two_circulant",
            matrix: two_circulant(&a, &b)?,
            expected_forms: vec!["two_circulant[as_given]", "cyclic_block_structure_from_aut"],
            expected_aut: None,
            notes: vec![format!(
                "Periodic Golay pair of length {m} found by exhaustive search; two-circulant \
                 form [A B; B^T -A^T] of order {}.",
                2 * m
            )],
        });
    }

    // Bordered two-circulant from a Legendre pair.
    let mut lcase = None;
    for l in [13usize, 11, 9, 7, 5, 3] {
        if let Some(p) = find_legendre_pair(l) {
            lcase = Some((l, p));
            break;
        }
    }
    if let Some((l, (a, b))) = lcase {
        cases.push(Case {
            name: "legendre_pair_bordered",
            matrix: legendre_pair_hadamard(&a, &b)?,
            expected_forms: vec!["bordered_two_circulant[as_given]", "cyclic_block_structure_from_aut"],
            expected_aut: None,
            notes: vec![format!(
                "Legendre pair of length {l} found by exhaustive search; bordered two-circulant \
                 Hadamard matrix of order {}. This is the shape the order-668 target would take \
                 with core length 333.",
                2 * l + 2
            )],
        });
    }

    Ok(cases)
}

pub fn run(outdir: Option<&Path>, aut_max_n: usize, workdir: &Path) -> Result<SelftestReport> {
    let cases = build_cases()?;
    let mut results = Vec::new();
    for c in cases {
        let mut notes = c.notes.clone();
        let (ok, worst, _) = c.matrix.check_orthogonality();
        let verify_pass = c.matrix.is_square() && ok;

        let aut = if c.matrix.n <= aut_max_n {
            match run_autgroup(&c.matrix, true, true, workdir, false) {
                Ok(a) => Some(a),
                Err(e) => {
                    notes.push(format!("autgroup unavailable: {e}"));
                    None
                }
            }
        } else {
            notes.push(format!(
                "automorphism group skipped: n = {} exceeds --aut-max-n = {aut_max_n}",
                c.matrix.n
            ));
            None
        };

        let rep = classify(&c.matrix, aut.clone());
        let form_pass = c
            .expected_forms
            .iter()
            .all(|f| rep.forms_found.iter().any(|x| x == f));
        for f in &c.expected_forms {
            if !rep.forms_found.iter().any(|x| x == f) {
                notes.push(format!("expected form {f} not detected"));
            }
        }
        let aut_order = aut
            .as_ref()
            .map(|a| a.aut_graph_order.clone().unwrap_or_else(|| a.aut_graph_order_raw.clone()));
        let aut_pass = c.expected_aut.map(|e| {
            let want: f64 = e.parse().unwrap_or(f64::NAN);
            match aut.as_ref().map(|a| a.aut_graph_order_f64) {
                Some(v) => (v - want).abs() <= want * 1e-9,
                None => false,
            }
        });
        if aut_pass == Some(false) {
            notes.push(format!(
                "|Aut(graph)| = {}, expected {}",
                aut_order.clone().unwrap_or_else(|| "<not computed>".into()),
                c.expected_aut.unwrap_or("")
            ));
        }
        if aut.is_some() && c.expected_aut.is_none() {
            notes.push(format!(
                "|Aut(graph)| recorded, not compared: {}",
                aut.as_ref().unwrap().aut_graph_order_raw
            ));
        }

        if let Some(dir) = outdir {
            std::fs::create_dir_all(dir)?;
            let p: PathBuf = dir.join(format!("{}_n{}.pm", c.name, c.matrix.n));
            std::fs::write(&p, c.matrix.canonical_text())?;
            notes.push(format!("matrix written to {}", p.display()));
        }

        let pass = verify_pass && form_pass && aut_pass.unwrap_or(true);
        results.push(CaseResult {
            case: c.name.to_string(),
            n: c.matrix.n,
            verify_pass,
            max_abs_offdiag: worst,
            sha256_canonical_normalized: rep.sha256_canonical_normalized.clone(),
            forms_found: rep.forms_found.clone(),
            expected_forms: c.expected_forms.iter().map(|s| s.to_string()).collect(),
            form_pass,
            aut_graph_order: aut_order.clone(),
            aut_order_mod_center: aut.as_ref().map(|a| {
                a.hadamard_aut_order_mod_center
                    .clone()
                    .unwrap_or_else(|| format!("~{:.6e}", a.hadamard_aut_order_mod_center_f64))
            }),
            expected_aut_graph_order: c.expected_aut.map(|s| s.to_string()),
            aut_pass,
            notes,
            pass,
        });
    }

    let mut auxiliary = Vec::new();
    auxiliary.push(census_check());
    auxiliary.push(parser_roundtrip_check()?);
    auxiliary.push(order_668_dry_run()?);
    auxiliary.push(multiplier_detection_check()?);

    let all_pass = results.iter().all(|r| r.pass)
        && auxiliary
            .iter()
            .all(|a| a.get("pass").and_then(|v| v.as_bool()).unwrap_or(false));
    Ok(SelftestReport {
        cases: results,
        auxiliary,
        all_pass,
    })
}

/// Check that the census subgroup generators reproduce the element sets stated in the
/// C736/C738/C740/C741 reports.
fn census_check() -> serde_json::Value {
    let expected: Vec<(usize, Vec<usize>)> = vec![
        (0, vec![1]),
        (1, vec![1, 73]),
        (2, vec![1, 112, 223]),
        (3, vec![1, 10, 100]),
        (4, vec![1, 121, 322]),
        (5, vec![1, 211, 232]),
    ];
    let mut rows = Vec::new();
    let mut pass = true;
    for (id, gens, status, prov) in census_subgroups_333() {
        let mut set = vec![1usize];
        let mut changed = true;
        while changed {
            changed = false;
            let snap = set.clone();
            for &g in &gens {
                for &s in &snap {
                    let v = (s * g) % 333;
                    if !set.contains(&v) {
                        set.push(v);
                        changed = true;
                    }
                }
            }
        }
        set.sort_unstable();
        let ok = match expected.iter().find(|(e, _)| *e == id) {
            Some((_, want)) => {
                let good = &set == want;
                if !good {
                    pass = false;
                }
                Some(good)
            }
            None => None,
        };
        rows.push(json!({
            "id": id, "generators": gens, "order": set.len(), "elements": set,
            "status": status, "provenance": prov, "matches_report_element_list": ok
        }));
    }
    json!({
        "check": "census_subgroups_mod_333",
        "pass": pass,
        "residual_survivors": [0, 1, 3, 4, 5],
        "rows": rows
    })
}

/// Exercise the whole order-668 path -- 333-length sequences, the bordered layout, the
/// classifier, and the census lookup -- on sequences invariant under the ID-4 multiplier
/// subgroup `<121> = {1, 121, 322}`. The result is deliberately NOT a Hadamard matrix: no
/// Legendre pair of length 333 is known. What is checked is that the plumbing fires and that
/// the census lookup names ID 4.
fn order_668_dry_run() -> Result<serde_json::Value> {
    let l = 333usize;
    let target = vec![1usize, 121, 322];
    let orbit_of = |start: usize| -> Vec<usize> {
        let mut o = vec![start];
        let mut x = (start * 121) % l;
        while x != start {
            o.push(x);
            x = (x * 121) % l;
        }
        o
    };
    let make = |seed: u64| -> Vec<i8> {
        let mut s = vec![0i8; l];
        let mut state = seed;
        for i in 0..l {
            if s[i] != 0 {
                continue;
            }
            state = state.wrapping_mul(6364136223846793005).wrapping_add(1442695040888963407);
            let v: i8 = if (state >> 33) & 1 == 0 { 1 } else { -1 };
            for j in orbit_of(i) {
                s[j] = v;
            }
        }
        s
    };
    let mut a = Vec::new();
    let mut b = Vec::new();
    let mut ok = false;
    for seed in 1..64u64 {
        a = make(seed);
        b = make(seed + 1000);
        let mr = crate::classify::multiplier_report(&a, &b);
        if mr.fixed_common_multipliers == target {
            ok = true;
            break;
        }
    }
    if !ok {
        return Ok(json!({
            "check": "order_668_dry_run",
            "pass": false,
            "reason": "no seed produced sequences whose fixed common-multiplier group is <121>"
        }));
    }
    let m = crate::construct::bordered_two_circulant_layout(&a, &b)?;
    let t0 = std::time::Instant::now();
    let rep = classify(&m, None);
    let elapsed = t0.elapsed().as_secs_f64();
    let bordered = rep
        .tests
        .iter()
        .find(|t| t.name == "bordered_two_circulant[as_given]");
    let detail = bordered.map(|t| t.detail.clone()).unwrap_or(json!(null));
    let id = detail
        .get("census_match_fixed")
        .and_then(|c| c.get("id"))
        .and_then(|v| v.as_u64());
    let paley = rep
        .tests
        .iter()
        .find(|t| t.name == "paley_applicability")
        .map(|t| t.detail.clone())
        .unwrap_or(json!(null));
    let pass = m.n == 668
        && bordered.map(|t| t.found).unwrap_or(false)
        && id == Some(4)
        && !rep.verified_hadamard;
    Ok(json!({
        "check": "order_668_dry_run",
        "pass": pass,
        "n": m.n,
        "core_length": l,
        "bordered_form_detected": bordered.map(|t| t.found),
        "census_id": id,
        "census_status": detail.get("census_match_fixed").and_then(|c| c.get("status")),
        "is_legendre_pair": detail.get("is_legendre_pair"),
        "verified_hadamard": rep.verified_hadamard,
        "max_abs_offdiag": rep.max_abs_offdiag,
        "classify_seconds": elapsed,
        "paley_applicability_at_668": paley,
        "note": "these sequences are a synthetic multiplier-invariant pair, not a Legendre pair; \
                 the matrix is intentionally not Hadamard"
    }))
}


/// Regression test for multiplier detection, using the four length-223 sequences recovered from
/// the decoded order-892 matrix. Their fixed multiplier group is `{1, 39, 183} = <39>` of order
/// 3, and it is the source of that matrix's order-6 automorphism group. The matrix-level test
/// missed this before the compensating shift `2r = t - 1` was derived, so this case pins the fix.
pub const SEQ892: [&str; 4] = [
    "----++-++++--+++++--+--+--+--+++-----++--+-+-+++-+++-+++-+-+++-+++-+++++-++++---+++---+--+--++++--+++++--+---+++-+--+-----+-+++++++------+++-+--++-+++--++--+++-+-+++-++-+++-+----++-------+--+-+-++-+-+--+--+-+--+-+-+-++-+-+-",
    "--+++++-+-++-++----++--++++-+--++-+---+-++--+-+----+------+--+-+-+--+---+++++-+++-++++---+-++-++--+-++-+---+++-+-+++-+-+--+++-+-----++-+++--+--++++-++-+-++++--+--++---+++++---+---++++-++----+--+-+-++++++-+++-++++--+---+--++",
    "--+-+-++-+++-+++---++---++----++------+--+--++++-+++-++++--+++++-+-+-++++-+-+-++--+++++-----+++-+++++-+---+--+++++-+---++------++-+++-+++-++---++-+--+--+-++++--+-+++-+++-+---++++---++--+-++-+--++-+------+-++++-+--+-+---++--",
    "-+-++++-++++-+--++++---++---+++--+--++++-++-++++++-+---+-----+++--++----+----+-+-+----++++++---+-+---+++++-++---+-+--++--+-++-+++-+++-+++++-+-+-+---++-+++-+++-++---++-+-+--+--+--+-+-++-++++-++--+++++-+--+++++-+--+-++-+++---",
];

fn multiplier_detection_check() -> Result<serde_json::Value> {
    let seqs: Vec<Vec<i8>> = SEQ892
        .iter()
        .map(|s| s.chars().map(|c| if c == '+' { 1i8 } else { -1 }).collect())
        .collect();
    let m = crate::construct::goethals_seidel(&seqs[0], &seqs[1], &seqs[2], &seqs[3])?;
    let (ok, worst, _) = m.check_orthogonality();
    let rep = classify(&m, None);
    let mr = rep
        .tests
        .iter()
        .find(|t| t.found && t.name == "gs_array[as_given]")
        .and_then(|t| t.detail.get("multipliers").cloned());
    let group = mr
        .as_ref()
        .and_then(|v| v.get("fixed_multiplier_group").cloned())
        .unwrap_or(json!(null));
    let gen = mr
        .as_ref()
        .and_then(|v| v.get("cyclic_generator").cloned())
        .unwrap_or(json!(null));
    let verified = mr
        .as_ref()
        .and_then(|v| v.get("verified_on_matrix_with_compensating_shift").cloned())
        .unwrap_or(json!(null));
    let pass = m.n == 892
        && ok
        && group == json!([1, 39, 183])
        && gen == json!(39)
        && verified == json!([39, 183]);
    Ok(json!({
        "check": "multiplier_detection_892",
        "pass": pass,
        "n": m.n,
        "hadamard": ok,
        "max_abs_offdiag": worst,
        "fixed_multiplier_group": group,
        "cyclic_generator": gen,
        "verified_on_matrix": verified,
        "note": "rebuilt from the four length-223 sequences via the Goethals--Seidel array; the \
                 group <39> of order 3 explains |Aut| = 6 = centre x <39>"
    }))
}

fn parser_roundtrip_check() -> Result<serde_json::Value> {
    let h = sylvester(16)?;
    let want = h.canonical_text();
    let pm = want.clone();
    let zo: String = want
        .chars()
        .map(|c| match c {
            '+' => '0',
            '-' => '1',
            c => c,
        })
        .collect();
    let num: String = h
        .rows
        .iter()
        .map(|r| {
            r.iter()
                .map(|&v| v.to_string())
                .collect::<Vec<_>>()
                .join(" ")
        })
        .collect::<Vec<_>>()
        .join("\n");
    // Bit packed, contiguous, 0 -> +1.
    let mut bits: Vec<u8> = Vec::new();
    let mut cur = 0u8;
    let mut k = 0;
    for r in &h.rows {
        for &v in r {
            cur = (cur << 1) | if v == 1 { 0 } else { 1 };
            k += 1;
            if k == 8 {
                bits.push(cur);
                cur = 0;
                k = 0;
            }
        }
    }
    if k > 0 {
        bits.push(cur << (8 - k));
    }
    let hex: String = bits.iter().map(|b| format!("{b:02x}")).collect();

    let mut rows = Vec::new();
    let mut pass = true;
    for (name, text, n) in [
        ("pm", pm, None),
        ("zo", zo, None),
        ("num", num, None),
        ("hex", hex, Some(16usize)),
    ] {
        let opts = ParseOpts {
            n,
            ..Default::default()
        };
        let got = parse(&text, &opts);
        let ok = matches!(&got, Ok((m, _)) if m.canonical_text() == want);
        if !ok {
            pass = false;
        }
        rows.push(json!({
            "format": name,
            "detected": got.as_ref().map(|(_, f)| format!("{f:?}").to_lowercase()).unwrap_or_default(),
            "roundtrip_ok": ok,
            "error": got.err().map(|e| e.to_string())
        }));
    }
    Ok(json!({"check": "parser_roundtrip_sylvester_16", "pass": pass, "rows": rows}))
}
