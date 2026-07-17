#!/usr/bin/env python3
"""Exact certificate for C253's seven-state continuation witness.

The script exhausts all failure-domain sets and all 877 partitions of the
seven states.  The latter proves minimality only in the explicitly declared
class of feature-preserving quotients of this phase automaton.
"""

from itertools import combinations


DOMAINS = ("A", "B", "C")
WEIGHT = {domain: 1 for domain in DOMAINS}
STATES = ("start", "reserved", "failed", "switched", "commit", "abort", "unsafe")
ACCEPTABLE = frozenset(("commit", "abort"))
ACTIONS = {
    "start": ("start_A", "run_B"),
    "reserved": ("finish_A", "switch_to_B"),
    "failed": ("compensate",),
    "switched": ("finish_B",),
}

# (material state, compensation stack, failed history, switching cost, phase)
OBSERVATION = {
    "start": ("clean", (), (), 0, "running"),
    "reserved": ("reserved", ("cancel_A",), (), 0, "running"),
    "failed": ("reserved", ("cancel_A",), ("A",), 0, "running"),
    "switched": ("clean", (), (), 1, "running"),
    "commit": ("committed", (), (), 0, "commit"),
    "abort": ("clean", (), (), 0, "safe_abort"),
    "unsafe": ("residual_effect", (), (), 0, "unsafe"),
}


def successor(state, action, failed):
    table = {
        ("start", "start_A"): "reserved",
        ("start", "run_B"): "abort" if "B" in failed else "commit",
        ("reserved", "finish_A"): "failed" if "A" in failed else "commit",
        ("reserved", "switch_to_B"): "unsafe" if "C" in failed else "switched",
        ("failed", "compensate"): "unsafe" if "C" in failed else "abort",
        ("switched", "finish_B"): "abort" if "B" in failed else "commit",
    }
    return table[(state, action)]


def winning_states(failed, goals=ACCEPTABLE):
    """Strong winning least fixed point for a fixed persistent failure set."""
    winning = set(goals)
    while True:
        grown = winning | {
            state
            for state, actions in ACTIONS.items()
            if any(successor(state, action, failed) in winning for action in actions)
        }
        if grown == winning:
            return frozenset(winning)
        winning = grown


def subsets():
    for size in range(len(DOMAINS) + 1):
        for chosen in combinations(DOMAINS, size):
            yield frozenset(chosen)


def residual_threshold(state):
    losing = [
        (sum(WEIGHT[d] for d in failed), failed)
        for failed in subsets()
        if state not in winning_states(failed)
    ]
    return min(losing, default=(float("inf"), frozenset()))


def partitions(items):
    if not items:
        yield ()
        return
    first, *rest = items
    for partition in partitions(rest):
        yield ((first,),) + partition
        for index in range(len(partition)):
            yield partition[:index] + (partition[index] + (first,),) + partition[index + 1 :]


def feature_preserving(partition):
    return all(len({OBSERVATION[state] for state in block}) == 1 for block in partition)


def main():
    thresholds = {state: residual_threshold(state) for state in ACTIONS}
    assert thresholds["reserved"][0] == 2
    assert thresholds["failed"] == (1, frozenset(("C",)))
    assert thresholds["switched"][0] == float("inf")
    assert "start" in winning_states(frozenset(DOMAINS))

    # Initial commit-only diversity: A and B must both fail.  Safe abort is not
    # a committed completion, so this deliberately uses a different predicate.
    commit_winning = winning_states(frozenset(("A", "B")), frozenset(("commit",)))
    assert "start" not in commit_winning
    for singleton in map(frozenset, ((d,) for d in DOMAINS)):
        assert "start" in winning_states(singleton, frozenset(("commit",)))

    all_partitions = list(partitions(STATES))
    preserving = [partition for partition in all_partitions if feature_preserving(partition)]
    assert len(all_partitions) == 877
    assert preserving == [tuple((state,) for state in STATES)]

    print("commit-only initial blocker cost: 2 (A+B)")
    print("acceptable-terminal residual threshold at reserved: 2")
    print("acceptable-terminal residual threshold after A failure: 1 (C)")
    print("acceptable-terminal initial policy threshold: infinity (clean abort via B)")
    print("strong and strong-cyclic coincide here: every fixed-D transition is deterministic")
    print("feature-preserving quotient check: 877 partitions, identity only")


if __name__ == "__main__":
    main()
