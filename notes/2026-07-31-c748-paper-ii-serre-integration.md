# C748 — Paper II Serre-style integration review

**Lane:** clebsch

**Date:** 2026-07-31

**Status:** parity-specific truncation repaired; the post-repair
context-free reader returned GO and the modular verdict is pending

## 2026-08-01 alt-attack plan

The cold reads found a genuine defect in the advertised outer-parity
calculation.  The reduction \(t^{q+m}=t^{m+1}\) is equivariant under a
nonsquare diagonal element, so it contributes no Euler sign.  Unequal
inner labels also survive the outer symmetrizer in two-row orbits.  The
manuscript must not use either shortcut.

The repair is split at the prime/extension-field boundary.

1. **Prime fields.**  Use tilting structure.  Here
   \(d=(p-3)/2<p\), so \(F=\operatorname{Sym}^2L(d)\) and
   \(\operatorname{Sym}^2F\) are tilting.  The first-Frobenius candidates
   attached to \(L(s)\) are \(L(s+1,1)\) and \(L(s-1,1)\); every
   indecomposable tilting summand in the relevant highest-weight range has
   restricted simple socle, so neither candidate embeds.  This closes the
   selected \(s=2,4,6,8,12\) rows without carry signs.
2. **Extension fields.**  The degree-\(<2q\) root equations inject the
   finite/rational Hom quotient into the first Frobenius section
   \(Y_1=\nabla(1)\otimes\nabla(1)^{(e)*}\).  Use Steinberg for every
   intransitive stabilizer and \(L(q-7)\), with the opposite linear outer
   parity, for the sole transitive nonsplit-dihedral reflection case.
   The first-section Hom vanishes by top divided-power relations.
3. **Acceptance.**  Obtain a fresh modular-representation GO and a
   separately isolated context-free exposition GO.  Only after both
   verdicts may release validation, trust metadata, synchronization,
   lifecycle closeout, or C749 begin.

Rejected routes are retained as red-team evidence: the Euler-sign
cancellation, carry annihilation by pair symmetry, torus-plus-positive-root
injectivity, a blanket low-height restriction claim, and automatic outer
stabilization of transitive nonsplit-dihedral matchings all fail.

### Documented repair plan after the fresh NO-GO verdicts

The readers correctly rejected the unrestricted injection from the
finite/rational Hom quotient into the first Frobenius section.  The theorem
needs only the extension opposite to the determinant-normalized one.  Repair
that smaller statement directly:

1. decompose an opposite-parity finite map into algebraic-torus weights
   \(q-1\) and \(1-q\);
2. factor its positive-root defect uniquely as \((t^q-t)\beta_+\) and use
   the cocycle identity to prove that \(\beta_+\) has weight \(q+1\);
3. use the negative-root defect and divided-power commutators to build the
   full four-weight \(L(1)\otimes L(1)^{(e)}\) map, including its
   \(t^{q+1}\) coefficient; and
4. combine the resulting injection with the already proved first-section
   Hom vanishing, then submit the exact repaired text to two new isolated
   readers.

The manuscript now carries steps 1--4 explicitly.  No claim is made about
the unrestricted finite/rational quotient, and the BNP filtration is no
longer used to supply such a claim.

### First execution result

The prime-field half is now reduced without finite-row combinatorics.  If
\(e=1\), then \(d<p\), so \(L(d)\) is tilting and both symmetric squares
are direct summands of tensor squares.  Hence
\(M=\operatorname{Sym}^2F\) is tilting with indecomposable summands
\(T(n)\), \(0\le n\le2p-6\).  The first-Frobenius section sends a selected
\(L(s)\) only through
\[
 L(s)\otimes L(1)\otimes L(1)^{(1)}
 =\bigl(L(s+1)\oplus L(s-1)\bigr)\otimes L(1)^{(1)}.
\]
Thus its possible sources are \(L(s+1,1)\) and \(L(s-1,1)\).  The socle
of every \(T(n)\) in this range is restricted, so neither two-digit simple
embeds in \(M\).  This closes the first-Frobenius contribution for all five
prime-field test rows.

For \(e>1\), the same argument is unavailable.  The first Frobenius
section is an actual direct submodule, so its contribution must vanish
rationally rather than be killed by a connecting differential.  For
Steinberg this is now closed: after tensoring with \(Y_1\), the head has
highest weight \(2q-2\), above the highest weight \(2q-6\) of \(M\).
The case \(e=2\) is the same because \(L(p-1,p-1)\) is Steinberg there.
The initially proposed remaining input was
\[
 \operatorname{Hom}_{\mathbf G}
 \bigl(L(p-1,p-1)\otimes Y_1,M\bigr)=0
\qquad(e\ge3),
\]
but the third execution result below refutes it at \(q=27\).  A
positive-root fixed-vector test is
not sufficient: at \(q=7\), the highest line of the \(\Delta(8)\) section
is an odd actual-weight fixed vector although it does not define an
\(L(2)\)-homomorphism.  The extension-field calculation must therefore
include the Weyl/negative-root relations from the outset.

### Second execution result: the exact seam of the rejected module

Put \(B=L(p^2-1)\otimes L(1)=T(p^2)\).  The tempting claim that
\(B\otimes L(1)^{(e)}\) is tilting is false: Frobenius twist does not
preserve rational tilting modules.  Put \(r=p^2\) and
\(Y_a=\Delta(a)\otimes L(q)\).  The Frobenius sequence
\[
 0\longrightarrow\Delta(q-a-2)
 \mathrel{\mathop{\longrightarrow}^{\theta_a}}\Delta(q+a)
 \longrightarrow Y_a\longrightarrow0,
 \qquad \theta_a(v)=F^{(a+1)}v,
\]
together with
\[
 0\longrightarrow\Delta(r)\longrightarrow T(r)
 \longrightarrow\Delta(r-2)\longrightarrow0
\]
reduces the remaining vanishing to injectivity of the two maps
\[
 \theta_a^*:\operatorname{Hom}_{\mathbf G}(\Delta(q+a),M)
 \longrightarrow
 \operatorname{Hom}_{\mathbf G}(\Delta(q-a-2),M),
 \qquad a=r,r-2.
\]
Equivalently, every nonzero primitive vector of weight \(q+a\) in \(M\)
must survive \(F^{(a+1)}\).  These are the two Carter--Payne seams that
the next attack must calculate.
For example, at \(q=27,p=3\) the source module has formal character
\(\chi(36)+\chi(34)-\chi(18)-\chi(16)\); its negative coefficients
explicitly rule out the spurious Weyl-filtration shortcut.  More sharply,
the same-inner-label transvectant scalar is
\[
 \binom{(q+a)/2+2(i-j)}{a+1}\pmod p.
\]
At \(q=27\) it vanishes on three of the six source rows for \(a=9\), and
on all four source rows for \(a=7\).  Thus a diagonal argument cannot
work: any proof must use off-diagonal recoupling between unequal inner
labels.  The next calculation shows that this hoped-for injectivity is
itself false.

### Third execution result: counterexample and replacement split

The Carter--Payne gate is not injective.  There is a compact exact
witness, so this conclusion needs no computational evidence.  In
\(W=\nabla(12)\), put
\(e_i=X^{12-i}Y^i\), and write \([a,b\mid c,d]\) for the sum over the
distinct \(\mathfrak S_2\wr\mathfrak S_2\)-orbit.  Then
\[
\begin{split}
v={}&2[0,0\mid0,7]+2[0,0\mid1,6]+2[0,0\mid3,4]\\
   &+[0,1\mid0,6]+[0,1\mid3,3]
\end{split}
\]
has weight \(34\).  Direct Lucas expansion gives
\(E^{(1)}v=E^{(3)}v=F^{(8)}v=0\); the first two equalities imply all
positive divided-power equations.  Hence \(\Delta(34)\to M\) factors
nontrivially through
\(Y_7=\Delta(34)/\Delta(18)\).  Its determinant exponent differs from
the ordinary extension by \(13=(27-1)/2\), so it has exactly the
previously claimed absent outer parity.
Since
\[
 0\longrightarrow Y_9\longrightarrow
 T(9)\otimes L(27)\longrightarrow Y_7\longrightarrow0,
\]
this map also refutes the required Hom vanishing for
\(S=L(p-1,p-1)\).  Off-diagonal recoupling cannot repair that choice.

There is a cleaner replacement over many extension fields.  A simple
with a normalizer-fixed zero line has all digits even, and the normalizer
sign is \((-1)^{\sum_jc_j/2}\).  Hence:

* if \(p\equiv1\pmod4\) or \(e\) is even, the full Steinberg module
  closes the argument;
* in the residual congruence \(q\equiv3\pmod4\), use \(L(q-7)\) with
  the outer extension opposite to its linear occurrence in \(F\).
  For \(p\ge7\) the underlying \(H\)-simple does occur in \(F\), but
  only with the determinant-normalized parity; the selected opposite
  extension still has zero linear moment.  Its first-Frobenius Hom
  vanishes by the two top divided-power relations.  In characteristic
  \(3\), write the source as \(T(3)\otimes R^{(2)}\): its two generators
  map to the one-dimensional top two target weight spaces, and the
  relations \(F^{(6)}g=0\) and \(E^{(1)}v=g\) force both coefficients to
  vanish.  This is uniform for every \(e\ge3\).

Subgroup separation sharpens this further.  Steinberg has
\[
 \dim\operatorname{St}^K
   =\#(K\backslash\mathbb P^1)-1,
\]
so it handles every cyclic stabilizer, every split dihedral stabilizer,
and every proper nonsplit dihedral stabilizer.  The sole geometric
residual is the full nonsplit normalizer of order \(q+1\), acting
regularly on the endpoints, with the matching given by right
multiplication by a reflection.  The two reflection classes are the two
\(H\)-sheets.

The initially tried sign-corrected replacement \(L(q-1-2p)\) leaves an
unresolved adjacent first-wall pair, so it supplies no proof.  The better
choice \(L(q-7)\) uses outer parity at the linear stage and top
divided-power relations at the first finite-defect stage.  The
parity-specific defect lemma below excludes all aliases of that parity; no
higher-layer filtration claim is needed.

### Fourth execution result: fresh cold reads

The fresh modular and context-free readers independently returned
NO-GO.  Both identified the same load-bearing gap: the standard
filtration of
\(\operatorname{ind}_{\operatorname{SL}_2(q)}^{\operatorname{SL}_2}k\)
does not by itself inject finite-only Hom classes into its \(m=1\)
section.  A degree-\(<2q\) equation controls one root subgroup at a time,
but the manuscript must still construct the global defect map and exclude
mixed or higher filtration layers.  The BNP citation supplies the
filtration, not this stronger conclusion.  Acceptance is closed again.

### Fifth execution result: parity-specific closure

The common cold-read objection is repaired without strengthening the BNP
filtration.  If \(X=\operatorname{Hom}(S,M)\), its weights have absolute
value at most \(3q-7\).  A finite-torus-fixed vector of the selected outer
parity therefore has only weights \(q-1\) and \(1-q\); the even aliases
\(0,\pm2(q-1)\), which invalidate the unrestricted injection, are absent.

For such a vector \(\phi\), the exact root-defect identity is
\[
 u_M(t)\phi u_S(-t)-\phi=(t^q-t)\beta_+.
\]
Comparing its coefficients at \(t\) and \(t^q\) forces
\(\operatorname{wt}(\beta_+)=q+1\).  The Weyl-conjugate defect supplies
the lowest vector.  The four vectors
\(\beta_+,\phi_+,\phi_-\), and \(w\beta_+\) satisfy exactly the complete
root-action table of \(L(1)\otimes L(1)^{(e)}\), including the mixed
\(t^{q+1}\) term.  Thus
\[
 \operatorname{Hom}_{\operatorname{PGL}_2(q)}(S^\square,M)
 \hookrightarrow
 \operatorname{Hom}_{\mathbf G}
   (S\otimes L(1)\otimes L(1)^{(e)},M).
\]
The right side was already proved zero for each detecting module.  This is
the needed opposite-parity statement; the unrestricted statement remains
false and has been removed.

## Integrated causal spine

1. A two-valued quadratic trade line forces the matching orbit to split
   into its two \(\operatorname{PSL}_2(q)\)-sheets.
2. A \(p'\)-matching stabilizer makes a sheet permutation module projective
   and self-dual.  Frobenius reciprocity plus the permutation pairing puts an
   actual nontrivial self-dual simple in its socle, including when the
   principal projective cover occurs.
3. The finite-group Lucas equations give the actual socle Hom space.  One
   outer extension is absent from \(\operatorname{Sym}^2F\), including the
   unique finite first wall.
4. If the forbidden quadratic moment has zero linear part, it embeds in the
   absent parity.  If its linear part is nonzero, the exact cocycle
   \(z_i(g)(t)=i(t)c(g)\) contracts either through a retracted Fischer factor
   or through the unique adjacent-wall trace/spill pair.  Both alternatives
   contradict the moment-map splitting.
5. Hence each sheet has size \(q\).  Orbit--stabilizer and Dickson's list
   leave \(q=5,7,9,11\); block-system arguments remove \(5,9\), and the
   surviving cases are exactly \(q=7,11\).

## Modular-representation cold pass

Internal verdict: **GO, non-independent**.

The pass reconstructed the projective-socle step, the finite-group degree
bound, the determinant-normalized outer action, the partial-trace
contraction, the first-wall Clebsch--Gordan row, and every exceptional test
module.  It rejected and repaired three points:

- a retraction \(E\to S\) was replaced by the legitimate
  \(S\hookrightarrow F\twoheadrightarrow S\) contraction;
- the algebraic-group Lucas argument was extended across the sole finite
  wall, with the two compensating sign changes written explicitly; and
- one-digit nonsplitting was separated from multi-digit Lucas absence.

A later theorem-only hostile pass challenged the one-digit application once
more: the lemma states nonsplitting conditionally on the outer parity of the
unique \(S\to F\) line.  The apparent gap is resolved by the same dichotomy.
If the forbidden extension does not occur in \(F\), then \(i_\square=0\) and
the quadratic moment embeds in the absent square parity.  If
\(i_\square\ne0\), it itself spans the unique Hom line, so that line has
parity \(S^\square\) and the first-wall clause applies.  This implication is
now explicit in the manuscript.  The pass also isolated the only numerical
exception to the Borel weight-gap estimate, \((p,s,e)=(3,0,2)\); the Lucas
congruence makes its Hom line absent, so the spill branch never uses it.

The generic-wall programs remain conditional corroboration and are not used
as proof of the adjacent-wall identification.

## Context-free exposition cold pass

Internal verdict: **GO, non-independent**.

Read from the theorem backward, without the C746/C747 task reports, the text
determines the obstruction and the two survivors from its own definitions.
The single obstruction is the incompatible pair
\[
 (p-2-s)x=1,\qquad x=0,
\]
unless a Fischer retraction already detects the affine class.  The final
classification is memorable as
\[
 \text{two levels}\Rightarrow\text{two PSL sheets}
 \Rightarrow |\text{sheet}|=q
 \Rightarrow |K|=(q^2-1)/2
 \Rightarrow q=7,11.
\]

## Validation

The current files pass `git diff --check`.  The authoritative guarded release
aggregate passes: all three Lean gates elaborate, the axiom allowlist is clean,
the manuscript rebuild succeeds, the warning scan reports no findings, and the
release verifier reports `CHECK OK`.  The first document pass exposed three
overfull boxes; the long Hom expression and divided-power identity were moved
to displays, the citation sentence was shortened, statement identity and the
evidence fingerprint were regenerated, and the changed aggregate then passed.

## Advisory golden-review response

The 2026-08-01 golden-paper review is one referee-style input, not an
authority.  Each criticism was checked against the current manuscript.

Accepted and repaired: the five malformed `,qquad` separators; the colliding
and skipped equation tags; the theorem comma splice and misleading “fibers”;
the stale Paper I title; the abstract's unexplained internal vocabulary; the
introduction's weak emphasis on completeness; and the lack of navigational
subsections, a proof-strategy paragraph, and a compact uniform-exclusion case
table.

Rejected as stale: the requested repair of the former one-carry/cyclic-carry
argument, because the current proof uses the parity-specific defect injection
and contraction instead.  Rejected as disproportionate churn: a global rename
of both uses of (L), since the evaluation space and simple modules occur in
separate, locally explicit scopes.  The review's repackaging suggestions are
deferred by instruction.

## Open acceptance gate

C748 required two readers independent of the authoring/red-team pass: one
finite-group/modular-representation reader and one context-free exposition
reader.  Two readers correctly returned NO-GO on the discarded carry proof,
and two more correctly returned NO-GO on the unrestricted finite-to-rational
truncation.  Fresh post-repair readers independently returned GO on the
parity-specific proof, one modular and one context-free.  The human-proof
acceptance gate is therefore closed; structural Lean coverage remains the
separate C750 task.

## Mystery ledger

| feature | status | remaining gate |
|---|---|---|
| projective principal summand | settled | no remaining C748 gate |
| finite outer parity | settled by parity-specific repair | no remaining C748 gate |
| false \(L(p-1,p-1)\) route | refuted by exact witness | retained red-team check |
| causal exposition | independently reconstructible | no remaining C748 gate |
| human-proof freeze | closed by two independent `GO` verdicts | none |
| structural Lean | partial spine exists | C750 completion |

The closeout extra-juice and Tao-style pass found no further cheap repair
beyond the strategy paragraph, subsection spine, and uniform-exclusion table
already added.  No genuine C748 mystery remains: the incomplete structural
Lean coverage is an explicit C750 evidence gap, not an unexplained feature of
the human proof.

## Vibe check

The proof now has a clean, memorable spine: one projective-socle input, one
Lucas parity calculation, one functorial contraction, and one adjacent-wall
spill.  The two cold reads agree that this spine is referee-readable; the
remaining risk is formal coverage, not a known human-proof defect.
