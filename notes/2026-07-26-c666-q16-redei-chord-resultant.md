# C666: the \(q=16\) Rédei quotient stops at an all-eight-fiber gate

**Lane:** `relconic`

**Result:** complete negative as a replacement for the \(q=16\)
augmentation certificate.

The projection proposed after C663 does expose a sharp local identity, but
its last branch is real rather than spurious.  An exact \(\operatorname{GF}(16)\)
example below satisfies the required quotient divisibility on seven of the
eight labeled arc fibers simultaneously.  Two of those seven fibers are the
exceptional all-allowable-roots branch.  The eighth fiber fails at one
explicit off-conic hole.  Consequently:

1. no one-fiber Rédei argument can force the second conic point to remain
   uncovered;
2. compatibility across any seven labeled fibers still does not do so; and
3. the only surviving route is an intrinsically all-eight exclusion.

No all-eight analytic exclusion was obtained.  The known assertion that it
cannot occur is precisely what the existing exhaustive eight-arc
classification proves.  Thus this route does not remove that certificate.

## 1. The exact fiber quotient

Let \(A=\{a_1,\ldots,a_8\}\) be an eight-arc disjoint from a nonsingular conic
\(\mathcal C\), and suppose that every point outside \(A\cup\mathcal C\) is
covered by a secant of \(A\).  Choose an ordinary-uncovered point
\(u\in\mathcal C\).  On the fiber
\[
 L_i=ua_i
\]
write \(c_i\) for its second conic point.  Choose an affine coordinate \(T\)
on \(L_i\) for which \(u\) is the point at infinity.  For \(j,k\ne i\), let
\(x_{jk}(i)\) be the intersection of \(a_ja_k\) with \(L_i\), and put
\[
 S_i(T)=\prod_{\substack{j<k\\j,k\ne i}}
        (T-x_{jk}(i)).
\]
This is the labeled complementary-\(K_7\) chord product of degree \(21\).

The fourteen affine points of \(L_i\) outside
\(\{a_i,c_i\}\) must all be covered.  A secant through one of them cannot
contain \(a_i\), since \(A\) is an arc, so it is one of the complementary
chords.  Hence
\[
 D_i(T):=\frac{T^{16}-T}{(T-a_i)(T-c_i)}
 \quad\text{divides}\quad S_i(T),
\]
and
\[
 S_i=D_iE_i,\qquad \deg E_i=7.                 \tag{1}
\]

There are two branches.

- If \(c_i\) is uncovered, the distinct roots of \(S_i\) are exactly the
  fourteen roots of \(D_i\).
- If \(c_i\) is covered, then \((T-c_i)D_i\mid S_i\).  The product has all
  fifteen allowable affine roots, and removing it leaves degree six.

The second alternative is the local exceptional branch.  In the standard
lacunary-polynomial formulation, after the common repeated-root factor is
removed it is the case proportional to \(T^{16}-T\).  This is the same
exceptional case isolated by Theorem 2.1 of Simeon Ball's
[full paper on small complete arcs](https://web.mat.upc.edu/people/simeon.michael.ball/complete.pdf),
read in full (especially pp. 1--5).  Ball excludes it for the ordinary
complete-arc polynomial by a degree ordering between the two remaining
pieces.  Multiplication by the conic equation contributes the extra
degree-two term here, so that ordering is unavailable.

## 2. Why the collision count adds nothing

The projection collision budget is exactly the old incidence moment in new
coordinates.  The \(28\) secants have
\[
 3\binom84=210
\]
intersections from disjoint edge pairs; the \(168\) pairs of secants sharing
an arc endpoint meet on \(A\).  Equivalently, after subtracting the forced
off-conic coverage and separating conic incidence, the projected excess is
the already-known identity
\[
 \sum_{x\notin \mathcal C\cup A}\binom{r(x)-1}{2}
   =38+D-W,
\]
where \(D=\sum_{w\in\mathcal C}r(w)\) and
\(W=\sum_{w\in\mathcal C}\binom{r(w)}2\).
Thus neither pair collisions nor their first excess moment distinguish the
two branches of (1).

## 3. The conditional involution route

Every \(a\notin\mathcal C\) induces an involution
\(\tau_a\) of \(\mathcal C\): \(\tau_a(u)\) is the second conic point on
\(au\).  If the exceptional branch could be excluded, (1) would give
\[
 u\in U \Longrightarrow \tau_a(u)\in U
 \quad(a\in A),
\]
where \(U\) is the conic part of the ordinary-uncovered locus.  The set \(U\)
would then be invariant under all eight involutions.  This would open the
small-complement subgroup analysis suggested after C663.

The implication is false locally: the exceptional branch says exactly that
\(\tau_a(u)=c_i\) is covered.  The following example shows that the failure
persists through seven mutually compatible fibers.

## 4. Exact seven-fiber near-counterexample

Use the polynomial-basis encoding
\[
 \operatorname{GF}(16)=\operatorname{GF}(2)[\alpha]/(\alpha^4+\alpha+1)
\]
and the standard point ordering
\[
 (0,0,1),\quad (0,1,z),\quad (1,y,z).
\]
Take the eight-arc with point indices
\[
 A=(0,1,17,34,52,67,89,127)
\]
and the nonsingular conic
\[
 X^2+11Y^2+4Z^2+4XY+10XZ+9YZ=0.       \tag{2}
\]
The conic has \(17\) points, is disjoint from \(A\), and its polar radical
does not lie on (2).  Point \(u=240\) is ordinary-uncovered.

The exact complementary-chord computation is:

| arc position | arc point | second conic point | quotient (1) | distinct roots | branch |
| ---: | ---: | ---: | :---: | ---: | :--- |
| 0 | 0 | 228 | yes | 15 | exceptional, residual degree \(6\) |
| 1 | 1 | 176 | yes | 14 | ordinary, residual degree \(7\) |
| 2 | 17 | 205 | yes | 14 | ordinary, residual degree \(7\) |
| 3 | 34 | 218 | yes | 14 | ordinary, residual degree \(7\) |
| 4 | 52 | 156 | yes | 14 | ordinary, residual degree \(7\) |
| 5 | 67 | 197 | **no** | 14 | off-conic hole \(264\) |
| 6 | 89 | 138 | yes | 14 | ordinary, residual degree \(7\) |
| 7 | 127 | 219 | yes | 15 | exceptional, residual degree \(6\) |

Thus seven fiber quotients arise from one global labeled \(K_8\) chord
product and one global nonsingular conic.  In particular, all compatibility
relations involving only those seven restrictions are already present.
The two degree-six branches prove that the \(T^{16}-T\) alternative is
geometrically realizable by genuine \(K_8\) chords, not merely permitted by
an overly weak polynomial theorem.

The sole failure is equally sharp: on \(u\,a_5\), point \(264\) is
ordinary-uncovered and does not lie on (2).  Any successful replacement
therefore has to couple all eight fibers strongly enough to detect this one
point.  The separate restrictions, their degrees, their squarefree root
sets, and every subsystem of seven fibers do not suffice.

There is a stronger collapse.  The six ordinary holes
\[
 240,\ 176,\ 205,\ 218,\ 156,\ 138
\]
have quadratic-evaluation rank \(5\), and their one-dimensional quadratic
kernel is generated by (2).  Thus the seven successful fibers already
determine the conic uniquely.  The all-eight gate is exactly the question
whether hole \(264\) evaluates to zero on that quadratic; it does not.
Consequently the residual/resultant route returns to the same quadratic
evaluation test used by the existing leaf certificate.  It has not produced
an independent certificate-free invariant.

## 5. Reproducible certificate

The deterministic checker and its canonical output are:

- `notes/2026-07-26-c666-q16-redei-chord-resultant.py`;
- `notes/2026-07-26-c666-q16-redei-chord-resultant.json`.

Replay from the repository root:

```text
python3 notes/2026-07-26-c666-q16-redei-chord-resultant.py --check
```

The checker independently verifies exact field arithmetic, the eight-arc
condition, nonsingularity and disjointness of (2), ordinary uncoveredness of
\(u\), all \(21\) complementary chords on every fiber, the root
multiplicities, the seven quotient divisibilities, both exceptional fibers,
and the unique displayed failed fiber.  It imports neither the augmentation
list nor its Lean certificate.

SHA-256:

```text
71d6ceef68a11d881159e1e1c89ffa0679663fcf427601654b53b60d675ebfac  notes/2026-07-26-c666-q16-redei-chord-resultant.py
5c78c9073e0218da8caafe0a8a8dc86b344200855aea6230c1ffb5b891df3c4d  notes/2026-07-26-c666-q16-redei-chord-resultant.json
```

## 6. Boundary left behind

The C663 projective-code route failed because evaluation forgets the split
\(K_8\) lift.  C666 restores those labels and obtains the exact degree-seven
fiber quotients, but the exceptional degree-six branch survives on genuine
geometry and can coexist on seven fibers.

The remaining statement would have to be an all-eight theorem:

> No eight-arc \(A\), nonsingular conic \(\mathcal C\) disjoint from \(A\),
> and \(u\in\mathcal C\) ordinary-uncovered can satisfy (1) on all eight
> fibers \(ua_i\).

This statement is necessary for the desired certificate-free proof, but no
independent resultant, subgroup, or lacunary-polynomial proof of it was
found.  The present exhaustive classification implies it; using that
implication would merely repackage the certificate C663 was meant to remove.
Accordingly, the honest endpoint is negative: retain the existing checked
\(2633\)-leaf certificate for \(\rho_{\mathcal C}(16)=9\).

## Mystery ledger

- **Settled:** the projected complementary-\(K_7\) product has a universal
  degree-\(14\) divisor and a degree-\(7\) residual.
- **Settled:** the collision budget is the old second-moment identity.
- **Settled:** the exceptional all-allowable-roots branch is realizable by
  genuine labeled chords.
- **Settled:** seven simultaneous quotient identities, including two
  exceptional fibers, do not force the eighth.
- **Settled by the `ej`+`tt` closeout:** the six holes exposed by the seven
  successful fibers uniquely determine the conic, so the all-eight
  resultant gate collapses to the original quadratic-evaluation question.
- **Open:** a genuinely all-eight invariant that excludes the final failed
  fiber without invoking the augmentation classification.
