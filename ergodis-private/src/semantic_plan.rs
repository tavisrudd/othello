//! Typed, bounded `match / reduce / canonicalize` recipe contracts.

pub mod affine_census;
pub mod dataflow;
pub mod execution;
pub mod q11_hall_packet;
pub mod q9_rank_packet;
pub mod theorem;

use ergodis::control::{
    format_plan_expression, format_plan_name, lex_plan_text, parse_plan_expression,
    parse_plan_i64_literal, parse_plan_u64_literal, validate_plan_name, ControlError,
    ExpressionPlanSpec, PlanExpr, PlanOutput, PlanRole, PlanScope, PlanTextToken,
    PlanTextTokenKind, MAX_PLAN_OPS, PLAN_SCHEMA,
};
use serde::{Deserialize, Serialize};
use std::collections::BTreeSet;

pub const SEMANTIC_RECIPE_SCHEMA: &str = "ergodis-semantic-recipe-v0";

#[derive(Debug, Clone, Copy, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
#[repr(u8)]
pub enum OpKind {
    Match,
    Reduce,
    Canonicalize,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub enum LabelContract {
    /// The action fixes the exact label predicate.
    Preserves,
    /// The action carries labels through an exact domain adapter.
    Transports,
    /// Useful geometry only; forbidden in a proof-producing quotient.
    Diagnostic,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct CanonicalizationGate {
    pub label_contract: LabelContract,
    pub action_verified: bool,
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(
    tag = "type",
    content = "value",
    rename_all = "kebab-case",
    deny_unknown_fields
)]
pub enum OperationArgumentValue {
    Integer(i64),
    Name(String),
    Boolean(bool),
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct OperationArgument {
    pub name: String,
    pub value: OperationArgumentValue,
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(tag = "op", rename_all = "kebab-case", deny_unknown_fields)]
pub enum RecipeStep {
    Match {
        adapter: String,
        arguments: Box<[OperationArgument]>,
        inputs: Box<[String]>,
        binding: String,
        output_sort: String,
        retention: u64,
        memory_bytes: u64,
    },
    Reduce {
        reducer: String,
        arguments: Box<[OperationArgument]>,
        inputs: Box<[String]>,
        binding: String,
        output_sort: String,
        retention: u64,
        memory_bytes: u64,
    },
    Canonicalize {
        action: String,
        arguments: Box<[OperationArgument]>,
        inputs: Box<[String]>,
        binding: String,
        output_sort: String,
        retention: u64,
        memory_bytes: u64,
        streamed_partition: bool,
        gate: CanonicalizationGate,
    },
}

impl RecipeStep {
    #[must_use]
    pub const fn kind(&self) -> OpKind {
        match self {
            Self::Match { .. } => OpKind::Match,
            Self::Reduce { .. } => OpKind::Reduce,
            Self::Canonicalize { .. } => OpKind::Canonicalize,
        }
    }

    fn binding(&self) -> &str {
        match self {
            Self::Match { binding, .. }
            | Self::Reduce { binding, .. }
            | Self::Canonicalize { binding, .. } => binding,
        }
    }

    fn inputs(&self) -> &[String] {
        match self {
            Self::Match { inputs, .. }
            | Self::Reduce { inputs, .. }
            | Self::Canonicalize { inputs, .. } => inputs,
        }
    }

    fn output_sort(&self) -> &str {
        match self {
            Self::Match { output_sort, .. }
            | Self::Reduce { output_sort, .. }
            | Self::Canonicalize { output_sort, .. } => output_sort,
        }
    }

    fn resources(&self) -> (u64, u64) {
        match self {
            Self::Match {
                retention,
                memory_bytes,
                ..
            }
            | Self::Reduce {
                retention,
                memory_bytes,
                ..
            }
            | Self::Canonicalize {
                retention,
                memory_bytes,
                ..
            } => (*retention, *memory_bytes),
        }
    }

    fn arguments(&self) -> &[OperationArgument] {
        match self {
            Self::Match { arguments, .. }
            | Self::Reduce { arguments, .. }
            | Self::Canonicalize { arguments, .. } => arguments,
        }
    }
}

#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct SemanticRecipe {
    pub schema: String,
    pub name: String,
    pub source: String,
    pub source_binding: String,
    pub source_sort: String,
    pub label: PlanExpr,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub scope: Option<PlanScope>,
    pub provenance: String,
    pub steps: Box<[RecipeStep]>,
    pub emit_binding: String,
    #[serde(default)]
    pub sinks: Box<[String]>,
    pub gates: Box<[String]>,
}

impl SemanticRecipe {
    pub fn validate(&self) -> Result<(), ControlError> {
        if self.schema != SEMANTIC_RECIPE_SCHEMA {
            return invalid("semantic recipe has an unsupported schema");
        }
        validate_plan_name(&self.name)?;
        validate_plan_name(&self.source)?;
        validate_plan_name(&self.source_binding)?;
        validate_plan_name(&self.source_sort)?;
        validate_plan_name(&self.provenance)?;
        if let Some(scope) = &self.scope {
            validate_plan_name(&scope.field)?;
        }
        ExpressionPlanSpec {
            schema: PLAN_SCHEMA.into(),
            name: self.name.clone(),
            role: PlanRole::Diagnostic,
            output: PlanOutput::Predicate,
            scope: self.scope.clone(),
            expr: self.label.clone(),
        }
        .lower()?;
        if self.steps.is_empty() || self.steps.len() > MAX_PLAN_OPS {
            return invalid("semantic recipe has an invalid step count");
        }
        if self.gates.is_empty() || self.gates.len() > MAX_PLAN_OPS {
            return invalid("semantic recipe has an invalid verification-gate count");
        }
        validate_plan_name(&self.emit_binding)?;
        if self.sinks.len() > MAX_PLAN_OPS {
            return invalid("semantic recipe has too many sinks");
        }
        let mut bindings = BTreeSet::from([self.source_binding.as_str()]);
        let mut reduced_bindings = BTreeSet::new();
        let mut bounded_bindings = BTreeSet::new();
        for step in &self.steps {
            let binding = step.binding();
            validate_plan_name(binding)?;
            validate_plan_name(step.output_sort())?;
            let inputs = step.inputs();
            if inputs.is_empty() || inputs.len() > MAX_PLAN_OPS {
                return invalid("semantic recipe operation has an invalid input count");
            }
            if step.kind() == OpKind::Match && inputs.len() != 1 {
                return invalid("semantic match operations require exactly one input");
            }
            let mut unique_inputs = BTreeSet::new();
            for input in inputs {
                validate_plan_name(input)?;
                if !bindings.contains(input.as_str()) {
                    return invalid("semantic recipe step references an unknown input binding");
                }
                if !unique_inputs.insert(input.as_str()) {
                    return invalid("semantic recipe operation repeats an input binding");
                }
            }
            if !bindings.insert(binding) {
                return invalid("semantic recipe contains a duplicate binding");
            }
            let (retention, memory_bytes) = step.resources();
            if retention == 0 || memory_bytes == 0 {
                return invalid("semantic operation requires positive retention and memory bounds");
            }
            if step.arguments().len() > MAX_PLAN_OPS {
                return invalid("semantic operation has too many arguments");
            }
            let mut argument_names = BTreeSet::new();
            for argument in step.arguments() {
                validate_plan_name(&argument.name)?;
                if let OperationArgumentValue::Name(value) = &argument.value {
                    validate_plan_name(value)?;
                }
                if !argument_names.insert(argument.name.as_str()) {
                    return invalid("semantic operation contains a duplicate argument");
                }
            }
            match step {
                RecipeStep::Match { adapter, .. } => validate_plan_name(adapter)?,
                RecipeStep::Reduce { reducer, .. } => {
                    validate_plan_name(reducer)?;
                    if inputs.len() > 1
                        && !inputs
                            .iter()
                            .all(|input| bounded_bindings.contains(input.as_str()))
                    {
                        return invalid("multi-input reducers require bounded input artifacts");
                    }
                    reduced_bindings.insert(binding);
                    bounded_bindings.insert(binding);
                }
                RecipeStep::Canonicalize {
                    action,
                    streamed_partition,
                    ..
                } => {
                    validate_plan_name(action)?;
                    if *streamed_partition && inputs.len() != 1 {
                        return invalid(
                            "streamed canonicalization requires exactly one input partition",
                        );
                    }
                    if !streamed_partition
                        && !inputs
                            .iter()
                            .all(|input| reduced_bindings.contains(input.as_str()))
                    {
                        return invalid(
                            "canonicalization requires reducer outputs or a streamed partition",
                        );
                    }
                    bounded_bindings.insert(binding);
                }
            }
        }
        for gate in &self.gates {
            validate_plan_name(gate)?;
        }
        if !bindings.contains(self.emit_binding.as_str()) {
            return invalid("semantic recipe emits an unknown binding");
        }
        if !bounded_bindings.contains(self.emit_binding.as_str()) {
            return invalid("semantic recipe output must be a bounded artifact");
        }
        let mut sinks = BTreeSet::new();
        for sink in &self.sinks {
            validate_plan_name(sink)?;
            if sink == &self.emit_binding {
                return invalid("semantic recipe sink duplicates its emitted binding");
            }
            if !bindings.contains(sink.as_str()) {
                return invalid("semantic recipe sinks an unknown binding");
            }
            if !bounded_bindings.contains(sink.as_str()) {
                return invalid("semantic recipe sink must be a bounded artifact");
            }
            if !sinks.insert(sink) {
                return invalid("semantic recipe contains a duplicate sink");
            }
        }
        Ok(())
    }

    pub fn canonical_json(&self) -> Result<Vec<u8>, ControlError> {
        self.validate()?;
        serde_json::to_vec(self).map_err(ControlError::Json)
    }
}

pub fn parse_semantic_recipe(text: &str) -> Result<SemanticRecipe, ControlError> {
    RecipeParser::new(text, lex_plan_text(text)?).parse()
}

pub fn format_semantic_recipe(recipe: &SemanticRecipe) -> Result<String, ControlError> {
    recipe.validate()?;
    let mut text = format!("recipe {} {{\n", format_plan_name(&recipe.name)?);
    text.push_str(&format!(
        "  source {} as {} sort {};\n  label {};\n",
        format_plan_name(&recipe.source)?,
        format_plan_name(&recipe.source_binding)?,
        format_plan_name(&recipe.source_sort)?,
        format_plan_expression(&recipe.label)?
    ));
    if let Some(scope) = &recipe.scope {
        text.push_str(&format!(
            "  scope {} 0x{:016x};\n",
            format_plan_name(&scope.field)?,
            scope.mask
        ));
    }
    text.push_str(&format!(
        "  provenance {};\n",
        format_plan_name(&recipe.provenance)?
    ));
    for step in &recipe.steps {
        match step {
            RecipeStep::Match {
                adapter,
                arguments,
                inputs,
                binding,
                output_sort,
                retention,
                memory_bytes,
            } => text.push_str(&format!(
                "  match {} from {} as {} sort {} retain {} memory {};\n",
                format_operation(adapter, arguments)?,
                format_inputs(inputs)?,
                format_plan_name(binding)?,
                format_plan_name(output_sort)?,
                retention,
                memory_bytes
            )),
            RecipeStep::Reduce {
                reducer,
                arguments,
                inputs,
                binding,
                output_sort,
                retention,
                memory_bytes,
            } => text.push_str(&format!(
                "  reduce {} from {} as {} sort {} retain {} memory {};\n",
                format_operation(reducer, arguments)?,
                format_inputs(inputs)?,
                format_plan_name(binding)?,
                format_plan_name(output_sort)?,
                retention,
                memory_bytes
            )),
            RecipeStep::Canonicalize {
                action,
                arguments,
                inputs,
                binding,
                output_sort,
                retention,
                memory_bytes,
                streamed_partition,
                gate,
            } => text.push_str(&format!(
                "  canonicalize {} from {} as {} sort {} retain {} memory {} streamed {} contract {} verified {};\n",
                format_operation(action, arguments)?,
                format_inputs(inputs)?,
                format_plan_name(binding)?,
                format_plan_name(output_sort)?,
                retention,
                memory_bytes,
                streamed_partition,
                contract_name(gate.label_contract),
                gate.action_verified
            )),
        }
    }
    text.push_str(&format!(
        "  emit {};\n",
        format_plan_name(&recipe.emit_binding)?
    ));
    for sink in &recipe.sinks {
        text.push_str(&format!("  sink {};\n", format_plan_name(sink)?));
    }
    for gate in &recipe.gates {
        text.push_str(&format!("  verify {};\n", format_plan_name(gate)?));
    }
    text.push_str("}\n");
    Ok(text)
}

fn contract_name(contract: LabelContract) -> &'static str {
    match contract {
        LabelContract::Preserves => "preserves",
        LabelContract::Transports => "transports",
        LabelContract::Diagnostic => "diagnostic",
    }
}

fn format_operation(name: &str, arguments: &[OperationArgument]) -> Result<String, ControlError> {
    let mut text = format_plan_name(name)?;
    if arguments.is_empty() {
        return Ok(text);
    }
    text.push('(');
    for (index, argument) in arguments.iter().enumerate() {
        if index != 0 {
            text.push_str(", ");
        }
        text.push_str(&format_plan_name(&argument.name)?);
        text.push('=');
        match &argument.value {
            OperationArgumentValue::Integer(value) => text.push_str(&value.to_string()),
            OperationArgumentValue::Name(value) => text.push_str(&format_plan_name(value)?),
            OperationArgumentValue::Boolean(value) => {
                text.push_str(if *value { "true" } else { "false" })
            }
        }
    }
    text.push(')');
    Ok(text)
}

fn format_inputs(inputs: &[String]) -> Result<String, ControlError> {
    let mut text = String::new();
    for (index, input) in inputs.iter().enumerate() {
        if index != 0 {
            text.push_str(", ");
        }
        text.push_str(&format_plan_name(input)?);
    }
    Ok(text)
}

struct RecipeParser<'a> {
    text: &'a str,
    tokens: Vec<PlanTextToken>,
    at: usize,
}

impl<'a> RecipeParser<'a> {
    fn new(text: &'a str, tokens: Vec<PlanTextToken>) -> Self {
        Self {
            text,
            tokens,
            at: 0,
        }
    }

    fn parse(mut self) -> Result<SemanticRecipe, ControlError> {
        self.expect_word("recipe")?;
        let name = self.name()?;
        self.expect(PlanTextTokenKind::LBrace)?;
        let (mut source, mut source_binding, mut source_sort, mut label, mut scope, mut provenance) =
            (None, None, None, None, None, None);
        let mut steps = Vec::new();
        let mut emit_binding = None;
        let mut sinks = Vec::new();
        let mut gates = Vec::new();
        while !self.consume(&PlanTextTokenKind::RBrace) {
            match self.word()?.as_str() {
                "source" if source.is_none() => {
                    source = Some(self.name()?);
                    self.expect_word("as")?;
                    source_binding = Some(self.name()?);
                    self.expect_word("sort")?;
                    source_sort = Some(self.name()?);
                }
                "label" if label.is_none() => {
                    label = Some(self.expression_until_semicolon()?);
                    continue;
                }
                "scope" if scope.is_none() => {
                    scope = Some(PlanScope {
                        field: self.name()?,
                        mask: parse_plan_u64_literal(&self.number()?)?,
                    });
                }
                "provenance" if provenance.is_none() => provenance = Some(self.name()?),
                "match" => {
                    let (adapter, arguments) = self.operation()?;
                    self.expect_word("from")?;
                    let inputs = self.inputs()?;
                    let binding = self.name()?;
                    self.expect_word("sort")?;
                    let output_sort = self.name()?;
                    self.expect_word("retain")?;
                    let retention = parse_plan_u64_literal(&self.number()?)?;
                    self.expect_word("memory")?;
                    steps.push(RecipeStep::Match {
                        adapter,
                        arguments,
                        inputs,
                        binding,
                        output_sort,
                        retention,
                        memory_bytes: parse_plan_u64_literal(&self.number()?)?,
                    });
                }
                "reduce" => {
                    let (reducer, arguments) = self.operation()?;
                    self.expect_word("from")?;
                    let inputs = self.inputs()?;
                    let binding = self.name()?;
                    self.expect_word("sort")?;
                    let output_sort = self.name()?;
                    self.expect_word("retain")?;
                    let retention = parse_plan_u64_literal(&self.number()?)?;
                    self.expect_word("memory")?;
                    steps.push(RecipeStep::Reduce {
                        reducer,
                        arguments,
                        inputs,
                        binding,
                        output_sort,
                        retention,
                        memory_bytes: parse_plan_u64_literal(&self.number()?)?,
                    });
                }
                "canonicalize" => {
                    let (action, arguments) = self.operation()?;
                    self.expect_word("from")?;
                    let inputs = self.inputs()?;
                    let binding = self.name()?;
                    self.expect_word("sort")?;
                    let output_sort = self.name()?;
                    self.expect_word("retain")?;
                    let retention = parse_plan_u64_literal(&self.number()?)?;
                    self.expect_word("memory")?;
                    let memory_bytes = parse_plan_u64_literal(&self.number()?)?;
                    self.expect_word("streamed")?;
                    let streamed_partition = match self.word()?.as_str() {
                        "true" => true,
                        "false" => false,
                        _ => return self.error("expected true or false"),
                    };
                    self.expect_word("contract")?;
                    let label_contract = match self.word()?.as_str() {
                        "preserves" => LabelContract::Preserves,
                        "transports" => LabelContract::Transports,
                        "diagnostic" => LabelContract::Diagnostic,
                        _ => return self.error("unknown label contract"),
                    };
                    self.expect_word("verified")?;
                    let action_verified = match self.word()?.as_str() {
                        "true" => true,
                        "false" => false,
                        _ => return self.error("expected true or false"),
                    };
                    steps.push(RecipeStep::Canonicalize {
                        action,
                        arguments,
                        inputs,
                        binding,
                        output_sort,
                        retention,
                        memory_bytes,
                        streamed_partition,
                        gate: CanonicalizationGate {
                            label_contract,
                            action_verified,
                        },
                    });
                }
                "emit" if emit_binding.is_none() => emit_binding = Some(self.name()?),
                "sink" => sinks.push(self.name()?),
                "verify" => gates.push(self.name()?),
                "source" | "label" | "scope" | "provenance" | "emit" => {
                    return self.error("duplicate semantic recipe declaration");
                }
                _ => return self.error("unknown semantic recipe declaration"),
            }
            self.expect(PlanTextTokenKind::Semi)?;
        }
        if self.at != self.tokens.len() {
            return self.error("trailing tokens after semantic recipe");
        }
        let recipe = SemanticRecipe {
            schema: SEMANTIC_RECIPE_SCHEMA.into(),
            name,
            source: source
                .ok_or_else(|| ControlError::Invalid("semantic recipe omits source".into()))?,
            source_binding: source_binding.ok_or_else(|| {
                ControlError::Invalid("semantic recipe omits source binding".into())
            })?,
            source_sort: source_sort
                .ok_or_else(|| ControlError::Invalid("semantic recipe omits source sort".into()))?,
            label: label
                .ok_or_else(|| ControlError::Invalid("semantic recipe omits label".into()))?,
            scope,
            provenance: provenance
                .ok_or_else(|| ControlError::Invalid("semantic recipe omits provenance".into()))?,
            steps: steps.into_boxed_slice(),
            emit_binding: emit_binding.ok_or_else(|| {
                ControlError::Invalid("semantic recipe omits output binding".into())
            })?,
            sinks: sinks.into_boxed_slice(),
            gates: gates.into_boxed_slice(),
        };
        recipe.validate()?;
        Ok(recipe)
    }

    fn inputs(&mut self) -> Result<Box<[String]>, ControlError> {
        let mut inputs = Vec::new();
        loop {
            inputs.push(self.name()?);
            if !self.consume(&PlanTextTokenKind::Comma) {
                break;
            }
        }
        self.expect_word("as")?;
        Ok(inputs.into_boxed_slice())
    }

    fn expression_until_semicolon(&mut self) -> Result<PlanExpr, ControlError> {
        let start = self
            .tokens
            .get(self.at)
            .ok_or_else(|| ControlError::Invalid("semantic recipe omits label expression".into()))?
            .offset;
        let end_index = self.tokens[self.at..]
            .iter()
            .position(|token| token.kind == PlanTextTokenKind::Semi)
            .map(|offset| self.at + offset)
            .ok_or_else(|| ControlError::Invalid("unterminated label expression".into()))?;
        if end_index == self.at {
            return self.error("semantic recipe omits label expression");
        }
        let end = self.tokens[end_index].offset;
        self.at = end_index + 1;
        parse_plan_expression(&self.text[start..end])
    }

    fn take(&mut self) -> Result<PlanTextToken, ControlError> {
        let token = self
            .tokens
            .get(self.at)
            .cloned()
            .ok_or_else(|| ControlError::Invalid("unexpected end of semantic recipe".into()))?;
        self.at += 1;
        Ok(token)
    }

    fn operation(&mut self) -> Result<(String, Box<[OperationArgument]>), ControlError> {
        let name = self.name()?;
        if !self.consume(&PlanTextTokenKind::LParen) {
            return Ok((name, Box::new([])));
        }
        let mut arguments = Vec::new();
        if self.consume(&PlanTextTokenKind::RParen) {
            return Ok((name, arguments.into_boxed_slice()));
        }
        loop {
            let argument = self.name()?;
            self.expect(PlanTextTokenKind::Assign)?;
            arguments.push(OperationArgument {
                name: argument,
                value: self.argument_value()?,
            });
            if self.consume(&PlanTextTokenKind::RParen) {
                break;
            }
            self.expect(PlanTextTokenKind::Comma)?;
        }
        Ok((name, arguments.into_boxed_slice()))
    }

    fn argument_value(&mut self) -> Result<OperationArgumentValue, ControlError> {
        let token = self.take()?;
        match token.kind {
            PlanTextTokenKind::Number(value) => Ok(OperationArgumentValue::Integer(
                parse_plan_i64_literal(&value)?,
            )),
            PlanTextTokenKind::Minus => {
                let magnitude = self.number()?;
                Ok(OperationArgumentValue::Integer(parse_plan_i64_literal(
                    &format!("-{magnitude}"),
                )?))
            }
            PlanTextTokenKind::Quoted(value) => Ok(OperationArgumentValue::Name(value)),
            PlanTextTokenKind::Word(value) if value == "true" => {
                Ok(OperationArgumentValue::Boolean(true))
            }
            PlanTextTokenKind::Word(value) if value == "false" => {
                Ok(OperationArgumentValue::Boolean(false))
            }
            PlanTextTokenKind::Word(value) => Ok(OperationArgumentValue::Name(value)),
            _ => invalid_at(token.offset, "expected operation argument value"),
        }
    }

    fn name(&mut self) -> Result<String, ControlError> {
        let token = self.take()?;
        match token.kind {
            PlanTextTokenKind::Word(value) | PlanTextTokenKind::Quoted(value) => Ok(value),
            _ => invalid_at(token.offset, "expected name"),
        }
    }

    fn word(&mut self) -> Result<String, ControlError> {
        let token = self.take()?;
        match token.kind {
            PlanTextTokenKind::Word(value) => Ok(value),
            _ => invalid_at(token.offset, "expected word"),
        }
    }

    fn number(&mut self) -> Result<String, ControlError> {
        let token = self.take()?;
        match token.kind {
            PlanTextTokenKind::Number(value) => Ok(value),
            _ => invalid_at(token.offset, "expected integer"),
        }
    }

    fn expect_word(&mut self, expected: &str) -> Result<(), ControlError> {
        if self.word()? == expected {
            Ok(())
        } else {
            self.error(&format!("expected {expected}"))
        }
    }

    fn expect(&mut self, expected: PlanTextTokenKind) -> Result<(), ControlError> {
        if self.consume(&expected) {
            Ok(())
        } else {
            self.error("unexpected token")
        }
    }

    fn consume(&mut self, expected: &PlanTextTokenKind) -> bool {
        if self
            .tokens
            .get(self.at)
            .is_some_and(|token| &token.kind == expected)
        {
            self.at += 1;
            true
        } else {
            false
        }
    }

    fn error<T>(&self, message: &str) -> Result<T, ControlError> {
        let offset = self.tokens.get(self.at).map_or_else(
            || self.tokens.last().map_or(0, |token| token.offset + 1),
            |token| token.offset,
        );
        invalid_at(offset, message)
    }
}

fn invalid<T>(message: &str) -> Result<T, ControlError> {
    Err(ControlError::Invalid(message.into()))
}

fn invalid_at<T>(offset: usize, message: &str) -> Result<T, ControlError> {
    Err(ControlError::Invalid(format!("{message} at byte {offset}")))
}

impl CanonicalizationGate {
    #[must_use]
    pub const fn proof_eligible(self) -> bool {
        match self.label_contract {
            LabelContract::Preserves | LabelContract::Transports => self.action_verified,
            LabelContract::Diagnostic => false,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEXT: &str = r#"
recipe affine_caps {
  source split_nine_sets as objects sort nine_set_stream;
  label (g2 == 0) && (g3 == 0);
  scope root.kind 0x0000000000000005;
  provenance "sha256:fixture";
  match affine_subspace(rank=2, metric=max_overlap) from objects as plane sort feature_row retain 1 memory 4096;
  reduce overlap_histogram(weighted=true) from plane as extrema sort retained_set retain 2106 memory 131072;
  canonicalize affine_generators(count=4) from extrema as cap_orbit sort orbit_summary retain 2106 memory 65536 streamed false contract diagnostic verified true;
  emit cap_orbit;
  verify replay_label;
  verify source_hash;
}
"#;

    #[test]
    fn diagnostic_symmetry_never_enters_proof_packet() {
        let gate = CanonicalizationGate {
            label_contract: LabelContract::Diagnostic,
            action_verified: true,
        };
        assert!(!gate.proof_eligible());
    }

    #[test]
    fn transported_labels_require_verified_action() {
        let unverified = CanonicalizationGate {
            label_contract: LabelContract::Transports,
            action_verified: false,
        };
        assert!(!unverified.proof_eligible());
        assert!(CanonicalizationGate {
            label_contract: LabelContract::Transports,
            action_verified: true,
        }
        .proof_eligible());
    }

    #[test]
    fn text_json_and_canonical_text_share_one_typed_recipe() {
        let parsed = parse_semantic_recipe(TEXT).unwrap();
        assert_eq!(parsed.steps[0].kind(), OpKind::Match);
        assert_eq!(parsed.steps[1].kind(), OpKind::Reduce);
        assert_eq!(parsed.steps[2].kind(), OpKind::Canonicalize);
        assert_eq!(parsed.steps[0].arguments().len(), 2);
        let formatted = format_semantic_recipe(&parsed).unwrap();
        let reparsed = parse_semantic_recipe(&formatted).unwrap();
        assert_eq!(
            parsed.canonical_json().unwrap(),
            reparsed.canonical_json().unwrap()
        );
        let from_json: SemanticRecipe =
            serde_json::from_slice(&parsed.canonical_json().unwrap()).unwrap();
        assert_eq!(
            parsed.canonical_json().unwrap(),
            from_json.canonical_json().unwrap()
        );
        assert_eq!(format_semantic_recipe(&reparsed).unwrap(), formatted);
        let RecipeStep::Canonicalize { gate, .. } = parsed.steps[2] else {
            panic!("expected canonicalization");
        };
        assert!(!gate.proof_eligible());
    }

    #[test]
    fn recipes_fail_closed_on_unbounded_or_unsafe_structure() {
        assert!(parse_semantic_recipe(
            "recipe x { source s as rows sort stream; label a == 1; provenance p; canonicalize g from rows as q sort orbit retain 1 memory 1 streamed false contract preserves verified true; emit q; verify replay; }"
        )
        .is_err());
        assert!(parse_semantic_recipe(
            "recipe x { source s as rows sort stream; label a == 1; provenance p; match m from rows as x sort feature retain 1 memory 1; reduce r from x as x sort set retain 1 memory 1; emit x; verify replay; }"
        )
        .is_err());
        assert!(parse_semantic_recipe(
            "recipe x { source s as rows sort stream; label a == 1; provenance p; match m from rows as y sort feature retain 1 memory 1; reduce r from y as q sort set retain 0 memory 1; emit q; verify replay; }"
        )
        .is_err());
        assert!(parse_semantic_recipe(
            "recipe x { source s as rows sort stream; label a == 1; provenance p; match m from rows as y sort feature retain 1 memory 1; reduce r from y as q sort set retain 1 memory 1; emit q; }"
        )
        .is_err());
        assert!(parse_semantic_recipe(
            "recipe x { source s as rows sort stream; label a == 1; provenance p; match m from missing as y sort feature retain 1 memory 1; emit y; verify replay; }"
        )
        .is_err());
        assert!(parse_semantic_recipe(
            "recipe x { source s as rows sort stream; label a == 1; provenance p; match m from rows as y sort feature retain 1 memory 1; emit y; verify replay; }"
        )
        .is_err());
    }
}
