//! Test-only allocation instrumentation for solve-loop invariants.

use std::alloc::{GlobalAlloc, Layout, System};
use std::cell::Cell;
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::{Mutex, MutexGuard};

struct HotLoopCountingAllocator;

thread_local! {
    static CURRENT_MEASUREMENT: Cell<u64> = const { Cell::new(0) };
    static HOT_LOOP_GUARD_DEPTH: Cell<u32> = const { Cell::new(0) };
    static HOT_LOOP_MEASUREMENT: Cell<u64> = const { Cell::new(0) };
}

static NEXT_MEASUREMENT: AtomicU64 = AtomicU64::new(1);
static ACTIVE_MEASUREMENT: AtomicU64 = AtomicU64::new(0);
static HOT_LOOP_ALLOCATIONS: AtomicU64 = AtomicU64::new(0);
static HOT_LOOP_REALLOCATIONS: AtomicU64 = AtomicU64::new(0);
static HOT_LOOP_DEALLOCATIONS: AtomicU64 = AtomicU64::new(0);
static MEASUREMENT_LOCK: Mutex<()> = Mutex::new(());

fn count_hot_loop_event(counter: &AtomicU64) {
    let active = ACTIVE_MEASUREMENT.load(Ordering::Acquire);
    if active == 0 {
        return;
    }
    let _ = HOT_LOOP_MEASUREMENT.try_with(|measurement| {
        if measurement.get() == active {
            counter.fetch_add(1, Ordering::Relaxed);
        }
    });
}

unsafe impl GlobalAlloc for HotLoopCountingAllocator {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        count_hot_loop_event(&HOT_LOOP_ALLOCATIONS);
        unsafe { System.alloc(layout) }
    }

    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        count_hot_loop_event(&HOT_LOOP_ALLOCATIONS);
        unsafe { System.alloc_zeroed(layout) }
    }

    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        count_hot_loop_event(&HOT_LOOP_DEALLOCATIONS);
        unsafe { System.dealloc(ptr, layout) }
    }

    unsafe fn realloc(&self, ptr: *mut u8, layout: Layout, new_size: usize) -> *mut u8 {
        count_hot_loop_event(&HOT_LOOP_REALLOCATIONS);
        unsafe { System.realloc(ptr, layout, new_size) }
    }
}

#[global_allocator]
static HOT_LOOP_ALLOCATOR: HotLoopCountingAllocator = HotLoopCountingAllocator;

#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub(crate) struct AllocationEvents {
    pub(crate) allocations: u64,
    pub(crate) reallocations: u64,
    pub(crate) deallocations: u64,
}

#[derive(Clone, Copy)]
pub(crate) struct AllocationMeasurement(u64);

impl AllocationMeasurement {
    pub(crate) fn scope<T>(self, operation: impl FnOnce() -> T) -> T {
        let previous = CURRENT_MEASUREMENT.with(|current| current.replace(self.0));
        let _restore = MeasurementScope { previous };
        operation()
    }
}

struct MeasurementScope {
    previous: u64,
}

impl Drop for MeasurementScope {
    fn drop(&mut self) {
        CURRENT_MEASUREMENT.with(|current| current.set(self.previous));
    }
}

struct ActiveMeasurement;

impl ActiveMeasurement {
    fn begin(measurement: u64) -> Self {
        ACTIVE_MEASUREMENT.store(measurement, Ordering::Release);
        Self
    }
}

impl Drop for ActiveMeasurement {
    fn drop(&mut self) {
        ACTIVE_MEASUREMENT.store(0, Ordering::Release);
    }
}

pub(crate) fn current_measurement() -> AllocationMeasurement {
    AllocationMeasurement(CURRENT_MEASUREMENT.with(Cell::get))
}

pub(crate) struct HotLoopAllocationGuard;

impl HotLoopAllocationGuard {
    pub(crate) fn enter() -> Self {
        Self::enter_for(current_measurement())
    }

    pub(crate) fn enter_for(measurement: AllocationMeasurement) -> Self {
        HOT_LOOP_GUARD_DEPTH.with(|depth| {
            let current = depth.get();
            if current == 0 {
                HOT_LOOP_MEASUREMENT.with(|active| active.set(measurement.0));
            } else {
                HOT_LOOP_MEASUREMENT.with(|active| {
                    assert_eq!(active.get(), measurement.0, "nested measurement mismatch");
                });
            }
            depth.set(current.checked_add(1).expect("hot-loop guard overflow"));
        });
        Self
    }
}

impl Drop for HotLoopAllocationGuard {
    fn drop(&mut self) {
        HOT_LOOP_GUARD_DEPTH.with(|depth| {
            let current = depth.get();
            assert!(current != 0, "unbalanced hot-loop allocation guard");
            depth.set(current - 1);
            if current == 1 {
                HOT_LOOP_MEASUREMENT.with(|measurement| measurement.set(0));
            }
        });
    }
}

pub(crate) fn measure_allocations<T>(operation: impl FnOnce() -> T) -> (T, AllocationEvents) {
    let _measurement = lock_measurement();
    HOT_LOOP_ALLOCATIONS.store(0, Ordering::Relaxed);
    HOT_LOOP_REALLOCATIONS.store(0, Ordering::Relaxed);
    HOT_LOOP_DEALLOCATIONS.store(0, Ordering::Relaxed);
    let mut measurement = NEXT_MEASUREMENT.fetch_add(1, Ordering::Relaxed);
    if measurement == 0 {
        measurement = NEXT_MEASUREMENT.fetch_add(1, Ordering::Relaxed);
    }
    let active = ActiveMeasurement::begin(measurement);
    let result = AllocationMeasurement(measurement).scope(operation);
    drop(active);
    let events = AllocationEvents {
        allocations: HOT_LOOP_ALLOCATIONS.load(Ordering::Relaxed),
        reallocations: HOT_LOOP_REALLOCATIONS.load(Ordering::Relaxed),
        deallocations: HOT_LOOP_DEALLOCATIONS.load(Ordering::Relaxed),
    };
    (result, events)
}

/// Measure one caller-thread region with the same panic-safe guard used by
/// instrumented solve kernels. Worker threads must receive the measurement
/// identity explicitly through [`current_measurement`] and
/// [`HotLoopAllocationGuard::enter_for`]; this helper deliberately does not
/// pretend that thread-local state propagates automatically.
pub(crate) fn measure_current_thread_allocations<T>(
    operation: impl FnOnce() -> T,
) -> (T, AllocationEvents) {
    measure_allocations(|| {
        let _guard = HotLoopAllocationGuard::enter();
        operation()
    })
}

fn lock_measurement() -> MutexGuard<'static, ()> {
    MEASUREMENT_LOCK
        .lock()
        .unwrap_or_else(std::sync::PoisonError::into_inner)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn worker_events_require_and_obey_explicit_measurement_propagation() {
        let (_, unpropagated) = measure_allocations(|| {
            std::thread::scope(|scope| {
                scope
                    .spawn(|| std::hint::black_box(Box::new(7_u64)))
                    .join()
                    .unwrap();
            });
        });
        assert_eq!(unpropagated, AllocationEvents::default());

        let (_, propagated) = measure_allocations(|| {
            let measurement = current_measurement();
            std::thread::scope(|scope| {
                scope
                    .spawn(move || {
                        let _guard = HotLoopAllocationGuard::enter_for(measurement);
                        std::hint::black_box(Box::new(7_u64));
                    })
                    .join()
                    .unwrap();
            });
        });
        assert!(propagated.allocations > 0);
        assert!(propagated.deallocations > 0);
    }

    #[test]
    fn panicking_measurement_restores_the_allocator_state() {
        let failure = std::panic::catch_unwind(|| {
            measure_current_thread_allocations(|| panic!("intentional measurement failure"));
        });
        assert!(failure.is_err());
        let (_, events) = measure_current_thread_allocations(|| {});
        assert_eq!(events, AllocationEvents::default());
    }
}
