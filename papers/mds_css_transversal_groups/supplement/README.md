# Evidence supplement

This directory is the paper-local reproducibility package for every
computational result retained by *Diagonal Isoduality and Transversal
Clifford Groups of MDS--CSS Codes*.  `EVIDENCE.md` gives the
claim, exact domain, certificate meaning, independent check, and trust boundary
for each bundle.  The imported generators and canonical JSON certificates are
under `evidence/`.  They are byte-identical to the frozen source artifacts
except for dependency paths relocated to keep a generator self-contained
inside the paper bundle; the manifest pins the exact paper-local bytes.

From this directory, verify all sizes and SHA-256 hashes without changing the
worktree:

```text
python3 verify.py
```

Regenerate every certificate in memory and compare it with the tracked bytes:

```text
python3 verify.py --replay
```

Both commands use only Python 3's standard library.  The full replay is
deterministic and may take several minutes.  The manifest also includes the
hash-pinned pencil-arithmetic module because it is a load-bearing input to the
holonomy-completeness certificate, though it is not itself an adopted paper
result.
