use std::hint::black_box;

use ergodis_private::q29_pair_key_evolve::{
    evolve_retained_q29_pair_mask, retained_q29_pair_corpus, Q29PairLookupCounters, Q29PairMask,
    Q29PairTable,
};

fn main() {
    let mode = std::env::args()
        .nth(1)
        .unwrap_or_else(|| "evolved".to_owned());
    let repetitions = std::env::args()
        .nth(2)
        .map(|value| value.parse::<u32>().expect("integer repetitions"))
        .unwrap_or(100_000);
    let evolution = evolve_retained_q29_pair_mask();
    let mask = match mode.as_str() {
        "evolved" => evolution.mask,
        "full" => Q29PairMask::full(),
        _ => panic!("mode must be evolved or full"),
    };
    let keys = retained_q29_pair_corpus();
    let mut table = Q29PairTable::with_capacity(mask, keys.len()).expect("bounded q29 pair table");
    for &key in &keys {
        assert!(table.insert(key));
    }
    let mut counters = Q29PairLookupCounters::default();
    for _ in 0..repetitions {
        for key in &keys {
            black_box(table.contains_exact(black_box(key), &mut counters));
        }
    }
    println!(
        "{{\"mode\":\"{}\",\"repetitions\":{},\"mask\":{:?},\"corpus_keys\":{},\"train_extra_collisions\":{},\"heldout_extra_collisions\":{},\"lookups\":{},\"probes\":{},\"tagged_candidates\":{},\"exact_coordinate_comparisons\":{},\"exact_hits\":{},\"provenance\":\"ObservedEvolvedPerformanceOnly\"}}",
        mode,
        repetitions,
        &mask.order[..usize::from(mask.length)],
        keys.len(),
        evolution.train_extra_collisions,
        evolution.heldout_extra_collisions,
        counters.lookups,
        counters.probes,
        counters.tagged_candidates,
        counters.exact_coordinate_comparisons,
        counters.exact_hits,
    );
}
