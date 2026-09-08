# Framed companion: specialization boundary and F1 counterexample

**Lane:** cubic-threefolds. **Date:** 2026-09-08.
**Scope:** author-requested editing memo for the framed-monodromy companion;
no separate discovery paper, primary-manuscript theorem change, or cross-lane
application. C978/C956 remain open.
**Status:** independent calculation, source-only gate and companion build
pass. Rendered companion inspected (22 pages, previously 20; 193126 bytes).
Local export pending.

## Mathematical result and independent audit

The supplied strictly admissible F1 map Q^f=-27t², Q^s=16t has nu6=2;
independent divisor tagging gives nu6=0. It is not graded-monomial: the
initial images -27t² and 256t² are distinct proportional vectors. This
refutes unrestricted T, not its actual-center restriction.

The independent checker reconstructs Euler multiplication from the quotient
relations S²+SF=u, F²=wS by Gröbner reduction over Q(u,w), using the fixed
cohomology basis (1,F,S,p) with p=SF+wS. It does not seed the supplied
multiplication matrices or use the supplied splitting basis. The grading is
D=diag(1,0,0,-1). The moving-basis change is I-wE34, whose conjugated grading
has (3,4) entry -w. Fixed-basis multiplication and grading obey the Frobenius
pairing identities against the classical Poincaré matrix.

At t=1 the polynomial projector
E=(U²-20U+612I)/1296 is idempotent of rank two with (U+18I)E=0.
Compression yields R=[[-1/18,4/3],[1/54,1/18]], R²=I/36 and trace R=0.
Projector traces independently give trace(ED)=0 and trace(EDED)=1/18.
The supplied nullspace/complement calculation reproduces the same residue.
The noncolliding rank-one residues vanish; this is also checked through
trace(U^j D)=0 for j=0,...,3. Parameter scaling is independent of the loop
coordinate, so introduces no z-derivative correction. Formal splitting and
removal of the scalar irregular factor give the claimed exponents and
(x-1)²(x²-x+1) for framed monodromy. The tagged collision factor is
6912t²(exp(2 beta)-exp(alpha)), nonzero generically.

## Invocation audit and scope

- Hypothesis T now quantifies only over the actual remaining surface-center
  maps Q_T^d -> Q^{i_*d}u^{rho_T.d} from the blowup comparisons in dimensions
  at most four, in their stated coefficient completions and faithful field
  extensions. It permits no arbitrary additional Novikov specialization.
- The divisor-tagging lemma now selects that same class. Its proof of
  faithful tagged coefficient transport is unconditional; setting tags to
  zero is the separately hypothesized step.
- Low-dimensional vanishing retains the original broad classes for direct
  cases, but requires actual center maps for surfaces neither minimal nor
  geometrically ruled. The birational-invariance proof supplies exactly
  these maps. The introductory obstruction and genus-eight application use
  that conditional theorem and retain both R and restricted T.
- Nef-canonical targets, P1, P2 and the stated rational ruled cases remain
  unconditional; positive-genus ruled surfaces still require R alone.
  The direct F1 case requires graded monomiality. No general surface theorem
  is deduced from graded monomiality alone.
- The counterexample's repeated block is scalar. It does not satisfy the
  nonzero-nilpotent condition of the primary paper or cyclic persistence.
- Formal monodromy is distinguished from full analytic monodromy involving
  Stokes matrices. The unresolved target is a geometrically checkable
  actual-center specialization criterion controlling permitted collisions;
  resolving it would not resolve R.

## Attribution and evidence

Reyes, SIGMA 19 (2023), 092, Proposition 5.3 and the preceding formal
normal form (5.6), supplies the I2(m) exponents ±(m-2)/(2m), giving ±1/6
at m=3. The published page 13 was inspected. His Theorem 6.6 concerns motion
along a caustic, not specialization onto it from the complement. The
companion gives a direct calculation and does not claim a new general
collision phenomenon or assert all geometric hypotheses of Reyes for F1.
Inverting his coordinate at infinity exchanges the signs of this unordered
pair and does not change the comparison.

Source: https://sigma-journal.com/2023/092/sigma23-092.pdf
Cache key arXiv:2209.01062; published PDF SHA-256
`deb2b3a0f92cdde39baabc9d7cb5e5a2238c7717f2d47847e0170b0b49280cac`.
The cached text and page image support citation inspection, not a novelty audit.

Author-supplied ZIP: `/home/tavis/Downloads/framed_monodromy_specialization_checks.zip`,
5837 bytes; SHA-256
`5472122eded08155674804492d4f92a8f6f39aaaa81635582ccc5c4c87d12555`.
Its checker was replayed and the output matches the ZIP's recorded JSON.
The task-owned quantum calculations also agree with the independent checker.
Unrelated material in the supplied archive is not imported into the companion.

From `papers/cubic-stabilization-m1`, replay:

```
uv run --with sympy==1.14.0 python verification/framed_specialization.py --check
python3 lean/verification/check_formal_artifact.py --source-only
make -C companions/cubic-framed-monodromy check \
  TEXSHELL="nix develop --offline ../../..#manuscript --command" PYTHON=python3
```

The committed independent script is 4048 bytes; its JSON is 1902 bytes.
Their SHA-256 hashes are in `verification/framed_specialization.sha256`.
Exact finite rational algebra is checked; quantum input, strict admissibility
and formal classification are justified in the manuscript. No Lean kernel is
run and no formalization of the new proposition is claimed. The existing
conditional terminals remain conditional; the new proposition is registered
as absent. Shared coverage is 67 claims, 14 absent, 26 fragmentary,
26 conditional and 1 complete; the primary paper's own coverage is unchanged.

## ej + tt and Mystery ledger

Rendered inspection also corrected two overfull lines and gave the actual
center-map, counterexample-monodromy and revised low-dimensional-vanishing
displays numbered equation environments, so their references resolve to
displays rather than surrounding theorem or section counters.

The focused independent pass settles the plausible grading/basis error and
checks the projector without relying on the supplied splitting basis. The
quantifier audit also repairs the two downstream statements that would have
remained too broad after narrowing T alone. No additional incidental claim
is promoted. Remaining mysteries are exactly the existing research gates:
which collisions actual remaining center maps permit (restricted T), and
reconstruction-tail invariance (R). Neither the counterexample nor its
finite checker resolves either gate.
