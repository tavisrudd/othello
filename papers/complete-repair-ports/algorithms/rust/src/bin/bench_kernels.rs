use std::hint::black_box;
use std::time::Instant;

use ergo_comp::{
    compile_binary_target_subspace, ternary_orbit_syndrome_meet_in_middle,
    ternary_orbit_syndrome_meet_in_middle_count_split,
    ternary_orbit_syndrome_meet_in_middle_unreserved, ternary_orbit_syndrome_search,
    ternary_orbit_syndrome_search_correlated, CompositionTower, Gf4, Matrix, OrbitOption,
    TowerLevel, WeightedRepairProblem, WeightedRepairWorkspace, WeightedSchedulerBackend,
};

fn next_u32(state: &mut u64) -> u32 {
    *state = state
        .wrapping_mul(6_364_136_223_846_793_005)
        .wrapping_add(1);
    (*state >> 32) as u32
}

fn advance_lcg(state: u64, mut delta: u64) -> u64 {
    let mut accumulated_multiplier = 1u64;
    let mut accumulated_increment = 0u64;
    let mut multiplier = 6_364_136_223_846_793_005u64;
    let mut increment = 1u64;
    while delta != 0 {
        if delta & 1 != 0 {
            accumulated_multiplier = accumulated_multiplier.wrapping_mul(multiplier);
            accumulated_increment = accumulated_increment
                .wrapping_mul(multiplier)
                .wrapping_add(increment);
        }
        increment = multiplier.wrapping_add(1).wrapping_mul(increment);
        multiplier = multiplier.wrapping_mul(multiplier);
        delta >>= 1;
    }
    accumulated_multiplier
        .wrapping_mul(state)
        .wrapping_add(accumulated_increment)
}

fn transfer_tower_spec(variant: &str) -> Option<(&str, usize, usize)> {
    let mut fields = variant.split(':');
    if fields.next()? != "transfer-tower" {
        return None;
    }
    let backend = fields.next()?;
    if backend != "rust" && backend != "rust-stream" {
        return None;
    }
    let depth = fields.next()?.parse().ok()?;
    let fanout = fields.next()?.parse().ok()?;
    fields.next().is_none().then_some((backend, depth, fanout))
}

fn scheduler_problem(small: bool) -> WeightedRepairProblem {
    let (resource_count, capacity, demand_count) = if small { (4, 2, 80) } else { (6, 3, 11) };
    scheduler_problem_with(resource_count, capacity, demand_count, 4, 0xA17E_5EED)
}

fn scheduler_problem_with(
    resource_count: usize,
    capacity: u32,
    demand_count: usize,
    option_count: usize,
    seed: u64,
) -> WeightedRepairProblem {
    assert!(resource_count >= 2);
    let capacities = vec![capacity; resource_count];
    let mut state = seed;
    let families: Vec<Vec<Vec<u32>>> = (0..demand_count)
        .map(|_| {
            (0..option_count)
                .map(|_| {
                    let mut loads = vec![0u32; resource_count];
                    let first = next_u32(&mut state) as usize % capacities.len();
                    let mut second = next_u32(&mut state) as usize % capacities.len();
                    if second == first {
                        second = (second + 1) % capacities.len();
                    }
                    loads[first] = 1;
                    loads[second] = 1;
                    loads
                })
                .collect()
        })
        .collect();
    WeightedRepairProblem::from_families(&capacities, &families).unwrap()
}

fn scheduler_grid_spec(variant: &str) -> Option<(&str, usize, u32, usize, usize, u64)> {
    let mut fields = variant.split(':');
    if fields.next()? != "scheduler-grid" {
        return None;
    }
    let backend = fields.next()?;
    let resources = fields.next()?.parse().ok()?;
    let capacity = fields.next()?.parse().ok()?;
    let demands = fields.next()?.parse().ok()?;
    let options = fields.next()?.parse().ok()?;
    let seed = fields.next()?.parse().ok()?;
    fields
        .next()
        .is_none()
        .then_some((backend, resources, capacity, demands, options, seed))
}

fn heterogeneous_scheduler_problem_with(
    resource_count: usize,
    capacity: u32,
    demand_count: usize,
) -> WeightedRepairProblem {
    let capacities = vec![capacity; resource_count];
    let families = (0..demand_count)
        .map(|demand| {
            (0..resource_count)
                .map(|resource| {
                    let mut loads = vec![0u32; resource_count];
                    loads[resource] = 1 + u32::from((demand + resource) % 3 == 0);
                    loads
                })
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();
    WeightedRepairProblem::from_families(&capacities, &families).unwrap()
}

fn heterogeneous_scheduler_grid_spec(variant: &str) -> Option<(&str, usize, u32, usize)> {
    let mut fields = variant.split(':');
    if fields.next()? != "scheduler-heterogeneous-grid" {
        return None;
    }
    let backend = fields.next()?;
    let resources = fields.next()?.parse().ok()?;
    let capacity = fields.next()?.parse().ok()?;
    let demands = fields.next()?.parse().ok()?;
    fields
        .next()
        .is_none()
        .then_some((backend, resources, capacity, demands))
}

fn graded_scheduler_problem_with(
    resource_count: usize,
    capacity: u32,
    demand_count: usize,
    option_count: usize,
    seed: u64,
    certified: bool,
) -> WeightedRepairProblem {
    assert!(resource_count >= 4);
    let capacities = vec![capacity; resource_count];
    let weights: Vec<u32> = (0..resource_count)
        .map(|resource| if resource % 2 == 0 { 1 } else { 2 })
        .collect();
    let even: Vec<usize> = (0..resource_count).step_by(2).collect();
    let odd: Vec<usize> = (1..resource_count).step_by(2).collect();
    let mut state = seed;
    let families: Vec<Vec<Vec<u32>>> = (0..demand_count)
        .map(|_| {
            (0..option_count)
                .map(|option| {
                    let mut loads = vec![0u32; resource_count];
                    match option % 4 {
                        0 => loads[even[next_u32(&mut state) as usize % even.len()]] = 4,
                        1 => loads[odd[next_u32(&mut state) as usize % odd.len()]] = 2,
                        2 => {
                            let first = next_u32(&mut state) as usize % even.len();
                            let mut second = next_u32(&mut state) as usize % even.len();
                            if second == first {
                                second = (second + 1) % even.len();
                            }
                            loads[even[first]] = 2;
                            loads[even[second]] = 2;
                        }
                        _ => {
                            loads[even[next_u32(&mut state) as usize % even.len()]] = 2;
                            loads[odd[next_u32(&mut state) as usize % odd.len()]] = 1;
                        }
                    }
                    loads
                })
                .collect()
        })
        .collect();
    if certified {
        WeightedRepairProblem::from_families_with_positive_grading(&capacities, &families, &weights)
            .unwrap()
    } else {
        WeightedRepairProblem::from_families(&capacities, &families).unwrap()
    }
}

fn graded_scheduler_problem_streaming_4(
    capacity: u32,
    demand_count: usize,
    option_count: usize,
    seed: u64,
) -> WeightedRepairProblem {
    let remainder_calls = [0u64, 1, 2, 4];
    let calls_per_family =
        u64::try_from(option_count / 4).unwrap() * 6 + remainder_calls[option_count % 4];
    let even = [0usize, 2];
    let odd = [1usize, 3];
    let families = (0..demand_count).map(|demand| {
        let offset = u64::try_from(demand).unwrap() * calls_per_family;
        let mut state = advance_lcg(seed, offset);
        (0..option_count).map(move |option| {
            let mut loads = [0u32; 4];
            match option % 4 {
                0 => loads[even[next_u32(&mut state) as usize % even.len()]] = 4,
                1 => loads[odd[next_u32(&mut state) as usize % odd.len()]] = 2,
                2 => {
                    let first = next_u32(&mut state) as usize % even.len();
                    let mut second = next_u32(&mut state) as usize % even.len();
                    if second == first {
                        second = (second + 1) % even.len();
                    }
                    loads[even[first]] = 2;
                    loads[even[second]] = 2;
                }
                _ => {
                    loads[even[next_u32(&mut state) as usize % even.len()]] = 2;
                    loads[odd[next_u32(&mut state) as usize % odd.len()]] = 1;
                }
            }
            loads
        })
    });
    WeightedRepairProblem::from_family_iterators_with_positive_grading(
        &[capacity; 4],
        families,
        &[1, 2, 1, 2],
    )
    .unwrap()
}

fn graded_scheduler_grid_spec(variant: &str) -> Option<(&str, usize, u32, usize, usize, u64)> {
    let mut fields = variant.split(':');
    if fields.next()? != "scheduler-graded-grid" {
        return None;
    }
    let backend = fields.next()?;
    let resources = fields.next()?.parse().ok()?;
    let capacity = fields.next()?.parse().ok()?;
    let demands = fields.next()?.parse().ok()?;
    let options = fields.next()?.parse().ok()?;
    let seed = fields.next()?.parse().ok()?;
    fields
        .next()
        .is_none()
        .then_some((backend, resources, capacity, demands, options, seed))
}

fn orbit_problem() -> (Vec<Vec<OrbitOption>>, Vec<u8>) {
    orbit_problem_with(&[3; 10], 12, 0xA17E_0B17)
}

fn orbit_grid_spec(variant: &str) -> Option<(usize, usize, usize, u64)> {
    let mut fields = variant.split(':');
    if fields.next()? != "orbit-grid" || fields.next()? != "rust" {
        return None;
    }
    let families = fields.next()?.parse().ok()?;
    let options = fields.next()?.parse().ok()?;
    let width = fields.next()?.parse().ok()?;
    let seed = fields.next()?.parse().ok()?;
    fields
        .next()
        .is_none()
        .then_some((families, options, width, seed))
}

fn orbit_problem_with(
    family_sizes: &[usize],
    width: usize,
    seed: u64,
) -> (Vec<Vec<OrbitOption>>, Vec<u8>) {
    let mut state = seed;
    let mut label = 0u32;
    let families = family_sizes
        .iter()
        .map(|&family_size| {
            (0..family_size)
                .map(|_| {
                    let option = OrbitOption {
                        label,
                        residue: (0..width)
                            .map(|_| (next_u32(&mut state) % 3) as u8)
                            .collect::<Vec<_>>()
                            .into_boxed_slice(),
                        totals: Box::new([]),
                    };
                    label += 1;
                    option
                })
                .collect()
        })
        .collect();
    let target = (0..width)
        .map(|_| (next_u32(&mut state) % 3) as u8)
        .collect();
    (families, target)
}

fn peak_rss_kib() -> u64 {
    std::fs::read_to_string("/proc/self/status")
        .ok()
        .and_then(|status| {
            status.lines().find_map(|line| {
                line.strip_prefix("VmHWM:")?
                    .split_whitespace()
                    .next()?
                    .parse()
                    .ok()
            })
        })
        .unwrap_or(0)
}

fn main() {
    let mut args = std::env::args().skip(1);
    let variant = args.next().expect("variant is required");
    let repetitions: u32 = args
        .next()
        .expect("repetitions are required")
        .parse()
        .expect("repetitions must be an integer");
    assert!(args.next().is_none(), "unexpected argument");

    let started = Instant::now();
    let mut work = 0u64;
    let mut peak_states = 0u64;
    let mut checksum = 0u64;
    if let Some((backend, depth, fanout)) = transfer_tower_spec(&variant) {
        let normalization = Matrix::new::<2>(2, 2, vec![1, 0, 0, 1]).unwrap();
        let profile =
            compile_binary_target_subspace::<Gf4>(&[1, 2, 1, 2], &[0, 1], &normalization, 256, 16)
                .unwrap();
        let (ordinary, target) = profile.cost_tables::<Gf4>().unwrap();
        let levels = (0..depth)
            .map(|_| TowerLevel {
                outer_blocks: (0..fanout)
                    .map(|_| Matrix::new_field::<Gf4>(1, 1, vec![1]).unwrap())
                    .collect::<Vec<_>>()
                    .into_boxed_slice(),
                target_block: 0,
            })
            .collect::<Vec<_>>();
        let tower = CompositionTower::compile_field::<Gf4>(&ordinary, &target, &levels).unwrap();
        let label = Matrix::new_field::<Gf4>(1, 2, vec![0, 0]).unwrap();
        for _ in 0..repetitions {
            if backend == "rust-stream" {
                let mut visited = 0u64;
                let mut replay_checksum = 0u64;
                let answer = tower
                    .replay_target_witness_field::<Gf4>(&label, 1 << 30, |visit| {
                        visited += 1;
                        replay_checksum = replay_checksum
                            .wrapping_mul(0x9E37_79B1)
                            .wrapping_add(u64::from(visit.cost))
                            .wrapping_add(visit.level_from_base as u64)
                            .wrapping_add(visit.child_count as u64)
                            .wrapping_add(u64::from(visit.target_normalized))
                            .wrapping_add(
                                visit
                                    .label_data
                                    .iter()
                                    .fold(0u64, |sum, &entry| sum + u64::from(entry)),
                            );
                    })
                    .unwrap()
                    .unwrap();
                assert_eq!(visited, answer.witness_nodes);
                work += visited;
                peak_states = peak_states.max(visited);
                checksum = checksum.wrapping_add(replay_checksum);
                black_box(answer);
            } else {
                let answer = tower
                    .answer_target_field::<Gf4>(&label, 1 << 30)
                    .unwrap()
                    .unwrap();
                work += answer.witness_nodes;
                peak_states = peak_states.max(answer.witness_nodes);
                checksum = checksum.wrapping_add(u64::from(answer.cost));
                black_box(answer);
            }
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((family_count, option_count, width, seed)) = orbit_grid_spec(&variant) {
        let family_sizes = vec![option_count; family_count];
        let (families, target) = orbit_problem_with(&family_sizes, width, seed);
        for _ in 0..repetitions {
            let answer = ternary_orbit_syndrome_search(&families, &target, &[]).unwrap();
            work += answer.states_examined;
            peak_states = peak_states.max(answer.correlated_suffix_states);
            checksum = checksum.wrapping_add(answer.feasible() as u64);
            black_box(answer);
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((backend, resources, capacity, demands)) =
        heterogeneous_scheduler_grid_spec(&variant)
    {
        let problem = heterogeneous_scheduler_problem_with(resources, capacity, demands);
        let planner_dense = problem.recommended_backend() == WeightedSchedulerBackend::DenseLattice;
        #[cfg(feature = "parallel")]
        let parallel_pool = backend.strip_prefix("parallel-").map(|threads| {
            rayon::ThreadPoolBuilder::new()
                .num_threads(threads.parse::<usize>().expect("invalid thread count"))
                .build()
                .unwrap()
        });
        for _ in 0..repetitions {
            let answer = if backend == "adaptive" {
                problem.solve_adaptive().unwrap()
            } else if backend.starts_with("parallel-") {
                #[cfg(feature = "parallel")]
                {
                    parallel_pool
                        .as_ref()
                        .expect("parallel pool was compiled")
                        .install(|| problem.solve_adaptive_parallel().unwrap())
                }
                #[cfg(not(feature = "parallel"))]
                panic!("parallel benchmark requires the parallel feature")
            } else {
                panic!("unknown heterogeneous scheduler backend")
            };
            work += answer.transitions_examined;
            peak_states = peak_states.max(u64::from(answer.peak_pareto_states));
            checksum = checksum.wrapping_add(answer.repaired_count() as u64);
            black_box(answer);
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum},\"planner_dense\":{planner_dense}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((backend, resources, capacity, demands, options, seed)) =
        graded_scheduler_grid_spec(&variant)
    {
        let certified = backend.starts_with("graded-");
        let streaming = backend.starts_with("graded-stream");
        let problem = if streaming {
            assert_eq!(resources, 4, "streaming fixture has four resources");
            graded_scheduler_problem_streaming_4(capacity, demands, options, seed)
        } else {
            graded_scheduler_problem_with(resources, capacity, demands, options, seed, certified)
        };
        let planner_dense = problem.recommended_backend() == WeightedSchedulerBackend::DenseLattice;
        let mut workspace = WeightedRepairWorkspace::new();
        #[cfg(feature = "parallel")]
        let parallel_pool = backend
            .strip_prefix("graded-parallel-")
            .or_else(|| backend.strip_prefix("graded-stream-parallel-"))
            .map(|threads| {
                rayon::ThreadPoolBuilder::new()
                    .num_threads(threads.parse::<usize>().expect("invalid thread count"))
                    .build()
                    .unwrap()
            });
        for _ in 0..repetitions {
            let answer = match backend {
                "flat" | "graded-flat" => problem.solve().unwrap(),
                "dense" | "graded-dense" => problem.solve_dense_lattice().unwrap(),
                "adaptive" | "graded-adaptive" => problem.solve_adaptive().unwrap(),
                "graded-stream" => problem
                    .solve_adaptive_with_workspace(&mut workspace)
                    .unwrap(),
                "graded-dense-workspace" => problem
                    .solve_dense_lattice_with_workspace(&mut workspace)
                    .unwrap(),
                "graded-adaptive-workspace" => problem
                    .solve_adaptive_with_workspace(&mut workspace)
                    .unwrap(),
                backend
                    if backend.starts_with("graded-parallel-")
                        || backend.starts_with("graded-stream-parallel-") =>
                {
                    #[cfg(feature = "parallel")]
                    {
                        parallel_pool
                            .as_ref()
                            .expect("parallel pool was compiled")
                            .install(|| {
                                problem
                                    .solve_adaptive_parallel_with_workspace(&mut workspace)
                                    .unwrap()
                            })
                    }
                    #[cfg(not(feature = "parallel"))]
                    panic!("parallel benchmark requires the parallel feature")
                }
                _ => panic!("unknown graded scheduler grid backend"),
            };
            work += answer.transitions_examined;
            peak_states = peak_states.max(u64::from(answer.peak_pareto_states));
            checksum = checksum.wrapping_add(answer.repaired_count() as u64);
            black_box(answer);
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum},\"planner_dense\":{planner_dense},\"graded\":{certified}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((backend, resources, capacity, demands, options, seed)) =
        scheduler_grid_spec(&variant)
    {
        let problem = scheduler_problem_with(resources, capacity, demands, options, seed);
        let planner_dense = problem.recommended_backend() == WeightedSchedulerBackend::DenseLattice;
        for _ in 0..repetitions {
            let answer = match backend {
                "flat" => problem.solve().unwrap(),
                "dense" => problem.solve_dense_lattice().unwrap(),
                "adaptive" => problem.solve_adaptive().unwrap(),
                _ => panic!("unknown scheduler grid backend"),
            };
            work += answer.transitions_examined;
            peak_states = peak_states.max(u64::from(answer.peak_pareto_states));
            checksum = checksum.wrapping_add(answer.repaired_count() as u64);
            black_box(answer);
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum},\"planner_dense\":{planner_dense}}}",
            peak_rss_kib()
        );
        return;
    }
    match variant.as_str() {
        "scheduler-flat"
        | "scheduler-mixed"
        | "scheduler-dense"
        | "scheduler-dense-unpacked"
        | "scheduler-dense-wide"
        | "scheduler-flat-small"
        | "scheduler-mixed-small"
        | "scheduler-dense-small" => {
            let small = variant.ends_with("-small");
            let problem = scheduler_problem(small);
            for _ in 0..repetitions {
                let answer = if variant.starts_with("scheduler-flat") {
                    problem.solve().unwrap()
                } else if variant.starts_with("scheduler-dense-unpacked") {
                    problem.solve_dense_lattice_unpacked().unwrap()
                } else if variant.starts_with("scheduler-dense-wide") {
                    problem.solve_dense_lattice_wide().unwrap()
                } else if variant.starts_with("scheduler-dense") {
                    problem.solve_dense_lattice().unwrap()
                } else {
                    problem.solve_mixed_radix().unwrap()
                };
                work += answer.transitions_examined;
                peak_states = peak_states.max(u64::from(answer.peak_pareto_states));
                checksum = checksum.wrapping_add(answer.repaired_count() as u64);
                black_box(answer);
            }
        }
        "orbit-coordinate"
        | "orbit-correlated"
        | "orbit-meet"
        | "orbit-meet-unreserved"
        | "orbit-split-count"
        | "orbit-split-balanced" => {
            let (families, target) = if variant.starts_with("orbit-split") {
                orbit_problem_with(&[2, 2, 2, 2, 2, 2, 64], 12, 0xA17E_5A17)
            } else {
                orbit_problem()
            };
            for _ in 0..repetitions {
                if variant.starts_with("orbit-meet") || variant.starts_with("orbit-split") {
                    let answer = if variant == "orbit-meet" || variant == "orbit-split-balanced" {
                        ternary_orbit_syndrome_meet_in_middle(&families, &target, &[]).unwrap()
                    } else if variant == "orbit-split-count" {
                        ternary_orbit_syndrome_meet_in_middle_count_split(&families, &target, &[])
                            .unwrap()
                    } else {
                        ternary_orbit_syndrome_meet_in_middle_unreserved(&families, &target, &[])
                            .unwrap()
                    };
                    work += answer.left_assignments + answer.right_assignments;
                    peak_states = peak_states.max(u64::from(answer.unique_right_states));
                    checksum = checksum.wrapping_add(answer.feasible() as u64);
                    black_box(answer);
                    continue;
                }
                let answer = if variant == "orbit-coordinate" {
                    ternary_orbit_syndrome_search(&families, &target, &[]).unwrap()
                } else {
                    ternary_orbit_syndrome_search_correlated(&families, &target, &[], 100_000)
                        .unwrap()
                };
                work += answer.states_examined;
                peak_states = peak_states.max(answer.correlated_suffix_states);
                checksum = checksum.wrapping_add(answer.feasible() as u64);
                black_box(answer);
            }
        }
        _ => panic!("unknown benchmark variant"),
    }
    let elapsed_ns = started.elapsed().as_nanos();
    println!(
        "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
        peak_rss_kib()
    );
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn lcg_jump_matches_scalar_steps() {
        for steps in [0, 1, 2, 3, 17, 1_000, 1_000_000] {
            let mut scalar = 0xA17E_5EEDu64;
            for _ in 0..steps {
                next_u32(&mut scalar);
            }
            assert_eq!(advance_lcg(0xA17E_5EED, steps), scalar);
        }
    }

    #[test]
    fn streaming_fixture_matches_materialized_problem_and_witness() {
        let materialized = graded_scheduler_problem_with(4, 2, 80, 64, 2719080173, true);
        let streaming = graded_scheduler_problem_streaming_4(2, 80, 64, 2719080173);
        assert_eq!(
            streaming.solve_adaptive().unwrap(),
            materialized.solve_adaptive().unwrap()
        );
    }
}
