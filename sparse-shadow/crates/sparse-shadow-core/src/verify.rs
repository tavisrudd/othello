use std::collections::BTreeSet;

use serde::{Deserialize, Serialize};

use crate::{
    ActionKind, BinaryRelation, BranchDecision, CanonicalCertificate, InputArtifact,
    PaperIOrientation, ProfileInput, RelationalShadow, ShadowError,
};

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct VerificationReport {
    pub valid: bool,
    pub canonical_id: Option<String>,
    pub checked_automorphisms: usize,
}

/// Validate schema, normalization, action, and adapter-specific admissibility.
///
/// # Errors
///
/// Returns an error for any unknown, inconsistent, unsupported, or gated input.
pub fn validate(input: &InputArtifact) -> Result<VerificationReport, ShadowError> {
    input.check_version()?;
    match &input.profile {
        ProfileInput::PaperIOrientation(paper) => {
            if paper.shadow.action != ActionKind::ColorPreservingPermutations {
                return Err(ShadowError::Invalid("unsupported Paper-I action".into()));
            }
            let n = paper.shadow.vertices.len();
            if n == 0 {
                return Err(ShadowError::Invalid("vertex set is empty".into()));
            }
            if n != 12 {
                return Err(ShadowError::Invalid(
                    "schema-v1 Paper-I orientation fixture requires twelve vertices".into(),
                ));
            }
            if paper.theorem_locator.trim().is_empty() {
                return Err(ShadowError::Invalid("theorem locator is empty".into()));
            }
            if n > u32::MAX as usize {
                return Err(ShadowError::Invalid(
                    "vertex count exceeds schema range".into(),
                ));
            }
            if paper.shadow.relations.len() != 3 {
                return Err(ShadowError::Invalid(
                    "Paper-I orientation requires exactly two orbitals and one antipodal relation"
                        .into(),
                ));
            }
            let expected = ["orbital_positive", "orbital_negative", "antipodal"];
            for (relation, expected_name) in paper.shadow.relations.iter().zip(expected) {
                if relation.name != expected_name {
                    return Err(ShadowError::Invalid(format!(
                        "expected relation `{expected_name}`, found `{}`",
                        relation.name
                    )));
                }
                validate_relation(relation, n)?;
            }
            validate_paper_i_partition(&paper.shadow.relations, n)?;
            if let Some(triangle) = paper.calibrated_triangle {
                let distinct: BTreeSet<_> = triangle.into_iter().collect();
                if distinct.len() != 3 || triangle.iter().any(|&vertex| vertex as usize >= n) {
                    return Err(ShadowError::Invalid(
                        "calibrated triangle must contain three distinct in-range vertices".into(),
                    ));
                }
            }
        }
        ProfileInput::PaperIiTrade(value) => validate_gate("paper_ii_trade", &value.gate)?,
        ProfileInput::PaperIiiFourShadow(value) => {
            validate_gate("paper_iii_four_shadow", &value.gate)?;
        }
        ProfileInput::PaperIvMinimumWords(value) => {
            validate_gate("paper_iv_minimum_words", &value.gate)?;
        }
        ProfileInput::PaperVChordalConference(value) => {
            validate_gate("paper_v_chordal_conference", &value.gate)?;
        }
    }
    Ok(VerificationReport {
        valid: true,
        canonical_id: None,
        checked_automorphisms: 0,
    })
}

/// Replay a canonical certificate from the raw input.
///
/// Cached refinement state and claimed hashes are not trusted.
///
/// # Errors
///
/// Returns an error if canonical search, the explicit witness, artifact
/// identity, or any reported automorphism fails independent replay.
pub fn verify_certificate(
    input: &InputArtifact,
    certificate: &CanonicalCertificate,
) -> Result<VerificationReport, ShadowError> {
    if certificate.certificate_schema != "sparse-shadow-certificate/v1" {
        return Err(ShadowError::Certificate(
            "unsupported certificate schema".into(),
        ));
    }
    if certificate.proof_system != "paper-i-ir-exhaustion/v1" {
        return Err(ShadowError::Certificate(
            "unsupported canonical proof system".into(),
        ));
    }
    // This reference search is separate from the producing canonicalizer. It
    // starts from raw relations and trusts neither cached refinement nor hashes.
    let recomputed = reference_canonicalize(input)?;
    if recomputed.canonical_json != certificate.canonical_json {
        return Err(ShadowError::Certificate(
            "canonical payload differs from independently recomputed search".into(),
        ));
    }
    let actual_id = blake3::hash(certificate.canonical_json.as_bytes())
        .to_hex()
        .to_string();
    if actual_id != certificate.canonical_id {
        return Err(ShadowError::Certificate(
            "canonical identity is corrupt".into(),
        ));
    }
    if recomputed.input_to_canonical != certificate.input_to_canonical {
        return Err(ShadowError::Certificate(
            "input-to-canonical witness differs".into(),
        ));
    }
    if recomputed.winning_trace != certificate.winning_trace {
        return Err(ShadowError::Certificate(
            "winning branch trace differs".into(),
        ));
    }
    if recomputed.automorphisms != certificate.automorphisms {
        return Err(ShadowError::Certificate(
            "automorphism set is incomplete or corrupt".into(),
        ));
    }
    if recomputed.search_stats != certificate.search_stats {
        return Err(ShadowError::Certificate(
            "exhausted-search counters differ".into(),
        ));
    }
    let checked = certificate.automorphisms.len();
    for permutation in &certificate.automorphisms {
        verify_automorphism(input, permutation)?;
    }
    Ok(VerificationReport {
        valid: true,
        canonical_id: Some(actual_id),
        checked_automorphisms: checked,
    })
}

struct ReferenceResult {
    canonical_json: String,
    input_to_canonical: Vec<u32>,
    winning_trace: Vec<BranchDecision>,
    automorphisms: Vec<Vec<u32>>,
    search_stats: crate::SearchStats,
}

struct ReferenceSearch<'a> {
    paper: &'a PaperIOrientation,
    edge_sets: Vec<BTreeSet<[u32; 2]>>,
    best_json: Option<String>,
    best_permutation: Vec<u32>,
    winning_trace: Vec<BranchDecision>,
    equal_permutations: Vec<Vec<u32>>,
    stats: crate::SearchStats,
}

fn reference_canonicalize(input: &InputArtifact) -> Result<ReferenceResult, ShadowError> {
    validate(input)?;
    let ProfileInput::PaperIOrientation(paper) = &input.profile else {
        return Err(ShadowError::Certificate(
            "reference checker supports only the enabled Paper-I adapter".into(),
        ));
    };
    let edge_sets = paper
        .shadow
        .relations
        .iter()
        .map(|relation| relation.edges.iter().copied().collect())
        .collect();
    let mut search = ReferenceSearch {
        paper,
        edge_sets,
        best_json: None,
        best_permutation: Vec::new(),
        winning_trace: Vec::new(),
        equal_permutations: Vec::new(),
        stats: crate::SearchStats {
            search_nodes: 0,
            canonical_leaves: 0,
            refinement_rounds: 0,
            max_depth: 0,
            arena_grows: 0,
        },
    };
    search.walk(reference_initial_partition(paper), &mut Vec::new())?;
    let canonical_json = search
        .best_json
        .ok_or_else(|| ShadowError::Certificate("reference search found no leaf".into()))?;
    let automorphisms =
        reference_automorphisms(&search.best_permutation, &search.equal_permutations)?;
    Ok(ReferenceResult {
        canonical_json,
        input_to_canonical: search.best_permutation,
        winning_trace: search.winning_trace,
        automorphisms,
        search_stats: search.stats,
    })
}

impl ReferenceSearch<'_> {
    fn walk(
        &mut self,
        partition: Vec<Vec<u32>>,
        trace: &mut Vec<BranchDecision>,
    ) -> Result<(), ShadowError> {
        self.stats.search_nodes += 1;
        self.stats.max_depth = self
            .stats
            .max_depth
            .max(u32::try_from(trace.len()).expect("Paper-I depth fits u32"));
        let partition = self.equitable_partition(partition);
        if partition.iter().all(|cell| cell.len() == 1) {
            self.stats.canonical_leaves += 1;
            let mut permutation = vec![0; partition.len()];
            for (new, cell) in partition.iter().enumerate() {
                permutation[cell[0] as usize] =
                    u32::try_from(new).expect("validated vertex count fits u32");
            }
            let candidate = reference_relabel(self.paper, &permutation);
            let json = serde_json::to_string(&candidate)?;
            match self.best_json.as_ref() {
                None => self.replace_best(json, permutation, trace),
                Some(best) if json < *best => self.replace_best(json, permutation, trace),
                Some(best) if json == *best => self.equal_permutations.push(permutation),
                Some(_) => {}
            }
            return Ok(());
        }
        let chosen = partition
            .iter()
            .enumerate()
            .filter(|(_, cell)| cell.len() > 1)
            .min_by_key(|(_, cell)| cell.len())
            .map(|(index, _)| index)
            .expect("non-discrete partition contains a branch cell");
        let candidates = partition[chosen].clone();
        for &vertex in &candidates {
            trace.push(BranchDecision {
                depth: u32::try_from(trace.len()).expect("trace depth fits u32"),
                cell: candidates.clone(),
                chosen_vertex: vertex,
            });
            let mut child = partition.clone();
            let rest = child[chosen]
                .iter()
                .copied()
                .filter(|&other| other != vertex)
                .collect();
            child.splice(chosen..=chosen, [vec![vertex], rest]);
            self.walk(child, trace)?;
            trace.pop();
        }
        Ok(())
    }

    fn replace_best(&mut self, json: String, permutation: Vec<u32>, trace: &[BranchDecision]) {
        self.best_json = Some(json);
        self.best_permutation.clone_from(&permutation);
        self.winning_trace = trace.to_vec();
        self.equal_permutations.clear();
        self.equal_permutations.push(permutation);
    }

    fn equitable_partition(&mut self, mut partition: Vec<Vec<u32>>) -> Vec<Vec<u32>> {
        loop {
            self.stats.refinement_rounds += 1;
            let old = partition;
            let mut changed = false;
            let mut next = Vec::with_capacity(old.len());
            for cell in &old {
                let mut buckets = std::collections::BTreeMap::<Vec<u32>, Vec<u32>>::new();
                for &vertex in cell {
                    let signature = self.reference_signature(vertex, &old);
                    buckets.entry(signature).or_default().push(vertex);
                }
                changed |= buckets.len() > 1;
                next.extend(buckets.into_values());
            }
            partition = next;
            if !changed {
                return partition;
            }
        }
    }

    fn reference_signature(&self, vertex: u32, partition: &[Vec<u32>]) -> Vec<u32> {
        let mut signature = Vec::new();
        for (relation_index, relation) in self.paper.shadow.relations.iter().enumerate() {
            for cell in partition {
                let outgoing = cell
                    .iter()
                    .filter(|&&other| {
                        self.edge_sets[relation_index].contains(&normalized_edge(
                            vertex,
                            other,
                            relation.directed,
                        ))
                    })
                    .count();
                signature.push(u32::try_from(outgoing).expect("validated degree fits u32"));
                if relation.directed {
                    let incoming = cell
                        .iter()
                        .filter(|&&other| self.edge_sets[relation_index].contains(&[other, vertex]))
                        .count();
                    signature.push(u32::try_from(incoming).expect("validated degree fits u32"));
                }
            }
        }
        if let Some(triangle) = self.paper.calibrated_triangle {
            signature.push(u32::from(triangle.contains(&vertex)));
        }
        signature
    }
}

fn reference_initial_partition(paper: &PaperIOrientation) -> Vec<Vec<u32>> {
    let mut cells = std::collections::BTreeMap::<crate::Vertex, Vec<u32>>::new();
    for (vertex, data) in paper.shadow.vertices.iter().cloned().enumerate() {
        cells
            .entry(data)
            .or_default()
            .push(u32::try_from(vertex).expect("validated vertex count fits u32"));
    }
    cells.into_values().collect()
}

fn reference_relabel(paper: &PaperIOrientation, permutation: &[u32]) -> InputArtifact {
    let mut vertices = paper.shadow.vertices.clone();
    for (old, &new) in permutation.iter().enumerate() {
        vertices[new as usize] = paper.shadow.vertices[old].clone();
    }
    let relations = paper
        .shadow
        .relations
        .iter()
        .map(|relation| {
            let mut edges: Vec<[u32; 2]> = relation
                .edges
                .iter()
                .map(|&[left, right]| {
                    normalized_edge(
                        permutation[left as usize],
                        permutation[right as usize],
                        relation.directed,
                    )
                })
                .collect();
            edges.sort_unstable();
            BinaryRelation {
                name: relation.name.clone(),
                directed: relation.directed,
                edges,
            }
        })
        .collect();
    let calibrated_triangle = paper.calibrated_triangle.map(|triangle| {
        let mut result = triangle.map(|vertex| permutation[vertex as usize]);
        result.sort_unstable();
        result
    });
    InputArtifact {
        schema: crate::SCHEMA_VERSION.into(),
        profile: ProfileInput::PaperIOrientation(PaperIOrientation {
            theorem_locator: "clebsch-paper-i-orientation/v1".into(),
            shadow: RelationalShadow {
                action: paper.shadow.action,
                vertices,
                relations,
            },
            calibrated_triangle,
        }),
    }
}

fn normalized_edge(left: u32, right: u32, directed: bool) -> [u32; 2] {
    if directed || left < right {
        [left, right]
    } else {
        [right, left]
    }
}

fn reference_automorphisms(best: &[u32], equal: &[Vec<u32>]) -> Result<Vec<Vec<u32>>, ShadowError> {
    let mut result = BTreeSet::new();
    for leaf in equal {
        let mut inverse = vec![0; leaf.len()];
        for (old, &canonical) in leaf.iter().enumerate() {
            inverse[canonical as usize] =
                u32::try_from(old).expect("validated vertex count fits u32");
        }
        result.insert(
            best.iter()
                .map(|&canonical| inverse[canonical as usize])
                .collect(),
        );
    }
    if result.is_empty() {
        return Err(ShadowError::Certificate(
            "reference search found no automorphism".into(),
        ));
    }
    Ok(result.into_iter().collect())
}

fn validate_gate(profile: &'static str, gate: &crate::FixtureGate) -> Result<(), ShadowError> {
    Err(ShadowError::ProfileGated {
        profile,
        reason: if gate.enabled {
            format!(
                "adapter implementation is absent despite enabled gate; required export: {}",
                gate.required_export
            )
        } else {
            format!("{}; required export: {}", gate.reason, gate.required_export)
        },
    })
}

fn validate_relation(relation: &BinaryRelation, n: usize) -> Result<(), ShadowError> {
    let mut seen = BTreeSet::new();
    for &[left, right] in &relation.edges {
        if left as usize >= n || right as usize >= n {
            return Err(ShadowError::Invalid(format!(
                "relation `{}` contains an out-of-range endpoint",
                relation.name
            )));
        }
        if left == right {
            return Err(ShadowError::Invalid(format!(
                "relation `{}` contains a loop",
                relation.name
            )));
        }
        if !relation.directed && left >= right {
            return Err(ShadowError::Invalid(format!(
                "undirected relation `{}` must store edges as [min,max]",
                relation.name
            )));
        }
        if !seen.insert([left, right]) {
            return Err(ShadowError::Invalid(format!(
                "relation `{}` contains a duplicate edge",
                relation.name
            )));
        }
    }
    Ok(())
}

fn validate_paper_i_partition(relations: &[BinaryRelation], n: usize) -> Result<(), ShadowError> {
    if relations.iter().any(|relation| relation.directed) {
        return Err(ShadowError::Invalid(
            "Paper-I orbital and antipodal relations must be undirected".into(),
        ));
    }
    let expected_degrees = [5, 5, 1];
    let mut all_pairs = BTreeSet::new();
    for (relation, expected_degree) in relations.iter().zip(expected_degrees) {
        let mut degrees = vec![0usize; n];
        for &edge @ [left, right] in &relation.edges {
            degrees[left as usize] += 1;
            degrees[right as usize] += 1;
            if !all_pairs.insert(edge) {
                return Err(ShadowError::Invalid(
                    "Paper-I relations overlap on an unordered pair".into(),
                ));
            }
        }
        if degrees.iter().any(|&degree| degree != expected_degree) {
            return Err(ShadowError::Invalid(format!(
                "relation `{}` is not {expected_degree}-regular",
                relation.name
            )));
        }
    }
    if all_pairs.len() != n * (n - 1) / 2 {
        return Err(ShadowError::Invalid(
            "Paper-I relations do not partition all unordered vertex pairs".into(),
        ));
    }
    Ok(())
}

fn verify_automorphism(input: &InputArtifact, permutation: &[u32]) -> Result<(), ShadowError> {
    let ProfileInput::PaperIOrientation(paper) = &input.profile else {
        return Err(ShadowError::Certificate(
            "automorphism replay is not enabled for this profile".into(),
        ));
    };
    let n = paper.shadow.vertices.len();
    let image: BTreeSet<_> = permutation.iter().copied().collect();
    if permutation.len() != n || image.len() != n || image.iter().any(|&v| v as usize >= n) {
        return Err(ShadowError::Certificate(
            "automorphism is not a permutation".into(),
        ));
    }
    for (old, &new) in permutation.iter().enumerate() {
        if paper.shadow.vertices[old] != paper.shadow.vertices[new as usize] {
            return Err(ShadowError::Certificate(
                "automorphism does not preserve vertex data".into(),
            ));
        }
    }
    for relation in &paper.shadow.relations {
        let original: BTreeSet<[u32; 2]> = relation.edges.iter().copied().collect();
        let mapped: BTreeSet<[u32; 2]> = relation
            .edges
            .iter()
            .map(|&[left, right]| {
                let mut edge = [permutation[left as usize], permutation[right as usize]];
                if !relation.directed && edge[0] > edge[1] {
                    edge.swap(0, 1);
                }
                edge
            })
            .collect();
        if mapped != original {
            return Err(ShadowError::Certificate(format!(
                "automorphism does not preserve relation `{}`",
                relation.name
            )));
        }
    }
    Ok(())
}
