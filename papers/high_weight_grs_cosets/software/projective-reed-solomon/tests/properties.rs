use projective_reed_solomon::{
    locator_from_support, normalize_projective, recover_magnitudes, split_support, Field,
    FieldSpec, Root,
};
use proptest::prelude::*;
use proptest::test_runner::{Config as ProptestConfig, RngSeed};

const ENCODING: &str = "polynomial-basis-base-p-integer-v1";

fn prime_inputs() -> impl Strategy<Value = (u32, u32, u32, u32)> {
    prop::sample::select(vec![2u32, 3, 5, 7, 11, 13]).prop_flat_map(|p| (Just(p), 0..p, 0..p, 0..p))
}

fn extension_inputs() -> impl Strategy<Value = (FieldSpec, u32, u32, u32)> {
    prop_oneof![
        (0u32..8, 0u32..8, 0u32..8).prop_map(|(a, b, c)| {
            (
                FieldSpec {
                    p: 2,
                    degree: 3,
                    modulus: vec![1, 1, 0, 1],
                    encoding: ENCODING.into(),
                },
                a,
                b,
                c,
            )
        }),
        (0u32..9, 0u32..9, 0u32..9).prop_map(|(a, b, c)| {
            (
                FieldSpec {
                    p: 3,
                    degree: 2,
                    modulus: vec![1, 0, 1],
                    encoding: ENCODING.into(),
                },
                a,
                b,
                c,
            )
        }),
    ]
}

fn projective_inputs() -> impl Strategy<Value = (u32, Vec<u32>, u32)> {
    prop::sample::select(vec![3u32, 5, 7, 11])
        .prop_flat_map(|p| (Just(p), prop::collection::vec(0..p, 5), 1..p))
}

fn prime_field(p: u32) -> Field {
    Field::new(FieldSpec {
        p,
        degree: 1,
        modulus: vec![0, 1],
        encoding: ENCODING.into(),
    })
    .expect("listed characteristic is prime")
}

proptest! {
    #![proptest_config(ProptestConfig {
        cases: 256,
        rng_seed: RngSeed::Fixed(0x5052_532d_5631),
        ..ProptestConfig::default()
    })]

    #[test]
    fn prime_field_operations_obey_field_laws((p, a, b, c) in prime_inputs()) {
        let field = prime_field(p);
        prop_assert_eq!(field.add(field.add(a, b), c), field.add(a, field.add(b, c)));
        prop_assert_eq!(field.mul(field.mul(a, b), c), field.mul(a, field.mul(b, c)));
        prop_assert_eq!(field.mul(a, field.add(b, c)), field.add(field.mul(a, b), field.mul(a, c)));
        prop_assert_eq!(field.add(a, field.neg(a)), 0);
        prop_assert_eq!(field.pow(a, u64::from(p)), a);
        if a != 0 {
            prop_assert_eq!(field.mul(a, field.inv(a).expect("nonzero inverse")), 1);
        }
    }

    #[test]
    fn extension_field_operations_obey_field_laws((spec, a, b, c) in extension_inputs()) {
        let field = Field::new(spec).expect("fixed modulus is irreducible");
        prop_assert_eq!(field.add(field.add(a, b), c), field.add(a, field.add(b, c)));
        prop_assert_eq!(field.mul(field.mul(a, b), c), field.mul(a, field.mul(b, c)));
        prop_assert_eq!(field.mul(a, field.add(b, c)), field.add(field.mul(a, b), field.mul(a, c)));
        prop_assert_eq!(field.pow(a, u64::from(field.order())), a);
        if a != 0 {
            prop_assert_eq!(field.mul(a, field.inv(a).expect("nonzero inverse")), 1);
        }
    }

    #[test]
    fn projective_normalization_is_scale_invariant((p, vector, scale) in projective_inputs()) {
        prop_assume!(vector.iter().any(|&entry| entry != 0));
        let field = prime_field(p);
        let scaled: Vec<u32> = vector.iter().map(|&entry| field.mul(scale, entry)).collect();
        prop_assert_eq!(
            normalize_projective(&field, &vector).expect("nonzero vector"),
            normalize_projective(&field, &scaled).expect("nonzero scaled vector"),
        );
    }

    #[test]
    fn locator_support_round_trip(bits in prop::collection::vec(any::<bool>(), 8)) {
        let field = prime_field(7);
        let support: Vec<Root> = bits
            .into_iter()
            .enumerate()
            .filter_map(|(index, include)| {
                include.then_some(if index == 7 {
                    Root::Infinity
                } else {
                    Root::Finite(index as u32)
                })
            })
            .collect();
        prop_assume!(!support.is_empty() && support.len() <= 5);
        let locator = locator_from_support(&field, &support).expect("distinct support");
        prop_assert_eq!(split_support(&field, &locator), Some(support));
    }

    #[test]
    fn magnitude_recovery_inverts_syndrome_synthesis(
        bits in prop::collection::vec(any::<bool>(), 8),
        raw_magnitudes in prop::collection::vec(1u32..7, 8),
    ) {
        let field = prime_field(7);
        let selected: Vec<(Root, u32)> = bits
            .into_iter()
            .zip(raw_magnitudes)
            .enumerate()
            .filter_map(|(index, (include, magnitude))| {
                include.then_some((
                    if index == 7 { Root::Infinity } else { Root::Finite(index as u32) },
                    magnitude,
                ))
            })
            .collect();
        prop_assume!(!selected.is_empty() && selected.len() <= 5);
        let support: Vec<Root> = selected.iter().map(|(root, _)| *root).collect();
        let magnitudes: Vec<u32> = selected.iter().map(|(_, magnitude)| *magnitude).collect();
        let mut syndrome = vec![0u32; 5];
        for (root, magnitude) in &selected {
            for (index, coordinate) in syndrome.iter_mut().enumerate() {
                let value = match root {
                    Root::Finite(x) => field.pow(*x, index as u64),
                    Root::Infinity => u32::from(index == 4),
                };
                *coordinate = field.add(*coordinate, field.mul(*magnitude, value));
            }
        }
        prop_assert_eq!(recover_magnitudes(&field, &syndrome, &support), Some(magnitudes));
    }
}
