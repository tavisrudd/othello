//! Othello game core: board state, rules, move generation, coordinates.
//!
//! A faithful Rust port of `othello/core.py`. No search/AI here -- see
//! `engines` for the search and `eval` for scoring. Square *i* is bit *i*;
//! file A..H = bits 0..7 within a rank, rank 1..8 = the eight bytes.
//!
//! Unlike the Python `int` bitboards, `u64` wraps natively, so the explicit
//! `& FULL` the Python kernels carry is implicit here.

pub type Player = u8;
pub type Bitmap = u64;
pub type Moves = u64;
pub type Move = u64;
pub type Square = u32;
pub type Score = i32;

pub const BLACK: Player = 0;
pub const WHITE: Player = 1;

pub const PASS: Move = 0;
pub const MIN_SCORE: Score = -1_000_000_000;
pub const MAX_SCORE: Score = 1_000_000_000;

pub const FULL: u64 = 0xFFFF_FFFF_FFFF_FFFF;

const NOT_A_FILE: u64 = 0xFEFE_FEFE_FEFE_FEFE; // no file A (rightward rays)
const NOT_H_FILE: u64 = 0x7F7F_7F7F_7F7F_7F7F; // no file H (leftward rays)

// --------------------------------------------------------------------------- //
// Coordinates
// --------------------------------------------------------------------------- //

pub fn parse_square_name(sq: &str) -> Result<Square, String> {
    let bytes = sq.as_bytes();
    if bytes.len() != 2 {
        return Err(format!("invalid square: {:?}", sq));
    }
    let file = (bytes[0] as char).to_ascii_uppercase();
    let rank = bytes[1] as char;
    if !('A'..='H').contains(&file) {
        return Err(format!("invalid file: {:?}", file));
    }
    if !('1'..='8').contains(&rank) {
        return Err(format!("invalid rank: {:?}", rank));
    }
    Ok((rank as u32 - '1' as u32) * 8 + (file as u32 - 'A' as u32))
}

pub fn format_square(square: Square) -> String {
    debug_assert!(square < 64, "invalid square index: {square}");
    let file = (b'A' + (square % 8) as u8) as char;
    let rank = square / 8 + 1;
    format!("{file}{rank}")
}

pub fn square_to_move(name: &str) -> Result<Move, String> {
    Ok(1u64 << parse_square_name(name)?)
}

/// Highest set bit index (`bit_length() - 1`); for a one-hot move this is the
/// square index.
pub fn move_to_square(mv: Move) -> Square {
    63 - mv.leading_zeros()
}

pub fn format_move(mv: Move) -> String {
    format_square(move_to_square(mv))
}

pub fn parse_move(spec: &str) -> Result<Move, String> {
    let s = spec.trim().to_ascii_uppercase();
    if s == "PASS" {
        return Ok(PASS);
    }
    square_to_move(&s)
}

// --------------------------------------------------------------------------- //
// Board
// --------------------------------------------------------------------------- //

#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug)]
pub struct Board {
    pub black: u64,
    pub white: u64,
    pub to_move: Player,
}

impl Board {
    #[inline]
    pub fn new(black: u64, white: u64, to_move: Player) -> Self {
        Board {
            black,
            white,
            to_move,
        }
    }

    #[inline]
    pub fn occupied(&self) -> u64 {
        self.black | self.white
    }

    #[inline]
    pub fn empty(&self) -> u64 {
        !self.occupied()
    }

    #[inline]
    pub fn is_terminal(&self) -> bool {
        legal_moves(self.black, self.white) == 0 && legal_moves(self.white, self.black) == 0
    }

    #[inline]
    pub fn actions(&self) -> Moves {
        let (player, opp) = self.player_opponent();
        legal_moves(player, opp)
    }

    #[inline]
    fn player_opponent(&self) -> (u64, u64) {
        if self.to_move == BLACK {
            (self.black, self.white)
        } else {
            (self.white, self.black)
        }
    }

    /// Validated move application (mirrors `Board.make_move`).
    pub fn make_move(&self, mv: Move) -> Result<Board, String> {
        if mv == PASS {
            if self.actions() != 0 {
                return Err("cannot pass when legal moves exist".into());
            }
            if self.is_terminal() {
                return Err("cannot pass from terminal state".into());
            }
        } else {
            if mv & mv.wrapping_sub(1) != 0 {
                return Err(format!("move is not one-hot: {mv:#x}"));
            }
            if mv & self.actions() == 0 {
                return Err(format!("illegal move: {mv:#x}"));
            }
        }
        Ok(self.make_move_unchecked(mv))
    }

    /// Apply `mv` without validating legality. `mv` must be PASS or a legal
    /// one-hot move; the search guarantees this, so this skips the `actions()`
    /// recompute that `make_move` pays per child.
    #[inline]
    pub fn make_move_unchecked(&self, mv: Move) -> Board {
        debug_assert!(self.black & self.white == 0, "black/white discs overlap");
        debug_assert!(
            mv == PASS || mv.is_power_of_two(),
            "move is not one-hot: {mv:#x}"
        );
        if mv == PASS {
            return Board {
                black: self.black,
                white: self.white,
                to_move: self.to_move ^ 1,
            };
        }
        if self.to_move == BLACK {
            let flips = flips_for_move(mv, self.black, self.white);
            Board {
                black: self.black | mv | flips,
                white: self.white & !flips,
                to_move: WHITE,
            }
        } else {
            let flips = flips_for_move(mv, self.white, self.black);
            Board {
                black: self.black & !flips,
                white: self.white | mv | flips,
                to_move: BLACK,
            }
        }
    }

    /// Shorthand: parse + play (mirrors `Board.play`).
    pub fn play(&self, spec: &str) -> Result<Board, String> {
        self.make_move(parse_move(spec)?)
    }
}

// --------------------------------------------------------------------------- //
// Bitboard kernels (ports of the Cython _bitboard / _search inner kernels)
// --------------------------------------------------------------------------- //

/// Kogge-Stone parallel-prefix occluded fill per ray (3 shift-doubling steps).
/// `g & opponent` drops the seed, so a move needs a run >= 1 disc.
#[inline]
pub fn legal_moves(player: u64, opponent: u64) -> u64 {
    let empty = !(player | opponent);
    let mut moves: u64 = 0;
    let (mut g, mut p);

    g = player;
    p = opponent; // north
    g |= p & (g << 8);
    p &= p << 8;
    g |= p & (g << 16);
    p &= p << 16;
    g |= p & (g << 32);
    moves |= ((g & opponent) << 8) & empty;

    g = player;
    p = opponent; // south
    g |= p & (g >> 8);
    p &= p >> 8;
    g |= p & (g >> 16);
    p &= p >> 16;
    g |= p & (g >> 32);
    moves |= ((g & opponent) >> 8) & empty;

    let ep = opponent & NOT_A_FILE; // rightward (mask file A)
    g = player;
    p = ep; // east
    g |= p & (g << 1);
    p &= p << 1;
    g |= p & (g << 2);
    p &= p << 2;
    g |= p & (g << 4);
    moves |= (((g & opponent) << 1) & NOT_A_FILE) & empty;

    g = player;
    p = ep; // northeast
    g |= p & (g << 9);
    p &= p << 9;
    g |= p & (g << 18);
    p &= p << 18;
    g |= p & (g << 36);
    moves |= (((g & opponent) << 9) & NOT_A_FILE) & empty;

    g = player;
    p = ep; // southeast
    g |= p & (g >> 7);
    p &= p >> 7;
    g |= p & (g >> 14);
    p &= p >> 14;
    g |= p & (g >> 28);
    moves |= (((g & opponent) >> 7) & NOT_A_FILE) & empty;

    let wp = opponent & NOT_H_FILE; // leftward (mask file H)
    g = player;
    p = wp; // west
    g |= p & (g >> 1);
    p &= p >> 1;
    g |= p & (g >> 2);
    p &= p >> 2;
    g |= p & (g >> 4);
    moves |= (((g & opponent) >> 1) & NOT_H_FILE) & empty;

    g = player;
    p = wp; // northwest
    g |= p & (g << 7);
    p &= p << 7;
    g |= p & (g << 14);
    p &= p << 14;
    g |= p & (g << 28);
    moves |= (((g & opponent) << 7) & NOT_H_FILE) & empty;

    g = player;
    p = wp; // southwest
    g |= p & (g >> 9);
    p &= p >> 9;
    g |= p & (g >> 18);
    p &= p >> 18;
    g |= p & (g >> 36);
    moves |= (((g & opponent) >> 9) & NOT_H_FILE) & empty;

    moves
}

/// Per ray: walk the contiguous opponent run from `mv`; if it ends on one of
/// ours, capture it. The `while` loop early-exits as soon as a run ends -- and
/// because real flip runs are short, this beats the branchless `flips_outflank`
/// below in actual self-play (see its note). The production flip.
#[inline]
pub fn flips_for_move(mv: Move, player: u64, opponent: u64) -> u64 {
    let mut flips: u64 = 0;
    let (mut x, mut cap);

    x = (mv & NOT_H_FILE) << 1;
    cap = 0; // east
    while x & opponent != 0 {
        cap |= x;
        x = (x & NOT_H_FILE) << 1;
    }
    if x & player != 0 {
        flips |= cap;
    }

    x = (mv & NOT_A_FILE) >> 1;
    cap = 0; // west
    while x & opponent != 0 {
        cap |= x;
        x = (x & NOT_A_FILE) >> 1;
    }
    if x & player != 0 {
        flips |= cap;
    }

    x = mv << 8;
    cap = 0; // north
    while x & opponent != 0 {
        cap |= x;
        x <<= 8;
    }
    if x & player != 0 {
        flips |= cap;
    }

    x = mv >> 8;
    cap = 0; // south
    while x & opponent != 0 {
        cap |= x;
        x >>= 8;
    }
    if x & player != 0 {
        flips |= cap;
    }

    x = (mv & NOT_H_FILE) << 9;
    cap = 0; // northeast
    while x & opponent != 0 {
        cap |= x;
        x = (x & NOT_H_FILE) << 9;
    }
    if x & player != 0 {
        flips |= cap;
    }

    x = (mv & NOT_A_FILE) << 7;
    cap = 0; // northwest
    while x & opponent != 0 {
        cap |= x;
        x = (x & NOT_A_FILE) << 7;
    }
    if x & player != 0 {
        flips |= cap;
    }

    x = (mv & NOT_H_FILE) >> 7;
    cap = 0; // southeast
    while x & opponent != 0 {
        cap |= x;
        x = (x & NOT_H_FILE) >> 7;
    }
    if x & player != 0 {
        flips |= cap;
    }

    x = (mv & NOT_A_FILE) >> 9;
    cap = 0; // southwest
    while x & opponent != 0 {
        cap |= x;
        x = (x & NOT_A_FILE) >> 9;
    }
    if x & player != 0 {
        flips |= cap;
    }

    flips
}

// --------------------------------------------------------------------------- //
// Nearest-blocker ("outflank") flips -- a documented experiment, NOT used by the
// search (the walk above is faster in real games; see the note on the function).
//
// For each of the eight rays from the move square, the flipped run is the
// opponent discs between the move and the *nearest blocker* (a player disc or an
// empty square): if that blocker is a player disc, capture the run. Per ray we
// precompute the ray mask (`RAY[sq][dir]`); the nearest blocker is one BMI op
// (`blsi` for increasing rays, an MSB isolate for decreasing ones), and the run
// is `mask & (nearest - 1)` (or its high-side mirror) -- O(1) and branchless.

const RAY_DR: [i32; 8] = [0, 0, 1, -1, 1, 1, -1, -1];
const RAY_DC: [i32; 8] = [1, -1, 0, 0, 1, -1, 1, -1];
const INC_DIRS: [usize; 4] = [0, 2, 4, 5]; // E, N, NE, NW  (increasing bit index)
const DEC_DIRS: [usize; 4] = [1, 3, 6, 7]; // W, S, SE, SW  (decreasing bit index)

const fn build_rays() -> [[u64; 8]; 64] {
    let mut rays = [[0u64; 8]; 64];
    let mut sq = 0usize;
    while sq < 64 {
        let r = (sq / 8) as i32;
        let c = (sq % 8) as i32;
        let mut d = 0usize;
        while d < 8 {
            let mut rr = r + RAY_DR[d];
            let mut cc = c + RAY_DC[d];
            let mut mask = 0u64;
            while rr >= 0 && rr < 8 && cc >= 0 && cc < 8 {
                mask |= 1u64 << (rr * 8 + cc);
                rr += RAY_DR[d];
                cc += RAY_DC[d];
            }
            rays[sq][d] = mask;
            d += 1;
        }
        sq += 1;
    }
    rays
}

static RAY: [[u64; 8]; 64] = build_rays();

/// Isolate the highest set bit (0 if `x == 0`), branchless.
#[inline]
fn highest_bit(mut x: u64) -> u64 {
    x |= x >> 1;
    x |= x >> 2;
    x |= x >> 4;
    x |= x >> 8;
    x |= x >> 16;
    x |= x >> 32;
    x - (x >> 1)
}

/// Branchless nearest-blocker flips. ~5x the walk on a *random-board* microbench,
/// but ~4% SLOWER in real self-play: flip runs are short, so the walk early-exits
/// in 1-2 predictable steps with no table load, while this pays fixed work + a
/// `RAY[sq]` load every call. Kept as a documented experiment (`make bench-flips`);
/// the production flip is `flips_for_move`. Bit-identical to it (asserted in tests).
#[inline]
pub fn flips_outflank(mv: Move, player: u64, opponent: u64) -> u64 {
    debug_assert!(
        mv != 0 && mv.is_power_of_two(),
        "move is not one-hot: {mv:#x}"
    );
    let sq = mv.trailing_zeros() as usize;
    // SAFETY: sq < 64 (mv is a single bit within the board).
    let rays = unsafe { RAY.get_unchecked(sq) };
    let blockers = player | !(player | opponent); // player discs OR empty squares
    let mut flips = 0u64;

    let mut k = 0;
    while k < 4 {
        let mask = rays[INC_DIRS[k]];
        let b = blockers & mask;
        let nearest = b & b.wrapping_neg(); // lowest blocker, 0 if none
        let run = mask & nearest.wrapping_sub(1); // ray cells between mv and nearest
        let hit = 0u64.wrapping_sub(((nearest & player) != 0) as u64); // all-ones iff player
        flips |= run & hit;
        k += 1;
    }
    let mut k = 0;
    while k < 4 {
        let mask = rays[DEC_DIRS[k]];
        let b = blockers & mask;
        let nearest = highest_bit(b); // highest blocker, 0 if none
        let run = mask & !(nearest << 1).wrapping_sub(1); // cells above nearest, below mv
        let hit = 0u64.wrapping_sub(((nearest & player) != 0) as u64);
        flips |= run & hit;
        k += 1;
    }
    flips
}

// --------------------------------------------------------------------------- //
// Parsing / winner
// --------------------------------------------------------------------------- //

const BLACK_CHARS: &str = "BX*";
const WHITE_CHARS: &str = "WO";
const EMPTY_CHARS: &str = ".-_";

/// Parse an 8x8 text grid into a Board. Rows run top (rank 8) to bottom
/// (rank 1); columns A..H left to right. Mirrors `core.parse_board`.
pub fn parse_board(text: &str, to_move: Player) -> Result<Board, String> {
    let mut black: u64 = 0;
    let mut white: u64 = 0;
    let mut rows: Vec<String> = Vec::new();
    let mut side: Option<Player> = None;

    for raw in text.lines() {
        let line = raw.trim();
        if line.is_empty() || line.starts_with('#') {
            continue;
        }
        let low = line.to_ascii_lowercase();
        if low.starts_with("to_move") || low.starts_with("to-move") {
            // Match Python's `low.split(":",1)[-1].strip() or low.split()[-1]`.
            let last = low.splitn(2, ':').last().unwrap_or("").trim();
            let value = if !last.is_empty() {
                last.to_string()
            } else {
                low.split_whitespace().last().unwrap_or("").to_string()
            };
            side = Some(if value.starts_with('w') { WHITE } else { BLACK });
            continue;
        }
        rows.push(line.replace(' ', ""));
    }

    if rows.len() != 8 {
        return Err(format!("board needs 8 grid rows, got {}", rows.len()));
    }
    for (i, row) in rows.iter().enumerate() {
        let cells: Vec<char> = row.chars().collect();
        if cells.len() != 8 {
            return Err(format!("row {} must have 8 cells, got {:?}", i + 1, row));
        }
        let rank = 7 - i; // top row is rank 8
        for (c, &ch) in cells.iter().enumerate() {
            let bit = 1u64 << (rank * 8 + c);
            let upper = ch.to_ascii_uppercase();
            if BLACK_CHARS.contains(upper) {
                black |= bit;
            } else if WHITE_CHARS.contains(upper) {
                white |= bit;
            } else if !EMPTY_CHARS.contains(upper) {
                return Err(format!("bad cell {:?} at row {}, col {}", ch, i + 1, c + 1));
            }
        }
    }
    Ok(Board {
        black,
        white,
        to_move: side.unwrap_or(to_move),
    })
}

pub fn winner(board: &Board) -> Option<Player> {
    let black = board.black.count_ones();
    let white = board.white.count_ones();
    if black > white {
        Some(BLACK)
    } else if white > black {
        Some(WHITE)
    } else {
        None
    }
}
