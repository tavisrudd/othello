use std::time::Instant;

use ergo_comp::defect::{
    analyze_fixed_maximal_set, canonical_maximal_prefix_search, AugmentResult, Gf27DefectCatalog,
    MaximalPointAugmentor, SearchPruning,
};
use ergo_comp::projective::ProjectivePlane;

fn seeded_points(plane: &ProjectivePlane, depth: usize) -> Vec<u16> {
    let mut state = MaximalPointAugmentor::new(plane);
    let mut points = Vec::with_capacity(depth);
    let mut candidate = 0;
    while points.len() != depth {
        if state.push(plane, candidate) == AugmentResult::Added {
            points.push(candidate as u16);
            candidate = (candidate + 37) % plane.points().len();
        } else {
            candidate = (candidate + 1) % plane.points().len();
        }
    }
    points
}

fn main() {
    let forced_depth = std::env::args()
        .nth(1)
        .map(|value| value.parse::<u8>().expect("forced depth is a u8"))
        .unwrap_or(40);
    let terminal_depth = std::env::args()
        .nth(2)
        .map(|value| value.parse::<u8>().expect("terminal depth is a u8"))
        .unwrap_or(forced_depth + 2);
    let mode = std::env::args().nth(3).unwrap_or_else(|| "both".to_owned());
    let repetitions = std::env::args()
        .nth(4)
        .map(|value| value.parse::<u32>().expect("repetitions is a u32"))
        .unwrap_or(1);
    let node_limit = std::env::args()
        .nth(5)
        .map(|value| value.parse::<u64>().expect("node limit is a u64"))
        .unwrap_or(u64::MAX);
    let plane = ProjectivePlane::ternary(27).unwrap();
    let catalog = Gf27DefectCatalog::new();
    let forced = seeded_points(&plane, forced_depth as usize);
    if mode == "points" {
        println!("{forced:?}");
        return;
    }
    if mode == "analyze" {
        let mut state = MaximalPointAugmentor::new(&plane);
        for &point in &forced {
            assert_eq!(state.push(&plane, usize::from(point)), AugmentResult::Added);
        }
        println!("{:?}", analyze_fixed_maximal_set(&plane, &state));
        return;
    }
    let pruning_modes = match mode.as_str() {
        "cap" => &[(SearchPruning::DegreeCapOnly)][..],
        "catalog" => &[(SearchPruning::DefectCatalog)][..],
        "both" => &[SearchPruning::DegreeCapOnly, SearchPruning::DefectCatalog][..],
        _ => panic!("mode must be cap, catalog, both, analyze, or points"),
    };
    for &pruning in pruning_modes {
        let start = Instant::now();
        let mut stats = None;
        for _ in 0..repetitions {
            stats = Some(
                canonical_maximal_prefix_search(
                    &plane,
                    &catalog,
                    &forced,
                    terminal_depth,
                    node_limit,
                    pruning,
                )
                .unwrap()
                .stats,
            );
        }
        println!(
            "{pruning:?} repetitions={repetitions} {:?} {:?}",
            start.elapsed(),
            stats.unwrap()
        );
    }
}
