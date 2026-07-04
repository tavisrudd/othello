#!/usr/bin/env bash
set -u

cd "$(dirname "$0")/.."

DATE="$(date +%F)"
NOTES="../notes/${DATE}-codex-border-overlap-graph.md"

mkdir -p ../notes
if [[ ! -s "$NOTES" ]]; then
  {
    echo "# Border overlap-graph pass"
    echo "Date: ${DATE}"
    echo "## Running log"
  } > "$NOTES"
fi

{
  echo
  echo "## Theorem-ready overlap lemmas"
  echo
  echo "Status: proof hygiene / theorem drafting.  Claims below are marked individually."
  echo
  echo "Notation: even \`n=2m\`, \`q=n-1\`, \`h=m-1\`, central strike \`c*=(h,h)\`, embedded core \`S=[0..q-1]^2=[0..n-2]^2\`, and live core"
  echo
  echo "\`\`\`text"
  echo "R_n = { (r,c) in S : r != h, c != h, r+c != q-1, r-c != 0 }."
  echo "\`\`\`"
  echo
  echo "The involution is \`tau(r,c)=(q-1-r,q-1-c)\`.  For a legal row-to-column border pair, write \`b=(q,x)\`, \`r=(y,q)\`, where \`x,y in [0,q-1]\\{h}\` and \`x != y\`."
  echo
  echo "### Lemma O1: tau action on additive line labels"
  echo
  echo "Statement.  Inside \`S\`, the involution \`tau\` maps line labels by"
  echo
  echo "\`\`\`text"
  echo "row a  -> row  (q-1-a)"
  echo "col b  -> col  (q-1-b)"
  echo "sum s  -> sum  (2q-2-s)"
  echo "diff d -> diff (-d)"
  echo "\`\`\`"
  echo
  echo "Proof.  If \`(r',c')=tau(r,c)\`, then \`r'=q-1-r\`, \`c'=q-1-c\`, \`r'+c'=2q-2-(r+c)\`, and \`r'-c'=-(r-c)\`.  Each displayed formula is just the corresponding coordinate identity."
  echo
  echo "Status: PROVEN by arithmetic."
  echo
  echo "### Lemma O2: border-pair scar as six line labels"
  echo
  echo "Statement.  The live-core scar of the legal border pair \`(q,x),(y,q)\` is"
  echo
  echo "\`\`\`text"
  echo "scar(x,y) = R_n intersect ("
  echo "    col x"
  echo "  union row y"
  echo "  union sum  (q+x)"
  echo "  union sum  (q+y)"
  echo "  union diff (q-x)"
  echo "  union diff (y-q)"
  echo ")."
  echo "\`\`\`"
  echo
  echo "Proof.  A queen at \`(q,x)\` attacks, inside \`S\`, exactly column \`x\`, difference diagonal \`r-c=q-x\`, and sum diagonal \`r+c=q+x\`; its row \`q\` lies outside \`S\`.  A queen at \`(y,q)\` attacks, inside \`S\`, exactly row \`y\`, difference diagonal \`r-c=y-q\`, and sum diagonal \`r+c=y+q\`; its column \`q\` lies outside \`S\`.  Intersect with \`R_n\` because the central strike has already killed the center row, center column, anti-diagonal \`q-1\), and main diagonal \`0\`."
  echo
  echo "Status: PROVEN by arithmetic."
  echo
  echo "### Lemma O3: active/mate union formula for combined asymmetry"
  echo
  echo "Statement.  Let \`A(x,y)\` be the union of the six active line masks from Lemma O2, restricted to \`R_n\`.  Let \`M(x,y)=tau(A(x,y))\), equivalently the union of the six tau-mate line masks from Lemma O1.  Then"
  echo
  echo "\`\`\`text"
  echo "combined_asym(x,y) = |A(x,y) symmetric_difference M(x,y)|."
  echo "\`\`\`"
  echo
  echo "Proof.  By definition, \`combined_scar = scar(x,y) = A(x,y)\`.  Since \`tau\` is a bijection on \`R_n\` and distributes over unions, \`tau(combined_scar)=M(x,y)\`.  The square-level asymmetry is \`combined_scar symmetric_difference tau(combined_scar)\`, which is the displayed expression."
  echo
  echo "Status: PROVEN by arithmetic."
  echo
  echo "### Lemma O4: incidence hypergraph determines asymmetry exactly"
  echo
  echo "Statement.  For each square \`s in R_n\`, record two incidence bitmasks:"
  echo
  echo "\`\`\`text"
  echo "active_mask(s) = active line-orbits whose active line contains s"
  echo "mate_mask(s)   = active line-orbits whose tau-mate line contains s"
  echo "\`\`\`"
  echo
  echo "Then \`combined_asym(x,y)\` is determined by the multiset of pairs \`(active_mask(s), mate_mask(s))\` over \`s in R_n\`; explicitly,"
  echo
  echo "\`\`\`text"
  echo "|combined_asym| = sum_{s in R_n} 1[(active_mask(s) != 0) xor (mate_mask(s) != 0)]."
  echo "\`\`\`"
  echo
  echo "Proof.  A square lies in \`A(x,y)\` iff its active mask is nonzero, and lies in \`M(x,y)\` iff its mate mask is nonzero.  Membership in the symmetric difference is exactly exclusive-or of these two nonzero tests.  Summing over \`R_n\` gives the formula."
  echo
  echo "Status: PROVEN by arithmetic."
  echo
  echo "Note.  The exact incidence-hypergraph script checked this representation for \`n<=40\`; the lemma itself is a definition-level proof and does not depend on the finite check."
  echo
  echo "### Lemma O5: board automorphisms commuting with tau preserve asymmetry"
  echo
  echo "Statement.  Let \`pi\` be a bijection of \`R_n\` such that \`pi tau = tau pi\`.  Then for every scar set \`A subseteq R_n\`,"
  echo
  echo "\`\`\`text"
  echo "|A symmetric_difference tau(A)| = |pi(A) symmetric_difference tau(pi(A))|."
  echo "\`\`\`"
  echo
  echo "In particular, the transpose map \`sigma(r,c)=(c,r)\` preserves the asymmetry size, because it preserves \`R_n\` and commutes with \`tau\`."
  echo
  echo "Proof.  Since \`pi\` is a bijection, it preserves cardinality.  Since it commutes with \`tau\`, \`pi(tau(A))=tau(pi(A))\`.  Therefore \`pi(A symmetric_difference tau(A))=pi(A) symmetric_difference tau(pi(A))\`, and the two sets have the same size.  The transpose preserves \`R_n\` because it swaps the center row/column exclusions, fixes the anti-diagonal exclusion \`r+c=q-1\`, and maps the main diagonal exclusion \`r-c=0\` to itself."
  echo
  echo "Status: PROVEN by arithmetic."
  echo
  echo "### Lemma O6: row/col quotient is score-exact in finite data"
  echo
  echo "Statement.  For all legal row-to-column border pairs with even \`n=8,10,...,100\`, the full-kind edge-overlap signature modulo row/column kind swap determines \`|combined_asym|\`.  The finite table was:"
  echo
  echo "\`\`\`text"
  echo "full-kind exact, no symmetry quotient:         159156 groups, 0 ambiguous score groups"
  echo "full-kind exact + row/col kind quotient:        79618 groups, 0 ambiguous score groups"
  echo "full-kind exact + row/col + sum/diff quotient:  79618 groups, 0 ambiguous score groups"
  echo "\`\`\`"
  echo
  echo "Proof sketch / why plausible.  Lemma O5 proves that actual transposition preserves asymmetry.  The finite row/col quotient appears to identify only transpose-dual local overlap fingerprints as far as the score is concerned; all tested identifications preserve the active-vs-mate xor size.  A theorem proof should show that the quotient does not merge two non-transpose incidence patterns with different counts."
  echo
  echo "Status: verified for finite n<=100; proof gap remains."
  echo
  echo "Proof obligation.  Derive the row/col quotient directly from the six line labels in Lemma O2 and the tau-action in Lemma O1, or exhibit the finite set of possible non-transpose collisions and show their xor-counts agree."
  echo
  echo "### Lemma O7: full-kind pairwise edge signature is empirically score-exact"
  echo
  echo "Statement.  For all legal row-to-column border pairs with even \`n=8,10,...,100\`, the full-kind pairwise edge-overlap signature determines \`|combined_asym|\` in the generated data."
  echo
  echo "Status: verified for finite n<=100; not yet PROVEN."
  echo
  echo "Reason for caution.  In a general set system, vertex sizes plus pairwise intersections do not determine union sizes or symmetric-difference sizes; triple and higher intersections can matter.  The finite data says the constrained queen-line geometry may make pairwise data sufficient here, but a theorem must prove that higher intersections are forced by the pairwise full-kind signature for this six-line family.  Lemma O4 gives the stronger incidence representation that is exact by definition."
  echo
  echo "### Lemma O8: family-collapsed edge buckets are good generators but not exact invariants"
  echo
  echo "Statement.  Collapsing line colors from \`row/col/sum/diff\` to broad families \`orth/diag\` is not an exact minimizer invariant.  In the finite data through \`n<=100\`, exact-family bucket-best admitted \`78\` extra non-minimizer replies across \`78\` inflated \`(n,x)\` rows.  Every extra had score delta \`4\`, and every mixed selected family bucket had size \`2\` with \`2\` distinct full-kind buckets."
  echo
  echo "Proof.  This is a finite counterexample family recorded by the exact-family collision continuation.  Any single extra non-minimizer in a selected family bucket refutes exactness of the family-collapsed bucket as a minimizer classifier."
  echo
  echo "Status: verified for finite n<=100; negative finding / refuted as exact minimizer invariant."
  echo
  echo "### Lemma O9: local score-exact signatures do not decide minimizer status"
  echo
  echo "Statement.  A local overlap signature, even one that determines \`|combined_asym|\`, does not by itself decide whether a reply is an asymmetry minimizer for the fixed opponent coordinate.  In the row/col quotient data through \`n<=100\`, there were \`3444\` mixed minimizer/non-minimizer groups, containing \`3444\` minimizer records and \`3444\` non-minimizer records."
  echo
  echo "Proof.  Minimizer status is row-relative: a reply \`y\` is a minimizer iff"
  echo
  echo "\`\`\`text"
  echo "score(n,x,y) = min_{legal z} score(n,x,z)."
  echo "\`\`\`"
  echo
  echo "The left side is a local score, but the right side depends on the full competitor set for the row context \`(n,x)\`.  The mixed groups give explicit finite examples where the same quotient-local score is a row minimum in one context and above the row minimum in another.  The non-minimizer deltas in mixed groups were mostly \`4\` records (\`3413\`), with \`27\` delta-\`2\` and \`4\` delta-\`6\` records."
  echo
  echo "Status: verified for finite n<=100; conceptual reason PROVEN by definition of row-relative minimization."
  echo
  echo "### Corollary O10: repair-oracle state needs row context"
  echo
  echo "Statement.  Any B6-style repair oracle based on overlap/asymmetry data should include row context.  A minimal candidate state is"
  echo
  echo "\`\`\`text"
  echo "(n, x, local_overlap_signature, asymmetry_score, asymmetry_rank)"
  echo "\`\`\`"
  echo
  echo "with solver-side extensions for \`ply/pc\`, parent/root move, line-load deltas, and child value when known."
  echo
  echo "Proof.  Lemma O9 refutes local signature alone as a minimizer classifier.  Adding \`(n,x)\` supplies the row-relative competitor set needed to define rank.  The older solver handoffs show that runtime usefulness is also band- and parent-context-dependent, so the implementation state should not collapse those fields prematurely."
  echo
  echo "Status: heuristic engineering corollary, supported by finite data and older solver measurements."
  echo
  echo "### Recommended next proof task"
  echo
  echo "Try to close Lemma O6.  The target statement is:"
  echo
  echo "\`\`\`text"
  echo "For legal border pairs, the row/col-kind quotient of the full-kind edge-overlap"
  echo "signature preserves |combined_asym| for all even n."
  echo "\`\`\`"
  echo
  echo "Do not try to prove that it preserves minimizer status; Lemma O9 shows that is the wrong target."
  echo
} >> "$NOTES"
