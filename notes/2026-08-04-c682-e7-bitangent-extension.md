# C682 — the optimal E7 bitangent code extends the E6 tritangent code

**Date:** 2026-08-04  
**Task:** C682  
**Lane:** `clebsch`  
**Status:** exact research bundle; no manuscript or Lean file changed

## Result

The next finite exceptional object preserves all of the strongest properties
of the (E_6) code.  Let (V=mathbf F_2^6) carry its standard symplectic
form and let (mathcal Q^-) be its 28 odd quadratic refinements, classically
the 28 bitangents of a marked plane quartic.  Restrict the affine linear
functions on the six-dimensional affine space of quadratic refinements to
(mathcal Q^-).  The resulting code is

\[
 \boxed{C_{E_7}=[28,7,12]_2},
 \qquad
 W_{C_{E_7}}(z)=1+63z^{12}+63z^{16}+z^{28}.
\]

Its 63 minimum words are exactly the Steiner complexes indexed by
(V\setminus\{0\}), and they span the code.  Shortening at any one of the 28
bitangent coordinates gives

\[
 \boxed{
   \operatorname{Short}_{q_*}(C_{E_7})
   \simeq C_{E_6}=[27,6,12]_2
 }
\]

with weight enumerator

\[
 1+36z^{12}+27z^{16}.
\]

The checker verifies all 28 shortenings and constructs an explicit coordinate
permutation identifying one shortening word-for-word with the independently
constructed Cartan-tritangent kernel from the (E_6) bundle.  Under this
identification the 36 shortened minimum words are exactly the 36 Schläfli
double-sixes.

Thus the previously isolated (E_6) optimum is the one-coordinate shortening
shadow of an (E_7) optimum:

\[
 \boxed{
  \begin{array}{ccccc}
  E_7:&28\text{ bitangents}&\longleftrightarrow&63\text{ Steiner complexes}
       &[28,7,12]_2\\
  &&\downarrow\text{ shorten one bitangent}&&\\
  E_6:&27\text{ lines}&\longleftrightarrow&36\text{ double-sixes}
       &[27,6,12]_2.
  \end{array}}
\]

This is a genuine level-up theorem, not a numerical analogy.

## Intrinsic construction

Write a vector of (V) as ((x,y)inmathbf F_2^3\oplusmathbf F_2^3) and
the 64 quadratic refinements as

\[
 q_{a,b}(x,y)=x\cdot y+a\cdot x+b\cdot y.
\]

The odd refinements are precisely the 28 pairs with (a\cdot b=1).  The
seven-dimensional code is spanned by the constant word and the six coordinate
linear functions in (a,b).  For every nonzero (vin V),

\[
 S_v=\{q\in\mathcal Q^-:q(v)=0\}
\]

has size 12.  These 63 supports are all the minimum words.  For distinct
(v,w), exact intersection gives

\[
 |S_v\cap S_w|=
 \begin{cases}
 4,&\langle v,w\rangle=0,\\
 6,&\langle v,w\rangle=1.
 \end{cases}
\]

Consequently the minimum-shell intersection relation reconstructs the
symplectic polar space (W(5,2)).  Transposing its support matrix gives 28
distinct weight-27 columns, the 28 odd quadratic refinements themselves.  The
minimum shell is also a (2)-((28,12,11)) design.

Fix (q_*\in\mathcal Q^-).  The other odd refinements are (q_*+\langle
t,-\rangle) for the 27 nonzero (q_*)-singular vectors (t).  Requiring a
codeword to vanish at (q_*) removes the affine constant, leaving the six
linear functions on those 27 vectors.  This explains the dimension drop
(7\to6) and makes the (E_7\to E_6) shortening structural.  The exact
minimum-shell cooccurrences after shortening are 8 on 135 coordinate pairs
and 6 on 216 pairs; the count-8 graph is the 27-line intersection graph, and
its 45 triangles are the Cartan tritangents by the independent (E_6)
certificate.

Group-theoretically, choosing (q_*) reduces the transitive
(operatorname{Sp}_6(2)) action on 28 odd refinements to its index-28
orthogonal stabilizer, isomorphic to (W(E_6)).  This is the symmetry reason
that one marked (E_7) bitangent exposes the (E_6) 27-line carrier.

## Exact SOTA status

Both levels attain unrestricted optimal parameters.

- For ([28,7]), distance 13 would require Griesmer length
  (13+7+4+2+1+1+1=29), so (d\le12).  The displayed code attains 12.
- The current public table gives exact optimum 11 for ([28,8]).  Hence the
  code is also dimension-maximal at distance 12: one cannot add an eighth
  dimension without losing distance.
- For ([27,6]), distance 13 would require Griesmer length
  (13+7+4+2+1+1=28), so the shortened (E_6) code is likewise optimal.

The public table realizes some ([28,7,12]) code by shortening an extended
BCH code.  No code-equivalence or historical audit was performed to decide
whether that stored construction is equivalent to the bitangent code, and no
novelty claim is made for the parameters or geometric realization.

The (E_7) code is doubly even and self-orthogonal.  Its dual is
([28,21,4]_2); its 315 minimum words are the zero-sum, or syzygetic,
bitangent tetrads.  The resulting CSS code is ([[28,14,4]]).  This quantum
code is not SOTA: a ([[28,14,5]]) stabilizer code is publicly recorded.  The
series crown is the optimal classical shortening ladder, not the quantum
parameter.

There is a direct obstruction to gaining that missing quantum unit while
retaining (C_{E_7}) as one half of a ([[28,14]]) CSS construction.  If
(C_X=C_{E_7}), then (C_X^perp) contains 315 weight-four tetrads.  CSS
commutation requires the seven-dimensional (C_Z) to lie in
(C_X^perp), but (C_Z) contains at most 127 nonzero words.  It therefore
cannot absorb all 315 tetrads, so at least one remains a weight-four logical
operator.  Hence

\[
 \boxed{
 C_X=C_{E_7},\quad k_{m quantum}=14,\quad\text{CSS}
 \quad\Longrightarrow\quad d_{\rm quantum}\le4.}
\]

The highest-value route to five is a non-CSS phase lift.  Replace the two
unsigned binary copies by seven Hermitian-self-orthogonal checks over
(mathbf F_4), with (1,\omega,\omega^2) labels supplied by the signed
56-weight (E_7) carrier or its (E_8) bracket.  Equivalently, construct on
the 56 antipodal weights first and fold each pair to a Pauli (X,Y,Z) label.
The exact next test is whether the public ([[28,14,5]]) generator has the
same theta-characteristic support skeleton after coordinate permutation and
local phase relabeling.  A positive result would identify the missing unit as
a cocycle/phase effect; a negative full-equivariance test would show that
distance five requires breaking the full (E_7) symmetry.

The CSS alternative is a rate trade: adjoin mutually orthogonal checks whose
syndromes hit all 315 tetrads.  This is a finite covering/SAT problem and
necessarily lowers the protected dimension.  A subsystem variant can instead
promote the tetrads to gauge operators.  Neither route preserves the exact
([[28,14]]) CSS parameters.

Public comparisons checked in full on 2026-08-04:

- ([28,7]), exact 12:
  <https://www.codetables.de/BKLC/BKLC.php?q=2&n=28&k=7>;
- ([28,8]), exact 11:
  <https://www.codetables.de/BKLC/BKLC.php?q=2&n=28&k=8>;
- ([[28,14,5]]) encoding record:
  <https://www.markus-grassl.de/QECC/circuits/28_14_5.html>.

These sources establish parameter context only.  No paper full text or code
classification literature was read for this bounded comparison.

## What this changes about the higher ladder

The (E_{10}) boundary-transfer idea remains a plausible infinite-family
experiment, but it is no longer the next step.  The finite exceptional tower
now has a proved optimal link at (E_6\subset E_7), whereas the unsigned
(E_6\times A_2\subset E_8) support lift gives only ([81,8,36]_2), two below
the unrestricted optimum.

The highest-value next finite object is therefore the 56-dimensional
minuscule (E_7) carrier inside

\[
 \mathfrak e_8=(133,1)\oplus(1,3)\oplus(56,2),
\]

with the signed Freudenthal quartic or the signed (E_8) bracket retained.
The exact question is whether its kernel has an optimal homogeneous minimum
shell whose shortening or antipodal quotient returns the 28-bitangent code.
Only after this (E_7\to E_8) finite gate should the affine (E_9) and
hyperbolic (E_{10}) transfer directions be introduced.

## Evidence and replay

From `/home/tavis/src/othello`, run

```sh
python3 notes/2026-08-04-c682-e7-bitangent-extension.py --check
sha256sum -c notes/2026-08-04-c682-e7-bitangent-extension.sha256
```

The checker uses only the Python standard library.  It constructs all 28 odd
quadratic refinements and all 63 Steiner supports, enumerates the complete
(2^7)-word code, checks all 28 shortenings, and reconstructs the symplectic
pairing from every pair of minimum words.  It independently imports the
Cartan-support constructor, derives the (E_6) kernel, recovers both
27-vertex graphs from minimum-shell cooccurrences, finds an exact graph
isomorphism by equitable-refinement backtracking, and compares the transported
codes word-for-word.  It also proves dual distance four by exhausting all
subsets of at most four generator columns and counts all 315 minimum dual
words.  No randomized step or external algebra package is used.

## EJ + TT closeout and mystery ledger

- **Settled — why 27 becomes 28.**  The extra coordinate is the marked odd
  quadratic refinement; shortening there removes exactly the affine constant
  direction and recovers the six-dimensional (E_6) code.
- **Settled — why 36 becomes 63.**  The 63 nonzero symplectic vectors index
  all Steiner complexes.  Exactly 36 avoid a fixed bitangent and survive as
  the (E_6) minimum shell.
- **Settled — optimality preservation.**  Griesmer proves distance optimality
  at both levels, and the exact ([28,8,11]) bound proves dimension maximality
  of the (E_7) point at distance 12.
- **Settled — dual shell.**  The 315 weight-four dual words are the syzygetic
  tetrads and give exact CSS parameters ([[28,14,4]]); public comparison
  rules out a quantum SOTA claim.
- **Settled — fixed-rate CSS obstruction.**  A seven-dimensional opposite
  CSS half cannot contain all 315 tetrads, so any ([[28,14]]) CSS code with
  an (E_7) half has distance at most four.
- **Open — representation-theoretic identity.**  The checker proves exact
  coordinate equivalence after shortening, but a manuscript-quality proof
  should state the (W(E_6)\subset W(E_7)) stabilizer argument and identify
  double-sixes inside Steiner complexes without coordinates.
- **Open — next finite lift.**  It is unknown whether signed Freudenthal or
  (E_8)-bracket linearization on the 56 carrier preserves an optimal code
  frontier or realizes the known ([[28,14,5]]) phase lift.  Unsigned support
  alone cannot remove the tetrad logicals.
- **Open — novelty/equivalence.**  The relation to catalogued BCH and
  classical bitangent codes has not received a claim-specific literature
  audit.

## Vibe check

This is the cleanest code-series connection found so far.  It explains the
(E_6) code as a forced shortening of the next exceptional geometry, retains
unrestricted optimality in both distance and dimension, and replaces a
speculative jump to (E_{10}) with a concrete finite ladder whose next gate
is sharply defined.
