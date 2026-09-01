//! Cold compiler from semantic recipes to bounded typed dataflow slots.

use super::theorem::{FragmentStatus, TheoremFragment};
use super::{OpKind, OperationArgument, OperationArgumentValue, RecipeStep, SemanticRecipe};
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
    #[serde(default)]
    pub parameters: Box<[ParameterSignature]>,
    pub max_retention: u64,
    pub max_memory_bytes: u64,
    #[serde(default)]
    pub allows_streamed_partition: bool,
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(tag = "type", rename_all = "kebab-case", deny_unknown_fields)]
pub enum ArgumentDomain {
    Integer { minimum: i64, maximum: i64 },
    Name { choices: Box<[String]> },
    Boolean,
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct ParameterSignature {
    pub name: String,
    pub domain: ArgumentDomain,
}

#[derive(Debug, Clone, Serialize)]
#[serde(deny_unknown_fields)]
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
            if operation.parameters.len() > MAX_PLAN_OPS {
                return invalid("semantic operation signature has too many parameters");
            }
            let mut parameter_names = BTreeSet::new();
            for parameter in &operation.parameters {
                validate_plan_name(&parameter.name)?;
                if !parameter_names.insert(parameter.name.as_str()) {
                    return invalid("semantic operation signature has duplicate parameters");
                }
                match &parameter.domain {
                    ArgumentDomain::Integer { minimum, maximum } if minimum > maximum => {
                        return invalid("semantic integer parameter has an empty domain");
                    }
                    ArgumentDomain::Name { choices } => {
                        if choices.is_empty() || choices.len() > MAX_PLAN_OPS {
                            return invalid("semantic name parameter has an invalid domain");
                        }
                        let mut unique = BTreeSet::new();
                        for choice in choices {
                            validate_plan_name(choice)?;
                            if !unique.insert(choice.as_str()) {
                                return invalid("semantic name parameter has duplicate choices");
                            }
                        }
                    }
                    ArgumentDomain::Integer { .. } | ArgumentDomain::Boolean => {}
                }
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

    pub fn canonical_json(&self) -> Result<Vec<u8>, ControlError> {
        serde_json::to_vec(self).map_err(ControlError::Json)
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
    retention: u64,
    memory_bytes: u64,
    signature: u16,
    input_slot: u16,
    output_slot: u16,
    kind: OpKind,
    flags: u8,
}

impl CompiledRecipeOp {
    pub const STREAMED_PARTITION: u8 = 1;

    #[must_use]
    pub const fn uses_streamed_partition(self) -> bool {
        self.flags & Self::STREAMED_PARTITION != 0
    }

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
    pub const fn input_slot(self) -> u16 {
        self.input_slot
    }

    #[must_use]
    pub const fn output_slot(self) -> u16 {
        self.output_slot
    }

    #[must_use]
    pub const fn kind(self) -> OpKind {
        self.kind
    }
}

const _: () = assert!(std::mem::size_of::<CompiledRecipeOp>() == 24);
const _: () = assert!(std::mem::align_of::<CompiledRecipeOp>() == 8);

#[derive(Debug, Clone)]
pub struct CompiledRecipe {
    source_signature: u16,
    slots: u16,
    output_slot: u16,
    sink_slots: Box<[u16]>,
    total_retention: u64,
    total_memory_bytes: u64,
    operations: Box<[CompiledRecipeOp]>,
    argument_offsets: Box<[u16]>,
    arguments: Box<[i64]>,
    recipe_canonical: Box<[u8]>,
    registry_canonical: Box<[u8]>,
}

impl CompiledRecipe {
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
    pub const fn total_retention(&self) -> u64 {
        self.total_retention
    }

    #[must_use]
    pub const fn total_memory_bytes(&self) -> u64 {
        self.total_memory_bytes
    }

    #[must_use]
    pub fn operations(&self) -> &[CompiledRecipeOp] {
        &self.operations
    }

    pub(crate) fn operation_argument_range(&self, operation: usize) -> (u16, u16) {
        let start = self.argument_offsets[operation];
        let end = self.argument_offsets[operation + 1];
        (start, end - start)
    }

    #[must_use]
    pub fn arguments(&self) -> &[i64] {
        &self.arguments
    }

    #[must_use]
    pub fn registry_canonical(&self) -> &[u8] {
        &self.registry_canonical
    }
}

#[repr(C)]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct CompiledFragmentEmission {
    pub output_slot: u16,
    pub verifier_gate: u16,
    pub action_count: u16,
    pub status: FragmentStatus,
    pub _pad: u8,
}

const _: () = assert!(std::mem::size_of::<CompiledFragmentEmission>() == 8);
const _: () = assert!(std::mem::align_of::<CompiledFragmentEmission>() == 2);

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
    let recipe_canonical = recipe.canonical_json()?.into_boxed_slice();
    let registry_canonical = registry.canonical_json()?.into_boxed_slice();
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
    let mut argument_offsets = Vec::with_capacity(recipe.steps.len() + 1);
    let mut arguments = Vec::new();
    argument_offsets.push(0);
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
        encode_arguments(step.arguments(), &signature.parameters, &mut arguments)?;
        if arguments.len() > MAX_PLAN_OPS {
            return invalid("semantic recipe exceeds the compiled argument bound");
        }
        argument_offsets.push(u16::try_from(arguments.len()).map_err(|_| {
            ControlError::Invalid("semantic compiled argument offset overflow".into())
        })?);
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
    let output_slot = slots
        .get(recipe.emit_binding.as_str())
        .ok_or_else(|| ControlError::Invalid("semantic recipe output slot is not defined".into()))?
        .id;
    let sink_slots = recipe
        .sinks
        .iter()
        .map(|sink| {
            slots
                .get(sink.as_str())
                .map(|slot| slot.id)
                .ok_or_else(|| ControlError::Invalid("semantic sink slot is not defined".into()))
        })
        .collect::<Result<Vec<_>, _>>()?
        .into_boxed_slice();
    Ok(CompiledRecipe {
        source_signature,
        slots: u16::try_from(slots.len())
            .map_err(|_| ControlError::Invalid("semantic recipe has too many slots".into()))?,
        output_slot,
        sink_slots,
        total_retention,
        total_memory_bytes,
        operations: operations.into_boxed_slice(),
        argument_offsets: argument_offsets.into_boxed_slice(),
        arguments: arguments.into_boxed_slice(),
        recipe_canonical,
        registry_canonical,
    })
}

pub fn compile_fragment_emission(
    recipe: &SemanticRecipe,
    compiled: &CompiledRecipe,
    fragment: &TheoremFragment,
) -> Result<CompiledFragmentEmission, ControlError> {
    recipe.validate()?;
    fragment.validate()?;
    if compiled.recipe_canonical.as_ref() != recipe.canonical_json()?.as_slice() {
        return invalid("compiled semantic dataflow belongs to a different recipe");
    }
    let emitted_sort = binding_sort(recipe, &recipe.emit_binding).ok_or_else(|| {
        ControlError::Invalid("semantic recipe output binding has no declared sort".into())
    })?;
    if emitted_sort != fragment.evidence_sort {
        return invalid("theorem fragment evidence sort does not match the recipe output");
    }
    if recipe.provenance != fragment.provenance {
        return invalid("theorem fragment provenance does not match the recipe");
    }
    if !same_scope(recipe.scope.as_ref(), fragment.scope.as_ref()) {
        return invalid("theorem fragment scope does not match the recipe");
    }

    let mut lineage_actions = BTreeMap::new();
    let mut binding = recipe.emit_binding.as_str();
    while binding != recipe.source_binding {
        let step = recipe
            .steps
            .iter()
            .find(|step| step.binding() == binding)
            .ok_or_else(|| ControlError::Invalid("semantic output lineage is incomplete".into()))?;
        if let RecipeStep::Canonicalize {
            action,
            arguments,
            gate,
            ..
        } = step
        {
            if lineage_actions
                .insert(action.as_str(), (*gate, arguments.as_ref()))
                .is_some_and(|earlier| earlier != (*gate, arguments.as_ref()))
            {
                return invalid("semantic output lineage uses conflicting action contracts");
            }
        }
        binding = step.input();
    }
    if lineage_actions.len() != fragment.actions.len() {
        return invalid("theorem fragment actions do not match its recipe lineage");
    }
    for action in &fragment.actions {
        if lineage_actions.get(action.name.as_str())
            != Some(&(action.gate, action.arguments.as_ref()))
        {
            return invalid("theorem fragment action contract differs from its recipe lineage");
        }
    }

    let verifier_gate = if let Some(certificate) = &fragment.certificate {
        recipe
            .gates
            .iter()
            .position(|gate| gate == &certificate.verifier)
            .map(|index| index as u16)
            .ok_or_else(|| {
                ControlError::Invalid(
                    "theorem fragment verifier is not a declared recipe gate".into(),
                )
            })?
    } else {
        u16::MAX
    };
    Ok(CompiledFragmentEmission {
        output_slot: compiled.output_slot,
        verifier_gate,
        action_count: u16::try_from(lineage_actions.len())
            .map_err(|_| ControlError::Invalid("too many theorem actions".into()))?,
        status: fragment.status,
        _pad: 0,
    })
}

fn binding_sort<'a>(recipe: &'a SemanticRecipe, binding: &str) -> Option<&'a str> {
    if binding == recipe.source_binding {
        Some(&recipe.source_sort)
    } else {
        recipe
            .steps
            .iter()
            .find(|step| step.binding() == binding)
            .map(RecipeStep::output_sort)
    }
}

fn same_scope(
    left: Option<&ergodis::control::PlanScope>,
    right: Option<&ergodis::control::PlanScope>,
) -> bool {
    match (left, right) {
        (None, None) => true,
        (Some(left), Some(right)) => left.field == right.field && left.mask == right.mask,
        (None, Some(_)) | (Some(_), None) => false,
    }
}

fn operation_name(step: &RecipeStep) -> &str {
    match step {
        RecipeStep::Match { adapter, .. } => adapter,
        RecipeStep::Reduce { reducer, .. } => reducer,
        RecipeStep::Canonicalize { action, .. } => action,
    }
}

fn encode_arguments(
    arguments: &[OperationArgument],
    parameters: &[ParameterSignature],
    output: &mut Vec<i64>,
) -> Result<(), ControlError> {
    if arguments.len() != parameters.len() {
        return invalid("semantic operation argument set does not match its signature");
    }
    for parameter in parameters {
        let argument = arguments
            .iter()
            .find(|argument| argument.name == parameter.name)
            .ok_or_else(|| {
                ControlError::Invalid("semantic operation omits a required argument".into())
            })?;
        let encoded = match (&argument.value, &parameter.domain) {
            (
                OperationArgumentValue::Integer(value),
                ArgumentDomain::Integer { minimum, maximum },
            ) if value >= minimum && value <= maximum => *value,
            (OperationArgumentValue::Name(value), ArgumentDomain::Name { choices }) => choices
                .iter()
                .position(|choice| choice == value)
                .map(|index| index as i64)
                .ok_or_else(|| {
                    ControlError::Invalid("semantic name argument is outside its domain".into())
                })?,
            (OperationArgumentValue::Boolean(value), ArgumentDomain::Boolean) => i64::from(*value),
            _ => return invalid("semantic operation argument has the wrong type or value"),
        };
        output.push(encoded);
    }
    Ok(())
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
  match affine_subspace(rank=2, metric=max_overlap) from objects as plane sort feature_row retain 1 memory 4096;
  reduce overlap_histogram(weighted=true) from plane as extrema sort retained_set retain 2106 memory 131072;
  canonicalize affine_generators(count=4) from extrema as cap_orbit sort orbit_summary retain 2106 memory 65536 streamed false contract diagnostic verified true;
  emit cap_orbit;
  verify replay_label;
  verify replay_hankel;
}
"#;

    const FRAGMENT_TEXT: &str = r#"
theorem cap_geometry {
  domain gf27_nine_set;
  evidence orbit_summary;
  parameter g2 scalar;
  parameter g3 scalar;
  hypothesis labelled g2 == 0;
  conclusion g3 == 0;
  observable cap_overlap contract diagnostic;
  action affine_generators(count=4) contract diagnostic verified true;
  provenance "sha256:fixture";
  status candidate;
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
                    input_sort: "feature_row".into(),
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
                    input_sort: "retained_set".into(),
                    output_sort: "orbit_summary".into(),
                    parameters: Box::new([ParameterSignature {
                        name: "count".into(),
                        domain: ArgumentDomain::Integer {
                            minimum: 1,
                            maximum: 16,
                        },
                    }]),
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
        assert_eq!(compiled.output_slot, 3);
        assert_eq!(compiled.operations.len(), 3);
        assert_eq!(compiled.operations[2].input_slot, 2);
        assert_eq!(compiled.operations[2].output_slot, 3);
        assert_eq!(compiled.total_retention, 4213);
        assert_eq!(compiled.total_memory_bytes, 200_704);
        assert_eq!(compiled.arguments(), &[2, 0, 1, 4]);
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

        for malformed in [
            TEXT.replace("rank=2", "rank=4"),
            TEXT.replace("metric=max_overlap", "metric=unknown"),
            TEXT.replace("weighted=true", "weighted=wrong"),
            TEXT.replace("count=4", "other=4"),
        ] {
            let malformed = parse_semantic_recipe(&malformed).unwrap();
            assert!(compile_recipe(
                &malformed,
                &registry(false),
                DataflowBudget {
                    max_total_retention: 5000,
                    max_total_memory_bytes: 300_000,
                }
            )
            .is_err());
        }
    }

    #[test]
    fn streamed_partition_requires_explicit_recipe_and_signature_gates() {
        let streamed_text = TEXT
            .replace(
                "reduce overlap_histogram(weighted=true) from plane as extrema sort retained_set retain 2106 memory 131072;\n",
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

    #[test]
    fn fragment_emission_binds_output_sort_lineage_and_provenance() {
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
        let fragment =
            crate::semantic_plan::theorem::parse_theorem_fragment(FRAGMENT_TEXT).unwrap();
        let emission = compile_fragment_emission(&recipe, &compiled, &fragment).unwrap();
        assert_eq!(emission.output_slot, 3);
        assert_eq!(emission.verifier_gate, u16::MAX);
        assert_eq!(emission.action_count, 1);

        let wrong_sort = FRAGMENT_TEXT.replace("evidence orbit_summary", "evidence retained_set");
        let fragment = crate::semantic_plan::theorem::parse_theorem_fragment(&wrong_sort).unwrap();
        assert!(compile_fragment_emission(&recipe, &compiled, &fragment).is_err());
        let wrong_action = FRAGMENT_TEXT.replace("affine_generators", "other_action");
        let fragment =
            crate::semantic_plan::theorem::parse_theorem_fragment(&wrong_action).unwrap();
        assert!(compile_fragment_emission(&recipe, &compiled, &fragment).is_err());
        let wrong_action_argument = FRAGMENT_TEXT.replace("count=4", "count=5");
        let fragment =
            crate::semantic_plan::theorem::parse_theorem_fragment(&wrong_action_argument).unwrap();
        assert!(compile_fragment_emission(&recipe, &compiled, &fragment).is_err());
        let wrong_provenance = FRAGMENT_TEXT.replace("sha256:fixture", "sha256:other");
        let fragment =
            crate::semantic_plan::theorem::parse_theorem_fragment(&wrong_provenance).unwrap();
        assert!(compile_fragment_emission(&recipe, &compiled, &fragment).is_err());
    }

    #[test]
    fn certified_fragment_verifier_must_be_a_recipe_gate() {
        let recipe = parse_semantic_recipe(&TEXT.replace(
            "contract diagnostic verified true",
            "contract transports verified true",
        ))
        .unwrap();
        let compiled = compile_recipe(
            &recipe,
            &registry(false),
            DataflowBudget {
                max_total_retention: 5000,
                max_total_memory_bytes: 300_000,
            },
        )
        .unwrap();
        let certified = FRAGMENT_TEXT
            .replace("contract diagnostic", "contract exact")
            .replace(
                "action affine_generators(count=4) contract exact verified true",
                "action affine_generators(count=4) contract transports verified true",
            )
            .replace(
                "status candidate;",
                "status finite_certified;\n  certificate replay_hankel \"sha256:packet\";",
            );
        let fragment = crate::semantic_plan::theorem::parse_theorem_fragment(&certified).unwrap();
        let emission = compile_fragment_emission(&recipe, &compiled, &fragment).unwrap();
        assert_eq!(emission.verifier_gate, 1);

        let missing = certified.replace("replay_hankel", "unknown_verifier");
        let fragment = crate::semantic_plan::theorem::parse_theorem_fragment(&missing).unwrap();
        assert!(compile_fragment_emission(&recipe, &compiled, &fragment).is_err());
    }
}
