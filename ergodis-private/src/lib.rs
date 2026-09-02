pub mod banked_rule_evolve;
pub mod banked_semantic_evolve;
pub mod bitset_sumset;
pub mod cyclic_quotient_defects;
pub mod cyclic_residual_features;
pub mod feature_synthesis;
pub mod g133_cycle_mod11_proof;
pub mod g133_evolve_adapter;
pub mod g133_exact_q2_proof;
pub mod g133_exact_shift_proof;
pub mod g133_sparse_defect;
pub mod g41_defect_scout;
pub mod g41_digit_witness_cache;
pub mod g41_joint_quotient_search;
pub mod g41_q174_full_q87_join;
pub mod g41_q174_grouped_join;
pub mod g41_q174_joint;
pub mod g41_q174_joint_join;
pub mod g41_q29_evolve;
pub mod g41_q29_exact_tablebase;
pub mod g41_q29_pair_target_cache;
pub mod g41_q29_profile_descent;
pub mod g41_q29_profile_shard;
pub mod g41_q58_exact_tablebase;
pub mod g41_q58_gram_masks;
pub mod g41_q58_profile_join;
pub mod g41_q87_energy;
pub mod g41_q87_exact_energy;
pub mod g41_quotient_filter_proof;
pub mod g53_defect_profile_proof;
pub mod g53_mod14_reduction;
pub mod g53_mod28_reduction;
pub mod g53_mod343_scout;
pub mod g53_mod49_high_scout;
pub mod g53_mod49_reduction;
pub mod g53_mod7_reduction;
pub mod g53_q0_diverse;
pub mod g53_q4_profiles;
pub mod g53_reduction_proof;
pub mod g53_search;
pub mod g53_sparse_defect;
pub mod g53_sparse_dual;
pub mod g53_sparse_prefix;
pub mod g53_sparse_q4_oracle;
pub mod g53_sparse_q4_proof;
pub mod g91_defect_obstruction;
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
