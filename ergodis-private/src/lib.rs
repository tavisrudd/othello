// Fixed-array kernels deliberately use indexed loops and flat, explicit APIs:
// these shapes preserve bounded workspace, avoid iterator-state allocation, and
// make exact replay state visible.  The remaining allowances are analogous
// style diagnostics, not soundness or arithmetic diagnostics.
#![allow(
    clippy::double_must_use,
    clippy::int_plus_one,
    clippy::manual_is_multiple_of,
    clippy::manual_range_contains,
    clippy::mut_range_bound,
    clippy::needless_borrow,
    clippy::needless_range_loop,
    clippy::too_many_arguments,
    clippy::type_complexity
)]

pub mod alignment_control;
pub mod arith;
pub mod banked_rule_evolve;
pub mod banked_semantic_evolve;
pub mod binary_margin_lift;
pub mod bitset_sumset;
pub mod css_codes;
pub mod cyclic_polynomial_moment_evolve;
pub mod cyclic_quotient_defects;
pub mod cyclic_residual_features;
pub mod cyclic_residual_relation_evolve;
pub mod feature_synthesis;
pub mod g133_cycle_mod11_proof;
pub mod g133_evolve_adapter;
pub mod g133_exact_q2_proof;
pub mod g133_exact_shift_proof;
pub mod g133_sparse_defect;
pub mod g41_crt_allocation;
pub mod g41_defect_scout;
pub mod g41_digit_witness_cache;
pub mod g41_joint_quotient_search;
pub mod g41_q174_degree_fibre;
pub mod g41_q174_energy_theorem;
pub mod g41_q174_full_q87_join;
pub mod g41_q174_grouped_join;
pub mod g41_q174_joint;
pub mod g41_q174_joint_join;
pub mod g41_q29_aggregate_pair_graph;
pub mod g41_q29_energy_boxes;
pub mod g41_q29_evolve;
pub mod g41_q29_exact_tablebase;
pub mod g41_q29_fibre_endgame;
pub mod g41_q29_matched_pair_cache;
pub mod g41_q29_pair_target_cache;
pub mod g41_q29_pair_target_cycle;
pub mod g41_q29_profile_descent;
pub mod g41_q29_profile_endgame;
pub mod g41_q29_profile_lattice_proof;
pub mod g41_q29_profile_multiset;
pub mod g41_q29_profile_shard;
pub mod g41_q29_q58_energy;
pub mod g41_q29_shard_census;
pub mod g41_q29_signature_energy;
pub mod g41_q29_source_pair_graph;
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
pub mod gf2_linalg;
pub mod hadamard_2092;
pub mod hall_core;
pub mod landed_rank_adapter;
pub mod mask_cycle_proof;
pub mod order6_crt_residual;
pub mod order6_margin_evolve;
pub mod planted_gap_corpus;
pub mod predicate_cover;
pub mod projected_orbit_min_cost;
pub mod projective_grid;
pub mod proof_synthesis;
pub mod prs;
pub mod q16_quadratic;
pub mod q18_energy_corpus;
pub mod q18_energy_gate;
pub mod q18_local_repair;
pub mod q18_pair_split;
pub mod q18_q174_margin_lift;
pub mod q18_unassumed_evolve;
pub mod q19_marked_polar;
pub mod q25_pair_repair;
pub mod q29_complete_even_moments;
pub mod q29_even_moment_proof;
pub mod q29_exact_anneal;
pub mod q29_four_plus_one;
pub mod q29_inventory_scope;
pub mod q29_mod3_norm;
pub mod q29_mod9_generator;
pub mod q29_mod9_lift;
pub mod q29_pair_key_evolve;
pub mod q29_parity_support;
pub mod q29_psd_scope_proof;
pub mod q29_transfer_anneal;
pub mod quotient_paf_proof;
pub mod raw_feature_evolve;
pub mod reduction_proof;
pub mod semantic_plan;
pub mod semantic_rank;
pub mod semantic_sets;
pub mod semantic_theorems;
pub mod sparse_defect_synthesis;
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
