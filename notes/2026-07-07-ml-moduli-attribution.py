#!/usr/bin/env python3
"""C18 feature attribution for on-conic PGL(2,q) orbit buckets.

Inputs are `gridcap feat q` logs for q in {11,13,17,19}.  The script rebuilds
the on-conic six-set buckets, computes interpretable arithmetic/moduli
features, and runs small standard-library classifiers on the required splits.
"""

from __future__ import annotations

import ast
import itertools as it
import math
import re
import sys
from collections import Counter, defaultdict
from dataclasses import dataclass
from functools import lru_cache
from typing import Callable


X_RE = re.compile(r"^X q=(\d+) cls=(\d+) x=(\d+),(\d+) val=([PN]) pos=(\w+)$")
CLS_RE = re.compile(r"^CLS q=(\d+) cls=(\d+) S3=(\[.*\]) escape=")
SUMMARY_RE = re.compile(r"^FEAT-SUMMARY q=(\d+) root=(.*?) size3-classes=(\d+) sanity=(\w+)$")


@dataclass
class Bucket:
    q: int
    canon: tuple[int, ...]
    label: str
    size: int
    sample_cls: int
    sample_s3: tuple[tuple[int, int], ...]
    sample_x: tuple[int, int]
    sample_six: tuple[int, ...]
    features: dict[str, float]


def inv(q: int, x: int) -> int:
    return pow(x % q, q - 2, q)


def legendre(q: int, x: int) -> int:
    x %= q
    if x == 0:
        return 0
    y = pow(x, (q - 1) // 2, q)
    return 1 if y == 1 else -1


def nu2(n: int) -> int:
    out = 0
    while n and n % 2 == 0:
        out += 1
        n //= 2
    return out


def prime_factors(n: int) -> list[int]:
    out = []
    d = 2
    while d * d <= n:
        if n % d == 0:
            out.append(d)
            while n % d == 0:
                n //= d
        d += 1
    if n > 1:
        out.append(n)
    return out


def mult_order(q: int, x: int) -> int:
    x %= q
    if x == 0:
        return 0
    y = 1
    for k in range(1, q):
        y = (y * x) % q
        if y == 1:
            return k
    raise AssertionError((q, x))


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


def six_set(q: int, s3: list[tuple[int, int]], x: tuple[int, int]) -> tuple[int, ...]:
    eps, zeta, gamma, rho, a_param, b_param = conic_params(q, s3)
    pts = [q, 0]  # q is the infinity sentinel.
    for r, c in list(s3) + [x]:
        assert fval(q, eps, zeta, gamma, r, c) == 0
        t = (r - rho) % q
        assert t != 0
        assert (c - a_param) % q == (b_param * inv(q, t)) % q
        pts.append(t)
    assert len(set(pts)) == 6
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


def point_vec(q: int, x: int) -> tuple[int, int]:
    return (1, 0) if x == q else (x % q, 1)


def det2(q: int, p: int, r: int) -> int:
    px, py = point_vec(q, p)
    rx, ry = point_vec(q, r)
    return (px * ry - py * rx) % q


def cross_ratio(q: int, a: int, b: int, c: int, d: int) -> int:
    num = det2(q, a, c) * det2(q, b, d)
    den = det2(q, a, d) * det2(q, b, c)
    den %= q
    assert den != 0
    return (num * inv(q, den)) % q


def cr_orbit(q: int, lam: int) -> tuple[int, ...]:
    vals = {
        lam % q,
        inv(q, lam),
        (1 - lam) % q,
        inv(q, (1 - lam) % q),
        ((lam - 1) * inv(q, lam)) % q,
        (lam * inv(q, (lam - 1) % q)) % q,
    }
    vals.discard(0)
    return tuple(sorted(vals))


def mat_norm(q: int, m: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    m = tuple(v % q for v in m)
    first = next((v for v in m if v), None)
    if first is None:
        raise AssertionError("zero matrix")
    scale = inv(q, first)
    return tuple((v * scale) % q for v in m)


def mat_mul(q: int, a: tuple[int, int, int, int], b: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    a00, a01, a10, a11 = a
    b00, b01, b10, b11 = b
    return mat_norm(
        q,
        (
            a00 * b00 + a01 * b10,
            a00 * b01 + a01 * b11,
            a10 * b00 + a11 * b10,
            a10 * b01 + a11 * b11,
        ),
    )


def mat_inv(q: int, m: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    a, b, c, d = m
    det = (a * d - b * c) % q
    assert det != 0
    scale = inv(q, det)
    return mat_norm(q, (d * scale, -b * scale, -c * scale, a * scale))


def vanish_row(q: int, x: int) -> tuple[int, int]:
    vx, vy = point_vec(q, x)
    return (vy % q, (-vx) % q)


def split_involution(q: int, a: int, b: int) -> tuple[int, int, int, int]:
    # M sends a -> 0 and b -> infinity; conjugate z -> -z back.
    n0, n1 = vanish_row(q, a)
    d0, d1 = vanish_row(q, b)
    m = mat_norm(q, (n0, n1, d0, d1))
    diag = mat_norm(q, (-1, 0, 0, 1))
    return mat_mul(q, mat_inv(q, m), mat_mul(q, diag, m))


def pgl_order(q: int, m: tuple[int, int, int, int]) -> int:
    ident = mat_norm(q, (1, 0, 0, 1))
    cur = ident
    cap = q * q + q + 2
    for k in range(1, cap + 1):
        cur = mat_mul(q, cur, m)
        if cur == ident:
            return k
    raise AssertionError((q, m, cur))


def element_type(q: int, m: tuple[int, int, int, int]) -> str:
    a, b, c, d = m
    disc = ((a + d) * (a + d) - 4 * (a * d - b * c)) % q
    chi = legendre(q, disc)
    if chi == 0:
        return "parabolic"
    if chi == 1:
        return "split"
    return "nonsplit"


def pair_char_counts(q: int, pts: tuple[int, ...]) -> Counter:
    out = Counter()
    for a, b in it.combinations(pts, 2):
        if a == q or b == q:
            finite = b if a == q else a
            out[f"pair_inf_chi_{legendre(q, finite)}"] += 1
        else:
            out[f"pair_diff_chi_{legendre(q, a - b)}"] += 1
    return out


def bucket_features(q: int, canon_key: tuple[int, ...], size: int) -> dict[str, float]:
    feats: dict[str, float] = {}
    feats["q"] = q
    feats["q_mod_3"] = q % 3
    feats["q_mod_4"] = q % 4
    feats["q_mod_8"] = q % 8
    feats["q_mod_12"] = q % 12
    feats["q_mod4_eq_1"] = 1 if q % 4 == 1 else 0
    feats["q_mod4_eq_3"] = 1 if q % 4 == 3 else 0
    feats["nu2_q_minus_1"] = nu2(q - 1)
    feats["nu2_q_plus_1"] = nu2(q + 1)
    feats["num_pf_q_minus_1"] = len(prime_factors(q - 1))
    feats["num_pf_q_plus_1"] = len(prime_factors(q + 1))
    feats["orbit_size"] = size
    feats["stabilizer_size"] = len(pgl_maps(q)) // size

    finite = [x for x in canon_key if x != q]
    char_vals = Counter(legendre(q, x) for x in finite)
    for key in [-1, 0, 1]:
        feats[f"point_chi_{key}"] = char_vals[key]
    feats.update(pair_char_counts(q, canon_key))
    for key in ["pair_inf_chi_-1", "pair_inf_chi_0", "pair_inf_chi_1", "pair_diff_chi_-1", "pair_diff_chi_1"]:
        feats.setdefault(key, 0)

    crs = []
    for quad in it.combinations(canon_key, 4):
        lam = cross_ratio(q, *quad)
        crs.append(min(cr_orbit(q, lam)))
    cr_counter = Counter(legendre(q, x) for x in crs)
    for key in [-1, 0, 1]:
        feats[f"cr_chi_{key}"] = cr_counter[key]
    cr_orders = [mult_order(q, x) for x in crs if x % q]
    feats["cr_order_min"] = min(cr_orders)
    feats["cr_order_max"] = max(cr_orders)
    feats["cr_order_sum"] = sum(cr_orders)
    feats["cr_order_even"] = sum(1 for x in cr_orders if x % 2 == 0)
    feats["cr_order_div3"] = sum(1 for x in cr_orders if x % 3 == 0)
    feats["cr_eq_minus1"] = sum(1 for x in crs if x == q - 1)
    feats["cr_eq_2"] = sum(1 for x in crs if x == 2 % q)
    feats["cr_eq_half"] = sum(1 for x in crs if x == inv(q, 2))

    involutions = [split_involution(q, a, b) for a, b in it.combinations(canon_key, 2)]
    orders = []
    types = Counter()
    gcd_qm = []
    gcd_qp = []
    for s, t in it.combinations(involutions, 2):
        prod = mat_mul(q, s, t)
        order = pgl_order(q, prod)
        orders.append(order)
        types[element_type(q, prod)] += 1
        gcd_qm.append(math.gcd(order, q - 1))
        gcd_qp.append(math.gcd(order, q + 1))
    feats["invprod_order_min"] = min(orders)
    feats["invprod_order_max"] = max(orders)
    feats["invprod_order_sum"] = sum(orders)
    feats["invprod_order_mean_x100"] = round(100 * sum(orders) / len(orders), 3)
    for k in [2, 3, 4, 5, 6, 8, 9, 10]:
        feats[f"invprod_order_eq_{k}"] = sum(1 for x in orders if x == k)
        feats[f"invprod_order_div_{k}"] = sum(1 for x in orders if x % k == 0)
    feats["invprod_split"] = types["split"]
    feats["invprod_nonsplit"] = types["nonsplit"]
    feats["invprod_parabolic"] = types["parabolic"]
    feats["invprod_gcd_qm_sum"] = sum(gcd_qm)
    feats["invprod_gcd_qp_sum"] = sum(gcd_qp)
    feats["invprod_div_qm"] = sum(1 for x in orders if (q - 1) % x == 0)
    feats["invprod_div_qp"] = sum(1 for x in orders if (q + 1) % x == 0)
    return feats


def parse_logs(paths: list[str]) -> list[Bucket]:
    s3_by_q_cls: dict[tuple[int, int], list[tuple[int, int]]] = {}
    pending: dict[tuple[int, int], list[tuple[tuple[int, int], str]]] = defaultdict(list)
    summaries: dict[int, str] = {}
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
                    continue
                m = SUMMARY_RE.match(line)
                if m:
                    q, root, ncls, sanity = m.groups()
                    summaries[int(q)] = f"root={root} size3-classes={ncls} sanity={sanity}"
    rows_by_bucket: dict[tuple[int, tuple[int, ...]], list[dict[str, object]]] = defaultdict(list)
    for (q, ci), xs in pending.items():
        s3 = s3_by_q_cls[(q, ci)]
        for x, val in xs:
            six = six_set(q, s3, x)
            rows_by_bucket[(q, canon(q, six))].append(
                {
                    "q": q,
                    "cls": ci,
                    "s3": tuple(s3),
                    "x": x,
                    "val": val,
                    "six": six,
                }
            )
    buckets = []
    for (q, key), vals in sorted(rows_by_bucket.items()):
        vc = Counter(v["val"] for v in vals)
        if len(vc) != 1:
            raise SystemExit(f"mixed bucket q={q} canon={key} values={dict(vc)}")
        sample = vals[0]
        buckets.append(
            Bucket(
                q=q,
                canon=key,
                label=next(iter(vc)),
                size=len(vals),
                sample_cls=int(sample["cls"]),
                sample_s3=sample["s3"],
                sample_x=sample["x"],
                sample_six=sample["six"],
                features=bucket_features(q, key, len(vals)),
            )
        )
    for q in sorted(summaries):
        _ = summaries[q]
    return buckets


def yval(b: Bucket) -> int:
    return 1 if b.label == "N" else 0


def accuracy(rows: list[Bucket], pred: Callable[[Bucket], int]) -> tuple[int, int, float]:
    good = sum(1 for r in rows if pred(r) == yval(r))
    return good, len(rows), good / len(rows) if rows else 0.0


def confusion(rows: list[Bucket], pred: Callable[[Bucket], int]) -> str:
    c = Counter((yval(r), pred(r)) for r in rows)
    return f"TP={c[(1,1)]} TN={c[(0,0)]} FP={c[(0,1)]} FN={c[(1,0)]}"


def feature_names(rows: list[Bucket]) -> list[str]:
    names = sorted({k for r in rows for k in r.features})
    return [n for n in names if len({r.features.get(n, 0.0) for r in rows}) > 1]


@dataclass
class Split:
    feat: str
    thresh: float

    def __call__(self, b: Bucket) -> bool:
        return b.features.get(self.feat, 0.0) <= self.thresh

    def text(self) -> str:
        return f"{self.feat} <= {self.thresh:g}"


def candidate_splits(rows: list[Bucket], names: list[str]) -> list[Split]:
    splits = []
    for name in names:
        vals = sorted(set(float(r.features.get(name, 0.0)) for r in rows))
        if len(vals) <= 1:
            continue
        for a, b in zip(vals, vals[1:]):
            splits.append(Split(name, (a + b) / 2))
    return splits


def majority(rows: list[Bucket]) -> int:
    c = Counter(yval(r) for r in rows)
    return 1 if c[1] > c[0] else 0


@dataclass
class Tree:
    pred: int | None = None
    split: Split | None = None
    left: "Tree | None" = None
    right: "Tree | None" = None

    def classify(self, b: Bucket) -> int:
        if self.pred is not None:
            return self.pred
        assert self.split and self.left and self.right
        return self.left.classify(b) if self.split(b) else self.right.classify(b)

    def describe(self, indent: str = "") -> list[str]:
        if self.pred is not None:
            return [indent + ("N" if self.pred else "P")]
        assert self.split and self.left and self.right
        lines = [indent + f"if {self.split.text()}:"]
        lines += self.left.describe(indent + "  ")
        lines.append(indent + "else:")
        lines += self.right.describe(indent + "  ")
        return lines


def gini(rows: list[Bucket]) -> float:
    if not rows:
        return 0.0
    c = Counter(yval(r) for r in rows)
    return 1.0 - sum((v / len(rows)) ** 2 for v in c.values())


def build_tree(rows: list[Bucket], names: list[str], depth: int) -> Tree:
    labels = {yval(r) for r in rows}
    if depth == 0 or len(labels) == 1 or len(rows) <= 1:
        return Tree(pred=majority(rows))
    best = None
    for split in candidate_splits(rows, names):
        left = [r for r in rows if split(r)]
        right = [r for r in rows if not split(r)]
        if not left or not right:
            continue
        score = (len(left) * gini(left) + len(right) * gini(right)) / len(rows)
        if best is None or score < best[0]:
            best = (score, split, left, right)
    if best is None:
        return Tree(pred=majority(rows))
    _, split, left, right = best
    return Tree(split=split, left=build_tree(left, names, depth - 1), right=build_tree(right, names, depth - 1))


def best_rule(rows: list[Bucket], test: list[Bucket], names: list[str]) -> list[str]:
    splits = candidate_splits(rows, names)
    scored = []
    for split in splits:
        for true_pred in [0, 1]:
            false_pred = 1 - true_pred
            pred = lambda b, s=split, tp=true_pred, fp=false_pred: tp if s(b) else fp
            tr = accuracy(rows, pred)
            te = accuracy(test, pred)
            scored.append((tr[2], te[2], split.text(), true_pred, false_pred, tr, te))
    scored.sort(reverse=True)
    out = []
    for tr_acc, te_acc, text, tp, fp, tr, te in scored[:8]:
        out.append(
            f"{text} -> true:{'N' if tp else 'P'} false:{'N' if fp else 'P'} "
            f"train={tr[0]}/{tr[1]} test={te[0]}/{te[1]}"
        )
    return out


def symbolic_pairs(rows: list[Bucket], test: list[Bucket], names: list[str]) -> list[str]:
    base = candidate_splits(rows, names)
    unary = []
    for split in base:
        pred = lambda b, s=split: 1 if s(b) else 0
        tr = accuracy(rows, pred)
        unary.append((tr[2], split))
    top = [s for _, s in sorted(unary, key=lambda item: (item[0], item[1].text()), reverse=True)[:30]]
    scored = []
    for a, b in it.combinations(top, 2):
        for op in ["and", "or"]:
            for true_pred in [0, 1]:
                false_pred = 1 - true_pred
                def pred(row: Bucket, aa=a, bb=b, oo=op, tp=true_pred, fp=false_pred) -> int:
                    val = aa(row) and bb(row) if oo == "and" else aa(row) or bb(row)
                    return tp if val else fp
                tr = accuracy(rows, pred)
                te = accuracy(test, pred)
                scored.append((tr[2], te[2], a.text(), op, b.text(), true_pred, false_pred, tr, te))
    scored.sort(reverse=True)
    out = []
    for _tr_acc, _te_acc, at, op, bt, tp, fp, tr, te in scored[:8]:
        out.append(
            f"({at}) {op} ({bt}) -> true:{'N' if tp else 'P'} false:{'N' if fp else 'P'} "
            f"train={tr[0]}/{tr[1]} test={te[0]}/{te[1]}"
        )
    return out


def logistic_l1(rows: list[Bucket], test: list[Bucket], names: list[str]) -> list[str]:
    # Pure-Python proximal-gradient logistic regression.  This is deliberately
    # small and deterministic; it is a sanity check, not a production optimizer.
    means = {}
    scales = {}
    for name in names:
        vals = [float(r.features.get(name, 0.0)) for r in rows]
        mu = sum(vals) / len(vals)
        var = sum((v - mu) ** 2 for v in vals) / len(vals)
        sd = math.sqrt(var) or 1.0
        means[name] = mu
        scales[name] = sd

    def vec(row: Bucket) -> list[float]:
        return [(float(row.features.get(name, 0.0)) - means[name]) / scales[name] for name in names]

    x_train = [vec(r) for r in rows]
    y_train = [yval(r) for r in rows]
    x_test = [vec(r) for r in test]

    best = None
    for lam in [0.0, 0.001, 0.01, 0.03, 0.1, 0.3, 1.0]:
        w = [0.0] * len(names)
        bias = math.log((sum(y_train) + 0.5) / (len(y_train) - sum(y_train) + 0.5))
        lr = 0.05
        for _ in range(2500):
            gb = 0.0
            gw = [0.0] * len(names)
            for x, y in zip(x_train, y_train):
                z = bias + sum(wi * xi for wi, xi in zip(w, x))
                p = 1.0 / (1.0 + math.exp(-max(-40.0, min(40.0, z))))
                e = p - y
                gb += e
                for i, xi in enumerate(x):
                    gw[i] += e * xi
            bias -= lr * gb / len(rows)
            for i in range(len(w)):
                z = w[i] - lr * gw[i] / len(rows)
                shrink = lr * lam
                if z > shrink:
                    w[i] = z - shrink
                elif z < -shrink:
                    w[i] = z + shrink
                else:
                    w[i] = 0.0
        def pred_from_x(x: list[float], ww=w, bb=bias) -> int:
            z = bb + sum(wi * xi for wi, xi in zip(ww, x))
            return 1 if z >= 0 else 0
        train_pred = lambda r, ww=w, bb=bias: pred_from_x(vec(r), ww, bb)
        test_pred = lambda r, ww=w, bb=bias: pred_from_x(vec(r), ww, bb)
        tr = accuracy(rows, train_pred)
        te = accuracy(test, test_pred)
        nnz = sum(1 for x in w if abs(x) > 1e-7)
        key = (te[2], tr[2], -nnz)
        if best is None or key > best[0]:
            best = (key, lam, w, bias, tr, te, nnz)
    assert best is not None
    _, lam, w, _bias, tr, te, nnz = best
    coeffs = sorted(((abs(v), v, n) for v, n in zip(w, names) if abs(v) > 1e-7), reverse=True)[:8]
    out = [f"lambda={lam:g} nonzero={nnz} train={tr[0]}/{tr[1]} test={te[0]}/{te[1]}"]
    out += [f"  {name}: {coef:.4f}" for _abs, coef, name in coeffs]
    return out


def split_report(name: str, train_qs: set[int], buckets: list[Bucket], names: list[str]) -> list[str]:
    train = [b for b in buckets if b.q in train_qs]
    test = [b for b in buckets if b.q not in train_qs]
    out = [f"## Split {name}", ""]
    out.append(f"train_q={sorted(train_qs)} test_q={sorted(set(b.q for b in test))}")
    maj = majority(train)
    maj_pred = lambda _b, p=maj: p
    out.append(
        f"majority={'N' if maj else 'P'} train={accuracy(train, maj_pred)[0]}/{len(train)} "
        f"test={accuracy(test, maj_pred)[0]}/{len(test)} {confusion(test, maj_pred)}"
    )
    tree = build_tree(train, names, 3)
    tree_pred = lambda b: tree.classify(b)
    out.append("depth3_tree:")
    out += ["  " + line for line in tree.describe()]
    out.append(
        f"tree train={accuracy(train, tree_pred)[0]}/{len(train)} "
        f"test={accuracy(test, tree_pred)[0]}/{len(test)} {confusion(test, tree_pred)}"
    )
    out.append("best_univariate_rules:")
    out += ["  " + x for x in best_rule(train, test, names)]
    out.append("best_symbolic_pair_rules:")
    out += ["  " + x for x in symbolic_pairs(train, test, names)]
    out.append("sparse_logistic_l1:")
    out += ["  " + x for x in logistic_l1(train, test, names)]
    return out


def sklearn_split_report(name: str, train_qs: set[int], buckets: list[Bucket], names: list[str]) -> list[str]:
    import numpy as np
    from sklearn.linear_model import LogisticRegression
    from sklearn.tree import DecisionTreeClassifier, export_text

    train = [b for b in buckets if b.q in train_qs]
    test = [b for b in buckets if b.q not in train_qs]

    def matrix(rows: list[Bucket]):
        return np.array([[float(r.features.get(n, 0.0)) for n in names] for r in rows], dtype=float)

    x_train = matrix(train)
    x_test = matrix(test)
    y_train = np.array([yval(r) for r in train], dtype=int)
    y_test = np.array([yval(r) for r in test], dtype=int)
    mu = x_train.mean(axis=0)
    sigma = x_train.std(axis=0)
    sigma[sigma == 0] = 1.0
    zx_train = (x_train - mu) / sigma
    zx_test = (x_test - mu) / sigma

    out = [f"### sklearn {name}", ""]
    tree = DecisionTreeClassifier(max_depth=3, random_state=0, class_weight="balanced")
    tree.fit(x_train, y_train)
    out.append(
        f"tree train={tree.score(x_train, y_train):.3f} test={tree.score(x_test, y_test):.3f}"
    )
    out += ["  " + line for line in export_text(tree, feature_names=names).splitlines()]

    logit = LogisticRegression(
        penalty="l1",
        solver="liblinear",
        C=1.0,
        class_weight="balanced",
        random_state=0,
        max_iter=1000,
    )
    logit.fit(zx_train, y_train)
    pred = logit.predict(zx_test)
    nz = [(abs(c), c, n) for c, n in zip(logit.coef_[0], names) if abs(c) > 1e-8]
    nz.sort(reverse=True)
    out.append(
        f"l1_logistic train={logit.score(zx_train, y_train):.3f} "
        f"test={logit.score(zx_test, y_test):.3f} nonzero={len(nz)}"
    )
    out += [f"  {n}: {c:.4f}" for _abs, c, n in nz[:10]]
    misses = []
    for row, p in zip(test, pred):
        if int(p) != yval(row):
            misses.append(f"q={row.q} canon={fmt_canon(row.q, row.canon)} label={row.label} pred={'N' if p else 'P'}")
    out.append("misses:")
    out += ["  " + m for m in misses[:20]]
    return out


def sklearn_report(buckets: list[Bucket], names: list[str]) -> list[str]:
    try:
        import numpy  # noqa: F401
        import sklearn  # noqa: F401
    except Exception as exc:
        return ["## sklearn cross-check", "", f"unavailable: {type(exc).__name__}: {exc}"]
    out = ["## sklearn cross-check", ""]
    out += sklearn_split_report("forward", {11, 13}, buckets, names)
    out.append("")
    out += sklearn_split_report("reverse", {17, 19}, buckets, names)
    return out


def fmt_canon(q: int, xs: tuple[int, ...]) -> str:
    return "(" + ",".join("inf" if x == q else str(x) for x in xs) + ")"


def main() -> int:
    args = sys.argv[1:]
    use_sklearn = False
    if args and args[0] == "--sklearn":
        use_sklearn = True
        args = args[1:]
    if len(args) < 1:
        print(f"usage: {sys.argv[0]} [--sklearn] FEAT_LOG...", file=sys.stderr)
        return 2
    buckets = parse_logs(args)
    names = feature_names(buckets)
    print("# C18 ML/moduli attribution output")
    print()
    print(f"buckets={len(buckets)} features={len(names)}")
    print()
    print("## Bucket table")
    print()
    print("| q | canon | size | label | sample_cls | sample_x |")
    print("|---:|---|---:|:---:|---:|---|")
    for b in buckets:
        print(f"| {b.q} | `{fmt_canon(b.q, b.canon)}` | {b.size} | {b.label} | {b.sample_cls} | {b.sample_x} |")
    print()
    print("## Feature ranking")
    print()
    for split_name, train_qs in [("forward", {11, 13}), ("reverse", {17, 19})]:
        train = [b for b in buckets if b.q in train_qs]
        test = [b for b in buckets if b.q not in train_qs]
        print(f"### {split_name} univariate top")
        for line in best_rule(train, test, names)[:12]:
            print("- " + line)
        print()
    print()
    print("\n".join(split_report("forward", {11, 13}, buckets, names)))
    print()
    print("\n".join(split_report("reverse", {17, 19}, buckets, names)))
    print()
    print("## Explicit falsification checks")
    print()
    for q in [13, 17, 19]:
        rows = [b for b in buckets if b.q == q]
        print(f"q={q} labels={dict(Counter(b.label for b in rows))}")
    if use_sklearn:
        print()
        print("\n".join(sklearn_report(buckets, names)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
