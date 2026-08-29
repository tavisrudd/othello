//! Exact theorem certificates for structured CNF instances.
//!
//! The current recognizer targets direct graph-coloring CNFs with at most 64
//! vertices and colors. It streams DIMACS clauses through a fixed buffer,
//! reconstructs the incompatibility graph, and recognizes complete multipartite
//! graphs. More parts than colors yields a replayable clique/pigeonhole UNSAT
//! certificate without CDCL search.

use rustc_hash::FxHashMap;
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::path::Path;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum StructuredSatError {
    #[error("DIMACS input could not be read")]
    Io(#[from] std::io::Error),
    #[error("malformed DIMACS CNF")]
    Format,
    #[error("the structured recognizer supports at most 64 vertices and colors")]
    Width,
    #[error("the CNF is not a direct block-structured coloring encoding")]
    Encoding,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct MultipartiteColoringCertificate {
    pub variables: u32,
    pub clauses: u32,
    pub vertices: u32,
    pub colors: u32,
    pub parts: Box<[u64]>,
    pub clique_vertices: Box<[u32]>,
}

/// Recognize a complete-multipartite graph-coloring CNF and, when the number
/// of parts exceeds the number of colors, return an exact UNSAT certificate.
pub fn certify_multipartite_coloring_unsat(
    path: impl AsRef<Path>,
) -> Result<Option<MultipartiteColoringCertificate>, StructuredSatError> {
    let path = path.as_ref();
    let mut maximum_positive_clause = 0_usize;
    let (variables, clauses) = scan_dimacs(path, |clause| {
        if clause.iter().all(|&literal| literal > 0) {
            maximum_positive_clause = maximum_positive_clause.max(clause.len());
        }
        Ok(())
    })?;
    if maximum_positive_clause == 0
        || maximum_positive_clause > 64
        || variables == 0
        || variables as usize % maximum_positive_clause != 0
    {
        return Err(StructuredSatError::Encoding);
    }
    let colors = maximum_positive_clause;
    let vertices = variables as usize / colors;
    if vertices > 64 {
        return Err(StructuredSatError::Width);
    }

    let expected_edge_capacity = clauses as usize / colors;
    let mut edge_colors =
        FxHashMap::<u64, u64>::with_capacity_and_hasher(expected_edge_capacity, Default::default());
    let mut domains = vec![0_u64; vertices];
    let mut domain_seen = 0_u64;
    scan_dimacs(path, |clause| {
        if clause.iter().all(|&literal| literal > 0) {
            let first = (clause[0] as usize - 1) / colors;
            if first >= vertices || domain_seen & (1_u64 << first) != 0 {
                return Err(StructuredSatError::Encoding);
            }
            let mut domain = 0_u64;
            for &literal in clause {
                let variable = literal as usize - 1;
                if variable / colors != first {
                    return Err(StructuredSatError::Encoding);
                }
                domain |= 1_u64 << (variable % colors);
            }
            domains[first] = domain;
            domain_seen |= 1_u64 << first;
            return Ok(());
        }
        if clause.len() != 2 || clause[0] >= 0 || clause[1] >= 0 {
            return Err(StructuredSatError::Encoding);
        }
        let left = (-clause[0] - 1) as usize;
        let right = (-clause[1] - 1) as usize;
        let (left_vertex, left_color) = (left / colors, left % colors);
        let (right_vertex, right_color) = (right / colors, right % colors);
        if left_vertex >= vertices
            || right_vertex >= vertices
            || left_vertex == right_vertex
            || left_color != right_color
        {
            return Err(StructuredSatError::Encoding);
        }
        let (low, high) = if left_vertex < right_vertex {
            (left_vertex, right_vertex)
        } else {
            (right_vertex, left_vertex)
        };
        let key = ((low as u64) << 32) | high as u64;
        let colors_seen = edge_colors.entry(key).or_default();
        let bit = 1_u64 << left_color;
        if *colors_seen & bit != 0 {
            return Err(StructuredSatError::Encoding);
        }
        *colors_seen |= bit;
        Ok(())
    })?;
    let vertex_mask = if vertices == 64 {
        u64::MAX
    } else {
        (1_u64 << vertices) - 1
    };
    if domain_seen != vertex_mask || domains.contains(&0) {
        return Err(StructuredSatError::Encoding);
    }
    let color_mask = if colors == 64 {
        u64::MAX
    } else {
        (1_u64 << colors) - 1
    };
    let mut adjacency = vec![0_u64; vertices];
    for (key, seen) in edge_colors {
        if seen != color_mask {
            return Err(StructuredSatError::Encoding);
        }
        let low = (key >> 32) as usize;
        let high = key as u32 as usize;
        adjacency[low] |= 1_u64 << high;
        adjacency[high] |= 1_u64 << low;
    }

    let mut remaining = vertex_mask;
    let mut parts = Vec::with_capacity(vertices);
    let mut clique = Vec::with_capacity(vertices);
    while remaining != 0 {
        let representative = remaining.trailing_zeros() as usize;
        let part = vertex_mask & !adjacency[representative];
        if part & remaining == 0 {
            return Err(StructuredSatError::Encoding);
        }
        let mut members = part;
        while members != 0 {
            let vertex = members.trailing_zeros() as usize;
            if vertex_mask & !adjacency[vertex] != part {
                return Ok(None);
            }
            members &= members - 1;
        }
        parts.push(part);
        clique.push(representative as u32);
        remaining &= !part;
    }
    if parts.len() <= colors {
        return Ok(None);
    }
    Ok(Some(MultipartiteColoringCertificate {
        variables,
        clauses,
        vertices: vertices as u32,
        colors: colors as u32,
        parts: parts.into_boxed_slice(),
        clique_vertices: clique.into_boxed_slice(),
    }))
}

fn scan_dimacs(
    path: &Path,
    mut consume: impl FnMut(&[i32]) -> Result<(), StructuredSatError>,
) -> Result<(u32, u32), StructuredSatError> {
    let mut reader = BufReader::new(File::open(path)?);
    let mut header = None;
    let mut observed_clauses = 0_u32;
    let mut clause = [0_i32; 64];
    let mut clause_len = 0_usize;
    let mut line = String::with_capacity(4_096);
    loop {
        line.clear();
        if reader.read_line(&mut line)? == 0 {
            break;
        }
        let trimmed = line.trim_start();
        if trimmed.is_empty() || trimmed.starts_with('c') {
            continue;
        }
        if trimmed.starts_with('p') {
            let mut words = trimmed.split_whitespace();
            if words.next() != Some("p") || words.next() != Some("cnf") || header.is_some() {
                return Err(StructuredSatError::Format);
            }
            let variables = words
                .next()
                .ok_or(StructuredSatError::Format)?
                .parse()
                .map_err(|_| StructuredSatError::Format)?;
            let clauses = words
                .next()
                .ok_or(StructuredSatError::Format)?
                .parse()
                .map_err(|_| StructuredSatError::Format)?;
            if words.next().is_some() {
                return Err(StructuredSatError::Format);
            }
            header = Some((variables, clauses));
            continue;
        }
        if header.is_none() {
            return Err(StructuredSatError::Format);
        }
        for word in trimmed.split_whitespace() {
            let literal: i32 = word.parse().map_err(|_| StructuredSatError::Format)?;
            if literal == 0 {
                if clause_len == 0 {
                    return Err(StructuredSatError::Format);
                }
                consume(&clause[..clause_len])?;
                clause_len = 0;
                observed_clauses = observed_clauses
                    .checked_add(1)
                    .ok_or(StructuredSatError::Format)?;
            } else {
                if clause_len == clause.len() {
                    return Err(StructuredSatError::Width);
                }
                clause[clause_len] = literal;
                clause_len += 1;
            }
        }
    }
    let (variables, clauses) = header.ok_or(StructuredSatError::Format)?;
    if clause_len != 0 || clauses != observed_clauses {
        return Err(StructuredSatError::Format);
    }
    Ok((variables, clauses))
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::io::Write;

    #[test]
    fn certifies_triangle_with_two_colors() {
        let cache = std::env::var_os("XDG_CACHE_HOME")
            .map(std::path::PathBuf::from)
            .unwrap_or_else(|| std::path::PathBuf::from("/home/tavis/.cache"));
        let path = cache.join(format!(
            "ergodis-coloring-{}-{}.cnf",
            std::process::id(),
            std::thread::current().name().unwrap_or("test")
        ));
        let mut file = File::create(&path).unwrap();
        writeln!(file, "p cnf 6 9").unwrap();
        writeln!(file, "1 0\n3 4 0\n5 6 0").unwrap();
        writeln!(file, "-1 -3 0\n-2 -4 0").unwrap();
        writeln!(file, "-1 -5 0\n-2 -6 0").unwrap();
        writeln!(file, "-3 -5 0\n-4 -6 0").unwrap();
        drop(file);
        let certificate = certify_multipartite_coloring_unsat(&path).unwrap().unwrap();
        std::fs::remove_file(path).unwrap();
        assert_eq!(certificate.colors, 2);
        assert_eq!(certificate.vertices, 3);
        assert_eq!(&*certificate.clique_vertices, &[0, 1, 2]);
    }
}
