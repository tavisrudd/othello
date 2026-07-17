#!/usr/bin/env python3
"""Bounded congruence scout for C231's scalar 2-sum interface messages.

For a fixed locality radius, regard a pointed component and active seed as a
Moore state.  Its inputs are the truncated interface costs supplied by a
partner; its outputs are private ground size, active count, and its own
truncated interface cost.  The proposed signature adds the output after one
step for every possible input.  We test whether this one-step refinement is
already a transition congruence and replay equal-signature states against all
bounded partners.
"""

from __future__ import annotations

import argparse
import importlib.util
import itertools
import json
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from types import ModuleType


HERE = Path(__file__).resolve().parent
C231_PATH = HERE / "2026-07-16-c231-two-sum-repair-convolution.py"


def load_c231() -> ModuleType:
    spec = importlib.util.spec_from_file_location("c231_two_sum", C231_PATH)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {C231_PATH}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C231 = load_c231()


@dataclass(frozen=True)
class State:
    component: int
    columns: tuple[int, ...]
    circuit_family: tuple[frozenset[int], ...]
    active: frozenset[int]

    @property
    def private_size(self) -> int:
        return len(self.columns) - 1


def input_alphabet(radius: int) -> tuple[int, ...]:
    """Use radius + 1 as the unique value representing every over-budget cost."""
    return tuple(range(radius + 2))


def truncate(cost: int, radius: int) -> int:
    return min(cost, radius + 1)


def output(state: State, radius: int) -> tuple[int, int, int]:
    return (
        state.private_size,
        len(state.active),
        truncate(C231.interface_cost(state.active, state.circuit_family), radius),
    )


def transition(state: State, incoming: int, radius: int) -> State:
    additions: set[int] = set()
    for target in frozenset(range(1, len(state.columns))) - state.active:
        if C231.internal_cost(target, state.active, state.circuit_family) <= radius:
            additions.add(target)
            continue
        if (
            C231.assisted_cost(target, state.active, state.circuit_family) + incoming
            <= radius
        ):
            additions.add(target)
    return State(
        component=state.component,
        columns=state.columns,
        circuit_family=state.circuit_family,
        active=state.active | additions,
    )


def state_catalog() -> tuple[State, ...]:
    states = []
    for component, (columns, circuit_family) in enumerate(component_catalog()):
        private_ground = tuple(range(1, len(columns)))
        for active in C231.subsets(private_ground):
            states.append(State(component, columns, circuit_family, active))
    return tuple(states)


def component_catalog() -> tuple[
    tuple[tuple[int, ...], tuple[frozenset[int], ...]], ...
]:
    """All simple binary pointed restrictions inside PG(2,2).

    The interface is the fixed column 1.  Private columns are distinct nonzero
    vectors other than 1, and the interface must lie in a circuit, equivalently
    it is not a coloop.  Private sizes two through six exhaust this universe.
    """
    result = []
    for other_count in range(2, 7):
        for rest in itertools.combinations(range(2, 8), other_count):
            columns = (1,) + rest
            circuit_family = C231.circuits(columns)
            if any(0 in circuit for circuit in circuit_family):
                result.append((columns, circuit_family))
    return tuple(result)


def class_ids(signatures: list[tuple[object, ...]]) -> tuple[int, ...]:
    identifiers: dict[tuple[object, ...], int] = {}
    result = []
    for signature in signatures:
        if signature not in identifiers:
            identifiers[signature] = len(identifiers)
        result.append(identifiers[signature])
    return tuple(result)


def partition_data(
    states: tuple[State, ...], radius: int
) -> tuple[
    tuple[tuple[int, ...], ...],
    tuple[int, ...],
    tuple[int, ...],
    tuple[int, ...],
    int,
]:
    index = {
        (state.component, state.active): state_index
        for state_index, state in enumerate(states)
    }
    transitions = tuple(
        tuple(
            index[(state.component, transition(state, incoming, radius).active)]
            for incoming in input_alphabet(radius)
        )
        for state in states
    )
    base = class_ids([output(state, radius) for state in states])
    proposed = class_ids(
        [
            (
                output(state, radius),
                tuple(output(states[target], radius) for target in transitions[i]),
            )
            for i, state in enumerate(states)
        ]
    )

    refined = proposed
    refinement_rounds = 0
    while True:
        enlarged = class_ids(
            [
                (output(state, radius), tuple(refined[target] for target in transitions[i]))
                for i, state in enumerate(states)
            ]
        )
        if enlarged == refined:
            break
        refined = enlarged
        refinement_rounds += 1
    return transitions, base, proposed, refined, refinement_rounds


def congruence_violations(
    classes: tuple[int, ...], transitions: tuple[tuple[int, ...], ...]
) -> list[tuple[int, int, int]]:
    groups: dict[int, list[int]] = defaultdict(list)
    for state, class_id in enumerate(classes):
        groups[class_id].append(state)
    violations = []
    for members in groups.values():
        representative = members[0]
        for state in members[1:]:
            for incoming, (left, right) in enumerate(
                zip(transitions[representative], transitions[state], strict=True)
            ):
                if classes[left] != classes[right]:
                    violations.append((representative, state, incoming))
                    break
    return violations


def state_record(state: State, radius: int) -> dict[str, object]:
    return {
        "component": state.component,
        "columns": list(state.columns),
        "active": sorted(state.active),
        "output": list(output(state, radius)),
    }


def coupled_trace(
    left: int,
    right: int,
    outputs: tuple[tuple[int, int, int], ...],
    transitions: tuple[tuple[int, ...], ...],
) -> tuple[tuple[int, ...], ...]:
    trace = []
    while True:
        _, left_active_count, left_beta = outputs[left]
        _, right_active_count, right_beta = outputs[right]
        trace.append(
            (
                left_active_count,
                left_beta,
                right_active_count,
                right_beta,
            )
        )
        enlarged_left = transitions[left][right_beta]
        enlarged_right = transitions[right][left_beta]
        if enlarged_left == left and enlarged_right == right:
            return tuple(trace)
        left, right = enlarged_left, enlarged_right


def partner_replay(
    states: tuple[State, ...],
    classes: tuple[int, ...],
    transitions: tuple[tuple[int, ...], ...],
    radius: int,
) -> tuple[int, dict[str, object] | None]:
    outputs = tuple(output(state, radius) for state in states)
    groups: dict[int, list[int]] = defaultdict(list)
    for state, class_id in enumerate(classes):
        groups[class_id].append(state)
    comparisons = 0
    for members in groups.values():
        representative = members[0]
        for equivalent in members[1:]:
            for partner_index in range(len(states)):
                comparisons += 1
                left_trace = coupled_trace(
                    representative, partner_index, outputs, transitions
                )
                right_trace = coupled_trace(equivalent, partner_index, outputs, transitions)
                if left_trace != right_trace:
                    return comparisons, {
                        "representative": representative,
                        "equivalent": equivalent,
                        "partner": partner_index,
                        "representative_state": state_record(
                            states[representative], radius
                        ),
                        "equivalent_state": state_record(states[equivalent], radius),
                        "partner_state": state_record(states[partner_index], radius),
                        "representative_trace": left_trace,
                        "equivalent_trace": right_trace,
                    }
    return comparisons, None


def check_radius(states: tuple[State, ...], radius: int) -> dict[str, object]:
    transitions, base, proposed, minimal, refinement_rounds = partition_data(
        states, radius
    )
    base_violations = congruence_violations(base, transitions)
    proposed_violations = congruence_violations(proposed, transitions)
    output_replay_comparisons, output_replay_counterexample = partner_replay(
        states, base, transitions, radius
    )
    replay_comparisons, replay_counterexample = partner_replay(
        states, proposed, transitions, radius
    )
    first_output_only_counterexample = None
    if base_violations:
        left, right, incoming = base_violations[0]
        first_output_only_counterexample = {
            "incoming": incoming,
            "left": state_record(states[left], radius),
            "right": state_record(states[right], radius),
            "left_next": state_record(states[transitions[left][incoming]], radius),
            "right_next": state_record(states[transitions[right][incoming]], radius),
        }
    return {
        "radius": radius,
        "input_alphabet": list(input_alphabet(radius)),
        "states": len(states),
        "output_only_classes": len(set(base)),
        "output_only_congruence_violations": len(base_violations),
        "first_output_only_counterexample": first_output_only_counterexample,
        "output_only_partner_replay_comparisons_until_decision": (
            output_replay_comparisons
        ),
        "output_only_partner_replay_counterexample": output_replay_counterexample,
        "proposed_one_step_classes": len(set(proposed)),
        "proposed_transition_congruence_violations": len(proposed_violations),
        "minimal_behavioral_classes": len(set(minimal)),
        "extra_refinement_rounds_after_proposed": refinement_rounds,
        "partner_replay_comparisons": replay_comparisons,
        "partner_replay_counterexample": replay_counterexample,
        "proposed_signature_is_congruence": not proposed_violations,
        "proposed_signature_matches_minimal_partition": proposed == minimal,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output", type=Path, default=Path(__file__).with_suffix(".json")
    )
    args = parser.parse_args()

    states = state_catalog()
    components = component_catalog()
    components_by_size = {
        str(size): sum(1 for columns, _ in components if len(columns) - 1 == size)
        for size in range(2, 7)
    }
    states_by_size = {
        str(size): sum(1 for state in states if state.private_size == size)
        for size in range(2, 7)
    }
    radius_checks = [check_radius(states, radius) for radius in C231.RADII]
    certificate = {
        "task": "C231 pre-allocation tree-congruence scout",
        "component_representations": len(components),
        "component_representations_by_private_size": components_by_size,
        "pointed_component_seed_states": len(states),
        "seed_states_by_private_size": states_by_size,
        "signature": {
            "output": ["private_ground_size", "active_count", "truncated_beta"],
            "refinement": "next output under every incoming truncated beta",
            "infinity_encoding": "radius + 1",
        },
        "radii": radius_checks,
        "total_proposed_partner_replay_comparisons": sum(
            check["partner_replay_comparisons"] for check in radius_checks
        ),
    }
    args.output.write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps(certificate, indent=2))


if __name__ == "__main__":
    main()
