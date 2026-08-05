#!/usr/bin/env python3
"""Search GF(4) phase decorations of the E7 bitangent generator."""

from __future__ import annotations

import argparse
import itertools
import json
import random
import re
import subprocess
import tempfile
from pathlib import Path


Z3_DEFAULT = "/nix/store/7igjywfjlfa7v2sknkd9dbvpv2s5qf6g-z3-4.15.4/bin/z3"


def binary_generator():
    points = [(a, b) for a in range(8) for b in range(8) if (a & b).bit_count() & 1]
    rows = [[1] * 28]
    for bit in range(3):
        rows.append([(a >> bit) & 1 for a, _ in points])
    for bit in range(3):
        rows.append([(b >> bit) & 1 for _, b in points])
    return rows


LOG = {1: 0, 2: 1, 3: 2}
EXP = (1, 2, 3)


def multiply(left, right):
    if not left or not right:
        return 0
    return EXP[(LOG[left] + LOG[right]) % 3]


def inverse(value):
    return EXP[(-LOG[value]) % 3]


def rank_columns(matrix, columns):
    work = [[row[column] for column in columns] for row in matrix]
    rank = 0
    for column in range(len(columns)):
        pivot = next(
            (row for row in range(rank, len(matrix)) if work[row][column]), None
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        scale = inverse(work[rank][column])
        work[rank] = [multiply(scale, value) for value in work[rank]]
        for row in range(len(matrix)):
            if row == rank or not work[row][column]:
                continue
            scale = work[row][column]
            work[row] = [
                left ^ multiply(scale, right)
                for left, right in zip(work[row], work[rank], strict=True)
            ]
        rank += 1
    return rank


def dependent_supports(matrix, weight):
    return tuple(
        columns
        for columns in itertools.combinations(range(28), weight)
        if rank_columns(matrix, columns) < weight
    )


def smt_problem(seed, pins, forbidden=(), exact_distance_five=False):
    support = binary_generator()
    variables = {
        (row, column): f"x_{row}_{column}"
        for row in range(1, 7)
        for column in range(28)
        if support[row][column]
    }
    lines = [
        "(set-logic QF_UF)",
        f"(set-option :random-seed {seed})",
        f"(set-option :smt.random_seed {seed})",
    ]
    for variable in variables.values():
        for residue in range(3):
            lines.append(f"(declare-const {variable}_{residue} Bool)")
        lines.append(
            f"(assert (or {variable}_0 {variable}_1 {variable}_2))"
        )
        lines.append(
            f"(assert (not (and {variable}_0 {variable}_1)))"
        )
        lines.append(
            f"(assert (not (and {variable}_0 {variable}_2)))"
        )
        lines.append(
            f"(assert (not (and {variable}_1 {variable}_2)))"
        )

    def phase_atom(row, column, residue):
        if row == 0:
            return "true" if residue == 0 else "false"
        return f"{variables[(row, column)]}_{residue}"

    for left in range(7):
        for right in range(left + 1, 7):
            overlap = [
                column
                for column in range(28)
                if support[left][column] and support[right][column]
            ]
            for residue in range(3):
                indicators = []
                for column in overlap:
                    alternatives = [
                        f"(and {phase_atom(left, column, left_phase)} {phase_atom(right, column, right_phase)})"
                        for left_phase in range(3)
                        for right_phase in range(3)
                        if (left_phase - right_phase) % 3 == residue
                    ]
                    indicators.append(f"(or {' '.join(alternatives)})")
                lines.append(
                    f"(assert (= (xor {' '.join(indicators)}) false))"
                )
    # Exclude row-separable scalar extensions: every nonconstant row uses all phases.
    for row in range(1, 7):
        for residue in range(3):
            terms = " ".join(
                f"{variables[(row, column)]}_{residue}"
                for column in range(28)
                if (row, column) in variables
            )
            lines.append(f"(assert (or {terms}))")
    for variable, value in pins:
        lines.append(f"(assert {variable}_{value})")
    for columns, phases in forbidden:
        changes = []
        for row in range(1, 7):
            for column in columns:
                if (row, column) in variables:
                    changes.append(
                        f"(not {variables[(row, column)]}_{LOG[phases[row][column]]})"
                    )
        lines.append(f"(assert (or {' '.join(changes)}))")
    if exact_distance_five:
        bits = {1: (1, 0), 2: (0, 1), 3: (1, 1)}

        def xor_expression(atoms):
            if not atoms:
                return "false"
            if len(atoms) == 1:
                return atoms[0]
            return f"(xor {' '.join(atoms)})"

        coefficient_patterns = []
        for second in EXP:
            for third in EXP:
                fourth = 1 ^ second ^ third
                if fourth:
                    coefficient_patterns.append((1, second, third, fourth))
        assert len(coefficient_patterns) == 7
        for columns in itertools.combinations(range(28), 4):
            if any(
                sum(support[row][column] for column in columns) == 1
                for row in range(1, 7)
            ):
                continue
            for coefficients in coefficient_patterns:
                nonzero_rows = []
                for row in range(1, 7):
                    parity_bits = []
                    for bit in range(2):
                        atoms = []
                        for column, coefficient in zip(
                            columns, coefficients, strict=True
                        ):
                            if not support[row][column]:
                                continue
                            variable = variables[(row, column)]
                            residues = [
                                residue
                                for residue in range(3)
                                if bits[
                                    EXP[(LOG[coefficient] + residue) % 3]
                                ][bit]
                            ]
                            atoms.append(
                                f"(or {' '.join(f'{variable}_{residue}' for residue in residues)})"
                            )
                        parity_bits.append(xor_expression(atoms))
                    nonzero_rows.append(f"(or {' '.join(parity_bits)})")
                lines.append(f"(assert (or {' '.join(nonzero_rows)}))")
    names = " ".join(
        f"{variable}_{residue}"
        for variable in variables.values()
        for residue in range(3)
    )
    lines.extend(("(check-sat)", f"(get-value ({names}))"))
    return "\n".join(lines) + "\n", variables


def matrix_from_model(output, variables):
    atoms = {
        (name, int(residue)): value == "true"
        for name, residue, value in re.findall(
            r"\((x_\d+_\d+)_([012]) (true|false)\)", output
        )
    }
    if len(atoms) != 3 * len(variables):
        return None
    support = binary_generator()
    matrix = [[0] * 28 for _ in range(7)]
    for row in range(7):
        for column in range(28):
            if support[row][column]:
                exponent = (
                    0
                    if row == 0
                    else next(
                        residue
                        for residue in range(3)
                        if atoms[(variables[(row, column)], residue)]
                    )
                )
                matrix[row][column] = EXP[exponent]
    return matrix


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--solver", default=Z3_DEFAULT)
    parser.add_argument("--trials", type=int, default=100)
    parser.add_argument("--seed", type=int, default=20260805)
    parser.add_argument("--pin-count", type=int, default=8)
    parser.add_argument("--cutting-plane", type=int, default=0)
    parser.add_argument("--exact", action="store_true")
    parser.add_argument("--output", type=Path)
    parser.add_argument("--expect-no-solution", action="store_true")
    args = parser.parse_args()
    rng = random.Random(args.seed)
    seen = set()
    trial_counts = []
    if args.exact:
        with tempfile.TemporaryDirectory(prefix="c682-e7-phase-exact-") as directory:
            problem, variables = smt_problem(
                args.seed, (), exact_distance_five=True
            )
            path = Path(directory) / "problem.smt2"
            path.write_text(problem)
            print(f"exact_smt_bytes={path.stat().st_size}", flush=True)
            result = subprocess.run(
                [args.solver, str(path)], capture_output=True, text=True, check=True
            )
            if result.stdout.startswith("unsat"):
                raise SystemExit("UNSAT: no support-preserving distance-five phase lift")
            matrix = matrix_from_model(result.stdout, variables)
            assert matrix is not None
            bad4 = dependent_supports(matrix, 4)
            trial_counts.append(len(bad4))
            assert not bad4
            bad5 = dependent_supports(matrix, 5)
            print(f"SUCCESS dependent5={len(bad5)}", flush=True)
            for row in matrix:
                print(" ".join("01ab"[value] for value in row))
            return
    with tempfile.TemporaryDirectory(prefix="c682-e7-phase-") as directory:
        for trial in range(args.trials):
            base, variables = smt_problem(args.seed + trial, ())
            names = tuple(variables.values())
            pins = tuple((name, rng.randrange(3)) for name in rng.sample(names, args.pin_count))
            problem, variables = smt_problem(args.seed + trial, pins)
            path = Path(directory) / "problem.smt2"
            path.write_text(problem)
            result = subprocess.run(
                [args.solver, str(path)], capture_output=True, text=True, check=True
            )
            if not result.stdout.startswith("sat"):
                continue
            matrix = matrix_from_model(result.stdout, variables)
            if matrix is None:
                continue
            fingerprint = tuple(tuple(row) for row in matrix)
            if fingerprint in seen:
                continue
            seen.add(fingerprint)
            bad4 = dependent_supports(matrix, 4)
            trial_counts.append(len(bad4))
            print(
                f"trial={trial} models={len(seen)} dependent4={len(bad4)}",
                flush=True,
            )
            if not bad4:
                bad5 = dependent_supports(matrix, 5)
                print(f"SUCCESS dependent5={len(bad5)}")
                for row in matrix:
                    print(" ".join("01ab"[value] for value in row))
                if args.output:
                    args.output.write_text(
                        json.dumps(
                            {
                                "status": "success",
                                "seed": args.seed,
                                "pin_count": args.pin_count,
                                "dependent_weight4_counts": trial_counts,
                                "dependent_weight5_supports": len(bad5),
                            },
                            indent=2,
                            sort_keys=True,
                        )
                        + "\n"
                    )
                return
    if args.cutting_plane:
        forbidden = []
        best = None
        cutting_counts = []
        with tempfile.TemporaryDirectory(prefix="c682-e7-phase-cp-") as directory:
            for iteration in range(args.cutting_plane):
                problem, variables = smt_problem(args.seed + iteration, (), forbidden)
                path = Path(directory) / "problem.smt2"
                path.write_text(problem)
                result = subprocess.run(
                    [args.solver, str(path)], capture_output=True, text=True, check=True
                )
                if result.stdout.startswith("unsat"):
                    raise SystemExit(
                        f"UNSAT after {iteration} models and {len(forbidden)} local cuts"
                    )
                matrix = matrix_from_model(result.stdout, variables)
                assert matrix is not None
                bad4 = dependent_supports(matrix, 4)
                cutting_counts.append(len(bad4))
                if best is None or len(bad4) < best:
                    best = len(bad4)
                print(
                    f"cut={iteration} dependent4={len(bad4)} best={best} clauses={len(forbidden)}",
                    flush=True,
                )
                if not bad4:
                    bad5 = dependent_supports(matrix, 5)
                    print(f"SUCCESS dependent5={len(bad5)}", flush=True)
                    for row in matrix:
                        print(" ".join("01ab"[value] for value in row))
                    return
                forbidden.extend((columns, matrix) for columns in bad4)
        if args.output:
            args.output.write_text(
                json.dumps(
                    {
                        "status": "bounded_cutting_plane_negative_only",
                        "iterations": args.cutting_plane,
                        "dependent_weight4_counts": cutting_counts,
                        "best_remaining_weight4_supports": best,
                        "local_blocking_clauses": len(forbidden),
                        "claim_boundary": "not an impossibility theorem",
                    },
                    indent=2,
                    sort_keys=True,
                )
                + "\n"
            )
        message = f"no distance-five lift after {args.cutting_plane} cuts; best={best}"
        if args.expect_no_solution:
            print(message)
            return
        raise SystemExit(message)
    if args.output:
        args.output.write_text(
            json.dumps(
                {
                    "status": "bounded_negative_only",
                    "seed": args.seed,
                    "pin_count": args.pin_count,
                    "distinct_models": len(seen),
                    "dependent_weight4_counts": trial_counts,
                    "best_remaining_weight4_supports": min(trial_counts),
                    "claim_boundary": "not an impossibility theorem",
                },
                indent=2,
                sort_keys=True,
            )
            + "\n"
        )
    message = f"no distance-five lift in {len(seen)} distinct models"
    if args.expect_no_solution:
        print(message)
        return
    raise SystemExit(message)


if __name__ == "__main__":
    main()
