use std::alloc::{GlobalAlloc, Layout, System};
use std::cell::Cell;

use ergodis_private::g41_quotient_filter_proof::{
    derive_g41_quotient_filter_rules_into, replay_g41_quotient_filter_rules,
};
use ergodis_private::g53_defect_profile_proof::{
    derive_g53_defect_rules_into, replay_g53_defect_rules,
};
use ergodis_private::g53_mod7_reduction::{derive_g53_mod7_rules_into, replay_g53_mod7_rules};
use ergodis_private::g53_reduction_proof::{derive_g53_rules_into, replay_g53_rules};
use ergodis_private::g53_search::{G53SearchConfig, G53SearchRunner};
use ergodis_private::g53_sparse_q4_proof::{
    derive_g53_sparse_q4_rules_into, replay_g53_sparse_q4_rules,
};
use ergodis_private::g91_defect_obstruction::{
    derive_g91_defect_rules_into, replay_g91_defect_rules,
};
use ergodis_private::proof_synthesis::RuleApplication;
use ergodis_private::quotient_paf_proof::{
    derive_quotient_paf_rules_into, replay_quotient_paf_rules,
};
use ergodis_private::reduction_proof::{
    derive_generator_91_rule_transcript_into, replay_generator_91_rule_transcript,
};
use ergodis_private::subgroup_energy_proof::{
    derive_subgroup_energy_rules_into, replay_subgroup_energy_rules,
};

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

    unsafe fn dealloc(&self, pointer: *mut u8, layout: Layout) {
        unsafe { System.dealloc(pointer, layout) }
    }

    unsafe fn realloc(&self, pointer: *mut u8, layout: Layout, size: usize) -> *mut u8 {
        record_allocation();
        unsafe { System.realloc(pointer, layout, size) }
    }
}

#[global_allocator]
static ALLOCATOR: CountingAllocator = CountingAllocator;

fn tracked_allocations<T>(operation: impl FnOnce() -> T) -> (T, usize) {
    ALLOCATIONS.with(|allocations| allocations.set(0));
    TRACKING.with(|tracking| tracking.set(true));
    let result = operation();
    TRACKING.with(|tracking| tracking.set(false));
    let allocations = ALLOCATIONS.with(Cell::get);
    (result, allocations)
}

#[test]
fn q29_closure_and_replay_kernels_allocate_nothing() {
    let mut workspace = [RuleApplication::EMPTY; 7];
    let ((facts, used), derive_allocations) =
        tracked_allocations(|| derive_generator_91_rule_transcript_into(&mut workspace).unwrap());
    assert_eq!(facts, 0x1ff);
    assert_eq!(used, 7);
    assert_eq!(derive_allocations, 0);

    let (replayed, replay_allocations) =
        tracked_allocations(|| replay_generator_91_rule_transcript(&workspace).unwrap());
    assert_eq!(replayed, facts);
    assert_eq!(replay_allocations, 0);
}

#[test]
fn g53_proof_rule_kernels_allocate_nothing() {
    let mut workspace = [RuleApplication::EMPTY; 7];
    let ((facts, used), derive_allocations) =
        tracked_allocations(|| derive_g53_rules_into(&mut workspace).unwrap());
    assert_eq!(used, workspace.len());
    assert_eq!(derive_allocations, 0);

    let (replayed, replay_allocations) =
        tracked_allocations(|| replay_g53_rules(&workspace).unwrap());
    assert_eq!(replayed, facts);
    assert_eq!(replay_allocations, 0);
}

#[test]
fn subgroup_energy_proof_kernels_allocate_nothing() {
    let mut workspace = [RuleApplication::EMPTY; 4];
    let ((facts, used), derive_allocations) =
        tracked_allocations(|| derive_subgroup_energy_rules_into(&mut workspace).unwrap());
    assert_eq!(used, workspace.len());
    assert_eq!(derive_allocations, 0);

    let (replayed, replay_allocations) =
        tracked_allocations(|| replay_subgroup_energy_rules(&workspace).unwrap());
    assert_eq!(replayed, facts);
    assert_eq!(replay_allocations, 0);
}

#[test]
fn quotient_paf_proof_kernels_allocate_nothing() {
    let mut workspace = [RuleApplication::EMPTY; 4];
    let ((facts, used), derive_allocations) =
        tracked_allocations(|| derive_quotient_paf_rules_into(&mut workspace).unwrap());
    assert_eq!(used, workspace.len());
    assert_eq!(derive_allocations, 0);

    let (replayed, replay_allocations) =
        tracked_allocations(|| replay_quotient_paf_rules(&workspace).unwrap());
    assert_eq!(replayed, facts);
    assert_eq!(replay_allocations, 0);
}

#[test]
fn g53_defect_proof_kernels_allocate_nothing() {
    let mut workspace = [RuleApplication::EMPTY; 6];
    let ((facts, used), derive_allocations) =
        tracked_allocations(|| derive_g53_defect_rules_into(&mut workspace).unwrap());
    assert_eq!(used, workspace.len());
    assert_eq!(derive_allocations, 0);

    let (replayed, replay_allocations) =
        tracked_allocations(|| replay_g53_defect_rules(&workspace).unwrap());
    assert_eq!(replayed, facts);
    assert_eq!(replay_allocations, 0);
}

#[test]
fn g53_sparse_q4_proof_kernels_allocate_nothing() {
    let mut workspace = [RuleApplication::EMPTY; 6];
    let ((facts, used), derive_allocations) =
        tracked_allocations(|| derive_g53_sparse_q4_rules_into(&mut workspace).unwrap());
    assert_eq!(used, workspace.len());
    assert_eq!(derive_allocations, 0);

    let (replayed, replay_allocations) =
        tracked_allocations(|| replay_g53_sparse_q4_rules(&workspace).unwrap());
    assert_eq!(replayed, facts);
    assert_eq!(replay_allocations, 0);
}

#[test]
fn g91_defect_proof_kernels_allocate_nothing() {
    let mut workspace = [RuleApplication::EMPTY; 6];
    let ((facts, used), derive_allocations) =
        tracked_allocations(|| derive_g91_defect_rules_into(&mut workspace).unwrap());
    assert_eq!(used, workspace.len());
    assert_eq!(derive_allocations, 0);

    let (replayed, replay_allocations) =
        tracked_allocations(|| replay_g91_defect_rules(&workspace).unwrap());
    assert_eq!(replayed, facts);
    assert_eq!(replay_allocations, 0);
}

#[test]
fn g41_quotient_filter_proof_kernels_allocate_nothing() {
    let mut workspace = [RuleApplication::EMPTY; 6];
    let ((facts, used), derive_allocations) =
        tracked_allocations(|| derive_g41_quotient_filter_rules_into(&mut workspace).unwrap());
    assert_eq!(used, workspace.len());
    assert_eq!(derive_allocations, 0);

    let (replayed, replay_allocations) =
        tracked_allocations(|| replay_g41_quotient_filter_rules(&workspace).unwrap());
    assert_eq!(replayed, facts);
    assert_eq!(replay_allocations, 0);
}

#[test]
fn g53_mod7_proof_kernels_allocate_nothing() {
    let mut workspace = [RuleApplication::EMPTY; 8];
    let ((facts, used), derive_allocations) =
        tracked_allocations(|| derive_g53_mod7_rules_into(&mut workspace).unwrap());
    assert_eq!(used, workspace.len());
    assert_eq!(derive_allocations, 0);

    let (replayed, replay_allocations) =
        tracked_allocations(|| replay_g53_mod7_rules(&workspace).unwrap());
    assert_eq!(replayed, facts);
    assert_eq!(replay_allocations, 0);
}

#[test]
fn g53_mutation_kernel_allocates_nothing() {
    let mut runner = G53SearchRunner::compile().unwrap();
    let stop = std::sync::atomic::AtomicBool::new(false);
    let (outcome, allocations) = tracked_allocations(|| {
        runner
            .run(
                G53SearchConfig {
                    seed: 19,
                    iterations: 10_000,
                    restart_after: 20_000,
                    ..G53SearchConfig::default()
                },
                &stop,
            )
            .unwrap()
    });
    assert!(outcome.witness.is_none());
    assert_eq!(outcome.iterations, 10_000);
    assert_eq!(allocations, 0);
}

#[test]
fn g53_quotient_shell_miner_allocates_nothing() {
    let mut runner = G53SearchRunner::compile().unwrap();
    let stop = std::sync::atomic::AtomicBool::new(false);
    let (outcome, allocations) = tracked_allocations(|| {
        runner
            .run(
                G53SearchConfig {
                    seed: 2092,
                    iterations: 10_000,
                    initial_shift_orbits: 0,
                    initial_quotient_shifts: 1,
                    subgroup_energy_weight: 0,
                    restart_after: 20_000,
                    stop_at_quotient_shell: true,
                    mod7_locked: true,
                    cross_block_move_interval: 8,
                    quotient_slot_swap_interval: 4,
                    ..G53SearchConfig::default()
                },
                &stop,
            )
            .unwrap()
    });
    assert!(outcome.iterations <= 10_000);
    assert_eq!(allocations, 0);
}

#[test]
fn g53_mod49_seeded_shell_miner_allocates_nothing() {
    let mut runner = G53SearchRunner::compile_with_mod49_q7_seed().unwrap();
    let stop = std::sync::atomic::AtomicBool::new(false);
    let (outcome, allocations) = tracked_allocations(|| {
        runner
            .run(
                G53SearchConfig {
                    seed: 49_2092,
                    iterations: 10_000,
                    initial_shift_orbits: 0,
                    initial_quotient_shifts: 1,
                    subgroup_energy_weight: 0,
                    restart_after: 20_000,
                    stop_at_quotient_shell: true,
                    mod7_locked: true,
                    mod49_q7_seed: true,
                    ..G53SearchConfig::default()
                },
                &stop,
            )
            .unwrap()
    });
    assert!(outcome.iterations <= 10_000);
    assert_eq!(allocations, 0);
}

#[test]
fn g53_diverse_q0_shell_miner_allocates_nothing() {
    let mut runner = G53SearchRunner::compile_with_diverse_q0_bank().unwrap();
    let stop = std::sync::atomic::AtomicBool::new(false);
    let (outcome, allocations) = tracked_allocations(|| {
        runner
            .run(
                G53SearchConfig {
                    seed: 7_2092,
                    iterations: 10_000,
                    initial_shift_orbits: 0,
                    initial_quotient_shifts: 1,
                    subgroup_energy_weight: 0,
                    restart_after: 20_000,
                    stop_at_quotient_shell: true,
                    mod7_locked: true,
                    ..G53SearchConfig::default()
                },
                &stop,
            )
            .unwrap()
    });
    assert!(outcome.iterations <= 10_000);
    assert_eq!(allocations, 0);
}
