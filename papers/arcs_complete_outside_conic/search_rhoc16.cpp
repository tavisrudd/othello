// Exact discovery enumerator.  This is not itself a proof object: its output is intended
// to be frozen and consumed by the independent Lean checker.
#include <algorithm>
#include <array>
#include <cstdint>
#include <fstream>
#include <filesystem>
#include <iostream>
#include <set>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

using P = std::array<uint8_t, 3>;

static uint8_t add(uint8_t a, uint8_t b) { return a ^ b; }
static uint8_t mul(uint8_t a, uint8_t b) {
  uint8_t r = 0;
  while (b) {
    if (b & 1) r ^= a;
    b >>= 1;
    a <<= 1;
    if (a & 16) a ^= 0x13;
  }
  return r;
}
static uint8_t inv(uint8_t a) {
  for (uint8_t b = 1; b < 16; ++b) if (mul(a, b) == 1) return b;
  std::abort();
}
static P norm(P p) {
  uint8_t z = p[0] ? p[0] : p[1] ? p[1] : p[2];
  z = inv(z);
  for (auto &x : p) x = mul(z, x);
  return p;
}
static uint16_t code(P p) { return uint16_t(p[0]) << 8 | uint16_t(p[1]) << 4 | p[2]; }
static uint8_t det(P a, P b, P c) {
  // Minus is plus in characteristic two.
  return add(add(mul(a[0], add(mul(b[1], c[2]), mul(b[2], c[1]))),
                 mul(a[1], add(mul(b[0], c[2]), mul(b[2], c[0])))),
             mul(a[2], add(mul(b[0], c[1]), mul(b[1], c[0]))));
}

static std::vector<P> points;
static std::array<int, 4096> point_index;

using M3 = std::array<std::array<uint8_t, 3>, 3>;
static P mv(const M3 &m, P p) {
  P q{};
  for (int i = 0; i < 3; ++i)
    for (int j = 0; j < 3; ++j) q[i] ^= mul(m[i][j], p[j]);
  return q;
}
static M3 inverse(P a, P b, P c) {
  M3 m{{{{a[0],b[0],c[0]}},{{a[1],b[1],c[1]}},{{a[2],b[2],c[2]}}}};
  M3 r{{{{1,0,0}},{{0,1,0}},{{0,0,1}}}};
  for (int col = 0; col < 3; ++col) {
    int pivot = col;
    while (!m[pivot][col]) ++pivot;
    std::swap(m[pivot], m[col]); std::swap(r[pivot], r[col]);
    uint8_t z = inv(m[col][col]);
    for (int j = 0; j < 3; ++j) { m[col][j] = mul(z,m[col][j]); r[col][j] = mul(z,r[col][j]); }
    for (int i = 0; i < 3; ++i) if (i != col && m[i][col]) {
      z = m[i][col];
      for (int j = 0; j < 3; ++j) { m[i][j] ^= mul(z,m[col][j]); r[i][j] ^= mul(z,r[col][j]); }
    }
  }
  return r;
}

using Arc = std::vector<uint16_t>;
struct CanonicalArc { Arc arc; M3 matrix; };
static CanonicalArc canonical(const Arc &a) {
  CanonicalArc best;
  const int n = a.size();
  for (int i = 0; i < n; ++i) for (int j = 0; j < n; ++j) if (j != i)
    for (int k = 0; k < n; ++k) if (k != i && k != j)
      for (int l = 0; l < n; ++l) if (l != i && l != j && l != k) {
        P p0=points[a[i]],p1=points[a[j]],p2=points[a[k]],p3=points[a[l]];
        M3 m=inverse(p0,p1,p2); P q=mv(m,p3);
        for (int row=0;row<3;++row) for(int col=0;col<3;++col) m[row][col]=mul(inv(q[row]),m[row][col]);
        Arc out; out.reserve(n);
        for (auto x:a) out.push_back(point_index[code(norm(mv(m,points[x]))) ]);
        std::sort(out.begin(),out.end());
        if (best.arc.empty() || out < best.arc) best={std::move(out),m};
      }
  return best;
}
static bool legal_add(const Arc&a,int x) {
  for(int i=0;i<(int)a.size();++i) for(int j=0;j<i;++j)
    if(!det(points[a[i]],points[a[j]],points[x])) return false;
  return true;
}
static std::string key(const Arc&a) {
  std::string s; s.resize(2*a.size());
  for(size_t i=0;i<a.size();++i){s[2*i]=char(a[i]&255);s[2*i+1]=char(a[i]>>8);} return s;
}

using V6=std::array<uint8_t,6>;
static V6 mon(P p){return {mul(p[0],p[0]),mul(p[1],p[1]),mul(p[2],p[2]),mul(p[0],p[1]),mul(p[0],p[2]),mul(p[1],p[2])};}
static uint8_t dot6(V6 a,V6 b){uint8_t r=0;for(int i=0;i<6;++i)r^=mul(a[i],b[i]);return r;}
static std::vector<V6> nullspace(std::vector<V6> rows) {
  int r=0; std::array<int,6> piv; piv.fill(-1);
  for(int c=0;c<6 && r<(int)rows.size();++c){int z=r;while(z<(int)rows.size()&&!rows[z][c])++z;if(z==(int)rows.size())continue;
    std::swap(rows[z],rows[r]);uint8_t q=inv(rows[r][c]);for(int j=0;j<6;++j)rows[r][j]=mul(q,rows[r][j]);
    for(int i=0;i<(int)rows.size();++i)if(i!=r&&rows[i][c]){q=rows[i][c];for(int j=0;j<6;++j)rows[i][j]^=mul(q,rows[r][j]);}
    piv[c]=r++;
  }
  std::vector<V6> b;
  for(int f=0;f<6;++f)if(piv[f]<0){V6 v{};v[f]=1;for(int c=0;c<6;++c)if(piv[c]>=0)v[c]=rows[piv[c]][f];b.push_back(v);}
  return b;
}
static bool nonsingular(V6 q){P r{q[5],q[4],q[3]};return (q[3]||q[4]||q[5]) && dot6(q,mon(r));}

static bool relative_conic(const Arc&a, V6 &answer, std::vector<int>&uncovered, int &nullity) {
  std::array<bool,273> covered{}; std::array<bool,273> chosen{};for(auto x:a)chosen[x]=true;
  for(int i=0;i<8;++i)for(int j=0;j<i;++j)for(int x=0;x<273;++x)if(!det(points[a[i]],points[a[j]],points[x]))covered[x]=true;
  std::vector<V6> eqs;for(int x=0;x<273;++x)if(!chosen[x]&&!covered[x]){uncovered.push_back(x);eqs.push_back(mon(points[x]));}
  auto b=nullspace(eqs); nullity=b.size(); if(b.empty())return false;
  uint64_t total=1;for(size_t i=0;i<b.size();++i)total*=16;
  for(uint64_t z=1;z<total;++z){uint64_t w=z;V6 q{};for(auto v:b){uint8_t c=w&15;w>>=4;for(int i=0;i<6;++i)q[i]^=mul(c,v[i]);}
    if(!nonsingular(q))continue;
    bool ok=true;for(auto x:a)if(!dot6(q,mon(points[x]))){ok=false;break;}if(ok){answer=q;return true;}}
  return false;
}

struct MapW { uint16_t source,target; uint8_t scalar; };
struct Transition { uint16_t move; int child; M3 matrix; std::vector<MapW> witnesses; };
struct RejectData { bool forced; std::array<uint16_t,6> points; std::array<uint8_t,6> coeffs; std::array<uint8_t,36> inverse; uint16_t hit; };

static std::array<uint8_t,36> inverse6(const std::array<uint16_t,6>&xs){
  std::array<std::array<uint8_t,12>,6>a{};for(int i=0;i<6;++i){auto v=mon(points[xs[i]]);for(int j=0;j<6;++j)a[i][j]=v[j];a[i][6+i]=1;}
  for(int col=0;col<6;++col){int p=col;while(p<6&&!a[p][col])++p;if(p==6)std::abort();std::swap(a[p],a[col]);uint8_t z=inv(a[col][col]);for(int j=0;j<12;++j)a[col][j]=mul(z,a[col][j]);for(int i=0;i<6;++i)if(i!=col&&a[i][col]){z=a[i][col];for(int j=0;j<12;++j)a[i][j]^=mul(z,a[col][j]);}}
  std::array<uint8_t,36>r{};for(int i=0;i<6;++i)for(int j=0;j<6;++j)r[i*6+j]=a[i][6+j];return r;
}

static std::vector<int> independent_rows(const std::vector<int>&u,int wanted){
  std::vector<std::pair<int,V6>> pivots;std::vector<int> ans;
  for(int x:u){V6 w=mon(points[x]);for(auto&pr:pivots)if(w[pr.first]){uint8_t c=w[pr.first];for(int j=0;j<6;++j)w[j]^=mul(c,pr.second[j]);}
    int p=0;while(p<6&&!w[p])++p;if(p==6)continue;uint8_t z=inv(w[p]);for(auto&v:w)v=mul(z,v);pivots.push_back({p,w});ans.push_back(x);if((int)ans.size()==wanted)break;}
  return ans;
}
static std::array<uint8_t,6> span_coeffs(const std::array<uint16_t,6>&xs,V6 target){
  std::array<std::array<uint8_t,7>,6>a{};for(int eq=0;eq<6;++eq){for(int i=0;i<6;++i)a[eq][i]=mon(points[xs[i]])[eq];a[eq][6]=target[eq];}
  int row=0;std::array<int,6>pivot{};pivot.fill(-1);for(int col=0;col<6&&row<6;++col){int z=row;while(z<6&&!a[z][col])++z;if(z==6)continue;std::swap(a[z],a[row]);uint8_t c=inv(a[row][col]);for(int j=col;j<7;++j)a[row][j]=mul(c,a[row][j]);for(int i=0;i<6;++i)if(i!=row&&a[i][col]){c=a[i][col];for(int j=col;j<7;++j)a[i][j]^=mul(c,a[row][j]);}pivot[col]=row++;}
  std::array<uint8_t,6>out{};for(int col=0;col<6;++col)if(pivot[col]>=0)out[col]=a[pivot[col]][6];return out;
}
static RejectData make_reject(const Arc&a,const std::vector<int>&u,int nullity){
  RejectData r{};if(!nullity){auto b=independent_rows(u,6);if(b.size()!=6)std::abort();for(int i=0;i<6;++i)r.points[i]=b[i];r.inverse=inverse6(r.points);return r;}
  r.forced=true;auto b=independent_rows(u,5);if(b.size()!=5)std::abort();for(int i=0;i<5;++i)r.points[i]=b[i];r.points[5]=b[0];auto ns=nullspace([&]{std::vector<V6>z;for(int x:u)z.push_back(mon(points[x]));return z;}());
  bool found=false;for(auto x:a)if(!dot6(ns[0],mon(points[x]))){r.hit=x;found=true;break;}if(!found)std::abort();r.coeffs=span_coeffs(r.points,mon(points[r.hit]));return r;
}

static void print_arc(std::ostream &o, const Arc &a) {
  o << "{";
  for (size_t i=0;i<a.size();++i) { if (i) o << ","; o << a[i]; }
  o << "}";
}
static void print_matrix(std::ostream &o, const M3 &m) {
  o << "![";
  for (int i=0;i<3;++i) for (int j=0;j<3;++j) {
    if (i || j) o << ",";
    o << int(m[i][j]);
  }
  o << "]";
}
static void print_transition(std::ostream&o,const Transition&r){
  o << "{ move := " << r.move << ", child := " << r.child << ", matrix := ";print_matrix(o,r.matrix);o << ", witnesses := [";
  for(size_t wi=0;wi<r.witnesses.size();++wi){if(wi)o << ",";const auto&w=r.witnesses[wi];o << "{ source := " << w.source << ", target := " << w.target << ", scalar := " << int(w.scalar) << " }";}o << "] }";
}
static void emit_lean(const std::vector<std::vector<Arc>> &levels,
    const std::vector<std::vector<std::vector<Transition>>> &transitions,
    const std::vector<RejectData>&rejects) {
  const std::string root="../../lean/RelativeConicArcs/";
  std::filesystem::create_directories(root+"Q16CertificateData");
  std::ofstream o(root+"Q16CertificateLevels.lean");
  o << "import RelativeConicArcs.Q16Classification\n\n"
       "namespace RelativeConicArcs.Q16Classification.Q16CertificateData\n\n"
       "set_option maxHeartbeats 20000000\nset_option maxRecDepth 100000\n\n";
  for (int n=4;n<=8;++n) {
    o << "noncomputable def level" << n << " : List (Finset Idx) := [\n";
    for (const auto &a:levels[n-4]) { o << "  "; print_arc(o,a); o << ",\n"; }
    o << "]\n\n";
  }
  o << "end RelativeConicArcs.Q16Classification.Q16CertificateData\n";
  o.close();

  std::filesystem::remove_all(root+"Q16CertificateData");
  std::filesystem::remove_all(root+"Q16CertificateRows");
  std::filesystem::create_directories(root+"Q16CertificateData");
  std::filesystem::create_directories(root+"Q16CertificateRows");
  constexpr size_t book_chunk_size=2;
  constexpr size_t row_chunk_size=48;
  std::vector<std::vector<std::string>> modules(4);
  for(int n=4;n<8;++n) for(size_t lo=0;lo<levels[n-4].size();lo+=book_chunk_size) {
    size_t hi=std::min(levels[n-4].size(),lo+book_chunk_size);
    char name[32];std::snprintf(name,sizeof(name),"L%d_%03zu",n,lo/book_chunk_size);
    modules[n-4].push_back(name);
    std::vector<std::vector<std::string>> rowmods(hi-lo);
    for(size_t i=lo;i<hi;++i) for(size_t rlo=0;rlo<transitions[n-4][i].size();rlo+=row_chunk_size){
      size_t rhi=std::min(transitions[n-4][i].size(),rlo+row_chunk_size);
      char rn[48];std::snprintf(rn,sizeof(rn),"R%d_%04zu_%03zu",n,i,rlo/row_chunk_size);
      rowmods[i-lo].push_back(rn);
      std::ofstream rfile(root+"Q16CertificateRows/"+rn+".lean");
      rfile << "import RelativeConicArcs.Q16CertificateLevels\n\n"
         "namespace RelativeConicArcs.Q16Classification.Q16CertificateData\n\n"
         "set_option maxHeartbeats 20000000\nset_option maxRecDepth 100000\n\n"
        ;
      for(size_t ri=rlo;ri<rhi;++ri){rfile << "noncomputable def row" << rn << "_" << ri-rlo << " : ExtensionRow := ";print_transition(rfile,transitions[n-4][i][ri]);rfile << "\n"
        << "theorem row" << rn << "_" << ri-rlo << "_valid : (row" << rn << "_" << ri-rlo << ").ValidFor level" << n+1 << " ";print_arc(rfile,levels[n-4][i]);rfile << " := by decide\n\n";}
      rfile << "noncomputable def rows" << rn << " : List ExtensionRow := [";for(size_t ri=rlo;ri<rhi;++ri){if(ri>rlo)rfile << ",";rfile << "row" << rn << "_" << ri-rlo;}rfile << "]\n\n"
        << "theorem rows" << rn << "_valid : RowListValid level" << n+1 << " ";print_arc(rfile,levels[n-4][i]);rfile << " rows" << rn << " := by\n"
           "  intro r hr\n  simp only [rows" << rn << ", List.mem_cons, List.not_mem_nil, or_false] at hr\n  rcases hr with ";
      for(size_t ri=rlo;ri<rhi;++ri){if(ri>rlo)rfile << " | ";rfile << "rfl";}rfile << "\n";
      for(size_t ri=rlo;ri<rhi;++ri)rfile << "  \u00b7 exact row" << rn << "_" << ri-rlo << "_valid\n";
      rfile << "\nend RelativeConicArcs.Q16Classification.Q16CertificateData\n";
    }
    std::ofstream c(root+"Q16CertificateData/"+name+".lean");
    c << "import RelativeConicArcs.Q16CertificateLevels\n";
    for(auto&rms:rowmods)for(auto&rm:rms)c << "import RelativeConicArcs.Q16CertificateRows." << rm << "\n";
    c << "\nnamespace RelativeConicArcs.Q16Classification.Q16CertificateData\n\nset_option maxHeartbeats 20000000\nset_option maxRecDepth 100000\n\n";
    for(size_t i=lo;i<hi;++i){std::string p=std::string(name)+"_P"+std::to_string(i-lo);
      c << "noncomputable def parent" << p << " : Finset Idx := ";print_arc(c,levels[n-4][i]);c << "\n\nnoncomputable def rows" << p << " : List ExtensionRow :=\n  ";
      for(size_t k=0;k<rowmods[i-lo].size();++k){if(k)c << " ++\n  ";c << "rows" << rowmods[i-lo][k];}c << "\n\ntheorem rows" << p << "_valid : RowListValid level" << n+1 << " parent" << p << " rows" << p << " := by\n  dsimp [rows" << p << ", parent" << p << "]\n  ";
      for(size_t k=0;k+1<rowmods[i-lo].size();++k)c << "apply RowListValid.append rows" << rowmods[i-lo][k] << "_valid\n  ";
      c << "exact rows" << rowmods[i-lo].back() << "_valid\n\nnoncomputable def book" << p << " : NodeBook := { parent := parent" << p << ", rows := rows" << p << " }\n\ntheorem book" << p << "_valid : (book" << p << ").ValidFor level" << n+1 << " := by\n  constructor\n  \u00b7 exact rows" << p << "_valid\n  \u00b7 decide\n\n";
    }
    c << "noncomputable def books" << name << " : List NodeBook := [";for(size_t i=lo;i<hi;++i){if(i>lo)c << ",";c << "book" << name << "_P" << i-lo;}c << "]\n\n"
      << "theorem books" << name << "_valid : BookListValid level" << n+1 << " books" << name << " := by\n"
         "  intro b hb\n  simp only [books" << name << ", List.mem_cons, List.not_mem_nil, or_false] at hb\n  rcases hb with ";
    for(size_t i=lo;i<hi;++i){if(i>lo)c << " | ";c << "rfl";}c << "\n";
    for(size_t i=lo;i<hi;++i)c << "  \u00b7 exact book" << name << "_P" << i-lo << "_valid\n";
    c << "\n"
         "end RelativeConicArcs.Q16Classification.Q16CertificateData\n";
  }
  std::ofstream a(root+"Q16CertificateData.lean");
  a << "import RelativeConicArcs.Q16CertificateLevels\n";
  for(auto&ms:modules)for(auto&m:ms)a << "import RelativeConicArcs.Q16CertificateData." << m << "\n";
  a << "\nnamespace RelativeConicArcs.Q16Classification.Q16CertificateData\n\n"
       "set_option maxHeartbeats 20000000\nset_option maxRecDepth 100000\n\n";
  for(int n=4;n<8;++n) {
    a << "noncomputable def books" << n << " : List NodeBook :=\n  ";
    for(size_t i=0;i<modules[n-4].size();++i){if(i)a << " ++\n  ";a << "books" << modules[n-4][i];}a << "\n\n";
    a << "theorem books" << n << "_valid : BooksValid level" << n << " level" << n+1 << " books" << n << " := by\n"
         "  constructor\n  \u00b7 decide\n  \u00b7 dsimp [books" << n << "]\n    ";
    for(size_t i=0;i+1<modules[n-4].size();++i)a << "apply BookListValid.append books" << modules[n-4][i] << "_valid\n    ";
    a << "exact books" << modules[n-4].back() << "_valid\n\n";
  }
  a << "end RelativeConicArcs.Q16Classification.Q16CertificateData\n";
  a.close();

  std::filesystem::remove_all(root+"Q16LeafData");
  std::filesystem::create_directories(root+"Q16LeafData");
  constexpr size_t leaf_chunk_size=8;
  std::vector<std::string> leafmods;
  for(size_t lo=0;lo<rejects.size();lo+=leaf_chunk_size){size_t hi=std::min(rejects.size(),lo+leaf_chunk_size);char ln[32];std::snprintf(ln,sizeof(ln),"L_%03zu",lo/leaf_chunk_size);leafmods.push_back(ln);std::ofstream l(root+"Q16LeafData/"+ln+".lean");
    l << "import RelativeConicArcs.Q16CertificateLevels\n\nnamespace RelativeConicArcs.Q16Classification.Q16CertificateData\n\nset_option maxHeartbeats 20000000\nset_option maxRecDepth 100000\n\n";
    for(size_t i=lo;i<hi;++i){const auto&r=rejects[i];l << "noncomputable def leaf" << ln << "_" << i-lo << " : RejectedLeaf := { leaf := ";print_arc(l,levels[4][i]);l << ", reject := ." << (r.forced?"forcedHit":"fullRank") << " { members := ![";for(int j=0;j<8;++j){if(j)l<<",";l<<levels[4][i][j];}l << "], points := ![";for(int j=0;j<6;++j){if(j)l<<",";l<<r.points[j];}if(r.forced){l << "], coeffs := ![";for(int j=0;j<6;++j){if(j)l<<",";l<<int(r.coeffs[j]);}l << "], hit := " << r.hit << " } }\n";}else{l << "], inverse := ![";for(int j=0;j<36;++j){if(j)l<<",";l<<int(r.inverse[j]);}l << "] } }\n";}
      l << "theorem leaf" << ln << "_" << i-lo << "_valid : (leaf" << ln << "_" << i-lo << ").reject.ValidFor (leaf" << ln << "_" << i-lo << ").leaf := by decide\n\n";}
    l << "noncomputable def leaves" << ln << " : List RejectedLeaf := [";for(size_t i=lo;i<hi;++i){if(i>lo)l<<",";l<<"leaf"<<ln<<"_"<<i-lo;}l << "]\n\ntheorem leaves" << ln << "_valid : LeafListValid leaves" << ln << " := by\n  intro x hx\n  simp only [leaves" << ln << ", List.mem_cons, List.not_mem_nil, or_false] at hx\n  rcases hx with ";for(size_t i=lo;i<hi;++i){if(i>lo)l<<" | ";l<<"rfl";}l<<"\n";for(size_t i=lo;i<hi;++i)l<<"  \u00b7 exact leaf"<<ln<<"_"<<i-lo<<"_valid\n";l<<"\nend RelativeConicArcs.Q16Classification.Q16CertificateData\n";
  }
  std::ofstream la(root+"Q16LeafData.lean");for(auto&m:leafmods)la<<"import RelativeConicArcs.Q16LeafData."<<m<<"\n";la<<"\nnamespace RelativeConicArcs.Q16Classification.Q16CertificateData\n\nset_option maxHeartbeats 20000000\nset_option maxRecDepth 100000\n\nnoncomputable def rejectedLeaves : List RejectedLeaf :=\n  ";for(size_t i=0;i<leafmods.size();++i){if(i)la<<" ++\n  ";la<<"leaves"<<leafmods[i];}la<<"\n\ntheorem rejectedLeaves_valid : RejectsLevel level8 rejectedLeaves := by\n  constructor\n  \u00b7 decide\n  \u00b7 dsimp [rejectedLeaves]\n    ";for(size_t i=0;i+1<leafmods.size();++i)la<<"apply LeafListValid.append leaves"<<leafmods[i]<<"_valid\n    ";la<<"exact leaves"<<leafmods.back()<<"_valid\n\nend RelativeConicArcs.Q16Classification.Q16CertificateData\n";
}

// Compose the checked transition rows without materializing one large list of their full
// matrix/witness payloads. Each StepBook dispatches a legal move directly to its row theorem.
static void emit_step_data(const std::vector<std::vector<Arc>> &levels,
    const std::vector<std::vector<std::vector<Transition>>> &transitions) {
  const std::string root="../../lean/RelativeConicArcs/";
  constexpr size_t book_chunk_size=2;
  constexpr size_t row_chunk_size=48;
  std::filesystem::remove_all(root+"Q16CertificateData");
  std::filesystem::create_directories(root+"Q16CertificateData");
  std::vector<std::vector<std::string>> modules(4);
  for(int n=4;n<8;++n) for(size_t lo=0;lo<levels[n-4].size();lo+=book_chunk_size) {
    size_t hi=std::min(levels[n-4].size(),lo+book_chunk_size);
    char name[32];std::snprintf(name,sizeof(name),"L%d_%03zu",n,lo/book_chunk_size);
    modules[n-4].push_back(name);
    std::vector<std::vector<std::string>> rowmods(hi-lo);
    for(size_t i=lo;i<hi;++i)
      for(size_t rlo=0;rlo<transitions[n-4][i].size();rlo+=row_chunk_size) {
        char rn[48];std::snprintf(rn,sizeof(rn),"R%d_%04zu_%03zu",n,i,rlo/row_chunk_size);
        rowmods[i-lo].push_back(rn);
      }
    std::ofstream c(root+"Q16CertificateData/"+name+".lean");
    c << "import RelativeConicArcs.Q16StepKernel\n";
    for(auto&rms:rowmods)for(auto&rm:rms)
      c << "import RelativeConicArcs.Q16CertificateRows." << rm << "\n";
    c << "\nnamespace RelativeConicArcs.Q16Classification.Q16CertificateData\n\n"
         "set_option maxHeartbeats 20000000\nset_option maxRecDepth 100000\n\n";
    for(size_t i=lo;i<hi;++i) {
      std::string p=std::string(name)+"_P"+std::to_string(i-lo);
      c << "noncomputable def parent" << p << " : Finset Idx := ";
      print_arc(c,levels[n-4][i]);
      c << "\n\ndef members" << p << " : Fin " << n << " → Idx := ![";
      for(size_t mi=0;mi<levels[n-4][i].size();++mi) {
        if(mi)c << ",";
        c << levels[n-4][i][mi];
      }
      c << "]\n\n";
      for(size_t ri=0;ri<transitions[n-4][i].size();++ri) {
        size_t rlo=(ri/row_chunk_size)*row_chunk_size;
        char rn[48];std::snprintf(rn,sizeof(rn),"R%d_%04zu_%03zu",n,i,rlo/row_chunk_size);
        c << "noncomputable def entry" << p << "_" << ri <<
          " : StepEntry level" << n+1 << " parent" << p << " :=\n"
          "  { move := " << transitions[n-4][i][ri].move << ", step := "
          "(row" << rn << "_" << ri-rlo << "_valid).toStep }\n\n";
      }
      c << "noncomputable def entries" << p << " : List (StepEntry level" << n+1
        << " parent" << p << ") := [";
      for(size_t ri=0;ri<transitions[n-4][i].size();++ri) {
        if(ri)c << ",";
        c << "entry" << p << "_" << ri;
      }
      c << "]\n\nnoncomputable def book" << p << " : StepBook level" << n+1 << " where\n"
           "  parent := parent" << p << "\n"
           "  entries := entries" << p << "\n"
           "  coverage := by\n"
           "    intro x hx hraw\n"
           "    have hfast : FastRawExtensionBy members" << p << " x :=\n"
           "      fastRawExtensionBy_of_rawExtension (members := members" << p << ")\n"
           "        (parent := parent" << p << ") (by decide) (by decide) hraw\n"
           "    have hcoverage : ∀ y, FastRawExtensionBy members" << p << " y →\n"
           "        y ∈ entries" << p << ".map StepEntry.move := by decide\n"
           "    exact hcoverage x hfast\n\n";
    }
    c << "noncomputable def books" << name << " : List (StepBook level" << n+1 << ") := [";
    for(size_t i=lo;i<hi;++i) {
      if(i>lo)c << ",";
      c << "book" << name << "_P" << i-lo;
    }
    c << "]\n\nend RelativeConicArcs.Q16Classification.Q16CertificateData\n";
  }
  std::ofstream a(root+"Q16CertificateData.lean");
  a << "import RelativeConicArcs.Q16StepKernel\n";
  for(auto&ms:modules)for(auto&m:ms)
    a << "import RelativeConicArcs.Q16CertificateData." << m << "\n";
  a << "\nnamespace RelativeConicArcs.Q16Classification.Q16CertificateData\n\n"
       "set_option maxHeartbeats 20000000\nset_option maxRecDepth 100000\n\n";
  for(int n=4;n<8;++n) {
    a << "noncomputable def books" << n << " : List (StepBook level" << n+1 << ") :=\n  ";
    for(size_t i=0;i<modules[n-4].size();++i) {
      if(i)a << " ++\n  ";
      a << "books" << modules[n-4][i];
    }
    a << "\n\ntheorem books" << n << "_valid : StepBooksValid level" << n
      << " level" << n+1 << " books" << n << " := by\n  rfl\n\n";
  }
  a << "end RelativeConicArcs.Q16Classification.Q16CertificateData\n";
}

int main(int argc,char**argv){point_index.fill(-1);std::set<uint16_t> seen;
  for(int x=0;x<16;++x)for(int y=0;y<16;++y)for(int z=0;z<16;++z)if(x||y||z)seen.insert(code(norm(P{(uint8_t)x,(uint8_t)y,(uint8_t)z})));
  for(auto c:seen){P p{uint8_t(c>>8),uint8_t((c>>4)&15),uint8_t(c&15)};point_index[c]=points.size();points.push_back(p);}std::cerr<<"points "<<points.size()<<"\n";
  Arc frame{uint16_t(point_index[code(P{1,0,0})]),uint16_t(point_index[code(P{0,1,0})]),
    uint16_t(point_index[code(P{0,0,1})]),uint16_t(point_index[code(P{1,1,1})])};
  std::sort(frame.begin(),frame.end());
  std::vector<Arc> cls{canonical(frame).arc};
  std::vector<std::vector<Arc>> levels{cls};
  std::vector<std::vector<std::vector<Transition>>> transitions;
  for(int n=5;n<=8;++n){std::unordered_set<std::string> keys;std::vector<Arc> next;uint64_t extensions=0;
    struct Pending { uint16_t move; std::string child_key; M3 matrix; std::vector<MapW> witnesses; };
    std::vector<std::vector<Pending>> pending(cls.size());
    for(size_t ai=0;ai<cls.size();++ai){auto&a=cls[ai];for(int x=0;x<273;++x)if(!std::binary_search(a.begin(),a.end(),x)&&legal_add(a,x)){++extensions;Arc b=a;b.push_back(x);std::sort(b.begin(),b.end());auto c=canonical(b);auto k=key(c.arc);std::vector<MapW> ws;for(auto s:b){P q=mv(c.matrix,points[s]);uint8_t scalar=q[0]?q[0]:q[1]?q[1]:q[2];ws.push_back({s,(uint16_t)point_index[code(norm(q))],scalar});}pending[ai].push_back({(uint16_t)x,k,c.matrix,std::move(ws)});if(keys.insert(k).second)next.push_back(std::move(c.arc));}}
    std::unordered_map<std::string,int> child_index;for(size_t i=0;i<next.size();++i)child_index[key(next[i])]=i;
    std::vector<std::vector<Transition>> rows(cls.size());
    for(size_t i=0;i<pending.size();++i)for(auto&r:pending[i])rows[i].push_back({r.move,child_index.at(r.child_key),r.matrix,std::move(r.witnesses)});
    transitions.push_back(std::move(rows)); cls=std::move(next);levels.push_back(cls);std::cerr<<"classes "<<n<<" "<<cls.size()<<" extensions "<<extensions<<"\n";
  }
  std::array<int,7> nullities{};std::vector<RejectData> rejects;int tested=0;for(auto&a:cls){V6 q{};std::vector<int> u;int nul=0;if(relative_conic(a,q,u,nul)){std::cout<<"FOUND arc";for(auto x:a){auto p=points[x];std::cout<<" ("<<int(p[0])<<","<<int(p[1])<<","<<int(p[2])<<")";}std::cout<<"\nconic";for(auto c:q)std::cout<<" "<<int(c);std::cout<<"\nuncovered";for(auto x:u){auto p=points[x];std::cout<<" ("<<int(p[0])<<","<<int(p[1])<<","<<int(p[2])<<")";}std::cout<<"\n";return 0;}rejects.push_back(make_reject(a,u,nul));if(nul==1){std::cout<<"NULLITY1 class="<<tested<<" arc";for(auto x:a){auto p=points[x];std::cout<<" ("<<int(p[0])<<","<<int(p[1])<<","<<int(p[2])<<")";}std::cout<<" uncovered";for(auto x:u){auto p=points[x];std::cout<<" ("<<int(p[0])<<","<<int(p[1])<<","<<int(p[2])<<")";}std::cout<<"\n";}++nullities[nul];++tested;}
  std::cout<<"NO_RELATIVE_EIGHT classes="<<tested<<" nullities";for(int i=0;i<7;++i)if(nullities[i])std::cout<<" "<<i<<":"<<nullities[i];std::cout<<"\n";
  if(argc>1 && std::string(argv[1])=="--emit-lean") {
    emit_lean(levels,transitions,rejects);
    emit_step_data(levels,transitions);
  } else if(argc>1 && std::string(argv[1])=="--emit-step-data") {
    emit_step_data(levels,transitions);
  }
}
