# C864 — where to cut the five mixed order-eleven interface modules

**Date:** 2026-08-04
**Lane:** `build-sys`
**Purpose:** a proposal, not an edit. The payload inventory
(`notes/2026-08-04-c864-q11-payload-inventory.md`) identified five order-eleven modules that are
both a semantic interface and an exhaustive computation. This note proposes where each one is cut
when the order-eleven families move to an external package. No file was moved or edited.

## The rule these lines follow

The order-16 split is the precedent. The monorepo keeps statements and definitions that other
modules and papers name; the exhaustive proof and its generated data move into the package; the
monorepo consumes a compact pinned fact rather than importing the certificate closure. So for each
module the question is only: which declarations are named by something outside the order-eleven
family, and which exist solely to discharge them.

The gate `RelativeConicArcs.Gates.ClebschRigidityTrust` is the authority on what is paper-facing:
what it audits is the surface, and nothing else in these modules is.

## Point-orbit entry module

Audited terminals — the orbit partition, uniqueness of the six-point orbit, uniqueness of the
twelve-point orbit, and that the Brianchon points form one orbit. No other declaration of this
module is named anywhere outside the order-eleven family.

**Cut:** those four statements stay as the semantic interface, proved from a pinned package fact.
Everything else in the module, and the whole row family beneath it — 60 generated leaves, 72 row
aggregators, and the matrix, support and fixed-point satellites — moves. This is the largest single
elaboration saving available in the family.

## Coding module

Audited terminals — the MDS column property, the identification of distance-three directions with
the standard conic, and covering radius three. Of its 28 declarations exactly one is named by a
consumer outside the family: the distance-three identification, used by the Clebsch gateway
extension.

**Cut:** the three audited statements plus the distance-three identification stay; the exhaustive
case work behind them moves. Note the module raises elaboration limits for that case work, so after
the cut the local module should carry none.

## Decoding synthesis module

Audited terminals — the exact total syndrome distance, ambiguity strata soundness and counts, the
identification of Brianchon direction indices, and the weight-two leader supports. Its declarations
live in the coding namespace, which is why they appear as coding terminals in the audit. No
declaration of this module is named by any consumer outside the family: its only external reach is
through the gate's audit and the reflection-arrangement decoding gate.

**Cut:** the audited statements stay; the entire synthesis computation moves. This is the cleanest
of the five — interface above, computation below, no third party reaching inside.

## Brianchon–Petersen module

Consumer is the reflection-arrangement module, which uses four declarations: the chord-edge
constructor, the raw chord line, and the two vector helpers for cross and dot products. Fifty of
its 54 declarations are unreferenced outside.

**Cut:** those four definitions are small and general enough to stay, and the vector helpers should
in fact move up into a shared geometry module rather than being re-exported from a certificate
interface. The matching and perfect-matching enumeration, the edge tables, and the exhaustive
incidence work move.

## Residual module

Named outside by the Clebsch gateway conic module: the conic embedding, its range characterization,
the conic point and raw point constructors, membership of the standard conic, and the adjacency and
neighbour definitions. Its game terminal is named nowhere outside the module.

**Cut:** this module is already scheduled for a different split, described in the task card, because
of the base-library export defect: a game-free half holding the conic parametrization, the
icosahedral adjacency and the validity dictionary, and a separate module holding the
previous-player-win terminal. That split should be done first and this externalization applied to
the game-free half only. The declarations listed above all sit in the game-free half.

## What still needs reading before the cut

Each cut names statements, not line numbers. Before moving anything, each module needs a read to
confirm that the surviving statements do not silently depend on a definition being moved out from
under them — the coding and Brianchon–Petersen modules are the two where that risk is real, since
their surviving declarations are definitions rather than closed theorems.
