"""C997 -- symmetry-reduction gate on the classical [78,36,12]_2 q=13 passant code.

The code is the binary incidence code of the 78 internal points of a nonsingular
conic in PG(2,13) against its 78 passant lines; `papers/q13-passant-code` proves
d = 12 with exactly 364 minimum words in four PGL(2,13)-orbits of 91.  That
committed answer is the independent check on this experiment; nothing under
`papers/` is read or written by this script -- the geometry is rebuilt here from
the same definitions so the run is self-contained.

Formulations, same solver (CBC via python-mip), same machine, same instance:

  baseline   -- min sum(x) s.t. H x = 0 mod 2, sum(x) >= 1.
  symbreak   -- min sum(x) s.t. H x = 0 mod 2, x_0 = 1.
                Sound because PGL(2,13) is transitive on the 78 coordinates and
                preserves the code, so every nonzero codeword has an image whose
                support contains coordinate 0.
  symbreak2  -- symbreak plus the second-level orbit-representative constraint:
                min(supp(x) \\ {0}) must be the smallest element of its
                Stab(0)-orbit.  Encoded as x_i <= sum_{1 <= j < i} x_j for every
                i that is not the minimum of its Stab(0)-orbit.

Replay:
  uv run --with mip --with numpy python passant_distance_experiment.py \
      --mode baseline --out results_passant_baseline.json --log-dir logs
"""

from __future__ import annotations

import argparse
import contextlib
import hashlib
import json
import os
import re
import sys
import time
from pathlib import Path

import numpy as np
from mip import BINARY, Model, minimize, xsum

Q = 13


# ------------------------------------------------------------------ geometry


def canonical(vector):
    first = next(value for value in vector if value)
    inverse = pow(first, -1, Q)
    return tuple(value * inverse % Q for value in vector)


def projective_points():
    return (
        [(1, y, z) for y in range(Q) for z in range(Q)]
        + [(0, 1, z) for z in range(Q)]
        + [(0, 0, 1)]
    )


def build_passant_code():
    """Return (internal_points, passant_lines, incidence G) with G of shape (78, 78)."""
    points = projective_points()
    nonzero_squares = {value * value % Q for value in range(1, Q)}
    bad = nonzero_squares | {0}
    internal = [p for p in points if (p[1] * p[1] - p[0] * p[2]) % Q not in bad]
    passants = [l for l in points if (l[1] * l[1] - 4 * l[0] * l[2]) % Q not in bad]
    assert len(internal) == len(passants) == 78

    def incident(line, point):
        return sum(a * b for a, b in zip(line, point)) % Q == 0

    G = np.array(
        [[1 if incident(line, point) else 0 for point in internal] for line in passants],
        dtype=np.uint8,
    )
    return internal, passants, G


# --------------------------------------------------------------- GF(2) tools


def gf2_rref(mat: np.ndarray):
    """Row-reduce over GF(2); return (rref, pivot columns)."""
    a = (mat % 2).astype(np.uint8).copy()
    rows, cols = a.shape
    pivots = []
    r = 0
    for c in range(cols):
        pivot = None
        for i in range(r, rows):
            if a[i, c]:
                pivot = i
                break
        if pivot is None:
            continue
        a[[r, pivot]] = a[[pivot, r]]
        for i in range(rows):
            if i != r and a[i, c]:
                a[i] ^= a[r]
        pivots.append(c)
        r += 1
        if r == rows:
            break
    return a[:r], pivots


def gf2_nullspace(mat: np.ndarray) -> np.ndarray:
    """Basis (as rows) of {x : mat x = 0} over GF(2)."""
    rref, pivots = gf2_rref(mat)
    cols = mat.shape[1]
    free = [c for c in range(cols) if c not in pivots]
    basis = np.zeros((len(free), cols), dtype=np.uint8)
    for idx, f in enumerate(free):
        basis[idx, f] = 1
        for row, p in enumerate(pivots):
            basis[idx, p] = rref[row, f]
    return basis


def gf2_rank(mat: np.ndarray) -> int:
    return gf2_rref(mat)[0].shape[0]


# ------------------------------------------------------------- PGL(2,13)


def sym2_matrix(a, b, c, d):
    """3x3 action on (x, y, z) = (u^2, uv, v^2) induced by (u,v) -> (au+bv, cu+dv)."""
    return (
        (a * a % Q, 2 * a * b % Q, b * b % Q),
        (a * c % Q, (a * d + b * c) % Q, b * d % Q),
        (c * c % Q, 2 * c * d % Q, d * d % Q),
    )


def apply_matrix(mat, point):
    return canonical(tuple(sum(mat[r][k] * point[k] for k in range(3)) % Q for r in range(3)))


def pgl2_permutations(internal):
    """All permutations of the 78 internal points induced by PGL(2,13)."""
    index = {p: i for i, p in enumerate(internal)}
    perms = set()
    for a in range(Q):
        for b in range(Q):
            for c in range(Q):
                for d in range(Q):
                    if (a * d - b * c) % Q == 0:
                        continue
                    if a % Q:
                        if a % Q != 1:
                            continue  # normalise scalars: first nonzero entry is 1
                    elif b % Q != 1:
                        continue
                    mat = sym2_matrix(a, b, c, d)
                    perm = tuple(index[apply_matrix(mat, p)] for p in internal)
                    perms.add(perm)
    return sorted(perms)


def orbits_of(perms, ground):
    seen = {}
    reps = []
    for point in ground:
        if point in seen:
            continue
        orbit = {point}
        frontier = [point]
        while frontier:
            cur = frontier.pop()
            for perm in perms:
                img = perm[cur]
                if img not in orbit:
                    orbit.add(img)
                    frontier.append(img)
        for member in orbit:
            seen[member] = point
        reps.append((point, sorted(orbit)))
    return reps


# ------------------------------------------------------------ solver plumbing


@contextlib.contextmanager
def capture_fd(path: Path):
    sys.stdout.flush()
    saved = os.dup(1)
    with open(path, "wb") as sink:
        os.dup2(sink.fileno(), 1)
        try:
            yield
        finally:
            sys.stdout.flush()
            os.dup2(saved, 1)
            os.close(saved)


NODE_RE = re.compile(r"Enumerated nodes:\s+(\d+)")
ITER_RE = re.compile(r"Total iterations:\s+(\d+)")
SEARCH_RE = re.compile(r"took (\d+) iterations and (\d+) nodes")
PRESOLVE_SYM_RE = re.compile(r"(?i)(symmetr|orbital|nauty)")


def parse_cbc_log(text: str) -> dict:
    nodes = iters = None
    match = NODE_RE.search(text)
    if match:
        nodes = int(match.group(1))
    match = ITER_RE.search(text)
    if match:
        iters = int(match.group(1))
    if nodes is None:
        match = SEARCH_RE.search(text)
        if match:
            iters, nodes = int(match.group(1)), int(match.group(2))
    sym = sorted({ln.strip() for ln in text.splitlines() if PRESOLVE_SYM_RE.search(ln)})
    return {"nodes": nodes, "iterations": iters, "symmetry_log_lines": sym[:10]}


def solve(model: Model, log_path: Path, max_seconds: float) -> dict:
    model.verbose = 1
    model.threads = 1
    start = time.perf_counter()
    with capture_fd(log_path):
        status = model.optimize(max_seconds=max_seconds)
    elapsed = time.perf_counter() - start
    text = log_path.read_text(errors="replace")
    stats = parse_cbc_log(text)
    stats.update(
        {
            "status": str(status),
            "wall_seconds": round(elapsed, 3),
            "objective": None if model.objective_value is None else round(model.objective_value, 6),
            "objective_bound": None
            if model.objective_bound is None
            else round(model.objective_bound, 6),
            "num_vars": model.num_cols,
            "num_constraints": model.num_rows,
        }
    )
    return stats


# --------------------------------------------------------------- ILP builder


def build_model(H: np.ndarray, mode: str, stab_orbit_min: set[int] | None):
    n = H.shape[1]
    model = Model()
    model.verbose = 0
    x = [model.add_var(var_type=BINARY) for _ in range(n)]
    model.objective = minimize(xsum(x))
    for row in range(H.shape[0]):
        supp = np.nonzero(H[row, :])[0]
        bits = max(1, int(np.ceil(np.log2(max(2, len(supp))))))
        slacks = [model.add_var(var_type=BINARY) for _ in range(bits)]
        model += (
            xsum(x[int(q)] for q in supp)
            - xsum((1 << (j + 1)) * slacks[j] for j in range(bits))
            == 0
        )
    if mode == "baseline":
        model += xsum(x) >= 1
    else:
        model += x[0] == 1
        if mode == "symbreak2":
            assert stab_orbit_min is not None
            for i in range(1, n):
                if i not in stab_orbit_min:
                    model += x[i] <= xsum(x[j] for j in range(1, i))
    return model, x


# ------------------------------------------------------------------- driver


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--mode", required=True,
                    choices=["check-group", "baseline", "symbreak", "symbreak2"])
    ap.add_argument("--out", required=True)
    ap.add_argument("--log-dir", default="logs")
    ap.add_argument("--max-seconds", type=float, default=1200.0)
    args = ap.parse_args()

    log_dir = Path(args.log_dir)
    log_dir.mkdir(parents=True, exist_ok=True)

    internal, passants, G = build_passant_code()
    # The [78,36,12]_2 passant code is the NULL SPACE of the 78x78 passant/internal
    # incidence matrix, not its row space: the incidence matrix has GF(2)-rank 42,
    # so its kernel has dimension 36, and the row space (dimension 42) contains the
    # weight-7 incidence rows themselves.  The parity-check matrix is therefore G,
    # and membership is `G x = 0`.  This is the sparse formulation (78 checks of
    # weight 7), and it is the one whose minimum weight is the committed d = 12.
    H = G
    dim = 78 - gf2_rank(G)

    record = {
        "code": "[78,36,12]_2 q=13 passant code",
        "n": 78,
        "k": int(dim),
        "parity_rows": int(H.shape[0]),
        "mode": args.mode,
        "solver": "CBC via python-mip",
        "threads": 1,
        "max_seconds": args.max_seconds,
        "G_sha256": hashlib.sha256(G.tobytes()).hexdigest(),
        "H_sha256": hashlib.sha256(H.tobytes()).hexdigest(),
        "solves": [],
    }

    stab_orbit_min = None
    if args.mode in ("check-group", "symbreak2"):
        perms = pgl2_permutations(internal)
        # Code invariance is checked on a generating set of PGL(2,13); invariance
        # under generators implies invariance under the whole group.
        index = {p: i for i, p in enumerate(internal)}
        generators = [(1, 1, 0, 1), (2, 0, 0, 1), (0, 1, 1, 0)]
        gen_perms = [
            tuple(index[apply_matrix(sym2_matrix(*g), p)] for p in internal) for g in generators
        ]
        rank_G = gf2_rank(G)
        invariant = True
        for perm in gen_perms:
            Gp = np.zeros_like(G)
            Gp[:, list(perm)] = G
            invariant &= gf2_rank(np.vstack([G, Gp])) == rank_G
        # confirm the generators really do generate the enumerated group
        closure = {tuple(range(78))}
        frontier = [tuple(range(78))]
        while frontier:
            cur = frontier.pop()
            for gen in gen_perms:
                img = tuple(gen[cur[i]] for i in range(78))
                if img not in closure:
                    closure.add(img)
                    frontier.append(img)
        record_closure = len(closure)
        point_orbits = orbits_of(perms, range(78))
        stab0 = [p for p in perms if p[0] == 0]
        stab_orbits = orbits_of(stab0, range(1, 78))
        stab_orbit_min = {rep for rep, _ in stab_orbits}
        record["group_check"] = {
            "group_order": len(perms),
            "generated_subgroup_order": record_closure,
            "code_invariant_on_generators": bool(invariant),
            "rank_G": int(rank_G),
            "num_point_orbits": len(point_orbits),
            "point_orbit_sizes": sorted(len(o) for _, o in point_orbits),
            "stabiliser_order": len(stab0),
            "stab0_orbit_sizes": sorted(len(o) for _, o in stab_orbits),
            "num_orbit_minima_excluding_0": len(stab_orbit_min),
        }
        if args.mode == "check-group":
            Path(args.out).write_text(json.dumps(record, indent=2, sort_keys=True) + "\n")
            print(json.dumps(record["group_check"]))
            return 0

    model, _ = build_model(H, args.mode, stab_orbit_min)
    stats = solve(model, log_dir / f"passant_{args.mode}.log", args.max_seconds)
    record["solves"].append(stats)
    record["min_objective"] = stats["objective"]
    record["total_nodes"] = stats["nodes"]
    record["total_wall_seconds"] = stats["wall_seconds"]

    Path(args.out).write_text(json.dumps(record, indent=2, sort_keys=True) + "\n")
    print(json.dumps({key: record[key] for key in
                      ("mode", "min_objective", "total_nodes", "total_wall_seconds")}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
