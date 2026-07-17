# C210 a=0 stratum verification (independent re-run + re-derivation)

Date: 2026-07-17. Role: skeptical verification of (A) the six committed C210 collision-curve
scripts and (B) this session's uncommitted a=0 structural claims (scratch
`explore_a_zero.py` / `a0.sing`). No tracked file was modified.

Verification artifacts live in the session scratchpad
(`verify_pullback.py`, `verify_pullback.sing`, `deg_check*.sing`, run logs); the Singular
transcript is at
`/tmp/claude-run-quiet/20260717-150930-nix-shell-nixpkgssingular-command-Singular-q-verify_pullback.sing/stdout.log`.

## (A) Committed scripts — all re-run from a clean working tree (identical to HEAD)

| Script                                            | Exit | Key asserted numbers re-confirmed                                     | Verdict |
|---------------------------------------------------|------|-----------------------------------------------------------------------|---------|
| `analyze_c210_seed_cross_repair_curve.py`         | 0    | resultant 452 terms, bidegree (u:6, t:4), top form a^2·u^4·t^4, 24576 incidence checks | PASS |
| `analyze_c210_collision_curve_frobenius.py`       | 0    | GF(8) rational points 0, both oriented traces 1, 22-term normalized fiber | PASS |
| `analyze_c210_collision_curve_generic_factorization.py` | 0 | factorize(R): 1 factor, multiplicity 1 over GF(2)                     | PASS-WITH-CAVEAT |
| `analyze_c210_collision_curve_degree_drop.py`     | 0    | t-degree strata {a≠0: 4, a=0∧b≠0: 2, a=b=0: 0}; legal singles 35; two-layer arcs 22; trace-one arcs 12; survivors 0 | PASS |
| `analyze_c210_collision_curve_constant_height.py` | 0    | 5376 tuples, odd-factor census {both: 3174, exactly_one: 1932, neither: 270}; h0-coefficient H^2 with H=delta·p^2·(z^2+z+1); ramification = delta·p^3·(e^2+e·p+h1)·quartic | PASS |
| `analyze_c210_collision_curve_constant_height_arc.py` | 0 | same 5376/270 census; arc-legal p=1 configs 0; arc-legal survivors 0; 22 arcs / 12 trace-one / p ∈ {14,22,24}; collision-free trace-one arcs 0 | PASS |

Caveat on `generic_factorization`: its own assert proves irreducibility over GF(2) only.
The JSON conclusion "absolutely irreducible" leans on the companion certificate
`analyze_c210_collision_curve_frobenius.sing` (a degree-preserving total-degree-8 GF(8)
fiber, checked irreducible over extension degrees 1, 2, 4, 8; orbit sizes dividing 8 make
that sufficient) plus the standard degree-preserving-specialization argument. The `.py`
does not run that certificate; I ran it separately and it prints
`{"absolute_irreducible":1,"checked_extension_degrees":[1,2,4,8],"total_degree":8}`. The
chain is valid, but the conclusion is only as re-checkable as that separate `.sing` run.
Note the degree-6 a=0 fiber in `degree_drop` is degree-preserving only for the a=0 family
R0, not for the full degree-8 family; the frobenius fiber is the one that carries the
generic absolute-irreducibility claim.

Minor: `constant_height`'s JSON flags `boundary_nonzero_on_odd_scalar_extensions` and
`inseparable_divisor_odd_collision_forced` are printed literals. They are supported by
asserted structure (z^2+z+1 has roots only in GF(4), which no GF(8^odd) contains; the
h1=e^2+e·p pullback is asserted even in z with z-degree 6, hence a square of a cubic with
an odd-extension root), but the script does not assert those final inferences directly.

## (B) Scratch a=0 claims

Independent route: I rebuilt the universal resultant from the committed modules
(re-asserting `derive_quadratics == expected_quadratics`), performed the trace-one
substitution (K0, K1, c→h+g exactly as in `degree_drop.symbolic_checks`) in Singular
rather than in the scratch ring, and compared.

| # | Claim                                                                  | Verdict | Evidence |
|---|------------------------------------------------------------------------|---------|----------|
| 0 | Scratch R(u,t) is the genuine trace-one pullback of the committed resultant | PASS | Singular: pullback − scratch R = 0 (474 terms); g0/g1 cancel identically after c→h+g, so the scratch g=0 collapse is exact; `a0.sing`'s A2/A1/A0 match the independently built coefficients term-for-term (differences 0) |
| 1 | A2 = b^2·Q^2, Q = u^2+u·delta+delta^2 (perfect square)                 | PASS | Singular identity cA2 − b^2·Q^2 = 0; independently, Python leading-coefficient check `True`; generic t^4 coefficient = a^2·Q^2 also re-confirmed in Python |
| 2 | A1 = delta·b·G1·G2 with G1, G2 as stated, both irreducible over GF(2)(params) | PASS | Singular identity cA1 − delta·b·G1·G2 = 0; factorize gives each as a single multiplicity-1 factor in GF(2)[u,…]; both monic in u, so Gauss gives irreducibility over GF(2)(params) |
| 3 | A0 irreducible, degree 6 in u                                          | PASS | u-degree 6 (Python, exponent scan); Singular factorize: unit + one factor, multiplicity 1; monic-in-u content trivial, so irreducible over GF(2)(params) |
| 4 | gcd(A2,A0) = gcd(A1,A0) = 1; no common u-factor across A2, A1, A0       | PASS | Singular: gcd(A2,A0) = 1, gcd(A1,A0) = 1, gcd(gcd(A2,A1),A0) = 1. Exact detail: gcd(A2,A1) = b (u-degree 0), not 1 — a parameter factor, nonzero on the stratum, so "no common u-factor" is the correct phrasing |
| 5 | Only remaining reducibility mechanism on a=0, b≠0 is D3: φ = A0·A2/A1^2 ∈ ℘(K̄(u)) | PASS-WITH-CAVEATS | see below |

### Claim 5 assessment

The criterion itself is sound. Over F = K̄(u), char 2, with A2 ≠ 0 (holds: b ≠ 0 and Q
monic in u) and u-content trivial, Gauss reduces reducibility of R0 in K̄[u,t] to
reducibility of the quadratic in F[t]; with A1 ≠ 0 the substitution t = (A1/A2)s turns
R0/A2 into (A1/A2)^2·(s^2+s+φ), so a root in F exists iff φ = A0·A2/A1^2 ∈ ℘(F). The
mechanism trichotomy (common u-factor content / A1 ≡ 0 / Artin–Schreier triviality) is a
correct and exhaustive disjunction, and A1 ≡ 0 forces delta·b = 0 because G1, G2 are
monic in u (delta = e'+e ≠ 0 and b ≠ 0 are both excluded on the stratum, b=0 being the
already-closed a=b=0 stratum).

Caveats:

1. Attribution: A1 ≢ 0 follows from the monic-in-u factors of A1, not from A2 being a
   perfect square. The perfect square (bQ)^2 is genuine and useful downstream (even pole
   orders of φ at the zeros of Q), but it is not the reason the A1 ≡ 0 mechanism dies.
2. A1 ≡ 0 does not automatically give reducibility: A2t^2+A0 is reducible iff A0/A2 is a
   square in K̄(u). As a list of the only possible mechanisms the trichotomy stands, but
   the b=0 boundary case needs its own (already delivered) treatment, not the AS test.
3. Generic vs pointwise: the gcd computations eliminate the common-factor mechanism for
   the generic fiber (equivalently, outside a proper closed parameter locus). At special
   parameter values with delta, b ≠ 0 a common u-factor can still appear (e.g. where a
   root u = ω·delta of Q also satisfies A0 = 0), since gcd = 1 in GF(2)[params][u] does
   not specialize. Any pointwise use of the D3 reduction must either stay generic or
   handle that codimension-≥1 locus separately.
4. Geometric splitting (informational, matters for the coming pole analysis of φ): G1 and
   Q are irreducible over GF(2)(params) but split over GF(4)(params) — G1 =
   (u+p(w+ω))(u+p(w+ω^2)), Q = (u+ω·delta)(u+ω^2·delta) — every GF(4) specialization of
   G1 showed exactly 2 roots. G2 is absolutely irreducible: it is cubic and irreducible
   over GF(2)(params), so absolute reducibility would force three conjugate linear
   factors defined over GF(8)(params), monic in u with polynomial coefficients (Gauss),
   making every GF(8) specialization split; the specialization (delta,p,w) = (1,1,tau)
   has no GF(8) root. A0's absolute (K̄) factorization status was not certified here;
   only irreducibility over GF(2)(params) is established.

## Overall

Both bodies of work check out. The single load-bearing external dependency is the
frobenius `.sing` certificate behind the "absolutely irreducible" conclusions, which I
re-ran green. The scratch a=0 structure (A2 square, A1 = delta·b·G1·G2, A0 irreducible,
coprimality, D3 reduction) is exactly right at the generic-fiber level, with the
pointwise-specialization caveat above.

## Promotion (post-verification)

The verified a=0 structure no longer lives only in the tmpfs scratch checked above. It is
committed as `papers/arcs_complete_outside_conic/analyze_c210_a_zero_factorization_strata.py`
(canonical JSON output `..._output.txt`), which rebuilds the trace-one cover from the committed
resultant — not a re-transcription — and re-certifies A2 = b²·Q², A1 = δ·b·G1·G2, A0 irreducible
of u-degree 6, and gcd(A2,A1)=b, gcd(A2,A0)=gcd(A1,A0)=1 via Singular, printing the D3 reduction
together with an explicit `does_not_prove` list (the caveats above). Hashes/byte counts and the
check command are in [`2026-07-17-c210-reproducibility-manifest.md`](2026-07-17-c210-reproducibility-manifest.md)
and `analyze_c210_SHA256SUMS`.
