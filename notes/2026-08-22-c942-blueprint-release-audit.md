# C942 LeanBlueprint release audit

## Verdict

**Fail for release as currently described.**  The target is reproducible on the
review host, is idempotent, and does not disturb the manuscript build.  The
generated Lean links do not resolve in the generated site, however, so the
reviewer guide overstates what the web view currently provides.

## Checks

- I ran `nix run .#blueprint-web` twice from
  `papers/cubic-stabilization-m1/`.  Both runs exited zero.  Each produced 21
  files, and the sorted content-hash manifest was identical on the two runs:
  `42daa15f9eea974c53c6c2b748e98a0d27a29d5b8dcf02f2a8fa91f156909256`.
- The output contains the annotated manuscript, including the theorem headed
  “One-step irrationality,” and a nonempty `dep_graph_document.html`.  The
  second log has no error, undefined-citation, or unrecognized-annotation
  diagnostic.  plasTeX reports its ordinary `begingroup` renderer warning and
  falls back from absent `pdf2svg` to `dvisvgm`.
- The output tree, generated bibliography, and `.paux` file are ignored.  A
  second run adds no source path to `git status`.
- The original `nixpkgs` lock entry is byte-unchanged.  Blueprint uses a
  separate revision-pinned input; the existing `default` and `manuscript`
  shells and the Makefile are unchanged.
- `make check` exits zero after both web runs.  The manuscript PDF has no Git
  status entry, and its SHA-256 before and after the audit is
  `246d254f7275111ba33b5b73ad344d31a89b749b28e37d76b306b919349b708a`.
- The guide states the trust boundary correctly: the web command parses the
  existing annotations but neither builds nor checks Lean and does not replace
  the claim registry or axiom audit.

## Required finding

`blueprint/src/web.tex` sets `\dochome{}`.  All 33 rendered Lean anchors
therefore have targets of the form `/find/#doc/<declaration>`, while the
generated tree contains no `find` endpoint.  The links are dead when the site
is opened or served by itself.  Configure `\dochome` to a real API
documentation root, provide the corresponding documentation in the published
site, or change the view and guide so they do not promise Lean declaration
links.

## Minor wording finding

`split-level=0` produces one `index.html` containing the theorem blocks, not
separate theorem pages.  In the guide, “writes the theorem pages” should be
replaced by “writes an annotated web view of the manuscript” (or the split
configuration should be changed deliberately).

No other release or PDF-build defect was found in the C942 delta.
