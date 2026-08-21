# Cold referee report: *Frobenius-equivariant pair extension and robust repair of eight-arcs*

Date: 2026-08-21  
Referee perspective: finite geometry and coding theory  
Verdict scale: A = ready; B = local repairs; C = major revision / missing bridge / material overclaim; D = central failure

## Recommendation

**Verdict: C (major revision).**

The carrier count, the invisible-center/collision identity, all four structural
profiles over \(\mathbf F_{25}\), the five-profile envelope for \(s\ge 7\), and
the alternate-repair subtraction are mathematically sound. The paper has a
clean organizing idea and an appropriate distinction between configuration
repair and decoding.

The central order-five conclusion nevertheless depends on Proposition 5.3,
whose only bridge from a semantic invariant arc to the certified normalized
coordinate slice is asserted in four sentences on pp. 7--8. The certificate is
explicitly said to terminate at the normalized classification, so it cannot
prove this bridge. The manuscript does not specify the first normalization,
define “first admissible selected conjugate pair,” prove the stabilizer
transitivity used for the second normalization, or identify the 46,056-row
finite domain with all normalized semantic arcs. Thus the manuscript, as
written, does not establish that the exhaustive finite result applies to every
two-fixed-point eight-arc. This is a missing load-bearing proof, not merely a
request for more implementation detail.

I would invite a major revision rather than reject the mathematical project.
The missing normalization lemma appears likely to have a short coordinate
proof, but that proof and the semantic-to-finite correspondence must be in the
paper (or formally certified), not inferred from an unavailable artifact.

## Frozen identity and read surface

- Frozen manuscript authority commit requested: `9977af02cfed699c1c14802242a6f500896164bc`.
- `git cat-file -t` verified that this object is a commit.
- Frozen PDF SHA-256 requested and independently obtained:
  `0ecdf6e1689a407a47da0f1c03693da2466ae3dd1221b6462e548ed4a97d691f`.
- Streaming the PDF blob at the frozen commit through SHA-256 produced the same
  digest. The working-tree PDF also produced the same digest.
- The checkout HEAD at review time was
  `e1b58fd8a79a763012a21fa4d32f8904c8d9eb04`, so I did not treat HEAD as the
  authority; I reviewed the byte-verified frozen PDF.
- Read in full: all 15 pages of the PDF, including references.
- Inspected only where needed: manuscript source for Sections 1--7 and the
  source/rendering of Figure 1. The figure was rendered independently at 150
  dpi and inspected at full resolution.
- For a bounded novelty check, I used four direct web queries around
  Frobenius-invariant arcs, conjugate-pair extension, and \(\mathrm{PG}(2,q^2)\),
  and inspected the relevant primary Baker--Wantz paper, especially its
  maximality argument on p. 9. This confirms that the manuscript fairly
  acknowledges genuine precedence for adjoining a point with its Frobenius
  image; the bounded check found no exact carrier-count precursor. It is not a
  systematic historical-priority audit.
- Deliberately not read: internal task notes, an existing referee dossier,
  prior reviews, chat history, or git history/logs.
- Deliberately not run or inspected: Lean, Lake, Q25 certificates, certificate
  generators, large builds, or prior computational reports.

## Correctness assessment

### 1. Mate lines, empty carriers, and secant-orbit count (pp. 2--4)

**Correct.**

For a nonfixed point \(P\), the line \(P\phi(P)\) is a fixed line. A fixed line
has \(s^2+1\) points, exactly \(s+1\) fixed, hence
\((s^2-s)/2\) nonfixed conjugate pairs. Lemma 2.4 correctly counts occupied
fixed lines as
\[
 f(s+1)-\binom f2+e.
\]
The mate lines of the selected nonfixed pairs are distinct and avoid selected
fixed points because the old set is an arc.

The fixed old secants are exactly the \(\binom f2\) fixed-point secants and the
\(e\) selected mate lines. Consequently
\[
 M=\frac{\binom k2-\binom f2-e}{2}=fe+e(e-1)
\]
is correct. Theorem 3.1 then correctly charges at most one candidate on each
empty carrier to each nonfixed secant orbit. Distinct carriers have disjoint
candidate sets by uniqueness of the mate line, so multiplication by \(E\) is
legitimate.

### 2. Invisible centers and collision correction (pp. 5--6)

**Correct.**

A nonfixed secant orbit is invisible on a fixed carrier precisely when its
fixed center lies on that carrier. Thus \(A_\ell=M-B_\ell\). The definition
\(R_\ell=\sum_Q(\mu_\ell(Q)-1)_+\) gives
\(|F_\ell|=A_\ell-R_\ell\), and hence
\[
 |Q_\ell\setminus F_\ell|+M=N+B_\ell+R_\ell.
\]
Summing yields Corollary 4.2 exactly. The “if and only if” equality condition is
also correct since both correction terms are nonnegative.

Figure 1 is useful, legible at publication size, and distinguishable without
color because the four visible lines use different dash patterns. The caption
states the mathematical point. An optional small improvement would define
\(C_1,C_2\) explicitly in the caption rather than leaving their role to the
preceding prose.

### 3. The four nonexceptional \(\mathbf F_{25}\) profiles (pp. 6--7)

**Correct, with one omitted explanatory equality.**

The table values are right:

| \((f,e)\) | \(E\) | \(M\) | proved lower bound |
|---|---:|---:|---:|
| \((0,4)\) | 27 | 12 | 5 |
| \((4,2)\) | 11 | 10 | 4 |
| \((6,1)\) | 9 | 6 | 36 |
| \((8,0)\) | 11 | 0 | 110 |

For a cross-pair secant orbit, its fixed center lies on neither participating
mate line. At most \(f+(e-2)\) fixed lines through that center are occupied,
giving at least \(s+3-f-e\) invisible empty carriers. This proves \(B\ge4\)
for \((4,2)\) and \(B\ge48\) for \((0,4)\).

The second secant-index moment
\(\sum_{x\notin C}\binom{r_x}{2}=3\binom84=210\) is used correctly. The fixed
external contribution is at most 72; the nonfixed external points on the four
occupied mate lines contribute at most 96; therefore empty-carrier endpoints
contribute at least 42. For a candidate \(Q=\{q,\phi(q)\}\) on an empty
carrier, however, the proof should explicitly state the load-bearing equality
\[
 r_q=r_{\phi(q)}=\mu_\ell(Q).
\]
It follows because each secant through \(q\) belongs to exactly one visible
secant orbit charging \(Q\). With this sentence inserted, the deduction
\(T\ge21\), then \(R\ge11\), and finally \(L\ge5\) is complete. The omission
is local and does not cast doubt on the branch.

### 4. Exceptional two-fixed-point profile and Q25 transport (pp. 7--8, Proposition 5.3)

**Not established by the manuscript. This is the decisive defect.**

The finite terminal claimed in the text is clear: within a normalized
coordinate model, 1,189 representatives cover a 46,056-row slice; five
representatives attain 32; their residual orbits have sizes
\(200,400,400,200,400\); strict and exhaustion certificates classify the
normalized equality rows. I did not run those certificates, and the manuscript
does not ask the reader to regard them as proving anything beyond that
normalized model.

What is missing is the mathematical map into that model:

1. The “prescribed ordered pair” of fixed points is not given in coordinates,
   nor is the projectivity sending an arbitrary ordered pair to it described.
2. “The first admissible selected conjugate pair” is undefined. A semantic arc
   is a set and its three nonfixed orbits have no first element. The proof must
   state whether any one may be chosen, how choices and orderings affect the
   normalized row, and why at least one resulting row lies in the enumerated
   domain.
3. The stabilizer-transitivity claim sending that pair to
   \([1:\omega:\omega]\), \([1:-\omega:-\omega]\) is asserted without a
   lemma, coordinate calculation, or citation. A short matrix proof may well
   suffice, but it is part of the central proof.
4. The manuscript never defines a row of the 46,056-row slice. It does not say
   how projective representatives, unordered conjugate pairs, the two remaining
   selected pairs, and arc admissibility are encoded, or prove that every
   normalized semantic arc produces such a row.
5. The equality transport likewise needs an explicit commutative statement:
   the finite predicate called “legal-pair count” must be identified with
   \(N_{\rm pair}(C)\), and the residual action must be shown to preserve this
   semantic count. The text merely repeats that invariance does the transport.

These are exactly the arguments that pp. 1 and 11 declare to be manuscript
arguments rather than certificate outputs. Until supplied, Proposition 5.3,
Theorem 5.4, Corollary 5.5, Corollary 6.5 at \(s=5\), and Theorem 1.1(i) do not
follow from the displayed evidence.

### 5. Five-profile envelope for \(s\ge7\) (pp. 9--10, Theorem 6.2)

**Correct.**

All five substitutions for \(E_f,M_f,L_f\) check. The displayed vectors at
\(s=7,8,9\) are correct. I also expanded the four claimed differences at
\(s=t+10\): twice \(L_f-L_8\) has nonnegative coefficients for each
\(f=0,2,4,6\). The individual factors in each \(L_f(s)\) are positive and
nondecreasing for \(s\ge7\), so the uniform lower bound 319 follows.

The manuscript could print the four short difference polynomials instead of
appealing to supplementary Lean for elementary algebra. This is optional, but
would improve self-containment.

### 6. Saturation and parameterized repair (pp. 9--10)

**Correct.**

The completed-square identity in Corollary 6.1 is right. If an empty carrier
exists, pair saturation implies \(N\le M\), and
\(4M\le(k-1)^2\) yields the stated ceiling bound.

In Theorem 6.4 the exact profile maximum
\[
 W(k)=\left\lfloor (k-1)^2/4\right\rfloor
\]
is attained at \(f=0\) for even \(k\) and \(f=1\) for odd \(k\). The phase
condition forces the existence of an empty carrier. On that carrier it gives at
least \(r+1\) legal pairs, one of which is the erased orbit, hence at least
\(r\) alternate repairs. The rectangular corollary's inequality is also
correct, including the \((s,k)=(3,4)\) boundary remark.

There is no alternate-repair off-by-one error anywhere in Definitions 2.2,
Corollaries 3.2, 5.2, 5.5, 6.3, or Theorem 6.4. The counts 4 to 3, 319 to 318,
and \(r+1\) to \(r\) all correctly remove the erased orbit itself.

### 7. MDS interpretation

**Conceptually correct, with one definite parameter error.**

The introduction correctly identifies a \(k\)-arc with projective columns of a
\([k,3,k-2]_{s^2}\) MDS code. It also correctly warns that “repair” changes the
generator-column configuration and is not erasure decoding in a fixed code.

On p. 4, Corollary 3.2, the claimed extension
\([6,3,4]_{11}\to[8,5,4]_{121}\) is wrong in this generator-column
interpretation. After scalar extension and adjoining two columns, the code is
\([8,3,6]_{121}\). The printed \([8,5,4]\) code is its MDS dual, not the stated
two-column extension of the dimension-three generator matrix. This must be
corrected.

### 8. Formal and computational trust statement (pp. 11--13)

**Conceptually candid but not yet reproducible from the paper.**

The paper does several things well: it distinguishes structural Lean from the
Q25 certificate; states that the certificate stops at the normalized model;
identifies kernel `decide`; reports the axiom profile; denies admitted proofs,
custom axioms, and `native_decide`; and maps paper claims to declaration names.

Publication still requires the following:

- Give a stable public locator (archival DOI/URL or equivalent) for both the
  structural development and the separately pinned certificate. The current
  paper gives only local paths and `nix run .#verify` “from the package root,”
  without telling a reader where that root can be obtained.
- Put the exact certificate commit and manifest digest in the paper or in a
  cited immutable archive record, rather than only in an unlocatable local JSON
  file. Likewise pin the structural Lean source revision corresponding to the
  declaration table.
- State expected verifier output, approximate runtime/memory, supported
  platform/toolchain entry point, and whether generation from source is part of
  the acceptance gate. “Sealed aggregate and source-reproduction checks” is too
  compressed to reconstruct the trust chain.
- Add the missing semantic normalization/correspondence proof discussed above.
  No amount of axiom auditing of the normalized certificate substitutes for
  that bridge.

I therefore have high confidence in the declared *shape* of the trust boundary,
but cannot validate the exceptional semantic theorem from the manuscript.

## Exposition and internal consistency

The exposition is generally strong. The abstract and introduction state the
object, theorem, mechanism, exceptional computation, and trust boundary early.
The carrier vocabulary is effective; the structural/computational split is
easy to follow; the exact correction is not oversold as an inverse theorem; and
the conclusion returns to the mathematics rather than ending on audit details.

Two definite consistency errors require correction:

1. **p. 11, “Proof of Theorem 1.1.”** Theorem 1.1 has only parts (i) and (ii),
   but the proof says Proposition 5.3 gives (ii) and Theorem 6.2/Corollary 6.3
   give (iii). The intended assignment is: Theorem 5.4/Corollary 5.5 give (i),
   and Theorem 6.2/Corollary 6.3 give (ii); Proposition 5.3 is a supporting
   refinement for the \(s=5\) case.
2. **p. 4, Corollary 3.2.** Replace \([8,5,4]_{121}\) by
   \([8,3,6]_{121}\), unless the sentence is explicitly rewritten as a claim
   about dual codes.

Minor edits: “pairs carrier by carrier” in the abstract is awkward; “counts
pairs carrier by carrier” is clearer. Reference [2] (a 2026 item) and reference
[17] (“Working paper, 2026”) need stable bibliographic locators if they remain
in the submission.

## Novelty and venue significance

The novelty boundary is stated responsibly. In particular, the paper credits
Baker--Wantz for the conjugate-point maneuver, labels the Clebsch specialization
as secondary, and makes no new Lunelli--Sce constant or sharpness claim. My
bounded check is consistent with the narrower claim that the carrierwise
quantitative criterion and the uniform \(\mathrm{PG}(2,25)\) result are not
obvious restatements of the cited predecessors. The sentence reporting database
searches is not independently auditable because it gives no dates, queries, or
result ledger; either provide a compact supplementary search record or soften
it to a conventional “we are not aware” statement.

Correctness and significance should be separated:

- **Correctness:** C until the Q25 normalization/semantic bridge is supplied.
  The general \(s\ge7\) theorem and structural identities are already at B/A
  correctness level after local edits.
- **Significance for a specialist finite-geometry or coding-theory journal:**
  potentially publishable after major revision. The mate-line carrier method is
  simple but useful; the exact correction and robust-exchange formulation give
  it more than example-level value; the exact Q25 exceptional result supplies a
  concrete finite theorem.
- **Significance for a broad or highly selective journal:** modest. The general
  bound is an elementary secant count, and the hardest small-field case is a
  finite census rather than a structural classification of semantic equality
  cases. I would recommend a focused finite-geometry/designs-and-codes venue,
  not a broad top-tier mathematics venue.

## Mandatory repairs before acceptance

1. Supply a complete, checkable normalization-and-transport lemma for
   Proposition 5.3, including coordinates, stabilizer action, treatment of
   choices/orderings, definition of the normalized rows, surjectivity onto the
   enumerated domain, and equality of finite and semantic legal-pair counts.
2. Make the formal/computational artifacts stably retrievable and immutably
   pinned; state verifier output and practical reproduction requirements.
3. Correct the Clebsch extension parameters on p. 4.
4. Correct the malformed proof of Theorem 1.1 on p. 11.
5. In the \((f,e)=(0,4)\) moment proof on p. 7, state
   \(r_q=\mu_\ell(Q)\) and the partition of nonfixed external points by their
   unique fixed mate carrier.

## Optional improvements

1. Print the four elementary difference polynomials used in Theorem 6.2.
2. Add a one-sentence proof of the cross-pair invisible-carrier estimate (9).
3. Define \(C_1,C_2\) explicitly in the Figure 1 caption.
4. Give stable identifiers for references [2] and [17].
5. Replace the unauditable database-search sentence by either a compact search
   appendix or a conventional, narrower awareness statement.

## Confidence

- Structural carrier count and exact correction: **very high (0.98)**.
- Four nonexceptional Q25 profiles: **high (0.95)**.
- \(s\ge7\) envelope, saturation, and parameterized repair: **very high (0.97)**.
- Exceptional normalized census as an artifact claim: **not assessed**, because
  the instructions excluded running or reading the certificate.
- Semantic Q25 theorem from the manuscript alone: **low-to-moderate (0.55)**;
  the result is plausible, but the necessary bridge is absent.
- Novelty assessment: **moderate (0.65)** after a bounded independent check, not
  a systematic priority search.
- Overall verdict confidence: **high (0.93)**.

## Bottom line

This is not a central mathematical failure: the conceptual mechanism and the
entire \(s\ge7\) theory survive scrutiny. It is also not ready after merely local
editing, because the only proof of the \(s=5\) exceptional profile stops at the
precise interface the paper says remains the author's manuscript
responsibility. A revision that proves that interface, exposes immutable
artifacts, and corrects the two parameter/cross-reference errors should receive
a substantially more favorable report.
