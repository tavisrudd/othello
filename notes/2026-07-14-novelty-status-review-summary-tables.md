# Novelty status review — summary tables (2026-07-14)

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing. (Cross-lane review; rows are pegged
individually. Findings that land in a manuscript belong to that manuscript's lane.)

Status of every claim in the gem/Clebsch program after the 2026-07-14 literature sweeps
(`2026-07-14-gem-lit-{hexad,exterior-sets,omega-arc,deep-holes,orbit-classification}.md`), the
adversarial vet (`2026-07-14-gem-program-vet.md`), and the C147 work
(`2026-07-14-c147-hexad-polarity-characterization.md`).

---

## 1. What may still be novel

| # | Item | Lane | Status after the sweeps | What it still needs |
|---|------|------|------------------------|---------------------|
| 1 | **Hexad ⟺ no accidental chord concurrency** | `gem-mining` | Verified; absent from the literature at full text; proof needs no enumeration | Write-up. Novelty is narrower than it looked — see note |
| 2 | **The identity `t(H) = 60 + #fpf involutions in Stab(H)`** | `gem-mining` | Ours. Synthetic, computer-free, verified for all 924 | Nothing — this is the actual new mathematics in (1) |
| 3 | **Why q=23 cannot work** (needs \|H\| = 2×3, so a concurrent *triple* is a *perfect* matching) | `gem-mining` | Ours. Explains the octad negative structurally | Nothing — a paragraph, and it closes the family question |
| 4 | **Deep holes = the conic** (the covering fact) | `relconic` owns; also `clebsch` | Ours. Absent from Edge and Van de Voorde, both read in full | The two BSW originals (ILL) — the negative is conditioned on them |
| 5 | **"First deep-hole set = F_q-points of a named variety"** | `relconic` owns; `clebsch` demoted it to setup | Audited, survives; Reed--Muller residual closed by [C154](2026-07-16-c154-reed-muller-deep-holes.md) | Keep the precise bounded-audit wording; no exhaustive priority claim |
| 6 | **Rigidity theorem + gap theorem** | `clebsch` | **Audited 2026-07-14 — no collision found** ([sweep](2026-07-14-gem-lit-rigidity-gap.md)). Nobody characterises the hexagon by its extension points; nobody observes `U(A)` is a conic. **But the two most dangerous sources were unread**: Sadeh's thesis (not online) and Hirschfeld PGOFF Ch. 14 (403, in-copyright). So: "no collision in anything openable", not "verified novel" | The Sadeh/Hirschfeld ILL. Narrow the claim to the deep-hole side — **(iv)⟺(v) is likely classical** |
| 7 | **Mixed-type ω_arc** (internal/external arc-cliques) | `gem-mining` | New territory — the literature is external-only and structurally cannot see it | Someone to care. Downgraded; lowest in lane |
| 8 | **k=4 / twisted cubic healthy search** | `cubic` (when opened) | Open. No prior statement of the question found (light search) | Re-derive DMP's R=4 dictionary, then a Rust DFS at q=11, 13 |
| 9 | **U-atlas with elliptic targets** | `gem-mining` | Open, untried. C132's genus-0 restriction was a fiat | One cell (q ≤ 11, all n) |
| 10 | **q=5 frame sibling** | `gem-mining` | Unaudited | Cheap check: structure or degeneracy? |

**The note on (1).** With CO-TR supplying the orbit table, the stabilizer-parity form ("hexad ⟺
Stab has odd order") is a repackaging of *their* result, not a new phenomenon. What is ours is the
**bridge**: the identity in (2), connecting a geometric invariant (chord concurrency) to the orbit
table. The pieces all existed; nobody wrote the sentence. A legitimate note, thinner than
"we characterized S(5,6,12)".

---

## 2. Infrastructure the literature gives us

| Source | What it gives | Which claim it serves |
|--------|---------------|----------------------|
| **Cameron–Omidi–Tayfeh-Rezaie**, EJC 13 (2006) #R50, **Thm 4** | PGL(2,q)-orbits on k-subsets indexed by stabilizer type (`g_k(H)`); q=11, k=6 is inside the hypothesis | Closes the converse of (1). Removes the 924-case enumeration |
| — same, **Lemma 8** | Orbit profiles of dihedral subgroups on the projective line | The fixed-point-free refinement in (2) |
| — same, **Thm 1 + Thm 2(i)** | The 66 external / 55 internal counts | The point↔involution correspondence in (2) |
| **Nguyen**, arXiv:1912.12200 §3–4 | Pencil of binary quadratics ↔ involution, char ≠ 2 | The other half of (2)'s toolkit |
| **Edge 1956**, Canad. J. Math. 8, 362–382, §§29–32 | The q=11 six-point configuration, the "Clebsch hexagon" name, 22 hexagons in two systems of 11, order-60 stabilizer | Prior art for the *arc* in (4). C146 |
| **Blokhuis–Seress–Wilbrink**, Combinatorica 12 (1992) 143–147 | Complete exterior sets; the conjecture | Prior art for the exterior-set *condition*. C146 |
| **Van de Voorde**, Discrete Math. 311(20) (2011) 2253–2258 | Sets without tangents; BSW checked to q < 131; LDPC stopping-set link | Bounds what (7) can claim; the one existing coding link |
| **DMP**, arXiv:2101.12722, **Thm 6.3(iii)** / **Thm 7.7** | The arc↔deep-hole dictionary / the leader formula | (4) and (5); cited, now correctly numbered |
| **ZWK**, arXiv:1901.05445, **Thm I.7** | PRS deep holes = three combinatorial families, *not* a variety-equality | The precursor that makes (5)'s "first" safe |
| **Halbeisen–Hungerbühler**, J. Geometry (2024) | The same 15-chord construction over ℝ, where no-accidental-concurrency is *generic* | Why (1) is a finite-field phenomenon, not a char-0 specialization |
| **Havlicek/Coxeter/Pellegrino**, arXiv:1210.2055 | The only rival geometric hexad characterization (12-cap in PG(5,3), by incidence) | Positions (1) against its nearest neighbour |
| **Shaska** (genus-2 reduced-Aut list) | `y² = x⁶ − x` is the reduced-C₅ curve; `μ₅ = QR(11)` over F₁₁ | **Interpretation only** for (1) — see cautions |
| **Curtis / Conway–Sloane** | S(5,6,12) construction; PSL(2,11) hexad stabilizer C₅ | Standard setup for (1) |

### Do-not-cite list (each of these nearly bit us)

- **Genus-2 literature for the orbit table.** It classifies *geometric* automorphisms; ours are
  F₁₁-rational. They agree here by luck — the 110-orbit is `μ₆` geometrically, and `μ₆ ⊄ F₁₁` since
  `6 ∤ 10`. Cite CO-TR.
- **CO-TR §8** for the 132+132 PSL/PGL split — it requires `p > 23`.
- **arXiv's journal-ref for 1201.0484** — wrong; it points at a different Van de Voorde paper.
- **Hirschfeld / Semple–Kneebone theorem numbers** — inferred, never verified; neither book was
  accessible.

---

## 3. Items we thought were novel that aren't

| # | Lane | What we thought | What it actually is | Killed by |
|---|------|-----------------|---------------------|-----------|
| 1 | `clebsch` | The Clebsch hexagon at q=11 is prior art only via **Dye 1991** | **Edge 1956** §§29–32 has it 35 years earlier — configuration, name, the 22 hexagons in two systems of 11, the order-60 stabilizer, crediting **Clebsch 1871**. The priority footnote argues against the wrong paper | Exterior-sets sweep (Edge read in full) |
| 2 | `clebsch` | "All 15 joins external to the conic" is our framing | **BSW's definition** of a complete exterior set of size (q+1)/2. BSW's object *is* Edge's hexagon renamed | Exterior-sets + ω_arc sweeps |
| 3 | `gem-mining` | Our census **extends** BSW's range (q=37 "one prime past 31") | Machine-checked to **q < 131**; our sweep recomputes inside it. The "q<131 vs 11<q≤31" discrepancy was two different claims, not a contradiction | Fable vet §1.4 |
| 4 | `gem-mining` | The **four-orbit classification** was ours to prove | Published: **CO-TR 2006** Thm 4, stabilizer-indexed, hypothesis covers q=11, k=6 | Opus orbit check |
| 5 | `gem-mining` | "Hexad ⟺ stabilizer has odd order" is a new phenomenon | A **repackaging of CO-TR's table**. Ours is the bridge to chord concurrency, not this restatement | Opus orbit check (Q3) |
| 6 | `clebsch` | The **two-systems-swapped-by-non-PSL** chirality motif is ours | Classical — **Edge §§29/32**. Prop 5.1's leader-orbit proposition survives but must cite the precedent | Fable vet |
| 7 | `gem-mining` | Point↔involution and pencil↔involution are our machinery | Both classical. CO-TR Thm 1 / Thm 2(i); Nguyen §3–4; Desargues involution theorem | Opus orbit check |
| 8 | `gem-mining` | ω_arc growth strengthens an open conjecture (ranked **#2** at the time) | Its all-external half **is** the BSW conjecture, inside the checked range. Only the mixed-type half survives. Now last in lane | Fable vet + ω_arc sweep |
| 9 | `gem-mining` | The **fill-signature detector** (`\|config\| = \|space\|`) finds gems | Wrong signature — selects rich-incidence configurations, the opposite of arcs. Retired, not re-keyed | C132 + Fable §9 |
| 10 | `clebsch` | 27 lines / Valentiner / 57-cell / Hesse are second instances | All four fail the arc/deep-hole template | C132 |
| 11 | `clebsch` | "Deep holes = the conic" is headline-grade | Corollary-grade via the DMP dictionary; the rigidity theorem became the headline | Earlier red team |
| 12 | `clebsch` | The **dual-variety conjecture** (C123) generalizes it | Dead five ways; ZWK subsumes and refutes it | Earlier red team |
| 13 | `clebsch` | Klein reduction **causes** deep-holes-=-conic | False by our own C126 data. "Because" struck; demoted to discussion | Earlier red team |
| 14 | `clebsch` | The 6-arc census and the \|U\| histogram are ours | Conceded outright to the arc-classification (Sadeh) school | Earlier audit |
| 16 | `clebsch` | `U(A)` is an object nobody had a reason to compute | **Half false.** `U(A)` is classical Segre tangent-envelope machinery (cite **Ball–Lavrauw arXiv:1908.10772 Thms 39–41**, not PGOFF). But machinery ≠ motive: the no-motive argument survives, and the hypothesis gate is a **non-collision** certificate, not a significance one. Odd-q gate is `\|A\| ≥ 2q/3+2 ≈ 9.34`, **not** `q/2+1 = 6.5` (that is q-even); we have `k=6`, excluded by four points | Gap sweep (G5), corrected by the [Fable vet](2026-07-14-gap-theorem-vet-fable.md) |
| 15 | `clebsch` | The whole rigidity TFAE is ours | **(iv)⟺(v)** — "PGL-equivalent to the Clebsch hexagon ⟺ stabilizer contains A₅" — is very likely classical: the q=11 "Diagonal" surface with \|G\|=120 is in Karaoglu's Table 5.1, credited to Sadeh. Claim priority on the **deep-hole side only**: (i)/(ii)/(iii) ⟺ (iv)/(v) | Rigidity/gap sweep |

**Rows that span lanes**, pegged to whoever owns the deliverable:

- **Rows 1–2** are `clebsch` because C146 is the deliverable and the `clebsch` manuscript cites
  neither Edge nor BSW. The Edge gap hit `arcs` too; that fix landed separately under `relconic`
  (commit `cfd8537`). `arcs` was never wrong about row 2 — it cited BSW and drew the exterior-set
  distinction correctly beforehand.
- **Row 9** was built under `clebsch` (C130/C132), but the retirement verdict and the replacement
  generator live in `gem-mining`, which owns the methodology. Recorded there; the old C items are
  not re-pegged.

---

## 4. Claims made in-session that were false

Recorded because the pattern matters more than the individual errors.

| What was claimed | What was true |
|------------------|---------------|
| ω_arc falls below n_min after q=11 — "why 11", provable by a spectral bound | **Refuted by computation.** ω_arc ≥ n_min at q = 13, 23, 29, 31, 37; the covering fails anyway. No mechanism |
| E_q is likely strongly regular → Hoffman/ratio bound gives O(√q) | **Dead a priori.** Every external line is a (q+1)-clique, so no spectral bound sees the arc condition. E_q is not SRG |
| Arc points are external points | **False.** The q=3, 5, 19 configurations are all-internal. An external-only search — what the literature does — misses them |
| The pencil ceiling is ~√q | **Linear**, ~q/2. That bound was the whole basis of the crossing story |
| Fable's Edge "2×11" reading was wrong | **Fable was right.** A paper was corrected that had not been read |
| The identity extends to q=23 as `t = 280 + #fpf involutions` | **False.** Needs \|H\| = 2×3. Caught before shipping — and the correction became the explanation of why octads fail |
| 759 subsets at max t looks like a second Steiner system | **Numerology.** `759 = \|PGL(2,23)\|/16`, an orbit size; not Steiner; disjoint from the Golay octads |

---

## 5. The pattern

Two distinct failure modes needing different defences.

**Table 3 rows 1, 2, 4, 6, 7 are one thing**: the objects and tools are classical and nobody had
searched. The fix is scholarship, and it is cheap — four sweeps in one session found seventy years
of prior art.

**Table 4 is a different thing**: every row is a confident claim about something not computed or not
read. The census, the pencil bound, the Edge passage, the q=23 identity — each took minutes to check
and each was wrong. That is precisely the failure the gem-mining method exists to prevent (declare
the null, then compute), skipped at the moment it was needed.

**The lane split looks like a signal and mostly is not one.** Nine of fourteen table-3 rows are
`clebsch` and five are `gem-mining`, which invites a story about a careless lane and a careful one.
Check the dates before telling it: **the `clebsch` manuscript's first commit and the `gem-mining`
lane's first commit are the same day as this review** (`4b6aa8e`, `5522332`). Nothing accumulated
over time; there was no time. The manuscript was drafted, red-teamed, and swept inside one day, and
the sweep was simply the last review in that chain rather than a belated discovery of old rot.

The real difference is sequence, and it is about tasking, not lanes: **the `clebsch` draft was
written before the literature sweeps existed and the hexad result after them.** A draft that has not
yet had its sweep is not a careless draft; it is a draft at the stage before scholarship. What the
table shows is the cost of writing before searching — which is a schedule choice, cheap to reverse,
and says nothing about the lane that made it. `relconic`'s zero rows are the one durable point:
`arcs` cited BSW and drew the exterior-set distinction before any of this, so the searching *can* be
done first.
