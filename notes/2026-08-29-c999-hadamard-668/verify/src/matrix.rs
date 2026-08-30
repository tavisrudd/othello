//! Parsing, exact verification, dephasing and canonical serialization of +-1 matrices.

use anyhow::{anyhow, bail, Result};
use base64::Engine;
use rayon::prelude::*;
use serde::Serialize;
use sha2::{Digest, Sha256};

#[derive(Clone, Copy, Debug, PartialEq, Eq, clap::ValueEnum)]
pub enum Format {
    /// Detect from the file contents.
    Auto,
    /// Rows of `+` / `-` characters, one row per line.
    Pm,
    /// Rows of `0` / `1` characters, one row per line.
    Zo,
    /// Whitespace separated `1` / `-1` / `+1` tokens.
    Num,
    /// Bit packed, hexadecimal. Requires `--n`.
    Hex,
    /// Bit packed, standard base64. Requires `--n`.
    B64,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, clap::ValueEnum)]
pub enum BitLayout {
    /// The bit stream runs continuously across row boundaries.
    Contiguous,
    /// Each row starts on a byte boundary.
    RowAligned,
}

#[derive(Clone, Debug)]
pub struct Matrix {
    pub n: usize,
    pub rows: Vec<Vec<i8>>,
}

impl Matrix {
    pub fn from_rows(rows: Vec<Vec<i8>>) -> Result<Self> {
        let n = rows.len();
        if n == 0 {
            bail!("empty matrix");
        }
        for (i, r) in rows.iter().enumerate() {
            if r.len() != rows[0].len() {
                bail!(
                    "ragged input: row 0 has {} entries, row {} has {}",
                    rows[0].len(),
                    i,
                    r.len()
                );
            }
            for (j, &v) in r.iter().enumerate() {
                if v != 1 && v != -1 {
                    bail!("entry ({i},{j}) is {v}, not +-1");
                }
            }
        }
        Ok(Matrix { n, rows })
    }

    pub fn cols(&self) -> usize {
        self.rows[0].len()
    }

    pub fn is_square(&self) -> bool {
        self.cols() == self.n
    }

    /// Exact integer check of `H * H^T == n * I`.
    /// Returns `(ok, max off-diagonal |inner product|, one witness pair)`.
    pub fn check_orthogonality(&self) -> (bool, i64, Option<(usize, usize, i64)>) {
        let n = self.n;
        let res: Vec<(i64, Option<(usize, usize, i64)>)> = (0..n)
            .into_par_iter()
            .map(|i| {
                let mut worst = 0i64;
                let mut witness = None;
                let ri = &self.rows[i];
                for k in (i + 1)..n {
                    let rk = &self.rows[k];
                    let mut acc = 0i64;
                    for j in 0..ri.len() {
                        acc += (ri[j] as i64) * (rk[j] as i64);
                    }
                    if acc.abs() > worst {
                        worst = acc.abs();
                        witness = Some((i, k, acc));
                    }
                }
                (worst, witness)
            })
            .collect();
        let mut worst = 0i64;
        let mut witness = None;
        for (w, wt) in res {
            if w > worst {
                worst = w;
                witness = wt;
            }
        }
        // Diagonal is automatically n because every entry is +-1 and the matrix is square.
        (worst == 0, worst, witness)
    }

    /// Dephase: negate rows so that column 0 is all `+`, then negate columns so that row 0 is
    /// all `+`.
    pub fn dephase(&self) -> Matrix {
        let mut rows = self.rows.clone();
        for r in rows.iter_mut() {
            if r[0] == -1 {
                for v in r.iter_mut() {
                    *v = -*v;
                }
            }
        }
        let flip: Vec<bool> = rows[0].iter().map(|&v| v == -1).collect();
        for r in rows.iter_mut() {
            for (j, v) in r.iter_mut().enumerate() {
                if flip[j] {
                    *v = -*v;
                }
            }
        }
        Matrix { n: self.n, rows }
    }

    /// Canonical text form: one line of `+`/`-` per row, trailing newline.
    pub fn canonical_text(&self) -> String {
        let mut s = String::with_capacity(self.n * (self.cols() + 1));
        for r in &self.rows {
            for &v in r {
                s.push(if v == 1 { '+' } else { '-' });
            }
            s.push('\n');
        }
        s
    }

    pub fn sha256_canonical(&self) -> String {
        let mut h = Sha256::new();
        h.update(self.canonical_text().as_bytes());
        format!("{:x}", h.finalize())
    }

    pub fn row_sums(&self) -> Vec<i64> {
        self.rows
            .iter()
            .map(|r| r.iter().map(|&v| v as i64).sum())
            .collect()
    }

    #[allow(dead_code)]
    pub fn transpose(&self) -> Matrix {
        let m = self.cols();
        let mut rows = vec![vec![0i8; self.n]; m];
        for i in 0..self.n {
            for j in 0..m {
                rows[j][i] = self.rows[i][j];
            }
        }
        Matrix { n: m, rows }
    }

    /// `self[r0..r0+h][c0..c0+w]`
    pub fn block(&self, r0: usize, c0: usize, h: usize, w: usize) -> Vec<Vec<i8>> {
        (0..h)
            .map(|i| self.rows[r0 + i][c0..c0 + w].to_vec())
            .collect()
    }
}

#[derive(Serialize)]
pub struct VerifyReport {
    pub file: String,
    pub detected_format: String,
    pub rows: usize,
    pub cols: usize,
    pub square: bool,
    pub entries_pm1: bool,
    pub n: usize,
    pub orthogonal: bool,
    pub pass: bool,
    pub max_abs_offdiag: i64,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub worst_pair: Option<(usize, usize, i64)>,
    pub sha256_canonical_normalized: String,
    pub sha256_canonical_as_given: String,
    pub row_sum_multiset: Vec<(i64, usize)>,
}

// ---------------------------------------------------------------------------
// parsing
// ---------------------------------------------------------------------------

pub fn detect_format(content: &str) -> Format {
    let toks: Vec<&str> = content.split_ascii_whitespace().collect();
    if toks.len() > 1 && toks.iter().all(|t| matches!(*t, "1" | "-1" | "+1")) {
        return Format::Num;
    }
    let dense: String = content.chars().filter(|c| !c.is_whitespace()).collect();
    if dense.is_empty() {
        return Format::Auto;
    }
    if dense.chars().all(|c| c == '+' || c == '-') {
        return Format::Pm;
    }
    if dense.chars().all(|c| c == '0' || c == '1') {
        return Format::Zo;
    }
    if dense.chars().all(|c| c.is_ascii_hexdigit()) {
        return Format::Hex;
    }
    if dense
        .chars()
        .all(|c| c.is_ascii_alphanumeric() || c == '+' || c == '/' || c == '=')
    {
        return Format::B64;
    }
    Format::Auto
}

pub struct ParseOpts {
    pub format: Format,
    pub n: Option<usize>,
    pub bit_zero_is_plus: bool,
    pub bit_layout: BitLayout,
}

impl Default for ParseOpts {
    fn default() -> Self {
        ParseOpts {
            format: Format::Auto,
            n: None,
            bit_zero_is_plus: true,
            bit_layout: BitLayout::Contiguous,
        }
    }
}

pub fn parse(content: &str, opts: &ParseOpts) -> Result<(Matrix, Format)> {
    let fmt = if opts.format == Format::Auto {
        detect_format(content)
    } else {
        opts.format
    };
    let m = match fmt {
        Format::Auto => bail!("could not auto-detect the input format; pass --format"),
        Format::Num => {
            let vals: Vec<i8> = content
                .split_ascii_whitespace()
                .map(|t| match t {
                    "1" | "+1" => Ok(1i8),
                    "-1" => Ok(-1i8),
                    other => Err(anyhow!("bad numeric token {other:?}")),
                })
                .collect::<Result<_>>()?;
            let n = opts.n.unwrap_or_else(|| isqrt(vals.len()));
            if n == 0 || vals.len() % n != 0 {
                bail!("{} numeric entries do not split into rows of {}", vals.len(), n);
            }
            Matrix::from_rows(vals.chunks(n).map(|c| c.to_vec()).collect())?
        }
        Format::Pm | Format::Zo => {
            let rows: Vec<Vec<i8>> = content
                .lines()
                .map(|l| l.trim())
                .filter(|l| !l.is_empty())
                .map(|l| {
                    l.chars()
                        .filter(|c| !c.is_whitespace())
                        .map(|c| match (fmt, c) {
                            (Format::Pm, '+') => Ok(1i8),
                            (Format::Pm, '-') => Ok(-1i8),
                            (Format::Zo, '0') => Ok(if opts.bit_zero_is_plus { 1 } else { -1 }),
                            (Format::Zo, '1') => Ok(if opts.bit_zero_is_plus { -1 } else { 1 }),
                            (_, c) => Err(anyhow!("bad character {c:?}")),
                        })
                        .collect::<Result<Vec<i8>>>()
                })
                .collect::<Result<_>>()?;
            Matrix::from_rows(rows)?
        }
        Format::Hex | Format::B64 => {
            let n = opts
                .n
                .ok_or_else(|| anyhow!("--n is required for bit-packed input"))?;
            let dense: String = content.chars().filter(|c| !c.is_whitespace()).collect();
            let bytes = if fmt == Format::Hex {
                hex_decode(&dense)?
            } else {
                base64::engine::general_purpose::STANDARD
                    .decode(dense.as_bytes())
                    .or_else(|_| {
                        base64::engine::general_purpose::URL_SAFE.decode(dense.as_bytes())
                    })?
            };
            unpack_bits(&bytes, n, opts)?
        }
    };
    Ok((m, fmt))
}

fn isqrt(v: usize) -> usize {
    let mut r = (v as f64).sqrt() as usize;
    while r * r > v {
        r -= 1;
    }
    while (r + 1) * (r + 1) <= v {
        r += 1;
    }
    r
}

fn hex_decode(s: &str) -> Result<Vec<u8>> {
    if s.len() % 2 != 0 {
        bail!("hex string has odd length {}", s.len());
    }
    (0..s.len() / 2)
        .map(|i| {
            u8::from_str_radix(&s[2 * i..2 * i + 2], 16).map_err(|e| anyhow!("bad hex: {e}"))
        })
        .collect()
}

fn unpack_bits(bytes: &[u8], n: usize, opts: &ParseOpts) -> Result<Matrix> {
    let bit = |idx: usize| -> Result<i8> {
        let byte = *bytes
            .get(idx / 8)
            .ok_or_else(|| anyhow!("bit-packed input too short: need {} bits", idx + 1))?;
        let b = (byte >> (7 - (idx % 8))) & 1;
        Ok(match (b, opts.bit_zero_is_plus) {
            (0, true) | (1, false) => 1,
            _ => -1,
        })
    };
    let stride = match opts.bit_layout {
        BitLayout::Contiguous => n,
        BitLayout::RowAligned => n.div_ceil(8) * 8,
    };
    let mut rows = Vec::with_capacity(n);
    for i in 0..n {
        let mut row = Vec::with_capacity(n);
        for j in 0..n {
            row.push(bit(i * stride + j)?);
        }
        rows.push(row);
    }
    Matrix::from_rows(rows)
}

pub fn verify_report(file: &str, content: &str, opts: &ParseOpts) -> Result<VerifyReport> {
    let (m, fmt) = parse(content, opts)?;
    let square = m.is_square();
    let (ok, worst, witness) = if square {
        m.check_orthogonality()
    } else {
        (false, -1, None)
    };
    let mut sums: Vec<i64> = m.row_sums();
    sums.sort_unstable();
    let mut multiset: Vec<(i64, usize)> = Vec::new();
    for s in sums {
        match multiset.last_mut() {
            Some(last) if last.0 == s => last.1 += 1,
            _ => multiset.push((s, 1)),
        }
    }
    Ok(VerifyReport {
        file: file.to_string(),
        detected_format: format!("{fmt:?}").to_lowercase(),
        rows: m.n,
        cols: m.cols(),
        square,
        entries_pm1: true, // enforced by Matrix::from_rows
        n: m.n,
        orthogonal: ok,
        pass: square && ok,
        max_abs_offdiag: worst,
        worst_pair: if ok { None } else { witness },
        sha256_canonical_normalized: if square {
            m.dephase().sha256_canonical()
        } else {
            String::new()
        },
        sha256_canonical_as_given: m.sha256_canonical(),
        row_sum_multiset: multiset,
    })
}
