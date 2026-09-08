# C1130 — Private module legal notice

**PRIVATE — contributor working document; do not ship this document.**
**Lane**: `ergodis`. Date: 2026-09-08.
**Status**: implemented and validated after Tavis confirmed Tavis Rudd as owner.
Both stripped private native/WASM providers carry the notice. Broader recipient-
license restrictions below remain draft terms, not an adopted license agreement.

## Recommended notice

The authoritative embedded text is private
`packages/execution-provider/LEGAL-NOTICE.txt`, using Copyright (c) 2026 Tavis Rudd,
All rights reserved. It reserves rights and points to a separate license rather
than purporting to create a contract through possession. Its single-paragraph form
is included verbatim in cold Describe JSON and packaged as a matching text sidecar.
The following expanded drafting form expresses the same intended reservation:

```text
ERGODIS PRIVATE MODULE — PROPRIETARY SOFTWARE
Copyright (c) 2026 Tavis Rudd. All rights reserved.

Permission to use, reproduce, modify or distribute this module is governed by
your separate license agreement with Tavis Rudd and applicable law. Possession
of this module does not itself grant additional rights.

Preserve this notice and accompanying attribution and license notices.
Third-party components remain subject to their respective licenses. This notice
does not restrict rights granted under those licenses or under the separate
license for the public Ergodis core.
```

Candidate additional language for the actual recipient license, for counsel's
review (not automatically imposed by the notice):

```text
Except as expressly authorized by this agreement or permitted by applicable law
notwithstanding this restriction, you may not reverse engineer, decompile or
disassemble the proprietary module, redistribute it, or remove or alter its
copyright, ownership or license notices. These restrictions do not override
rights granted by applicable third-party licenses.
```

Do not add a universal confidentiality/trade-secret assertion, automatic assent
by opening/loading, an invented corporate owner, or an unconditional claim that
all reverse engineering is unlawful. A notice is not a substitute for the actual
recipient agreement, delivery/acceptance process or applicable legal analysis.

## Placement and bounded implementation

1. Keep one authoritative notice text for private provider packaging. Embed its
   bytes in each native/WASM provider with a live reference from the existing
   cold Describe metadata; do not rely solely on an unreferenced string or debug
   section surviving stripping. No new hot-loop checks or allocations.
2. Include the same text as LEGAL-NOTICE.txt beside the payload and make it available
   during package inspection, before activation. Do not broaden the current
   strict host manifest schema casually; a versioned metadata change, if needed,
   gets the same compatibility gate as other extension metadata.
3. Test the actual stripped distribution: exact notice bytes present, Describe
   returns the intended text, sidecar matches, and existing native/browser
   transcripts still pass under the frozen host. A changed payload gets a new
   hash. Preserve original spike evidence instead of overwriting its identities.
4. Retain third-party attribution separately as required by the included components'
   licenses. The proprietary notice applies only to the material owned by the
   identified owner; it must not relicense the public core or dependencies.
5. Expose the notice in package details / an About or Legal surface. Keep it off
   the campaign's main solve controls. No repeated acceptance dialog is implied;
   any contractual acceptance belongs in the distribution/licensing workflow.

No public-core license change, click-through system, signature service or license
enforcement mechanism is part of this small notice addition. The current payload
hash binds embedded bytes against its selected manifest; it is not authentication
of the publisher or proof of contractual acceptance.

## Legal basis and limits (United States only)

This is a drafting aid, not a determination of enforceability. Counsel should
review restrictions and the recipient agreement for the intended jurisdictions.

- A US copyright notice identifies the owner and applicable publication year;
  proper notice can affect an innocent-infringement argument concerning damages.
  Do not treat an obscure embedded string alone as satisfying every notice-position
  requirement. [17 USC 401](https://www.copyright.gov/title17/92chap4.html).
- Copyright-management information has separate statutory protection against
  certain knowing/intentional falsification or removal connected to infringement;
  embedding a notice does not make every deletion automatically unlawful.
  [US Copyright Office DMCA overview](https://www.copyright.gov/dmca/).
- US federal trade-secret definitions exclude reverse engineering and independent
  derivation from improper means. A confidentiality label alone therefore cannot
  establish that any examination of a delivered binary is misappropriation.
  [18 USC 1839](https://uscode.house.gov/view.xhtml?req=%28title%3A18+section%3A1839+edition%3Aprelim%29).

Sources checked 2026-09-08. Local inspection found no LICENSE/COPYING/NOTICE file
in the private repository outside excluded analysis/build directories, and no
owner/license declaration in the root or two provider Cargo manifests. This is
not a finding about agreements held elsewhere. Tavis subsequently confirmed Tavis Rudd as owner. Broader license restrictions
remain proposed wording, not terms already agreed by recipients.

## Implemented result

Private implementation/evidence commit: `5da6805`.

The one authoritative notice is embedded through compile-time inclusion in both
cold Describe descriptors (implementation revision 3). Packaging emits the same
bytes as LEGAL-NOTICE.txt and refuses payloads missing that notice. Solver loops,
public-core licenses, ABI operations and the frozen host executable are unchanged.

Both native/WASM stripped payloads pass exact notice-byte/sidecar checks. Native
Describe and actual Chromium Worker Describe return the exact authoritative text.
The frozen native recipient and Chromium pass the existing LRC 23-operation and
QEC 20-operation transcripts; one canonical core engine is fetched. The component
comparison arm remains its historical payload, outside the new notice assertion.
Scoped provider contract tests and all-target/all-feature Clippy pass. No native
performance acceptance claim is added for this cold-metadata change.

Evidence: private analysis/module-loading/legal-evidence/; source scripts and
README include replay. Cache: ~/.cache/ergodis/module-loading/legal-notice/.
Original spike evidence and payload identities were preserved. Final verification:
/tmp/claude-run-quiet/20260908-144237-nix-shell-nixpkgsnodejs-nixpkgschromium-command-env-legal-notice-bash-verify-lega/.
The first ctypes audit supplied a null empty-input pointer, which the existing ABI
rejects; correcting the audit to supply a non-null zero-length borrowed input made
it pass. No ABI relaxation or provider change was needed for that harness fix.

A copyright notice is now present and discoverable; this does not establish
recipient assent to a separate agreement or determine enforceability. No complete
EULA, reverse-engineering restriction or confidentiality obligation was activated.
