// C294 B3 E2: transition-stable typed 02-square frontier quotient.
//
// This is deliberately an offline audit of the frozen E1 prefixes.  It starts
// from E1's value-blind typed-square coordinate and repeatedly refines by the
// complete set of typed Node--Kayles transitions.  High/low-cycle connected
// successors remain symbolic classes; path, tree, and unicyclic debris enters
// an exact detached nimber-xor bank.  State nimbers are consulted only after
// the stable partition has been constructed.
#define C294_RELEVANCE_LEDGER_NO_MAIN
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-function"
#include "2026-07-17-c294-b3-relevance-ledger.cpp"
#pragma GCC diagnostic pop
#undef C294_RELEVANCE_LEDGER_NO_MAIN

#include <functional>
#include <tuple>

struct TypedMove {
    std::vector<int> label;
    int detached_xor = 0;
    std::vector<int> symbolic_children;

    bool operator<(const TypedMove &other) const {
        return std::tie(label, detached_xor, symbolic_children) <
               std::tie(other.label, other.detached_xor, other.symbolic_children);
    }
    bool operator==(const TypedMove &other) const {
        return label == other.label && detached_xor == other.detached_xor &&
               symbolic_children == other.symbolic_children;
    }
};

struct TypedNode {
    Mask mask{};
    int value = -1;
    int base_class = -1;
    std::vector<TypedMove> moves;
};

struct MergerWitness {
    bool present = false;
    Mask prior{};
    Mask current{};
    int prior_value = -1;
    int current_value = -1;
    int stable_class = -1;
};

static int block_word(Mask mask, int block, const CoordinateInput &coordinate) {
    int result = 0;
    for (int vertex : coordinate.blocks[block]) {
        if (!empty(mask & singleton(vertex))) result |= 1 << coordinate.position[vertex];
    }
    return result;
}

static std::vector<int> local_move_label(
    Mask mask, int vertex, const CoordinateInput &coordinate
) {
    int block = coordinate.block[vertex];
    int third = coordinate.targets[vertex][1];
    int third_block = coordinate.block[third];
    int live_neighbour_bits = 0;
    for (int colour = 0; colour < 3; ++colour) {
        if (!empty(mask & singleton(coordinate.targets[vertex][colour]))) {
            live_neighbour_bits |= 1 << colour;
        }
    }
    return {
        coordinate.sheet[vertex],
        coordinate.position[vertex],
        block_word(mask, block, coordinate),
        live_neighbour_bits,
        coordinate.sheet[third],
        coordinate.position[third],
        block_word(mask, third_block, coordinate),
    };
}

static std::vector<int> encode_signature(
    int base_class, const std::vector<TypedMove> &moves,
    const std::vector<int> &classes
) {
    std::vector<TypedMove> refined;
    refined.reserve(moves.size());
    for (const TypedMove &move : moves) {
        TypedMove current;
        current.label = move.label;
        current.detached_xor = move.detached_xor;
        current.symbolic_children.reserve(move.symbolic_children.size());
        for (int child : move.symbolic_children) {
            current.symbolic_children.push_back(classes[child]);
        }
        std::sort(current.symbolic_children.begin(), current.symbolic_children.end());
        refined.push_back(std::move(current));
    }
    std::sort(refined.begin(), refined.end());
    refined.erase(std::unique(refined.begin(), refined.end()), refined.end());
    std::vector<int> result{base_class, static_cast<int>(refined.size())};
    for (const TypedMove &move : refined) {
        result.push_back(static_cast<int>(move.label.size()));
        result.insert(result.end(), move.label.begin(), move.label.end());
        result.push_back(move.detached_xor);
        result.push_back(static_cast<int>(move.symbolic_children.size()));
        result.insert(
            result.end(), move.symbolic_children.begin(), move.symbolic_children.end()
        );
    }
    return result;
}

static std::vector<int> refine_partition(
    const std::vector<TypedNode> &nodes, int &rounds, std::vector<int> &class_counts
) {
    std::vector<int> classes(nodes.size());
    for (size_t index = 0; index < nodes.size(); ++index) {
        classes[index] = nodes[index].base_class;
    }
    rounds = 0;
    class_counts.clear();
    class_counts.push_back(
        nodes.empty() ? 0 : 1 + *std::max_element(classes.begin(), classes.end())
    );
    while (true) {
        std::map<std::vector<int>, int> interned;
        std::vector<int> next(nodes.size());
        for (size_t index = 0; index < nodes.size(); ++index) {
            std::vector<int> signature = encode_signature(
                nodes[index].base_class, nodes[index].moves, classes
            );
            auto [where, inserted] = interned.emplace(
                std::move(signature), static_cast<int>(interned.size())
            );
            next[index] = where->second;
            (void)inserted;
        }
        ++rounds;
        class_counts.push_back(static_cast<int>(interned.size()));
        if (class_counts.back() == class_counts[class_counts.size() - 2]) {
            return next;
        }
        classes = std::move(next);
    }
}

static bool same_graph(
    const std::vector<Mask> &adjacency, Mask left, Mask right
) {
    if (size(left) != size(right)) return false;
    std::vector<int> a;
    std::vector<int> b;
    Mask scan = left;
    while (!empty(scan)) a.push_back(pop_first(scan));
    scan = right;
    while (!empty(scan)) b.push_back(pop_first(scan));
    const int n = static_cast<int>(a.size());
    int left_edges = 0;
    int right_edges = 0;
    std::vector<int> degree_a(n);
    std::vector<int> degree_b(n);
    for (int index = 0; index < n; ++index) {
        degree_a[index] = size(adjacency[a[index]] & left);
        degree_b[index] = size(adjacency[b[index]] & right);
        left_edges += degree_a[index];
        right_edges += degree_b[index];
    }
    if (left_edges != right_edges) return false;
    std::sort(degree_a.begin(), degree_a.end());
    std::sort(degree_b.begin(), degree_b.end());
    if (degree_a != degree_b) return false;

    std::vector<int> map_a_to_b(n, -1);
    std::vector<int> used_b(n, 0);
    std::vector<std::vector<int>> neighbours_a(n), neighbours_b(n);
    std::array<int, 128> local_a{};
    std::array<int, 128> local_b{};
    local_a.fill(-1);
    local_b.fill(-1);
    for (int index = 0; index < n; ++index) {
        local_a[a[index]] = index;
        local_b[b[index]] = index;
    }
    for (int index = 0; index < n; ++index) {
        Mask neighbours = adjacency[a[index]] & left;
        while (!empty(neighbours)) neighbours_a[index].push_back(local_a[pop_first(neighbours)]);
        neighbours = adjacency[b[index]] & right;
        while (!empty(neighbours)) neighbours_b[index].push_back(local_b[pop_first(neighbours)]);
    }
    std::vector<int> original_degree_a(n), original_degree_b(n);
    for (int index = 0; index < n; ++index) {
        original_degree_a[index] = static_cast<int>(neighbours_a[index].size());
        original_degree_b[index] = static_cast<int>(neighbours_b[index].size());
    }

    std::function<bool(int)> search = [&](int mapped) {
        if (mapped == n) return true;
        int chosen = -1;
        int best_candidates = n + 1;
        for (int x = 0; x < n; ++x) {
            if (map_a_to_b[x] != -1) continue;
            int candidates = 0;
            for (int y = 0; y < n; ++y) {
                if (used_b[y] || original_degree_a[x] != original_degree_b[y]) continue;
                bool compatible = true;
                for (int u = 0; u < n; ++u) {
                    if (map_a_to_b[u] == -1) continue;
                    bool edge_a = std::find(neighbours_a[x].begin(), neighbours_a[x].end(), u) !=
                                  neighbours_a[x].end();
                    bool edge_b = std::find(neighbours_b[y].begin(), neighbours_b[y].end(),
                                            map_a_to_b[u]) != neighbours_b[y].end();
                    if (edge_a != edge_b) {
                        compatible = false;
                        break;
                    }
                }
                if (compatible) ++candidates;
            }
            if (candidates < best_candidates) {
                best_candidates = candidates;
                chosen = x;
            }
        }
        if (chosen < 0 || best_candidates == 0) return false;
        for (int y = 0; y < n; ++y) {
            if (used_b[y] || original_degree_a[chosen] != original_degree_b[y]) continue;
            bool compatible = true;
            for (int u = 0; u < n; ++u) {
                if (map_a_to_b[u] == -1) continue;
                bool edge_a = std::find(neighbours_a[chosen].begin(), neighbours_a[chosen].end(), u) !=
                              neighbours_a[chosen].end();
                bool edge_b = std::find(neighbours_b[y].begin(), neighbours_b[y].end(),
                                        map_a_to_b[u]) != neighbours_b[y].end();
                if (edge_a != edge_b) {
                    compatible = false;
                    break;
                }
            }
            if (!compatible) continue;
            map_a_to_b[chosen] = y;
            used_b[y] = 1;
            if (search(mapped + 1)) return true;
            used_b[y] = 0;
            map_a_to_b[chosen] = -1;
        }
        return false;
    };
    return search(0);
}

static void emit_int_array(std::ostream &out, const std::vector<int> &values) {
    out << '[';
    for (size_t index = 0; index < values.size(); ++index) {
        if (index) out << ", ";
        out << values[index];
    }
    out << ']';
}

static void emit_merger(std::ostream &out, const MergerWitness &witness) {
    if (!witness.present) {
        out << "null";
        return;
    }
    out << "{\"class\": " << witness.stable_class << ", \"prior\": ";
    emit_json_mask(out, witness.prior);
    out << ", \"prior_nimber\": " << witness.prior_value << ", \"current\": ";
    emit_json_mask(out, witness.current);
    out << ", \"current_nimber\": " << witness.current_value << '}';
}

int main(int argc, char **argv) {
    if (argc < 3 || argc > 4) {
        std::cerr << "usage: c294-b3-typed-frontier-quotient GAME_LIMIT INTERFACE_LIMIT [OUTPUT]\n";
        return 2;
    }
    size_t game_limit = std::strtoull(argv[1], nullptr, 10);
    size_t interface_limit = std::strtoull(argv[2], nullptr, 10);
    int q, type, graph_size;
    if (!(std::cin >> q >> type >> graph_size) || graph_size < 0 || graph_size > 128) return 2;
    RelevanceProbe solver(game_limit, interface_limit);
    solver.adjacency.resize(graph_size);
    solver.closed.resize(graph_size);
    for (int vertex = 0; vertex < graph_size; ++vertex) {
        std::cin >> solver.adjacency[vertex].lo >> solver.adjacency[vertex].hi;
        solver.closed[vertex] = solver.adjacency[vertex] | singleton(vertex);
    }
    Mask root;
    std::cin >> root.lo >> root.hi;
    CoordinateInput coordinate;
    int block_count;
    std::cin >> block_count;
    coordinate.order.resize(block_count);
    coordinate.blocks.resize(block_count);
    for (int &block : coordinate.order) std::cin >> block;
    for (int vertex = 0; vertex < graph_size; ++vertex) {
        std::cin >> coordinate.targets[vertex][0] >> coordinate.targets[vertex][1]
                 >> coordinate.targets[vertex][2] >> coordinate.sheet[vertex]
                 >> coordinate.block[vertex] >> coordinate.position[vertex];
        coordinate.blocks[coordinate.block[vertex]].push_back(vertex);
    }
    solver.initialize_transition();
    bool stopped = false;
    int follower = -1;
    try {
        follower = solver.nimber(root);
    } catch (const LimitReached &) {
        stopped = true;
    }

    std::vector<RelevanceProbe::Entry> entries = solver.frozen_entries();
    std::map<std::vector<int>, int> exact_id;
    for (size_t index = 0; index < entries.size(); ++index) {
        if (!exact_id.emplace(entries[index].absolute_key, static_cast<int>(index)).second) {
            throw std::runtime_error("duplicate exact absolute key");
        }
    }
    auto ports = full_cut_ports(solver.adjacency, coordinate);
    std::map<std::string, int> base_intern;
    std::vector<TypedNode> nodes(entries.size());
    uint64_t transition_count = 0;
    uint64_t symbolic_terms = 0;
    uint64_t banked_terms = 0;
    uint64_t missing_successors = 0;

    for (size_t index = 0; index < entries.size(); ++index) {
        TypedNode &node = nodes[index];
        node.mask = entries[index].representative;
        node.value = entries[index].value;
        SpatialSummary spatial = spatial_summary(
            node.mask, root, solver.adjacency, coordinate, ports
        );
        std::string base = candidate_key(0, spatial);
        auto [base_where, base_inserted] = base_intern.emplace(
            std::move(base), static_cast<int>(base_intern.size())
        );
        node.base_class = base_where->second;
        (void)base_inserted;

        Mask moves = node.mask;
        while (!empty(moves)) {
            int vertex = pop_first(moves);
            TypedMove transition;
            transition.label = local_move_label(node.mask, vertex, coordinate);
            Mask child = and_not(node.mask, solver.closed[vertex]);
            for (Mask part : solver.split(child)) {
                int vertices = size(part);
                int twice_edges = 0;
                int maximum_degree = 0;
                Mask scan = part;
                while (!empty(scan)) {
                    int current = pop_first(scan);
                    int degree = size(solver.adjacency[current] & part);
                    twice_edges += degree;
                    maximum_degree = std::max(maximum_degree, degree);
                }
                int edges = twice_edges / 2;
                int rank = edges - vertices + 1;
                if (maximum_degree <= 2 || rank <= 1) {
                    transition.detached_xor ^= solver.frozen_nimber(part);
                    ++banked_terms;
                    continue;
                }
                std::vector<int> key = rank <= 4
                    ? solver.low_cyclomatic_keys(part, rank).candidate
                    : solver.sparse_absolute_core_key(part, rank);
                auto found = exact_id.find(key);
                if (found == exact_id.end()) {
                    ++missing_successors;
                } else {
                    transition.symbolic_children.push_back(found->second);
                    ++symbolic_terms;
                }
            }
            std::sort(
                transition.symbolic_children.begin(), transition.symbolic_children.end()
            );
            node.moves.push_back(std::move(transition));
        }
        std::sort(node.moves.begin(), node.moves.end());
        node.moves.erase(std::unique(node.moves.begin(), node.moves.end()), node.moves.end());
        transition_count += node.moves.size();
    }
    if (missing_successors != 0) {
        throw std::runtime_error("typed grammar is not downward closed");
    }

    int rounds = 0;
    std::vector<int> class_counts;
    std::vector<int> classes = refine_partition(nodes, rounds, class_counts);
    const int stable_classes = class_counts.back();
    std::vector<std::vector<int>> members(stable_classes);
    for (size_t index = 0; index < classes.size(); ++index) {
        members[classes[index]].push_back(static_cast<int>(index));
    }
    uint64_t conflicts = 0;
    uint64_t isomorphism_removals_inside_typed_classes = 0;
    uint64_t genuine_removals = 0;
    MergerWitness first_merger;
    MergerWitness first_nonisomorphic;
    for (int class_id = 0; class_id < stable_classes; ++class_id) {
        std::map<int, int> first_by_value;
        const std::vector<int> &group = members[class_id];
        if (group.size() > 1 && !first_merger.present) {
            first_merger = {
                true, nodes[group[0]].mask, nodes[group[1]].mask,
                nodes[group[0]].value, nodes[group[1]].value, class_id
            };
        }
        for (int member : group) {
            if (first_by_value.empty()) {
                first_by_value.emplace(nodes[member].value, member);
            } else if (!first_by_value.count(nodes[member].value)) {
                ++conflicts;
                first_by_value.emplace(nodes[member].value, member);
            }
        }
        if (!first_nonisomorphic.present && group.size() > 1) {
            for (size_t offset = 1; offset < group.size(); ++offset) {
                if (!same_graph(
                        solver.adjacency, nodes[group[0]].mask, nodes[group[offset]].mask
                    )) {
                    first_nonisomorphic = {
                        true, nodes[group[0]].mask, nodes[group[offset]].mask,
                        nodes[group[0]].value, nodes[group[offset]].value, class_id
                    };
                    break;
                }
            }
        }
        std::vector<int> isomorphism_representatives;
        for (int member : group) {
            bool represented = false;
            for (int representative : isomorphism_representatives) {
                if (same_graph(
                        solver.adjacency, nodes[representative].mask, nodes[member].mask
                    )) {
                    represented = true;
                    break;
                }
            }
            if (!represented) isomorphism_representatives.push_back(member);
        }
        isomorphism_removals_inside_typed_classes +=
            group.size() - isomorphism_representatives.size();
        if (!isomorphism_representatives.empty()) {
            genuine_removals += isomorphism_representatives.size() - 1;
        }
    }

    const int known_isomorphism_removals = q == 5 ? 943 : 0;
    const int removals = static_cast<int>(nodes.size()) - stable_classes;
    const bool gate_passed = conflicts == 0 && genuine_removals >= 850;

    std::ofstream file;
    std::ostream *out = &std::cout;
    if (argc == 4) {
        file.open(argv[3]);
        if (!file) return 2;
        out = &file;
    }
    *out << "{\n"
         << "  \"schema\": \"c294-b3-typed-frontier-quotient-v1\",\n"
         << "  \"field_order\": " << q << ",\n"
         << "  \"type_index\": " << type << ",\n"
         << "  \"fixed_prefix\": {\"connected_states\": " << solver.connected_states
         << ", \"completed_classes\": " << nodes.size()
         << ", \"decompositions\": " << solver.decompositions
         << ", \"follower_nimber\": " << follower
         << ", \"stopped_at_limit\": " << (stopped ? "true" : "false") << "},\n"
         << "  \"typed_grammar\": {\"base_classes\": " << base_intern.size()
         << ", \"banked_component_terms\": " << banked_terms
         << ", \"missing_symbolic_successors\": " << missing_successors
         << ", \"symbolic_successor_terms\": " << symbolic_terms
         << ", \"unique_typed_transitions\": " << transition_count << "},\n"
         << "  \"refinement\": {\"rounds\": " << rounds
         << ", \"class_counts\": ";
    emit_int_array(*out, class_counts);
    *out << ", \"stable_classes\": " << stable_classes << "},\n"
         << "  \"gate\": {\"known_isomorphism_removals\": "
         << known_isomorphism_removals << ", \"total_removals\": " << removals
         << ", \"isomorphism_removals_inside_typed_classes\": "
         << isomorphism_removals_inside_typed_classes
         << ", \"genuine_removals\": " << genuine_removals
         << ", \"combined_removals_lower_bound\": "
         << known_isomorphism_removals + genuine_removals
         << ", \"nimber_conflicts\": " << conflicts
         << ", \"promotion_threshold\": 850, \"passed\": "
         << (gate_passed ? "true" : "false") << "},\n"
         << "  \"first_merger\": ";
    emit_merger(*out, first_merger);
    *out << ",\n  \"first_nonisomorphic_merger\": ";
    emit_merger(*out, first_nonisomorphic);
    *out << ",\n  \"closure\": {\"downward_closed\": true, "
         << "\"stable_signatures_checked\": true, "
         << "\"state_nimbers_used_in_refinement\": false}\n}\n";
}
