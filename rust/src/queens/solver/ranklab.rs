//! Offline move-ordering lab (`queens ranklab`). Consumes a `QUEENS_HITKEY` dump — sampled deep-tail
//! node states (canonical key + available-square set + pc) — and scores candidate child orderings
//! against the production degree ordering WITHOUT a live search.
//!
//! The metric is `ordering_loss` = E − E_perfect, the *avoidable* child-examination waste the
//! `QUEENS_RANK` report surfaces. It collapses to the 0-based rank of the first losing child: a
//! perfect order cuts every winning OR-node at rank 0; a LOSS (no-cut) node is unavoidable. Because a
//! child's win/loss value is order-invariant, the rank ANY candidate ordering achieves is exactly the
//! index of its earliest losing child — so the A/B is exact offline, no re-search per candidate rule.
//!
//! Labeling (which children are losing) happens HERE, in an isolated solver context (its own TT),
//! never in the live run — inline labeling would pollute the production TT and skew the sample (the
//! constraint baked into this design). We reuse the real iso-dense kernel via [`Solver::wins`] so the
//! labels — and thus the baseline rank — are exact, and a shared TT amortises the labeling cost across
//! the overlapping sampled subtrees.

use super::{make_solver, Solver};
use crate::queens::{Bits, Queens};
use rayon::prelude::*;
use std::path::Path;

/// Candidate orderings scored per node (index 0 is the live baseline; keep in sync with the names).
/// 0–2 controls, 3–4 the bounded-oracle CEILINGS (what any tie-break / ±1 reorder could reach), 5+ the
/// one-ply reply-degree discriminators being proven out (all degree-primary tie-breaks).
const NCAND: usize = 10;
const CAND_NAMES: [&str; NCAND] = [
    "degree(cur)", // 0 baseline — reproduces the live order ⇒ captured 0% (pipeline check)
    "oracle",      // 1 losing child first ⇒ captures 100% (full avoidable-loss ceiling)
    "random",      // 2 deterministic shuffle ⇒ noise floor control
    "same-deg", // 3 bounded oracle k=0 = the tie-break CEILING (the discriminators below aim at this)
    "deg±1",    // 4 bounded oracle k=1 = the ±1-window CEILING
    "mingc↓", // 5 tie-break: min opponent reply degree DESC (opponent's best escape is weakest first)
    "mingc↑", // 6 tie-break: min opponent reply degree ASC (opposite direction — sanity)
    "sumgc↓", // 7 tie-break: total opponent reply degree DESC (whole reply menu weakest first)
    "sumgc↑", // 8 tie-break: total opponent reply degree ASC (opposite)
    "sumgc⇄", // 9 pc-adaptive: sumgc↓ for pc≤20, sumgc↑ for pc≥21 (the signal's sign flips at ~pc21)
];

/// One scored node: its pc, whether it had a losing child (else nocut = unavoidable, excluded), and
/// the 0-based first-losing-child rank under each candidate ordering. `cand_rank[0]` is the live order.
struct NodeScore {
    pc: usize,
    cut: bool,
    cand_rank: [u32; NCAND],
}

/// Deterministic per-node PRNG (splitmix64) seeded from the node's own bits, so the "random" ordering
/// is reproducible run-to-run without a `rand` dependency or wall-clock seed.
fn splitmix64(state: &mut u64) -> u64 {
    *state = state.wrapping_add(0x9E37_79B9_7F4A_7C15);
    let mut z = *state;
    z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
    z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
    z ^ (z >> 31)
}

/// One-ply reply-degree stats of a child `h` (the opponent's reply menu): for each opponent move `v`
/// in `h`, the grandchild degree `popcount(h \ attack[v])`. Returns `(min, sum, has_instant_win)`.
/// Cheap — O(child_pc) bitmask ops, no allocation/BFS/canonicalization (the cost tier that can survive
/// the hot loop). The hypothesis: a *losing* child (P-position for the opponent) leaves the opponent no
/// forcing escape ⇒ high reply degrees / no instant win.
fn reply_stats(h: Bits, attack: &[Bits]) -> (u32, u32, bool) {
    if h == Bits::ZERO {
        return (0, 0, true); // empty child = the move already won; nothing to reply with
    }
    let (mut mn, mut sum, mut iw) = (u32::MAX, 0u32, false);
    h.each(|v| {
        let gd = h.and_not(attack[v as usize]).popcount();
        mn = mn.min(gd);
        sum += gd;
        iw |= gd == 0;
    });
    (mn, sum, iw)
}

/// Label every child of `avail` and score each candidate ordering by the rank of its first losing
/// child. A child is *losing* (a winning move for the mover) iff the resulting position is a LOSS for
/// the opponent: `!solver.wins(child)`. `wins(q, blocked)` evaluates the node whose available set is
/// `board \ blocked`, so `blocked = board \ child`.
fn score_node(q: &Queens, solver: &dyn Solver, avail: Bits) -> NodeScore {
    let pc = avail.popcount() as usize;
    // Available moves in q.order order (the live baseline's stable tie-break).
    let moves: Vec<u32> = q
        .order
        .iter()
        .copied()
        .filter(|&sq| avail.get(sq))
        .collect();
    let m = moves.len();
    // Each move's child (placing removes sq + its attacks), and its degree = child popcount. The
    // degree matches `sort_moves_by_degree` exactly (build_att's identity image att[sq][0] == attack).
    let children: Vec<Bits> = moves
        .iter()
        .map(|&sq| avail.and_not(q.attack[sq as usize]))
        .collect();
    let deg: Vec<u32> = children.iter().map(|c| c.popcount()).collect();
    // One-ply reply-degree stats per child (the opponent's reply menu from that child).
    let reply: Vec<(u32, u32, bool)> = children
        .iter()
        .map(|&c| reply_stats(c, &q.attack))
        .collect();
    let min_gc: Vec<u32> = reply.iter().map(|r| r.0).collect();
    let sum_gc: Vec<u32> = reply.iter().map(|r| r.1).collect();
    // Exact label per move via the production kernel (verdict is order-invariant; the shared TT
    // amortises across nodes). An empty child (move fills the board) is a loss for the opponent ⇒
    // `wins` returns false ⇒ losing = true, the instant-win move.
    let losing: Vec<bool> = children
        .iter()
        .map(|&child| !solver.wins(q, q.board.and_not(child)))
        .collect();
    let mut ns = NodeScore {
        pc,
        cut: losing.iter().any(|&b| b),
        cand_rank: [0; NCAND],
    };
    if !ns.cut {
        return ns; // nocut — contributes zero ordering loss (a mandatory full scan)
    }
    // Rank of the first losing child under an index order.
    let rank_of =
        |order: &[usize]| -> u32 { order.iter().position(|&i| losing[i]).unwrap() as u32 };
    // Stable sort of `0..m` by a key (ties keep q.order order, matching the live tie-break).
    let sorted = |key: &dyn Fn(usize) -> (u32, u32, u32)| -> Vec<usize> {
        let mut v: Vec<usize> = (0..m).collect();
        v.sort_by_key(|&i| key(i));
        v
    };
    ns.cand_rank[0] = rank_of(&sorted(&|i| (deg[i], 0, 0))); // degree asc (= live order)
    ns.cand_rank[1] = 0; // oracle: a losing child exists ⇒ a perfect order cuts at rank 0
    ns.cand_rank[2] = {
        let mut v: Vec<usize> = (0..m).collect();
        let mut s =
            avail.0[0] ^ avail.0[1].rotate_left(17) ^ avail.0[2].rotate_left(33) ^ avail.0[3];
        for i in (1..m).rev() {
            let j = (splitmix64(&mut s) % (i as u64 + 1)) as usize;
            v.swap(i, j);
        }
        rank_of(&v)
    };
    // Bounded-oracle ceilings: with d* = min degree among losing children, a deg±k order can place the
    // min-degree losing child after only the children of degree < d*−k. k=0 = the best ANY equal-degree
    // tie-break can do; k=1 = the ±1-window ceiling. The discriminators (5+) are degree-primary
    // tie-breaks, so they can capture at most the same-deg (k=0) ceiling.
    let dstar = (0..m).filter(|&i| losing[i]).map(|i| deg[i]).min().unwrap();
    let count_below = |thr: u32| (0..m).filter(|&i| deg[i] < thr).count() as u32;
    ns.cand_rank[3] = count_below(dstar); // same-degree ceiling (k=0)
    ns.cand_rank[4] = count_below(dstar.saturating_sub(1)); // deg±1 ceiling
                                                            // One-ply reply-degree tie-breaks (degree primary, reply stat secondary, q.order final tie).
    ns.cand_rank[5] = rank_of(&sorted(&|i| (deg[i], u32::MAX - min_gc[i], 0))); // min reply deg DESC
    ns.cand_rank[6] = rank_of(&sorted(&|i| (deg[i], min_gc[i], 0))); // min reply deg ASC
    ns.cand_rank[7] = rank_of(&sorted(&|i| (deg[i], u32::MAX - sum_gc[i], 0))); // sum reply deg DESC
    ns.cand_rank[8] = rank_of(&sorted(&|i| (deg[i], sum_gc[i], 0))); // sum reply deg ASC
                                                                     // pc-adaptive sign: the sumgc signal flips direction at ~pc21 (opponent-stuck-first helps in the
                                                                     // shallow shoulder, opponent-mobile-first helps deeper) — use the per-band-correct direction.
    ns.cand_rank[9] = if pc <= 20 {
        rank_of(&sorted(&|i| (deg[i], u32::MAX - sum_gc[i], 0)))
    } else {
        rank_of(&sorted(&|i| (deg[i], sum_gc[i], 0)))
    };
    ns
}

/// Per-pc (and grand) accumulator over the scored nodes.
#[derive(Default, Clone)]
struct Agg {
    nodes: u64,             // sampled nodes at this pc
    nocut: u64,             // excluded (no losing child — unavoidable full scan)
    sum_cur: u64,           // Σ current_rank over cut nodes (= the avoidable loss, baseline)
    sum_cand: [u64; NCAND], // Σ candidate_rank over cut nodes, per ordering
}

/// Run the offline lab over a `QUEENS_HITKEY` dump at `dump_path`. Scores the giant-shoulder band
/// `pc_lo..=pc_hi`, stride-subsampled to `cap_per_pc` nodes per pc, and prints the captured fraction
/// of avoidable `ordering_loss` for each candidate ordering. `QUEENS_TT_BITS` sizes the labeling TT.
pub fn run_ranklab(
    dump_path: &Path,
    cap_per_pc: usize,
    pc_lo: usize,
    pc_hi: usize,
) -> std::io::Result<()> {
    let bytes = std::fs::read(dump_path)?;
    // Header: "QHK1" + n(u32 LE) + count(u64 LE) = 16 bytes; records are 68 bytes
    // (key 32 + avail 32 + pc 2 + hit 1 + pad 1) — see `IsoFlat::write_hitkey_file`.
    const REC: usize = 68;
    if bytes.len() < 16 || &bytes[0..4] != b"QHK1" {
        eprintln!(
            "ranklab: {} is not a QHK1 (QUEENS_HITKEY) dump",
            dump_path.display()
        );
        std::process::exit(1);
    }
    let n = u32::from_le_bytes(bytes[4..8].try_into().unwrap());
    let body = &bytes[16..];
    let nrec = body.len() / REC;

    let read_avail_pc_hit = |i: usize| -> (Bits, usize, bool) {
        let o = i * REC + 32; // skip the 32-byte canonical key
        let mut av = [0u64; 4];
        for (w, slot) in av.iter_mut().enumerate() {
            *slot = u64::from_le_bytes(body[o + w * 8..o + w * 8 + 8].try_into().unwrap());
        }
        let pc = u16::from_le_bytes(body[i * REC + 64..i * REC + 66].try_into().unwrap()) as usize;
        let hit = body[i * REC + 66] != 0;
        (Bits(av), pc, hit)
    };

    // Eligible = an expanding node (miss) whose pc is in band. First pass: per-pc totals.
    let mut total: Vec<usize> = vec![0; pc_hi + 1];
    for i in 0..nrec {
        let (_, pc, hit) = read_avail_pc_hit(i);
        if !hit && (pc_lo..=pc_hi).contains(&pc) {
            total[pc] += 1;
        }
    }
    // Second pass: stride-subsample up to cap_per_pc per pc (spread across the dump, not first-N).
    let stride: Vec<usize> = total
        .iter()
        .map(|&t| {
            if cap_per_pc == 0 || t <= cap_per_pc {
                1
            } else {
                t / cap_per_pc
            }
        })
        .collect();
    let mut seen = vec![0usize; pc_hi + 1];
    let mut kept: Vec<Bits> = Vec::new();
    for i in 0..nrec {
        let (avail, pc, hit) = read_avail_pc_hit(i);
        if hit || !(pc_lo..=pc_hi).contains(&pc) {
            continue;
        }
        let s = seen[pc];
        seen[pc] += 1;
        if s.is_multiple_of(stride[pc]) && (cap_per_pc == 0 || (s / stride[pc]) < cap_per_pc) {
            kept.push(avail);
        }
    }
    if kept.is_empty() {
        eprintln!(
            "ranklab: no eligible records in pc {pc_lo}..={pc_hi} (dump has {nrec} records, n={n})"
        );
        return Ok(());
    }

    let bits: u32 = std::env::var("QUEENS_TT_BITS")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(28);
    let q = Queens::new(n);
    let solver = make_solver("iso-dense", bits).expect("iso-dense solver");
    let solver = solver.as_ref();

    println!(
        "ranklab — {} · n={n} · scoring {} sampled nodes (pc {pc_lo}..={pc_hi}, cap {cap_per_pc}/pc) · labeling solver iso-dense, TT 2^{bits}",
        dump_path.display(),
        kept.len(),
    );

    // Label + score every kept node in parallel (concurrent `wins` on the shared lockless TT — the
    // production pattern; `Solver: Sync`). The shared TT means overlapping sampled subtrees are paid
    // once across the whole sweep.
    let scores: Vec<NodeScore> = kept
        .par_iter()
        .map(|&avail| score_node(&q, solver, avail))
        .collect();

    // Aggregate per pc and overall.
    let mut per: Vec<Agg> = vec![Agg::default(); pc_hi + 1];
    let mut all = Agg::default();
    for s in &scores {
        let a = &mut per[s.pc];
        a.nodes += 1;
        all.nodes += 1;
        if !s.cut {
            a.nocut += 1;
            all.nocut += 1;
            continue;
        }
        let cur = s.cand_rank[0] as u64;
        a.sum_cur += cur;
        all.sum_cur += cur;
        for c in 0..NCAND {
            a.sum_cand[c] += s.cand_rank[c] as u64;
            all.sum_cand[c] += s.cand_rank[c] as u64;
        }
    }

    // Captured fraction of avoidable loss for candidate c: (Σcur − Σcand) / Σcur. A ratio of sums, so
    // it estimates the true captured fraction from the sample without needing absolute node counts.
    let capt = |a: &Agg, c: usize| -> f64 {
        if a.sum_cur == 0 {
            0.0
        } else {
            100.0 * (a.sum_cur as f64 - a.sum_cand[c] as f64) / a.sum_cur as f64
        }
    };

    let mut hdr = format!(
        "    {:>3} {:>9} {:>8} {:>10}",
        "pc", "scored", "nocut%", "mean_rank"
    );
    for name in CAND_NAMES {
        hdr.push_str(&format!(" {name:>13}"));
    }
    println!("{hdr}   (per-candidate = % of avoidable loss captured vs the live order)");
    let print_row = |label: String, a: &Agg| {
        let cut = a.nodes - a.nocut;
        let mean_rank = if cut > 0 {
            a.sum_cur as f64 / cut as f64
        } else {
            0.0
        };
        let mut row = format!(
            "    {label:>3} {:>9} {:>7.1}% {:>10.3}",
            a.nodes,
            100.0 * a.nocut as f64 / a.nodes.max(1) as f64,
            mean_rank,
        );
        for c in 0..NCAND {
            row.push_str(&format!(" {:>12.1}%", capt(a, c)));
        }
        println!("{row}");
    };
    for (pc, a) in per.iter().enumerate().take(pc_hi + 1).skip(pc_lo) {
        if a.nodes > 0 {
            print_row(pc.to_string(), a);
        }
    }
    print_row("ALL".to_string(), &all);
    println!(
        "  mean_rank = mean first-losing-child rank under the live degree order (≈ the report's loss/cut).\n  \
         degree(cur)=0% and oracle=100% validate the pipeline; random = noise floor."
    );
    // Discriminator summary: each tie-break's capture vs the FULL oracle, vs the same-deg ceiling
    // (the most it could reach as a tie-break), and vs the ±1 ceiling. A degree-primary tie-break that
    // gets a real fraction of the same-deg ceiling is the signal we're hunting.
    let ceil_sd = capt(&all, 3); // same-deg ceiling
    let ceil_d1 = capt(&all, 4); // deg±1 ceiling
    println!(
        "  ceilings: same-deg(k=0) = {ceil_sd:.1}% of full loss · deg±1 = {ceil_d1:.1}% · (a tie-break tops out at same-deg)"
    );
    println!(
        "    {:>12}   {:>10}   {:>14}   {:>12}",
        "discriminator", "vs full", "vs same-deg", "vs deg±1"
    );
    for (c, name) in CAND_NAMES.iter().enumerate().take(NCAND).skip(5) {
        let cc = capt(&all, c);
        let of_sd = if ceil_sd != 0.0 {
            100.0 * cc / ceil_sd
        } else {
            0.0
        };
        let of_d1 = if ceil_d1 != 0.0 {
            100.0 * cc / ceil_d1
        } else {
            0.0
        };
        println!("    {name:>12}   {cc:>9.1}%   {of_sd:>13.1}%   {of_d1:>11.1}%");
    }
    println!(
        "  COST: each one-ply tie-break adds an O(child_pc) reply scan per move (~a 2nd degree pass) —\n  \
         vs the current O(1) key. Promote only if `vs full` × loss_mass beats that added per-move cost."
    );
    Ok(())
}
