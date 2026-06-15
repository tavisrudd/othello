//! Calibrate Multi-ProbCut coefficients for the `strong++` engine.
//!
//! Multi-ProbCut (Buro) forward-prunes a deep node by predicting its value from a
//! cheap shallow search: `v_deep ≈ a·v_shallow + b`, with residual std `σ`. If a
//! shallow null-window search proves `v_shallow` far enough beyond the window
//! (by `t·σ`), the deep search is skipped. This harness *measures* `(a, b, σ)`.
//!
//! For a large, phase-diverse set of positions it computes the EXACT (MPC-off)
//! side-to-move PVS value at every shallow and deep depth, then regresses
//! `v_deep` on `v_shallow` per `(deep_depth, disc-count)`. Disc-count coefficients
//! are pooled over a sliding window so every phase has enough samples and the
//! curve is smooth. Values are side-to-move (negamax) units, which are
//! colour-swap invariant, so both sides pool into one consistent fit.
//!
//!     cargo run --release --example calibrate_mpc -- [positions] [seed] > /tmp/mpc.txt
//!
//! Emits a Rust table to stdout (paste into `src/mpc.rs`) and a human summary to
//! stderr. Calibrated for the `strong+` ("plus") horizon eval — the eval the
//! `strong++` engine uses — so the search/probe leaf values match.

use std::time::Instant;

use othello::search::search_strong;
use othello::{init_early_game, iter_moves, Board, TranspositionTable, BLACK, PASS};

/// (deep depth we calibrate, shallow probe depth). Shallow must stay below the
/// runtime `MPC_MIN_DEPTH` so probes never re-trigger MPC (no nesting).
const PAIRS: &[(i32, i32)] = &[(5, 1), (6, 2), (7, 3), (8, 4), (9, 4)];
/// Every distinct depth we must search per position (union of shallow + deep).
const MAX_DEPTH: i32 = 9;
/// Sliding half-window (in discs) used to pool samples for a per-disc fit.
const DISC_WINDOW: i32 = 4;
/// Below this many samples in a cell, widen to the whole-game pooled fit.
const MIN_SAMPLES: usize = 80;
/// TT for the plus eval, sized like the engine's sequential table.
const TT_BITS: u32 = 17;

struct Lcg(u64);
impl Lcg {
    fn next(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x >> 12;
        x ^= x << 25;
        x ^= x >> 27;
        self.0 = x;
        x.wrapping_mul(0x2545_F491_4F6C_DD1D)
    }
    fn frac(&mut self) -> f64 {
        (self.next() >> 11) as f64 / (1u64 << 53) as f64
    }
}

/// Generate phase-diverse, realistic-ish positions: play games with shallow
/// `strong+`-guided moves, injecting ε-random moves for diversity, and sample
/// every non-terminal position. Spans disc counts 4..~60 naturally.
fn gen_positions(n: usize, seed: u64) -> Vec<Board> {
    const EPS: f64 = 0.25;
    let mut rng = Lcg(seed.wrapping_mul(0x9E37_79B9) | 1);
    let mut guide = TranspositionTable::new(TT_BITS);
    guide.set_plus(true);
    let mut out = Vec::with_capacity(n);
    while out.len() < n {
        let mut b = init_early_game();
        // A short random opening so different games diverge immediately.
        let open = (rng.next() % 8) as usize;
        for _ in 0..open {
            if !step(&mut b, &mut rng, 1.0, &mut guide) {
                break;
            }
        }
        while !b.is_terminal() {
            if b.actions() != 0 {
                out.push(b);
                if out.len() >= n {
                    break;
                }
            }
            if !step(&mut b, &mut rng, EPS, &mut guide) {
                break;
            }
        }
    }
    out
}

/// Advance `b` one ply: ε of the time a random legal move, else a shallow
/// `strong+` choice. Returns false at a terminal state.
fn step(b: &mut Board, rng: &mut Lcg, eps: f64, tt: &mut TranspositionTable) -> bool {
    if b.is_terminal() {
        return false;
    }
    let acts = iter_moves(b.actions());
    let mv = if acts.is_empty() {
        PASS
    } else if rng.frac() < eps {
        acts[(rng.next() as usize) % acts.len()]
    } else {
        // shallow guided move (depth 4): score each child, pick black-centred best
        let mut best = acts[0];
        let mut best_v = i32::MIN;
        for &m in &acts {
            let c = b.make_move_unchecked(m);
            let bc = search_strong(c.black, c.white, c.to_move as i32, 3, tt, true);
            let v = if b.to_move == BLACK { bc } else { -bc };
            if v > best_v {
                best_v = v;
                best = m;
            }
        }
        best
    };
    *b = b.make_move_unchecked(mv);
    true
}

/// Ordinary-least-squares fit of `y = a·x + b` plus residual std `σ`.
fn fit(xy: &[(f64, f64)]) -> (f64, f64, f64) {
    let n = xy.len() as f64;
    if n < 2.0 {
        return (1.0, 0.0, 0.0);
    }
    let (mut sx, mut sy, mut sxx, mut sxy) = (0.0, 0.0, 0.0, 0.0);
    for &(x, y) in xy {
        sx += x;
        sy += y;
        sxx += x * x;
        sxy += x * y;
    }
    let denom = n * sxx - sx * sx;
    let a = if denom.abs() < 1e-9 {
        1.0
    } else {
        (n * sxy - sx * sy) / denom
    };
    let b = (sy - a * sx) / n;
    let mut sse = 0.0;
    for &(x, y) in xy {
        let e = y - (a * x + b);
        sse += e * e;
    }
    let sigma = (sse / n).sqrt();
    (a, b, sigma)
}

fn main() {
    let mut argv = std::env::args().skip(1);
    let positions: usize = argv.next().and_then(|s| s.parse().ok()).unwrap_or(1500);
    let seed: u64 = argv.next().and_then(|s| s.parse().ok()).unwrap_or(1);

    eprintln!("generating {positions} positions (plus eval, seed {seed})...");
    let t0 = Instant::now();
    let boards = gen_positions(positions, seed);
    eprintln!(
        "  {} positions in {:.1}s",
        boards.len(),
        t0.elapsed().as_secs_f64()
    );

    // Per deep-depth, collect (disc, v_shallow, v_deep) side-to-move samples.
    let mut samples: Vec<Vec<(i32, f64, f64)>> = vec![Vec::new(); PAIRS.len()];
    let t1 = Instant::now();
    let mut tt = TranspositionTable::new(TT_BITS);
    tt.set_plus(true);
    for (i, b) in boards.iter().enumerate() {
        let disc = (b.black | b.white).count_ones() as i32;
        // Exact (MPC-off) side-to-move value at every depth, fresh TT per board.
        tt.clear();
        let mut v = [0i32; (MAX_DEPTH + 1) as usize];
        for d in 1..=MAX_DEPTH {
            let bc = search_strong(b.black, b.white, b.to_move as i32, d, &mut tt, true);
            v[d as usize] = if b.to_move == BLACK { bc } else { -bc };
        }
        for (p, &(d, s)) in PAIRS.iter().enumerate() {
            samples[p].push((disc, v[s as usize] as f64, v[d as usize] as f64));
        }
        if (i + 1) % 250 == 0 {
            eprintln!("  searched {}/{}", i + 1, boards.len());
        }
    }
    eprintln!("  searches in {:.1}s", t1.elapsed().as_secs_f64());

    // Per-disc windowed fit, with a whole-game pooled fallback for sparse cells.
    println!("// AUTO-GENERATED by `cargo run --release --example calibrate_mpc`.");
    println!("// Do not edit by hand. Side-to-move (negamax) units, `strong+` eval.");
    println!("// Multi-ProbCut: v_deep ≈ a·v_shallow + b, residual std σ.");
    println!(
        "pub const MPC_PAIRS: [(i32, i32); {}] = {:?};",
        PAIRS.len(),
        PAIRS
    );
    println!("/// `[pair][disc]` -> `(a, b, σ)`; pair index matches `MPC_PAIRS`.");
    println!(
        "pub const MPC_COEFF: [[(f32, f32, f32); 64]; {}] = [",
        PAIRS.len()
    );
    for (p, &(d, s)) in PAIRS.iter().enumerate() {
        let xy_all: Vec<(f64, f64)> = samples[p].iter().map(|&(_, x, y)| (x, y)).collect();
        let (ga, gb, gs) = fit(&xy_all);
        eprintln!(
            "pair d={d} s={s}: global a={ga:.4} b={gb:.3} σ={gs:.3} (n={})",
            xy_all.len()
        );
        print!("    [");
        for disc in 0..64i32 {
            let cell: Vec<(f64, f64)> = samples[p]
                .iter()
                .filter(|&&(dc, _, _)| (dc - disc).abs() <= DISC_WINDOW)
                .map(|&(_, x, y)| (x, y))
                .collect();
            let (a, b, sg) = if cell.len() >= MIN_SAMPLES {
                fit(&cell)
            } else {
                (ga, gb, gs)
            };
            // Guard σ away from zero so a cell never cuts with no margin.
            let sg = sg.max(1.0);
            print!("({a:.4}, {b:.3}, {sg:.3}), ");
        }
        println!("],");
    }
    println!("];");
}
