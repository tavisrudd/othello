#!/usr/bin/env python3
"""Fixed-q on-conic stabilizer-orbit census propagation probe (C42).

This reuses the conic reconstruction and exact orbit machinery from
onconic_child_type_alignment.py.  For each prime q with an on-disk feat census,
and for each size-3 class, it counts the q-4 on-conic children by exact
burned-pair-stabilizer orbit.  It then reports how much those value-blind census
vectors vary across classes, and how the projection onto that q's P-valued
orbits recovers the onP histograms.

Run from rust/:
    python3 scripts/onconic_census_propagation.py \
        --out-dir s4-dumps/2026-07-09/c42-census
"""

from __future__ import annotations

import argparse
import os
from collections import Counter, defaultdict
from fractions import Fraction

import onconic_child_type_alignment as align


def hist_text(counter: Counter) -> str:
    return ",".join(f"{k}:{counter[k]}" for k in sorted(counter)) or "-"


def sparse_vec(vec: list[int], orbit_ids: list[str]) -> str:
    return ";".join(f"{oid}={n}" for oid, n in zip(orbit_ids, vec) if n) or "-"


def l1(a: tuple[int, ...], b: tuple[int, ...]) -> int:
    return sum(abs(x - y) for x, y in zip(a, b))


def l1_diameter(vecs: list[tuple[int, ...]]) -> int:
    out = 0
    for i in range(len(vecs)):
        for j in range(i + 1, len(vecs)):
            out = max(out, l1(vecs[i], vecs[j]))
    return out


def range_max(vecs: list[tuple[int, ...]]) -> int:
    if not vecs:
        return 0
    return max(max(col) - min(col) for col in zip(*vecs))


def orbit_key_text(key) -> str:
    return ",".join(str(x) for x in key)


def frac_text(x: Fraction) -> str:
    return str(x.numerator) if x.denominator == 1 else f"{x.numerator}/{x.denominator}"


def analyze_q(q: int):
    recs = align.build_records_prime(q, os.path.join(align.DATA, align.FEAT_FILES[q]))
    by_cls: dict[int, list] = defaultdict(list)
    orbit_value = {}
    for rec in recs:
        by_cls[rec.cls].append(rec)
        orbit_value.setdefault(rec.stab_orbit, rec.val)
        assert orbit_value[rec.stab_orbit] == rec.val

    orbits = sorted(orbit_value, key=repr)
    orbit_ids = [f"O{i:02d}" for i in range(len(orbits))]
    orbit_index = {orbit: i for i, orbit in enumerate(orbits)}
    p_indices = [i for i, orbit in enumerate(orbits) if orbit_value[orbit] == "P"]

    classes = []
    full_vecs = []
    p_vecs = []
    onp_hist = Counter()
    for cls in sorted(by_cls):
        vec = [0] * len(orbits)
        s3 = by_cls[cls][0].s3
        for rec in by_cls[cls]:
            vec[orbit_index[rec.stab_orbit]] += 1
        assert sum(vec) == q - 4, (q, cls, sum(vec))
        pvec = [vec[i] for i in p_indices]
        onp = sum(pvec)
        onp_hist[onp] += 1
        full_vecs.append(tuple(vec))
        p_vecs.append(tuple(pvec))
        classes.append({
            "q": q,
            "cls": cls,
            "s3": s3,
            "onp": onp,
            "full_vec": vec,
            "p_vec": pvec,
        })

    return {
        "q": q,
        "recs": recs,
        "classes": classes,
        "orbits": orbits,
        "orbit_ids": orbit_ids,
        "orbit_value": orbit_value,
        "p_indices": p_indices,
        "full_vecs": full_vecs,
        "p_vecs": p_vecs,
        "onp_hist": onp_hist,
        "summary": {
            "classes": len(classes),
            "orbits": len(orbits),
            "p_orbits": len(p_indices),
            "distinct_full": len(set(full_vecs)),
            "full_l1_diam": l1_diameter(full_vecs),
            "full_range_max": range_max(full_vecs),
            "distinct_p": len(set(p_vecs)),
            "p_l1_diam": l1_diameter(p_vecs),
            "p_range_max": range_max(p_vecs),
            "onp_min": min(onp_hist),
            "onp_max": max(onp_hist),
        },
    }


def write_tables(results: list[dict], out_dir: str) -> None:
    os.makedirs(out_dir, exist_ok=True)
    with open(os.path.join(out_dir, "class_vectors.tsv"), "w", encoding="utf-8") as f:
        f.write("q\tcls\ts3\tonP\tfull_vec\tp_vec\n")
        for res in results:
            p_ids = [res["orbit_ids"][i] for i in res["p_indices"]]
            for row in res["classes"]:
                f.write(
                    f"{res['q']}\t{row['cls']}\t{list(row['s3'])}\t{row['onp']}\t"
                    f"{sparse_vec(row['full_vec'], res['orbit_ids'])}\t"
                    f"{sparse_vec(row['p_vec'], p_ids)}\n"
                )

    with open(os.path.join(out_dir, "orbit_ranges.tsv"), "w", encoding="utf-8") as f:
        f.write("q\torbit\tvalue\ttotal\tclass_min\tclass_max\tclass_range\tkey\n")
        for res in results:
            cols = list(zip(*res["full_vecs"]))
            for i, orbit in enumerate(res["orbits"]):
                col = cols[i]
                f.write(
                    f"{res['q']}\t{res['orbit_ids'][i]}\t{res['orbit_value'][orbit]}\t"
                    f"{sum(col)}\t{min(col)}\t{max(col)}\t{max(col)-min(col)}\t"
                    f"{orbit_key_text(orbit)}\n"
                )

    with open(os.path.join(out_dir, "depleted_group_diffs.tsv"), "w", encoding="utf-8") as f:
        f.write("q\torbit\tvalue\tlow_onP\thigh_onP\tlow_classes\thigh_classes\tlow_total\thigh_total\tavg_delta_high_minus_low\tkey\n")
        for res in results:
            q = res["q"]
            if q not in (11, 17):
                continue
            groups: dict[int, list] = defaultdict(list)
            for row in res["classes"]:
                groups[row["onp"]].append(row)
            low = min(groups)
            high = max(groups)
            for i in res["p_indices"]:
                low_total = sum(row["full_vec"][i] for row in groups[low])
                high_total = sum(row["full_vec"][i] for row in groups[high])
                delta = Fraction(high_total, len(groups[high])) - Fraction(low_total, len(groups[low]))
                if delta == 0:
                    continue
                orbit = res["orbits"][i]
                f.write(
                    f"{q}\t{res['orbit_ids'][i]}\t{res['orbit_value'][orbit]}\t"
                    f"{low}\t{high}\t{len(groups[low])}\t{len(groups[high])}\t"
                    f"{low_total}\t{high_total}\t{frac_text(delta)}\t{orbit_key_text(orbit)}\n"
                )


def print_summary(results: list[dict], out_dir: str) -> None:
    total_records = sum(len(res["recs"]) for res in results)
    qs = [res["q"] for res in results]
    print(f"C42 loaded records={total_records} prime_q={qs}")
    print("ANCHOR onP histograms")
    for res in results:
        print(f"  q={res['q']:2d} onP_hist={{{hist_text(res['onp_hist'])}}}")

    print("SUMMARY fixed-q stabilizer census variation")
    for res in results:
        s = res["summary"]
        print(
            f"  q={res['q']:2d} classes={s['classes']} stab_orbits={s['orbits']} "
            f"P_orbits={s['p_orbits']} distinct_full_vectors={s['distinct_full']} "
            f"full_l1_diam={s['full_l1_diam']} full_coord_range_max={s['full_range_max']} "
            f"distinct_P_vectors={s['distinct_p']} P_l1_diam={s['p_l1_diam']} "
            f"P_coord_range_max={s['p_range_max']} onP_range={s['onp_min']}..{s['onp_max']}"
        )

    print("DEPLETED variation localization")
    for res in results:
        q = res["q"]
        if q not in (11, 17):
            continue
        groups: dict[int, list] = defaultdict(list)
        for row in res["classes"]:
            groups[row["onp"]].append(row)
        low = min(groups)
        high = max(groups)
        changed = []
        for i in res["p_indices"]:
            low_total = sum(row["full_vec"][i] for row in groups[low])
            high_total = sum(row["full_vec"][i] for row in groups[high])
            delta = Fraction(high_total, len(groups[high])) - Fraction(low_total, len(groups[low]))
            if delta:
                changed.append((abs(delta), delta, i, low_total, high_total))
        changed.sort(reverse=True)
        top = " ".join(
            f"{res['orbit_ids'][i]}:davg={frac_text(delta)} low={lo} high={hi}"
            for _, delta, i, lo, hi in changed[:8]
        )
        print(
            f"  q={q} low_onP={low} low_classes={len(groups[low])} "
            f"high_onP={high} high_classes={len(groups[high])} "
            f"changed_P_orbits={len(changed)}/{len(res['p_indices'])} top={top}"
        )

    print(
        "VERDICT full-vector census is non-uniform even at all-P q=13 and q=19; "
        "the fixed-q propagation half is not a value-blind uniform census identity."
    )
    print(f"TABLES out_dir={out_dir}")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out-dir", default="s4-dumps/2026-07-09/c42-census")
    ap.add_argument("q", nargs="*", type=int, default=[5, 7, 11, 13, 17, 19])
    args = ap.parse_args()
    qs = args.q or [5, 7, 11, 13, 17, 19]
    results = [analyze_q(q) for q in qs]
    write_tables(results, args.out_dir)
    print_summary(results, args.out_dir)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
