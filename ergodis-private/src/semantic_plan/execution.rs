//! Zero-materialization execution schedule for prepared semantic runtimes.
//!
//! Dispatch occurs once per compiled stage. A `match` stream is never exposed
//! as an artifact: it must be immediately fused with its bounded reducer bank,
//! whose implementation owns the allocation-free per-record loop.

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
pub struct ReducerLane {
    retention: u64,
    memory_bytes: u64,
    signature: u16,
    output_slot: u16,
    argument_start: u16,
    argument_count: u16,
}

impl ReducerLane {
    #[must_use]
    pub const fn retention(self) -> u64 {
        self.retention
    }

    #[must_use]
    pub const fn memory_bytes(self) -> u64 {
        self.memory_bytes
    }

    #[must_use]
    pub const fn signature(self) -> u16 {
        self.signature
    }

    #[must_use]
    pub const fn output_slot(self) -> u16 {
        self.output_slot
    }

    #[must_use]
    pub fn arguments(self, pool: &[i64]) -> Option<&[i64]> {
        let start = self.argument_start as usize;
        pool.get(start..start + self.argument_count as usize)
    }
}

const _: () = assert!(std::mem::size_of::<ReducerLane>() == 24);
const _: () = assert!(std::mem::align_of::<ReducerLane>() == 8);

#[repr(C)]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ExecutionStage {
    retention: u64,
    memory_bytes: u64,
    primary_signature: u16,
    input_start: u16,
    output_slot: u16,
    lane_start: u16,
    lane_count: u16,
    kind_flags: u8,
    input_count: u8,
    argument_start: u16,
    argument_count: u16,
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
    pub const fn output_slot(self) -> u16 {
        self.output_slot
    }

    #[must_use]
    pub const fn kind(self) -> ExecutionStageKind {
        match self.kind_flags & Self::KIND_MASK {
            0 => ExecutionStageKind::FusedMatchReduce,
            1 => ExecutionStageKind::Reduce,
            2 => ExecutionStageKind::Canonicalize,
            _ => unreachable!(),
        }
    }

    #[must_use]
    pub const fn reducer_lane_count(self) -> u16 {
        self.lane_count
    }

    #[must_use]
    pub fn arguments(self, pool: &[i64]) -> Option<&[i64]> {
        let start = self.argument_start as usize;
        pool.get(start..start + self.argument_count as usize)
    }

    #[must_use]
    pub const fn uses_streamed_partition(self) -> bool {
        self.kind_flags & CompiledRecipeOp::STREAMED_PARTITION != 0
    }

    const KIND_MASK: u8 = 0b11;
}

const _: () = assert!(std::mem::size_of::<ExecutionStage>() == 32);
const _: () = assert!(std::mem::align_of::<ExecutionStage>() == 8);

#[derive(Debug, Clone)]
pub struct ExecutionPlan {
    source_signature: u16,
    slots: u16,
    output_slot: u16,
    sink_slots: Box<[u16]>,
    stages: Box<[ExecutionStage]>,
    input_slots: Box<[u16]>,
    reducer_lanes: Box<[ReducerLane]>,
    arguments: Box<[i64]>,
    registry_canonical: Box<[u8]>,
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
    pub fn sink_slots(&self) -> &[u16] {
        &self.sink_slots
    }

    #[must_use]
    pub fn stages(&self) -> &[ExecutionStage] {
        &self.stages
    }

    #[must_use]
    pub fn input_slots(&self) -> &[u16] {
        &self.input_slots
    }

    #[must_use]
    pub fn reducer_lanes(&self) -> &[ReducerLane] {
        &self.reducer_lanes
    }

    #[must_use]
    pub fn arguments(&self) -> &[i64] {
        &self.arguments
    }

    #[must_use]
    pub fn registry_canonical(&self) -> &[u8] {
        &self.registry_canonical
    }

    fn stage_reducer_lanes(&self, stage: ExecutionStage) -> &[ReducerLane] {
        let start = stage.lane_start as usize;
        &self.reducer_lanes[start..start + stage.lane_count as usize]
    }

    fn stage_inputs(&self, stage: ExecutionStage) -> &[u16] {
        let start = stage.input_start as usize;
        &self.input_slots[start..start + stage.input_count as usize]
    }
}

pub fn compile_execution_plan(compiled: &CompiledRecipe) -> Result<ExecutionPlan, ControlError> {
    let operations = compiled.operations();
    let mut consumers = vec![0_u16; compiled.slots() as usize];
    for operation in operations {
        for &input_slot in compiled.operation_inputs(*operation) {
            let count = &mut consumers[input_slot as usize];
            *count = count
                .checked_add(1)
                .ok_or_else(|| ControlError::Invalid("semantic slot consumer overflow".into()))?;
        }
    }
    for operation in operations {
        if consumers[operation.output_slot() as usize] == 0
            && operation.output_slot() != compiled.output_slot()
            && !compiled.sink_slots().contains(&operation.output_slot())
        {
            return invalid("semantic execution plan contains a dead output");
        }
    }

    let mut stages = Vec::with_capacity(operations.len());
    let mut reducer_lanes = Vec::new();
    let mut at = 0;
    while at < operations.len() {
        let operation = operations[at];
        match operation.kind() {
            OpKind::Match => {
                let first_reducer = operations.get(at + 1).copied().ok_or_else(|| {
                    ControlError::Invalid("semantic match has no adjacent reducer".into())
                })?;
                if first_reducer.kind() != OpKind::Reduce
                    || compiled.operation_inputs(first_reducer) != [operation.output_slot()]
                {
                    return invalid(
                        "semantic match must feed an immediately adjacent reducer bank",
                    );
                }
                let lane_start = reducer_lanes.len();
                let mut next = at + 1;
                let mut retention = 0_u64;
                let mut memory_bytes = operation.memory_bytes();
                while let Some(reducer) = operations.get(next).copied() {
                    if reducer.kind() != OpKind::Reduce
                        || compiled.operation_inputs(reducer) != [operation.output_slot()]
                    {
                        break;
                    }
                    retention = retention.checked_add(reducer.retention()).ok_or_else(|| {
                        ControlError::Invalid("fused reducer retention overflow".into())
                    })?;
                    memory_bytes = memory_bytes
                        .checked_add(reducer.memory_bytes())
                        .ok_or_else(|| {
                            ControlError::Invalid("fused semantic stage memory overflow".into())
                        })?;
                    reducer_lanes.push(ReducerLane {
                        retention: reducer.retention(),
                        memory_bytes: reducer.memory_bytes(),
                        signature: reducer.signature(),
                        output_slot: reducer.output_slot(),
                        argument_start: compiled.operation_argument_range(next).0,
                        argument_count: compiled.operation_argument_range(next).1,
                    });
                    next += 1;
                }
                let lane_count = reducer_lanes.len() - lane_start;
                if usize::from(consumers[operation.output_slot() as usize]) != lane_count {
                    return invalid(
                        "semantic match consumers must all be adjacent reducers in one bank",
                    );
                }
                stages.push(ExecutionStage {
                    retention,
                    memory_bytes,
                    primary_signature: operation.signature(),
                    input_start: operation.input_start(),
                    output_slot: if lane_count == 1 {
                        reducer_lanes[lane_start].output_slot
                    } else {
                        u16::MAX
                    },
                    lane_start: u16::try_from(lane_start).map_err(|_| {
                        ControlError::Invalid("too many semantic reducer lanes".into())
                    })?,
                    lane_count: u16::try_from(lane_count).map_err(|_| {
                        ControlError::Invalid("too many semantic reducer lanes".into())
                    })?,
                    kind_flags: ExecutionStageKind::FusedMatchReduce as u8,
                    input_count: operation.input_count(),
                    argument_start: compiled.operation_argument_range(at).0,
                    argument_count: compiled.operation_argument_range(at).1,
                });
                at = next;
            }
            OpKind::Reduce => {
                stages.push(single_stage(
                    operation,
                    ExecutionStageKind::Reduce,
                    compiled.operation_argument_range(at),
                ));
                at += 1;
            }
            OpKind::Canonicalize => {
                stages.push(single_stage(
                    operation,
                    ExecutionStageKind::Canonicalize,
                    compiled.operation_argument_range(at),
                ));
                at += 1;
            }
        }
    }
    Ok(ExecutionPlan {
        source_signature: compiled.source_signature(),
        slots: compiled.slots(),
        output_slot: compiled.output_slot(),
        sink_slots: compiled.sink_slots().into(),
        stages: stages.into_boxed_slice(),
        input_slots: compiled.input_slots().into(),
        reducer_lanes: reducer_lanes.into_boxed_slice(),
        arguments: compiled.arguments().into(),
        registry_canonical: compiled.registry_canonical().into(),
    })
}

fn single_stage(
    operation: CompiledRecipeOp,
    kind: ExecutionStageKind,
    arguments: (u16, u16),
) -> ExecutionStage {
    ExecutionStage {
        retention: operation.retention(),
        memory_bytes: operation.memory_bytes(),
        primary_signature: operation.signature(),
        input_start: operation.input_start(),
        output_slot: operation.output_slot(),
        lane_start: 0,
        lane_count: 0,
        kind_flags: kind as u8
            | if operation.uses_streamed_partition() {
                CompiledRecipeOp::STREAMED_PARTITION
            } else {
                0
            },
        input_count: operation.input_count(),
        argument_start: arguments.0,
        argument_count: arguments.1,
    }
}

/// A domain runtime prepared with every arena and workspace needed by `plan`.
/// Implementations must not allocate, serialize, or perform per-record dynamic
/// dispatch from these methods; the feature/search loop stays inside the
/// selected fused adapter.
pub trait PreparedSemanticRuntime {
    fn registry_canonical(&self) -> &[u8];

    fn run_fused_match_reduce(
        &mut self,
        stage: ExecutionStage,
        inputs: &[u16],
        reducers: &[ReducerLane],
        arguments: &[i64],
    ) -> Result<(), ControlError>;
    fn run_reduce(
        &mut self,
        stage: ExecutionStage,
        inputs: &[u16],
        arguments: &[i64],
    ) -> Result<(), ControlError>;
    fn run_canonicalize(
        &mut self,
        stage: ExecutionStage,
        inputs: &[u16],
        arguments: &[i64],
    ) -> Result<(), ControlError>;
}

/// Execute one already-prepared plan. This loop itself allocates nothing and
/// performs one branch plus one runtime call per stage, never per record.
pub fn execute_prepared(
    plan: &ExecutionPlan,
    runtime: &mut impl PreparedSemanticRuntime,
) -> Result<(), ControlError> {
    if runtime.registry_canonical() != plan.registry_canonical() {
        return invalid("prepared semantic runtime uses a different adapter registry");
    }
    for &stage in plan.stages() {
        match stage.kind() {
            ExecutionStageKind::FusedMatchReduce => runtime.run_fused_match_reduce(
                stage,
                plan.stage_inputs(stage),
                plan.stage_reducer_lanes(stage),
                plan.arguments(),
            )?,
            ExecutionStageKind::Reduce => {
                runtime.run_reduce(stage, plan.stage_inputs(stage), plan.arguments())?
            }
            ExecutionStageKind::Canonicalize => {
                runtime.run_canonicalize(stage, plan.stage_inputs(stage), plan.arguments())?
            }
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
        compile_recipe, AdapterRegistry, ArgumentDomain, DataflowBudget, OperationSignature,
        ParameterSignature, SourceSignature,
    };
    use crate::semantic_plan::{format_semantic_recipe, parse_semantic_recipe};

    const TEXT: &str = r#"
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

    fn registry() -> AdapterRegistry {
        registry_with_options("retained_set", false, false)
    }

    fn registry_with(canonical_input_sort: &str, streamed: bool) -> AdapterRegistry {
        registry_with_options(canonical_input_sort, streamed, false)
    }

    fn registry_with_options(
        canonical_input_sort: &str,
        streamed: bool,
        fanout: bool,
    ) -> AdapterRegistry {
        let mut operations = vec![
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
                max_retention: 2106,
                max_memory_bytes: 131072,
                allows_streamed_partition: false,
            },
            OperationSignature {
                name: "affine_generators".into(),
                kind: OpKind::Canonicalize,
                input_sorts: Box::new([canonical_input_sort.into()]),
                output_sort: "orbit_summary".into(),
                parameters: Box::new([ParameterSignature {
                    name: "count".into(),
                    domain: ArgumentDomain::Integer {
                        minimum: 1,
                        maximum: 16,
                    },
                }]),
                max_retention: 2106,
                max_memory_bytes: 131072,
                allows_streamed_partition: streamed,
            },
        ];
        if fanout {
            operations.push(OperationSignature {
                name: "parity_histogram".into(),
                kind: OpKind::Reduce,
                input_sorts: Box::new(["feature_row".into()]),
                output_sort: "parity_summary".into(),
                parameters: Box::new([]),
                max_retention: 2,
                max_memory_bytes: 64,
                allows_streamed_partition: false,
            });
            operations.push(OperationSignature {
                name: "join_summaries".into(),
                kind: OpKind::Reduce,
                input_sorts: Box::new(["retained_set".into(), "parity_summary".into()]),
                output_sort: "joined_summary".into(),
                parameters: Box::new([]),
                max_retention: 1,
                max_memory_bytes: 64,
                allows_streamed_partition: false,
            });
        }
        AdapterRegistry::try_new(
            vec![SourceSignature {
                name: "split_nine_sets".into(),
                output_sort: "nine_set_stream".into(),
            }],
            operations,
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

    struct CountingRuntime {
        registry_canonical: Box<[u8]>,
        calls: [u8; 8],
        len: usize,
    }

    impl CountingRuntime {
        fn new(registry: &AdapterRegistry) -> Self {
            Self {
                registry_canonical: registry.canonical_json().unwrap().into_boxed_slice(),
                calls: [0; 8],
                len: 0,
            }
        }

        fn push(&mut self, value: u8) {
            self.calls[self.len] = value;
            self.len += 1;
        }
    }

    impl PreparedSemanticRuntime for CountingRuntime {
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
            assert_eq!(inputs, &[0]);
            assert_eq!(reducers.len(), 1);
            assert_eq!(reducers[0].signature(), 1);
            assert_eq!(stage.arguments(arguments), Some(&[2, 0][..]));
            assert_eq!(reducers[0].arguments(arguments), Some(&[1][..]));
            assert_eq!(stage.memory_bytes(), 135_168);
            self.push(1);
            Ok(())
        }

        fn run_reduce(
            &mut self,
            _stage: ExecutionStage,
            _inputs: &[u16],
            _arguments: &[i64],
        ) -> Result<(), ControlError> {
            self.push(2);
            Ok(())
        }

        fn run_canonicalize(
            &mut self,
            stage: ExecutionStage,
            inputs: &[u16],
            arguments: &[i64],
        ) -> Result<(), ControlError> {
            assert_eq!(inputs, &[2]);
            assert_eq!(stage.output_slot(), 3);
            assert_eq!(stage.arguments(arguments), Some(&[4][..]));
            self.push(3);
            Ok(())
        }
    }

    #[test]
    fn schedule_fuses_streaming_match_and_reduce() {
        let registry = registry();
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
        let mut runtime = CountingRuntime::new(&registry);
        execute_prepared(&plan, &mut runtime).unwrap();
        assert_eq!(&runtime.calls[..runtime.len], &[1, 3]);
        let wrong_registry = registry_with("feature_row", true);
        let mut wrong_runtime = CountingRuntime::new(&wrong_registry);
        assert!(execute_prepared(&plan, &mut wrong_runtime).is_err());
        assert_eq!(wrong_runtime.len, 0);
    }

    struct FanoutRuntime {
        registry_canonical: Box<[u8]>,
        sum_of_squares: u64,
        even_squares: u64,
        canonicalized: bool,
    }

    impl FanoutRuntime {
        fn new(registry: &AdapterRegistry) -> Self {
            Self {
                registry_canonical: registry.canonical_json().unwrap().into_boxed_slice(),
                sum_of_squares: 0,
                even_squares: 0,
                canonicalized: false,
            }
        }
    }

    impl PreparedSemanticRuntime for FanoutRuntime {
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
            assert_eq!(inputs, &[0]);
            assert_eq!(stage.reducer_lane_count(), 2);
            assert_eq!(reducers.len(), 2);
            assert_eq!(reducers[0].signature(), 1);
            assert_eq!(reducers[1].signature(), 3);
            assert_eq!(stage.arguments(arguments), Some(&[2, 0][..]));
            assert_eq!(reducers[0].arguments(arguments), Some(&[1][..]));
            assert_eq!(reducers[1].arguments(arguments), Some(&[][..]));
            for value in 0..64_u64 {
                let feature = value * value;
                self.sum_of_squares += feature;
                self.even_squares += u64::from(feature & 1 == 0);
            }
            Ok(())
        }

        fn run_reduce(
            &mut self,
            _stage: ExecutionStage,
            _inputs: &[u16],
            _arguments: &[i64],
        ) -> Result<(), ControlError> {
            unreachable!("the feature stream is fused into both reducers")
        }

        fn run_canonicalize(
            &mut self,
            _stage: ExecutionStage,
            _inputs: &[u16],
            _arguments: &[i64],
        ) -> Result<(), ControlError> {
            self.canonicalized = true;
            Ok(())
        }
    }

    #[test]
    fn one_match_dispatches_a_fixed_reducer_bank() {
        let fanout = TEXT
            .replace(
                "  reduce overlap_histogram(weighted=true) from plane as extrema sort retained_set retain 2106 memory 131072;\n",
                "  reduce overlap_histogram(weighted=true) from plane as extrema sort retained_set retain 2106 memory 131072;\n  reduce parity_histogram from plane as parity sort parity_summary retain 2 memory 64;\n",
            )
            .replace("  emit cap_orbit;", "  emit cap_orbit;\n  sink parity;");
        let recipe = parse_semantic_recipe(&fanout).unwrap();
        let registry = registry_with_options("retained_set", false, true);
        let compiled = compile_recipe(
            &recipe,
            &registry,
            DataflowBudget {
                max_total_retention: 5000,
                max_total_memory_bytes: 300_000,
            },
        )
        .unwrap();
        let plan = compile_execution_plan(&compiled).unwrap();
        assert_eq!(plan.stages().len(), 2);
        assert_eq!(plan.reducer_lanes().len(), 2);
        assert_eq!(plan.sink_slots(), &[3]);
        assert_eq!(plan.stages()[0].output_slot(), u16::MAX);
        let mut runtime = FanoutRuntime::new(&registry);
        execute_prepared(&plan, &mut runtime).unwrap();
        assert_eq!(runtime.sum_of_squares, 85_344);
        assert_eq!(runtime.even_squares, 32);
        assert!(runtime.canonicalized);
    }

    struct JoinRuntime {
        registry_canonical: Box<[u8]>,
        calls: [u8; 2],
        len: usize,
    }

    impl PreparedSemanticRuntime for JoinRuntime {
        fn registry_canonical(&self) -> &[u8] {
            &self.registry_canonical
        }

        fn run_fused_match_reduce(
            &mut self,
            _stage: ExecutionStage,
            inputs: &[u16],
            reducers: &[ReducerLane],
            _arguments: &[i64],
        ) -> Result<(), ControlError> {
            assert_eq!(inputs, &[0]);
            assert_eq!(reducers.len(), 2);
            self.calls[self.len] = 1;
            self.len += 1;
            Ok(())
        }

        fn run_reduce(
            &mut self,
            stage: ExecutionStage,
            inputs: &[u16],
            _arguments: &[i64],
        ) -> Result<(), ControlError> {
            assert_eq!(stage.primary_signature(), 4);
            assert_eq!(inputs, &[2, 3]);
            assert_eq!(stage.output_slot(), 4);
            self.calls[self.len] = 2;
            self.len += 1;
            Ok(())
        }

        fn run_canonicalize(
            &mut self,
            _stage: ExecutionStage,
            _inputs: &[u16],
            _arguments: &[i64],
        ) -> Result<(), ControlError> {
            unreachable!("join fixture has no canonicalization stage")
        }
    }

    #[test]
    fn bounded_reducer_outputs_feed_a_typed_multi_input_join() {
        let text = TEXT
            .replace(
                "  canonicalize affine_generators(count=4) from extrema as cap_orbit sort orbit_summary retain 2106 memory 131072 streamed false contract diagnostic verified true;\n",
                "  reduce parity_histogram from plane as parity sort parity_summary retain 2 memory 64;\n  reduce join_summaries from extrema, parity as joined sort joined_summary retain 1 memory 64;\n",
            )
            .replace("  emit cap_orbit;", "  emit joined;");
        let recipe = parse_semantic_recipe(&text).unwrap();
        assert_eq!(recipe.steps[3].inputs(), &["extrema", "parity"]);
        let formatted = format_semantic_recipe(&recipe).unwrap();
        assert!(formatted.contains("from extrema, parity as joined"));
        assert_eq!(
            parse_semantic_recipe(&formatted)
                .unwrap()
                .canonical_json()
                .unwrap(),
            recipe.canonical_json().unwrap()
        );
        let registry = registry_with_options("retained_set", false, true);
        let compiled = compile_recipe(
            &recipe,
            &registry,
            DataflowBudget {
                max_total_retention: 5000,
                max_total_memory_bytes: 300_000,
            },
        )
        .unwrap();
        let plan = compile_execution_plan(&compiled).unwrap();
        assert_eq!(plan.stages().len(), 2);
        assert_eq!(plan.input_slots(), &[0, 1, 1, 2, 3]);
        let mut runtime = JoinRuntime {
            registry_canonical: registry.canonical_json().unwrap().into_boxed_slice(),
            calls: [0; 2],
            len: 0,
        };
        execute_prepared(&plan, &mut runtime).unwrap();
        assert_eq!(runtime.calls, [1, 2]);

        let unbounded_join =
            TEXT.replace("from plane as extrema", "from plane, objects as extrema");
        assert!(parse_semantic_recipe(&unbounded_join).is_err());
    }

    #[test]
    fn schedule_rejects_unmaterialized_match_outputs() {
        let unfused = TEXT
            .replace(
                "  reduce overlap_histogram(weighted=true) from plane as extrema sort retained_set retain 2106 memory 131072;\n",
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
        registry_canonical: Box<[u8]>,
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
        fn new(registry: &AdapterRegistry) -> Self {
            Self {
                registry_canonical: registry.canonical_json().unwrap().into_boxed_slice(),
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
            assert_eq!(inputs, &[0]);
            assert_eq!(stage.kind(), ExecutionStageKind::FusedMatchReduce);
            assert_eq!(reducers.len(), 1);
            assert_eq!(stage.arguments(arguments), Some(&[2, 0][..]));
            assert_eq!(reducers[0].arguments(arguments), Some(&[1][..]));
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

        fn run_reduce(
            &mut self,
            _stage: ExecutionStage,
            _inputs: &[u16],
            _arguments: &[i64],
        ) -> Result<(), ControlError> {
            unreachable!("the affine plan fuses its match and reducer")
        }

        fn run_canonicalize(
            &mut self,
            stage: ExecutionStage,
            inputs: &[u16],
            arguments: &[i64],
        ) -> Result<(), ControlError> {
            assert_eq!(inputs, &[2]);
            assert_eq!(stage.kind(), ExecutionStageKind::Canonicalize);
            assert_eq!(stage.arguments(arguments), Some(&[4][..]));
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
        let registry = registry();
        let plan = plan(TEXT).unwrap();
        let mut runtime = AffineCensusRuntime::new(&registry);
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
