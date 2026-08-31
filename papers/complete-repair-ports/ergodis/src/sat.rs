//! Exact theorem certificates for structured CNF instances.
//!
//! The current recognizer targets direct graph-coloring CNFs with bounded
//! clause width. It streams DIMACS clauses through a fixed buffer,
//! reconstructs the incompatibility graph, and recognizes complete multipartite
//! graphs. More parts than colors yields a replayable clique/pigeonhole UNSAT
//! certificate without CDCL search.

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
    #[error("the structured recognizer exceeded a fixed-width limit")]
    Width,
    #[error("the structured recognizer's dense edge table would exceed 64 MiB")]
    Capacity,
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

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ColoringCliqueCertificate {
    pub variables: u32,
    pub clauses: u32,
    pub vertices: u32,
    pub colors: u32,
    pub clique_vertices: Box<[u32]>,
}

struct DirectColoringGraph {
    variables: u32,
    clauses: u32,
    vertices: usize,
    colors: usize,
    words: usize,
    adjacency: Box<[u64]>,
}

/// Recognize a complete-multipartite graph-coloring CNF and, when the number
/// of parts exceeds the number of colors, return an exact UNSAT certificate.
pub fn certify_multipartite_coloring_unsat(
    path: impl AsRef<Path>,
) -> Result<Option<MultipartiteColoringCertificate>, StructuredSatError> {
    let graph = parse_direct_coloring(path.as_ref())?;
    let DirectColoringGraph {
        variables,
        clauses,
        vertices,
        colors,
        words,
        adjacency: pooled_adjacency,
    } = graph;
    if vertices > 64 {
        return Err(StructuredSatError::Width);
    }
    let vertex_mask = if vertices == 64 {
        u64::MAX
    } else {
        (1_u64 << vertices) - 1
    };
    debug_assert_eq!(words, 1);
    let adjacency = (0..vertices)
        .map(|vertex| pooled_adjacency[vertex])
        .collect::<Vec<_>>();

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

/// Recognize a direct graph-coloring encoding and return any explicit clique
/// whose cardinality exceeds the available color count. The clique alone is a
/// replayable pigeonhole UNSAT certificate; the graph need not be multipartite.
pub fn certify_coloring_clique_unsat(
    path: impl AsRef<Path>,
) -> Result<Option<ColoringCliqueCertificate>, StructuredSatError> {
    let graph = parse_direct_coloring(path.as_ref())?;
    if graph.vertices <= graph.colors {
        return Ok(None);
    }

    let mut degrees = vec![0_u32; graph.vertices];
    for (vertex, degree) in degrees.iter_mut().enumerate() {
        let row = &graph.adjacency[vertex * graph.words..(vertex + 1) * graph.words];
        *degree = row.iter().map(|word| word.count_ones()).sum();
    }
    let mut order = (0..graph.vertices as u32).collect::<Vec<_>>();
    order.sort_unstable_by_key(|&vertex| (std::cmp::Reverse(degrees[vertex as usize]), vertex));

    let mut candidates = vec![0_u64; graph.words];
    let mut clique = Vec::with_capacity(graph.colors + 1);
    for &start in &order {
        clique.clear();
        clique.push(start);
        let start = start as usize;
        candidates
            .copy_from_slice(&graph.adjacency[start * graph.words..(start + 1) * graph.words]);
        for &vertex in &order {
            let vertex = vertex as usize;
            if candidates[vertex / 64] & (1_u64 << (vertex % 64)) == 0 {
                continue;
            }
            clique.push(vertex as u32);
            if clique.len() > graph.colors {
                return Ok(Some(ColoringCliqueCertificate {
                    variables: graph.variables,
                    clauses: graph.clauses,
                    vertices: graph.vertices as u32,
                    colors: graph.colors as u32,
                    clique_vertices: clique.into_boxed_slice(),
                }));
            }
            let row = &graph.adjacency[vertex * graph.words..(vertex + 1) * graph.words];
            for (candidate, adjacent) in candidates.iter_mut().zip(row) {
                *candidate &= adjacent;
            }
        }
    }
    Ok(None)
}

fn parse_direct_coloring(path: &Path) -> Result<DirectColoringGraph, StructuredSatError> {
    const MAX_EDGE_TABLE_BYTES: usize = 64 << 20;
    let mut maximum_positive_clause = 0_usize;
    let (variables, clauses) = scan_dimacs(path, |clause| {
        if clause.iter().all(|&literal| literal > 0) {
            maximum_positive_clause = maximum_positive_clause.max(clause.len());
        } else if clause.len() != 2 || clause.iter().any(|&literal| literal >= 0) {
            return Err(StructuredSatError::Encoding);
        }
        Ok(())
    })?;
    if maximum_positive_clause == 0
        || variables == 0
        || !(variables as usize).is_multiple_of(maximum_positive_clause)
    {
        return Err(StructuredSatError::Encoding);
    }
    let colors = maximum_positive_clause;
    let vertices = variables as usize / colors;
    let words = vertices.div_ceil(64);
    let color_words = colors.div_ceil(64);
    let maximum_edges = vertices.saturating_mul(vertices.saturating_sub(1)) / 2;
    let edge_color_words = maximum_edges
        .checked_mul(color_words)
        .ok_or(StructuredSatError::Capacity)?;
    if edge_color_words.saturating_mul(std::mem::size_of::<u64>()) > MAX_EDGE_TABLE_BYTES {
        return Err(StructuredSatError::Capacity);
    }
    let mut edge_colors = vec![0_u64; edge_color_words];
    let mut domains = vec![0_u64; vertices.saturating_mul(color_words)];
    let mut domain_seen = vec![0_u64; words];
    if color_words == 1 {
        populate_single_word_coloring(
            path,
            colors,
            vertices,
            &mut edge_colors,
            &mut domains,
            &mut domain_seen,
        )?;
    } else {
        populate_multiword_coloring(
            path,
            colors,
            vertices,
            color_words,
            &mut edge_colors,
            &mut domains,
            &mut domain_seen,
        )?;
    }
    let complete_words = vertices / 64;
    if domain_seen[..complete_words]
        .iter()
        .any(|&word| word != u64::MAX)
        || !vertices.is_multiple_of(64)
            && domain_seen[complete_words] != (1_u64 << (vertices % 64)) - 1
        || domains
            .chunks_exact(color_words)
            .any(|domain| domain.iter().all(|&word| word == 0))
    {
        return Err(StructuredSatError::Encoding);
    }

    let mut adjacency = vec![0_u64; vertices * words];
    if color_words == 1 {
        for low in 0..vertices {
            for high in low + 1..vertices {
                let seen = edge_colors[triangular_pair_index(vertices, low, high)];
                let shared_domain = domains[low] & domains[high];
                if seen & shared_domain != shared_domain {
                    continue;
                }
                adjacency[low * words + high / 64] |= 1_u64 << (high % 64);
                adjacency[high * words + low / 64] |= 1_u64 << (low % 64);
            }
        }
    } else {
        for low in 0..vertices {
            for high in low + 1..vertices {
                let edge_base = triangular_pair_index(vertices, low, high) * color_words;
                let low_domain = &domains[low * color_words..(low + 1) * color_words];
                let high_domain = &domains[high * color_words..(high + 1) * color_words];
                let mut complete = true;
                for color_word in 0..color_words {
                    let shared_domain = low_domain[color_word] & high_domain[color_word];
                    if edge_colors[edge_base + color_word] & shared_domain != shared_domain {
                        complete = false;
                        break;
                    }
                }
                if !complete {
                    continue;
                }
                adjacency[low * words + high / 64] |= 1_u64 << (high % 64);
                adjacency[high * words + low / 64] |= 1_u64 << (low % 64);
            }
        }
    }
    Ok(DirectColoringGraph {
        variables,
        clauses,
        vertices,
        colors,
        words,
        adjacency: adjacency.into_boxed_slice(),
    })
}

#[inline(always)]
fn populate_single_word_coloring(
    path: &Path,
    colors: usize,
    vertices: usize,
    edge_colors: &mut [u64],
    domains: &mut [u64],
    domain_seen: &mut [u64],
) -> Result<(), StructuredSatError> {
    scan_dimacs(path, |clause| {
        if clause.iter().all(|&literal| literal > 0) {
            let first = (clause[0] as usize - 1) / colors;
            if first >= vertices || domain_seen[first / 64] & (1_u64 << (first % 64)) != 0 {
                return Err(StructuredSatError::Encoding);
            }
            for &literal in clause {
                let variable = literal as usize - 1;
                if variable / colors != first {
                    return Err(StructuredSatError::Encoding);
                }
                let bit = 1_u64 << (variable % colors);
                if domains[first] & bit != 0 {
                    return Err(StructuredSatError::Encoding);
                }
                domains[first] |= bit;
            }
            domain_seen[first / 64] |= 1_u64 << (first % 64);
            return Ok(());
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
        let colors_seen = &mut edge_colors[triangular_pair_index(vertices, low, high)];
        let bit = 1_u64 << left_color;
        if *colors_seen & bit != 0 {
            return Err(StructuredSatError::Encoding);
        }
        *colors_seen |= bit;
        Ok(())
    })?;
    Ok(())
}

#[inline(never)]
fn populate_multiword_coloring(
    path: &Path,
    colors: usize,
    vertices: usize,
    color_words: usize,
    edge_colors: &mut [u64],
    domains: &mut [u64],
    domain_seen: &mut [u64],
) -> Result<(), StructuredSatError> {
    scan_dimacs(path, |clause| {
        if clause.iter().all(|&literal| literal > 0) {
            let first = (clause[0] as usize - 1) / colors;
            if first >= vertices || domain_seen[first / 64] & (1_u64 << (first % 64)) != 0 {
                return Err(StructuredSatError::Encoding);
            }
            for &literal in clause {
                let variable = literal as usize - 1;
                if variable / colors != first {
                    return Err(StructuredSatError::Encoding);
                }
                let color = variable % colors;
                let domain_word = &mut domains[first * color_words + color / 64];
                let bit = 1_u64 << (color % 64);
                if *domain_word & bit != 0 {
                    return Err(StructuredSatError::Encoding);
                }
                *domain_word |= bit;
            }
            domain_seen[first / 64] |= 1_u64 << (first % 64);
            return Ok(());
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
        let colors_seen = &mut edge_colors
            [triangular_pair_index(vertices, low, high) * color_words + left_color / 64];
        let bit = 1_u64 << (left_color % 64);
        if *colors_seen & bit != 0 {
            return Err(StructuredSatError::Encoding);
        }
        *colors_seen |= bit;
        Ok(())
    })?;
    Ok(())
}

#[inline(always)]
fn triangular_pair_index(vertices: usize, low: usize, high: usize) -> usize {
    debug_assert!(low < high && high < vertices);
    low * (2 * vertices - low - 1) / 2 + high - low - 1
}

fn scan_dimacs(
    path: &Path,
    mut consume: impl FnMut(&[i32]) -> Result<(), StructuredSatError>,
) -> Result<(u32, u32), StructuredSatError> {
    let mut reader = BufReader::new(File::open(path)?);
    let mut header = None;
    let mut observed_clauses = 0_u32;
    let mut clause = [0_i32; 1_024];
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

    fn test_cache() -> std::path::PathBuf {
        std::env::var_os("XDG_CACHE_HOME")
            .map(std::path::PathBuf::from)
            .unwrap_or_else(|| std::env::current_dir().unwrap().join("target"))
    }

    #[test]
    fn certifies_triangle_with_two_colors() {
        let cache = test_cache();
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

    #[test]
    fn rejects_non_coloring_clause_shapes() {
        let cache = test_cache();
        let path = cache.join(format!(
            "ergodis-non-coloring-{}-{}.cnf",
            std::process::id(),
            std::thread::current().name().unwrap_or("test")
        ));
        let mut file = File::create(&path).unwrap();
        writeln!(file, "p cnf 3 1").unwrap();
        writeln!(file, "-1 2 -3 0").unwrap();
        drop(file);
        let error = certify_multipartite_coloring_unsat(&path).unwrap_err();
        std::fs::remove_file(path).unwrap();
        assert!(matches!(error, StructuredSatError::Encoding));
    }

    #[test]
    fn accepts_direct_coloring_domains_wider_than_one_word() {
        let cache = test_cache();
        let path = cache.join(format!(
            "ergodis-wide-coloring-{}-{}.cnf",
            std::process::id(),
            std::thread::current().name().unwrap_or("test")
        ));
        let mut file = File::create(&path).unwrap();
        writeln!(file, "p cnf 130 2").unwrap();
        for first in [1, 66] {
            for literal in first..first + 65 {
                write!(file, "{literal} ").unwrap();
            }
            writeln!(file, "0").unwrap();
        }
        drop(file);
        assert!(certify_coloring_clique_unsat(&path).unwrap().is_none());
        std::fs::remove_file(path).unwrap();
    }

    #[test]
    fn certifies_clique_without_multipartite_graph() {
        let cache = test_cache();
        let path = cache.join(format!(
            "ergodis-clique-{}-{}.cnf",
            std::process::id(),
            std::thread::current().name().unwrap_or("test")
        ));
        let mut file = File::create(&path).unwrap();
        writeln!(file, "p cnf 15 26").unwrap();
        for vertex in 0..5 {
            writeln!(
                file,
                "{} {} {} 0",
                vertex * 3 + 1,
                vertex * 3 + 2,
                vertex * 3 + 3
            )
            .unwrap();
        }
        for (left, right) in [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3), (0, 4)] {
            for color in 0..3 {
                writeln!(
                    file,
                    "-{} -{} 0",
                    left * 3 + color + 1,
                    right * 3 + color + 1
                )
                .unwrap();
            }
        }
        drop(file);
        assert!(certify_multipartite_coloring_unsat(&path)
            .unwrap()
            .is_none());
        let certificate = certify_coloring_clique_unsat(&path).unwrap().unwrap();
        std::fs::remove_file(path).unwrap();
        assert_eq!(certificate.colors, 3);
        assert_eq!(certificate.clique_vertices.len(), 4);
    }
}
