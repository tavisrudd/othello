use serde::Deserialize;
use std::fs::File;
use std::io::{self, BufReader, BufWriter, Read, Write};
use std::path::Path;
use std::time::Instant;

#[cfg(test)]
use std::alloc::{GlobalAlloc, Layout, System};
#[cfg(test)]
use std::cell::Cell;

#[cfg(test)]
struct CountingAllocator;

#[cfg(test)]
thread_local! {
    static COUNT_ALLOCATIONS: Cell<bool> = const { Cell::new(false) };
    static ALLOCATION_EVENTS: Cell<usize> = const { Cell::new(0) };
}

#[cfg(test)]
fn count_allocation_event() {
    COUNT_ALLOCATIONS.with(|enabled| {
        if enabled.get() {
            ALLOCATION_EVENTS.with(|events| events.set(events.get() + 1));
        }
    });
}

#[cfg(test)]
unsafe impl GlobalAlloc for CountingAllocator {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        count_allocation_event();
        unsafe { System.alloc(layout) }
    }

    unsafe fn dealloc(&self, pointer: *mut u8, layout: Layout) {
        count_allocation_event();
        unsafe { System.dealloc(pointer, layout) }
    }

    unsafe fn realloc(&self, pointer: *mut u8, layout: Layout, size: usize) -> *mut u8 {
        count_allocation_event();
        unsafe { System.realloc(pointer, layout, size) }
    }
}

#[cfg(test)]
#[global_allocator]
static TEST_ALLOCATOR: CountingAllocator = CountingAllocator;

#[cfg(test)]
fn measured_allocations<T>(operation: impl FnOnce() -> T) -> (T, usize) {
    ALLOCATION_EVENTS.with(|events| events.set(0));
    COUNT_ALLOCATIONS.with(|enabled| enabled.set(true));
    let result = operation();
    COUNT_ALLOCATIONS.with(|enabled| enabled.set(false));
    let events = ALLOCATION_EVENTS.with(Cell::get);
    (result, events)
}

#[derive(Deserialize)]
struct Instance {
    coordinate_count: usize,
    physical_checks: Vec<Vec<usize>>,
    logical_observations: Vec<Vec<usize>>,
}

struct TannerGraph {
    bits: usize,
    checks: usize,
    row_offsets: Vec<usize>,
    edge_bits: Vec<usize>,
    edge_checks: Vec<usize>,
    col_offsets: Vec<usize>,
    col_edges: Vec<usize>,
}

impl TannerGraph {
    fn from_rows(bits: usize, rows: impl Iterator<Item = Vec<usize>>) -> Self {
        let rows: Vec<Vec<usize>> = rows.collect();
        let checks = rows.len();
        let edge_count: usize = rows.iter().map(Vec::len).sum();
        let mut row_offsets = Vec::with_capacity(checks + 1);
        let mut edge_bits = Vec::with_capacity(edge_count);
        let mut edge_checks = Vec::with_capacity(edge_count);
        let mut degrees = vec![0usize; bits];
        row_offsets.push(0);
        for (check, row) in rows.iter().enumerate() {
            for &bit in row {
                assert!(bit < bits, "column index out of range");
                edge_bits.push(bit);
                edge_checks.push(check);
                degrees[bit] += 1;
            }
            row_offsets.push(edge_bits.len());
        }

        let mut col_offsets = Vec::with_capacity(bits + 1);
        col_offsets.push(0);
        for degree in degrees {
            col_offsets.push(col_offsets.last().copied().unwrap() + degree);
        }
        let mut col_edges = vec![0usize; edge_count];
        let mut cursors = col_offsets[..bits].to_vec();
        for (edge, &bit) in edge_bits.iter().enumerate() {
            col_edges[cursors[bit]] = edge;
            cursors[bit] += 1;
        }
        Self {
            bits,
            checks,
            row_offsets,
            edge_bits,
            edge_checks,
            col_offsets,
            col_edges,
        }
    }
}

#[repr(C, align(64))]
struct MinSum {
    v2c: Vec<f64>,
    c2v: Vec<f64>,
    posterior: Vec<f64>,
    hard: Vec<u8>,
    observed: Vec<u8>,
}

#[repr(C, align(64))]
struct Osd0 {
    rows: Vec<u64>,
    template: Vec<u64>,
    order: Vec<usize>,
    pivot_columns: Vec<usize>,
    free_columns: Vec<usize>,
    pivot_mask: Vec<bool>,
    candidate: Vec<u8>,
    baseline: Vec<u8>,
    trial: Vec<u8>,
    words: usize,
}

impl Osd0 {
    fn new(graph: &TannerGraph) -> Self {
        let words = (graph.bits + 1).div_ceil(64);
        let mut template = vec![0u64; graph.checks * words];
        for edge in 0..graph.edge_bits.len() {
            let check = graph.edge_checks[edge];
            let bit = graph.edge_bits[edge];
            template[check * words + bit / 64] ^= 1u64 << (bit % 64);
        }
        Self {
            rows: template.clone(),
            template,
            order: (0..graph.bits).collect(),
            pivot_columns: vec![0; graph.checks],
            free_columns: Vec::with_capacity(graph.bits),
            pivot_mask: vec![false; graph.bits],
            candidate: vec![0; graph.bits],
            baseline: vec![0; graph.bits],
            trial: vec![0; graph.bits],
            words,
        }
    }

    fn solve(
        &mut self,
        graph: &TannerGraph,
        syndrome: &[u8],
        posterior: &[f64],
        provided_order: Option<&[u16]>,
        combination_sweep_order: Option<usize>,
        exhaustive_order: Option<usize>,
    ) -> bool {
        self.rows.copy_from_slice(&self.template);
        self.candidate.fill(0);
        for (check, &value) in syndrome.iter().enumerate() {
            self.rows[check * self.words + graph.bits / 64] |=
                u64::from(value) << (graph.bits % 64);
        }
        if let Some(order) = provided_order {
            assert_eq!(order.len(), graph.bits);
            for (destination, &source) in self.order.iter_mut().zip(order) {
                *destination = usize::from(source);
            }
        } else {
            self.order.sort_unstable_by(|&left, &right| {
                posterior[left]
                    .total_cmp(&posterior[right])
                    .then_with(|| left.cmp(&right))
            });
        }

        let mut rank = 0usize;
        for &column in &self.order {
            let word = column / 64;
            let mask = 1u64 << (column % 64);
            let Some(pivot) =
                (rank..graph.checks).find(|&row| self.rows[row * self.words + word] & mask != 0)
            else {
                continue;
            };
            if pivot != rank {
                let (left, right) = self.rows.split_at_mut(pivot * self.words);
                left[rank * self.words..(rank + 1) * self.words]
                    .swap_with_slice(&mut right[..self.words]);
            }
            for row in 0..graph.checks {
                if row == rank || self.rows[row * self.words + word] & mask == 0 {
                    continue;
                }
                for offset in 0..self.words {
                    self.rows[row * self.words + offset] ^= self.rows[rank * self.words + offset];
                }
            }
            self.pivot_columns[rank] = column;
            rank += 1;
            if rank == graph.checks {
                break;
            }
        }

        let rhs_word = graph.bits / 64;
        let rhs_mask = 1u64 << (graph.bits % 64);
        for row in rank..graph.checks {
            if self.rows[row * self.words + rhs_word] & rhs_mask != 0 {
                return false;
            }
        }
        for row in 0..rank {
            self.candidate[self.pivot_columns[row]] =
                u8::from(self.rows[row * self.words + rhs_word] & rhs_mask != 0);
        }
        if let Some(order) = combination_sweep_order {
            self.combination_sweep(rank, order);
        } else if let Some(order) = exhaustive_order {
            self.exhaustive(rank, order);
        }
        true
    }

    fn prepare_free_columns(&mut self, rank: usize) {
        self.baseline.copy_from_slice(&self.candidate);
        self.pivot_mask.fill(false);
        for &column in &self.pivot_columns[..rank] {
            self.pivot_mask[column] = true;
        }
        self.free_columns.clear();
        for &column in &self.order {
            if !self.pivot_mask[column] {
                self.free_columns.push(column);
            }
        }
    }

    fn combination_sweep(&mut self, rank: usize, order: usize) {
        self.prepare_free_columns(rank);

        let mut best_weight: usize = self.candidate.iter().map(|&value| usize::from(value)).sum();
        for free_index in 0..self.free_columns.len() {
            self.trial.copy_from_slice(&self.baseline);
            self.apply_free_delta(rank, free_index);
            let weight: usize = self.trial.iter().map(|&value| usize::from(value)).sum();
            if weight < best_weight {
                best_weight = weight;
                self.candidate.copy_from_slice(&self.trial);
            }
        }

        let pair_limit = order.min(self.free_columns.len());
        for left in 0..pair_limit {
            for right in (left + 1)..pair_limit {
                self.trial.copy_from_slice(&self.baseline);
                self.apply_free_delta(rank, left);
                self.apply_free_delta(rank, right);
                let weight: usize = self.trial.iter().map(|&value| usize::from(value)).sum();
                if weight < best_weight {
                    best_weight = weight;
                    self.candidate.copy_from_slice(&self.trial);
                }
            }
        }
    }

    fn exhaustive(&mut self, rank: usize, order: usize) {
        self.prepare_free_columns(rank);
        let order = order.min(self.free_columns.len());
        assert!(
            order <= 20,
            "private spike bounds exhaustive OSD at order 20"
        );
        let mut best_weight: usize = self.candidate.iter().map(|&value| usize::from(value)).sum();
        for mask in 1usize..(1usize << order) {
            self.trial.copy_from_slice(&self.baseline);
            let mut remaining = mask;
            while remaining != 0 {
                let bit = remaining.trailing_zeros() as usize;
                self.apply_free_delta(rank, bit);
                remaining &= remaining - 1;
            }
            let weight: usize = self.trial.iter().map(|&value| usize::from(value)).sum();
            if weight < best_weight {
                best_weight = weight;
                self.candidate.copy_from_slice(&self.trial);
            }
        }
    }

    fn apply_free_delta(&mut self, rank: usize, free_index: usize) {
        let column = self.free_columns[free_index];
        self.trial[column] ^= 1;
        let word = column / 64;
        let mask = 1u64 << (column % 64);
        for row in 0..rank {
            if self.rows[row * self.words + word] & mask != 0 {
                self.trial[self.pivot_columns[row]] ^= 1;
            }
        }
    }
}

impl MinSum {
    fn new(graph: &TannerGraph) -> Self {
        let edges = graph.edge_bits.len();
        Self {
            v2c: vec![0.0; edges],
            c2v: vec![0.0; edges],
            posterior: vec![0.0; graph.bits],
            hard: vec![0; graph.bits],
            observed: vec![0; graph.checks],
        }
    }

    fn decode(
        &mut self,
        graph: &TannerGraph,
        syndrome: &[u8],
        channel_llr: f64,
        scale: f64,
        max_iterations: usize,
    ) -> usize {
        self.v2c.fill(channel_llr);
        self.c2v.fill(0.0);
        self.hard.fill(0);

        for iteration in 1..=max_iterations {
            for (check, window) in graph.row_offsets.windows(2).enumerate() {
                let start = window[0];
                let end = window[1];
                let mut sign = syndrome[check] != 0;
                let mut minimum = f64::INFINITY;
                let mut second = f64::INFINITY;
                let mut minimum_edge = usize::MAX;
                for edge in start..end {
                    let message = self.v2c[edge];
                    sign ^= message <= 0.0;
                    let magnitude = message.abs();
                    if magnitude < minimum {
                        second = minimum;
                        minimum = magnitude;
                        minimum_edge = edge;
                    } else if magnitude < second {
                        second = magnitude;
                    }
                }
                for edge in start..end {
                    let magnitude = if edge == minimum_edge {
                        second
                    } else {
                        minimum
                    } * scale;
                    let negative = sign ^ (self.v2c[edge] <= 0.0);
                    self.c2v[edge] = if negative { -magnitude } else { magnitude };
                }
            }

            self.observed.fill(0);
            for bit in 0..graph.bits {
                let start = graph.col_offsets[bit];
                let end = graph.col_offsets[bit + 1];
                let mut llr = channel_llr;
                for slot in start..end {
                    let edge = graph.col_edges[slot];
                    self.v2c[edge] = llr;
                    llr += self.c2v[edge];
                }
                self.posterior[bit] = llr;
                self.hard[bit] = u8::from(llr <= 0.0);
                if llr <= 0.0 {
                    for slot in start..end {
                        let edge = graph.col_edges[slot];
                        self.observed[graph.edge_checks[edge]] ^= 1;
                    }
                }
                let mut suffix = 0.0;
                for slot in (start..end).rev() {
                    let edge = graph.col_edges[slot];
                    self.v2c[edge] += suffix;
                    suffix += self.c2v[edge];
                }
            }

            if self.observed == syndrome {
                return iteration;
            }
        }
        0
    }

    fn satisfies(&mut self, graph: &TannerGraph, syndrome: &[u8]) -> bool {
        self.observed.fill(0);
        for bit in 0..graph.bits {
            if self.hard[bit] == 0 {
                continue;
            }
            for slot in graph.col_offsets[bit]..graph.col_offsets[bit + 1] {
                let edge = graph.col_edges[slot];
                self.observed[graph.edge_checks[edge]] ^= 1;
            }
        }
        self.observed == syndrome
    }
}

struct TargetBatch {
    words: Vec<u64>,
    orders: Vec<u16>,
    bits: usize,
}

fn read_targets(path: &Path, limit: usize, retain_orders: bool) -> io::Result<TargetBatch> {
    let mut reader = BufReader::new(File::open(path)?);
    let mut header = [0u8; 16];
    reader.read_exact(&mut header)?;
    assert_eq!(&header[..8], b"EGBPORD1");
    let bits = usize::from(u16::from_le_bytes([header[8], header[9]]));
    let encoded = usize::try_from(u32::from_le_bytes(header[12..16].try_into().unwrap())).unwrap();
    let count = encoded.min(limit);
    let mut words = Vec::with_capacity(count);
    let mut orders = Vec::with_capacity(if retain_orders { count * bits } else { 0 });
    let mut target = [0u8; 8];
    let mut encoded_order = vec![0u8; bits * 2];
    for _ in 0..count {
        reader.read_exact(&mut target)?;
        words.push(u64::from_le_bytes(target));
        reader.read_exact(&mut encoded_order)?;
        if retain_orders {
            orders.extend(
                encoded_order
                    .chunks_exact(2)
                    .map(|pair| u16::from_le_bytes([pair[0], pair[1]])),
            );
        }
    }
    Ok(TargetBatch {
        words,
        orders,
        bits,
    })
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut args = std::env::args_os().skip(1);
    let input = args
        .next()
        .expect("usage: c985-native-bp INPUT TARGETS [TRIALS] [ITERATIONS]");
    let targets_path = args.next().expect("missing targets file");
    let trials = args
        .next()
        .map(|v| v.to_string_lossy().parse())
        .transpose()?
        .unwrap_or(2048);
    let iterations = args
        .next()
        .map(|v| v.to_string_lossy().parse())
        .transpose()?
        .unwrap_or(300);
    let mode = args.next().unwrap_or_default();
    let mode_text = mode.to_string_lossy();
    let dump_posterior = args.next();
    let combination_sweep_order = mode_text
        .strip_prefix("osdcs")
        .map(str::parse::<usize>)
        .transpose()?;
    let exhaustive_order = mode_text
        .strip_prefix("osde")
        .map(str::parse::<usize>)
        .transpose()?;
    let run_osd0 = mode_text == "osd0"
        || mode_text == "osd0-provided"
        || combination_sweep_order.is_some()
        || exhaustive_order.is_some();
    let provided_order = mode_text == "osd0-provided";
    let instance: Instance = serde_json::from_reader(BufReader::new(File::open(input)?))?;
    assert!(instance.logical_observations.len() <= 64);
    let physical_count = instance.physical_checks.len();
    let logical_count = instance.logical_observations.len();
    let graph = TannerGraph::from_rows(
        instance.coordinate_count,
        instance
            .physical_checks
            .into_iter()
            .chain(instance.logical_observations),
    );
    let targets = read_targets(Path::new(&targets_path), trials, provided_order)?;
    let mut syndrome = vec![0u8; graph.checks];
    let mut decoder = MinSum::new(&graph);
    let mut osd0 = Osd0::new(&graph);
    let channel_llr = ((1.0f64 - 0.002) / 0.002).ln();
    let start = Instant::now();
    let mut converged = 0usize;
    let mut iterations_total = 0usize;
    let mut best_weight = graph.bits + 1;
    let mut osd0_solved = 0usize;
    let mut osd0_best_weight = graph.bits + 1;
    let mut osd0_weight_sum = 0usize;
    let mut osd0_checksum = 0xcbf2_9ce4_8422_2325u64;
    for (trial, target) in targets.words.iter().copied().enumerate() {
        syndrome.fill(0);
        for bit in 0..logical_count {
            syndrome[physical_count + bit] = ((target >> bit) & 1) as u8;
        }
        let used = decoder.decode(&graph, &syndrome, channel_llr, 0.625, iterations);
        if used != 0 {
            assert!(decoder.satisfies(&graph, &syndrome));
            converged += 1;
            iterations_total += used;
            best_weight = best_weight.min(decoder.hard.iter().map(|&v| usize::from(v)).sum());
        }
        let order = provided_order
            .then(|| &targets.orders[trial * targets.bits..(trial + 1) * targets.bits]);
        if run_osd0
            && osd0.solve(
                &graph,
                &syndrome,
                &decoder.posterior,
                order,
                combination_sweep_order,
                exhaustive_order,
            )
        {
            decoder.hard.copy_from_slice(&osd0.candidate);
            assert!(decoder.satisfies(&graph, &syndrome));
            osd0_solved += 1;
            let weight = osd0.candidate.iter().map(|&value| usize::from(value)).sum();
            osd0_best_weight = osd0_best_weight.min(weight);
            osd0_weight_sum += weight;
            for &value in &osd0.candidate {
                osd0_checksum ^= u64::from(value);
                osd0_checksum = osd0_checksum.wrapping_mul(0x100_0000_01b3);
            }
            osd0_checksum ^= 0xff;
            osd0_checksum = osd0_checksum.wrapping_mul(0x100_0000_01b3);
        }
    }
    let elapsed = start.elapsed();
    if let Some(path) = dump_posterior {
        let mut output = BufWriter::new(File::create(path)?);
        for &value in &decoder.posterior {
            output.write_all(&value.to_le_bytes())?;
        }
        output.flush()?;
    }
    decoder.satisfies(&graph, &syndrome);
    let residual_weight = decoder
        .observed
        .iter()
        .zip(&syndrome)
        .filter(|(left, right)| left != right)
        .count();
    let hard_weight: usize = decoder.hard.iter().map(|&v| usize::from(v)).sum();
    let posterior_min = decoder
        .posterior
        .iter()
        .copied()
        .fold(f64::INFINITY, f64::min);
    let posterior_max = decoder
        .posterior
        .iter()
        .copied()
        .fold(f64::NEG_INFINITY, f64::max);
    let posterior_sum: f64 = decoder.posterior.iter().sum();
    println!(
        "{{\"schema\":\"c985-native-bp-spike-v1\",\"trials\":{},\"converged\":{},\"iterations_total\":{},\"best_weight\":{},\"osd0_solved\":{},\"osd0_best_weight\":{},\"osd0_weight_sum\":{},\"osd0_checksum\":{},\"elapsed_ns\":{},\"edges\":{},\"last_hard_weight\":{},\"last_residual_weight\":{},\"last_posterior_min\":{},\"last_posterior_max\":{},\"last_posterior_sum\":{}}}",
        targets.words.len(),
        converged,
        iterations_total,
        best_weight,
        osd0_solved,
        osd0_best_weight,
        osd0_weight_sum,
        osd0_checksum,
        elapsed.as_nanos(),
        graph.edge_bits.len(),
        hard_weight,
        residual_weight,
        posterior_min,
        posterior_max,
        posterior_sum
    );
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn decodes_single_parity_check_without_allocation_after_setup() {
        let graph = TannerGraph::from_rows(3, [vec![0, 1], vec![1, 2]].into_iter());
        let mut decoder = MinSum::new(&graph);
        let used = decoder.decode(&graph, &[1, 0], 2.0, 0.625, 8);
        assert!(used > 0);
        assert!(decoder.satisfies(&graph, &[1, 0]));
        assert_eq!(decoder.hard.iter().copied().sum::<u8>(), 1);
    }

    #[test]
    fn osd0_returns_an_exact_affine_solution() {
        let graph = TannerGraph::from_rows(3, [vec![0, 1], vec![1, 2]].into_iter());
        let mut osd = Osd0::new(&graph);
        assert!(osd.solve(&graph, &[1, 0], &[-1.0, 2.0, 3.0], None, None, None));
        let mut decoder = MinSum::new(&graph);
        decoder.hard.copy_from_slice(&osd.candidate);
        assert!(decoder.satisfies(&graph, &[1, 0]));
    }

    #[test]
    fn bp_and_higher_order_osd_regions_allocate_nothing() {
        let graph = TannerGraph::from_rows(4, [vec![0, 1, 3], vec![1, 2]].into_iter());
        let mut decoder = MinSum::new(&graph);
        let mut osd = Osd0::new(&graph);
        let (solved, bp_events) =
            measured_allocations(|| decoder.decode(&graph, &[1, 0], 2.0, 0.625, 8));
        let (_, osd_events) = measured_allocations(|| {
            osd.solve(&graph, &[1, 0], &decoder.posterior, None, Some(2), None)
        });
        assert_eq!(bp_events, 0, "BP event count after result {solved}");
        assert_eq!(osd_events, 0);
    }
}
