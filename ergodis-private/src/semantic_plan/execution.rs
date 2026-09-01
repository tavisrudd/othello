//! Zero-materialization execution schedule for prepared semantic runtimes.
//!
//! Dispatch occurs once per compiled stage. A `match` stream is never exposed
//! as an artifact: it must be immediately fused with its sole reducer, whose
//! implementation owns the allocation-free per-record loop.

use super::dataflow::{CompiledRecipe, CompiledRecipeOp};
use super::OpKind;
use ergodis::control::ControlError;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u8)]
pub enum ExecutionStageKind {
    FusedMatchReduce,
    Reduce,
    Canonicalize,
}

#[repr(C)]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ExecutionStage {
    retention: u64,
    memory_bytes: u64,
    primary_signature: u16,
    secondary_signature: u16,
    input_slot: u16,
    output_slot: u16,
    kind: ExecutionStageKind,
    flags: u8,
    _pad: [u8; 6],
}

impl ExecutionStage {
    #[must_use]
    pub const fn retention(self) -> u64 {
        self.retention
    }

    #[must_use]
    pub const fn memory_bytes(self) -> u64 {
        self.memory_bytes
    }

    #[must_use]
    pub const fn primary_signature(self) -> u16 {
        self.primary_signature
    }

    #[must_use]
    pub const fn secondary_signature(self) -> Option<u16> {
        if self.secondary_signature == u16::MAX {
            None
        } else {
            Some(self.secondary_signature)
        }
    }

    #[must_use]
    pub const fn input_slot(self) -> u16 {
        self.input_slot
    }

    #[must_use]
    pub const fn output_slot(self) -> u16 {
        self.output_slot
    }

    #[must_use]
    pub const fn kind(self) -> ExecutionStageKind {
        self.kind
    }

    #[must_use]
    pub const fn uses_streamed_partition(self) -> bool {
        self.flags & CompiledRecipeOp::STREAMED_PARTITION != 0
    }
}

const _: () = assert!(std::mem::size_of::<ExecutionStage>() == 32);
const _: () = assert!(std::mem::align_of::<ExecutionStage>() == 8);

#[derive(Debug, Clone)]
pub struct ExecutionPlan {
    source_signature: u16,
    slots: u16,
    output_slot: u16,
    stages: Box<[ExecutionStage]>,
}

impl ExecutionPlan {
    #[must_use]
    pub const fn source_signature(&self) -> u16 {
        self.source_signature
    }

    #[must_use]
    pub const fn slots(&self) -> u16 {
        self.slots
    }

    #[must_use]
    pub const fn output_slot(&self) -> u16 {
        self.output_slot
    }

    #[must_use]
    pub fn stages(&self) -> &[ExecutionStage] {
        &self.stages
    }
}

pub fn compile_execution_plan(compiled: &CompiledRecipe) -> Result<ExecutionPlan, ControlError> {
    let operations = compiled.operations();
    let mut consumers = vec![0_u16; compiled.slots() as usize];
    for operation in operations {
        let count = &mut consumers[operation.input_slot() as usize];
        *count = count
            .checked_add(1)
            .ok_or_else(|| ControlError::Invalid("semantic slot consumer overflow".into()))?;
    }
    for operation in operations {
        if consumers[operation.output_slot() as usize] == 0
            && operation.output_slot() != compiled.output_slot()
        {
            return invalid("semantic execution plan contains a dead output");
        }
    }

    let mut stages = Vec::with_capacity(operations.len());
    let mut at = 0;
    while at < operations.len() {
        let operation = operations[at];
        match operation.kind() {
            OpKind::Match => {
                let reducer = operations.get(at + 1).copied().ok_or_else(|| {
                    ControlError::Invalid("semantic match has no adjacent reducer".into())
                })?;
                if consumers[operation.output_slot() as usize] != 1
                    || reducer.kind() != OpKind::Reduce
                    || reducer.input_slot() != operation.output_slot()
                {
                    return invalid(
                        "semantic match must feed exactly one immediately adjacent reducer",
                    );
                }
                stages.push(ExecutionStage {
                    retention: reducer.retention(),
                    memory_bytes: operation
                        .memory_bytes()
                        .checked_add(reducer.memory_bytes())
                        .ok_or_else(|| {
                            ControlError::Invalid("fused semantic stage memory overflow".into())
                        })?,
                    primary_signature: operation.signature(),
                    secondary_signature: reducer.signature(),
                    input_slot: operation.input_slot(),
                    output_slot: reducer.output_slot(),
                    kind: ExecutionStageKind::FusedMatchReduce,
                    flags: 0,
                    _pad: [0; 6],
                });
                at += 2;
            }
            OpKind::Reduce => {
                stages.push(single_stage(operation, ExecutionStageKind::Reduce));
                at += 1;
            }
            OpKind::Canonicalize => {
                stages.push(single_stage(operation, ExecutionStageKind::Canonicalize));
                at += 1;
            }
        }
    }
    Ok(ExecutionPlan {
        source_signature: compiled.source_signature(),
        slots: compiled.slots(),
        output_slot: compiled.output_slot(),
        stages: stages.into_boxed_slice(),
    })
}

fn single_stage(operation: CompiledRecipeOp, kind: ExecutionStageKind) -> ExecutionStage {
    ExecutionStage {
        retention: operation.retention(),
        memory_bytes: operation.memory_bytes(),
        primary_signature: operation.signature(),
        secondary_signature: u16::MAX,
        input_slot: operation.input_slot(),
        output_slot: operation.output_slot(),
        kind,
        flags: if operation.uses_streamed_partition() {
            CompiledRecipeOp::STREAMED_PARTITION
        } else {
            0
        },
        _pad: [0; 6],
    }
}

/// A domain runtime prepared with every arena and workspace needed by `plan`.
/// Implementations must not allocate, serialize, or perform per-record dynamic
/// dispatch from these methods; the feature/search loop stays inside the
/// selected fused adapter.
pub trait PreparedSemanticRuntime {
    fn run_fused_match_reduce(&mut self, stage: ExecutionStage) -> Result<(), ControlError>;
    fn run_reduce(&mut self, stage: ExecutionStage) -> Result<(), ControlError>;
    fn run_canonicalize(&mut self, stage: ExecutionStage) -> Result<(), ControlError>;
}

/// Execute one already-prepared plan. This loop itself allocates nothing and
/// performs one branch plus one runtime call per stage, never per record.
pub fn execute_prepared(
    plan: &ExecutionPlan,
    runtime: &mut impl PreparedSemanticRuntime,
) -> Result<(), ControlError> {
    for &stage in plan.stages() {
        match stage.kind() {
            ExecutionStageKind::FusedMatchReduce => runtime.run_fused_match_reduce(stage)?,
            ExecutionStageKind::Reduce => runtime.run_reduce(stage)?,
            ExecutionStageKind::Canonicalize => runtime.run_canonicalize(stage)?,
        }
    }
    Ok(())
}

fn invalid<T>(message: &str) -> Result<T, ControlError> {
    Err(ControlError::Invalid(message.into()))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::semantic_plan::dataflow::{
        compile_recipe, AdapterRegistry, DataflowBudget, OperationSignature, SourceSignature,
    };
    use crate::semantic_plan::parse_semantic_recipe;

    const TEXT: &str = r#"
recipe affine_caps {
  source split_nine_sets as objects sort nine_set_stream;
  label (g2 == 0) && (g3 == 0);
  provenance "sha256:fixture";
  match affine_subspace from objects as plane sort feature_row retain 1 memory 4096;
  reduce overlap_histogram from plane as extrema sort retained_set retain 2106 memory 131072;
  canonicalize affine_generators from extrema as cap_orbit sort orbit_summary retain 2106 memory 131072 streamed false contract diagnostic verified true;
  emit cap_orbit;
  verify replay;
}
"#;

    fn registry() -> AdapterRegistry {
        registry_with("retained_set", false)
    }

    fn registry_with(canonical_input_sort: &str, streamed: bool) -> AdapterRegistry {
        AdapterRegistry::try_new(
            vec![SourceSignature {
                name: "split_nine_sets".into(),
                output_sort: "nine_set_stream".into(),
            }],
            vec![
                OperationSignature {
                    name: "affine_subspace".into(),
                    kind: OpKind::Match,
                    input_sort: "nine_set_stream".into(),
                    output_sort: "feature_row".into(),
                    max_retention: 1,
                    max_memory_bytes: 4096,
                    allows_streamed_partition: false,
                },
                OperationSignature {
                    name: "overlap_histogram".into(),
                    kind: OpKind::Reduce,
                    input_sort: "feature_row".into(),
                    output_sort: "retained_set".into(),
                    max_retention: 2106,
                    max_memory_bytes: 131072,
                    allows_streamed_partition: false,
                },
                OperationSignature {
                    name: "affine_generators".into(),
                    kind: OpKind::Canonicalize,
                    input_sort: canonical_input_sort.into(),
                    output_sort: "orbit_summary".into(),
                    max_retention: 2106,
                    max_memory_bytes: 131072,
                    allows_streamed_partition: streamed,
                },
            ],
        )
        .unwrap()
    }

    fn plan(text: &str) -> Result<ExecutionPlan, ControlError> {
        let recipe = parse_semantic_recipe(text)?;
        let compiled = compile_recipe(
            &recipe,
            &registry(),
            DataflowBudget {
                max_total_retention: 5000,
                max_total_memory_bytes: 300_000,
            },
        )?;
        compile_execution_plan(&compiled)
    }

    #[derive(Default)]
    struct CountingRuntime {
        calls: [u8; 8],
        len: usize,
    }

    impl CountingRuntime {
        fn push(&mut self, value: u8) {
            self.calls[self.len] = value;
            self.len += 1;
        }
    }

    impl PreparedSemanticRuntime for CountingRuntime {
        fn run_fused_match_reduce(&mut self, stage: ExecutionStage) -> Result<(), ControlError> {
            assert_eq!(stage.secondary_signature(), Some(1));
            assert_eq!(stage.memory_bytes(), 135_168);
            self.push(1);
            Ok(())
        }

        fn run_reduce(&mut self, _stage: ExecutionStage) -> Result<(), ControlError> {
            self.push(2);
            Ok(())
        }

        fn run_canonicalize(&mut self, stage: ExecutionStage) -> Result<(), ControlError> {
            assert_eq!(stage.input_slot(), 2);
            assert_eq!(stage.output_slot(), 3);
            self.push(3);
            Ok(())
        }
    }

    #[test]
    fn schedule_fuses_streaming_match_and_reduce() {
        let plan = plan(TEXT).unwrap();
        assert_eq!(plan.source_signature(), 0);
        assert_eq!(plan.slots(), 4);
        assert_eq!(plan.output_slot(), 3);
        assert_eq!(plan.stages().len(), 2);
        assert_eq!(
            plan.stages()[0].kind(),
            ExecutionStageKind::FusedMatchReduce
        );
        assert_eq!(plan.stages()[1].kind(), ExecutionStageKind::Canonicalize);
        let mut runtime = CountingRuntime::default();
        execute_prepared(&plan, &mut runtime).unwrap();
        assert_eq!(&runtime.calls[..runtime.len], &[1, 3]);
    }

    #[test]
    fn schedule_rejects_unmaterialized_match_outputs() {
        let unfused = TEXT
            .replace(
                "  reduce overlap_histogram from plane as extrema sort retained_set retain 2106 memory 131072;\n",
                "",
            )
            .replace("from extrema as cap_orbit", "from plane as cap_orbit")
            .replace("streamed false", "streamed true");
        let recipe = parse_semantic_recipe(&unfused).unwrap();
        let compiled = compile_recipe(
            &recipe,
            &registry_with("feature_row", true),
            DataflowBudget {
                max_total_retention: 5000,
                max_total_memory_bytes: 300_000,
            },
        )
        .unwrap();
        assert!(compile_execution_plan(&compiled).is_err());
    }

    struct AffineCensusRuntime {
        planes: [u64; 39],
        lines: [u64; 117],
        histogram: [u64; 10],
        representative: u64,
        minimum: u32,
        minimum_count: u64,
        minimum_all_caps: bool,
        ambient_subsets: u64,
        orbit_slots: [u64; 8192],
        orbit_objects: [u64; 2106],
        orbit_len: usize,
    }

    impl AffineCensusRuntime {
        fn new() -> Self {
            Self {
                planes: affine_subspaces::<39>(2),
                lines: affine_subspaces::<117>(1),
                histogram: [0; 10],
                representative: 0,
                minimum: 9,
                minimum_count: 0,
                minimum_all_caps: true,
                ambient_subsets: 0,
                orbit_slots: [u64::MAX; 8192],
                orbit_objects: [0; 2106],
                orbit_len: 0,
            }
        }

        fn observe(&mut self, mask: u64) {
            let mut maximum = 0;
            for plane in self.planes {
                maximum = maximum.max((mask & plane).count_ones());
            }
            self.histogram[maximum as usize] += 1;
            self.ambient_subsets += 1;
            if maximum < self.minimum {
                self.minimum = maximum;
                self.minimum_count = 0;
                self.minimum_all_caps = true;
                self.representative = mask;
            }
            if maximum == self.minimum {
                self.minimum_count += 1;
                self.minimum_all_caps &= self
                    .lines
                    .iter()
                    .all(|line| (mask & line).count_ones() <= 2);
                if subset_lexicographically_precedes(mask, self.representative) {
                    self.representative = mask;
                }
            }
        }

        fn insert_orbit(&mut self, value: u64) -> bool {
            let mut slot = (value.wrapping_mul(0x9e37_79b9_7f4a_7c15) >> (64 - 13)) as usize;
            loop {
                let stored = self.orbit_slots[slot];
                if stored == value {
                    return false;
                }
                if stored == u64::MAX {
                    assert!(self.orbit_len < self.orbit_objects.len());
                    self.orbit_slots[slot] = value;
                    self.orbit_objects[self.orbit_len] = value;
                    self.orbit_len += 1;
                    return true;
                }
                slot = (slot + 1) & (self.orbit_slots.len() - 1);
            }
        }
    }

    impl PreparedSemanticRuntime for AffineCensusRuntime {
        fn run_fused_match_reduce(&mut self, stage: ExecutionStage) -> Result<(), ControlError> {
            assert_eq!(stage.kind(), ExecutionStageKind::FusedMatchReduce);
            let low = (1_u64 << 9) - 1;
            let last = low << (27 - 9);
            let mut mask = low;
            loop {
                self.observe(mask);
                if mask == last {
                    break;
                }
                let lowest = mask & mask.wrapping_neg();
                let incremented = mask + lowest;
                mask = incremented | (((incremented ^ mask) >> 2) >> lowest.trailing_zeros());
            }
            Ok(())
        }

        fn run_reduce(&mut self, _stage: ExecutionStage) -> Result<(), ControlError> {
            unreachable!("the affine plan fuses its match and reducer")
        }

        fn run_canonicalize(&mut self, stage: ExecutionStage) -> Result<(), ControlError> {
            assert_eq!(stage.kind(), ExecutionStageKind::Canonicalize);
            let generators = [
                ([1, 0, 0, 0, 1, 0, 0, 0, 1], 1),
                ([0, 1, 0, 1, 0, 0, 0, 0, 1], 0),
                ([1, 0, 0, 0, 0, 1, 0, 1, 0], 0),
                ([1, 1, 0, 0, 1, 0, 0, 0, 1], 0),
            ];
            self.orbit_slots.fill(u64::MAX);
            self.orbit_len = 0;
            self.insert_orbit(self.representative);
            let mut cursor = 0;
            while cursor < self.orbit_len {
                let object = self.orbit_objects[cursor];
                cursor += 1;
                for (matrix, translation) in generators {
                    let mut transformed = 0;
                    let mut points = object;
                    while points != 0 {
                        let point = points.trailing_zeros() as u8;
                        transformed |= 1_u64 << transform_point(point, &matrix, translation);
                        points &= points - 1;
                    }
                    self.insert_orbit(transformed);
                }
            }
            Ok(())
        }
    }

    #[test]
    fn prepared_pipeline_replays_the_full_affine_census() {
        let plan = plan(TEXT).unwrap();
        let mut runtime = AffineCensusRuntime::new();
        assert!(std::mem::size_of_val(&runtime) <= 300_000);
        execute_prepared(&plan, &mut runtime).unwrap();
        assert_eq!(runtime.ambient_subsets, 4_686_825);
        assert_eq!(runtime.minimum, 4);
        assert_eq!(runtime.minimum_count, 2106);
        assert!(runtime.minimum_all_caps);
        assert_eq!(
            runtime.histogram,
            [0, 0, 0, 0, 2106, 2_070_198, 2_393_352, 214_812, 6318, 39]
        );
        assert_eq!(runtime.orbit_len, 2106);
        assert_eq!(
            runtime.representative,
            [0_u8, 1, 3, 4, 9, 10, 14, 17, 23]
                .into_iter()
                .fold(0_u64, |mask, point| mask | (1_u64 << point))
        );
    }

    fn affine_subspaces<const N: usize>(rank: usize) -> [u64; N] {
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
                let mut translated = 0;
                let mut points = mask;
                while points != 0 {
                    let point = points.trailing_zeros() as u8;
                    translated |= 1_u64 << add(point, translation);
                    points &= points - 1;
                }
                affine.push(translated);
            }
        }
        affine.sort_unstable();
        affine.dedup();
        affine.try_into().unwrap_or_else(|values: Vec<u64>| {
            panic!("expected {N} affine subspaces, got {}", values.len())
        })
    }

    #[inline]
    fn add(mut left: u8, mut right: u8) -> u8 {
        let mut result = 0;
        let mut place = 1;
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

    fn transform_point(point: u8, matrix: &[u8; 9], translation: u8) -> u8 {
        let vector = [point % 3, (point / 3) % 3, (point / 9) % 3];
        let shift = [
            translation % 3,
            (translation / 3) % 3,
            (translation / 9) % 3,
        ];
        let mut result = 0;
        let mut place = 1;
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
}
