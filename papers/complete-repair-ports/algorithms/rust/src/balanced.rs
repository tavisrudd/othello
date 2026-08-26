//! Normalized exact front end for the Gf27 balanced `q=27` branch.
//!
//! Projective shear and homothety normalization leave four cubic ratio
//! fibers.  Frobenius identifies three of them, so only two representatives
//! feed the expensive carrier or incidence solver.  This module compiles the
//! remaining singleton transversals into compact, allocation-free scan data.

use crate::projective::TernaryExtensionField;
use rustc_hash::{FxHashMap, FxHashSet};
use thiserror::Error;

const Q: u8 = 27;

/// Independent length-two Witt Fourier coordinates at `q=27`.
/// Multiples of three are recovered by Frobenius from the divided index.
pub const WITT_INDEPENDENT_EXPONENTS_Q27: [u8; 17] =
    [1, 2, 4, 5, 7, 8, 10, 11, 13, 14, 16, 17, 19, 20, 22, 23, 25];

/// One normalized ratio fiber and its semilinear orbit.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct RatioFiber {
    pub roots: [u8; 3],
    pub frobenius_orbit: [u8; 3],
    pub kappa: u8,
    pub orbit_len: u8,
}

const _: () = assert!(std::mem::size_of::<RatioFiber>() == 8);
const _: () = assert!(std::mem::align_of::<RatioFiber>() == 1);

/// A normalized bijection from three marked rows to three singleton columns.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct TransversalMapping {
    pub rows: [u8; 3],
    pub columns: [u8; 3],
    pub ratios: [u8; 3],
    pub kappa: u8,
    row_cubes: [u8; 3],
    forbidden_a: [u8; 3],
}

const _: () = assert!(std::mem::size_of::<TransversalMapping>() == 16);
const _: () = assert!(std::mem::align_of::<TransversalMapping>() == 1);

/// Mapping-independent `(U,E)` key, with multiplicity one or two.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct TransversalPair {
    pub rows: [u8; 3],
    pub columns: [u8; 3],
    pub kappa: u8,
    pub multiplicity: u8,
}

const _: () = assert!(std::mem::size_of::<TransversalPair>() == 8);
const _: () = assert!(std::mem::align_of::<TransversalPair>() == 1);

/// One independently schedulable joint carrier--mapping orbit.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct BalancedWorkItem {
    pub mapping_index: u16,
    pub ratio_case: u8,
    pub orbit_size: u8,
    pub kappa: u8,
    _reserved: [u8; 3],
}

const _: () = assert!(std::mem::size_of::<BalancedWorkItem>() == 8);
const _: () = assert!(std::mem::align_of::<BalancedWorkItem>() == 2);

#[repr(C, align(64))]
#[derive(Clone, Debug)]
pub struct HighFiberSpec {
    value_to_slot: [u8; 27],
    target_counts: [u8; 9],
    values: [u8; 9],
    cubic_count: u8,
    _reserved: [u8; 18],
}

const _: () = assert!(std::mem::size_of::<HighFiberSpec>() == 64);
const _: () = assert!(std::mem::align_of::<HighFiberSpec>() == 64);

impl HighFiberSpec {
    pub fn new(values: [u8; 9], cubic_mask: u16) -> Option<Self> {
        if cubic_mask >= 1 << 9 {
            return None;
        }
        let mut value_to_slot = [u8::MAX; 27];
        for (slot, &value) in values.iter().enumerate() {
            if value == 0 || value >= 27 || value_to_slot[value as usize] != u8::MAX {
                return None;
            }
            value_to_slot[value as usize] = slot as u8;
        }
        let target_counts =
            std::array::from_fn(|slot| if cubic_mask & (1 << slot) != 0 { 3 } else { 4 });
        Some(Self {
            value_to_slot,
            target_counts,
            values,
            cubic_count: cubic_mask.count_ones() as u8,
            _reserved: [0; 18],
        })
    }

    pub fn cubic_count(&self) -> u8 {
        self.cubic_count
    }

    pub fn values(&self) -> &[u8; 9] {
        &self.values
    }

    pub fn target_counts(&self) -> &[u8; 9] {
        &self.target_counts
    }
}

/// Hot prefix state for the high-fiber row-overlap identity.
#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct HighFiberLedger {
    counts: [u8; 9],
    rows_done: u8,
    overlap_delta: i8,
    zero_rows: u8,
    double_rows: u8,
    _reserved: [u8; 3],
}

const _: () = assert!(std::mem::size_of::<HighFiberLedger>() == 16);
const _: () = assert!(std::mem::align_of::<HighFiberLedger>() == 1);

/// First four elementary coefficients of the degree-54 support product.
#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct WittSpectralPrefix {
    elementary: [u8; 4],
    roots_done: u8,
    _reserved: [u8; 3],
}

const _: () = assert!(std::mem::size_of::<WittSpectralPrefix>() == 8);
const _: () = assert!(std::mem::align_of::<WittSpectralPrefix>() == 1);

/// One factorized high fiber `C(X)-y*A(X)+y^2`, padded through degree eight.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct HighFiberPolynomial {
    pub coefficients: [u8; 9],
    pub value: u8,
    _reserved: [u8; 6],
}

const _: () = assert!(std::mem::size_of::<HighFiberPolynomial>() == 16);
const _: () = assert!(std::mem::align_of::<HighFiberPolynomial>() == 1);

impl HighFiberPolynomial {
    pub fn new(value: u8, coefficients: [u8; 9]) -> Option<Self> {
        if value >= Q || coefficients.iter().any(|&coefficient| coefficient >= Q) {
            return None;
        }
        Some(Self {
            coefficients,
            value,
            _reserved: [0; 6],
        })
    }
}

/// Degree-eight trace/product candidate reconstructed from two high fibers.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct BalancedCarrierCoefficients {
    pub trace: [u8; 9],
    pub product: [u8; 9],
    _reserved: [u8; 14],
}

const _: () = assert!(std::mem::size_of::<BalancedCarrierCoefficients>() == 32);
const _: () = assert!(std::mem::align_of::<BalancedCarrierCoefficients>() == 1);

impl BalancedCarrierCoefficients {
    pub fn new(trace: [u8; 9], product: [u8; 9]) -> Option<Self> {
        if trace.iter().chain(&product).any(|&value| value >= Q) {
            return None;
        }
        Some(Self {
            trace,
            product,
            _reserved: [0; 14],
        })
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct BalancedSeedWitness {
    pub candidates_examined: u64,
    pub carrier: BalancedCarrierCoefficients,
    pub candidate_indices: [u16; 9],
    pub seed_slots: [u8; 2],
    _reserved: [u8; 4],
}

const _: () = assert!(std::mem::size_of::<BalancedSeedWitness>() == 64);
const _: () = assert!(std::mem::align_of::<BalancedSeedWitness>() == 8);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct CarrierCellSolve {
    pub carrier: Option<BalancedCarrierCoefficients>,
    pub rank: u8,
    pub consistent: bool,
}

/// The exact terminal gates for one fixed semilinear carrier--mapping task.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
#[repr(u8)]
pub enum BalancedTerminalRejection {
    TaskIndex = 0,
    CarrierDoesNotSplit = 1,
    HighFiberProfile = 2,
    MappingCellPresent = 3,
    UnshiftedNorm = 4,
    ReciprocalNorm = 5,
    FourthWitt = 6,
    TerminalRankBound = 7,
    MobiusDiscriminantEmpty = 8,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct BalancedTerminalWitness {
    pub carrier: BalancedCarrierCoefficients,
    pub ratio_case: u8,
    pub mapping_index: u16,
    pub high_values: [u8; 9],
    pub cubic_count: u8,
}

/// A rank-18 point or rank-17 affine line in carrier coefficient space.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct CarrierAffineFamily {
    pub origin: BalancedCarrierCoefficients,
    pub direction: Option<BalancedCarrierCoefficients>,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct BalancedDfsLimits {
    /// Zero means no node limit.
    pub max_nodes: u64,
    /// Zero means no terminal-carrier limit.
    pub max_terminal_carriers: u64,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct BalancedDfsStats {
    pub nodes: u64,
    pub terminal_carriers: u64,
    pub prefix_mismatches: u64,
    pub duplicate_terminals: u64,
    pub split_mask_prunes: u64,
    pub split_parameters_removed: u64,
    pub mobius_terminal_families: u64,
    pub inconsistent_pushes: u64,
    pub ledger_prunes: u64,
    pub rank_bound_prunes: u64,
    pub rejection_counts: [u64; 9],
    pub maximum_rank: u8,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct BalancedRejectionCore {
    pub category: BalancedTerminalRejection,
    pub kappa: u8,
    pub mapping_key: [u8; 9],
    pub high_values: [u8; 9],
    pub cubic_count: u8,
    /// Rows whose Möbius-parameter square masks already have empty
    /// intersection.  Empty for non-splitting-independent gate cores.
    pub discriminant_rows: Box<[u8]>,
    /// Jointly Frobenius-canonical high-cell equations.  Terminal-gate cores
    /// are greedily inclusion-minimal; the rank-bound core is the full
    /// completed high-incidence pattern used by that theorem.
    pub cells: Box<[(u8, u8)]>,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum BalancedDfsStatus {
    Witness,
    Rejected,
    Incomplete,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct BalancedDfsResult {
    pub status: BalancedDfsStatus,
    pub witness: Option<BalancedTerminalWitness>,
    pub stats: BalancedDfsStats,
    pub rejection_cores: Box<[BalancedRejectionCore]>,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct BalancedQueueLimits {
    /// Zero visits all 714 joint semilinear tasks.
    pub max_tasks: u16,
    /// Zero visits all `binom(26,9)=3,124,550` high sets in each task.
    pub max_high_sets_per_task: u64,
    pub per_high_set: BalancedDfsLimits,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct BalancedWorkDfsResult {
    pub work_ordinal: u16,
    pub work_item: BalancedWorkItem,
    pub status: BalancedDfsStatus,
    pub high_sets_examined: u64,
    pub witness: Option<BalancedTerminalWitness>,
    pub stats: BalancedDfsStats,
    pub rejection_cores: Box<[BalancedRejectionCore]>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct BalancedQueueDfsResult {
    pub status: BalancedDfsStatus,
    pub tasks: Box<[BalancedWorkDfsResult]>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct BalancedCoreClass {
    pub core: BalancedRejectionCore,
    pub task_count: u16,
    pub orbit_weight: u32,
}

impl BalancedWorkDfsResult {
    pub fn minimal_rejection_core(&self) -> Option<&BalancedRejectionCore> {
        (self.status == BalancedDfsStatus::Rejected)
            .then(|| {
                self.rejection_cores.iter().min_by_key(|core| {
                    (
                        core.cells.len() + core.discriminant_rows.len(),
                        core.cells.len(),
                        core.category as u8,
                        core.kappa,
                        core.mapping_key,
                        core.high_values,
                    )
                })
            })
            .flatten()
    }
}

impl BalancedQueueDfsResult {
    /// Classifies one minimal jointly Frobenius-canonical core per task.
    /// A partial queue has no rejection classification.
    pub fn canonical_core_classes(&self) -> Option<Box<[BalancedCoreClass]>> {
        if self.status != BalancedDfsStatus::Rejected || self.tasks.len() != 714 {
            return None;
        }
        let mut classes = Vec::<BalancedCoreClass>::new();
        for task in &self.tasks {
            let core = task.minimal_rejection_core()?;
            if let Some(class) = classes.iter_mut().find(|class| class.core == *core) {
                class.task_count += 1;
                class.orbit_weight += u32::from(task.work_item.orbit_size);
            } else {
                classes.push(BalancedCoreClass {
                    core: core.clone(),
                    task_count: 1,
                    orbit_weight: u32::from(task.work_item.orbit_size),
                });
            }
        }
        classes.sort_by(|left, right| {
            right
                .task_count
                .cmp(&left.task_count)
                .then_with(|| {
                    (left.core.cells.len() + left.core.discriminant_rows.len())
                        .cmp(&(right.core.cells.len() + right.core.discriminant_rows.len()))
                })
                .then_with(|| (left.core.category as u8).cmp(&(right.core.category as u8)))
                .then_with(|| left.core.mapping_key.cmp(&right.core.mapping_key))
        });
        Some(classes.into_boxed_slice())
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Error)]
pub enum BalancedDfsError {
    #[error("the semilinear task index is invalid")]
    TaskIndex,
    #[error("cubic high fibers must be exactly the high singleton values")]
    HighFiberMappingMismatch,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
struct IncidenceRowChoice {
    values: [u8; 2],
    count: u8,
    rank_gain: u8,
}

const _: () = assert!(std::mem::size_of::<IncidenceRowChoice>() == 4);
const _: () = assert!(std::mem::align_of::<IncidenceRowChoice>() == 1);

#[repr(C, align(64))]
#[derive(Clone)]
pub struct CarrierEquationBasis {
    rows: [[u8; 19]; 18],
    pivots: [u8; 18],
    rank: u8,
    _reserved: [u8; 23],
}

const _: () = assert!(std::mem::size_of::<CarrierEquationBasis>() == 384);
const _: () = assert!(std::mem::align_of::<CarrierEquationBasis>() == 64);

impl Default for CarrierEquationBasis {
    fn default() -> Self {
        Self {
            rows: [[0; 19]; 18],
            pivots: [u8::MAX; 18],
            rank: 0,
            _reserved: [0; 23],
        }
    }
}

impl CarrierEquationBasis {
    pub fn rank(&self) -> u8 {
        self.rank
    }

    pub fn pop_independent(&mut self) -> bool {
        if self.rank == 0 {
            return false;
        }
        self.rank -= 1;
        true
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum CarrierEquationPush {
    Independent,
    Dependent,
    Inconsistent,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Error)]
pub enum BalancedSeedError {
    #[error("seed reconstruction needs exactly nine nonempty fiber families")]
    FamilyShape,
    #[error("every candidate family must have one distinct valid fiber value")]
    FiberValue,
    #[error("a candidate family exceeds the compact witness index")]
    TooManyCandidates,
}

impl HighFiberLedger {
    /// Adds one distinct quadratic root pair if it can still reach every
    /// cubic/quartic fiber count and `n_2-n_0=10-g` in 26 rows.
    pub fn try_push(&mut self, spec: &HighFiberSpec, roots: [u8; 2]) -> bool {
        if self.rows_done == 26 || roots[0] >= 27 || roots[1] >= 27 || roots[0] == roots[1] {
            return false;
        }
        let mut high_values = [0u8; 2];
        let mut high_count = 0u8;
        for root in roots {
            let slot = spec.value_to_slot[root as usize];
            if slot == u8::MAX {
                continue;
            }
            high_values[high_count as usize] = root;
            high_count += 1;
        }
        self.try_push_high_values(spec, high_values, high_count)
    }

    /// Adds only the selected high values on one row.  Low roots are not
    /// represented in the high-incidence DFS.
    pub fn try_push_high_values(
        &mut self,
        spec: &HighFiberSpec,
        high_values: [u8; 2],
        high_count: u8,
    ) -> bool {
        if self.rows_done == 26 || high_count > 2 {
            return false;
        }
        if high_count == 2 && high_values[0] == high_values[1] {
            return false;
        }
        let mut next = *self;
        for &value in high_values.iter().take(high_count as usize) {
            if value >= Q {
                return false;
            }
            let slot = spec.value_to_slot[value as usize];
            if slot == u8::MAX {
                return false;
            }
            let count = &mut next.counts[slot as usize];
            *count += 1;
            if *count > spec.target_counts[slot as usize] {
                return false;
            }
        }
        next.rows_done += 1;
        next.overlap_delta += high_count as i8 - 1;
        if high_count == 0 {
            next.zero_rows += 1;
        } else if high_count == 2 {
            next.double_rows += 1;
        }
        let remaining = 26 - next.rows_done;
        let target_delta = 10 - spec.cubic_count as i8;
        if next.overlap_delta - (remaining as i8) > target_delta
            || next.overlap_delta + (remaining as i8) < target_delta
        {
            return false;
        }
        let mut total_deficit = 0u8;
        for slot in 0..9 {
            let deficit = spec.target_counts[slot] - next.counts[slot];
            if deficit > remaining {
                return false;
            }
            total_deficit += deficit;
        }
        if total_deficit > 2 * remaining {
            return false;
        }
        *self = next;
        true
    }

    pub fn is_complete(&self, spec: &HighFiberSpec) -> bool {
        self.rows_done == 26
            && self.counts == spec.target_counts
            && self.overlap_delta == 10 - spec.cubic_count as i8
    }

    pub fn rows_done(&self) -> u8 {
        self.rows_done
    }

    pub fn zero_rows(&self) -> u8 {
        self.zero_rows
    }

    pub fn double_rows(&self) -> u8 {
        self.double_rows
    }

    /// At a complete ledger, the 18-coefficient carrier system has nullity
    /// zero except possibly nullity one when there are seven double rows.
    pub fn carrier_nullity_upper_bound(&self, spec: &HighFiberSpec) -> Option<u8> {
        self.is_complete(spec)
            .then_some(u8::from(self.double_rows == 7))
    }
}

#[derive(Clone, Debug)]
pub struct BalancedTransversalCatalog {
    ratio_fibers: [RatioFiber; 2],
    mappings: Box<[TransversalMapping]>,
    pairs: Box<[TransversalPair]>,
    witt4_weights: Box<[u8]>,
    mapping_offsets: [u16; 3],
    work_items: Box<[BalancedWorkItem]>,
    work_offsets: [u16; 3],
    frobenius: [u8; 27],
    field_add: Box<[u8]>,
    field_multiply: Box<[u8]>,
    witt4_coefficient_weights: [[u8; 2]; 2],
    nonzero_square: [bool; 27],
}

impl BalancedTransversalCatalog {
    pub fn q27() -> Self {
        let field = TernaryExtensionField::new(Q).expect("GF(27) is supported");
        let mut raw_fibers = Vec::with_capacity(4);
        for kappa in 1..Q {
            let mut roots = [0; 3];
            let mut len = 0usize;
            for value in 0..Q {
                let shifted = field.add(value, 1);
                let image = field.multiply(value, field.multiply(shifted, shifted));
                if image == kappa {
                    if len < roots.len() {
                        roots[len] = value;
                    }
                    len += 1;
                }
            }
            if len == 3 {
                roots.sort_unstable();
                raw_fibers.push((kappa, roots));
            }
        }
        debug_assert_eq!(raw_fibers.len(), 4);

        let mut representatives = Vec::with_capacity(2);
        let mut seen = [false; Q as usize];
        for &(kappa, roots) in &raw_fibers {
            if seen[kappa as usize] {
                continue;
            }
            let mut orbit = [0; 3];
            let mut orbit_len = 0usize;
            let mut value = kappa;
            loop {
                if seen[value as usize] {
                    break;
                }
                seen[value as usize] = true;
                orbit[orbit_len] = value;
                orbit_len += 1;
                value = field.pow(value, 3);
            }
            orbit[..orbit_len].sort_unstable();
            representatives.push(RatioFiber {
                roots,
                frobenius_orbit: orbit,
                kappa,
                orbit_len: orbit_len as u8,
            });
        }
        representatives.sort_unstable_by_key(|fiber| fiber.kappa);
        let ratio_fibers: [RatioFiber; 2] = representatives
            .try_into()
            .expect("GF(27) has two semilinear ratio cases");
        let frobenius = std::array::from_fn(|value| field.pow(value as u8, 3));
        let field_add = (0..729)
            .map(|index| field.add((index / 27) as u8, (index % 27) as u8))
            .collect::<Vec<_>>()
            .into_boxed_slice();
        let field_multiply = (0..729)
            .map(|index| field.multiply((index / 27) as u8, (index % 27) as u8))
            .collect::<Vec<_>>()
            .into_boxed_slice();
        let witt4_coefficient_weights = std::array::from_fn(|ratio_case| {
            let kappa = ratio_fibers[ratio_case].kappa;
            let kappa_r = field.pow(kappa, 9);
            let kappa_minus_one_r = field.pow(field.add(kappa, 2), 9);
            let common = field.multiply(kappa_r, kappa_minus_one_r);
            [
                field.multiply(common, field.add(kappa_r, 1)),
                field.multiply(common, kappa_minus_one_r),
            ]
        });
        let mut nonzero_square = [false; 27];
        for value in 1..Q {
            nonzero_square[field.multiply(value, value) as usize] = true;
        }

        let mut mappings = Vec::with_capacity(1_060);
        let mut mapping_offsets = [0u16; 3];
        for (fiber_index, fiber) in ratio_fibers.iter().enumerate() {
            for first in 1..Q {
                for second in 1..Q {
                    if first == second {
                        continue;
                    }
                    let third = field.inverse(field.multiply(first, second));
                    let rows = [first, second, third];
                    if has_duplicate(rows) {
                        continue;
                    }
                    let columns = [
                        field.multiply(fiber.roots[0], rows[0]),
                        field.multiply(fiber.roots[1], rows[1]),
                        field.multiply(fiber.roots[2], rows[2]),
                    ];
                    if has_duplicate(columns) {
                        continue;
                    }
                    mappings.push(TransversalMapping {
                        rows,
                        columns,
                        ratios: fiber.roots,
                        kappa: fiber.kappa,
                        row_cubes: rows.map(|row| field.pow(row, 3)),
                        forbidden_a: std::array::from_fn(|index| {
                            field.multiply(field.add(fiber.roots[index], 2), rows[index])
                        }),
                    });
                }
            }
            mapping_offsets[fiber_index + 1] = mappings.len() as u16;
        }

        let mut work_items = Vec::with_capacity(714);
        let mut work_offsets = [0u16; 3];
        for (ratio_case, fiber) in ratio_fibers.iter().enumerate() {
            let start = mapping_offsets[ratio_case] as usize;
            let end = mapping_offsets[ratio_case + 1] as usize;
            for (local_index, &mapping) in mappings[start..end].iter().enumerate() {
                let key = mapping_key(mapping);
                let (is_representative, orbit_size) = if fiber.orbit_len == 1 {
                    let image_one = frobenius_image_with_table(mapping, 1, &frobenius);
                    let image_two = frobenius_image_with_table(mapping, 2, &frobenius);
                    let fixed = key == mapping_key(image_one);
                    (
                        key <= mapping_key(image_one) && key <= mapping_key(image_two),
                        if fixed { 1 } else { 3 },
                    )
                } else {
                    (true, 3)
                };
                if is_representative {
                    work_items.push(BalancedWorkItem {
                        mapping_index: local_index as u16,
                        ratio_case: ratio_case as u8,
                        orbit_size,
                        kappa: mapping.kappa,
                        _reserved: [0; 3],
                    });
                }
            }
            work_offsets[ratio_case + 1] = work_items.len() as u16;
        }

        let mut pair_keys = Vec::with_capacity(mappings.len());
        for mapping in &mappings {
            let mut rows = mapping.rows;
            let mut columns = mapping.columns;
            rows.sort_unstable();
            columns.sort_unstable();
            pair_keys.push(TransversalPair {
                rows,
                columns,
                kappa: mapping.kappa,
                multiplicity: 1,
            });
        }
        pair_keys.sort_unstable();
        let mut pairs: Vec<TransversalPair> = Vec::with_capacity(pair_keys.len());
        for key in pair_keys {
            if let Some(previous) = pairs.last_mut() {
                if previous.rows == key.rows
                    && previous.columns == key.columns
                    && previous.kappa == key.kappa
                {
                    previous.multiplicity += 1;
                    continue;
                }
            }
            pairs.push(key);
        }

        let mut witt4_weights = Vec::with_capacity(2 * Q as usize * Q as usize);
        for fiber in &ratio_fibers {
            for t in 0..Q {
                for u in 0..Q {
                    witt4_weights.push(witt4_theta(&field, fiber.kappa, u, t));
                }
            }
        }
        Self {
            ratio_fibers,
            mappings: mappings.into_boxed_slice(),
            pairs: pairs.into_boxed_slice(),
            witt4_weights: witt4_weights.into_boxed_slice(),
            mapping_offsets,
            work_items: work_items.into_boxed_slice(),
            work_offsets,
            frobenius,
            field_add,
            field_multiply,
            witt4_coefficient_weights,
            nonzero_square,
        }
    }

    pub fn ratio_fibers(&self) -> &[RatioFiber; 2] {
        &self.ratio_fibers
    }

    pub fn mappings(&self, ratio_case: usize) -> Option<&[TransversalMapping]> {
        if ratio_case >= self.ratio_fibers.len() {
            return None;
        }
        let start = self.mapping_offsets[ratio_case] as usize;
        let end = self.mapping_offsets[ratio_case + 1] as usize;
        Some(&self.mappings[start..end])
    }

    pub fn pairs(&self) -> &[TransversalPair] {
        &self.pairs
    }

    /// Borrowed work items after quotienting every semilinear stabilizer.
    pub fn work_items(&self, ratio_case: usize) -> Option<&[BalancedWorkItem]> {
        if ratio_case >= self.ratio_fibers.len() {
            return None;
        }
        let start = self.work_offsets[ratio_case] as usize;
        let end = self.work_offsets[ratio_case + 1] as usize;
        Some(&self.work_items[start..end])
    }

    /// All 714 work items; orbit sizes sum to the original 2,120 mappings.
    pub fn all_work_items(&self) -> &[BalancedWorkItem] {
        &self.work_items
    }

    pub fn storage_bytes(&self) -> usize {
        std::mem::size_of_val(&*self.mappings)
            + std::mem::size_of_val(&*self.pairs)
            + std::mem::size_of_val(&*self.witt4_weights)
            + std::mem::size_of_val(&*self.work_items)
            + std::mem::size_of_val(&*self.field_add)
            + std::mem::size_of_val(&*self.field_multiply)
    }

    /// The precomputed right-hand weight `Theta_4(u,t;kappa)^9` for the first
    /// independent post-quadratic Witt constraint.
    #[inline]
    pub fn witt4_weight(&self, ratio_case: usize, u: u8, t: u8) -> Option<u8> {
        if ratio_case >= 2 || u >= Q || t >= Q {
            return None;
        }
        let index = ratio_case * Q as usize * Q as usize + t as usize * Q as usize + u as usize;
        Some(self.witt4_weights[index])
    }

    /// The collapsed fourth-Witt spectrum gate from `(a5,a6,a7,a8)`.
    #[inline]
    pub fn witt4_coefficient_gate(&self, ratio_case: usize, top_a: [u8; 4]) -> Option<u8> {
        if ratio_case >= 2 || top_a.iter().any(|&value| value >= Q) {
            return None;
        }
        let power_r = |value: u8| self.frobenius[self.frobenius[value as usize] as usize];
        let [a5, a6, a7, a8] = top_a.map(power_r);
        let product = self.multiply(a6, a8);
        let square = self.multiply(a7, a7);
        let delta = self.add(product, self.multiply(2, square));
        let [a5_weight, delta_weight] = self.witt4_coefficient_weights[ratio_case];
        Some(self.add(
            self.multiply(a5_weight, a5),
            self.multiply(delta_weight, delta),
        ))
    }

    #[inline]
    pub fn witt2_coefficient_gate(&self, ratio_case: usize, top_a: [u8; 2]) -> Option<u8> {
        if ratio_case >= 2 || top_a.iter().any(|&value| value >= Q) {
            return None;
        }
        let power_r = |value: u8| self.frobenius[self.frobenius[value as usize] as usize];
        let a7_r = power_r(top_a[0]);
        let a8_r = power_r(top_a[1]);
        let a8_2r = self.multiply(a8_r, a8_r);
        let kappa_r = power_r(self.ratio_fibers[ratio_case].kappa);
        Some(self.multiply(kappa_r, self.add(a7_r, a8_2r)))
    }

    /// Reconstructs `(A,C)` from two distinct high fibers using `(SR24z)`.
    pub fn reconstruct_carrier_from_fibers(
        &self,
        first: HighFiberPolynomial,
        second: HighFiberPolynomial,
    ) -> Option<BalancedCarrierCoefficients> {
        if first.value == second.value {
            return None;
        }
        let denominator = self.add(first.value, self.multiply(2, second.value));
        let inverse = self.inverse(denominator);
        let mut trace = [0; 9];
        for (degree, coefficient) in trace.iter_mut().enumerate() {
            let difference = self.add(
                first.coefficients[degree],
                self.multiply(2, second.coefficients[degree]),
            );
            let quotient = self.multiply(difference, inverse);
            *coefficient = self.multiply(2, quotient);
        }
        trace[0] = self.add(trace[0], self.add(first.value, second.value));

        let mut product = first.coefficients;
        for (coefficient, &trace_coefficient) in product.iter_mut().zip(&trace) {
            *coefficient = self.add(*coefficient, self.multiply(first.value, trace_coefficient));
        }
        let first_square = self.multiply(first.value, first.value);
        product[0] = self.add(product[0], self.multiply(2, first_square));
        Some(BalancedCarrierCoefficients {
            trace,
            product,
            _reserved: [0; 14],
        })
    }

    pub fn high_fiber_matches(
        &self,
        carrier: &BalancedCarrierCoefficients,
        fiber: HighFiberPolynomial,
    ) -> bool {
        self.high_fiber_coefficients(carrier, fiber.value) == fiber.coefficients
    }

    fn high_fiber_coefficients(&self, carrier: &BalancedCarrierCoefficients, value: u8) -> [u8; 9] {
        let mut expected = carrier.product;
        for (coefficient, &trace_coefficient) in expected.iter_mut().zip(&carrier.trace) {
            *coefficient = self.add(
                *coefficient,
                self.multiply(2, self.multiply(value, trace_coefficient)),
            );
        }
        expected[0] = self.add(expected[0], self.multiply(value, value));
        expected
    }

    pub fn high_fiber_from_carrier(
        &self,
        carrier: &BalancedCarrierCoefficients,
        value: u8,
    ) -> Option<HighFiberPolynomial> {
        (value != 0 && value < Q).then(|| HighFiberPolynomial {
            coefficients: self.high_fiber_coefficients(carrier, value),
            value,
            _reserved: [0; 6],
        })
    }

    /// `F_3`-rank of allowed `(A,C)` pair differences at one unmarked row.
    pub fn unmarked_pair_local_rank(&self, omitted: u8) -> Option<u8> {
        if omitted == 0 || omitted >= Q {
            return None;
        }
        let mut pairs = (0..Q).flat_map(|first| {
            (first + 1..Q)
                .filter(move |&second| omitted != first && omitted != second)
                .map(move |second| (self.add(first, second), self.multiply(first, second)))
        });
        let baseline = pairs.next()?;
        let mut rows = [[0u8; 6]; 6];
        let mut pivots = [u8::MAX; 6];
        let mut rank = 0usize;
        for pair in pairs {
            let differences = [
                self.add(pair.0, self.multiply(2, baseline.0)),
                self.add(pair.1, self.multiply(2, baseline.1)),
            ];
            let mut vector = [0u8; 6];
            for (half, mut value) in differences.into_iter().enumerate() {
                for coordinate in 0..3 {
                    vector[3 * half + coordinate] = value % 3;
                    value /= 3;
                }
            }
            for index in 0..rank {
                let coefficient = vector[pivots[index] as usize];
                if coefficient != 0 {
                    for (entry, &row_entry) in vector.iter_mut().zip(&rows[index]) {
                        *entry = (*entry + 3 - coefficient * row_entry % 3) % 3;
                    }
                }
            }
            let Some(pivot) = vector.iter().position(|&entry| entry != 0) else {
                continue;
            };
            if vector[pivot] == 2 {
                for entry in &mut vector {
                    *entry = 2 * *entry % 3;
                }
            }
            for row in rows.iter_mut().take(rank) {
                let coefficient = row[pivot];
                if coefficient != 0 {
                    for (entry, &new_entry) in row.iter_mut().zip(&vector) {
                        *entry = (*entry + 3 - coefficient * new_entry % 3) % 3;
                    }
                }
            }
            let position = pivots[..rank].partition_point(|&old| old < pivot as u8);
            rows[position..=rank].rotate_right(1);
            pivots[position..=rank].rotate_right(1);
            rows[position] = vector;
            pivots[position] = pivot as u8;
            rank += 1;
            if rank == 6 {
                break;
            }
        }
        Some(rank as u8)
    }

    /// Chooses the least-product seed pair and verifies the other seven fibers.
    pub fn search_high_fiber_candidates(
        &self,
        families: &[Vec<HighFiberPolynomial>],
    ) -> Result<Option<BalancedSeedWitness>, BalancedSeedError> {
        if families.len() != 9 || families.iter().any(Vec::is_empty) {
            return Err(BalancedSeedError::FamilyShape);
        }
        let mut seen_values = [false; Q as usize];
        for family in families {
            if family.len() > u16::MAX as usize {
                return Err(BalancedSeedError::TooManyCandidates);
            }
            let value = family[0].value;
            if value == 0
                || value >= Q
                || seen_values[value as usize]
                || family.iter().any(|candidate| candidate.value != value)
            {
                return Err(BalancedSeedError::FiberValue);
            }
            seen_values[value as usize] = true;
        }
        let (first_slot, second_slot) = (0..8)
            .flat_map(|first| (first + 1..9).map(move |second| (first, second)))
            .min_by_key(|&(first, second)| {
                (
                    families[first].len().saturating_mul(families[second].len()),
                    first,
                    second,
                )
            })
            .expect("nine families have a pair");
        let indexes: Vec<FxHashMap<[u8; 9], u16>> = families
            .iter()
            .map(|family| {
                let mut index =
                    FxHashMap::with_capacity_and_hasher(family.len(), Default::default());
                for (candidate_index, candidate) in family.iter().enumerate() {
                    index
                        .entry(candidate.coefficients)
                        .or_insert(candidate_index as u16);
                }
                index
            })
            .collect();
        let mut candidates_examined = 0u64;
        for (first_index, &first) in families[first_slot].iter().enumerate() {
            for (second_index, &second) in families[second_slot].iter().enumerate() {
                candidates_examined += 1;
                let carrier = self
                    .reconstruct_carrier_from_fibers(first, second)
                    .expect("validated family values are distinct");
                let mut indices = [0u16; 9];
                indices[first_slot] = first_index as u16;
                indices[second_slot] = second_index as u16;
                let mut valid = true;
                for slot in 0..9 {
                    if slot == first_slot || slot == second_slot {
                        continue;
                    }
                    let expected = self.high_fiber_coefficients(&carrier, families[slot][0].value);
                    let Some(&index) = indexes[slot].get(&expected) else {
                        valid = false;
                        break;
                    };
                    indices[slot] = index;
                }
                if valid {
                    return Ok(Some(BalancedSeedWitness {
                        candidates_examined,
                        carrier,
                        candidate_indices: indices,
                        seed_slots: [first_slot as u8, second_slot as u8],
                        _reserved: [0; 4],
                    }));
                }
            }
        }
        Ok(None)
    }

    /// Solves the 18 carrier coefficients from high-incidence cells `(x,y)`.
    pub fn carrier_from_high_cells(&self, cells: &[(u8, u8)]) -> Option<CarrierCellSolve> {
        if cells.iter().any(|&(x, y)| x == 0 || x >= Q || y >= Q) {
            return None;
        }
        let mut rows = [[0u8; 19]; 18];
        let mut pivots = [u8::MAX; 18];
        let mut rank = 0usize;
        for &(x, y) in cells {
            let mut equation = [0u8; 19];
            let mut power = 1u8;
            for degree in 0..9 {
                equation[degree] = self.multiply(2, self.multiply(y, power));
                equation[9 + degree] = power;
                power = self.multiply(power, x);
            }
            equation[18] = self.multiply(2, self.multiply(y, y));
            for index in 0..rank {
                let coefficient = equation[pivots[index] as usize];
                if coefficient != 0 {
                    for (entry, &row_entry) in equation.iter_mut().zip(&rows[index]) {
                        *entry = self.add(
                            *entry,
                            self.multiply(2, self.multiply(coefficient, row_entry)),
                        );
                    }
                }
            }
            let Some(pivot) = equation[..18].iter().position(|&entry| entry != 0) else {
                if equation[18] != 0 {
                    return Some(CarrierCellSolve {
                        carrier: None,
                        rank: rank as u8,
                        consistent: false,
                    });
                }
                continue;
            };
            let inverse = self.inverse(equation[pivot]);
            for entry in &mut equation {
                *entry = self.multiply(*entry, inverse);
            }
            for row in rows.iter_mut().take(rank) {
                let coefficient = row[pivot];
                if coefficient != 0 {
                    for (entry, &new_entry) in row.iter_mut().zip(&equation) {
                        *entry = self.add(
                            *entry,
                            self.multiply(2, self.multiply(coefficient, new_entry)),
                        );
                    }
                }
            }
            let position = pivots[..rank].partition_point(|&old| old < pivot as u8);
            rows[position..=rank].rotate_right(1);
            pivots[position..=rank].rotate_right(1);
            rows[position] = equation;
            pivots[position] = pivot as u8;
            rank += 1;
        }
        let carrier = (rank == 18).then(|| {
            let mut solution = [0u8; 18];
            for index in 0..rank {
                solution[pivots[index] as usize] = rows[index][18];
            }
            let mut trace = [0; 9];
            let mut product = [0; 9];
            trace.copy_from_slice(&solution[..9]);
            product.copy_from_slice(&solution[9..]);
            BalancedCarrierCoefficients {
                trace,
                product,
                _reserved: [0; 14],
            }
        });
        Some(CarrierCellSolve {
            carrier,
            rank: rank as u8,
            consistent: true,
        })
    }

    fn high_cell_equation(&self, x: u8, y: u8) -> Option<[u8; 19]> {
        if x == 0 || x >= Q || y >= Q {
            return None;
        }
        let mut equation = [0u8; 19];
        let mut power = 1u8;
        for degree in 0..9 {
            equation[degree] = self.multiply(2, self.multiply(y, power));
            equation[9 + degree] = power;
            power = self.multiply(power, x);
        }
        equation[18] = self.multiply(2, self.multiply(y, y));
        Some(equation)
    }

    /// Transactionally appends one independent cell equation without
    /// modifying older rows; `pop_independent` is therefore constant-time.
    pub fn push_high_cell(
        &self,
        basis: &mut CarrierEquationBasis,
        x: u8,
        y: u8,
    ) -> Option<CarrierEquationPush> {
        let mut equation = self.high_cell_equation(x, y)?;
        for index in 0..basis.rank as usize {
            let coefficient = equation[basis.pivots[index] as usize];
            if coefficient != 0 {
                for (entry, &row_entry) in equation.iter_mut().zip(&basis.rows[index]) {
                    *entry = self.add(
                        *entry,
                        self.multiply(2, self.multiply(coefficient, row_entry)),
                    );
                }
            }
        }
        let Some(pivot) = equation[..18].iter().position(|&entry| entry != 0) else {
            return Some(if equation[18] == 0 {
                CarrierEquationPush::Dependent
            } else {
                CarrierEquationPush::Inconsistent
            });
        };
        let inverse = self.inverse(equation[pivot]);
        for entry in &mut equation {
            *entry = self.multiply(*entry, inverse);
        }
        let rank = basis.rank as usize;
        basis.rows[rank] = equation;
        basis.pivots[rank] = pivot as u8;
        basis.rank += 1;
        Some(CarrierEquationPush::Independent)
    }

    pub fn carrier_from_equation_basis(
        &self,
        basis: &CarrierEquationBasis,
    ) -> Option<BalancedCarrierCoefficients> {
        if basis.rank != 18 {
            return None;
        }
        let mut solution = [0u8; 18];
        for index in (0..18).rev() {
            let row = &basis.rows[index];
            let pivot = basis.pivots[index] as usize;
            let mut value = row[18];
            for variable in 0..18 {
                if variable != pivot && row[variable] != 0 && solution[variable] != 0 {
                    value = self.add(
                        value,
                        self.multiply(2, self.multiply(row[variable], solution[variable])),
                    );
                }
            }
            solution[pivot] = value;
        }
        let mut trace = [0; 9];
        let mut product = [0; 9];
        trace.copy_from_slice(&solution[..9]);
        product.copy_from_slice(&solution[9..]);
        Some(BalancedCarrierCoefficients {
            trace,
            product,
            _reserved: [0; 14],
        })
    }

    /// Returns the full terminal affine family when its dimension is at most
    /// one.  Rank below 17 is deliberately left unresolved.
    pub fn carrier_affine_family(
        &self,
        basis: &CarrierEquationBasis,
    ) -> Option<CarrierAffineFamily> {
        if basis.rank < 17 {
            return None;
        }
        let free_variable = if basis.rank == 17 {
            (0..18).find(|variable| !basis.pivots[..17].contains(&(*variable as u8)))
        } else {
            None
        };
        let solve = |free_value: u8| {
            let mut solution = [0u8; 18];
            if let Some(variable) = free_variable {
                solution[variable] = free_value;
            }
            for index in (0..basis.rank as usize).rev() {
                let row = &basis.rows[index];
                let pivot = basis.pivots[index] as usize;
                let mut value = row[18];
                for variable in 0..18 {
                    if variable != pivot && row[variable] != 0 && solution[variable] != 0 {
                        value = self.add(
                            value,
                            self.multiply(2, self.multiply(row[variable], solution[variable])),
                        );
                    }
                }
                solution[pivot] = value;
            }
            let mut trace = [0; 9];
            let mut product = [0; 9];
            trace.copy_from_slice(&solution[..9]);
            product.copy_from_slice(&solution[9..]);
            BalancedCarrierCoefficients {
                trace,
                product,
                _reserved: [0; 14],
            }
        };
        let origin = solve(0);
        let direction = free_variable.map(|_| {
            let unit = solve(1);
            let mut trace = [0; 9];
            let mut product = [0; 9];
            for index in 0..9 {
                trace[index] = self.add(unit.trace[index], self.multiply(2, origin.trace[index]));
                product[index] =
                    self.add(unit.product[index], self.multiply(2, origin.product[index]));
            }
            BalancedCarrierCoefficients {
                trace,
                product,
                _reserved: [0; 14],
            }
        });
        Some(CarrierAffineFamily { origin, direction })
    }

    pub fn carrier_affine_member(
        &self,
        family: CarrierAffineFamily,
        parameter: u8,
    ) -> Option<BalancedCarrierCoefficients> {
        if parameter >= Q {
            return None;
        }
        let Some(direction) = family.direction else {
            return (parameter == 0).then_some(family.origin);
        };
        let mut carrier = family.origin;
        for index in 0..9 {
            carrier.trace[index] = self.add(
                carrier.trace[index],
                self.multiply(parameter, direction.trace[index]),
            );
            carrier.product[index] = self.add(
                carrier.product[index],
                self.multiply(parameter, direction.product[index]),
            );
        }
        Some(carrier)
    }

    /// Replays every field-level gate at a rank-17/18 DFS terminal.
    pub fn check_balanced_terminal(
        &self,
        ratio_case: usize,
        mapping_index: usize,
        spec: &HighFiberSpec,
        carrier: BalancedCarrierCoefficients,
    ) -> Result<BalancedTerminalWitness, BalancedTerminalRejection> {
        let mapping = self
            .mappings(ratio_case)
            .and_then(|mappings| mappings.get(mapping_index))
            .ok_or(BalancedTerminalRejection::TaskIndex)?;

        let mut y_counts = [0u8; 27];
        let mut t_counts = [0u8; 27];
        let mut ratio_counts = [0u8; 27];
        let mut fourth_witt_sum = 0u8;
        for x in 1..Q {
            let u = self.frobenius[self.frobenius[x as usize] as usize];
            let trace = self.evaluate_polynomial(&carrier.trace, x);
            let product = self.evaluate_polynomial(&carrier.product, x);
            let mut roots = [0u8; 2];
            let mut root_count = 0usize;
            for y in 0..Q {
                let value = self.add(
                    self.add(
                        self.multiply(y, y),
                        self.multiply(2, self.multiply(trace, y)),
                    ),
                    product,
                );
                if value == 0 {
                    if root_count < roots.len() {
                        roots[root_count] = y;
                    }
                    root_count += 1;
                }
            }
            if root_count != 2 {
                return Err(BalancedTerminalRejection::CarrierDoesNotSplit);
            }
            for y in roots {
                let t = self.add(y, u);
                let ratio = self.multiply(t, self.inverse(u));
                y_counts[y as usize] += 1;
                t_counts[t as usize] += 1;
                ratio_counts[ratio as usize] += 1;
                fourth_witt_sum = self.add(
                    fourth_witt_sum,
                    self.witt4_weight(ratio_case, u, t)
                        .ok_or(BalancedTerminalRejection::TaskIndex)?,
                );
            }
        }

        let mut expected_y = [1u8; 27];
        expected_y[0] = 2;
        for &value in &mapping.columns {
            expected_y[value as usize] = 0;
        }
        for (slot, &value) in spec.values.iter().enumerate() {
            expected_y[value as usize] = spec.target_counts[slot];
        }
        if y_counts != expected_y {
            return Err(BalancedTerminalRejection::HighFiberProfile);
        }

        for index in 0..3 {
            if self.evaluate_polynomial(&carrier.trace, mapping.row_cubes[index])
                == mapping.forbidden_a[index]
            {
                return Err(BalancedTerminalRejection::MappingCellPresent);
            }
        }

        let mut expected_t = [2u8; 27];
        expected_t[0] = 3;
        for &value in &mapping.columns {
            expected_t[value as usize] = 1;
        }
        if t_counts != expected_t {
            return Err(BalancedTerminalRejection::UnshiftedNorm);
        }

        let mut expected_ratio = [2u8; 27];
        expected_ratio[0] = 3;
        for &value in &mapping.ratios {
            expected_ratio[value as usize] = 1;
        }
        if ratio_counts != expected_ratio {
            return Err(BalancedTerminalRejection::ReciprocalNorm);
        }

        let top_trace = [
            carrier.trace[5],
            carrier.trace[6],
            carrier.trace[7],
            carrier.trace[8],
        ];
        if self.witt4_coefficient_gate(ratio_case, top_trace) != Some(fourth_witt_sum) {
            return Err(BalancedTerminalRejection::FourthWitt);
        }
        Ok(BalancedTerminalWitness {
            carrier,
            ratio_case: ratio_case as u8,
            mapping_index: mapping_index as u16,
            high_values: spec.values,
            cubic_count: spec.cubic_count,
        })
    }

    #[inline]
    fn evaluate_polynomial(&self, coefficients: &[u8; 9], x: u8) -> u8 {
        coefficients.iter().rev().fold(0, |value, &coefficient| {
            self.add(self.multiply(value, x), coefficient)
        })
    }

    /// Writes indices of mappings passing the three-evaluation completion-cell
    /// avoidance gate. `a_by_x[x]` is the carrier value `A(x)`.
    ///
    /// The caller owns the output buffer so repeated solver nodes allocate
    /// nothing.  A full case has exactly 530 mappings.
    pub fn cell_avoiding_indices(
        &self,
        ratio_case: usize,
        a_by_x: &[u8; 27],
        output: &mut [u16; 530],
    ) -> Option<usize> {
        let mappings = self.mappings(ratio_case)?;
        let mut output_len = 0usize;
        for (mapping_index, mapping) in mappings.iter().enumerate() {
            let mut allowed = true;
            for index in 0..3 {
                allowed &= a_by_x[mapping.row_cubes[index] as usize] != mapping.forbidden_a[index];
            }
            if allowed {
                output[output_len] = mapping_index as u16;
                output_len += 1;
            }
        }
        Some(output_len)
    }

    /// The same gate after the full semilinear mapping quotient.
    ///
    /// This is lossless only when the carrier is canonicalized under the same
    /// Frobenius action. For a fixed unquotiented carrier, use
    /// [`Self::cell_avoiding_indices`].
    pub fn cell_avoiding_representatives(
        &self,
        ratio_case: usize,
        a_by_x: &[u8; 27],
        output: &mut [u16; 530],
    ) -> Option<usize> {
        let mappings = self.mappings(ratio_case)?;
        let representatives = self.work_items(ratio_case)?;
        if representatives.len() == mappings.len() {
            return self.cell_avoiding_indices(ratio_case, a_by_x, output);
        }
        let mut output_len = 0usize;
        for item in representatives {
            let mapping = &mappings[item.mapping_index as usize];
            let mut allowed = true;
            for index in 0..3 {
                allowed &= a_by_x[mapping.row_cubes[index] as usize] != mapping.forbidden_a[index];
            }
            if allowed {
                output[output_len] = item.mapping_index;
                output_len += 1;
            }
        }
        Some(output_len)
    }

    /// Transports a normalized mapping through a power of ternary Frobenius.
    /// This expands a representative witness back to every member of its
    /// semilinear orbit without rebuilding the catalogue.
    pub fn frobenius_image(&self, mapping: TransversalMapping, power: u8) -> TransversalMapping {
        frobenius_image_with_table(mapping, power, &self.frobenius)
    }

    /// Transports the evaluation table by `A'(x^(3^j))=A(x)^(3^j)`.
    pub fn frobenius_carrier_evaluations(&self, values: &[u8; 27], power: u8) -> [u8; 27] {
        let mut result = *values;
        for _ in 0..power % 3 {
            let previous = result;
            for (x, &value) in previous.iter().enumerate() {
                result[self.frobenius[x] as usize] = self.frobenius[value as usize];
            }
        }
        result
    }

    #[inline]
    fn add(&self, left: u8, right: u8) -> u8 {
        self.field_add[left as usize * 27 + right as usize]
    }

    #[inline]
    fn multiply(&self, left: u8, right: u8) -> u8 {
        self.field_multiply[left as usize * 27 + right as usize]
    }

    #[inline]
    fn inverse(&self, value: u8) -> u8 {
        debug_assert_ne!(value, 0);
        let square = self.multiply(value, value);
        let fourth = self.multiply(square, square);
        let eighth = self.multiply(fourth, fourth);
        let sixteenth = self.multiply(eighth, eighth);
        let inverse = self.multiply(self.multiply(sixteenth, eighth), value);
        debug_assert_eq!(self.multiply(value, inverse), 1);
        inverse
    }
}

struct BalancedDfsEngine<'a> {
    catalog: &'a BalancedTransversalCatalog,
    ratio_case: usize,
    mapping_index: usize,
    spec: &'a HighFiberSpec,
    limits: BalancedDfsLimits,
    stats: BalancedDfsStats,
    cores: Vec<BalancedRejectionCore>,
    seen_carriers: FxHashSet<[u8; 18]>,
    witness: Option<BalancedTerminalWitness>,
    incomplete: bool,
}

impl BalancedTransversalCatalog {
    /// Exhausts one fixed nine-high-value carrier--mapping task.
    ///
    /// A nonzero limit can only return [`BalancedDfsStatus::Incomplete`]; it
    /// is never promoted to a finite rejection.
    pub fn search_high_incidence_spec(
        &self,
        ratio_case: usize,
        mapping_index: usize,
        spec: &HighFiberSpec,
        limits: BalancedDfsLimits,
    ) -> Result<BalancedDfsResult, BalancedDfsError> {
        let mapping = self
            .mappings(ratio_case)
            .and_then(|mappings| mappings.get(mapping_index))
            .ok_or(BalancedDfsError::TaskIndex)?;
        for (slot, &value) in spec.values.iter().enumerate() {
            let should_be_cubic = mapping.columns.contains(&value);
            if (spec.target_counts[slot] == 3) != should_be_cubic {
                return Err(BalancedDfsError::HighFiberMappingMismatch);
            }
        }
        let mut engine = BalancedDfsEngine {
            catalog: self,
            ratio_case,
            mapping_index,
            spec,
            limits,
            stats: BalancedDfsStats::default(),
            cores: Vec::new(),
            seen_carriers: FxHashSet::default(),
            witness: None,
            incomplete: false,
        };
        let mut basis = CarrierEquationBasis::default();
        let mut ledger = HighFiberLedger::default();
        let mut selected_cells = [(0u8, 0u8); 52];
        engine.search_node(&mut basis, &mut ledger, 0, &mut selected_cells, 0);
        let status = if engine.witness.is_some() {
            BalancedDfsStatus::Witness
        } else if engine.incomplete {
            BalancedDfsStatus::Incomplete
        } else {
            BalancedDfsStatus::Rejected
        };
        Ok(BalancedDfsResult {
            status,
            witness: engine.witness,
            stats: engine.stats,
            rejection_cores: engine.cores.into_boxed_slice(),
        })
    }

    /// Streams all `binom(26,9)` high-value sets for one weighted task.
    pub fn search_balanced_work_item(
        &self,
        work_ordinal: usize,
        limits: BalancedQueueLimits,
    ) -> Result<BalancedWorkDfsResult, BalancedDfsError> {
        let &work_item = self
            .all_work_items()
            .get(work_ordinal)
            .ok_or(BalancedDfsError::TaskIndex)?;
        let mapping = self
            .mappings(work_item.ratio_case as usize)
            .and_then(|mappings| mappings.get(work_item.mapping_index as usize))
            .ok_or(BalancedDfsError::TaskIndex)?;
        let mut high_values = [1, 2, 3, 4, 5, 6, 7, 8, 9];
        let mut high_sets_examined = 0u64;
        let mut stats = BalancedDfsStats::default();
        let mut cores = Vec::<BalancedRejectionCore>::new();
        loop {
            if limits.max_high_sets_per_task != 0
                && high_sets_examined >= limits.max_high_sets_per_task
            {
                return Ok(BalancedWorkDfsResult {
                    work_ordinal: work_ordinal as u16,
                    work_item,
                    status: BalancedDfsStatus::Incomplete,
                    high_sets_examined,
                    witness: None,
                    stats,
                    rejection_cores: cores.into_boxed_slice(),
                });
            }
            let cubic_mask = high_values
                .iter()
                .enumerate()
                .fold(0u16, |mask, (slot, value)| {
                    mask | (u16::from(mapping.columns.contains(value)) << slot)
                });
            let spec = HighFiberSpec::new(high_values, cubic_mask)
                .expect("combination contains nine distinct nonzero field values");
            let result = self.search_high_incidence_spec(
                work_item.ratio_case as usize,
                work_item.mapping_index as usize,
                &spec,
                limits.per_high_set,
            )?;
            high_sets_examined += 1;
            merge_dfs_stats(&mut stats, &result.stats);
            merge_rejection_cores(&mut cores, &result.rejection_cores);
            if let Some(witness) = result.witness {
                return Ok(BalancedWorkDfsResult {
                    work_ordinal: work_ordinal as u16,
                    work_item,
                    status: BalancedDfsStatus::Witness,
                    high_sets_examined,
                    witness: Some(witness),
                    stats,
                    rejection_cores: cores.into_boxed_slice(),
                });
            }
            if result.status == BalancedDfsStatus::Incomplete {
                return Ok(BalancedWorkDfsResult {
                    work_ordinal: work_ordinal as u16,
                    work_item,
                    status: BalancedDfsStatus::Incomplete,
                    high_sets_examined,
                    witness: None,
                    stats,
                    rejection_cores: cores.into_boxed_slice(),
                });
            }
            if !next_nine_subset(&mut high_values) {
                break;
            }
        }
        debug_assert_eq!(high_sets_examined, 3_124_550);
        Ok(BalancedWorkDfsResult {
            work_ordinal: work_ordinal as u16,
            work_item,
            status: BalancedDfsStatus::Rejected,
            high_sets_examined,
            witness: None,
            stats,
            rejection_cores: cores.into_boxed_slice(),
        })
    }

    /// Runs the exact weighted 714-task queue sequentially.  Limits preserve
    /// a three-way result: no cutoff can become `Rejected`.
    pub fn search_balanced_work_queue(
        &self,
        limits: BalancedQueueLimits,
    ) -> Result<BalancedQueueDfsResult, BalancedDfsError> {
        let task_cap = if limits.max_tasks == 0 {
            self.all_work_items().len()
        } else {
            usize::from(limits.max_tasks).min(self.all_work_items().len())
        };
        let mut tasks = Vec::with_capacity(task_cap);
        for work_ordinal in 0..task_cap {
            let result = self.search_balanced_work_item(work_ordinal, limits)?;
            let status = result.status;
            tasks.push(result);
            if status != BalancedDfsStatus::Rejected {
                return Ok(BalancedQueueDfsResult {
                    status,
                    tasks: tasks.into_boxed_slice(),
                });
            }
        }
        Ok(BalancedQueueDfsResult {
            status: if task_cap == self.all_work_items().len() {
                BalancedDfsStatus::Rejected
            } else {
                BalancedDfsStatus::Incomplete
            },
            tasks: tasks.into_boxed_slice(),
        })
    }
}

fn next_nine_subset(values: &mut [u8; 9]) -> bool {
    for index in (0..9).rev() {
        let maximum = 26 - (8 - index) as u8;
        if values[index] < maximum {
            values[index] += 1;
            for next in index + 1..9 {
                values[next] = values[next - 1] + 1;
            }
            return true;
        }
    }
    false
}

fn merge_dfs_stats(target: &mut BalancedDfsStats, source: &BalancedDfsStats) {
    target.nodes += source.nodes;
    target.terminal_carriers += source.terminal_carriers;
    target.prefix_mismatches += source.prefix_mismatches;
    target.duplicate_terminals += source.duplicate_terminals;
    target.split_mask_prunes += source.split_mask_prunes;
    target.split_parameters_removed += source.split_parameters_removed;
    target.mobius_terminal_families += source.mobius_terminal_families;
    target.inconsistent_pushes += source.inconsistent_pushes;
    target.ledger_prunes += source.ledger_prunes;
    target.rank_bound_prunes += source.rank_bound_prunes;
    target.maximum_rank = target.maximum_rank.max(source.maximum_rank);
    for (target_count, source_count) in target
        .rejection_counts
        .iter_mut()
        .zip(source.rejection_counts)
    {
        *target_count += source_count;
    }
}

fn merge_rejection_cores(
    target: &mut Vec<BalancedRejectionCore>,
    source: &[BalancedRejectionCore],
) {
    for core in source {
        if let Some(existing) = target
            .iter_mut()
            .find(|candidate| candidate.category == core.category)
        {
            let core_key = (
                core.cells.len() + core.discriminant_rows.len(),
                core.cells.len(),
                core.kappa,
                core.mapping_key,
                core.high_values,
                &core.discriminant_rows[..],
                &core.cells[..],
            );
            let existing_key = (
                existing.cells.len() + existing.discriminant_rows.len(),
                existing.cells.len(),
                existing.kappa,
                existing.mapping_key,
                existing.high_values,
                &existing.discriminant_rows[..],
                &existing.cells[..],
            );
            if core_key < existing_key {
                *existing = core.clone();
            }
        } else {
            target.push(core.clone());
        }
    }
    target.sort_by_key(|core| core.category as u8);
}

impl BalancedDfsEngine<'_> {
    fn search_node(
        &mut self,
        basis: &mut CarrierEquationBasis,
        ledger: &mut HighFiberLedger,
        processed_rows: u32,
        selected_cells: &mut [(u8, u8); 52],
        selected_len: usize,
    ) {
        if self.witness.is_some() || self.incomplete {
            return;
        }
        if self.limits.max_nodes != 0 && self.stats.nodes >= self.limits.max_nodes {
            self.incomplete = true;
            return;
        }
        self.stats.nodes += 1;
        self.stats.maximum_rank = self.stats.maximum_rank.max(basis.rank);

        if basis.rank >= 17 {
            self.check_affine_terminal(basis, processed_rows, &selected_cells[..selected_len]);
            return;
        }
        if processed_rows == (1u32 << 26) - 1 {
            if ledger.is_complete(self.spec) {
                self.stats.rank_bound_prunes += 1;
                self.stats.rejection_counts
                    [BalancedTerminalRejection::TerminalRankBound as usize] += 1;
                self.record_rank_core(&selected_cells[..selected_len]);
            } else {
                self.stats.ledger_prunes += 1;
            }
            return;
        }

        let mut best_x = 0u8;
        let mut best_count = usize::MAX;
        let mut best_rank_gain = 0u8;
        let mut probe_choices = [IncidenceRowChoice::default(); 46];
        for x in 1..Q {
            if processed_rows & (1 << (x - 1)) != 0 {
                continue;
            }
            let count = self.row_choices(basis, ledger, x, &mut probe_choices);
            if count == 0 {
                self.stats.ledger_prunes += 1;
                return;
            }
            let maximum_gain = probe_choices[..count]
                .iter()
                .map(|choice| choice.rank_gain)
                .max()
                .unwrap_or(0);
            if count < best_count || (count == best_count && maximum_gain > best_rank_gain) {
                best_x = x;
                best_count = count;
                best_rank_gain = maximum_gain;
            }
        }

        let mut choices = [IncidenceRowChoice::default(); 46];
        let choice_count = self.row_choices(basis, ledger, best_x, &mut choices);
        choices[..choice_count].sort_unstable_by(|left, right| {
            right
                .rank_gain
                .cmp(&left.rank_gain)
                .then_with(|| right.count.cmp(&left.count))
                .then_with(|| left.values.cmp(&right.values))
        });
        for choice in choices[..choice_count].iter().copied() {
            if self.witness.is_some() || self.incomplete {
                break;
            }
            let rank_before = basis.rank;
            let ledger_before = *ledger;
            let mut consistent = true;
            for &value in choice.values.iter().take(choice.count as usize) {
                match self.catalog.push_high_cell(basis, best_x, value) {
                    Some(CarrierEquationPush::Independent | CarrierEquationPush::Dependent) => {}
                    Some(CarrierEquationPush::Inconsistent) | None => {
                        self.stats.inconsistent_pushes += 1;
                        consistent = false;
                        break;
                    }
                }
            }
            if consistent && ledger.try_push_high_values(self.spec, choice.values, choice.count) {
                let mut next_len = selected_len;
                for &value in choice.values.iter().take(choice.count as usize) {
                    selected_cells[next_len] = (best_x, value);
                    next_len += 1;
                }
                self.search_node(
                    basis,
                    ledger,
                    processed_rows | (1 << (best_x - 1)),
                    selected_cells,
                    next_len,
                );
            } else if consistent {
                self.stats.ledger_prunes += 1;
            }
            while basis.rank > rank_before {
                assert!(basis.pop_independent());
            }
            *ledger = ledger_before;
        }
    }

    fn row_choices(
        &mut self,
        basis: &mut CarrierEquationBasis,
        ledger: &HighFiberLedger,
        x: u8,
        output: &mut [IncidenceRowChoice; 46],
    ) -> usize {
        let mut allowed = 0u16;
        let mut required = 0u16;
        for (slot, &value) in self.spec.values.iter().enumerate() {
            let rank_before = basis.rank;
            match self.catalog.push_high_cell(basis, x, value) {
                Some(CarrierEquationPush::Independent) => {
                    allowed |= 1 << slot;
                    assert!(basis.pop_independent());
                }
                Some(CarrierEquationPush::Dependent) => {
                    allowed |= 1 << slot;
                    required |= 1 << slot;
                }
                Some(CarrierEquationPush::Inconsistent) | None => {
                    self.stats.inconsistent_pushes += 1;
                }
            }
            debug_assert_eq!(basis.rank, rank_before);
        }
        if required.count_ones() > 2 {
            return 0;
        }
        let mut output_len = 0usize;
        for subset in 0u16..(1 << 9) {
            if subset & !allowed != 0 || subset & required != required || subset.count_ones() > 2 {
                continue;
            }
            let mut values = [0u8; 2];
            let mut count = 0u8;
            for (slot, &value) in self.spec.values.iter().enumerate() {
                if subset & (1 << slot) != 0 {
                    values[count as usize] = value;
                    count += 1;
                }
            }
            let mut ledger_probe = *ledger;
            if !ledger_probe.try_push_high_values(self.spec, values, count) {
                continue;
            }
            let rank_before = basis.rank;
            let mut valid = true;
            for &value in values.iter().take(count as usize) {
                if self.catalog.push_high_cell(basis, x, value)
                    == Some(CarrierEquationPush::Inconsistent)
                {
                    valid = false;
                    break;
                }
            }
            let rank_gain = basis.rank - rank_before;
            while basis.rank > rank_before {
                assert!(basis.pop_independent());
            }
            if valid {
                output[output_len] = IncidenceRowChoice {
                    values,
                    count,
                    rank_gain,
                };
                output_len += 1;
            }
        }
        output_len
    }

    fn check_affine_terminal(
        &mut self,
        basis: &CarrierEquationBasis,
        processed_rows: u32,
        selected_cells: &[(u8, u8)],
    ) {
        let family = self
            .catalog
            .carrier_affine_family(basis)
            .expect("rank-17/18 basis has an affine terminal family");
        let parameter_count = if family.direction.is_some() { 27 } else { 1 };
        if parameter_count == 27 {
            self.stats.mobius_terminal_families += 1;
        }
        let (split_parameters, discriminant_rows) = self.split_parameter_mask(family);
        self.stats.split_parameters_removed +=
            u64::from(parameter_count) - u64::from(split_parameters.count_ones());
        if split_parameters == 0 {
            self.stats.split_mask_prunes += 1;
            self.stats.rejection_counts
                [BalancedTerminalRejection::MobiusDiscriminantEmpty as usize] += 1;
            self.record_split_core(selected_cells, &discriminant_rows);
            return;
        }
        for parameter in 0..parameter_count {
            if split_parameters & (1 << parameter) == 0 {
                continue;
            }
            if self.limits.max_terminal_carriers != 0
                && self.stats.terminal_carriers >= self.limits.max_terminal_carriers
            {
                self.incomplete = true;
                return;
            }
            self.stats.terminal_carriers += 1;
            let carrier = self
                .catalog
                .carrier_affine_member(family, parameter)
                .expect("terminal parameter is in GF(27)");
            if !self.carrier_matches_prefix(carrier, processed_rows, selected_cells) {
                self.stats.prefix_mismatches += 1;
                continue;
            }
            let mut carrier_key = [0u8; 18];
            carrier_key[..9].copy_from_slice(&carrier.trace);
            carrier_key[9..].copy_from_slice(&carrier.product);
            if !self.seen_carriers.insert(carrier_key) {
                self.stats.duplicate_terminals += 1;
                continue;
            }
            match self.catalog.check_balanced_terminal(
                self.ratio_case,
                self.mapping_index,
                self.spec,
                carrier,
            ) {
                Ok(witness) => {
                    self.witness = Some(witness);
                    return;
                }
                Err(category) => {
                    self.stats.rejection_counts[category as usize] += 1;
                    self.record_terminal_core(category, selected_cells);
                }
            }
        }
    }

    fn split_parameter_mask(&self, family: CarrierAffineFamily) -> (u32, Vec<u8>) {
        let parameter_count = if family.direction.is_some() { 27 } else { 1 };
        let full_mask = (1u32 << parameter_count) - 1;
        let mut row_masks = [(0u8, 0u32); 26];
        for x in 1..Q {
            let mut mask = 0u32;
            for parameter in 0..parameter_count {
                let carrier = self
                    .catalog
                    .carrier_affine_member(family, parameter as u8)
                    .expect("split-mask parameter is in GF(27)");
                let trace = self.catalog.evaluate_polynomial(&carrier.trace, x);
                let product = self.catalog.evaluate_polynomial(&carrier.product, x);
                let discriminant = self.catalog.add(
                    self.catalog.multiply(trace, trace),
                    self.catalog.multiply(2, product),
                );
                if self.catalog.nonzero_square[discriminant as usize] {
                    mask |= 1 << parameter;
                }
            }
            row_masks[(x - 1) as usize] = (x, mask);
        }
        let intersection = row_masks
            .iter()
            .fold(full_mask, |mask, (_, row_mask)| mask & row_mask);
        if intersection != 0 {
            return (intersection, Vec::new());
        }
        let mut rows = row_masks.to_vec();
        let mut index = rows.len();
        while index > 0 {
            index -= 1;
            let intersection_without = rows
                .iter()
                .enumerate()
                .filter(|(other, _)| *other != index)
                .fold(full_mask, |mask, (_, (_, row_mask))| mask & row_mask);
            if intersection_without == 0 {
                rows.remove(index);
            }
        }
        (0, rows.into_iter().map(|(x, _)| x).collect())
    }

    fn record_split_core(&mut self, selected_cells: &[(u8, u8)], rows: &[u8]) {
        let category = BalancedTerminalRejection::MobiusDiscriminantEmpty;
        if self.cores.iter().any(|core| {
            core.category == category && core.cells.len() == 17 && core.discriminant_rows.len() == 1
        }) {
            return;
        }
        let mut core = selected_cells.to_vec();
        let mut discriminant_rows = rows.to_vec();
        let mut index = core.len();
        while index > 0 {
            index -= 1;
            let removed = core.remove(index);
            let mut basis = CarrierEquationBasis::default();
            let mut consistent = true;
            for &(x, y) in &core {
                if self.catalog.push_high_cell(&mut basis, x, y)
                    == Some(CarrierEquationPush::Inconsistent)
                {
                    consistent = false;
                    break;
                }
            }
            let replacement_rows = if consistent {
                self.catalog
                    .carrier_affine_family(&basis)
                    .and_then(|family| {
                        let (mask, rows) = self.split_parameter_mask(family);
                        (mask == 0).then_some(rows)
                    })
            } else {
                None
            };
            if let Some(rows) = replacement_rows {
                discriminant_rows = rows;
            } else {
                core.insert(index, removed);
            }
        }
        let (kappa, key, high_values) = self.canonicalize_core(&mut core, &mut discriminant_rows);
        let new_key = (
            core.len() + discriminant_rows.len(),
            core.len(),
            &discriminant_rows[..],
            &core[..],
        );
        let replace = self
            .cores
            .iter()
            .find(|entry| entry.category == category)
            .is_none_or(|entry| {
                new_key
                    < (
                        entry.cells.len() + entry.discriminant_rows.len(),
                        entry.cells.len(),
                        &entry.discriminant_rows[..],
                        &entry.cells[..],
                    )
            });
        if replace {
            self.cores.retain(|entry| entry.category != category);
            self.cores.push(BalancedRejectionCore {
                category,
                kappa,
                mapping_key: key,
                high_values,
                cubic_count: self.spec.cubic_count,
                discriminant_rows: discriminant_rows.into_boxed_slice(),
                cells: core.into_boxed_slice(),
            });
            self.cores.sort_by_key(|entry| entry.category as u8);
        }
    }

    fn carrier_matches_prefix(
        &self,
        carrier: BalancedCarrierCoefficients,
        processed_rows: u32,
        selected_cells: &[(u8, u8)],
    ) -> bool {
        for x in 1..Q {
            if processed_rows & (1 << (x - 1)) == 0 {
                continue;
            }
            let trace = self.catalog.evaluate_polynomial(&carrier.trace, x);
            let product = self.catalog.evaluate_polynomial(&carrier.product, x);
            let mut actual = [0u8; 2];
            let mut actual_count = 0usize;
            let mut total_roots = 0usize;
            for y in 0..Q {
                let value = self.catalog.add(
                    self.catalog.add(
                        self.catalog.multiply(y, y),
                        self.catalog.multiply(2, self.catalog.multiply(trace, y)),
                    ),
                    product,
                );
                if value == 0 {
                    total_roots += 1;
                    if self.spec.value_to_slot[y as usize] != u8::MAX {
                        if actual_count < actual.len() {
                            actual[actual_count] = y;
                        }
                        actual_count += 1;
                    }
                }
            }
            // A nonsplit row is a genuine terminal rejection, not a prefix
            // mismatch, so let the ordered terminal checker classify it.
            if total_roots != 2 {
                return true;
            }
            let mut expected = [0u8; 2];
            let mut expected_count = 0usize;
            for &(cell_x, cell_y) in selected_cells {
                if cell_x == x {
                    expected[expected_count] = cell_y;
                    expected_count += 1;
                }
            }
            actual[..actual_count].sort_unstable();
            expected[..expected_count].sort_unstable();
            if actual_count != expected_count
                || actual[..actual_count] != expected[..expected_count]
            {
                return false;
            }
        }
        true
    }

    fn record_terminal_core(
        &mut self,
        category: BalancedTerminalRejection,
        selected_cells: &[(u8, u8)],
    ) {
        let current_best = self
            .cores
            .iter()
            .find(|core| core.category == category)
            .map_or(usize::MAX, |core| core.cells.len());
        if current_best == 17 {
            return;
        }
        let mut core = selected_cells.to_vec();
        let mut index = core.len();
        while index > 0 {
            index -= 1;
            let removed = core.remove(index);
            if !self.core_forces_category(&core, category) {
                core.insert(index, removed);
            }
        }
        // A rank-18 subbasis already reconstructs the same unique carrier.
        // If deletion reaches rank 17, all 27 members must fail this same
        // gate.  Hence an inclusion-minimal terminal core cannot be larger.
        debug_assert!(core.len() <= 18);
        let mut discriminant_rows = Vec::new();
        let (kappa, key, high_values) = self.canonicalize_core(&mut core, &mut discriminant_rows);
        if let Some(existing) = self
            .cores
            .iter_mut()
            .find(|entry| entry.category == category)
        {
            if core.len() < existing.cells.len()
                || (core.len() == existing.cells.len() && core.as_slice() < &existing.cells[..])
            {
                existing.cells = core.into_boxed_slice();
                existing.kappa = kappa;
                existing.mapping_key = key;
                existing.high_values = high_values;
                existing.cubic_count = self.spec.cubic_count;
                existing.discriminant_rows = discriminant_rows.into_boxed_slice();
            }
        } else {
            self.cores.push(BalancedRejectionCore {
                category,
                kappa,
                mapping_key: key,
                high_values,
                cubic_count: self.spec.cubic_count,
                discriminant_rows: discriminant_rows.into_boxed_slice(),
                cells: core.into_boxed_slice(),
            });
            self.cores.sort_by_key(|entry| entry.category as u8);
        }
    }

    fn core_forces_category(
        &self,
        cells: &[(u8, u8)],
        category: BalancedTerminalRejection,
    ) -> bool {
        let mut basis = CarrierEquationBasis::default();
        for &(x, y) in cells {
            if self.catalog.push_high_cell(&mut basis, x, y)
                == Some(CarrierEquationPush::Inconsistent)
            {
                return false;
            }
        }
        let Some(family) = self.catalog.carrier_affine_family(&basis) else {
            return false;
        };
        let parameter_count = if family.direction.is_some() { 27 } else { 1 };
        (0..parameter_count).all(|parameter| {
            let carrier = self
                .catalog
                .carrier_affine_member(family, parameter)
                .expect("core parameter is in GF(27)");
            self.catalog.check_balanced_terminal(
                self.ratio_case,
                self.mapping_index,
                self.spec,
                carrier,
            ) == Err(category)
        })
    }

    fn record_rank_core(&mut self, selected_cells: &[(u8, u8)]) {
        let category = BalancedTerminalRejection::TerminalRankBound;
        let mut core = selected_cells.to_vec();
        let mut discriminant_rows = Vec::new();
        let (kappa, key, high_values) = self.canonicalize_core(&mut core, &mut discriminant_rows);
        let replace = self
            .cores
            .iter()
            .find(|entry| entry.category == category)
            .is_none_or(|entry| {
                core.len() < entry.cells.len()
                    || (core.len() == entry.cells.len() && core.as_slice() < &entry.cells[..])
            });
        if replace {
            self.cores.retain(|entry| entry.category != category);
            self.cores.push(BalancedRejectionCore {
                category,
                kappa,
                mapping_key: key,
                high_values,
                cubic_count: self.spec.cubic_count,
                discriminant_rows: discriminant_rows.into_boxed_slice(),
                cells: core.into_boxed_slice(),
            });
            self.cores.sort_by_key(|entry| entry.category as u8);
        }
    }

    fn canonicalize_core(
        &self,
        cells: &mut Vec<(u8, u8)>,
        discriminant_rows: &mut Vec<u8>,
    ) -> (u8, [u8; 9], [u8; 9]) {
        let mapping =
            self.catalog.mappings(self.ratio_case).expect("valid task")[self.mapping_index];
        cells.sort_unstable();
        discriminant_rows.sort_unstable();
        let mut image_cells = cells.clone();
        let mut image_rows = discriminant_rows.clone();
        let mut image_mapping = mapping;
        let mut image_high = self.spec.values;
        image_high.sort_unstable();
        let mut best = (
            image_mapping.kappa,
            mapping_key(image_mapping),
            image_high,
            image_rows.clone(),
            image_cells.clone(),
        );
        for _ in 0..2 {
            image_mapping = self.catalog.frobenius_image(image_mapping, 1);
            for value in &mut image_high {
                *value = self.catalog.frobenius[*value as usize];
            }
            image_high.sort_unstable();
            for x in &mut image_rows {
                *x = self.catalog.frobenius[*x as usize];
            }
            image_rows.sort_unstable();
            for (x, y) in &mut image_cells {
                *x = self.catalog.frobenius[*x as usize];
                *y = self.catalog.frobenius[*y as usize];
            }
            image_cells.sort_unstable();
            let candidate = (
                image_mapping.kappa,
                mapping_key(image_mapping),
                image_high,
                image_rows.clone(),
                image_cells.clone(),
            );
            if candidate < best {
                best = candidate;
            }
        }
        *discriminant_rows = best.3;
        *cells = best.4;
        (best.0, best.1, best.2)
    }
}

impl WittSpectralPrefix {
    pub fn try_push(&mut self, catalog: &BalancedTransversalCatalog, root: u8) -> bool {
        if self.roots_done == 54 || root >= Q {
            return false;
        }
        for degree in (1..=4).rev() {
            let previous = if degree == 1 {
                1
            } else {
                self.elementary[degree - 2]
            };
            self.elementary[degree - 1] = catalog.add(
                self.elementary[degree - 1],
                catalog.multiply(root, previous),
            );
        }
        self.roots_done += 1;
        true
    }

    pub fn is_complete(
        &self,
        catalog: &BalancedTransversalCatalog,
        ratio_case: usize,
        top_a: [u8; 4],
    ) -> bool {
        let Some(h2) = catalog.witt2_coefficient_gate(ratio_case, [top_a[2], top_a[3]]) else {
            return false;
        };
        let Some(h4) = catalog.witt4_coefficient_gate(ratio_case, top_a) else {
            return false;
        };
        let target_e4 = catalog.multiply(2, catalog.add(h4, catalog.multiply(h2, h2)));
        self.roots_done == 54
            && self.elementary[0] == 0
            && self.elementary[1] == h2
            && self.elementary[3] == target_e4
    }

    pub fn elementary(&self) -> [u8; 4] {
        self.elementary
    }
}

#[inline]
fn has_duplicate(values: [u8; 3]) -> bool {
    values[0] == values[1] || values[0] == values[2] || values[1] == values[2]
}

fn frobenius_image_with_table(
    mut mapping: TransversalMapping,
    power: u8,
    frobenius: &[u8; 27],
) -> TransversalMapping {
    for _ in 0..power % 3 {
        mapping.rows = mapping.rows.map(|value| frobenius[value as usize]);
        mapping.columns = mapping.columns.map(|value| frobenius[value as usize]);
        mapping.ratios = mapping.ratios.map(|value| frobenius[value as usize]);
        mapping.kappa = frobenius[mapping.kappa as usize];
        mapping.row_cubes = mapping.row_cubes.map(|value| frobenius[value as usize]);
        mapping.forbidden_a = mapping.forbidden_a.map(|value| frobenius[value as usize]);
    }
    mapping
}

fn mapping_key(mapping: TransversalMapping) -> [u8; 9] {
    let mut entries = std::array::from_fn::<_, 3, _>(|index| {
        (
            mapping.ratios[index],
            mapping.rows[index],
            mapping.columns[index],
        )
    });
    entries.sort_unstable();
    std::array::from_fn(|index| {
        let (ratio, row, column) = entries[index / 3];
        [ratio, row, column][index % 3]
    })
}

fn witt4_theta(field: &TernaryExtensionField, kappa: u8, u: u8, t: u8) -> u8 {
    let neg = |value| field.multiply(2, value);
    let t4 = field.pow(t, 4);
    let u3 = field.pow(u, 3);
    let ku4 = field.multiply(kappa, field.pow(u, 4));
    let one_minus_kappa = field.add(1, neg(kappa));
    let e3 = field.add(field.pow(t, 3), field.multiply(one_minus_kappa, u3));
    let e4 = field.add(
        field.add(t4, field.multiply(one_minus_kappa, field.multiply(t, u3))),
        neg(ku4),
    );
    let mut powers = [0u8; 9];
    powers[1] = t;
    powers[2] = field.pow(t, 2);
    powers[3] = field.pow(t, 3);
    powers[4] = field.add(t4, ku4);
    for exponent in 5..=8 {
        powers[exponent] = field.add(
            field.add(
                field.multiply(t, powers[exponent - 1]),
                field.multiply(e3, powers[exponent - 3]),
            ),
            neg(field.multiply(e4, powers[exponent - 4])),
        );
    }
    let e3_fourth_values = field.add(
        field.add(
            field.pow(e3, 4),
            field.multiply(field.multiply(t, e3), field.pow(e4, 2)),
        ),
        neg(field.pow(e4, 3)),
    );
    let carry_four = field.add(
        field.add(
            neg(field.multiply(powers[4], powers[8])),
            field.pow(powers[4], 3),
        ),
        e3_fourth_values,
    );
    let carry_target = neg(field.add(
        field.multiply(field.pow(t4, 2), ku4),
        field.multiply(t4, field.pow(ku4, 2)),
    ));
    field.pow(field.add(carry_four, neg(carry_target)), 9)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn q27_semilinear_ratio_and_transversal_counts_match_gf27() {
        let catalog = BalancedTransversalCatalog::q27();
        assert_eq!(catalog.ratio_fibers[0].kappa, 2);
        assert_eq!(catalog.ratio_fibers[0].frobenius_orbit, [2, 0, 0]);
        assert_eq!(catalog.ratio_fibers[0].orbit_len, 1);
        assert_eq!(catalog.ratio_fibers[1].kappa, 18);
        assert_eq!(catalog.ratio_fibers[1].frobenius_orbit, [18, 23, 26]);
        assert_eq!(catalog.ratio_fibers[1].orbit_len, 3);
        assert_eq!(catalog.mappings(0).unwrap().len(), 530);
        assert_eq!(catalog.mappings(1).unwrap().len(), 530);
        assert!(catalog.mappings(2).is_none());
    }

    #[test]
    fn every_mapping_replays_products_and_distinctness() {
        let field = TernaryExtensionField::new(Q).unwrap();
        let catalog = BalancedTransversalCatalog::q27();
        for mapping in &catalog.mappings {
            assert!(!has_duplicate(mapping.rows));
            assert!(!has_duplicate(mapping.columns));
            assert_eq!(
                field.multiply(
                    field.multiply(mapping.rows[0], mapping.rows[1]),
                    mapping.rows[2]
                ),
                1
            );
            assert_eq!(
                field.multiply(
                    field.multiply(mapping.columns[0], mapping.columns[1]),
                    mapping.columns[2]
                ),
                mapping.kappa
            );
            for index in 0..3 {
                assert_eq!(
                    mapping.columns[index],
                    field.multiply(mapping.ratios[index], mapping.rows[index])
                );
            }
        }
    }

    #[test]
    fn pair_multiplicities_match_the_semilinear_representatives() {
        let catalog = BalancedTransversalCatalog::q27();
        assert_eq!(catalog.pairs.len(), 1_058);
        assert_eq!(
            catalog
                .pairs
                .iter()
                .filter(|pair| pair.multiplicity == 1)
                .count(),
            1_056
        );
        assert_eq!(
            catalog
                .pairs
                .iter()
                .filter(|pair| pair.multiplicity == 2)
                .count(),
            2
        );
        assert_eq!(catalog.storage_bytes(), 34_052);
    }

    #[test]
    fn witt_indices_are_exactly_the_nonmultiples_of_three() {
        assert_eq!(WITT_INDEPENDENT_EXPONENTS_Q27.len(), 17);
        assert_eq!(
            WITT_INDEPENDENT_EXPONENTS_Q27.as_slice(),
            &(1u8..=25)
                .filter(|value| value % 3 != 0)
                .collect::<Vec<_>>()
        );
    }

    #[test]
    fn cell_avoidance_filter_matches_direct_three_evaluation_gate() {
        let field = TernaryExtensionField::new(Q).unwrap();
        let catalog = BalancedTransversalCatalog::q27();
        let mut a_by_x = [0u8; 27];
        for (x, value) in a_by_x.iter_mut().enumerate() {
            *value = field.add(field.pow(x as u8, 2), 1);
        }
        let mut output = [0u16; 530];
        for ratio_case in 0..2 {
            let mappings = catalog.mappings(ratio_case).unwrap();
            let count = catalog
                .cell_avoiding_indices(ratio_case, &a_by_x, &mut output)
                .unwrap();
            let expected = mappings
                .iter()
                .enumerate()
                .filter_map(|(mapping_index, mapping)| {
                    (0..3)
                        .all(|index| {
                            let row = mapping.rows[index];
                            let x = field.pow(row, 3);
                            let forbidden =
                                field.multiply(field.add(mapping.ratios[index], 2), row);
                            a_by_x[x as usize] != forbidden
                        })
                        .then_some(mapping_index as u16)
                })
                .collect::<Vec<_>>();
            assert_eq!(&output[..count], expected);
        }
        assert!(catalog
            .cell_avoiding_indices(2, &a_by_x, &mut output)
            .is_none());
    }

    #[test]
    fn witt4_lookup_covers_two_semilinear_cases_and_replays_formula() {
        let field = TernaryExtensionField::new(Q).unwrap();
        let catalog = BalancedTransversalCatalog::q27();
        let mut nonzero_weights = 0usize;
        for ratio_case in 0..2 {
            let fiber = catalog.ratio_fibers()[ratio_case];
            for t in 0..Q {
                for u in 0..Q {
                    let expected = witt4_theta(&field, fiber.kappa, u, t);
                    let actual = catalog.witt4_weight(ratio_case, u, t).unwrap();
                    assert_eq!(actual, expected);
                    nonzero_weights += usize::from(actual != 0);

                    let fourth_sum = std::iter::once(2)
                        .chain(fiber.roots)
                        .map(|slope| {
                            let linear = field.add(t, field.multiply(2, field.multiply(slope, u)));
                            field.pow(linear, 4)
                        })
                        .fold(0, |sum, value| field.add(sum, value));
                    assert_eq!(
                        fourth_sum,
                        field.add(
                            field.pow(t, 4),
                            field.multiply(fiber.kappa, field.pow(u, 4))
                        )
                    );
                }
            }
        }
        assert!(nonzero_weights > 0);
        assert!(catalog.witt4_weight(2, 0, 0).is_none());
        assert!(catalog.witt4_weight(0, Q, 0).is_none());
        assert!(catalog.witt4_weight(0, 0, Q).is_none());
    }

    #[test]
    fn collapsed_witt4_gate_matches_both_q27_coefficient_formulas() {
        let field = TernaryExtensionField::new(Q).unwrap();
        let catalog = BalancedTransversalCatalog::q27();
        assert_eq!(catalog.witt4_coefficient_weights, [[0, 2], [7, 26]]);
        for a5 in 0..Q {
            for a6 in 0..Q {
                for a7 in 0..Q {
                    for a8 in 0..Q {
                        let a5_r = field.pow(a5, 9);
                        let delta = field.add(
                            field.multiply(field.pow(a6, 9), field.pow(a8, 9)),
                            field.multiply(2, field.pow(a7, 18)),
                        );
                        assert_eq!(
                            catalog.witt4_coefficient_gate(0, [a5, a6, a7, a8]),
                            Some(field.multiply(2, delta))
                        );
                        assert_eq!(
                            catalog.witt4_coefficient_gate(1, [a5, a6, a7, a8]),
                            Some(field.add(field.multiply(7, a5_r), field.multiply(26, delta)))
                        );
                    }
                }
            }
        }
        assert!(catalog.witt4_coefficient_gate(2, [0; 4]).is_none());
        assert!(catalog.witt4_coefficient_gate(0, [0, 0, 0, Q]).is_none());
    }

    #[test]
    fn frobenius_transport_expands_and_closes_the_three_cycle() {
        let catalog = BalancedTransversalCatalog::q27();
        let mapping = catalog.mappings(1).unwrap()[0];
        let image_one = catalog.frobenius_image(mapping, 1);
        let image_two = catalog.frobenius_image(mapping, 2);
        assert_ne!(image_one.kappa, mapping.kappa);
        assert_ne!(image_two.kappa, mapping.kappa);
        assert_ne!(image_one.kappa, image_two.kappa);
        let mut kappas = [mapping.kappa, image_one.kappa, image_two.kappa];
        kappas.sort_unstable();
        assert_eq!(kappas, [18, 23, 26]);
        assert_eq!(catalog.frobenius_image(mapping, 3), mapping);
        assert_eq!(catalog.frobenius_image(mapping, 255), mapping);
    }

    #[test]
    fn fixed_ratio_fiber_quotients_to_eleven_fixed_and_173_three_cycles() {
        let catalog = BalancedTransversalCatalog::q27();
        assert_eq!(catalog.work_items(0).unwrap().len(), 184);
        assert_eq!(catalog.work_items(1).unwrap().len(), 530);
        assert!(catalog.work_items(2).is_none());

        let mappings = catalog.mappings(0).unwrap();
        let fixed = mappings
            .iter()
            .filter(|&&mapping| {
                mapping_key(mapping) == mapping_key(catalog.frobenius_image(mapping, 1))
            })
            .count();
        assert_eq!(fixed, 11);

        let representative_keys = catalog
            .work_items(0)
            .unwrap()
            .iter()
            .map(|item| mapping_key(mappings[item.mapping_index as usize]))
            .collect::<std::collections::BTreeSet<_>>();
        for &mapping in mappings {
            let canonical = [
                mapping_key(mapping),
                mapping_key(catalog.frobenius_image(mapping, 1)),
                mapping_key(catalog.frobenius_image(mapping, 2)),
            ]
            .into_iter()
            .min()
            .unwrap();
            assert!(representative_keys.contains(&canonical));
        }
    }

    #[test]
    fn representative_cell_filter_is_an_exact_subscan() {
        let catalog = BalancedTransversalCatalog::q27();
        let a_by_x = std::array::from_fn(|index| ((index * index + 1) % 27) as u8);
        let mut full = [0u16; 530];
        let mut reduced = [0u16; 530];
        for ratio_case in 0..2 {
            let full_count = catalog
                .cell_avoiding_indices(ratio_case, &a_by_x, &mut full)
                .unwrap();
            let reduced_count = catalog
                .cell_avoiding_representatives(ratio_case, &a_by_x, &mut reduced)
                .unwrap();
            let full_set = full[..full_count]
                .iter()
                .copied()
                .collect::<std::collections::BTreeSet<_>>();
            assert!(reduced[..reduced_count]
                .iter()
                .all(|index| full_set.contains(index)));
            assert!(reduced_count <= catalog.work_items(ratio_case).unwrap().len());
        }
    }

    #[test]
    fn cell_avoidance_is_equivariant_under_joint_frobenius_transport() {
        let catalog = BalancedTransversalCatalog::q27();
        let a_by_x = std::array::from_fn(|index| ((index * index + 1) % 27) as u8);
        for ratio_case in 0..2 {
            for &mapping in catalog.mappings(ratio_case).unwrap() {
                let allowed = (0..3).all(|index| {
                    a_by_x[mapping.row_cubes[index] as usize] != mapping.forbidden_a[index]
                });
                for power in 1..=2 {
                    let image = catalog.frobenius_image(mapping, power);
                    let image_a = catalog.frobenius_carrier_evaluations(&a_by_x, power);
                    let image_allowed = (0..3).all(|index| {
                        image_a[image.row_cubes[index] as usize] != image.forbidden_a[index]
                    });
                    assert_eq!(image_allowed, allowed);
                }
            }
        }
    }

    #[test]
    fn weighted_work_queue_covers_every_normalized_mapping_once() {
        let catalog = BalancedTransversalCatalog::q27();
        let work = catalog.all_work_items();
        assert_eq!(work.len(), 714);
        assert_eq!(
            work.iter()
                .map(|item| usize::from(item.orbit_size))
                .sum::<usize>(),
            2_120
        );
        assert_eq!(work.iter().filter(|item| item.orbit_size == 1).count(), 11);
        assert_eq!(work.iter().filter(|item| item.orbit_size == 3).count(), 703);
        assert_eq!(work.iter().filter(|item| item.ratio_case == 0).count(), 184);
        assert_eq!(work.iter().filter(|item| item.ratio_case == 1).count(), 530);
    }

    #[test]
    fn high_fiber_ledger_accepts_exact_overlap_and_rejects_overfill() {
        let spec = HighFiberSpec::new([1, 2, 3, 4, 5, 6, 7, 8, 9], 0b111).unwrap();
        assert_eq!(spec.cubic_count(), 3);
        let mut rows = Vec::with_capacity(26);
        rows.extend([[1, 2], [1, 3], [2, 3], [4, 5], [4, 6], [5, 6], [7, 8]]);
        rows.extend(
            [1, 2, 3, 4, 4, 5, 5, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 9].map(|root| [root, 10]),
        );
        let mut ledger = HighFiberLedger::default();
        for &roots in &rows {
            assert!(ledger.try_push(&spec, roots));
        }
        assert_eq!(ledger.rows_done(), 26);
        assert!(ledger.is_complete(&spec));
        assert_eq!((ledger.zero_rows(), ledger.double_rows()), (0, 7));
        assert_eq!(ledger.carrier_nullity_upper_bound(&spec), Some(1));

        let mut overfill = HighFiberLedger::default();
        for _ in 0..3 {
            assert!(overfill.try_push(&spec, [1, 10]));
        }
        let snapshot = overfill;
        assert!(!overfill.try_push(&spec, [1, 11]));
        assert_eq!(overfill, snapshot);
        assert!(HighFiberSpec::new([1; 9], 0).is_none());
        assert!(HighFiberSpec::new([1, 2, 3, 4, 5, 6, 7, 8, 27], 0).is_none());

        for shift in 0..rows.len() {
            let mut permuted = HighFiberLedger::default();
            for offset in 0..rows.len() {
                assert!(permuted.try_push(&spec, rows[(shift + offset) % rows.len()]));
            }
            assert!(permuted.is_complete(&spec));
        }
        let mut reversed = HighFiberLedger::default();
        for &roots in rows.iter().rev() {
            assert!(reversed.try_push(&spec, roots));
        }
        assert!(reversed.is_complete(&spec));

        let spec_two_cubic = HighFiberSpec::new([1, 2, 3, 4, 5, 6, 7, 8, 9], 0b11).unwrap();
        let mut rows_two_cubic = rows.clone();
        let single_one = rows_two_cubic
            .iter()
            .position(|&roots| roots == [1, 10])
            .unwrap();
        rows_two_cubic[single_one] = [1, 3];
        let mut ledger_two_cubic = HighFiberLedger::default();
        for roots in rows_two_cubic {
            assert!(ledger_two_cubic.try_push(&spec_two_cubic, roots));
        }
        assert!(ledger_two_cubic.is_complete(&spec_two_cubic));
        assert_eq!(ledger_two_cubic.double_rows(), 8);
        assert_eq!(
            ledger_two_cubic.carrier_nullity_upper_bound(&spec_two_cubic),
            Some(0)
        );
    }

    #[test]
    fn two_high_fibers_reconstruct_and_verify_the_carrier() {
        let catalog = BalancedTransversalCatalog::q27();
        let carrier = BalancedCarrierCoefficients {
            trace: [4, 7, 11, 3, 18, 9, 22, 6, 1],
            product: [8, 2, 15, 20, 5, 17, 12, 24, 10],
            _reserved: [0; 14],
        };
        let make_fiber = |value: u8| {
            let mut coefficients = carrier.product;
            for (coefficient, &trace_coefficient) in coefficients.iter_mut().zip(&carrier.trace) {
                *coefficient = catalog.add(
                    *coefficient,
                    catalog.multiply(2, catalog.multiply(value, trace_coefficient)),
                );
            }
            coefficients[0] = catalog.add(coefficients[0], catalog.multiply(value, value));
            HighFiberPolynomial::new(value, coefficients).unwrap()
        };
        let reconstructed = catalog
            .reconstruct_carrier_from_fibers(make_fiber(1), make_fiber(2))
            .unwrap();
        assert_eq!(reconstructed, carrier);
        for value in 1..=9 {
            assert!(catalog.high_fiber_matches(&reconstructed, make_fiber(value)));
        }
        let mut corrupted = make_fiber(7);
        corrupted.coefficients[4] = catalog.add(corrupted.coefficients[4], 1);
        assert!(!catalog.high_fiber_matches(&reconstructed, corrupted));
        assert!(catalog
            .reconstruct_carrier_from_fibers(make_fiber(3), make_fiber(3))
            .is_none());
    }

    #[test]
    fn every_unmarked_row_has_full_pair_difference_rank() {
        let catalog = BalancedTransversalCatalog::q27();
        for omitted in 1..27 {
            assert_eq!(catalog.unmarked_pair_local_rank(omitted), Some(6));
        }
        assert_eq!(catalog.unmarked_pair_local_rank(0), None);
        assert_eq!(catalog.unmarked_pair_local_rank(27), None);
    }

    #[test]
    fn seed_search_reconstructs_once_and_checks_seven_families() {
        let catalog = BalancedTransversalCatalog::q27();
        let carrier = BalancedCarrierCoefficients {
            trace: [4, 7, 11, 3, 18, 9, 22, 6, 1],
            product: [8, 2, 15, 20, 5, 17, 12, 24, 10],
            _reserved: [0; 14],
        };
        let make_fiber = |value: u8| {
            let mut coefficients = carrier.product;
            for (coefficient, &trace_coefficient) in coefficients.iter_mut().zip(&carrier.trace) {
                *coefficient = catalog.add(
                    *coefficient,
                    catalog.multiply(2, catalog.multiply(value, trace_coefficient)),
                );
            }
            coefficients[0] = catalog.add(coefficients[0], catalog.multiply(value, value));
            HighFiberPolynomial::new(value, coefficients).unwrap()
        };
        let mut families: Vec<_> = (1..=9).map(|value| vec![make_fiber(value)]).collect();
        let mut decoy = make_fiber(1);
        decoy.coefficients[8] = catalog.add(decoy.coefficients[8], 1);
        families[0].insert(0, decoy);
        let witness = catalog
            .search_high_fiber_candidates(&families)
            .unwrap()
            .unwrap();
        assert_eq!(witness.seed_slots, [1, 2]);
        assert_eq!(witness.candidates_examined, 1);
        assert_eq!(witness.carrier, carrier);
        assert_eq!(witness.candidate_indices[0], 1);

        let mut impossible = families.clone();
        let mut corrupted = impossible[8][0];
        corrupted.coefficients[4] = catalog.add(corrupted.coefficients[4], 1);
        impossible[8] = vec![corrupted];
        assert!(catalog
            .search_high_fiber_candidates(&impossible)
            .unwrap()
            .is_none());
    }

    #[test]
    fn eighteen_high_cells_reconstruct_the_unique_carrier() {
        let catalog = BalancedTransversalCatalog::q27();
        let mut cells = Vec::with_capacity(18);
        for x in 2..=10 {
            cells.push((x, x));
            cells.push((x, catalog.multiply(x, x)));
        }
        let solution = catalog.carrier_from_high_cells(&cells).unwrap();
        assert!(solution.consistent);
        assert_eq!(solution.rank, 18);
        let carrier = solution.carrier.unwrap();
        let mut expected_trace = [0; 9];
        expected_trace[1] = 1;
        expected_trace[2] = 1;
        let mut expected_product = [0; 9];
        expected_product[3] = 1;
        assert_eq!(carrier.trace, expected_trace);
        assert_eq!(carrier.product, expected_product);

        let partial = catalog.carrier_from_high_cells(&cells[..10]).unwrap();
        assert!(partial.consistent);
        assert!(partial.rank < 18);
        assert!(partial.carrier.is_none());

        cells.push((2, 0));
        let inconsistent = catalog.carrier_from_high_cells(&cells).unwrap();
        assert!(!inconsistent.consistent);
        assert!(inconsistent.carrier.is_none());
        assert_eq!(catalog.carrier_from_high_cells(&[(0, 1)]), None);
    }

    #[test]
    fn transactional_cell_basis_rolls_back_by_rank() {
        let catalog = BalancedTransversalCatalog::q27();
        let mut cells = Vec::with_capacity(18);
        for x in 2..=10 {
            cells.push((x, x));
            cells.push((x, catalog.multiply(x, x)));
        }
        let mut basis = CarrierEquationBasis::default();
        for &(x, y) in &cells {
            assert_eq!(
                catalog.push_high_cell(&mut basis, x, y),
                Some(CarrierEquationPush::Independent)
            );
        }
        assert_eq!(basis.rank(), 18);
        let carrier = catalog.carrier_from_equation_basis(&basis).unwrap();
        let direct = catalog
            .carrier_from_high_cells(&cells)
            .unwrap()
            .carrier
            .unwrap();
        assert_eq!(carrier, direct);
        assert_eq!(
            catalog.push_high_cell(&mut basis, 2, 0),
            Some(CarrierEquationPush::Inconsistent)
        );
        assert_eq!(basis.rank(), 18);
        assert!(basis.pop_independent());
        assert_eq!(basis.rank(), 17);
        assert!(catalog.carrier_from_equation_basis(&basis).is_none());
        assert_eq!(
            catalog.push_high_cell(&mut basis, cells[17].0, cells[17].1),
            Some(CarrierEquationPush::Independent)
        );
        assert_eq!(catalog.carrier_from_equation_basis(&basis), Some(direct));
    }

    #[test]
    fn spectral_prefix_replays_newton_update_and_terminal_gate() {
        let field = TernaryExtensionField::new(Q).unwrap();
        let catalog = BalancedTransversalCatalog::q27();
        let roots = [1, 4, 7, 11];
        let mut prefix = WittSpectralPrefix::default();
        for root in roots {
            assert!(prefix.try_push(&catalog, root));
        }
        let e1 = roots.iter().fold(0, |sum, &root| field.add(sum, root));
        let e2 = (0..4)
            .flat_map(|left| ((left + 1)..4).map(move |right| (left, right)))
            .fold(0, |sum, (left, right)| {
                field.add(sum, field.multiply(roots[left], roots[right]))
            });
        let e3 = (0..4)
            .flat_map(|left| {
                ((left + 1)..4).flat_map(move |middle| {
                    ((middle + 1)..4).map(move |right| (left, middle, right))
                })
            })
            .fold(0, |sum, (left, middle, right)| {
                field.add(
                    sum,
                    field.multiply(field.multiply(roots[left], roots[middle]), roots[right]),
                )
            });
        let e4 = roots
            .iter()
            .fold(1, |product, &root| field.multiply(product, root));
        assert_eq!(prefix.elementary(), [e1, e2, e3, e4]);

        let top_a = [5, 6, 7, 8];
        for ratio_case in 0..2 {
            let h2 = catalog
                .witt2_coefficient_gate(ratio_case, [top_a[2], top_a[3]])
                .unwrap();
            let h4 = catalog.witt4_coefficient_gate(ratio_case, top_a).unwrap();
            let target_e4 = catalog.multiply(2, catalog.add(h4, catalog.multiply(h2, h2)));
            for free_e3 in [0, 13, 26] {
                let terminal = WittSpectralPrefix {
                    elementary: [0, h2, free_e3, target_e4],
                    roots_done: 54,
                    _reserved: [0; 3],
                };
                assert!(terminal.is_complete(&catalog, ratio_case, top_a));
            }
        }
    }

    fn first_mapping_high_spec(
        catalog: &BalancedTransversalCatalog,
        ratio_case: usize,
    ) -> HighFiberSpec {
        let mapping = catalog.mappings(ratio_case).unwrap()[0];
        let mut values = mapping.columns.to_vec();
        for value in 1..Q {
            if !values.contains(&value) {
                values.push(value);
                if values.len() == 9 {
                    break;
                }
            }
        }
        values.sort_unstable();
        let values: [u8; 9] = values.try_into().unwrap();
        let cubic_mask = values.iter().enumerate().fold(0u16, |mask, (slot, value)| {
            mask | (u16::from(mapping.columns.contains(value)) << slot)
        });
        HighFiberSpec::new(values, cubic_mask).unwrap()
    }

    #[test]
    fn rank_seventeen_basis_enumerates_exactly_the_mobius_parameter_line() {
        let catalog = BalancedTransversalCatalog::q27();
        let mut cells = Vec::with_capacity(18);
        for x in 2..=10 {
            cells.push((x, x));
            cells.push((x, catalog.multiply(x, x)));
        }
        let full = catalog
            .carrier_from_high_cells(&cells)
            .unwrap()
            .carrier
            .unwrap();
        let mut basis = CarrierEquationBasis::default();
        for &(x, y) in &cells[..17] {
            assert_eq!(
                catalog.push_high_cell(&mut basis, x, y),
                Some(CarrierEquationPush::Independent)
            );
        }
        assert_eq!(basis.rank(), 17);
        let family = catalog.carrier_affine_family(&basis).unwrap();
        assert!(family.direction.is_some());
        let members = (0..Q)
            .map(|parameter| catalog.carrier_affine_member(family, parameter).unwrap())
            .collect::<Vec<_>>();
        assert_eq!(members.len(), 27);
        assert!(members.contains(&full));
        for left in 0..members.len() {
            for right in left + 1..members.len() {
                assert_ne!(members[left], members[right]);
            }
        }
        assert!(catalog.carrier_affine_member(family, Q).is_none());
    }

    #[test]
    fn completed_exceptional_mobius_profile_leaves_at_least_eight_split_parameters() {
        let catalog = BalancedTransversalCatalog::q27();

        // H has the seven double rows as its simple roots.  The affine
        // carrier line has direction (P,Q)=(H,XH), so y=x is fixed on
        // every singleton row.  This realizes the extremal situation behind
        // the general count: seven full masks and nineteen masks that can
        // each remove at most one of the twenty-seven parameters.
        let mut h = [0u8; 9];
        h[0] = 1;
        for (degree, root) in (1..=7u8).enumerate() {
            let mut next = [0u8; 9];
            for index in 0..=degree {
                next[index + 1] = catalog.add(next[index + 1], h[index]);
                next[index] = catalog.add(
                    next[index],
                    catalog.multiply(2, catalog.multiply(root, h[index])),
                );
            }
            h = next;
        }

        let mut cells = Vec::with_capacity(33);
        for x in 1..Q {
            cells.push((x, x));
            if x <= 7 {
                cells.push((x, catalog.multiply(2, x)));
            }
        }
        let mut basis = CarrierEquationBasis::default();
        for &(x, y) in &cells {
            assert_ne!(
                catalog.push_high_cell(&mut basis, x, y),
                Some(CarrierEquationPush::Inconsistent)
            );
        }
        assert_eq!(basis.rank(), 17);
        let family = catalog.carrier_affine_family(&basis).unwrap();
        let direction = family.direction.unwrap();
        assert_eq!(direction.trace, h);
        assert_eq!(direction.product[0], 0);
        assert_eq!(direction.product[1..], h[..8]);

        let mut split_parameters = (1u32 << Q) - 1;
        for x in 1..Q {
            let mut row_mask = 0u32;
            for parameter in 0..Q {
                let carrier = catalog.carrier_affine_member(family, parameter).unwrap();
                let trace = catalog.evaluate_polynomial(&carrier.trace, x);
                let product = catalog.evaluate_polynomial(&carrier.product, x);
                let discriminant =
                    catalog.add(catalog.multiply(trace, trace), catalog.multiply(2, product));
                if catalog.nonzero_square[discriminant as usize] {
                    row_mask |= 1 << parameter;
                }
            }
            split_parameters &= row_mask;
        }
        assert!(split_parameters.count_ones() >= 8);
    }

    #[test]
    fn terminal_replay_rejects_a_nonsplit_row_before_profile_gates() {
        let catalog = BalancedTransversalCatalog::q27();
        let spec = first_mapping_high_spec(&catalog, 0);
        let mut trace = [0; 9];
        trace[1] = 1;
        trace[2] = 1;
        let mut product = [0; 9];
        product[3] = 1;
        let carrier = BalancedCarrierCoefficients {
            trace,
            product,
            _reserved: [0; 14],
        };
        assert_eq!(
            catalog.check_balanced_terminal(0, 0, &spec, carrier),
            Err(BalancedTerminalRejection::CarrierDoesNotSplit)
        );
    }

    #[test]
    fn discriminant_square_mask_is_exactly_the_distinct_split_condition() {
        let catalog = BalancedTransversalCatalog::q27();
        let carriers = [
            BalancedCarrierCoefficients::new(
                [1, 2, 0, 0, 0, 0, 0, 0, 0],
                [0, 1, 1, 0, 0, 0, 0, 0, 0],
            )
            .unwrap(),
            BalancedCarrierCoefficients::new(
                [0, 1, 1, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 1, 0, 0, 0, 0, 0],
            )
            .unwrap(),
        ];
        for carrier in carriers {
            for x in 1..Q {
                let trace = catalog.evaluate_polynomial(&carrier.trace, x);
                let product = catalog.evaluate_polynomial(&carrier.product, x);
                let discriminant =
                    catalog.add(catalog.multiply(trace, trace), catalog.multiply(2, product));
                let root_count = (0..Q)
                    .filter(|&y| {
                        catalog.add(
                            catalog.add(
                                catalog.multiply(y, y),
                                catalog.multiply(2, catalog.multiply(trace, y)),
                            ),
                            product,
                        ) == 0
                    })
                    .count();
                assert_eq!(
                    catalog.nonzero_square[discriminant as usize],
                    root_count == 2
                );
            }
        }
    }

    #[test]
    fn bounded_high_incidence_dfs_never_promotes_cutoff_to_rejection() {
        let catalog = BalancedTransversalCatalog::q27();
        let spec = first_mapping_high_spec(&catalog, 0);
        let result = catalog
            .search_high_incidence_spec(
                0,
                0,
                &spec,
                BalancedDfsLimits {
                    max_nodes: 2,
                    max_terminal_carriers: 0,
                },
            )
            .unwrap();
        assert_eq!(result.status, BalancedDfsStatus::Incomplete);
        assert!(result.witness.is_none());
        assert_eq!(result.stats.nodes, 2);
        assert!(result.rejection_cores.is_empty());
    }

    #[test]
    fn nine_high_value_stream_has_exact_binomial_domain() {
        let mut values = [1, 2, 3, 4, 5, 6, 7, 8, 9];
        let mut count = 1u64;
        while next_nine_subset(&mut values) {
            count += 1;
        }
        assert_eq!(count, 3_124_550);
        assert_eq!(values, [18, 19, 20, 21, 22, 23, 24, 25, 26]);
    }

    #[test]
    fn bounded_714_task_queue_stays_explicitly_incomplete() {
        let catalog = BalancedTransversalCatalog::q27();
        let result = catalog
            .search_balanced_work_queue(BalancedQueueLimits {
                max_tasks: 1,
                max_high_sets_per_task: 1,
                per_high_set: BalancedDfsLimits {
                    max_nodes: 1,
                    max_terminal_carriers: 0,
                },
            })
            .unwrap();
        assert_eq!(result.status, BalancedDfsStatus::Incomplete);
        assert_eq!(result.tasks.len(), 1);
        assert_eq!(result.tasks[0].high_sets_examined, 1);
        assert_eq!(result.tasks[0].stats.nodes, 1);
    }
}
