use criterion::{Criterion, criterion_group, criterion_main};
use sparse_shadow_core::{InputArtifact, canonicalize, verify_certificate};

fn paper_i(c: &mut Criterion) {
    let input: InputArtifact = serde_json::from_str(include_str!(
        "../../../fixtures/paper-i-icosahedral-orbitals.json"
    ))
    .expect("committed fixture parses");
    let certificate = canonicalize(&input)
        .expect("fixture canonicalizes")
        .certificate;

    c.bench_function("paper_i/canonicalize_end_to_end", |bench| {
        bench.iter(|| {
            let _ = canonicalize(std::hint::black_box(&input));
        });
    });
    c.bench_function("paper_i/independent_replay_end_to_end", |bench| {
        bench.iter(|| {
            let _ = verify_certificate(
                std::hint::black_box(&input),
                std::hint::black_box(&certificate),
            );
        });
    });
}

criterion_group!(benches, paper_i);
criterion_main!(benches);
