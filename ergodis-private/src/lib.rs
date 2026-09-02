pub mod banked_semantic_evolve;
pub mod bitset_sumset;
pub mod cyclic_residual_features;
pub mod feature_synthesis;
pub mod g41_defect_scout;
pub mod g41_digit_witness_cache;
pub mod g41_joint_quotient_search;
pub mod g41_q29_evolve;
pub mod g41_q29_exact_tablebase;
pub mod g53_defect_profile_proof;
pub mod g53_mod7_reduction;
pub mod g53_reduction_proof;
pub mod hadamard_2092;
pub mod hall_core;
pub mod landed_rank_adapter;
pub mod projective_grid;
pub mod proof_synthesis;
pub mod q16_quadratic;
pub mod q19_marked_polar;
pub mod q25_pair_repair;
pub mod quotient_paf_proof;
pub mod raw_feature_evolve;
pub mod reduction_proof;
pub mod semantic_plan;
pub mod semantic_rank;
pub mod semantic_sets;
pub mod semantic_theorems;
pub mod subgroup_energy_proof;
pub mod symmetric_feature_evolve;
pub mod tactical_completion;
pub mod two_adic_autocorrelation;
pub mod z2k_subgroup;

#[cfg(test)]
pub(crate) mod allocation_test {
    use std::alloc::{GlobalAlloc, Layout, System};
    use std::cell::Cell;

    struct CountingAllocator;

    thread_local! {
        static TRACKING: Cell<bool> = const { Cell::new(false) };
        static ALLOCATIONS: Cell<usize> = const { Cell::new(0) };
    }

    unsafe impl GlobalAlloc for CountingAllocator {
        unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
            TRACKING.with(|tracking| {
                if tracking.get() {
                    ALLOCATIONS.with(|allocations| allocations.set(allocations.get() + 1));
                }
            });
            unsafe { System.alloc(layout) }
        }

        unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
            TRACKING.with(|tracking| {
                if tracking.get() {
                    ALLOCATIONS.with(|allocations| allocations.set(allocations.get() + 1));
                }
            });
            unsafe { System.alloc_zeroed(layout) }
        }

        unsafe fn dealloc(&self, pointer: *mut u8, layout: Layout) {
            unsafe { System.dealloc(pointer, layout) }
        }

        unsafe fn realloc(&self, pointer: *mut u8, layout: Layout, size: usize) -> *mut u8 {
            TRACKING.with(|tracking| {
                if tracking.get() {
                    ALLOCATIONS.with(|allocations| allocations.set(allocations.get() + 1));
                }
            });
            unsafe { System.realloc(pointer, layout, size) }
        }
    }

    #[global_allocator]
    static ALLOCATOR: CountingAllocator = CountingAllocator;

    pub(crate) fn tracked_allocations<T>(operation: impl FnOnce() -> T) -> (T, usize) {
        ALLOCATIONS.with(|allocations| allocations.set(0));
        TRACKING.with(|tracking| tracking.set(true));
        let result = operation();
        TRACKING.with(|tracking| tracking.set(false));
        (result, ALLOCATIONS.with(Cell::get))
    }
}
