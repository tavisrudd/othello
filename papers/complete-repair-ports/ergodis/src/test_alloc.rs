//! Test-only allocation instrumentation for solve-loop invariants.

use std::alloc::{GlobalAlloc, Layout, System};
use std::cell::Cell;
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::{Mutex, MutexGuard};

struct HotLoopCountingAllocator;

thread_local! {
    static COUNT_HOT_LOOP_ALLOCATIONS: Cell<bool> = const { Cell::new(false) };
}

static HOT_LOOP_ALLOCATIONS: AtomicU64 = AtomicU64::new(0);
static HOT_LOOP_REALLOCATIONS: AtomicU64 = AtomicU64::new(0);
static HOT_LOOP_DEALLOCATIONS: AtomicU64 = AtomicU64::new(0);
static MEASUREMENT_LOCK: Mutex<()> = Mutex::new(());

fn count_hot_loop_event(counter: &AtomicU64) {
    let _ = COUNT_HOT_LOOP_ALLOCATIONS.try_with(|enabled| {
        if enabled.get() {
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

pub(crate) struct HotLoopAllocationGuard;

impl HotLoopAllocationGuard {
    pub(crate) fn enter() -> Self {
        COUNT_HOT_LOOP_ALLOCATIONS.with(|enabled| {
            assert!(!enabled.replace(true), "nested hot-loop allocation guard");
        });
        Self
    }
}

impl Drop for HotLoopAllocationGuard {
    fn drop(&mut self) {
        COUNT_HOT_LOOP_ALLOCATIONS.with(|enabled| enabled.set(false));
    }
}

pub(crate) fn measure_allocations<T>(operation: impl FnOnce() -> T) -> (T, AllocationEvents) {
    let _measurement = lock_measurement();
    HOT_LOOP_ALLOCATIONS.store(0, Ordering::Relaxed);
    HOT_LOOP_REALLOCATIONS.store(0, Ordering::Relaxed);
    HOT_LOOP_DEALLOCATIONS.store(0, Ordering::Relaxed);
    let result = operation();
    let events = AllocationEvents {
        allocations: HOT_LOOP_ALLOCATIONS.load(Ordering::Relaxed),
        reallocations: HOT_LOOP_REALLOCATIONS.load(Ordering::Relaxed),
        deallocations: HOT_LOOP_DEALLOCATIONS.load(Ordering::Relaxed),
    };
    (result, events)
}

fn lock_measurement() -> MutexGuard<'static, ()> {
    MEASUREMENT_LOCK
        .lock()
        .unwrap_or_else(std::sync::PoisonError::into_inner)
}
