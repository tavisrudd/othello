use std::io::{self, BufReader, BufWriter};

use anyhow::Result;
use ergodis::rpc::{serve_jsonl, RpcLimits};

fn main() -> Result<()> {
    serve_jsonl(
        BufReader::new(io::stdin().lock()),
        BufWriter::new(io::stdout().lock()),
        RpcLimits::default(),
    )
}
