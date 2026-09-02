use ergodis_private::q29_parity_support::{census_q29_support_quartets, Q29ParityWorkspace};

fn main() {
    let mut workspace = Box::new(Q29ParityWorkspace::ZERO);
    let report = census_q29_support_quartets(&mut workspace);
    println!(
        "left_pairs={} right_pairs={} compatible_quartets={} occupied_left_keys={} occupied_right_keys={} provenance={}",
        report.left_pairs,
        report.right_pairs,
        report.compatible_quartets,
        report.occupied_left_keys,
        report.occupied_right_keys,
        report.provenance
    );
}
