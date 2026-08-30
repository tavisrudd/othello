use ergodis::control::{
    send_request, CompiledPlan, Manifest, PlanArena, PlanOutput, PlanRole,
};
use ergodis::{
    AlignmentBranchFeatures, AlignmentError, AlignmentSearchControl, AlignmentSearchPoint,
};
use serde_json::json;
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

static WATCH_IDS: AtomicU64 = AtomicU64::new(0);

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
    ) -> Result<Self, AlignmentError> {
        let ready = Arc::new(PaddedFlag(AtomicBool::new(false)));
        let failed = Arc::new(PaddedFlag(AtomicBool::new(false)));
        let stop = Arc::new(PaddedFlag(AtomicBool::new(false)));
        let heartbeat = Arc::new(Heartbeat::new());
        let notifications = Arc::new(AtomicU64::new(0));
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
        let thread_ready = Arc::clone(&ready);
        let thread_failed = Arc::clone(&failed);
        let thread_stop = Arc::clone(&stop);
        let thread_notifications = Arc::clone(&notifications);
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
                            thread_ready.0.store(true, Ordering::Release);
                        }
                        Err(error)
                            if progress.is_some()
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
                                let record = json!({
                                    "schema": "ergodis-progress-v0",
                                    "elapsed_ms": start.elapsed().as_millis(),
                                    "applied_epoch": thread_applied_epoch.load(Ordering::Acquire),
                                    "notified_epoch": notified_epoch,
                                    "solver": status,
                                });
                                let Some(writer) = progress.as_mut() else {
                                    unreachable!()
                                };
                                if serde_json::to_writer(&mut *writer, &record).is_err()
                                    || writer.write_all(b"\n").is_err()
                                {
                                    thread_failed.0.store(true, Ordering::Release);
                                    break;
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
        let fields: Arc<[String]> = Arc::from(
            ALIGNMENT_PLAN_FIELDS
                .iter()
                .map(|field| (*field).into())
                .collect::<Vec<String>>(),
        );
        let watcher =
            SteeringWatcher::spawn(manifest.clone(), response_limit, progress_path, fields)?;
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
