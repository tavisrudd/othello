g1 := [
[-1,0,0,-1,-1],
[1,1,1,0,2],
[0,0,-1,-1,-1],
[0,0,0,0,1],
[0,0,0,1,0]
];;
g2 := [
[0,-1,-1,0,-1],
[-1,0,-1,0,-1],
[0,0,0,0,1],
[0,0,-1,-1,-1],
[0,0,1,0,0]
];;

i1 := [[1,0],[-1,-1]];;
i2 := [[0,1],[1,0]];;
j1 := [[1,-1],[0,-1]];;
j2 := [[0,1],[1,0]];;

BlockDiagonal := function(blocks)
  local total, result, offset, block, i, j;
  total := Sum(List(blocks, Length));
  result := NullMat(total,total);
  offset := 0;
  for block in blocks do
    for i in [1..Length(block)] do
      for j in [1..Length(block)] do
        result[offset+i][offset+j] := block[i][j];
      od;
    od;
    offset := offset + Length(block);
  od;
  return result;
end;;

one := [[1]];;
minus := [[-1]];;
# The two displayed involutions have S3 sign (-1,-1).  Their product has
# order six, so choose central sign (+1,-1); the other choice merely swaps
# the final two rank-one factors.
target1 := function(a,b)
  return Group([
    BlockDiagonal([minus,a[1],b[1],one,minus]),
    BlockDiagonal([minus,a[2],b[2],minus,one])
  ]);
end;;

for sourceDual in [false,true] do
  if sourceDual then
    n1 := TransposedMat(Inverse(g1));
    n2 := TransposedMat(Inverse(g2));
  else
    n1 := g1;
    n2 := g2;
  fi;
  for sourceName in ["I","J"] do
    if sourceName="I" then a := [i1,i2]; else a := [j1,j2]; fi;
    source := Group([
      BlockDiagonal([n1,a[1]]),
      BlockDiagonal([n2,a[2]])
    ]);
    for leftName in ["I","J"] do
      if leftName="I" then left := [i1,i2]; else left := [j1,j2]; fi;
      for rightName in ["I","J"] do
        if rightName="I" then right := [i1,i2]; else right := [j1,j2]; fi;
        target := target1(left,right);
        c := RepresentativeAction(GL(7,Integers),source,target);
        Print("source-dual=",sourceDual," source=",sourceName,
              " target=",leftName,rightName," equivalent=",c<>fail,"\n");
        if c<>fail then Print("conjugator=",c,"\n"); fi;
      od;
    od;
  od;
od;
QUIT;
