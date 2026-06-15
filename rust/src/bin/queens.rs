//! Play the adversarial Non-Attacking Queens game (Noon & Van Brummelen, 2006).
//!
//! Two players alternately place a queen so no two attack each other (no shared
//! row, column, or diagonal); whoever cannot move loses. The engine plays
//! perfectly (win as fast as possible, resist as long as possible).
//!
//!   queens solve [n]            who wins the empty n×n board, with the optimal line
//!   queens self  [n]            watch the engine play the optimal line both sides
//!   queens play  [n] [1|2]      play against the engine as player 1 (first) or 2
//!
//! Default: n = 8, you are player 1. Squares are named file+rank, e.g. `d1`
//! (file A..H left→right, rank 1..n bottom→top, chess style).

use std::collections::HashMap;
use std::io::{self, Write};

use othello::queens::{Outcome, Queens};

fn main() {
    let mut args = std::env::args().skip(1);
    let mode = args.next().unwrap_or_else(|| "solve".into());
    let n: u32 = args.next().and_then(|s| s.parse().ok()).unwrap_or(8);
    if !(1..=8).contains(&n) {
        eprintln!("board side must be 1..=8 (an n×n board must fit in 64 bits)");
        std::process::exit(2);
    }
    let q = Queens::new(n);

    match mode.as_str() {
        "solve" => solve(&q),
        "self" => self_play(&q),
        "play" => {
            let human: u32 = args.next().and_then(|s| s.parse().ok()).unwrap_or(1);
            play(&q, human == 1);
        }
        other => {
            eprintln!("unknown mode {other:?}; use: solve | self | play");
            std::process::exit(2);
        }
    }
}

/// Square name like `d1`: file letter (column) + rank number (row, 1-based).
fn name(q: &Queens, sq: u32) -> String {
    let c = sq % q.n;
    let r = sq / q.n;
    format!("{}{}", (b'A' + c as u8) as char, r + 1)
}

/// Parse a square name (`d1`, case-insensitive) into a square index, validated
/// against the board size.
fn parse(q: &Queens, s: &str) -> Option<u32> {
    let s = s.trim();
    let mut ch = s.chars();
    let file = ch.next()?.to_ascii_uppercase();
    let rank: u32 = ch.as_str().parse().ok()?;
    if !file.is_ascii_alphabetic() || rank < 1 {
        return None;
    }
    let c = (file as u8 - b'A') as u32;
    let r = rank - 1;
    if c >= q.n || r >= q.n {
        return None;
    }
    Some(q.square(r, c))
}

/// Render the board: `Q` = queen, dim `·` = attacked (illegal), `.` = available.
fn render(q: &Queens, queens: u64, blocked: u64) {
    for r in (0..q.n).rev() {
        print!("{:>2} ", r + 1);
        for c in 0..q.n {
            let bit = 1u64 << q.square(r, c);
            if queens & bit != 0 {
                print!(" \x1b[1;93mQ\x1b[0m");
            } else if blocked & bit != 0 {
                print!(" \x1b[90m·\x1b[0m");
            } else {
                print!(" \x1b[92m.\x1b[0m");
            }
        }
        println!();
    }
    print!("   ");
    for c in 0..q.n {
        print!(" {}", (b'A' + c as u8) as char);
    }
    println!();
}

/// "first" / "second" for a 0-based player index.
fn who(p: u32) -> &'static str {
    if p.is_multiple_of(2) {
        "first"
    } else {
        "second"
    }
}

fn solve(q: &Queens) {
    let mut memo = HashMap::new();
    let root = q.solve(0, &mut memo);
    let pv = q.principal_variation();
    let winner = if root.win { "first" } else { "second" };
    println!(
        "On the {n}×{n} board the {winner} player wins with perfect play \
         (game lasts {} move{}).",
        root.plies,
        if root.plies == 1 { "" } else { "s" },
        n = q.n,
    );
    let names: Vec<String> = pv.iter().map(|&s| name(q, s)).collect();
    println!("Principal variation: {}", names.join("  "));
    println!("(explored {} distinct positions)", memo.len());

    // Final board of the optimal line.
    let mut queens = 0u64;
    let mut blocked = 0u64;
    for &sq in &pv {
        queens |= 1u64 << sq;
        blocked = q.place(blocked, sq);
    }
    println!();
    render(q, queens, blocked);
}

fn self_play(q: &Queens) {
    let mut memo = HashMap::new();
    let mut queens = 0u64;
    let mut blocked = 0u64;
    let mut ply = 0u32;
    println!("Optimal self-play on the {n}×{n} board:\n", n = q.n);
    render(q, queens, blocked);
    while let Some((sq, o)) = q.best_move(blocked, &mut memo) {
        queens |= 1u64 << sq;
        blocked = q.place(blocked, sq);
        println!(
            "\nmove {}: {} player plays {}  ({})",
            ply + 1,
            who(ply),
            name(q, sq),
            assess(o),
        );
        render(q, queens, blocked);
        ply += 1;
    }
    println!(
        "\nNo moves left: the {} player cannot move and loses. \
         The {} player wins after {ply} moves.",
        who(ply),
        who(ply + 1),
    );
}

fn play(q: &Queens, human_first: bool) {
    let mut memo = HashMap::new();
    let mut queens = 0u64;
    let mut blocked = 0u64;
    let mut ply = 0u32;
    println!(
        "Non-Attacking Queens on {n}×{n}. You are the {} player. \
         Enter moves like `d1` (or `quit`).\n",
        if human_first { "first" } else { "second" },
        n = q.n,
    );

    loop {
        render(q, queens, blocked);
        if q.available(blocked) == 0 {
            // The player to move at `ply` cannot move and loses.
            let loser_is_human = ply.is_multiple_of(2) == human_first;
            println!(
                "\nNo legal moves: the {} player ({}) loses. {} after {ply} moves.",
                who(ply),
                if loser_is_human { "you" } else { "engine" },
                if loser_is_human {
                    "Engine wins"
                } else {
                    "You win"
                },
            );
            return;
        }
        let human_turn = ply.is_multiple_of(2) == human_first;
        let sq = if human_turn {
            match read_move(q, blocked) {
                Some(sq) => sq,
                None => return, // quit / EOF
            }
        } else {
            let (sq, o) = q.best_move(blocked, &mut memo).unwrap();
            println!("\nEngine plays {}  ({}).", name(q, sq), assess(o));
            sq
        };
        queens |= 1u64 << sq;
        blocked = q.place(blocked, sq);
        ply += 1;
        println!();
    }
}

/// Prompt the human for a legal move; `None` on quit/EOF.
fn read_move(q: &Queens, blocked: u64) -> Option<u32> {
    loop {
        print!("\nyour move> ");
        io::stdout().flush().ok();
        let mut line = String::new();
        if io::stdin().read_line(&mut line).ok()? == 0 {
            return None; // EOF
        }
        let s = line.trim();
        if s.eq_ignore_ascii_case("quit") || s.eq_ignore_ascii_case("q") {
            return None;
        }
        match parse(q, s) {
            Some(sq) if q.available(blocked) & (1u64 << sq) != 0 => return Some(sq),
            Some(_) => println!("That square is occupied or attacked. Try again."),
            None => println!("Bad square. Use file+rank like `d1`."),
        }
    }
}

/// Engine self-assessment of the move it just chose, from its own perspective.
fn assess(o: Outcome) -> String {
    if o.win {
        format!("winning; mate in {}", o.plies)
    } else {
        format!("losing; holds out {} more", o.plies)
    }
}
