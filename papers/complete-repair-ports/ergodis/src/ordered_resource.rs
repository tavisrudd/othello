//! Exact finite ordered-resource algebras and Pareto composition.

use crate::observational::FrozenObservation;
use thiserror::Error;

/// Finite ordered commutative monoid with compact elements `0..element_count`.
///
/// Call [`validate_finite_ordered_monoid`] at an adapter or trust boundary
/// before relying on the algebraic laws for contextual compilation.
pub trait FiniteOrderedMonoid {
    fn element_count(&self) -> u32;
    fn identity(&self) -> u32;
    fn combine(&self, left: u32, right: u32) -> u32;
    fn leq(&self, left: u32, right: u32) -> bool;
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct OrderedMonoidCertificate {
    pub elements: u32,
}

#[derive(Debug, Error, PartialEq, Eq)]
pub enum OrderedResourceError {
    #[error("an ordered monoid needs at least one element")]
    Empty,
    #[error("ordered-monoid element {element} is out of range")]
    Element { element: u32 },
    #[error("element {element} violates the identity law")]
    Identity { element: u32 },
    #[error("elements {left} and {right} violate commutativity")]
    Commutative { left: u32, right: u32 },
    #[error("elements {first}, {second}, and {third} violate associativity")]
    Associative { first: u32, second: u32, third: u32 },
    #[error("the order is not reflexive at element {element}")]
    Reflexive { element: u32 },
    #[error("distinct elements {left} and {right} violate antisymmetry")]
    Antisymmetric { left: u32, right: u32 },
    #[error("elements {first}, {second}, and {third} violate transitivity")]
    Transitive { first: u32, second: u32, third: u32 },
    #[error("order monotonicity fails for {left} <= {right} after adding {addend}")]
    Monotone { left: u32, right: u32, addend: u32 },
    #[error("extensivity fails for elements {left} and {right}")]
    Extensive { left: u32, right: u32 },
    #[error("a resource-space dimension or product exceeds compact storage")]
    Overflow,
    #[error("resource vector has the wrong dimension or exceeds its cap")]
    ResourceShape,
    #[error("Pareto workspace needs capacity {required}, but has {capacity}")]
    WorkspaceCapacity { required: usize, capacity: usize },
}

/// Exhaustively certify the laws needed by the finite ordered-monoid theorem.
pub fn validate_finite_ordered_monoid<M: FiniteOrderedMonoid>(
    monoid: &M,
) -> Result<OrderedMonoidCertificate, OrderedResourceError> {
    let count = monoid.element_count();
    if count == 0 {
        return Err(OrderedResourceError::Empty);
    }
    let identity = monoid.identity();
    validate_element(count, identity)?;
    for left in 0..count {
        if !monoid.leq(left, left) {
            return Err(OrderedResourceError::Reflexive { element: left });
        }
        let identity_left = monoid.combine(identity, left);
        let left_identity = monoid.combine(left, identity);
        validate_element(count, identity_left)?;
        validate_element(count, left_identity)?;
        if identity_left != left || left_identity != left {
            return Err(OrderedResourceError::Identity { element: left });
        }
        for right in 0..count {
            let sum = monoid.combine(left, right);
            validate_element(count, sum)?;
            let reverse_sum = monoid.combine(right, left);
            validate_element(count, reverse_sum)?;
            if sum != reverse_sum {
                return Err(OrderedResourceError::Commutative { left, right });
            }
            if left != right && monoid.leq(left, right) && monoid.leq(right, left) {
                return Err(OrderedResourceError::Antisymmetric { left, right });
            }
            if !monoid.leq(left, sum) {
                return Err(OrderedResourceError::Extensive { left, right });
            }
            for third in 0..count {
                let sum_third = monoid.combine(sum, third);
                let right_third = monoid.combine(right, third);
                validate_element(count, sum_third)?;
                validate_element(count, right_third)?;
                let left_right_third = monoid.combine(left, right_third);
                validate_element(count, left_right_third)?;
                if sum_third != left_right_third {
                    return Err(OrderedResourceError::Associative {
                        first: left,
                        second: right,
                        third,
                    });
                }
                let left_third = monoid.combine(left, third);
                validate_element(count, left_third)?;
                if monoid.leq(left, right) && !monoid.leq(left_third, right_third) {
                    return Err(OrderedResourceError::Monotone {
                        left,
                        right,
                        addend: third,
                    });
                }
                if monoid.leq(left, right) && monoid.leq(right, third) && !monoid.leq(left, third) {
                    return Err(OrderedResourceError::Transitive {
                        first: left,
                        second: right,
                        third,
                    });
                }
            }
        }
    }
    Ok(OrderedMonoidCertificate { elements: count })
}

fn validate_element(count: u32, element: u32) -> Result<(), OrderedResourceError> {
    if element >= count {
        return Err(OrderedResourceError::Element { element });
    }
    Ok(())
}

/// Coordinatewise ordered resource vectors with capped additive composition.
#[derive(Clone, Debug)]
pub struct CappedAdditiveMonoid {
    caps: Box<[u16]>,
    strides: Box<[u32]>,
    element_count: u32,
    boolean_dimensions: bool,
}

impl CappedAdditiveMonoid {
    pub fn new(caps: impl Into<Box<[u16]>>) -> Result<Self, OrderedResourceError> {
        let caps = caps.into();
        let mut strides = Vec::with_capacity(caps.len());
        let mut count = 1_u32;
        for &cap in caps.iter() {
            strides.push(count);
            count = count
                .checked_mul(u32::from(cap) + 1)
                .ok_or(OrderedResourceError::Overflow)?;
        }
        Ok(Self {
            boolean_dimensions: caps.iter().all(|&cap| cap == 1),
            caps,
            strides: strides.into_boxed_slice(),
            element_count: count,
        })
    }

    pub fn caps(&self) -> &[u16] {
        &self.caps
    }

    /// Constant-time certificate for this proof-by-construction monoid.
    ///
    /// Generic adapters need [`validate_finite_ordered_monoid`], whose
    /// exhaustive cubic audit is intended only for small opaque algebras.
    pub fn certificate(&self) -> OrderedMonoidCertificate {
        OrderedMonoidCertificate {
            elements: self.element_count,
        }
    }

    pub fn encode(&self, resources: &[u16]) -> Result<u32, OrderedResourceError> {
        if resources.len() != self.caps.len()
            || resources
                .iter()
                .zip(self.caps.iter())
                .any(|(&value, &cap)| value > cap)
        {
            return Err(OrderedResourceError::ResourceShape);
        }
        Ok(resources
            .iter()
            .zip(self.strides.iter())
            .map(|(&value, &stride)| u32::from(value) * stride)
            .sum())
    }

    pub fn decode(&self, element: u32) -> Result<Box<[u16]>, OrderedResourceError> {
        validate_element(self.element_count, element)?;
        Ok(self
            .caps
            .iter()
            .zip(self.strides.iter())
            .map(|(&cap, &stride)| ((element / stride) % (u32::from(cap) + 1)) as u16)
            .collect())
    }
}

impl FiniteOrderedMonoid for CappedAdditiveMonoid {
    #[inline]
    fn element_count(&self) -> u32 {
        self.element_count
    }

    #[inline]
    fn identity(&self) -> u32 {
        0
    }

    #[inline]
    fn combine(&self, left: u32, right: u32) -> u32 {
        debug_assert!(left < self.element_count && right < self.element_count);
        if self.boolean_dimensions {
            return left | right;
        }
        let mut result = 0_u32;
        for (&cap, &stride) in self.caps.iter().zip(self.strides.iter()) {
            let radix = u32::from(cap) + 1;
            let left_value = (left / stride) % radix;
            let right_value = (right / stride) % radix;
            let value = left_value.saturating_add(right_value).min(u32::from(cap));
            result += value * stride;
        }
        result
    }

    #[inline]
    fn leq(&self, left: u32, right: u32) -> bool {
        debug_assert!(left < self.element_count && right < self.element_count);
        if self.boolean_dimensions {
            return left & !right == 0;
        }
        self.caps
            .iter()
            .zip(self.strides.iter())
            .all(|(&cap, &stride)| {
                let radix = u32::from(cap) + 1;
                (left / stride) % radix <= (right / stride) % radix
            })
    }
}

/// Canonical antichain representing an upward-closed set of feasible costs.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ParetoFront {
    elements: Box<[u32]>,
}

/// Dense observation IDs for a batch of canonical resource fronts.
///
/// Equal fronts share one stored payload. Construction sorts indices once and
/// moves each payload into its unique slot, so it does not retain a duplicate
/// hash-table key for every potentially large front.
#[derive(Clone, Debug)]
pub struct ParetoObservationTable {
    observations: Box<[u32]>,
    fronts: Box<[ParetoFront]>,
}

/// Distinct Pareto payloads after moving state observation IDs elsewhere.
#[derive(Clone, Debug)]
pub struct ParetoResponseDictionary {
    fronts: Box<[ParetoFront]>,
}

/// Reusable, allocation-free scratch space for Pareto choice and composition.
///
/// Size once from the maximum input-front sum or product on the hot path.
/// Operations return an error rather than growing the buffer.
#[derive(Clone, Debug)]
pub struct ParetoWorkspace {
    elements: Vec<u32>,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ParetoWitness {
    pub resource: u32,
    pub witness: u32,
}

const _: () = assert!(std::mem::size_of::<ParetoWitness>() == 8);

/// Canonical resource antichain retaining one concrete witness per point.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct WitnessedParetoFront {
    entries: Box<[ParetoWitness]>,
}

impl WitnessedParetoFront {
    pub fn new<M: FiniteOrderedMonoid>(
        monoid: &M,
        candidates: impl IntoIterator<Item = ParetoWitness>,
    ) -> Result<Self, OrderedResourceError> {
        let candidates = candidates.into_iter();
        let capacity = candidates.size_hint().1.unwrap_or(candidates.size_hint().0);
        let mut entries = Vec::with_capacity(capacity);
        for candidate in candidates {
            validate_element(monoid.element_count(), candidate.resource)?;
            insert_witnessed(monoid, &mut entries, candidate);
        }
        entries.sort_unstable_by_key(|entry| entry.resource);
        Ok(Self {
            entries: entries.into_boxed_slice(),
        })
    }

    pub fn entries(&self) -> &[ParetoWitness] {
        &self.entries
    }

    pub fn resources(&self) -> impl ExactSizeIterator<Item = u32> + '_ {
        self.entries.iter().map(|entry| entry.resource)
    }

    pub fn choice<M: FiniteOrderedMonoid>(
        &self,
        monoid: &M,
        other: &Self,
    ) -> Result<Self, OrderedResourceError> {
        let mut entries = Vec::with_capacity(self.entries.len() + other.entries.len());
        for &candidate in self.entries.iter().chain(other.entries.iter()) {
            insert_witnessed(monoid, &mut entries, candidate);
        }
        entries.sort_unstable_by_key(|entry| entry.resource);
        Ok(Self {
            entries: entries.into_boxed_slice(),
        })
    }
}

#[derive(Debug, Error, PartialEq, Eq)]
pub enum ParetoWitnessError<E> {
    #[error(transparent)]
    Resource(#[from] OrderedResourceError),
    #[error("witness composition failed: {0}")]
    Witness(E),
}

#[derive(Debug, Error, PartialEq, Eq)]
pub enum FrozenParetoError {
    #[error(transparent)]
    Resource(#[from] OrderedResourceError),
    #[error("the frozen quotient and edge-front table have different generator counts")]
    EdgeFrontCount,
    #[error("the frozen quotient output has no supplied Pareto interpretation")]
    Output,
    #[error("the frozen quotient DAG is malformed or not forward-topological")]
    Artifact,
}

/// Pre-sized, allocation-free workspace for witness-preserving composition.
#[derive(Clone, Debug)]
pub struct WitnessedParetoWorkspace {
    entries: Vec<ParetoWitness>,
}

impl WitnessedParetoWorkspace {
    pub fn with_capacity(capacity: usize) -> Self {
        Self {
            entries: Vec::with_capacity(capacity),
        }
    }

    pub fn capacity(&self) -> usize {
        self.entries.capacity()
    }

    pub fn compose<'a, M, E>(
        &'a mut self,
        monoid: &M,
        left: &WitnessedParetoFront,
        right: &WitnessedParetoFront,
        mut compose_witness: impl FnMut(u32, u32) -> Result<u32, E>,
    ) -> Result<&'a [ParetoWitness], ParetoWitnessError<E>>
    where
        M: FiniteOrderedMonoid,
    {
        let required = left
            .entries
            .len()
            .checked_mul(right.entries.len())
            .ok_or(OrderedResourceError::Overflow)?;
        let capacity = self.entries.capacity();
        if required > capacity {
            return Err(OrderedResourceError::WorkspaceCapacity { required, capacity }.into());
        }
        self.entries.clear();
        for &left_entry in &left.entries {
            for &right_entry in &right.entries {
                let resource = monoid.combine(left_entry.resource, right_entry.resource);
                validate_element(monoid.element_count(), resource)?;
                if self
                    .entries
                    .iter()
                    .any(|entry| monoid.leq(entry.resource, resource))
                {
                    continue;
                }
                let witness = compose_witness(left_entry.witness, right_entry.witness)
                    .map_err(ParetoWitnessError::Witness)?;
                self.entries
                    .retain(|entry| !monoid.leq(resource, entry.resource));
                self.entries.push(ParetoWitness { resource, witness });
            }
        }
        self.entries.sort_unstable_by_key(|entry| entry.resource);
        Ok(&self.entries)
    }
}

/// Evaluate a forward-topological frozen feasibility quotient over a
/// witness-bearing Pareto algebra without recompiling the quotient.
///
/// `edge_fronts[g]` interprets generator `g`, while `output_fronts[o]`
/// interprets observation `o`. All topology is taken from the frozen artifact.
/// The caller owns the pre-sized composition workspace, so the evaluator never
/// grows scratch storage in its class/generator loops.
pub struct FrozenParetoPlan<'a> {
    frozen: &'a FrozenObservation,
    offsets: Box<[usize]>,
    outgoing: Box<[u32]>,
    generator_targets: Box<[u32]>,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct FrozenParetoEvaluationMetrics {
    pub reachable_classes: usize,
    pub peak_live_classes: usize,
    pub peak_live_entries: usize,
    pub retained_entries: usize,
}

/// Entry-specific topology compiled once and reused across objective families.
pub struct FrozenParetoQueryPlan<'plan, 'frozen> {
    plan: &'plan FrozenParetoPlan<'frozen>,
    entry_classes: Box<[u32]>,
    single_sort: Option<usize>,
    selected_counts: Box<[usize]>,
    selected_indices: Box<[usize]>,
    reachable_offsets: Box<[usize]>,
    reachable_class_ids: Box<[u32]>,
    target_offsets: Box<[usize]>,
    target_locals: Box<[u32]>,
    release_offsets: Box<[usize]>,
    release_targets: Box<[u32]>,
    reachable_classes: usize,
}

impl<'a> FrozenParetoPlan<'a> {
    pub fn new(frozen: &'a FrozenObservation) -> Result<Self, FrozenParetoError> {
        let sort_count = frozen.sort_count();
        let mut offsets = vec![0_usize; sort_count + 1];
        let mut generator_targets = vec![0_u32; frozen.generator_count()];
        for (generator, target_slot) in generator_targets.iter_mut().enumerate() {
            let spec = frozen
                .generator_spec(generator as u32)
                .ok_or(FrozenParetoError::Artifact)?;
            if spec.source_sort as usize >= sort_count
                || spec.target_sort as usize >= sort_count
                || spec.source_sort >= spec.target_sort
            {
                return Err(FrozenParetoError::Artifact);
            }
            offsets[spec.source_sort as usize + 1] += 1;
            *target_slot = spec.target_sort;
        }
        for sort in 0..sort_count {
            offsets[sort + 1] += offsets[sort];
        }
        let mut cursor = offsets[..sort_count].to_vec();
        let mut outgoing = vec![0_u32; frozen.generator_count()];
        for generator in 0..frozen.generator_count() {
            let source = frozen
                .generator_spec(generator as u32)
                .ok_or(FrozenParetoError::Artifact)?
                .source_sort as usize;
            outgoing[cursor[source]] = generator as u32;
            cursor[source] += 1;
        }
        Ok(Self {
            frozen,
            offsets: offsets.into_boxed_slice(),
            outgoing: outgoing.into_boxed_slice(),
            generator_targets: generator_targets.into_boxed_slice(),
        })
    }

    pub fn evaluate<M: FiniteOrderedMonoid>(
        &self,
        monoid: &M,
        output_fronts: &[WitnessedParetoFront],
        edge_fronts: &[WitnessedParetoFront],
        workspace: &mut WitnessedParetoWorkspace,
        mut compose_witness: impl FnMut(u32, u32, u32) -> u32,
    ) -> Result<Vec<Option<WitnessedParetoFront>>, FrozenParetoError> {
        if edge_fronts.len() != self.frozen.generator_count() {
            return Err(FrozenParetoError::EdgeFrontCount);
        }
        let mut fronts: Vec<Option<WitnessedParetoFront>> =
            vec![None; self.frozen.storage().classes];
        let capacity = workspace.capacity();
        let accumulator = &mut workspace.entries;
        for sort in (0..self.frozen.sort_count()).rev() {
            let range = self
                .frozen
                .class_range(sort as u32)
                .ok_or(FrozenParetoError::Artifact)?;
            for class in range.start..range.start + range.len {
                let output = self
                    .frozen
                    .output(class)
                    .ok_or(FrozenParetoError::Artifact)? as usize;
                let output_front = output_fronts.get(output).ok_or(FrozenParetoError::Output)?;
                if output_front.entries.len() > capacity {
                    return Err(OrderedResourceError::WorkspaceCapacity {
                        required: output_front.entries.len(),
                        capacity,
                    }
                    .into());
                }
                for entry in &output_front.entries {
                    validate_element(monoid.element_count(), entry.resource)?;
                }
                accumulator.clear();
                accumulator.extend_from_slice(&output_front.entries);
                for &generator in &self.outgoing[self.offsets[sort]..self.offsets[sort + 1]] {
                    let target =
                        self.frozen
                            .transition(generator, class)
                            .ok_or(FrozenParetoError::Artifact)? as usize;
                    let child = fronts
                        .get(target)
                        .and_then(Option::as_ref)
                        .ok_or(FrozenParetoError::Artifact)?;
                    for &edge in &edge_fronts[generator as usize].entries {
                        validate_element(monoid.element_count(), edge.resource)?;
                        for &suffix in &child.entries {
                            let resource = monoid.combine(edge.resource, suffix.resource);
                            validate_element(monoid.element_count(), resource)?;
                            insert_witnessed_bounded(
                                monoid,
                                accumulator,
                                capacity,
                                resource,
                                || compose_witness(generator, edge.witness, suffix.witness),
                            )?;
                        }
                    }
                }
                accumulator.sort_unstable_by_key(|entry| entry.resource);
                fronts[class as usize] = Some(WitnessedParetoFront {
                    entries: Box::from(accumulator.as_slice()),
                });
            }
        }
        Ok(fronts)
    }

    /// Compile entry-specific reachability and reclamation topology once.
    pub fn query<'plan>(
        &'plan self,
        entry_classes: &[u32],
    ) -> Result<FrozenParetoQueryPlan<'plan, 'a>, FrozenParetoError> {
        let sort_count = self.frozen.sort_count();
        let single_sort = if let [class] = entry_classes {
            Some(
                self.sort_for_class(*class)
                    .ok_or(FrozenParetoError::Artifact)?,
            )
        } else {
            None
        };
        let mut selected_counts = Vec::new();
        let mut selected_indices = Vec::new();
        if single_sort.is_none() {
            selected_counts.resize(sort_count + 1, 0_usize);
            let mut selected_sorts = Vec::with_capacity(entry_classes.len());
            for &class in entry_classes {
                let sort = self
                    .sort_for_class(class)
                    .ok_or(FrozenParetoError::Artifact)?;
                selected_sorts.push(sort);
                selected_counts[sort + 1] += 1;
            }
            for sort in 0..sort_count {
                selected_counts[sort + 1] += selected_counts[sort];
            }
            let mut selected_cursor = selected_counts[..sort_count].to_vec();
            selected_indices.resize(entry_classes.len(), 0_usize);
            for (index, &sort) in selected_sorts.iter().enumerate() {
                selected_indices[selected_cursor[sort]] = index;
                selected_cursor[sort] += 1;
            }
        }
        let mut last_reachable_source = vec![None; sort_count];

        let class_count = self.frozen.storage().classes;
        let mut reachable = vec![0_u64; class_count.div_ceil(64)];
        let mut reachable_classes = 0_usize;
        for &class in entry_classes {
            let word = &mut reachable[class as usize / 64];
            let mask = 1_u64 << (class as usize % 64);
            if *word & mask == 0 {
                *word |= mask;
                reachable_classes += 1;
            }
        }
        for sort in 0..sort_count {
            let range = self
                .frozen
                .class_range(sort as u32)
                .ok_or(FrozenParetoError::Artifact)?;
            for class in range.start..range.start + range.len {
                if reachable[class as usize / 64] & (1_u64 << (class as usize % 64)) == 0 {
                    continue;
                }
                for &generator in &self.outgoing[self.offsets[sort]..self.offsets[sort + 1]] {
                    let target_sort = self.generator_targets[generator as usize] as usize;
                    let slot = &mut last_reachable_source[target_sort];
                    *slot = Some(slot.map_or(sort, |old: usize| old.min(sort)));
                    let target =
                        self.frozen
                            .transition(generator, class)
                            .ok_or(FrozenParetoError::Artifact)? as usize;
                    let word = reachable
                        .get_mut(target / 64)
                        .ok_or(FrozenParetoError::Artifact)?;
                    let mask = 1_u64 << (target % 64);
                    if *word & mask == 0 {
                        *word |= mask;
                        reachable_classes += 1;
                    }
                }
            }
        }
        let mut release_offsets = vec![0_usize; sort_count + 1];
        for (target, source) in last_reachable_source.iter().enumerate() {
            release_offsets[source.unwrap_or(target) + 1] += 1;
        }
        for sort in 0..sort_count {
            release_offsets[sort + 1] += release_offsets[sort];
        }
        let mut release_cursor = release_offsets[..sort_count].to_vec();
        let mut release_targets = vec![0_u32; sort_count];
        for (target, source) in last_reachable_source.iter().enumerate() {
            let release_sort = source.unwrap_or(target);
            release_targets[release_cursor[release_sort]] = target as u32;
            release_cursor[release_sort] += 1;
        }

        let mut reachable_offsets = vec![0_usize; sort_count + 1];
        let mut reachable_class_ids = Vec::with_capacity(reachable_classes);
        for sort in 0..sort_count {
            let range = self
                .frozen
                .class_range(sort as u32)
                .ok_or(FrozenParetoError::Artifact)?;
            for class in range.start..range.start + range.len {
                if reachable[class as usize / 64] & (1_u64 << (class as usize % 64)) != 0 {
                    reachable_class_ids.push(class);
                }
            }
            reachable_offsets[sort + 1] = reachable_class_ids.len();
        }
        let mut target_offsets = Vec::with_capacity(reachable_classes + 1);
        let mut target_locals = Vec::new();
        target_offsets.push(0);
        for sort in 0..sort_count {
            for &class in &reachable_class_ids[reachable_offsets[sort]..reachable_offsets[sort + 1]]
            {
                for &generator in &self.outgoing[self.offsets[sort]..self.offsets[sort + 1]] {
                    let target = self
                        .frozen
                        .transition(generator, class)
                        .ok_or(FrozenParetoError::Artifact)?;
                    let target_sort = self.generator_targets[generator as usize] as usize;
                    let target_classes = &reachable_class_ids
                        [reachable_offsets[target_sort]..reachable_offsets[target_sort + 1]];
                    let target_local = target_classes
                        .binary_search(&target)
                        .map_err(|_| FrozenParetoError::Artifact)?;
                    target_locals.push(target_local as u32);
                }
                target_offsets.push(target_locals.len());
            }
        }

        Ok(FrozenParetoQueryPlan {
            plan: self,
            entry_classes: entry_classes.into(),
            single_sort,
            selected_counts: selected_counts.into_boxed_slice(),
            selected_indices: selected_indices.into_boxed_slice(),
            reachable_offsets: reachable_offsets.into_boxed_slice(),
            reachable_class_ids: reachable_class_ids.into_boxed_slice(),
            target_offsets: target_offsets.into_boxed_slice(),
            target_locals: target_locals.into_boxed_slice(),
            release_offsets: release_offsets.into_boxed_slice(),
            release_targets: release_targets.into_boxed_slice(),
            reachable_classes,
        })
    }

    /// Evaluate selected quotient classes with one-shot topology preparation.
    pub fn evaluate_entries<M: FiniteOrderedMonoid>(
        &self,
        entry_classes: &[u32],
        monoid: &M,
        output_fronts: &[WitnessedParetoFront],
        edge_fronts: &[WitnessedParetoFront],
        workspace: &mut WitnessedParetoWorkspace,
        compose_witness: impl FnMut(u32, u32, u32) -> u32,
    ) -> Result<(Vec<WitnessedParetoFront>, FrozenParetoEvaluationMetrics), FrozenParetoError> {
        self.query(entry_classes)?.evaluate(
            monoid,
            output_fronts,
            edge_fronts,
            workspace,
            compose_witness,
        )
    }

    fn sort_for_class(&self, class: u32) -> Option<usize> {
        let mut low = 0_usize;
        let mut high = self.frozen.sort_count();
        while low < high {
            let middle = low + (high - low) / 2;
            let range = self.frozen.class_range(middle as u32)?;
            if class < range.start {
                high = middle;
            } else if class >= range.start + range.len {
                low = middle + 1;
            } else {
                return Some(middle);
            }
        }
        None
    }
}

impl FrozenParetoQueryPlan<'_, '_> {
    /// Evaluate only the prepared classes while reclaiming every sort slab at
    /// its exact last reachable predecessor.
    pub fn evaluate<M: FiniteOrderedMonoid>(
        &self,
        monoid: &M,
        output_fronts: &[WitnessedParetoFront],
        edge_fronts: &[WitnessedParetoFront],
        workspace: &mut WitnessedParetoWorkspace,
        mut compose_witness: impl FnMut(u32, u32, u32) -> u32,
    ) -> Result<(Vec<WitnessedParetoFront>, FrozenParetoEvaluationMetrics), FrozenParetoError> {
        if edge_fronts.len() != self.plan.frozen.generator_count() {
            return Err(FrozenParetoError::EdgeFrontCount);
        }
        if self.entry_classes.is_empty() {
            return Ok((Vec::new(), FrozenParetoEvaluationMetrics::default()));
        }
        let sort_count = self.plan.frozen.sort_count();
        let capacity = workspace.capacity();
        let accumulator = &mut workspace.entries;
        let mut live: Vec<Option<Vec<Option<WitnessedParetoFront>>>> = vec![None; sort_count];
        let mut retained = if self.single_sort.is_some() {
            Vec::new()
        } else {
            vec![None; self.entry_classes.len()]
        };
        let mut single_retained = None;
        let mut metrics = FrozenParetoEvaluationMetrics {
            reachable_classes: self.reachable_classes,
            ..FrozenParetoEvaluationMetrics::default()
        };
        let mut live_classes = 0_usize;
        let mut live_entries = 0_usize;

        for sort in (0..sort_count).rev() {
            let reachable_classes = &self.reachable_class_ids
                [self.reachable_offsets[sort]..self.reachable_offsets[sort + 1]];
            let mut sort_fronts = Vec::with_capacity(reachable_classes.len());
            for (class_local, &class) in reachable_classes.iter().enumerate() {
                let output = self
                    .plan
                    .frozen
                    .output(class)
                    .ok_or(FrozenParetoError::Artifact)? as usize;
                let output_front = output_fronts.get(output).ok_or(FrozenParetoError::Output)?;
                if output_front.entries.len() > capacity {
                    return Err(OrderedResourceError::WorkspaceCapacity {
                        required: output_front.entries.len(),
                        capacity,
                    }
                    .into());
                }
                for entry in &output_front.entries {
                    validate_element(monoid.element_count(), entry.resource)?;
                }
                accumulator.clear();
                accumulator.extend_from_slice(&output_front.entries);
                let global_local = self.reachable_offsets[sort] + class_local;
                let target_locals = &self.target_locals
                    [self.target_offsets[global_local]..self.target_offsets[global_local + 1]];
                for (edge_local, &generator) in self.plan.outgoing
                    [self.plan.offsets[sort]..self.plan.offsets[sort + 1]]
                    .iter()
                    .enumerate()
                {
                    let target_sort = self.plan.generator_targets[generator as usize] as usize;
                    let target_local = target_locals[edge_local] as usize;
                    let child = live[target_sort]
                        .as_ref()
                        .and_then(|fronts| fronts.get(target_local))
                        .and_then(Option::as_ref)
                        .ok_or(FrozenParetoError::Artifact)?;
                    for &edge in &edge_fronts[generator as usize].entries {
                        validate_element(monoid.element_count(), edge.resource)?;
                        for &suffix in &child.entries {
                            let resource = monoid.combine(edge.resource, suffix.resource);
                            validate_element(monoid.element_count(), resource)?;
                            insert_witnessed_bounded(
                                monoid,
                                accumulator,
                                capacity,
                                resource,
                                || compose_witness(generator, edge.witness, suffix.witness),
                            )?;
                        }
                    }
                }
                accumulator.sort_unstable_by_key(|entry| entry.resource);
                sort_fronts.push(Some(WitnessedParetoFront {
                    entries: Box::from(accumulator.as_slice()),
                }));
            }

            let local_for_index = |index: usize| -> Result<usize, FrozenParetoError> {
                reachable_classes
                    .binary_search(&self.entry_classes[index])
                    .map_err(|_| FrozenParetoError::Artifact)
            };
            match self.single_sort {
                Some(selected_sort) if selected_sort == sort => {
                    let local = local_for_index(0)?;
                    let front = sort_fronts[local]
                        .take()
                        .ok_or(FrozenParetoError::Artifact)?;
                    metrics.retained_entries = front.entries.len();
                    single_retained = Some(front);
                }
                Some(_) => {}
                None => {
                    for &index in &self.selected_indices
                        [self.selected_counts[sort]..self.selected_counts[sort + 1]]
                    {
                        let front = sort_fronts[local_for_index(index)?]
                            .as_ref()
                            .ok_or(FrozenParetoError::Artifact)?
                            .clone();
                        metrics.retained_entries += front.entries.len();
                        retained[index] = Some(front);
                    }
                }
            }
            live_classes += sort_fronts.iter().filter(|front| front.is_some()).count();
            live_entries += sort_fronts
                .iter()
                .filter_map(Option::as_ref)
                .map(|front| front.entries.len())
                .sum::<usize>();
            live[sort] = Some(sort_fronts);
            metrics.peak_live_classes = metrics.peak_live_classes.max(live_classes);
            metrics.peak_live_entries = metrics.peak_live_entries.max(live_entries);

            for &target in
                &self.release_targets[self.release_offsets[sort]..self.release_offsets[sort + 1]]
            {
                if let Some(fronts) = live[target as usize].take() {
                    live_classes -= fronts.iter().filter(|front| front.is_some()).count();
                    live_entries -= fronts
                        .iter()
                        .filter_map(Option::as_ref)
                        .map(|front| front.entries.len())
                        .sum::<usize>();
                }
            }
        }

        if self.single_sort.is_some() {
            Ok((
                vec![single_retained.ok_or(FrozenParetoError::Artifact)?],
                metrics,
            ))
        } else {
            retained
                .into_iter()
                .map(|front| front.ok_or(FrozenParetoError::Artifact))
                .collect::<Result<Vec<_>, _>>()
                .map(|fronts| (fronts, metrics))
        }
    }
}

pub fn evaluate_frozen_pareto_dag<M: FiniteOrderedMonoid>(
    frozen: &FrozenObservation,
    monoid: &M,
    output_fronts: &[WitnessedParetoFront],
    edge_fronts: &[WitnessedParetoFront],
    workspace: &mut WitnessedParetoWorkspace,
    compose_witness: impl FnMut(u32, u32, u32) -> u32,
) -> Result<Vec<Option<WitnessedParetoFront>>, FrozenParetoError> {
    FrozenParetoPlan::new(frozen)?.evaluate(
        monoid,
        output_fronts,
        edge_fronts,
        workspace,
        compose_witness,
    )
}

#[inline]
fn insert_witnessed_bounded<M: FiniteOrderedMonoid>(
    monoid: &M,
    entries: &mut Vec<ParetoWitness>,
    capacity: usize,
    resource: u32,
    make_witness: impl FnOnce() -> u32,
) -> Result<(), OrderedResourceError> {
    if let [current] = entries.as_mut_slice() {
        if monoid.leq(current.resource, resource) {
            return Ok(());
        }
        if monoid.leq(resource, current.resource) {
            *current = ParetoWitness {
                resource,
                witness: make_witness(),
            };
            return Ok(());
        }
    } else if entries
        .iter()
        .any(|entry| monoid.leq(entry.resource, resource))
    {
        return Ok(());
    } else if entries.len() > 1 {
        entries.retain(|entry| !monoid.leq(resource, entry.resource));
    }
    if entries.len() == capacity {
        return Err(OrderedResourceError::WorkspaceCapacity {
            required: capacity.saturating_add(1),
            capacity,
        });
    }
    entries.push(ParetoWitness {
        resource,
        witness: make_witness(),
    });
    Ok(())
}

#[inline]
fn insert_witnessed<M: FiniteOrderedMonoid>(
    monoid: &M,
    entries: &mut Vec<ParetoWitness>,
    candidate: ParetoWitness,
) {
    if entries
        .iter()
        .any(|entry| monoid.leq(entry.resource, candidate.resource))
    {
        return;
    }
    entries.retain(|entry| !monoid.leq(candidate.resource, entry.resource));
    entries.push(candidate);
}

impl ParetoWorkspace {
    pub fn with_capacity(capacity: usize) -> Self {
        Self {
            elements: Vec::with_capacity(capacity),
        }
    }

    pub fn capacity(&self) -> usize {
        self.elements.capacity()
    }

    pub fn choice<'a, M: FiniteOrderedMonoid>(
        &'a mut self,
        monoid: &M,
        left: &ParetoFront,
        right: &ParetoFront,
    ) -> Result<&'a [u32], OrderedResourceError> {
        let required = left
            .elements
            .len()
            .checked_add(right.elements.len())
            .ok_or(OrderedResourceError::Overflow)?;
        self.prepare(required)?;
        for &candidate in left.elements.iter().chain(right.elements.iter()) {
            insert_minimal(monoid, &mut self.elements, candidate);
        }
        self.elements.sort_unstable();
        Ok(&self.elements)
    }

    pub fn compose<'a, M: FiniteOrderedMonoid>(
        &'a mut self,
        monoid: &M,
        left: &ParetoFront,
        right: &ParetoFront,
    ) -> Result<&'a [u32], OrderedResourceError> {
        let required = left
            .elements
            .len()
            .checked_mul(right.elements.len())
            .ok_or(OrderedResourceError::Overflow)?;
        self.prepare(required)?;
        for &left_element in &left.elements {
            for &right_element in &right.elements {
                let candidate = monoid.combine(left_element, right_element);
                validate_element(monoid.element_count(), candidate)?;
                insert_minimal(monoid, &mut self.elements, candidate);
            }
        }
        self.elements.sort_unstable();
        Ok(&self.elements)
    }

    fn prepare(&mut self, required: usize) -> Result<(), OrderedResourceError> {
        let capacity = self.elements.capacity();
        if required > capacity {
            return Err(OrderedResourceError::WorkspaceCapacity { required, capacity });
        }
        self.elements.clear();
        Ok(())
    }
}

impl ParetoObservationTable {
    pub fn new(
        fronts: impl IntoIterator<Item = ParetoFront>,
    ) -> Result<Self, OrderedResourceError> {
        let iterator = fronts.into_iter();
        let capacity = iterator.size_hint().1.unwrap_or(iterator.size_hint().0);
        let mut indexed = Vec::with_capacity(capacity);
        for (state, front) in iterator.enumerate() {
            indexed.push((state, front));
        }
        let state_count = indexed.len();
        if state_count > u32::MAX as usize {
            return Err(OrderedResourceError::Overflow);
        }
        indexed.sort_unstable_by(|left, right| left.1.elements.cmp(&right.1.elements));

        let mut observations = vec![0_u32; state_count];
        let mut unique = Vec::with_capacity(state_count);
        for (state, front) in indexed {
            if unique.last() != Some(&front) {
                if unique.len() == u32::MAX as usize {
                    return Err(OrderedResourceError::Overflow);
                }
                unique.push(front);
            }
            observations[state] = (unique.len() - 1) as u32;
        }
        unique.shrink_to_fit();
        Ok(Self {
            observations: observations.into_boxed_slice(),
            fronts: unique.into_boxed_slice(),
        })
    }

    pub fn observations(&self) -> &[u32] {
        &self.observations
    }

    pub fn fronts(&self) -> &[ParetoFront] {
        &self.fronts
    }

    pub fn front(&self, observation: u32) -> Option<&ParetoFront> {
        self.fronts.get(observation as usize)
    }

    pub fn into_parts(self) -> (Box<[u32]>, ParetoResponseDictionary) {
        (
            self.observations,
            ParetoResponseDictionary {
                fronts: self.fronts,
            },
        )
    }
}

impl ParetoResponseDictionary {
    pub fn fronts(&self) -> &[ParetoFront] {
        &self.fronts
    }

    pub fn front(&self, observation: u32) -> Option<&ParetoFront> {
        self.fronts.get(observation as usize)
    }
}

impl ParetoFront {
    pub fn new<M: FiniteOrderedMonoid>(
        monoid: &M,
        candidates: impl IntoIterator<Item = u32>,
    ) -> Result<Self, OrderedResourceError> {
        let candidates = candidates.into_iter();
        let mut elements = Vec::with_capacity(candidates.size_hint().0);
        for candidate in candidates {
            validate_element(monoid.element_count(), candidate)?;
            insert_minimal(monoid, &mut elements, candidate);
        }
        elements.sort_unstable();
        Ok(Self {
            elements: elements.into_boxed_slice(),
        })
    }

    pub fn identity<M: FiniteOrderedMonoid>(monoid: &M) -> Result<Self, OrderedResourceError> {
        Self::new(monoid, [monoid.identity()])
    }

    pub fn elements(&self) -> &[u32] {
        &self.elements
    }

    pub fn choice<M: FiniteOrderedMonoid>(
        &self,
        monoid: &M,
        other: &Self,
    ) -> Result<Self, OrderedResourceError> {
        let mut elements = Vec::with_capacity(self.elements.len() + other.elements.len());
        for &candidate in self.elements.iter().chain(other.elements.iter()) {
            insert_minimal(monoid, &mut elements, candidate);
        }
        elements.sort_unstable();
        Ok(Self {
            elements: elements.into_boxed_slice(),
        })
    }

    pub fn compose<M: FiniteOrderedMonoid>(
        &self,
        monoid: &M,
        other: &Self,
    ) -> Result<Self, OrderedResourceError> {
        let capacity = self
            .elements
            .len()
            .checked_mul(other.elements.len())
            .ok_or(OrderedResourceError::Overflow)?;
        let mut elements = Vec::with_capacity(capacity);
        for &left in self.elements.iter() {
            for &right in other.elements.iter() {
                let candidate = monoid.combine(left, right);
                validate_element(monoid.element_count(), candidate)?;
                insert_minimal(monoid, &mut elements, candidate);
            }
        }
        elements.sort_unstable();
        Ok(Self {
            elements: elements.into_boxed_slice(),
        })
    }

    pub fn admits<M: FiniteOrderedMonoid>(
        &self,
        monoid: &M,
        budget: u32,
    ) -> Result<bool, OrderedResourceError> {
        validate_element(monoid.element_count(), budget)?;
        Ok(self
            .elements
            .iter()
            .any(|&element| monoid.leq(element, budget)))
    }
}

#[inline]
fn insert_minimal<M: FiniteOrderedMonoid>(monoid: &M, elements: &mut Vec<u32>, candidate: u32) {
    if elements
        .iter()
        .any(|&element| monoid.leq(element, candidate))
    {
        return;
    }
    elements.retain(|element| !monoid.leq(candidate, *element));
    elements.push(candidate);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn capped_resources_validate_and_compose_exact_fronts() {
        let monoid = CappedAdditiveMonoid::new([2, 2]).unwrap();
        assert_eq!(
            validate_finite_ordered_monoid(&monoid).unwrap(),
            OrderedMonoidCertificate { elements: 9 }
        );
        let a = ParetoFront::new(
            &monoid,
            [
                monoid.encode(&[1, 0]).unwrap(),
                monoid.encode(&[0, 1]).unwrap(),
            ],
        )
        .unwrap();
        let composed = a.compose(&monoid, &a).unwrap();
        let decoded: Vec<_> = composed
            .elements()
            .iter()
            .map(|&element| monoid.decode(element).unwrap())
            .collect();
        assert_eq!(
            decoded,
            vec![
                vec![2, 0].into_boxed_slice(),
                vec![1, 1].into_boxed_slice(),
                vec![0, 2].into_boxed_slice(),
            ]
        );
        assert!(composed
            .admits(&monoid, monoid.encode(&[2, 1]).unwrap())
            .unwrap());
        assert!(!composed
            .admits(&monoid, monoid.encode(&[0, 1]).unwrap())
            .unwrap());
        assert_eq!(
            composed.admits(&monoid, monoid.element_count()),
            Err(OrderedResourceError::Element {
                element: monoid.element_count()
            })
        );
    }

    #[derive(Clone, Copy)]
    struct TableMonoid {
        count: u32,
        identity: u32,
        combine: &'static [u32],
        order: &'static [bool],
    }

    impl FiniteOrderedMonoid for TableMonoid {
        fn element_count(&self) -> u32 {
            self.count
        }

        fn identity(&self) -> u32 {
            self.identity
        }

        fn combine(&self, left: u32, right: u32) -> u32 {
            self.combine[(left * self.count + right) as usize]
        }

        fn leq(&self, left: u32, right: u32) -> bool {
            self.order[(left * self.count + right) as usize]
        }
    }

    #[test]
    fn validator_rejects_out_of_range_outputs_before_reusing_them() {
        let bad = TableMonoid {
            count: 2,
            identity: 0,
            combine: &[0, 1, 1, 2],
            order: &[true, true, false, true],
        };
        assert_eq!(
            validate_finite_ordered_monoid(&bad),
            Err(OrderedResourceError::Element { element: 2 })
        );
    }

    #[test]
    fn pareto_choice_and_composition_obey_semiring_laws() {
        let monoid = CappedAdditiveMonoid::new([2, 2]).unwrap();
        let front = |points: &[[u16; 2]]| {
            ParetoFront::new(
                &monoid,
                points.iter().map(|point| monoid.encode(point).unwrap()),
            )
            .unwrap()
        };
        let a = front(&[[1, 0], [0, 1]]);
        let b = front(&[[2, 0], [0, 1]]);
        let c = front(&[[0, 2], [1, 0]]);
        let empty = ParetoFront::new(&monoid, []).unwrap();
        let one = ParetoFront::identity(&monoid).unwrap();

        assert_eq!(a.choice(&monoid, &a).unwrap(), a);
        assert_eq!(
            a.choice(&monoid, &b).unwrap(),
            b.choice(&monoid, &a).unwrap()
        );
        assert_eq!(a.compose(&monoid, &one).unwrap(), a);
        assert_eq!(a.compose(&monoid, &empty).unwrap(), empty);
        assert_eq!(
            a.compose(&monoid, &b)
                .unwrap()
                .compose(&monoid, &c)
                .unwrap(),
            a.compose(&monoid, &b.compose(&monoid, &c).unwrap())
                .unwrap()
        );
        assert_eq!(
            a.compose(&monoid, &b.choice(&monoid, &c).unwrap()).unwrap(),
            a.compose(&monoid, &b)
                .unwrap()
                .choice(&monoid, &a.compose(&monoid, &c).unwrap())
                .unwrap()
        );
    }

    #[test]
    fn pareto_observations_deduplicate_payloads_without_losing_state_order() {
        let monoid = CappedAdditiveMonoid::new([2, 2]).unwrap();
        let front = |points: &[[u16; 2]]| {
            ParetoFront::new(
                &monoid,
                points.iter().map(|point| monoid.encode(point).unwrap()),
            )
            .unwrap()
        };
        let a = front(&[[1, 0], [0, 1]]);
        let b = front(&[[2, 0], [0, 2]]);
        let table = ParetoObservationTable::new([a.clone(), b.clone(), a]).unwrap();

        assert_eq!(table.fronts().len(), 2);
        assert_eq!(table.observations()[0], table.observations()[2]);
        assert_ne!(table.observations()[0], table.observations()[1]);
        assert_eq!(
            table.front(table.observations()[1]).unwrap().elements(),
            b.elements()
        );
    }

    #[test]
    fn pre_sized_workspace_reuses_storage_and_rejects_growth() {
        let monoid = CappedAdditiveMonoid::new([2, 2]).unwrap();
        let front = |points: &[[u16; 2]]| {
            ParetoFront::new(
                &monoid,
                points.iter().map(|point| monoid.encode(point).unwrap()),
            )
            .unwrap()
        };
        let a = front(&[[1, 0], [0, 1]]);
        let mut workspace = ParetoWorkspace::with_capacity(4);
        let first = workspace.compose(&monoid, &a, &a).unwrap();
        let storage = first.as_ptr();
        assert_eq!(first, a.compose(&monoid, &a).unwrap().elements());
        let second = workspace.choice(&monoid, &a, &a).unwrap();
        assert_eq!(second.as_ptr(), storage);
        assert_eq!(second, a.elements());

        let mut undersized = ParetoWorkspace::with_capacity(3);
        assert_eq!(
            undersized.compose(&monoid, &a, &a),
            Err(OrderedResourceError::WorkspaceCapacity {
                required: 4,
                capacity: 3
            })
        );
    }

    #[test]
    fn all_small_resource_subsets_and_pairs_match_brute_force() {
        let monoid = CappedAdditiveMonoid::new([1, 1]).unwrap();
        let canonical = |candidates: &[u32]| {
            let mut expected: Vec<_> = candidates
                .iter()
                .copied()
                .filter(|&candidate| {
                    !candidates
                        .iter()
                        .copied()
                        .any(|other| other != candidate && monoid.leq(other, candidate))
                })
                .collect();
            expected.sort_unstable();
            expected.dedup();
            expected
        };
        let mut fronts = Vec::with_capacity(16);
        let mut subsets = Vec::with_capacity(16);
        for mask in 0_u32..16 {
            let subset: Vec<_> = (0_u32..4)
                .filter(|&element| mask & (1 << element) != 0)
                .collect();
            let front = ParetoFront::new(&monoid, subset.iter().copied()).unwrap();
            assert_eq!(front.elements(), canonical(&subset));
            subsets.push(subset);
            fronts.push(front);
        }
        for left in 0..fronts.len() {
            for right in 0..fronts.len() {
                let choice_candidates: Vec<_> = subsets[left]
                    .iter()
                    .chain(subsets[right].iter())
                    .copied()
                    .collect();
                assert_eq!(
                    fronts[left]
                        .choice(&monoid, &fronts[right])
                        .unwrap()
                        .elements(),
                    canonical(&choice_candidates)
                );

                let mut compose_candidates =
                    Vec::with_capacity(subsets[left].len() * subsets[right].len());
                for &left_element in &subsets[left] {
                    for &right_element in &subsets[right] {
                        compose_candidates.push(monoid.combine(left_element, right_element));
                    }
                }
                assert_eq!(
                    fronts[left]
                        .compose(&monoid, &fronts[right])
                        .unwrap()
                        .elements(),
                    canonical(&compose_candidates)
                );
            }
        }
    }

    #[test]
    fn witnessed_fronts_compose_without_allocating_or_losing_replay_ids() {
        let monoid = CappedAdditiveMonoid::new([2, 2]).unwrap();
        let left = WitnessedParetoFront::new(
            &monoid,
            [
                ParetoWitness {
                    resource: monoid.encode(&[1, 0]).unwrap(),
                    witness: 10,
                },
                ParetoWitness {
                    resource: monoid.encode(&[0, 1]).unwrap(),
                    witness: 20,
                },
            ],
        )
        .unwrap();
        let mut workspace = WitnessedParetoWorkspace::with_capacity(4);
        let storage = workspace.entries.as_ptr();
        let composed = workspace
            .compose(&monoid, &left, &left, |a, b| Ok::<_, ()>(a * 10 + b))
            .unwrap();
        assert_eq!(composed.as_ptr(), storage);
        assert_eq!(
            composed,
            &[
                ParetoWitness {
                    resource: monoid.encode(&[2, 0]).unwrap(),
                    witness: 110,
                },
                ParetoWitness {
                    resource: monoid.encode(&[1, 1]).unwrap(),
                    witness: 120,
                },
                ParetoWitness {
                    resource: monoid.encode(&[0, 2]).unwrap(),
                    witness: 220,
                },
            ]
        );
    }

    #[test]
    fn boolean_resources_use_bitset_union_and_constant_time_certificate() {
        let monoid = CappedAdditiveMonoid::new([1; 16]).unwrap();
        assert_eq!(
            monoid.certificate(),
            OrderedMonoidCertificate { elements: 1 << 16 }
        );
        let left = monoid
            .encode(&[1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0])
            .unwrap();
        let right = monoid
            .encode(&[0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0])
            .unwrap();
        assert_eq!(monoid.combine(left, right), left | right);
        assert!(monoid.leq(left, left | right));
        assert!(!monoid.leq(left | right, left));
    }

    #[test]
    fn all_small_capped_products_match_coordinate_arithmetic() {
        for dimensions in 0_u32..=3 {
            let cap_vectors = 3_u32.pow(dimensions);
            for mut encoded_caps in 0..cap_vectors {
                let mut caps = Vec::with_capacity(dimensions as usize);
                for _ in 0..dimensions {
                    caps.push((encoded_caps % 3) as u16);
                    encoded_caps /= 3;
                }
                let monoid = CappedAdditiveMonoid::new(caps.clone()).unwrap();
                assert_eq!(
                    validate_finite_ordered_monoid(&monoid).unwrap(),
                    monoid.certificate()
                );
                for left in 0..monoid.element_count() {
                    let left_coordinates = monoid.decode(left).unwrap();
                    assert_eq!(monoid.encode(&left_coordinates).unwrap(), left);
                    for right in 0..monoid.element_count() {
                        let right_coordinates = monoid.decode(right).unwrap();
                        let expected: Vec<_> = left_coordinates
                            .iter()
                            .zip(right_coordinates.iter())
                            .zip(caps.iter())
                            .map(|((&a, &b), &cap)| a.saturating_add(b).min(cap))
                            .collect();
                        assert_eq!(
                            monoid.decode(monoid.combine(left, right)).unwrap().as_ref(),
                            expected
                        );
                    }
                }
            }
        }
    }

    #[test]
    fn frozen_pareto_plan_matches_all_tiny_local_interpretations() {
        use std::convert::Infallible;

        use crate::observational::{compile_layered_frozen_dag_audited, LayeredGeneratorSpec};

        let mut audit = Vec::new();
        let (frozen, _) = compile_layered_frozen_dag_audited(
            &[3, 2],
            &[LayeredGeneratorSpec {
                source_sort: 0,
                target_sort: 1,
            }],
            &[0],
            |sort, state| if sort == 0 { 0 } else { state + 1 },
            |_, state| if state < 2 { 0 } else { 1 },
            &mut audit,
        )
        .unwrap();
        assert_eq!(frozen.entry_class(0, 0), frozen.entry_class(0, 1));
        assert_ne!(frozen.entry_class(0, 0), frozen.entry_class(0, 2));

        let monoid = CappedAdditiveMonoid::new([1]).unwrap();
        let empty = WitnessedParetoFront::new(&monoid, []).unwrap();
        let identity = WitnessedParetoFront::new(
            &monoid,
            [ParetoWitness {
                resource: monoid.identity(),
                witness: 0,
            }],
        )
        .unwrap();
        let plan = FrozenParetoPlan::new(&frozen).unwrap();
        let selected_classes: Vec<_> = (0..3)
            .map(|state| frozen.entry_class(0, state).unwrap())
            .collect();
        let selected_query = plan.query(&selected_classes).unwrap();
        let mixed_classes = [
            selected_classes[0],
            frozen.class_range(1).unwrap().start,
            selected_classes[0],
        ];
        let mixed_query = plan.query(&mixed_classes).unwrap();
        let empty_query = plan.query(&[]).unwrap();
        assert!(matches!(
            plan.query(&[frozen.storage().classes as u32]),
            Err(FrozenParetoError::Artifact)
        ));
        for output_mask in 0_u32..8 {
            let outputs = [0, 1, 2].map(|output| {
                if output_mask & (1 << output) == 0 {
                    empty.clone()
                } else {
                    identity.clone()
                }
            });
            for edge_resource in 0..monoid.element_count() {
                let edges = [WitnessedParetoFront::new(
                    &monoid,
                    [ParetoWitness {
                        resource: edge_resource,
                        witness: 1,
                    }],
                )
                .unwrap()];
                let mut workspace = WitnessedParetoWorkspace::with_capacity(2);
                let workspace_storage = workspace.entries.as_ptr();
                let (empty_selected, empty_metrics) = empty_query
                    .evaluate(&monoid, &[], &edges, &mut workspace, |_, _, _| {
                        unreachable!("an empty query must not compose witnesses")
                    })
                    .unwrap();
                assert!(empty_selected.is_empty());
                assert_eq!(empty_metrics, FrozenParetoEvaluationMetrics::default());
                let quotient = plan
                    .evaluate(
                        &monoid,
                        &outputs,
                        &edges,
                        &mut workspace,
                        |_, edge, child| edge | (child << 1),
                    )
                    .unwrap();
                let (selected, selected_metrics) = selected_query
                    .evaluate(
                        &monoid,
                        &outputs,
                        &edges,
                        &mut workspace,
                        |_, edge, child| edge | (child << 1),
                    )
                    .unwrap();
                let (mixed, _) = mixed_query
                    .evaluate(
                        &monoid,
                        &outputs,
                        &edges,
                        &mut workspace,
                        |_, edge, child| edge | (child << 1),
                    )
                    .unwrap();
                assert_eq!(workspace.entries.as_ptr(), workspace_storage);
                assert_eq!(
                    mixed[0].resources().collect::<Vec<_>>(),
                    mixed[2].resources().collect::<Vec<_>>()
                );
                assert_eq!(
                    mixed[1].resources().collect::<Vec<_>>(),
                    quotient[mixed_classes[1] as usize]
                        .as_ref()
                        .unwrap()
                        .resources()
                        .collect::<Vec<_>>()
                );
                assert!(selected_metrics.peak_live_classes <= frozen.storage().classes);
                for state in 0..3 {
                    let target = if state < 2 { 0 } else { 1 };
                    let entries = workspace
                        .compose(
                            &monoid,
                            &edges[0],
                            &outputs[target as usize + 1],
                            |edge, child| Ok::<_, Infallible>(edge | (child << 1)),
                        )
                        .unwrap();
                    let extension =
                        WitnessedParetoFront::new(&monoid, entries.iter().copied()).unwrap();
                    let raw = outputs[0].choice(&monoid, &extension).unwrap();
                    let class = frozen.entry_class(0, state).unwrap();
                    assert_eq!(
                        quotient[class as usize]
                            .as_ref()
                            .unwrap()
                            .resources()
                            .collect::<Vec<_>>(),
                        raw.resources().collect::<Vec<_>>()
                    );
                    assert_eq!(
                        selected[state as usize].resources().collect::<Vec<_>>(),
                        raw.resources().collect::<Vec<_>>()
                    );
                }
            }
        }

        let mut workspace = WitnessedParetoWorkspace::with_capacity(2);
        assert_eq!(
            plan.evaluate(&monoid, &[empty], &[], &mut workspace, |_, _, _| 0),
            Err(FrozenParetoError::EdgeFrontCount)
        );
        let larger = CappedAdditiveMonoid::new([2]).unwrap();
        let foreign = WitnessedParetoFront::new(
            &larger,
            [ParetoWitness {
                resource: 2,
                witness: 0,
            }],
        )
        .unwrap();
        let foreign_outputs = [foreign.clone(), foreign.clone(), foreign];
        let valid_edges = [identity];
        assert!(matches!(
            selected_query.evaluate(
                &monoid,
                &foreign_outputs,
                &valid_edges,
                &mut workspace,
                |_, _, _| 0,
            ),
            Err(FrozenParetoError::Resource(OrderedResourceError::Element {
                element: 2
            }))
        ));
    }
}
