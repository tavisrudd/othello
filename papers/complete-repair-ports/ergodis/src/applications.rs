//! Application-facing exact kernels built on the recovery-state abstractions.

use crate::field::FiniteField;
use crate::matrix::{canonicalize_rows_in_place_field, Matrix, MatrixError};
use crate::scheduler::{SchedulerError, WeightedRepairProblem};
use crate::zdd::{DirectMemo, Zdd, EMPTY, UNIT};
use num_bigint::BigUint;
use num_traits::ToPrimitive;
use rustc_hash::{FxHashMap, FxHashSet};
use std::collections::VecDeque;
use thiserror::Error;

#[derive(Debug, Error, PartialEq, Eq)]
pub enum ApplicationError {
    #[error(transparent)]
    Matrix(#[from] MatrixError),
    #[error(transparent)]
    Scheduler(#[from] SchedulerError),
    #[error("application input has inconsistent dimensions")]
    Shape,
    #[error("the bounded exact search exhausted its budget of {budget} states")]
    Budget { budget: u64 },
    #[error("the compact application kernel supports at most 128 coordinates or 63 tasks")]
    TooLarge,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CephXorLayer {
    pub parity: u8,
    pub data: Box<[u8]>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CephRepairAnswer {
    pub supports: Box<[Box<[u8]>]>,
    pub closure_rounds: u32,
    pub combinations_examined: u64,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CephCompressedRepairAnswer {
    pub support_count: u64,
    pub first_support: Option<Box<[u8]>>,
    pub closure_rounds: u32,
    pub zdd_nodes: u32,
    pub zdd_operations: u64,
    pub zdd_storage_grew: bool,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CephReliabilityPolynomial {
    /// Number of successful helper-availability sets at each exact cardinality.
    pub success_counts_by_available: Box<[BigUint]>,
}

impl CephReliabilityPolynomial {
    pub fn variable_count(&self) -> usize {
        self.success_counts_by_available.len().saturating_sub(1)
    }

    pub fn evaluate_uniform(&self, probability: f64) -> Option<f64> {
        if !(0.0..=1.0).contains(&probability) {
            return None;
        }
        let size = self.variable_count();
        let failure = 1.0 - probability;
        self.success_counts_by_available
            .iter()
            .enumerate()
            .try_fold(0.0, |sum, (available, count)| {
                Some(
                    sum + count.to_f64()?
                        * probability.powi(available as i32)
                        * failure.powi((size - available) as i32),
                )
            })
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CephAggregatedRepairOption {
    pub loads: Box<[u32]>,
    pub representative_support: Box<[u8]>,
}

#[derive(Clone, Debug)]
pub struct CephAggregatedRepairProblem {
    pub problem: WeightedRepairProblem,
    pub options: Box<[CephAggregatedRepairOption]>,
}

impl CephAggregatedRepairProblem {
    pub fn representative_support(&self, loads: &[u32]) -> Option<&[u8]> {
        self.options
            .binary_search_by(|option| option.loads.as_ref().cmp(loads))
            .ok()
            .map(|index| self.options[index].representative_support.as_ref())
    }
}

#[derive(Debug)]
pub struct CephCompressedRepairFamily {
    coordinate_count: usize,
    eligible_helpers: Box<[bool]>,
    root: u32,
    zdd: Zdd<DirectMemo>,
    closure_rounds: u32,
}

impl CephCompressedRepairFamily {
    pub fn summary(&self) -> Result<CephCompressedRepairAnswer, ApplicationError> {
        Ok(CephCompressedRepairAnswer {
            support_count: self
                .zdd
                .count(self.root)
                .ok_or(ApplicationError::TooLarge)?,
            first_support: self.zdd.first(self.root),
            closure_rounds: self.closure_rounds,
            zdd_nodes: self.zdd.node_count() as u32,
            zdd_operations: self.zdd.operations(),
            zdd_storage_grew: self.zdd.storage_grew(),
        })
    }

    pub fn reliability_polynomial(
        &mut self,
    ) -> Result<CephReliabilityPolynomial, ApplicationError> {
        let success_counts_by_available = self
            .zdd
            .reliability_counts(self.root, &self.eligible_helpers)
            .ok_or(ApplicationError::Budget {
                budget: self.zdd.node_budget() as u64,
            })?;
        Ok(CephReliabilityPolynomial {
            success_counts_by_available,
        })
    }

    pub fn aggregate_for_scheduler(
        &self,
        resource_of_coordinate: &[u8],
        capacities: &[u32],
        demand_count: usize,
        frontier_budget: usize,
    ) -> Result<CephAggregatedRepairProblem, ApplicationError> {
        if resource_of_coordinate.len() != self.coordinate_count
            || resource_of_coordinate
                .iter()
                .any(|&resource| usize::from(resource) >= capacities.len())
        {
            return Err(ApplicationError::Shape);
        }
        let frontier = self
            .zdd
            .aggregate_frontier(
                self.root,
                resource_of_coordinate,
                capacities,
                frontier_budget,
            )
            .ok_or(ApplicationError::Budget {
                budget: frontier_budget as u64,
            })?;
        let mut options = frontier
            .codes
            .iter()
            .zip(frontier.supports)
            .map(|(&code, representative_support)| {
                let loads = frontier
                    .strides
                    .iter()
                    .zip(capacities)
                    .map(|(&stride, &capacity)| (code / stride % (u64::from(capacity) + 1)) as u32)
                    .collect::<Vec<_>>()
                    .into_boxed_slice();
                CephAggregatedRepairOption {
                    loads,
                    representative_support,
                }
            })
            .collect::<Vec<_>>();
        options.sort_unstable_by(|left, right| left.loads.cmp(&right.loads));
        let families =
            (0..demand_count).map(|_| options.iter().map(|option| option.loads.as_ref()));
        let problem = WeightedRepairProblem::from_family_iterators(capacities, families)?;
        Ok(CephAggregatedRepairProblem {
            problem,
            options: options.into_boxed_slice(),
        })
    }
}

fn ceil_sqrt(value: usize) -> usize {
    if value < 2 {
        return value;
    }
    let mut low = 1usize;
    let mut high = 1usize << usize::BITS.div_ceil(2);
    while low < high {
        let middle = low + (high - low) / 2;
        if middle >= value.div_ceil(middle) {
            high = middle;
        } else {
            low = middle + 1;
        }
    }
    low
}

/// Parse Ceph's low-level layer strings. Each contiguous non-underscore run
/// must contain one coding coordinate `c` and at least one data coordinate `D`.
pub fn parse_ceph_xor_layers(
    coordinate_count: usize,
    patterns: &[String],
) -> Result<Vec<CephXorLayer>, ApplicationError> {
    let mut layers = Vec::new();
    for pattern in patterns {
        if pattern.len() != coordinate_count || !pattern.is_ascii() {
            return Err(ApplicationError::Shape);
        }
        let bytes = pattern.as_bytes();
        let mut start = 0;
        while start < bytes.len() {
            while start < bytes.len() && bytes[start] == b'_' {
                start += 1;
            }
            if start == bytes.len() {
                break;
            }
            let mut end = start;
            while end < bytes.len() && bytes[end] != b'_' {
                end += 1;
            }
            let mut parity = None;
            let mut data = Vec::new();
            for (coordinate, &symbol) in bytes.iter().enumerate().take(end).skip(start) {
                match symbol {
                    b'c' if parity.replace(coordinate as u8).is_none() => {}
                    b'D' => data.push(coordinate as u8),
                    _ => return Err(ApplicationError::Shape),
                }
            }
            let parity = parity.ok_or(ApplicationError::Shape)?;
            if data.is_empty() {
                return Err(ApplicationError::Shape);
            }
            layers.push(CephXorLayer {
                parity,
                data: data.into_boxed_slice(),
            });
            start = end;
        }
    }
    Ok(layers)
}

/// Compute the exact inclusion-minimal repair supports generated by recursive
/// XOR layers. Every layer is a parity equation on `parity` and `data`.
pub fn ceph_xor_repair_supports(
    coordinate_count: usize,
    layers: &[CephXorLayer],
    target: usize,
    unavailable: &[usize],
    budget: u64,
) -> Result<CephRepairAnswer, ApplicationError> {
    if coordinate_count > 128
        || target >= coordinate_count
        || layers.iter().any(|layer| {
            usize::from(layer.parity) >= coordinate_count
                || layer
                    .data
                    .iter()
                    .any(|&coordinate| usize::from(coordinate) >= coordinate_count)
        })
    {
        return Err(ApplicationError::Shape);
    }
    let mut unavailable_mask = [false; 256];
    for &coordinate in unavailable {
        if coordinate >= coordinate_count {
            return Err(ApplicationError::Shape);
        }
        unavailable_mask[coordinate] = true;
    }
    let mut supports = vec![Vec::<u128>::new(); coordinate_count];
    for (coordinate, entries) in supports.iter_mut().enumerate() {
        if !unavailable_mask[coordinate] {
            entries.push(1u128 << coordinate);
        }
    }
    let mut examined = 0u64;
    let mut rounds = 0u32;
    loop {
        let mut changed = false;
        rounds += 1;
        for layer in layers {
            let mut group = Vec::with_capacity(layer.data.len() + 1);
            group.push(usize::from(layer.parity));
            group.extend(layer.data.iter().map(|&coordinate| usize::from(coordinate)));
            group.sort_unstable();
            group.dedup();
            if group.len() != layer.data.len() + 1 {
                return Err(ApplicationError::Shape);
            }
            for &destination in &group {
                let sources: Vec<_> = group
                    .iter()
                    .copied()
                    .filter(|&coordinate| coordinate != destination)
                    .collect();
                if sources
                    .iter()
                    .any(|&coordinate| supports[coordinate].is_empty())
                {
                    continue;
                }
                let mut products = vec![0u128];
                for source in sources {
                    let old = std::mem::take(&mut products);
                    products = Vec::with_capacity(old.len().saturating_mul(supports[source].len()));
                    for prefix in old {
                        for &suffix in &supports[source] {
                            examined += 1;
                            if examined > budget {
                                return Err(ApplicationError::Budget { budget });
                            }
                            products.push(prefix | suffix);
                        }
                    }
                    canonicalize_support_antichain(&mut products);
                }
                for candidate in products {
                    changed |= insert_minimal_support(&mut supports[destination], candidate);
                }
            }
        }
        if !changed {
            break;
        }
    }
    let mut answer = supports[target].clone();
    canonicalize_support_antichain(&mut answer);
    Ok(CephRepairAnswer {
        supports: answer
            .into_iter()
            .map(|mask| {
                (0..coordinate_count)
                    .filter(|&coordinate| mask & (1u128 << coordinate) != 0)
                    .map(|coordinate| coordinate as u8)
                    .collect::<Vec<_>>()
                    .into_boxed_slice()
            })
            .collect::<Vec<_>>()
            .into_boxed_slice(),
        closure_rounds: rounds,
        combinations_examined: examined,
    })
}

/// Compute the exact inclusion-minimal repair-support family as a reduced
/// zero-suppressed decision diagram. This returns its cardinality and one
/// canonical member without materializing the complete family.
pub fn ceph_xor_repair_supports_compressed(
    coordinate_count: usize,
    layers: &[CephXorLayer],
    target: usize,
    unavailable: &[usize],
    node_budget: usize,
) -> Result<CephCompressedRepairAnswer, ApplicationError> {
    ceph_xor_repair_family(coordinate_count, layers, target, unavailable, node_budget)?.summary()
}

pub fn ceph_xor_repair_family(
    coordinate_count: usize,
    layers: &[CephXorLayer],
    target: usize,
    unavailable: &[usize],
    node_budget: usize,
) -> Result<CephCompressedRepairFamily, ApplicationError> {
    if coordinate_count > usize::from(u8::MAX) + 1
        || target >= coordinate_count
        || layers.iter().any(|layer| {
            usize::from(layer.parity) >= coordinate_count
                || layer
                    .data
                    .iter()
                    .any(|&coordinate| usize::from(coordinate) >= coordinate_count)
        })
    {
        return Err(ApplicationError::Shape);
    }
    let mut unavailable_mask = [false; 256];
    for &coordinate in unavailable {
        if coordinate >= coordinate_count {
            return Err(ApplicationError::Shape);
        }
        unavailable_mask[coordinate] = true;
    }
    let structural_units = layers
        .iter()
        .map(|layer| layer.data.len() + 2)
        .sum::<usize>();
    let mut parity_multiplicity = [0usize; 256];
    let mut data_multiplicity = [0usize; 256];
    for layer in layers {
        parity_multiplicity[usize::from(layer.parity)] += 1;
        for &coordinate in &layer.data {
            data_multiplicity[usize::from(coordinate)] += 1;
        }
    }
    let role_fanout = parity_multiplicity
        .into_iter()
        .chain(data_multiplicity)
        .max()
        .unwrap_or(0);
    let capacity_scale_tenths = 8usize.saturating_add(ceil_sqrt(role_fanout.saturating_mul(36)));
    let memo_capacity_hint = coordinate_count.saturating_mul(structural_units);
    let node_capacity_hint = memo_capacity_hint
        .saturating_mul(capacity_scale_tenths)
        .div_ceil(10);
    ceph_xor_repair_family_with(
        coordinate_count,
        layers,
        target,
        &unavailable_mask,
        node_budget,
        node_capacity_hint,
        memo_capacity_hint,
    )
}

fn ceph_xor_repair_family_with(
    coordinate_count: usize,
    layers: &[CephXorLayer],
    target: usize,
    unavailable: &[bool; 256],
    node_budget: usize,
    node_capacity_hint: usize,
    memo_capacity_hint: usize,
) -> Result<CephCompressedRepairFamily, ApplicationError> {
    let group_coordinates = layers
        .iter()
        .map(|layer| layer.data.len() + 1)
        .sum::<usize>();
    let mut group_data = Vec::with_capacity(group_coordinates);
    let mut group_offsets = Vec::with_capacity(layers.len() + 1);
    group_offsets.push(0usize);
    for layer in layers {
        let mut seen = [false; 256];
        let start = group_data.len();
        for coordinate in std::iter::once(layer.parity).chain(layer.data.iter().copied()) {
            let coordinate = usize::from(coordinate);
            if seen[coordinate] {
                return Err(ApplicationError::Shape);
            }
            seen[coordinate] = true;
            group_data.push(coordinate);
        }
        group_data[start..].sort_unstable();
        group_offsets.push(group_data.len());
    }
    let mut zdd =
        Zdd::<DirectMemo>::with_capacities(node_budget, node_capacity_hint, memo_capacity_hint);
    let mut supports = Vec::with_capacity(coordinate_count);
    for (coordinate, &is_unavailable) in unavailable.iter().take(coordinate_count).enumerate() {
        let root = if is_unavailable {
            EMPTY
        } else {
            zdd.singleton(coordinate as u32)
                .ok_or(ApplicationError::Budget {
                    budget: node_budget as u64,
                })?
        };
        supports.push(root);
    }
    let mut closure_rounds = 0u32;
    loop {
        let mut changed = false;
        closure_rounds += 1;
        for offsets in group_offsets.windows(2) {
            let group = &group_data[offsets[0]..offsets[1]];
            for &destination in group {
                let mut product = UNIT;
                for &source in group {
                    if source != destination {
                        product = zdd.join(product, supports[source]).ok_or(
                            ApplicationError::Budget {
                                budget: node_budget as u64,
                            },
                        )?;
                    }
                }
                let combined =
                    zdd.union(supports[destination], product)
                        .ok_or(ApplicationError::Budget {
                            budget: node_budget as u64,
                        })?;
                let minimal = zdd.minimal(combined).ok_or(ApplicationError::Budget {
                    budget: node_budget as u64,
                })?;
                if minimal != supports[destination] {
                    supports[destination] = minimal;
                    changed = true;
                }
            }
        }
        if !changed {
            break;
        }
    }
    Ok(CephCompressedRepairFamily {
        coordinate_count,
        eligible_helpers: unavailable[..coordinate_count]
            .iter()
            .map(|&is_unavailable| !is_unavailable)
            .collect(),
        root: supports[target],
        zdd,
        closure_rounds,
    })
}

#[allow(clippy::manual_contains)] // This is a subset test, not equality.
fn insert_minimal_support(antichain: &mut Vec<u128>, candidate: u128) -> bool {
    if antichain.iter().any(|&old| old & candidate == old) {
        return false;
    }
    antichain.retain(|&old| candidate & old != candidate);
    antichain.push(candidate);
    true
}

#[allow(clippy::manual_contains)] // This is a subset test, not equality.
fn canonicalize_support_antichain(supports: &mut Vec<u128>) {
    supports.sort_unstable_by_key(|mask| (mask.count_ones(), *mask));
    let mut write = 0;
    for read in 0..supports.len() {
        let candidate = supports[read];
        if supports[..write].iter().any(|&old| old & candidate == old) {
            continue;
        }
        supports[write] = candidate;
        write += 1;
    }
    supports.truncate(write);
}

/// Compile the published Azure LRC(12,2,2) upgrade-domain layout into an exact
/// batch scheduler. Demands cycle through the twelve data fragments.
pub fn azure_lrc_12_2_2_upgrade_domains(
    capacities: &[u32; 9],
    demand_count: usize,
) -> Result<WeightedRepairProblem, ApplicationError> {
    let families = (0..demand_count).map(|demand| {
        let target = demand % 12;
        let local_index = target % 6;
        let local_parity_domain = 6;
        let mut local = vec![0u32; 9];
        for (domain, load) in local.iter_mut().enumerate().take(6) {
            if domain != local_index {
                *load = 1;
            }
        }
        local[local_parity_domain] = 1;

        let mut global_zero = vec![0u32; 9];
        for data in 0..12 {
            if data != target {
                global_zero[data % 6] += 1;
            }
        }
        global_zero[7] = 1;
        let mut global_one = global_zero.clone();
        global_one[7] = 0;
        global_one[8] = 1;
        vec![local, global_zero, global_one]
    });
    WeightedRepairProblem::from_family_iterators(capacities, families).map_err(Into::into)
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct AzureLrcBatchAnswer {
    /// Per data-domain counts in `[local, global-parity-0, global-parity-1]`
    /// order. Demands of each type can be assigned deterministically in their
    /// input order.
    pub mode_counts: [[u64; 3]; 6],
    pub repaired_count: u64,
    pub total_loads: [u64; 9],
    pub totals_checked: u64,
}

/// Exact counted-family compiler for the published Azure LRC(12,2,2)
/// upgrade-domain layout. The twelve data labels have six distinct load
/// types, and the load on data domain `i` is `(L + 2G) - s_i` for total local
/// repairs `L`, global repairs `G`, and served demands `s_i` of that type.
pub fn azure_lrc_12_2_2_counted(capacities: &[u32; 9], demand_count: usize) -> AzureLrcBatchAnswer {
    let complete_cycles = demand_count / 6;
    let remainder = demand_count % 6;
    let multiplicities: [u64; 6] =
        std::array::from_fn(|kind| complete_cycles as u64 + u64::from(kind < remainder));
    let local_capacity = u64::from(capacities[6]);
    let global_capacity = u64::from(capacities[7]) + u64::from(capacities[8]);
    let maximum = (demand_count as u64).min(local_capacity + global_capacity);
    let mut totals_checked = 0u64;
    for served in (0..=maximum).rev() {
        totals_checked += 1;
        let local = served.min(local_capacity);
        let global = served - local;
        if global > global_capacity {
            continue;
        }
        let aggregate_data = local + 2 * global;
        let lower: [u64; 6] = std::array::from_fn(|domain| {
            aggregate_data.saturating_sub(u64::from(capacities[domain]))
        });
        if lower
            .iter()
            .zip(multiplicities)
            .any(|(&needed, available)| needed > available)
            || lower.iter().sum::<u64>() > served
        {
            continue;
        }
        let mut selected = lower;
        let mut remaining = served - selected.iter().sum::<u64>();
        for domain in 0..6 {
            let add = remaining.min(multiplicities[domain] - selected[domain]);
            selected[domain] += add;
            remaining -= add;
        }
        debug_assert_eq!(remaining, 0);
        let mut local_by_domain = [0u64; 6];
        let mut local_remaining = local;
        for domain in 0..6 {
            local_by_domain[domain] = local_remaining.min(selected[domain]);
            local_remaining -= local_by_domain[domain];
        }
        debug_assert_eq!(local_remaining, 0);
        let global_by_domain: [u64; 6] =
            std::array::from_fn(|domain| selected[domain] - local_by_domain[domain]);
        let global_zero_total = global.min(u64::from(capacities[7]));
        let mut global_zero_remaining = global_zero_total;
        let mut mode_counts = [[0u64; 3]; 6];
        for domain in 0..6 {
            let global_zero = global_zero_remaining.min(global_by_domain[domain]);
            global_zero_remaining -= global_zero;
            mode_counts[domain] = [
                local_by_domain[domain],
                global_zero,
                global_by_domain[domain] - global_zero,
            ];
        }
        debug_assert_eq!(global_zero_remaining, 0);
        let mut total_loads = [0u64; 9];
        for domain in 0..6 {
            total_loads[domain] = aggregate_data - selected[domain];
        }
        total_loads[6] = local;
        total_loads[7] = global_zero_total;
        total_loads[8] = global - global_zero_total;
        debug_assert!(total_loads
            .iter()
            .zip(capacities)
            .all(|(&load, &capacity)| load <= u64::from(capacity)));
        return AzureLrcBatchAnswer {
            mode_counts,
            repaired_count: served,
            total_loads,
            totals_checked,
        };
    }
    AzureLrcBatchAnswer {
        mode_counts: [[0; 3]; 6],
        repaired_count: 0,
        total_loads: [0; 9],
        totals_checked,
    }
}

/// Compile simultaneous recovery of failed MDS-protected checkpoint shards.
/// Resource coordinates are per-node reads followed by same-rack and
/// cross-rack transfers. This models an erasure-coded in-memory checkpoint
/// after the DP/PP/TP placement has been fixed.
pub fn gpu_checkpoint_mds_recovery(
    data_shards: usize,
    shard_nodes: &[u16],
    node_racks: &[u16],
    failed_shards: &[usize],
    replacement_nodes: &[u16],
    capacities: &[u32],
    option_budget: u64,
) -> Result<WeightedRepairProblem, ApplicationError> {
    let node_count = node_racks.len();
    if data_shards == 0
        || data_shards > shard_nodes.len()
        || shard_nodes.len() > usize::from(u16::MAX) + 1
        || failed_shards.len() != replacement_nodes.len()
        || capacities.len() != node_count + 2
        || shard_nodes
            .iter()
            .chain(replacement_nodes)
            .any(|&node| usize::from(node) >= node_count)
        || failed_shards
            .iter()
            .any(|&shard| shard >= shard_nodes.len())
    {
        return Err(ApplicationError::Shape);
    }
    let failed: FxHashSet<usize> = failed_shards.iter().copied().collect();
    let survivors: Vec<_> = (0..shard_nodes.len())
        .filter(|shard| !failed.contains(shard))
        .collect();
    if survivors.len() < data_shards {
        return Err(ApplicationError::Shape);
    }
    let mut combinations = Vec::new();
    enumerate_combinations(
        &survivors,
        data_shards,
        0,
        &mut Vec::with_capacity(data_shards),
        &mut combinations,
        option_budget,
    )?;
    let families = replacement_nodes.iter().map(|&replacement| {
        let combinations = &combinations;
        combinations.iter().map(move |helpers| {
            let mut loads = vec![0u32; node_count + 2];
            for &helper in helpers {
                let node = usize::from(shard_nodes[helper]);
                loads[node] += 1;
                if node != usize::from(replacement) {
                    let tier = if node_racks[node] == node_racks[usize::from(replacement)] {
                        node_count
                    } else {
                        node_count + 1
                    };
                    loads[tier] += 1;
                }
            }
            loads
        })
    });
    WeightedRepairProblem::from_family_iterators(capacities, families).map_err(Into::into)
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct GpuCheckpointBatchAnswer {
    /// Slot-major witness: entry `slot * failure_count + failure` is one
    /// helper shard for that failure.
    pub helper_shards: Box<[u16]>,
    pub failure_count: u32,
    pub data_shards: u32,
    pub node_loads: Box<[u32]>,
    pub same_rack_load: u32,
    pub cross_rack_load: u32,
    pub assignments: u64,
}

impl GpuCheckpointBatchAnswer {
    pub fn helper_shard(&self, failure: usize, slot: usize) -> Option<u16> {
        if failure >= self.failure_count as usize || slot >= self.data_shards as usize {
            return None;
        }
        self.helper_shards
            .get(slot * self.failure_count as usize + failure)
            .copied()
    }
}

#[derive(Clone, Copy, Debug)]
pub struct GpuCheckpointCapacities<'a> {
    pub nodes: &'a [u32],
    pub same_rack: u32,
    pub cross_rack: u32,
}

/// Recover a complete batch of MDS checkpoint shards into one replacement
/// rack when every surviving helper is remote from every replacement node.
/// Complete MDS helper eligibility reduces feasibility to aggregate node and
/// rack capacities. A cyclic degree realization then returns distinct helper
/// shards without materializing the complete failure-by-shard graph.
pub fn gpu_checkpoint_mds_same_rack_recovery(
    data_shards: usize,
    shard_nodes: &[u16],
    node_racks: &[u16],
    failed_shards: &[usize],
    replacement_nodes: &[u16],
    capacities: GpuCheckpointCapacities<'_>,
) -> Result<Option<GpuCheckpointBatchAnswer>, ApplicationError> {
    let node_count = node_racks.len();
    if data_shards == 0
        || data_shards > shard_nodes.len()
        || failed_shards.len() != replacement_nodes.len()
        || capacities.nodes.len() != node_count
        || shard_nodes
            .iter()
            .chain(replacement_nodes)
            .any(|&node| usize::from(node) >= node_count)
        || failed_shards
            .iter()
            .any(|&shard| shard >= shard_nodes.len())
    {
        return Err(ApplicationError::Shape);
    }
    if failed_shards.is_empty() {
        return Ok(Some(GpuCheckpointBatchAnswer {
            helper_shards: Box::new([]),
            failure_count: 0,
            data_shards: data_shards as u32,
            node_loads: vec![0; node_count].into_boxed_slice(),
            same_rack_load: 0,
            cross_rack_load: 0,
            assignments: 0,
        }));
    }
    let replacement_rack = node_racks[usize::from(replacement_nodes[0])];
    if replacement_nodes
        .iter()
        .any(|&node| node_racks[usize::from(node)] != replacement_rack)
    {
        return Err(ApplicationError::Shape);
    }
    let failed: FxHashSet<usize> = failed_shards.iter().copied().collect();
    let survivors: Vec<_> = (0..shard_nodes.len())
        .filter(|shard| !failed.contains(shard))
        .collect();
    let replacement_set: FxHashSet<u16> = replacement_nodes.iter().copied().collect();
    if survivors
        .iter()
        .any(|&shard| replacement_set.contains(&shard_nodes[shard]))
    {
        return Err(ApplicationError::Shape);
    }
    if survivors.len() < data_shards {
        return Ok(None);
    }
    let failure_count = failed_shards.len();
    let failure_count_u32 = u32::try_from(failure_count).map_err(|_| ApplicationError::Shape)?;
    let required = u64::try_from(data_shards)
        .ok()
        .and_then(|data| data.checked_mul(failure_count as u64))
        .ok_or(ApplicationError::Shape)?;
    let required_usize = usize::try_from(required).map_err(|_| ApplicationError::Shape)?;
    let mut survivor_counts = vec![0usize; node_count];
    for &shard in &survivors {
        survivor_counts[usize::from(shard_nodes[shard])] += 1;
    }
    let mut survivor_offsets = Vec::with_capacity(node_count + 1);
    survivor_offsets.push(0usize);
    for &count in &survivor_counts {
        let previous = survivor_offsets[survivor_offsets.len() - 1];
        survivor_offsets.push(previous + count);
    }
    let mut write_offsets = survivor_offsets[..node_count].to_vec();
    let mut grouped_survivors = vec![0u16; survivors.len()];
    for &shard in &survivors {
        let node = usize::from(shard_nodes[shard]);
        grouped_survivors[write_offsets[node]] = shard as u16;
        write_offsets[node] += 1;
    }
    let tier_maximum = |same: bool| -> u64 {
        survivor_counts
            .iter()
            .enumerate()
            .filter(|(node, _)| (node_racks[*node] == replacement_rack) == same)
            .map(|(node, &count)| {
                u64::from(capacities.nodes[node]).min((count as u64) * (failure_count as u64))
            })
            .sum()
    };
    let same_maximum = tier_maximum(true).min(u64::from(capacities.same_rack));
    let cross_maximum = tier_maximum(false).min(u64::from(capacities.cross_rack));
    let minimum_same = required.saturating_sub(cross_maximum);
    let same_target = required.min(same_maximum);
    if minimum_same > same_target {
        return Ok(None);
    }
    let mut node_loads = vec![0u32; node_count];
    let mut degrees = Vec::with_capacity(survivors.len());
    for (same, mut remaining) in [(true, same_target), (false, required - same_target)] {
        for (node, &count) in survivor_counts.iter().enumerate() {
            if remaining == 0 {
                break;
            }
            if (node_racks[node] == replacement_rack) != same {
                continue;
            }
            let take = remaining
                .min(u64::from(capacities.nodes[node]))
                .min((count as u64) * (failure_count as u64));
            node_loads[node] = take as u32;
            let mut node_remaining = take;
            let shards = &grouped_survivors[survivor_offsets[node]..survivor_offsets[node + 1]];
            for &shard in shards {
                if node_remaining == 0 {
                    break;
                }
                let degree = node_remaining.min(failure_count as u64) as usize;
                degrees.push((shard, degree));
                node_remaining -= degree as u64;
            }
            remaining -= take;
        }
        if remaining != 0 {
            return Ok(None);
        }
    }
    let mut helper_shards = Vec::with_capacity(required_usize);
    for (shard, degree) in degrees {
        helper_shards.resize(helper_shards.len() + degree, shard);
    }
    debug_assert_eq!(helper_shards.len(), required_usize);
    Ok(Some(GpuCheckpointBatchAnswer {
        helper_shards: helper_shards.into_boxed_slice(),
        failure_count: failure_count_u32,
        data_shards: data_shards as u32,
        node_loads: node_loads.into_boxed_slice(),
        same_rack_load: same_target as u32,
        cross_rack_load: (required - same_target) as u32,
        assignments: required,
    }))
}

fn enumerate_combinations(
    values: &[usize],
    choose: usize,
    next: usize,
    current: &mut Vec<usize>,
    output: &mut Vec<Box<[usize]>>,
    budget: u64,
) -> Result<(), ApplicationError> {
    if current.len() == choose {
        if output.len() as u64 >= budget {
            return Err(ApplicationError::Budget { budget });
        }
        output.push(current.clone().into_boxed_slice());
        return Ok(());
    }
    let needed = choose - current.len();
    for index in next..=values.len() - needed {
        current.push(values[index]);
        enumerate_combinations(values, choose, index + 1, current, output, budget)?;
        current.pop();
    }
    Ok(())
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct RepairTask {
    pub predecessors: u64,
    pub loads: Box<[u16]>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct RepairDagAnswer {
    pub slots: u16,
    pub task_batches: Box<[Box<[u8]>]>,
    pub states_examined: u64,
}

/// Exact unit-slot scheduler for a repair DAG with multidimensional per-slot
/// capacities. It is intended for compact RDAGs after algebraic compilation.
pub fn schedule_repair_dag(
    capacities: &[u16],
    tasks: &[RepairTask],
    budget: u64,
) -> Result<RepairDagAnswer, ApplicationError> {
    if tasks.len() > 63
        || tasks.iter().any(|task| {
            task.loads.len() != capacities.len()
                || task.predecessors >> tasks.len() != 0
                || task
                    .loads
                    .iter()
                    .zip(capacities)
                    .any(|(&load, &capacity)| load > capacity)
        })
    {
        return Err(ApplicationError::Shape);
    }
    let complete = (1u64 << tasks.len()) - 1;
    let mut queue = VecDeque::from([0u64]);
    let mut distance = FxHashMap::default();
    let mut parent = FxHashMap::default();
    distance.insert(0u64, 0u16);
    let mut states_examined = 0u64;
    while let Some(done) = queue.pop_front() {
        states_examined += 1;
        if states_examined > budget {
            return Err(ApplicationError::Budget { budget });
        }
        if done == complete {
            let mut batches = Vec::new();
            let mut cursor = done;
            while cursor != 0 {
                let &(previous, batch) = parent.get(&cursor).ok_or(ApplicationError::Shape)?;
                batches.push(
                    (0..tasks.len())
                        .filter(|&task| batch & (1u64 << task) != 0)
                        .map(|task| task as u8)
                        .collect::<Vec<_>>()
                        .into_boxed_slice(),
                );
                cursor = previous;
            }
            batches.reverse();
            return Ok(RepairDagAnswer {
                slots: distance[&done],
                task_batches: batches.into_boxed_slice(),
                states_examined,
            });
        }
        let ready = tasks
            .iter()
            .enumerate()
            .filter(|(index, task)| done & (1u64 << index) == 0 && task.predecessors & !done == 0)
            .fold(0u64, |mask, (index, _)| mask | (1u64 << index));
        if batch_fits(capacities, tasks, ready) {
            let next = done | ready;
            if !distance.contains_key(&next) {
                distance.insert(next, distance[&done] + 1);
                parent.insert(next, (done, ready));
                queue.push_back(next);
            }
            continue;
        }
        let mut batch = ready;
        while batch != 0 {
            if batch_fits(capacities, tasks, batch) {
                let next = done | batch;
                if !distance.contains_key(&next) {
                    distance.insert(next, distance[&done] + 1);
                    parent.insert(next, (done, batch));
                    queue.push_back(next);
                }
            }
            batch = (batch - 1) & ready;
        }
    }
    Err(ApplicationError::Shape)
}

fn batch_fits(capacities: &[u16], tasks: &[RepairTask], batch: u64) -> bool {
    let mut loads = vec![0u32; capacities.len()];
    for (task_index, task) in tasks.iter().enumerate() {
        if batch & (1u64 << task_index) == 0 {
            continue;
        }
        for (total, &load) in loads.iter_mut().zip(task.loads.iter()) {
            *total += u32::from(load);
        }
    }
    loads
        .iter()
        .zip(capacities)
        .all(|(&load, &capacity)| load <= u32::from(capacity))
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct QcLdpcCode {
    check_groups: u16,
    variable_groups: u16,
    lift: u16,
    shifts: Box<[Option<u16>]>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct QcTrappingSetAnswer {
    pub variables: Box<[u32]>,
    pub odd_checks: u32,
    pub candidates_examined: u64,
    pub cyclic_normalization_factor: u16,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct QcSearchResult {
    pub answer: Option<QcTrappingSetAnswer>,
    pub candidates_examined: u64,
}

impl QcLdpcCode {
    pub fn new(
        check_groups: usize,
        variable_groups: usize,
        lift: usize,
        shifts: Vec<Option<u16>>,
    ) -> Result<Self, ApplicationError> {
        if check_groups == 0
            || variable_groups == 0
            || lift == 0
            || shifts.len() != check_groups.saturating_mul(variable_groups)
            || shifts
                .iter()
                .flatten()
                .any(|&shift| usize::from(shift) >= lift)
        {
            return Err(ApplicationError::Shape);
        }
        Ok(Self {
            check_groups: check_groups
                .try_into()
                .map_err(|_| ApplicationError::TooLarge)?,
            variable_groups: variable_groups
                .try_into()
                .map_err(|_| ApplicationError::TooLarge)?,
            lift: lift.try_into().map_err(|_| ApplicationError::TooLarge)?,
            shifts: shifts.into_boxed_slice(),
        })
    }

    pub fn find_trapping_set(
        &self,
        size: usize,
        maximum_odd_checks: usize,
        budget: u64,
    ) -> Result<Option<QcTrappingSetAnswer>, ApplicationError> {
        Ok(self
            .search_trapping_set(size, maximum_odd_checks, budget)?
            .answer)
    }

    pub fn search_trapping_set(
        &self,
        size: usize,
        maximum_odd_checks: usize,
        budget: u64,
    ) -> Result<QcSearchResult, ApplicationError> {
        if size == 0 {
            return Ok(QcSearchResult {
                answer: None,
                candidates_examined: 0,
            });
        }
        if maximum_odd_checks == 0 {
            if let Some(result) = self.degree_two_codeword_search(size) {
                return Ok(result);
            }
        }
        let variable_count = usize::from(self.variable_groups) * usize::from(self.lift);
        let check_count = usize::from(self.check_groups) * usize::from(self.lift);
        let mut examined = 0u64;
        for anchor_group in 0..usize::from(self.variable_groups) {
            let anchor = anchor_group * usize::from(self.lift);
            let mut selected = Vec::with_capacity(size);
            selected.push(anchor);
            let mut next_by_depth = vec![0_usize; size + 1];
            let mut check_degrees = vec![0u16; check_count];
            self.update_degrees(anchor, &mut check_degrees, true);
            let odd_checks = self.search_trapping_sets_iterative(
                variable_count,
                size,
                maximum_odd_checks,
                false,
                anchor,
                &mut selected,
                &mut next_by_depth,
                &mut check_degrees,
                &mut examined,
                budget,
            )?;
            if let Some(odd_checks) = odd_checks {
                return Ok(QcSearchResult {
                    answer: Some(QcTrappingSetAnswer {
                        variables: selected
                            .iter()
                            .map(|&variable| variable as u32)
                            .collect::<Vec<_>>()
                            .into_boxed_slice(),
                        odd_checks: odd_checks as u32,
                        candidates_examined: examined,
                        cyclic_normalization_factor: self.lift,
                    }),
                    candidates_examined: examined,
                });
            }
        }
        Ok(QcSearchResult {
            answer: None,
            candidates_examined: examined,
        })
    }

    fn degree_two_codeword_search(&self, size: usize) -> Option<QcSearchResult> {
        let variable_count = usize::from(self.variable_groups) * usize::from(self.lift);
        let mut parent: Vec<_> = (0..variable_count).collect();
        let mut forced_zero = vec![false; variable_count];
        for check_group in 0..usize::from(self.check_groups) {
            for position in 0..usize::from(self.lift) {
                let mut neighbors = Vec::with_capacity(2);
                for variable_group in 0..usize::from(self.variable_groups) {
                    let Some(shift) = self.shifts
                        [check_group * usize::from(self.variable_groups) + variable_group]
                    else {
                        continue;
                    };
                    let variable_position = (position + usize::from(self.lift)
                        - usize::from(shift))
                        % usize::from(self.lift);
                    neighbors.push(variable_group * usize::from(self.lift) + variable_position);
                }
                match neighbors.as_slice() {
                    [] => {}
                    &[variable] => forced_zero[variable] = true,
                    &[left, right] => union_components(&mut parent, left, right),
                    _ => return None,
                }
            }
        }
        for variable in 0..variable_count {
            let root = find_component(&mut parent, variable);
            if forced_zero[variable] {
                forced_zero[root] = true;
            }
        }
        let mut members: FxHashMap<usize, Vec<usize>> = FxHashMap::default();
        for variable in 0..variable_count {
            let root = find_component(&mut parent, variable);
            if !forced_zero[root] {
                members.entry(root).or_default().push(variable);
            }
        }
        let components: Vec<_> = members.into_values().collect();
        let mut choices: Vec<Option<Vec<usize>>> = vec![None; size + 1];
        choices[0] = Some(Vec::new());
        let mut examined = 0u64;
        for (component, variables) in components.iter().enumerate() {
            let weight = variables.len();
            if weight > size {
                examined += 1;
                continue;
            }
            for total in (weight..=size).rev() {
                examined += 1;
                if choices[total].is_none() {
                    if let Some(prefix) = &choices[total - weight] {
                        let mut selected = prefix.clone();
                        selected.push(component);
                        choices[total] = Some(selected);
                    }
                }
            }
        }
        let answer = choices[size].as_ref().map(|selected| {
            let mut variables: Vec<u32> = selected
                .iter()
                .flat_map(|&component| {
                    components[component]
                        .iter()
                        .map(|&variable| variable as u32)
                })
                .collect();
            variables.sort_unstable();
            QcTrappingSetAnswer {
                variables: variables.into_boxed_slice(),
                odd_checks: 0,
                candidates_examined: examined,
                cyclic_normalization_factor: self.lift,
            }
        });
        Some(QcSearchResult {
            answer,
            candidates_examined: examined,
        })
    }

    pub fn find_stopping_set(
        &self,
        maximum_size: usize,
        budget: u64,
    ) -> Result<Option<QcTrappingSetAnswer>, ApplicationError> {
        for size in 1..=maximum_size {
            let variable_count = usize::from(self.variable_groups) * usize::from(self.lift);
            let check_count = usize::from(self.check_groups) * usize::from(self.lift);
            let mut examined = 0u64;
            for anchor_group in 0..usize::from(self.variable_groups) {
                let anchor = anchor_group * usize::from(self.lift);
                let mut selected = Vec::with_capacity(size);
                selected.push(anchor);
                let mut next_by_depth = vec![0_usize; size + 1];
                let mut check_degrees = vec![0u16; check_count];
                self.update_degrees(anchor, &mut check_degrees, true);
                let odd_checks = self.search_trapping_sets_iterative(
                    variable_count,
                    size,
                    0,
                    true,
                    anchor,
                    &mut selected,
                    &mut next_by_depth,
                    &mut check_degrees,
                    &mut examined,
                    budget,
                )?;
                if let Some(odd_checks) = odd_checks {
                    return Ok(Some(QcTrappingSetAnswer {
                        variables: selected
                            .iter()
                            .map(|&variable| variable as u32)
                            .collect::<Vec<_>>()
                            .into_boxed_slice(),
                        odd_checks: odd_checks as u32,
                        candidates_examined: examined,
                        cyclic_normalization_factor: self.lift,
                    }));
                }
            }
        }
        Ok(None)
    }

    #[allow(clippy::too_many_arguments)]
    fn search_trapping_sets_iterative(
        &self,
        variable_count: usize,
        target_size: usize,
        maximum_odd_checks: usize,
        stopping: bool,
        anchor: usize,
        selected: &mut Vec<usize>,
        next_by_depth: &mut [usize],
        check_degrees: &mut [u16],
        examined: &mut u64,
        budget: u64,
    ) -> Result<Option<usize>, ApplicationError> {
        #[cfg(test)]
        let _allocation_guard = crate::test_alloc::HotLoopAllocationGuard::enter();
        debug_assert_eq!(selected.as_slice(), &[anchor]);
        debug_assert!(next_by_depth.len() > target_size);
        next_by_depth[1] = 0;
        loop {
            let depth = selected.len();
            if depth == target_size {
                *examined += 1;
                if *examined > budget {
                    return Err(ApplicationError::Budget { budget });
                }
                let odd = check_degrees
                    .iter()
                    .filter(|&&degree| degree & 1 != 0)
                    .count();
                let accepted = if stopping {
                    check_degrees.iter().all(|&degree| degree != 1)
                } else {
                    odd <= maximum_odd_checks
                };
                if accepted {
                    return Ok(Some(odd));
                }
                if depth == 1 {
                    return Ok(None);
                }
                let variable = selected.pop().unwrap();
                self.update_degrees(variable, check_degrees, false);
                continue;
            }

            let needed = target_size - depth;
            let mut variable = next_by_depth[depth];
            while variable < variable_count
                && (variable == anchor || variable_count - variable < needed)
            {
                variable += 1;
            }
            if variable == variable_count {
                if depth == 1 {
                    return Ok(None);
                }
                let variable = selected.pop().unwrap();
                self.update_degrees(variable, check_degrees, false);
                continue;
            }

            next_by_depth[depth] = variable + 1;
            selected.push(variable);
            self.update_degrees(variable, check_degrees, true);
            next_by_depth[depth + 1] = variable + 1;
        }
    }

    fn update_degrees(&self, variable: usize, degrees: &mut [u16], add: bool) {
        let group = variable / usize::from(self.lift);
        let position = variable % usize::from(self.lift);
        for check_group in 0..usize::from(self.check_groups) {
            let Some(shift) = self.shifts[check_group * usize::from(self.variable_groups) + group]
            else {
                continue;
            };
            let check = check_group * usize::from(self.lift)
                + (position + usize::from(shift)) % usize::from(self.lift);
            if add {
                degrees[check] += 1;
            } else {
                degrees[check] -= 1;
            }
        }
    }
}

fn find_component(parent: &mut [usize], mut value: usize) -> usize {
    while parent[value] != value {
        parent[value] = parent[parent[value]];
        value = parent[value];
    }
    value
}

fn union_components(parent: &mut [usize], left: usize, right: usize) {
    let left = find_component(parent, left);
    let right = find_component(parent, right);
    if left != right {
        parent[right] = left;
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct NodeSpanRepairAnswer {
    pub node_cost: u16,
    pub nodes: Box<[u16]>,
    pub generated_spans: usize,
    pub transitions: u64,
}

#[derive(Clone)]
struct NodeSpanState {
    rows: u16,
    data: Box<[u8]>,
    nodes: Box<[u16]>,
}

/// Minimum number of storage nodes whose combined symbol span contains every
/// target column. Multiple subpacketization columns from one node cost one.
pub fn minimum_node_span_repair<F: FiniteField>(
    generator: &Matrix,
    coordinate_nodes: &[u16],
    target: &Matrix,
    state_budget: usize,
) -> Result<Option<NodeSpanRepairAnswer>, ApplicationError> {
    F::validate().map_err(MatrixError::from)?;
    if coordinate_nodes.len() != generator.cols() || target.rows() != generator.rows() {
        return Err(ApplicationError::Shape);
    }
    let node_count = coordinate_nodes
        .iter()
        .copied()
        .max()
        .map_or(0usize, |node| usize::from(node) + 1);
    let ambient = generator.rows();
    let mut node_columns = vec![0usize; node_count];
    for &node in coordinate_nodes {
        node_columns[usize::from(node)] += 1;
    }
    let mut node_offsets = Vec::with_capacity(node_count + 1);
    node_offsets.push(0usize);
    for &columns in &node_columns {
        let previous = node_offsets[node_offsets.len() - 1];
        node_offsets.push(previous + columns);
    }
    let mut write_offsets = node_offsets[..node_count].to_vec();
    let mut grouped_data = vec![0u8; generator.cols() * ambient];
    for (coordinate, &node) in coordinate_nodes.iter().enumerate() {
        let node = usize::from(node);
        let offset = write_offsets[node] * ambient;
        for row in 0..ambient {
            grouped_data[offset + row] = generator.as_slice()[row * generator.cols() + coordinate];
        }
        write_offsets[node] += 1;
    }
    let mut node_bases = Vec::with_capacity(node_count);
    let mut distinct_bases = FxHashSet::default();
    let mut data =
        Vec::with_capacity(node_columns.iter().copied().max().unwrap_or_default() * ambient);
    for node in 0..node_count {
        let rows = node_columns[node];
        let start = node_offsets[node] * ambient;
        let end = node_offsets[node + 1] * ambient;
        data.clear();
        data.extend_from_slice(&grouped_data[start..end]);
        let rank = canonicalize_rows_in_place_field::<F>(&mut data, rows, ambient)?;
        let basis = &data[..rank * ambient];
        if !distinct_bases.contains(basis) {
            let key: Box<[u8]> = basis.into();
            distinct_bases.insert(key.clone());
            node_bases.push((node as u16, rank, key));
        }
    }
    let mut states = vec![NodeSpanState {
        rows: 0,
        data: Box::new([]),
        nodes: Box::new([]),
    }];
    let mut transitions = 0u64;
    for (node, node_rows, node_data) in &node_bases {
        let old = states.clone();
        let mut index: FxHashMap<Box<[u8]>, usize> = states
            .iter()
            .enumerate()
            .map(|(position, state)| (state.data.clone(), position))
            .collect();
        for state in old {
            transitions += 1;
            let mut data = state.data.to_vec();
            data.extend_from_slice(node_data);
            let rank = canonicalize_rows_in_place_field::<F>(
                &mut data,
                usize::from(state.rows) + *node_rows,
                ambient,
            )?;
            data.truncate(rank * ambient);
            if rank == usize::from(state.rows) {
                continue;
            }
            let mut nodes = state.nodes.to_vec();
            nodes.push(*node);
            let key: Box<[u8]> = data.into_boxed_slice();
            if let Some(&position) = index.get(&key) {
                if nodes.len() < states[position].nodes.len() {
                    states[position].nodes = nodes.into_boxed_slice();
                }
                continue;
            }
            if states.len() >= state_budget {
                return Err(ApplicationError::Budget {
                    budget: state_budget as u64,
                });
            }
            index.insert(key.clone(), states.len());
            states.push(NodeSpanState {
                rows: rank as u16,
                data: key,
                nodes: nodes.into_boxed_slice(),
            });
        }
    }
    let target_basis = target
        .transpose_field::<F>()?
        .canonical_row_basis_field::<F>()?;
    let mut best: Option<&NodeSpanState> = None;
    for state in &states {
        let mut data = state.data.to_vec();
        data.extend_from_slice(target_basis.as_slice());
        let rank = canonicalize_rows_in_place_field::<F>(
            &mut data,
            usize::from(state.rows) + target_basis.rows(),
            ambient,
        )?;
        if rank == usize::from(state.rows)
            && best.is_none_or(|old| state.nodes.len() < old.nodes.len())
        {
            best = Some(state);
        }
    }
    Ok(best.map(|state| NodeSpanRepairAnswer {
        node_cost: state.nodes.len() as u16,
        nodes: state.nodes.clone(),
        generated_spans: states.len(),
        transitions,
    }))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::field::Prime;

    #[test]
    fn ceph_documented_layers_recover_through_recursive_xor_paths() {
        let layers = parse_ceph_xor_layers(
            8,
            &["_cDD_cDD".into(), "cDDD____".into(), "____cDDD".into()],
        )
        .unwrap();
        let answer = ceph_xor_repair_supports(8, &layers, 2, &[2], 10_000).unwrap();
        assert_eq!(&*answer.supports, &[Box::from([1, 3])]);
        let compressed = ceph_xor_repair_supports_compressed(8, &layers, 2, &[2], 10_000).unwrap();
        assert_eq!(compressed.support_count, 1);
        assert_eq!(compressed.first_support.as_deref(), Some([1, 3].as_slice()));

        let mut family = ceph_xor_repair_family(8, &layers, 2, &[2], 10_000).unwrap();
        let reliability = family.reliability_polynomial().unwrap();
        assert_eq!(
            &*reliability.success_counts_by_available,
            [0u32, 0, 1, 5, 10, 10, 5, 1].map(BigUint::from).as_slice()
        );
        assert_eq!(reliability.evaluate_uniform(0.5), Some(0.25));

        let aggregated = family
            .aggregate_for_scheduler(&[0, 0, 0, 1, 0, 0, 0, 0], &[3, 3], 3, 10_000)
            .unwrap();
        assert_eq!(
            aggregated.representative_support(&[1, 1]),
            Some([1, 3].as_slice())
        );
        let schedule = aggregated.problem.solve_adaptive().unwrap();
        assert_eq!(schedule.repaired_count(), 3);
        assert_eq!(&*schedule.total_loads, &[3, 3]);
    }

    #[test]
    fn compressed_ceph_family_counts_diamond_fanout_without_enumeration() {
        for levels in 1..=12 {
            let common = levels;
            let mut layers = Vec::with_capacity(2 * levels);
            for level in 0..levels {
                let previous = if level == 0 { common } else { level - 1 };
                for branch in 0..2 {
                    layers.push(CephXorLayer {
                        parity: level as u8,
                        data: Box::new([previous as u8, (levels + 1 + 2 * level + branch) as u8]),
                    });
                }
            }
            let answer = ceph_xor_repair_supports_compressed(
                3 * levels + 1,
                &layers,
                levels - 1,
                &(0..levels).collect::<Vec<_>>(),
                1 << 20,
            )
            .unwrap();
            assert_eq!(answer.support_count, 1u64 << levels);
            assert_eq!(answer.first_support.as_ref().unwrap().len(), levels + 1);
        }
    }

    #[test]
    fn compressed_ceph_matches_explicit_closure_on_seeded_small_layers() {
        let mut state = 0x4f1b_c3d8_a927_650eu64;
        for _ in 0..128 {
            let mut layers = Vec::with_capacity(6);
            for _ in 0..6 {
                let mut coordinates = [0u8; 3];
                for index in 0..3 {
                    loop {
                        state = state
                            .wrapping_mul(6_364_136_223_846_793_005)
                            .wrapping_add(1_442_695_040_888_963_407);
                        let candidate = (state >> 61) as u8;
                        if !coordinates[..index].contains(&candidate) {
                            coordinates[index] = candidate;
                            break;
                        }
                    }
                }
                layers.push(CephXorLayer {
                    parity: coordinates[0],
                    data: Box::new([coordinates[1], coordinates[2]]),
                });
            }
            let target = (state as usize >> 8) & 7;
            let explicit =
                ceph_xor_repair_supports(8, &layers, target, &[target], 1 << 24).unwrap();
            let compressed =
                ceph_xor_repair_supports_compressed(8, &layers, target, &[target], 1 << 20)
                    .unwrap();
            assert_eq!(compressed.support_count as usize, explicit.supports.len());
            if let Some(first) = &compressed.first_support {
                assert!(explicit.supports.iter().any(|support| support == first));
            } else {
                assert!(explicit.supports.is_empty());
            }

            let mut family =
                ceph_xor_repair_family(8, &layers, target, &[target], 1 << 20).unwrap();
            let reliability = family.reliability_polynomial().unwrap();
            let eligible = (0..8)
                .filter(|&coordinate| coordinate != target)
                .collect::<Vec<_>>();
            let mut expected = vec![0u32; eligible.len() + 1];
            for mask in 0u16..1u16 << eligible.len() {
                let available = eligible
                    .iter()
                    .enumerate()
                    .filter(|&(index, _)| mask & (1 << index) != 0)
                    .map(|(_, &coordinate)| coordinate as u8)
                    .collect::<Vec<_>>();
                if explicit.supports.iter().any(|support| {
                    support
                        .iter()
                        .all(|coordinate| available.contains(coordinate))
                }) {
                    expected[mask.count_ones() as usize] += 1;
                }
            }
            assert_eq!(
                &*reliability.success_counts_by_available,
                expected.into_iter().map(BigUint::from).collect::<Vec<_>>()
            );

            let resource_map = [0u8, 1, 2, 0, 1, 2, 0, 1];
            let mut expected_loads = explicit
                .supports
                .iter()
                .map(|support| {
                    let mut loads = [0u32; 3];
                    for &coordinate in support.iter() {
                        loads[resource_map[coordinate as usize] as usize] += 1;
                    }
                    loads
                })
                .collect::<Vec<_>>();
            expected_loads.sort_unstable();
            expected_loads.dedup();
            let all_loads = expected_loads.clone();
            expected_loads.retain(|right| {
                !all_loads
                    .iter()
                    .any(|left| left != right && left.iter().zip(right.iter()).all(|(a, b)| a <= b))
            });
            let aggregated = family
                .aggregate_for_scheduler(&resource_map, &[8, 8, 8], 1, 1 << 20)
                .unwrap();
            assert_eq!(
                aggregated
                    .options
                    .iter()
                    .map(|option| option.loads.as_ref())
                    .collect::<Vec<_>>(),
                expected_loads
                    .iter()
                    .map(<[u32; 3]>::as_slice)
                    .collect::<Vec<_>>()
            );
            for option in &aggregated.options {
                assert!(explicit.supports.contains(&option.representative_support));
                let mut loads = [0u32; 3];
                for &coordinate in option.representative_support.iter() {
                    loads[resource_map[coordinate as usize] as usize] += 1;
                }
                assert_eq!(loads.as_slice(), option.loads.as_ref());
            }
        }
    }

    #[test]
    fn aggregate_frontier_compresses_exponential_fanout_for_scheduling() {
        let levels = 12;
        let common = levels;
        let mut layers = Vec::with_capacity(2 * levels);
        for level in 0..levels {
            let previous = if level == 0 { common } else { level - 1 };
            for branch in 0..2 {
                layers.push(CephXorLayer {
                    parity: level as u8,
                    data: Box::new([previous as u8, (levels + 1 + 2 * level + branch) as u8]),
                });
            }
        }
        let coordinate_count = 3 * levels + 1;
        let mut resources = vec![0u8; coordinate_count];
        resources[common] = 2;
        for level in 0..levels {
            resources[levels + 1 + 2 * level] = 0;
            resources[levels + 2 + 2 * level] = 1;
        }
        let family = ceph_xor_repair_family(
            coordinate_count,
            &layers,
            levels - 1,
            &(0..levels).collect::<Vec<_>>(),
            1 << 20,
        )
        .unwrap();
        assert_eq!(family.summary().unwrap().support_count, 1 << levels);
        let aggregated = family
            .aggregate_for_scheduler(&resources, &[levels as u32, levels as u32, 2], 2, 1 << 20)
            .unwrap();
        assert_eq!(aggregated.options.len(), levels + 1);
        assert!(aggregated.options.iter().all(|option| {
            option.loads.iter().sum::<u32>() == levels as u32 + 1
                && option.loads[2] == 1
                && option.representative_support.len() == levels + 1
        }));
        let answer = aggregated.problem.solve_adaptive().unwrap();
        assert_eq!(answer.repaired_count(), 2);
        assert_eq!(&*answer.total_loads, &[levels as u64, levels as u64, 2]);
        for choice in &answer.assignment {
            assert!(aggregated.representative_support(&choice.loads).is_some());
        }
    }

    #[test]
    fn azure_layout_scheduler_prefers_six_fragment_local_repairs() {
        let problem = azure_lrc_12_2_2_upgrade_domains(&[6, 6, 6, 6, 6, 6, 3, 0, 0], 3).unwrap();
        let answer = problem.solve_adaptive().unwrap();
        assert_eq!(answer.repaired_count(), 3);
        assert!(answer
            .assignment
            .iter()
            .all(|choice| choice.loads.iter().sum::<u32>() == 6));
    }

    #[test]
    fn azure_counted_compiler_matches_enumerated_scheduler() {
        let mut state = 0x4d59_5df4_d0f3_3173u64;
        for _ in 0..1_000 {
            state = state
                .wrapping_mul(6_364_136_223_846_793_005)
                .wrapping_add(1);
            let demand_count = ((state >> 32) % 9) as usize;
            let mut capacities = [0u32; 9];
            for capacity in &mut capacities {
                state = state
                    .wrapping_mul(6_364_136_223_846_793_005)
                    .wrapping_add(1);
                *capacity = ((state >> 32) % 7) as u32;
            }
            let counted = azure_lrc_12_2_2_counted(&capacities, demand_count);
            let enumerated = azure_lrc_12_2_2_upgrade_domains(&capacities, demand_count)
                .unwrap()
                .solve_adaptive()
                .unwrap();
            assert_eq!(counted.repaired_count as usize, enumerated.repaired_count());
            assert!(counted
                .total_loads
                .iter()
                .zip(capacities)
                .all(|(&load, capacity)| load <= u64::from(capacity)));
            assert_eq!(
                counted.mode_counts.iter().flatten().sum::<u64>(),
                counted.repaired_count
            );
        }
    }

    #[test]
    fn repair_dag_scheduler_respects_precedence_and_full_duplex_capacity() {
        let tasks = [
            RepairTask {
                predecessors: 0,
                loads: vec![1, 0].into_boxed_slice(),
            },
            RepairTask {
                predecessors: 0,
                loads: vec![0, 1].into_boxed_slice(),
            },
            RepairTask {
                predecessors: 0b11,
                loads: vec![1, 1].into_boxed_slice(),
            },
        ];
        let answer = schedule_repair_dag(&[1, 1], &tasks, 100).unwrap();
        assert_eq!(answer.slots, 2);
        assert_eq!(&*answer.task_batches[0], &[0, 1]);
        assert_eq!(&*answer.task_batches[1], &[2]);
    }

    #[test]
    fn gpu_checkpoint_recovery_accounts_for_rack_crossings() {
        let problem = gpu_checkpoint_mds_recovery(
            2,
            &[0, 1, 2, 3],
            &[0, 0, 1, 1],
            &[0],
            &[0],
            &[2, 2, 2, 2, 2, 1],
            10,
        )
        .unwrap();
        let answer = problem.solve_adaptive().unwrap();
        assert_eq!(answer.repaired_count(), 1);
        assert_eq!(answer.total_loads.last(), Some(&1));
    }

    #[test]
    fn gpu_checkpoint_batch_returns_capacity_checked_helper_witnesses() {
        let answer = gpu_checkpoint_mds_same_rack_recovery(
            2,
            &[0, 1, 2, 3],
            &[0, 0, 1, 1],
            &[0],
            &[0],
            GpuCheckpointCapacities {
                nodes: &[1, 1, 1, 1],
                same_rack: 1,
                cross_rack: 1,
            },
        )
        .unwrap()
        .unwrap();
        assert_eq!(answer.failure_count, 1);
        assert_eq!(answer.data_shards, 2);
        assert_ne!(answer.helper_shard(0, 0), answer.helper_shard(0, 1));
        assert_eq!(answer.same_rack_load, 1);
        assert_eq!(answer.cross_rack_load, 1);
        assert!(answer
            .node_loads
            .iter()
            .zip([1, 1, 1, 1])
            .all(|(&load, capacity)| load <= capacity));
    }

    #[test]
    fn gpu_checkpoint_batch_proves_a_cross_rack_bottleneck_infeasible() {
        assert!(gpu_checkpoint_mds_same_rack_recovery(
            2,
            &[0, 1, 2, 3],
            &[0, 0, 1, 1],
            &[0],
            &[0],
            GpuCheckpointCapacities {
                nodes: &[1, 1, 1, 1],
                same_rack: 2,
                cross_rack: 0,
            },
        )
        .unwrap()
        .is_none());
    }

    #[test]
    fn gpu_checkpoint_batch_compiler_matches_helper_family_enumeration() {
        let shard_nodes = [0, 1, 2, 3, 4];
        let node_racks = [0, 0, 0, 1, 1];
        let failed = [0, 1];
        let replacements = [0, 0];
        for mask in 0u32..32 {
            let nodes: Vec<_> = (0..5)
                .map(|node| if mask & (1 << node) == 0 { 0 } else { 2 })
                .collect();
            for same_rack in 0..=4 {
                for cross_rack in 0..=4 {
                    let compiled = gpu_checkpoint_mds_same_rack_recovery(
                        2,
                        &shard_nodes,
                        &node_racks,
                        &failed,
                        &replacements,
                        GpuCheckpointCapacities {
                            nodes: &nodes,
                            same_rack,
                            cross_rack,
                        },
                    )
                    .unwrap();
                    let mut all_capacities = nodes.clone();
                    all_capacities.extend([same_rack, cross_rack]);
                    let enumerated = gpu_checkpoint_mds_recovery(
                        2,
                        &shard_nodes,
                        &node_racks,
                        &failed,
                        &replacements,
                        &all_capacities,
                        100,
                    )
                    .unwrap()
                    .solve_adaptive()
                    .unwrap();
                    assert_eq!(compiled.is_some(), enumerated.repaired_count() == 2);
                }
            }
        }
    }

    #[test]
    fn qc_normalized_search_finds_a_lifted_cycle_codeword() {
        let code = QcLdpcCode::new(2, 2, 2, vec![Some(0), Some(0), Some(0), Some(1)]).unwrap();
        let answer = code.find_trapping_set(4, 0, 10_000).unwrap().unwrap();
        assert_eq!(answer.odd_checks, 0);
        assert_eq!(answer.variables.len(), 4);
        assert_eq!(answer.cyclic_normalization_factor, 2);
    }

    #[test]
    fn stopping_search_does_not_confuse_odd_degree_with_degree_one() {
        let code = QcLdpcCode::new(
            4,
            3,
            1,
            vec![
                Some(0),
                Some(0),
                Some(0),
                Some(0),
                Some(0),
                None,
                Some(0),
                None,
                Some(0),
                None,
                Some(0),
                Some(0),
            ],
        )
        .unwrap();
        assert!(code.find_trapping_set(3, 0, 100).unwrap().is_none());
        let stopping = code.find_stopping_set(3, 100).unwrap().unwrap();
        assert_eq!(&*stopping.variables, &[0, 1, 2]);
        assert_eq!(stopping.odd_checks, 1);
    }

    #[test]
    fn degree_two_component_shortcut_matches_exhaustive_qc_codewords() {
        let lift = 3;
        let choices = [None, Some(0), Some(1), Some(2)];
        for mut packed in 0usize..4usize.pow(4) {
            let mut shifts = Vec::with_capacity(4);
            for _ in 0..4 {
                shifts.push(choices[packed & 3]);
                packed >>= 2;
            }
            let code = QcLdpcCode::new(2, 2, lift, shifts).unwrap();
            for size in 1..=2 * lift {
                let expected = (1usize..1usize << (2 * lift)).any(|mask| {
                    if mask.count_ones() as usize != size {
                        return false;
                    }
                    let mut degrees = vec![0u16; 2 * lift];
                    for variable in 0..2 * lift {
                        if mask & (1usize << variable) != 0 {
                            code.update_degrees(variable, &mut degrees, true);
                        }
                    }
                    degrees.iter().all(|degree| degree & 1 == 0)
                });
                assert_eq!(
                    code.search_trapping_set(size, 0, 10_000)
                        .unwrap()
                        .answer
                        .is_some(),
                    expected
                );
            }
        }
    }

    fn exhaustive_qc_exists(
        code: &QcLdpcCode,
        size: usize,
        maximum_odd_checks: usize,
        stopping: bool,
    ) -> bool {
        let variable_count = usize::from(code.variable_groups) * usize::from(code.lift);
        let check_count = usize::from(code.check_groups) * usize::from(code.lift);
        (1_usize..1_usize << variable_count).any(|mask| {
            if mask.count_ones() as usize != size {
                return false;
            }
            let mut degrees = vec![0_u16; check_count];
            for variable in 0..variable_count {
                if mask & (1 << variable) != 0 {
                    code.update_degrees(variable, &mut degrees, true);
                }
            }
            if stopping {
                degrees.iter().all(|&degree| degree != 1)
            } else {
                degrees.iter().filter(|&&degree| degree & 1 != 0).count() <= maximum_odd_checks
            }
        })
    }

    #[test]
    fn iterative_qc_search_matches_exhaustive_small_codes() {
        let choices = [None, Some(0), Some(1)];
        for mut packed in (0_usize..3_usize.pow(6)).step_by(17) {
            let mut shifts = Vec::with_capacity(6);
            for _ in 0..6 {
                shifts.push(choices[packed % 3]);
                packed /= 3;
            }
            let code = QcLdpcCode::new(2, 3, 2, shifts).unwrap();
            for size in 1..=4 {
                for maximum_odd_checks in 0..=2 {
                    let expected = exhaustive_qc_exists(&code, size, maximum_odd_checks, false);
                    let actual = code
                        .search_trapping_set(size, maximum_odd_checks, 1_000_000)
                        .unwrap();
                    assert_eq!(actual.answer.is_some(), expected);
                }
                let expected_stopping =
                    (1..=size).any(|weight| exhaustive_qc_exists(&code, weight, 0, true));
                assert_eq!(
                    code.find_stopping_set(size, 1_000_000).unwrap().is_some(),
                    expected_stopping
                );
            }
        }
    }

    #[test]
    fn iterative_qc_search_preserves_budget_boundary() {
        let code = QcLdpcCode::new(1, 1, 2, vec![Some(0)]).unwrap();
        assert_eq!(
            code.search_trapping_set(1, 1, 0),
            Err(ApplicationError::Budget { budget: 0 })
        );
    }

    #[test]
    fn iterative_qc_search_loop_allocates_nothing() {
        let code = QcLdpcCode::new(
            2,
            5,
            3,
            vec![
                Some(0),
                Some(1),
                Some(2),
                None,
                Some(0),
                Some(2),
                Some(0),
                None,
                Some(1),
                Some(2),
            ],
        )
        .unwrap();
        let (result, events) =
            crate::test_alloc::measure_allocations(|| code.search_trapping_set(4, 2, 1_000_000));
        result.unwrap();
        assert_eq!(events, Default::default());
    }

    #[test]
    fn vector_repair_charges_all_subsymbols_from_one_node_once() {
        let generator =
            Matrix::new::<2>(3, 5, vec![1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1]).unwrap();
        let target = Matrix::new::<2>(3, 2, vec![1, 0, 0, 1, 0, 0]).unwrap();
        let answer =
            minimum_node_span_repair::<Prime<2>>(&generator, &[0, 0, 1, 2, 2], &target, 1_000)
                .unwrap()
                .unwrap();
        assert_eq!(answer.node_cost, 1);
        assert_eq!(&*answer.nodes, &[0]);
    }
}
