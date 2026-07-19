// C294 B3: simultaneous live integration of several exact two-port interfaces.
//
// This bounded probe reuses the checked transition and component kernels.  For
// each high-cycle residual it greedily chooses up to four mutually compatible
// separator pieces, removes all selected interiors, and canonically encodes the
// remaining context with a two-vertex oriented gadget for every exact interface.
#define C294_TWO_PORT_LIVE_NO_MAIN
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-function"
#include "2026-07-17-c294-b3-two-port-live.cpp"
#pragma GCC diagnostic pop
#undef C294_TWO_PORT_LIVE_NO_MAIN

class MultiPieceLiveProbe : public TwoPortLiveProbe {
  public:
    struct MultiEntry {
        uint8_t value = 0;
        Mask representative;
        std::vector<int> absolute_key;
        std::vector<Candidate> candidates;
    };

    MultiPieceLiveProbe(size_t game_limit, size_t interface_limit)
        : TwoPortLiveProbe(game_limit, interface_limit) {}

    uint8_t nimber(Mask mask) {
        if (empty(mask)) return 0;
        std::vector<Mask> parts = components(mask);
        if (parts.size() != 1) {
            ++decompositions;
            uint8_t value = 0;
            for (Mask part : parts) value ^= nimber(part);
            return value;
        }

        int vertices = size(mask);
        int twice_edges = 0;
        int maximum_degree = 0;
        Mask scan = mask;
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            int degree = size(adjacency[vertex] & mask);
            twice_edges += degree;
            maximum_degree = std::max(maximum_degree, degree);
        }
        int edges = twice_edges / 2;
        if (maximum_degree <= 2) {
            ++path_cycle_hits;
            if (edges == vertices - 1) return path_nimber_[vertices];
            if (edges == vertices && vertices >= 3) return cycle_nimber_[vertices];
            throw std::runtime_error("unexpected connected maximum-degree-two graph");
        }
        if (edges == vertices - 1) {
            std::string key = tree_key(mask);
            auto found = tree_cache_.find(key);
            if (found != tree_cache_.end()) {
                ++tree_cache_hits;
                return found->second;
            }
            uint8_t value = evaluate_connected_multi(mask);
            tree_cache_.emplace(std::move(key), value);
            ++tree_shapes;
            return value;
        }
        if (edges == vertices) {
            std::string key = unicyclic_key(mask);
            auto found = unicyclic_cache_.find(key);
            if (found != unicyclic_cache_.end()) {
                ++unicyclic_cache_hits;
                return found->second;
            }
            uint8_t value = evaluate_connected_multi(mask);
            unicyclic_cache_.emplace(std::move(key), value);
            ++unicyclic_shapes;
            return value;
        }

        int cyclomatic = edges - vertices + 1;
        std::vector<int> absolute_key;
        if (cyclomatic >= 2 && cyclomatic <= 4) {
            absolute_key = low_cyclomatic_keys(mask, cyclomatic).candidate;
            ++low_key_requests;
        } else {
            absolute_key = sparse_absolute_core_key(mask, cyclomatic);
            ++high_key_requests;
        }

        std::vector<Candidate> selected;
        std::vector<int> cache_key = absolute_key;
        bool used_interfaces = false;
        if (cyclomatic >= 5 && !multi_interface_disabled_) {
            auto known = multi_key_by_absolute_.find(absolute_key);
            if (known != multi_key_by_absolute_.end()) {
                cache_key = known->second;
            } else {
                try {
                    select_candidates(mask, selected);
                    if (!selected.empty()) {
                        cache_key = multi_live_key(mask, selected);
                        used_interfaces = true;
                        multi_key_by_absolute_.emplace(absolute_key, cache_key);
                    }
                } catch (const InterfaceLimitReached &) {
                    multi_interface_stopped_ = true;
                    multi_interface_disabled_ = true;
                    selected.clear();
                    cache_key = absolute_key;
                }
            }
        }

        auto found = multi_cache_.find(cache_key);
        if (found != multi_cache_.end()) {
            ++multi_cache_hits;
            if (used_interfaces && found->second.absolute_key != absolute_key) {
                ++full_new_absolute_hits;
                if (different_piece_realization(found->second.candidates, selected)) {
                    ++cross_exact_full_hits;
                    if (!has_first_cross_exact_full_hit_) {
                        has_first_cross_exact_full_hit_ = true;
                        first_any_full_prior_ = found->second;
                        first_any_full_current_ = {
                            found->second.value, mask, absolute_key, selected
                        };
                    }
                    if (found->second.candidates.size() > 1 && selected.size() > 1) {
                        ++cross_exact_multi_full_hits;
                    }
                    if (!has_first_cross_exact_multi_full_hit_ &&
                        found->second.candidates.size() > 1 && selected.size() > 1) {
                        has_first_cross_exact_multi_full_hit_ = true;
                        first_full_prior_ = found->second;
                        first_full_current_ = {found->second.value, mask, absolute_key, selected};
                    }
                }
            }
            return found->second.value;
        }

        uint8_t value = evaluate_connected_multi(mask);
        multi_cache_.emplace(
            std::move(cache_key),
            MultiEntry{value, mask, std::move(absolute_key), std::move(selected)}
        );
        if (cyclomatic >= 2 && cyclomatic <= 4) ++low_cyclomatic_shapes;
        return value;
    }

    uint64_t multi_cache_hits = 0;
    uint64_t multi_requests = 0;
    uint64_t selected_pieces = 0;
    uint64_t positions_with_multiple_pieces = 0;
    uint64_t cross_class_selected_pieces = 0;
    uint64_t full_new_absolute_hits = 0;
    uint64_t cross_exact_full_hits = 0;
    uint64_t cross_exact_multi_full_hits = 0;
    uint64_t eligible_occurrences = 0;
    int maximum_selected_pieces = 0;

    size_t multi_classes() const { return multi_cache_.size(); }
    bool multi_interface_stopped() const { return multi_interface_stopped_; }
    bool has_first_cross_exact_multi_full_hit() const {
        return has_first_cross_exact_multi_full_hit_;
    }
    bool has_first_cross_exact_full_hit() const {
        return has_first_cross_exact_full_hit_;
    }
    const MultiEntry &first_full_prior() const { return first_full_prior_; }
    const MultiEntry &first_full_current() const { return first_full_current_; }
    const MultiEntry &first_any_full_prior() const { return first_any_full_prior_; }
    const MultiEntry &first_any_full_current() const { return first_any_full_current_; }

  private:
    uint8_t evaluate_connected_multi(Mask mask) {
        if (connected_states >= limit_) {
            limit_vertices = size(mask);
            throw LimitReached();
        }
        int twice_edges = 0;
        Mask scan = mask;
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            twice_edges += size(adjacency[vertex] & mask);
        }
        int cyclomatic = twice_edges / 2 - size(mask) + 1;
        ++cyclomatic_states[std::min(cyclomatic, 16)];
        ++connected_states;
        std::array<uint64_t, 2> seen{};
        Mask moves = mask;
        while (!empty(moves)) {
            int vertex = pop_first(moves);
            uint8_t child = nimber(and_not(mask, closed[vertex]));
            if (child < 64) seen[0] |= 1ULL << child;
            else seen[1] |= 1ULL << (child - 64);
        }
        if (~seen[0]) return static_cast<uint8_t>(__builtin_ctzll(~seen[0]));
        return static_cast<uint8_t>(64 + __builtin_ctzll(~seen[1]));
    }

    std::vector<Candidate> enumerate_candidates(Mask mask) {
        Mask core = two_core(mask);
        std::vector<int> vertices;
        Mask scan = core;
        while (!empty(scan)) vertices.push_back(pop_first(scan));
        std::vector<Candidate> result;
        for (size_t first = 0; first < vertices.size(); ++first) {
            for (size_t second = first + 1; second < vertices.size(); ++second) {
                int a = vertices[first];
                int b = vertices[second];
                Mask remainder = and_not(and_not(core, singleton(a)), singleton(b));
                std::vector<Mask> parts = components(remainder);
                if (parts.size() < 2) continue;
                for (Mask component : parts) {
                    if (size(component) < 8) continue;
                    if (empty(adjacency[a] & component) ||
                        empty(adjacency[b] & component)) continue;
                    Candidate current;
                    current.piece = expanded_piece(mask, core, component);
                    current.first_port = a;
                    current.second_port = b;
                    current.core_vertices = size(component);
                    current.expanded_vertices = size(current.piece);
                    if (current.expanded_vertices > 16) continue;
                    current.exact_key = piece_key(mask, core, component, a, b);
                    ++eligible_occurrences;
                    auto ids = transition_->ordered_ids(
                        current.piece, current.first_port, current.second_port
                    );
                    current.forward_id = ids.forward;
                    current.reverse_id = ids.reverse;
                    result.push_back(std::move(current));
                }
            }
        }
        return result;
    }

    static std::pair<int, int> unordered_interface(const Candidate &candidate) {
        return std::minmax(candidate.forward_id, candidate.reverse_id);
    }

    bool compatible(const Candidate &candidate,
                    const std::vector<Candidate> &selected) const {
        for (const Candidate &prior : selected) {
            if (!empty(candidate.piece & prior.piece)) return false;
            if (!empty(candidate.piece & singleton(prior.first_port)) ||
                !empty(candidate.piece & singleton(prior.second_port))) return false;
            if (!empty(prior.piece & singleton(candidate.first_port)) ||
                !empty(prior.piece & singleton(candidate.second_port))) return false;
        }
        return true;
    }

    void select_candidates(Mask mask, std::vector<Candidate> &selected) {
        std::vector<Candidate> candidates = enumerate_candidates(mask);
        std::stable_sort(candidates.begin(), candidates.end(), [&](const Candidate &a,
                                                                  const Candidate &b) {
            auto a_class = multi_selected_classes_.find(unordered_interface(a));
            auto b_class = multi_selected_classes_.find(unordered_interface(b));
            bool a_cross = a_class != multi_selected_classes_.end() &&
                           a_class->second.exact_key != a.exact_key;
            bool b_cross = b_class != multi_selected_classes_.end() &&
                           b_class->second.exact_key != b.exact_key;
            if (a_cross != b_cross) return a_cross > b_cross;
            if (a.expanded_vertices != b.expanded_vertices) {
                return a.expanded_vertices > b.expanded_vertices;
            }
            return a.exact_key > b.exact_key;
        });
        for (const Candidate &candidate : candidates) {
            if (selected.size() == 4) break;
            if (!compatible(candidate, selected)) continue;
            auto known = multi_selected_classes_.find(unordered_interface(candidate));
            if (known != multi_selected_classes_.end() &&
                known->second.exact_key != candidate.exact_key) {
                ++cross_class_selected_pieces;
            }
            selected.push_back(candidate);
        }
        for (const Candidate &candidate : selected) {
            multi_selected_classes_.try_emplace(unordered_interface(candidate), candidate);
        }
        ++multi_requests;
        selected_pieces += selected.size();
        if (selected.size() > 1) ++positions_with_multiple_pieces;
        maximum_selected_pieces = std::max(
            maximum_selected_pieces, static_cast<int>(selected.size())
        );
    }

    std::vector<int> oriented_context_key(
        Mask mask, const std::vector<Candidate> &selected, unsigned orientation
    ) {
        Mask removed{};
        for (const Candidate &candidate : selected) removed = removed | candidate.piece;
        Mask context = and_not(mask, removed);
        std::vector<int> vertices;
        std::array<int, 128> local{};
        local.fill(-1);
        Mask scan = context;
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            local[vertex] = static_cast<int>(vertices.size());
            vertices.push_back(vertex);
        }
        size_t actual = vertices.size();
        std::vector<std::vector<int>> neighbours(actual + 2 * selected.size());
        std::vector<int> labels(actual + 2 * selected.size(), 0);
        for (size_t index = 0; index < actual; ++index) {
            Mask adjacent = adjacency[vertices[index]] & context;
            while (!empty(adjacent)) neighbours[index].push_back(local[pop_first(adjacent)]);
        }
        for (size_t index = 0; index < selected.size(); ++index) {
            const Candidate &candidate = selected[index];
            bool reverse = (orientation & (1U << index)) != 0;
            int identifier = reverse ? candidate.reverse_id : candidate.forward_id;
            int first_port = reverse ? candidate.second_port : candidate.first_port;
            int second_port = reverse ? candidate.first_port : candidate.second_port;
            if (local[first_port] < 0 || local[second_port] < 0) {
                throw std::runtime_error("selected interface port removed by another piece");
            }
            int first_marker = static_cast<int>(actual + 2 * index);
            int second_marker = first_marker + 1;
            labels[first_marker] = 1 + 2 * identifier;
            labels[second_marker] = 2 + 2 * identifier;
            neighbours[first_marker] = {local[first_port], second_marker};
            neighbours[second_marker] = {local[second_port], first_marker};
            neighbours[local[first_port]].push_back(first_marker);
            neighbours[local[second_port]].push_back(second_marker);
        }
        for (auto &list : neighbours) std::sort(list.begin(), list.end());
        return canonical_graph_key(-4, neighbours, labels);
    }

    std::vector<int> multi_live_key(Mask mask,
                                    const std::vector<Candidate> &selected) {
        std::vector<int> result;
        unsigned orientations = 1U << selected.size();
        for (unsigned orientation = 0; orientation < orientations; ++orientation) {
            std::vector<int> candidate = oriented_context_key(mask, selected, orientation);
            if (result.empty() || candidate < result) result = std::move(candidate);
        }
        result.insert(result.begin(), std::numeric_limits<int>::min() + 2);
        return result;
    }

    static bool different_piece_realization(const std::vector<Candidate> &a,
                                            const std::vector<Candidate> &b) {
        std::vector<std::vector<int>> a_keys;
        std::vector<std::vector<int>> b_keys;
        for (const Candidate &candidate : a) a_keys.push_back(candidate.exact_key);
        for (const Candidate &candidate : b) b_keys.push_back(candidate.exact_key);
        std::sort(a_keys.begin(), a_keys.end());
        std::sort(b_keys.begin(), b_keys.end());
        return a_keys != b_keys;
    }

    bool multi_interface_stopped_ = false;
    bool multi_interface_disabled_ = false;
    std::unordered_map<std::vector<int>, MultiEntry, VectorHash> multi_cache_;
    std::unordered_map<std::vector<int>, std::vector<int>, VectorHash>
        multi_key_by_absolute_;
    std::map<std::pair<int, int>, Candidate> multi_selected_classes_;
    bool has_first_cross_exact_multi_full_hit_ = false;
    bool has_first_cross_exact_full_hit_ = false;
    MultiEntry first_full_prior_;
    MultiEntry first_full_current_;
    MultiEntry first_any_full_prior_;
    MultiEntry first_any_full_current_;
};

static void emit_multi_entry(std::ostream &output,
                             const MultiPieceLiveProbe::MultiEntry &entry) {
    output << "{\"pieces\": [";
    for (size_t index = 0; index < entry.candidates.size(); ++index) {
        if (index != 0) output << ", ";
        emit_candidate(output, entry.representative, entry.candidates[index]);
    }
    output << "], \"residual\": ";
    emit_mask(output, entry.representative);
    output << "}";
}

int main(int argc, char **argv) {
    if (argc < 3 || argc > 4) {
        std::cerr << "usage: c294-b3-multi-piece-live GAME_STATE_LIMIT "
                     "INTERFACE_STATE_LIMIT [OUTPUT]\n";
        return 2;
    }
    size_t game_limit = std::strtoull(argv[1], nullptr, 10);
    size_t interface_limit = std::strtoull(argv[2], nullptr, 10);
    int field_order;
    int type_index;
    int graph_size;
    if (!(std::cin >> field_order >> type_index >> graph_size) ||
        graph_size < 0 || graph_size > 128) return 2;
    MultiPieceLiveProbe solver(game_limit, interface_limit);
    solver.adjacency.resize(graph_size);
    solver.closed.resize(graph_size);
    for (int vertex = 0; vertex < graph_size; ++vertex) {
        std::cin >> solver.adjacency[vertex].lo >> solver.adjacency[vertex].hi;
        solver.closed[vertex] = solver.adjacency[vertex] | singleton(vertex);
    }
    Mask root;
    std::cin >> root.lo >> root.hi;
    solver.initialize_transition();
    bool game_stopped = false;
    int value = -1;
    try {
        value = solver.nimber(root);
    } catch (const LimitReached &) {
        game_stopped = true;
    }

    std::ofstream output_file;
    std::ostream *output = &std::cout;
    if (argc == 4) {
        output_file.open(argv[3]);
        if (!output_file) return 2;
        output = &output_file;
    }
    *output << "{\n"
            << "  \"connected_states\": " << solver.connected_states << ",\n"
            << "  \"cross_class_selected_pieces\": "
            << solver.cross_class_selected_pieces << ",\n"
            << "  \"cross_exact_full_hits\": " << solver.cross_exact_full_hits << ",\n"
            << "  \"cross_exact_multi_full_hits\": "
            << solver.cross_exact_multi_full_hits << ",\n"
            << "  \"decompositions\": " << solver.decompositions << ",\n"
            << "  \"eligible_occurrences\": " << solver.eligible_occurrences << ",\n"
            << "  \"field_order\": " << field_order << ",\n"
            << "  \"first_cross_exact_full_hit\": ";
    if (!solver.has_first_cross_exact_full_hit()) {
        *output << "null";
    } else {
        *output << "{\"current\": ";
        emit_multi_entry(*output, solver.first_any_full_current());
        *output << ", \"prior\": ";
        emit_multi_entry(*output, solver.first_any_full_prior());
        *output << "}";
    }
    *output << ",\n"
            << "  \"first_cross_exact_multi_full_hit\": ";
    if (!solver.has_first_cross_exact_multi_full_hit()) {
        *output << "null";
    } else {
        *output << "{\"current\": ";
        emit_multi_entry(*output, solver.first_full_current());
        *output << ", \"prior\": ";
        emit_multi_entry(*output, solver.first_full_prior());
        *output << "}";
    }
    *output << ",\n"
            << "  \"follower_nimber\": " << value << ",\n"
            << "  \"full_new_absolute_hits\": " << solver.full_new_absolute_hits << ",\n"
            << "  \"game_state_limit\": " << game_limit << ",\n"
            << "  \"game_stopped_at_limit\": "
            << (game_stopped ? "true" : "false") << ",\n"
            << "  \"high_key_requests\": " << solver.high_key_requests << ",\n"
            << "  \"interface_nodes\": " << solver.interface_nodes() << ",\n"
            << "  \"interface_state_limit\": " << interface_limit << ",\n"
            << "  \"interface_states\": " << solver.interface_states() << ",\n"
            << "  \"interface_stopped_at_limit\": "
            << (solver.multi_interface_stopped() ? "true" : "false") << ",\n"
            << "  \"low_key_requests\": " << solver.low_key_requests << ",\n"
            << "  \"maximum_selected_pieces\": " << solver.maximum_selected_pieces << ",\n"
            << "  \"multi_cache_hits\": " << solver.multi_cache_hits << ",\n"
            << "  \"multi_classes\": " << solver.multi_classes() << ",\n"
            << "  \"multi_requests\": " << solver.multi_requests << ",\n"
            << "  \"positions_with_multiple_pieces\": "
            << solver.positions_with_multiple_pieces << ",\n"
            << "  \"selected_pieces\": " << solver.selected_pieces << ",\n"
            << "  \"selector\": \"up-to-four-cross-class-first-largest\",\n"
            << "  \"type_index\": " << type_index << "\n"
            << "}\n";
}
