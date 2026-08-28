//! Contextual quotients and rank-bounded outer tests.
//!
//! These routines specialize to scalar labels over the outer field.  They
//! retain exact labelled costs inside every probe; only the outer test family
//! is quotiented.

use crate::composition::CostTable;
use crate::confinement::{confinement_by_generators_field, ConfinementError, ConfinementSector};
use crate::field::FiniteField;
use crate::matrix::{Matrix, MatrixError};
use std::marker::PhantomData;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum ContextualError {
    #[error(transparent)]
    Confinement(#[from] ConfinementError),
    #[error(transparent)]
    Matrix(#[from] MatrixError),
    #[error("contextual-state input dimensions do not agree")]
    Shape,
    #[error("the outer functional dual kills the target projection")]
    TargetProjection,
    #[error("cost or state count exceeds its compact representation")]
    Overflow,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct ContextWork {
    pub outer_vectors: u64,
    pub distinct_subspaces: u64,
    pub cache_hits: u64,
    pub scalar_probes: u64,
    pub generator_candidates: u64,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ContextCost {
    pub cost: u32,
    pub sector: ConfinementSector,
    pub work: ContextWork,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ContextExecution {
    Direct,
    Cached,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ContextStrategy {
    Direct,
    Cached,
    Auto {
        expected_queries: u32,
        memory_budget_bytes: usize,
    },
}

impl Default for ContextStrategy {
    fn default() -> Self {
        Self::Auto {
            expected_queries: 1,
            memory_budget_bytes: usize::MAX,
        }
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ContextPlan {
    pub execution: ContextExecution,
    pub expected_queries: u32,
    pub amortization_queries: u32,
    pub estimated_cache_entries: u64,
    pub estimated_cache_bytes: u64,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct PlannedContextCost {
    pub result: ContextCost,
    pub plan: ContextPlan,
}

const PROJECTIVE_AMORTIZATION_QUERIES: u32 = 1;
const RANK_BOUNDED_AMORTIZATION_QUERIES: u32 = 2;
const CACHE_RECORD_AND_INDEX_BYTES: u64 = 32;
const FULL_RANK_MAP_CACHE_BYTES: usize = 8 * 1024 * 1024;
const DENSE_COST_DIRECTORY_ENTRIES: u64 = 1 << 18;

const EMPTY_SLOT: u32 = u32::MAX;

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct CacheRecord {
    hash: u64,
    cost: u32,
    seen_generation: u32,
}

#[derive(Default)]
struct DenseCostDirectory {
    storage: Box<[u32]>,
    cost_len: usize,
}

impl DenseCostDirectory {
    #[inline(always)]
    fn lookup_index(&self, index: usize) -> Option<u32> {
        let present = self.storage[self.cost_len + index / 32] & (1_u32 << (index % 32)) != 0;
        present.then_some(self.storage[index])
    }

    fn lookup<F: FiniteField>(&self, label: &[u8]) -> Option<u32> {
        if self.storage.is_empty() {
            return None;
        }
        let mut index = 0_usize;
        for &entry in label {
            index = index * F::ORDER as usize + entry as usize;
        }
        self.lookup_index(index)
    }
}

const _: () = assert!(std::mem::size_of::<CacheRecord>() == 16);
const _: () = assert!(std::mem::align_of::<CacheRecord>() == 8);

/// Fixed-width keys in one flat byte pool, addressed through compact record IDs.
struct FlatCostCache {
    key_len: usize,
    slots: Vec<u32>,
    records: Vec<CacheRecord>,
    keys: Vec<u8>,
    generation: u32,
}

impl FlatCostCache {
    fn new(key_len: usize) -> Self {
        Self {
            key_len,
            slots: Vec::new(),
            records: Vec::new(),
            keys: Vec::new(),
            generation: 0,
        }
    }

    fn len(&self) -> usize {
        self.records.len()
    }

    /// Reserve all candidate admissions and rebuild the index before the scan.
    fn reserve_scan(&mut self, total_capacity: usize) -> Result<(), ContextualError> {
        if total_capacity > EMPTY_SLOT as usize {
            return Err(ContextualError::Overflow);
        }
        let needed = total_capacity.max(self.records.len());
        self.records.reserve(needed - self.records.len());
        self.keys.reserve(
            (needed - self.records.len())
                .checked_mul(self.key_len)
                .ok_or(ContextualError::Overflow)?,
        );
        let doubled = needed.checked_mul(2).ok_or(ContextualError::Overflow)?;
        let slot_count = doubled
            .checked_next_power_of_two()
            .ok_or(ContextualError::Overflow)?
            .max(8);
        if self.slots.len() < slot_count {
            self.slots.clear();
            self.slots.resize(slot_count, EMPTY_SLOT);
            for record_id in 0..self.records.len() {
                self.place(record_id as u32);
            }
        }
        Ok(())
    }

    fn begin_scan(&mut self) {
        self.generation = self.generation.wrapping_add(1);
        if self.generation == 0 {
            for record in &mut self.records {
                record.seen_generation = 0;
            }
            self.generation = 1;
        }
    }

    fn lookup(&self, key: &[u8], hash: u64) -> Option<u32> {
        if self.slots.is_empty() {
            return None;
        }
        let mask = self.slots.len() - 1;
        let mut slot = hash as usize & mask;
        loop {
            let record_id = self.slots[slot];
            if record_id == EMPTY_SLOT {
                return None;
            }
            let record = self.records[record_id as usize];
            if record.hash == hash && self.key(record_id) == key {
                return Some(record_id);
            }
            slot = (slot + 1) & mask;
        }
    }

    fn insert_reserved(&mut self, key: &[u8], hash: u64, cost: u32) -> u32 {
        debug_assert_eq!(key.len(), self.key_len);
        debug_assert!(self.records.len() < self.records.capacity());
        debug_assert!(self.keys.len() + self.key_len <= self.keys.capacity());
        let record_id = self.records.len() as u32;
        self.keys.extend_from_slice(key);
        self.records.push(CacheRecord {
            hash,
            cost,
            seen_generation: 0,
        });
        self.place(record_id);
        record_id
    }

    fn cost(&self, record_id: u32) -> u32 {
        self.records[record_id as usize].cost
    }

    fn mark_first_in_scan(&mut self, record_id: u32) -> bool {
        let record = &mut self.records[record_id as usize];
        if record.seen_generation == self.generation {
            false
        } else {
            record.seen_generation = self.generation;
            true
        }
    }

    fn key(&self, record_id: u32) -> &[u8] {
        let start = record_id as usize * self.key_len;
        &self.keys[start..start + self.key_len]
    }

    fn place(&mut self, record_id: u32) {
        let mask = self.slots.len() - 1;
        let mut slot = self.records[record_id as usize].hash as usize & mask;
        while self.slots[slot] != EMPTY_SLOT {
            slot = (slot + 1) & mask;
        }
        self.slots[slot] = record_id;
    }
}

fn hash_key(key: &[u8]) -> u64 {
    let mut hash = 0xcbf2_9ce4_8422_2325u64;
    for &byte in key {
        hash ^= u64::from(byte);
        hash = hash.wrapping_mul(0x0000_0100_0000_01b3);
    }
    hash
}

/// Lazy cache of the zero-truncated projective line-probe profile.
pub struct RankOneProbeCache<'a, F: FiniteField> {
    inner: &'a CostTable,
    target: &'a CostTable,
    block_count: usize,
    target_block: usize,
    inner_dual_distance: u32,
    zero_cost: u32,
    probes: FlatCostCache,
    _field: PhantomData<F>,
}

impl<'a, F: FiniteField> RankOneProbeCache<'a, F> {
    pub fn new(
        inner: &'a CostTable,
        target: &'a CostTable,
        block_count: usize,
        target_block: usize,
        inner_dual_distance: u32,
    ) -> Result<Self, ContextualError> {
        F::validate().map_err(MatrixError::from)?;
        if inner.field_order() != F::ORDER
            || target.field_order() != F::ORDER
            || inner.shape() != (1, 1)
            || target.shape() != (1, 1)
            || block_count < 2
            || target_block >= block_count
        {
            return Err(ContextualError::Shape);
        }
        let zero = Matrix::zeros_field::<F>(1, 1)?;
        let zero_cost = target
            .cost(&zero)
            .ok_or(ContextualError::Shape)?
            .checked_add(inner_dual_distance)
            .ok_or(ContextualError::Overflow)?;
        Ok(Self {
            inner,
            target,
            block_count,
            target_block,
            inner_dual_distance,
            zero_cost,
            probes: FlatCostCache::new(block_count),
            _field: PhantomData,
        })
    }

    pub fn cached_probe_count(&self) -> usize {
        self.probes.len()
    }

    fn cached_context_cost_if_complete(
        &mut self,
        basis: &Matrix,
    ) -> Result<Option<ContextCost>, ContextualError> {
        if self.probes.records.is_empty() {
            return Ok(None);
        }
        let mut coefficients = vec![0u8; basis.rows()];
        let mut tuple = vec![0u8; self.block_count];
        let mut canonical = vec![0u8; self.block_count];
        self.probes.begin_scan();
        let mut work = ContextWork::default();
        let mut best = self.zero_cost;
        while increment_digits::<F>(&mut coefficients) {
            work.outer_vectors += 1;
            combine_rows::<F>(basis, &coefficients, &mut tuple);
            canonicalize_projective_line::<F>(&tuple, &mut canonical)?;
            let hash = hash_key(&canonical);
            let Some(record_id) = self.probes.lookup(&canonical, hash) else {
                return Ok(None);
            };
            if self.probes.mark_first_in_scan(record_id) {
                work.distinct_subspaces += 1;
                work.cache_hits += 1;
                best = best.min(self.probes.cost(record_id));
            }
        }
        Ok(Some(ContextCost {
            cost: best,
            sector: if best < self.zero_cost {
                ConfinementSector::Nonzero
            } else {
                ConfinementSector::Zero
            },
            work,
        }))
    }

    pub fn context_cost(
        &mut self,
        functional_dual_basis: &Matrix,
    ) -> Result<ContextCost, ContextualError> {
        Ok(self
            .context_cost_planned(functional_dual_basis, ContextStrategy::default())?
            .result)
    }

    pub fn context_cost_cached(
        &mut self,
        functional_dual_basis: &Matrix,
    ) -> Result<ContextCost, ContextualError> {
        let basis =
            validate_context::<F>(functional_dual_basis, self.block_count, self.target_block)?;
        if let Some(cached) = self.cached_context_cost_if_complete(&basis)? {
            return Ok(cached);
        }
        let mut coefficients = vec![0u8; basis.rows()];
        let mut tuple = vec![0u8; self.block_count];
        let mut canonical = vec![0u8; self.block_count];
        let query_entries = projective_line_count(F::ORDER, basis.rows())?;
        let total_capacity = self
            .probes
            .len()
            .checked_add(to_usize(query_entries)?)
            .ok_or(ContextualError::Overflow)?;
        self.probes.reserve_scan(total_capacity)?;
        self.probes.begin_scan();
        let mut work = ContextWork::default();
        let mut best = self.zero_cost;
        while increment_digits::<F>(&mut coefficients) {
            work.outer_vectors += 1;
            combine_rows::<F>(&basis, &coefficients, &mut tuple);
            canonicalize_projective_line::<F>(&tuple, &mut canonical)?;
            let hash = hash_key(&canonical);
            let (record_id, was_cached) =
                if let Some(record_id) = self.probes.lookup(&canonical, hash) {
                    (record_id, true)
                } else {
                    let cost = self.compute_probe(&canonical, &mut work)?;
                    (self.probes.insert_reserved(&canonical, hash, cost), false)
                };
            if !self.probes.mark_first_in_scan(record_id) {
                continue;
            }
            work.distinct_subspaces += 1;
            if was_cached {
                work.cache_hits += 1;
            }
            let probe = self.probes.cost(record_id);
            best = best.min(probe);
        }
        Ok(ContextCost {
            cost: best,
            sector: if best < self.zero_cost {
                ConfinementSector::Nonzero
            } else {
                ConfinementSector::Zero
            },
            work,
        })
    }

    fn compute_probe(&self, line: &[u8], work: &mut ContextWork) -> Result<u32, ContextualError> {
        let mut best = self.zero_cost;
        let mut label = [0u8; 1];
        for scalar in 1..F::ORDER {
            work.scalar_probes += 1;
            let mut cost = 0u32;
            for (block, &entry) in line.iter().enumerate() {
                label[0] = F::mul(scalar, entry);
                let table = if block == self.target_block {
                    self.target
                } else {
                    self.inner
                };
                let local = table.cost_slice(&label).ok_or(ContextualError::Shape)?;
                cost = cost.checked_add(local).ok_or(ContextualError::Overflow)?;
                if cost >= best {
                    break;
                }
            }
            best = best.min(cost);
        }
        Ok(best)
    }

    pub fn context_cost_planned(
        &mut self,
        functional_dual_basis: &Matrix,
        strategy: ContextStrategy,
    ) -> Result<PlannedContextCost, ContextualError> {
        let basis =
            validate_context::<F>(functional_dual_basis, self.block_count, self.target_block)?;
        if let ContextStrategy::Auto {
            expected_queries, ..
        } = strategy
        {
            if expected_queries == 0 {
                return Err(ContextualError::Shape);
            }
            if let Some(result) = self.cached_context_cost_if_complete(&basis)? {
                let entries =
                    u64::try_from(self.probes.len()).map_err(|_| ContextualError::Overflow)?;
                let estimated_cache_bytes = entries
                    .checked_mul(cache_entry_bytes(self.block_count)?)
                    .ok_or(ContextualError::Overflow)?;
                return Ok(PlannedContextCost {
                    result,
                    plan: ContextPlan {
                        execution: ContextExecution::Cached,
                        expected_queries,
                        amortization_queries: PROJECTIVE_AMORTIZATION_QUERIES,
                        estimated_cache_entries: entries,
                        estimated_cache_bytes,
                    },
                });
            }
        }
        let query_entries = projective_line_count(F::ORDER, basis.rows())?;
        let entries = u64::try_from(self.probes.len())
            .ok()
            .and_then(|cached| cached.checked_add(query_entries))
            .ok_or(ContextualError::Overflow)?;
        let entry_bytes = cache_entry_bytes(self.block_count)?;
        let plan = choose_plan(
            strategy,
            PROJECTIVE_AMORTIZATION_QUERIES,
            entries,
            entry_bytes,
        )?;
        let result = match plan.execution {
            ContextExecution::Direct => direct_context_cost::<F>(
                &basis,
                self.block_count,
                self.inner,
                self.target,
                self.target_block,
                self.inner_dual_distance,
            )?,
            ContextExecution::Cached => self.context_cost_cached(&basis)?,
        };
        Ok(PlannedContextCost { result, plan })
    }
}

/// Cache for the rank-bounded outer-test decomposition at a fixed target rank.
pub struct RankBoundedContextCache<'a, F: FiniteField> {
    inner: &'a CostTable,
    target: &'a CostTable,
    block_count: usize,
    target_block: usize,
    inner_dual_distance: u32,
    target_rank: usize,
    zero_cost: u32,
    costs: FlatCostCache,
    full_rank_maps: Box<[Box<[u8]>]>,
    inner_dense_costs: DenseCostDirectory,
    target_dense_costs: DenseCostDirectory,
    target_uses_inner_dense_costs: bool,
    compiled_kernels_initialized: bool,
    _field: PhantomData<F>,
}

const EXACT_ENVELOPE_PARENT: u32 = u32::MAX;

#[derive(Debug)]
struct RankEnvelopeStratum {
    bases: Box<[u8]>,
    exact_costs: Box<[u32]>,
    envelope_costs: Box<[u32]>,
    envelope_parents: Box<[u32]>,
    restriction_offsets: Box<[u32]>,
    restriction_targets: Box<[u32]>,
    lookup_keys: Box<[u64]>,
    lookup_states: Box<[u32]>,
}

/// Exact full-span costs aggregated upward through the subspace lattice.
///
/// Each rank is contiguous. Adjacent-rank restriction edges and envelope
/// parents use compact local state IDs; query-time lookup performs no lattice
/// traversal and allocates only while canonicalizing an untrusted matrix.
#[derive(Debug)]
pub struct RankStratifiedEnvelope {
    field_order: u8,
    ambient_dimension: usize,
    target_block: usize,
    strata: Box<[RankEnvelopeStratum]>,
    compilation_work: ContextWork,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct RankEnvelopeStorage {
    pub states: u64,
    pub restriction_edges: u64,
    pub payload_bytes: u64,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct RankEnvelopeAnswer {
    pub cost: u32,
    pub context_rank: u16,
    pub exact_rank: u16,
    pub exact_state: u32,
}

impl RankStratifiedEnvelope {
    pub fn compilation_work(&self) -> ContextWork {
        self.compilation_work
    }

    pub fn storage(&self) -> RankEnvelopeStorage {
        let mut states = 0_u64;
        let mut restriction_edges = 0_u64;
        let mut payload_bytes = 0_u64;
        for stratum in &self.strata {
            states += stratum.exact_costs.len() as u64;
            restriction_edges += stratum.restriction_targets.len() as u64;
            payload_bytes += (stratum.bases.len()
                + std::mem::size_of_val(&*stratum.exact_costs)
                + std::mem::size_of_val(&*stratum.envelope_costs)
                + std::mem::size_of_val(&*stratum.envelope_parents)
                + std::mem::size_of_val(&*stratum.restriction_offsets)
                + std::mem::size_of_val(&*stratum.restriction_targets)
                + std::mem::size_of_val(&*stratum.lookup_keys)
                + std::mem::size_of_val(&*stratum.lookup_states))
                as u64;
        }
        RankEnvelopeStorage {
            states,
            restriction_edges,
            payload_bytes,
        }
    }

    pub fn context_cost<F: FiniteField>(
        &self,
        functional_dual_basis: &Matrix,
    ) -> Result<RankEnvelopeAnswer, ContextualError> {
        if self.field_order != F::ORDER {
            return Err(ContextualError::Shape);
        }
        let basis = validate_context::<F>(
            functional_dual_basis,
            self.ambient_dimension,
            self.target_block,
        )?;
        let rank = basis.rows();
        let stratum = self.strata.get(rank).ok_or(ContextualError::Shape)?;
        let key = encode_subspace::<F>(basis.as_slice())?;
        let state = lookup_envelope_state(stratum, key).ok_or(ContextualError::Shape)?;
        let mut exact_rank = rank;
        let mut exact_state = state;
        while exact_rank != 0 {
            let parent = self.strata[exact_rank].envelope_parents[exact_state as usize];
            if parent == EXACT_ENVELOPE_PARENT {
                break;
            }
            exact_rank -= 1;
            exact_state = parent;
        }
        Ok(RankEnvelopeAnswer {
            cost: stratum.envelope_costs[state as usize],
            context_rank: rank.try_into().map_err(|_| ContextualError::Overflow)?,
            exact_rank: exact_rank
                .try_into()
                .map_err(|_| ContextualError::Overflow)?,
            exact_state,
        })
    }

    pub fn exact_basis(&self, rank: usize, state: u32) -> Option<&[u8]> {
        let stratum = self.strata.get(rank)?;
        let width = rank.checked_mul(self.ambient_dimension)?;
        let start = (state as usize).checked_mul(width)?;
        stratum.bases.get(start..start.checked_add(width)?)
    }
}

impl<'a, F: FiniteField> RankBoundedContextCache<'a, F> {
    pub fn new(
        inner: &'a CostTable,
        target: &'a CostTable,
        block_count: usize,
        target_block: usize,
        inner_dual_distance: u32,
    ) -> Result<Self, ContextualError> {
        F::validate().map_err(MatrixError::from)?;
        let (label_rows, target_rank) = inner.shape();
        if label_rows != 1
            || target_rank == 0
            || inner.field_order() != F::ORDER
            || target.field_order() != F::ORDER
            || target.shape() != (1, target_rank)
            || block_count < 2
            || target_block >= block_count
        {
            return Err(ContextualError::Shape);
        }
        let zero = Matrix::zeros_field::<F>(1, target_rank)?;
        let zero_cost = target
            .cost(&zero)
            .ok_or(ContextualError::Shape)?
            .checked_add(inner_dual_distance)
            .ok_or(ContextualError::Overflow)?;
        Ok(Self {
            inner,
            target,
            block_count,
            target_block,
            inner_dual_distance,
            target_rank,
            zero_cost,
            costs: FlatCostCache::new(target_rank * block_count),
            full_rank_maps: vec![Box::default(); target_rank + 1].into_boxed_slice(),
            inner_dense_costs: DenseCostDirectory::default(),
            target_dense_costs: DenseCostDirectory::default(),
            target_uses_inner_dense_costs: std::ptr::eq(inner, target),
            compiled_kernels_initialized: false,
            _field: PhantomData,
        })
    }

    pub fn cached_context_count(&self) -> usize {
        self.costs.len()
    }

    /// Payload bytes retained by compiled full-rank maps and dense cost
    /// directories, excluding container headers and the contextual cost cache.
    pub fn compiled_kernel_payload_bytes(&self) -> usize {
        let full_rank = self
            .full_rank_maps
            .iter()
            .map(|maps| maps.len())
            .sum::<usize>();
        let dense_words = self
            .inner_dense_costs
            .storage
            .len()
            .saturating_add(self.target_dense_costs.storage.len());
        full_rank.saturating_add(dense_words.saturating_mul(std::mem::size_of::<u32>()))
    }

    fn ensure_compiled_kernels(&mut self) -> Result<(), ContextualError> {
        if self.compiled_kernels_initialized {
            return Ok(());
        }
        let mut remaining = FULL_RANK_MAP_CACHE_BYTES;
        for rank in 1..=self.target_rank {
            let Some(bytes) = full_rank_map_storage_bytes::<F>(rank, self.target_rank)? else {
                continue;
            };
            if bytes > remaining {
                continue;
            }
            let maps = enumerate_full_rank_maps::<F>(rank, self.target_rank, bytes);
            remaining -= maps.len();
            self.full_rank_maps[rank] = maps;
        }
        self.inner_dense_costs = dense_cost_directory::<F>(self.inner, self.target_rank)?;
        if !self.target_uses_inner_dense_costs {
            self.target_dense_costs = dense_cost_directory::<F>(self.target, self.target_rank)?;
        }
        self.compiled_kernels_initialized = true;
        Ok(())
    }

    fn cached_context_cost_if_complete(
        &self,
        basis: &Matrix,
    ) -> Result<Option<ContextCost>, ContextualError> {
        if self.costs.records.is_empty() {
            return Ok(None);
        }
        let max_rank = self.target_rank.min(basis.rows());
        let mut ambient_key = vec![0u8; self.target_rank * self.block_count];
        let mut pivots = Vec::with_capacity(max_rank);
        let mut coefficient_basis = vec![0u8; max_rank * basis.rows()];
        let mut free = Vec::with_capacity(max_rank * basis.rows());
        let mut digits = vec![0u8; max_rank * basis.rows()];
        let mut work = ContextWork::default();
        let mut best = self.zero_cost;
        let mut complete = true;
        for rank in 1..=max_rank {
            enumerate_rref_subspaces::<F, _>(
                basis.rows(),
                rank,
                &mut pivots,
                &mut coefficient_basis,
                &mut free,
                &mut digits,
                |coefficient_basis| {
                    multiply_bases_into::<F>(coefficient_basis, rank, basis, &mut ambient_key);
                    work.distinct_subspaces += 1;
                    let hash = hash_key(&ambient_key);
                    if let Some(record_id) = self.costs.lookup(&ambient_key, hash) {
                        work.cache_hits += 1;
                        best = best.min(self.costs.cost(record_id));
                    } else {
                        complete = false;
                    }
                    Ok(())
                },
            )?;
        }
        Ok(complete.then_some(ContextCost {
            cost: best,
            sector: if best < self.zero_cost {
                ConfinementSector::Nonzero
            } else {
                ConfinementSector::Zero
            },
            work,
        }))
    }

    pub fn context_cost(
        &mut self,
        functional_dual_basis: &Matrix,
    ) -> Result<ContextCost, ContextualError> {
        Ok(self
            .context_cost_planned(functional_dual_basis, ContextStrategy::default())?
            .result)
    }

    pub fn context_cost_cached(
        &mut self,
        functional_dual_basis: &Matrix,
    ) -> Result<ContextCost, ContextualError> {
        let basis =
            validate_context::<F>(functional_dual_basis, self.block_count, self.target_block)?;
        self.context_cost_cached_validated(&basis, true)
    }

    fn context_cost_cached_validated(
        &mut self,
        basis: &Matrix,
        compile_kernels: bool,
    ) -> Result<ContextCost, ContextualError> {
        if let Some(cached) = self.cached_context_cost_if_complete(basis)? {
            return Ok(cached);
        }
        if compile_kernels {
            self.ensure_compiled_kernels()?;
        }
        let mut work = ContextWork::default();
        let mut best = self.zero_cost;
        let max_rank = self.target_rank.min(basis.rows());
        let mut ambient_key = vec![0u8; self.target_rank * self.block_count];
        let mut coefficients = vec![0u8; self.target_rank * self.target_rank];
        let mut rank_scratch = vec![0u8; self.target_rank * self.target_rank];
        let mut block_data = vec![0u8; self.block_count * self.target_rank];
        let mut pivots = Vec::with_capacity(max_rank);
        let mut coefficient_basis = vec![0u8; max_rank * basis.rows()];
        let mut free = Vec::with_capacity(max_rank * basis.rows());
        let mut digits = vec![0u8; max_rank * basis.rows()];
        let query_entries = rank_bounded_subspace_count(F::ORDER, basis.rows(), max_rank)?;
        let total_capacity = self
            .costs
            .len()
            .checked_add(to_usize(query_entries)?)
            .ok_or(ContextualError::Overflow)?;
        self.costs.reserve_scan(total_capacity)?;
        self.costs.begin_scan();
        for rank in 1..=max_rank {
            enumerate_rref_subspaces::<F, _>(
                basis.rows(),
                rank,
                &mut pivots,
                &mut coefficient_basis,
                &mut free,
                &mut digits,
                |coefficient_basis| {
                    multiply_bases_into::<F>(coefficient_basis, rank, basis, &mut ambient_key);
                    work.distinct_subspaces += 1;
                    let hash = hash_key(&ambient_key);
                    let cost = if let Some(record_id) = self.costs.lookup(&ambient_key, hash) {
                        work.cache_hits += 1;
                        self.costs.cost(record_id)
                    } else {
                        let cost = atomic_subspace_cost::<F>(
                            &ambient_key[..rank * self.block_count],
                            rank,
                            self.block_count,
                            self.target_rank,
                            self.inner,
                            self.target,
                            self.target_block,
                            self.zero_cost,
                            &mut coefficients[..rank * self.target_rank],
                            &mut rank_scratch[..rank * self.target_rank],
                            &self.full_rank_maps[rank],
                            &self.inner_dense_costs,
                            &self.target_dense_costs,
                            self.target_uses_inner_dense_costs,
                            &mut block_data,
                            &mut work,
                        )?;
                        self.costs.insert_reserved(&ambient_key, hash, cost);
                        cost
                    };
                    best = best.min(cost);
                    Ok(())
                },
            )?;
        }
        Ok(ContextCost {
            cost: best,
            sector: if best < self.zero_cost {
                ConfinementSector::Nonzero
            } else {
                ConfinementSector::Zero
            },
            work,
        })
    }

    pub fn context_cost_planned(
        &mut self,
        functional_dual_basis: &Matrix,
        strategy: ContextStrategy,
    ) -> Result<PlannedContextCost, ContextualError> {
        let basis =
            validate_context::<F>(functional_dual_basis, self.block_count, self.target_block)?;
        if let ContextStrategy::Auto {
            expected_queries, ..
        } = strategy
        {
            if expected_queries == 0 {
                return Err(ContextualError::Shape);
            }
            if let Some(result) = self.cached_context_cost_if_complete(&basis)? {
                let entries =
                    u64::try_from(self.costs.len()).map_err(|_| ContextualError::Overflow)?;
                let entry_bytes = cache_entry_bytes(
                    self.target_rank
                        .checked_mul(self.block_count)
                        .ok_or(ContextualError::Overflow)?,
                )?;
                let estimated_cache_bytes = entries
                    .checked_mul(entry_bytes)
                    .ok_or(ContextualError::Overflow)?;
                return Ok(PlannedContextCost {
                    result,
                    plan: ContextPlan {
                        execution: ContextExecution::Cached,
                        expected_queries,
                        amortization_queries: RANK_BOUNDED_AMORTIZATION_QUERIES,
                        estimated_cache_entries: entries,
                        estimated_cache_bytes,
                    },
                });
            }
        }
        let query_entries = rank_bounded_subspace_count(
            F::ORDER,
            basis.rows(),
            self.target_rank.min(basis.rows()),
        )?;
        let entries = u64::try_from(self.costs.len())
            .ok()
            .and_then(|cached| cached.checked_add(query_entries))
            .ok_or(ContextualError::Overflow)?;
        let entry_bytes = cache_entry_bytes(
            self.target_rank
                .checked_mul(self.block_count)
                .ok_or(ContextualError::Overflow)?,
        )?;
        let compile_kernels = matches!(strategy, ContextStrategy::Cached);
        let plan = choose_plan(
            strategy,
            RANK_BOUNDED_AMORTIZATION_QUERIES,
            entries,
            entry_bytes,
        )?;
        let result = match plan.execution {
            ContextExecution::Direct => direct_context_cost::<F>(
                &basis,
                self.block_count,
                self.inner,
                self.target,
                self.target_block,
                self.inner_dual_distance,
            )?,
            ContextExecution::Cached => {
                self.context_cost_cached_validated(&basis, compile_kernels)?
            }
        };
        Ok(PlannedContextCost { result, plan })
    }

    /// Compile all exact full-span responses once, then propagate their minima
    /// through precomputed adjacent-rank restriction edges.
    ///
    /// This is intended for many contexts in a small ambient space. The state
    /// budget is checked before any stratum is materialized.
    pub fn compile_full_span_envelope(
        &mut self,
        maximum_context_rank: usize,
        state_budget: usize,
    ) -> Result<RankStratifiedEnvelope, ContextualError> {
        if maximum_context_rank > self.block_count || state_budget == 0 {
            return Err(ContextualError::Shape);
        }
        self.ensure_compiled_kernels()?;
        let mut coefficients = vec![0u8; self.target_rank * self.target_rank];
        let mut rank_scratch = vec![0u8; self.target_rank * self.target_rank];
        let mut block_data = vec![0u8; self.block_count * self.target_rank];
        let mut work = ContextWork::default();
        let mut envelope = compile_rank_stratified_envelope::<F, _>(
            self.block_count,
            self.target_block,
            maximum_context_rank,
            state_budget,
            self.zero_cost,
            |rank, subspace| {
                work.distinct_subspaces = work
                    .distinct_subspaces
                    .checked_add(1)
                    .ok_or(ContextualError::Overflow)?;
                if rank > self.target_rank {
                    return Ok(u32::MAX);
                }
                atomic_subspace_cost::<F>(
                    subspace,
                    rank,
                    self.block_count,
                    self.target_rank,
                    self.inner,
                    self.target,
                    self.target_block,
                    self.zero_cost,
                    &mut coefficients[..rank * self.target_rank],
                    &mut rank_scratch[..rank * self.target_rank],
                    &self.full_rank_maps[rank],
                    &self.inner_dense_costs,
                    &self.target_dense_costs,
                    self.target_uses_inner_dense_costs,
                    &mut block_data,
                    &mut work,
                )
            },
        )?;
        envelope.compilation_work = work;
        Ok(envelope)
    }
}

#[allow(clippy::too_many_arguments)]
fn compile_rank_stratified_envelope<F: FiniteField, C>(
    ambient_dimension: usize,
    target_block: usize,
    maximum_rank: usize,
    state_budget: usize,
    zero_cost: u32,
    mut exact_cost: C,
) -> Result<RankStratifiedEnvelope, ContextualError>
where
    C: FnMut(usize, &[u8]) -> Result<u32, ContextualError>,
{
    let mut state_count = 1_u64;
    for rank in 1..=maximum_rank {
        state_count = state_count
            .checked_add(valid_context_subspace_count(
                F::ORDER,
                ambient_dimension,
                rank,
            )?)
            .ok_or(ContextualError::Overflow)?;
    }
    if state_count > state_budget as u64 || state_count > u64::from(u32::MAX) {
        return Err(ContextualError::Overflow);
    }
    let mut strata = Vec::with_capacity(maximum_rank + 1);
    strata.push(RankEnvelopeStratum {
        bases: Box::default(),
        exact_costs: Box::from([zero_cost]),
        envelope_costs: Box::from([zero_cost]),
        envelope_parents: Box::from([EXACT_ENVELOPE_PARENT]),
        restriction_offsets: Box::from([0, 0]),
        restriction_targets: Box::default(),
        lookup_keys: Box::from([0]),
        lookup_states: Box::from([0]),
    });

    let mut pivots = Vec::with_capacity(maximum_rank);
    let mut basis_scratch = vec![0u8; maximum_rank * ambient_dimension];
    let mut free = Vec::with_capacity(maximum_rank * ambient_dimension);
    let mut digits = vec![0u8; maximum_rank * ambient_dimension];
    for rank in 1..=maximum_rank {
        let count = to_usize(valid_context_subspace_count(
            F::ORDER,
            ambient_dimension,
            rank,
        )?)?;
        let width = rank
            .checked_mul(ambient_dimension)
            .ok_or(ContextualError::Overflow)?;
        let mut bases =
            Vec::with_capacity(count.checked_mul(width).ok_or(ContextualError::Overflow)?);
        let mut exact_costs = Vec::with_capacity(count);
        enumerate_rref_subspaces::<F, _>(
            ambient_dimension,
            rank,
            &mut pivots,
            &mut basis_scratch,
            &mut free,
            &mut digits,
            |basis| {
                if rref_contains_coordinate_line(basis, rank, ambient_dimension, target_block) {
                    return Ok(());
                }
                bases.extend_from_slice(basis);
                exact_costs.push(exact_cost(rank, basis)?);
                Ok(())
            },
        )?;
        debug_assert_eq!(exact_costs.len(), count);

        let lookup_capacity = count
            .checked_mul(4)
            .ok_or(ContextualError::Overflow)?
            .div_ceil(3)
            .next_power_of_two();
        let mut lookup_keys = vec![u64::MAX; lookup_capacity];
        let mut lookup_states = vec![u32::MAX; lookup_capacity];
        for (state, basis) in bases.chunks_exact(width).enumerate() {
            let key = encode_subspace::<F>(basis)?;
            let mut slot = mix_subspace_key(key) as usize & (lookup_capacity - 1);
            while lookup_states[slot] != u32::MAX {
                slot = (slot + 1) & (lookup_capacity - 1);
            }
            lookup_keys[slot] = key;
            lookup_states[slot] = u32::try_from(state).map_err(|_| ContextualError::Overflow)?;
        }

        let restrictions_per_state = projective_line_count(F::ORDER, rank)?;
        let edge_capacity = u64::try_from(count)
            .map_err(|_| ContextualError::Overflow)?
            .checked_mul(restrictions_per_state)
            .ok_or(ContextualError::Overflow)?;
        if edge_capacity > u64::from(u32::MAX) {
            return Err(ContextualError::Overflow);
        }
        let mut restriction_offsets = Vec::with_capacity(count + 1);
        let mut restriction_targets = Vec::with_capacity(to_usize(edge_capacity)?);
        let mut envelope_costs = exact_costs.clone();
        let mut envelope_parents = vec![EXACT_ENVELOPE_PARENT; count];
        if rank == 1 {
            for state in 0..count {
                restriction_offsets.push(restriction_targets.len() as u32);
                restriction_targets.push(0);
                if strata[0].envelope_costs[0] < envelope_costs[state] {
                    envelope_costs[state] = strata[0].envelope_costs[0];
                    envelope_parents[state] = 0;
                }
            }
        } else {
            let child_rank = rank - 1;
            let child_width = child_rank * ambient_dimension;
            let mut coefficient_pivots = Vec::with_capacity(child_rank);
            let mut coefficient_basis = vec![0u8; child_rank * rank];
            let mut coefficient_free = Vec::with_capacity(child_rank * rank);
            let mut coefficient_digits = vec![0u8; child_rank * rank];
            let mut child_basis = vec![0u8; child_width];
            let previous = &strata[child_rank];
            for (state, basis) in bases.chunks_exact(width).enumerate() {
                restriction_offsets.push(restriction_targets.len() as u32);
                enumerate_rref_subspaces::<F, _>(
                    rank,
                    child_rank,
                    &mut coefficient_pivots,
                    &mut coefficient_basis,
                    &mut coefficient_free,
                    &mut coefficient_digits,
                    |coefficients| {
                        multiply_rref_bases_into::<F>(
                            coefficients,
                            child_rank,
                            basis,
                            rank,
                            ambient_dimension,
                            &mut child_basis,
                        );
                        let key = encode_subspace::<F>(&child_basis)?;
                        let child =
                            lookup_envelope_state(previous, key).ok_or(ContextualError::Shape)?;
                        restriction_targets.push(child);
                        let child_cost = previous.envelope_costs[child as usize];
                        if child_cost < envelope_costs[state] {
                            envelope_costs[state] = child_cost;
                            envelope_parents[state] = child;
                        }
                        Ok(())
                    },
                )?;
            }
        }
        restriction_offsets.push(restriction_targets.len() as u32);
        debug_assert_eq!(restriction_targets.len(), to_usize(edge_capacity)?);
        strata.push(RankEnvelopeStratum {
            bases: bases.into_boxed_slice(),
            exact_costs: exact_costs.into_boxed_slice(),
            envelope_costs: envelope_costs.into_boxed_slice(),
            envelope_parents: envelope_parents.into_boxed_slice(),
            restriction_offsets: restriction_offsets.into_boxed_slice(),
            restriction_targets: restriction_targets.into_boxed_slice(),
            lookup_keys: lookup_keys.into_boxed_slice(),
            lookup_states: lookup_states.into_boxed_slice(),
        });
    }
    Ok(RankStratifiedEnvelope {
        field_order: F::ORDER,
        ambient_dimension,
        target_block,
        strata: strata.into_boxed_slice(),
        compilation_work: ContextWork::default(),
    })
}

fn gaussian_subspace_count(
    order: u8,
    dimension: usize,
    rank: usize,
) -> Result<u64, ContextualError> {
    if rank > dimension {
        return Ok(0);
    }
    let mut numerator = 1u128;
    let mut denominator = 1u128;
    for index in 0..rank {
        numerator = numerator
            .checked_mul(u128::from(
                checked_pow(u64::from(order), dimension - index)? - 1,
            ))
            .ok_or(ContextualError::Overflow)?;
        denominator = denominator
            .checked_mul(u128::from(checked_pow(u64::from(order), rank - index)? - 1))
            .ok_or(ContextualError::Overflow)?;
    }
    u64::try_from(numerator / denominator).map_err(|_| ContextualError::Overflow)
}

fn valid_context_subspace_count(
    order: u8,
    dimension: usize,
    rank: usize,
) -> Result<u64, ContextualError> {
    gaussian_subspace_count(order, dimension, rank)?
        .checked_sub(gaussian_subspace_count(order, dimension - 1, rank - 1)?)
        .ok_or(ContextualError::Overflow)
}

fn rref_contains_coordinate_line(
    basis: &[u8],
    rank: usize,
    ambient_dimension: usize,
    coordinate: usize,
) -> bool {
    (0..rank).any(|row| {
        let row = &basis[row * ambient_dimension..(row + 1) * ambient_dimension];
        row[coordinate] == 1
            && row
                .iter()
                .enumerate()
                .all(|(column, &entry)| column == coordinate || entry == 0)
    })
}

fn encode_subspace<F: FiniteField>(basis: &[u8]) -> Result<u64, ContextualError> {
    let mut key = 0_u64;
    for &entry in basis {
        key = key
            .checked_mul(u64::from(F::ORDER))
            .and_then(|value| value.checked_add(u64::from(entry)))
            .ok_or(ContextualError::Overflow)?;
    }
    Ok(key)
}

fn lookup_envelope_state(stratum: &RankEnvelopeStratum, key: u64) -> Option<u32> {
    let mask = stratum.lookup_keys.len().checked_sub(1)?;
    let mut slot = mix_subspace_key(key) as usize & mask;
    for _ in 0..stratum.lookup_keys.len() {
        let state = stratum.lookup_states[slot];
        if state == u32::MAX {
            return None;
        }
        if stratum.lookup_keys[slot] == key {
            return Some(state);
        }
        slot = (slot + 1) & mask;
    }
    None
}

#[inline]
fn mix_subspace_key(mut key: u64) -> u64 {
    key ^= key >> 30;
    key = key.wrapping_mul(0xbf58_476d_1ce4_e5b9);
    key ^= key >> 27;
    key = key.wrapping_mul(0x94d0_49bb_1331_11eb);
    key ^ (key >> 31)
}

fn multiply_rref_bases_into<F: FiniteField>(
    coefficients: &[u8],
    output_rows: usize,
    basis: &[u8],
    basis_rows: usize,
    ambient_dimension: usize,
    output: &mut [u8],
) {
    output.fill(0);
    for row in 0..output_rows {
        for middle in 0..basis_rows {
            let scalar = coefficients[row * basis_rows + middle];
            if scalar == 0 {
                continue;
            }
            for col in 0..ambient_dimension {
                let output_index = row * ambient_dimension + col;
                output[output_index] = F::add(
                    output[output_index],
                    F::mul(scalar, basis[middle * ambient_dimension + col]),
                );
            }
        }
    }
}

fn validate_context<F: FiniteField>(
    basis: &Matrix,
    block_count: usize,
    target_block: usize,
) -> Result<Matrix, ContextualError> {
    if basis.cols() != block_count {
        return Err(ContextualError::Shape);
    }
    let basis = basis.canonical_row_basis_field::<F>()?;
    let mut target_line = vec![0u8; block_count];
    target_line[target_block] = 1;
    let target_line = Matrix::new_field::<F>(1, block_count, target_line)?;
    if basis.row_space_contains_field::<F>(&target_line)? {
        return Err(ContextualError::TargetProjection);
    }
    Ok(basis)
}

fn canonicalize_projective_line<F: FiniteField>(
    tuple: &[u8],
    output: &mut [u8],
) -> Result<(), ContextualError> {
    let pivot = tuple
        .iter()
        .copied()
        .find(|&entry| entry != 0)
        .ok_or(ContextualError::Shape)?;
    let inverse = F::inverse(pivot).map_err(MatrixError::from)?;
    for (slot, &entry) in output.iter_mut().zip(tuple) {
        *slot = F::mul(inverse, entry);
    }
    Ok(())
}

fn increment_digits<F: FiniteField>(digits: &mut [u8]) -> bool {
    for digit in digits.iter_mut().rev() {
        *digit += 1;
        if *digit < F::ORDER {
            return true;
        }
        *digit = 0;
    }
    false
}

fn combine_rows<F: FiniteField>(basis: &Matrix, coefficients: &[u8], output: &mut [u8]) {
    output.fill(0);
    for (row, &coefficient) in coefficients.iter().enumerate() {
        if coefficient == 0 {
            continue;
        }
        for (slot, &entry) in output.iter_mut().zip(basis.row(row)) {
            *slot = F::add(*slot, F::mul(coefficient, entry));
        }
    }
}

fn multiply_bases_into<F: FiniteField>(
    coefficients: &[u8],
    rank: usize,
    ambient: &Matrix,
    output: &mut [u8],
) {
    output.fill(0);
    if F::ORDER == 2 {
        for row in 0..rank {
            for middle in 0..ambient.rows() {
                if coefficients[row * ambient.rows() + middle] == 0 {
                    continue;
                }
                let output = &mut output[row * ambient.cols()..(row + 1) * ambient.cols()];
                for (entry, &addend) in output.iter_mut().zip(ambient.row(middle)) {
                    *entry ^= addend;
                }
            }
        }
        return;
    }
    for row in 0..rank {
        for middle in 0..ambient.rows() {
            let scalar = coefficients[row * ambient.rows() + middle];
            for col in 0..ambient.cols() {
                let index = row * ambient.cols() + col;
                output[index] = F::add(
                    output[index],
                    F::mul(scalar, ambient.as_slice()[middle * ambient.cols() + col]),
                );
            }
        }
    }
}

fn enumerate_rref_subspaces<F: FiniteField, C>(
    ambient_dimension: usize,
    rank: usize,
    pivots: &mut Vec<usize>,
    data: &mut [u8],
    free: &mut Vec<(usize, usize)>,
    digits: &mut [u8],
    mut callback: C,
) -> Result<(), ContextualError>
where
    C: FnMut(&[u8]) -> Result<(), ContextualError>,
{
    pivots.clear();
    let data = &mut data[..rank * ambient_dimension];
    let digits = &mut digits[..rank * ambient_dimension];
    pivots.extend(0..rank);
    loop {
        enumerate_free_entries::<F, C>(
            ambient_dimension,
            pivots,
            data,
            free,
            digits,
            &mut callback,
        )?;

        let Some(index) = (0..rank)
            .rev()
            .find(|&index| pivots[index] < ambient_dimension - rank + index)
        else {
            return Ok(());
        };
        pivots[index] += 1;
        for suffix in index + 1..rank {
            pivots[suffix] = pivots[suffix - 1] + 1;
        }
    }
}

fn enumerate_free_entries<F: FiniteField, C>(
    ambient_dimension: usize,
    pivots: &[usize],
    data: &mut [u8],
    free: &mut Vec<(usize, usize)>,
    digits: &mut [u8],
    callback: &mut C,
) -> Result<(), ContextualError>
where
    C: FnMut(&[u8]) -> Result<(), ContextualError>,
{
    let rank = pivots.len();
    data.fill(0);
    for (row, &pivot) in pivots.iter().enumerate() {
        data[row * ambient_dimension + pivot] = 1;
    }
    free.clear();
    for row in 0..rank {
        for col in (pivots[row] + 1)..ambient_dimension {
            if !pivots.contains(&col) {
                free.push((row, col));
            }
        }
    }
    let digits = &mut digits[..free.len()];
    digits.fill(0);
    loop {
        for (&(row, col), &value) in free.iter().zip(digits.iter()) {
            data[row * ambient_dimension + col] = value;
        }
        callback(data)?;
        if !increment_digits::<F>(digits) {
            break;
        }
    }
    Ok(())
}

fn full_rank_map_storage_bytes<F: FiniteField>(
    rank: usize,
    target_rank: usize,
) -> Result<Option<usize>, ContextualError> {
    let vector_count = checked_pow(u64::from(F::ORDER), target_rank)?;
    let mut map_count = 1_u64;
    for dimension in 0..rank {
        let dependent = checked_pow(u64::from(F::ORDER), dimension)?;
        map_count = match map_count.checked_mul(vector_count - dependent) {
            Some(count) => count,
            None => return Ok(None),
        };
    }
    let width = match rank.checked_mul(target_rank) {
        Some(width) => width,
        None => return Ok(None),
    };
    Ok(map_count
        .checked_mul(width as u64)
        .and_then(|bytes| usize::try_from(bytes).ok()))
}

fn enumerate_full_rank_maps<F: FiniteField>(
    rank: usize,
    target_rank: usize,
    expected_bytes: usize,
) -> Box<[u8]> {
    let width = rank * target_rank;
    let mut maps = Vec::with_capacity(expected_bytes);
    let mut coefficients = vec![0_u8; width];
    let mut rank_scratch = vec![0_u8; width];
    while increment_digits::<F>(&mut coefficients) {
        if matrix_rank::<F>(&coefficients, rank, target_rank, &mut rank_scratch) == rank {
            maps.extend_from_slice(&coefficients);
        }
    }
    debug_assert_eq!(maps.len(), expected_bytes);
    maps.into_boxed_slice()
}

fn dense_cost_directory<F: FiniteField>(
    table: &CostTable,
    label_len: usize,
) -> Result<DenseCostDirectory, ContextualError> {
    let entry_count = checked_pow(u64::from(F::ORDER), label_len)?;
    if entry_count > DENSE_COST_DIRECTORY_ENTRIES {
        return Ok(DenseCostDirectory::default());
    }
    let mut label = vec![0_u8; label_len];
    let entry_count = to_usize(entry_count)?;
    let presence_words = entry_count
        .checked_add(31)
        .ok_or(ContextualError::Overflow)?
        / 32;
    let storage_len = entry_count
        .checked_add(presence_words)
        .ok_or(ContextualError::Overflow)?;
    let mut storage = vec![0_u32; storage_len];
    let mut index = 0_usize;
    loop {
        if let Some(cost) = table.cost_slice(&label) {
            storage[index] = cost;
            storage[entry_count + index / 32] |= 1_u32 << (index % 32);
        }
        index += 1;
        if !increment_digits::<F>(&mut label) {
            break;
        }
    }
    debug_assert_eq!(index, entry_count);
    Ok(DenseCostDirectory {
        storage: storage.into_boxed_slice(),
        cost_len: entry_count,
    })
}

#[allow(clippy::too_many_arguments)]
fn atomic_subspace_cost<F: FiniteField>(
    subspace: &[u8],
    rank: usize,
    block_count: usize,
    target_rank: usize,
    inner: &CostTable,
    target: &CostTable,
    target_block: usize,
    zero_cost: u32,
    coefficients: &mut [u8],
    rank_scratch: &mut [u8],
    full_rank_maps: &[u8],
    inner_dense_costs: &DenseCostDirectory,
    target_dense_costs: &DenseCostDirectory,
    target_uses_inner_dense_costs: bool,
    block_data: &mut [u8],
    work: &mut ContextWork,
) -> Result<u32, ContextualError> {
    let mut best = zero_cost;
    if !full_rank_maps.is_empty() {
        for coefficients in full_rank_maps.chunks_exact(rank * target_rank) {
            work.generator_candidates = work
                .generator_candidates
                .checked_add(1)
                .ok_or(ContextualError::Overflow)?;
            let cost = coefficient_map_cost::<F>(
                subspace,
                rank,
                block_count,
                target_rank,
                inner,
                target,
                target_block,
                best,
                coefficients,
                inner_dense_costs,
                target_dense_costs,
                target_uses_inner_dense_costs,
                block_data,
            )?;
            best = best.min(cost);
        }
        return Ok(best);
    }

    coefficients.fill(0);
    while increment_digits::<F>(coefficients) {
        if matrix_rank::<F>(coefficients, rank, target_rank, rank_scratch) != rank {
            continue;
        }
        work.generator_candidates = work
            .generator_candidates
            .checked_add(1)
            .ok_or(ContextualError::Overflow)?;
        let cost = coefficient_map_cost::<F>(
            subspace,
            rank,
            block_count,
            target_rank,
            inner,
            target,
            target_block,
            best,
            coefficients,
            inner_dense_costs,
            target_dense_costs,
            target_uses_inner_dense_costs,
            block_data,
        )?;
        best = best.min(cost);
    }
    Ok(best)
}

#[allow(clippy::too_many_arguments)]
#[inline]
fn coefficient_map_cost<F: FiniteField>(
    subspace: &[u8],
    rank: usize,
    block_count: usize,
    target_rank: usize,
    inner: &CostTable,
    target: &CostTable,
    target_block: usize,
    cutoff: u32,
    coefficients: &[u8],
    inner_dense_costs: &DenseCostDirectory,
    target_dense_costs: &DenseCostDirectory,
    target_uses_inner_dense_costs: bool,
    block_data: &mut [u8],
) -> Result<u32, ContextualError> {
    if !inner_dense_costs.storage.is_empty()
        && (target_uses_inner_dense_costs || !target_dense_costs.storage.is_empty())
    {
        return coefficient_map_dense_cost::<F>(
            subspace,
            rank,
            block_count,
            target_rank,
            target_block,
            cutoff,
            coefficients,
            inner_dense_costs,
            target_dense_costs,
            target_uses_inner_dense_costs,
        );
    }
    block_data.fill(0);
    for block in 0..block_count {
        let label = &mut block_data[block * target_rank..(block + 1) * target_rank];
        for row in 0..rank {
            let outer = subspace[row * block_count + block];
            if outer == 0 {
                continue;
            }
            for col in 0..target_rank {
                label[col] = F::add(
                    label[col],
                    F::mul(outer, coefficients[row * target_rank + col]),
                );
            }
        }
    }
    let mut cost = 0u32;
    for block in 0..block_count {
        let label = &block_data[block * target_rank..(block + 1) * target_rank];
        let table = if block == target_block { target } else { inner };
        let dense_costs = if block == target_block {
            if target_uses_inner_dense_costs {
                inner_dense_costs
            } else {
                target_dense_costs
            }
        } else {
            inner_dense_costs
        };
        let local = if dense_costs.storage.is_empty() {
            table.cost_slice(label)
        } else {
            dense_costs.lookup::<F>(label)
        };
        let Some(local) = local else {
            return Ok(cutoff);
        };
        cost = cost.checked_add(local).ok_or(ContextualError::Overflow)?;
        if cost >= cutoff {
            return Ok(cost);
        }
    }
    Ok(cost)
}

#[allow(clippy::too_many_arguments)]
#[inline]
fn coefficient_map_dense_cost<F: FiniteField>(
    subspace: &[u8],
    rank: usize,
    block_count: usize,
    target_rank: usize,
    target_block: usize,
    cutoff: u32,
    coefficients: &[u8],
    inner_dense_costs: &DenseCostDirectory,
    target_dense_costs: &DenseCostDirectory,
    target_uses_inner_dense_costs: bool,
) -> Result<u32, ContextualError> {
    let mut cost = 0_u32;
    for block in 0..block_count {
        let mut index = 0_usize;
        for col in 0..target_rank {
            let mut value = 0_u8;
            if F::ORDER == 2 {
                for row in 0..rank {
                    if subspace[row * block_count + block] != 0 {
                        value ^= coefficients[row * target_rank + col];
                    }
                }
            } else {
                for row in 0..rank {
                    let outer = subspace[row * block_count + block];
                    if outer == 0 {
                        continue;
                    }
                    value = F::add(value, F::mul(outer, coefficients[row * target_rank + col]));
                }
            }
            index = index * F::ORDER as usize + value as usize;
        }
        let directory = if block == target_block && !target_uses_inner_dense_costs {
            target_dense_costs
        } else {
            inner_dense_costs
        };
        let Some(local) = directory.lookup_index(index) else {
            return Ok(cutoff);
        };
        cost = cost.checked_add(local).ok_or(ContextualError::Overflow)?;
        if cost >= cutoff {
            return Ok(cost);
        }
    }
    Ok(cost)
}

fn matrix_rank<F: FiniteField>(data: &[u8], rows: usize, cols: usize, scratch: &mut [u8]) -> usize {
    scratch.copy_from_slice(data);
    let mut rank = 0;
    for col in 0..cols {
        let Some(pivot) = (rank..rows).find(|&row| scratch[row * cols + col] != 0) else {
            continue;
        };
        for entry_col in 0..cols {
            scratch.swap(rank * cols + entry_col, pivot * cols + entry_col);
        }
        let inverse = F::inverse(scratch[rank * cols + col]).expect("nonzero pivot");
        for entry_col in col..cols {
            scratch[rank * cols + entry_col] = F::mul(inverse, scratch[rank * cols + entry_col]);
        }
        for row in 0..rows {
            if row == rank {
                continue;
            }
            let factor = scratch[row * cols + col];
            for entry_col in col..cols {
                scratch[row * cols + entry_col] = F::sub(
                    scratch[row * cols + entry_col],
                    F::mul(factor, scratch[rank * cols + entry_col]),
                );
            }
        }
        rank += 1;
        if rank == rows {
            break;
        }
    }
    rank
}

fn direct_context_cost<F: FiniteField>(
    basis: &Matrix,
    block_count: usize,
    inner: &CostTable,
    target: &CostTable,
    target_block: usize,
    inner_dual_distance: u32,
) -> Result<ContextCost, ContextualError> {
    let answer = confinement_by_generators_field::<F>(
        basis,
        block_count,
        inner,
        target,
        target_block,
        inner_dual_distance,
    )?;
    Ok(ContextCost {
        cost: answer.cost,
        sector: answer.sector,
        work: ContextWork {
            generator_candidates: answer.transitions,
            ..ContextWork::default()
        },
    })
}

fn choose_plan(
    strategy: ContextStrategy,
    amortization_queries: u32,
    estimated_cache_entries: u64,
    estimated_entry_bytes: u64,
) -> Result<ContextPlan, ContextualError> {
    let estimated_cache_bytes = estimated_cache_entries
        .checked_mul(estimated_entry_bytes)
        .ok_or(ContextualError::Overflow)?;
    let (execution, expected_queries) = match strategy {
        ContextStrategy::Direct => (ContextExecution::Direct, 1),
        ContextStrategy::Cached => (ContextExecution::Cached, amortization_queries),
        ContextStrategy::Auto {
            expected_queries,
            memory_budget_bytes,
        } => {
            if expected_queries == 0 {
                return Err(ContextualError::Shape);
            }
            let fits =
                u64::try_from(memory_budget_bytes).unwrap_or(u64::MAX) >= estimated_cache_bytes;
            (
                if expected_queries >= amortization_queries && fits {
                    ContextExecution::Cached
                } else {
                    ContextExecution::Direct
                },
                expected_queries,
            )
        }
    };
    Ok(ContextPlan {
        execution,
        expected_queries,
        amortization_queries,
        estimated_cache_entries,
        estimated_cache_bytes,
    })
}

fn cache_entry_bytes(key_len: usize) -> Result<u64, ContextualError> {
    u64::try_from(key_len)
        .map_err(|_| ContextualError::Overflow)?
        .checked_add(CACHE_RECORD_AND_INDEX_BYTES)
        .ok_or(ContextualError::Overflow)
}

fn projective_line_count(order: u8, dimension: usize) -> Result<u64, ContextualError> {
    let numerator = checked_pow(u64::from(order), dimension)?
        .checked_sub(1)
        .ok_or(ContextualError::Overflow)?;
    Ok(numerator / (u64::from(order) - 1))
}

fn rank_bounded_subspace_count(
    order: u8,
    dimension: usize,
    max_rank: usize,
) -> Result<u64, ContextualError> {
    let mut total = 0u64;
    for rank in 1..=max_rank {
        let mut numerator = 1u128;
        let mut denominator = 1u128;
        for index in 0..rank {
            numerator = numerator
                .checked_mul(u128::from(
                    checked_pow(u64::from(order), dimension - index)? - 1,
                ))
                .ok_or(ContextualError::Overflow)?;
            denominator = denominator
                .checked_mul(u128::from(checked_pow(u64::from(order), rank - index)? - 1))
                .ok_or(ContextualError::Overflow)?;
        }
        let gaussian =
            u64::try_from(numerator / denominator).map_err(|_| ContextualError::Overflow)?;
        total = total
            .checked_add(gaussian)
            .ok_or(ContextualError::Overflow)?;
    }
    Ok(total)
}

fn checked_pow(base: u64, exponent: usize) -> Result<u64, ContextualError> {
    let mut value = 1u64;
    for _ in 0..exponent {
        value = value.checked_mul(base).ok_or(ContextualError::Overflow)?;
    }
    Ok(value)
}

fn to_usize(value: u64) -> Result<usize, ContextualError> {
    usize::try_from(value).map_err(|_| ContextualError::Overflow)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::field::Gf4;

    fn scalar_table<F: FiniteField>(costs: &[u32]) -> CostTable {
        CostTable::from_entries_field::<F>(
            1,
            1,
            costs.iter().enumerate().map(|(label, &cost)| {
                (
                    Matrix::new_field::<F>(1, 1, vec![label as u8]).unwrap(),
                    cost,
                )
            }),
        )
        .unwrap()
    }

    #[test]
    fn rank_one_projective_cache_matches_direct_context_cost() {
        let inner = scalar_table::<Gf4>(&[0, 1, 1, 2]);
        let target = scalar_table::<Gf4>(&[1, 0, 2, 1]);
        let dual = Matrix::new_field::<Gf4>(2, 3, vec![1, 1, 0, 0, 1, 1]).unwrap();
        let direct =
            confinement_by_generators_field::<Gf4>(&dual, 3, &inner, &target, 0, 2).unwrap();
        let mut cache = RankOneProbeCache::<Gf4>::new(&inner, &target, 3, 0, 2).unwrap();
        let first = cache.context_cost_cached(&dual).unwrap();
        let second = cache.context_cost_cached(&dual).unwrap();
        assert_eq!(first.cost, direct.cost);
        assert_eq!(second.cost, direct.cost);
        assert_eq!(second.work.scalar_probes, 0);
        assert_eq!(second.work.cache_hits, second.work.distinct_subspaces);
        let warm_default = cache
            .context_cost_planned(&dual, ContextStrategy::default())
            .unwrap();
        assert_eq!(warm_default.plan.execution, ContextExecution::Cached);
        assert_eq!(warm_default.result.work.scalar_probes, 0);
        assert_eq!(
            warm_default.result.work.cache_hits,
            warm_default.result.work.distinct_subspaces
        );
    }

    #[test]
    fn rank_bounded_contexts_match_direct_rank_two_cost() {
        let entries = (0u8..4).map(|bits| {
            let label = Matrix::new::<2>(1, 2, vec![bits & 1, (bits >> 1) & 1]).unwrap();
            let cost = label.as_slice().iter().filter(|&&x| x != 0).count() as u32;
            (label, cost)
        });
        let inner = CostTable::from_entries::<2>(1, 2, entries).unwrap();
        let target = inner.clone();
        let dual = Matrix::new::<2>(3, 4, vec![1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1]).unwrap();
        let direct = confinement_by_generators_field::<crate::field::Prime<2>>(
            &dual, 4, &inner, &target, 0, 2,
        )
        .unwrap();
        let mut cache =
            RankBoundedContextCache::<crate::field::Prime<2>>::new(&inner, &target, 4, 0, 2)
                .unwrap();
        let bounded = cache.context_cost_cached(&dual).unwrap();
        assert_eq!(bounded.cost, direct.cost);
        assert_eq!(bounded.work.generator_candidates, direct.transitions);
        assert_eq!(cache.compiled_kernel_payload_bytes(), 70);
        let warm_default = cache
            .context_cost_planned(&dual, ContextStrategy::default())
            .unwrap();
        assert_eq!(warm_default.plan.execution, ContextExecution::Cached);
        assert_eq!(warm_default.result.work.generator_candidates, 0);
        assert_eq!(
            warm_default.result.work.cache_hits,
            warm_default.result.work.distinct_subspaces
        );
        let mut planned =
            RankBoundedContextCache::<crate::field::Prime<2>>::new(&inner, &target, 4, 0, 2)
                .unwrap();
        let one_shot = planned
            .context_cost_planned(
                &dual,
                ContextStrategy::Auto {
                    expected_queries: 1,
                    memory_budget_bytes: usize::MAX,
                },
            )
            .unwrap();
        assert_eq!(one_shot.plan.execution, ContextExecution::Direct);
        assert_eq!(planned.cached_context_count(), 0);
        assert_eq!(planned.compiled_kernel_payload_bytes(), 0);
        let default = planned.context_cost(&dual).unwrap();
        assert_eq!(default.cost, direct.cost);
        assert_eq!(planned.cached_context_count(), 0);
        assert_eq!(planned.compiled_kernel_payload_bytes(), 0);
    }

    #[test]
    fn rank_stratified_envelope_matches_direct_contexts_and_replays_parent() {
        let inner = rank_two_table::<crate::field::Prime<2>>();
        let target = inner.clone();
        let mut cache =
            RankBoundedContextCache::<crate::field::Prime<2>>::new(&inner, &target, 4, 0, 2)
                .unwrap();
        let envelope = cache.compile_full_span_envelope(3, 51).unwrap();
        let storage = envelope.storage();
        assert_eq!(storage.states, 51);
        assert_eq!(storage.restriction_edges, 154);
        assert_eq!(envelope.compilation_work().distinct_subspaces, 50);

        let mut contexts = vec![Matrix::new::<2>(2, 4, vec![1, 1, 0, 0, 0, 1, 1, 0]).unwrap()];
        for tail in 0..8usize {
            let mut data = vec![0u8; 12];
            for row in 0..3 {
                data[row * 4] = ((tail >> row) & 1) as u8;
                data[row * 4 + row + 1] = 1;
            }
            contexts.push(Matrix::new::<2>(3, 4, data).unwrap());
        }
        for context in contexts {
            let direct = confinement_by_generators_field::<crate::field::Prime<2>>(
                &context, 4, &inner, &target, 0, 2,
            )
            .unwrap();
            let answer = envelope
                .context_cost::<crate::field::Prime<2>>(&context)
                .unwrap();
            assert_eq!(answer.cost, direct.cost);
            assert!(answer.exact_rank <= 2);
            assert!(envelope
                .exact_basis(answer.exact_rank as usize, answer.exact_state)
                .is_some());
        }
    }

    fn rank_two_table<F: FiniteField>() -> CostTable {
        let mut entries = Vec::with_capacity(F::ORDER as usize * F::ORDER as usize);
        for left in 0..F::ORDER {
            for right in 0..F::ORDER {
                let label = Matrix::new_field::<F>(1, 2, [left, right]).unwrap();
                let cost = u32::from(left != 0) + u32::from(right != 0) + u32::from(left != right);
                entries.push((label, cost));
            }
        }
        CostTable::from_entries_field::<F>(1, 2, entries).unwrap()
    }

    fn assert_rank_two_cached_matches_direct<F: FiniteField>(expected_payload: usize) {
        let inner = rank_two_table::<F>();
        let target = inner.clone();
        let dual = Matrix::new_field::<F>(2, 4, [1, 1, 0, 0, 0, 1, 1, 0]).unwrap();
        let direct = confinement_by_generators_field::<F>(&dual, 4, &inner, &target, 0, 2).unwrap();
        let mut cache = RankBoundedContextCache::<F>::new(&inner, &target, 4, 0, 2).unwrap();
        let cold = cache.context_cost_cached(&dual).unwrap();
        let warm = cache.context_cost_cached(&dual).unwrap();
        assert_eq!(cold.cost, direct.cost);
        assert_eq!(cold.work.generator_candidates, direct.transitions);
        assert_eq!(warm.cost, direct.cost);
        assert_eq!(warm.work.cache_hits, warm.work.distinct_subspaces);
        assert_eq!(cache.compiled_kernel_payload_bytes(), expected_payload);
    }

    #[test]
    fn rank_bounded_compiled_kernels_cover_prime_and_extension_fields() {
        assert_rank_two_cached_matches_direct::<crate::field::Prime<3>>(288);
        assert_rank_two_cached_matches_direct::<crate::field::Gf4>(886);
    }

    #[test]
    fn auto_skips_cache_when_reuse_or_memory_is_too_small() {
        let inner = scalar_table::<Gf4>(&[0, 1, 1, 2]);
        let target = scalar_table::<Gf4>(&[1, 0, 2, 1]);
        let dual = Matrix::new_field::<Gf4>(2, 3, vec![1, 1, 0, 0, 1, 1]).unwrap();
        let mut cache = RankOneProbeCache::<Gf4>::new(&inner, &target, 3, 0, 2).unwrap();
        let one_shot = cache
            .context_cost_planned(
                &dual,
                ContextStrategy::Auto {
                    expected_queries: 1,
                    memory_budget_bytes: usize::MAX,
                },
            )
            .unwrap();
        assert_eq!(one_shot.plan.execution, ContextExecution::Cached);
        assert!(cache.cached_probe_count() > 0);
        let mut default_cache = RankOneProbeCache::<Gf4>::new(&inner, &target, 3, 0, 2).unwrap();
        assert_eq!(
            default_cache.context_cost(&dual).unwrap().cost,
            one_shot.result.cost
        );
        assert!(default_cache.cached_probe_count() > 0);
        let mut constrained_cache =
            RankOneProbeCache::<Gf4>::new(&inner, &target, 3, 0, 2).unwrap();
        let constrained = constrained_cache
            .context_cost_planned(
                &dual,
                ContextStrategy::Auto {
                    expected_queries: 1,
                    memory_budget_bytes: 0,
                },
            )
            .unwrap();
        assert_eq!(constrained.plan.execution, ContextExecution::Direct);
        assert_eq!(constrained_cache.cached_probe_count(), 0);
        let reused = constrained_cache
            .context_cost_planned(
                &dual,
                ContextStrategy::Auto {
                    expected_queries: PROJECTIVE_AMORTIZATION_QUERIES,
                    memory_budget_bytes: usize::MAX,
                },
            )
            .unwrap();
        assert_eq!(reused.plan.execution, ContextExecution::Cached);
        assert!(constrained_cache.cached_probe_count() > 0);
    }

    #[test]
    fn auto_budget_boundary_and_long_keys_are_exact() {
        let inner = scalar_table::<Gf4>(&[0, 1, 1, 2]);
        let target = scalar_table::<Gf4>(&[1, 0, 2, 1]);
        let dual = Matrix::new_field::<Gf4>(2, 3, vec![1, 1, 0, 0, 1, 1]).unwrap();
        let estimate = RankOneProbeCache::<Gf4>::new(&inner, &target, 3, 0, 2)
            .unwrap()
            .context_cost_planned(&dual, ContextStrategy::Direct)
            .unwrap()
            .plan
            .estimated_cache_bytes;
        let mut below = RankOneProbeCache::<Gf4>::new(&inner, &target, 3, 0, 2).unwrap();
        let below_plan = below
            .context_cost_planned(
                &dual,
                ContextStrategy::Auto {
                    expected_queries: 1,
                    memory_budget_bytes: usize::try_from(estimate - 1).unwrap(),
                },
            )
            .unwrap();
        assert_eq!(below_plan.plan.execution, ContextExecution::Direct);
        assert_eq!(below.cached_probe_count(), 0);
        let mut boundary = RankOneProbeCache::<Gf4>::new(&inner, &target, 3, 0, 2).unwrap();
        let boundary_plan = boundary
            .context_cost_planned(
                &dual,
                ContextStrategy::Auto {
                    expected_queries: 1,
                    memory_budget_bytes: usize::try_from(estimate).unwrap(),
                },
            )
            .unwrap();
        assert_eq!(boundary_plan.plan.execution, ContextExecution::Cached);

        let mut long_vector = vec![0u8; 64];
        long_vector[1] = 1;
        let long_dual = Matrix::new_field::<Gf4>(1, 64, long_vector).unwrap();
        let long_plan = RankOneProbeCache::<Gf4>::new(&inner, &target, 64, 0, 2)
            .unwrap()
            .context_cost_planned(&long_dual, ContextStrategy::Direct)
            .unwrap();
        assert_eq!(long_plan.plan.estimated_cache_entries, 1);
        assert_eq!(long_plan.plan.estimated_cache_bytes, 64 + 32);

        let invalid = RankOneProbeCache::<Gf4>::new(&inner, &target, 3, 0, 2)
            .unwrap()
            .context_cost_planned(
                &dual,
                ContextStrategy::Auto {
                    expected_queries: 0,
                    memory_budget_bytes: usize::MAX,
                },
            );
        assert!(matches!(invalid, Err(ContextualError::Shape)));
    }

    #[test]
    fn caches_complete_partial_nonempty_state() {
        let scalar = scalar_table::<crate::field::Prime<2>>(&[0, 1]);
        let first = Matrix::new::<2>(2, 4, vec![0, 1, 1, 0, 0, 0, 1, 1]).unwrap();
        let second = Matrix::new::<2>(2, 4, vec![0, 1, 0, 1, 0, 0, 0, 1]).unwrap();
        let direct = confinement_by_generators_field::<crate::field::Prime<2>>(
            &second, 4, &scalar, &scalar, 0, 2,
        )
        .unwrap();
        let mut projective =
            RankOneProbeCache::<crate::field::Prime<2>>::new(&scalar, &scalar, 4, 0, 2).unwrap();
        projective.context_cost_cached(&first).unwrap();
        let before = projective.cached_probe_count();
        let completed = projective.context_cost_cached(&second).unwrap();
        assert_eq!(completed.cost, direct.cost);
        assert!(projective.cached_probe_count() > before);
        let warm = projective.context_cost_cached(&second).unwrap();
        assert_eq!(warm.work.cache_hits, warm.work.distinct_subspaces);

        let entries = (0u8..4).map(|bits| {
            let label = Matrix::new::<2>(1, 2, vec![bits & 1, (bits >> 1) & 1]).unwrap();
            let cost = label.as_slice().iter().filter(|&&x| x != 0).count() as u32;
            (label, cost)
        });
        let rank_two = CostTable::from_entries::<2>(1, 2, entries).unwrap();
        let first = Matrix::new::<2>(2, 5, vec![0, 1, 1, 0, 0, 0, 0, 1, 1, 0]).unwrap();
        let second = Matrix::new::<2>(2, 5, vec![0, 1, 0, 1, 0, 0, 0, 1, 0, 1]).unwrap();
        let direct = confinement_by_generators_field::<crate::field::Prime<2>>(
            &second, 5, &rank_two, &rank_two, 0, 2,
        )
        .unwrap();
        let mut bounded =
            RankBoundedContextCache::<crate::field::Prime<2>>::new(&rank_two, &rank_two, 5, 0, 2)
                .unwrap();
        bounded.context_cost_cached(&first).unwrap();
        let before = bounded.cached_context_count();
        let completed = bounded.context_cost_cached(&second).unwrap();
        assert_eq!(completed.cost, direct.cost);
        assert!(bounded.cached_context_count() > before);
        let warm = bounded.context_cost_cached(&second).unwrap();
        assert_eq!(warm.work.cache_hits, warm.work.distinct_subspaces);
    }
}
