#!/usr/bin/env python3
"""C77 continuation: game-value structure on C74's one-intruder pencil.

For every maximum-capacity C74 line (minimum product-collision count d), recover
the involution parameter a of each legal off-conic center z_a.  The recovery is
geometric: after sending the distinguished endpoints (F,w) to (0,infinity),
every chord through z_a pairs t with a/t, so transformed chord products agree.

The feature battery is deliberately value-blind and scale-invariant:
  * quadratic character of a;
  * character multiset of a-b over the forbidden product set B=P2(U);
  * multiplicative-order multiset of the ratios a/b, b in B.

Only after those features are built are exact P/N labels joined.  The report
focuses on the mandatory q=11 knife-edge pencils (4P/2N off-conic centers) and
uses all q=11/13/17/19 maximum lines as adversarial controls.
"""
from collections import Counter, defaultdict
from itertools import combinations
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from c73_secant_algebra import (  # noqa: E402
    DATA,
    PRIME_FILES,
    analyze,
    inv,
    parse,
    secant_line_pred,
)
from c74_line_pencil import INF, line_product_data, mobius_zero_inf  # noqa: E402


KNIFE = {11: {4, 7}, 17: {2, 17, 19}}


def chi(x, q):
    x %= q
    if x == 0:
        return 0
    return 1 if pow(x, (q - 1) // 2, q) == 1 else -1


def mul_order(x, q):
    x %= q
    assert x
    y = 1
    for d in range(1, q):
        y = y * x % q
        if y == 1:
            return d
    raise AssertionError((q, x))


def chord_contains(rec, t, u, cell):
    """Whether the affine cell lies on the conic chord through P1 params t,u."""
    q, rho, A, B = rec["q"], rec["rho"], rec["A"], rec["B"]
    if t == INF:
        t, u = u, t
    if t == 0 and u == INF:
        return False  # the burned line at infinity has no affine cell
    if t == 0:
        pred = secant_line_pred(q, rho, A, B, u, "0")
    elif u == INF:
        pred = secant_line_pred(q, rho, A, B, t, "oo")
    else:
        pred = secant_line_pred(q, rho, A, B, t, u)
    return pred(cell)


def center_parameter(rec, key, cell):
    """Recover a in tau_a(t)=a/t from any non-endpoint chords through cell."""
    q = rec["q"]
    F, w = key
    F0 = 0 if F == "0" else F
    points = list(range(q)) + [INF]
    products = set()
    witnesses = 0
    for t, u in combinations(points, 2):
        if t in (F0, w) or u in (F0, w):
            continue
        if not chord_contains(rec, t, u, cell):
            continue
        mt = mobius_zero_inf(t, F0, w, q)
        mu = mobius_zero_inf(u, F0, w, q)
        assert mt not in (0, INF) and mu not in (0, INF)
        products.add(mt * mu % q)
        witnesses += 1
    assert witnesses > 0 and len(products) == 1, (q, rec["cls"], key, cell, products)
    return products.pop()


def features(a, forbidden, q):
    gaps = tuple(sorted(chi(a - b, q) for b in forbidden))
    orders = tuple(sorted(mul_order(a * inv(b, q), q) for b in forbidden))
    return {
        "chi": (chi(a, q),),
        "gap": gaps,
        "chi_gap": (chi(a, q), gaps),
        "orders": orders,
        "all": (chi(a, q), gaps, orders),
    }


def legal_after(q, root, z):
    if any(z[0] == x[0] or z[1] == x[1] for x in root):
        return False
    return all(((b[0] - a[0]) * (z[1] - a[1])
                - (b[1] - a[1]) * (z[0] - a[0])) % q != 0
               for a, b in combinations(root, 2))


def root_support(rec, cell):
    """Value-blind live-conic/off-conic support after selecting one S4 center."""
    q = rec["q"]
    root = rec["S3"] + [cell]
    live_on = zone_v = 0
    for z in ((r, c) for r in range(q) for c in range(q)):
        if not legal_after(q, root, z):
            continue
        on = ((z[0] - rec["rho"]) * (z[1] - rec["A"]) - rec["B"]) % q == 0
        if on:
            live_on += 1
        else:
            zone_v += 1
    return live_on, zone_v


def mobius_preimage(y, F, w, q):
    """Inverse of mobius_zero_inf by exact P1 enumeration (tiny prime-field diagnostic)."""
    if y == INF:
        return w
    for t in list(range(q)) + [INF]:
        if t == w:
            continue
        if mobius_zero_inf(t, F, w, q) == y:
            return t
    raise AssertionError((q, F, w, y))


def on_spoke(rec, e, center, cell):
    """Whether an affine child cell lies on the line through center and frame point e."""
    if e == 0:
        return cell[0] == center[0]
    if e == INF:
        return cell[1] == center[1]
    frame_cell = next(z for z in rec["S3"] if (z[0] - rec["rho"]) % rec["q"] == e)
    return ((frame_cell[0] - center[0]) * (cell[1] - center[1])
            - (frame_cell[1] - center[1]) * (cell[0] - center[0])) % rec["q"] == 0


def spoke_loads(rec, key, a, center):
    """Legal off-conic loads on the five center-to-frame spokes; secants cross-check C74 d."""
    q = rec["q"]
    F, w = key
    F0 = 0 if F == "0" else F
    frame = [0, INF] + rec["tframe"]
    loads = []
    defects = []
    tangents = 0
    for e in frame:
        u = mobius_zero_inf(e, F0, w, q)
        target = INF if u == 0 else a * inv(u, q) % q
        image = mobius_preimage(target, F0, w, q)
        assert image not in frame or image == e, (
            q, rec["cls"], key, a, e, u, target, image, frame
        )
        load = sum(
            pos != "on" and on_spoke(rec, e, center, cell)
            for cell, _value, pos in rec["children"]
        )
        assert load >= 1  # the selected center itself
        if image == e:
            tangents += 1
            defect = q - load
            assert 4 <= defect <= 6, (q, rec["cls"], key, a, e, load, defect)
        else:
            ekey = "0" if e == 0 else e
            _U, _products, d = line_product_data(rec, (ekey, image))
            assert load == q - 1 - d, (q, rec["cls"], key, a, e, image, load, d)
            defect = d
        loads.append(load)
        defects.append(defect)
    return sum(loads), tuple(sorted(loads)), sum(defects), tuple(sorted(defects)), tangents


def rows_for(q):
    recs = analyze(q, parse(os.path.join(DATA, PRIME_FILES[q])))
    rows = []
    pencils = []
    for cls, rec in sorted(recs.items()):
        ds = {key: line_product_data(rec, key)[2] for key in rec["cand"]}
        dmin = min(ds.values())
        for key in sorted((key for key, d in ds.items() if d == dmin), key=str):
            _U, products, d = line_product_data(rec, key)
            forbidden = tuple(sorted(products))
            pencil = []
            for cell, value, pos in rec["cand"][key]["hit"]:
                if pos == "on":
                    continue
                a = center_parameter(rec, key, cell)
                assert a not in products
                row = {
                    "q": q,
                    "cls": cls,
                    "key": key,
                    "d": d,
                    "cell": cell,
                    "a": a,
                    "value": value,
                    "features": features(a, forbidden, q),
                }
                row["live_on"], row["zone_v"] = root_support(rec, cell)
                (row["spoke_load"], row["spoke_loads"], row["spoke_defect"],
                 row["spoke_defects"], row["spoke_tangents"]) = spoke_loads(rec, key, a, cell)
                predicted_zone = (q - 5) ** 2 + 4 - row["spoke_load"]
                collision_zone = q * q - 15 * q + 34 + row["spoke_defect"] - row["spoke_tangents"]
                assert predicted_zone == collision_zone
                assert row["zone_v"] == predicted_zone, (
                    q, cls, key, cell, row["zone_v"], predicted_zone,
                    row["spoke_loads"], row["spoke_tangents"]
                )
                rows.append(row)
                pencil.append(row)
            pencils.append((q, cls, key, d, pencil))
    return rows, pencils


def all_line_lowzone_control(q):
    """Adversarial control: score Low4 on every candidate secant, not only maximum ones."""
    recs = analyze(q, parse(os.path.join(DATA, PRIME_FILES[q])))
    totals = Counter()
    failures = Counter()
    examples = []
    for cls, rec in recs.items():
        ds = {key: line_product_data(rec, key)[2] for key in rec["cand"]}
        dmin = min(ds.values())
        for key, datum in rec["cand"].items():
            centers = []
            for cell, value, pos in datum["hit"]:
                if pos == "on":
                    continue
                _live_on, zone_v = root_support(rec, cell)
                centers.append((zone_v, value))
            if not centers:
                continue
            threshold = sorted(z for z, _value in centers)[min(3, len(centers) - 1)]
            packet = [(z, value) for z, value in centers if z <= threshold]
            tag = "max" if ds[key] == dmin else "other"
            totals[(tag, ds[key])] += 1
            pcount = sum(value == "P" for _z, value in packet)
            if pcount < min(3, len(centers)):
                failures[(tag, ds[key])] += 1
                if len(examples) < 6:
                    examples.append((cls, key, ds[key], len(packet), pcount))
    return totals, failures, examples


def score_feature(name, pencils):
    """Score a selector as: choose every center with a globally P-pure feature value."""
    labels = defaultdict(set)
    for *_head, pencil in pencils:
        for row in pencil:
            labels[row["features"][name]].add(row["value"])
    pure_p = {f for f, values in labels.items() if values == {"P"}}
    covered = sum(any(row["features"][name] in pure_p for row in pencil)
                  for *_head, pencil in pencils)
    mixed = sum(values == {"P", "N"} for values in labels.values())
    return len(pure_p), mixed, covered, len(pencils)


def main():
    qs = [int(x) for x in sys.argv[1:]] or [11, 13, 17, 19]
    all_pencils = []
    for q in qs:
        rows, pencils = rows_for(q)
        all_pencils.extend(pencils)
        hist = Counter((r["value"] for r in rows))
        print(f"SUMMARY q={q} pencils={len(pencils)} centers={len(rows)} values={dict(hist)}")
        pencil_hist = Counter(
            (d,
             sum(r["value"] == "P" for r in pencil),
             sum(r["value"] == "N" for r in pencil))
            for _q, _cls, _key, d, pencil in pencils
        )
        max_n = max(sum(r["value"] == "N" for r in pencil)
                    for *_head, pencil in pencils)
        min_p = min(sum(r["value"] == "P" for r in pencil)
                    for *_head, pencil in pencils)
        print(f"PENCIL-HIST q={q} rows={dict(sorted(pencil_hist.items()))} "
              f"maxN={max_n} minP={min_p}")
        spoke_hist = Counter(
            (r["spoke_defect"] - r["spoke_tangents"], r["spoke_tangents"], r["value"])
            for r in rows
        )
        print(f"SPOKEFORMULA q={q} checked={len(rows)} offroot={(q-5)**2} "
              f"score/tangents/value={dict(sorted(spoke_hist.items()))}")
        if q >= 11:
            print(f"ABSORB q={q} maxN={max_n} bound=q-8={q-8} "
                  f"holds={int(max_n <= q-8)}")
            assert max_n <= q - 8
        lowzone = Counter()
        lowzone_fail = []
        for q0, cls, key, d, pencil in pencils:
            threshold = sorted(r["zone_v"] for r in pencil)[min(3, len(pencil) - 1)]
            packet = [r for r in pencil if r["zone_v"] <= threshold]
            score = (len(packet),
                     sum(r["value"] == "P" for r in packet),
                     sum(r["value"] == "N" for r in packet))
            lowzone[score] += 1
            if score[1] < min(3, len(pencil)):
                lowzone_fail.append((cls, key, score))
            if q == 17 and sum(r["value"] == "N" for r in pencil) == 9:
                layers = Counter(
                    (r["spoke_defect"] - r["spoke_tangents"],
                     r["spoke_tangents"], r["value"])
                    for r in pencil
                )
                expected = Counter({
                    (24, 0, "P"): 1,
                    (26, 0, "P"): 2,
                    (26, 2, "N"): 2,
                    (28, 0, "N"): 7,
                })
                assert layers == expected, (cls, key, layers)
                print(f"TIGHT q=17 cls={cls} key={key} layers={dict(sorted(layers.items()))}")
        print(f"LOWZONE q={q} packet(size,P,N)={dict(sorted(lowzone.items()))} "
              f"threeP-failures={len(lowzone_fail)} examples={lowzone_fail[:4]}")
        balanced_hist = Counter()
        balanced_values = Counter()
        for _q0, _cls, _key, d, pencil in pencils:
            target = tuple(sorted((d, 5, 5, 6, 6)))
            matches = [r for r in pencil if r["spoke_defects"] == target]
            balanced_hist[(d, len(matches))] += 1
            balanced_values.update(r["value"] for r in matches)
            if q >= 11:
                assert matches and all(r["value"] == "P" for r in matches)
        print(f"BALANCED-VALUE q={q} multiplicity={dict(sorted(balanced_hist.items()))} "
              f"values={dict(sorted(balanced_values.items()))}")
        totals, failures, examples = all_line_lowzone_control(q)
        print(f"ALLLINES q={q} totals={dict(sorted(totals.items()))} "
              f"threeP-failures={dict(sorted(failures.items()))} examples={examples}")
        for q0, cls, key, d, pencil in pencils:
            if cls not in KNIFE.get(q, set()):
                continue
            vals = Counter(r["value"] for r in pencil)
            detail = " ".join(
                f"a={r['a']}:{r['value']}:chi={r['features']['chi'][0]}:"
                f"gap={','.join(map(str, r['features']['gap']))}:"
                f"ord={','.join(map(str, r['features']['orders']))}"
                for r in sorted(pencil, key=lambda x: x["a"])
            )
            print(f"KNIFE q={q0} cls={cls} key={key} d={d} values={dict(vals)} {detail}")

    for scope, pencils in (
        ("all", all_pencils),
        ("depleted", [p for p in all_pencils if p[0] in (11, 17)]),
        ("q11-knife", [p for p in all_pencils if p[0] == 11 and p[1] in KNIFE[11]]),
    ):
        for name in ("chi", "gap", "chi_gap", "orders", "all"):
            pure, mixed, covered, total = score_feature(name, pencils)
            print(f"SCORE scope={scope} feature={name} pureP={pure} mixed={mixed} "
                  f"covered={covered}/{total}")


if __name__ == "__main__":
    main()
