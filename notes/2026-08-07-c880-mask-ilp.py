#!/usr/bin/env python3
"""C880: the exact mask-free bound at n points, as an integer program.

Input is the difference-mask certificate written by

    c880 masks --n N --weight W --out masks.json

Each row of that file is a set M of alignment tests together with a witness
pair of graphs whose alignment vectors differ exactly on M.  Two such graphs
are separated only by a test of M, so every separating family is a hitting set
of the masks, and

    minimum separating family  >=  minimum hitting set of the masks.

The right-hand side is an integer program on one binary variable per test:
minimise the number of chosen tests subject to at least one chosen test in
every mask.  It is solved here to proved optimality by HiGHS through
`scipy.optimize.milp`, and the same program is written out in CPLEX LP format
so that an unrelated solver can confirm the value.

Nothing here trusts the scan that produced the masks.  Every witness pair is
re-expanded from its edge list, its two alignment vectors are recomputed from
the definition, and their difference is required to be exactly the mask that
claims it; the four-subset indexing is regenerated and required to agree.  A
mask whose witness fails is a fatal error rather than a dropped row, and the
scan's completeness is not used: dropping constraints can only lower the bound,
so the value below stands whatever else the scan missed.

Usage:
    uv run --with numpy --with scipy python3 2026-08-07-c880-mask-ilp.py \
        --masks masks8w4.json --out ilp8.json [--lp ilp8.lp]
"""

import argparse
import itertools
import json
import sys

import numpy as np
from scipy.optimize import LinearConstraint, milp
from scipy.sparse import csr_matrix


def alignment_vector(n, edges, foursets):
    """The alignment bits of the two-graph of `edges`, in the order of `foursets`.

    tau(abc) is the parity of the number of edges inside {a,b,c}; a four-set is
    aligned when its four triples carry equal tau.  This is the definition, not
    the generator's switching-class representation.
    """
    adj = [[0] * n for _ in range(n)]
    for i, j in edges:
        adj[i][j] = adj[j][i] = 1

    def tau(a, b, c):
        return (adj[a][b] + adj[a][c] + adj[b][c]) & 1

    out = 0
    for k, (a, b, c, d) in enumerate(foursets):
        t = (tau(a, b, c), tau(a, b, d), tau(a, c, d), tau(b, c, d))
        if t[0] == t[1] == t[2] == t[3]:
            out |= 1 << k
    return out


def verify(cert):
    """Recheck every mask against its witness pair; return the checked masks."""
    n = cert["n"]
    foursets = [tuple(f) for f in cert["foursets"]]
    expected = [tuple(c) for c in itertools.combinations(range(n), 4)]
    if foursets != expected:
        raise SystemExit("four-subset indexing does not match lexicographic order")
    if len(foursets) != cert["tests_available"]:
        raise SystemExit("test count disagrees with the four-subset list")

    masks = []
    for row in cert["masks"]:
        support = tuple(sorted(row["tests"]))
        ea, eb = row["witness_edges"]
        va = alignment_vector(n, ea, foursets)
        vb = alignment_vector(n, eb, foursets)
        diff = va ^ vb
        got = tuple(k for k in range(len(foursets)) if diff >> k & 1)
        if got != support:
            raise SystemExit(f"witness for mask {support} realises {got} instead")
        masks.append(support)
    if len(set(masks)) != len(masks):
        raise SystemExit("duplicate masks in the certificate")
    return n, len(foursets), masks


def solve(masks, tests):
    """Minimum hitting set of `masks`, to proved optimality, by HiGHS."""
    rows, cols = [], []
    for r, m in enumerate(masks):
        for t in m:
            rows.append(r)
            cols.append(t)
    a = csr_matrix(
        (np.ones(len(rows)), (rows, cols)), shape=(len(masks), tests)
    )
    res = milp(
        c=np.ones(tests),
        constraints=LinearConstraint(a, lb=np.ones(len(masks)), ub=np.inf),
        integrality=np.ones(tests),
        bounds=(0, 1),
    )
    if res.status != 0:
        raise SystemExit(f"solver did not prove optimality: {res.message}")
    chosen = sorted(t for t in range(tests) if res.x[t] > 0.5)
    if len(chosen) != round(res.fun):
        raise SystemExit("solution vector disagrees with the objective")
    hit = set(chosen)
    for m in masks:
        if not hit & set(m):
            raise SystemExit(f"returned family misses mask {m}")
    return len(chosen), chosen, res.mip_dual_bound


def resolve_with_cbc(masks, tests):
    """The same program through an unrelated solver, as the independent replay."""
    import pulp

    prob = pulp.LpProblem("hitting_set", pulp.LpMinimize)
    y = [pulp.LpVariable(f"y{t}", cat="Binary") for t in range(tests)]
    prob += pulp.lpSum(y)
    for m in masks:
        prob += pulp.lpSum(y[t] for t in m) >= 1
    status = prob.solve(pulp.PULP_CBC_CMD(msg=0, gapRel=0, gapAbs=0))
    return pulp.LpStatus[status], int(round(pulp.value(prob.objective)))


def write_lp(path, masks, tests):
    """The same program in CPLEX LP format, for an unrelated solver."""
    lines = ["Minimize", " obj: " + " + ".join(f"y{t}" for t in range(tests)), "Subject To"]
    for r, m in enumerate(masks):
        lines.append(f" c{r}: " + " + ".join(f"y{t}" for t in m) + " >= 1")
    lines.append("Binary")
    lines += [" " + " ".join(f"y{t}" for t in range(tests))]
    lines.append("End")
    with open(path, "w") as fh:
        fh.write("\n".join(lines) + "\n")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--masks", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--lp")
    ap.add_argument("--cbc", action="store_true", help="re-solve with CBC through PuLP")
    args = ap.parse_args()

    with open(args.masks) as fh:
        cert = json.load(fh)
    if cert.get("artifact") != "c880-difference-masks":
        raise SystemExit("not a difference-mask certificate")

    n, tests, masks = verify(cert)
    value, chosen, dual = solve(masks, tests)
    if args.lp:
        write_lp(args.lp, masks, tests)

    doc = {
        "artifact": "c880-mask-ilp",
        "schema": 1,
        "n": n,
        "tests_available": tests,
        "difference_weight_scanned": cert["difference_weight_scanned"],
        "masks_checked": len(masks),
        "witness_pairs_reverified": len(masks),
        "minimum_hitting_set": value,
        "largest_mask_free_set": tests - value,
        "mask_lower_bound": value,
        "optimality_proved": True,
        "solver": "HiGHS via scipy.optimize.milp",
        "dual_bound": dual,
        "hitting_set": chosen,
    }
    if args.cbc:
        status, value2 = resolve_with_cbc(masks, tests)
        if status != "Optimal" or value2 != value:
            raise SystemExit(f"CBC disagrees: {status} {value2} against {value}")
        doc["independent_solver"] = "CBC via PuLP"
        doc["independent_solver_value"] = value2
    with open(args.out, "w") as fh:
        json.dump(doc, fh, sort_keys=True)
        fh.write("\n")
    print(json.dumps(doc, sort_keys=True), file=sys.stderr)


if __name__ == "__main__":
    main()
