# Module 49. The naive canonical completion is not in the total-space phase

**Packet part:** Module 49.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** the geometric-phase hypothesis isolated in Module 48 fails for
every admissible chamber of the five genuine unit-wall pilots.  The added
weight \((1,-1)\) creates explicit new semistable points.  Thus the
Coates--Iritani--Jiang completed quotient cannot be identified naively with
Shoemaker's \(\operatorname{Tot}(K_X)\) for those pilots.  The abstract
divided-rank theorem survives, but this direct realization route does not.

## 49.1 The support-cone test

Let a split torus \(T\) act on

\[
                         W=\bigoplus_{i=1}^N\mathbf C_{\beta_i}
                                                                    \tag{49.1}
\]

and let \(\theta\in X^*(T)_\mathbf R\) be a rational linearization.  For a
point \(w=(w_i)\), write

\[
                         S(w)=\{\beta_i:w_i\ne0\}.              \tag{49.2}
\]

The affine torus Hilbert--Mumford criterion says

\[
 w\in W^{\mathrm{ss}}_\theta
       \quad\Longleftrightarrow\quad
 \theta\in\operatorname{Cone}(S(w)).                           \tag{49.3}
\]

Adjoin one coordinate of weight \(c\) and write a point as \((w,t)\).

### Proposition 49.1 -- exact phase criterion

The equality

\[
                    (W\oplus\mathbf C_c)^{\mathrm{ss}}_\theta
                       =W^{\mathrm{ss}}_\theta\oplus\mathbf C_c
                                                                    \tag{49.4}
\]

holds if and only if, for every subset \(S\) of the weight multiset of
\(W\),

\[
 \theta\in\operatorname{Cone}(S\cup\{c\})
       \quad\Longrightarrow\quad
 \theta\in\operatorname{Cone}(S).                              \tag{49.5}
\]

#### Proof

If \(t=0\), the two semistability tests agree.  If \(t\ne0\), the support of
\((w,t)\) is \(S(w)\cup\{c\}\).  Applying (49.3) shows that a new
semistable point exists exactly when the antecedent of (49.5) holds and its
consequent fails.  \(\square\)

This criterion tests the semistable locus, not merely equality of total
characters or canonical bundles after a quotient has already been formed.

## 49.2 The genuine unit-wall geometry

Assume \(W\) is one of the five quasi-symmetric genuine signatures in
Theorem 41.4, and use Module 41's rank-two basis.  The raw discrepancy
character and canonical completion weight are

\[
                         \kappa(W)=(-1,1),
 \qquad
                         c=-\kappa(W)=(1,-1).                  \tag{49.6}
\]

In (41.15f), genuine-wall strictness gives
\(x=A-s>0\) and \(y=B-s>0\).  Quasi-symmetric line balance therefore gives
raw nonzero weights of both signs on both coordinate axes.  In particular
the raw weight multiset contains

\[
 E=(1,0),\qquad W_0=(-1,0),\qquad
 N=(0,1),\qquad S=(0,-1).                                     \tag{49.7}
\]

The admissible intermediate chamber is one of the northeast, southeast, or
southwest open quadrants.  The northwest quadrant is excluded by the raw
discrepancy ray \((-1,1)\), as in Corollary 41.4A.

### Theorem 49.2 -- phase failure in every admissible quadrant

For every generic chamber character \(\theta\) in the northeast,
southeast, or southwest quadrant,

\[
 (W\oplus\mathbf C_c)^{\mathrm{ss}}_\theta
        \supsetneq W^{\mathrm{ss}}_\theta\oplus\mathbf C_c.    \tag{49.8}
\]

#### Proof

Write all coefficients below as positive real numbers.

**Northeast.**  If \(\theta=(a,b)\) with \(a,b>0\), then

\[
                         \theta=a\,c+(a+b)N.                   \tag{49.9}
\]

Hence a point supported only on the completion coordinate and one raw
\(N\)-coordinate is completed-semistable.  Its raw support is \(\{N\}\),
whose cone does not contain the interior northeast character \(\theta\).

**Southwest.**  If \(\theta=(-a,-b)\) with \(a,b>0\), then

\[
                         \theta=b\,c+(a+b)W_0.                 \tag{49.10}
\]

The same argument with raw support \(\{W_0\}\) gives a new semistable point.

**Southeast.**  Write \(\theta=(a,-b)\) with \(a,b>0\).  If \(a>b\), then

\[
                         \theta=b\,c+(a-b)E.                   \tag{49.11}
\]

If \(b>a\), then

\[
                         \theta=a\,c+(b-a)S.                   \tag{49.12}
\]

If \(a=b\), the completion coordinate \(c\) alone spans \(\theta\).
In the first two cases the corresponding one-ray raw support does not span
the interior southeast character; in the third case the raw support is
empty.  All three cases violate (49.5).  \(\square\)

Once (49.7) has been obtained from the five-signature theorem, the proof
uses no further multiplicity data.  Genuine-wall span without the
quasi-symmetric line balance would not by itself force both signs.

### Corollary 49.2A -- all five pilots fail the naive total-space phase

Every oriented chamber selected in Corollary 41.4A violates Module 48's
geometric-phase equality (48.5).  Consequently its canonical completed GIT
quotient is not identified, by the naive same-linearization construction,
with

\[
                  \operatorname{Tot}
                  \bigl(K_{[W^{\mathrm{ss}}_\theta/T]}\bigr). \tag{49.13}
\]

#### Proof

All five signatures satisfy the genuine-wall condition, and Corollary
41.4A leaves only the three quadrants treated by Theorem 49.2.  \(\square\)

## 49.3 What fails in the narrow route

The Coates--Iritani--Jiang comparison on the completed quotient remains a
valid crepant toric comparison whenever all of its hypotheses, including
completed adjacency, DM, and semi-projectivity, hold.  What fails is the
natural same-linearization identification: the intended total-space open is
a proper substack,

\[
 [W^{\mathrm{ss}}_\theta\times\mathbf C_c/T]
   \subsetneq
 [(W\oplus\mathbf C_c)^{\mathrm{ss}}_\theta/T].               \tag{49.14}
\]

Strictness here concerns this natural open inclusion; it does not claim
that no accidental abstract isomorphism of the two stacks can exist.

Therefore Shoemaker's total-space Euler coimage and shifted Thom point
cannot be imported through (48.6) for these pilots.  Modules 45--47 were
conditional on precisely this realization, so Theorem 49.2 is not a
counterexample to their abstract statements.  It is a counterexample to
their most direct proposed instantiation.

The obstruction occurs before any primitive projector, Gamma framing,
resonant specialization, or row calculation.  More analytic precision
cannot repair the wrong semistable locus.

## 49.4 What survives

The following results are unaffected:

1. Module 43's common-window rank and normal-jet calculation on an actual
   completed quotient;
2. Module 45's proper-support functoriality for any genuine proper
   Fourier--Mukai correspondence;
3. Module 46's divided-rank theorem for any actual equivariant Thom
   presentation; and
4. Module 47's horizontal primary-sector transport.

What is lost is only the assertion that the naive canonical completed
quotient supplies the Thom/narrow presentation required to compose those
four results.

## 49.5 Possible repairs

The phase no-go leaves several logically distinct alternatives.

### A. Restrict to the intended open total space

The open substack

\[
                  [W^{\mathrm{ss}}_\theta\times\mathbf C_c/T]
                                                                    \tag{49.15}
\]

is still the desired line-bundle total space.  One could try to prove that
the completed Fourier--Mukai/Gamma comparison restricts to these opens and
that the complement contributes only divided-rank-zero terms.  Proper
support and exact base change would have to be redone for this open
restriction; CIJ does not state it automatically.

### B. Use a relative or \(p\)-field stability condition

One may impose stability only on the \(W\)-coordinate, treating the
completion coordinate as a fibre rather than as an additional GIT
coordinate.  This produces (49.15) by definition, but it is no longer the
ordinary affine GIT problem to which Module 45 was applied.  A relative
crepant/narrow comparison theorem would be needed.

### C. Change the completion

For an ordinary multi-coordinate affine completion, the exact acceptance
test is the evident extension of Proposition 49.1: for every raw support
\(S\) and every subset \(A\) of the added weights,

\[
 \theta\in\operatorname{Cone}(S\cup A)
       \quad\Longrightarrow\quad
 \theta\in\operatorname{Cone}(S).
\]

Module 50 proves that no finite list of ordinary added coordinates can pass
this test while having total weight \(c\).  A stacky completion with an
enlarged group or a master space remains possible, but requires its own
Hilbert--Mumford criterion.  Any successful replacement must also preserve
the primitive fibre parameter and admit a proper comparison kernel.

### D. Return to the normal-jet route

Module 43 does not require identifying the whole completed quotient with
\(\operatorname{Tot}(K_X)\).  Its remaining vertical realization may be
easier than constructing a new phase-safe narrow completion.

## 49.6 Source and scope audit

The only external input in Proposition 49.1 is the standard affine-torus
support-cone form of Hilbert--Mumford.  The weights (49.6)--(49.7) and
admissible quadrant list are the proved Module 41 pilot data.  No statement
about arbitrary non-unit AKMW overlaps is inferred.

Coates--Iritani--Jiang is not contradicted: their theorem applies to the
completed chamber quotient when its own hypotheses hold.  Shoemaker is not
contradicted: his narrow QDM applies to an actual vector-bundle total space.
The failed step is the proposed identification between those two geometric
objects.

## 49.7 EJ/TT and mystery ledger

**EJ.** The finite five-signature search was not wasted: its genuine axis
weights give a uniform three-line proof that the naive total-space phase
fails in every admissible orientation.

**TT.** Check semistable supports before comparing quantum theories.  Zero
total character proves crepancy of the enlarged quotient, not that the
enlarged quotient is the intended line bundle.

| question | status | exact evidence or gate |
|---|---|---|
| Does the naive completed semistable locus equal the base locus times the fibre? | **no for all five pilots** | Theorem 49.2 |
| Is CIJ invalidated? | **no** | it applies to a different completed quotient |
| Is Shoemaker invalidated? | **no** | the intended total space still has its narrow QDM |
| Can the two be composed naively? | **no** | Corollary 49.2A |
| What is the cheapest repair? | **unknown** | test open restriction A against normal-jet route D |

## Boundary

Module 49 closes the naive canonical-completion/narrow-QDM instantiation
negatively for every five-signature genuine unit pilot.  It does not rule
out relative \(p\)-field comparisons, restriction of the completed
correspondence to the intended open total spaces, an enlarged-group master
space, or the independent normal-jet adapter.  Module 50 rules out the
remaining finite ordinary multi-coordinate variant.
