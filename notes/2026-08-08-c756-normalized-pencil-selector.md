# C756 normalized pencil selector and split Rédei verdict

## Verdict

The signed perfect-pencil equation has an exact affine normal form.  After
normalizing the deleted conjugate pair, a hypothetical saturated-internal
support becomes a set \(T\) with one point on every nonsquare direction from
the origin, while every secant of \(T\) has square direction.  Every missing
direction therefore gives a balanced Rédei factorization
\[
 \widehat H_L(X)Q_L(X)=X^{q-1}-1,\qquad
 \deg\widehat H_L=\deg Q_L=(q-1)/2.
\]
This is the desired half-domain degree balance.

It is not, however, the nonsaturated masked identity in disguise.  The
saturated identity is a family of injective projection-slice factorizations
on half the directions; nonsaturated \(h=0\) is one chord-direction product
covering every direction.  The tempting extra collapse in which
\(\widehat H_L\) is a complete square or nonsquare coset is false already for
the genuine \(q=5\) four-frame.  A common half-Paley theorem remains
possible, but it must control two slices jointly; no single-slice Rédei
identity unifies the branches.

## 1. Normalized two-color form

Let \(q\) be odd, \(m=(q+1)/2\), and
\(\delta=(-1)^m\).  Work in \(\mathbb F_{q^2}=\mathbb F_q(s)\), with
\(s^q=-s\), and write \(\chi_2\) for the quadratic character of
\(\mathbb F_{q^2}\).  For a hypothetical coherent saturated-internal system,
choose the representatives supplied by the sign-coherence theorem:
\[
 \chi_2(z_i-z_j)=\delta,\qquad
 \chi_2(z_i-z_j^q)=-\delta\quad(i\ne j). \tag{1}
\]
Normalize \(z_0=s\), and put
\[
 v_i=\frac{z_i+s}{2s},\qquad
 \tau(v)=1-v^q,\qquad
 V=\{v_i\},\qquad T=V\setminus\{1\}. \tag{2}
\]

> **Proposition 21 (normalized perfect-pencil form).**  One has \(v_0=1\)
> and, for all distinct \(i,j\),
> \[
> \chi_2(v_i-v_j)=+1,\qquad
> \chi_2(v_i-\tau(v_j))=-1. \tag{3}
> \]
> In particular every \(v\in T\) satisfies
> \[
> \chi_2(v)=-1,\qquad \chi_2(v-1)=+1. \tag{4}
> \]
> Regard \(\mathbb F_{q^2}\) as a two-dimensional affine space over
> \(\mathbb F_q\).  Then \(T\), of size \(m\), contains exactly one nonzero
> point on each nonsquare projective direction through \(0\), and every
> secant direction determined by two points of \(T\) is square.

**Proof.**  The conjugate of the point represented by \(v\) is represented
by \(\tau(v)\), because
\[
 z_i=2sv_i-s,\qquad z_i^q=-2sv_i^q+s.
\]
Moreover
\[
 z_i-z_j=2s(v_i-v_j),\qquad
 z_i-z_j^q=2s(v_i+v_j^q-1)=2s(v_i-\tau(v_j)).
\]
If \(\epsilon=\chi_q(-1)\), then
\[
 \chi_2(2s)=\chi_q(N(2s))
 =\chi_q(-4s^2)=-\epsilon=\delta.
\]
Dividing the two identities in (1) by this common character proves (3).
Taking \(j=0\) in the cross identity and in the within identity proves (4).

Quadratic character is constant on each \(\mathbb F_q\)-direction, because
every element of \(\mathbb F_q^\times\) is a square in
\(\mathbb F_{q^2}\).  Thus (4) puts every point of \(T\) on a nonsquare
direction.  Two distinct members cannot lie on the same direction: if
\(u=cv\) with \(c\in\mathbb F_q^\times\), then
\(\chi_2(u-v)=\chi_2((c-1)v)=-1\), contradicting (3).  There are exactly
\((q+1)/2=m\) nonsquare directions, so \(T\) meets each once.  The last
assertion is the first identity of (3). \(\square\)

This is the affine version of \(Zx=\pm Ze_R\).  It retains both halves that
the earlier direction coordinatization separated: the radial transversal is
the cross-Frobenius perfect pencil, while the square-secant condition is the
within-fibre Paley constraint.

## 2. Balanced Rédei slices

Fix a nonsquare direction \(L\), and choose any nonzero
\(\mathbb F_q\)-linear functional
\(\ell_L:\mathbb F_{q^2}\to\mathbb F_q\) with kernel \(L\).  Define
\[
 H_L(X)=\prod_{v\in T}(X-\ell_L(v)).
\]

> **Corollary 21.1 (balanced half-direction factorization).**  There are
> monic polynomials \(\widehat H_L,Q_L\in\mathbb F_q[X]\), both of degree
> \(m-1=(q-1)/2\), such that
> \[
> H_L(X)=X\widehat H_L(X),\qquad
> \widehat H_L(X)Q_L(X)=X^{q-1}-1. \tag{5}
> \]

**Proof.**  Proposition 21 gives a unique \(v_L\in T\cap L\), so zero is one
projection value.  No two other projection values coincide, because their
difference would be a secant parallel to the nonsquare direction \(L\).
Thus the \(m\) values \(\ell_L(T)\) are distinct elements of
\(\mathbb F_q\), exactly one of them zero.  Hence \(H_L\mid X^q-X\).
Cancel the simple factor \(X\); the remaining root set and its complement
both have size \(m-1\), proving (5). \(\square\)

The factorization is invariant under rescaling \(\ell_L\), up to the
corresponding rescaling of roots.  It is exact and uniform, but it carries
\(m-1\) degrees of freedom in each factor.  Triangle holonomy does not
collapse those roots to one character coset.

## 3. Comparison with the nonsaturated identity

For a nonsaturated candidate with a deleted point and spare external line,
the \(h=0\) hypothesis gives
\[
 D_P(T)=(T^q-T)E_P(T),
\]
where \(D_P\) is the product of all chord-direction factors and
\(\deg E_P=\delta=\binom{k-1}{2}-q\).  This says every affine direction is
hit by at least one chord.

Equation (5) says something categorically different.  It is obtained from
the point Rédei polynomial, one slice at a time, because half the directions
are missed by all secants and therefore give injective projections.  The
radial-transversal condition supplies one zero and makes the residual factor
degrees equal.  Thus:

| branch | direction statement | algebraic carrier |
|---|---|---|
| saturated internal | half the directions are absent from secants; each is occupied radially once | \(m\) balanced slice factorizations of \(X^{q-1}-1\) |
| nonsaturated \(h=0\) | every affine direction occurs as a chord direction | one global chord product divisible by \(T^q-T\) |

The shared vocabulary is genuine, but the one-variable identities have
opposite incidence content.  Any common theorem must use a two-direction or
two-coordinate invariant, not identify these factorizations.

## 4. Rejecting control at \(q=5\)

Take \(\mathbb F_{25}=\mathbb F_5(s)\), \(s^2=2\), and
\[
 V=\{1,\;4s,\;4+3s,\;2+s\}.
\]
This is a normalized genuine four-frame: every within difference has
\(\chi_2=+1\), and every off-diagonal difference
\(v-\tau(w)\) has \(\chi_2=-1\).  For
\[
 \ell_v(u)=\frac{uv^q-u^qv}{2s},
\]
the three projection rows on \(T=V\setminus\{1\}\) are
\[
 \{0,4,2\},\qquad \{1,0,3\},\qquad \{3,2,0\}. \tag{6}
\]
The first two nonzero root sets contain one square and one nonsquare.
Therefore neither sign coherence nor the perfect-pencil equation can force
\(\widehat H_L\) to be \(X^{m-1}-1\), \(X^{m-1}+1\), or a rescaled
quadratic-character coset.  This closes that proposed degree collapse.

## 5. Reproducible verification

The exact checker uses only prime-field pair arithmetic.  It verifies all six
within signs and all twelve ordered off-diagonal cross signs of the displayed
\(q=5\) four-frame, its three distinct nonsquare radial directions, and the
three projection rows in (6).  It certifies only this rejecting control; the
uniform statements are the human proofs above.

Replay from the repository root:

    python3 notes/2026-08-08-c756-normalized-pencil-selector.py --check

| artifact | bytes | SHA-256 |
|---|---:|---|
| 2026-08-08-c756-normalized-pencil-selector.py | 4,836 | a622bcfe26c45d1fac02a64c8bef24a57652a4953c20d99e811006d4e23ef580 |
| 2026-08-08-c756-normalized-pencil-selector.json | 1,700 | b1e29fede1508acf84a7d2c03c5d301ae0f497bff3d8c938815dbe929d430a1d |

Independent boundary: Proposition 21 and Corollary 21.1 are symbolic.  The
four displayed projection rows make the finite negative check independently
hand-replayable.

## EJ + TT closeout

**EJ.**  The free structural upgrade is the exact radial-transversal form:
the deleted seed is not merely a set missing half the directions.  It
occupies each missing direction exactly once.  This supplies the zero that
turns the ordinary Rédei slice into the balanced factorization (5), with two
equal-degree factors.

**TT.**  Equal degrees are not rigidity.  The genuine \(q=5\) solution
already has mixed quadratic characters in a slice, so forcing either factor
to be a cyclotomic half repeats the failed one-coordinate moment strategy.
The next admissible calculation is joint: compare
\((\widehat H_L,\widehat H_{L'})\) under the Frobenius reflection
\(\tau(v)=1-v^q\), and ask whether their resultant or common divisor is
bounded-degree.  Stop immediately if this reduces to Corollary 7.1's
single-coordinate set equality or Theorem 8's moment wall.

The architecture odds should be revised from 55/25/15/5 to approximately
30/50/15/5: 30% for one common half-Paley theorem, 50% for separate
Segre/polarity and masked Rédei finishers, 15% for signed \(p\)-adic
incidence, and 5% for another arithmetic route.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| What is the normalized missing-point selector? | settled | Proposition 21: one point on every nonsquare radial direction, with only square secants |
| Does the saturated selector have an exact Rédei factorization? | settled | Corollary 21.1 gives equal-degree factors of \(X^{q-1}-1\) for every nonsquare direction |
| Is that the nonsaturated masked identity? | settled negative | slice injectivity on half the directions versus chord coverage on every direction |
| Does triangle holonomy force a square/nonsquare root coset in each slice? | settled negative | explicit genuine \(q=5\) mixed-character rows (6) |
| Can one common direction theorem still close both branches? | open, downgraded | requires a joint two-direction invariant, not either one-variable factorization |
| What is the saturated next gate? | open | bounded-degree relation between two balanced slices under \(\tau\), with the prior moment wall as stop rule |
| What is the nonsaturated next gate? | unchanged open | prove the masked direction theorem \(h\ge1\) |

## 6. Joint-slice audit

The proposed next calculation also has an exact identification.  For a
nonsquare direction \(L\), let
\(\ell_L:\mathbb F_{q^2}\to\mathbb F_q\) have kernel \(L\).  The cross
condition in Proposition 21 and the perfect-matching theorem say that the
two projected sets
\[
 \ell_L(V),\qquad \ell_L(\tau(V))
\]
coincide, with a canonical bijection induced by pairs whose difference lies
in \(L\).  In the earlier direction coordinatization these are precisely
\[
 X_c=\rho(c)X_{c^{-1}},
\]
and the induced bijection is \(\pi_c\).

> **Proposition 22 (joint-slice identification).**  For two distinct
> nonsquare directions \(L,L'\), the paired two-coordinate distribution
> \[
> \{(\ell_L(v),\ell_{L'}(v)):v\in V\}
> \]
> determines exactly the previously isolated composite matching
> \(\pi_{c'}^{-1}\pi_c\), up to affine rescaling of each coordinate.
> Consequently a resultant, gcd, or interpolation invariant of two slices
> is new only if it extracts a field-arithmetic restriction on that
> composite's cycle structure.

**Proof.**  The map
\(v\mapsto(\ell_L(v),\ell_{L'}(v))\) is an
\(\mathbb F_q\)-linear isomorphism because its two kernels are distinct.
Thus the paired projections recover \(V\) and the two projection matchings.
Composing one matching with the inverse of the other gives
\(\pi_{c'}^{-1}\pi_c\).  Changing either functional rescales its coordinate,
which is exactly the freedom already present in the factors \(d_c\) and
\(\rho(c)\) of Corollary 7.1. \(\square\)

This meets the stop rule from the prior pass.  The single-slice set equality
and all of its symmetric moments were exhausted by Theorem 8; the missing
cycle invariant was already named and no bounded-degree carrier was found.
Renaming it a two-slice resultant does not make it a new attack.  The
one-common-lemma architecture is therefore downgraded again: approximately
15% common half-Paley, 65% separate Segre/polarity plus masked Rédei, 15%
signed \(p\)-adic incidence, and 5% another route.

**TT2.**  The useful question is no longer whether two projections contain
more data--they tautologically do--but whether the field arithmetic forces
their matching composite into a small conjugacy class.  That is the old
cycle gate.  With no new bounded carrier, the correct move is to stop this
branch and spend the next pass on the self-dual signed incidence operator,
where integrality and polarity have not yet been combined.

## Next action

Determine whether the signed passant incidence matrix can be switched
symmetric or skew-symmetric uniformly under polarity.  If so, compute its
exact square and recast \(Zy=0\) as a sparse-kernel problem for one self-dual
integral operator.  Continue only if the symmetry yields arithmetic beyond
\(Z^{\mathsf T}Z=mI-\epsilon K\); otherwise pursue a branch-specific Segre
tangent theorem for saturation.  The nonsaturated gate remains the separate
masked Rédei theorem \(h\ge1\).
