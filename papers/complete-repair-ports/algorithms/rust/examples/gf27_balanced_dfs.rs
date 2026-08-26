use ergo_comp::balanced::{
    BalancedDfsLimits, BalancedQueueLimits, BalancedRejectionCore, BalancedTransversalCatalog,
    HighFiberSpec,
};

fn parse_argument(arguments: &[String], index: usize, default: u64) -> u64 {
    arguments
        .get(index)
        .map(|value| value.parse::<u64>().expect("DFS limits must be integers"))
        .unwrap_or(default)
}

fn print_cores(cores: &[BalancedRejectionCore]) {
    for core in cores {
        println!(
            "core category={:?} kappa={} mapping={:?} high={:?} cubic_count={} rows={:?} cells={:?}",
            core.category,
            core.kappa,
            core.mapping_key,
            core.high_values,
            core.cubic_count,
            core.discriminant_rows,
            core.cells,
        );
    }
}

fn main() {
    let arguments = std::env::args().collect::<Vec<_>>();
    let max_tasks = parse_argument(&arguments, 1, 1);
    let max_high_sets = parse_argument(&arguments, 2, 1);
    let max_nodes = parse_argument(&arguments, 3, 10_000);
    let max_terminals = parse_argument(&arguments, 4, 10_000);
    let catalog = BalancedTransversalCatalog::q27();
    if let Some(encoded) = arguments
        .get(5)
        .and_then(|value| value.strip_prefix("high="))
    {
        let values = encoded
            .split(',')
            .map(|value| value.parse::<u8>().expect("high values must be bytes"))
            .collect::<Vec<_>>();
        let high_values: [u8; 9] = values
            .try_into()
            .expect("exactly nine high values are required");
        let work_ordinal = usize::try_from(max_tasks).expect("work ordinal exceeds usize");
        let work_item = catalog
            .all_work_items()
            .get(work_ordinal)
            .expect("work ordinal exceeds the 714-task queue");
        let mapping = &catalog.mappings(work_item.ratio_case as usize).unwrap()
            [work_item.mapping_index as usize];
        let cubic_mask = high_values
            .iter()
            .enumerate()
            .fold(0u16, |mask, (slot, value)| {
                mask | (u16::from(mapping.columns.contains(value)) << slot)
            });
        let spec = HighFiberSpec::new(high_values, cubic_mask)
            .expect("high values must be distinct and nonzero GF(27) elements");
        let result = catalog
            .search_high_incidence_spec(
                work_item.ratio_case as usize,
                work_item.mapping_index as usize,
                &spec,
                BalancedDfsLimits {
                    max_nodes,
                    max_terminal_carriers: max_terminals,
                },
            )
            .expect("exact-spec DFS input is valid");
        println!(
            "status={:?} task={} case={} mapping={} high={:?} cubic_count={} nodes={} terminals={} prefix_mismatches={} split_mask_prunes={} mobius={} max_rank={} rejections={:?}",
            result.status,
            work_ordinal,
            work_item.ratio_case,
            work_item.mapping_index,
            spec.values(),
            spec.cubic_count(),
            result.stats.nodes,
            result.stats.terminal_carriers,
            result.stats.prefix_mismatches,
            result.stats.split_mask_prunes,
            result.stats.mobius_terminal_families,
            result.stats.maximum_rank,
            result.stats.rejection_counts,
        );
        print_cores(&result.rejection_cores);
        return;
    }
    let show_cores = arguments.get(5).is_some_and(|value| value == "cores");
    let result = catalog
        .search_balanced_work_queue(BalancedQueueLimits {
            max_tasks: u16::try_from(max_tasks).expect("task limit exceeds u16"),
            max_high_sets_per_task: max_high_sets,
            per_high_set: BalancedDfsLimits {
                max_nodes,
                max_terminal_carriers: max_terminals,
            },
        })
        .expect("bounded DFS input is valid");
    println!("status={:?} tasks={}", result.status, result.tasks.len());
    for task in &result.tasks {
        let core_sizes = task
            .rejection_cores
            .iter()
            .map(|core| {
                format!(
                    "{:?}:{}+{}",
                    core.category,
                    core.cells.len(),
                    core.discriminant_rows.len()
                )
            })
            .collect::<Vec<_>>()
            .join(",");
        println!(
            "task={} case={} mapping={} orbit={} status={:?} high_sets={} nodes={} terminals={} prefix_mismatches={} duplicate_terminals={} split_mask_prunes={} split_parameters_removed={} mobius={} max_rank={} rejections={:?} cores=[{}]",
            task.work_ordinal,
            task.work_item.ratio_case,
            task.work_item.mapping_index,
            task.work_item.orbit_size,
            task.status,
            task.high_sets_examined,
            task.stats.nodes,
            task.stats.terminal_carriers,
            task.stats.prefix_mismatches,
            task.stats.duplicate_terminals,
            task.stats.split_mask_prunes,
            task.stats.split_parameters_removed,
            task.stats.mobius_terminal_families,
            task.stats.maximum_rank,
            task.stats.rejection_counts,
            core_sizes,
        );
        if show_cores {
            print_cores(&task.rejection_cores);
        }
    }
}
