//! Quotient-first exact Pareto DP for a finite-state fork/join workflow.

use ergodis::observational::{
    compile_layered_frozen_dag_audited, verify_frozen_layered_dag_audit, FrozenObservation,
    LayeredGeneratorSpec,
};
use ergodis::{
    CappedAdditiveMonoid, FiniteOrderedMonoid, ParetoWitness, WitnessedParetoFront,
    WitnessedParetoWorkspace,
};
use std::io::Write;
use std::time::Instant;

#[derive(Clone, Copy)]
struct Action {
    branch: u8,
    symbol: u8,
}

struct Workflow {
    length: usize,
    automaton_states: u32,
    state_counts: Vec<u32>,
    generators: Vec<LayeredGeneratorSpec>,
    actions: Vec<Action>,
    outgoing: Vec<Vec<u32>>,
    coordinates: Vec<(usize, usize)>,
}

impl Workflow {
    fn new(length: usize, automaton_states: u32) -> Self {
        assert!(length != 0 && 6 * length <= 30 && automaton_states != 0);
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
        let local_states = automaton_states * automaton_states;
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
            state_counts,
            generators,
            actions,
            outgoing,
            coordinates,
        }
    }

    fn transition(&self, generator: u32, state: u32) -> u32 {
        let action = self.actions[generator as usize];
        let mut left = state / self.automaton_states;
        let mut right = state % self.automaton_states;
        let selected = if action.branch == 0 {
            &mut left
        } else {
            &mut right
        };
        *selected =
            (selected.wrapping_mul(2) + u32::from(action.symbol) + 1) % self.automaton_states;
        left * self.automaton_states + right
    }

    fn observation(&self, sort: u32, state: u32) -> u32 {
        let (left_steps, right_steps) = self.coordinates[sort as usize];
        if left_steps != self.length || right_steps != self.length {
            return 0;
        }
        let left = state / self.automaton_states;
        let right = state % self.automaton_states;
        if left == self.automaton_states - 1 && right == self.automaton_states - 1 {
            1
        } else {
            2
        }
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

fn edge_fronts(resources: &CappedAdditiveMonoid) -> [WitnessedParetoFront; 4] {
    [
        singleton_front(resources, [1, 4], 1),
        singleton_front(resources, [4, 1], 2),
        singleton_front(resources, [2, 5], 3),
        singleton_front(resources, [5, 2], 4),
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
    let edges = edge_fronts(resources);
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

fn quotient_pareto_dp(
    workflow: &Workflow,
    frozen: &FrozenObservation,
    resources: &CappedAdditiveMonoid,
) -> Vec<Option<WitnessedParetoFront>> {
    let edges = edge_fronts(resources);
    let mut workspace = WitnessedParetoWorkspace::with_capacity(resources.element_count() as usize);
    let mut fronts = vec![None; frozen.storage().classes];
    for sort in (0..workflow.state_counts.len()).rev() {
        let range = frozen.class_range(sort as u32).unwrap();
        for class in range.start..range.start + range.len {
            let mut front = if frozen.output(class) == Some(1) {
                singleton_front(resources, [0, 0], 0)
            } else {
                empty_front(resources)
            };
            for &generator in &workflow.outgoing[sort] {
                let target = frozen.transition(generator, class).unwrap();
                let action = workflow.actions[generator as usize];
                let edge = &edges[(2 * action.branch + action.symbol) as usize];
                let candidate = extend_front(
                    resources,
                    &mut workspace,
                    edge,
                    fronts[target as usize].as_ref().unwrap(),
                );
                front = front.choice(resources, &candidate).unwrap();
            }
            fronts[class as usize] = Some(front);
        }
    }
    fronts
}

fn factorized_pareto_dp(
    workflow: &Workflow,
    resources: &CappedAdditiveMonoid,
    initial_state: u32,
) -> WitnessedParetoFront {
    let edges = edge_fronts(resources);
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
) {
    let weights = [[1_u16, 4_u16], [4, 1], [2, 5], [5, 2]];
    let mut left_steps = 0;
    let mut right_steps = 0;
    let mut left_state = initial_state / workflow.automaton_states;
    let mut right_state = initial_state % workflow.automaton_states;
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
            left_state = (2 * left_state + symbol as u32 + 1) % workflow.automaton_states;
        } else {
            assert!(right_steps < workflow.length);
            right_steps += 1;
            right_state = (2 * right_state + symbol as u32 + 1) % workflow.automaton_states;
        }
        for coordinate in 0..2 {
            resource[coordinate] += weights[action][coordinate];
        }
    }
    assert_eq!(witness, 0);
    assert_eq!(left_state, workflow.automaton_states - 1);
    assert_eq!(right_state, workflow.automaton_states - 1);
    assert_eq!(resources.encode(&resource).unwrap(), entry.resource);
}

#[cfg(test)]
fn brute_force_entry(
    workflow: &Workflow,
    resources: &CappedAdditiveMonoid,
    initial_state: u32,
) -> WitnessedParetoFront {
    let steps = 2 * workflow.length;
    let mut candidates = Vec::new();
    for mut sequence in 0..4_u64.pow(steps as u32) {
        let mut left_steps = 0;
        let mut right_steps = 0;
        let mut left_state = initial_state / workflow.automaton_states;
        let mut right_state = initial_state % workflow.automaton_states;
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
                left_state = (2 * left_state + symbol as u32 + 1) % workflow.automaton_states;
            } else {
                right_steps += 1;
                right_state = (2 * right_state + symbol as u32 + 1) % workflow.automaton_states;
            }
            let weight = [[1_u16, 4_u16], [4, 1], [2, 5], [5, 2]][action];
            resource[0] += weight[0];
            resource[1] += weight[1];
            witness |= (action as u32 + 1) << (3 * step);
        }
        if valid
            && left_state == workflow.automaton_states - 1
            && right_state == workflow.automaton_states - 1
        {
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
        let mut left_state = initial_state / workflow.automaton_states;
        let mut right_state = initial_state % workflow.automaton_states;
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
                left_state = (2 * left_state + symbol as u32 + 1) % workflow.automaton_states;
            } else {
                right_steps += 1;
                right_state = (2 * right_state + symbol as u32 + 1) % workflow.automaton_states;
            }
        }
        if valid
            && left_state == workflow.automaton_states - 1
            && right_state == workflow.automaton_states - 1
        {
            signature[sequence_index / 64] |= 1_u64 << (sequence_index % 64);
        }
    }
    signature
}

fn run(
    length: usize,
    automaton_states: u32,
    audit_path: Option<&str>,
) -> (usize, usize, usize, u128, u128, u128, u128, u64) {
    let workflow = Workflow::new(length, automaton_states);
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
    let raw_start = Instant::now();
    let raw = raw_pareto_dp(&workflow, &resources);
    let raw_ns = raw_start.elapsed().as_nanos();
    let quotient_start = Instant::now();
    let quotient = quotient_pareto_dp(&workflow, &frozen, &resources);
    let quotient_ns = quotient_start.elapsed().as_nanos();
    let factorized_start = Instant::now();
    let factorized = factorized_pareto_dp(&workflow, &resources, 0);
    let factorized_ns = factorized_start.elapsed().as_nanos();
    let entry_class = frozen.entry_class(0, 0).unwrap();
    let raw_entry = &raw[0][0];
    let quotient_entry = quotient[entry_class as usize].as_ref().unwrap();
    assert_eq!(
        raw_entry.resources().collect::<Vec<_>>(),
        quotient_entry.resources().collect::<Vec<_>>()
    );
    assert_eq!(
        raw_entry.resources().collect::<Vec<_>>(),
        factorized.resources().collect::<Vec<_>>()
    );
    for &entry in quotient_entry.entries() {
        verify_witness(&workflow, &resources, 0, entry);
    }
    for &entry in factorized.entries() {
        verify_witness(&workflow, &resources, 0, entry);
    }
    (
        workflow
            .state_counts
            .iter()
            .map(|&count| count as usize)
            .sum(),
        frozen.storage().classes,
        quotient_entry.entries().len(),
        compile_ns,
        raw_ns,
        quotient_ns,
        factorized_ns,
        audit_bytes,
    )
}

fn main() {
    let audit_path = "/home/tavis/.cache/ergodis/fork-join-cost-regular.audit";
    let (raw_states, classes, front, compile_ns, raw_ns, quotient_ns, factorized_ns, audit_bytes) =
        run(5, 12, Some(audit_path));
    println!(
        "fork-join-cost-regular\traw_states={raw_states}\tclasses={classes}\tfront={front}\tcompile_ns={compile_ns}\traw_pareto_ns={raw_ns}\tquotient_pareto_ns={quotient_ns}\tfactorized_pareto_ns={factorized_ns}\traw_quotient_ratio={:.3}\tquotient_factorized_ratio={:.3}\taudit_bytes={}",
        raw_ns as f64 / quotient_ns as f64,
        quotient_ns as f64 / factorized_ns as f64,
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
        let (raw_states, classes, front, _, _, _, _, _) = run(3, 6, None);
        assert!(classes < raw_states);
        assert!(front != 0);

        let workflow = Workflow::new(3, 6);
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
        let quotient = quotient_pareto_dp(&workflow, &frozen, &resources);
        let mut signatures = Vec::with_capacity(workflow.state_counts[0] as usize);
        for state in 0..workflow.state_counts[0] {
            let class = frozen.entry_class(0, state).unwrap();
            let quotient_entry = quotient[class as usize].as_ref().unwrap();
            let brute = brute_force_entry(&workflow, &resources, state);
            assert_eq!(
                raw[0][state as usize].resources().collect::<Vec<_>>(),
                brute.resources().collect::<Vec<_>>()
            );
            assert_eq!(
                raw[0][state as usize].resources().collect::<Vec<_>>(),
                quotient_entry.resources().collect::<Vec<_>>()
            );
            for &entry in quotient_entry.entries() {
                verify_witness(&workflow, &resources, state, entry);
            }
            signatures.push(acceptance_signature(&workflow, state));
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
}
