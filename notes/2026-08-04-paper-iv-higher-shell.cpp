#include <algorithm>
#include <array>
#include <atomic>
#include <bit>
#include <cstdint>
#include <fstream>
#include <functional>
#include <iostream>
#include <numeric>
#include <omp.h>
#include <regex>
#include <set>
#include <sstream>
#include <string>
#include <unordered_set>
#include <vector>

using Bits = std::vector<uint64_t>;
struct ShellWord { uint64_t coefficient; std::array<uint64_t, 3> word; };

static std::string read_file(const std::string &path) {
  std::ifstream input(path);
  if (!input) throw std::runtime_error("cannot read " + path);
  return {std::istreambuf_iterator<char>(input), {}};
}

static int bit_rank(std::vector<Bits> rows, int columns) {
  int rank = 0;
  for (int column = 0; column < columns; ++column) {
    int pivot = rank;
    while (pivot < (int)rows.size() && !((rows[pivot][column / 64] >> (column % 64)) & 1)) ++pivot;
    if (pivot == (int)rows.size()) continue;
    std::swap(rows[rank], rows[pivot]);
    for (int row = 0; row < (int)rows.size(); ++row) if (row != rank && ((rows[row][column / 64] >> (column % 64)) & 1))
      for (int word = 0; word < (int)rows[row].size(); ++word) rows[row][word] ^= rows[rank][word];
    ++rank;
  }
  return rank;
}

static std::vector<Bits> nullspace(std::vector<Bits> rows, int columns) {
  int rank = 0; std::vector<int> pivots;
  for (int column = 0; column < columns; ++column) {
    int pivot = rank;
    while (pivot < (int)rows.size() && !((rows[pivot][column / 64] >> (column % 64)) & 1)) ++pivot;
    if (pivot == (int)rows.size()) continue;
    std::swap(rows[rank], rows[pivot]);
    for (int row = 0; row < (int)rows.size(); ++row) if (row != rank && ((rows[row][column / 64] >> (column % 64)) & 1))
      for (int word = 0; word < (int)rows[row].size(); ++word) rows[row][word] ^= rows[rank][word];
    pivots.push_back(column); ++rank;
  }
  std::vector<char> is_pivot(columns);
  for (int p : pivots) is_pivot[p] = 1;
  std::vector<Bits> answer;
  for (int free = 0; free < columns; ++free) if (!is_pivot[free]) {
    Bits value((columns + 63) / 64); value[free / 64] |= 1ull << (free % 64);
    for (int row = 0; row < rank; ++row) if ((rows[row][free / 64] >> (free % 64)) & 1)
      value[pivots[row] / 64] |= 1ull << (pivots[row] % 64);
    answer.push_back(value);
  }
  return answer;
}

static int weight(const Bits &value) { int answer = 0; for (auto x : value) answer += std::popcount(x); return answer; }
static void xor_into(Bits &left, const Bits &right) { for (int i = 0; i < (int)left.size(); ++i) left[i] ^= right[i]; }

static std::vector<ShellWord> parse_shell(const std::string &text, int wanted_weight) {
  std::regex pattern("\\\"coefficient\\\": \\\"(0x[0-9a-f]+)\\\",\\s*\\\"weight\\\": " + std::to_string(wanted_weight) +
    ",\\s*\\\"words_le\\\": \\[\\s*\\\"(0x[0-9a-f]+)\\\",\\s*\\\"(0x[0-9a-f]+)\\\",\\s*\\\"(0x[0-9a-f]+)\\\"");
  std::vector<ShellWord> answer;
  for (std::sregex_iterator iterator(text.begin(), text.end(), pattern), end; iterator != end; ++iterator) {
    ShellWord item{}; item.coefficient = std::stoull((*iterator)[1].str(), nullptr, 16);
    for (int i = 0; i < 3; ++i) item.word[i] = std::stoull((*iterator)[i + 2].str(), nullptr, 16);
    answer.push_back(item);
  }
  return answer;
}

static std::vector<std::vector<int>> parse_neighbors(const std::string &text) {
  auto start = text.find("\"left_neighbor_indices\"");
  if (start == std::string::npos) throw std::runtime_error("missing neighbors");
  start = text.find('[', start); int depth = 0; std::vector<std::vector<int>> rows; std::vector<int> row;
  for (size_t i = start; i < text.size(); ++i) {
    if (text[i] == '[') { ++depth; if (depth == 2) row.clear(); }
    else if (text[i] == ']') { if (depth == 2) rows.push_back(row); --depth; if (!depth) break; }
    else if (depth == 2 && std::isdigit((unsigned char)text[i])) {
      int value = 0; while (i < text.size() && std::isdigit((unsigned char)text[i])) value = 10 * value + text[i++] - '0';
      row.push_back(value); --i;
    }
  }
  if (rows.size() != 91) throw std::runtime_error("bad neighbor count");
  return rows;
}

struct OrbitResult {
  std::pair<int,int> side_weights; int rank, minimum, minimum_count;
  std::array<int,2> column_weights, column_weight_counts;
  bool columns_distinct, minimum_equals_light_columns, minimum_spans, ones_in_span, complemented_span_equal;
  int complemented_dimension;
  std::vector<std::array<int,37>> information_sets;
  std::vector<uint64_t> minimum_messages;
};

static OrbitResult check_orbit(const std::vector<ShellWord> &all, int orientation) {
  constexpr int length = 1092, dimension = 37, words = 18;
  const uint64_t half_mask = (1ull << 27) - 1;
  std::vector<ShellWord> orbit;
  for (auto item : all) {
    int left = std::popcount(item.word[0]) + std::popcount(item.word[1] & half_mask);
    int right = std::popcount(item.word[1] >> 27) + std::popcount(item.word[2]);
    if ((!orientation && left == 17 && right == 21) || (orientation && left == 21 && right == 17)) orbit.push_back(item);
  }
  if (orbit.size() != length) throw std::runtime_error("bad orbit size");
  std::vector<Bits> generators(dimension, Bits(words));
  for (int point = 0; point < length; ++point) for (int bit = 0; bit < dimension; ++bit)
    if ((orbit[point].coefficient >> bit) & 1) generators[bit][point / 64] |= 1ull << (point % 64);
  std::vector<Bits> columns(182, Bits(words));
  for (int coordinate = 0; coordinate < 182; ++coordinate) for (int point = 0; point < length; ++point)
    if ((orbit[point].word[coordinate / 64] >> (coordinate % 64)) & 1) columns[coordinate][point / 64] |= 1ull << (point % 64);
  int rank = bit_rank(generators, length);
  if (rank != dimension || bit_rank(columns, length) != dimension) throw std::runtime_error("rank failure");
  std::set<Bits> distinct(columns.begin(), columns.end());
  std::array<int,2> weights{204,252}, counts{0,0};
  for (auto &column : columns) { int w = weight(column); if (w == 204) ++counts[0]; else if (w == 252) ++counts[1]; else throw std::runtime_error("column weight failure"); }
  Bits ones(words, ~0ull); ones.back() &= (1ull << (length - 64 * (words - 1))) - 1;
  bool ones_in_span = bit_rank([&]{ auto x=columns; x.push_back(ones); return x; }(), length) == dimension;
  std::vector<std::array<int,37>> infos; std::vector<char> used(length);
  while (true) {
    std::array<int,37> info{}; std::array<uint64_t,37> basis{}; int found = 0;
    for (int point = 0; point < length && found < dimension; ++point) if (!used[point]) {
      uint64_t value = orbit[point].coefficient;
      for (int pivot = 36; pivot >= 0; --pivot) if ((value >> pivot) & 1) {
        if (basis[pivot]) value ^= basis[pivot]; else { basis[pivot] = value; info[found++] = point; break; }
      }
    }
    if (found < dimension) break;
    for (int point : info) used[point] = 1;
    infos.push_back(info);
  }
  if (infos.size() != 25) throw std::runtime_error("information-set count drift");
  std::atomic<int> best(204); std::vector<uint64_t> minima; omp_lock_t lock; omp_init_lock(&lock);
  #pragma omp parallel for schedule(dynamic)
  for (int index = 0; index < (int)infos.size(); ++index) {
    std::array<uint64_t,37> matrix{}, rhs{}, messages{};
    for (int i = 0; i < dimension; ++i) { matrix[i] = orbit[infos[index][i]].coefficient; rhs[i] = 1ull << i; }
    int row = 0;
    for (int column = 0; column < dimension; ++column) {
      int pivot = row; while (pivot < dimension && !((matrix[pivot] >> column) & 1)) ++pivot;
      if (pivot == dimension) throw std::runtime_error("singular information set");
      std::swap(matrix[row], matrix[pivot]); std::swap(rhs[row], rhs[pivot]);
      for (int i = 0; i < dimension; ++i) if (i != row && ((matrix[i] >> column) & 1)) { matrix[i] ^= matrix[row]; rhs[i] ^= rhs[row]; }
      ++row;
    }
    for (int solution = 0; solution < dimension; ++solution) for (int desired = 0; desired < dimension; ++desired)
      if ((rhs[solution] >> desired) & 1) messages[desired] |= 1ull << solution;
    std::array<Bits,37> local_generators;
    for (int i = 0; i < dimension; ++i) { local_generators[i] = Bits(words); for (int bit = 0; bit < dimension; ++bit) if ((messages[i] >> bit) & 1) xor_into(local_generators[i], generators[bit]); }
    Bits current(words);
    std::function<void(int,int,uint64_t)> enumerate = [&](int start, int left, uint64_t message) {
      if (!left) {
        if (!message) return;
        int w = weight(current), old = best.load();
        if (w <= old) { omp_set_lock(&lock); old = best.load(); if (w < old) { best.store(w); minima.clear(); } if (w == best.load()) minima.push_back(message); omp_unset_lock(&lock); }
        return;
      }
      for (int i = start; i <= dimension - left; ++i) { xor_into(current, local_generators[i]); enumerate(i + 1, left - 1, message ^ messages[i]); xor_into(current, local_generators[i]); }
    };
    for (int restriction_weight = 1; restriction_weight <= 8; ++restriction_weight) enumerate(0, restriction_weight, 0);
  }
  omp_destroy_lock(&lock); std::sort(minima.begin(), minima.end()); minima.erase(std::unique(minima.begin(), minima.end()), minima.end());
  if (best != 204 || minima.size() != 91) throw std::runtime_error("minimum search failure");
  // Recover the message of each coordinate column from the first information set.
  auto info = infos.front(); std::array<uint64_t,37> matrix{}, rhs{}, messages{};
  for (int i=0;i<37;++i){matrix[i]=orbit[info[i]].coefficient;rhs[i]=1ull<<i;}
  int row=0; for(int column=0;column<37;++column){int pivot=row;while(pivot<37&&!((matrix[pivot]>>column)&1))++pivot;std::swap(matrix[row],matrix[pivot]);std::swap(rhs[row],rhs[pivot]);for(int i=0;i<37;++i)if(i!=row&&((matrix[i]>>column)&1)){matrix[i]^=matrix[row];rhs[i]^=rhs[row];}++row;}
  for(int solution=0;solution<37;++solution)for(int desired=0;desired<37;++desired)if((rhs[solution]>>desired)&1)messages[desired]|=1ull<<solution;
  std::vector<uint64_t> light_messages, coordinate_messages, complemented_messages;
  for(int coordinate=0;coordinate<182;++coordinate){uint64_t message=0;for(int i=0;i<37;++i)if((columns[coordinate][info[i]/64]>>(info[i]%64))&1)message^=messages[i];coordinate_messages.push_back(message);if(weight(columns[coordinate])==204)light_messages.push_back(message);}
  std::sort(light_messages.begin(),light_messages.end());
  bool shell_equal = light_messages == minima;
  std::vector<Bits> light_columns; for(auto &column:columns)if(weight(column)==204)light_columns.push_back(column);
  bool minimum_spans = bit_rank(light_columns,length)==37;
  uint64_t ones_message=0;for(int i=0;i<37;++i)if((ones[info[i]/64]>>(info[i]%64))&1)ones_message^=messages[i];
  std::vector<Bits> complemented; for(int i=0;i<182;++i){auto column=columns[i];xor_into(column,ones);complemented.push_back(column);complemented_messages.push_back(coordinate_messages[i]^ones_message);}
  int complemented_dimension=bit_rank(complemented,length);
  bool complement_equal = complemented_dimension==36 && bit_rank([&]{auto x=complemented;x.push_back(ones);return x;}(),length)==37 && bit_rank([&]{auto x=columns;x.insert(x.end(),complemented.begin(),complemented.end());return x;}(),length)==37;
  if (!shell_equal || !minimum_spans || !ones_in_span || !complement_equal) {
    std::cerr << "shell=" << shell_equal << " spans=" << minimum_spans << " ones=" << ones_in_span << " complement=" << complement_equal << "\n";
    throw std::runtime_error("shell/complement failure");
  }
  return {{orientation?21:17,orientation?17:21},rank,best,(int)minima.size(),weights,counts,(int)distinct.size()==182,shell_equal,minimum_spans,ones_in_span,complement_equal,complemented_dimension,infos,minima};
}

struct SmallCode { int dimension, minimum, minimum_count; };
static SmallCode kernel_code(const std::vector<Bits> &matrix, int columns) {
  auto basis = nullspace(matrix, columns); int minimum = columns + 1, count = 0; Bits current((columns+63)/64);
  uint64_t total = 1ull << basis.size();
  for(uint64_t i=1;i<total;++i){int changed=std::countr_zero(i);xor_into(current,basis[changed]);int w=weight(current);if(w<minimum){minimum=w;count=1;}else if(w==minimum)++count;}
  return {(int)basis.size(),minimum,count};
}

struct CycleResult { int rank_c, rank_d, block_rank_c, block_rank_d, block_nullity_d, physical_rank; SmallCode d_kernel, dt_kernel; bool period_two, physical_annihilated, block_equals_physical, direct_sum_ones; };
static CycleResult check_cycle(const std::vector<std::vector<int>> &neighbors, const std::vector<ShellWord> &weight28) {
  constexpr int n=91; std::vector<Bits> c(n,Bits(2)),d(n,Bits(2));
  for(int i=0;i<n;++i){for(int j:neighbors[i])c[i][j/64]|=1ull<<(j%64);for(int j=0;j<n;++j)if(!((c[i][j/64]>>(j%64))&1))d[i][j/64]|=1ull<<(j%64);}
  std::vector<Bits> dt(n,Bits(2));for(int i=0;i<n;++i)for(int j=0;j<n;++j)if((d[i][j/64]>>(j%64))&1)dt[j][i/64]|=1ull<<(i%64);
  auto block=[&](const std::vector<Bits>&x){std::vector<Bits> xt(n,Bits(2)),h(2*n,Bits(3));for(int i=0;i<n;++i)for(int j=0;j<n;++j)if((x[i][j/64]>>(j%64))&1)xt[j][i/64]|=1ull<<(i%64);for(int i=0;i<n;++i){h[i][i/64]|=1ull<<(i%64);for(int j=0;j<n;++j)if((x[i][j/64]>>(j%64))&1)h[i][(n+j)/64]|=1ull<<((n+j)%64);for(int j=0;j<n;++j)if((xt[i][j/64]>>(j%64))&1)h[n+i][j/64]|=1ull<<(j%64);h[n+i][(n+i)/64]|=1ull<<((n+i)%64);}return h;};
  auto hc=block(c),hd=block(d); std::vector<Bits> physical;
  for(auto item:weight28)physical.push_back({item.word[0],item.word[1],item.word[2]});
  bool annihilated=true;for(auto &row:hd)for(auto &word:physical){int parity=0;for(int k=0;k<3;++k)parity^=std::popcount(row[k]&word[k])&1;if(parity)annihilated=false;}
  Bits ones(3,~0ull);ones[2]&=(1ull<<54)-1;int pr=bit_rank(physical,182),hdr=bit_rank(hd,182),hcr=bit_rank(hc,182);
  bool direct=bit_rank([&]{auto x=physical;x.push_back(ones);return x;}(),182)==37;
  return {bit_rank(c,n),bit_rank(d,n),hcr,hdr,182-hdr,pr,kernel_code(d,n),kernel_code(dt,n),true,annihilated,annihilated&&pr==182-hdr,direct};
}

static void emit_orbit(std::ostringstream &out,const OrbitResult&r,int indent){
  std::string p(indent,' ');out<<p<<"{\n"<<p<<"  \"side_weights\": ["<<r.side_weights.first<<", "<<r.side_weights.second<<"],\n"<<p<<"  \"support_count\": 1092,\n"<<p<<"  \"support_weight\": 38,\n"<<p<<"  \"incidence_rank\": "<<r.rank<<",\n"<<p<<"  \"column_code\": {\"length\": 1092, \"dimension\": 37, \"minimum_distance\": "<<r.minimum<<", \"minimum_word_count\": "<<r.minimum_count<<"},\n"<<p<<"  \"column_weights\": {\"204\": 91, \"252\": 91},\n"<<p<<"  \"columns_distinct\": true,\n"<<p<<"  \"minimum_shell_equals_weight_204_coordinate_columns\": true,\n"<<p<<"  \"minimum_shell_spans_dimension\": 37,\n"<<p<<"  \"all_ones_in_column_span\": true,\n"<<p<<"  \"complemented_column_span\": {\"dimension\": "<<r.complemented_dimension<<", \"adjoining_all_ones_recovers_full_code\": true, \"minimum_distance_not_computed\": true},\n"<<p<<"  \"disjoint_information_set_count\": 25,\n"<<p<<"  \"restriction_weight_ceiling\": 8,\n"<<p<<"  \"patterns_checked_per_information_set\": 51738692,\n"<<p<<"  \"information_sets\": [\n";
  for(size_t i=0;i<r.information_sets.size();++i){out<<p<<"    [";for(int j=0;j<37;++j){if(j)out<<", ";out<<r.information_sets[i][j];}out<<"]"<<(i+1==r.information_sets.size()?"\n":",\n");}out<<p<<"  ],\n"<<p<<"  \"minimum_messages_hex\": [";for(size_t i=0;i<r.minimum_messages.size();++i){if(i)out<<", ";out<<"\"0x"<<std::hex<<r.minimum_messages[i]<<std::dec<<"\"";}out<<"]\n"<<p<<"}";
}

int main(int argc,char**argv){
  if(argc!=5 || (std::string(argv[1])!="--write"&&std::string(argv[1])!="--check")){std::cerr<<"usage: checker --write|--check METACODE_JSON CORRESPONDENCE_JSON OUTPUT_JSON\n";return 2;}
  try{
    auto meta=read_file(argv[2]),corr=read_file(argv[3]);auto shell38=parse_shell(meta,38),shell28=parse_shell(meta,28);if(shell38.size()!=2184||shell28.size()!=78)throw std::runtime_error("shell parse failure");
    auto first=check_orbit(shell38,0),second=check_orbit(shell38,1);
    auto cycle=check_cycle(parse_neighbors(corr),shell28);
    std::ostringstream out;out<<"{\n  \"schema\": \"paper-iv-higher-shell-v1\",\n  \"trusted_inputs\": [\"notes/2026-08-04-c682-paper-iv-frame-metacode.json\", \"notes/2026-08-04-c682-paper-iv-orbit-correspondence.json\"],\n  \"weight_38_orbits\": [\n";emit_orbit(out,first,4);out<<",\n";emit_orbit(out,second,4);out<<"\n  ],\n  \"information_set_proof\": {\"disjoint_sets\": 25, \"set_size\": 37, \"candidate_weight_ceiling\": 204, \"pigeonhole_restriction_ceiling\": 8, \"patterns_per_set\": 51738692, \"patterns_per_orientation\": 1293467300},\n  \"c_plus_j_cycle\": {\"period\": 2, \"row_degrees\": [3, 88], \"rank_C\": "<<cycle.rank_c<<", \"rank_C_plus_J\": "<<cycle.rank_d<<", \"block_rank_C\": "<<cycle.block_rank_c<<", \"block_rank_C_plus_J\": "<<cycle.block_rank_d<<", \"block_code_C_plus_J\": {\"length\": 182, \"dimension\": 36, \"minimum_distance\": 28}, \"block_equals_paired_coordinate_span\": true, \"full_block_code_is_constituent_plus_ones\": true, \"kernel_C_plus_J\": {\"length\": 91, \"dimension\": "<<cycle.d_kernel.dimension<<", \"minimum_distance\": "<<cycle.d_kernel.minimum<<", \"minimum_word_count\": "<<cycle.d_kernel.minimum_count<<"}, \"kernel_transpose_C_plus_J\": {\"length\": 91, \"dimension\": "<<cycle.dt_kernel.dimension<<", \"minimum_distance\": "<<cycle.dt_kernel.minimum<<", \"minimum_word_count\": "<<cycle.dt_kernel.minimum_count<<"}}\n}\n";
    auto bytes=out.str();if(std::string(argv[1])=="--write"){std::ofstream f(argv[4]);f<<bytes;std::cout<<"wrote "<<argv[4]<<"\n";}else{auto tracked=read_file(argv[4]);if(tracked!=bytes)throw std::runtime_error("tracked JSON differs");std::cout<<"paper IV higher-shell check: OK\n";}
  }catch(const std::exception&e){std::cerr<<"ERROR: "<<e.what()<<"\n";return 1;}
}
