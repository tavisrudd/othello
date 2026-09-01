use ergodis::control::{send_request, CompiledPlan, Manifest, PlanArena, PlanOutput, PlanRole};
use ergodis::{
    AlignmentBranchFeatures, AlignmentError, AlignmentSearchControl, AlignmentSearchPoint,
};
use serde_json::json;
use std::collections::BTreeMap;
use std::fs::{self, OpenOptions};
use std::io::{self, LineWriter, Write};
use std::os::unix::fs::{OpenOptionsExt, PermissionsExt};
use std::os::unix::net::UnixDatagram;
use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::{Arc, Mutex};
use std::thread::{self, JoinHandle};
use std::time::{Duration, Instant};

pub const ALIGNMENT_PLAN_FIELDS: [&str; 15] = [
    "depth",
    "selected_count",
    "candidate",
    "branch_count",
    "unresolved_count",
    "child_unresolved_count",
    "child_packing",
    "root_candidate",
    "root_orbit",
    "root_ordinal",
    "root_total",
    "root_sized",
    "root_initial_unresolved",
    "root_initial_packing",
    "root_initial_branches",
];

const ALIGNMENT_TARGET_FIELDS: [&str; 3] = ["root_orbit", "root_initial_packing", "root_sized"];

static WATCH_IDS: AtomicU64 = AtomicU64::new(0);

#[derive(Clone, Copy, Eq, Ord, PartialEq, PartialOrd)]
struct AlignmentTargetKey([i64; 3]);

#[derive(Default)]
struct AlignmentTargetStats {
    root_states: BTreeMap<u32, u64>,
    last_sent: Option<(u64, u64, &'static str)>,
}

struct AlignmentTargetPublisher {
    targets: BTreeMap<AlignmentTargetKey, AlignmentTargetStats>,
    policy: AlignmentProfilePolicy,
}

struct AlignmentTargetObservation {
    values: [i64; 3],
    mass: u64,
    unit_cost: u64,
    strategy: &'static str,
}

#[derive(Clone, Copy, Debug)]
pub struct AlignmentProfilePolicy {
    pub structural_branches: u64,
    pub structural_packing: u64,
}

impl Default for AlignmentProfilePolicy {
    fn default() -> Self {
        Self {
            structural_branches: 8,
            structural_packing: 3,
        }
    }
}

impl AlignmentTargetPublisher {
    fn new(policy: AlignmentProfilePolicy) -> Self {
        Self {
            targets: BTreeMap::new(),
            policy,
        }
    }

    fn update(&mut self, status: &serde_json::Value) -> Option<AlignmentTargetObservation> {
        let root_orbit = status["root_orbit"].as_u64()?;
        let root_ordinal = u32::try_from(status["root_ordinal"].as_u64()?).ok()?;
        let root_states = status["root_states"].as_u64()?.max(1);
        let root_initial_packing = status["root_initial_packing"].as_u64()?;
        let root_sized = status["root_sized"].as_bool()?;
        let key = AlignmentTargetKey([
            i64::try_from(root_orbit).ok()?,
            i64::try_from(root_initial_packing).ok()?,
            i64::from(root_sized),
        ]);
        let strategy = if status["root_initial_branches"].as_u64()?
            >= self.policy.structural_branches
            || root_initial_packing >= self.policy.structural_packing
        {
            "structural"
        } else {
            "numeric"
        };
        let target = self.targets.entry(key).or_default();
        target
            .root_states
            .entry(root_ordinal)
            .and_modify(|states| *states = (*states).max(root_states))
            .or_insert(root_states);
        let mass = u64::try_from(target.root_states.len()).ok()?;
        let unit_cost = target.root_states.values().copied().max()?;
        let measurement = (mass, unit_cost, strategy);
        if target.last_sent == Some(measurement) {
            return None;
        }
        target.last_sent = Some(measurement);
        Some(AlignmentTargetObservation {
            values: key.0,
            mass,
            unit_cost,
            strategy,
        })
    }

    fn retry(&mut self, values: [i64; 3]) {
        if let Some(target) = self.targets.get_mut(&AlignmentTargetKey(values)) {
            target.last_sent = None;
        }
    }
}

#[repr(align(64))]
struct PaddedFlag(AtomicBool);

#[repr(C, align(64))]
struct Heartbeat {
    sequence: AtomicU64,
    states: AtomicU64,
    duplicates: AtomicU64,
    infeasible: AtomicU64,
    depth: AtomicU64,
    selected_count: AtomicU64,
    unresolved_count: AtomicU64,
    root_done: AtomicU64,
    root_total: AtomicU64,
    root_candidate: AtomicU64,
    root_orbit: AtomicU64,
    root_states: AtomicU64,
    root_duplicates: AtomicU64,
    root_infeasible: AtomicU64,
    root_ordinal: AtomicU64,
    root_sized: AtomicU64,
    root_initial_unresolved: AtomicU64,
    root_initial_packing: AtomicU64,
    root_initial_branches: AtomicU64,
    active_root_mask: AtomicU64,
    completed_root_mask: AtomicU64,
}

impl Heartbeat {
    fn new() -> Self {
        Self {
            sequence: AtomicU64::new(0),
            states: AtomicU64::new(0),
            duplicates: AtomicU64::new(0),
            infeasible: AtomicU64::new(0),
            depth: AtomicU64::new(0),
            selected_count: AtomicU64::new(0),
            unresolved_count: AtomicU64::new(0),
            root_done: AtomicU64::new(0),
            root_total: AtomicU64::new(0),
            root_candidate: AtomicU64::new(u64::MAX),
            root_orbit: AtomicU64::new(u64::MAX),
            root_states: AtomicU64::new(0),
            root_duplicates: AtomicU64::new(0),
            root_infeasible: AtomicU64::new(0),
            root_ordinal: AtomicU64::new(0),
            root_sized: AtomicU64::new(0),
            root_initial_unresolved: AtomicU64::new(0),
            root_initial_packing: AtomicU64::new(0),
            root_initial_branches: AtomicU64::new(0),
            active_root_mask: AtomicU64::new(0),
            completed_root_mask: AtomicU64::new(0),
        }
    }

    fn publish(&self, point: AlignmentSearchPoint) {
        self.sequence.fetch_add(1, Ordering::AcqRel);
        self.states.store(point.metrics.states, Ordering::Relaxed);
        self.duplicates
            .store(point.metrics.duplicate_states, Ordering::Relaxed);
        self.infeasible
            .store(point.metrics.infeasible_states, Ordering::Relaxed);
        self.depth.store(u64::from(point.depth), Ordering::Relaxed);
        self.selected_count
            .store(u64::from(point.selected_count), Ordering::Relaxed);
        self.unresolved_count
            .store(u64::from(point.unresolved_count), Ordering::Relaxed);
        self.root_done
            .store(u64::from(point.root_done), Ordering::Relaxed);
        self.root_total
            .store(u64::from(point.root_total), Ordering::Relaxed);
        self.root_candidate.store(
            point.root_candidate.map_or(u64::MAX, u64::from),
            Ordering::Relaxed,
        );
        self.root_orbit.store(
            point.root_orbit.map_or(u64::MAX, u64::from),
            Ordering::Relaxed,
        );
        self.root_states.store(point.root_states, Ordering::Relaxed);
        self.root_duplicates
            .store(point.root_duplicates, Ordering::Relaxed);
        self.root_infeasible
            .store(point.root_infeasible, Ordering::Relaxed);
        self.root_ordinal
            .store(u64::from(point.root_ordinal), Ordering::Relaxed);
        self.root_sized
            .store(u64::from(point.root_sized), Ordering::Relaxed);
        self.root_initial_unresolved
            .store(u64::from(point.root_initial_unresolved), Ordering::Relaxed);
        self.root_initial_packing
            .store(u64::from(point.root_initial_packing), Ordering::Relaxed);
        self.root_initial_branches
            .store(u64::from(point.root_initial_branches), Ordering::Relaxed);
        self.active_root_mask
            .store(point.active_root_mask, Ordering::Relaxed);
        self.completed_root_mask
            .store(point.completed_root_mask, Ordering::Relaxed);
        self.sequence.fetch_add(1, Ordering::Release);
    }

    fn snapshot(&self) -> serde_json::Value {
        loop {
            let before = self.sequence.load(Ordering::Acquire);
            if before & 1 != 0 {
                std::hint::spin_loop();
                continue;
            }
            let root_candidate = self.root_candidate.load(Ordering::Relaxed);
            let root_orbit = self.root_orbit.load(Ordering::Relaxed);
            let status = json!({
                "states": self.states.load(Ordering::Relaxed),
                "duplicates": self.duplicates.load(Ordering::Relaxed),
                "infeasible": self.infeasible.load(Ordering::Relaxed),
                "depth": self.depth.load(Ordering::Relaxed),
                "selected_count": self.selected_count.load(Ordering::Relaxed),
                "unresolved_count": self.unresolved_count.load(Ordering::Relaxed),
                "root_done": self.root_done.load(Ordering::Relaxed),
                "root_total": self.root_total.load(Ordering::Relaxed),
                "root_candidate": (root_candidate != u64::MAX).then_some(root_candidate),
                "root_orbit": (root_orbit != u64::MAX).then_some(root_orbit),
                "root_states": self.root_states.load(Ordering::Relaxed),
                "root_duplicates": self.root_duplicates.load(Ordering::Relaxed),
                "root_infeasible": self.root_infeasible.load(Ordering::Relaxed),
                "root_ordinal": self.root_ordinal.load(Ordering::Relaxed),
                "root_sized": self.root_sized.load(Ordering::Relaxed) != 0,
                "root_initial_unresolved": self.root_initial_unresolved.load(Ordering::Relaxed),
                "root_initial_packing": self.root_initial_packing.load(Ordering::Relaxed),
                "root_initial_branches": self.root_initial_branches.load(Ordering::Relaxed),
                "active_root_mask": self.active_root_mask.load(Ordering::Relaxed),
                "completed_root_mask": self.completed_root_mask.load(Ordering::Relaxed),
            });
            if self.sequence.load(Ordering::Acquire) == before {
                return status;
            }
        }
    }
}

struct SteeringWatcher {
    ready: Arc<PaddedFlag>,
    failed: Arc<PaddedFlag>,
    stop: Arc<PaddedFlag>,
    heartbeat: Arc<Heartbeat>,
    notifications: Arc<AtomicU64>,
    profile_updates: Arc<AtomicU64>,
    profile_rejections: Arc<AtomicU64>,
    profile_refreshes: Arc<AtomicU64>,
    applied_epoch: Arc<AtomicU64>,
    exchange: Arc<Mutex<PlanExchange>>,
    endpoint: PathBuf,
    manifest: Manifest,
    response_limit: usize,
    handle: Option<JoinHandle<()>>,
}

struct PlanExchange {
    prepared: Option<PlanArena>,
    recycled: Option<PlanArena>,
}

impl SteeringWatcher {
    fn spawn(
        manifest: Manifest,
        response_limit: usize,
        progress_path: Option<PathBuf>,
        fields: Arc<[String]>,
        profile_policy: Option<AlignmentProfilePolicy>,
    ) -> Result<Self, AlignmentError> {
        let publish_profile = profile_policy.is_some();
        let ready = Arc::new(PaddedFlag(AtomicBool::new(false)));
        let failed = Arc::new(PaddedFlag(AtomicBool::new(false)));
        let stop = Arc::new(PaddedFlag(AtomicBool::new(false)));
        let heartbeat = Arc::new(Heartbeat::new());
        let notifications = Arc::new(AtomicU64::new(0));
        let profile_updates = Arc::new(AtomicU64::new(0));
        let profile_rejections = Arc::new(AtomicU64::new(0));
        let profile_refreshes = Arc::new(AtomicU64::new(0));
        let applied_epoch = Arc::new(AtomicU64::new(0));
        let exchange = Arc::new(Mutex::new(PlanExchange {
            prepared: None,
            recycled: Some(PlanArena::new(response_limit)),
        }));
        let endpoint = manifest.run_dir.join(format!(
            "watch-{}-{}.sock",
            std::process::id(),
            WATCH_IDS.fetch_add(1, Ordering::Relaxed)
        ));
        let socket = UnixDatagram::bind(&endpoint).map_err(|_| AlignmentError::Control)?;
        if fs::set_permissions(&endpoint, fs::Permissions::from_mode(0o600)).is_err() {
            let _ = fs::remove_file(&endpoint);
            return Err(AlignmentError::Control);
        }
        let registration = match send_request(
            &manifest,
            "watch-register",
            json!({"path": endpoint}),
            response_limit,
        ) {
            Ok(registration) => registration,
            Err(_) => {
                let _ = fs::remove_file(&endpoint);
                return Err(AlignmentError::Control);
            }
        };
        if !registration.ok {
            let _ = fs::remove_file(&endpoint);
            return Err(AlignmentError::Control);
        }
        let Some(registered_epoch) = registration.result["epoch"].as_u64() else {
            unregister(&manifest, &endpoint, response_limit);
            return Err(AlignmentError::Control);
        };
        if publish_profile {
            let reset = match send_request(
                &manifest,
                "target-profile-reset",
                json!({"fields": ALIGNMENT_TARGET_FIELDS}),
                response_limit,
            ) {
                Ok(reset) => reset,
                Err(_) => {
                    unregister(&manifest, &endpoint, response_limit);
                    return Err(AlignmentError::Control);
                }
            };
            if !reset.ok {
                unregister(&manifest, &endpoint, response_limit);
                return Err(AlignmentError::Control);
            }
        }
        let mut progress = if let Some(path) = progress_path {
            if socket
                .set_read_timeout(Some(Duration::from_secs(1)))
                .is_err()
            {
                unregister(&manifest, &endpoint, response_limit);
                return Err(AlignmentError::Control);
            }
            let file = match OpenOptions::new()
                .write(true)
                .create_new(true)
                .mode(0o600)
                .open(path)
            {
                Ok(file) => file,
                Err(_) => {
                    unregister(&manifest, &endpoint, response_limit);
                    return Err(AlignmentError::Control);
                }
            };
            Some(LineWriter::new(file))
        } else {
            None
        };
        if publish_profile
            && socket
                .set_read_timeout(Some(Duration::from_secs(1)))
                .is_err()
        {
            unregister(&manifest, &endpoint, response_limit);
            return Err(AlignmentError::Control);
        }
        let thread_ready = Arc::clone(&ready);
        let thread_failed = Arc::clone(&failed);
        let thread_stop = Arc::clone(&stop);
        let thread_notifications = Arc::clone(&notifications);
        let thread_profile_updates = Arc::clone(&profile_updates);
        let thread_profile_rejections = Arc::clone(&profile_rejections);
        let thread_profile_refreshes = Arc::clone(&profile_refreshes);
        let thread_heartbeat = Arc::clone(&heartbeat);
        let thread_applied_epoch = Arc::clone(&applied_epoch);
        let thread_exchange = Arc::clone(&exchange);
        let thread_manifest = manifest.clone();
        let handle = thread::Builder::new()
            .name("ergodis-steering".into())
            .spawn(move || {
                let mut epoch = [0_u8; 8];
                let mut notified_epoch = registered_epoch;
                let mut last_states = u64::MAX;
                let mut profile_publisher =
                    AlignmentTargetPublisher::new(profile_policy.unwrap_or_default());
                let start = Instant::now();
                let mut initial_refresh = registered_epoch != 0;
                loop {
                    let received = if initial_refresh {
                        initial_refresh = false;
                        Ok(8)
                    } else {
                        socket.recv(&mut epoch)
                    };
                    if thread_stop.0.load(Ordering::Relaxed) {
                        break;
                    }
                    match received {
                        Ok(8) => {
                            if registered_epoch == 0 || epoch != [0; 8] {
                                notified_epoch = u64::from_le_bytes(epoch);
                                thread_notifications.fetch_add(1, Ordering::Relaxed);
                            }
                            thread_ready.0.store(false, Ordering::Release);
                            if prepare_latest(
                                &thread_manifest,
                                &fields,
                                response_limit,
                                &thread_heartbeat,
                                &thread_exchange,
                            )
                            .is_err()
                            {
                                thread_failed.0.store(true, Ordering::Release);
                                break;
                            }
                            if publish_profile {
                                let status = thread_heartbeat.snapshot();
                                publish_target_observation(
                                    &thread_manifest,
                                    response_limit,
                                    &mut profile_publisher,
                                    &status,
                                    &thread_profile_updates,
                                    &thread_profile_rejections,
                                    &thread_profile_refreshes,
                                );
                            }
                            thread_ready.0.store(true, Ordering::Release);
                        }
                        Err(error)
                            if progress.is_some()
                                || publish_profile
                                    && matches!(
                                        error.kind(),
                                        io::ErrorKind::WouldBlock | io::ErrorKind::TimedOut
                                    ) =>
                        {
                            let status = thread_heartbeat.snapshot();
                            let states = status["states"].as_u64().unwrap_or(0);
                            if states != last_states {
                                last_states = states;
                                let _ = send_request(
                                    &thread_manifest,
                                    "pulse",
                                    json!({
                                        "since_epoch": thread_applied_epoch.load(Ordering::Acquire),
                                        "solver": &status,
                                    }),
                                    response_limit,
                                );
                                if publish_profile {
                                    publish_target_observation(
                                        &thread_manifest,
                                        response_limit,
                                        &mut profile_publisher,
                                        &status,
                                        &thread_profile_updates,
                                        &thread_profile_rejections,
                                        &thread_profile_refreshes,
                                    );
                                }
                                let record = json!({
                                    "schema": "ergodis-progress-v0",
                                    "elapsed_ms": start.elapsed().as_millis(),
                                    "applied_epoch": thread_applied_epoch.load(Ordering::Acquire),
                                    "notified_epoch": notified_epoch,
                                    "solver": status,
                                });
                                if let Some(writer) = progress.as_mut() {
                                    if serde_json::to_writer(&mut *writer, &record).is_err()
                                        || writer.write_all(b"\n").is_err()
                                    {
                                        thread_failed.0.store(true, Ordering::Release);
                                        break;
                                    }
                                }
                            }
                        }
                        _ => {
                            thread_failed.0.store(true, Ordering::Release);
                            break;
                        }
                    }
                }
            })
            .map_err(|_| {
                unregister(&manifest, &endpoint, response_limit);
                AlignmentError::Control
            })?;
        Ok(Self {
            ready,
            failed,
            stop,
            heartbeat,
            notifications,
            profile_updates,
            profile_rejections,
            profile_refreshes,
            applied_epoch,
            exchange,
            endpoint,
            manifest,
            response_limit,
            handle: Some(handle),
        })
    }
}

impl Drop for SteeringWatcher {
    fn drop(&mut self) {
        self.stop.0.store(true, Ordering::Relaxed);
        if let Ok(socket) = UnixDatagram::unbound() {
            let _ = socket.send_to(&[0], &self.endpoint);
        }
        if let Some(handle) = self.handle.take() {
            let _ = handle.join();
        }
        unregister(&self.manifest, &self.endpoint, self.response_limit);
    }
}

fn unregister(manifest: &Manifest, endpoint: &Path, response_limit: usize) {
    let _ = send_request(
        manifest,
        "watch-unregister",
        json!({"path": endpoint}),
        response_limit,
    );
    let _ = fs::remove_file(endpoint);
}

fn publish_target_observation(
    manifest: &Manifest,
    response_limit: usize,
    publisher: &mut AlignmentTargetPublisher,
    status: &serde_json::Value,
    updates: &AtomicU64,
    rejections: &AtomicU64,
    refreshes: &AtomicU64,
) {
    let Some(observation) = publisher.update(status) else {
        return;
    };
    let observed = send_request(
        manifest,
        "target-profile-observe",
        json!({
            "values": observation.values,
            "mass": observation.mass,
            "unit_cost": observation.unit_cost,
            "strategy": observation.strategy,
        }),
        response_limit,
    );
    let Ok(observed) = observed else {
        publisher.retry(observation.values);
        rejections.fetch_add(1, Ordering::Relaxed);
        return;
    };
    if !observed.ok {
        rejections.fetch_add(1, Ordering::Relaxed);
        return;
    }
    updates.fetch_add(1, Ordering::Relaxed);
    if let Ok(refresh) = send_request(
        manifest,
        "evolve-profile-refresh",
        json!({}),
        response_limit,
    ) {
        if refresh.ok && refresh.result["queued"].as_bool() == Some(true) {
            refreshes.fetch_add(1, Ordering::Relaxed);
        }
    }
}

fn prepare_latest(
    manifest: &Manifest,
    fields: &[String],
    response_limit: usize,
    heartbeat: &Heartbeat,
    exchange: &Mutex<PlanExchange>,
) -> Result<(), AlignmentError> {
    let mut arena = {
        let mut exchange = exchange.lock().map_err(|_| AlignmentError::Control)?;
        exchange
            .prepared
            .take()
            .or_else(|| exchange.recycled.take())
            .unwrap_or_else(|| PlanArena::new(response_limit))
    };
    arena
        .refresh_with_status(manifest, fields, Some(heartbeat.snapshot()))
        .map_err(|_| AlignmentError::Control)?;
    let mut exchange = exchange.lock().map_err(|_| AlignmentError::Control)?;
    if exchange.prepared.is_some() {
        return Err(AlignmentError::Control);
    }
    exchange.prepared = Some(arena);
    Ok(())
}

/// Alignment-attachment adapter for live ordering-plan injection. A watcher blocks on a Unix
/// datagram; a search thread executes one relaxed Boolean load per stride.
pub struct AlignmentCampaignControl {
    arena: PlanArena,
    watcher: SteeringWatcher,
    last_point: Option<AlignmentSearchPoint>,
}

impl AlignmentCampaignControl {
    pub fn new(
        manifest: Manifest,
        response_limit: usize,
        progress_path: Option<PathBuf>,
    ) -> Result<Self, AlignmentError> {
        Self::create(manifest, response_limit, progress_path, None)
    }

    pub fn new_profiled(
        manifest: Manifest,
        response_limit: usize,
        progress_path: Option<PathBuf>,
        policy: AlignmentProfilePolicy,
    ) -> Result<Self, AlignmentError> {
        Self::create(manifest, response_limit, progress_path, Some(policy))
    }

    fn create(
        manifest: Manifest,
        response_limit: usize,
        progress_path: Option<PathBuf>,
        profile_policy: Option<AlignmentProfilePolicy>,
    ) -> Result<Self, AlignmentError> {
        let fields: Arc<[String]> = Arc::from(
            ALIGNMENT_PLAN_FIELDS
                .iter()
                .map(|field| (*field).into())
                .collect::<Vec<String>>(),
        );
        let watcher = SteeringWatcher::spawn(
            manifest.clone(),
            response_limit,
            progress_path,
            fields,
            profile_policy,
        )?;
        Ok(Self {
            arena: PlanArena::new(response_limit),
            watcher,
            last_point: None,
        })
    }

    pub fn epoch(&self) -> u64 {
        self.arena.epoch()
    }

    pub fn notifications(&self) -> u64 {
        self.watcher.notifications.load(Ordering::Relaxed)
    }

    pub fn profile_updates(&self) -> u64 {
        self.watcher.profile_updates.load(Ordering::Relaxed)
    }

    pub fn profile_rejections(&self) -> u64 {
        self.watcher.profile_rejections.load(Ordering::Relaxed)
    }

    pub fn profile_refreshes(&self) -> u64 {
        self.watcher.profile_refreshes.load(Ordering::Relaxed)
    }

    fn ordering_plan(&self) -> Option<&CompiledPlan> {
        self.arena
            .plans()
            .iter()
            .find(|plan| plan.role == PlanRole::Ordering && plan.output == PlanOutput::Score)
    }
}

impl AlignmentSearchControl for AlignmentCampaignControl {
    #[inline(always)]
    fn steering_pending(&self) -> bool {
        self.watcher.failed.0.load(Ordering::Relaxed)
            || self.watcher.ready.0.load(Ordering::Relaxed)
    }

    fn safe_point(&mut self, point: AlignmentSearchPoint) -> Result<(), AlignmentError> {
        if self.watcher.failed.0.load(Ordering::Acquire) {
            return Err(AlignmentError::Control);
        }
        if self.watcher.ready.0.swap(false, Ordering::AcqRel) {
            let mut exchange = self
                .watcher
                .exchange
                .lock()
                .map_err(|_| AlignmentError::Control)?;
            if let Some(mut prepared) = exchange.prepared.take() {
                if exchange.recycled.is_some() {
                    exchange.prepared = Some(prepared);
                    return Err(AlignmentError::Control);
                }
                std::mem::swap(&mut self.arena, &mut prepared);
                exchange.recycled = Some(prepared);
            }
            self.watcher
                .applied_epoch
                .store(self.arena.epoch(), Ordering::Release);
        }
        self.last_point = Some(point);
        Ok(())
    }

    #[inline]
    fn heartbeat(&mut self, point: AlignmentSearchPoint) -> Result<(), AlignmentError> {
        self.watcher.heartbeat.publish(point);
        self.last_point = Some(point);
        Ok(())
    }

    #[inline]
    fn ordering_active(&self, root_candidate: Option<u32>, root_orbit: Option<u32>) -> bool {
        let Some(plan) = self.ordering_plan() else {
            return false;
        };
        let Some((field, mask)) = plan.scope_descriptor() else {
            return true;
        };
        let value = match field {
            7 => root_candidate,
            8 => root_orbit,
            _ => return true,
        };
        value.is_none_or(|value| value < 64 && mask >> value & 1 != 0)
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
            features.root_candidate.map_or(-1, i64::from),
            features.root_orbit.map_or(-1, i64::from),
            i64::from(features.root_ordinal),
            i64::from(features.root_total),
            i64::from(features.root_sized),
            i64::from(features.root_initial_unresolved),
            i64::from(features.root_initial_packing),
            i64::from(features.root_initial_branches),
        ])
        .map_err(|_| AlignmentError::Control)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn status(
        root_ordinal: u64,
        root_states: u64,
        root_initial_packing: u64,
        root_initial_branches: u64,
    ) -> serde_json::Value {
        json!({
            "root_orbit": 3,
            "root_ordinal": root_ordinal,
            "root_states": root_states,
            "root_initial_packing": root_initial_packing,
            "root_initial_branches": root_initial_branches,
            "root_sized": true,
        })
    }

    #[test]
    fn target_publisher_is_absolute_idempotent_and_shape_routed() {
        let mut publisher = AlignmentTargetPublisher::new(AlignmentProfilePolicy::default());
        let first = publisher.update(&status(1, 10, 1, 4)).unwrap();
        assert_eq!(first.values, [3, 1, 1]);
        assert_eq!((first.mass, first.unit_cost), (1, 10));
        assert_eq!(first.strategy, "numeric");
        assert!(publisher.update(&status(1, 10, 1, 4)).is_none());
        publisher.retry(first.values);
        assert!(publisher.update(&status(1, 10, 1, 4)).is_some());

        let grown = publisher.update(&status(1, 12, 1, 4)).unwrap();
        assert_eq!((grown.mass, grown.unit_cost), (1, 12));
        let second_root = publisher.update(&status(2, 3, 1, 4)).unwrap();
        assert_eq!((second_root.mass, second_root.unit_cost), (2, 12));

        let structural = publisher.update(&status(3, 7, 3, 2)).unwrap();
        assert_eq!(structural.values, [3, 3, 1]);
        assert_eq!(structural.strategy, "structural");
    }

    #[test]
    fn target_publisher_reaches_the_campaign_accumulator() {
        let unique = WATCH_IDS.fetch_add(1, Ordering::Relaxed);
        let root = std::env::temp_dir().join(format!(
            "ergodis-alignment-profile-{}-{unique}",
            std::process::id()
        ));
        std::fs::create_dir(&root).unwrap();
        let data = root.join("features.jsonl");
        std::fs::write(
            &data,
            concat!(
                "{\"schema\":\"ergodis-campaign-data-v0\",\"presentation\":\"alignment-profile\",\"problem\":\"publisher\",\"fields\":[\"root_orbit\",\"root_initial_packing\",\"root_sized\"],\"rows\":1}\n",
                "{\"id\":0,\"expected\":false,\"values\":[3,1,1]}\n"
            ),
        )
        .unwrap();
        let campaign = ergodis::control::Campaign::create(
            &data,
            &root.join("run"),
            Some(root.join("control.sock")),
            16_384,
            8_192,
            16_384,
        )
        .unwrap();
        let manifest = campaign.manifest().clone();
        let server = std::thread::spawn(move || campaign.serve());
        for _ in 0..10_000 {
            if send_request(&manifest, "capabilities", json!({}), 8_192).is_ok() {
                break;
            }
            std::thread::yield_now();
        }
        let reset = send_request(
            &manifest,
            "target-profile-reset",
            json!({"fields": ALIGNMENT_TARGET_FIELDS}),
            8_192,
        )
        .unwrap();
        assert!(reset.ok, "{}", reset.result);
        let updates = AtomicU64::new(0);
        let rejections = AtomicU64::new(0);
        let refreshes = AtomicU64::new(0);
        let mut publisher = AlignmentTargetPublisher::new(AlignmentProfilePolicy::default());
        publish_target_observation(
            &manifest,
            8_192,
            &mut publisher,
            &status(1, 10, 1, 4),
            &updates,
            &rejections,
            &refreshes,
        );
        assert_eq!(updates.load(Ordering::Relaxed), 1);
        assert_eq!(rejections.load(Ordering::Relaxed), 0);
        assert_eq!(refreshes.load(Ordering::Relaxed), 0);
        let profile = send_request(&manifest, "target-profile-status", json!({}), 8_192).unwrap();
        assert!(profile.ok, "{}", profile.result);
        assert_eq!(profile.result["nodes"], 1);
        let stopped = send_request(&manifest, "shutdown", json!({}), 8_192).unwrap();
        assert!(stopped.ok, "{}", stopped.result);
        server.join().unwrap().unwrap();
        std::fs::remove_dir_all(root).unwrap();
    }
}
