//! Persistent JSON-RPC transport for exact Ergodis primitives.
//!
//! The transport is method-agnostic. New primitives add a typed handler and
//! one entry to `rpc_methods!`; framing, limits, discovery, errors, caching,
//! and clients do not change.

use std::io::{self, BufRead, Write};

use anyhow::Result;
use num_bigint::BigInt;
use num_traits::ToPrimitive;
use serde::de::DeserializeOwned;
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};

use crate::PrimeQuadraticCharacter;

const JSON_RPC_VERSION: &str = "2.0";

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct RpcLimits {
    pub max_request_bytes: usize,
    pub max_character_modulus: u32,
}

impl Default for RpcLimits {
    fn default() -> Self {
        Self {
            max_request_bytes: 8 * 1024 * 1024,
            max_character_modulus: 10_000_000,
        }
    }
}

#[derive(Deserialize)]
struct RpcRequest {
    jsonrpc: String,
    #[serde(default)]
    id: Option<Value>,
    method: String,
    #[serde(default)]
    params: Value,
}

#[derive(Serialize)]
struct RpcSuccess<'a> {
    jsonrpc: &'static str,
    id: &'a Value,
    result: Value,
}

#[derive(Serialize)]
struct RpcFailure<'a> {
    jsonrpc: &'static str,
    id: &'a Value,
    error: RpcErrorBody,
}

#[derive(Debug, Serialize)]
struct RpcErrorBody {
    code: i32,
    message: String,
}

impl RpcErrorBody {
    fn parse(message: impl Into<String>) -> Self {
        Self {
            code: -32700,
            message: message.into(),
        }
    }

    fn invalid_request(message: impl Into<String>) -> Self {
        Self {
            code: -32600,
            message: message.into(),
        }
    }

    fn method_not_found(method: &str) -> Self {
        Self {
            code: -32601,
            message: format!("method {method:?} is not registered"),
        }
    }

    fn invalid_params(message: impl Into<String>) -> Self {
        Self {
            code: -32602,
            message: message.into(),
        }
    }
}

#[derive(Debug, PartialEq, Eq)]
enum Frame {
    Eof,
    Line,
    TooLarge,
}

struct RpcContext {
    limits: RpcLimits,
    cached_character: Option<PrimeQuadraticCharacter>,
}

#[derive(Deserialize)]
struct CharacterSumParams {
    modulus: u32,
    queries: Vec<CharacterQuery>,
}

#[derive(Deserialize)]
struct CharacterQuery {
    name: String,
    coefficients: Vec<RpcInteger>,
    #[serde(default)]
    linear_twist: Option<[RpcInteger; 2]>,
}

#[derive(Deserialize)]
#[serde(untagged)]
enum RpcInteger {
    Signed(i64),
    Unsigned(u64),
    Decimal(String),
    Extended {
        #[serde(rename = "$integer")]
        decimal: String,
    },
}

fn decode_params<T: DeserializeOwned>(params: Value) -> Result<T, RpcErrorBody> {
    serde_json::from_value(params).map_err(|error| RpcErrorBody::invalid_params(error.to_string()))
}

fn reduce_integer(value: &RpcInteger, modulus: u32) -> Result<u32, RpcErrorBody> {
    let integer = match value {
        RpcInteger::Signed(value) => BigInt::from(*value),
        RpcInteger::Unsigned(value) => BigInt::from(*value),
        RpcInteger::Decimal(value) | RpcInteger::Extended { decimal: value } => {
            BigInt::parse_bytes(value.as_bytes(), 10)
                .ok_or_else(|| RpcErrorBody::invalid_params(format!("invalid integer {value:?}")))?
        }
    };
    let modulus = BigInt::from(modulus);
    let mut reduced = integer % &modulus;
    if reduced < BigInt::from(0_u8) {
        reduced += &modulus;
    }
    reduced
        .to_u32()
        .ok_or_else(|| RpcErrorBody::invalid_params("reduced coefficient does not fit u32"))
}

fn character_sum_census(context: &mut RpcContext, params: Value) -> Result<Value, RpcErrorBody> {
    let params: CharacterSumParams = decode_params(params)?;
    if params.modulus > context.limits.max_character_modulus {
        return Err(RpcErrorBody::invalid_params(format!(
            "modulus exceeds configured limit {}",
            context.limits.max_character_modulus
        )));
    }
    if context
        .cached_character
        .as_ref()
        .map(PrimeQuadraticCharacter::modulus)
        != Some(params.modulus)
    {
        context.cached_character = Some(
            PrimeQuadraticCharacter::new(params.modulus)
                .map_err(|error| RpcErrorBody::invalid_params(error.to_string()))?,
        );
    }
    let character = context.cached_character.as_ref().unwrap();
    let mut answers = Vec::with_capacity(params.queries.len());
    for query in params.queries {
        let coefficients = query
            .coefficients
            .iter()
            .map(|value| reduce_integer(value, params.modulus))
            .collect::<Result<Vec<_>, _>>()?;
        let census = if let Some([intercept, slope]) = query.linear_twist {
            character
                .linear_twist_polynomial_census_reduced(
                    0..params.modulus,
                    &coefficients,
                    reduce_integer(&intercept, params.modulus)?,
                    reduce_integer(&slope, params.modulus)?,
                )
                .map_err(|error| RpcErrorBody::invalid_params(error.to_string()))?
        } else {
            character
                .polynomial_census_reduced(&coefficients)
                .map_err(|error| RpcErrorBody::invalid_params(error.to_string()))?
        };
        answers.push(json!({
            "name": query.name,
            "positive": census.positive(),
            "negative": census.negative(),
            "zero": census.zero(),
            "sum": census.sum(),
        }));
    }
    Ok(json!({"modulus": params.modulus, "queries": answers}))
}

macro_rules! rpc_methods {
    ($($name:literal => $handler:path),+ $(,)?) => {
        const REGISTERED_METHODS: &[&str] = &["rpc.discover", $($name),+];

        fn dispatch(
            context: &mut RpcContext,
            method: &str,
            params: Value,
        ) -> Result<Value, RpcErrorBody> {
            match method {
                "rpc.discover" => Ok(json!({
                    "transport": "ndjson",
                    "jsonrpc": JSON_RPC_VERSION,
                    "methods": REGISTERED_METHODS,
                    "large_integer_encoding": {"$integer": "decimal string"},
                    "limits": {
                        "max_request_bytes": context.limits.max_request_bytes,
                        "max_character_modulus": context.limits.max_character_modulus,
                    },
                })),
                $($name => $handler(context, params),)+
                _ => Err(RpcErrorBody::method_not_found(method)),
            }
        }
    };
}

rpc_methods! {
    "character_sum.census" => character_sum_census,
}

fn read_bounded_line(
    input: &mut impl BufRead,
    buffer: &mut Vec<u8>,
    maximum: usize,
) -> io::Result<Frame> {
    buffer.clear();
    let mut overflow = false;
    loop {
        let available = input.fill_buf()?;
        if available.is_empty() {
            return Ok(if overflow {
                Frame::TooLarge
            } else if buffer.is_empty() {
                Frame::Eof
            } else {
                Frame::Line
            });
        }
        let newline = available.iter().position(|&byte| byte == b'\n');
        let consumed = newline.map_or(available.len(), |position| position + 1);
        if !overflow {
            if buffer.len() + consumed <= maximum {
                buffer.extend_from_slice(&available[..consumed]);
            } else {
                overflow = true;
            }
        }
        input.consume(consumed);
        if newline.is_some() {
            return Ok(if overflow {
                Frame::TooLarge
            } else {
                Frame::Line
            });
        }
    }
}

fn write_response(output: &mut impl Write, value: &impl Serialize) -> Result<()> {
    serde_json::to_writer(&mut *output, value)?;
    output.write_all(b"\n")?;
    output.flush()?;
    Ok(())
}

/// Serve newline-framed JSON-RPC requests until input reaches EOF.
pub fn serve_jsonl(
    mut input: impl BufRead,
    mut output: impl Write,
    limits: RpcLimits,
) -> Result<()> {
    let mut context = RpcContext {
        limits,
        cached_character: None,
    };
    let mut line = Vec::with_capacity(4096);
    loop {
        match read_bounded_line(&mut input, &mut line, limits.max_request_bytes)? {
            Frame::Eof => break,
            Frame::TooLarge => {
                write_response(
                    &mut output,
                    &RpcFailure {
                        jsonrpc: JSON_RPC_VERSION,
                        id: &Value::Null,
                        error: RpcErrorBody::invalid_request(format!(
                            "request exceeds {} bytes",
                            limits.max_request_bytes
                        )),
                    },
                )?;
                continue;
            }
            Frame::Line => {}
        }
        if line.iter().all(u8::is_ascii_whitespace) {
            continue;
        }
        let request: RpcRequest = match serde_json::from_slice(&line) {
            Ok(request) => request,
            Err(error) => {
                let rpc_error = if error.is_syntax() || error.is_eof() {
                    RpcErrorBody::parse(error.to_string())
                } else {
                    RpcErrorBody::invalid_request(error.to_string())
                };
                write_response(
                    &mut output,
                    &RpcFailure {
                        jsonrpc: JSON_RPC_VERSION,
                        id: &Value::Null,
                        error: rpc_error,
                    },
                )?;
                continue;
            }
        };
        let response = if request.jsonrpc != JSON_RPC_VERSION {
            Err(RpcErrorBody::invalid_request("jsonrpc must be \"2.0\""))
        } else {
            dispatch(&mut context, &request.method, request.params)
        };
        let Some(id) = &request.id else {
            continue;
        };
        match response {
            Ok(result) => write_response(
                &mut output,
                &RpcSuccess {
                    jsonrpc: JSON_RPC_VERSION,
                    id,
                    result,
                },
            )?,
            Err(error) => write_response(
                &mut output,
                &RpcFailure {
                    jsonrpc: JSON_RPC_VERSION,
                    id,
                    error,
                },
            )?,
        }
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use std::io::Cursor;

    use super::*;

    #[test]
    fn bounded_reader_drains_an_oversized_frame_and_recovers() {
        let mut input = Cursor::new(b"short\n123456\nnext\n");
        let mut line = Vec::new();
        assert_eq!(
            read_bounded_line(&mut input, &mut line, 6).unwrap(),
            Frame::Line
        );
        assert_eq!(&line, b"short\n");
        assert_eq!(
            read_bounded_line(&mut input, &mut line, 6).unwrap(),
            Frame::TooLarge
        );
        assert_eq!(
            read_bounded_line(&mut input, &mut line, 6).unwrap(),
            Frame::Line
        );
        assert_eq!(&line, b"next\n");
        assert_eq!(
            read_bounded_line(&mut input, &mut line, 6).unwrap(),
            Frame::Eof
        );
    }
}
