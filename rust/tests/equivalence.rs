//! Equivalence tests: the Rust port must satisfy the same invariants as the
//! Python suite -- move-gen/flips against an independent grid reference, exact
//! endgame-solve values, and value-for-value agreement across all engines.

use othello::core::{flips_for_move, legal_moves};
use othello::engines::{AlphaBeta, Minimax, Strong};
use othello::game::Engine;
use othello::{
    best_by_side, format_score, format_square, init_early_game, init_near_terminal_game_black_win,
    init_near_terminal_game_either_can_win, init_near_terminal_game_white_win, iter_moves,
    move_to_square, parse_board, parse_square_name, square_to_move, winner, Board, BLACK, WHITE,
};

// --------------------------------------------------------------------------- //
// Independent grid-arithmetic reference (no bitboards)
// --------------------------------------------------------------------------- //

const DIRS: [(i32, i32); 8] = [
    (-1, -1),
    (-1, 0),
    (-1, 1),
    (0, -1),
    (0, 1),
    (1, -1),
    (1, 0),
    (1, 1),
];

fn grid(bm: u64) -> std::collections::HashSet<(i32, i32)> {
    (0..64)
        .filter(|s| (bm >> s) & 1 == 1)
        .map(|s| (s / 8, s % 8))
        .collect()
}

fn ref_legal(player: u64, opp: u64) -> std::collections::HashSet<(i32, i32)> {
    let p = grid(player);
    let o = grid(opp);
    let mut moves = std::collections::HashSet::new();
    for r in 0..8 {
        for c in 0..8 {
            if p.contains(&(r, c)) || o.contains(&(r, c)) {
                continue;
            }
            for (dr, dc) in DIRS {
                let (mut rr, mut cc, mut seen) = (r + dr, c + dc, 0);
                while (0..8).contains(&rr) && (0..8).contains(&cc) && o.contains(&(rr, cc)) {
                    rr += dr;
                    cc += dc;
                    seen += 1;
                }
                if seen > 0 && (0..8).contains(&rr) && (0..8).contains(&cc) && p.contains(&(rr, cc))
                {
                    moves.insert((r, c));
                    break;
                }
            }
        }
    }
    moves
}

fn ref_flips(sq: i32, player: u64, opp: u64) -> std::collections::HashSet<(i32, i32)> {
    let (r, c) = (sq / 8, sq % 8);
    let p = grid(player);
    let o = grid(opp);
    let mut flips = std::collections::HashSet::new();
    for (dr, dc) in DIRS {
        let (mut rr, mut cc) = (r + dr, c + dc);
        let mut run = Vec::new();
        while (0..8).contains(&rr) && (0..8).contains(&cc) && o.contains(&(rr, cc)) {
            run.push((rr, cc));
            rr += dr;
            cc += dc;
        }
        if !run.is_empty() && (0..8).contains(&rr) && (0..8).contains(&cc) && p.contains(&(rr, cc))
        {
            flips.extend(run);
        }
    }
    flips
}

/// A tiny deterministic LCG so we don't pull in `rand`.
struct Lcg(u64);
impl Lcg {
    fn next_u64(&mut self) -> u64 {
        // xorshift64*
        let mut x = self.0;
        x ^= x >> 12;
        x ^= x << 25;
        x ^= x >> 27;
        self.0 = x;
        x.wrapping_mul(0x2545_F491_4F6C_DD1D)
    }
}

/// Every position reached by `games` random self-play games from the opening.
fn random_positions(games: usize, seed: u64, mut f: impl FnMut(&Board)) {
    let mut rng = Lcg(seed);
    for _ in 0..games {
        let mut b = init_early_game();
        loop {
            f(&b);
            if b.is_terminal() {
                break;
            }
            let acts = iter_moves(b.actions());
            let mv = if acts.is_empty() {
                othello::PASS
            } else {
                acts[(rng.next_u64() as usize) % acts.len()]
            };
            b = b.make_move(mv).unwrap();
        }
    }
}

// --------------------------------------------------------------------------- //
// Coordinates
// --------------------------------------------------------------------------- //

#[test]
fn square_roundtrip() {
    for sq in 0..64 {
        assert_eq!(parse_square_name(&format_square(sq)).unwrap(), sq);
        assert_eq!(move_to_square(1 << sq), sq);
    }
}

#[test]
fn square_names() {
    for (name, sq) in [("A1", 0), ("H1", 7), ("A8", 56), ("H8", 63), ("D5", 35)] {
        assert_eq!(parse_square_name(name).unwrap(), sq);
        assert_eq!(format_square(sq), name);
    }
}

#[test]
fn format_score_winner_prefix() {
    assert_eq!(format_score(6), "B:+6");
    assert_eq!(format_score(1), "B:+1");
    assert_eq!(format_score(-4), "W:-4");
    assert_eq!(format_score(-40), "W:-40");
    assert_eq!(format_score(0), "T:0");
}

// --------------------------------------------------------------------------- //
// Opening / move application
// --------------------------------------------------------------------------- //

#[test]
fn opening_legal_moves() {
    let b = init_early_game();
    assert_eq!(b.to_move, BLACK);
    let names: std::collections::HashSet<String> = iter_moves(b.actions())
        .iter()
        .map(|&m| othello::format_move(m))
        .collect();
    let expected: std::collections::HashSet<String> = ["C4", "D3", "E6", "F5"]
        .iter()
        .map(|s| s.to_string())
        .collect();
    assert_eq!(names, expected);
}

#[test]
fn make_move_flips_and_turn() {
    let b = init_early_game();
    let nb = b.play("D3").unwrap();
    assert_eq!(nb.to_move, WHITE);
    assert_eq!(nb.black.count_ones(), 4);
    assert_eq!(nb.white.count_ones(), 1);
    assert!(nb.black & square_to_move("D4").unwrap() != 0);
    assert!(nb.white & square_to_move("D4").unwrap() == 0);
    assert_eq!(nb.black & nb.white, 0);
}

#[test]
fn make_move_unchecked_matches_make_move() {
    let mut n = 0;
    random_positions(60, 1, |b| {
        if b.is_terminal() {
            return;
        }
        for m in iter_moves(b.actions()) {
            assert_eq!(b.make_move(m).unwrap(), b.make_move_unchecked(m));
            n += 1;
        }
    });
    assert!(n > 1000, "only {n} moves sampled");
}

// --------------------------------------------------------------------------- //
// Reference equivalence: legal moves + flips
// --------------------------------------------------------------------------- //

#[test]
fn legal_moves_and_flips_match_reference_on_games() {
    let mut n = 0;
    random_positions(80, 3, |b| {
        let (player, opp) = if b.to_move == BLACK {
            (b.black, b.white)
        } else {
            (b.white, b.black)
        };
        assert_eq!(grid(b.actions()), ref_legal(player, opp));
        for sq in 0..64 {
            if (b.actions() >> sq) & 1 == 1 {
                assert_eq!(
                    grid(flips_for_move(1 << sq, player, opp)),
                    ref_flips(sq, player, opp)
                );
            }
        }
        n += 1;
    });
    assert!(n > 1000);
}

#[test]
fn movegen_matches_reference_on_random_boards() {
    let mut rng = Lcg(99);
    for _ in 0..1500 {
        let player = rng.next_u64();
        let opp = rng.next_u64() & !player;
        let legal = legal_moves(player, opp);
        assert_eq!(grid(legal), ref_legal(player, opp));
        for sq in 0..64 {
            if (legal >> sq) & 1 == 1 {
                assert_eq!(
                    grid(flips_for_move(1 << sq, player, opp)),
                    ref_flips(sq, player, opp)
                );
            }
        }
    }
}

#[test]
fn flips_outflank_match_walk_on_random_boards() {
    use othello::core::{flips_for_move, flips_outflank};
    let mut rng = Lcg(0xABCD);
    for _ in 0..3000 {
        let player = rng.next_u64();
        let opp = rng.next_u64() & !player;
        let mut empties = !(player | opp); // every possible move square
        while empties != 0 {
            let mv = empties & empties.wrapping_neg();
            empties ^= mv;
            assert_eq!(
                flips_outflank(mv, player, opp),
                flips_for_move(mv, player, opp),
                "mv={mv:#x} p={player:#x} o={opp:#x}"
            );
        }
    }
}

// --------------------------------------------------------------------------- //
// Brute-force oracle + engine equivalence
// --------------------------------------------------------------------------- //

fn nocache_value(board: &Board, depth: Option<i32>) -> i32 {
    if matches!(depth, Some(d) if d <= 0) {
        return othello::heuristic(board, BLACK);
    }
    if board.is_terminal() {
        return othello::utility(board, BLACK);
    }
    let child = depth.map(|d| d - 1);
    let acts = iter_moves(board.actions());
    let children: Vec<Board> = if acts.is_empty() {
        vec![board.make_move_unchecked(othello::PASS)]
    } else {
        acts.iter().map(|&m| board.make_move_unchecked(m)).collect()
    };
    let vals = children.iter().map(|c| nocache_value(c, child));
    if board.to_move == BLACK {
        vals.max().unwrap()
    } else {
        vals.min().unwrap()
    }
}

fn engines() -> Vec<Box<dyn Engine>> {
    vec![
        Box::new(Minimax::new()),
        Box::new(AlphaBeta::plain()),
        Box::new(AlphaBeta::ordered()),
        Box::new(Strong::new()),
    ]
}

#[test]
fn full_search_values() {
    let cases = [
        (init_near_terminal_game_black_win as fn() -> Board, 6),
        (init_near_terminal_game_white_win as fn() -> Board, -40),
        (init_near_terminal_game_either_can_win as fn() -> Board, 4),
    ];
    for (init, expected) in cases {
        let b = init();
        for mut e in engines() {
            assert_eq!(e.value(&b, None), expected, "{} on {:?}", e.name(), b);
        }
    }
}

#[test]
fn value_matches_nocache_endgame_all_depths() {
    let fixtures = [
        init_near_terminal_game_black_win as fn() -> Board,
        init_near_terminal_game_white_win,
        init_near_terminal_game_either_can_win,
    ];
    for init in fixtures {
        let b = init();
        for depth in [None, Some(0), Some(1), Some(2), Some(3), Some(4), Some(6)] {
            let oracle = nocache_value(&b, depth);
            for mut e in engines() {
                assert_eq!(e.value(&b, depth), oracle, "{} depth {:?}", e.name(), depth);
            }
        }
    }
}

#[test]
fn value_matches_nocache_midgame_finite_depths() {
    let b = init_early_game().play("D3").unwrap().play("C3").unwrap();
    for depth in [Some(0), Some(1), Some(2), Some(3), Some(4)] {
        let oracle = nocache_value(&b, depth);
        for mut e in engines() {
            assert_eq!(e.value(&b, depth), oracle, "{} depth {:?}", e.name(), depth);
        }
    }
}

#[test]
fn engine_cache_is_depth_isolated() {
    let b = init_early_game().play("D3").unwrap();
    for mut e in engines() {
        for depth in [Some(2), Some(4), Some(1), Some(3), Some(2), Some(4)] {
            assert_eq!(e.value(&b, depth), nocache_value(&b, depth), "{}", e.name());
        }
    }
}

#[test]
fn best_move_is_extreme_for_side_to_move() {
    let fixtures = [
        init_near_terminal_game_black_win as fn() -> Board,
        init_near_terminal_game_white_win,
        init_near_terminal_game_either_can_win,
    ];
    for init in fixtures {
        let b = init();
        for mut e in engines() {
            let scored = e.scores(&b, e.default_depth()).unwrap();
            let best = e.best_move(&b, e.default_depth()).unwrap();
            let best_score = scored.iter().find(|(m, _)| *m == best).unwrap().1;
            let extreme = if b.to_move == BLACK {
                scored.iter().map(|x| x.1).max().unwrap()
            } else {
                scored.iter().map(|x| x.1).min().unwrap()
            };
            assert_eq!(best_score, extreme, "{}", e.name());
            assert_eq!(best, best_by_side(&b, &scored));
        }
    }
}

#[test]
fn strong_fast_best_move_matches_exact_scores() {
    // The single-rooted PVS best_move must pick the identical move as
    // best_by_side over the exact per-move scores, at every depth, on a spread
    // of real positions (this is the tie-break correctness guarantee).
    let mut n = 0;
    random_positions(40, 17, |b| {
        if b.is_terminal() {
            return;
        }
        for depth in [Some(1), Some(2), Some(3), Some(4), Some(5), Some(6)] {
            let fast = Strong::new().best_move(b, depth).unwrap();
            let mut s = Strong::new();
            let exact = best_by_side(b, &s.scores(b, depth).unwrap());
            assert_eq!(fast, exact, "depth {:?} on {:?}", depth, b);
            n += 1;
        }
    });
    assert!(n > 500, "only {n} checks");
}

#[test]
fn engine_on_terminal_errors() {
    let mut driver = Strong::new();
    let mut b = init_near_terminal_game_white_win();
    while !b.is_terminal() {
        b = b.make_move(driver.best_move(&b, Some(4)).unwrap()).unwrap();
    }
    for mut e in engines() {
        assert!(e.best_move(&b, None).is_err(), "{}", e.name());
        assert!(e.scores(&b, None).is_err(), "{}", e.name());
    }
}

// --------------------------------------------------------------------------- //
// Utility / winner / parsing
// --------------------------------------------------------------------------- //

#[test]
fn utility_sign_at_terminal() {
    random_positions(120, 5, |b| {
        if !b.is_terminal() {
            return;
        }
        let u = othello::utility(b, BLACK);
        let w = winner(b);
        assert_eq!(u > 0, w == Some(BLACK));
        assert_eq!(u < 0, w == Some(WHITE));
        assert_eq!(u == 0, w.is_none());
        assert_eq!(
            u.unsigned_abs(),
            (b.black.count_ones() as i32 - b.white.count_ones() as i32).unsigned_abs()
        );
    });
}

#[test]
fn parse_board_round_trips_opening() {
    let grid = "........\n........\n........\n...BW...\n...WB...\n........\n........\n........";
    assert_eq!(parse_board(grid, BLACK).unwrap(), init_early_game());
}

#[test]
fn parse_board_to_move_directive() {
    let empty = "........\n".repeat(8);
    assert_eq!(parse_board(&empty, BLACK).unwrap().to_move, BLACK);
    assert_eq!(parse_board(&empty, WHITE).unwrap().to_move, WHITE);
    assert_eq!(
        parse_board(&format!("{empty}\nto_move: white"), BLACK)
            .unwrap()
            .to_move,
        WHITE
    );
}

#[test]
fn parse_board_rejects_malformed() {
    assert!(parse_board(&"........\n".repeat(7), BLACK).is_err()); // 7 rows
    assert!(parse_board(&".......\n".repeat(8), BLACK).is_err()); // 7 cols
    let bad = format!("Z{}\n{}", ".".repeat(7), "........\n".repeat(7));
    assert!(parse_board(&bad, BLACK).is_err()); // unknown cell
}
