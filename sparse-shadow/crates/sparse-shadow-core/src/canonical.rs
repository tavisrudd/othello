use std::collections::BTreeSet;

use serde::{Deserialize, Serialize};

use crate::{
    BinaryRelation, InputArtifact, PaperIOrientation, ProfileInput, RelationalShadow, ShadowError,
    validate,
};

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SearchStats {
    pub search_nodes: u64,
    pub canonical_leaves: u64,
    pub refinement_rounds: u64,
    pub max_depth: u32,
    pub arena_grows: u64,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct BranchDecision {
    pub depth: u32,
    pub cell: Vec<u32>,
    pub chosen_vertex: u32,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct CanonicalCertificate {
    pub certificate_schema: String,
    pub proof_system: String,
    pub input_to_canonical: Vec<u32>,
    pub canonical_json: String,
    pub canonical_id: String,
    pub winning_trace: Vec<BranchDecision>,
    pub automorphisms: Vec<Vec<u32>>,
    pub search_stats: SearchStats,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct CanonicalArtifact {
    pub schema: String,
    pub canonical_id: String,
    pub canonical: InputArtifact,
    pub input_to_canonical: Vec<u32>,
    pub automorphism_generators: Vec<Vec<u32>>,
    pub automorphism_order: u64,
    pub vertex_orbits: Vec<Vec<u32>>,
    pub stats: SearchStats,
    pub certificate: CanonicalCertificate,
}

/// Compute the deterministic canonical form and replay certificate.
///
/// # Errors
///
/// Returns an error when the schema or profile is invalid or gated, or when a
/// canonical artifact cannot be represented by schema v1.
pub fn canonicalize(input: &InputArtifact) -> Result<CanonicalArtifact, ShadowError> {
    validate(input)?;
    let ProfileInput::PaperIOrientation(paper) = &input.profile else {
        return Err(gated_error(&input.profile));
    };

    let search = crate::hot::search(paper);
    let canonical = relabel(paper, &search.best_permutation);
    let canonical_json = serde_json::to_string(&canonical)?;
    let input_to_canonical = to_u32_permutation(&search.best_permutation)?;
    let automorphisms = automorphisms(&search.best_permutation, &search.equal_permutations)?;
    let automorphism_generators = generating_set(&automorphisms);
    let vertex_orbits = permutation_orbits(paper.shadow.vertices.len(), &automorphisms)?;
    let canonical_id = blake3::hash(canonical_json.as_bytes()).to_hex().to_string();
    let automorphism_order = u64::try_from(automorphisms.len())
        .map_err(|_| ShadowError::Invalid("automorphism count exceeds u64".into()))?;
    let certificate = CanonicalCertificate {
        certificate_schema: "sparse-shadow-certificate/v1".into(),
        proof_system: "paper-i-ir-exhaustion/v1".into(),
        input_to_canonical: input_to_canonical.clone(),
        canonical_json,
        canonical_id: canonical_id.clone(),
        winning_trace: search.winning_trace,
        automorphisms: automorphisms.clone(),
        search_stats: search.stats.clone(),
    };

    Ok(CanonicalArtifact {
        schema: "sparse-shadow-canonical/v1".into(),
        canonical_id,
        canonical,
        input_to_canonical,
        automorphism_generators,
        automorphism_order,
        vertex_orbits,
        stats: search.stats,
        certificate,
    })
}

pub(crate) fn verify_canonical_artifact_fields(
    artifact: &CanonicalArtifact,
) -> Result<(), ShadowError> {
    let certificate = &artifact.certificate;
    if artifact.schema != "sparse-shadow-canonical/v1"
        || artifact.canonical_id != certificate.canonical_id
        || artifact.input_to_canonical != certificate.input_to_canonical
        || artifact.stats != certificate.search_stats
    {
        return Err(ShadowError::Certificate(
            "canonical artifact wrapper differs from its certificate".into(),
        ));
    }
    if serde_json::to_string(&artifact.canonical)? != certificate.canonical_json {
        return Err(ShadowError::Certificate(
            "canonical artifact payload differs from its certificate".into(),
        ));
    }
    let expected_order = u64::try_from(certificate.automorphisms.len())
        .map_err(|_| ShadowError::Certificate("automorphism count exceeds u64".into()))?;
    if artifact.automorphism_order != expected_order {
        return Err(ShadowError::Certificate(
            "canonical artifact automorphism order differs from its certificate".into(),
        ));
    }

    let degree = artifact.input_to_canonical.len();
    for generator in &artifact.automorphism_generators {
        validate_permutation(generator, degree)?;
    }
    let expected: BTreeSet<_> = certificate.automorphisms.iter().cloned().collect();
    let generated = generated_closure_within(degree, &artifact.automorphism_generators, &expected)?;
    if generated != expected {
        return Err(ShadowError::Certificate(
            "canonical artifact generators do not close to the certified automorphism group".into(),
        ));
    }
    if artifact.vertex_orbits != permutation_orbits(degree, &certificate.automorphisms)? {
        return Err(ShadowError::Certificate(
            "canonical artifact vertex orbits differ from its certificate".into(),
        ));
    }
    Ok(())
}

fn generated_closure_within(
    degree: usize,
    generators: &[Vec<u32>],
    expected: &BTreeSet<Vec<u32>>,
) -> Result<BTreeSet<Vec<u32>>, ShadowError> {
    let identity: Vec<u32> = (0..degree)
        .map(|value| u32::try_from(value).expect("validated degree fits u32"))
        .collect();
    if !expected.contains(&identity)
        || generators
            .iter()
            .any(|generator| !expected.contains(generator))
    {
        return Err(ShadowError::Certificate(
            "canonical artifact generator is outside the certified automorphism group".into(),
        ));
    }
    let mut closure = BTreeSet::from([identity.clone()]);
    let mut frontier = vec![identity];
    while let Some(element) = frontier.pop() {
        for generator in generators {
            let product: Vec<u32> = element
                .iter()
                .map(|&image| generator[image as usize])
                .collect();
            if !expected.contains(&product) {
                return Err(ShadowError::Certificate(
                    "canonical artifact generators leave the certified automorphism group".into(),
                ));
            }
            if closure.insert(product.clone()) {
                frontier.push(product);
            }
        }
    }
    Ok(closure)
}

fn validate_permutation(permutation: &[u32], degree: usize) -> Result<(), ShadowError> {
    let image: BTreeSet<_> = permutation.iter().copied().collect();
    if permutation.len() != degree
        || image.len() != degree
        || image.iter().any(|&vertex| vertex as usize >= degree)
    {
        return Err(ShadowError::Certificate(
            "canonical artifact generator is not a permutation".into(),
        ));
    }
    Ok(())
}

fn gated_error(profile: &ProfileInput) -> ShadowError {
    let (name, gate) = match profile {
        ProfileInput::PaperIiTrade(value) => ("paper_ii_trade", &value.gate),
        ProfileInput::PaperIiiFourShadow(value) => ("paper_iii_four_shadow", &value.gate),
        ProfileInput::PaperIvMinimumWords(value) => ("paper_iv_minimum_words", &value.gate),
        ProfileInput::PaperVChordalConference(value) => ("paper_v_chordal_conference", &value.gate),
        ProfileInput::PaperIOrientation(_) => unreachable!(),
    };
    ShadowError::ProfileGated {
        profile: name,
        reason: format!("{}; required export: {}", gate.reason, gate.required_export),
    }
}

fn relabel(paper: &PaperIOrientation, permutation: &[usize]) -> InputArtifact {
    let n = paper.shadow.vertices.len();
    let mut vertices = vec![paper.shadow.vertices[0].clone(); n];
    for (old, &new) in permutation.iter().enumerate() {
        vertices[new] = paper.shadow.vertices[old].clone();
    }
    let relations = paper
        .shadow
        .relations
        .iter()
        .map(|relation| relabel_relation(relation, permutation))
        .collect();
    let calibrated_triangle = paper.calibrated_triangle.map(|triangle| {
        let mut mapped = triangle.map(|vertex| index_u32(permutation[vertex as usize]));
        mapped.sort_unstable();
        mapped
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

fn relabel_relation(relation: &BinaryRelation, permutation: &[usize]) -> BinaryRelation {
    let mut edges: Vec<[u32; 2]> = relation
        .edges
        .iter()
        .map(|&[left, right]| {
            let mut mapped = [
                index_u32(permutation[left as usize]),
                index_u32(permutation[right as usize]),
            ];
            if !relation.directed && mapped[0] > mapped[1] {
                mapped.swap(0, 1);
            }
            mapped
        })
        .collect();
    edges.sort_unstable();
    BinaryRelation {
        name: relation.name.clone(),
        directed: relation.directed,
        edges,
    }
}

fn automorphisms(best: &[usize], equal: &[Vec<usize>]) -> Result<Vec<Vec<u32>>, ShadowError> {
    let mut result = BTreeSet::new();
    for leaf in equal {
        let mut inverse = vec![0; leaf.len()];
        for (old, &canonical) in leaf.iter().enumerate() {
            inverse[canonical] = old;
        }
        let automorphism: Vec<u32> = best
            .iter()
            .map(|&canonical| u32::try_from(inverse[canonical]))
            .collect::<Result<_, _>>()
            .map_err(|_| ShadowError::Invalid("vertex index exceeds u32".into()))?;
        result.insert(automorphism);
    }
    Ok(result.into_iter().collect())
}

fn generating_set(group: &[Vec<u32>]) -> Vec<Vec<u32>> {
    let Some(first) = group.first() else {
        return Vec::new();
    };
    let identity: Vec<u32> = (0..first.len())
        .map(|value| u32::try_from(value).expect("validated degree fits u32"))
        .collect();
    let mut generators = Vec::new();
    let mut generated = BTreeSet::from([identity]);
    for candidate in group {
        if !generated.contains(candidate) {
            generators.push(candidate.clone());
            generated = generated_closure(first.len(), &generators);
            if generated.len() == group.len() {
                break;
            }
        }
    }
    generators
}

fn generated_closure(degree: usize, generators: &[Vec<u32>]) -> BTreeSet<Vec<u32>> {
    let identity: Vec<u32> = (0..degree)
        .map(|value| u32::try_from(value).expect("validated degree fits u32"))
        .collect();
    let mut closure = BTreeSet::from([identity.clone()]);
    let mut frontier = vec![identity];
    while let Some(element) = frontier.pop() {
        for generator in generators {
            let product: Vec<u32> = element
                .iter()
                .map(|&image| generator[image as usize])
                .collect();
            if closure.insert(product.clone()) {
                frontier.push(product);
            }
        }
    }
    closure
}

fn permutation_orbits(n: usize, automorphisms: &[Vec<u32>]) -> Result<Vec<Vec<u32>>, ShadowError> {
    let mut parent: Vec<usize> = (0..n).collect();
    for permutation in automorphisms {
        for (left, &right) in permutation.iter().enumerate() {
            union(&mut parent, left, right as usize);
        }
    }
    let mut roots = std::collections::BTreeMap::<usize, Vec<u32>>::new();
    for vertex in 0..n {
        let root = find(&mut parent, vertex);
        roots.entry(root).or_default().push(
            u32::try_from(vertex)
                .map_err(|_| ShadowError::Invalid("vertex index exceeds u32".into()))?,
        );
    }
    Ok(roots.into_values().collect())
}

fn find(parent: &mut [usize], vertex: usize) -> usize {
    if parent[vertex] != vertex {
        parent[vertex] = find(parent, parent[vertex]);
    }
    parent[vertex]
}

fn union(parent: &mut [usize], left: usize, right: usize) {
    let left_root = find(parent, left);
    let right_root = find(parent, right);
    if left_root != right_root {
        parent[right_root] = left_root;
    }
}

fn to_u32_permutation(permutation: &[usize]) -> Result<Vec<u32>, ShadowError> {
    permutation
        .iter()
        .map(|&value| {
            u32::try_from(value)
                .map_err(|_| ShadowError::Invalid("vertex index exceeds u32".into()))
        })
        .collect()
}

fn index_u32(value: usize) -> u32 {
    u32::try_from(value).expect("validated vertex count fits u32")
}
