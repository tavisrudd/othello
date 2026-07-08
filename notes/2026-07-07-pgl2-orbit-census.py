#!/usr/bin/env python3
"""PGL(2,q) orbit-collapse census for on-conic S4 feat records.

Input is one or more `gridcap feat q` logs for odd prime q.  For each on-conic
size-4 child, the script refits the conic through the size-3 class and the two
directions, recovers the six P1 parameters, buckets by full PGL(2,q) canonical
form, and checks that the game value is constant on each bucket.
"""

from __future__ import annotations

import ast
import re
import sys
from collections import Counter, defaultdict
from functools import lru_cache


X_RE = re.compile(r"^X q=(\d+) cls=(\d+) x=(\d+),(\d+) val=([PN]) pos=(\w+)$")
CLS_RE = re.compile(r"^CLS q=(\d+) cls=(\d+) S3=(\[.*\]) escape=")
SUMMARY_RE = re.compile(r"^FEAT-SUMMARY q=(\d+) root=(.*?) size3-classes=(\d+) sanity=(\w+)$")


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
    rows = []
    for r, c in cells:
        rows.append([r % q, c % q, 1, (-(r * c)) % q])
    eps, zeta, gamma = solve3(q, rows)
    rho = (-zeta) % q
    a_param = (-eps) % q
    b_param = (rho * a_param - gamma) % q
    assert b_param != 0, (q, cells, eps, zeta, gamma, rho, a_param, b_param)
    return eps, zeta, gamma, rho, a_param, b_param


def fval(q: int, eps: int, zeta: int, gamma: int, r: int, c: int) -> int:
    return (r * c + eps * r + zeta * c + gamma) % q


def six_set(q: int, s3: list[tuple[int, int]], x: tuple[int, int]) -> tuple[int, ...]:
    eps, zeta, gamma, rho, a_param, b_param = conic_params(q, s3)
    pts = [q, 0]  # q is the infinity sentinel.
    for r, c in list(s3) + [x]:
        assert fval(q, eps, zeta, gamma, r, c) == 0, (q, s3, x, (r, c), eps, zeta, gamma)
        t = (r - rho) % q
        assert t != 0, (q, s3, x, (r, c), rho)
        assert (c - a_param) % q == (b_param * inv(q, t)) % q, (
            q,
            s3,
            x,
            (r, c),
            rho,
            a_param,
            b_param,
            t,
        )
        pts.append(t)
    assert len(set(pts)) == 6, (q, s3, x, pts)
    return tuple(sorted(pts))


def mobius(q: int, m: tuple[int, int, int, int], x: int) -> int:
    a, b, c, d = m
    if x == q:
        return q if c == 0 else (a * inv(q, c)) % q
    den = (c * x + d) % q
    if den == 0:
        return q
    return ((a * x + b) * inv(q, den)) % q


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


def canon(q: int, s: tuple[int, ...]) -> tuple[int, ...]:
    return min(tuple(sorted(mobius(q, m, x) for x in s)) for m in pgl_maps(q))


def parse(path: str) -> dict[int, dict[str, object]]:
    s3_by_q_cls: dict[tuple[int, int], list[tuple[int, int]]] = {}
    pending: dict[tuple[int, int], list[tuple[tuple[int, int], str]]] = defaultdict(list)
    summaries: dict[int, str] = {}
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            m = X_RE.match(line)
            if m:
                q, ci, r, c, val, pos = m.groups()
                q = int(q)
                ci = int(ci)
                if pos == "on":
                    pending[(q, ci)].append(((int(r), int(c)), val))
                continue
            m = CLS_RE.match(line)
            if m:
                q, ci, s3 = m.groups()
                q = int(q)
                ci = int(ci)
                s3_by_q_cls[(q, ci)] = ast.literal_eval(s3)
                continue
            m = SUMMARY_RE.match(line)
            if m:
                q, root, ncls, sanity = m.groups()
                summaries[int(q)] = f"root={root} size3-classes={ncls} sanity={sanity}"

    rows_by_q: dict[int, list[dict[str, object]]] = defaultdict(list)
    for (q, ci), xs in pending.items():
        s3 = s3_by_q_cls[(q, ci)]
        for x, val in xs:
            six = six_set(q, s3, x)
            rows_by_q[q].append(
                {
                    "cls": ci,
                    "s3": tuple(s3),
                    "x": x,
                    "val": val,
                    "six": six,
                    "canon": canon(q, six),
                }
            )
    return {q: {"rows": rows, "summary": summaries.get(q, "MISSING")} for q, rows in rows_by_q.items()}


def render_q(q: int, rows: list[dict[str, object]], summary: str) -> tuple[str, int]:
    buckets: dict[tuple[int, ...], list[dict[str, object]]] = defaultdict(list)
    for row in rows:
        buckets[row["canon"]].append(row)
    violations = []
    for key, vals in buckets.items():
        vc = Counter(v["val"] for v in vals)
        if len(vc) > 1:
            violations.append((key, vc, vals))

    lines = []
    lines.append(f"q={q}")
    lines.append(f"feat_summary={summary}")
    lines.append(f"pgl_maps={len(pgl_maps(q))}")
    lines.append(f"on_records={len(rows)}")
    lines.append(f"buckets={len(buckets)}")
    lines.append(f"collapse={len(rows)}->{len(buckets)}")
    lines.append(f"bucket_size_hist={dict(sorted(Counter(len(v) for v in buckets.values()).items()))}")
    lines.append(f"value_counts={dict(sorted(Counter(r['val'] for r in rows).items()))}")
    lines.append(f"constant_buckets={len(buckets) - len(violations)}")
    lines.append(f"violations={len(violations)}")
    if violations:
        for idx, (key, vc, vals) in enumerate(violations[:20], 1):
            lines.append(f"VIOLATION {idx} canon={key} values={dict(vc)} size={len(vals)}")
            for row in vals:
                lines.append(
                    f"  cls={row['cls']} S3={list(row['s3'])} x={row['x']} "
                    f"val={row['val']} six={row['six']}"
                )
    else:
        for idx, (key, vals) in enumerate(
            sorted(buckets.items(), key=lambda kv: (len(kv[1]), kv[0]), reverse=True)[:20],
            1,
        ):
            vc = Counter(v["val"] for v in vals)
            sample = vals[0]
            lines.append(f"BUCKET {idx} canon={key} size={len(vals)} values={dict(vc)}")
            lines.append(
                f"  sample cls={sample['cls']} S3={list(sample['s3'])} "
                f"x={sample['x']} six={sample['six']} val={sample['val']}"
            )
    return "\n".join(lines), len(violations)


def main() -> int:
    if len(sys.argv) < 2:
        print(f"usage: {sys.argv[0]} FEAT_LOG...", file=sys.stderr)
        return 2
    parsed: dict[int, dict[str, object]] = {}
    for path in sys.argv[1:]:
        for q, data in parse(path).items():
            if q in parsed:
                raise SystemExit(f"duplicate q={q} input")
            parsed[q] = data
    total_violations = 0
    for q in sorted(parsed):
        text, violations = render_q(q, parsed[q]["rows"], parsed[q]["summary"])
        total_violations += violations
        print(text)
        print()
    print(f"TOTAL_VIOLATIONS={total_violations}")
    return 1 if total_violations else 0


if __name__ == "__main__":
    raise SystemExit(main())
