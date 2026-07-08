#!/usr/bin/env python3
"""GF(9) q=9 intrusion-structure probe for the on-conic S4 grid-cap game.

Field model: F_9 = F_3[i] with i^2 = -1 = 2.  The normalized conic is
    C_aff = {(t, 1/t) : t in F_9^*}
plus the two pre-played directions A=(1:0:0), B=(0:1:0).

The script checks every normalized on-conic S4, and groups the resulting
6-point conic subsets by full PGL(2,9) orbit.
"""

from __future__ import annotations

from collections import Counter
from functools import lru_cache
from itertools import combinations, product


Q = 9
P = 3
ZERO = 0
ONE = 1
INF = 9


def f_add(x: int, y: int) -> int:
    return ((x % P + y % P) % P) + P * (((x // P) + (y // P)) % P)


def f_neg(x: int) -> int:
    return ((-x) % P) + P * ((-(x // P)) % P)


def f_sub(x: int, y: int) -> int:
    return f_add(x, f_neg(y))


def f_mul(x: int, y: int) -> int:
    a, b = x % P, x // P
    c, d = y % P, y // P
    # (a + b*i)(c + d*i), with i^2 = 2 in F_3.
    return ((a * c + 2 * b * d) % P) + P * ((a * d + b * c) % P)


def f_pow(x: int, n: int) -> int:
    out = ONE
    while n:
        if n & 1:
            out = f_mul(out, x)
        x = f_mul(x, x)
        n >>= 1
    return out


def f_inv(x: int) -> int:
    assert x != ZERO
    return f_pow(x, Q - 2)


def f_div(x: int, y: int) -> int:
    return f_mul(x, f_inv(y))


def f_eq_zero(x: int) -> bool:
    return x == ZERO


def f_name(x: int) -> str:
    a, b = x % P, x // P
    if x == 0:
        return "0"
    parts = []
    if a:
        parts.append(str(a))
    if b == 1:
        parts.append("i")
    elif b == 2:
        parts.append("2i")
    return "+".join(parts)


def p1_name(x: int) -> str:
    return "inf" if x == INF else f_name(x)


def pt_aff(cell: int) -> tuple[int, int, int]:
    return (cell // Q, cell % Q, ONE)


A = (ONE, ZERO, ZERO)
B = (ZERO, ONE, ZERO)
BASE_POINTS = [A, B] + [pt_aff(c) for c in range(Q * Q)]
FULL_MASK = (1 << (Q * Q)) - 1


def det3(p: tuple[int, int, int], r: tuple[int, int, int], s: tuple[int, int, int]) -> int:
    return f_add(
        f_sub(
            f_mul(p[0], f_sub(f_mul(r[1], s[2]), f_mul(r[2], s[1]))),
            f_mul(p[1], f_sub(f_mul(r[0], s[2]), f_mul(r[2], s[0]))),
        ),
        f_mul(p[2], f_sub(f_mul(r[0], s[1]), f_mul(r[1], s[0]))),
    )


def collinear(p: tuple[int, int, int], r: tuple[int, int, int], s: tuple[int, int, int]) -> bool:
    return f_eq_zero(det3(p, r, s))


def build_line_masks() -> list[list[int]]:
    n = len(BASE_POINTS)
    out = [[0] * n for _ in range(n)]
    aff_pts = BASE_POINTS[2:]
    for i in range(n):
        for j in range(i + 1, n):
            mask = 0
            for c, p in enumerate(aff_pts):
                if collinear(p, BASE_POINTS[i], BASE_POINTS[j]):
                    mask |= 1 << c
            out[i][j] = mask
            out[j][i] = mask
    return out


LINE_MASK = build_line_masks()


NONZERO = [x for x in range(Q) if x != ZERO]
INV = {x: f_inv(x) for x in NONZERO}
CONIC_CELL = {t: t * Q + INV[t] for t in NONZERO}
CONIC_KEYS = [INF, ZERO] + NONZERO
CONIC_POINT = {INF: A, ZERO: B}
CONIC_POINT.update({t: pt_aff(CONIC_CELL[t]) for t in NONZERO})


def is_on_conic_cell(cell: int) -> bool:
    return f_mul(cell // Q, cell % Q) == ONE


def cell_label(cell: int) -> str:
    return f"({f_name(cell // Q)},{f_name(cell % Q)})"


@lru_cache(maxsize=None)
def legal_mask(mask: int) -> int:
    pts = [0, 1]
    occupied = 0
    for c in range(Q * Q):
        if mask & (1 << c):
            pts.append(c + 2)
            occupied |= 1 << c
    forbidden = occupied
    for i, pi in enumerate(pts):
        for pj in pts[i + 1 :]:
            forbidden |= LINE_MASK[pi][pj]
    return FULL_MASK & ~forbidden


@lru_cache(maxsize=None)
def solve(mask: int) -> tuple[bool, int, int]:
    """Return (N-position?, maximum game-tree depth, maximum branching)."""
    moves = legal_mask(mask)
    if moves == 0:
        return (False, 0, 0)
    win = False
    max_depth = 0
    max_branch = moves.bit_count()
    bits = moves
    while bits:
        bit = bits & -bits
        child_win, child_depth, child_branch = solve(mask | bit)
        if not child_win:
            win = True
        max_depth = max(max_depth, 1 + child_depth)
        max_branch = max(max_branch, child_branch)
        bits ^= bit
    return (win, max_depth, max_branch)


@lru_cache(maxsize=None)
def subtree_state_count(mask: int) -> int:
    seen = {mask}
    stack = [mask]
    while stack:
        cur = stack.pop()
        moves = legal_mask(cur)
        bits = moves
        while bits:
            bit = bits & -bits
            nxt = cur | bit
            if nxt not in seen:
                seen.add(nxt)
                stack.append(nxt)
            bits ^= bit
    return len(seen)


def mask_from_cells(cells: list[int] | tuple[int, ...]) -> int:
    mask = 0
    for c in cells:
        mask |= 1 << c
    return mask


def conic_sigma(cell: int, key: int) -> int:
    x = pt_aff(cell)
    p = CONIC_POINT[key]
    hits = [k for k in CONIC_KEYS if collinear(CONIC_POINT[k], x, p)]
    if len(hits) == 1:
        assert hits[0] == key
        return key
    assert len(hits) == 2 and key in hits, (cell, key, hits)
    return hits[0] if hits[1] == key else hits[1]


def tau_x(cell: int) -> int:
    return sum(1 for key in CONIC_KEYS if conic_sigma(cell, key) == key)


def pgl2_permutations() -> list[dict[int, int]]:
    perms = {}
    elems = range(Q)
    for a, b, c, d in product(elems, repeat=4):
        det = f_sub(f_mul(a, d), f_mul(b, c))
        if det == ZERO:
            continue
        image = []
        for x in CONIC_KEYS:
            if x == INF:
                y = INF if c == ZERO else f_div(a, c)
            else:
                num = f_add(f_mul(a, x), b)
                den = f_add(f_mul(c, x), d)
                y = INF if den == ZERO else f_div(num, den)
            image.append(y)
        perms[tuple(image)] = dict(zip(CONIC_KEYS, image))
    return list(perms.values())


PGL2 = pgl2_permutations()


def canonical_pgl2(six_set: frozenset[int]) -> tuple[int, ...]:
    return min(tuple(sorted(perm[x] for x in six_set)) for perm in PGL2)


def set_label(keys: tuple[int, ...] | frozenset[int]) -> str:
    return "{" + ",".join(p1_name(x) for x in sorted(keys)) + "}"


def run() -> None:
    by_class: dict[tuple[int, ...], dict[str, object]] = {}
    global_intrusion_hist = Counter()
    global_intruder_counts = Counter()
    global_first_move_counts = Counter()
    failures: list[str] = []
    intruded_children: list[int] = []
    all_s4_masks: list[int] = []

    for t4 in combinations(NONZERO, 4):
        six = frozenset((INF, ZERO, *t4))
        cls = canonical_pgl2(six)
        rec = by_class.setdefault(
            cls,
            {
                "raw": 0,
                "intruder_counts": Counter(),
                "intrusion_hist": Counter(),
                "child_outcomes": Counter(),
                "child_reply_counts": Counter(),
                "winning_reply_counts": Counter(),
                "terminal_win_reply_counts": Counter(),
                "max_depth": 0,
                "max_branch": 0,
                "max_states": 0,
                "first_moves": Counter(),
                "conic_first_reply_counts": Counter(),
                "off_first_reply_counts": Counter(),
            },
        )
        rec["raw"] += 1

        s4_cells = [CONIC_CELL[t] for t in t4]
        s4_mask = mask_from_cells(s4_cells)
        all_s4_masks.append(s4_mask)
        s4_win, _, _ = solve(s4_mask)
        if s4_win:
            failures.append(f"S4 is N, t4={set_label(six)}")

        legal0 = legal_mask(s4_mask)
        conic_first = 0
        off_first = 0
        bits = legal0
        while bits:
            bit = bits & -bits
            cell = bit.bit_length() - 1
            child = s4_mask | bit
            child_win, _, _ = solve(child)
            if not child_win:
                failures.append(f"first move to P child from S4 {set_label(six)} at {cell_label(cell)}")
            reply_count = legal_mask(child).bit_count()
            if is_on_conic_cell(cell):
                conic_first += 1
                rec["conic_first_reply_counts"][reply_count] += 1
            else:
                off_first += 1
                rec["off_first_reply_counts"][reply_count] += 1
            bits ^= bit
        rec["first_moves"][(conic_first, off_first)] += 1
        global_first_move_counts[(conic_first, off_first)] += 1

        played_conic = set((INF, ZERO, *t4))
        rem_conic = set(NONZERO) - set(t4)
        intruders = []
        bits = legal0
        while bits:
            bit = bits & -bits
            cell = bit.bit_length() - 1
            if not is_on_conic_cell(cell):
                intruders.append(cell)
            bits ^= bit

        rec["intruder_counts"][len(intruders)] += 1
        global_intruder_counts[len(intruders)] += 1

        for cell in intruders:
            tx = tau_x(cell)
            tplayed = sum(1 for key in played_conic if conic_sigma(cell, key) == key)
            rec["intrusion_hist"][(tx, tplayed)] += 1
            global_intrusion_hist[(tx, tplayed)] += 1
            if (tx, tplayed) != (2, 2):
                failures.append(
                    f"bad intrusion type {tx,tplayed} for {set_label(six)} at {cell_label(cell)}"
                )

            sigma_played = {conic_sigma(cell, key) for key in played_conic}
            expected_killed = sigma_played & rem_conic
            child = s4_mask | (1 << cell)
            surviving_conic = {
                t for t in rem_conic if legal_mask(child) & (1 << CONIC_CELL[t])
            }
            if surviving_conic:
                failures.append(
                    f"conic survived after intrusion {set_label(six)} at {cell_label(cell)}: "
                    f"{set_label(frozenset(surviving_conic))}"
                )
            if expected_killed != rem_conic:
                failures.append(
                    f"sigma kill-set mismatch {set_label(six)} at {cell_label(cell)}: "
                    f"expected {set_label(frozenset(expected_killed))}, rem {set_label(frozenset(rem_conic))}"
                )

            child_win, child_depth, child_branch = solve(child)
            if not child_win:
                failures.append(f"intruded child is P for {set_label(six)} at {cell_label(cell)}")
            rec["child_outcomes"]["N" if child_win else "P"] += 1
            rec["max_depth"] = max(rec["max_depth"], child_depth)
            rec["max_branch"] = max(rec["max_branch"], child_branch)
            rec["max_states"] = max(rec["max_states"], subtree_state_count(child))
            intruded_children.append(child)

            replies = legal_mask(child)
            rec["child_reply_counts"][replies.bit_count()] += 1
            winning_replies = 0
            terminal_winning_replies = 0
            bits2 = replies
            while bits2:
                bit2 = bits2 & -bits2
                grandchild = child | bit2
                grandchild_win, _, _ = solve(grandchild)
                if not grandchild_win:
                    winning_replies += 1
                    if legal_mask(grandchild) == 0:
                        terminal_winning_replies += 1
                bits2 ^= bit2
            rec["winning_reply_counts"][winning_replies] += 1
            rec["terminal_win_reply_counts"][terminal_winning_replies] += 1

    all_s4_p = all(not solve(mask)[0] for mask in all_s4_masks)
    all_intruded_n = all(solve(mask)[0] for mask in intruded_children)
    all_have_terminal_p2 = all(
        any(
            (not solve(mask | bit)[0]) and legal_mask(mask | bit) == 0
            for bit in iter_bits(legal_mask(mask))
        )
        for mask in intruded_children
    )

    print("q=9 GF(9) intrusion probe")
    print(f"field=F3[i]/(i^2+1), PGL2 permutations={len(PGL2)}")
    print(f"raw normalized on-conic S4 configs={len(all_s4_masks)}")
    print(f"full PGL(2,9) S4 classes={len(by_class)}")
    print(f"global legal first moves (conic,intruder) histogram={dict(sorted(global_first_move_counts.items()))}")
    print(f"global legal intruders per S4 histogram={dict(sorted(global_intruder_counts.items()))}")
    print(f"global intrusion types (tau_x,tau_played)={dict(sorted(global_intrusion_hist.items()))}")
    print(f"all S4 P={all_s4_p}")
    print(f"all intruded children N={all_intruded_n}")
    print(f"all intruded children have a terminal P2 reply={all_have_terminal_p2}")
    print(f"failures={len(failures)}")
    for failure in failures[:20]:
        print(f"FAIL {failure}")
    print()
    print("classes:")
    for idx, (cls, rec) in enumerate(sorted(by_class.items()), 1):
        print(f"CLASS {idx} rep={set_label(cls)} raw={rec['raw']}")
        for key in (
            "first_moves",
            "intruder_counts",
            "intrusion_hist",
            "child_outcomes",
            "child_reply_counts",
            "winning_reply_counts",
            "terminal_win_reply_counts",
            "conic_first_reply_counts",
            "off_first_reply_counts",
        ):
            print(f"  {key}={dict(sorted(rec[key].items()))}")
        print(
            f"  residual max_depth={rec['max_depth']} "
            f"max_branch={rec['max_branch']} max_states_per_child={rec['max_states']}"
        )


def iter_bits(mask: int):
    bits = mask
    while bits:
        bit = bits & -bits
        yield bit
        bits ^= bit


if __name__ == "__main__":
    run()
