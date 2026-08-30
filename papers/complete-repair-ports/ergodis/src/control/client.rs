use super::{send_request, CompiledPlan, ControlError, Manifest, PlanSpec, MAX_ACTIVE_PLANS};
use serde_json::{json, Value};

/// Double-buffered active plans for coarse solver safe points.
///
/// Socket I/O and compilation happen only in `refresh`. The active slice is
/// immutable between refreshes and its evaluators allocate nothing per row.
pub struct PlanArena {
    epoch: u64,
    active: Vec<CompiledPlan>,
    inactive: Vec<CompiledPlan>,
    response_limit: usize,
}

impl PlanArena {
    pub fn new(response_limit: usize) -> Self {
        Self {
            epoch: 0,
            active: Vec::with_capacity(MAX_ACTIVE_PLANS),
            inactive: Vec::with_capacity(MAX_ACTIVE_PLANS),
            response_limit,
        }
    }

    pub fn epoch(&self) -> u64 {
        self.epoch
    }

    pub fn plans(&self) -> &[CompiledPlan] {
        &self.active
    }

    /// Poll and atomically replace the local plan arena if the epoch changed.
    /// A failed or stale fetch leaves the prior arena intact.
    pub fn refresh(
        &mut self,
        manifest: &Manifest,
        fields: &[String],
    ) -> Result<bool, ControlError> {
        self.refresh_with_status(manifest, fields, None)
    }

    pub fn refresh_with_status(
        &mut self,
        manifest: &Manifest,
        fields: &[String],
        solver_status: Option<Value>,
    ) -> Result<bool, ControlError> {
        let pulse = send_request(
            manifest,
            "pulse",
            json!({"since_epoch": self.epoch, "solver": solver_status}),
            self.response_limit,
        )?;
        ensure_ok(&pulse.result, pulse.ok)?;
        if !pulse.result["changed"].as_bool().unwrap_or(false) {
            return Ok(false);
        }
        let epoch = pulse.result["epoch"]
            .as_u64()
            .ok_or_else(|| ControlError::Invalid("pulse omitted epoch".into()))?;
        let summaries = pulse.result["plans"]
            .as_array()
            .ok_or_else(|| ControlError::Invalid("changed pulse omitted plans".into()))?;
        if summaries.len() > MAX_ACTIVE_PLANS {
            return Err(ControlError::Invalid(
                "pulse exceeds active plan capacity".into(),
            ));
        }
        self.inactive.clear();
        for summary in summaries {
            let name = summary["name"]
                .as_str()
                .ok_or_else(|| ControlError::Invalid("plan summary omitted name".into()))?;
            let claimed_hash = summary["hash"]
                .as_str()
                .ok_or_else(|| ControlError::Invalid("plan summary omitted hash".into()))?;
            let fetched = send_request(
                manifest,
                "plan-get",
                json!({"plan": name, "expect_epoch": epoch}),
                self.response_limit,
            )?;
            if let Err(error) = ensure_ok(&fetched.result, fetched.ok) {
                self.inactive.clear();
                return Err(error);
            }
            let spec: PlanSpec = serde_json::from_value(fetched.result["plan"].clone())?;
            let plan = CompiledPlan::compile(&spec, fields)?;
            if plan.hash != claimed_hash || fetched.result["hash"] != claimed_hash {
                self.inactive.clear();
                return Err(ControlError::Invalid("plan hash mismatch".into()));
            }
            self.inactive.push(plan);
        }
        std::mem::swap(&mut self.active, &mut self.inactive);
        self.inactive.clear();
        self.epoch = epoch;
        Ok(true)
    }
}

fn ensure_ok(result: &Value, ok: bool) -> Result<(), ControlError> {
    if ok {
        Ok(())
    } else {
        Err(ControlError::Invalid(
            result
                .get("error")
                .and_then(Value::as_str)
                .unwrap_or("campaign rejected request")
                .into(),
        ))
    }
}
