# Provenance — Alpöge Hadamard-668 announcement artifacts

All fetches performed 2026-08-30, 02:42–02:47 UTC (local 2026-08-29 19:42–19:46 PDT),
from this machine via `curl` (WebFetch used only for narrative pages).
Nothing was decoded or executed.

## Payload files

| file | bytes | sha256 | source URL | fetched (UTC) |
|---|---|---|---|---|
| `alpoge-tweet-2087504785952182273-fxtwitter.txt` | 23828 | `5b5fe8fa42f0d6a8b4e4c9926726d82a6aab8e1070c1ae4d1b430c1277e58db4` | https://api.fxtwitter.com/__alpoge__/status/2087504785952182273 (`tweet.text`) | 2026-08-30T02:44Z |
| `alpoge-tweet-2087504785952182273-vxtwitter.txt` | 23828 | `5b5fe8fa42f0d6a8b4e4c9926726d82a6aab8e1070c1ae4d1b430c1277e58db4` | https://api.vxtwitter.com/__alpoge__/status/2087504785952182273 (`text`) | 2026-08-30T02:44Z |
| `alpoge-reply-2087504788938510427-fxtwitter.txt` | 6350 | `30d552fa26eab955cf73d7c762b34e23bea5a3ba70e384518cf718b040fd9f0a` | https://api.fxtwitter.com/__alpoge__/status/2087504788938510427 (`tweet.text`) | 2026-08-30T02:45Z |
| `alpoge-reply-2087504790435840207-fxtwitter.txt` | 105 | `3df59ed258b0880c3584bbfbaa8226fc9adfb42ac2ab65f54204feaad3df0912` | https://api.fxtwitter.com/__alpoge__/status/2087504790435840207 (`tweet.text`) | 2026-08-30T02:45Z |

The two independent mirrors of the main post are **byte-identical** (same sha256),
which is the cross-check that the 23,828-character payload was not truncated or
re-encoded by either mirror. Character set of the payload is exactly `{+, -}`;
no whitespace, no newline, no trailing newline in the saved file.

## Raw responses kept as evidence

| file | sha256 | source URL |
|---|---|---|
| `api-api.fxtwitter.com.json` | `425c91d5ceef876278f312b11c2d236deab94a9dda890e43aade649a783dcc7e` | https://api.fxtwitter.com/__alpoge__/status/2087504785952182273 |
| `api-api.vxtwitter.com.json` | `eddca764ba2c8a416dfbfffd1510d816114e5e9d6e558532b1d989f54daa54c2` | https://api.vxtwitter.com/__alpoge__/status/2087504785952182273 |
| `api-fx-2087504788938510427.json` | `745aad776182bd0d1951d4c4516a52bddfbbade2f844769b2ea09d4015d432ec` | https://api.fxtwitter.com/__alpoge__/status/2087504788938510427 |
| `api-fx-2087504790435840207.json` | `a198577994d10a0a91019026642ae06f4de6808c9f751be4d1bd450840119d46` | https://api.fxtwitter.com/__alpoge__/status/2087504790435840207 |
| `api-fx-sumeetrm-2087534215772479838.json` | `bce144cdcd5664762634bc1d76475e898dc8712edc670c98512702f50ee4dd9b` | https://api.fxtwitter.com/sumeetrm/status/2087534215772479838 |
| `syndication-2087504785952182273.json` | `dbe3d01ac1fb3d24d00b002f196c70a966048261b529c10398909ead13695d1d` | https://cdn.syndication.twimg.com/tweet-result?id=2087504785952182273&token=x&lang=en |
| `tr.html` | `5166dfd3ae4d4604d8e48f961dac164912c7daf9a393777c18968acc43a2a0a4` | https://threadreaderapp.com/thread/2087504785952182273.html |
| `tr-extracted.txt` | `84b7939fff069815aee498a2613cb8b8131320c429f359d59c4bf377c5dfb3c2` | derived locally from `tr.html` (tags stripped, sign-runs collapsed) — used only to discover the two reply IDs |

Total directory size: ~300 KB.

## Files committed here (C999, 2026-08-29)

Only the two payload files above were carried into this directory, under the
names `payload.txt` and `decoder-raw.txt`; the remaining fetch artifacts stayed
in the session scratchpad. Nothing from the poster's script was ever executed:
the de-obfuscation was performed by applying its three `sed` substitutions in
Python, and the decoding by an independent re-implementation (`../decode.py`).

| file | bytes | sha256 | origin |
|---|---|---|---|
| `payload.txt`               | 23828 | `5b5fe8fa42f0d6a8b4e4c9926726d82a6aab8e1070c1ae4d1b430c1277e58db4` | verbatim copy of `alpoge-tweet-2087504785952182273-fxtwitter.txt` |
| `decoder-raw.txt`           |  6350 | `30d552fa26eab955cf73d7c762b34e23bea5a3ba70e384518cf718b040fd9f0a` | verbatim copy of `alpoge-reply-2087504788938510427-fxtwitter.txt` |
| `decoder-deobfuscated.sh`   |  6679 | `c5d8b005b4bb32c2900c93161a6978b29a5dcbcd0af6bc13811a1d55c180710c` | `decoder-raw.txt` after the three static substitutions, plus a DO-NOT-RUN header |
| `../decode.py`              |       | `78ae0eb9cd43cdda8e68befef49e2ca383635f5eafe108aca08478a8cdca359b` | independent re-implementation, written for this task |

SHA-256 of each decoded matrix file `H<order>.txt` is tabulated in `../README.md`.
`decoder-deobfuscated.sh` is byte-identical to the poster's intended script apart
from the eleven-line header comment prepended at the top.
