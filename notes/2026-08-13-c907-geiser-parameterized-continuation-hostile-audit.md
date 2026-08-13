# C907 — hostile audit of the Geiser parameterized continuation

Date: 2026-08-13

Verdict: **GO after two material proof repairs.**  The quotient-Novikov-line
path is legitimate and the Geiser rank Boolean is preserved, but the first
version of the proof conflated two comparison maps and overstated what
spectral separation gives.  The repaired argument uses:

1. the Lee--Lin--Qu--Wang graph correspondence as the regular-at-`z=0`
   quantum-D-module comparison, hence as the transporter of the formal
   primitive-sixth packet;
2. the Chen--Tseng transformation only as the large-`z` expression of that
   same horizontal continuation, where their Gamma/Fourier--Mukai square
   identifies the transported point section;
3. Dreyfus locally, on nonturning endpoint polydiscs, to identify the
   formal-primary packet with the two fixed-sector receivers.

No global convergent block diagonalization and no claim that Chen--Tseng's
`U` is itself regular at `z=0` are used.

## 1. Two claims that do not survive literally

### 1.1 Spectral separation is formal/sectorial, not convergent

At a point-blowup endpoint with nonzero exceptional parameter, the zero
ambient eigenvalue cluster is separated from the two nonzero exceptional
eigenvalues of the Euler quantum product.  A Riesz contour gives a
parameter-holomorphic projector for that **leading coefficient**.  It does
not give a convergent holomorphic gauge that exactly block diagonalizes the
irregular connection near `z=0`: off-diagonal Stokes extensions are precisely
the obstruction to such a gauge.

The valid consequence is smaller.  Separation makes the Sylvester operators
in the recursive **formal** block diagonalization invertible.  This gives a
unique formal projector after its leading projector is fixed.  On a
nonturning parameter polydisc and in a nonsingular direction, parameterized
multisummation gives its canonical sectorial realization.  Different
directions can differ by Stokes transformations.

Thus the old phrase “convergent parameter-holomorphic separation” is false
as stated and has been removed.

### 1.2 Chen--Tseng's `U` is not the cited `z=0` gauge

Chen--Tseng define

\[
 U S_{Y,\tau}^{-1}=S_{Y^+,\tau^+}^{-1}
\]

in the multivalued Givental space
`H[[log z]]((z^{-1}))`.  Their Theorem 0.2 proves

\[
 U\Psi_Y(E)=\Psi_{Y^+}(\operatorname{FM}E).
\]

This is an exact Gamma/Fourier--Mukai statement at the large-`z` framing.
It does not by itself say that `U` is a meromorphic gauge at `z=0`, and so it
cannot alone be cited as transporting formal monodromy or `P_6`.

The regular comparison is already present in the input Chen--Tseng use:
Lee--Lin--Qu--Wang identify the analytically continued quantum differential
equations by the cohomological graph correspondence.  That correspondence is
independent of `z`, hence regular at `z=0`, and therefore transports the
formal meromorphic connection and its primitive-sixth formal-primary packet.
Indeed their theorem gives
`F(alpha star beta)=F(alpha) star' F(beta)` after continuation; `F` also
preserves degree, the Poincare pairing, and the crepant first-Chern class.
It therefore conjugates the parameter and `z` parts of the Dubrovin
connection, not merely the primary ring at one point.
Chen--Tseng then identifies the induced map on horizontal solutions, written
in the two large-`z` fundamental-solution frames, with `U` and proves that it
sends the Gamma point class to its Fourier--Mukai transform.  The two maps
have different matrix expressions but describe the same horizontal
continuation.

This two-map argument is the load-bearing repair.

## 2. Exact use of Dreyfus

Dreyfus Proposition 1.3 produces a parameterized Hukuhara--Turrittin form
only after shrinking to a nonempty parameter polydisc.  Example 1.5 warns
that it need not specialize across a level-changing point.  Before
Proposition 1.13 he additionally shrinks so that:

- formal levels are constant;
- specialized and parameterized singular directions agree;
- distinct singular directions do not collide.

Proposition 1.13 and Lemma 1.14 then give parameter-meromorphic sectorial
sums in a continuously nonsingular direction and commutation with parameter
derivatives.  They do not provide one global sector across a turning
divisor.

For the Geiser path this is enough.  Remove:

- the singular locus of the analytically continued small quantum
  connection;
- the turning and level-changing loci;
- the resonance locus where the generalized `zeta_6` formal-primary rank
  changes.

These are proper analytic loci after the endpoint noncollision checks.  The
nonzero total space of the quotient-Novikov line is connected, and removing
proper complex hypersurfaces does not disconnect it.  Choose a path between
the two endpoint germs in the complement.  Along the compact path, cover by
finitely many Dreyfus polydiscs and choose a continuous lifted nonsingular
`z` direction.  On overlaps the **formal primary projector**, normalized by
its leading projector, is unique; its sums therefore agree.  No Stokes wall
is crossed by the chosen lifted direction.

Joint flatness is not a quoted clause of Dreyfus.  It follows here from the
integrability defect: applying a Novikov covariant derivative to the summed
formal-primary solution produces another `z`-flat solution with zero formal
asymptotic germ, hence zero by sectorial uniqueness.

One can equivalently continue at one fixed `z!=0` using the ordinary flat
parameter connection and use Dreyfus only to identify the endpoint
asymptotics.  This avoids any need for a uniform positive lower bound on the
radius `epsilon(t)` in Proposition 1.13.

## 3. The repaired Geiser transport

Use `q=Q^e`, `s=Q^c` on the left and `q'=Q^{e'}`, `s'=Q^{c'}` on the right.
The curve correspondence gives

\[
 s'=s^{-1},\qquad q'=qs^3.
\]

For a fixed homogeneous coefficient the dimension axiom fixes the exponent
of `q`; only the `s`-series is infinite.  LLW analytically continue precisely
that extremal series, while the change `q'=qs^3` is the transition between
two frames of the quotient-Novikov line.  Thus the correlated path is a
legal coefficientwise analytic path, not evaluation of a formal power series
at a nonzero point.

Now transport two structures along the same path:

1. **Formal packet.**  LLW's graph gauge identifies the continued quantum
   connections and is regular at `z=0`.  Together with the local
   parameterized formal-primary continuation, it sends the left `P_6` to the
   right `P_6`.
2. **Rank row.**  The intrinsic Gamma point section is horizontal.  The
   finite-disjoint extension of Chen--Tseng identifies its continuation
   across the six-curve middle flop with the Gamma section of the
   Fourier--Mukai image.  An off-exceptional skyscraper maps to the
   corresponding off-exceptional skyscraper.  Flat-pairing compatibility
   therefore transports the rank covector.

At each endpoint, the Artin receiver and Dreyfus summation identify these
intrinsic objects with the balanced point-blowup receiver.  Hence

\[
 \mathfrak r_X|_{P_6(X)}\ne0
 \quad\Longleftrightarrow\quad
 \mathfrak r_{X'}|_{P_6(X')}\ne0.
\]

The same proof external-products with the small quantum D-module of
`P^2`.

## 4. Remaining boundaries

1. The finite-disjoint Chen--Tseng statement remains a proof extension, not
   the literal scope of their published theorem.  Its deformation argument
   must keep the common extremal variable for all six components; it is not
   six independent continuations.
2. The path argument is for a general Geiser point, where the six Atiyah
   curves and endpoint spectral separations are clean.
3. This proves one peak theorem.  It gives no classification or coverage of
   the other smooth-fivefold peaks needed for Gold.
4. Nothing in this audit promotes the theorem to a manuscript or to Lean.

## 5. Source boundary

- Dreyfus, arXiv:1203.2904, Proposition 1.3, Example 1.5,
  Proposition 1.13, and Lemma 1.14; cached PDF SHA-256
  `927b043d9af6759673cd28be74dfe1765373e60bf6e9c94821a80dd0700dccc0`.
- Chen--Tseng, arXiv:2604.09962v1, Definition 0.1, Theorem 0.2,
  equations (1.2), (3.7)--(3.12), and Remark 3.1; cached PDF SHA-256
  `edee1bc9cce58e216ec5973dd409a72de80db593820a912ed54325773edef6df`.
- Lee--Lin--Qu--Wang, arXiv:1401.7097, Theorem 0.1.1 and
  Sections 1.2--1.3; cached PDF SHA-256
  `eeb1d87ae279a04c0ce5e9df66ce820aa87443fa6494f21d24269891a905b19c`.

## EJ / TT

- **EJ:** the audit separates a reusable pattern: regular quantum-D-module
  gauge transports the formal packet; Gamma/Fourier--Mukai compatibility
  transports the distinguished covector.  Demanding one matrix to do both
  was the source of the apparent frame contradiction.
- **TT:** any next peak theorem should state these as two commuting edges of
  one horizontal comparison square.  A large-`z` Givental transformation is
  never, without proof, the `z=0` formal-primary gauge.
