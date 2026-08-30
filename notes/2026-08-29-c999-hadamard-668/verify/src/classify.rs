//! Structural classification: two-circulant, bordered two-circulant (Legendre pair),
//! Williamson, Goethals--Seidel, Paley applicability, and cyclic structure read off the
//! automorphism group.

use serde::Serialize;
use serde_json::json;

use crate::construct::{self, prime_power};
use crate::graph::AutReport;
use crate::matrix::Matrix;

type Blk = Vec<Vec<i8>>;

fn sub(m: &Matrix, r0: usize, c0: usize, h: usize, w: usize) -> Blk {
    m.block(r0, c0, h, w)
}

fn eq(a: &Blk, b: &Blk) -> bool {
    a == b
}

fn negb(a: &Blk) -> Blk {
    a.iter().map(|r| r.iter().map(|&v| -v).collect()).collect()
}

fn tr(a: &Blk) -> Blk {
    let h = a.len();
    let w = a[0].len();
    (0..w).map(|j| (0..h).map(|i| a[i][j]).collect()).collect()
}

fn is_circulant(a: &Blk) -> bool {
    let m = a.len();
    if a[0].len() != m {
        return false;
    }
    (0..m).all(|i| (0..m).all(|j| a[i][j] == a[0][(j + m - i) % m]))
}

fn first_row(a: &Blk) -> Vec<i8> {
    a[0].clone()
}

fn to_pm(s: &[i8]) -> String {
    s.iter().map(|&v| if v == 1 { '+' } else { '-' }).collect()
}

#[derive(Serialize)]
pub struct TestResult {
    pub name: String,
    pub applicable: bool,
    pub found: bool,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub variant: Option<String>,
    pub detail: serde_json::Value,
}

#[derive(Serialize)]
pub struct ClassifyReport {
    pub n: usize,
    pub verified_hadamard: bool,
    pub max_abs_offdiag: i64,
    pub sha256_canonical_as_given: String,
    pub sha256_canonical_normalized: String,
    pub tested_variants: Vec<String>,
    pub tests: Vec<TestResult>,
    pub forms_found: Vec<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub aut: Option<AutReport>,
}

// ---------------------------------------------------------------------------
// two-circulant tests
// ---------------------------------------------------------------------------

/// `A`, `B` circulant of order `m`, core `[A B; C D]`.
/// Returns the matched variant name.
fn two_circulant_variant(a: &Blk, b: &Blk, c: &Blk, d: &Blk) -> Option<&'static str> {
    if !is_circulant(a) || !is_circulant(b) {
        return None;
    }
    if eq(c, &negb(&tr(b))) && eq(d, &tr(a)) {
        return Some("[A B; -B^T A^T]");
    }
    if eq(c, &tr(b)) && eq(d, &negb(&tr(a))) {
        return Some("[A B; B^T -A^T]");
    }
    None
}

fn test_two_circulant(m: &Matrix, label: &str) -> TestResult {
    let n = m.n;
    if n % 2 != 0 {
        return TestResult {
            name: format!("two_circulant[{label}]"),
            applicable: false,
            found: false,
            variant: None,
            detail: json!({"reason": "n is odd"}),
        };
    }
    let h = n / 2;
    let (a, b, c, d) = (
        sub(m, 0, 0, h, h),
        sub(m, 0, h, h, h),
        sub(m, h, 0, h, h),
        sub(m, h, h, h, h),
    );
    match two_circulant_variant(&a, &b, &c, &d) {
        Some(v) => TestResult {
            name: format!("two_circulant[{label}]"),
            applicable: true,
            found: true,
            variant: Some(v.to_string()),
            detail: json!({
                "block_order": h,
                "a": to_pm(&first_row(&a)),
                "b": to_pm(&first_row(&b)),
            }),
        },
        None => TestResult {
            name: format!("two_circulant[{label}]"),
            applicable: true,
            found: false,
            variant: None,
            detail: json!({
                "block_order": h,
                "top_left_circulant": is_circulant(&a),
                "top_right_circulant": is_circulant(&b),
            }),
        },
    }
}

// ---------------------------------------------------------------------------
// bordered two-circulant / Legendre pair
// ---------------------------------------------------------------------------

#[derive(Serialize)]
pub struct CensusMatch {
    pub id: usize,
    pub generators: Vec<usize>,
    pub elements: Vec<usize>,
    pub status: String,
    pub provenance: String,
}

/// The fixed common-multiplier subgroups of `(Z/333)^*` named in the C736/C738/C740/C741
/// reports, in the numbering of arXiv:2607.20765v1, Table A1.
pub fn census_subgroups_333() -> Vec<(usize, Vec<usize>, &'static str, &'static str)> {
    vec![
        (0, vec![], "residual survivor", "C736 census; not excluded by C738/C740"),
        (1, vec![73], "residual survivor", "C736 census; not excluded by C738/C740"),
        (2, vec![112], "excluded", "C740: orbit lock, 222 >= 167 at shifts 111 and 222"),
        (3, vec![10], "residual survivor", "C736 census; not excluded by C738/C740"),
        (4, vec![121], "residual survivor", "C741: not excluded, 108 orbit representatives open"),
        (5, vec![211], "residual survivor", "C741: not excluded, 108 orbit representatives open"),
        (7, vec![73, 112], "excluded", "C738: sole surviving order-6 case, then excluded"),
        (9, vec![73, 85], "excluded", "C736: mod-8 obstruction in the exact 9-compression"),
        (10, vec![73, 121], "excluded", "C736: mod-8 obstruction in the exact 9-compression"),
    ]
}

fn subgroup_closure(gens: &[usize], modulus: usize) -> Vec<usize> {
    let mut set = vec![1usize];
    let mut changed = true;
    while changed {
        changed = false;
        let snapshot = set.clone();
        for &g in gens {
            for &s in &snapshot {
                let v = (s * g) % modulus;
                if !set.contains(&v) {
                    set.push(v);
                    changed = true;
                }
            }
        }
    }
    set.sort_unstable();
    set
}

fn units(modulus: usize) -> Vec<usize> {
    (1..modulus)
        .filter(|&m| crate::graph::gcd(m, modulus) == 1)
        .collect()
}

/// `m` is a fixed (untranslated) multiplier of `a` when `a[m*i] == a[i]` for every `i`.
fn fixed_multipliers(a: &[i8]) -> Vec<usize> {
    let l = a.len();
    units(l)
        .into_iter()
        .filter(|&m| (0..l).all(|i| a[(m * i) % l] == a[i]))
        .collect()
}

/// `m` is a multiplier up to translation when some shift `t` gives `a[m*i + t] == a[i]`.
fn translated_multipliers(a: &[i8]) -> Vec<usize> {
    let l = a.len();
    units(l)
        .into_iter()
        .filter(|&m| (0..l).any(|t| (0..l).all(|i| a[(m * i + t) % l] == a[i])))
        .collect()
}

fn intersect(x: &[usize], y: &[usize]) -> Vec<usize> {
    x.iter().filter(|v| y.contains(v)).cloned().collect()
}

#[derive(Serialize)]
pub struct MultiplierReport {
    pub ell: usize,
    pub a: String,
    pub b: String,
    pub sum_a: i64,
    pub sum_b: i64,
    pub is_legendre_pair: bool,
    pub paf_sum_offsets_wrong: Vec<(usize, i64)>,
    pub fixed_common_multipliers: Vec<usize>,
    pub fixed_common_order: usize,
    pub translated_common_multipliers: Vec<usize>,
    pub translated_common_order: usize,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub census_match_fixed: Option<CensusMatch>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub census_note: Option<String>,
}

pub fn multiplier_report(a: &[i8], b: &[i8]) -> MultiplierReport {
    let l = a.len();
    let pa = construct::paf(a);
    let pb = construct::paf(b);
    let bad: Vec<(usize, i64)> = (1..l)
        .filter(|&s| pa[s] + pb[s] != -2)
        .map(|s| (s, pa[s] + pb[s]))
        .collect();
    let fa = fixed_multipliers(a);
    let fb = fixed_multipliers(b);
    let fixed = intersect(&fa, &fb);
    let ta = translated_multipliers(a);
    let tb = translated_multipliers(b);
    let translated = intersect(&ta, &tb);

    let (census_match_fixed, census_note) = if l == 333 {
        let mut found = None;
        for (id, gens, status, prov) in census_subgroups_333() {
            let elems = subgroup_closure(&gens, 333);
            if elems == fixed {
                found = Some(CensusMatch {
                    id,
                    generators: gens,
                    elements: elems,
                    status: status.to_string(),
                    provenance: prov.to_string(),
                });
                break;
            }
        }
        let note = if found.is_none() {
            Some(format!(
                "fixed common-multiplier group of order {} matches none of the nine residual \
                 Table A1 subgroups listed in C736/C738/C740/C741; the census covers only the \
                 fixed, untranslated cases",
                fixed.len()
            ))
        } else {
            None
        };
        (found, note)
    } else {
        (
            None,
            Some(format!(
                "census IDs are defined only for Legendre pairs of length 333; this pair has \
                 length {l}"
            )),
        )
    };

    MultiplierReport {
        ell: l,
        a: to_pm(a),
        b: to_pm(b),
        sum_a: a.iter().map(|&v| v as i64).sum(),
        sum_b: b.iter().map(|&v| v as i64).sum(),
        is_legendre_pair: bad.is_empty(),
        paf_sum_offsets_wrong: bad.into_iter().take(8).collect(),
        fixed_common_order: fixed.len(),
        fixed_common_multipliers: fixed,
        translated_common_order: translated.len(),
        translated_common_multipliers: translated,
        census_match_fixed,
        census_note,
    }
}

fn test_bordered(m: &Matrix, label: &str) -> TestResult {
    let n = m.n;
    if n < 6 || n % 2 != 0 {
        return TestResult {
            name: format!("bordered_two_circulant[{label}]"),
            applicable: false,
            found: false,
            variant: None,
            detail: json!({"reason": "n must be even and at least 6"}),
        };
    }
    let l = (n - 2) / 2;
    let mut attempts = Vec::new();
    for (bname, r0) in [("border_first_two", 2usize), ("border_last_two", 0usize)] {
        // r0 is the offset of the core inside the matrix.
        let (a, b, c, d) = (
            sub(m, r0, r0, l, l),
            sub(m, r0, r0 + l, l, l),
            sub(m, r0 + l, r0, l, l),
            sub(m, r0 + l, r0 + l, l, l),
        );
        if let Some(v) = two_circulant_variant(&a, &b, &c, &d) {
            let seq_a = first_row(&a);
            let seq_b = first_row(&b);
            let mr = multiplier_report(&seq_a, &seq_b);
            return TestResult {
                name: format!("bordered_two_circulant[{label}]"),
                applicable: true,
                found: true,
                variant: Some(format!("{bname} core {v}")),
                detail: serde_json::to_value(&mr).unwrap(),
            };
        }
        attempts.push(json!({
            "border": bname,
            "core_order": l,
            "top_left_circulant": is_circulant(&a),
            "top_right_circulant": is_circulant(&b),
        }));
    }
    TestResult {
        name: format!("bordered_two_circulant[{label}]"),
        applicable: true,
        found: false,
        variant: None,
        detail: json!({"core_order": l, "attempts": attempts}),
    }
}

// ---------------------------------------------------------------------------
// Williamson / Goethals--Seidel
// ---------------------------------------------------------------------------

fn test_williamson(m: &Matrix, label: &str) -> TestResult {
    let n = m.n;
    if n % 4 != 0 {
        return TestResult {
            name: format!("williamson[{label}]"),
            applicable: false,
            found: false,
            variant: None,
            detail: json!({"reason": "n is not divisible by 4"}),
        };
    }
    let bm = n / 4;
    let a = first_row(&sub(m, 0, 0, bm, bm));
    let b = first_row(&sub(m, 0, bm, bm, bm));
    let c = first_row(&sub(m, 0, 2 * bm, bm, bm));
    let d = first_row(&sub(m, 0, 3 * bm, bm, bm));
    match construct::williamson(&a, &b, &c, &d) {
        Ok(h) if h.rows == m.rows => TestResult {
            name: format!("williamson[{label}]"),
            applicable: true,
            found: true,
            variant: Some("[A B C D; -B A D -C; -C -D A B; -D C -B A]".into()),
            detail: json!({
                "block_order": bm,
                "a": to_pm(&a), "b": to_pm(&b), "c": to_pm(&c), "d": to_pm(&d)
            }),
        },
        Ok(_) => TestResult {
            name: format!("williamson[{label}]"),
            applicable: true,
            found: false,
            variant: None,
            detail: json!({
                "block_order": bm,
                "reason": "first block row gives symmetric circulants satisfying the Williamson \
                           condition, but the assembled array differs from the input"
            }),
        },
        Err(e) => TestResult {
            name: format!("williamson[{label}]"),
            applicable: true,
            found: false,
            variant: None,
            detail: json!({"block_order": bm, "reason": e.to_string()}),
        },
    }
}

fn rev_cols(a: &Blk) -> Blk {
    a.iter().map(|r| r.iter().rev().cloned().collect()).collect()
}

/// Largest block length `b` dividing `mm` for which `x` is block-circulant: `x` splits into
/// `(mm/b)^2` blocks of size `b`, each of which is an ordinary circulant. `b == mm` means `x`
/// is itself circulant.
fn block_circulant_length(x: &Blk) -> Option<usize> {
    let mm = x.len();
    let mut divs: Vec<usize> = (1..=mm).filter(|d| mm % d == 0).collect();
    divs.reverse();
    for b in divs {
        let nb = mm / b;
        let ok = (0..nb).all(|bi| {
            (0..nb).all(|bj| {
                (0..b).all(|i| {
                    (0..b).all(|j| {
                        x[bi * b + i][bj * b + j] == x[bi * b][bj * b + (j + b - i) % b]
                    })
                })
            })
        });
        if ok {
            return Some(b);
        }
    }
    None
}

/// The Goethals--Seidel array as a *pattern* over four arbitrary blocks, optionally inside a
/// `bw`-row / `bw`-column border:
///
/// ```text
/// [  A     BR    CR    DR
///   -BR    A     D^T R -C^T R
///   -CR   -D^T R A     B^T R
///   -DR    C^T R -B^T R A    ]
/// ```
///
/// Unlike `goethals_seidel`, this does not require the blocks to be circulant, so it also
/// recognises a GS array over block-circulant super-blocks (T-matrices). Block properties are
/// reported separately.
fn test_gs_array(m: &Matrix, label: &str) -> TestResult {
    let n = m.n;
    let mut attempts = Vec::new();
    for bw in [0usize, 4, 12, 20, 28] {
        if n <= bw || (n - bw) % 4 != 0 {
            continue;
        }
        let mm = (n - bw) / 4;
        let g = |i: usize, j: usize| sub(m, bw + i * mm, bw + j * mm, mm, mm);
        let (br, cr, dr) = (g(0, 1), g(0, 2), g(0, 3));
        let a = g(0, 0);
        let (b, c, d) = (rev_cols(&br), rev_cols(&cr), rev_cols(&dr));
        // The six relations that do not involve a transpose fix the outer GS skeleton.
        let skeleton: [(&str, Blk, Blk); 6] = [
            ("(1,0)=-BR", g(1, 0), negb(&br)),
            ("(1,1)=A", g(1, 1), a.clone()),
            ("(2,0)=-CR", g(2, 0), negb(&cr)),
            ("(2,2)=A", g(2, 2), a.clone()),
            ("(3,0)=-DR", g(3, 0), negb(&dr)),
            ("(3,3)=A", g(3, 3), a.clone()),
        ];
        let skel_failed: Vec<&str> = skeleton
            .iter()
            .filter(|(_, got, want)| !eq(got, want))
            .map(|(nm, _, _)| *nm)
            .collect();
        // Read the "transpose-like" operation off the array instead of assuming it is the
        // matrix transpose: the block-circulant super-block families use a different one.
        let b_op = rev_cols(&g(2, 3));
        let c_op = rev_cols(&negb(&g(1, 3)));
        let d_op = rev_cols(&g(1, 2));
        let consistency: [(&str, Blk, Blk); 3] = [
            ("(3,1)=C^op R", g(3, 1), rev_cols(&c_op)),
            ("(2,1)=-D^op R", g(2, 1), negb(&rev_cols(&d_op))),
            ("(3,2)=-B^op R", g(3, 2), negb(&rev_cols(&b_op))),
        ];
        let cons_failed: Vec<&str> = consistency
            .iter()
            .filter(|(_, got, want)| !eq(got, want))
            .map(|(nm, _, _)| *nm)
            .collect();
        let classic_transpose =
            eq(&b_op, &tr(&b)) && eq(&c_op, &tr(&c)) && eq(&d_op, &tr(&d));
        let failed: Vec<&str> = skel_failed
            .iter()
            .chain(cons_failed.iter())
            .cloned()
            .collect();
        if !failed.is_empty() {
            attempts.push(json!({
                "border_width": bw, "block_order": mm,
                "skeleton_relations_failed": skel_failed,
                "transpose_consistency_failed": cons_failed
            }));
            continue;
        }
        // The array pattern holds. Describe the four blocks.
        let blocks = [("A", &a), ("B", &b), ("C", &c), ("D", &d)];
        let circ: Vec<bool> = blocks.iter().map(|(_, x)| is_circulant(x)).collect();
        let all_circ = circ.iter().all(|&v| v);
        let bcl: Vec<Option<usize>> = blocks
            .iter()
            .map(|(_, x)| block_circulant_length(x))
            .collect();
        let mut detail = json!({
            "border_width": bw,
            "block_order": mm,
            "blocks_circulant": all_circ,
            "block_circulant_lengths": bcl,
            "sub_block_count": bcl.iter().map(|b| b.map(|b| mm / b)).collect::<Vec<_>>(),
            "transpose_operation_is_matrix_transpose": classic_transpose,
        });
        if all_circ {
            let seqs: Vec<Vec<i8>> = blocks.iter().map(|(_, x)| first_row(x)).collect();
            let pafs: Vec<Vec<i64>> = seqs.iter().map(|s| construct::paf(s)).collect();
            let sums: Vec<i64> = (1..mm)
                .map(|s| pafs.iter().map(|p| p[s]).sum::<i64>())
                .collect();
            let constant = sums.iter().all(|&v| v == sums[0]);
            let rowsums: Vec<i64> = seqs
                .iter()
                .map(|s| s.iter().map(|&v| v as i64).sum())
                .collect();
            detail["sequences"] = json!(blocks
                .iter()
                .zip(&seqs)
                .map(|((nm, _), s)| json!({ "name": nm, "seq": to_pm(s) }))
                .collect::<Vec<_>>());
            detail["paf_sum_constant_over_nonzero_shifts"] = json!(constant);
            detail["paf_sum_value"] = json!(if constant { Some(sums[0]) } else { None });
            detail["sequence_row_sums"] = json!(rowsums);
            detail["expected_paf_sum"] = json!(if bw == 0 { 0i64 } else { -(bw as i64) });
        }
        if bw > 0 {
            detail["border"] = json!(describe_border(m, bw, mm));
        }
        detail["shift_automorphisms"] = shift_automorphisms(m, bw, mm, bcl[0]);
        if all_circ {
            let seqs: Vec<Vec<i8>> = blocks.iter().map(|(_, x)| first_row(x)).collect();
            detail["multipliers"] = multiplier_report_for_sequences(m, bw, mm, &seqs);
        }
        return TestResult {
            name: format!("gs_array[{label}]"),
            applicable: true,
            found: true,
            variant: Some({
                let kind = if classic_transpose {
                    "Goethals--Seidel array"
                } else {
                    "Goethals--Seidel array with a generalized (non-matrix) transpose"
                };
                let blocks = match bcl[0] {
                    Some(b) if b == mm => format!("four circulants of order {mm}"),
                    Some(b) => format!(
                        "four block-circulant blocks of order {mm} ({} sub-blocks of length {b})",
                        mm / b
                    ),
                    None => format!("four blocks of order {mm}"),
                };
                if bw == 0 {
                    format!("{kind}, {blocks}")
                } else {
                    format!("bordered {kind}, border {bw}, {blocks}")
                }
            }),
            detail,
        };
    }
    TestResult {
        name: format!("gs_array[{label}]"),
        applicable: true,
        found: false,
        variant: None,
        detail: json!({"attempts": attempts}),
    }
}

/// Exact, solver-free search for block-shift automorphisms of a (bordered) block array.
///
/// For a shift `s`, permute rows and columns by "fix the border, and rotate each of the four
/// blocks by `s`". The pair is realised by a monomial automorphism `P H Q = H` exactly when the
/// permuted matrix and `H` have the same dephasing: writing `Y_ij = X_00 X_i0 X_0j X_ij`, the
/// dephased form is the unique representative of the orbit of `X` under independent row and
/// column sign changes, so equality of dephasings is necessary and sufficient.
///
/// This is the reason a simultaneous shift usually fails and `s = m/2` usually works. In the
/// Goethals--Seidel array the diagonal blocks are circulant (forcing row shift = column shift)
/// while the off-diagonal blocks are back-circulant (forcing row shift = -column shift), so a
/// common shift `s` needs `s = -s (mod m)`, i.e. `2s = 0`. For even `m` that gives `s = m/2`;
/// for odd `m` no nonzero shift can work.
fn shift_search(m: &Matrix, bw: usize, mm: usize, b: usize) -> Vec<usize> {
    let n = m.n;
    // Rotate position within each length-`b` cyclic run; `b == mm` rotates whole blocks.
    let idx = |i: usize, s: usize| -> usize {
        if i < bw {
            i
        } else {
            let k = (i - bw) / mm;
            let r = (i - bw) % mm;
            let q = r / b;
            let p = r % b;
            bw + k * mm + q * b + (p + s) % b
        }
    };
    let base = m.dephase();
    let mut works = Vec::new();
    for s in 1..b {
        let rows: Vec<Vec<i8>> = (0..n)
            .map(|i| {
                let si = idx(i, s);
                (0..n).map(|j| m.rows[si][idx(j, s)]).collect()
            })
            .collect();
        if (Matrix { n, rows }).dephase().rows == base.rows {
            works.push(s);
        }
    }
    works
}

/// Same exact test, for the multiplier maps `i -> t*i (mod b)` inside each block. These are
/// invisible to the shift search: a multiplier fixes position 0 of every block rather than
/// moving everything, so it shows up as an element with a small fixed set.
fn multiplier_search(m: &Matrix, bw: usize, mm: usize, b: usize) -> Vec<usize> {
    let n = m.n;
    let idx = |i: usize, t: usize| -> usize {
        if i < bw {
            i
        } else {
            let k = (i - bw) / mm;
            let r = (i - bw) % mm;
            let q = r / b;
            let p = r % b;
            bw + k * mm + q * b + (p * t) % b
        }
    };
    let base = m.dephase();
    let mut works = Vec::new();
    for t in 2..b {
        if crate::graph::gcd(t, b) != 1 {
            continue;
        }
        let rows: Vec<Vec<i8>> = (0..n)
            .map(|i| {
                let si = idx(i, t);
                (0..n).map(|j| m.rows[si][idx(j, t)]).collect()
            })
            .collect();
        if (Matrix { n, rows }).dephase().rows == base.rows {
            works.push(t);
        }
    }
    works
}

fn shift_automorphisms(m: &Matrix, bw: usize, mm: usize, sub: Option<usize>) -> serde_json::Value {
    let works = shift_search(m, bw, mm, mm);
    let mut out = json!({
        "block_order": mm,
        "border_width": bw,
        "shifts_realised_by_a_monomial_automorphism": works,
        "cyclic_subgroup_order": works.len() + 1,
        "predicted_by_gs_parity": if mm % 2 == 0 { json!([mm / 2]) } else { json!([]) },
        "note": "exact: dephasing is a complete invariant for the row/column sign group, so a \
                 listed shift is a proved automorphism and an omitted one is proved not to be. \
                 This is a lower bound on |Aut| that needs no graph-isomorphism solver."
    });
    let muls = multiplier_search(m, bw, mm, mm);
    // The subgroup generated by the multipliers found, inside the unit group mod mm.
    let mul_order = {
        let mut set = vec![1usize];
        let mut changed = true;
        while changed {
            changed = false;
            let snap = set.clone();
            for &g in &muls {
                for &x in &snap {
                    let v = (x * g) % mm;
                    if !set.contains(&v) {
                        set.push(v);
                        changed = true;
                    }
                }
            }
        }
        set.len()
    };
    out["multipliers_realised_by_a_monomial_automorphism"] = json!(muls);
    out["multiplier_subgroup_order"] = json!(mul_order);

    // For a block-circulant super-block, the meaningful rotation is inside each sub-block.
    if let Some(b) = sub {
        if b < mm {
            let sw = shift_search(m, bw, mm, b);
            out["sub_block_length"] = json!(b);
            out["sub_block_shifts_realised"] = json!(sw);
            out["sub_block_cyclic_subgroup_order"] = json!(sw.len() + 1);
        }
    }
    out
}

/// For a bordered array: check that each border row is constant on each body block, and that
/// each body row carries a per-slab constant prefix.
fn describe_border(m: &Matrix, bw: usize, mm: usize) -> serde_json::Value {
    let corner: Vec<String> = (0..bw)
        .map(|i| to_pm(&m.rows[i][0..bw].to_vec()))
        .collect();
    let mut row_block_signs = Vec::new();
    let mut rows_constant_on_blocks = true;
    for i in 0..bw {
        let mut signs = String::new();
        for k in 0..4 {
            let seg = &m.rows[i][bw + k * mm..bw + (k + 1) * mm];
            if seg.iter().any(|&v| v != seg[0]) {
                rows_constant_on_blocks = false;
            }
            signs.push(if seg[0] == 1 { '+' } else { '-' });
        }
        row_block_signs.push(signs);
    }
    let mut slab_prefixes = Vec::new();
    let mut prefix_constant_per_slab = true;
    for k in 0..4 {
        let p0: Vec<i8> = m.rows[bw + k * mm][0..bw].to_vec();
        for i in 0..mm {
            if m.rows[bw + k * mm + i][0..bw].to_vec() != p0 {
                prefix_constant_per_slab = false;
            }
        }
        slab_prefixes.push(to_pm(&p0));
    }
    json!({
        "corner": corner,
        "border_row_block_signs": row_block_signs,
        "border_rows_constant_on_each_body_block": rows_constant_on_blocks,
        "slab_column_prefixes": slab_prefixes,
        "column_prefix_constant_within_each_slab": prefix_constant_per_slab
    })
}

fn test_goethals_seidel(m: &Matrix, label: &str) -> TestResult {
    let n = m.n;
    if n % 4 != 0 {
        return TestResult {
            name: format!("goethals_seidel[{label}]"),
            applicable: false,
            found: false,
            variant: None,
            detail: json!({"reason": "n is not divisible by 4"}),
        };
    }
    let bm = n / 4;
    let a = first_row(&sub(m, 0, 0, bm, bm));
    // The (0, j) blocks for j >= 1 are `X R`; recover `X` by reversing the columns.
    let b = first_row(&rev_cols(&sub(m, 0, bm, bm, bm)));
    let c = first_row(&rev_cols(&sub(m, 0, 2 * bm, bm, bm)));
    let d = first_row(&rev_cols(&sub(m, 0, 3 * bm, bm, bm)));
    match construct::goethals_seidel(&a, &b, &c, &d) {
        Ok(h) if h.rows == m.rows => TestResult {
            name: format!("goethals_seidel[{label}]"),
            applicable: true,
            found: true,
            variant: Some("[A BR CR DR; -BR A D^T R -C^T R; -CR -D^T R A B^T R; -DR C^T R -B^T R A]".into()),
            detail: json!({
                "block_order": bm,
                "a": to_pm(&a), "b": to_pm(&b), "c": to_pm(&c), "d": to_pm(&d)
            }),
        },
        Ok(_) => TestResult {
            name: format!("goethals_seidel[{label}]"),
            applicable: true,
            found: false,
            variant: None,
            detail: json!({
                "block_order": bm,
                "reason": "first block row yields circulants meeting the PAF condition, but the \
                           assembled Goethals--Seidel array differs from the input"
            }),
        },
        Err(e) => TestResult {
            name: format!("goethals_seidel[{label}]"),
            applicable: true,
            found: false,
            variant: None,
            detail: json!({"block_order": bm, "reason": e.to_string()}),
        },
    }
}

// ---------------------------------------------------------------------------
// Paley applicability and cyclic structure
// ---------------------------------------------------------------------------

/// Paley applicability at this order, plus a literal comparison against the Paley I matrix when
/// the order admits one and `q` is prime. `found` means "this matrix IS the Paley I matrix (up to
/// dephasing)", not "a Paley matrix of this order exists".
fn test_paley(m: &Matrix) -> TestResult {
    let n = m.n;
    let q1 = n.wrapping_sub(1);
    let pp1 = prime_power(q1);
    let ok1 = pp1.is_some() && q1 % 4 == 3;
    let (q2, pp2, ok2) = if n % 2 == 0 && n >= 4 {
        let q = n / 2 - 1;
        let pp = prime_power(q);
        (Some(q), pp, pp.is_some() && q % 4 == 1)
    } else {
        (None, None, false)
    };
    let mut equals_paley1 = None;
    if ok1 {
        if let Ok(p) = construct::paley1(q1) {
            equals_paley1 = Some(p.dephase().rows == m.dephase().rows);
        }
    }
    TestResult {
        name: "paley_applicability".into(),
        applicable: true,
        found: equals_paley1 == Some(true),
        variant: if equals_paley1 == Some(true) {
            Some("Paley I (literal match after dephasing)".into())
        } else {
            None
        },
        detail: json!({
            "paley_I": {
                "q": q1,
                "prime_power": pp1.map(|(p, k)| format!("{p}^{k}")),
                "q_mod_4": q1 % 4,
                "construction_exists_at_this_order": ok1,
                "matrix_equals_paley_I_after_dephasing": equals_paley1
            },
            "paley_II": {
                "q": q2,
                "prime_power": pp2.map(|(p, k)| format!("{p}^{k}")),
                "q_mod_4": q2.map(|q| q % 4),
                "construction_exists_at_this_order": ok2
            },
            "caveat": "the literal comparison is only run when q is prime (the built-in Paley I \
                       generator does not implement non-prime prime powers), and only detects the \
                       matrix in exactly the generated row/column order up to dephasing"
        }),
    }
}

fn test_cyclic_from_aut(n: usize, aut: Option<&AutReport>) -> TestResult {
    match aut {
        None => TestResult {
            name: "cyclic_block_structure_from_aut".into(),
            applicable: false,
            found: false,
            variant: None,
            detail: json!({"reason": "automorphism group not computed (pass --with-aut)"}),
        },
        Some(a) => {
            // Block orders whose cyclic shift would show up as an element of that order:
            // n/4 for Williamson and Goethals--Seidel, n/2 for a pure two-circulant form, and
            // (n-2)/2 for a bordered two-circulant (Legendre pair) core. At n = 668 these are
            // 167, 334 and 333.
            let interesting: Vec<usize> = [n / 4, (n - 2) / 2, n / 2]
                .into_iter()
                .filter(|&k| k > 1)
                .collect();
            // A bordered core of length ell fixes the 2 border rows and 2 border columns, each
            // with both signs: 4 fixed row vertices and 4 fixed column vertices.
            let bordered_sig: Vec<serde_json::Value> = a
                .cyclic_structure_found
                .iter()
                .filter(|e| interesting.contains(&e.order))
                .map(|e| {
                    // A border of `b` rows and `b` columns fixes 2b row and 2b column vertices.
                    let implied_border = if e.fixed_row_vertices == e.fixed_col_vertices
                        && e.fixed_row_vertices % 2 == 0
                    {
                        Some(e.fixed_row_vertices / 2)
                    } else {
                        None
                    };
                    let shape = match (e.fixed_points, implied_border) {
                        (0, _) => "consistent with an unbordered block-circulant shift \
                                   (fixed-point-free)"
                            .to_string(),
                        (_, Some(b)) => format!(
                            "consistent with a bordered block-circulant core shift, implied \
                             border {b} rows and {b} columns"
                        ),
                        _ => "uniform cycles away from a small fixed set of another shape"
                            .to_string(),
                    };
                    json!({
                        "order": e.order,
                        "fixed_points": e.fixed_points,
                        "fixed_row_vertices": e.fixed_row_vertices,
                        "fixed_col_vertices": e.fixed_col_vertices,
                        "shape": shape
                    })
                })
                .collect();
            let gens: Vec<serde_json::Value> = a
                .generator_cycle_data
                .iter()
                .map(|g| {
                    json!({
                        "order": g.order,
                        "semiregular": g.semiregular,
                        "cycle_lengths": g.cycle_lengths,
                        "fixed_points": g.fixed_points,
                        "row_cycle_lengths": g.row_cycle_lengths
                    })
                })
                .collect();
            TestResult {
                name: "cyclic_block_structure_from_aut".into(),
                applicable: true,
                found: !bordered_sig.is_empty(),
                variant: if bordered_sig.is_empty() {
                    None
                } else {
                    Some(format!(
                        "cyclic element(s) at block order(s) {:?}",
                        bordered_sig
                            .iter()
                            .filter_map(|v| v.get("order").and_then(|o| o.as_u64()))
                            .collect::<Vec<_>>()
                    ))
                },
                detail: json!({
                    "block_orders_of_interest": interesting,
                    "matches_at_block_orders": bordered_sig,
                    "largest_strictly_semiregular_order": a.max_semiregular_order_found,
                    "cyclic_elements_found": a.cyclic_structure_found,
                    "sampled_element_orders": a.sampled_element_orders,
                    "random_words_sampled": a.random_words_sampled,
                    "aut_graph_order": a.aut_graph_order_raw,
                    "generators": gens,
                    "caveat": "SCREEN ONLY. A hit says the automorphism group contains an \
                               element whose cycle shape is consistent with that block order; it \
                               does NOT establish the form -- the Sylvester matrix of order 16 \
                               produces a spurious order-7 hit with the bordered cycle shape. \
                               The direct block tests (two_circulant, bordered_two_circulant, \
                               williamson, goethals_seidel) are the authoritative ones. Absence \
                               is likewise evidence, not proof: this is a randomized walk over \
                               nauty's generators, not a cyclic-subgroup classification. \
                               Elements are kept only when every cycle has length 1 or `order` \
                               and at most HAD668_FIXED_CAP points are fixed (default 16; a \
                               border of b rows and b columns fixes 2b + 2b)."
                }),
            }
        }
    }
}

// ---------------------------------------------------------------------------

pub fn classify(m: &Matrix, aut: Option<AutReport>) -> ClassifyReport {
    let (ok, worst, _) = m.check_orthogonality();
    let deph = m.dephase();
    let mut tests = Vec::new();
    for (label, mat) in [("as_given", m), ("dephased", &deph)] {
        tests.push(test_two_circulant(mat, label));
        tests.push(test_bordered(mat, label));
        tests.push(test_williamson(mat, label));
        tests.push(test_goethals_seidel(mat, label));
        tests.push(test_gs_array(mat, label));
    }
    tests.push(test_paley(m));
    tests.push(test_cyclic_from_aut(m.n, aut.as_ref()));
    let forms_found = tests
        .iter()
        .filter(|t| t.found)
        .map(|t| t.name.clone())
        .collect();
    ClassifyReport {
        n: m.n,
        verified_hadamard: m.is_square() && ok,
        max_abs_offdiag: worst,
        sha256_canonical_as_given: m.sha256_canonical(),
        sha256_canonical_normalized: deph.sha256_canonical(),
        tested_variants: vec!["as_given".into(), "dephased".into()],
        tests,
        forms_found,
        aut,
    }
}

// ---------------------------------------------------------------------------
// Multiplier groups, computed on the sequences rather than on the matrix.
// ---------------------------------------------------------------------------

/// Why the matrix-level `multiplier_search` misses these: it applies `i -> t*i` to rows and
/// columns uniformly. That preserves a circulant diagonal block, whose entry depends on `j - i`,
/// but *not* a back-circulant off-diagonal block `X_k R`, whose entry is `c[i + j]`: the map
/// sends it to `c[t(i+j) + d]`, and invariance forces the compensating shift `d = t - 1 (mod m)`
/// on every block-column except the first. Without that shift every non-trivial multiplier is
/// rejected, which is exactly what happened. The sequence-level test below has no such blind
/// spot, and `matrix_multipliers_with_compensating_shift` re-checks the survivors against the
/// full matrix with the derived shift applied.
fn units_mod(m: usize) -> Vec<usize> {
    (1..m).filter(|&t| crate::graph::gcd(t, m) == 1).collect()
}

fn closure_mod(gens: &[usize], m: usize) -> Vec<usize> {
    let mut set = vec![1usize];
    let mut changed = true;
    while changed {
        changed = false;
        let snap = set.clone();
        for &g in gens {
            for &x in &snap {
                let v = (x * g) % m;
                if !set.contains(&v) {
                    set.push(v);
                    changed = true;
                }
            }
        }
    }
    set.sort_unstable();
    set
}

/// `t` is a fixed multiplier of the sequence set when `X_k[t*i] = X_k[i]` for every block and
/// every `i` -- untranslated, unsigned, identity block permutation.
fn fixed_multiplier_group(seqs: &[Vec<i8>], m: usize) -> Vec<usize> {
    units_mod(m)
        .into_iter()
        .filter(|&t| {
            seqs.iter()
                .all(|s| (0..m).all(|i| s[(t * i) % m] == s[i]))
        })
        .collect()
}

/// The same, but allowing each sequence its own sign and shift: `X_k[t*i] = eps * X_k[i + sh]`.
fn translated_multiplier_group(seqs: &[Vec<i8>], m: usize) -> Vec<usize> {
    units_mod(m)
        .into_iter()
        .filter(|&t| {
            seqs.iter().all(|s| {
                let y: Vec<i8> = (0..m).map(|i| s[(t * i) % m]).collect();
                [1i8, -1].iter().any(|&eps| {
                    (0..m).any(|sh| (0..m).all(|i| y[i] == eps * s[(i + sh) % m]))
                })
            })
        })
        .collect()
}

/// Re-verify a sequence multiplier against the whole matrix. The map is `i -> t*i + r` on rows
/// and columns alike, with the *same* offset `r` in every block, chosen so that `2r = t - 1`.
///
/// Derivation. A diagonal block is circulant, entry `a[j - i]`, and `a[t(j-i)] = a[j-i]` needs
/// the row and column offsets to agree. An off-diagonal block is back-circulant, entry
/// `b[m-1-i-j]`, and the same map sends it to `b[m-1-t(i+j)-2r]`; with `b[tx] = b[x]` that equals
/// `b[t^-1(m-1-2r) - (i+j)]`, which is the original iff `2r = t - 1 (mod m)`. So the offset is
/// forced and shared, not per-block-column -- getting that wrong rejects every multiplier.
/// `2` is invertible for odd `m`; for even `m` every unit `t` is odd, so `t - 1` is even and
/// both solutions `r` and `r + m/2` are tried.
fn matrix_multipliers_with_compensating_shift(
    mat: &Matrix,
    bw: usize,
    mm: usize,
    cands: &[usize],
) -> Vec<usize> {
    let n = mat.n;
    let base = mat.dephase();
    let mut ok = Vec::new();
    for &t in cands {
        if t == 1 {
            continue;
        }
        let offsets: Vec<usize> = if mm % 2 == 1 {
            vec![((t + mm - 1) % mm) * ((mm + 1) / 2) % mm]
        } else if (t + mm - 1) % mm % 2 == 0 {
            let r = ((t + mm - 1) % mm) / 2;
            vec![r, (r + mm / 2) % mm]
        } else {
            vec![]
        };
        for r in offsets {
            let map = |i: usize| -> usize {
                if i < bw {
                    i
                } else {
                    let k = (i - bw) / mm;
                    let p = (i - bw) % mm;
                    bw + k * mm + (p * t + r) % mm
                }
            };
            let rows: Vec<Vec<i8>> = (0..n)
                .map(|i| {
                    let si = map(i);
                    (0..n).map(|j| mat.rows[si][map(j)]).collect()
                })
                .collect();
            if (Matrix { n, rows }).dephase().rows == base.rows {
                ok.push(t);
                break;
            }
        }
    }
    ok
}

pub fn multiplier_report_for_sequences(
    mat: &Matrix,
    bw: usize,
    mm: usize,
    seqs: &[Vec<i8>],
) -> serde_json::Value {
    let fixed = fixed_multiplier_group(seqs, mm);
    let translated = translated_multiplier_group(seqs, mm);
    // Smallest element whose powers give the whole group, when the group is cyclic.
    let gen = fixed
        .iter()
        .find(|&&g| g != 1 && closure_mod(&[g], mm) == fixed)
        .copied();
    let verified = matrix_multipliers_with_compensating_shift(mat, bw, mm, &fixed);
    json!({
        "modulus": mm,
        "fixed_multiplier_group": fixed,
        "fixed_multiplier_group_order": fixed.len(),
        "cyclic_generator": gen,
        "is_cyclic": gen.is_some() || fixed.len() == 1,
        "translated_multiplier_group": translated,
        "translated_multiplier_group_order": translated.len(),
        "verified_on_matrix_with_compensating_shift": verified,
        "definition": "t in (Z/m)* with X_k[t*i] = X_k[i] for all four sequences and all i \
                       (untranslated, unsigned, identity block permutation); the translated \
                       variant allows each sequence its own sign and shift",
        "note": "computed on the sequences. The matrix-level test needs the compensating shift \
                 t-1 on every block-column after the first, because the off-diagonal blocks are \
                 back-circulant; omitting it rejects every non-trivial multiplier."
    })
}
