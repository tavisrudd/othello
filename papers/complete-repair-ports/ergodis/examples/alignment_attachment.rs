use ergodis::{
    compile_alignment_attachment, search_alignment_attachment, AlignmentSearchWorkspace,
};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let points = std::env::var("ERGODIS_ALIGNMENT_POINTS")
        .ok()
        .map_or(Ok(8_u32), |value| value.parse())?;
    let budget = std::env::var("ERGODIS_ALIGNMENT_BUDGET")
        .ok()
        .map_or(Ok(16_u32), |value| value.parse())?;
    let seen_power = std::env::var("ERGODIS_ALIGNMENT_SEEN_POWER")
        .ok()
        .map_or(Ok(24_u32), |value| value.parse())?;
    let problem = compile_alignment_attachment(points)?;
    if let Ok(family) = std::env::var("ERGODIS_ALIGNMENT_FAMILY") {
        let mut selected = 0_u64;
        for index in family.split(',') {
            let index = index.parse::<usize>()?;
            selected |= 1_u64 << index;
        }
        println!(
            "points={points} selected={} separates={}",
            selected.count_ones(),
            problem.separates(selected)?
        );
        return Ok(());
    }
    let mut workspace = AlignmentSearchWorkspace::new(budget, 1_usize << seen_power)?;
    let started = std::time::Instant::now();
    let (solution, metrics) = search_alignment_attachment(&problem, budget, &mut workspace)?;
    println!(
        "points={points} triples={} cuts={} budget={budget} solution={solution:?} states={} duplicates={} infeasible={} elapsed_ns={}",
        problem.triples().len(),
        problem.cut_count(),
        metrics.states,
        metrics.duplicate_states,
        metrics.infeasible_states,
        started.elapsed().as_nanos()
    );
    Ok(())
}
