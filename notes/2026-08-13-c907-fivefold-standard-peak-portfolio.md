# C907 — finite portfolio of smooth standard peaks in dimension five

Date: 2026-08-13

Status: exact dimension sieve.  Once a smooth peak is known to be a
semi-free standard wall, Gold has only four non-blowup geometries.  The two
point-base geometries are covered by existing or newly extended Gamma/QDM
intertwiners.  The remaining standard-wall frontier is a `P^1` ordinary flop
over a surface and a discrepant `(1,2)` flip over a curve.  Weighted or
nonstandard toroidal AKMW peaks remain outside this sieve.

## 1. Dimension equation

Let a standard wall have smooth base `S` of dimension `d`, vector bundles
`V_+`, `V_-` of ranks `r_+<=r_-`, and exceptional loci

\[
 P_S(V_+)\subset X_+,
 \qquad
 P_S(V_-)\subset X_-.
\]

The normal bundle of `P_S(V_+)` has rank `r_-` and that of
`P_S(V_-)` has rank `r_+`.  Therefore the common ambient dimension is

\[
 n=d+(r_+-1)+r_-=d+r_++r_--1.                    \tag{1}
\]

For Gold, `n=5`.

If `r_+=1`, one side has exceptional locus `S` and the wall is a smooth
blowup/down, already covered by the one-arrow theorem.  Assume henceforth
`r_+>=2`.  Equation (1) leaves exactly:

| `r_+` | `r_-` | `d` | geometry |
|---:|---:|---:|---|
| `2` | `2` | `2` | ordinary `P^1` flop over a surface |
| `2` | `3` | `1` | discrepant `(1,2)` flip over a curve |
| `2` | `4` | `0` | discrepant `(1,3)` flip over a point |
| `3` | `3` | `0` | ordinary `P^2` flop over a point |

There are no further cases.

## 2. Current theorem coverage

### Blowups (`r_+=1`)

The fixed-sector one-arrow theorem applies in every codimension, including
the repaired codimension-two case.  Peak composition still requires a direct
wall or carrier comparison, but no new local wall type occurs.

### Point `P^2` flop (`3,3,0`)

This is Chen--Tseng's literal simple-flop hypothesis with

\[
 Z=P^2,\qquad N_{Z/X}=O_{P^2}(-1)^{\oplus3}.
\]

Their Gamma/Fourier--Mukai square transports the off-exceptional point class
exactly.  The graph correspondence transports the quantum connection after
extremal analytic continuation.  Hence the primitive-sixth rank Boolean is
preserved for a single such point flop.

### Point `(1,3)` flip (`2,4,0`)

The split local wall is Gu--Yu--Yu's standard-flip model with wall `pt` and
discrepancy `-2`.  The isolated-point Gold regression produces six disjoint
copies sharing one extremal ray.  The finite-disconnected extension in
`2026-08-13-c907-disconnected-standard-wall-and-point-flip.md` treats them as
one repeated middle block and proves the rank identity.

### Surface `P^1` flop (`2,2,2`)

Lee--Lin--Qu--Wang prove the global genus-zero quantum-ring/ancestor
correspondence for ordinary flops.  Gamma/Fourier--Mukai compatibility is
proved for the simple point flop and toric/split local bundle models, but the
general projective-bundle flop needed here is only advertised, not proved, in
Chen--Tseng's Remark 3.1.  The product Geiser middle flop is one closed split
disconnected example.  A general surface-base standard flop remains open for
the C907 point/rank row.

### Curve `(1,2)` flip (`2,3,1`)

Gu--Yu--Yu prove the simple-VGIT case and the projective local model for
arbitrary rank-two/rank-three bundles over the curve.  Their decomposition
for an arbitrary global standard flip is Conjecture 1.8.  Thus the local
normal model is covered, while global gluing to an arbitrary common open
complement is the missing theorem.  The wall center is a curve and carries no
primitive-sixth packet, but that formal emptiness does not by itself identify
the incident sectorial frames.

## 3. What this does and does not buy

For **semi-free smooth standard** peaks, Gold has been reduced to two
globalization statements:

1. Gamma/Fourier--Mukai point-row compatibility for a `P^1` ordinary flop
   over a smooth projective surface;
2. the ambient point/rank row of a global `(1,2)` standard flip over a smooth
   projective curve.

Both centers have dimension at most two and empty primitive-sixth formal
packet.  Their difficulty is therefore pure frame/gluing compatibility, not
carrier cancellation.

This finite list does not prove that AKMW's regular-subdivision peaks are
semi-free standard walls.  AKMW supplies smooth toroidal blowups/down at the
boundaries but does not state that the common master is smooth with only
weight-`(+/-1)` normal directions.  Weighted walls and common refinements
with several interacting exceptional classes remain a separate coverage
gate.

## EJ / TT / AA

- **EJ:** in dimension five, the apparently unbounded standard-flip problem
  is two globalizations after the point cases are removed.
- **TT:** “smooth endpoints” does not imply “semi-free smooth master”; the
  finite table begins only after that additional hypothesis is verified.
- **AA:** attack the curve `(1,2)` flip first.  Its center has no `P6`,
  Gu--Yu--Yu already prove every local bundle model, and only the common-open
  gluing remains.

## Sources

- Gu--Yu--Yu, arXiv:2508.15770v1, Theorem 6.2, Corollary 6.8, and Conjecture
  1.8; cached SHA-256
  `9c00f826cb13ad243bd2ad126e74733cacf650a385160a11adc785693c01a358`.
- Chen--Tseng, arXiv:2604.09962v1, Theorem 0.2 and Remark 3.1; cached SHA-256
  `edee1bc9cce58e216ec5973dd409a72de80db593820a912ed54325773edef6df`.
- Lee--Lin--Qu--Wang, arXiv:1401.7097, Theorem 0.1.1; cached SHA-256
  `eeb1d87ae279a04c0ce5e9df66ce820aa87443fa6494f21d24269891a905b19c`.
