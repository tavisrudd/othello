# C912 — the atom-route imports, read at the source

**Date:** 2026-08-15
**Lane:** `cubic-threefolds`
**Task:** C912 (literature verification and memo edit; no manuscript edit)
**Follows:** `2026-08-15-c912-blowup-formula-source-check.md`

The atom route to the endpoint rested on four statements of
Katzarkov–Kontsevich–Pantev–Yu that this lane had never read. The paper is in
the cache after all — under a key my earlier search missed, since the cache
lists titles and I searched author names. All four are now read. One of them
overturns a verdict I gave two reports ago.

## Verdicts

1. **All four imports check out verbatim.** The non-rationality criterion, the
   nef-canonical single-atom lemma, the regular-singularity claim and the
   projective-bundle formula all say what the memo says they say, with no hidden
   hypotheses that bite here.
2. **Correction: the memo's transcription was faithful, and my earlier verdict
   was wrong.** Example 6.21 really does state the graded minimal polynomial as
   `S^5 = [3]`. I previously concluded the memo had transposed Kuznetsov's
   `S^3 = [5]`; it had not. The discrepancy is between
   Katzarkov–Kontsevich–Pantev–Yu's convention and the categorical one, not a
   copying slip, and it is systematic: their Example 6.20 gives `S^3 = [4]` for
   the cubic fourfold, whose Kuznetsov component is a K3 category with `S = [2]`
   categorically. The lattice computation stands as computed — it is in the
   categorical convention — but it does not convict the memo of anything.
3. **The Serre automorphism is *defined* as the monodromy in the `u`-direction**,
   with compatibility `chi(a,b) = chi(b, S(a))`. That is exactly the relation
   this lane's scripts use. So on the F-bundle side the identification of the
   count with Serre eigenvalues is definitional, not conjectural; what remains
   expected-rather-than-proved is only the comparison with the *categorical*
   Serre functor of a Kuznetsov component.
4. **Step (iii) upgrades, and in the direction their own argument uses.** Every
   atom of a smooth projective surface has monodromy of order at most two —
   eigenvalues in `{+1, -1}` — not merely "no primitive sixth root". That is the
   same discriminator they use for the cubic fourfold, where the exclusion is
   unipotency versus non-unipotency.
5. **The hard part of their machinery is not needed.** They flag the enhancement
   by *integral structures* as difficult and defer it to forthcoming work, but
   say the enhancement by Euler pairings and Serre automorphisms "is completely
   straightforward and is just a repeat of the theory of undecorated Hodge
   atoms". The route this lane needs uses only the second.

## 1. Source and reading list

Katzarkov, Kontsevich, Pantev, Yue Yu, *Birational Invariants from Hodge
Structures and Quantum Multiplication*, arXiv:2508.05105. Cached copy: key
`arXiv:2508.05105`, fetched 2026-08-10, 82 pages, PDF SHA-256
`2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64`;
`litcache.py verify` reports 773 entries and no problems. Read: Lemma 5.24 with
its proof reference, Lemma 5.25, Claim 6.15 with its statement and the opening
of its proof, Proposition 5.30, Theorem 4.11 with its proof reference, the
Leray–Hirsch subsection 4.3, the passage defining the duality automorphism and
the enhanced criterion, and Examples 6.20 and 6.21 in full. Not read: the proofs
of Theorems 4.5 and 4.11, Section 5's general theory, and the deferred
integral-structure work.

## 2. The four imports, as stated

**Proposition 5.30 (non-rationality criterion).** For `X` smooth projective of
dimension `d >= 2`, if a Hodge atom `alpha` appears in the atomic decomposition
of `X` and `alpha` is not in `HAtoms` of dimension `<= d-2`, then `X` is not
rational. So in dimension three the exclusion is over points and curves, and in
dimension four it is over points, curves and surfaces — exactly as the memo
records. The enhanced form, stated in the same section, replaces atoms by
enhanced atoms and reads: if `X` has an enhanced atomic composition containing an
enhanced atom that does not come from a smooth projective variety of dimension
at most `dim X - 2`, then `X` cannot be rational.

**Lemma 5.24.** For a connected smooth projective variety with numerically
effective canonical class, the Hodge atoms consist of a single atom.

**Claim 6.15.** If the canonical class is nef, the quantum connection has a
regular singularity at the origin; more precisely, after the gauge by `u^g`
together with the half `Td` term, the connection has a first-order pole and a
*nilpotent residue*. They then use it in the form: the conjugacy class of the
monodromy is well defined and is unipotent on even cohomology, and
quasi-unipotent with eigenvalue `-1` on odd cohomology.

**Theorem 4.11 (Leray–Hirsch).** For a vector bundle of rank `r` over a smooth
projective variety `X`, there is a canonical isomorphism of maximal F-bundles
between the projective bundle and the disjoint union of `r` copies of `X`, over
analytic domains whose unions are connected and nonempty; the proof reduces to
Iritani–Koto's Theorem 5.1. With `r = 2` and the trivial bundle this is the
statement that puts two copies of the cubic threefold's atom into its product
with the projective line.

## 3. The convention question, settled as a convention question

Example 6.21, quoted: the atom of a smooth cubic threefold "looks like the atom
of a smooth projective curve of genus 5 but when viewed as a Hodge atom enhanced
with a Serre automorphism, the corresponding Serre automorphism `S` in the
cohomological Z-grading satisfies the graded minimal polynomial `S^5 = [3]`".

So the memo copied correctly and my previous report's verdict 1 was wrong. What
is true is the incompatibility, not its attribution: on the numerical
Grothendieck group the Serre operator of the cubic threefold's Kuznetsov
component has characteristic polynomial `Phi_6` and satisfies `S^3 = -I`,
matching Kuznetsov's `S^3 = [5]` and not `S^5 = [3]`. Their Example 6.20 shows
the same offset in dimension four, giving `S^3 = [4]` where the Kuznetsov
component is a K3 category with `S = [2]`. Two data points make this a
convention difference — theirs is the Serre automorphism of a Hodge atom in the
cohomological Z-grading, ours is the categorical Serre functor on a K-group —
rather than an error in either place. Which of the two the manuscript cites
should follow which object it is talking about.

**The half-parity gauge is the other half of the same story.** Their statements
are made after the gauge by `u^g`; the memo's count is defined before it. The
gauge shifts exponents by half the cohomological degree, so it multiplies
monodromy eigenvalues by a sign that depends on parity: primitive sixth roots
become primitive cube roots, and `+-1` swap. That is the same substitution
`lam -> -lam` recorded as ledger item C912-M27 between the prime-Fano
classification's polynomial `R` and the Serre side, and it is now explained
rather than merely observed. Every separation used below survives the
substitution, because it separates roots of unity of order at most two from
roots of order three or six, and the gauge preserves that distinction.

## 4. Step (iii), upgraded

Their exclusion for the cubic fourfold is unipotency: the monodromy of an atom of
a surface of general type is unipotent on even cohomology, while the atom in
question is not. The surface induction proves the same shape of statement for
*all* surfaces, and in the stronger form:

> **(iii')** Every atom of a smooth projective surface has monodromy eigenvalues
> in `{+1, -1}`; that is, its formal monodromy has order at most two.

The four cases give exactly this. A blowup adds the atom of a point, of trivial
monodromy, and Iritani's decomposition transports the rest. A surface with nef
canonical class has nilpotent residue after the half-parity gauge, so unipotent
monodromy there and eigenvalues `+-1` before the gauge. The projective plane has
semisimple small quantum cohomology, so every block is multiplicity one and the
memo's own simple-block theorem gives `mu_i = 0` and identity monodromy. A
projective bundle over a curve reduces to the curve, whose even part has
exponents `+-1/2` and therefore monodromy `-1` twice, matching their own sentence
about higher-genus curves after the gauge is accounted for.

Note that their Example 6.20 needs only surfaces of general type, because the
atom there is shaped like one. The endpoint needs all surfaces, because the
cubic threefold's atom is shaped like a genus-five curve atom rather than a
surface atom, so nothing narrows the search a priori. That is why (iii') had to
be proved rather than cited.

## 5. What now follows for the endpoint

The target statement is: for `X` a smooth complex cubic threefold, `X x P^1` is
not rational. The argument has four steps.

1. **The atom exists in `X`.** The atomic decomposition of `X` at the hyperplane
   point consists of two one-dimensional atoms at the nonzero eigenvalues of
   Euler multiplication and one atom `alpha(X)` at the eigenvalue zero
   (Example 6.21), with no further splitting nearby by their Remark 3.14 Witt
   algebra argument.
2. **The atom's monodromy.** In this memo's normalization the zero block has
   exponents `-1/6` and `-5/6`, so the formal monodromy eigenvalues of
   `alpha(X)` are the two primitive sixth roots of unity — order six. This is
   the lane's own computation, not an import.
3. **The atom appears in `X x P^1`.** Writing `X x P^1 = P(O + O)`, Theorem 4.11
   with `r = 2` gives a canonical isomorphism of maximal F-bundles between
   `X x P^1` and the disjoint union of two copies of `X`, over analytic domains
   whose unions are connected and nonempty. So the atomic decomposition of
   `X x P^1` contains two copies of `alpha(X)`.
4. **The atom comes from no variety of dimension at most two.** Points give
   trivial monodromy; a curve has even-part exponents `+-1/2`, hence monodromy
   `-1` twice; a surface has monodromy of order at most two by (iii'). Order six
   is none of these.

The criterion that then applies is **not** the numbered Proposition 5.30**.**
That one excludes membership in `HAtoms` of dimension at most `d-2` for
*undecorated* Hodge atoms, whereas steps 2 and 4 distinguish atoms by their
monodromy, which is a decoration. The applicable statement is the enhanced form,
which the authors give as unnumbered prose in the same section: "with the
enhancements in place, we get a stronger version of the nonrationality criterion
Proposition 5.30. In this version we conclude that if a smooth projective variety
`X` has an enhanced atomic composition containing an enhanced atom that does not
come from a smooth projective variety of dimension `<= dim X - 2`, then `X` can
not be rational." With `dim(X x P^1) = 4` the excluded dimensions are at most
two, which is what steps 1 to 4 supply.

That distinction matters for how much this route imports. The numbered
proposition is proved in their paper as a special case of Proposition 5.17. The
enhanced version, which is the one needed here, is asserted in prose, on the
grounds that the theory of Hodge atoms enhanced with Euler pairings and Serre
automorphisms "is completely straightforward and is just a repeat of the theory
of undecorated Hodge atoms". So the load-bearing citation for this route is an
assertion rather than a numbered theorem, and any manuscript using it either
proves the enhanced criterion in the generality it needs or states plainly that
it is quoting an assertion.

Two further dependencies, both stated: Theorem 4.11 holds over analytic domains
and its proof reduces to Iritani–Koto's Theorem 5.1, which has not been read
here; and the monodromy has to be an invariant of the enhanced atom, which is
the same assertion again. The route does *not* depend on the integral-structure
enhancement they defer to forthcoming work, and does not depend on any transport
lemma or on the memo's refuted Section 10.

The practical consequence: the one-stabilization statement is available by this
route without the memo's Section 10, which remains refuted, and without the
rigidity theorem. Whether to take that route is an editorial decision about
importing the atom framework, not a mathematical gap.

## Mystery ledger updates

| ID | Status | Discovery | Owner |
|---|---|---|---|
| C912-M26 | resolved, verdict corrected | Katzarkov–Kontsevich–Pantev–Yu's Example 6.21 does state `S^5 = [3]`, so the memo transcribed faithfully and the earlier "transcription slip" verdict was wrong. The incompatibility with the lattice is real but is a convention difference between their Hodge-atom Serre automorphism in the cohomological grading and the categorical Serre functor on a K-group; their Example 6.20 shows the same offset in dimension four. | Section 3 here; supersedes `../2026-08-15-c912-step-iii-serre-restatement.md` verdict 1 |
| C912-M25 | refined | Their Serre automorphism is *defined* as the monodromy in the `u`-direction, with `chi(a,b) = chi(b,S(a))` — the relation this lane's scripts already use. The identification of the count with Serre eigenvalues is therefore definitional on the F-bundle side; only the comparison with the categorical Serre functor of a Kuznetsov component remains expected rather than proved. | Section 1 passage on the duality automorphism |
| C912-M27 | explained | The `lam -> -lam` substitution between the classification's `R` and the Serre side is the half-parity gauge `u^g`, which shifts exponents by half the cohomological degree and so multiplies monodromy eigenvalues by a parity-dependent sign. All separations used here are invariant under it. | Section 3 here |
| C912-M35 | confirmed | Step (iii) upgrades to (iii'): every atom of a smooth projective surface has monodromy of order at most two. This is the same discriminator Katzarkov–Kontsevich–Pantev–Yu use for the cubic fourfold, where they need only surfaces of general type; the endpoint needs all surfaces because the cubic threefold's atom is shaped like a curve atom. | Section 4 here |
| C912-M36 | open | The endpoint follows from Theorem 4.11, the *enhanced* non-rationality criterion and (iii'), with no transport lemma and no integral structures. The enhanced criterion is the load-bearing one, since the argument separates atoms by monodromy, which is a decoration; it is asserted in unnumbered prose rather than proved, unlike the numbered Proposition 5.30. Any manuscript using this route must either prove it in the generality needed or quote it as an assertion. | Section 5 here |

## Replay

No computation. All claims are quotations from a cached source; the cache key,
hash and reading list are in Section 1, and the manifest verifies clean.
