//! Bounded textual authoring for scalar steering plans.

use super::{
    ControlError, ExpressionPlanSpec, PlanExpr, PlanOutput, PlanRole, PlanScope, PlanSpec,
    MAX_FRAME_BYTES, MAX_PLAN_OPS, PLAN_SCHEMA,
};

pub const MAX_PLAN_TEXT_BYTES: usize = MAX_FRAME_BYTES;
pub const MAX_PLAN_TEXT_TOKENS: usize = 4 * MAX_PLAN_OPS;
const MAX_PLAN_TEXT_DEPTH: usize = 32;
const MAX_NAME_BYTES: usize = 256;

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum PlanTextTokenKind {
    Word(String),
    Quoted(String),
    Number(String),
    LBrace,
    RBrace,
    LParen,
    RParen,
    Comma,
    Semi,
    Plus,
    Minus,
    Star,
    Bang,
    Assign,
    Eq,
    Ne,
    Lt,
    Le,
    Gt,
    Ge,
    And,
    Or,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct PlanTextToken {
    pub kind: PlanTextTokenKind,
    pub offset: usize,
}

type Kind = PlanTextTokenKind;
type Token = PlanTextToken;

/// Parse a bounded textual plan into the same typed AST used by JSON plans.
pub fn parse_expression_plan(text: &str) -> Result<ExpressionPlanSpec, ControlError> {
    Parser::new(lex_plan_text(text)?).parse_plan()
}

/// Tokenize a bounded plan-language document.
///
/// Recipe and theorem front ends use this same lexer so identifiers, quoted
/// names, integers, comments, operators, and resource limits cannot drift
/// from scalar steering plans.
pub fn lex_plan_text(text: &str) -> Result<Vec<PlanTextToken>, ControlError> {
    if text.len() > MAX_PLAN_TEXT_BYTES {
        return invalid("text plan exceeds byte limit");
    }
    lex(text)
}

/// Parse one bounded scalar expression using the plan-language grammar.
pub fn parse_plan_expression(text: &str) -> Result<PlanExpr, ControlError> {
    let mut parser = Parser::new(lex_plan_text(text)?);
    let expr = parser.expr(0, 1)?;
    if parser.at != parser.tokens.len() {
        return parser.error("trailing tokens after expression");
    }
    Ok(expr)
}

/// Canonically format one scalar expression.
pub fn format_plan_expression(expr: &PlanExpr) -> Result<String, ControlError> {
    let mut text = String::new();
    format_expr(expr, &mut text, 1)?;
    if text.len() > MAX_PLAN_TEXT_BYTES {
        return invalid("formatted expression exceeds byte limit");
    }
    Ok(text)
}

/// Apply the common bounded-name contract used by all plan documents.
pub fn validate_plan_name(name: &str) -> Result<(), ControlError> {
    validate_name(name)
}

/// Canonically format a plan-language name, quoting it when required.
pub fn format_plan_name(name: &str) -> Result<String, ControlError> {
    format_name(name)
}

/// Parse the unsigned integer syntax shared by masks and bounded resources.
pub fn parse_plan_u64_literal(number: &str) -> Result<u64, ControlError> {
    parse_u64(number)
}

/// Parse the signed integer syntax shared by scalar and operation arguments.
pub fn parse_plan_i64_literal(number: &str) -> Result<i64, ControlError> {
    if let Some(magnitude) = number.strip_prefix('-') {
        parse_negative(magnitude)
    } else {
        parse_i64(number)
    }
}

/// Parse and lower a textual plan to the existing VM bytecode schema.
pub fn parse_and_lower_plan(text: &str) -> Result<PlanSpec, ControlError> {
    parse_expression_plan(text)?.lower()
}

/// Canonically format a typed expression plan.
pub fn format_expression_plan(plan: &ExpressionPlanSpec) -> Result<String, ControlError> {
    if plan.schema != PLAN_SCHEMA {
        return invalid("text plan has an unsupported schema");
    }
    validate_name(&plan.name)?;
    if let Some(scope) = &plan.scope {
        validate_name(&scope.field)?;
    }
    plan.clone().lower()?;

    let mut text = format!(
        "plan {} {{\n  role {};\n  output {};\n",
        quote(&plan.name)?,
        match plan.role {
            PlanRole::Diagnostic => "diagnostic",
            PlanRole::Ordering => "ordering",
        },
        match plan.output {
            PlanOutput::Predicate => "predicate",
            PlanOutput::Score => "score",
        }
    );
    if let Some(scope) = &plan.scope {
        text.push_str(&format!(
            "  scope {} 0x{:016x};\n",
            format_name(&scope.field)?,
            scope.mask
        ));
    }
    text.push_str("  expr ");
    format_expr(&plan.expr, &mut text, 1)?;
    text.push_str(";\n}\n");
    if text.len() > MAX_PLAN_TEXT_BYTES {
        return invalid("formatted plan exceeds byte limit");
    }
    Ok(text)
}

fn lex(text: &str) -> Result<Vec<Token>, ControlError> {
    let bytes = text.as_bytes();
    let mut out = Vec::new();
    let mut at = 0usize;
    while at < bytes.len() {
        match bytes[at] {
            byte if byte.is_ascii_whitespace() => at += 1,
            b'#' => {
                while at < bytes.len() && bytes[at] != b'\n' {
                    at += 1;
                }
            }
            b'"' => {
                let start = at;
                at += 1;
                let mut escaped = false;
                while at < bytes.len() {
                    let byte = bytes[at];
                    at += 1;
                    if escaped {
                        escaped = false;
                    } else if byte == b'\\' {
                        escaped = true;
                    } else if byte == b'"' {
                        break;
                    }
                }
                if at > bytes.len() || bytes[at - 1] != b'"' || escaped {
                    return invalid_at(start, "unterminated quoted string");
                }
                let value = serde_json::from_str(&text[start..at]).map_err(|_| {
                    ControlError::Invalid(format!("invalid string at byte {start}"))
                })?;
                push(&mut out, Kind::Quoted(value), start)?;
            }
            byte if byte.is_ascii_alphabetic() || byte == b'_' => {
                let start = at;
                at += 1;
                while at < bytes.len()
                    && (bytes[at].is_ascii_alphanumeric() || matches!(bytes[at], b'_' | b'.'))
                {
                    at += 1;
                }
                push(&mut out, Kind::Word(text[start..at].into()), start)?;
            }
            byte if byte.is_ascii_digit() => {
                let start = at;
                at += 1;
                while at < bytes.len() && (bytes[at].is_ascii_alphanumeric() || bytes[at] == b'_') {
                    at += 1;
                }
                push(&mut out, Kind::Number(text[start..at].into()), start)?;
            }
            b'!' if bytes.get(at + 1) == Some(&b'=') => double(&mut out, &mut at, Kind::Ne)?,
            b'=' if bytes.get(at + 1) == Some(&b'=') => double(&mut out, &mut at, Kind::Eq)?,
            b'<' if bytes.get(at + 1) == Some(&b'=') => double(&mut out, &mut at, Kind::Le)?,
            b'>' if bytes.get(at + 1) == Some(&b'=') => double(&mut out, &mut at, Kind::Ge)?,
            b'&' if bytes.get(at + 1) == Some(&b'&') => double(&mut out, &mut at, Kind::And)?,
            b'|' if bytes.get(at + 1) == Some(&b'|') => double(&mut out, &mut at, Kind::Or)?,
            b'{' => single(&mut out, &mut at, Kind::LBrace)?,
            b'}' => single(&mut out, &mut at, Kind::RBrace)?,
            b'(' => single(&mut out, &mut at, Kind::LParen)?,
            b')' => single(&mut out, &mut at, Kind::RParen)?,
            b',' => single(&mut out, &mut at, Kind::Comma)?,
            b';' => single(&mut out, &mut at, Kind::Semi)?,
            b'+' => single(&mut out, &mut at, Kind::Plus)?,
            b'-' => single(&mut out, &mut at, Kind::Minus)?,
            b'*' => single(&mut out, &mut at, Kind::Star)?,
            b'!' => single(&mut out, &mut at, Kind::Bang)?,
            b'=' => single(&mut out, &mut at, Kind::Assign)?,
            b'<' => single(&mut out, &mut at, Kind::Lt)?,
            b'>' => single(&mut out, &mut at, Kind::Gt)?,
            _ => return invalid_at(at, "unexpected character"),
        }
    }
    Ok(out)
}

fn push(out: &mut Vec<Token>, kind: Kind, offset: usize) -> Result<(), ControlError> {
    if out.len() == MAX_PLAN_TEXT_TOKENS {
        return invalid("text plan exceeds token limit");
    }
    out.push(Token { kind, offset });
    Ok(())
}

fn single(out: &mut Vec<Token>, at: &mut usize, kind: Kind) -> Result<(), ControlError> {
    let offset = *at;
    *at += 1;
    push(out, kind, offset)
}

fn double(out: &mut Vec<Token>, at: &mut usize, kind: Kind) -> Result<(), ControlError> {
    let offset = *at;
    *at += 2;
    push(out, kind, offset)
}

struct Parser {
    tokens: Vec<Token>,
    at: usize,
}

impl Parser {
    fn new(tokens: Vec<Token>) -> Self {
        Self { tokens, at: 0 }
    }

    fn parse_plan(mut self) -> Result<ExpressionPlanSpec, ControlError> {
        self.expect_word("plan")?;
        let name = self.name()?;
        validate_name(&name)?;
        self.expect(Kind::LBrace)?;
        let (mut role, mut output, mut scope, mut expr) = (None, None, None, None);
        while !self.consume(&Kind::RBrace) {
            match self.word()?.as_str() {
                "role" if role.is_none() => {
                    role = Some(match self.word()?.as_str() {
                        "diagnostic" => PlanRole::Diagnostic,
                        "ordering" => PlanRole::Ordering,
                        _ => return self.error("expected diagnostic or ordering role"),
                    });
                }
                "output" if output.is_none() => {
                    output = Some(match self.word()?.as_str() {
                        "predicate" => PlanOutput::Predicate,
                        "score" => PlanOutput::Score,
                        _ => return self.error("expected predicate or score output"),
                    });
                }
                "scope" if scope.is_none() => {
                    let field = self.name()?;
                    validate_name(&field)?;
                    scope = Some(PlanScope {
                        field,
                        mask: parse_u64(&self.number()?)?,
                    });
                }
                "expr" if expr.is_none() => expr = Some(self.expr(0, 1)?),
                "role" | "output" | "scope" | "expr" => {
                    return self.error("duplicate plan declaration");
                }
                _ => return self.error("unknown plan declaration"),
            }
            self.expect(Kind::Semi)?;
        }
        if self.at != self.tokens.len() {
            return self.error("trailing tokens after plan");
        }
        Ok(ExpressionPlanSpec {
            schema: PLAN_SCHEMA.into(),
            name,
            role: role.ok_or_else(|| ControlError::Invalid("plan omits role".into()))?,
            output: output.ok_or_else(|| ControlError::Invalid("plan omits output".into()))?,
            scope,
            expr: expr.ok_or_else(|| ControlError::Invalid("plan omits expr".into()))?,
        })
    }

    fn expr(&mut self, minimum: u8, depth: usize) -> Result<PlanExpr, ControlError> {
        if depth > MAX_PLAN_TEXT_DEPTH {
            return self.error("expression exceeds depth limit");
        }
        let mut left = self.prefix(depth)?;
        while let Some((binding, operator)) = self.infix() {
            if binding < minimum {
                break;
            }
            self.at += 1;
            let right = self.expr(binding + 1, depth + 1)?;
            left = binary(operator, left, right);
        }
        Ok(left)
    }

    fn prefix(&mut self, depth: usize) -> Result<PlanExpr, ControlError> {
        let token = self.take()?;
        match token.kind {
            Kind::Number(value) => Ok(PlanExpr::Const {
                value: parse_i64(&value)?,
            }),
            Kind::Minus => Ok(PlanExpr::Const {
                value: parse_negative(&self.number()?)?,
            }),
            Kind::Word(name) => {
                if self.consume(&Kind::LParen) {
                    self.call(&name, depth + 1)
                } else {
                    validate_name(&name)?;
                    Ok(PlanExpr::Field { name })
                }
            }
            Kind::Quoted(name) => {
                validate_name(&name)?;
                Ok(PlanExpr::Field { name })
            }
            Kind::Bang => Ok(PlanExpr::Not {
                arg: Box::new(self.expr(7, depth + 1)?),
            }),
            Kind::LParen => {
                let expr = self.expr(0, depth + 1)?;
                self.expect(Kind::RParen)?;
                Ok(expr)
            }
            _ => invalid_at(token.offset, "expected expression"),
        }
    }

    fn call(&mut self, name: &str, depth: usize) -> Result<PlanExpr, ControlError> {
        let first = self.expr(0, depth + 1)?;
        let expr = match name {
            "abs" => PlanExpr::Abs {
                arg: Box::new(first),
            },
            "popcount" => PlanExpr::PopCount {
                arg: Box::new(first),
            },
            "parity" => PlanExpr::Parity {
                arg: Box::new(first),
            },
            "min" | "max" | "mod" | "div" | "gcd" | "gaussian_norm" | "eisenstein_norm" => {
                self.expect(Kind::Comma)?;
                let second = self.expr(0, depth + 1)?;
                match name {
                    "min" => PlanExpr::Min {
                        left: Box::new(first),
                        right: Box::new(second),
                    },
                    "max" => PlanExpr::Max {
                        left: Box::new(first),
                        right: Box::new(second),
                    },
                    "mod" => PlanExpr::Mod {
                        left: Box::new(first),
                        right: Box::new(second),
                    },
                    "div" => PlanExpr::Div {
                        left: Box::new(first),
                        right: Box::new(second),
                    },
                    "gcd" => PlanExpr::Gcd {
                        left: Box::new(first),
                        right: Box::new(second),
                    },
                    "gaussian_norm" => PlanExpr::GaussianNorm {
                        left: Box::new(first),
                        right: Box::new(second),
                    },
                    "eisenstein_norm" => PlanExpr::EisensteinNorm {
                        left: Box::new(first),
                        right: Box::new(second),
                    },
                    _ => unreachable!(),
                }
            }
            "legendre" => {
                self.expect(Kind::Comma)?;
                let modulus = self.expr(0, depth + 1)?;
                let PlanExpr::Const { value } = modulus else {
                    return self.error("Legendre modulus must be an integer literal");
                };
                let modulus = u16::try_from(value)
                    .map_err(|_| ControlError::Invalid("Legendre modulus exceeds u16".into()))?;
                PlanExpr::Legendre {
                    arg: Box::new(first),
                    modulus,
                }
            }
            "select" => {
                self.expect(Kind::Comma)?;
                let then_value = self.expr(0, depth + 1)?;
                self.expect(Kind::Comma)?;
                let else_value = self.expr(0, depth + 1)?;
                PlanExpr::Select {
                    condition: Box::new(first),
                    then_value: Box::new(then_value),
                    else_value: Box::new(else_value),
                }
            }
            _ => return self.error("unknown expression function"),
        };
        self.expect(Kind::RParen)?;
        Ok(expr)
    }

    fn infix(&self) -> Option<(u8, Binary)> {
        Some(match self.tokens.get(self.at)?.kind {
            Kind::Or => (1, Binary::Or),
            Kind::And => (2, Binary::And),
            Kind::Eq => (3, Binary::Eq),
            Kind::Ne => (3, Binary::Ne),
            Kind::Lt => (4, Binary::Lt),
            Kind::Le => (4, Binary::Le),
            Kind::Gt => (4, Binary::Gt),
            Kind::Ge => (4, Binary::Ge),
            Kind::Plus => (5, Binary::Add),
            Kind::Minus => (5, Binary::Sub),
            Kind::Star => (6, Binary::Mul),
            _ => return None,
        })
    }

    fn take(&mut self) -> Result<Token, ControlError> {
        let token = self
            .tokens
            .get(self.at)
            .cloned()
            .ok_or_else(|| ControlError::Invalid("unexpected end of plan".into()))?;
        self.at += 1;
        Ok(token)
    }

    fn name(&mut self) -> Result<String, ControlError> {
        let token = self.take()?;
        match token.kind {
            Kind::Word(value) | Kind::Quoted(value) => Ok(value),
            _ => invalid_at(token.offset, "expected name"),
        }
    }

    fn word(&mut self) -> Result<String, ControlError> {
        let token = self.take()?;
        match token.kind {
            Kind::Word(value) => Ok(value),
            _ => invalid_at(token.offset, "expected word"),
        }
    }

    fn number(&mut self) -> Result<String, ControlError> {
        let token = self.take()?;
        match token.kind {
            Kind::Number(value) => Ok(value),
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

    fn expect(&mut self, expected: Kind) -> Result<(), ControlError> {
        if self.consume(&expected) {
            Ok(())
        } else {
            self.error("unexpected token")
        }
    }

    fn consume(&mut self, expected: &Kind) -> bool {
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

#[derive(Clone, Copy)]
enum Binary {
    Add,
    Sub,
    Mul,
    Eq,
    Ne,
    Lt,
    Le,
    Gt,
    Ge,
    And,
    Or,
}

fn binary(op: Binary, left: PlanExpr, right: PlanExpr) -> PlanExpr {
    let left = Box::new(left);
    let right = Box::new(right);
    match op {
        Binary::Add => PlanExpr::Add { left, right },
        Binary::Sub => PlanExpr::Sub { left, right },
        Binary::Mul => PlanExpr::Mul { left, right },
        Binary::Eq => PlanExpr::Eq { left, right },
        Binary::Ne => PlanExpr::Ne { left, right },
        Binary::Lt => PlanExpr::Lt { left, right },
        Binary::Le => PlanExpr::Le { left, right },
        Binary::Gt => PlanExpr::Gt { left, right },
        Binary::Ge => PlanExpr::Ge { left, right },
        Binary::And => PlanExpr::And { left, right },
        Binary::Or => PlanExpr::Or { left, right },
    }
}

fn format_expr(expr: &PlanExpr, out: &mut String, depth: usize) -> Result<(), ControlError> {
    if depth > MAX_PLAN_TEXT_DEPTH {
        return invalid("expression exceeds depth limit");
    }
    match expr {
        PlanExpr::Field { name } => out.push_str(&format_name(name)?),
        PlanExpr::Const { value } => out.push_str(&value.to_string()),
        PlanExpr::Not { arg } => {
            out.push_str("!(");
            format_expr(arg, out, depth + 1)?;
            out.push(')');
        }
        PlanExpr::Abs { arg } => format_call("abs", &[arg], out, depth)?,
        PlanExpr::PopCount { arg } => format_call("popcount", &[arg], out, depth)?,
        PlanExpr::Parity { arg } => format_call("parity", &[arg], out, depth)?,
        PlanExpr::Legendre { arg, modulus } => {
            out.push_str("legendre(");
            format_expr(arg, out, depth + 1)?;
            out.push_str(", ");
            out.push_str(&modulus.to_string());
            out.push(')');
        }
        PlanExpr::Min { left, right } => format_call("min", &[left, right], out, depth)?,
        PlanExpr::Max { left, right } => format_call("max", &[left, right], out, depth)?,
        PlanExpr::Mod { left, right } => format_call("mod", &[left, right], out, depth)?,
        PlanExpr::Div { left, right } => format_call("div", &[left, right], out, depth)?,
        PlanExpr::Gcd { left, right } => format_call("gcd", &[left, right], out, depth)?,
        PlanExpr::GaussianNorm { left, right } => {
            format_call("gaussian_norm", &[left, right], out, depth)?
        }
        PlanExpr::EisensteinNorm { left, right } => {
            format_call("eisenstein_norm", &[left, right], out, depth)?
        }
        PlanExpr::Select {
            condition,
            then_value,
            else_value,
        } => format_call("select", &[condition, then_value, else_value], out, depth)?,
        binary => {
            let (left, right, symbol) = binary_parts(binary)
                .ok_or_else(|| ControlError::Invalid("unsupported expression".into()))?;
            out.push('(');
            format_expr(left, out, depth + 1)?;
            out.push(' ');
            out.push_str(symbol);
            out.push(' ');
            format_expr(right, out, depth + 1)?;
            out.push(')');
        }
    }
    Ok(())
}

fn format_call(
    name: &str,
    args: &[&PlanExpr],
    out: &mut String,
    depth: usize,
) -> Result<(), ControlError> {
    out.push_str(name);
    out.push('(');
    for (index, arg) in args.iter().enumerate() {
        if index != 0 {
            out.push_str(", ");
        }
        format_expr(arg, out, depth + 1)?;
    }
    out.push(')');
    Ok(())
}

fn binary_parts(expr: &PlanExpr) -> Option<(&PlanExpr, &PlanExpr, &'static str)> {
    match expr {
        PlanExpr::Add { left, right } => Some((left, right, "+")),
        PlanExpr::Sub { left, right } => Some((left, right, "-")),
        PlanExpr::Mul { left, right } => Some((left, right, "*")),
        PlanExpr::Eq { left, right } => Some((left, right, "==")),
        PlanExpr::Ne { left, right } => Some((left, right, "!=")),
        PlanExpr::Lt { left, right } => Some((left, right, "<")),
        PlanExpr::Le { left, right } => Some((left, right, "<=")),
        PlanExpr::Gt { left, right } => Some((left, right, ">")),
        PlanExpr::Ge { left, right } => Some((left, right, ">=")),
        PlanExpr::And { left, right } => Some((left, right, "&&")),
        PlanExpr::Or { left, right } => Some((left, right, "||")),
        _ => None,
    }
}

fn validate_name(name: &str) -> Result<(), ControlError> {
    if name.is_empty() || name.len() > MAX_NAME_BYTES || name.contains(['\n', '\r', '\0']) {
        return invalid("name is empty, too long, or contains a control character");
    }
    Ok(())
}

fn format_name(name: &str) -> Result<String, ControlError> {
    validate_name(name)?;
    if identifier(name) {
        Ok(name.into())
    } else {
        quote(name)
    }
}

fn identifier(name: &str) -> bool {
    let mut bytes = name.bytes();
    bytes
        .next()
        .is_some_and(|byte| byte.is_ascii_alphabetic() || byte == b'_')
        && bytes.all(|byte| byte.is_ascii_alphanumeric() || matches!(byte, b'_' | b'.'))
}

fn quote(value: &str) -> Result<String, ControlError> {
    serde_json::to_string(value).map_err(ControlError::Json)
}

fn parse_i64(number: &str) -> Result<i64, ControlError> {
    let digits = number.replace('_', "");
    if let Some(hex) = digits.strip_prefix("0x") {
        i64::from_str_radix(hex, 16).map_err(|_| ControlError::Invalid("invalid integer".into()))
    } else {
        digits
            .parse()
            .map_err(|_| ControlError::Invalid("invalid integer".into()))
    }
}

fn parse_negative(number: &str) -> Result<i64, ControlError> {
    let magnitude = parse_u64(number)?;
    if magnitude == 1_u64 << 63 {
        Ok(i64::MIN)
    } else {
        i64::try_from(magnitude)
            .map(|value| -value)
            .map_err(|_| ControlError::Invalid("invalid negative integer".into()))
    }
}

fn parse_u64(number: &str) -> Result<u64, ControlError> {
    let digits = number.replace('_', "");
    if let Some(hex) = digits.strip_prefix("0x") {
        u64::from_str_radix(hex, 16).map_err(|_| ControlError::Invalid("invalid integer".into()))
    } else {
        digits
            .parse()
            .map_err(|_| ControlError::Invalid("invalid integer".into()))
    }
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
plan "rigid-order" {
  role ordering;
  output score;
  scope root.kind 0x0000000000000005;
  expr select((rigid == 1) && !(debt > 3), max(score * 4, abs(slack)), -7);
}
"#;

    #[test]
    fn text_round_trip_is_canonical_and_lowering_stable() {
        let parsed = parse_expression_plan(TEXT).unwrap();
        let formatted = format_expression_plan(&parsed).unwrap();
        let reparsed = parse_expression_plan(&formatted).unwrap();
        assert_eq!(
            serde_json::to_value(&parsed).unwrap(),
            serde_json::to_value(&reparsed).unwrap()
        );
        assert_eq!(
            serde_json::to_vec(&parsed.clone().lower().unwrap()).unwrap(),
            serde_json::to_vec(&reparsed.lower().unwrap()).unwrap()
        );
        assert_eq!(format_expression_plan(&parsed).unwrap(), formatted);
    }

    #[test]
    fn number_theoretic_functions_round_trip_through_text() {
        let source = r#"
plan arithmetic {
  role diagnostic;
  output predicate;
  expr legendre(mod(eisenstein_norm(x, y), 7), 7) == parity(gcd(x, y));
}
"#;
        let parsed = parse_expression_plan(source).unwrap();
        let formatted = format_expression_plan(&parsed).unwrap();
        let reparsed = parse_expression_plan(&formatted).unwrap();
        assert_eq!(
            serde_json::to_value(parsed).unwrap(),
            serde_json::to_value(reparsed).unwrap()
        );
    }

    #[test]
    fn text_and_json_lower_to_identical_bytecode() {
        let text = parse_expression_plan(TEXT).unwrap();
        let decoded: ExpressionPlanSpec =
            serde_json::from_str(&serde_json::to_string(&text).unwrap()).unwrap();
        assert_eq!(
            serde_json::to_vec(&text.lower().unwrap()).unwrap(),
            serde_json::to_vec(&decoded.lower().unwrap()).unwrap()
        );
    }

    #[test]
    fn malformed_unbounded_and_duplicate_documents_fail_closed() {
        assert!(parse_expression_plan("plan x { role diagnostic; }").is_err());
        assert!(parse_expression_plan(
            "plan x { role diagnostic; role ordering; output predicate; expr a == 1; }"
        )
        .is_err());
        assert!(parse_expression_plan(
            "plan x { role diagnostic; output predicate; expr unknown(a); }"
        )
        .is_err());
        assert!(parse_expression_plan(&"x".repeat(MAX_PLAN_TEXT_BYTES + 1)).is_err());
    }

    #[test]
    fn integer_edges_and_quoted_fields_round_trip() {
        let text = r#"plan edge { role diagnostic; output score; expr min("field-name", -9223372036854775808); }"#;
        let parsed = parse_expression_plan(text).unwrap();
        let formatted = format_expression_plan(&parsed).unwrap();
        assert_eq!(
            serde_json::to_value(parsed).unwrap(),
            serde_json::to_value(parse_expression_plan(&formatted).unwrap()).unwrap()
        );
    }

    #[test]
    fn shared_lexer_and_expression_fragments_preserve_scalar_semantics() {
        let source = r#"select((rigid == 1) && !(debt > 3), "field-name", -7)"#;
        let tokens = lex_plan_text(source).unwrap();
        assert!(tokens
            .iter()
            .any(|token| token.kind == PlanTextTokenKind::And));
        let parsed = parse_plan_expression(source).unwrap();
        let formatted = format_plan_expression(&parsed).unwrap();
        let reparsed = parse_plan_expression(&formatted).unwrap();
        assert_eq!(
            serde_json::to_value(parsed).unwrap(),
            serde_json::to_value(reparsed).unwrap()
        );
        assert_eq!(format_plan_name("field-name").unwrap(), r#""field-name""#);
        assert_eq!(parse_plan_u64_literal("0xffff_0000").unwrap(), 0xffff_0000);
        assert_eq!(parse_plan_i64_literal("-0x8000").unwrap(), -0x8000);
        let arguments = lex_plan_text("affine(rank=2, metric=max_overlap)").unwrap();
        assert_eq!(
            arguments
                .iter()
                .filter(|token| token.kind == PlanTextTokenKind::Assign)
                .count(),
            2
        );
    }
}
