"""C997 -- symmetry-reduction gate on the [[144,12,12]] bivariate bicycle gross code.

Baseline formulation is Bravyi et al.'s published `distance_test.py`
(github.com/sbravyi/BivariateBicycleCodes, commit fa77e333, file sha256
5110793dd66b6672289e55c21eebc9eb267f73c041a1d0827b3fcba57ec7f889): one integer
program per logical qubit, mod-2 conditions linearised by powers-of-two slack
binaries, solved with python-mip / CBC.

Three formulations are compared on the same solver, machine and code:

  per-logical   -- upstream, k integer programs, no symmetry breaking.
  global        -- one integer program for min weight over ker(hx) \\ rowspace(hz),
                   encoding "not a stabiliser" as "some logical parity is odd".
                   No symmetry breaking. This isolates the reformulation effect.
  symbreak      -- the `global` model plus the Z_ell x Z_m orbit-representative
                   constraint, solved once per qubit-block orbit (two solves).

Soundness of `symbreak` is argued in the report and checked numerically by
`--check-group`.

Replay:
  uv run --with mip --with bposd --with numpy python gross_distance_experiment.py \
      --mode per-logical --out results_gross_per_logical.json --log-dir logs
"""

from __future__ import annotations

import argparse
import contextlib
import hashlib
import json
import os
import re
import sys
import tempfile
import time
from pathlib import Path

import numpy as np
from mip import BINARY, Model, minimize, xsum

# ---------------------------------------------------------------- gross code

ELL, M = 12, 6
A_EXP = (3, 1, 2)  # A = x^3 + y^1 + y^2
B_EXP = (3, 1, 2)  # B = y^3 + x^1 + x^2


def build_gross_code():
    """Return (hx, hz, lx, lz) for the [[144,12,12]] gross code.

    Verbatim construction from upstream `distance_test.py`.
    """
    from bposd.css import css_code

    ell, m = ELL, M
    a1, a2, a3 = A_EXP
    b1, b2, b3 = B_EXP

    I_ell = np.identity(ell, dtype=int)
    I_m = np.identity(m, dtype=int)
    x = {i: np.kron(np.roll(I_ell, i, axis=1), I_m) for i in range(ell)}
    y = {i: np.kron(I_ell, np.roll(I_m, i, axis=1)) for i in range(m)}

    A = (x[a1] + y[a2] + y[a3]) % 2
    B = (y[b1] + x[b2] + x[b3]) % 2
    hx = np.hstack((A, B))
    hz = np.hstack((B.T, A.T))

    qcode = css_code(hx, hz)
    # bposd 2.1 returns scipy sparse logicals; densify so the model builders and
    # hashes see plain 0/1 integer arrays, exactly as upstream assumed.
    def dense(mat):
        return np.asarray(mat.todense() if hasattr(mat, "todense") else mat, dtype=int) % 2

    return hx, hz, dense(qcode.lx), dense(qcode.lz), x, y


def translation_perm(u: int, v: int) -> np.ndarray:
    """Permutation of the 2*ELL*M qubit indices given by the shift x^u y^v.

    Block index q = r*M + s with r in Z_ELL, s in Z_M; the shift sends
    (r, s) -> (r+u mod ELL, s+v mod M) inside each of the two blocks.
    """
    n2 = ELL * M
    perm = np.empty(2 * n2, dtype=int)
    for r in range(ELL):
        for s in range(M):
            src = r * M + s
            dst = ((r + u) % ELL) * M + ((s + v) % M)
            perm[src] = dst
            perm[n2 + src] = n2 + dst
    return perm


def gf2_rank(mat: np.ndarray) -> int:
    rows = [int("".join(str(int(b) & 1) for b in row), 2) for row in mat]
    rank = 0
    pivots: list[int] = []
    for value in rows:
        for pivot in pivots:
            value = min(value, value ^ pivot)
        if value:
            pivots.append(value)
            pivots.sort(reverse=True)
            rank += 1
    return rank


def check_group_action(hx, hz) -> dict:
    """Verify that every shift x^u y^v preserves ker(hx) and rowspace(hz).

    Writing sigma for the coordinate permutation, ker(hx) is sigma-invariant iff
    rowspace(hx) is (the two are orthogonal complements), and the stabiliser
    group is rowspace(hz).  So we check, over GF(2),
        rank([hx ; hx.sigma]) == rank(hx)   and   rank([hz ; hz.sigma]) == rank(hz),
    which is exactly the invariance the reduction needs, with no sign or
    left/right convention to get wrong.
    """
    rank_hx = gf2_rank(hx % 2)
    rank_hz = gf2_rank(hz % 2)
    ok = True
    checked = 0
    free_on_blocks = True
    n2 = ELL * M
    for u in range(ELL):
        for v in range(M):
            perm = translation_perm(u, v)
            hxP = np.zeros_like(hx)
            hzP = np.zeros_like(hz)
            hxP[:, perm] = hx % 2
            hzP[:, perm] = hz % 2
            ok &= gf2_rank(np.vstack([hx % 2, hxP])) == rank_hx
            ok &= gf2_rank(np.vstack([hz % 2, hzP])) == rank_hz
            if (u, v) != (0, 0):
                free_on_blocks &= not np.any(perm == np.arange(2 * n2))
            checked += 1
    return {
        "group_order": checked,
        "rowspace_hx_invariant": bool(ok),
        "rank_hx": rank_hx,
        "rank_hz": rank_hz,
        "action_free_on_qubits": bool(free_on_blocks),
        "orbits_on_qubits": 2,
        "orbit_size": n2,
    }


# ------------------------------------------------------------- solver plumbing


@contextlib.contextmanager
def capture_fd(path: Path):
    """Capture C-level stdout (CBC's log) into `path`."""
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
    nodes = None
    iters = None
    match = NODE_RE.search(text)
    if match:
        nodes = int(match.group(1))
    match = ITER_RE.search(text)
    if match:
        iters = int(match.group(1))
    if nodes is None:
        match = SEARCH_RE.search(text)
        if match:
            iters = int(match.group(1))
            nodes = int(match.group(2))
    sym_lines = sorted({ln.strip() for ln in text.splitlines() if PRESOLVE_SYM_RE.search(ln)})
    return {"nodes": nodes, "iterations": iters, "symmetry_log_lines": sym_lines[:10]}


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
            "log_bytes": len(text),
        }
    )
    return stats


# ------------------------------------------------------------- ILP builders


def _mod2_slack(model, expr_terms, num_var_bits, rhs):
    """Return the constraint expr - sum 2^(j+1) a_j == rhs with fresh binaries a_j."""
    slacks = [model.add_var(var_type=BINARY) for _ in range(num_var_bits)]
    return xsum(expr_terms) - xsum((1 << (j + 1)) * slacks[j] for j in range(num_var_bits)) == rhs


def base_model(hx):
    """Model with the stabiliser orthogonality constraints and the weight objective."""
    n = hx.shape[1]
    m = hx.shape[0]
    wstab = int(np.max(hx.sum(axis=1)))
    num_anc_stab = int(np.ceil(np.log2(wstab)))

    model = Model()
    model.verbose = 0
    x = [model.add_var(var_type=BINARY) for _ in range(n)]
    model.objective = minimize(xsum(x[i] for i in range(n)))
    for row in range(m):
        supp = np.nonzero(hx[row, :])[0]
        model += _mod2_slack(model, [x[int(q)] for q in supp], num_anc_stab, 0)
    return model, x


def model_per_logical(hx, logic_op):
    """Upstream formulation: odd overlap with one X logical."""
    model, x = base_model(hx)
    supp = np.nonzero(logic_op)[0]
    wlog = int(np.count_nonzero(logic_op))
    bits = int(np.ceil(np.log2(wlog)))
    model += _mod2_slack(model, [x[int(q)] for q in supp], bits, 1)
    return model, x


def model_global(hx, lx, fix_index=None):
    """min weight over ker(hx) \\ rowspace(hz): some logical parity must be odd."""
    model, x = base_model(hx)
    parities = []
    for i in range(lx.shape[0]):
        supp = np.nonzero(lx[i, :])[0]
        wlog = int(np.count_nonzero(lx[i, :]))
        bits = int(np.ceil(np.log2(wlog)))
        p = model.add_var(var_type=BINARY)
        slacks = [model.add_var(var_type=BINARY) for _ in range(bits)]
        model += (
            xsum(x[int(q)] for q in supp)
            - xsum((1 << (j + 1)) * slacks[j] for j in range(bits))
            - p
            == 0
        )
        parities.append(p)
    model += xsum(parities) >= 1
    if fix_index is not None:
        model += x[fix_index] == 1
    return model, x


# ------------------------------------------------------------------- driver


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--mode",
        required=True,
        choices=["check-group", "per-logical", "global", "symbreak"],
    )
    ap.add_argument("--out", required=True)
    ap.add_argument("--log-dir", default="logs")
    ap.add_argument("--max-seconds", type=float, default=900.0)
    ap.add_argument("--logicals", default="all", help="'all' or comma-separated indices")
    args = ap.parse_args()

    log_dir = Path(args.log_dir)
    log_dir.mkdir(parents=True, exist_ok=True)

    hx, hz, lx, lz, _, _ = build_gross_code()
    n = hx.shape[1]
    k = lx.shape[0]

    record = {
        "code": "[[144,12,12]] bivariate bicycle gross code",
        "ell": ELL,
        "m": M,
        "A_exponents": list(A_EXP),
        "B_exponents": list(B_EXP),
        "n": int(n),
        "k": int(k),
        "mode": args.mode,
        "solver": "CBC via python-mip",
        "threads": 1,
        "max_seconds": args.max_seconds,
        "hx_sha256": hashlib.sha256(hx.astype(np.uint8).tobytes()).hexdigest(),
        "lx_sha256": hashlib.sha256(lx.astype(np.uint8).tobytes()).hexdigest(),
        "solves": [],
    }

    if args.mode == "check-group":
        record["group_check"] = check_group_action(hx, hz)
        Path(args.out).write_text(json.dumps(record, indent=2, sort_keys=True) + "\n")
        print(json.dumps(record["group_check"]))
        return 0

    if args.mode == "per-logical":
        if args.logicals == "all":
            indices = list(range(k))
        else:
            indices = [int(t) for t in args.logicals.split(",")]
        for i in indices:
            model, _ = model_per_logical(hx, lx[i, :])
            stats = solve(model, log_dir / f"gross_per_logical_{i}.log", args.max_seconds)
            stats["logical"] = i
            stats["num_vars"] = model.num_cols
            stats["num_constraints"] = model.num_rows
            record["solves"].append(stats)
            print(f"logical {i}: obj={stats['objective']} nodes={stats['nodes']} "
                  f"t={stats['wall_seconds']}s", file=sys.stderr)
            # write incrementally so a truncated run still leaves usable evidence
            Path(args.out).write_text(json.dumps(record, indent=2, sort_keys=True) + "\n")
    elif args.mode == "global":
        model, _ = model_global(hx, lx)
        stats = solve(model, log_dir / "gross_global.log", args.max_seconds)
        stats["fix_index"] = None
        stats["num_vars"] = model.num_cols
        stats["num_constraints"] = model.num_rows
        record["solves"].append(stats)
        print(f"global: obj={stats['objective']} nodes={stats['nodes']} "
              f"t={stats['wall_seconds']}s", file=sys.stderr)
    elif args.mode == "symbreak":
        for fix in (0, ELL * M):
            model, _ = model_global(hx, lx, fix_index=fix)
            stats = solve(model, log_dir / f"gross_symbreak_fix{fix}.log", args.max_seconds)
            stats["fix_index"] = fix
            stats["num_vars"] = model.num_cols
            stats["num_constraints"] = model.num_rows
            record["solves"].append(stats)
            print(f"symbreak fix={fix}: obj={stats['objective']} nodes={stats['nodes']} "
                  f"t={stats['wall_seconds']}s", file=sys.stderr)

    objectives = [s["objective"] for s in record["solves"] if s["objective"] is not None]
    record["min_objective"] = min(objectives) if objectives else None
    nodes = [s["nodes"] for s in record["solves"]]
    record["total_nodes"] = None if any(v is None for v in nodes) else sum(nodes)
    record["total_wall_seconds"] = round(sum(s["wall_seconds"] for s in record["solves"]), 3)

    Path(args.out).write_text(json.dumps(record, indent=2, sort_keys=True) + "\n")
    print(json.dumps({key: record[key] for key in
                      ("mode", "min_objective", "total_nodes", "total_wall_seconds")}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
