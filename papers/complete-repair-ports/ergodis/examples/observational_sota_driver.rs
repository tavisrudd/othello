use ergodis::observational::{
    compile_observational_with_deferred_verification, compile_observational_with_policy,
    CertificatePolicy, FinitePresentation, GeneratorSpec,
};
use std::hint::black_box;
use std::time::Instant;

fn next_random(state: &mut u64) -> u64 {
    *state ^= *state << 13;
    *state ^= *state >> 7;
    *state ^= *state << 17;
    *state
}

fn presentation(states: u32, generators: u32, outputs: u32, family: &str) -> FinitePresentation {
    assert!(states >= 2);
    assert!(generators >= 1);
    assert!(outputs >= 2);
    let observations = if family == "colors" {
        assert_eq!(states % outputs, 0);
        (0..states).map(|state| state % outputs).collect()
    } else if family == "stable" {
        vec![1_u32; states as usize]
    } else {
        let mut observations = vec![0_u32; states as usize];
        observations[states as usize - 1] = 1;
        observations
    };
    let mut specs = Vec::with_capacity(generators as usize);
    for generator in 0..generators {
        let transitions = if family == "colors" || family == "stable" {
            let shift = generator + 1;
            (0..states)
                .map(|state| (state + shift) % states)
                .collect::<Vec<_>>()
        } else if family == "chain" || generator == 0 {
            (0..states)
                .map(|state| (state + 1).min(states - 1))
                .collect::<Vec<_>>()
        } else {
            let mut random = 0x9e37_79b9_7f4a_7c15_u64 ^ u64::from(generator);
            (0..states)
                .map(|_| (next_random(&mut random) % u64::from(states)) as u32)
                .collect::<Vec<_>>()
        };
        specs.push(GeneratorSpec {
            source_sort: 0,
            target_sort: 0,
            transitions: transitions.into_boxed_slice(),
        });
    }
    FinitePresentation::new([states], observations, specs).unwrap()
}

fn main() {
    let mut args = std::env::args().skip(1);
    let family = args
        .next()
        .expect("family: chain, random, colors, or stable");
    assert!(family == "chain" || family == "random" || family == "colors" || family == "stable");
    let states = args.next().expect("states").parse::<u32>().unwrap();
    let generators = args.next().expect("generators").parse::<u32>().unwrap();
    let repetitions = args.next().expect("repetitions").parse::<u32>().unwrap();
    let outputs = args.next().map_or(2, |value| value.parse::<u32>().unwrap());
    let policy_arg = args.next();
    let deferred = policy_arg.as_deref() == Some("adaptive-deferred");
    let policy = match policy_arg.as_deref() {
        None | Some("transcript") => CertificatePolicy::SplitTranscript,
        Some("adaptive" | "adaptive-deferred") => CertificatePolicy::AdaptiveTranscript,
        Some("multiway") => CertificatePolicy::MultiwayTranscript,
        Some("quotient") => CertificatePolicy::QuotientOnly,
        Some(value) => {
            panic!("unknown policy {value}: expected transcript, adaptive[-deferred], multiway, or quotient")
        }
    };
    assert!(args.next().is_none());

    let input = presentation(states, generators, outputs, &family);
    let start = Instant::now();
    let mut classes = 0_usize;
    let mut splits = 0_usize;
    for _ in 0..repetitions {
        let compiled = if deferred {
            compile_observational_with_deferred_verification(black_box(&input), policy).unwrap()
        } else {
            compile_observational_with_policy(black_box(&input), policy).unwrap()
        };
        classes = black_box(compiled.class_outputs().len());
        splits = black_box(
            if compiled.certificate_policy() == CertificatePolicy::MultiwayTranscript {
                compiled.multiway_records().len()
            } else {
                compiled.metrics().refinement_splits
            },
        );
    }
    let elapsed = start.elapsed();
    println!(
        "ergodis\t{family}\t{states}\t{generators}\t{outputs}\t{repetitions}\t{}\t{classes}\t{splits}",
        elapsed.as_nanos() / u128::from(repetitions)
    );
}
