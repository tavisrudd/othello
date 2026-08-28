//! Adapters for deterministic finite automata.
//!
//! The explicit MATA adapter turns language equivalence into observational
//! equivalence: accepting status is the observation and alphabet symbols are
//! total unary contexts. Partial transition functions are completed with one
//! rejecting sink before compilation.

use crate::observational::{FinitePresentation, GeneratorSpec, ObservationalError};
use rustc_hash::FxHashMap;
use std::io::BufRead;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum ExplicitMataError {
    #[error("explicit MATA input could not be read")]
    Io(#[from] std::io::Error),
    #[error("line {line}: {message}")]
    Format { line: usize, message: &'static str },
    #[error("the explicit automaton must have exactly one initial state")]
    Initial,
    #[error("the explicit automaton has no states")]
    NoStates,
    #[error("the explicit automaton is nondeterministic")]
    Nondeterministic,
    #[error("the explicit automaton is too large")]
    Overflow,
    #[error(transparent)]
    Presentation(#[from] ObservationalError),
}

/// A total deterministic presentation imported from `@NFA-explicit`.
#[derive(Clone, Debug)]
pub struct ExplicitMataDfa {
    presentation: FinitePresentation,
    initial_state: u32,
    original_state_count: u32,
    added_rejecting_sink: bool,
    symbols: Box<[Box<str>]>,
}

impl ExplicitMataDfa {
    /// Parse the explicit format emitted by MATA's `Nfa::print_to_mata`.
    pub fn parse(reader: impl BufRead) -> Result<Self, ExplicitMataError> {
        let mut header_seen = false;
        let mut initial = None;
        let mut final_states = Vec::new();
        let mut transitions = Vec::new();
        let mut symbol_ids = FxHashMap::<String, u32>::default();
        let mut symbols = Vec::<Box<str>>::new();
        let mut maximum_state = None;

        for (line_index, line) in reader.lines().enumerate() {
            let line_number = line_index + 1;
            let line = line?;
            let line = line.trim();
            if line.is_empty() || line.starts_with('#') {
                continue;
            }
            if line.starts_with('@') {
                if header_seen || line != "@NFA-explicit" {
                    return Err(format_error(
                        line_number,
                        "expected one @NFA-explicit section",
                    ));
                }
                header_seen = true;
                continue;
            }
            if !header_seen {
                return Err(format_error(line_number, "content precedes @NFA-explicit"));
            }
            if line.starts_with("%Alphabet") {
                continue;
            }
            if let Some(states) = line.strip_prefix("%Initial") {
                if initial.is_some() {
                    return Err(ExplicitMataError::Initial);
                }
                let mut words = states.split_whitespace();
                let state = words.next().ok_or(ExplicitMataError::Initial)?;
                if words.next().is_some() {
                    return Err(ExplicitMataError::Initial);
                }
                let state = parse_state(state, line_number)?;
                update_maximum(&mut maximum_state, state);
                initial = Some(state);
                continue;
            }
            if let Some(states) = line.strip_prefix("%Final") {
                for state in states.split_whitespace() {
                    let state = parse_state(state, line_number)?;
                    update_maximum(&mut maximum_state, state);
                    final_states.push(state);
                }
                continue;
            }
            if line.starts_with('%') {
                return Err(format_error(line_number, "unsupported directive"));
            }

            let mut words = line.split_whitespace();
            let source = words
                .next()
                .ok_or_else(|| format_error(line_number, "missing transition source"))?;
            let symbol = words
                .next()
                .ok_or_else(|| format_error(line_number, "missing transition symbol"))?;
            let target = words
                .next()
                .ok_or_else(|| format_error(line_number, "missing transition target"))?;
            if words.next().is_some() {
                return Err(format_error(
                    line_number,
                    "transition has more than three fields",
                ));
            }
            let source = parse_state(source, line_number)?;
            let target = parse_state(target, line_number)?;
            update_maximum(&mut maximum_state, source);
            update_maximum(&mut maximum_state, target);
            let symbol = if let Some(&symbol) = symbol_ids.get(symbol) {
                symbol
            } else {
                let symbol_id =
                    u32::try_from(symbols.len()).map_err(|_| ExplicitMataError::Overflow)?;
                let owned: Box<str> = symbol.into();
                symbol_ids.insert(owned.to_string(), symbol_id);
                symbols.push(owned);
                symbol_id
            };
            transitions.push((source, symbol, target));
        }

        let initial_state = initial.ok_or(ExplicitMataError::Initial)?;
        let original_state_count = maximum_state
            .ok_or(ExplicitMataError::NoStates)?
            .checked_add(1)
            .ok_or(ExplicitMataError::Overflow)?;
        let symbol_count = symbols.len();
        let partial_len = (original_state_count as usize)
            .checked_mul(symbol_count)
            .ok_or(ExplicitMataError::Overflow)?;
        let mut partial = vec![u32::MAX; partial_len];
        for (source, symbol, target) in transitions {
            let slot = symbol as usize * original_state_count as usize + source as usize;
            let previous = partial[slot];
            if previous != u32::MAX && previous != target {
                return Err(ExplicitMataError::Nondeterministic);
            }
            partial[slot] = target;
        }
        let added_rejecting_sink = partial.contains(&u32::MAX);
        let state_count = original_state_count
            .checked_add(u32::from(added_rejecting_sink))
            .ok_or(ExplicitMataError::Overflow)?;
        let dense_len = (state_count as usize)
            .checked_mul(symbol_count)
            .ok_or(ExplicitMataError::Overflow)?;
        let mut dense = vec![original_state_count; dense_len];
        for symbol in 0..symbol_count {
            let partial_start = symbol * original_state_count as usize;
            let dense_start = symbol * state_count as usize;
            for state in 0..original_state_count as usize {
                let target = partial[partial_start + state];
                if target != u32::MAX {
                    dense[dense_start + state] = target;
                }
            }
        }
        if !added_rejecting_sink {
            debug_assert!(!dense.contains(&original_state_count));
        }

        let mut observations = vec![0_u32; state_count as usize];
        for state in final_states {
            observations[state as usize] = 1;
        }
        let generators =
            dense
                .chunks_exact(state_count as usize)
                .map(|transitions| GeneratorSpec {
                    source_sort: 0,
                    target_sort: 0,
                    transitions: transitions.into(),
                });
        let presentation = FinitePresentation::new([state_count], observations, generators)?;
        Ok(Self {
            presentation,
            initial_state,
            original_state_count,
            added_rejecting_sink,
            symbols: symbols.into_boxed_slice(),
        })
    }

    pub fn presentation(&self) -> &FinitePresentation {
        &self.presentation
    }

    pub fn initial_state(&self) -> u32 {
        self.initial_state
    }

    pub fn original_state_count(&self) -> u32 {
        self.original_state_count
    }

    pub fn state_count(&self) -> u32 {
        self.presentation.sorts()[0].len
    }

    pub fn added_rejecting_sink(&self) -> bool {
        self.added_rejecting_sink
    }

    pub fn symbols(&self) -> &[Box<str>] {
        &self.symbols
    }
}

fn format_error(line: usize, message: &'static str) -> ExplicitMataError {
    ExplicitMataError::Format { line, message }
}

fn parse_state(word: &str, line: usize) -> Result<u32, ExplicitMataError> {
    word.strip_prefix('q')
        .and_then(|digits| digits.parse().ok())
        .ok_or_else(|| format_error(line, "state must have form q<unsigned integer>"))
}

fn update_maximum(maximum: &mut Option<u32>, state: u32) {
    *maximum = Some(maximum.map_or(state, |current| current.max(state)));
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::observational::{compile_observational_with_policy, CertificatePolicy};
    use std::io::Cursor;

    #[test]
    fn explicit_partial_dfa_compiles_to_myhill_nerode_quotient() {
        let source = b"@NFA-explicit\n%Alphabet-auto\n%Initial q0\n%Final q2\nq0 a q1\nq1 a q2\nq2 a q2\nq0 b q0\nq1 b q0\n";
        let dfa = ExplicitMataDfa::parse(Cursor::new(source)).unwrap();
        assert_eq!(dfa.original_state_count(), 3);
        assert_eq!(dfa.state_count(), 4);
        assert!(dfa.added_rejecting_sink());
        assert_eq!(dfa.symbols().len(), 2);
        let compiled = compile_observational_with_policy(
            dfa.presentation(),
            CertificatePolicy::SplitTranscript,
        )
        .unwrap();
        assert_eq!(compiled.class_ranges()[0].len, 4);
    }

    #[test]
    fn explicit_parser_rejects_nondeterminism() {
        let source = b"@NFA-explicit\n%Initial q0\nq0 a q0\nq0 a q1\n";
        assert!(matches!(
            ExplicitMataDfa::parse(Cursor::new(source)),
            Err(ExplicitMataError::Nondeterministic)
        ));
    }
}
