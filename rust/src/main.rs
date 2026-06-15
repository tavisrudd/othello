//! `othello` -- see `--help` for options.

fn main() {
    let argv: Vec<String> = std::env::args().skip(1).collect();
    std::process::exit(othello::cli::run(argv));
}
