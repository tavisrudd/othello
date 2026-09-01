use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis::{
    compile_alignment_attachment, search_alignment_attachment_controlled,
    search_alignment_attachment_from, AlignmentBranchFeatures, AlignmentError,
    AlignmentSearchControl, AlignmentSearchPoint, AlignmentSearchWorkspace,
};
use serde::Serialize;
use serde_json::json;
use sha2::{Digest, Sha256};
use std::collections::BTreeMap;
use std::fs::OpenOptions;
use std::io::{BufWriter, Read, Write};
use std::os::unix::fs::OpenOptionsExt;
use std::path::{Path, PathBuf};

const CORPUS_FIELDS: [&str; 6] = [
    "root_candidate",
    "root_orbit",
    "root_sized",
    "root_initial_unresolved",
    "root_initial_packing",
    "root_initial_branches",
];

#[derive(Debug, Parser)]
#[command(about = "Generate an exact per-root alignment cost corpus")]
struct Args {
    #[arg(long, default_value_t = 8)]
    points: u32,
    #[arg(long, default_value_t = 8)]
    budget: u32,
    #[arg(long, default_value_t = 1 << 22)]
    seen_capacity: usize,
    /// Capture the first active root whose sizing pass has completed.
    #[arg(long)]
    capture_sized: bool,
    #[arg(long)]
    output: PathBuf,
    #[arg(long)]
    report: PathBuf,
}

#[derive(Clone, Copy, Serialize)]
struct RootSample {
    initial: u32,
    states: u64,
    duplicates: u64,
    infeasible: u64,
    values: [i64; CORPUS_FIELDS.len()],
    expected: bool,
}

struct FirstPoint {
    point: Option<AlignmentSearchPoint>,
    require_sized: bool,
}

impl FirstPoint {
    fn new(require_sized: bool) -> Self {
        Self {
            point: None,
            require_sized,
        }
    }

    #[inline]
    fn capture(&mut self, point: AlignmentSearchPoint) {
        if self.point.is_none()
            && point.root_candidate.is_some()
            && (!self.require_sized || point.root_sized)
        {
            self.point = Some(point);
        }
    }
}

impl AlignmentSearchControl for FirstPoint {
    #[inline(always)]
    fn steering_pending(&self) -> bool {
        self.point.is_none()
    }

    #[inline(always)]
    fn safe_point(&mut self, point: AlignmentSearchPoint) -> Result<(), AlignmentError> {
        self.capture(point);
        Ok(())
    }

    #[inline(always)]
    fn heartbeat(&mut self, point: AlignmentSearchPoint) -> Result<(), AlignmentError> {
        self.capture(point);
        Ok(())
    }

    #[inline(always)]
    fn ordering_active(&self, _root_candidate: Option<u32>, _root_orbit: Option<u32>) -> bool {
        false
    }

    #[inline(always)]
    fn score_branch(&mut self, _features: AlignmentBranchFeatures) -> Result<i64, AlignmentError> {
        Ok(0)
    }
}

fn create(path: &Path) -> Result<BufWriter<std::fs::File>> {
    let file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .mode(0o600)
        .open(path)
        .with_context(|| format!("cannot create {}", path.display()))?;
    Ok(BufWriter::new(file))
}

fn sha256(path: &Path) -> Result<String> {
    let mut file = std::fs::File::open(path)?;
    let mut hasher = Sha256::new();
    let mut buffer = [0_u8; 16 * 1024];
    loop {
        let read = file.read(&mut buffer)?;
        if read == 0 {
            break;
        }
        hasher.update(&buffer[..read]);
    }
    Ok(format!("{:x}", hasher.finalize()))
}

fn point_values(point: AlignmentSearchPoint) -> [i64; CORPUS_FIELDS.len()] {
    [
        point.root_candidate.map_or(-1, i64::from),
        point.root_orbit.map_or(-1, i64::from),
        i64::from(point.root_sized),
        i64::from(point.root_initial_unresolved),
        i64::from(point.root_initial_packing),
        i64::from(point.root_initial_branches),
    ]
}

fn observable_ceiling(samples: &[RootSample]) -> (usize, u64) {
    let mut classes = BTreeMap::<[i64; CORPUS_FIELDS.len()], [u64; 2]>::new();
    for sample in samples {
        classes.entry(sample.values).or_default()[usize::from(sample.expected)] += 1;
    }
    let optimum = classes
        .values()
        .map(|counts| counts[0].max(counts[1]))
        .sum();
    (classes.len(), optimum)
}

fn main() -> Result<()> {
    let args = Args::parse();
    if args.output == args.report {
        bail!("output and report paths must differ");
    }
    let problem = compile_alignment_attachment(args.points)?;
    let roots = problem.triples().len();
    if roots > 64 {
        bail!("alignment root corpus requires at most 64 triples");
    }
    let mut workspace = AlignmentSearchWorkspace::new(args.budget, args.seen_capacity)?;
    let mut samples = Vec::with_capacity(roots);
    for initial in 0..roots {
        let mut control = FirstPoint::new(args.capture_sized);
        let (answer, metrics) = search_alignment_attachment_controlled(
            &problem,
            args.budget,
            1_u64 << initial,
            &mut workspace,
            1,
            &mut control,
        )?;
        let (baseline_answer, baseline_metrics) = search_alignment_attachment_from(
            &problem,
            args.budget,
            1_u64 << initial,
            &mut workspace,
        )?;
        if answer != baseline_answer || metrics != baseline_metrics {
            bail!("controlled root {initial} disagrees with the uncontrolled baseline");
        }
        let point = control
            .point
            .with_context(|| format!("root {initial} search published no progress point"))?;
        samples.push(RootSample {
            initial: u32::try_from(initial)?,
            states: metrics.states,
            duplicates: metrics.duplicate_states,
            infeasible: metrics.infeasible_states,
            values: point_values(point),
            expected: false,
        });
    }
    let mut costs = samples
        .iter()
        .map(|sample| sample.states)
        .collect::<Vec<_>>();
    costs.sort_unstable();
    let median_states = costs[costs.len() / 2];
    for sample in &mut samples {
        sample.expected = sample.states >= median_states;
    }
    let positives = samples.iter().filter(|sample| sample.expected).count();
    let (observable_classes, observable_optimum) = observable_ceiling(&samples);

    let mut output = create(&args.output)?;
    serde_json::to_writer(
        &mut output,
        &json!({
            "schema": "ergodis-campaign-data-v0",
            "presentation": format!(
                "alignment-root-cost-p{}-b{}{}",
                args.points,
                args.budget,
                if args.capture_sized { "-sized" } else { "" },
            ),
            "problem": "exact alignment root-cost classification",
            "fields": CORPUS_FIELDS,
            "rows": samples.len(),
        }),
    )?;
    output.write_all(b"\n")?;
    for (id, sample) in samples.iter().enumerate() {
        serde_json::to_writer(
            &mut output,
            &json!({"id": id, "expected": sample.expected, "values": sample.values}),
        )?;
        output.write_all(b"\n")?;
    }
    output.flush()?;

    let output_sha256 = sha256(&args.output)?;
    let mut report = create(&args.report)?;
    serde_json::to_writer_pretty(
        &mut report,
        &json!({
            "schema": "ergodis-private-alignment-root-corpus-v0",
            "points": args.points,
            "budget": args.budget,
            "seen_capacity": args.seen_capacity,
            "capture": if args.capture_sized { "first-sized-root" } else { "first-active-root" },
            "uncontrolled_baseline_verified": true,
            "fields": CORPUS_FIELDS,
            "median_states": median_states,
            "rows": samples.len(),
            "positives": positives,
            "observable_classes": observable_classes,
            "observable_optimum": observable_optimum,
            "output": args.output,
            "output_sha256": output_sha256,
            "samples": samples,
        }),
    )?;
    report.write_all(b"\n")?;
    report.flush()?;
    println!(
        "{}",
        json!({"rows": samples.len(), "positives": positives, "median_states": median_states, "observable_classes": observable_classes, "observable_optimum": observable_optimum, "output_sha256": output_sha256})
    );
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sample(class: i64, expected: bool) -> RootSample {
        RootSample {
            initial: 0,
            states: 0,
            duplicates: 0,
            infeasible: 0,
            values: [class, 0, 0, 0, 0, 0],
            expected,
        }
    }

    #[test]
    fn observable_ceiling_takes_each_class_majority() {
        let samples = [
            sample(0, true),
            sample(0, true),
            sample(0, false),
            sample(1, false),
        ];
        assert_eq!(observable_ceiling(&samples), (2, 3));
    }
}
