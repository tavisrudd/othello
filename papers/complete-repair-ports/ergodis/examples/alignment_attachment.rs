use ergodis::{
    compile_alignment_attachment, search_alignment_attachment, AlignmentSearchWorkspace,
};
use std::io::BufRead;

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
    if let Ok(path) = std::env::var("ERGODIS_ALIGNMENT_MODEL") {
        let file = std::fs::File::open(path)?;
        let mut reader = std::io::BufReader::new(file);
        let mut line = String::new();
        let mut selected = 0_u64;
        let mut satisfiable = false;
        while reader.read_line(&mut line)? != 0 {
            if line.trim_end() == "s SATISFIABLE" {
                satisfiable = true;
            } else if let Some(model_line) = line.strip_prefix("v ") {
                for literal in model_line.split_ascii_whitespace() {
                    let literal = literal.parse::<i32>()?;
                    if literal > 0 && literal as usize <= problem.triples().len() {
                        selected |= 1_u64 << (literal - 1);
                    }
                }
            }
            line.clear();
        }
        if !satisfiable {
            return Err("the model stream is not SATISFIABLE".into());
        }
        println!(
            "points={points} selected={} separates={}",
            selected.count_ones(),
            problem.separates(selected)?
        );
        return Ok(());
    }
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
