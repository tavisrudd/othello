//! A counting global allocator, used to reject any encoder candidate whose
//! decode or probe path allocates.
//!
//! The public core's allocation harness is crate-private, so this spike carries
//! its own. The non-measuring path is one relaxed load, so the allocator is
//! inert for every other `ergodis-tools` subcommand.

use std::alloc::{GlobalAlloc, Layout, System};
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};

static MEASURING: AtomicBool = AtomicBool::new(false);
static EVENTS: AtomicU64 = AtomicU64::new(0);

/// Registered as the global allocator only outside `cfg(test)`, where the
/// public core installs its own; the counters below still work in either build.
#[cfg_attr(test, allow(dead_code))]
pub struct CountingAllocator;

unsafe impl GlobalAlloc for CountingAllocator {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        if MEASURING.load(Ordering::Relaxed) {
            EVENTS.fetch_add(1, Ordering::Relaxed);
        }
        // SAFETY: the layout is forwarded unchanged to the system allocator.
        unsafe { System.alloc(layout) }
    }

    unsafe fn dealloc(&self, pointer: *mut u8, layout: Layout) {
        if MEASURING.load(Ordering::Relaxed) {
            EVENTS.fetch_add(1, Ordering::Relaxed);
        }
        // SAFETY: the pointer and layout come from a matching `alloc`.
        unsafe { System.dealloc(pointer, layout) }
    }

    unsafe fn realloc(&self, pointer: *mut u8, layout: Layout, new_size: usize) -> *mut u8 {
        if MEASURING.load(Ordering::Relaxed) {
            EVENTS.fetch_add(1, Ordering::Relaxed);
        }
        // SAFETY: the pointer and layout come from a matching `alloc`.
        unsafe { System.realloc(pointer, layout, new_size) }
    }
}

/// Run `body` with allocation counting on, returning its value and the number
/// of allocator events observed. Single-threaded use only.
pub fn measure<T>(body: impl FnOnce() -> T) -> (T, u64) {
    EVENTS.store(0, Ordering::Relaxed);
    MEASURING.store(true, Ordering::Relaxed);
    let value = body();
    MEASURING.store(false, Ordering::Relaxed);
    (value, EVENTS.load(Ordering::Relaxed))
}
