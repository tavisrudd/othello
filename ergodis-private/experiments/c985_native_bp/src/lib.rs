use serde::Deserialize;
use std::fs::File;
use std::io::{self, BufReader, BufWriter, Read, Write};
use std::path::Path;
use std::time::Instant;

#[inline(always)]
fn ordered_min(left: f64, right: f64) -> f64 {
    #[cfg(target_arch = "x86_64")]
    {
        use std::arch::x86_64::{_mm_cvtsd_f64, _mm_min_sd, _mm_set_sd};
        // SAFETY: SSE2 is mandatory on x86-64. BP messages in the admitted
        // finite-message envelope are ordered numbers, so MINSD matches min.
        unsafe { _mm_cvtsd_f64(_mm_min_sd(_mm_set_sd(left), _mm_set_sd(right))) }
    }
    #[cfg(not(target_arch = "x86_64"))]
    {
        left.min(right)
    }
}

#[inline(always)]
fn ordered_max(left: f64, right: f64) -> f64 {
    #[cfg(target_arch = "x86_64")]
    {
        use std::arch::x86_64::{_mm_cvtsd_f64, _mm_max_sd, _mm_set_sd};
        // SAFETY: SSE2 is mandatory on x86-64; see ordered_min.
        unsafe { _mm_cvtsd_f64(_mm_max_sd(_mm_set_sd(left), _mm_set_sd(right))) }
    }
    #[cfg(not(target_arch = "x86_64"))]
    {
        left.max(right)
    }
}

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

    #[inline(always)]
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
                let mut minimum = f64::MAX;
                let mut second = f64::MAX;
                for edge in start..end {
                    let message = self.v2c[edge];
                    sign ^= message <= 0.0;
                    let magnitude = message.abs();
                    let lower = ordered_min(minimum, magnitude);
                    let upper = ordered_max(minimum, magnitude);
                    minimum = lower;
                    second = ordered_min(second, upper);
                }
                for edge in start..end {
                    let magnitude = if self.v2c[edge].abs() == minimum {
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

    #[inline(always)]
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

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum MatrixError {
    ZeroBits,
    ColumnOutOfRange { row: usize, column: usize },
    DuplicateColumn { row: usize, column: usize },
}

impl std::fmt::Display for MatrixError {
    fn fmt(&self, formatter: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(formatter, "{self:?}")
    }
}

impl std::error::Error for MatrixError {}

pub struct BinaryParityCheck {
    graph: TannerGraph,
}

impl BinaryParityCheck {
    pub fn from_rows(
        bits: usize,
        rows: impl IntoIterator<Item = Vec<usize>>,
    ) -> Result<Self, MatrixError> {
        if bits == 0 {
            return Err(MatrixError::ZeroBits);
        }
        let rows: Vec<Vec<usize>> = rows.into_iter().collect();
        let mut seen = vec![0usize; bits];
        for (row, support) in rows.iter().enumerate() {
            let epoch = row + 1;
            for &column in support {
                if column >= bits {
                    return Err(MatrixError::ColumnOutOfRange { row, column });
                }
                if seen[column] == epoch {
                    return Err(MatrixError::DuplicateColumn { row, column });
                }
                seen[column] = epoch;
            }
        }
        Ok(Self {
            graph: TannerGraph::from_rows(bits, rows.into_iter()),
        })
    }

    pub fn bit_count(&self) -> usize {
        self.graph.bits
    }

    pub fn check_count(&self) -> usize {
        self.graph.checks
    }

    pub fn edge_count(&self) -> usize {
        self.graph.edge_bits.len()
    }
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct DecodeConfig {
    pub error_rate: f64,
    pub maximum_iterations: usize,
    pub min_sum_scale: f64,
}

#[repr(u8)]
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub enum BinaryValue {
    #[default]
    Zero = 0,
    One = 1,
}

impl From<bool> for BinaryValue {
    fn from(value: bool) -> Self {
        if value {
            Self::One
        } else {
            Self::Zero
        }
    }
}

fn binary_values_as_bytes(values: &[BinaryValue]) -> &[u8] {
    // SAFETY: BinaryValue is repr(u8), both variants have their stated byte value,
    // and every element in the input slice is a valid BinaryValue.
    unsafe { std::slice::from_raw_parts(values.as_ptr().cast(), values.len()) }
}

impl Default for DecodeConfig {
    fn default() -> Self {
        Self {
            error_rate: 0.002,
            maximum_iterations: 300,
            min_sum_scale: 0.625,
        }
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum OrderedStatistics {
    Disabled,
    Zero,
    CombinationSweep { order: usize },
    Exhaustive { order: usize },
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub enum DecodeError {
    SyndromeLength { expected: usize, actual: usize },
    SyndromeValue { check: usize, value: u8 },
    InvalidErrorRate(f64),
    InvalidScale(f64),
    ExhaustiveOrderTooLarge(usize),
}

impl std::fmt::Display for DecodeError {
    fn fmt(&self, formatter: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(formatter, "{self:?}")
    }
}

impl std::error::Error for DecodeError {}

pub struct DecodeView<'decoder> {
    pub candidate: &'decoder [u8],
    pub posterior: &'decoder [f64],
    pub bp_iterations: usize,
    pub syndrome_satisfied: bool,
    pub weight: usize,
}

#[repr(C, align(64))]
pub struct NativeBpOsd {
    bp: MinSum,
    osd: Osd0,
    channel_llr: f64,
    maximum_iterations: usize,
    min_sum_scale: f64,
    run_osd: bool,
    combination_sweep: Option<usize>,
    exhaustive: Option<usize>,
}

impl NativeBpOsd {
    pub fn new(
        code: &BinaryParityCheck,
        config: DecodeConfig,
        method: OrderedStatistics,
    ) -> Result<Self, DecodeError> {
        if !(0.0 < config.error_rate && config.error_rate < 0.5) {
            return Err(DecodeError::InvalidErrorRate(config.error_rate));
        }
        if !(config.min_sum_scale.is_finite()
            && config.min_sum_scale > 0.0
            && config.min_sum_scale <= 1.0)
        {
            return Err(DecodeError::InvalidScale(config.min_sum_scale));
        }
        if let OrderedStatistics::Exhaustive { order } = method {
            if order > 20 {
                return Err(DecodeError::ExhaustiveOrderTooLarge(order));
            }
        }
        let (run_osd, combination_sweep, exhaustive) = match method {
            OrderedStatistics::Disabled => (false, None, None),
            OrderedStatistics::Zero => (true, None, None),
            OrderedStatistics::CombinationSweep { order } => (true, Some(order), None),
            OrderedStatistics::Exhaustive { order } => (true, None, Some(order)),
        };
        let bp = MinSum::new(&code.graph);
        let osd = Osd0::new(&code.graph);
        Ok(Self {
            bp,
            osd,
            channel_llr: ((1.0 - config.error_rate) / config.error_rate).ln(),
            maximum_iterations: config.maximum_iterations,
            min_sum_scale: config.min_sum_scale,
            run_osd,
            combination_sweep,
            exhaustive,
        })
    }

    pub fn candidate(&self) -> &[u8] {
        &self.bp.hard
    }

    pub fn posterior(&self) -> &[f64] {
        &self.bp.posterior
    }

    pub fn residual_weight(
        &mut self,
        code: &BinaryParityCheck,
        syndrome: &[BinaryValue],
    ) -> Result<usize, DecodeError> {
        if syndrome.len() != code.graph.checks {
            return Err(DecodeError::SyndromeLength {
                expected: code.graph.checks,
                actual: syndrome.len(),
            });
        }
        let syndrome = binary_values_as_bytes(syndrome);
        self.bp.satisfies(&code.graph, syndrome);
        Ok(self
            .bp
            .observed
            .iter()
            .zip(syndrome)
            .filter(|(left, right)| left != right)
            .count())
    }

    #[inline(always)]
    pub fn decode(
        &mut self,
        code: &BinaryParityCheck,
        syndrome: &[BinaryValue],
    ) -> Result<DecodeView<'_>, DecodeError> {
        self.decode_with_order(code, binary_values_as_bytes(syndrome), None)
    }

    pub fn decode_bytes(
        &mut self,
        code: &BinaryParityCheck,
        syndrome: &[u8],
    ) -> Result<DecodeView<'_>, DecodeError> {
        if let Some((check, &value)) = syndrome.iter().enumerate().find(|(_, value)| **value > 1) {
            return Err(DecodeError::SyndromeValue { check, value });
        }
        self.decode_with_order(code, syndrome, None)
    }

    #[inline(always)]
    fn decode_with_order(
        &mut self,
        code: &BinaryParityCheck,
        syndrome: &[u8],
        provided_order: Option<&[u16]>,
    ) -> Result<DecodeView<'_>, DecodeError> {
        if syndrome.len() != code.graph.checks {
            return Err(DecodeError::SyndromeLength {
                expected: code.graph.checks,
                actual: syndrome.len(),
            });
        }
        let bp_iterations = self.bp.decode(
            &code.graph,
            syndrome,
            self.channel_llr,
            self.min_sum_scale,
            self.maximum_iterations,
        );
        if bp_iterations == 0
            && self.run_osd
            && self.osd.solve(
                &code.graph,
                syndrome,
                &self.bp.posterior,
                provided_order,
                self.combination_sweep,
                self.exhaustive,
            )
        {
            self.bp.hard.copy_from_slice(&self.osd.candidate);
        }
        let syndrome_satisfied = self.bp.satisfies(&code.graph, syndrome);
        let weight = self.bp.hard.iter().map(|&value| usize::from(value)).sum();
        Ok(DecodeView {
            candidate: &self.bp.hard,
            posterior: &self.bp.posterior,
            bp_iterations,
            syndrome_satisfied,
            weight,
        })
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

pub fn run_cli() -> Result<(), Box<dyn std::error::Error>> {
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
    let code = BinaryParityCheck::from_rows(
        instance.coordinate_count,
        instance
            .physical_checks
            .into_iter()
            .chain(instance.logical_observations),
    )
    .expect("validated sparse binary matrix");
    let targets = read_targets(Path::new(&targets_path), trials, provided_order)?;
    let config = DecodeConfig {
        maximum_iterations: iterations,
        ..DecodeConfig::default()
    };
    let method = if let Some(order) = combination_sweep_order {
        OrderedStatistics::CombinationSweep { order }
    } else if let Some(order) = exhaustive_order {
        OrderedStatistics::Exhaustive { order }
    } else if run_osd0 {
        OrderedStatistics::Zero
    } else {
        OrderedStatistics::Disabled
    };
    let bit_count = code.bit_count();
    let edge_count = code.edge_count();
    let mut syndrome = vec![BinaryValue::Zero; code.check_count()];
    let mut decoder = NativeBpOsd::new(&code, config, method).expect("validated decoder config");
    let start = Instant::now();
    let mut converged = 0usize;
    let mut iterations_total = 0usize;
    let mut best_weight = bit_count + 1;
    let mut osd0_solved = 0usize;
    let mut osd0_best_weight = bit_count + 1;
    let mut osd0_weight_sum = 0usize;
    let mut osd0_checksum = 0xcbf2_9ce4_8422_2325u64;
    for (trial, target) in targets.words.iter().copied().enumerate() {
        syndrome.fill(BinaryValue::Zero);
        for bit in 0..logical_count {
            syndrome[physical_count + bit] = BinaryValue::from((target >> bit) & 1 != 0);
        }
        let order = provided_order
            .then(|| &targets.orders[trial * targets.bits..(trial + 1) * targets.bits]);
        let view = decoder
            .decode_with_order(&code, binary_values_as_bytes(&syndrome), order)
            .expect("validated decoder request");
        if view.bp_iterations != 0 {
            assert!(view.syndrome_satisfied);
            converged += 1;
            iterations_total += view.bp_iterations;
            best_weight = best_weight.min(view.weight);
        }
        if run_osd0 && view.bp_iterations == 0 && view.syndrome_satisfied {
            osd0_solved += 1;
            osd0_best_weight = osd0_best_weight.min(view.weight);
            osd0_weight_sum += view.weight;
            for &value in view.candidate {
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
        for &value in decoder.posterior() {
            output.write_all(&value.to_le_bytes())?;
        }
        output.flush()?;
    }
    let residual_weight = decoder
        .residual_weight(&code, &syndrome)
        .expect("validated syndrome");
    let hard_weight: usize = decoder.candidate().iter().map(|&v| usize::from(v)).sum();
    let posterior_min = decoder
        .posterior()
        .iter()
        .copied()
        .fold(f64::INFINITY, f64::min);
    let posterior_max = decoder
        .posterior()
        .iter()
        .copied()
        .fold(f64::NEG_INFINITY, f64::max);
    let posterior_sum: f64 = decoder.posterior().iter().sum();
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
        edge_count,
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
        let rows = [vec![0, 1, 3], vec![1, 2]];
        let bp_code = BinaryParityCheck::from_rows(4, rows.clone()).unwrap();
        let osd_code = BinaryParityCheck::from_rows(4, rows).unwrap();
        let mut bp_decoder = NativeBpOsd::new(
            &bp_code,
            DecodeConfig {
                maximum_iterations: 8,
                ..DecodeConfig::default()
            },
            OrderedStatistics::Disabled,
        )
        .unwrap();
        let mut osd_decoder = NativeBpOsd::new(
            &osd_code,
            DecodeConfig {
                maximum_iterations: 0,
                ..DecodeConfig::default()
            },
            OrderedStatistics::CombinationSweep { order: 2 },
        )
        .unwrap();
        let syndrome = [BinaryValue::One, BinaryValue::Zero];
        let (_, bp_events) = measured_allocations(|| bp_decoder.decode(&bp_code, &syndrome));
        let (solved, osd_events) = measured_allocations(|| {
            osd_decoder
                .decode(&osd_code, &syndrome)
                .unwrap()
                .syndrome_satisfied
        });
        assert!(solved);
        assert_eq!(bp_events, 0);
        assert_eq!(osd_events, 0);
    }

    #[test]
    fn typed_matrix_boundary_rejects_malformed_rows() {
        assert_eq!(
            BinaryParityCheck::from_rows(3, [vec![0, 3]]).err().unwrap(),
            MatrixError::ColumnOutOfRange { row: 0, column: 3 }
        );
        assert_eq!(
            BinaryParityCheck::from_rows(3, [vec![1, 1]]).err().unwrap(),
            MatrixError::DuplicateColumn { row: 0, column: 1 }
        );
    }

    #[test]
    fn byte_boundary_rejects_nonbinary_syndrome() {
        let code = BinaryParityCheck::from_rows(3, [vec![0, 1], vec![1, 2]]).unwrap();
        let mut decoder =
            NativeBpOsd::new(&code, DecodeConfig::default(), OrderedStatistics::Zero).unwrap();
        assert_eq!(
            decoder.decode_bytes(&code, &[0, 2]).err().unwrap(),
            DecodeError::SyndromeValue { check: 1, value: 2 }
        );
    }

    #[test]
    fn degree_one_check_uses_finite_reference_message() {
        let code = BinaryParityCheck::from_rows(1, [vec![0]]).unwrap();
        let mut decoder = NativeBpOsd::new(
            &code,
            DecodeConfig {
                maximum_iterations: 1,
                ..DecodeConfig::default()
            },
            OrderedStatistics::Disabled,
        )
        .unwrap();
        let result = decoder.decode(&code, &[BinaryValue::One]).unwrap();
        assert!(result.syndrome_satisfied);
        assert_eq!(result.candidate, &[1]);
        assert!(result.posterior[0].is_finite());
    }

    #[test]
    fn immutable_code_supports_independent_worker_workspaces() {
        assert!(std::mem::align_of::<NativeBpOsd>() >= 64);
        let code = BinaryParityCheck::from_rows(4, [vec![0, 1, 3], vec![1, 2]]).unwrap();
        std::thread::scope(|scope| {
            let mut workers = Vec::with_capacity(4);
            for _ in 0..4 {
                workers.push(scope.spawn(|| {
                    let mut workspace = NativeBpOsd::new(
                        &code,
                        DecodeConfig {
                            maximum_iterations: 0,
                            ..DecodeConfig::default()
                        },
                        OrderedStatistics::Exhaustive { order: 2 },
                    )
                    .unwrap();
                    let result = workspace
                        .decode(&code, &[BinaryValue::One, BinaryValue::Zero])
                        .unwrap();
                    (
                        result.syndrome_satisfied,
                        result.weight,
                        result.candidate.to_vec(),
                    )
                }));
            }
            let expected = workers.remove(0).join().unwrap();
            for worker in workers {
                assert_eq!(worker.join().unwrap(), expected);
            }
        });
    }
}
