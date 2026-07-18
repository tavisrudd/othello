// Exact Node--Kayles recursion with game-aware component canonicalization.

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
#include <vector>

struct Mask {
    uint64_t lo = 0;
    uint64_t hi = 0;
    friend bool operator==(Mask a, Mask b) { return a.lo == b.lo && a.hi == b.hi; }
};

struct MaskHash {
    size_t operator()(Mask value) const {
        uint64_t x = value.lo ^ (value.hi + 0x9e3779b97f4a7c15ULL +
                                 (value.lo << 6) + (value.lo >> 2));
        x ^= x >> 30;
        x *= 0xbf58476d1ce4e5b9ULL;
        x ^= x >> 27;
        x *= 0x94d049bb133111ebULL;
        return static_cast<size_t>(x ^ (x >> 31));
    }
};

static Mask operator&(Mask a, Mask b) { return {a.lo & b.lo, a.hi & b.hi}; }
static Mask operator|(Mask a, Mask b) { return {a.lo | b.lo, a.hi | b.hi}; }
static Mask and_not(Mask a, Mask b) { return {a.lo & ~b.lo, a.hi & ~b.hi}; }
static bool empty(Mask a) { return a.lo == 0 && a.hi == 0; }
static int size(Mask a) { return __builtin_popcountll(a.lo) + __builtin_popcountll(a.hi); }

static int pop_first(Mask &mask) {
    if (mask.lo) {
        int bit = __builtin_ctzll(mask.lo);
        mask.lo &= mask.lo - 1;
        return bit;
    }
    int bit = __builtin_ctzll(mask.hi);
    mask.hi &= mask.hi - 1;
    return bit + 64;
}

static Mask singleton(int vertex) {
    return vertex < 64 ? Mask{1ULL << vertex, 0} : Mask{0, 1ULL << (vertex - 64)};
}

struct LimitReached : std::runtime_error {
    LimitReached() : std::runtime_error("state limit reached") {}
};

class Solver {
  public:
    explicit Solver(size_t limit) : limit_(limit) { build_path_cycle_tables(); }

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
            auto tree_found = tree_cache_.find(key);
            if (tree_found != tree_cache_.end()) {
                ++tree_cache_hits;
                return tree_found->second;
            }
            uint8_t value = recurse_connected(mask);
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
            uint8_t value = recurse_connected(mask);
            unicyclic_cache_.emplace(std::move(key), value);
            ++unicyclic_shapes;
            return value;
        }
        int cyclomatic = edges - vertices + 1;
        if (cyclomatic >= 2 && cyclomatic <= 3) {
            std::string key = low_cyclomatic_key(mask, cyclomatic);
            auto found = low_cyclomatic_cache_.find(key);
            if (found != low_cyclomatic_cache_.end()) {
                ++low_cyclomatic_cache_hits;
                return found->second;
            }
            uint8_t value = recurse_connected(mask);
            low_cyclomatic_cache_.emplace(std::move(key), value);
            ++low_cyclomatic_shapes;
            return value;
        }
        return recurse_connected(mask);
    }

    std::vector<Mask> adjacency;
    std::vector<Mask> closed;
    uint64_t cache_hits = 0;
    uint64_t connected_states = 0;
    uint64_t decompositions = 0;
    uint64_t path_cycle_hits = 0;
    uint64_t tree_cache_hits = 0;
    uint64_t tree_shapes = 0;
    uint64_t unicyclic_cache_hits = 0;
    uint64_t unicyclic_shapes = 0;
    uint64_t low_cyclomatic_cache_hits = 0;
    uint64_t low_cyclomatic_shapes = 0;
    std::array<uint64_t, 17> cyclomatic_states{};
    int limit_vertices = -1;

  private:
    uint8_t recurse_connected(Mask mask) {
        auto found = cache_.find(mask);
        if (found != cache_.end()) {
            ++cache_hits;
            return found->second;
        }
        if (cache_.size() >= limit_) {
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
        cache_.emplace(mask, value);
        return value;
    }

    std::vector<Mask> components(Mask mask) const {
        std::vector<Mask> result;
        Mask unseen = mask;
        while (!empty(unseen)) {
            int seed_vertex = pop_first(unseen);
            Mask component = singleton(seed_vertex);
            Mask frontier = component;
            while (!empty(frontier)) {
                int vertex = pop_first(frontier);
                Mask added = adjacency[vertex] & unseen;
                unseen = and_not(unseen, added);
                frontier = frontier | added;
                component = component | added;
            }
            result.push_back(component);
        }
        return result;
    }

    std::string rooted_tree_key(int vertex, int parent, Mask mask) const {
        std::vector<std::string> children;
        Mask neighbours = adjacency[vertex] & mask;
        while (!empty(neighbours)) {
            int child = pop_first(neighbours);
            if (child != parent) children.push_back(rooted_tree_key(child, vertex, mask));
        }
        std::sort(children.begin(), children.end());
        std::string result = "(";
        for (const std::string &child : children) result += child;
        result += ")";
        return result;
    }

    std::string tree_key(Mask mask) const {
        std::vector<int> degree(128);
        std::vector<int> leaves;
        Mask alive = mask;
        Mask scan = mask;
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            degree[vertex] = size(adjacency[vertex] & mask);
            if (degree[vertex] <= 1) leaves.push_back(vertex);
        }
        int remaining = size(mask);
        while (remaining > 2) {
            std::vector<int> next;
            for (int leaf : leaves) {
                alive = and_not(alive, singleton(leaf));
                --remaining;
                Mask neighbours = adjacency[leaf] & alive;
                while (!empty(neighbours)) {
                    int neighbour = pop_first(neighbours);
                    if (--degree[neighbour] == 1) next.push_back(neighbour);
                }
            }
            leaves = std::move(next);
        }
        std::vector<int> centres;
        Mask centre_scan = alive;
        while (!empty(centre_scan)) {
            centres.push_back(pop_first(centre_scan));
        }
        if (centres.size() == 1) return rooted_tree_key(centres[0], -1, mask);
        if (centres.size() != 2) throw std::runtime_error("tree centre failure");
        std::string left = rooted_tree_key(centres[0], centres[1], mask);
        std::string right = rooted_tree_key(centres[1], centres[0], mask);
        if (right < left) std::swap(left, right);
        return "(" + left + right + ")";
    }

    std::string unicyclic_key(Mask mask) const {
        std::vector<int> degree(128);
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
        int first = pop_first(scan = core);
        std::vector<int> cycle{first};
        int previous = -1;
        int current = first;
        while (true) {
            Mask neighbours = adjacency[current] & core;
            int next = pop_first(neighbours);
            if (next == previous) next = pop_first(neighbours);
            if (next == first) break;
            cycle.push_back(next);
            previous = current;
            current = next;
        }
        if (static_cast<int>(cycle.size()) != size(core)) {
            throw std::runtime_error("unicyclic core failure");
        }
        std::vector<std::string> labels;
        for (int vertex : cycle) {
            std::vector<std::string> branches;
            Mask neighbours = adjacency[vertex] & and_not(mask, core);
            while (!empty(neighbours)) {
                int child = pop_first(neighbours);
                branches.push_back(rooted_tree_key(child, vertex, and_not(mask, core) | singleton(vertex)));
            }
            std::sort(branches.begin(), branches.end());
            std::string label = "[";
            for (const std::string &branch : branches) label += branch;
            label += "]";
            labels.push_back(std::move(label));
        }
        std::vector<std::string> best;
        auto consider = [&](const std::vector<std::string> &candidate) {
            for (size_t shift = 0; shift < candidate.size(); ++shift) {
                std::vector<std::string> rotated;
                for (size_t offset = 0; offset < candidate.size(); ++offset) {
                    rotated.push_back(candidate[(shift + offset) % candidate.size()]);
                }
                if (best.empty() || rotated < best) best = std::move(rotated);
            }
        };
        consider(labels);
        std::reverse(labels.begin(), labels.end());
        consider(labels);
        std::string result = "C";
        for (const std::string &label : best) result += label;
        return result;
    }

    std::string attachment_label(int vertex, Mask mask, Mask core) const {
        std::vector<std::string> branches;
        Mask outside = and_not(mask, core);
        Mask neighbours = adjacency[vertex] & outside;
        while (!empty(neighbours)) {
            int child = pop_first(neighbours);
            branches.push_back(rooted_tree_key(child, vertex, outside | singleton(vertex)));
        }
        std::sort(branches.begin(), branches.end());
        std::string result = "[";
        for (const std::string &branch : branches) result += branch;
        result += "]";
        return result;
    }

    static std::string encode_piece(const std::string &piece) {
        return std::to_string(piece.size()) + ":" + piece;
    }

    std::string low_cyclomatic_key(Mask mask, int cyclomatic) const {
        std::vector<int> degree(128);
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

        std::vector<int> branches;
        scan = core;
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            int core_degree = size(adjacency[vertex] & core);
            if (core_degree != 2) branches.push_back(vertex);
        }
        if (branches.size() != static_cast<size_t>(2 * cyclomatic - 2)) {
            throw std::runtime_error("cycle-skeleton branch count failure");
        }
        std::array<int, 128> branch_index;
        branch_index.fill(-1);
        for (size_t index = 0; index < branches.size(); ++index) branch_index[branches[index]] = index;

        struct SkeletonEdge {
            int first;
            int second;
            std::vector<std::string> labels;
        };
        std::vector<SkeletonEdge> skeleton_edges;
        std::unordered_map<uint64_t, bool> visited;
        auto edge_id = [](int first, int second) {
            if (second < first) std::swap(first, second);
            return (static_cast<uint64_t>(first) << 32) | static_cast<uint32_t>(second);
        };
        for (int start : branches) {
            Mask neighbours = adjacency[start] & core;
            while (!empty(neighbours)) {
                int current = pop_first(neighbours);
                if (visited[edge_id(start, current)]) continue;
                visited[edge_id(start, current)] = true;
                int previous = start;
                std::vector<std::string> labels;
                while (branch_index[current] < 0) {
                    labels.push_back(attachment_label(current, mask, core));
                    Mask onward = adjacency[current] & core;
                    int next = pop_first(onward);
                    if (next == previous) next = pop_first(onward);
                    visited[edge_id(current, next)] = true;
                    previous = current;
                    current = next;
                }
                skeleton_edges.push_back({branch_index[start], branch_index[current], std::move(labels)});
            }
        }
        if (skeleton_edges.size() != static_cast<size_t>(3 * cyclomatic - 3)) {
            throw std::runtime_error("cycle-skeleton edge count failure");
        }

        std::vector<std::string> branch_labels;
        for (int vertex : branches) branch_labels.push_back(attachment_label(vertex, mask, core));
        std::vector<int> permutation(branches.size());
        std::iota(permutation.begin(), permutation.end(), 0);
        std::string best;
        do {
            std::vector<int> inverse(branches.size());
            for (size_t new_index = 0; new_index < permutation.size(); ++new_index) {
                inverse[permutation[new_index]] = static_cast<int>(new_index);
            }
            std::string candidate = "B";
            for (int old_index : permutation) candidate += encode_piece(branch_labels[old_index]);
            std::vector<std::string> encoded_edges;
            for (const SkeletonEdge &edge : skeleton_edges) {
                int first = inverse[edge.first];
                int second = inverse[edge.second];
                std::vector<std::string> labels = edge.labels;
                if (second < first) {
                    std::swap(first, second);
                    std::reverse(labels.begin(), labels.end());
                } else if (first == second) {
                    std::vector<std::string> reversed = labels;
                    std::reverse(reversed.begin(), reversed.end());
                    if (reversed < labels) labels = std::move(reversed);
                }
                std::string encoded = std::to_string(first) + "," + std::to_string(second) + ":";
                for (const std::string &label : labels) encoded += encode_piece(label);
                encoded_edges.push_back(std::move(encoded));
            }
            std::sort(encoded_edges.begin(), encoded_edges.end());
            candidate += "E";
            for (const std::string &edge : encoded_edges) candidate += encode_piece(edge);
            if (best.empty() || candidate < best) best = std::move(candidate);
        } while (std::next_permutation(permutation.begin(), permutation.end()));
        return "R" + std::to_string(cyclomatic) + ":" + best;
    }

    void build_path_cycle_tables() {
        path_nimber_.fill(0);
        cycle_nimber_.fill(0);
        for (int n = 1; n <= 128; ++n) {
            std::array<bool, 256> seen{};
            for (int vertex = 0; vertex < n; ++vertex) {
                int left = std::max(0, vertex - 1);
                int right = std::max(0, n - vertex - 2);
                seen[path_nimber_[left] ^ path_nimber_[right]] = true;
            }
            while (seen[path_nimber_[n]]) ++path_nimber_[n];
            if (n >= 3) cycle_nimber_[n] = path_nimber_[n - 3] == 0 ? 1 : 0;
        }
    }

    size_t limit_;
    std::unordered_map<Mask, uint8_t, MaskHash> cache_;
    std::unordered_map<std::string, uint8_t> tree_cache_;
    std::unordered_map<std::string, uint8_t> unicyclic_cache_;
    std::unordered_map<std::string, uint8_t> low_cyclomatic_cache_;
    std::array<uint8_t, 129> path_nimber_{};
    std::array<uint8_t, 129> cycle_nimber_{};
};

int main(int argc, char **argv) {
    if (argc < 2 || argc > 3) {
        std::cerr << "usage: c294-component-nimber STATE_LIMIT [OUTPUT]\n";
        return 2;
    }
    size_t limit = std::strtoull(argv[1], nullptr, 10);
    int field_order;
    int type_index;
    int graph_size;
    if (!(std::cin >> field_order >> type_index >> graph_size) || graph_size < 0 || graph_size > 128) return 2;
    Solver solver(limit);
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
              << "  \"cache_hits\": " << solver.cache_hits << ",\n"
              << "  \"connected_states\": " << solver.connected_states << ",\n"
              << "  \"cyclomatic_states_0_to_15_plus\": [";
    for (size_t index = 0; index < solver.cyclomatic_states.size(); ++index) {
        if (index != 0) *output << ", ";
        *output << solver.cyclomatic_states[index];
    }
    *output << "],\n"
              << "  \"decompositions\": " << solver.decompositions << ",\n"
              << "  \"field_order\": " << field_order << ",\n"
              << "  \"follower_nimber\": " << value << ",\n"
              << "  \"limit_vertices\": " << solver.limit_vertices << ",\n"
              << "  \"low_cyclomatic_cache_hits\": " << solver.low_cyclomatic_cache_hits << ",\n"
              << "  \"low_cyclomatic_shapes\": " << solver.low_cyclomatic_shapes << ",\n"
              << "  \"path_cycle_hits\": " << solver.path_cycle_hits << ",\n"
              << "  \"state_limit\": " << limit << ",\n"
              << "  \"stopped_at_limit\": " << (stopped ? "true" : "false") << ",\n"
              << "  \"tree_cache_hits\": " << solver.tree_cache_hits << ",\n"
              << "  \"tree_shapes\": " << solver.tree_shapes << ",\n"
              << "  \"unicyclic_cache_hits\": " << solver.unicyclic_cache_hits << ",\n"
              << "  \"unicyclic_shapes\": " << solver.unicyclic_shapes << ",\n"
              << "  \"type_index\": " << type_index << "\n"
              << "}\n";
}
