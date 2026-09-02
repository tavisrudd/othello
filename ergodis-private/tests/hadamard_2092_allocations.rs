use ergodis_private::hadamard_2092::{write_bordered_pair_residual, JointD9D6MarginalTable};
use std::alloc::{GlobalAlloc, Layout, System};
use std::cell::Cell;

struct CountingAllocator;

thread_local! {
    static TRACKING: Cell<bool> = const { Cell::new(false) };
    static ALLOCATIONS: Cell<usize> = const { Cell::new(0) };
}

fn record_allocation() {
    TRACKING.with(|tracking| {
        if tracking.get() {
            ALLOCATIONS.with(|allocations| allocations.set(allocations.get() + 1));
        }
    });
}

unsafe impl GlobalAlloc for CountingAllocator {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        record_allocation();
        unsafe { System.alloc(layout) }
    }

    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        record_allocation();
        unsafe { System.alloc_zeroed(layout) }
    }

    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        unsafe { System.dealloc(ptr, layout) }
    }

    unsafe fn realloc(&self, ptr: *mut u8, layout: Layout, new_size: usize) -> *mut u8 {
        record_allocation();
        unsafe { System.realloc(ptr, layout, new_size) }
    }
}

#[global_allocator]
static ALLOCATOR: CountingAllocator = CountingAllocator;

struct TrackingGuard;

impl Drop for TrackingGuard {
    fn drop(&mut self) {
        TRACKING.with(|tracking| tracking.set(false));
    }
}

fn tracked_allocations<T>(operation: impl FnOnce() -> T) -> (T, usize) {
    ALLOCATIONS.with(|allocations| allocations.set(0));
    TRACKING.with(|tracking| tracking.set(true));
    let guard = TrackingGuard;
    let result = operation();
    drop(guard);
    (result, ALLOCATIONS.with(Cell::get))
}

#[test]
fn order_2092_marginal_and_residual_queries_allocate_nothing() {
    let table = JointD9D6MarginalTable::compile().unwrap();
    let signature = [0_i32, 8];
    let mut residual = [0_i32; 2];
    let (checksum, allocations) = tracked_allocations(|| {
        let mut checksum = 0_u64;
        for _ in 0..1_000 {
            checksum += u64::from(table.fibres([1, -1], [0, 0, 0]));
            write_bordered_pair_residual(&signature, &mut residual).unwrap();
        }
        checksum
    });
    assert_eq!(checksum, 12_000);
    assert_eq!(residual, [-4, -12]);
    assert_eq!(allocations, 0);
}
