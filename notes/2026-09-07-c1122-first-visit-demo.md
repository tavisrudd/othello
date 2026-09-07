# C1122 — First-visit Ergodis demo

Date: 2026-09-07. Lane: `ergodis`. Status: complete. Core `67d929b`.

User says the demos still leave a potential new user lost, and campaign.html is worse.
Scope: a concrete guided product introduction and campaign story, with advanced inspectors
retained. Allowed core paths: `wasm/www/index.html`, `main.js`, `learning-example.js`,
`introduction.js`, `introduction.css`, `campaign.html`, `campaign.js`, `campaign.css`,
`bundle.html`, related `wasm/scripts/` browser tests, `wasm/README.md`,
`docs/browser-control.md`. No Rust, solver, storage architecture or gate changes.

Assumption pending optional audience clarification: a potential user evaluating the optimizer.
Use a visible small switch/lamp problem for which real WASM returns a minimum and specific
choices. Continue with a safe versus unsafe search restriction. Explain the problem, action,
result and product relevance before introducing campaign/provenance/checkpoint vocabulary.
Do not imply session checkpoint files and immutable run bundles are interchangeable.

## Result

The new index explains what Ergodis takes as input, returns as an answer, and which
problems suit it. Its interactive example has four switches: two share a main lamp,
two control separate test lamps. The goal is main ON/tests OFF at minimum switch count.
Visitors can try the switches and then run the real CampaignSession/WASM engine.
The UI renders returned local labels and the exact minimum, rather than a canned answer.
An edited setting clears the displayed solution. Each introductory solve owns and closes
its own bounded Worker session.

The campaign page continues with the same model. Keep-test-switches-off preserves the
valid settings; keep-main-switches-off loses them. The checker actually admits/refutes
these proposals. The admitted solve returns complete-problem coverage and a cost-one
witness. A refutation renders the actual lost setting, and solving remains unavailable
for a changed/refuted proposal. Campaign terminology is introduced after the workflow.
The old form remains under an advanced inspector, preserving explicit heuristic mode,
provenance, cancel/resume and opaque checkpoint exchange. Advanced actions invalidate
the guided result. The fixed guided example resets its draft provenance/model on entry.

The bundle page is now explicitly a developer artifact tool, with a prominent route to
the introduction. Campaign checkpoints and immutable run bundles are not presented as
interchangeable files. Existing saved-run functionality remains intact.

## Validation

Actual Chromium tests cover manual switch toggles/cancellation, real WASM solving,
independent enumeration of all 16 settings, returned witness/goal/cost agreement,
editing invalidation and repeated solving. Guided admission, refutation, the displayed
counterexample and refusal to solve after changing/refuting a shortcut all pass.
The existing advanced campaign, composition/reduction corpus, bundle inspection,
verification/fork and repository process-crash/restart gates also pass. The advanced
sample's expected optimum is now one, reflecting the changed demo input; checker budget
is 16 assignments/1024 cell updates. Runtime validation policy is unchanged.

During development, a counterexample rendering test caught use of input label order
instead of canonical checker order. The shared fixed example now declares its labels
in canonical lexicographic order; the browser test independently checks the rendered
counterexample against the actual lamp goal. A screenshot helper name collision was
renamed. An offline action wait timed out on one run; diagnostics now include offline
status text, and the final complete suite passed. No production failure was suppressed.

Final browser capture: `20260907-152427-nix-shell-nixpkgsnodejs-nixpkgschromium-command-node-browser-smoke.mjs`.
Full native fmt/clippy/all-feature tests and eight-case Python parity pass:
`20260907-152232-nix-shell-nixpkgscargo-nixpkgsrustc-nixpkgsclippy-nixpkgsrustfmt-nixpkgspython3-c`.
No Rust source or WASM binary change. Browser replay is the existing README command:
`nix shell nixpkgs#nodejs nixpkgs#chromium --command node wasm/scripts/browser-smoke.mjs`.

Desktop introduction, rejected-shortcut and mobile-shortcut screenshots were generated
under `~/.cache/ergodis/browser-control-review/first-visit-*.png`; desktop introduction
and shortcut renders were visually inspected, and the mobile width assertion passes.
The real-browser counterexample assertion, not a screenshot, checks semantic rendering.

## Limits and closeout

The lamps are a small synthetic teaching example, not a performance comparison or an
application-specific value claim. The UI names intended algebraic/finite scope and the
need for a model/adapter. Proposed reductions are supplied by the demo, not discovered
autonomously. The campaign retains its existing bounded session/event limits. No storage
architecture, kernel, validation policy or recovery claim changed. No incidental research
discovery or mathematical mystery. The architecture frontier remains in the handoff.

The new introduction was opened in the user's local Chromium at
`http://127.0.0.1:8765/index.html`. No export or push.
