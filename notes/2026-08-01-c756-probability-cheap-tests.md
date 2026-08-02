# C756 — probability/information cheap-test portfolio

**Lane**: `clebsch` · **Date**: 2026-08-01 · **Scope**: bounded diagnostics, research only

## Verdict

All five parked probability/information tests have now run in the promised EV
order.  Three cheap mechanisms close negative, one survives, and one produces
a mixed but concrete global-algebraic signal:

| test | bounded verdict | consequence |
|---|---|---|
| saturated-internal entropic uncertainty / additive energy | **negative as a new mechanism** | the (q=5) frame is an exact Paley eigenvector, but is not an entropic-uncertainty equality case; the zero residual merely restates coherence |
| global split-polynomial support | **mixed positive** | unexpected low-degree missing-set curves occur at (q=13,29,31), but not uniformly through degree 10 |
| Lloyd/Delsarte multiplicity moments | **closed negative at degree two** | an exact integer covering profile exists at the first live boundary ((q,k)=(53,12)) |
| resultant-sign prefix entropy | **survives** | extension counts collapse to a small catalogue on every tested maximum witness; the latent geometry of the catalogue is not identified |
| local (K_4/K_5) character cumulants | **closed negative as a uniform local route** | edge mutual information is tiny, and the known (q=11) hexagon supplies every all-negative five-subset forbidden at (q=5,7) |

None of these tests proves a new impossibility theorem.  The clean masked
direction target `h >= 1` remains primary.  The two survivors say where a
global proof might live: the missing-set support of the split chord product,
and a structured container explaining the compressed prefix extension counts.

Evidence: `notes/2026-08-01-c756-probability-cheap-tests.py` and
`notes/2026-08-01-c756-probability-cheap-tests.json`.

## 1. Saturated-internal uncertainty — no new lever

Scope: every character candidate in the independent prime-field enumeration
at (q=5,7,11,19,23), respectively (2,5,28,55,39) candidates.  For each
candidate all (2^k) conjugation orientations were checked.  The selected
orientation minimizes the number of violated coherent-pair signs; its signed
indicator `x = 1_Z - 1_{Z^q}` was then measured for:

- the entropic uncertainty gap
  \(H(|x|^2)+H(|\widehat x|^2)-2\log q\);
- additive energy and sumset size of `Z union Z^q`;
- exact residual from the two Paley adjacency conventions.

| (q) | candidates | minimum coherence violations | uncertainty gap range (nats) | normalized energy range |
|---:|---:|---:|---:|---:|
| 5  | 2  | 0 | 0.9400 | 0.3906 |
| 7  | 5  | 2 | 1.4393 | 0.3180 |
| 11 | 28 | 4--6 | 1.7431--2.0276 | 0.2106--0.2748 |
| 19 | 55 | 19--20 | 2.3200--2.6290 | 0.1257--0.1505 |
| 23 | 39 | 28--30 | 2.4914--2.8097 | 0.1132--0.1191 |

Both (q=5) frames have zero nonsquare-Paley eigen-residual, exactly as the
balance theorem predicts.  Every other candidate has positive residual.  This
is an excellent consistency check but not an independent obstruction:
zero residual is simply the already-proved coherent double-clique condition in
Fourier clothing.  More importantly, the positive example's uncertainty gap is
already (0.94) nats, not equality or a visibly vanishing stability regime.
Normalized additive energy falls smoothly with (q) among the incoherent
candidates rather than exposing another discrete equality.

**Verdict:** kill the proposed entropic-uncertainty equality attack.  Retain
Fourier support only as a language for classifying exact coherent eigenvectors;
it supplies no cheaper inequality than coherence itself.

## 2. Global split support — a real but nonuniform signal

For the maximum-coverage extremal witness in every audited prime field
`q >= 13`, let `S_A` be the off-conic points missed by all chord lines.  The
test computes the homogeneous evaluation rank of `S_A` in every degree
1 through 10.  A rank defect means that `S_A` lies on more low-degree curves
than a generic set of the same size.  It also records the full line-intersection
profile.

| q | `|S_A|` | `|S_A|/q` | max points on a line | first unexpected Hilbert defect |
|---:|---:|---:|---:|---:|
| 13 | 24  | 1.85 | 4  | degree 4 |
| 17 | 84  | 4.94 | 10 | degree 10 |
| 19 | 120 | 6.32 | 10 | degree 10 |
| 23 | 97  | 4.22 | 8  | none through 10 |
| 29 | 50  | 1.72 | 5  | degree 7 |
| 31 | 60  | 1.94 | 6  | degree 6 |
| 37 | 260 | 7.03 | 14 | none through 10 |
| 41 | 280 | 6.83 | 15 | none through 10 |
| 43 | 356 | 8.28 | 18 | none through 10 |

The strongest rows are (q=13,29,31): the first rank defects are respectively
one-dimensional in degrees (4,7,6), well before cardinality alone forces a
vanishing polynomial.  The signal is not uniform: (q=23,37,41,43) have the
generic Hilbert function throughout the tested range, while the defects at
(q=17,19) appear only at the final tested degree and are therefore a weaker
signal than the earlier (q=13,29,31) defects.

**Verdict:** promote only a bounded follow-up: extract and factor the first
kernel polynomials at (q=13,29,31), then test whether their components are
canonically determined by (A), the conic, or the chord arrangement.  If the
curves are accidental or do not recur, kill the split-support route.  This does
not support the now-refuted claim that every extremal external clique is a
near-cover.

## 3. Lloyd moments — exact integer falsifier

Let `N_j` count off-conic points on exactly `j` chord lines of the original
`k`-arc, and let `b = binom(k,2)`.  Any covering profile satisfies

\[
 \sum_jN_j=q^2,\qquad
 \sum_jjN_j=b(q+1),\qquad
 \sum_j\binom j2N_j=\binom b2,\qquad N_0=0. \tag{1}
\]

The last identity holds because every pair of external chord lines meets at an
off-conic point.  At the first live boundary ((q,k)=(53,12)), hence (b=66),
the following nonnegative integer profile satisfies (1) exactly and contains
the twelve forced arc vertices of multiplicity (k-1=11):

\[
       N_1=2502,\qquad N_2=210,\qquad N_6=85,\qquad N_{11}=12.
\]

It gives totals (2809,3564,2145), exactly
`q^2`, `b(q+1)`, and `binom(b,2)`.

**Verdict:** no quadratic Lloyd/Delsarte polynomial using only the two universal
incidence moments can force (N_0>0).  This route is closed at degree two.
Reopening it requires a genuinely new exact higher-concurrency identity, not a
stronger optimization of the same moment data.

## 4. Prefix entropy — compressed, latent state unknown

For one exact maximum witness at each
`q in {13,19,29,31,41,43}`, every subset of the witness was used as a
prefix state.  Its extension count is the number of off-conic points that
preserve both pairwise conic externality and general position.  At each depth
the test records the entire extension-count distribution.

The count catalogue is much smaller than the set of prefixes.  Representative
middle-depth rows:

| (q) | depth | subsets | distinct extension counts | range | coefficient of variation |
|---:|---:|---:|---:|---:|---:|
| 13 | 3 | 20  | 5  | 6--13  | 0.257 |
| 19 | 3 | 20  | 6  | 22--28 | 0.075 |
| 29 | 5 | 252 | 10 | 6--16  | 0.242 |
| 31 | 5 | 252 | 7  | 6--16  | 0.319 |
| 41 | 5 | 462 | 21 | 11--34 | 0.171 |
| 43 | 5 | 462 | 21 | 12--33 | 0.165 |

At depth two there are only one to three count values in every field; late
depths collapse to one or two values, partly because the chosen witness is
maximal.  The independent fair-sign baseline (q^2/2^d) consistently
overestimates the observed middle-depth extension count, showing that general
position plus the algebraic sign graph carries additional dependence.

**Verdict:** the cheap falsifier does not fire.  A container route remains
plausible, but count compression alone is not a classification.  The next
bounded test must label each count class by geometric state — point types,
line/pencil incidence, cross-ratio or norm coset, and stabilizer orbit — and
ask whether a bounded catalogue works across fields and across *all* maximum
witnesses rather than one witness per field.

## 5. Local cumulants — too weak and field-dependent

Every general-position four- and five-subset of the off-conic plane was
enumerated at (q=5,7).  Adjacent- and disjoint-edge mutual information was
computed for the resultant sign variables, together with triangle and
four-cycle product histograms.

| (q) | size | general-position sets | all-negative sets | adjacent MI | disjoint MI |
|---:|---:|---:|---:|---:|---:|
| 5 | 4 | 6,195   | 5   | 0.0255 | 0.0191 |
| 5 | 5 | 5,724   | 0   | 0.0295 | 0.0118 |
| 7 | 4 | 125,650 | 154 | 0.0109 | 0.0041 |
| 7 | 5 | 425,712 | 0   | 0.0110 | 0.0030 |

The absence of all-negative five-sets at (q=5,7) is not a uniform local
law: the committed (q=11) Clebsch hexagon contains all six of its five-point
subsets as general-position all-negative sets.  Mutual information is only
0.003--0.030 nats and the cycle-product histograms have all allowed
signs with large support.

**Verdict:** kill a field-uniform (K_4/K_5) cumulant or forbidden-pattern
proof.  Larger local flags could merely rebuild the full clique search at
high cost; they have no positive cheap signal here.

## 6. EJ + TT routing and mystery ledger

**EJ.**  The portfolio did its job by killing attractive analogies before they
became proof projects.  Entropic uncertainty has no equality case to classify,
the universal degree-two multiplicity moments admit an exact covering profile,
and small local cumulants are field-dependent.  The positive evidence is
global and conditional: missing-set Hilbert defects in three fields, and
compressed extension counts along selected maximum witnesses.

**TT.**  The cheapest upgrades are correspondingly concrete.  Extract the
three first kernel polynomials before invoking any general lacunary theory, and
label prefix count classes before attempting an entropy-container theorem.
Either experiment can still kill its route cheaply.  No further inequality
optimization is warranted for the three negative tests without a genuinely
new identity.

The EV order after these falsifiers is:

1. prove the clean masked direction gap `h >= 1`, using the global split chord
   polynomial / Rédei carrier;
2. cheaply extract the three unexpected missing-set curves and decide whether
   they are canonical;
3. label the compressed prefix-extension classes and test for a field-uniform
   container catalogue;
4. keep (R) as a mixed fourth-moment fallback;
5. do not spend another pass on raw uncertainty entropy, degree-two incidence
   moments, or unstructured (K_4/K_5) cumulants.

Open diagnostics:

- Why do Hilbert defects appear early at (q=13,29,31) but not (23,37,41,43)?
- Are the prefix count classes stabilizer orbits, or merely repeated integers
  with unrelated geometry?
- Can the exact direction gap be expressed as a support lower bound for the
  restriction of (H_A) modulo the projective Frobenius ideal?
- Which higher-concurrency statistic, if any, is fixed by the chord graph and
  conic mask strongly enough to revive a Lloyd-style dual polynomial?

## 7. Replay and evidence limits

Run from `rust/`:

```text
python3 ../notes/2026-08-01-c756-probability-cheap-tests.py
sha256sum ../notes/2026-08-01-c756-probability-cheap-tests.{py,json}
```

The full replay is deterministic.  The prime-field saturated enumeration is
independent of the Rust audit and its candidate counts are checked against the
committed certificate.  The split-support coverage counts are checked against
the exhaustive masked-direction certificate.  The Lloyd profile is checked by
exact integer identities.  The prefix test verifies that a full maximum witness
has no extension.  The local test checks the six five-subsets of the committed
(q=11) hexagon directly.

Recorded artifacts:

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-01-c756-probability-cheap-tests.py` | 20,904 | `34fe706268e51f4ed09a95ec64424430e11f46d9e03fae320ca16eac0580fff2` |
| `notes/2026-08-01-c756-probability-cheap-tests.json` | 136,584 | `cf1830a069605c1a2d1edb42bad8ed9d52264df3bca193a1e07d0cf6762fae73` |

These are bounded diagnostics, not exhaustive all-field evidence.  In
particular, split-support and prefix tests use one selected extremal witness per
field; they cannot establish universality.
