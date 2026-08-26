use std::collections::{BTreeMap, BTreeSet, VecDeque};

use serde::{Deserialize, Serialize};

use crate::{
    ActionKind, AmbiguitySpec, BinaryRelation, BranchDecision, CanonicalCertificate,
    DeclaredAction, GatedPaperIi, GatedPaperIii, GatedPaperIv, InputArtifact, PaperIOrientation,
    ProfileInput, RelationalShadow, ShadowError,
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
    let mut checked_automorphisms = 0;
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
                let mut normalized = triangle;
                normalized.sort_unstable();
                if triangle != normalized {
                    return Err(ShadowError::Invalid(
                        "calibrated triangle must be stored in increasing order".into(),
                    ));
                }
                let positive_edges: BTreeSet<_> =
                    paper.shadow.relations[0].edges.iter().copied().collect();
                let triangle_edges = [
                    [triangle[0], triangle[1]],
                    [triangle[0], triangle[2]],
                    [triangle[1], triangle[2]],
                ];
                if triangle_edges
                    .iter()
                    .any(|edge| !positive_edges.contains(edge))
                {
                    return Err(ShadowError::Invalid(
                        "calibrated triangle is not a clique in `orbital_positive`".into(),
                    ));
                }
            }
        }
        ProfileInput::PaperIiTrade(value) => checked_automorphisms = validate_paper_ii(value)?,
        ProfileInput::PaperIiiFourShadow(value) => {
            checked_automorphisms = validate_paper_iii(value)?;
        }
        ProfileInput::PaperIvMinimumWords(value) => {
            checked_automorphisms = validate_paper_iv(value)?;
        }
        ProfileInput::PaperVChordalConference(value) => {
            checked_automorphisms = validate_paper_v(value)?;
        }
    }
    Ok(VerificationReport {
        valid: true,
        canonical_id: None,
        checked_automorphisms,
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
    // This reference search is separate from the producing canonicalizer. It
    // starts from raw relations and trusts neither cached refinement nor hashes.
    let recomputed = match certificate.proof_system.as_str() {
        "paper-i-ir-exhaustion/v1" => reference_canonicalize(input)?,
        "paper-ii-declared-action-exhaustion/v1" => reference_canonicalize_paper_ii(input)?,
        "paper-iii-four-shadow-action-exhaustion/v1" => reference_canonicalize_paper_iii(input)?,
        "paper-iv-weighted-scheme-ir-exhaustion/v1" => reference_canonicalize_paper_iv(input)?,
        "paper-v-marked-conference-action-exhaustion/v1" => reference_canonicalize_paper_v(input)?,
        _ => {
            return Err(ShadowError::Certificate(
                "unsupported canonical proof system".into(),
            ));
        }
    };
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

fn reference_canonicalize_paper_ii(input: &InputArtifact) -> Result<ReferenceResult, ShadowError> {
    validate(input)?;
    let ProfileInput::PaperIiTrade(value) = &input.profile else {
        return Err(ShadowError::Certificate(
            "Paper-II checker received another profile".into(),
        ));
    };
    let group = crate::paper_ii::declared_group(value)?;
    let mut best_key = None;
    let mut best = Vec::new();
    let mut equal = Vec::new();
    for permutation in &group {
        let mut key = BTreeSet::new();
        for block in value.trade_halves.iter().flatten() {
            let mut secants = BTreeSet::new();
            for &encoded in &block.support {
                let mut image = [
                    u32::try_from(permutation[encoded as usize / 12])
                        .expect("Paper-II image fits u32"),
                    u32::try_from(permutation[encoded as usize % 12])
                        .expect("Paper-II image fits u32"),
                ];
                image.sort_unstable();
                secants.insert(image);
            }
            key.insert((block.sign, block.weight, secants));
        }
        match best_key.as_ref().map(|old| key.cmp(old)) {
            None | Some(std::cmp::Ordering::Less) => {
                best_key = Some(key);
                best.clone_from(permutation);
                equal = vec![permutation.clone()];
            }
            Some(std::cmp::Ordering::Equal) => equal.push(permutation.clone()),
            Some(std::cmp::Ordering::Greater) => {}
        }
    }
    let input_to_canonical = best
        .iter()
        .map(|&image| u32::try_from(image).expect("Paper-II image fits u32"))
        .collect::<Vec<_>>();
    let mut automorphisms = equal
        .iter()
        .map(|candidate| {
            let mut inverse = vec![0; candidate.len()];
            for (old, &new) in candidate.iter().enumerate() {
                inverse[new] = old;
            }
            best.iter()
                .map(|&canonical| {
                    u32::try_from(inverse[canonical]).expect("Paper-II image fits u32")
                })
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();
    automorphisms.sort_unstable();
    let canonical =
        crate::canonical::relabel_paper_ii(input, value, &input_to_canonical, &automorphisms)?;
    Ok(ReferenceResult {
        canonical_json: serde_json::to_string(&canonical)?,
        input_to_canonical,
        winning_trace: Vec::new(),
        automorphisms,
        search_stats: crate::SearchStats {
            search_nodes: group.len() as u64,
            canonical_leaves: group.len() as u64,
            refinement_rounds: 0,
            max_depth: 0,
            arena_grows: 0,
        },
    })
}

fn reference_canonicalize_paper_iv(input: &InputArtifact) -> Result<ReferenceResult, ShadowError> {
    validate(input)?;
    let ProfileInput::PaperIvMinimumWords(value) = &input.profile else {
        return Err(ShadowError::Certificate(
            "Paper-IV reference checker received another profile".into(),
        ));
    };
    let search = crate::paper_iv_reference::search(value)?;
    let canonical = crate::canonical::relabel_paper_iv(
        input,
        value,
        &search.input_to_canonical,
        &search.automorphisms,
    );
    Ok(ReferenceResult {
        canonical_json: serde_json::to_string(&canonical)?,
        input_to_canonical: search.input_to_canonical,
        winning_trace: search.winning_trace,
        automorphisms: search.automorphisms,
        search_stats: search.search_stats,
    })
}

fn reference_canonicalize_paper_iii(input: &InputArtifact) -> Result<ReferenceResult, ShadowError> {
    validate(input)?;
    let ProfileInput::PaperIiiFourShadow(value) = &input.profile else {
        return Err(ShadowError::Certificate(
            "Paper-III checker received another profile".into(),
        ));
    };
    let mut permutation = vec![0, 1, 2, 3, 4, 5];
    let mut best_key = None;
    let mut best = Vec::new();
    let mut equal = Vec::new();
    loop {
        let key = value
            .aligned_four_sets
            .iter()
            .map(|four_set| {
                let mut image = four_set.map(|vertex| {
                    u32::try_from(permutation[vertex as usize]).expect("Paper-III image fits u32")
                });
                image.sort_unstable();
                image
            })
            .collect::<BTreeSet<_>>();
        match best_key.as_ref().map(|old| key.cmp(old)) {
            None | Some(std::cmp::Ordering::Less) => {
                best_key = Some(key);
                best.clone_from(&permutation);
                equal = vec![permutation.clone()];
            }
            Some(std::cmp::Ordering::Equal) => equal.push(permutation.clone()),
            Some(std::cmp::Ordering::Greater) => {}
        }
        if !next_permutation(&mut permutation) {
            break;
        }
    }
    let input_to_canonical = best
        .iter()
        .map(|&image| u32::try_from(image).expect("Paper-III image fits u32"))
        .collect::<Vec<_>>();
    let mut automorphisms = equal
        .iter()
        .map(|candidate| {
            let mut inverse = [0; 6];
            for (old, &new) in candidate.iter().enumerate() {
                inverse[new] = old;
            }
            best.iter()
                .map(|&canonical| {
                    u32::try_from(inverse[canonical]).expect("Paper-III image fits u32")
                })
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();
    automorphisms.sort_unstable();
    let canonical = crate::canonical::relabel_paper_iii(input, value, &input_to_canonical)?;
    Ok(ReferenceResult {
        canonical_json: serde_json::to_string(&canonical)?,
        input_to_canonical,
        winning_trace: Vec::new(),
        automorphisms,
        search_stats: crate::SearchStats {
            search_nodes: 720,
            canonical_leaves: 720,
            refinement_rounds: 0,
            max_depth: 0,
            arena_grows: 0,
        },
    })
}

fn reference_canonicalize_paper_v(input: &InputArtifact) -> Result<ReferenceResult, ShadowError> {
    validate(input)?;
    let ProfileInput::PaperVChordalConference(value) = &input.profile else {
        return Err(ShadowError::Certificate(
            "Paper-V checker received another profile".into(),
        ));
    };
    let mut permutation = vec![0, 1, 2, 3, 4, 5];
    let mut best_key = None;
    let mut best = Vec::new();
    let mut equal = Vec::new();
    loop {
        let mut inverse = [0; 6];
        for (old, &new) in permutation.iter().enumerate() {
            inverse[new] = old;
        }
        let mut key = Vec::with_capacity(21);
        for left in 0..6 {
            for right in left + 1..6 {
                key.push(value.delta_matrix[inverse[left]][inverse[right]].numerator);
            }
        }
        for &old in &inverse {
            key.push(
                i64::try_from(permutation[value.outer_involution[old] as usize])
                    .expect("Paper-V image fits i64"),
            );
        }
        match best_key.as_ref().map(|old| key.cmp(old)) {
            None | Some(std::cmp::Ordering::Less) => {
                best_key = Some(key);
                best.clone_from(&permutation);
                equal = vec![permutation.clone()];
            }
            Some(std::cmp::Ordering::Equal) => equal.push(permutation.clone()),
            Some(std::cmp::Ordering::Greater) => {}
        }
        if !next_permutation(&mut permutation) {
            break;
        }
    }
    let input_to_canonical = best
        .iter()
        .map(|&image| u32::try_from(image).expect("Paper-V image fits u32"))
        .collect::<Vec<_>>();
    let mut automorphisms = equal
        .iter()
        .map(|candidate| {
            let mut inverse = [0; 6];
            for (old, &new) in candidate.iter().enumerate() {
                inverse[new] = old;
            }
            best.iter()
                .map(|&canonical| {
                    u32::try_from(inverse[canonical]).expect("Paper-V image fits u32")
                })
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();
    automorphisms.sort_unstable();
    let canonical = crate::canonical::relabel_paper_v(input, value, &input_to_canonical)?;
    Ok(ReferenceResult {
        canonical_json: serde_json::to_string(&canonical)?,
        input_to_canonical,
        winning_trace: Vec::new(),
        automorphisms,
        search_stats: crate::SearchStats {
            search_nodes: 720,
            canonical_leaves: 720,
            refinement_rounds: 0,
            max_depth: 0,
            arena_grows: 0,
        },
    })
}

fn next_permutation(values: &mut [usize]) -> bool {
    let Some(pivot) = (0..values.len() - 1).rfind(|&index| values[index] < values[index + 1])
    else {
        return false;
    };
    let successor = (pivot + 1..values.len())
        .rfind(|&index| values[pivot] < values[index])
        .expect("pivot has a successor");
    values.swap(pivot, successor);
    values[pivot + 1..].reverse();
    true
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
            if old.iter().all(|cell| cell.len() == 1) {
                return old;
            }
            let mut changed = false;
            let mut next = Vec::with_capacity(old.len());
            for cell in &old {
                if cell.len() == 1 {
                    next.push(cell.clone());
                    continue;
                }
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

fn validate_paper_iii(value: &GatedPaperIii) -> Result<usize, ShadowError> {
    if !value.gate.enabled {
        validate_gate("paper_iii_four_shadow", &value.gate)?;
        unreachable!();
    }
    if value.gate.required_export != "verification/sparse_shadow_export.json"
        || value.source.paper != "III"
        || value.source.theorem
            != "arithmetic descent, four-shadow recognition, and calibrated two-graph return"
        || value.source.artifact != "verification/evidence/orientation_source.json"
        || value.source.sha256 != "37c38ff37a9235f94a772eb473e0d6484420978670027e990ee93e89bbad4193"
        || value.branch_sextic != "J_0=0"
        || value.fibre_quadratic_algebra != "Q[t]/(t^2-t-1)"
        || value.vertex_count != 6
        || value.recovered_twist != "z^2=5J_0"
        || value.recovered_two_graph
            != "the order-six conference switching class recovered by four-shadow proportionality"
        || !matches!(
            value.twist_ambiguity,
            AmbiguitySpec::HomogeneousFibre { .. }
        )
        || !matches!(value.complement_ambiguity, AmbiguitySpec::OrientationC2 {})
        || value.calibrated_triangle_product != Some(-1)
    {
        return Err(ShadowError::Invalid(
            "invalid Paper-III source or recovery contract".into(),
        ));
    }
    let AmbiguitySpec::HomogeneousFibre {
        numerator,
        denominator,
    } = &value.twist_ambiguity
    else {
        unreachable!()
    };
    if numerator != "Q^times" || denominator != "(Q^times)^2" {
        return Err(ShadowError::Invalid(
            "invalid Paper-III homogeneous-fibre ambiguity".into(),
        ));
    }
    let expected_point = [(4, 5), (-1, 5), (-1, 5), (-1, 5), (-1, 5)];
    if value.rational_fibre_point.len() != expected_point.len()
        || value.rational_fibre_point.iter().zip(expected_point).any(
            |(actual, (numerator, denominator))| {
                actual.numerator != numerator || actual.denominator != denominator
            },
        )
    {
        return Err(ShadowError::Invalid(
            "invalid Paper-III normalized rational fibre point".into(),
        ));
    }
    let mut four_sets = BTreeSet::new();
    for four_set in &value.aligned_four_sets {
        if four_set.windows(2).any(|pair| pair[0] >= pair[1])
            || four_set.iter().any(|&vertex| vertex >= 6)
            || !four_sets.insert(*four_set)
        {
            return Err(ShadowError::Invalid(
                "Paper-III aligned four-sets are not normalized".into(),
            ));
        }
    }
    if !value.aligned_four_sets.is_empty() {
        return Err(ShadowError::Invalid(
            "the frozen Paper-III conference has an empty aligned family".into(),
        ));
    }
    if value.minimality_collisions.len() != 1
        || value.minimality_collisions[0].boundary != "six_vertices_aligned_family"
        || value.minimality_collisions[0].common_restricted_shadow_blake3
            != "c7bcc87f15491ddc26ab3eb04aaca0dc4b2a6961aa6d15f0e1a2b75d24718a87"
    {
        return Err(ShadowError::Invalid(
            "invalid Paper-III six-point minimality collision".into(),
        ));
    }
    let DeclaredAction::VertexPermutations { degree, generators } = &value.action else {
        return Err(ShadowError::Invalid(
            "Paper-III action must use vertex permutations".into(),
        ));
    };
    if *degree != 6 || generators.is_empty() {
        return Err(ShadowError::Invalid(
            "invalid Paper-III action degree".into(),
        ));
    }
    for generator in generators {
        validate_permutation(generator, 6)?;
    }
    let order = generated_permutation_group_order(generators, 6, 720)?;
    if order != 720 {
        return Err(ShadowError::Invalid(
            "Paper-III generators do not generate S6".into(),
        ));
    }
    Ok(order)
}

#[allow(clippy::too_many_lines)] // One linear exact-contract audit is easier to review atomically.
fn validate_paper_ii(value: &GatedPaperIi) -> Result<usize, ShadowError> {
    if !value.gate.enabled {
        validate_gate("paper_ii_trade", &value.gate)?;
        unreachable!();
    }
    if value.source.paper != "II"
        || value.source.theorem != "quadratic trade, carrier gate, and cubic orientation"
        || value.source.artifact
            != "papers/clebsch-factorization/verification/evidence/profile_incidence.json"
        || value.source.sha256 != "58a81d66c5248f116c3ddd99a33da811c05b5b10c66b4d695f5656b78b977f57"
        || value.field.characteristic != 11
        || value.field.degree != 1
        || !value.field.modulus_coefficients_low_to_high.is_empty()
        || value.field.element_encoding != "least_nonnegative_residue"
        || value.matching_count != 22
        || value.carrier_hypothesis != "complete splitting into secants"
        || value.recovered_carrier != "the 22 H3 matching configurations on P1(F11)"
        || !matches!(value.ambiguity, AmbiguitySpec::OrientationC2 {})
    {
        return Err(ShadowError::Invalid(
            "invalid Paper-II source or recovery contract".into(),
        ));
    }
    if value.trade_halves.iter().any(|half| half.len() != 11) {
        return Err(ShadowError::Invalid(
            "Paper-II trade must have two eleven-block halves".into(),
        ));
    }
    let degree = 12_usize;
    let mut all = BTreeSet::new();
    for (half_index, half) in value.trade_halves.iter().enumerate() {
        let expected_sign = if half_index == 0 { 1 } else { -1 };
        for block in half {
            if block.weight != 1 || block.sign != expected_sign || block.support.len() != 6 {
                return Err(ShadowError::Invalid(
                    "invalid Paper-II signed matching block".into(),
                ));
            }
            let mut vertices = BTreeSet::new();
            for &edge in &block.support {
                let (left, right) = (edge as usize / degree, edge as usize % degree);
                if left >= right || right >= degree {
                    return Err(ShadowError::Invalid(
                        "invalid Paper-II encoded secant".into(),
                    ));
                }
                vertices.insert(left);
                vertices.insert(right);
            }
            if vertices.len() != degree || !all.insert(block.support.clone()) {
                return Err(ShadowError::Invalid(
                    "Paper-II blocks are not distinct perfect matchings".into(),
                ));
            }
        }
    }
    let Some(calibration) = &value.odd_calibration else {
        return Err(ShadowError::Invalid(
            "Paper-II export lacks cubic odd calibration".into(),
        ));
    };
    if calibration.name != "cubic_first_coordinate_mod_11"
        || calibration.value != 6
        || calibration.support != [0, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19]
        || value.minimality_collisions.len() != 2
        || value.minimality_collisions[0].boundary != "degree_1"
        || value.minimality_collisions[1].boundary != "degree_2"
        || value.minimality_collisions[0].common_restricted_shadow_blake3
            != "d308a2f201977287aaea705410e4a01696c24728ed0dbd30e44ea43dcbd9dd5b"
        || value.minimality_collisions[1].common_restricted_shadow_blake3
            != "596b8c429d1cb24e8d9ba9a1ebd4ee76702f21953611482eb0a1e5d7e1fb4734"
    {
        return Err(ShadowError::Invalid(
            "invalid Paper-II cubic/minimality calibration".into(),
        ));
    }
    let DeclaredAction::VertexPermutations {
        degree: action_degree,
        generators,
    } = &value.action
    else {
        return Err(ShadowError::Invalid(
            "Paper-II action must use vertex permutations".into(),
        ));
    };
    if *action_degree != 12 || generators.is_empty() {
        return Err(ShadowError::Invalid(
            "invalid Paper-II action degree".into(),
        ));
    }
    for generator in generators {
        validate_permutation(generator, degree)?;
        let moved = value
            .trade_halves
            .iter()
            .flatten()
            .map(|block| {
                let permutation = generator.iter().map(|&x| x as usize).collect::<Vec<_>>();
                crate::paper_ii::relabel_support(block, &permutation)
            })
            .collect::<Result<BTreeSet<_>, _>>()?;
        if moved != all {
            return Err(ShadowError::Invalid(
                "Paper-II action does not preserve the matching carrier".into(),
            ));
        }
    }
    let order = generated_permutation_group_order(generators, degree, 1320)?;
    if order != 1320 {
        return Err(ShadowError::Invalid(
            "Paper-II generators do not generate PGL2(11)".into(),
        ));
    }
    Ok(order)
}

#[allow(clippy::too_many_lines)] // One linear exact-contract audit is easiest to review.
fn validate_paper_v(value: &crate::GatedPaperV) -> Result<usize, ShadowError> {
    if !value.gate.enabled {
        validate_gate("paper_v_chordal_conference", &value.gate)?;
        unreachable!();
    }
    if value.source.paper != "V"
        || value.source.theorem != "carrier recovery and exact marked return"
        || value.source.artifact
            != "papers/chordal-conference-reconstruction/verification/evidence/conference_node_completeness.json"
        || value.source.sha256 != "2d3621207f01f0243d50b0a22d24d13add9f1e56c6a7a08129fb23f5376bcf4e"
        || !matches!(value.base_field, crate::BaseFieldSpec::Rational)
        || value.verification_field.characteristic != 11
        || value.verification_field.degree != 1
        || !value
            .verification_field
            .modulus_coefficients_low_to_high
            .is_empty()
        || value.verification_field.element_encoding != "least_nonnegative_residue"
        || value.recovered_carrier
            != "singular quartic, twelve points, six axes, and conference switching class"
        || !matches!(value.ambiguity, AmbiguitySpec::OrientationC2 {})
    {
        return Err(ShadowError::Invalid(
            "invalid Paper-V source or recovery contract".into(),
        ));
    }
    let residue = &value.retained_residue;
    if residue.action != crate::ActionKind::ColorPreservingPermutations
        || residue.vertices.len() != 6
        || residue
            .vertices
            .iter()
            .any(|vertex| vertex.color != 0 || vertex.weight != 1 || vertex.sign != 0)
        || residue.relations.len() != 2
        || residue.relations[0].name != "conference_positive"
        || residue.relations[1].name != "conference_negative"
    {
        return Err(ShadowError::Invalid(
            "invalid Paper-V retained residue".into(),
        ));
    }
    for relation in &residue.relations {
        validate_relation(relation, 6)?;
    }
    let positive = residue.relations[0]
        .edges
        .iter()
        .copied()
        .collect::<BTreeSet<_>>();
    let negative = residue.relations[1]
        .edges
        .iter()
        .copied()
        .collect::<BTreeSet<_>>();
    if positive.len() != 10
        || negative.len() != 5
        || !positive.is_disjoint(&negative)
        || positive.len() + negative.len() != 15
    {
        return Err(ShadowError::Invalid(
            "Paper-V conference signs do not partition K6".into(),
        ));
    }
    if value.delta_matrix.len() != 6 || value.delta_matrix.iter().any(|row| row.len() != 6) {
        return Err(ShadowError::Invalid(
            "Paper-V delta matrix is not six by six".into(),
        ));
    }
    for row in 0..6 {
        for column in 0..6 {
            let entry = &value.delta_matrix[row][column];
            let expected = if row == column {
                0
            } else if positive.contains(&[
                u32::try_from(row.min(column)).expect("Paper-V index fits u32"),
                u32::try_from(row.max(column)).expect("Paper-V index fits u32"),
            ]) {
                1
            } else {
                -1
            };
            if entry.denominator != 1
                || entry.numerator != expected
                || value.delta_matrix[row][column] != value.delta_matrix[column][row]
            {
                return Err(ShadowError::Invalid(
                    "Paper-V delta matrix disagrees with residue".into(),
                ));
            }
        }
    }
    for row in 0..6 {
        for column in 0..6 {
            let square: i64 = (0..6)
                .map(|middle| {
                    value.delta_matrix[row][middle].numerator
                        * value.delta_matrix[middle][column].numerator
                })
                .sum();
            if square != if row == column { 5 } else { 0 } {
                return Err(ShadowError::Invalid(
                    "Paper-V delta matrix does not square to 5I".into(),
                ));
            }
        }
    }
    validate_permutation(&value.outer_involution, 6)?;
    let square = compose_u32(&value.outer_involution, &value.outer_involution);
    let fourth = compose_u32(&square, &square);
    if square == (0_u32..6).collect::<Vec<_>>() || fourth != (0_u32..6).collect::<Vec<_>>() {
        return Err(ShadowError::Invalid(
            "Paper-V outer lift must have order four".into(),
        ));
    }
    let DeclaredAction::VertexPermutations { degree, generators } = &value.action else {
        return Err(ShadowError::Invalid(
            "Paper-V action must use vertex permutations".into(),
        ));
    };
    if *degree != 6 || generators.is_empty() {
        return Err(ShadowError::Invalid("invalid Paper-V action degree".into()));
    }
    for generator in generators {
        validate_permutation(generator, 6)?;
    }
    let order = generated_permutation_group_order(generators, 6, 720)?;
    if order != 720 {
        return Err(ShadowError::Invalid(
            "Paper-V action does not generate S6".into(),
        ));
    }
    let points_valid = |points: &[Vec<u32>], count: usize| {
        points.len() == count
            && points
                .iter()
                .all(|point| point.len() == 5 && point.iter().all(|&x| x < 11))
            && points.iter().collect::<BTreeSet<_>>().len() == count
    };
    if !points_valid(&value.conference_singular_points, 6)
        || !points_valid(&value.chordal_singular_points, 12)
        || value.conference_cubic.len() != 35
        || value.chordal_cubic.len() != 35
        || value
            .conference_cubic
            .iter()
            .chain(&value.chordal_cubic)
            .any(|&x| x >= 11)
    {
        return Err(ShadowError::Invalid(
            "invalid Paper-V cubic or singular-point census".into(),
        ));
    }
    let Some(calibration) = &value.odd_calibration else {
        return Err(ShadowError::Invalid(
            "Paper-V selected-line calibration is absent".into(),
        ));
    };
    if value.selected_chordal_line != Some(0)
        || calibration.name != "selected_chordal_line"
        || calibration.support != [0]
        || calibration.value != 1
        || !value.minimality_collisions.is_empty()
    {
        return Err(ShadowError::Invalid(
            "invalid Paper-V selected-line calibration".into(),
        ));
    }
    Ok(order)
}

fn compose_u32(left: &[u32], right: &[u32]) -> Vec<u32> {
    right.iter().map(|&image| left[image as usize]).collect()
}

fn validate_paper_iv(value: &GatedPaperIv) -> Result<usize, ShadowError> {
    if !value.gate.enabled {
        validate_gate("paper_iv_minimum_words", &value.gate)?;
        unreachable!();
    }
    if value.field.characteristic != 13
        || value.field.degree != 1
        || !value.field.modulus_coefficients_low_to_high.is_empty()
        || value.field.element_encoding != "least_nonnegative_residue"
        || value.coordinate_count != 78
        || value.minimum_support_count != 364
    {
        return Err(ShadowError::Invalid(
            "invalid Paper-IV field or census contract".into(),
        ));
    }
    if value.recovered_carrier != "PG(2,13), conic, and polarity"
        || !matches!(&value.ambiguity, AmbiguitySpec::MarkingTorsor { group } if group == "PGL2(13)")
    {
        return Err(ShadowError::Invalid(
            "invalid Paper-IV recovery contract".into(),
        ));
    }
    if value.source.paper != "IV"
        || value.source.theorem != "exact arity-two minimum-word reconstruction"
        || value.source.artifact != "papers/q13-passant-code/verification/pair_reconstruction.json"
        || value.source.sha256 != "cb9c1da169cef5f23402bb87d28d4f5885ddecb9ae7d92f784803a2d9d8d0ae6"
    {
        return Err(ShadowError::Invalid(
            "invalid Paper-IV frozen-source identity".into(),
        ));
    }

    let degree = value.coordinate_count as usize;
    let mut weights = vec![0_u32; degree * degree];
    let mut distribution = BTreeMap::<u32, usize>::new();
    for pair in &value.weighted_pair_section {
        let (left, right) = (pair.left as usize, pair.right as usize);
        if left >= right || right >= degree || weights[left * degree + right] != 0 {
            return Err(ShadowError::Invalid(
                "Paper-IV pair section is not a simple complete upper triangle".into(),
            ));
        }
        weights[left * degree + right] = pair.multiplicity;
        weights[right * degree + left] = pair.multiplicity;
        *distribution.entry(pair.multiplicity).or_default() += 1;
    }
    if value.weighted_pair_section.len() != degree * (degree - 1) / 2
        || distribution != BTreeMap::from([(6, 1092), (7, 546), (8, 273), (9, 546), (12, 546)])
    {
        return Err(ShadowError::Invalid(
            "invalid Paper-IV pair-concurrence distribution".into(),
        ));
    }

    let DeclaredAction::VertexPermutations {
        degree: action_degree,
        generators,
    } = &value.action
    else {
        return Err(ShadowError::Invalid(
            "Paper-IV action must use vertex permutations".into(),
        ));
    };
    if *action_degree as usize != degree || generators.is_empty() {
        return Err(ShadowError::Invalid(
            "invalid Paper-IV action degree or generator set".into(),
        ));
    }
    for generator in generators {
        validate_permutation(generator, degree)?;
        for left in 0..degree {
            for right in left + 1..degree {
                let image_left = generator[left] as usize;
                let image_right = generator[right] as usize;
                if weights[left * degree + right] != weights[image_left * degree + image_right] {
                    return Err(ShadowError::Invalid(
                        "Paper-IV generator does not preserve pair weights".into(),
                    ));
                }
            }
        }
    }
    let group_order = generated_permutation_group_order(generators, degree, 2184)?;
    if group_order != 2184 {
        return Err(ShadowError::Invalid(
            "Paper-IV generators do not generate PGL2(13)".into(),
        ));
    }
    Ok(group_order)
}

fn validate_permutation(permutation: &[u32], degree: usize) -> Result<(), ShadowError> {
    let image = permutation.iter().copied().collect::<BTreeSet<_>>();
    if permutation.len() != degree
        || image.len() != degree
        || image.iter().any(|&point| point as usize >= degree)
    {
        return Err(ShadowError::Invalid(
            "action generator is not a permutation".into(),
        ));
    }
    Ok(())
}

fn generated_permutation_group_order(
    generators: &[Vec<u32>],
    degree: usize,
    limit: usize,
) -> Result<usize, ShadowError> {
    let degree_u32 = u32::try_from(degree)
        .map_err(|_| ShadowError::Invalid("action degree exceeds u32".into()))?;
    let identity = (0..degree_u32).collect::<Vec<_>>();
    let mut seen = BTreeSet::from([identity.clone()]);
    let mut pending = VecDeque::from([identity]);
    while let Some(element) = pending.pop_front() {
        for generator in generators {
            let product = (0..degree)
                .map(|point| generator[element[point] as usize])
                .collect::<Vec<_>>();
            if seen.insert(product.clone()) {
                if seen.len() > limit {
                    return Err(ShadowError::Invalid(
                        "action closure exceeds declared group order".into(),
                    ));
                }
                pending.push_back(product);
            }
        }
    }
    Ok(seen.len())
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

#[allow(clippy::too_many_lines)]
fn verify_automorphism(input: &InputArtifact, permutation: &[u32]) -> Result<(), ShadowError> {
    if let ProfileInput::PaperIiiFourShadow(value) = &input.profile {
        validate_permutation(permutation, 6)
            .map_err(|error| ShadowError::Certificate(error.to_string()))?;
        let permutation = permutation
            .iter()
            .map(|&image| image as usize)
            .collect::<Vec<_>>();
        if crate::paper_iii::relabel_four_sets(&value.aligned_four_sets, &permutation)
            != value.aligned_four_sets
        {
            return Err(ShadowError::Certificate(
                "automorphism does not preserve the Paper-III aligned family".into(),
            ));
        }
        return Ok(());
    }
    if let ProfileInput::PaperVChordalConference(value) = &input.profile {
        validate_permutation(permutation, 6)
            .map_err(|error| ShadowError::Certificate(error.to_string()))?;
        for row in 0..6 {
            for column in 0..6 {
                if value.delta_matrix[row][column]
                    != value.delta_matrix[permutation[row] as usize][permutation[column] as usize]
                {
                    return Err(ShadowError::Certificate(
                        "automorphism does not preserve the Paper-V delta matrix".into(),
                    ));
                }
            }
            if permutation[value.outer_involution[row] as usize]
                != value.outer_involution[permutation[row] as usize]
            {
                return Err(ShadowError::Certificate(
                    "automorphism does not centralize the Paper-V outer lift".into(),
                ));
            }
        }
        return Ok(());
    }
    if let ProfileInput::PaperIiTrade(value) = &input.profile {
        validate_permutation(permutation, 12)
            .map_err(|error| ShadowError::Certificate(error.to_string()))?;
        let expected = value
            .trade_halves
            .iter()
            .flatten()
            .map(|block| (block.sign, block.weight, block.support.clone()))
            .collect::<BTreeSet<_>>();
        let permutation = permutation
            .iter()
            .map(|&image| image as usize)
            .collect::<Vec<_>>();
        let actual = value
            .trade_halves
            .iter()
            .flatten()
            .map(|block| {
                Ok((
                    block.sign,
                    block.weight,
                    crate::paper_ii::relabel_support(block, &permutation)?,
                ))
            })
            .collect::<Result<BTreeSet<_>, ShadowError>>()?;
        if actual != expected {
            return Err(ShadowError::Certificate(
                "automorphism does not preserve the oriented Paper-II trade".into(),
            ));
        }
        return Ok(());
    }
    if let ProfileInput::PaperIvMinimumWords(value) = &input.profile {
        let degree = value.coordinate_count as usize;
        validate_permutation(permutation, degree)
            .map_err(|error| ShadowError::Certificate(error.to_string()))?;
        let weights = value
            .weighted_pair_section
            .iter()
            .map(|pair| ([pair.left, pair.right], pair.multiplicity))
            .collect::<BTreeMap<_, _>>();
        for pair in &value.weighted_pair_section {
            let mut image = [
                permutation[pair.left as usize],
                permutation[pair.right as usize],
            ];
            image.sort_unstable();
            if weights.get(&image) != Some(&pair.multiplicity) {
                return Err(ShadowError::Certificate(
                    "automorphism does not preserve Paper-IV pair weights".into(),
                ));
            }
        }
        return Ok(());
    }
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
