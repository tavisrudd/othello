use criterion::{criterion_group, criterion_main, Criterion, Throughput};
use ergodis::{PrimePolynomialRecurrence, PrimeQuadraticCharacter};
use std::hint::black_box;

fn character_sum(c: &mut Criterion) {
    const MODULUS: u32 = 65_537;
    let coefficients = [3, 2, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47];
    let character = PrimeQuadraticCharacter::new(MODULUS).unwrap();
    let mut recurrence = PrimePolynomialRecurrence::compile(MODULUS, &coefficients).unwrap();
    let expected = character.polynomial_census_reduced(&coefficients).unwrap();
    assert_eq!(
        character
            .polynomial_census_recurrence(&mut recurrence)
            .unwrap(),
        expected
    );

    let mut group = c.benchmark_group("prime_polynomial_character_census");
    group.throughput(Throughput::Elements(u64::from(MODULUS)));
    group.bench_function("horner_degree_14", |b| {
        b.iter(|| {
            black_box(
                character
                    .polynomial_census_reduced(black_box(&coefficients))
                    .unwrap(),
            )
        });
    });
    group.bench_function("finite_difference_degree_14", |b| {
        b.iter(|| {
            black_box(
                character
                    .polynomial_census_recurrence(black_box(&mut recurrence))
                    .unwrap(),
            )
        });
    });
    group.finish();
}

criterion_group!(benches, character_sum);
criterion_main!(benches);
