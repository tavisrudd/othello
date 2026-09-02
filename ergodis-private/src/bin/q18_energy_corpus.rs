use ergodis_private::q18_energy_corpus::{
    first_broad_q174_shell_reject, measure_broad_q174_shell, measure_broad_q174_shell_lower_bound,
    measure_broad_q174_shell_old_gate_control, measure_q18_energy_gate_corpus,
    Q18EnergyCorpusWorkspace,
};
use ergodis_private::q18_energy_gate::q18_class_energy_bounds;

fn main() {
    let mode = std::env::args().nth(1).unwrap_or_else(|| "gate".to_owned());
    let samples = std::env::args()
        .nth(2)
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(10_000);
    let seed = std::env::args()
        .nth(3)
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(0x243f_6a88_85a3_08d3);
    let mut workspace = Q18EnergyCorpusWorkspace::new();
    if mode == "broad-find-reject" {
        let found = first_broad_q174_shell_reject(seed, samples, &mut workspace).unwrap();
        match found {
            Some((sample, summaries)) => {
                let mut minimum = 0_u32;
                let mut maximum = 0_u32;
                print!("sample={sample} summaries=");
                for summary in summaries {
                    for class in summary.classes {
                        let (class_minimum, class_maximum, _) =
                            q18_class_energy_bounds(class).unwrap();
                        minimum += u32::from(class_minimum);
                        maximum += u32::from(class_maximum);
                        print!(
                            "{},{},{};",
                            class.total, class.zero_columns, class.full_columns
                        );
                    }
                    print!("|");
                }
                println!(
                    " min_energy={minimum} max_energy={maximum} provenance=proved_gate_over_discovery_only_broad_shell"
                );
            }
            None => println!("no_reject_in={samples} provenance=discovery_only_miss"),
        }
        return;
    }
    let report = match mode.as_str() {
        "control" => measure_q18_energy_gate_corpus::<false>(seed, samples, &mut workspace),
        "gate" => measure_q18_energy_gate_corpus::<true>(seed, samples, &mut workspace),
        "broad-control" => measure_broad_q174_shell::<false>(seed, samples, &mut workspace),
        "broad-gate" => measure_broad_q174_shell::<true>(seed, samples, &mut workspace),
        "broad-old-gate" => {
            measure_broad_q174_shell_old_gate_control(seed, samples, &mut workspace)
        }
        "broad-lower" => measure_broad_q174_shell_lower_bound(seed, samples, &mut workspace),
        _ => panic!("unknown mode"),
    }
    .unwrap();
    println!(
        "mode={mode} proposals={} shell_samples={} gate_survivors={} checksum={:016x} scope_samples={:?} scope_rejects={:?} lower_bound_rejects={} upper_bound_rejects={} internal_gap_rejects={} provenance=discovery_only_pseudorandom_fixed_weight_rejection",
        report.proposals,
        report.shell_samples,
        report.gate_survivors,
        report.summary_checksum,
        report.scope_samples,
        report.scope_rejects,
        report.lower_bound_rejects,
        report.upper_bound_rejects,
        report.internal_gap_rejects
    );
}
