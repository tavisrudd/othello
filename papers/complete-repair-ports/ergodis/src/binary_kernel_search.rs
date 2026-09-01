//! Random information-set search for low-weight constrained binary-kernel words.
//!
//! Compilation accepts packed physical constraints and logical observations.
//! Each allocation-free trial chooses a random information set, constructs a
//! systematic kernel basis, and tests its rows plus optional order-two sums.

use thiserror::Error;

#[cfg(test)]
use crate::test_alloc::HotLoopAllocationGuard;

pub const MAX_BINARY_KERNEL_WORKSPACE_BYTES: usize = 1 << 30;

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum BinaryKernelSearchError {
    #[error("the binary-kernel dimensions or packed lengths are invalid")]
    InvalidDimensions,
    #[error("a packed row has set bits beyond the declared coordinate count")]
    NonCanonicalRow,
    #[error("the requested workspace exceeds the hard byte limit")]
    WorkspaceLimit,
    #[error("OSD order must be one or two and its window must be nonzero")]
    InvalidOptions,
    #[error("the workspace was compiled for a different problem")]
    WorkspaceMismatch,
    #[error("a support is empty, repeated, or outside the coordinate range")]
    InvalidSupport,
    #[error("a support violates a physical constraint")]
    PhysicalViolation,
    #[error("a support has zero logical observation")]
    TrivialSupport,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct BinaryKernelTrialOptions {
    pub target_weight: u16,
    pub osd_window: u16,
    pub osd_order: u8,
    pub _padding: [u8; 3],
}

const _: () = assert!(std::mem::size_of::<BinaryKernelTrialOptions>() == 8);
const _: () = assert!(std::mem::align_of::<BinaryKernelTrialOptions>() == 2);

impl BinaryKernelTrialOptions {
    pub fn new(
        target_weight: u16,
        osd_order: u8,
        osd_window: u16,
    ) -> Result<Self, BinaryKernelSearchError> {
        let options = Self {
            target_weight,
            osd_window,
            osd_order,
            _padding: [0; 3],
        };
        options.validate()?;
        Ok(options)
    }

    fn validate(self) -> Result<(), BinaryKernelSearchError> {
        if !(1..=2).contains(&self.osd_order) || self.osd_window == 0 || self._padding != [0; 3] {
            return Err(BinaryKernelSearchError::InvalidOptions);
        }
        Ok(())
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct BinaryKernelSearchSummary {
    pub completed_trials: u64,
    pub best_weight: u16,
    pub target_hit: u8,
    pub _padding: [u8; 5],
}

const _: () = assert!(std::mem::size_of::<BinaryKernelSearchSummary>() == 16);
const _: () = assert!(std::mem::align_of::<BinaryKernelSearchSummary>() == 8);

impl BinaryKernelSearchSummary {
    #[must_use]
    pub const fn has_witness(self) -> bool {
        self.best_weight != u16::MAX
    }

    #[must_use]
    pub const fn target_hit(self) -> bool {
        self.target_hit != 0
    }
}

#[derive(Clone, Debug)]
pub struct CompiledBinaryKernelSearch {
    columns: u16,
    rank: u16,
    logical_count: u16,
    words: u16,
    logical_words: u16,
    basis: Box<[u64]>,
    logical_columns: Box<[u64]>,
}

impl CompiledBinaryKernelSearch {
    pub fn compile(
        columns: u16,
        physical_rows: &[u64],
        physical_row_count: u16,
        logical_rows: &[u64],
        logical_row_count: u16,
    ) -> Result<Self, BinaryKernelSearchError> {
        if columns == 0 || logical_row_count == 0 {
            return Err(BinaryKernelSearchError::InvalidDimensions);
        }
        let columns_usize = usize::from(columns);
        let words = columns_usize.div_ceil(64);
        if physical_rows.len()
            != usize::from(physical_row_count)
                .checked_mul(words)
                .ok_or(BinaryKernelSearchError::InvalidDimensions)?
            || logical_rows.len()
                != usize::from(logical_row_count)
                    .checked_mul(words)
                    .ok_or(BinaryKernelSearchError::InvalidDimensions)?
            || words > usize::from(u16::MAX)
        {
            return Err(BinaryKernelSearchError::InvalidDimensions);
        }
        verify_tail_bits(physical_rows, words, columns_usize)?;
        verify_tail_bits(logical_rows, words, columns_usize)?;

        let mut basis = physical_rows.to_vec();
        let rank = canonical_row_basis(
            &mut basis,
            usize::from(physical_row_count),
            words,
            columns_usize,
        );
        basis.truncate(rank * words);
        let logical_words = usize::from(logical_row_count).div_ceil(64);
        let logical_len = columns_usize
            .checked_mul(logical_words)
            .ok_or(BinaryKernelSearchError::WorkspaceLimit)?;
        let compiled_bytes = basis
            .len()
            .checked_add(logical_len)
            .and_then(|entries| entries.checked_mul(std::mem::size_of::<u64>()))
            .ok_or(BinaryKernelSearchError::WorkspaceLimit)?;
        if compiled_bytes > MAX_BINARY_KERNEL_WORKSPACE_BYTES {
            return Err(BinaryKernelSearchError::WorkspaceLimit);
        }
        let mut logical_columns = vec![0_u64; logical_len];
        for logical in 0..usize::from(logical_row_count) {
            let row = &logical_rows[logical * words..(logical + 1) * words];
            for coordinate in 0..columns_usize {
                if row[coordinate / 64] & (1_u64 << (coordinate % 64)) != 0 {
                    logical_columns[coordinate * logical_words + logical / 64] |=
                        1_u64 << (logical % 64);
                }
            }
        }
        Ok(Self {
            columns,
            rank: rank as u16,
            logical_count: logical_row_count,
            words: words as u16,
            logical_words: logical_words as u16,
            basis: basis.into_boxed_slice(),
            logical_columns: logical_columns.into_boxed_slice(),
        })
    }

    #[must_use]
    pub const fn columns(&self) -> u16 {
        self.columns
    }

    #[must_use]
    pub const fn rank(&self) -> u16 {
        self.rank
    }

    #[must_use]
    pub const fn logical_observations(&self) -> u16 {
        self.logical_count
    }

    pub fn workspace(
        &self,
        seed: u64,
    ) -> Result<BinaryKernelSearchWorkspace, BinaryKernelSearchError> {
        BinaryKernelSearchWorkspace::new(self, seed)
    }

    pub fn verify_support(&self, support: &[u16]) -> Result<(), BinaryKernelSearchError> {
        if support.is_empty() {
            return Err(BinaryKernelSearchError::InvalidSupport);
        }
        let columns = usize::from(self.columns);
        let words = usize::from(self.words);
        let mut packed = vec![0_u64; words];
        for &coordinate in support {
            let coordinate = usize::from(coordinate);
            if coordinate >= columns {
                return Err(BinaryKernelSearchError::InvalidSupport);
            }
            let bit = 1_u64 << (coordinate % 64);
            let word = &mut packed[coordinate / 64];
            if *word & bit != 0 {
                return Err(BinaryKernelSearchError::InvalidSupport);
            }
            *word |= bit;
        }
        if self
            .basis
            .chunks_exact(words)
            .any(|row| parity_dot(row, &packed))
        {
            return Err(BinaryKernelSearchError::PhysicalViolation);
        }
        let logical_words = usize::from(self.logical_words);
        let mut logical = vec![0_u64; logical_words];
        for &coordinate in support {
            let start = usize::from(coordinate) * logical_words;
            for (value, &column) in logical
                .iter_mut()
                .zip(&self.logical_columns[start..start + logical_words])
            {
                *value ^= column;
            }
        }
        if logical.iter().all(|&word| word == 0) {
            return Err(BinaryKernelSearchError::TrivialSupport);
        }
        Ok(())
    }
}

pub struct BinaryKernelSearchWorkspace {
    columns: u16,
    rank: u16,
    words: u16,
    logical_words: u16,
    rng: XorShift64,
    work: Box<[u64]>,
    order: Box<[u16]>,
    pivots: Box<[u16]>,
    pivot_marker: Box<[u8]>,
    kernel_rows: Box<[u64]>,
    kernel_logicals: Box<[u64]>,
    kernel_weights: Box<[u16]>,
    kernel_order: Box<[u16]>,
    witness: Vec<u16>,
}

impl BinaryKernelSearchWorkspace {
    fn new(
        compiled: &CompiledBinaryKernelSearch,
        seed: u64,
    ) -> Result<Self, BinaryKernelSearchError> {
        let columns = usize::from(compiled.columns);
        let rank = usize::from(compiled.rank);
        let words = usize::from(compiled.words);
        let logical_words = usize::from(compiled.logical_words);
        let free = columns - rank;
        let u64_entries = compiled
            .basis
            .len()
            .checked_add(
                free.checked_mul(words)
                    .ok_or(BinaryKernelSearchError::WorkspaceLimit)?,
            )
            .and_then(|entries| entries.checked_add(free.checked_mul(logical_words)?))
            .ok_or(BinaryKernelSearchError::WorkspaceLimit)?;
        let bytes = u64_entries
            .checked_mul(std::mem::size_of::<u64>())
            .and_then(|value| value.checked_add(columns.checked_mul(5)?))
            .and_then(|value| value.checked_add(rank.checked_mul(2)?))
            .and_then(|value| value.checked_add(free.checked_mul(4)?))
            .ok_or(BinaryKernelSearchError::WorkspaceLimit)?;
        if bytes > MAX_BINARY_KERNEL_WORKSPACE_BYTES {
            return Err(BinaryKernelSearchError::WorkspaceLimit);
        }
        Ok(Self {
            columns: compiled.columns,
            rank: compiled.rank,
            words: compiled.words,
            logical_words: compiled.logical_words,
            rng: XorShift64(seed | 1),
            work: vec![0; compiled.basis.len()].into_boxed_slice(),
            order: (0..compiled.columns).collect::<Vec<_>>().into_boxed_slice(),
            pivots: vec![0; rank].into_boxed_slice(),
            pivot_marker: vec![0; columns].into_boxed_slice(),
            kernel_rows: vec![0; free * words].into_boxed_slice(),
            kernel_logicals: vec![0; free * logical_words].into_boxed_slice(),
            kernel_weights: vec![0; free].into_boxed_slice(),
            kernel_order: vec![0; free].into_boxed_slice(),
            witness: Vec::with_capacity(columns),
        })
    }

    pub fn reseed(&mut self, seed: u64) {
        self.rng = XorShift64(seed | 1);
    }

    #[must_use]
    pub fn witness(&self) -> &[u16] {
        &self.witness
    }

    pub fn search_targeted(
        &mut self,
        compiled: &CompiledBinaryKernelSearch,
        trials: u64,
        options: BinaryKernelTrialOptions,
    ) -> Result<BinaryKernelSearchSummary, BinaryKernelSearchError> {
        self.search::<false>(compiled, trials, options)
    }

    pub fn search_best_effort(
        &mut self,
        compiled: &CompiledBinaryKernelSearch,
        trials: u64,
        options: BinaryKernelTrialOptions,
    ) -> Result<BinaryKernelSearchSummary, BinaryKernelSearchError> {
        self.search::<true>(compiled, trials, options)
    }

    fn search<const RETAIN_BEST: bool>(
        &mut self,
        compiled: &CompiledBinaryKernelSearch,
        trials: u64,
        options: BinaryKernelTrialOptions,
    ) -> Result<BinaryKernelSearchSummary, BinaryKernelSearchError> {
        options.validate()?;
        self.check_layout(compiled)?;
        self.witness.clear();
        let mut completed = 0_u64;
        let mut best_weight = usize::from(self.columns) + 1;
        #[cfg(test)]
        let _allocation_guard = HotLoopAllocationGuard::enter();
        for _ in 0..trials {
            let incumbent = if RETAIN_BEST {
                best_weight
            } else {
                usize::from(options.target_weight) + 1
            };
            let found = self.trial::<RETAIN_BEST>(compiled, options, incumbent);
            completed += 1;
            if let Some(weight) = found {
                best_weight = weight;
                if !RETAIN_BEST && weight <= usize::from(options.target_weight) {
                    break;
                }
            }
        }
        let has_witness = !self.witness.is_empty();
        Ok(BinaryKernelSearchSummary {
            completed_trials: completed,
            best_weight: if has_witness {
                self.witness.len() as u16
            } else {
                u16::MAX
            },
            target_hit: u8::from(
                has_witness && self.witness.len() <= usize::from(options.target_weight),
            ),
            _padding: [0; 5],
        })
    }

    fn check_layout(
        &self,
        compiled: &CompiledBinaryKernelSearch,
    ) -> Result<(), BinaryKernelSearchError> {
        if self.columns != compiled.columns
            || self.rank != compiled.rank
            || self.words != compiled.words
            || self.logical_words != compiled.logical_words
        {
            return Err(BinaryKernelSearchError::WorkspaceMismatch);
        }
        Ok(())
    }

    fn shuffle(&mut self) {
        for (index, entry) in self.order.iter_mut().enumerate() {
            *entry = index as u16;
        }
        for upper in (1..self.order.len()).rev() {
            let other = self.rng.bounded(upper + 1);
            self.order.swap(upper, other);
        }
    }

    fn trial<const RETAIN_BEST: bool>(
        &mut self,
        compiled: &CompiledBinaryKernelSearch,
        options: BinaryKernelTrialOptions,
        incumbent_weight: usize,
    ) -> Option<usize> {
        let columns = usize::from(self.columns);
        let rank = usize::from(self.rank);
        let words = usize::from(self.words);
        let logical_words = usize::from(self.logical_words);
        self.work.copy_from_slice(&compiled.basis);
        self.shuffle();
        self.pivot_marker.fill(0);
        let mut pivot_count = 0usize;
        for &column in &self.order {
            let column = usize::from(column);
            let word = column / 64;
            let bit = 1_u64 << (column % 64);
            let Some(pivot) =
                (pivot_count..rank).find(|&row| self.work[row * words + word] & bit != 0)
            else {
                continue;
            };
            swap_rows(&mut self.work, words, pivot_count, pivot);
            let pivot_start = pivot_count * words;
            for row in 0..rank {
                if row != pivot_count && self.work[row * words + word] & bit != 0 {
                    let row_start = row * words;
                    for offset in 0..words {
                        self.work[row_start + offset] ^= self.work[pivot_start + offset];
                    }
                }
            }
            self.pivots[pivot_count] = column as u16;
            self.pivot_marker[column] = 1;
            pivot_count += 1;
            if pivot_count == rank {
                break;
            }
        }
        debug_assert_eq!(pivot_count, rank);

        let mut kernel_count = 0usize;
        let mut best_weight = incumbent_weight;
        let mut improved = false;
        for &free in &self.order {
            let free = usize::from(free);
            if self.pivot_marker[free] != 0 {
                continue;
            }
            let word = free / 64;
            let bit = 1_u64 << (free % 64);
            let kernel = &mut self.kernel_rows[kernel_count * words..(kernel_count + 1) * words];
            kernel.fill(0);
            kernel[word] = bit;
            let logical = &mut self.kernel_logicals
                [kernel_count * logical_words..(kernel_count + 1) * logical_words];
            logical.fill(0);
            let free_logical = free * logical_words;
            logical.copy_from_slice(
                &compiled.logical_columns[free_logical..free_logical + logical_words],
            );
            for row in 0..rank {
                if self.work[row * words + word] & bit == 0 {
                    continue;
                }
                let pivot = usize::from(self.pivots[row]);
                kernel[pivot / 64] |= 1_u64 << (pivot % 64);
                let start = pivot * logical_words;
                for (left, &right) in logical
                    .iter_mut()
                    .zip(&compiled.logical_columns[start..start + logical_words])
                {
                    *left ^= right;
                }
            }
            let weight = kernel.iter().map(|word| word.count_ones() as u16).sum();
            self.kernel_weights[kernel_count] = weight;
            self.kernel_order[kernel_count] = kernel_count as u16;
            if usize::from(weight) < best_weight && logical.iter().any(|&word| word != 0) {
                write_support(kernel, columns, &mut self.witness);
                best_weight = usize::from(weight);
                if !RETAIN_BEST {
                    return Some(best_weight);
                }
                improved = true;
            }
            kernel_count += 1;
        }
        if options.osd_order == 2 {
            self.kernel_order[..kernel_count]
                .sort_unstable_by_key(|&index| self.kernel_weights[index as usize]);
            let window = kernel_count.min(usize::from(options.osd_window));
            for left_position in 0..window {
                let left = usize::from(self.kernel_order[left_position]);
                let left_words = &self.kernel_rows[left * words..(left + 1) * words];
                let left_logical =
                    &self.kernel_logicals[left * logical_words..(left + 1) * logical_words];
                for right_position in left_position + 1..window {
                    let right = usize::from(self.kernel_order[right_position]);
                    let right_words = &self.kernel_rows[right * words..(right + 1) * words];
                    let mut weight = 0usize;
                    for (&left_word, &right_word) in left_words.iter().zip(right_words) {
                        weight += (left_word ^ right_word).count_ones() as usize;
                        if weight >= best_weight {
                            break;
                        }
                    }
                    if weight >= best_weight {
                        continue;
                    }
                    let right_logical =
                        &self.kernel_logicals[right * logical_words..(right + 1) * logical_words];
                    if !left_logical
                        .iter()
                        .zip(right_logical)
                        .any(|(&left, &right)| left ^ right != 0)
                    {
                        continue;
                    }
                    write_xor_support(left_words, right_words, columns, &mut self.witness);
                    best_weight = weight;
                    if !RETAIN_BEST {
                        return Some(best_weight);
                    }
                    improved = true;
                }
            }
        }
        improved.then_some(best_weight)
    }
}

#[derive(Clone, Copy)]
struct XorShift64(u64);

impl XorShift64 {
    fn next(&mut self) -> u64 {
        let mut value = self.0;
        value ^= value >> 12;
        value ^= value << 25;
        value ^= value >> 27;
        self.0 = value;
        value.wrapping_mul(0x2545_f491_4f6c_dd1d)
    }

    fn bounded(&mut self, bound: usize) -> usize {
        ((u128::from(self.next()) * bound as u128) >> 64) as usize
    }
}

fn verify_tail_bits(
    rows: &[u64],
    words: usize,
    columns: usize,
) -> Result<(), BinaryKernelSearchError> {
    let tail = columns % 64;
    if tail == 0 {
        return Ok(());
    }
    let allowed = (1_u64 << tail) - 1;
    if rows
        .chunks_exact(words)
        .any(|row| row[words - 1] & !allowed != 0)
    {
        return Err(BinaryKernelSearchError::NonCanonicalRow);
    }
    Ok(())
}

fn canonical_row_basis(matrix: &mut [u64], rows: usize, words: usize, columns: usize) -> usize {
    let mut rank = 0usize;
    for column in 0..columns {
        let word = column / 64;
        let bit = 1_u64 << (column % 64);
        let Some(pivot) = (rank..rows).find(|&row| matrix[row * words + word] & bit != 0) else {
            continue;
        };
        swap_rows(matrix, words, rank, pivot);
        let pivot_start = rank * words;
        for row in 0..rows {
            if row != rank && matrix[row * words + word] & bit != 0 {
                let row_start = row * words;
                for offset in 0..words {
                    matrix[row_start + offset] ^= matrix[pivot_start + offset];
                }
            }
        }
        rank += 1;
        if rank == rows {
            break;
        }
    }
    rank
}

fn swap_rows(matrix: &mut [u64], words: usize, left: usize, right: usize) {
    if left == right {
        return;
    }
    for word in 0..words {
        matrix.swap(left * words + word, right * words + word);
    }
}

fn parity_dot(left: &[u64], right: &[u64]) -> bool {
    left.iter()
        .zip(right)
        .fold(0_u32, |parity, (&left, &right)| {
            parity ^ (left & right).count_ones()
        })
        & 1
        != 0
}

fn write_support(words: &[u64], columns: usize, support: &mut Vec<u16>) {
    support.clear();
    for coordinate in 0..columns {
        if words[coordinate / 64] & (1_u64 << (coordinate % 64)) != 0 {
            support.push(coordinate as u16);
        }
    }
}

fn write_xor_support(left: &[u64], right: &[u64], columns: usize, support: &mut Vec<u16>) {
    support.clear();
    for coordinate in 0..columns {
        let bit = 1_u64 << (coordinate % 64);
        if (left[coordinate / 64] ^ right[coordinate / 64]) & bit != 0 {
            support.push(coordinate as u16);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::test_alloc::{measure_allocations, AllocationEvents};

    fn pack(rows: &[&[u16]], columns: usize) -> Vec<u64> {
        let words = columns.div_ceil(64);
        let mut packed = vec![0_u64; rows.len() * words];
        for (row, support) in rows.iter().enumerate() {
            for &coordinate in *support {
                packed[row * words + usize::from(coordinate) / 64] |=
                    1_u64 << (usize::from(coordinate) % 64);
            }
        }
        packed
    }

    #[test]
    fn targeted_and_best_effort_find_and_replay_nontrivial_words() {
        let physical = pack(&[&[0, 1]], 3);
        let logical = pack(&[&[2]], 3);
        let compiled = CompiledBinaryKernelSearch::compile(3, &physical, 1, &logical, 1).unwrap();
        let options = BinaryKernelTrialOptions::new(1, 2, 16).unwrap();
        let mut workspace = compiled.workspace(7).unwrap();
        let targeted = workspace.search_targeted(&compiled, 10, options).unwrap();
        assert!(targeted.target_hit());
        assert_eq!(targeted.best_weight, 1);
        compiled.verify_support(workspace.witness()).unwrap();

        workspace.reseed(7);
        let exhaustive = workspace
            .search_best_effort(&compiled, 10, options)
            .unwrap();
        assert_eq!(exhaustive.completed_trials, 10);
        assert_eq!(exhaustive.best_weight, 1);
        compiled.verify_support(workspace.witness()).unwrap();
    }

    #[test]
    fn order_two_can_beat_every_systematic_basis_row() {
        let physical = pack(&[&[0, 2, 3], &[1, 2, 3]], 4);
        let logical = pack(&[&[2]], 4);
        let compiled = CompiledBinaryKernelSearch::compile(4, &physical, 2, &logical, 1).unwrap();
        let witness = (1..1000).find_map(|seed| {
            let mut order_one = compiled.workspace(seed).unwrap();
            let one = order_one
                .search_targeted(
                    &compiled,
                    1,
                    BinaryKernelTrialOptions::new(2, 1, 4).unwrap(),
                )
                .unwrap();
            if one.has_witness() {
                return None;
            }
            let mut order_two = compiled.workspace(seed).unwrap();
            let two = order_two
                .search_targeted(
                    &compiled,
                    1,
                    BinaryKernelTrialOptions::new(2, 2, 4).unwrap(),
                )
                .unwrap();
            two.has_witness().then(|| order_two.witness().to_vec())
        });
        assert_eq!(witness, Some(vec![2, 3]));
    }

    #[test]
    fn hot_trial_loop_allocates_nothing() {
        let physical = pack(&[&[0, 1, 2, 3], &[1, 2, 4, 5], &[0, 3, 4, 5]], 8);
        let logical = pack(&[&[0, 2, 4, 6], &[1, 3, 5, 7]], 8);
        let compiled = CompiledBinaryKernelSearch::compile(8, &physical, 3, &logical, 2).unwrap();
        let options = BinaryKernelTrialOptions::new(1, 2, 8).unwrap();
        let mut workspace = compiled.workspace(17).unwrap();
        let (_, events) = measure_allocations(|| {
            workspace
                .search_best_effort(&compiled, 256, options)
                .unwrap()
        });
        assert_eq!(events, AllocationEvents::default());
    }

    #[test]
    fn worker_thread_trial_loops_allocate_nothing() {
        let physical = pack(&[&[0, 1, 2, 3], &[1, 2, 4, 5], &[0, 3, 4, 5]], 8);
        let logical = pack(&[&[0, 2, 4, 6], &[1, 3, 5, 7]], 8);
        let compiled = CompiledBinaryKernelSearch::compile(8, &physical, 3, &logical, 2).unwrap();
        let options = BinaryKernelTrialOptions::new(1, 2, 8).unwrap();
        let mut workspaces = [
            compiled.workspace(17).unwrap(),
            compiled.workspace(29).unwrap(),
        ];
        let (_, events) = measure_allocations(|| {
            let measurement = crate::test_alloc::current_measurement();
            std::thread::scope(|scope| {
                for workspace in &mut workspaces {
                    scope.spawn(|| {
                        measurement.scope(|| {
                            workspace
                                .search_best_effort(&compiled, 256, options)
                                .unwrap()
                        })
                    });
                }
            });
        });
        assert_eq!(events, AllocationEvents::default());
    }

    #[test]
    fn systematic_order_two_agrees_with_an_independent_exhaustive_oracle() {
        let mut state = 0x9e37_79b9_7f4a_7c15_u64;
        for columns in 3_u16..=8 {
            for case in 0..64_u64 {
                let rank = columns - 2;
                let mut physical = vec![0_u64; usize::from(rank)];
                for row in 0..rank {
                    state ^= state >> 12;
                    state ^= state << 25;
                    state ^= state >> 27;
                    physical[usize::from(row)] = (1_u64 << row) | ((state & 3) << rank);
                }
                state ^= state >> 12;
                state ^= state << 25;
                state ^= state >> 27;
                let logical = [state & ((1_u64 << columns) - 1)];
                let compiled =
                    CompiledBinaryKernelSearch::compile(columns, &physical, rank, &logical, 1)
                        .unwrap();
                let expected = (1_u64..1_u64 << columns)
                    .filter(|&word| {
                        physical
                            .iter()
                            .all(|&row| (row & word).count_ones() & 1 == 0)
                    })
                    .filter(|&word| (logical[0] & word).count_ones() & 1 != 0)
                    .map(u64::count_ones)
                    .min()
                    .map(|weight| weight as u16);
                let mut workspace = compiled.workspace(case + u64::from(columns)).unwrap();
                let summary = workspace
                    .search_best_effort(
                        &compiled,
                        1,
                        BinaryKernelTrialOptions::new(columns, 2, 2).unwrap(),
                    )
                    .unwrap();
                assert_eq!(
                    summary.has_witness().then_some(summary.best_weight),
                    expected
                );
                if expected.is_some() {
                    compiled.verify_support(workspace.witness()).unwrap();
                }
            }
        }
    }

    #[test]
    fn malformed_rows_options_workspaces_and_supports_fail_closed() {
        assert!(matches!(
            CompiledBinaryKernelSearch::compile(3, &[0b1000], 1, &[1], 1),
            Err(BinaryKernelSearchError::NonCanonicalRow)
        ));
        assert_eq!(
            BinaryKernelTrialOptions::new(1, 3, 1),
            Err(BinaryKernelSearchError::InvalidOptions)
        );
        let left = CompiledBinaryKernelSearch::compile(3, &[0b11], 1, &[0b100], 1).unwrap();
        let right = CompiledBinaryKernelSearch::compile(4, &[0b11], 1, &[0b100], 1).unwrap();
        let mut workspace = left.workspace(1).unwrap();
        assert_eq!(
            workspace.search_targeted(&right, 1, BinaryKernelTrialOptions::new(1, 1, 1).unwrap()),
            Err(BinaryKernelSearchError::WorkspaceMismatch)
        );
        assert_eq!(
            left.verify_support(&[0]),
            Err(BinaryKernelSearchError::PhysicalViolation)
        );
        assert_eq!(
            left.verify_support(&[0, 0]),
            Err(BinaryKernelSearchError::InvalidSupport)
        );
        assert_eq!(
            left.verify_support(&[0, 1]),
            Err(BinaryKernelSearchError::TrivialSupport)
        );
    }
}
