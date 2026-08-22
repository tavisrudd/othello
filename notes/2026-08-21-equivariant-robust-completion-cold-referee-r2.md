# Cold referee report: *Frobenius-equivariant pair extension and robust repair of eight-arcs*

Date: 2026-08-21

Frozen authority reviewed:

- manuscript commit `0a2924c560f556bc8d61bce9625ace08875d272e`;
- PDF SHA-256 `65e8ee558c95c2c8f3935c2dd5b93a26162dc80346df2b57408e4ff28cb97a66` (16 pages).

I cold-read the manuscript without consulting prior reports, dossiers, task notes, or handoffs. I inspected the pinned Q25 certificate source at commit `d4e910cf01819a8678fd84422bb18fe23f4d6695` read-only, but did not run Lean, Lake, Nix verification, certificate regeneration, or any build.

## Verdict: C — major revision / load-bearing gap

The mathematical spine is convincing. I found no counterexample or invalid inference in the mate-line reduction, the uniform obstruction count, the collision correction, the four structural Q25 profiles, the projective normalization of the exceptional profile, the general repair phase, or the coding-theory translation. The exceptional Q25 minimum and hence the order-five part of the main theorem are nevertheless load-bearing computer-assisted claims. At the review date their cited certificate repository is publicly empty and the cited structural-source commit is unavailable. In addition, the exact five-orbit equality classification is not a precise standalone mathematical statement because the manuscript never defines the residual group or its action. These must be repaired before acceptance.

## Mandatory findings

### 1. The load-bearing certificate and the cited structural source are not publicly retrievable

Section 7, “Artifact and reproduction,” says that the exceptional certificate is a content-addressed source tree and directs the reader to GitHub (PDF p. 14; `sections/07-formal-verification.tex`, lines 118–156). The pin file names certificate commit `d4e910cf01819a8678fd84422bb18fe23f4d6695`, manifest digest `4f3d252a453c7217a8a8aaf7b27374794396e2d0b4101c7c8b85683deaa52292`, and structural commit `9977af02cfed699c1c14802242a6f500896164bc` (`verification/q25-certificate-pin.json`, lines 3–16). But, on 2026-08-21:

- `https://github.com/tavisrudd/finitegeom-q25-certificates` reports “This repository is empty”; `git ls-remote` returns no refs, and the raw `MANIFEST.json` URL at the pinned commit returns 404;
- `https://github.com/tavisrudd/othello/commit/9977af02cfed699c1c14802242a6f500896164bc` returns 404, as does a raw structural source path at that commit.

The internal local certificate checkout does contain the pinned commit, and `git show <pin>:MANIFEST.json | sha256sum` matches the manuscript’s digest exactly. That establishes internal consistency of the pin but does not give a referee or reader access to the evidence. The paper’s own verification README also says that publishing the certificate is a separate release action not performed by the exporter (`verification/README.md`, lines 58–60).

This is load bearing: Proposition 5.3’s lower bound 32, attainment, strict bound 33 off the minimizers, and equality exhaustion depend on the certificate (PDF pp. 8–9; `sections/05-eight-arcs-q25.tex`, lines 128–139 and 216–232). Proposition 5.3 is then used for Theorem 5.4, Corollary 5.5, Corollary 6.5, and Theorem 1.1(i). Until the exact commits are durably released, a clean third party cannot check the central finite step.

Required remedy: publish both cited commits (or replace the links and hashes with durable archival deposits), verify that every URL and digest resolves from an unauthenticated clean environment, and record one successful clean replay of the stated aggregate command. The frozen paper archive should contain enough metadata to identify the same sources permanently.

### 2. Define the residual group, its action, and the precise equivalence relation in Proposition 5.3

Proposition 5.3 states that the equality configurations form five “residual-group orbits” of sizes 200, 400, 400, 200, and 400, with disjoint union of size 1600 (PDF p. 8; `sections/05-eight-arcs-q25.tex`, lines 128–138). The proof later says only that the residual group has order 400 and that orbit–stabilizer certificates give those sizes (PDF p. 9; lines 216–229). No manuscript definition tells the reader:

- what the 400 group elements are geometrically or in coordinates;
- which normalized objects they act on;
- whether the action incorporates swapping the two fixed points, changing the chosen normalized conjugate pair, or choosing the other point of that pair;
- exactly what “up to normalization” identifies.

Remark 5.6 narrows the claim but does not supply this missing definition (PDF p. 10; lines 267–272). The pinned source defines a 400-element product group of admissible-coordinate parameters acting on indexed projective points and hence on finite point sets (`ResidualGroup.lean`, especially lines 6–18 and 62–80), but a theorem in the paper cannot leave its acting group implicit in a generated certificate package.

Required remedy: add a compact coordinate definition of the residual group and its action immediately before Proposition 5.3 or inside its proof, then state the equality classification with an explicit domain and equivalence relation. Explain how arbitrary choices in the two manuscript normalizations map into this action, or weaken the paper-level classification to the exact semantic statement actually proved. The minimum-32 theorem itself does not appear endangered; the issue is precision and semantic transport of the advertised equality classification.

## Mathematical audit

### Carrier count and collision correction

The pair-extension test and empty-carrier count are correct (PDF pp. 2–3; `sections/02-quadratic-frobenius.tex`, lines 34–79). On an empty fixed line, a fixed old secant meets at a fixed point and a nonfixed secant orbit forbids at most one nonfixed pair, so Theorem 3.1’s lower bound follows without hidden overlap assumptions (PDF p. 4; `sections/03-pair-extension-criterion.tex`, lines 7–33). Proposition 4.1 and Corollary 4.2 correctly separate invisible centers from multiplicity redundancy and give the exact identity `L + EM = EN + B + R` (PDF p. 5–6; `sections/04-collision-correction.tex`, lines 7–75).

### Q25 structural profiles

The fixed-center estimate `s+3-f-e` is sound: a cross-pair secant center lies on neither participating mate line, and at most `f+(e-2)` occupied fixed lines pass through it (PDF p. 6; `sections/05-eight-arcs-q25.tex`, lines 35–44). The `(4,2)`, `(6,1)`, and `(8,0)` bounds then follow as stated.

For `(0,4)`, the second secant-index identity is correctly normalized. Pairs of disjoint secants contribute `3*binom(8,4)=210`; the fixed-external contribution is at most 72, the nonfixed contribution on the four occupied mate lines is at most 96, and conjugate endpoints halve the remaining moment to give `T >= 21`, hence `R >= 11` and `L >= 5` (PDF pp. 6–7; lines 65–104). I found no missing class of external points or double-counting error.

### Exceptional normalization and semantic transport

The two manuscript normalizations are valid (PDF p. 8; `sections/05-eight-arcs-q25.tex`, lines 141–175). Sending two ordered fixed points to `A=[0:0:1]`, `B=[0:1:0]` uses a base-field projectivity and commutes with Frobenius. Arc noncollinearity forces both imaginary coefficients `b,d` of a chosen nonfixed point to be nonzero, and the displayed diagonal-affine change sends its conjugate pair to `[1:±omega:±omega]` while fixing `A,B` projectively.

The row semantics are also correctly described (PDF pp. 8–9; lines 177–209). In the pinned source, projective points use the three canonical charts, nonfixed conjugate pairs have 310 bijective orbit codes, the standard orbit has code 5, and compatibility with `A,B` implies code at least 5 (`Coordinates.lean`, lines 118–155; `Normalization.lean`, lines 225–265). Thus the other two distinct selected pairs can indeed be uniquely ordered as `6 <= b' < c' <= 309`, giving `binom(304,2)=46,056` rows. The certificate’s freshness plus determinant predicates match the manuscript definition of a fresh legal pair. I found no normalization or semantic-transport defect in the lower-bound claim.

### General theorem and coding interpretation

The saturation identity and phase inequality are algebraically correct (PDF pp. 10–12; `sections/06-robust-repair.tex`, lines 12–41 and 100–144). Maximizing `e(k-e-1)` over profiles `k=f+2e` gives `floor((k-1)^2/4)`, and the phase hypothesis forces an empty carrier before applying the one-carrier lower bound. The numerical envelope values 319, 726, and 1350 are consistent with the displayed profile formulas.

The coding interpretation is appropriately limited (PDF p. 1; `sections/01-introduction.tex`, lines 19–24). A projective `k`-arc gives the columns of a `[k,3,k-2]` MDS code, and adjoining a jointly legal conjugate pair gives a Frobenius-compatible two-column MDS extension. The manuscript explicitly warns that “repair” changes the generator-column configuration and is not erasure decoding inside a fixed code. I recommend retaining that warning.

## Optional improvements

1. In the proof of Theorem 6.2, print the four short factorizations or coefficient-positive polynomials used to compare `L_f-L_8` for `s>=10` (PDF p. 11; `sections/06-robust-repair.tex`, lines 78–83). The present assertion is easy to check and formally supported, but one displayed line would make the paper proof self-contained.

2. Give one reference-machine replay measurement for the 9,511-module certificate: CPU/RAM, clean versus warm cache, elapsed time, and peak memory. The current explanation that no portable estimate is quoted (PDF p. 14; `sections/07-formal-verification.tex`, lines 139–143; `verification/README.md`, lines 49–51) is honest, but a nonportable benchmark is still useful planning information.

3. Clarify that “the obstruction envelope `W(k)` is exact over all profiles” means exact for the arithmetic profile optimization, not that every maximizing profile is realized by a geometric arc for every `(s,k)` (PDF p. 11; `sections/06-robust-repair.tex`, lines 100–126).

4. The rendered PDF is clean: no unresolved references or overfull/underfull warnings were found, the profile table is legible, and Figure 1 materially clarifies the two correction terms. No layout revision is required.

## Recommendation after revision

If the two mandatory items are fixed and the released certificate replays from a clean checkout with the stated manifest, I would expect the verdict to improve to B or A after a focused artifact and semantic-statement check. I do not currently see a mathematical defect in the main carrier argument or in the manuscript’s normalization bridge.
