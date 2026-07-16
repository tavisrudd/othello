---
Report

(1) a9f5377 — per-item verdicts

┌─────────────────────────────┬────────────────┐
│            Item             │    Verdict     │
├─────────────────────────────┼────────────────┤
│ §7 secant→unisecant         │ FIXED          │
├─────────────────────────────┼────────────────┤
│ Class count                 │ FIXED          │
├─────────────────────────────┼────────────────┤
│ papers-index:191            │ FIXED          │
├─────────────────────────────┼────────────────┤
│ "incidence form" → polarity │ FIXED, one gap │
├─────────────────────────────┼────────────────┤
│ "precisely non-edges"       │ FIXED          │
├─────────────────────────────┼────────────────┤
│ §7 attribution              │ FIXED          │
├─────────────────────────────┼────────────────┤
│ "five (+1)"                 │ FIXED          │
└─────────────────────────────┴────────────────┘

§7 (tex:686-691) — FIXED. Your counts match mine exactly: 66 chords = 30 carrying one arc point + 36 carrying none, zero secants. The new text derives the impossibility from Prop 3.1 ("it could not be a secant, since… no point of 𝒞 lies on a secant of A at all") rather than asserting it — better than what I asked for, because it makes §3 and §7 visibly consistent instead of merely non-contradictory.

Class count (tex:372-373) — FIXED. \sum_{\text{reps}}|S|/360=15 is right.

papers-index:191 — FIXED. Now arcs (clebsch restates), novelty retired, proof location pointing at arcs' Prop 4.6(i) with clebsch's restatement noted. This was the one that mattered — the ruling is now implemented in the registry, not just the prose.

Polarity (tex:695-699) — FIXED, but the gloss explains 1/6 of the fact. "each arc point is the pole of an antipodal chord, and a pole lies on its own polar only when it lies on 𝒞, which no arc point does" — correct (P ∈ P^⊥ ⟺ B(P,P)=0 ⟺ P ∈ 𝒞), and I verified all six arc points have B(a,a) ≠ 0. But this explains only why arc point a is off its own chord c_a. The claim is that c_a carries no arc point at all — the other five need B(a,b) ≠ 0, i.e. no two arc points are conjugate under the polarity. I checked: conjugate arc pairs B(a,b)==0: [] — true, and a nicer statement than the pole triviality. LOW; the hard fact is Lean-certified (antipodal_chord_nonedge), this is a gloss in Further Remarks. One clause fixes it: "…and no two arc points areconjugate under that polarity."

No NEWLY BROKEN. I re-read §§3–8 for collateral damage and found none.

(2) Tasks 2–3 — what I changed

Files touched: papers/papers-index.md, papers/papers-planning.md only. Uncommitted, as instructed.

Task 2 — the six re-pegs. Content-driven, not blanket, because the rows do not all say the same kind of thing:

┌───────────────────────────────────┬──────────────────────┬───────────────────────────────────────────────────────────┐
│                Row                │        Owner         │                            Why                            │
├───────────────────────────────────┼──────────────────────┼───────────────────────────────────────────────────────────┤
│ thm-relative-game-localization    │ nofil (arcs glosses) │ normal-play value, cap-game localization                  │
├───────────────────────────────────┼──────────────────────┼───────────────────────────────────────────────────────────┤
│ comp-q9-terminal                  │ nofil                │ P-position is the claim; arc completeness is the input    │
├───────────────────────────────────┼──────────────────────┼───────────────────────────────────────────────────────────┤
│ comp-q11-icosahedral              │ nofil                │ titled "seeded P-position"; identification noted as arcs' │
├───────────────────────────────────┼──────────────────────┼───────────────────────────────────────────────────────────┤
│ thm-extension-conflict-hypergraph │ arcs (nofil cites)   │ titled "arc/MDS extension semantics" — zero game content  │
├───────────────────────────────────┼──────────────────────┼───────────────────────────────────────────────────────────┤
│ comp-q11-extension-complex        │ arcs                 │ independence polynomial, complete 8-/9-arcs               │
├───────────────────────────────────┼──────────────────────┼───────────────────────────────────────────────────────────┤
│ comp-q11-chord-decomposition      │ arcs (clebsch cites) │ matchings/one-factorization                               │
└───────────────────────────────────┴──────────────────────┴───────────────────────────────────────────────────────────┘

A blanket re-peg to nofil would have been wrong — three of the six are pure arc content.

On the sequence inversion — my call: do not change the order. It was an artifact of the mis-peg, not a real dependency. Reasoning, now recorded in the planning doc:

1. A Lean directory name is not paper ownership. isP/seed_isP/win_parametrizedHoles_iff sit under RelativeConicArcs/ because that is where the witness got formalized. That is a file-location fact; the arcs paper never claimed them.
2. Neither nofil result needs an arcs novelty. comp-q9-terminal's input — the q=9 witness is a complete arc — is classical (SVM 1995 Prop. 13), so nofil cites SVM. comp-q11-icosahedral's input, adj_iff_icosahedron, is a decide-grade finite check nofil cites from the public Lean artifact, which ships before every paper.
3. So dependencies point backwards in ship order in both directions: nofil (1) cites SVM + the artifact; arcs (3) cites nofil (1), by then published. No paper cites an unpublished companion — the exact fragility that forced move 3 in Clebsch after Arcs.

Residual I did not fix: the game theorems are now misfiled — nofil owns results living in a directory named for arcs. That wants a Lean rename/move. I left it alone: it is Lean, outside mynamed files, changes no proof, and gates nothing.

Task 3 — one numbering scheme. Killed the two clashing schemes at the root by merging the decomposition list and the submission table into a single ordered list, since they were two views of one thing and that is what let them drift. Papers are now 1–7 in ship order — 1 Games, 2 Dihedral, 3 Arcs, 4 Clebsch, 5 Coding, 6 Baer⊕completion, 7 Continuation — ascending in bothdocs.

- Non-paper deliverables are named, not numbered (public mirror, the two OEIS entries). Reason, stated in the doc: they are a different deliverable kind with no venue, no formalization gate, no novelty seam — and numbering them alongside papers is precisely what made a bare "#4" mean Arcs in one doc and Equivariant/Baer in another. The mirror keeps its "do this first"prominence, which it now earns twice: the Arcs vs Nofil ruling depends on it.
- Division of labour kept: planning owns the authoritative list with gate distances and dependencies; the index carries the same numbers on directory rows and points there. No secondordered copy — the drift you have spent this session deleting.
- Fixed every stale cross-reference (D6 count, "Arcs (#4)", "see Submission sequence", "merged paper (7)", the index's "five (+1)").

Tables — reformatted for <100 columns. Note awk counts bytes; these docs are full of multibyte symbols, so real display width needed measuring properly. Result: papers-planning.md now has 0 table rows over 100 columns (was 15, worst 254). Converted the ship-order table, the "leads" table, and the "gates" table to definition-style lists. In the leads table I added a Clebsch entry that points at its ruling rather than inventing a lead — that table predates the paper and I would not fabricate its content. papers-index.md's directory tables are likewise converted (worst was ~500 cols).

I stopped at the results table, per your call to keep it. Straight assessment, since you raised org-mode: it will not get that table under 100 columns. Its worst row is 1033 columns; the issue is cell length, not table syntax. What a src-block org table does buy is real: no markdown-renderer mangling, monospace, and long rows scroll instead of wrapping into mush — which isa genuine readability win, and org's C-c C-c gives you true column alignment (CLAUDE.md asks for width-aligned columns; that table cannot currently satisfy it). So it is a reasonable move for the wrong stated reason. The only thing that achieves "<100 columns" is shortening cells — e.g. ID | Result | Paper in the table with Description/Proof as a detail line beneath. I didnot do either — you were still deciding, it is 100 rows of registry data, and churning it through three formats mid-decision is how content gets lost. Say which and I will do it scripted with a content round-trip check.

Concurrent session: codex has uncommitted work in four files I never touched (paper-baer-equivariant-robust-completion.md, the baer handoff, and the baer-equivariant-extension /equivariant-robust-completion READMEs). I checked for collision rather than fighting it: codex's README rewrite preserves the "canonical paper directory… remain source/staging views" language, so my paper-6 statements stay accurate. No conflict.

(3) Task 4 — q=9 uniqueness: settled, uniqueness HOLDS

I did not relay the sub-agent. I re-derived it from scratch with an independently written script sharing no code:

PGL2(9) element-order profile: {1:1, 2:81, 3:80, 4:90, 5:144, 8:180, 10:144}
distinct order-60 subgroups found: 12
all have A5 element-order profile {1:1,2:15,3:20,5:24}: True
conjugacy class of one A5 has size 12; covers all 12 found: True
Sym^2 rep of A5 is faithful on PG(2,9) (60 distinct actions): True
A5 orbit sizes on the 91 points of PG(2,9): [6, 10, 15, 30, 30]  sum = 91
orbits of size 1 or 5 (would permit a 5+1 or 1+..+1 arc): NONE
orbit-unions of total size 6: [[6]]
  candidate sizes [6]: is a six-arc = True
    |U| (deep-hole locus) = 0

Every number matches the sub-agent's. The crux is orbits of size 1 or 5: NONE — that is what kills the 5+1 and 1+…+1 cases my round-3 argument had to reason about, and it makes the branch universal rather than witness-specific. My reasoning was right, and it is now computed.

§6's q=9 clause can and should be made universal. Suggested reading:

▎ At q=9 the rationality filter passes, so q=9 must be excluded on its own terms. An icosahedral A₅ ⊂ PGL₂(9) is unique up to conjugacy, and its orbits on the 91 points of PG(2,9) havesizes 6, 10, 15, 30, 30 — none of size 1 or 5. An A₅-invariant point set is a union of orbits, so the only A₅-invariant six-set is the six-orbit itself: every A₅-invariant six-arc of PG(2,9) is projectively the same one. It is a genuine six-arc and it is complete (|𝒰(A)|=0), so the phenomenon is vacuous at q=9.

That matches q=4 and q=5 in form — universally quantified, no "the".

Evidence grade: script (uncommitted). My referee assessment of the sub-agent:

- Sound, and honest about its limits. Its key lemma — every (order-5, order-3) pair inside an A₅ generates it, since subgroup orders divisible by 15 force 60 — is correct, and it makes the11,520-pair sweep genuinely exhaustive. It flagged, unprompted, that it never byte-matched its arc against q9Witness. That caveat is immaterial and it correctly said so: uniqueness rests on orbit combinatorics, so any A₅-invariant six-arc is complete regardless of which representative the Lean file holds.
- I made it redo nothing — it had finished before I could referee. Had it still been running I would have pushed on the Lean rejection.
- Its Lean rejection is under-argued, and I disagree with the reasoning. It justified rejection partly by "PGL(3,9)… on the order of 5×10⁸". That is wrong twice: the true order is|GL(3,9)|/8 ≈ 4.2×10⁷, ~10× smaller — and, more to the point, neither its method nor mine ever enumerates PGL(3,9). The search space is PGL₂(9): 720 elements. So it rejected Lean on a cost its own approach does not pay.
- Lean is more reachable than it claimed. The uniqueness splits cleanly: (a) all A₅ ⊂ PGL₂(9) are conjugate — the only expensive part (the 11,520-pair closure sweep), and it is classical, straight out of Dickson's subgroup classification of PSL₂(q), so it can be cited rather than computed; (b) this one A₅ has orbits [6,10,15,30,30], its six-orbit is an arc, and |U|=0 — 60 ×91 = 5,460 point-applications, comfortably decide-grade and the same shape as the existing Q11Residual/Q11Coding proofs. Route (b)-with-(a)-cited is a real option and closes the paper's one non-universal branch at the gate's own standard.

I did not build either. Lean is outside my named files, the box has OOM constraints I was told to respect, and a concurrent session is live — building a new Lean module unasked is exactlythe scope creep I have been flagging in others. Recommendation, for your call: do route (b) with (a) cited to Dickson. Fallback is check_q9_uniqueness.py in the paper directory, which would also retire one of the three checker-coverage gaps.

Flagging: the referee script is uncommitted in the scratchpad. Nothing else was left undone.

---
Aside — novelty/strength grades

Caveat first, since it determines how much these are worth: I have read the Clebsch paper closely and re-derived most of its results; I have read the arcs prop:q11-code and the registry rows for everything else. Grades for papers 1, 2, 5, 6, 7 are inferred from index/planning/audit notes, not from reading the manuscripts. Weight them accordingly.

┌─────┬───────────────────┬─────────┬──────────┬───────────────────────────────────────┐
│  #  │       Paper       │ Novelty │ Strength │                 Note                  │
├─────┼───────────────────┼─────────┼──────────┼───────────────────────────────────────┤
│ 3   │ Arcs              │ B+      │ A−       │ The portfolio's anchor                │
├─────┼───────────────────┼─────────┼──────────┼───────────────────────────────────────┤
│ 4   │ Clebsch           │ A−      │ B+       │ Best idea; thinnest certification     │
├─────┼───────────────────┼─────────┼──────────┼───────────────────────────────────────┤
│ 2   │ Dihedral          │ B−      │ B+       │ Honest, bounded, finishable           │
├─────┼───────────────────┼─────────┼──────────┼───────────────────────────────────────┤
│ 1   │ Games flagship    │ B       │ B        │ Value is the boundary, not the method │
├─────┼───────────────────┼─────────┼──────────┼───────────────────────────────────────┤
│ 5   │ Coding / LRC      │ C+      │ B        │ Gated on a review that may not clear  │
├─────┼───────────────────┼─────────┼──────────┼───────────────────────────────────────┤
│ 6   │ Baer ⊕ completion │ C+      │ C+       │ Merged because each half was weak     │
├─────┼───────────────────┼─────────┼──────────┼───────────────────────────────────────┤
│ 7   │ Continuation N1   │ B       │ C−       │ Grade is nearly all promise           │
└─────┴───────────────────┴─────────┴──────────┴───────────────────────────────────────┘

Clebsch — novelty A−, strength B+. The rigidity TFAE is the best single idea here: recovering A₅ from a purely coding-theoretic hypothesis is a genuinely surprising statement, the kind areferee remembers. It is also, by construction, a q=11 fact about 15 arcs — an extremal curiosity, not a theory. That ceiling is real and no amount of writing lifts it. Strength is held back by what is certified: the headline TFAE and the gap theorem are Python-only, the gap theorem and chirality had no checker at all until this session, and the Lean gallery covers thesetup rather than the results. The priority discipline is the best I have seen in the portfolio — it concedes the census outright, publishes its own foil (the ten-arc), and now cedes the identification to arcs. That discipline is why it is B+ and not lower. Close the TFAE/gap Lean and it is A−/A−.

Arcs — novelty B+, strength A−. Less exciting, considerably more solid: an exact defect identity, a real classification, strict-trust Lean, independent checkers, near submission-ready. This is the one I would send first regardless of the seam ruling — and the ruling made it stronger by giving it back the identification. The strength grade is what the whole gate policy is for.

Games flagship — B/B. The classification is worth something; the mirror trick is elementary and the planning doc says so. Its real asset is the method boundary — where mirror⇒P dies (parabolic/Hermitian, capacity ≥ 3). Negative results are what make it a paper rather than a sequence of exercises, and the doc already knows to lead with that.

Dihedral — B−/B+. Exact nimbers for an explicit infinite family: modest, correct, finishable. Its own note concedes it is "elementary without D₂ₘ." Refreshingly unpretentious.

Coding / LRC — C+/B. Complete and audited, but its own audit already narrowed the novelty to "exact all-symbol (ν,τ) separation and complete-hypergraph transfer," and it is gated on anexternal specialist review that could narrow it further. Conditional for good reason.

Baer ⊕ completion — C+/C+. The tell is in the ruling: "each half is weak alone by its own audit." Merging two thin papers yields one paper, not a strong one. The √2·s bound turned out to be the classical Lunelli–Sce constant. Every order-five consequence is still unproved. Ranked 6th, correctly.

Continuation N1 — B/C−. Aut(frame graph) = ambient semilinear group is a nice rigidity statement — but there is no manuscript, it is the hardest formalization, and N2 is blocked onpaywalled reads. Novelty B on the idea; strength C− because almost none of it exists yet.

On the portfolio. The honest summary is that this is one A−, one B+ anchor, and a tail — and the tail is where the risk lives. Two of my three seam findings across these rounds were the same failure mode: one computation, two readings, two papers, novelty claimed twice. That pattern is what turns a B+ portfolio into a reviewer's salami complaint, and it recurs because theunderlying Lean library is shared while the papers are split. You have now ruled both instances. I would watch for a third rather than assume there isn't one — the lem-twisted-cubic row is benign today, but ProjectiveTwistedCubicTransversalSpectrum.lean living in the coding library while the twisted-cubic spectrum is completion's stated headline candidate is the same shape,one step earlier.

The strongest single move remains the one the planning doc already names: ship the public mirror. It unblocks four deliverables, starts the priority clock on the A344227 refutation — which is, unglamorously, the highest-novelty item in the whole repo, since it refutes a published conjecture — and it is the thing that makes the arcs/nofil citation story work at all.
