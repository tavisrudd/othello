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
recipe small_pipeline {
  source rows as input sort row_stream;
  label target == 1;
  provenance fixture;
  match feature from input as features sort feature_stream retain 1 memory 64;
  reduce extrema from features as retained sort retained_set retain 8 memory 128;
  canonicalize orbit from retained as summary sort orbit_summary retain 8 memory 256 streamed false contract diagnostic verified true;
  emit summary;
  verify replay;
}
"#;

    fn registry() -> AdapterRegistry {
        registry_with("retained_set", false)
    }

    fn registry_with(canonical_input_sort: &str, streamed: bool) -> AdapterRegistry {
        AdapterRegistry::try_new(
            vec![SourceSignature {
                name: "rows".into(),
                output_sort: "row_stream".into(),
            }],
            vec![
                OperationSignature {
                    name: "feature".into(),
                    kind: OpKind::Match,
                    input_sort: "row_stream".into(),
                    output_sort: "feature_stream".into(),
                    max_retention: 1,
                    max_memory_bytes: 64,
                    allows_streamed_partition: false,
                },
                OperationSignature {
                    name: "extrema".into(),
                    kind: OpKind::Reduce,
                    input_sort: "feature_stream".into(),
                    output_sort: "retained_set".into(),
                    max_retention: 8,
                    max_memory_bytes: 128,
                    allows_streamed_partition: false,
                },
                OperationSignature {
                    name: "orbit".into(),
                    kind: OpKind::Canonicalize,
                    input_sort: canonical_input_sort.into(),
                    output_sort: "orbit_summary".into(),
                    max_retention: 8,
                    max_memory_bytes: 256,
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
                max_total_retention: 32,
                max_total_memory_bytes: 1024,
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
            assert_eq!(stage.memory_bytes(), 192);
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
                "  reduce extrema from features as retained sort retained_set retain 8 memory 128;\n",
                "",
            )
            .replace("from retained as summary", "from features as summary")
            .replace("streamed false", "streamed true");
        let recipe = parse_semantic_recipe(&unfused).unwrap();
        let compiled = compile_recipe(
            &recipe,
            &registry_with("feature_stream", true),
            DataflowBudget {
                max_total_retention: 32,
                max_total_memory_bytes: 1024,
            },
        )
        .unwrap();
        assert!(compile_execution_plan(&compiled).is_err());
    }
}
