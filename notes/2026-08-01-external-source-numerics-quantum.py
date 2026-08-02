#!/usr/bin/env python3
"""Independent replay of the 2-uniform note's section 6 numerics.

Deterministic: the local generators are drawn from numpy's PCG64 seeded with
SEED below, so the run is reproducible; no other randomness is used.

Emits a canonical JSON certificate on stdout, or with --check verifies the
tracked certificate and leaves the worktree unchanged.  Floating-point results
are rounded to ROUND decimals before serialization so the certificate is stable
across platforms.

Replay from the repository root:
    uv run --with numpy --with scipy python \
        notes/2026-08-01-external-source-numerics-quantum.py \
        > notes/2026-08-01-external-source-numerics-quantum.json
    uv run --with numpy --with scipy python \
        notes/2026-08-01-external-source-numerics-quantum.py --check

Certifies, for the stabilizer AME(4,3) state sum_{i,j} |i, j, i+j, i+2j> mod 3:
exact 2-uniformity of every pair marginal; the ratio of generator size to
symmetry defect against the stability ceiling sqrt(6/5), at five scales, each
labelled with whether it satisfies the theorem's hypothesis; and the quantum
Fisher identity.  For the four-qutrit GHZ state: an exact continuous product
symmetry and a non-maximally-mixed pair marginal.

Does NOT certify the stability theorem itself, which is a statement about all
generators, nor anything about states other than these two.  The defect
threshold below which every approximate symmetry is near an exact one is
non-explicit in the source and is not computed here.
"""
import json
import sys

import numpy as np
from scipy.linalg import expm

SEED = 11
ROUND = 10
Q, N = 3, 4
DIM = Q ** N
SCALES = (0.3, 0.1, 0.03, 0.01, 0.003)


def ame43():
    v = np.zeros(DIM, dtype=complex)
    for i in range(Q):
        for j in range(Q):
            idx = ((i * Q + j) * Q + (i + j) % Q) * Q + (i + 2 * j) % Q
            v[idx] = 1
    return v / np.linalg.norm(v)


def ghz4():
    v = np.zeros(DIM, dtype=complex)
    for i in range(Q):
        v[((i * Q + i) * Q + i) * Q + i] = 1
    return v / np.linalg.norm(v)


def marginal(psi, keep):
    t = psi.reshape([Q] * N)
    rest = [ax for ax in range(N) if ax not in keep]
    t = np.transpose(t, list(keep) + rest).reshape(Q ** len(keep), -1)
    return t @ t.conj().T


def site_op(h, j):
    out = np.eye(1, dtype=complex)
    for k in range(N):
        out = np.kron(out, h if k == j else np.eye(Q, dtype=complex))
    return out


def generators(rng):
    hs = []
    for _ in range(N):
        a = rng.normal(size=(Q, Q)) + 1j * rng.normal(size=(Q, Q))
        h = (a + a.conj().T) / 2
        hs.append(h - np.trace(h) / Q * np.eye(Q))
    return hs


def build():
    psi = ame43()
    pair_dev = max(
        float(np.abs(marginal(psi, (a, b)) - np.eye(Q * Q) / (Q * Q)).max())
        for a in range(N) for b in range(a + 1, N)
    )

    rng = np.random.default_rng(SEED)
    hs = generators(rng)
    frob2 = float(sum(np.trace(h @ h).real for h in hs))
    sum_op = float(sum(np.linalg.norm(h, 2) for h in hs))
    M = sum(site_op(h, j) for j, h in enumerate(hs))

    rows = []
    for s in SCALES:
        U = np.eye(1, dtype=complex)
        for h in hs:
            U = np.kron(U, expm(1j * s * h))
        psi_u = U @ psi
        ov = complex(np.vdot(psi, psi_u))
        eps = float(np.sqrt(max(0.0, 2 - 2 * abs(ov))))
        # independent route to the same defect: minimise over the global phase
        phase = ov / abs(ov) if abs(ov) > 0 else 1.0
        eps_direct = float(np.linalg.norm(psi_u - phase * psi))
        dist = float(s * np.sqrt(frob2))
        t = s * sum_op
        rows.append({
            "scale": s,
            "defect": round(eps, ROUND),
            "defect_direct_norm": round(eps_direct, ROUND),
            "defect_routes_agree": bool(abs(eps - eps_direct) < 1e-9),
            "generator_frobenius": round(dist, ROUND),
            "ratio_to_sqrt_q_defect": round(dist / (np.sqrt(Q) * eps), ROUND),
            "hypothesis_t": round(t, ROUND),
            "hypothesis_satisfied": bool(t <= 0.5),
            "under_ceiling": bool(dist / (np.sqrt(Q) * eps) <= np.sqrt(1.2) + 1e-12),
        })

    mean = float(np.vdot(psi, M @ psi).real)
    var = float(np.vdot(psi, M @ (M @ psi)).real - mean ** 2)

    ghz = ghz4()
    n_op = np.diag([0.0, 1.0, 2.0]).astype(complex)
    theta = 0.7
    G = np.eye(1, dtype=complex)
    for j in range(N):
        G = np.kron(G, expm(1j * theta * (n_op if j < N - 1 else -(N - 1) * n_op)))
    ov_g = complex(np.vdot(ghz, G @ ghz))

    return {
        "schema": "external-source-numerics-quantum/1",
        "source_note": "notes/2026-08-01-external-session-notes/"
                       "approximate_rigidity_of_2uniform_states.md section 6",
        "seed": SEED,
        "local_dimension": Q,
        "parties": N,
        "ame43": {
            "pair_marginal_max_deviation": round(pair_dev, ROUND),
            "two_uniform_exact": bool(pair_dev < 1e-12),
            "stability_ceiling_sqrt_6_over_5": round(float(np.sqrt(1.2)), ROUND),
            "rows": rows,
            "all_rows_under_ceiling": all(r["under_ceiling"] for r in rows),
            "rows_outside_hypothesis": [r["scale"] for r in rows
                                        if not r["hypothesis_satisfied"]],
            "fisher_4_var_M": round(4 * var, ROUND),
            "fisher_4_over_q_frobenius": round(4 / Q * frob2, ROUND),
            "fisher_identity_holds": bool(abs(4 * var - 4 / Q * frob2) < 1e-9),
            "mean_M_is_zero": bool(abs(mean) < 1e-12),
        },
        "ghz4": {
            "continuous_symmetry_defect": round(
                float(np.sqrt(max(0.0, 2 - 2 * abs(ov_g)))), ROUND),
            "exact_continuous_symmetry": bool(abs(abs(ov_g) - 1) < 1e-12),
            "pair_marginal_frobenius_deviation": round(
                float(np.linalg.norm(marginal(ghz, (0, 1)) - np.eye(Q * Q) / (Q * Q))),
                ROUND),
        },
    }


def main():
    doc = build()
    text = json.dumps(doc, indent=2, sort_keys=True) + "\n"
    if "--check" in sys.argv:
        with open(__file__.replace(".py", ".json")) as fh:
            tracked = fh.read()
        if tracked != text:
            print("MISMATCH against tracked certificate", file=sys.stderr)
            sys.exit(1)
        a = doc["ame43"]
        if not (a["two_uniform_exact"] and a["fisher_identity_holds"]
                and a["all_rows_under_ceiling"]
                and all(r["defect_routes_agree"] for r in a["rows"])
                and doc["ghz4"]["exact_continuous_symmetry"]):
            print("CROSS-CHECK FAILED", file=sys.stderr)
            sys.exit(1)
        print("OK: certificate matches and all cross-checks pass")
        return
    sys.stdout.write(text)


if __name__ == "__main__":
    main()
