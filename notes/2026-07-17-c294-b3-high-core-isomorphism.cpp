// C294 B3: exact labelled-high-two-core isomorphism compression probe.

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <map>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <vector>

// Reuse the checked B2 graph, component, skeleton, and boundary-interface kernel.
#define private public
#define main c294_b2_embedded_main
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wreturn-type"
#include "2026-07-17-c294-b2-contextual-signature.cpp"
#pragma GCC diagnostic pop
#undef main
#undef private

class HighCoreIsomorphismProbe : public Solver {
  public:
    HighCoreIsomorphismProbe(size_t limit, bool live_isomorphism)
        : Solver(limit), live_isomorphism_(live_isomorphism) {}

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
        std::vector<int> cache_key = absolute_key;
        bool new_absolute_key = false;
        if (cyclomatic >= 5 && live_isomorphism_) {
            auto canonical = canonical_by_absolute_.find(absolute_key);
            if (canonical == canonical_by_absolute_.end()) {
                cache_key = canonical_high_core_key(mask, cyclomatic);
                canonical_by_absolute_.emplace(absolute_key, cache_key);
                new_absolute_key = true;
                ++high_observed_absolute_keys;
            } else {
                cache_key = canonical->second;
            }
        }
        auto found = quotient_cache_.find(cache_key);
        if (found != quotient_cache_.end()) {
            ++quotient_cache_hits;
            if (cyclomatic >= 5 && live_isomorphism_ && new_absolute_key &&
                found->second.absolute_key != absolute_key) {
                ++live_new_absolute_key_hits;
            }
            return found->second.value;
        }

        uint8_t value = evaluate_connected(mask);
        quotient_cache_.emplace(cache_key, Entry{value, mask, absolute_key});
        if (cyclomatic >= 2 && cyclomatic <= 4) {
            ++low_cyclomatic_shapes;
        } else if (live_isomorphism_) {
            ++high_isomorphism_classes;
        } else {
            record_high_core_class(mask, cyclomatic, absolute_key, value);
        }
        return value;
    }

    uint64_t quotient_cache_hits = 0;
    uint64_t low_key_requests = 0;
    uint64_t high_key_requests = 0;
    uint64_t high_absolute_classes = 0;
    uint64_t high_isomorphism_classes = 0;
    uint64_t high_merged_absolute_classes = 0;
    uint64_t high_nimber_conflicts = 0;
    uint64_t high_observed_absolute_keys = 0;
    uint64_t live_new_absolute_key_hits = 0;
    uint64_t canonical_search_nodes = 0;
    uint64_t canonical_search_leaves = 0;
    uint64_t maximum_search_nodes = 0;
    uint64_t maximum_search_leaves = 0;

    size_t quotient_classes() const { return quotient_cache_.size(); }
    bool has_first_merger() const { return has_first_merger_; }
    Mask first_prior() const { return first_prior_; }
    Mask first_current() const { return first_current_; }
    int first_prior_value() const { return first_prior_value_; }
    int first_current_value() const { return first_current_value_; }

  private:
    struct Entry {
        uint8_t value;
        Mask representative;
        std::vector<int> absolute_key;
    };

    struct CanonicalEntry {
        std::vector<int> absolute_key;
        uint8_t value;
        Mask representative;
    };

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

    Mask two_core(Mask mask) const {
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
        return core;
    }

    std::vector<int> sparse_absolute_core_key(Mask mask, int cyclomatic) {
        Mask core = two_core(mask);
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
        Mask scan = core;
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

    static std::vector<int> normalize_signatures(
        const std::vector<std::vector<int>> &signatures
    ) {
        std::vector<std::vector<int>> ordered = signatures;
        std::sort(ordered.begin(), ordered.end());
        ordered.erase(std::unique(ordered.begin(), ordered.end()), ordered.end());
        std::vector<int> colors;
        colors.reserve(signatures.size());
        for (const auto &signature : signatures) {
            colors.push_back(static_cast<int>(
                std::lower_bound(ordered.begin(), ordered.end(), signature) - ordered.begin()
            ));
        }
        return colors;
    }

    std::vector<int> refine_colors(
        const std::vector<std::vector<int>> &neighbours,
        std::vector<int> colors
    ) const {
        while (true) {
            std::vector<std::vector<int>> signatures(colors.size());
            for (size_t vertex = 0; vertex < colors.size(); ++vertex) {
                signatures[vertex].push_back(colors[vertex]);
                std::vector<int> adjacent;
                for (int neighbour : neighbours[vertex]) {
                    adjacent.push_back(colors[neighbour]);
                }
                std::sort(adjacent.begin(), adjacent.end());
                signatures[vertex].insert(
                    signatures[vertex].end(), adjacent.begin(), adjacent.end()
                );
            }
            std::vector<int> next = normalize_signatures(signatures);
            if (next == colors) return colors;
            colors = std::move(next);
        }
    }

    std::vector<int> discrete_encoding(
        int cyclomatic,
        const std::vector<std::vector<int>> &neighbours,
        const std::vector<int> &labels,
        const std::vector<int> &colors
    ) const {
        std::vector<int> order(colors.size());
        std::iota(order.begin(), order.end(), 0);
        std::sort(order.begin(), order.end(), [&](int first, int second) {
            return colors[first] < colors[second];
        });
        std::vector<int> inverse(colors.size());
        for (size_t index = 0; index < order.size(); ++index) {
            inverse[order[index]] = static_cast<int>(index);
        }

        std::vector<int> encoded{cyclomatic, static_cast<int>(order.size())};
        for (int vertex : order) encoded.push_back(labels[vertex]);
        for (size_t first = 0; first < order.size(); ++first) {
            std::vector<int> adjacent;
            for (int neighbour : neighbours[order[first]]) {
                int second = inverse[neighbour];
                if (second > static_cast<int>(first)) adjacent.push_back(second);
            }
            std::sort(adjacent.begin(), adjacent.end());
            encoded.push_back(static_cast<int>(adjacent.size()));
            encoded.insert(encoded.end(), adjacent.begin(), adjacent.end());
        }
        return encoded;
    }

    void canonical_search(
        int cyclomatic,
        const std::vector<std::vector<int>> &neighbours,
        const std::vector<int> &labels,
        std::vector<int> colors,
        std::vector<int> &best,
        uint64_t &nodes,
        uint64_t &leaves
    ) const {
        ++nodes;
        colors = refine_colors(neighbours, std::move(colors));
        std::map<int, std::vector<int>> cells;
        for (size_t vertex = 0; vertex < colors.size(); ++vertex) {
            cells[colors[vertex]].push_back(static_cast<int>(vertex));
        }
        auto cell = std::find_if(cells.begin(), cells.end(), [](const auto &entry) {
            return entry.second.size() > 1;
        });
        if (cell == cells.end()) {
            ++leaves;
            std::vector<int> encoded =
                discrete_encoding(cyclomatic, neighbours, labels, colors);
            if (best.empty() || encoded < best) best = std::move(encoded);
            return;
        }

        for (int selected : cell->second) {
            std::vector<std::vector<int>> signatures(colors.size());
            for (size_t vertex = 0; vertex < colors.size(); ++vertex) {
                signatures[vertex] = {
                    colors[vertex], vertex == static_cast<size_t>(selected) ? 1 : 0
                };
            }
            canonical_search(
                cyclomatic, neighbours, labels, normalize_signatures(signatures),
                best, nodes, leaves
            );
        }
    }

    std::vector<int> canonical_high_core_key(Mask mask, int cyclomatic) {
        Mask core = two_core(mask);
        std::vector<int> vertices;
        std::array<int, 128> local_index{};
        local_index.fill(-1);
        Mask scan = core;
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            local_index[vertex] = static_cast<int>(vertices.size());
            vertices.push_back(vertex);
        }

        std::vector<std::vector<int>> neighbours(vertices.size());
        std::vector<int> labels(vertices.size());
        std::vector<std::vector<int>> initial(vertices.size());
        for (size_t index = 0; index < vertices.size(); ++index) {
            int vertex = vertices[index];
            Mask adjacent = adjacency[vertex] & core;
            while (!empty(adjacent)) {
                neighbours[index].push_back(local_index[pop_first(adjacent)]);
            }
            labels[index] = attachment_signature_label(vertex, mask, core);
            initial[index] = {
                static_cast<int>(neighbours[index].size()), labels[index]
            };
        }

        uint64_t nodes = 0;
        uint64_t leaves = 0;
        std::vector<int> best;
        canonical_search(
            cyclomatic, neighbours, labels, normalize_signatures(initial),
            best, nodes, leaves
        );
        canonical_search_nodes += nodes;
        canonical_search_leaves += leaves;
        maximum_search_nodes = std::max(maximum_search_nodes, nodes);
        maximum_search_leaves = std::max(maximum_search_leaves, leaves);
        return best;
    }

    void record_high_core_class(
        Mask mask,
        int cyclomatic,
        const std::vector<int> &absolute_key,
        uint8_t value
    ) {
        ++high_absolute_classes;
        std::vector<int> canonical = canonical_high_core_key(mask, cyclomatic);
        auto found = canonical_high_cache_.find(canonical);
        if (found == canonical_high_cache_.end()) {
            canonical_high_cache_.emplace(
                std::move(canonical), CanonicalEntry{absolute_key, value, mask}
            );
            ++high_isomorphism_classes;
            return;
        }
        if (found->second.absolute_key == absolute_key) {
            throw std::runtime_error("duplicate completed absolute high-core key");
        }
        ++high_merged_absolute_classes;
        if (found->second.value != value) ++high_nimber_conflicts;
        if (!has_first_merger_) {
            has_first_merger_ = true;
            first_prior_ = found->second.representative;
            first_current_ = mask;
            first_prior_value_ = found->second.value;
            first_current_value_ = value;
        }
    }

    std::unordered_map<std::vector<int>, Entry, VectorHash> quotient_cache_;
    std::unordered_map<std::vector<int>, CanonicalEntry, VectorHash> canonical_high_cache_;
    std::unordered_map<std::vector<int>, std::vector<int>, VectorHash>
        canonical_by_absolute_;
    bool live_isomorphism_ = false;
    bool has_first_merger_ = false;
    Mask first_prior_;
    Mask first_current_;
    int first_prior_value_ = -1;
    int first_current_value_ = -1;
};

int main(int argc, char **argv) {
    if (argc < 2 || argc > 4) {
        std::cerr << "usage: c294-b3-high-core-isomorphism STATE_LIMIT [OUTPUT] [--live]\n";
        return 2;
    }
    size_t limit = std::strtoull(argv[1], nullptr, 10);
    bool live_isomorphism = argc == 4 && std::string(argv[3]) == "--live";
    if (argc == 4 && !live_isomorphism) return 2;
    int field_order;
    int type_index;
    int graph_size;
    if (!(std::cin >> field_order >> type_index >> graph_size) ||
        graph_size < 0 || graph_size > 128) return 2;
    HighCoreIsomorphismProbe solver(limit, live_isomorphism);
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
    if (argc >= 3) {
        output_file.open(argv[2]);
        if (!output_file) return 2;
        output = &output_file;
    }
    *output << "{\n"
            << "  \"boundary_absolute_states\": "
            << solver.boundary_absolute_states() << ",\n"
            << "  \"boundary_interface_nodes\": "
            << solver.boundary_interface_nodes() << ",\n"
            << "  \"canonical_search_leaves\": "
            << solver.canonical_search_leaves << ",\n"
            << "  \"canonical_search_nodes\": "
            << solver.canonical_search_nodes << ",\n"
            << "  \"connected_quotient_states\": " << solver.connected_states << ",\n"
            << "  \"decompositions\": " << solver.decompositions << ",\n"
            << "  \"field_order\": " << field_order << ",\n"
            << "  \"first_high_isomorphism_merger\": ";
    if (solver.has_first_merger()) {
        Mask prior = solver.first_prior();
        Mask current = solver.first_current();
        *output << "{\"current_hi\": " << current.hi
                << ", \"current_lo\": " << current.lo
                << ", \"current_nimber\": " << solver.first_current_value()
                << ", \"prior_hi\": " << prior.hi
                << ", \"prior_lo\": " << prior.lo
                << ", \"prior_nimber\": " << solver.first_prior_value() << "}";
    } else {
        *output << "null";
    }
    *output << ",\n"
            << "  \"follower_nimber\": " << value << ",\n"
            << "  \"high_absolute_classes\": "
            << solver.high_absolute_classes << ",\n"
            << "  \"high_isomorphism_classes\": "
            << solver.high_isomorphism_classes << ",\n"
            << "  \"high_key_requests\": " << solver.high_key_requests << ",\n"
            << "  \"high_merged_absolute_classes\": "
            << solver.high_merged_absolute_classes << ",\n"
            << "  \"high_nimber_conflicts\": "
            << solver.high_nimber_conflicts << ",\n"
            << "  \"high_observed_absolute_keys\": "
            << solver.high_observed_absolute_keys << ",\n"
            << "  \"limit_vertices\": " << solver.limit_vertices << ",\n"
            << "  \"low_key_requests\": " << solver.low_key_requests << ",\n"
            << "  \"live_isomorphism_cache\": "
            << (live_isomorphism ? "true" : "false") << ",\n"
            << "  \"live_new_absolute_key_hits\": "
            << solver.live_new_absolute_key_hits << ",\n"
            << "  \"maximum_search_leaves\": "
            << solver.maximum_search_leaves << ",\n"
            << "  \"maximum_search_nodes\": "
            << solver.maximum_search_nodes << ",\n"
            << "  \"quotient_cache_hits\": "
            << solver.quotient_cache_hits << ",\n"
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
