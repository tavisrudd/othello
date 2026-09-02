//! Typed authoring contract for injected theorem fragments.

use super::{
    format_operation, CanonicalizationGate, LabelContract, OperationArgument,
    OperationArgumentValue,
};
use ergodis::control::{
    format_plan_expression, format_plan_name, lex_plan_text, parse_plan_expression,
    validate_plan_name, ControlError, ExpressionPlanSpec, PlanExpr, PlanOutput, PlanRole,
    PlanScope, PlanTextToken, PlanTextTokenKind, MAX_PLAN_OPS, PLAN_SCHEMA,
};
use serde::{Deserialize, Serialize};
use std::collections::BTreeSet;

pub const THEOREM_FRAGMENT_SCHEMA: &str = "ergodis-theorem-fragment-v0";

#[derive(Debug, Clone, Copy, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub enum Quantifier {
    ForAll,
    Exists,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
#[repr(u8)]
pub enum FragmentStatus {
    Candidate,
    FiniteCertified,
    Proved,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub enum ObservableContract {
    Exact,
    LowerBound,
    Diagnostic,
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct TypedBinding {
    pub name: String,
    pub sort: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct QuantifiedBinding {
    pub quantifier: Quantifier,
    pub name: String,
    pub sort: String,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct NamedPredicate {
    pub name: String,
    pub expr: PlanExpr,
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct ObservableDeclaration {
    pub name: String,
    pub contract: ObservableContract,
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct ActionDeclaration {
    pub name: String,
    pub arguments: Box<[OperationArgument]>,
    pub gate: CanonicalizationGate,
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct CertificateReference {
    pub verifier: String,
    pub reference: String,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
pub struct TheoremFragment {
    pub schema: String,
    pub name: String,
    pub domain: String,
    pub evidence_sort: String,
    pub parameters: Box<[TypedBinding]>,
    pub variables: Box<[QuantifiedBinding]>,
    pub hypotheses: Box<[NamedPredicate]>,
    pub conclusion: PlanExpr,
    pub observables: Box<[ObservableDeclaration]>,
    pub actions: Box<[ActionDeclaration]>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub scope: Option<PlanScope>,
    pub dependencies: Box<[String]>,
    pub provenance: String,
    pub status: FragmentStatus,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub certificate: Option<CertificateReference>,
}

impl TheoremFragment {
    pub fn validate(&self) -> Result<(), ControlError> {
        if self.schema != THEOREM_FRAGMENT_SCHEMA {
            return invalid("theorem fragment has an unsupported schema");
        }
        validate_plan_name(&self.name)?;
        validate_plan_name(&self.domain)?;
        validate_plan_name(&self.evidence_sort)?;
        validate_plan_name(&self.provenance)?;
        if let Some(scope) = &self.scope {
            validate_plan_name(&scope.field)?;
        }
        if self.parameters.len() > MAX_PLAN_OPS
            || self.variables.len() > MAX_PLAN_OPS
            || self.hypotheses.len() > MAX_PLAN_OPS
            || self.observables.is_empty()
            || self.observables.len() > MAX_PLAN_OPS
            || self.actions.len() > MAX_PLAN_OPS
            || self.dependencies.len() > MAX_PLAN_OPS
        {
            return invalid("theorem fragment exceeds a declaration bound");
        }

        let mut declared = BTreeSet::new();
        for binding in &self.parameters {
            validate_binding(binding, &mut declared)?;
        }
        for binding in &self.variables {
            validate_plan_name(&binding.name)?;
            validate_plan_name(&binding.sort)?;
            if !declared.insert(binding.name.as_str()) {
                return invalid("theorem fragment contains a duplicate typed binding");
            }
        }

        let mut predicate_names = BTreeSet::new();
        for hypothesis in &self.hypotheses {
            validate_plan_name(&hypothesis.name)?;
            if !predicate_names.insert(hypothesis.name.as_str()) {
                return invalid("theorem fragment contains a duplicate hypothesis");
            }
            validate_predicate(&self.name, &hypothesis.expr, &declared)?;
        }
        validate_predicate(&self.name, &self.conclusion, &declared)?;

        let mut observable_names = BTreeSet::new();
        for observable in &self.observables {
            validate_plan_name(&observable.name)?;
            if !observable_names.insert(observable.name.as_str()) {
                return invalid("theorem fragment contains a duplicate observable");
            }
        }
        let mut action_names = BTreeSet::new();
        for action in &self.actions {
            validate_plan_name(&action.name)?;
            let mut arguments = BTreeSet::new();
            for argument in &action.arguments {
                validate_plan_name(&argument.name)?;
                if let OperationArgumentValue::Name(value) = &argument.value {
                    validate_plan_name(value)?;
                }
                if !arguments.insert(argument.name.as_str()) {
                    return invalid("theorem action contains a duplicate argument");
                }
            }
            if !action_names.insert(action.name.as_str()) {
                return invalid("theorem fragment contains a duplicate action");
            }
        }
        let mut dependencies = BTreeSet::new();
        for dependency in &self.dependencies {
            validate_plan_name(dependency)?;
            if dependency == &self.name {
                return invalid("theorem fragment cannot depend on itself");
            }
            if !dependencies.insert(dependency.as_str()) {
                return invalid("theorem fragment contains a duplicate dependency");
            }
        }

        if let Some(certificate) = &self.certificate {
            validate_plan_name(&certificate.verifier)?;
            validate_plan_name(&certificate.reference)?;
        }
        if self.status >= FragmentStatus::FiniteCertified && self.certificate.is_none() {
            return invalid("certified theorem fragment omits its verifier reference");
        }
        if self.status >= FragmentStatus::FiniteCertified
            && self
                .observables
                .iter()
                .any(|observable| observable.contract == ObservableContract::Diagnostic)
        {
            return invalid("diagnostic observables cannot carry certified authority");
        }
        if self.status >= FragmentStatus::FiniteCertified
            && self
                .actions
                .iter()
                .any(|action| !action.gate.proof_eligible())
        {
            return invalid("unverified or diagnostic actions cannot carry certified authority");
        }
        Ok(())
    }

    pub fn canonical_json(&self) -> Result<Vec<u8>, ControlError> {
        self.validate()?;
        serde_json::to_vec(self).map_err(ControlError::Json)
    }

    #[must_use]
    pub fn authority_eligible(&self) -> bool {
        self.status >= FragmentStatus::FiniteCertified && self.validate().is_ok()
    }
}

pub fn parse_theorem_fragment(text: &str) -> Result<TheoremFragment, ControlError> {
    FragmentParser::new(text, lex_plan_text(text)?).parse()
}

pub fn format_theorem_fragment(fragment: &TheoremFragment) -> Result<String, ControlError> {
    fragment.validate()?;
    let mut text = format!(
        "theorem {} {{\n  domain {};\n  evidence {};\n",
        format_plan_name(&fragment.name)?,
        format_plan_name(&fragment.domain)?,
        format_plan_name(&fragment.evidence_sort)?
    );
    for parameter in &fragment.parameters {
        text.push_str(&format!(
            "  parameter {} {};\n",
            format_plan_name(&parameter.name)?,
            format_plan_name(&parameter.sort)?
        ));
    }
    for variable in &fragment.variables {
        text.push_str(&format!(
            "  {} {} {};\n",
            quantifier_name(variable.quantifier),
            format_plan_name(&variable.name)?,
            format_plan_name(&variable.sort)?
        ));
    }
    for hypothesis in &fragment.hypotheses {
        text.push_str(&format!(
            "  hypothesis {} {};\n",
            format_plan_name(&hypothesis.name)?,
            format_plan_expression(&hypothesis.expr)?
        ));
    }
    text.push_str(&format!(
        "  conclusion {};\n",
        format_plan_expression(&fragment.conclusion)?
    ));
    for observable in &fragment.observables {
        text.push_str(&format!(
            "  observable {} contract {};\n",
            format_plan_name(&observable.name)?,
            observable_contract_name(observable.contract)
        ));
    }
    for action in &fragment.actions {
        text.push_str(&format!(
            "  action {} contract {} verified {};\n",
            format_operation(&action.name, &action.arguments)?,
            label_contract_name(action.gate.label_contract),
            action.gate.action_verified
        ));
    }
    if let Some(scope) = &fragment.scope {
        text.push_str(&format!(
            "  scope {} 0x{:016x};\n",
            format_plan_name(&scope.field)?,
            scope.mask
        ));
    }
    for dependency in &fragment.dependencies {
        text.push_str(&format!("  depends {};\n", format_plan_name(dependency)?));
    }
    text.push_str(&format!(
        "  provenance {};\n  status {};\n",
        format_plan_name(&fragment.provenance)?,
        status_name(fragment.status)
    ));
    if let Some(certificate) = &fragment.certificate {
        text.push_str(&format!(
            "  certificate {} {};\n",
            format_plan_name(&certificate.verifier)?,
            format_plan_name(&certificate.reference)?
        ));
    }
    text.push_str("}\n");
    Ok(text)
}

fn validate_binding<'a>(
    binding: &'a TypedBinding,
    declared: &mut BTreeSet<&'a str>,
) -> Result<(), ControlError> {
    validate_plan_name(&binding.name)?;
    validate_plan_name(&binding.sort)?;
    if !declared.insert(binding.name.as_str()) {
        return invalid("theorem fragment contains a duplicate typed binding");
    }
    Ok(())
}

fn validate_predicate(
    fragment_name: &str,
    expr: &PlanExpr,
    declared: &BTreeSet<&str>,
) -> Result<(), ControlError> {
    ExpressionPlanSpec {
        schema: PLAN_SCHEMA.into(),
        name: fragment_name.into(),
        role: PlanRole::Diagnostic,
        output: PlanOutput::Predicate,
        scope: None,
        expr: expr.clone(),
    }
    .lower()?;
    let mut work = vec![expr];
    while let Some(node) = work.pop() {
        match node {
            PlanExpr::Field { name } => {
                if !declared.contains(name.as_str()) {
                    return invalid("theorem predicate references an undeclared binding");
                }
            }
            PlanExpr::Const { .. } => {}
            PlanExpr::Add { left, right }
            | PlanExpr::Sub { left, right }
            | PlanExpr::Mul { left, right }
            | PlanExpr::Mod { left, right }
            | PlanExpr::Div { left, right }
            | PlanExpr::Gcd { left, right }
            | PlanExpr::GaussianNorm { left, right }
            | PlanExpr::EisensteinNorm { left, right }
            | PlanExpr::Min { left, right }
            | PlanExpr::Max { left, right }
            | PlanExpr::Eq { left, right }
            | PlanExpr::Ne { left, right }
            | PlanExpr::Lt { left, right }
            | PlanExpr::Le { left, right }
            | PlanExpr::Gt { left, right }
            | PlanExpr::Ge { left, right }
            | PlanExpr::And { left, right }
            | PlanExpr::Or { left, right } => {
                work.push(right);
                work.push(left);
            }
            PlanExpr::Not { arg }
            | PlanExpr::Abs { arg }
            | PlanExpr::PopCount { arg }
            | PlanExpr::Parity { arg }
            | PlanExpr::Legendre { arg, .. } => work.push(arg),
            PlanExpr::Select {
                condition,
                then_value,
                else_value,
            } => {
                work.push(else_value);
                work.push(then_value);
                work.push(condition);
            }
        }
    }
    Ok(())
}

fn quantifier_name(quantifier: Quantifier) -> &'static str {
    match quantifier {
        Quantifier::ForAll => "forall",
        Quantifier::Exists => "exists",
    }
}

fn observable_contract_name(contract: ObservableContract) -> &'static str {
    match contract {
        ObservableContract::Exact => "exact",
        ObservableContract::LowerBound => "lower_bound",
        ObservableContract::Diagnostic => "diagnostic",
    }
}

fn label_contract_name(contract: LabelContract) -> &'static str {
    match contract {
        LabelContract::Preserves => "preserves",
        LabelContract::Transports => "transports",
        LabelContract::Diagnostic => "diagnostic",
    }
}

fn status_name(status: FragmentStatus) -> &'static str {
    match status {
        FragmentStatus::Candidate => "candidate",
        FragmentStatus::FiniteCertified => "finite_certified",
        FragmentStatus::Proved => "proved",
    }
}

struct FragmentParser<'a> {
    text: &'a str,
    tokens: Vec<PlanTextToken>,
    at: usize,
}

impl<'a> FragmentParser<'a> {
    fn new(text: &'a str, tokens: Vec<PlanTextToken>) -> Self {
        Self {
            text,
            tokens,
            at: 0,
        }
    }

    fn parse(mut self) -> Result<TheoremFragment, ControlError> {
        self.expect_word("theorem")?;
        let name = self.name()?;
        self.expect(PlanTextTokenKind::LBrace)?;
        let (
            mut domain,
            mut evidence_sort,
            mut conclusion,
            mut scope,
            mut provenance,
            mut status,
            mut certificate,
        ) = (None, None, None, None, None, None, None);
        let mut parameters = Vec::new();
        let mut variables = Vec::new();
        let mut hypotheses = Vec::new();
        let mut observables = Vec::new();
        let mut actions = Vec::new();
        let mut dependencies = Vec::new();
        while !self.consume(&PlanTextTokenKind::RBrace) {
            match self.word()?.as_str() {
                "domain" if domain.is_none() => domain = Some(self.name()?),
                "evidence" if evidence_sort.is_none() => evidence_sort = Some(self.name()?),
                "parameter" => parameters.push(TypedBinding {
                    name: self.name()?,
                    sort: self.name()?,
                }),
                "forall" => variables.push(QuantifiedBinding {
                    quantifier: Quantifier::ForAll,
                    name: self.name()?,
                    sort: self.name()?,
                }),
                "exists" => variables.push(QuantifiedBinding {
                    quantifier: Quantifier::Exists,
                    name: self.name()?,
                    sort: self.name()?,
                }),
                "hypothesis" => {
                    let name = self.name()?;
                    hypotheses.push(NamedPredicate {
                        name,
                        expr: self.expression_until_semicolon()?,
                    });
                    continue;
                }
                "conclusion" if conclusion.is_none() => {
                    conclusion = Some(self.expression_until_semicolon()?);
                    continue;
                }
                "observable" => {
                    let name = self.name()?;
                    self.expect_word("contract")?;
                    let contract = match self.word()?.as_str() {
                        "exact" => ObservableContract::Exact,
                        "lower_bound" => ObservableContract::LowerBound,
                        "diagnostic" => ObservableContract::Diagnostic,
                        _ => return self.error("unknown observable contract"),
                    };
                    observables.push(ObservableDeclaration { name, contract });
                }
                "action" => {
                    let (name, arguments) = self.operation()?;
                    self.expect_word("contract")?;
                    let label_contract = match self.word()?.as_str() {
                        "preserves" => LabelContract::Preserves,
                        "transports" => LabelContract::Transports,
                        "diagnostic" => LabelContract::Diagnostic,
                        _ => return self.error("unknown action contract"),
                    };
                    self.expect_word("verified")?;
                    let action_verified = self.boolean()?;
                    actions.push(ActionDeclaration {
                        name,
                        arguments,
                        gate: CanonicalizationGate {
                            label_contract,
                            action_verified,
                        },
                    });
                }
                "scope" if scope.is_none() => {
                    scope = Some(PlanScope {
                        field: self.name()?,
                        mask: ergodis::control::parse_plan_u64_literal(&self.number()?)?,
                    });
                }
                "depends" => dependencies.push(self.name()?),
                "provenance" if provenance.is_none() => provenance = Some(self.name()?),
                "status" if status.is_none() => {
                    status = Some(match self.word()?.as_str() {
                        "candidate" => FragmentStatus::Candidate,
                        "finite_certified" => FragmentStatus::FiniteCertified,
                        "proved" => FragmentStatus::Proved,
                        _ => return self.error("unknown theorem-fragment status"),
                    });
                }
                "certificate" if certificate.is_none() => {
                    certificate = Some(CertificateReference {
                        verifier: self.name()?,
                        reference: self.name()?,
                    });
                }
                "domain" | "evidence" | "conclusion" | "scope" | "provenance" | "status"
                | "certificate" => return self.error("duplicate theorem fragment declaration"),
                _ => return self.error("unknown theorem fragment declaration"),
            }
            self.expect(PlanTextTokenKind::Semi)?;
        }
        if self.at != self.tokens.len() {
            return self.error("trailing tokens after theorem fragment");
        }
        let fragment = TheoremFragment {
            schema: THEOREM_FRAGMENT_SCHEMA.into(),
            name,
            domain: required(domain, "theorem fragment omits domain")?,
            evidence_sort: required(evidence_sort, "theorem fragment omits evidence sort")?,
            parameters: parameters.into_boxed_slice(),
            variables: variables.into_boxed_slice(),
            hypotheses: hypotheses.into_boxed_slice(),
            conclusion: required(conclusion, "theorem fragment omits conclusion")?,
            observables: observables.into_boxed_slice(),
            actions: actions.into_boxed_slice(),
            scope,
            dependencies: dependencies.into_boxed_slice(),
            provenance: required(provenance, "theorem fragment omits provenance")?,
            status: required(status, "theorem fragment omits status")?,
            certificate,
        };
        fragment.validate()?;
        Ok(fragment)
    }

    fn expression_until_semicolon(&mut self) -> Result<PlanExpr, ControlError> {
        let start = self
            .tokens
            .get(self.at)
            .ok_or_else(|| ControlError::Invalid("theorem fragment omits predicate".into()))?
            .offset;
        let end_index = self.tokens[self.at..]
            .iter()
            .position(|token| token.kind == PlanTextTokenKind::Semi)
            .map(|offset| self.at + offset)
            .ok_or_else(|| ControlError::Invalid("unterminated theorem predicate".into()))?;
        if end_index == self.at {
            return self.error("theorem fragment omits predicate");
        }
        let end = self.tokens[end_index].offset;
        self.at = end_index + 1;
        parse_plan_expression(&self.text[start..end])
    }

    fn take(&mut self) -> Result<PlanTextToken, ControlError> {
        let token =
            self.tokens.get(self.at).cloned().ok_or_else(|| {
                ControlError::Invalid("unexpected end of theorem fragment".into())
            })?;
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
                ergodis::control::parse_plan_i64_literal(&value)?,
            )),
            PlanTextTokenKind::Minus => {
                let magnitude = self.number()?;
                Ok(OperationArgumentValue::Integer(
                    ergodis::control::parse_plan_i64_literal(&format!("-{magnitude}"))?,
                ))
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

    fn boolean(&mut self) -> Result<bool, ControlError> {
        match self.word()?.as_str() {
            "true" => Ok(true),
            "false" => Ok(false),
            _ => self.error("expected true or false"),
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

fn required<T>(value: Option<T>, message: &str) -> Result<T, ControlError> {
    value.ok_or_else(|| ControlError::Invalid(message.into()))
}

fn invalid<T>(message: &str) -> Result<T, ControlError> {
    Err(ControlError::Invalid(message.into()))
}

fn invalid_at<T>(offset: usize, message: &str) -> Result<T, ControlError> {
    Err(ControlError::Invalid(format!("{message} at byte {offset}")))
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEXT: &str = r#"
theorem cap_label_exclusion {
  domain gf27_nine_set;
  evidence orbit_summary;
  parameter g2 scalar;
  parameter g3 scalar;
  forall cap nine_set;
  hypothesis labelled g2 == 0;
  conclusion g3 != 0;
  observable cap_overlap contract exact;
  action semilinear contract transports verified true;
  scope root.kind 0x0000000000000003;
  depends affine_switch;
  provenance "sha256:fixture";
  status finite_certified;
  certificate replay_hankel "sha256:packet";
}
"#;

    #[test]
    fn text_json_and_canonical_text_share_one_fragment() {
        let parsed = parse_theorem_fragment(TEXT).unwrap();
        assert!(parsed.authority_eligible());
        let formatted = format_theorem_fragment(&parsed).unwrap();
        let reparsed = parse_theorem_fragment(&formatted).unwrap();
        assert_eq!(
            parsed.canonical_json().unwrap(),
            reparsed.canonical_json().unwrap()
        );
        let from_json: TheoremFragment =
            serde_json::from_slice(&parsed.canonical_json().unwrap()).unwrap();
        assert_eq!(
            parsed.canonical_json().unwrap(),
            from_json.canonical_json().unwrap()
        );
        assert_eq!(format_theorem_fragment(&reparsed).unwrap(), formatted);
    }

    #[test]
    fn certified_fragments_fail_closed() {
        assert!(parse_theorem_fragment(
            &TEXT.replace("certificate replay_hankel \"sha256:packet\";", "")
        )
        .is_err());
        assert!(parse_theorem_fragment(&TEXT.replace(
            "contract transports verified true",
            "contract diagnostic verified true"
        ))
        .is_err());
        assert!(parse_theorem_fragment(&TEXT.replace("g3 != 0", "missing != 0")).is_err());
        assert!(parse_theorem_fragment(
            &TEXT.replace("depends affine_switch;", "depends cap_label_exclusion;")
        )
        .is_err());
    }

    #[test]
    fn diagnostic_candidate_is_retained_without_authority() {
        let candidate = TEXT
            .replace("contract exact", "contract diagnostic")
            .replace(
                "contract transports verified true",
                "contract diagnostic verified false",
            )
            .replace("status finite_certified", "status candidate")
            .replace("  certificate replay_hankel \"sha256:packet\";\n", "");
        let parsed = parse_theorem_fragment(&candidate).unwrap();
        assert!(!parsed.authority_eligible());
    }
}
