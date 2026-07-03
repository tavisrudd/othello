#!/usr/bin/env node
// Validation harness for the queens-explorable engine. Extracts the
// `queens-core` / `queens-data` script blocks straight out of the HTML (single
// source of truth — nothing is duplicated here) and cross-checks them against
// the Rust solver's known values:
//   - first-player verdicts n=1..10 (sign of A344227)
//   - `symmetry` solver node counts (queens solve <n> symmetry, 2026-07-03)
//   - Sprague-Grundy nimbers n=1..9 vs OEIS A344227
//   - memo-less naive vs memoized agreement (n<=7)
//   - odd-n mirror line legality + parity
//   - D4 canon invariance under all 8 transforms
//   - the hard-coded n=18 PV: legal, 15 plies, ends with no square free
//
// Run with a small heap on purpose (box may be under memory pressure):
//   node --max-old-space-size=512 queens-explorable-test.mjs

import { readFileSync } from 'node:fs';

const html = readFileSync(new URL('./queens-explorable.html', import.meta.url), 'utf8');
function extract(id) {
  const m = html.match(new RegExp(`<script id="${id}">([\\s\\S]*?)</script>`));
  if (!m) throw new Error(`script #${id} not found in queens-explorable.html`);
  return m[1];
}
// Evaluate in the main realm (NOT node:vm — its contextified sandbox routes
// every global lookup through a C++ interceptor, ~10x slower, and the point
// here is also to see real engine speed).
const { QueensCore: Core, QueensData: Data } =
  new Function(extract('queens-core') + extract('queens-data') +
    '; return { QueensCore, QueensData };')();

let pass = 0, fail = 0;
function check(name, ok, detail = '') {
  if (ok) { pass++; console.log(`  ok   ${name}${detail ? ` — ${detail}` : ''}`); }
  else { fail++; console.log(`  FAIL ${name}${detail ? ` — ${detail}` : ''}`); }
}

// --- verdicts + node counts vs the Rust `symmetry` solver -------------------
console.log('verdicts n=1..10 (win iff A344227[n] != 0) + node counts:');
const rustNodes = { 6: 27, 7: 54, 8: 625, 9: 858, 10: 94760 };
for (let n = 1; n <= 10; n++) {
  const q = new Core.Queens(n);
  const solver = new Core.Solver(q);
  const t0 = Date.now();
  const wins = solver.wins(0n);
  const ms = Date.now() - t0;
  const expected = Data.A344227[n] !== 0;
  check(`n=${n} first player ${expected ? 'wins' : 'loses'}`, wins === expected,
    `${solver.nodes} nodes, ${ms}ms`);
  if (n in rustNodes) {
    // Exact at n<=8; at n=9/10 the Rust fixed-size TT re-expands a handful of
    // evicted entries so rust >= js by a hair. Gate: js <= rust, within 1%.
    const r = rustNodes[n];
    check(`n=${n} node count vs Rust symmetry solver`,
      solver.nodes <= r && solver.nodes >= r * 0.99,
      `js=${solver.nodes} rust=${r}${solver.nodes === r ? ' (exact)' : ''}`);
  }
}

// --- nimbers vs OEIS A344227 ------------------------------------------------
console.log('nimbers n=1..9 vs OEIS A344227:');
for (let n = 1; n <= 9; n++) {
  const g = new Core.Grundy(new Core.Queens(n)).nimber();
  check(`G(${n}) = ${Data.A344227[n]}`, g === Data.A344227[n], `got ${g}`);
}

// --- naive (memo-less ground truth) vs memoized ------------------------------
console.log('naive vs memoized, n=1..7:');
for (let n = 1; n <= 7; n++) {
  const q = new Core.Queens(n);
  check(`n=${n} agree`, Core.naiveWins(q, 0n) === new Core.Solver(q).wins(0n));
}

// --- mirror line -------------------------------------------------------------
console.log('odd-n mirror line (centre + 180° pairing):');
for (const n of [1, 3, 5, 7, 9]) {
  const q = new Core.Queens(n);
  const line = Core.mirrorLine(q);
  let blocked = 0n, legal = true;
  for (const sq of line) {
    if (!q.isAvailable(blocked, sq)) { legal = false; break; }
    blocked = q.place(blocked, sq);
  }
  check(`n=${n} line legal, odd length, board dead`,
    legal && line.length % 2 === 1 && q.noMoves(blocked),
    `${line.length} plies`);
  // every even ply (0-indexed) after the centre mirrors the previous one
  let mirrored = true;
  for (let i = 2; i < line.length; i += 2) {
    if (line[i] !== q.mirror(line[i - 1])) mirrored = false;
  }
  check(`n=${n} every reply is the 180° mirror`, mirrored);
}

// --- canon invariance ---------------------------------------------------------
console.log('D4 canon: canon(perm_t(mask)) == canon(mask) for all 8 t:');
{
  const q = new Core.Queens(7);
  let lcg = 12345, bad = 0;
  const rnd = () => (lcg = (lcg * 1103515245 + 12345) & 0x7fffffff);
  for (let trial = 0; trial < 200; trial++) {
    let mask = 0n;
    for (let s = 0; s < 49; s++) if (rnd() % 3 === 0) mask |= q.bit[s];
    const want = q.canon(mask);
    for (let t = 0; t < 8; t++) {
      let img = 0n;
      Core.forEachBit(mask, s => { img |= q.bit[q.sym[t][s]]; });
      if (q.canon(img) !== want) bad++;
    }
  }
  check('200 random masks × 8 transforms', bad === 0, bad ? `${bad} mismatches` : '');
}

// --- oracle / bestMove self-consistency ---------------------------------------
console.log('bestMove: solver-vs-solver playout matches the root verdict:');
for (const n of [6, 8, 10]) {
  const q = new Core.Queens(n);
  const solver = new Core.Solver(q);
  const rootWins = solver.wins(0n);
  let blocked = 0n, mover = 0, plies = 0; // mover 0 = first player
  while (!q.noMoves(blocked)) {
    const mv = solver.bestMove(blocked);
    blocked = q.place(blocked, mv.sq);
    mover ^= 1; plies++;
  }
  // `mover` is now the player to move with no square: the loser.
  const firstWon = mover === 1;
  check(`n=${n} playout winner matches verdict`, firstWon === rootWins,
    `${plies} plies`);
}

// --- the n=18 PV (hard-coded data) --------------------------------------------
console.log('n=18 principal variation (I9 …):');
{
  const q = new Core.Queens(18);
  const pv = Data.n18.pv;
  let blocked = 0n, legal = true;
  const schedule = [q.availableCount(blocked)];
  for (const name of pv) {
    const sq = Core.parseSq(q, name);
    if (!q.isAvailable(blocked, sq)) { legal = false; break; }
    blocked = q.place(blocked, sq);
    schedule.push(q.availableCount(blocked));
  }
  check('all 15 moves legal (non-attacking)', legal && pv.length === 15);
  check('final position dead (no square free)', q.noMoves(blocked));
  check('odd ply count ⇒ first player made the last move', pv.length % 2 === 1);
  console.log(`  info deletion schedule: ${schedule.join(' → ')}`);
  console.log(`  info I9 deletes ${schedule[0] - schedule[1]} squares (of ${schedule[0]})`);
  check('round-trip sqName(parseSq)', pv.every(nm => Core.sqName(q, Core.parseSq(q, nm)) === nm));
}

// --- StatsSolver: identical search, sane counters ------------------------------
console.log('StatsSolver vs Solver (identical nodes/verdicts) + counter sanity:');
for (let n = 4; n <= 9; n++) {
  const q1 = new Core.Queens(n), q2 = new Core.Queens(n);
  const a = new Core.Solver(q1), b = new Core.StatsSolver(q2);
  const wa = a.wins(0n), wb = b.wins(0n);
  check(`n=${n} same verdict + node count`, wa === wb && a.nodes === b.nodes,
    `${a.nodes} vs ${b.nodes}`);
}
{
  const q = new Core.Queens(8);
  const s = new Core.StatsSolver(q);
  s.wins(0n);
  const st = s.stats;
  check('n=8 win+loss nodes = expansions', st.winNodes + st.lossNodes === s.nodes);
  check('n=8 tried >= edges, both positive', st.tried >= st.edges && st.edges > 0);
  check('n=8 both transposition kinds occur', st.rawHits > 0 && st.canonHits > 0,
    `order=${st.rawHits} sym=${st.canonHits}`);
  check('n=8 winTriedSum >= winNodes', st.winTriedSum >= st.winNodes,
    `avg cutoff ${(st.winTriedSum / st.winNodes).toFixed(2)}`);
}

// --- naiveCount regression (pins the move order + recursion shape) -------------
console.log('naiveCount node counts (engine regression values, 2026-07-03):');
const naiveNodes = { 6: 154, 7: 1556, 8: 7612, 9: 49752 };
for (const [n, want] of Object.entries(naiveNodes)) {
  const q = new Core.Queens(Number(n));
  const r = Core.naiveCount(q, 0n);
  check(`naive n=${n} = ${want} nodes`, r.nodes === want, `got ${r.nodes}`);
  check(`naive n=${n} verdict matches A344227`, r.wins === (Data.A344227[n] !== 0));
}
if (process.env.QUEENS_TEST_SLOW === '1') {
  console.log('slow: verifying the precomputed naive n=10 point (~40s):');
  const q = new Core.Queens(10);
  const r = Core.naiveCount(q, 0n);
  check('naive n=10 matches QueensData.naive10', r.nodes === Data.naive10.nodes,
    `got ${r.nodes} want ${Data.naive10.nodes}`);
} else {
  console.log('  (skip: naive n=10 precomputed-point verify — set QUEENS_TEST_SLOW=1)');
}

// --- the scenes block at least parses (no DOM here to run it) ------------------
console.log('scenes script:');
try {
  new Function(extract('queens-scenes'));
  check('queens-scenes parses', true);
} catch (e) {
  check('queens-scenes parses', false, String(e));
}

// --- firstPlayerWins table -----------------------------------------------------
console.log('QueensData.firstPlayerWins:');
check('n=10,12,14,16 second player', [10, 12, 14, 16].every(n => Data.firstPlayerWins(n) === false));
check('n=18 first player (new result)', Data.firstPlayerWins(18) === true);
check('n=20 open', Data.firstPlayerWins(20) === null);
check('odd n first player', [3, 5, 7, 9, 11, 13, 15, 17].every(n => Data.firstPlayerWins(n) === true));

console.log(`\n${pass} passed, ${fail} failed`);
process.exit(fail ? 1 : 0);
