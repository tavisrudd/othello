use ergodis::observational::{
    compile_observational, verify_compilation, CompiledObservation, FinitePresentation,
    GeneratorSpec,
};
use std::collections::{BTreeMap, BTreeSet};

const LIMIT: u32 = 4;
const INFINITY: u32 = LIMIT + 1;

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

#[test]
fn weighted_tree_automaton_compiles_to_six_exact_states() {
    let (presentation, states, trees) = wta_fixture();
    let compiled = compile_observational(&presentation).unwrap();
    verify_compilation(&presentation, &compiled).unwrap();

    assert_eq!(presentation.state_count(), 13);
    assert_eq!(presentation.generators().len(), 26);
    assert_eq!(compiled.metrics().classes, 6);
    assert_eq!(compiled.metrics().refinement_rounds, 1);
    assert_eq!(compiled.metrics().separators, 60);
    assert_eq!(compiled.metrics().separator_steps, 4);
    assert_eq!(compiled.storage().quotient_bytes, 1_148);
    assert_eq!(compiled.storage().certificate_bytes, 1_456);
    for (&state, tree) in states.iter().zip(&trees) {
        assert_eq!(replay_wta_tree(tree), state);
        assert_eq!(replay_optimal_wta_run(tree), wta_observation(state));
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

#[test]
fn resource_batches_compile_and_replay_through_the_same_api() {
    let fixture = resource_fixture();
    let compiled = compile_observational(&fixture.presentation).unwrap();
    verify_compilation(&fixture.presentation, &compiled).unwrap();

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
            }
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

#[test]
fn checked_in_python_oracle_agrees_with_rust_metrics_and_witnesses() {
    let oracle: serde_json::Value =
        serde_json::from_str(include_str!("fixtures/observational_compilation.json")).unwrap();
    assert_eq!(oracle["schema"], "ergodis-observational-v1");

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
}
