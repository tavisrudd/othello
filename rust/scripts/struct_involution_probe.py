#!/usr/bin/env python3
"""Offline GO/NO-GO: generalized STRUCTURAL-INVOLUTION pairing certificate (graph-theory lever #5).

A Node-Kayles position is a 2nd-player (P / nimber-0) win if its conflict graph G admits a
fixed-point-free involutive AUTOMORPHISM tau with v !~ tau(v) for all v.

Certificate soundness (pairing-strategy argument):
  - tau is an automorphism of G  => deleting a tau-symmetric set leaves a tau-symmetric graph.
  - tau is fixed-point-free involution (tau^2 = id, tau(v) != v)  => vertices pair up perfectly.
  - v !~ tau(v) for all v  => when P1 plays v (deleting N[v]), tau(v) is NOT in N[v], so it is
    still AVAILABLE; P2 plays tau(v), deleting N[tau(v)] = tau(N[v]).  The union N[v] U N[tau(v)]
    is tau-symmetric, so the remaining graph is again tau-symmetric and the SAME tau (restricted)
    is a valid certificate.  By induction P2 always has a reply => P2 makes the last move => P-win.

This is a SUFFICIENT condition (genuine winning strategy), cross-checked: EVERY graph where tau is
found MUST have nimber 0 (verified vs nk_solve).  We also report how often N-positions (nimber!=0)
admit such a tau (must be ~never; otherwise the condition is buggy/too weak).

Usage: struct_involution_probe.py [/tmp/qhk-n14.bin] [--pc-lo 18] [--pc-hi 28]
                                   [--per-band 400] [--cap 4000000] [--selftest]
"""
import sys, random, itertools
from collections import defaultdict

# reuse the validated substrate
sys.path.insert(0, "/home/tavis/src/othello/rust/scripts")
from treewidth_dp_probe import load, build_graph, nk_solve, bits_to_squares  # noqa: E402


# ---------------------------------------------------------------- tau search
def find_pairing_involution(m, adj, node_budget=2_000_000):
    """Search for a fixed-point-free involutive automorphism tau with v !~ tau(v) for all v.

    Returns the partner array tau (list of len m, tau[v]=partner) or None.

    Strategy: backtracking perfect-matching of vertices into UNORDERED pairs {v,w} subject to
      (1) w !~ v                                  (non-adjacency, the certificate constraint)
      (2) deg(v) == deg(w)                        (necessary for an automorphism)
      (3) the induced pairing is a graph automorphism: for any two pairs {v,w},{x,y},
          v~x  iff  w~y   AND   v~y  iff  w~x.    (tau is an automorphism)
    We enforce (3) incrementally: when pairing {v,w}, check consistency against all already-fixed
    pairs.  This is exactly the condition that the permutation swapping each pair is an automorphism.
    """
    if m % 2 == 1:
        return None  # odd order => no fixed-point-free involution
    adjset = [set() for _ in range(m)]
    for i in range(m):
        a = adj[i]
        while a:
            b = a & -a
            adjset[i].add(b.bit_length() - 1)
            a ^= b
    deg = [len(adjset[i]) for i in range(m)]

    # candidate partners for each v: non-adjacent, equal degree, v != w
    cand = [None] * m
    for v in range(m):
        c = [w for w in range(m)
             if w != v and deg[w] == deg[v] and w not in adjset[v]]
        cand[v] = set(c)
        if not c:
            return None  # v has no possible partner => impossible

    partner = [-1] * m

    def consistent(v, w):
        # swapping {v,w} must be an automorphism w.r.t. all already-fixed pairs {x,y=partner[x]}.
        # For the involution sigma that swaps v<->w and x<->y (and is id elsewhere so far),
        # adjacency must be preserved between {v,w} and {x,y}:
        #   v~x  iff  w~y    and    v~y  iff  w~x
        # Also self-consistency of the new pair vs itself is trivial (v!~w enforced already; and
        # sigma maps edge (v,w)->(w,v) which is fine).
        wv = adjset[v]; ww = adjset[w]
        for x in range(m):
            y = partner[x]
            if y < 0 or x > y:  # consider each fixed pair once (x<y), skip unfixed
                continue
            ax = adjset[x]; ay = adjset[y]
            # v~x iff w~y
            if (x in wv) != (y in ww):
                return False
            # v~y iff w~x
            if (y in wv) != (x in ww):
                return False
        return True

    budget = [node_budget]

    def backtrack():
        budget[0] -= 1
        if budget[0] <= 0:
            return False
        # pick the unmatched vertex with fewest remaining candidates (MRV)
        v = -1
        best = None
        for u in range(m):
            if partner[u] != -1:
                continue
            avail = [w for w in cand[u] if partner[w] == -1]
            if best is None or len(avail) < best:
                best = len(avail); v = u
                if best == 0:
                    return False  # dead end
        if v == -1:
            return True  # all matched
        for w in [x for x in cand[v] if partner[x] == -1]:
            if not consistent(v, w):
                continue
            partner[v] = w; partner[w] = v
            if backtrack():
                return True
            partner[v] = -1; partner[w] = -1
        return False

    if backtrack():
        return partner[:]
    return None


def verify_certificate(m, adj, tau):
    """Independently re-verify tau is a fixed-point-free involutive automorphism with v!~tau(v)."""
    if tau is None:
        return False
    if len(tau) != m:
        return False
    adjset = [set() for _ in range(m)]
    for i in range(m):
        a = adj[i]
        while a:
            b = a & -a; adjset[i].add(b.bit_length() - 1); a ^= b
    for v in range(m):
        w = tau[v]
        if w == v:            # fixed point
            return False
        if tau[w] != v:       # involution
            return False
        if w in adjset[v]:    # adjacency (non-adjacency constraint v !~ tau(v))
            return False
    # automorphism: edge (u,v) exists iff edge (tau[u],tau[v]) exists
    for u in range(m):
        for v in adjset[u]:
            if tau[v] not in adjset[tau[u]]:
                return False
    return True


# ---------------------------------------------------------------- self-test of the certificate logic
def cert_selftest():
    rnd = random.Random(2024)
    # 1) cross-check: on random graphs, EVERY found tau => nimber 0 (soundness), and verifier agrees.
    found_total = 0
    p_with_tau = 0
    n_with_tau = 0
    for _ in range(4000):
        k = rnd.choice([2, 4, 6, 8])
        adj = [0] * k
        for i in range(k):
            for j in range(i + 1, k):
                if rnd.random() < rnd.choice([0.2, 0.35, 0.5]):
                    adj[i] |= 1 << j; adj[j] |= 1 << i
        tau = find_pairing_involution(k, adj)
        if tau is not None:
            assert verify_certificate(k, adj, tau), ("verifier rejects found tau", adj, tau)
            found_total += 1
            win, nim, *_ = nk_solve(k, adj, 1 << 22)
            assert nim == 0, ("SOUNDNESS VIOLATION: tau found but nimber!=0", adj, tau, nim)
            p_with_tau += 1
        else:
            win, nim, *_ = nk_solve(k, adj, 1 << 22)
            if nim != 0:
                n_with_tau += 0  # correctly no tau for an N-position
    print(f"cert_selftest: random graphs, tau found {found_total}x, ALL had nimber 0 (sound). OK")

    # 2) constructed positive: two disjoint copies of P3 (a-b-c) + (d-e-f). tau = (a d)(b e)(c f)?
    #    a~b,b~c ; d~e,e~f. tau swap a<->d,b<->e,c<->f. v!~tau(v): a!~d (yes), b!~e (yes), c!~f (yes).
    #    automorphism: a~b -> d~e (yes). nimber of P3 (+) P3 = 2 xor 2 = 0. Should FIND tau.
    P3P3 = [0b000010, 0b000101, 0b000010, 0b010000, 0b101000, 0b010000]
    tau = find_pairing_involution(6, P3P3)
    assert tau is not None and verify_certificate(6, P3P3, tau), ("expected tau on P3+P3", tau)
    assert nk_solve(6, P3P3, 1 << 20)[1] == 0
    print("cert_selftest: P3(+)P3 (disjoint mirror) certificate found, nimber 0. OK")

    # 3) constructed negative: single edge K2 has nimber 1 (N). tau would pair a<->b but a~b -> rejected.
    K2 = [0b10, 0b01]
    assert find_pairing_involution(2, K2) is None, "K2 must have NO certificate (adjacent pair)"
    assert nk_solve(2, K2, 1 << 10)[1] == 1
    print("cert_selftest: K2 (adjacent) correctly has NO certificate, nimber 1 (N). OK")

    # 4) two isolated vertices: nimber 0, tau pairs them (non-adjacent). Should FIND.
    II = [0, 0]
    tau = find_pairing_involution(2, II)
    assert tau is not None and verify_certificate(2, II, tau)
    assert nk_solve(2, II, 1 << 10)[1] == 0
    print("cert_selftest: 2 isolated vertices certificate found, nimber 0. OK")
    print("ALL cert self-tests PASSED")


# ---------------------------------------------------------------- main measurement
def main():
    args = sys.argv[1:]
    if "--selftest" in args:
        cert_selftest()
        if len(args) == 1:
            return
        args = [a for a in args if a != "--selftest"]

    def argval(flag, default, cast=int):
        return cast(args[args.index(flag) + 1]) if flag in args else default

    path = next((a for a in args if not a.startswith("--") and
                 (args.index(a) == 0 or args[args.index(a) - 1] not in
                  ("--pc-lo", "--pc-hi", "--per-band", "--cap"))), "/tmp/qhk-n14.bin")
    pc_lo = argval("--pc-lo", 18)
    pc_hi = argval("--pc-hi", 28)
    per_band = argval("--per-band", 400)
    cap = argval("--cap", 4_000_000)

    n, recs = load(path)
    # unique graphs by avail tuple within the deep-tail band
    seen = set()
    bands = defaultdict(list)
    for key, avail, pc, hit in recs:
        if not (pc_lo <= pc <= pc_hi):
            continue
        if avail in seen:
            continue
        seen.add(avail)
        bands[pc].append(avail)

    rnd = random.Random(7)
    chosen = []
    for pc in sorted(bands):
        lst = bands[pc][:]
        rnd.shuffle(lst)
        for avail in lst[:per_band]:
            chosen.append((avail, pc))

    print(f"# n={n} records={len(recs)} unique deep graphs pc[{pc_lo}..{pc_hi}]="
          f"{sum(len(v) for v in bands.values())} sampled={len(chosen)} cap={cap:,}")

    # per-band stats
    # P = nimber 0, N = nimber != 0, U = nimber uncomputed (alpha-beta only, no full nimber)
    stat = defaultdict(lambda: {"P": 0, "N": 0, "U": 0,
                                "P_fire": 0, "N_fire": 0, "U_fire": 0,
                                "cnt": 0})
    sound_violations = []
    n_fires_total = 0

    for avail, pc in chosen:
        m, adj = build_graph(avail, n)
        tau = find_pairing_involution(m, adj)
        fired = tau is not None
        if fired:
            assert verify_certificate(m, adj, tau), ("verifier rejects own tau", pc, avail)
            n_fires_total += 1

        win, nimber, n_full, n_ab, ab_of, nim_skip = nk_solve(m, adj, cap)

        st = stat[pc]; st["cnt"] += 1
        if nimber is None:
            cls = "U"
        elif nimber == 0:
            cls = "P"
        else:
            cls = "N"
        st[cls] += 1
        if fired:
            st[cls + "_fire"] += 1
            # SOUNDNESS: a fire on a known N-position is a fatal bug
            if cls == "N":
                sound_violations.append((pc, m, nimber, avail))

    # ---- report ----
    print("\n=== SOUNDNESS CROSS-CHECK ===")
    if sound_violations:
        print(f"!!! {len(sound_violations)} SOUNDNESS VIOLATIONS (tau fired on nimber!=0) !!!")
        for pc, m, nim, av in sound_violations[:10]:
            print(f"    pc={pc} m={m} nimber={nim}")
        print("CERTIFICATE IS UNSOUND - condition is WRONG.")
    else:
        print("PASS: every tau-fire occurred on a nimber-0 (P) position (where nimber was computable).")
        # also report fires on U (uncomputed-nimber) positions: these are deep, nimber not validated
        u_fires = sum(s["U_fire"] for s in stat.values())
        print(f"      (tau fired on {u_fires} positions whose full nimber was too big to validate "
              f"directly; these are claimed P-wins by the certificate.)")

    print("\n=== NON-VACUITY (N-positions admitting tau) ===")
    n_total = sum(s["N"] for s in stat.values())
    n_fire = sum(s["N_fire"] for s in stat.values())
    print(f"N-positions (nimber!=0, computable): {n_total}; admitting tau: {n_fire} "
          f"({100.0 * n_fire / n_total if n_total else 0:.4f}%)  [should be 0]")

    print("\n=== FIRE-RATE among P-positions (nimber 0, computable) by pc band ===")
    print(f"{'pc':>3} {'cnt':>5} {'P':>5} {'P_fire':>7} {'fire%(P)':>9} "
          f"{'N':>5} {'N_fire':>7} {'U':>5} {'U_fire':>7}")
    tot_P = tot_Pf = 0
    for pc in sorted(stat):
        s = stat[pc]
        pr = 100.0 * s["P_fire"] / s["P"] if s["P"] else float('nan')
        tot_P += s["P"]; tot_Pf += s["P_fire"]
        print(f"{pc:>3} {s['cnt']:>5} {s['P']:>5} {s['P_fire']:>7} {pr:>8.2f}% "
              f"{s['N']:>5} {s['N_fire']:>7} {s['U']:>5} {s['U_fire']:>7}")
    overall = 100.0 * tot_Pf / tot_P if tot_P else float('nan')
    print(f"\nOVERALL P-fire-rate (computable-nimber P-positions): {tot_Pf}/{tot_P} = {overall:.2f}%")

    # combined view counting U-fires as claimed P-wins (certificate is sound, so they ARE P)
    all_fire = n_fires_total
    all_pos = len(chosen)
    print(f"Total tau-fires (all classes): {all_fire}/{all_pos} = {100.0*all_fire/all_pos:.2f}% of sampled deep positions")

    print("\n=== VERDICT ===")
    if sound_violations:
        print("NO-GO (UNSOUND): fix the certificate condition before any further investigation.")
    elif overall >= 10.0:
        print(f"GO: structural pairing fires on {overall:.1f}% of deep P-positions (>= ~10-20% bar). "
              f"vs #9 geometric <0.001%.")
    elif overall < 1.0:
        print(f"NO-GO: fires on only {overall:.2f}% of deep P-positions (< ~1% bar).")
    else:
        print(f"MARGINAL: {overall:.2f}% of deep P-positions (between 1% and 10%). Borderline.")


if __name__ == "__main__":
    main()
