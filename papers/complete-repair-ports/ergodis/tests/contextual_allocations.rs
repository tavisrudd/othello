use ergodis::observational::{
    compile_layered_observational, compile_observational_with_policy, CertificatePolicy,
    FinitePresentation, GeneratorSpec, LayeredGeneratorSpec,
};
use ergodis::{
    compile_verified_explicit_binary_support, BinarySupportCandidate, CanonicalContextBasis,
    CostTable, DenseSelector, ExplicitBinarySupportProblem, FinitePermutationAction, Gf4, Matrix,
    Prime, RankBoundedContextCache, RankOneProbeCache, SparseSelector,
};
use std::alloc::{GlobalAlloc, Layout, System};
use std::cell::Cell;
use std::convert::Infallible;

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

struct ThreeCycle;

impl FinitePermutationAction for ThreeCycle {
    type Error = Infallible;

    fn point_count(&self) -> u32 {
        3
    }

    fn generator_count(&self) -> u32 {
        1
    }

    fn apply(&self, _generator: u32, point: u32) -> Result<u32, Self::Error> {
        Ok((point + 1) % 3)
    }
}

#[test]
fn verified_semantic_symmetry_evaluation_allocates_nothing() {
    let candidates = vec![
        BinarySupportCandidate::new(0b001, 7),
        BinarySupportCandidate::new(0b010, 7),
        BinarySupportCandidate::new(0b100, 7),
        BinarySupportCandidate::new(0b011, 9),
        BinarySupportCandidate::new(0b110, 9),
        BinarySupportCandidate::new(0b101, 9),
    ];
    let problem = ExplicitBinarySupportProblem::new(3, candidates).unwrap();
    let verified = compile_verified_explicit_binary_support(&ThreeCycle, problem).unwrap();

    let (answer, allocations) = tracked_allocations(|| verified.anchored_minimum());
    assert_eq!(answer.unwrap().candidate().cost(), 7);
    assert_eq!(allocations, 0);

    let subproblem = verified.cover().subproblems().next().unwrap();
    let result = verified.backend_result(subproblem, 0).unwrap();
    let (_, boundary_allocations) = tracked_allocations(|| {
        verified
            .write_anchored_lp(subproblem, &mut std::io::sink())
            .unwrap();
        verified.verify_backend_result(result).unwrap();
        verified.verify_complete_backend_results(&[result]).unwrap();
    });
    assert_eq!(boundary_allocations, 0);
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

fn distinguishing_chain(states: u32) -> FinitePresentation {
    let mut observations = vec![0; states as usize];
    observations[states as usize - 1] = 1;
    FinitePresentation::new(
        [states],
        observations,
        [GeneratorSpec {
            source_sort: 0,
            target_sort: 0,
            transitions: (0..states)
                .map(|state| (state + 1).min(states - 1))
                .collect::<Vec<_>>()
                .into_boxed_slice(),
        }],
    )
    .unwrap()
}

fn four_generator_fixture(states: u32) -> FinitePresentation {
    let mut observations = vec![0; states as usize];
    observations[states as usize - 1] = 1;
    let generators = (0..4_u64)
        .map(|generator| {
            let mut random = 0x9e37_79b9_7f4a_7c15_u64 ^ generator;
            let transitions = (0..states)
                .map(|_| {
                    random ^= random << 13;
                    random ^= random >> 7;
                    random ^= random << 17;
                    (random % u64::from(states)) as u32
                })
                .collect::<Vec<_>>()
                .into_boxed_slice();
            GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions,
            }
        })
        .collect::<Vec<_>>();
    FinitePresentation::new([states], observations, generators).unwrap()
}

#[test]
fn observational_worklist_has_no_per_split_allocation_growth() {
    let small = distinguishing_chain(64);
    let large = distinguishing_chain(1_024);
    let (_, small_allocations) = tracked_allocations(|| {
        compile_observational_with_policy(&small, CertificatePolicy::SplitTranscript).unwrap()
    });
    let (_, large_allocations) = tracked_allocations(|| {
        compile_observational_with_policy(&large, CertificatePolicy::SplitTranscript).unwrap()
    });

    assert!(
        large_allocations <= small_allocations + 2,
        "worklist allocations grew from {small_allocations} to {large_allocations}"
    );
}

#[test]
fn observational_multiway_has_no_per_event_allocation_growth() {
    let small = four_generator_fixture(64);
    let large = four_generator_fixture(1_024);
    let (_, small_allocations) = tracked_allocations(|| {
        compile_observational_with_policy(&small, CertificatePolicy::MultiwayTranscript).unwrap()
    });
    let (_, large_allocations) = tracked_allocations(|| {
        compile_observational_with_policy(&large, CertificatePolicy::MultiwayTranscript).unwrap()
    });

    assert!(
        large_allocations <= small_allocations + 2,
        "multiway allocations grew from {small_allocations} to {large_allocations}"
    );
}

#[test]
fn layered_compiler_has_no_per_state_allocation_growth() {
    let generators = [LayeredGeneratorSpec {
        source_sort: 0,
        target_sort: 1,
    }];
    let (_, small_allocations) = tracked_allocations(|| {
        compile_layered_observational(
            &[64, 64],
            &generators,
            |_, state| state % 7,
            |_, state| state,
        )
        .unwrap()
    });
    let (_, large_allocations) = tracked_allocations(|| {
        compile_layered_observational(
            &[4_096, 4_096],
            &generators,
            |_, state| state % 7,
            |_, state| state,
        )
        .unwrap()
    });
    assert!(
        large_allocations <= small_allocations + 2,
        "layered allocations grew from {small_allocations} to {large_allocations}"
    );
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

#[test]
fn frozen_envelope_canonical_query_allocates_nothing() {
    let entries = (0u8..4).map(|bits| {
        let label = Matrix::new::<2>(1, 2, vec![bits & 1, (bits >> 1) & 1]).unwrap();
        let cost = label.as_slice().iter().filter(|&&value| value != 0).count() as u32;
        (label, cost)
    });
    let rank_two = CostTable::from_entries::<2>(1, 2, entries).unwrap();
    let mut cache =
        RankBoundedContextCache::<Prime<2>>::new(&rank_two, &rank_two, 5, 0, 2).unwrap();
    let envelope = cache.compile_frozen_full_span_envelope(4, 307).unwrap();
    let context = Matrix::new::<2>(
        4,
        5,
        vec![0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1],
    )
    .unwrap();
    let canonical = CanonicalContextBasis::new::<Prime<2>>(&context, 5, 0).unwrap();
    let (answer, allocations) =
        tracked_allocations(|| envelope.context_cost_canonical(&canonical).unwrap());
    assert_eq!(answer.context_rank, 4);
    assert_eq!(allocations, 0);
}

#[test]
fn successive_selector_allocates_only_its_returned_assignment() {
    let selector = DenseSelector::<Prime<5>>::new([1, 1], [0, 1, 1, 0]).unwrap();
    let mut workspace = selector.workspace();
    let (answer, allocations) =
        tracked_allocations(|| selector.select_nonzero(&mut workspace).unwrap());
    assert_eq!(&*answer.assignment, &[0, 1]);
    assert!(
        allocations <= 1,
        "selector hot path allocated {allocations} times"
    );
}

#[test]
fn sparse_selector_allocates_only_its_returned_assignment() {
    let selector = SparseSelector::<Prime<5>>::new([1, 1], vec![(1, 1), (2, 1)]).unwrap();
    let mut workspace = selector.workspace();
    let (answer, allocations) =
        tracked_allocations(|| selector.select_nonzero(&mut workspace).unwrap());
    assert_eq!(&*answer.assignment, &[0, 1]);
    assert!(
        allocations <= 1,
        "sparse selector hot path allocated {allocations} times"
    );
}
