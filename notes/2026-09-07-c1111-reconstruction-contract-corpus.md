# C1111 reconstruction contract corpus: worktree spike

User authorization: spike C1111–C1113 in a worktree, without using tmpfs for
bulk artifacts. Code is on private branch `spike/continuation-reconstruction`
at `/home/tavis/.cache/ergodis/worktrees/continuation/ergodis-private`, based
on `de4f4fd`; the sibling core is a detached worktree at `67d929b`.
The filesystem reports ZFS. Run/log/temp files live under
`/home/tavis/.cache/ergodis/continuation-spike`; Cargo uses the existing shared
`/home/tavis/.cache/ergodis/target/ergodis-private` directory.

The six fixtures are frames at q=5,13,17,19, a triangle at q=7, and the Clebsch
six-arc at q=11. Candidate adjacency is separate from oracle geometry. Exact
partition-word reconstruction succeeds for the three stable frames. A pair of
independent triples has opposite joint-legality answers in the triangle case.
Explicit graph automorphisms change the marking for frame5 and Clebsch11.

The existing observable-admission API rejects the triangle's finer readout and
accepts explicit refinement. It has static query states and no dynamic context
claim. Independent Python line-equation checks replay incidence and ambiguity;
coordinate-word/edge mutations are rejected. The handwritten paper recognizer
also returns verified finite-field coordinates on identical stable inputs.

Reproduction and complete boundaries: worktree
`experiments/continuation/README.md`; entry point `experiments/continuation/run.sh`.
Its checked-in bundle is about 2.4 MB of logical bytes; run data use about
668 KiB of allocated ZFS space on this host. This is a bounded pilot; C1111 stays
in progress pending broader integration. No core changes or public export.

## ej+tt closeout / Mystery ledger

Retaining adjacency does not imply retaining joint legality; the concrete
triangle witness settles that distinction for the declared coarse observation.
Marking ambiguity is likewise witnessed, not an oracle's unexplained verdict.
A stronger dynamic admission contract and extension-field coverage remain open.
No universal reconstruction or automorphism-classification theorem is inferred
from the finite corpus.

Private spike commits: `529e9f2`, `dff995d`. The end-to-end run command passes
workspace formatting, scoped Clippy, both integration tests, independent Python
replay and handwritten-control verification. Final run log directory:
`~/.cache/ergodis/continuation-spike/logs/20260907-164845-run.sh`.
All retained source and fixture bytes are bound by the committed SHA256SUMS.
