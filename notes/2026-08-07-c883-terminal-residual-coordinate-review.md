# C883 review — terminal residual-prime coordinate mismatch

**Lane:** `reed-solomon`  
**Date:** 2026-08-07  
**Scope:** cross-check of the residual prime in
`prop:reduced-terminal-carrier`; no review of the characteristic-two plane,
characteristic-three cone, or the other carrier components.

## Verdict

The reported coordinate mismatch is real.  The seven printed generators and
the stable-component certificate use the bottom divided-power coordinates of
the displayed Hankel matrix.  The parametrization printed as (26) uses plain
quartic coefficients.  The uniform replacement over
`Spec Z[1/6]` is

\[
 [u:v:w]\longmapsto
 [6u^2:3uv:v^2+2uw:3vw:6w^2].
\]

The prime decomposition itself survives.  Three local pieces of its printed
proof need repair: the parametrization, the sentence identifying the printed
map's prime kernel, and the generic residual witness used for irredundancy.

There is one qualification to the original report.  In characteristic five
the two parametrized surfaces accidentally coincide after (v\mapsto-v), so
the printed map has the correct fibre there.  The mismatch is visible over
characteristic zero and over characteristics other than (2,3,5).

## 1. Independent substitution

For

\[
 A(u,v,w)=(u^2,2uv,v^2+2uw,2vw,w^2),
\]

direct expansion gives

\[
\begin{aligned}
g_1(A)&=-10vw^3(uw-v^2),\\
g_2(A)&=-5w^2(uw-v^2)(7uw+3v^2),\\
g_3(A)&=-10uvw^2(uw-v^2),\\
g_4(A)&=0.
\end{aligned}
\]

For the reversed generators the corresponding values are

\[
-10u^3v(uw-v^2),\qquad
-5u^2(uw-v^2)(7uw+3v^2),\qquad
-10u^2vw(uw-v^2),\qquad0.
\]

Thus the three reported residuals are exact polynomial identities over
\(\mathbb Z\).  Their common factor (5) matters: modulo five every one
vanishes.  Indeed, if

\[
B(u,v,w)=(6u^2,3uv,v^2+2uw,3vw,6w^2),
\]

then

\[
B(u,-v,w)\equiv A(u,v,w)\pmod5.
\]

## 2. Corrected parametrization

Direct substitution of (B) annihilates (g_1,\ldots,g_4) and all four
reversed generators identically.  The reason is the coefficient dictionary.
For bottom coordinates (c), the associated syndrome quartic is

\[
f_c(X,Y)=c_0X^4-4c_1X^3Y+6c_2X^2Y^2-4c_3XY^3+c_4Y^4.
\]

On (B),

\[
f_{B(u,v,w)}(X,Y)=6(uX^2-vXY+wY^2)^2.
\]

Hence (B) is exactly the perfect-square locus in bottom coordinates.
Equivalently, in the rescaled coordinates

\[
z_i=\binom4i c_i,
\]

it becomes the plain-coefficient Veronese (A), up to the harmless parameter
change (v\mapsto-v).  This also explains why the identical-looking display
in the R8 appendix is correct: that appendix introduces the (z_i) before
printing it.  Proposition `prop:reduced-terminal-carrier` instead labels its
coordinates as the bottom (c_i), so the same display is wrong there.

The tracked stable-component elimination gives the scheme-theoretic equality,
not only containment: over the generic fibre, the seven-generator ideal is the
residual minimal prime obtained after saturation by the persistent determinant.
A fresh independent Gröbner elimination of the five equations defining (B)
also returned seven elimination generators and mutual ideal containment with
the printed seven-generator ideal.  That one-shot check is corroborative; the
tracked stable-component certificate below is the durable evidence.

## 3. Which display is authoritative

The generators are authoritative for four independent reasons.

1. The proposition defines (c_0,\ldots,c_4) as the entries of
   \[
   H_c=\begin{pmatrix}c_0&c_1&c_2&c_3\\c_1&c_2&c_3&c_4\end{pmatrix}.
   \]
2. The stable-component certificate constructs the signed Plücker minors
   (z(c)) from exactly that Hankel matrix and defines the residual ideal (V)
   by the seven printed generators.
3. Its Singular replay verifies
   \[
   (J:D^\infty)=V
   \]
   over the generic fibre and finds (V) as the residual minimal prime beside
   the persistent component.
4. The R6 calculation independently describes the tame cyclic surface in
   syndrome coordinates as
   \[
   \operatorname{diag}(1,4,6,4,1)^{-1}[Q^2],
   \]
   which clears to (B), not to the printed bottom-coordinate map (A).

The fresh replays were:

```text
cd papers/beyond4_prs/supplement/evidence/stable-components
python3 2026-07-24-r10-integral-bad-scheme-sc11.py --check
nix shell nixpkgs#singular -c Singular -q 2026-07-24-r10-integral-bad-scheme-sc11.sing
```

Both passed.  The Python replay reports the bottom factor trichotomy, bridge
saturation, small-characteristic controls, and row-space transport.  The
Singular replay reports the minimal integer bridge and the generic and vertical
fibre checks.

## 4. Intrinsic square-locus reading

Away from characteristics two and three, the residual component is exactly the
projective locus of syndrome quartics that are scalar multiples of squares of
binary quadratics.  The corrected map proves one containment, and the prime
kernel/elimination proves the converse.

On this map the catalecticant determinant is

\[
D(B(u,v,w))=(4uw-v^2)^3.
\]

Thus the residual surface is not contained in (V(D)); its intersection with
the persistent cubic is the image of the discriminant conic of degenerate
quadratics.  This also supplies a uniform repair of the irredundancy witness:

\[
[3:0:1:0:3]\in V,
\qquad D(3,0,1,0,3)=8.
\]

By contrast, the manuscript's witness ([1:0:2:0:1]) gives

\[
(g_1,g_2,g_3,g_4)=(0,-35,0,0),\qquad D=-6,
\]

so it is not a valid generic witness, although it happens to work in some
special characteristics.

For the invariant normalization used in the C883 covariant report, on the
unscaled square locus

\[
I=\frac{(4uw-v^2)^2}{12},\qquad
J=\frac{(4uw-v^2)^3}{216},
\]

and hence (I^3=27J^2).  This relation is supporting evidence but is not an
exact characterization: the quartic discriminant hypersurface also contains
nonsquare quartics with other repeated-root partitions.  The elimination
equality is the discriminating evidence.

## Literature cross-check

Three sources were consulted at partial depth for this narrow review: two in
the sections bearing on binary-quartic coordinates and square forms, and one
for the classical covariant comparison.

- Krishna Kaipa, Nupur Patanker, and Puspendu Pradhan, *On the
  (PGL_2(q))-orbits of lines of (PG(3,q)) and binary quartic forms*,
  `arXiv:2312.07118`.  **Partial:** the binary-quartic normalization, invariant
  formulas, and Section 5.2 on discriminant-zero orbits.  The paper uses the
  same binomial-coordinate quartic and its square cases are the fourth-power
  orbit and the squares of split or irreducible quadratics, agreeing with the
  intrinsic reading above.  Cache SHA-256
  `2ea8efc04bbf42be0919288e5e3777a4010ae30940bf8fec3a5c32feef789752`.
- Krishna Kaipa and Puspendu Pradhan, *Incidence of lines, points and planes in
  (PG(3,q)) with respect to the twisted cubic*, `arXiv:2509.15332`.
  **Partial:** Section 1.1 and the invariant/Klein-coordinate discussion.  It
  uses the same binomial quartic, apolar invariant, catalecticant, and
  discriminant convention up to normalization.  It supports the coordinate
  dictionary and repeated-root interpretation but does not identify this
  terminal residual component.  Cache SHA-256
  `f11b17aeebe9c4fca18c1486853664cb1fd075e24ceb2e0156023e1d529ee726`.
- W. Duke, *On Elliptic Curves and Binary Quartic Forms*, IMRN 2022,
  DOI `10.1093/imrn/rnab249`.  **Partial:** Section 5 and the square-factor
  remarks in Section 8.  Duke denotes the related quartic covariant
  (2IH-3JF) by (K_F); it is not the C883 combination (IH-JF) in the same
  normalization.  Cache SHA-256
  `beeabac0d615d28a5189bfeed6759d08fe154a91d8836a41cd7288a8942f569b`.

This bounded reading supports the square-locus interpretation.  It does not
close C883's separate literature gate asking whether (IH-JF) has a classical
name; no priority or absence verdict is made here.

## Durable evidence

- `notes/2026-08-07-c883-hankel-plucker-covariant.py`, 6707 bytes, SHA-256
  `6a16072b28d9695ca578417e7c37a409c127562f558ff702e4c039738d51366a`.
- `notes/2026-08-07-c883-hankel-plucker-covariant.json`, 587 bytes, SHA-256
  `90fe8dbf2a179733ae149c8c5e726d85b7f26adddeab4b1a149d1c66fb1ce86e`.
- `papers/beyond4_prs/supplement/evidence/stable-components/2026-07-24-r10-integral-bad-scheme-sc11.py`,
  24824 bytes, SHA-256
  `4881ea814c056dc452fd0cd47fbea56117ad860f325f367aa561e120b7565a4d`.
- `papers/beyond4_prs/supplement/evidence/stable-components/2026-07-24-r10-integral-bad-scheme-sc11.sing`,
  4763 bytes, SHA-256
  `6bf5c52bdded5f991d511b44a80847feba8a6a12812bea22c74d2e170e111be0`.

Replay of the C883 substitution and invariant checks:

```text
uv run --with sympy python3 notes/2026-08-07-c883-hankel-plucker-covariant.py
```

The tracked script rewrites its canonical JSON certificate.  The stable-
component commands above run in check mode or read-only certificate mode.

## Repair boundary

The minimum manuscript repair is:

1. replace (26) by (B);
2. change the prime-kernel sentence to refer to the corrected map;
3. replace the generic residual witness by ([3:0:1:0:3]).

No change is needed to the seven generators, the characteristic-two plane,
the characteristic-three cone, the residual degrees, or the two-prime
decomposition.

## Mystery ledger

- **Settled:** why the plain Veronese appears elsewhere in the manuscript: it
  is correct after the explicit binomial rescaling to (z_i).
- **Settled:** why the residual component is a projected Veronese: it is the
  quadratic-squaring map in syndrome-quartic coordinates.
- **Settled:** irredundancy after the witness repair, via
  (D(B)=(4uw-v^2)^3).
- **Open elsewhere in C883:** whether the distinct covariant (IH-JF) has a
  classical name.  This review neither settles nor enlarges that literature
  gate.
