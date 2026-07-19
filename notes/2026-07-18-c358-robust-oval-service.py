#!/usr/bin/env python3
"""Bounded adversarial-deletion census for C358.

This first-stage generator imports C354's independently checked finite-field,
frame-orbit, and recovery-hypergraph definitions.  It computes the worst
equal three-colour fractional service rate for every frame orbit after exactly
f helper deletions, for f <= 3.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from fractions import Fraction
from itertools import combinations
from pathlib import Path


STEM = "2026-07-18-c358-robust-oval-service"
SCHEMA = "c358-robust-oval-service-v1"
C354 = Path(__file__).with_name("2026-07-18-c354-conic-mds-service-spectrum.py")


def load_c354():
    spec = importlib.util.spec_from_file_location("c354_service_spectrum", C354)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def fraction_text(value: Fraction) -> str:
    return str(value.numerator) if value.denominator == 1 else f"{value.numerator}/{value.denominator}"


def parse_fraction(value: str) -> Fraction:
    return Fraction(value)


def solve_rate(edges, server_count: int, failed: tuple[int, ...]) -> Fraction:
    try:
        import numpy as np
        from scipy.optimize import linprog
    except ImportError as exc:
        raise SystemExit("run with scipy available") from exc

    failed_mask = sum(1 << server for server in failed)
    available = tuple((color, mask) for color, mask in edges if not mask & failed_mask)
    edge_count = len(available)
    # Variables are edge allocations followed by lambda.
    objective = np.zeros(edge_count + 1)
    objective[-1] = -1
    rows = []
    bounds = []
    for server in range(server_count):
        row = np.zeros(edge_count + 1)
        for column, (_, mask) in enumerate(available):
            row[column] = bool(mask & (1 << server))
        rows.append(row)
        bounds.append(0 if server in failed else 1)
    for color in range(3):
        row = np.zeros(edge_count + 1)
        for column, (edge_color, _) in enumerate(available):
            row[column] = -int(edge_color == color)
        row[-1] = 1
        rows.append(row)
        bounds.append(0)
    result = linprog(
        objective,
        A_ub=np.asarray(rows),
        b_ub=np.asarray(bounds),
        bounds=[(0, None)] * (edge_count + 1),
        method="highs",
    )
    assert result.success, result.message
    return Fraction(float(result.x[-1])).limit_denominator(1_000_000)


def solve_certificate(edges, server_count: int, failed: tuple[int, ...]) -> dict[str, object]:
    """Discover and rationalize matching primal/dual certificates."""
    try:
        import numpy as np
        from scipy.optimize import linprog
    except ImportError as exc:
        raise SystemExit("run with scipy available") from exc

    failed_mask = sum(1 << server for server in failed)
    available = tuple((color, mask) for color, mask in edges if not mask & failed_mask)
    edge_count = len(available)
    incidence = np.zeros((server_count, edge_count))
    for column, (_, mask) in enumerate(available):
        for server in range(server_count):
            incidence[server, column] = bool(mask & (1 << server))

    objective = np.zeros(edge_count + 1)
    objective[-1] = -1
    rows = []
    bounds = []
    for server in range(server_count):
        rows.append(np.r_[incidence[server], 0])
        bounds.append(0 if server in failed else 1)
    for color in range(3):
        rows.append(np.r_[[-int(edge_color == color) for edge_color, _ in available], 1])
        bounds.append(0)
    primal = linprog(
        objective,
        A_ub=np.asarray(rows),
        b_ub=np.asarray(bounds),
        bounds=[(0, None)] * (edge_count + 1),
        method="highs",
    )
    assert primal.success, primal.message
    allocation = tuple(Fraction(float(value)).limit_denominator(1_000_000) for value in primal.x[:-1])
    rate = Fraction(float(primal.x[-1])).limit_denominator(1_000_000)

    # Variables are server weights y, followed by colour weights u.
    dual_rows = []
    dual_bounds = []
    for color, mask in available:
        dual_rows.append(
            [-int(mask & (1 << server) != 0) for server in range(server_count)]
            + [int(index == color) for index in range(3)]
        )
        dual_bounds.append(0)
    dual_rows.append([0] * server_count + [-1, -1, -1])
    dual_bounds.append(-1)
    dual = linprog(
        [0 if server in failed else 1 for server in range(server_count)] + [0, 0, 0],
        A_ub=np.asarray(dual_rows),
        b_ub=np.asarray(dual_bounds),
        bounds=[(0, None)] * (server_count + 3),
        method="highs",
    )
    assert dual.success, dual.message
    server_weights = tuple(Fraction(float(value)).limit_denominator(1_000_000) for value in dual.x[:server_count])
    color_weights = tuple(Fraction(float(value)).limit_denominator(1_000_000) for value in dual.x[server_count:])
    dual_rate = sum(server_weights[server] for server in range(server_count) if server not in failed)
    assert rate == dual_rate

    # Exact checks before serialization.
    for server in range(server_count):
        load = sum(allocation[column] for column, (_, mask) in enumerate(available) if mask & (1 << server))
        assert load <= (0 if server in failed else 1)
    for color in range(3):
        assert sum(allocation[column] for column, (edge_color, _) in enumerate(available) if edge_color == color) >= rate
    assert sum(color_weights) >= 1
    for color, mask in available:
        assert sum(server_weights[server] for server in range(server_count) if mask & (1 << server)) >= color_weights[color]

    return {
        "rate": fraction_text(rate),
        "primal": [[column, fraction_text(value)] for column, value in enumerate(allocation) if value],
        "dual_servers": [fraction_text(value) for value in server_weights],
        "dual_colors": [fraction_text(value) for value in color_weights],
    }


def census(fields: tuple[int, ...], max_failures: int) -> dict[str, object]:
    c354 = load_c354()
    output: dict[str, object] = {
        "schema": SCHEMA,
        "c354_source_sha256": hashlib.sha256(C354.read_bytes()).hexdigest(),
        "fields": {},
    }
    for q in fields:
        field = c354.FiniteField(q)
        rows = []
        for index, orbit in enumerate(c354.frame_orbits(field)):
            frame = orbit["representative"]
            edges = c354.recovery_edges(field, frame)
            assert edges == c354.direct_recovery_edges(field, frame)
            rates = []
            witnesses = []
            for failure_count in range(max_failures + 1):
                by_failure = [
                    (solve_rate(edges, q + 1, failed), failed)
                    for failed in combinations(range(q + 1), failure_count)
                ]
                worst = min(rate for rate, _ in by_failure)
                rates.append(fraction_text(worst))
                witnesses.append([list(failed) for rate, failed in by_failure if rate == worst])
            rows.append(
                {
                    "index": index,
                    "representative": frame,
                    "type": orbit["type"],
                    "orbit_size": orbit["orbit_size"],
                    "rates": rates,
                    "worst_failure_sets": witnesses,
                }
            )
        output["fields"][str(q)] = {"orbit_count": len(rows), "orbits": rows}
    return output


def merge_pilots(paths: tuple[Path, ...]) -> dict[str, object]:
    merged: dict[str, object] = {"fields": {}}
    for path in paths:
        payload = json.loads(path.read_text())
        merged["fields"].update(payload["fields"])
    return merged


def certify(pilot: dict[str, object], fields: tuple[int, ...], max_failures: int) -> dict[str, object]:
    c354 = load_c354()
    output: dict[str, object] = {
        "schema": SCHEMA,
        "c354_source_sha256": hashlib.sha256(C354.read_bytes()).hexdigest(),
        "fields": {},
    }
    for q in fields:
        field = c354.FiniteField(q)
        orbits = c354.frame_orbits(field)
        pilot_rows = pilot["fields"][str(q)]["orbits"]
        assert len(orbits) == len(pilot_rows)
        failure_rows = []
        for failure_count in range(max_failures + 1):
            rates = [parse_fraction(row["rates"][failure_count]) for row in pilot_rows]
            optimum = max(rates)
            winner_index = rates.index(optimum)
            winner_orbit = orbits[winner_index]
            winner_frame = winner_orbit["representative"]
            winner_edges = c354.recovery_edges(field, winner_frame)
            assert winner_edges == c354.direct_recovery_edges(field, winner_frame)

            winner_primals = []
            for failed in combinations(range(q + 1), failure_count):
                certificate = solve_certificate(winner_edges, q + 1, failed)
                certificate_rate = parse_fraction(certificate["rate"])
                assert certificate_rate >= optimum
                scale = optimum / certificate_rate
                winner_primals.append(
                    {
                        "failed": list(failed),
                        "allocation": [
                            [index, fraction_text(parse_fraction(value) * scale)]
                            for index, value in certificate["primal"]
                        ],
                    }
                )

            orbit_uppers = []
            for index, (orbit, pilot_row) in enumerate(zip(orbits, pilot_rows)):
                frame = orbit["representative"]
                assert [list(point) for point in frame] == pilot_row["representative"]
                edges = c354.recovery_edges(field, frame)
                assert edges == c354.direct_recovery_edges(field, frame)
                failed = tuple(pilot_row["worst_failure_sets"][failure_count][0])
                certificate = solve_certificate(edges, q + 1, failed)
                rate = parse_fraction(certificate["rate"])
                assert rate == rates[index] and rate <= optimum
                orbit_uppers.append(
                    {
                        "failed": list(failed),
                        "dual_servers": certificate["dual_servers"],
                        "dual_colors": certificate["dual_colors"],
                        "objective": certificate["rate"],
                    }
                )
            failure_rows.append(
                {
                    "failure_count": failure_count,
                    "optimum": fraction_text(optimum),
                    "winner_index": winner_index,
                    "winner_representative": winner_frame,
                    "winner_type": winner_orbit["type"],
                    "winner_primals": winner_primals,
                    "orbit_uppers": orbit_uppers,
                }
            )
        output["fields"][str(q)] = {"orbit_count": len(orbits), "failures": failure_rows}
    return output


def check_certificate(data: dict[str, object]) -> None:
    c354 = load_c354()
    assert data["schema"] == SCHEMA
    assert data["c354_source_sha256"] == hashlib.sha256(C354.read_bytes()).hexdigest()
    for q_text, field_row in data["fields"].items():
        q = int(q_text)
        field = c354.FiniteField(q)
        orbits = c354.frame_orbits(field)
        assert field_row["orbit_count"] == len(orbits)
        for failure_row in field_row["failures"]:
            failure_count = failure_row["failure_count"]
            optimum = parse_fraction(failure_row["optimum"])
            winner_index = failure_row["winner_index"]
            winner_frame = orbits[winner_index]["representative"]
            assert [list(point) for point in winner_frame] == failure_row["winner_representative"]
            winner_edges = c354.recovery_edges(field, winner_frame)
            assert winner_edges == c354.direct_recovery_edges(field, winner_frame)
            primals = failure_row["winner_primals"]
            assert len(primals) == sum(1 for _ in combinations(range(q + 1), failure_count))
            for primal_row in primals:
                failed = tuple(primal_row["failed"])
                assert len(failed) == failure_count
                failed_mask = sum(1 << server for server in failed)
                available = tuple((color, mask) for color, mask in winner_edges if not mask & failed_mask)
                allocation = [Fraction(0)] * len(available)
                for index, value in primal_row["allocation"]:
                    allocation[index] = parse_fraction(value)
                for server in range(q + 1):
                    load = sum(allocation[index] for index, (_, mask) in enumerate(available) if mask & (1 << server))
                    assert load <= (0 if server in failed else 1)
                for color in range(3):
                    served = sum(allocation[index] for index, (edge_color, _) in enumerate(available) if edge_color == color)
                    assert served >= optimum

            uppers = failure_row["orbit_uppers"]
            assert len(uppers) == len(orbits)
            for orbit, upper in zip(orbits, uppers):
                frame = orbit["representative"]
                edges = c354.recovery_edges(field, frame)
                assert edges == c354.direct_recovery_edges(field, frame)
                failed = tuple(upper["failed"])
                assert len(failed) == failure_count
                failed_mask = sum(1 << server for server in failed)
                server_weights = tuple(map(parse_fraction, upper["dual_servers"]))
                color_weights = tuple(map(parse_fraction, upper["dual_colors"]))
                assert len(server_weights) == q + 1 and len(color_weights) == 3
                assert sum(color_weights) >= 1
                for color, mask in edges:
                    if mask & failed_mask:
                        continue
                    assert sum(server_weights[server] for server in range(q + 1) if mask & (1 << server)) >= color_weights[color]
                objective = sum(server_weights[server] for server in range(q + 1) if server not in failed)
                assert objective == parse_fraction(upper["objective"])
                assert objective <= optimum


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--fields", nargs="+", type=int, default=[5, 7, 9, 11])
    parser.add_argument("--max-failures", type=int, default=3)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--pilot", nargs="*", type=Path)
    parser.add_argument("--generate", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    fields = tuple(args.fields)
    assert all(q in (5, 7, 9, 11) for q in fields)
    assert 0 <= args.max_failures <= 3
    tracked = Path(__file__).with_suffix(".json")
    if args.check:
        assert fields == (5, 7, 9, 11) and args.max_failures == 3
        data = json.loads(tracked.read_text())
        check_certificate(data)
        payload = canonical_bytes(data)
        assert tracked.read_bytes() == payload
        print(f"CHECKED {tracked.name} {len(payload)} bytes sha256={hashlib.sha256(payload).hexdigest()}")
    elif args.generate:
        pilot = merge_pilots(tuple(args.pilot)) if args.pilot else census(fields, args.max_failures)
        result = certify(pilot, fields, args.max_failures)
        payload = canonical_bytes(result)
        destination = args.output or tracked
        destination.write_bytes(payload)
        print(f"WROTE {destination} {len(payload)} bytes sha256={hashlib.sha256(payload).hexdigest()}")
    else:
        raise SystemExit("choose --generate or --check")


if __name__ == "__main__":
    main()
