//! Command-line entry point, port of `cli.py` (hand-rolled parser, no deps).
//!
//! ```text
//! othello [--engine E] [--depth N|full] [--start S | --board-file P]
//!         [--to-move black|white] [--list-engines]
//! ```

use std::io::Read;

use crate::core::{parse_board, Board, Player, BLACK, WHITE};
use crate::engines::{make_engine, ENGINE_NAMES};
use crate::fixtures::{start, START_NAMES};
use crate::game::Depth;
use crate::play::play_game;

struct Args {
    engine: String,
    depth: Option<Depth>, // None = unset (use the engine default)
    start: String,
    start_set: bool,
    board_file: Option<String>,
    to_move: Option<String>,
    list_engines: bool,
}

impl Default for Args {
    fn default() -> Self {
        Args {
            engine: "ordered".into(),
            depth: None,
            start: "early".into(),
            start_set: false,
            board_file: None,
            to_move: None,
            list_engines: false,
        }
    }
}

const USAGE: &str = "\
usage: othello [-h] [--engine {alphabeta,minimax,ordered,strong}] [--depth N]
               [--start {black-win,either,early,white-win} | --board-file PATH]
               [--to-move {black,white}] [--list-engines]

Play a self-play Othello game with a chosen search engine.

options:
  -h, --help            show this help message and exit
  --engine ENGINE       search engine to play both sides (default: ordered)
  --depth N             plies to search per move ('full' for exact to terminal);
                        defaults to the engine's own default
  --start START         named starting position (default: early)
  --board-file PATH     read the starting position from a text grid ('-' for stdin)
  --to-move {black,white}
                        side to move (overrides a board file's directive)
  --list-engines        list available engines and exit";

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

/// Pull the value for `--flag value` or `--flag=value`.
fn take_value<'a>(
    flag: &str,
    inline: Option<&'a str>,
    iter: &mut std::slice::Iter<'a, String>,
) -> Result<&'a str, String> {
    if let Some(v) = inline {
        return Ok(v);
    }
    iter.next()
        .map(|s| s.as_str())
        .ok_or_else(|| format!("argument {flag}: expected one argument"))
}

enum Parsed {
    Run(Args),
    Help,
    Error(String),
}

fn parse(argv: &[String]) -> Parsed {
    let mut args = Args::default();
    let mut iter = argv.iter();
    while let Some(raw) = iter.next() {
        let (flag, inline) = match raw.split_once('=') {
            Some((f, v)) => (f, Some(v)),
            None => (raw.as_str(), None),
        };
        match flag {
            "-h" | "--help" => return Parsed::Help,
            "--list-engines" => args.list_engines = true,
            "--engine" => match take_value(flag, inline, &mut iter) {
                Ok(v) if ENGINE_NAMES.contains(&v) => args.engine = v.to_string(),
                Ok(v) => {
                    return Parsed::Error(format!(
                        "argument --engine: invalid choice: {v:?} (choose from {})",
                        choices(&ENGINE_NAMES)
                    ))
                }
                Err(e) => return Parsed::Error(e),
            },
            "--depth" => match take_value(flag, inline, &mut iter) {
                Ok(v) => match parse_depth(v) {
                    Ok(d) => args.depth = Some(d),
                    Err(e) => return Parsed::Error(e),
                },
                Err(e) => return Parsed::Error(e),
            },
            "--start" => match take_value(flag, inline, &mut iter) {
                Ok(v) if START_NAMES.contains(&v) => {
                    args.start = v.to_string();
                    args.start_set = true;
                }
                Ok(v) => {
                    return Parsed::Error(format!(
                        "argument --start: invalid choice: {v:?} (choose from {})",
                        choices(&START_NAMES)
                    ))
                }
                Err(e) => return Parsed::Error(e),
            },
            "--board-file" => match take_value(flag, inline, &mut iter) {
                Ok(v) => args.board_file = Some(v.to_string()),
                Err(e) => return Parsed::Error(e),
            },
            "--to-move" => match take_value(flag, inline, &mut iter) {
                Ok(v) if v == "black" || v == "white" => args.to_move = Some(v.to_string()),
                Ok(v) => {
                    return Parsed::Error(format!(
                    "argument --to-move: invalid choice: {v:?} (choose from \"black\", \"white\")"
                ))
                }
                Err(e) => return Parsed::Error(e),
            },
            other => return Parsed::Error(format!("unrecognized arguments: {other}")),
        }
    }
    if args.start_set && args.board_file.is_some() {
        return Parsed::Error("argument --board-file: not allowed with argument --start".into());
    }
    Parsed::Run(args)
}

fn choices(names: &[&str]) -> String {
    names
        .iter()
        .map(|n| format!("{n:?}"))
        .collect::<Vec<_>>()
        .join(", ")
}

fn read_file(path: &str) -> Result<String, String> {
    std::fs::read_to_string(path).map_err(|e| format!("{path}: {e}"))
}

fn load_board(args: &Args) -> Result<Board, String> {
    let to_move: Player = if args.to_move.as_deref() == Some("white") {
        WHITE
    } else {
        BLACK
    };
    if let Some(path) = &args.board_file {
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
        if args.to_move.is_some() {
            board = Board::new(board.black, board.white, to_move);
        }
        return Ok(board);
    }
    let mut board = start(&args.start).expect("validated start name");
    if args.to_move.is_some() {
        board = Board::new(board.black, board.white, to_move);
    }
    Ok(board)
}

/// Run the CLI; returns the process exit code (0 ok, 2 usage/IO error).
pub fn run(argv: Vec<String>) -> i32 {
    let args = match parse(&argv) {
        Parsed::Help => {
            println!("{USAGE}");
            return 0;
        }
        Parsed::Error(msg) => {
            eprintln!("othello: error: {msg}");
            return 2;
        }
        Parsed::Run(a) => a,
    };

    if args.list_engines {
        for name in ENGINE_NAMES {
            let engine = make_engine(name).unwrap();
            let depth = match engine.default_depth() {
                Some(d) => d.to_string(),
                None => "full".to_string(),
            };
            println!("{name:12} {:20} default depth {depth}", engine.name());
        }
        return 0;
    }

    let board = match load_board(&args) {
        Ok(b) => b,
        Err(e) => {
            eprintln!("error: {e}");
            return 2;
        }
    };

    let mut engine = make_engine(&args.engine).expect("validated engine name");
    let depth = match args.depth {
        Some(d) => d,
        None => engine.default_depth(),
    };
    play_game(board, engine.as_mut(), depth);
    0
}
