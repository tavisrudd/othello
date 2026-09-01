//! Typed finite obstruction packet for the hostile `q=11` Hall exchange.

use super::dataflow::{
    compile_fragment_emission, compile_recipe, AdapterRegistry, ArgumentDomain,
    CompiledFragmentEmission, DataflowBudget, OperationSignature, ParameterSignature,
    SourceSignature,
};
use super::execution::{
    compile_execution_plan, execute_prepared, ExecutionPlan, ExecutionStage,
    PreparedSemanticRuntime, ReducerLane,
};
use super::theorem::parse_theorem_fragment;
use super::{parse_semantic_recipe, OpKind};
use crate::hall_core::{HallOutcome, HallWorkspace};
use ergodis::control::ControlError;

const SOURCE_DIGEST: &str = "564d92e45dd472beffbf36744baeabbb93e64b89d1ea1a2c3f5a8b69bfb6ed32";

pub const RECIPE_TEXT: &str = r#"
recipe q11_hostile_exchange {
  source hostile_exchange as exchange sort exchange_packet;
  label (created == 2) && (consumed == 2) && (omega_drop == 10);
  provenance "sha256:564d92e45dd472beffbf36744baeabbb93e64b89d1ea1a2c3f5a8b69bfb6ed32";
  reduce exchange_profile from exchange as profile sort charge_profile retain 4 memory 128;
  canonicalize hall_deficiency(expected_deficiency=1) from profile as obstruction sort hall_certificate retain 2 memory 256 streamed false contract preserves verified true;
  emit obstruction;
  verify hall_replay;
}
"#;

pub const FRAGMENT_TEXT: &str = r#"
theorem q11_secant_charge_obstruction {
  domain q11_exchange_graph;
  evidence hall_certificate;
  parameter consumed scalar;
  parameter created scalar;
  parameter left_size scalar;
  parameter neighborhood_size scalar;
  hypothesis equal_support consumed == created;
  conclusion neighborhood_size < left_size;
  observable hall_deficiency contract exact;
  action hall_deficiency(expected_deficiency=1) contract preserves verified true;
  provenance "sha256:564d92e45dd472beffbf36744baeabbb93e64b89d1ea1a2c3f5a8b69bfb6ed32";
  status finite_certified;
  certificate hall_replay "sha256:564d92e45dd472beffbf36744baeabbb93e64b89d1ea1a2c3f5a8b69bfb6ed32";
}
"#;

pub struct Q11HallPacket {
    pub plan: ExecutionPlan,
    pub emission: CompiledFragmentEmission,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Q11HallResult {
    pub consumed: usize,
    pub created: usize,
    pub omega_old: u32,
    pub omega_next: u32,
    pub left_size: usize,
    pub neighborhood_size: usize,
}

impl Q11HallResult {
    #[must_use]
    pub const fn deficiency(self) -> usize {
        self.left_size - self.neighborhood_size
    }
}

pub fn registry() -> Result<AdapterRegistry, ControlError> {
    AdapterRegistry::try_new(
        vec![SourceSignature {
            name: "hostile_exchange".into(),
            output_sort: "exchange_packet".into(),
        }],
        vec![
            OperationSignature {
                name: "exchange_profile".into(),
                kind: OpKind::Reduce,
                input_sorts: Box::new(["exchange_packet".into()]),
                output_sort: "charge_profile".into(),
                parameters: Box::new([]),
                max_retention: 4,
                max_memory_bytes: 128,
                allows_streamed_partition: false,
            },
            OperationSignature {
                name: "hall_deficiency".into(),
                kind: OpKind::Canonicalize,
                input_sorts: Box::new(["charge_profile".into()]),
                output_sort: "hall_certificate".into(),
                parameters: Box::new([ParameterSignature {
                    name: "expected_deficiency".into(),
                    domain: ArgumentDomain::Integer {
                        minimum: 1,
                        maximum: 4,
                    },
                }]),
                max_retention: 2,
                max_memory_bytes: 256,
                allows_streamed_partition: false,
            },
        ],
    )
}

pub fn compile_packet(registry: &AdapterRegistry) -> Result<Q11HallPacket, ControlError> {
    let recipe = parse_semantic_recipe(RECIPE_TEXT)?;
    let compiled = compile_recipe(
        &recipe,
        registry,
        DataflowBudget {
            max_total_retention: 8,
            max_total_memory_bytes: 512,
        },
    )?;
    let fragment = parse_theorem_fragment(FRAGMENT_TEXT)?;
    let emission = compile_fragment_emission(&recipe, &compiled, &fragment)?;
    Ok(Q11HallPacket {
        plan: compile_execution_plan(&compiled)?,
        emission,
    })
}

pub struct Q11HallRuntime {
    registry_canonical: Box<[u8]>,
    hall: HallWorkspace,
    result: Q11HallResult,
}

impl Q11HallRuntime {
    pub fn try_new(registry: &AdapterRegistry) -> Result<Self, ControlError> {
        Ok(Self {
            registry_canonical: registry.canonical_json()?.into_boxed_slice(),
            hall: HallWorkspace::new(2, 2),
            result: Q11HallResult {
                consumed: 0,
                created: 0,
                omega_old: 0,
                omega_next: 0,
                left_size: 0,
                neighborhood_size: 0,
            },
        })
    }

    #[must_use]
    pub const fn result(&self) -> Q11HallResult {
        self.result
    }
}

impl PreparedSemanticRuntime for Q11HallRuntime {
    fn registry_canonical(&self) -> &[u8] {
        &self.registry_canonical
    }

    fn run_fused_match_reduce(
        &mut self,
        _stage: ExecutionStage,
        _inputs: &[u16],
        _reducers: &[ReducerLane],
        _arguments: &[i64],
    ) -> Result<(), ControlError> {
        invalid("q11 Hall packet has no streamed matcher")
    }

    fn run_reduce(
        &mut self,
        stage: ExecutionStage,
        inputs: &[u16],
        arguments: &[i64],
    ) -> Result<(), ControlError> {
        if inputs != [0]
            || stage.primary_signature() != 0
            || stage.arguments(arguments) != Some(&[])
        {
            return invalid("prepared q11 Hall packet received an incompatible reducer");
        }
        // Exact hostile exchange: two old labels are consumed, two new
        // defects are created, and Omega falls 10 -> 0.
        self.result.consumed = 2;
        self.result.created = 2;
        self.result.omega_old = 10;
        self.result.omega_next = 0;
        Ok(())
    }

    fn run_canonicalize(
        &mut self,
        stage: ExecutionStage,
        inputs: &[u16],
        arguments: &[i64],
    ) -> Result<(), ControlError> {
        if inputs != [1]
            || stage.primary_signature() != 1
            || stage.arguments(arguments) != Some(&[1])
        {
            return invalid("prepared q11 Hall packet received an incompatible canonicalizer");
        }
        // Both new defects have singleton neighbourhood equal to consumed
        // label (6,1); consumed label (4,9) is isolated under the rejected
        // direct/deletion-secant edge law.
        let outcome = self
            .hall
            .solve(2, 2, &[0, 1, 2], &[1, 1])
            .map_err(|error| ControlError::Invalid(error.to_string()))?;
        let HallOutcome::Deficient {
            left_size,
            neighborhood_size,
        } = outcome
        else {
            return invalid("q11 hostile exchange unexpectedly admits a saturated matching");
        };
        if self.hall.deficient_left() != [0, 1] || self.hall.deficient_right() != [1] {
            return invalid("q11 Hall replay returned the wrong deficient witness");
        }
        self.result.left_size = left_size;
        self.result.neighborhood_size = neighborhood_size;
        Ok(())
    }
}

pub fn run() -> Result<Q11HallResult, ControlError> {
    debug_assert_eq!(SOURCE_DIGEST.len(), 64);
    let registry = registry()?;
    let packet = compile_packet(&registry)?;
    let mut runtime = Q11HallRuntime::try_new(&registry)?;
    execute_prepared(&packet.plan, &mut runtime)?;
    if packet.emission.verifier_gate != 0 {
        return invalid("q11 Hall packet selected the wrong verifier gate");
    }
    Ok(runtime.result())
}

fn invalid<T>(message: &str) -> Result<T, ControlError> {
    Err(ControlError::Invalid(message.into()))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn q11_hall_packet_compiles_executes_and_replays() {
        let registry = registry().unwrap();
        let packet = compile_packet(&registry).unwrap();
        assert_eq!(packet.plan.stages().len(), 2);
        assert_eq!(packet.emission.output_slot, 2);
        assert_eq!(packet.emission.action_count, 1);
        let mut runtime = Q11HallRuntime::try_new(&registry).unwrap();
        execute_prepared(&packet.plan, &mut runtime).unwrap();
        let first = runtime.result();
        let (replay, allocations) = crate::allocation_test::tracked_allocations(|| {
            execute_prepared(&packet.plan, &mut runtime)
        });
        replay.unwrap();
        assert_eq!(allocations, 0);
        assert_eq!(runtime.result(), first);
        assert_eq!(first.consumed, first.created);
        assert_eq!((first.omega_old, first.omega_next), (10, 0));
        assert_eq!((first.left_size, first.neighborhood_size), (2, 1));
        assert_eq!(first.deficiency(), 1);
    }

    #[test]
    fn q11_hall_packet_rejects_certificate_parameter_drift() {
        let registry = registry().unwrap();
        let recipe = parse_semantic_recipe(RECIPE_TEXT).unwrap();
        let compiled = compile_recipe(
            &recipe,
            &registry,
            DataflowBudget {
                max_total_retention: 8,
                max_total_memory_bytes: 512,
            },
        )
        .unwrap();
        let fragment = parse_theorem_fragment(
            &FRAGMENT_TEXT.replace("expected_deficiency=1", "expected_deficiency=2"),
        )
        .unwrap();
        assert!(compile_fragment_emission(&recipe, &compiled, &fragment).is_err());
    }
}
