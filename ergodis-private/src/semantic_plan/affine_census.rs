//! Registered optimized adapter for the exact `AG(3,3)` nine-set census.
//!
//! Preparation owns every allocation. The prepared match/reduce and
//! canonicalization stages reuse fixed-capacity state and allocate nothing.

use super::dataflow::{
    compile_recipe, AdapterRegistry, ArgumentDomain, DataflowBudget, OperationSignature,
    ParameterSignature, SourceSignature,
};
use super::execution::{
    compile_execution_plan, execute_prepared, ExecutionPlan, ExecutionStage,
    PreparedSemanticRuntime, ReducerLane,
};
use super::{parse_semantic_recipe, OpKind};
use crate::semantic_sets::{for_each_k_subset, FixedMaskSet, TernaryPartitionMaxOverlapProfiler};
use ergodis::control::ControlError;

pub const RECIPE_TEXT: &str = r#"
recipe affine_caps {
  source split_nine_sets as objects sort nine_set_stream;
  label (g2 == 0) && (g3 == 0);
  provenance "sha256:fixture";
  match affine_subspace(rank=2, metric=max_overlap) from objects as plane sort feature_row retain 1 memory 4096;
  reduce overlap_histogram(weighted=true) from plane as extrema sort retained_set retain 2106 memory 131072;
  canonicalize affine_generators(count=4) from extrema as cap_orbit sort orbit_summary retain 2106 memory 131072 streamed false contract diagnostic verified true;
  emit cap_orbit;
  verify replay;
}
"#;

const UNIVERSE_SIZE: usize = 27;
const OBJECT_SIZE: usize = 9;
const MINIMUM_STRATUM_BOUND: usize = 2106;
const AFFINE_GROUP_ORDER: usize = 27 * (27 - 1) * (27 - 3) * (27 - 9);
const GENERATORS: [([u8; 9], u8); 4] = [
    ([1, 0, 0, 0, 1, 0, 0, 0, 1], 1),
    ([0, 1, 0, 1, 0, 0, 0, 0, 1], 0),
    ([1, 0, 0, 0, 0, 1, 0, 1, 0], 0),
    ([1, 1, 0, 0, 1, 0, 0, 0, 1], 0),
];

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct AffineCensusResult {
    pub ambient_subsets: u64,
    pub histogram: [u64; OBJECT_SIZE + 1],
    pub minimum: u32,
    pub minimum_count: u64,
    pub minimum_all_caps: bool,
    pub representative: u64,
    pub orbit_size: usize,
    pub affine_group_order: usize,
}

impl AffineCensusResult {
    #[must_use]
    pub const fn stabilizer_order(self) -> usize {
        self.affine_group_order / self.orbit_size
    }

    #[must_use]
    pub const fn is_single_minimum_orbit(self) -> bool {
        self.orbit_size as u64 == self.minimum_count
    }
}

pub fn registry() -> Result<AdapterRegistry, ControlError> {
    AdapterRegistry::try_new(
        vec![SourceSignature {
            name: "split_nine_sets".into(),
            output_sort: "nine_set_stream".into(),
        }],
        vec![
            OperationSignature {
                name: "affine_subspace".into(),
                kind: OpKind::Match,
                input_sorts: Box::new(["nine_set_stream".into()]),
                output_sort: "feature_row".into(),
                parameters: Box::new([
                    ParameterSignature {
                        name: "rank".into(),
                        domain: ArgumentDomain::Integer {
                            minimum: 1,
                            maximum: 3,
                        },
                    },
                    ParameterSignature {
                        name: "metric".into(),
                        domain: ArgumentDomain::Name {
                            choices: Box::new(["max_overlap".into(), "incidence".into()]),
                        },
                    },
                ]),
                max_retention: 1,
                max_memory_bytes: 4096,
                allows_streamed_partition: false,
            },
            OperationSignature {
                name: "overlap_histogram".into(),
                kind: OpKind::Reduce,
                input_sorts: Box::new(["feature_row".into()]),
                output_sort: "retained_set".into(),
                parameters: Box::new([ParameterSignature {
                    name: "weighted".into(),
                    domain: ArgumentDomain::Boolean,
                }]),
                max_retention: MINIMUM_STRATUM_BOUND as u64,
                max_memory_bytes: 131072,
                allows_streamed_partition: false,
            },
            OperationSignature {
                name: "affine_generators".into(),
                kind: OpKind::Canonicalize,
                input_sorts: Box::new(["retained_set".into()]),
                output_sort: "orbit_summary".into(),
                parameters: Box::new([ParameterSignature {
                    name: "count".into(),
                    domain: ArgumentDomain::Integer {
                        minimum: 1,
                        maximum: 16,
                    },
                }]),
                max_retention: MINIMUM_STRATUM_BOUND as u64,
                max_memory_bytes: 131072,
                allows_streamed_partition: false,
            },
        ],
    )
}

pub fn compile_plan(registry: &AdapterRegistry) -> Result<ExecutionPlan, ControlError> {
    let recipe = parse_semantic_recipe(RECIPE_TEXT)?;
    let compiled = compile_recipe(
        &recipe,
        registry,
        DataflowBudget {
            max_total_retention: 5000,
            max_total_memory_bytes: 300_000,
        },
    )?;
    compile_execution_plan(&compiled)
}

pub struct AffineCensusRuntime {
    registry_canonical: Box<[u8]>,
    profiler: TernaryPartitionMaxOverlapProfiler,
    lines: Box<[u64]>,
    orbit_seen: FixedMaskSet,
    orbit_objects: Vec<u64>,
    ambient_subsets: u64,
    minimum: u32,
    minimum_count: u64,
    minimum_all_caps: bool,
    representative: u64,
}

impl AffineCensusRuntime {
    pub fn try_new(registry: &AdapterRegistry) -> Result<Self, ControlError> {
        let planes = affine_subspaces(2);
        let lines = affine_subspaces(1);
        if planes.len() != 39 || lines.len() != 117 {
            return invalid("affine subspace compiler returned the wrong family size");
        }
        let profiler = TernaryPartitionMaxOverlapProfiler::try_new(
            planes,
            (1_u64 << UNIVERSE_SIZE) - 1,
            OBJECT_SIZE,
        )
        .map_err(|message| ControlError::Invalid(message.into()))?;
        if profiler.partitions() != 13 {
            return invalid("affine plane compiler returned the wrong partition count");
        }
        Ok(Self {
            registry_canonical: registry.canonical_json()?.into_boxed_slice(),
            profiler,
            lines: lines.into_boxed_slice(),
            orbit_seen: FixedMaskSet::with_max_items(MINIMUM_STRATUM_BOUND),
            orbit_objects: Vec::with_capacity(MINIMUM_STRATUM_BOUND),
            ambient_subsets: 0,
            minimum: OBJECT_SIZE as u32,
            minimum_count: 0,
            minimum_all_caps: true,
            representative: 0,
        })
    }

    pub fn result(&self) -> Result<AffineCensusResult, ControlError> {
        let histogram: [u64; OBJECT_SIZE + 1] =
            self.profiler.histogram().try_into().map_err(|_| {
                ControlError::Invalid("affine histogram has the wrong width".into())
            })?;
        if self.orbit_objects.is_empty() {
            return invalid("affine census has not completed canonicalization");
        }
        Ok(AffineCensusResult {
            ambient_subsets: self.ambient_subsets,
            histogram,
            minimum: self.minimum,
            minimum_count: self.minimum_count,
            minimum_all_caps: self.minimum_all_caps,
            representative: self.representative,
            orbit_size: self.orbit_objects.len(),
            affine_group_order: AFFINE_GROUP_ORDER,
        })
    }

    fn reset_profile(&mut self) {
        self.profiler.clear();
        self.ambient_subsets = 0;
        self.minimum = OBJECT_SIZE as u32;
        self.minimum_count = 0;
        self.minimum_all_caps = true;
        self.representative = 0;
    }
}

impl PreparedSemanticRuntime for AffineCensusRuntime {
    fn registry_canonical(&self) -> &[u8] {
        &self.registry_canonical
    }

    fn run_fused_match_reduce(
        &mut self,
        stage: ExecutionStage,
        inputs: &[u16],
        reducers: &[ReducerLane],
        arguments: &[i64],
    ) -> Result<(), ControlError> {
        if inputs != [0]
            || stage.primary_signature() != 0
            || stage.arguments(arguments) != Some(&[2, 0])
            || reducers.len() != 1
            || reducers[0].signature() != 1
            || reducers[0].arguments(arguments) != Some(&[1])
        {
            return invalid("prepared affine census received an incompatible match/reduce stage");
        }
        self.reset_profile();
        let profiler = &mut self.profiler;
        let lines = &self.lines;
        let ambient_subsets = &mut self.ambient_subsets;
        let minimum = &mut self.minimum;
        let minimum_count = &mut self.minimum_count;
        let minimum_all_caps = &mut self.minimum_all_caps;
        let representative = &mut self.representative;
        for_each_k_subset(UNIVERSE_SIZE, OBJECT_SIZE, |mask| {
            *ambient_subsets += 1;
            let overlap = profiler.observe(mask, 1);
            if overlap < *minimum {
                *minimum = overlap;
                *minimum_count = 0;
                *minimum_all_caps = true;
                *representative = mask;
            }
            if overlap == *minimum {
                *minimum_count += 1;
                *minimum_all_caps &= lines.iter().all(|line| (mask & line).count_ones() <= 2);
                if subset_lexicographically_precedes(mask, *representative) {
                    *representative = mask;
                }
            }
        });
        Ok(())
    }

    fn run_reduce(
        &mut self,
        _stage: ExecutionStage,
        _inputs: &[u16],
        _arguments: &[i64],
    ) -> Result<(), ControlError> {
        invalid("affine census reducers must remain fused with the matcher")
    }

    fn run_canonicalize(
        &mut self,
        stage: ExecutionStage,
        inputs: &[u16],
        arguments: &[i64],
    ) -> Result<(), ControlError> {
        if inputs != [2]
            || stage.primary_signature() != 2
            || stage.arguments(arguments) != Some(&[4])
        {
            return invalid("prepared affine census received an incompatible canonicalizer");
        }
        self.orbit_seen.clear();
        self.orbit_objects.clear();
        self.orbit_seen
            .try_insert(self.representative)
            .map_err(|message| ControlError::Invalid(message.into()))?;
        self.orbit_objects.push(self.representative);
        let mut cursor = 0;
        while cursor < self.orbit_objects.len() {
            let object = self.orbit_objects[cursor];
            cursor += 1;
            for &(matrix, translation) in &GENERATORS {
                let image = transform_mask(object, &matrix, translation);
                if self
                    .orbit_seen
                    .try_insert(image)
                    .map_err(|message| ControlError::Invalid(message.into()))?
                {
                    if self.orbit_objects.len() == self.orbit_objects.capacity() {
                        return invalid("affine orbit exceeds its prepared retention bound");
                    }
                    self.orbit_objects.push(image);
                }
            }
        }
        Ok(())
    }
}

pub fn run() -> Result<AffineCensusResult, ControlError> {
    let registry = registry()?;
    let plan = compile_plan(&registry)?;
    let mut runtime = AffineCensusRuntime::try_new(&registry)?;
    execute_prepared(&plan, &mut runtime)?;
    runtime.result()
}

#[must_use]
pub fn affine_subspaces(rank: usize) -> Vec<u64> {
    let mut linear = Vec::new();
    if rank == 1 {
        for first in 1..27_u8 {
            linear.push((1_u64 << 0) | (1_u64 << first) | (1_u64 << scale(first, 2)));
        }
    } else {
        for first in 1..27_u8 {
            for second in (first + 1)..27_u8 {
                if second == scale(first, 2) {
                    continue;
                }
                let mut mask = 0;
                for left in 0..3_u8 {
                    for right in 0..3_u8 {
                        mask |= 1_u64 << add(scale(first, left), scale(second, right));
                    }
                }
                linear.push(mask);
            }
        }
    }
    linear.sort_unstable();
    linear.dedup();
    let mut affine = Vec::with_capacity(linear.len() * 27);
    for mask in linear {
        for translation in 0..27_u8 {
            affine.push(transform_mask(
                mask,
                &[1, 0, 0, 0, 1, 0, 0, 0, 1],
                translation,
            ));
        }
    }
    affine.sort_unstable();
    affine.dedup();
    affine
}

#[inline]
fn add(left: u8, right: u8) -> u8 {
    let mut result = 0_u8;
    let mut place = 1_u8;
    let mut left = left;
    let mut right = right;
    for _ in 0..3 {
        result += ((left % 3 + right % 3) % 3) * place;
        left /= 3;
        right /= 3;
        place *= 3;
    }
    result
}

#[inline]
fn scale(value: u8, scalar: u8) -> u8 {
    match scalar {
        0 => 0,
        1 => value,
        2 => add(value, value),
        _ => unreachable!(),
    }
}

#[inline]
fn transform_point(point: u8, matrix: &[u8; 9], translation: u8) -> u8 {
    let vector = [point % 3, (point / 3) % 3, (point / 9) % 3];
    let shift = [
        translation % 3,
        (translation / 3) % 3,
        (translation / 9) % 3,
    ];
    let mut result = 0_u8;
    let mut place = 1_u8;
    for row in 0..3 {
        let coordinate = (shift[row]
            + matrix[3 * row] * vector[0]
            + matrix[3 * row + 1] * vector[1]
            + matrix[3 * row + 2] * vector[2])
            % 3;
        result += coordinate * place;
        place *= 3;
    }
    result
}

#[inline]
fn transform_mask(mut mask: u64, matrix: &[u8; 9], translation: u8) -> u64 {
    let mut transformed = 0_u64;
    while mask != 0 {
        let point = mask.trailing_zeros() as u8;
        transformed |= 1_u64 << transform_point(point, matrix, translation);
        mask &= mask - 1;
    }
    transformed
}

#[inline]
fn subset_lexicographically_precedes(mut left: u64, mut right: u64) -> bool {
    while left != 0 {
        let left_point = left.trailing_zeros();
        let right_point = right.trailing_zeros();
        if left_point != right_point {
            return left_point < right_point;
        }
        left &= left - 1;
        right &= right - 1;
    }
    false
}

fn invalid<T>(message: &str) -> Result<T, ControlError> {
    Err(ControlError::Invalid(message.into()))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn registered_optimized_adapter_replays_the_exact_census() {
        let result = run().unwrap();
        assert_eq!(result.ambient_subsets, 4_686_825);
        assert_eq!(
            result.histogram,
            [0, 0, 0, 0, 2106, 2_070_198, 2_393_352, 214_812, 6318, 39]
        );
        assert_eq!(result.minimum, 4);
        assert_eq!(result.minimum_count, 2106);
        assert!(result.minimum_all_caps);
        assert_eq!(result.orbit_size, 2106);
        assert!(result.is_single_minimum_orbit());
        assert_eq!(result.stabilizer_order(), 144);
        assert_eq!(
            result.representative,
            [0_u8, 1, 3, 4, 9, 10, 14, 17, 23]
                .into_iter()
                .fold(0_u64, |mask, point| mask | (1_u64 << point))
        );
    }

    #[test]
    fn prepared_runtime_is_reusable_without_state_leakage() {
        let registry = registry().unwrap();
        let plan = compile_plan(&registry).unwrap();
        let mut runtime = AffineCensusRuntime::try_new(&registry).unwrap();
        execute_prepared(&plan, &mut runtime).unwrap();
        let first = runtime.result().unwrap();
        let (replay, allocations) =
            crate::allocation_test::tracked_allocations(|| execute_prepared(&plan, &mut runtime));
        replay.unwrap();
        assert_eq!(allocations, 0);
        assert_eq!(runtime.result().unwrap(), first);
    }
}
