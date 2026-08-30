# External claim: Hadamard matrix of order 2060

Not our work, and not from the Alpöge payload. Fetched for independent checking only.

| field | value |
|---|---|
| gist | https://gist.github.com/schneiderlo/b866a2ff2fcd93934f0db54cfa4069d0 |
| raw | https://gist.githubusercontent.com/schneiderlo/b866a2ff2fcd93934f0db54cfa4069d0/raw/H2060.txt |
| owner | `schneiderlo` |
| created | 2026-08-23T02:33:38Z |
| updated | 2026-08-23T02:33:42Z |
| revisions | 1 (`00784a83279fda136c961e0844616366f9298214`) |
| file | `H2060.txt`, 4,245,660 bytes = 2060 × 2061 |
| fetched | 2026-08-29 (this session) |
| sha256 | `c7a145d86210740dd3f8ea21ca896a54d6916007a042638f17c8c47f097200f7` |

Fetch and re-check:

```bash
curl -L -o H2060.txt \
  https://gist.githubusercontent.com/schneiderlo/b866a2ff2fcd93934f0db54cfa4069d0/raw/H2060.txt
sha256sum H2060.txt
~/.cache/c999-target/release/had668 verify   H2060.txt
~/.cache/c999-target/release/had668 classify H2060.txt
```

Gist metadata came from the public API (`curl -sSL https://api.github.com/gists/<id>`); `gh` was
not authenticated on this host.

The file is 2060 lines of exactly 2060 characters over `{+,-}` with no other characters.

## Verdict

**The claim holds.** `max |(H Hᵀ)_ij| = 0` for `i ≠ j` in exact `i64` arithmetic, every entry is
`±1`, and the matrix is square of order 2060. See `../certificate/H2060.json` for the full
record and `../certificate/README.md` under "External: order 2060" for the structure.
