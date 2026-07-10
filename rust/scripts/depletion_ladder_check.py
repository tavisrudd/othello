#!/usr/bin/env python3
"""Lightweight validation for the C46 conic-depletion ladder.

The checker consumes the already-distilled C38 forced-node table plus an optional
bounded prefix of a large FORCED rows file.  It does not query a game oracle or
walk a raw memo dump.
"""

from __future__ import annotations

import argparse
import csv
import re
from collections import defaultdict
from dataclasses import dataclass
from itertools import chain
from pathlib import Path
from typing import Iterable, Iterator


@dataclass(frozen=True)
class State:
    q: int
    ply: int
    sel_on: int
    live_on: int
    cells: tuple[tuple[int, int], ...]
    source: str


def pattern_loss(a: int, b: int) -> int:
    """Maximum charged conic loss after a on-conic and b off-conic plies."""
    return a + 5 * b + a * b + b * b


def pattern_bound(q: int, a: int, b: int) -> int:
    return max(0, q - 5 - pattern_loss(a, b))


def universal_bound(q: int, t: int) -> int:
    return max(0, q - 5 - t * t - 5 * t)


def parse_cells(text: str) -> tuple[tuple[int, int], ...]:
    cells = []
    for item in re.split(r"[; ]+", text.strip()):
        if not item:
            continue
        r, c = item.split(",", 1)
        cells.append((int(r), int(c)))
    return tuple(cells)


def geometry(q: int, cell: tuple[int, int]) -> str:
    """Prime-field version of geometry_label_for_root's on/ext/int split."""
    r, c = cell
    if r != 0 and c != 0 and r * c % q == 1:
        return "on"
    tangents = int(c == 0) + int(r == 0)
    for pr in range(1, q):
        pc = pow(pr, -1, q)
        if (pr * c + pc * r - 2) % q == 0:
            tangents += 1
    if tangents == 2:
        return "ext"
    if tangents == 0:
        return "int"
    return "anom"


def tsv_states(path: Path) -> Iterator[State]:
    with path.open(newline="") as f:
        for row in csv.DictReader(f, delimiter="\t"):
            q = int(row["q"])
            if q == 9:  # GF(9) cell labels are not prime-field residues.
                cells: tuple[tuple[int, int], ...] = ()
            else:
                cells = parse_cells(row["cells"])
            yield State(
                q=q,
                ply=int(row["ply"]),
                sel_on=int(row["sel_on"]),
                live_on=int(row["live_on_before"]),
                cells=cells,
                source=path.name,
            )

            child_sel_on = int(row["sel_on"]) + int(row["move_geom"] == "on")
            child_cells = () if q == 9 else parse_cells(row["child_cells"])
            yield State(
                q=q,
                ply=int(row["ply"]) + 1,
                sel_on=child_sel_on,
                live_on=int(row["live_on_after"]),
                cells=child_cells,
                source=path.name + ":child",
            )


FIELD_RE = re.compile(r"\b(q|ply|live_on_before|live_on_after|sel_on|xgeom)=([^ ]+)")
CELLS_RE = re.compile(r" cells=(.*?) child_cells=(.*?) conic_v=")


def forced_prefix_states(path: Path, max_rows: int) -> Iterator[State]:
    seen = 0
    with path.open() as f:
        for line in f:
            if not line.startswith("FORCED "):
                continue
            fields = dict(FIELD_RE.findall(line))
            cells_match = CELLS_RE.search(line)
            if cells_match is None:
                raise ValueError(f"could not parse cells from {path}: {line[:120]!r}")
            q = int(fields["q"])
            ply = int(fields["ply"])
            sel_on = int(fields["sel_on"])
            cells = parse_cells(cells_match.group(1))
            yield State(q, ply, sel_on, int(fields["live_on_before"]), cells, path.name)

            child_sel_on = sel_on + int(fields["xgeom"] == "on")
            child_cells = parse_cells(cells_match.group(2))
            yield State(
                q,
                ply + 1,
                child_sel_on,
                int(fields["live_on_after"]),
                child_cells,
                path.name + ":child",
            )
            seen += 1
            if seen >= max_rows:
                return


def validate_two_ply(path: Path) -> tuple[int, int]:
    groups = failures = 0
    with path.open(newline="") as f:
        for row in csv.DictReader(f, delimiter="\t"):
            groups += 1
            if row["meets_bound"] != "True":
                failures += 1
            on = int(row["xgeom"] == "on") + int(row["ygeom"] == "on")
            a, b = on, 2 - on
            expected = pattern_bound(int(row["q"]), a, b)
            if expected != int(row["expected_live_lower_bound"]):
                raise AssertionError((row, expected))
    return groups, failures


def summarize(states: Iterable[State], *, detail: bool) -> None:
    summary: dict[tuple[int, int, int, int], dict[str, int]] = defaultdict(
        lambda: {"rows": 0, "live_min": 10**9, "pattern_slack": 10**9, "universal_slack": 10**9}
    )
    failures = geometry_failures = type_i_failures = 0
    literature_hits: dict[tuple[int, str, int, int], int] = defaultdict(int)
    total = 0

    for state in states:
        total += 1
        t = state.ply - 4
        a = state.sel_on - 4
        b = state.ply - state.sel_on
        if min(t, a, b) < 0 or a + b != t:
            raise AssertionError(state)
        pb = pattern_bound(state.q, a, b)
        ub = universal_bound(state.q, t)
        if state.live_on < pb:
            failures += 1
        key = (state.q, t, a, b)
        row = summary[key]
        row["rows"] += 1
        row["live_min"] = min(row["live_min"], state.live_on)
        row["pattern_slack"] = min(row["pattern_slack"], state.live_on - pb)
        row["universal_slack"] = min(row["universal_slack"], state.live_on - ub)

        if state.cells and state.q != 9:
            geoms = [geometry(state.q, cell) for cell in state.cells]
            if geoms.count("on") != state.sel_on or "anom" in geoms:
                geometry_failures += 1
            internal = geoms.count("int")
            external = geoms.count("ext")
            conic_total = state.sel_on + 2  # include the two burned projective conic points
            if b >= 2 and conic_total == (state.q + 1) // 2:
                if external == 0:
                    literature_hits[(state.q, "I", internal, external)] += 1
                    if b > 4 or (b == 4 and state.q % 24 != 23):
                        type_i_failures += 1
                elif internal > 0:
                    literature_hits[(state.q, "M", internal, external)] += 1
                else:
                    # All-external, but one conic point short of the paper's type-E
                    # "large" threshold.  Record the boundary without calling it type E.
                    literature_hits[(state.q, "below-E", internal, external)] += 1
            if b >= 2 and conic_total == (state.q + 3) // 2 and internal == 0:
                literature_hits[(state.q, "E", internal, external)] += 1

    print(
        f"LADDER states={total} groups={len(summary)} failures={failures} "
        f"geometry_failures={geometry_failures} typeI_failures={type_i_failures}"
    )
    positive_groups = sum(pattern_bound(q, a, b) > 0 for q, _t, a, b in summary)
    positive_sharp = sum(
        pattern_bound(q, a, b) > 0 and row["pattern_slack"] == 0
        for (q, _t, a, b), row in summary.items()
    )
    all_sharp = sum(row["pattern_slack"] == 0 for row in summary.values())
    print(
        f"SHARPNESS positive_groups={positive_groups} positive_sharp={positive_sharp} "
        f"all_groups_sharp={all_sharp}/{len(summary)}"
    )
    if detail:
        print("q t a b rows live_min pattern_bound min_pattern_slack universal_bound min_universal_slack")
        for (q, t, a, b), row in sorted(summary.items()):
            print(
                q,
                t,
                a,
                b,
                row["rows"],
                row["live_min"],
                pattern_bound(q, a, b),
                row["pattern_slack"],
                universal_bound(q, t),
                row["universal_slack"],
            )
    print("LITERATURE q kind internal external rows")
    for (q, kind, internal, external), rows in sorted(literature_hits.items()):
        print(q, kind, internal, external, rows)

    if failures or geometry_failures or type_i_failures:
        raise SystemExit(1)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--forced-tsv", type=Path, required=True)
    parser.add_argument("--two-ply-tsv", type=Path, required=True)
    parser.add_argument("--forced-prefix", type=Path)
    parser.add_argument("--max-prefix-rows", type=int, default=100_000)
    parser.add_argument("--compact", action="store_true")
    args = parser.parse_args()

    groups, failures = validate_two_ply(args.two_ply_tsv)
    print(f"TWO_PLY groups={groups} failures={failures}")
    states: Iterable[State] = tsv_states(args.forced_tsv)
    if args.forced_prefix:
        states = chain(states, forced_prefix_states(args.forced_prefix, args.max_prefix_rows))
    summarize(states, detail=not args.compact)


if __name__ == "__main__":
    main()
