use ergodis::{
    compile_greedy_adaptive_queries, compile_greedy_nonadaptive_queries,
    pair_query_nonadaptive_lower_bound, verify_adaptive_queries, verify_nonadaptive_queries,
    NonadaptiveQueryCertificate,
};
use serde::Deserialize;

#[derive(Deserialize)]
struct Input {
    hypotheses: u32,
    tests: Vec<u64>,
    selected: Vec<u32>,
}

fn main() {
    let input: Input = serde_json::from_reader(std::io::BufReader::new(
        std::fs::File::open("c1011-query-input.json").expect("open frozen query incidence"),
    ))
    .expect("parse frozen query incidence");
    let supplied = NonadaptiveQueryCertificate::new(input.selected);
    verify_nonadaptive_queries(input.hypotheses, &input.tests, &supplied)
        .expect("replay supplied nonadaptive certificate");
    let nonadaptive = compile_greedy_nonadaptive_queries(input.hypotheses, &input.tests)
        .expect("compile nonadaptive query design");
    let adaptive = compile_greedy_adaptive_queries(input.hypotheses, &input.tests)
        .expect("compile adaptive query design");
    let metrics = verify_adaptive_queries(input.hypotheses, &input.tests, &adaptive)
        .expect("replay adaptive query design");
    assert_eq!(supplied.selected_tests().len(), 14);
    assert_eq!(nonadaptive.selected_tests().len(), 14);
    assert_eq!(
        pair_query_nonadaptive_lower_bound(input.hypotheses, &input.tests).unwrap(),
        Some(14)
    );
    assert_eq!(metrics.maximum_depth, 11);
    println!(
        "nonadaptive={} adaptive_depth={} adaptive_nodes={}",
        nonadaptive.selected_tests().len(),
        metrics.maximum_depth,
        metrics.internal_nodes,
    );
}
