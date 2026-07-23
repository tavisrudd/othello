#!/usr/bin/env python3
"""Independent replay for C501.

Distinct routes used here:
* reconstruct H from its incidence block and enumerate all 3^12 vectors for kernels;
* build PSL_2(11) directly on P^1(F_11), enumerate its A5 six-set stabilizers, and
  fuse the two classes with the explicit nonsquare-determinant map x -> 2x;
* count invariant form dimensions by signed orbits of ordered coordinate pairs;
* verify the C472 loop fixes the kernel subspace directly, without Witt reduction.

Run from /home/tavis/src/othello:
  python3 notes/2026-07-22-c501-hexad-outer-bit-explore-replay.py
"""
from collections import deque
import itertools
import json
import os

HERE = os.path.dirname(os.path.abspath(__file__))
C471_PATH = os.path.join(HERE, "2026-07-22-c471-hadamard-degeneration-complex.json")
C472_PATH = os.path.join(HERE, "2026-07-22-c472-signed-weil-lift.json")
CERT_PATH = os.path.join(HERE, "2026-07-22-c501-hexad-outer-bit-explore.json")
P = 3
N = 12
ID = tuple(range(N))


def rref(rows):
    rows = [[x % P for x in row] for row in rows if any(x % P for x in row)]
    if not rows:
        return []
    r = 0
    for c in range(len(rows[0])):
        pivot = next((i for i in range(r, len(rows)) if rows[i][c]), None)
        if pivot is None:
            continue
        rows[r], rows[pivot] = rows[pivot], rows[r]
        z = pow(rows[r][c], -1, P)
        rows[r] = [(z * x) % P for x in rows[r]]
        for i in range(len(rows)):
            if i != r and rows[i][c]:
                z = rows[i][c]
                rows[i] = [(x - z * y) % P for x, y in zip(rows[i], rows[r])]
        r += 1
    return rows[:r]


def matvec(A, v, modulus=None):
    out = [sum(row[j] * v[j] for j in range(len(v))) for row in A]
    return [x % modulus for x in out] if modulus else out


def mm(A, B):
    return [[sum(A[i][k] * B[k][j] for k in range(len(B)))
             for j in range(len(B[0]))] for i in range(len(A))]


def transpose(A):
    return [list(row) for row in zip(*A)]


def pcompose(a, b):
    return tuple(a[b[i]] for i in range(len(a)))


def pinverse(p):
    out = [0] * len(p)
    for i, j in enumerate(p):
        out[j] = i
    return tuple(out)


def pgroup(gens):
    out = {ID}
    queue = deque([ID])
    while queue:
        x = queue.popleft()
        for g in gens:
            y = pcompose(g, x)
            if y not in out:
                out.add(y)
                queue.append(y)
    return out


def porder(p):
    x = ID
    for k in range(1, 100):
        x = pcompose(p, x)
        if x == ID:
            return k
    raise AssertionError("order bound")


def action(p, support):
    return frozenset(p[i] for i in support)


def conjugacy_class(group, subgroup):
    return {
        frozenset(pcompose(pcompose(g, h), pinverse(g)) for h in subgroup)
        for g in group
    }


def signed_compose(left, right):
    lp, lm = left
    rp, rm = right
    mask = rm
    for old in range(N):
        if (lm >> rp[old]) & 1:
            mask ^= 1 << old
    return tuple(lp[rp[i]] for i in range(N)), mask


def signed_action(element, v):
    p, mask = element
    out = [0] * N
    for i in range(N):
        out[p[i]] = ((2 if (mask >> i) & 1 else 1) * v[i]) % P
    return out


def pair_orbit_form_dimension(gens, alternating):
    """Dimension of invariant (alternating) forms via signed pair-orbit propagation."""
    unseen = {(i, j) for i in range(N) for j in range(N)}
    dimension = 0
    while unseen:
        start = min(unseen)
        values = {start: 1}
        queue = deque([start])
        consistent = True
        while queue:
            i, j = queue.popleft()
            transforms = []
            for p, mask in gens:
                factor = (2 if (mask >> i) & 1 else 1) * (2 if (mask >> j) & 1 else 1) % P
                transforms.append(((p[i], p[j]), factor))
            if alternating:
                transforms.append(((j, i), 2))
            for target, factor in transforms:
                target_value = values[(i, j)] * factor % P
                if target in values:
                    if values[target] != target_value:
                        consistent = False
                else:
                    values[target] = target_value
                    queue.append(target)
        unseen -= set(values)
        if consistent and not (alternating and any(i == j for i, j in values)):
            dimension += 1
    return dimension


def projective_permutation(a, b, c, d):
    """Mobius action on 0..10 plus infinity=11."""
    out = []
    for x in range(11):
        denominator = (c * x + d) % 11
        out.append(11 if denominator == 0 else (a * x + b) * pow(denominator, -1, 11) % 11)
    out.append(11 if c == 0 else a * pow(c, -1, 11) % 11)
    assert len(set(out)) == 12
    return tuple(out)


def main():
    C471 = json.load(open(C471_PATH))
    C472 = json.load(open(C472_PATH))
    cert = json.load(open(CERT_PATH))

    # Rebuild H from the incidence block, without using the recorded H as input.
    A = C471["integral_matrix_factorization"]["incidence_matrix_A"]
    H = [[1] * 12] + [
        [1 - 2 * A[i][j] for j in range(11)] + [-1] for i in range(11)
    ]
    assert H == C471["integral_matrix_factorization"]["hadamard_matrix_H"]
    Ht = transpose(H)

    # Brute-force the complete ambient vector space instead of null-space elimination.
    K1, K2 = [], []
    for v in itertools.product(range(P), repeat=N):
        if not any(matvec(H, v, P)):
            K1.append(v)
        if not any(matvec(Ht, v, P)):
            K2.append(v)
    assert len(K1) == len(K2) == 729
    set1, set2 = set(K1), set(K2)
    common = set1 & set2
    assert len(common) == 3
    shared = min(v for v in common if any(v))
    hexad = frozenset(i for i, x in enumerate(shared) if x)
    assert sorted(hexad) == cert["leg0_canonicity"]["hexad"]

    pure = C472["full_preimage"]["literal_complement_generators"]
    T = tuple(pure["T"]["permutation"])
    S = tuple(pure["S"]["permutation"])
    Gamma = pgroup([T, S])
    assert len(Gamma) == 660

    # Re-derive row transport and the opposite stabilizer class.
    def row_permutation(g):
        R = [[0] * N for _ in range(N)]
        for i in range(N):
            R[g[i]][i] = 1
        Mnum = mm(mm(H, R), Ht)
        M = [[x // 12 for x in row] for row in Mnum]
        out = []
        for j in range(N):
            nz = [i for i in range(N) if M[i][j]]
            assert len(nz) == 1 and abs(M[nz[0]][j]) == 1
            out.append(nz[0])
        return tuple(out)

    rho = {g: row_permutation(g) for g in Gamma}
    col_stab = frozenset(g for g in Gamma if action(g, hexad) == hexad)
    row_stab = frozenset(g for g in Gamma if action(rho[g], hexad) == hexad)
    col_class = conjugacy_class(Gamma, col_stab)
    row_class = conjugacy_class(Gamma, row_stab)
    assert len(col_stab) == len(row_stab) == 60
    assert len(col_class) == len(row_class) == 11 and row_stab not in col_class

    hexads = {
        frozenset(i for i, x in enumerate(v) if x)
        for v in set1 if sum(bool(x) for x in v) == 6
    }
    fixed = [h for h in hexads if all(action(g, h) == h for g in col_stab)]
    opposite_fixed = [h for h in hexads if all(action(g, h) == h for g in row_stab)]
    assert len(fixed) == 2 and fixed[0] == frozenset(set(range(N)) - fixed[1])
    assert not opposite_fixed

    # Completely separate PSL_2(11) model on P^1 and the PGL outer element x -> 2x.
    translation = projective_permutation(1, 1, 0, 1)
    inversion = projective_permutation(0, -1, 1, 0)
    PSL = pgroup([translation, inversion])
    assert len(PSL) == 660
    involutions = [g for g in PSL if porder(g) == 2]
    order_three = [g for g in PSL if porder(g) == 3]
    a5_subgroups = set()
    for a in involutions:
        for b in order_three:
            if porder(pcompose(a, b)) == 5:
                subgroup = frozenset(pgroup([a, b]))
                if len(subgroup) == 60:
                    a5_subgroups.add(subgroup)
    assert len(a5_subgroups) == 22
    first = min(a5_subgroups, key=lambda H5: tuple(sorted(H5)))
    class1 = conjugacy_class(PSL, first)
    second = next(H5 for H5 in a5_subgroups if H5 not in class1)
    class2 = conjugacy_class(PSL, second)
    assert len(class1) == len(class2) == 11 and class1 | class2 == a5_subgroups
    delta = projective_permutation(2, 0, 0, 1)
    assert delta not in PSL
    assert {pcompose(pcompose(delta, g), pinverse(delta)) for g in PSL} == PSL
    delta_first = frozenset(pcompose(pcompose(delta, g), pinverse(delta)) for g in first)
    assert delta_first in class2

    # Recompute the central word and verify that every partial image is literally K1.
    gluing = C472["two_parent_signed_gluing"]
    gens = [
        (tuple(g["permutation"]), g["sign_mask"])
        for parent in ("coordinate_oriented_parent", "row_oriented_parent")
        for g in gluing[parent]["generators"]
    ]
    current = (ID, 0)
    fixed_steps = 0
    for index in gluing["central_witness_word_generator_indices"]:
        current = signed_compose(gens[index], current)
        image = {tuple(signed_action(current, v)) for v in K1}
        fixed_steps += image == set1
    assert fixed_steps == 8
    assert current == (ID, 4095)
    assert cert["leg3_central_scalar"]["distinct_quotient_lagrangians"] == 1
    assert cert["leg3_central_scalar"]["loop_witt_class"] == 0

    # Pair-orbit propagation is independent of the primary linear-equation solver.
    bilinear_dim = pair_orbit_form_dimension(gens, alternating=False)
    alternating_dim = pair_orbit_form_dimension(gens, alternating=True)
    frozen_alt_dim = pair_orbit_form_dimension([(T, 0), (S, 0)], alternating=True)
    assert (bilinear_dim, alternating_dim, frozen_alt_dim) == (1, 0, 1)
    assert bilinear_dim == cert["leg3_central_scalar"]["full_signed_invariant_bilinear_dimension"]
    assert alternating_dim == cert["leg3_central_scalar"]["full_signed_invariant_alternating_dimension"]

    print("OK: independent C501 replay")
    print("brute-force kernel sizes:", len(K1), len(K2), "shared-line vectors:", len(common))
    print("P^1 model A5 classes:", len(class1), "+", len(class2), "fused by x -> 2x")
    print("central loop: 8/8 partial images fix ker(H); Witt class 0 versus scalar -1")
    print("signed pair-orbit invariant dimensions:", bilinear_dim, alternating_dim)


if __name__ == "__main__":
    main()
