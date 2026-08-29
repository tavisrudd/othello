//! Quotient-first exact Pareto DP for a finite-state fork/join workflow.

use ergodis::observational::{
    compile_layered_frozen_dag_audited, verify_frozen_layered_dag_audit, LayeredGeneratorSpec,
};
use ergodis::{
    CappedAdditiveMonoid, FiniteOrderedMonoid, FrozenParetoEvaluationMetrics, FrozenParetoPlan,
    ParetoWitness, WitnessedParetoFront, WitnessedParetoWorkspace,
};
use std::io::Write;
use std::time::Instant;

const DEFAULT_WEIGHTS: [[u16; 2]; 4] = [[1, 4], [4, 1], [2, 5], [5, 2]];

#[derive(Clone, Copy)]
struct Action {
    branch: u8,
    symbol: u8,
}

struct Workflow {
    length: usize,
    automaton_states: u32,
    monitor_states: u32,
    state_counts: Vec<u32>,
    generators: Vec<LayeredGeneratorSpec>,
    actions: Vec<Action>,
    outgoing: Vec<Vec<u32>>,
    coordinates: Vec<(usize, usize)>,
}

impl Workflow {
    fn new(length: usize, automaton_states: u32, monitor_states: u32) -> Self {
        assert!(length != 0 && 6 * length <= 30 && automaton_states != 0);
        assert!(monitor_states == 1 || monitor_states == 7 || monitor_states == 9);
        let mut sort_of = vec![vec![usize::MAX; length + 1]; length + 1];
        let mut coordinates = Vec::with_capacity((length + 1) * (length + 1));
        for diagonal in 0..=2 * length {
            for (left, row) in sort_of.iter_mut().enumerate() {
                let Some(right) = diagonal.checked_sub(left) else {
                    continue;
                };
                if right <= length {
                    row[right] = coordinates.len();
                    coordinates.push((left, right));
                }
            }
        }
        let local_states = automaton_states
            .checked_mul(automaton_states)
            .and_then(|states| states.checked_mul(monitor_states))
            .unwrap();
        let state_counts = vec![local_states; coordinates.len()];
        let mut generators = Vec::new();
        let mut actions = Vec::new();
        let mut outgoing = vec![Vec::new(); coordinates.len()];
        for (source, &(left, right)) in coordinates.iter().enumerate() {
            for branch in 0_u8..2 {
                if (branch == 0 && left == length) || (branch == 1 && right == length) {
                    continue;
                }
                let target = if branch == 0 {
                    sort_of[left + 1][right]
                } else {
                    sort_of[left][right + 1]
                };
                for symbol in 0_u8..2 {
                    let generator = generators.len() as u32;
                    generators.push(LayeredGeneratorSpec {
                        source_sort: source as u32,
                        target_sort: target as u32,
                    });
                    actions.push(Action { branch, symbol });
                    outgoing[source].push(generator);
                }
            }
        }
        Self {
            length,
            automaton_states,
            monitor_states,
            state_counts,
            generators,
            actions,
            outgoing,
            coordinates,
        }
    }

    fn transition(&self, generator: u32, state: u32) -> u32 {
        let action = self.actions[generator as usize];
        self.transition_action(action, state)
    }

    fn transition_action(&self, action: Action, state: u32) -> u32 {
        let (mut left, mut right, monitor) = self.decode_state(state);
        let selected = if action.branch == 0 {
            &mut left
        } else {
            &mut right
        };
        *selected =
            (selected.wrapping_mul(2) + u32::from(action.symbol) + 1) % self.automaton_states;
        let next_monitor = if self.monitor_states == 1 {
            0
        } else if self.monitor_states == 9 {
            let mut left_mode = monitor / 3;
            let mut right_mode = monitor % 3;
            let selected_mode = if action.branch == 0 {
                &mut left_mode
            } else {
                &mut right_mode
            };
            if *selected_mode == 0 {
                *selected_mode = u32::from(action.symbol) + 1;
            }
            3 * left_mode + right_mode
        } else if monitor == 0 {
            1 + u32::from(action.branch) * 3
        } else {
            let previous_branch = (monitor - 1) / 3;
            let switches = (monitor - 1) % 3;
            1 + u32::from(action.branch) * 3
                + (switches + u32::from(previous_branch != u32::from(action.branch))) % 3
        };
        self.encode_state(left, right, next_monitor)
    }

    fn observation(&self, sort: u32, state: u32) -> u32 {
        let (left_steps, right_steps) = self.coordinates[sort as usize];
        if left_steps != self.length || right_steps != self.length {
            return 0;
        }
        let (left, right, monitor) = self.decode_state(state);
        let monitor_accepts = match self.monitor_states {
            1 => true,
            7 => monitor != 0 && (monitor - 1) % 3 == 1,
            9 => monitor / 3 != 0 && monitor / 3 == monitor % 3,
            _ => unreachable!(),
        };
        if left == self.automaton_states - 1
            && right == self.automaton_states - 1
            && monitor_accepts
        {
            1
        } else {
            2
        }
    }

    fn decode_state(&self, state: u32) -> (u32, u32, u32) {
        let monitor = state % self.monitor_states;
        let pair = state / self.monitor_states;
        (
            pair / self.automaton_states,
            pair % self.automaton_states,
            monitor,
        )
    }

    fn encode_state(&self, left: u32, right: u32, monitor: u32) -> u32 {
        (left * self.automaton_states + right) * self.monitor_states + monitor
    }
}

fn empty_front(resources: &CappedAdditiveMonoid) -> WitnessedParetoFront {
    WitnessedParetoFront::new(resources, []).unwrap()
}

fn singleton_front(
    resources: &CappedAdditiveMonoid,
    resource: [u16; 2],
    witness: u32,
) -> WitnessedParetoFront {
    WitnessedParetoFront::new(
        resources,
        [ParetoWitness {
            resource: resources.encode(&resource).unwrap(),
            witness,
        }],
    )
    .unwrap()
}

fn edge_fronts(
    resources: &CappedAdditiveMonoid,
    weights: &[[u16; 2]; 4],
) -> [WitnessedParetoFront; 4] {
    [
        singleton_front(resources, weights[0], 1),
        singleton_front(resources, weights[1], 2),
        singleton_front(resources, weights[2], 3),
        singleton_front(resources, weights[3], 4),
    ]
}

fn extend_front(
    resources: &CappedAdditiveMonoid,
    workspace: &mut WitnessedParetoWorkspace,
    edge: &WitnessedParetoFront,
    child: &WitnessedParetoFront,
) -> WitnessedParetoFront {
    let entries = workspace
        .compose(resources, edge, child, |edge, child| {
            Ok::<_, std::convert::Infallible>(edge | (child << 3))
        })
        .unwrap();
    WitnessedParetoFront::new(resources, entries.iter().copied()).unwrap()
}

fn raw_pareto_dp(
    workflow: &Workflow,
    resources: &CappedAdditiveMonoid,
) -> Vec<Vec<WitnessedParetoFront>> {
    let edges = edge_fronts(resources, &DEFAULT_WEIGHTS);
    let mut workspace = WitnessedParetoWorkspace::with_capacity(resources.element_count() as usize);
    let mut fronts = vec![Vec::new(); workflow.state_counts.len()];
    for sort in (0..workflow.state_counts.len()).rev() {
        let mut sort_fronts = Vec::with_capacity(workflow.state_counts[sort] as usize);
        for state in 0..workflow.state_counts[sort] {
            let mut front = if workflow.observation(sort as u32, state) == 1 {
                singleton_front(resources, [0, 0], 0)
            } else {
                empty_front(resources)
            };
            for &generator in &workflow.outgoing[sort] {
                let spec = workflow.generators[generator as usize];
                let target_state = workflow.transition(generator, state);
                let action = workflow.actions[generator as usize];
                let edge = &edges[(2 * action.branch + action.symbol) as usize];
                let candidate = extend_front(
                    resources,
                    &mut workspace,
                    edge,
                    &fronts[spec.target_sort as usize][target_state as usize],
                );
                front = front.choice(resources, &candidate).unwrap();
            }
            sort_fronts.push(front);
        }
        fronts[sort] = sort_fronts;
    }
    fronts
}

#[cfg(test)]
fn quotient_pareto_dp(
    workflow: &Workflow,
    plan: &FrozenParetoPlan<'_>,
    resources: &CappedAdditiveMonoid,
    weights: &[[u16; 2]; 4],
) -> Vec<Option<WitnessedParetoFront>> {
    let edges = edge_fronts(resources, weights);
    let outputs = [
        empty_front(resources),
        singleton_front(resources, [0, 0], 0),
        empty_front(resources),
    ];
    let mut generator_edges = Vec::with_capacity(workflow.generators.len());
    for &action in &workflow.actions {
        generator_edges.push(edges[(2 * action.branch + action.symbol) as usize].clone());
    }
    let mut workspace = WitnessedParetoWorkspace::with_capacity(resources.element_count() as usize);
    plan.evaluate(
        resources,
        &outputs,
        &generator_edges,
        &mut workspace,
        |_, edge, suffix| edge | (suffix << 3),
    )
    .unwrap()
}

fn quotient_entry_pareto_dp(
    plan: &FrozenParetoPlan<'_>,
    resources: &CappedAdditiveMonoid,
    outputs: &[WitnessedParetoFront],
    generator_edges: &[WitnessedParetoFront],
    entry_class: u32,
) -> (WitnessedParetoFront, FrozenParetoEvaluationMetrics) {
    let mut workspace = WitnessedParetoWorkspace::with_capacity(resources.element_count() as usize);
    let (mut fronts, metrics) = plan
        .evaluate_entries(
            &[entry_class],
            resources,
            outputs,
            generator_edges,
            &mut workspace,
            |_, edge, suffix| edge | (suffix << 3),
        )
        .unwrap();
    (fronts.pop().unwrap(), metrics)
}

fn factorized_pareto_dp(
    workflow: &Workflow,
    resources: &CappedAdditiveMonoid,
    initial_state: u32,
) -> WitnessedParetoFront {
    assert_eq!(workflow.monitor_states, 1);
    let edges = edge_fronts(resources, &DEFAULT_WEIGHTS);
    let state_count = workflow.automaton_states as usize;
    let initial_left = initial_state / workflow.automaton_states;
    let initial_right = initial_state % workflow.automaton_states;
    let mut workspace = WitnessedParetoWorkspace::with_capacity(resources.element_count() as usize);
    let mut branch_fronts = [empty_front(resources), empty_front(resources)];

    for branch in 0..2 {
        let mut next = Vec::with_capacity(state_count);
        for state in 0..workflow.automaton_states {
            next.push(if state == workflow.automaton_states - 1 {
                singleton_front(resources, [0, 0], 0)
            } else {
                empty_front(resources)
            });
        }
        let mut current = Vec::with_capacity(state_count);
        for _ in 0..workflow.length {
            current.clear();
            for state in 0..workflow.automaton_states {
                let mut front = empty_front(resources);
                for symbol in 0..2 {
                    let target = (2 * state + symbol + 1) % workflow.automaton_states;
                    let candidate = extend_front(
                        resources,
                        &mut workspace,
                        &edges[2 * branch + symbol as usize],
                        &next[target as usize],
                    );
                    front = front.choice(resources, &candidate).unwrap();
                }
                current.push(front);
            }
            std::mem::swap(&mut current, &mut next);
        }
        let initial = if branch == 0 {
            initial_left
        } else {
            initial_right
        };
        branch_fronts[branch] = next.swap_remove(initial as usize);
    }

    let entries = workspace
        .compose(
            resources,
            &branch_fronts[0],
            &branch_fronts[1],
            |left, right| {
                Ok::<_, std::convert::Infallible>(left | (right << (3 * workflow.length)))
            },
        )
        .unwrap();
    WitnessedParetoFront::new(resources, entries.iter().copied()).unwrap()
}

fn verify_witness(
    workflow: &Workflow,
    resources: &CappedAdditiveMonoid,
    initial_state: u32,
    entry: ParetoWitness,
    weights: &[[u16; 2]; 4],
) {
    let mut left_steps = 0;
    let mut right_steps = 0;
    let mut state = initial_state;
    let mut resource = [0_u16; 2];
    let mut witness = entry.witness;
    while left_steps != workflow.length || right_steps != workflow.length {
        let code = (witness & 7) as usize;
        assert!((1..=4).contains(&code));
        witness >>= 3;
        let action = code - 1;
        let branch = action / 2;
        let symbol = action % 2;
        if branch == 0 {
            assert!(left_steps < workflow.length);
            left_steps += 1;
        } else {
            assert!(right_steps < workflow.length);
            right_steps += 1;
        }
        state = workflow.transition_action(
            Action {
                branch: branch as u8,
                symbol: symbol as u8,
            },
            state,
        );
        for coordinate in 0..2 {
            resource[coordinate] += weights[action][coordinate];
        }
    }
    assert_eq!(witness, 0);
    assert_eq!(
        workflow.observation((workflow.coordinates.len() - 1) as u32, state),
        1
    );
    assert_eq!(resources.encode(&resource).unwrap(), entry.resource);
}

#[cfg(test)]
fn brute_force_entry(
    workflow: &Workflow,
    resources: &CappedAdditiveMonoid,
    initial_state: u32,
    weights: &[[u16; 2]; 4],
) -> WitnessedParetoFront {
    let steps = 2 * workflow.length;
    let mut candidates = Vec::new();
    for mut sequence in 0..4_u64.pow(steps as u32) {
        let mut left_steps = 0;
        let mut right_steps = 0;
        let mut state = initial_state;
        let mut resource = [0_u16; 2];
        let mut witness = 0_u32;
        let mut valid = true;
        for step in 0..steps {
            let action = (sequence & 3) as usize;
            sequence >>= 2;
            let branch = action / 2;
            let symbol = action % 2;
            if (branch == 0 && left_steps == workflow.length)
                || (branch == 1 && right_steps == workflow.length)
            {
                valid = false;
                break;
            }
            if branch == 0 {
                left_steps += 1;
            } else {
                right_steps += 1;
            }
            state = workflow.transition_action(
                Action {
                    branch: branch as u8,
                    symbol: symbol as u8,
                },
                state,
            );
            let weight = weights[action];
            resource[0] += weight[0];
            resource[1] += weight[1];
            witness |= (action as u32 + 1) << (3 * step);
        }
        if valid && workflow.observation((workflow.coordinates.len() - 1) as u32, state) == 1 {
            candidates.push(ParetoWitness {
                resource: resources.encode(&resource).unwrap(),
                witness,
            });
        }
    }
    WitnessedParetoFront::new(resources, candidates).unwrap()
}

#[cfg(test)]
fn acceptance_signature(workflow: &Workflow, initial_state: u32) -> Vec<u64> {
    let steps = 2 * workflow.length;
    let sequence_count = 4_usize.pow(steps as u32);
    let mut signature = vec![0_u64; sequence_count.div_ceil(64)];
    for sequence_index in 0..sequence_count {
        let mut sequence = sequence_index;
        let mut left_steps = 0;
        let mut right_steps = 0;
        let mut state = initial_state;
        let mut valid = true;
        for _ in 0..steps {
            let action = sequence & 3;
            sequence >>= 2;
            let branch = action / 2;
            let symbol = action % 2;
            if (branch == 0 && left_steps == workflow.length)
                || (branch == 1 && right_steps == workflow.length)
            {
                valid = false;
                break;
            }
            if branch == 0 {
                left_steps += 1;
            } else {
                right_steps += 1;
            }
            state = workflow.transition_action(
                Action {
                    branch: branch as u8,
                    symbol: symbol as u8,
                },
                state,
            );
        }
        if valid && workflow.observation((workflow.coordinates.len() - 1) as u32, state) == 1 {
            signature[sequence_index / 64] |= 1_u64 << (sequence_index % 64);
        }
    }
    signature
}

struct RunResult {
    raw_states: usize,
    classes: usize,
    identity_classes: usize,
    front: usize,
    reachable_classes: usize,
    peak_live_classes: usize,
    peak_live_entries: usize,
    compile_ns: u128,
    legacy_raw_ns: u128,
    identity_ns: u128,
    quotient_ns: u128,
    factorized_ns: u128,
    audit_bytes: u64,
}

fn run(
    length: usize,
    automaton_states: u32,
    monitor_states: u32,
    audit_path: Option<&str>,
    repetitions: u128,
) -> RunResult {
    assert!(repetitions != 0);
    let workflow = Workflow::new(length, automaton_states, monitor_states);
    let compile_start = Instant::now();
    let (frozen, audit) = if let Some(path) = audit_path {
        let file = std::fs::File::create(path).unwrap();
        let mut writer = std::io::BufWriter::with_capacity(64 * 1024, file);
        let (frozen, _) = compile_layered_frozen_dag_audited(
            &workflow.state_counts,
            &workflow.generators,
            &[0],
            |sort, state| workflow.observation(sort, state),
            |generator, state| workflow.transition(generator, state),
            &mut writer,
        )
        .unwrap();
        writer.flush().unwrap();
        (frozen, None)
    } else {
        let mut audit = Vec::new();
        let (frozen, _) = compile_layered_frozen_dag_audited(
            &workflow.state_counts,
            &workflow.generators,
            &[0],
            |sort, state| workflow.observation(sort, state),
            |generator, state| workflow.transition(generator, state),
            &mut audit,
        )
        .unwrap();
        (frozen, Some(audit))
    };
    let compile_ns = compile_start.elapsed().as_nanos();
    let audit_bytes = if let Some(path) = audit_path {
        let file = std::fs::File::open(path).unwrap();
        let mut reader = std::io::BufReader::with_capacity(64 * 1024, file);
        verify_frozen_layered_dag_audit(&frozen, &mut reader).unwrap();
        std::fs::metadata(path).unwrap().len()
    } else {
        let audit = audit.unwrap();
        let audit_bytes = audit.len() as u64;
        verify_frozen_layered_dag_audit(&frozen, &mut std::io::Cursor::new(audit)).unwrap();
        audit_bytes
    };

    let resources = CappedAdditiveMonoid::new([64, 64]).unwrap();
    let plan = FrozenParetoPlan::new(&frozen).unwrap();
    let entry_class = frozen.entry_class(0, 0).unwrap();
    let edges = edge_fronts(&resources, &DEFAULT_WEIGHTS);
    let quotient_outputs = [
        empty_front(&resources),
        singleton_front(&resources, [0, 0], 0),
        empty_front(&resources),
    ];
    let mut generator_edges = Vec::with_capacity(workflow.generators.len());
    for &action in &workflow.actions {
        generator_edges.push(edges[(2 * action.branch + action.symbol) as usize].clone());
    }

    let mut state_offsets = Vec::with_capacity(workflow.state_counts.len());
    let mut state_offset = 0_u32;
    for &count in &workflow.state_counts {
        state_offsets.push(state_offset);
        state_offset = state_offset.checked_add(count).unwrap();
    }
    let (identity, _) = compile_layered_frozen_dag_audited(
        &workflow.state_counts,
        &workflow.generators,
        &[0],
        |sort, state| state_offsets[sort as usize] + state,
        |generator, state| workflow.transition(generator, state),
        &mut std::io::sink(),
    )
    .unwrap();
    let identity_plan = FrozenParetoPlan::new(&identity).unwrap();
    let identity_entry = identity.entry_class(0, 0).unwrap();
    let mut identity_outputs = Vec::with_capacity(state_offset as usize);
    for (sort, &count) in workflow.state_counts.iter().enumerate() {
        for state in 0..count {
            identity_outputs.push(if workflow.observation(sort as u32, state) == 1 {
                singleton_front(&resources, [0, 0], 0)
            } else {
                empty_front(&resources)
            });
        }
    }
    let mut raw = None;
    let raw_start = Instant::now();
    for _ in 0..repetitions {
        raw = Some(std::hint::black_box(raw_pareto_dp(&workflow, &resources)));
    }
    let raw_ns = raw_start.elapsed().as_nanos() / repetitions;
    let raw = raw.unwrap();
    let mut quotient = None;
    let quotient_start = Instant::now();
    for _ in 0..repetitions {
        quotient = Some(std::hint::black_box(quotient_entry_pareto_dp(
            &plan,
            &resources,
            &quotient_outputs,
            &generator_edges,
            entry_class,
        )));
    }
    let quotient_ns = quotient_start.elapsed().as_nanos() / repetitions;
    let (quotient_entry, quotient_metrics) = quotient.unwrap();
    let mut identity_result = None;
    let identity_start = Instant::now();
    for _ in 0..repetitions {
        identity_result = Some(std::hint::black_box(quotient_entry_pareto_dp(
            &identity_plan,
            &resources,
            &identity_outputs,
            &generator_edges,
            identity_entry,
        )));
    }
    let identity_ns = identity_start.elapsed().as_nanos() / repetitions;
    let (identity_entry_front, _) = identity_result.unwrap();
    let (factorized, factorized_ns) = if workflow.monitor_states == 1 {
        let mut factorized = None;
        let factorized_start = Instant::now();
        for _ in 0..repetitions {
            factorized = Some(std::hint::black_box(factorized_pareto_dp(
                &workflow, &resources, 0,
            )));
        }
        (
            factorized,
            factorized_start.elapsed().as_nanos() / repetitions,
        )
    } else {
        (None, 0)
    };
    let raw_entry = &raw[0][0];
    assert_eq!(
        raw_entry.resources().collect::<Vec<_>>(),
        quotient_entry.resources().collect::<Vec<_>>()
    );
    assert_eq!(
        raw_entry.resources().collect::<Vec<_>>(),
        identity_entry_front.resources().collect::<Vec<_>>()
    );
    if let Some(factorized) = &factorized {
        assert_eq!(
            raw_entry.resources().collect::<Vec<_>>(),
            factorized.resources().collect::<Vec<_>>()
        );
    }
    for &entry in quotient_entry.entries() {
        verify_witness(&workflow, &resources, 0, entry, &DEFAULT_WEIGHTS);
    }
    if let Some(factorized) = &factorized {
        for &entry in factorized.entries() {
            verify_witness(&workflow, &resources, 0, entry, &DEFAULT_WEIGHTS);
        }
    }
    RunResult {
        raw_states: workflow
            .state_counts
            .iter()
            .map(|&count| count as usize)
            .sum(),
        classes: frozen.storage().classes,
        identity_classes: identity.storage().classes,
        front: quotient_entry.entries().len(),
        reachable_classes: quotient_metrics.reachable_classes,
        peak_live_classes: quotient_metrics.peak_live_classes,
        peak_live_entries: quotient_metrics.peak_live_entries,
        compile_ns,
        legacy_raw_ns: raw_ns,
        identity_ns,
        quotient_ns,
        factorized_ns,
        audit_bytes,
    }
}

fn main() {
    let coupled = std::env::var_os("ERGODIS_COUPLED").is_some();
    let audit_path = if coupled {
        "/home/tavis/.cache/ergodis/coupled-fork-join-cost-regular.audit"
    } else {
        "/home/tavis/.cache/ergodis/fork-join-cost-regular.audit"
    };
    let repetitions = std::env::var("ERGODIS_BENCH_REPETITIONS")
        .ok()
        .and_then(|value| value.parse::<u128>().ok())
        .unwrap_or(1000);
    let RunResult {
        raw_states,
        classes,
        identity_classes,
        front,
        reachable_classes,
        peak_live_classes,
        peak_live_entries,
        compile_ns,
        legacy_raw_ns,
        identity_ns,
        quotient_ns,
        factorized_ns,
        audit_bytes,
    } = run(
        5,
        12,
        if coupled { 9 } else { 1 },
        Some(audit_path),
        repetitions,
    );
    let label = if coupled {
        "coupled-fork-join-cost-regular"
    } else {
        "shuffle-product-cost-regular"
    };
    let quotient_factorized_ratio = if factorized_ns == 0 {
        0.0
    } else {
        quotient_ns as f64 / factorized_ns as f64
    };
    println!(
        "{label}\trepetitions={repetitions}\traw_states={raw_states}\tclasses={classes}\tidentity_classes={identity_classes}\tfront={front}\treachable_classes={reachable_classes}\tpeak_live_classes={peak_live_classes}\tpeak_live_entries={peak_live_entries}\tcompile_ns={compile_ns}\tlegacy_raw_pareto_ns={legacy_raw_ns}\tidentity_pareto_ns={identity_ns}\tquotient_pareto_ns={quotient_ns}\tfactorized_pareto_ns={factorized_ns}\tidentity_quotient_ratio={:.3}\tquotient_factorized_ratio={:.3}\taudit_bytes={}",
        identity_ns as f64 / quotient_ns as f64,
        quotient_factorized_ratio,
        audit_bytes
    );
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn quotient_pareto_matches_raw_and_lifts_words() {
        // Since gcd(2^3, 6) = 2, the bounded continuation has a
        // non-trivial kernel without erasing every initial distinction.
        let result = run(3, 6, 1, None, 1);
        assert!(result.classes < result.raw_states);
        assert!(result.front != 0);

        let workflow = Workflow::new(3, 6, 1);
        let resources = CappedAdditiveMonoid::new([64, 64]).unwrap();
        let raw = raw_pareto_dp(&workflow, &resources);

        let mut audit = Vec::new();
        let (frozen, _) = compile_layered_frozen_dag_audited(
            &workflow.state_counts,
            &workflow.generators,
            &[0],
            |sort, state| workflow.observation(sort, state),
            |generator, state| workflow.transition(generator, state),
            &mut audit,
        )
        .unwrap();
        let plan = FrozenParetoPlan::new(&frozen).unwrap();
        let quotient = quotient_pareto_dp(&workflow, &plan, &resources, &DEFAULT_WEIGHTS);
        let mut signatures = Vec::with_capacity(workflow.state_counts[0] as usize);
        for state in 0..workflow.state_counts[0] {
            let class = frozen.entry_class(0, state).unwrap();
            let quotient_entry = quotient[class as usize].as_ref().unwrap();
            let brute = brute_force_entry(&workflow, &resources, state, &DEFAULT_WEIGHTS);
            assert_eq!(
                raw[0][state as usize].resources().collect::<Vec<_>>(),
                brute.resources().collect::<Vec<_>>()
            );
            assert_eq!(
                raw[0][state as usize].resources().collect::<Vec<_>>(),
                quotient_entry.resources().collect::<Vec<_>>()
            );
            for &entry in quotient_entry.entries() {
                verify_witness(&workflow, &resources, state, entry, &DEFAULT_WEIGHTS);
            }
            signatures.push(acceptance_signature(&workflow, state));
        }

        // Reuse the identical feasibility quotient under a second objective;
        // only the generator-local interpretation changes.
        let alternate_weights = [[1, 1], [3, 0], [0, 2], [4, 1]];
        let alternate = quotient_pareto_dp(&workflow, &plan, &resources, &alternate_weights);
        for state in 0..workflow.state_counts[0] {
            let class = frozen.entry_class(0, state).unwrap();
            let quotient_entry = alternate[class as usize].as_ref().unwrap();
            let brute = brute_force_entry(&workflow, &resources, state, &alternate_weights);
            assert_eq!(
                quotient_entry.resources().collect::<Vec<_>>(),
                brute.resources().collect::<Vec<_>>()
            );
            for &entry in quotient_entry.entries() {
                verify_witness(&workflow, &resources, state, entry, &alternate_weights);
            }
        }

        let mut saw_merge = false;
        let mut saw_distinction = false;
        for left in 0..workflow.state_counts[0] {
            for right in left + 1..workflow.state_counts[0] {
                let same = frozen.entry_class(0, left) == frozen.entry_class(0, right);
                assert_eq!(
                    same,
                    signatures[left as usize] == signatures[right as usize]
                );
                saw_merge |= same;
                saw_distinction |= !same;
            }
        }
        assert!(saw_merge && saw_distinction);
    }

    #[test]
    fn shared_mode_monitor_prevents_branch_factorization() {
        let result = run(3, 5, 9, None, 1);
        assert!(result.front != 0 && result.peak_live_classes < result.classes);
        assert_eq!(result.factorized_ns, 0);

        let workflow = Workflow::new(3, 5, 9);
        let incompatible = [
            Action {
                branch: 0,
                symbol: 0,
            },
            Action {
                branch: 0,
                symbol: 1,
            },
            Action {
                branch: 0,
                symbol: 0,
            },
            Action {
                branch: 1,
                symbol: 1,
            },
            Action {
                branch: 1,
                symbol: 1,
            },
            Action {
                branch: 1,
                symbol: 1,
            },
        ];
        let compatible = [
            incompatible[0],
            incompatible[1],
            incompatible[2],
            Action {
                branch: 1,
                symbol: 0,
            },
            Action {
                branch: 1,
                symbol: 1,
            },
            Action {
                branch: 1,
                symbol: 0,
            },
        ];
        let terminal_sort = (workflow.coordinates.len() - 1) as u32;
        let execute = |actions: &[Action]| {
            actions.iter().fold(0, |state, &action| {
                workflow.transition_action(action, state)
            })
        };
        assert_eq!(workflow.observation(terminal_sort, execute(&compatible)), 1);
        assert_eq!(
            workflow.observation(terminal_sort, execute(&incompatible)),
            2
        );

        let resources = CappedAdditiveMonoid::new([64, 64]).unwrap();
        let coupled = brute_force_entry(&workflow, &resources, 0, &DEFAULT_WEIGHTS);
        let independent = factorized_pareto_dp(&Workflow::new(3, 5, 1), &resources, 0);
        assert_ne!(
            coupled.resources().collect::<Vec<_>>(),
            independent.resources().collect::<Vec<_>>()
        );
    }
}
