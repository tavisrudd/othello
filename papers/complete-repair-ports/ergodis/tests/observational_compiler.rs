use ergodis::observational::{
    compile_observational, compile_observational_with_policy, verify_compilation,
    CertificatePolicy, CompiledObservation, FinitePresentation, GeneratorSpec,
};
use ergodis::provenance::{ProvenanceArena, ProvenanceId, ReplaySidecar};
use ergodis::{CompositionAnswer, CompositionTable, CostTable, GeneratedSpanTable, Matrix};
use std::collections::{BTreeMap, BTreeSet};

const LIMIT: u32 = 4;
const INFINITY: u32 = LIMIT + 1;

const WTA_LEAF: u32 = 1_001;
const WTA_NODE: u32 = 1_002;
const RESOURCE_ASSIGNMENT: u32 = 2_001;
const RECOVERY_EQUATION: u32 = 3_001;
const HIERARCHY_LEAF: u32 = 3_002;
const HIERARCHY_NODE: u32 = 3_003;
const WTA_ADAPTER: u32 = 101;
const RESOURCE_ADAPTER: u32 = 102;
const RECOVERY_ADAPTER: u32 = 103;
const HIERARCHY_ADAPTER: u32 = 104;

type Valuation = [u32; 3];

#[derive(Clone)]
enum WtaTree {
    Leaf(Valuation),
    Node(Box<WtaTree>, Box<WtaTree>),
}

const TRANSITIONS: [&[(usize, usize, u32)]; 3] = [
    &[(0, 1, 1), (1, 0, 1), (2, 0, 2), (2, 2, 1)],
    &[(0, 1, 0), (1, 0, 2)],
    &[(0, 2, 2), (1, 1, 0), (1, 2, 0), (2, 1, 2), (2, 2, 2)],
];

fn saturated_sum(values: &[u32]) -> u32 {
    let sum: u32 = values.iter().sum();
    if sum > LIMIT {
        INFINITY
    } else {
        sum
    }
}

fn wta_product(left: Valuation, right: Valuation) -> Valuation {
    std::array::from_fn(|output| {
        TRANSITIONS[output]
            .iter()
            .map(|&(left_state, right_state, weight)| {
                saturated_sum(&[left[left_state], right[right_state], weight])
            })
            .min()
            .unwrap()
    })
}

fn wta_observation(value: Valuation) -> u32 {
    value
        .into_iter()
        .zip([1, 1, 3])
        .map(|(state, final_weight)| saturated_sum(&[state, final_weight]))
        .min()
        .unwrap()
}

fn wta_fixture() -> (FinitePresentation, Vec<Valuation>, Vec<WtaTree>) {
    let leaves = [[3, INFINITY, 1], [1, 3, 0], [3, 3, 4]];
    let mut witnesses: BTreeMap<Valuation, WtaTree> = leaves
        .into_iter()
        .map(|value| (value, WtaTree::Leaf(value)))
        .collect();
    loop {
        let old: Vec<_> = witnesses.keys().copied().collect();
        let mut additions = Vec::new();
        for &left in &old {
            for &right in &old {
                let value = wta_product(left, right);
                if !witnesses.contains_key(&value) {
                    additions.push((
                        value,
                        WtaTree::Node(
                            Box::new(witnesses[&left].clone()),
                            Box::new(witnesses[&right].clone()),
                        ),
                    ));
                }
            }
        }
        if additions.is_empty() {
            break;
        }
        for (value, witness) in additions {
            witnesses.entry(value).or_insert(witness);
        }
    }
    let states: Vec<_> = witnesses.keys().copied().collect();
    let trees = states
        .iter()
        .map(|state| witnesses[state].clone())
        .collect();
    let ids: BTreeMap<_, _> = states
        .iter()
        .copied()
        .enumerate()
        .map(|(index, state)| (state, index as u32))
        .collect();
    let mut generators = Vec::with_capacity(2 * states.len());
    for &coargument in &states {
        generators.push(GeneratorSpec {
            source_sort: 0,
            target_sort: 0,
            transitions: states
                .iter()
                .map(|&state| ids[&wta_product(state, coargument)])
                .collect(),
        });
        generators.push(GeneratorSpec {
            source_sort: 0,
            target_sort: 0,
            transitions: states
                .iter()
                .map(|&state| ids[&wta_product(coargument, state)])
                .collect(),
        });
    }
    let observations: Vec<_> = states.iter().copied().map(wta_observation).collect();
    let presentation =
        FinitePresentation::new([states.len() as u32], observations, generators).unwrap();
    (presentation, states, trees)
}

fn replay_wta_tree(tree: &WtaTree) -> Valuation {
    match tree {
        WtaTree::Leaf(value) => *value,
        WtaTree::Node(left, right) => wta_product(replay_wta_tree(left), replay_wta_tree(right)),
    }
}

fn replay_wta_run(tree: &WtaTree, output: usize) -> u32 {
    match tree {
        WtaTree::Leaf(value) => value[output],
        WtaTree::Node(left, right) => TRANSITIONS[output]
            .iter()
            .map(|&(left_output, right_output, weight)| {
                saturated_sum(&[
                    replay_wta_run(left, left_output),
                    replay_wta_run(right, right_output),
                    weight,
                ])
            })
            .min()
            .unwrap(),
    }
}

fn replay_optimal_wta_run(tree: &WtaTree) -> u32 {
    (0..3)
        .map(|output| saturated_sum(&[replay_wta_run(tree, output), [1, 1, 3][output]]))
        .min()
        .unwrap()
}

fn export_wta_tree(tree: &WtaTree, arena: &mut ProvenanceArena) -> ProvenanceId {
    match tree {
        WtaTree::Leaf(value) => arena.push(WTA_LEAF, value, &[]).unwrap(),
        WtaTree::Node(left, right) => {
            let left = export_wta_tree(left, arena);
            let right = export_wta_tree(right, arena);
            arena.push(WTA_NODE, &[], &[left, right]).unwrap()
        }
    }
}

fn replay_wta_provenance(arena: &ProvenanceArena, root: ProvenanceId) -> Valuation {
    let view = arena.get(root).unwrap();
    match view.kind() {
        WTA_LEAF => view.payload().try_into().unwrap(),
        WTA_NODE => {
            let children: Vec<_> = view.children().collect();
            assert_eq!(children.len(), 2);
            wta_product(
                replay_wta_provenance(arena, children[0]),
                replay_wta_provenance(arena, children[1]),
            )
        }
        kind => panic!("unknown WTA provenance kind {kind}"),
    }
}

fn replay_all_paths(
    presentation: &FinitePresentation,
    compiled: &CompiledObservation,
    paths: &[Vec<u32>],
) {
    for state in 0..presentation.state_count() as u32 {
        for path in paths {
            let mut concrete = state;
            let mut class = compiled.state_classes()[state as usize];
            let mut admitted = true;
            for &generator in path {
                let Some(next) = presentation.transition(generator, concrete) else {
                    admitted = false;
                    break;
                };
                concrete = next;
                class = compiled.transition(generator, class).unwrap();
            }
            if admitted {
                assert_eq!(
                    presentation.observations()[concrete as usize],
                    compiled.class_outputs()[class as usize]
                );
            }
        }
    }
}

fn assert_split_transcript(
    presentation: &FinitePresentation,
    exhaustive: &CompiledObservation,
    expected_splits: usize,
) -> CompiledObservation {
    let split = compile_observational_with_policy(presentation, CertificatePolicy::SplitTranscript)
        .unwrap();
    assert_eq!(split.state_classes(), exhaustive.state_classes());
    assert_eq!(split.class_ranges(), exhaustive.class_ranges());
    assert_eq!(split.class_outputs(), exhaustive.class_outputs());
    assert!(split.storage().certificate_bytes < exhaustive.storage().certificate_bytes);
    assert_eq!(split.split_records().len(), expected_splits);
    assert_eq!(split.storage().certificate_bytes, 16 * expected_splits);
    verify_compilation(presentation, &split).unwrap();
    split
}

#[test]
fn weighted_tree_automaton_compiles_to_six_exact_states() {
    let (presentation, states, trees) = wta_fixture();
    let compiled = compile_observational(&presentation).unwrap();
    verify_compilation(&presentation, &compiled).unwrap();
    let _split = assert_split_transcript(&presentation, &compiled, 2);

    assert_eq!(presentation.state_count(), 13);
    assert_eq!(presentation.generators().len(), 26);
    assert_eq!(compiled.metrics().classes, 6);
    assert_eq!(compiled.metrics().refinement_rounds, 1);
    assert_eq!(compiled.metrics().separators, 60);
    assert_eq!(compiled.metrics().separator_steps, 4);
    assert_eq!(compiled.storage().quotient_bytes, 1_148);
    assert_eq!(compiled.storage().certificate_bytes, 1_456);
    let mut sidecar = ReplaySidecar::new(presentation.fingerprint(), WTA_ADAPTER, INFINITY);
    for (&state, tree) in states.iter().zip(&trees) {
        assert_eq!(replay_wta_tree(tree), state);
        assert_eq!(replay_optimal_wta_run(tree), wta_observation(state));
        let root = export_wta_tree(tree, sidecar.arena_mut());
        let state_id = states
            .iter()
            .position(|candidate| candidate == &state)
            .unwrap() as u32;
        sidecar
            .bind(state_id, &[], state_id, wta_observation(state), Some(root))
            .unwrap();
    }
    sidecar
        .verify(WTA_ADAPTER, &presentation, &compiled)
        .unwrap();
    let storage = sidecar.arena().storage();
    assert_eq!(
        (
            storage.node_bytes,
            storage.payload_bytes,
            storage.child_bytes
        ),
        (1_248, 312, 104)
    );
    assert_eq!(sidecar.replay_storage_bytes(), 416);
    for replay in sidecar.records() {
        let value = replay_wta_provenance(sidecar.arena(), replay.provenance.unwrap());
        assert_eq!(value, states[replay.record.terminal_state as usize]);
        assert_eq!(wta_observation(value), replay.record.observation);
    }

    let left = states.iter().position(|&state| state == [1, 3, 0]).unwrap() as u32;
    let right = states.iter().position(|&state| state == [1, 4, 2]).unwrap() as u32;
    let coargument = left as usize;
    let generator = (2 * coargument) as u32;
    let left_target = presentation.transition(generator, left).unwrap();
    let right_target = presentation.transition(generator, right).unwrap();
    assert_eq!(presentation.observations()[left_target as usize], 2);
    assert_eq!(presentation.observations()[right_target as usize], 4);
    assert!(compiled.separators().any(|(record, path)| {
        record.left_state == left && record.right_state == right && path == [generator]
    }));
    replay_all_paths(
        &presentation,
        &compiled,
        &(0..presentation.generators().len() as u32)
            .map(|generator| vec![generator])
            .collect::<Vec<_>>(),
    );
}

type Profile = [u8; 3];

fn resource_profiles() -> Vec<Profile> {
    let mut profiles = Vec::new();
    for first in 0..=4 {
        for second in first..=4 {
            for third in second..=4 {
                profiles.push([first, second, third]);
            }
        }
    }
    profiles
}

fn resource_step(
    subset: u64,
    job: u8,
    profiles: &[Profile],
    ids: &BTreeMap<Profile, usize>,
) -> u64 {
    let mut next = 0_u64;
    for (profile_index, &profile) in profiles.iter().enumerate() {
        if subset & (1_u64 << profile_index) == 0 {
            continue;
        }
        for slot in 0..3 {
            if profile[slot] + job <= 4 {
                let mut successor = profile;
                successor[slot] += job;
                successor.sort_unstable();
                next |= 1_u64 << ids[&successor];
            }
        }
    }
    next
}

fn resource_observation(subset: u64, profiles: &[Profile]) -> u32 {
    profiles
        .iter()
        .enumerate()
        .filter(|(index, _)| subset & (1_u64 << index) != 0)
        .map(|(_, profile)| u32::from(profile[2]))
        .min()
        .unwrap_or(INFINITY)
}

struct ResourceFixture {
    presentation: FinitePresentation,
    profiles: Vec<Profile>,
    subsets: [Vec<u64>; 3],
}

fn resource_fixture() -> ResourceFixture {
    let profiles = resource_profiles();
    let profile_ids: BTreeMap<_, _> = profiles
        .iter()
        .copied()
        .enumerate()
        .map(|(index, profile)| (profile, index))
        .collect();
    let sort_zero: Vec<_> = (0..profiles.len()).map(|index| 1_u64 << index).collect();
    let mut sorts = [sort_zero, Vec::new(), Vec::new()];
    for depth in 0..2 {
        let mut next = BTreeSet::new();
        for &subset in &sorts[depth] {
            for job in [1, 2] {
                next.insert(resource_step(subset, job, &profiles, &profile_ids));
            }
        }
        sorts[depth + 1] = next.into_iter().collect();
    }
    let offsets = [0, sorts[0].len(), sorts[0].len() + sorts[1].len()];
    let state_ids: [BTreeMap<u64, u32>; 3] = std::array::from_fn(|depth| {
        sorts[depth]
            .iter()
            .copied()
            .enumerate()
            .map(|(index, subset)| (subset, (offsets[depth] + index) as u32))
            .collect()
    });
    let mut generators = Vec::new();
    for depth in 0..2 {
        for job in [1, 2] {
            generators.push(GeneratorSpec {
                source_sort: depth as u32,
                target_sort: depth as u32 + 1,
                transitions: sorts[depth]
                    .iter()
                    .map(|&subset| {
                        state_ids[depth + 1][&resource_step(subset, job, &profiles, &profile_ids)]
                    })
                    .collect(),
            });
        }
    }
    let observations: Vec<_> = sorts
        .iter()
        .flat_map(|sort| {
            sort.iter()
                .map(|&subset| resource_observation(subset, &profiles))
        })
        .collect();
    let presentation = FinitePresentation::new(
        sorts.iter().map(|sort| sort.len() as u32),
        observations,
        generators,
    )
    .unwrap();
    ResourceFixture {
        presentation,
        profiles,
        subsets: sorts,
    }
}

fn resource_generators(word: &[u8]) -> Vec<u32> {
    word.iter()
        .enumerate()
        .map(|(depth, &job)| 2 * depth as u32 + u32::from(job - 1))
        .collect()
}

fn optimal_assignment(mut profile: Profile, jobs: &[u8]) -> Option<(u32, Vec<usize>)> {
    fn search(profile: Profile, jobs: &[u8]) -> Option<(u32, Vec<usize>)> {
        let Some((&job, tail)) = jobs.split_first() else {
            return Some((u32::from(profile[2]), Vec::new()));
        };
        let mut best: Option<(u32, Vec<usize>)> = None;
        for slot in 0..3 {
            if profile[slot] + job > 4 {
                continue;
            }
            let mut next = profile;
            next[slot] += job;
            next.sort_unstable();
            if let Some((cost, suffix)) = search(next, tail) {
                let mut witness = Vec::with_capacity(1 + suffix.len());
                witness.push(slot);
                witness.extend(suffix);
                let candidate = (cost, witness);
                if best.as_ref().is_none_or(|current| candidate < *current) {
                    best = Some(candidate);
                }
            }
        }
        best
    }
    profile.sort_unstable();
    search(profile, jobs)
}

fn replay_assignment(mut profile: Profile, jobs: &[u8], witness: &[usize]) -> Option<Profile> {
    if jobs.len() != witness.len() {
        return None;
    }
    for (&job, &slot) in jobs.iter().zip(witness) {
        if slot >= 3 || profile[slot] + job > 4 {
            return None;
        }
        profile[slot] += job;
        profile.sort_unstable();
    }
    Some(profile)
}

fn export_resource_assignment(
    arena: &mut ProvenanceArena,
    profile: Profile,
    jobs: &[u8],
    slots: &[usize],
) -> ProvenanceId {
    let mut payload = Vec::with_capacity(5 + jobs.len() + slots.len());
    payload.extend(profile.map(u32::from));
    payload.push(jobs.len() as u32);
    payload.extend(jobs.iter().copied().map(u32::from));
    payload.push(slots.len() as u32);
    payload.extend(slots.iter().map(|&slot| slot as u32));
    arena.push(RESOURCE_ASSIGNMENT, &payload, &[]).unwrap()
}

fn replay_resource_provenance(arena: &ProvenanceArena, root: ProvenanceId) -> Profile {
    let view = arena.get(root).unwrap();
    assert_eq!(view.kind(), RESOURCE_ASSIGNMENT);
    assert_eq!(view.children().len(), 0);
    let payload = view.payload();
    let profile: Profile = payload[..3]
        .iter()
        .map(|&value| value as u8)
        .collect::<Vec<_>>()
        .try_into()
        .unwrap();
    let job_count = payload[3] as usize;
    let jobs: Vec<u8> = payload[4..4 + job_count]
        .iter()
        .map(|&job| job as u8)
        .collect();
    let slot_count = payload[4 + job_count] as usize;
    let slots: Vec<usize> = payload[5 + job_count..]
        .iter()
        .map(|&slot| slot as usize)
        .collect();
    assert_eq!(slot_count, slots.len());
    replay_assignment(profile, &jobs, &slots).unwrap()
}

#[test]
fn resource_batches_compile_and_replay_through_the_same_api() {
    let fixture = resource_fixture();
    let compiled = compile_observational(&fixture.presentation).unwrap();
    verify_compilation(&fixture.presentation, &compiled).unwrap();
    let _split = assert_split_transcript(&fixture.presentation, &compiled, 26);

    assert_eq!(fixture.subsets.each_ref().map(Vec::len), [35, 51, 44]);
    assert_eq!(compiled.metrics().states, 130);
    assert_eq!(
        compiled
            .class_ranges()
            .iter()
            .map(|range| range.len)
            .collect::<Vec<_>>(),
        [22, 14, 5]
    );
    assert_eq!(compiled.metrics().classes, 41);
    assert_eq!(compiled.metrics().refinement_rounds, 2);
    assert_eq!(compiled.metrics().separators, 2_321);
    assert_eq!(compiled.metrics().separator_steps, 369);
    assert_eq!(compiled.storage().quotient_bytes, 1_224);
    assert_eq!(compiled.storage().certificate_bytes, 57_180);

    let words = [
        vec![],
        vec![1],
        vec![2],
        vec![1, 1],
        vec![1, 2],
        vec![2, 1],
        vec![2, 2],
    ];
    let generator_paths: Vec<_> = words.iter().map(|word| resource_generators(word)).collect();
    replay_all_paths(&fixture.presentation, &compiled, &generator_paths);

    let sort_zero = fixture.presentation.sorts()[0];
    let mut sidecar = ReplaySidecar::new(
        fixture.presentation.fingerprint(),
        RESOURCE_ADAPTER,
        INFINITY,
    );
    for (index, &profile) in fixture.profiles.iter().enumerate() {
        let state = sort_zero.start + index as u32;
        for word in &words {
            let mut target = state;
            for generator in resource_generators(word) {
                target = fixture.presentation.transition(generator, target).unwrap();
            }
            let expected = optimal_assignment(profile, word);
            let expected_cost = expected.as_ref().map_or(INFINITY, |answer| answer.0);
            assert_eq!(
                fixture.presentation.observations()[target as usize],
                expected_cost
            );
            if let Some((cost, witness)) = expected {
                let final_profile = replay_assignment(profile, word, &witness).unwrap();
                assert_eq!(u32::from(final_profile[2]), cost);
                let root = export_resource_assignment(sidecar.arena_mut(), profile, word, &witness);
                sidecar
                    .bind(state, &resource_generators(word), target, cost, Some(root))
                    .unwrap();
            } else {
                sidecar
                    .bind(state, &resource_generators(word), target, INFINITY, None)
                    .unwrap();
            }
        }
    }
    sidecar
        .verify(RESOURCE_ADAPTER, &fixture.presentation, &compiled)
        .unwrap();
    let storage = sidecar.arena().storage();
    assert_eq!(
        (
            storage.node_bytes,
            storage.payload_bytes,
            storage.child_bytes
        ),
        (6_976, 6_768, 0)
    );
    assert_eq!(sidecar.replay_storage_bytes(), 9_240);
    for replay in sidecar.records() {
        if let Some(root) = replay.provenance {
            let final_profile = replay_resource_provenance(sidecar.arena(), root);
            assert_eq!(u32::from(final_profile[2]), replay.record.observation);
        } else {
            assert_eq!(replay.record.observation, INFINITY);
        }
    }

    let left = fixture
        .profiles
        .iter()
        .position(|&p| p == [0, 0, 1])
        .unwrap() as u32;
    let right = fixture
        .profiles
        .iter()
        .position(|&p| p == [0, 1, 1])
        .unwrap() as u32;
    assert!(compiled.separators().any(|(record, path)| {
        record.left_state == left && record.right_state == right && path == [0, 2]
    }));
}

fn recovery_demand(state: u32) -> Matrix {
    let data: Vec<_> = (0..4).map(|bit| ((state >> bit) & 1) as u8).collect();
    Matrix::new::<2>(2, 2, data).unwrap()
}

fn recovery_fixture() -> (FinitePresentation, GeneratedSpanTable) {
    let generator = Matrix::new::<2>(2, 3, vec![1, 0, 1, 0, 1, 1]).unwrap();
    let spans = GeneratedSpanTable::build::<2>(&generator).unwrap();
    let observations: Vec<_> = (0..16)
        .map(|state| {
            u32::from(
                spans
                    .query::<2>(&recovery_demand(state))
                    .unwrap()
                    .unwrap()
                    .cost,
            )
        })
        .collect();
    let presentation = FinitePresentation::new(
        [16],
        observations,
        [
            GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: (0_u32..16).map(|state| state & 0b0101).collect(),
            },
            GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: (0_u32..16).map(|state| state & 0b1010).collect(),
            },
        ],
    )
    .unwrap();
    (presentation, spans)
}

fn recovery_coefficients(state: u32, support: &[u32]) -> Vec<u32> {
    let demand = recovery_demand(state);
    let generator = [[1_u8, 0, 1], [0_u8, 1, 1]];
    for bits in 0_u32..1_u32 << (2 * support.len()) {
        let coefficients: Vec<u32> = (0..2 * support.len())
            .map(|bit| (bits >> bit) & 1)
            .collect();
        let valid = (0..2).all(|row| {
            (0..2).all(|column| {
                let value = support
                    .iter()
                    .enumerate()
                    .fold(0_u8, |sum, (index, &helper)| {
                        sum ^ (generator[row][helper as usize]
                            * coefficients[2 * index + column] as u8)
                    });
                value == demand.as_slice()[2 * row + column]
            })
        });
        if valid
            && coefficients
                .chunks_exact(2)
                .all(|row| row.iter().any(|&entry| entry != 0))
        {
            return coefficients;
        }
    }
    panic!("span witness has no coefficient lift")
}

fn export_recovery_equation(
    arena: &mut ProvenanceArena,
    spans: &GeneratedSpanTable,
    state: u32,
) -> ProvenanceId {
    let answer = spans.query::<2>(&recovery_demand(state)).unwrap().unwrap();
    let coefficients = recovery_coefficients(state, &answer.support);
    let mut loads = [0_u32; 3];
    for &helper in &answer.support {
        loads[helper as usize] = 1;
    }
    let mut payload = Vec::new();
    payload.extend([state, u32::from(answer.cost), answer.support.len() as u32]);
    payload.extend(answer.support.iter().copied());
    payload.push(coefficients.len() as u32);
    payload.extend(coefficients);
    payload.extend(loads);
    arena.push(RECOVERY_EQUATION, &payload, &[]).unwrap()
}

fn recovery_payload_valid_for_state(payload: &[u32], state: u32) -> bool {
    if payload.len() < 7 || payload[0] != state {
        return false;
    }
    let cost = payload[1];
    let support_len = payload[2] as usize;
    let Some(support_end) = 3_usize.checked_add(support_len) else {
        return false;
    };
    let Some(&coefficient_len) = payload.get(support_end) else {
        return false;
    };
    let coefficient_start = support_end + 1;
    let Some(coefficient_end) = coefficient_start.checked_add(coefficient_len as usize) else {
        return false;
    };
    if coefficient_len as usize != 2 * support_len || coefficient_end + 3 != payload.len() {
        return false;
    }
    let support = &payload[3..support_end];
    if support.windows(2).any(|pair| pair[0] >= pair[1])
        || support.iter().any(|&helper| helper >= 3)
        || cost != support_len as u32
    {
        return false;
    }
    let coefficients = &payload[coefficient_start..coefficient_end];
    if coefficients
        .chunks_exact(2)
        .any(|row| row.iter().all(|&entry| entry == 0))
    {
        return false;
    }
    let loads = &payload[coefficient_end..];
    if (0..3).any(|helper| loads[helper] != u32::from(support.contains(&(helper as u32)))) {
        return false;
    }
    let generator = [[1_u32, 0, 1], [0_u32, 1, 1]];
    let demand = recovery_demand(state);
    (0..2).all(|row| {
        (0..2).all(|column| {
            let value = support
                .iter()
                .enumerate()
                .fold(0_u32, |sum, (index, &helper)| {
                    sum ^ (generator[row][helper as usize] * coefficients[2 * index + column])
                });
            value == u32::from(demand.as_slice()[2 * row + column])
        })
    })
}

#[test]
fn triangle_recovery_compiles_with_concrete_witness_lifts() {
    const RECOVERY_INFINITY: u32 = 9;
    let (presentation, spans) = recovery_fixture();
    let compiled = compile_observational(&presentation).unwrap();
    verify_compilation(&presentation, &compiled).unwrap();
    let _split = assert_split_transcript(&presentation, &compiled, 2);
    assert_eq!(compiled.metrics().states, 16);
    assert_eq!(compiled.metrics().classes, 5);
    assert_eq!(compiled.metrics().refinement_rounds, 1);
    assert_eq!(compiled.metrics().separators, 96);
    assert_eq!(compiled.metrics().separator_steps, 27);
    assert_eq!(compiled.storage().quotient_bytes, 184);
    assert_eq!(compiled.storage().certificate_bytes, 2_412);
    let mut class_sizes = BTreeMap::new();
    for &class in compiled.state_classes() {
        *class_sizes.entry(class).or_insert(0) += 1;
    }
    let mut class_sizes: Vec<_> = class_sizes.into_values().collect();
    class_sizes.sort_unstable_by(|left, right| right.cmp(left));
    assert_eq!(class_sizes, [6, 3, 3, 3, 1]);
    for left in 0..16_u32 {
        let left_signature = (
            presentation.observations()[left as usize],
            presentation.observations()[(left & 0b0101) as usize],
            presentation.observations()[(left & 0b1010) as usize],
        );
        for right in 0..16_u32 {
            let right_signature = (
                presentation.observations()[right as usize],
                presentation.observations()[(right & 0b0101) as usize],
                presentation.observations()[(right & 0b1010) as usize],
            );
            assert_eq!(
                compiled.state_classes()[left as usize] == compiled.state_classes()[right as usize],
                left_signature == right_signature
            );
        }
    }

    let left = 1_u32;
    let right = 2_u32;
    assert_eq!(presentation.observations()[left as usize], 1);
    assert_eq!(presentation.observations()[right as usize], 1);
    assert!(compiled.separators().any(|(record, path)| {
        record.left_state == left && record.right_state == right && path == [0]
    }));

    let mut sidecar = ReplaySidecar::new(
        presentation.fingerprint(),
        RECOVERY_ADAPTER,
        RECOVERY_INFINITY,
    );
    let roots: Vec<_> = (0..16)
        .map(|state| export_recovery_equation(sidecar.arena_mut(), &spans, state))
        .collect();
    let paths = [vec![], vec![0], vec![1], vec![0, 1], vec![1, 0]];
    for start in 0..16_u32 {
        for path in &paths {
            let mut terminal = start;
            for &generator in path {
                terminal = presentation.transition(generator, terminal).unwrap();
            }
            let answer = spans
                .query::<2>(&recovery_demand(terminal))
                .unwrap()
                .unwrap();
            sidecar
                .bind(
                    start,
                    path,
                    terminal,
                    u32::from(answer.cost),
                    Some(roots[terminal as usize]),
                )
                .unwrap();
        }
    }
    sidecar
        .verify(RECOVERY_ADAPTER, &presentation, &compiled)
        .unwrap();
    let storage = sidecar.arena().storage();
    assert_eq!(
        (
            storage.node_bytes,
            storage.payload_bytes,
            storage.child_bytes
        ),
        (512, 700, 0)
    );
    assert_eq!(sidecar.replay_storage_bytes(), 2_944);
    for replay in sidecar.records() {
        let view = sidecar.arena().get(replay.provenance.unwrap()).unwrap();
        assert_eq!(view.kind(), RECOVERY_EQUATION);
        assert!(recovery_payload_valid_for_state(
            view.payload(),
            replay.record.terminal_state
        ));
        assert_eq!(view.payload()[1], replay.record.observation);
    }

    let equivalent_left = 3_u32;
    let equivalent_right = 12_u32;
    assert_eq!(
        compiled.state_classes()[equivalent_left as usize],
        compiled.state_classes()[equivalent_right as usize]
    );
    let left_payload = sidecar
        .arena()
        .get(roots[equivalent_left as usize])
        .unwrap();
    assert!(!recovery_payload_valid_for_state(
        left_payload.payload(),
        equivalent_right
    ));
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct RecoveryProfile([u32; 4]);

fn profile_table(costs: [u32; 2]) -> CostTable {
    CostTable::from_entries::<2>(
        1,
        1,
        (0_u8..2).map(|label| {
            (
                Matrix::new::<2>(1, 1, vec![label]).unwrap(),
                costs[label as usize],
            )
        }),
    )
    .unwrap()
}

fn hierarchy_blocks(context: usize) -> [Matrix; 2] {
    let coefficients = [(1_u8, 0_u8), (0, 1), (1, 1)][context];
    [
        Matrix::new::<2>(1, 1, vec![coefficients.0]).unwrap(),
        Matrix::new::<2>(1, 1, vec![coefficients.1]).unwrap(),
    ]
}

fn hierarchy_answer(
    profile: RecoveryProfile,
    context: usize,
    target_mode: bool,
    label: u8,
) -> CompositionAnswer {
    let ordinary = profile_table([profile.0[0], profile.0[1]]);
    let target = profile_table([profile.0[2], profile.0[3]]);
    let blocks = hierarchy_blocks(context);
    let composed = if target_mode {
        CompositionTable::compose_with_target::<2>(&blocks, &ordinary, &target, 0).unwrap()
    } else {
        CompositionTable::compose::<2>(&blocks, &ordinary).unwrap()
    };
    composed
        .answer::<2>(&Matrix::new::<2>(1, 1, vec![label]).unwrap())
        .unwrap()
        .unwrap()
}

fn hierarchy_step(profile: RecoveryProfile, context: usize) -> RecoveryProfile {
    RecoveryProfile([
        hierarchy_answer(profile, context, false, 0).cost,
        hierarchy_answer(profile, context, false, 1).cost,
        hierarchy_answer(profile, context, true, 0).cost,
        hierarchy_answer(profile, context, true, 1).cost,
    ])
}

struct HierarchyFixture {
    presentation: FinitePresentation,
    profiles: [Vec<RecoveryProfile>; 3],
}

fn hierarchy_fixture() -> HierarchyFixture {
    let first: Vec<_> = (1..=3)
        .flat_map(|ordinary| {
            (1..=3).map(move |zero_sector| RecoveryProfile([0, ordinary, zero_sector, 0]))
        })
        .collect();
    let mut profiles = [first, Vec::new(), Vec::new()];
    for depth in 0..2 {
        profiles[depth + 1] = profiles[depth]
            .iter()
            .flat_map(|&profile| (0..3).map(move |context| hierarchy_step(profile, context)))
            .collect::<BTreeSet<_>>()
            .into_iter()
            .collect();
    }
    let offsets = [
        0_usize,
        profiles[0].len(),
        profiles[0].len() + profiles[1].len(),
    ];
    let ids: [BTreeMap<RecoveryProfile, u32>; 3] = std::array::from_fn(|depth| {
        profiles[depth]
            .iter()
            .copied()
            .enumerate()
            .map(|(index, profile)| (profile, (offsets[depth] + index) as u32))
            .collect()
    });
    let mut generators = Vec::new();
    for depth in 0..2 {
        for context in 0..3 {
            generators.push(GeneratorSpec {
                source_sort: depth as u32,
                target_sort: depth as u32 + 1,
                transitions: profiles[depth]
                    .iter()
                    .map(|&profile| ids[depth + 1][&hierarchy_step(profile, context)])
                    .collect(),
            });
        }
    }
    let observations: Vec<_> = profiles
        .iter()
        .flat_map(|sort| sort.iter().map(|profile| profile.0[3]))
        .collect();
    let presentation = FinitePresentation::new(
        profiles.iter().map(|sort| sort.len() as u32),
        observations,
        generators,
    )
    .unwrap();
    HierarchyFixture {
        presentation,
        profiles,
    }
}

fn profile_after(mut profile: RecoveryProfile, contexts: &[usize]) -> RecoveryProfile {
    for &context in contexts {
        profile = hierarchy_step(profile, context);
    }
    profile
}

fn export_hierarchy_witness(
    arena: &mut ProvenanceArena,
    seed: RecoveryProfile,
    contexts: &[usize],
    target_mode: bool,
    label: u8,
) -> ProvenanceId {
    if contexts.is_empty() {
        let offset = if target_mode { 2 } else { 0 };
        let cost = seed.0[offset + label as usize];
        return arena
            .push(
                HIERARCHY_LEAF,
                &[u32::from(target_mode), u32::from(label), cost, u32::MAX],
                &[],
            )
            .unwrap();
    }
    let (&context, prefix) = contexts.split_last().unwrap();
    let input = profile_after(seed, prefix);
    let answer = hierarchy_answer(input, context, target_mode, label);
    let local: Vec<u8> = answer
        .local_labels
        .iter()
        .map(|matrix| matrix.as_slice()[0])
        .collect();
    assert_eq!(local.len(), 2);
    let left = export_hierarchy_witness(arena, seed, prefix, target_mode, local[0]);
    let right = export_hierarchy_witness(arena, seed, prefix, false, local[1]);
    arena
        .push(
            HIERARCHY_NODE,
            &[
                u32::from(target_mode),
                u32::from(label),
                answer.cost,
                context as u32,
            ],
            &[left, right],
        )
        .unwrap()
}

fn replay_hierarchy_witness(
    arena: &ProvenanceArena,
    root: ProvenanceId,
    seed: RecoveryProfile,
    contexts: &[usize],
    target_mode: bool,
    label: u8,
) -> u32 {
    let view = arena.get(root).unwrap();
    let payload = view.payload();
    assert_eq!(payload.len(), 4);
    assert_eq!(payload[0], u32::from(target_mode));
    assert_eq!(payload[1], u32::from(label));
    if contexts.is_empty() {
        assert_eq!(view.kind(), HIERARCHY_LEAF);
        assert_eq!(payload[3], u32::MAX);
        assert_eq!(view.children().len(), 0);
        let offset = if target_mode { 2 } else { 0 };
        assert_eq!(payload[2], seed.0[offset + label as usize]);
        return payload[2];
    }
    assert_eq!(view.kind(), HIERARCHY_NODE);
    let (&context, prefix) = contexts.split_last().unwrap();
    assert_eq!(payload[3], context as u32);
    let children: Vec<_> = view.children().collect();
    assert_eq!(children.len(), 2);
    let left_view = arena.get(children[0]).unwrap();
    let right_view = arena.get(children[1]).unwrap();
    let left_label = left_view.payload()[1] as u8;
    let right_label = right_view.payload()[1] as u8;
    let coefficients = [(1_u8, 0_u8), (0, 1), (1, 1)][context];
    assert_eq!(
        (coefficients.0 * left_label) ^ (coefficients.1 * right_label),
        label
    );
    let left_cost =
        replay_hierarchy_witness(arena, children[0], seed, prefix, target_mode, left_label);
    let right_cost = replay_hierarchy_witness(arena, children[1], seed, prefix, false, right_label);
    assert_eq!(payload[2], left_cost + right_cost);
    payload[2]
}

#[test]
fn hierarchical_recovery_tables_use_actual_min_sum_composition() {
    let fixture = hierarchy_fixture();
    let compiled = compile_observational(&fixture.presentation).unwrap();
    verify_compilation(&fixture.presentation, &compiled).unwrap();
    let _split = assert_split_transcript(&fixture.presentation, &compiled, 4);
    assert_eq!(fixture.profiles.each_ref().map(Vec::len), [9, 12, 12]);
    assert_eq!(
        compiled
            .class_ranges()
            .iter()
            .map(|range| range.len)
            .collect::<Vec<_>>(),
        [3, 6, 4]
    );
    assert_eq!(compiled.metrics().states, 33);
    assert_eq!(compiled.metrics().classes, 13);
    assert_eq!(compiled.metrics().refinement_rounds, 1);
    assert_eq!(compiled.metrics().separators, 114);
    assert_eq!(compiled.metrics().separator_steps, 54);
    assert_eq!(compiled.storage().quotient_bytes, 464);
    assert_eq!(compiled.storage().certificate_bytes, 2_952);

    let paths = [
        Vec::new(),
        vec![0],
        vec![1],
        vec![2],
        vec![0, 0],
        vec![0, 1],
        vec![0, 2],
        vec![1, 0],
        vec![1, 1],
        vec![1, 2],
        vec![2, 0],
        vec![2, 1],
        vec![2, 2],
    ];
    let mut sidecar = ReplaySidecar::new(
        fixture.presentation.fingerprint(),
        HIERARCHY_ADAPTER,
        u32::MAX,
    );
    for (start, &seed) in fixture.profiles[0].iter().enumerate() {
        for contexts in &paths {
            let generator_path: Vec<_> = contexts
                .iter()
                .enumerate()
                .map(|(depth, &context)| 3 * depth as u32 + context as u32)
                .collect();
            let mut terminal = start as u32;
            for &generator in &generator_path {
                terminal = fixture
                    .presentation
                    .transition(generator, terminal)
                    .unwrap();
            }
            let root = export_hierarchy_witness(sidecar.arena_mut(), seed, contexts, true, 1);
            let observation =
                replay_hierarchy_witness(sidecar.arena(), root, seed, contexts, true, 1);
            assert_eq!(
                observation,
                fixture.presentation.observations()[terminal as usize]
            );
            sidecar
                .bind(
                    start as u32,
                    &generator_path,
                    terminal,
                    observation,
                    Some(root),
                )
                .unwrap();
        }
    }
    sidecar
        .verify(HIERARCHY_ADAPTER, &fixture.presentation, &compiled)
        .unwrap();
    let storage = sidecar.arena().storage();
    assert_eq!(
        (
            storage.node_bytes,
            storage.payload_bytes,
            storage.child_bytes
        ),
        (21_024, 10_512, 2_160)
    );
    assert_eq!(sidecar.replay_storage_bytes(), 4_500);
    for replay in sidecar.records() {
        let seed = fixture.profiles[0][replay.record.start_state as usize];
        let contexts: Vec<_> = replay
            .path
            .iter()
            .enumerate()
            .map(|(depth, &generator)| generator as usize - 3 * depth)
            .collect();
        assert_eq!(
            replay_hierarchy_witness(
                sidecar.arena(),
                replay.provenance.unwrap(),
                seed,
                &contexts,
                true,
                1,
            ),
            replay.record.observation
        );
    }
}

#[test]
fn checked_in_python_oracle_agrees_with_rust_metrics_and_witnesses() {
    let oracle: serde_json::Value =
        serde_json::from_str(include_str!("fixtures/observational_compilation.json")).unwrap();
    assert_eq!(oracle["schema"], "ergodis-observational-v2");

    let (wta, _, _) = wta_fixture();
    let wta_compiled = compile_observational(&wta).unwrap();
    assert_eq!(oracle["wta"]["carrier"], wta_compiled.metrics().states);
    assert_eq!(oracle["wta"]["quotient"], wta_compiled.metrics().classes);
    assert_eq!(
        oracle["wta"]["separator_steps"],
        wta_compiled.metrics().separator_steps
    );

    let resource = resource_fixture();
    let resource_compiled = compile_observational(&resource.presentation).unwrap();
    assert_eq!(
        oracle["resource"]["carrier_by_sort"],
        serde_json::json!(resource.subsets.each_ref().map(Vec::len))
    );
    assert_eq!(
        oracle["resource"]["quotient_by_sort"],
        serde_json::json!(resource_compiled
            .class_ranges()
            .iter()
            .map(|range| range.len)
            .collect::<Vec<_>>())
    );
    for case in oracle["resource"]["witnesses"].as_array().unwrap() {
        let profile: Profile = serde_json::from_value(case["profile"].clone()).unwrap();
        let jobs: Vec<u8> = serde_json::from_value(case["jobs"].clone()).unwrap();
        let answer = optimal_assignment(profile, &jobs);
        assert_eq!(
            answer.as_ref().map_or(INFINITY, |(cost, _)| *cost),
            case["cost"].as_u64().unwrap() as u32
        );
        let expected_slots: Option<Vec<usize>> =
            serde_json::from_value(case["slots"].clone()).unwrap();
        assert_eq!(answer.map(|(_, slots)| slots), expected_slots);
    }

    let (recovery, spans) = recovery_fixture();
    let recovery_compiled = compile_observational(&recovery).unwrap();
    assert_eq!(
        oracle["recovery"]["carrier"],
        recovery_compiled.metrics().states
    );
    assert_eq!(
        oracle["recovery"]["quotient"],
        recovery_compiled.metrics().classes
    );
    assert_eq!(
        oracle["recovery"]["separator_steps"],
        recovery_compiled.metrics().separator_steps
    );
    for case in oracle["recovery"]["witnesses"].as_array().unwrap() {
        let state = case["state"].as_u64().unwrap() as u32;
        let answer = spans.query::<2>(&recovery_demand(state)).unwrap().unwrap();
        let coefficients = recovery_coefficients(state, &answer.support);
        let mut loads = [0_u32; 3];
        for &helper in &answer.support {
            loads[helper as usize] = 1;
        }
        assert_eq!(case["cost"], u32::from(answer.cost));
        assert_eq!(case["support"], serde_json::json!(answer.support));
        assert_eq!(case["coefficients"], serde_json::json!(coefficients));
        assert_eq!(case["helper_loads"], serde_json::json!(loads));
    }

    let hierarchy = hierarchy_fixture();
    let hierarchy_compiled = compile_observational(&hierarchy.presentation).unwrap();
    assert_eq!(
        oracle["hierarchy"]["carrier_by_sort"],
        serde_json::json!(hierarchy.profiles.each_ref().map(Vec::len))
    );
    assert_eq!(
        oracle["hierarchy"]["quotient_by_sort"],
        serde_json::json!(hierarchy_compiled
            .class_ranges()
            .iter()
            .map(|range| range.len)
            .collect::<Vec<_>>())
    );
    assert_eq!(
        oracle["hierarchy"]["separator_steps"],
        hierarchy_compiled.metrics().separator_steps
    );
    for case in oracle["hierarchy"]["response_cases"].as_array().unwrap() {
        let seed = RecoveryProfile(serde_json::from_value(case["seed"].clone()).unwrap());
        let contexts: Vec<usize> = serde_json::from_value(case["contexts"].clone()).unwrap();
        let profile = profile_after(seed, &contexts);
        assert_eq!(case["profile"], serde_json::json!(profile.0));
        assert_eq!(case["observation"], profile.0[3]);
    }
}
