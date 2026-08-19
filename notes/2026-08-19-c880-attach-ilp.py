#!/usr/bin/env python3
"""Exact minimum hitting set of the attachment difference masks (C880).

Reads the mask dump written by
`notes/2026-08-19-c880-nonadaptive-constant.rs` (mode `lowerbound` with
C880NC_DUMP set) and solves

    minimise  sum_t z_t          subject to   sum_{t in M} z_t >= 1  for every mask M,
              z in {0,1}^T

to proved optimality with HiGHS (through `scipy.optimize.milp`) and,
independently, with CBC (through PuLP).  Dropping constraints can only lower a
hitting number, so the optimum of a weight-capped mask family is a valid lower
bound for g(m) whatever the sweep above the cap contains.

The script re-derives the constraint semantics from the triple list rather than
trusting the mask indices: every mask is checked to be a set of valid triple
indices, and the reported solution is re-checked against every mask directly.

    uv run --with numpy --with scipy --with pulp python3 \
        2026-08-19-c880-attach-ilp.py --masks FILE --out FILE [--cbc]
"""

import argparse
import hashlib
import json


def solve_highs(nvars, masks):
    import numpy as np
    from scipy.optimize import milp, LinearConstraint, Bounds

    from scipy.sparse import csc_matrix

    rows = len(masks)
    ri, ci = [], []
    for i, m in enumerate(masks):
        for t in m:
            ri.append(i)
            ci.append(t)
    a = csc_matrix(
        (np.ones(len(ri)), (np.array(ri), np.array(ci))), shape=(rows, nvars)
    )
    con = LinearConstraint(a, lb=np.ones(rows), ub=np.full(rows, np.inf))
    res = milp(
        c=np.ones(nvars),
        constraints=[con],
        integrality=np.ones(nvars),
        bounds=Bounds(0, 1),
    )
    assert res.success, res.message
    sol = [t for t in range(nvars) if res.x[t] > 0.5]
    return int(round(res.fun)), sol, res.status


def solve_cbc(nvars, masks):
    import pulp

    prob = pulp.LpProblem("attach_hitting_set", pulp.LpMinimize)
    z = [pulp.LpVariable(f"z{t}", cat="Binary") for t in range(nvars)]
    prob += pulp.lpSum(z)
    for m in masks:
        prob += pulp.lpSum(z[t] for t in m) >= 1
    status = prob.solve(pulp.PULP_CBC_CMD(msg=0))
    assert pulp.LpStatus[status] == "Optimal"
    sol = [t for t in range(nvars) if z[t].value() > 0.5]
    return len(sol), sol


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--masks", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--cbc", action="store_true")
    args = ap.parse_args()

    raw = open(args.masks, "rb").read()
    sha = hashlib.sha256(raw).hexdigest()
    data = json.loads(raw)
    m = data["m"]
    tc = data["triples"]
    triple_list = [tuple(t) for t in data["triple_list"]]
    assert len(triple_list) == tc
    # Re-derive the triple indexing from m rather than trusting the file.
    expect = [
        (p, q, r)
        for p in range(m)
        for q in range(p + 1, m)
        for r in range(q + 1, m)
    ]
    assert triple_list == expect, "triple indexing disagrees with the canonical order"

    masks = [list(sorted(set(mm))) for mm in data["masks"]]
    for mm in masks:
        assert mm and all(0 <= t < tc for t in mm)
    # Keep only inclusion-minimal masks; supersets are redundant constraints.
    masks.sort(key=lambda mm: (len(mm), mm))
    if len(masks) <= 5000:
        kept = []
        for mm in masks:
            s = set(mm)
            if not any(set(k) <= s for k in kept):
                kept.append(mm)
    else:
        # The generator already emitted an inclusion-minimal family; re-running
        # the quadratic filter here would dominate the solve.
        kept = [list(mm) for mm in dict.fromkeys(tuple(mm) for mm in masks)]

    k_highs, sol_highs, status = solve_highs(tc, kept)
    assert all(any(t in sol_highs for t in mm) for mm in kept), "HiGHS solution is not a hitting set"

    out = {
        "source": args.masks,
        "source_sha256": sha,
        "m": m,
        "triples": tc,
        "mask_maxweight": data["mask_maxweight"],
        "full_family_separates": data["full_family_separates"],
        "masks_in_file": len(data["masks"]),
        "masks_minimal": len(kept),
        "highs_optimum": k_highs,
        "highs_status": int(status),
        "highs_solution": sol_highs,
    }
    if args.cbc:
        k_cbc, sol_cbc = solve_cbc(tc, kept)
        assert all(any(t in sol_cbc for t in mm) for mm in kept), "CBC solution is not a hitting set"
        out["cbc_optimum"] = k_cbc
        out["cbc_agrees"] = bool(k_cbc == k_highs)
    out["g_lower_bound"] = k_highs

    with open(args.out, "w") as f:
        json.dump(out, f, indent=2, sort_keys=True)
        f.write("\n")
    print(json.dumps({k: v for k, v in out.items() if k not in ("highs_solution",)}, sort_keys=True))


if __name__ == "__main__":
    main()
