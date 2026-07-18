// C294 B3: on-demand live integration of the exact two-port transition quotient.
#include <memory>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wreturn-type"
#pragma GCC diagnostic ignored "-Wunused-function"
#define C294_TWO_PORT_TRANSITION_NO_MAIN
#include "2026-07-17-c294-b3-two-port-transition.cpp"
#undef C294_TWO_PORT_TRANSITION_NO_MAIN
#pragma GCC diagnostic pop

class TrackedTwoPortTransition : public TwoPortTransition {
  public:
    struct OrderedIds {
        int forward;
        int reverse;
        bool forward_cached;
        bool reverse_cached;
    };

    TrackedTwoPortTransition(const std::vector<Mask> &adjacency, size_t state_limit)
        : TwoPortTransition(adjacency, state_limit) {}

    OrderedIds ordered_ids(Mask piece, int first_port, int second_port) {
        Mask first = adjacency_[first_port] & piece;
        Mask second = adjacency_[second_port] & piece;
        BoundaryState forward_state{piece, first, second, 2};
        BoundaryState reverse_state{piece, second, first, 2};
        bool forward_cached = boundary_cache_.contains(forward_state);
        int forward = interface_id(piece, first, second, 2);
        bool reverse_cached = boundary_cache_.contains(reverse_state);
        int reverse = interface_id(piece, second, first, 2);
        return {forward, reverse, forward_cached, reverse_cached};
    }
};

class TwoPortLiveProbe : public SeparatorCensusProbe {
  public:
    struct Candidate {
        Mask piece;
        int first_port = -1;
        int second_port = -1;
        int core_vertices = 0;
        int expanded_vertices = 0;
        std::vector<int> exact_key;
        int forward_id = -1;
        int reverse_id = -1;
    };

    struct CacheEntry {
        uint8_t value;
        Mask representative;
        std::vector<int> absolute_key;
        Candidate candidate;
        bool used_interface = false;
    };

    TwoPortLiveProbe(size_t game_limit, size_t interface_limit)
        : SeparatorCensusProbe(game_limit), interface_limit_(interface_limit) {}

    void initialize_transition() {
        transition_ = std::make_unique<TrackedTwoPortTransition>(adjacency, interface_limit_);
    }

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
            uint8_t value = evaluate_connected(mask);
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
            uint8_t value = evaluate_connected(mask);
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

        Candidate candidate;
        bool used_interface = false;
        std::vector<int> cache_key = absolute_key;
        if (cyclomatic >= 5 && !interface_disabled_) {
            auto known = live_key_by_absolute_.find(absolute_key);
            if (known != live_key_by_absolute_.end()) {
                cache_key = known->second;
            } else {
                try {
                    if (select_candidate(mask, candidate)) {
                        cache_key = live_key(mask, candidate);
                        used_interface = true;
                        live_key_by_absolute_.emplace(absolute_key, cache_key);
                    }
                } catch (const InterfaceLimitReached &) {
                    interface_stopped_ = true;
                    interface_disabled_ = true;
                }
            }
        }

        auto found = quotient_cache_.find(cache_key);
        if (found != quotient_cache_.end()) {
            ++quotient_cache_hits;
            if (cache_key != absolute_key && found->second.absolute_key != absolute_key) {
                ++live_new_absolute_key_hits;
                if (!has_first_full_hit_) {
                    has_first_full_hit_ = true;
                    first_full_prior_ = found->second;
                    first_full_current_mask_ = mask;
                    first_full_current_candidate_ = candidate;
                    first_full_current_absolute_ = absolute_key;
                }
            }
            return found->second.value;
        }

        uint8_t value = evaluate_connected(mask);
        quotient_cache_.emplace(
            std::move(cache_key),
            CacheEntry{value, mask, std::move(absolute_key), candidate, used_interface}
        );
        if (cyclomatic >= 2 && cyclomatic <= 4) ++low_cyclomatic_shapes;
        return value;
    }

    uint64_t quotient_cache_hits = 0;
    uint64_t low_key_requests = 0;
    uint64_t high_key_requests = 0;
    uint64_t live_requests = 0;
    uint64_t exact_top_state_hits = 0;
    uint64_t reusable_interface_hits = 0;
    uint64_t nonisomorphic_interface_hits = 0;
    uint64_t live_new_absolute_key_hits = 0;
    int maximum_requested_core_vertices = 0;
    int maximum_requested_expanded_vertices = 0;

    size_t quotient_classes() const { return quotient_cache_.size(); }
    size_t interface_classes() const { return interface_classes_.size(); }
    bool interface_stopped() const { return interface_stopped_; }
    size_t interface_states() const {
        return transition_ == nullptr ? 0 : transition_->total_states();
    }
    size_t interface_nodes() const {
        return transition_ == nullptr ? 0 : transition_->interface_nodes();
    }
    bool has_first_interface_hit() const { return has_first_interface_hit_; }
    bool has_first_full_hit() const { return has_first_full_hit_; }
    const Candidate &first_interface_prior() const { return first_interface_prior_; }
    const Candidate &first_interface_current() const { return first_interface_current_; }
    Mask first_interface_prior_mask() const { return first_interface_prior_mask_; }
    Mask first_interface_current_mask() const { return first_interface_current_mask_; }
    const CacheEntry &first_full_prior() const { return first_full_prior_; }
    Mask first_full_current_mask() const { return first_full_current_mask_; }
    const Candidate &first_full_current_candidate() const {
        return first_full_current_candidate_;
    }

  private:
    uint8_t evaluate_connected(Mask mask) {
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

    Mask expanded_piece(Mask residual, Mask core, Mask component) {
        Mask outside = and_not(residual, core);
        Mask expanded = component;
        Mask roots{};
        Mask scan = component;
        while (!empty(scan)) roots = roots | (adjacency[pop_first(scan)] & outside);
        while (!empty(roots)) {
            int root = pop_first(roots);
            Mask attachment = component_from(root, outside);
            expanded = expanded | attachment;
            roots = and_not(roots, attachment);
        }
        return expanded;
    }

    bool select_candidate(Mask mask, Candidate &best) {
        Mask core = two_core(mask);
        std::vector<int> vertices;
        Mask scan = core;
        while (!empty(scan)) vertices.push_back(pop_first(scan));
        bool found = false;
        for (size_t first = 0; first < vertices.size(); ++first) {
            for (size_t second = first + 1; second < vertices.size(); ++second) {
                int a = vertices[first];
                int b = vertices[second];
                Mask remainder = and_not(and_not(core, singleton(a)), singleton(b));
                std::vector<Mask> parts = components(remainder);
                if (parts.size() < 2) continue;
                for (Mask component : parts) {
                    if (size(component) < 8) continue;
                    if (empty(adjacency[a] & component) || empty(adjacency[b] & component)) {
                        continue;
                    }
                    Candidate current;
                    current.piece = expanded_piece(mask, core, component);
                    current.first_port = a;
                    current.second_port = b;
                    current.core_vertices = size(component);
                    current.expanded_vertices = size(current.piece);
                    if (current.expanded_vertices > 16) continue;
                    current.exact_key = piece_key(mask, core, component, a, b);
                    if (!found || current.expanded_vertices < best.expanded_vertices ||
                        (current.expanded_vertices == best.expanded_vertices &&
                         current.exact_key < best.exact_key)) {
                        best = std::move(current);
                        found = true;
                    }
                }
            }
        }
        return found;
    }

    std::vector<int> context_key(Mask context, int first_port, int second_port) {
        std::vector<int> vertices;
        std::array<int, 128> local{};
        local.fill(-1);
        Mask scan = context;
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            local[vertex] = static_cast<int>(vertices.size());
            vertices.push_back(vertex);
        }
        std::vector<std::vector<int>> neighbours(vertices.size());
        std::vector<int> labels(vertices.size(), 0);
        for (size_t index = 0; index < vertices.size(); ++index) {
            int vertex = vertices[index];
            Mask adjacent = adjacency[vertex] & context;
            while (!empty(adjacent)) neighbours[index].push_back(local[pop_first(adjacent)]);
            if (vertex == first_port) labels[index] = 1;
            if (vertex == second_port) labels[index] = 2;
        }
        return canonical_graph_key(-3, neighbours, labels);
    }

    std::vector<int> live_key(Mask mask, Candidate &candidate) {
        ++live_requests;
        maximum_requested_core_vertices = std::max(
            maximum_requested_core_vertices, candidate.core_vertices
        );
        maximum_requested_expanded_vertices = std::max(
            maximum_requested_expanded_vertices, candidate.expanded_vertices
        );
        auto ids = transition_->ordered_ids(
            candidate.piece, candidate.first_port, candidate.second_port
        );
        candidate.forward_id = ids.forward;
        candidate.reverse_id = ids.reverse;
        if (ids.forward_cached && ids.reverse_cached) ++exact_top_state_hits;

        std::pair<int, int> unordered_ids = std::minmax(ids.forward, ids.reverse);
        auto [where, inserted] = interface_classes_.emplace(
            unordered_ids, InterfaceRepresentative{mask, candidate}
        );
        if (!inserted) {
            ++reusable_interface_hits;
            if (where->second.candidate.exact_key != candidate.exact_key) {
                ++nonisomorphic_interface_hits;
            }
            if (!has_first_interface_hit_) {
                has_first_interface_hit_ = true;
                first_interface_prior_mask_ = where->second.mask;
                first_interface_prior_ = where->second.candidate;
                first_interface_current_mask_ = mask;
                first_interface_current_ = candidate;
            }
        }

        Mask context = and_not(mask, candidate.piece);
        std::vector<int> forward = {
            std::numeric_limits<int>::min() + 1, ids.forward
        };
        std::vector<int> forward_context = context_key(
            context, candidate.first_port, candidate.second_port
        );
        forward.insert(forward.end(), forward_context.begin(), forward_context.end());
        std::vector<int> reverse = {
            std::numeric_limits<int>::min() + 1, ids.reverse
        };
        std::vector<int> reverse_context = context_key(
            context, candidate.second_port, candidate.first_port
        );
        reverse.insert(reverse.end(), reverse_context.begin(), reverse_context.end());
        return std::min(forward, reverse);
    }

    struct InterfaceRepresentative {
        Mask mask;
        Candidate candidate;
    };

    size_t interface_limit_;
    std::unique_ptr<TrackedTwoPortTransition> transition_;
    bool interface_stopped_ = false;
    bool interface_disabled_ = false;
    std::unordered_map<std::vector<int>, CacheEntry, VectorHash> quotient_cache_;
    std::unordered_map<std::vector<int>, std::vector<int>, VectorHash>
        live_key_by_absolute_;
    std::map<std::pair<int, int>, InterfaceRepresentative> interface_classes_;
    bool has_first_interface_hit_ = false;
    Mask first_interface_prior_mask_;
    Mask first_interface_current_mask_;
    Candidate first_interface_prior_;
    Candidate first_interface_current_;
    bool has_first_full_hit_ = false;
    CacheEntry first_full_prior_;
    Mask first_full_current_mask_;
    Candidate first_full_current_candidate_;
    std::vector<int> first_full_current_absolute_;
};

static void emit_candidate(
    std::ostream &output,
    Mask residual,
    const TwoPortLiveProbe::Candidate &candidate
) {
    output << "{\"expanded_vertices\": " << candidate.expanded_vertices
           << ", \"first_port\": " << candidate.first_port
           << ", \"forward_id\": " << candidate.forward_id
           << ", \"piece\": ";
    emit_mask(output, candidate.piece);
    output << ", \"residual\": ";
    emit_mask(output, residual);
    output << ", \"reverse_id\": " << candidate.reverse_id
           << ", \"second_port\": " << candidate.second_port << "}";
}

int main(int argc, char **argv) {
    if (argc < 3 || argc > 4) {
        std::cerr << "usage: c294-b3-two-port-live GAME_STATE_LIMIT "
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
    TwoPortLiveProbe solver(game_limit, interface_limit);
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
            << "  \"decompositions\": " << solver.decompositions << ",\n"
            << "  \"exact_top_state_hits\": " << solver.exact_top_state_hits << ",\n"
            << "  \"field_order\": " << field_order << ",\n"
            << "  \"first_full_quotient_hit\": ";
    if (!solver.has_first_full_hit()) {
        *output << "null";
    } else {
        *output << "{\"current\": ";
        emit_candidate(
            *output, solver.first_full_current_mask(),
            solver.first_full_current_candidate()
        );
        *output << ", \"prior\": ";
        emit_candidate(
            *output, solver.first_full_prior().representative,
            solver.first_full_prior().candidate
        );
        *output << "}";
    }
    *output << ",\n  \"first_interface_hit\": ";
    if (!solver.has_first_interface_hit()) {
        *output << "null";
    } else {
        *output << "{\"current\": ";
        emit_candidate(
            *output, solver.first_interface_current_mask(),
            solver.first_interface_current()
        );
        *output << ", \"prior\": ";
        emit_candidate(
            *output, solver.first_interface_prior_mask(),
            solver.first_interface_prior()
        );
        *output << "}";
    }
    *output << ",\n"
            << "  \"follower_nimber\": " << value << ",\n"
            << "  \"game_state_limit\": " << game_limit << ",\n"
            << "  \"game_stopped_at_limit\": "
            << (game_stopped ? "true" : "false") << ",\n"
            << "  \"high_key_requests\": " << solver.high_key_requests << ",\n"
            << "  \"interface_classes\": " << solver.interface_classes() << ",\n"
            << "  \"interface_nodes\": " << solver.interface_nodes() << ",\n"
            << "  \"interface_state_limit\": " << interface_limit << ",\n"
            << "  \"interface_states\": " << solver.interface_states() << ",\n"
            << "  \"interface_stopped_at_limit\": "
            << (solver.interface_stopped() ? "true" : "false") << ",\n"
            << "  \"live_decomposition_requests\": " << solver.live_requests << ",\n"
            << "  \"live_new_absolute_key_hits\": "
            << solver.live_new_absolute_key_hits << ",\n"
            << "  \"low_key_requests\": " << solver.low_key_requests << ",\n"
            << "  \"maximum_requested_core_vertices\": "
            << solver.maximum_requested_core_vertices << ",\n"
            << "  \"maximum_requested_expanded_vertices\": "
            << solver.maximum_requested_expanded_vertices << ",\n"
            << "  \"nonisomorphic_interface_hits\": "
            << solver.nonisomorphic_interface_hits << ",\n"
            << "  \"quotient_cache_hits\": " << solver.quotient_cache_hits << ",\n"
            << "  \"quotient_classes\": " << solver.quotient_classes() << ",\n"
            << "  \"reusable_interface_hits\": "
            << solver.reusable_interface_hits << ",\n"
            << "  \"type_index\": " << type_index << "\n"
            << "}\n";
}
