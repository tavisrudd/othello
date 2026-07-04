#!/usr/bin/env python3
"""Formula pass for central-strike border scars in the queens game.

Pure Python arithmetic only.  No Rust build or solver invocation.
"""

from __future__ import annotations

import functools
import itertools
import resource
import time
from collections import Counter, defaultdict


Square = tuple[int, int]


def md_table(rows: list[list[object]]) -> str:
    if not rows:
        return ""
    widths = [max(len(str(row[i])) for row in rows) for i in range(len(rows[0]))]
    out = []
    out.append("| " + " | ".join(str(v).ljust(widths[i]) for i, v in enumerate(rows[0])) + " |")
    out.append("| " + " | ".join("-" * widths[i] for i in range(len(widths))) + " |")
    for row in rows[1:]:
        out.append("| " + " | ".join(str(v).ljust(widths[i]) for i, v in enumerate(row)) + " |")
    return "\n".join(out)


def q_of(n: int) -> int:
    return n - 1


def m_of(n: int) -> int:
    return n // 2


def h_of(n: int) -> int:
    return m_of(n) - 1


def central(n: int) -> Square:
    h = h_of(n)
    return h, h


def tau(n: int, s: Square) -> Square:
    q = q_of(n)
    r, c = s
    return q - 1 - r, q - 1 - c


def s_core(n: int) -> set[Square]:
    q = q_of(n)
    return {(r, c) for r in range(q) for c in range(q)}


def live_core(n: int) -> set[Square]:
    q = q_of(n)
    h = h_of(n)
    return {
        (r, c)
        for r in range(q)
        for c in range(q)
        if r != h and c != h and r + c != q - 1 and r - c != 0
    }


def live_border_formula(n: int) -> tuple[set[Square], set[Square]]:
    q = q_of(n)
    h = h_of(n)
    row = {(q, x) for x in range(q) if x != h}
    col = {(y, q) for y in range(q) if y != h}
    return row, col


def labels(s: Square) -> tuple[int, int, int, int]:
    r, c = s
    return r, c, r + c, r - c


def used_labels(moves: list[Square]) -> tuple[set[int], set[int], set[int], set[int]]:
    rows: set[int] = set()
    cols: set[int] = set()
    sums: set[int] = set()
    diffs: set[int] = set()
    for r, c in moves:
        rows.add(r)
        cols.add(c)
        sums.add(r + c)
        diffs.add(r - c)
    return rows, cols, sums, diffs


def live_after(n: int, moves: list[Square]) -> set[Square]:
    rows, cols, sums, diffs = used_labels(moves)
    out = set()
    for r in range(n):
        if r in rows:
            continue
        for c in range(n):
            if c in cols or r + c in sums or r - c in diffs:
                continue
            out.add((r, c))
    return out


def attacks(a: Square, b: Square) -> bool:
    ar, ac = a
    br, bc = b
    return ar == br or ac == bc or ar + ac == br + bc or ar - ac == br - bc


def raw_row_scar(n: int, x: int) -> set[Square]:
    q = q_of(n)
    return {
        (r, c)
        for r in range(q)
        for c in range(q)
        if c == x or r - c == q - x or r + c == q + x
    }


def raw_col_scar(n: int, y: int) -> set[Square]:
    q = q_of(n)
    return {
        (r, c)
        for r in range(q)
        for c in range(q)
        if r == y or r - c == y - q or r + c == y + q
    }


def live_row_scar(n: int, x: int) -> set[Square]:
    return raw_row_scar(n, x) & live_core(n)


def live_col_scar(n: int, y: int) -> set[Square]:
    return raw_col_scar(n, y) & live_core(n)


def row_live_component_counts_formula(n: int, x: int) -> tuple[int, int, int, int]:
    q = q_of(n)
    m = m_of(n)
    h = h_of(n)
    parity = x & 1
    col = q - 3
    diff = x - 2 * int(x >= m) - parity
    anti = q - 1 - x - 2 * int(x <= h - 1) - parity
    return col, diff, anti, col + diff + anti


def row_live_scar_size_formula(n: int, x: int) -> int:
    return 2 * n - 8 - 2 * (x & 1)


def raw_scar_size_formula(n: int) -> int:
    return 2 * n - 3


def tau_image(n: int, xs: set[Square]) -> set[Square]:
    return {tau(n, s) for s in xs}


def symdiff_size(n: int, xs: set[Square]) -> int:
    return len(xs ^ tau_image(n, xs))


def scar_intersection_with_tau_formula(n: int, x: int) -> int:
    """|scar_R(row x) ∩ tau(scar_R(row x))|, which is always 0 or 2."""
    m = m_of(n)
    h = h_of(n)
    if x <= h - 1:
        dead = (2 * x == m - 2) or (3 * x == 2 * m - 3)
    else:
        dead = (2 * x == 3 * m - 2) or (3 * x == 4 * m - 3)
    return 0 if dead else 2


def tau_asym_formula(n: int, x: int) -> int:
    s = row_live_scar_size_formula(n, x)
    inter = scar_intersection_with_tau_formula(n, x)
    return 2 * s - 2 * inter


def border_coords(n: int) -> list[int]:
    q = q_of(n)
    h = h_of(n)
    return [x for x in range(q) if x != h]


def combined_scar(n: int, x: int, y: int) -> set[Square]:
    return live_row_scar(n, x) | live_col_scar(n, y)


def label_tau(kind: str, n: int, value: int) -> int:
    q = q_of(n)
    if kind in {"row", "col"}:
        return q - 1 - value
    if kind == "sum":
        return 2 * q - 2 - value
    if kind == "diff":
        return -value
    raise ValueError(kind)


def active_label_sets_for_pair(n: int, x: int, y: int) -> dict[str, set[int]]:
    q = q_of(n)
    h = h_of(n)
    rows = {h, y}
    cols = {h, x}
    sums = {q - 1}
    diffs = {0}
    for s in [q + x, q + y]:
        if 0 <= s <= 2 * q - 2:
            sums.add(s)
    for d in [q - x, y - q]:
        if -(q - 1) <= d <= q - 1:
            diffs.add(d)
    return {"row": rows, "col": cols, "sum": sums, "diff": diffs}


def raw_label_sets_for_pair(n: int, x: int, y: int) -> dict[str, set[int]]:
    q = q_of(n)
    h = h_of(n)
    return {
        "row": {h, q, y},
        "col": {h, x, q},
        "sum": {q - 1, q + x, q + y},
        "diff": {0, q - x, y - q},
    }


def unpaired_labels(n: int, label_sets: dict[str, set[int]]) -> dict[str, set[int]]:
    out: dict[str, set[int]] = {}
    for kind, vals in label_sets.items():
        out[kind] = {v for v in vals if label_tau(kind, n, v) not in vals}
    return out


def unpaired_label_orbits(n: int, label_sets: dict[str, set[int]]) -> dict[str, set[int]]:
    out: dict[str, set[int]] = {}
    for kind, vals in label_sets.items():
        xs: set[int] = set()
        for v in vals:
            tv = label_tau(kind, n, v)
            if tv not in vals:
                xs.add(v)
                xs.add(tv)
        out[kind] = xs
    return out


def label_cover(n: int, unpaired: dict[str, set[int]]) -> set[Square]:
    cover: set[Square] = set()
    for r, c in live_core(n):
        if (
            r in unpaired["row"]
            or c in unpaired["col"]
            or r + c in unpaired["sum"]
            or r - c in unpaired["diff"]
        ):
            cover.add((r, c))
    return cover


def label_imbalance_score(n: int, x: int, y: int) -> tuple[int, int, int]:
    unpaired = unpaired_labels(n, active_label_sets_for_pair(n, x, y))
    counts = [len(unpaired[k]) for k in ["row", "col", "sum", "diff"]]
    return max(counts), sum(counts), max(counts) - min(counts)


def repair_records(n: int, x: int) -> list[dict[str, object]]:
    out: list[dict[str, object]] = []
    for y in border_coords(n):
        attacked = x == y
        if attacked:
            continue
        scar = combined_scar(n, x, y)
        asym = symdiff_size(n, scar)
        max_imb, total_unpaired, spread = label_imbalance_score(n, x, y)
        out.append(
            {
                "y": y,
                "attacked": attacked,
                "combined": len(scar),
                "asym": asym,
                "remaining": len(live_core(n)) - len(scar),
                "max_imb": max_imb,
                "total_unpaired": total_unpaired,
                "spread": spread,
            }
        )
    return out


def best_repairs(n: int, x: int) -> tuple[list[int], dict[str, object], list[dict[str, object]]]:
    recs = repair_records(n, x)
    min_asym = min(int(r["asym"]) for r in recs)
    primary = [r for r in recs if r["asym"] == min_asym]
    lex = min(primary, key=lambda r: (int(r["combined"]), int(r["max_imb"]), int(r["total_unpaired"]), int(r["y"])))
    return [int(r["y"]) for r in primary], lex, recs


def section_closed_border() -> str:
    lines: list[str] = []
    lines.append("## Closed-form live-border formulas")
    lines.append("")
    lines.append("Status: PROVEN by arithmetic; verified for n=8..24 by Python.")
    lines.append("")
    lines.append("Let `n=2m`, `q=n-1`, and `h=m-1`.  After `c*=(h,h)`, a border square can only lie on row `q` or column `q`.")
    lines.append("")
    lines.append("- Row arm: `B_row = {(q,x): 0 <= x <= q-1, x != h}`; hence `|B_row| = q-1 = n-2`.")
    lines.append("- Column arm: `B_col = {(y,q): 0 <= y <= q-1, y != h}`; hence `|B_col| = n-2`.")
    lines.append("- Total live border size is `2(n-2)`.")
    lines.append("- Two row-arm squares share row `q`; two column-arm squares share column `q`, so each arm is a clique.")
    lines.append("- `(q,x)` and `(y,q)` share the anti-diagonal exactly when `q+x = y+q`, i.e. `x=y`; they never share row/column, and their differences `q-x` and `y-q` are equal only at the excluded impossible equation `x+y=2q`.")
    lines.append("- Therefore cross-arm attack occurs exactly when `x=y`.  Since each arm is a clique, any three border squares contain two in one arm and are not independent; at most two live-border queens can ever be placed.")
    rows = [["n", "|B_row|", "|B_col|", "|B|", "formula ok", "cross iff x=y", "no independent triple"]]
    for n in range(8, 26, 2):
        row, col = live_border_formula(n)
        border = row | col
        formula_ok = len(row) == n - 2 and len(col) == n - 2 and len(border) == 2 * (n - 2)
        cross_ok = all(attacks((q_of(n), x), (y, q_of(n))) == (x == y) for x in border_coords(n) for y in border_coords(n))
        no_triple = not any(
            (not attacks(a, b) and not attacks(a, c) and not attacks(b, c))
            for a, b, c in itertools.combinations(sorted(border), 3)
        )
        rows.append([n, len(row), len(col), len(border), formula_ok, cross_ok, no_triple])
    lines.append("")
    lines.append(md_table(rows))
    return "\n".join(lines)


def section_single_scar() -> str:
    lines: list[str] = []
    lines.append("## Single-border scar formulas")
    lines.append("")
    lines.append("Status: PROVEN by arithmetic for the displayed formulas; verified for n=8..24 by Python.")
    lines.append("")
    lines.append("For a row-arm border move `b=(q,x)`, raw geometric `scar_S(b)` is the disjoint union inside `S` of:")
    lines.append("")
    lines.append("- column `c=x`, length `q`;")
    lines.append("- high difference line `r-c=q-x`, length `x`;")
    lines.append("- high sum line `r+c=q+x`, length `q-1-x`.")
    lines.append("")
    lines.append("The three raw lines meet only at row `q`, outside `S`, so `|scar_S(q,x)| = q+x+q-1-x = 2q-1 = 2n-3`.")
    lines.append("")
    lines.append("For the game-relevant live scar `scar_R = scar_S ∩ R_n ∩ S`, remove the central-strike labels `row h`, `col h`, `sum q-1`, and `diff 0`.  With `[P]` denoting 1 if `P` holds:")
    lines.append("")
    lines.append("- live column contribution: `q-3 = n-4`.")
    lines.append("- live high-difference contribution: `x - 2[x>=m] - [x odd]`.")
    lines.append("- live high-sum contribution: `q-1-x - 2[x<=h-1] - [x odd]`.")
    lines.append("- since `x != h`, exactly one side indicator is active, so `|scar_R(q,x)| = 2n-8 - 2[x odd]`.")
    lines.append("")
    lines.append("The column-arm formula is the transpose: replace `x` by `y`, column by row, and high-difference/high-sum by `r-c=y-q`, `r+c=y+q`.")
    rows = [["n", "coords checked", "raw mismatches", "live total mismatches", "component mismatches", "even |scar_R|", "odd |scar_R|"]]
    for n in range(8, 26, 2):
        raw_bad = live_bad = comp_bad = 0
        for x in border_coords(n):
            if len(raw_row_scar(n, x)) != raw_scar_size_formula(n):
                raw_bad += 1
            col, diff, anti, total = row_live_component_counts_formula(n, x)
            brute = len(live_row_scar(n, x))
            if total != brute or row_live_scar_size_formula(n, x) != brute:
                live_bad += 1
            # Component counts from labels, checked by direct filtering.
            q = q_of(n)
            live = live_core(n)
            b_col = sum(1 for r, c in live if c == x)
            b_diff = sum(1 for r, c in live if r - c == q - x)
            b_anti = sum(1 for r, c in live if r + c == q + x)
            if (col, diff, anti) != (b_col, b_diff, b_anti):
                comp_bad += 1
        rows.append([n, len(border_coords(n)), raw_bad, live_bad, comp_bad, 2 * n - 8, 2 * n - 10])
    lines.append("")
    lines.append(md_table(rows))
    return "\n".join(lines)


def dead_intersection_tags(n: int, x: int) -> list[str]:
    m = m_of(n)
    h = h_of(n)
    tags = []
    if x <= h - 1:
        if 2 * x == m - 2:
            tags.append("left-row-h")
        if 3 * x == 2 * m - 3:
            tags.append("left-diff0")
    else:
        if 2 * x == 3 * m - 2:
            tags.append("right-row-h")
        if 3 * x == 4 * m - 3:
            tags.append("right-sum-h")
    return tags


def section_tau_asym() -> str:
    lines: list[str] = []
    lines.append("## Single-border tau-asymmetry")
    lines.append("")
    lines.append("Status: PROVEN by arithmetic for the indicator formula; verified for n=8..24 by Python.")
    lines.append("")
    lines.append("Inside `S`, tau sends line labels as follows: rows/columns `ell -> q-1-ell`, sums `a -> 2q-2-a`, and differences `d -> -d`.")
    lines.append("")
    lines.append("For a row scar at coordinate `x`, the only possible intersections between `scar_R(q,x)` and its tau-image are two symmetric candidate points.  Both survive, or both are killed by a central-strike label.  Thus")
    lines.append("")
    lines.append("`|scar_R ∩ tau(scar_R)| = J_n(x)`, where `J_n(x)=2` except at these dead-intersection coordinates:")
    lines.append("")
    lines.append("- left side `x <= h-1`: `2x=m-2` or `3x=2m-3`;")
    lines.append("- right side `x >= m`: `2x=3m-2` or `3x=4m-3`.")
    lines.append("")
    lines.append("Then `|Delta_b| = |scar_R Δ tau(scar_R)| = 2|scar_R| - 2J_n(x)`.")
    rows = [["n", "m", "dead-intersection x", "formula mismatches", "min |Delta|", "minimizing x"]]
    for n in range(8, 26, 2):
        bad = 0
        vals: list[tuple[int, int]] = []
        dead = []
        for x in border_coords(n):
            brute = symdiff_size(n, live_row_scar(n, x))
            formula = tau_asym_formula(n, x)
            if brute != formula:
                bad += 1
            vals.append((x, brute))
            tags = dead_intersection_tags(n, x)
            if tags:
                dead.append(f"{x}:{','.join(tags)}")
        mn = min(v for _, v in vals)
        mins = [x for x, v in vals if v == mn]
        rows.append([n, m_of(n), " ".join(dead) or "none", bad, mn, ",".join(map(str, mins))])
    lines.append("")
    lines.append(md_table(rows))
    lines.append("")
    lines.append("Pattern: the minimum is usually at odd coordinates whose two tau-intersections survive (`J=2`).  Endpoint status alone is not decisive; the exceptional coordinates are where the candidate intersections land on the central killed row, killed sum, or killed difference.")
    return "\n".join(lines)


def compact_best_map(n: int) -> str:
    cells = []
    for x in border_coords(n):
        ys, lex, _ = best_repairs(n, x)
        if len(ys) > 4:
            ytxt = ",".join(map(str, ys[:4])) + "+"
        else:
            ytxt = ",".join(map(str, ys))
        cells.append(f"{x}->{ytxt}@{lex['asym']}/{lex['combined']}")
    return " ; ".join(cells)


def section_best_repair() -> str:
    lines: list[str] = []
    lines.append("## Best cross-arm repair candidates")
    lines.append("")
    lines.append("Status: verified for n=8..24 by exhaustive arithmetic enumeration of all legal cross-arm replies; symbolic minimizer rule remains heuristic / open.")
    lines.append("")
    lines.append("For opponent `(q,x)`, every cross-arm reply `(y,q)` with `y=x` is illegal, because the two border squares share sum `q+x`.  The script enumerated all other `y != h,x` and minimized lexicographically by `|combined_asym|`, then `|combined_scar|`, then label-imbalance score.")
    rows = [["n", "row coords", "legal pairs", "unique primary", "ties", "adjacent-best", "min asym range", "lex-best size range"]]
    for n in range(8, 26, 2):
        unique = ties = adjacent = legal_pairs = 0
        min_as = []
        sizes = []
        for x in border_coords(n):
            ys, lex, recs = best_repairs(n, x)
            legal_pairs += len(recs)
            if len(ys) == 1:
                unique += 1
            else:
                ties += 1
            if any(abs(y - x) == 1 for y in ys):
                adjacent += 1
            min_as.append(int(lex["asym"]))
            sizes.append(int(lex["combined"]))
        rows.append([n, len(border_coords(n)), legal_pairs, unique, ties, adjacent, f"{min(min_as)}..{max(min_as)}", f"{min(sizes)}..{max(sizes)}"])
    lines.append("")
    lines.append(md_table(rows))
    lines.append("")
    lines.append("Primary minimizer maps are shown as `x->best_y@asym/combined_size`; `+` means more ties omitted.")
    map_rows = [["n", "primary minimizers by x"]]
    for n in range(8, 26, 2):
        map_rows.append([n, compact_best_map(n)])
    lines.append("")
    lines.append(md_table(map_rows))
    lines.append("")
    lines.append("Findings:")
    lines.append("")
    lines.append("- The natural same-coordinate reply is always illegal: it is exactly the cross-arm attack case `x=y`.")
    lines.append("- No single rule such as `y=x+1`, `y=x-1`, endpoint, or center-gap reply explains all minimizers.")
    lines.append("- Ties are common, especially as n grows; this supports an oracle table keyed by coordinate class and label imbalance rather than a context-free formula.")
    return "\n".join(lines)


def section_label_state() -> str:
    lines: list[str] = []
    lines.append("## Additive line-label state after border exchange")
    lines.append("")
    lines.append("Status: verified for n=8..24 by arithmetic enumeration; proposed descriptor is heuristic.")
    lines.append("")
    lines.append("For a border pair `(q,x),(y,q)`, the active line labels inside `S` are:")
    lines.append("")
    lines.append("- rows `{h,y}`, columns `{h,x}`;")
    lines.append("- sums `{q-1}` plus any of `q+x`, `q+y` lying in `[0,2q-2]`;")
    lines.append("- differences `{0}` plus any of `q-x`, `y-q` lying in `[-(q-1),q-1]`.")
    lines.append("")
    lines.append("Tau acts on labels by row/column reflection, sum complement, and diff negation.  A label is unpaired if its tau-label is not also active.")
    rows = [["n", "legal pairs", "asym subset of unpaired-label orbit cover", "exact equality", "unpaired orbit label count range", "square asym range"]]
    examples: list[list[object]] = [["n", "x", "lex-best y", "raw used labels", "unpaired label orbits", "|asym|"]]
    for n in range(8, 26, 2):
        pairs = subset_ok = exact_ok = 0
        unpaired_counts = []
        asym_vals = []
        for x in border_coords(n):
            ys, lex, _ = best_repairs(n, x)
            y = int(lex["y"])
            if n in {10, 14, 18} and len(examples) < 10:
                examples.append([
                    n,
                    x,
                    y,
                    raw_label_sets_for_pair(n, x, y),
                    unpaired_label_orbits(n, active_label_sets_for_pair(n, x, y)),
                    int(lex["asym"]),
                ])
            for rec in repair_records(n, x):
                yy = int(rec["y"])
                scar = combined_scar(n, x, yy)
                asym_set = scar ^ tau_image(n, scar)
                cover = label_cover(n, unpaired_label_orbits(n, active_label_sets_for_pair(n, x, yy)))
                pairs += 1
                subset_ok += int(asym_set <= cover)
                exact_ok += int(asym_set == cover)
                unpaired_counts.append(sum(len(v) for v in unpaired_label_orbits(n, active_label_sets_for_pair(n, x, yy)).values()))
                asym_vals.append(len(asym_set))
        rows.append([n, pairs, f"{subset_ok}/{pairs}", f"{exact_ok}/{pairs}", f"{min(unpaired_counts)}..{max(unpaired_counts)}", f"{min(asym_vals)}..{max(asym_vals)}"])
    lines.append("")
    lines.append(md_table(rows))
    lines.append("")
    lines.append("Examples for lexicographic best replies:")
    lines.append("")
    lines.append(md_table(examples))
    lines.append("")
    lines.append("Conclusion: square-level asymmetry is always covered by the squares incident to tau-unpaired label orbits, but equality is rare.  The additive labels explain where asymmetry can live; they do not by themselves determine its exact square count because line overlaps and central-strike holes matter.")
    return "\n".join(lines)


def grundy_on_live(n: int, live: set[Square]) -> tuple[int, dict[Square, int]]:
    live_tuple = tuple(sorted(live))
    index = {s: i for i, s in enumerate(live_tuple)}
    attack_masks = []
    for s in live_tuple:
        mask = 0
        for t in live_tuple:
            if attacks(s, t):
                mask |= 1 << index[t]
        attack_masks.append(mask)
    full = (1 << len(live_tuple)) - 1

    @functools.cache
    def g(mask: int) -> int:
        if mask == 0:
            return 0
        seen = set()
        x = mask
        while x:
            bit = x & -x
            i = bit.bit_length() - 1
            seen.add(g(mask & ~attack_masks[i]))
            x ^= bit
        mex = 0
        while mex in seen:
            mex += 1
        return mex

    child = {}
    for s, i in index.items():
        child[s] = g(full & ~attack_masks[i])
    return g(full), child


def section_d1_counterexample() -> str:
    lines: list[str] = []
    lines.append("## n=10 D1 counterexample anatomy")
    lines.append("")
    lines.append("Status: verified statically from existing notes; no large rediscovery search run.")
    n = 10
    placements = [(0, 4), (2, 1), (4, 7), (5, 2), (7, 8), (9, 5)]
    live = live_after(n, placements)
    g, child_values = grundy_on_live(n, live)
    rho = lambda s: (n - 1 - s[0], n - 1 - s[1])
    rows = [["live square", "rho partner", "long diagonal?", "labels (row,col,sum,diff)", "child G"]]
    for s in sorted(live):
        r, c = s
        rows.append([s, rho(s), (r == c or r + c == n - 1), labels(s), child_values[s]])
    e = (3, 3)
    eb = rho(e)
    strike_child = {s for s in live if not attacks(e, s)}
    scar_delta = {s for s in strike_child if attacks(eb, s)}
    child_hist = Counter(child_values.values())
    lines.append("")
    lines.append(f"Placement witness from `2026-07-03-almost-mirror-method.md`: `{placements}`.")
    lines.append(f"Available live set has {len(live)} squares and induced Grundy value `{g}`.")
    lines.append("")
    lines.append(md_table(rows))
    lines.append("")
    lines.append(f"Diagonal defect pair: `{e}` and `{eb}`.  Strike child after `{e}` is `{sorted(strike_child)}`; its scar against `{eb}` is `{sorted(scar_delta)}`.")
    lines.append("")
    lines.append(f"Child-value histogram: `{dict(sorted(child_hist.items()))}`.  The parent reaches Grundy 3 because non-diagonal children supply values needed for mex, even though the diagonal-pair scar is empty.")
    lines.append("")
    lines.append("Interpretation: the one live diagonal pair measures failure of the mirror pairing, not value.  The high value is manufactured by the small residual graph on the non-diagonal rho-pairs, so any repair theorem needs strategy/certificate state rather than a defect count.")
    return "\n".join(lines)


def section_vocabulary() -> str:
    lines: list[str] = []
    lines.append("## Candidate finite-state repair vocabulary")
    lines.append("")
    lines.append("Status: heuristic proposal based on verified arithmetic tables and tiny-board repair conflicts.")
    lines.append("")
    lines.append("Definitely needed fields:")
    lines.append("")
    lines.append("- `border_state`: none / row-used / col-used / both-used, plus the occupied border coordinates.")
    lines.append("- `unpaired_label_state`: active tau-unpaired rows, columns, sums, and differences inside `S`.")
    lines.append("- `coordinate_class`: endpoint, near center gap `h`, left/right side, parity, and dead-intersection tags from the tau-asymmetry formula.")
    lines.append("- `scar_class`: single-border, legal border-pair, diagonal-defect strike, or deep repair.")
    lines.append("")
    lines.append("Speculative but likely useful fields:")
    lines.append("")
    lines.append("- `pairing_health`: live tau-pair count and broken tau-pair count after the move.")
    lines.append("- `line_overlap_health`: maximum number of active unpaired labels incident to one live square.")
    lines.append("- `repair_rank`: whether a candidate minimizes square asymmetry, combined scar size, or label imbalance.")
    lines.append("")
    lines.append("Why opponent-square -> reply is too weak: the previous repair probe found many conflicts for the same coarse opponent features at n=6/8.  This pass adds a reason: the same coordinate class can have different dead-intersection tags and different unpaired-label overlaps, changing the best repair set.")
    lines.append("")
    lines.append("Telemetry to log later when the solver box is free: for every repair decision, log residual hash, border state, opponent square, candidate replies, tau-reply legality, active unpaired labels, square asymmetry, child win/loss or Grundy target, and the chosen proof reply.")
    return "\n".join(lines)


def section_lemmas() -> str:
    lines: list[str] = []
    lines.append("## Theorem-ready lemmas")
    lines.append("")
    lines.append("### Lemma B1: live-border occupancy")
    lines.append("Statement. For even `n=2m`, after `c*=(m-1,m-1)`, the live border outside `S=[0..n-2]^2` is exactly `B_row ∪ B_col` with `B_row={(n-1,x): x != m-1}` and `B_col={(y,n-1): y != m-1}`.  Its size is `2(n-2)`, and at most two border queens can be placed in any legal continuation.")
    lines.append("Proof. The central strike kills border row/column coordinate `m-1`, and kills the corner `(n-1,n-1)` by the main diagonal; all other border squares in row `n-1` or column `n-1` survive.  Each arm is a clique, so at most one square can be selected from each arm.")
    lines.append("Status: PROVEN by arithmetic.")
    lines.append("")
    lines.append("### Lemma B2: row-arm / column-arm clique structure")
    lines.append("Statement. Any two distinct row-arm squares attack each other, and any two distinct column-arm squares attack each other.")
    lines.append("Proof. Distinct row-arm squares share row `n-1`; distinct column-arm squares share column `n-1`.")
    lines.append("Status: PROVEN by arithmetic.")
    lines.append("")
    lines.append("### Lemma B3: cross-arm attack condition")
    lines.append("Statement. A row-arm square `(n-1,x)` and a column-arm square `(y,n-1)` attack if and only if `x=y`.")
    lines.append("Proof. They do not share row or column.  Their sums are `n-1+x` and `n-1+y`, equal iff `x=y`.  Their differences are `n-1-x` and `y-(n-1)`, which cannot be equal for allowed coordinates.")
    lines.append("Status: PROVEN by arithmetic.")
    lines.append("")
    lines.append("### Lemma B4: single-border scar line-label formula")
    lines.append("Statement. Let `q=n-1`, `h=m-1`, and `b=(q,x)` with `x != h`.  The raw scar in `S` is the disjoint union of `c=x`, `r-c=q-x`, and `r+c=q+x`, with size `2n-3`.  The live scar after `c*` has component counts `q-3`, `x-2[x>=m]-[x odd]`, and `q-1-x-2[x<=h-1]-[x odd]`, hence total `2n-8-2[x odd]`.")
    lines.append("Proof. Direct line-length count in the `q×q` square; raw intersections lie on row `q` outside `S`.  The central strike removes one row, one column, the central sum, and diff zero; solving each line's intersection with those four labels gives the stated subtractions.")
    lines.append("Status: PROVEN by arithmetic.")
    lines.append("")
    lines.append("### Lemma B5: tau-action on border scar labels")
    lines.append("Statement. Under `tau(r,c)=(q-1-r,q-1-c)`, row/column labels map by `ell -> q-1-ell`, sum labels by `a -> 2q-2-a`, and difference labels by `d -> -d`.  For a row scar coordinate `x`, `|scar_R ∩ tau(scar_R)|` is 2 except at the four indicator dead-intersection equations listed in the tau-asymmetry section, where it is 0.")
    lines.append("Proof. Apply tau to the three scar line labels and solve the four possible original/tau line intersections that can fall in `S`; the two candidates are killed together precisely when they lie on central row/sum/diff labels.")
    lines.append("Status: PROVEN by arithmetic, verified for n=8..24.")
    lines.append("")
    lines.append("### Lemma B6: cross-arm repair minimizer table")
    lines.append("Statement. For n=8..24, the best legal cross-arm replies under primary objective `|combined_asym|` are exactly the minimizer maps in the `Best cross-arm repair candidates` table.")
    lines.append("Proof. Exhaustive arithmetic enumeration over all legal `x,y` border-coordinate pairs with `y != x,h`.")
    lines.append("Status: verified for n=8..24; no closed symbolic minimizer rule proven.")
    return "\n".join(lines)


def section_final() -> str:
    lines: list[str] = []
    lines.append("## Final summary")
    lines.append("")
    lines.append("### Strong positive findings")
    lines.append("")
    lines.append("- PROVEN by arithmetic: live-border size, clique arms, cross-arm attack iff coordinate equality, and occupancy at most two.")
    lines.append("- PROVEN by arithmetic: raw single-border scar size is constant `2n-3`; live-core scar size is `2n-8` for even border coordinate and `2n-10` for odd coordinate.")
    lines.append("- PROVEN by arithmetic / verified n=8..24: tau-asymmetry of a single border scar has a compact indicator formula using two candidate tau-intersections.")
    lines.append("- verified for n=8..24: square-level border-pair asymmetry is always covered by tau-unpaired active line labels.")
    lines.append("")
    lines.append("### Negative findings / failed simplifications")
    lines.append("")
    lines.append("- failed / refuted: same-coordinate cross-arm repair is the natural label-balancing move but is always illegal, exactly because it is the cross-arm attack condition.")
    lines.append("- heuristic failure: no single offset, endpoint, or center-gap rule explains all best cross-arm minimizers.")
    lines.append("- failed / refuted by existing data: the n=10 D1 witness shows one diagonal defect and empty scar can still have Grundy value 3.")
    lines.append("")
    lines.append("### Clean formulas obtained")
    lines.append("")
    lines.append("- `|B_row|=|B_col|=n-2`, `|B|=2(n-2)`.")
    lines.append("- `(n-1,x)` attacks `(y,n-1)` iff `x=y`.")
    lines.append("- raw row scar component lengths: `n-1`, `x`, `n-2-x`; raw total `2n-3`.")
    lines.append("- live row scar component lengths: `n-4`, `x-2[x>=m]-[x odd]`, `n-2-x-2[x<=m-2]-[x odd]`; live total `2n-8-2[x odd]`.")
    lines.append("- single-scar tau asymmetry: `2(2n-8-2[x odd])-2J_n(x)` with `J_n(x) in {0,2}` from the dead-intersection indicators.")
    lines.append("")
    lines.append("### Formula gaps remaining")
    lines.append("")
    lines.append("- Need a symbolic closed form for best cross-arm repair minimizers, or proof that a finite table by coordinate/parity/dead-intersection class is the right abstraction.")
    lines.append("- Need tighter formulas connecting unpaired label sets to exact square-level asymmetry; current cover relation is exact as a superset but not usually equality.")
    lines.append("- Need solver telemetry to know which arithmetic minimizers are actually winning repairs in game states beyond the immediate border exchange.")
    lines.append("")
    lines.append("### Suggested next low-memory experiment")
    lines.append("")
    lines.append("- Build a finite classifier over `(side, parity, endpoint distance, center-gap distance, dead-intersection tag, unpaired-label counts)` and test whether it predicts the best-repair minimizer set for n=8..100 by pure arithmetic.")
    lines.append("")
    lines.append("### Suggested next high-memory / solver experiment after box is free")
    lines.append("")
    lines.append("- Instrument the solver to log repair decisions after central strikes for n=10/12/14/16/18, including border coordinates, unpaired labels, square asymmetry, and chosen winning replies; compare solver-winning repairs with the arithmetic minimizer table.")
    return "\n".join(lines)


def main() -> int:
    t0 = time.time()
    sections = [
        section_closed_border(),
        section_single_scar(),
        section_tau_asym(),
        section_best_repair(),
        section_label_state(),
        section_d1_counterexample(),
        section_vocabulary(),
        section_lemmas(),
        section_final(),
    ]
    print("\n\n".join(sections))
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    print("")
    print(f"_Script resource footer: elapsed={time.time() - t0:.3f}s, maxrss={rss} KB._")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
