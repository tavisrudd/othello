# C934 repaired-manuscript referee freeze

**Date:** 2026-08-20

**Authority commit:** `8a46b475da8241695ab83e2b90e5bce9e0188c0e`

**Frozen manuscript:**
`papers/blown-up-theta-lattice/blown_up_theta_lattice.pdf`

**SHA-256:**

- PDF: `98b8669dce44baa12f5bf21235d32a6aa850a50b9daf622aa5790ea90288d655`
- main TeX: `9e6fe75f92d5a5a4348ce6a2fec94814b0231073bb8159460ef797e6f74a27e6`
- Section 7: `11a6590ba29fc870b91556eab792cf0ef12af99ae9d20f63dc4648677f2302b3`

The PDF has 11 A4 pages.  `make check` passed without a final LaTeX,
bibliography, reference, overfull-box, underfull-box, or spacing-lint warning.
The PDF-extracted abstract has 147 whitespace tokens, below both the hard
250-word limit and the preferred 150-word target.

## Repairs and upgrades in scope

1. The manuscript now cites and delimits de Cataldo--Migliorini's rational
   intersection-form mechanism and Cipriani's field-coefficient
   small-extension classification.
2. Section 7 states why freeness of the residual stalk and costalk groups
   makes derived reduction modulo three perverse and excludes torsion point
   summands.
3. The modular theorem now gives the canonical length-three Loewy filtration
   with factors `delta_0`, `IC_Theta(F_3)`, `delta_0` and asserts that both
   adjacent extensions are nonsplit.
4. Corollary 1.5 identifies the outer relative Lefschetz map with
   multiplication by three and deduces failure of relative hard Lefschetz
   modulo three.
5. The title is unchanged.  The abstract was rewritten in active voice to
   surface the lattice, integral direct image, Loewy, Fano-lift, and modular
   hard-Lefschetz headlines.

Fresh rerun reports must review this frozen commit and hash only.  Any later
manuscript edit invalidates the freeze.
