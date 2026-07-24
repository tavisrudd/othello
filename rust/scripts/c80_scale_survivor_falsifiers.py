#!/usr/bin/env python3
"""C80: falsify scale-aware strict-overload survivor packets.

Each packet is incidence-only.  It restricts the replies allowed in the
strict-overload kernel and therefore defines a value-independent survivor
family with the same Y_NK boundary:

  omega(S) = 0: use the static Node-Kayles boundary;
  omega(S) > 0: every opponent move must have a packet reply whose target
                has smaller omega and remains in the restricted family.

The unrestricted packet is the canonical K_omega kernel and is retained as
a positive control.  The other packets compare the complete overload-load
vectors of the legal replies.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import sys
from collections import Counter
from fractions import Fraction
from functools import lru_cache
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/2026-07-24-c80-scale-survivor-falsifiers.json"
UPSTREAM_CERT = ROOT / "notes/2026-07-24-c80-strict-overload-kernel.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


KERNEL = load_module(
    ROOT / "rust/scripts/c80_strict_overload_kernel.py",
    "c80_scale_survivor_kernel",
)


def prefix_sums(vector: tuple[int, ...], length: int) -> tuple[int, ...]:
    total = 0
    result = []
    for index in range(length):
        if index < len(vector):
            total += vector[index]
        result.append(total)
    return tuple(result)


def weakly_dominates(
    left: tuple[int, ...], right: tuple[int, ...], *, lower: bool
) -> bool:
    """Strict weak-majorization dominance, with zero padding."""
    length = max(len(left), len(right))
    left_prefix = prefix_sums(left, length)
    right_prefix = prefix_sums(right, length)
    if lower:
        return all(a <= b for a, b in zip(left_prefix, right_prefix)) and any(
            a < b for a, b in zip(left_prefix, right_prefix)
        )
    return all(a >= b for a, b in zip(left_prefix, right_prefix)) and any(
        a > b for a, b in zip(left_prefix, right_prefix)
    )


class PacketKernel:
    PACKETS = (
        "all_strict",
        "fastest_total",
        "lower_majorization",
        "slowest_total",
        "upper_majorization",
        "reservoir_pareto",
        "retain_90pct",
        "retain_75pct",
        "retain_50pct",
        "retain_49pct",
        "retain_40pct",
        "retain_25pct",
        "retain_10pct",
    )

    def __init__(self, base, packet: str):
        if packet not in self.PACKETS:
            raise ValueError(packet)
        self.base = base
        self.packet = packet
        self.responses: dict[tuple[int, int], int] = {}

    @lru_cache(maxsize=None)
    def reply_rows(self, state: int, opponent: int) -> tuple[tuple, ...]:
        old_omega = self.base.omega(state)
        child = state | (1 << opponent)
        rows = []
        for reply in KERNEL.GEOMETRY.bits(self.base.game.legal_mask(child)):
            target = child | (1 << reply)
            target_omega = self.base.omega(target)
            if target_omega >= old_omega:
                continue
            legal = self.base.game.legal_mask(target)
            overload_vector = tuple(
                sorted(
                    (
                        max(0, (legal & line_mask).bit_count() - 2)
                        for line_mask, fixed_load in self.base.lines
                        if fixed_load + (target & line_mask).bit_count() == 0
                    ),
                    reverse=True,
                )
            )
            overload_vector = tuple(value for value in overload_vector if value)
            rows.append(
                (
                    reply,
                    target,
                    target_omega,
                    overload_vector,
                    (
                        target_omega,
                        len(overload_vector),
                        overload_vector[0] if overload_vector else 0,
                        legal.bit_count(),
                    ),
                )
            )
        return tuple(rows)

    def packet_rows(self, state: int, opponent: int) -> tuple[tuple, ...]:
        rows = self.reply_rows(state, opponent)
        assert rows
        boundary = tuple(
            row
            for row in rows
            if row[2] == 0 and self.base.contains(row[1])
        )

        def with_boundary(selected: tuple[tuple, ...]) -> tuple[tuple, ...]:
            replies = {row[0] for row in selected}
            return selected + tuple(
                row for row in boundary if row[0] not in replies
            )

        if self.packet == "all_strict":
            return rows
        if self.packet == "fastest_total":
            best = min(row[2] for row in rows)
            return tuple(row for row in rows if row[2] == best)
        if self.packet == "slowest_total":
            best = max(row[2] for row in rows)
            return with_boundary(tuple(row for row in rows if row[2] == best))
        if self.packet in ("lower_majorization", "upper_majorization"):
            lower = self.packet == "lower_majorization"
            selected = tuple(
                row
                for row in rows
                if not any(
                    weakly_dominates(other[3], row[3], lower=lower)
                    for other in rows
                    if other is not row
                )
            )
            return selected if lower else with_boundary(selected)
        if self.packet == "reservoir_pareto":
            return with_boundary(
                tuple(
                    row
                    for row in rows
                    if not any(
                        all(a >= b for a, b in zip(other[4], row[4]))
                        and any(a > b for a, b in zip(other[4], row[4]))
                        for other in rows
                        if other is not row
                    )
                )
            )
        if self.packet.startswith("retain_"):
            numerator = int(self.packet.split("_")[1].removesuffix("pct"))
            maximum = max(row[2] for row in rows)
            return with_boundary(
                tuple(
                    row
                    for row in rows
                    if 100 * row[2] >= numerator * maximum
                )
            )
        raise AssertionError(self.packet)

    @lru_cache(maxsize=None)
    def contains(self, state: int) -> bool:
        if not self.base.contains(state):
            return False
        if self.base.omega(state) == 0:
            return True
        for opponent in KERNEL.GEOMETRY.bits(self.base.game.legal_mask(state)):
            witness = None
            for reply, target, _omega, _vector, _coordinates in self.packet_rows(
                state, opponent
            ):
                if self.contains(target):
                    witness = reply
                    break
            if witness is None:
                return False
            self.responses[(state, opponent)] = witness
        return True

    def response_digest(self) -> str:
        rows = (
            f"{state}:{opponent}:{reply}"
            for (state, opponent), reply in sorted(self.responses.items())
        )
        return hashlib.sha256("\n".join(rows).encode()).hexdigest()


class RetentionStrength:
    """Largest alpha for the boundary-or-alpha-retention survivor family."""

    def __init__(self, base):
        self.base = base
        self.rows = PacketKernel(base, "all_strict")

    @lru_cache(maxsize=None)
    def value(self, state: int) -> Fraction:
        if not self.base.contains(state):
            return Fraction(0)
        if self.base.omega(state) == 0:
            return Fraction(1)
        opponent_values = []
        for opponent in KERNEL.GEOMETRY.bits(self.base.game.legal_mask(state)):
            rows = self.rows.reply_rows(state, opponent)
            maximum = max(row[2] for row in rows)
            reply_values = []
            for _reply, target, target_omega, _vector, _coordinates in rows:
                if not self.base.contains(target):
                    continue
                if target_omega == 0:
                    reply_values.append(Fraction(1))
                else:
                    reply_values.append(
                        min(
                            Fraction(target_omega, maximum),
                            self.value(target),
                        )
                    )
            assert reply_values
            opponent_values.append(max(reply_values))
        return min(opponent_values)


def labels_for_order(q: int) -> list[tuple[int, ...]]:
    if q == 11:
        return list(itertools.combinations(range(1, q), 4))
    return KERNEL.escape_parameters(KERNEL.ROWS, q)


def certified_states(base, roots: list[int]) -> set[int]:
    result: set[int] = set()
    stack = list(roots)
    while stack:
        state = stack.pop()
        if state in result or base.omega(state) == 0:
            continue
        result.add(state)
        for opponent in KERNEL.GEOMETRY.bits(base.game.legal_mask(state)):
            reply = base.responses[(state, opponent)]
            stack.append(state | (1 << opponent) | (1 << reply))
    return result


def fibre_audit(base, roots: list[int]) -> dict:
    states = certified_states(base, roots)
    coverage = Counter()
    packet_sizes: dict[str, Counter] = {
        packet: Counter() for packet in PacketKernel.PACKETS
    }
    examples = {}
    retention_ratios = []
    global_profile_labels: dict[tuple[int, tuple[int, ...]], set[bool]] = {}
    global_scalar_labels: dict[tuple[int, int], set[bool]] = {}
    good_profile_sets = []
    edges = 0
    for state in sorted(states):
        old_omega = base.omega(state)
        all_packet = PacketKernel(base, "all_strict")
        for opponent in KERNEL.GEOMETRY.bits(base.game.legal_mask(state)):
            rows = all_packet.reply_rows(state, opponent)
            positive_good = [
                row
                for row in rows
                if row[2] > 0 and base.contains(row[1])
            ]
            if not positive_good:
                continue
            edges += 1
            good_profile_sets.append(
                {(state.bit_count() + 2, row[3]) for row in positive_good}
            )
            for row in rows:
                if row[2] == 0:
                    continue
                label = base.contains(row[1])
                global_profile_labels.setdefault(
                    (state.bit_count() + 2, row[3]), set()
                ).add(label)
                global_scalar_labels.setdefault(
                    (state.bit_count() + 2, row[2]), set()
                ).add(label)
            maximum_omega = max(row[2] for row in rows)
            best_good_omega = max(row[2] for row in positive_good)
            retention_ratios.append((best_good_omega, maximum_omega))
            for packet in PacketKernel.PACKETS:
                restricted = PacketKernel(base, packet)
                chosen = restricted.packet_rows(state, opponent)
                packet_sizes[packet][len(chosen)] += 1
                if any(row[2] > 0 and base.contains(row[1]) for row in chosen):
                    coverage[packet] += 1
                elif packet not in examples:
                    examples[packet] = {
                        "selected_size": state.bit_count(),
                        "old_omega": old_omega,
                        "opponent_cell": list(base.game.cell_tuple(opponent)),
                        "packet_size": len(chosen),
                        "legal_replies": len(rows),
                        "best_positive_kernel_omega": best_good_omega,
                        "maximum_strict_target_omega": maximum_omega,
                        "packet_targets": [
                            {
                                "omega": row[2],
                                "overload_vector_head": list(row[3][:8]),
                                "in_kernel": base.contains(row[1]),
                            }
                            for row in chosen[:4]
                        ],
                    }
    sharp_ratio = min(Fraction(a, b) for a, b in retention_ratios)
    pure_kernel_profiles = {
        profile
        for profile, labels in global_profile_labels.items()
        if labels == {True}
    }
    return {
        "positive_survival_fibres": edges,
        "sharp_retention_ratio": {
            "numerator": sharp_ratio.numerator,
            "denominator": sharp_ratio.denominator,
        },
        "packet_coverage": {
            packet: {
                "covered": coverage[packet],
                "of": edges,
                "packet_size_histogram": {
                    str(size): count
                    for size, count in sorted(packet_sizes[packet].items())
                },
            }
            for packet in PacketKernel.PACKETS
        },
        "first_failures": examples,
        "unmarked_profile_purity": {
            "scalar_size_omega_signatures": len(global_scalar_labels),
            "scalar_mixed_signatures": sum(
                labels == {False, True}
                for labels in global_scalar_labels.values()
            ),
            "full_load_profiles": len(global_profile_labels),
            "full_load_mixed_profiles": sum(
                labels == {False, True}
                for labels in global_profile_labels.values()
            ),
            "fibres_with_globally_pure_kernel_profile": sum(
                bool(profiles & pure_kernel_profiles)
                for profiles in good_profile_sets
            ),
            "of_positive_survival_fibres": edges,
        },
    }


def run_order(q: int) -> dict:
    base = KERNEL.StrictKernel(q)
    labels = labels_for_order(q)
    roots = [
        (label, base.game.base_mask(label))
        for label in labels
        if base.contains(base.game.base_mask(label))
    ]
    packet_results = {}
    for packet in PacketKernel.PACKETS:
        restricted = PacketKernel(base, packet)
        records = [
            {
                "t4": list(label),
                "member": restricted.contains(mask),
            }
            for label, mask in roots
        ]
        packet_results[packet] = {
            "members": sum(record["member"] for record in records),
            "of_kernel_roots": len(records),
            "certified_response_edges": len(restricted.responses),
            "response_map_sha256": restricted.response_digest(),
            "records": records,
        }
    strength = RetentionStrength(base)
    strength_records = [
        {
            "t4": list(label),
            "numerator": strength.value(mask).numerator,
            "denominator": strength.value(mask).denominator,
        }
        for label, mask in roots
    ]
    threshold_consistency = {}
    for percent in (10, 25, 40, 49, 50, 75, 90):
        packet = packet_results[f"retain_{percent}pct"]["records"]
        expected = [
            strength.value(mask) >= Fraction(percent, 100)
            for _label, mask in roots
        ]
        actual = [record["member"] for record in packet]
        threshold_consistency[str(percent)] = actual == expected
        assert actual == expected
    minimum_strength = min(strength.value(mask) for _label, mask in roots)
    result = {
        "q": q,
        "root_domain": (
            "all raw on-conic size-four roots"
            if q == 11
            else "frozen size-four on-conic escape roots"
        ),
        "kernel_roots": len(roots),
        "packet_families": packet_results,
        "retention_strength": {
            "minimum_numerator": minimum_strength.numerator,
            "minimum_denominator": minimum_strength.denominator,
            "records": strength_records,
            "threshold_consistency": threshold_consistency,
        },
    }
    if q == 17:
        result["positive_fibre_audit"] = fibre_audit(
            base, [mask for _label, mask in roots]
        )
    return result


def run_q19_probe() -> dict:
    q = 19
    label = (15, 16, 17, 18)
    base = KERNEL.StrictKernel(q)
    root = base.game.base_mask(label)
    assert base.contains(root)
    explicit = {}
    for percent in (25, 40, 50, 75, 90):
        member = PacketKernel(base, f"retain_{percent}pct").contains(root)
        explicit[str(percent)] = member
    return {
        "q": q,
        "root": list(label),
        "domain": "single previously certified q=19 strict-kernel root",
        "explicit_retention_membership": explicit,
        "kernel_states_visited": base.states_visited(),
        "kernel_response_edges": len(base.responses),
    }


def run() -> dict:
    return {
        "schema": "c80-scale-survivor-falsifiers-v1",
        "claim_scope": (
            "Exact restricted-kernel membership on the listed q=11/13/17 "
            "root domains, plus a q=17 audit of opponent fibres for which "
            "a positive-overload lower-K_omega reply exists. The finite "
            "negative does not exclude marked algebraic survivor families."
        ),
        "upstream": {
            "strict_kernel_script": {
                "path": "rust/scripts/c80_strict_overload_kernel.py",
                "sha256": sha256(
                    ROOT / "rust/scripts/c80_strict_overload_kernel.py"
                ),
            },
            "strict_kernel_certificate": {
                "path": "notes/2026-07-24-c80-strict-overload-kernel.json",
                "sha256": sha256(UPSTREAM_CERT),
            },
            "frozen_rows": {
                "path": "notes/data/c20-q13-q17-states.jsonl.gz",
                "sha256": sha256(KERNEL.ROWS),
            },
        },
        "orders": [run_order(q) for q in (11, 13, 17)],
        "q19_out_of_sample": run_q19_probe(),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(run(), indent=2, sort_keys=True) + "\n"
    if args.check:
        assert OUT.read_text() == rendered, "scale survivor output mismatch"
        print("C80 scale survivor falsifiers: PASS")
    else:
        OUT.write_text(rendered)
        print(f"wrote {OUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
