use super::{Manifest, PlanArena, PlanOutput, PlanRole};
use crate::alignment::{
    AlignmentBranchFeatures, AlignmentError, AlignmentSearchControl, AlignmentSearchPoint,
};
use serde_json::json;

pub const ALIGNMENT_PLAN_FIELDS: [&str; 7] = [
    "depth",
    "selected_count",
    "candidate",
    "branch_count",
    "unresolved_count",
    "child_unresolved_count",
    "child_packing",
];

/// C880 adapter for live ordering-plan injection at coarse search safe points.
pub struct AlignmentCampaignControl {
    manifest: Manifest,
    fields: Box<[String]>,
    arena: PlanArena,
    pulses: u64,
    last_point: Option<AlignmentSearchPoint>,
}

impl AlignmentCampaignControl {
    pub fn new(manifest: Manifest, response_limit: usize) -> Self {
        Self {
            manifest,
            fields: ALIGNMENT_PLAN_FIELDS
                .iter()
                .map(|field| (*field).into())
                .collect(),
            arena: PlanArena::new(response_limit),
            pulses: 0,
            last_point: None,
        }
    }

    pub fn epoch(&self) -> u64 {
        self.arena.epoch()
    }

    pub fn pulses(&self) -> u64 {
        self.pulses
    }

    pub fn last_point(&self) -> Option<AlignmentSearchPoint> {
        self.last_point
    }

    fn ordering_plan(&self) -> Option<&super::CompiledPlan> {
        self.arena
            .plans()
            .iter()
            .find(|plan| plan.role == PlanRole::Ordering && plan.output == PlanOutput::Score)
    }
}

impl AlignmentSearchControl for AlignmentCampaignControl {
    fn safe_point(&mut self, point: AlignmentSearchPoint) -> Result<(), AlignmentError> {
        self.arena
            .refresh_with_status(
                &self.manifest,
                &self.fields,
                Some(json!({
                    "states": point.metrics.states,
                    "duplicates": point.metrics.duplicate_states,
                    "infeasible": point.metrics.infeasible_states,
                    "depth": point.depth,
                    "selected_count": point.selected_count,
                    "unresolved_count": point.unresolved_count,
                })),
            )
            .map_err(|_| AlignmentError::Control)?;
        self.pulses = self.pulses.saturating_add(1);
        self.last_point = Some(point);
        Ok(())
    }

    #[inline]
    fn ordering_active(&self) -> bool {
        self.ordering_plan().is_some()
    }

    #[inline]
    fn score_branch(&mut self, features: AlignmentBranchFeatures) -> Result<i64, AlignmentError> {
        let Some(plan) = self.ordering_plan() else {
            return Ok(0);
        };
        plan.evaluate_row(&[
            i64::from(features.depth),
            i64::from(features.selected_count),
            i64::from(features.candidate),
            i64::from(features.branch_count),
            i64::from(features.unresolved_count),
            i64::from(features.child_unresolved_count),
            i64::from(features.child_packing),
        ])
        .map_err(|_| AlignmentError::Control)
    }
}
