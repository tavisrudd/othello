#!/usr/bin/env python3
"""C20 on-conic intrusion census.

Inputs are `gridcap feat q` logs.  For each full-PGL on-conic bucket, this
chooses one normalized representative S4, solves the full residual grid game,
and computes the intruder/NK-defect features requested in C20.
"""

from __future__ import annotations

import argparse
import ast
import itertools as it
import json
import re
import time
from collections import Counter, defaultdict
from dataclasses import dataclass, asdict
from functools import lru_cache


INF = "inf"
X_RE = re.compile(r"^X q=(\d+) cls=(\d+) x=(\d+),(\d+) val=([PN]) pos=(\w+)$")
CLS_RE = re.compile(r"^CLS q=(\d+) cls=(\d+) S3=(\[.*\]) escape=")


def inv(q: int, x: int) -> int:
    return pow(x % q, q - 2, q)


def solve3(q: int, rows: list[list[int]]) -> tuple[int, int, int]:
    m = [list(r) for r in rows]
    for col in range(3):
        piv = next(i for i in range(col, 3) if m[i][col] % q)
        m[col], m[piv] = m[piv], m[col]
        scale = inv(q, m[col][col])
        for j in range(col, 4):
            m[col][j] = (m[col][j] * scale) % q
        for i in range(3):
            if i == col:
                continue
            f = m[i][col] % q
            if f:
                for j in range(col, 4):
                    m[i][j] = (m[i][j] - f * m[col][j]) % q
    return m[0][3], m[1][3], m[2][3]


def conic_params(q: int, cells: list[tuple[int, int]]) -> tuple[int, int, int, int, int, int]:
    rows = [[r % q, c % q, 1, (-(r * c)) % q] for r, c in cells]
    eps, zeta, gamma = solve3(q, rows)
    rho = (-zeta) % q
    a_param = (-eps) % q
    b_param = (rho * a_param - gamma) % q
    assert b_param != 0, (q, cells, eps, zeta, gamma)
    return eps, zeta, gamma, rho, a_param, b_param


def fval(q: int, eps: int, zeta: int, gamma: int, r: int, c: int) -> int:
    return (r * c + eps * r + zeta * c + gamma) % q


def six_set(q: int, s3: list[tuple[int, int]], x: tuple[int, int]) -> tuple[int | str, ...]:
    eps, zeta, gamma, rho, a_param, b_param = conic_params(q, s3)
    pts: list[int | str] = [INF, 0]
    for r, c in list(s3) + [x]:
        assert fval(q, eps, zeta, gamma, r, c) == 0
        t = (r - rho) % q
        assert t != 0
        assert (c - a_param) % q == (b_param * inv(q, t)) % q
        pts.append(t)
    assert len(set(pts)) == 6
    return tuple(sorted(pts, key=param_key))


def param_key(x: int | str) -> int:
    return 10**9 if x == INF else int(x)


def mobius(q: int, m: tuple[int, int, int, int], x: int | str) -> int | str:
    a, b, c, d = m
    if x == INF:
        return INF if c == 0 else (a * inv(q, c)) % q
    den = (c * int(x) + d) % q
    if den == 0:
        return INF
    return ((a * int(x) + b) * inv(q, den)) % q


@lru_cache(maxsize=None)
def pgl_maps(q: int) -> tuple[tuple[int, int, int, int], ...]:
    seen = set()
    maps = []
    for a in range(q):
        for b in range(q):
            for c in range(q):
                for d in range(q):
                    det = (a * d - b * c) % q
                    if det == 0:
                        continue
                    entries = (a, b, c, d)
                    first = next(v for v in entries if v % q)
                    scale = inv(q, first)
                    norm = tuple((v * scale) % q for v in entries)
                    if norm in seen:
                        continue
                    seen.add(norm)
                    maps.append(norm)
    assert len(maps) == q * (q * q - 1), (q, len(maps))
    return tuple(maps)


def canon(q: int, s: tuple[int | str, ...]) -> tuple[int | str, ...]:
    images = (
        tuple(sorted((mobius(q, m, x) for x in s), key=param_key))
        for m in pgl_maps(q)
    )
    return min(images, key=lambda xs: tuple(param_key(x) for x in xs))


@dataclass
class Bucket:
    q: int
    canon: tuple[int | str, ...]
    label: str
    size: int
    sample_cls: int
    sample_s3: tuple[tuple[int, int], ...]
    sample_x: tuple[int, int]
    sample_six: tuple[int | str, ...]


def parse_logs(paths: list[str]) -> list[Bucket]:
    s3_by_q_cls: dict[tuple[int, int], list[tuple[int, int]]] = {}
    pending: dict[tuple[int, int], list[tuple[tuple[int, int], str]]] = defaultdict(list)
    for path in paths:
        with open(path, "r", encoding="utf-8") as f:
            for raw in f:
                line = raw.strip()
                m = X_RE.match(line)
                if m:
                    q, ci, r, c, val, pos = m.groups()
                    if pos == "on":
                        pending[(int(q), int(ci))].append(((int(r), int(c)), val))
                    continue
                m = CLS_RE.match(line)
                if m:
                    q, ci, s3 = m.groups()
                    s3_by_q_cls[(int(q), int(ci))] = ast.literal_eval(s3)
    rows_by_bucket: dict[tuple[int, tuple[int | str, ...]], list[dict[str, object]]] = defaultdict(list)
    for (q, ci), xs in pending.items():
        s3 = s3_by_q_cls[(q, ci)]
        for x, val in xs:
            six = six_set(q, s3, x)
            rows_by_bucket[(q, canon(q, six))].append(
                {"q": q, "cls": ci, "s3": tuple(s3), "x": x, "val": val, "six": six}
            )
    out = []
    for (q, key), vals in sorted(rows_by_bucket.items(), key=lambda kv: (kv[0][0], repr(kv[0][1]))):
        vc = Counter(v["val"] for v in vals)
        if len(vc) != 1:
            raise SystemExit(f"mixed bucket q={q} canon={key} values={dict(vc)}")
        sample = vals[0]
        out.append(
            Bucket(
                q=q,
                canon=key,
                label=next(iter(vc)),
                size=len(vals),
                sample_cls=int(sample["cls"]),
                sample_s3=sample["s3"],
                sample_x=sample["x"],
                sample_six=sample["six"],
            )
        )
    return out


def dawson_tables(maxn: int) -> tuple[list[int], list[int]]:
    gp = [0] * (maxn + 1)
    for n in range(1, maxn + 1):
        opts = set()
        for i in range(n):
            left = max(i - 1, 0)
            right = n - (i + 2)
            opts.add(gp[left] ^ gp[max(right, 0)])
        g = 0
        while g in opts:
            g += 1
        gp[n] = g
    gc = [0] * (maxn + 1)
    for n in range(3, maxn + 1):
        opts = {gp[n - 3]}
        g = 0
        while g in opts:
            g += 1
        gc[n] = g
    return gp, gc


def mex(opts: set[int]) -> int:
    g = 0
    while g in opts:
        g += 1
    return g


class PrimeGridGame:
    def __init__(self, q: int):
        self.q = q
        self.inv = {t: inv(q, t) for t in range(1, q)}
        self.full_mask = (1 << (q * q)) - 1
        self.a = (1, 0, 0)
        self.b = (0, 1, 0)
        self.points = [self.a, self.b] + [(r, c, 1) for r in range(q) for c in range(q)]
        self.line_masks = self._build_line_masks()
        self.conic_cell = {t: t * q + self.inv[t] for t in range(1, q)}
        self.cell_param = {v: k for k, v in self.conic_cell.items()}
        self.conic_mask = sum(1 << c for c in self.conic_cell.values())
        self.params: list[int | str] = [INF, 0] + list(range(1, q))
        self.conic_point: dict[int | str, tuple[int, int, int]] = {INF: self.a, 0: self.b}
        self.conic_point.update({t: self.points[self.conic_cell[t] + 2] for t in range(1, q)})
        self.gp, self.gc = dawson_tables(q + 2)

    def _det(self, p: tuple[int, int, int], r: tuple[int, int, int], s: tuple[int, int, int]) -> int:
        q = self.q
        return (
            p[0] * (r[1] * s[2] - r[2] * s[1])
            - p[1] * (r[0] * s[2] - r[2] * s[0])
            + p[2] * (r[0] * s[1] - r[1] * s[0])
        ) % q

    def collinear(self, p: tuple[int, int, int], r: tuple[int, int, int], s: tuple[int, int, int]) -> bool:
        return self._det(p, r, s) == 0

    def _build_line_masks(self) -> list[list[int]]:
        n = len(self.points)
        out = [[0] * n for _ in range(n)]
        aff = self.points[2:]
        for i in range(n):
            for j in range(i + 1, n):
                mask = 0
                pi, pj = self.points[i], self.points[j]
                for c, p in enumerate(aff):
                    if self.collinear(p, pi, pj):
                        mask |= 1 << c
                out[i][j] = mask
                out[j][i] = mask
        return out

    @staticmethod
    def iter_bits(mask: int):
        while mask:
            bit = mask & -mask
            yield bit, bit.bit_length() - 1
            mask ^= bit

    @lru_cache(maxsize=None)
    def legal_mask(self, mask: int) -> int:
        pts = [0, 1]
        occupied = mask
        for _bit, c in self.iter_bits(mask):
            pts.append(c + 2)
        forbidden = occupied
        for i, pi in enumerate(pts):
            row = self.line_masks[pi]
            for pj in pts[i + 1:]:
                forbidden |= row[pj]
        return self.full_mask & ~forbidden

    @lru_cache(maxsize=None)
    def value(self, mask: int) -> bool:
        moves = self.legal_mask(mask)
        if moves == 0:
            return False
        for bit, _c in self.iter_bits(moves):
            if not self.value(mask | bit):
                return True
        return False

    def cell_tuple(self, c: int) -> tuple[int, int]:
        return divmod(c, self.q)

    def bit_for_cell(self, c: tuple[int, int]) -> int:
        return 1 << (c[0] * self.q + c[1])

    def is_conic_cell(self, c: int) -> bool:
        return c in self.cell_param

    def base_mask(self, t4: tuple[int, ...]) -> int:
        mask = 0
        for t in t4:
            mask |= 1 << self.conic_cell[t]
        return mask

    def sigma(self, xcell: int, s: int | str) -> int | str:
        x = self.points[xcell + 2]
        p = self.conic_point[s]
        hits = [t for t in self.params if self.collinear(x, p, self.conic_point[t])]
        if len(hits) == 1:
            assert hits[0] == s
            return s
        assert len(hits) == 2 and s in hits, (self.q, xcell, s, hits)
        return hits[0] if hits[1] == s else hits[1]

    def sigma_perm(self, xcell: int) -> dict[int | str, int | str]:
        return {s: self.sigma(xcell, s) for s in self.params}

    def prod_order(self, pa: dict[int | str, int | str], pb: dict[int | str, int | str]) -> int:
        from math import gcd
        comp = {s: pa[pb[s]] for s in self.params}
        order = 1
        seen = set()
        for s in self.params:
            if s in seen:
                continue
            t = s
            n = 0
            while True:
                seen.add(t)
                t = comp[t]
                n += 1
                if t == s:
                    break
            order = order * n // gcd(order, n)
        return order

    def spectrum(self, live: frozenset[int], sigmas: list[dict[int | str, int | str]]) -> tuple[tuple[str, int], ...]:
        adj = {s: set() for s in live}
        for sg in sigmas:
            for s in live:
                t = sg[s]
                if t != s and t in live:
                    adj[s].add(t)
        comps = []
        seen = set()
        for s in live:
            if s in seen:
                continue
            stack = [s]
            comp = set()
            while stack:
                u = stack.pop()
                if u in comp:
                    continue
                comp.add(u)
                seen.add(u)
                stack.extend(adj[u] - comp)
            edges = sum(len(adj[u] & comp) for u in comp) // 2
            n = len(comp)
            if edges == n:
                comps.append(("cycle", n))
            elif edges == n - 1:
                comps.append(("path", n))
            else:
                comps.append(("bad", n))
        return tuple(sorted(comps))

    def dawson_xor(self, comps: tuple[tuple[str, int], ...]) -> int:
        out = 0
        for kind, n in comps:
            if kind == "path":
                out ^= self.gp[n]
            elif kind == "cycle":
                out ^= self.gc[n]
            else:
                out ^= 999999
        return out

    def zone_graph(self, mask: int) -> tuple[list[int], list[int], int]:
        zone = [c for _bit, c in self.iter_bits(self.legal_mask(mask) & ~self.conic_mask)]
        n = len(zone)
        adj = [0] * n
        edges = 0
        for i, z in enumerate(zone):
            live_after = self.legal_mask(mask | (1 << z))
            for j in range(i + 1, n):
                w = zone[j]
                if not (live_after & (1 << w)):
                    adj[i] |= 1 << j
                    adj[j] |= 1 << i
                    edges += 1
        return zone, adj, edges

    def nk_grundy(self, adj: list[int]) -> int:
        n = len(adj)

        @lru_cache(maxsize=None)
        def g(mask: int) -> int:
            if mask == 0:
                return 0
            opts = set()
            bits = mask
            while bits:
                bit = bits & -bits
                i = bit.bit_length() - 1
                opts.add(g(mask & ~(bit | adj[i])))
                bits ^= bit
            return mex(opts)

        return g((1 << n) - 1)

    def state_features(self, mask: int, intruders: tuple[int, ...]) -> dict[str, object]:
        legal = self.legal_mask(mask)
        live = frozenset(t for t, c in self.conic_cell.items() if legal & (1 << c))
        sigmas = [self.sigma_perm(x) for x in intruders]
        comps = self.spectrum(live, sigmas)
        zone, adj, edges = self.zone_graph(mask)
        return {
            "spectrum": comps,
            "defxor": self.dawson_xor(comps),
            "zone_size": len(zone),
            "zone_edges": edges,
            "zone_grundy": self.nk_grundy(adj),
        }


@dataclass
class BucketResult:
    q: int
    canon: str
    feat_label: str
    computed_label: str
    size: int
    t4: tuple[int, ...]
    intruders: int
    intruder_values: dict[str, int]
    s4_win_move_kind: dict[str, int]
    kill_size_values: dict[str, dict[str, int]]
    type_values: dict[str, dict[str, int]]
    n_child_reply_counts: dict[str, int]
    win_reply_kind: dict[str, int]
    win_reply_order: dict[str, int]
    p_reply_states: int
    necessity_violation_count: int
    necessity_violations: list[dict[str, object]]
    zero_even_value_by_zoneg: dict[str, dict[str, int]]
    zero_even_value_by_zone_size: dict[str, dict[str, int]]
    max_zone_size: int
    seconds: float


def counter_to_dict(c: Counter) -> dict[str, int]:
    return {str(k): v for k, v in sorted(c.items(), key=lambda kv: str(kv[0]))}


def nested_counter_to_dict(d: dict[object, Counter]) -> dict[str, dict[str, int]]:
    return {str(k): counter_to_dict(v) for k, v in sorted(d.items(), key=lambda kv: str(kv[0]))}


def analyze_bucket(game: PrimeGridGame, bucket: Bucket, state_out=None) -> BucketResult:
    start = time.time()
    t4 = tuple(sorted(x for x in bucket.sample_six if x not in (INF, 0)))
    assert len(t4) == 4 and all(isinstance(x, int) and x != 0 for x in t4), bucket
    base = game.base_mask(t4)
    base_value = game.value(base)
    computed_label = "N" if base_value else "P"
    if computed_label != bucket.label:
        raise SystemExit(
            f"label mismatch q={bucket.q} canon={bucket.canon}: "
            f"feat={bucket.label} computed={computed_label} t4={t4}"
        )

    legal0 = game.legal_mask(base)
    s4_win_move_kind = Counter()
    if base_value:
        for _bit, m in game.iter_bits(legal0):
            if not game.value(base | (1 << m)):
                s4_win_move_kind["conic" if game.is_conic_cell(m) else "intruder"] += 1
    intruders = [c for _bit, c in game.iter_bits(legal0 & ~game.conic_mask)]
    played_params = frozenset((INF, 0, *t4))
    intruder_values = Counter()
    kill_size_values: dict[int, Counter] = defaultdict(Counter)
    type_values: dict[tuple[int, int, int], Counter] = defaultdict(Counter)
    n_child_reply_counts = Counter()
    win_reply_kind = Counter()
    win_reply_order = Counter()
    necessity_violations: list[dict[str, object]] = []
    zero_even_by_zoneg: dict[int, Counter] = defaultdict(Counter)
    zero_even_by_zone_size: dict[int, Counter] = defaultdict(Counter)
    p_reply_states = 0
    necessity_violation_count = 0
    max_zone_size = 0

    for x in intruders:
        xbit = 1 << x
        child = base | xbit
        child_value = game.value(child)
        vlabel = "N" if child_value else "P"
        intruder_values[vlabel] += 1
        sx = game.sigma_perm(x)
        tau_x = sum(1 for s in game.params if sx[s] == s)
        tau_played = sum(1 for s in played_params if sx[s] == s)
        m_parity = ((game.q - 11 + tau_x) // 2) & 1
        type_values[(tau_x, tau_played, m_parity)][vlabel] += 1
        rem_conic = set(t for t in range(1, game.q) if t not in t4)
        live_after_x = {
            t for t in rem_conic
            if game.legal_mask(child) & (1 << game.conic_cell[t])
        }
        kill_size = len(rem_conic) - len(live_after_x)
        kill_size_values[kill_size][vlabel] += 1
        if not child_value:
            continue

        replies = [c for _bit, c in game.iter_bits(game.legal_mask(child))]
        n_child_reply_counts[len(replies)] += 1
        for y in replies:
            ybit = 1 << y
            state = child | ybit
            state_value = game.value(state)
            intrs = (x,) if game.is_conic_cell(y) else (x, y)
            feats = game.state_features(state, intrs)
            order = None if game.is_conic_cell(y) else game.prod_order(sx, game.sigma_perm(y))
            max_zone_size = max(max_zone_size, int(feats["zone_size"]))
            state_label = "N" if state_value else "P"
            if state_out is not None:
                state_out.write(json.dumps(
                    {
                        "q": bucket.q,
                        "canon": repr(bucket.canon),
                        "bucket_label": bucket.label,
                        "bucket_size": bucket.size,
                        "t4": t4,
                        "x": game.cell_tuple(x),
                        "x_child_value": vlabel,
                        "tau_x": tau_x,
                        "tau_played": tau_played,
                        "m_parity": m_parity,
                        "kill_size": kill_size,
                        "y": game.cell_tuple(y),
                        "y_kind": "conic" if game.is_conic_cell(y) else "intruder",
                        "order": order,
                        "reply_state_value": state_label,
                        "winning_reply": not state_value,
                        "spectrum": feats["spectrum"],
                        "defxor": feats["defxor"],
                        "zone_size": feats["zone_size"],
                        "zone_edges": feats["zone_edges"],
                        "zone_grundy": feats["zone_grundy"],
                    },
                    sort_keys=True,
                ) + "\n")
            if feats["defxor"] == 0 and int(feats["zone_size"]) % 2 == 0:
                zero_even_by_zoneg[feats["zone_grundy"]][state_label] += 1
                zero_even_by_zone_size[feats["zone_size"]][state_label] += 1
            if not state_value:
                p_reply_states += 1
                if feats["defxor"] != 0 or int(feats["zone_size"]) % 2 != 0:
                    necessity_violation_count += 1
                    if len(necessity_violations) < 10:
                        necessity_violations.append(
                            {
                                "x": game.cell_tuple(x),
                                "y": game.cell_tuple(y),
                                "y_kind": "conic" if game.is_conic_cell(y) else "intruder",
                                "defxor": feats["defxor"],
                                "zone_size": feats["zone_size"],
                                "zone_edges": feats["zone_edges"],
                                "zone_grundy": feats["zone_grundy"],
                                "spectrum": feats["spectrum"],
                            }
                        )
                if game.is_conic_cell(y):
                    win_reply_kind["conic"] += 1
                else:
                    win_reply_kind["intruder"] += 1
                    win_reply_order[order] += 1

    return BucketResult(
        q=bucket.q,
        canon=repr(bucket.canon),
        feat_label=bucket.label,
        computed_label=computed_label,
        size=bucket.size,
        t4=t4,
        intruders=len(intruders),
        intruder_values=counter_to_dict(intruder_values),
        s4_win_move_kind=counter_to_dict(s4_win_move_kind),
        kill_size_values=nested_counter_to_dict(kill_size_values),
        type_values=nested_counter_to_dict(type_values),
        n_child_reply_counts=counter_to_dict(n_child_reply_counts),
        win_reply_kind=counter_to_dict(win_reply_kind),
        win_reply_order=counter_to_dict(win_reply_order),
        p_reply_states=p_reply_states,
        necessity_violation_count=necessity_violation_count,
        necessity_violations=necessity_violations,
        zero_even_value_by_zoneg=nested_counter_to_dict(zero_even_by_zoneg),
        zero_even_value_by_zone_size=nested_counter_to_dict(zero_even_by_zone_size),
        max_zone_size=max_zone_size,
        seconds=time.time() - start,
    )


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("logs", nargs="+")
    ap.add_argument("--qs", default="13,17")
    ap.add_argument("--limit-buckets", type=int, default=None)
    ap.add_argument("--json-out")
    ap.add_argument("--states-jsonl")
    args = ap.parse_args()

    want_q = {int(x) for x in args.qs.split(",") if x}
    buckets = [b for b in parse_logs(args.logs) if b.q in want_q]
    if args.limit_buckets is not None:
        buckets = buckets[: args.limit_buckets]
    print(f"loaded buckets={len(buckets)} qs={sorted(want_q)}")
    by_q = Counter(b.q for b in buckets)
    labels = Counter((b.q, b.label) for b in buckets)
    print(f"bucket counts by q={dict(sorted(by_q.items()))} labels={dict(sorted(labels.items()))}")

    games: dict[int, PrimeGridGame] = {}
    results = []
    state_out = open(args.states_jsonl, "w", encoding="utf-8") if args.states_jsonl else None
    try:
        for idx, bucket in enumerate(buckets, 1):
            game = games.setdefault(bucket.q, PrimeGridGame(bucket.q))
            print(
                f"BUCKET {idx}/{len(buckets)} q={bucket.q} label={bucket.label} "
                f"size={bucket.size} canon={bucket.canon} sample_six={bucket.sample_six}",
                flush=True,
            )
            res = analyze_bucket(game, bucket, state_out=state_out)
            results.append(res)
            print(
                f"  done {res.seconds:.2f}s intruders={res.intruders} values={res.intruder_values} "
                f"P_reply_states={res.p_reply_states} necessity_violations={res.necessity_violation_count} "
                f"max_zone={res.max_zone_size}",
                flush=True,
            )
            print(f"  zero_even_by_zoneg={res.zero_even_value_by_zoneg}", flush=True)
    finally:
        if state_out is not None:
            state_out.close()
            print(f"wrote {args.states_jsonl}")

    total_viol = sum(r.necessity_violation_count for r in results)
    print(f"SUMMARY buckets={len(results)} necessity_violations={total_viol}")
    for q in sorted({r.q for r in results}):
        rows = [r for r in results if r.q == q]
        print(f"SUMMARY q={q} buckets={len(rows)} labels={Counter(r.feat_label for r in rows)}")

    if args.json_out:
        with open(args.json_out, "w", encoding="utf-8") as f:
            json.dump([asdict(r) for r in results], f, indent=2, sort_keys=True)
        print(f"wrote {args.json_out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
