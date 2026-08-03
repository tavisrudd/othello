# C836 — admissible scaling for AME global rounding (2026-08-02)

## Verdict

The fixed-local-dimension phrase attached to C833 was mathematically
conditional but scientifically weak: it described a formal slice of the
threshold while saying nothing about whether stabilizer AME tensors exist
along that slice.  The exact threshold should be presented first, followed
only by explicit existing families.

No theorem changes.  The repaired uniform asymptotic form is

    R_clean(n,q) = Theta(min(p^-1, q^-1/2, n^-1/2)),
    q = p^e.

The constants are absolute.  This follows directly from the exact minimum:
sin(pi/p) is Theta(p^-1), and d_p is uniformly bounded away from zero and
infinity.

## Explicit admissible regimes

Equal-phase states of generalized and extended generalized Reed--Solomon
[2m,m,m+1]_q codes give stabilizer AME(2m,q) tensors for 2m <= q+1.
Along this construction n <= q+1, so n^-1/2 cannot be the uniquely
smallest term.

| Field regime | GRS-tower threshold | If n is comparable to q |
|---|---:|---:|
| prime field, q=p | Theta(q^-1) | Theta(n^-1) |
| extension degree e=2 | Theta(q^-1/2) | Theta(n^-1/2) |
| extension degree e>=3 | Theta(q^-1/2) | Theta(n^-1/2) |
| fixed characteristic, e growing | Theta(q^-1/2) | Theta(n^-1/2) |

If q grows much faster than n, the displayed q-scale, not n, governs.
For a general stabilizer AME family outside the GRS construction, the
three-variable minimum remains the correct statement and no existence
asymptotic is inferred.

## Consequence for framing

- Removed the abstract's fixed-q n^-1/2 shorthand.
- Replaced it by the uniform three-parameter minimum.
- Added the explicit GRS prime-field and extension-field regimes.
- Marked fixed-q growth as a conditional formal slice rather than an
  existence claim.
- Changed “supersedes for fixed q” to a parameterwise comparison.

This makes the prime-field cost visible: on a length-saturating prime GRS
tower, the characteristic-dependent phase-resolution term lowers the
certified radius from n^-1/2 to n^-1.  Conversely, fixed-characteristic
extension towers retain the n^-1/2 scale when n is comparable to q.

No computation or certificate is used.
