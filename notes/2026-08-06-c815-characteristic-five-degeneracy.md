# C815 addendum — the characteristic-five degeneracy explained

**Date:** 2026-08-06
**Lane:** `clebsch` (Paper III, `passages`)
**Settles:** the open "bad primes of the integral Jacobian" item in the mystery
ledger of `notes/2026-08-05-c815-rank-14-weighted-jacobian.md`
**Status:** research bundle; no manuscript and no Lean file changed

## Verdict

The C815 report logged, without an owner, that the primitive weighted Jacobian
keeps rank fourteen in every characteristic other than two and five, and that
its rank modulo five is eleven — "exactly the conference tangent rank." That
phrasing overstated one thing and understated another.

The equality of the two elevens is a bookkeeping accident. The conference rank
counts sixteen variables against a five-dimensional kernel; the modular
Jacobian rank counts fifteen variables against a four-dimensional kernel. Two
different offsets happen to cancel, and nothing follows from the numbers
matching.

Underneath it, though, there is an exact structural containment, and it is
stronger than the coincidence it was mistaken for:

> Let \(T\) be the tangent space at the golden representative to the
> generalized conference locus \(\{A^2=\lambda I\}\), and for \(X\in T\) let
> \(\mu(X)\) be the scalar with \(A_0X+XA_0=\mu(X)I\). Then the kernel of the
> weighted Jacobian modulo five is **exactly** the hyperplane \(\mu\equiv0\)
> inside \(T\).

So the modular kernel is not merely the same size as something conference-shaped;
it sits inside the conference tangent space and is cut out of it by one explicit
linear functional. The rank eleven is then forced: \(15-4\).

## The engine

Everything follows from one line. For \(X\in T\), multiply
\(A_0X+XA_0=\mu(X)I\) on the left by \(A_0\) and use \(A_0^2=5I\):

\[
 5X+A_0XA_0=\mu(X)A_0,
 \qquad\text{that is}\qquad
 A_0XA_0=\mu(X)A_0-5X .
\]

Equivalently, the involution \(\sigma(X)=\tfrac15A_0XA_0\) acts on \(T\), and

- \(\sigma=+1\) on the scaling line, since \(\mu(A_0)=2\lambda=10\) and
  \(\sigma(A_0)=A_0\);
- \(\sigma=-1\) on \(\ker\mu\), which is the four-dimensional irreducible
  summand of \(T\) as a module over the order-sixty stabilizer.

So the decomposition \(T\cong\mathbf1\oplus\mathbf4\) that C815 identified is
the \(\pm1\) eigenspace splitting of \(\sigma\), not merely a character
computation. That is a genuine sharpening of the C815 statement.

## Why five, and not any other prime

Let \(C=\textstyle\bigwedge^3A_0\) be the third compound, a 20-by-20 integer
matrix whose relevant entries are the Hodge coefficients. Because compounds are
multiplicative,

\[
 C^2=\textstyle\bigwedge^3(A_0^2)=\bigwedge^3(5I)=125\,I_{20}.
\]

Write \(D(X)\) for the derivative of \(A\mapsto\bigwedge^3A\) at \(A_0\) in the
direction \(X\); its entries are the Hodge half of the Jacobian rows. The mixed
compound satisfies \(\Lambda(PM_1Q,PM_2Q,PM_3Q)=\bigwedge^3P\cdot
\Lambda(M_1,M_2,M_3)\cdot\bigwedge^3Q\). Applying that with \(P=Q=A_0\), and
absorbing \(A_0(A_0/5)A_0=A_0\) in the two unperturbed slots, gives

\[
 D(A_0XA_0)=\tfrac1{25}\,C\,D(X)\,C .
\]

For \(X\in\ker\mu\) the engine identity makes the left side \(-5D(X)\), so
\(C\,D(X)\,C=-125\,D(X)\), and since \(C^2=125I\),

\[
 \boxed{\;C\,D(X)=-D(X)\,C\quad\text{for every }X\in\ker\mu\;}
\]

while \(D(A_0)\) commutes with \(C\). Both are verified at both oriented
representatives in the bundle.

That anticommutation is where the prime five enters and why no other prime can.
\(C^2=125I\) makes \(C/(5\sqrt5)\) an involution, so \(C\) has eigenvalues
\(\pm5\sqrt5\) and its elementary divisors carry half-integral five-adic
valuation. Five is the ramified prime of \(\mathbf Z[\varphi]\) — it is
\((\sqrt5)^2\) — and anticommuting with \(C\) forces \(D(X)\) into the odd part
of that ramified grading, which is exactly the extra factor of five. Away from
five, \(C\) is invertible with unit determinant class and the grading is
harmless, so the rank cannot drop. Away from two the primitive normalization
does nothing. Hence two and five are not merely the observed bad primes; they
are the only primes that can be bad, and three is excluded structurally rather
than by inspection.

## Status of the proof

Complete. The full prose proof now lives in the C815 report itself, under "The
characteristic-five theorem", and this note records the discovery and the
surrounding context rather than the argument.

The route that closed it is not the valuation bookkeeping this note first
sketched. Two ingredients replaced it. In gauge coordinates \(y_e=(A_0)_eX_e\)
the whole derivative becomes combinatorial: the triangle half is
\(\tau_S\,Y(S)\), the Hodge cofactor array is
\(2\varepsilon\tau_S(\mathbf J_3-P_S)\) for a perfect matching \(P_S\), and on
\(\mu=0\) directions the two combine to
\(\mathrm dF_S=-2\varepsilon\tau_S(4Y(S)+Y_{P_S})\). Then the same equivariant
reduction C815 already uses works modulo five, because three is invertible there
and every irreducible \(\mathbf F_5[\mathrm A_5]\)-module has exactly
one-dimensional order-three fixed space — so fixed-point dimension equals
composition length, and a submodule with the right fixed space is the whole
thing. The two hand checks that remain are the mod-five rank of the same
eight-by-five table and the tangency of its two kernel vectors.

That is a better outcome than the sketch, because it reuses the table the report
already displays instead of introducing new machinery, and because it explains
the \(-5\) minor: five divides that minor for every choice of rows and every
orbit basis, since the table drops rank modulo five.

The compound picture above survives as the reason no prime other than two and
five can be bad, which the combinatorial proof does not by itself supply.

The characteristic-two collapse is untouched. The primitive Jacobian has rank
four there, its kernel is eleven-dimensional, and no analogue of the engine
identity is available because \(A_0^2=5I\) becomes \(A_0^2=I\) modulo two. This
is not claimed to be explained.

## Bearing on the certificate question

None, and that is worth stating plainly. The rank-fourteen statement behind
Theorem D was already structural after C815; the characteristic-five behaviour
was never part of the certificate and removing the mystery does not remove any
remaining dependency. The residue in C815 is unchanged: a reader must still
reproduce the displayed eight-by-five reduced table from the multilinear
difference formula, and the constant-rank step is ordinary real analysis.

What this addendum does buy the manuscript is a better sentence about the
relationship between the cubic equality locus and the conference locus. C815
could say the two tangent pictures agree as modules. It can now say why: the
conference tangent space is the \(\pm1\) eigenspace decomposition of
conjugation by the representative, the cubic Jacobian is injective on the
\(-1\) part over \(\mathbf Q\), and that injectivity fails precisely at the
ramified prime of the golden order.

## No connection to the exceptional root-system ladder

Checked and negative. The ladder of `2026-08-05-c865-e9-affine-level-code.md`
and its predecessors is a characteristic-two construction: mod-two quadratic
forms on the E6 through E10 root lattices, orthogonal groups over
\(\mathbf F_2\), Calderbank--Kantor two-weight codes. C815 is a
characteristic-zero rigidity statement with icosahedral symmetry whose bad
primes are two and five.

The shared vocabulary is misleading in three specific places. The \(\mathbf F_4\)
of the ladder is \(E_8/2E_8\) as a module over the Eisenstein integers, with
\(\omega\) a cube root of unity; the \(\mathbf F_4\) of the golden programme is
\(\mathbf Z[\varphi]/2\), because two is inert in \(\mathbf Z[\sqrt5]\). Same
residue field, unrelated rings. The ladder's "exceptional" is the
crystallographic E-series; the golden programme's is the non-crystallographic
icosahedral series. And the ladder's bad prime two is the characteristic it is
built in, not a degeneracy.

There is one real ambient bridge, and it is not usable here. E8 is the icosian
ring over \(\mathbf Z[\varphi]\), H4 sits inside it, and \(\sqrt5\) is the
different of \(\mathbf Z[\varphi]\) — the same five that ramifies above. So both
stories do live over the same lattice. But the ladder uses only the mod-two
reduction, in which \(\varphi\) plays no role at all, so the bridge is never
crossed by either construction.

One adjacency is concrete enough to name, and it is the only one worth a later
look. The E6 level code has length twenty-seven on the points of a minus-type
elliptic quadric, which is the classical labelling of the twenty-seven lines of
a cubic surface; and the golden operator programme independently produces a
Clebsch cubic surface with its double-six and small resolutions. Those are
genuinely the same combinatorial object under \(W(E_6)\). Even so, the code is
pre-empted as Calderbank--Kantor, so nothing new could come from the code side;
the only possible content would be a golden or icosahedral refinement of it,
and there is no evidence yet that one exists. Not allocated.

## Evidence bundle

- `notes/2026-08-06-c815-characteristic-five-degeneracy.py` — 20,950 bytes,
  SHA-256 `38226476475bd85b46a3bc7fdd16589dc5479121561f6d8a80f30766acc4aefe`;
- `notes/2026-08-06-c815-characteristic-five-degeneracy.json` — 3,056 bytes,
  SHA-256 `2efca6885f1c010acfa0f67fcfc7a9a82bdfa976f4a47d7ab01b4e9d4349cdc4`.

Replay from the repository root:

```sh
python3 notes/2026-08-06-c815-characteristic-five-degeneracy.py \
  --check notes/2026-08-06-c815-characteristic-five-degeneracy.json
```

Standard library only, exact integer and rational arithmetic, no randomness.
The Jacobian, the compound, and the conference tangent are rebuilt from scratch
rather than imported from the C815 or C809 bundles, so the shared quantities —
rational rank fourteen, the primitive invariant factors, the conference rank
eleven — are confirmed on an independent code path. Everything is checked at
both oriented representatives.

The bundle verifies the rational rank; the modular ranks of the raw and
primitive Jacobians at the small primes; the primitive invariant factors; the
conference tangent dimension and rank; that \(\mu\) is a rank-one functional on
the tangent space with \(\mu(A_0)=10\); the engine identity
\(A_0XA_0=\mu A_0-5X\); that \(C^2=125I\); that the compound derivative
anticommutes with \(C\) on \(\ker\mu\) and commutes on the representative
direction; that every image content on \(\ker\mu\) is ten; and the headline
equality of the modular kernel with the \(\mu\equiv0\) hyperplane.

It also verifies the two inputs the prose proof in the C815 report leaves to the
reader, so that nothing in that proof is asserted without a machine check
alongside it: the stabilizer order and the existence of an order-three element
fixing the displayed orbit basis; that the eight distinct raw reduced rows have
contents \(6,4,2,2,4,2,2,6\), none divisible by five, so the content division in
the displayed table cannot change the modular rank; that the reduced table has
rank four over the rationals and three modulo five; that its modular kernel is
spanned by \(u_2-u_3\) and \(-u_1+3u_2-u_4+u_5\); and that both of those lie in
the conference tangent space with multiplier zero.

## Mystery ledger

- **Settled — the characteristic-five drop.** The modular kernel is the
  \(\mu\equiv0\) hyperplane of the conference tangent space; the drop is three
  because that hyperplane is four-dimensional and contains the scaling line.
  The mechanism is the engine identity and the anticommutation with the third
  compound.
- **Settled — why the two elevens agreed.** Cancelling offsets, not a shared
  cause. The C815 sentence should be corrected rather than promoted.
- **Settled — why three is not a bad prime.** The only prime the compound
  grading can see is the ramified prime of \(\mathbf Z[\varphi]\), which is
  five; two is the separate primitive-normalization factor.
- **Settled — the divisibility step.** Closed by the gauge-coordinate reduction
  and the modular equivariant argument, both written out in the C815 report. The
  five-adic route this note first proposed was not needed.
- **Settled — the \(-5\) minor.** Its divisibility by five is forced by the
  modular rank drop and is independent of the chosen rows and orbit basis; only
  the cofactor \(-1\) is a normalization artifact. The C815 ledger entry that
  deflated the minor entirely is corrected there.
- **Open — characteristic two.** The rank-four collapse of the primitive
  Jacobian has no explanation here and no analogue of the engine identity.
- **Closed — the exceptional-ladder connection.** Negative, for the reasons
  above.
