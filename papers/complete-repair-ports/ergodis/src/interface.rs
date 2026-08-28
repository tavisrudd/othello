//! Domain-independent compilation boundary for exact finite interfaces.
//!
//! An adapter enumerates typed internal states, their observable responses,
//! and every admissible one-hole context.  The resulting presentation can be
//! minimized by [`crate::compile_observational`].  Consequently, two states
//! share a quotient class exactly when no well-typed word of supplied
//! contexts distinguishes their observations.

use crate::observational::{
    CompiledObservation, FinitePresentation, GeneratorSpec, ObservationalError,
};
use thiserror::Error;

/// A finite, typed, deterministic semantics exposed to contextual compilation.
///
/// State IDs are contiguous globally: the states of sort zero come first,
/// followed by the states of sort one, and so on. `transition` receives a
/// global state ID and must return a global state ID in the context's target
/// sort. Adapter methods are called only during cold compilation.
pub trait FiniteInterfaceAdapter {
    type Error;

    fn sort_count(&self) -> u32;
    fn sort_len(&self, sort: u32) -> Result<u32, Self::Error>;
    fn observation(&self, state: u32) -> Result<u32, Self::Error>;
    fn context_count(&self) -> u32;
    fn context_sorts(&self, context: u32) -> Result<(u32, u32), Self::Error>;
    fn transition(&self, context: u32, state: u32) -> Result<u32, Self::Error>;
}

/// Optional witness reconstruction for a finite-interface adapter.
pub trait FiniteInterfaceWitness: FiniteInterfaceAdapter {
    type Witness;

    fn lift_state(&self, state: u32) -> Result<Self::Witness, Self::Error>;
}

#[derive(Debug, Error)]
pub enum InterfaceCompileError<E> {
    #[error("finite-interface adapter failed: {0}")]
    Adapter(E),
    #[error(transparent)]
    Presentation(#[from] ObservationalError),
    #[error("a finite-interface count or offset exceeds compact storage")]
    Overflow,
}

/// Materialize a validated finite presentation with exactly-sized buffers.
pub fn present_finite_interface<A: FiniteInterfaceAdapter>(
    adapter: &A,
) -> Result<FinitePresentation, InterfaceCompileError<A::Error>> {
    let sort_count = adapter.sort_count();
    let mut sort_lengths = Vec::with_capacity(sort_count as usize);
    let mut state_count = 0_u32;
    for sort in 0..sort_count {
        let len = adapter
            .sort_len(sort)
            .map_err(InterfaceCompileError::Adapter)?;
        state_count = state_count
            .checked_add(len)
            .ok_or(InterfaceCompileError::Overflow)?;
        sort_lengths.push(len);
    }

    let mut observations = Vec::with_capacity(state_count as usize);
    for state in 0..state_count {
        observations.push(
            adapter
                .observation(state)
                .map_err(InterfaceCompileError::Adapter)?,
        );
    }

    let context_count = adapter.context_count();
    let mut contexts = Vec::with_capacity(context_count as usize);
    let mut sort_starts = Vec::with_capacity(sort_lengths.len());
    let mut start = 0_u32;
    for &len in &sort_lengths {
        sort_starts.push(start);
        start = start
            .checked_add(len)
            .ok_or(InterfaceCompileError::Overflow)?;
    }
    for context in 0..context_count {
        let (source_sort, target_sort) = adapter
            .context_sorts(context)
            .map_err(InterfaceCompileError::Adapter)?;
        let source_len = sort_lengths.get(source_sort as usize).copied().unwrap_or(0);
        let source_start = sort_starts.get(source_sort as usize).copied().unwrap_or(0);
        let mut transitions = Vec::with_capacity(source_len as usize);
        for local_state in 0..source_len {
            transitions.push(
                adapter
                    .transition(context, source_start + local_state)
                    .map_err(InterfaceCompileError::Adapter)?,
            );
        }
        contexts.push(GeneratorSpec {
            source_sort,
            target_sort,
            transitions: transitions.into_boxed_slice(),
        });
    }

    FinitePresentation::new(sort_lengths, observations, contexts).map_err(Into::into)
}

/// Reconstruct one concrete domain witness for every quotient class.
pub fn lift_class_witnesses<A: FiniteInterfaceWitness>(
    adapter: &A,
    compiled: &CompiledObservation,
) -> Result<Box<[A::Witness]>, InterfaceCompileError<A::Error>> {
    let mut witnesses = Vec::with_capacity(compiled.class_representatives().len());
    for &state in compiled.class_representatives() {
        witnesses.push(
            adapter
                .lift_state(state)
                .map_err(InterfaceCompileError::Adapter)?,
        );
    }
    Ok(witnesses.into_boxed_slice())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::observational::{compile_observational, verify_compilation};
    use std::convert::Infallible;

    struct TypedAdapter;

    impl FiniteInterfaceAdapter for TypedAdapter {
        type Error = Infallible;

        fn sort_count(&self) -> u32 {
            2
        }

        fn sort_len(&self, _sort: u32) -> Result<u32, Self::Error> {
            Ok(2)
        }

        fn observation(&self, state: u32) -> Result<u32, Self::Error> {
            Ok(u32::from(state == 3))
        }

        fn context_count(&self) -> u32 {
            2
        }

        fn context_sorts(&self, context: u32) -> Result<(u32, u32), Self::Error> {
            Ok(if context == 0 { (0, 1) } else { (1, 1) })
        }

        fn transition(&self, context: u32, state: u32) -> Result<u32, Self::Error> {
            Ok(match (context, state) {
                (0, 0) => 2,
                (0, 1) => 3,
                (1, 2) => 3,
                (1, 3) => 3,
                _ => unreachable!(),
            })
        }
    }

    impl FiniteInterfaceWitness for TypedAdapter {
        type Witness = u32;

        fn lift_state(&self, state: u32) -> Result<Self::Witness, Self::Error> {
            Ok(10 + state)
        }
    }

    #[test]
    fn adapter_compiles_typed_contexts_and_lifts_representatives() {
        let presentation = present_finite_interface(&TypedAdapter).unwrap();
        let compiled = compile_observational(&presentation).unwrap();
        verify_compilation(&presentation, &compiled).unwrap();

        assert_ne!(compiled.state_classes()[0], compiled.state_classes()[1]);
        assert_ne!(compiled.state_classes()[2], compiled.state_classes()[3]);
        let witnesses = lift_class_witnesses(&TypedAdapter, &compiled).unwrap();
        assert_eq!(witnesses.len(), compiled.class_representatives().len());
        for (&witness, &representative) in witnesses.iter().zip(compiled.class_representatives()) {
            assert_eq!(witness, representative + 10);
        }
    }
}
