//! Cold compiler from semantic recipes to bounded typed dataflow slots.

use super::{OpKind, RecipeStep, SemanticRecipe};
use ergodis::control::{validate_plan_name, ControlError, MAX_PLAN_OPS};
use serde::{Deserialize, Serialize};
use std::collections::{BTreeMap, BTreeSet};

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct SourceSignature {
    pub name: String,
    pub output_sort: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct OperationSignature {
    pub name: String,
    pub kind: OpKind,
    pub input_sort: String,
    pub output_sort: String,
    pub max_retention: u64,
    pub max_memory_bytes: u64,
    #[serde(default)]
    pub allows_streamed_partition: bool,
}

#[derive(Debug, Clone)]
pub struct AdapterRegistry {
    sources: Box<[SourceSignature]>,
    operations: Box<[OperationSignature]>,
}

impl AdapterRegistry {
    pub fn try_new(
        sources: Vec<SourceSignature>,
        operations: Vec<OperationSignature>,
    ) -> Result<Self, ControlError> {
        if sources.is_empty()
            || sources.len() > MAX_PLAN_OPS
            || operations.is_empty()
            || operations.len() > MAX_PLAN_OPS
        {
            return invalid("semantic adapter registry has an invalid size");
        }
        let mut names = BTreeSet::new();
        for source in &sources {
            validate_plan_name(&source.name)?;
            validate_plan_name(&source.output_sort)?;
            if !names.insert(source.name.as_str()) {
                return invalid("semantic adapter registry has a duplicate source");
            }
        }
        names.clear();
        for operation in &operations {
            validate_plan_name(&operation.name)?;
            validate_plan_name(&operation.input_sort)?;
            validate_plan_name(&operation.output_sort)?;
            if operation.max_retention == 0 || operation.max_memory_bytes == 0 {
                return invalid("semantic operation signature has a zero resource bound");
            }
            if operation.allows_streamed_partition && operation.kind != OpKind::Canonicalize {
                return invalid("only canonicalizers may accept a streamed partition");
            }
            if !names.insert(operation.name.as_str()) {
                return invalid("semantic adapter registry has a duplicate operation");
            }
        }
        Ok(Self {
            sources: sources.into_boxed_slice(),
            operations: operations.into_boxed_slice(),
        })
    }

    fn source(&self, name: &str) -> Option<(u16, &SourceSignature)> {
        self.sources
            .iter()
            .enumerate()
            .find(|(_, source)| source.name == name)
            .map(|(index, source)| (index as u16, source))
    }

    fn operation(&self, name: &str) -> Option<(u16, &OperationSignature)> {
        self.operations
            .iter()
            .enumerate()
            .find(|(_, operation)| operation.name == name)
            .map(|(index, operation)| (index as u16, operation))
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct DataflowBudget {
    pub max_total_retention: u64,
    pub max_total_memory_bytes: u64,
}

#[repr(C)]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct CompiledRecipeOp {
    pub retention: u64,
    pub memory_bytes: u64,
    pub signature: u16,
    pub input_slot: u16,
    pub output_slot: u16,
    pub kind: OpKind,
    pub flags: u8,
}

impl CompiledRecipeOp {
    pub const STREAMED_PARTITION: u8 = 1;

    #[must_use]
    pub const fn uses_streamed_partition(self) -> bool {
        self.flags & Self::STREAMED_PARTITION != 0
    }
}

const _: () = assert!(std::mem::size_of::<CompiledRecipeOp>() == 24);
const _: () = assert!(std::mem::align_of::<CompiledRecipeOp>() == 8);

#[derive(Debug, Clone)]
pub struct CompiledRecipe {
    pub source_signature: u16,
    pub slots: u16,
    pub total_retention: u64,
    pub total_memory_bytes: u64,
    pub operations: Box<[CompiledRecipeOp]>,
}

#[derive(Clone, Copy, PartialEq, Eq)]
enum Producer {
    Source,
    Match,
    Reduce,
    Canonicalize,
}

struct Slot<'a> {
    id: u16,
    sort: &'a str,
    producer: Producer,
}

pub fn compile_recipe(
    recipe: &SemanticRecipe,
    registry: &AdapterRegistry,
    budget: DataflowBudget,
) -> Result<CompiledRecipe, ControlError> {
    recipe.validate()?;
    if budget.max_total_retention == 0 || budget.max_total_memory_bytes == 0 {
        return invalid("semantic dataflow budget must be positive");
    }
    let (source_signature, source) = registry
        .source(&recipe.source)
        .ok_or_else(|| ControlError::Invalid("semantic recipe source is not registered".into()))?;
    if source.output_sort != recipe.source_sort {
        return invalid("semantic recipe source sort does not match its signature");
    }

    let mut slots = BTreeMap::new();
    slots.insert(
        recipe.source_binding.as_str(),
        Slot {
            id: 0,
            sort: &recipe.source_sort,
            producer: Producer::Source,
        },
    );
    let mut operations = Vec::with_capacity(recipe.steps.len());
    let mut total_retention = 0_u64;
    let mut total_memory_bytes = 0_u64;
    for step in &recipe.steps {
        let name = operation_name(step);
        let (signature_id, signature) = registry.operation(name).ok_or_else(|| {
            ControlError::Invalid("semantic recipe operation is not registered".into())
        })?;
        if signature.kind != step.kind() {
            return invalid("semantic recipe operation kind does not match its signature");
        }
        let input = slots.get(step.input()).ok_or_else(|| {
            ControlError::Invalid("semantic recipe input slot is not defined".into())
        })?;
        if input.sort != signature.input_sort {
            return invalid("semantic recipe input sort does not match its signature");
        }
        if step.output_sort() != signature.output_sort {
            return invalid("semantic recipe output sort does not match its signature");
        }
        let (retention, memory_bytes) = step.resources();
        if retention > signature.max_retention || memory_bytes > signature.max_memory_bytes {
            return invalid("semantic recipe exceeds an operation signature resource bound");
        }
        let streamed_partition = matches!(
            step,
            RecipeStep::Canonicalize {
                streamed_partition: true,
                ..
            }
        );
        if streamed_partition && !signature.allows_streamed_partition {
            return invalid("semantic canonicalizer does not admit a streamed partition");
        }
        if step.kind() == OpKind::Canonicalize
            && !streamed_partition
            && input.producer != Producer::Reduce
        {
            return invalid("semantic canonicalizer input is not a reducer output");
        }

        total_retention = total_retention
            .checked_add(retention)
            .ok_or_else(|| ControlError::Invalid("semantic retention budget overflow".into()))?;
        total_memory_bytes = total_memory_bytes
            .checked_add(memory_bytes)
            .ok_or_else(|| ControlError::Invalid("semantic memory budget overflow".into()))?;
        if total_retention > budget.max_total_retention
            || total_memory_bytes > budget.max_total_memory_bytes
        {
            return invalid("semantic recipe exceeds its campaign resource budget");
        }

        let output_slot = u16::try_from(slots.len())
            .map_err(|_| ControlError::Invalid("semantic recipe has too many slots".into()))?;
        operations.push(CompiledRecipeOp {
            retention,
            memory_bytes,
            signature: signature_id,
            input_slot: input.id,
            output_slot,
            kind: step.kind(),
            flags: if streamed_partition {
                CompiledRecipeOp::STREAMED_PARTITION
            } else {
                0
            },
        });
        slots.insert(
            step.binding(),
            Slot {
                id: output_slot,
                sort: step.output_sort(),
                producer: match step.kind() {
                    OpKind::Match => Producer::Match,
                    OpKind::Reduce => Producer::Reduce,
                    OpKind::Canonicalize => Producer::Canonicalize,
                },
            },
        );
    }
    Ok(CompiledRecipe {
        source_signature,
        slots: u16::try_from(slots.len())
            .map_err(|_| ControlError::Invalid("semantic recipe has too many slots".into()))?,
        total_retention,
        total_memory_bytes,
        operations: operations.into_boxed_slice(),
    })
}

fn operation_name(step: &RecipeStep) -> &str {
    match step {
        RecipeStep::Match { adapter, .. } => adapter,
        RecipeStep::Reduce { reducer, .. } => reducer,
        RecipeStep::Canonicalize { action, .. } => action,
    }
}

fn invalid<T>(message: &str) -> Result<T, ControlError> {
    Err(ControlError::Invalid(message.into()))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::semantic_plan::parse_semantic_recipe;

    const TEXT: &str = r#"
recipe affine_caps {
  source split_nine_sets as objects sort nine_set_stream;
  label (g2 == 0) && (g3 == 0);
  provenance "sha256:fixture";
  match affine_subspace from objects as plane sort feature_row retain 1 memory 4096;
  reduce overlap_histogram from plane as extrema sort retained_set retain 2106 memory 131072;
  canonicalize affine_generators from extrema as cap_orbit sort orbit_summary retain 2106 memory 65536 streamed false contract diagnostic verified true;
  verify replay_label;
}
"#;

    fn registry(streamed: bool) -> AdapterRegistry {
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
                    input_sort: "retained_set".into(),
                    output_sort: "orbit_summary".into(),
                    max_retention: 2106,
                    max_memory_bytes: 65536,
                    allows_streamed_partition: streamed,
                },
            ],
        )
        .unwrap()
    }

    #[test]
    fn lowering_resolves_typed_slots_and_resource_totals() {
        let recipe = parse_semantic_recipe(TEXT).unwrap();
        let compiled = compile_recipe(
            &recipe,
            &registry(false),
            DataflowBudget {
                max_total_retention: 5000,
                max_total_memory_bytes: 300_000,
            },
        )
        .unwrap();
        assert_eq!(compiled.source_signature, 0);
        assert_eq!(compiled.slots, 4);
        assert_eq!(compiled.operations.len(), 3);
        assert_eq!(compiled.operations[2].input_slot, 2);
        assert_eq!(compiled.operations[2].output_slot, 3);
        assert_eq!(compiled.total_retention, 4213);
        assert_eq!(compiled.total_memory_bytes, 200_704);
        assert!(!compiled.operations[2].uses_streamed_partition());
    }

    #[test]
    fn lowering_rejects_sort_signature_and_budget_mismatches() {
        let recipe = parse_semantic_recipe(TEXT).unwrap();
        let tight = DataflowBudget {
            max_total_retention: 4212,
            max_total_memory_bytes: 300_000,
        };
        assert!(compile_recipe(&recipe, &registry(false), tight).is_err());

        let mut wrong = registry(false);
        wrong.operations[1].input_sort = "wrong".into();
        assert!(compile_recipe(
            &recipe,
            &wrong,
            DataflowBudget {
                max_total_retention: 5000,
                max_total_memory_bytes: 300_000,
            }
        )
        .is_err());
    }

    #[test]
    fn streamed_partition_requires_explicit_recipe_and_signature_gates() {
        let streamed_text = TEXT
            .replace(
                "reduce overlap_histogram from plane as extrema sort retained_set retain 2106 memory 131072;\n",
                "",
            )
            .replace(
                "from extrema as cap_orbit",
                "from plane as cap_orbit",
            )
            .replace("streamed false", "streamed true");
        let recipe = parse_semantic_recipe(&streamed_text).unwrap();
        let mut denied = registry(false);
        denied.operations[2].input_sort = "feature_row".into();
        assert!(compile_recipe(
            &recipe,
            &denied,
            DataflowBudget {
                max_total_retention: 5000,
                max_total_memory_bytes: 300_000,
            }
        )
        .is_err());
        let mut admitted = registry(true);
        admitted.operations[2].input_sort = "feature_row".into();
        let compiled = compile_recipe(
            &recipe,
            &admitted,
            DataflowBudget {
                max_total_retention: 5000,
                max_total_memory_bytes: 300_000,
            },
        )
        .unwrap();
        assert!(compiled.operations[1].uses_streamed_partition());
    }
}
