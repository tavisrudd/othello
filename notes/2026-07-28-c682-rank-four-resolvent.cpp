#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <map>
#include <numeric>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

namespace {

constexpr int kPrime = 11;
constexpr int kVariables = 10;
constexpr int kRows = 13;
constexpr int kColumns = 7;
constexpr int kMinorSize = 5;
constexpr int kMaximumDegree = 6;

using Exponent = std::array<std::uint8_t, kVariables>;
using Polynomial = std::vector<std::uint8_t>;
using LinearForm = std::array<std::uint8_t, kVariables>;

struct MonomialTables {
  std::array<std::vector<Exponent>, kMaximumDegree + 1> exponents;
  std::array<std::unordered_map<std::string, int>, kMaximumDegree + 1> indices;
  std::array<std::vector<std::array<int, kVariables>>, kMaximumDegree> multiply;

  MonomialTables() {
    Exponent current{};
    for (int degree = 0; degree <= kMaximumDegree; ++degree) {
      enumerate(degree, 0, current, exponents[degree]);
      for (int index = 0; index < static_cast<int>(exponents[degree].size());
           ++index) {
        indices[degree][key(exponents[degree][index])] = index;
      }
    }
    for (int degree = 0; degree < kMaximumDegree; ++degree) {
      multiply[degree].resize(exponents[degree].size());
      for (int index = 0; index < static_cast<int>(exponents[degree].size());
           ++index) {
        for (int variable = 0; variable < kVariables; ++variable) {
          Exponent next = exponents[degree][index];
          ++next[variable];
          multiply[degree][index][variable] =
              indices[degree + 1].at(key(next));
        }
      }
    }
  }

  static std::string key(const Exponent& exponent) {
    return std::string(reinterpret_cast<const char*>(exponent.data()),
                       exponent.size());
  }

  static void enumerate(int remaining, int variable, Exponent& current,
                        std::vector<Exponent>& output) {
    if (variable == kVariables - 1) {
      current[variable] = static_cast<std::uint8_t>(remaining);
      output.push_back(current);
      return;
    }
    for (int value = remaining; value >= 0; --value) {
      current[variable] = static_cast<std::uint8_t>(value);
      enumerate(remaining - value, variable + 1, current, output);
    }
  }
};

Polynomial multiply_linear(const Polynomial& polynomial, int degree,
                           const LinearForm& linear,
                           const MonomialTables& tables) {
  Polynomial output(tables.exponents[degree + 1].size(), 0);
  for (int monomial = 0; monomial < static_cast<int>(polynomial.size());
       ++monomial) {
    const int coefficient = polynomial[monomial];
    if (coefficient == 0) {
      continue;
    }
    for (int variable = 0; variable < kVariables; ++variable) {
      const int factor = linear[variable];
      if (factor == 0) {
        continue;
      }
      const int target = tables.multiply[degree][monomial][variable];
      output[target] =
          static_cast<std::uint8_t>((output[target] + coefficient * factor) %
                                    kPrime);
    }
  }
  return output;
}

void add_scaled(Polynomial& target, const Polynomial& source, int scale) {
  if (scale < 0) {
    scale += kPrime;
  }
  for (int index = 0; index < static_cast<int>(target.size()); ++index) {
    target[index] = static_cast<std::uint8_t>(
        (target[index] + scale * source[index]) % kPrime);
  }
}

std::vector<std::array<int, kMinorSize>> combinations(int size) {
  std::vector<std::array<int, kMinorSize>> output;
  std::array<int, kMinorSize> choice{};
  auto visit = [&](auto&& self, int start, int depth) -> void {
    if (depth == kMinorSize) {
      output.push_back(choice);
      return;
    }
    for (int value = start; value <= size - (kMinorSize - depth); ++value) {
      choice[depth] = value;
      self(self, value + 1, depth + 1);
    }
  };
  visit(visit, 0, 0);
  return output;
}

Polynomial determinant(
    const std::array<int, kMinorSize>& rows,
    const std::array<int, kMinorSize>& columns,
    const std::array<std::array<LinearForm, kColumns>, kRows>& matrix,
    const MonomialTables& tables) {
  std::array<Polynomial, 1 << kMinorSize> states;
  states[0] = Polynomial(1, 1);
  for (int row_index = 0; row_index < kMinorSize; ++row_index) {
    std::array<Polynomial, 1 << kMinorSize> next;
    for (int mask = 0; mask < (1 << kMinorSize); ++mask) {
      if (__builtin_popcount(static_cast<unsigned>(mask)) != row_index ||
          states[mask].empty()) {
        continue;
      }
      for (int column_index = 0; column_index < kMinorSize; ++column_index) {
        if ((mask >> column_index) & 1) {
          continue;
        }
        Polynomial product =
            multiply_linear(states[mask], row_index,
                            matrix[rows[row_index]][columns[column_index]],
                            tables);
        const int greater =
            __builtin_popcount(static_cast<unsigned>(
                mask & ~((1 << (column_index + 1)) - 1)));
        const int target_mask = mask | (1 << column_index);
        if (next[target_mask].empty()) {
          next[target_mask] =
              Polynomial(tables.exponents[row_index + 1].size(), 0);
        }
        add_scaled(next[target_mask], product, greater % 2 == 0 ? 1 : -1);
      }
    }
    states = std::move(next);
  }
  return states[(1 << kMinorSize) - 1];
}

int first_nonzero(const Polynomial& polynomial) {
  for (int index = 0; index < static_cast<int>(polynomial.size()); ++index) {
    if (polynomial[index] != 0) {
      return index;
    }
  }
  return -1;
}

int inverse_mod(int value) {
  value %= kPrime;
  for (int candidate = 1; candidate < kPrime; ++candidate) {
    if (value * candidate % kPrime == 1) {
      return candidate;
    }
  }
  throw std::runtime_error("noninvertible pivot");
}

bool insert_echelon(Polynomial row, std::vector<Polynomial>& pivots,
                    std::vector<int>& pivot_ids, int minor_id) {
  while (true) {
    const int pivot = first_nonzero(row);
    if (pivot < 0) {
      return false;
    }
    if (pivots[pivot].empty()) {
      const int inverse = inverse_mod(row[pivot]);
      for (auto& value : row) {
        value = static_cast<std::uint8_t>(value * inverse % kPrime);
      }
      pivots[pivot] = std::move(row);
      pivot_ids[pivot] = minor_id;
      return true;
    }
    const int scale = kPrime - row[pivot];
    add_scaled(row, pivots[pivot], scale);
  }
}

Polynomial reduce_echelon(Polynomial row,
                          const std::vector<Polynomial>& pivots) {
  for (int column = 0; column < static_cast<int>(row.size()); ++column) {
    if (row[column] != 0 && !pivots[column].empty()) {
      const int scale = kPrime - row[column];
      add_scaled(row, pivots[column], scale);
    }
  }
  return row;
}

std::array<std::array<LinearForm, kColumns>, kRows> read_matrix() {
  std::array<std::array<LinearForm, kColumns>, kRows> matrix{};
  for (int variable = 0; variable < kVariables; ++variable) {
    for (int row = 0; row < kRows; ++row) {
      for (int column = 0; column < kColumns; ++column) {
        int value = 0;
        if (!(std::cin >> value)) {
          throw std::runtime_error("incomplete operator basis");
        }
        value %= kPrime;
        if (value < 0) {
          value += kPrime;
        }
        matrix[row][column][variable] =
            static_cast<std::uint8_t>(value);
      }
    }
  }
  return matrix;
}

}  // namespace

int main(int argc, char** argv) {
  try {
    bool leading_only = false;
    bool degree_six = false;
    bool emit_matrices = false;
    for (int argument = 1; argument < argc; ++argument) {
      const std::string option = argv[argument];
      leading_only = leading_only || option == "--leading";
      degree_six = degree_six || option == "--degree6";
      emit_matrices = emit_matrices || option == "--matrices";
    }
    const auto matrix = read_matrix();
    const MonomialTables tables;
    const auto row_sets = combinations(kRows);
    const auto column_sets = combinations(kColumns);
    std::vector<bool> leading_seen(tables.exponents[kMinorSize].size(), false);
    const int target_degree = degree_six ? 6 : 5;
    const int target_rank =
        static_cast<int>(tables.exponents[target_degree].size()) - 6;
    std::vector<Polynomial> pivots(tables.exponents[5].size());
    std::vector<int> pivot_ids(tables.exponents[5].size(), -1);
    int nonzero = 0;
    int rank = 0;
    int minor_id = 0;
    for (int row_id = 0; row_id < static_cast<int>(row_sets.size()); ++row_id) {
      for (int column_id = 0;
           column_id < static_cast<int>(column_sets.size());
           ++column_id, ++minor_id) {
        Polynomial polynomial =
            determinant(row_sets[row_id], column_sets[column_id], matrix, tables);
        const int leading = first_nonzero(polynomial);
        if (leading < 0) {
          continue;
        }
        ++nonzero;
        leading_seen[leading] = true;
        if (!leading_only &&
            insert_echelon(std::move(polynomial), pivots, pivot_ids, minor_id)) {
          ++rank;
          if (!degree_six && rank == target_rank) {
            std::cout << "rank " << rank << "\n";
            std::cout << "processed " << minor_id + 1 << "\n";
            std::cout << "nonzero " << nonzero << "\n";
            std::cout << "pivot_ids";
            for (int pivot_id : pivot_ids) {
              if (pivot_id >= 0) {
                std::cout << ' ' << pivot_id;
              }
            }
            std::cout << "\n";
            return 0;
          }
        }
      }
    }
    if (degree_six) {
      const int quintic_rank = rank;
      std::vector<Polynomial> sextic_pivots(tables.exponents[6].size());
      std::vector<int> sextic_ids(tables.exponents[6].size(), -1);
      rank = 0;
      int quintic_id = 0;
      for (const auto& polynomial : pivots) {
        if (polynomial.empty()) {
          continue;
        }
        for (int variable = 0; variable < kVariables; ++variable) {
          LinearForm coordinate{};
          coordinate[variable] = 1;
          Polynomial product =
              multiply_linear(polynomial, 5, coordinate, tables);
          if (insert_echelon(std::move(product), sextic_pivots, sextic_ids,
                             quintic_id * kVariables + variable)) {
            ++rank;
          }
        }
        ++quintic_id;
      }
      std::cout << "quintic_rank " << quintic_rank << "\n";
      std::cout << "sextic_rank " << rank << "\n";
      std::cout << "sextic_generators " << quintic_id * kVariables << "\n";
      std::vector<int> quintic_standard;
      std::vector<int> sextic_standard;
      for (int column = 0; column < static_cast<int>(pivots.size()); ++column) {
        if (pivots[column].empty()) {
          quintic_standard.push_back(column);
        }
      }
      for (int column = 0; column < static_cast<int>(sextic_pivots.size());
           ++column) {
        if (sextic_pivots[column].empty()) {
          sextic_standard.push_back(column);
        }
      }
      std::cout << "quintic_quotient " << quintic_standard.size() << "\n";
      std::cout << "sextic_quotient " << sextic_standard.size() << "\n";
      std::cout << "coordinate_multiplication_ranks";
      std::vector<std::vector<Polynomial>> multiplication_matrices;
      for (int variable = 0; variable < kVariables; ++variable) {
        std::vector<Polynomial> image_pivots(sextic_standard.size());
        std::vector<int> image_ids(sextic_standard.size(), -1);
        std::vector<Polynomial> multiplication_matrix;
        int image_rank = 0;
        for (int source : quintic_standard) {
          Polynomial monomial(tables.exponents[5].size(), 0);
          monomial[source] = 1;
          LinearForm coordinate{};
          coordinate[variable] = 1;
          Polynomial product =
              multiply_linear(monomial, 5, coordinate, tables);
          Polynomial remainder = reduce_echelon(
              std::move(product), sextic_pivots);
          Polynomial quotient_coordinates(sextic_standard.size(), 0);
          for (int index = 0;
               index < static_cast<int>(sextic_standard.size()); ++index) {
            quotient_coordinates[index] = remainder[sextic_standard[index]];
          }
          multiplication_matrix.push_back(quotient_coordinates);
          if (insert_echelon(std::move(quotient_coordinates), image_pivots,
                             image_ids, source)) {
            ++image_rank;
          }
        }
        multiplication_matrices.push_back(std::move(multiplication_matrix));
        std::cout << ' ' << image_rank;
      }
      std::cout << "\n";
      if (emit_matrices) {
        std::cout << "quintic_standard";
        for (int column : quintic_standard) {
          std::cout << ' ' << column;
        }
        std::cout << "\n";
        std::cout << "sextic_standard";
        for (int column : sextic_standard) {
          std::cout << ' ' << column;
        }
        std::cout << "\n";
        for (int variable = 0; variable < kVariables; ++variable) {
          std::cout << "multiplication_" << variable;
          for (const auto& row : multiplication_matrices[variable]) {
            for (int value : row) {
              std::cout << ' ' << value;
            }
          }
          std::cout << "\n";
        }
      }
      return quintic_rank == 1980 && rank == 4983 ? 0 : 2;
    }
    std::cout << "rank " << rank << "\n";
    std::cout << "processed " << minor_id << "\n";
    std::cout << "nonzero " << nonzero << "\n";
    std::cout << "distinct_leading "
              << std::count(leading_seen.begin(), leading_seen.end(), true)
              << "\n";
  } catch (const std::exception& error) {
    std::cerr << error.what() << "\n";
    return 1;
  }
  return 0;
}
