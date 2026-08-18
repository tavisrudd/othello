# Cubic-threefolds discovery track

**Lane:** `cubic-threefolds`

Append-only catchment for incidental observations and musings noticed during
planned `cubic-threefolds` work — not a task queue, work list, or alternate
handoff. See `notes/discovery-track-conventions.md` for the boundary and
entry format.

Split off from `notes/2026-07-14-clebsch-discovery-track.md` on 2026-08-15
when the C907/C908/C909/C910/C911/C914 research program moved into its own
lane; that file's existing entries stay there as historical record and are
not copied here.

### 2026-08-18 — Guéré's heart invariant may give a second proof that no surface represents the cubic atom

**Provenance:** C917 source verification of Guéré, *On the irrationality of
cubic fourfolds*, arXiv:2603.04518v1, read while adding related-work prose.
**Was I looking for this?:** no — the task was to position the epilogue in
prose, with the proofs explicitly out of scope.
**Observed / musing:** Guéré's blowup-invariant property (his heart invariant,
the analogue of Katzarkov--Kontsevich--Pantev--Yu's club property) forces a
surface carrier to satisfy `c_1(K) = 0`, `h^{2,0} != 0`, and `h^1 = 0`, which
in his cubic-fourfold case pins the carrier to a K3 surface. The epilogue's
Proposition 4.17 excludes surface representatives of the cubic atom by a
different route: even parity rank at least three for nef-canonical minimal
models, plus the classification of minimal surfaces and the projective-bundle
formula for `P^2` and ruled surfaces. The two exclusions constrain the same
kind of object through unrelated numerics.
**Why it may matter / strongest question:** does Guéré's heart constraint,
applied to the rank-two even part of the cubic atom, give an independent
proof of Proposition 4.17 — and if it does, does it also survive to the
second stabilization, where the ordinary atom criterion fails because the
cubic atom already has a threefold representative? A surface-carrier
constraint that does not depend on the dimension bound in the ordinary
non-rationality criterion would be worth more than a second proof.
**Evidence:** OPEN — no attempt made; his evaluation maps are related to but
not identified with the atom construction, and the epilogue deliberately uses
only the ordinary, non-enhanced package.
**Status:** open lead

### 2026-08-18 — a forthcoming revision of Guéré's paper is announced inside the joint criterion note

**Provenance:** C917 source verification of
Benedetti--Fay--Guéré--Manivel--Perrin, arXiv:2607.26718v1, Remark 4.2.
**Was I looking for this?:** no — the remark was read only to confirm that
nothing in it needed importing into the epilogue.
**Observed / musing:** their Remark 4.2 records a subtlety about maximal
spectra for evaluation maps defined relative to a blowup-center embedding
versus the identity morphism, and points to a forthcoming revision of Guéré's
paper. The epilogue is unaffected, since Section 4 uses no evaluation
argument.
**Why it may matter / strongest question:** any future lane work that does use
evaluation maps — including the lead logged above — should wait for or check
that revision before relying on the v1 evaluation formalism.
**Evidence:** CHECKED — read in the cached full text of arXiv:2607.26718v1.
**Status:** open lead
