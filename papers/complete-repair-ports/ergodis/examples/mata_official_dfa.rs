use ergodis::observational::{compile_observational_with_policy, CertificatePolicy};
use ergodis::ExplicitMataDfa;
use std::fs::File;
use std::hint::black_box;
use std::io::BufReader;
use std::time::Instant;

fn main() -> anyhow::Result<()> {
    let mut arguments = std::env::args().skip(1);
    let path = arguments
        .next()
        .ok_or_else(|| anyhow::anyhow!("missing DFA path"))?;
    let repetitions: u64 = arguments
        .next()
        .ok_or_else(|| anyhow::anyhow!("missing repetition count"))?
        .parse()?;
    if arguments.next().is_some() || repetitions == 0 {
        anyhow::bail!("usage: mata_official_dfa DFA.mata REPETITIONS");
    }
    let dfa = ExplicitMataDfa::parse(BufReader::new(File::open(path)?))?;
    let mut classes = 0_u32;
    let start = Instant::now();
    for _ in 0..repetitions {
        let compiled = compile_observational_with_policy(
            dfa.presentation(),
            CertificatePolicy::SplitTranscript,
        )?;
        classes = compiled.class_ranges()[0].len;
        black_box(&compiled);
    }
    let elapsed = start.elapsed().as_nanos() / u128::from(repetitions);
    println!(
        "ergodis\t{}\t{}\t{}\t{}\t{}\t{}",
        dfa.original_state_count(),
        dfa.state_count(),
        dfa.symbols().len(),
        repetitions,
        elapsed,
        classes
    );
    Ok(())
}
