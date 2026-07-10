#!/usr/bin/env python3
"""Replay the pre-registered kill-set top-k maintenance rule (R2-2).

The candidate gate is value-blind: legal replies whose post-reply live-conic
Node-Kayles xor is zero.  Candidates are ordered by

  ([D != empty], |D|, |K|, sorted ray-kill profile, geometry, row, column),

where D is the newly killed live-conic set and K is the newly killed live
off-conic set.  Values are consulted only after this order is fixed.

Corpora:

* q19: the 148 exact root maintenance obligations in the complete Grundy dump.
* q23: accepted followers for root moves 0..9 in the detailed maintenance log.
  Labels come from exact MAINTTRY rows, supplemented by the certified early-break
  raw table.  A missing early-break record remains UNKNOWN.

This is deliberately a narrow replay, not a solver.  It reconstructs legality,
the conic graph, kill sets, and canonical keys independently in Python.
"""

from __future__ import annotations

import argparse
import json
import mmap
import re
import struct
from collections import Counter, defaultdict
from dataclasses import dataclass
from functools import lru_cache
from pathlib import Path

MASK64 = (1 << 64) - 1
RAW_HEADER = 128
RAW_RECORD = 24
GEOM_RANK = {"on": 0, "int": 1, "ext": 2, "off": 3, "root": 4, "anom": 5}


def mix_cell(i: int) -> tuple[int, int]:
    x = (i + 0x9E3779B97F4A7C15) & MASK64
    x = ((x ^ (x >> 30)) * 0xBF58476D1CE4E5B9) & MASK64
    x = ((x ^ (x >> 27)) * 0x94D049BB133111EB) & MASK64
    h1 = (x ^ (x >> 31)) & MASK64
    y = (i + 0xD1B54A32D192ED03) & MASK64
    y = ((y ^ (y >> 29)) * 0xFF51AFD7ED558CCD) & MASK64
    y = ((y ^ (y >> 32)) * 0xC4CEB9FE1A85EC53) & MASK64
    h2 = (y ^ (y >> 29)) & MASK64
    return h1, h2


class RawValues:
    """Binary-search lookup for GCAPGRD1 or GCAPRAW3 sorted records."""

    def __init__(self, path: Path):
        self.path = path
        self.fh = path.open("rb")
        self.mm = mmap.mmap(self.fh.fileno(), 0, access=mmap.ACCESS_READ)
        self.magic = bytes(self.mm[:8])
        if self.magic not in {b"GCAPGRD1", b"GCAPRAW3"}:
            raise ValueError(f"{path}: unsupported magic {self.magic!r}")
        self.q = struct.unpack_from("<I", self.mm, 24)[0]
        self.n = struct.unpack_from("<Q", self.mm, 48)[0]
        rec = struct.unpack_from("<I", self.mm, 56)[0]
        if rec != RAW_RECORD or len(self.mm) != RAW_HEADER + self.n * RAW_RECORD:
            raise ValueError(f"{path}: malformed raw length")
        self.t4 = tuple(struct.unpack_from("<4H", self.mm, 32))
        self.root_key = struct.unpack_from("<Q", self.mm, 72)[0] | (
            struct.unpack_from("<Q", self.mm, 80)[0] << 64
        )

    def get(self, key: int) -> int | None:
        lo, hi = 0, self.n
        while lo < hi:
            mid = (lo + hi) // 2
            off = RAW_HEADER + mid * RAW_RECORD
            a, b = struct.unpack_from("<QQ", self.mm, off)
            k = a | (b << 64)
            if k < key:
                lo = mid + 1
            else:
                hi = mid
        if lo == self.n:
            return None
        off = RAW_HEADER + lo * RAW_RECORD
        a, b, value = struct.unpack_from("<QQB", self.mm, off)
        return value if (a | (b << 64)) == key else None

    def close(self) -> None:
        self.mm.close()
        self.fh.close()


@dataclass(frozen=True)
class State:
    cells: tuple[tuple[int, int], ...]
    forbidden: frozenset[tuple[int, int]]


class Board:
    def __init__(self, q: int):
        self.q = q
        self.inv = [0] + [pow(x, q - 2, q) for x in range(1, q)]
        self.cellh = [mix_cell(i) for i in range(q * q)]

    def line(self, a: tuple[int, int], b: tuple[int, int]) -> frozenset[tuple[int, int]]:
        dr = (b[0] - a[0]) % self.q
        dc = (b[1] - a[1]) % self.q
        return frozenset(((a[0] + t * dr) % self.q, (a[1] + t * dc) % self.q) for t in range(self.q))

    def root(self, t4: tuple[int, ...]) -> State:
        state = State((), frozenset())
        for t in t4:
            state = self.push(state, (t, self.inv[t]))
        return state

    def push(self, state: State, z: tuple[int, int]) -> State:
        if z in state.cells or z in state.forbidden:
            raise ValueError(f"illegal push {z} into {state.cells}")
        forbidden = set(state.forbidden)
        r, c = z
        forbidden.update((r, cc) for cc in range(self.q))
        forbidden.update((rr, c) for rr in range(self.q))
        for x in state.cells:
            forbidden.update(self.line(x, z))
        return State(state.cells + (z,), frozenset(forbidden))

    def avail(self, state: State) -> list[tuple[int, int]]:
        chosen = set(state.cells)
        return [
            (r, c)
            for r in range(self.q)
            for c in range(self.q)
            if (r, c) not in chosen and (r, c) not in state.forbidden
        ]

    def on_conic(self, z: tuple[int, int]) -> bool:
        return z[0] != 0 and z[1] == self.inv[z[0]]

    def live_conic(self, state: State) -> frozenset[tuple[int, int]]:
        chosen = set(state.cells)
        return frozenset(
            (t, self.inv[t])
            for t in range(1, self.q)
            if (t, self.inv[t]) not in chosen and (t, self.inv[t]) not in state.forbidden
        )

    def zone(self, state: State) -> frozenset[tuple[int, int]]:
        return frozenset(z for z in self.avail(state) if not self.on_conic(z))

    def geom(self, z: tuple[int, int]) -> str:
        if self.on_conic(z):
            return "on"
        r, c = z
        tangents = int(c == 0) + int(r == 0)
        for pr in range(1, self.q):
            pc = self.inv[pr]
            if (pr * c + pc * r - 2) % self.q == 0:
                tangents += 1
        return "ext" if tangents == 2 else "int" if tangents == 0 else "anom"

    def conic_adj(self, state: State) -> tuple[tuple[int, int], tuple[int, ...]]:
        live = tuple(sorted(self.live_conic(state)))
        adj = [0] * len(live)
        for x in state.cells:
            if self.on_conic(x):
                continue
            for i, a in enumerate(live):
                line = self.line(x, a)
                for j in range(i + 1, len(live)):
                    if live[j] in line:
                        adj[i] |= 1 << j
                        adj[j] |= 1 << i
        return live, tuple(adj)

    def conic_xor(self, state: State) -> int:
        _live, adj = self.conic_adj(state)
        return nk_value(adj)

    def shape(self, state: State) -> str:
        live, adj = self.conic_adj(state)
        unseen = (1 << len(live)) - 1
        sizes = []
        while unseen:
            seed = unseen & -unseen
            todo, comp = seed, 0
            unseen ^= seed
            while todo:
                bit = todo & -todo
                todo ^= bit
                i = bit.bit_length() - 1
                comp |= bit
                new = adj[i] & unseen
                unseen ^= new
                todo |= new
            sizes.append(comp.bit_count())
        return f"live={len(live)} comps={','.join(map(str, sorted(sizes, reverse=True)))} xor={nk_value(adj)}"

    def canon(self, cells: tuple[tuple[int, int], ...]) -> int:
        n = len(cells)
        if n <= 1:
            return n
        best = (1 << 128) - 1
        for ui, (ur, uc) in enumerate(cells):
            tr = [((r - ur) % self.q) for r, _c in cells]
            tc = [((c - uc) % self.q) for _r, c in cells]
            for vi in range(n):
                if vi == ui or tr[vi] == 0 or tc[vi] == 0:
                    continue
                for sr, sc in ((tr, tc), (tc, tr)):
                    if sr[vi] == 0 or sc[vi] == 0:
                        continue
                    a = self.inv[sr[vi]]
                    b = self.inv[sc[vi]]
                    s1 = s2 = 0
                    for k in range(n):
                        idx = ((a * sr[k]) % self.q) * self.q + (b * sc[k]) % self.q
                        h1, h2 = self.cellh[idx]
                        s1 = (s1 + h1) & MASK64
                        s2 = (s2 + h2) & MASK64
                    best = min(best, (s1 << 64) | s2)
        return best


@lru_cache(maxsize=None)
def nk_value(adj: tuple[int, ...]) -> int:
    @lru_cache(maxsize=None)
    def rec(mask: int) -> int:
        if mask == 0:
            return 0
        seen = 0
        bits = mask
        while bits:
            bit = bits & -bits
            bits ^= bit
            i = bit.bit_length() - 1
            g = rec(mask & ~(bit | adj[i]))
            seen |= 1 << g
        g = 0
        while seen & (1 << g):
            g += 1
        return g

    return rec((1 << len(adj)) - 1)


def ray_profile(board: Board, state: State, w: tuple[int, int], zone: frozenset[tuple[int, int]]) -> tuple[int, ...]:
    counts = [0] * (len(state.cells) + 2)
    lines = [board.line(x, w) for x in state.cells]
    for y in zone:
        if y == w:
            continue
        if y[0] == w[0]:
            counts[0] += 1
        elif y[1] == w[1]:
            counts[1] += 1
        else:
            for i, line in enumerate(lines):
                if y in line:
                    counts[i + 2] += 1
                    break
    return tuple(sorted(counts))


@dataclass
class Candidate:
    w: tuple[int, int]
    state: State
    d: tuple[int, ...]
    k: int
    rays: tuple[int, ...]
    geom: str
    value: str = "?"

    def score(self) -> tuple[object, ...]:
        return (bool(self.d), len(self.d), self.k, self.rays, GEOM_RANK[self.geom], self.w[0], self.w[1])

    def desc(self) -> dict[str, object]:
        return {"w": f"{self.w[0]},{self.w[1]}", "value": self.value, "D": list(self.d), "K": self.k, "R": list(self.rays), "geom": self.geom}


def ranked_candidates(board: Board, after_opponent: State) -> list[Candidate]:
    live0 = board.live_conic(after_opponent)
    zone0 = board.zone(after_opponent)
    out = []
    for w in board.avail(after_opponent):
        child = board.push(after_opponent, w)
        if board.conic_xor(child) != 0:
            continue
        live1 = board.live_conic(child)
        zone1 = board.zone(child)
        d = tuple(sorted(t for t, _c in live0 - live1))
        out.append(Candidate(w, child, d, len(zone0 - zone1), ray_profile(board, after_opponent, w, zone0), board.geom(w)))
    out.sort(key=Candidate.score)
    return out


def parse_kv(line: str) -> dict[str, str]:
    return dict(re.findall(r"([A-Za-z_-]+)=([^ ]+)", line))


def parse_cell(text: str) -> tuple[int, int]:
    a, b = text.split(",")
    return int(a), int(b)


def q23_log_data(path: Path, board: Board, root: State):
    exact: dict[int, str] = {}
    accepted: list[tuple[tuple[int, int], tuple[int, int]]] = []
    current_x = current_y = None
    expected: dict[tuple[tuple[int, int], tuple[int, int], tuple[int, int]], int] = {}
    for line in path.read_text().splitlines():
        if line.startswith("MAINTFOLLOW "):
            v = parse_kv(line)
            current_x, current_y = parse_cell(v["x"]), parse_cell(v["y"])
        elif line.startswith("MAINTMOVE "):
            v = parse_kv(line)
            x, y, z = parse_cell(v["x"]), parse_cell(v["y"]), parse_cell(v["z"])
            expected[(x, y, z)] = int(v["candidates"])
        elif line.startswith("MAINTTRY "):
            if current_x is None or current_y is None:
                raise ValueError("MAINTTRY without MAINTFOLLOW")
            v = parse_kv(line)
            z, w = parse_cell(v["z"]), parse_cell(v["w"])
            state = board.push(board.push(board.push(board.push(root, current_x), current_y), z), w)
            key = board.canon(state.cells)
            label = v["value"]
            old = exact.setdefault(key, label)
            if old != label:
                raise ValueError(f"log label disagreement at {key:032x}")
        elif line.startswith("XORRESULT ") and " status=hit " in line:
            v = parse_kv(line)
            accepted.append((parse_cell(v["x"]), parse_cell(v["y"])))
    return exact, accepted, expected


def evaluate(obligations, board: Board, raw: RawValues, log_values=None, expected=None):
    log_values = log_values or {}
    stats = {k: Counter() for k in range(1, 5)}
    failures = []
    candidate_count_bad = 0
    for oid, after_opponent, expected_count in obligations:
        candidates = ranked_candidates(board, after_opponent)
        if expected_count is not None and len(candidates) != expected_count:
            candidate_count_bad += 1
        for cand in candidates[:4]:
            key = board.canon(cand.state.cells)
            raw_v = raw.get(key)
            raw_label = None if raw_v is None else ("P" if raw_v == 0 else "N")
            log_label = log_values.get(key)
            if raw_label is not None and log_label is not None and raw_label != log_label:
                raise ValueError(f"raw/log disagreement at {key:032x}: {raw_label}/{log_label}")
            cand.value = log_label or raw_label or "?"
        for k in range(1, 5):
            selected = candidates[:k]
            labels = [c.value for c in selected]
            if any(v == "P" for v in labels):
                stats[k]["hit"] += 1
            elif len(selected) < k or any(v == "?" for v in labels):
                stats[k]["unknown"] += 1
            else:
                stats[k]["fail"] += 1
        top = candidates[:4]
        if len(top) == 4 and all(c.value == "N" for c in top):
            first_p = None
            for rank, cand in enumerate(candidates[4:], 5):
                key = board.canon(cand.state.cells)
                raw_v = raw.get(key)
                raw_label = None if raw_v is None else ("P" if raw_v == 0 else "N")
                log_label = log_values.get(key)
                if raw_label is not None and log_label is not None and raw_label != log_label:
                    raise ValueError(f"raw/log disagreement at {key:032x}: {raw_label}/{log_label}")
                cand.value = log_label or raw_label or "?"
                if cand.value == "P":
                    first_p = {"rank": rank, **cand.desc()}
                    break
            failures.append({"id": oid, "before": board.shape(after_opponent), "live_params": sorted(t for t, _ in board.live_conic(after_opponent)), "candidates": [c.desc() for c in top], "first_known_p": first_p})
    return stats, failures, candidate_count_bad


def q19_obligations(board: Board, root: State):
    for x in board.avail(root):
        yield f"root/x={x[0]},{x[1]}", board.push(root, x), None


def q23_obligations(board: Board, root: State, accepted, expected):
    for x, y in accepted:
        follower = board.push(board.push(root, x), y)
        for z in board.avail(follower):
            if board.on_conic(z):
                continue
            key = (x, y, z)
            yield f"x={x[0]},{x[1]}/y={y[0]},{y[1]}/z={z[0]},{z[1]}", board.push(follower, z), expected.get(key)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--q19-grundy", type=Path, default=Path("s4-dumps/2026-07-09/c35/q19-root-1234.grundy.raw"))
    ap.add_argument("--q23-raw", type=Path, default=Path("s4-dumps/2026-07-09/c37-q23-raw/q23-bucket00-1349.raw"))
    ap.add_argument("--q23-log", type=Path, default=Path("s4-dumps/2026-07-09/xormine-q23-maint-required-idx00-rootmoves000-009.txt"))
    ap.add_argument("--fail-json", type=Path)
    args = ap.parse_args()

    reports = {}
    raw19 = RawValues(args.q19_grundy)
    b19 = Board(19)
    root19 = b19.root(tuple(raw19.t4))
    if b19.canon(root19.cells) != raw19.root_key:
        raise SystemExit("q19 Python canonicalizer disagrees at root")
    st19, fail19, bad19 = evaluate(q19_obligations(b19, root19), b19, raw19)
    reports["q19"] = {"corpus": "exact Grundy root obligations", "obligations": sum(st19[1].values()), "budget": {str(k): dict(st19[k]) for k in range(1, 5)}, "candidate_count_mismatches": bad19, "failures": fail19}
    raw19.close()

    raw23 = RawValues(args.q23_raw)
    b23 = Board(23)
    root23 = b23.root((1, 3, 4, 9))
    if b23.canon(root23.cells) != raw23.root_key:
        raise SystemExit("q23 Python canonicalizer disagrees at root")
    log_values, accepted, expected = q23_log_data(args.q23_log, b23, root23)
    st23, fail23, bad23 = evaluate(q23_obligations(b23, root23, accepted, expected), b23, raw23, log_values, expected)
    reports["q23"] = {"corpus": "10 accepted maintenance followers; exact log plus early-break raw", "accepted_followers": len(accepted), "log_labeled_keys": len(log_values), "obligations": sum(st23[1].values()), "budget": {str(k): dict(st23[k]) for k in range(1, 5)}, "candidate_count_mismatches": bad23, "failures": fail23}
    raw23.close()

    for q, rep in reports.items():
        print(f"R2-KILLSET {q} corpus={rep['corpus']} obligations={rep['obligations']} candidate_count_mismatches={rep['candidate_count_mismatches']}")
        for k in range(1, 5):
            c = Counter(rep["budget"][str(k)])
            print(f"  k={k} hit={c['hit']} fail={c['fail']} unknown={c['unknown']}")
        print(f"  exact_top4_failures={len(rep['failures'])}")
        for f in rep["failures"]:
            print("  FAIL " + json.dumps(f, sort_keys=True, separators=(",", ":")))
    if args.fail_json:
        args.fail_json.write_text(json.dumps(reports, indent=2, sort_keys=True) + "\n")
        print(f"wrote {args.fail_json}")


if __name__ == "__main__":
    main()
