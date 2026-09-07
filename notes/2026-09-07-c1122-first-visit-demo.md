# C1122 — First-visit Ergodis demo

Date: 2026-09-07. Lane: `ergodis`. Status: in progress.

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
