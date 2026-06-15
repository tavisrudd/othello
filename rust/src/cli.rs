//! Command-line entry point for the self-play Othello driver (clap).

use std::io::Read;

use clap::builder::PossibleValuesParser;
use clap::Parser;

use crate::core::{parse_board, Board, Player, BLACK, WHITE};
use crate::engines::{make_engine, ENGINE_INFO, ENGINE_NAMES};
use crate::fixtures::start;
use crate::game::Depth;
use crate::play::play_game;

#[derive(Parser)]
#[command(
    name = "othello",
    about = "Play a self-play Othello game with a chosen search engine."
)]
struct Cli {
    /// Search engine to play both sides.
    #[arg(long, default_value = "ordered", value_parser = PossibleValuesParser::new(ENGINE_NAMES))]
    engine: String,

    /// Plies to search per move ('full' = exact to terminal) [default: the engine's own].
    #[arg(long, value_name = "N|full")]
    depth: Option<String>,

    /// Named starting position [default: early].
    #[arg(long, value_parser = PossibleValuesParser::new(crate::fixtures::START_NAMES), conflicts_with = "board_file")]
    start: Option<String>,

    /// Read the starting position from a text grid ('-' for stdin).
    #[arg(long, value_name = "PATH")]
    board_file: Option<String>,

    /// Side to move (overrides a board file's directive).
    #[arg(long, value_parser = ["black", "white"])]
    to_move: Option<String>,

    /// List available engines and exit.
    #[arg(long)]
    list_engines: bool,
}

/// `--depth` value: an integer ply count, or 'full'/'exact'/'none' for the exact
/// endgame solve (`Depth::None`).
fn parse_depth(value: &str) -> Result<Depth, String> {
    let low = value.to_ascii_lowercase();
    if low == "full" || low == "none" || low == "exact" {
        return Ok(None);
    }
    value
        .parse::<i32>()
        .map(Some)
        .map_err(|_| format!("depth must be an integer or 'full': {value:?}"))
}

fn read_file(path: &str) -> Result<String, String> {
    std::fs::read_to_string(path).map_err(|e| format!("{path}: {e}"))
}

fn load_board(
    start_name: &str,
    board_file: Option<&str>,
    to_move_opt: Option<&str>,
) -> Result<Board, String> {
    let to_move: Player = if to_move_opt == Some("white") {
        WHITE
    } else {
        BLACK
    };
    if let Some(path) = board_file {
        let text = if path == "-" {
            let mut s = String::new();
            std::io::stdin()
                .read_to_string(&mut s)
                .map_err(|e| e.to_string())?;
            s
        } else {
            read_file(path)?
        };
        let mut board = parse_board(&text, to_move)?;
        if to_move_opt.is_some() {
            board = Board::new(board.black, board.white, to_move);
        }
        return Ok(board);
    }
    let mut board = start(start_name).expect("validated start name");
    if to_move_opt.is_some() {
        board = Board::new(board.black, board.white, to_move);
    }
    Ok(board)
}

/// Run the CLI; returns the process exit code (0 ok, 2 usage/IO error). `clap`
/// handles `--help`/`-h` and argument errors itself (exiting directly).
pub fn run() -> i32 {
    let cli = Cli::parse();

    if cli.list_engines {
        let rows: Vec<Vec<String>> = ENGINE_INFO
            .iter()
            .map(|(name, desc, parallelism)| {
                let depth = match make_engine(name).unwrap().default_depth() {
                    Some(d) => d.to_string(),
                    None => "full".to_string(),
                };
                vec![
                    name.to_string(),
                    desc.to_string(),
                    parallelism.to_string(),
                    depth,
                ]
            })
            .collect();
        print!(
            "{}",
            crate::table::render(
                &["name", "description", "parallelism", "default depth"],
                &rows,
                1, // wrap the description column
            )
        );
        return 0;
    }

    let board = match load_board(
        cli.start.as_deref().unwrap_or("early"),
        cli.board_file.as_deref(),
        cli.to_move.as_deref(),
    ) {
        Ok(b) => b,
        Err(e) => {
            eprintln!("error: {e}");
            return 2;
        }
    };

    let mut engine = make_engine(&cli.engine).expect("validated engine name");
    let depth = match cli.depth.as_deref() {
        None => engine.default_depth(),
        Some(s) => match parse_depth(s) {
            Ok(d) => d,
            Err(e) => {
                eprintln!("othello: error: {e}");
                return 2;
            }
        },
    };
    play_game(board, engine.as_mut(), depth);
    0
}
