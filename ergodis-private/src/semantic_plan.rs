//! Typed, bounded `match / reduce / canonicalize` recipe contracts.

use ergodis::control::{
    format_plan_expression, format_plan_name, lex_plan_text, parse_plan_expression,
    parse_plan_u64_literal, validate_plan_name, ControlError, ExpressionPlanSpec, PlanExpr,
    PlanOutput, PlanRole, PlanScope, PlanTextToken, PlanTextTokenKind, MAX_PLAN_OPS, PLAN_SCHEMA,
};
use serde::{Deserialize, Serialize};
use std::collections::BTreeSet;

pub const SEMANTIC_RECIPE_SCHEMA: &str = "ergodis-semantic-recipe-v0";

#[derive(Debug, Clone, Copy, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
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
#[serde(tag = "op", rename_all = "kebab-case", deny_unknown_fields)]
pub enum RecipeStep {
    Match {
        adapter: String,
        binding: String,
    },
    Reduce {
        reducer: String,
        binding: String,
        retention: u64,
    },
    Canonicalize {
        action: String,
        binding: String,
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
}

#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct SemanticRecipe {
    pub schema: String,
    pub name: String,
    pub source: String,
    pub label: PlanExpr,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub scope: Option<PlanScope>,
    pub provenance: String,
    pub steps: Box<[RecipeStep]>,
    pub gates: Box<[String]>,
}

impl SemanticRecipe {
    pub fn validate(&self) -> Result<(), ControlError> {
        if self.schema != SEMANTIC_RECIPE_SCHEMA {
            return invalid("semantic recipe has an unsupported schema");
        }
        validate_plan_name(&self.name)?;
        validate_plan_name(&self.source)?;
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
        let mut bindings = BTreeSet::new();
        let mut reduced = false;
        for step in &self.steps {
            let binding = step.binding();
            validate_plan_name(binding)?;
            if !bindings.insert(binding) {
                return invalid("semantic recipe contains a duplicate binding");
            }
            match step {
                RecipeStep::Match { adapter, .. } => validate_plan_name(adapter)?,
                RecipeStep::Reduce {
                    reducer, retention, ..
                } => {
                    validate_plan_name(reducer)?;
                    if *retention == 0 {
                        return invalid("semantic reducer must retain a bounded positive count");
                    }
                    reduced = true;
                }
                RecipeStep::Canonicalize { action, .. } => {
                    validate_plan_name(action)?;
                    if !reduced {
                        return invalid("canonicalization requires an earlier bounded reducer");
                    }
                }
            }
        }
        for gate in &self.gates {
            validate_plan_name(gate)?;
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
        "  source {};\n  label {};\n",
        format_plan_name(&recipe.source)?,
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
            RecipeStep::Match { adapter, binding } => text.push_str(&format!(
                "  match {} as {};\n",
                format_plan_name(adapter)?,
                format_plan_name(binding)?
            )),
            RecipeStep::Reduce {
                reducer,
                binding,
                retention,
            } => text.push_str(&format!(
                "  reduce {} as {} retain {};\n",
                format_plan_name(reducer)?,
                format_plan_name(binding)?,
                retention
            )),
            RecipeStep::Canonicalize {
                action,
                binding,
                gate,
            } => text.push_str(&format!(
                "  canonicalize {} contract {} verified {} as {};\n",
                format_plan_name(action)?,
                contract_name(gate.label_contract),
                gate.action_verified,
                format_plan_name(binding)?
            )),
        }
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
        let (mut source, mut label, mut scope, mut provenance) = (None, None, None, None);
        let mut steps = Vec::new();
        let mut gates = Vec::new();
        while !self.consume(&PlanTextTokenKind::RBrace) {
            match self.word()?.as_str() {
                "source" if source.is_none() => source = Some(self.name()?),
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
                    let adapter = self.name()?;
                    self.expect_word("as")?;
                    steps.push(RecipeStep::Match {
                        adapter,
                        binding: self.name()?,
                    });
                }
                "reduce" => {
                    let reducer = self.name()?;
                    self.expect_word("as")?;
                    let binding = self.name()?;
                    self.expect_word("retain")?;
                    steps.push(RecipeStep::Reduce {
                        reducer,
                        binding,
                        retention: parse_plan_u64_literal(&self.number()?)?,
                    });
                }
                "canonicalize" => {
                    let action = self.name()?;
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
                    self.expect_word("as")?;
                    steps.push(RecipeStep::Canonicalize {
                        action,
                        binding: self.name()?,
                        gate: CanonicalizationGate {
                            label_contract,
                            action_verified,
                        },
                    });
                }
                "verify" => gates.push(self.name()?),
                "source" | "label" | "scope" | "provenance" => {
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
            label: label
                .ok_or_else(|| ControlError::Invalid("semantic recipe omits label".into()))?,
            scope,
            provenance: provenance
                .ok_or_else(|| ControlError::Invalid("semantic recipe omits provenance".into()))?,
            steps: steps.into_boxed_slice(),
            gates: gates.into_boxed_slice(),
        };
        recipe.validate()?;
        Ok(recipe)
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
  source split_nine_sets;
  label (g2 == 0) && (g3 == 0);
  scope root.kind 0x0000000000000005;
  provenance "sha256:fixture";
  match affine_subspace as plane;
  reduce overlap_histogram as extrema retain 2106;
  canonicalize affine_generators contract diagnostic verified true as cap_orbit;
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
            "recipe x { source s; label a == 1; provenance p; canonicalize g contract preserves verified true as q; verify replay; }"
        )
        .is_err());
        assert!(parse_semantic_recipe(
            "recipe x { source s; label a == 1; provenance p; match m as x; reduce r as x retain 1; verify replay; }"
        )
        .is_err());
        assert!(parse_semantic_recipe(
            "recipe x { source s; label a == 1; provenance p; match m as y; reduce r as q retain 0; verify replay; }"
        )
        .is_err());
        assert!(parse_semantic_recipe(
            "recipe x { source s; label a == 1; provenance p; match m as y; reduce r as q retain 1; }"
        )
        .is_err());
    }
}
