use ergodis::{CostTable, Gf4, Matrix, Prime, RankBoundedContextCache, RankOneProbeCache};
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
    let count = ALLOCATIONS.with(Cell::get);
    (result, count)
}

fn gf4_scalar_table(costs: &[u32]) -> CostTable {
    CostTable::from_entries_field::<Gf4>(
        1,
        1,
        costs.iter().enumerate().map(|(label, &cost)| {
            (
                Matrix::new_field::<Gf4>(1, 1, vec![label as u8]).unwrap(),
                cost,
            )
        }),
    )
    .unwrap()
}

#[test]
fn contextual_cache_scans_have_constant_allocation_envelopes() {
    let inner = gf4_scalar_table(&[0, 1, 1, 2]);
    let target = gf4_scalar_table(&[1, 0, 2, 1]);
    let dual =
        Matrix::new_field::<Gf4>(3, 5, vec![0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1]).unwrap();
    let mut projective = RankOneProbeCache::<Gf4>::new(&inner, &target, 5, 0, 2).unwrap();
    let (cold, cold_allocations) =
        tracked_allocations(|| projective.context_cost_cached(&dual).unwrap());
    let (warm, warm_allocations) =
        tracked_allocations(|| projective.context_cost_cached(&dual).unwrap());
    assert_eq!(cold.cost, warm.cost);
    assert_eq!(warm.work.cache_hits, warm.work.distinct_subspaces);
    assert!(
        cold_allocations <= 16,
        "projective cold scan allocated {cold_allocations} times"
    );
    assert!(
        warm_allocations <= 8,
        "projective warm scan allocated {warm_allocations} times"
    );

    let entries = (0u8..4).map(|bits| {
        let label = Matrix::new::<2>(1, 2, vec![bits & 1, (bits >> 1) & 1]).unwrap();
        let cost = label.as_slice().iter().filter(|&&value| value != 0).count() as u32;
        (label, cost)
    });
    let rank_two = CostTable::from_entries::<2>(1, 2, entries).unwrap();
    let dual = Matrix::new::<2>(3, 5, vec![0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1]).unwrap();
    let mut bounded =
        RankBoundedContextCache::<Prime<2>>::new(&rank_two, &rank_two, 5, 0, 2).unwrap();
    let (cold, cold_allocations) =
        tracked_allocations(|| bounded.context_cost_cached(&dual).unwrap());
    let (warm, warm_allocations) =
        tracked_allocations(|| bounded.context_cost_cached(&dual).unwrap());
    assert_eq!(cold.cost, warm.cost);
    assert_eq!(warm.work.cache_hits, warm.work.distinct_subspaces);
    assert!(
        cold_allocations <= 24,
        "rank-bounded cold scan allocated {cold_allocations} times"
    );
    assert!(
        warm_allocations <= 10,
        "rank-bounded warm scan allocated {warm_allocations} times"
    );
}
