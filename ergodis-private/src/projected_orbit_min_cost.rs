//! Domain-neutral exact minimum-cost synthesis for projected orbit choices.
//!
//! Every optional orbit contributes a constant amplitude to one projection
//! lane and belongs to one quota family. Compilation discovers the connected
//! components of the lane/family collision graph. Evaluation solves each
//! component by a bounded iterative mixed-radix DP.

use serde::Serialize;
use thiserror::Error;

const MAX_FAMILIES: usize = 16;
const MAX_LANES: usize = 256;
const MAX_ITEMS_PER_LANE: usize = 8;
const UNREACHABLE: u32 = u32::MAX;

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ProjectedOrbitItem {
    pub lane: u16,
    pub family: u8,
    pub amplitude: u8,
}

const _: () = assert!(std::mem::size_of::<ProjectedOrbitItem>() == 4);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ProjectedOrbitBudget {
    pub maximum_states: usize,
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum ProjectedOrbitMinCostError {
    #[error("projected-orbit input semantics are invalid")]
    SemanticMismatch,
    #[error("projected-orbit state budget exceeded: required {required}, budget {budget}")]
    StateBudget { required: usize, budget: usize },
}

#[derive(Clone, Copy, Debug, Default, Serialize, PartialEq, Eq)]
pub struct ProjectedOrbitComponentReport {
    pub families: u8,
    pub lanes: u16,
    pub items: u16,
    pub states: u32,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct ProjectedOrbitCompileReport {
    pub families: u8,
    pub lanes: u16,
    pub items: u16,
    pub collision_components: u8,
    pub components: Box<[ProjectedOrbitComponentReport]>,
    pub maximum_component_families: u8,
    pub maximum_component_lanes: u16,
    pub maximum_items_per_lane: u8,
    pub provenance: &'static str,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
struct Component {
    family_mask: u16,
    lane_start: u16,
    lane_len: u16,
    item_count: u16,
}

const _: () = assert!(std::mem::size_of::<Component>() == 8);

pub struct ProjectedOrbitMinCostKernel {
    lane_weights: Box<[u16]>,
    lane_offsets: Box<[u16]>,
    items: Box<[ProjectedOrbitItem]>,
    component_lanes: Box<[u16]>,
    components: Box<[Component]>,
    family_count: u8,
    budget: ProjectedOrbitBudget,
    report: ProjectedOrbitCompileReport,
}

pub struct ProjectedOrbitMinCostWorkspace {
    current: Box<[u32]>,
    next: Box<[u32]>,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
struct TableComponent {
    family_mask: u16,
    _pad: u16,
    values_start: u32,
}

const _: () = assert!(std::mem::size_of::<TableComponent>() == 8);

/// A fixed-projection table compiled once for allocation-free quota lookup.
pub struct ProjectedOrbitMinCostTable {
    components: Box<[TableComponent]>,
    values: Box<[u32]>,
    family_capacities: [u8; MAX_FAMILIES],
    family_count: u8,
    fixed_only_cost: u32,
}

impl ProjectedOrbitMinCostTable {
    #[inline(always)]
    pub fn minimum(&self, quotas: &[u8]) -> Result<u32, ProjectedOrbitMinCostError> {
        if quotas.len() != usize::from(self.family_count)
            || quotas
                .iter()
                .zip(self.family_capacities)
                .any(|(&quota, capacity)| quota > capacity)
        {
            return Err(ProjectedOrbitMinCostError::SemanticMismatch);
        }
        let mut answer = self.fixed_only_cost;
        for component in &self.components {
            let mut target = 0_usize;
            let mut stride = 1_usize;
            for family in 0..usize::from(self.family_count) {
                if component.family_mask & (1 << family) == 0 {
                    continue;
                }
                target += usize::from(quotas[family]) * stride;
                stride *= usize::from(self.family_capacities[family]) + 1;
            }
            let value = self.values[component.values_start as usize + target];
            if value == UNREACHABLE {
                return Err(ProjectedOrbitMinCostError::SemanticMismatch);
            }
            answer = answer
                .checked_add(value)
                .ok_or(ProjectedOrbitMinCostError::SemanticMismatch)?;
        }
        Ok(answer)
    }
}

impl ProjectedOrbitMinCostWorkspace {
    pub fn new(maximum_states: usize) -> Result<Self, ProjectedOrbitMinCostError> {
        if maximum_states == 0 {
            return Err(ProjectedOrbitMinCostError::SemanticMismatch);
        }
        Ok(Self {
            current: vec![UNREACHABLE; maximum_states].into_boxed_slice(),
            next: vec![UNREACHABLE; maximum_states].into_boxed_slice(),
        })
    }

    pub fn workspace_bytes(&self) -> u64 {
        (self.current.len() * 2 * std::mem::size_of::<u32>()) as u64
    }
}

impl ProjectedOrbitMinCostKernel {
    pub fn compile(
        lane_weights: &[u16],
        family_count: u8,
        items: &[ProjectedOrbitItem],
        budget: ProjectedOrbitBudget,
    ) -> Result<Self, ProjectedOrbitMinCostError> {
        let lanes = lane_weights.len();
        let families = usize::from(family_count);
        if lanes == 0
            || lanes > MAX_LANES
            || families == 0
            || families > MAX_FAMILIES
            || budget.maximum_states == 0
            || items.len() > u16::MAX as usize
            || lane_weights.contains(&0)
            || items.is_empty()
            || items.iter().any(|item| {
                usize::from(item.lane) >= lanes
                    || usize::from(item.family) >= families
                    || item.amplitude == 0
            })
        {
            return Err(ProjectedOrbitMinCostError::SemanticMismatch);
        }
        let mut sorted = items.to_vec();
        sorted.sort_unstable_by_key(|item| (item.lane, item.family, item.amplitude));
        let mut lane_offsets = vec![0_u16; lanes + 1];
        for item in &sorted {
            lane_offsets[usize::from(item.lane) + 1] += 1;
        }
        for lane in 0..lanes {
            lane_offsets[lane + 1] += lane_offsets[lane];
            if usize::from(lane_offsets[lane + 1] - lane_offsets[lane]) > MAX_ITEMS_PER_LANE {
                return Err(ProjectedOrbitMinCostError::SemanticMismatch);
            }
        }

        let mut parent: [u8; MAX_FAMILIES] = std::array::from_fn(|index| index as u8);
        for lane in 0..lanes {
            let range = usize::from(lane_offsets[lane])..usize::from(lane_offsets[lane + 1]);
            let Some(first) = sorted.get(range.clone()).and_then(|slice| slice.first()) else {
                continue;
            };
            for item in &sorted[range] {
                union(&mut parent, first.family, item.family);
            }
        }
        for family in 0..families {
            parent[family] = find(&parent, family as u8);
        }
        let mut roots = [u8::MAX; MAX_FAMILIES];
        let mut component_count = 0_usize;
        for item in &sorted {
            let root = parent[usize::from(item.family)];
            if roots[usize::from(root)] == u8::MAX {
                roots[usize::from(root)] = component_count as u8;
                component_count += 1;
            }
        }
        let mut component_lanes = Vec::with_capacity(lanes);
        let mut components = Vec::with_capacity(component_count);
        let mut reports = Vec::with_capacity(component_count);
        let mut max_component_families = 0_u8;
        let mut max_component_lanes = 0_u16;
        for component_id in 0..component_count {
            let mut family_mask = 0_u16;
            let lane_start = component_lanes.len() as u16;
            let mut item_count = 0_u16;
            for lane in 0..lanes {
                let range = usize::from(lane_offsets[lane])..usize::from(lane_offsets[lane + 1]);
                let Some(first) = sorted.get(range.clone()).and_then(|slice| slice.first()) else {
                    continue;
                };
                let root = parent[usize::from(first.family)];
                if usize::from(roots[usize::from(root)]) != component_id {
                    continue;
                }
                component_lanes.push(lane as u16);
                item_count += (range.end - range.start) as u16;
                for item in &sorted[range] {
                    family_mask |= 1 << item.family;
                }
            }
            let lane_len = component_lanes.len() as u16 - lane_start;
            let family_len = family_mask.count_ones() as u8;
            max_component_families = max_component_families.max(family_len);
            max_component_lanes = max_component_lanes.max(lane_len);
            components.push(Component {
                family_mask,
                lane_start,
                lane_len,
                item_count,
            });
            reports.push(ProjectedOrbitComponentReport {
                families: family_len,
                lanes: lane_len,
                items: item_count,
                states: 0,
            });
        }
        let report = ProjectedOrbitCompileReport {
            families: family_count,
            lanes: lanes as u16,
            items: sorted.len() as u16,
            collision_components: component_count as u8,
            components: reports.into_boxed_slice(),
            maximum_component_families: max_component_families,
            maximum_component_lanes: max_component_lanes,
            maximum_items_per_lane: lane_offsets
                .windows(2)
                .map(|pair| pair[1] - pair[0])
                .max()
                .unwrap_or(0) as u8,
            provenance: "domain-neutral compilation of the bipartite family/lane collision graph from projected orbit contributions; scopes are connected components discovered from the supplied data",
        };
        Ok(Self {
            lane_weights: lane_weights.to_vec().into_boxed_slice(),
            lane_offsets: lane_offsets.into_boxed_slice(),
            items: sorted.into_boxed_slice(),
            component_lanes: component_lanes.into_boxed_slice(),
            components: components.into_boxed_slice(),
            family_count,
            budget,
            report,
        })
    }

    pub fn report(&self) -> &ProjectedOrbitCompileReport {
        &self.report
    }

    pub fn compile_quota_table(
        &self,
        fixed: &[u8],
        workspace: &mut ProjectedOrbitMinCostWorkspace,
    ) -> Result<ProjectedOrbitMinCostTable, ProjectedOrbitMinCostError> {
        if fixed.len() != self.lane_weights.len() {
            return Err(ProjectedOrbitMinCostError::SemanticMismatch);
        }
        let mut family_capacities = [0_u8; MAX_FAMILIES];
        for item in &self.items {
            family_capacities[usize::from(item.family)] = family_capacities
                [usize::from(item.family)]
            .checked_add(1)
            .ok_or(ProjectedOrbitMinCostError::SemanticMismatch)?;
        }
        let mut tables = Vec::with_capacity(self.components.len());
        let mut values = Vec::new();
        let mut lane_has_items = [false; MAX_LANES];
        for component in &self.components {
            let mut families = [0_u8; MAX_FAMILIES];
            let mut family_len = 0_usize;
            let mut strides = [0_usize; MAX_FAMILIES];
            let mut state_count = 1_usize;
            for family in 0..usize::from(self.family_count) {
                if component.family_mask & (1 << family) == 0 {
                    continue;
                }
                families[family_len] = family as u8;
                strides[family_len] = state_count;
                state_count = state_count
                    .checked_mul(usize::from(family_capacities[family]) + 1)
                    .ok_or(ProjectedOrbitMinCostError::StateBudget {
                        required: usize::MAX,
                        budget: self.budget.maximum_states,
                    })?;
                family_len += 1;
            }
            if state_count > self.budget.maximum_states || state_count > workspace.current.len() {
                return Err(ProjectedOrbitMinCostError::StateBudget {
                    required: state_count,
                    budget: self.budget.maximum_states.min(workspace.current.len()),
                });
            }
            workspace.current[..state_count].fill(UNREACHABLE);
            workspace.current[0] = 0;
            let lanes = usize::from(component.lane_start)
                ..usize::from(component.lane_start + component.lane_len);
            for lane_index in lanes {
                let lane = usize::from(self.component_lanes[lane_index]);
                lane_has_items[lane] = true;
                workspace.next[..state_count].fill(UNREACHABLE);
                let item_start = usize::from(self.lane_offsets[lane]);
                let item_end = usize::from(self.lane_offsets[lane + 1]);
                let item_len = item_end - item_start;
                for state in 0..state_count {
                    let base = workspace.current[state];
                    if base == UNREACHABLE {
                        continue;
                    }
                    for subset in 0..1_usize << item_len {
                        let mut increments = [0_u8; MAX_FAMILIES];
                        let mut amplitude = 0_u16;
                        for local_item in 0..item_len {
                            if subset & (1 << local_item) != 0 {
                                let item = self.items[item_start + local_item];
                                increments[usize::from(item.family)] += 1;
                                amplitude += u16::from(item.amplitude);
                            }
                        }
                        let mut next_state = state;
                        let mut valid = true;
                        for local in 0..family_len {
                            let family = usize::from(families[local]);
                            let radix = usize::from(family_capacities[family]) + 1;
                            let used = state / strides[local] % radix;
                            let increment = usize::from(increments[family]);
                            if used + increment >= radix {
                                valid = false;
                                break;
                            }
                            next_state += increment * strides[local];
                        }
                        if valid {
                            let coefficient = u32::from(fixed[lane]) + u32::from(amplitude);
                            let cost = base
                                + u32::from(self.lane_weights[lane]) * coefficient * coefficient;
                            workspace.next[next_state] = workspace.next[next_state].min(cost);
                        }
                    }
                }
                std::mem::swap(&mut workspace.current, &mut workspace.next);
            }
            let values_start = values.len() as u32;
            values.extend_from_slice(&workspace.current[..state_count]);
            tables.push(TableComponent {
                family_mask: component.family_mask,
                _pad: 0,
                values_start,
            });
        }
        let fixed_only_cost = (0..self.lane_weights.len())
            .filter(|&lane| !lane_has_items[lane])
            .map(|lane| u32::from(self.lane_weights[lane]) * u32::from(fixed[lane]).pow(2))
            .sum();
        Ok(ProjectedOrbitMinCostTable {
            components: tables.into_boxed_slice(),
            values: values.into_boxed_slice(),
            family_capacities,
            family_count: self.family_count,
            fixed_only_cost,
        })
    }

    pub fn minimum(
        &self,
        fixed: &[u8],
        quotas: &[u8],
        workspace: &mut ProjectedOrbitMinCostWorkspace,
    ) -> Result<u32, ProjectedOrbitMinCostError> {
        if fixed.len() != self.lane_weights.len() || quotas.len() != usize::from(self.family_count)
        {
            return Err(ProjectedOrbitMinCostError::SemanticMismatch);
        }
        let mut answer = 0_u32;
        let mut lane_has_items = [false; MAX_LANES];
        for component in &self.components {
            let mut families = [0_u8; MAX_FAMILIES];
            let mut family_len = 0_usize;
            for family in 0..usize::from(self.family_count) {
                if component.family_mask & (1 << family) != 0 {
                    families[family_len] = family as u8;
                    family_len += 1;
                }
            }
            let mut strides = [0_usize; MAX_FAMILIES];
            let mut state_count = 1_usize;
            for local in 0..family_len {
                strides[local] = state_count;
                state_count = state_count
                    .checked_mul(usize::from(quotas[usize::from(families[local])]) + 1)
                    .ok_or(ProjectedOrbitMinCostError::StateBudget {
                        required: usize::MAX,
                        budget: self.budget.maximum_states,
                    })?;
            }
            if state_count > self.budget.maximum_states || state_count > workspace.current.len() {
                return Err(ProjectedOrbitMinCostError::StateBudget {
                    required: state_count,
                    budget: self.budget.maximum_states.min(workspace.current.len()),
                });
            }
            workspace.current[..state_count].fill(UNREACHABLE);
            workspace.current[0] = 0;
            let lanes = usize::from(component.lane_start)
                ..usize::from(component.lane_start + component.lane_len);
            for lane_index in lanes {
                let lane = usize::from(self.component_lanes[lane_index]);
                lane_has_items[lane] = true;
                workspace.next[..state_count].fill(UNREACHABLE);
                let item_start = usize::from(self.lane_offsets[lane]);
                let item_end = usize::from(self.lane_offsets[lane + 1]);
                let item_len = item_end - item_start;
                debug_assert!(item_len <= MAX_ITEMS_PER_LANE);
                for state in 0..state_count {
                    let base = workspace.current[state];
                    if base == UNREACHABLE {
                        continue;
                    }
                    for subset in 0..1_usize << item_len {
                        let mut increments = [0_u8; MAX_FAMILIES];
                        let mut amplitude = 0_u16;
                        for local_item in 0..item_len {
                            if subset & (1 << local_item) == 0 {
                                continue;
                            }
                            let item = self.items[item_start + local_item];
                            amplitude += u16::from(item.amplitude);
                            increments[usize::from(item.family)] += 1;
                        }
                        let mut next_state = state;
                        let mut valid = true;
                        for local in 0..family_len {
                            let family = usize::from(families[local]);
                            let radix = usize::from(quotas[family]) + 1;
                            let used = state / strides[local] % radix;
                            let increment = usize::from(increments[family]);
                            if used + increment >= radix {
                                valid = false;
                                break;
                            }
                            next_state += increment * strides[local];
                        }
                        if !valid {
                            continue;
                        }
                        let coefficient = u32::from(fixed[lane]) + u32::from(amplitude);
                        let cost =
                            base + u32::from(self.lane_weights[lane]) * coefficient * coefficient;
                        workspace.next[next_state] = workspace.next[next_state].min(cost);
                    }
                }
                std::mem::swap(&mut workspace.current, &mut workspace.next);
            }
            let mut target = 0_usize;
            for local in 0..family_len {
                target += usize::from(quotas[usize::from(families[local])]) * strides[local];
            }
            let component_minimum = workspace.current[target];
            if component_minimum == UNREACHABLE {
                return Err(ProjectedOrbitMinCostError::SemanticMismatch);
            }
            answer = answer
                .checked_add(component_minimum)
                .ok_or(ProjectedOrbitMinCostError::SemanticMismatch)?;
        }
        for lane in 0..self.lane_weights.len() {
            if !lane_has_items[lane] {
                answer += u32::from(self.lane_weights[lane]) * u32::from(fixed[lane]).pow(2);
            }
        }
        Ok(answer)
    }

    pub fn replay_energy(
        &self,
        fixed: &[u8],
        selected: &[bool],
    ) -> Result<u32, ProjectedOrbitMinCostError> {
        if fixed.len() != self.lane_weights.len() || selected.len() != self.items.len() {
            return Err(ProjectedOrbitMinCostError::SemanticMismatch);
        }
        let mut coefficients = [0_u16; MAX_LANES];
        for lane in 0..fixed.len() {
            coefficients[lane] = u16::from(fixed[lane]);
        }
        for (item, &take) in self.items.iter().zip(selected) {
            if take {
                coefficients[usize::from(item.lane)] += u16::from(item.amplitude);
            }
        }
        Ok((0..fixed.len())
            .map(|lane| u32::from(self.lane_weights[lane]) * u32::from(coefficients[lane]).pow(2))
            .sum())
    }

    pub fn items(&self) -> &[ProjectedOrbitItem] {
        &self.items
    }
}

fn find(parent: &[u8; MAX_FAMILIES], mut value: u8) -> u8 {
    while parent[usize::from(value)] != value {
        value = parent[usize::from(value)];
    }
    value
}

fn union(parent: &mut [u8; MAX_FAMILIES], first: u8, second: u8) {
    let first = find(parent, first);
    let second = find(parent, second);
    if first != second {
        parent[usize::from(second)] = first;
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn holdout() -> (ProjectedOrbitMinCostKernel, ProjectedOrbitMinCostWorkspace) {
        let items = [
            ProjectedOrbitItem {
                lane: 0,
                family: 0,
                amplitude: 1,
            },
            ProjectedOrbitItem {
                lane: 0,
                family: 1,
                amplitude: 2,
            },
            ProjectedOrbitItem {
                lane: 1,
                family: 0,
                amplitude: 2,
            },
            ProjectedOrbitItem {
                lane: 2,
                family: 1,
                amplitude: 1,
            },
            ProjectedOrbitItem {
                lane: 2,
                family: 2,
                amplitude: 3,
            },
            ProjectedOrbitItem {
                lane: 3,
                family: 2,
                amplitude: 1,
            },
            ProjectedOrbitItem {
                lane: 4,
                family: 0,
                amplitude: 1,
            },
            ProjectedOrbitItem {
                lane: 4,
                family: 2,
                amplitude: 2,
            },
        ];
        let budget = ProjectedOrbitBudget { maximum_states: 64 };
        (
            ProjectedOrbitMinCostKernel::compile(&[2, 3, 1, 4, 2], 3, &items, budget).unwrap(),
            ProjectedOrbitMinCostWorkspace::new(budget.maximum_states).unwrap(),
        )
    }

    #[test]
    fn synthetic_holdout_matches_independent_full_subset_oracle() {
        let (kernel, mut workspace) = holdout();
        let fixed = [1, 0, 2, 1, 0];
        let quotas = [2, 1, 2];
        let exact = kernel.minimum(&fixed, &quotas, &mut workspace).unwrap();
        let mut best = u32::MAX;
        let mut selected = vec![false; kernel.items().len()];
        for subset in 0..1_usize << selected.len() {
            let mut counts = [0_u8; 3];
            for index in 0..selected.len() {
                selected[index] = subset & (1 << index) != 0;
                if selected[index] {
                    counts[usize::from(kernel.items()[index].family)] += 1;
                }
            }
            if counts == quotas {
                best = best.min(kernel.replay_energy(&fixed, &selected).unwrap());
            }
        }
        assert_eq!(exact, best);
        assert_eq!(kernel.report().collision_components, 1);
    }

    #[test]
    fn minimum_hot_loop_allocates_nothing() {
        let (kernel, mut workspace) = holdout();
        let fixed = [1, 0, 2, 1, 0];
        let quotas = [2, 1, 2];
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..32 {
                std::hint::black_box(kernel.minimum(&fixed, &quotas, &mut workspace).unwrap());
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn quota_table_matches_solver_and_lookup_allocates_nothing() {
        let (kernel, mut workspace) = holdout();
        let fixed = [1, 0, 2, 1, 0];
        let table = kernel.compile_quota_table(&fixed, &mut workspace).unwrap();
        for first in 0..=3 {
            for second in 0..=2 {
                for third in 0..=3 {
                    let quotas = [first, second, third];
                    assert_eq!(
                        table.minimum(&quotas).unwrap(),
                        kernel.minimum(&fixed, &quotas, &mut workspace).unwrap()
                    );
                }
            }
        }
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..128 {
                std::hint::black_box(table.minimum(&[2, 1, 2]).unwrap());
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn state_budget_fails_closed() {
        let (kernel, _) = holdout();
        let mut workspace = ProjectedOrbitMinCostWorkspace::new(8).unwrap();
        assert_eq!(
            kernel.minimum(&[0; 5], &[2, 1, 2], &mut workspace),
            Err(ProjectedOrbitMinCostError::StateBudget {
                required: 18,
                budget: 8
            })
        );
    }
}
