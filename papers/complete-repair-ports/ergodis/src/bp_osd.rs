//! Sparse binary normalized-min-sum BP with bounded OSD post-processing.
//!
//! This module produces candidate vectors and certified syndrome upper bounds.
//! `syndrome_satisfied` means only `H * candidate = syndrome` over GF(2); it
//! does not assert minimum weight, distance optimality, necessity, or proof
//! authority.
//!
//! The normalized-min-sum and OSD candidate families follow the BP+OSD
//! architecture described by Roffe et al. (arXiv:2005.07016). Behavioral
//! compatibility was checked against the MIT-licensed
//! `quantumgizmos/ldpc` implementation; this module is a Rust reimplementation.

use std::fmt;

#[inline(always)]
fn ordered_min(left: f64, right: f64) -> f64 {
    #[cfg(target_arch = "x86_64")]
    {
        use std::arch::x86_64::{_mm_cvtsd_f64, _mm_min_sd, _mm_set_sd};
        // SAFETY: SSE2 is mandatory on x86-64. Admitted BP messages are finite
        // ordered numbers, so MINSD has the required minimum semantics.
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
    fn from_rows(bits: usize, rows: Vec<Vec<usize>>) -> Self {
        let checks = rows.len();
        let edge_count: usize = rows.iter().map(Vec::len).sum();
        let mut row_offsets = Vec::with_capacity(checks + 1);
        let mut edge_bits = Vec::with_capacity(edge_count);
        let mut edge_checks = Vec::with_capacity(edge_count);
        let mut degrees = vec![0usize; bits];
        row_offsets.push(0);
        for (check, row) in rows.iter().enumerate() {
            for &bit in row {
                edge_bits.push(bit);
                edge_checks.push(check);
                degrees[bit] += 1;
            }
            row_offsets.push(edge_bits.len());
        }

        let mut col_offsets = Vec::with_capacity(bits + 1);
        col_offsets.push(0);
        for degree in degrees {
            col_offsets.push(col_offsets.last().copied().unwrap_or(0) + degree);
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

/// A validated immutable sparse binary parity-check matrix.
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
            graph: TannerGraph::from_rows(bits, rows),
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

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum MatrixError {
    ZeroBits,
    ColumnOutOfRange { row: usize, column: usize },
    DuplicateColumn { row: usize, column: usize },
}

impl fmt::Display for MatrixError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(formatter, "{self:?}")
    }
}

impl std::error::Error for MatrixError {}

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
    // SAFETY: BinaryValue is repr(u8), and every element is a valid variant.
    unsafe { std::slice::from_raw_parts(values.as_ptr().cast(), values.len()) }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct BpOsdConfig {
    pub error_rate: f64,
    pub maximum_iterations: usize,
    pub min_sum_scale: f64,
}

impl Default for BpOsdConfig {
    fn default() -> Self {
        Self {
            error_rate: 0.002,
            maximum_iterations: 300,
            min_sum_scale: 0.625,
        }
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum OsdMethod {
    Disabled,
    Zero,
    CombinationSweep { order: usize },
    Exhaustive { order: usize },
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub enum BpOsdError {
    SyndromeLength { expected: usize, actual: usize },
    SyndromeValue { check: usize, value: u8 },
    InvalidErrorRate(f64),
    InvalidScale(f64),
    ExhaustiveOrderTooLarge(usize),
}

impl fmt::Display for BpOsdError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(formatter, "{self:?}")
    }
}

impl std::error::Error for BpOsdError {}

pub struct BpOsdResult<'workspace> {
    pub candidate: &'workspace [u8],
    pub posterior: &'workspace [f64],
    pub bp_iterations: usize,
    pub syndrome_satisfied: bool,
    pub weight: usize,
}

#[repr(C, align(64))]
struct MinSumWorkspace {
    v2c: Vec<f64>,
    c2v: Vec<f64>,
    posterior: Vec<f64>,
    hard: Vec<u8>,
    observed_words: Vec<u64>,
    syndrome_words: Vec<u64>,
}

impl MinSumWorkspace {
    fn new(graph: &TannerGraph) -> Self {
        let edges = graph.edge_bits.len();
        Self {
            v2c: vec![0.0; edges],
            c2v: vec![0.0; edges],
            posterior: vec![0.0; graph.bits],
            hard: vec![0; graph.bits],
            observed_words: vec![0; graph.checks.div_ceil(64)],
            syndrome_words: vec![0; graph.checks.div_ceil(64)],
        }
    }

    #[inline(always)]
    fn decode(
        &mut self,
        graph: &TannerGraph,
        syndrome: &[u8],
        channel_llr: f64,
        scale: f64,
        maximum_iterations: usize,
    ) -> usize {
        self.syndrome_words.fill(0);
        for (check, &value) in syndrome.iter().enumerate() {
            self.syndrome_words[check / 64] |= u64::from(value) << (check % 64);
        }
        self.v2c.fill(channel_llr);
        self.c2v.fill(0.0);
        self.hard.fill(0);
        for iteration in 1..=maximum_iterations {
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

            self.observed_words.fill(0);
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
                        let check = graph.edge_checks[edge];
                        self.observed_words[check / 64] ^= 1 << (check % 64);
                    }
                }
                let mut suffix = 0.0;
                for slot in (start..end).rev() {
                    let edge = graph.col_edges[slot];
                    self.v2c[edge] += suffix;
                    suffix += self.c2v[edge];
                }
            }
            if self.observed_words == self.syndrome_words {
                return iteration;
            }
        }
        0
    }

    #[inline(always)]
    fn satisfies(&mut self, graph: &TannerGraph) -> bool {
        self.observed_words.fill(0);
        for bit in 0..graph.bits {
            if self.hard[bit] == 0 {
                continue;
            }
            for slot in graph.col_offsets[bit]..graph.col_offsets[bit + 1] {
                let edge = graph.col_edges[slot];
                let check = graph.edge_checks[edge];
                self.observed_words[check / 64] ^= 1 << (check % 64);
            }
        }
        self.observed_words == self.syndrome_words
    }
}

#[repr(C, align(64))]
struct OsdWorkspace {
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

impl OsdWorkspace {
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
        combination_sweep_order: Option<usize>,
        exhaustive_order: Option<usize>,
    ) -> bool {
        self.rows.copy_from_slice(&self.template);
        self.candidate.fill(0);
        for (check, &value) in syndrome.iter().enumerate() {
            self.rows[check * self.words + graph.bits / 64] |=
                u64::from(value) << (graph.bits % 64);
        }
        self.order.sort_unstable_by(|&left, &right| {
            posterior[left]
                .total_cmp(&posterior[right])
                .then_with(|| left.cmp(&right))
        });

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

/// Worker-owned BP/OSD state for one immutable compiled matrix.
#[repr(C, align(64))]
pub struct BpOsdWorkspace {
    bp: MinSumWorkspace,
    osd: OsdWorkspace,
    channel_llr: f64,
    maximum_iterations: usize,
    min_sum_scale: f64,
    run_osd: bool,
    combination_sweep: Option<usize>,
    exhaustive: Option<usize>,
}

impl BpOsdWorkspace {
    pub fn new(
        code: &BinaryParityCheck,
        config: BpOsdConfig,
        method: OsdMethod,
    ) -> Result<Self, BpOsdError> {
        if !(0.0 < config.error_rate && config.error_rate < 0.5) {
            return Err(BpOsdError::InvalidErrorRate(config.error_rate));
        }
        if !(config.min_sum_scale.is_finite()
            && config.min_sum_scale > 0.0
            && config.min_sum_scale <= 1.0)
        {
            return Err(BpOsdError::InvalidScale(config.min_sum_scale));
        }
        if let OsdMethod::Exhaustive { order } = method {
            if order > 20 {
                return Err(BpOsdError::ExhaustiveOrderTooLarge(order));
            }
        }
        let (run_osd, combination_sweep, exhaustive) = match method {
            OsdMethod::Disabled => (false, None, None),
            OsdMethod::Zero => (true, None, None),
            OsdMethod::CombinationSweep { order } => (true, Some(order), None),
            OsdMethod::Exhaustive { order } => (true, None, Some(order)),
        };
        Ok(Self {
            bp: MinSumWorkspace::new(&code.graph),
            osd: OsdWorkspace::new(&code.graph),
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

    #[inline(always)]
    pub fn decode(
        &mut self,
        code: &BinaryParityCheck,
        syndrome: &[BinaryValue],
    ) -> Result<BpOsdResult<'_>, BpOsdError> {
        self.decode_bytes_inner(code, binary_values_as_bytes(syndrome))
    }

    pub fn decode_bytes(
        &mut self,
        code: &BinaryParityCheck,
        syndrome: &[u8],
    ) -> Result<BpOsdResult<'_>, BpOsdError> {
        if let Some((check, &value)) = syndrome.iter().enumerate().find(|(_, value)| **value > 1) {
            return Err(BpOsdError::SyndromeValue { check, value });
        }
        self.decode_bytes_inner(code, syndrome)
    }

    #[inline(always)]
    fn decode_bytes_inner(
        &mut self,
        code: &BinaryParityCheck,
        syndrome: &[u8],
    ) -> Result<BpOsdResult<'_>, BpOsdError> {
        if syndrome.len() != code.graph.checks {
            return Err(BpOsdError::SyndromeLength {
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
                self.combination_sweep,
                self.exhaustive,
            )
        {
            self.bp.hard.copy_from_slice(&self.osd.candidate);
        }
        let syndrome_satisfied = self.bp.satisfies(&code.graph);
        let weight = self.bp.hard.iter().map(|&value| usize::from(value)).sum();
        Ok(BpOsdResult {
            candidate: &self.bp.hard,
            posterior: &self.bp.posterior,
            bp_iterations,
            syndrome_satisfied,
            weight,
        })
    }
}
