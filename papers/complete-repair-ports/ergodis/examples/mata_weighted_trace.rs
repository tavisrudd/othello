use ergodis::observational::{compile_observational_with_policy, CertificatePolicy};
use ergodis::ExplicitMataDfa;
use serde_json::json;
use std::fs::File;
use std::hint::black_box;
use std::io::BufReader;
use std::time::Instant;

fn symbol_cost(symbol: &str) -> anyhow::Result<u64> {
    if symbol.is_empty() || !symbol.bytes().all(|byte| matches!(byte, b'0' | b'1')) {
        anyhow::bail!("expected a nonempty bit-vector alphabet label, got {symbol:?}");
    }
    Ok(1 + symbol.bytes().filter(|&byte| byte == b'1').count() as u64)
}

fn main() -> anyhow::Result<()> {
    let mut arguments = std::env::args().skip(1);
    let path = arguments
        .next()
        .ok_or_else(|| anyhow::anyhow!("missing DFA path"))?;
    let repetitions: u64 = arguments.next().unwrap_or_else(|| "1".to_owned()).parse()?;
    if arguments.next().is_some() || repetitions == 0 {
        anyhow::bail!("usage: mata_weighted_trace DFA.mata [REPETITIONS]");
    }

    let dfa = ExplicitMataDfa::parse(BufReader::new(File::open(path)?))?;
    let costs = dfa
        .symbols()
        .iter()
        .map(|symbol| symbol_cost(symbol))
        .collect::<Result<Vec<_>, _>>()?;

    let compile_start = Instant::now();
    let compiled =
        compile_observational_with_policy(dfa.presentation(), CertificatePolicy::SplitTranscript)?;
    let compile_ns = compile_start.elapsed().as_nanos();
    let plan_start = Instant::now();
    let plan = compiled.compile_weighted_generator_plan(&costs)?;
    let plan_ns = plan_start.elapsed().as_nanos();
    let start_class = compiled.state_classes()[dfa.initial_state() as usize];

    let mut workspace = plan.workspace()?;
    let query_start = Instant::now();
    for _ in 0..repetitions {
        let answer = plan
            .shortest_word_to_output_in(start_class, 1, &mut workspace)?
            .ok_or_else(|| anyhow::anyhow!("accepting output is unreachable"))?;
        black_box((answer.cost, answer.generators.len()));
    }
    let query_ns = query_start.elapsed().as_nanos() / u128::from(repetitions);
    let answer = plan
        .shortest_word_to_output_in(start_class, 1, &mut workspace)?
        .ok_or_else(|| anyhow::anyhow!("accepting output is unreachable"))?;

    let mut concrete_state = dfa.initial_state();
    let mut replay_cost = 0_u64;
    let mut checksum = 0xcbf2_9ce4_8422_2325_u64;
    for &generator in answer.generators {
        concrete_state = dfa
            .presentation()
            .transition(generator, concrete_state)
            .ok_or_else(|| anyhow::anyhow!("synthesized word is ill typed"))?;
        replay_cost = replay_cost
            .checked_add(costs[generator as usize])
            .ok_or_else(|| anyhow::anyhow!("cost overflow"))?;
        checksum ^= u64::from(generator);
        checksum = checksum.wrapping_mul(0x100_0000_01b3);
    }
    if replay_cost != answer.cost || dfa.presentation().observations()[concrete_state as usize] != 1
    {
        anyhow::bail!("synthesized witness failed concrete replay");
    }

    serde_json::to_writer(
        std::io::stdout().lock(),
        &json!({
            "status": "optimal",
            "original_states": dfa.original_state_count(),
            "total_states": dfa.state_count(),
            "symbols": dfa.symbols().len(),
            "classes": plan.class_count(),
            "uncollapsed_edges": plan.uncollapsed_edge_count(),
            "collapsed_edges": plan.edge_count(),
            "optimum": answer.cost,
            "word_length": answer.generators.len(),
            "word_checksum": checksum,
            "compile_ns": compile_ns,
            "plan_ns": plan_ns,
            "query_ns": query_ns,
            "query_repetitions": repetitions,
        }),
    )?;
    println!();
    Ok(())
}
