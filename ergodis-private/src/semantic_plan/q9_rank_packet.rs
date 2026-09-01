//! Typed semantic packet for the bounded `GF(9)` intertwiner rank core.

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
use crate::landed_rank_adapter::{q9_extra_channel_system, SOURCE_SHA256};
use crate::semantic_rank::{
    compile_semantic_rank_core, Gf9BlockSystem, Gf9RankWorkspace, SemanticRankCore,
};
use crate::semantic_sets::for_each_k_subset;
use ergodis::control::ControlError;

pub const RECIPE_TEXT: &str = r#"
recipe q9_rank_core {
  source q9_intertwiner_core as core sort semantic_rank_core;
  label (rank == 29) && (hom_dimension == 1) && (weyl_rank_loss == 1);
  provenance "sha256:782087ca2931c7438dca514010b65cb152d90df18cc27ae86822dde0fea20ab6";
  reduce generator_marginals from core as summary sort rank_summary retain 4 memory 256;
  canonicalize independent_row_basis(expected_rank=29) from summary as evidence sort rank_certificate retain 29 memory 4096 streamed false contract preserves verified true;
  emit evidence;
  verify rank_replay;
}
"#;

pub const FRAGMENT_TEXT: &str = r#"
theorem q9_extra_channel_rank {
  domain gf9_intertwiner_system;
  evidence rank_certificate;
  parameter rank scalar;
  parameter hom_dimension scalar;
  parameter weyl_rank_loss scalar;
  hypothesis rank_fixed rank == 29;
  hypothesis hom_fixed hom_dimension == 1;
  conclusion weyl_rank_loss == 1;
  observable rank contract exact;
  observable hom_dimension contract exact;
  action independent_row_basis(expected_rank=29) contract preserves verified true;
  provenance "sha256:782087ca2931c7438dca514010b65cb152d90df18cc27ae86822dde0fea20ab6";
  status finite_certified;
  certificate rank_replay "sha256:c896-q9-semantic-rank-v1";
}
"#;

pub struct Q9RankPacket {
    pub plan: ExecutionPlan,
    pub emission: CompiledFragmentEmission,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Q9RankResult {
    pub variables: usize,
    pub rank: usize,
    pub hom_dimension: usize,
    pub minimum_generator_core_size: usize,
    pub minimum_generator_core_count: usize,
    pub rank_loss_if_removed: [usize; 4],
    pub independent_equations: usize,
    pub certificate_replayed: bool,
}

pub fn registry() -> Result<AdapterRegistry, ControlError> {
    AdapterRegistry::try_new(
        vec![SourceSignature {
            name: "q9_intertwiner_core".into(),
            output_sort: "semantic_rank_core".into(),
        }],
        vec![
            OperationSignature {
                name: "generator_marginals".into(),
                kind: OpKind::Reduce,
                input_sorts: Box::new(["semantic_rank_core".into()]),
                output_sort: "rank_summary".into(),
                parameters: Box::new([]),
                max_retention: 4,
                max_memory_bytes: 256,
                allows_streamed_partition: false,
            },
            OperationSignature {
                name: "independent_row_basis".into(),
                kind: OpKind::Canonicalize,
                input_sorts: Box::new(["rank_summary".into()]),
                output_sort: "rank_certificate".into(),
                parameters: Box::new([ParameterSignature {
                    name: "expected_rank".into(),
                    domain: ArgumentDomain::Integer {
                        minimum: 1,
                        maximum: 256,
                    },
                }]),
                max_retention: 29,
                max_memory_bytes: 4096,
                allows_streamed_partition: false,
            },
        ],
    )
}

pub fn compile_packet(registry: &AdapterRegistry) -> Result<Q9RankPacket, ControlError> {
    let recipe = parse_semantic_recipe(RECIPE_TEXT)?;
    let compiled = compile_recipe(
        &recipe,
        registry,
        DataflowBudget {
            max_total_retention: 64,
            max_total_memory_bytes: 8192,
        },
    )?;
    let fragment = parse_theorem_fragment(FRAGMENT_TEXT)?;
    let emission = compile_fragment_emission(&recipe, &compiled, &fragment)?;
    Ok(Q9RankPacket {
        plan: compile_execution_plan(&compiled)?,
        emission,
    })
}

pub struct Q9RankRuntime {
    registry_canonical: Box<[u8]>,
    system: Gf9BlockSystem,
    certificate: Gf9BlockSystem,
    core: SemanticRankCore,
    full_workspace: Gf9RankWorkspace,
    certificate_workspace: Gf9RankWorkspace,
    rank_loss_if_removed: [usize; 4],
    certificate_replayed: bool,
}

impl Q9RankRuntime {
    pub fn try_new(registry: &AdapterRegistry) -> Result<Self, ControlError> {
        let system = q9_extra_channel_system();
        let core = compile_semantic_rank_core(&system);
        let certificate = system
            .select_rows(&core.independent_rows)
            .map_err(|message| ControlError::Invalid(message.into()))?;
        Ok(Self {
            registry_canonical: registry.canonical_json()?.into_boxed_slice(),
            full_workspace: Gf9RankWorkspace::new(system.row_count(), system.columns()),
            certificate_workspace: Gf9RankWorkspace::new(
                certificate.row_count(),
                certificate.columns(),
            ),
            system,
            certificate,
            core,
            rank_loss_if_removed: [0; 4],
            certificate_replayed: false,
        })
    }

    #[must_use]
    pub fn result(&self) -> Q9RankResult {
        Q9RankResult {
            variables: self.system.columns(),
            rank: self.core.rank,
            hom_dimension: self.system.columns() - self.core.rank,
            minimum_generator_core_size: self.core.minimum_block_size,
            minimum_generator_core_count: self.core.minimum_block_masks.len(),
            rank_loss_if_removed: self.rank_loss_if_removed,
            independent_equations: self.core.independent_rows.len(),
            certificate_replayed: self.certificate_replayed,
        }
    }
}

impl PreparedSemanticRuntime for Q9RankRuntime {
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
        invalid("q9 rank packet has no streamed matcher")
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
            return invalid("prepared q9 rank packet received an incompatible reducer");
        }
        let full_mask = (1_u64 << self.system.block_count()) - 1;
        if self.full_workspace.rank_blocks(&self.system, full_mask) != self.core.rank {
            return invalid("q9 rank source no longer has the compiled full rank");
        }
        for (block, loss) in self.rank_loss_if_removed.iter_mut().enumerate() {
            *loss = self.core.rank
                - self
                    .full_workspace
                    .rank_blocks(&self.system, full_mask ^ (1_u64 << block));
        }
        if self.rank_loss_if_removed.as_slice() != self.core.rank_loss_if_removed.as_ref() {
            return invalid("q9 generator marginals disagree with the compiled packet");
        }
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
            || stage.arguments(arguments) != Some(&[29])
        {
            return invalid("prepared q9 rank packet received an incompatible canonicalizer");
        }
        self.certificate_replayed = false;
        if self.certificate_workspace.rank_blocks(&self.certificate, 1) != self.core.rank {
            return invalid("q9 independent-row certificate has the wrong rank");
        }
        for size in 0..self.core.minimum_block_size {
            let mut found_full_rank = false;
            for_each_k_subset(self.system.block_count(), size, |mask| {
                found_full_rank |=
                    self.full_workspace.rank_blocks(&self.system, mask) == self.core.rank;
            });
            if found_full_rank {
                return invalid("q9 packet omitted a smaller full-rank generator core");
            }
        }
        let mut cursor = 0;
        let mut mismatch = false;
        for_each_k_subset(
            self.system.block_count(),
            self.core.minimum_block_size,
            |mask| {
                if self.full_workspace.rank_blocks(&self.system, mask) == self.core.rank {
                    mismatch |= self.core.minimum_block_masks.get(cursor) != Some(&mask);
                    cursor += 1;
                }
            },
        );
        if mismatch || cursor != self.core.minimum_block_masks.len() {
            return invalid("q9 minimum generator cores fail exact replay");
        }
        self.certificate_replayed = true;
        Ok(())
    }
}

pub fn run() -> Result<Q9RankResult, ControlError> {
    debug_assert_eq!(SOURCE_SHA256.len(), 64);
    let registry = registry()?;
    let packet = compile_packet(&registry)?;
    let mut runtime = Q9RankRuntime::try_new(&registry)?;
    execute_prepared(&packet.plan, &mut runtime)?;
    if packet.emission.verifier_gate != 0 {
        return invalid("q9 packet selected the wrong verifier gate");
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
    fn q9_rank_packet_compiles_executes_and_replays() {
        let registry = registry().unwrap();
        let packet = compile_packet(&registry).unwrap();
        assert_eq!(packet.plan.stages().len(), 2);
        assert_eq!(packet.emission.output_slot, 2);
        assert_eq!(packet.emission.action_count, 1);
        assert_eq!(packet.emission.verifier_gate, 0);
        let mut runtime = Q9RankRuntime::try_new(&registry).unwrap();
        execute_prepared(&packet.plan, &mut runtime).unwrap();
        let (replay, allocations) = crate::allocation_test::tracked_allocations(|| {
            execute_prepared(&packet.plan, &mut runtime)
        });
        replay.unwrap();
        assert_eq!(allocations, 0);
        let result = runtime.result();
        assert_eq!(
            (result.variables, result.rank, result.hom_dimension),
            (30, 29, 1)
        );
        assert_eq!(result.minimum_generator_core_size, 3);
        assert_eq!(result.minimum_generator_core_count, 3);
        assert_eq!(result.rank_loss_if_removed, [0, 0, 1, 0]);
        assert_eq!(result.independent_equations, 29);
        assert!(result.certificate_replayed);
    }

    #[test]
    fn q9_rank_packet_rejects_action_parameter_drift() {
        let registry = registry().unwrap();
        let recipe = parse_semantic_recipe(RECIPE_TEXT).unwrap();
        let compiled = compile_recipe(
            &recipe,
            &registry,
            DataflowBudget {
                max_total_retention: 64,
                max_total_memory_bytes: 8192,
            },
        )
        .unwrap();
        let fragment =
            parse_theorem_fragment(&FRAGMENT_TEXT.replace("expected_rank=29", "expected_rank=28"))
                .unwrap();
        assert!(compile_fragment_emission(&recipe, &compiled, &fragment).is_err());
    }
}
