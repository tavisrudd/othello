use ergodis::observational::{
    compile_layered_frozen_dag_audited, compile_layered_observational, verify_frozen_layered_audit,
    verify_frozen_layered_dag_audit, write_frozen_observation, write_layered_audit,
    FrozenObservation, LayeredFrontierMetrics, LayeredGeneratorSpec,
};
use std::hint::black_box;
use std::io::Write;
use std::time::Instant;

fn generators(shape: &str, sorts: usize, window: usize) -> Vec<LayeredGeneratorSpec> {
    let mut result = Vec::new();
    for source in 0..sorts {
        for target in source + 1..sorts {
            let include = match shape {
                "chain" => target == source + 1,
                "window" => target - source <= window,
                "full" => true,
                _ => panic!("unknown DAG shape {shape}"),
            };
            if include {
                result.push(LayeredGeneratorSpec {
                    source_sort: source as u32,
                    target_sort: target as u32,
                });
            }
        }
    }
    result
}

#[inline]
fn target_state(
    state_counts: &[u32],
    generators: &[LayeredGeneratorSpec],
    generator: u32,
    state: u32,
) -> u32 {
    let spec = generators[generator as usize];
    let modulus = state_counts[spec.target_sort as usize];
    state
        .wrapping_mul(2 * generator + 3)
        .wrapping_add(generator + spec.source_sort + spec.target_sort)
        % modulus
}

fn write_frozen(path: &str, frozen: &FrozenObservation) {
    let file = std::fs::File::create(path).unwrap();
    let mut writer = std::io::BufWriter::with_capacity(64 * 1024, file);
    write_frozen_observation(frozen, &mut writer).unwrap();
    writer.flush().unwrap();
}

fn main() {
    let mut args = std::env::args().skip(1);
    let mode = args.next().expect("mode");
    let shape = args.next().expect("shape");
    let sorts = args.next().expect("sorts").parse::<usize>().unwrap();
    let states_per_sort = args
        .next()
        .expect("states per sort")
        .parse::<u32>()
        .unwrap();
    let window = args.next().expect("window").parse::<usize>().unwrap();
    let frozen_path = args.next().expect("frozen path");
    let audit_path = args.next().expect("audit path");
    assert!(args.next().is_none());
    assert!(sorts >= 2 && states_per_sort != 0);

    let state_counts = vec![states_per_sort; sorts];
    let generators = generators(&shape, sorts, window);
    let observation = |_: u32, _: u32| 0_u32;
    let transition = |generator, state| target_state(&state_counts, &generators, generator, state);
    let total_states = states_per_sort as usize * sorts;
    let start = Instant::now();
    let (frozen, frontier, compile_ns, stream_ns) = if mode == "full-certified" {
        let compiled =
            compile_layered_observational(&state_counts, &generators, observation, transition)
                .unwrap();
        let compile_ns = start.elapsed().as_nanos();
        let file = std::fs::File::create(&audit_path).unwrap();
        let mut writer = std::io::BufWriter::with_capacity(64 * 1024, file);
        let stream_start = Instant::now();
        write_layered_audit(
            &state_counts,
            &generators,
            observation,
            transition,
            &compiled,
            &mut writer,
        )
        .unwrap();
        writer.flush().unwrap();
        let stream_ns = stream_start.elapsed().as_nanos();
        let frozen = compiled.into_frozen(&state_counts, &[0]).unwrap();
        (
            frozen,
            LayeredFrontierMetrics::default(),
            compile_ns,
            stream_ns,
        )
    } else if mode == "frontier-certified" {
        let file = std::fs::File::create(&audit_path).unwrap();
        let mut writer = std::io::BufWriter::with_capacity(64 * 1024, file);
        let ((frozen, frontier), compile_ns) = {
            let compile_start = Instant::now();
            let result = compile_layered_frozen_dag_audited(
                &state_counts,
                &generators,
                &[0],
                observation,
                transition,
                &mut writer,
            )
            .unwrap();
            (result, compile_start.elapsed().as_nanos())
        };
        writer.flush().unwrap();
        (frozen, frontier, compile_ns, 0)
    } else {
        panic!("unknown mode {mode}");
    };
    write_frozen(&frozen_path, &frozen);
    let file = std::fs::File::open(&audit_path).unwrap();
    let mut reader = std::io::BufReader::with_capacity(64 * 1024, file);
    let verify_start = Instant::now();
    if mode == "full-certified" {
        verify_frozen_layered_audit(&frozen, &mut reader).unwrap();
    } else {
        verify_frozen_layered_dag_audit(&frozen, &mut reader).unwrap();
    }
    let verify_ns = verify_start.elapsed().as_nanos();
    let checksum = frozen.entry_class(0, 0).unwrap() as u64
        ^ frozen.storage().payload_bytes as u64
        ^ std::fs::metadata(&audit_path).unwrap().len();
    println!(
        "dag\t{mode}\t{shape}\t{sorts}\t{states_per_sort}\t{}\t{total_states}\t{}\t{}\t{}\t{}\t{}\t{compile_ns}\t{stream_ns}\t{verify_ns}\t{}\t{}\t{checksum}",
        generators.len(),
        frozen.storage().classes,
        frozen.storage().payload_bytes,
        frontier.peak_live_state_classes,
        frontier.peak_live_class_maps,
        frontier.peak_signature_words,
        std::fs::metadata(&audit_path).unwrap().len(),
        std::fs::metadata(&frozen_path).unwrap().len(),
    );
    black_box(frozen);
}
