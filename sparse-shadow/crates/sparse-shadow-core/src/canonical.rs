use std::collections::BTreeSet;

use serde::{Deserialize, Serialize};

use crate::{
    BinaryRelation, InputArtifact, PaperIOrientation, ProfileInput, RelationalShadow, ShadowError,
    Vertex, validate,
};

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SearchStats {
    pub search_nodes: u64,
    pub canonical_leaves: u64,
    pub refinement_rounds: u64,
    pub max_depth: u32,
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
    pub input_to_canonical: Vec<u32>,
    pub canonical_json: String,
    pub canonical_id: String,
    pub winning_trace: Vec<BranchDecision>,
    pub automorphisms: Vec<Vec<u32>>,
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

#[derive(Clone)]
struct DenseRelation {
    directed: bool,
    adjacency: Vec<Vec<bool>>,
}

struct Search<'a> {
    paper: &'a PaperIOrientation,
    dense: Vec<DenseRelation>,
    best_json: Option<String>,
    best_permutation: Vec<usize>,
    winning_trace: Vec<BranchDecision>,
    equal_permutations: Vec<Vec<usize>>,
    stats: SearchStats,
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

    let dense = dense_relations(&paper.shadow);
    let mut search = Search {
        paper,
        dense,
        best_json: None,
        best_permutation: Vec::new(),
        winning_trace: Vec::new(),
        equal_permutations: Vec::new(),
        stats: SearchStats {
            search_nodes: 0,
            canonical_leaves: 0,
            refinement_rounds: 0,
            max_depth: 0,
        },
    };
    let partition = initial_partition(&paper.shadow.vertices);
    search.visit(partition, &mut Vec::new(), 0)?;

    let canonical_json = search
        .best_json
        .clone()
        .ok_or_else(|| ShadowError::Invalid("canonical search produced no leaf".into()))?;
    let canonical: InputArtifact = serde_json::from_str(&canonical_json)?;
    let input_to_canonical = to_u32_permutation(&search.best_permutation)?;
    let automorphisms = automorphisms(&search.best_permutation, &search.equal_permutations)?;
    let vertex_orbits = permutation_orbits(paper.shadow.vertices.len(), &automorphisms)?;
    let canonical_id = blake3::hash(canonical_json.as_bytes()).to_hex().to_string();
    let automorphism_order = u64::try_from(automorphisms.len())
        .map_err(|_| ShadowError::Invalid("automorphism count exceeds u64".into()))?;
    let certificate = CanonicalCertificate {
        certificate_schema: "sparse-shadow-certificate/v1".into(),
        input_to_canonical: input_to_canonical.clone(),
        canonical_json,
        canonical_id: canonical_id.clone(),
        winning_trace: search.winning_trace,
        automorphisms: automorphisms.clone(),
    };

    Ok(CanonicalArtifact {
        schema: "sparse-shadow-canonical/v1".into(),
        canonical_id,
        canonical,
        input_to_canonical,
        automorphism_generators: automorphisms.clone(),
        automorphism_order,
        vertex_orbits,
        stats: search.stats,
        certificate,
    })
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
        reason: gate.reason.clone(),
    }
}

impl Search<'_> {
    fn visit(
        &mut self,
        mut partition: Vec<Vec<usize>>,
        trace: &mut Vec<BranchDecision>,
        depth: u32,
    ) -> Result<(), ShadowError> {
        self.stats.search_nodes += 1;
        self.stats.max_depth = self.stats.max_depth.max(depth);
        self.refine(&mut partition);
        if partition.iter().all(|cell| cell.len() == 1) {
            self.stats.canonical_leaves += 1;
            let order: Vec<usize> = partition.iter().map(|cell| cell[0]).collect();
            let permutation = inverse_order(&order);
            let candidate = relabel(self.paper, &permutation);
            let json = serde_json::to_string(&candidate)?;
            match self.best_json.as_ref() {
                None => self.install_best(json, permutation, trace),
                Some(best) if json < *best => self.install_best(json, permutation, trace),
                Some(best) if json == *best => self.equal_permutations.push(permutation),
                Some(_) => {}
            }
            return Ok(());
        }

        let cell_index = partition
            .iter()
            .enumerate()
            .filter(|(_, cell)| cell.len() > 1)
            .min_by_key(|(_, cell)| cell.len())
            .map(|(index, _)| index)
            .expect("non-discrete partition has a non-singleton cell");
        let candidates = partition[cell_index].clone();
        for vertex in candidates.iter().copied() {
            trace.push(BranchDecision {
                depth,
                cell: candidates.iter().map(|&v| index_u32(v)).collect(),
                chosen_vertex: index_u32(vertex),
            });
            let mut child = partition.clone();
            let rest: Vec<usize> = child[cell_index]
                .iter()
                .copied()
                .filter(|&v| v != vertex)
                .collect();
            child.splice(cell_index..=cell_index, [vec![vertex], rest]);
            self.visit(child, trace, depth + 1)?;
            trace.pop();
        }
        Ok(())
    }

    fn install_best(&mut self, json: String, permutation: Vec<usize>, trace: &[BranchDecision]) {
        self.best_json = Some(json);
        self.best_permutation.clone_from(&permutation);
        self.winning_trace = trace.to_vec();
        self.equal_permutations.clear();
        self.equal_permutations.push(permutation);
    }

    fn refine(&mut self, partition: &mut Vec<Vec<usize>>) {
        loop {
            self.stats.refinement_rounds += 1;
            let old = partition.clone();
            let mut changed = false;
            let mut refined = Vec::with_capacity(old.len());
            for cell in &old {
                let mut buckets: Vec<(Vec<u32>, Vec<usize>)> = Vec::new();
                for &vertex in cell {
                    let signature = self.signature(vertex, &old);
                    match buckets.iter_mut().find(|(key, _)| *key == signature) {
                        Some((_, vertices)) => vertices.push(vertex),
                        None => buckets.push((signature, vec![vertex])),
                    }
                }
                buckets.sort_by(|left, right| left.0.cmp(&right.0));
                changed |= buckets.len() > 1;
                refined.extend(buckets.into_iter().map(|(_, vertices)| vertices));
            }
            *partition = refined;
            if !changed {
                break;
            }
        }
    }

    fn signature(&self, vertex: usize, partition: &[Vec<usize>]) -> Vec<u32> {
        let mut signature = Vec::with_capacity(self.dense.len() * partition.len() * 2 + 3);
        let data = &self.paper.shadow.vertices[vertex];
        signature.push(data.color);
        signature.extend(data.weight.to_be_bytes().map(u32::from));
        signature.push(u32::from_ne_bytes(i32::from(data.sign).to_ne_bytes()));
        for relation in &self.dense {
            for cell in partition {
                let outgoing = u32::try_from(
                    cell.iter()
                        .filter(|&&other| relation.adjacency[vertex][other])
                        .count(),
                )
                .expect("validated vertex count fits u32");
                signature.push(outgoing);
                if relation.directed {
                    let incoming = u32::try_from(
                        cell.iter()
                            .filter(|&&other| relation.adjacency[other][vertex])
                            .count(),
                    )
                    .expect("validated vertex count fits u32");
                    signature.push(incoming);
                }
            }
        }
        if let Some(triangle) = self.paper.calibrated_triangle {
            signature.push(u32::from(triangle.contains(&index_u32(vertex))));
        }
        signature
    }
}

fn initial_partition(vertices: &[Vertex]) -> Vec<Vec<usize>> {
    let mut keyed: Vec<(Vertex, usize)> = vertices.iter().cloned().zip(0..vertices.len()).collect();
    keyed.sort_by(|left, right| left.0.cmp(&right.0));
    let mut partition: Vec<Vec<usize>> = Vec::new();
    for (key, vertex) in keyed {
        match partition.last_mut() {
            Some(cell) if vertices[cell[0]] == key => cell.push(vertex),
            _ => partition.push(vec![vertex]),
        }
    }
    partition
}

fn dense_relations(shadow: &RelationalShadow) -> Vec<DenseRelation> {
    let n = shadow.vertices.len();
    shadow
        .relations
        .iter()
        .map(|relation| {
            let mut adjacency = vec![vec![false; n]; n];
            for &[left, right] in &relation.edges {
                adjacency[left as usize][right as usize] = true;
                if !relation.directed {
                    adjacency[right as usize][left as usize] = true;
                }
            }
            DenseRelation {
                directed: relation.directed,
                adjacency,
            }
        })
        .collect()
}

fn inverse_order(order: &[usize]) -> Vec<usize> {
    let mut permutation = vec![0; order.len()];
    for (new, &old) in order.iter().enumerate() {
        permutation[old] = new;
    }
    permutation
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
            theorem_locator: paper.theorem_locator.clone(),
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
