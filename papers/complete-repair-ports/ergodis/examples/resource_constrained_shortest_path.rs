//! Exact warm RCSP evaluation over an Ergodis contextual quotient.
//!
//! The accepted input is the single-resource, zero-vertex-resource subset of
//! the OR-Library RCSP format. Positive arc resources make the budget-unrolled
//! presentation acyclic. Invoke with:
//!
//! `resource_constrained_shortest_path FILE [forward|pareto|direct] [REPETITIONS]`

use std::cmp::Reverse;
use std::collections::BTreeMap;
use std::collections::BinaryHeap;
use std::error::Error;
use std::fs;
use std::hint::black_box;
use std::io;
use std::time::Instant;

use ergodis::observational::{compile_layered_frozen_dag_audited, LayeredGeneratorSpec};
use ergodis::{
    FiniteOrderedMonoid, FrozenParetoPlan, FrozenShortestPathPlan, FrozenShortestPathWorkspace,
    ParetoWitness, WitnessedParetoFront, WitnessedParetoWorkspace, ABSENT_SHORTEST_PATH_COST,
};

const ABSENT: u32 = u32::MAX;
const INF: u32 = u32::MAX;
const OUTPUT_WITNESS_BIT: u32 = 1 << 31;

#[repr(C)]
#[derive(Clone, Copy)]
struct Arc {
    target: u32,
    cost: u32,
    resource: u32,
    input_id: u32,
}

const _: () = assert!(std::mem::size_of::<Arc>() == 16 && std::mem::align_of::<Arc>() == 4);

#[repr(C)]
#[derive(Clone, Copy)]
struct MacroArc {
    target: u32,
    cost: u32,
    resource: u32,
    positive_source: u32,
    input_id: u32,
}

const _: () =
    assert!(std::mem::size_of::<MacroArc>() == 20 && std::mem::align_of::<MacroArc>() == 4);

struct Instance {
    vertices: usize,
    budget: u32,
    offsets: Box<[u32]>,
    arcs: Box<[Arc]>,
}

struct Action {
    resource: u32,
    targets: Box<[u32]>,
    costs: Box<[u32]>,
    positive_sources: Box<[u32]>,
    input_ids: Box<[u32]>,
}

struct ZeroClosure {
    distances: Box<[u32]>,
    next_arcs: Box<[u32]>,
}

#[derive(Clone, Copy)]
struct ScalarCap {
    cap: u32,
}

impl FiniteOrderedMonoid for ScalarCap {
    fn element_count(&self) -> u32 {
        self.cap + 1
    }

    fn identity(&self) -> u32 {
        0
    }

    fn combine(&self, left: u32, right: u32) -> u32 {
        left.saturating_add(right).min(self.cap)
    }

    fn leq(&self, left: u32, right: u32) -> bool {
        left <= right
    }
}

#[repr(C)]
#[derive(Clone, Copy)]
struct GeneratorMeta {
    source_sort: u32,
    action: u32,
}

const _: () = assert!(
    std::mem::size_of::<GeneratorMeta>() == 8 && std::mem::align_of::<GeneratorMeta>() == 4
);

#[repr(C)]
#[derive(Clone, Copy)]
struct PathNode {
    generator: u32,
    suffix: u32,
}

const _: () =
    assert!(std::mem::size_of::<PathNode>() == 8 && std::mem::align_of::<PathNode>() == 4);

#[repr(C)]
#[derive(Clone, Copy)]
struct Predecessor {
    previous: u32,
    input_id: u32,
}

const _: () =
    assert!(std::mem::size_of::<Predecessor>() == 8 && std::mem::align_of::<Predecessor>() == 4);

fn main() -> Result<(), Box<dyn Error>> {
    let mut arguments = std::env::args().skip(1);
    let path = arguments.next().ok_or("missing OR-Library input path")?;
    let stage = arguments.next().unwrap_or_else(|| "forward".to_owned());
    let repetitions = arguments
        .next()
        .map(|value| value.parse::<usize>())
        .transpose()?
        .unwrap_or(100);
    if arguments.next().is_some() || (stage != "forward" && stage != "pareto" && stage != "direct")
    {
        return Err("usage: FILE [forward|pareto|direct] [REPETITIONS]".into());
    }

    let instance = parse_instance(&fs::read_to_string(path)?)?;
    if stage == "direct" {
        run_direct(&instance, repetitions)?;
    } else {
        run_ergodis(&instance, repetitions, stage == "pareto")?;
    }
    Ok(())
}

fn parse_instance(text: &str) -> Result<Instance, Box<dyn Error>> {
    let mut words = text.split_whitespace();
    let vertices = next_usize(&mut words, "vertex count")?;
    let arc_count = next_usize(&mut words, "arc count")?;
    let resources = next_usize(&mut words, "resource count")?;
    if vertices < 2 || resources != 1 {
        return Err("the example currently requires at least two vertices and K=1".into());
    }
    let lower = next_u32(&mut words, "resource lower bound")?;
    let budget = next_u32(&mut words, "resource upper bound")?;
    if lower != 0 || budget == 0 {
        return Err("the example currently requires lower bound zero and positive budget".into());
    }
    for _ in 0..vertices {
        if next_u32(&mut words, "vertex resource")? != 0 {
            return Err("the example currently requires zero vertex resources".into());
        }
    }

    let mut by_source = vec![Vec::new(); vertices];
    for input_id in 0..arc_count {
        let source = next_usize(&mut words, "arc source")?;
        let target = next_usize(&mut words, "arc target")?;
        let cost = next_u32(&mut words, "arc cost")?;
        let resource = next_u32(&mut words, "arc resource")?;
        if source == 0 || source > vertices || target == 0 || target > vertices {
            return Err("arc endpoint lies outside 1..=n".into());
        }
        by_source[source - 1].push(Arc {
            target: (target - 1) as u32,
            cost,
            resource,
            input_id: input_id as u32,
        });
    }
    if words.next().is_some() {
        return Err("trailing data after the declared arcs".into());
    }
    for arcs in &mut by_source {
        arcs.sort_unstable_by_key(|arc| (arc.resource, arc.cost, arc.target, arc.input_id));
    }
    let mut offsets = Vec::with_capacity(vertices + 1);
    let mut arcs = Vec::with_capacity(arc_count);
    offsets.push(0_u32);
    for outgoing in by_source {
        arcs.extend(outgoing);
        offsets.push(u32::try_from(arcs.len())?);
    }
    Ok(Instance {
        vertices,
        budget,
        offsets: offsets.into_boxed_slice(),
        arcs: arcs.into_boxed_slice(),
    })
}

fn next_u32<'a>(
    words: &mut impl Iterator<Item = &'a str>,
    label: &str,
) -> Result<u32, Box<dyn Error>> {
    Ok(words
        .next()
        .ok_or_else(|| format!("missing {label}"))?
        .parse()?)
}

fn next_usize<'a>(
    words: &mut impl Iterator<Item = &'a str>,
    label: &str,
) -> Result<usize, Box<dyn Error>> {
    Ok(words
        .next()
        .ok_or_else(|| format!("missing {label}"))?
        .parse()?)
}

fn outgoing(instance: &Instance, vertex: usize) -> &[Arc] {
    &instance.arcs[instance.offsets[vertex] as usize..instance.offsets[vertex + 1] as usize]
}

fn build_zero_closure(instance: &Instance) -> Result<ZeroClosure, Box<dyn Error>> {
    let n = instance.vertices;
    let mut distances = vec![INF; n * n];
    let mut next_arcs = vec![ABSENT; n * n];
    for vertex in 0..n {
        distances[vertex * n + vertex] = 0;
    }
    for source in 0..n {
        for arc in outgoing(instance, source)
            .iter()
            .filter(|arc| arc.resource == 0)
        {
            let cell = source * n + arc.target as usize;
            if arc.cost < distances[cell]
                || (arc.cost == distances[cell] && arc.input_id < next_arcs[cell])
            {
                distances[cell] = arc.cost;
                next_arcs[cell] = arc.input_id;
            }
        }
    }
    for middle in 0..n {
        for source in 0..n {
            let prefix = distances[source * n + middle];
            if prefix == INF {
                continue;
            }
            for target in 0..n {
                let suffix = distances[middle * n + target];
                if suffix == INF {
                    continue;
                }
                let candidate = prefix
                    .checked_add(suffix)
                    .ok_or("zero-resource closure cost overflow")?;
                let cell = source * n + target;
                if candidate < distances[cell] {
                    distances[cell] = candidate;
                    next_arcs[cell] = next_arcs[source * n + middle];
                }
            }
        }
    }
    Ok(ZeroClosure {
        distances: distances.into_boxed_slice(),
        next_arcs: next_arcs.into_boxed_slice(),
    })
}

fn build_actions(instance: &Instance, zero: &ZeroClosure) -> Result<Vec<Action>, Box<dyn Error>> {
    let dead = instance.vertices as u32;
    let mut grouped: BTreeMap<u32, Vec<Vec<MacroArc>>> = BTreeMap::new();
    let n = instance.vertices;
    for source in 0..n {
        let mut best: BTreeMap<(u32, u32), (u32, u32, u32)> = BTreeMap::new();
        for positive_source in 0..n {
            let prefix = zero.distances[source * n + positive_source];
            if prefix == INF {
                continue;
            }
            for arc in outgoing(instance, positive_source)
                .iter()
                .filter(|arc| arc.resource != 0)
            {
                let cost = prefix
                    .checked_add(arc.cost)
                    .ok_or("macro-transition cost overflow")?;
                let key = (arc.resource, arc.target);
                let candidate = (cost, positive_source as u32, arc.input_id);
                if best.get(&key).is_none_or(|&retained| candidate < retained) {
                    best.insert(key, candidate);
                }
            }
        }
        for ((resource, target), (cost, positive_source, input_id)) in best {
            grouped
                .entry(resource)
                .or_insert_with(|| vec![Vec::new(); n])[source]
                .push(MacroArc {
                    target,
                    cost,
                    resource,
                    positive_source,
                    input_id,
                });
        }
    }
    let mut actions = Vec::new();
    for (resource, mut sources) in grouped {
        for arcs in &mut sources {
            arcs.sort_unstable_by_key(|arc| (arc.cost, arc.target, arc.input_id));
        }
        let width = sources.iter().map(Vec::len).max().unwrap_or(0);
        for slot in 0..width {
            let mut targets = vec![dead; instance.vertices + 1];
            let mut costs = vec![ABSENT; instance.vertices + 1];
            let mut positive_sources = vec![ABSENT; instance.vertices + 1];
            let mut input_ids = vec![ABSENT; instance.vertices + 1];
            for (source, arcs) in sources.iter().enumerate() {
                if let Some(arc) = arcs.get(slot) {
                    targets[source] = arc.target;
                    costs[source] = arc.cost;
                    positive_sources[source] = arc.positive_source;
                    input_ids[source] = arc.input_id;
                }
            }
            actions.push(Action {
                resource,
                targets: targets.into_boxed_slice(),
                costs: costs.into_boxed_slice(),
                positive_sources: positive_sources.into_boxed_slice(),
                input_ids: input_ids.into_boxed_slice(),
            });
        }
    }
    Ok(actions)
}

fn run_ergodis(
    instance: &Instance,
    repetitions: usize,
    use_pareto: bool,
) -> Result<(), Box<dyn Error>> {
    if instance.vertices >= OUTPUT_WITNESS_BIT as usize {
        return Err("vertex count exceeds the compact output-witness namespace".into());
    }
    let zero = build_zero_closure(instance)?;
    let actions = build_actions(instance, &zero)?;
    let state_count = instance.vertices + 1;
    let sort_count = instance.budget as usize + 1;
    let state_counts = vec![u32::try_from(state_count)?; sort_count];

    let mut generators = Vec::new();
    let mut generator_meta = Vec::new();
    for source in 0..sort_count {
        for (action, descriptor) in actions.iter().enumerate() {
            let target = source + descriptor.resource as usize;
            if target < sort_count {
                generators.push(LayeredGeneratorSpec {
                    source_sort: source as u32,
                    target_sort: target as u32,
                });
                generator_meta.push(GeneratorMeta {
                    source_sort: source as u32,
                    action: action as u32,
                });
            }
        }
    }
    let entry_sorts = (0..sort_count as u32).collect::<Vec<_>>();
    let compile_started = Instant::now();
    let (frozen, frontier) = compile_layered_frozen_dag_audited(
        &state_counts,
        &generators,
        &entry_sorts,
        |_, state| state,
        |generator, state| {
            actions[generator_meta[generator as usize].action as usize].targets[state as usize]
        },
        &mut io::sink(),
    )?;
    let compile_ns = compile_started.elapsed().as_nanos();
    let plan = FrozenParetoPlan::new(&frozen)?;
    let start_class = frozen.entry_class(0, 0).ok_or("missing start class")?;
    if !use_pareto {
        return run_forward(
            instance,
            repetitions,
            &zero,
            &actions,
            &generator_meta,
            &frozen,
            &frontier,
            &plan,
            start_class,
            compile_ns,
        );
    }
    let query = plan.query(&[start_class])?;

    let min_resource = actions
        .iter()
        .map(|action| action.resource)
        .min()
        .ok_or("instance has no arcs")?;
    let max_macro_cost = actions
        .iter()
        .flat_map(|action| action.costs.iter())
        .filter(|&&cost| cost != ABSENT)
        .copied()
        .max()
        .unwrap_or(0);
    let cost_cap = (instance.budget / min_resource + 1)
        .checked_mul(max_macro_cost)
        .ok_or("cost cap overflow")?;
    if cost_cap == u32::MAX {
        return Err("cost cap exhausts the finite scalar namespace".into());
    }
    let monoid = ScalarCap { cap: cost_cap };
    let empty = WitnessedParetoFront::new(&monoid, std::iter::empty())?;
    let destination = instance.vertices - 1;
    let mut output_fronts = Vec::with_capacity(state_count);
    for state in 0..state_count {
        let cost = if state < instance.vertices {
            zero.distances[state * instance.vertices + destination]
        } else {
            INF
        };
        output_fronts.push(if cost == INF {
            empty.clone()
        } else {
            WitnessedParetoFront::new(
                &monoid,
                [ParetoWitness {
                    resource: cost,
                    witness: if state == destination {
                        0
                    } else {
                        OUTPUT_WITNESS_BIT | state as u32
                    },
                }],
            )?
        });
    }
    let mut transition_fronts = vec![empty.clone(); plan.transition_front_count()];
    for sort in 0..sort_count as u32 {
        let range = frozen.class_range(sort).ok_or("missing class range")?;
        let outgoing_generators = plan
            .outgoing_generators(sort)
            .ok_or("missing outgoing-generator range")?;
        let mut representatives = vec![ABSENT; range.len as usize];
        for state in 0..state_count as u32 {
            let class = frozen
                .entry_class(sort, state)
                .ok_or("missing entry class")?;
            representatives[(class - range.start) as usize] =
                representatives[(class - range.start) as usize].min(state);
        }
        for (class_local, &state) in representatives.iter().enumerate() {
            if state == ABSENT {
                return Err("quotient class has no raw representative".into());
            }
            let class = range.start + class_local as u32;
            let front_range = plan
                .transition_front_range(class)
                .ok_or("missing transition-front range")?;
            if front_range.len() != outgoing_generators.len() {
                return Err("transition-front/generator range mismatch".into());
            }
            for (front_index, &generator) in front_range.zip(outgoing_generators) {
                let action = &actions[generator_meta[generator as usize].action as usize];
                let cost = action.costs[state as usize];
                if cost != ABSENT {
                    transition_fronts[front_index] = WitnessedParetoFront::new(
                        &monoid,
                        [ParetoWitness {
                            resource: cost,
                            witness: generator,
                        }],
                    )?;
                }
            }
        }
    }
    let objective =
        plan.validate_transition_objective(&monoid, &output_fronts, &transition_fronts)?;
    let mut workspace = WitnessedParetoWorkspace::with_capacity(1);
    if plan.transition_front_count() >= OUTPUT_WITNESS_BIT as usize {
        return Err("witness arena exceeds its compact ID namespace".into());
    }
    let mut witness_nodes = Vec::with_capacity(plan.transition_front_count());
    let solve = |workspace: &mut WitnessedParetoWorkspace,
                 witness_nodes: &mut Vec<PathNode>|
     -> Result<_, Box<dyn Error>> {
        witness_nodes.clear();
        let answer = query.evaluate_transitions_validated(
            &objective,
            workspace,
            |generator, _, suffix| {
                assert!(witness_nodes.len() < witness_nodes.capacity());
                let id = witness_nodes.len() as u32 + 1;
                witness_nodes.push(PathNode { generator, suffix });
                id
            },
        )?;
        Ok(answer)
    };
    let warm = solve(&mut workspace, &mut witness_nodes)?;
    let expected_cost = answer_cost(&warm.0)?;
    let expected_path = replay_ergodis(
        instance,
        &actions,
        &generator_meta,
        &zero,
        &witness_nodes,
        warm.0[0].entries()[0].witness,
    )?;
    if expected_path.0 != expected_cost {
        return Err("Ergodis witness cost does not match its optimum".into());
    }
    black_box(warm);

    let started = Instant::now();
    let mut checksum = 0_u64;
    let mut peak_live_entries = 0_usize;
    for _ in 0..repetitions {
        let answer = solve(&mut workspace, &mut witness_nodes)?;
        let cost = answer_cost(&answer.0)?;
        checksum = checksum
            .wrapping_mul(0x9e37_79b9)
            .wrapping_add(u64::from(cost));
        peak_live_entries = peak_live_entries.max(answer.1.peak_live_entries);
        black_box(answer);
    }
    let elapsed_ns = started.elapsed().as_nanos();
    println!(
        "{{\"stage\":\"pareto\",\"vertices\":{},\"arcs\":{},\"budget\":{},\"raw_states\":{},\"classes\":{},\"generators\":{},\"transition_fronts\":{},\"frontier_classes\":{},\"compile_ns\":{},\"repetitions\":{},\"elapsed_ns\":{},\"peak_live_entries\":{},\"cost\":{},\"path_arcs\":{},\"checksum\":{}}}",
        instance.vertices,
        instance.arcs.len(),
        instance.budget,
        state_count * sort_count,
        frozen.storage().classes,
        frozen.generator_count(),
        plan.transition_front_count(),
        frontier.peak_live_state_classes,
        compile_ns,
        repetitions,
        elapsed_ns,
        peak_live_entries,
        expected_cost,
        expected_path.1,
        checksum,
    );
    Ok(())
}

#[allow(clippy::too_many_arguments)]
fn run_forward(
    instance: &Instance,
    repetitions: usize,
    zero: &ZeroClosure,
    actions: &[Action],
    generator_meta: &[GeneratorMeta],
    frozen: &ergodis::observational::FrozenObservation,
    frontier: &ergodis::observational::LayeredFrontierMetrics,
    pareto: &FrozenParetoPlan<'_>,
    start_class: u32,
    compile_ns: u128,
) -> Result<(), Box<dyn Error>> {
    let destination = instance.vertices - 1;
    let mut output_costs = vec![ABSENT_SHORTEST_PATH_COST; instance.vertices + 1];
    for (state, output) in output_costs[..instance.vertices].iter_mut().enumerate() {
        let cost = zero.distances[state * instance.vertices + destination];
        if cost != INF {
            *output = u64::from(cost);
        }
    }
    let table_bytes = pareto
        .transition_front_count()
        .checked_mul(std::mem::size_of::<u64>())
        .ok_or("transition table size overflow")?;
    const MAX_TRANSITION_BYTES: usize = 1 << 30;
    if table_bytes > MAX_TRANSITION_BYTES {
        return Err(format!(
            "forward transition table needs {table_bytes} bytes (safety cap {MAX_TRANSITION_BYTES})"
        )
        .into());
    }
    let mut transition_costs = vec![ABSENT_SHORTEST_PATH_COST; pareto.transition_front_count()];
    for sort in 0..frozen.sort_count() as u32 {
        let range = frozen.class_range(sort).ok_or("missing class range")?;
        let outgoing_generators = pareto
            .outgoing_generators(sort)
            .ok_or("missing outgoing-generator range")?;
        let mut representatives = vec![ABSENT; range.len as usize];
        for state in 0..=instance.vertices as u32 {
            let class = frozen
                .entry_class(sort, state)
                .ok_or("missing entry class")?;
            representatives[(class - range.start) as usize] =
                representatives[(class - range.start) as usize].min(state);
        }
        for (class_local, &state) in representatives.iter().enumerate() {
            if state == ABSENT {
                return Err("quotient class has no raw representative".into());
            }
            let class = range.start + class_local as u32;
            let cost_range = pareto
                .transition_front_range(class)
                .ok_or("missing transition-cost range")?;
            for (cost_index, &generator) in cost_range.zip(outgoing_generators) {
                let action = &actions[generator_meta[generator as usize].action as usize];
                let cost = action.costs[state as usize];
                if cost != ABSENT {
                    transition_costs[cost_index] = u64::from(cost);
                }
            }
        }
    }
    let plan = FrozenShortestPathPlan::new(pareto)?;
    let objective = plan.validate_objective(&output_costs, &transition_costs)?;
    let mut workspace = FrozenShortestPathWorkspace::new(plan.class_count())?;
    let warm = plan.solve_validated(start_class, &objective, &mut workspace)?;
    plan.verify_result(start_class, &objective, &warm)?;
    let expected_path =
        replay_generators(instance, actions, generator_meta, zero, &warm.generators)?;
    if u64::from(expected_path.0) != warm.cost {
        return Err("forward witness cost does not match its optimum".into());
    }
    let expected_cost = warm.cost;
    let expected_metrics = warm.metrics;
    black_box(warm);

    let started = Instant::now();
    let mut checksum = 0_u64;
    for _ in 0..repetitions {
        let result = plan.solve_validated(start_class, &objective, &mut workspace)?;
        checksum = checksum.wrapping_mul(0x9e37_79b9).wrapping_add(result.cost);
        black_box(result);
    }
    let elapsed_ns = started.elapsed().as_nanos();
    println!(
        "{{\"stage\":\"forward\",\"vertices\":{},\"arcs\":{},\"budget\":{},\"raw_states\":{},\"classes\":{},\"generators\":{},\"transition_costs\":{},\"transition_bytes\":{},\"frontier_classes\":{},\"compile_ns\":{},\"repetitions\":{},\"elapsed_ns\":{},\"settled_classes\":{},\"scanned_transitions\":{},\"peak_heap_classes\":{},\"cost\":{},\"path_arcs\":{},\"checksum\":{}}}",
        instance.vertices,
        instance.arcs.len(),
        instance.budget,
        (instance.vertices + 1) * (instance.budget as usize + 1),
        frozen.storage().classes,
        frozen.generator_count(),
        transition_costs.len(),
        table_bytes,
        frontier.peak_live_state_classes,
        compile_ns,
        repetitions,
        elapsed_ns,
        expected_metrics.settled_classes,
        expected_metrics.scanned_transitions,
        expected_metrics.peak_heap_classes,
        expected_cost,
        expected_path.1,
        checksum,
    );
    Ok(())
}

fn replay_generators(
    instance: &Instance,
    actions: &[Action],
    generator_meta: &[GeneratorMeta],
    zero: &ZeroClosure,
    generators: &[u32],
) -> Result<(u32, usize), Box<dyn Error>> {
    let mut state = 0_usize;
    let mut resource = 0_u32;
    let mut cost = 0_u32;
    let mut length = 0_usize;
    for &generator in generators {
        let meta = *generator_meta
            .get(generator as usize)
            .ok_or("witness generator lies outside the presentation")?;
        if meta.source_sort != resource {
            return Err("witness generator starts at the wrong resource layer".into());
        }
        let action = &actions[meta.action as usize];
        let target = action.targets[state];
        let edge_cost = action.costs[state];
        if target == instance.vertices as u32
            || edge_cost == ABSENT
            || action.positive_sources[state] == ABSENT
            || action.input_ids[state] == ABSENT
        {
            return Err("witness selects an absent transition".into());
        }
        let positive_source = action.positive_sources[state] as usize;
        let prefix = replay_zero_path(instance, zero, state, positive_source)?;
        let positive = outgoing(instance, positive_source)
            .iter()
            .find(|arc| arc.input_id == action.input_ids[state])
            .ok_or("macro witness selects an absent positive-resource arc")?;
        if positive.resource != action.resource
            || positive.target != target
            || prefix.0.checked_add(positive.cost) != Some(edge_cost)
        {
            return Err("macro witness does not replay to its compiled transition".into());
        }
        state = target as usize;
        resource += action.resource;
        cost = cost.checked_add(edge_cost).ok_or("witness cost overflow")?;
        length += prefix.1 + 1;
    }
    let suffix = replay_zero_path(instance, zero, state, instance.vertices - 1)?;
    cost = cost.checked_add(suffix.0).ok_or("witness cost overflow")?;
    length += suffix.1;
    if resource > instance.budget {
        return Err("witness exceeds its resource budget".into());
    }
    Ok((cost, length))
}

fn answer_cost(fronts: &[WitnessedParetoFront]) -> Result<u32, Box<dyn Error>> {
    let entries = fronts.first().ok_or("missing answer front")?.entries();
    if entries.len() != 1 {
        return Err("RCSP answer is infeasible or not scalar".into());
    }
    Ok(entries[0].resource)
}

fn replay_ergodis(
    instance: &Instance,
    actions: &[Action],
    generator_meta: &[GeneratorMeta],
    zero: &ZeroClosure,
    nodes: &[PathNode],
    mut witness: u32,
) -> Result<(u32, usize), Box<dyn Error>> {
    let mut state = 0_usize;
    let mut resource = 0_u32;
    let mut cost = 0_u32;
    let mut length = 0_usize;
    while witness != 0 {
        if witness & OUTPUT_WITNESS_BIT != 0 {
            if witness & !OUTPUT_WITNESS_BIT != state as u32 {
                return Err("output witness starts at the wrong vertex".into());
            }
            let suffix = replay_zero_path(instance, zero, state, instance.vertices - 1)?;
            cost = cost.checked_add(suffix.0).ok_or("witness cost overflow")?;
            length += suffix.1;
            state = instance.vertices - 1;
            break;
        }
        let node = *nodes
            .get(witness as usize - 1)
            .ok_or("witness node lies outside the arena")?;
        let meta = *generator_meta
            .get(node.generator as usize)
            .ok_or("witness generator lies outside the presentation")?;
        if meta.source_sort != resource {
            return Err("witness generator starts at the wrong resource layer".into());
        }
        let action = &actions[meta.action as usize];
        let target = action.targets[state];
        let edge_cost = action.costs[state];
        if target == instance.vertices as u32
            || edge_cost == ABSENT
            || action.positive_sources[state] == ABSENT
            || action.input_ids[state] == ABSENT
        {
            return Err("witness selects an absent transition".into());
        }
        let positive_source = action.positive_sources[state] as usize;
        let prefix = replay_zero_path(instance, zero, state, positive_source)?;
        let positive = outgoing(instance, positive_source)
            .iter()
            .find(|arc| arc.input_id == action.input_ids[state])
            .ok_or("macro witness selects an absent positive-resource arc")?;
        if positive.resource != action.resource
            || positive.target != target
            || prefix.0.checked_add(positive.cost) != Some(edge_cost)
        {
            return Err("macro witness does not replay to its compiled transition".into());
        }
        state = target as usize;
        resource += action.resource;
        cost = cost.checked_add(edge_cost).ok_or("witness cost overflow")?;
        length += prefix.1 + 1;
        witness = node.suffix;
    }
    if state != instance.vertices - 1 || resource > instance.budget {
        return Err("witness does not end feasibly at the destination".into());
    }
    Ok((cost, length))
}

fn replay_zero_path(
    instance: &Instance,
    zero: &ZeroClosure,
    mut source: usize,
    target: usize,
) -> Result<(u32, usize), Box<dyn Error>> {
    let mut cost = 0_u32;
    let mut length = 0_usize;
    while source != target {
        let input_id = zero.next_arcs[source * instance.vertices + target];
        let arc = outgoing(instance, source)
            .iter()
            .find(|arc| arc.input_id == input_id && arc.resource == 0)
            .ok_or("zero-resource witness path is missing")?;
        source = arc.target as usize;
        cost = cost
            .checked_add(arc.cost)
            .ok_or("zero-resource witness cost overflow")?;
        length += 1;
        if length > instance.vertices * instance.vertices {
            return Err("zero-resource witness path does not terminate".into());
        }
    }
    Ok((cost, length))
}

fn run_direct(instance: &Instance, repetitions: usize) -> Result<(), Box<dyn Error>> {
    let layers = instance.budget as usize + 1;
    let cells = layers
        .checked_mul(instance.vertices)
        .ok_or("direct table size overflow")?;
    let mut costs = vec![INF; cells];
    if cells > u32::MAX as usize {
        return Err("expanded graph exceeds compact node IDs".into());
    }
    let mut predecessors = vec![
        Predecessor {
            previous: ABSENT,
            input_id: ABSENT,
        };
        cells
    ];
    let heap_capacity = layers
        .checked_mul(instance.arcs.len())
        .and_then(|value| value.checked_add(1))
        .ok_or("direct heap bound overflow")?;
    let mut heap = BinaryHeap::with_capacity(heap_capacity);
    let solve = |costs: &mut [u32],
                 predecessors: &mut [Predecessor],
                 heap: &mut BinaryHeap<(Reverse<u32>, Reverse<u32>)>|
     -> Result<(u32, u32), Box<dyn Error>> {
        costs.fill(INF);
        heap.clear();
        costs[0] = 0;
        heap.push((Reverse(0), Reverse(0)));
        while let Some((Reverse(cost), Reverse(node))) = heap.pop() {
            if costs[node as usize] != cost {
                continue;
            }
            let consumed = node as usize / instance.vertices;
            let source = node as usize % instance.vertices;
            if source == instance.vertices - 1 {
                return Ok((cost, node));
            }
            for arc in outgoing(instance, source) {
                let next_consumed = consumed + arc.resource as usize;
                if next_consumed >= layers {
                    continue;
                }
                let next = next_consumed * instance.vertices + arc.target as usize;
                let candidate = cost
                    .checked_add(arc.cost)
                    .ok_or("direct path cost overflow")?;
                if candidate < costs[next] {
                    costs[next] = candidate;
                    predecessors[next] = Predecessor {
                        previous: node,
                        input_id: arc.input_id,
                    };
                    if heap.len() == heap.capacity() {
                        return Err("direct heap exceeded its proved edge-relaxation bound".into());
                    }
                    heap.push((Reverse(candidate), Reverse(next as u32)));
                }
            }
        }
        Err("instance is infeasible".into())
    };
    let (expected_cost, expected_goal) = solve(&mut costs, &mut predecessors, &mut heap)?;
    let expected_path = replay_direct(instance, &predecessors, expected_goal)?;
    if expected_path.0 != expected_cost {
        return Err("direct witness cost does not match its optimum".into());
    }
    let started = Instant::now();
    let mut checksum = 0_u64;
    for _ in 0..repetitions {
        let (cost, goal) = solve(&mut costs, &mut predecessors, &mut heap)?;
        checksum = checksum
            .wrapping_mul(0x9e37_79b9)
            .wrapping_add(u64::from(cost));
        black_box((cost, goal));
    }
    let elapsed_ns = started.elapsed().as_nanos();
    println!(
        "{{\"stage\":\"direct\",\"vertices\":{},\"arcs\":{},\"budget\":{},\"cells\":{},\"repetitions\":{},\"elapsed_ns\":{},\"cost\":{},\"path_arcs\":{},\"checksum\":{}}}",
        instance.vertices,
        instance.arcs.len(),
        instance.budget,
        cells,
        repetitions,
        elapsed_ns,
        expected_cost,
        expected_path.1,
        checksum,
    );
    Ok(())
}

fn replay_direct(
    instance: &Instance,
    predecessors: &[Predecessor],
    mut node: u32,
) -> Result<(u32, usize), Box<dyn Error>> {
    let mut cost = 0_u32;
    let mut length = 0_usize;
    while node != 0 {
        let predecessor = *predecessors
            .get(node as usize)
            .ok_or("direct witness node lies outside the table")?;
        if predecessor.previous == ABSENT {
            return Err("direct witness has no predecessor".into());
        }
        let previous_state = predecessor.previous as usize % instance.vertices;
        let previous_resource = predecessor.previous as usize / instance.vertices;
        let state = node as usize % instance.vertices;
        let resource = node as usize / instance.vertices;
        let arc = outgoing(instance, previous_state)
            .iter()
            .find(|arc| arc.input_id == predecessor.input_id)
            .ok_or("direct witness selects an absent arc")?;
        if arc.target as usize != state || previous_resource + arc.resource as usize != resource {
            return Err("direct witness edge does not join its expanded nodes".into());
        }
        cost = cost
            .checked_add(arc.cost)
            .ok_or("direct witness cost overflow")?;
        length += 1;
        node = predecessor.previous;
        if length > predecessors.len() {
            return Err("direct witness does not terminate".into());
        }
    }
    Ok((cost, length))
}
