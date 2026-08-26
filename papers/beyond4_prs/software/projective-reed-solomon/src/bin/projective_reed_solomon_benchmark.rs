use clap::Parser;
use projective_reed_solomon::{
    canonicalize_syndrome, classify, search_fast_terminal_locator, search_locator,
    verify_deep_certificate, DeepCertificate, Field, FieldSpec, Request, REQUEST_SCHEMA,
};
use serde::Serialize;
use std::hint::black_box;
use std::time::Instant;

#[derive(Parser)]
#[command(name = "projective-reed-solomon-benchmark")]
struct Args {
    #[arg(long, default_value_t = 1)]
    iterations: u32,
    #[arg(long, default_value_t = 10_000_000)]
    candidate_limit: u64,
    /// Include GF(8), GF(9), GF(16), and the slower GF(32)/R17 structural row.
    #[arg(long)]
    extension_fields: bool,
}

#[derive(Serialize)]
struct BenchmarkReport {
    schema: &'static str,
    crate_version: &'static str,
    build_profile: &'static str,
    iterations: u32,
    rows: Vec<BenchmarkRow>,
}

#[derive(Serialize)]
struct BenchmarkRow {
    operation: String,
    field_order: u32,
    redundancy: usize,
    elapsed_ns_total: u128,
    elapsed_ns_per_iteration: u128,
    candidates_examined: Option<u64>,
    baseline: &'static str,
}

fn prime_field(p: u32) -> FieldSpec {
    FieldSpec {
        p,
        degree: 1,
        modulus: vec![0, 1],
        encoding: "polynomial-basis-base-p-integer-v1".into(),
    }
}

fn gf8() -> FieldSpec {
    FieldSpec {
        p: 2,
        degree: 3,
        modulus: vec![1, 1, 0, 1],
        encoding: "polynomial-basis-base-p-integer-v1".into(),
    }
}

fn gf9() -> FieldSpec {
    FieldSpec {
        p: 3,
        degree: 2,
        modulus: vec![1, 0, 1],
        encoding: "polynomial-basis-base-p-integer-v1".into(),
    }
}

fn gf16() -> FieldSpec {
    FieldSpec {
        p: 2,
        degree: 4,
        modulus: vec![1, 1, 0, 0, 1],
        encoding: "polynomial-basis-base-p-integer-v1".into(),
    }
}

fn gf32() -> FieldSpec {
    FieldSpec {
        p: 2,
        degree: 5,
        modulus: vec![1, 0, 1, 0, 0, 1],
        encoding: "polynomial-basis-base-p-integer-v1".into(),
    }
}

fn request(field: FieldSpec, redundancy: usize, syndrome: Vec<u32>) -> Request {
    Request {
        schema: REQUEST_SCHEMA.into(),
        field,
        redundancy,
        evaluation: "full-projective-nrc-v1".into(),
        syndrome,
        operation: None,
    }
}

fn r11_sigma() -> Result<Request, projective_reed_solomon::Error> {
    let field_spec = prime_field(13);
    let field = Field::new(field_spec.clone())?;
    let quadratic = (1..13)
        .flat_map(|constant| (0..13).map(move |linear| vec![constant, linear, 1]))
        .find(|candidate| (0..13).all(|x| field.eval(candidate, x) != 0))
        .expect("a finite field has irreducible quadratics");
    let mut syndrome = vec![1, 1];
    while syndrome.len() < 11 {
        let last = syndrome.len() - 1;
        syndrome.push(field.neg(field.add(
            field.mul(quadratic[1], syndrome[last]),
            field.mul(quadratic[0], syndrome[last - 1]),
        )));
    }
    Ok(request(field_spec, 11, syndrome))
}

fn elapsed<F, T>(iterations: u32, mut operation: F) -> Result<u128, Box<dyn std::error::Error>>
where
    F: FnMut() -> Result<T, projective_reed_solomon::Error>,
{
    let start = Instant::now();
    for _ in 0..iterations {
        black_box(operation()?);
    }
    Ok(start.elapsed().as_nanos())
}

fn terminal_rows(
    request: &Request,
    q: u32,
    iterations: u32,
    candidate_limit: u64,
) -> Result<Vec<BenchmarkRow>, Box<dyn std::error::Error>> {
    let selector_certificate = search_fast_terminal_locator(request, candidate_limit)?;
    let selector_elapsed = elapsed(iterations, || {
        search_fast_terminal_locator(request, candidate_limit)
    })?;
    let oracle_certificate = search_locator(request, request.redundancy - 1, candidate_limit)?;
    let oracle_elapsed = elapsed(iterations, || {
        search_locator(request, request.redundancy - 1, candidate_limit)
    })?;
    Ok(vec![
        BenchmarkRow {
            operation: format!("r{}_terminal_12_point_selector", request.redundancy),
            field_order: q,
            redundancy: request.redundancy,
            elapsed_ns_total: selector_elapsed,
            elapsed_ns_per_iteration: selector_elapsed / u128::from(iterations),
            candidates_examined: Some(selector_certificate.candidates_examined),
            baseline: "streamed degree-(r-4) prefix supports; two fixed 12-point charts",
        },
        BenchmarkRow {
            operation: format!("r{}_projective_locator_oracle", request.redundancy),
            field_order: q,
            redundancy: request.redundancy,
            elapsed_ns_total: oracle_elapsed,
            elapsed_ns_per_iteration: oracle_elapsed / u128::from(iterations),
            candidates_examined: Some(oracle_certificate.candidates_examined),
            baseline: "increasing-degree projective Hankel-kernel enumeration through r-1",
        },
    ])
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = Args::parse();
    if args.iterations == 0 {
        return Err("--iterations must be positive".into());
    }
    let r5 = request(prime_field(7), 5, vec![0, 0, 0, 1, 0]);
    let r5_sigma_rootless = request(prime_field(7), 5, vec![1, 1, 6, 6, 1]);
    let r6 = request(prime_field(17), 6, vec![0, 0, 0, 0, 1, 0]);
    let r6_sigma = request(prime_field(17), 6, vec![0, 1, 0, 3, 0, 9]);
    let r7 = request(prime_field(7), 7, vec![0, 0, 0, 0, 1, 0, 0]);
    let mut r11_tangent_syndrome = vec![0; 11];
    r11_tangent_syndrome[9] = 1;
    let r11_tangent = request(prime_field(13), 11, r11_tangent_syndrome);
    let r11_sigma = r11_sigma()?;
    let mut r13_multiple_syndrome = vec![0; 13];
    r13_multiple_syndrome[2] = 1;
    r13_multiple_syndrome[12] = 2;
    let r13_multiple = request(prime_field(13), 13, r13_multiple_syndrome);
    let mut rows = Vec::new();
    rows.extend(terminal_rows(
        &r5,
        7,
        args.iterations,
        args.candidate_limit,
    )?);
    rows.extend(terminal_rows(
        &r6,
        17,
        args.iterations,
        args.candidate_limit,
    )?);
    rows.extend(terminal_rows(
        &r7,
        7,
        args.iterations,
        args.candidate_limit,
    )?);
    if args.extension_fields {
        let r5_q8 = request(gf8(), 5, vec![0, 0, 1, 0, 0]);
        let r5_q9_wild = request(gf9(), 5, vec![0, 0, 1, 0, 4]);
        let mut r16_q16_syndrome = vec![0; 16];
        r16_q16_syndrome[2] = 1;
        r16_q16_syndrome[15] = 2;
        let r16_q16 = request(gf16(), 16, r16_q16_syndrome);
        let r17_q32 = request(
            gf32(),
            17,
            (0..17).map(|i| (i * i + 3 * i + 1) % 32).collect(),
        );
        rows.extend(terminal_rows(
            &r5_q8,
            8,
            args.iterations,
            args.candidate_limit,
        )?);
        let canonicalization = canonicalize_syndrome(&r5_q8, args.candidate_limit)?;
        let canonical_elapsed = elapsed(args.iterations, || {
            canonicalize_syndrome(&r5_q8, args.candidate_limit)
        })?;
        rows.push(BenchmarkRow {
            operation: "r5_q8_extension_field_canonicalization".into(),
            field_order: 8,
            redundancy: 5,
            elapsed_ns_total: canonical_elapsed,
            elapsed_ns_per_iteration: canonical_elapsed / u128::from(args.iterations),
            candidates_examined: Some(canonicalization.transporters_examined),
            baseline: "polynomial-basis GF(8), maximal-root lex chart",
        });
        let classification = classify(&r5_q8, args.candidate_limit, args.candidate_limit)?;
        let certificate = classification
            .deep_certificate
            .ok_or("R5 q=8 extension fixture did not produce a deep certificate")?;
        let classify_elapsed = elapsed(args.iterations, || {
            classify(&r5_q8, args.candidate_limit, args.candidate_limit)
        })?;
        rows.push(BenchmarkRow {
            operation: "r5_q8_extension_field_classify".into(),
            field_order: 8,
            redundancy: 5,
            elapsed_ns_total: classify_elapsed,
            elapsed_ns_per_iteration: classify_elapsed / u128::from(args.iterations),
            candidates_examined: None,
            baseline: "GF(8) locator rejection, family route, and reduced semilinear transport",
        });
        let verify_elapsed = elapsed(args.iterations, || {
            verify_deep_certificate(&certificate, args.candidate_limit)
        })?;
        rows.push(BenchmarkRow {
            operation: "r5_q8_extension_field_positive_replay".into(),
            field_order: 8,
            redundancy: 5,
            elapsed_ns_total: verify_elapsed,
            elapsed_ns_per_iteration: verify_elapsed / u128::from(args.iterations),
            candidates_examined: None,
            baseline: "GF(8) frozen orbit, transporter, split-free, and radius replay",
        });
        let q9_wild_canonicalization = canonicalize_syndrome(&r5_q9_wild, args.candidate_limit)?;
        let q9_wild_elapsed = elapsed(args.iterations, || {
            canonicalize_syndrome(&r5_q9_wild, args.candidate_limit)
        })?;
        rows.push(BenchmarkRow {
            operation: "r5_q9_lucas_degenerate_canonicalization".into(),
            field_order: 9,
            redundancy: 5,
            elapsed_ns_total: q9_wild_elapsed,
            elapsed_ns_per_iteration: q9_wild_elapsed / u128::from(args.iterations),
            candidates_examined: Some(q9_wild_canonicalization.transporters_examined),
            baseline: "Lucas-degenerate maximal-root stabilizers: O(m*r*q^2)",
        });
        let q16_r16_canonicalization = canonicalize_syndrome(&r16_q16, args.candidate_limit)?;
        let q16_r16_elapsed = elapsed(args.iterations, || {
            canonicalize_syndrome(&r16_q16, args.candidate_limit)
        })?;
        rows.push(BenchmarkRow {
            operation: "r16_q16_extension_structural_canonicalization".into(),
            field_order: 16,
            redundancy: 16,
            elapsed_ns_total: q16_r16_elapsed,
            elapsed_ns_per_iteration: q16_r16_elapsed / u128::from(args.iterations),
            candidates_examined: Some(q16_r16_canonicalization.transporters_examined),
            baseline: "full-length-boundary maximal-root chart; no R16 coding verdict",
        });
        let q32_r17_canonicalization = canonicalize_syndrome(&r17_q32, args.candidate_limit)?;
        let q32_r17_elapsed = elapsed(args.iterations, || {
            canonicalize_syndrome(&r17_q32, args.candidate_limit)
        })?;
        rows.push(BenchmarkRow {
            operation: "r17_q32_characteristic_power_canonicalization".into(),
            field_order: 32,
            redundancy: 17,
            elapsed_ns_total: q32_r17_elapsed,
            elapsed_ns_per_iteration: q32_r17_elapsed / u128::from(args.iterations),
            candidates_examined: Some(q32_r17_canonicalization.transporters_examined),
            baseline: "characteristic-power rooted chart; no R17 coding verdict",
        });
    }

    let canonicalization = canonicalize_syndrome(&r6, args.candidate_limit)?;
    let canonical_elapsed = elapsed(args.iterations, || {
        canonicalize_syndrome(&r6, args.candidate_limit)
    })?;
    rows.push(BenchmarkRow {
        operation: "r6_tangent_semilinear_canonicalization".into(),
        field_order: 17,
        redundancy: 6,
        elapsed_ns_total: canonical_elapsed,
        elapsed_ns_per_iteration: canonical_elapsed / u128::from(args.iterations),
        candidates_examined: Some(canonicalization.transporters_examined),
        baseline: "tangent gcd root sent to infinity; m*q*(q-1) affine transports",
    });
    let rootless_sigma_canonicalization =
        canonicalize_syndrome(&r5_sigma_rootless, args.candidate_limit)?;
    let rootless_sigma_elapsed = elapsed(args.iterations, || {
        canonicalize_syndrome(&r5_sigma_rootless, args.candidate_limit)
    })?;
    rows.push(BenchmarkRow {
        operation: "r5_sigma_rootless_semilinear_canonicalization".into(),
        field_order: 7,
        redundancy: 5,
        elapsed_ns_total: rootless_sigma_elapsed,
        elapsed_ns_per_iteration: rootless_sigma_elapsed / u128::from(args.iterations),
        candidates_examined: Some(rootless_sigma_canonicalization.transporters_examined),
        baseline: "rootless syndrome form; lex-forced second coordinate: m*(q^2-1)",
    });
    let sigma_canonicalization = canonicalize_syndrome(&r6_sigma, args.candidate_limit)?;
    let sigma_elapsed = elapsed(args.iterations, || {
        canonicalize_syndrome(&r6_sigma, args.candidate_limit)
    })?;
    rows.push(BenchmarkRow {
        operation: "r6_sigma_simple_root_semilinear_canonicalization".into(),
        field_order: 17,
        redundancy: 6,
        elapsed_ns_total: sigma_elapsed,
        elapsed_ns_per_iteration: sigma_elapsed / u128::from(args.iterations),
        candidates_examined: Some(sigma_canonicalization.transporters_examined),
        baseline: "simple rational syndrome-form root; lex-forced prefix: O(m*r*q)",
    });
    let r11_tangent_canonicalization = canonicalize_syndrome(&r11_tangent, args.candidate_limit)?;
    let r11_tangent_elapsed = elapsed(args.iterations, || {
        canonicalize_syndrome(&r11_tangent, args.candidate_limit)
    })?;
    rows.push(BenchmarkRow {
        operation: "r11_tangent_structural_canonicalization".into(),
        field_order: 13,
        redundancy: 11,
        elapsed_ns_total: r11_tangent_elapsed,
        elapsed_ns_per_iteration: r11_tangent_elapsed / u128::from(args.iterations),
        candidates_examined: Some(r11_tangent_canonicalization.transporters_examined),
        baseline: "dimension-independent tangent chart; no R11 coding verdict",
    });
    let r11_sigma_canonicalization = canonicalize_syndrome(&r11_sigma, args.candidate_limit)?;
    let r11_sigma_elapsed = elapsed(args.iterations, || {
        canonicalize_syndrome(&r11_sigma, args.candidate_limit)
    })?;
    rows.push(BenchmarkRow {
        operation: "r11_sigma_structural_canonicalization".into(),
        field_order: 13,
        redundancy: 11,
        elapsed_ns_total: r11_sigma_elapsed,
        elapsed_ns_per_iteration: r11_sigma_elapsed / u128::from(args.iterations),
        candidates_examined: Some(r11_sigma_canonicalization.transporters_examined),
        baseline: "dimension-independent binary-form chart; no R11 coding verdict",
    });
    let r13_multiple_canonicalization = canonicalize_syndrome(&r13_multiple, args.candidate_limit)?;
    let r13_multiple_elapsed = elapsed(args.iterations, || {
        canonicalize_syndrome(&r13_multiple, args.candidate_limit)
    })?;
    rows.push(BenchmarkRow {
        operation: "r13_multiple_root_structural_canonicalization".into(),
        field_order: 13,
        redundancy: 13,
        elapsed_ns_total: r13_multiple_elapsed,
        elapsed_ns_per_iteration: r13_multiple_elapsed / u128::from(args.iterations),
        candidates_examined: Some(r13_multiple_canonicalization.transporters_examined),
        baseline: "dimension-independent maximal-root chart; no R13 coding verdict",
    });

    let classification = classify(&r6, args.candidate_limit, args.candidate_limit)?;
    let deep_certificate: DeepCertificate = classification
        .deep_certificate
        .ok_or("R6 benchmark fixture did not produce a deep certificate")?;
    let classify_elapsed = elapsed(args.iterations, || {
        classify(&r6, args.candidate_limit, args.candidate_limit)
    })?;
    rows.push(BenchmarkRow {
        operation: "r6_end_to_end_classify".into(),
        field_order: 17,
        redundancy: 6,
        elapsed_ns_total: classify_elapsed,
        elapsed_ns_per_iteration: classify_elapsed / u128::from(args.iterations),
        candidates_examined: None,
        baseline: "intrinsic family detection plus tangent-restricted canonicalization",
    });
    let verify_elapsed = elapsed(args.iterations, || {
        verify_deep_certificate(&deep_certificate, args.candidate_limit)
    })?;
    rows.push(BenchmarkRow {
        operation: "r6_positive_certificate_replay".into(),
        field_order: 17,
        redundancy: 6,
        elapsed_ns_total: verify_elapsed,
        elapsed_ns_per_iteration: verify_elapsed / u128::from(args.iterations),
        candidates_examined: None,
        baseline: "independent domain, transporter, family, split-free, and radius replay",
    });

    println!(
        "{}",
        serde_json::to_string_pretty(&BenchmarkReport {
            schema: "prs-benchmark-report-v1",
            crate_version: env!("CARGO_PKG_VERSION"),
            build_profile: if cfg!(debug_assertions) {
                "debug"
            } else {
                "release"
            },
            iterations: args.iterations,
            rows,
        })?
    );
    Ok(())
}
