// C294 B3: exact sparse two-core / one-port-interface quotient.

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <numeric>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

// Reuse the checked B2 graph, component, skeleton, and boundary-interface kernel.
// The access rewrite exposes its implementation to the B3 driver without changing
// the predecessor evidence artifact.
#define private public
#define main c294_b2_embedded_main
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wreturn-type"
#include "2026-07-17-c294-b2-contextual-signature.cpp"
#pragma GCC diagnostic pop
#undef main
#undef private

class B3Solver : public Solver {
  public:
    explicit B3Solver(size_t limit) : Solver(limit) {}

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
        std::vector<int> key;
        if (cyclomatic >= 2 && cyclomatic <= 4) {
            key = low_cyclomatic_keys(mask, cyclomatic).candidate;
            ++low_key_requests;
        } else {
            key = sparse_absolute_core_key(mask, cyclomatic);
            ++high_key_requests;
        }
        auto found = quotient_cache_.find(key);
        if (found != quotient_cache_.end()) {
            ++quotient_cache_hits;
            if (!(found->second.representative == mask)) {
                ++distinct_mask_quotient_hits;
                if (cyclomatic >= 5) ++high_distinct_mask_hits;
                else ++low_distinct_mask_hits;
                if (cyclomatic >= 5 && !first_high_distinct_hit_) {
                    first_high_distinct_hit_ = true;
                    first_prior_ = found->second.representative;
                    first_current_ = mask;
                }
            }
            return found->second.value;
        }
        uint8_t value = evaluate_connected(mask);
        quotient_cache_.emplace(std::move(key), Entry{value, mask});
        if (cyclomatic >= 2 && cyclomatic <= 4) ++low_cyclomatic_shapes;
        return value;
    }

    uint64_t quotient_cache_hits = 0;
    uint64_t distinct_mask_quotient_hits = 0;
    uint64_t high_distinct_mask_hits = 0;
    uint64_t low_distinct_mask_hits = 0;
    uint64_t low_key_requests = 0;
    uint64_t high_key_requests = 0;

    size_t quotient_classes() const { return quotient_cache_.size(); }
    bool has_high_distinct_hit() const { return first_high_distinct_hit_; }
    Mask first_prior() const { return first_prior_; }
    Mask first_current() const { return first_current_; }

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
        uint8_t value;
        if (~seen[0]) value = static_cast<uint8_t>(__builtin_ctzll(~seen[0]));
        else value = static_cast<uint8_t>(64 + __builtin_ctzll(~seen[1]));
        return value;
    }

    std::vector<int> sparse_absolute_core_key(Mask mask, int cyclomatic) {
        std::array<int, 128> degree{};
        std::vector<int> leaves;
        Mask core = mask;
        Mask scan = mask;
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            degree[vertex] = size(adjacency[vertex] & mask);
            if (degree[vertex] == 1) leaves.push_back(vertex);
        }
        while (!leaves.empty()) {
            std::vector<int> next;
            for (int leaf : leaves) {
                core = and_not(core, singleton(leaf));
                Mask neighbours = adjacency[leaf] & core;
                while (!empty(neighbours)) {
                    int neighbour = pop_first(neighbours);
                    if (--degree[neighbour] == 1) next.push_back(neighbour);
                }
            }
            leaves = std::move(next);
        }

        std::vector<int> key{
            cyclomatic,
            static_cast<int>(core.lo & 0xffffffffULL),
            static_cast<int>(core.lo >> 32),
            static_cast<int>(core.hi & 0xffffffffULL),
            static_cast<int>(core.hi >> 32),
        };
        size_t count_index = key.size();
        key.push_back(0);
        int labelled = 0;
        scan = core;
        Mask outside = and_not(mask, core);
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            if (empty(adjacency[vertex] & outside)) continue;
            key.push_back(vertex);
            key.push_back(attachment_signature_label(vertex, mask, core));
            ++labelled;
        }
        key[count_index] = labelled;
        return key;
    }

    struct Entry {
        uint8_t value;
        Mask representative;
    };
    std::unordered_map<std::vector<int>, Entry, VectorHash> quotient_cache_;
    bool first_high_distinct_hit_ = false;
    Mask first_prior_;
    Mask first_current_;
};

int main(int argc, char **argv) {
    if (argc < 2 || argc > 3) {
        std::cerr << "usage: c294-b3-seven-skeleton-value STATE_LIMIT [OUTPUT]\n";
        return 2;
    }
    size_t limit = std::strtoull(argv[1], nullptr, 10);
    int field_order;
    int type_index;
    int graph_size;
    if (!(std::cin >> field_order >> type_index >> graph_size) ||
        graph_size < 0 || graph_size > 128) return 2;
    B3Solver solver(limit);
    solver.adjacency.resize(graph_size);
    solver.closed.resize(graph_size);
    for (int vertex = 0; vertex < graph_size; ++vertex) {
        std::cin >> solver.adjacency[vertex].lo >> solver.adjacency[vertex].hi;
        solver.closed[vertex] = solver.adjacency[vertex] | singleton(vertex);
    }
    Mask root;
    std::cin >> root.lo >> root.hi;
    bool stopped = false;
    int value = -1;
    try {
        value = solver.nimber(root);
    } catch (const LimitReached &) {
        stopped = true;
    }

    std::ofstream output_file;
    std::ostream *output = &std::cout;
    if (argc == 3) {
        output_file.open(argv[2]);
        if (!output_file) return 2;
        output = &output_file;
    }
    *output << "{\n"
            << "  \"boundary_absolute_states\": "
            << solver.boundary_absolute_states() << ",\n"
            << "  \"boundary_interface_nodes\": "
            << solver.boundary_interface_nodes() << ",\n"
            << "  \"connected_quotient_states\": " << solver.connected_states << ",\n"
            << "  \"decompositions\": " << solver.decompositions << ",\n"
            << "  \"distinct_mask_quotient_hits\": "
            << solver.distinct_mask_quotient_hits << ",\n"
            << "  \"field_order\": " << field_order << ",\n"
            << "  \"first_high_distinct_quotient_hit\": ";
    if (solver.has_high_distinct_hit()) {
        Mask prior = solver.first_prior();
        Mask current = solver.first_current();
        *output << "{\"current_hi\": " << current.hi
                << ", \"current_lo\": " << current.lo
                << ", \"prior_hi\": " << prior.hi
                << ", \"prior_lo\": " << prior.lo << "}";
    } else {
        *output << "null";
    }
    *output << ",\n"
            << "  \"follower_nimber\": " << value << ",\n"
            << "  \"high_distinct_mask_hits\": "
            << solver.high_distinct_mask_hits << ",\n"
            << "  \"high_key_requests\": " << solver.high_key_requests << ",\n"
            << "  \"limit_vertices\": " << solver.limit_vertices << ",\n"
            << "  \"low_key_requests\": " << solver.low_key_requests << ",\n"
            << "  \"low_distinct_mask_hits\": "
            << solver.low_distinct_mask_hits << ",\n"
            << "  \"quotient_cache_hits\": " << solver.quotient_cache_hits << ",\n"
            << "  \"quotient_classes\": " << solver.quotient_classes() << ",\n"
            << "  \"state_limit\": " << limit << ",\n"
            << "  \"stopped_at_limit\": " << (stopped ? "true" : "false") << ",\n"
            << "  \"tree_cache_hits\": " << solver.tree_cache_hits << ",\n"
            << "  \"tree_shapes\": " << solver.tree_shapes << ",\n"
            << "  \"type_index\": " << type_index << ",\n"
            << "  \"unicyclic_cache_hits\": " << solver.unicyclic_cache_hits << ",\n"
            << "  \"unicyclic_shapes\": " << solver.unicyclic_shapes << "\n"
            << "}\n";
}
