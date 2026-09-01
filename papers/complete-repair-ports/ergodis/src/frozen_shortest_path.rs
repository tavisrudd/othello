//! Allocation-free label setting over a compiled observational quotient.

use std::mem::{align_of, size_of};

use thiserror::Error;

use crate::ordered_resource::FrozenParetoPlan;

/// Sentinel used for an unavailable terminal or transition cost.
pub const ABSENT_SHORTEST_PATH_COST: u64 = u64::MAX;
const NO_CLASS: u32 = u32::MAX;

#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub struct FrozenShortestPathMetrics {
    pub settled_classes: usize,
    pub scanned_transitions: usize,
    pub successful_relaxations: usize,
    pub peak_heap_classes: usize,
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct FrozenShortestPathResult {
    pub cost: u64,
    pub terminal_class: u32,
    pub generators: Box<[u32]>,
    pub metrics: FrozenShortestPathMetrics,
}

#[derive(Clone, Copy, Debug, Error, Eq, PartialEq)]
pub enum FrozenShortestPathError {
    #[error("the frozen quotient is malformed or incompatible with the plan")]
    Artifact,
    #[error("the output-cost table does not interpret every quotient output")]
    OutputCostCount,
    #[error("the transition-cost table has the wrong length")]
    TransitionCostCount,
    #[error("the entry class lies outside the frozen quotient")]
    EntryClass,
    #[error("no finite terminal is reachable from the entry class")]
    Unreachable,
    #[error("a path cost or compact index overflowed")]
    Overflow,
    #[error("the shortest-path workspace was built for a different plan size")]
    WorkspaceShape,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
struct Predecessor {
    class: u32,
    generator: u32,
}

const _: () = assert!(size_of::<Predecessor>() == 8 && align_of::<Predecessor>() == 4);

/// Cold topology wrapper for forward label setting over a frozen quotient.
pub struct FrozenShortestPathPlan<'plan, 'frozen> {
    pareto: &'plan FrozenParetoPlan<'frozen>,
    class_sorts: Box<[u32]>,
}

/// Objective tables checked once before repeated shortest-path queries.
pub struct ValidatedFrozenShortestPathObjective<'plan, 'frozen, 'objective> {
    plan: &'objective FrozenShortestPathPlan<'plan, 'frozen>,
    output_costs: &'objective [u64],
    transition_costs: &'objective [u64],
}

/// Reusable, presized mutable state. Every solve-loop byte is worker-owned.
pub struct FrozenShortestPathWorkspace {
    distances: Vec<u64>,
    predecessors: Vec<Predecessor>,
    positions: Vec<u32>,
    heap: Vec<u32>,
    replay: Vec<u32>,
}

impl<'plan, 'frozen> FrozenShortestPathPlan<'plan, 'frozen> {
    pub fn new(pareto: &'plan FrozenParetoPlan<'frozen>) -> Result<Self, FrozenShortestPathError> {
        let class_count = pareto.frozen.storage().classes;
        if class_count > u32::MAX as usize {
            return Err(FrozenShortestPathError::Overflow);
        }
        let mut class_sorts = vec![NO_CLASS; class_count];
        for sort in 0..pareto.frozen.sort_count() {
            let range = pareto
                .frozen
                .class_range(sort as u32)
                .ok_or(FrozenShortestPathError::Artifact)?;
            let start = range.start as usize;
            let end = start
                .checked_add(range.len as usize)
                .ok_or(FrozenShortestPathError::Overflow)?;
            let slots = class_sorts
                .get_mut(start..end)
                .ok_or(FrozenShortestPathError::Artifact)?;
            if slots.iter().any(|&owner| owner != NO_CLASS) {
                return Err(FrozenShortestPathError::Artifact);
            }
            slots.fill(sort as u32);
        }
        if class_sorts.contains(&NO_CLASS) {
            return Err(FrozenShortestPathError::Artifact);
        }
        Ok(Self {
            pareto,
            class_sorts: class_sorts.into_boxed_slice(),
        })
    }

    pub fn class_count(&self) -> usize {
        self.class_sorts.len()
    }

    pub fn transition_cost_count(&self) -> usize {
        self.pareto.transition_front_count()
    }

    pub fn validate_objective<'objective>(
        &'objective self,
        output_costs: &'objective [u64],
        transition_costs: &'objective [u64],
    ) -> Result<
        ValidatedFrozenShortestPathObjective<'plan, 'frozen, 'objective>,
        FrozenShortestPathError,
    > {
        if transition_costs.len() != self.transition_cost_count() {
            return Err(FrozenShortestPathError::TransitionCostCount);
        }
        for class in 0..self.class_count() as u32 {
            let output = self
                .pareto
                .frozen
                .output(class)
                .ok_or(FrozenShortestPathError::Artifact)? as usize;
            if output >= output_costs.len() {
                return Err(FrozenShortestPathError::OutputCostCount);
            }
        }
        Ok(ValidatedFrozenShortestPathObjective {
            plan: self,
            output_costs,
            transition_costs,
        })
    }

    pub fn solve(
        &self,
        entry_class: u32,
        output_costs: &[u64],
        transition_costs: &[u64],
        workspace: &mut FrozenShortestPathWorkspace,
    ) -> Result<FrozenShortestPathResult, FrozenShortestPathError> {
        let objective = self.validate_objective(output_costs, transition_costs)?;
        self.solve_validated(entry_class, &objective, workspace)
    }

    pub fn solve_validated(
        &self,
        entry_class: u32,
        objective: &ValidatedFrozenShortestPathObjective<'_, '_, '_>,
        workspace: &mut FrozenShortestPathWorkspace,
    ) -> Result<FrozenShortestPathResult, FrozenShortestPathError> {
        if !std::ptr::eq(self, objective.plan) {
            return Err(FrozenShortestPathError::Artifact);
        }
        let entry = entry_class as usize;
        if entry >= self.class_count() {
            return Err(FrozenShortestPathError::EntryClass);
        }
        workspace.prepare(self.class_count())?;
        workspace.distances[entry] = 0;
        heap_push_or_decrease(
            entry_class,
            &workspace.distances,
            &mut workspace.heap,
            &mut workspace.positions,
        )?;

        let mut metrics = FrozenShortestPathMetrics {
            peak_heap_classes: 1,
            ..FrozenShortestPathMetrics::default()
        };
        let mut best_cost = ABSENT_SHORTEST_PATH_COST;
        let mut terminal_class = NO_CLASS;

        #[cfg(test)]
        let _allocation_guard = crate::test_alloc::HotLoopAllocationGuard::enter();

        while let Some(class) = heap_pop_min(
            &mut workspace.heap,
            &mut workspace.positions,
            &workspace.distances,
        ) {
            let distance = workspace.distances[class as usize];
            if distance >= best_cost {
                break;
            }
            metrics.settled_classes += 1;
            let output = self
                .pareto
                .frozen
                .output(class)
                .ok_or(FrozenShortestPathError::Artifact)? as usize;
            let output_cost = objective.output_costs[output];
            if output_cost != ABSENT_SHORTEST_PATH_COST {
                let candidate = distance
                    .checked_add(output_cost)
                    .ok_or(FrozenShortestPathError::Overflow)?;
                if candidate < best_cost {
                    best_cost = candidate;
                    terminal_class = class;
                }
            }
            if distance >= best_cost {
                continue;
            }

            let sort = self.class_sorts[class as usize] as usize;
            let range = self
                .pareto
                .frozen
                .class_range(sort as u32)
                .ok_or(FrozenShortestPathError::Artifact)?;
            let outgoing =
                &self.pareto.outgoing[self.pareto.offsets[sort]..self.pareto.offsets[sort + 1]];
            let transition_base = self.pareto.transition_sort_offsets[sort]
                + (class - range.start) as usize * outgoing.len();
            for (local, &generator) in outgoing.iter().enumerate() {
                metrics.scanned_transitions += 1;
                let edge_cost = objective.transition_costs[transition_base + local];
                if edge_cost == ABSENT_SHORTEST_PATH_COST {
                    continue;
                }
                let target = self
                    .pareto
                    .frozen
                    .transition(generator, class)
                    .ok_or(FrozenShortestPathError::Artifact)?;
                let candidate = distance
                    .checked_add(edge_cost)
                    .ok_or(FrozenShortestPathError::Overflow)?;
                if candidate < workspace.distances[target as usize] {
                    workspace.distances[target as usize] = candidate;
                    workspace.predecessors[target as usize] = Predecessor { class, generator };
                    heap_push_or_decrease(
                        target,
                        &workspace.distances,
                        &mut workspace.heap,
                        &mut workspace.positions,
                    )?;
                    metrics.successful_relaxations += 1;
                    metrics.peak_heap_classes = metrics.peak_heap_classes.max(workspace.heap.len());
                }
            }
        }

        #[cfg(test)]
        drop(_allocation_guard);

        if terminal_class == NO_CLASS {
            return Err(FrozenShortestPathError::Unreachable);
        }
        workspace.replay.clear();
        let mut class = terminal_class;
        while class != entry_class {
            let predecessor = workspace.predecessors[class as usize];
            if predecessor.class == NO_CLASS
                || workspace.replay.len() == workspace.replay.capacity()
            {
                return Err(FrozenShortestPathError::Artifact);
            }
            workspace.replay.push(predecessor.generator);
            class = predecessor.class;
        }
        workspace.replay.reverse();
        Ok(FrozenShortestPathResult {
            cost: best_cost,
            terminal_class,
            generators: workspace.replay.clone().into_boxed_slice(),
            metrics,
        })
    }

    pub fn verify_result(
        &self,
        entry_class: u32,
        objective: &ValidatedFrozenShortestPathObjective<'_, '_, '_>,
        result: &FrozenShortestPathResult,
    ) -> Result<(), FrozenShortestPathError> {
        if !std::ptr::eq(self, objective.plan) || entry_class as usize >= self.class_count() {
            return Err(FrozenShortestPathError::Artifact);
        }
        let mut class = entry_class;
        let mut cost = 0_u64;
        for &generator in result.generators.iter() {
            let sort = self.class_sorts[class as usize] as usize;
            let outgoing =
                &self.pareto.outgoing[self.pareto.offsets[sort]..self.pareto.offsets[sort + 1]];
            let local = outgoing
                .iter()
                .position(|&candidate| candidate == generator)
                .ok_or(FrozenShortestPathError::Artifact)?;
            let range = self
                .pareto
                .frozen
                .class_range(sort as u32)
                .ok_or(FrozenShortestPathError::Artifact)?;
            let transition = self.pareto.transition_sort_offsets[sort]
                + (class - range.start) as usize * outgoing.len()
                + local;
            let edge_cost = objective.transition_costs[transition];
            if edge_cost == ABSENT_SHORTEST_PATH_COST {
                return Err(FrozenShortestPathError::Artifact);
            }
            cost = cost
                .checked_add(edge_cost)
                .ok_or(FrozenShortestPathError::Overflow)?;
            class = self
                .pareto
                .frozen
                .transition(generator, class)
                .ok_or(FrozenShortestPathError::Artifact)?;
        }
        if class != result.terminal_class {
            return Err(FrozenShortestPathError::Artifact);
        }
        let output = self
            .pareto
            .frozen
            .output(class)
            .ok_or(FrozenShortestPathError::Artifact)? as usize;
        let output_cost = objective.output_costs[output];
        if output_cost == ABSENT_SHORTEST_PATH_COST
            || cost.checked_add(output_cost) != Some(result.cost)
        {
            return Err(FrozenShortestPathError::Artifact);
        }
        Ok(())
    }
}

impl FrozenShortestPathWorkspace {
    pub fn new(class_count: usize) -> Result<Self, FrozenShortestPathError> {
        if class_count > u32::MAX as usize {
            return Err(FrozenShortestPathError::Overflow);
        }
        Ok(Self {
            distances: vec![ABSENT_SHORTEST_PATH_COST; class_count],
            predecessors: vec![
                Predecessor {
                    class: NO_CLASS,
                    generator: u32::MAX,
                };
                class_count
            ],
            positions: vec![NO_CLASS; class_count],
            heap: Vec::with_capacity(class_count),
            replay: Vec::with_capacity(class_count),
        })
    }

    fn prepare(&mut self, class_count: usize) -> Result<(), FrozenShortestPathError> {
        if self.distances.len() != class_count
            || self.predecessors.len() != class_count
            || self.positions.len() != class_count
            || self.heap.capacity() < class_count
            || self.replay.capacity() < class_count
        {
            return Err(FrozenShortestPathError::WorkspaceShape);
        }
        self.distances.fill(ABSENT_SHORTEST_PATH_COST);
        self.predecessors.fill(Predecessor {
            class: NO_CLASS,
            generator: u32::MAX,
        });
        self.positions.fill(NO_CLASS);
        self.heap.clear();
        self.replay.clear();
        Ok(())
    }
}

fn heap_push_or_decrease(
    class: u32,
    distances: &[u64],
    heap: &mut Vec<u32>,
    positions: &mut [u32],
) -> Result<(), FrozenShortestPathError> {
    let position = positions[class as usize];
    let mut child = if position == NO_CLASS {
        if heap.len() == heap.capacity() {
            return Err(FrozenShortestPathError::WorkspaceShape);
        }
        heap.push(class);
        let position = heap.len() - 1;
        positions[class as usize] = position as u32;
        position
    } else {
        position as usize
    };
    while child != 0 {
        let parent = (child - 1) / 2;
        let parent_class = heap[parent];
        if (distances[parent_class as usize], parent_class) <= (distances[class as usize], class) {
            break;
        }
        heap[child] = parent_class;
        positions[parent_class as usize] = child as u32;
        child = parent;
    }
    heap[child] = class;
    positions[class as usize] = child as u32;
    Ok(())
}

fn heap_pop_min(heap: &mut Vec<u32>, positions: &mut [u32], distances: &[u64]) -> Option<u32> {
    let minimum = *heap.first()?;
    let last = heap.pop().expect("the heap was observed nonempty");
    positions[minimum as usize] = NO_CLASS;
    if heap.is_empty() {
        return Some(minimum);
    }
    let mut parent = 0_usize;
    while let Some(left) = parent.checked_mul(2).and_then(|value| value.checked_add(1)) {
        if left >= heap.len() {
            break;
        }
        let right = left + 1;
        let child = if right < heap.len()
            && (distances[heap[right] as usize], heap[right])
                < (distances[heap[left] as usize], heap[left])
        {
            right
        } else {
            left
        };
        if (distances[last as usize], last) <= (distances[heap[child] as usize], heap[child]) {
            break;
        }
        let displaced = heap[child];
        heap[parent] = displaced;
        positions[displaced as usize] = parent as u32;
        parent = child;
    }
    heap[parent] = last;
    positions[last as usize] = parent as u32;
    Some(minimum)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::observational::{compile_layered_frozen_dag_audited, LayeredGeneratorSpec};

    fn tiny_fixture() -> (
        crate::observational::FrozenObservation,
        Box<[u64]>,
        Box<[u64]>,
        u32,
    ) {
        let generators = [
            LayeredGeneratorSpec {
                source_sort: 0,
                target_sort: 1,
            },
            LayeredGeneratorSpec {
                source_sort: 0,
                target_sort: 1,
            },
            LayeredGeneratorSpec {
                source_sort: 1,
                target_sort: 2,
            },
        ];
        let mut audit = Vec::new();
        let (frozen, _) = compile_layered_frozen_dag_audited(
            &[2, 2, 1],
            &generators,
            &[0, 1, 2],
            |sort, state| sort * 2 + state,
            |generator, state| match generator {
                0 => state,
                1 => 1 - state,
                2 => 0,
                _ => unreachable!(),
            },
            &mut audit,
        )
        .unwrap();
        let pareto = FrozenParetoPlan::new(&frozen).unwrap();
        let mut transition_costs = vec![ABSENT_SHORTEST_PATH_COST; pareto.transition_front_count()];
        for state in 0..2_u32 {
            let class = frozen.entry_class(0, state).unwrap();
            transition_costs[pareto.transition_front_index(class, 0).unwrap()] = 4 - state as u64;
            transition_costs[pareto.transition_front_index(class, 1).unwrap()] = 1 + state as u64;
        }
        for state in 0..2_u32 {
            let class = frozen.entry_class(1, state).unwrap();
            transition_costs[pareto.transition_front_index(class, 2).unwrap()] = 2 + state as u64;
        }
        let output_count = (0..frozen.storage().classes as u32)
            .map(|class| frozen.output(class).unwrap())
            .max()
            .unwrap() as usize
            + 1;
        let mut output_costs = vec![ABSENT_SHORTEST_PATH_COST; output_count];
        output_costs[frozen.output(frozen.entry_class(2, 0).unwrap()).unwrap() as usize] = 3;
        let entry = frozen.entry_class(0, 0).unwrap();
        (
            frozen,
            output_costs.into_boxed_slice(),
            transition_costs.into_boxed_slice(),
            entry,
        )
    }

    #[test]
    fn forward_shortest_path_preserves_class_local_costs_and_replay() {
        let (frozen, outputs, transitions, entry) = tiny_fixture();
        let pareto = FrozenParetoPlan::new(&frozen).unwrap();
        let plan = FrozenShortestPathPlan::new(&pareto).unwrap();
        let objective = plan.validate_objective(&outputs, &transitions).unwrap();
        let mut workspace = FrozenShortestPathWorkspace::new(plan.class_count()).unwrap();
        let result = plan
            .solve_validated(entry, &objective, &mut workspace)
            .unwrap();
        assert_eq!(result.cost, 7);
        assert_eq!(&*result.generators, &[1, 2]);
        assert_eq!(result.metrics.settled_classes, 4);
        plan.verify_result(entry, &objective, &result).unwrap();
    }

    #[test]
    fn forward_shortest_path_hot_loop_allocates_nothing() {
        let (frozen, outputs, transitions, entry) = tiny_fixture();
        let pareto = FrozenParetoPlan::new(&frozen).unwrap();
        let plan = FrozenShortestPathPlan::new(&pareto).unwrap();
        let objective = plan.validate_objective(&outputs, &transitions).unwrap();
        let mut workspace = FrozenShortestPathWorkspace::new(plan.class_count()).unwrap();
        let expected = plan
            .solve_validated(entry, &objective, &mut workspace)
            .unwrap();
        let (answer, events) = crate::test_alloc::measure_allocations(|| {
            plan.solve_validated(entry, &objective, &mut workspace)
                .unwrap()
        });
        assert_eq!(answer, expected);
        assert_eq!(events, Default::default());
    }

    #[test]
    fn forward_shortest_path_rejects_bad_tables_and_unreachable_entries() {
        let (frozen, outputs, transitions, entry) = tiny_fixture();
        let pareto = FrozenParetoPlan::new(&frozen).unwrap();
        let plan = FrozenShortestPathPlan::new(&pareto).unwrap();
        assert!(matches!(
            plan.validate_objective(&outputs, &transitions[..transitions.len() - 1]),
            Err(FrozenShortestPathError::TransitionCostCount)
        ));
        assert!(matches!(
            plan.validate_objective(&[], &transitions),
            Err(FrozenShortestPathError::OutputCostCount)
        ));
        let no_outputs = vec![ABSENT_SHORTEST_PATH_COST; outputs.len()];
        let objective = plan.validate_objective(&no_outputs, &transitions).unwrap();
        let mut workspace = FrozenShortestPathWorkspace::new(plan.class_count()).unwrap();
        assert_eq!(
            plan.solve_validated(entry, &objective, &mut workspace),
            Err(FrozenShortestPathError::Unreachable)
        );
    }
}
