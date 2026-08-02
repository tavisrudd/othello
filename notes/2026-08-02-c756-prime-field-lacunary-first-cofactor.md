# C756 — prime-field lacunary first-cofactor gate

**Lane**: clebsch · **Date**: 2026-08-02 · **Scope**: saturated-internal,
bounded Route-L discriminator

## Verdict

The cleared first angle coefficient has an exact canonical one-variable
realization, but its reduced support and Cartier width are not bounded on the
existing prime-field coherent candidates.  They reach full or near-full linear
size at (p=11,19,23).  This triggers Route L's stated stop gate.

The canonical section is as follows.  Write

\[
  G=\prod_{i=1}^k f_i,
  \qquad
  E_2=\sum_{a<b}f_af_b\prod_{r\notin\{a,b\}}f_r^p
  \in\mathbf F_p[X],
\]

where (k=(p+3)/2) and the (f_i) are the irreducible quadratic factors
attached to the internal points.  On the component (f_i=0), Frobenius kills
the derivatives of the (p)-th powers and gives

\[
 E_2'(z_i)=f_i'(z_i)
   \sum_{j\ne i}f_j(z_i)
     \prod_{r\ne i,j}f_r(z_i^p)=f_i'(z_i)C_i.
\]

Since (f_i'(z_i)=z_i-z_i^p), the polynomial (X-X^p) is invertible in the
reduced algebra (mathbf F_p[X]/(G)), and

\[
 \boxed{\mathcal C=E_2'(X)(X-X^p)^{-1}\pmod G}
\]

is the desired cleared first-cofactor section without a componentwise tangent
choice.  Further division by

\[
 \left(G'(X)(X-X^p)^{-1}\right)^p
\]

recovers the un-cleared first angle-moment section.  Thus the reformulation is
exact, canonical, and genuinely stronger than the old constant-coefficient
master divisibility.  It does not lower the degree or support enough to start a
lacunary theorem.

## Bounded prime-field discriminator

The deterministic checker evaluates every normalized pairwise-character
candidate in the existing audited prime fields.  For each candidate it builds
(G), computes (mathcal C) in the quotient algebra, and records degree,
monomial support, and the nonzero first (p)-sections

\[
 \Lambda_r\!\left(\sum_n a_nX^n\right)
   =\sum_m a_{pm+r}X^m,
 \qquad 0\le r<p.
\]

The last statistic is the width of the first Cartier/(p)-kernel layer.  Because
the reduced representative has degree at most (p+2), iteration depth alone is
automatically small; width is the nontrivial recurrence discriminator.

| (p) | candidates | (mathcal C=0) | support range | degree range | nonzero (p)-section range |
|---:|---:|---:|---:|---:|---:|
| 5 | 2 | 2 | 0 | 0 | 0 |
| 7 | 5 | 0 | 3--5 | 8 | 3 |
| 11 | 28 | 0 | 3--14 | 12--13 | 3--11 |
| 19 | 55 | 0 | 3--22 | 20--21 | 3--19 |
| 23 | 39 | 0 | 3--25 | 24--25 | 3--22 |
| 31 | 17 | 0 | 3--5 | 32 | 3 |
| 43 | 23 | 0 | 3--5 | 44 | 3 |

At (p=11) the support reaches (p+3), at (p=19) it again reaches
(p+3), and at (p=23) it reaches (p+2).  The corresponding first Cartier
widths reach (p,p,p-1).  The angle-moment normalization has the same support
ranges.  Hence neither clearing scale is responsible for the linear growth.

There is a real but insufficient endpoint-lacunary texture.  Every tested
(p>5) has one support-three candidate with exponent set
({0,2,p+1}); many (p=7,31,43) candidates have support five in
({0,1,2,p,p+1}).  This does not rescue Route L: the desired theorem must
control every coherent candidate, while the (p=11,19,23) families already
occupy essentially every allowed residue class.  The texture is retained for
the row-transition fallback, where endpoint exponents may reflect low-degree
torus transitions rather than global cofactor lacunarity.

This is a bounded falsifier, not an all-prime nonexistence theorem.  It proves
that the predeclared support/Cartier discriminator fails on the exact searched
domain; it does not prove that no different lacunary invariant can exist.

## Trust and replay

Run from the repository root:

```sh
python3 notes/2026-08-02-c756-prime-field-lacunary-first-cofactor.py --check
sha256sum notes/2026-08-02-c756-prime-field-lacunary-first-cofactor.{py,json}
```

The scope is all (169) normalized candidates in
(p\in\{5,7,11,19,23,31,43\}), using the same canonical enumeration and
field model as the prior saturated-internal audit.  There is no randomness.
For an invariant cross-check independent of the quotient-ring recurrence, the
checker evaluates the resulting sections at every quadratic root and compares
them pointwise with (i) a direct product-and-sum evaluation of (C_i) and
(ii) a direct sum of the cross-ratio angles.  The two positive (p=5)
candidates vanish identically; every one of the (167) negative (p>5)
candidates is nonzero.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-02-c756-prime-field-lacunary-first-cofactor.py` | 10,964 | `4fc33a8730c287319fcb8ab151aef72f2bcd1470a5f5c67a4b4b9b0aa65faf64` |
| `notes/2026-08-02-c756-prime-field-lacunary-first-cofactor.json` | 11,873 | `f00f37e5e8cc7068409c0de134badc76e8557f2f35b315efb85c8de197f2e0e2` |
| input `notes/2026-08-01-c756-probability-cheap-tests.py` | 20,904 | `34fe706268e51f4ed09a95ec64424430e11f46d9e03fae320ca16eac0580fff2` |
| input `notes/2026-08-01-c756-saturated-internal-audit.json` | 3,842 | `acabee2fa04d61e6673c60a5cc429ba11f9e294e233a96c53d8451d91f6104d7` |

The machine-readable output certifies only the stated finite candidate domain,
normalization, support profiles, and exact pointwise identities.  The human
derivation above identifies the section intrinsically on the reduced root
divisor.

## EJ + TT closeout

**EJ.**  The free upgrade was to test both natural scales: the cleared cofactor
(mathcal C) and the angle moment obtained by dividing by the Frobenius power
of the complementary factor.  Their identical support ranges rule out the
obvious possibility that linear growth is a clearing artifact.  The persistent
({0,2,p+1}) and ({0,1,2,p,p+1}) endpoint patterns are also retained as
exact input for Route Q rather than discarded with Route L.

**TT.**  The canonical derivative construction solves the conormal bookkeeping
problem but exposes the real obstruction: reduction modulo (G) mixes the
Frobenius-lacunary high-degree expression across essentially all residue
classes.  A useful next attack must compare rows before this global mixing.
That is precisely the four-point row-transition route, whose outputs are least
rational degree, pole divisor, and cross-ratio defect.

## Mystery ledger

| mystery | status | exact gap / owner |
|---|---|---|
| Can the local factor (f_i) be removed canonically? | settled | (mathcal C=E_2'/(X-X^p)\bmod G) does so without tangent choices |
| Does either natural normalization have bounded support? | settled negatively on the declared gate | support reaches (p+3,p+3,p+2) at (p=11,19,23) |
| Does a bounded-width Cartier recurrence survive? | settled negatively on the declared gate | first (p)-section width reaches (p,p,p-1) at the same fields |
| Why do endpoint-supported subclasses persist? | open | profile their row transitions under Route Q; they do not carry the uniform cofactor proof |
| Does a different lacunary invariant exist? | open but unowned | no candidate is promoted without a new bounded carrier; do not continue Route L by renaming this section |
| What is the next saturated-internal gate? | settled | Route Q: rational row-transition degree, poles, and four-point defect |
