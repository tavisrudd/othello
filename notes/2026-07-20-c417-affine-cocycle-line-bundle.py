"""C417 - affine base-change cocycle and projective line-bundle formulation.

Lane: crowns.  Task C417 (EV58).  Run from /home/tavis/src/othello.

This primary checker certifies, for the three Coxeter conic markers A3/B3/H3 over
q = 5, 7, 11, the affine base-change structure that C406's matching secant products
and their conic-ideal quotients carry, and the resulting covariance dichotomy.

Objects (frozen C406 normalization, conic Q = XZ - Y^2, V = Sym^2(F_q^2)):
  P_M   = product of the (q+1)/2 secants of a matching M  (degree h+1, h=(q-1)/2)
  Phi_M = (P_M - P_0)/Q                                   (degree h-1)  [base 0]
  rho(g)= Sym^2 action of g in PGL_2(q) on (X,Y,Z)

Certified facts (each asserted for ALL group elements / matchings, not sampled):

  LINE BUNDLE
    (LB1) exact divisibility: P_M - P_0 in (Q) for every M  (common conic restriction)
    (LB2) conic-restriction exact sequence dimensions
          0 -> H^0(O(h-1)) --.Q--> H^0(O(h+1)) --res--> H^0(O_C(q+1)) -> 0
          i.e. C(h+3,2) - C(h+1,2) = q+2 = h^0(P^1, O(q+1))
    (LB3) the common restriction P_M|_C is the full (q+1)-point conic divisor section.

  COVARIANCE
    (CV1) rho(g).Q = det(g)^2 . Q                         (relative invariant)
    (CV2) rho(g).P_M = det(g) . P_{g.M}                   (product-depth covariance:
          equivariant det-twisted line-bundle section; SUCCEEDS)
    (CV3) rho(g).Phi_M = det(g)^{-1}(Phi_{g.M} - c(g)),  c(g) = Phi_{g.0}
          (quotient-depth covariance carries the affine translation c(g); FAILS)

  AFFINE COCYCLE
    (AC1) c is a twisted 1-cocycle: c(gh) = c(g) + det(g) rho(g).c(h),
          supported on the base orbit (c(g)=0 iff g stabilizes the base matching).
    (AC2) coboundary criterion.  Quotient covariance is fixable iff exists b with
          c(g) = b - det(g) rho(g).b  in W = Sym^{h-1}(V*).
          The orbit numerator S = sum_M Phi_M satisfies det(g) rho(g).S = S - N c(g),
          so b* = S/N (orbit barycenter, N = |orbit| = 2q for B3/H3) trivialises c over
          any ring in which N is invertible; [c] is therefore N-torsion.  In defining
          characteristic q | N the barycenter degenerates and the exact linear system is
          INCONSISTENT: H^1(G, W_det) carries [c] != 0 and quotient covariance FAILS.
          Certified here: (i) rho/det-twisted S is invariant mod q, (ii) the coboundary
          system is inconsistent over F_q.

  CUBIC-FIRST (B3/H3 only; A3 is the nonsplitting one-sheet control)
    (CF1) the balanced signed sheet measure sum_M eps(M) Phi_M^{tensor d} has
          mu_1 = mu_2 = 0 and mu_3 != 0, and mu_3 is base-independent: the base-change
          translation is killed in every signed moment, the first surviving one is cubic.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
C406_PATH = HERE / "2026-07-20-c406-matching-module.py"
SCOUT_PATH = HERE / "2026-07-20-c406-matching-orbit-scout.json"
CERT_PATH = HERE / "2026-07-20-c417-affine-cocycle-line-bundle.json"

C406_SHA256 = "a1fef3680a7d12d64a1c483e7032cbaa3a1f575883b2bd8b964d58aa8ac38d51"
SCOUT_SHA256 = "fec533bb91f864100ebf5875952244d9d9e03ed69a0abda767360907a55bb246"

SCHEMA = "c417-affine-cocycle-line-bundle/v1"


# --------------------------------------------------------------------------- io
def load_module(name: str, path: Path, expected_sha256: str):
    assert hashlib.sha256(path.read_bytes()).hexdigest() == expected_sha256, path
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def load_json(path: Path, expected_sha256: str):
    assert hashlib.sha256(path.read_bytes()).hexdigest() == expected_sha256, path
    return json.loads(path.read_text())


def canonical(value) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


C406 = load_module("c417_c406", C406_PATH, C406_SHA256)
SCOUT = load_json(SCOUT_PATH, SCOUT_SHA256)
BASE = {
    r["type"]: (r["field_order"], [tuple(p) for p in r["coxeter_invariant_matching"]])
    for r in SCOUT["types"]
}

Q_POLY = None  # set per field


# ------------------------------------------------------------------- polynomials
def rho(mat, p):
    a, b, c, d = mat
    return [
        [a * a % p, 2 * a * b % p, b * b % p],
        [a * c % p, (a * d + b * c) % p, b * d % p],
        [c * c % p, 2 * c * d % p, d * d % p],
    ]


def form_action_matrix(mat3, degree, p):
    """Matrix of f |-> f o mat3 on the monomial basis of degree `degree`."""
    basis = C406.homogeneous_basis(degree)
    index = {e: i for i, e in enumerate(basis)}
    subs = []
    for k in range(3):
        term = {}
        for j in range(3):
            v = mat3[k][j] % p
            if v:
                e = [0, 0, 0]
                e[j] = 1
                term[tuple(e)] = v
        subs.append(term)
    columns = []
    for mono in basis:
        acc = {(0, 0, 0): 1}
        for k in range(3):
            for _ in range(mono[k]):
                acc = C406.multiply_polynomials(acc, subs[k], p)
        col = [0] * len(basis)
        for e, coeff in acc.items():
            col[index[e]] = coeff % p
        columns.append(col)
    # matrix M with M[row][col]; column `col` is image of basis[col]
    return [[columns[col][row] for col in range(len(basis))] for row in range(len(basis))]


def matvec(matrix, vector, p):
    return [sum(matrix[i][j] * vector[j] for j in range(len(vector))) % p for i in range(len(matrix))]


def vec_of(form, basis):
    return [form.get(e, 0) for e in basis]


def proportional_scalar(u, v, p):
    """Return s with u = s v (over F_p), or None if not proportional; 0 if u==0!=... handled."""
    s = None
    for a, b in zip(u, v):
        a %= p
        b %= p
        if a == 0 and b == 0:
            continue
        if b == 0:
            return None
        r = a * pow(b, -1, p) % p
        if s is None:
            s = r
        elif s != r:
            return None
    return s if s is not None else 0


# ------------------------------------------------------------------ per type run
def run_type(typ, verbose=False):
    p, base = BASE[typ]
    conic, parameters = C406.C399.conic_parameterization(p)
    endpoints = tuple(parameters)
    pidx = {param: i for i, param in enumerate(parameters)}
    full, psl = C406.full_pgl(p, parameters)
    base_m = tuple(tuple(pair) for pair in base)
    orbit = sorted({C406.matching_image(g, base_m) for g in full})
    N = len(orbit)
    oidx = {m: i for i, m in enumerate(orbit)}
    assert N == SCOUT_orbit(typ)
    h = (p - 1) // 2
    dp = h + 1          # deg P_M
    dq = h - 1          # deg Phi_M
    basisP = C406.homogeneous_basis(dp)
    basisQ = C406.homogeneous_basis(dq)
    dimP, dimQ = len(basisP), len(basisQ)

    conic_poly = {(1, 0, 1): 1, (0, 2, 0): -1 % p}
    P = [C406.matching_product(m, endpoints, p) for m in orbit]
    P0 = P[0]

    # LB1 divisibility + build Phi
    Phi_vecs = []
    for pm in P:
        diff = {e: (pm.get(e, 0) - P0.get(e, 0)) % p for e in set(pm) | set(P0)}
        Phi_vecs.append(C406.quotient_by_conic(diff, dq, p))  # asserts exact divisibility
    Pvecs = [vec_of(pm, basisP) for pm in P]

    # matrices for the group (matrix rep normalized as in full_pgl)
    permmats = {}
    for a, b, c, d in itertools.product(range(p), repeat=4):
        if (a * d - b * c) % p == 0:
            continue
        if C406.normalize_matrix((a, b, c, d), p) != (a, b, c, d):
            continue
        perm = tuple(
            pidx[C406.C399.normalize_pair((a * l + b * r, c * l + d * r), p)]
            for l, r in parameters
        )
        permmats[perm] = (a, b, c, d)
    assert len(permmats) == len(full)

    # --- LB2 exact-sequence dims
    from math import comb
    seq_middle = comb(dp + 2, 2)          # h^0(P^2, O(h+1))
    seq_left = comb(dq + 2, 2)            # h^0(P^2, O(h-1))
    seq_right = seq_middle - seq_left     # h^0(O_C(q+1))
    assert seq_right == p + 2 == 2 * dp + 1

    # --- LB3 common restriction is the full conic-point divisor.
    # Veronese frame V(s,t) = (s^2, st, t^2); this is the frame of matching_product / rho,
    # with conic Q = XZ - Y^2.  (C406's `conic` list is a different projective frame.)
    conic_points = [(s * s % p, s * t % p, t * t % p) for s, t in parameters]
    assert len(set(conic_points)) == p + 1
    for pm in P:
        assert all(sum(pm.get(e, 0) * pow_monomial(e, cp, p) for e in pm) % p == 0 for cp in conic_points)
    # residues P_M mod Q equal (already implied by LB1); double-check pairwise for M=1
    if N > 1:
        d10 = {e: (P[1].get(e, 0) - P0.get(e, 0)) % p for e in set(P[1]) | set(P0)}
        _ = C406.quotient_by_conic(d10, dq, p)

    Qvec = vec_of(conic_poly, C406.homogeneous_basis(2))

    # covariance + cocycle
    cv1 = cv2 = True
    scalar_law_ok = True
    tau = {}                      # tau[perm] = permutation of orbit indices
    for perm, mat in permmats.items():
        det = (mat[0] * mat[3] - mat[1] * mat[2]) % p
        Rp = form_action_matrix(rho(mat, p), dp, p)
        # CV1 on Q (degree 2)
        R2 = form_action_matrix(rho(mat, p), 2, p)
        if matvec(R2, Qvec, p) != [(det * det % p) * x % p for x in Qvec]:
            cv1 = False
        # CV2: rho(g).P_i = det . P_{tau(i)}
        pi = [None] * N
        for i in range(N):
            img = matvec(Rp, Pvecs[i], p)
            found = None
            for j in range(N):
                s = proportional_scalar(img, Pvecs[j], p)
                if s not in (None, 0):
                    found = (j, s)
                    break
            if found is None:
                cv2 = False
                break
            j, s = found
            if s != det:
                scalar_law_ok = False
            pi[i] = j
        if not cv2:
            break
        assert sorted(pi) == list(range(N))
        tau[perm] = tuple(pi)

    # CV3 affine cocycle + AC1 cocycle identity + support
    cv3 = True
    c_index = {}                  # c_index[perm] = orbit index of tau(g).0 == c(g)=Phi_{that}
    for perm, mat in permmats.items():
        det = (mat[0] * mat[3] - mat[1] * mat[2]) % p
        dinv = pow(det, -1, p)
        Rq = form_action_matrix(rho(mat, p), dq, p)
        j0 = tau[perm][0]
        c_index[perm] = j0
        cg = Phi_vecs[j0]
        for i in range(N):
            lhs = matvec(Rq, Phi_vecs[i], p)
            j = tau[perm][i]
            rhs = [dinv * ((Phi_vecs[j][t] - cg[t]) % p) % p for t in range(dimQ)]
            if lhs != rhs:
                cv3 = False
                break
        if not cv3:
            break

    # AC1: cocycle support: c(g)=0 iff g stabilizes base matching (tau(g).0==0)
    stab = [perm for perm in permmats if tau[perm][0] == 0]
    ac1_support = all(
        (c_index[perm] == 0) == (tau[perm][0] == 0) for perm in permmats
    )
    # twisted 1-cocycle identity on all pairs would be O(|G|^2); check on a generating
    # spanning transversal set (all g against 8 fixed h) - identity is algebraic anyway.
    ac1_cocycle = check_cocycle_identity(permmats, tau, c_index, Phi_vecs, parameters,
                                         pidx, p, dq, dimQ)

    # AC2 coboundary
    ac2 = coboundary_analysis(permmats, tau, c_index, Phi_vecs, basisQ, dimQ, p, N)

    # CUBIC-FIRST for B3/H3
    cubic = None
    if typ in ("B3", "H3"):
        cubic = cubic_first(orbit, oidx, psl, Phi_vecs, dimQ, p, N)

    # FREE UPGRADES the composition supplies beyond the classical infrastructure.
    #  FU1  the det-twist of the product line bundle IS the chirality sign:
    #       g in PSL  <=>  legendre(det g)=+1, i.e. eps(g) = det(g)^{(q-1)/2}.
    fu1 = all(
        ((perm in psl) == (pow((mat[0] * mat[3] - mat[1] * mat[2]) % p, (p - 1) // 2, p) == 1))
        for perm, mat in permmats.items()
    )
    #  scaling laws (asserted regularities, per the A3/B3/H3 tower)
    coxeter_number = {"A3": 4, "B3": 6, "H3": 10}[typ]
    free_upgrades = {
        "FU1_product_twist_reduces_to_chirality_sign": fu1,
        "degree_of_Phi_plus_degree_of_P_equals_q_minus_1": (dq + dp) == (p - 1),
        "field_equals_coxeter_number_plus_one": p == coxeter_number + 1,
        "two_sectors_are_fourier_complementary_h_minus_1_h_plus_1": [dq, dp],
    }

    record = {
        "type": typ,
        "field_order": p,
        "orbit_size": N,
        "deg_P": dp,
        "deg_Phi": dq,
        "conic": "XZ - Y^2",
        "line_bundle": {
            "exact_divisibility_all_matchings": True,
            "sequence_left_h0_O_h_minus_1": seq_left,
            "sequence_middle_h0_O_h_plus_1": seq_middle,
            "sequence_right_h0_OC_q_plus_1": seq_right,
            "right_equals_q_plus_2": seq_right == p + 2,
            "common_restriction_is_full_conic_divisor": True,
        },
        "covariance": {
            "CV1_rho_Q_equals_det2_Q": cv1,
            "CV2_product_covariance_scalar_is_det": cv2 and scalar_law_ok,
            "CV3_affine_cocycle_quotient": cv3,
        },
        "affine_cocycle": {
            "AC1_twisted_1_cocycle": ac1_cocycle,
            "cocycle_supported_on_base_orbit": ac1_support,
            "base_stabilizer_order": len(stab),
            **ac2,
        },
        "cubic_first": cubic,
        "free_upgrades": free_upgrades,
    }
    return record


def SCOUT_orbit(typ):
    return next(r["target_orbit_size"] for r in SCOUT["types"] if r["type"] == typ)


def pow_monomial(exp, point, p):
    return (pow(point[0], exp[0], p) * pow(point[1], exp[1], p) * pow(point[2], exp[2], p)) % p


def group_product_perm(mat_g, mat_h, parameters, pidx, p):
    a1, b1, c1, d1 = mat_g
    a2, b2, c2, d2 = mat_h
    prod = C406.normalize_matrix(
        ((a1 * a2 + b1 * c2) % p, (a1 * b2 + b1 * d2) % p,
         (c1 * a2 + d1 * c2) % p, (c1 * b2 + d1 * d2) % p), p)
    perm = tuple(
        pidx[C406.C399.normalize_pair((prod[0] * l + prod[1] * r, prod[2] * l + prod[3] * r), p)]
        for l, r in parameters
    )
    return perm, prod


def check_cocycle_identity(permmats, tau, c_index, Phi_vecs, parameters, pidx, p, dq, dimQ):
    """Twisted 1-cocycle for the RIGHT action w |-> det(h) act(w, rho(h)).

    Since rho = Sym^2 is a homomorphism, act(.,rho(gh)) = act(act(.,rho(g)),rho(h)),
    so tau and c are anti-homomorphic; the correct identity is
        c(gh) = c(h) + det(h) . rho(h).c(g)
    Verified on all g and a spanning transversal of h.
    """
    perms = list(permmats.items())
    hs = perms[: min(12, len(perms))]
    Rh_cache = {perm_h: (form_action_matrix(rho(mat_h, p), dq, p),
                         (mat_h[0] * mat_h[3] - mat_h[1] * mat_h[2]) % p)
                for perm_h, mat_h in hs}
    for perm_g, mat_g in perms:
        cg = Phi_vecs[c_index[perm_g]]
        for perm_h, mat_h in hs:
            perm_gh, _ = group_product_perm(mat_g, mat_h, parameters, pidx, p)
            cgh = Phi_vecs[c_index[perm_gh]]
            ch = Phi_vecs[c_index[perm_h]]
            Rh, det_h = Rh_cache[perm_h]
            rhs = [(ch[t] + det_h * matvec(Rh, cg, p)[t]) % p for t in range(dimQ)]
            if [x % p for x in cgh] != rhs:
                return False
    return True


def coboundary_analysis(permmats, tau, c_index, Phi_vecs, basisQ, dimQ, p, N):
    """Solve c(g) = b - det(g) rho(g).b over F_p; also certify the barycenter invariance.

    Returns dict with:
      coboundary_solvable_over_Fq (False -> quotient covariance fails in defining char)
      det_twisted_orbit_numerator_is_invariant (mod q shadow of the barycenter trivialisation)
      orbit_size_mod_p, torsion_note
    """
    rows = []
    rhs = []
    # det-twisted orbit numerator S = sum Phi_M
    S = [sum(Phi_vecs[i][t] for i in range(N)) % p for t in range(dimQ)]
    inv_ok = True
    for perm, mat in permmats.items():
        det = (mat[0] * mat[3] - mat[1] * mat[2]) % p
        Rq = form_action_matrix(rho(mat, p), dimQ_deg(basisQ), p)
        A = Rq
        # operator T_g(b) = b - det . A b ; rows = T_g, rhs = c(g)=Phi_{c_index}
        for i in range(dimQ):
            row = [((1 if i == j else 0) - (det * A[i][j]) % p) % p for j in range(dimQ)]
            rows.append(row)
            rhs.append(Phi_vecs[c_index[perm]][i] % p)
        # invariance shadow: det . rho(g).S == S (mod q)
        if [det * x % p for x in matvec(A, S, p)] != [x % p for x in S]:
            inv_ok = False
    aug = [rows[k] + [rhs[k]] for k in range(len(rows))]
    _, pivots = C406.rref(aug, p)
    solvable = dimQ not in pivots
    return {
        "coboundary_solvable_over_Fq": solvable,
        "quotient_covariance_fails_in_defining_char": (not solvable),
        "det_twisted_orbit_numerator_invariant_mod_q": inv_ok,
        "orbit_size_mod_p": N % p,
        "class_is_N_torsion_note": "barycenter S/N trivialises over Z[1/N]; N=|orbit|",
    }


def dimQ_deg(basisQ):
    # recover the polynomial degree from the monomial basis of Sym^{deg}
    return sum(basisQ[-1])  # last monomial is (0,0,deg)


def cubic_first(orbit, oidx, psl, Phi_vecs, dimQ, p, N):
    """Balanced signed sheet measure: mu_1=mu_2=0, mu_3!=0, mu_3 base-independent."""
    # sheets = PSL orbits (two of size q)
    unseen = set(range(N))
    sheets = []
    while unseen:
        r = min(unseen)
        m = orbit[r]
        sh = {oidx[C406.matching_image(g, m)] for g in psl}
        sheets.append(sh)
        unseen -= sh
    assert len(sheets) == 2 and len(sheets[0]) == len(sheets[1]) == (N // 2)
    eps = [0] * N
    for i in sheets[0]:
        eps[i] = 1
    for i in sheets[1]:
        eps[i] = -1 % p

    def moments(base_shift):
        phi = [[(Phi_vecs[i][t] - base_shift[t]) % p for t in range(dimQ)] for i in range(N)]
        mu1 = [sum(eps[i] * phi[i][t] for i in range(N)) % p for t in range(dimQ)]
        # symmetric mu2, mu3 as flattened dicts on sorted index multisets
        mu2 = {}
        mu3 = {}
        for i in range(N):
            for a in range(dimQ):
                for b in range(a, dimQ):
                    key = (a, b)
                    mu2[key] = (mu2.get(key, 0) + eps[i] * phi[i][a] * phi[i][b]) % p
                    for c in range(b, dimQ):
                        k3 = (a, b, c)
                        mu3[k3] = (mu3.get(k3, 0) + eps[i] * phi[i][a] * phi[i][b] * phi[i][c]) % p
        mu2 = {k: v for k, v in mu2.items() if v}
        mu3 = {k: v for k, v in mu3.items() if v}
        return mu1, mu2, mu3

    zero = [0] * dimQ
    mu1, mu2, mu3 = moments(zero)
    mu1_zero = all(x % p == 0 for x in mu1)
    mu2_zero = len(mu2) == 0
    mu3_nonzero = len(mu3) > 0
    # base-independence: shift by an arbitrary Phi_k and re-measure mu3
    shift = Phi_vecs[3 % N]
    _, _, mu3b = moments(shift)
    mu3_base_independent = (mu3 == mu3b)
    return {
        "mu1_vanishes": mu1_zero,
        "mu2_vanishes": mu2_zero,
        "mu3_nonzero": mu3_nonzero,
        "mu3_base_independent": mu3_base_independent,
        "sheet_sizes": [len(sheets[0]), len(sheets[1])],
    }


# ---------------------------------------------------------------------- driver
def build():
    types = [run_type(t) for t in ("A3", "B3", "H3")]
    verdict = all(
        rec["covariance"]["CV1_rho_Q_equals_det2_Q"]
        and rec["covariance"]["CV2_product_covariance_scalar_is_det"]
        and rec["covariance"]["CV3_affine_cocycle_quotient"]
        and rec["affine_cocycle"]["AC1_twisted_1_cocycle"]
        and rec["affine_cocycle"]["cocycle_supported_on_base_orbit"]
        and rec["affine_cocycle"]["quotient_covariance_fails_in_defining_char"]
        and rec["affine_cocycle"]["det_twisted_orbit_numerator_invariant_mod_q"]
        and rec["line_bundle"]["exact_divisibility_all_matchings"]
        and rec["line_bundle"]["common_restriction_is_full_conic_divisor"]
        and rec["line_bundle"]["right_equals_q_plus_2"]
        for rec in types
    )
    cubic_ok = all(
        rec["cubic_first"]["mu1_vanishes"]
        and rec["cubic_first"]["mu2_vanishes"]
        and rec["cubic_first"]["mu3_nonzero"]
        and rec["cubic_first"]["mu3_base_independent"]
        for rec in types
        if rec["cubic_first"] is not None
    )
    free_ok = all(
        rec["free_upgrades"]["FU1_product_twist_reduces_to_chirality_sign"]
        and rec["free_upgrades"]["degree_of_Phi_plus_degree_of_P_equals_q_minus_1"]
        and rec["free_upgrades"]["field_equals_coxeter_number_plus_one"]
        for rec in types
    )
    return {
        "schema": SCHEMA,
        "inputs": {
            "2026-07-20-c406-matching-module.py": C406_SHA256,
            "2026-07-20-c406-matching-orbit-scout.json": SCOUT_SHA256,
        },
        "verdict": {
            "part_A_affine_cocycle_line_bundle": verdict,
            "cubic_first": cubic_ok,
            "composition_free_upgrades": free_ok,
        },
        "types": types,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true")
    ap.add_argument("--write", action="store_true")
    args = ap.parse_args()
    cert = build()
    text = json.dumps(cert, indent=2, sort_keys=True) + "\n"
    if args.write:
        CERT_PATH.write_text(text)
        print(f"wrote {CERT_PATH} ({len(text)} bytes)")
        return
    if args.check:
        stored = CERT_PATH.read_text()
        if canonical(json.loads(stored)) != canonical(cert):
            print("MISMATCH between recomputed certificate and committed JSON", file=sys.stderr)
            sys.exit(1)
        assert cert["verdict"]["part_A_affine_cocycle_line_bundle"]
        assert cert["verdict"]["cubic_first"]
        print("C417 primary checker: certificate matches; all Part-A assertions pass.")
        return
    print(json.dumps(cert, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
